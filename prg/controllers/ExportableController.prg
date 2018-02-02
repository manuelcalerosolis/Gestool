#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ExportableController 

   DATA oController

   DATA lSelectSend

   METHOD setSelectSend( lSelect )     INLINE ( ::lSelectSend := lSelect )
   METHOD getSelectSend()              INLINE ( ::lSelectSend )

   DATA lSelectRecive

   METHOD setSelectRecive( lSelect )   INLINE ( ::lSelectRecive := lSelect )
   METHOD getSelectRecive()            INLINE ( ::lSelectRecive )

   DATA cZipFile

   METHOD setZipFile( cZipFile )       INLINE ( ::cZipFile := cZipFile )
   METHOD getZipFile()                 INLINE ( ::cZipFile )

   METHOD New( oController )

   METHOD Load()   

   METHOD Save()

   METHOD isSendData( oInternet )

   METHOD getTitle()                   INLINE ( ::oController:getTitle() )
   METHOD cText()                      INLINE ( ::getTitle() )

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

METHOD isSendData( oInternet )

   if !file( ::getZipFile() )
      RETURN ( .f. )
   end if 

   if oInternet:SendFiles( ::getZipFile() )
      oInternet:SetText( "Ficheros de artículos enviados " + ::getZipFile() )
      RETURN ( .t. )
   end if

   oInternet:SetText( "ERROR fichero de artículos no enviado" )

RETURN ( .f. )

//----------------------------------------------------------------------------//
