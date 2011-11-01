class Player
  attr_reader :name
  attr_accessor :score, :turns, :rack
  def initialize(name)
    @name = name
    @rack = Array.new
    @score = 0
  end
end
