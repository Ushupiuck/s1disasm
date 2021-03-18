; ---------------------------------------------------------------------------
; Background layer deformation subroutines
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


DeformLayers:
		tst.b	(f_nobgscroll).w
		beq.s	.bgscroll
		rts
; ===========================================================================

	.bgscroll:
		clr.w	(v_fg_scroll_flags).w
		clr.w	(v_bg1_scroll_flags).w
		clr.w	(v_bg2_scroll_flags).w
		clr.w	(v_bg3_scroll_flags).w
		; used both in horizontal an vertical scrolling
		lea (v_fg_scroll_flags).w,a3

	    ; Horizontal Scrolling
		lea	(v_screenposx).w,a1
		lea	(v_scrshiftx).w,a4
		bsr.w	ScrollHoriz

		; Vertical Scrolling
		lea (v_screenposy).w,a1
		lea	(v_scrshifty).w,a4
		bsr.w	ScrollVertical

		bsr.w	DynamicLevelEvents
.dead:
		rts
ScreenEvents:
		tst.b	(f_nobgscroll).w
		bne.s	.dead
		move.w	(v_screenposy).w,(v_scrposy_dup).w
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		moveq	#0,d0
		move.b	(v_zone).w,d0
		add.w	d0,d0
		move.w	Deform_Index(pc,d0.w),d0
		jmp	Deform_Index(pc,d0.w)
		;clr.w   (v_spritequeue+prio0).w
		;clr.w   (v_spritequeue+prio1).w
		;clr.w   (v_spritequeue+prio2).w
		;clr.w   (v_spritequeue+prio3).w
		;clr.w   (v_spritequeue+prio4).w
		;clr.w   (v_spritequeue+prio5).w
		;clr.w   (v_spritequeue+prio6).w
		;clr.w   (v_spritequeue+prio7).w
.dead:
		rts
; End of function DeformLayers
; ===========================================================================
; ---------------------------------------------------------------------------
; Offset index for background layer deformation	code
; ---------------------------------------------------------------------------
Deform_Index:	dc.w Deform_GHZ-Deform_Index, Deform_LZ-Deform_Index
		dc.w Deform_MZ-Deform_Index, Deform_SLZ-Deform_Index
		dc.w Deform_SYZ-Deform_Index, Deform_SBZ-Deform_Index
		zonewarning Deform_Index,2
		dc.w Deform_GHZ-Deform_Index
; ---------------------------------------------------------------------------
; Green	Hill Zone background layer deformation code
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
Deform_GHZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#0,d6
		bsr.w	BGScroll_Block3
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#0,d6
		bsr.w	BGScroll_Block2
		lea	(v_hscrolltablebuffer).w,a1
		move.w	(v_screenposy).w,d0
		andi.w	#$7FF,d0
		lsr.w	#5,d0
		neg.w	d0
		addi.w	#$20,d0
		bpl.s	loc_62F6
		moveq	#0,d0
loc_62F6:
		move.w	d0,d4
		move.w	d0,(v_bgscrposy_dup).w
		move.w	(v_screenposx).w,d0
		cmpi.b	#id_Title,(v_gamemode).w
		bne.s	loc_630A
		moveq	#0,d0
loc_630A:
		neg.w	d0
		swap	d0
		lea	(v_bgscroll_buffer).w,a2
		addi.l	#$10000,(a2)+
		addi.l	#$C000,(a2)+
		addi.l	#$8000,(a2)+
		move.w	(v_bgscroll_buffer).w,d0
		add.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#$1F,d1
		sub.w	d4,d1
		bcs.s	loc_633C
loc_6336:
		move.l	d0,(a1)+
		dbf	d1,loc_6336
loc_633C:
		move.w	(v_lvllayoutbg).w,d0
		add.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#$F,d1
loc_634A:
		move.l	d0,(a1)+
		dbf	d1,loc_634A
		move.w	(v_bgscroll_buffer).w,d0
		add.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#$F,d1
