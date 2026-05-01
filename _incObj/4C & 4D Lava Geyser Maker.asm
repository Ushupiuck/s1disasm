; ---------------------------------------------------------------------------
; Object 4C - lava geyser / lavafall producer + active lava (MZ)
; ---------------------------------------------------------------------------
;
; subtype:
; 	0 = lava geyser producer / active geyser
; 	1 = lavafall producer / active lavafall
; ---------------------------------------------------------------------------

GeyserMaker:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	GMake_Index(pc,d0.w),d1
		jmp	GMake_Index(pc,d1.w)
; ===========================================================================
GMake_Index:
		dc.w GMake_Main-GMake_Index
		dc.w GMake_Wait-GMake_Index
		dc.w GMake_ChkType-GMake_Index
		dc.w GMake_MakeLava-GMake_Index
		dc.w GMake_Display-GMake_Index
		dc.w GMake_Delete-GMake_Index
		dc.w Geyser_Main-GMake_Index
		dc.w Geyser_Action-GMake_Index
		dc.w Geyser_FollowSource-GMake_Index
		dc.w Geyser_Delete-GMake_Index
; ---------------------------------------------------------------------------
gmake_parent	= objoff_2C	; parent object pointer (used by producers spawned from Obj33)
geyser_base_y	= objoff_30	; original/rest Y used as the return target during the falling phase
gmake_timer	= objoff_32	; current countdown before the producer checks Sonic again
gmake_delay	= objoff_34	; delay value reloaded into gmake_timer each cycle
geyser_source	= objoff_36	; source/controller object pointer
; ===========================================================================

; ---------------------------------------------------------------------------
; Producer path (original object 4C)
; ---------------------------------------------------------------------------

GMake_Main:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.l	#Map_Geyser,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,1),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#1,obPriority(a0)
		move.b	#$38,obActWid(a0)
		move.w	#120,gmake_delay(a0)
		; gmake_timer intentionally left to roll negative once, like the original

GMake_Wait:	; Routine 2
		subq.w	#1,gmake_timer(a0)
		bpl.s	.displaychk
		move.w	gmake_delay(a0),gmake_timer(a0)
		move.w	(v_player+obY).w,d0
		move.w	obY(a0),d1
		cmp.w	d1,d0
		bhs.s	.displaychk
		subi.w	#$170,d1
		cmp.w	d1,d0
		blo.s	.displaychk
		addq.b	#2,obRoutine(a0)
.displaychk:	out_of_range.w	DeleteObject
		rts
; ===========================================================================

GMake_ChkType:	; Routine 4
		tst.b	obSubtype(a0)
		beq.s	GMake_Display
		addq.b	#2,obRoutine(a0)
		out_of_range.w	DeleteObject
		rts
; ===========================================================================

GMake_MakeLava:	; Routine 6
		addq.b	#2,obRoutine(a0)
		bsr.w	FindNextFreeObj
		bne.s	.fail
		_move.b	#id_GeyserMaker,obID(a1)
		move.b	#$C,obRoutine(a1)		; active lava init
		move.b	obSubtype(a0),obSubtype(a1)
		move.l	a0,geyser_source(a1)		; active lava points back to this producer
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)

.fail:
		move.b	#1,obAnim(a0)
		tst.b	obSubtype(a0)
		beq.s	GMake_Display.isgeyser
		move.b	#4,obAnim(a0)
; ===========================================================================

GMake_Display:	; Routine 8
		out_of_range.w	DeleteObject
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

.isgeyser:
		movea.l	gmake_parent(a0),a1
		bset	#1,obStatus(a1)
		move.w	#-$580,obVelY(a1)
		out_of_range.w	DeleteObject
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite
		bra.w	DisplaySprite
; ===========================================================================

GMake_Delete:	; Routine $A
		clr.b	obAnim(a0)
		move.b	#2,obRoutine(a0)
		tst.b	obSubtype(a0)
		beq.w	DeleteObject
		out_of_range.w	DeleteObject
		rts
; ===========================================================================
Geyser_Speeds:	dc.w $FB00, 0
; ===========================================================================

; ---------------------------------------------------------------------------
; Active lava path (fused object 4D)
; ob2ndRoutine:
; 	0 = geyser
; 	2 = lavafall
; ---------------------------------------------------------------------------

