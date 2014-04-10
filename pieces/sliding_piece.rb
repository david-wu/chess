require_relative "piece"

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