loc_635E:
		move.l	d0,(a1)+
		dbf	d1,loc_635E
		move.w	#$2F,d1
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
loc_636E:
		move.l	d0,(a1)+
		dbf	d1,loc_636E
		move.w	#$27,d1
		move.w	(v_bg2screenposx).w,d0
		neg.w	d0
loc_637E:
		move.l	d0,(a1)+
		dbf	d1,loc_637E
		move.w	(v_bg2screenposx).w,d0
		move.w	(v_screenposx).w,d2
		sub.w	d0,d2
		ext.l	d2
		asl.l	#8,d2
		divs.w	#$68,d2
		ext.l	d2
		asl.l	#8,d2
		moveq	#0,d3
		move.w	d0,d3
		move.w	#$47,d1
		add.w	d4,d1
loc_63A4:
		move.w	d3,d0
		neg.w	d0
		move.l	d0,(a1)+
		swap	d3
		add.l	d2,d3
		swap	d3
		dbf	d1,loc_63A4
		rts
; End of function Deform_GHZ
; ---------------------------------------------------------------------------
; Labyrinth Zone background layer deformation code
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
Deform_LZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	BGScroll_XY
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		lea	(Lz_Scroll_Data).l,a3
		lea	(Drown_WobbleData).l,a2
		move.b	(v_lz_deform).w,d2
		move.b	d2,d3
		addi.w	#$80,(v_lz_deform).w
		add.w	(v_bgscreenposy).w,d2
		andi.w	#$FF,d2
		add.w	(v_screenposy).w,d3
		andi.w	#$FF,d3
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$DF,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		move.w	d0,d6
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		move.w	(v_waterpos1).w,d4
		move.w	(v_screenposy).w,d5
loc_6418:
		cmp.w	d4,d5
		bge.s	loc_642A
		move.l	d0,(a1)+
		addq.w	#1,d5
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,loc_6418
		rts
loc_642A:
		move.b	(a3,d3),d4
		ext.w	d4
		add.w	d6,d4
		move.w	d4,(a1)+
		move.b	(a2,d2),d4
		ext.w	d4
		add.w	d0,d4
		move.w	d4,(a1)+
		addq.b	#1,d2
		addq.b	#1,d3
		dbf	d1,loc_642A
		rts
Lz_Scroll_Data:
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $FF,$FF,$FE,$FE,$FD,$FD,$FD,$FD,$FE,$FE,$FF,$FF,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $01,$01,$02,$02,$03,$03,$03,$03,$02,$02,$01,$01,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; End of function Deform_LZ
; ---------------------------------------------------------------------------
; Marble Zone background layer deformation code
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
Deform_MZ:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#2,d6
		bsr.w	BGScroll_Block1
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#6,d6
		bsr.w	BGScroll_Block3
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#4,d6
		bsr.w	BGScroll_Block2
		move.w	#$200,d0
		move.w	(v_screenposy).w,d1
		subi.w	#$1C8,d1
		bcs.s	loc_6590
		move.w	d1,d2
		add.w	d1,d1
		add.w	d2,d1
		asr.w	#2,d1
		add.w	d1,d0
loc_6590:
		move.w	d0,(v_bg2screenposy).w
		move.w	d0,(v_bg3screenposy).w
		bsr.w	BGScroll_YAbsolute
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		move.b	(v_bg1_scroll_flags).w,d0
		or.b	(v_bg2_scroll_flags).w,d0
		or.b	d0,(v_bg3_scroll_flags).w
		clr.b	(v_bg1_scroll_flags).w
		clr.b	(v_bg2_scroll_flags).w
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#2,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#5,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#4,d1
loc_65DE:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_65DE
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#1,d1
loc_65F4:
		move.w	d0,(a1)+
		dbf	d1,loc_65F4
		move.w	(v_bg2screenposx).w,d0
		neg.w	d0
		move.w	#8,d1
loc_6604:
		move.w	d0,(a1)+
		dbf	d1,loc_6604
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		move.w	#$F,d1
loc_6614:
		move.w	d0,(a1)+
		dbf	d1,loc_6614
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		subi.w	#$200,d0
		move.w	d0,d2
		cmpi.w	#$100,d0
		bcs.s	loc_6632
		move.w	#$100,d0
