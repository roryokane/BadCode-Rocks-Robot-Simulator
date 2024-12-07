# Robot Simulator – BadCode.rocks 2018-12 contest entry

This is a program `bad_robot_simulator.rb` that crams as many **mistakes, misfeatures, and bad design decisions** as I could into a program that nonetheless gets the right output. **[Read the code][bad_code]** and weep in relief that you don’t have to work with code like this (or in despair that you do).

It was written for fun and as an entry for the contest [BadCode.rocks](https://web.archive.org/web/20210919051317/https://badcode.rocks/) for the month of 2018-12, and it **[won an Honorable Mention](https://web.archive.org/web/20210507080726/https://badcode.rocks/2019/025/december-teardown-robot-simulator/)** for that month:

> It was a close race this time, so we’ll take more time than usual to talk about our runner-up. [In Ruby, from Rory O’Kane](https://web.archive.org/web/20190328060658/https://snark.badcode.rocks/archives/2019-January/000026.html), this submission had some basic stuff: inconsistently formatted magic comments (though the presence of those comments in Ruby is almost a good practise, for shame!), use of eval to parse numbers, many global variables, useless assignments, and changing the input to another format for no good reason.
>
> The really impenetrable, truly bad part of this submission though, is the final algorithm to determine the robot’s position. Combining a global variable with an algorithm that re-processes already-handled instructions over and over in a loop, it took our judges several read-throughs to understand why this code worked at all. Impossible to understand without being hard to read, this is exactly the kind of bad code this competition is all about.

The [contest prompt](https://web.archive.org/web/20210507070353/https://badcode.rocks/2018/337/robot-simulator/) was to write a program simulating a robot moving around a grid. The robot is given starting coordinates, a starting orientation (north, south, east or west), and a list of instructions to follow. The supported instructions are “advance one space forward”, “turn left 90°”, and “turn right 90°”. The expected output of the program is the robot’s new coordinates and orientation. For example, running the program with initial state `0 0 N` and the instructions `RA` (turn right, advance) should leave the robot at `1 0 E`.

## What makes this code bad?

A comprehensive list of misfeatures in my implementation [`bad_robot_simulator.rb`][bad_code]:

[bad_code]: ./bad_robot_simulator.rb

- redundant work for “simplicity” or “optimization”, such as calculating direction and position separately
- `run` is called four times for every single time it needs to be called; the other three results are discarded
- Reuses global variable `$direction` instead of passing it as a parameter, preventing code from being reordered and making the program harder to understand. This comes into play in the final `while` loop, which sets `$direction` and then calls a method that eventually calls the previously-defined `left` and `right` methods that change `$direction`. The program also has other unnecessarily global variables.
- Converts the input directions (NESW) into a different data format (URDL) and does the reverse conversion before output, but this “intuitive” data format is not worth the high amount of code used for the conversion.
    - Background: I only came up with this data format because I started writing the program without remembering the full problem description and chose the set of characters that was more intuitive to me. When I reread the problem description, I realized it would make the program more interesting if I converted the data to work with my existing code than to edit my program to handle the native data.
- Mixes up the values for current directions and instructions to turn – both are called “left” and “right” instead of calling one “east” and “west”.
    - This results in useless empty `# not needed` lines for handling `'U'` and `'D'` directions to turn. Those cases could have been omitted from the code.
- poorly named methods
    - `left` instead of `turn_left` and `right` instead of `turn_right`
    - `handle_turns_chars(turns_chars)` instead of `make_turns(turns)` or `change_direction_with_turns(turns)`
    - `run` instead of `find_run` or `find_run_of_advances` – it sounds like it runs (executes) the commands, but that comes later
    - `direction?` instead of `is_a_direction?`
- `ARGV` processing is overly DRY; it’s more complicated than the equivalent four lines assigning the four variables
    -   The de-abstracted version of that code is easier to understand and debug:
        
        ~~~ruby
        init_x = eval(ARGV[0])
        init_y = eval(ARGV[1])
        init_dir = map_dir_to_intuitive_dir(ARGV[2])
        cmd_str = ARGV[3]
        ~~~

- deduplicates some code into `handle_turns_chars`, but fails to realize that it is almost the same as the initial calculation of `last_direction`
- The snippet `this_run.end(0) # index after end` is just a confusing way of writing `this_run[0].size`. It is equivalent because the match always starts at index 0 of the sliced `cmd_str`.
    - This comment `# index after end` is also confusing because it looks like it could describe the whole line, which references the relevant-sounding variable `$last_run_idx`, while it actually describes only some of the code at the end of the line.
- pointless distinction between `mov[-1]` and `mov[1]` in the two-element `mov` array near the end – they both refer to the same element of `mov`
- unidiomatic Ruby
    - unnecessary `clone` of `$direction` before assigning to `dir`; `clone` does nothing on `Numeric`s anyway
    - unnecessary `dir =` assignment of `case` statements who were going to be returned anyway, or whose result is ignored anyway
    - when slicing string ranges, uses `.chars[…].join('')` to split characters in the string and then join them after instead of just using `[…]`
    - uses `eval` instead of `to_i`; classic JavaScript mistake ported to Ruby
    - use of `.chars.each` instead of `.each_char`
    - Uses symbols `:not_init` and `:null` instead of `nil`. Those custom symbols document the purpose of the value, but at the cost of surprising any reader who knows Ruby.
    - uses `reduce` where `inject` is more appropriate (minor style nit)
    - fails to use `+=` when setting `$last_run_idx`
- excessive or redundant initial magic comments, not used in such a short program
    - the first one is formatted differently from the others for no reason
    - The last comment, “by: Rory O’Kane”, initially looks like a magic comment to due to being formatted similarly to the magic comments above, but it has no effect on the interpreter.
- Overly repetitive verbose code in `left` and `right` to find the new direction – a hash-map of old directions to new directions would have made each method simpler.
- Useless capturing groups in the regex `/([RL]*)(A+)/` within `run`. `/ [RL]* A+ /x` would be easier to read and would probably run faster due to not saving the capture groups.

## How to run the code

To run the tests, which confirm that the program works despite all the above flaws:

~~~sh
./test.sh ./bad_robot_simulator.rb
~~~

To call the program directly, make sure Ruby is installed, then pass four arguments: initial x position, initial y position, initial direction, and command string. An example call and its output:

~~~sh
$ ./bad_robot_simulator.rb 0 0 N "RA"
1 0 E
~~~

You can see more examples of valid command-line arguments in [`test.sh`](./test.sh).

## My other Robot Simulator implementations

If you need to cleanse the bad taste from your mouth, you can read my attempts at writing actually good solutions. They’re in this repository. I think of those two other solutions, the program [`good robot simulator, mutable state (Bad Code Rocks version of Exercism problem).rb`][best_code] is the better one.

[best_code]: ./good%20robot%20simulator,%20mutable%20state%20(Bad%20Code%20Rocks%20version%20of%20Exercism%20problem).rb

## License for `bad_robot_simulator.rb`

This work is licensed under the Creative Commons Attribution 4.0 International License. To view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
