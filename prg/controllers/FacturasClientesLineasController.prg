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

   METHOD New()

   METHOD Append()

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
   
   // Otros--------------------------------------------------------------------

   METHOD stampArticulo( hArticulo )

   METHOD stampArticuloNombre( uValue )

   METHOD isChangeArticulo()

   METHOD getHashArticulo()

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

   ::oValidator                        := DocumentosLineasValidator():New( self )

   ::oSearchView                       := SQLSearchView():New( self )

   ::oSeriesControler                  := NumerosSeriesController():New( self )

   ::oRelacionesEntidades              := RelacionesEntidadesController():New( self )

   ::setEvent( 'activating',           {|| ::oModel:setOrderBy( "id" ), ::oModel:setOrientation( "D" ) } )

   ::setEvent( 'closedDialog',         {|| ::closedDialog() } )

   ::setEvent( 'appended',             {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',               {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',     {|| ::oBrowseView:Refresh() } )

   ::setEvent( 'deletingLines',        {|| ::oSeriesControler:deletedSelected( ::aSelectDelete ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validColumnCodigoArticulo( oCol, uValue, nKey )

   local hArticulo 

   if !hb_isnumeric( nKey ) .or. ( nKey == VK_ESCAPE ) .or. hb_isnil( uValue )
      RETURN ( .t. )
   end if

   if hb_ishash( uValue )
      RETURN ( ::stampArticulo( uValue ) )
   end if 

   if !hb_ischar( uValue )
      RETURN ( .f. )
   end if 

   if !( ::validate( "articulo_codigo", uValue ) )
      RETURN ( .f. )
   end if 

   hArticulo   := SQLArticulosModel():getHashWhere( "codigo", uValue )
   if empty( hArticulo )
      RETURN ( .f. )
   end if 

RETURN ( ::stampArticulo( hArticulo ) )

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

METHOD stampArticulo( hArticulo )

   local hBuffer

   if !empty( hArticulo )
      ::hArticulo    := hArticulo
   end if 

   hBuffer           := {  "articulo_codigo"    => hget( ::hArticulo, "codigo" ),;
                           "articulo_nombre"    => hget( ::hArticulo, "nombre" ) }

   ::oModel:updateBufferWhereId( ::getRowSet():fieldGet( 'id' ), hBuffer )

   ::getRowSet():Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampArticuloNombre( uValue )

   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "articulo_nombre", uValue )

   ::getRowSet():Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD isChangeArticulo()

   local cCodigoArticulo

   cCodigoArticulo   := ::getModelBuffer( "articulo_codigo" )
   if empty( cCodigoArticulo )
      RETURN ( .f. )
   end if  

   if !( ::oDialogView:oGetCodigoArticulo:isOriginalChanged( cCodigoArticulo ) )
      RETURN ( .f. )
   end if

   ::oDialogView:oGetCodigoArticulo:setOriginal( cCodigoArticulo )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getHashArticulo()

   ::hArticulo       := ArticulosModel():getHash( ::getModelBuffer( "articulo_codigo" ) )

   if empty( ::hArticulo )
      RETURN ( .f. )
   end if 

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

METHOD updateUnidadMedicion( x )
      
   MsgInfo( ::getModelBuffer( "id" ), "id" )
   MsgInfo( x, "x" )


   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), 'unidad_medicion_codigo', x )

   ::getRowSet():Refresh()

   ::refreshBrowse()

Return ( nil )

//----------------------------------------------------------------------------//