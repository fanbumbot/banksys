#define CAL_MAX 25//number of digits of the calculator (15-25)

//------------------------------------------------------------------------------
//the correctness of the number

//cal_con(cal_cisin[]);

//parameters:
//cal_cisin[] (input) - string containing a number (recommended size - 32 char)

//returned values:
//integer data type:
//0 - the number is incorrect
//1 - the number is correct
//------------------------------------------------------------------------------
//the operation of addition of numbers

//cal_add(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode);

//parameters:
//cal_cisin1[] (input) - string containing a first summand (recommended size - 32 char)
//cal_cisin2[] (input) - string containing a second summand (recommended size - 32 char)
//cal_cisin3[] (output) - string containing a summ (recommended size - 40 char)
//cal_cmode (input) - 0 - simple output string value, 1 - formated output string value

//returned values:
//integer data type:
//0 - overflow during addition
//1 - function has completed successful
//2 - incorrect first summand
//3 - incorrect second summand
//------------------------------------------------------------------------------
//the operation of substraction of numbers

//cal_sub(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode);

//parameters:
//cal_cisin1[] (input) - string containing a minuend (recommended size - 32 char)
//cal_cisin2[] (input) - string containing a subtrahend (recommended size - 32 char)
//cal_cisin3[] (output) - string containing a difference (recommended size - 40 char)
//cal_cmode (input) - 0 - simple output string value, 1 - formated output string value

//returned values:
//integer data type:
//0 - overflow during substraction
//1 - function has completed successful
//2 - incorrect minuend
//3 - incorrect subtrahend
//------------------------------------------------------------------------------
//the operation of multiplication of numbers

//cal_mul(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode);

//parameters:
//cal_cisin1[] (input) - string containing a first multiplier (recommended size - 32 char)
//cal_cisin2[] (input) - string containing a second multiplier (recommended size - 32 char)
//cal_cisin3[] (output) - string containing a multiplication (recommended size - 40 char)
//cal_cmode (input) - 0 - simple output string value, 1 - formated output string value

//returned values:
//integer data type:
//0 - overflow during multiplication
//1 - function has completed successful
//2 - incorrect first multiplier
//3 - incorrect second multiplier
//------------------------------------------------------------------------------
//the operation of division of numbers

//cal_div(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode);

//parameters:
//cal_cisin1[] (input) - string containing a dividend (recommended size - 32 char)
//cal_cisin2[] (input) - string containing a divisor (recommended size - 32 char)
//cal_cisin3[] (output) - string containing a quotient (recommended size - 40 char)
//cal_cmode (input) - 0 - simple output string value, 1 - formated output string value

//returned values:
//integer data type:
//0 - error of overflow
//1 - function has completed successful
//2 - incorrect dividend
//3 - incorrect divisor
//4 - error of division by zero
//------------------------------------------------------------------------------
//compare of two numbers

//cal_cmp(cal_cisin1[], cal_cisin2[]);

//parameters:
//cal_cisin1[] (input) - string containing a first number in compare (recommended size - 32 char)
//cal_cisin2[] (input) - string containing a second number in compare (recommended size - 32 char)

//returned values:
//integer data type:
//0 - the numbers are equal
//1 - fisrt number > second number
//2 - fisrt number < second number
//------------------------------------------------------------------------------
//translate simple string value to formated string value

//cal_pf(cal_cisin1[], cal_cisout2[]);

//parameters:
//cal_cisin1[] (input) - string containing a simple string value (recommended size - 32 char)
//cal_cisout2[] (output) - string containing a formated string value (recommended size - 40 char)

//returned values:
//integer data type:
//0 - incorrect input string value
//1 - function has completed successful
//------------------------------------------------------------------------------
//translate formated string value to simple string value

//cal_pp(cal_cisin1[], cal_cisout2[]);

//parameters:
//cal_cisin1[] (input) - string containing a formated string value (recommended size - 40 char)
//cal_cisout2[] (output) - string containing a simple string value (recommended size - 32 char)

//returned values:
//integer data type:
//0 - incorrect input string value
//1 - function has completed successful
//------------------------------------------------------------------------------

