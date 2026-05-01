; ---------------------------------------------------------------------------
; Object 33 - Pushable blocks (MZ, LZ)
; ---------------------------------------------------------------------------
;
; Notes:
; - This object has 3 main object routines:
;     0 = init
;     2 = main idle/pushing logic
;     4 = parked off-screen until visible again
; - It also has an internal state machine driven by obSolid:
;     0 = normal solid interaction / can be pushed
;     2 = Sonic standing on block / platform maintenance
;     4 = airborne block falling after geyser launch or lost support
;     6 = actively sliding after a push
; - objoff_32 is the "lava-ride" / moving-across-lava state flag.
; - objoff_30 stores the last horizontal speed used to continue sliding.
;
; ---------------------------------------------------------------------------
; Object-specific SST fields
; ---------------------------------------------------------------------------
gmake_caller		= objoff_2C	; child parent pointer (used by producers spawned from Obj33)
pblock_saved_velx	= objoff_30	; cached X velocity used when resuming movement after landing
pblock_spawn_x		= objoff_32	; original X position
pblock_spawn_y		= objoff_34	; original Y position
pblock_lava_ride	= objoff_36	; 1 = block is in special moving/ride state (lava/geyser sequence)

PushBlock:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	PushB_Index(pc,d0.w),d1
		jmp	PushB_Index(pc,d1.w)
; ===========================================================================
PushB_Index:	dc.w PushB_Init-PushB_Index
		dc.w PushB_Main-PushB_Index
		dc.w PushB_Parked-PushB_Index

PushB_Var:	dc.b $10, 0	; normal block: half-width, frame
		dc.b $40, 1	; 4-length block: half-width, frame
; ===========================================================================

PushB_Init:	; Routine 0
		addq.b	#2,obRoutine(a0)
		move.b	#$F,obHeight(a0)
		move.b	#$F,obWidth(a0)
		move.l	#Map_Push,obMap(a0)
		move.w	#make_art_tile(ArtTile_MZ_Block,2,0),obGfx(a0)	; MZ art
		cmpi.b	#id_LZ,(v_zone).w
		bne.s	.notLZ
		move.w	#make_art_tile(ArtTile_LZ_Push_Block,2,0),obGfx(a0)	; LZ art

.notLZ:
		move.b	#4,obRender(a0)
		move.b	#3,obPriority(a0)
		move.w	obX(a0),pblock_spawn_x(a0)
		move.w	obY(a0),pblock_spawn_y(a0)
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		add.w	d0,d0
		andi.w	#$E,d0
		lea	PushB_Var(pc,d0.w),a2
		move.b	(a2)+,obActWid(a0)
		move.b	(a2)+,obFrame(a0)
		tst.b	obSubtype(a0)
		beq.s	.chkgone
		move.w	#make_art_tile(ArtTile_MZ_Block,2,1),obGfx(a0)

.chkgone:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	PushB_Main
		bclr	#7,2(a2,d0.w)
		bset	#0,2(a2,d0.w)
		bne.w	DeleteObject

PushB_Main:	; Routine 2
		tst.b	pblock_lava_ride(a0)
		bne.w	PushB_MoveState
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		move.w	#$10,d2
		move.w	#$11,d3
		move.w	obX(a0),d4
		bsr.w	PushB_SolidLogic
		cmpi.w	#id_MZ_act1,(v_zone).w
		bne.s	PushB_RangeCheck
		bclr	#7,obSubtype(a0)
		move.w	obX(a0),d0
		cmpi.w	#$A20,d0
		blo.s	PushB_RangeCheck
		cmpi.w	#$AA1,d0
		bhs.s	PushB_RangeCheck
		move.w	(v_obj31ypos).w,d0
		subi.w	#$1C,d0
		move.w	d0,obY(a0)
		bset	#7,(v_obj31ypos).w
		bset	#7,obSubtype(a0)

PushB_RangeCheck:
		out_of_range.s	PushB_ResetOrDelete
		bra.w	DisplaySprite
; ===========================================================================
PushB_ResetOrDelete:
		out_of_range.s	PushB_Delete,pblock_spawn_x(a0)
		move.w	pblock_spawn_x(a0),obX(a0)
		move.w	pblock_spawn_y(a0),obY(a0)
		move.b	#4,obRoutine(a0)

PushB_Parked:	; Routine 4
		bsr.w	ChkPartiallyVisible
		beq.s	.return
		move.b	#2,obRoutine(a0)
		clr.b	pblock_lava_ride(a0)
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
.return:	rts
; ===========================================================================
PushB_Delete:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	+
		bclr	#0,2(a2,d0.w)
+		bra.w	DeleteObject
; ===========================================================================

PushB_MoveState:
		move.w	obX(a0),-(sp)
		cmpi.b	#4,obSolid(a0)
		bhs.s	.checkState
		bsr.w	SpeedToPos

