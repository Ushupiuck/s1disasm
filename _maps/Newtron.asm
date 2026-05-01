; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 1 format
; --------------------------------------------------------------------------------

SME_YFeSu:	
		dc.w SME_YFeSu_12-SME_YFeSu, SME_YFeSu_22-SME_YFeSu	
		dc.w SME_YFeSu_32-SME_YFeSu, SME_YFeSu_42-SME_YFeSu	
		dc.w SME_YFeSu_57-SME_YFeSu, SME_YFeSu_67-SME_YFeSu	
		dc.w SME_YFeSu_72-SME_YFeSu, SME_YFeSu_82-SME_YFeSu	
		dc.w SME_YFeSu_92-SME_YFeSu	
SME_YFeSu_12:	dc.b 3	
		dc.b $EC, $D, 0, 0, $EC	
		dc.b $F4, 0, 0, 8, $C	
		dc.b $FC, $E, 0, 9, $F4	
SME_YFeSu_22:	dc.b 3	
		dc.b $EC, 6, 0, $15, $EC	
		dc.b $EC, 9, 0, $1B, $FC	
		dc.b $FC, $A, 0, $21, $FC	
SME_YFeSu_32:	dc.b 3	
		dc.b $EC, 6, 0, $2A, $EC	
		dc.b $EC, 9, 0, $1B, $FC	
		dc.b $FC, $A, 0, $21, $FC	
SME_YFeSu_42:	dc.b 4	
		dc.b $EC, 6, 0, $30, $EC	
		dc.b $EC, 9, 0, $1B, $FC	
		dc.b $FC, 9, 0, $36, $FC	
		dc.b $C, 0, 0, $3C, $C	
SME_YFeSu_57:	dc.b 3	
		dc.b $F4, $D, 0, $3D, $EC	
		dc.b $FC, 0, 0, $20, $C	
		dc.b 4, 8, 0, $45, $FC	
SME_YFeSu_67:	dc.b 2	
		dc.b $F8, $D, 0, $48, $EC	
		dc.b $F8, 1, 0, $50, $C	
SME_YFeSu_72:	dc.b 3	
		dc.b $F8, $D, 0, $48, $EC	
		dc.b $F8, 1, 0, $50, $C	
		dc.b $FE, 0, 0, $52, $14	
SME_YFeSu_82:	dc.b 3	
		dc.b $F8, $D, 0, $48, $EC	
		dc.b $F8, 1, 0, $50, $C	
		dc.b $FE, 4, 0, $53, $14	
SME_YFeSu_92:	dc.b 0	
		even