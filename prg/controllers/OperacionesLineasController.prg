#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS OperacionesLineasController FROM SQLBrowseController

   DATA oHistoryManager

   DATA hArticulo

   DATA oSeriesControler

   DATA oSearchView

   DATA aSelectDelete                  INIT {}

   METHOD New()                        CONSTRUCTOR

   METHOD End()

   METHOD Edit()    

   // Validaciones ------------------------------------------------------------

   METHOD validArticuloCodigo( oGet, oCol )

   METHOD validColumnNombreArticulo( oCol, uValue, nKey )  

   METHOD postValidateArticuloCodigo( oCol, uValue, nKey )  

   METHOD postValidateAlmacenCodigo( oCol, uValue, nKey )

   METHOD postValidateUbicacionCodigo( oCol, uValue, nKey, cField )

   METHOD postValidateCombinacionesUuid( oCol, uValue, nKey )

   METHOD postValidateUnidadMedicion( oCol, uValue, nKey )

   METHOD validateLote()               

   METHOD validateUnidadMedicion( uValue )

   METHOD validateIva( uValue )

   METHOD validateDescuento( uValue )
   
   METHOD validAlmacenCodigo( oGet, oCol )

   METHOD validUbicacionCodigo( oGet, oCol )

   METHOD validLineCombinacion( cCodigoArticulo )

   METHOD validLineLote( cCodigoArticulo )

   METHOD validLineAlmacen()

   METHOD validLineUbicacion()

   METHOD validCombinacionesTexto( oGet, oCol )    

   // Escritura de campos------------------------------------------------------

   METHOD updateField( cField, uValue )   

   // stamps de articulos------------------------------------------------------

   METHOD stampAlmacen( hAlmacen )

   METHOD stampUbicacion( hUbicacion )

   METHOD stampArticuloCodigo( cCodigoArticulo ) ;
                                       INLINE ( ::updateField( "articulo_codigo", cCodigoArticulo ) ) 

   METHOD stampArticuloNombre( cNombreArticulo ) ;
                                       INLINE ( ::updateField( "articulo_nombre", cNombreArticulo ) )

   METHOD stampCombinacionesUuid( UuidCombinacion ) ;
                                       INLINE ( ::updateField( "combinaciones_uuid", UuidCombinacion ) )

   METHOD stampIncrement( nIncrementoPrecio ) 

   METHOD stampArticuloUnidadMedicion()   

   METHOD stampArticuloPrecio()        VIRTUAL        

   METHOD stampArticuloCodigoNombre( hArticulo ) ;
                                       INLINE ( ::updateField( "articulo_codigo", hget( hArticulo, "codigo" ) ),;
                                                ::updateField( "articulo_nombre", hget( hArticulo, "nombre" ) ) )

   METHOD stampArticuloDescuento()     VIRTUAL

   METHOD getArticuloUnidadMedicion()    

   METHOD stampArticuloUnidadMedicionCodigo( uValue )

   METHOD stampArticuloUnidadMedFac()

   METHOD stampCombinationAndIncrement( hCombination )

   METHOD getUnidadMedicion( cCodigoArticulo )  VIRTUAL

   METHOD updateArticuloFactor( uValue )

   METHOD updateArticuloPrecio( uValue ) ;
                                       INLINE ( ::updateField( 'articulo_precio', uValue ),;
                                                ::oController:calculateTotals() )

   METHOD updateArticuloIncrementoPrecio( uValue ) ;
                                       INLINE ( ::updateField( 'incremento_precio', uValue ),;
                                                ::oController:calculateTotals() )

   METHOD updateDescuento( nDescuento )

   METHOD getHashArticuloWhereCodigo( cCodigo )

   METHOD getHashAlmacenWhereCodigo( cCodigo )

   METHOD getHashUbicacionWhereCodigo( cCodigo )
   
   // Dialogos-----------------------------------------------------------------

   METHOD runDialogSeries()

   METHOD Search()

   METHOD deleteLines( uuid )

   METHOD getUuid()                    INLINE ( iif(  !empty( ::getModel() ) .and. !empty( ::getModel():hBuffer ),;
                                                      hget( ::getModel():hBuffer, "uuid" ),;
                                                      nil ) )

   METHOD refreshBrowse()              INLINE ( iif(  !empty( ::getBrowseView() ), ::getBrowseView():Refresh(), ) )

   METHOD loadStockInformation()
      METHOD loadGeneralStockInformation()            
      METHOD loadAlmacenStockInformation()
      METHOD loadUbicacionStockInformation()
      METHOD loadLoteStockInformation()
      METHOD loadCombinacionesStockInformation()
      
   METHOD loadUnidadesMedicion()

   METHOD loadedBlankBuffer()          VIRTUAL

   // Construcciones tardias---------------------------------------------------

   METHOD getModel()                   VIRTUAL

   METHOD getBrowseView()              VIRTUAL

   METHOD getDialogView()              VIRTUAL

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := OperacionesLineasValidator():New( self ), ), ::oValidator )

   METHOD getHistoryManager()          INLINE ( iif( empty( ::oHistoryManager ), ::oHistoryManager := HistoryManager():New(), ), ::oHistoryManager )

   METHOD getSearchView()              INLINE ( iif( empty( ::oSearchView ), ::oSearchView := SQLSearchView():New( self ), ), ::oSearchView )  

   METHOD getSeriesControler()         INLINE ( iif( empty( ::oSeriesControler ), ::oSeriesControler := NumerosSeriesController():New( self ), ), ::oSeriesControler )  

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS OperacionesLineasController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::setEvent( 'activating',  {|| ::getModel():setOrderBy( "id" ), ::getModel():setOrientation( "D" ) } )

   ::setEvent( 'deletingLines', {|| ::oSeriesControler:deletedSelected( ::aSelectDelete ) } )

   ::setEvent( 'exitAppended', {|| ::getBrowseView():setFocusColumnCodigoArticulo() } )

   ::getModel():setEvent( 'loadedBlankBuffer',  {|| ::loadedBlankBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS OperacionesLineasController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oSearchView )
      ::oSearchView:End()
   end if 

   if !empty( ::oSeriesControler )
      ::oSeriesControler:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oHistoryManager )
      ::oHistoryManager:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD validArticuloCodigo( oGet, oCol ) CLASS OperacionesLineasController

   local uValue   := oGet:varGet()

   msgalert( hb_valtoexp( uValue ), "validArtucloCodigo" )

   if empty( uValue )
      RETURN ( .t. )
   end if 

