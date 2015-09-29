#include "FiveWin.Ch"
#include "Folder.ch"
#include "Report.ch"
#include "Print.ch"
#include "TWMail.ch"
#include "FastRepH.ch"
#include "Xbrowse.ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Static Function ExportarEDI( lNoExportados, oTree, nView )

   local oNode
   local nDescuento           := 0
   local nNumeroLinea         := 0
   local cNumeroFactura

   // Quitar

   msgAlert( lNoExportados)
   msgAlert( hb_valtoexp( oTree ) )
   msgAlert( nView )

   oNode                   := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " anteriormente generada.", 1 )
   oTree:Select( oNode )
   Return .f.

   if ( D():FacturasClientes( nView ) )->lExpEdi .and. lNoExportados
      oNode                   := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " anteriormente generada.", 1 )
      oTree:Select( oNode )
      Return .f.
   end if

   cNumeroFactura             := ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac

   if hCabeceraFactura        != -1 .and.;
      hLineaFactura           != -1 .and.;
      hVencimientoFactura     != -1 .and.;
      hDescuentoFactura       != -1 .and.;
      hImpuestosFactura       != -1

      nTotFacCli( cNumeroFactura, D():FacturasClientes( nView ), dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT )

      /*
      Cabecera de facturas-----------------------------------------------------
      */

      ExportaEDICabecera( hCabeceraFactura )

      /*
      Ahora vamos a ver si hay descuentos en la cabecera-----------------------
      */

      if !Empty( ( D():FacturasClientes( nView ) )->nDtoEsp )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoEsp, nTotDto, ++nDescuento, hDescuentoFactura )
      end if

      if !Empty( ( D():FacturasClientes( nView ) )->nDpp )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDpp, nTotDpp, ++nDescuento, hDescuentoFactura )
      end if

      if !Empty( ( D():FacturasClientes( nView ) )->nDtoAtp )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoAtp, nTotAtp, ++nDescuento, hDescuentoFactura )
      end if

      if !Empty( ( D():FacturasClientes( nView ) )->nDtoUno )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoUno, nTotUno, ++nDescuento, hDescuentoFactura )
      end if

      if !Empty( ( D():FacturasClientes( nView ) )->nDtoDos )
         ExportaEDIDescuentoCabecera( ( D():FacturasClientes( nView ) )->nDtoDos, nTotDos, ++nDescuento, hDescuentoFactura )
      end if

      /*
      Impuestos de facturas----------------------------------------------------
      */

      ExportaEDIImpuestos( hImpuestosFactura )

      /*
      Lineas de facturas-------------------------------------------------------
      */

      if ( dbfFacCliL )->( dbSeek( cNumeroFactura ) )

         while ( dbfFacCliL )->cSerie + str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac == cNumeroFactura .and. !( dbfFacCliL )->( eof() )

            if lValLine( dbfFacCliL )

               ExportaEDILinea( ++nNumeroLinea, hLineaFactura  )

               if ( dbfFacCliL )->nDto != 0
                  ExportaEDIDescuentoLinea( ( dbfFacCliL )->nDto, nDtoLFacCli( dbfFacCliL, nRouDiv, nVdvDiv ), nNumeroLinea, ++nDescuento, hDescuentoFactura  )
               end if

               if ( dbfFacCliL )->nDtoPrm != 0
                  ExportaEDIDescuentoLinea( ( dbfFacCliL )->nDtoPrm, nPrmLFacCli( dbfFacCliL, nRouDiv, nVdvDiv ), nNumeroLinea, ++nDescuento, hDescuentoFactura  )
               end if

            end if

            ( dbfFacCliL )->( dbSkip() )

         end while

      end if

      /*
      Pagos de facturas--------------------------------------------------------
      */

      nNumeroLinea         := 0

      if ( dbfFacCliP )->( dbSeek( cNumeroFactura ) )

         while ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == cNumeroFactura .and. !( dbfFacCliP )->( eof() )

            ExportaEDIRecibo( ++nNumeroLinea, hVencimientoFactura )

            ( dbfFacCliP )->( dbSkip() )

         end while

      end if

      /*
      Marcamos la factura como exportada---------------------------------------
      */

      if dbLock( D():FacturasClientes( nView ) )
         ( D():FacturasClientes( nView ) )->lExpEdi    := .t.
         ( D():FacturasClientes( nView ) )->dFecEdi    := GetSysDate()
         ( D():FacturasClientes( nView ) )->cHorEdi    := Time()
         ( dbfFacCliL )->( dbUnlock() )
      end if

      oNode                := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " ficheros generados.", 1 )

   else

      oNode                := oTree:Add( "Factura : " + ( D():FacturasClientes( nView ) )->cSerie + "/" + Alltrim( str( ( D():FacturasClientes( nView ) )->nNumFac ) ) + "/" + Alltrim( ( D():FacturasClientes( nView ) )->cSufFac ) + " ficheros no generados.", 0 )

   end if

   oTree:Select( oNode )

