class Player
  attr_reader :name
  attr_accessor :score, :turns, :rack
  def initialize(name)
    @name = name
    @turns = Array.new
    @rack = Array.new
    @score = 0
  end
end
