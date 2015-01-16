#include "FiveWin.Ch"
#include "Factu.ch"

CLASS PedidoCliente FROM Ventas  

   DATA oViewNavigator

   METHOD New()

   METHOD setAeras()

   METHOD setNavigator()

   METHOD PropiedadesBrowse()

   METHOD PropiedadesBrowseDetail()

   METHOD Resource( nMode )

   METHOD ResourceDetail( nMode )

   METHOD GetAppendDocumento()

   METHOD GetEditDocumento()

   METHOD GuardaDocumento()

   METHOD GetAppendDetail()
   METHOD GetEditDetail()

   METHOD CargaArticulo()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS PedidoCliente

   if ::OpenFiles()
      
      ::setAeras()

      ::setNavigator()

      ::CloseFiles()

   end if   

return ( self )

//---------------------------------------------------------------------------//

METHOD setAeras() CLASS PedidoCliente
   
   ::setWorkArea( D():PedidosClientes( ::nView ) )
   ::setDetailArea( D():PedidosClientesLineas( ::nView ) )

   ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) )

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS PedidoCliente

   ::oViewNavigator       := ViewNavigator():New( self )

   if !Empty( ::oViewNavigator )

      ::oViewNavigator:setTextoTipoDocuento( "Pedidos de cliente" )
      ::oViewNavigator:setItemsBusqueda( { "Número", "Fecha", "Código", "Nombre" } )
      
      ::oViewNavigator:setWorkArea( ::getWorkArea() )

      ::oViewNavigator:ResourceViewNavigator()

   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowse() CLASS PedidoCliente

   ::oViewNavigator:oBrowse:cName            := "Grid pedidos"

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Pedido"
      :bEditValue        := {|| D():PedidosClientesIdText( ::nView ) + CRLF + Dtoc( ( D():PedidosClientes( ::nView ) )->dFecPed ) }
      :nWidth            := 160
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Cliente"
      :bEditValue        := {|| AllTrim( ( D():PedidosClientes( ::nView ) )->cCodCli ) + CRLF + AllTrim( ( D():PedidosClientes( ::nView ) )->cNomCli )  }
      :nWidth            := 320
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Base"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotNet  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := cImp()
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotIva  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "R.E."
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotReq  }
      :cEditPicture      := cPorDiv()
      :nWidth            := 80
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
      :lHide             := .t.
   end with

   with object ( ::oViewNavigator:oBrowse:AddCol() )
      :cHeader           := "Total"
      :bEditValue        := {|| ( D():PedidosClientes( ::nView ) )->nTotPed }
      :cEditPicture      := cPorDiv()
      :nWidth            := 190
      :nDataStrAlign     := 1
      :nHeadStrAlign     := 1
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS PedidoCliente

   ::oViewEdit       := ViewEdit():New( self )

   if !Empty( ::oViewEdit )

      ::oViewEdit:setTextoTipoDocuento( LblTitle( nMode ) + "pedido" )
      
      ::oViewEdit:ResourceViewEdit( nMode )

   end if

