#line 1 "C:/Users/Mario/Desktop/sensor_temperatura/sensor.c"
unsigned short i, DD0 = 0x40, DD1 = 0x40, N_Flag, valor_manual;
unsigned temp_value = 0;
unsigned short temp_minima = 10;
unsigned short temp_maxima = 99;
unsigned short temp_por_defecto = 20;
unsigned short mask(unsigned short num);
void display_temp(short DD0, short DD1);
void DS18B20();
unsigned short presionBoton(unsigned short pin);
void main()
{
 CMCON |= 7;
 TRISA0_bit = 0;
 TRISA1_bit = 0;
 TRISA2_bit = 0;
 TRISA4_bit = 0;
 TRISB0_bit = 0;
 TRISB1_bit = 0;
 TRISB2_bit = 0;
 TRISB3_bit = 0;
 TRISB4_bit = 0;
 TRISB5_bit = 0;
 TRISB6_bit = 0;
 PORTB = 1;

 temp_por_defecto = EEPROM_Read(0x01);
 valor_manual = temp_por_defecto;
 RA0_bit = 0;
 RA1_bit = 0;
 RA2_bit = 1;
 RA4_bit = 0;
 do
 {
 DD0 = valor_manual % 10;
 DD0 = mask(DD0);
 DD1 = (valor_manual / 10) % 10;
 DD1 = mask(DD1);
 display_temp(DD0, DD1);

 if (presionBoton(3) == 3)
 {
 if (valor_manual < temp_maxima)
 {
 valor_manual++;
 EEPROM_Write(0x01,valor_manual);
 }
 }
 if (presionBoton(6) == 6)
 {
 if (valor_manual >= temp_minima)
 {
 valor_manual--;
 EEPROM_Write(0x01,valor_manual);
 }
 }
 if (presionBoton(7) == 7)
 {
 do
 {
 N_Flag = 0;
 DS18B20();
 DD0 = temp_value % 10;
 DD0 = mask(DD0);
 DD1 = (temp_value / 10) % 10;
 DD1 = mask(DD1);
 display_temp(DD0, DD1);
 if (temp_value >= valor_manual)
 {
 RA2_bit = 1;
 RA4_bit = 0;
 }
 else
 {
 RA2_bit = 0;
 RA4_bit = 1;
 }

 } while (!presionBoton(7));
 RA2_bit = 1;
 RA4_bit = 0;
 }

 } while (1);
}

unsigned short mask(unsigned short num)
{
 switch (num)
 {
 case 0:
 return 0x40;
 case 1:
 return 0x79;
 case 2:
 return 0x24;
 case 3:
 return 0x30;
 case 4:
 return 0x19;
 case 5:
 return 0x12;
 case 6:
 return 0x02;
 case 7:
 return 0x78;
 case 8:
 return 0x00;
 case 9:
 return 0x10;
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
 for (i = 0; i <= 4; i++)
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
 Ow_Reset(&PORTB, 7);
 Ow_Write(&PORTB, 7, 0xCC);
 Ow_Write(&PORTB, 7, 0x44);
 Ow_Reset(&PORTB, 7);
 Ow_Write(&PORTB, 7, 0xCC);
 Ow_Write(&PORTB, 7, 0xBE);

 temp_value = Ow_Read(&PORTB, 7);
 temp_value = (Ow_Read(&PORTB, 7) << 8) + temp_value;


 if (temp_value & 0x8000)
 {
 temp_value = ~temp_value + 1;
 N_Flag = 1;
 }
 if (temp_value & 0x0001)
 temp_value += 1;
 temp_value = temp_value >> 4;

 if (N_Flag == 1)
 {
 temp_value = 0;
 }
 if (temp_value >= 99)
 {
 temp_value = 99;
 }
}
unsigned short presionBoton(unsigned short pin)
{
 int pulso = 0;
 int oldstate = 0;
 pulso = Button(&PORTA, pin, 100, 1);
 if (pulso != 0)
 {
 oldstate = 1;
 }
 while (pulso == 1)
 {
 pulso = Button(&PORTA, pin, 100, 1);
 }
 if (oldstate == 1)
 {
 return pin;
 }
 else
 {
 return 0;
 }
}
