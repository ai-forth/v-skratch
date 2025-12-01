## v-skratch

A playground for the poor and ignominious.

### Sections

The 'tests' folder is the working-area for code development while using Gforth; polyForth is still an open-question. They are organized according to the 'cooperation scenarios' document:

* A-01 - First task
    - Await/analyze command phrase
* B-01 - Second task
    - Move toward voice/sound
    - Detected spatially in the last task
* C-01 - Third task
    - Execute animation
    - One of seven possibilities
    - Two are implemented
        - 'come here'
        - 'dance'
* D-01 - Fourth task
    - Await vocal indicative feedback
    - Detected audially post-third task (animation)
    - Staring-point for Ideal
        - Was the feedback positive or negative?

_Example_

* Copy the desired forth word to be tested into the `tests` folder.
* Use the terminal: `forth pcm-analyze.f`.
* Tune the algorithm that word detection is suitably reliable to be field-tested.

### Tasks

_01: Decomposing a `wav` file_

```
ffmpeg -i ref.wav -f s16le -ac 1 -ar 16000 ref.raw
ffmpeg -i test.wav -f s16le -ac 1 -ar 16000 test.raw
```
