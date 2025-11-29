\ ==============================================================
\  Voice‑command detector – “come here”
\  Pure Forth, fixed‑point arithmetic only
\  Tested with Gforth 0.7.3 on Linux/macOS/Windows
\ ==============================================================

\ -------------------  USER SETTINGS  -------------------------
16000 constant SAMPLE-RATE          \ Hz – must match your audio files
2      constant BYTES-PER-SAMPLE    \ 16‑bit = 2 bytes

s" ref.raw"   constant REF-FILE     \ reference template (come here)
s" test.raw"  constant TEST-FILE    \ file you want to scan

\ Fixed‑point parameters
14 constant FRAC-BITS                \ number of fractional bits
1 FRAC-BITS lshift constant SCALE    \ 2^FRAC-BITS  (16384)

\ Scaled detection threshold (0.80 → 0.80 * SCALE)
0.80e0 f>s FRAC-BITS lshift * constant THRESHOLD-FIXED
\ --------------------------------------------------------------

\ ----------  Helper: read raw 16‑bit PCM into a cell array ----------
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

\ -------------------  Load files  -------------------------
REF-FILE load-raw constant REF-ADDR   \ address of reference samples
REF-ADDR swap constant REF-LEN        \ number of samples in reference

TEST-FILE load-raw constant TEST-ADDR \ address of test samples
TEST-ADDR swap constant TEST-LEN      \ number of samples in test file

\ -------------------  Integer math helpers  --------------------
\ 64‑bit multiply: a*b → high 64‑bit result (we only need low part)
: umul64 ( u1 u2 -- ud )  \ unsigned 64‑bit product (low part)
    >r >r                \ keep operands on return stack
    r@ r@ *               \ 32‑bit * 32‑bit → 64‑bit (Gforth auto‑promotes)
    r> r> 2drop ;        \ drop the copies we saved

\ Integer square root (Newton method, works for 64‑bit values)
: isqrt ( ud -- u )
    dup 0= if drop 0 exit then
    1 swap 2/ 1+          \ initial guess = (n/2)+1
    begin
        dup 2/ over +      \ (guess + n/guess) / 2
        2/ dup >r          \ new guess
        over over >        \ old_guess^2 > n ?
    while
        r> drop
    r