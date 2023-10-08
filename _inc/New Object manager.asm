; ---------------------------------------------------------------------------
; Subroutine to	load a level's objects
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

; LevelObjManager:
ObjPosLoad:
		moveq	#0,d0
		move.b	(v_opl_routine).w,d0
		move.w	OPL_Index(pc,d0.w),d0
		jmp	OPL_Index(pc,d0.w)
; End of function ObjPosLoad

; ===========================================================================
OPL_Index:	dc.w OPL_Main-OPL_Index
		dc.w OPL_Next-OPL_Index
; ===========================================================================

OPL_Main:
		addq.b	#2,(v_opl_routine).w
		move.w	(v_zone).w,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	(ObjPos_Index).l,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,(v_opl_data).w
		move.l	a0,(v_opl_data+4).w
		move.l	a0,(v_opl_data+8).w	; Changed from a1 to a0
		move.l	a0,(v_opl_data+$C).w	; Changed from a1 to a0
		lea	(v_objstate).w,a2
		move.w	#$101,(a2)+
		move.w	#(v_objstate_end-v_objstate-2)/4-1,d0

OPL_ClrList:
		clr.l	(a2)+		; loop clears all other respawn values
		dbf	d0,OPL_ClrList
		; Clear the last word, since the above loop only does longwords.
	if (v_objstate_end-v_objstate-2)&2
		clr.w	(a2)+
	endif
		lea	(v_objstate).w,a2	; reset
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		subi.w	#$80,d6		; look one chunk to the left
		bhs.s	loc_D93C	; if the result was negative,
		moveq	#0,d6		; cap at zero

loc_D93C:
		andi.w	#$FF80,d6
		movea.l	(v_opl_data).w,a0	; load address of object placement list

loc_D944:
		cmp.w	(a0),d6		; is object's x position >= d6?
		bls.s	loc_D956	; if yes, branch
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	loc_D952	; if not, branch
		move.b	(a2),d2
		addq.b	#1,(a2)		; respawn index of next object to the right

loc_D952:
		addq.w	#6,a0		; next object
		bra.s	loc_D944
; ===========================================================================

loc_D956:
		move.l	a0,(v_opl_data).w	; remember rightmost object that has been processed, so far (we still need to look forward)
		move.l	a0,(v_opl_data+8).w
		movea.l	(v_opl_data+4).w,a0	; reset a0
		subi.w	#$80,d6			; look even farther left (any object behind this is out of range)
		bcs.s	loc_D976		; branch, if camera position would be behind level's left boundary

loc_D964:	; count how many objects are behind the screen that are not in range and need to remember their state
		cmp.w	(a0),d6		; is object's x position >= d6?
		bls.s	loc_D976	; if yes, branch
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	loc_D972	; if not, branch
		addq.b	#1,1(a2)	; respawn index of current object to the left

loc_D972:
		addq.w	#6,a0
		bra.s	loc_D964	; continue with next object
; ===========================================================================

loc_D976:
		move.l	a0,(v_opl_data+4).w
		move.l	a0,(v_opl_data+$C).w
		move.w	#-1,(v_opl_screen).w
; ---------------------------------------------------------------------------

OPL_Next:
		move.w	(v_screenposx).w,d1
		subi.w	#$80,d1
		andi.w	#$FF80,d1
		move.w	d1,(v_screenposx_coarse).w
		lea	(v_objstate).w,a2
		moveq	#0,d2
		move.w	(v_screenposx).w,d6
		andi.w	#$FF80,d6
		cmp.w	(v_opl_screen).w,d6	; is the X range the same as last time?
		beq.w	locret_DA3A		; if yes, branch (rts)
		bge.s	loc_D9F6		; if new pos is greater than old pos, branch
		; if the player is moving back
		move.w	d6,(v_opl_screen).w	; remember current position for next time
		movea.l	(v_opl_data+4).w,a0	; get current object from the left
		subi.w	#$80,d6			; look one chunk to the left
		blo.s	loc_D9D2		; branch, if camera position would be behind level's left boundary

loc_D9A6:	; load all objects left of the screen that are now in range
		cmp.w	-6(a0),d6	; is the previous object's X pos less than d6?
		bge.s	loc_D9D2	; if it is, branch
		subq.w	#6,a0		; get object's address
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	loc_D9BC	; if not, branch
		subq.b	#1,1(a2)	; respawn index of this object
		move.b	1(a2),d2

