require "./tile.rb"
require 'yaml'

class Board
  attr_reader :board, :bomb_locations, :remaining_tiles

  def initialize(board_size = 9)
    @board_size = board_size
    @board = Array.new(board_size) {Array.new(board_size)}
    @num_bombs = 5

    setup
  end

  def setup
    assign_bombs
    build_board
    assign_neighbors
    render
  end

  def build_board
    counter = 0
    @board.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        value = :bomb if @bomb_locations.include?(counter)
        @board[row_index][col_index] = Tile.new([row_index, col_index],value)
        counter += 1
      end
    end
    @board
  end

  def assign_bombs
    @bomb_locations = (0..@board_size**2).to_a.sample(@num_bombs)
  end

  def assign_neighbors
    possible_directions = [
      [-1, -1], [0, -1], [1, -1], [-1,0],
      [1, 0], [-1, 1], [0, 1], [1, 1]]

    @board.each_with_index do |row, row_index|
      row.each_with_index do |tile, col_index|
        possible_directions.each do |direction|
          new_neigh_row = row_index + direction[0]
          new_neigh_col = col_index + direction[1]

          if new_neigh_col.between?(0, @board_size-1) && new_neigh_row.between?(0, @board_size-1)
            tile.neighbors << @board[new_neigh_row][new_neigh_col]
          end

          tile.neighbor_bomb_count
        end
      end
    end
  end

  def win?
    @remaining_tiles == @num_bombs
  end


  def render
    @remaining_tiles = @board_size ** 2
    print "  0 1 2 3 4 5 6 7 8\n"
    @board.each_with_index do |row, row_index|
      print "#{row_index} "
      row.each do |tile|
        # print tile.to_s
        if tile.status == :hidden
          print "* "
        elsif tile.status == :flagged
          print "F "
        elsif tile.value == :bomb
          print "B "
        else
          if tile.value == 0
            print "_ "
            @remaining_tiles -= 1
          else
            print "#{tile.value} "
            @remaining_tiles -= 1
          end
        end
      end
      print "\n"
    end
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def export_game_file(filename)
    File.open("#{filename}.yml","w"){|file| file.write(@board.to_yaml)}
  end

  def load_game_file(filename)
    file = File.read("#{filename}.yml")
    @board = YAML::load(file)
  end

end
