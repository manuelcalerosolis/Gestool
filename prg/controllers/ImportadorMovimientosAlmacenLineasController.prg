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

   METHOD creaRegistro()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oStock             := TStock():New()

   ::cTitle             := "Importador movimientos almacen lineas"

   ::oDialogView        := ImportadorMovimientosAlmacenLineasView():New( self )

   ::oValidator         := ImportadorMovimientosAlmacenLineasValidator():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::Super:End()

   ::oStock:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   if empty( ::oSenderController:oDialogView:oGetAlmacenDestino:varGet() )
      msgStop( "Es necesario cumplimentar el almacén destino" )
      RETURN ( Self )      
   end if 
      
RETURN ( ::oDialogView:Activate() )

//---------------------------------------------------------------------------//

METHOD importarAlmacen()

   local cArea          := "ArtToImport"

   ArticulosModel():getArticulosToImport( @cArea, ::oDialogView:getRange() )

   ::oDialogView:oMtrStock:setTotal( ( cArea )->( lastrec() ) )

   while !( cArea )->( eof() )

      ::calculaStock( cArea )

      ::oDialogView:oMtrStock:autoInc()

      ( cArea )->( dbskip() )

   end while

   CLOSE ( cArea )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD calculaStock( cArea )

   local aStockArticulo 

   aStockArticulo       := ::oStock:aStockArticulo( ( cArea )->Codigo, ::oSenderController:oDialogView:oGetAlmacenDestino:varGet() )

   aeval( aStockArticulo, {|sStockArticulo| if( sStockArticulo:nUnidades != 0, ::creaRegistro( cArea, sStockArticulo ), ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD creaRegistro( cArea, sStockArticulo )

   local nId
   local hBuffer

   hBuffer                                := ::oSenderController:oLineasController:oModel:loadBlankBuffer()

   hBuffer[ "parent_uuid" ]               := ::getSenderController():getUuid()
   hBuffer[ "codigo_articulo" ]           := ( cArea )->Codigo
   hBuffer[ "nombre_articulo" ]           := ( cArea )->Nombre
   hBuffer[ "precio_articulo" ]           := ( cArea )->pCosto
   hBuffer[ "codigo_primera_propiedad" ]  := sStockArticulo:cCodigoPropiedad1
   hBuffer[ "valor_primera_propiedad" ]   := sStockArticulo:cValorPropiedad1
   hBuffer[ "codigo_segunda_propiedad" ]  := sStockArticulo:cCodigoPropiedad2
   hBuffer[ "valor_segunda_propiedad" ]   := sStockArticulo:cValorPropiedad2
   hBuffer[ "lote" ]                      := sStockArticulo:cLote
   hBuffer[ "unidades_articulo" ]         := sStockArticulo:nUnidades

   nId                                    := ::oSenderController:oLineasController:oModel:insertBuffer( hBuffer )

   if !empty( nId )
      ::oSenderController:oLineasController:refreshRowSetAndFind( nId )
      ::oSenderController:oLineasController:oBrowseView:Refresh()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//
