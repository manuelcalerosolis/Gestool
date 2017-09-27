#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS GroupCustomer FROM Editable

   DATA oGridGroupCustomer

   METHOD New()

   METHOD Init( oSender )

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD setEnviroment()              INLINE ( ::setDataTable( "GrpCli" ) ) 

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS GroupCustomer

   if ::OpenFiles()
      ::setEnviroment()
   end if   

Return ( self )

//---------------------------------------------------------------------------//

METHOD Init( oSender ) CLASS GroupCustomer

   ::nView                                   := oSender:nView

   ::oGridGroupCustomer                      := GroupCustomerViewSearchNavigator():New( self )
   ::oGridGroupCustomer:setSelectorMode()
   ::oGridGroupCustomer:setTitleDocumento( "Seleccione grupo de cliente" )
   ::oGridGroupCustomer:setDblClickBrowseGeneral( {|| ::oGridGroupCustomer:endView() } )

   ::setEnviroment()

Return ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS GroupCustomer

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():GrupoClientes( ::nView )

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