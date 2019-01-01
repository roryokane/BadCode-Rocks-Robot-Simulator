The problem description: http://badcode.rocks/2018/337/robot-simulator/

Misfeatures of my program (some implemented, some planned, some just ideas):

- bad code on purpose
- redundant work for “simplicity” or “optimization”, such as calculating direction and position separately
- `run` is called four times for every single time it needs to be called; the other three results are discarded
- reuses global variable `$direction`; has other unnecessarily global variables
- mixes up the values for current directions and instructions to turn – both are called “left” and “right” instead of calling one “east” and “west”.
- poorly named methods – `left` instead of `turn_left`, `handle_turns_chars` instead of `make_turns`
- deduplicates some code into `handle_turns_chars`, but fails to realize that it is almost the same as the initial calculation of `last_direction`
- unidiomatic Ruby
    - unnecessary `clone` of the global variable; `clone` does nothing on `Number`s anyway
    - doesn’t index string ranges; splits and joins chars first
    - uses symbols instead of nil
- excessive or redundant initial magic comments, not used in such a short program

