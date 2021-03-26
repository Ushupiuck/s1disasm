; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; Variables (v) and Flags (f)

v_regbuffer	= ramaddr ( $FFFFFC80 )	; stores registers d0-a7 during an error event ($40 bytes)
v_spbuffer	= ramaddr ( $FFFFFCC0 )	; stores most recent sp address (4 bytes)
v_errortype	= ramaddr ( $FFFFFCC4 )	; error type

v_128x128	= ramaddr ( $FF0000 )	; 128x128 tile mappings ($8000 bytes)
v_16x16		= ramaddr ( $FFFF8000 )	; 16x16 tile mappings ($1800 bytes)
v_bgscroll_buffer	= ramaddr( $FFFF9800 )	; background scroll buffer ($200 bytes)
v_ngfx_buffer	= ramaddr ( $FFFF9A00 )	; Nemesis graphics decompression buffer ($200 bytes)
v_spritequeue	= ramaddr ( $FFFF9C00 )	; sprite display queue, in order of priority ($400 bytes)
VDP_Command_Buffer	= ramaddr ( $FFFFA000 )	; stores 18 ($12) VDP commands to issue the next time ProcessDMAQueue is called ($FC bytes)
VDP_Command_Buffer_Slot	= ramaddr ( $FFFFA0FC )	; stores the address of the next open slot for a queued VDP command ($4 bytes)
v_tracksonic	= ramaddr ( $FFFFA100 )	; position tracking data for Sonic ($100 bytes)
v_hscrolltablebuffer	= ramaddr ( $FFFFA200 )	; scrolling table data (actually $380 bytes, but $400 is reserved for it)
Primary_Collision	= ramaddr ( $FFFFA600 )
Secondary_Collision	= ramaddr ( $FFFFA900 )
v_systemstack	= ramaddr ( $FFFFAD00 )
; $2400 bytes of free ram starting at AC00!~

v_lastlamp	= ramaddr ( $FFFFAD02 )	; number of the last lamppost you hit
v_savedlastlamp	= v_lastlamp+1	; last lamppost you hit
v_lamp_xpos	= v_lastlamp+2	; x-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_ypos	= v_lastlamp+4	; y-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_rings	= v_lastlamp+6	; rings stored at lamppost (2 bytes)
v_lamp_time	= v_lastlamp+8	; time stored at lamppost (2 bytes)
v_lamp_dle	= v_lastlamp+$C	; dynamic level event routine counter at lamppost
v_lamp_limitbtm	= v_lastlamp+$E	; level bottom boundary at lamppost (2 bytes)
v_lamp_scrx	= v_lastlamp+$10 ; x-axis screen at lamppost (2 bytes)
v_lamp_scry	= v_lastlamp+$12 ; y-axis screen at lamppost (2 bytes)
v_lamp_bgscrx	= v_lastlamp+$14 ; x-axis screen at lamppost (2 bytes)
v_lamp_bgscry	= v_lastlamp+$16 ; y-axis screen at lamppost (2 bytes)
v_lamp_bg2scrx	= v_lastlamp+$18 ; y-axis screen at lamppost (2 bytes)
v_lamp_bg2scry	= v_lastlamp+$1A ; y-axis screen at lamppost (2 bytes)
v_lamp_bg3scrx	= v_lastlamp+$1C ; y-axis screen at lamppost (2 bytes)
v_lamp_bg3scry	= v_lastlamp+$1E ; y-axis screen at lamppost (2 bytes)
v_lamp_wtrpos	= v_lastlamp+$20 ; water position at lamppost (2 bytes)
v_lamp_wtrrout	= v_lastlamp+$22 ; water routine at lamppost
v_lamp_wtrstat	= v_lastlamp+$23 ; water state at lamppost
v_lamp_lives	= v_lastlamp+$24 ; lives counter at lamppost

v_emeralds	= ramaddr ( $FFFFAD27 )	; number of chaos emeralds
v_emldlist	= ramaddr ( $FFFFAD28 )	; which individual emeralds you have (00 = no; 01 = yes) (6 bytes)
v_oscillate	= ramaddr ( $FFFFAD2E )	; values which oscillate - for swinging platforms, et al ($42 bytes)

