#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenLineasController FROM SQLBaseController

   DATA aProperties                    INIT {}

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

   METHOD getPrimeraPropiedad( cCodigoArticulo, cCodigoPropiedad )

   METHOD getSegundaPropiedad( cCodigoArticulo, cCodigoPropiedad )

   METHOD onClosedDialog() 

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

   ::setEvent( 'closedDialog', {|| ::onClosedDialog() } )

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

   local uuid        := hget( ::getSenderController():oModel:hBuffer, "uuid" )

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

   if !( ::oDialogView:oGetCodigoArticulo:isOriginalChanged( cCodigoArticulo ) )
      RETURN ( .t. )
   end if 

   cAreaArticulo     := ArticulosModel():get( cCodigoArticulo )
   if empty( cAreaArticulo )
      RETURN ( .t. )
   end if 

   ::oDialogView:oGetCodigoArticulo:Original  := cCodigoArticulo

   ::oDialogView:oGetNombreArticulo:cText( ( cAreaArticulo )->Nombre )

   ::oDialogView:oGetLote:cText( ( cAreaArticulo )->cLote )

   // Primera propiedad--------------------------------------------------------

   if empty( ( cAreaArticulo )->cCodPrp1 )

      ::oDialogView:oBrowsePropertyView:hide()

      ::oDialogView:oGetValorPrimeraPropiedad:hide()

      ::oDialogView:oGetValorSegundaPropiedad:hide()

   else 
   
      hset( ::oModel:hBuffer, "codigo_primera_propiedad", ( cAreaArticulo )->cCodPrp1 )

      ::oDialogView:oGetValorPrimeraPropiedad:oSay:setText( PropiedadesModel():getNombre( ( cAreaArticulo )->cCodPrp1 ) )

      if !uFieldEmpresa( "lUseTbl" )
         ::oDialogView:oGetValorPrimeraPropiedad:Show()
      end if 

      ::oDialogView:oBrowsePropertyView:setPropertyOne( ::getPrimeraPropiedad( cCodigoArticulo, ( cAreaArticulo )->cCodPrp1 ) )

      // Segunda propiedad-----------------------------------------------------

      if !empty( ( cAreaArticulo )->cCodPrp2 )
      
         hset( ::oModel:hBuffer, "codigo_segunda_propiedad", ( cAreaArticulo )->cCodPrp2 )

         ::oDialogView:oGetValorSegundaPropiedad:oSay:setText( PropiedadesModel():getNombre( ( cAreaArticulo )->cCodPrp2 ) )
         
         if !uFieldEmpresa( "lUseTbl" )
            ::oDialogView:oGetValorSegundaPropiedad:Show()
         end if 

         ::oDialogView:oBrowsePropertyView:setPropertyTwo( ::getSegundaPropiedad( cCodigoArticulo, ( cAreaArticulo )->cCodPrp2 ) )

      end if 

      if uFieldEmpresa( "lUseTbl" )
         ::oDialogView:oBrowsePropertyView:build()
      end if 

   end if 

   // Fecha de caducidad-------------------------------------------------------

   ::stampFechaCaducidad()

   ::oDialogView:oGetCodigoArticulo:setOriginal( cCodigoArticulo )

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

   if ::oDialogView:oBrowsePropertyView:lVisible
      ::aProperties  := ::oDialogView:oBrowsePropertyView:getProperties()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
