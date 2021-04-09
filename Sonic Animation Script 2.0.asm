; macro to declare an offset table
offsetTable macro {INTLABEL}
current_offset_table := __LABEL__
__LABEL__ label *
    endm

; macro to declare an entry in an offset table
offsetTableEntry macro ptr
	dc.ATTRIBUTE ptr-current_offset_table
    endm
; ---------------------------------------------------------------------------
; Animation script - Sonic (Nothing but a filler until the actual art gets added)
; ---------------------------------------------------------------------------
; off_1B618:
SonicAniData:			offsetTable
SonAni_Walk_ptr:		offsetTableEntry.w SonAni_Walk1		;  0 ;   0
SonAni_Run_ptr:			offsetTableEntry.w SonAni_Run1		;  1 ;   1
SonAni_Roll_ptr:		offsetTableEntry.w SonAni_Roll1		;  2 ;   2
SonAni_Roll2_ptr:		offsetTableEntry.w SonAni_Roll21		;  3 ;   3
SonAni_Push_ptr:		offsetTableEntry.w SonAni_Push1		;  4 ;   4
SonAni_Wait_ptr:		offsetTableEntry.w SonAni_Wait1		;  5 ;   5
SonAni_Balance_ptr:		offsetTableEntry.w SonAni_Balance1	;  6 ;   6
SonAni_LookUp_ptr:		offsetTableEntry.w SonAni_LookUp1	;  7 ;   7
SonAni_Duck_ptr:		offsetTableEntry.w SonAni_Duck1		;  8 ;   8
SonAni_Spindash_ptr:		offsetTableEntry.w SonAni_Spindash1	;  9 ;   9
SonAni_Blink_ptr:		offsetTableEntry.w SonAni_Blink1		; 10 ;  $A
SonAni_GetUp_ptr:		offsetTableEntry.w SonAni_GetUp1		; 11 ;  $B
SonAni_Balance2_ptr:		offsetTableEntry.w SonAni_Balance21	; 12 ;  $C
SonAni_Stop_ptr:		offsetTableEntry.w SonAni_Stop1		; 13 ;  $D
SonAni_Float_ptr:		offsetTableEntry.w SonAni_Float		; 14 ;  $E
SonAni_Float2_ptr:		offsetTableEntry.w SonAni_Float21	; 15 ;  $F
SonAni_Spring_ptr:		offsetTableEntry.w SonAni_Spring1	; 16 ; $10
SonAni_Hang_ptr:		offsetTableEntry.w SonAni_Hang1		; 17 ; $11
SonAni_Dash2_ptr:		offsetTableEntry.w SonAni_Dash21		; 18 ; $12
SonAni_Dash3_ptr:		offsetTableEntry.w SonAni_Dash31		; 19 ; $13
SonAni_Hang2_ptr:		offsetTableEntry.w SonAni_Hang21		; 20 ; $14
SonAni_Bubble_ptr:		offsetTableEntry.w SonAni_Bubble1	; 21 ; $15
SonAni_DeathBW_ptr:		offsetTableEntry.w SonAni_DeathBW1	; 22 ; $16
SonAni_Drown_ptr:		offsetTableEntry.w SonAni_Drown1		; 23 ; $17
SonAni_Death_ptr:		offsetTableEntry.w SonAni_Death1		; 24 ; $18
SonAni_Hurt_ptr:		offsetTableEntry.w SonAni_Hurt1		; 25 ; $19
SonAni_Hurt2_ptr:		offsetTableEntry.w SonAni_Hurt1		; 26 ; $1A
SonAni_Slide_ptr:		offsetTableEntry.w SonAni_Slide1		; 27 ; $1B
SonAni_Blank_ptr:		offsetTableEntry.w SonAni_Blank1		; 28 ; $1C
SonAni_Balance3_ptr:		offsetTableEntry.w SonAni_Balance31	; 29 ; $1D
SonAni_Balance4_ptr:		offsetTableEntry.w SonAni_Balance41	; 30 ; $1E
SonAni_Lying_ptr:		offsetTableEntry.w SonAni_Lying1		; 32 ; $20
SonAni_LieDown_ptr:		offsetTableEntry.w SonAni_LieDown1	; 33 ; $21

