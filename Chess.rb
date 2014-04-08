class Piece
  def initialize(color, pos_x, pos_y, board)
    @color = color
    @pos_x = pos_x
    @pos_y = pos_y
    @board = board
    board[@pos_x][@pos_y] = self
    @legal_moves = []
  end

  def legal_moves
    raise NotYetImplemented
  end


  def move(new_pos)
    if @legal_moves.include?(new_pos)
      @board[@pos_x][@pos_y] = nil
      @pos_x, @pos_y = new_pos[0], new_pos[1]
      @board[@pos_x][@pos_y] = self
    end
  end

  def move_legal?()
    raise NotYetImplemented
  end
end

class SlidingPiece < Piece

  def initialize(color, pos_x, pos_y, board)
    super(color, pos_x, pos_y, board)
    @DELTAS = nil
  end

  def legal_moves
    @DELTAS.each { |delta| check_lines(delta) }
  end

  def check_line(delta)
    candidate_x = @pos_x+delta[0]
    candidate_y = @pos_y+delta[1]

    #returns possible moves in a line
    while legal_move?([candidate_x, candidate_y])
      @legal_moves << [candidate_x, candidate_y]
      break if !@board[[candidate_x,candidate_y]].nil? && (@board[[candidate_x,candidate_y]].color != @color)
      candidate_x, candidate_y = candidate_x + delta[0], candidate_y + delta[1]
    end

    @legal_moves
  end

  def legal_move?(pos)
    return false if pos[0] < 0 || pos[0] > 7 ||
       pos[1] < 0 || pos[1] > 7

    return false if !@board[pos].nil? && @color == @board[pos].color
    true
  end
end

class Bishop < SlidingPiece

  def initialize(color, pos_x, pos_y, board)
    super(color, pos_x, pos_y, board)
    @DELTAS =[[1,1],[-1,-1],[1,-1],[-1,1]]
    @display = "B"
  end

  def inspect
    @display
  end

end

class SteppingPiece

end

class Pawn
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

  def [](pos)
    if pos.is_a?(Fixnum)
      super(pos)
    else
      self[pos[0]][pos[1]]
    end
  end

  def []=(pos, value)
    if pos.is_a?(Fixnum)
      super(pos, value)
    else
      x,y = pos[0], pos[1]
      self[x][y] = value
    end
  end

end


b = Board.new
p b