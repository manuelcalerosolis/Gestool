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

   DATA oHistoryManager

   METHOD New()

   METHOD End()

   METHOD Append()

   METHOD Edit()                       INLINE ( .t. )

   // Validaciones ------------------------------------------------------------

   METHOD validColumnCodigoArticulo( oCol, uValue, nKey )  

   METHOD validColumnNombreArticulo( oCol, uValue, nKey )  

   METHOD validateLote()               

   METHOD validatePrimeraPropiedad()   INLINE ( iif(  ::validate( "valor_primera_propiedad" ),;
                                                      ::stampPropertyName( "codigo_primera_propiedad" , "valor_primera_propiedad", ::oDialogView:oGetValorPrimeraPropiedad ),;
                                                      .f. ) )

   METHOD validateSegundaPropiedad()   INLINE ( iif(  ::validate( "valor_segunda_propiedad" ),;
                                                      ::stampPropertyName( "codigo_segunda_propiedad" , "valor_segunda_propiedad", ::oDialogView:oGetValorSegundaPropiedad ),;
                                                      .f. ) )

   METHOD lValidUnidadMedicion( uValue )
   
   // Otros--------------------------------------------------------------------

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloNombre( uValue )

   METHOD getArticulo( cCodigo )

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

   METHOD updateFieldWhereId( cField, uValue )    INLINE ( ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), cField, uValue ), ::getRowSet():Refresh(), ::refreshBrowse() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::cTitle                            := "Facturas clientes líneas"

   ::setName( "lineas_facturas_clientes" )

   ::oModel                            := SQLFacturasClientesLineasModel():New( self )

   ::oBrowseView                       := FacturasClientesLineasBrowseView():New( self )

   ::oDialogView                       := FacturasClientesLineasView():New( self )

   ::oValidator                        := FacturasClientesLineasValidator():New( self )

   ::oSearchView                       := SQLSearchView():New( self )

   ::oSeriesControler                  := NumerosSeriesController():New( self )

   ::oRelacionesEntidades              := RelacionesEntidadesController():New( self )

   ::oUnidadesMedicionController       := UnidadesMedicionGruposLineasController():New( self )

   ::oHistoryManager                   := HistoryManager():New()

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

   hArticulo   := ::getArticulo( uValue )
   if empty( hArticulo )
      RETURN ( .f. )
   end if 

RETURN ( ::stampArticulo( hArticulo ) )

//---------------------------------------------------------------------------//

METHOD getArticulo( cCodigo )
   
RETURN ( SQLArticulosModel():getHashWhere( "codigo", cCodigo ) )

//---------------------------------------------------------------------------//

METHOD stampArticulo( hArticulo )

   local hBuffer     := {=>}

   msgalert( hb_valtoexp( hArticulo ), "hArticulo" )
   
   msgalert( UnidadesMedicionGruposLineasRepository():getCodigoDefault( hget( hArticulo, "codigo" ) ), "UnidadesMedicionGruposLineasRepository" )

   hset( hBuffer, "articulo_codigo",         hget( hArticulo, "codigo" ) )

   hset( hBuffer, "articulo_nombre",         hget( hArticulo, "nombre" ) )

   hset( hBuffer, "unidad_medicion_codigo",  UnidadesMedicionGruposLineasRepository():getCodigoDefault( hget( hArticulo, "codigo" ) ) )
   
   hset( hBuffer, "articulo_precio",         333 )

   ::oModel:updateBufferWhereId( ::getRowSet():fieldGet( 'id' ), hBuffer )

   ::getRowSet():Refresh()
   
   ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() )

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

METHOD stampArticuloNombre( uValue )

   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "articulo_nombre", uValue )

   ::getRowSet():Refresh()

   ::oHistoryManager:Set( ::getRowSet():getValuesAsHash() )

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

METHOD updateUnidadMedicion( uValue )
      
   local hBuffer           := {  "unidad_medicion_codigo"          => uValue,;
                                 "unidad_medicion_factor"          => UnidadesMedicionGruposLineasRepository():getFactorWhereUnidadMedicion( ::getRowSet():fieldGet( 'articulo_codigo' ), uValue ) }

   ::oModel:updateBufferWhereId( ::getRowSet():fieldGet( 'id' ), hBuffer )

   ::getRowSet():Refresh()

   ::refreshBrowse()

Return ( nil )

//----------------------------------------------------------------------------//

METHOD loadUnidadesMedicion()

   ::oBrowseView:oColumnUnidadMedicion:aEditListTxt := UnidadesMedicionGruposLineasRepository():getCodigos( ::getRowSet():fieldGet( 'articulo_codigo' ) )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD lValidUnidadMedicion( uValue )

   local cValue   :=  uValue:VarGet()

   if !hb_ischar( cValue )
      RETURN ( .f. )
   end if 

   if !( ::validate( "unidad_medicion_codigo", cValue ) )
      RETURN ( .f. )
   end if

Return ( .t. )

//----------------------------------------------------------------------------//
