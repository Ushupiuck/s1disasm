; ---------------------------------------------------------------------------
; Subroutine to	display	a sprite/object, when a0 is the	object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DisplaySprite:
		lea	(v_spritequeue).w,a1
		move.w	obPriority(a0),d0 ; get sprite priority
		lsr.w	#1,d0
		andi.w	#$380,d0
		adda.w	d0,a1		; jump to position in queue
		cmpi.w	#$7E,(a1)	; is this part of the queue full?
		bhs.s	+		; if yes, branch
		addq.w	#2,(a1)		; increment sprite count
		adda.w	(a1),a1		; jump to empty position
		move.w	a0,(a1)		; insert RAM address for object
+		rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to	display	a 2nd sprite/object, when a1 is	the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DisplaySprite1:
		lea	(v_spritequeue).w,a2
		move.w	obPriority(a1),d0
		lsr.w	#1,d0
		andi.w	#$380,d0
		adda.w	d0,a2
		cmpi.w	#$7E,(a2)
		bhs.s	+
		addq.w	#2,(a2)
		adda.w	(a2),a2
		move.w	a1,(a2)
+		rts
; End of function DisplaySprite1

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already (priority/2)&$380
; ---------------------------------------------------------------------------


DisplaySprite3:
		lea	(v_spritequeue).w,a1
		adda.w	d0,a1
		cmpi.w	#$7E,(a1)
		bhs.s	+
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)
+		rts