/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <sqlx>

#define PLUGIN "Register System"
#define VERSION "1.0"
#define AUTHOR "AMG"
#define TAG "!g[!tSYSTEM!g]"

#pragma semicolon 1

new NickName[33][32], Password[33][32], SteamID[33][32];
new MYSQLPassword[33][32];
new const TABEL[]="Users_Reg";
new Handle:g_SqlTuple,g_Error[256];
new bool: playerexist[33], LoggedIn[33], ResetPassword[33];

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	register_clcmd("say /register", "func_register");
	register_clcmd("say /login", "func_register");
	register_clcmd("say /panel", "func_register");
	register_concmd("MyPass", "func_password", -1, "", -1);
}

public func_register (id) {
	new MenuName[32];
	if(!playerexist[id])
	formatex(MenuName, sizeof(MenuName)-1, "\rRegister Menu");
	else
	formatex(MenuName, sizeof(MenuName)-1, "\rLogin Menu");
	if (playerexist[id] && LoggedIn[id])
	formatex(MenuName, sizeof(MenuName)-1, "\rMain Panel");
	new menu = menu_create(MenuName, "MenuHandler"); 
	
	menu_additem(menu, "\rExit", "-69");
	
	menu_addblank(menu, 0);
	
	// Zona Inregistrare
	
	if(!playerexist[id]) {
	
	new Temp[64];
	
	formatex(Temp, sizeof(Temp)-1, "\rNickName\d: \r[\w%s\r]", NickName[id]);
	menu_additem(menu, Temp, "1");
	
	if(equali(Password[id], "")) {
	formatex(Temp, sizeof(Temp)-1, "\rPassword\d: \r[\wNone\r]");
	menu_additem(menu, Temp, "2");
	}
	else
	{
		formatex(Temp, sizeof(Temp)-1, "\rPassword\d: \r[\w%s\r]", Password[id]);
		menu_additem(menu, Temp, "2");
	}
	
	menu_addblank(menu, 0);
	
	menu_additem(menu, "\rRegister", "3");
	
	}
	
	// Zona Logare
	
	
	if(playerexist[id] && !LoggedIn[id]) {
		
	new Temp[64];
	
	formatex(Temp, sizeof(Temp)-1, "\rNickName\d: \r[\w%s\r]", NickName[id]);
	menu_additem(menu, Temp, "1");
	
	if(equali(Password[id], "")) {
	formatex(Temp, sizeof(Temp)-1, "\rPassword\d: \r[\wNone\r]");
	menu_additem(menu, Temp, "2");
	}
	else
	{
		formatex(Temp, sizeof(Temp)-1, "\rPassword\d: \r[\w%s\r]", Password[id]);
		menu_additem(menu, Temp, "2");
	}
	
	menu_addblank(menu, 0);
	
	menu_additem(menu, "\rLogin", "3");
	
	}
	
	// Zona Panou
	
	if(playerexist[id] && LoggedIn[id] && !ResetPassword[id]) {
	
	menu_addtext(menu, "\dBeta Version", -1);
	
	menu_additem(menu, "\rReset Password", "4");
	menu_additem(menu, "\rDisconect", "5");
	
	}
	
	// Zone Resetare Parola
	
	if(playerexist[id] && LoggedIn[id] && ResetPassword[id]) {
	
	menu_additem(menu, "\rCancel", "1");
	
	menu_addblank(menu, -1);
	
	new Temp[64];
	
	if(equali(Password[id], "")) {
		formatex(Temp, sizeof(Temp)-1, "\rPassword\d: \r[\wNone\r]");
		menu_additem(menu, Temp, "2");
		}
		else
		{
			formatex(Temp, sizeof(Temp)-1, "\rPassword\d: \r[\w%s\r]", Password[id]);
			menu_additem(menu, Temp, "2");
		}
	menu_additem(menu, "\rChange Now", "3");
	}
	
	menu_setprop(menu, MPROP_EXIT, MEXIT_NEVER);
	
	menu_display(id, menu, 0 );
	return PLUGIN_HANDLED;
}

