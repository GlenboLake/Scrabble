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
turn.add_letter(?R, 7, 6) # DWS
turn.add_letter(?A, 7, 7)
turn.add_letter(?Q, 1, 1)
turn.add_letter(?B, 7, 8)
turn.add_letter(?B, 7, 9)
turn.add_letter(?L, 7, 10) #DLS
turn.add_letter(?E, 7, 11)
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
players.each { |player| puts("#{player.name}: #{player.score}") }

# Second turn: SCRABBLE
turn = Turn.new
turn.add_letter(?S, 7, 4) # DWS
turn.add_letter(?C, 7, 5)

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
players.each { |player| puts("#{player.name}: #{player.score}") }

# Third turn: ROCKS
turn = Turn.new
turn.add_letter(?R, 5, 5)
turn.add_letter(?O, 6, 5)
turn.add_letter(?K, 8, 5)
turn.add_letter(?S, 9, 5)

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
players.each { |player| puts("#{player.name}: #{player.score}") }

puts("Expected 37 to 14")