loc_6632:
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X
; End of function Deform_MZ
; ---------------------------------------------------------------------------
; Star Light Zone background layer deformation code
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
Deform_SLZ:
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#7,d5
		bsr.w	Bg_Scroll_Y
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$1C,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#$1B,d1
loc_6678:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_6678
		move.w	d2,d0
		asr.w	#3,d0
		move.w	d0,d1
		asr.w	#1,d1
		add.w	d1,d0
		move.w	#4,d1
loc_6692:
		move.w	d0,(a1)+
		dbf	d1,loc_6692
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#4,d1
loc_66A0:
		move.w	d0,(a1)+
		dbf	d1,loc_66A0
		move.w	d2,d0
		asr.w	#1,d0
		move.w	#$1D,d1
loc_66AE:
		move.w	d0,(a1)+
		dbf	d1,loc_66AE
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2
		subi.w	#$C0,d0
		andi.w	#$3F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
;-------------------------------------------------------------------------------
Bg_Scroll_X:
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#$E,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		andi.w	#$F,d2
		add.w	d2,d2
		move.w	(a2)+,d0
		jmp	loc_66EA(pc,d2.w)
Loop_Bg_Scroll_X:
		move.w	(a2)+,d0
loc_66EA:
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		move.l	d0,(a1)+
		dbf	d1,Loop_Bg_Scroll_X
		rts
; ---------------------------------------------------------------------------
; Spring Yard Zone background layer deformation	code
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
Deform_SYZ:
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#4,d5
		move.l	d5,d1
		asl.l	#1,d5
		add.l	d1,d5
		bsr.w	Bg_Scroll_Y
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		move.w	d2,d0
		asr.w	#3,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#8,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#7,d1
loc_6750:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_6750
		move.w	d2,d0
		asr.w	#3,d0
		move.w	#4,d1
loc_6764:
		move.w	d0,(a1)+
		dbf	d1,loc_6764
		move.w	d2,d0
		asr.w	#2,d0
		move.w	#5,d1
loc_6772:
		move.w	d0,(a1)+
		dbf	d1,loc_6772
		move.w	d2,d0
		move.w	d2,d1
		asr.w	#1,d1
		sub.w	d1,d0
		ext.l	d0
		asl.l	#4,d0
		divs.w	#$E,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		asr.w	#1,d3
		move.w	#$D,d1
loc_6798:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_6798
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X
; End of function Deform_SYZ
; ---------------------------------------------------------------------------
; Scrap	Brain Zone background layer deformation	code
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
Deform_SBZ:
		tst.b	(v_act).w
		bne.w	Bg_Scroll_SBz_2
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#7,d4
		moveq	#2,d6
		bsr.w	BGScroll_Block1
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		moveq	#6,d6
		bsr.w	BGScroll_Block3
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#5,d4
		move.l	d4,d1
		asl.l	#1,d4
		add.l	d1,d4
		moveq	#4,d6
		bsr.w	BGScroll_Block2
		moveq	#0,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_YRelative
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,(v_bg2screenposy).w
		move.w	d0,(v_bg3screenposy).w
		move.w	d0,(v_bgscrposy_dup).w
		move.b	(v_bg1_scroll_flags).w,d0
		or.b	(v_bg3_scroll_flags).w,d0
		or.b	d0,(v_bg2_scroll_flags).w
		clr.b	(v_bg1_scroll_flags).w
		clr.b	(v_bg3_scroll_flags).w
		lea	(v_bgscroll_buffer).w,a1
		move.w	(v_screenposx).w,d2
		neg.w	d2
		asr.w	#2,d2
		move.w	d2,d0
		asr.w	#1,d0
		sub.w	d2,d0
		ext.l	d0
		asl.l	#3,d0
		divs.w	#4,d0
		ext.l	d0
		asl.l	#4,d0
		asl.l	#8,d0
		moveq	#0,d3
		move.w	d2,d3
		move.w	#3,d1
