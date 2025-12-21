## DF Robot motors for the robot

Both platforms use the DFRobot [FIT0450](https://wiki.dfrobot.com/Micro_DC_Motor_with_Encoder-SJ01_SKU__FIT0450) motor with encoder.

![pinout](/datasheets/motor-encoder/FIT0450.png)

| Pin   | Name                     | Functional Description                                                       |
|-------|--------------------------|------------------------------------------------------------------------------|
| 1     | Motor power supply pin + | 3-7.5V，Rated voltage6V                                                      |
| 2     | Motor power supply pin - |                                                                              |
| 3     | Encoder A phase output   | Changes square wave with the output frequency of Motor speed                 |
| 4     | Encoder B phase output   | Changes square wave with the output frequency of Motor speed(interrupt port) |
| 5     | Encoder supply GND       |                                                                              |
| 6     | Encoder supply +         | 4.5-7.5V                                                                     |

## Using G3VM-61BR2 for High Current Motors
```
   1.8V Source
       |
       R1 (68 Ω)
       |
     -----LED (Input)
     |          
     |          GND
     |
     |  Phototransistor
     |     (Output)
     |
     +---|-----|--- Base of NPN Transistor
     |   |     |
     |   Rb    |
    6.4V   Motor
     |       |
     |       | 
     +-------+----+
     |  Flyback Diode|
     +----------------+
```

## Current Draw Above 50mA

If the current draw of your motor exceeds **50 mA**, you'll need to incorporate additional components to ensure safe and effective operation. Here are some options:

## Using a Transistor or Relay

### 1. Transistor as a Switch

You can use an external transistor to switch the motor on and off. This way, the phototransistor in the **G3VM-61BR2** only needs to drive the base of the external transistor.

#### Circuit Design

- **Components Needed:**
  - NPN Transistor (e.g., **2N2222**, **TIP120**)
  - Flyback Diode (for motor protection, e.g., **1N4007**)
  - Resistor for the base of the transistor (Rb)

#### Schematic Overview

1. **Input Circuit:**
   - Connect the input side of the opto-isolator as before.

2. **Output Circuit:**
   - Connect the collector of the phototransistor to the base of the NPN transistor through the base resistor (Rb).
   - Connect the emitter of the NPN transistor to ground.
   - Connect the motor and a flyback diode in series with the power supply to the collector of the NPN transistor.

#### Example Calculation for Base Resistor (Rb)

If you use a transistor with a current gain of 100 (common for small NPN transistors), and your motor draws **200 mA**:
- Current through the base (Ib) must be:
  \[
  Ib = \frac{Ic}{\text{hFE}} = \frac{200 \text{ mA}}{100} = 2 \text{ mA}
  \]
- Voltage across the base resistor (assuming the base-emitter voltage drop (Vbe) is about 0.7 V):
  \[
  Rb = \frac{V_{source} - V_{be}}{Ib} = \frac{1.8 - 0.7}{0.002} = 550 \, \Omega
  \]
- Use a standard resistor value of **560 Ω**.

### 2. Using a Relay

If the current draw is significantly higher, or if isolation is critical, consider using a relay:

#### Circuit Design

1. **Input Circuit:**
   - Connect the opto-isolator as before.

2. **Relay Control:**
   - Use a relay with a coil rating compatible with the output from the opto-isolator to switch on the motor.
   - Connect the relay contacts in series with the motor and the power supply.

3. **Flyback Diode:**
   - Place a flyback diode across the relay coil to protect against voltage spikes.

### Schematic Representation

In both cases, the schematic will look similar to the earlier designs but with a transistor or relay included to handle the higher current.

## Summary

- If your motor's current draw exceeds **50 mA**, using an external transistor or relay allows you to control larger loads safely.
- Always include protection diodes for inductive loads to safeguard your components.
