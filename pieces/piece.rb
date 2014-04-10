class Piece
  attr_accessor :color, :pos_x, :pos_y

  def initialize(color, pos_x, pos_y, board)
    @color = color
    @pos_x = pos_x
    @pos_y = pos_y
    @board = board
    board[@pos_x][@pos_y] = self
  end

  def move(new_pos)
    if legal_moves.include?(new_pos)
      @board[@pos_x][@pos_y] = nil
      @pos_x, @pos_y = new_pos[0], new_pos[1]
      @board[@pos_x][@pos_y] = self
    end
  end

  def legal_move?(pos)
    return false if pos[0] < 0 || pos[0] > 7 ||
       pos[1] < 0 || pos[1] > 7

    return false if !@board[pos].nil? && @color == @board[pos].color
    true
  end

  def legal_moves
    raise NotYetImplemented
  end
end