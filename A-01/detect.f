\ ------------------------------------------------------------
\  CONFIGURATION
\ ------------------------------------------------------------
16000 constant SAMPLE-RATE          \ Hz – must match your audio files
2      constant BYTES-PER-SAMPLE    \ 16‑bit = 2 bytes
\ ------------------------------------------------------------
\  USER SETTINGS – change these to point at your files
\ ------------------------------------------------------------
s" ref.raw"   constant REF-FILE     \ reference template (come here)
s" test.raw"  constant TEST-FILE    \ file to scan
0.80 fconstant THRESHOLD          \ correlation threshold (tune)

\ ------------------------------------------------------------
\  Utility: read a raw PCM file into a cell array
\ ------------------------------------------------------------
: load-raw ( c-addr u -- addr n )
    r/o open-file throw               \ open for reading
    dup file-size@                    \ total bytes in file
    2/ 2/ 2/                         \ convert bytes → number of 16‑bit samples
    dup cells allocate throw           \ allocate space for samples (cells = 32‑bit)
    dup >r                            \ keep address on stack
    0 do                              \ read sample by sample
        dup i cells +                \ address of ith cell
        2 pick read-file throw       \ read 2 bytes
        dup 0= if leave then
        dup c@ 256 * swap 1+ c@ +    \ combine low/high bytes (little‑endian)
        dup 32768 -                  \ signed conversion
        swap !                       \ store as 32‑bit integer
    loop
    r> swap                          \ (addr n)
    close-file throw ;

\ ------------------------------------------------------------
\  Load reference and test buffers
\ ------------------------------------------------------------
REF-FILE load-raw constant REF-ADDR   \ address of reference samples
REF-ADDR swap constant REF-LEN        \ number of samples in reference

TEST-FILE load-raw constant TEST-ADDR \ address of test samples
TEST-ADDR swap constant TEST-LEN      \ number of samples in test file

\ ------------------------------------------------------------
\  Math helpers (floating‑point)
\ ------------------------------------------------------------
: f>i ( r -- n ) f>d drop ;          \ truncate float → integer
: i>f ( n -- r ) s>f ;                \ integer → float

\ ------------------------------------------------------------
\  Normalised cross‑correlation for two equal‑length vectors
\ ------------------------------------------------------------
: dot-product ( a-addr b-addr n -- d )
    0.0e0 0 do
        dup i cells + @               \ a[i]
        swap i cells + @ * f+          \ accumulate a[i]*b[i]
    loop nip nip f> ;                 \ result as float

: vec-norm ( a-addr n -- r )
    0.0e0 0 do
        dup i cells + @ dup * f+      \ sum of squares
    loop nip sqrt ;                   \ sqrt(sum(x^2))

: correlation ( a-addr b-addr n -- r )
    >r >r >r                         \ keep lengths on return stack
    r@ r@ r@ dot-product              \ numerator
    r@ r@ vec-norm f*                 \ denominator = ||a||*||b||
    f/ ;                             \ final correlation (-1 .. 1)

\ ------------------------------------------------------------
\  Sliding‑window detector
\ ------------------------------------------------------------
: detect-in-test ( -- )
    TEST-LEN REF-LEN - 0 max          \ number of possible windows
    0 do
        TEST-ADDR i +                 \ start of window
        REF-ADDR REF-LEN correlation   \ compute correlation
        dup THRESHOLD f> if           \ above threshold?
            ." 👣 Detected \"come here\" at sample "
            i REF-LEN + . cr          \ report approximate position
        then
        drop
    loop ;

\ ------------------------------------------------------------
\  Run it
\ ------------------------------------------------------------
cr ." Loading reference (" REF-FILE ." )…" cr
cr ." Loading test file (" TEST-FILE ." )…" cr
detect-in-test
cr ." Done." cr