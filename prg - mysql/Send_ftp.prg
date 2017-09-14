
#include "FiveWin.Ch"
#include "qFtp.ch"

// Here I'm sending the data of central stock of goods reminder

function main
clear all
private nHorRes := GetSysMetric( 0 )
private nVerRes := GetSysMetric( 1 )
private cLg := "L"
private cSave, cGerai, cCancel, cCont, cTaip, cNe, cPPrint, cPFont
private oFont_pagr
private cDef_kl, cFtp_ini
private cRezimas := "0"

private oWnd

cDef_kl := cFilePath( GetModuleFileName( GetInstance() ) )
cFtp_ini := cDef_kl + "op_ftp.ini"

stand_uzr()

SetHandleCount( 100 )

SET MULTIPLE ON
SET SCOREBOARD OFF
SET EXCLUSIVE OFF
SET DELETED ON

SET CENTURY ON
SET DATE ANSI
SET EPOCH TO 1999
SET DATE FORMAT TO "YYYY.MM.DD"
SET CONFIRM ON
SET ESCAPE ON
SET WRAP ON

SET DEFAULT TO &cDef_kl

if round( nVerRes, -2 )  == 600
   DEFINE FONT oFont_pagr NAME "MS SANS SERIF" SIZE 0, -8
  elseif round( nVerRes, -2 )  == 480
   DEFINE FONT oFont_pagr NAME "MS SANS SERIF" SIZE 0, -4
  else
   DEFINE FONT oFont_pagr NAME "MS SANS SERIF" SIZE 0, -10
endif
ACTIVATE FONT oFont_pagr

if !file( cFtp_ini )
   create_ini()
endif
private cFsrv := alltrim( GetPvProfString( "main", "FTP_serv",, cFtp_ini ) )
private cFpth := alltrim( GetPvProfString( "main", "FTP_path",, cFtp_ini ) )
private cFusr := alltrim( GetPvProfString( "main", "FTP_user",, cFtp_ini ) )
private cFpsw := alltrim( GetPvProfString( "main", "FTP_pasw",, cFtp_ini ) )
private cFzip := alltrim( GetPvProfString( "main", "FTP_file",, cFtp_ini ) )

private cFailas := substr( cFzip, 1, at( ".", cFzip ) - 1 )
private cOper_df := cDef_kl + cFailas + ".dbf"
private cOper_zf := cDef_kl + cFailas + ".zip"
private cOper_sm := cDef_kl + cOpfp

if empty( cFsrv ) .or. empty( cFzip ) .or. empty( cFpth )
   MsgInf( "None of needfuls FTP parameters !", 2 )
   clear all
   quit
endif

DEFINE WINDOW oWnd FROM 100, 100 TO nVerRes / 2, nHorRes / 2 PIXEL ;
TITLE "Sending oper.reminder" MDI

SET MESSAGE OF oWnd TO "Sending through FTP" DATE TIME KEYBOARD

ACTIVATE WINDOW oWnd ON INIT suformavimas() ICONIZED

clear all
return( NIL )

static procedure suformavimas
dbcloseall()

suform()

dbcloseall()
oWnd:End()
return( NIL )

static procedure suform

dbcloseall()

ferase( cOper_zf )
zipas()

dbcloseall()

if file( cOper_zf )
   if FtpPut()
      MsgWait( "All is OK !", "Sended !", 3 )
     else
      MsgInf( "Unsuccessfull ... !", 2 )
   endif
  else
   MsgInf( "Can't find file - " + cOper_zf + " - !", 2 )
endif
return( NIL )

static function FtpPut
private lFtp_ret := .f.
private cMsg   := "Failo - " + cFzip + " - uzkrovimas i FTP ..."
private cTitle := "FTP uzkrova"

MsgMeter( { |oMeter, oText, oDlg, lEnd| ;
    ftp_write( oMeter, oText, oDlg, @lEnd ) }, cMsg, cTitle )

return( lFtp_ret )

static function ftp_write( oMeter, oText, oDlg, lEnd )
local nBufSize := 50000
oFTP := qFTPClient():New( cFsrv,,,, cFusr, cFpsw )
oFTP:lPassive := .F.

if oFTP:Connect()

   oFTP:Cd( cFpth )   // Go to needful dir .
   oFTP:Stor( cOper_zf, cFzip, { |n| oMeter:Set( n ), SysRefresh() }, oMeter )
   oFTP:Quit()
   oFTP:End()
   Memory( -1 )
   lFtp_ret := .t.

  else

   Msginf( "Can't connect to FTP !", 2 )

endif
return( NIL )

static procedure create_ini
local oIni
local cF_serv := "ftp_server"
local cF_path := "someone"
local cF_user := "user"
local cF_pasw := "pasw"
local cF_file := "uab_ol.zip"
INI oIni FILE cFtp_ini
   SET SECTION "main" ENTRY "FTP_serv" TO cF_serv OF oIni
   SET SECTION "main" ENTRY "FTP_path" TO cF_path OF oIni
   SET SECTION "main" ENTRY "FTP_user" TO cF_user OF oIni
   SET SECTION "main" ENTRY "FTP_pasw" TO cF_pasw OF oIni
   SET SECTION "main" ENTRY "FTP_file" TO cF_file OF oIni
ENDINI
return( NIL )

static procedure zipas()
local cZip_command := cFzip + " " + cFailas + ".dbf"
ZipFile( cZip_command, oWnd:hWnd )
Memory( -1 )
return( NIL )