SonAni_Walk1:	dc.b $FF, $F,$10,$11,$12,$13,$14, $D, $E,$FF
SonAni_Run1:	dc.b $FF,$2D,$2E,$2F,$30,$FF,$FF,$FF,$FF,$FF
SonAni_Roll1:	dc.b $FE,$3D,$41,$3E,$41,$3F,$41,$40,$41,$FF
SonAni_Roll21:	dc.b $FE,$3D,$41,$3E,$41,$3F,$41,$40,$41,$FF
SonAni_Push1:	dc.b $FD,$48,$49,$4A,$4B,$FF,$FF,$FF,$FF,$FF
SonAni_Wait1:
	dc.b   5,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1
	dc.b   1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2
	dc.b   3,  3,  3,  3,  3,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5
	dc.b   5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  6,  6,  6
	dc.b   6,  6,  6,  6,  6,  6,  6,  4,  4,  4,  5,  5,  5,  4,  4,  4
	dc.b   5,  5,  5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  6
	dc.b   6,  6,  6,  6,  6,  6,  6,  6,  6,  4,  4,  4,  5,  5,  5,  4
	dc.b   4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5
	dc.b   5,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  4,  4,  4,  5,  5
	dc.b   5,  4,  4,  4,  5,  5,  5,  4,  4,  4,  5,  5,  5,  4,  4,  4
	dc.b   5,  5,  5,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,  7,  8,  8
	dc.b   8,  9,  9,  9,$FE,  6
SonAni_Balance1:	dc.b   9,$CC,$CD,$CE,$CD,$FF
SonAni_LookUp1:	dc.b   5, $B, $C,$FE,  1
SonAni_Duck1:	dc.b   5,$4C,$4D,$FE,  1
SonAni_Spindash1:dc.b   0,$42,$43,$42,$44,$42,$45,$42,$46,$42,$47,$FF
SonAni_Blink1:	dc.b   1,  2,$FD,  0
SonAni_GetUp1:	dc.b   3, $A,$FD,  0
SonAni_Balance21:dc.b   3,$C8,$C9,$CA,$CB,$FF
SonAni_Stop1:	dc.b   5,$D2,$D3,$D4,$D5,$FD,  0 ; halt/skidding animation
SonAni_Float:	dc.b   7,$54,$59,$FF
SonAni_Float21:	dc.b   7,$54,$55,$56,$57,$58,$FF
SonAni_Spring1:	dc.b $2F,$5B,$FD,  0
SonAni_Hang1:	dc.b   1,$50,$51,$FF
SonAni_Dash21:	dc.b  $F,$43,$43,$43,$FE,  1
SonAni_Dash31:	dc.b  $F,$43,$44,$FE,  1
SonAni_Hang21:	dc.b $13,$6B,$6C,$FF
SonAni_Bubble1:	dc.b  $B,$5A,$5A,$11,$12,$FD,  0 ; breathe
SonAni_DeathBW1:	dc.b $20,$5E,$FF
SonAni_Drown1:	dc.b $20,$5D,$FF
SonAni_Death1:	dc.b $20,$5C,$FF
SonAni_Hurt1:	dc.b $40,$4E,$FF
SonAni_Slide1:	dc.b   9,$4E,$4F,$FF
SonAni_Blank1:	dc.b $77,  0,$FD,  0
SonAni_Balance31:dc.b $13,$D0,$D1,$FF
SonAni_Balance41:dc.b   3,$CF,$C8,$C9,$CA,$CB,$FE,  4
SonAni_Lying1:	dc.b   9,  8,  9,$FF
SonAni_LieDown1:	dc.b   3,  7,$FD,  0