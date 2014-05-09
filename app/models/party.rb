class Party < CDQManagedObject

	attr_writer :avatarURL

	def self.make(data)

		instance = self.new({
			:id	 			=> data["id"], 
			:name 		=> data['name'], 
			:slogan 	=> data['slogan']})

		instance.avatarURL = data['logo_url']

		data['characters'].each do |char_data|
			character = Character.new(
				:id => char_data['id'], 
				:name => char_data['name'], 
				:concept => char_data['concept'])
			character.party = instance
			instance.characters << character
		end

		instance
	end

	def avatar_url
		return NSURL.URLWithString(@avatarURL)
	end

end