.checkState:
		btst	#1,obStatus(a0)
		beq.s	PushB_RideMove
		addi.w	#$18,obVelY(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.w	PushB_PostMove
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		bclr	#1,obStatus(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0
		blo.w	PushB_PostMove
		move.w	pblock_saved_velx(a0),d0
		asr.w	#3,d0
		move.w	d0,obVelX(a0)
		move.b	#1,pblock_lava_ride(a0)
		clr.w	obY+2(a0)
		bra.w	PushB_PostMove
; ===========================================================================
PushB_RideMove:
		tst.w	obVelX(a0)
		beq.w	PushB_FallOut
		bmi.s	PushB_RideMoveLeft
		moveq	#0,d3
		move.b	obActWid(a0),d3
		jsr	(ObjHitWallRight).l
		tst.w	d1
		bmi.s	PushB_StopPush
		bsr.s	PushB_CheckRideSupport
		bra.w	PushB_PostMove
; ===========================================================================
PushB_RideMoveLeft:
		moveq	#0,d3
		move.b	obActWid(a0),d3
		not.w	d3
		jsr	(ObjHitWallLeft).l
		tst.w	d1
		bmi.s	PushB_StopPush
		bsr.s	PushB_CheckRideSupport
		bra.w	PushB_PostMove
; ===========================================================================
PushB_CheckRideSupport:
		jsr	(ObjFloorDist).l
		cmpi.w	#4,d1
		bgt.s	.lostground
		add.w	d1,obY(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0
		bhs.s	.return
		clr.b	pblock_lava_ride(a0)
		clr.w	obVelX(a0)
		rts

.lostground:
		bset	#1,obStatus(a0)		; fall exactly like geyser-launched block
.return:	rts
; ===========================================================================
PushB_StopPush:
		clr.w	obVelX(a0)
		bra.s	PushB_PostMove
; ===========================================================================
PushB_FallOut:
		addi.l	#$2001,obY(a0)
		cmpi.b	#$A0,obY+3(a0)
		bhs.w	PushB_FellTooFar

PushB_PostMove:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#$10,d2
		moveq	#$11,d3
		move.w	(sp)+,d4
		bsr.w	PushB_SolidLogic
		bsr.w	PushB_CheckLavaTrigger
		out_of_range.s	PushB_ResetOrDelete2
		bra.w	DisplaySprite
; ===========================================================================
PushB_ResetOrDelete2:
		out_of_range.s	PushB_Delete2,pblock_spawn_x(a0)
		move.w	pblock_spawn_x(a0),obX(a0)
		move.w	pblock_spawn_y(a0),obY(a0)
		move.b	#4,obRoutine(a0)
		bsr.w	ChkPartiallyVisible
		beq.s	.return
		move.b	#2,obRoutine(a0)
		clr.b	pblock_lava_ride(a0)
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
.return:	rts
; ===========================================================================
PushB_Delete2:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	+
		bclr	#0,2(a2,d0.w)
+		bra.w	DeleteObject
; ===========================================================================
PushB_FellTooFar:
		move.w	(sp)+,d4
		lea	(v_player).w,a1
		bclr	#3,obStatus(a1)
		bclr	#3,obStatus(a0)
		out_of_range.s	PushB_Delete3,pblock_spawn_x(a0)
		move.w	pblock_spawn_x(a0),obX(a0)
		move.w	pblock_spawn_y(a0),obY(a0)
		move.b	#4,obRoutine(a0)
		bsr.w	ChkPartiallyVisible
		beq.s	.return
		move.b	#2,obRoutine(a0)
		clr.b	pblock_lava_ride(a0)
		clr.w	obVelX(a0)
		clr.w	obVelY(a0)
.return:	rts
; ===========================================================================
PushB_Delete3:
		lea	(v_objstate).w,a2
		moveq	#0,d0
		move.b	obRespawnNo(a0),d0
		beq.s	+
		bclr	#0,2(a2,d0.w)
+		bra.w	DeleteObject
; ===========================================================================

PushB_CheckLavaTrigger:
		cmpi.w	#id_MZ_act2,(v_zone).w
		bne.s	PushB_CheckLavaTrigger2
		move.w	#-$20,d2
		cmpi.w	#$DD0,obX(a0)
		beq.s	PushB_SpawnGeyserMaker
		cmpi.w	#$CC0,obX(a0)
		beq.s	PushB_SpawnGeyserMaker
		cmpi.w	#$BA0,obX(a0)
		beq.s	PushB_SpawnGeyserMaker
		rts
; ===========================================================================
PushB_CheckLavaTrigger2:
		cmpi.w	#id_MZ_act3,(v_zone).w
		bne.s	PushB_NoLava
		move.w	#$20,d2
		cmpi.w	#$560,obX(a0)
		beq.s	PushB_SpawnGeyserMaker
		cmpi.w	#$5C0,obX(a0)
		beq.s	PushB_SpawnGeyserMaker

PushB_NoLava:
		rts
; ===========================================================================
PushB_SpawnGeyserMaker:
		bsr.w	FindFreeObj
		bne.s	.return
		_move.b	#id_GeyserMaker,obID(a1)
		move.w	obX(a0),obX(a1)
		add.w	d2,obX(a1)
		move.w	obY(a0),obY(a1)
		addi.w	#$10,obY(a1)
		move.l	a0,gmake_caller(a1)
.return:	rts
; ===========================================================================

PushB_SolidLogic:
		move.b	obSolid(a0),d0
		beq.w	PushB_CheckEnter
		subq.b	#2,d0
		bne.s	PushB_FallingState
		bsr.w	ExitPlatform
		btst	#3,obStatus(a1)
		bne.s	PushB_MoveSonicOnPlatform
		clr.b	obSolid(a0)
		rts
; ===========================================================================
PushB_MoveSonicOnPlatform:
		move.w	d4,d2
		bra.w	MvSonicOnPtfm
; ===========================================================================
PushB_FallingState:
		subq.b	#2,d0
		bne.s	PushB_SlidingState
		bsr.w	SpeedToPos
		addi.w	#$18,obVelY(a0)
		jsr	(ObjFloorDist).l
		tst.w	d1
		bpl.s	.return
		add.w	d1,obY(a0)
		clr.w	obVelY(a0)
		clr.b	obSolid(a0)
		move.w	(a1),d0
		andi.w	#$3FF,d0
		cmpi.w	#$16A,d0
		blo.s	.return
		move.w	pblock_saved_velx(a0),d0
		asr.w	#3,d0
		move.w	d0,obVelX(a0)
		move.b	#1,pblock_lava_ride(a0)
		clr.w	obY+2(a0)
.return:	rts
; ===========================================================================
PushB_SlidingState:
		bsr.w	SpeedToPos
		move.w	obX(a0),d0
		andi.w	#$C,d0
		bne.s	.return
		andi.w	#-$10,obX(a0)
		move.w	obVelX(a0),pblock_saved_velx(a0)
		clr.w	obVelX(a0)
		subq.b	#2,obSolid(a0)
.return:	rts
; ===========================================================================
PushB_CheckEnter:
		bsr.w	Solid_ChkEnter
		tst.w	d4
		beq.s	.return0
		bmi.s	.return0
		tst.b	pblock_lava_ride(a0)
		beq.s	+
.return0:	rts
; ===========================================================================
+
		tst.w	d0
		beq.s	.return
		bmi.s	PushB_PushLeft
		btst	#0,obStatus(a1)
		bne.s	.return
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	obActWid(a0),d3
		jsr	(ObjHitWallRight).l
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	.return
		addi.l	#$10000,obX(a0)
		moveq	#1,d0
		move.w	#$40,d1
		lea	(v_player).w,a1
		add.w	d0,obX(a1)
		move.w	d1,obInertia(a1)
		move.w	#0,obVelX(a1)
		move.w	d0,-(sp)
		move.w	#sfx_Push,d0
		jsr	(QueueSound2).l
		move.w	(sp)+,d0
		tst.b	obSubtype(a0)
		bmi.s	.return
		move.w	d0,-(sp)
		jsr	(ObjFloorDist).l
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	.adjustY
		move.w	#$400,obVelX(a0)
		tst.w	d0
		bpl.s	+
		neg.w	obVelX(a0)
+		move.b	#6,obSolid(a0)
.return:	rts
; ===========================================================================
.adjustY:
		add.w	d1,obY(a0)
		rts
; ===========================================================================
PushB_PushLeft:
		btst	#0,obStatus(a1)
		beq.s	.return
		move.w	d0,-(sp)
		moveq	#0,d3
		move.b	obActWid(a0),d3
		not.w	d3
		jsr	(ObjHitWallLeft).l
		move.w	(sp)+,d0
		tst.w	d1
		bmi.s	.return
		subi.l	#$10000,obX(a0)
		moveq	#-1,d0
		move.w	#-$40,d1
		lea	(v_player).w,a1
		add.w	d0,obX(a1)
		move.w	d1,obInertia(a1)
		move.w	#0,obVelX(a1)
		move.w	d0,-(sp)
		move.w	#sfx_Push,d0
		jsr	(QueueSound2).l
		move.w	(sp)+,d0
		tst.b	obSubtype(a0)
		bmi.s	.return
		move.w	d0,-(sp)
		jsr	(ObjFloorDist).l
		move.w	(sp)+,d0
		cmpi.w	#4,d1
		ble.s	PushB_CheckEnter.adjustY
		move.w	#$400,obVelX(a0)
		tst.w	d0
		bpl.s	+
		neg.w	obVelX(a0)
+		move.b	#6,obSolid(a0)
.return:	rts
; ===========================================================================