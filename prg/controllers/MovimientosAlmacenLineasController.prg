#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasController FROM SQLBaseController

   DATA oSeriesControler

   DATA oSearchView

   DATA aProperties                       INIT {}

   DATA aSelectDelete                     INIT {}

   METHOD New()

   METHOD loadedBlankBuffer()

   METHOD buildingRowSet()

   // Validaciones ------------------------------------------------------------

   METHOD validateCodigoArticulo()     INLINE   (  iif(  ::validate( "codigo_articulo" ),;
                                                         ::stampArticulo(),;
                                                         .f. ) )
   METHOD validateLote()               

   METHOD validatePrimeraPropiedad()   INLINE   (  iif(  ::validate( "valor_primera_propiedad" ),;
                                                         ::stampPropertyName( "codigo_primera_propiedad" , "valor_primera_propiedad", ::oDialogView:oGetValorPrimeraPropiedad ),;
                                                         .f. ) )
   METHOD validateSegundaPropiedad()   INLINE   (  iif(  ::validate( "valor_segunda_propiedad" ),;
                                                         ::stampPropertyName( "codigo_segunda_propiedad" , "valor_segunda_propiedad", ::oDialogView:oGetValorSegundaPropiedad ),;
                                                         .f. ) )
   
   // Propiedades--------------------------------------------------------------

   METHOD stampArticulo()
   
   METHOD stampLoteCaducidad()

   METHOD stampProperties()   
   METHOD stampPropertyName( cFieldCodigo, cFieldValor, oControl )

   // Show/Hide----------------------------------------------------------------

   METHOD showLoteCaducidad()
   METHOD showProperty()
   METHOD hideProperty()               INLINE ( ::oDialogView:hidePropertyControls() )     

   METHOD getPrimeraPropiedad( cCodigoArticulo, cCodigoPropiedad )
   METHOD getSegundaPropiedad( cCodigoArticulo, cCodigoPropiedad )

   METHOD lBrowseProperty()            INLINE ( uFieldEmpresa( "lUseTbl" ) )

   METHOD buildPropertyBrowse()        INLINE ( iif(  uFieldEmpresa( "lUseTbl" ),;
                                                      ::oDialogView:oBrowsePropertyView:build(), ) )

   METHOD loadValuesBrowseProperty()

   METHOD isProductProperty()          INLINE ( !empty( hget( ::oModel:hBuffer, "codigo_primera_propiedad" ) ) .or.;
                                                !empty( hget( ::oModel:hBuffer, "codigo_segunda_propiedad" ) ) )

   METHOD runDialogSeries()

   METHOD onClosedDialog() 

   METHOD Search()

   METHOD deleteLines( cId )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Movimientos de almacen lineas"

   ::oModel                := SQLMovimientosAlmacenLineasModel():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'buildingRowSet',      {|| ::buildingRowSet() } ) 

   ::oDialogView           := MovimientosAlmacenLineasView():New( self )

   ::oSearchView           := SQLSearchView():New( self )

   ::oValidator            := MovimientosAlmacenLineasValidator():New( self )

   ::oSeriesControler      := NumerosSeriesController():New( self )

   ::Super:New( oController )

   ::setEvent( 'closedDialog',      {|| ::onClosedDialog() } )

   ::setEvent( 'appended',          {|| oController:oDialogView:oSQLBrowseView:Refresh() } )
   ::setEvent( 'edited',            {|| oController:oDialogView:oSQLBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',  {|| oController:oDialogView:oSQLBrowseView:Refresh() } )

   ::setEvent( 'deletingLines',     {|| ::oSeriesControler:deletedSelected( ::aSelectDelete ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildingRowSet()

   local uuid        := ::getSenderController():getUuid() 

   if empty( uuid )
      RETURN ( Self )
   end if 

   ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD stampArticulo()

   local hArticulo
   local cCodigoArticulo

   cCodigoArticulo   := ::getModelBuffer( "codigo_articulo" )
   if empty( cCodigoArticulo )
      RETURN ( .t. )
   end if  

   if !( ::oDialogView:oGetCodigoArticulo:isOriginalChanged( cCodigoArticulo ) )
      RETURN ( .t. )
   end if 

   hArticulo         := ArticulosModel():getHash( cCodigoArticulo )
   if empty( hArticulo )
      RETURN ( .t. )
   end if 

   cursorwait()

   ::oDialogView:oGetCodigoArticulo:setOriginal( cCodigoArticulo )

   ::oDialogView:oGetNombreArticulo:cText( hget( hArticulo, "nombre" ) )

   // Adaptaciones de pantalla-------------------------------------------------

   ::showLoteCaducidad( hArticulo )

   ::showProperty( cCodigoArticulo, hArticulo )

   // Lote caducidad------------------------------------------------

   ::stampLoteCaducidad( hArticulo )

   ::stampProperties( cCodigoArticulo, hArticulo )

   cursorwe()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD showLoteCaducidad( hArticulo )

   if hget( hArticulo, "llote" )
      ::oDialogView:showLoteCaducidadControls()
   else 
      ::oDialogView:hideLoteCaducidadControls()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD showProperty( cCodigoArticulo, hArticulo )

   if empty( hget( hArticulo, "ccodprp1" ) ) 

      ::oDialogView:hidePrimeraPropiedad()

      ::oDialogView:hidePropertyBrowseView()

   else 

      if ::lBrowseProperty()

         ::oDialogView:setPropertyOneBrowseView( ::getPrimeraPropiedad( cCodigoArticulo, hget( hArticulo, "ccodprp1" ) ) )

         ::oDialogView:setPropertyTwoBrowseView( ::getSegundaPropiedad( cCodigoArticulo, hget( hArticulo, "ccodprp2" ) ) )

         ::oDialogView:showPropertyBrowseView()

         ::oDialogView:buildPropertyBrowseView()

         // ::oDialogView:oBrowsePropertyView:setOnPostEdit( {|| ::oDialogView:refreshUnidadesImportes() } )

         ::oDialogView:hideUnitsControls()

      else
         
         ::oDialogView:showPrimeraPropiedad()

      end if 

   end if 

   if empty( hget( hArticulo, "ccodprp2" ) ) 

      ::oDialogView:hideSegundaPropiedad()

   else 

      if !( ::lBrowseProperty() )
         ::oDialogView:showSegundaPropiedad()
      end if 

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampProperties( cCodigoArticulo, hArticulo )

   hset( ::oModel:hBuffer, "codigo_primera_propiedad", hget( hArticulo, "ccodprp1" ) )

   hset( ::oModel:hBuffer, "codigo_segunda_propiedad", hget( hArticulo, "ccodprp2" ) )

   if ::lBrowseProperty()

      ::loadValuesBrowseProperty( cCodigoArticulo )

   else 

      if !empty( hget( hArticulo, "ccodprp1" ) )

         ::oDialogView:oPrimeraPropiedadControlView:setSayText( PropiedadesModel():getNombre( hget( hArticulo, "ccodprp1" ) ) )

      end if 

      if !empty( hget( hArticulo, "ccodprp2" ) )

         ::oDialogView:oSegundaPropiedadControlView:setSayText( PropiedadesModel():getNombre( hget( hArticulo, "ccodprp2" ) ) )

      end if 

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampPropertyName( cFieldCodigo, cFieldValor, oControl )

   local cNombrePropiedad

   if empty( hget( ::oModel:hBuffer, cFieldCodigo ) )
      RETURN ( .t. )
   end if 

   if empty( hget( ::oModel:hBuffer, cFieldValor ) )
      RETURN ( .t. )
   end if 

   if empty( oControl )
      RETURN ( .t. )
   end if 

   cNombrePropiedad  := PropiedadesLineasModel():getNombre( hget( ::oModel:hBuffer, cFieldCodigo ), hget( ::oModel:hBuffer, cFieldValor ) )

   oControl:oHelpText:cText( cNombrePropiedad )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampLoteCaducidad( hArticulo )

   local dCaducidad

   if !( hget( hArticulo, "llote" ) )
      RETURN ( .t. )
   end if 

   if !empty( ::oDialogView:oGetLote )
      ::oDialogView:oGetLote:cText( hget( hArticulo, "clote" ) )
   end if 

   if !empty( ::oDialogView:oGetCaducidad ) .and. empty( ::oDialogView:oGetCaducidad:varGet() )

      dCaducidad   := StocksModel():getFechaCaducidad( hget( ::oModel:hBuffer, "codigo_articulo" ), hget( ::oModel:hBuffer, "valor_primera_propiedad" ), hget( ::oModel:hBuffer, "valor_segunda_propiedad" ), , hget( ::oModel:hBuffer, "lote" ) )

      if !empty( dCaducidad )
         ::oDialogView:oGetCaducidad:cText( dCaducidad )
      end if 
   
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getPrimeraPropiedad( cCodigoArticulo, cCodigoPropiedad )

   local aProperties := ArticulosPrecios():getPrimeraPropiedad( cCodigoArticulo, cCodigoPropiedad )

   if empty( aProperties )
      aProperties    := PropiedadesLineasModel():getPropiedadesGeneral( cCodigoArticulo, cCodigoPropiedad )
   end if 

RETURN ( aProperties )

//---------------------------------------------------------------------------//

METHOD getSegundaPropiedad( cCodigoArticulo, cCodigoPropiedad )

   local aProperties := ArticulosPrecios():getSegundaPropiedad( cCodigoArticulo, cCodigoPropiedad )

   if empty( aProperties )
      aProperties    := PropiedadesLineasModel():getPropiedadesGeneral( cCodigoArticulo, cCodigoPropiedad )
   end if 

RETURN ( aProperties )

//---------------------------------------------------------------------------//

METHOD validateLote()

   local cLote

   cLote       := ::getModelBuffer( "lote" )
   if empty( cLote )
      RETURN ( .t. )
   end if  

   if !( ::oDialogView:oLoteCaducidadControlView:isLoteOriginalChanged( cLote ) )
      RETURN ( .t. )
   end if 

   ::oDialogView:oLoteCaducidadControlView:setLoteOriginal( cLote )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD onClosedDialog()

   ::aProperties     := {}

   if !( ::oDialogView:oBrowsePropertyView:lVisible() )
      RETURN ( .t. )
   end if 

   ::aProperties     := ::oDialogView:oBrowsePropertyView:getProperties()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runDialogSeries()

   ::oSeriesControler:SetTotalUnidades( ::oDialogView:nTotalUnidadesArticulo() )

   ::oSeriesControler:SetParentUUID( hget( ::oModel:hBuffer, "uuid" ) )

   if Empty( ::oDialogView:nTotalUnidadesArticulo() )
      MsgStop( "El número de unidades no puede ser 0 para editar números de serie" )
   else
      ::oSeriesControler:Edit()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD loadValuesBrowseProperty( cCodigoArticulo )

   local Uuid
   local aArticulos

   if !( uFieldEmpresa( 'lUseTbl' ) )
      RETURN ( Self )
   end if 

   if ::isNotEditMode()
      RETURN ( Self )
   end if 

   Uuid           := hget( ::getSenderController():oModel:hBuffer, "uuid" )
   if empty( Uuid )
      RETURN ( Self )
   end if 

   aArticulos     := MovimientosAlmacenLineasRepository():getHashArticuloUuid( cCodigoArticulo, Uuid ) 
   if empty( aArticulos )
      RETURN ( Self )
   end if 

   aeval( aArticulos, {|elem| ::oDialogView:oBrowsePropertyView:setValueAndUuidToPropertiesTable( elem ) } )

   ::oDialogView:oBrowsePropertyView:Refresh()

RETURN ( Self )

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

