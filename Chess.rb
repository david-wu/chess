require "debugger"
require "set"
require "colorize"

# Change deltas to class constants
# Override to_s, not  (no @display)

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
    @color == "white" ? "\u2657" : "\u265d"
  end
end

class Rook < SlidingPiece
  DELTAS =[[1,0],[0,1],[0,-1],[-1,0]]

  def to_s
    @color == "white" ? "\u2656" : "\u265c"
  end
end

class Queen < SlidingPiece
  DELTAS =[[1,1],[-1,-1],[1,-1],[-1,1],[1,0],[0,1],[0,-1],[-1,0]]

  def to_s
    @color == "white" ? "\u2655" : "\u265b"
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

  def to_s
    @color == "white" ? "\u2654" : "\u265a"
  end
end

class Knight < SteppingPiece
  DELTAS = [[2,1],[-2,-1],[2,-1],[-2,1],[1,2],[1,-2],[-1,2],[-1,-2]]

  def to_s
    @color == "white" ? "\u2658" : "\u265e"
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


  def to_s
    @color == "white" ? "\u2659" : "\u265f"
  end
end


class Board < Array

  attr_accessor :black_pieces, :white_pieces

  def initialize(fill = true)
    super(8){Array.new(8)}
    fill_board if fill
  end

  def dup
    dup_board = Board.new(false)
    self.each_with_index do |row, r_i|
      row.each_with_index do |ele, c_i|
        unless ele.nil?
          dup_board[r_i][c_i] = ele.class.new(ele.color, r_i, c_i, dup_board)
        end
      end
    end
    dup_board
  end

  def fill_board

    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    (0..7).each do |index|
      self[1][index] = Pawn.new("black", 1, index, self)
      self[6][index] = Pawn.new("white", 6, index, self)
      self[0][index] = pieces[index].new("black", 0, index, self)
      self[7][index] = pieces[index].new("white", 7, index, self)
    end
  end

  #filters out legal moves that would put in check
  def filter_moves(piece)

    moves = piece.legal_moves
    moves.reject! do |move|
      dup_board = self.dup
      duped_piece = dup_board[[piece.pos_x,piece.pos_y]]
      duped_piece.move(move)
      dup_board.check?(duped_piece.color)
    end
    moves
  end

  def all_pieces
    pieces = []
    (0..7).each do |row|
      self[row].each_with_index do |element, index|
        pieces << element unless element.nil?
      end
    end
    pieces
  end

  def check?(color)
    king_pos = []
    all_possible_moves = Set.new

    self.all_pieces.each do |piece|
      if piece.is_a?(King) && piece.color == color
          king_pos = [piece.pos_x, piece.pos_y]
      elsif piece.color != color
          all_possible_moves += piece.legal_moves
      end
    end

    return true if all_possible_moves.include?(king_pos)
    false
  end


  def checkmate?(player)

    self.all_pieces.each do |piece|
      if player == "white"
        return false unless filter_moves(piece)
      elsif player == "black"
        return false unless filter_moves(piece)
      end
    end
    true
  end

  def to_s
    system('clear')
    print_string = ''
    puts "  0  1  2  3  4  5  6  7"
    self.each_with_index do |row, index|
      print_string += "#{index}"
      row.each do |element|
        if element.nil?
          print_string += " \u2610 "
        else
          print_string += " #{element.to_s} "
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

class Game
  def initialize
    @board = Board.new
    @p1 = "white"
    @p2 = "black"
  end
  def run

    [@p1, @p2].cycle do |player|
      take_turn(player)
      break if false
    end

  end

  def take_turn(player)

    if @board.check?(player)
      puts "#{player} is in check"
      if @board.checkmate?(player)
        "#{player} Checkmate"
      end
    end


    print @board
    begin
      puts "#{player}, move which piece? (x,y)"
      start_pos = gets.chomp.split(',').map(&:to_i)

      puts "#{player}, move piece where? (x,y)"
      end_pos = gets.chomp.split(',').map(&:to_i)

      if @board[start_pos].nil? || @board[start_pos].color != player
        raise ArgumentError "No piece at #{start_pos}"
      end

      unless @board.filter_moves(@board[start_pos]).include?(end_pos)
        raise ArgumentError
      end
    rescue
      system('clear')
      print @board
      puts "#{start_pos} to #{end_pos} is not a valid move. Try again."
      retry
    end

    @board[start_pos].move(end_pos)
  end
end

game = Game.new
game.run
print b