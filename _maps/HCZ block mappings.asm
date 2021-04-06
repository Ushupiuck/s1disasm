; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_YSh7S:	
		dc.w SME_YSh7S_8-SME_YSh7S, SME_YSh7S_E-SME_YSh7S	
		dc.w SME_YSh7S_19-SME_YSh7S, SME_YSh7S_29-SME_YSh7S	
SME_YSh7S_8:	dc.b 1	
		dc.b $F0, $F, 0, 0, $F0	
SME_YSh7S_E:	dc.b 2	
		dc.b $F0, $F, 0, 0, $E0	
		dc.b $F0, $F, 0, 0, 0	
SME_YSh7S_19:	dc.b 3	
		dc.b $F0, $F, 0, 0, $D0	
		dc.b $F0, $F, 0, 0, $F0	
		dc.b $F0, $F, 0, 0, $10	
SME_YSh7S_29:	dc.b 4	
		dc.b $F0, $F, 0, 0, $C0	
		dc.b $F0, $F, 0, 0, $E0	
		dc.b $F0, $F, 0, 0, 0	
		dc.b $F0, $F, 0, 0, $20	
		even