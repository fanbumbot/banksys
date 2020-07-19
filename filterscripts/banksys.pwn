#include <a_samp>
#include <streamer>
#include <Longcalc>
#include <MXini>

#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_GREEN 0x00FF00FF
#define COLOR_RED 0xFF0000FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_BIR 0x00FFFFFF

new Text3D:fantxt;
new onesectimer;
new Pic2[8];
new Text3D:Tex2[8];
new Float:CorX[8] = {2141.40, 2141.40, 2141.40, 2141.40, 2146.96, 2146.96, 2146.96, 2146.96};
new Float:CorY[8] = {1629.34, 1633.28, 1637.19, 1641.13, 1641.13, 1637.19, 1633.28, 1629.34};
new Float:CorZ[8] = {993.57, 993.57, 993.57, 993.57, 993.57, 993.57, 993.57, 993.57};
new RealName[MAX_PLAYERS][MAX_PLAYER_NAME];
new spawplay[MAX_PLAYERS];
new bankplay[MAX_PLAYERS];
new perop[MAX_PLAYERS];
new logplay[MAX_PLAYERS];
new dopcouplay[MAX_PLAYERS];
new Bname[8][64];
new Bpass[8][32];
new Bpass22[8][32];
new Bpasscou[8];
new Bmoney[8][32];

public OnFilterScriptInit()
{
	print(" ");
	print("----------------------------------");
	print("            bank system            ");
	print("----------------------------------\n");

	fantxt = Create3DTextLabel(" ",0xFFFFFFAA,0.000,0.000,-4.000,18.0,0,1);

	new pname[MAX_PLAYER_NAME];
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerName(i, pname, sizeof(pname));
			strdel(RealName[i], 0, MAX_PLAYER_NAME);
			new aa333[64];
			format(aa333, sizeof(aa333), "%s", pname);
			strcat(RealName[i], aa333);
			spawplay[i] = 1;
			bankplay[i] = 0;
			perop[i] = -100;
			logplay[i] = 0;
			dopcouplay[i] = 0;
			Bpasscou[i] = 0;
		}
	}
	onesectimer = SetTimer("OneSec", 1207, 1);

	CreateDynamicObject(2332, 2140.62207, 1629.31934, 993.77649,   0.00000, 0.00000, 90.00000, 0, 1);
	CreateDynamicObject(2332, 2140.62207, 1633.24390, 993.77649,   0.00000, 0.00000, 90.00000, 0, 1);
	CreateDynamicObject(2332, 2140.62207, 1637.17957, 993.77649,   0.00000, 0.00000, 90.00000, 0, 1);
	CreateDynamicObject(2332, 2140.62207, 1641.10144, 993.77649,   0.00000, 0.00000, 90.00000, 0, 1);
	CreateDynamicObject(2332, 2147.75244, 1641.11963, 993.77649,   0.00000, 0.00000, -90.00000, 0, 1);
	CreateDynamicObject(2332, 2147.75244, 1637.20032, 993.77649,   0.00000, 0.00000, -90.00000, 0, 1);
	CreateDynamicObject(2332, 2147.75244, 1633.26672, 993.77649,   0.00000, 0.00000, -90.00000, 0, 1);
	CreateDynamicObject(2332, 2147.75244, 1629.32434, 993.77649,   0.00000, 0.00000, -90.00000, 0, 1);

	for(new i = 0; i < 8; i++)
	{
		Pic2[i] = CreateDynamicPickup(1274, 1, CorX[i], CorY[i], CorZ[i], 0, 1, -1, 100.0);
		Tex2[i] = CreateDynamic3DTextLabel("no", 0x00FF00FF, CorX[i], CorY[i], CorZ[i]+1.5, 50.0,
		INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 1);
	}

	LoadBankSystem();
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(onesectimer);
	for(new i = 0; i < 8; i++)
	{
		DestroyDynamic3DTextLabel(Tex2[i]);
	}
	for(new i = 0; i < 8; i++)
	{
		DestroyDynamicPickup(Pic2[i]);
	}
	Delete3DTextLabel(fantxt);
	return 1;
}

