
schema "0001 initial" do

  entity "Scenario" do 
    string    :id
    string    :name

    has_many :parties, inverse: "Party.scenario"
    has_many :questions
  end

  entity "Party" do 
    string    :id
    string    :name
    string    :avatar_url
    string    :slogan

    has_many :characters, inverse: "Character.party"
    belongs_to :scenario
    has_many :players, inverse: "Player.party"
    has_many :questions
    has_many :opinions, inverse: "Opinion.party"
  end

  entity "Character" do 
    string    :id
    string    :name
    string    :concept

    belongs_to :party
    belongs_to :player, inverse: "Player.character"
    has_one :question, inverse: "Question.characters"
  end

  entity "Question" do 
    string    :id
    string    :name
    string    :desc

    belongs_to :scenario
    belongs_to :party
    has_many :characters, inverse: "Character.question"
    has_many :players, inverse: "Player.question"
    has_many :alternatives, inverse: "Alternative.question"
  end

  entity "Alternative" do 
    string    :id
    string    :name
    string    :desc

    belongs_to :question, inverse: "Question.alternatives"
    has_many :arguments, inverse: "Argument.alternative"
  end

  entity "Argument" do 
    string    :id
    string    :desc

    belongs_to :alternative, inverse: "Alternative.arguments"
    has_many :opinions, inverse: "Opinion.argument"
  end

  entity "Opinion" do 
    string      :id
    integer16   :points

    belongs_to  :party, inverse: "Party.opinions"
    belongs_to  :argument, inverse: "Argument.opinions"
  end

  entity "Player" do 
    string    :id
    string    :name

    has_one :character, inverse: "Character.player"
    has_one :party, inverse: "Party.players"
    has_one :question, inverse: "Question.players"

    # Add meetings here!
  end

end