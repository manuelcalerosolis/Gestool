#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasController FROM SQLBaseController

   METHOD New( oController )

   METHOD Activate()    INLINE ( ::oDialogView:Activate() )

   METHOD importarAlmacen()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportadorMovimientosAlmacenLineasView():New( self )

   ::oValidator         := ImportadorMovimientosAlmacenLineasValidator():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD importarAlmacen()

   local cArea          := "ArtToImport"

   ArticulosModel():getArticulosToImport( @cArea, ::oDialogView:getRange() )

   ::oDialogView:oMtrStock:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      ::oDialogView:oMtrStock:autoInc()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

RETURN ( Self )

//---------------------------------------------------------------------------//

