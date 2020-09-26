
_main:

;sensor.c,10 :: 		void main()
;sensor.c,12 :: 		CMCON |= 7;     // Disable Comparators
	MOVLW      7
	IORWF      CMCON+0, 1
;sensor.c,14 :: 		TRISA0_bit = 0; // RA.0 to RA.2 Output, RA.4 Output
	BCF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;sensor.c,15 :: 		TRISA1_bit = 0; // RB.0 to RB.6 Output
	BCF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
;sensor.c,16 :: 		TRISA2_bit = 0; // RA.5 Resetn Only
	BCF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;sensor.c,17 :: 		TRISA4_bit = 0; // RA.3 Input temp +
	BCF        TRISA4_bit+0, BitPos(TRISA4_bit+0)
;sensor.c,18 :: 		TRISB0_bit = 0; // RA.6 Input temp -
	BCF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;sensor.c,19 :: 		TRISB1_bit = 0; // RA.7 Input start/stop
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;sensor.c,20 :: 		TRISB2_bit = 0; //**********************************************//
	BCF        TRISB2_bit+0, BitPos(TRISB2_bit+0)
;sensor.c,21 :: 		TRISB3_bit = 0;
	BCF        TRISB3_bit+0, BitPos(TRISB3_bit+0)
;sensor.c,22 :: 		TRISB4_bit = 0;
	BCF        TRISB4_bit+0, BitPos(TRISB4_bit+0)
;sensor.c,23 :: 		TRISB5_bit = 0;
	BCF        TRISB5_bit+0, BitPos(TRISB5_bit+0)
;sensor.c,24 :: 		TRISB6_bit = 0;
	BCF        TRISB6_bit+0, BitPos(TRISB6_bit+0)
;sensor.c,25 :: 		PORTB = 1;
	MOVLW      1
	MOVWF      PORTB+0
;sensor.c,26 :: 		valor_manual = temp_por_defecto;
	MOVF       _temp_por_defecto+0, 0
	MOVWF      _valor_manual+0
;sensor.c,27 :: 		RA0_bit = 0;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,28 :: 		RA1_bit = 0;
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,29 :: 		RA2_bit = 1;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;sensor.c,30 :: 		do
L_main0:
;sensor.c,32 :: 		DD0 = valor_manual % 10; // Extract One Digit
	MOVLW      10
	MOVWF      R4+0
	MOVF       _valor_manual+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _DD0+0
;sensor.c,33 :: 		DD0 = mask(DD0);
	MOVF       _DD0+0, 0
	MOVWF      FARG_mask_num+0
	CALL       _mask+0
	MOVF       R0+0, 0
	MOVWF      _DD0+0
;sensor.c,34 :: 		DD1 = (valor_manual / 10) % 10; // Extract Tens Digit
	MOVLW      10
	MOVWF      R4+0
	MOVF       _valor_manual+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      _DD1+0
;sensor.c,35 :: 		DD1 = mask(DD1);
	MOVF       _DD1+0, 0
	MOVWF      FARG_mask_num+0
	CALL       _mask+0
	MOVF       R0+0, 0
	MOVWF      _DD1+0
;sensor.c,36 :: 		display_temp(DD0, DD1);
	MOVF       _DD0+0, 0
	MOVWF      FARG_display_temp_DD0+0
	MOVF       _DD1+0, 0
	MOVWF      FARG_display_temp_DD1+0
	CALL       _display_temp+0
;sensor.c,38 :: 		if (presionBoton(3) == 3) //Si se presiono el boton de temp +
	MOVLW      3
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;sensor.c,40 :: 		if (valor_manual <= temp_maxima) //Si el valor seteado es menor a la temperatura maxima acumule en 1
	MOVF       _valor_manual+0, 0
	SUBWF      _temp_maxima+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main4
;sensor.c,42 :: 		valor_manual++;
	INCF       _valor_manual+0, 1
;sensor.c,43 :: 		}
L_main4:
;sensor.c,44 :: 		}
L_main3:
;sensor.c,45 :: 		if (presionBoton(6) == 6) //si se presiono el boton de temp -
	MOVLW      6
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_main5
;sensor.c,47 :: 		if (valor_manual >= temp_minima) //Si el valor seteado es mayor a la temperatura maxima disminuye en 1
	MOVF       _temp_minima+0, 0
	SUBWF      _valor_manual+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main6
;sensor.c,49 :: 		valor_manual--;
	DECF       _valor_manual+0, 1
;sensor.c,50 :: 		}
L_main6:
;sensor.c,51 :: 		}
L_main5:
;sensor.c,52 :: 		if (presionBoton(7) == 7) //si se presiono el boton start
	MOVLW      7
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_main7
;sensor.c,54 :: 		do
L_main8:
;sensor.c,56 :: 		N_Flag = 0; // Reset Temp Flag
	CLRF       _N_Flag+0
