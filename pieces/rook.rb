require_relative "sliding_piece"

class Rook < SlidingPiece
  DELTAS =[[1,0],[0,1],[0,-1],[-1,0]]

  def to_s
    @color == :white ? "\u265c".colorize(:light_white) : "\u265c".colorize(:black)
  end
end