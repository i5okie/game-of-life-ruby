
class Game
  attr_accessor :world, :seeds

  def initialize(world=World.new, seeds=[])
    @world = world
    @seeds = seeds

    seeds.each do |seed|
      world.cell_grid[seed[0]][seed[1]].alive = true
    end
  end

  def tick!
    next_round_live_cells = []
    next_round_dead_cells = []    

    world.cells.each do |cell|
      neighbour_count = self.world.live_neighbours_around_cell(cell).count
      # Rule 1
      if cell.alive? && neighbour_count < 2
        # cell.die!
        next_round_dead_cells << cell
        cell.terminal = true
      end

      # Rule 2
      if cell.alive? && ([2, 3].include? neighbour_count)
        # cell.revive!
        next_round_live_cells << cell
        cell.terminal = false
      end

      # Rule 3
      if cell.alive? && neighbour_count > 3
        next_round_dead_cells << cell
        cell.terminal = true
      end

      # Rule 4
      if cell.dead? && neighbour_count == 3
        next_round_live_cells << cell
        cell.terminal = false
      end
    end

    next_round_live_cells.each do |cell|
      cell.revive!
    end

    next_round_dead_cells.each do |cell|
      cell.die!
    end
  end

end

class World < Game
  attr_accessor :rows, :cols, :cell_grid, :cells
  def initialize(rows=3, cols=3)
  	@rows = rows
  	@cols = cols
    @cells = []

    @cell_grid = Array.new(rows) do |row|
      Array.new(cols) do |col|
        Cell.new(col, row) # Note: col is 1st
      end
    end

    cell_grid.each do |row|
      row.each do |element|
        if element.is_a?(Cell)
          cells << element
        end
      end
    end
  end

  def live_cells
    cells.select { |cell| cell.alive }
  end

  def rand_populate
    cells.each do |cell|
      cell.alive = [true, false].sample
    end
  end

  def live_neighbours_around_cell(cell)
     live_neighbours = []
     # Neighbour to the North-East
     if cell.y > 0 && cell.x < (cols - 1)
       candidate = self.cell_grid[cell.y - 1][cell.x + 1]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbour to the South-East
     if cell.y < (rows - 1) && cell.x < (cols - 1)
       candidate = self.cell_grid[cell.y + 1][cell.x + 1]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbours to the South-West
     if cell.y < (rows - 1) && cell.x > 0
       candidate = self.cell_grid[cell.y + 1][cell.x - 1]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbours to the North-West
     if cell.y > 0 && cell.x > 0
       candidate = self.cell_grid[cell.y - 1][cell.x - 1]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbour to the North
     if cell.y > 0
       candidate = self.cell_grid[cell.y - 1][cell.x]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbour to the East
     if cell.x < (cols - 1)
       candidate = self.cell_grid[cell.y][cell.x + 1]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbour to the South
     if cell.y < (rows - 1)
       candidate = self.cell_grid[cell.y + 1][cell.x]
       live_neighbours << candidate if candidate.alive?
     end
     # Neighbours to the West
     if cell.x > 0
       candidate = self.cell_grid[cell.y][cell.x - 1]
       live_neighbours << candidate if candidate.alive?
     end
     live_neighbours
   end

  # def live_neighbours_around_cell(cell)
  #   live_neighbours = []

  #   # it detects a neighbour to the north-west
  #   if cell.y > 0 and cell.x > 0
  #     candidate = self.cell_grid[cell.y - 1][cell.x - 1]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   # it detects a neighbour to the north
  #   if cell.y > 0
  #     candidate = self.cell_grid[cell.y - 1][cell.x]
  #     live_neighbours << candidate if candidate.alive?
  #   end
    
  #   # it detects a neighbour to the north-east
  #   if cell.y > 0 and cell.x < (cols - 1)
  #     candidate = self.cell_grid[cell.y - 1][cell.x + 1]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   # it detects a neighbour to the east
  #   if cell.x < (cols - 1)
  #     candidate = self.cell_grid[cell.y][cell.x + 1]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   # it detects a neighbour to the south-east
  #   if cell.y < (rows - 1) and cell.x < (cols - 1)
  #     candidate = self.cell_grid[cell.y + 1][cell.x + 1]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   # it detects a neighbour to the south
  #   if cell.y < (rows - 1)
  #     candidate = self.cell_grid[cell.y + 1][cell.x]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   # it detects a neighbour to the south-west
  #   if cell.y < (rows - 1) and cell.x > 0
  #     candidate = self.cell_grid[cell.y + 1][cell.x - 1]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   # it detects a neighbour to the west
  #   if cell.x > 0
  #     candidate = self.cell_grid[cell.y][cell.x - 1]
  #     live_neighbours << candidate if candidate.alive?
  #   end

  #   live_neighbours
  # end

end

class Cell < Game
  attr_accessor :alive, :x, :y, :terminal

  def initialize(x = 0, y = 0)
    @alive = false
    @terminal = false
    @x = x
    @y = y
  end

  def die!
    @alive = false
    terminal = false
  end

  def terminal?
    terminal
  end

  def alive?
    alive
  end

  def dead?
    !alive
  end

  def revive!
    terminal = false
    @alive = true
  end

end

