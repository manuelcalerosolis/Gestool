#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImportadorMovimientosAlmacenLineasController FROM SQLBaseController

   DATA oStock

   METHOD New( oController )

   METHOD End()

   METHOD Activate()

   METHOD importarAlmacen()

   METHOD calculaStock( cArea )
      METHOD procesaStock( sStockArticulo )

   METHOD creaRegistro()

   METHOD validateFamiliaInicio()            INLINE ( iif(  ::validate( "codigo_familia_inicio", ::oDialogView:oFamiliaInicio:varGet() ),;
                                                            ::stampNombreFamilia( ::oDialogView:oFamiliaInicio ),;
                                                            .f. ) )

   METHOD stampNombreFamilia( oFamilia )     INLINE ( oFamilia:oHelpText:cText( FamiliasModel():getNombre( oFamilia:varGet() ) ), .t. )

   METHOD stampArticuloNombre( oArticulo )   INLINE ( oArticulo:oHelpText:cText( SQLArticulosModel():getNombre( oArticulo:varGet() ) ), .t. )

   METHOD isConsolidacion()                  INLINE ( ::oController:oDialogView:oRadioTipoMovimento:nOption() == __tipo_movimiento_consolidacion__ )

   METHOD getUnidadesStock( sStockArticulo ) INLINE ( iif( ::isConsolidacion(), 0, sStockArticulo:nUnidades ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oStock             := TStock():New()

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportadorMovimientosAlmacenLineasView():New( self )

   ::oValidator         := ImportadorDocumentosLineasValidator():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::Super:End()

   ::oStock:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   if empty( ::oController:oDialogView:oGetAlmacenDestino:varGet() )
      msgStop( "Es necesario cumplimentar el almac�n destino" )
      RETURN ( Self )      
   end if 

RETURN ( ::oDialogView:Activate() )

//---------------------------------------------------------------------------//

METHOD importarAlmacen()

   local cArea          := "ArtToImport"

   SQLArticulosModel():getArticulosToImport( @cArea, ::oDialogView:getRange() )

   ::oDialogView:oMtrStock:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      ::calculaStock( cArea )

      ::oDialogView:oMtrStock:autoInc()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

   ::oController:oLineasController:oBrowseView:goTop()
   ::oController:oLineasController:oBrowseView:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD calculaStock( cArea )

   local aStockArticulo 

   aStockArticulo       := ::oStock:aStockArticulo( ( cArea )->Codigo, ::oController:oDialogView:oGetAlmacenDestino:varGet() )

   aeval( aStockArticulo, {|sStockArticulo| ::procesaStock( sStockArticulo, cArea ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD procesaStock( sStockArticulo, cArea )

   if sStockArticulo:nUnidades != 0 .or. ::oDialogView:lStockCero
      ::creaRegistro( cArea, sStockArticulo )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD creaRegistro( cArea, sStockArticulo )

   local nId
   local hBuffer

   hBuffer                                := ::oController:oLineasController:oModel:loadBlankBuffer()

   hBuffer[ "parent_uuid" ]               := ::getController():getUuid()
   hBuffer[ "codigo_articulo" ]           := ( cArea )->Codigo
   hBuffer[ "nombre_articulo" ]           := ( cArea )->Nombre
   hBuffer[ "precio_articulo" ]           := ( cArea )->pCosto
   hBuffer[ "codigo_primera_propiedad" ]  := sStockArticulo:cCodigoPropiedad1
   hBuffer[ "valor_primera_propiedad" ]   := sStockArticulo:cValorPropiedad1
   hBuffer[ "codigo_segunda_propiedad" ]  := sStockArticulo:cCodigoPropiedad2
   hBuffer[ "valor_segunda_propiedad" ]   := sStockArticulo:cValorPropiedad2
   hBuffer[ "lote" ]                      := sStockArticulo:cLote

   hBuffer[ "unidades_articulo" ]         := ::getUnidadesStock( sStockArticulo )

   nId                                    := ::oController:oLineasController:oModel:insertBuffer( hBuffer )

   if !empty( nId )
      ::oController:oLineasController:refreshRowSetAndFindId( nId )
      ::oController:oLineasController:oBrowseView:Refresh()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//