v_screenposx_dup	= ramaddr ( $FFFFAD70 )	; screen position x (duplicate) (Camera_RAM_copy in Sonic 2) (2 bytes)
Horiz_scroll_delay_val	= ramaddr ( $FFFFAD72 ) ; ; if its value is a, where a != 0, X scrolling will be based on the player's X position a-1 frames ago
Camera_Y_pos_bias	= ramaddr ( $FFFFAD74 )	; screen position y (duplicate) (2 bytes)
v_bgscreenposx_dup	= ramaddr ( $FFFFAD76 )	; background screen position x (duplicate) (8 bytes)
v_bg2screenposx_dup	= ramaddr ( $FFFFAD7E )	; 8 bytes
v_bg3screenposx_dup	= ramaddr ( $FFFFAD86 )	; 8 bytes
v_fg_scroll_flags_dup	= ramaddr ( $FFFFAD8E )
v_bg1_scroll_flags_dup	= ramaddr ( $FFFFAD90 )
v_bg2_scroll_flags_dup	= ramaddr ( $FFFFAD92 )
v_bg3_scroll_flags_dup	= ramaddr ( $FFFFAD94 )

v_objspace	= ramaddr ( $FFFFD000 )	; object variable space ($40 bytes per object) ($2000 bytes)
v_player	= v_objspace	; object variable space for Sonic ($40 bytes)
v_lvlobjspace	= ramaddr ( $FFFFD800 )	; level object variable space ($1800 bytes)

v_snddriver_ram  = ramaddr ( $FFFFF000 )	; start of RAM for the sound driver data ($5C0 bytes)

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================
v_startofvariables:	= $000
v_sndprio:		= $000	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
v_main_tempo_timeout:	= $001	; Counts down to zero; when zero, resets to next value and delays song by 1 frame
v_main_tempo:		= $002	; Used for music only
f_pausemusic:		= $003	; flag set to stop music when paused
v_fadeout_counter:	= $004

v_fadeout_delay:	= $006
v_communication_byte:	= $007	; used in Ristar to sync with a boss' attacks; unused here
f_updating_dac:		= $008	; $80 if updating DAC, $00 otherwise
v_sound_id:		= $009	; sound or music copied from below
v_soundqueue0:		= $00A	; sound or music to play
v_soundqueue1:		= $00B	; special sound to play
v_soundqueue2:		= $00C	; unused sound to play

f_voice_selector:	= $00E	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_voice_ptr:		= $018	; voice data pointer (4 bytes)

v_special_voice_ptr:	= $020	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

f_fadein_flag:		= $024	; Flag for fade in
v_fadein_delay:		= $025
v_fadein_counter:	= $026	; Timer for fade in/out
f_1up_playing:		= $027	; flag indicating 1-up song is playing
v_tempo_mod:		= $028	; music - tempo modifier
v_speeduptempo:		= $029	; music - tempo modifier with speed shoes
f_speedup:		= $02A	; flag indicating whether speed shoes tempo is on ($80) or off ($00)
v_ring_speaker:		= $02B	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		= $02C	; if set, prevents further push sounds from playing

v_music_track_ram:	= $040	; Start of music RAM

v_music_fmdac_tracks:	= v_music_track_ram+TrackSz*0
v_music_dac_track:	= v_music_fmdac_tracks+TrackSz*0
v_music_fm_tracks:	= v_music_fmdac_tracks+TrackSz*1
v_music_fm1_track:	= v_music_fm_tracks+TrackSz*0
v_music_fm2_track:	= v_music_fm_tracks+TrackSz*1
v_music_fm3_track:	= v_music_fm_tracks+TrackSz*2
v_music_fm4_track:	= v_music_fm_tracks+TrackSz*3
v_music_fm5_track:	= v_music_fm_tracks+TrackSz*4
v_music_fm6_track:	= v_music_fm_tracks+TrackSz*5
v_music_fm_tracks_end:	= v_music_fm_tracks+TrackSz*6
v_music_fmdac_tracks_end:	= v_music_fm_tracks_end
v_music_psg_tracks:	= v_music_fmdac_tracks_end
v_music_psg1_track:	= v_music_psg_tracks+TrackSz*0
v_music_psg2_track:	= v_music_psg_tracks+TrackSz*1
v_music_psg3_track:	= v_music_psg_tracks+TrackSz*2
v_music_psg_tracks_end:	= v_music_psg_tracks+TrackSz*3
v_music_track_ram_end:	= v_music_psg_tracks_end