Return .t.

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//

Static Function CreateFileEDI()

   local cCabeceraFactura     := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCC.TXT"
   local cLineaFactura        := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCL.TXT"
   local cVencimientoFactura  := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCV.TXT"
   local cDescuentoFactura    := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCD.TXT"
   local cImpuestosFactura    := uFieldEmpresa( "cRutEdi" ) + "\" + "SINCI.TXT"

   if file( cCabeceraFactura )
      ferase( cCabeceraFactura )
   end if
   if file( cLineaFactura )
      ferase( cLineaFactura )
   end if
   if file( cVencimientoFactura )
      ferase( cVencimientoFactura )
   end if
   if file( cDescuentoFactura )
      ferase( cDescuentoFactura )
   end if
   if file( cImpuestosFactura )
      ferase( cImpuestosFactura )
   end if

   hCabeceraFactura           := fCreate( cCabeceraFactura     )
   hLineaFactura              := fCreate( cLineaFactura        )
   hVencimientoFactura        := fCreate( cVencimientoFactura  )
   hDescuentoFactura          := fCreate( cDescuentoFactura    )
   hImpuestosFactura          := fCreate( cImpuestosFactura    )

return nil

//---------------------------------------------------------------------------//

Static Function CloseFileEDI()

   fClose( hCabeceraFactura      )
   fClose( hLineaFactura         )
   fClose( hVencimientoFactura   )
   fClose( hDescuentoFactura     )
   fClose( hImpuestosFactura     )

return nil

//---------------------------------------------------------------------------//

