#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"
#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TImportarExcelArguelles():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelArguelles FROM TImportarExcel

   DATA nFila
   DATA nFilaInicio
   DATA nFilaFinal
   DATA nContadorPagina
   DATA aLineasPedido
   DATA lFinPage

   DATA hLine

   DATA cCodigoProveedor

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD procesaFicheroExcel()

   METHOD procesaHojaExcel( nContadorPagina )

   METHOD procesaLinea()

   METHOD procesaLote()

   METHOD getLotesLine()

   METHOD formatArrayLote( aLotes )

   METHOD addCabeceraFactura()

   METHOD addLineasFactura()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   ::cFicheroExcel            := cGetFile( "Excel ( *.Xlsx ) | " + "*.Xlsx", "Seleccione la hoja de calculo" )

   ::aLineasPedido            := {}

   ::nContadorPagina          := 1
   ::nFilaInicio              := 57
   ::nFilaFinal               := 84
   ::lFinPage                 := .f.

   ::cColumnaCampoClave       := 'A'

   ::cCodigoProveedor         := '0000001'

   ::hLine                    := {=>}

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   msgrun( "Procesando fichero " + ::cFicheroExcel, "Espere por favor...",  {|| ::procesaFicheroExcel() } )

   msginfo( "Proceso finalizado" )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::oExcel                      := TOleExcel():New( "Importando hoja de excel", "Conectando...", .f. )

   ::oExcel:oExcel:Visible       := .t.
   ::oExcel:oExcel:DisplayAlerts := .f.
   ::oExcel:oExcel:WorkBooks:Open( ::cFicheroExcel )
   
   while !::lFinPage

      ::procesaHojaExcel()

      ::nContadorPagina               := ::nContadorPagina + 1

   end while

   ::oExcel:oExcel:Quit()
   ::oExcel:oExcel:DisplayAlerts := .t.
   ::oExcel:End()

Return nil

//---------------------------------------------------------------------------//

METHOD procesaHojaExcel()

   if !::lFinPage
      ::oExcel:oExcel:WorkSheets( ::nContadorPagina ):Activate()
   end if

   for ::nFila := ::nFilaInicio to ::nFilaFinal

      if ::lFinPage
         Return nil      
      end if

      ::procesaLinea()

      ::procesaLote()

      ::hLine     := {=>}

   next

   ::addCabeceraFactura()

   ::addLineasFactura()

Return nil

//---------------------------------------------------------------------------//

METHOD procesaLinea()

   if Empty( ::getExcelString( "A", ::nFila ) )
      ::lFinPage := .t.
   end if

   hSet( ::hLine, "codigoBaras", ::getExcelString( "A", ::nFila ) )
   hSet( ::hLine, "descripcion", ::getExcelString( "D", ::nFila ) )
   hSet( ::hLine, "unidades", ::getExcelNumeric( "J", ::nFila ) )
   hSet( ::hLine, "lote", "" )
   hSet( ::hLine, "caducidad", "" )
   hSet( ::hLine, "preciounitario", ::getExcelNumeric( "P", ::nFila ) )
   hSet( ::hLine, "bruto", ::getExcelNumeric( "Q", ::nFila ) )
   hSet( ::hLine, "descuento", ::getExcelNumeric( "T", ::nFila ) )
   hSet( ::hLine, "puntoVerde", ::getExcelNumeric( "AA", ::nFila ) )

   ::nFila    := ::nFila + 1

Return nil

//---------------------------------------------------------------------------//

METHOD procesaLote()

   local cString
   local hlin
   local hLote
   local aLotes      := ::getLotesLine()

   hLin              := ::hLine

   if Empty( aLotes )

      aadd( ::aLineasPedido, hLin )

   else

      for each hLote in aLotes

         hSet( hLin, "lote", hGet( hLote, "lote" ) )
         hSet( hLin, "unidades", hGet( hLote, "unidades" ) )
         hSet( hLin, "caducidad", hGet( hLote, "caducidad" ) )

         aadd( ::aLineasPedido, hLin )

      next

   end if

Return nil

//---------------------------------------------------------------------------//

METHOD getLotesLine()

   local cString
   local aLotes      := {}

   cString           := ::getExcelString( "H", ::nFila )

   if At( ";", cString ) != 0

      aLotes   := HB_ATokens( cString, ";" )

   else

      aAdd( aLotes, cString )

   end if

Return ::formatArrayLote( aLotes )

//---------------------------------------------------------------------------//

METHOD formatArrayLote( aLotes )

   local cLote
   local hLotes      := {=>}
   local aHashLotes  := {}

   if Empty( aLotes )
      Return ( hLotes )
   end if

   for each cLote in aLotes

      hLotes      := {=>}

      hSet( hLotes, "lote", AllTrim( SubStr( cLote, 1, at( "[", cLote ) -1 ) ) )
      hSet( hLotes, "unidades", SubStr( cLote, at( "[", cLote ) + 1, ( at( "]", cLote ) ) - ( at( "[", cLote ) + 1 ) ) )
      hSet( hLotes, "caducidad", cTod( "01" + AllTrim( SubStr( cLote, at( "]", cLote ) + 1 ) ) ), "Caducidad" )

      aAdd( aHashLotes, hLotes )

   end if

Return ( aHashLotes )

//---------------------------------------------------------------------------//

METHOD addCabeceraFactura()

   MsgInfo( ::cCodigoProveedor, "cCodigoProveedor" )

   //( FacturasProveedores( nView ) )->( dbAppend() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD addLineasFactura()

   MsgInfo( hb_valToExp( ::aLineasPedido ) , "Lineas" )

Return ( .t. )

//---------------------------------------------------------------------------//   

#include "ImportarExcel.prg"

/*
METHOD getExcelValue( columna, fila, valorPorDefecto )

METHOD getExcelString( columna, fila )
                                                 
METHOD getExcelNumeric( columna, fila )

METHOD getExcelLogic( columna, fila )

*/