v_sfx_track_ram:	= v_music_track_ram_end	; Start of SFX RAM, straight after the end of music RAM

v_sfx_fm_tracks:	= v_sfx_track_ram+TrackSz*0
v_sfx_fm3_track:	= v_sfx_fm_tracks+TrackSz*0
v_sfx_fm4_track:	= v_sfx_fm_tracks+TrackSz*1
v_sfx_fm5_track:	= v_sfx_fm_tracks+TrackSz*2
v_sfx_fm_tracks_end:	= v_sfx_fm_tracks+TrackSz*3
v_sfx_psg_tracks:	= v_sfx_fm_tracks_end
v_sfx_psg1_track:	= v_sfx_psg_tracks+TrackSz*0
v_sfx_psg2_track:	= v_sfx_psg_tracks+TrackSz*1
v_sfx_psg3_track:	= v_sfx_psg_tracks+TrackSz*2
v_sfx_psg_tracks_end:	= v_sfx_psg_tracks+TrackSz*3
v_sfx_track_ram_end:	= v_sfx_psg_tracks_end

v_spcsfx_track_ram:	= v_sfx_track_ram_end	; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	= v_spcsfx_track_ram+TrackSz*0
v_spcsfx_psg3_track:	= v_spcsfx_track_ram+TrackSz*1
v_spcsfx_track_ram_end:	= v_spcsfx_track_ram+TrackSz*2

v_1up_ram_copy:		= v_spcsfx_track_ram_end

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode	= ramaddr ( $FFFFF600 )	; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
v_jpadhold2	= ramaddr ( $FFFFF602 )	; joypad input - held, duplicate
v_jpadpress2	= ramaddr ( $FFFFF603 )	; joypad input - pressed, duplicate
v_jpadhold1	= ramaddr ( $FFFFF604 )	; joypad input - held
v_jpadpress1	= ramaddr ( $FFFFF605 )	; joypad input - pressed
;v_jpad2hold1	= ramaddr ( $FFFFF606 )	; joypad input for player 2 - held
;v_jpad2press1	= ramaddr ( $FFFFF607 )	; joypad input for player 2 - pressed

v_vdp_buffer1	= ramaddr ( $FFFFF60C )	; VDP instruction buffer (2 bytes)
v_wtr_routine	= ramaddr ( $FFFFF60E )	; water event - routine counter
f_wtr_state	= ramaddr ( $FFFFF60F )	; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)

v_demolength	= ramaddr ( $FFFFF614 )	; the length of a demo in frames (2 bytes)
v_scrposy_dup	= ramaddr ( $FFFFF616 )	; screen position y (duplicate) (2 bytes)
v_bgscrposy_dup	= ramaddr ( $FFFFF618 )	; background screen position y (duplicate) (2 bytes)
v_scrposx_dup	= ramaddr ( $FFFFF61A )	; screen position x (duplicate) (2 bytes)
v_lvllayoutfg	= ramaddr ( $FFFFF61C )	; level layout ROM address (4 bytes)
v_lvllayoutbg	= ramaddr ( $FFFFF620 )	; background layout ROM address (4 bytes)
v_hbla_hreg	= ramaddr ( $FFFFF624 )	; VDP H.interrupt register buffer (8Axx) (2 bytes)
v_hbla_line	= ramaddr ( $FFFFF625 )	; screen line where water starts and palette is changed by HBlank
v_pfade_start	= ramaddr ( $FFFFF626 )	; palette fading - start position in bytes
v_pfade_size	= ramaddr ( $FFFFF627 )	; palette fading - number of colours
v_int0E_Counter = ramaddr ( $FFFFF628 )	; (1 byte)
v_vbla_routine	= ramaddr ( $FFFFF629 )	; VBlank - routine counter
MiscLevelVariables	= v_vbla_routine

