require 'rspec'
require 'gosu'

class Cell
  attr_accessor :x, :y
  def neighbours
    []
  end

  def spawn_at(x, y)
    Cell.new
  end
end

describe 'game of life'  do
  context "cell utility methods" do
    subject { Cell.new }
    it "spawn relative to" do
      cell = subject.spawn_at(3,5)
      cell.is_a?(Cell).should be_true
      cell.x.should == 3
      cell.y.should == 5
    end
  end
  it 'Rule #1: Any live cell with fewer than two live neighbours dies, as if caused by under-population.' do
  cell = Cell.new
  cell.neighbours.count.should == 0
  end
end


