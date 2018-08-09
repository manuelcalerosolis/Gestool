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

   DATA oHistoryManager

   METHOD New()

   METHOD End()

   METHOD Append()

   METHOD Edit()                       

   // Validaciones ------------------------------------------------------------

   METHOD validArticuloCodigo( oGet, oCol )

   METHOD postValidateArticuloCodigo( oCol, uValue, nKey )  

   METHOD validColumnNombreArticulo( oCol, uValue, nKey )  

   METHOD validateLote()               

   METHOD lValidUnidadMedicion( uValue )
   
   // Historicos---------------------------------------------------------------

   METHOD setHistoryManager()             INLINE ( ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() ) )

   // Escritura de campos------------------------------------------------------

   METHOD updateField( cField, uValue )   

   // stamps de articulos------------------------------------------------------

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloCodigo( cCodigoArticulo ) ;
                                          INLINE ( ::updateField( "articulo_codigo", cCodigoArticulo ) )

   METHOD stampArticuloNombre( cNombreArticulo ) ;
                                          INLINE ( ::updateField( "articulo_nombre", cNombreArticulo ) )

   METHOD stampArticuloUnidaMedicionVentas()
<<<<<<< HEAD

   METHOD stampArticuloUnidadMedicion()
=======
>>>>>>> fca1396d0530bf7c00e6348f918b6406df657661

   METHOD stampArticuloPrecio()

   METHOD stampArticuloUnidades( uValue )

   METHOD stampArticuloDescuento()

   METHOD getHashArticuloWhereCodigo( cCodigo )

   METHOD stampArticuloUnidadMedicion( uValue )

   METHOD stampArticuloUnidadMedicionFactor()
   
   // Dialogos-----------------------------------------------------------------

   METHOD runDialogSeries()

   METHOD onActivateDialog()

   METHOD closedDialog() 

   METHOD Search()

   METHOD deleteLines( cId )

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

   ::oHistoryManager                         := HistoryManager():New()

   ::setEvent( 'activating',           {|| ::oModel:setOrderBy( "id" ), ::oModel:setOrientation( "D" ) } )

   ::setEvent( 'closedDialog',         {|| ::closedDialog() } )

   ::setEvent( 'appended',             {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',               {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',     {|| ::oBrowseView:Refresh() } )

   ::setEvent( 'deletingLines',        {|| ::oSeriesControler:deletedSelected( ::aSelectDelete ) } )

   ::oModel:setEvent( 'loadedBlankBuffer',  {|| hSet( ::oModel:hBuffer, "unidad_medicion_codigo", UnidadesMedicionGruposLineasRepository():getCodigoDefault() ) } )

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

METHOD getHashArticuloWhereCodigo( cCodigo )
   
RETURN ( SQLArticulosModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD updateField( cField, uValue )

   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue )
   
   ::getRowSet():Refresh()
   
   ::oBrowseView:Refresh()
   
   ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo )

   ::stampArticuloCodigo( hget( hArticulo, "codigo" ) )

   ::stampArticuloNombre( hget( hArticulo, "nombre" ) )
<<<<<<< HEAD

   ::stampArticuloUnidaMedicionVentas()

   ::stampArticuloPrecio()

   ::stampArticuloDescuento()

   /*
   hset( hBuffer, "articulo_codigo",         hget( hArticulo, "codigo" ) )

   hset( hBuffer, "unidad_medicion_codigo",  cUnidadMedicion )
   
   hset( hBuffer, "articulo_precio",         nPrecioBase )

   hset( hBuffer, "descuento",               nDescuento )

   ::oModel:updateBufferWhereId( ::getRowSet():fieldGet( 'id' ), hBuffer )
=======
>>>>>>> fca1396d0530bf7c00e6348f918b6406df657661

   ::stampArticuloUnidaMedicionVentas()

   ::stampArticuloPrecio()

   ::stampArticuloDescuento()
   
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

   local cUnidadMedicion   := UnidadesMedicionGruposLineasRepository():getCodigoDefault( ::getRowSet():fieldGet( 'articulo_codigo' ) )

   if !empty( cUnidadMedicion )
      ::updateField( "unidad_medicion_codigo", cUnidadMedicion )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampArticuloUnidades( oCol, uValue )

   ::updateField( 'articulo_unidades', uValue )

   ::stampArticuloDescuento()

   ::oBrowseView:makeTotals( oCol )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloDescuento()

   local nDescuento     := SQLArticulosPreciosDescuentosModel():getDescuentoWhereArticuloCodigo( ::getRowSet():fieldGet( 'articulo_codigo' ), ::oSenderController:getModelBuffer( 'tarifa_codigo' ), ::getRowSet():fieldGet( 'total_unidades' ), ::oSenderController:getModelBuffer( 'fecha' ) )

   ::updateField( 'descuento', nDescuento )

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteLines( uuid )

   ::aSelectDelete  := ::oModel:aRowsDeleted( uuid )

   ::fireEvent( 'deletingLines' )

   ::oModel:deleteWhereUuid( uuid )

   ::fireEvent( 'deletedLines' )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Append()

   local nId
   local lAppend     := .t.   

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( .f. )
   end if 

   if isFalse( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::setAppendMode()

   ::saveRowSetRecno()

   nId               := ::oModel:insertBlankBuffer()

   if !empty( nId )

      ::fireEvent( 'appended' ) 

      ::refreshRowSetAndFindId( nId )

   else 
      
      lAppend        := .f.

      ::refreshRowSet()

   end if 

   ::refreshBrowseView()

   ::fireEvent( 'exitAppended' ) 

   if lAppend
      ::oBrowseView:setFocus()
      ::oBrowseView:selectCol( ::oBrowseView:oColumnCodigo:nPos )
   end if 

RETURN ( lAppend )

//----------------------------------------------------------------------------//

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

METHOD lValidUnidadMedicion( uValue )

   local cValue   := uValue:VarGet()

   if !( hb_ischar( cValue ) )
      RETURN ( .f. )
   end if 

   if !( ::validate( "unidad_medicion_codigo", cValue ) )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//
