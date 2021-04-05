; ---------------------------------------------------------------------------
; Object 10 - Ported block from Hidrocity
; ---------------------------------------------------------------------------
lblk_height = $16		; block height
Obj10:
		moveq	#0,d0
		move.b	obSubtype(a0),d0
		move.b	d0,obFrame(a0)
		add.w	d0,d0
		lea	byte_1F38A(pc,d0.w),a1
		move.b	(a1)+,obActWid(a0)
;		move.b	(a1)+,height_pixels(a0) ; To be determined
		move.b	(a1)+,$16(a0)
;		move.l	#Map_HCZBlock,obMap(a0)
		move.l	#Map_LBlock,obMap(a0) ; Temporarily point to LZ's Mappings
;		move.w	#$43D4,obGfx(a0)
		move.w	#$43E6,obGfx(a0) ; Temporarily point to LZ's block
		ori.b	#4,obRender(a0)
		move.b	#5,obPriority(a0) ; Changed From 280 to 5 (Sonic 1/2 Priority manager)
		move.l	#Determine_length,(a0)

Determine_length:
		moveq	#0,d1
		move.b	obActWid(a0),d1
		addi.w	#$B,d1
		moveq	#0,d2
;		move.b	height_pixels(a0),d2 ; To be determined
		move.b	$16(a0),d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		bsr.w	SolidObject

		out_of_range.w	DisplaySprite,x_pos(a0)
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