;sensor.c,57 :: 		DS18B20();
	CALL       _DS18B20+0
;sensor.c,58 :: 		DD0 = temp_value % 10;
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
;sensor.c,59 :: 		DD0 = mask(DD0);
	MOVF       _DD0+0, 0
	MOVWF      FARG_mask_num+0
	CALL       _mask+0
	MOVF       R0+0, 0
	MOVWF      _DD0+0
;sensor.c,60 :: 		DD1 = (temp_value / 10) % 10;
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
;sensor.c,61 :: 		DD1 = mask(DD1);
	MOVF       _DD1+0, 0
	MOVWF      FARG_mask_num+0
	CALL       _mask+0
	MOVF       R0+0, 0
	MOVWF      _DD1+0
;sensor.c,62 :: 		display_temp(DD0, DD1);
	MOVF       _DD0+0, 0
	MOVWF      FARG_display_temp_DD0+0
	MOVF       _DD1+0, 0
	MOVWF      FARG_display_temp_DD1+0
	CALL       _display_temp+0
;sensor.c,63 :: 		if (temp_value >= valor_manual)
	MOVLW      0
	SUBWF      _temp_value+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main43
	MOVF       _valor_manual+0, 0
	SUBWF      _temp_value+0, 0
L__main43:
	BTFSS      STATUS+0, 0
	GOTO       L_main11
;sensor.c,65 :: 		RA2_bit = 1;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;sensor.c,66 :: 		}
	GOTO       L_main12
L_main11:
;sensor.c,69 :: 		RA2_bit = 0;
	BCF        RA2_bit+0, BitPos(RA2_bit+0)
;sensor.c,70 :: 		}
L_main12:
;sensor.c,72 :: 		} while (!presionBoton(7)); //Mientras no se presione el boton start
	MOVLW      7
	MOVWF      FARG_presionBoton_pin+0
	CALL       _presionBoton+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main8
;sensor.c,73 :: 		RA2_bit = 1;
	BSF        RA2_bit+0, BitPos(RA2_bit+0)
;sensor.c,74 :: 		}
L_main7:
;sensor.c,76 :: 		} while (1);
	GOTO       L_main0
;sensor.c,77 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_mask:

;sensor.c,79 :: 		unsigned short mask(unsigned short num) // Mask for 7 segment Common Anode;
;sensor.c,81 :: 		switch (num)
	GOTO       L_mask13
;sensor.c,83 :: 		case 0:
L_mask15:
;sensor.c,84 :: 		return 0x40; // 0;
	MOVLW      64
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,85 :: 		case 1:
L_mask16:
;sensor.c,86 :: 		return 0x79; // 1;
	MOVLW      121
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,87 :: 		case 2:
L_mask17:
;sensor.c,88 :: 		return 0x24; // 2;
	MOVLW      36
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,89 :: 		case 3:
L_mask18:
;sensor.c,90 :: 		return 0x30; // 3;
	MOVLW      48
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,91 :: 		case 4:
L_mask19:
;sensor.c,92 :: 		return 0x19; // 4;
	MOVLW      25
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,93 :: 		case 5:
L_mask20:
;sensor.c,94 :: 		return 0x12; // 5;
	MOVLW      18
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,95 :: 		case 6:
L_mask21:
;sensor.c,96 :: 		return 0x02; // 6;
	MOVLW      2
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,97 :: 		case 7:
L_mask22:
;sensor.c,98 :: 		return 0x78; // 7;
	MOVLW      120
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,99 :: 		case 8:
L_mask23:
;sensor.c,100 :: 		return 0x00; // 8;
	CLRF       R0+0
	GOTO       L_end_mask
;sensor.c,101 :: 		case 9:
L_mask24:
;sensor.c,102 :: 		return 0x10; // 9;
	MOVLW      16
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,103 :: 		case 10:
L_mask25:
;sensor.c,104 :: 		return 0xBF; // Symbol '-'
	MOVLW      191
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,105 :: 		case 11:
L_mask26:
;sensor.c,106 :: 		return 0x9E; // Symbol C
	MOVLW      158
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,107 :: 		case 12:
L_mask27:
;sensor.c,108 :: 		return 0xFF; // Blank
	MOVLW      255
	MOVWF      R0+0
	GOTO       L_end_mask
;sensor.c,109 :: 		}                //case end
L_mask13:
	MOVF       FARG_mask_num+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_mask15
	MOVF       FARG_mask_num+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_mask16
	MOVF       FARG_mask_num+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_mask17
	MOVF       FARG_mask_num+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_mask18
	MOVF       FARG_mask_num+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_mask19
	MOVF       FARG_mask_num+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_mask20
	MOVF       FARG_mask_num+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_mask21
	MOVF       FARG_mask_num+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_mask22
	MOVF       FARG_mask_num+0, 0
	XORLW      8
	BTFSC      STATUS+0, 2
	GOTO       L_mask23
	MOVF       FARG_mask_num+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_mask24
	MOVF       FARG_mask_num+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_mask25
	MOVF       FARG_mask_num+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_mask26
	MOVF       FARG_mask_num+0, 0
	XORLW      12
	BTFSC      STATUS+0, 2
	GOTO       L_mask27
