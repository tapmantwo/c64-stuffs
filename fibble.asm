; Constants
SPRITE_OFFSET    = $FF
SPRITE_INTERVAL_COUNTER  = $FE;
SPRITE_ADDRESS = $FD;
SPRITE_INTERVAL  = 5;
  
init:
  lda #$FF
  sta SPRITE_OFFSET
  lda #$00
  sta SPRITE_INTERVAL_COUNTER
  lda #$01
  sta $d020 ; border colour
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
  ldx $D020
  inx
  stx $D020
  ; Get current sprite
  lda SPRITE_OFFSET
  tay
  lda sprite_routine_ptrs, y
  sta $07f8
  
   ; Enable sprite 1
  lda #$01
  sta $d015
  ; Sprite colour
  lda #$00
  sta $D027
  ; Sprite position
  lda #$80
  sta $d000
  sta $d001
 
  rts

sprite_routine_ptrs:
  !byte $80
  !byte $82
  !byte $84
  !byte $82
  