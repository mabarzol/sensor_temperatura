unsigned short i, DD0 = 0x40, DD1 = 0x40, N_Flag;
unsigned temp_value = 0;
unsigned short mask(unsigned short num);
void display_temp(short DD0, short DD1);
void DS18B20();
void main()
{
 CMCON  |= 7;                               // Disable Comparators
 
}
unsigned short mask(unsigned short num) // Mask for 7 segment common anode;
{
    switch (num)
    {
    case 0:
        return 0xC0; // 0;
    case 1:
        return 0xF9; // 1;
    case 2:
        return 0xA4; // 2;
    case 3:
        return 0xB0; // 3;
    case 4:
        return 0x99; // 4;
    case 5:
        return 0x92; // 5;
    case 6:
        return 0x82; // 6;
    case 7:
        return 0xF8; // 7;
    case 8:
        return 0x80; // 8;
    case 9:
        return 0x90; // 9;
    case 10:
        return 0xBF; // Symbol '-'
    case 11:
        return 0x9E; // Symbol C
    case 12:
        return 0xFF; // Blank
    }                //case end
}
void display_temp(short DD0, short DD1)
{
    for (i = 0; i <= 2; i++)
    {
        PORTB = DD0;
        RA0_bit = 0;
        RA1_bit = 1; // Select Ones Digit;
        delay_ms(2);
        PORTB = DD1;
        RA0_bit = 1;
        RA1_bit = 0;
        delay_ms(2);
    }
    return;
}
void DS18B20() //Perform temperature reading
{
    Ow_Reset(&PORTA, 4);       // Onewire reset signal
    Ow_Write(&PORTA, 4, 0xCC); // Issue command SKIP_ROM
    Ow_Write(&PORTA, 4, 0x44); // Issue command CONVERT_T
    Ow_Reset(&PORTA, 4);
    Ow_Write(&PORTA, 4, 0xCC); // Issue command SKIP_ROM
    Ow_Write(&PORTA, 4, 0xBE); // Issue command READ_SCRATCHPAD
    // Next Read Temperature
    temp_value = Ow_Read(&PORTA, 4);                     // Read Byte 0 from Scratchpad
    temp_value = (Ow_Read(&PORTA, 4) << 8) + temp_value; // Then read Byte 1 from
                                                         // Scratchpad and shift
                                                         // 8 bit left and add the Byte 0
    if (temp_value & 0x8000)
    {
        temp_value = ~temp_value + 1;
        N_Flag = 1; // Temp is -ive
    }
    if (temp_value & 0x0001)
        temp_value += 1;          // 0.5 round to 1
    temp_value = temp_value >> 4; //<<<  // 1 for DS1820 and
                                  // 4 for DS18B20;
}