RETURN ( ::validate( 'articulo_codigo', uValue ) )

//---------------------------------------------------------------------------//

METHOD validAlmacenCodigo( oGet, oCol ) CLASS OperacionesLineasController

   if SQLAlmacenesModel():CountAlmacenWhereCodigo( oGet:varGet() ) <= 0 

      ::getController():getDialogView():showMessage( "El almacén introducido no existe" )      
   
      RETURN ( .f. )
   
   end if

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD validUbicacionCodigo( oGet, oCol ) CLASS OperacionesLineasController

   if SQLUbicacionesModel():CountUbicacionWhereCodigo( oGet:varGet() ) <= 0 
      
      ::getController():getDialogView():showMessage( "La ubicación introducida no existe" )

      RETURN ( .f. )

   end if

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD validCombinacionesTexto( oGet, oCol ) CLASS OperacionesLineasController

   local hArticuloCombinacion

   hArticuloCombinacion    := SQLCombinacionesPropiedadesModel():selectPropertyWhereArticuloCombinacion( ::getRowSet():fieldget( 'articulo_codigo' ), alltrim( oGet:varGet() ) )
   
   if empty( hArticuloCombinacion )

      ::getController():getDialogView():showMessage( "Las propiedades introducidas no son validas" )      

      ::getBrowseView():setFocusColumnPropiedades()

      RETURN ( .f. )

   end if 

   oGet:varPut( hget( atail( hArticuloCombinacion ), "uuid" ) )

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD validLineCombinacion() CLASS OperacionesLineasController

   if !empty( ::getRowSet():fieldget( 'articulos_propiedades_nombre' ) )
      RETURN ( .t. )
   end if

   if !empty( ::getCombinacionesController():getModel():CountWhereCodigoArticulo( ::getRowSet():fieldget( 'articulo_codigo' ) ) )
      
      ::getController():getDialogView():showMessage( "Debe seleccionar propiedades" )      
      
      ::getBrowseView():setFocusColumnPropiedades()
      
      RETURN ( .f. )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validLineLote() CLASS OperacionesLineasController

   if !empty( ::getRowSet():fieldget( 'lote' ) )
      RETURN ( .t. )
   end if

   if !empty( ::getArticulosController():getModel():isLote( ::getRowSet():fieldget( 'articulo_codigo' ) ) )
      
      ::getController():getDialogView():showMessage( "Debe seleccionar un lote" )      
      
      ::getBrowseView():setFocusColumnLote()
      
      RETURN ( .f. )

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validLineAlmacen() CLASS OperacionesLineasController

   if empty( ::getRowSet():fieldget( 'almacen_codigo' ) )

      ::getController():getDialogView():showMessage( "Almacén no puede estar vacio en la línea" )   
   
      ::getBrowseView():setFocusColumnCodigoAlmacen()
   
      RETURN ( .f. )
   
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD validLineUbicacion( cField ) CLASS OperacionesLineasController

   DEFAULT cField    := 'ubicacion_codigo'

   if !( Company():getDefaultUsarUbicaciones() )
      RETURN ( .t. )
   end if 

   if empty( ::getRowSet():fieldget( cField ) )

      ::getController():getDialogView():showMessage( "Ubicación no puede estar vacia en la línea" )   
   
      ::getBrowseView():setFocusColumnCodigoUbicacion()
   
      RETURN ( .f. )
   
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD postValidateArticuloCodigo( oCol, uValue, nKey ) CLASS OperacionesLineasController

   local hArticulo 

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if hb_ishash( uValue )
      if ::getHistoryManager():isEqual( 'articulo_codigo', hget( uValue, 'codigo' ) )
         RETURN ( .f. )
      end if          
      RETURN ( ::stampArticulo( uValue ) )
   end if 

   if !hb_ischar( uValue )
      RETURN ( .f. )
   end if 

   if ::getHistoryManager():isEqual( 'articulo_codigo', uValue )
      RETURN ( .f. )
   end if          

   hArticulo   := ::getHashArticuloWhereCodigo( uValue )
   if empty( hArticulo )
      RETURN ( .f. )
   end if 

