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
: load-raw ( c-addr u -- addr n )
    r/o open-file throw               \ open for reading
    dup file-size@ 2/ 2/             \ bytes → number of 16‑bit samples
    dup cells allocate throw          \ allocate space for samples (cells = 32‑bit)
    dup >r                            \ keep address on stack

    0 do                              \ read sample by sample
        r@ i cells +                  \ address of ith cell
        2 pick read-file throw        \ read 2 bytes
        dup 0= if leave then          \ EOF guard (should not happen)
        dup c@ 256 * swap 1+ c@ +     \ little‑endian combine
        dup 32768 -                   \ signed conversion (‑32768…32767)
        swap !                        \ store as 32‑bit integer
    loop
    r> swap                           \ (addr n)
    close-file throw
    drop ;                            \ discard filename string

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