Static Function ExportaEDICabecera( hFicheroFactura )

   local cCabecera         := ""
   local nDescuento        := 0

   // cCabecera         += Padr( "SINCC", 6 )                                                                                       // 6.  Cabecera
   cCabecera         += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cCabecera         += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac) , 17 ) // 29. Numero factura
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cCabecera         += Padr( "", 6 )                                                                                            // 61. Funcion del mensaje
   cCabecera         += Padr( Dtos( ( D():FacturasClientes( nView ) )->dFecFac ), 8 )                                                               // 69. Fecha de la factura
   cCabecera         += Padr( Dtos( ( D():FacturasClientes( nView ) )->dFecFac ) + Dtos( ( D():FacturasClientes( nView ) )->dFecFac ), 16 )                            // 85. Periodo de facturación pongo la misma fecha 2 veces
   cCabecera         += Padr( "42", 6 )                                                                                          // 91. Forma de pago 42 por defecto
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 104. Codigo de Emisor de la factura coincide ( quien factura )
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 117. Codigo de Receptor de la factura ( quien recibe )
   if !Empty( ( D():FacturasClientes( nView ) )->cCodObr )
      cCabecera      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli + ( D():FacturasClientes( nView ) )->cCodObr, dbfObrasT, "cCodEdi" ), 13 )            // 130. Codigo del receptor de la mercancia con codigo EDI en la obra
   else
      cCabecera      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 130. Codigo del receptor de la mercancia con cóodigo EDI en el cliente
   end if
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 143. Codigo receptor del pago
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 156. Codigo del emisor del pago
   cCabecera         += Padr( "", 6 )                                                                                            // 162. Razon o cargo del abono.
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cSuFac, 17 )                                                                       // 179. Numero del pedido
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cSuAlb, 17 )                                                                       // 196. Numero del albaran
   cCabecera         += Padr( "", 3 )                                                                                            // 199. Calificador documento rectificado sustituido
   cCabecera         += Padr( "", 17 )                                                                                           // 216. Numero documento rectificado sustituido
   cCabecera         += Padr( "", 17 )                                                                                           // 233. Numero de contrato o acuerdo
   cCabecera         += Padr( "", 17 )                                                                                           // 250. Numero de relacion de entregas
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cNomCli, 70 )                                                                      // 320. Razon social del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cDirCli, 70 )                                                                      // 390. Direccion del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cPobCli, 35 )                                                                      // 425. Población del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cPosCli, 9 )                                                                       // 434. Codigo postal del receptor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cDniCli, 17 )                                                                      // 451. Nif del receptor de la factura
   cCabecera         += Padr( uFieldEmpresa( "cDomicilio" ), 70 )                                                                // 521. Domicilio del emisor de la factura
   cCabecera         += Padr( uFieldEmpresa( "cPoblacion" ), 35 )                                                                // 556. Población del emisor de la factura
   cCabecera         += Padr( uFieldEmpresa( "cCodPos" ), 9 )                                                                    // 565. Codigo postal del emisor de la factura
   cCabecera         += Padr( ( D():FacturasClientes( nView ) )->cDivFac, 6 )                                                                       // 571. Codigo de la divisa
   cCabecera         += Padr( "", 8 )                                                                                            // 579. Fecha de vencimiento unico
   cCabecera         += Padl( Trans( nTotNet, "99999999999999.999" ), 18 )                                                       // 599. Importe neto factura
   cCabecera         += Padl( Trans( nTotNet, "99999999999999.999" ), 18 )                                                       // 617. Base imponible factura
   cCabecera         += Padl( Trans( nTotBrt, "99999999999999.999" ), 18 )                                                       // 635. Importe bruto total factura
   cCabecera         += Padl( Trans( nTotImp, "99999999999999.999" ), 18 )                                                       // 653. Impuestos de factura
   cCabecera         += Padl( Trans( nTotFac, "99999999999999.999" ), 18 )                                                       // 671. Total factura
   cCabecera         += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // 689. Subvenciones vinculadas a precio
   cCabecera         += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // 707. Incrementos del importe bruto
   cCabecera         += Padl( Trans( nTotDto, "99999999999999.999" ), 18 )                                                       // 725. Minoraciones del importe bruto
   cCabecera         += Padr( "", 17 )                                                                                           // 742. Identificacion adicional de la parte
   cCabecera         += Padr( "", 13 )                                                                                           // 755. Receptor del documento
   cCabecera         += Padr( "", 17 )                                                                                           // 773. Identificacion adicional proveedor
   cCabecera         += CRLF

   fWrite( hFicheroFactura, cCabecera )

Return nil

