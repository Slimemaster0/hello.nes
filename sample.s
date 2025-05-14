; vim: set syntax=asm_ca65:

.segment "HEADER"
    .byte $4E, $45, $53, $1A
    .byte 2
    .byte 1
    .byte $01, $00

.export Main
.segment "CODE"

.proc Main

    rts
.endproc

.segment "STARTUP"

RESET:
    INFLOOP: 
	jmp INFLOOP

NMI:
    RTI
    
.segment "VECTORS"
    .word NMI
    .word RESET

.segment "CHARS"
.incbin "gfx.chr"
