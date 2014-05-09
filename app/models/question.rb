class Question < CDQManagedObject

	def self.make(data)
		instance = self.new(:id => data['id'], :name => data['name'], :desc => data['description'])

		data['alternatives'].each do |data|
			alternative = Alternative.new({:id => data['id'], :name => data['name'], :desc => data['description']})
			instance.alternatives << alternative
		end

		instance
	end

end