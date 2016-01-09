require './board.rb'
require 'yaml'

class Game

  attr_reader :board

  def initialize(board_size = 9)
    @board = Board.new(board_size)
    setup
  end

  def setup
    puts "Do you want to load in a game? (y/n)"
    if gets.chomp == "y"
      puts "Please enter a yaml filename (without .yml extension)"
      filename = gets.chomp
      load_game(filename)
    end
    play
  end


  def get_guess
    answer_valid = false
    until answer_valid
      puts "Make your next move! Indicate 'F' (for Flag) or 'R' (for Reveal) and Guess location x,y!"
      puts "To save the game, type S"
      puts "Example : R 1,2"
      move = gets.chomp
      if move == "S"
        puts "Choose a filename (without .yml extension)"
        filename = gets.chomp
        save_game(filename)
      end
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

  def save_game(filename)
    @board.export_game_file(filename)
  end

  def load_game(filename)
    @board.load_game_file(filename)
  end

end
