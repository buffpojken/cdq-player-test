class Character < CDQManagedObject

	attr_accessor :id, :name, :concept, :party

	def initialize(data)
		self.id 			= data["id"]
		self.name			= data["name"]
		self.concept	= data["concept"]
		self
	end

end