class Player
  attr_reader :name,:color

  def initialize(name,color)
    @name = name
    @color = color
  end
end

class Human < Player
  
end

class Bot < Player
end
