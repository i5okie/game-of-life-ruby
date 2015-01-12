require 'gosu'
require_relative 'game_of_life.rb'


class GameWindow < Gosu::Window

	def initialize(width=600, height=600)
		@width = width
		@height = height

		super width, height, false
		self.caption = 'Game of Life'

		# color
		@background = Gosu::Color.new(0xffdedede)
		@alive = Gosu::Color.new(0xff121212)
		@dead = Gosu::Color.new(0xffdedede)
		@terminal = Gosu::Color.new(0xffff0000)

		# game definitions
		@rows = height/10
		@cols = width/10

		@row_height = height/@rows
		@col_width = width/@cols

		@world = World.new(@cols, @rows) # Note: col is 1st
		@game = Game.new(@world)

		@game.world.rand_populate

		@generation = 0
	end

	def update
	  @game.tick!
	  # @generation += 1
	  # puts "Generation No: #{@generation}"
	end

	def draw
	  draw_background
	  @game.world.cells.each do |cell|
	  	
	    if cell.alive?
	      draw_quad(cell.x * @col_width, cell.y * @row_height, @alive,
	                cell.x * @col_width + (@col_width - 1), cell.y * @row_height, @alive,
	                cell.x * @col_width + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @alive,
	                cell.x * @col_width, cell.y * @row_height + (@row_height - 1), @alive)
	    elsif cell.terminal? && cell.alive?
	  		draw_quad(cell.x * @col_width, cell.y * @row_height, @terminal,
	  		          cell.x * @col_width + (@col_width - 1), cell.y * @row_height, @terminal,
	  		          cell.x * @col_width + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @terminal,
	  		          cell.x * @col_width, cell.y * @row_height + (@row_height - 1), @terminal)
	  	else
	      draw_quad(cell.x * @col_width, cell.y * @row_height, @dead,
	                cell.x * @col_width + (@col_width - 1), cell.y * @row_height, @dead,
	                cell.x * @col_width + (@col_width - 1), cell.y * @row_height + (@row_height - 1), @dead,
	                cell.x * @col_width, cell.y * @row_height + (@row_height - 1), @dead)
	    end
	  end
	end

	def draw_background
	  draw_quad(0, 0, @background,
	            width, 0, @background,
	            width, height, @background,
	            0, height, @background)
	end

	def button_down(id)
	  case id
	  when Gosu::KbSpace
	    @game.world.rand_populate
	  when Gosu::KbEscape
	    close
	  end
	end

	def needs_cursor?
	  true
	end
end

GameWindow.new.show

