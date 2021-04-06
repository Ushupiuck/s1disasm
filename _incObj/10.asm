; ---------------------------------------------------------------------------
; Object 10 - Ported block from Hidrocity
; ---------------------------------------------------------------------------
Obj10:
		moveq	#0,d0
		move.b	obRoutine(a0),d0
		move.w	HCBlk_Index(pc,d0.w),d1
		jmp	HCBlk_Index(pc,d1.w)
; ===========================================================================
HCBlk_Index:	dc.w HCBlk_Main-HCBlk_Index
		dc.w Determine_length-HCBlk_Index
; ===========================================================================
HCBlk_Main:
		addq.b	#2,obRoutine(a0)
		move.b	obSubtype(a0),d0
		move.b	d0,obFrame(a0)
		add.w	d0,d0
		lea	byte_1F38A(pc,d0.w),a1
		move.b	(a1)+,obActWid(a0)
		move.w	#$F,obHeight(a0)
		move.b	(a1)+,obHeight(a0)
		move.l	#Map_HCZBlock,obMap(a0)
		move.w	#$41F0,obGfx(a0)
		ori.b	#4,obRender(a0)
		move.b	#5,obPriority(a0) ; Changed From 280 to 5 (Sonic 1/2 Priority manager)

Determine_length:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
		move.b	obHeight(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		jsr	SolidObject
		out_of_range.w	DeleteObject
		jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
byte_1F38A:	dc.b $10
		dc.b $10
		dc.b $20
		dc.b $10
		dc.b $30
		dc.b $10
		dc.b $40
		dc.b $10
; ---------------------------------------------------------------------------