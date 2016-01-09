require './board.rb'


class Game

  attr_reader :board

  def initialize(board_size = 9)
    @board = Board.new(board_size)

    play
  end

  def get_guess
    answer_valid = false
    until answer_valid
      puts "Make your next move! Indicate 'F' (for Flag) or 'R' (for Reveal) and Guess location x,y!"
      puts "Example : R 1,2"
      move = gets.chomp
      answer_valid = true if move.length == 5 && (move[0] == "R" || move[0] == "F")
    end
    move = move.split(" ")
    @move_action = move[0]
    @move_position = move[1].split(",").map(&:to_i)
  end


  def receive_guess
    if @move_action == "R"
      @board[@move_position].reveal
    else
      flag_tile
    end
  end


  def game_over?
    return true if loss? || @board.win?

  end

  def loss?
    @move_action == "R" && @board[@move_position].value == :bomb
  end

  def flag_tile
    @board[@move_position].status = :flagged
  end


  def play
    until game_over?
      @board.render
      get_guess
      receive_guess
      system("clear")
    end
    puts "You Lose!" if loss?
    puts "You win!" if @board.win?
    @board.render
  end


end
