## v

A voltage divider is a simple electronic circuit that reduces a higher voltage to a lower voltage. It typically consists of two resistors connected in series. The output voltage is taken from the junction between the two resistors.

* Resistors (R1 and R2): The two resistors are connected in series. The input voltage (Vin) is applied across the series combination, and the output voltage (Vout) is measured across R2.

The output voltage can be calculated using the formula:

$$ V_{out} = V_{in} \cdot \frac{R_2}{R_1 + R_2} $$

This equation shows that the output voltage is a fraction of the input voltage, determined by the ratio of the resistors.

## Level shifter

* Starting from [here](https://www.instructables.com/Single-Transistor-Voltage-Level-Shifter/)

![circuit](/circuits/level-shift/circuit.jpg)

![board](/circuits/level-shift/board.jpg)

Logic levels to be read by leveraging the Digilent Analog Discovery 2.

### Tasking

The oscilloscope is extra powered by the battery. The devices will consume power from the Begin by charting the actual levels of the devices on-hand:

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