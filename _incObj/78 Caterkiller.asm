; ---------------------------------------------------------------------------
; Object 78 - Caterkiller enemy (MZ, SBZ)
; ---------------------------------------------------------------------------

Caterkiller:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cat_Index(pc,d0.w),d1
		jmp	Cat_Index(pc,d1.w)
; ===========================================================================
Cat_Index:	dc.w Cat_Main-Cat_Index
		dc.w Cat_Head-Cat_Index
		dc.w Cat_BodySeg1-Cat_Index
		dc.w Cat_BodySeg2-Cat_Index
		dc.w Cat_BodySeg1-Cat_Index
		dc.w Cat_Delete-Cat_Index
		dc.w Cat_Scatter-Cat_Index

cat_wait_time	= objoff_2A		; 1 byte; time to wait between actions
cat_mode	= objoff_2B		; 1 byte; bit 4 (+$10) = mouth is open/segment moving up; bit 7 (+$80) = update animation
cat_floormap	= objoff_2C		; $10 bytes; height map of floor beneath caterkiller
cat_parent	= objoff_3C		; 4 bytes; address of parent object (high/first byte is cat_segment_pos, read below)
cat_segment_pos	= cat_parent		; high/first byte of cat_parent; segment position - starts as 0/4/8/$A, increments as it moves
; ===========================================================================

locret_16950:
		rts
; ===========================================================================

Cat_Main:	; Routine 0
		move.b	#7,obHeight(a0)
		move.b	#8,obWidth(a0)
		jsr	(ObjectFall).l
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	locret_16950
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Cat,obMap(a0)
		move.w	#make_art_tile(ArtTile_SBZ_Caterkiller,1,0),obGfx(a0)
		cmpi.b	#id_SBZ,(v_zone).w ; if level is SBZ, branch
		beq.s	.isscrapbrain
		move.w	#make_art_tile(ArtTile_MZ_SYZ_Caterkiller,1,0),obGfx(a0) ; MZ/SYZ specific code

.isscrapbrain:
		andi.b	#3,obRender(a0)
		ori.b	#4,obRender(a0)
		move.b	obRender(a0),obStatus(a0)
		move.b	#4,obPriority(a0)
		move.b	#8,obActWid(a0)
		move.b	#$B,obColType(a0)
		move.w	obX(a0),d2
		moveq	#$C,d5
		btst	#0,obStatus(a0)
		beq.s	.noflip
		neg.w	d5

.noflip:
		moveq	#4,d6
		moveq	#0,d3
		moveq	#4,d4
		movea.l	a0,a2
		moveq	#2,d1

Cat_Loop:
		jsr	(FindNextFreeObj).l
		bne.w	Cat_ChkGone
		_move.b	#id_Caterkiller,obID(a1) ; load body segment object
		move.b	d6,obRoutine(a1) ; goto Cat_BodySeg1 or Cat_BodySeg2 next
		addq.b	#2,d6		; alternate between the two
		move.l	obMap(a0),obMap(a1)
		move.w	obGfx(a0),obGfx(a1)
		move.b	#5,obPriority(a1)
		move.b	#8,obActWid(a1)
		move.b	#$CB,obColType(a1)
		add.w	d5,d2
		move.w	d2,obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obStatus(a0),obStatus(a1)
		move.b	obStatus(a0),obRender(a1)
		move.b	#8,obFrame(a1)
		move.l	a2,cat_parent(a1)
		move.b	d4,cat_segment_pos(a1)
		addq.b	#4,d4
		movea.l	a1,a2
		dbf	d1,Cat_Loop	; repeat sequence 2 more times

		move.b	#7,cat_wait_time(a0)
		clr.b	cat_segment_pos(a0)

Cat_Head:	; Routine 2
		tst.b	obStatus(a0)
		bmi.w	loc_16C96
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Cat_Index2(pc,d0.w),d1
		jsr	Cat_Index2(pc,d1.w)
		move.b	cat_mode(a0),d1
		bpl.s	.display
		lea	(Ani_Cat).l,a1
		move.b	obAngle(a0),d0
		andi.w	#$7F,d0
		addq.b	#4,obAngle(a0)
		move.b	(a1,d0.w),d0
		bpl.s	.animate
		bclr	#7,cat_mode(a0)
		bra.s	.display

.animate:
		andi.b	#$10,d1
		add.b	d1,d0
		move.b	d0,obFrame(a0)

