; Constants
SPRITE_OFFSET    = $FF
SPRITE_INTERVAL_COUNTER  = $FE;
SPRITE_CURRENT_INTERVAL = $FA;
SPRITE_ADDRESS = $FD;
SPRITE_INTERVAL_IDLE  = 60;
SPRITE_INTERVAL_WALKING  = 10;

SPRITE_DIRECTION_ADDRESS = $FC; / 0 no move, 1 left, 2 right, 3 up, 4 down
SPRITE_NO_DIRECTION = 0;
SPRITE_LEFT_DIRECTION = 1
SPRITE_RIGHT_DIRECTION = 2
SPRITE_UP_DIRECTION = 3
SPRITE_DOWN_DIRECTION = 4

SPRITE_FRAMESET = $FB;
  
init:
  lda #$FF
  sta SPRITE_OFFSET
  lda #$00
  sta SPRITE_INTERVAL_COUNTER
  lda #SPRITE_INTERVAL_IDLE
  sta SPRITE_CURRENT_INTERVAL
  lda #SPRITE_NO_DIRECTION
  sta SPRITE_DIRECTION_ADDRESS
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
  
  ; Sprite initial position
  lda #$80
  sta $d000
  sta $d001
  sta $d002
  sta $d003 
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
  beq reset_frame 
  lda SPRITE_CURRENT_INTERVAL
  sta SPRITE_INTERVAL_COUNTER
  ; Get current direction
  lda SPRITE_DIRECTION_ADDRESS
  cmp #SPRITE_NO_DIRECTION
  beq stand_still
  cmp #SPRITE_LEFT_DIRECTION
  beq walk_left
  cmp #SPRITE_RIGHT_DIRECTION
  beq walk_right
  rts
 
stand_still:
  lda SPRITE_OFFSET
  asl
  tay
  lda stand_still_ptrs, y
  sta $07f9
  lda stand_still_ptrs + 1, y
  sta $07f8  
  rts
  
walk_left:
  lda SPRITE_OFFSET
  asl
  tay
  lda walk_left_ptrs, y
  sta $07f9
  lda walk_left_ptrs + 1, y
  sta $07f8  
  rts
  
walk_right:
  lda SPRITE_OFFSET
  asl
  tay
  lda walk_right_ptrs, y
  sta $07f9
  lda walk_right_ptrs + 1, y
  sta $07f8  
  rts
  
reset_frame:
  lda #$FF
  sta SPRITE_OFFSET
  lda #$0
  sta SPRITE_INTERVAL_COUNTER
  rts

walk_right_ptrs:
  !byte $80
  !byte $82
  !byte $84
  !byte $86
  !byte $88
  !byte $8A
  !byte $84
  !byte $86
  
walk_left_ptrs:
  !byte $8C
  !byte $8E
  !byte $90
  !byte $92
  !byte $94
  !byte $96
  !byte $90
  !byte $92
 
stand_still_ptrs:
  !byte $9C
  !byte $9E
  !byte $98
  !byte $9A
  !byte $9C
  !byte $9E
  !byte $A0
  !byte $A2
 