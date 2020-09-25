
_main:

;sensor.c,8 :: 		void main()
;sensor.c,10 :: 		CMCON |= 7;     // Disable Comparators
	MOVLW      7
	IORWF      CMCON+0, 1
;sensor.c,11 :: 		TRISA0_bit = 0; // RA.0 to RA3 Output
	BCF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;sensor.c,12 :: 		TRISA1_bit = 0;
	BCF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
;sensor.c,13 :: 		TRISA2_bit = 0;
	BCF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;sensor.c,14 :: 		TRISB0_bit = 0;
	BCF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;sensor.c,15 :: 		TRISB1_bit = 0;
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;sensor.c,16 :: 		TRISB2_bit = 0;
	BCF        TRISB2_bit+0, BitPos(TRISB2_bit+0)
;sensor.c,17 :: 		TRISB3_bit = 0;
	BCF        TRISB3_bit+0, BitPos(TRISB3_bit+0)
;sensor.c,18 :: 		TRISB4_bit = 0;
	BCF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;sensor.c,19 :: 		TRISB5_bit = 0;
	BCF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;sensor.c,20 :: 		TRISB6_bit = 0;
	BCF        TRISB6_bit+0, BitPos(TRISB6_bit+0)
;sensor.c,21 :: 		PORTB = 1;
	MOVLW      1
	MOVWF      PORTB+0
;sensor.c,22 :: 		valor_manual = 20;
	MOVLW      20
	MOVWF      _valor_manual+0
;sensor.c,26 :: 		do
L_main0:
;sensor.c,29 :: 		if (presionBoton(3))
	MOVLW      3
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main3
;sensor.c,31 :: 		}
L_main3:
;sensor.c,32 :: 		if (presionBoton(6))
	MOVLW      6
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main4
;sensor.c,34 :: 		}
L_main4:
;sensor.c,35 :: 		if (presionBoton(7))
	MOVLW      7
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
;sensor.c,37 :: 		N_Flag = 0; // Reset Temp Flag
	CLRF       _N_Flag+0
;sensor.c,38 :: 		DS18B20();
	CALL       _DS18B20+0
;sensor.c,39 :: 		DD0 = temp_value % 10; // Extract Ones Digit
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _temp_value+0, 0
	MOVWF      R0+0
	MOVF       _temp_value+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _DD0+0
;sensor.c,40 :: 		DD0 = mask(DD0);
	MOVF       R0+0, 0
	MOVWF      FARG_mask_num+0
	CALL       _mask+0
	MOVF       R0+0, 0
	MOVWF      _DD0+0
;sensor.c,41 :: 		DD1 = (temp_value / 10) % 10; // Extract Tens Digit
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _temp_value+0, 0
	MOVWF      R0+0
	MOVF       _temp_value+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _DD1+0
;sensor.c,42 :: 		DD1 = mask(DD1);
	MOVF       R0+0, 0
	MOVWF      FARG_mask_num+0
	CALL       _mask+0
	MOVF       R0+0, 0
	MOVWF      _DD1+0
;sensor.c,43 :: 		display_temp(DD0, DD1); // Infinite loop;
	MOVF       _DD0+0, 0
	MOVWF      FARG_display_temp_DD0+0
	MOVF       R0+0, 0
	MOVWF      FARG_display_temp_DD1+0
	CALL       _display_temp+0
;sensor.c,44 :: 		}
L_main5:
;sensor.c,46 :: 		} while (1);
	GOTO       L_main0
;sensor.c,47 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_mask:

;sensor.c,49 :: 		unsigned short mask(unsigned short num) // Mask for 7 segment common anode;
;sensor.c,51 :: 		switch (num)
	GOTO       L_mask6
