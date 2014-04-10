require_relative "sliding_piece"

class Bishop < SlidingPiece
  DELTAS =[[1,1],[-1,-1],[1,-1],[-1,1]]

  def to_s
    @color == :white ? "\u265d".colorize(:light_white) : "\u265d".colorize(:black)
  end
end