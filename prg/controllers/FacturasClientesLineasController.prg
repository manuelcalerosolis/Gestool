#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesLineasController FROM SQLBrowseController

   DATA hArticulo

   DATA oSeriesControler

   DATA oRelacionesEntidades

   DATA oSearchView

   DATA aProperties                    INIT {}

   DATA aSelectDelete                  INIT {}

   DATA oUnidadesMedicionController

   DATA oArticulosPreciosDescuentosController

   DATA oHistoryManager

   METHOD New()

   METHOD End()

   METHOD Append()

   METHOD Edit()                       

   // Validaciones ------------------------------------------------------------

   METHOD validColumnCodigoArticulo( oCol, uValue, nKey )  

   METHOD validColumnNombreArticulo( oCol, uValue, nKey )  

   METHOD validateLote()               

   METHOD validatePrimeraPropiedad()      INLINE ( iif(  ::validate( "valor_primera_propiedad" ),;
                                                         ::stampPropertyName( "codigo_primera_propiedad" , "valor_primera_propiedad", ::oDialogView:oGetValorPrimeraPropiedad ),;
                                                         .f. ) )

   METHOD validateSegundaPropiedad()      INLINE ( iif(  ::validate( "valor_segunda_propiedad" ),;
                                                         ::stampPropertyName( "codigo_segunda_propiedad" , "valor_segunda_propiedad", ::oDialogView:oGetValorSegundaPropiedad ),;
                                                         .f. ) )

   METHOD lValidUnidadMedicion( uValue )
   
   // Historicos---------------------------------------------------------------

   METHOD setHistoryManager()             INLINE ( ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() ) )

   // Escritura de campos------------------------------------------------------

   METHOD updateField( cField, uValue )   INLINE ( ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue ),;
                                                   ::getRowSet():Refresh(),;
                                                   ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() ) ) 

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloCodigo( cCodigoArticulo ) ;
                                          INLINE ( ::updateField( "articulo_codigo", cCodigoArticulo ) )

   METHOD stampArticuloNombre( cNombreArticulo ) ;
                                          INLINE ( ::updateField( "articulo_nombre", cNombreArticulo ) )

<<<<<<< HEAD
   ::getRowSet():Refresh()

   ::setHistoryManager()

RETURN ( nil )

//---------------------------------------------------------------------------//

   METHOD stampArticuloNombre( cNombreArticulo ) 

=======
>>>>>>> 9e6f7d46196978851f83aa1330be7e2c02d20fdd
   METHOD stampArticuloUnidadeMedicion()

   METHOD stampArticuloPrecio()

   METHOD stampUnidades( uValue )

   METHOD getHashArticuloWhereCodigo( cCodigo )

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

   METHOD updateUnidadMedicion( x )

   METHOD loadUnidadesMedicion()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::cTitle                            := "Facturas clientes líneas"

   ::setName( "lineas_facturas_clientes" )

   ::oModel                                        := SQLFacturasClientesLineasModel():New( self )

   ::oBrowseView                                   := FacturasClientesLineasBrowseView():New( self )

   ::oDialogView                                   := FacturasClientesLineasView():New( self )

   ::oValidator                                    := FacturasClientesLineasValidator():New( self )

   ::oSearchView                                   := SQLSearchView():New( self )

   ::oSeriesControler                              := NumerosSeriesController():New( self )

   ::oRelacionesEntidades                          := RelacionesEntidadesController():New( self )

   ::oUnidadesMedicionController                   := UnidadesMedicionGruposLineasController():New( self )

   ::oArticulosPreciosDescuentosController         := ArticulosPreciosDescuentosController():New( self )

   ::oHistoryManager                               := HistoryManager():New()

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

METHOD validColumnCodigoArticulo( oCol, uValue, nKey )

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

   if !( ::validate( "articulo_codigo", uValue ) )
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