loc_D9BC:
		bsr.w	loc_DA3C	; load object
		bne.s	loc_D9C6	; branch, if SST is full
		subq.w	#6,a0
		bra.s	loc_D9A6	; continue with previous object
; ===========================================================================

loc_D9C6:	; undo a few things, if the object couldn't load
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	loc_D9D0	; if not, branch
		addq.b	#1,1(a2)	; since we didn't load the object, undo last change

loc_D9D0:
		addq.w	#6,a0		; go back to last object

loc_D9D2:
		move.l	a0,(v_opl_data+4).w	; remember current object from the left
		movea.l	(v_opl_data).w,a0	; get next object from the right
		addi.w	#$300,d6		; look two chunks beyond the right edge of the screen

loc_D9DE:	; subtract number of objects that have been moved out of range (from the right side)
		cmp.w	-6(a0),d6	; is the previous object's X pos less than d6?
		bgt.s	loc_D9F0	; if it is, branch
		tst.b	-4(a0)		; does the previous object get a respawn table entry?
		bpl.s	loc_D9EC	; if not, branch
		subq.b	#1,(a2)		; respawn index of next object to the right

loc_D9EC:
		subq.w	#6,a0
		bra.s	loc_D9DE	; continue with previous object
; ===========================================================================

loc_D9F0:
		move.l	a0,(v_opl_data).w	; remember next object from the right
		rts
; ===========================================================================

loc_D9F6:
		move.w	d6,(v_opl_screen).w
		movea.l	(v_opl_data).w,a0	; get next object from the right
		addi.w	#$280,d6		; look two chunks forward

loc_DA02:	; load all objects right of the screen that are now in range
		cmp.w	(a0),d6		; is object's x position >= d6?
		bls.s	loc_DA16	; if yes, branch
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	loc_DA10	; if not, branch
		move.b	(a2),d2		; respawn index of this object
		addq.b	#1,(a2)		; respawn index of next object to the right

loc_DA10:
		bsr.w	loc_DA3C	; load object (and get address of next object)
		beq.s	loc_DA02	; continue loading objects, if the SST isn't full
loc_DA16:
		move.l	a0,(v_opl_data).w	; remember next object from the right
		movea.l	(v_opl_data+4).w,a0	; get current object from the left
		subi.w	#$300,d6		; look one chunk behind the left edge of the screen
		bcs.s	loc_DA36		; branch, if camera position would be behind level's left boundary

loc_DA24:	; subtract number of objects that have been moved out of range (from the left)
		cmp.w	(a0),d6		; is object's x position >= d6?
		bls.s	loc_DA36	; if yes, branch
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	loc_DA32	; if not, branch
		addq.b	#1,1(a2)	; respawn index of next object to the left

loc_DA32:
		addq.w	#6,a0
		bra.s	loc_DA24	; continue with previous object
; ===========================================================================

loc_DA36:
		move.l	a0,(v_opl_data+4).w	; remember current object from the left

locret_DA3A:
		rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to check if an object needs to be loaded.
;
; input variables:
;  d2 = respawn index of object to be loaded
;
;  a0 = address in object placement list
;  a2 = object respawn table
;
; writes:
;  d0, d1
;  a1 = object
; ---------------------------------------------------------------------------

loc_DA3C:
		tst.b	2(a0)		; does the object get a respawn table entry?
		bpl.s	OPL_MakeItem	; if not, branch
		bset	#7,2(a2,d2.w)	; mark object as loaded
		beq.s	OPL_MakeItem	; branch if it wasn't already loaded
		addq.w	#6,a0		; next object
		moveq	#0,d0		; let the objects manager know that it can keep going
		rts
; ===========================================================================

OPL_MakeItem:
		bsr.w	FindFreeObj	; find empty slot
		bne.s	locret_DA8A	; branch, if there is no room left in the SST
		move.w	(a0)+,obX(a1)
		move.w	(a0)+,d0	; there are three things stored in this word
		bpl.s	+		; branch, if the object doesn't get a respawn table entry
		move.b	d2,obRespawnNo(a1)
+
		move.w	d0,d1		; copy for later
		andi.w	#$FFF,d0	; get y-position
		move.w	d0,obY(a1)
		rol.w	#3,d1		; adjust bits
		andi.b	#3,d1		; get render flags
		move.b	d1,obRender(a1)
		move.b	d1,obStatus(a1)
		_move.b	(a0)+,obID(a1)	; load obj
		move.b	(a0)+,obSubtype(a1)
		moveq	#0,d0

locret_DA8A:
		rts