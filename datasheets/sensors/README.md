### The array of sensors to be implemented

The Forth-X Robot will possess the following sensors for its operational paradigm:

* [GRL-12503](https://botland.store/content/158-Photoresistor-and-Arduino) Digital light sensor with regulation via photoresistor and potentiometer
* [MOD-06638](https://botland.store/microphones-and-sound-detection/6638-sound-sensor-digital-5v-5904422359829.html) Sound sensor and folllower
* [MOD-01420](https://botland.store/ultrasonic-distance-sensors/1420-ultrasonic-distance-sensor-hc-sr04-2-200cm-justpi-5903351241366.html) Ultrasonic distance sensor

_Pinouts_

![light](/datasheets/sensors/light-sensor.jpg)
| PIN | Description                      |
|-----|----------------------------------|
| D0  | Digital signal.                  |
| GND | The ground of the system.        |
| VCC | Supply voltage from 3.3 V to 5V. |

![sound](/datasheets/sensors/sound-sensor.jpg)
| Pin | Description                                                                                |
|-----|--------------------------------------------------------------------------------------------|
| GND | The ground of the system.                                                                  |
| OUT | The digital output signal, the sensitivity is adjusted using the integrated potentiometer. |
| +5V | Voltage: 5 V.                                                                              |

![ultrasonic](/datasheets/sensors/ultrasonic-sensor.jpg)
| Pin  |        Description        |
|------|:-------------------------:|
|  VCC |        Voltage: 5V        |
|  GND | The ground of the system. |
| TRIG |       Trigger input       |
| ECHO |        Echo output        |

Ultrasonic sensor working in the range of 2-200 cm. Powered with voltage of 5 V. The output is a signal whose duration is proportional to the measured distance. Application [notes](https://botland.store/content/144-Distance-measurement-using-Arduino-and-HC-SR04-sensor). User's implementation guide is [here](/datasheets/sensors/HC-SR04.pdf).