public OnPlayerConnect(playerid)
{
	new pname[MAX_PLAYER_NAME];
	GetPlayerName(playerid, pname, sizeof(pname));
	strdel(RealName[playerid], 0, MAX_PLAYER_NAME);
	new aa333[64];
	format(aa333, sizeof(aa333), "%s", pname);
	strcat(RealName[playerid], aa333);
	spawplay[playerid] = 0;
	bankplay[playerid] = 0;
	perop[playerid] = -100;
	logplay[playerid] = 0;
	dopcouplay[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	dopcouplay[playerid] = 0;
	logplay[playerid] = 0;
	perop[playerid] = -100;
	bankplay[playerid] = 0;
	return 1;
}

public OnPlayerSpawn(playerid)
{
	spawplay[playerid] = 1;
	return 1;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[30];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new idx;
	idx = 0;
	new string[256];
	new cmd[256];
	new tmp[256];
	cmd = strtok(cmdtext, idx);
	if(strcmp(cmd, "/bankhelp", true) == 0)
	{
		SendClientMessage(playerid, COLOR_BIR, " ------------------------------- Bank system commands -------------------------------");
		SendClientMessage(playerid, COLOR_BIR, "         For players:");
		SendClientMessage(playerid, COLOR_BIR, " /bankhelp - bank system help");
		SendClientMessage(playerid, COLOR_BIR, " /bankreg - bank account registration");
		SendClientMessage(playerid, COLOR_BIR, " /banklog - connection (logging) to the bank account");
		SendClientMessage(playerid, COLOR_BIR, " /bankchan - change password of the bank account");
		SendClientMessage(playerid, COLOR_BIR, " /bankdown - put money to the bank account");
		SendClientMessage(playerid, COLOR_BIR, " /bankget - get money from the bank account");
		if(IsPlayerAdmin(playerid))
		{
			SendClientMessage(playerid, COLOR_BIR, "         For RCON-admin:");
			SendClientMessage(playerid, COLOR_BIR, " /banklink - link bank account to the player");
			SendClientMessage(playerid, COLOR_BIR, " /bankunlink - unlink bank account from the player");
			SendClientMessage(playerid, COLOR_BIR, " /bankclear - temporary cleaning(removing) bank accounts registration");
			SendClientMessage(playerid, COLOR_BIR, " /bankname - change the player's nickname on the bank account");
			SendClientMessage(playerid, COLOR_BIR, " /bankpass - check/change player's password on the bank account");
			SendClientMessage(playerid, COLOR_BIR, " /bankmon - add/get amount from the bank account");
			SendClientMessage(playerid, COLOR_BIR, " /banksmon - set amount of money on the bank account");
			SendClientMessage(playerid, COLOR_BIR, " /bankrecr - recreate the bank account");
			SendClientMessage(playerid, COLOR_BIR, " /bankform - formatting all bank accounts");
			SendClientMessage(playerid, COLOR_RED, "                  ( use ONLY in extreme cases !!! )");
		}
		SendClientMessage(playerid, COLOR_BIR, " -------------------------------------------------------------------------------------------------------");
		return 1;
	}
	if(strcmp(cmd, "/bankreg", true) == 0)
	{
		if(bankplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
			return 1;
		}
		if(perop[playerid] == -100)
		{
			SendClientMessage(playerid, COLOR_RED, " You are so far from the safe !");
			return 1;
		}
		if(strlen(Bname[perop[playerid]]) == 0 || strlen(Bpass[perop[playerid]]) == 0 ||
		strlen(Bmoney[perop[playerid]]) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Bank system error!");
			SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
			return 1;
		}
		if(perop[playerid] != -100 && strcmp(RealName[playerid], Bname[perop[playerid]], false) != 0)
		{
			SendClientMessage(playerid, COLOR_RED, " This safe is not your !");
			return 1;
		}
		if(strcmp(Bpass[perop[playerid]], "*** INV_PASS", false) != 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Your bank account is already registered !");
			SendClientMessage(playerid, COLOR_RED, " Talk to the server admins to create new one !");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_BIR, " Type: /bankreg [password]");
			return 1;
		}
		if(strlen(tmp) < 3 || strlen(tmp) > 20)
		{
			SendClientMessage(playerid, COLOR_RED, " Password length must be from 3 to 20 symbols !");
			return 1;
		}
		if(PassControl(tmp) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You can use ONLY latin ");
			SendClientMessage(playerid, COLOR_RED, " letters: from a to z , from A to Z , and numbers from 0 to 9 !");
			return 1;
		}
		if(Bpasscou[perop[playerid]] != 0)
		{
			Bpasscou[perop[playerid]] = 0;
		}
		strdel(Bpass[perop[playerid]], 0, 32);
		strcat(Bpass[perop[playerid]], tmp);
		SaveBankSystem(perop[playerid]);

		format(string, sizeof(string), " Your registration password: '{FFFF00}%s{00FF00}' - don't forget it !",
		Bpass[perop[playerid]]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		printf("[banksys] Player %s [%d] registrated the bank account (%d) , password (%s) .",
		RealName[playerid], playerid, perop[playerid], Bpass[perop[playerid]]);
		return 1;
	}
	if(strcmp(cmd, "/banklog", true) == 0)
	{
		if(bankplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
			return 1;
		}
		if(perop[playerid] == -100)
		{
			SendClientMessage(playerid, COLOR_RED, " You are so far from the safe !");
			return 1;
		}
		if(strlen(Bname[perop[playerid]]) == 0 || strlen(Bpass[perop[playerid]]) == 0 ||
		strlen(Bmoney[perop[playerid]]) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Bank system error !");
			SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
			return 1;
		}
		if(perop[playerid] != -100 && strcmp(RealName[playerid], Bname[perop[playerid]], false) != 0)
		{
			SendClientMessage(playerid, COLOR_RED, " This safe is not your !");
			return 1;
		}
		if(strcmp(Bpass[perop[playerid]], "*** INV_PASS", false) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Your bank account has not been registered yet !");
			SendClientMessage(playerid, COLOR_RED, " For registration - use command  /bankreg  !");
			return 1;
		}
		if(logplay[playerid] == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " You are already logged in !");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_BIR, " Type: /banklog [password]");
			return 1;
		}
		if(strlen(tmp) < 3 || strlen(tmp) > 20)
		{
			SendClientMessage(playerid, COLOR_RED, " Password length must be from 3 to 20 symbols !");
			return 1;
		}
		if(PassControl(tmp) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You can use ONLY latin ");
			SendClientMessage(playerid, COLOR_RED, " letters: from a to z , from A to Z , and numbers from 0 to 9 !");
			return 1;
		}
		if(strcmp(tmp, Bpass[perop[playerid]], false) == 0)
		{
			if(bankplay[playerid] == 1 && perop[playerid] != -100 &&
			strcmp(RealName[playerid], Bname[perop[playerid]], false) == 0)
			{
				dopcouplay[playerid] = 0;
				logplay[playerid] = 1;
				SendClientMessage(playerid, COLOR_GREEN, " You have successfully logged in.");
				printf("[banksys] Player %s [%d] have logged in the bank account (%d) .",
				RealName[playerid], playerid, perop[playerid]);
				return 1;
			}
		}
		else
		{
			dopcouplay[playerid]++;
			SendClientMessage(playerid, COLOR_RED, " Password typing error !");
		}
		if(dopcouplay[playerid] >= 10)
		{
			format(string, sizeof(string), " [banksys] Player %s [%d] was kicked, attempt of bank account hacking !",
			RealName[playerid], playerid);
			SendClientMessageToAll(COLOR_RED, string);
			print(string);
			SetTimerEx("PlayKick", 300, 0, "i", playerid);
		}
		return 1;
	}
	if(strcmp(cmd, "/bankchan", true) == 0)
	{
		if(bankplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
			return 1;
		}
		if(perop[playerid] == -100)
		{
			SendClientMessage(playerid, COLOR_RED, " You are so far from the safe !");
			return 1;
		}
		if(strlen(Bname[perop[playerid]]) == 0 || strlen(Bpass[perop[playerid]]) == 0 ||
		strlen(Bmoney[perop[playerid]]) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Bank system error !");
			SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
			return 1;
		}
		if(perop[playerid] != -100 && strcmp(RealName[playerid], Bname[perop[playerid]], false) != 0)
		{
			SendClientMessage(playerid, COLOR_RED, " This safe is not yours !");
			return 1;
		}
		if(strcmp(Bpass[perop[playerid]], "*** INV_PASS", false) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Your bank account has not been registered yet !");
			SendClientMessage(playerid, COLOR_RED, " For registration - use command  /bankreg  !");
			return 1;
		}
		if(logplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not logged yet !");
			SendClientMessage(playerid, COLOR_RED, " For logging - use command  /banklog  !");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_BIR, " Type: /bankchan [new password]");
			return 1;
		}
		if(strlen(tmp) < 3 || strlen(tmp) > 20)
		{
			SendClientMessage(playerid, COLOR_RED, " Password length must be from 3 to 20 symbols !");
			return 1;
		}
		if(PassControl(tmp) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You can use ONLY latin ");
			SendClientMessage(playerid, COLOR_RED, " letters: from a to z , from A to Z , and numbers from 0 to 9 !");
			return 1;
		}
		if(strcmp(tmp, Bpass[perop[playerid]], false) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You used your old password !");
			return 1;
		}
		new para2[32];
		strdel(para2, 0, 32);
		strcat(para2, Bpass[perop[playerid]]);
		strdel(Bpass[perop[playerid]], 0, 32);
		strcat(Bpass[perop[playerid]], tmp);
		SaveBankSystem(perop[playerid]);

		format(string, sizeof(string), " Your new registration password: '{FFFF00}%s{00FF00}' - don't forget it !",
		Bpass[perop[playerid]]);
		SendClientMessage(playerid, COLOR_GREEN, string);
		printf("[banksys] Player %s [%d] changed the bank account password from (%d) to (%s) FP: (%s) .",
		RealName[playerid], playerid, perop[playerid], Bpass[perop[playerid]], para2);
		return 1;
	}
	if(strcmp(cmd, "/bankdown", true) == 0)
	{
		if(bankplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
			return 1;
		}
		if(perop[playerid] == -100)
		{
			SendClientMessage(playerid, COLOR_RED, " You are so far from the safe !");
			return 1;
		}
		if(strlen(Bname[perop[playerid]]) == 0 || strlen(Bpass[perop[playerid]]) == 0 ||
		strlen(Bmoney[perop[playerid]]) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Bank system error !");
			SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
			return 1;
		}
		if(perop[playerid] != -100 && strcmp(RealName[playerid], Bname[perop[playerid]], false) != 0)
		{
			SendClientMessage(playerid, COLOR_RED, " This safe is not yours !");
			return 1;
		}
		if(strcmp(Bpass[perop[playerid]], "*** INV_PASS", false) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Your bank account has not been registered yet !");
			SendClientMessage(playerid, COLOR_RED, " For registration - use command  /bankreg  !");
			return 1;
		}
		if(logplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not logged yet !");
			SendClientMessage(playerid, COLOR_RED, " For logging - use command  /banklog  !");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_BIR, " Type: /bankdown [amount]");
			return 1;
		}
		new para1 = strval(tmp);
		if(para1 <= 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Amount can't be zero,");
			SendClientMessage(playerid, COLOR_RED, " or can't be negative number !");
			return 1;
		}
		new para2, para3[32];
		format(para3, sizeof(para3), "%d", para1);
		para2 = GetPlayerMoney(playerid);
		if(para1 > para2)
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have that amount !");
			return 1;
		}
		new para4[40];
		if(cal_add(Bmoney[perop[playerid]], para3, para4, 0) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " This amount can't be placed in bank account (It's to big!) !");
			return 1;
		}
		GivePlayerMoney(playerid, para1 * -1);
		strdel(Bmoney[perop[playerid]], 0, 32);
		strcat(Bmoney[perop[playerid]], para4);
		SaveBankSystem(perop[playerid]);

		format(string, sizeof(string), " You put %d $ to the bank account.", para1);
		SendClientMessage(playerid, COLOR_GREEN, string);
		printf("[banksys] Player %s [%d] put(%d) %d $ to the bank account.",
		RealName[playerid], playerid, perop[playerid], para1);
		return 1;
	}
	if(strcmp(cmd, "/bankget", true) == 0)
	{
		if(bankplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
			return 1;
		}
		if(perop[playerid] == -100)
		{
			SendClientMessage(playerid, COLOR_RED, " You are so far from the safe !");
			return 1;
		}
		if(strlen(Bname[perop[playerid]]) == 0 || strlen(Bpass[perop[playerid]]) == 0 ||
		strlen(Bmoney[perop[playerid]]) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Bank system error !");
			SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
			return 1;
		}
		if(perop[playerid] != -100 && strcmp(RealName[playerid], Bname[perop[playerid]], false) != 0)
		{
			SendClientMessage(playerid, COLOR_RED, " This safe is not yours !");
			return 1;
		}
		if(strcmp(Bpass[perop[playerid]], "*** INV_PASS", false) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Your bank account has not been registered yet !");
			SendClientMessage(playerid, COLOR_RED, " For registration - use command  /bankreg  !");
			return 1;
		}
		if(logplay[playerid] == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " You are not logged yet !");
			SendClientMessage(playerid, COLOR_RED, " For logging - use command  /banklog  !");
			return 1;
		}
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendClientMessage(playerid, COLOR_BIR, " Type: /bankget [amount]");
			return 1;
		}
		new para1[32];
		strdel(para1, 0, 32);
		strcat(para1, tmp);
		if(cal_con(para1) == 0)
		{
			SendClientMessage(playerid, COLOR_RED, " Incorrect value !");
			return 1;
		}
		if(cal_cmp(para1, "0") == 0 || cal_cmp(para1, "0") == 2)
		{
			SendClientMessage(playerid, COLOR_RED, " Amount can't be zero,");
			SendClientMessage(playerid, COLOR_RED, " or can't be negative number !");
			return 1;
		}
		if(cal_cmp(para1, Bmoney[perop[playerid]]) == 1)
		{
			SendClientMessage(playerid, COLOR_RED, "You don't have such amount in your bank account !");
			return 1;
		}
		if(cal_cmp(para1, "2147483647") == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " This amount won't fit in your wallet !");
			return 1;
		}
		new para2, para3[32], para4[40];
		para2 = GetPlayerMoney(playerid);
		format(para3, sizeof(para3), "%d", para2);
		cal_add(para1, para3, para4, 0);
		if(cal_cmp(para4, "2147483647") == 1)
		{
			SendClientMessage(playerid, COLOR_RED, " This amount won't fit in your wallet !");
			return 1;
		}
		new para5 = strval(para1);
		cal_sub(Bmoney[perop[playerid]], para1, para4, 0);
		GivePlayerMoney(playerid, para5);
		strdel(Bmoney[perop[playerid]], 0, 32);
		strcat(Bmoney[perop[playerid]], para4);
		SaveBankSystem(perop[playerid]);

		format(string, sizeof(string), " You took from the bank account %d $ .", para5);
		SendClientMessage(playerid, COLOR_GREEN, string);
		printf("[banksys] Player %s [%d] took from the bank account (%d) %d $ .",
		RealName[playerid], playerid, perop[playerid], para5);
		return 1;
	}
	if(strcmp(cmd, "/banklink", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /banklink [account id] [players nickname]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) != 0)
			{
				SendClientMessage(playerid, COLOR_RED, " This bank account is already taken !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /banklink [account id] [players nickname] !");
				return 1;
			}
			if(strlen(tmp) < 1 || strlen(tmp) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Nickname length must be from 1 to 25 symbols !");
				return 1;
			}
			new para2[64];
			strdel(para2, 0, 64);
			strcat(para2, tmp);
			if(NikControl(para2) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Error! There are forbidden symbols in the nickname!");
				return 1;
			}
			new para3 = 0;
			new para4 = 0;
			while(para3 < 8)
			{
				if(strcmp(para2, Bname[para3], false) == 0)
				{
					para4 = 1;
					break;
				}
				para3++;
			}
			if(para4 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Nickname already has a personal bank account !");
				return 1;
			}
			strdel(Bname[para1], 0, 64);
			strcat(Bname[para1], para2);
			SaveBankSystem(para1);

			format(string, sizeof(string), " You have connected bank account (%d) to the player %s .", para1, Bname[para1]);
			SendClientMessage(playerid, COLOR_GREEN, string);
			printf("[banksys] Admin %s [%d] have connected bank account (%d) to the player %s .",
			RealName[playerid], playerid, para1, Bname[para1]);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankunlink", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankunlink [account id]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " This bank account is already taken !");
				return 1;
			}
			OutLogPlay(para1);
			new para2[64];
			strdel(para2, 0, 64);
			strcat(para2, Bname[para1]);
			strdel(Bname[para1], 0, 64);
			strcat(Bname[para1], "*** INV_PL_ID");
			strdel(Bpass[para1], 0, 32);
			strcat(Bpass[para1], "*** INV_PASS");
			strdel(Bmoney[para1], 0, 32);
			strcat(Bmoney[para1], "0");
			SaveBankSystem(para1);

			format(string, sizeof(string), " You have disconnected bank account (%d) from the player %s .", para1, para2);
			SendClientMessage(playerid, COLOR_RED, string);
			printf("[banksys] Admin %s [%d] have disconnected bank account (%d) from the player %s .",
			RealName[playerid], playerid, para1, para2);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankclear", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankclear [account id]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You have selected an empty (unoccupied) bank account !");
				return 1;
			}
			if(strcmp(Bpass[para1], "*** INV_PASS", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Selected bank account isn't registrated !");
				return 1;
			}
			OutLogPlay(para1);
			if(Bpasscou[para1] == 0)
			{
				strdel(Bpass22[para1], 0, 32);
				strcat(Bpass22[para1], Bpass[para1]);
				strdel(Bpass[para1], 0, 32);
				strcat(Bpass[para1], "*** INV_PASS");
			}
			Bpasscou[para1] = 60+2;

			format(string, sizeof(string), " You have made a temporary reset of the bank account registration (%d) .", para1);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			printf("[banksys] Admin %s [%d] have made a temporary reset of the bank account registration (%d) .",
			RealName[playerid], playerid, para1);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankname", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankname [account id] [players nickname]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " The bank account you have selected is not occupied !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /bankname [account id] [players nickname] !");
				return 1;
			}
			if(strlen(tmp) < 1 || strlen(tmp) > 25)
			{
				SendClientMessage(playerid, COLOR_RED, " Nickname length must be from 1 to 25 symbols !");
				return 1;
			}
			new para2[64];
			strdel(para2, 0, 64);
			strcat(para2, tmp);
			if(NikControl(para2) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Error! There are forbidden symbols in the nickname !");
				return 1;
			}
			new para3 = 0;
			new para4 = 0;
			while(para3 < 8)
			{
				if(strcmp(para2, Bname[para3], false) == 0)
				{
					para4 = 1;
					break;
				}
				para3++;
			}
			if(para4 == 1)
			{
				SendClientMessage(playerid, COLOR_RED, " This nickname already has a personal bank account !");
				return 1;
			}
			OutLogPlay(para1);
			new para5[64];
			strdel(para5, 0, 64);
			strcat(para5, Bname[para1]);
			strdel(Bname[para1], 0, 64);
			strcat(Bname[para1], para2);
			SaveBankSystem(para1);

			format(string, sizeof(string), " You changed the players nickname in the bank account from (%d) to %s FN: %s .",
			para1, Bname[para1], para5);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			printf("[banksys] Admin %s [%d] changed the players nickname in the bank account from (%d) to %s FN: %s .",
			RealName[playerid], playerid, para1, Bname[para1], para5);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankpass", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankpass [account id]");
				SendClientMessage(playerid, COLOR_BIR, " (:additionally [new password] )");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no [account id] in bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You choose free bank account !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				if(strcmp(Bpass[para1], "*** INV_PASS", false) == 0)
				{
					format(string, sizeof(string), " Bank account: %d   password: {FF3F3F}false{FFFFFF} .",
					para1, Bpass[para1]);
				}
				else
				{
					format(string, sizeof(string), " Bank account: %d   password: (%s) .",
					para1, Bpass[para1]);
				}
				SendClientMessage(playerid, COLOR_WHITE, string);
				SendClientMessage(playerid, COLOR_WHITE, " .....");
				SendClientMessage(playerid, COLOR_WHITE, " Type: /bankpass [account id]");
				SendClientMessage(playerid, COLOR_WHITE, " ( additionally: [new password] )");
				printf("[banksys] Admin %s [%d] checked players bank account password  %d .",
				RealName[playerid], playerid, para1);
				return 1;
			}
			if(strlen(tmp) < 3 || strlen(tmp) > 20)
			{
				SendClientMessage(playerid, COLOR_RED, " Password lenght must be from 3 to 20 symbols !");
				return 1;
			}
			new para2[64];
			strdel(para2, 0, 64);
			strcat(para2, tmp);
			if(PassControl(para2) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You can use ONLY latin ");
				SendClientMessage(playerid, COLOR_RED, " letters: from a to z , from A to Z , and numbers from 0 to 9 !");
				return 1;
			}
			if(strcmp(para2, Bpass[para1], false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You typed old bank account password !");
				return 1;
			}
			OutLogPlay(para1);
			new para3[64];
			strdel(para3, 0, 64);
			strcat(para3, Bpass[para1]);
			strdel(Bpass[para1], 0, 64);
			strcat(Bpass[para1], para2);
			SaveBankSystem(para1);

			format(string, sizeof(string), " You changed players bank account password from (%d) to (%s) FP: (%s) .",
			para1, Bpass[para1], para3);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			printf("[banksys] Admin %s [%d] changed players bank account password from (%d) to (%s) FP: (%s) .",
			RealName[playerid], playerid, para1, Bpass[para1], para3);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankmon", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankmon [account id] [amount]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You choose free bank account !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /bankmon [account id] [amount] !");
				return 1;
			}
			new para2[32];
			strdel(para2, 0, 32);
			strcat(para2, tmp);
			if(cal_con(para2) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, "  !");
				return 1;
			}
			if(cal_cmp(para2, "0") == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Amount can't be zero !");
				return 1;
			}
			if(cal_cmp(para2, "0") == 1)
			{
				new para3[40];
				if(cal_add(Bmoney[para1], para2, para3, 0) == 0)
				{
					SendClientMessage(playerid, COLOR_RED, " This amount won't fit in the wallet !");
					return 1;
				}
				OutLogPlay(para1);
				new para4[32];
				strdel(para4, 0, 32);
				strcat(para4, Bmoney[para1]);
				strdel(Bmoney[para1], 0, 32);
				strcat(Bmoney[para1], para3);
				SaveBankSystem(para1);

				format(string, sizeof(string), " You put to the bank account (%d) amount %s $ FS: %s $ .",
				para1, para2, para4);
				SendClientMessage(playerid, COLOR_GREEN, string);
				printf("[banksys] Admin %s [%d] put to the bank account (%d) amount %s $ FS: %s $ .",
				RealName[playerid], playerid, para1, para2, para4);
				return 1;
			}
			if(cal_cmp(para2, "0") == 2)
			{
				strmid(para2, para2, 1, strlen(para2));
				new para3[40];
				cal_sub(Bmoney[para1], para2, para3, 0);
				if(cal_cmp(para3, "0") == 2)
				{
					SendClientMessage(playerid, COLOR_RED, " The debiting amount is bigger than the amount on the bank account !");
					return 1;
				}
				OutLogPlay(para1);
				new para4[32];
				strdel(para4, 0, 32);
				strcat(para4, Bmoney[para1]);
				strdel(Bmoney[para1], 0, 32);
				strcat(Bmoney[para1], para3);
				SaveBankSystem(para1);

				format(string, sizeof(string), " You debited from the bank account (%d) amount %s $ FS: %s $ .",
				para1, para2, para4);
				SendClientMessage(playerid, COLOR_RED, string);
				printf("[banksys] Admin %s [%d] debited from the bank account (%d) amount %s $ FS: %s $ .",
				RealName[playerid], playerid, para1, para2, para4);
				return 1;
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/banksmon", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /banskmon [account id] [amount]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			if(strlen(Bname[para1]) == 0 || strlen(Bpass[para1]) == 0 || strlen(Bmoney[para1]) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " Bank system error !");
				SendClientMessage(playerid, COLOR_RED, " Operation can't be performed !");
				return 1;
			}
			if(strcmp(Bname[para1], "*** INV_PL_ID", false) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " The bank account you selected is not occupied !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_RED, " /banksmon [account id] [amount] !");
				return 1;
			}
			new para2[32];
			strdel(para2, 0, 32);
			strcat(para2, tmp);
			if(cal_con(para2) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You typed irregular amount !");
				return 1;
			}
			if(cal_cmp(para2, "0") == 2)
			{
				SendClientMessage(playerid, COLOR_RED, " Amount can't be zero !");
				return 1;
			}
			if(cal_cmp(Bmoney[para1], para2) == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " This amount is already set in the bank account !");
				return 1;
			}
			OutLogPlay(para1);
			new para4[32];
			strdel(para4, 0, 32);
			strcat(para4, Bmoney[para1]);
			strdel(Bmoney[para1], 0, 32);
			strcat(Bmoney[para1], para2);
			SaveBankSystem(para1);

			format(string, sizeof(string), " You have installed on your bank account (%d) amount %s $ FS: %s $ .",
			para1, Bmoney[para1], para4);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			printf("[banksys] Admin %s [%d] have installed on your bank account (%d) amount %s $ FS: %s $ .",
			RealName[playerid], playerid, para1, Bmoney[para1], para4);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankrecr", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankrecr [account id]");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 < 0 || para1 > 7)
			{
				SendClientMessage(playerid, COLOR_RED, " There are no bank account [account id] in the bank system !");
				return 1;
			}
			OutLogPlay(para1);
			ReCrBankSystem(para1);

			format(string, sizeof(string), " You succesfully re-created bank account (%d) .", para1);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			printf("[banksys] Admin %s [%d] re-created bank account (%d) .",
			RealName[playerid], playerid, para1);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	if(strcmp(cmd, "/bankform", true) == 0)
	{
		if(IsPlayerAdmin(playerid))
		{
			if(bankplay[playerid] == 0)
			{
				SendClientMessage(playerid, COLOR_RED, " You are not in the bank !");
				return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_BIR, " Type: /bankform 1");
				SendClientMessage(playerid, COLOR_RED, " ( use ONLY in extreme cases !!! )");
				return 1;
			}
			new para1 = strval(tmp);
			if(para1 != 1)
			{
				SendClientMessage(playerid, COLOR_RED, " Optional parameter error !");
				return 1;
			}
			FormBankSystem();

			SendClientMessage(playerid, COLOR_YELLOW, " You succsesfully formatted all bank accounts.");
			printf("[banksys] Admin %s [%d] formatted all bank accounts.", RealName[playerid], playerid);
		}
		else
		{
			SendClientMessage(playerid, COLOR_RED, " You don't have permission to use this command !");
		}
		return 1;
	}
	return 0;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && spawplay[playerid] == 1)
	{
		for(new i = 0; i < 8; i++)
		{
			if(pickupid == Pic2[i])
			{
				perop[playerid] = i;
			}
		}
	}
	return 1;
}

