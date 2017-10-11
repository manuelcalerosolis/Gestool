#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView, oStock )

   local oImportaArticulos := RegularizaArticulos():New( nView, oStock )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS RegularizaArticulos

   DATA nView
   DATA oStock

   DATA cArticulo
   DATA cLote
   DATA cAlmacen

   METHOD New()

   METHOD Process()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oStock ) CLASS RegularizaArticulos

   local nRec
   local nOrdAnt

   ::nView                       := nView
   ::oStock                      := oStock

   ::cArticulo                   := space( 18 )
   ::cLote                       := space( 14 )
   ::cAlmacen                    := space( 16 )

   nRec                          := ( D():Articulos( ::nView ) )->( Recno() )
   nOrdAnt                       := ( D():Articulos( ::nView ) )->( OrdSetFocus( "Codigo" ) )

   MsgGet( "Seleccione un artículo", "Artículo: ", @::cArticulo )
   MsgGet( "Seleccione un almacén", "Almacén: ", @::cAlmacen )
   MsgGet( "Seleccione un lote", "Lote: ", @::cLote )

   if ( D():Articulos( ::nView ) )->( dbSeek( ::cArticulo ) )
      MsgRun( "Integrando datos", "Espere por favor", {|| ::Process() } )
   else
      MsgStop( "El artículo introducido no existe en la base se datos", ::cArticulo )
   end if

   ( D():Articulos( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Articulos( ::nView ) )->( dbGoTo( nRec ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Process() CLASS RegularizaArticulos

   local aStockArticulo    := {}

   MsgInfo( ::cArticulo, "::cArticulo" )
   MsgInfo( ::cLote, "::cLote" )
   MsgInfo( ::cAlmacen, "::cAlmacen" )

   //Calcular el Stock---------------------------------------------------------

   aStockArticulo          := ::oStock:aStockArticulo( ::cArticulo, ::cAlmacen )

   MsgInfo( hb_valtoexp( aStockArticulo ), "aStockArticulo" )

Return ( Self )

//---------------------------------------------------------------------------//