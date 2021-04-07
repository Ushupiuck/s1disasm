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
ptr_Spindash:	dc.w SonAni_Spindash-Ani_Sonic
ptr_Stop:	dc.w SonAni_Stop-Ani_Sonic
ptr_Float1:	dc.w SonAni_Float1-Ani_Sonic
ptr_Float2:	dc.w SonAni_Float2-Ani_Sonic
ptr_Spring:	dc.w SonAni_Spring-Ani_Sonic
ptr_Hang:	dc.w SonAni_Hang-Ani_Sonic
ptr_Leap1:	dc.w SonAni_Leap1-Ani_Sonic
ptr_Leap2:	dc.w SonAni_Leap2-Ani_Sonic
ptr_Surf:	dc.w SonAni_Surf-Ani_Sonic
ptr_GetAir:	dc.w SonAni_GetAir-Ani_Sonic
ptr_Burnt:	dc.w SonAni_Burnt-Ani_Sonic
ptr_Drown:	dc.w SonAni_Drown-Ani_Sonic
ptr_Death:	dc.w SonAni_Death-Ani_Sonic
ptr_Shrink:	dc.w SonAni_Shrink-Ani_Sonic
ptr_Hurt:	dc.w SonAni_Hurt-Ani_Sonic
ptr_WaterSlide:	dc.w SonAni_WaterSlide-Ani_Sonic
ptr_Null:	dc.w SonAni_Null-Ani_Sonic
ptr_Float3:	dc.w SonAni_Float3-Ani_Sonic
ptr_Float4:	dc.w SonAni_Float4-Ani_Sonic

SonAni_Walk:	dc.b $FF, 8, 9,	$A, $B,	6, 7, afEnd
SonAni_Run:	dc.b $FF, $1E, $1F, $20, $21, afEnd, afEnd, afEnd
SonAni_Roll:	dc.b $FE, $2E, $2F, $30, $31, $32, afEnd, afEnd
SonAni_Roll2:	dc.b $FE, $2E, $2F, $32, $30, $31, $32,	afEnd
SonAni_Push:	dc.b $FD, $47, $48, $49, $4A, afEnd, afEnd, afEnd
SonAni_Wait:	dc.b $17, 1, 1,	1, 1, 1, 1, 1, 1, 1
		dc.b 1,	1, 1, 3, 2, 2, 2, 3, 4, afBack, 2
SonAni_Balance:	dc.b $1F, $3C, $3D, afEnd
SonAni_LookUp:	dc.b $3F, 5, afEnd
SonAni_Duck:	dc.b $3F, $3B, afEnd
SonAni_Spindash:
		dc.b 0, $33, $34, $33, $35, $33, $36, $33, $37, $33, $38, afEnd
SonAni_Stop:	dc.b 7,	$39, $3A, afEnd
SonAni_Float1:	dc.b 7,	$3E, $40, afEnd
SonAni_Float2:	dc.b 7,	$3E, $3F, $55, $40, $56, afEnd
SonAni_Spring:	dc.b $2F, $42, afChange, id_Walk
SonAni_Hang:	dc.b 4,	$43, $44, afEnd
SonAni_Leap1:	dc.b $F, $45, $45, $45,	afBack, 1
SonAni_Leap2:	dc.b $F, $45, $46, afBack, 1
SonAni_Surf:	dc.b $3F, $4B, afEnd
SonAni_GetAir:	dc.b $B, $58, $58, $A, $B, afChange, id_Walk
SonAni_Burnt:	dc.b $20, $4D, afEnd
SonAni_Drown:	dc.b $2F, $4E, afEnd
SonAni_Death:	dc.b 3,	$4F, afEnd
SonAni_Shrink:	dc.b 3,	$50, $51, $52, $53, $54, 0, afBack, 1
SonAni_Hurt:	dc.b 3,	$57, afEnd
SonAni_WaterSlide:
		dc.b 7, $57, $59, afEnd
SonAni_Null:	dc.b $77, 0, afChange, id_Walk
SonAni_Float3:	dc.b 3,	$3E, $3F, $55, $40, $56, afEnd
SonAni_Float4:	dc.b 3,	$3E, afChange, id_Walk

id_Walk:	equ (ptr_Walk-Ani_Sonic)/2	; 0
id_Run:		equ (ptr_Run-Ani_Sonic)/2	; 1
id_Roll:	equ (ptr_Roll-Ani_Sonic)/2	; 2
id_Roll2:	equ (ptr_Roll2-Ani_Sonic)/2	; 3
id_Push:	equ (ptr_Push-Ani_Sonic)/2	; 4
id_Wait:	equ (ptr_Wait-Ani_Sonic)/2	; 5
id_Balance:	equ (ptr_Balance-Ani_Sonic)/2	; 6
id_LookUp:	equ (ptr_LookUp-Ani_Sonic)/2	; 7
id_Duck:	equ (ptr_Duck-Ani_Sonic)/2	; 8
id_Spindash:	equ (ptr_Spindash-Ani_Sonic)/2	; 9
id_Stop:	equ (ptr_Stop-Ani_Sonic)/2	; $D
id_Float1:	equ (ptr_Float1-Ani_Sonic)/2	; $E
id_Float2:	equ (ptr_Float2-Ani_Sonic)/2	; $F
id_Spring:	equ (ptr_Spring-Ani_Sonic)/2	; $10
id_Hang:	equ (ptr_Hang-Ani_Sonic)/2	; $11
id_Leap1:	equ (ptr_Leap1-Ani_Sonic)/2	; $12
id_Leap2:	equ (ptr_Leap2-Ani_Sonic)/2	; $13
id_Surf:	equ (ptr_Surf-Ani_Sonic)/2	; $14
id_GetAir:	equ (ptr_GetAir-Ani_Sonic)/2	; $15
id_Burnt:	equ (ptr_Burnt-Ani_Sonic)/2	; $16
id_Drown:	equ (ptr_Drown-Ani_Sonic)/2	; $17
id_Death:	equ (ptr_Death-Ani_Sonic)/2	; $18
id_Shrink:	equ (ptr_Shrink-Ani_Sonic)/2	; $19
id_Hurt:	equ (ptr_Hurt-Ani_Sonic)/2	; $1A
id_WaterSlide:	equ (ptr_WaterSlide-Ani_Sonic)/2 ; $1B
id_Null:	equ (ptr_Null-Ani_Sonic)/2	; $1C
id_Float3:	equ (ptr_Float3-Ani_Sonic)/2	; $1D
id_Float4:	equ (ptr_Float4-Ani_Sonic)/2	; $1E