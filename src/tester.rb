# To change this template, choose Tools | Templates
# and open the template in the editor.

$LOAD_PATH << '.'

require 'board'
require 'player'

players = Array.new
players[0] = Player.new('Glen')
players[1] = Player.new('Fool')

current_player = 0

board = Board.new

# First turn: RABBLE
turn = Turn.new
turn.add_letter(?R, 7, 7) # DWS
turn.add_letter(?A, 7, 8)
turn.add_letter(?Q, 1, 1)
turn.add_letter(?B, 7, 9)
turn.add_letter(?B, 7, 10)
turn.add_letter(?L, 7, 11) #DLS
turn.add_letter(?E, 7, 12)
turn.remove_letter(1, 1)

# Play the turn
turn_score = board.play_turn(turn)
if (turn_score > 0)
  puts("#{players[current_player].name} scored #{turn_score} points!")
  players[current_player].turns << turn
  players[current_player].score += turn_score
end
board.printout
# Print the scores
current_player = (current_player+1) % players.size
players.each do |player|
  puts("#{player.name}: #{player.score}")
end

# Second turn: SCRABBLE
turn = Turn.new
turn.add_letter(?S, 7, 5) # DWS
turn.add_letter(?C, 7, 6)

# Play the turn
turn_score = board.play_turn(turn)
if (turn_score > 0)
  puts("#{players[current_player].name} scored #{turn_score} points!")
  players[current_player].turns << turn
  players[current_player].score += turn_score
end
board.printout
#Print the scores
current_player = (current_player+1) % players.size
players.each do |player|
  puts("#{player.name}: #{player.score}")
end

# Third turn: ROCKS
turn = Turn.new
turn.add_letter(?R, 5, 6)
turn.add_letter(?O, 6, 6)
turn.add_letter(?K, 8, 6)
turn.add_letter(?S, 9, 6)

# Play the turn
turn_score = board.play_turn(turn)
if (turn_score > 0)
  puts("#{players[current_player].name} scored #{turn_score} points!")
  players[current_player].turns << turn
  players[current_player].score += turn_score
end
board.printout
#Print the scores
current_player = (current_player+1) % players.size
players.each do |player|
  puts("#{player.name}: #{player.score}")
end

puts("Expected 36 to 15")