#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesLineasController FROM OperacionesLineasController

   METHOD loadedBlankBuffer()

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloDescuento()

   METHOD stampArticuloIva()

   METHOD stampArticuloPrecio()

   METHOD updateArticuloUnidades( oCol, uValue )

   METHOD postValidateAgenteCodigo( oCol, uValue, nKey )

   METHOD updateImpuestos( nPorcentajeIva )

   METHOD updateAgenteComision( uValue ) ;
                                       INLINE ( ::updateField( 'agente_comision', uValue ),;
                                                ::oController:calculateTotals() )

   METHOD stampAgente( cCodigoAgente )

   METHOD stampAgenteComision()

   METHOD validAgenteCodigo( oGet, oCol )               

   METHOD getHashAgenteWhereCodigo()

   METHOD validLine()   

   METHOD getUnidadMedicion( cCodigoArticulo ) ;
                                       INLINE ( SQLUnidadesMedicionOperacionesModel():getUnidadVentaWhereArticulo( cCodigoArticulo ) )

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesLineasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := OperacionesComercialesLineasView():New( self ), ), ::oDialogView )

END CLASS

//----------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo ) CLASS OperacionesComercialesLineasController

   cursorWait()

   ::stampArticuloCodigoNombre( hArticulo )

   ::stampArticuloUnidadMedicion()

   ::stampArticuloPrecio()

   ::stampArticuloDescuento()

   ::stampArticuloIva()

   ::oController:calculateTotals()

   cursorWE()
   
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS OperacionesComercialesLineasController

   ::setModelBuffer( 'unidad_medicion_codigo', UnidadesMedicionGruposLineasRepository():getCodigoDefault() )

   ::setModelBuffer( 'almacen_codigo', ::oController:getModelBuffer( 'almacen_codigo' ) )

   ::setModelBuffer( 'agente_codigo', ::oController:getModelBuffer( 'agente_codigo' ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticuloDescuento() CLASS OperacionesComercialesLineasController

   local nDescuento        := SQLArticulosPreciosDescuentosModel():getDescuentoWhereArticuloCodigo( ::getRowSet():fieldGet( 'articulo_codigo' ), ::oController:getModelBuffer( 'tarifa_codigo' ), ::getRowSet():fieldGet( 'total_unidades' ), ::oController:getModelBuffer( 'fecha' ) )

   ::updateField( 'descuento', nDescuento )

RETURN ( ::oController:calculateTotals() )

//---------------------------------------------------------------------------//

METHOD stampArticuloIva() CLASS OperacionesComercialesLineasController

   local nPorcentajeIva     := SQLTiposIvaModel():getIvaWhereArticuloCodigo( ::getRowSet():fieldGet( 'articulo_codigo' ) )

   if hb_isnumeric( nPorcentajeIva )
      ::updateImpuestos( nPorcentajeIva )
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD updateArticuloUnidades( oCol, uValue ) CLASS OperacionesComercialesLineasController

   ::updateField( 'articulo_unidades', uValue )

   ::stampArticuloDescuento()

   ::getBrowseView():makeTotals( oCol )

RETURN ( ::oController:calculateTotals() )

//---------------------------------------------------------------------------//

METHOD updateImpuestos( nPorcentajeIva ) CLASS OperacionesComercialesLineasController

   local nPorcentajeRecargo

   ::updateField( 'iva', nPorcentajeIva )

   nPorcentajeRecargo         := SQLTiposIvaModel():getField( 'recargo', 'porcentaje', nPorcentajeIVA )

   if hb_isnumeric( nPorcentajeRecargo )
      ::updateField( 'recargo_equivalencia', nPorcentajeRecargo )
   end if 

RETURN ( ::oController:calculateTotals() )

//----------------------------------------------------------------------------//

METHOD postValidateAgenteCodigo( oCol, uValue, nKey ) CLASS OperacionesComercialesLineasController

   local cCodigo

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   do case
      case hb_ishash( uValue )
         cCodigo     := hget( uValue, "codigo" )
      case hb_ischar( uValue )
         cCodigo     := uValue
   end case 

   if ::getHistoryManager():isEqual( "agente_codigo", cCodigo )
      RETURN ( .t. )
   end if 

RETURN ( ::stampAgente( cCodigo ) )

//---------------------------------------------------------------------------//

METHOD getHashAgenteWhereCodigo( cCodigo ) CLASS OperacionesComercialesLineasController
   
RETURN ( SQLAgentesModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD stampAgente( cCodigoAgente ) CLASS OperacionesComercialesLineasController

   ::updateField( "agente_codigo", cCodigoAgente )

RETURN ( ::stampAgenteComision() )

//---------------------------------------------------------------------------//

METHOD stampAgenteComision() CLASS OperacionesComercialesLineasController

   local nComision     := SQLAgentesModel():getComisionWhereAgenteCodigo( ::getRowSet():fieldGet( 'agente_codigo' ) )

   if hb_isnumeric( nComision )
      ::updateField( 'agente_comision', nComision )
   end if 

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD validAgenteCodigo( oGet, oCol ) CLASS OperacionesComercialesLineasController

   if SQLAgentesModel():CountAgenteWhereCodigo( oGet:varGet() ) <= 0 

      ::getController():getDialogView():showMessage( "El agente introducido no existe" )      

      RETURN ( .f. )

   end if

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD validLine() CLASS OperacionesComercialesLineasController

   if empty( ::getRowSet():fieldget( 'articulo_codigo' ) )
      RETURN ( .t. )
   end if 

   if !( ::validLineCombinacion() )
      RETURN ( .f. )
   end if

   if !( ::validLineLote() )
      RETURN ( .f. )
   end if

   if !( ::validLineAlmacen() )
      RETURN ( .f. )
   end if

   if !( ::validLineUbicacion() )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloPrecio() CLASS OperacionesComercialesLineasController

   local nPrecioBase    := SQLArticulosPreciosModel():getPrecioBaseWhereArticuloCodigoAndTarifaCodigo( ::getRowSet():fieldget( "articulo_codigo" ), ::oController:getModelBuffer( "tarifa_codigo" ) )

   ::updateField( 'articulo_precio', nPrecioBase )

RETURN ( .t. )

//---------------------------------------------------------------------------//