forward OutLogPlay(bankid);
public OutLogPlay(bankid)
{
	new para1 = 0;
	new para2 = -100;
	while(para1 < MAX_PLAYERS)
	{
		if(IsPlayerConnected(para1))
		{
			if(strcmp(Bname[bankid], RealName[para1], false) == 0)
			{
				para2 = para1;
				break;
			}
		}
		para1++;
	}
	if(para2 != -100)
	{
		if(logplay[para2] == 1)
		{
			dopcouplay[para2] = 0;
			logplay[para2] = 0;
			SendClientMessage(para2, COLOR_RED, " You have been logged out by a banking system service operation !");
			printf("[banksys] Player %s [%d] have been logged out from the bank account (%d) banking system service operation.",
			RealName[para2], para2, perop[para2]);
		}
	}
	return 1;
}

forward PlayKick(playerid);
public PlayKick(playerid)
{
	Kick(playerid);
	return 1;
}

forward SaveBankSystem(bankid);
public SaveBankSystem(bankid)
{
	new para1[40], string[512];
	cal_pf(Bmoney[bankid], para1);
	if(strcmp(Bname[bankid], "*** INV_PL_ID", false) == 0 && strcmp(Bpass[bankid], "*** INV_PASS", false) == 0)
	{
		format(string, sizeof(string), "Account ID %d\nOwner: false\nRegistration: false\n\nAmount: %s $",
		bankid, para1);
		UpdateDynamic3DTextLabelText(Tex2[bankid], 0x00FF00FF, string);
	}
	if(strcmp(Bname[bankid], "*** INV_PL_ID", false) != 0 && strcmp(Bpass[bankid], "*** INV_PASS", false) == 0)
	{
		format(string, sizeof(string), "Account ID %d\nOwner: %s\nRegistration: false\n\nAmount: %s $",
		bankid, Bname[bankid], para1);
		UpdateDynamic3DTextLabelText(Tex2[bankid], 0x00FF00FF, string);
	}
	if(strcmp(Bname[bankid], "*** INV_PL_ID", false) != 0 && strcmp(Bpass[bankid], "*** INV_PASS", false) != 0)
	{
		format(string, sizeof(string), "Account ID %d\nOwner: %s\nRegistration: true\n\nAmount: %s $",
		bankid, Bname[bankid], para1);
		UpdateDynamic3DTextLabelText(Tex2[bankid], 0x00FF00FF, string);
	}

    new file, f[256];
	format(f, 256, "banksys/%i.ini", bankid);
	if(!fexist(f))
	{
		file = ini_createFile(f);
	}
	else
	{
		file = ini_openFile(f);
	}
	if(file >= 0)
	{
	    ini_setString(file, "Bname", Bname[bankid]);
	    ini_setString(file, "Bpass", Bpass[bankid]);
	    ini_setString(file, "Bmoney", Bmoney[bankid]);

		ini_closeFile(file);
	}
	return 1;
}

