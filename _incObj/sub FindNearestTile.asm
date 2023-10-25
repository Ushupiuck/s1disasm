; ---------------------------------------------------------------------------
; Subroutine to	find which tile	the object is standing on

; input:
;	d2 = y-position of object's bottom edge
;	d3 = x-position of object

; output:
;	a1 = address within 256x256 mappings where object is standing
;	     (refers to a 16x16 tile number)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


FindNearestTile:
		move.w	d2,d0			; d0 = Y-pos (sensor)
		lsr.w	#1,d0			; d0 = Y-pos / 4
		andi.w	#$380,d0		; d0 = (Y-pos / $100) * $80
		move.w	d3,d1			; d1 = X-pos (sensor)
		lsr.w	#8,d1			; d1 = X-pos / $100
		andi.w	#$7F,d1			; d1 = (X-pos / $100) & $7F
		add.w	d1,d0			; d0 = in-layout pos
		moveq	#-1,d1
		clr.w	d1
		lea	(v_lvllayout).w,a1
		move.b	(a1,d0.w),d1		; d1 = chunk id
		beq.s	.EmptyChunk		; if chunk = $00, branch
		bmi.s	.LoopChunk
.GetChunk:	; Calculate address within chunk where object stands
		add.w	d1,d1
		move.w	.GetChunkOffset-2(pc,d1.w),d1
		move.w	d2,d0
		add.w	d0,d0
		andi.w	#$1E0,d0
		add.w	d0,d1
		move.w	d3,d0
		lsr.w	#3,d0
		andi.w	#$1E,d0
		add.w	d0,d1
		movea.l d1,a1
		rts

.EmptyChunk:
		lea	.NullBlock(pc),a1
		rts
; ===========================================================================
.LoopChunk:
		andi.w	#$7F,d1
		btst	#6,obRender(a0)		; is object on the low plane?
		beq.s	.GetChunk		; if not, branch
		addq.w	#1,d1			; swap collision layer
		bra.s	.GetChunk
; ===========================================================================
.NullBlock:					; they both start with $0000
.GetChunkOffset:
c := 0
	while c<$A400
		dc.w	c
c := c+$200
	endm