loc_684E:
		move.w	d3,(a1)+
		swap	d3
		add.l	d0,d3
		swap	d3
		dbf	d1,loc_684E
		move.w	(v_bg3screenposx).w,d0
		neg.w	d0
		move.w	#9,d1
loc_6864:
		move.w	d0,(a1)+
		dbf	d1,loc_6864
		move.w	(v_bg2screenposx).w,d0
		neg.w	d0
		move.w	#6,d1
loc_6874:
		move.w	d0,(a1)+
		dbf	d1,loc_6874
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
		move.w	#$A,d1
loc_6884:
		move.w	d0,(a1)+
		dbf	d1,loc_6884
		lea	(v_bgscroll_buffer).w,a2
		move.w	(v_bgscreenposy).w,d0
		move.w	d0,d2
		andi.w	#$1F0,d0
		lsr.w	#3,d0
		lea	(a2,d0),a2
		bra.w	Bg_Scroll_X
;-------------------------------------------------------------------------------
Bg_Scroll_SBz_2:;loc_68A2:
		move.w	(v_scrshiftx).w,d4
		ext.l	d4
		asl.l	#6,d4
		move.w	(v_scrshifty).w,d5
		ext.l	d5
		asl.l	#5,d5
		bsr.w	BGScroll_XY
		move.w	(v_bgscreenposy).w,(v_bgscrposy_dup).w
		lea	(v_hscrolltablebuffer).w,a1
		move.w	#223,d1
		move.w	(v_screenposx).w,d0
		neg.w	d0
		swap	d0
		move.w	(v_bgscreenposx).w,d0
		neg.w	d0
loc_68D2:
		move.l	d0,(a1)+
		dbf	d1,loc_68D2
		rts
; End of function Deform_SBZ
; ---------------------------------------------------------------------------
; Subroutine to	scroll the level horizontally as Sonic moves
; ---------------------------------------------------------------------------
; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


ScrollHoriz:
		lea	(v_cameralag).w,a5
		move.w	(a1),d4		; get camera X pos
		move.w	(a5),d1		; should scrolling be delayed?
		bra.s	.scrollNotDelayed	; if not, branch
		subi.w	#$100,d1	; reduce delay value
		move.w	d1,(a5)
		moveq	#0,d1
		move.b	(a5),d1		; get delay value
		add.b   d1,d1		; multiply by 4, the size of a position buffer entry (this is faster than bit shift)
		add.b   d1,d1
		addq.b	#4,d1
		move.w	(v_trackpos).w,d0	; get current position buffer index
		sub.b	d1,d0
		lea     (v_tracksonic).w,a6
		move.w	(a6,d0.w),d0	; get Sonic's position a certain number of frames ago
		andi.w	#$7FFF,d0
		bra.s	.scrollCheck	; use that value for scrolling
; ===========================================================================
.scrollNotDelayed:
		move.w	(v_player+obX).w,d0
.scrollCheck:
		sub.w	(a1),d0
		subi.w	#(320/2)-16,d0		; is the player less than 144 pixels from the screen edge?
		blt.s	.scrollLeft	; if he is, scroll left
		subi.w	#16,d0		; is the player more than 159 pixels from the screen edge?
		bge.s	.scrollRight	; if he is, scroll right
		clr.w	(a4)		; otherwise, don't scroll
		rts ; there is no reason to set scroll flags, if screen doesn't move
; ===========================================================================
.scrollLeft:
		cmpi.w	#-16,d0
		bgt.s	.maxNotReached
		move.w	#-16,d0		; limit scrolling to 16 pixels per frame
.maxNotReached:
		add.w	(a1),d0		; get new camera position
		cmp.w	(v_limitleft2).w,d0		; is it greater than the minimum position?
		bgt.s	.doScroll		; if it is, branch
		move.w	(v_limitleft2).w,d0		; prevent camera from going any further back
		bra.s	.doScroll
; ===========================================================================

.scrollRight:
		cmpi.w	#16,d0
		blo.s	.maxNotReached2
		move.w	#16,d0

