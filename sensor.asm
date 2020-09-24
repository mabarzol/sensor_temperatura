
_main:

;sensor.c,6 :: 		void main()
;sensor.c,8 :: 		CMCON  |= 7;                               // Disable Comparators
	MOVLW      7
	IORWF      CMCON+0, 1
;sensor.c,10 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_mask:

;sensor.c,11 :: 		unsigned short mask(unsigned short num) // Mask for 7 segment common anode;
;sensor.c,13 :: 		switch (num)
	GOTO       L_mask0
;sensor.c,15 :: 		case 0:
L_mask2:
;sensor.c,16 :: 		return 0xC0; // 0;
	MOVLW      192
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,17 :: 		case 1:
L_mask3:
;sensor.c,18 :: 		return 0xF9; // 1;
	MOVLW      249
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,19 :: 		case 2:
L_mask4:
;sensor.c,20 :: 		return 0xA4; // 2;
	MOVLW      164
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,21 :: 		case 3:
L_mask5:
;sensor.c,22 :: 		return 0xB0; // 3;
	MOVLW      176
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,23 :: 		case 4:
L_mask6:
;sensor.c,24 :: 		return 0x99; // 4;
	MOVLW      153
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,25 :: 		case 5:
L_mask7:
;sensor.c,26 :: 		return 0x92; // 5;
	MOVLW      146
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,27 :: 		case 6:
L_mask8:
;sensor.c,28 :: 		return 0x82; // 6;
	MOVLW      130
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,29 :: 		case 7:
L_mask9:
;sensor.c,30 :: 		return 0xF8; // 7;
	MOVLW      248
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,31 :: 		case 8:
L_mask10:
;sensor.c,32 :: 		return 0x80; // 8;
	MOVLW      128
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,33 :: 		case 9:
L_mask11:
;sensor.c,34 :: 		return 0x90; // 9;
	MOVLW      144
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,35 :: 		case 10:
L_mask12:
;sensor.c,36 :: 		return 0xBF; // Symbol '-'
	MOVLW      191
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,37 :: 		case 11:
L_mask13:
;sensor.c,38 :: 		return 0x9E; // Symbol C
	MOVLW      158
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,39 :: 		case 12:
L_mask14:
;sensor.c,40 :: 		return 0xFF; // Blank
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,41 :: 		}                //case end
L_mask0:
	MOVF       FARG_mask_num+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_mask2
	MOVF       FARG_mask_num+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_mask3
	MOVF       FARG_mask_num+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_mask4
	MOVF       FARG_mask_num+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_mask5
	MOVF       FARG_mask_num+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_mask6
	MOVF       FARG_mask_num+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_mask7
	MOVF       FARG_mask_num+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_mask8
	MOVF       FARG_mask_num+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_mask9
	MOVF       FARG_mask_num+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_mask10
	MOVF       FARG_mask_num+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_mask11
	MOVF       FARG_mask_num+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_mask12
	MOVF       FARG_mask_num+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_mask13
	MOVF       FARG_mask_num+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_mask14
;sensor.c,42 :: 		}
L_end_mask:
	RETURN
; end of _mask

_display_temp:

;sensor.c,43 :: 		void display_temp(short DD0, short DD1)
;sensor.c,45 :: 		for (i = 0; i <= 2; i++)
	CLRF       _i+0
L_display_temp15:
	MOVF       _i+0, 0
	SUBLW      2
	BTFSS      STATUS+0, 0
	GOTO       L_display_temp16
;sensor.c,47 :: 		PORTB = DD0;
	MOVF       FARG_display_temp_DD0+0, 0
	MOVWF      PORTB+0
;sensor.c,48 :: 		RA0_bit = 0;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,49 :: 		RA1_bit = 1; // Select Ones Digit;
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,50 :: 		delay_ms(2);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_display_temp18:
	DECFSZ     R13+0, 1
	GOTO       L_display_temp18
	DECFSZ     R12+0, 1
	GOTO       L_display_temp18
	NOP
	NOP
