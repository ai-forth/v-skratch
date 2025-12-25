## Level shifter

* Starting from [here](https://www.instructables.com/Single-Transistor-Voltage-Level-Shifter/)

![circuit](/circuits/level-shift/circuit.jpg)

![board](/circuits/level-shift/board.jpg)

### Tasking

Begin by charting the actual levels of the devices on-hand:

* Sound sensor - 
* Light sensor - 
* Ultra sensor - 

### 3V3 to 1V8

* Parts
    - [1] 2N2222
    - [4] 3.6kΩ voltage divider
* Implementation
    - Connect the source of the MOSFET to ground
    - Use the 3.3V side for the gate
    - Connect the drain to the 1.8V logic side
    - Add pull-up resistors (10kΩ-47kΩ) to ensure clean signal transitions

### 5V0 to 1V8

Some advice [here](https://electronics.stackexchange.com/questions/677958/level-shifting-to-lower-voltage-logic-gate-vs-voltage-divider) and [theory](https://analogcircuitdesign.com/level-shifter-circuit/#level-shifter-50v-to-33v).

![image](/circuits/level-shift/5v-1v8.jpg)

* Parts
    - [1] 74LVC244A
    - [4] ?