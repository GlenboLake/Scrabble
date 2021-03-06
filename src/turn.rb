require 'ruby_version.rb'

class Turn
  attr_reader :letters
  attr_accessor :score

  def initialize
    @letters = Hash.new
    @score = 0
  end

  def add_letter(letter, row, col)
    unless is_letter?(letter)
      puts("Error: letter should be a single character. Found #{letter} instead.")
      return
    end
    unless row.class==Fixnum && col.class==Fixnum
      puts("row and col should be integers")
      return
    end
    @letters[[row,col]] = letter
  end

  def remove_letter(row, col)
    @letters.delete([row,col])
  end
  
  def direction
    rows = []
    cols = []
    # First make sure the turn spans a single row or column and doesn't cover any occupied squares
    @letters.keys.each { |key|
      rows << key[0]
      cols << key[1]
    }
    if rows.uniq.size == 1
      return :horizontal
    elsif cols.uniq.size == 1
      return :vertical
    else
      return nil
    end
  end

  def is_letter?(char)
    if RubyVersion.is? 1.8
      unless char.is_a?(Fixnum)
        return false
      end
      if char >= ?a && char <= ?z
        char += ?A-?a
        return true
      end
    end
    if RubyVersion.is? 1.9
      unless char.is_a?(String)
        puts(char.class.name)
        return false
      end
      unless char.length == 1
        puts("#{char.length}")
        return false
      end
      char.upcase!
    end
    return char >= ?A && char <= ?Z
  end
  private :is_letter?
end
