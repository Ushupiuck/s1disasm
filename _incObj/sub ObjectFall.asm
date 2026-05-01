; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

ObjectFall:
ObjectMoveAndFall:
		movem.w	obVelX(a0),d0/d2			; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,obX(a0)				; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
		add.l	d2,obY(a0)				; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
		addi.w	#$38,obVelY(a0)				; increase vertical speed (apply gravity)
		rts
; End of function ObjectMoveAndFall

; =============== S U B R O U T I N E =======================================

ObjectMoveAndFall_LightGravity:
		moveq	#$20,d1

ObjectMoveAndFall_CustomGravity:
		movem.w	obVelX(a0),d0/d2			; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,obX(a0)				; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+obX(a0)
		add.l	d2,obY(a0)				; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+obY(a0)
		add.w	d1,obVelY(a0)				; increase vertical speed (apply gravity)
		rts
; End of function ObjectMoveAndFall_LightGravity

; =============== S U B R O U T I N E =======================================

ObjectMoveAndFall_Parent:
		moveq	#$38,d1

ObjectMoveAndFall_Parent_CustomGravity:
		movem.w	obVelX(a1),d0/d2				; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,obX(a1)				; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+obX(a0)
		add.l	d2,obY(a1)				; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+obY(a0)
		add.w	d1,obVelY(a1)				; increase vertical speed (apply gravity)
		rts
; End of function ObjectMoveAndFall_Parent

; =============== S U B R O U T I N E =======================================

ObjectMoveAndFall_Reserved:
		movem.w	obVelX(a0),d0/d2				; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,objoff_30(a0)			; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+obX(a0)
		add.l	d2,objoff_34(a0)			; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+obY(a0)
		addi.w	#$38,obVelY(a0)				; increase vertical speed (apply gravity)
		rts
; End of function ObjectMoveAndFall_Reserved