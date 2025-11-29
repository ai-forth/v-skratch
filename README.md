## v-skratch

A playground for the poor and ignominious.

### Sections

_01_

```
ffmpeg -i ref.wav -f s16le -ac 1 -ar 16000 ref.raw
ffmpeg -i test.wav -f s16le -ac 1 -ar 16000 test.raw
```

_Example_

* Copy the desired forth word to be tested into the `tests` folder.
* Use the terminal: `forth pcm-analyze.f`.
* Tune the algorithm that word detection is suitably reliable to be field-tested.
