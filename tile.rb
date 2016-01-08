class Tile

  attr_reader :value, :neighbors

  def initialize(assigned_value = nil, pos)
    @status = :hidden
    @value = assigned_value
    @position = pos
    @neighbors = []
  end


  def reveal
    @status = :revealed
    @value
  end

  def neighbor_bomb_count
    return @value if @value == :bomb

    bomb_counter = 0
    neighbors.each do |neighbor|
      if neighbor.value == :bomb
        bomb_counter += 1
      end
    end
    @value = bomb_counter
  end


  def bombed?
    @value == :bomb
  end




end
