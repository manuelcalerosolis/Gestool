#include "hbclass.ch"

#define __separtor__    "|#|"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   ImportacionUVERisi():New()

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS ImportacionUVERisi

   DATA nView

   DATA oUve

   DATA cFileUVE
   DATA nFileHandle

   DATA aUVELines                               INIT {}

   DATA currentInvoice

   DATA serieInvoice
   DATA numberInvoice
   DATA delegationInvoice

   METHOD New()                                 CONSTRUCTOR

   METHOD getFileUVE()
   METHOD isFileUVE() 
   METHOD openFileUVE()
   METHOD closeFileUVE()                        INLINE ( fclose( ::nFileHandle ) )
   METHOD processFileUVE()
      METHOD processLineUVE( cLine)             
         METHOD insertLineUVE( aLine )
   METHOD sortUveLinesByInvoiceId()
   METHOD processUVELinesByInvoiceId()
      METHOD isInvoiceChange( hUVELine )        INLINE ( hget( hUVELine, "NumeroFactura" ) != ::currentInvoice )
      METHOD insertInvoiceHeader( hUVELine )
      METHOD getNewInvoiceNumber( hUVELine )
      METHOD insertInvoiceLine( hUVELine )
   
   METHOD writeUVEtoGestool()                   VIRTUAL

   METHOD OpenFiles()
   METHOD CloseFiles()                          INLINE ( D():DeleteView( ::nView ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ImportacionUVERisi

   ::getFileUVE()

   if !::isFileUVE()
      Return ( Self )
   end if

   if ::openFileUVE()
      ::processFileUVE()
      ::closeFileUVE()
   end if 

   if !::OpenFiles()
      Return ( Self )
   end if 

   ::sortUveLinesByInvoiceId()

   ::processUVELinesByInvoiceId()

   ::CloseFiles()

   msgInfo( "Porceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getFileUVE()

   ::cFileUVE  := cGetFile( "Csv ( *.* ) | " + "*.*", "Seleccione el fichero a importar" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isFileUVE()

   if !empty( ::cFileUVE )
      Return ( file( ::cFileUVE ) )
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD openFileUVE()

   ::nFileHandle := fOpen( ::cFileUVE )

   if ferror() != 0
      Return ( .f. )
   end if  

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processFileUVE()

   local cLine 

   while ( hb_freadline( ::nFileHandle, @cLine ) == 0 )
      ::processLineUVE( cLine )
   end while  
   
Return ( Self )

//---------------------------------------------------------------------------//

METHOD processLineUVE( cLine )

   local aLine          := hb_atokens( cLine, __separtor__ )

   if !empty( aLine )
      ::insertLineUVE( aLine )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertLineUVE( aLine )

   local hUve   := {=>}

   hset( hUve, "NumeroFactura",                 aLine[ 1 ] )
   hset( hUve, "NumeroLinea",                   aLine[ 2 ] )
   hset( hUve, "CodigoProducto",                aLine[ 3 ] )
   hset( hUve, "DescripciónProducto",           aLine[ 4 ] )
   hset( hUve, "Fabricante",                    aLine[ 5 ] )
   hset( hUve, "CodigoProductoFabricante",      aLine[ 6 ] )
   hset( hUve, "EAN13",                         aLine[ 7 ] )
   hset( hUve, "Cantidad",                      aLine[ 8 ] )
   hset( hUve, "UnidadMedición",                aLine[ 9 ] )
   hset( hUve, "PrecioBase",                    aLine[ 10 ] )
   hset( hUve, "Descuentos",                    aLine[ 11 ] )
   hset( hUve, "PrecioBrutoTotal",              aLine[ 12 ] )
   hset( hUve, "FechaFactura",                  aLine[ 13 ] )
   hset( hUve, "Ejercicio",                     aLine[ 14 ] )
   hset( hUve, "CodigoCliente",                 aLine[ 15 ] )
   hset( hUve, "Nombre",                        aLine[ 16 ] )
   hset( hUve, "RazonSocial",                   aLine[ 17 ] )
   hset( hUve, "CIF",                           aLine[ 18 ] )
   hset( hUve, "Direccion",                     aLine[ 19 ] )
   hset( hUve, "Poblacion",                     aLine[ 20 ] )
   hset( hUve, "CodigoPostal",                  aLine[ 21 ] )
   hset( hUve, "Ruta",                          aLine[ 22 ] )
   hset( hUve, "NombreRuta",                    aLine[ 23 ] )
   hset( hUve, "CodigoComercial",               aLine[ 24 ] )
   hset( hUve, "NombreComercial",               aLine[ 25 ] )
   hset( hUve, "Peso",                          aLine[ 26 ] )
   hset( hUve, "UMPeso",                        aLine[ 27 ] )
   hset( hUve, "TipoCliente",                   aLine[ 28 ] )
   hset( hUve, "Telefono",                      aLine[ 29 ] )
   hset( hUve, "DescripciónTipoCliente",        aLine[ 30 ] )

   aadd( ::aUVELines, hUve )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() 

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )    
      ( D():FacturasClientesLineas( ::nView ) )->( ordsetfocus( "nNumLin" ) )

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():GruposClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

      D():Contadores( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD sortUveLinesByInvoiceId()

   asort( ::aUVELines, , , {|x,y| hget( x, "NumeroFactura" ) < hget( y, "NumeroFactura" ) } )

Return ( self )
//---------------------------------------------------------------------------//

METHOD processUVELinesByInvoiceId()

   local hUVELine

   for each hUVELine in ::aUVELines 

      if ::isInvoiceChange( hUVELine )
         ::getNewInvoiceNumber()
         ::insertInvoiceHeader( hUVELine )
      end if

      ::insertInvoiceLine( hUVELine )

   next

Return ( self )

//---------------------------------------------------------------------------//

METHOD getNewInvoiceNumber( hUVELine )
   
   ::currentInvoice     := hget( hUVELine, "NumeroFactura" )
   ::serieInvoice       := "A"
   ::numberInvoice      := nNewDoc( ::serieInvoice, D():FacturasClientes( ::nView ), "nFacCli", , D():Contadores( ::nView ) )
   ::delegationInvoice  := retSufEmp()

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertInvoiceHeader( hUVELine )
   
   msgWait( str( ::numberInvoice ), "test", 0.1 )

   ( D():FacturasClientes( ::nView ) )->( dbappend() )
   ( D():FacturasClientes( ::nView ) )->cSerie  := ::serieInvoice
   ( D():FacturasClientes( ::nView ) )->nNumFac := ::numberInvoice
   ( D():FacturasClientes( ::nView ) )->cSufFac := ::delegationInvoice

   ( D():FacturasClientes( ::nView ) )->cCodCli := hget( hUVELine, "CodigoCliente" )
   ( D():FacturasClientes( ::nView ) )->cNomCli := hget( hUVELine, "Nombre" )
   //*( D():FacturasClientes( ::nView ) )->c := hget( hUVELine, "RazonSocial" )
   ( D():FacturasClientes( ::nView ) )->cDniCli := hget( hUVELine, "CIF" )
   ( D():FacturasClientes( ::nView ) )->cDirCli := hget( hUVELine, "Direccion" )
   //*( D():FacturasClientes( ::nView ) )->c := hget( hUVELine, "TipoCliente" )
   //*( D():FacturasClientes( ::nView ) )->c := hget( hUVELine, "DescripciónTipoCliente" )
   ( D():FacturasClientes( ::nView ) )->( dbrunlock() )
   

Return ( self )

//---------------------------------------------------------------------------//

METHOD insertInvoiceLine( hUVELine )

   ( D():FacturasClientesLineas( ::nView ) )->( dbappend() )
   ( D():FacturasClientesLineas( ::nView ) )->cSerie     := ::serieInvoice
   ( D():FacturasClienteslineas( ::nView ) )->nNumFac    := ::numberInvoice
   ( D():FacturasClienteslineas( ::nView ) )->cSufFac    := ::delegationInvoice
   ( D():FacturasClienteslineas( ::nView ) )->cRef       := hget( hUVELine, "EAN13" )
   ( D():FacturasClienteslineas( ::nView ) )->nCosDiv    := hget( hUVELine, "PrecioBase" )
   ( D():FacturasClienteslineas( ::nView ) )->nPreUnit   := hget( hUVELine, "PrecioBrutoTotal" )
   // ( D():FacturasClienteslineas( ::nView ) )->    := 
   // ( D():FacturasClienteslineas( ::nView ) )->    := 
   ( D():FacturasClientes( ::nView ) )->( dbrunlock() )
   
Return ( self )

//---------------------------------------------------------------------------//

#include "UVE.prg"