RETURN ( ::stampArticulo( hArticulo ) )

//---------------------------------------------------------------------------//

METHOD postValidateAlmacenCodigo( oCol, uValue, nKey ) CLASS OperacionesLineasController

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

   if ::getHistoryManager():isEqual( "almacen_codigo", cCodigo )
      RETURN ( .t. )
   end if 

RETURN ( ::stampAlmacen( cCodigo ) )

//---------------------------------------------------------------------------//

METHOD postValidateUbicacionCodigo( oCol, uValue, nKey, cField ) CLASS OperacionesLineasController

   local cCodigo

   DEFAULT cField    := "ubicacion_codigo"

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   do case
      case hb_ishash( uValue )
         cCodigo     := hget( uValue, "codigo" )
      case hb_ischar( uValue )
         cCodigo     := uValue
   end case 

   if ::getHistoryManager():isEqual( cField, cCodigo )
      RETURN ( .t. )
   end if 

RETURN ( ::stampUbicacion( cCodigo, cField ) )

//---------------------------------------------------------------------------//

METHOD postValidateCombinacionesUuid( oCol, uValue ) CLASS OperacionesLineasController

   local hCombination         

   if hb_isnil( uValue )
      RETURN ( nil )
   end if

   hCombination               := SQLcombinacionesModel():getHashWhere( "uuid", uValue )

   if empty( hCombination )
      RETURN ( nil )
   end if 

   ::stampCombinationAndIncrement( hCombination )

   ::oController:calculateTotals()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD postValidateUnidadMedicion( oCol, uValue, nKey ) CLASS OperacionesLineasController

   if !hb_ischar( uValue )
      RETURN ( .f. )
   end if 

   if ::getHistoryManager():isEqual( "unidad_medicion_codigo", uValue )
      RETURN ( .t. )
   end if          
   
   ::stampArticuloUnidadMedicionCodigo( uValue )

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD getHashArticuloWhereCodigo( cCodigo ) CLASS OperacionesLineasController
   
