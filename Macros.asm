; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 4 bytes per iteration
bytesToLcnt function n,n>>2-1

; calculates initial loop counter value for a dbf loop
; that writes n bytes total at 2 bytes per iteration
bytesToWcnt function n,n>>1-1
; fills a region of 68k RAM with 0
clearRAM macro startaddr,size
	if ((startaddr)&$8000)==0
	lea	(startaddr).l,a1
	else
	lea	(startaddr).w,a1
	endif
	moveq	#0,d0
	if ((startaddr)&1)
	move.b	d0,(a1)+
	endif
	move.w	#bytesToLcnt((size) - ((startaddr)&1)),d1
-	move.l	d0,(a1)+
	dbf	d1,-
	if (((size) - ((startaddr)&1))&2)
	move.w	d0,(a1)+
	endif
	if (((size) - ((startaddr)&1))&1)
	move.b	d0,(a1)+
	endif
	endm
; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if ("controlport"=="")
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),(vdp_control_port).l
		else
		move.l	#($40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14)),controlport
		endif
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro source,length,destination
		lea	(vdp_control_port).l,a5
		move.l	#$94000000+(((length>>1)&$FF00)<<8)+$9300+((length>>1)&$FF),(a5)
		move.l	#$96000000+(((source>>1)&$FF00)<<8)+$9500+((source>>1)&$FF),(a5)
		move.w	#$9700+((((source>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(destination&$3FFF),(a5)
		move.w	#$80+((destination&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro source,length,destination
		lea	(vdp_control_port).l,a5
		move.l	#$94000000+(((length>>1)&$FF00)<<8)+$9300+((length>>1)&$FF),(a5)
		move.l	#$96000000+(((source>>1)&$FF00)<<8)+$9500+((source>>1)&$FF),(a5)
		move.w	#$9700+((((source>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$C000+(destination&$3FFF),(a5)
		move.w	#$80+((destination&$C000)>>14),(v_vdp_buffer2).w
		move.w	(v_vdp_buffer2).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro value,length,loc ; To be replaced
		lea	(vdp_control_port).l,a5
		move.w	#$8F01,(a5)
		move.l	#$94000000+((length&$FF00)<<8)+$9300+(length&$FF),(a5)
		move.w	#$9780,(a5)
		move.l	#$40000080+((loc&$3FFF)<<16)+((loc&$C000)>>14),(a5)
		move.w	#value,(vdp_data_port).l
-		move.w	(a5),d1
		btst	#1,d1
		bne.s	- ; busy loop until the VDP is finished filling...
		move.w	#$8F02,(a5) ; VRAM pointer increment: $0002
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,loc,width,height
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		bsr.w	TilemapToVRAM
		endm

; ---------------------------------------------------------------------------
; stop the Z80
; ---------------------------------------------------------------------------

stopZ80:	macro
		move.w	#$100,(z80_bus_request).l
		endm

; ---------------------------------------------------------------------------
; wait for Z80 to stop
; ---------------------------------------------------------------------------

waitZ80:	macro
.wait:	btst	#0,(z80_bus_request).l
		bne.s	.wait
		endm

; ---------------------------------------------------------------------------
; reset the Z80
; ---------------------------------------------------------------------------

resetZ80:	macro
		move.w	#$100,(z80_reset).l
		endm

resetZ80a:	macro
		move.w	#0,(z80_reset).l
		endm

; ---------------------------------------------------------------------------
; start the Z80
; ---------------------------------------------------------------------------

startZ80:	macro
		move.w	#0,(z80_bus_request).l
		endm

; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macro
		move	#$2700,sr
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move	#$2300,sr
		endm

; ---------------------------------------------------------------------------
; long conditional jumps
; ---------------------------------------------------------------------------

jhi:		macro loc
		bls.s	.nojump
		jmp	loc
.nojump:
		endm

jcc:		macro loc
		bcs.s	.nojump
		jmp	loc
.nojump:
		endm

jhs:		macro loc
		jcc	loc
		endm

