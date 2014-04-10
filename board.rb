require_relative "pieces/pieces"

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
      if player == "white" && piece.color == "white"
        return false unless filter_moves(piece).empty?
      elsif player == "black" && piece.color == "black"
        return false unless filter_moves(piece).empty?
      end
    end
    true
  end

  def to_s
    print_string = ''
    place_color = "white"

    puts "  0 1 2 3 4 5 6 7"
    self.each_with_index do |row, index|
      print_string += "#{index}"
      row.each do |element|
        print_string += add_square(place_color, element)
        place_color == "white" ? place_color = "black" : place_color = "white"
      end
      print_string += "\n"
      place_color == "white" ? place_color = "black" : place_color = "white"
    end
    print_string
  end

  def add_square(color, element)
    if color == "white"
      if element.nil?
       return "  ".colorize( :background => :white)
      else
        return "#{element.to_s} ".colorize( :background => :white)
      end
    else
      if element.nil?
        return "  ".colorize( :background => :green)
      else
        return "#{element.to_s} ".colorize( :background => :green)
      end
    end
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