;sensor.c,110 :: 		}
L_end_mask:
	RETURN
; end of _mask

_display_temp:

;sensor.c,111 :: 		void display_temp(short DD0, short DD1)
;sensor.c,113 :: 		for (i = 0; i <= 4; i++)
	CLRF       _i+0
L_display_temp28:
	MOVF       _i+0, 0
	SUBLW      4
	BTFSS      STATUS+0, 0
	GOTO       L_display_temp29
;sensor.c,115 :: 		PORTB = DD0;
	MOVF       FARG_display_temp_DD0+0, 0
	MOVWF      PORTB+0
;sensor.c,116 :: 		RA0_bit = 0;
	BCF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,117 :: 		RA1_bit = 1;
	BSF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,118 :: 		delay_ms(2);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_display_temp31:
	DECFSZ     R13+0, 1
	GOTO       L_display_temp31
	DECFSZ     R12+0, 1
	GOTO       L_display_temp31
	NOP
	NOP
;sensor.c,119 :: 		PORTB = DD1;
	MOVF       FARG_display_temp_DD1+0, 0
	MOVWF      PORTB+0
;sensor.c,120 :: 		RA0_bit = 1;
	BSF        RA0_bit+0, BitPos(RA0_bit+0)
;sensor.c,121 :: 		RA1_bit = 0;
	BCF        RA1_bit+0, BitPos(RA1_bit+0)
;sensor.c,122 :: 		delay_ms(2);
	MOVLW      3
	MOVWF      R12+0
	MOVLW      151
	MOVWF      R13+0
L_display_temp32:
	DECFSZ     R13+0, 1
	GOTO       L_display_temp32
	DECFSZ     R12+0, 1
	GOTO       L_display_temp32
	NOP
	NOP
;sensor.c,113 :: 		for (i = 0; i <= 4; i++)
	INCF       _i+0, 1
;sensor.c,123 :: 		}
	GOTO       L_display_temp28
L_display_temp29:
;sensor.c,124 :: 		return;
;sensor.c,125 :: 		}
L_end_display_temp:
	RETURN
; end of _display_temp

_DS18B20:

;sensor.c,126 :: 		void DS18B20()
;sensor.c,128 :: 		Ow_Reset(&PORTB, 7);       // Onewire reset signal
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;sensor.c,129 :: 		Ow_Write(&PORTB, 7, 0xCC); // Issue command SKIP_ROM
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,130 :: 		Ow_Write(&PORTB, 7, 0x44); // Issue command CONVERT_T
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      68
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,131 :: 		Ow_Reset(&PORTB, 7);
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Reset_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Reset_pin+0
	CALL       _Ow_Reset+0
;sensor.c,132 :: 		Ow_Write(&PORTB, 7, 0xCC); // Issue command SKIP_ROM
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      204
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,133 :: 		Ow_Write(&PORTB, 7, 0xBE); // Issue command READ_SCRATCHPAD
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Write_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Write_pin+0
	MOVLW      190
	MOVWF      FARG_Ow_Write_data_+0
	CALL       _Ow_Write+0
;sensor.c,135 :: 		temp_value = Ow_Read(&PORTB, 7);                     // Read Byte 0 from Scratchpad
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp_value+0
	CLRF       _temp_value+1
;sensor.c,136 :: 		temp_value = (Ow_Read(&PORTB, 7) << 8) + temp_value; // Then read Byte 1 from
	MOVLW      PORTB+0
	MOVWF      FARG_Ow_Read_port+0
	MOVLW      7
	MOVWF      FARG_Ow_Read_pin+0
	CALL       _Ow_Read+0
	MOVF       R0+0, 0
	MOVWF      R1+1
	CLRF       R1+0
	MOVF       R1+0, 0
	ADDWF      _temp_value+0, 1
	MOVF       R1+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _temp_value+1, 1
;sensor.c,139 :: 		if (temp_value & 0x8000)
	BTFSS      _temp_value+1, 7
	GOTO       L_DS18B2033
;sensor.c,141 :: 		temp_value = ~temp_value + 1;
	COMF       _temp_value+0, 1
	COMF       _temp_value+1, 1
	INCF       _temp_value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _temp_value+1, 1
;sensor.c,142 :: 		N_Flag = 1; // Temp is -ive
	MOVLW      1
	MOVWF      _N_Flag+0
