class Player < CDQManagedObject


	def saveToServer(&block)
		if self.name.nil? || self.name.length == 0
			block.call({:error => true, :message => "Name is missing and is required!"})
			return
		end
		file = make_png(self.image) if self.image
		payload = { :payload => {:user => {:name 	=> self.name}, 
								:scenario => JadeServer.instance.identifier				
							}
		}
		if self.image
			payload.merge!(:files => {:avatar => file})
		end
		url = JadeServer.instance.signedURL("/jade/players/register")
		BW::HTTP.post(url, payload) do |result|
			if result.ok? 
				# Later on, we'll receive a specific data-package containing 
				# connection details for this specific iPad here!
				puts "Resp acked!"
				data = BW::JSON.parse(result.body.to_str)
				self.id	= data[:player][:id]
				Dispatch::Queue.concurrent(:high).async do 
					JadeServer.instance.setupPlayerQueue(self.id, self.name)
				end
				@@player = self
				block.call({:error => false})
			elsif result.status_code == 400
				data = BW::JSON.parse(result.body.to_str)
				block.call({:error => true, :message => data[:message]})
			else
				block.call({:error => true, :message => "Something went unexpectely wrong, try again?"})
			end
		end
	end

	def image=(img)
		@image = img
	end

	def self.current
		@@player
	end

	def handleMessage(payload)
		if payload["message"].eql?("character.assignment")
			setup(payload)
			GameState.instance.characterReceived!
		elsif payload["message"].eql?("party_meeting")
			meeting = PartyMeeting.new(payload["data"])
			meeting.start do |m|
				GameState.instance.state = m
				GameState.instance.event(:begin_meeting)
			end
			self.meetings.push(meeting)
		end
	end


	private

	# Just naively convert convert passed image to PNG, 
	# and then return the resulting NSData. 
	# This should probably do some downscaling and rotation later on!
	def make_png(ui_image)
		img = UIImagePNGRepresentation(image)
		return img
	end

	# def setup(payload)
	# 	# Here, switch these to load this stuff from the scenario-definition for the proper scenario!
	# 	puts payload.inspect

	# 	self.party 				= Party.where(:id).eq(payload["party"])
	# 	self.character 		= Character.where(:id).eq(payload["character"])
	# 	self.question 		= Question.where(:id).eq(payload["question"])

	# 	puts self.party.inspect
	# 	puts self.character.inspect
	# 	puts self.question.inspect
	# end

end