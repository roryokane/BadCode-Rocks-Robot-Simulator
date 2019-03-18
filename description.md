The problem description: http://badcode.rocks/2018/337/robot-simulator/

Misfeatures of my program:

- redundant work for “simplicity” or “optimization”, such as calculating direction and position separately
- `run` is called four times for every single time it needs to be called; the other three results are discarded
- Reuses global variable `$direction` instead of passing it as a parameter, preventing code from being reordered. Has other unnecessarily global variables.
- Mixes up the values for current directions and instructions to turn – both are called “left” and “right” instead of calling one “east” and “west”.
- poorly named methods
    - `left` instead of `turn_left` and `right` instead of `turn_right`
    - `handle_turns_chars(turns_chars)` instead of `make_turns(turns)` or `change_direction_with_turns(turns)`
    - `run` instead of `find_run` or `find_run_of_advances` – it sounds like it runs (executes) the commands, but that comes later
    - `direction?` instead of `is_a_direction?`
- `ARGV` processing is overly DRY; it’s more complicated than the equivalent four lines assigning the four variables
- deduplicates some code into `handle_turns_chars`, but fails to realize that it is almost the same as the initial calculation of `last_direction`
- The snippet `this_run.end(0) # index after end` is just a confusing way of writing `this_run[0].size`. It is equivalent because the match always starts at index 0 of the sliced `cmd_str`.
- pointless distinction between `mov[-1]` and `mov[1]` in the two-element `mov` array near the end
- unidiomatic Ruby
    - unnecessary `clone` of `$direction` before assigning to `dir`; `clone` does nothing on `Numeric`s anyway
    - unnecessary `dir =` assignment of `case` statements who were going to be returned anyway, or whose result is ignored anyway
    - when slicing string ranges, uses `.chars[…].join('')` to split characters in the string and then join them after instead of just using `[…]`
    - uses `eval` instead of `to_i`; classic JavaScript mistake ported to Ruby
    - use of `.chars.each` instead of `.each_char`
    - Uses symbols `:not_init` and `:null` instead of nil. They document the purpose, but at what cost?
    - uses `reduce` where `inject` is more appropriate (minor style nit)
    - fails to use `+=` when setting `$last_run_idx`
- excessive or redundant initial magic comments, not used in such a short program

To run the tests:

~~~sh
./test.sh ./bad_robot_simulator.rb
~~~
