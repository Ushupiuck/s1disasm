; ---------------------------------------------------------------------------
; Object 2D - Burrobot enemy (LZ)
; ---------------------------------------------------------------------------

Burrobot:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Burro_Index(pc,d0.w),d1
		jmp	Burro_Index(pc,d1.w)
; ===========================================================================
Burro_Index:	dc.w Burro_Main-Burro_Index
		dc.w Burro_Action-Burro_Index

burrobot_turn_time	= objoff_30	; 2 bytes; time between direction changes
burrobot_floor_flag	= objoff_32	; 1 byte ; flag set every other frame to detect edge of floor
; ===========================================================================

Burro_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$13,obHeight(a0)
		move.b	#8,obWidth(a0)
		move.l	#Map_Burro,obMap(a0)
		move.w	#make_art_tile(ArtTile_Burrobot,0,0),obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#4,obPriority(a0)
		move.b	#5,obColType(a0)
		move.b	#$C,obActWid(a0)
		addq.b	#6,ob2ndRout(a0) ; run "Burro_ChkSonic" routine
		move.b	#2,obAnim(a0)

Burro_Action:	; Routine 2
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	.index(pc,d0.w),d1
		jsr	.index(pc,d1.w)
		lea	(Ani_Burro).l,a1
		bsr.w	AnimateSprite
		bra.w	RememberState
; ===========================================================================
.index:		dc.w .changedir-.index
		dc.w Burro_Move-.index
		dc.w Burro_Jump-.index
		dc.w Burro_ChkSonic-.index
; ===========================================================================

.changedir:
		subq.w	#1,burrobot_turn_time(a0)
		bpl.s	.nochg
		addq.b	#2,ob2ndRout(a0)
		move.w	#255,burrobot_turn_time(a0)
		move.w	#$80,obVelX(a0)
		move.b	#1,obAnim(a0)
		bchg	#0,obStatus(a0)	; change direction the Burrobot is facing
		beq.s	.nochg
		neg.w	obVelX(a0)	; change direction the Burrobot is moving
.nochg:		rts
; ===========================================================================

Burro_Move:
		subq.w	#1,burrobot_turn_time(a0)	; decrement turning timer
		bmi.s	Burro_Turn			; branch if it runs out
		bsr.w	SpeedToPos
		bchg	#0,burrobot_floor_flag(a0)
		bne.s	Burro_Turn.findfloor
		move.w	obX(a0),d3
		addi.w	#$C,d3				; find floor to the right
		btst	#0,obStatus(a0)			; is burrobot flipped?
		bne.s	+
		subi.w	#$18,d3				; find floor to the left
+
		jsr	(ObjFloorDist2).l
		cmpi.w	#$C,d1				; is floor 12 or more px away?
		blt.s	Burro_Turn.return		; if so, return
	;	bge.s	Burro_Turn			; if yes, branch
Burro_Turn:
	;	btst	#2,(v_vbla_byte+3).w		; becomes vbla_byte+3 in Sonic 2 onwards
		btst	#2,(v_vbla_byte).w
		beq.s	.jump
		subq.b	#2,ob2ndRout(a0)
		move.w	#59,burrobot_turn_time(a0)
		clr.w	obVelX(a0)
		clr.b	obAnim(a0)
.return:	rts
; ===========================================================================

.findfloor:
		jsr	(ObjFloorDist).l
		add.w	d1,obY(a0)
		rts
; ===========================================================================

.jump:		; RNG decided we should jump, so prepare.
		addq.b	#2,ob2ndRout(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#2,obAnim(a0)
		rts
; ===========================================================================

Burro_Jump:
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		bmi.s	Burro_ChkSonic.return
		move.b	#3,obAnim(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	Burro_ChkSonic.return
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		move.b	#1,obAnim(a0)
		move.w	#255,burrobot_turn_time(a0)
		subq.b	#2,ob2ndRout(a0)
		move.w	#$80,d1
		bra.w	Burro_ChkSonic2
; ===========================================================================

Burro_ChkSonic:
		moveq	#$60,d2
		move.w	#$80,d1
		bsr.w	Burro_ChkSonic2
		bcc.s	.return
		move.w	(v_player+obY).w,d0
		sub.w	obY(a0),d0
		bcc.s	.return
		cmpi.w	#-$80,d0
		blo.s	.return
		tst.w	(v_debuguse).w
		bne.s	.return
		subq.b	#2,ob2ndRout(a0)
		move.w	d1,obVelX(a0)
		move.w	#-$400,obVelY(a0)
.return:	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


Burro_ChkSonic2:
		bset	#0,obStatus(a0)
		move.w	(v_player+obX).w,d0
		sub.w	obX(a0),d0
		bcc.s	.right
		neg.w	d0
		neg.w	d1
		bclr	#0,obStatus(a0)
.right:		cmp.w	d2,d0
		rts
; End of function Burro_ChkSonic2