public MenuHandler(id, menu, item) {
	new data [6], szName [64];
	new access, callback;
	menu_item_getinfo (menu, item, access, data,charsmax (data), szName,charsmax (szName), callback);
	new key = str_to_num (data);
	
	switch (key)
	{
		case 1: {
			if(ResetPassword[id]) {
				culoare(id, "%s !tChange Password Canceled!", TAG);
				ResetPassword[id] = false;
				return 1;
			}
			culoare(id, "%s !tCan't Change Your NickName", TAG);
			func_register(id);
			return 1;
		}
		case 2: {
			if(playerexist[id] && ResetPassword[id]) {
				culoare(id, "%s !tPlease Enter A New Password For Your Account!", TAG);
				client_cmd(id, "messagemode MyPass");
				return 1;
			}
			if(playerexist[id]) {
				culoare(id, "%s !tPlease Enter Your Password!", TAG);
				client_cmd(id, "messagemode MyPass");
				return 1;
			}
			else {
				culoare(id, "%s !tPlease Type A Password That Contain At Least 6 Characters", TAG);
				client_cmd(id, "messagemode MyPass");
				return 1;
			}
		}
		case 3: {
			if(equali(Password[id], "") && playerexist[id] && ResetPassword[id]) {
				culoare(id, "%s !tPlease Enter A Password To Change It!", TAG);
				return 1;
			}
			else {
				if(ResetPassword[id]) {
					static Temp[256];
					formatex(Temp,charsmax(Temp),"UPDATE %s SET Password = '%s' WHERE NickName = '%s'",TABEL, Password[id], NickName[id]);
					SQL_ThreadQuery(g_SqlTuple,"IgnoreHandle",Temp);
					LoggedIn[id] = true;
					culoare(id, "%s !tPassword Successfuly Changed!", TAG);
					culoare(id, "%s !tDisconected | Please Relogin!", TAG);
					MYSQLPassword[id] = Password[id];
					Password[id] = "";
					LoggedIn[id] = false;
					ResetPassword[id] = false;
					func_register(id);
					return 1;
				}
			}
			if(equali(Password[id], "") && playerexist[id]) {
				culoare(id, "%s !tPlease Enter Your Password!", TAG);
				return 1;
			}
			if(equali(Password[id], "") && !playerexist[id]) {
				culoare(id, "%s !tCan't Register Right Now | No Password Setted", TAG);
				return 1;
			}
			else {
				if(!playerexist[id]) {
					static Temp[256];
					formatex(Temp,charsmax(Temp),"INSERT INTO %s (NickName, Password, SteamID) VALUES ('%s', '%s', '%s');",TABEL, NickName[id], Password[id], SteamID[id]);
					SQL_ThreadQuery(g_SqlTuple,"IgnoreHandle",Temp);
					LoggedIn[id] = true;
					playerexist[id] = true;
					MYSQLPassword[id] = Password[id];
					culoare(id, "%s !tAccount Successfuly Created!", TAG);
					func_register(id);
					return 1;
				} 
				else {
					if(equali(Password[id], MYSQLPassword[id])) {
						LoggedIn[id] = true;
						culoare(id, "%s !tYou Have Just Successfuly Logged In!", TAG);
						return 1;
					}
					else {
						culoare(id, "%s !tWrong Password!", TAG);
						return 1;
					}
				}
			}
		}
		case 4: {
			if(!ResetPassword[id]) {
				ResetPassword[id] = true;
				Password[id] = "";
				func_register(id);
			}
			else {
				
			}
		}
		case 5: {
			culoare(id, "%s !tYou Have Just Successfuly Logged Out!", TAG);
			LoggedIn[id] = false;
			Password[id] = "";
		}
	}
	return PLUGIN_HANDLED;
}

public func_password(id)
{
	new Args[32];
	read_args(Args, 31);
	remove_quotes(Args);
	
	if(!playerexist[id] || playerexist[id] && ResetPassword[id]) {
		if(6 > strlen(Args) ) {
			culoare(id, "%s !tYour Password Should Be At Least 6 Characters!", TAG);
			client_cmd(id, "messagemode MyPass");
			return 1;
		}
		if(24 < strlen(Args) ) {
			culoare(id, "%s !tYour Password Can't Be More Than 24 Characters!!", TAG);
			client_cmd(id, "messagemode MyPass");
			return 1;
		}
	}
	else {
		if(24 < strlen(Args) ) {
			culoare(id, "%s !tYour Password Can't Be More Than 24 Characters!!", TAG);
			client_cmd(id, "messagemode MyPass");
			return 1;
		}
	}
	
	copy(Password[id], sizeof(Password)-1, Args);
	func_register(id);
	return 1;
}

public client_putinserver(id) {
	LoggedIn[id] = false;
	ResetPassword[id] = false;
	Password[id] = "";
}

public client_disconnect(id) {
	Password[id] = "";
	playerexist[id] = false;
	LoggedIn[id] = false;
	ResetPassword[id] = false;
}

