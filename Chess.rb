require "debugger"

# Change deltas to class constants
# Override to_s, not inspect (no @display)

class Piece
  attr_accessor :color

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

class SlidingPiece < Piece

  def legal_move?(pos)
    super(pos)
  end

  def legal_moves
    moves = []
    self.class::DELTAS.each { |delta| moves += check_line(delta) }
    moves
  end

  #returns possible moves in a line
  def check_line(delta)
    candidate_x = @pos_x+delta[0]
    candidate_y = @pos_y+delta[1]
    moves = []
    next_pos = [candidate_x, candidate_y]

    while legal_move?(next_pos)
      moves << next_pos.dup
      break if !@board[next_pos].nil? && (@board[next_pos].color != @color)
      next_pos[0], next_pos[1] = next_pos[0] + delta[0], next_pos[1] + delta[1]
    end
    moves
  end
end

class Bishop < SlidingPiece
  DELTAS =[[1,1],[-1,-1],[1,-1],[-1,1]]

  def to_s
    "B"
  end
end

class Rook < SlidingPiece
  DELTAS =[[1,0],[0,1],[0,-1],[-1,0]]

  def inspect
    "R"
  end
end

class Queen < SlidingPiece
  DELTAS =[[1,1],[-1,-1],[1,-1],[-1,1],[1,0],[0,1],[0,-1],[-1,0]]

  def inspect
    "Q"
  end
end

class SteppingPiece < Piece

  def legal_move?(pos)
    super(pos)
  end

  def legal_moves
    moves = self.class::DELTAS.map{ |delta| [ delta[0] + @pos_x, delta[1] + @pos_y] }
    if moves
      moves.select! { |pos| legal_move?(pos) }
    end
    moves
  end

end

class King < SteppingPiece
  DELTAS = [[1,1],[-1,-1],[1,-1],[-1,1],[1,0],[0,1],[0,-1],[-1,0]]

  def inspect
    "K"
  end
end

class Knight < SteppingPiece
  DELTAS = [[2,1],[-2,-1],[2,-1],[-2,1],[1,2],[1,-2],[-1,2],[-1,-2]]

  def inspect
    "N"
  end
end

class Pawn < Piece

  def legal_moves
    @color == "white" ? x_mod = -1 : x_mod = 1
    moves = [[x_mod,-1],[x_mod,1]]
    possible_moves = []
    moves.each do |pos|
      next_pos = [@pos_x+pos[0], @pos_y+pos[1]]
      #if candidate move is not empty and piece is opposite color
      if (!@board[next_pos].nil?) && (@board[next_pos].color != @color)
        possible_moves << next_pos
      end
    end

    next_pos = [@pos_x+x_mod, @pos_y]
    if @board[next_pos].nil?
      possible_moves << next_pos
    end

    if @color == "white" && @pos_x == 6
      possible_moves << [4 , @pos_y] if @board[[4, @pos_y]].nil?
    end
    if @color == "black" && @pos_x == 1
      possible_moves << [3 , @pos_y] if @board[[3, @pos_y]].nil?
    end


    possible_moves
  end


  def inspect
    "P"
  end
end


class Board < Array
  def initialize
    super(8){Array.new(8)}
  end

  def to_s
    print_string = ''
    self.each do |row|
      row.each do |element|
        if element.nil?
          print_string += " _ "
        else
          print_string += " #{element} "
        end
      end
      print_string += "\n"
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
puts b