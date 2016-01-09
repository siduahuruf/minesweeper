require './board.rb'

class Tile

  attr_reader :value, :neighbors, :position
  attr_accessor :status

  def initialize(pos, assigned_value = nil)
    @status = :hidden
    @value = assigned_value
    @position = pos
    @neighbors = []
  end

  def reveal
    return @value if @status == :revealed
    if @value == :bomb
      @status = :bombed
    else
      @status = :revealed
      @neighbors.each {|neighbor| neighbor.reveal} if @value == 0
    end
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

  def inspect
    {"Value" => @value, "Position" => @position}.inspect
  end
end
