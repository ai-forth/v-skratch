## v-skratch

A dedicated volatco playground.

### Characteristics

We decided that version VOL00-0000a of this board would have two GA144 chips and essentially be a cost- and size-reduced version of the EVB002 board, capable of running polyFORTH®. In addition to the two GA144s, 2 MB SRAM and 16 MB SPI flash, the board has a reset/watchdog circuit and minimal jumpers for selecting development or operational modes, for measuring power consumption, and for resetting the board. Power comes from off-board; there are no onboard regulators. All I/O, including that necessary for commissioning the board and developing software, is off-board and reached via 0.1" headers.

The only I/O pins that are not brought to these headers are the 36 lines of parallel "bus" connections on chip 1 ("target"). 

It's deemed that the 25 GPIO, 10 analog in and 10 analog out pins should suffice for this application without having to contend with the bus pins' characteristics. And, if absolutely necessary, several of the pins on chip 0 might also be available. Other than the above functionality, there were two design constraints:

1. Minimize energy consumption.
2. Minimize PCB size.

More details will be published as they are made publically-available.

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