public plugin_natives() {
	register_library("register");
	register_native("user_exist", "_user_exist");
	register_native("user_loggedin", "_user_loggedin");
	register_native("get_user_password", "_get_user_password");
	register_native("get_user_password_mysql", "_get_user_password_mysql");
}

public _user_exist(plugin,iParams[32])
{
	new id = get_param(1);
	if( !is_user_connected(id) ) return 1;
	if(playerexist[id]) return true;
	else return false;
	return 1;
}

public _get_user_password(plugin,iParams[32], len)
{
	new id = get_param(1);
	if( !is_user_connected(id) ) return 1;
	set_string(2, Password[id], get_param(3));
	return 1;
}

public _get_user_password_mysql(plugin,iParams[32], len)
{
	new id = get_param(1);
	if( !is_user_connected(id) ) return 1;
	set_string(2, MYSQLPassword[id], get_param(3));
	return 1;
}

public _user_loggedin(plugin,iParams[32])
{
	new id = get_param(1);
	if( !is_user_connected(id) ) return 1;
	if(LoggedIn[id]) return true;
	else return false;
	return 1;
}

public plugin_cfg() {
	set_task(0.5, "MySql_Init");
}

// MYSQL

public client_authorized ( id )	if(!(is_user_bot(id)||is_user_hltv(id)))	Load_MySql(id);
public Load_MySql(id)
{
	new szTemp[128];
	get_user_name(id, NickName[id], sizeof(NickName)-1);
	get_user_authid(id, SteamID[id], sizeof(SteamID)-1);
	new Data[1];
	Data[0] = id;
	format(szTemp,charsmax(szTemp),"SELECT * FROM `%s` WHERE (`NickName` = '%s');",TABEL, NickName[id]);
	SQL_ThreadQuery(g_SqlTuple,"register_client",szTemp,Data,1);
}
public register_client(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
	if(FailState == TQUERY_CONNECT_FAILED)	log_amx("Load - Could not connect to SQL database [%d] %s", Errcode, Error);
	else if(FailState == TQUERY_QUERY_FAILED)	log_amx("Load Query failed [%d] %s", Errcode, Error);

	new id;
	id = Data[0];
	if(SQL_NumResults(Query) < 1) 
	{
		if (equal(SteamID[id],"ID_PENDING"))
		return PLUGIN_HANDLED;
	} 
	else 	 
	{
		SQL_ReadResult(Query, 1, MYSQLPassword[id], sizeof(MYSQLPassword)-1);
		SQL_ReadResult(Query, 2, SteamID[id], sizeof(SteamID)-1);
		playerexist[id] = true;
	}
	return PLUGIN_HANDLED;
}

public MySql_Init()
{
	g_SqlTuple = SQL_MakeStdTuple();
	new ErrorCode,Handle:SqlConnection = SQL_Connect(g_SqlTuple,ErrorCode,g_Error,charsmax(g_Error));
	if(SqlConnection == Empty_Handle)	set_fail_state(g_Error);
	new Handle:Queries;

	Queries = SQL_PrepareQuery(SqlConnection,"CREATE TABLE IF NOT EXISTS %s (NickName varchar(33), Password varchar(33), SteamID varchar(33));",TABEL);
	if(!SQL_Execute(Queries))
	{
		SQL_QueryError(Queries,g_Error,charsmax(g_Error));
		set_fail_state(g_Error);
	}

	
	SQL_FreeHandle(Queries);
	SQL_FreeHandle(SqlConnection);
}

public IgnoreHandle(FailState,Handle:Query,Error[],Errcode,Data[],DataSize)
{
    SQL_FreeHandle(Query);
    return PLUGIN_HANDLED;
}

public plugin_end()
{	
	SQL_FreeHandle(g_SqlTuple);
}

stock culoare (const id, const input[], any:...) 
{
	new count = 1, players[ 32 ];
	static msg[ 191 ];
	vformat( msg, 190, input, 3 );
   
	replace_all( msg, 190, "!g", "^4" );
	replace_all( msg, 190, "!y", "^1" );
	replace_all( msg, 190, "!t2", "^2" );
	replace_all( msg, 190, "!t", "^3" );

   
	if(id) players[ 0 ] = id; else get_players( players, count, "ch" );
	{
		for(new i = 0; i < count; i++)
		{
			if( is_user_connected( players[ i ] ) )
			{
				message_begin( MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[ i ] );
				write_byte( players[ i ] );
				write_string( msg );
				message_end( );
			} 
		} 
	}
}
