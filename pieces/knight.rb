require_relative "stepping_piece"

class Knight < SteppingPiece
  DELTAS = [[2,1],[-2,-1],[2,-1],[-2,1],[1,2],[1,-2],[-1,2],[-1,-2]]

  def to_s
    @color == :white ? "\u265e".colorize(:light_white) : "\u265e".colorize(:black)
  end
end