jls:		macro loc
		bhi.s	.nojump
		jmp	loc
.nojump:
		endm

jcs:		macro loc
		bcc.s	.nojump
		jmp	loc
.nojump:
		endm

jlo:		macro loc
		jcs	loc
		endm

jeq:		macro loc
		bne.s	.nojump
		jmp	loc
.nojump:
		endm

jne:		macro loc
		beq.s	.nojump
		jmp	loc
.nojump:
		endm

jgt:		macro loc
		ble.s	.nojump
		jmp	loc
.nojump:
		endm

jge:		macro loc
		blt.s	.nojump
		jmp	loc
.nojump:
		endm

jle:		macro loc
		bgt.s	.nojump
		jmp	loc
.nojump:
		endm

jlt:		macro loc
		bge.s	.nojump
		jmp	loc
.nojump:
		endm

jpl:		macro loc
		bmi.s	.nojump
		jmp	loc
.nojump:
		endm

jmi:		macro loc
		bpl.s	.nojump
		jmp	loc
.nojump:
		endm

; ---------------------------------------------------------------------------
; check if object moves out of range
; input: location to jump to if out of range, x-axis pos (obX(a0) by default)
; ---------------------------------------------------------------------------

out_of_range:	macro exit,pos
		if ("pos"<>"")
		move.w	pos,d0		; get object position (if specified as not obX)
		else
		move.w	obX(a0),d0	; get object position
		endif
		andi.w	#$FF80,d0	; round down to nearest $80
		sub.w	(v_screenposx_coarse).w,d0 ; get approximate distance between object and screen
		cmpi.w	#128+320+192,d0
		jhi	exit
		endm

; ---------------------------------------------------------------------------
; play a sound effect or music
; input: track, terminate routine, branch or jump, move operand size
; ---------------------------------------------------------------------------

music:		macro track,terminate,branch,byte
		  if (OptimiseSound<>0)
			move.b	#track,(v_snddriver_ram+v_soundqueue0).l
		    if ("terminate"<>"0")
			rts
		    endif
		  else
	 	    if ("byte"<>"0")
			move.b	#track,d0
		    else
			move.w	#track,d0
		    endif
		    if ("branch"<>"0")
		      if ("terminate"="0")
			bsr.w	PlaySound
		      else
			bra.w	PlaySound
		      endif
		    else
		      if ("terminate"="0")
			jsr	(PlaySound).l
		      else
			jmp	(PlaySound).l
		      endif
		    endif
		  endif
		endm

sfx:		macro track,terminate,branch,byte
		  if (OptimiseSound<>0)
			move.b	#track,(v_snddriver_ram+v_soundqueue1).l
		    if ("terminate"<>"0")
			rts
		    endif
		  else
	 	    if ("byte"<>"0")
			move.b	#track,d0
		    else
			move.w	#track,d0
		    endif
		    if ("branch"<>"0")
		      if ("terminate"="0")
			bsr.w	PlaySound_Special
		      else
			bra.w	PlaySound_Special
		      endif
		    else
		      if ("terminate"="0")
			jsr	(PlaySound_Special).l
		      else
			jmp	(PlaySound_Special).l
		      endif
		    endif
		  endif
		endm

; ---------------------------------------------------------------------------
; bankswitch between SRAM and ROM
; (remember to enable SRAM in the header first!)
; ---------------------------------------------------------------------------

gotoSRAM:	macro
		move.b  #1,($A130F1).l
		endm

gotoROM:	macro
		move.b  #0,($A130F1).l
		endm

; ---------------------------------------------------------------------------
; compare the size of an index with ZoneCount constant
; (should be used immediately after the index)
; input: index address, element size
; ---------------------------------------------------------------------------

zonewarning:	macro loc,elementsize
._end:
		if (._end-loc)-(ZoneCount*elementsize)<>0
		warning "Size of loc (\{(._end-loc)/elementsize}) does not match ZoneCount (\{ZoneCount})."
		endif
		endm
