; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's angle & position as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_AnglePos:
		btst	#3,obStatus(a0)		; Are we standing on an object?
		beq.s	.OnGround		; If not, then we are on the ground
		moveq	#0,d0			; Reset angle buffers
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		rts
; ===========================================================================

.OnGround:
		moveq	#3,d0			; Reset angle buffers
		move.b	d0,(v_anglebuffer).w
		move.b	d0,(v_anglebuffer2).w
		move.b	obAngle(a0),d0		; Get the quadrant that we are in
		addi.b	#$20,d0
		bpl.s	.HighAngle
		move.b	obAngle(a0),d0
		bpl.s	.SkipSub
		subq.b	#1,d0

.SkipSub:
		addi.b	#$20,d0
		bra.s	.GotAngle
; ===========================================================================

.HighAngle:
		move.b	obAngle(a0),d0
		bpl.s	.SkipAdd
		addq.b	#1,d0

.SkipAdd:
		addi.b	#$1F,d0

.GotAngle:
		andi.b	#$C0,d0
		cmpi.b	#$40,d0			; Are we on a left wall?
		beq.w	Sonic_WalkVertL		; If so, branch
		cmpi.b	#$80,d0			; Are we on a ceiling?
		beq.w	Sonic_WalkCeiling	; If so, branch
		cmpi.b	#$C0,d0			; Are we on a right wall?
		beq.w	Sonic_WalkVertR		; If so, branch

; -------------------------------------------------------------------------
; Move the player along a floor
; -------------------------------------------------------------------------
; PARAMETERS:
;	a0.l - Player object RAM
; -------------------------------------------------------------------------

Player_WalkFloor:
		move.w	obY(a0),d2		; Get primary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4	; Get floor information from this sensor
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2		; Get secondary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4	; Get floor information from this sensor
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle		; Choose which height and angle to go with
		tst.w	d1			; Are we perfectly aligned to the ground?
		beq.s	.End			; If so, branch
		bpl.s	.CheckLedge		; If we are outside the floor, branch
		cmpi.w	#-$E,d1			; Have we hit a wall?
		blt.s	.End			; If so, branch
		add.w	d1,obY(a0)		; Align outselves onto the floor

.End:
		rts
; ===========================================================================

.CheckLedge:
		cmpi.w	#$E,d1			; Are we about to fall off?
		bgt.s	.CheckStick		; If so, branch

.SetY:
		add.w	d1,obY(a0)		; Align ourselves onto the floor
		rts
; ===========================================================================

.CheckStick:
		tst.b	stick_to_convex(a0)	; Are we sticking to a surface?
		bne.s	.SetY		; If so, align to the floor anyways
		bset	#1,obStatus(a0)		; Fall off the ground
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0) ; restart Sonic's animation
		rts
; End of function Sonic_AnglePos

; ---------------------------------------------------------------------------
; Subroutine to	change Sonic's angle as he walks along the floor
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_Angle:
		move.b	(v_anglebuffer2).w,d2	; Use secondary angle
		cmp.w	d0,d1			; Is the primary sensor on the higher ground?
		ble.s	.GotAngle		; If not, branch
		move.b	(v_anglebuffer).w,d2	; Use primary angle
		move.w	d0,d1			; Use primary floor height

.GotAngle:
		btst	#0,d2			; Was the level block found a flat surface?
		bne.s	.FlatSurface		; If so, branch
		move.b	d2,obAngle(a0)		; Update angle
		rts
; ===========================================================================

.FlatSurface:
		move.b	obAngle(a0),d2		; Shift ourselves to the next quadrant
		addi.b	#$20,d2
		andi.b	#$C0,d2
		move.b	d2,obAngle(a0)
		rts
; End of function Sonic_Angle

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his right
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkVertR:
		move.w	obY(a0),d2		; Get primary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		neg.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4	; Get floor information from this sensor
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2		; Get secondary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer2).w,a4	; Get floor information from this sensor
		movea.w	#$10,a3
		move.w	#0,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle		; Choose which height and angle to go with
		tst.w	d1			; Are we perfectly aligned to the ground?
		beq.s	.End			; If so, branch
		bpl.s	.CheckLedge		; If we are outside the wall, branch
		cmpi.w	#-$E,d1			; Have we hit a wall?
		blt.s	.End 			; If so, branch
		add.w	d1,obX(a0)		; Align outselves onto the wall

