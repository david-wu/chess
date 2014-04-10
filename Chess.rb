require "debugger"
require "set"
require "colorize"

require_relative "board"

class Game
  def initialize
    @board = Board.new
    @p1 = "white"
    @p2 = "black"
    @checkmate= false
  end
  def run
    [@p1, @p2].cycle do |player|

      break unless take_turn(player)
    end

  end

  def take_turn(player)

    system('clear')
    print @board
    if @board.check?(player)
      if @board.checkmate?(player)
        puts "Checkmate!"
        return false
      end
      puts "#{player.capitalize} is in check."
    end

    begin
      puts "#{player.capitalize}, move which piece? (x,y)"
      start_pos = gets.chomp.split(',').map(&:to_i)

      puts "#{player.capitalize}, move piece where? (x,y)"
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