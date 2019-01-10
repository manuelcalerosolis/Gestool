#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenLineasController FROM OperacionesLineasController

   METHOD loadedBlankBuffer()

   METHOD stampArticulo( hArticulo )

   METHOD updateArticuloUnidades( oCol, uValue )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLConsolidacionesAlmacenesLineasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := ConsolidacionAlmacenLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ConsolidacionAlmacenLineasController

   ::setModelBuffer( 'unidad_medicion_codigo', UnidadesMedicionGruposLineasRepository():getCodigoDefault() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo ) CLASS ConsolidacionAlmacenLineasController

   cursorWait()

   ::stampArticuloCodigoNombre( hArticulo )

   ::stampArticuloUnidadMedicionVentas()

   ::stampArticuloPrecio()

   ::oController:calculateTotals()

   cursorWE()
   
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD updateArticuloUnidades( oCol, uValue ) CLASS ConsolidacionAlmacenLineasController

   ::updateField( 'articulo_unidades', uValue )

   ::getBrowseView():makeTotals( oCol )

RETURN ( ::oController:calculateTotals() )

//---------------------------------------------------------------------------//

METHOD validLine() CLASS ConsolidacionAlmacenLineasController

   if empty( ::getRowSet():fieldget( 'articulo_codigo' ) )
      RETURN ( .t. )
   end if 

   if !( ::validLineCombinacion() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacion() )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//


