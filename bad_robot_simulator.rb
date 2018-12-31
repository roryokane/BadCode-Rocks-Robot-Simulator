#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# frozen_string_literal: true
# warn_indent: true

$direction = :not_init

def map_dir_to_intuitive_dir(dir)
	dir = case dir
	when 'N'
		'U'
	when 'E'
		'R'
	when 'S'
		'D'
	when 'W'
		'L'
	end
end

def intuitive_dir_to_map_dir(dir)
	dir = case dir
	when 'U'
		'N'
	when 'R'
		'E'
	when 'D'
		'S'
	when 'L'
		'W'
	end
end

init_x = eval(ARGV[0])
init_y = eval(ARGV[1])
init_dir = map_dir_to_intuitive_dir(ARGV[2])
cmd_str = ARGV[3]

$direction = init_dir

def turn_right # TODO rename to “right” at end
	case $direction
	when 'R'
		$direction = 'D'
	when 'D'
		$direction = 'L'
	when 'L'
		$direction = 'U'
	when 'U'
		$direction = 'R'
	end
end

def turn_left # TODO rename to “left” at end
	case $direction
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
	if c == 'R'
		turn_right
	elsif c == 'L'
		turn_left
	end
end
$last_direction = $direction

# now figure out the final position
# for speed, collapse runs of Advances before actually doing them

def run(cmd_str)
	cmd_str.chars[$last_run_idx..-1].join('').match(/([RL]*)(A+)/)
end

$movements = []
$last_run_idx = 0
$next_run = run(cmd_str) ? run(cmd_str) : :null
#$stderr.puts ['debug: before loop', $last_run_idx, $next_run, cmd_str].inspect
$direction = init_dir
while $next_run != :null
	#$direction = init_dir # TODO Should I do this here? I had originally planned to reset the direction and calculate it from scratch for each run, by ignoring 'A' before that position in the regex and keeping only the turns to recalculate. My current code goes each segment at a time, which would require removing this initializion so that direction can be tracked (globally) between runs. Which is worse (better)?
	
	this_run = run(cmd_str)
	#$stderr.puts ['debug: in loop', $last_run_idx, this_run].inspect
	
	turns = this_run[1]
	num_advances = this_run[2].size
	#$stderr.puts ['debug: direction before turns', $direction].inspect
	turns.chars.each do |c|
		if c == 'R'
			turn_right
		elsif c == 'L'
			turn_left
		end
	end
	#$stderr.puts ['debug: direction after turns', $direction].inspect
	dir = $direction.clone
	$movements << [dir, num_advances]
	#$stderr.puts ['debug: movements edited', $movements].inspect
	$last_run_idx = $last_run_idx + this_run.end(0) # index after end
	
	$next_run = run(cmd_str) ? run(cmd_str) : :null
end

# split movements into x and y movements so the program can set x and y separately
#$stderr.puts ['debug: movements', $movements].inspect
y_movs, x_movs = $movements.partition { |m| m[0] == 'U' || m[0] == 'D' }
last_x = x_movs.inject(init_x) { |x, mov| mov[0] == 'L' ? x - mov[-1] : x + mov[1] }
last_y = y_movs.inject(init_y) { |y, mov| mov[0] == 'D' ? y - mov[-1] : y + mov[1] }

puts "#{last_x} #{last_y} #{intuitive_dir_to_map_dir($last_direction)}"