.display:
		out_of_range.w	Cat_ChkGone
		jmp	(DisplaySprite).l

Cat_ChkGone:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	.delete
		bclr	#7,2(a2,d0.w)

.delete:
		move.b	#$A,obRoutine(a0)	; goto Cat_Delete next
		rts
; ===========================================================================

Cat_Delete:	; Routine $A
		jmp	(DeleteObject).l
; ===========================================================================
Cat_Index2:	dc.w .wait-Cat_Index2
		dc.w loc_16B02-Cat_Index2
; ===========================================================================

.wait:
		subq.b	#1,cat_wait_time(a0)
		bmi.s	.move
		rts
; ===========================================================================

.move:
		addq.b	#2,ob2ndRout(a0)
		move.b	#$10,cat_wait_time(a0)
		move.w	#-$C0,obVelX(a0)
		move.w	#$40,obInertia(a0)
		bchg	#4,cat_mode(a0)
		bne.s	loc_16AFC
		clr.w	obVelX(a0)
		neg.w	obInertia(a0)

loc_16AFC:
		bset	#7,cat_mode(a0)

loc_16B02:
		subq.b	#1,cat_wait_time(a0)
		bmi.s	.loc_16B5E
	;	tst.w	obVelX(a0)
	;	beq.s	.notmoving
	;	move.l	obX(a0),d2
	;	move.l	d2,d3
		move.w	obVelX(a0),d0
		beq.s	.notmoving
		move.l	obX(a0),d2
		move.l	d2,d3
		btst	#0,obStatus(a0)
		beq.s	.noflip
		neg.w	d0

.noflip:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,obX(a0)
		swap	d3
		cmp.w	obX(a0),d3
		beq.s	.notmoving
		jsr	(ObjFloorDist).l
		cmpi.w	#-8,d1
		blt.s	.turn
		cmpi.w	#$C,d1
		bge.s	.turn
		add.w	d1,obY(a0)
		moveq	#0,d0
		move.b	cat_segment_pos(a0),d0
		move.b	d1,cat_floormap(a0,d0.w)
	;	addq.b	#1,cat_segment_pos(a0)
	;	andi.b	#$F,cat_segment_pos(a0)
		addq.w	#1,d0
		andi.w	#$F,d0
	;	move.b	d1,cat_floormap(a0,d0.w)
		move.b	d0,cat_segment_pos(a0)

.notmoving:
		rts
; ===========================================================================

.loc_16B5E:
		subq.b	#2,ob2ndRout(a0)
		move.b	#7,cat_wait_time(a0)
		clr.w	obVelX(a0)
		clr.w	obInertia(a0)
		rts
; ===========================================================================

.turn:
		moveq	#0,d0
		move.b	cat_segment_pos(a0),d0
		move.b	#$80,cat_floormap(a0,d0.w)
		neg.w	obX+2(a0)
		beq.s	.flip
		btst	#0,obStatus(a0)
		beq.s	.flip
		subq.w	#1,obX(a0)
	;	addq.b	#1,cat_segment_pos(a0)
		addq.w	#1,d0
		andi.w	#$F,d0
	;	moveq	#0,d0
	;	move.b	cat_segment_pos(a0),d0
		clr.b	cat_floormap(a0,d0.w)
.flip:
		bchg	#0,obStatus(a0)
		move.b	obStatus(a0),obRender(a0)
	;	addq.b	#1,cat_segment_pos(a0)
	;	andi.b	#$F,cat_segment_pos(a0)
		addq.w	#1,d0
		andi.w	#$F,d0
		move.b	d0,cat_segment_pos(a0)
		rts
; ===========================================================================

Cat_BodySeg2:	; Routine 6
		movea.l	cat_parent(a0),a1
		move.b	cat_mode(a1),cat_mode(a0)
		bpl.s	Cat_BodySeg1
		lea	(Ani_Cat).l,a1
		move.b	obAngle(a0),d0
		andi.w	#$7F,d0
		addq.b	#4,obAngle(a0)
		tst.b	4(a1,d0.w)
		bpl.s	Cat_AniBody
		addq.b	#4,obAngle(a0)

Cat_AniBody:
		move.b	(a1,d0.w),d0
		addq.b	#8,d0
		move.b	d0,obFrame(a0)

