\ -------------------------------------------------
\ Example: a simple switch‑case that prints a word
\ -------------------------------------------------

: say-hello   ." Hello!" cr ;
: say-bye     ." Goodbye!" cr ;
: say-unknown ." I do not know that option." cr ;

\ The CASE word expects a value on the stack.
\ Each OF compares that value with the literal that follows.
\ If it matches, the code after OF runs until ENDOF.
\ If none match, the code after ENDCASE runs.

: demo-switch ( n -- )
    CASE
        1 OF say-hello   ENDOF
        2 OF say-bye     ENDOF
    ENDCASE
    \ If we fell through without a match, handle it here:
    DUP 1 <> SWAP 2 <> AND IF say-unknown THEN
;

\ -------------------------------------------------
\ Usage examples
\ -------------------------------------------------
5 demo-switch   \ → I don’t know that option.
1 demo-switch   \ → Hello!
2 demo-switch   \ → Goodbye!