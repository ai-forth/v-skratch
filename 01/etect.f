\ ============================================================
\  Voice‑command detector – “come here”
\  Pure Forth, works on a pre‑recorded raw PCM file.
\  Tested with Gforth 0.7.3 on Linux/macOS/Windows.
\ ============================================================

\ -------------------  USER SETTINGS  -----------------------
16000 constant SAMPLE-RATE          \ Hz – must match your audio files
2      constant BYTES-PER-SAMPLE    \ 16‑bit = 2 bytes

s" ref.raw"   constant REF-FILE     \ reference template (come here)
s" test.raw"  constant TEST-FILE    \ file you want to scan

0.80 fconstant THRESHOLD          \ correlation threshold (tune as needed)
\ -----------------------------------------------------------

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
        dup 32768 -                   \ signed conversion
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

\ -------------------  FP math helpers  --------------------
\ dot‑product of two equal‑length integer vectors → float
: dot-f ( a-addr b-addr n -- r )
    0.0e0 0 do
        dup i cells + @ s>f          \ a[i] → float
        swap i cells + @ s>f          \ b[i] → float
        f* f+                        \ accumulate a[i]*b[i]
    loop nip nip ;                    \ leave result on FP stack

\ Euclidean norm of an integer vector → float
: norm-f ( a-addr n -- r )
    0.0e0 0 do
        dup i cells + @ s>f dup f* f+   \ x² accumulated as float
    loop nip sqrt ;                     \ sqrt of sum of squares

\ Normalised cross‑correlation (float in –1..1)
: corr-f ( a-addr b-addr n -- r )
    >r >r >r                         \ keep lengths on return stack
    r@ r@ r@ dot-f                    \