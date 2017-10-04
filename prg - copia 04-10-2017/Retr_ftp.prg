
#include "FiveWin.Ch"
#include "qFtp.ch"

// This is another side of program in divisions of enterprise .
// Here I'm downloading oper.reminder and renewing reminder of goods .

REQUEST DBFCDX

function Main()

   local i := n := j := 0
   local cStr := cStr1 := ""
   local aDb_cr := {}
   local cTitl := "Palaukite , duomenu atnaujinimas ... "

   RDDSETDEFAULT( cDriver() )

   private cLg := "L"
   private cDef_kl := cFilePath( GetModuleFileName( GetInstance() ) )

   SET DEFAULT TO &cDef_kl

   private oFont_pagr
   private nHorRes := GetSysMetric( 0 )
   private nVerRes := GetSysMetric( 1 )

   SetHandleCount( 100 )

   SET MULTIPLE ON
   SET SCOREBOARD OFF
   SET EXCLUSIVE OFF
   SET DELETED ON

   SET CENTURY ON
   SET DATE ANSI
   SET EPOCH TO 2000
   SET DATE FORMAT TO "YYYY.MM.DD"

   SET CONFIRM ON
   SET ESCAPE ON
   SET WRAP ON

   if round( nVerRes, -2 ) == 600
      DEFINE FONT oFont_pagr NAME "MS SANS SERIF" SIZE 0, -8
     elseif round( nVerRes, -2 ) == 480
      DEFINE FONT oFont_pagr NAME "MS SANS SERIF" SIZE 0, -4
     else
      DEFINE FONT oFont_pagr NAME "MS SANS SERIF" SIZE 0, -10
   endif
   ACTIVATE FONT oFont_pagr

   private cSave, cGerai, cCancel, cCont, cTaip, cNe, cPPrint, cPFont

   stand_uzr()

   private cFtp_ini := cDef_kl + "op_at.ini"
   private cFserv := alltrim( GetPvProfString( "main", "FTP_serv",, cFtp_ini ) )
   private cFpath := alltrim( GetPvProfString( "main", "FTP_path",, cFtp_ini ) )
   private cFuser := alltrim( GetPvProfString( "main", "FTP_user",, cFtp_ini ) )
   private cFpasw := alltrim( GetPvProfString( "main", "FTP_pasw",, cFtp_ini ) )
   private cFzip  := alltrim( GetPvProfString( "main", "FTP_file",, cFtp_ini ) )
   private cFailas := cDef_kl + cFzip
   private cFdbf := cDef_kl + "uab_ol.dbf"
   private cFile := substr( cFzip, 1, at( ".", cFzip ) - 1 )

   if empty( cFserv ) .or. empty( cFzip ) .or. empty( cFpath )
      MsgWait( "Can't find needful FTP parameters !", "Warning !" )
      dbcloseall()
      return( NIL )
   endif

   dbcloseall()

   private oWnd

   DEFINE WINDOW oWnd FROM 100, 100 TO nVerRes / 2, nHorRes / 2 PIXEL ;
   TITLE "Renew of oper.reminder" MDI

   SET MESSAGE OF oWnd TO "Renew through FTP" DATE TIME KEYBOARD

   ACTIVATE WINDOW oWnd ON INIT atnaujinti() ICONIZED

   oFont_pagr:End()
   clear all

return( NIL )

static procedure atnaujinti
SysRefresh()
CursorWait()

dbcloseall()

suform()

dbcloseall()

CursorArrow()
SysRefresh()
oWnd:End()
return( NIL )

static procedure suform
if !FTPGetFile()
   return( NIL )
endif
if !archyvas()
   return( NIL )
endif
if !duom_atnauj() // This is my functions ...
   return( NIL )
endif
MsgWait( "Renew successfull !", "Message !", 2 )
return( NIL )

static function FtpGetFile()
private lFtp_ret := .f.
if file( cFailas )
   if ferase( cFailas ) == -1
      MsgWait( "Can't delete old file !", "Warning !", 2 )
      return( .f. )
   endif
endif
MsgMeter({ |oMeter, oText, oDlg, lEnd, oBtn| ;
FTPGet( oMeter ) }, "Download of file - " + cFzip + " - from FTP server", ;
"Renew of oper.reminder ..." )
return( lFtp_ret )

static function FTPGet( oMeter )
local nFileSize := FtpFSize()  // At first read size of file ...
local oFTP
if nFileSize > 0
   oFTP := qFTPClient():New( cFserv,,,, cFuser, cFpasw )
   oFTP:lPassive := .F.
   oMeter:SetTotal( nFileSize )
   if oFTP:Connect()
      oFtp:Cd( cFpath )
      oFTP:Retr( cFzip, cFailas, nFileSize, oMeter )
      oFTP:Quit()
      oFTP:End()
      lFtp_ret := .t.
     else
      MsgWait( "Can't connect to FTP !", "Warning !", 2 )
   endif
endif
return( lFtp_ret )

static function FtpFSize
local nSize := 0
local oFTP
local cStr := ""
begin sequence
   oFTP := qFTPClient():New( cFserv,,,, cFuser, cFpasw )
   oFTP:lPassive := .F.
   if oFTP:Connect()
      oFTP:Cd( cFpath )
      oFTP:DIR( cFzip )
      if len( oFTP:acDir ) > 1
         MsgStop( "FTP directory too many files ...", "QFTP" )
         BREAK
        elseif len( oFtp:acDir ) < 1
         MsgStop( "Can't find needful file ...", "QFTP" )
         BREAK
        else
	 n := at( cFzip, oFTP:acDir[ 1 ] )
	 if n # 0
            nSize := val( alltrim( substr( oFTP:acDir[ 1 ], n - 23, 10 ) ) )
	 endif
      endif
      oFTP:Quit()
      oFTP:End()
     else
      MsgWait( "Can't connect to FTP server ...", "Warning !", 2 )
   endif
end sequence
return( nSize )

static function archyvas
if file( cFzip )
   if file( cFdbf )
      if ferase( cFdbf ) == -1
         MsgWait( "Can't delete old file !", "Warining !", 2 )
	 return( .f. )
      endif
   endif
   if UnZipFile( cFzip, cFdbf,, oWnd:hWnd ) == 0
      Memory( -1 )
      dbcloseall()
      if !file( cFdbf )
         MsgBeep()
         MsgInf( if( cLg == "L", "Nesekmingas isarchivavimas !", ;
         "UnZip unsuccesfull !" ), 2 )
         return( .f. )
      endif
     else
      MsgInf( if( cLg == "L", "Nesekmingas isarchivavimas !", ;
      "UnZip command unsuccesfull !" ), 2 )
      return( .f. )
   endif
endif
return( .t. )

static procedure stand_uzr
cSave := if( cLg == "L", "Irasyti", "Save" )
cGerai := if( cLg == "L", "Gerai", "OK" )
cCancel := if( cLg == "L", "Atsisakyti", "Cancel" )
cCont := if( cLg == "L", "Testi", "Continue" )
cTaip := if( cLg == "L", "Taip", "Yes" )
cNe := if( cLg == "L", "Ne", "No" )
cPPrint := if( cLg == "L", "Printerio parametrai", "Printer setup" )
return( NIL )