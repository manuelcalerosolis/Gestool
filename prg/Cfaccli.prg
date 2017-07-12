#include "FiveWin.Ch"
#include "Factu.ch" 

/*
Realiza asientos en Contaplus, partiendo de la factura
*/

//---------------------------------------------------------------------------//

Static Function isIVARegimenGeneralVentas( dbfFactura )

Return ( ( dbfFactura )->nRegIva <= 1 )

//---------------------------------------------------------------------------//

Static Function isIVARegimenGeneralCompras( dbfFactura )

Return ( ( dbfFactura )->nRegIva <= 1 .or. ( dbfFactura )->nRegIva == 4 )

//---------------------------------------------------------------------------//

Static Function isIVAComunidadEconomicaEuropea( dbfFactura )

Return ( ( dbfFactura )->nRegIva == 2 )

//---------------------------------------------------------------------------//

Static Function isIVAExportacionFueraUE( dbfFactura )

Return ( ( dbfFactura )->nRegIva == 4 )

//---------------------------------------------------------------------------//

FUNCTION CntFacCli( lSimula, lPago, lExcCnt, lMessage, oTree, nAsiento, aSimula, dbfFacCliT, dbfFacCliL, dbfFacCliP, dbfAntCliT, dbfCli, dbfDiv, dbfArt, dbfFPago, dbfIva, oNewImp, oBrw, cCodEmp, cCodPro )

   local n
   local nIva
   local cCtaVent
   local nPos
   local dFecha
   local cConcepto
   local cPago
   local cSubCtaIva
   local cSubCtaReq
   local cSubCtaIvm
   local cSubCtaTrn
   local nImpDet
   local nImpTrn
   local nImpPnt
   local nImpIvm
   local nImpIva
   local cRuta
   local nDouDiv
   local nRouDiv
   local nDpvDiv
   local aTotAnt
   local nNetAnt
   local nIvaAnt
   local nAcuAnt     := 0
   local nTotAnt     := 0
   local uIva
   local newIva
   local aIvm        := {}
   local aTrn        := {}
   local aAsiento    := {}
   local nCalculo    := 0
   local nBase       := 0
   local aVentas     := {}
   local lIvaInc     := ( dbfFacCliT )->lIvaInc
   local cCodDiv     := ( dbfFacCliT )->cDivFac
   local cCtaCli     := cCliCta( ( dbfFacCliT )->cCodCli, dbfCli )
   local cCtaCliVta  := cCliCtaVta( ( dbfFacCliT )->cCodCli, dbfCli )
   local cCtaAnticipo:= cCtaAnt()
   local nFactura    := ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac
   local cFactura    := ( dbfFacCliT )->cSerie + alltrim( str( ( dbfFacCliT )->nNumFac ) )
   local pFactura    := ( dbfFacCliT )->cSerie + "/" + alltrim( str( ( dbfFacCliT )->nNumFac ) ) + "/" + ( dbfFacCliT )->cSufFac
   local lRecargo    := ( dbfFacCliT )->lRecargo
   local cTerNif     := ( dbfFacCliT )->cDniCli
   local cTerNom     := ( dbfFacCliT )->cNomCli
   local lErrorFound := .f.
   local cProyecto
   local cClave
   local sTotFacCli
   local ptaDebe
   local ptaRet
   local lReturn     := .t.
   local lOpenDiario := lOpenDiario()
   local nTotDebe    := 0
   local nTotHaber   := 0
   local nDtoEsp     := 0
   local nDpp        := 0
   local nDtoUno     := 0
   local nDtoDos     := 0
   local nPctDto     := 0
   local nPctIva     := 0
   local nBaseImp    := 0

   DEFAULT lSimula   := .t.
   DEFAULT nAsiento  := 0
   DEFAULT aSimula   := {}
   DEFAULT cCodEmp   := cCodEmpCnt( ( dbfFacCliT )->cSerie )
   DEFAULT cCodPro   := ( dbfFacCliT )->cCodPro

   nDouDiv           := nDouDiv( ( dbfFacCliT )->cDivFac, dbfDiv )
   nRouDiv           := nRouDiv( ( dbfFacCliT )->cDivFac, dbfDiv )
   nDpvDiv           := nDpvDiv( ( dbfFacCliT )->cDivFac, dbfDiv )

   dFecha            := ( dbfFacCliT )->dFecFac
   nDtoEsp           := ( dbfFacCliT )->nDtoEsp
   nDpp              := ( dbfFacCliT )->nDpp
   nDtoUno           := ( dbfFacCliT )->nDtoUno
   nDtoDos           := ( dbfFacCliT )->nDtoDos
   nPctDto           := ( dbfFacCliT )->nPctDto

   sTotFacCli        := sTotFacCli( ( dbfFacCliT )->cSerie + str( ( dbfFacCliT )->nNumFac ) + ( dbfFacCliT )->cSufFac, dbfFacCliT, dbfFacCliL, dbfIva, dbfDiv, dbfFacCliP, dbfAntCliT, nil, nil, .f., lExcCnt  )
   ptaDebe           := sTotFacCli:nTotalDocumento
   ptaRet            := sTotFacCli:nTotalRetencion
   newIva            := sTotFacCli:aTotalIva

   cProyecto         := Left( cCodPro, 3 )
   cClave            := Right( cCodPro, 6 )

   /*
   Seleccionamos las empresa dependiendo de la serie de factura----------------
   */

   cRuta             := cRutCnt()

   if !chkEmpresaAsociada( cCodEmp )
      oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " no se definierón empresas asociadas.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add(  "Factura cliente : " + rtrim( pFactura ) + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkFecha( cRuta, cCodEmp, ( dbfFacCliT )->dFecFac, .f., oTree, "Factura cliente : " + Rtrim( pFactura ) )
      lErrorFound    := .t.
   end if

   /*
   Preparamos los apuntes de cliente-------------------------------------------
   */

   if Empty( cCtaCli )
      cCtaCli        := cCtaSin()
   end if

   if Empty( cCtaCliVta )
      cCtaCliVta     := cCtaCli()
   end if

   /*
   Estudio de los Articulos de una factura-------------------------------------
   */

   if ( dbfFacCliL )->( dbSeek( nFactura ) )

      while ( ( dbfFacCliL )->cSerie + str( ( dbfFacCliL )->nNumFac ) + ( dbfFacCliL )->cSufFac == nFactura .and. !( dbfFacCliL )->( eof() ) )

         if !( dbfFacCliL )->lTotLin                           .and. ;
            lValLine( dbfFacCliL )                             .and. ;
            nTotLFacCli( dbfFacCliL, nDouDiv, nRouDiv, nil, .t., .t., .t. ) != 0

            if ( lExcCnt == nil                                .or.;    // Entran todos
               ( lExcCnt .and. ( dbfFacCliL )->nCtlStk != 2 )  .or.;    // Articulos sin contadores
               ( !lExcCnt .and. ( dbfFacCliL )->nCtlStk == 2 ) )        // Articulos con contadores

               nIva           := ( dbfFacCliL )->nIva
               nImpDet        := nTotLFacCli( dbfFacCliL, nDouDiv, nRouDiv, nil, .t., .f., .f. )
               nImpTrn        := nTrnLFacCli( dbfFacCliL, nDouDiv, nRouDiv )                 // Portes

               /*
               Si en la factura nos piden q operemeos con punto verde----------
               */

               if ( dbfFacCliT )->lOperPV
                  nImpPnt     := nPntLFacCli( dbfFacCliL, nDpvDiv )
               else
                  nImpPnt     := 0
               end if 

               nImpIva        := nIvaLFacCli( dbfFacCliL, nDouDiv, nRouDiv )
               nImpIvm        := nTotIFacCli( dbfFacCliL, nDouDiv, nRouDiv )

               /*
               Cuenta de venta si es una devolucion----------------------------
               */

               cCtaVent       := RetCtaVta( ( dbfFacCliL )->cRef, ( nImpDet < 0 ), dbfArt )
               if empty( cCtaVent )
                  cCtaVent    := cCtaCliVta + RetGrpVta( ( dbfFacCliL )->cRef, cRuta, cCodEmp, dbfArt, nIva )
               end if

               /*
               Cuentas de ventas--------------------------------------------------
               */

               nPos           := aScan( aVentas, {|x| x[ 1 ] == cCtaVent .and. x[ 2 ] == nIva } )
               if nPos == 0
                  aAdd( aVentas, { cCtaVent, nIva, nImpDet, nImpPnt, nImpTrn, nImpIva, .t. } )
               else
                  aVentas[ nPos, 3 ]   += nImpDet
                  aVentas[ nPos, 4 ]   += nImpPnt
                  aVentas[ nPos, 5 ]   += nImpTrn
                  aVentas[ nPos, 6 ]   += nImpIva
               end if

               /*
               Construimos las bases de los impuestos-----------------------------
               */

               if isIVAComunidadEconomicaEuropea( dbfFacCliT )
                  cSubCtaIva  := uFieldEmpresa( "cCtaCeeRpt" )
                  cSubCtaReq  := uFieldEmpresa( "cCtaCeeSpt" )
               else
                  cSubCtaIva  := cSubCuentaIva( nIva, ( dbfFacCliT )->lRecargo, cRuta, cCodEmp, dbfIva )
                  cSubCtaReq  := cSubCuentaRecargo( nIva, ( dbfFacCliT )->lRecargo, cRuta, cCodEmp, dbfIva )
               end if

               if uFieldEmpresa( "lIvaImpEsp" )
                  nImpDet     += nImpIvm
               end if

               /*
               transportes--------------------------------------------------------
               */

               if nImpTrn != 0

                  cSubCtaTrn  := RetCtaTrn( ( dbfFacCliL )->cRef, dbfArt )

                  nPos        := aScan( aTrn, {|x| x[1] == cSubCtaTrn } )
                  if nPos == 0
                     aAdd( aTrn, { cSubCtaTrn, nImpTrn } )
                  else
                     aTrn[ nPos, 2 ] += nImpTrn
                  end if

               end if

               /*
               impuesto especiales---------------------------------------------------
               */

               nImpIvm        := nTotIFacCli( dbfFacCliL, nDouDiv, nRouDiv )

               if nImpIvm != 0

                  cSubCtaIvm  := oNewImp:cCtaImp( oNewImp:nValImp( ( dbfFacCliL )->cCodImp ) )

                  if !Empty( cSubCtaIvm )

                     nPos     := aScan( aIvm, {|x| x[1] == cSubCtaIvm } )
                     if nPos == 0
                        aAdd( aIvm, { cSubCtaIvm, nImpIvm } )
                     else
                        aIvm[ nPos, 2 ] += nImpIvm
                     end if

                  end if

               end if

            end if

         end if

         SysRefresh()

         ( dbfFacCliL )->( dbSkip() )

      end while

   else

      oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " factura sin artículos.", 0 ) )

      lErrorFound := .t.

   end if

   /*
   Descuentos sobres grupos de Venta
   --------------------------------------------------------------------------
   */

   for n := 1 to Len( aVentas )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDtoEsp )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDpp )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDtoUno )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDtoDos )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nPctDto )
   next

   /*
   Gastos se lo sumamos a la base----------------------------------------------
   */

   if ( ( dbfFacCliT )->nManObr != 0 )

      cSubCtaTrn     := uFieldEmpresa( "cCtaGas")

      nPos           := aScan( aVentas, {|x| x[ 1 ] == cSubCtaTrn .and. x[ 2 ] == ( dbfFacCliT )->nIvaMan } )
      if nPos == 0
         aAdd( aVentas, { cSubCtaTrn, ( dbfFacCliT )->nIvaMan, ( dbfFacCliT )->nManObr, 0, 0, 0, .f. } )
      else
         aVentas[ nPos, 3 ]   += ( dbfFacCliT )->nManObr
      end if

   end if 

   /*
   Despues de aplicar los descuentos le sumamos el punto verde-----------------
   */

   for n := 1 to Len( aVentas )
      aVentas[ n, 3 ]   += aVentas[ n, 4 ]
   next

   /*
   Ponemos la cuentas de IVA---------------------------------------------------
   */

   for each uIva in newIva

      if isNum( uIva[ 3 ] )

         /*
         Construimos las bases de los impuestos--------------------------------
         */

         if isIVAComunidadEconomicaEuropea( dbfFacCliT )
            cSubCtaIva  := cCuentaVentaIVARepercutidoUE()
            uIva[ 3 ]   := 0
            aAdd( uIva, cSubCtaIva )
         elseif isIVAExportacionFueraUE( dbfFacCliT )
            cSubCtaIva  := cCuentaVentaIVARepercutidoFueraUE()
            uIva[ 3 ]   := 0
            aAdd( uIva, cSubCtaIva )
         else
            aAdd( uIva, cSubCuentaIva( uIva[ 3 ], ( dbfFacCliT )->lRecargo, cRuta, cCodEmp, dbfIva ) )
            aAdd( uIva, cSubCuentaRecargo( uIva[ 3 ], ( dbfFacCliT )->lRecargo, cRuta, cCodEmp, dbfIva ) )
            aAdd( uIva, cSubCuentaIva( uIva[ 3 ], .f., cRuta, cCodEmp, dbfIva ) )
         end if

      end if 

   next 

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if ( dbfFacCliT )->lContab
      oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " subcuenta " + cCtaCli + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   if ptaRet != 0
      if !ChkSubcuenta( cRuta, cCodEmp, cCtaRet(), , .f., .f. )
         oTree:Select( oTree:Add( "Factura cliente : " + Rtrim( cFactura ) + " subcuenta " + cCtaRet() + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   end if

   /*
   Creacion y chequeo de Cuentas de impuestos
   --------------------------------------------------------------------------
   */

   for each uIva in newIva 

      if isNum( uIva[ 3 ] )

         if !ChkSubcuenta( cRutCnt(), cCodEmp, uIva[ 12 ], , .f., .f. )
            oTree:Select( oTree:Add( "Factura cliente : " + Rtrim( pFactura ) + " subcuenta " + uIva[ 12 ] + " no encontada.", 0 ) )
            lErrorFound := .t.
         end if

         if lRecargo .and. !ChkSubcuenta( cRutCnt(), cCodEmp, uIva[ 13 ], , .f., .f. )
            oTree:Select( oTree:Add( "Factura cliente : " + Rtrim( pFactura ) + " subcuenta " + uIva[ 13 ] + " no encontada.", 0 ) )
            lErrorFound := .t.
         end if

      end if 

   next

   for n := 1 to len( aVentas )
      if !ChkSubcuenta( cRuta, cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   for n := 1 to len( aIvm )
      if !lSimula .and. !ChkSubcuenta( cRuta, cCodEmp, aIvm[ n, 1 ], , .f., .f. )
         oTree:Add( "Factura cliente : " + rtrim( nFactura ) + " subcuenta " + aIvm[ n, 1 ] + " no encontada.", 0 )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeo de Cuentas de Transportes
   --------------------------------------------------------------------------
   */

   for n := 1 to len( aTrn )
      if !ChkSubcuenta( cRuta, cCodEmp, aTrn[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " subcuenta " + aTrn[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeamos los anticipos-------------------------------------------------
   */

   if nTotAnt != 0 .and. !ChkSubcuenta( cRuta, cCodEmp, cCtaAnticipo, , .f., .f. )
      oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " subcuenta de anticipo " + cCtaAnticipo + " no encontada.", 0 ) )
      lErrorFound := .t.
   end if

   /*
   Datos comunes a todos los Asientos
   --------------------------------------------------------------------------
   */

   cConcepto      := "N/Fcta. N." + ( dbfFacCliT )->CSERIE + "/" + alltrim( str( (dbfFacCliT)->NNUMFAC ) + "/" + (dbfFacCliT)->CSUFFAC )
   cPago          := "C/Fcta. N." + ( dbfFacCliT )->CSERIE + "/" + alltrim( str( (dbfFacCliT)->NNUMFAC ) + "/" + (dbfFacCliT)->CSUFFAC )

   /*
   Cuadre del apunte
   -------------------------------------------------------------------------
   */

   nTotDebe          += Round( ptaDebe, nRouDiv )

   for n := 1 to len( aVentas )

      if lIvaInc

         nCalculo    := Round( aVentas[ n, 3 ], nRouDiv )

         if aVentas[ n, 2 ] != 0
            nCalculo -= Round( aVentas[ n, 3 ] / ( 100 / aVentas[ n, 2 ] + 1 ), nRouDiv )
         end if

      else

         nCalculo    := Round( aVentas[ n, 3 ], nRouDiv )

      end if

      nTotHaber      += nCalculo

   next

   nTotDebe          += ptaRet
   nTotDebe          += nAcuAnt

   for n := 1 to Len( aIvm )
      nTotHaber      += Round( aIvm[ n, 2 ], nRouDiv )
   next

   for n := 1 to Len( aTrn )
      nTotHaber      += Round( aTrn[ n, 2 ], nRouDiv )
   next

   for each uIva in newIva 

      if isNum( uIva[ 8 ] )
         nTotHaber   += uIva[ 8 ]
      end if 

      if lRecargo .and. isNum( uIva[ 9 ] )
         nTotHaber   += uIva[ 9 ]
      end if 

   next

   nTotDebe          := Round( nTotDebe, nRouDiv )
   nTotHaber         := Round( nTotHaber, nRouDiv )

   /*
   Realización de Asientos
   --------------------------------------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if lOpenDiario .or. OpenDiario( , cCodEmp )
         nAsiento    := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Factura cliente : " + Rtrim( pFactura ) + " imposible abrir ficheros de contaplus.", 0 ) )
         Return .f.
      end if

      setAsientoIntraComunitario( isIVAComunidadEconomicaEuropea( dbfFacCliT ) )

      /*
      Asiento de cliente----------------------------------------------------------
      */

      if lAplicacionContaplus()

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaCli,;
                                    ,;
                                    Round( ptaDebe, nRouDiv ),;
                                    cConcepto,;
                                    ,;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      else 

         EnlaceA3():getInstance():Add( {  "Empresa"               => cEmpCnt( ( dbfFacCliT )->cSerie ),;
                                          "Fecha"                 => dFecha ,;
                                          "TipoRegistro"          => '1',; // Facturas
                                          "Cuenta"                => cCtaCli,;
                                          "DescripcionCuenta"     => cTerNom,;
                                          "TipoFactura"           => '1',; // Ventas
                                          "NumeroFactura"         => cFactura,;
                                          "DescripcionApunte"     => cConcepto,;
                                          "Importe"               => Round( ptaDebe, nRouDiv ),;
                                          "Nif"                   => cTerNif,;
                                          "NombreCliente"         => cTerNom,;
                                          "CodigoPostal"          => ( dbfFacCliT )->cPosCli,;
                                          "FechaOperacion"        => dFecha,;
                                          "FechaFactura"          => dFecha,;
                                          "Moneda"                => 'E',; // Euros
                                          "Render"                => 'CabeceraFactura' } )

      end if 

      /*
      Asientos de Ventas
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aVentas )

         nCalculo       := Round( aVentas[ n, 3 ], nRouDiv )

         if lIvaInc

            nPctIva     := aVentas[ n, 2 ]
        
            if ( lRecargo .and. aVentas[ n, 7 ] )
               nPctIva  += nPReq( dbfIva, aVentas[ n, 2 ] )
            end if             

            if aVentas[ n, 2 ] != 0
               nCalculo -= Round( aVentas[ n, 3 ] / ( 100 / nPctIva + 1 ), nRouDiv )
            end if

         end if 

         if lAplicacionContaplus()

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       cCodDiv, ;
                                       dFecha, ;
                                       aVentas[ n, 1 ],;
                                       ,;
                                       ,;
                                       cConcepto,;
                                       nCalculo,;
                                       cFactura,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         else 

            EnlaceA3():getInstance():Add( {  "Empresa"               => cEmpCnt( ( dbfFacCliT )->cSerie ),;
                                             "Fecha"                 => dFecha ,;
                                             "TipoRegistro"          => '9',; // Facturas
                                             "Cuenta"                => aVentas[ n, 1 ],;
                                             "DescripcionCuenta"     => '',;
                                             "TipoImporte"           => 'C',;
                                             "NumeroFactura"         => cFactura,;
                                             "DescripcionApunte"     => cConcepto,;
                                             "SubtipoFactura"        => if( isIVAComunidadEconomicaEuropea( dbfFacCliT ), '02', '01' ),; // Ventas
                                             "BaseImponible"         => nCalculo,;
                                             "PorcentajeIVA"         => aVentas[ n, 2 ],;
                                             "PorcentajeRecargo"     => if( ( dbfFacCliT )->lRecargo, nPReq( dbfIva, aVentas[ n, 2 ] ), 0 ),;
                                             "PorcentajeRetencion"   => 0,;
                                             "Impreso"               => '01',; // 347
                                             "SujetaIVA"             => if( aVentas[ n, 2 ] != 0, 'S', 'N' ),;
                                             "Modelo415"             => ' ',;
                                             "Analitico"             => ' ',;
                                             "Moneda"                => 'E',; // Euros
                                             "Render"                => 'VentaFactura' } )

         end if 

      next

      /*
      Asientos del retenciones________________________________________________________
      */

      if lAplicacionContaplus() .and. ptaRet != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaRet(),;   // Cuenta de retencion
                                    ,;
                                    ptaRet,;
                                    cConcepto,;
                                    ,;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Asientos de anticipo
      -------------------------------------------------------------------------
      */

      if lAplicacionContaplus() .and. nTotAnt != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaAnticipo,;
                                    ,;
                                    nAcuAnt,;
                                    cConcepto,;
                                    ,;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Asientos de IVM
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aIvm )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aIvm[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aIvm[ n, 2 ], nRouDiv ),;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula ) )

      next

      /*
      Asientos de transporte
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aTrn )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aTrn[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aTrn[ n, 2 ], nRouDiv ),;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de impuestos
      --------------------------------------------------------------------------
      */

      for each uIva in newIva

         if ( len( uIva ) >= 12 ) .and. ( uIva[ 8 ] != 0 .or. uFieldEmpresa( "lConIva" ) )

            nBaseImp    := uIva[ 2 ] - uIva[ 10 ] 

            if uFieldEmpresa( "lIvaImpEsp")
               nBaseImp += uIva[ 6 ]
            end if

            aAsiento    := MkAsiento(  nAsiento, ;                          
                                       cCodDiv, ;                          
                                       dFecha, ;                          
                                       uIva[ 12 ],;                           // Cuenta de impuestos                          
                                       cCtaCli,;                              // Contrapartida                          
                                       ,;                                     // Ptas. Debe                          
                                       cConcepto,;                          
                                       uIva[ 8 ] - uIva[ 11 ],;               // Ptas. Haber                          
                                       cFactura,;                          
                                       nBaseImp,;                             // Base Imponible                          
                                       uIva[ 3 ],;                          
                                       if( lRecargo, uIva[ 4 ], 0 ),;         // Tipo de recargo                         
                                       ,;                          
                                       cProyecto,;                          
                                       cClave,;                          
                                       ,;                          
                                       ,;                          
                                       ,;                          
                                       lSimula,;                          
                                       cTerNif,;                          
                                       cTerNom )

            msgalert( hb_valtoexp( aAsiento ), "aAsiento" )

            aAdd( aSimula, aAsiento )                          

         end if

         /*
         Asientos del Recargo
         -------------------------------------------------------------------------
         */

         if ( lRecargo .and. len( uIva ) >= 13 .and. uIva[ 9 ] != 0 )

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha,;
                                       uIva[ 13 ],;
                                       ,;
                                       ,;
                                       cConcepto,;
                                       uIva[ 9 ],;
                                       cFactura,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         end if 

         /*
         Asientos de Portes exentos de recargo de equivalencia
         -------------------------------------------------------------------------
         */

         if ( len( uIva ) >= 14 .and. uIva[ 10 ] != 0 )

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha,;
                                       uIva[ 14 ],;      // Cuenta de impuestos
                                       cCtaCli,;         // Contrapartida                          
                                       ,;                // Ptas. Debe                          
                                       cConcepto,;
                                       uIva[ 11 ],;      // Ptas. Haber
                                       cFactura,;
                                       uIva[ 10 ],;      // Base Imponible
                                       uIva[ 3 ],;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         end if 


      next

   end if

   // Contabilizamos desde aki A3---------------------------------------------

   // if lAplicacionA3()
   //    oEnlaceContable:Render()
   // end if 

   /*
   Contabilizamos los pagos
   ----------------------------------------------------------------------------
   */

   if lPago .and. !lErrorFound .and. ( dbfFacCliP )->( dbSeek( nFactura ) )

      while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == nFactura ) .and. !( dbfFacCliP )->( eof() )

         ContabilizaReciboCliente( oBrw, oTree, lSimula, aSimula, dbfFacCliT, dbfFacCliP, dbfFPago, dbfCli, dbfDiv, .t., nAsiento )

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

   /*
   Ponemos la factura como Contabilizada---------------------------------------
   */

   if lSimula

      if lMessage
         lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, pFactura, {|| aWriteAsiento( aSimula, cCodDiv, lMessage, oTree, pFactura, nAsiento ), lCntFacCli( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacCliT, dbfFacCliP ) } )
      end if

   else

      if !lErrorFound
         aWriteAsiento( aSimula, cCodDiv, lMessage, oTree, pFactura, nAsiento )

         lReturn  := lCntFacCli( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacCliT )
      end if

   end if

   /*
   Cerramos las tablas de contaplus--------------------------------------------
   */

   if !lOpenDiario
      CloseDiario()
   end if

   setAsientoIntraComunitario( .f. )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