Static Function ExportaEDILinea( nNumeroLinea, hFicheroFactura )

   local cLinea      := ""

   //cLinea            += Padr( "SINCL", 6 )                                                                                     // 6.  Cabecera
   cLinea            += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cLinea            += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac) , 17 ) // 29. Numero factura
   cLinea            += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cLinea            += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cLinea            += Padl( Trans( nNumeroLinea, "999999" ), 6 )                                                               // 61. Numero de linea
   cLinea            += Padr( RetFld( ( dbfFacCliL )->cRef, D():Articulos( nView ), "Codebar" ), 15 ) //Padr( ( dbfFacCliL )->cRef, 15 )    // 76. Código articulo / Codigo de barras
   cLinea            += Padr( if( !Empty( ( dbfFacCliL )->cDetalle ), ( dbfFacCliL )->cDetalle, ( dbfFacCliL )->mLngDes ), 35 )  // 111. Descripción articulo
   cLinea            += Padr( "M", 1 )                                                                                           // 112. Tipo de articulo
   cLinea            += Padr( "", 15 )                                                                                           // 127. Codigo interno articulo proveedor
   cLinea            += Padr( "", 15 )                                                                                           // 142. Codigo interno articulo cliente
   cLinea            += Padr( "", 15 )                                                                                           // 157. Codigo variable promocional
   cLinea            += Padr( "", 15 )                                                                                           // 172. Codigo unidad expedición
   cLinea            += Padr( ( dbfFacCliL )->cLote, 15 )                                                                        // 187. Numero de lote
   cLinea            += Padl( Trans( nTotNFacCli( dbfFacCliL ), "999999999999.999" ), 16 )                                       // 203. Unidades facturado
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // 219. Unidades bonificadas
   cLinea            += Padr( "", 6 )                                                                                            // 225. Unidad de medida
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // 241. Unidad entregada
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // 257. Unidades de consumo en expedicion
   cLinea            += Padl( Trans( nTotLFacCli( dbfFacCliL, nDouDiv, nRouDiv ), "99999999999999.999" ), 18 )                   // 275. Importe total neto
   cLinea            += Padl( Trans( nTotUFacCli( dbfFacCliL, nDouDiv ), "99999999999.999" ), 16 )                               // 291. Precio bruto unitario
   cLinea            += Padl( Trans( nTotPFacCli( dbfFacCliL, nDouDiv ), "9999999999.9999" ), 16 )                               // 291. Precio neto unitario
   cLinea            += Padr( "", 6 )                                                                                            // 225. Unidad de medida del precio
   cLinea            += Padr( "VAT", 6 )                                                                                         // 225. Calificador de impuesto VAT es impuestos
   cLinea            += Padl( Trans( ( dbfFacCliL )->nIva, "999.99" ), 6 )                                                       // 291. % Impuesto
   cLinea            += Padl( Trans( 0, "9999999999999.999" ), 18 )                                                              // 291. Importe impuesto se aconseja no cumplimentar
   cLinea            += Padl( Trans( if( ( D():FacturasClientes( nView ) )->lRecargo, ( dbfFacCliL )->nReq, 0 ), "999.99" ), 6 )                    // 291. % Recargo de eqivalencia
   cLinea            += Padl( Trans( 0, "9999999999999.999" ), 18 )                                                              // 291. Importe recargo equivalencia se aconseja no cumplimentar
   cLinea            += Padr( "", 6 )                                                                                            // 225. Calificador de otro impuesto VAT es impuestos
   cLinea            += Padl( Trans( 0, "999.99" ), 6 )                                                                          // 291. % otro Impuesto
   cLinea            += Padl( Trans( 0, "9999999999999.999" ), 18 )                                                              // 291. Importe otro impuesto se aconseja no cumplimentar
   cLinea            += Padr( ( D():FacturasClientes( nView ) )->cNumPed, 17 )                                                                      // 179. Numero del pedido
   cLinea            += Padr( ( dbfFacCliL )->cCodAlb, 17 )                                                                      // 196. Numero del albaran
   cLinea            += Padl( Trans( 0, "99999999" ), 8 )                                                                        // 291. Numero de embalajes
   cLinea            += Padr( "", 7 )                                                                                            // 225. Tipo de embalaje
   cLinea            += Padl( Trans( nTotLFacCli( dbfFacCliL, nDouDiv, nRouDiv, nVdvDiv, .f. ), "99999999999999.999" ), 18 )     // 275. Importe total bruto
   cLinea            += CRLF

   fWrite( hFicheroFactura, cLinea )

Return nil

