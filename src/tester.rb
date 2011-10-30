# To change this template, choose Tools | Templates
# and open the template in the editor.

$LOAD_PATH << '.'

require 'board'

print ?A.class.name

board = Board.new
board.print

turn = Turn.new
turn.add_letter(?S, 7, 5)
turn.add_letter(?C, 7, 6)
turn.add_letter(?R, 7, 7) # DWS
turn.add_letter(?A, 7, 8)
turn.add_letter(?Q, 1, 1)
turn.add_letter(?B, 7, 9)
turn.add_letter(?B, 7, 10)
turn.add_letter(?L, 7, 11) #DLS
turn.add_letter(?E, 7, 12)
turn.remove_letter(1, 1)

puts(board.play_turn(turn))
board.print

turn = Turn.new
turn.add_letter(?R, 5, 6)
turn.add_letter(?O, 6, 6)
turn.add_letter(?K, 8, 6)
turn.add_letter(?S, 9, 6)

puts(board.play_turn(turn))
board.print

