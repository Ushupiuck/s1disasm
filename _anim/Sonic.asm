; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
Ani_Sonic:

ptr_Walk:	dc.w SonAni_Walk-Ani_Sonic
ptr_Run:	dc.w SonAni_Run-Ani_Sonic
ptr_Roll:	dc.w SonAni_Roll-Ani_Sonic
ptr_Roll2:	dc.w SonAni_Roll2-Ani_Sonic
ptr_Push:	dc.w SonAni_Push-Ani_Sonic
ptr_Wait:	dc.w SonAni_Wait-Ani_Sonic
ptr_Balance:	dc.w SonAni_Balance-Ani_Sonic
ptr_LookUp:	dc.w SonAni_LookUp-Ani_Sonic
ptr_Duck:	dc.w SonAni_Duck-Ani_Sonic
ptr_SDash:	dc.w SonAni_SDash-Ani_Sonic
ptr_Blink:	dc.w SonAni_Blink-Ani_Sonic
ptr_GetUp:	dc.w SonAni_GetUp-Ani_Sonic
ptr_Balance2:	dc.w SonAni_Balance2-Ani_Sonic
ptr_Stop:	dc.w SonAni_Stop-Ani_Sonic
ptr_Float1:	dc.w SonAni_Float1-Ani_Sonic
ptr_Float2:	dc.w SonAni_Float2-Ani_Sonic
ptr_Spring:	dc.w SonAni_Spring-Ani_Sonic
ptr_Hang:	dc.w SonAni_Hang-Ani_Sonic
ptr_Leap1:	dc.w SonAni_Leap1-Ani_Sonic
ptr_Leap2:	dc.w SonAni_Leap2-Ani_Sonic
ptr_Hang2:	dc.w SonAni_Hang2-Ani_Sonic
ptr_GetAir:	dc.w SonAni_GetAir-Ani_Sonic
ptr_HangDrop:	dc.w SonAni_Hang3-Ani_Sonic
ptr_Drown:	dc.w SonAni_Drown-Ani_Sonic
ptr_Death:	dc.w SonAni_Death-Ani_Sonic
;ptr_Shrink:	dc.w SonAni_Shrink-Ani_Sonic
ptr_Hurt:	dc.w SonAni_Hurt-Ani_Sonic
ptr_WaterSlide:	dc.w SonAni_WaterSlide-Ani_Sonic
ptr_Null:	dc.w SonAni_Null-Ani_Sonic
ptr_Lying:	dc.w SonAni_Lying-Ani_Sonic
ptr_LieDown:	dc.w SonAni_LieDown-Ani_Sonic

SonAni_Walk:	dc.b $FF, $F, $10, $11, $12, $13, $14, $D, $E, afEnd
		even
SonAni_Run:	dc.b $FF, $2D, $2E ,$2F, $30, afEnd
		even
SonAni_Roll:	dc.b $FE, $3D, $41, $3E, $41, $3F, $41, $40, $41, afEnd
		even
SonAni_Roll2:	dc.b $FE, $3D, $41, $3E, $41, $3F, $41, $40, $41, afEnd
		even
SonAni_Push:	dc.b $FD, $48, $49, $4A, $4B, afEnd
		even
SonAni_Wait:	dc.b 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
		dc.b 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2
		dc.b 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 5, 4, 4, 4, 5, 5
		dc.b 5, 4, 4, 4, 5, 5, 5, 4, 4, 4, 5, 5, 5, 6, 6, 6
		dc.b 6, 6, 6, 6, 6, 6, 6, 4, 4, 4, 5, 5, 5, 4, 4, 4
		dc.b 5, 5, 5, 4, 4, 4, 5, 5, 5, 4, 4, 4, 5, 5, 5, 6
		dc.b 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 4, 4, 5, 5, 5, 4
		dc.b 4, 4, 5, 5, 5, 4, 4, 4, 5, 5, 5, 4, 4, 4, 5, 5
		dc.b 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 4, 4, 4, 5, 5
		dc.b 5, 4, 4, 4, 5, 5, 5, 4, 4, 4, 5, 5, 5, 4, 4, 4
		dc.b 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 8, 8
		dc.b 8, 9, 9, 9, afBack, 6
		even
SonAni_Balance:	dc.b 9, $CA, $CB, $CC, $CB, afEnd
		even
SonAni_LookUp:	dc.b 5, $B, $C, afBack, 1
		even
SonAni_Duck:	dc.b 5, $4C, $4D, afBack,  1
		even
SonAni_SDash:	dc.b 0, $42, $43, $42, $44, $42, $45, $42, $46, $42, $47, afEnd
		even
SonAni_Blink:	dc.b 1, 2, afChange, 0
		even