Static Function ExportaEDIRecibo( nNumeroRecibo, hFicheroFactura )

   local cRecibo     := ""

   //cRecibo           += Padr( "SINCV", 6 )                                                                                       // 6.  Cabecera
   cRecibo           += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cRecibo           += Padr( Alltrim( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac ) , 17 )// 29. Numero factura
   cRecibo           += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cRecibo           += Padr( Retfld( ( dbfFacCliP )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cRecibo           += Padl( Trans( nNumeroRecibo, "999999" ), 6 )                                                              // 61. Numero de Recibo
   cRecibo           += Padr( Dtos( ( dbfFacCliP )->dFecVto ), 8 )                                                               // 76. Código articulo
   cRecibo           += Padl( Trans( nTotRecCli( dbfFacCliP, dbfDiv ), "999999999999.999" ), 16 )                                // 203. Unidades facturado
   cRecibo           += CRLF

   fWrite( hFicheroFactura, cRecibo )

Return nil

Static Function ExportaEDIDescuentoCabecera( nPorcentajeDescuento, nTotalDescuento, nDescuento, hFicheroFactura )

   local cCabecera   := ""

   //cCabecera         += Padr( "SINCD", 6 )                                                                                       // 6.  Cabecera
   cCabecera         += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cCabecera         += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
   cCabecera         += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cCabecera         += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cCabecera         += Padl( Trans( 0, "999999" ), 6 )                                                                          // Numero de linea 0 para cabeceras
   cCabecera         += Padl( Trans( nDescuento, "99" ), 2 )                                                                     // Numero de descuento
   cCabecera         += "A"                                                                                                      // Indicador de descuento
   cCabecera         += Padl( Trans( nDescuento, "999" ), 3 )                                                                    // Numero de descuento
   cCabecera         += Padl( Trans( nPorcentajeDescuento, "9999.9999" ), 9 )                                                    // Porcentaje de descuento atipico
   cCabecera         += Padl( Trans( nTotalDescuento, "99999999999999.999" ), 18 )                                               // Importe descuento atipico
   cCabecera         += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // Importe total sujeto a aplicacion
   cCabecera         += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Unidades q se descuentan por lineas
   cCabecera         += Padr( "TD", 6 )                                                                                          // Tipo de descuento TD descuento comercial
   cCabecera         += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Descuentos monetarios por unidad
   cCabecera         += Padr( "", 6 )                                                                                            // Unidade de medida
   cCabecera         += CRLF

  fWrite( hFicheroFactura, cCabecera )

Return nil

Static Function ExportaEDIDescuentoLinea( nPorcentajeDescuento, nTotalDescuento, nLinea, nDescuento, hFicheroFactura )

   local cLinea      := ""

   //cLinea            += Padr( "SINCD", 6 )                                                                                       // 6.  Cabecera
   cLinea            += Padr( "380", 6 )                                                                                         // 12. Factura comercial
   cLinea            += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
   cLinea            += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
   cLinea            += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
   cLinea            += Padl( Trans( nLinea, "999999" ), 6 )                                                                          // Numero de linea 0 para cabeceras
   cLinea            += Padl( Trans( nDescuento, "99" ), 2 )                                                                     // Numero de descuento
   cLinea            += "A"                                                                                                      // Indicador de descuento
   cLinea            += Padl( Trans( nDescuento, "999" ), 3 )                                                                    // Numero de descuento
   cLinea            += Padl( Trans( nPorcentajeDescuento, "9999.9999" ), 9 )                                                    // Porcentaje de descuento atipico
   cLinea            += Padl( Trans( nTotalDescuento, "99999999999999.999" ), 18 )                                               // Importe descuento atipico
   cLinea            += Padl( Trans( 0, "99999999999999.999" ), 18 )                                                             // Importe total sujeto a aplicacion
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Unidades q se descuentan por lineas
   cLinea            += Padr( "TD", 6 )                                                                                          // Tipo de descuento TD descuento comercial
   cLinea            += Padl( Trans( 0, "999999999999.999" ), 16 )                                                               // Descuentos monetarios por unidad
   cLinea            += Padr( "", 6 )                                                                                            // Unidade de medida
   cLinea            += CRLF

  fWrite( hFicheroFactura, cLinea )

Return nil

Static Function ExportaEDIImpuestos( hFicheroFactura )

   local nImpuesto   := 0
   local cImpuesto   := ""

   if !Empty( aIvaUno[ 3 ] )
      //cImpuesto      += Padr( "SINCI", 6 )                                                                                       // 6.  Cabecera
      cImpuesto      += Padr( "380", 6 )                                                                                         // 12. Factura comercial
      cImpuesto      += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
      cImpuesto      += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
      cImpuesto      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
      cImpuesto      += Padl( Trans( ++nImpuesto, "99" ), 2 )                                                                    // 61. Numero de impuesto
      cImpuesto      += Padr( "VAT", 6 )                                                                                         // 76. Tipo de impuestos
      cImpuesto      += Padl( Trans( aIvaUno[ 3 ], "999.99" ), 6 )                                                               // 203. % impuestos
      cImpuesto      += Padl( Trans( aIvaUno[ 8 ], "99999999999999.999" ), 18 )                                                  // 203. Importe de tipo de impuesto
      cImpuesto      += Padl( Trans( aIvaUno[ 2 ], "99999999999999.999" ), 18 )                                                  // 203. Base imponible
      cImpuesto      += CRLF
   end if

   if !Empty( aIvaDos[ 3 ] )
      //cImpuesto      += Padr( "SINCI", 6 )                                                                                       // 6.  Cabecera
      cImpuesto      += Padr( "380", 6 )                                                                                         // 12. Factura comercial
      cImpuesto      += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
      cImpuesto      += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
      cImpuesto      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
      cImpuesto      += Padl( Trans( ++nImpuesto, "99" ), 2 )                                                                    // 61. Numero de impuesto
      cImpuesto      += Padr( "VAT", 6 )                                                                                         // 76. Tipo de impuestos
      cImpuesto      += Padl( Trans( aIvaDos[ 3 ], "999.99" ), 6 )                                                               // 203. % impuestos
      cImpuesto      += Padl( Trans( aIvaDos[ 8 ], "99999999999999.999" ), 18 )                                                  // 203. Base imponible
      cImpuesto      += Padl( Trans( aIvaDos[ 2 ], "99999999999999.999" ), 18 )                                                  // 203. Importe de tipo de impuesto
      cImpuesto      += CRLF
   end if

   if !Empty( aIvaTre[ 3 ] )
      //cImpuesto      += Padr( "SINCI", 6 )                                                                                       // 6.  Cabecera
      cImpuesto      += Padr( "380", 6 )                                                                                         // 12. Factura comercial
      cImpuesto      += Padr( Alltrim( ( D():FacturasClientes( nView ) )->cSerie + str( ( D():FacturasClientes( nView ) )->nNumFac ) + ( D():FacturasClientes( nView ) )->cSufFac ) , 17 )// 29. Numero factura
      cImpuesto      += Padr( uFieldEmpresa( "cCodEdi" ), 13 )                                                                   // 42. Codigo de Vendedor a quien se pide
      cImpuesto      += Padr( Retfld( ( D():FacturasClientes( nView ) )->cCodCli, D():Clientes( nView ), "cCodEdi" ), 13 )                                      // 55. Codigo de Comprador (quien pide)
      cImpuesto      += Padl( Trans( ++nImpuesto, "99" ), 2 )                                                                    // 61. Numero de impuesto
      cImpuesto      += Padr( "VAT", 6 )                                                                                         // 76. Tipo de impuestos
      cImpuesto      += Padl( Trans( aIvaTre[ 3 ], "999.99" ), 6 )                                                               // 203. % impuestos
      cImpuesto      += Padl( Trans( aIvaTre[ 8 ], "99999999999999.999" ), 18 )                                                  // 203. Base imponible
      cImpuesto      += Padl( Trans( aIvaTre[ 2 ], "99999999999999.999" ), 18 )                                                  // 203. Importe de tipo de impuesto
      cImpuesto      += CRLF
   end if

   fWrite( hFicheroFactura, cImpuesto )

Return nil

//---------------------------------------------------------------------------//

