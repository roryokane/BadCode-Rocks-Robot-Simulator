The problem description: http://badcode.rocks/2018/337/robot-simulator/

Misfeatures of my program (some implemented, some planned, some just ideas):

- bad code on purpose
- redundant work for “simplicity” or “optimization”
- reuses global variable $direction
- Try to mix up the values for current directions and instructions to turn – both will be called “left” and “right” instead of calling one “east” and “west”.
- unidiomatic Ruby?



deleted debug code:


