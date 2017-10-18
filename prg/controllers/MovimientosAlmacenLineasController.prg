#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasController FROM SQLBaseController

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

   METHOD stampPrimeraPropiedad()

   METHOD stampSegundaPropiedad()

   METHOD stampFechaCaducidad()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::cTitle                := "Lineas" // "Movimientos de almacen lineas"

   ::oModel                := SQLMovimientosAlmacenLineasModel():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'buildingRowSet',      {|| ::buildingRowSet() } ) 

   ::oDialogView           := MovimientosAlmacenLineasView():New( self )

   ::oValidator            := MovimientosAlmacenLineasValidator():New( self )

   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer()

   local uuid              := hget( ::getSenderController():oModel:hBuffer, "uuid" )

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildingRowSet()

   local uuid              := hget( ::getSenderController():oModel:hBuffer, "uuid" )

   if empty( uuid )
      RETURN ( Self )
   end if 

   ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD stampArticulo()

   local cAreaArticulo
   local aPropertiesOne
   local aPropertiesTwo
   local cCodigoArticulo

   cCodigoArticulo   := hget( ::oModel:hBuffer, "codigo_articulo" )
   if empty( cCodigoArticulo )
      RETURN ( .t. )
   end if 

   cAreaArticulo     := ArticulosModel():get( cCodigoArticulo )
   if empty( cAreaArticulo )
      RETURN ( .t. )
   end if 

   ::oDialogView:oGetNombreArticulo:cText( ( cAreaArticulo )->Nombre )

   ::oDialogView:oGetLote:cText( ( cAreaArticulo )->cLote )

   // Primera propiedad--------------------------------------------------------

   if !empty( ( cAreaArticulo )->cCodPrp1 )
   
      hset( ::oModel:hBuffer, "codigo_primera_propiedad", ( cAreaArticulo )->cCodPrp1 )

      ::oDialogView:oGetValorPrimeraPropiedad:oSay:setText( PropiedadesModel():getNombre( ( cAreaArticulo )->cCodPrp1 ) )
      
      ::oDialogView:oGetValorPrimeraPropiedad:Show()

      // aPropertiesOne := 

      ::oDialogView:oBrowsePropertyView:setPropertyOne( PropiedadesLineasModel():getPropiedadesGeneral( cCodigoArticulo, ( cAreaArticulo )->cCodPrp1 ) )

   end if 

   // Segunda propiedad--------------------------------------------------------

   if !empty( ( cAreaArticulo )->cCodPrp2 )
   
      hset( ::oModel:hBuffer, "codigo_segunda_propiedad", ( cAreaArticulo )->cCodPrp2 )

      ::oDialogView:oGetValorSegundaPropiedad:oSay:setText( PropiedadesModel():getNombre( ( cAreaArticulo )->cCodPrp2 ) )
      
      ::oDialogView:oGetValorSegundaPropiedad:Show()

      ::oDialogView:oBrowsePropertyView:setPropertyTwo( PropiedadesLineasModel():getPropiedadesGeneral( cCodigoArticulo, ( cAreaArticulo )->cCodPrp2 ) )

   end if 

   ::oDialogView:oBrowsePropertyView:build()

   // Fecha de caducidad-------------------------------------------------------

   ::stampFechaCaducidad()

   // Area de trabajo----------------------------------------------------------

   ArticulosModel():closeArea( cAreaArticulo )

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

METHOD stampFechaCaducidad()

   local dFechaCaducidad   := StocksModel():getFechaCaducidad( hget( ::oModel:hBuffer, "codigo_articulo" ), hget( ::oModel:hBuffer, "valor_primera_propiedad" ), hget( ::oModel:hBuffer, "valor_segunda_propiedad" ), , hget( ::oModel:hBuffer, "lote" ) )

   if !empty( dFechaCaducidad )
      ::oDialogView:oGetFechaCaducidad:cText( dFechaCaducidad )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//


