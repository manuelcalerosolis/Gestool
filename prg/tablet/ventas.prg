#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Ventas FROM DocumentoSerializable
   
   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD aItemsBusqueda() INLINE ( { "Número", "Fecha", "Código", "Nombre" } )

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

   D():AlbaranesClientes( ::nView )

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