;sensor.c,53 :: 		case 0:
L_mask8:
;sensor.c,54 :: 		return 0x40; // 0;
	MOVLW      64
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,55 :: 		case 1:
L_mask9:
;sensor.c,56 :: 		return 0x79; // 1;
	MOVLW      121
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,57 :: 		case 2:
L_mask10:
;sensor.c,58 :: 		return 0x24; // 2;
	MOVLW      36
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,59 :: 		case 3:
L_mask11:
;sensor.c,60 :: 		return 0x30; // 3;
	MOVLW      48
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,61 :: 		case 4:
L_mask12:
;sensor.c,62 :: 		return 0x19; // 4;
	MOVLW      25
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,63 :: 		case 5:
L_mask13:
;sensor.c,64 :: 		return 0x12; // 5;
	MOVLW      18
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,65 :: 		case 6:
L_mask14:
;sensor.c,66 :: 		return 0x02; // 6;
	MOVLW      2
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,67 :: 		case 7:
L_mask15:
;sensor.c,68 :: 		return 0x78; // 7;
	MOVLW      120
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,69 :: 		case 8:
L_mask16:
;sensor.c,70 :: 		return 0x00; // 8;
	CLRF       R0+0
	GOTO       L_end_mask
;sensor.c,71 :: 		case 9:
L_mask17:
;sensor.c,72 :: 		return 0x10; // 9;
	MOVLW      16
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,73 :: 		case 10:
L_mask18:
;sensor.c,74 :: 		return 0xBF; // Symbol '-'
	MOVLW      191
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,75 :: 		case 11:
L_mask19:
;sensor.c,76 :: 		return 0x9E; // Symbol C
	MOVLW      158
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,77 :: 		case 12:
L_mask20:
;sensor.c,78 :: 		return 0xFF; // Blank
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,79 :: 		}                //case end
L_mask6:
	MOVF       FARG_mask_num+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_mask8
	MOVF       FARG_mask_num+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_mask9
	MOVF       FARG_mask_num+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_mask10
	MOVF       FARG_mask_num+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_mask11
	MOVF       FARG_mask_num+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_mask12
	MOVF       FARG_mask_num+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_mask13
	MOVF       FARG_mask_num+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_mask14
	MOVF       FARG_mask_num+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_mask15
	MOVF       FARG_mask_num+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_mask16
	MOVF       FARG_mask_num+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_mask17
	MOVF       FARG_mask_num+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_mask18
	MOVF       FARG_mask_num+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_mask19
	MOVF       FARG_mask_num+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_mask20
;sensor.c,80 :: 		}
L_end_mask:
	RETURN
; end of _mask

_display_temp:

;sensor.c,81 :: 		void display_temp(short DD0, short DD1)
;sensor.c,83 :: 		for (i = 0; i <= 4; i++)
	CLRF       _i+0
L_display_temp21:
	MOVF       _i+0, 0
	SUBLW      4
	BTFSS      STATUS+0, 0
	GOTO       L_display_temp22
;sensor.c,85 :: 		PORTB = DD0;
	MOVF       FARG_display_temp_DD0+0, 0
	MOVWF      PORTB+0
;sensor.c,86 :: 		RA0_bit = 0;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,87 :: 		RA1_bit = 1; // Select Ones Digit;
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,88 :: 		delay_ms(2);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_display_temp24:
	DECFSZ     R13+0, 1
	GOTO       L_display_temp24
	DECFSZ     R12+0, 1
	GOTO       L_display_temp24
	NOP
	NOP
;sensor.c,89 :: 		PORTB = DD1;
	MOVF       FARG_display_temp_DD1+0, 0
	MOVWF      PORTB+0
;sensor.c,90 :: 		RA0_bit = 1;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,91 :: 		RA1_bit = 0;
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,92 :: 		delay_ms(2);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_display_temp25:
	DECFSZ     R13+0, 1
	GOTO       L_display_temp25
	DECFSZ     R12+0, 1
	GOTO       L_display_temp25
	NOP
	NOP
;sensor.c,83 :: 		for (i = 0; i <= 4; i++)
	INCF       _i+0, 1
;sensor.c,93 :: 		}
	GOTO       L_display_temp21
L_display_temp22:
;sensor.c,94 :: 		return;
;sensor.c,95 :: 		}
L_end_display_temp:
	RETURN
; end of _display_temp

_DS18B20:

