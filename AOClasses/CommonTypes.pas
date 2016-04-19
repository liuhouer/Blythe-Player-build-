unit CommonTypes;
{ CommonTypes by Alessandro Cappellozza
  version 0.8 02/2002
  http://digilander.iol.it/Kappe/audioobject  
}

interface
 uses Windows, Dialogs, Forms, Controls, StdCtrls, Classes, ExtCtrls, SysUtils;

  Type TEqPreset = array [0..9] of Integer;
  Type TWaveData = array [ 0..2048] of DWORD;
  Type TFFTData = array [0..512] of Single;

  Const
       VERSION_INTEGER = 0.84;
       VERSION_STRING  = '0.8.4';
       VERSION_UPDATE  = 'Aplir 2002';
       STARTUP_TITLE = 'Audio Object Version ' + VERSION_STRING + ' *** by Porzyllosoft Inc. ***';
       DEFAULT_PLAYLIST = 'default.pls';
       DEFAUKT_SKIN  = 'default';
       ETENSION_REG_CLASS = 'AudioObject.Player';
       ETENSION_REG_DESCR = 'AO Audio File';
       DEFAULT_UPDATE_URL = 'http://crmw4dhe155zfi4/aoupdates.txt';
       DEFAULT_SHOUTCAST_URL = 'http://crmw4dhe155zfi4/shoutcast.txt';


       ENGINE_CST_OFFSET = 1000;
       ENGINE_STOP = ENGINE_CST_OFFSET + 1;
       ENGINE_PLAY = ENGINE_CST_OFFSET + 2;
       ENGINE_PAUSE = ENGINE_CST_OFFSET + 3;
       ENGINE_SONG_END = ENGINE_CST_OFFSET + 4;
       ENGINE_ON_LINE  = ENGINE_CST_OFFSET + 5;

       AMPSHELL_CST_OFFSET = 2000;
       MSG_TRAYICON  = AMPSHELL_CST_OFFSET + 1;

       KEY_A_CODE = 65;
       KEY_B_CODE = 66;
       KEY_C_CODE = 67;
       KEY_D_CODE = 68;
       KEY_E_CODE = 69;
       KEY_F_CODE = 70;
       KEY_I_CODE = 73;
       KEY_K_CODE = 75;
       KEY_L_CODE = 76;
       KEY_O_CODE = 79;
       KEY_P_CODE = 80;
       KEY_R_CODE = 82;
       KEY_S_CODE = 83;
       KEY_T_CODE = 84;
       KEY_V_CODE = 86;
       KEY_X_CODE = 88;
       KEY_Z_CODE = 90;
       KEY_UP_CODE = 38;
       KEY_DW_CODE = 40;
       KEY_BK_CODE = 37;
       KEY_FW_CODE = 39;
implementation

end.
