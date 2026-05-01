; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

SpeedToPos:
ObjectMove:
		movem.w	obVelX(a0),d0/d2			; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,obX(a0)				; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
		add.l	d2,obY(a0)				; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
		rts
; End of function ObjectMove

; =============== S U B R O U T I N E =======================================

ObjectMove_Parent:
		movem.w	obVelX(a1),d0/d2			; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,obX(a1)				; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+obX(a0)
		add.l	d2,obY(a1)				; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+obY(a0)
		rts
; End of function ObjectMove_Parent

; =============== S U B R O U T I N E =======================================

ObjectMove_Reserved:
		movem.w	obVelX(a0),d0/d2			; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,objoff_30(a0)			; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+obX(a0)
		add.l	d2,objoff_34(a0)			; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+obY(a0)
		rts
; End of function ObjectMove_Reserved

; =============== S U B R O U T I N E =======================================
; BossMove:
ObjectMove_Reserved2:
		movem.w	obVelX(a0),d0/d2			; load xy speed
		lsl.l	#8,d0					; shift velocity to line up with the middle 16 bits of the 32-bit position
		lsl.l	#8,d2					; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,objoff_30(a0)			; add to x-axis position ; note this affects the subpixel position x_sub(a0) = 2+obX(a0)
		add.l	d2,objoff_38(a0)			; add to y-axis position ; note this affects the subpixel position y_sub(a0) = 2+obY(a0)
		rts
; End of function ObjectMove_Reserved2