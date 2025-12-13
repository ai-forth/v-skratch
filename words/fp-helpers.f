\ --------------------------------------------------------------
\ Fixed point helpers - dot library
\ --------------------------------------------------------------
14 constant FRAC-BITS                \ 14 fractional bits → SCALE = 16384
1 FRAC-BITS lshift constant SCALE

\ Unsigned 64bit multiply (low part only – sufficient here)
: umul64 ( u1 u2 -- ud )  >r >r  r@ r@ *  r> r> 2drop ;

\ Integer square root (Newton method)
: isqrt ( ud -- u )
    dup 0= if drop 0 exit then
    1 swap 2/ 1+                     \ initial guess
    begin
        dup 2/ over + 2/
        2dup >r >r
        over over >
    while
        r> drop
    repeat
    r> drop ;

\ Dot product of two integer vectors → 64‑bit result (hi lo)
: dot64 ( a-addr b-addr n -- ud )
    0 0 0 do
        dup i cells + @               \ a[i]
        swap i cells + @              \ b[i]
        smultiply                     \ 32×32 → 64‑bit (hi lo)
        rot rot + >r >r                \ add low parts, carry high parts
        r> r> + >r >r
    loop
    r> r> ;

\ Sum of squares → 64‑bit result (hi lo)
: sumsq64 ( a-addr n -- ud )
    0 0 0 do
        dup i cells + @               \ x
        dup *                         \ x*x
        >r >r                         \ add low part, carry high part
        r> r> + >r >r
    loop
    r> r> ;

\ Normalised correlation in fixed‑point
\ Returns an integer in range [-SCALE .. SCALE]
: corr-fixed ( a-addr b-addr n -- corr )
    >r >r >r                         \ keep lengths on return stack
    r@ r@ r@ dot64                    \ numerator (hi lo)
    r@ sumsq64 r@ sumsq64             \ denom_a , denom_b
    isqrt swap isqrt                  \ sqrt_a sqrt_b
    umul64                            \ denominator (hi lo)

    \ Shift numerator left by FRAC_BITS (14) to restore fraction
    2dup 0= if drop drop 0 exit then
    2dup 14 lshift swap 64 14 - rshift or >r   \ new_hi
    2dup 14 lshift >r                         \ new_lo

    \ 128‑by‑64 division: (new_hi new_lo) / den
    r> r> 0
    2 0 do
        2over 2over 2>r >r >r
        2over 2over 2>r >r
        2dup 2>r >r
        2over 2over u>= if
            2over 2over u- swap u- swap
            1 swap lshift or
        then
        2drop 2drop
    loop
    r> r> drop drop ;               \ final quotient (fits 64‑bits)

\ --------------------------------------------------------------
\ Sliding window detector
\ --------------------------------------------------------------
: detect-command ( ref-addr ref-n test-addr test-n thresh-fix -- )
    >r >r >r                         \ keep thresh on return stack
    test-n ref-n - 0 max 0 do        \ each possible window
        test-addr i +                \ start of window
        ref-addr ref-n corr-fixed    \ correlation (fixed‑point)
        dup r@ > if                  \ above threshold?
            ." 👣 Detected \"come here\" at sample "
            i ref-n + . cr
        then
        drop
    loop
    r> r> r> drop ;                  \ clean up threshold

\ --------------------------------------------------------------
\ Example usage (after you’ve loaded the buffers)
\ --------------------------------------------------------------
\ Load the two files (you already have these from the loader)
load-ref   \ → ref-addr ref-n on stack
load-test  \ → test-addr test-n on stack

\ Choose a threshold (0.80 → 0.80 * SCALE)
0.80e0 f>s FRAC-BITS lshift * constant THRESH-FIX

\ Call the detector
ref-addr ref-n test-addr test-n THRESH-FIX detect-command