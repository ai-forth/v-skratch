\ ------------------------------------------------------------
\ Load a raw 16‑bit PCM file into a cell array (fixed‑point version)
\ ------------------------------------------------------------
: load-raw ( c-addr u -- addr n )
    r/o open-file throw               \ 1. Open the file → (fid ior)
    dup >r                            \ Save the file identifier on the return stack

    \ 2. Get the file size (in bytes)
    r@ file-size@                     \ (fid bytes)

    \ 3. Convert bytes → number of 16‑bit samples
    2/ 2/                             \ each sample = 2 bytes, mono → divide twice

    dup cells allocate throw          \ Allocate space for that many cells
    dup >r                            \ Keep the buffer address on the return stack

    \ 4. Read the whole file into the buffer
    r@ swap >r                        \ (fid addr n) → move n to the return stack
    r@ read-file throw                \ read n bytes into addr
    drop                              \ discard the actual byte count returned by read-file

    \ 5. Convert raw bytes (little‑endian) to signed 16‑bit integers
    0 do
        r@ i cells +                  \ address of ith cell
        dup i 2* + @c@                 \ low byte
        swap i 2* 1+ + @c@             \ high byte
        256 * +                       \ combine low+high
        dup 32768 -                   \ signed conversion (‑32768…32767)
        swap !                        \ store as 32‑bit integer
    loop

    r> r> r>                         \ clean up: drop fid, buffer addr, file id
    close-file throw                 \ close the file
    swap ;                           \ leave (addr n) on the stack