v_pcyc_num	= ramaddr ( $FFFFF62A )	; palette cycling - current reference number (2 bytes)
v_pcyc_time	= ramaddr ( $FFFFF62C )	; palette cycling - time until the next change (2 bytes)
v_spritecount	= ramaddr ( $FFFFF62D )	; number of sprites on-screen
v_int_update	= ramaddr ( $FFFFF62E ) ; (1 byte)
f_pause		= ramaddr ( $FFFFF630 )	; flag set to pause the game (2 bytes)

v_random	= ramaddr ( $FFFFF632 )	; pseudo random number buffer (4 bytes)
v_vdp_buffer2	= ramaddr ( $FFFFF636 )	; VDP instruction buffer (2 bytes)
f_hbla_pal	= ramaddr ( $FFFFF638 )	; flag set to change palette during HBlank (0000 = no; 0001 = change) (2 bytes)

v_waterpos1	= ramaddr ( $FFFFF63A )	; water height, actual (2 bytes)
v_waterpos2	= ramaddr ( $FFFFF63C )	; water height, ignoring sway (2 bytes)
v_waterpos3	= ramaddr ( $FFFFF63E )	; water height, next target (2 bytes)

v_pal_buffer	= ramaddr ( $FFFFF640 )	; palette data buffer (used for palette cycling) ($30 bytes)
v_plc_buffer	= ramaddr ( $FFFFF670 )	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_plc_buffer_reg0	= ramaddr ( $FFFFF6D0 )	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)
v_plc_buffer_reg4	= ramaddr ( $FFFFF6D4 ) ; (4 bytes)
v_plc_buffer_reg8	= ramaddr ( $FFFFF6D8 )	; (4 bytes)
v_plc_buffer_regC	= ramaddr ( $FFFFF6DC )	; (4 bytes)
v_plc_buffer_reg10	= ramaddr ( $FFFFF6E0 )	; (4 bytes)
v_plc_buffer_reg14	= ramaddr ( $FFFFF6D4 )	; (4 bytes)
v_plc_buffer_reg18	= ramaddr ( $FFFFF6D8 )	; (2 bytes)
v_plc_buffer_reg1A	= ramaddr ( $FFFFF6DA )	; (2 bytes)
f_plc_execute	= ramaddr ( $FFFFF6DE )	; flag set for pattern load cue execution (2 bytes)

v_screenposx	= ramaddr ( $FFFFF6E0 )	; screen position x (2 bytes)
v_screenposy	= ramaddr ( $FFFFF6E2 )	; screen position y (2 bytes)
v_bgscreenposx	= ramaddr ( $FFFFF6E4 )	; background screen position x (2 bytes)
v_bgscreenposy	= ramaddr ( $FFFFF6E6 )	; background screen position y (2 bytes)
v_bg2screenposx	= ramaddr ( $FFFFF6E8 )	; 2 bytes
v_bg2screenposy	= ramaddr ( $FFFFF6EA )	; 2 bytes
v_bg3screenposx	= ramaddr ( $FFFFF6EC )	; 2 bytes
v_bg3screenposy	= ramaddr ( $FFFFF6EE )	; 2 bytes