Static Function lCntFacCli( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacCliT, dbfFacCliP )

   // Contabilizamos desde aki A3---------------------------------------------

   if lAplicacionA3()
      EnlaceA3():getInstance():Render()
   end if 

   // Ponemos el ticket como contabilizado-------------------------------------

   if dbDialogLock( dbfFacCliT )
      ( dbfFacCliT )->lContab := .t.
      ( dbfFacCliT )->( dbUnLock() )
   end if

   // Mensaje------------------------------------------------------------------

   if lAplicacionA3()
      EnlaceA3():getInstance():WriteInfo( oTree, "Factura cliente : " + rtrim( pFactura ) + " asiento generado." )
   else
      oTree:Select( oTree:Add( "Factura cliente : " + rtrim( pFactura ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 ) )
   end if 

   // Contabilizacion de recibos-----------------------------------------------

   if !Empty( dbfFacCliP )

      if lPago .and. ( dbfFacCliP )->( dbSeek( nFactura ) )

         while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == nFactura ) .and. !( dbfFacCliP )->( eof() )

            lContabilizaReciboCliente( nil, nil, .t., oTree, dbfFacCliP )

            ( dbfFacCliP )->( dbSkip() )

         end while

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

Function DlgCntTicket( dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oBrw, oNewImp )

   local oRad
   local nRad        := 1
   local oDlg
   local oChk1
   local oChk2
   local lChk1       := .t.
   local lChk2       := .t.
   local oSelTik
   local nSelTik     := 1
   local nOrdAnt     := ( dbfTikT )->( OrdSetFocus( 1 ) )
   local nRecAnt     := ( dbfTikT )->( RecNo() )
   local oSerIni
   local cSerIni     := ( dbfTikT )->cSerTik
   local oDocIni
   local nDocIni     := Val( ( dbfTikT )->cNumTik )
   local oSufIni
   local cSufIni     := ( dbfTikT )->cSufTik
   local oSerFin
   local cSerFin     := ( dbfTikT )->cSerTik
   local oDocFin
   local nDocFin     := Val( ( dbfTikT )->cNumTik )
   local cSufFin     := ( dbfTikT )->cSufTik
   local oSufFin
   local dFecIni     := ( dbfTikT )->dFecTik
   local dFecFin     := ( dbfTikT )->dFecTik
   local lSimula     := .t.
   local lCobros     := .t.
   local oMtrInf
   local nMtrInf
   local lFechas     := .t.
   local dDesde      := CtoD( "01/01/" + str( Year( Date() ) ) )
   local dHasta      := Date()
   local oTree
   local oImageList
   local oBtnCancel

   oImageList        := TImageList():New( 16, 16 )
   oImageList:AddMasked( TBitmap():Define( "bRed" ), Rgb( 255, 0, 255 ) )
   oImageList:AddMasked( TBitmap():Define( "bGreen" ), Rgb( 255, 0, 255 ) )

   DEFINE DIALOG oDlg RESOURCE "SelectRango"

   REDEFINE RADIO oRad VAR nRad ;
      ID       80, 81 ;
      OF       oDlg

   REDEFINE GET oSerIni VAR cSerIni ;
      ID       100 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerIni ) );
      ON DOWN  ( DwSerie( oSerIni ) );
      WHEN     ( oRad:nOption == 2 ) ;
      VALID    ( cSerIni >= "A" .and. cSerIni <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       101 ;
      OF       oDlg ;
      RESOURCE "Up16" ;
      NOBORDER ;
      ACTION   ( oDocIni:cText( Val( dbFirst( dbfTikT, "cNumTik", , cSerIni, "cNumTik" ) ) ) )

   REDEFINE GET oSerFin VAR cSerFin ;
      ID       110 ;
      PICTURE  "@!" ;
      SPINNER ;
      ON UP    ( UpSerie( oSerFin ) );
      ON DOWN  ( DwSerie( oSerFin ) );
      WHEN     ( oRad:nOption == 2 ) ;
      VALID    ( cSerFin >= "A" .and. cSerFin <= "Z" );
      UPDATE ;
      OF       oDlg

   REDEFINE BTNBMP ;
      ID       111 ;
      OF       oDlg ;
      RESOURCE "Down16" ;
      NOBORDER ;
      ACTION   ( oDocFin:cText( Val( dbLast( dbfTikT, "cNumTik", , cSerIni, "cNumTik" ) ) ) )

   REDEFINE GET oDocIni VAR nDocIni;
      ID       120 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oDocFin VAR nDocFin;
      ID       130 ;
      PICTURE  "999999999" ;
      SPINNER ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oSufIni VAR cSufIni ;
      ID       140 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE GET oSufFin VAR cSufFin ;
      ID       150 ;
      PICTURE  "##" ;
      WHEN     ( nRad == 2 ) ;
      OF       oDlg

   REDEFINE CHECKBOX oChk1 VAR lChk1 ;
      ID       160 ;
      OF       oDlg

   REDEFINE CHECKBOX oChk2 VAR lChk2 ;
      ID       180 ;
      OF       oDlg

   /*
   Rango de fechas-------------------------------------------------------------
   */

   REDEFINE CHECKBOX lFechas ;
      ID       300 ;
      OF       oDlg

   REDEFINE GET dDesde ;
      ID       310 ;
      WHEN     ( !lFechas ) ;
      SPINNER ;
      OF       oDlg

   REDEFINE GET dHasta ;
      ID       320 ;
      WHEN     ( !lFechas ) ;
      SPINNER ;
      OF       oDlg

   oTree             := TTreeView():Redefine( 170, oDlg )
   oTree:bLDblClick  := {|| TreeChanged( oTree ) }

   REDEFINE APOLOMETER oMtrInf ;
      VAR      nMtrInf ;
      PROMPT   "Proceso" ;
      ID       200;
      TOTAL    ( dbfTikT )->( Lastrec() ) ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( ContaSerieTiket( nRad, cSerIni + str( nDocIni, 10 ) + cSufIni, cSerFin + str( nDocFin, 10 ) + cSufFin, lFechas, dDesde, dHasta, lChk1, lChk2, oBrw, oMtrInf, oTree, oDlg, oBtnCancel, dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp ) )

   REDEFINE BUTTON oBtnCancel ;
      ID       IDCANCEL ;
      OF       oDlg ;
      CANCEL ;
      ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ContaSerieTiket( nRad, cSerIni + str( nDocIni, 10 ) + cSufIni, cSerFin + str( nDocFin, 10 ) + cSufFin, lFechas, dDesde, dHasta, lChk1, lChk2, oBrw, oMtrInf, oTree, oDlg, oBtnCancel, dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp ) } )

   oDlg:bStart := {|| StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin ) }

   ACTIVATE DIALOG oDlg CENTER ;
      ON INIT  ( oTree:SetImageList( oImageList ) )

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   oImageList:End()

   oTree:Destroy()

   oBrw:Refresh()

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function StartGetSelRec( oBrw, oRad, oChk1, oChk2, oSerIni, oSerFin, oDocIni, oDocFin, oSufIni, oSufFin )

   if !Empty( oBrw ) .and. ( len( oBrw:oBrw:aSelected ) > 1 )
      oRad:SetOption( 1 )
   else
      oRad:SetOption( 2 )
      oSerIni:Enable()
      oSerFin:Enable()
      oDocIni:Enable()
      oDocFin:Enable()
      oSufIni:Enable()
      oSufFin:Enable()
   end if

   oChk1:SetText( "Simular resultados" )

   oChk2:SetText( "Contabilizar cobors" )

Return ( nil )

//---------------------------------------------------------------------------//

Static Function TreeChanged( oTree )

   local oItemTree   := oTree:GetItem()

   if !Empty( oItemTree ) .and. !Empty( oItemTree:bAction )
      Eval( oItemTree:bAction )
   end if

Return nil

//---------------------------------------------------------------------------//

Static Function ContaSerieTiket( nRad, cNumIni, cNumFin, lFechas, dDesde, dHasta, lSimula, lCobro, oBrw, oMtrInf, oTree, oDlg, oBtnCancel, dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp )

   local n        := 0
   local aPos
   local nPos
   local lRet
   local nRecAnt  := ( dbfTikT )->( RecNo() )
   local nOrdAnt  := ( dbfTikT )->( OrdSetFocus( "cNumTik" ) )
   local lWhile   := .t.

   /*
   Preparamos la pantalla para mostrar la simulación---------------------------
   */

   if lSimula
      aPos        := { 0, 0 }
      ClientToScreen( oDlg:hWnd, aPos )
      oDlg:Move( aPos[ 1 ] - 26, aPos[ 2 ] - 510 )
   end if

   /*
   Iniabilitamos el dialogo para iniciar el proceso----------------------------
   */

   oDlg:Disable()

   oTree:Enable()
   oTree:DeleteAll()

   oBtnCancel:bAction   := {|| lWhile := .f. }
   oBtnCancel:Enable()

   if nRad == 1

      oMtrInf:SetTotal( len( oBrw:oBrw:aSelected ) )

      for each nPos in ( oBrw:oBrw:aSelected )

         ( dbfTikT )->( dbGoTo( nPos ) )

         if lFechas .or.( ( dbfTikT )->dFecTik >= dDesde .and. ( dbfTikT )->dFecTik <= dHasta )

            do case
               case ( dbfTikT )->cTipTik == "1"
                  lRet  := CntTiket( lSimula, lCobro, .f., .t., oTree, 0, , dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp )
               case ( dbfTikT )->cTipTik == "4"
                  lRet  := CntTiket( lSimula, lCobro, .t., .t., oTree, 0, , dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp )
            end case

         end if

         if IsFalse( lRet )
            exit
         end if

         oMtrInf:Set( ++n )

         SysRefresh()

         if !lWhile
            exit
         end if

      next

      oMtrInf:Set( len( oBrw:oBrw:aSelected ) )

   else

      if ( dbfTikT )->( dbSeek( cNumIni, .t. ) )

         oMtrInf:Set( ( dbfTikT )->( OrdKeyNo() ) )

         while ( lWhile )                                .and.;
               !Empty( ( dbfTikT )->( OrdKeyVal() ) )    .and.;
               ( dbfTikT )->( OrdKeyVal() ) >= cNumIni   .and.;
               ( dbfTikT )->( OrdKeyVal() ) <= cNumFin   .and.;
               ( dbfTikT )->( !eof() )

            if lFechas .or.( ( dbfTikT )->dFecTik >= dDesde .and. ( dbfTikT )->dFecTik <= dHasta )

               do case
                  case ( dbfTikT )->cTipTik == "1"
                     lRet  := CntTiket( lSimula, lCobro, .f., .t., oTree, 0, , dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp )
                  case ( dbfTikT )->cTipTik == "4"
                     lRet  := CntTiket( lSimula, lCobro, .t., .t., oTree, 0, , dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp )
               end case

               if IsFalse( lRet )
                  exit
               end if

            end if

            ( dbfTikT )->( dbSkip() )

            oMtrInf:Set( ( dbfTikT )->( OrdKeyNo() ) )

         end while

         oMtrInf:Set( ( dbfTikT )->( Lastrec() ) )

      end if

   end if

   if lSimula
      WndCenter( oDlg:hWnd ) // Move( aPos[ 1 ], aPos[ 2 ] + 200 )
   end if

   oBtnCancel:bAction   := {|| oDlg:End() }

   oDlg:Enable()

   ( dbfTikT )->( dbGoTo( nRecAnt ) )
   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )

Return Nil

//--------------------------------------------------------------------------//

