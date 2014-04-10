require_relative "sliding_piece"

class Queen < SlidingPiece
  DELTAS =[[1,1],[-1,-1],[1,-1],[-1,1],[1,0],[0,1],[0,-1],[-1,0]]

  def to_s
    @color == "white" ? "\u265b".colorize(:light_white) : "\u265b".colorize(:black)
  end
end