.maxNotReached2:
		add.w	(a1),d0		; get new camera position
		cmp.w	(v_limitright2).w,d0	; is it less than the max position?
		blt.s	.doScroll	; if it is, branch
		move.w	(v_limitright2).w,d0	; prevent camera from going any further forward
.doScroll:
		move.w	d0,d1
		sub.w	(a1),d1		; subtract old camera position
		asl.w	#8,d1		; shift up by a byte
		move.w	d0,(a1)		; set new camera position
		move.w	d1,(a4)		; set difference between old and new positions
.setFlags:
		; set horizontal scroll flags
		lea	(v_fg_xblock).w,a2
		move.w	(a1),d0		; get camera X pos
		andi.w	#$10,d0
		move.b	(v_fg_xblock).w,d1
		eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
		bne.s	.return		; if not, branch
		eori.b	#$10,(v_fg_xblock).w
		move.w	(a1),d0		; get camera X pos
		sub.w	d4,d0		; subtract previous camera X pos
		bpl.s	.moveForward		; branch if the camera has moved forward
		bset	#2,(a3)		; set moving back in level bit
.return:
		rts
; ===========================================================================
.moveForward:
		bset	#3,(a3)		; set moving forward in level bit
		rts
; End of function ScrollHoriz

; ---------------------------------------------------------------------------
; Subroutine to	scroll the level vertically as Sonic moves

;	input:
;	(a1) - screen Y position

; ---------------------------------------------------------------------------

; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||

ScrollVertical:
		moveq	#0,d1
		move.w	(v_player+obY).w,d0
		move.w  (v_lookshift).w,d3
		sub.w	(a1),d0		; subtract camera Y pos
		cmpi.w	#$FF00,(v_limittop2).w ; does the level wrap vertically?
		bne.s	.noWrap		; if not, branch
		andi.w	#$7FF,d0
.noWrap:
		btst	#2,(v_player+obStatus).w	; is the player rolling?
		beq.s	.notRolling	; if not, branch
		subq.w	#5,d0		; subtract difference between standing and rolling heights
.notRolling:
		btst	#1,(v_player+obStatus).w			; is the player in the air?
		beq.s	.checkBoundaryCrossed_onGround	; if not, branch
		; If Sonic's in the air, he has $20 pixels above and below him to move without disturbing the camera.
		; The camera movement is also only capped at $10 pixels.
		addi.w	#$20,d0
		sub.w   d3,d0	; subtract camera offset
		blo.s	.doScroll_fast	; If Sonic is above the boundary, scroll to catch up to him
		subi.w	#$40,d0
		bhs.s	.doScroll_fast	; If Sonic is below the boundary, scroll to catch up to him
		tst.b	(f_bgscrollvert).w	; is the max Y pos changing?
		bne.s	.scrollUpOrDown_maxYPosChanging	; if it is, branch
		bra.s	.doNotScroll
; ===========================================================================

.checkBoundaryCrossed_onGround:
		; On the ground, the camera follows Sonic very strictly.
		sub.w	d3,d0	; subtract camera offset
		bne.s	.selectScrollType		; If Sonic has moved, scroll to catch up to him
		tst.b	(f_bgscrollvert).w	; is the max Y pos changing?
		bne.s	.scrollUpOrDown_maxYPosChanging	; if it is, branch

.doNotScroll:
		clr.w	(a4)	; clear Y position shift
		rts
; ===========================================================================
.selectScrollType:
		cmpi.w	#(224/2)-16,d3		; is the camera offset normal?
		bne.s	.doScroll_slow	; if not, branch
		move.w	(v_player+obInertia).w,d1	; get player ground velocity, force it to be positive
		andi.w  #$7FFF,d1 ; clear sign bit
		cmpi.w	#$800,d1	; is the player travelling very fast?
		bhs.s	.doScroll_fast	; if he is, branch
