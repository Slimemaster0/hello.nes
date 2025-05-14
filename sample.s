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
    stx $4010     ; Disable PCM

    ; Initialize the stack
    ldx #$FF
    txs


    ; Clear PPU registers
    ldx #$00
    stx $2000
    stx $2001

    ; Clear the memory
    txa
CLEARMEMORY: ; Clear the memory from $0000 to $07ff
    sta $0000, x
    sta $0100, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    lda #$FF
    sta $0200, x
    lda #$00
    inx
    cpx #$00
    bne CLEARMEMORY

    ; Wait for VBlank
:
    bit $2002
    bpl :-

    ; Setting sprite range
    lda #$02
    sta $4014

    lda #$3f
    sta $2006
    lda #$00
    sta $2006

    ldx #$00
LOADPALETTES:
    lda PALETTEDATA, x
    sta $2007
    inx
    cpx #$20
    bne LOADPALETTES

    ldx #$00
LOADSPRITES:
    lda SPRITEDATA, x
    sta $0200, x
    inx
    cpx #$10	; 16 bytes ( 4 bytes pr sprite, 4 sprites total )
    bne LOADSPRITES

    INFLOOP: 
	jmp INFLOOP

NMI:
    rti

PALETTEDATA:
    .byte $00, $0F, $00, $10, 	$00, $0A, $15, $01, 	$00, $29, $28, $27, 	$00, $34, $24, $14 	; background palettes
    .byte $31, $0F, $15, $30, 	$00, $0F, $11, $30, 	$00, $0F, $30, $27, 	$00, $3C, $2C, $1C 	; sprite palettes

SPRITEDATA:
            ; Y    id   attr X
	.byte $40, $00, $00, $40
	.byte $40, $01, $00, $48
	.byte $48, $10, $00, $40
	.byte $48, $11, $00, $48
    
.segment "VECTORS"
    .word NMI
    .word RESET

.segment "CHARS"
.incbin "gfx.chr"