Function CntTiket( lSimula, lCobro, lDev, lMessage, oTree, nAsiento, aSimula, dbfTikT, dbfTikL, dbfTikP, dbfCli, dbfArt, dbfFPago, dbfDiv, oNewImp )

   local n
   local nPos
   local dFecha
   local cConcepto
   local cPago
   local nIvaDeta
   local nImpDeta
   local nIvmDeta
   local cSubCtaIvm
   local cSubCtaIva
   local cCtaVent
   local aIva        := {}
   local aIvm        := {}
   local aVentas     := {}
   local aPago       := {}
   local aAsiento    := {}
   local nTotTik     := 0
   local nTotPgo     := 0
   local cCtaPgo     := cCtaCob()
   local cRuta       := cRutCnt()
   local nOrdAnt
   local cCodEmp     := cCodEmpCnt( ( dbfTikT )->cSerTik )
   local cCodPro     := ( dbfTikT )->cCodPro
   local cCtaCli     := cCliCta( ( dbfTikT )->cCliTik, dbfCli )
   local cNumTik     := ( dbfTikT )->cSerTik + ( dbfTikT )->cNumTik + ( dbfTikT )->cSufTik
   local cTxtNumTik  := Rtrim( ( dbfTikT )->cSerTik + "/" + alltrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik )
   local cCodDiv     := ( dbfTikT )->cDivTik
   local nDouDiv     := nDouDiv( ( dbfTikT )->cDivTik, dbfDiv )
   local nRouDiv     := nRouDiv( ( dbfTikT )->cDivTik, dbfDiv )
   local lErrorFound := .f.
   local cProyecto
   local cClave
   local cTerNif     := ( dbfTikT )->cDniCli
   local cTerNom     := ( dbfTikT )->cNomTik
   local lReturn
   local nBaseImp

   DEFAULT nAsiento  := 0
   DEFAULT aSimula   := {}

   cProyecto         := Left( cCodPro, 3 )
   cClave            := Right( cCodPro, 6 )

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if !ChkRuta( cRuta )
      oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " ruta no valida para acceso a Contaplus®", 0 ) )
      lErrorFound    := .t.
   end if

   if Empty( cCodEmp )
      oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " empresa de Contaplus® no encontrada", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkFecha( cRuta, cCodEmp, ( dbfTikT )->dFecTik, .f., oTree )
      lErrorFound    := .t.
   end if

   if ( dbfTikT )->lConTik
      oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + ", ya contabilizado", 0 ) )
      lErrorFound    := .t.
   else
      oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik, 0 ) )
   end if

   nTotTik           := nTotTik( cNumTik, dbfTikT, dbfTikL, dbfDiv, nil, nil, .f., nil )

   if lDev
      nTotTik        := - nTotTik
   end if

   /*
   Preparamos los apuntes de cliente
   --------------------------------------------------------------------------
   */

   if Empty( cCtaCli )
      cCtaCli        := cCtaSin()
   end if

   /*
   Estudio de los Articulos de una factura
   --------------------------------------------------------------------------
   */

   if ( dbfTikL )->( dbSeek( cNumTik ) ) // nTotTik != 0 .and.

      while ( dbfTikL )->cSerTil + ( dbfTikL )->cNumTil + ( dbfTikL )->cSufTil == cNumTik .AND. !( dbfTikL )->( eof() )

         /*
         Si el articulo no es un obsequio ni tiene control de almacen de tipo contadores
         */

         /*
         Importe de la linea---------------------------------------------------
         */

         nImpDeta    := nNetLTpv( dbfTikL, nDouDiv, nRouDiv )

         if ( dbfTikT )->nDtoEsp != 0
            nImpDeta -= Round( nImpDeta * ( dbfTikT )->nDtoEsp / 100, nRouDiv )
         end if

         if ( dbfTikT )->nDpp != 0
            nImpDeta -= Round( nImpDeta * ( dbfTikT )->nDpp / 100, nRouDiv )
         end if

         /*
         impuestos de la linea-------------------------------------------------------
         */

         nIvaDeta    := nTotLTpv( dbfTikL, nDouDiv, nRouDiv )

         if ( dbfTikT )->nDtoEsp != 0
            nIvaDeta -= Round( nIvaDeta * ( dbfTikT )->nDtoEsp / 100, nRouDiv )
         end if

         if ( dbfTikT )->nDpp != 0
            nIvaDeta -= Round( nIvaDeta * ( dbfTikT )->nDpp / 100, nRouDiv )
         end if

         nIvaDeta    -= nImpDeta

         /*
         IVM de la linea-------------------------------------------------------
         */

         nIvmDeta    := nIvmLTpv( dbfTikL, nDouDiv, nRouDiv )

         if ( dbfTikT )->nDtoEsp != 0
            nIvmDeta -= Round( nIvmDeta * ( dbfTikT )->nDtoEsp / 100, nRouDiv )
         end if

         if ( dbfTikT )->nDpp != 0
            nIvmDeta -= Round( nIvmDeta * ( dbfTikT )->nDpp / 100, nRouDiv )
         end if

         nImpDeta    -= nIvmDeta

         /*
         Caso para las devoluciones--------------------------------------------
         */

         if lDev
            nImpDeta := - nImpDeta
            nIvaDeta := - nIvaDeta
            nIvmDeta := - nIvmDeta
         end if

         /*
         cuenta de venta en funcion de si es una devolucion---------------------
         */

         cCtaVent    := RetCtaVta( ( dbfTikL )->cCbaTil, ( nImpDeta < 0 ), dbfArt )
         if Empty( cCtaVent )
            cCtaVent := cCtaCli() + RetGrpVta( ( dbfTikL )->cCbaTil, cRuta, cCodEmp, dbfArt, ( dbfTikL )->nIvaTil )
         end if

         /*
         Acumula los importes--------------------------------------------------
         */

         nPos        := aScan( aVentas, {|x| x[ 1 ] == cCtaVent } )
         if nPos == 0 // .and. nImpDeta != 0
            aadd( aVentas, { cCtaVent, ( dbfTikL )->nIvaTil, nImpDeta, nIvaDeta } )
         else
            aVentas[ nPos, 3 ] += nImpDeta
            aVentas[ nPos, 4 ] += nIvaDeta
         end if

         /*
         Construimos las bases de los impuestosS
         --------------------------------------------------------------------
         */

         cSubCtaIva  := cSubCuentaIva( ( dbfTikL )->nIvaTil, .f., cRuta, cCodEmp )

         nPos        := aScan( aIva, {|x| x[ 1 ] == cSubCtaIva } )
         if nPos == 0 // .and. nImpDeta != 0
            aAdd( aIva, { cSubCtaIva, ( dbfTikL )->nIvaTil, nImpDeta, nIvaDeta, nIvmDeta  } )
         else
            aIva[ nPos, 3 ] += nImpDeta
            aIva[ nPos, 4 ] += nIvaDeta
            aIva[ nPos, 5 ] += nIvmDeta
         end if

         /*
         Construimos las bases de los IVMH
         --------------------------------------------------------------------
         */

         if nIvmDeta != 0

           // cSubCtaIvm  := RJust( ( dbfTikL )->nValImp, "0", 2 )
           // cSubCtaIvm  := cCtaVta() + RJust( cSubCtaIvm, "0", nLenCuentaContaplus( cRuta, cCodEmp ) )
           //cSubCtaIvm   := oNewImp:cCtaImp( ( dbfTikL )->nValImp )

           cSubCtaIvm   := oNewImp:cCtaImp( oNewImp:nValImp( ( dbfTikL )->cCodImp ) )

            nPos        := aScan( aIvm, {|x| x[ 1 ] == cSubCtaIvm } )
            if nPos == 0
               aAdd( aIvm, { cSubCtaIvm, nIvmDeta } )
            else
               aIvm[ nPos, 2 ] += nIvmDeta
            end if

         end if

         ( dbfTikL )->( dbSkip() )

      end while

   end if

   /*
   Descuentos sobre el total
   --------------------------------------------------------------------------

   for n := 1 to Len( aVentas )

      if ( dbfTikT )->nDtoEsp != 0
         aVentas[ n, 3 ] -= ( aVentas[ n, 3 ] * ( dbfTikT )->nDtoEsp / 100 )
         aVentas[ n, 3 ] := Round( aVentas[ n, 3 ], nRouDiv )
      end if

      if ( dbfTikT )->nDpp != 0
         aVentas[ n, 3 ] -= ( aVentas[ n, 3 ] * ( dbfTikT )->nDpp / 100 )
         aVentas[ n, 3 ] := Round( aVentas[ n, 3 ], nRouDiv )
      end if

   next
   */

   /*
   Descuentos sobres grupos de impuestos
   ----------------------------------------------------------------------------

   for n := 1 to Len( aIva )

      if ( dbfTikT )->nDtoEsp != 0
         aIva[ n, 3 ] -= ( aIva[ n, 3 ] * ( dbfTikT )->nDtoEsp / 100 )
         aIva[ n, 3 ] := Round( aIva[ n, 3 ], nRouDiv )

         aIva[ n, 4 ] -= ( aIva[ n, 4 ] * ( dbfTikT )->nDtoEsp / 100 )
         aIva[ n, 4 ] := Round( aIva[ n, 4 ], nRouDiv )
      end if

      if ( dbfTikT )->nDpp != 0
         aIva[ n, 3 ] -= ( aIva[ n, 3 ] * ( dbfTikT )->nDpp / 100 )
         aIva[ n, 3 ] := Round( aIva[ n, 3 ], nRouDiv )

         aIva[ n, 4 ] -= ( aIva[ n, 4 ] * ( dbfTikT )->nDpp / 100 )
         aIva[ n, 4 ] := Round( aIva[ n, 4 ], nRouDiv )
      end if

   next
   */

   /*
   Descuentos sobres grupos de impuestos
   ----------------------------------------------------------------------------

   for n := 1 to Len( aIvm )

      if ( dbfTikT )->nDtoEsp != 0
         aIvm[ n, 2 ] -= Round( aIvm[ n, 2 ] * ( dbfTikT )->nDtoEsp / 100, nRouDiv )
      end if

      if ( dbfTikT )->nDpp != 0
         aIvm[ n, 2 ] -= Round( aIvm[ n, 2 ] * ( dbfTikT )->nDpp / 100, nRouDiv )
      end if

   next
   */

   /*
   Contabilizaci¢n de Pagos
   --------------------------------------------------------------------------
   */

   nOrdAnt           := ( dbfTikP )->( OrdSetFocus( "cNumTik" ) )

   if ( dbfTikP )->( dbSeek( cNumTik ) )

      while ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .and. !( dbfTikP )->( eof() )

         if !Empty( ( dbfTikP )->cCtaPgo )
            cCtaPgo  := ( dbfTikP )->cCtaPgo
         else
            cCtaPgo  := cCtaFPago( ( dbfTikT )->cFpgTik, dbfFPago )
         end if

         if Empty( cCtaPgo )
            cCtaPgo  := cCtaCob()
         end if

         nTotPgo     := nTotUCobTik( dbfTikP, nRouDiv )

         if lDev
            nTotPgo  := - nTotPgo
         end if

         nPos        := aScan( aPago, {|x| x[ 1 ] + x[ 2 ] == cCtaPgo + cCtaCli } )
         if nPos == 0
            aAdd( aPago, { cCtaPgo, cCtaCli, nTotPgo } )
         else
            aPago[ nPos, 3 ] += nTotPgo
         end if

         ( dbfTikP )->( dbSkip() )

      end while

   end if

   ( dbfTikP )->( OrdSetFocus( nOrdAnt ) )

   /*
   Chequeamos la cuenta de cliente
   ----------------------------------------------------------------------------
   */

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " subcuenta de cliente " + RTrim( cCtaCli ) + " no encontada, en empresa" + cCodEmp, 0 ) )
      lErrorFound    := .t.
   end if

   for n := 1 to len( aVentas )
      if !ChkSubcuenta( cRuta, cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " subcuenta de ventas " + RTrim( aVentas[ n, 1 ] ) + " no encontada, en empresa" + cCodEmp, 0 ) )
         lErrorFound := .t.
      end if
   next

   for n := 1 to len( aIva )
      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " subcuenta de " + cImp() + " " + RTrim( aIva[ n, 1 ] ) + " no encontada, en empresa" + cCodEmp, 0 ) )
         lErrorFound := .t.
      end if
   next

   for n := 1 to len( aIvm )
      if !ChkSubcuenta( cRuta, cCodEmp, aIvm[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " subcuenta de IVM " + RTrim( aIvm[ n, 1 ] ) + " no encontada, en empresa" + cCodEmp, 0 ) )
         lErrorFound := .t.
      end if
   end if

   for n := 1 to len( aPago )
      if !ChkSubcuenta( cRuta, cCodEmp, aPago[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " subcuenta de pago " + RTrim( aPago[ n, 1 ] ) + " no encontada, en empresa" + cCodEmp, 0 ) )
         lErrorFound := .t.
      end if
   next

   /*
   Datos comunes a todos los Asientos
   --------------------------------------------------------------------------
   */

   dFecha      := ( dbfTikT )->dFecTik

   cConcepto   := "N/Tiket N. " + cTxtNumTik
   cPago       := "C/Tiket N. " + cTxtNumTik

   /*
   Realización de Asientos
   --------------------------------------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if OpenDiario( , cCodEmp )
         nAsiento                := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " imposible abrir ficheros.", 0 ) )
         return .f.
      end if

      /*
      Asiento de cliente----------------------------------------------------------
      */

      aadd( aSimula, MkAsiento(  nAsiento, ;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaCli,;
                                 ,;
                                 Round( nTotTik, nRouDiv ),;
                                 cConcepto,;
                                 ,;
                                 cNumTik,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 cProyecto,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Ventas
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aVentas )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aVentas[ n, 3 ], nRouDiv ),;
                                    cNumTik,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de IVM
      -------------------------------------------------------------------------
      */

      for n := 1 to len( aIvm )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aIvm[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aIvm[ n, 2 ], nRouDiv ),;
                                    cNumTik,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de impuestos
      --------------------------------------------------------------------------
      */

      for n := 1 to len( aIva )

         if aIva[ n, 4 ] != 0 .or. uFieldEmpresa( "lConIva" )

            if uFieldEmpresa( "lIvaImpEsp")
               nBaseImp := aIva[ n, 3 ] + aIva[ n, 5 ]
            else
               nBaseImp := aIva[n, 3 ]
            end if

            aAsiento    := MkAsiento(  nAsiento, ;                 
                                       cCodDiv, ;                 
                                       dFecha, ;                           // Fecha                 
                                       aIva[ n, 1 ],;                      // Cuenta de impuestos
                                       cCtaCli,;                           // Contrapartida
                                       ,;                                  // Ptas. Debe
                                       cConcepto,;                         // Concepto
                                       aIva[ n, 4 ],;                      // Ptas. Haber
                                       cNumTik,;                           // Factura                           
                                       nBaseImp,;                          // Base Imponible
                                       aIva[ n, 2 ],;                      // IVA
                                       ,;                                  // Recargo Equivalencia
                                       ,;                                  // Documento
                                       cProyecto,;                         // 
                                       cClave,;                 
                                       ,;                 
                                       ,;                 
                                       ,;                 
                                       lSimula,;                 
                                       cTerNif,;                 
                                       cTerNom )

            aAdd( aSimula, aAsiento )         

         end if

      next

      /*
      Contabilizaci¢n de Pagos
      --------------------------------------------------------------------------
      */

      if lCobro

         for n := 1 to len( aPago )

            if aPago[ n, 3 ] != 0

               aadd( aSimula, MkAsiento(  nAsiento,;
                                          cCodDiv,;
                                          dFecha, ;
                                          aPago[ n, 1 ],;
                                          ,;
                                          aPago[ n, 3 ],;
                                          cPago,;
                                          ,;
                                          cNumTik,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          cProyecto,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

            /*
            Contrapartida_________________________________________________________
            */

            if aPago[ n, 3 ] != 0

               aadd( aSimula, MkAsiento(  nAsiento,;
                                          cCodDiv,;
                                          dFecha, ;
                                          aPago[ n, 2 ],;
                                          ,;
                                          ,;
                                          cPago,;
                                          aPago[ n, 3 ],;
                                          cNumTik,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          cProyecto,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         next

      end if

      /*
      Ponemos la factura como Contabilizada
      --------------------------------------------------------------------------
      */

      if !lSimula

         if !lErrorFound
            lReturn  := lCntTiket( cNumTik, cTxtNumTik, nAsiento, lCobro, oTree, dbfTikT, dbfTikP )
         end if

      else

         if lMessage
            lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !( dbfTikT )->lConTik .and. !lErrorFound, cTxtNumTik, {|| aWriteAsiento( aSimula, cCodDiv, lMessage, oTree, cTxtNumTik, nAsiento ), lCntTiket( cNumTik, cTxtNumTik, nAsiento, lCobro, oTree, dbfTikT, dbfTikP ) } )
         end if

      end if

   end if

   CloseDiario()

RETURN ( lReturn )

//---------------------------------------------------------------------------//

Static Function lCntTiket( cNumTik, cTxtNumTik, nAsiento, lCobro, oTree, dbfTikT, dbfTikP )

   local nOrdAnt

   /*
   Ponemos el ticket como contabilizado
   --------------------------------------------------------------------------
   */

   if ( dbfTikT )->( dbRLock() )
      ( dbfTikT )->lConTik          := .t.
      ( dbfTikT )->( dbRUnLock() )
   end if

   /*
   Ponemos los pagos como contabilizados
   --------------------------------------------------------------------------
   */

   if lCobro

      nOrdAnt  := ( dbfTikP )->( OrdSetFocus( "cNumTik" ) )

      if ( dbfTikP )->( dbSeek( cNumTik ) )

         while ( dbfTikP )->cSerTik + ( dbfTikP )->cNumTik + ( dbfTikP )->cSufTik == cNumTik .and. !( dbfTikP )->( eof() )

            if ( dbfTikP )->( dbRLock() )
               ( dbfTikP )->lConPgo := .t.
               ( dbfTikP )->( dbRUnLock() )
            end if

            ( dbfTikP )->( dbSkip() )

         end while

      end if

      ( dbfTikP )->( OrdSetFocus( nOrdAnt ) )

   end if

   oTree:Select( oTree:Add( "Tiket : " + cTxtNumTik + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 ) )

Return ( .t. )

//---------------------------------------------------------------------------//
//
// Devuelve la subcuenta de impuestos
//

Function cSubCuentaIva( nIva, lRecargo, cRuta, cCodEmp, dbfIva, lVentas )

   local nReq        := 0
   local cReq        := ""
   local cIva        := RJust( nIva, "0", 2 )
   local cSubCtaIva  := ""

   DEFAULT lVentas   := .t.

   if ( nLenCuentaContaplus( cRuta, cCodEmp ) >= 4 )
      cReq           := "00"
   end if

   if ( lRecargo )
      nReq           := nPReq( dbfIva, nIva )

      if nReq  < 1 .or. uFieldEmpresa( "lReqDec" )
         nReq        := nReq * 10
      end if

      cReq           := RJust( nReq, "0", 2 )
   end if

   if lIvaReq()
      cSubCtaIva     := cIva + cReq
   else
      cSubCtaIva     := cReq + cIva
   end if

   if lVentas
      cSubCtaIva     := RetCtaEsp( 2 ) + RJust( cSubCtaIva, "0", nLenCuentaContaplus( cRuta, cCodEmp ) )
   else
      cSubCtaIva     := RetCtaEsp( 1 ) + RJust( cSubCtaIva, "0", nLenCuentaContaplus( cRuta, cCodEmp ) )
   end if

Return ( cSubCtaIva )

//---------------------------------------------------------------------------//
//
// Devuelve la subcuenta de recargo
//

Function cSubCuentaRecargo( nIva, lRecargo, cRuta, cCodEmp, dbfIva )

   local nReq        := 0
   local cSubCtaReq  := ""

   if lRecargo

      nReq           := nPReq( dbfIva, nIva )

      if nReq < 1 .or. uFieldEmpresa( "lReqDec" )
         nReq        := nReq * 10
      end if

   end if

   cSubCtaReq        := RetCtaEsp( 3 ) + RJust( nReq, "0", nLenCuentaContaplus( cRuta, cCodEmp ) )

Return ( cSubCtaReq )

//---------------------------------------------------------------------------//

FUNCTION CntAlbCli( lSimula, lExcCnt, lMessage, oTree, nAsiento, aSimula, dbfAlbCliT, dbfAlbCliL, dbfCli, dbfDiv, dbfArt, dbfFPago, dbfIva, oNewImp, oBrw )

   local n
   local nIva
   local cCtaVent
   local nPos
   local dFecha
   local ptaDebe
   local cConcepto
   local cPago
   local cSubCtaIva
   local cSubCtaReq
   local cSubCtaIvm
   local cSubCtaTrn
   local nImpDet
   local nImpTrn
   local nImpPnt
   local nImpIvm
   local nImpIva
   local cCodEmp
   local cRuta
   local nDouDiv
   local nRouDiv
   local nDpvDiv
   local nTotAnt     := 0
   local aIva        := {}
   local aIvm        := {}
   local aTrn        := {}
   local nCalculo    := 0
   local nBase       := 0
   local aVentas     := {}
   local lIvaInc     := ( dbfAlbCliT )->lIvaInc
   local cCodDiv     := ( dbfAlbCliT )->cDivAlb
   local cCtaCli     := cCliCta( ( dbfAlbCliT )->cCodCli, dbfCli )
   local cCtaCliVta  := cCliCtaVta( ( dbfAlbCliT )->cCodCli, dbfCli )
   local cCtaAnticipo:= cCtaAnt()
   local nAlbaran    := ( dbfAlbCliT )->cSerAlb + str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb
   local cAlbaran    := ( dbfAlbCliT )->cSerAlb + alltrim( str( ( dbfAlbCliT )->nNumAlb ) )
   local lRecargo    := ( dbfAlbCliT )->lRecargo
   local lErrorFound := .f.
   local cTerNif     := ( dbfAlbCliT )->cDniCli
   local cTerNom     := ( dbfAlbCliT )->cNomCli
   local lReturn

   DEFAULT lSimula   := .t.
   DEFAULT nAsiento  := 0
   DEFAULT aSimula   := {}

   nDouDiv           := nDouDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
   nRouDiv           := nRouDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )
   nDpvDiv           := nDpvDiv( ( dbfAlbCliT )->cDivAlb, dbfDiv )

   /*
   Seleccionamos las empresa dependiendo de la serie de Albaran
   --------------------------------------------------------------------------
   */

   cRuta             := cRutCnt()
   cCodEmp           := cCodEmpCnt( ( dbfAlbCliT )->cSerAlb )

   if !lSimula .and. !chkEmpresaAsociada( cCodEmp )
      oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " no se definierón empresas asociadas.", 0 ) )
      lErrorFound    := .t.
   end if

   if !lSimula .and. !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   if !lSimula .and. !ChkFecha( cRuta, cCodEmp, ( dbfAlbCliT )->dFecAlb, .f., oTree )
      lErrorFound    := .t.
   end if

   /*
   Preparamos los apuntes de cliente
   ----------------------------------------------------------------------------
   */

   if Empty( cCtaCli )
      cCtaCli        := cCtaSin()
   end if

   if Empty( cCtaCliVta )
      cCtaCliVta     := cCtaCli()
   end if

   /*
   Estudio de los Articulos
   ----------------------------------------------------------------------------
   */

   if ( dbfAlbCliL )->( dbSeek( nAlbaran ) )

      while ( ( dbfAlbCliL )->cSerAlb + str( ( dbfAlbCliL )->nNumAlb ) + ( dbfAlbCliL )->cSufAlb == nAlbaran .and. !( dbfAlbCliL )->( eof() ) )

         if !( dbfAlbCliL )->lControl                          .and. ;
            !( dbfAlbCliL )->lTotLin                           .and. ;
            lValLine( dbfAlbCliL )                             .and. ;
            nTotLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv, nil, .t., .f., .f. ) != 0

            if ( lExcCnt == nil                                .or.;    // Entran todos
               ( lExcCnt .and. ( dbfAlbCliL )->nCtlStk != 2 )  .or.;    // Articulos sin contadores
               ( !lExcCnt .and. ( dbfAlbCliL )->nCtlStk == 2 ) )        // Articulos con contadores

               nIva        := ( dbfAlbCliL )->nIva
               nImpDet     := nTotLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv, nil, .t., .f., .f. )
               nImpTrn     := nTrnLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv )                 // Portes
               nImpPnt     := nPntLAlbCli( dbfAlbCliL, nDpvDiv )
               nImpIva     := nIvaLAlbCli( dbfAlbCliL, nDouDiv, nRouDiv )

               /*
               Cuenta de venta si estamos devolviendo----------------------------
               */

               cCtaVent    := RetCtaVta( ( dbfAlbCliL )->cRef, ( nImpDet < 0 ), dbfArt )
               if Empty( cCtaVent )
                  cCtaVent := cCtaCliVta + RetGrpVta( ( dbfAlbCliL )->cRef, cRuta, cCodEmp, dbfArt, nIva )
               end if

               /*
               Cuentas de ventas--------------------------------------------------
               */

               if nImpDet != 0 .or. nImpPnt != 0 .or. nImpTrn != 0

                  nPos     := aScan( aVentas, {|x| x[ 1 ] == cCtaVent .and. x[ 2 ] == nIva } )
                  if nPos  == 0
                     aAdd( aVentas, { cCtaVent, nIva, nImpDet, nImpPnt, nImpTrn, nImpIva } )
                  else
                     aVentas[ nPos, 3 ]   += nImpDet
                     aVentas[ nPos, 4 ]   += nImpPnt
                     aVentas[ nPos, 5 ]   += nImpTrn
                     aVentas[ nPos, 6 ]   += nImpIva
                  end if

                  /*
                  Construimos las bases de los impuestosS y las cuentas
                  ----------------------------------------------------------------
                  */

                  cSubCtaReq  := cSubCuentaRecargo( nIva, ( dbfAlbCliT )->lRecargo, cRuta, cCodEmp, dbfIva )
                  cSubCtaIva  := cSubCuentaIva( nIva, ( dbfAlbCliT )->lRecargo, cRuta, cCodEmp, dbfIva )

                  nPos        := aScan( aIva, {|x| x[ 1 ] == nIva } )
                  if nPos  == 0
                     aAdd( aIva, { nIva, cSubCtaIva, cSubCtaReq, nImpDet, nImpPnt, nImpTrn, 0 } )
                  else
                     aIva[ nPos, 4 ] += nImpDet
                     aIva[ nPos, 5 ] += nImpPnt
                     aIva[ nPos, 6 ] += nImpTrn
                  end if

                  /*
                  transportes--------------------------------------------------------
                  */

                  if nImpTrn != 0

                     cSubCtaTrn  := RetCtaTrn( ( dbfAlbCliL )->cRef, dbfArt )

                     nPos        := aScan( aTrn, {|x| x[1] == cSubCtaTrn } )
                     if nPos == 0
                        aAdd( aTrn, { cSubCtaTrn, nImpTrn } )
                     else
                        aIvm[ nPos, 2 ] += nImpTrn
                     end if

                  end if

                  /*
                  impuesto especiales---------------------------------------------------
                  */

                  nImpIvm        := nTotIAlbCli( dbfAlbCliL, nDouDiv, nRouDiv )

                  if nImpIvm != 0

                     cSubCtaIvm  := oNewImp:cCtaImp( ( dbfAlbCliL )->nValImp )

                     nPos        := aScan( aIvm, {|x| x[1] == cSubCtaIvm } )
                     if nPos == 0
                        aAdd( aIvm, { cSubCtaIvm, nImpIvm } )
                     else
                        aIvm[ nPos, 2 ] += nImpIvm
                     end if

                  end if

               end if

            end if

         end if

         SysRefresh()

         ( dbfAlbCliL )->( dbSkip() )

      end while

   else

      oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " Albaran sin artículos.", 0 ) )
      lErrorFound := .t.

   end if

   /*
   Descuentos sobres grupos de Venta
   --------------------------------------------------------------------------
   */

   for n := 1 to Len( aVentas )

      if ( dbfAlbCliT )->nDtoEsp != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfAlbCliT )->nDtoEsp / 100, nRouDiv )
      end if

      if ( dbfAlbCliT )->nDpp != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfAlbCliT )->nDpp / 100, nRouDiv )
      end if

      if ( dbfAlbCliT )->nDtoUno != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfAlbCliT )->nDtoUno / 100, nRouDiv )
      end if

      if ( dbfAlbCliT )->nDtoDos != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfAlbCliT )->nDtoDos / 100, nRouDiv )
      end if

   next

   /*
   Despues de aplicar los descuentos le sumamos el punto verde-----------------
   */

   for n := 1 to Len( aVentas )
      aVentas[ n, 3 ] += aVentas[ n, 4 ]
   next

   /*
   Descuentos sobres grupos de impuestos
   ----------------------------------------------------------------------------
   */

   for n := 1 to Len( aIva )

      if ( dbfAlbCliT )->nDtoEsp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfAlbCliT )->nDtoEsp / 100, nRouDiv )
      end if

      if ( dbfAlbCliT )->nDpp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfAlbCliT )->nDpp / 100, nRouDiv )
      end if

      if ( dbfAlbCliT )->nDtoUno != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfAlbCliT )->nDtoUno / 100, nRouDiv )
      end if

      if ( dbfAlbCliT )->nDtoDos != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfAlbCliT )->nDtoDos / 100, nRouDiv )
      end if

   next

   /*
   Despues de aplicar los descuentos le sumamos el punto verde-----------------
   */

   for n := 1 to Len( aIva )
      aIva[ n, 4 ]   += aIva[ n, 5 ]
   next

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if !lSimula .and. ( dbfAlbCliT )->lContab
      oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   if !lSimula .AND. !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " subcuenta " + cCtaCli + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Creacion y chequeo de Cuentas de impuestos
   --------------------------------------------------------------------------
   */

   for n := 1 to len( aIva )

      if !lSimula .and. !ChkSubcuenta( cRutCnt(), cCodEmp, aIva[ n, 2 ], , .f., .f. )
         oTree:Select( oTree:Add( "Albaran cliente : " + Rtrim( nAlbaran ) + " subcuenta " + aIva[ n, 2 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if

      if lRecargo .and. !lSimula .and. !ChkSubcuenta( cRutCnt(), cCodEmp, aIva[ n, 3 ], , .f., .f. )
         oTree:Select( oTree:Add( "Albaran cliente : " + Rtrim( nAlbaran ) + " subcuenta " + aIva[ n, 3 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if

   next

   for n := 1 to len( aVentas )
      if !lSimula .AND. !ChkSubcuenta( cRuta, cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   for n := 1 to len( aIvm )
      if !lSimula .AND. !ChkSubcuenta( cRuta, cCodEmp, aIvm[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " subcuenta " + aIvm[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeo de Cuentas de Transportes
   --------------------------------------------------------------------------
   */

   for n := 1 to len( aTrn )
      if !lSimula .AND. !ChkSubcuenta( cRuta, cCodEmp, aTrn[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " subcuenta " + aTrn[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeamos los anticipos-------------------------------------------------
   */

   if !lSimula .AND. nTotAnt != 0 .and. !ChkSubcuenta( cRuta, cCodEmp, cCtaAnticipo, , .f., .f. )
      oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " subcuenta de anticipo " + cCtaAnticipo + " no encontada.", 0 ) )
      lErrorFound := .t.
   end if

   if !lErrorFound

      /*
      Datos comunes a todos los Asientos
      --------------------------------------------------------------------------
      */

      dFecha      := ( dbfAlbCliT )->dFecAlb
      ptaDebe     := nTotAlbCli( ( dbfAlbCliT )->cSerAlb + str( ( dbfAlbCliT )->nNumAlb ) + ( dbfAlbCliT )->cSufAlb, dbfAlbCliT, dbfAlbCliL, dbfIva, dbfDiv, nil, nil, .f., lExcCnt  )
      cConcepto   := "N/Alb. N." + ( dbfAlbCliT )->cSerAlb + "/" + alltrim( str( ( dbfAlbCliT )->nNumAlb ) + "/" + ( dbfAlbCliT )->cSufAlb )
      cPago       := "C/Alb. N." + ( dbfAlbCliT )->cSerAlb + "/" + alltrim( str( ( dbfAlbCliT )->nNumAlb ) + "/" + ( dbfAlbCliT )->cSufAlb )

      /*
      Realización de Asientos
      --------------------------------------------------------------------------
      */

      if OpenDiario( , cCodEmp )
         nAsiento := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Albaran cliente : " + Rtrim( nAlbaran ) + " imposible abrir ficheros.", 0 ) )
         return .f.
      end if

      /*
      Asiento de cliente----------------------------------------------------------
      */

      aadd( aSimula, MkAsiento(  nAsiento, ;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaCli,;
                                 ,;
                                 Round( ptaDebe, nRouDiv ),;
                                 cConcepto,;
                                 ,;
                                 cAlbaran,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Ventas
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aVentas )

         if lIvaInc

         nCalculo    := Round( aVentas[ n, 3 ], nRouDiv )
         if aVentas[ n, 2 ] != 0
            nCalculo -= Round( aVentas[ n, 3 ] / ( 100 / aVentas[ n, 2 ] + 1 ), nRouDiv )
         end if

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    nCalculo,;
                                    cAlbaran,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

         else

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aVentas[ n, 3 ], nRouDiv ),;
                                    cAlbaran,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

         end if

      next

      /*
      Asientos de IVM
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aIvm )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aIvm[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aIvm[ n, 2 ], nRouDiv ),;
                                    cAlbaran,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de transporte
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aTrn )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aTrn[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aTrn[ n, 2 ], nRouDiv ),;
                                    cAlbaran,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de impuestos
      --------------------------------------------------------------------------
      */

      for n := 1 to len( aIva )

         nBase          := Round( aIva[ n, 4 ], nRouDiv ) + Round( aIva[ n, 7 ], nRouDiv )

         if lIvaInc

            if aIva[ n, 1 ] != 0
               nCalculo := Round( aIva[ n, 4 ] / ( 100 / aIva[ n, 1 ] + 1 ), nRouDiv )
               nCalculo += Round( aIva[ n, 7 ] / ( 100 / aIva[ n, 1 ] + 1 ), nRouDiv )
            else
               nCalculo := 0
            end if

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aAdd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv, ;
                                          dFecha, ;
                                          aIva[ n, 2 ],;       // Cuenta de impuestos
                                          cCtaCli,;            // Contrapartida
                                          ,;                   // Ptas. Debe
                                          cConcepto,;
                                          nCalculo,;           // Ptas. Haber
                                          cAlbaran,;
                                          nBase - nCalculo,;   // Base Imponible
                                          Round( aIva[ n, 1 ], nRouDiv ),;
                                          If( lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), ),;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         else

            nCalculo    := Round( aIva[ n, 4 ] * aIva[ n, 1 ] / 100, nRouDiv )
            nCalculo    += Round( aIva[ n, 7 ] * aIva[ n, 1 ] / 100, nRouDiv )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv, ;
                                          dFecha, ;
                                          aIva[ n, 2 ],;    // Cuenta de impuestos
                                          cCtaCli,;         // Contrapartida
                                          ,;                // Ptas. Debe
                                          cConcepto,;
                                          nCalculo,;        // Ptas. Haber
                                          cAlbaran,;
                                          nBase,;           // Base Imponible
                                          Round( aIva[ n, 1 ], nRouDiv ),;
                                          If( lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), ),;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         end if

      next

      /*
      Asientos del Recargo
      -------------------------------------------------------------------------
      */

      if lRecargo

         for n := 1 TO len( aIva )

            if Round( nPReq( dbfIva, aIva[ n, 1 ] ) * ( aIva[ n, 4 ] ) / 100, nRouDiv ) != 0

               aadd( aSimula, MkAsiento(  nAsiento,;
                                          cCodDiv,;
                                          dFecha,;
                                          aIva[ n, 3 ],;
                                          ,;
                                          ,;
                                          cConcepto,;
                                          Round( nPReq( dbfIva, aIva[ n, 1 ] ) * ( aIva[ n, 4 ] ) / 100, nRouDiv ),;
                                          cAlbaran,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )
            end if

         next

      end if

      /*
      Ponemos el albaran como contabilizado
      --------------------------------------------------------------------------
      */

      if !lSimula

         if ( dbfAlbCliT )->( dbRLock() )
            ( dbfAlbCliT )->lContab := .t.
            ( dbfAlbCliT )->( dbUnLock() )
         end if

         oTree:Select( oTree:Add( "Albaran cliente : " + rtrim( nAlbaran ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 0 ) )

      else

         if lMessage
            lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv )
         end if

      end if

   end if

   CloseDiario()

   if oBrw != NIL
      oBrw:refresh()
   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

/*
Realiza asientos en Contaplus, partiendo de la factura
*/

FUNCTION CntFacRec2( lSimula, lPago, lExcCnt, lMessage, oTree, nAsiento, aSimula, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfCli, dbfDiv, dbfArt, dbfFPago, dbfIva, oNewImp, oBrw )

   local n
   local nIva
   local cCtaVent
   local nPos
   local dFecha
   local ptaDebe
   local cConcepto
   local cSubCtaIva
   local cSubCtaReq
   local cSubCtaTrn
   local cSubCtaIvm
   local nImpDet
   local nImpTrn
   local nImpPnt
   local nImpIva
   local nImpIvm
   local cRuta
   local nDouDiv
   local nRouDiv
   local nDpvDiv
   local nOrdAnt
   local nAcuAnt     := 0
   local nTotAnt     := 0
   local aIva        := {}
   local uIva 
   local aTrn        := {}
   local aIvm        := {}
   local nCalculo    := 0
   local nBase       := 0
   local aVentas     := {}
   local lIvaInc     := ( dbfFacRecT )->lIvaInc
   local cCodDiv     := ( dbfFacRecT )->cDivFac
   local cCtaCli     := cCliCta( ( dbfFacRecT )->cCodCli, dbfCli )
   local cCtaCliVta  := cCliCtaVta( ( dbfFacRecT )->cCodCli, dbfCli )
   local cCtaAnticipo:= cCtaAnt()
   local nFactura    := ( dbfFacRecT )->cSerie + str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac
   local cFactura    := ( dbfFacRecT )->cSerie + alltrim( str( ( dbfFacRecT )->nNumFac ) )
   local pFactura    := ( dbfFacRecT )->cSerie + "/" + alltrim( str( ( dbfFacRecT )->nNumFac ) ) + "/" + ( dbfFacRecT )->cSufFac
   local lRecargo    := ( dbfFacRecT )->lRecargo
   local lErrorFound := .f.
   local cTerNif     := ( dbfFacRecT )->cDniCli
   local cTerNom     := ( dbfFacRecT )->cNomCli
   local cCodEmp     := cCodEmpCnt( ( dbfFacRecT )->cSerie )
   local cCodPro     := ( dbfFacRecT )->cCodPro
   local cProyecto
   local cClave
   local lReturn

   DEFAULT lSimula   := .t.
   DEFAULT nAsiento  := 0
   DEFAULT aSimula   := {}

   nDouDiv           := nDouDiv( (dbfFacRecT)->CDIVFAC, dbfDiv )
   nRouDiv           := nRouDiv( (dbfFacRecT)->CDIVFAC, dbfDiv )
   nDpvDiv           := nDpvDiv( (dbfFacRecT)->CDIVFAC, dbfDiv )

   cProyecto         := Left( cCodPro, 3 )
   cClave            := Right( cCodPro, 6 )

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
   --------------------------------------------------------------------------
   */

   cRuta             := cRutCnt()

   if !chkEmpresaAsociada( cCodEmp )
      oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " no se definierón empresas asociadas.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkFecha( cRuta, cCodEmp, ( dbfFacRecT )->dFecFac, .f., oTree, "Factura rectificativa de cliente : " + rtrim( pFactura ) )
      lErrorFound    := .t.
   end if

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if ( dbfFacRecT )->lContab
      oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Preparamos los apuntes de cliente
   ----------------------------------------------------------------------------
   */

   if Empty( cCtaCli )
      cCtaCli        := cCtaSin()
   end if

   if Empty( cCtaCliVta )
      cCtaCliVta     := cCtaCli()
   end if

   /*
   Estudio de los Articulos de una factura
   ----------------------------------------------------------------------------
   */

   if ( dbfFacRecL )->( dbSeek( nFactura ) )

      while ( ( dbfFacRecL )->cSerie + str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac == nFactura .and. !( dbfFacRecL )->( eof() ) )

         if !( dbfFacRecL )->lControl                             .and.;
            !( dbfFacRecL )->lTotLin                              .and.;
            lValLine( dbfFacRecL )                                .and.;
            nTotLFacRec( dbfFacRecL, nDouDiv, nRouDiv, nil, .t., .f., .f. ) != 0

            if ( lExcCnt == nil                                   .or.;          // Entran todos
               ( lExcCnt .and. ( dbfFacRecL )->nCtlStk != 2 )     .or.;          // Articulos sin contadores
               ( !lExcCnt .and. ( dbfFacRecL )->nCtlStk == 2 ) )                 // Articulos con contadores

               nIva        := ( dbfFacRecL )->nIva
               nImpDet     := nTotLFacRec( dbfFacRecL, nDouDiv, nRouDiv, nil, .t., .f., .f. )
               nImpIvm     := nTotIFacRec( dbfFacRecL, nDouDiv, nRouDiv )
               nImpTrn     := nTrnLFacRec( dbfFacRecL, nDouDiv, nRouDiv )                 // Portes
               nImpPnt     := nPntLFacRec( dbfFacRecL, nDpvDiv )
               nImpIva     := nIvaLFacRec( dbfFacRecL, nDouDiv, nRouDiv ) 

               cCtaVent    := RetCtaVta( ( dbfFacRecL )->cRef, ( nImpDet < 0 ), dbfArt )
               if Empty( cCtaVent )
                  cCtaVent := cCtaCliVta + RetGrpVta( ( dbfFacRecL )->cRef, cRuta, cCodEmp, dbfArt, nIva )
               end if

               /*
               Cuentas de ventas--------------------------------------------------
               */

               // if nImpDet != 0 .or. nImpPnt != 0 .or. nImpTrn != 0

                  nPos        := aScan( aVentas, {|x| x[ 1 ] == cCtaVent .and. x[ 2 ] == nIva } )
                  if nPos  == 0
                     aAdd( aVentas, { cCtaVent, nIva, nImpDet, nImpPnt, nImpTrn, nImpIva } )
                  else
                     aVentas[ nPos, 3 ]   += nImpDet
                     aVentas[ nPos, 4 ]   += nImpPnt
                     aVentas[ nPos, 5 ]   += nImpTrn
                     aVentas[ nPos, 6 ]   += nImpIva
                  end if

                  /*
                  Construimos las bases de los impuestosS
                  */

                  if isIVAComunidadEconomicaEuropea( dbfFacRecT )
                     cSubCtaIva  := uFieldEmpresa( "cCtaCeeRpt" )
                     cSubCtaReq  := uFieldEmpresa( "cCtaCeeSpt" )
                  else
                     cSubCtaIva  := cSubCuentaIva( nIva, ( dbfFacRecT )->lRecargo, cRuta, cCodEmp, dbfIva )
                     cSubCtaReq  := cSubCuentaRecargo( nIva, ( dbfFacRecT )->lRecargo, cRuta, cCodEmp, dbfIva )
                  end if

                  if uFieldEmpresa( "lIvaImpEsp" )
                     nImpDet     += nImpIvm
                  end if

                  nPos           := aScan( aIva, {|x| x[ 1 ] == nIva } )
                  if nPos  == 0
                     aAdd( aIva, { nIva, cSubCtaIva, cSubCtaReq, nImpDet, nImpPnt, nImpTrn, 0 } )
                  else
                     aIva[ nPos, 4 ] += nImpDet
                     aIva[ nPos, 5 ] += nImpPnt
                     aIva[ nPos, 6 ] += nImpTrn
                  end if

                  /*
                  transportes--------------------------------------------------------
                  */

                  if nImpTrn != 0

                     cSubCtaTrn  := RetCtaTrn( ( dbfFacRecL )->cRef, dbfArt )

                     nPos        := aScan( aTrn, {|x| x[1] == cSubCtaTrn } )
                     if nPos == 0
                        aAdd( aTrn, { cSubCtaTrn, nImpTrn } )
                     else
                        aTrn[ nPos, 2 ] += nImpTrn
                     end if

                  end if

                  /*
                  impuesto especiales---------------------------------------------------
                  */

                  nImpIvm        := nTotIFacRec( dbfFacRecL, nDouDiv, nRouDiv )

                  if nImpIvm != 0

                     cSubCtaIvm  := oNewImp:cCtaImp( ( dbfFacRecL )->nValImp )

                     nPos        := aScan( aIvm, {|x| x[1] == cSubCtaIvm } )
                     if nPos == 0
                        aAdd( aIvm, { cSubCtaIvm, nImpIvm } )
                     else
                        aIvm[ nPos, 2 ] += nImpIvm
                     end if

                  end if

               // end if

            end if

         end if

         SysRefresh()

         ( dbfFacRecL )->( dbSkip() )

      end while

   else

      oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " factura sin artículos.", 0 ) )
      lErrorFound := .t.

   end if

   /*
   Descuentos sobres grupos de Venta
   --------------------------------------------------------------------------
   */

   for n := 1 to Len( aVentas )

      if ( dbfFacRecT )->nDtoEsp != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfFacRecT )->nDtoEsp / 100, nRouDiv )
      end if

      if ( dbfFacRecT )->nDpp != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfFacRecT )->nDpp / 100, nRouDiv )
      end if

      if ( dbfFacRecT )->nDtoUno != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfFacRecT )->nDtoUno / 100, nRouDiv )
      end if

      if ( dbfFacRecT )->nDtoDos != 0
         aVentas[ n, 3 ] -= Round( aVentas[ n, 3 ] * ( dbfFacRecT )->nDtoDos / 100, nRouDiv )
      end if

   next

   /*
   Despues de aplicar los descuentos le sumamos el punto verde-----------------
   */

   for n := 1 to Len( aVentas )
      aVentas[ n, 3 ] += aVentas[ n, 4 ]
   next

   /*
   Descuentos sobres grupos de impuestos
   ----------------------------------------------------------------------------
   */

   for n := 1 to Len( aIva )

      if ( dbfFacRecT )->nDtoEsp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacRecT )->nDtoEsp / 100, nRouDiv )
      end if

      if ( dbfFacRecT )->nDpp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacRecT )->nDpp / 100, nRouDiv )
      end if

      if ( dbfFacRecT )->nDtoUno != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacRecT )->nDtoUno / 100, nRouDiv )
      end if

      if ( dbfFacRecT )->nDtoDos != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacRecT )->nDtoDos / 100, nRouDiv )
      end if

   next

   /*
   Despues de aplicar los descuentos le sumamos el punto verde-----------------
   */

   for n := 1 to Len( aIva )
      aIva[ n, 4 ]   += aIva[ n, 5 ]
   next

   //construimos las bases de los impuestos

   for each uIva in aIva
      if isIVAComunidadEconomicaEuropea( dbfFacRecT )
         uIva[1] := 0
         uIva[2] := cCuentaVentaIVARepercutidoUE()
         uIva[3] := cCtaCli
      elseif isIVAExportacionFueraUE( dbfFacRecT )
         uIva[1] := 0
         uIva[2] := cCuentaVentaIVARepercutidoFueraUE()
         uIva[3] := cCtaCli
      end if 
   next

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " subcuenta " + cCtaCli + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Creacion y chequeo de Cuentas de impuestos
   --------------------------------------------------------------------------
   */

   for n := 1 to len( aIva )

      if !ChkSubcuenta( cRutCnt(), cCodEmp, aIva[ n, 2 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " subcuenta " + aIva[ n, 2 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if

      if lRecargo .and. !ChkSubcuenta( cRutCnt(), cCodEmp, aIva[ n, 3 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " subcuenta " + aIva[ n, 3 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if

   next

   for n := 1 to len( aVentas )
      if !ChkSubcuenta( cRuta, cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   for n := 1 to len( aIvm )
      if !lSimula .and. !ChkSubcuenta( cRuta, cCodEmp, aIvm[ n, 1 ], , .f., .f. )
         oTree:Add( "Factura rectificativa de cliente : " + rtrim( nFactura ) + " subcuenta " + aIvm[ n, 1 ] + " no encontada.", 0 )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeo de Cuentas de Transportes
   --------------------------------------------------------------------------
   */

   for n := 1 to len( aTrn )
      if !ChkSubcuenta( cRuta, cCodEmp, aTrn[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " subcuenta " + aTrn[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeamos los anticipos-------------------------------------------------
   */

   if nTotAnt != 0 .and. !ChkSubcuenta( cRuta, cCodEmp, cCtaAnticipo, , .f., .f. )
      oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " subcuenta de anticipo " + cCtaAnticipo + " no encontada.", 0 ) )
      lErrorFound := .t.
   end if

   if lSimula .or. !lErrorFound

      /*
      Datos comunes a todos los Asientos
      --------------------------------------------------------------------------
      */

      dFecha      := ( dbfFacRecT )->dFecFac
      ptaDebe     := nTotFacRec( ( dbfFacRecT )->cSerie + str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac, dbfFacRecT, dbfFacRecL, dbfIva, dbfDiv, nil, nil, .f., lExcCnt  )
      cConcepto   := "N/Rect. N." + ( dbfFacRecT )->cSerie + "/" + alltrim( str( ( dbfFacRecT )->nNumFac ) + "/" + ( dbfFacRecT )->cSufFac )

      /*
      Realización de Asientos
      --------------------------------------------------------------------------
      */

      if OpenDiario( , cCodEmp )
         nAsiento := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Factura rectificativa de cliente : " + rtrim( pFactura ) + " imposible abrir ficheros.", 0 ) )
         return .f.
      end if

      /*
      Asiento de cliente----------------------------------------------------------
      */

      aadd( aSimula, MkAsiento(  nAsiento, ;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaCli,;                           // Cuenta
                                 ,;                                  // Contrapartida
                                 Round( ptaDebe, nRouDiv ),;         // Ptas. Debe
                                 cConcepto,;
                                 ,;                                  // Ptas. Haber
                                 cFactura,;
                                 ,;                                  // Base Imponible
                                 ,;
                                 ,;
                                 ,;
                                 cProyecto,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Ventas
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aVentas )

         if lIvaInc

         nCalculo    := Round( aVentas[ n, 3 ], nRouDiv )

         if aVentas[ n, 2 ] != 0
            nCalculo -= Round( aVentas[ n, 3 ] / ( 100 / aVentas[ n, 2 ] + 1 ), nRouDiv )
         end if

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aVentas[ n, 1 ],;                      // Cuenta
                                    ,;                                     // Contrapartida
                                    ,;                                     // Ptas. Debe
                                    cConcepto,;
                                    nCalculo,;                             // Ptas. Haber
                                    cFactura,;
                                    ,;                                     // Base Imponible
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    .t.,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

         else

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aVentas[ n, 1 ],;                      // Cuenta
                                    ,;                                     // Contrapartida
                                    ,;                                     // Ptas. Debe
                                    cConcepto,;
                                    Round( aVentas[ n, 3 ], nRouDiv ),;    // Ptas. Haber
                                    cFactura,;
                                    ,;                                     // Base Imponible
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    .t.,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

         end if

      next

      /*
      Asientos de anticipo
      -------------------------------------------------------------------------
      */

      if nTotAnt != 0

      aadd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaAnticipo,;                            // Cuenta
                                 ,;                                        // Contrapartida
                                 nAcuAnt,;                                 // Ptas. Debe
                                 cConcepto,;
                                 ,;                                        // Ptas. Haber
                                 cFactura,;
                                 ,;                                        // Base Imponible
                                 ,;
                                 ,;
                                 ,;
                                 cProyecto,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      end if

      /*
      Asientos de transporte
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aTrn )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aTrn[ n, 1 ],;                         // Cuenta
                                    ,;                                     // Contrapartida
                                    ,;                                     // Ptas. Debe
                                    cConcepto,;
                                    Round( aTrn[ n, 2 ], nRouDiv ),;       // Ptas. Haber
                                    cFactura,;
                                    ,;                                     // Base Imponible
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de impuestos
      --------------------------------------------------------------------------
      */

      for n := 1 to len( aIva )

         nBase          := Round( aIva[ n, 4 ], nRouDiv ) + Round( aIva[ n, 7 ], nRouDiv )

         if lIvaInc

            if aIva[ n, 1 ] != 0
               nCalculo := Round( aIva[ n, 4 ] / ( 100 / aIva[ n, 1 ] + 1 ), nRouDiv )
               nCalculo += Round( aIva[ n, 7 ] / ( 100 / aIva[ n, 1 ] + 1 ), nRouDiv )
            else
               nCalculo := 0
            end if

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aAdd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv, ;
                                          dFecha, ;
                                          aIva[ n, 2 ],;                         // Cuenta de impuestos
                                          if( isIVAComunidadEconomicaEuropea( dbfFacRecT ), aIva[ n, 3 ], cCtaCli ),; // Contrapartida
                                          ,;                                     // Ptas. Debe
                                          cConcepto,;
                                          nCalculo,;                             // Ptas. Haber
                                          cFactura,;
                                          nBase - nCalculo,;                     // Base Imponible
                                          Round( aIva[ n, 1 ], nRouDiv ),;
                                          If( lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), ),;
                                          ,;
                                          cProyecto,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         else

            nCalculo    := Round( aIva[ n, 4 ] * aIva[ n, 1 ] / 100, nRouDiv )
            nCalculo    += Round( aIva[ n, 7 ] * aIva[ n, 1 ] / 100, nRouDiv )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv, ;
                                          dFecha, ;
                                          aIva[ n, 2 ],;                            // Contrapartida
                                          if( isIVAComunidadEconomicaEuropea( dbfFacRecT ), aIva[ n, 3 ], cCtaCli ),;    // Contrapartida
                                          ,;                                        // Ptas. Debe
                                          cConcepto,;
                                          nCalculo,;                                // Ptas. Haber
                                          cFactura,;
                                          nBase,;                                   // Base Imponible
                                          Round( aIva[ n, 1 ], nRouDiv ),;
                                          If( lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), ),;
                                          ,;
                                          cProyecto,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         end if

      next

      /*
      Asientos de IVM
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aIvm )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aIvm[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aIvm[ n, 2 ], nRouDiv ),;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula ) )

      next

      /*
      Asientos del Recargo
      -------------------------------------------------------------------------
      */

      if lRecargo

         for n := 1 TO len( aIva )

            if Round( nPReq( dbfIva, aIva[ n, 1 ] ) * ( aIva[ n, 4 ] ) / 100, nRouDiv ) != 0

               aadd( aSimula, MkAsiento(  nAsiento,;
                                          cCodDiv,;
                                          dFecha,;
                                          aIva[ n, 3 ],;                                                                // Contrapartida
                                          ,;                                                                            // Cuenta de impuestos
                                          ,;                                                                            // Ptas. Debe
                                          cConcepto,;
                                          Round( nPReq( dbfIva, aIva[ n, 1 ] ) * ( aIva[ n, 4 ] ) / 100, nRouDiv ),;    // Ptas. Haber
                                          cFactura,;
                                          ,;                                                                            // Base Imponible
                                          ,;
                                          ,;
                                          ,;
                                          cProyecto,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )
            end if

         next

      end if

   end if

   /*
   Contabilizamos los pagos
   ----------------------------------------------------------------------------
   */

   nOrdAnt  := ( dbfFacCliP )->( OrdSetFocus( "rNumFac" ) )

   if lPago .and. ( dbfFacCliP )->( dbSeek( nFactura ) )

      while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == nFactura ) .and. !( dbfFacCliP )->( eof() )

         lReturn  := ContabilizaReciboCliente( oBrw, oTree, lSimula, aSimula, dbfFacRecT, dbfFacCliP, dbfFPago, dbfCli, dbfDiv, .t., nAsiento )

         if IsFalse( lReturn )
            exit
         end if

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

   ( dbfFacCliP )->( OrdSetFocus( nOrdAnt ) )

   /*
   Ponemos la factura como Contabilizada
   ----------------------------------------------------------------------------
   */

   if !lSimula .and. !lErrorFound

      lReturn     := lCntFacRec( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacRecT )

   else

      if lMessage
         lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, pFactura, {|| aWriteAsiento( aSimula, cCodDiv, lMessage, oTree, pFactura, nAsiento ), lCntFacRec( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacRecT, dbfFacCliP ) } )
      end if

   end if

   /*
   Cerramos las tablas de contaplus--------------------------------------------
   */

   CloseDiario()

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//

Static Function lCntFacRec( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacRecT, dbfFacCliP )

   /*
   Ponemos el ticket como contabilizado
   ----------------------------------------------------------------------------
   */

   if ( dbfFacRecT )->( dbRLock() )
      ( dbfFacRecT )->lContab := .t.
      ( dbfFacRecT )->( dbUnLock() )
   end if

   oTree:Select( oTree:Add( "Factura rectificativa : " + rtrim( pFactura ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 ) )

   if !Empty( dbfFacCliP )

      if lPago .and. ( dbfFacCliP )->( dbSeek( nFactura ) )

         while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == nFactura ) .and. !( dbfFacCliP )->( eof() )

            lContabilizaReciboCliente( nil, nil, .t., oTree, dbfFacCliP )

            ( dbfFacCliP )->( dbSkip() )

         end while

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

/*
Realiza asientos en Contaplus, partiendo de la factura
*/

FUNCTION CntFacPrv( lSimula, lPago, lMessage, oTree, nAsiento, aSimula, dbfFacPrvT, dbfFacPrvL, dbfFacPrvP, dbfPrv, dbfDiv, dbfArticulo, dbfFPago, dbfIva, oBrw )

   local n
   local nOrd
   local cCtaVent
   local nPosicion
   local nPosIva
   local dFecha
   local aTotFac
   local nTotFac
   local nTotRet
   local aTotIva
   local cConcepto
   local cConCompr
   local cSubCtaIva
   local cSubCtaReq
   local cRuta
   local cCodEmp
   local nImpDeta
   local nDinDiv     := nDinDiv( ( dbfFacPrvT )->cDivFac, dbfDiv )
   local nRinDiv     := nRinDiv( ( dbfFacPrvT )->cDivFac, dbfDiv )
   local aIva        := {}
   local aVentas     := {}
   local cCodDiv     := ( dbfFacPrvT )->cDivFac
   local cCtaPrv     := cPrvCta( ( dbfFacPrvT )->cCodPrv, dbfPrv )
   local cCtaPrvVta  := cPrvCtaVta( ( dbfFacPrvT )->cCodPrv, dbfPrv )
   local nFactura    := ( dbfFacPrvT )->cSerFac + str( ( dbfFacPrvT )->nNumFac ) + ( dbfFacPrvT )->cSufFac
   local cFactura    := ( dbfFacPrvT )->cSerFac + "/" + Ltrim( str( ( dbfFacPrvT )->nNumFac ) ) + "/" + ( dbfFacPrvT )->cSufFac
   local nNumFac     := ( dbfFacPrvT )->nNumFac
   local cCodPro     := Left( ( dbfFacPrvT )->cCodPro, 3 )
   local cClave      := Right( ( dbfFacPrvT )->cCodPro, 6 )
   local lErrorFound := .f.
   local cTerNif     := ( dbfFacPrvT )->cDniPrv
   local cTerNom     := ( dbfFacPrvT )->cNomPrv
   local lReturn

   DEFAULT aSimula   := {}

   /*
   Chequeando antes de pasar a Contaplus
   */

   if ( dbfFacPrvT )->lContab
      oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + ", ya contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Factura proveedor : " + rtrim( cFactura ) + ", ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Chequeamos todos los valores
   */

   cRuta             := cRutCnt()
   cCodEmp           := cCodEmpCnt( ( dbfFacPrvT )->cSerFac )

   if Empty( cCtaPrvVta )
      cCtaPrvVta     := cCtaPrv()
   end if

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaPrv, , .f., .f. )
      oTree:Select( oTree:Add( "Factura proveedor : " + rtrim( cFactura ) + " subcuenta de proveedor " + Rtrim( cCtaPrv ) + ", no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Totales de las facturas
   */

   aTotFac           := aTotFacPrv( nFactura, dbfFacPrvT, dbfFacPrvL, dbfIva, dbfDiv, dbfFacPrvP )
   nTotFac           := aTotFac[ 4 ]
   aTotIva           := aTotFac[ 5 ]
   nTotRet           := aTotFac[ 6 ]

   /*
   Vamos a ver si es una factura de gastos-------------------------------------
   */

   if ( dbfFacPrvT )->lFacGas

      aAdd( aVentas, { ( dbfFacPrvT )->SubCta, aTotFac[ 1 ] } )

      /*
      Construimos las bases de los impuestosS
      */

      for n := 1 to Len( aTotIva )

         if isIVAComunidadEconomicaEuropea( dbfFacPrvT )
            cSubCtaIva  := cCuentaCompraIVASoportadoUE()
            cSubCtaReq  := cCuentaCompraIVARepercutidoUE()
         else
            cSubCtaIva  := cSubCuentaIva(       aTotIva[ n, 3 ], ( dbfFacPrvT )->lRecargo, cRuta, cCodEmp, dbfIva, .f. )
            cSubCtaReq  := cSubCuentaRecargo(   aTotIva[ n, 3 ], ( dbfFacPrvT )->lRecargo, cRuta, cCodEmp, dbfIva )
         end if

         nPosIva        := aScan( aIva, {|x| x[ 1 ] == aTotIva[ n, 3 ] } )
         if nPosIva == 0
            aAdd( aIva, { aTotIva[ n, 3 ], cSubCtaIva, cSubCtaReq, aTotIva[ n, 1 ] } )
         else
            aIva[ nPosIva, 4 ]   += aTotIva[ n, 1 ]
         end if

      next

   else

      /*
      Estudio de los Articulos de una factura----------------------------------
      */

      if ( dbfFacPrvL )->( dbSeek( nFactura ) )

         while ( ( dbfFacPrvL )->cSerFac + str( ( dbfFacPrvL )->nNumFac ) + ( dbfFacPrvL )->cSufFac == nFactura .and. !( dbfFacPrvL )->( eof() ) )

            nImpDeta       := nTotLFacPrv( dbfFacPrvL, nDinDiv, nRinDiv ) // , ( dbfFacPrvT )->nVdvFac )

            if nImpDeta != 0

               cCtaVent    := RetCtaCom( ( dbfFacPrvL )->cRef, ( nImpDeta < 0 ), dbfArticulo )
               if Empty( cCtaVent )
                  cCtaVent := cCtaPrvVta + RetGrpVta( ( dbfFacPrvL )->cRef, cRuta, cCodEmp, dbfArticulo, ( dbfFacPrvL )->nIva )
               end if

               nPosicion   := aScan( aVentas, {|x| x[1] == cCtaVent } )

               if nPosicion == 0
                  aadd( aVentas, { cCtaVent, nImpDeta } )
               else
                  aVentas[ nPosicion, 2 ] += nImpDeta
               end if

               /*
               Construimos las bases de los impuestos--------------------------
               */

               if isIVAComunidadEconomicaEuropea( dbfFacPrvT )
                  cSubCtaIva  := cCuentaCompraIVASoportadoUE()
                  cSubCtaReq  := cCuentaCompraIVARepercutidoUE()
               else
                  cSubCtaIva  := cSubCuentaIva( ( dbfFacPrvL )->nIva, ( dbfFacPrvT )->lRecargo, cRuta, cCodEmp, dbfIva, .f. )
                  cSubCtaReq  := cSubCuentaRecargo( ( dbfFacPrvL )->nIva, ( dbfFacPrvT )->lRecargo, cRuta, cCodEmp, dbfIva )
               end if

               nPosIva        := aScan( aIva, {|x| x[1] == ( dbfFacPrvL )->nIva } )
               if nPosIva == 0
                  aadd( aIva, { ( dbfFacPrvL )->nIva, cSubCtaIva, cSubCtaReq, nImpDeta } )
               else
                  aIva[ nPosIva, 4 ]   += nImpDeta
               end if

            end if

            ( dbfFacPrvL )->( dbSkip() )

         end while

      else

         oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + " factura sin artículos.", 0 ) )

         lErrorFound    := .t.

      end if

   end if

   /*
   Descuentos sobres grupos de Venta-------------------------------------------
   */

   for n := 1 TO Len( aVentas )

      if ( dbfFacPrvT )->nDtoEsp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfFacPrvT )->nDtoEsp / 100, nRinDiv )
      end if

      if ( dbfFacPrvT )->nDpp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfFacPrvT )->nDpp / 100, nRinDiv )
      end if

      if ( dbfFacPrvT )->nDtoUno != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfFacPrvT )->nDtoUno / 100, nRinDiv )
      end if

      if ( dbfFacPrvT )->nDtoDos != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfFacPrvT )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Descuentos sobres grupos de impuestos
   */

   for n := 1 to Len( aIva )

      if ( dbfFacPrvT )->nDtoEsp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacPrvT )->nDtoEsp / 100, nRinDiv )
      end if

      if ( dbfFacPrvT )->nDpp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacPrvT )->nDpp / 100, nRinDiv )
      end if

      if ( dbfFacPrvT )->nDtoUno != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfFacPrvT )->nDtoUno / 100, nRinDiv )
      end if

      if ( dbfFacPrvT )->nDtoDos != 0
         aIva[ n, 2 ] -= Round( aIva[ n, 4 ] * ( dbfFacPrvT )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Chequeo de Cuentas de Ventas------------------------------------------------
   */

   for n := 1 TO len( aVentas )
      if !ChkSubcuenta( cRutCnt(), cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura proveedor : " + rtrim( cFactura ) + " subcuenta de ventas " + aVentas[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound    := .t.
      end if
   next

   /*
   Chequeo de Cuentas de impuestos---------------------------------------------------
   */

   for n := 1 to len( aIva )

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 2 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + " subcuenta de " + cImp() + " " + aIva[ n, 2 ] + ", no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 3 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + " subcuenta de " + cImp() + " " + aIva[ n, 3 ] + ", no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

   next

   if nTotRet != 0

      if !ChkSubcuenta( cRuta, cCodEmp, cCtaRet(), , .f., .f. )
         oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + " subcuenta de retenciones " + cCtaRet() + ", no encontada.", 0 ) )
         lErrorFound    := .t.
      end if

   end if

   /*
   Comprobamos fechas----------------------------------------------------------
   */

   if !ChkFecha( cRuta, cCodEmp, ( dbfFacPrvT )->dFecFac, .f. )
      oTree:Select( oTree:Add(  "Factura proveedor : " + Rtrim( cFactura ) + " asiento fuera de fechas.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Datos comunes a todos los Asientos------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if Empty( ( dbfFacPrvT )->dFecEnt )
         dFecha      := ( dbfFacPrvT )->dFecFac
      else
         dFecha      := ( dbfFacPrvT )->dFecEnt
      end if

      cConCompr      := "S/Fcta."
      if !Empty( ( dbfFacPrvT )->cSuPed )
         nNumFac     := Val( ( dbfFacPrvT )->cSuPed )
         cConCompr   += " N." + Rtrim( ( dbfFacPrvT )->cSuPed )
      elseif !Empty( ( dbfFacPrvT )->cNumDoc )
         cConCompr   += " Doc. " + Rtrim( ( dbfFacPrvT )->cNumDoc )
      else
         cConCompr   += " N." + Rtrim( cFactura )
      end if
      cConcepto      := cConCompr + Space( 1 ) + DtoC( ( dbfFacPrvT )->dFecFac )
      cConCompr      += Space( 1 ) + Rtrim( ( dbfFacPrvT )->cNomPrv )

      /*
      Realizaci¢n de Asientos-----------------------------------------------------
      */

      if OpenDiario( , cCodEmp )
         nAsiento    := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + " imposible abrir ficheros de contaplus.", 0 ) )
         return .f.
      end if

      /*
      Asiento de Proveedor________________________________________________________
      */

      aAdd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaPrv,;
                                 ,;
                                 ,;
                                 cConcepto,;
                                 nTotFac,;
                                 nNumFac,;
                                 ,;
                                 ,;
                                 ,;
                                 ( dbfFacPrvT )->cNumDoc,;
                                 cCodPro,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Compras_________________________________________________________
      */

      for n := 1 TO len( aVentas )

         aAdd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    aVentas[ n, 2 ],;
                                    cConCompr,;
                                    ,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( dbfFacPrvT )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      // Asientos de iva regimen general_____________________________________________________________

      if isIVARegimenGeneralCompras( dbfFacPrvT )

         for n := 1 to len( aIva )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv,;
                                          dFecha, ;
                                          aIva[ n, 2 ],;    // Cuenta de impuestos
                                          cCtaPrv,;         // Contrapartida
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),;
                                          cConCompr,;
                                          ,;                // Ptas. Haber
                                          nNumFac,;
                                          aIva[ n, 4 ],;
                                          aIva[ n, 1 ],;
                                          If( ( dbfFacPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                          ( dbfFacPrvT )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         next

      end if 

      // Asiento de IVA CEE----------------------------------------------------

      if isIVAComunidadEconomicaEuropea( dbfFacPrvT )

         for n := 1 to len( aIva )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

/*
               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv,;
                                          dFecha, ;
                                          aIva[ n, 3 ],;                                        // Cuenta de impuestos
                                          aIva[ n, 2 ],;                                        // Contrapartida
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Debe
                                          cConCompr,;
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Haber
                                          nNumFac,;
                                          aIva[ n, 4 ],;
                                          aIva[ n, 1 ],;
                                          If( ( dbfFacPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                          ( dbfFacPrvT )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )
*/
               
               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv,;
                                          dFecha, ;
                                          aIva[ n, 3 ],;                                        // Cuenta de impuestos
                                          cCtaPrv,;                                             // Contrapartida
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Debe
                                          cConCompr,;
                                          0,;                                                   // Ptas. Haber
                                          nNumFac,;
                                          aIva[ n, 4 ],;
                                          aIva[ n, 1 ],;
                                          If( ( dbfFacPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                          ( dbfFacPrvT )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

               aadd( aSimula, MkAsiento(  nAsiento, ;
                                          cCodDiv,;
                                          dFecha, ;
                                          aIva[ n, 2 ],;                                        // Cuenta de impuestos
                                          cCtaPrv,;                                             // Contrapartida
                                          0,;                                                   // Ptas. Debe
                                          cConCompr,;
                                          Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Haber
                                          nNumFac,;
                                          aIva[ n, 4 ],;
                                          aIva[ n, 1 ],;
                                          If( ( dbfFacPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                          ( dbfFacPrvT )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         next

      end if

      // Asientos del Recargo________________________________________________________

      if ( dbfFacPrvT )->lRecargo .and. isIVARegimenGeneralCompras( dbfFacPrvT )

         for n := 1 to len( aIva )

            if aIva[ n, 1 ] != 0 .or. uFieldEmpresa( "lConIva" )

               aadd( aSimula, MkAsiento(  nAsiento,;
                                          cCodDiv,;
                                          dFecha,;
                                          aIva[ n, 3 ],; // Cuenta de impuestos
                                          ,;
                                          Round( nPReq( dbfIva, aIva[ n, 1 ] ) * aIva[ n, 4 ] / 100, nRinDiv ),;
                                          cConCompr,;
                                          ,;
                                          nNumFac,;
                                          ,;
                                          ,;
                                          ,;
                                          ( dbfFacPrvT )->cNumDoc,;
                                          cCodPro,;
                                          cClave,;
                                          ,;
                                          ,;
                                          ,;
                                          lSimula,;
                                          cTerNif,;
                                          cTerNom ) )

            end if

         next

      end if

      /*
      Asientos del retenciones________________________________________________________
      */

      if nTotRet != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaRet(),;   // Cuenta de retencion
                                    ,;
                                    ,;
                                    cConCompr,;
                                    nTotRet,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( dbfFacPrvT )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Contabilizaci¢n de Pagos
      --------------------------------------------------------------------------
      */

      if lPago

         nOrd           := ( dbfFacPrvP )->( ordSetFocus( "nNumFac" ) )

         if ( dbfFacPrvP )->( dbSeek( nFactura ) )

            while ( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac = nFactura ) .and. !( dbfFacPrvP )->( eof() )

               lReturn  := CntRecPrv( lSimula, oTree, nAsiento, aSimula, .t., dbfFacPrvT, dbfFacPrvP, dbfPrv, dbfFPago, dbfDiv )

               if IsFalse( lReturn )
                  exit
               end if

               ( dbfFacPrvP )->( dbSkip() )

            end while

         end if

         ( dbfFacPrvP )->( ordSetFocus( nOrd ) )

      end if

      /*
      Ponemos la factura como Contabilizada---------------------------------------
      */

      if lSimula

         if lMessage
            lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cFactura, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cFactura, nAsiento ), lCntFacPrv( .t., dbfFacPrvT ) } )
         end if

      else

         if !lErrorFound

            lReturn  := lCntFacPrv( .t., dbfFacPrvT )

            if lReturn .and. !Empty( oTree )
               oTree:Select( oTree:Add( "Factura proveedor : " + Rtrim( cFactura ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 ) )
            end if

         end if

      end if

      CloseDiario()

   end if

Return ( lReturn )

//---------------------------------------------------------------------------//

Function lCntFacPrv( lContabilizado, dbfFacPrvT )

   local lReturn              := .t.

   if dbLock( dbfFacPrvT )
      ( dbfFacPrvT )->lContab := lContabilizado
      ( dbfFacPrvT )->( dbUnlock() )
   else
      lReturn                 := .f.
   end if

Return ( lReturn )

//-------------------------------------------------------------------------//

FUNCTION CntRctPrv( lSimula, lPago, lMessage, oTree, nAsiento, aSimula, dbfRctPrvT, dbfRctPrvL, dbfFacPrvP, dbfPrv, dbfDiv, dbfArticulo, dbfFPago, dbfIva, oBrw )

   local n
   local cCtaVent
   local nPosicion
   local nPosIva
   local dFecha
   local aTotFac
   local nTotFac
   local nTotRet
   local cConcepto
   local cConCompr
   local cSubCtaIva
   local cSubCtaReq
   local cRuta
   local cCodEmp
   local nImpDeta
   local nDinDiv     := nDinDiv( ( dbfRctPrvT )->cDivFac, dbfDiv )
   local nRinDiv     := nRinDiv( ( dbfRctPrvT )->cDivFac, dbfDiv )
   local aIva        := {}
   local aVentas     := {}
   local cCodDiv     := ( dbfRctPrvT )->cDivFac
   local cCtaPrv     := cPrvCta( ( dbfRctPrvT )->cCodPrv, dbfPrv )
   local cCtaPrvVta  := cPrvCtaVta( ( dbfRctPrvT )->cCodPrv, dbfPrv )
   local nFactura    := ( dbfRctPrvT )->cSerFac + str( ( dbfRctPrvT )->nNumFac ) + ( dbfRctPrvT )->cSufFac
   local cFactura    := ( dbfRctPrvT )->cSerFac + "/" + Ltrim( str( ( dbfRctPrvT )->nNumFac ) ) + "/" + ( dbfRctPrvT )->cSufFac
   local nNumFac     := ( dbfRctPrvT )->nNumFac
   local cCodPro     := Left( ( dbfRctPrvT )->cCodPro, 3 )
   local cClave      := Right( ( dbfRctPrvT )->cCodPro, 6 )
   local lErrorFound := .f.
   local cTerNif     := ( dbfRctPrvT )->cDniPrv
   local cTerNom     := ( dbfRctPrvT )->cNomPrv
   local lReturn

   DEFAULT aSimula   := {}

   /*
   Chequeando antes de pasar a Contaplus
   */

   IF ( dbfRctPrvT )->lContab
      oTree:Add( "Factura rectificativa proveedor : " + Rtrim( cFactura ) + " ya contabilizada.", 0 )
      lErrorFound    := .t.
   END IF

   IF !ChkRuta( cRutCnt() )
      oTree:Add( "Factura rectificativa proveedor : " + rtrim( cFactura ) + " ruta no valida.", 0 )
      lErrorFound    := .t.
   END IF

   /*
   Chequeamos todos los valores
   */

   cRuta             := cRutCnt()
   cCodEmp           := cCodEmpCnt( ( dbfRctPrvT )->cSerFac )

   if Empty( cCtaPrvVta )
      cCtaPrvVta     := cCtaPrv()
   end if

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaPrv, , .f., .f. )
      oTree:Add( "Factura rectificativa proveedor : " + rtrim( cFactura ) + " subcuenta " + cCtaPrv + " no encontada.", 0 )
      lErrorFound    := .t.
   end if

   /*
   Totales de las facturas
   */

   aTotFac           := aTotRctPrv( nFactura, dbfRctPrvT, dbfRctPrvL, dbfIva, dbfDiv, dbfFacPrvP )
   nTotFac           := aTotFac[ 4 ]
   nTotRet           := aTotFac[ 6 ]

   /*
   Estudio de los Articulos de una factura
   */

   if ( dbfRctPrvL )->( dbSeek( nFactura ) )

      while ( ( dbfRctPrvL )->cSerFac + str( ( dbfRctPrvL )->nNumFac ) + ( dbfRctPrvL )->cSufFac == nFactura .and. !( dbfRctPrvL )->( eof() ) )

         nImpDeta    := nTotLRctPrv( dbfRctPrvL, nDinDiv, nRinDiv, ( dbfRctPrvT )->nVdvFac )

         if nImpDeta != 0

            cCtaVent := RetCtaCom( ( dbfRctPrvL )->cRef, ( nImpDeta < 0 ), dbfArticulo )
            if Empty( cCtaVent )
               cCtaVent := cCtaPrvVta + RetGrpVta( ( dbfRctPrvL )->cRef, cRuta, cCodEmp, dbfArticulo, ( dbfRctPrvL )->nIva )
            end if

            nPosicion   := aScan( aVentas, {|x| x[1] == cCtaVent } )
            if nPosicion == 0
               aadd( aVentas, { cCtaVent, nImpDeta } )
            else
               aVentas[ nPosicion, 2 ] += nImpDeta
            end if

            /*
            Construimos las bases de los impuestosS
            */

            if isIVAComunidadEconomicaEuropea( dbfRctPrvT )
               cSubCtaIva  := cCuentaCompraIVASoportadoUE()
               cSubCtaReq  := cCuentaCompraIVARepercutidoUE()
            else
               cSubCtaIva  := cSubCuentaIva( ( dbfRctPrvL )->nIva, ( dbfRctPrvT )->lRecargo, cRuta, cCodEmp, dbfIva, .f. )
               cSubCtaReq  := cSubCuentaRecargo( ( dbfRctPrvL )->nIva, ( dbfRctPrvT )->lRecargo, cRuta, cCodEmp, dbfIva )
            end if

            nPosIva     := aScan( aIva, {|x| x[1] == ( dbfRctPrvL )->nIva } )
            if nPosIva == 0
               aadd( aIva, { ( dbfRctPrvL )->nIva, cSubCtaIva, cSubCtaReq, nImpDeta } )
            else
               aIva[ nPosIva, 4 ]   += nImpDeta
            end if

         end if

         ( dbfRctPrvL )->( dbSkip() )

      end while

   else

      oTree:Add( "Factura rectificativa proveedor : " + rtrim( cFactura ) + " factura sin artículos.", 0 )
      lErrorFound    := .t.

   end if

   /*
   Descuentos sobres grupos de Venta
   */

   for n := 1 to Len( aVentas )

      if ( dbfRctPrvT )->nDtoEsp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfRctPrvT )->nDtoEsp / 100, nRinDiv )
      end if

      if ( dbfRctPrvT )->nDpp != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfRctPrvT )->nDpp / 100, nRinDiv )
      end if

      if ( dbfRctPrvT )->nDtoUno != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfRctPrvT )->nDtoUno / 100, nRinDiv )
      end if

      if ( dbfRctPrvT )->nDtoDos != 0
         aVentas[ n, 2 ] -= Round( aVentas[ n, 2 ] * ( dbfRctPrvT )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Descuentos sobres grupos de impuestos
   */

   for n := 1 to Len( aIva )

      if ( dbfRctPrvT )->nDtoEsp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfRctPrvT )->nDtoEsp / 100, nRinDiv )
      end if

      if ( dbfRctPrvT )->nDpp != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfRctPrvT )->nDpp / 100, nRinDiv )
      end if

      if ( dbfRctPrvT )->nDtoUno != 0
         aIva[ n, 4 ] -= Round( aIva[ n, 4 ] * ( dbfRctPrvT )->nDtoUno / 100, nRinDiv )
      end if

      if ( dbfRctPrvT )->nDtoDos != 0
         aIva[ n, 2 ] -= Round( aIva[ n, 4 ] * ( dbfRctPrvT )->nDtoDos / 100, nRinDiv )
      end if

   next

   /*
   Chequeo de Cuentas de Ventas------------------------------------------------
   */

   for n := 1 to len( aVentas )

      if !ChkSubcuenta( cRutCnt(), cCodEmp, aVentas[ n, 1 ], , .f., .f. )

         oTree:Add( "Factura rectificativa proveedor : " + rtrim( cFactura ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 )
         lErrorFound    := .t.

      end if

   next

   /*
   Chequeo de Cuentas de impuestos---------------------------------------------------
   */

   for n := 1 to len( aIva )

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 2 ], , .f., .f. )
         oTree:Add( "Factura rectificativa proveedor : " + Rtrim( cFactura ) + " subcuenta " + aIva[ n, 2 ] + " no encontada.", 0 )
         lErrorFound    := .t.
      end if

      if !ChkSubcuenta( cRuta, cCodEmp, aIva[ n, 3 ], , .f., .f. )
         oTree:Add( "Factura rectificativa proveedor : " + Rtrim( cFactura ) + " subcuenta " + aIva[ n, 3 ] + " no encontada.", 0 )
         lErrorFound    := .t.
      end if

   next

   if nTotRet != 0

      if !ChkSubcuenta( cRuta, cCodEmp, cCtaRet(), , .f., .f. )
         oTree:Add( "Factura rectificativa proveedor : " + Rtrim( cFactura ) + " subcuenta " + cCtaRet() + " no encontada.", 0 )
         lErrorFound    := .t.
      end if

   end if

   /*
   Comprobamos fechas----------------------------------------------------------
   */

   if !ChkFecha( , , ( dbfRctPrvT )->dFecFac, .f., oTree )
      lErrorFound    := .t.
   end if

   /*
   Datos comunes a todos los Asientos------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if Empty( ( dbfRctPrvT )->dFecEnt )
         dFecha      := ( dbfRctPrvT )->dFecFac
      else
         dFecha      := ( dbfRctPrvT )->dFecEnt
      end if

      cConCompr      := "S/Rect."
      if !Empty( ( dbfRctPrvT )->cSuPed )
         nNumFac     := Val( ( dbfRctPrvT )->cSuPed )
         cConCompr   += " N." + Rtrim( ( dbfRctPrvT )->cSuPed )
      elseif !Empty( ( dbfRctPrvT )->cNumDoc )
         cConCompr   += " Doc. " + Rtrim( ( dbfRctPrvT )->cNumDoc )
      else
         cConCompr   += " N." + Rtrim( cFactura )
      end if
      cConcepto      := cConCompr + Space( 1 ) + DtoC( ( dbfRctPrvT )->dFecFac )
      cConCompr      += Space( 1 ) + Rtrim( ( dbfRctPrvT )->cNomPrv )

      /*
      Realizaci¢n de Asientos-----------------------------------------------------
      */

      if OpenDiario( , cCodEmp )
         nAsiento    := contaplusUltimoAsiento()
      else
         oTree:Add( "Factura rectificativa proveedor : " + Rtrim( cFactura ) + " imposible abrir ficheros de contaplus.", 0 )
         return .f.
      end if

      /*
      Asiento de Proveedor________________________________________________________
      */

      aAdd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha,;
                                 cCtaPrv,;
                                 ,;
                                 ,;
                                 cConcepto,;
                                 nTotFac,;
                                 nNumFac,;
                                 ,;
                                 ,;
                                 ,;
                                 ( dbfRctPrvT )->cNumDoc,;
                                 cCodPro,;
                                 cClave,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Asientos de Compras_________________________________________________________
      */

      for n := 1 TO len( aVentas )

         aAdd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    aVentas[ n, 1 ],;
                                    ,;
                                    aVentas[ n, 2 ],;
                                    cConCompr,;
                                    ,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( dbfRctPrvT )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next      

      /*
      Asientos de impuestos_____________________________________________________________
      */

      if isIVARegimenGeneralCompras( dbfRctPrvT )

         for n := 1 TO len( aIva )

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       cCodDiv,;
                                       dFecha, ;
                                       aIva[ n, 2 ],;    // Cuenta de impuestos
                                       cCtaPrv,;         // Contrapartida
                                       Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),;
                                       cConCompr,;
                                       ,;                // Ptas. Haber
                                       nNumFac,;
                                       aIva[ n, 4 ],;
                                       aIva[ n, 1 ],;
                                       If( ( dbfRctPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                       ( dbfRctPrvT )->cNumDoc,;
                                       cCodPro,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         next

      end if 

      if isIVAComunidadEconomicaEuropea( dbfRctPrvT )

         for n := 1 to len( aIva )

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       cCodDiv,;
                                       dFecha, ;
                                       aIva[ n, 3 ],;                                        // Cuenta de impuestos
                                       cCtaPrv,;                                             // Contrapartida
                                       Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Debe
                                       cConCompr,;
                                       0,; // Ptas. Haber
                                       nNumFac,;
                                       aIva[ n, 4 ],;
                                       aIva[ n, 1 ],;
                                       If( ( dbfRctPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                       ( dbfRctPrvT )->cNumDoc,;
                                       cCodPro,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       cCodDiv,;
                                       dFecha, ;
                                       aIva[ n, 2 ],;                                        // Cuenta de impuestos
                                       cCtaPrv,;                                             // Contrapartida
                                       0,;                                                   // Ptas. Debe
                                       cConCompr,;
                                       Round( aIva[ n, 1 ] * aIva[ n, 4 ] / 100, nRinDiv ),; // Ptas. Haber
                                       nNumFac,;
                                       aIva[ n, 4 ],;
                                       aIva[ n, 1 ],;
                                       If( ( dbfRctPrvT )->lRecargo, nPReq( dbfIva, aIva[ n, 1 ] ), 0 ),;
                                       ( dbfRctPrvT )->cNumDoc,;
                                       cCodPro,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         next  

      end if  

      /*
      Asientos del Recargo________________________________________________________
      */

      if ( dbfRctPrvT )->lRecargo

         for n := 1 TO len( aIva )

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha,;
                                       aIva[ n, 3 ],; // Cuenta de impuestos
                                       ,;
                                       Round( nPReq( dbfIva, aIva[ n, 1 ] ) * aIva[ n, 4 ] / 100, nRinDiv ),;
                                       cConCompr,;
                                       ,;
                                       nNumFac,;
                                       ,;
                                       ,;
                                       ,;
                                       ( dbfRctPrvT )->cNumDoc,;
                                       cCodPro,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         next

      end if

      /*
      Asientos del retenciones________________________________________________________
      */

      if nTotRet != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaRet(),;   // Cuenta de retencion
                                    ,;
                                    ,;
                                    cConCompr,;
                                    nTotRet,;
                                    nNumFac,;
                                    ,;
                                    ,;
                                    ,;
                                    ( dbfRctPrvT )->cNumDoc,;
                                    cCodPro,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Contabilizaci¢n de Pagos
      --------------------------------------------------------------------------
      */

      if lPago .and. ( dbfFacPrvP )->( dbSeek( nFactura ) )

         while ( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac ) + ( dbfFacPrvP )->cSufFac == nFactura ) .AND.;
               !( dbfFacPrvP )->( eof() )

            lReturn  := CntRecPrv( lSimula, oTree, nAsiento, aSimula, .t., dbfRctPrvT, dbfFacPrvP, dbfPrv, dbfFPago, dbfDiv )

            if IsFalse( lReturn )
               exit
            end if

            ( dbfFacPrvP )->( dbSkip() )

         end while

      end if

      /*
      Ponemos la factura como Contabilizada---------------------------------------
      */

      if lSimula

         if lMessage
            lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cFactura, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cFactura, nAsiento ), lCntRctPrv( .t., dbfRctPrvT ) } )
         end if

      else

         if !lErrorFound

            lReturn  := lCntRctPrv( .t., dbfRctPrvT )

            if lReturn .and. !Empty( oTree )
               oTree:Add( "Factura rectificativa proveedor : " + Rtrim( cFactura ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 )
            end if

         end if

      end if

      CloseDiario()

   end if

Return ( lReturn )

//----------------------------------------------------------------------------//

Function lCntRctPrv( lContabilizado, dbfRctPrvT )

   local lReturn              := .t.

   if dbLock( dbfRctPrvT )
      ( dbfRctPrvT )->lContab := lContabilizado
      ( dbfRctPrvT )->( dbUnlock() )
   else
      lReturn                 := .f.
   end if

Return ( lReturn )

//-------------------------------------------------------------------------//

Function CntRecPrv( lSimula, oTree, nAsiento, aSimula, lFromFactura, dbfFacPrvT, dbfFacPrvP, dbfPrv, dbfFPago, dbfDiv, oBrw )

   local cCodEmp
   local cRuta
   local cConcepto
   local cPagoPrv
   local cCtaPgo
   local dFecha
   local nRecno      := ( dbfFacPrvP )->( Recno() )
   local cCodDiv     := ( dbfFacPrvP )->cDivPgo
   local cCodPgo     := ( dbfFacPrvP )->cCodPgo
   local lConFac     := lConFacPrv( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac, 9 ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT )
   local cCodPrv     := dPrvFacPrv( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac, 9 ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT )
   local cCodPro     := cProFacPrv( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac, 9 ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT )
   local cCtaPrv     := cPrvCta( cCodPrv, dbfPrv )
   local cFactura    := ( dbfFacPrvP )->cSerFac + "/" + Ltrim( str( ( dbfFacPrvP )->nNumFac ) ) + "/" + ( dbfFacPrvP )->cSufFac
   local nRecibo     := ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac, 9 ) + ( dbfFacPrvP )->cSufFac + str( ( dbfFacPrvP )->nNumRec )
   local cRecibo     := ( dbfFacPrvP )->cSerFac + "/" + Ltrim( str( ( dbfFacPrvP )->nNumFac, 9 ) ) + "/" + ( dbfFacPrvP )->cSufFac + "-" + str( ( dbfFacPrvP )->nNumRec )
   local cTerNif     := RetFld( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac, 9 ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT, "cDniPrv" )
   local cTerNom     := ( dbfFacPrvP )->cNomPrv
   local lRectif     := !Empty( ( dbfFacPrvP )->cTipRec )
   local lErrorFound := .f.
   local lReturn     := .t.

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
   --------------------------------------------------------------------------
   */

   cRuta             := cRutCnt()
   cCodEmp           := cCodEmpCnt( ( dbfFacPrvP )->cSerFac )

   if !lFromFactura

      if OpenDiario( , cCodEmp )
         nAsiento          := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " imposible abrir ficheros de contaplus.", 0 ) )
         Return .f.
      end if

   end if

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if ( dbfFacPrvP )->lConPgo
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " ya contabilizado.", 0 ) )
      lErrorFound    := .t.
   end if

   if !( dbfFacPrvP )->lCobrado
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " no cobrado.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   if !lConFac .and. !lFromFactura
      oTree:Select( oTree:Add( "Factura de Recibo proveedor : " + rtrim( cRecibo ) + " no contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   if Empty( cCodEmp )
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " no se definieron empresas asociadas.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Chequeamos todos los valores
   --------------------------------------------------------------------------
   */

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaPrv, , .f., .f. )
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " subcuenta " + cCtaPrv + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Comprobamos formas de pago
   ----------------------------------------------------------------------------
   */

   if Empty( cCodPgo )
      cCodPgo        := cPgoFacPrv( ( dbfFacPrvP )->cSerFac + str( ( dbfFacPrvP )->nNumFac, 9 ) + ( dbfFacPrvP )->cSufFac, dbfFacPrvT )
   end if

   cCtaPgo           := ( dbfFacPrvP )->cCtaRec

   if Empty( cCtaPgo )
      cCtaPgo        := cCtaFPago( cCodPgo, dbfFPago )
   end if

   if Empty( cCtaPgo )
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " no existe cuenta de pago.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkSubcuenta( cRutCnt(), cCodEmp, cCtaPgo, , .f., .f. )
      oTree:Select( oTree:Add( "Recibo proveedor : " + rtrim( cRecibo ) + " subcuenta " + rtrim( cCtaPgo ) + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   /*
   Comprobamos fechas
   --------------------------------------------------------------------------
   */

   if Empty( ( dbfFacPrvP )->dEntrada )
      if dbLock( dbfFacPrvP )
         ( dbfFacPrvP )->dEntrada := date()
         ( dbfFacPrvP )->( dbUnLock() )
      end if
   end if

   if !ChkFecha( , , ( dbfFacPrvP )->dEntrada, .f., oTree )
      lErrorFound    := .t.
   end if

   /*
   Datos comunes a todos los Asientos
   --------------------------------------------------------------------------
   */

   dFecha            := ( dbfFacPrvP )->dEntrada

   cConcepto         := "P/Recibo N." + alltrim( str( ( dbfFacPrvP )->nNumRec ) ) + Space( 1 )

   if !Empty( ( dbfFacPrvT )->cSuPed )

      cConcepto      += "S/Fcta. N." + Rtrim( ( dbfFacPrvT )->cSuPed )

   elseif !Empty( ( dbfFacPrvT )->cNumDoc )

      cConcepto      += "Doc. N." + Rtrim( ( dbfFacPrvT )->cNumDoc )

   else

      cConcepto      += "N/Fcta. N." + Rtrim( cFactura )

   end if

   cConcepto         += Space( 1 ) + Rtrim( ( dbfFacPrvT )->cNomPrv )
   //cConcepto         := "P/Recibo " + cRecibo
   //cPagoPrv          := "P/Recibo N." + str( ( dbfFacPrvP )->nNumRec, 2 ) + Sapce( 1 ) + Rtrim( ( dbfFacPrvT )->cNomPrv ) + " N." + ( dbfFacPrvP )->cSerFac + "/" + Ltrim( str( ( dbfFacPrvP )->nNumFac ) ) + "/" + ( dbfFacPrvP )->cSufFac + "/" +

   /*
   Realización de Asientos
   --------------------------------------------------------------------------
   */

   if !lFromFactura
      nAsiento    := contaplusUltimoAsiento()
   end if

   /*
   Contabilizaci¢n de Pagos
   --------------------------------------------------------------------------
   */

   if ( dbfFacPrvP )->( dbSeek( nRecibo ) )

      aadd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha, ;
                                 cCtaPgo,;
                                 ,;
                                 ,;
                                 cConcepto,; // cPagoPrv,;
                                 ( dbfFacPrvP )->nImporte,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 cCodPro,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      /*
      Contrapartida_________________________________________________________
      */

      aadd( aSimula, MkAsiento(  nAsiento,;
                                 cCodDiv,;
                                 dFecha, ;
                                 cCtaPrv,;
                                 ,;
                                 ( dbfFacPrvP )->nImporte,;
                                 cConcepto,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 cCodPro,;
                                 ,;
                                 ,;
                                 ,;
                                 ,;
                                 lSimula,;
                                 cTerNif,;
                                 cTerNom ) )

      if ( !lSimula .and. !lErrorFound )
         lReturn     := lCntRecPrv( cRecibo, nAsiento, lFromFactura, oTree, dbfFacPrvP )
      end if

      if ( lSimula .and. !lFromFactura )
         lReturn     := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cRecibo, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cRecibo, nAsiento ), lCntRecPrv( cRecibo, nAsiento, lFromFactura, oTree, dbfFacPrvP ) } )
      end if

   end if

   if !lFromFactura
      CloseDiario()
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

   ( dbfFacPrvP )->( dbGoTo( nRecno ) )

