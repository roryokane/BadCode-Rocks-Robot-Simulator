# In contrast, a good solution for the robot simulator.
# This good solution uses immutable state to make the code more explicit, though it is more verbose.
# http://badcode.rocks/2018/337/robot-simulator/

module StateTransformers
	NEW_DIR_AFTER_TURNING_RIGHT = {'N' => 'E', 'E' => 'S', 'S' => 'W', 'W' => 'N'}
	NEW_DIR_AFTER_TURNING_LEFT = NEW_DIR_AFTER_TURNING_RIGHT.invert

	def self.turn_right(old_state)
		old_state.merge({
			direction: NEW_DIR_AFTER_TURNING_RIGHT[old_state[:direction]],
		})
	end
	def self.turn_left(old_state)
		old_state.merge({
			direction: NEW_DIR_AFTER_TURNING_LEFT[old_state[:direction]],
		})
	end

	X_Y_ADDITIONS_WHEN_ADVANCING_IN_DIRECTION = {
		'N' => [0, 1],
		'E' => [1, 0],
		'S' => [0, -1],
		'W' => [-1, 0],
	}
	def self.advance(old_state)
		x_addition, y_addition = X_Y_ADDITIONS_WHEN_ADVANCING_IN_DIRECTION[old_state[:direction]]
		return old_state.merge({
			x: old_state[:x] + x_addition,
			y: old_state[:y] + y_addition,
		})
	end
end

initial_state = {
	x: ARGV[0].to_i,
	y: ARGV[1].to_i,
	direction: ARGV[2],
}
commands = ARGV[3]

final_state = commands.each_char.inject(initial_state) do |state, command_char|
	case command_char
	when 'L'
		StateTransformers.turn_left(state)
	when 'R'
		StateTransformers.turn_right(state)
	when 'A'
		StateTransformers.advance(state)
	end
end

puts "#{final_state[:x]} #{final_state[:y]} #{final_state[:direction]}"
