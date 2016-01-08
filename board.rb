require "./tile.rb"

class Board

  def initialize(board_size = 9)
    @board_size = board_size
    @board = Array.new(board_size) {Array.new(board_size)}
    @num_bombs = 5
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

  # def assign_neighbors
  #   @board.each_with_index do |row, row_index|
  #     row.each_with_index do |col, col_index|
  #       neighbor_array = []
  #       @board[row_index][col_index].neighbors
  #
  # end

end