;sensor.c,143 :: 		}
L_DS18B2033:
;sensor.c,144 :: 		if (temp_value & 0x0001)
	BTFSS      _temp_value+0, 0
	GOTO       L_DS18B2034
;sensor.c,145 :: 		temp_value += 1;          // 0.5 round to 1
	INCF       _temp_value+0, 1
	BTFSC      STATUS+0, 2
	INCF       _temp_value+1, 1
L_DS18B2034:
;sensor.c,146 :: 		temp_value = temp_value >> 4; //<<<  // 1 for DS1820 and
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
;sensor.c,148 :: 		if (N_Flag == 1)              //Verifico que el valor de temperatura es negativo
	MOVF       _N_Flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_DS18B2035
;sensor.c,150 :: 		temp_value = 0; //Seteo la temperatura en 0 grados
	CLRF       _temp_value+0
	CLRF       _temp_value+1
;sensor.c,151 :: 		}
L_DS18B2035:
;sensor.c,152 :: 		if (temp_value >= 99) //Verifico que el valor de temperatura es mayor a 99
	MOVLW      0
	SUBWF      _temp_value+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__DS18B2047
	MOVLW      99
	SUBWF      _temp_value+0, 0
L__DS18B2047:
	BTFSS      STATUS+0, 0
	GOTO       L_DS18B2036
;sensor.c,154 :: 		temp_value = 99; //Seteo la temperatura en 99 grados
	MOVLW      99
	MOVWF      _temp_value+0
	MOVLW      0
	MOVWF      _temp_value+1
;sensor.c,155 :: 		}
L_DS18B2036:
;sensor.c,156 :: 		}
L_end_DS18B20:
	RETURN
; end of _DS18B20

_presionBoton:

;sensor.c,157 :: 		unsigned short presionBoton(unsigned short pin) //Verifica si se presiona o suelta el boton
;sensor.c,159 :: 		int pulso = 0;
	CLRF       presionBoton_pulso_L0+0
	CLRF       presionBoton_pulso_L0+1
	CLRF       presionBoton_oldstate_L0+0
	CLRF       presionBoton_oldstate_L0+1
;sensor.c,161 :: 		pulso = Button(&PORTA, pin, 100, 1);
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVF       FARG_presionBoton_pin+0, 0
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	MOVWF      presionBoton_pulso_L0+0
	CLRF       presionBoton_pulso_L0+1
;sensor.c,162 :: 		if (pulso != 0)
	MOVLW      0
	XORWF      presionBoton_pulso_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__presionBoton49
	MOVLW      0
	XORWF      presionBoton_pulso_L0+0, 0
L__presionBoton49:
	BTFSC      STATUS+0, 2
	GOTO       L_presionBoton37
;sensor.c,164 :: 		oldstate = 1;
	MOVLW      1
	MOVWF      presionBoton_oldstate_L0+0
	MOVLW      0
	MOVWF      presionBoton_oldstate_L0+1
;sensor.c,165 :: 		}
L_presionBoton37:
;sensor.c,166 :: 		while (pulso == 1)
L_presionBoton38:
	MOVLW      0
	XORWF      presionBoton_pulso_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__presionBoton50
	MOVLW      1
	XORWF      presionBoton_pulso_L0+0, 0
L__presionBoton50:
	BTFSS      STATUS+0, 2
	GOTO       L_presionBoton39
;sensor.c,168 :: 		pulso = Button(&PORTA, pin, 100, 1);
	MOVLW      PORTA+0
	MOVWF      FARG_Button_port+0
	MOVF       FARG_presionBoton_pin+0, 0
	MOVWF      FARG_Button_pin+0
	MOVLW      100
	MOVWF      FARG_Button_time_ms+0
	MOVLW      1
	MOVWF      FARG_Button_active_state+0
	CALL       _Button+0
	MOVF       R0+0, 0
	MOVWF      presionBoton_pulso_L0+0
	CLRF       presionBoton_pulso_L0+1
;sensor.c,169 :: 		}
	GOTO       L_presionBoton38
L_presionBoton39:
;sensor.c,170 :: 		if (oldstate == 1)
	MOVLW      0
	XORWF      presionBoton_oldstate_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__presionBoton51
	MOVLW      1
	XORWF      presionBoton_oldstate_L0+0, 0
L__presionBoton51:
	BTFSS      STATUS+0, 2
	GOTO       L_presionBoton40
;sensor.c,172 :: 		return pin;
	MOVF       FARG_presionBoton_pin+0, 0
	MOVWF      R0+0
	GOTO       L_end_presionBoton
;sensor.c,173 :: 		}
L_presionBoton40:
;sensor.c,176 :: 		return 0;
	CLRF       R0+0
;sensor.c,178 :: 		}
L_end_presionBoton:
	RETURN
; end of _presionBoton