Return ( lReturn )

//------------------------------------------------------------------------//

Function lCntRecPrv( cRecibo, nAsiento, lFromFactura, oTree, dbfFacPrvP )

   local lReturn  := .f.

   if dbLock( dbfFacPrvP )
      ( dbfFacPrvP )->lConPgo  := .t.
      ( dbfFacPrvP )->( dbUnLock() )
      lReturn     := .t.
   end if

   if !lFromFactura
      oTree:Select( oTree:Add( "Recibo proveedor : " + Rtrim( cRecibo ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 ) )
   end if

RETURN ( lReturn )

//------------------------------------------------------------------------//

FUNCTION ContabilizaReciboCliente( oBrw, oTree, lSimula, aSimula, dbfFacCliT, dbfFacCliP, dbfFPago, dbfCli, dbfDiv, lFromFactura, nAsiento )

   local cCodEmp
   local cRuta
   local dFecha
   local cConcepto
   local cCtaGas
   local cCtaPgo
   local cCtaCli
   local nDpvDiv
   local lEfePgo
   local nEjeCon        := 0 
   local nRecCliT       := ( dbfFacCliT )->( Recno() )
   local nRecCliP       := ( dbfFacCliP )->( Recno() )
   local cCodDiv        := if( ( dbfFacCliP )->lImpEur, "EUR", ( dbfFacCliP )->cDivPgo )
   local nImpRec        := nTotRecCli( dbfFacCliP, dbfDiv )
   local nImpCob        := nTotCobCli( dbfFacCliP, dbfDiv )
   local nImpGas        := nTotGasCli( dbfFacCliP, dbfDiv )
   local nRecibo        := ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac + str( ( dbfFacCliP )->nNumRec )
   local cRecibo        := ( dbfFacCliP )->cSerie + "/" + Ltrim( str( ( dbfFacCliP )->NNUMFAC, 9 ) ) + "/" + ( dbfFacCliP )->CSUFFAC + "-" + str( ( dbfFacCliP )->NNUMREC )
   local lConFac        := lConFacCli( ( dbfFacCliP )->CSERIE + str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cCodCli        := cCliFacCli( ( dbfFacCliP )->CSERIE + str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cCodPgo        := cPgoFacCli( ( dbfFacCliP )->CSERIE + str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cCodPro        := cProFacCli( ( dbfFacCliP )->CSERIE + str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT )
   local cTerNif        := RetFld( ( dbfFacCliP )->CSERIE + str( ( dbfFacCliP )->NNUMFAC, 9 ) + ( dbfFacCliP )->CSUFFAC, dbfFacCliT, "CDNICLI" )
   local cNombreCliente := ( dbfFacCliP )->cNomCli
   local lErrorFound    := .f.
   local lRectif        := !Empty( ( dbfFacCliP )->cTipRec )
   local cProyecto      := Left( cCodPro, 3 )
   local cClave         := Right( cCodPro, 6 )
   local lReturn        := .t.

   nDpvDiv              := nDpvDiv( cCodDiv, dbfDiv )

   DEFAULT lSimula      := .f.
   DEFAULT lFromFactura := .f.
   DEFAULT nAsiento     := 0

   cRuta                := cRutCnt()
   cCodEmp              := cCodEmpCnt( ( dbfFacCliP )->cSerie )

   if !lFromFactura

      if OpenDiario( , cCodEmp )
         nAsiento       := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " imposible abrir ficheros de contaplus.", 0 ) )
         Return .f.
      end if

   end if

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if lAplicacionContaplus()

      if !( ( dbfFacCliP )->lCobrado .or. ( dbfFacCliP )->lDevuelto ) 
         oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no cobrado o no devuelto.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
         lErrorFound       := .t.
      end if

      if ( dbfFacCliP )->lCobrado .and. !ChkFecha( , , ( dbfFacCliP )->dEntrada, .f. )
         oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " de " + dtoc( ( dbfFacCliP )->dEntrada ) + " asiento fuera de fechas", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
         lErrorFound       := .t.
      end if

   end if

   if ( dbfFacCliP )->lConPgo
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " ya contabilizado.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if !Empty( ( dbfFacCliP )->nNumRem ) .and. !( dbfFacCliP )->lDevuelto
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " pertenece a remesa.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   if !uFieldEmpresa( "LCONTREC" )

      if !lConFac .and. !lFromFactura
         oTree:Select( oTree:Add( "Factura de recibo : " + rtrim( cRecibo ) + " no contabilizada.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
         lErrorFound       := .t.
      end if

   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " ruta no valida.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   /*
   Seleccionamos las empresa dependiendo de la serie de factura
   --------------------------------------------------------------------------
   */

   if Empty( cCodEmp )
      oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no se definieron empresas asociadas.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   /*
   Chequeamos todos los valores
   --------------------------------------------------------------------------
   */

   if Empty( cCodCli )
      cCodCli           := cCliFacCli( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac, 9 ) + ( dbfFacCliP )->cSufFac, dbfFacCliT )
   end if

   cCtaCli              := cCliCta( cCodCli, dbfCli )

   if Empty( cCtaCli )
      cCtaCli           := cCtaSin()
   end if

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " subcuenta de cliente " + cCtaCli + " no encontada.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
      lErrorFound       := .t.
   end if

   /*
   Comprobamos formas de pago
   ----------------------------------------------------------------------------
   */

   if ( dbfFacCliP )->( dbSeek( nRecibo ) )

      /*
      Si el recibo no trae forma especifica de pago entonces lo buscamos
      */

      cCtaPgo           := ( dbfFacCliP )->cCtaRec

      if Empty( cCtaPgo )
         cCtaPgo        := cCtaFPago( cCodPgo, dbfFPago )
      end if

      if Empty( cCtaPgo )
         cCtaPgo        := cCtaCob()
      end if

      if lAplicacionContaplus()

         if Empty( cCtaPgo )
            oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no existe cuenta de pago.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
            lErrorFound    := .t.
         end if

      end if 

      if !ChkSubcuenta( cRuta, cCodEmp, cCtaPgo, , .f., .f. )
         oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " subcuenta " + rtrim( cCtaPgo ) + " no encontada.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
         lErrorFound    := .t.
      end if

      /*
      Pago es en efectivo------------------------------------------------------
      */

      if lAplicacionContaplus()

         if ( nTipoPago( cCodPgo, dbfFPago ) == 1 )

            nEjeCon        := nEjercicioContaplus( cRuta, cCodEmp, .f. )

            if Empty( nEjeCon )
               oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " ejercicio no encontado.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
               lErrorFound := .t.
            end if

         end if 

      end if

      /*
      Obtenemos las cuentas de gastos------------------------------------------
      */

      if nImpGas != 0

         if Empty( ( dbfFacCliP )->cCtaGas )
            cCtaGas  := cCtaFGas( cCodPgo, dbfFPago )
         else
            cCtaGas  := ( dbfFacCliP )->cCtaGas
         end if

         if Empty( cCtaGas )
            oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " no existe cuenta de gastos.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
            lErrorFound := .t.
         end if

         if !ChkSubcuenta( cRuta, cCodEmp, cCtaGas, , .f., .f. )
            oTree:Select( oTree:Add( "Recibo : " + rtrim( cRecibo ) + " subcuenta " + rtrim( cCtaGas ) + " no encontada.", 0, bGenEdtRecCli( nRecibo, lFromFactura ) ) )
            lErrorFound := .t.
         end if

      end if

   else

      msginfo( "No encuentro el recibo " + nRecibo )

   end if

   /*
   Comprobamos fechas
   --------------------------------------------------------------------------
   */

   if ( !lErrorFound )

      if Empty( ( dbfFacCliP )->dPreCob )

         if dbDialogLock( dbfFacCliP )
            ( dbfFacCliP )->dPreCob := date()
            ( dbfFacCliP )->( dbUnLock() )
         end if

      end if

   end if

   /*
   Datos comunes a todos los Asientos
   --------------------------------------------------------------------------
   */

   if ( lSimula .or. !lErrorFound )

      if lAplicacionContaplus()

         if ( dbfFacCliP )->lDevuelto
            cConcepto      := "Dev./Recibo. " + cRecibo
            dFecha         := ( dbfFacCliP )->dFecDev
         else
            cConcepto      := "C/Recibo. " + cRecibo
            dFecha         := ( dbfFacCliP )->dEntrada
         end if

      else

         if ( dbfFacCliP )->lDevuelto
            cConcepto      := "Dev./Recibo. " + nRecibo
            dFecha         := ( dbfFacCliP )->dFecDev
         else
            cConcepto      := "C/Recibo. " + nRecibo
            dFecha         := ( dbfFacCliP )->dEntrada
         end if

      end if

   end if

   /*
   Contabilizaci¢n de Pagos
   --------------------------------------------------------------------------
   */

   if ( lSimula .or. !lErrorFound )

      /*
      Cliente por el total_____________________________________________________
      */

      if lAplicacionContaplus()

         if nImpRec != 0

             aadd( aSimula, MkAsiento( nAsiento,;
                                       cCodDiv,;
                                       dFecha, ;
                                       cCtaCli,;
                                       ,;
                                       if( ( dbfFacCliP )->lDevuelto, nImpRec, 0 ),;
                                       cConcepto,;
                                       if( ( dbfFacCliP )->lDevuelto, 0, nImpRec ),;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cNombreCliente ) )

         end if

         /*
         Cobro____________________________________________________________________
         */

         if nImpCob != 0

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha, ;
                                       cCtaPgo,;
                                       ,;
                                       if( ( dbfFacCliP )->lDevuelto, 0, nImpCob ),;
                                       cConcepto,;
                                       if( ( dbfFacCliP )->lDevuelto, nImpCob, 0 ),;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cNombreCliente,;
                                       nEjeCon,;
                                       cCtaCli ) )

         end if

         /*
         Gastos___________________________________________________________________
         */

         if nImpGas != 0

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha, ;
                                       cCtaGas,;
                                       ,;
                                       if( ( dbfFacCliP )->lDevuelto, 0, nImpGas ),;
                                       cConcepto,;
                                       if( ( dbfFacCliP )->lDevuelto, nImpGas, 0 ),;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cNombreCliente ) )

         end if

      else

         EnlaceA3():getInstance():Add( {  "Empresa"               => cEmpCnt( ( dbfFacCliP )->cSerie ),;
                                          "Fecha"                 => ( dbfFacCliP )->dEntrada,;
                                          "TipoRegistro"          => '0',; 
                                          "Cuenta"                => cCtaPgo,;
                                          "DescripcionCuenta"     => cNombreCliente,;
                                          "TipoImporte"           => 'D',; 
                                          "ReferenciaDocumento"   => nRecibo,; // cRecibo,;
                                          "DescripcionApunte"     => cConcepto,;
                                          "Importe"               => nImpRec,;
                                          "Moneda"                => 'E',; 
                                          "Render"                => 'ApuntesSinIVA' } )

         EnlaceA3():getInstance():Add( {  "Empresa"               => cEmpCnt( ( dbfFacCliP )->cSerie ),;
                                          "Fecha"                 => ( dbfFacCliP )->dEntrada,;
                                          "TipoRegistro"          => '0',; 
                                          "Cuenta"                => cCtaCli,;
                                          "DescripcionCuenta"     => cNombreCliente,;
                                          "TipoImporte"           => 'H',; 
                                          "ReferenciaDocumento"   => nRecibo,; // cRecibo,;
                                          "DescripcionApunte"     => cConcepto,;
                                          "Importe"               => nImpRec,;
                                          "Moneda"                => 'E',; 
                                          "Render"                => 'ApuntesSinIVA' } )

      end if 

      if ( !lSimula .and. !lErrorFound )
         lReturn     := lContabilizaReciboCliente( cRecibo, nAsiento, lFromFactura, oTree, dbfFacCliP )
      end if

      if ( lSimula .and. !lFromFactura )
         lReturn     := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, cRecibo, {|| aWriteAsiento( aSimula, cCodDiv, .t., oTree, cRecibo, nAsiento ), lContabilizaReciboCliente( cRecibo, nAsiento, lFromFactura, oTree, dbfFacCliP ) } )
      end if

   end if

   if !lFromFactura
      CloseDiario()
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

   ( dbfFacCliP )->( dbGoTo( nRecCliP ) )
   ( dbfFacCliT )->( dbGoTo( nRecCliT ) )

