; Constants
SPRITE_OFFSET    = $FF
SPRITE_INTERVAL_COUNTER  = $FE;
SPRITE_ADDRESS = $FD;
SPRITE_INTERVAL  = 10;
  
init:
  lda #$FF
  sta SPRITE_OFFSET
  lda #$00
  sta SPRITE_INTERVAL_COUNTER
  ; Sprite colour
  lda #$00
  sta $D027
  sta $D028
  ; Sprite 0 is multicolour
  lda #$0A
  sta $D01C
  lda #$0A
  sta $D025
  lda #$02
  sta $D026 
  ; Enable sprite 1 & 2
  lda #$03 ; 0x011
  sta $d015
  rts

anim_routine:
  lda SPRITE_INTERVAL_COUNTER
  cmp #$00
  beq next_frame
  dec SPRITE_INTERVAL_COUNTER
  rts
  
next_frame:
  inc SPRITE_OFFSET
  lda SPRITE_OFFSET
  cmp #$04 ; number of frames
  beq init 
  lda #SPRITE_INTERVAL
  sta SPRITE_INTERVAL_COUNTER  
  ; Get current sprite
  lda SPRITE_OFFSET
  asl
  tay
  lda sprite_routine_ptrs, y
  sta $07f9
  lda sprite_routine_ptrs+1, y
  sta $07f8
  
  ; Sprite position
  lda #$80
  sta $d000
  sta $d001
  sta $d002
  sta $d003
 
  rts

sprite_routine_ptrs:
  !byte $80
  !byte $82
  !byte $84
  !byte $86
  !byte $88
  !byte $8A
  !byte $84
  !byte $86
  