v_limitleft1	= ramaddr ( $FFFFF6F0 )	; left level boundary (2 bytes)
v_limitright1	= ramaddr ( $FFFFF6F2 )	; right level boundary (2 bytes)
v_limittop1	= ramaddr ( $FFFFF6F4 )	; top level boundary (2 bytes)
v_limitbtm1	= ramaddr ( $FFFFF6F6 )	; bottom level boundary (2 bytes)
v_limitleft2	= ramaddr ( $FFFFF6F8 )	; left level boundary (2 bytes)
v_limitright2	= ramaddr ( $FFFFF6FA )	; right level boundary (2 bytes)
v_limittop2	= ramaddr ( $FFFFF6FC )	; top level boundary (2 bytes)
v_limitbtm2	= ramaddr ( $FFFFF6FE )	; bottom level boundary (2 bytes)
v_dynresize	= ramaddr ( $FFFFF700 ) ; (2 bytes)
v_limitleft3	= ramaddr ( $FFFFF702 )	; left level boundary, at the end of an act (2 bytes)
v_scrshiftx	= ramaddr ( $FFFFF704 )	; x-screen shift (new - last) * $100
v_scrshifty	= ramaddr ( $FFFFF706 )	; y-screen shift (new - last) * $100
v_lookshift	= ramaddr ( $FFFFF708 )	; screen shift when Sonic looks up/down (2 bytes)
v_templabel	= ramaddr ( $FFFFF70A )
v_templabel2	= ramaddr ( $FFFFF70B )
v_dle_routine	= ramaddr ( $FFFFF70C )	; dynamic level event - routine counter
f_nobgscroll	= ramaddr ( $FFFFF70D )	; flag set to cancel background scrolling
v_templabel3	= ramaddr ( $FFFFF70E )
v_templabel4	= ramaddr ( $FFFFF70F )

v_fg_xblock	= ramaddr ( $FFFFF710 )	; foreground x-block parity (for redraw)
v_fg_yblock	= ramaddr ( $FFFFF711 )	; foreground y-block parity (for redraw)
v_bg1_xblock	= ramaddr ( $FFFFF712 )	; background x-block parity (for redraw)
v_bg1_yblock	= ramaddr ( $FFFFF713 )	; background y-block parity (for redraw)
v_bg2_xblock	= ramaddr ( $FFFFF714 )	; secondary background x-block parity (for redraw)
v_bg3_xblock	= ramaddr ( $FFFFF715 )	; teritary background x-block parity (for redraw)
; Moved down since I accidentally aligned it as byte when it was a word & I don't feel like shuffling the addresses again
f_bgscrollvert	= ramaddr ( $FFFFF71A )	; flag for vertical background scrolling

v_sonspeedmax	= ramaddr ( $FFFFF71C )	; Sonic's maximum speed (2 bytes)
v_sonspeedacc	= ramaddr ( $FFFFF71E )	; Sonic's acceleration (2 bytes)
v_sonspeeddec	= ramaddr ( $FFFFF720 )	; Sonic's deceleration (2 bytes)
v_sonframenum	= ramaddr ( $FFFFF721 )	; frame to display for Sonic
v_anglebuffer	= ramaddr ( $FFFFF722 )	; angle of collision block that Sonic or object is standing on
v_angledata	= ramaddr ( $FFFFF723 ) ; Maybe Angle Data? unknown (1 byte)

v_ssangle	= ramaddr ( $FFFFF724 )	; Special Stage angle (2 bytes)
v_ssrotate	= ramaddr ( $FFFFF726 )	; Special Stage rotation speed (2 bytes)
v_btnpushtime1	= ramaddr ( $FFFFF728 )	; button push duration - in level (2 bytes)
v_btnpushtime2	= ramaddr ( $FFFFF72A )	; button push duration - in demo (2 bytes)
v_palchgspeed	= ramaddr ( $FFFFF72C )	; palette fade/transition speed (0 is fastest) (2 bytes)
v_collindex	= ramaddr ( $FFFFF72E )	; RAM address for collision index of current level (4 bytes)
v_palss_num	= ramaddr ( $FFFFF732 )	; palette cycling in Special Stage - reference number (2 bytes)
v_palss_time	= ramaddr ( $FFFFF734 )	; palette cycling in Special Stage - time until next change (2 bytes)
v_palss_unknown	= ramaddr ( $FFFFF736 ) ; unknown (2 bytes)
v_palss_unknown2	= ramaddr ( $FFFFF738 ) ; unknown (2 bytes)

v_obj31ypos	= ramaddr ( $FFFFF73A )	; y-position of object 31 (MZ stomper) (2 bytes)
v_trackpos	= ramaddr ( $FFFFF73C )	; position tracking reference number (2 bytes)
v_trackbyte	= v_trackpos+1		; low byte for position tracking
v_screenposx_coarse	= ramaddr ( $FFFFF73E )	; (Camera_X_pos - 128) / 256 (2 bytes)
f_lockscreen	= ramaddr ( $FFFFF740 )	; flag set to lock screen during bosses

