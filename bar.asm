* = $1000

  ; Main entry point
  lda #$01
  sta $d020 ; border colour
  
  lda #$0F
  sta $d021 ; background colour
    
  ; Setup sprite and raster update of sprite (as user moves joystick)
  ;jsr setup_sprite
  jsr init
  jsr clear_screen
  
endless_loop
  ;jsr anim_routine
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

irq        dec $d019        ; acknowledge IRQ

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
  
 ; Refactor this shite
!source "fibble.asm"
!source "sprites.asm"
