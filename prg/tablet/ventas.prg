#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Ventas FROM Editable

   METHOD OpenFiles()
   METHOD CloseFiles()

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

   D():Clientes( ::nView )

   D():ClientesDirecciones( ::nView )

   D():Articulos( ::nView )

   D():ArticulosCodigosBarras( ::nView )

   D():ProveedorArticulo( ::nView )

   D():Proveedores( ::nView )

   D():Familias( ::nView )

   D():ImpuestosEspeciales( ::nView )

   D():Kit( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      ApoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

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

