## v-skratch

A dedicated volatco playground.

### Characteristics

Version VOL00-0001a of this board has two GA144 multicomputer chips, 2 MB SRAM, 16 MB SPI flash, 2 MB NOR flash capable of running polyFORTH®; a reset/watchdog circuit, and settings-jumpers for selecting development or operational modes, for measuring power consumption, and for resetting the board. Power, in the form of 1.80 VDC is applied via two sets of pins off-board and there are no onboard regulators.

All I/O, including that necessary for commissioning the board and developing software, is off-board and reached via 2.54mm headers.

`chip 1` - `target` - has 25 `GPIO`, 10 analog in `Ain`, and 10 analog out `Aout` pins available to polyForth applications, without having to contend with the bus pins' characteristics. If absolutely necessary: Several of the pins on `chip 0` could be made available. The design of the board is founded upon two primary design constraints:

1. Minimize energy consumption.
2. Minimize PCB size.

More details will be published as they are made available.

### Patterns

* Mood (Happy, Neutral, Sad)
* Emit (sound)
* Moves

### Sections

The 'tests' folder is the working-area for code development while using Gforth; polyForth is still an open-question. They are organized according to the 'cooperation scenarios' document:

* `A-01` - First task
    - Await/analyze command phrase
* `B-01` - Second task
    - Move toward voice/sound
    - Detected spatially in the last task
* `C-01` - Third task
    - Execute animation
    - One of seven possibilities
    - Three are implemented
        - 'come here'
        - 'dance'
* `D-01` - Fourth task
    - Await vocal indicative feedback
    - Detected audially post-third task (animation)
    - Staring-point for Ideal
        - Was the feedback positive or negative?

_Example_

* Copy the desired forth word to be tested into the `tests` folder.
* Use the terminal: `forth pcm-analyze.f`.
* Tune the algorithm that word detection is suitably reliable to be field-tested.

### Tasks

Record what should be for the machine in Audacity. Export to `*.wav` file, naming by functional placement.

_A-01: Decomposing a `wav` file_

```
ffmpeg -i ref.wav -f s16le -ac 1 -ar 16000 ref.raw
ffmpeg -i test.wav -f s16le -ac 1 -ar 16000 test.raw
```
