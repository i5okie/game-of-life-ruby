# spec file
require 'rspec'
require_relative 'game_of_life.rb'

describe ':: Game of Life'  do

  let!(:world) { World.new }
  let!(:cell) { Cell.new(1, 1) }

  context ":: World" do
    subject {World.new}

    it 'should create a new world object' do
      expect(subject).to be_a(World)
    end

    it 'should respond to proper methods' do
      expect(subject).to respond_to(:rows), 'World should respond to :rows'
      expect(subject).to respond_to(:cols), 'World should respond to :cols'
      expect(subject).to respond_to(:cell_grid), 'World should respond to :cell_grid'
      expect(subject).to respond_to(:live_neighbours_around_cell)
      expect(subject).to respond_to(:rand_populate)
      expect(subject).to respond_to(:live_cells)
    end

    it 'should create proper cell grid on initialization' do
      expect(subject.cell_grid).to be_a(Array), 'World.cell_grid should be an Array.'
      subject.cell_grid.each do |row|
        expect(row).to be_a(Array), 'Each row in World.cell_grid should be an Array'
      end
    end

    it 'should add all cells to cells array' do
      expect(subject.cells.count).to eq(9)
    end

    it 'detects live neighbour to the north-west' do
      subject.cell_grid[cell.y - 1][cell.x - 1].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the north' do
      subject.cell_grid[cell.y - 1][cell.x].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the north-east' do
      subject.cell_grid[cell.y - 1][cell.x + 1].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the east' do
      subject.cell_grid[cell.y][cell.x + 1].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the south-east' do
      subject.cell_grid[cell.y + 1][cell.x + 1].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the south' do
      subject.cell_grid[cell.y + 1][cell.x].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the south-west' do
      subject.cell_grid[cell.y + 1][cell.x - 1].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'detects live neighbour to the west' do
      subject.cell_grid[cell.y][cell.x - 1].alive = true
      expect(subject.live_neighbours_around_cell(cell).count).to eq(1)
    end

    it 'should detect a neighbour to the north' do
      expect(subject.cell_grid[0][2]).to be_dead
      subject.cell_grid[0][2].alive = true
      expect(subject.cell_grid[0][2]).to be_alive
      expect(subject.live_neighbours_around_cell(subject.cell_grid[1][1]).count).to eq(1)
    end

    it 'should randomly populate the world' do
      expect(subject.live_cells.count).to eq(0)
      subject.rand_populate
      expect(subject.live_cells.count).to be > 0
    end

  end

  context ":: Cell" do
    subject {Cell.new}

    it 'should create a new cell object' do
      expect(subject).to be_a(Cell), 'Should create a new Cell object'
    end

    it 'should respond to proper methods' do
      expect(subject).to respond_to(:alive), 'Cell should respond to :alive'
      expect(subject).to respond_to(:x)
      expect(subject).to respond_to(:y)
      expect(subject).to respond_to(:alive?), 'Cell should respond to :alive?'
      expect(subject).to respond_to(:die!)
    end

    it 'should initialize properly' do
      expect(subject.alive).to eq(false)
      expect(subject.x).to eq 0
      expect(subject.y).to eq 0
    end


  end

  context ':: Game' do
    subject {Game.new}
    it 'should create a new game' do
      expect(subject).to be_a(Game)
    end

    it 'should respond to proper methods' do
      expect(subject).to respond_to(:world)
      expect(subject).to respond_to(:seeds)
    end

    it 'should initialize properly' do
      expect(subject.world).to be_a(World)
      expect(subject.seeds).to be_a(Array)
    end

    it 'should plant seeds properly' do
      game =  Game.new(world, [[1,2],[0,2]])
      expect(world.cell_grid[1][2]).to be_alive
      expect(world.cell_grid[0][2]).to be_alive
    end

  end
  
  context ':: Rules' do
    let!(:game) { Game.new }

    context ':: #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population.' do
    
      it '-- Should kill off a cell with one life neighbour' do
        game = Game.new(world, [[1,0],[2,0]])
        game.tick!
        expect(world.cell_grid[1][0]).to be_dead
        expect(world.cell_grid[2][0]).to be_dead
      end

      it '-- Should kill a live cell with 1 live neighbour' do
        game = Game.new(world, [[1,0],[2,0]])
        game.tick!
        expect(world.cell_grid[1][0]).to be_dead
        expect(world.cell_grid[2][0]).to be_dead
      end

      it '-- Doesn\'t kill live cell with 2 neighbours' do
        game = Game.new(world, [[0,1],[1,1],[2,1]])
        game.tick!
        expect(world.cell_grid[1][1]).to be_alive
      end

    end

    context ':: #2: Any live cell with two or three live neighbours lives on to the next generation.' do
      it 'should keep alive cell with two neighbours until next generation' do
        game = Game.new(world, [ [0, 1],[1, 1],[2, 1] ])
        expect(world.live_neighbours_around_cell(world.cell_grid[1][1]).count).to eq(2)
        game.tick!
        expect(world.cell_grid[0][1]).to be_dead
        expect(world.cell_grid[1][1]).to be_alive
        expect(world.cell_grid[2][1]).to be_dead
      end
    end

    context ':: Rule #3: Any live cell with more than three live neighbours dies, as if by overcrowding.' do
    end

    context ':: Rule #4: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.' do
    end

  end

end


