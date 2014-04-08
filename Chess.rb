class Piece
  def initialize(color, pos_x, pos_y, board)
    @color = color
    @pos_x = pos_x
    @pos_y = pos_y
    @board = board
  end
  def moves

  end
  def move_legal?()
    raise NotYetImplemented
  end
end

class SlidingPiece

end



class Board < Array
  def initialize
    super(8){Array.new(8)}
    self[4][4]='pig'
  end

  def inspect
    print_string = ''
    self.each do |row|
      print_string += row.to_s + "\n"
    end
    print_string
  end

  def remove_piece()

  end

end


b = Board.new
p b