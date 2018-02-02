#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ExportableController 

   DATA oController

   DATA lSelectSend

   DATA lSelectRecive

   DATA cZipFile

   METHOD New( oController )

   METHOD Load()   

   METHOD Save()

   METHOD getTitle()                   INLINE ( ::oController:getTitle() )
   METHOD cText()                      INLINE ( ::getTitle() )

   METHOD setSelectSend( lSelect )     INLINE ( ::lSelectSend := lSelect )
   METHOD getSelectSend()              INLINE ( ::lSelectSend )

   METHOD setSelectRecive( lSelect )   INLINE ( ::lSelectRecive := lSelect )
   METHOD getSelectRecive()            INLINE ( ::lSelectRecive )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Save()

   WritePProString( "Envio",     ::getTitle(), cValToChar( ::lSelectSend ), cIniEmpresa() )

   WritePProString( "Recepcion", ::getTitle(), cValToChar( ::lSelectRecive ), cIniEmpresa() )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Load()

   ::lSelectSend     := ( Upper( GetPvProfString( "Envio", ::getTitle(), cValToChar( ::lSelectSend ), cIniEmpresa() ) ) == ".T." )

   ::lSelectRecive   := ( Upper( GetPvProfString( "Recepcion", ::getTitle(), cValToChar( ::lSelectRecive ), cIniEmpresa() ) ) == ".T." )

RETURN ( Self )

//----------------------------------------------------------------------------//