v_lani0_frame	= ramaddr ( $FFFFF741 )	; level graphics animation 0 - current frame
v_lani0_time	= ramaddr ( $FFFFF742 )	; level graphics animation 0 - time until next frame
v_lani1_frame	= ramaddr ( $FFFFF743 )	; level graphics animation 1 - current frame
v_lani1_time	= ramaddr ( $FFFFF744 )	; level graphics animation 1 - time until next frame
v_lani2_frame	= ramaddr ( $FFFFF745 )	; level graphics animation 2 - current frame
v_lani2_time	= ramaddr ( $FFFFF746 )	; level graphics animation 2 - time until next frame
v_lani3_frame	= ramaddr ( $FFFFF747 )	; level graphics animation 3 - current frame
v_lani3_time	= ramaddr ( $FFFFF748 )	; level graphics animation 3 - time until next frame
v_lani4_frame	= ramaddr ( $FFFFF749 )	; level graphics animation 4 - current frame
v_lani4_time	= ramaddr ( $FFFFF74A )	; level graphics animation 4 - time until next frame
v_lani5_frame	= ramaddr ( $FFFFF74B )	; level graphics animation 5 - current frame
v_lani5_time	= ramaddr ( $FFFFF74C )	; level graphics animation 5 - time until next frame
f_conveyrev	= ramaddr ( $FFFFF74D )	; flag set to reverse conveyor belts in LZ/SBZ
v_gfxbigring	= ramaddr ( $FFFFF74E )	; settings for giant ring graphics loading (2 bytes)
v_obj63		= ramaddr ( $FFFFF750 )	; object 63 (LZ/SBZ platforms) variables (6 bytes)
f_wtunnelmode	= ramaddr ( $FFFFF756 )	; LZ water tunnel mode
f_lockmulti	= ramaddr ( $FFFFF757 )	; flag set to lock controls, lock Sonic's position & animation
f_wtunnelallow	= ramaddr ( $FFFFF758 )	; LZ water tunnels (00 = enabled; 01 = disabled)
f_jumponly	= ramaddr ( $FFFFF759 )	; flag set to lock controls apart from jumping
f_lockctrl	= ramaddr ( $FFFFF75A )	; flag set to lock controls during ending sequence
f_bigring	= ramaddr ( $FFFFF75B )	; flag set when Sonic collects the giant ring
v_syz3door	= ramaddr ( $FFFFF75C )	; flag to move the blockade at SYZ act 3 (1 byte)
f_endactbonus	= ramaddr ( $FFFFF75D )	; time/ring bonus update flag at the end of an act
v_itembonus	= ramaddr ( $FFFFF75E )	; item bonus from broken enemies, blocks etc. (2 bytes)
v_timebonus	= ramaddr ( $FFFFF760 )	; time bonus at the end of an act (2 bytes)
v_ringbonus	= ramaddr ( $FFFFF762 )	; ring bonus at the end of an act (2 bytes)
v_lz_deform	= ramaddr ( $FFFFF764 )	; LZ deformtaion offset, in units of $80 (2 bytes)
f_switch	= ramaddr ( $FFFFF766 )	; flags set when Sonic stands on a switch ($10 bytes)

v_opl_screen	= ramaddr ( $FFFFF776 )	; ObjPosLoad - screen variable
v_opl_data	= ramaddr ( $FFFFF786 )	; ObjPosLoad - data buffer ($10 bytes)

v_opl_routine	= ramaddr ( $FFFFF796 )	; ObjPosLoad - routine counter
v_sonicend	= ramaddr ( $FFFFF797 )	; routine counter for Sonic in the ending sequence
v_shield	= ramaddr ( $FFFFF798 )	; shield status (00 = no; 01 = yes)
v_invinc	= ramaddr ( $FFFFF799 )	; invinciblity status (00 = no; 01 = yes)
v_shoes		= ramaddr ( $FFFFF79A )	; speed shoes status (00 = no; 01 = yes)

