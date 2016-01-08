require "./tile.rb"

class Board

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
            p "new_n_row #{new_neigh_row}, new_n_col #{new_neigh_col}, tile #{[row_index,col_index]}"
            tile.neighbors << @board[new_neigh_row][new_neigh_col]
          end
        end
      end
    end
  end

end
