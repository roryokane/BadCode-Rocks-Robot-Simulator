# In contrast, a good solution for the robot simulator.
# This good solution uses mutable state to make the code shorter and more like idiomatic Ruby.
# http://badcode.rocks/2018/337/robot-simulator/

class Robot
	attr_reader :direction, :x, :y
	
	def initialize(direction:, x:, y:)
		@direction = direction
		@x = x
		@y = y
	end

	NEW_DIR_AFTER_TURNING_RIGHT = {'N' => 'E', 'E' => 'S', 'S' => 'W', 'W' => 'N'}
	NEW_DIR_AFTER_TURNING_LEFT = NEW_DIR_AFTER_TURNING_RIGHT.invert
	
	def turn_right
		@direction = NEW_DIR_AFTER_TURNING_RIGHT[@direction]
	end
	def turn_left
		@direction = NEW_DIR_AFTER_TURNING_LEFT[@direction]
	end

	X_Y_ADDITIONS_WHEN_ADVANCING_IN_DIRECTION = {
		'N' => [0, 1],
		'E' => [1, 0],
		'S' => [0, -1],
		'W' => [-1, 0],
	}
	def advance
		x_addition, y_addition = X_Y_ADDITIONS_WHEN_ADVANCING_IN_DIRECTION[@direction]
		@x += x_addition
		@y += y_addition
	end
end

robot = Robot.new(
	x: ARGV[0].to_i,
	y: ARGV[1].to_i,
	direction: ARGV[2],
)
commands = ARGV[3]

commands.each_char do |command_char|
	case command_char
	when 'L'
		robot.turn_left
	when 'R'
		robot.turn_right
	when 'A'
		robot.advance
	end
end

puts "#{robot.x} #{robot.y} #{robot.direction}"