RETURN ( SQLArticulosModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD getHashAlmacenWhereCodigo( cCodigo ) CLASS OperacionesLineasController
   
RETURN ( SQLAlmacenesModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD getHashUbicacionWhereCodigo( cCodigo ) CLASS OperacionesLineasController
   
RETURN ( SQLUbicacionesModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD updateField( cField, uValue ) CLASS OperacionesLineasController

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue )
   
   ::getRowSet():Refresh()
   
   ::getBrowseView():Refresh()
   
   ::getHistoryManager():Set( ::getRowSet():getValuesAsHash() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampAlmacen( cCodigoAlmacen ) CLASS OperacionesLineasController

   ::updateField( "almacen_codigo", cCodigoAlmacen )

RETURN ( ::stampUbicacion( space( 20 ) ) )

//---------------------------------------------------------------------------//

METHOD stampUbicacion( cCodigoUbicacion, cField ) CLASS OperacionesLineasController

   DEFAULT cField          := "ubicacion_codigo"

   ::updateField( cField, cCodigoUbicacion )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedicion() CLASS OperacionesLineasController 

   local cUnidadMedicion   := ::getArticuloUnidadMedicion()

   if !empty( cUnidadMedicion )
      RETURN ( ::stampArticuloUnidadMedicionCodigo( cUnidadMedicion ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getArticuloUnidadMedicion() CLASS OperacionesLineasController

   local cUnidadMedicion   

   // Unidad de medición para ventas de este articulo--------------------------

   cUnidadMedicion         := ::getUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ) ) 

   if !empty( cUnidadMedicion )
      RETURN ( cUnidadMedicion ) 
   end if 

   // Unidad de medición menor para este articulo de su grupo de unidades------

   cUnidadMedicion         := UnidadesMedicionGruposLineasRepository():getUnidadDefectoWhereArticulo( ::getRowSet():fieldGet( 'articulo_codigo' ) ) 

   if !empty( cUnidadMedicion )
      RETURN ( cUnidadMedicion )
   end if 

   // Unidad de medición menor en el grupo de la empresa-----------------------

   cUnidadMedicion         := afirst( UnidadesMedicionGruposLineasRepository():getWhereEmpresa() )

   if !empty( cUnidadMedicion )
      RETURN ( cUnidadMedicion )  
   end if 

   // Unidad de medición del sistema-------------------------------------------

   cUnidadMedicion         := SQLUnidadesMedicionModel():getUnidadMedicionSistema()
   
   if !empty( cUnidadMedicion )
      RETURN ( cUnidadMedicion  )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//


METHOD validColumnNombreArticulo( oCol, uValue, nKey ) CLASS OperacionesLineasController 

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if !( ::validate( "articulo_nombre", uValue ) )
      RETURN .f.
   end if 

RETURN ( ::stampArticuloNombre( uValue ) )

//---------------------------------------------------------------------------//

METHOD updateArticuloFactor( oCol, uValue ) CLASS OperacionesLineasController

   ::updateField( 'unidad_medicion_factor', uValue )

   ::getBrowseView():makeTotals( oCol )

RETURN ( ::oController:calculateTotals() )

//---------------------------------------------------------------------------//

METHOD stampIncrement( nIncrementoPrecio ) CLASS OperacionesLineasController 
   
   ::updateField( "incremento_precio", nIncrementoPrecio )
                                                   
RETURN ( ::oController:calculateTotals() )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedicionCodigo( uValue ) CLASS OperacionesLineasController

   ::updateField( 'unidad_medicion_codigo', uValue )

   ::stampArticuloUnidadMedFac()

RETURN ( ::oController:calculateTotals() )

//----------------------------------------------------------------------------//

METHOD stampArticuloUnidadMedFac() CLASS OperacionesLineasController
      
   local nFactor  := UnidadesMedicionGruposLineasRepository():getFactorWhereUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ), ::getRowSet():fieldGet( 'unidad_medicion_codigo' ) ) 

   if nFactor > 0
      ::updateField( 'unidad_medicion_factor', nFactor )
      ::stampArticuloDescuento()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

 METHOD stampCombinationAndIncrement( hCombination ) CLASS OperacionesLineasController

   ::stampCombinacionesUuid( hget( hCombination, "uuid" ) )

   ::stampIncrement( hget( hCombination, "incremento_precio" ) )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD updateDescuento( nDescuento ) CLASS OperacionesLineasController

   if hb_isnumeric( nDescuento )
      ::updateField( 'descuento', nDescuento )
   end if 

RETURN ( ::oController:calculateTotals() )

//----------------------------------------------------------------------------//

METHOD validateLote() CLASS OperacionesLineasController

   local cLote

   cLote       := ::getModelBuffer( 'lote' )
   if empty( cLote )
      RETURN ( .t. )
   end if  

   if !( ::getDialogView():oGetLote:isOriginalChanged( cLote ) )
      RETURN ( .t. )
   end if 

   ::getDialogView():oGetLote:setOriginal( cLote )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runDialogSeries() CLASS OperacionesLineasController

   if empty( ::getDialogView():nTotalUnidadesArticulo() )
      ::getController():getDialogView():showMessage( "El número de unidades no puede ser 0 para editar números de serie" )      
      RETURN ( .f. )
   end if

   ::getSeriesControler():SetTotalUnidades( ::getDialogView():nTotalUnidadesArticulo() )

   ::getSeriesControler():Edit( hget( ::getModel():hBuffer, "id" ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Search() CLASS OperacionesLineasController

RETURN ( ::getSearchView():Activate() )

//---------------------------------------------------------------------------//

METHOD deleteLines( uuid ) CLASS OperacionesLineasController

   ::aSelectDelete  := ::getModel():aRowsDeleted( uuid )

   ::fireEvent( 'deletingLines' )

   ::getModel():deleteWhereUuid( uuid )

   ::fireEvent( 'deletedLines' )
 
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Edit() CLASS OperacionesLineasController

   local nId
   local cCodigoArticulo   := ::getRowSet():fieldGet( 'articulo_codigo' )

   if empty( cCodigoArticulo )
      RETURN ( nil )
   end if 

   nId                     := ::oController:getArticulosController():getModel():getIdWhereCodigo( cCodigoArticulo )
   if empty( nId )
      RETURN ( nil )
   end if 

RETURN ( ::oController:getArticulosController():Edit( nId ) )

//----------------------------------------------------------------------------//

METHOD loadUnidadesMedicion() CLASS OperacionesLineasController

   local aUnidadesMedicion := UnidadesMedicionGruposLineasRepository():getCodigos( ::getRowSet():fieldGet( 'articulo_codigo' ) )

   if !empty( aUnidadesMedicion )
      ::getBrowseView():oColumnUnidadMedicion:aEditListTxt := aUnidadesMedicion
   end if       

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD validateUnidadMedicion( uValue ) CLASS OperacionesLineasController

   local cValue   := uValue:VarGet()

   if !( hb_ischar( cValue ) )
      RETURN ( .f. )
   end if 

   if !( ::validate( "unidad_medicion_codigo", cValue ) )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD validateDescuento( uValue ) CLASS OperacionesLineasController

   local nDescuento                  

   nDescuento             := uValue:VarGet()

   if nDescuento < 0
      ::getController():getDialogView():showMessage( "El porcentaje de descuento no puede ser un número negativo" )      
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD validateIva( uValue ) CLASS OperacionesLineasController

   local nPorcentajeIVA                  
   local nPorcentajeRecargo

   nPorcentajeIVA             := uValue:VarGet()

   if empty( nPorcentajeIVA )
      RETURN ( .t. )
   end if

   if SQLTiposIvaModel():CountIvaWherePorcentaje( nPorcentajeIVA ) <= 0
      ::getController():getDialogView():showMessage( "No existe el IVA introducido" )      
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD loadStockInformation() CLASS OperacionesLineasController 

   if empty( ::oController:getDialogView() )
      RETURN ( nil )
   end if 

   ::loadGeneralStockInformation()

   ::loadAlmacenStockInformation()

   ::loadUbicacionStockInformation()

   ::loadLoteStockInformation()

   ::loadCombinacionesStockInformation()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadGeneralStockInformation() CLASS OperacionesLineasController 

   if empty( ::getRowSet():fieldget( "articulo_codigo" ) )
      RETURN ( ::oController:getDialogView():cleanTextLinkStockGlobal() )
   end if 

RETURN ( ::oController:getDialogView():setTextLinkStockGlobal( StocksRepository():selectStockWhereCodigo( ::getRowSet():fieldget( "articulo_codigo" ) ) ) )

//----------------------------------------------------------------------------//

METHOD loadAlmacenStockInformation() CLASS OperacionesLineasController 
   
   if empty( ::getRowSet():fieldget( "articulo_codigo" ) )
      RETURN ( ::oController:getDialogView():cleanTextLinkStockAlmacen() )
   end if 

RETURN ( ::oController:getDialogView():setTextLinkStockAlmacen( StocksRepository():selectStockWhereCodigoAlmacen( ::getRowSet():fieldget( "articulo_codigo" ), ::getRowSet():fieldget( "almacen_codigo" ) ) ) )

//----------------------------------------------------------------------------//

METHOD loadUbicacionStockInformation() CLASS OperacionesLineasController

   if empty( ::getRowSet():fieldget( "articulo_codigo" ) ) .or. !( Company():getDefaultUsarUbicaciones() )
      RETURN ( ::oController:getDialogView():cleanTextLinkStockUbicacion() )
   end if 
   
RETURN ( ::oController:getDialogView():setTextLinkStockUbicacion( StocksRepository():selectStockWhereCodigoAlmacenUbicacion( ::getRowSet():fieldget( "articulo_codigo" ), ::getRowSet():fieldget( "almacen_codigo" ), ::getRowSet():fieldget( "ubicacion_codigo" ) ) ) ) 

//----------------------------------------------------------------------------//

METHOD loadLoteStockInformation() CLASS OperacionesLineasController

   if empty( ::getRowSet():fieldget( "articulo_codigo" ) ) .or. empty( ::getRowSet():fieldget( "lote" ) )
      RETURN ( ::oController:getDialogView():cleanTextLinkStockLote() )
   end if 

RETURN ( ::oController:getDialogView():setTextLinkStockLote( StocksRepository():selectStockWhereCodigoAlmacenLote( ::getRowSet():fieldget( "articulo_codigo" ), ::getRowSet():fieldget( "almacen_codigo" ), ::getRowSet():fieldget( "ubicacion_codigo" ), ::getRowSet():fieldget( "lote" ) ) ) )

//----------------------------------------------------------------------------//

METHOD loadCombinacionesStockInformation() CLASS OperacionesLineasController

   if empty( ::getRowSet():fieldget( "articulo_codigo" ) ) .or. empty( ::getRowSet():fieldget( "combinaciones_uuid" ) )
      RETURN ( ::oController:getDialogView():cleanTextLinkStockCombinaciones() )
   end if 

RETURN ( ::oController:getDialogView():setTextLinkStockCombinaciones( StocksRepository():selectStockWhereCodigoAlmacenCombinaciones( ::getRowSet():fieldget( "articulo_codigo" ), ::getRowSet():fieldget( "almacen_codigo" ), ::getRowSet():fieldget( "ubicacion_codigo" ), ::getRowSet():fieldget( "lote" ), ::getRowSet():fieldget( "combinaciones_uuid" ) ) ) )

//----------------------------------------------------------------------------//
