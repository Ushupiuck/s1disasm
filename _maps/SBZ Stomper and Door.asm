; ---------------------------------------------------------------------------
; Sprite mappings - stomper and	platforms (SBZ)
; ---------------------------------------------------------------------------
Map_Stomp_internal:
		dc.w .door-Map_Stomp_internal
		dc.w .stomper-Map_Stomp_internal
		dc.w .stomper-Map_Stomp_internal
		dc.w .stomper-Map_Stomp_internal
.door:		dc.b 4
		dc.b $F4, $E, $21, $AF,	$C0 ; horizontal sliding door
		dc.b $F4, $E, $21, $B2,	$E0
		dc.b $F4, $E, $21, $B2,	0
		dc.b $F4, $E, $29, $AF,	$20
.stomper:	dc.b 8
		dc.b $E0, $C, 0, $C, $E4 ; stomper block with yellow/black stripes
		dc.b $E0, 8, 0,	$10, 4
		dc.b $E8, $E, $20, $13,	$E4
		dc.b $E8, $A, $20, $1F,	4
		dc.b 0,	$E, $20, $13, $E4
		dc.b 0,	$A, $20, $1F, 4
		dc.b $18, $C, 0, $C, $E4
		dc.b $18, 8, 0,	$10, 4