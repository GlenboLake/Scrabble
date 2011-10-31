# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'turn'

$PRINT_PREMIUMS = false

$letter_scores = { ?A => 1, ?B => 3, ?C => 3, ?D => 2, ?E => 1,
  ?F => 4, ?G => 2, ?H => 4, ?I => 1, ?J => 8, ?K => 5, ?L => 1,
  ?M => 3, ?N => 1, ?O => 1, ?P => 3, ?Q => 10, ?R => 1, ?S => 1,
  ?T => 1, ?U => 1, ?V => 4, ?W => 4, ?X => 8, ?Y => 4, ?Z => 10}

class Board
  def blank
    ?_
  end

  def initialize
    @squares = Hash.new
    (0...15).each do |i|
      (0...15).each do |j|
        @squares[[i,j]] = blank
      end
    end

    # Standard premium squares
    @premiums = Hash.new
    @premiums[[ 0, 0]]=:TWS
    @premiums[[ 0, 7]]=:TWS
    @premiums[[ 0,14]]=:TWS
    @premiums[[ 7, 0]]=:TWS
    @premiums[[ 7,14]]=:TWS
    @premiums[[14, 0]]=:TWS
    @premiums[[14, 7]]=:TWS
    @premiums[[14,14]]=:TWS

    (1..13).step(4) { |i|
    (1..13).step(4) { |j|
      @premiums[[i,j]]=:TLS
    }}

    (1..4).each do |i|
      @premiums[[i,i]]=:DWS
      @premiums[[i,14-i]]=:DWS
      @premiums[[14-i,i]]=:DWS
      @premiums[[14-i,14-i]]=:DWS
    end
    @premiums[[7,7]]=:DWS

    @premiums[[0,3]] = :DLS
    @premiums[[0,11]] = :DLS
    @premiums[[3,0]] = :DLS
    @premiums[[2,6]] = :DLS
    @premiums[[3,7]] = :DLS
    @premiums[[2,8]] = :DLS
    @premiums[[3,14]] = :DLS
    @premiums[[6,2]] = :DLS
    @premiums[[6,6]] = :DLS
    @premiums[[6,8]] = :DLS
    @premiums[[6,12]] = :DLS
    @premiums[[7,3]] = :DLS
    @premiums[[7,11]] = :DLS
    @premiums[[8,2]] = :DLS
    @premiums[[8,6]] = :DLS
    @premiums[[8,8]] = :DLS
    @premiums[[8,12]] = :DLS
    @premiums[[11,0]] = :DLS
    @premiums[[12,6]] = :DLS
    @premiums[[11,7]] = :DLS
    @premiums[[12,8]] = :DLS
    @premiums[[11,14]] = :DLS
    @premiums[[14,3]] = :DLS
    @premiums[[14,11]] = :DLS
  end

  def play_turn(turn)
    score = score_turn(turn)
    turn.letters.each { |tile,letter| @squares[tile] = letter } unless score==0
    return score
  end

  def score_turn(turn)
    unless is_valid?(turn)
      return 0
    end
    turn_score = 0
    #for each word (including crosses)
      word_score = 0
      word_multiplier = 1
      turn.letters.each { |tile,letter|
      if @premiums[tile]==:DWS
        word_multiplier *= 2
        word_score += $letter_scores[letter]
      elsif @premiums[tile]==:TWS
        word_multiplier *= 3
        word_score += $letter_scores[letter]
      elsif @premiums[tile]==:DLS
        word_score += 2 * $letter_scores[letter]
      elsif @premiums[tile]==:TLS
        word_score += $letter_scores[letter] * 3
      else
        word_score += $letter_scores[letter]
      end
      }
      turn_score += word_score * word_multiplier
    #end
    turn_score
  end

  def is_valid?(turn)
    return false if not turn.is_a?(Turn)
    rows = []
    cols = []
    # First make sure the turn spans a single row or column and doesn't cover any occupied squares
    turn.letters.keys.each { |key|
      return false if @squares[key] != blank
      rows << key[0]
      cols << key[1]
    }
    if rows.uniq.size == 1
      direction = :horizontal
    elsif cols.uniq.size == 1
      direction = :vertical
    else
      return false
    end
    # Check to make sure there are tiles between each of the ones being placed
    if direction == :horizontal
      (cols.min..cols.max).each do |i|
        cell = [rows[0],i]
        if not (@squares[cell]==blank) ^ (turn.letters[cell]==blank)
          return false
        end
      end
    elsif direction == :vertical
      (rows.min..rows.max).each { |i|
        cell = [i, cols[0]]
        if not (@squares[cell]==blank) ^ (turn.letters[cell]==nil)
          return false
        end
      }
    end
    true
  end
  private :is_valid?

  def printout()
    for row in (0...15)
      for col in (0...15)
        if $PRINT_PREMIUMS and @squares[[row,col]]==blank
          case @premiums[[row,col]]
          when :TWS
            putc(?T)
          when :DWS
            putc(?D)
          when :TLS
            putc(?t)
          when :DLS
            putc(?d)
          else
            putc(blank)
          end
        else
          putc(@squares[[row,col]])
        end
      end
      putc(?\n)
    end
  end
end
