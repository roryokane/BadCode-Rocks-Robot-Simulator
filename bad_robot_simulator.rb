#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# frozen_string_literal: true
# warn_indent: true
# by: Rory O’Kane

$direction = :not_init

def map_dir_to_intuitive_dir(dir)
	dir = case dir
	when 'W'
		'L'
	when 'S'
		'D'
	when 'E'
		'R'
	when 'N'
		'U'
	end
end

def intuitive_dir_to_map_dir(dir)
	dir = case dir
	when 'L'
		'W'
	when 'D'
		'S'
	when 'R'
		'E'
	when 'U'
		'N'
	end
end

init_x = eval(ARGV[0])
init_y = eval(ARGV[1])
init_dir = map_dir_to_intuitive_dir(ARGV[2])
cmd_str = ARGV[3]

$direction = init_dir

def right
	dir = case $direction
	when 'L'
		$direction = 'U'
	when 'D'
		$direction = 'L'
	when 'R'
		$direction = 'D'
	when 'U'
		$direction = 'R'
	end
end

def left
	dir = case $direction
	when 'L'
		$direction = 'D'
	when 'D'
		$direction = 'R'
	when 'R'
		$direction = 'U'
	when 'U'
		$direction = 'L'
	end
end

# first, figure out the final direction
cmd_str.chars.each do |c|
	case c
	when 'L'
		left
	when 'D'
		# not needed
	when 'R'
		right
	when 'U'
		# not needed
	end
end
$last_direction = $direction

# now figure out the final position
# for speed, collapse runs of Advances before actually doing them

def run(cmd_str)
	cmd_str.chars[$last_run_idx..-1].join('').match(/([RL]*)(A+)/)
end

def handle_turns_chars(turns_chars)
	turns_chars.each do |c|
		case c
		when 'L'
			left
		when 'D'
			# not needed
		when 'R'
			right
		when 'U'
			# not needed
		end
	end
end

$movements = []
$last_run_idx = 0
$next_run = run(cmd_str) ? run(cmd_str) : :null
while $next_run != :null
	# first handle previous directions
	$direction = init_dir
	turns = cmd_str.chars[0...$last_run_idx].select { |t| t == 'L' || t == 'D' || t == 'R' || t == 'U' }.join('')
	handle_turns_chars(turns.chars)
	
	this_run = run(cmd_str)
	
	turns = this_run[1]
	num_advances = this_run[2].size
	handle_turns_chars(turns.chars)
	dir = $direction.clone
	$movements << [dir, num_advances]
	$last_run_idx = $last_run_idx + this_run.end(0) # index after end
	
	$next_run = run(cmd_str) ? run(cmd_str) : :null
end

# split movements into x and y movements so x and y are only set once
y_movs, x_movs = $movements.partition { |m| m[0] == 'U' || m[0] == 'D' }
last_x = x_movs.inject(init_x) { |x, mov| mov[0] == 'L' ? x - mov[-1] : x + mov[1] }
last_y = y_movs.inject(init_y) { |y, mov| mov[0] == 'D' ? y - mov[-1] : y + mov[1] }

puts "#{last_x} #{last_y} #{intuitive_dir_to_map_dir($last_direction)}"
