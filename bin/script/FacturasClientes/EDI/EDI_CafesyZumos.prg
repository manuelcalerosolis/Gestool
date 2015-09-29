#include "Factu.ch" 
#include "FiveWin.ch"

#define __localDirectory__       "c:\EdiversaEDI\"
#define __separator__            ";"

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*
Ejemplo Fichero de Factura
Supongamos que el establecimiento “El Pato Barcelona” de la cadena “El Pato Andaluz, S.L.”, ha realizado el siguiente pedido al proveedor “Bebidas y Refrescos, S.A.”:
- 200 botellas de agua
- 15 Kgs de naranjas
- 100 entrecots de ternera de 300 gramos cada uno
La factura correspondiente sería la siguiente (se han utilizado únicamente los segmentos y campos marcados en rojo en las especificaciones):
Nombre del fichero: Factura_20140618_100000_000.txt
Carácter de separación de campos: ‘;’
Contenidos del fichero:
DatosGenerales;F132589;FacturaComercial;2014-06-18;EUR;
Proveedor;525;B61742348;Bebidas y Refrescos,S.A.;Av. Diagonal,23;Barcelona; 08012;Barcelona;ESP
Cliente;1;1024;2;12345678Z;El Pato Andaluz, S.L.;La Toja, 53;Barcelona; 08027;Barcelona;ESP
Estab;25;1024;2;El Pato BCN;Av.Icaria,34;Barcelona;08005;Barcelona;ESP
Referencias;A534687;P459034;;2014-06-18
Detalle;50;500;Agua Castillo de Montblanc;200;Unidades;0,2;40
ImpuestosLinea;IVA;4;1,6
Detalle;60;600;Naranjas Navel;15;Kgs;;;;2;30
ImpuestosLinea;IVA;4;1,2
Detalle;70;700;Entrecot Ternera;30;Kgs;;;;10;300
ImpuestosLinea;IVA;4;12
ResumenImpuestos;IVA;4;370;14,8
Vencimientos;2014-06-30;384,8;ReciboDomiciliado
ResumenTotales;370;370;0;370;14,8;384,8
*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function EDI_CafesyZymos( lNoExportados, oTree, nView )

   local oTEdiExporarFacturas

   oTEdiExporarFacturas          := TEdiExporarFacturas():New( lNoExportados, oTree, nView )
   oTEdiExporarFacturas:Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TEdiExporarFacturas

   DATA nView

   DATA oTree

   DATA lNoExportados

   DATA cFileEDI
   DATA oFileEDI

   METHOD New( lNoExportados, oTree, nView )
   METHOD Run()

   METHOD getSerlizeFileName()
   METHOD createFile()
   METHOD closeFile()         INLINE ( ::oFileEDI:Close() )
   METHOD isFile()            INLINE ( file( ::cFileEDI ) )

   METHOD writeDatosGenerales()
   METHOD writeDatosProveedor()
   METHOD writeDatosCliente()
   METHOD writeDatosEstablecimiento()
   METHOD writeLineas()
      METHOD writeDetallesLinea()
      METHOD writeImpuestosLinea()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( lNoExportados, oTree, nView )

   ::lNoExportados            := lNoExportados
   ::oTree                    := oTree
   ::nView                    := nView

Return ( self )

//---------------------------------------------------------------------------//

METHOD Run()

   local oNode

   if ( D():FacturasClientes( ::nView ) )->lExpEdi .and. ::lNoExportados
      oNode                   := ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " anteriormente generada.", 1 )
      ::oTree:Select( oNode )
      Return ( self )
   end if
   
   oNode                   := ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " en proceso.", 1 )
   ::oTree:Select( oNode )

   ::createFile()
   if ::isFile()
      ::writeDatosGenerales()
      ::writeDatosProveedor()
      ::writeDatosCliente()
      ::writeDatosEstablecimiento()
      ::writeLineas()      
      ::closeFile()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD getSerlizeFileName()

   local nSequencial := 0
   local cRootName   := __localDirectory__ + "Factura_" + dtos( date() ) + "_" + strtran( time(), ":", "" ) + "_" 
   local cFileName   := cRootName + strzero( nSequencial, 3 ) + "." + "txt"

   while file( cFileName )
      cFileName      := cRootName + strzero( ++nSequencial, 3 ) + "." + "txt"
   end while

Return ( cFileName )

//---------------------------------------------------------------------------//

METHOD createFile()

   ::cFileEDI              := ::getSerlizeFileName()
   ::oFileEDI              := TTxtFile():New( ::cFileEDI )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosGenerales()

   local cLine    := "DatosGenerales"                                      + __separator__
   cLine          += D():FacturasClientesIdShort( ::nView )                + __separator__
   if ( D():FacturasClientes( ::nView ) )->nTotFac > 0
      cLine       += "FacturaComercial"                                    + __separator__ 
   else 
      cLine       += "FacturaAbono"                                        + __separator__
   end if 
   cLine          += transform( dtos( ( D():FacturasClientes( ::nView ) )->dFecFac ), "@R 9999-99-99")  + __separator__
   cLine          += "EUR"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosProveedor()

   local cLine    := "DatosProveedor"                                      + __separator__
   cLine          += "IdProveedor"                                         + __separator__
   cLine          += "IDProvCli"                                           + __separator__ 
   cLine          += "CIF"                                                 + __separator__
   cLine          += "Cafes y Zumos S.L."                                  + __separator__
   cLine          += "Domicilio"                                           + __separator__
   cLine          += "Población"                                           + __separator__
   cLine          += "CodigoPostal"                                        + __separator__
   cLine          += "Provincia"                                           + __separator__
   cLine          += "Pais"                                                + __separator__
   cLine          += "Registro"                                            + __separator__
   cLine          += "Email"                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosCliente()

   local cLine    := "DatosCliente"                                        + __separator__
   cLine          += "IDCliente"                                           + __separator__
   cLine          += "IDCliProv"                                           + __separator__ 
   cLine          += "IDCentroCli"                                         + __separator__
   cLine          += "CIF"                                                 + __separator__
   cLine          += "Empresa"                                             + __separator__
   cLine          += "Domicilio"                                           + __separator__
   cLine          += "Población"                                           + __separator__
   cLine          += "CodigoPostal"                                        + __separator__
   cLine          += "Provincia"                                           + __separator__
   cLine          += "Pais"                                                + __separator__
   cLine          += "Registro"                                            + __separator__
   cLine          += "Email"                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosEstablecimiento()

   local cLine    := "Estab"                                               + __separator__
   cLine          += "IDEstab"                                             + __separator__
   cLine          += "IDCliProv"                                           + __separator__ 
   cLine          += "IDCentroCli"                                         + __separator__
   cLine          += "Estab"                                               + __separator__
   cLine          += "Domicilio"                                           + __separator__
   cLine          += "Población"                                           + __separator__
   cLine          += "CodigoPostal"                                        + __separator__
   cLine          += "Provincia"                                           + __separator__
   cLine          += "Pais"                                                + __separator__
   cLine          += "Email"                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeLineas()

   local id       := D():FacturasClientesId( ::nView )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesLineasId( ::nView ) == id ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() ) 

         ::writeDetallesLinea()
         ::writeImpuestosLinea()
      
         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDetallesLinea()

   local cLine    := "Detalle"                                               + __separator__

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImpuestosLinea()

   local cLine    := "ImpuestosLinea"                                        + __separator__

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

