#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasController FROM SQLBrowseController

   DATA hArticulo

   DATA oSeriesControler

   DATA oRelacionesEntidades

   DATA oSearchView

   DATA aSelectDelete                  INIT {}

   DATA oUnidadesMedicionController

   DATA oArticulosPreciosDescuentosController

   DATA oCombinacionesController

   DATA oHistoryManager

   METHOD New()

   METHOD End()

   METHOD Edit()                       

   // Validaciones ------------------------------------------------------------

   METHOD validArticuloCodigo( oGet, oCol )

   METHOD postValidateArticuloCodigo( oCol, uValue, nKey )  

   METHOD validColumnNombreArticulo( oCol, uValue, nKey )  

   METHOD postValidateAlmacenCodigo( oCol, uValue, nKey )

   METHOD postValidateAgenteCodigo( oCol, uValue, nKey )

   METHOD validateLote()               

   METHOD validateUnidadMedicion( uValue )

   METHOD validateIva( uValue )
   
   METHOD validAlmacenCodigo( oGet, oCol )

   METHOD validAgenteCodigo( oGet, oCol )

   // Escritura de campos------------------------------------------------------

   METHOD updateField( cField, uValue )   

   METHOD updateImpuestos( uValue )

   // stamps de articulos------------------------------------------------------

   METHOD stampArticulo( hArticulo )

   METHOD stampAlmacen( hAlmacen )

   METHOD stampAgente( hAgente )

   METHOD stampArticuloCodigo( cCodigoArticulo ) ;
                                          INLINE ( ::updateField( "articulo_codigo", cCodigoArticulo ) ) 

   METHOD stampArticuloNombre( cNombreArticulo ) ;
                                          INLINE ( ::updateField( "articulo_nombre", cNombreArticulo ) )

   METHOD stampAlmacenCodigo( cCodigoAlmacen ) ;
                                          INLINE ( ::updateField( "almacen_codigo", cCodigoAlmacen ) )

   METHOD stampAgenteCodigo( cCodigoAgente ) ;
                                          INLINE ( ::updateField( "agente_codigo", cCodigoAgente ) )

   METHOD stampArticuloUnidaMedicionVentas()

   METHOD stampArticuloPrecio()

   METHOD stampArticuloUnidades( uValue )

   METHOD stampArticuloDescuento()

   METHOD getHashArticuloWhereCodigo( cCodigo )

   METHOD getHashAlmacenWhereCodigo( cCodigo )

   METHOD getHashAgenteWhereCodigo( cCodigo )

   METHOD stampArticuloUnidadMedicion( uValue )

   METHOD stampArticuloUnidadMedicionFactor()

   METHOD stampArticuloIva()

   METHOD stampAgenteComision()
   
   // Dialogos-----------------------------------------------------------------

   METHOD runDialogSeries()

   METHOD onActivateDialog()

   METHOD closedDialog() 

   METHOD Search()

   METHOD deleteLines( uuid )

   METHOD getUuid()                    INLINE ( iif(  !empty( ::oModel ) .and. !empty( ::oModel:hBuffer ),;
                                                      hget( ::oModel:hBuffer, "uuid" ),;
                                                      nil ) )

   METHOD refreshBrowse()              INLINE ( iif(  !empty( ::oBrowseView ), ::oBrowseView:Refresh(), ) )


   METHOD loadUnidadesMedicion()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::lTransactional                          := .t.

   ::cTitle                                  := "Facturas clientes líneas"

   ::setName( "lineas_facturas_clientes" )

   ::oModel                                  := SQLFacturasClientesLineasModel():New( self )

   ::oBrowseView                             := FacturasClientesLineasBrowseView():New( self )

   ::oDialogView                             := FacturasClientesLineasView():New( self )

   ::oValidator                              := FacturasClientesLineasValidator():New( self )

   ::oSearchView                             := SQLSearchView():New( self )

   ::oSeriesControler                        := NumerosSeriesController():New( self )

   ::oRelacionesEntidades                    := RelacionesEntidadesController():New( self )

   ::oUnidadesMedicionController             := UnidadesMedicionGruposLineasController():New( self )

   ::oArticulosPreciosDescuentosController   := ArticulosPreciosDescuentosController():New( self )

   ::oCombinacionesController                := CombinacionesController():New( self )

   ::oHistoryManager                         := HistoryManager():New()

   ::setEvent( 'activating',                 {|| ::oModel:setOrderBy( "id" ), ::oModel:setOrientation( "D" ) } )

   ::setEvent( 'closedDialog',               {|| ::closedDialog() } )

   ::setEvent( 'appended',                   {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                     {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',           {|| ::oBrowseView:Refresh() } )

   ::setEvent( 'deletingLines',              {|| ::oSeriesControler:deletedSelected( ::aSelectDelete ) } )

   ::setEvent( 'exitAppended',               {|| ::oBrowseView:selectCol( ::oBrowseView:oColumnCodigo:nPos ) } )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| hSet( ::oModel:hBuffer, "unidad_medicion_codigo", UnidadesMedicionGruposLineasRepository():getCodigoDefault() ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oSearchView:End()

   ::oSeriesControler:End()

   ::oRelacionesEntidades:End()

   ::oUnidadesMedicionController:End()

   ::oCombinacionesController:End()

   ::oHistoryManager:End()

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validArticuloCodigo( oGet, oCol )

   local uValue   := oGet:varGet()

   if empty( uValue )
      RETURN ( .t. )
   end if 

RETURN ( ::validate( "articulo_codigo", uValue ) )

//---------------------------------------------------------------------------//

METHOD validAlmacenCodigo( oGet, oCol )

   local uValue   := oGet:varGet()

   if SQLAlmacenesModel():CountAlmacenWhereCodigo( uValue ) <= 0 
      msgStop( "El almacén introducido no existe" )
      RETURN( .f. )
   end if
   ::updateField ( 'almacen_codigo', uValue)

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD validAgenteCodigo( oGet, oCol )

   local uValue   := oGet:varGet()

   if SQLAgentesModel():CountAgenteWhereCodigo( uValue ) <= 0 
      msgStop( "El agente introducido no existe" )
      RETURN( .f. )
   end if
   ::updateField ( 'agente_codigo', uValue)
   ::stampAgenteComision()

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD postValidateArticuloCodigo( oCol, uValue, nKey )

   local hArticulo 

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if hb_ishash( uValue )
      if ::oHistoryManager:isEqual( "articulo_codigo", hget( uValue, "codigo" ) )
         RETURN ( .f. )
      end if          
      RETURN ( ::stampArticulo( uValue ) )
   end if 

   if !hb_ischar( uValue )
      RETURN ( .f. )
   end if 

   if ::oHistoryManager:isEqual( "articulo_codigo", uValue )
      RETURN ( .f. )
   end if          

   hArticulo   := ::getHashArticuloWhereCodigo( uValue )
   if empty( hArticulo )
      RETURN ( .f. )
   end if 

RETURN ( ::stampArticulo( hArticulo ) )

//---------------------------------------------------------------------------//

METHOD postValidateAlmacenCodigo( oCol, uValue, nKey )

   local hAlmacen

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if hb_ishash( uValue )
      if ::oHistoryManager:isEqual( "almacen_codigo", hget( uValue, "codigo" ) )
         RETURN ( .f. )
      end if          
      RETURN ( ::stampAlmacen( uValue ) )
   end if 

   if !hb_ischar( uValue )
      RETURN ( .f. )
   end if 

   if ::oHistoryManager:isEqual( "almacen_codigo", uValue )
      RETURN ( .f. )
   end if          

   hAlmacen   := ::getHashAlmacenWhereCodigo( uValue )
   if empty( hAlmacen )
      RETURN ( .f. )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD postValidateAgenteCodigo( oCol, uValue, nKey )

   local hAgente

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if hb_ishash( uValue )
      if ::oHistoryManager:isEqual( "agente_codigo", hget( uValue, "codigo" ) )
         RETURN ( .f. )
      end if          
      RETURN ( ::stampAgente( uValue ) )
   end if 

   if !hb_ischar( uValue )
      RETURN ( .f. )
   end if 

   if ::oHistoryManager:isEqual( "agente_codigo", uValue )
      RETURN ( .f. )
   end if          
   
   hAgente   := ::getHashAgenteWhereCodigo( uValue )
   
   if empty( hAgente )
      RETURN ( .f. )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getHashArticuloWhereCodigo( cCodigo )
   
RETURN ( SQLArticulosModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD getHashAlmacenWhereCodigo( cCodigo )
   
RETURN ( SQLAlmacenesModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD getHashAgenteWhereCodigo( cCodigo )
   
RETURN ( SQLAgentesModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD updateField( cField, uValue )

   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue )
   
   ::getRowSet():Refresh()
   
   ::oBrowseView:Refresh()
   
   ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo )

   cursorWait()

   ::stampArticuloCodigo( hget( hArticulo, "codigo" ) )

   ::stampArticuloNombre( hget( hArticulo, "nombre" ) )

   ::stampArticuloUnidaMedicionVentas()

   ::stampArticuloPrecio()

   ::stampArticuloDescuento()

   ::stampArticuloIva()

   ::oSenderController:calculateTotals()

   cursorWE()
   
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAlmacen( hAlmacen )

   ::stampAlmacenCodigo( hget( hAlmacen, "codigo" ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAgente( hAgente )

   ::stampAgenteCodigo( hget( hAgente, "codigo" ) )

   ::stampAgenteComision()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validColumnNombreArticulo( oCol, uValue, nKey ) 

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if !( ::validate( "articulo_nombre", uValue ) )
      RETURN .f.
   end if 

RETURN ( ::stampArticuloNombre( uValue ) )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidaMedicionVentas()

   local cUnidadMedicion   

   // Unidad de medición para ventas de este articulo--------------------------

   cUnidadMedicion         := SQLUnidadesMedicionOperacionesModel():getUnidadVentaWhereArticulo( ::getRowSet():fieldGet( 'articulo_codigo' ) ) 

   if !empty( cUnidadMedicion )
      RETURN ( ::stampArticuloUnidadMedicion( cUnidadMedicion ) )
   end if 

   // Unidad de medición menor para este articulo de su grupo de unidades------

   cUnidadMedicion         := UnidadesMedicionGruposLineasRepository():getUnidadDefectoWhereArticulo( ::getRowSet():fieldGet( 'articulo_codigo' ) ) 

   if !empty( cUnidadMedicion )
      RETURN ( ::stampArticuloUnidadMedicion( cUnidadMedicion ) )
   end if 

   // Unidad de medición menor en el grupo de la empresa-----------------------

   cUnidadMedicion         := UnidadesMedicionGruposLineasRepository():getWhereEmpresa()

   if !empty( cUnidadMedicion )
      RETURN ( ::stampArticuloUnidadMedicion( cUnidadMedicion ) )
   end if 

   // Unidad de medición del sistema-------------------------------------------

   cUnidadMedicion         := SQLUnidadesMedicionModel():getUnidadMedicionSistema()

   if !empty( cUnidadMedicion )
      RETURN ( ::stampArticuloUnidadMedicion( cUnidadMedicion ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidades( oCol, uValue )

   ::updateField( 'articulo_unidades', uValue )

   ::stampArticuloDescuento()

   ::oBrowseView:makeTotals( oCol )

   ::oSenderController:calculateTotals()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloDescuento()

   local nDescuento     := SQLArticulosPreciosDescuentosModel():getDescuentoWhereArticuloCodigo( ::getRowSet():fieldGet( 'articulo_codigo' ), ::oSenderController:getModelBuffer( 'tarifa_codigo' ), ::getRowSet():fieldGet( 'total_unidades' ), ::oSenderController:getModelBuffer( 'fecha' ) )

   ::updateField( 'descuento', nDescuento )

   ::oSenderController:calculateTotals()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloPrecio()

   local nPrecioBase    := SQLArticulosPreciosModel():getPrecioBaseWhereArticuloCodigoAndTarifaCodigo( ::getRowSet():fieldget( "articulo_codigo" ), ::oSenderController:getModelBuffer( "tarifa_codigo" ) )

   ::updateField( 'articulo_precio', nPrecioBase )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedicion( uValue )
      
   ::updateField( 'unidad_medicion_codigo', uValue )

   ::stampArticuloUnidadMedicionFactor()

   ::oSenderController:calculateTotals() 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedicionFactor()
      
   local nFactor  := UnidadesMedicionGruposLineasRepository():getFactorWhereUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ), ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) ) 

   if nFactor > 0
      
      ::updateField( 'unidad_medicion_factor', nFactor )

      ::stampArticuloDescuento()
      
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD stampArticuloIva()

   local nPorcentajeIva     := SQLTiposIvaModel():getIvaWhereArticuloCodigo( ::getRowSet():fieldGet( 'articulo_codigo' ) )

   if hb_isnumeric( nPorcentajeIva )
      ::updateImpuestos( nPorcentajeIva )
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD stampAgenteComision()

   local nComision     := SQLAgentesModel():getComisionWhereAgenteCodigo( ::getRowSet():fieldGet( 'agente_codigo' ) )

   if hb_isnumeric( nComision )
      ::updateField( 'agente_comision', nComision )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD updateImpuestos( nPorcentajeIva )

   local nPorcentajeRecargo

   ::updateField( 'iva', nPorcentajeIva )

   nPorcentajeRecargo         := SQLTiposIvaModel():getField( "recargo", "porcentaje", nPorcentajeIVA )
   
   msgalert( nPorcentajeRecargo, "nPorcentajeRecargo" )

   if hb_isnumeric( nPorcentajeRecargo )
      ::updateField( "recargo_equivalencia", nPorcentajeRecargo )
   end if 

   ::oSenderController:calculateTotals() 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD validateLote()

   local cLote

   cLote       := ::getModelBuffer( "lote" )
   if empty( cLote )
      RETURN ( .t. )
   end if  

   if !( ::oDialogView:oGetLote:isOriginalChanged( cLote ) )
      RETURN ( .t. )
   end if 

   ::oDialogView:oGetLote:setOriginal( cLote )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD onActivateDialog()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD closedDialog()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runDialogSeries()

   if Empty( ::oDialogView:nTotalUnidadesArticulo() )
      msgStop( "El número de unidades no puede ser 0 para editar números de serie" )
      RETURN ( .f. )
   end if

   ::oSeriesControler:SetTotalUnidades( ::oDialogView:nTotalUnidadesArticulo() )

   ::oSeriesControler:Edit( hget( ::oModel:hBuffer, "id" ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Search()

   ::oSearchView:Activate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteLines( uuid )

   ::aSelectDelete  := ::oModel:aRowsDeleted( uuid )

   ::fireEvent( 'deletingLines' )

   ::oModel:deleteWhereUuid( uuid )

   ::fireEvent( 'deletedLines' )
 
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Edit()

   local nId
   local cCodigoArticulo   := ::getRowSet():fieldGet( 'articulo_codigo' )

   if empty( cCodigoArticulo )
      RETURN ( nil )
   end if 

   nId                     := ::oSenderController:oArticulosController:oModel:getIdWhereCodigo( cCodigoArticulo )
   if empty( nId )
      RETURN ( nil )
   end if 

RETURN ( ::oSenderController:oArticulosController:Edit( nId ) )

//----------------------------------------------------------------------------//

METHOD loadUnidadesMedicion()

   ::oBrowseView:oColumnUnidadMedicion:aEditListTxt := UnidadesMedicionGruposLineasRepository():getCodigos( ::getRowSet():fieldGet( 'articulo_codigo' ) )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD validateUnidadMedicion( uValue )

   local cValue   := uValue:VarGet()

   if !( hb_ischar( cValue ) )
      RETURN ( .f. )
   end if 

   if !( ::validate( "unidad_medicion_codigo", cValue ) )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD validateIva( uValue )

   local nPorcentajeIVA                  
   local nPorcentajeRecargo

   nPorcentajeIVA             := uValue:VarGet()

    if empty( nPorcentajeIVA )
      RETURN ( .t. )
   end if

   if SQLTiposIvaModel():CountIvaWherePorcentaje( nPorcentajeIVA ) <= 0
      msgstop( "No existe el IVA introducido" )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//