;.doScroll_medium:
		move.w	#6<<8,d1	; If player is going too fast, cap camera movement to 6 pixels per frame
		cmpi.w	#6,d0		; is player going down too fast?
		bgt.s	.scrollDown_max	; if so, move camera at capped speed
		cmpi.w	#-6,d0		; is player going up too fast?
		blt.s	.scrollUp_max	; if so, move camera at capped speed
		bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
.doScroll_slow:
		move.w	#2<<8,d1	; If player is going too fast, cap camera movement to 2 pixels per frame
		cmpi.w	#2,d0		; is player going down too fast?
		bgt.s	.scrollDown_max	; if so, move camera at capped speed
		cmpi.w	#-2,d0		; is player going up too fast?
		blt.s	.scrollUp_max	; if so, move camera at capped speed
		bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
.doScroll_fast:
		; related code appears in ScrollBG
		; S3K uses 24 instead of 16
		move.w	#16<<8,d1	; If player is going too fast, cap camera movement to $10 pixels per frame
		cmpi.w	#16,d0		; is player going down too fast?
		bgt.s	.scrollDown_max	; if so, move camera at capped speed
		cmpi.w	#-16,d0		; is player going up too fast?
		blt.s	.scrollUp_max	; if so, move camera at capped speed
		bra.s	.scrollUpOrDown	; otherwise, move camera at player's speed
; ===========================================================================
.scrollUpOrDown_maxYPosChanging:
		moveq	#0,d0		; Distance for camera to move = 0
		move.b	d0,(f_bgscrollvert).w	; clear camera max Y pos changing flag
.scrollUpOrDown:
		moveq	#0,d1
		move.w	d0,d1		; get position difference
		add.w	(a1),d1		; add old camera Y position
		tst.w	d0		; is the camera to scroll down?
		bra.w	.scrollUp
