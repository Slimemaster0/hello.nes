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
    SEI ; Disable Interupts
    CLD ; Turn off decimal as its not supported on the NES


    ldx #%1000000 ; Disable sound IRQ
    stx $4017
    ldx #$00
    stx $4010    ; Disable PCM

    INFLOOP: 
	jmp INFLOOP

NMI:
    RTI
    
.segment "VECTORS"
    .word NMI
    .word RESET

.segment "CHARS"
.incbin "gfx.chr"
