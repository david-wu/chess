require_relative "stepping_piece"

class King < SteppingPiece
  DELTAS = [[1,1],[-1,-1],[1,-1],[-1,1],[1,0],[0,1],[0,-1],[-1,0]]

  def to_s
    @color == "white" ? "\u265a".colorize(:light_white) : "\u265a".colorize(:black)
  end
end