RETURN ( lReturn )

//------------------------------------------------------------------------//

Function lContabilizaReciboCliente( cRecibo, nAsiento, lFromFactura, oTree, dbfFacCliP )

   if dbLock( dbfFacCliP )
      ( dbfFacCliP )->lConPgo  := .t.
      ( dbfFacCliP )->( dbUnLock() )
   end if

   if !lFromFactura
      oTree:Select( oTree:Add( "Recibo : " + Rtrim( cRecibo ) + " asiento generado num. " + alltrim( str( nAsiento ) ), 1 ) )
   end if

RETURN ( .t. )

//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//
//------------------------------------------------------------------------//

FUNCTION CntFacRec( lSimula, lPago, lExcCnt, lMessage, oTree, nAsiento, aSimula, dbfFacRecT, dbfFacRecL, dbfFacCliP, dbfCli, dbfDiv, dbfArt, dbfFPago, dbfIva, oNewImp, oBrw, cCodEmp, cCodPro )

   local n
   local nIva
   local cCtaVent
   local nPos
   local dFecha
   local cConcepto
   local cPago
   local cSubCtaIva
   local cSubCtaReq
   local cSubCtaIvm
   local cSubCtaTrn
   local nImpDet
   local nImpTrn
   local nImpPnt
   local nImpIvm
   local nImpIva
   local cRuta
   local nDouDiv
   local nRouDiv
   local nDpvDiv
   local aTotAnt
   local nNetAnt
   local nIvaAnt
   local nAcuAnt     := 0
   local nTotAnt     := 0
   local uIva
   local newIva
   local aIva        := {}
   local aIvm        := {}
   local aTrn        := {}
   local nCalculo    := 0
   local nBase       := 0
   local aVentas     := {}
   local lIvaInc     := ( dbfFacRecT )->lIvaInc
   local cCodDiv     := ( dbfFacRecT )->cDivFac
   local cCtaCli     := cCliCta( ( dbfFacRecT )->cCodCli, dbfCli )
   local cCtaCliVta  := cCliCtaVta( ( dbfFacRecT )->cCodCli, dbfCli )
   local cCtaAnticipo:= cCtaAnt()
   local nFactura    := ( dbfFacRecT )->cSerie + str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac
   local cFactura    := ( dbfFacRecT )->cSerie + alltrim( str( ( dbfFacRecT )->nNumFac ) )
   local pFactura    := ( dbfFacRecT )->cSerie + "/" + alltrim( str( ( dbfFacRecT )->nNumFac ) ) + "/" + ( dbfFacRecT )->cSufFac
   local lRecargo    := ( dbfFacRecT )->lRecargo
   local cTerNif     := ( dbfFacRecT )->cDniCli
   local cTerNom     := ( dbfFacRecT )->cNomCli
   local lErrorFound := .f.
   local cProyecto
   local cClave
   local sTotFacRec
   local ptaDebe
   local ptaRet
   local lReturn     := .t.
   local lOpenDiario := lOpenDiario()
   local nTotDebe    := 0
   local nTotHaber   := 0
   local nDtoEsp     := 0
   local nDpp        := 0
   local nDtoUno     := 0
   local nDtoDos     := 0
   local nPctIva     := 0
   local nBaseImp    := 0

   DEFAULT lSimula   := .t.
   DEFAULT nAsiento  := 0
   DEFAULT aSimula   := {}
   DEFAULT cCodEmp   := cCodEmpCnt( ( dbfFacRecT )->cSerie )
   DEFAULT cCodPro   := ( dbfFacRecT )->cCodPro

   nDouDiv           := nDouDiv( ( dbfFacRecT )->cDivFac, dbfDiv )
   nRouDiv           := nRouDiv( ( dbfFacRecT )->cDivFac, dbfDiv )
   nDpvDiv           := nDpvDiv( ( dbfFacRecT )->cDivFac, dbfDiv )

   dFecha            := ( dbfFacRecT )->dFecFac
   nDtoEsp           := ( dbfFacRecT )->nDtoEsp
   nDpp              := ( dbfFacRecT )->nDpp
   nDtoUno           := ( dbfFacRecT )->nDtoUno
   nDtoDos           := ( dbfFacRecT )->nDtoDos

   sTotFacRec        := sTotFacRec( ( dbfFacRecT )->cSerie + str( ( dbfFacRecT )->nNumFac ) + ( dbfFacRecT )->cSufFac, dbfFacRecT, dbfFacRecL, dbfIva, dbfDiv, dbfFacCliP )
   ptaDebe           := sTotFacRec:nTotalDocumento
   ptaRet            := sTotFacRec:nTotalRetencion
   newIva            := sTotFacRec:aTotalIva

   cProyecto         := Left( cCodPro, 3 )
   cClave            := Right( cCodPro, 6 )

   /*
   Seleccionamos las empresa dependiendo de la serie de factura----------------
   */

   cRuta             := cRutCnt()

   if !chkEmpresaAsociada( cCodEmp )
      oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " no se definierón empresas asociadas.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkRuta( cRutCnt() )
      oTree:Select( oTree:Add(  "Factura rectificativa cliente : " + rtrim( pFactura ) + " ruta no valida.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkFecha( cRuta, cCodEmp, ( dbfFacRecT )->dFecFac, .f., oTree, "Factura rectificativa cliente : " + Rtrim( pFactura ) )
      lErrorFound    := .t.
   end if

   /*
   Preparamos los apuntes de cliente-------------------------------------------
   */

   if Empty( cCtaCli )
      cCtaCli        := cCtaSin()
   end if

   if Empty( cCtaCliVta )
      cCtaCliVta     := cCtaCli()
   end if

   /*
   Estudio de los Articulos de una factura-------------------------------------
   */

   if ( dbfFacRecL )->( dbSeek( nFactura ) )

      while ( ( dbfFacRecL )->cSerie + str( ( dbfFacRecL )->nNumFac ) + ( dbfFacRecL )->cSufFac == nFactura .and. !( dbfFacRecL )->( eof() ) )

         if !( dbfFacRecL )->lTotLin                           .and. ;
            lValLine( dbfFacRecL )                             .and. ;
            nTotLFacRec( dbfFacRecL, nDouDiv, nRouDiv, nil, .t., .t., .t. ) != 0

            if ( lExcCnt == nil                                .or.;    // Entran todos
               ( lExcCnt .and. ( dbfFacRecL )->nCtlStk != 2 )  .or.;    // Articulos sin contadores
               ( !lExcCnt .and. ( dbfFacRecL )->nCtlStk == 2 ) )        // Articulos con contadores

               nIva           := ( dbfFacRecL )->nIva
               nImpDet        := nTotLFacRec( dbfFacRecL, nDouDiv, nRouDiv, nil, .t., .f., .f. )
               nImpTrn        := nTrnLFacRec( dbfFacRecL, nDouDiv, nRouDiv )                 // Portes

               /*
               Si en la factura nos piden q operemeos con punto verde----------
               */

               if ( dbfFacRecT )->lOperPV
                  nImpPnt     := nPntLFacRec( dbfFacRecL, nDpvDiv )
               else
                  nImpPnt     := 0
               end if 

               nImpIva        := nIvaLFacRec( dbfFacRecL, nDouDiv, nRouDiv )
               nImpIvm        := nTotIFacRec( dbfFacRecL, nDouDiv, nRouDiv )

               cCtaVent       := RetCtaVta( ( dbfFacRecL )->cRef, ( nImpDet < 0 ), dbfArt )
               if Empty( cCtaVent )
                  cCtaVent    := cCtaCliVta + RetGrpVta( ( dbfFacRecL )->cRef, cRuta, cCodEmp, dbfArt, nIva )
               end if

               /*
               Cuentas de ventas--------------------------------------------------
               */

               nPos           := aScan( aVentas, {|x| x[ 1 ] == cCtaVent .and. x[ 2 ] == nIva } )
               if nPos == 0
                  aAdd( aVentas, { cCtaVent, nIva, nImpDet, nImpPnt, nImpTrn, nImpIva, .f. } )
               else
                  aVentas[ nPos, 3 ]   += nImpDet
                  aVentas[ nPos, 4 ]   += nImpPnt
                  aVentas[ nPos, 5 ]   += nImpTrn
                  aVentas[ nPos, 6 ]   += nImpIva
               end if

               /*
               Construimos las bases de los impuestos-----------------------------
               */

               if isIVAComunidadEconomicaEuropea( dbfFacRecT )
                  cSubCtaIva  := uFieldEmpresa( "cCtaCeeRpt" )
                  cSubCtaReq  := uFieldEmpresa( "cCtaCeeSpt" )
               else
                  cSubCtaIva  := cSubCuentaIva( nIva, ( dbfFacRecT )->lRecargo, cRuta, cCodEmp, dbfIva )
                  cSubCtaReq  := cSubCuentaRecargo( nIva, ( dbfFacRecT )->lRecargo, cRuta, cCodEmp, dbfIva )
               end if

               if uFieldEmpresa( "lIvaImpEsp" )
                  nImpDet     += nImpIvm
               end if

               nPos           := aScan( aIva, {|x| x[ 1 ] == nIva } )
               if nPos  == 0
                  aAdd( aIva, { nIva, cSubCtaIva, cSubCtaReq, nImpDet, nImpPnt, nImpTrn, 0, 0, 0 } )
               else
                  aIva[ nPos, 4 ] += nImpDet
                  aIva[ nPos, 5 ] += nImpPnt
                  aIva[ nPos, 6 ] += nImpTrn
               end if

               /*
               transportes--------------------------------------------------------
               */

               if nImpTrn != 0

                  cSubCtaTrn  := RetCtaTrn( ( dbfFacRecL )->cRef, dbfArt )

                  nPos        := aScan( aTrn, {|x| x[1] == cSubCtaTrn } )
                  if nPos == 0
                     aAdd( aTrn, { cSubCtaTrn, nImpTrn } )
                  else
                     aTrn[ nPos, 2 ] += nImpTrn
                  end if

               end if

               /*
               impuesto especiales---------------------------------------------------
               */

               nImpIvm        := nTotIFacRec( dbfFacRecL, nDouDiv, nRouDiv )

               if nImpIvm != 0

                  cSubCtaIvm  := oNewImp:cCtaImp( oNewImp:nValImp( ( dbfFacRecL )->cCodImp ) )

                  if !Empty( cSubCtaIvm )

                     nPos     := aScan( aIvm, {|x| x[1] == cSubCtaIvm } )
                     if nPos == 0
                        aAdd( aIvm, { cSubCtaIvm, nImpIvm } )
                     else
                        aIvm[ nPos, 2 ] += nImpIvm
                     end if

                  end if

               end if

            end if

         end if

         SysRefresh()

         ( dbfFacRecL )->( dbSkip() )

      end while

   else

      oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " factura sin artículos.", 0 ) )

      lErrorFound := .t.

   end if

   /*
   Descuentos sobres grupos de Venta
   --------------------------------------------------------------------------
   */

   for n := 1 to Len( aVentas )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDtoEsp )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDpp )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDtoUno )
      nRestaDescuentoVenta( @aVentas[ n, 3 ], nDtoDos )
   next

   /*
   Gastos se lo sumamos a la base----------------------------------------------
   */

   if ( ( dbfFacRecT )->nManObr != 0 )

      cSubCtaTrn     := uFieldEmpresa( "cCtaGas")

      nPos           := aScan( aVentas, {|x| x[ 1 ] == cSubCtaTrn .and. x[ 2 ] == ( dbfFacRecT )->nIvaMan } )
      if nPos == 0
         aAdd( aVentas, { cSubCtaTrn, ( dbfFacRecT )->nIvaMan, ( dbfFacRecT )->nManObr, 0, 0, 0, .f. } )
      else
         aVentas[ nPos, 3 ]   += ( dbfFacRecT )->nManObr
      end if

   end if 

   /*
   Despues de aplicar los descuentos le sumamos el punto verde-----------------
   */

   for n := 1 to Len( aVentas )
      aVentas[ n, 3 ]   += aVentas[ n, 4 ]
   next

   /*
   Ponemos la cuentas de IVA---------------------------------------------------
   */

   for each uIva in newIva

      if isNum( uIva[ 3 ] )

         /*
         Construimos las bases de los impuestos--------------------------------
         */

         if isIVAComunidadEconomicaEuropea( dbfFacRecT )
            cSubCtaIva  := cCuentaVentaIVARepercutidoUE()
            uIva[ 3 ]   := 0
            aAdd( uIva, cSubCtaIva )
         elseif isIVAExportacionFueraUE( dbfFacRecT )
            cSubCtaIva  := cCuentaVentaIVARepercutidoFueraUE()
            uIva[ 3 ]   := 0
            aAdd( uIva, cSubCtaIva )
         else
            aAdd( uIva, cSubCuentaIva( uIva[ 3 ], ( dbfFacRecT )->lRecargo, cRuta, cCodEmp, dbfIva ) )
            aAdd( uIva, cSubCuentaRecargo( uIva[ 3 ], ( dbfFacRecT )->lRecargo, cRuta, cCodEmp, dbfIva ) )
            aAdd( uIva, cSubCuentaIva( uIva[ 3 ], .f., cRuta, cCodEmp, dbfIva ) )
         end if

      end if 

   next 

   /*
   Chequando antes de pasar a Contaplus
   --------------------------------------------------------------------------
   */

   if ( dbfFacRecT )->lContab
      oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " contabilizada.", 0 ) )
      lErrorFound    := .t.
   end if

   if !ChkSubcuenta( cRuta, cCodEmp, cCtaCli, , .f., .f. )
      oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " subcuenta " + cCtaCli + " no encontada.", 0 ) )
      lErrorFound    := .t.
   end if

   if ptaRet != 0
      if !ChkSubcuenta( cRuta, cCodEmp, cCtaRet(), , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa cliente : " + Rtrim( cFactura ) + " subcuenta " + cCtaRet() + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   end if

   /*
   Creacion y chequeo de Cuentas de impuestos
   --------------------------------------------------------------------------
   */

   for each uIva in newIva 

      if isNum( uIva[ 3 ] )

         if !ChkSubcuenta( cRutCnt(), cCodEmp, uIva[ 12 ], , .f., .f. )
            oTree:Select( oTree:Add( "Factura rectificativa cliente : " + Rtrim( pFactura ) + " subcuenta " + uIva[ 12 ] + " no encontada.", 0 ) )
            lErrorFound := .t.
         end if

         if lRecargo .and. !ChkSubcuenta( cRutCnt(), cCodEmp, uIva[ 13 ], , .f., .f. )
            oTree:Select( oTree:Add( "Factura rectificativa cliente : " + Rtrim( pFactura ) + " subcuenta " + uIva[ 13 ] + " no encontada.", 0 ) )
            lErrorFound := .t.
         end if

      end if 

   next

   for n := 1 to len( aVentas )
      if !ChkSubcuenta( cRuta, cCodEmp, aVentas[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " subcuenta " + aVentas[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   for n := 1 to len( aIvm )
      if !lSimula .and. !ChkSubcuenta( cRuta, cCodEmp, aIvm[ n, 1 ], , .f., .f. )
         oTree:Add( "Factura rectificativa cliente : " + rtrim( nFactura ) + " subcuenta " + aIvm[ n, 1 ] + " no encontada.", 0 )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeo de Cuentas de Transportes
   --------------------------------------------------------------------------
   */

   for n := 1 to len( aTrn )
      if !ChkSubcuenta( cRuta, cCodEmp, aTrn[ n, 1 ], , .f., .f. )
         oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " subcuenta " + aTrn[ n, 1 ] + " no encontada.", 0 ) )
         lErrorFound := .t.
      end if
   next

   /*
   Chequeamos los anticipos-------------------------------------------------
   */

   if nTotAnt != 0 .and. !ChkSubcuenta( cRuta, cCodEmp, cCtaAnticipo, , .f., .f. )
      oTree:Select( oTree:Add( "Factura rectificativa cliente : " + rtrim( pFactura ) + " subcuenta de anticipo " + cCtaAnticipo + " no encontada.", 0 ) )
      lErrorFound := .t.
   end if

   /*
   Datos comunes a todos los Asientos
   --------------------------------------------------------------------------
   */

   cConcepto      := "N/Rect. N." + pFactura
   cPago          := "C/Rect. N." + pFactura

   /*
   Cuadre del apunte
   -------------------------------------------------------------------------
   */

   nTotDebe          += Round( ptaDebe, nRouDiv )

   for n := 1 to len( aVentas )

      if lIvaInc

         nCalculo    := Round( aVentas[ n, 3 ], nRouDiv )

         if aVentas[ n, 2 ] != 0
            nCalculo -= Round( aVentas[ n, 3 ] / ( 100 / aVentas[ n, 2 ] + 1 ), nRouDiv )
         end if

      else

         nCalculo    := Round( aVentas[ n, 3 ], nRouDiv )

      end if

      nTotHaber      += nCalculo

   next

   nTotDebe          += ptaRet
   nTotDebe          += nAcuAnt

   for n := 1 to Len( aIvm )
      nTotHaber      += Round( aIvm[ n, 2 ], nRouDiv )
   next

   for n := 1 to Len( aTrn )
      nTotHaber      += Round( aTrn[ n, 2 ], nRouDiv )
   next

   for each uIva in newIva 

      if isNum( uIva[ 8 ] )
         nTotHaber   += uIva[ 8 ]
      end if 

      if lRecargo .and. isNum( uIva[ 9 ] )
         nTotHaber   += uIva[ 9 ]
      end if 

   next

   nTotDebe          := Round( nTotDebe, nRouDiv )
   nTotHaber         := Round( nTotHaber, nRouDiv )

   /*
   Realización de Asientos
   --------------------------------------------------------------------------
   */

   if lSimula .or. !lErrorFound

      if lOpenDiario .or. OpenDiario( , cCodEmp )
         nAsiento    := contaplusUltimoAsiento()
      else
         oTree:Select( oTree:Add( "Factura rectificativa cliente : " + Rtrim( pFactura ) + " imposible abrir ficheros de contaplus.", 0 ) )
         Return .f.
      end if

      setAsientoIntraComunitario( isIVAComunidadEconomicaEuropea( dbfFacRecT ) )

      /*
      Asiento de cliente----------------------------------------------------------
      */

      if lAplicacionContaplus()

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaCli,;
                                    ,;
                                    Round( ptaDebe, nRouDiv ),;
                                    cConcepto,;
                                    ,;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      else 

         EnlaceA3():getInstance():Add( {  "Empresa"               => cEmpCnt( ( dbfFacRecT )->cSerie ),;
                                          "Fecha"                 => dFecha ,;
                                          "TipoRegistro"          => '1',; // Facturas
                                          "Cuenta"                => cCtaCli,;
                                          "DescripcionCuenta"     => cTerNom,;
                                          "TipoFactura"           => '1',; // Ventas
                                          "NumeroFactura"         => cFactura,;
                                          "DescripcionApunte"     => cConcepto,;
                                          "Importe"               => Round( ptaDebe, nRouDiv ),;
                                          "Nif"                   => cTerNif,;
                                          "NombreCliente"         => cTerNom,;
                                          "CodigoPostal"          => ( dbfFacRecT )->cPosCli,;
                                          "FechaOperacion"        => dFecha,;
                                          "FechaFactura"          => dFecha,;
                                          "Moneda"                => 'E',; // Euros
                                          "Render"                => 'CabeceraFactura' } )

      end if 

      /*
      Asientos de Ventas
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aVentas )

         nCalculo       := Round( aVentas[ n, 3 ], nRouDiv )

         if lIvaInc

            nPctIva     := aVentas[ n, 2 ]

            if ( lRecargo .and. aVentas[ n, 7 ] )
               nPctIva  += nPReq( dbfIva, aVentas[ n, 2 ] )
            end if             

            if aVentas[ n, 2 ] != 0
               nCalculo -= Round( aVentas[ n, 3 ] / ( 100 / nPctIva + 1 ), nRouDiv )
            end if

         end if 

         if lAplicacionContaplus()

            aadd( aSimula, MkAsiento(  nAsiento, ;
                                       cCodDiv, ;
                                       dFecha, ;
                                       aVentas[ n, 1 ],;
                                       ,;
                                       ,;
                                       cConcepto,;
                                       nCalculo,;
                                       cFactura,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         else 

            EnlaceA3():getInstance():Add( {  "Empresa"               => cEmpCnt( ( dbfFacRecT )->cSerie ),;
                                             "Fecha"                 => dFecha ,;
                                             "TipoRegistro"          => '9',; // Facturas
                                             "Cuenta"                => aVentas[ n, 1 ],;
                                             "DescripcionCuenta"     => '',;
                                             "TipoImporte"           => 'C',;
                                             "NumeroFactura"         => cFactura,;
                                             "DescripcionApunte"     => cConcepto,;
                                             "SubtipoFactura"        => if( isIVAComunidadEconomicaEuropea( dbfFacRecT ), '02', '01' ),; // Ventas
                                             "BaseImponible"         => nCalculo,;
                                             "PorcentajeIVA"         => aVentas[ n, 2 ],;
                                             "PorcentajeRecargo"     => if( ( dbfFacRecT )->lRecargo, nPReq( dbfIva, aVentas[ n, 2 ] ), 0 ),;
                                             "PorcentajeRetencion"   => 0,;
                                             "Impreso"               => '01',; // 347
                                             "SujetaIVA"             => if( aVentas[ n, 2 ] != 0, 'S', 'N' ),;
                                             "Modelo415"             => ' ',;
                                             "Analitico"             => ' ',;
                                             "Moneda"                => 'E',; // Euros
                                             "Render"                => 'VentaFactura' } )

         end if 

      next

      /*
      Asientos del retenciones________________________________________________________
      */

      if lAplicacionContaplus() .and. ptaRet != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaRet(),;   // Cuenta de retencion
                                    ,;
                                    ptaRet,;
                                    cConcepto,;
                                    ,;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Asientos de anticipo
      -------------------------------------------------------------------------
      */

      if lAplicacionContaplus() .and. nTotAnt != 0

         aadd( aSimula, MkAsiento(  nAsiento,;
                                    cCodDiv,;
                                    dFecha,;
                                    cCtaAnticipo,;
                                    ,;
                                    nAcuAnt,;
                                    cConcepto,;
                                    ,;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      end if

      /*
      Asientos de IVM
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aIvm )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aIvm[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aIvm[ n, 2 ], nRouDiv ),;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula ) )

      next

      /*
      Asientos de transporte
      -------------------------------------------------------------------------
      */

      for n := 1 to Len( aTrn )

         aadd( aSimula, MkAsiento(  nAsiento, ;
                                    cCodDiv, ;
                                    dFecha, ;
                                    aTrn[ n, 1 ],;
                                    ,;
                                    ,;
                                    cConcepto,;
                                    Round( aTrn[ n, 2 ], nRouDiv ),;
                                    cFactura,;
                                    ,;
                                    ,;
                                    ,;
                                    ,;
                                    cProyecto,;
                                    cClave,;
                                    ,;
                                    ,;
                                    ,;
                                    lSimula,;
                                    cTerNif,;
                                    cTerNom ) )

      next

      /*
      Asientos de impuestos
      --------------------------------------------------------------------------
      */

      for each uIva in newIva

         if ( len( uIva ) >= 12 ) .and. ( uIva[ 8 ] != 0 .or. uFieldEmpresa( "lConIva" ) )

            nBaseImp    := uIva[ 2 ] - uIva[ 10 ] 

            if uFieldEmpresa( "lIvaImpEsp" )
               nBaseImp += uIva[ 6 ]
            end if

            aAdd( aSimula, MkAsiento(  nAsiento, ;                          
                                       cCodDiv, ;                          
                                       dFecha, ;                          
                                       uIva[ 12 ],;                           // Cuenta de impuestos                          
                                       cCtaCli,;                              // Contrapartida                          
                                       ,;                                     // Ptas. Debe                          
                                       cConcepto,;                          
                                       uIva[ 8 ] - uIva[ 11 ],;               // Ptas. Haber                          
                                       cFactura,;                          
                                       nBaseImp,;                             // Base Imponible                          
                                       uIva[ 3 ],;                          
                                       if( lRecargo, uIva[ 4 ], 0 ),;         // Tipo de recargo                         
                                       ,;                          
                                       cProyecto,;                          
                                       cClave,;                          
                                       ,;                          
                                       ,;                          
                                       ,;                          
                                       lSimula,;                          
                                       cTerNif,;                          
                                       cTerNom,;
                                       ,;
                                       ,;
                                       .t. ) )                       

         end if

         /*
         Asientos del Recargo
         -------------------------------------------------------------------------
         */

         if ( lRecargo .and. len( uIva ) >= 13 .and. uIva[ 9 ] != 0 )

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha,;
                                       uIva[ 13 ],;
                                       ,;
                                       ,;
                                       cConcepto,;
                                       uIva[ 9 ],;
                                       cFactura,;
                                       ,;
                                       ,;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         end if 

         /*
         Asientos de Portes exentos de recargo de equivalencia
         -------------------------------------------------------------------------
         */

         if ( len( uIva ) >= 14 .and. uIva[ 10 ] != 0 )

            aadd( aSimula, MkAsiento(  nAsiento,;
                                       cCodDiv,;
                                       dFecha,;
                                       uIva[ 14 ],;      // Cuenta de impuestos
                                       cCtaCli,;         // Contrapartida                          
                                       ,;                // Ptas. Debe                          
                                       cConcepto,;
                                       uIva[ 11 ],;      // Ptas. Haber
                                       cFactura,;
                                       uIva[ 10 ],;      // Base Imponible
                                       uIva[ 3 ],;
                                       ,;
                                       ,;
                                       cProyecto,;
                                       cClave,;
                                       ,;
                                       ,;
                                       ,;
                                       lSimula,;
                                       cTerNif,;
                                       cTerNom ) )

         end if 

      next

   end if

   /*
   Contabilizamos los pagos
   ----------------------------------------------------------------------------
   */

   if lPago .and. !lErrorFound .and. ( dbfFacCliP )->( dbSeek( nFactura ) )

      while ( ( dbfFacCliP )->cSerie + str( ( dbfFacCliP )->nNumFac ) + ( dbfFacCliP )->cSufFac == nFactura ) .and. !( dbfFacCliP )->( eof() )

         ContabilizaReciboCliente( oBrw, oTree, lSimula, aSimula, dbfFacRecT, dbfFacCliP, dbfFPago, dbfCli, dbfDiv, .t., nAsiento )

         ( dbfFacCliP )->( dbSkip() )

      end while

   end if

   /*
   Ponemos la factura como Contabilizada---------------------------------------
   */

   if lSimula

      if lMessage
         lReturn  := msgTblCon( aSimula, cCodDiv, dbfDiv, !lErrorFound, pFactura, {|| aWriteAsiento( aSimula, cCodDiv, lMessage, oTree, pFactura, nAsiento ), lCntFacRec( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacRecT, dbfFacCliP ) } )
      end if

   else

      if !lErrorFound
         lReturn  := lCntFacRec( nFactura, pFactura, nAsiento, lPago, oTree, dbfFacRecT )
      end if

   end if

   /*
   Cerramos las tablas de contaplus--------------------------------------------
   */

   if !lOpenDiario
      CloseDiario()
   end if

   setAsientoIntraComunitario( .f. )

   if !Empty( oBrw )
      oBrw:Refresh()
   end if

RETURN ( lReturn )

//---------------------------------------------------------------------------//



