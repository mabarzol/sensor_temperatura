unsigned short i, DD0 = 0x40, DD1 = 0x40, N_Flag, valor_manual;
unsigned temp_value = 0;
unsigned short temp_minima = 10;      //seteo minimo de temperatura
unsigned short temp_maxima = 99;      //seteo maximo de temperatura
unsigned short temp_por_defecto = 20; //temperatura por defecto que se setea al encender el sistema leida del eeprom del pic
unsigned short mask(unsigned short num);
void display_temp(short DD0, short DD1);
void DS18B20();
unsigned short presionBoton(unsigned short pin);
void main()
{
    CMCON |= 7;     // Disable Comparators
    TRISA0_bit = 0; // RA.0 to RA.2 Output, RA.4 Output
    TRISA1_bit = 0; // RB.0 to RB.6 Output
    TRISA2_bit = 0; // RA.5 Resetn Only
    TRISA4_bit = 0; // RA.3 Input temp +
    TRISB0_bit = 0; // RA.6 Input temp -
    TRISB1_bit = 0; // RA.7 Input start/stop
    TRISB2_bit = 0; //**********************************************//
    TRISB3_bit = 0;
    TRISB4_bit = 0;
    TRISB5_bit = 0;
    TRISB6_bit = 0;
    PORTB = 1;
    //EEPROM_Write(0x01,20);
    temp_por_defecto = EEPROM_Read(0x01);  //lee el valor de la temperatura seteada que se almacena en la eeprom
    valor_manual = temp_por_defecto;
    RA0_bit = 0;  //LOGICA POSITIVA
    RA1_bit = 0;  //LOGICA POSITIVA
    RA2_bit = 1;  //LOGICA NEGATIVA
    RA4_bit = 0;  //LOGICA POSITIVA
    do
    {
        DD0 = valor_manual % 10; // Extract One Digit
        DD0 = mask(DD0);
        DD1 = (valor_manual / 10) % 10; // Extract Tens Digit
        DD1 = mask(DD1);
        display_temp(DD0, DD1);

        if (presionBoton(3) == 3) //Si se presiono el boton de temp +
        {
            if (valor_manual < temp_maxima) //Si el valor seteado es menor a la temperatura maxima acumule en 1
            {
                valor_manual++;
                EEPROM_Write(0x01,valor_manual);
            }
        }
        if (presionBoton(6) == 6) //si se presiono el boton de temp -
        {
            if (valor_manual >= temp_minima) //Si el valor seteado es mayor a la temperatura maxima disminuye en 1
            {
                valor_manual--;
                EEPROM_Write(0x01,valor_manual);
            }
        }
        if (presionBoton(7) == 7) //si se presiono el boton start
        {
            do
            {
                N_Flag = 0; // Reset Temp Flag
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

            } while (!presionBoton(7)); //Mientras no se presione el boton start
            RA2_bit = 1;       //LOGICA NEGATIVA
            RA4_bit = 0;       //LOGICA POSITIVA
        }

    } while (1);
}

unsigned short mask(unsigned short num) // Mask for 7 segment Common Anode;
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
{                              //PIN DE LECTURAR OWWIRE ES RB7 EN PORTB
    Ow_Reset(&PORTB, 7);       // Onewire reset signal
    Ow_Write(&PORTB, 7, 0xCC); // Issue command SKIP_ROM
    Ow_Write(&PORTB, 7, 0x44); // Issue command CONVERT_T
    Ow_Reset(&PORTB, 7);
    Ow_Write(&PORTB, 7, 0xCC); // Issue command SKIP_ROM
    Ow_Write(&PORTB, 7, 0xBE); // Issue command READ_SCRATCHPAD
    // Next Read Temperature
    temp_value = Ow_Read(&PORTB, 7);                     // Read Byte 0 from Scratchpad
    temp_value = (Ow_Read(&PORTB, 7) << 8) + temp_value; // Then read Byte 1 from
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
    if (N_Flag == 1)              //Verifico que el valor de temperatura es negativo
    {
        temp_value = 0; //Seteo la temperatura en 0 grados
    }
    if (temp_value >= 99) //Verifico que el valor de temperatura es mayor a 99
    {
        temp_value = 99; //Seteo la temperatura en 99 grados
    }
}
unsigned short presionBoton(unsigned short pin) //Verifica si se presiona o suelta el boton
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