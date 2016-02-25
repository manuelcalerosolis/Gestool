#include "Factu.ch" 
#include "FiveWin.ch"

//#define __localDirectory__       "\\Srvcafesyzumos\nueva estructura servidor\FicherosVoxel\"
#define __localDirectory__       "c:\ficheros\voxel\"
#define __separator__            "|"

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*
INVOIC_D_93A_UN_EAN007
INV|1600711|380|9
DTM|20151209
PAI|60
RFF|DQ|1600710
RFF|ON|530957173
NADSU|8437003477959|MARISCOS MENDEZ  SL|R.M.Huelva,Tomo269 Gral.Lb.96 Secc.1º,Fol.96, Hoja H-1925 Inscr.1º|POLIGONO PESQUERO NORTE S/N|HUELVA|21002     |B21173786
NADSCO|8437003477959|MARISCOS MENDEZ  SL|R.M.Huelva,Tomo269 Gral.Lb.96 Secc.1º,Fol.96, Hoja H-1925 Inscr.1º|POLIGONO PESQUERO NORTE S/N|HUELVA|21002     |B21173786
NADBY|8480015009007|CENTROS COMERCIALES CARREFOUR, S.A.SEVIL|P. I. DE LA ISLA C/TORRE DE LOS HEBREROS|DOS HERMANAS|41700     |A28425270|
NADBCO|8480015009007|CENTROS COMERCIALES CARREFOUR, S.A.SEVIL|P. I. DE LA ISLA C/TORRE DE LOS HEBREROS|DOS HERMANAS|41700     |A28425270
NADII|8437003477959|MARISCOS MENDEZ  SL|POLIGONO PESQUERO NORTE S/N|HUELVA|21002     |B21173786
NADIV| 8480015111113            |CENTROS COMERCIALES CARREFOUR, S.A.SEVIL|EDIFICIO CARREFOUR C/ CAMPEZO Nº16|POL. INDUSTRIAL LAS MERCEDES|28022     |A28425270
NADPR|8480015111113
NADDP|8480015102036
CUX|EUR|4
LIN|2928771000006 |EN
IMDLIN|LANGT. TG. H COC 2Kg|M
QTYLIN|47|         10.000
MOALIN|        112.700
PRILIN|AAB|         11.270
PRILIN|AAA|         11.270
TAXLIN|VAT|         10.000
CNTRES|2
MOARES|        112.700|        112.700|        112.700|         123.97|          11.27|          0.000
TAXRES|VAT|         10.000|         11.270|        112.700

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

   DATA cCodigoCliente

   DATA sTotalFactura

   METHOD New( lNoExportados, oTree, nView )
   METHOD Run()

   METHOD isFacturaProcesada()
   METHOD infoFacturaEnProceso() INLINE   ( ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " en proceso.", 1 ) ) )
   METHOD infoFacturaGenerada()  INLINE   ( ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " generada en el fichero " + ::cFileEDI, 1 ) ) )

   METHOD getSerlizeFileName()
   METHOD createFile()
   METHOD closeFile()            INLINE   ( ::oFileEDI:Close() )
   METHOD isFile()               INLINE   ( file( ::cFileEDI ) )

   METHOD writeDatosFijos()      INLINE   ( ::oFileEDI:add( "INVOIC_D_93A_UN_EAN007" ) )
   METHOD writeDatosGenerales()
   METHOD writeFechas()
   METHOD writeFormadePago()

   /*METHOD writeDatosProveedor()
   METHOD writeDatosCliente()
   
   METHOD getDatosEstablecimiento()   
      METHOD writeDatosEstablecimiento()
      METHOD writeClienteEstablecimiento()

   METHOD writeReferencias()

   METHOD writeLineas()
      METHOD writeDetallesLinea()
      METHOD writeDescuentoLinea()
      METHOD writeImpuestosLinea()

   METHOD writeResumenPrimerImpuesto()
   METHOD writeResumenSegundoImpuesto()
   METHOD writeResumenTercerImpuesto()

   METHOD writeVencimientos()
      METHOD writeDetallesVencimientos()
   
   METHOD writeResumenTotales()*/

   METHOD getNumero( nNumero )   INLINE   ( alltrim( transform( nNumero, "@E 99999999999999.99" ) ) )
   METHOD getFecha( dFecha )     INLINE   ( dtos( dFecha ) )

   METHOD isLineaValida()        INLINE   ( lValLine( D():FacturasClientesLineas( ::nView ) ) .and. !( D():FacturasClientesLineas( ::nView ) )->lTotLin .and. nTotNFacCli() != 0 )
   METHOD isDescuentoValido()    INLINE   ( ( D():FacturasClientesLineas( ::nView ) )->nDto != 0 )

   METHOD setFacturaClienteGeneradaEDI()

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

   if ::isFacturaProcesada()
      Return ( self )
   end if
   
   ::infoFacturaEnProceso()

   ::sTotalFactura         := sTotFacCli()

   ::cCodigoCliente        := ( D():FacturasClientes( ::nView ) )->cCodCli

   ::createFile()

   if ::isFile()

      ::writeDatosFijos()
      ::writeDatosGenerales()
      ::writeFechas()
      ::writeFormadePago()
      
      /*::writeDatosProveedor()
      ::writeDatosCliente()

      ::getDatosEstablecimiento()

      ::writeReferencias()
      
      ::writeLineas()  

      ::writeResumenPrimerImpuesto()
      ::writeResumenSegundoImpuesto()
      ::writeResumenTercerImpuesto()

      ::writeVencimientos()
      ::writeResumenTotales()*/

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

   ::cFileEDI     := ::getSerlizeFileName()
   ::oFileEDI     := TTxtFile():New( ::cFileEDI )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosGenerales()

   local cLine    := "INV" + __separator__
   cLine          += D():FacturasClientesIdShort( ::nView ) + __separator__
   cLine          += "380" + __separator__
   cLine          += "9"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeFechas()

   local cLine    := "DTM" + __separator__
   cLine          += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac )

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeFormadePago()

   local cLine    := "PAI" + __separator__
   cLine          += RetFld( ( D():FacturasClientes( ::nView ) )->cCodPago, 

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//



//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*METHOD writeDatosProveedor()

   local cLine    := "DatosProveedor" + __separator__
   cLine          += "9990000076857" + __separator__
   cLine          += "9990000076857" + __separator__ 
   cLine          += "B91012468" + __separator__
   cLine          += "Cafés y Zumos, S.L." + __separator__
   cLine          += "Pol. Ind. El Pino C7 Pino Silvestre, 21-22" + __separator__
   cLine          += "Sevilla" + __separator__
   cLine          += "41017" + __separator__
   cLine          += "Sevilla" + __separator__
   cLine          += "España" 
   // cLine          += "Registro" + __separator__
   // cLine          += "Email"                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosCliente()
   
    local cLine    := "DatosCliente" + __separator__                                                   

	
	//Cliente--------------------------------------------------------------

   	cLine          += "" + __separator__                                                                           // Código del cliente (interno del cliente)
   	cLine          += alltrim( ::cCodigoCliente ) + __separator__                                                  // Código del cliente (interno del proveedor)
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodEdi" ) ) + __separator__    // Código de un centro del cliente (interno del proveedor). Algunos proveedores no lo utilizan (solo usan el campo DCliProv)
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Nif" ) ) + __separator__        // CIF del cliente
   		
   	if !empty( ( D():FacturasClientes( ::nView ) )->cCodObr ) .and. ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::cCodigoCliente + ( D():FacturasClientes( ::nView ) )->cCodObr ) )
   		cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cNomObr ) + __separator__     // Razón social del cliente
   	else
   		cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Titulo" ) ) + __separator__     // Razón social del cliente
   	end if
   		
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Domicilio" ) ) + __separator__  // Domicilio del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Poblacion" ) ) + __separator__  // Población del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "CodPostal" ) ) + __separator__  // Codigo postal del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Provincia" ) ) + __separator__  // Provincia del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodPai" ) )                    // País del cliente (España: ESP)
   	cLine          += ""                                                                                           // Nº de registro mercantil del cliente
   	cLine          += ""                                                                                           // Dirección de email del cliente

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDatosEstablecimiento()

   if !empty( ( D():FacturasClientes( ::nView ) )->cCodObr ) .and. ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::cCodigoCliente + ( D():FacturasClientes( ::nView ) )->cCodObr ) )
      ::writeDatosEstablecimiento()
   else
      ::writeClienteEstablecimiento()
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosEstablecimiento()

   local cLine    := "Estab" + __separator__
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cCodEdi ) + __separator__    // Código del establecimiento del cliente donde se entrega de la mercancía (interno del cliente)
   cLine          += alltrim( ::cCodigoCliente ) + __separator__                                   // Código del cliente (interno del proveedor)
   cLine          += "" + __separator__                                                            // Código secundario del establecimiento del cliente según el proveedor (interno del proveedor). Algunos proveedores solo utilizan el campo IDCliProv
   //cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cNomObr ) + __separator__    // Nombre del establecimiento
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Titulo" ) ) + __separator__    // Nombre del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cDirObr ) + __separator__    // Dirección del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cPobObr ) + __separator__    // Población del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cPosObr ) + __separator__    // Código postal del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cPrvObr ) + __separator__    // Provincia del establecimiento
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodPai" ) )
   cLine          += ""                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeClienteEstablecimiento()

   local cLine    := "Estab" + __separator__
   cLine          += "" + __separator__                                    // Código del establecimiento del cliente donde se entrega de la mercancía (interno del cliente)
   cLine          += alltrim( ::cCodigoCliente ) + __separator__           // Código del cliente (interno del proveedor)
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodEdi" ) ) + __separator__  // Código secundario del establecimiento del cliente según el proveedor (interno del proveedor). Algunos proveedores solo utilizan el campo IDCliProv
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Titulo" ) ) + __separator__ 
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Domicilio" ) ) + __separator__
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Poblacion" ) ) + __separator__  // Población del cliente
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "CodPostal" ) ) + __separator__  // Codigo postal del cliente
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Provincia" ) ) + __separator__  // Provincia del cliente
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodPai" ) )                    // País del cliente (España: ESP)
   cLine          += ""                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeReferencias()

   local cLine    := "Referencias" + __separator__

   if Empty( ( D():FacturasClientes( ::nView ) )->cNumAlb )
      cLine       += alltrim( D():FacturasClientesIdShort( ::nView ) ) + __separator__   //Número del albarán de procedencia
      cLine       += "" + __separator__                                                  // Número del pedido no obligatorio
      cLine       += alltrim( D():FacturasClientesIdShort( ::nView ) ) + __separator__   // Número de la factura
      cLine       += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac ) + __separator__   // Fecha de la factura
      cLine       += "" + __separator__                                                  // Fecha del pedido no obligatorio
      cLine       += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac )          // Fecha de la factura
   else
      cLine       += alltrim( StrTran( ( D():FacturasClientes( ::nView ) )->cNumAlb, " ", "" ) ) + __separator__     //Número del albarán de procedencia
      cLine       += "" + __separator__                                                  // Número del pedido no obligatorio
      cLine       += alltrim( D():FacturasClientesIdShort( ::nView ) ) + __separator__   // Número de la factura
      cLine       += ::getFecha( retfld( ( D():FacturasClientes( ::nView ) )->cNumAlb, D():AlbaranesClientes( ::nView ), "dFecAlb" ) ) + __separator__   // Fecha del albarán
      cLine       += "" + __separator__                                                  // Fecha del pedido no obligatorio
      cLine       += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac )          // Fecha de la factura
   end if
   cLine          += ""  

   ::oFileEDI:add( cLine )      

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeLineas()

   local id       := D():FacturasClientesId( ::nView )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesLineasId( ::nView ) == id ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() ) 

         if ::isLineaValida()

            ::writeDetallesLinea()

            if ::isDescuentoValido()
               ::writeDescuentoLinea()
            end if

            ::writeImpuestosLinea()

         end if 
      
         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDetallesLinea()

   local cLine    := "Detalle" + __separator__
   cLine          += alltrim( ( D():FacturasClientesLineas( ::nView ) )->cRef ) + __separator__       // Código de artículo interno del proveedor
   cLine          += "" + __separator__                                                               // Código de artículo interno del cliente
   cLine          += alltrim( ( D():FacturasClientesLineas( ::nView ) )->cDetalle ) + __separator__   // Descripción (nombre) del artículo
   cLine          += ::getNumero( nTotNFacCli() ) + __separator__                                     // Cantidad del artículo
   cLine          += "Unidades" + __separator__                                                       // Unidad de medida de la cantidad
   cLine          += "" + __separator__                                                               // Número de unidades de expedición (bultos, cajas, etc.)
   cLine          += "" + __separator__                                                               // Número de unidades de consumo por unidad de expedición
   cLine          += "" + __separator__                                                               // Peso en gramos de una unidad. Solo tiene sentido cuando UM
   cLine          += ::getNumero( nTotUFacCli() ) + __separator__                                     // Precio bruto unitario (sin descuentos, impuestos, etc.)
   cLine          += ::getNumero( nTotLFacCli() )                                                     // Importe bruto total de esta línea (Cdad x Punit)

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDescuentoLinea()

   local cLine    := "DescuentosLinea" + __separator__                                                 
   cLine          += "Descuento" + __separator__                                                      // Identifica si es un descuento o un cargo
   cLine          += "Comercial" + __separator__                                                      // Indica el tipo de descuento que es, atendiendo a una tabla dada por ellos
   cLine          += ::getNumero( ( D():FacturasClientesLineas( ::nView ) )->nDto ) + __separator__   // Indica el % de descuento
   cLine          += ::getNumero( nDtoLFacCli() )                                                     // Indica el importe del descuento

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImpuestosLinea()

   local nImporte
   local cLine    := "ImpuestosLinea" + __separator__                                                 

   cLine          += "IVA" + __separator__                                                            // Identifica el tipo de impuesto. En la tabla códigos de impuesto se describen los valores posibles de este campo
   cLine          += ::getNumero( ( D():FacturasClientesLineas( ::nView ) )->nIva ) + __separator__   // Indica el % o el importe unitario del impuesto a aplicar
   nImporte       := nIvaLFacCli()                                                                    // Importe del impuesto
   cLine          += ::getNumero( nImporte )

   ::acumulaIva( ( D():FacturasClientesLineas( ::nView ) )->nIva, nImporte )

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenPrimerImpuesto()

   local cLine    := ""

   if empty( ::sTotalFactura:nPorcentajePrimerIva() )
      Return ( self )
   end if 

   cLine          += "ResumenImpuestos" + __separator__
   cLine          += "IVA" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nPorcentajePrimerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nBasePrimerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalPrimerIva() ) 

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenSegundoImpuesto()

   local cLine    := ""

   if empty( ::sTotalFactura:nPorcentajeSegundoIva() )
      Return ( self )
   end if 

   cLine          += "ResumenImpuestos" + __separator__
   cLine          += "IVA" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nPorcentajeSegundoIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nBaseSegundoIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalSegundoIva() )

   ::oFileEDI:add( cLine ) 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenTercerImpuesto()

   local cLine    := ""

   if empty( ::sTotalFactura:nPorcentajeTercerIva() )
      Return ( self )
   end if 

   cLine          += "ResumenImpuestos" + __separator__
   cLine          += "IVA" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nPorcentajeTercerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nBaseTercerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalTercerIva() ) 

   ::oFileEDI:add( cLine )

   MsgInfo( hb_valtoexp( ::hAcumulaIva ), "Resultado"  )

Return ( self )

//---------------------------------------------------------------------------//


METHOD writeVencimientos()

   local id       := D():FacturasClientesId( ::nView )

   if ( D():FacturasClientesCobros( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesCobrosIdShort( ::nView ) == id ) .and. !( D():FacturasClientesCobros( ::nView ) )->( eof() ) 

         ::writeDetallesVencimientos()
      
         ( D():FacturasClientesCobros( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDetallesVencimientos()

   local cLine    := "Vencimientos" + __separator__
   cLine          += ::getFecha( ( D():FacturasClientesCobros( ::nView ) )->dPreCob ) + __separator__
   cLine          += ::getNumero( ( D():FacturasClientesCobros( ::nView ) )->nImporte ) + __separator__
   cLine          += "Recibo" + __separator__
   cLine          += alltrim( ( D():FacturasClientesCobros( ::nView ) )->cDescrip ) 

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenTotales()

   local cLine    := "ResumenTotales" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalBruto ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalNeto ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalDescuento() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalBase() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalDocumento() )

   ::oFileEDI:add( cLine )

Return ( self )*/

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