; ===========================================================================
.scrollUp_max:
		neg.w	d1	; make the value negative (since we're going backwards)
		ext.l	d1
		asl.l	#8,d1	; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
		add.l	(a1),d1	; add the two, getting the new Camera_Y_pos value
		swap	d1	; actual Y-coordinate is now the low word
.scrollUp:
		cmp.w	(v_limittop2).w,d1	; is the new position less than the minimum Y pos?
		bgt.s	.doScroll	; if not, branch
		cmpi.w	#-$100,d1
		bgt.s	.minYPosReached
		andi.w	#$7FF,d1
		andi.w	#$7FF,(a1)
		;andi.w	#$7FF,(v_player+obY).w
		;andi.w	#$3FF,(v_bgscreenposy).w
		bra.s	.doScroll
; ===========================================================================
.minYPosReached:
		move.w	(v_limittop2).w,d1	; prevent camera from going any further up
		bra.s	.doScroll
; ===========================================================================
.scrollDown_max:
		ext.l	d1
		asl.l	#8,d1		; move this into the upper word, so it lines up with the actual y_pos value in Camera_Y_pos
		add.l	(a1),d1		; add the two, getting the new Camera_Y_pos value
		swap	d1		; actual Y-coordinate is now the low word
.scrollDown:
		cmp.w	(v_limitbtm2).w,d1	; is the new position greater than the maximum Y pos?
		blt.s	.doScroll	; if not, branch
		subi.w	#$800,d1
		bcs.s	.maxYPosReached
		subi.w	#$800,(a1)
		;andi.w	#$7FF,(v_player+obY).w
		;subi.w	#$800,(a1)
		;andi.w	#$3FF,(v_bgscreenposy).w
		bra.s	.doScroll
; ===========================================================================
.maxYPosReached:
		move.w	(v_limitbtm2).w,d1	; prevent camera from going any further down
.doScroll:
		move.w	(a1),d4		; get old pos (used by SetVertiScrollFlags)
		swap	d1		; actual Y-coordinate is now the high word, as Camera_Y_pos expects it
		move.l	d1,d3
		sub.l	(a1),d3
		ror.l	#8,d3
		move.w	d3,(a4)		; set difference between old and new positions
		move.l	d1,(a1)		; set new camera Y pos
		move.w	(a1),d0		; get camera Y pos
		andi.w	#$10,d0
		move.b	(v_fg_yblock).w,d1
		eor.b	d1,d0		; has the camera crossed a 16-pixel boundary?
		bne.s	.return		; if not, branch
		eori.b	#$10,(v_fg_yblock).w
		move.w	(a1),d0		; get camera Y pos
		sub.w	d4,d0		; subtract old camera Y pos
		bpl.s	.moveDown		; branch if the camera has scrolled down
		bset	#0,(a3)		; set moving up in level bit
.return:
		rts
; ===========================================================================
.moveDown:
		bset	#1,(a3)		; set moving down in level bit
		rts
; End of function ScrollVertical


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; Scrolls background and sets redraw flags.
; d4 - background x offset * $10000
; d5 - background y offset * $10000

BGScroll_XY:
		move.l	(v_bgscreenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscreenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_xblock).w,d3
		eor.b	d3,d1
		bne.s	BGScroll_YRelative	; no change in Y
		eori.b	#$10,(v_bg1_xblock).w
		sub.l	d2,d0	; new - old
		bpl.s	.scrollRight
		bset	#2,(v_bg1_scroll_flags).w
		bra.s	BGScroll_YRelative
	.scrollRight:
		bset	#3,(v_bg1_scroll_flags).w
BGScroll_YRelative:
		move.l	(v_bgscreenposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscreenposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_yblock).w
		sub.l	d3,d0
		bpl.s	.scrollBottom
		bset	#0,(v_bg1_scroll_flags).w
		rts
	.scrollBottom:
		bset	#1,(v_bg1_scroll_flags).w
	.return:
		rts
; End of function BGScroll_XY

Bg_Scroll_Y:
		move.l	(v_bgscreenposy).w,d3
		move.l	d3,d0
		add.l	d5,d0
		move.l	d0,(v_bgscreenposy).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_yblock).w
		sub.l	d3,d0
		bpl.s	.scrollBottom
		bset	#4,(v_bg1_scroll_flags).w
		rts
	.scrollBottom:
		bset	#5,(v_bg1_scroll_flags).w
	.return:
		rts


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BGScroll_YAbsolute:
		move.w	(v_bgscreenposy).w,d3
		move.w	d0,(v_bgscreenposy).w
		move.w	d0,d1
		andi.w	#$10,d1
		move.b	(v_bg1_yblock).w,d2
		eor.b	d2,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_yblock).w
		sub.w	d3,d0
		bpl.s	.scrollBottom
		bset	#0,(v_bg1_scroll_flags).w
		rts
	.scrollBottom:
		bset	#1,(v_bg1_scroll_flags).w
	.return:
		rts
; End of function BGScroll_YAbsolute


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||
; d6 - bit to set for redraw

BGScroll_Block1:
		move.l	(v_bgscreenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bgscreenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg1_xblock).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg1_xblock).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg1_scroll_flags).w
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg1_scroll_flags).w
	.return:
		rts
; End of function BGScroll_Block1


; ||||||||||||||| S U B	R O U T	I N E |||||||||||||||||||||||||||||||||||||||


BGScroll_Block2:
		move.l	(v_bg2screenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg2screenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg2_xblock).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg2_xblock).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg2_scroll_flags).w
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg2_scroll_flags).w
	.return:
		rts
;-------------------------------------------------------------------------------
BGScroll_Block3:
		move.l	(v_bg3screenposx).w,d2
		move.l	d2,d0
		add.l	d4,d0
		move.l	d0,(v_bg3screenposx).w
		move.l	d0,d1
		swap	d1
		andi.w	#$10,d1
		move.b	(v_bg3_xblock).w,d3
		eor.b	d3,d1
		bne.s	.return
		eori.b	#$10,(v_bg3_xblock).w
		sub.l	d2,d0
		bpl.s	.scrollRight
		bset	d6,(v_bg3_scroll_flags).w
		bra.s	.return
	.scrollRight:
		addq.b	#1,d6
		bset	d6,(v_bg3_scroll_flags).w
	.return:
		rts