;sensor.c,96 :: 		void DS18B20() //Perform temperature reading
;sensor.c,99 :: 		Ow_Reset(&PORTA, 4);       // Onewire reset signal
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;sensor.c,100 :: 		Ow_Write(&PORTA, 4, 0xCC); // Issue command SKIP_ROM
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,101 :: 		Ow_Write(&PORTA, 4, 0x44); // Issue command CONVERT_T
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,103 :: 		Ow_Reset(&PORTA, 4);
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;sensor.c,104 :: 		Ow_Write(&PORTA, 4, 0xCC); // Issue command SKIP_ROM
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,105 :: 		Ow_Write(&PORTA, 4, 0xBE); // Issue command READ_SCRATCHPAD
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,108 :: 		temp_value = Ow_Read(&PORTA, 4);                     // Read Byte 0 from Scratchpad
	MOVLW      PORTA+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      4
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_value+0
	CLRF       _temp_value+1
;sensor.c,109 :: 		temp_value = (Ow_Read(&PORTA, 4) << 8) + temp_value; // Then read Byte 1 from
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
;sensor.c,112 :: 		if (temp_value & 0x8000)
	BTFSS      R2+1, 7
	GOTO       L_DS18B2026
;sensor.c,114 :: 		temp_value = ~temp_value + 1;
	COMF       _temp_value+0, 1
	COMF       _temp_value+1, 1
	INCF       _temp_value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _temp_value+1, 1
;sensor.c,115 :: 		N_Flag = 1; // Temp is -ive
	MOVLW      1
	MOVWF      _N_Flag+0
;sensor.c,116 :: 		}
L_DS18B2026:
;sensor.c,117 :: 		if (temp_value & 0x0001)
	BTFSS      _temp_value+0, 0
	GOTO       L_DS18B2027
;sensor.c,118 :: 		temp_value += 1;          // 0.5 round to 1
	INCF       _temp_value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _temp_value+1, 1
L_DS18B2027:
;sensor.c,119 :: 		temp_value = temp_value >> 4; //<<<  // 1 for DS1820 and
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
;sensor.c,121 :: 		}
L_end_DS18B20:
	RETURN
; end of _DS18B20

_presionBoton:

;sensor.c,122 :: 		unsigned short presionBoton(unsigned short pin)
;sensor.c,125 :: 		oldstate = 0;
	BCF        presionBoton_oldstate_L0+0, BitPos(presionBoton_oldstate_L0+0)
;sensor.c,126 :: 		if (Button(&PORTA, pin, 10, 1))
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVF       FARG_presionBoton_pin+0, 0
	MOVWF      FARG_Button_pin+0
	MOVLW      10
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_presionBoton28
;sensor.c,128 :: 		oldstate = 1; // Update flag
	BSF        presionBoton_oldstate_L0+0, BitPos(presionBoton_oldstate_L0+0)
;sensor.c,129 :: 		}
	GOTO       L_presionBoton29
L_presionBoton28:
;sensor.c,132 :: 		return 0;
	CLRF       R0+0
	GOTO       L_end_presionBoton
;sensor.c,133 :: 		}
L_presionBoton29:
;sensor.c,134 :: 		if (oldstate && Button(&PORTA, pin, 10, 0))
	BTFSS      presionBoton_oldstate_L0+0, BitPos(presionBoton_oldstate_L0+0)
	GOTO       L_presionBoton32
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVF       FARG_presionBoton_pin+0, 0
	MOVWF      FARG_Button_pin+0
	MOVLW      10
	MOVWF      FARG_Button_time_ms+0
	CLRF       FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_presionBoton32
L__presionBoton33:
;sensor.c,136 :: 		oldstate = 0; // Update flag
	BCF        presionBoton_oldstate_L0+0, BitPos(presionBoton_oldstate_L0+0)
;sensor.c,137 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	GOTO       L_end_presionBoton
;sensor.c,138 :: 		}
L_presionBoton32:
;sensor.c,139 :: 		}
L_end_presionBoton:
	RETURN
; end of _presionBoton
