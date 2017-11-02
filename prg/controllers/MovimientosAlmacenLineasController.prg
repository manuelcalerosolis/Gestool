#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasController FROM SQLBaseController

   DATA oSeriesControler

   DATA oSearchView

   DATA aProperties                    INIT {}

   DATA aSelectDelete                  INIT {}

   METHOD New()

   METHOD loadedBlankBuffer()

   METHOD buildingRowSet()

   METHOD validateCodigoArticulo()     INLINE   (  iif(  ::validate( "codigo_articulo" ),;
                                                         ::stampArticulo(),;
                                                         .f. ) )

   METHOD validatePrimeraPropiedad()   INLINE   (  iif(  ::validate( "valor_primera_propiedad" ),;
                                                         ::stampPrimeraPropiedad(),;
                                                         .f. ) )

   METHOD validateSegundaPropiedad()   INLINE   (  iif(  ::validate( "valor_segunda_propiedad" ),;
                                                         ::stampSegundaPropiedad(),;
                                                         .f. ) )

   METHOD stampArticulo()

   METHOD stampLote()
   
   METHOD stampPrimeraPropiedad()

   METHOD stampSegundaPropiedad()

   METHOD stampFechaCaducidad()

   METHOD stampStockAlmacenOrigen()

   METHOD stampStockAlmacenDestino()

   METHOD getPrimeraPropiedad( cCodigoArticulo, cCodigoPropiedad )

   METHOD getSegundaPropiedad( cCodigoArticulo, cCodigoPropiedad )

   METHOD shopPropiedades()

   METHOD showPrimeraPropiedad()       INLINE ( if( !uFieldEmpresa( "lUseTbl" ), ::oDialogView:oGetValorPrimeraPropiedad:Show(), ) )
   
   METHOD showSegundaPropiedad()       INLINE ( if( !uFieldEmpresa( "lUseTbl" ), ::oDialogView:oGetValorSegundaPropiedad:Show(), ) )

   METHOD buildBrowseProperty()        INLINE ( if( uFieldEmpresa( "lUseTbl" ), ::oDialogView:oBrowsePropertyView:build(), ) )
   
   METHOD loadValuesBrowseProperty()

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

   ::setEvent( 'closedDialog',   {|| ::onClosedDialog() } )

   ::setEvent( 'deletingLines',  {|| ::oSeriesControler:deletedSelected( ::aSelectDelete ) } )

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
   local hHashCodeGS128
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

   ::oDialogView:oGetCodigoArticulo:setOriginal( cCodigoArticulo )

   ::oDialogView:oGetNombreArticulo:cText( hget( hArticulo, "nombre" ) )

   // Lote---------------------------------------------------------------------

   ::stampLote( hArticulo )

   // Primera propiedad--------------------------------------------------------

   ::shopPropiedades( cCodigoArticulo, hArticulo )

   // Fecha de caducidad-------------------------------------------------------

   ::stampFechaCaducidad()

   // Informacion de stock en almacen origen-----------------------------------

   ::stampStockAlmacenOrigen()

   ::stampStockAlmacenDestino()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD shopPropiedades( cCodigoArticulo, hArticulo )

   hset( ::oModel:hBuffer, "codigo_primera_propiedad", hget( hArticulo, "ccodprp1" ) )

   hset( ::oModel:hBuffer, "codigo_segunda_propiedad", hget( hArticulo, "ccodprp2" ) )

   // Primera propiedad--------------------------------------------------------

   if empty( hget( hArticulo, "ccodprp1" ) )

      ::oDialogView:oBrowsePropertyView:hide()

      ::oDialogView:oGetValorPrimeraPropiedad:hide()

      ::oDialogView:oGetValorSegundaPropiedad:hide()

   else 
   
      ::oDialogView:oGetValorPrimeraPropiedad:oSay:setText( PropiedadesModel():getNombre( hget( hArticulo, "ccodprp1" ) ) )

      ::showPrimeraPropiedad()

      ::oDialogView:oBrowsePropertyView:setPropertyOne( ::getPrimeraPropiedad( cCodigoArticulo, hget( hArticulo, "ccodprp1" ) ) )

      // Segunda propiedad-----------------------------------------------------

      if !empty( hget( hArticulo, "ccodprp2" ) )
      
         ::oDialogView:oGetValorSegundaPropiedad:oSay:setText( PropiedadesModel():getNombre( hget( hArticulo, "ccodprp2" ) ) )

         ::showSegundaPropiedad()
         
         ::oDialogView:oBrowsePropertyView:setPropertyTwo( ::getSegundaPropiedad( cCodigoArticulo, hget( hArticulo, "ccodprp2" ) ) )

      end if 

      ::buildBrowseProperty()

      ::loadValuesBrowseProperty( cCodigoArticulo )

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampPrimeraPropiedad()

   local cNombrePropiedad

   if empty( hget( ::oModel:hBuffer, "codigo_primera_propiedad" ) )
      RETURN .t.
   end if 

   if empty( hget( ::oModel:hBuffer, "valor_primera_propiedad" ) )
      RETURN .t.
   end if 

   cNombrePropiedad  := PropiedadesLineasModel():getNombre( hget( ::oModel:hBuffer, "codigo_primera_propiedad" ), hget( ::oModel:hBuffer, "valor_primera_propiedad" ) )

   ::oDialogView:oGetValorPrimeraPropiedad:oHelpText:cText( cNombrePropiedad )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampSegundaPropiedad()

   local cNombrePropiedad

   if empty( hget( ::oModel:hBuffer, "codigo_segunda_propiedad" ) )
      RETURN .t.
   end if 

   if empty( hget( ::oModel:hBuffer, "valor_segunda_propiedad" ) )
      RETURN .t.
   end if 

   cNombrePropiedad  := PropiedadesLineasModel():getNombre( hget( ::oModel:hBuffer, "codigo_segunda_propiedad" ), hget( ::oModel:hBuffer, "valor_segunda_propiedad" ) )

   ::oDialogView:oGetValorSegundaPropiedad:oHelpText:cText( cNombrePropiedad )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampLote( hArticulo )

   if empty( ::oDialogView:oGetLote:varGet() )
      ::oDialogView:oGetLote:cText( hget( hArticulo, "clote" ) )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampFechaCaducidad()

   local dFechaCaducidad

   if empty( ::oDialogView:oGetFechaCaducidad:varGet() )

      dFechaCaducidad   := StocksModel():getFechaCaducidad( hget( ::oModel:hBuffer, "codigo_articulo" ), hget( ::oModel:hBuffer, "valor_primera_propiedad" ), hget( ::oModel:hBuffer, "valor_segunda_propiedad" ), , hget( ::oModel:hBuffer, "lote" ) )

      if !empty( dFechaCaducidad )
         ::oDialogView:oGetFechaCaducidad:cText( dFechaCaducidad )
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

METHOD onClosedDialog()

   ::aProperties     := {}

   if !( ::oDialogView:oBrowsePropertyView:lVisible )
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

METHOD stampStockAlmacenOrigen()    

   if !Empty( ::getSenderController():oModel:hBuffer[ "almacen_origen" ] )
      ::oDialogView:oGetStockOrigen:cText( TStock():nSQLStockActual( ::oModel:hBuffer[ "codigo_articulo" ], ::getSenderController():oModel:hBuffer[ "almacen_origen" ], ::oModel:hBuffer[ "valor_primera_propiedad" ], ::oModel:hBuffer[ "valor_segunda_propiedad" ], ::oModel:hBuffer[ "lote" ] ) )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD stampStockAlmacenDestino()

   if !Empty( ::getSenderController():oModel:hBuffer[ "almacen_destino" ] )
      ::oDialogView:oGetStockDestino:cText( TStock():nSQLStockActual( ::oModel:hBuffer[ "codigo_articulo" ], ::getSenderController():oModel:hBuffer[ "almacen_destino" ], ::oModel:hBuffer[ "valor_primera_propiedad" ], ::oModel:hBuffer[ "valor_segunda_propiedad" ], ::oModel:hBuffer[ "lote" ] ) )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//