.End:
		rts
; ===========================================================================

.CheckLedge:
		cmpi.w	#$E,d1			; Are we about to fall off?
		bgt.s	.CheckStick		; If so, branch

.SetX:
		add.w	d1,obX(a0)		; Align ourselves onto the wall
		rts
; ===========================================================================

.CheckStick:
		tst.b	stick_to_convex(a0)	; Are we sticking to a surface?
		bne.s	.SetX			; If so, align to the wall anyways
		bset	#1,obStatus(a0)		; Fall off the ground
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0) ; restart Sonic's animation
		rts
; End of function Sonic_WalkVertR

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk upside-down
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkCeiling:
		move.w	obY(a0),d2		; Get primary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d3
		lea	(v_anglebuffer).w,a4	; Get floor information from this sensor
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	d1,-(sp)
		move.w	obY(a0),d2		; Get secondary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d2
		eori.w	#$F,d2
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d3
		lea	(v_anglebuffer2).w,a4	; Get floor information from this sensor
		movea.w	#-$10,a3
		move.w	#$1000,d6
		moveq	#$D,d5
		bsr.w	FindFloor
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle		; Choose which height and angle to go with
		tst.w	d1			; Are we perfectly aligned to the ground?
		beq.s	.End			; If so, branch
		bpl.s	.CheckLedge		; If we are outside the ceiling, branch
		cmpi.w	#-$E,d1			; Have we hit a ceiling?
		blt.w	.End			; If so, branch
		sub.w	d1,obY(a0)		; Align outselves onto the ceiling

.End:
		rts
; ===========================================================================

.CheckLedge:
		cmpi.w	#$E,d1			; Are we about to fall off?
		bgt.s	.CheckStick		; If so, branch

.SetY:
		sub.w	d1,obY(a0)		; Align ourselves onto the ceiling
		rts
; ===========================================================================

.CheckStick:
		tst.b	stick_to_convex(a0)	; Are we sticking to a surface?
		bne.s	.SetY			; If so, align to the ceiling anyways
		bset	#1,obStatus(a0)		; Fall off the ground
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0) ; restart Sonic's animation
		rts
; End of function Sonic_WalkCeiling

; ---------------------------------------------------------------------------
; Subroutine allowing Sonic to walk up a vertical slope/wall to	his left
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


Sonic_WalkVertL:
		move.w	obY(a0),d2		; Get primary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		sub.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer).w,a4	; Get floor information from this sensor
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	d1,-(sp)
		move.w	obY(a0),d2		; Get secondary sensor position
		move.w	obX(a0),d3
		moveq	#0,d0
		move.b	obWidth(a0),d0
		ext.w	d0
		add.w	d0,d2
		move.b	obHeight(a0),d0
		ext.w	d0
		sub.w	d0,d3
		eori.w	#$F,d3
		lea	(v_anglebuffer2).w,a4	; Get floor information from this sensor
		movea.w	#-$10,a3
		move.w	#$800,d6
		moveq	#$D,d5
		bsr.w	FindWall
		move.w	(sp)+,d0
		bsr.w	Sonic_Angle		; Choose which height and angle to go with
		tst.w	d1			; Are we perfectly aligned to the ground?
		beq.s	.End			; If so, branch
		bpl.s	.CheckLedge		; If we are outside the wall, branch
		cmpi.w	#-$E,d1			; Have we hit a wall?
		blt.w	.End			; If so, branch
		sub.w	d1,obX(a0)		; Align outselves onto the wall

.End:
		rts
; ===========================================================================

.CheckLedge:
		cmpi.w	#$E,d1			; Are we about to fall off?
		bgt.s	.CheckStick		; If so, branch

.SetX:
		sub.w	d1,obX(a0)		; Align ourselves onto the wall
		rts
; ===========================================================================

.CheckStick:
		tst.b	stick_to_convex(a0)	; Are we sticking to a surface?
		bne.s	.SetX			; If so, align to the wall anyways
		bset	#1,obStatus(a0)		; Fall off the ground
		bclr	#5,obStatus(a0)
		move.b	#id_Run,obPrevAni(a0) ; restart Sonic's animation
		rts
; End of function Sonic_WalkVertL