METHOD stampArticulo( hArticulo )

   local hBuffer           := {=>}
   // local nPrecioBase       := SQLArticulosPreciosModel():getPrecioBaseWhereArticuloUuidAndTarifaCodigo( hget( hArticulo, "uuid" ), ::oSenderController:getModelBuffer( "tarifa_codigo" ) )
   // local nDescuento        := SQLArticulosPreciosDescuentosModel():getDescuentoWhereArticulo( hget( hArticulo, "uuid" ), ::oSenderController:getModelBuffer( "tarifa_codigo" ), ::getRowSet():fieldGet( 'articulo_unidades' ), ::oSenderController:oModel:hBuffer[ "fecha" ] )
   // local cUnidadMedicion   := UnidadesMedicionGruposLineasRepository():getCodigoDefault( hget( hArticulo, "codigo" ) )

   ::stampArticuloCodigo( hget( hArticulo, "codigo" ) )

   ::stampArticuloNombre( hget( hArticulo, "nombre" ) )

   ::stampArticuloUnidadeMedicion()

   ::stampArticuloPrecio()

   /*
   hset( hBuffer, "articulo_codigo",         hget( hArticulo, "codigo" ) )

   hset( hBuffer, "unidad_medicion_codigo",  cUnidadMedicion )
   
   hset( hBuffer, "articulo_precio",         nPrecioBase )

   hset( hBuffer, "descuento",               nDescuento )

   ::oModel:updateBufferWhereId( ::getRowSet():fieldGet( 'id' ), hBuffer )

   ::stampArticuloUnidadeMedicion()

   ::stampArticuloPrecio()

   ::stampArticuloUnidades()
   
   ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() )
   */
   
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

METHOD stampArticuloUnidadeMedicion()

   local cUnidadMedicion   := UnidadesMedicionGruposLineasRepository():getCodigoDefault( ::getRowSet():fieldGet( 'articulo_codigo' ) )

   if !empty( cUnidadMedicion )
      ::updateField( "unidad_medicion_codigo", cUnidadMedicion )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD stampUnidades( uValue )

   local nDescuento        

   ::updateField( 'articulo_unidades', uValue )

   nDescuento           := SQLArticulosPreciosDescuentosModel():getDescuentoWhereArticuloCodigo( ::getRowSet():fieldGet( 'articulo_codigo' ), ::oSenderController:getModelBuffer( 'tarifa_codigo' ), ::getRowSet():fieldGet( 'articulo_unidades' ), ::oSenderController:oModel:hBuffer[ "fecha" ] )

   msgalert( nDescuento, "calculamos descuentos para undades")

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloPrecio()

   local nPrecioBase       := SQLArticulosPreciosModel():getPrecioBaseWhereArticuloCodigoAndTarifaCodigo( ::getRowSet():fieldget( "articulo_codigo" ), ::oSenderController:getModelBuffer( "tarifa_codigo" ) )

   ::updateField( 'articulo_precio', nPrecioBase )

RETURN ( .t. )

//---------------------------------------------------------------------------//

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

   ::aProperties     := {}

   if !( ::oDialogView:oBrowsePropertyView:lVisible() )
      RETURN ( .t. )
   end if 

   ::aProperties     := ::oDialogView:oBrowsePropertyView:getProperties()

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

METHOD updateUnidadMedicion( uValue )
      
   local hBuffer           := {  "unidad_medicion_codigo"          => uValue,;
                                 "unidad_medicion_factor"          => UnidadesMedicionGruposLineasRepository():getFactorWhereUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ), uValue ) }

   ::oModel:updateBufferWhereId( ::getRowSet():fieldGet( 'id' ), hBuffer )

   ::getRowSet():Refresh()

   ::refreshBrowse()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadUnidadesMedicion()

   ::oBrowseView:oColumnUnidadMedicion:aEditListTxt := UnidadesMedicionGruposLineasRepository():getCodigos( ::getRowSet():fieldGet( 'articulo_codigo' ) )

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD lValidUnidadMedicion( uValue )

   local cValue   :=  uValue:VarGet()

   if !hb_ischar( cValue )
      RETURN ( .f. )
   end if 

   if !( ::validate( "unidad_medicion_codigo", cValue ) )
      RETURN ( .f. )
   end if

RETURN ( .t. )

//----------------------------------------------------------------------------//