Cat_BodySeg1:	; Routine 4, 8
		movea.l	cat_parent(a0),a1
		tst.b	obStatus(a0)
		bmi.w	loc_16C90
		move.b	cat_mode(a1),cat_mode(a0)
		move.b	ob2ndRout(a1),ob2ndRout(a0)
		beq.w	loc_16C64
	;	move.w	obInertia(a1),obInertia(a0)
		move.w	obInertia(a1),d1
		move.w	d1,obInertia(a0)
		move.w	obVelX(a1),d0
	;	add.w	obInertia(a0),d0
		add.w	d1,d0
		move.w	d0,obVelX(a0)
		move.l	obX(a0),d2
		move.l	d2,d3
	;	move.w	obVelX(a0),d0
		btst	#0,obStatus(a0)
		beq.s	.noflip
		neg.w	d0

.noflip:
		ext.l	d0
		asl.l	#8,d0
		add.l	d0,d2
		move.l	d2,obX(a0)
		swap	d3
		cmp.w	obX(a0),d3
		beq.s	loc_16C64
		moveq	#0,d0
		move.b	cat_segment_pos(a0),d0
		move.b	cat_floormap(a1,d0.w),d1
		move.b	d1,cat_floormap(a0,d0.w)
		cmpi.b	#$80,d1
	;	bne.s	loc_16C50
		beq.s	.turn
		ext.w	d1
		add.w	d1,obY(a0)
		addq.w	#1,d0
		andi.w	#$F,d0
		move.b	d0,cat_segment_pos(a0)
		bra.s	loc_16C64

.turn:
	;	move.b	d1,cat_floormap(a0,d0.w)
		neg.w	obX+2(a0)
		beq.s	.flip
		btst	#0,obStatus(a0)
		beq.s	.flip
		cmpi.w	#-$C0,obVelX(a0)
		bne.s	.flip
		subq.w	#1,obX(a0)
	;	addq.b	#1,cat_segment_pos(a0)
	;	moveq	#0,d0
	;	move.b	cat_segment_pos(a0),d0
		addq.w	#1,d0
		andi.w	#$F,d0
		clr.b	cat_floormap(a0,d0.w)
.flip:
		bchg	#0,obStatus(a0)
		move.b	obStatus(a0),obRender(a0)
;		addq.b	#1,cat_segment_pos(a0)
;		andi.b	#$F,cat_segment_pos(a0)
		addq.w	#1,d0
		andi.w	#$F,d0
		move.b	d0,cat_segment_pos(a0)
		; fall through to loc_16C64
; ===========================================================================

loc_16C64:
		cmpi.b	#$C,obRoutine(a1)
		beq.s	loc_16C90

		; Each sub-object deletes itself when it detects that its
		; parent is going to delete itself. This mostly works, but
		; does cause the sub-object to linger for one frame longer
		; than it should, which is why rolling into a Caterkiller
		; at high speed causes Sonic to be hurt.

		; Has the head been destroyed?
		_cmpi.b	#id_ExplosionItem,obID(a1)
		beq.s	.delete
		; Is the parent going to delete itself?
		cmpi.b	#$A,obRoutine(a1)
		bne.s	.display
		; Delete the parent.
		jsr	(DeleteChild).l ; Don't mind this misnomer.

.delete:	; Mark self for deletion.
		clr.b	obColType(a1)	; immediately remove all touch response values when destroying the head to avoid taking damage
		move.b	#$A,obRoutine(a0)
		; Do not queue self for display, since it will be deleted by
		; its child later.
		rts

.display:
		jmp	(DisplaySprite).l
; ===========================================================================
Cat_FragSpeed:
		dc.w -$200				; head x speed
		dc.w -$180				; body x speed
		dc.w $180				; body x speed
		dc.w $200				; body x speed
; ===========================================================================

loc_16C90:
		bset	#7,obStatus(a1)

loc_16C96:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	Cat_FragSpeed-2(pc,d0.w),d0
		btst	#0,obStatus(a0)
		beq.s	loc_16CAA
		neg.w	d0

loc_16CAA:
		move.w	d0,obVelX(a0)
		move.w	#-$400,obVelY(a0)
		move.b	#$C,obRoutine(a0)
		andi.b	#$F8,obFrame(a0)

Cat_Scatter:	; Routine $C
		jsr	(ObjectFall).l
		tst.w	obVelY(a0)
		bmi.s	loc_16CE0
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	loc_16CE0
		add.w	d1,obY(a0)
		move.w	#-$400,obVelY(a0)

loc_16CE0:
		tst.b	obRender(a0)
		bpl.w	Cat_ChkGone
		jmp	(DisplaySprite).l