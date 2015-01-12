#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Ventas FROM DocumentoSerializable
   
   DATA oViewEdit

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD getDataBrowse( Name )     INLINE ( hGet( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD ChangeSerieTablet( getSerie )

   METHOD lValidCliente()

   METHOD lValidDireccion()

   METHOD ChangeRuta()

   METHOD NextClient()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS Ventas
   
   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::nView              := D():CreateView()

   D():PedidosClientes( ::nView )

   D():PedidosClientesLineas( ::nView )

   D():AlbaranesClientes( ::nView )

   D():AlbaranesClientesLineas( ::nView )

   D():TiposIva( ::nView )

   D():Divisas( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles()
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS Ventas

   D():DeleteView( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD isChangeSerieTablet( getSerie ) CLASS Ventas
   
   if hGet( ::hDictionaryMaster, "Envio" )
      ::ChangeSerieTablet( getSerie )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeSerieTablet( getSerie ) CLASS Ventas

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidCliente() CLASS Ventas

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lValidDireccion() CLASS Ventas

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ChangeRuta() CLASS Ventas

   ?"Cambio las rutas"

Return ( self )

//--------------------------------------------------------------------------------

METHOD NextClient() CLASS Ventas

   ?"Cambio los clientes"

Return ( self )

//---------------------------------------------------------------------------//