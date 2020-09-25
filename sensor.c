unsigned short i, DD0 = 0x40, DD1 = 0x40, N_Flag, valor_manual;
unsigned temp_value = 0;
unsigned short temp_minima = 10;       //seteo minimo de temperatura
unsigned short temp_maxima  = 50;      //seteo maximo de temperatura
unsigned short temp_por_defecto = 20;  //temperatura por defecto que se setea al encender el sistema
unsigned short mask(unsigned short num);
void display_temp(short DD0, short DD1);
void DS18B20();
unsigned short presionBoton(unsigned short pin);

void main()
{
    CMCON |= 7;     // Disable Comparators
    TRISA0_bit = 0; // RA.0 to RA3 Output
    TRISA1_bit = 0;
    TRISA2_bit = 0;
    TRISB0_bit = 0;
    TRISB1_bit = 0;
    TRISB2_bit = 0;
    TRISB3_bit = 0;
    TRISB4_bit = 0;
    TRISB5_bit = 0;
    TRISB6_bit = 0;
    PORTB = 1;
    valor_manual = temp_por_defecto;
    //ra3 temp +
    //ra6 temp -
    //ra7 start/stop
    RA0_bit = 0;
    RA1_bit = 0;
    RA2_bit = 1;

    do
    {
        DD0 = valor_manual % 10; // Extract Ones Digit
        DD0 = mask(DD0);
        DD1 = (valor_manual / 10) % 10; // Extract Tens Digit
        DD1 = mask(DD1);
        display_temp(DD0, DD1); // Infinite loop;

        if (presionBoton(3) == 3)        //Si se presiono el boton de temp +
        {
            if (valor_manual <= temp_maxima)          //Si el valor seteado es menor a la temperatura maxima acumule en 1
            {
                valor_manual++;
            }
        }
        if (presionBoton(6) == 6)        //si se presiono el boton de temp -
        {
            if (valor_manual >= temp_minima)           //Si el valor seteado es mayor a la temperatura maxima disminuye en 1
            {
                valor_manual--;
            }
        }
        if (presionBoton(7) == 7)        //si se presiono el boton start
        {
            do
            {
                N_Flag = 0; // Reset Temp Flag
                DS18B20();
                DD0 = temp_value % 10; // Extract Ones Digit
                DD0 = mask(DD0);
                DD1 = (temp_value / 10) % 10; // Extract Tens Digit
                DD1 = mask(DD1);
                display_temp(DD0, DD1); // Infinite loop;
                if (temp_value >= valor_manual)
                {
                    RA2_bit = 0;
                }
                else
                {
                    RA2_bit = 1;
                }

            } while (!presionBoton(7));          //mientras no se presione el boton start
            RA2_bit = 1;
        }

    } while (1);
}

unsigned short mask(unsigned short num) // Mask for 7 segment common anode;
{
    switch (num)
    {
    case 0:
        return 0x40; // 0;
    case 1:
        return 0x79; // 1;
    case 2:
        return 0x24; // 2;
    case 3:
        return 0x30; // 3;
    case 4:
        return 0x19; // 4;
    case 5:
        return 0x12; // 5;
    case 6:
        return 0x02; // 6;
    case 7:
        return 0x78; // 7;
    case 8:
        return 0x00; // 8;
    case 9:
        return 0x10; // 9;
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
    for (i = 0; i <= 4; i++)
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
    if (N_Flag == 1)                 //verifico que el valor de temperatura es negativo
    {
        temp_value = 0;              //seteo la temperatura en 0 grados
    }
    if (temp_value >= 99)            //verifico que el valor de temperatura es mayor a 99
    {
        temp_value = 99;             // seteo la temperatura en 99 grados
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