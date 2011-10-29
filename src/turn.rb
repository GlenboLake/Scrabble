# To change this template, choose Tools | Templates
# and open the template in the editor.

class Turn
  def initialize
    @letters = Hash.new
  end

  attr_reader :letters

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
  
  def is_letter?(char)
    unless char.is_a?(String)
      puts(char.class.name)
      return false
    end
    unless char.length == 1
      puts("#{char.length}")
      return false
    end
    char.upcase!
    return char >= ?A && char <= ?Z
  end

  private :is_letter?
end