v_megadrive	= ramaddr ( $FFFFF79B )	; Megadrive machine type
v_levseldelay	= ramaddr ( $FFFFF79C )	; level select - time until change when up/down is held (2 bytes)
v_levselitem	= ramaddr ( $FFFFF79E )	; level select - item selected (2 bytes)
v_levselsound	= ramaddr ( $FFFFF7A0 )	; level select - sound selected (2 bytes)
v_scorelife	= ramaddr ( $FFFFF7A2 )	; points required for an extra life (4 bytes) (JP1 only)
v_top_solid_bit	= ramaddr ( $FFFFF7A6 )
v_lrb_solid_bit	= ramaddr ( $FFFFF7A7 )
f_levselcheat	= ramaddr ( $FFFFF7A8 )	; level select cheat flag
f_slomocheat	= ramaddr ( $FFFFF7A9 )	; slow motion & frame advance cheat flag
f_debugcheat	= ramaddr ( $FFFFF7AA )	; debug mode cheat flag
f_creditscheat	= ramaddr ( $FFFFF7AB )	; hidden credits & press start cheat flag
v_title_dcount	= ramaddr ( $FFFFF7AC )	; number of times the d-pad is pressed on title screen (2 bytes)
v_title_ccount	= ramaddr ( $FFFFF7AE )	; number of times C is pressed on title screen (2 bytes)
f_demo		= ramaddr ( $FFFFF7B0 )	; demo mode flag (0 = no; 1 = yes; $8001 = ending) (2 bytes)
v_demonum	= ramaddr ( $FFFFF7B2 )	; demo level number (not the same as the level number) (2 bytes)
v_creditsnum	= ramaddr ( $FFFFF7B4 )	; credits index number (2 bytes)
f_debugmode	= ramaddr ( $FFFFF7B6 )	; debug mode flag (sometimes 2 bytes)
v_init		= ramaddr ( $FFFFF7B8 )	; 'init' text string (4 bytes)

f_restart	= ramaddr ( $FFFFF7BC )	; restart level flag (2 bytes)
v_framecount	= ramaddr ( $FFFFF7BE )	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte	= v_framecount+1; low byte for frame counter
v_debugitem	= ramaddr ( $FFFFF7C0 )	; debug item currently selected (NOT the object number of the item)
v_continues	= ramaddr ( $FFFFF7C1 )	; number of continues
v_debuguse	= ramaddr ( $FFFFF7C2 )	; debug mode use & routine counter (when Sonic is a ring/item) (2 bytes)
v_debugxspeed	= ramaddr ( $FFFFF7C4 )	; debug mode - horizontal speed
v_debugyspeed	= ramaddr ( $FFFFF7C5 )	; debug mode - vertical speed
v_vbla_count	= ramaddr ( $FFFFF7C6 )	; vertical interrupt counter (adds 1 every VBlank) (4 bytes)
v_vbla_word	= v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte	= v_vbla_word+1	; low byte for vertical interrupt counter
v_zone		= ramaddr ( $FFFFF7CA )	; current zone number
v_act		= ramaddr ( $FFFFF7CB )	; current act number
v_lives		= ramaddr ( $FFFFF7CC )	; number of lives
v_lastspecial	= ramaddr ( $FFFFF7CD )	; last special stage number
f_timeover	= ramaddr ( $FFFFF7CE )	; time over flag
v_lifecount	= ramaddr ( $FFFFF7CF )	; lives counter value (for actual number, see "v_lives")
f_lifecount	= ramaddr ( $FFFFF7D0 )	; lives counter update flag
f_ringcount	= ramaddr ( $FFFFF7D1 )	; ring counter update flag
f_timecount	= ramaddr ( $FFFFF7D2 )	; time counter update flag
f_scorecount	= ramaddr ( $FFFFF7D3 )	; score counter update flag
v_air		= ramaddr ( $FFFFF7D4 )	; air remaining while underwater (2 bytes)
v_airbyte	= v_air+1	; low byte for air
v_rings		= ramaddr ( $FFFFF7D6 )	; rings (2 bytes)
v_ringbyte	= v_rings+1	; low byte for rings
v_score		= ramaddr ( $FFFFF7D8 )	; score (4 bytes)
v_time		= ramaddr ( $FFFFF7DC )	; time (4 bytes)
v_timemin	= ramaddr ( $FFFFF7DD )	; time - minutes
v_timesec	= ramaddr ( $FFFFF7DE )	; time - seconds
v_timecent	= ramaddr ( $FFFFF7DF )	; time - centiseconds
v_ani0_time	= ramaddr ( $FFFFF7E0 )	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame	= ramaddr ( $FFFFF7E1 )	; synchronised sprite animation 0 - current frame
v_ani1_time	= ramaddr ( $FFFFF7E2 )	; synchronised sprite animation 1 - time until next frame
v_ani1_frame	= ramaddr ( $FFFFF7E3 )	; synchronised sprite animation 1 - current frame
v_ani2_time	= ramaddr ( $FFFFF7E4 )	; synchronised sprite animation 2 - time until next frame
v_ani2_frame	= ramaddr ( $FFFFF7E5 )	; synchronised sprite animation 2 - current frame
v_ani3_time	= ramaddr ( $FFFFF7E6 )	; synchronised sprite animation 3 - time until next frame
v_ani3_frame	= ramaddr ( $FFFFF7E7 )	; synchronised sprite animation 3 - current frame
v_ani3_buf	= ramaddr ( $FFFFF7E8 )	; synchronised sprite animation 3 - info buffer (2 bytes)
v_limittopdb	= ramaddr ( $FFFFF7EA )	; level upper boundary, buffered for debug mode (2 bytes)
v_limitbtmdb	= ramaddr ( $FFFFF7EC )	; level bottom boundary, buffered for debug mode (2 bytes)
v_fg_scroll_flags	= ramaddr ( $FFFFF7EE )	; screen redraw flags for foreground
v_bg1_scroll_flags	= ramaddr ( $FFFFF7F0 )	; screen redraw flags for background 1
v_bg2_scroll_flags	= ramaddr ( $FFFFF7F2 )	; screen redraw flags for background 2
v_bg3_scroll_flags	= ramaddr ( $FFFFF7F4 )	; screen redraw flags for background 3
f_water		= ramaddr ( $FFFFF7F5 )	; flag set for water
v_bossstatus	= ramaddr ( $FFFFF7F6 )	; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)

