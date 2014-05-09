class Scenario < CDQManagedObject

#	attr_accessor :characters, :id, :name

	def self.setup!
		Dispatch.once do 
			@instance ||= new
		end
		@instance
	end

	def self.instance
		@instance
	end

	def self.loadScenarios(&block)
		grouping 				= NSUserDefaults.standardUserDefaults["grouping_key"]
		url 						= JadeServer.instance.signedURL("/jade/grouping/#{grouping}/scenarios")
		BW::HTTP.get(url) do |result|
			if result.ok? 
				data = BW::JSON.parse(result.body.to_str)
				
				reset
				data['scenarios'].each do |scenario_data|
					persistScenariosToObjectContext(scenario_data, block)
				end

				block.call({:error => false})
			else
				puts result.inspect
				block.call({:error => true})				
			end
		end
	end

	# Refactor away this whole method, it is no longer necessary at all!
	def hydrate(id, &block)
		block.call({:error => false})
	end

	private 

	def self.persistScenariosToObjectContext(data, block)

		scenario = Scenario.create(:id => data['id'], :name => data['name'])

		data['questions'].each do |question_def|
			question = Question.make(question_def)
			scenario.questions << question
		end

		data['parties'].each do |party_def|
			party = Party.make(party_def)
			scenario.parties << party
		end

		Dispatch::Queue.main.async do 
			puts "calling on main"
			block.call({:error => false})
		end
	end


	def self.reset
		Scenario.all.map{|s| s.destroy }
		Character.all.map{|c| c.destroy }
		Question.all.map{|q| q.destroy }
		Player.all.map{|p| p.destroy }
		Party.all.map{|p| p.destroy }
		Alternative.all.map{|a| a.destroy }
		cdq.save
	end


end