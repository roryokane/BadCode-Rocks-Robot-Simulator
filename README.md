The problem description: http://badcode.rocks/2018/337/robot-simulator/

Misfeatures of my program:

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

To run the tests:

~~~sh
./test.sh ./bad_robot_simulator.rb
~~~