; 14 free bytes
v_spritetablebuffer	= ramaddr ( $FFFFF800 ) ; sprite table ($280 bytes, last $80 bytes are overwritten by v_pal_water_dup)
v_pal_water_dup	= ramaddr ( $FFFFFA80 ) ; duplicate underwater palette, used for transitions ($80 bytes)
v_pal_water	= ramaddr ( $FFFFFB00 )	; main underwater palette ($80 bytes)
v_pal_dry	= ramaddr ( $FFFFFB80 )	; main palette ($80 bytes)
v_pal_dry_dup	= ramaddr ( $FFFFFC00 )	; duplicate palette, used for transitions ($80 bytes)
v_objstate	= ramaddr ( $FFFFFC80 )	; object state list ($200 bytes)


;v_scroll_block_1_size	= ramaddr ( $FFFFF766 )	; (2 bytes)
;v_scroll_block_2_size	= ramaddr ( $FFFFF768 )	; unused (2 bytes)
;v_scroll_block_3_size	= ramaddr ( $FFFFF76A )	; unused (2 bytes)
;v_scroll_block_4_size	= ramaddr ( $FFFFF76C )	; unused (2 bytes)

;v_bgscreenposx_dup_unused	= ramaddr ( $FFFFF61C )	; background screen position x (duplicate) (2 bytes)
;v_bg3screenposy_dup_unused	= ramaddr ( $FFFFF61E )	; (2 bytes)
;v_bg3screenposx_dup_unused	= ramaddr ( $FFFFF620 )	; (2 bytes)
;v_bg2_yblock	= ramaddr ( $FFFFF74F )	; secondary background y-block parity (unused)
;v_bg3_yblock	= ramaddr ( $FFFFF751 )	; teritary background y-block parity (unused)
;f_sonframechg	= ramaddr ( $FFFFF722 )	; flag set to update Sonic's sprite frame
