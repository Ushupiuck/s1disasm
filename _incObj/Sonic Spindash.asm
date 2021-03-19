; ---------------------------------------------------------------------------
; Subroutine to check for starting to charge a spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1AC3E:
Sonic_CheckSpindash:
		tst.b	spindash_flag(a0)
		bne.s	Sonic_UpdateSpindash
		cmpi.b	#id_duck,anim(a0)
		bne.s	return_1AC8C
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	return_1AC8C
		move.b	#id_Spindash,anim(a0)
		move.w	#$BE,d0
		jsr	(PlaySound_Special).l
		addq.l	#4,sp
		move.b	#1,spindash_flag(a0)
		move.w	#0,spindash_counter(a0)
;		cmpi.b	#$C,air_left(a0)	; if he's drowning, branch to not make dust
;		blo.s	+
;		move.b	#2,(Sonic_Dust+anim).w
;+
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_AnglePos

return_1AC8C:
		rts
; End of subroutine Sonic_CheckSpindash


; ---------------------------------------------------------------------------
; Subrouting to update an already-charging spindash
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1AC8E:
Sonic_UpdateSpindash:
		move.b	#id_Spindash,anim(a0)
		move.b	(v_jpadhold2).w,d0
		btst	#bitDn,d0
		bne.w	Sonic_ChargingSpindash

		; unleash the charged spindash and start rolling quickly:
		move.b	#$E,y_radius(a0)
		move.b	#7,x_radius(a0)
		move.b	#id_roll,anim(a0)
		addq.w	#5,y_pos(a0)	; add the difference between Sonic's rolling and standing heights
		move.b	#0,spindash_flag(a0) ; clear Spin Dash flag
		moveq	#0,d0
		move.b	spindash_counter(a0),d0
		add.w	d0,d0
		move.w	SpindashSpeeds(pc,d0.w),inertia(a0)
;		tst.b	(Super_Sonic_flag).w
;		beq.s	+
;		move.w	SpindashSpeedsSuper(pc,d0.w),inertia(a0)
;+
		move.w	inertia(a0),d0
		subi.w	#$800,d0
		add.w	d0,d0
		andi.w	#$1F00,d0
		neg.w	d0
		addi.w	#$2000,d0
;		move.w	d0,(Horiz_scroll_delay_val).w
		btst	#0,status(a0)
		beq.s	+
		neg.w	inertia(a0)
+
		bset	#2,status(a0)
;		move.b	#0,(Sonic_Dust+anim).w
		move.w	#$BC,d0	; spindash zoom sound
		jsr	(PlaySound_Special).l
		move.b	angle(a0),d0
		jsr	(CalcSine).l
		muls.w	inertia(a0),d1
		asr.l	#8,d1
		move.w	d1,x_vel(a0)
		muls.w	inertia(a0),d0
		asr.l	#8,d0
		move.w	d0,y_vel(a0)
		bra.s	Obj01_Spindash_ResetScr
; ===========================================================================
; word_1AD0C:
SpindashSpeeds:
		dc.w  $800	; 0
		dc.w  $880	; 1
		dc.w  $900	; 2
		dc.w  $980	; 3
		dc.w  $A00	; 4
		dc.w  $A80	; 5
		dc.w  $B00	; 6
		dc.w  $B80	; 7
		dc.w  $C00	; 8
; word_1AD1E:
;SpindashSpeedsSuper:
;		dc.w  $B00	; 0
;		dc.w  $B80	; 1
;		dc.w  $C00	; 2
;		dc.w  $C80	; 3
;		dc.w  $D00	; 4
;		dc.w  $D80	; 5
;		dc.w  $E00	; 6
;		dc.w  $E80	; 7
;		dc.w  $F00	; 8
; ===========================================================================
; loc_1AD30:
Sonic_ChargingSpindash:			; If still charging the dash...
		tst.w	spindash_counter(a0)
		beq.s	+
		move.w	spindash_counter(a0),d0
		lsr.w	#5,d0
		sub.w	d0,spindash_counter(a0)
		bcc.s	+
		move.w	#0,spindash_counter(a0)
+
		move.b	(v_jpadpress2).w,d0
		andi.b	#btnABC,d0
		beq.w	Obj01_Spindash_ResetScr
		move.w	#(id_Spindash<<8),anim(a0)
		move.w	#$BE,d0
		jsr	(PlaySound_Special).l
		addi.w	#$200,spindash_counter(a0)
		cmpi.w	#$800,spindash_counter(a0)
		blo.s	Obj01_Spindash_ResetScr
		move.w	#$800,spindash_counter(a0)

; loc_1AD78:
Obj01_Spindash_ResetScr:
		addq.l	#4,sp
		cmpi.w	#(224/2)-16,(Camera_Y_pos_bias).w
		beq.s	loc_1AD8C
		bhs.s	+
		addq.w	#4,(Camera_Y_pos_bias).w
+		subq.w	#2,(Camera_Y_pos_bias).w

loc_1AD8C:
		bsr.w	Sonic_LevelBound
		bsr.w	Sonic_AnglePos
		move.w	#$60,(v_lookshift).w
		rts
; End of subroutine Sonic_UpdateSpindash