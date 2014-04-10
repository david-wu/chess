require_relative "piece"

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