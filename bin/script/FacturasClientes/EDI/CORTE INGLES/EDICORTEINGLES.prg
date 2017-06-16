#include "Factu.ch" 
#include "FiveWin.ch"

//AllTrim( getCustomExtraField( "025", "Clientes", ( D():FacturasClientes( ::nView ) )->cCodCli ) ) PO el de mendez Campo extra creado
//AllTrim( getCustomExtraField( "026", "Clientes", ( D():FacturasClientes( ::nView ) )->cCodCli ) ) PO quien paga Campo extra creado

#define __localDirectory__       "c:\eDiversa\send\Planos\"
//#define __localDirectory__       "c:\ficheros\"
#define __separator__            "|"

//---------------------------------------------------------------------------//

Function EDI_CorteIngles( lNoExportados, oTree, nView )

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

   DATA cCodigoCliente

   DATA sTotalFactura

   DATA nLinesCount

   METHOD New( lNoExportados, oTree, nView )
   METHOD Run()

   METHOD isFacturaProcesada()
   METHOD infoFacturaEnProceso()       INLINE ( ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " en proceso.", 1 ) ) )
   METHOD infoFacturaGenerada()        INLINE   ( ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " generada en el fichero " + ::cFileEDI, 1 ) ) )

   METHOD createFile()
   METHOD closeFile()                  INLINE   ( ::oFileEDI:Close() )
   METHOD isFile()                     INLINE   ( file( ::cFileEDI ) )

   METHOD getFecha( dFecha )           INLINE   ( dtos( dFecha ) )

   METHOD setFacturaClienteGeneradaEDI()

   METHOD writeCabecera()              INLINE   ( ::oFileEDI:add( "UNA:+.? '" ) )
   METHOD writeDatosFijos()            INLINE   ( ::oFileEDI:add( "UHN+EW201733471+INVOIC:D:93A:UN:EAN007'" ) )
   METHOD writeInicioMensaje()
   METHOD writeFechas()

   METHOD writeNumeroAlbaran()
   METHOD writeNumeroPedido()

   METHOD writeSucursalDestino()
   METHOD writeDepartamento()          INLINE   ( ::oFileEDI:add( "RFF+API:041'" ) )

   METHOD writeReceptorFactura

   METHOD writeDatosComprador()

   METHOD writeNifComprador()

   METHOD writeEmisorFactura()
   METHOD writeDatosEmisor()
   METHOD writeNifEmisor()             INLINE   ( ::oFileEDI:add( "RFF+VA:B21173786'" ) )

   METHOD writePOEntrega()

   METHOD writeImporteFactura()

   METHOD writeLineas()

   METHOD isLineaValida()              INLINE   ( lValLine( D():FacturasClientesLineas( ::nView ) ) .and. !( D():FacturasClientesLineas( ::nView ) )->lTotLin .and. nTotNFacCli() != 0 )

   METHOD writeEan13()

   METHOD writeDescripcion()

   METHOD writeUnidades()

   METHOD writeImporteLinea()

   METHOD writeImporteUnitario()

   METHOD writeReferenciaCorteIngles()

   METHOD writeSeparador()             INLINE   ( ::oFileEDI:add( "UND+S'" ) )

   METHOD writeNumeroLineas()          INLINE   ( ::oFileEDI:add( "CNT+2:" + AllTrim( Str( ::nLinesCount ) ) + "'" ) )

   METHOD writeImporteBruto()
   METHOD writeImporteNeto()
   METHOD writeBaseImponible()
   METHOD writeImporteTotal()

   METHOD writePrimerIva()
   METHOD writeImportePrimerIva()
   METHOD writeSegundoIva()            INLINE   ( self )
   METHOD writeImporteSegundoIva()     INLINE   ( self )
   METHOD writeTerceroIva()            INLINE   ( self )
   METHOD writeImporteTerceroIva()     INLINE   ( self )

   METHOD writeColaMensaje()           INLINE   ( ::oFileEDI:add( "UNT+XX+EW201733471'" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( lNoExportados, oTree, nView )

   ::lNoExportados            := lNoExportados
   ::oTree                    := oTree
   ::nView                    := nView
   ::nLinesCount              := 1

Return ( self )

//---------------------------------------------------------------------------//

METHOD Run()

   if ::isFacturaProcesada()
      Return ( self )
   end if

   ::infoFacturaEnProceso()

   ::sTotalFactura         := sTotFacCli()

   ::cCodigoCliente        := ( D():FacturasClientes( ::nView ) )->cCodCli

   ::createFile()

   if ::isFile()

      ::writeCabecera()
      ::writeDatosFijos()
      ::writeInicioMensaje()
      ::writeFechas()
      ::writeNumeroAlbaran()
      ::writeNumeroPedido()

      ::writeSucursalDestino()
      ::writeDepartamento()
      ::writeReceptorFactura()
      ::writeDatosComprador()
      ::writeNifComprador()

      ::writeEmisorFactura()
      ::writeDatosEmisor()
      ::writeNifEmisor()
      ::writePOEntrega()
      ::writeImporteFactura()
      
      ::writeLineas()

      ::writeSeparador()
      ::writeNumeroLineas()

      ::writeImporteBruto()
      ::writeImporteNeto()
      ::writeBaseImponible()
      ::writeImporteTotal()

      ::writePrimerIva()
      ::writeImportePrimerIva()
      ::writeSegundoIva()
      ::writeImporteSegundoIva()
      ::writeTerceroIva()
      ::writeImporteTerceroIva()

      ::writeColaMensaje()

      ::closeFile()

      ::setFacturaClienteGeneradaEDI()

      ::infoFacturaGenerada()

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD isFacturaProcesada()

   if ( D():FacturasClientes( ::nView ) )->lExpEdi .and. ::lNoExportados
      ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " anteriormente generada.", 1 ) )
      Return ( .t. )
   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD createFile()

   ::cFileEDI     := __localDirectory__ + "F" + D():FacturasClientesIdShort( ::nView ) + ".pla" 

   if file( ::cFileEDI )
      fErase( ::cFileEDI )
   end if

   ::oFileEDI     := TTxtFile():New( ::cFileEDI )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setFacturaClienteGeneradaEDI()

   if D():lockFacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->lExpEdi    := .t.
      ( D():FacturasClientes( ::nView ) )->dFecEdi    := getSysDate()
      ( D():FacturasClientes( ::nView ) )->cHorEdi    := time()
      D():unlockFacturasClientes( ::nView )
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeInicioMensaje()

   local cLine    := "BGM+380+"
   cLine          += D():FacturasClientesIdShort( ::nView )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeFechas()

   local cLine    := "DTM+137:"
   cLine          += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac )
   cLine          += ":102'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeNumeroAlbaran()

   local cNumAlb  := ( D():FacturasClientes( ::nView ) )->cNumAlb
   local cLine    := ""

   if !Empty( cNumAlb )

      cLine       += "RFF+DQ:"
      cLine       += StrTran( cNumAlb, " ", "" )
      cLine       += "'"

      ::oFileEDI:add( cLine )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeNumeroPedido()

   local cNumPed  := ( D():FacturasClientes( ::nView ) )->cSuFac
   local cLine    := ""

   if !Empty( cNumPed )

      cLine       += "RFF+ON:"
      cLine       += StrTran( cNumPed, " ", "" )
      cLine       += "'"

      ::oFileEDI:add( cLine )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeSucursalDestino()

   local cLine    := "NAD+BY+"
   cLine          += AllTrim( RetFld( ( D():FacturasClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cCodEdi" ) )
   cLine          += "::9'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeReceptorFactura()

   local cLine    := "NAD+IV+"
   cLine          += AllTrim( RetFld( ( D():FacturasClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cCodEdi" ) )
   cLine          += "::9'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosComprador()

   local cCodigo
   local cLine    := "NAD+BCO:"

   cLine          += AllTrim( ( D():FacturasClientes( ::nView ) )->cNomCli ) + ":"
   cLine          += ":"
   cLine          += AllTrim( ( D():FacturasClientes( ::nView ) )->cDirCli ) + ":"
   cLine          += AllTrim( ( D():FacturasClientes( ::nView ) )->cPobCli ) + ":"
   cLine          += AllTrim( ( D():FacturasClientes( ::nView ) )->cPosCli )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeNifComprador()

   local cCodigo
   local cLine    := "RFF+VA"

   cLine          += AllTrim( ( D():FacturasClientes( ::nView ) )->cDniCli )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeEmisorFactura()

   local cLine          := "NAD+SU+"
   local cExtraField    := getCustomExtraField( "025", "Clientes", ( D():FacturasClientes( ::nView ) )->cCodCli )

   if !Empty( cExtraField )
      cLine             += AllTrim( cExtraField )
      cLine             += "::9'"

      ::oFileEDI:add( cLine )

   end if

Return ( self )

//---------------------------------------------------------------------------//
   
METHOD writeDatosEmisor()

   local cLine    := "NAD+SCO:"
   cLine          += "MARISCOS MENDEZ  SL:"
   cLine          += ":"
   cLine          += "POLIGONO PESQUERO NORTE S/N:"
   cLine          += "HUELVA:"
   cLine          += "21002'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writePOEntrega()

   local cLine    := "NAD+DP+"
   cLine          += AllTrim( RetFld( ( D():FacturasClientes( ::nView ) )->cCodCli, D():Clientes( ::nView ), "cCodEdi" ) )
   cLine          += "::9'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImporteFactura()

   local cLine    := "CUX+2:"
   cLine          += AllTrim( Trans( ( D():FacturasClientes( ::nView ) )->nTotFac, cPouDiv() ) )
   cLine          += ":4'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeLineas()

   local id       := D():FacturasClientesId( ::nView )

   ::nLinesCount  := 1

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesLineasId( ::nView ) == id ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() ) 

         if ::isLineaValida()

            if ( D():Articulos( ::nView ) )->( dbSeek( ( D():FacturasClientesLineas( ::nView ) )->cRef ) )

               ::writeEan13()
               ::writeReferenciaCorteIngles()
               ::writeDescripcion()
               ::writeUnidades()
               ::writeImporteLinea()
               ::writeImporteUnitario()

               ::nLinesCount++

            end if

         end if 
      
         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD writeEan13()

   local cLine    := ""

   cLine          += "LIN+" + AllTrim( Str( ::nLinesCount ) ) + "++"
   
   if !Empty( ( D():Articulos( ::nView ) )->CodeBar )
      cLine       += AllTrim( ( D():Articulos( ::nView ) )->CodeBar )
   else
      cLine       += AllTrim( ( D():Articulos( ::nView ) )->Codigo )
   end if

   cLine          += ":EN'" 

   ::oFileEDI:add( cLine )


Return ( self )

//---------------------------------------------------------------------------//

METHOD writeReferenciaCorteIngles()

   local cLine    := "PIA+5+:"

   cLine          += AllTrim( ( D():Articulos( ::nView ) )->cRefAux )
   cLine          += ":IN'" 

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDescripcion()

   local cLine    := ""

   cLine          += "IMD+F+M+:::"
   cLine          += AllTrim( ( D():FacturasClientesLineas( ::nView ) )->cDetalle )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeUnidades()

   local cLine    := ""

   cLine          += "QTY+47:"
   cLine          += AllTrim( Trans( nTotNFacCli( D():FacturasClientesLineas( ::nView ) ), MasUnd() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImporteLinea()

local cLine    := ""

   cLine          += "MOA+66:"
   cLine          += AllTrim( Trans( nTotLFacCli( D():FacturasClientesLineas( ::nView ) ), cPouDiv() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImporteUnitario()

local cLine    := ""

   cLine          += "PRI+AAB:"
   cLine          += AllTrim( Trans( ( D():FacturasClientesLineas( ::nView ) )->nPreUnit, cPouDiv() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImporteBruto()

   local cLine    := "MOA+98:"

   cLine          += AllTrim( Trans( ::sTotalFactura:nTotalBruto, cPouDiv() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImporteNeto()

   local cLine    := "MOA+79:"

   cLine          += AllTrim( Trans( ::sTotalFactura:nTotalNeto, cPouDiv() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeBaseImponible()

   local cLine    := "MOA+125:"

   cLine          += AllTrim( Trans( ::sTotalFactura:TotalBase(), cPouDiv() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImporteTotal()

   local cLine    := "MOA+139:"

   cLine          += AllTrim( Trans( ::sTotalFactura:nTotalDocumento(), cPouDiv() ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writePrimerIva()

   local cLine    := "TAX+7+VAT+++:::"

   cLine          += AllTrim( Trans( ::sTotalFactura:aPorcentajeIva[1], "@E 99.9" ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImportePrimerIva()

   local cLine    := "MOA+176:"

   cLine          += AllTrim( Trans( ::sTotalFactura:nTotalIva, "@E 99.9" ) )
   cLine          += "'"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//