;sensor.c,51 :: 		PORTB = DD1;
	MOVF       FARG_display_temp_DD1+0, 0
	MOVWF      PORTB+0
;sensor.c,52 :: 		RA0_bit = 1;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,53 :: 		RA1_bit = 0;
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,54 :: 		delay_ms(2);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_display_temp19:
	DECFSZ     R13+0, 1
	GOTO       L_display_temp19
	DECFSZ     R12+0, 1
	GOTO       L_display_temp19
	NOP
	NOP
;sensor.c,45 :: 		for (i = 0; i <= 2; i++)
	INCF       _i+0, 1
;sensor.c,55 :: 		}
	GOTO       L_display_temp15
L_display_temp16:
;sensor.c,56 :: 		return;
;sensor.c,57 :: 		}
L_end_display_temp:
	RETURN
; end of _display_temp

_DS18B20:

;sensor.c,58 :: 		void DS18B20() //Perform temperature reading
;sensor.c,60 :: 		Ow_Reset(&PORTA, 4);       // Onewire reset signal
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;sensor.c,61 :: 		Ow_Write(&PORTA, 4, 0xCC); // Issue command SKIP_ROM
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,62 :: 		Ow_Write(&PORTA, 4, 0x44); // Issue command CONVERT_T
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,63 :: 		Ow_Reset(&PORTA, 4);
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;sensor.c,64 :: 		Ow_Write(&PORTA, 4, 0xCC); // Issue command SKIP_ROM
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,65 :: 		Ow_Write(&PORTA, 4, 0xBE); // Issue command READ_SCRATCHPAD
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,67 :: 		temp_value = Ow_Read(&PORTA, 4);                     // Read Byte 0 from Scratchpad
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_value+0
	CLRF       _temp_value+1
;sensor.c,68 :: 		temp_value = (Ow_Read(&PORTA, 4) << 8) + temp_value; // Then read Byte 1 from
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      R4+1
	CLRF       R4+0
	MOVF       _temp_value+0, 0
	ADDWF      R4+0, 0
	MOVWF      R2+0
	MOVF       R4+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_value+1, 0
	MOVWF      R2+1
	MOVF       R2+0, 0
	MOVWF      _temp_value+0
	MOVF       R2+1, 0
	MOVWF      _temp_value+1
;sensor.c,71 :: 		if (temp_value & 0x8000)
	BTFSS      R2+1, 7
	GOTO       L_DS18B2020
;sensor.c,73 :: 		temp_value = ~temp_value + 1;
	COMF       _temp_value+0, 1
	COMF       _temp_value+1, 1
	INCF       _temp_value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _temp_value+1, 1
;sensor.c,74 :: 		N_Flag = 1; // Temp is -ive
	MOVLW      1
	MOVWF      _N_Flag+0
;sensor.c,75 :: 		}
L_DS18B2020:
;sensor.c,76 :: 		if (temp_value & 0x0001)
	BTFSS      _temp_value+0, 0
	GOTO       L_DS18B2021
;sensor.c,77 :: 		temp_value += 1;          // 0.5 round to 1
	INCF       _temp_value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _temp_value+1, 1
L_DS18B2021:
;sensor.c,78 :: 		temp_value = temp_value >> 4; //<<<  // 1 for DS1820 and
	RRF        _temp_value+1, 1
	RRF        _temp_value+0, 1
	BCF        _temp_value+1, 7
	RRF        _temp_value+1, 1
	RRF        _temp_value+0, 1
	BCF        _temp_value+1, 7
	RRF        _temp_value+1, 1
	RRF        _temp_value+0, 1
	BCF        _temp_value+1, 7
	RRF        _temp_value+1, 1
	RRF        _temp_value+0, 1
	BCF        _temp_value+1, 7
;sensor.c,80 :: 		}
L_end_DS18B20:
	RETURN
; end of _DS18B20