forward ReCrBankSystem(bankid);
public ReCrBankSystem(bankid)
{
	new para1[40];
    new string[512], file, f[256];
    format(f, 256, "banksys/%i.ini", bankid);
	if(fexist(f))
	{
		fremove(f);
	}
	strdel(Bname[bankid], 0, 64);
	strcat(Bname[bankid], "*** INV_PL_ID");
	strdel(Bpass[bankid], 0, 32);
	strcat(Bpass[bankid], "*** INV_PASS");
	strdel(Bmoney[bankid], 0, 32);
	strcat(Bmoney[bankid], "0");

	file = ini_createFile(f);
	if(file >= 0)
	{
	    ini_setString(file, "Bname", Bname[bankid]);
	    ini_setString(file, "Bpass", Bpass[bankid]);
	    ini_setString(file, "Bmoney", Bmoney[bankid]);

		cal_pf(Bmoney[bankid], para1);
		format(string, sizeof(string), "Account ID %d\nOwner: false\nRegistration: false\n\nAmount: %s $",
		bankid, para1);
		UpdateDynamic3DTextLabelText(Tex2[bankid], 0x00FF00FF, string);

		ini_closeFile(file);
	}
	return 1;
}

forward FormBankSystem();
public FormBankSystem()
{
	new para1[40];
    new string[512], file, f[256];
	for(new i; i < 8; i++)
	{
	    format(f, 256, "banksys/%i.ini", i);
		if(fexist(f))
		{
			fremove(f);
		}
		OutLogPlay(i);
		strdel(Bname[i], 0, 64);
		strcat(Bname[i], "*** INV_PL_ID");
		strdel(Bpass[i], 0, 32);
		strcat(Bpass[i], "*** INV_PASS");
		strdel(Bmoney[i], 0, 32);
		strcat(Bmoney[i], "0");

		file = ini_createFile(f);
		if(file >= 0)
		{
		    ini_setString(file, "Bname", Bname[i]);
		    ini_setString(file, "Bpass", Bpass[i]);
		    ini_setString(file, "Bmoney", Bmoney[i]);

			cal_pf(Bmoney[i], para1);
			format(string, sizeof(string), "Account ID %d\nOwner: false\nRegistration: false\n\nAmount: %s $",
			i, para1);
			UpdateDynamic3DTextLabelText(Tex2[i], 0x00FF00FF, string);

			ini_closeFile(file);
		}
	}
	return 1;
}