#if (CAL_MAX < 15)
    #undef CAL_MAX
    #define CAL_MAX 15
#endif
#if (CAL_MAX > 25)
    #undef CAL_MAX
    #define CAL_MAX 25
#endif

new cal_rgd[40][32];

//base function
stock cal_con(cal_cisin[])//the correctness of the number
{
    new cal_ldata = strlen(cal_cisin);
    if(cal_ldata == 0) { return 0; }
    if(cal_cisin[0] == '-' && cal_ldata == 1) { return 0; }
    if(cal_cisin[0] != '-' && cal_ldata > CAL_MAX) { return 0; }
    if(cal_cisin[0] == '-' && cal_ldata > (CAL_MAX + 1)) { return 0; }
    new cal_ind = 0;
    if(cal_cisin[0] == '-')
    {
        cal_ind++;
    }
    while(cal_ind < cal_ldata)
    {
        if(cal_cisin[cal_ind] < 48 || cal_cisin[cal_ind] > 57) { return 0; }
        cal_ind++;
    }
    return 1;
}

//base function
stock cal_add(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode)//operation of addition
{
    strdel(cal_cisout3, 0, 40);
    new cal_cdata;
    cal_cdata = cald_setreg(cal_cisin1, 0);
    if(cal_cdata == 0)
    {
        return 2;
    }
    cal_cdata = cald_setreg(cal_cisin2, 1);
    if(cal_cdata == 0)
    {
        return 3;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 0)
    {
        cal_cdata = cald_add(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
//------------------------------------------------------------------------------
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 0 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_sub(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_sub(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_add(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
//------------------------------------------------------------------------------
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 0 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_sub(1, 0, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_sub(1, 0, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_add(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    return 0;
}

//base function
stock cal_sub(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode)//operation of substraction
{
    strdel(cal_cisout3, 0, 40);
    new cal_cdata;
    cal_cdata = cald_setreg(cal_cisin1, 0);
    if(cal_cdata == 0)
    {
        return 2;
    }
    cal_cdata = cald_setreg(cal_cisin2, 1);
    if(cal_cdata == 0)
    {
        return 3;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 0 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_sub(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 0 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_sub(1, 0, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
//------------------------------------------------------------------------------
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 0 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_add(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_add(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) != 2)
    {
        cal_cdata = cald_sub(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
//------------------------------------------------------------------------------
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 0 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_add(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 0 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_add(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if(cal_rgd[0][0] == 1 && cal_rgd[1][0] == 1 && cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cal_cdata = cald_sub(1, 0, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    return 0;
}

//base function
stock cal_mul(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode)//operation of multiplication
{
    strdel(cal_cisout3, 0, 40);
    new cal_cdata;
    cal_cdata = cald_setreg(cal_cisin1, 0);
    if(cal_cdata == 0)
    {
        return 2;
    }
    cal_cdata = cald_setreg(cal_cisin2, 1);
    if(cal_cdata == 0)
    {
        return 3;
    }
    if(cald_cmpmod(cal_cisin1, "0") == 0 || cald_cmpmod(cal_cisin2, "0") == 0)
    {
        cald_setreg("0", 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return 1;
    }
    if((cal_rgd[0][0] == 0 && cal_rgd[1][0] == 0) ||
    (cal_rgd[0][0] == 1 && cal_rgd[1][0] == 1))
    {
        cal_cdata = cald_mul(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if((cal_rgd[0][0] == 1 && cal_rgd[1][0] == 0) ||
    (cal_rgd[0][0] == 0 && cal_rgd[1][0] == 1))
    {
        cal_cdata = cald_mul(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    return 0;
}

//base function
stock cal_div(cal_cisin1[], cal_cisin2[], cal_cisout3[], cal_cmode)//operation of division
{
    strdel(cal_cisout3, 0, 40);
    new cal_cdata;
    cal_cdata = cald_setreg(cal_cisin1, 0);
    if(cal_cdata == 0)
    {
        return 2;
    }
    cal_cdata = cald_setreg(cal_cisin2, 1);
    if(cal_cdata == 0)
    {
        return 3;
    }
    if(cald_cmpmod(cal_cisin2, "0") == 0)
    {
        return 4;
    }
    if(cald_cmpmod(cal_cisin1, "0") == 0)
    {
        cald_setreg("0", 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return 1;
    }
    if(cald_cmpmod(cal_cisin1, cal_cisin2) == 2)
    {
        cald_setreg("0", 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return 1;
    }
    if((cal_rgd[0][0] == 0 && cal_rgd[1][0] == 0) ||
    (cal_rgd[0][0] == 1 && cal_rgd[1][0] == 1))
    {
        cal_cdata = cald_div(0, 1, 2);
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    if((cal_rgd[0][0] == 1 && cal_rgd[1][0] == 0) ||
    (cal_rgd[0][0] == 0 && cal_rgd[1][0] == 1))
    {
        cal_cdata = cald_div(0, 1, 2);
        cal_rgd[2][0] = 1;
        strcat(cal_cisout3, cald_getreg(2, cal_cmode), 40);
        return cal_cdata;
    }
    return 0;
}

//base function
stock cal_cmp(cal_cisin1[], cal_cisin2[])//compare of two numbers
{
    cald_setreg(cal_cisin1, 37);
    cald_setreg(cal_cisin2, 38);
    if(cal_rgd[37][0] != cal_rgd[38][0])
    {
        if(cal_rgd[37][0] < cal_rgd[38][0])
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else
    {
        new cal_ind = 1;
        if(cal_rgd[37][0] == 0)
        {
            while(cal_ind <= CAL_MAX)
            {
                if(cal_rgd[37][cal_ind] > cal_rgd[38][cal_ind])
                {
                    return 1;
                }
                if(cal_rgd[37][cal_ind] < cal_rgd[38][cal_ind])
                {
                    return 2;
                }
                cal_ind++;
            }
        }
        else
        {
            while(cal_ind <= CAL_MAX)
            {
                if(cal_rgd[37][cal_ind] > cal_rgd[38][cal_ind])
                {
                    return 2;
                }
                if(cal_rgd[37][cal_ind] < cal_rgd[38][cal_ind])
                {
                    return 1;
                }
                cal_ind++;
            }
        }
        return 0;
    }
}

//base function
stock cal_pf(cal_cisin1[], cal_cisout2[])//translate simple string value to formated string value
{
    new cal_cdata = cal_con(cal_cisin1);
    if(cal_cdata == 0)
    {
        return 0;
    }
    strdel(cal_cisout2, 0, 40);
    strcat(cal_cisout2, cal_cisin1, 40);
    new cal_ind, cal_nul;
    cal_ind = strlen(cal_cisout2);
    if(cal_cisout2[0] != '-')
    {
        cal_nul = 0;
    }
    else
    {
        cal_nul = 1;
        strmid(cal_cisout2, cal_cisout2, 1, cal_ind, 40);
        cal_ind--;
    }
    cal_ind = cal_ind - 3;
    while(cal_ind > 0)
    {
        strins(cal_cisout2, "'", cal_ind, 40);
        cal_ind = cal_ind - 3;
    }
    if(cal_nul == 1)
    {
        strins(cal_cisout2, "-", 0, 40);
    }
    return 1;
}

//base function
stock cal_pp(cal_cisin1[], cal_cisout2[])//translate formated string value to simple string value
{
    new cal_ldata = strlen(cal_cisin1);
    if(cal_ldata == 0) { return 0; }
    if(cal_cisin1[0] == '-' && cal_ldata == 1) { return 0; }
    if(cal_ldata > 39) { return 0; }
    new cal_ind = 0;
    if(cal_cisin1[0] == '-')
    {
        cal_ind++;
    }
    while(cal_ind < cal_ldata)
    {
        if((cal_cisin1[cal_ind] < 48 || cal_cisin1[cal_ind] > 57) &&
        cal_cisin1[cal_ind] != 39) { return 0; }
        cal_ind++;
    }
    strdel(cal_cisout2, 0, 32);
    cal_ind = 0;
    for(new i = 0; i < cal_ldata; i++)
    {
        if(cal_cisin1[i] != 39)
        {
            cal_cisout2[cal_ind] = cal_cisin1[i];
            cal_ind++;
        }
    }
    cal_cisout2[cal_ind] = 0;
    return 1;
}

stock cald_cmpmod(cal_cisin1[], cal_cisin2[])
{
    cald_setreg(cal_cisin1, 37);
    cald_setreg(cal_cisin2, 38);
    new cal_ind = 1;
    while(cal_ind <= CAL_MAX)
    {
        if(cal_rgd[37][cal_ind] > cal_rgd[38][cal_ind])
        {
            return 1;
        }
        if(cal_rgd[37][cal_ind] < cal_rgd[38][cal_ind])
        {
            return 2;
        }
        cal_ind++;
    }
    return 0;
}

stock cald_cmpreg(cal_reg1, cal_reg2)
{
    new cal_ind = 1;
    while(cal_ind <= CAL_MAX)
    {
        if(cal_rgd[cal_reg1][cal_ind] > cal_rgd[cal_reg2][cal_ind])
        {
            return 1;
        }
        if(cal_rgd[cal_reg1][cal_ind] < cal_rgd[cal_reg2][cal_ind])
        {
            return 2;
        }
        cal_ind++;
    }
    return 0;
}

stock cald_add(cal_reg1, cal_reg2, cal_reg3)
{
    cald_clr(36);
    new cal_pdata = 0;
    for(new i = CAL_MAX; i >= 1; i--)
    {
        cal_pdata = cal_rgd[cal_reg1][i] + cal_rgd[cal_reg2][i] + cal_pdata;
        if(cal_pdata > 9)
        {
            cal_rgd[36][i] = cal_pdata - 10;
            cal_pdata = 1;
        }
        else
        {
            cal_rgd[36][i] = cal_pdata;
            cal_pdata = 0;
        }
    }
    cald_mov(36, cal_reg3);
    if(cal_pdata == 1)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

stock cald_sub(cal_reg1, cal_reg2, cal_reg3)
{
    cald_inv(cal_reg1, cal_reg1);
    new cal_cdata = cald_add(cal_reg1, cal_reg2, cal_reg3);
    cald_inv(cal_reg3, cal_reg3);
    return cal_cdata;
}

stock cald_mul(cal_reg1, cal_reg2, cal_reg3)
{
    cald_clr(cal_reg3);
    new cal_cdata;
    new cal_cdata1 = 0;
    new cal_cdata2 = 0;
    new cal_ddata = CAL_MAX;
    while(cal_ddata >= 1)
    {
        if(cal_rgd[cal_reg1][cal_ddata] != 0)
        {
            break;
        }
        else
        {
            cal_cdata1++;
        }
        cal_ddata--;
    }
    cald_rotr(cal_reg1, 3, cal_cdata1);
    cal_ddata = CAL_MAX;
    while(cal_ddata >= 1)
    {
        if(cal_rgd[cal_reg2][cal_ddata] != 0)
        {
            break;
        }
        else
        {
            cal_cdata2++;
        }
        cal_ddata--;
    }
    cald_rotr(cal_reg2, 4, cal_cdata2);
    cal_cdata = cal_cdata1 + cal_cdata2;
    new cal_cdata10 = 0;
    new cal_ind = 1;
    while(cal_ind <= CAL_MAX)
    {
        if(cal_rgd[cal_reg2][cal_ind] != 0) { break; }
        cal_cdata10++;
        cal_ind++;
    }
    cal_cdata10 = CAL_MAX - cal_cdata10;
    cald_clr(6);
    new cal_cdata33;
    new cal_ddata2 = 1;
    while(cal_ddata2 <= CAL_MAX)
    {
        if(cal_cdata10 > 0)
        {
            if(cal_rgd[4][CAL_MAX] != 0)
            {
                cald_clr(5);
                cal_ddata = 0;
                while(cal_ddata < cal_rgd[4][CAL_MAX])
                {
                    cal_cdata33 = cald_add(3, 5, 5);
                    if(cal_cdata33 == 0) { return 0; }
                    cal_ddata++;
                }
                cal_cdata33 = cald_rotl(5, 5, cal_ddata2 - 1);
                if(cal_cdata33 == 0) { return 0; }
                cal_cdata33 = cald_add(5, 6, 6);
                if(cal_cdata33 == 0) { return 0; }
            }
            cald_rotr(4, 4, 1);
            cal_cdata10--;
        }
        else
        {
            break;
        }
        cal_ddata2++;
    }
    cal_cdata33 = cald_rotl(6, 6, cal_cdata);
    if(cal_cdata33 == 0) { return 0; }
    cald_mov(6, cal_reg3);
    return 1;
}

stock cald_div(cal_reg1, cal_reg2, cal_reg3)
{
    cald_clr(cal_reg3);
    new cal_cdata = 0;
    new cal_ind = 1;
    while(cal_ind <= CAL_MAX)
    {
        if(cal_rgd[cal_reg1][cal_ind] != 0) { break; }
        cal_cdata++;
        cal_ind++;
    }
    cald_clr(7);
    cald_clr(10);
    new cal_cdata3 = 0;
    new cal_cdata33;
    cal_ind = cal_cdata + 1;
    while(cal_ind <= CAL_MAX)
    {
        cal_rgd[7][CAL_MAX] = cal_rgd[cal_reg1][cal_ind];
        if(cald_cmpreg(7, cal_reg2) != 2)
        {
            cal_cdata3 = 1;
            new cal_cdata2 = 0;
            cald_clr(8);
            cald_clr(9);
            new cal_ind2 = 1;
            while(cal_ind2 <= 10)
            {
                cald_mov(9, 8);
                cal_cdata33 = cald_add(cal_reg2, 9, 9);
                cal_cdata2++;
                if(cal_cdata33 == 0 || cald_cmpreg(9, 7) == 1)
                {
                    cal_cdata2--;
                    break;
                }
                cal_ind2++;
            }
            cald_sub(7, 8, 7);
            cal_cdata33 = cald_rotl(7, 7, 1);
            if(cal_cdata33 == 0) { return 0; }
            cal_rgd[10][CAL_MAX] = cal_cdata2;
            cal_cdata33 = cald_rotl(10, 10, 1);
            if(cal_cdata33 == 0) { return 0; }
        }
        else
        {
            cal_cdata33 = cald_rotl(7, 7, 1);
            if(cal_cdata33 == 0) { return 0; }
            if(cal_cdata3 == 1)
            {
                cal_rgd[10][CAL_MAX] = 0;
                cal_cdata33 = cald_rotl(10, 10, 1);
                if(cal_cdata33 == 0) { return 0; }
            }
        }
        cal_ind++;
    }
    cald_rotr(10, 10, 1);
    cald_mov(10, cal_reg3);
    return 1;
}

stock cald_inv(cal_reg1, cal_reg2)
{
    for(new i = 1; i <= CAL_MAX; i++)
    {
        if(cal_rgd[cal_reg1][i] == 0) { cal_rgd[39][i] = 9; }
        if(cal_rgd[cal_reg1][i] == 1) { cal_rgd[39][i] = 8; }
        if(cal_rgd[cal_reg1][i] == 2) { cal_rgd[39][i] = 7; }
        if(cal_rgd[cal_reg1][i] == 3) { cal_rgd[39][i] = 6; }
        if(cal_rgd[cal_reg1][i] == 4) { cal_rgd[39][i] = 5; }
        if(cal_rgd[cal_reg1][i] == 5) { cal_rgd[39][i] = 4; }
        if(cal_rgd[cal_reg1][i] == 6) { cal_rgd[39][i] = 3; }
        if(cal_rgd[cal_reg1][i] == 7) { cal_rgd[39][i] = 2; }
        if(cal_rgd[cal_reg1][i] == 8) { cal_rgd[39][i] = 1; }
        if(cal_rgd[cal_reg1][i] == 9) { cal_rgd[39][i] = 0; }
    }
    cald_mov(39, cal_reg2);
    return 1;
}

stock cald_mov(cal_reg1, cal_reg2)
{
    cal_rgd[cal_reg2][0] = 0;
    for(new i = 1; i <= CAL_MAX; i++)
    {
        cal_rgd[cal_reg2][i] = cal_rgd[cal_reg1][i];
    }
    return 1;
}

stock cald_rotr(cal_reg1, cal_reg2, cal_rot)
{
    cald_mov(cal_reg1, 35);
    for(new j = 0; j < cal_rot; j++)
    {
        for(new i = (CAL_MAX - 1); i >= 1; i--)
        {
            cal_rgd[35][i + 1] = cal_rgd[35][i];
        }
        cal_rgd[35][1] = 0;
    }
    cald_mov(35, cal_reg2);
    return 1;
}

stock cald_rotl(cal_reg1, cal_reg2, cal_rot)
{
    cald_mov(cal_reg1, 34);
    new cal_ddata = 0;
    while(cal_ddata < cal_rot)
    {
        if(cal_rgd[34][1] != 0)
        {
            return 0;
        }
        for(new i = 1; i < CAL_MAX; i++)
        {
            cal_rgd[34][i] = cal_rgd[34][i + 1];
        }
        cal_rgd[34][CAL_MAX] = 0;
        cal_ddata++;
    }
    cald_mov(34, cal_reg2);
    return 1;
}

stock cald_clr(cal_reg)
{
    for(new i = 0; i < 32; i++)
    {
        cal_rgd[cal_reg][i] = 0;
    }
    cal_rgd[cal_reg][0] = 0;
    return 1;
}

stock cald_setreg(cal_cisin[], cal_reg)
{
    new cal_cdata = cal_con(cal_cisin);
    if(cal_cdata == 0)
    {
        return 0;
    }
    new cal_ldata = strlen(cal_cisin);
    new cal_ind = 1;
    if(cal_cisin[0] != '-')
    {
        cal_ind = 0;
    }
    cal_ldata--;
    for(new i = CAL_MAX; i > 0; i--)
    {
        if((cal_ldata >= 0 && cal_ind == 0) ||
        (cal_ldata >= 1 && cal_ind == 1))
        {
            cal_rgd[cal_reg][i] = cal_cisin[cal_ldata] - 48;
        }
        else
        {
            cal_rgd[cal_reg][i] = 0;
        }
        cal_ldata--;
    }
    cal_rgd[cal_reg][0] = cal_ind;
    if(strlen(cal_cisin) == 2 && cal_cisin[0] == '-' && cal_cisin[1] == '0')
    {
        cal_rgd[cal_reg][0] = 0;
    }
    return 1;
}

stock cald_getreg(cal_reg, cal_cismode)
{
    new cal_cisout[40];
    strdel(cal_cisout, 0, 40);
    new cal_ind, cal_nul;
    if(cal_rgd[cal_reg][0] == 0)
    {
        cal_ind = 0;
    }
    else
    {
        cal_cisout[0] = '-';
        cal_ind = 1;
    }
    cal_nul = 0;
    for(new i = 1; i <= CAL_MAX; i++)
    {
        if(cal_nul == 1)
        {
            cal_cisout[cal_ind] = cal_rgd[cal_reg][i] + 48;
            cal_ind++;
        }
        if(cal_rgd[cal_reg][i] != 0 && cal_nul == 0)
        {
            cal_nul = 1;
            cal_cisout[cal_ind] = cal_rgd[cal_reg][i] + 48;
            cal_ind++;
        }
    }
    if(cal_nul == 0)
    {
        cal_cisout[0] = '0';
        return cal_cisout;
    }
    if(cal_cismode == 0)
    {
        return cal_cisout;
    }
    else
    {
        cal_ind = strlen(cal_cisout);
        if(cal_cisout[0] != '-')
        {
            cal_nul = 0;
        }
        else
        {
            cal_nul = 1;
            strmid(cal_cisout, cal_cisout, 1, cal_ind);
            cal_ind--;
        }
        cal_ind = cal_ind - 3;
        while(cal_ind > 0)
        {
            strins(cal_cisout, "'", cal_ind);
            cal_ind = cal_ind - 3;
        }
        if(cal_nul == 1)
        {
            strins(cal_cisout, "-", 0);
        }
        return cal_cisout;
    }
}

