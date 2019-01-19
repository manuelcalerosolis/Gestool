#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionAlmacenLineasController FROM OperacionesLineasController

   METHOD loadedBlankBuffer()

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloPrecio()

   METHOD updateArticuloUnidades( oCol, uValue )

   METHOD getUnidadMedicion( cCodigoArticulo ) ;
                                       INLINE ( SQLUnidadesMedicionOperacionesModel():getUnidadInventarioWhereArticulo( cCodigoArticulo ) )

   METHOD validLine()                  VIRTUAL
   
   METHOD getModel()                   VIRTUAL  

   METHOD getBrowseView()              VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS OperacionAlmacenLineasController

RETURN ( ::setModelBuffer( 'unidad_medicion_codigo', UnidadesMedicionGruposLineasRepository():getCodigoDefault() ) )

//---------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo ) CLASS OperacionAlmacenLineasController

   cursorWait()

   ::stampArticuloCodigoNombre( hArticulo )

   ::stampArticuloUnidadMedicion()

   ::stampArticuloPrecio()

   ::oController:calculateTotals()

   cursorWE()
   
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD updateArticuloUnidades( oCol, uValue ) CLASS OperacionAlmacenLineasController

   ::updateField( 'articulo_unidades', uValue )

   ::getBrowseView():makeTotals( oCol )

RETURN ( ::oController:calculateTotals() )

//---------------------------------------------------------------------------//

METHOD stampArticuloPrecio() CLASS OperacionAlmacenLineasController

   local nPrecioBase    := SQLArticulosModel():getFieldWhere( "precio_costo", { "codigo" => ::getRowSet():fieldget( "articulo_codigo" ) } )

   if hb_isnumeric( nPrecioBase )
      ::updateField( 'articulo_precio', nPrecioBase )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ConsolidacionAlmacenLineasController FROM OperacionAlmacenLineasController

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLConsolidacionesAlmacenesLineasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := ConsolidacionAlmacenLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD validLine() CLASS ConsolidacionAlmacenLineasController

   if empty( ::getRowSet():fieldget( 'articulo_codigo' ) )
      RETURN ( .t. )
   end if 

   if !( ::validLineLote() )
      RETURN ( .f. )
   end if

   if !( ::validLineCombinacion() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacion() )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS MovimientoAlmacenLineasController FROM OperacionAlmacenLineasController

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLMovimientosAlmacenesLineasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := MovimientoAlmacenLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD postValidateUbicacionOrigenCodigo( oCol, uValue, nKey, cField ) ;
                                       INLINE ( ::postValidateUbicacionCodigo( oCol, uValue, nKey, "ubicacion_origen_codigo" ) )  

   METHOD postValidateUbicacionDestinoCodigo( oCol, uValue, nKey, cField ) ;
                                       INLINE ( ::postValidateUbicacionCodigo( oCol, uValue, nKey, "ubicacion_destino_codigo" ) )  

   METHOD validLineUbicacionOrigen()   INLINE ( ::validLineUbicacion( 'ubicacion_origen_codigo' ) )

   METHOD validLineUbicacionDestino()  INLINE ( ::validLineUbicacion( 'ubicacion_destino_codigo' ) )

   METHOD validLine()

END CLASS

//---------------------------------------------------------------------------//

METHOD validLine() CLASS MovimientoAlmacenLineasController

   if empty( ::getRowSet():fieldget( 'articulo_codigo' ) )
      RETURN ( .t. )
   end if 

   if !( ::validLineLote() )
      RETURN ( .f. )
   end if

   if !( ::validLineCombinacion() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacionOrigen() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacionDestino() )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