Geyser_Main:	; Routine $C
		move.l	#Map_Geyser,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,0),obGfx(a0)
		move.b	#4,obRender(a0)
		move.b	#$20,obActWid(a0)
		move.b	#1,obPriority(a0)
		move.b	#5,obAnim(a0)
		move.w	obY(a0),geyser_base_y(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.b	d0,ob2ndRout(a0)
		tst.b	obSubtype(a0)
		beq.s	.isgeyser
		subi.w	#$250,obY(a0)
		move.b	#2,obAnim(a0)

.isgeyser:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		move.w	Geyser_Speeds(pc,d0.w),obVelY(a0)
		addq.b	#2,obRoutine(a0)

		bsr.w	FindNextFreeObj
		bne.w	.return
		_move.b	#id_GeyserMaker,obID(a1)
		move.l	#Map_Geyser,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.b	#1,obPriority(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	obSubtype(a0),obSubtype(a1)
		move.b	#5,obAnim(a1)
		tst.b	obSubtype(a0)
		beq.s	+
		move.b	#2,obAnim(a1)
+
		addi.w	#$60,obY(a1)
		move.w	geyser_base_y(a0),geyser_base_y(a1)
		addi.w	#$60,geyser_base_y(a1)
		move.b	#$93,obColType(a1)
		move.b	#$80,obHeight(a1)
		bset	#4,obRender(a1)
		move.b	#$10,obRoutine(a1)		; follow-source segment
		move.l	a0,geyser_source(a1)

		tst.b	obSubtype(a0)
		beq.s	.sound
		bsr.w	FindNextFreeObj
		bne.s	.return
		_move.b	#id_GeyserMaker,obID(a1)
		move.l	#Map_Geyser,obMap(a1)
		move.w	#make_art_tile(ArtTile_MZ_Lava,3,0),obGfx(a1)
		move.b	#4,obRender(a1)
		move.b	#$20,obActWid(a1)
		move.b	#1,obPriority(a1)
		move.w	obX(a0),obX(a1)
		move.w	obY(a0),obY(a1)
		move.b	#1,obSubtype(a1)
		move.b	#2,obAnim(a1)
		move.b	#$E,obRoutine(a1)		; active lava action
		move.b	#2,ob2ndRout(a1)
		bset	#4,obGfx(a1)
		addi.w	#$100,obY(a1)
	;	clr.b	obPriority(a1)
		move.w	geyser_base_y(a0),geyser_base_y(a1)
		move.l	geyser_source(a0),geyser_source(a1)
		clr.b	obSubtype(a0)
		clr.b	ob2ndRout(a0)

.sound:
		move.w	#sfx_Burning,d0
		jmp	(QueueSound2).l
.return:	rts
; ===========================================================================

Geyser_Action:	; Routine $E
		moveq	#0,d0
		move.b	ob2ndRout(a0),d0
		move.w	Geyser_TypeIndex(pc,d0.w),d1
		jsr	Geyser_TypeIndex(pc,d1.w)
		bsr.w	SpeedToPos
		lea	(Ani_Geyser).l,a1
		bsr.w	AnimateSprite
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================
Geyser_TypeIndex:
		dc.w Geyser_Type00-Geyser_TypeIndex
		dc.w Geyser_Type01-Geyser_TypeIndex
; ===========================================================================

Geyser_Type00:
		addi.w	#$18,obVelY(a0)
		move.w	geyser_base_y(a0),d0
		cmp.w	obY(a0),d0
		bhs.s	.return
		move.b	#$12,obRoutine(a0)
		movea.l	geyser_source(a0),a1
		move.b	#3,obAnim(a1)
.return:	rts
; ===========================================================================

Geyser_Type01:
		addi.w	#$18,obVelY(a0)
		move.w	geyser_base_y(a0),d0
		cmp.w	obY(a0),d0
		bhs.s	.return
		move.b	#$12,obRoutine(a0)
		movea.l	geyser_source(a0),a1
		move.b	#1,obAnim(a1)
.return:	rts
; ===========================================================================

Geyser_FollowSource:	; Routine $10
		movea.l	geyser_source(a0),a1
		cmpi.b	#$12,obRoutine(a1)
		beq.s	Geyser_Delete
		move.w	obY(a1),d0
		addi.w	#$60,d0
		move.w	d0,obY(a0)
		sub.w	geyser_base_y(a0),d0
		neg.w	d0
		moveq	#8,d1
		cmpi.w	#$40,d0
		bge.s	.loc_F026
		moveq	#$B,d1

.loc_F026:
		cmpi.w	#$80,d0
		ble.s	.loc_F02E
		moveq	#$E,d1

.loc_F02E:
		subq.b	#1,obTimeFrame(a0)
		bpl.s	.loc_F04C
		move.b	#7,obTimeFrame(a0)
		addq.b	#1,obAniFrame(a0)
		cmpi.b	#2,obAniFrame(a0)
		blo.s	.loc_F04C
		clr.b	obAniFrame(a0)

.loc_F04C:
		move.b	obAniFrame(a0),d0
		add.b	d1,d0
		move.b	d0,obFrame(a0)
		out_of_range.w	DeleteObject
		bra.w	DisplaySprite
; ===========================================================================

Geyser_Delete:	; Routine $12
		bra.w	DeleteObject
; ===========================================================================