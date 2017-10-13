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

   DATA nNumRem
   DATA cSufRem

   DATA dFecha
   DATA cHora

   DATA nContadorLinea

   METHOD New()

   METHOD Process()

   METHOD addCabecera()

   METHOD addLinea( oStock )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView, oStock ) CLASS RegularizaArticulos

   local nRec
   local nOrdAnt

   ::nView                       := nView
   ::oStock                      := oStock

   ::cArticulo                   := space( 18 )
   ::cLote                       := space( 14 )
   ::cAlmacen                    := Padr( cDefAlm(), 16 )

   ::nContadorLinea              := 1

   ::nNumRem                     := 0
   ::cSufRem                     := ""

   nRec                          := ( D():Articulos( ::nView ) )->( Recno() )
   nOrdAnt                       := ( D():Articulos( ::nView ) )->( OrdSetFocus( "Codigo" ) )

   MsgGet( "Seleccione un artículo", "Artículo: ", @::cArticulo )
   MsgGet( "Seleccione un almacén", "Almacén: ", @::cAlmacen )
   MsgGet( "Seleccione un lote", "Lote: ", @::cLote )

   if ( D():Articulos( ::nView ) )->( dbSeek( ::cArticulo ) )

      if ( D():Almacen( ::nView ) )->( dbSeek( ::cAlmacen ) )   
      
         MsgRun( "Integrando datos", "Espere por favor", {|| ::Process() } )
      
      else
      
         MsgStop( "El anmacén introducido no existe en la base se datos", ::cAlmacen )
      
      end if

   else

      MsgStop( "El artículo introducido no existe en la base se datos", ::cArticulo )

   end if

   ( D():Articulos( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Articulos( ::nView ) )->( dbGoTo( nRec ) )

   if ::nNumRem != 0
      MsgInfo( "Movimiento generado con número: " + AllTrim( Str( ::nNumRem ) ) + "/" + ::cSufRem, "Proceso Realizado con éxito" )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Process() CLASS RegularizaArticulos

   local aStockArticulo    := {}
   local oStock
   local nTotalStock       := 0

   //Calcular el Stock---------------------------------------------------------

   aStockArticulo          := ::oStock:aStockArticulo( ::cArticulo, ::cAlmacen )

   if len( aStockArticulo ) != 0

      //-----------------------------------------------------------------------

      ::addCabecera()

      for each oStock in aStockArticulo

         if oStock:cCodigoAlmacen == ::cAlmacen

            ::addLinea( oStock )

            nTotalStock          += oStock:nUnidades

         end if

      next

      ::addLinea( nil, nTotalStock )

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD addCabecera() CLASS RegularizaArticulos

   ::nNumRem            := nNewDoc( nil, D():MovimientosAlmacen( ::nView ), "nMovAlm", nil, D():Contadores( ::nView ) )
   ::cSufRem            := RetSufEmp()
   ::dFecha             := GetSysDate()
   ::cHora              := GetSysTime()

   ( D():MovimientosAlmacen( ::nView ) )->( dbAppend() )
   
   ( D():MovimientosAlmacen( ::nView ) )->lSelDoc      := .t.
   ( D():MovimientosAlmacen( ::nView ) )->nNumRem      := ::nNumRem
   ( D():MovimientosAlmacen( ::nView ) )->cSufRem      := ::cSufRem
   ( D():MovimientosAlmacen( ::nView ) )->nTipMov      := 4
   ( D():MovimientosAlmacen( ::nView ) )->cCodUsr      := cCurUsr()
   ( D():MovimientosAlmacen( ::nView ) )->cCodDlg      := ::cSufRem
   ( D():MovimientosAlmacen( ::nView ) )->dFecRem      := ::dFecha
   ( D():MovimientosAlmacen( ::nView ) )->cTimRem      := ::cHora
   ( D():MovimientosAlmacen( ::nView ) )->cAlmDes      := ::cAlmacen
   ( D():MovimientosAlmacen( ::nView ) )->cCodDiv      := cDivEmp()
   ( D():MovimientosAlmacen( ::nView ) )->nVdvDiv      := 1
   ( D():MovimientosAlmacen( ::nView ) )->cComMov      := "Regularización por script"
   ( D():MovimientosAlmacen( ::nView ) )->nTotRem      := 0

   ( D():MovimientosAlmacen( ::nView ) )->( dbUnLock() )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD addLinea( oStock, nTotalUnidades ) CLASS RegularizaArticulos

   ( D():MovimientosAlmacenLineas( ::nView ) )->( dbAppend() )

   ( D():MovimientosAlmacenLineas( ::nView ) )->nNumRem        := ::nNumRem
   ( D():MovimientosAlmacenLineas( ::nView ) )->cSufRem        := ::cSufRem
   ( D():MovimientosAlmacenLineas( ::nView ) )->dFecMov        := ::dFecha
   ( D():MovimientosAlmacenLineas( ::nView ) )->cTimMov        := ::cHora
   ( D():MovimientosAlmacenLineas( ::nView ) )->nTipMov        := 4
   ( D():MovimientosAlmacenLineas( ::nView ) )->cAliMov        := ::cAlmacen
   ( D():MovimientosAlmacenLineas( ::nView ) )->cRefMov        := ::cArticulo
   ( D():MovimientosAlmacenLineas( ::nView ) )->cCodUsr        := cCurUsr()
   ( D():MovimientosAlmacenLineas( ::nView ) )->cCodDlg        := ::cSufRem
   ( D():MovimientosAlmacenLineas( ::nView ) )->nCajMov        := 1
   ( D():MovimientosAlmacenLineas( ::nView ) )->lSndDoc        := .t.
   ( D():MovimientosAlmacenLineas( ::nView ) )->cNomMov        := ( D():Articulos( ::nView ) )->Nombre
   ( D():MovimientosAlmacenLineas( ::nView ) )->lLote          := ( D():Articulos( ::nView ) )->lLote
   ( D():MovimientosAlmacenLineas( ::nView ) )->nNumLin        := ::nContadorLinea

   if !Empty( oStock )

      MsgWait( oStock:cLote, Str( ::nContadorLinea ), 0.001 )

      ( D():MovimientosAlmacenLineas( ::nView ) )->nUndMov        := 0
      ( D():MovimientosAlmacenLineas( ::nView ) )->cLote          := oStock:cLote

   else

      MsgWait( ::cLote, Str( ::nContadorLinea ), 0.001 )

      ( D():MovimientosAlmacenLineas( ::nView ) )->nUndMov        := nTotalUnidades
      ( D():MovimientosAlmacenLineas( ::nView ) )->cLote          := ::cLote

   end if

   ( D():MovimientosAlmacenLineas( ::nView ) )->( dbUnLock() )

   ::nContadorLinea++

Return ( Self )

//---------------------------------------------------------------------------//