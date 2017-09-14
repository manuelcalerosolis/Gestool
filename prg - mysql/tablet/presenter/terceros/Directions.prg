#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Directions FROM Editable

   DATA oSender
   
   DATA oGridDirections

   DATA idCustomer

   METHOD New()

   METHOD Init( oSender )

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "ObrasT" ) ) 

   METHOD setIdCustomer( id )          INLINE ( ::idCustomer := id )
   METHOD getIdCustomer()              INLINE ( ::idCustomer )

   METHOD putFilter()
   METHOD quitFilter()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS Directions

   if ::OpenFiles()
      ::setEnviroment()
   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS Directions

   ::oSender                                 := oSender

   ::nView                                   := oSender:nView

   ::oGridDirections                         := DirectionsViewSearchNavigator():New( self )
   ::oGridDirections:setSelectorMode()
   ::oGridDirections:setTitleDocumento( "Seleccione dirección de cliente" )
   ::oGridDirections:setDblClickBrowseGeneral( {|| ::oGridDirections:endView() } )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Directions

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():Clientes( ::nView )

      D():ClientesDirecciones( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      ApoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles( "" )
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD putFilter() CLASS Directions

   if lAIS()
      ( D():ClientesDirecciones( ::nView ) )->( adsSetAOF( "Field->cCodCli == '" + ::getIdCustomer() + "'" ) )
   else
      ( D():ClientesDirecciones( ::nView ) )->( dbsetfilter( {|| Field->cCodCli == ::getIdCustomer() }, "cCodCli" ) )
   end if 

   ( D():ClientesDirecciones( ::nView ) )->( dbgotop() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD quitFilter() CLASS Directions

   ( D():ClientesDirecciones( ::nView ) )->( dbsetfilter() )

Return ( self )

//---------------------------------------------------------------------------//
