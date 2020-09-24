#line 1 "C:/Users/PC/Desktop/sensor de temperatura/sensor.c"
unsigned short i, DD0 = 0x40, DD1 = 0x40, N_Flag;
unsigned temp_value = 0;
unsigned short mask(unsigned short num);
void display_temp(short DD0, short DD1);
void DS18B20();
void main()
{
 CMCON |= 7;

}
unsigned short mask(unsigned short num)
{
 switch (num)
 {
 case 0:
 return 0xC0;
 case 1:
 return 0xF9;
 case 2:
 return 0xA4;
 case 3:
 return 0xB0;
 case 4:
 return 0x99;
 case 5:
 return 0x92;
 case 6:
 return 0x82;
 case 7:
 return 0xF8;
 case 8:
 return 0x80;
 case 9:
 return 0x90;
 case 10:
 return 0xBF;
 case 11:
 return 0x9E;
 case 12:
 return 0xFF;
 }
}
void display_temp(short DD0, short DD1)
{
 for (i = 0; i <= 2; i++)
 {
 PORTB = DD0;
 RA0_bit = 0;
 RA1_bit = 1;
 delay_ms(2);
 PORTB = DD1;
 RA0_bit = 1;
 RA1_bit = 0;
 delay_ms(2);
 }
 return;
}
void DS18B20()
{
 Ow_Reset(&PORTA, 4);
 Ow_Write(&PORTA, 4, 0xCC);
 Ow_Write(&PORTA, 4, 0x44);
 Ow_Reset(&PORTA, 4);
 Ow_Write(&PORTA, 4, 0xCC);
 Ow_Write(&PORTA, 4, 0xBE);

 temp_value = Ow_Read(&PORTA, 4);
 temp_value = (Ow_Read(&PORTA, 4) << 8) + temp_value;


 if (temp_value & 0x8000)
 {
 temp_value = ~temp_value + 1;
 N_Flag = 1;
 }
 if (temp_value & 0x0001)
 temp_value += 1;
 temp_value = temp_value >> 4;

}
