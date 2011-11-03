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

  attr_accessor :squares, :premiums
  
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

  def score_word(letters, tiles)
    # letters is the letter collection from the turn
    # tiles are the indexes in [row,col] form
    return 0 if tiles.size==1
    word_score = 0
    word_multiplier = 1
    tiles.each { |tile|
      if letters[tile] == nil
        # This tile is already on the board
        word_score += $letter_scores[@squares[tile]]
      else
        # This is part of the word that was just played
        case @premiums[tile]
        when :DWS
          word_multiplier *= 2
          word_score += $letter_scores[letters[tile]]
        when :TWS
          word_multiplier *= 3
          word_score += $letter_scores[letters[tile]]
        when :DLS
          word_score += 2 * $letter_scores[letters[tile]]
        when :TLS
          word_score += 3 * $letter_scores[letters[tile]]
        else
          word_score += $letter_scores[letters[tile]]
        end
      end
    }
    word_score * word_multiplier
  end
  private :score_word

  def score_turn(turn)
    unless is_valid?(turn)
      return 0
    end
    turn_score = 0
    # First, primary word
    case turn.direction
    when :horizontal
      row = turn.letters.keys.first[0]
      left = turn.letters.keys.first[1]
      right = turn.letters.keys.last[1]
      until turn.letters[[row, left-1]]==nil and @squares[[row, left-1]]==blank
        left -= 1
      end
      until turn.letters[[row, right+1]]==nil and @squares[[row, right+1]]==blank
        right += 1
      end
      turn_score += score_word(turn.letters, (left..right).to_a.collect { |col| [row, col] })
    when :vertical
      col = turn.letters.keys.first[1]
      top = turn.letters.keys.first[0]
      bot = turn.letters.keys.last[1]
      until turn.letters[[top-1, col]]==nil and @squares[[top-1, col]]==blank
        top -= 1
      end
      until turn.letters[[bot+1, col]]==nil and @squares[[bot+1, col]]==blank
        bot += 1
      end
      turn_score += score_word(turn.letters, (top..bot).to_a.collect { |row| [row, col] })
    end
    # for each cross words
    turn.letters.keys.each do |key|
      row = key[0]
      col = key[1]
      case turn.direction
      when :horizontal
        top = row
        until turn.letters[[top-1, col]]==nil and @squares[[top-1, col]]==blank
          top -= 1
        end
        bot = row
        until turn.letters[[bot+1, col]]==nil and @squares[[bot+1, col]]==blank
          bot += 1
        end
        turn_score += score_word(turn.letters, (top..bot).to_a.collect { |row| [row, col] })
      when :vertical
        left = col
        until turn.letters[[row, left-1]]==nil and @squares[[row, left-1]]==blank
          left -= 1
        end
        right = col
        until turn.letters[[row, right+1]]==nil and @squares[[row, right+1]]=blank
          right += 1
        end
        turn_score += score_word(turn.letters, (left..right).to_a.collect { |row| [row, col] })
      end
    end
    turn.score = turn_score
  end

  def is_valid?(turn)
    return false if not turn.is_a?(Turn)
    # First make sure the turn spans a single row or column and doesn't cover any occupied squares
    return false if turn.direction==nil
    # collect the rows and columns
    rows = turn.letters.keys.collect { |i| i[0] }.uniq
    cols = turn.letters.keys.collect { |i| i[1] }.uniq
    # Check to make sure there are tiles between each of the ones being placed
    case turn.direction
    when :horizontal
      (cols.min..cols.max).each do |i|
        cell = [rows[0],i]
        if not (@squares[cell]==blank) ^ (turn.letters[cell]==blank)
          return false
        end
      end
    when :vertical
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
