require_relative "piece"

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
    @color == "white" ? "\u265f".colorize(:light_white) : "\u265f".colorize(:black)
  end
end