Return ( .t. )   

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS PedidoCliente

   local lResult     := .f.

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:setTextoTipoDocuento( LblTitle( nMode ) + " linea de pedido" )
      
      lResult        := ::oViewEditDetail:ResourceViewEditDetail( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS PedidoCliente

   ::hDictionaryMaster      := D():GetPedidoClienteDefaultValue( ::nView )
   ::hDictionaryDetail      := {}

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS PedidoCliente

   ::hDictionaryMaster      := D():GetPedidoClienteById( D():PedidosClientesId( ::nView ), ::nView ) 
   ::hDictionaryDetail      := D():GetPedidoClienteLineas( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD PropiedadesBrowseDetail() CLASS PedidoCliente

   ::oViewEdit:oBrowse:cName  := "Grid pedidos lineas"

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Número"
      :bEditValue             := {|| ::getDataBrowse( "NumeroLinea" ) }
      :cEditPicture           := "9999"
      :nWidth                 := 55
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.   
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Cód"
      :bEditValue             := {|| ::getDataBrowse( "Articulo" ) }
      :nWidth                 := 80
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Descripción"
      :bEditValue             := {|| ::getDataBrowse( "DescripcionArticulo" ) }
      :bFooter                := {|| "Total..." }
      :nWidth                 := 310
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := cNombreCajas()
      :bEditValue             := {|| ::getDataBrowse( "Cajas" ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := cNombreUnidades()
      :bEditValue             := {|| ::getDataBrowse( "Unidades" ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 60
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Und"
      :bEditValue             := {|| nTotNPedCli( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ] ) }
      :cEditPicture           := MasUnd()
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Precio"
      :bEditValue             := {|| nTotUPedCli( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ] ) }
      :cEditPicture           := cPouDiv( hGet( ::hDictionaryMaster, "Divisa" ), D():Divisas( ::nView ) )
      :nWidth                 := 90
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "% Dto."
      :bEditValue             := {|| ::getDataBrowse( "Descuento" ) }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 55
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "% " + cImp()
      :bEditValue             := {|| ::getDataBrowse( "PorcentajeImpuesto" ) }
      :cEditPicture           := "@E 999.99"
      :nWidth                 := 45
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :lHide                  := .t.
   end with

   with object ( ::oViewEdit:oBrowse:AddCol() )
      :cHeader                := "Total"
      :bEditValue             := {|| nTotalLineaPedidoCliente( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ], , , , .t., hGet( ::hDictionaryMaster, "OperarPuntoVerde" ), .t. ) }
      :cEditPicture           := cPouDiv( hGet( ::hDictionaryMaster, "Divisa" ), D():Divisas( ::nView ) )
      :nWidth                 := 94
      :nDataStrAlign          := 1
      :nHeadStrAlign          := 1
      :nFooterType            := AGGR_SUM
   end with

Return ( self )

//---------------------------------------------------------------------------//

METHOD GuardaDocumento( oCbxRuta ) CLASS PedidoCliente

   ApoloMsgStop( "Guardamos el documento Pedidos" )

   ::setUltimoCliente( oCbxRuta )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDetail() CLASS PedidoCliente

   ::hDictionaryDetailTemporal      := D():GetPedidoClienteLineaBlank( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS PedidoCliente

   ::hDictionaryDetailTemporal      := ::hDictionaryDetail[ ::nPosDetail ]

Return ( self )

//---------------------------------------------------------------------------//

METHOD CargaArticulo() CLASS PedidoCliente

   if !Empty( hGet( ::hDictionaryDetailTemporal, "Articulo" ) )

      if ::lSeekArticulo()

         if ::lArticuloObsoleto()
            return .f.
         end if

         ::setCodigoArticulo()

         ::setDetalleArticulo()

         ::setProveedorArticulo()

         ::setLote()

         ::setTipoVenta()

         ::setFamilia()

         ::setPeso()

         ::setVolumen()

         ::setUnidadesMedicion()

      else

         ApoloMsgStop( "Artículo no encontrado" )
         
         Return .f.

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

            /*
            Tratamientos kits-----------------------------------------------------

            if ( D():Articulos( nView ) )->lKitArt

               aTmp[ _LKITART ]        := ( D():Articulos( nView ) )->lKitArt                                  // Marcamos como padre del kit
               aTmp[ _LIMPLIN ]        := lImprimirCompuesto( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )    // 1 Todos, 2 Compuesto
               aTmp[ _LKITPRC ]        := lPreciosCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) ) // 1 Todos, 2 Compuesto

               if lStockCompuestos( ( D():Articulos( nView ) )->Codigo, D():Articulos( nView ) )

                  if aGet[ _NCTLSTK ] != nil
                     aGet[ _NCTLSTK ]:SetOption( ( D():Articulos( nView ) )->nCtlStock )
                  else
                     aTmp[ _NCTLSTK ]  := ( D():Articulos( nView ) )->nCtlStock
                  end if

               else

                  if aGet[ _NCTLSTK ] != nil
                     aGet[ _NCTLSTK ]:SetOption( STOCK_NO_CONTROLAR )
                  else
                     aTmp[ _NCTLSTK ]  := STOCK_NO_CONTROLAR
                  end if

               end if

            else

               aTmp[ _LIMPLIN ]     := .f.

               if aGet[ _NCTLSTK ] != nil
                  aGet[ _NCTLSTK ]:SetOption( ( D():Articulos( nView ) )->nCtlStock )
               else
                  aTmp[ _NCTLSTK ]  := ( D():Articulos( nView ) )->nCtlStock
               end if

            end if


            /*
            Tipo de articulo---------------------------------------------------

            if !Empty( aGet[ _CCODTIP ] )
               aGet[ _CCODTIP ]:cText( ( D():Articulos( nView ) )->cCodTip )
            else
               aTmp[ _CCODTIP ] := ( D():Articulos( nView ) )->cCodTip
            end if

            if (D():Articulos( nView ))->nCajEnt != 0
               aGet[ _NCANPED ]:cText( (D():Articulos( nView ))->nCajEnt )
            end if

            if ( D():Articulos( nView ) )->nUniCaja != 0
               aGet[ _NUNICAJA ]:cText( ( D():Articulos( nView ) )->nUniCaja )
            end if

            /*
            Preguntamos si el regimen de " + cImp() + " es distinto de Exento

            if aTmpPed[ _NREGIVA ] <= 1
               aGet[ _NIVA ]:cText( nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva ) )
               aTmp[ _NREQ ]     := nReq( dbfIva, ( D():Articulos( nView ) )->TipoIva )
            end if

            /*
            Ahora recogemos el impuesto especial si lo hay

            if !Empty( ( D():Articulos( nView ) )->cCodImp )
               aTmp[ _CCODIMP ]  := ( D():Articulos( nView ) )->cCodImp
               if !Empty( aGet[ _NVALIMP ] )
                  aGet[ _NVALIMP ]:cText( oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpPed[ _LIVAINC ], aTmp[ _NIVA ] ) )
               else
                  aTmp[ _NVALIMP ]  := oNewImp:nValImp( ( D():Articulos( nView ) )->cCodImp, aTmpPed[ _LIVAINC ], aTmp[ _NIVA ] )
               end if

               aTmp[ _LVOLIMP ]     := RetFld( ( D():Articulos( nView ) )->cCodImp, oNewImp:oDbf:cAlias, "lIvaVol" )

            end if

            /*
            Buscamos si el articulo tiene factor de conversion--------------------

            if ( D():Articulos( nView ) )->lFacCnv
               aTmp[ _NFACCNV ]     := ( D():Articulos( nView ) )->nFacCnv
            end if

            /*
            Si la comisi¢n del articulo hacia el agente es distinto de cero----

            aGet[ _NCOMAGE ]:cText( aTmpPed[ _NPCTCOMAGE ] )

            /*
            Imagen del producto---------------------------------------------------

            if !Empty( aGet[ _CIMAGEN ] )
               aGet[ _CIMAGEN ]:cText( ( D():Articulos( nView ) )->cImagen )
            else
               aTmp[ _CIMAGEN ]     := ( D():Articulos( nView ) )->cImagen
            end if

            if !Empty( bmpImage )
               if !Empty( aTmp[ _CIMAGEN ] )
                  bmpImage:Show()
                  bmpImage:LoadBmp( cFileBitmap( cPatImg(), aTmp[ _CIMAGEN ] ) )
               else
                  bmpImage:Hide()
               end if
            end if

            /*
            Tomamos el valor del stock y anotamos si nos dejan vender sin stock

            if oStkAct != nil .and. !uFieldEmpresa( "lNStkAct" ) .and. aTmp[ _NCTLSTK ] <= 1
               oStock:nPutStockActual( aTmp[ _CREF ], aTmp[ _CALMLIN ], , , , aTmp[ _LKITART ], aTmp[ _NCTLSTK ], oStkAct )
            end if

            /*
            Buscamos la familia del articulo y anotamos las propiedades-----------

            aTmp[_CCODPR1 ] := ( D():Articulos( nView ) )->cCodPrp1
            aTmp[_CCODPR2 ] := ( D():Articulos( nView ) )->cCodPrp2

            if !Empty( aTmp[ _CCODPR1 ] )

               if aGet[ _CVALPR1 ] != nil
                  aGet[ _CVALPR1 ]:Show()
                  if lFocused
                     aGet[ _CVALPR1 ]:SetFocus()
                  end if
               end if

               if oSayPr1 != nil
                  oSayPr1:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp1, dbfPro ) )
                  oSayPr1:show()
               end if

               if oSayVp1 != nil
                   oSayVp1:SetText( "" )
                   oSayVp1:Show()
               end if
            else

               if !Empty( aGet[ _CVALPR1 ] ) .and. !Empty( oSayPr1 ) .and. !Empty( oSayVp1 )
                  aGet[ _CVALPR1 ]:hide()
                  oSayPr1:hide()
                  oSayVp1:hide()
               end if

            end if

            if !empty( aTmp[_CCODPR2 ] )

               if aGet[ _CVALPR2 ] != nil
                  aGet[ _CVALPR2 ]:show()
               end if

               if oSayPr2 != nil
                  oSayPr2:SetText( retProp( ( D():Articulos( nView ) )->cCodPrp2, dbfPro ) )
                  oSayPr2:show()
               end if

               if oSayVp2 != nil
                   oSayVp2:SetText( "" )
                   oSayVp2:Show()
               end if

            else

               if !Empty( aGet[ _CVALPR2 ] )
                  aGet[_CVALPR2 ]:hide()
               end if

               if !Empty( oSayPr2 )
                  oSayPr2:hide()
               end if

               if !Empty( oSayVp2 )
                  oSayVp2:hide()
               end if

            end if

         end if

         /*
         He terminado de meter todo lo que no son precios ahora es cuando meteré los precios con todas las opciones posibles

         cPrpArt              := aTmp[ _CCODPR1 ] + aTmp[ _CCODPR2 ] + aTmp[ _CVALPR1 ] + aTmp[ _CVALPR2 ]

         if ( lChgCodArt ) .or. ( cPrpArt != cOldPrpArt )

            if nMode == APPD_MODE
               cCodFam        := RetFamArt( aTmp[ _CREF ], D():Articulos( nView ) )
            else
               cCodFam        := aTmp[ _CCODFAM ]
            end if

            /*
            Cargamos el precio-------------------------------------------------

            aTmp[ _NPVPREC ] := (D():Articulos( nView ))->PvpRec

            if !Empty( aGet[_NPNTVER ] )
                aGet[ _NPNTVER ]:cText( ( D():Articulos( nView ) )->NPNTVER1 )
            else
                aTmp [ _NPNTVER ] :=  ( D():Articulos( nView ) )->NPNTVER1
            end if

            /*
            Cargamos los costos------------------------------------------------

            if !uFieldEmpresa( "lCosAct" )
               nCosPro           := oStock:nCostoMedio( aTmp[ _CREF ], aTmp[ _CALMLIN ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _CLOTE ] )
               if nCosPro == 0
                  nCosPro        := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
               end if
            else
               nCosPro           := nCosto( aTmp[ _CREF ], D():Articulos( nView ), dbfKit, .f., , dbfDiv )
            end if

            if aGet[ _NCOSDIV ] != nil
               aGet[ _NCOSDIV ]:cText( nCosPro )
            else
               aTmp[ _NCOSDIV ]  := nCosPro
            end if

            /*
            Descuento de artículo----------------------------------------------

            nNumDto              := RetFld( aTmpPed[ _CCODCLI ], D():Clientes( nView ), "nDtoArt" )

            if nNumDto != 0

               do case
                  case nNumDto == 1

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt1 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt1
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt1
                     end if

                  case nNumDto == 2

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt2 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt2
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt2
                     end if

                  case nNumDto == 3

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO]:cText( ( D():Articulos( nView ) )->nDtoArt3 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt3
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt3
                     end if

                  case nNumDto == 4

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt4 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt4
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt4
                     end if

                  case nNumDto == 5

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO ]:cText( ( D():Articulos( nView ) )->nDtoArt5 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt5
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt5
                     end if

                  case nNumDto == 6

                     if !Empty( aGet[ _NDTO ] )
                        aGet[ _NDTO]:cText( ( D():Articulos( nView ) )->nDtoArt6 )
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt6
                     else
                        aTmp[ _NDTO ]     := ( D():Articulos( nView ) )->nDtoArt6
                     end if

               end case

            end if

            /*
            Vemos si hay descuentos en las familias----------------------------

            if aTmp[ _NDTO ] == 0

               if !Empty( aGet[ _NDTO ] )
                  aGet[ _NDTO ]:cText( nDescuentoFamilia( cCodFam, dbfFamilia ) )
               else
                  aTmp[ _NDTO ]     := nDescuentoFamilia( cCodFam, dbfFamilia )
               end if

            end if

            /*
            Cargamos el codigo de las unidades---------------------------------

            if !Empty( aGet[ _CUNIDAD ] )
               aGet[ _CUNIDAD ]:cText( ( D():Articulos( nView ) )->cUnidad )
            else
               aTmp[ _CUNIDAD ]  := ( D():Articulos( nView ) )->cUnidad
            end if

            //Cargamos el precio del artículo

            nPrePro           := nPrePro( aTmp[ _CREF ], aTmp[ _CCODPR1 ], aTmp[ _CVALPR1 ], aTmp[ _CCODPR2 ], aTmp[ _CVALPR2 ], aTmp[ _NTARLIN ], aTmpPed[ _LIVAINC ], dbfArtDiv, dbfTarPreL, aTmpPed[_CCODTAR] )

            if nPrePro == 0
               aGet[_NPREDIV]:cText( nRetPreArt( aTmp[ _NTARLIN ], aTmpPed[ _CDIVPED ], aTmpPed[ _LIVAINC ], D():Articulos( nView ), dbfDiv, dbfKit, dbfIva ) )
            else
               aGet[_NPREDIV]:cText( nPrePro )
            end if

            if aTmp[ __LALQUILER ]
               aGet[ _NPREDIV ]:cText( 0 )
               aGet[ _NPREALQ ]:cText( nPreAlq( aTmp[ _CREF ], aTmp[ _NTARLIN ], aTmpPed[_LIVAINC], D():Articulos( nView ) ) )
            end if

            /*
            Usando tarifas-----------------------------------------------------

            if !Empty( aTmpPed[_CCODTAR] )

               //--Precio--//
               nImpOfe     := RetPrcTar( aTmp[ _CREF ], aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL, aTmp[ _NTARLIN ] )
               if nImpOfe  != 0
                  aGet[_NPREDIV]:cText( nImpOfe )
               end if

               //--Descuento porcentual--//
               nImpOfe  := RetPctTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTO   ]:cText( nImpOfe )
               end if

               //--Descuento lineal--//
               nImpOfe  := RetLinTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dbfTarPreL )
               if nImpOfe != 0
                  aGet[_NDTODIV]:cText( nImpOfe )
               end if

               //--Comision de agente--//
               nImpOfe  := RetComTar( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], aTmpPed[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nImpOfe != 0
                  aGet[_NCOMAGE ]:cText( nImpOfe )
               end if

               //--Descuento de promoci¢n--//

               nImpOfe  := RetDtoPrm( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dFecPed, dbfTarPreL )
               if nImpOfe  != 0
                  aGet[_NDTOPRM]:cText( nImpOfe )
               end if

               //--Descuento de promocion para el agente--//

               nDtoAge  := RetDtoAge( aTmp[ _CREF ], cCodFam, aTmpPed[_CCODTAR], aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2], dFecPed, aTmpPed[_CCODAGE], dbfTarPreL, dbfTarPreS )
               if nDtoAge  != 0
                  aGet[ _NCOMAGE ]:cText( nDtoAge )
               end if

            end if

            /*
            Chequeamos las atipicas del cliente--------------------------------

            hAtipica := hAtipica( hValue( aTmp, aTmpPed ) )

            if !Empty( hAtipica )
               
                  if hhaskey( hAtipica, "nImporte" )
                     if hAtipica[ "nImporte" ] != 0
                        aGet[ _NPREDIV ]:cText( hAtipica[ "nImporte" ] )
                  end if
                  end if

                  if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. aTmp[ _NDTO ] == 0
                     if hAtipica[ "nDescuentoPorcentual"] != 0
                        aGet[ _NDTO ]:cText( hAtipica[ "nDescuentoPorcentual"] )   
                     end if   
                  end if

                  if hhaskey( hAtipica, "nDescuentoPromocional" ) .and. aTmp[ _NDTOPRM ] == 0
                     if hAtipica[ "nDescuentoPromocional" ] != 0
                        aGet[ _NDTOPRM ]:cText( hAtipica[ "nDescuentoPromocional" ] )
                     end if   
                  end if

                  if hhaskey( hAtipica, "nComisionAgente" ) .and. aTmp[ _NCOMAGE ] == 0
                     if hAtipica[ "nComisionAgente" ] != 0
                        aGet[ _NCOMAGE ]:cText( hAtipica[ "nComisionAgente" ] )
                     end if
                  end if

                  if hhaskey( hAtipica, "nDescuentoLineal" ) .and. aTmp[ _NDTODIV ] == 0
                     if hAtipica[ "nDescuentoLineal" ] != 0
                        aGet[ _NDTODIV ]:cText( hAtipica[ "nDescuentoLineal" ] )
                     end if
                  end if

            end if

            //--Buscamos si existen ofertas para este articulo y le cambiamos el precio--//

            nImpOfe     := nImpOferta( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[ _NTARLIN ], , aTmp[ _CCODPR1 ], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
            if nImpOfe  != 0
               aGet[ _NPREDIV ]:cText( nImpOfe )
            end if

            //--Buscamos si existen descuentos en las ofertas--//

            nImpOfe     := nDtoOferta( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
            if nImpOfe  != 0
               aGet[ _NDTO ]:cText( nImpOfe )
            end if

            //--Buscamos si existen descuentos lineales en las ofertas--//

            nImpOfe     := nDtoLineal( aTmp[ _CREF ], aTmpPed[ _CCODCLI ], aTmpPed[ _CCODGRP ], aTmp[ _NUNICAJA ], dFecPed, dbfOferta, aTmp[_CCODPR1], aTmp[_CCODPR2], aTmp[_CVALPR1], aTmp[_CVALPR2] )
            if nImpOfe  != 0
               if !Empty( aGet[ _NDTODIV ] )
                  aGet[ _NDTODIV ]:cText( nImpOfe )
               else
                  aGet[ _NDTODIV ]  := nImpOfe
               end if
            end if

            ValidaMedicion( aTmp, aGet )

         end if

         /*
         Buscamos si hay ofertas-----------------------------------------------

         lBuscaOferta( aTmp[ _CREF ], aGet, aTmp, aTmpPed, dbfOferta, dbfDiv, dbfKit, dbfIva  )

         /*
         Cargamos los valores para los cambios---------------------------------

         cOldPrpArt := cPrpArt
         cOldCodArt := cCodArt

         /*
         Solo pueden modificar los precios los administradores--------------

         if Empty( aTmp[ _NPREDIV ] ) .or. lUsrMaster() .or. oUser():lCambiarPrecio()

            aGet[ _NPREDIV ]:HardEnable()
            aGet[ _NIMPTRN ]:HardEnable()

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:HardEnable()
            end if

            aGet[ _NDTO    ]:HardEnable()
            aGet[ _NDTOPRM ]:HardEnable()

            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:HardEnable()
            end if

         else

            aGet[ _NPREDIV ]:HardDisable()
            aGet[ _NIMPTRN ]:HardDisable()

            if !Empty( aGet[ _NPNTVER ] )
               aGet[ _NPNTVER ]:HardEnable()
            end if
            aGet[ _NDTO    ]:HardDisable()
            aGet[ _NDTOPRM ]:HardDisable()

            if !Empty( aGet[ _NDTODIV ] )
               aGet[ _NDTODIV ]:HardEnable()
            end if

         end if

      else

         MsgStop( "Artículo no encontrado" )
         Return .f.

      end if

   end if

RETURN .t.*/

//--------------------------------------------------------------------------//
