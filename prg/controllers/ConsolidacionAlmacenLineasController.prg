#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenLineasController FROM OperacionesLineasController

   METHOD loadedBlankBuffer()

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloPrecio()

   METHOD updateArticuloUnidades( oCol, uValue )

   METHOD validLine()

   METHOD getUnidadMedicion( cCodigoArticulo ) ;
                                       INLINE ( SQLUnidadesMedicionOperacionesModel():getUnidadInventarioWhereArticulo( cCodigoArticulo ) )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLConsolidacionesAlmacenesLineasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := ConsolidacionAlmacenLineasBrowseView():New( self ), ), ::oBrowseView ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ConsolidacionAlmacenLineasController

   ::setModelBuffer( 'unidad_medicion_codigo', UnidadesMedicionGruposLineasRepository():getCodigoDefault() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo ) CLASS ConsolidacionAlmacenLineasController

   cursorWait()

   ::stampArticuloCodigoNombre( hArticulo )

   ::stampArticuloUnidadMedicion()

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

METHOD stampArticuloPrecio() CLASS ConsolidacionAlmacenLineasController

   local nPrecioBase    := SQLArticulosModel():getFieldWhere( "precio_costo", { "codigo" => ::getRowSet():fieldget( "articulo_codigo" ) } )

   if hb_isnumeric( nPrecioBase )
      ::updateField( 'articulo_precio', nPrecioBase )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//



