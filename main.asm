* = $1000

  ; Main entry point
  lda #$01
  sta $d020 ; border colour
  
  lda #$0F
  sta $d021 ; background colour
    
  jsr init
  jsr clear_screen
  
endless_loop
  sei         ; set interrupt disable flag
          
  ldy #$7f    ; $7f = %01111111
  sty $dc0d   ; Turn off CIAs Timer interrupts
  sty $dd0d   ; Turn off CIAs Timer interrupts
  lda $dc0d   ; cancel all CIA-IRQs in queue/unprocessed
  lda $dd0d   ; cancel all CIA-IRQs in queue/unprocessed

  lda #$01    ; Set Interrupt Request Mask...
  sta $d01a   ; ...we want IRQ by Rasterbeam

  lda #<irq   ; point IRQ Vector to our custom irq routine
  ldx #>irq 
  sta $314    ; store in $314/$315
  stx $315   

  lda #$00    ; trigger first interrupt at row zero
  sta $d012

  lda $d011   ; Bit#0 of $d011 is basically...
  and #$7f    ; ...the 9th Bit for $d012
  sta $d011   ; we need to make sure it is set to zero 

  cli         ; clear interrupt disable flag
  jmp endless_loop

irq        
  dec $d019        ; acknowledge IRQ
  jsr handle_movement
  jsr anim_routine
  jmp $ea81        ; return to kernel interrupt routine
  
clear_screen
  lda #$20
  ldx #$00
clsloop
  sta $0400,x
  sta $0500,x
  sta $0600,x
  sta $0700,x
  dex
  bne clsloop
  rts
 
handle_movement
  lda $dc00
  cmp #123 ; move left
  beq move_left
  cmp #119 ; move right
  beq move_right
  cmp #126
  beq look_up
  cmp #127
  beq no_move
  rts
  
look_up
  lda SPRITE_DIRECTION_ADDRESS
  cmp #SPRITE_UP_DIRECTION
  bne switch_to_look_up 
  rts
  
switch_to_look_up
  lda #SPRITE_UP_DIRECTION
  sta SPRITE_DIRECTION_ADDRESS
  rts
  
no_move
  lda SPRITE_DIRECTION_ADDRESS
  cmp #SPRITE_UP_DIRECTION
  bne switch_to_no_move 
  rts
  
switch_to_no_move
  lda #SPRITE_INTERVAL_IDLE
  sta SPRITE_CURRENT_INTERVAL
  lda #SPRITE_NO_DIRECTION
  sta SPRITE_DIRECTION_ADDRESS
  rts  
 
move_left
  dec $d000
  dec $d002
  lda $d000
  cmp #$FF
  bne move_left_values
  lda #$0
  sta $d010
  jsr move_left_values
  rts
  
move_left_values
  lda SPRITE_DIRECTION_ADDRESS
  cmp #SPRITE_LEFT_DIRECTION
  bne switch_to_left 
  rts
  
switch_to_left
  lda #SPRITE_INTERVAL_WALKING
  sta SPRITE_CURRENT_INTERVAL
  jsr reset_frame
  lda #SPRITE_LEFT_DIRECTION
  sta SPRITE_DIRECTION_ADDRESS
  rts

move_right
  lda $d000
  cmp #$FF
  beq handle_hi_x_right
  jmp move_right_values
  rts

handle_hi_x_right
  lda $d010
  ora #$03
  sta $d010
  jmp move_right_values
  rts
  
move_right_values
  inc $d000
  inc $d002
  lda SPRITE_DIRECTION_ADDRESS
  cmp #SPRITE_RIGHT_DIRECTION
  bne switch_to_right
  rts
  
switch_to_right
  lda #SPRITE_INTERVAL_WALKING
  sta SPRITE_CURRENT_INTERVAL
  jsr reset_frame
  lda #SPRITE_RIGHT_DIRECTION
  sta SPRITE_DIRECTION_ADDRESS
  rts
  
!source "sprite_routines.asm"
!source "sprites.asm"
