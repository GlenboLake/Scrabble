# To change this template, choose Tools | Templates
# and open the template in the editor.

require File.expand_path('board.rb', File.dirname(__FILE__))
require File.expand_path('turn.rb', File.dirname(__FILE__))

board = Board.new
board.print

turn = Turn.new
turn.add_letter(?S, 7, 5)
turn.add_letter(?c, 7, 6)
turn.add_letter(?r, 7, 7) # DWS
turn.add_letter(?a, 7, 8)
turn.add_letter(?q, 1, 1)
turn.add_letter(?b, 7, 9)
turn.add_letter(?b, 7, 10)
turn.add_letter(?l, 7, 11) #DLS
turn.add_letter(?e, 7, 12)
turn.remove_letter(1, 1)

print(board.score_turn(turn))