forward LoadBankSystem();
public LoadBankSystem()
{
	new para1[40], count = 0;
    new string[512], file, f[256];
	for(new i; i < 8; i++)
	{
	    format(f, 256, "banksys/%i.ini", i);
		file = ini_openFile(f);
		if(file >= 0)
		{
			count++;
		    ini_getString(file, "Bname", Bname[i]);
		    ini_getString(file, "Bpass", Bpass[i]);
		    ini_getString(file, "Bmoney", Bmoney[i]);

			cal_pf(Bmoney[i], para1);
			if(strcmp(Bname[i], "*** INV_PL_ID", false) == 0 && strcmp(Bpass[i], "*** INV_PASS", false) == 0)
			{
				format(string, sizeof(string), "Account ID %d\nOwner: false\nRegistration: false\n\nAmount: %s $",
				i, para1);
				UpdateDynamic3DTextLabelText(Tex2[i], 0x00FF00FF, string);
			}
			if(strcmp(Bname[i], "*** INV_PL_ID", false) != 0 && strcmp(Bpass[i], "*** INV_PASS", false) == 0)
			{
				format(string, sizeof(string), "Account ID %d\nOwner: %s\nRegistration: false\n\nAmount: %s $",
				i, Bname[i], para1);
				UpdateDynamic3DTextLabelText(Tex2[i], 0x00FF00FF, string);
			}
			if(strcmp(Bname[i], "*** INV_PL_ID", false) != 0 && strcmp(Bpass[i], "*** INV_PASS", false) != 0)
			{
				format(string, sizeof(string), "Account ID %d\nOwner: %s\nRegistration: true\n\nAmount: %s $",
				i, Bname[i], para1);
				UpdateDynamic3DTextLabelText(Tex2[i], 0x00FF00FF, string);
			}

			ini_closeFile(file);
		}
	}
	print(" ");
	printf(" %d bank accounts loaded.", count);

	print(" ");
	print("--------------------------------------");
	print("     banksys loaded successfully!      ");
	print("--------------------------------------\n");
	return 1;
}

