#include "Factu.ch" 
#include "FiveWin.ch"

//---------------------------------------------------------------------------//

Function EDI_CorteIngles( lNoExportados, oTree, nView )

   MsgInfo( "EDI CORTEINGLES" )

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

   METHOD New( lNoExportados, oTree, nView )
   METHOD Run()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( lNoExportados, oTree, nView )

   ::lNoExportados            := lNoExportados
   ::oTree                    := oTree
   ::nView                    := nView

Return ( self )

//---------------------------------------------------------------------------//

METHOD Run()

   MsgInfo( "Generandolo" )

   /*local oNode

   if ::isFacturaProcesada()
      Return ( self )
   end if

   ::seleccionaCodigoNormalizado()
   
   ::infoFacturaEnProceso()

   ::sTotalFactura         := sTotFacCli()

   ::cCodigoCliente        := ( D():FacturasClientes( ::nView ) )->cCodCli

   ::createFile()

   if ::isFile()

      ::writeDatosFijos()
      ::writeDatosGenerales()
      ::writeFechas()
      ::writeFormadePago()

      ::writeReferenciaAlbaran()
      ::writeReferenciaPedido()
      ::writeDatosProveedor()

      ::writeDatosComprador()
      ::writeDatosCompradorLegal()

      ::writeEmisorFactura()
      ::writeReceptorFactura()
      ::writeReceptorMercancia()
      ::writeEmisorPago()
      
      ::writeDivisa()

      ::writeLineas()

      ::writeMarcaCalculoTotales()
      ::writeResumenTotales()
      ::writeResumenPrimerImpuesto()
      ::writeResumenSegundoImpuesto()
      ::writeResumenTercerImpuesto()
      
      ::closeFile()

      ::setFacturaClienteGeneradaEDI()

      ::infoFacturaGenerada()

   end if*/

Return ( self )

//---------------------------------------------------------------------------//