SonAni_GetUp:	dc.b 3, $A, afChange, 0
		even
SonAni_Balance2:dc.b 3, $C6, $C7, $C8, $C9, afEnd
		even
SonAni_Stop:	dc.b 5, $CF, $D0, $D1, $D2, afChange, id_Walk
		even
SonAni_Float1:	dc.b 7,	$54, $59, afEnd
		even
SonAni_Float2:	dc.b 7,	$54, $55, $56, $57, $58, afEnd
		even
SonAni_Spring:	dc.b 3, $D8, $D9, $DA, $DB, $DC, afEnd
		even
SonAni_Hang:	dc.b 1,	$50, $51, afEnd
		even
SonAni_Leap1:	dc.b $F, $F9, $F9, $F9,	afBack, 1
		even
SonAni_Leap2:	dc.b $F, $F9, $FA, afBack, 1
		even
SonAni_Hang2:	dc.b $B, $ED, $EE, $EF, $F0, $F1, $F0, $EF
		dc.b $EE, afEnd
		even
SonAni_GetAir:	dc.b $B, $5A, $5A, $11, $12, afChange, id_Walk
		even
SonAni_Hang3:	dc.b $B, $ED, $EE, $EF, $F0, $F1, afChange, id_Walk, id_Walk
		even
SonAni_Drown:	dc.b $20, $5C, afEnd
		even
SonAni_Death:	dc.b $20, $5B, afEnd
		even
;SonAni_Shrink:	dc.b 3,	$4E, $4F, $50, $51, $52, 0, afBack, 1
;		even
SonAni_Hurt:	dc.b $40, $4E, afEnd
		even
SonAni_WaterSlide:
		dc.b 9, $4E, $4F, afEnd
		even
SonAni_Null:	dc.b $77, 0, afChange, id_Walk
		even
SonAni_Lying:	dc.b 9,  8,  9, afEnd
		even
SonAni_LieDown:	dc.b 3,  7, afChange, id_Walk
		even

id_Walk:	equ (ptr_Walk-Ani_Sonic)/2	; 0
id_Run:		equ (ptr_Run-Ani_Sonic)/2	; 1
id_Roll:	equ (ptr_Roll-Ani_Sonic)/2	; 2
id_Roll2:	equ (ptr_Roll2-Ani_Sonic)/2	; 3
id_Push:	equ (ptr_Push-Ani_Sonic)/2	; 4
id_Wait:	equ (ptr_Wait-Ani_Sonic)/2	; 5
id_Balance:	equ (ptr_Balance-Ani_Sonic)/2	; 6
id_LookUp:	equ (ptr_LookUp-Ani_Sonic)/2	; 7
id_Duck:	equ (ptr_Duck-Ani_Sonic)/2	; 8
id_SDash:	equ (ptr_SDash-Ani_Sonic)/2	; 9
id_Blink	equ (ptr_Blink-Ani_Sonic)/2	; $A
id_GetUp:	equ (ptr_GetUp-Ani_Sonic)/2	; $B
id_Balance2:	equ (ptr_Balance2-Ani_Sonic)/2	; $C
id_Stop:	equ (ptr_Stop-Ani_Sonic)/2	; $D
id_Float1:	equ (ptr_Float1-Ani_Sonic)/2	; $E
id_Float2:	equ (ptr_Float2-Ani_Sonic)/2	; $F
id_Spring:	equ (ptr_Spring-Ani_Sonic)/2	; $10
id_Hang:	equ (ptr_Hang-Ani_Sonic)/2	; $11
id_Leap1:	equ (ptr_Leap1-Ani_Sonic)/2	; $12
id_Leap2:	equ (ptr_Leap2-Ani_Sonic)/2	; $13
id_Hang2:	equ (ptr_Hang2-Ani_Sonic)/2	; $14
id_GetAir:	equ (ptr_GetAir-Ani_Sonic)/2	; $15
id_HangDrop:	equ (ptr_HangDrop-Ani_Sonic)/2	; $16
id_Drown:	equ (ptr_Drown-Ani_Sonic)/2	; $17
id_Death:	equ (ptr_Death-Ani_Sonic)/2	; $18
;id_Shrink:	equ (ptr_Shrink-Ani_Sonic)/2	; $19
id_Hurt:	equ (ptr_Hurt-Ani_Sonic)/2	; $1A
id_WaterSlide:	equ (ptr_WaterSlide-Ani_Sonic)/2; $1B
id_Null:	equ (ptr_Null-Ani_Sonic)/2	; $1C
id_Lying:	equ (ptr_Lying-Ani_Sonic)/2	; $1D
id_LieDown:	equ (ptr_LieDown-Ani_Sonic)/2	; $1E