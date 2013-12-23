#ifndef __PDA__
#include "FiveWin.Ch"
#include "Struct.ch"
#else
#include "FWCE.ch"
REQUEST DBFCDX
#endif
#include "Factu.ch" 
#include "Ini.ch"

//----------------------------------------------------------------------------//

CLASS TSenderReciverItem

   DATA  cText

   DATA  oSender

   DATA  lSelectSend
   DATA  lSelectRecive

   DATA  nNumberSend       INIT     0
   DATA  nNumberRecive     INIT     0

   DATA  cIniFile

   DATA  cFileName

   DATA  lSuccesfullSend

   Method New()

   Method CreateData()     VIRTUAL

   Method RestoreData()    VIRTUAL

   Method SendData()       VIRTUAL

   Method ReciveData()     VIRTUAL

   Method Process()        VIRTUAL

   Method Save()

   Method Load()

   Method nGetNumberToSend()

   Method SetNumberToSend()   INLINE   WritePProString( "Numero", ::cText, cValToChar( ::nNumberSend ), ::cIniFile )

   Method IncNumberToSend()   INLINE   WritePProString( "Numero", ::cText, cValToChar( ++::nNumberSend ), ::cIniFile )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cText, oSender )

   ::cText           := cText
   ::oSender         := oSender
   ::cIniFile        := cPatEmp() + "Empresa.Ini"
   ::lSuccesfullSend := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Save()

   WritePProString( "Envio",     ::cText, cValToChar( ::lSelectSend ), ::cIniFile )
   WritePProString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load()

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio", ::cText, cValToChar( ::lSelectSend ), ::cIniFile ) ) == ".T." )
   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::cText, cValToChar( ::lSelectRecive ), ::cIniFile ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//

Method nGetNumberToSend()

   ::nNumberSend     := GetPvProfInt( "Numero", ::cText, ::nNumberSend, ::cIniFile )

Return ( ::nNumberSend )

//----------------------------------------------------------------------------//