forward PassControl(string[]);
public PassControl(string[])
{
	new dln, dopper;
	dln = strlen(string);
	dopper = 1;
	for(new i = 0; i < dln; i++)
	{
		if(string[i] < 48 || (string[i] > 57 && string[i] < 65) ||
		(string[i] > 90 && string[i] < 97) || string[i] > 122) { dopper = 0; }
	}
	return dopper;
}

forward NikControl(string[]);
public NikControl(string[])
{
	new dln, dopper;
	dln = strlen(string);
	dopper = 1;
	for(new i = 0; i < dln; i++)
	{
		if(string[i] == 32 || string[i] == 37 || string[i] > 125) { dopper = 0; }
	}
	return dopper;
}

forward OneSec();
public OneSec()
{
	new string[512], para1[40];
	for(new i; i < 8; i++)
	{
		if(Bpasscou[i] > 1)
		{
			Bpasscou[i]--;
			cal_pf(Bmoney[i], para1);
			format(string, sizeof(string), "Account ID %d\nOwner: %s\nRegistration: time - %d\n\nAmount: %s $",
			i, Bname[i], Bpasscou[i]-1, para1);
			UpdateDynamic3DTextLabelText(Tex2[i], 0x00FF00FF, string);
		}
		if(Bpasscou[i] == 1)
		{
			Bpasscou[i]--;
			strdel(Bpass[i], 0, 32);
			strcat(Bpass[i], Bpass22[i]);
			cal_pf(Bmoney[i], para1);
			format(string, sizeof(string), "Account ID %d\nOwner: %s\nRegistration: true\n\nAmount: %s $",
			i, Bname[i], para1);
			UpdateDynamic3DTextLabelText(Tex2[i], 0x00FF00FF, string);
		}
	}
	new pint, pvw;
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
 			pint = GetPlayerInterior(i);
			pvw = GetPlayerVirtualWorld(i);
			if(pint == 1 && pvw == 0 &&
			IsPlayerInRangeOfPoint(i, 12.0, 2144.27, 1635.21, 993.57) == 1)
	    	{
				bankplay[i] = 1;
			}
			else
			{
				bankplay[i] = 0;
				dopcouplay[i] = 0;
				if(logplay[i] == 1)
				{
					logplay[i] = 0;
					SendClientMessage(i, COLOR_YELLOW, " You are logged out of your bank account !");
					printf("[banksys] Player %s [%d] logged out of the bank account (%d) .",
					RealName[i], i, perop[i]);
				}
			}
			if(perop[i] != -100)
			{
				if(!IsPlayerInRangeOfPoint(i, 1.5, CorX[perop[i]], CorY[perop[i]], CorZ[perop[i]]))
		    	{
					if(logplay[i] == 1)
					{
						dopcouplay[i] = 0;
						logplay[i] = 0;
						SendClientMessage(i, COLOR_YELLOW, " You are logged out of your bank account !");
						printf("[banksys] Player %s [%d] logged out of the bank account (%d) .",
						RealName[i], i, perop[i]);
					}
					perop[i] = -100;
				}
			}
		}
	}
    return 1;
}

