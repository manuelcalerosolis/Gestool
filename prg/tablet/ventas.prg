#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS Ventas FROM DocumentoSerializable
   
   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD Resource()

   METHOD DialogResize()

   METHOD InitDialog()

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

METHOD Resource( nMode ) CLASS Ventas

   msgInfo( "resource" )

   ::oDlg           := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., ::Style,, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )  

   Msginfo( nMode, "nMode" )

   ::oDlg:bResized  := {|| ::DialogResize() }

   ::oDlg:Activate( ,,,.t.,,, {|| ::InitDialog() } )

   msgInfo( "fin resource" )

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD DialogResize() CLASS Ventas

   GridResize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//

METHOD InitDialog() CLASS Ventas

   GridMaximize( ::oDlg )

Return ( self )

//---------------------------------------------------------------------------//