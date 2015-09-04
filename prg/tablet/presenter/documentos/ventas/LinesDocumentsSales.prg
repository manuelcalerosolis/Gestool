#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS LinesDocumentsSales FROM Editable

   DATA cOldCodigoArticulo          INIT ""

   DATA oViewEditDetail

   METHOD New( oSender )

   METHOD hSetDetail( cField, uValue );
            INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )

   METHOD setCodigoArticulo();
            INLINE ( ::hSetDetail( "Articulo", ( D():Articulos( ::getView() ) )->Codigo ),;
                     ::oViewEditDetail:oGetArticulo:Refresh() )

   METHOD lSeekArticulo()

   METHOD lArticuloObsoleto()

   METHOD setDetalleArticulo();    
            INLINE ( ::hSetDetail( "DescripcionArticulo", ( D():Articulos( ::getView() ) )->Nombre ),;
                     ::hSetDetail( "DescripcionAmpliada", ( D():Articulos( ::getView() ) )->Descrip ),;
                     ::oViewEditDetail:oGetDescripcionArticulo:Refresh() )

   METHOD setProveedorArticulo()

   METHOD setLote()

   METHOD setTipoVenta();
            INLINE ( ::hSetDetail( "AvisarSinStock", ( D():Articulos( ::getView() ) )->lMsgVta ),;
                     ::hSetDetail( "NoPermitirSinStock", ( D():Articulos( ::getView() ) )->lNotVta ) )

   METHOD setFamilia();
            INLINE ( ::hSetDetail( "Familia", ( D():Articulos( ::getView() ) )->Familia ),;
                     ::hSetDetail( "GrupoFamilia", cGruFam( ( D():Articulos( ::getView() ) )->Familia, D():Familias( ::getView() ) ) ) )

   METHOD setPeso();
            INLINE ( ::hSetDetail( "Peso", ( D():Articulos( ::getView() ) )->nPesoKg ),;
                     ::hSetDetail( "UnidadMedicionPeso", ( D():Articulos( ::getView() ) )->cUndDim ) )

   METHOD setVolumen();
            INLINE ( ::hSetDetail( "Volumen", ( D():Articulos( ::getView() ) )->nVolumen ),;
                     ::hSetDetail( "UnidadMedicionVolumen", ( D():Articulos( ::getView() ) )->cVolumen ) )

   METHOD setUnidadMedicion();
            INLINE ( ::hSetDetail( "UnidadMedicion", ( D():Articulos( ::getView() ) )->cUnidad ) )

   METHOD setTipoArticulo();
            INLINE ( ::hSetDetail( "TipoArticulo", ( D():Articulos( ::getView() ) )->cCodTip ) )

   METHOD setCajas();
            INLINE ( iif( !Empty( ( D():Articulos( ::getView() ) )->nCajEnt ), ::hSetDetail( "Cajas", ( D():Articulos( ::getView() ) )->nCajEnt ), ::hSetDetail( "Cajas", 1 ) ) )

   METHOD setUnidades();
            INLINE ( iif( !Empty( ( D():Articulos( ::getView() ) )->nUniCaja ), ::hSetDetail( "Unidades", ( D():Articulos( ::getView() ) )->nUniCaja ), ::hSetDetail( "Unidades", 1 ) ) )

   METHOD getValorImpuestoEspecial();
            INLINE ( D():ImpuestosEspeciales( ::getView() ):nValImp( ( D():Articulos( ::getView() ) )->cCodImp,;
                     hGet( ::oSender:hDictionaryMaster, "ImpuestosIncluidos" ),;
                     hGet( ::oSender:oDocumentLineTemporal:hDictionary, "TipoImpuesto" ) ) )

   METHOD SetImpuestoEspecial()

   METHOD SetTipoImpuesto()

   METHOD SetFactorConversion();
            INLINE ( iif( ( D():Articulos( ::getView() ) )->lFacCnv, ::hSetDetail( "FactorConversion", ( D():Articulos( ::getView() ) )->nFacCnv ), ) )

   METHOD SetImagenProducto();
            INLINE ( ::hSetDetail( "Imagen", ( D():Articulos( ::getView() ) )->cImagen ) )

   METHOD SetControlStock();
            INLINE ( ::hSetDetail( "TipoStock", ( D():Articulos( ::getView() ) )->nCtlStock ) )

   METHOD SetPrecioRecomendado();
            INLINE ( ::hSetDetail( "PrecioVentaRecomendado", ( D():Articulos( ::getView() ) )->PvpRec ) )

   METHOD SetPuntoVerde();
            INLINE ( ::hSetDetail( "PuntoVerde", ( D():Articulos( ::getView() ) )->nPntVer1 ) )

   METHOD SetUnidadMedicion();
            INLINE ( ::hSetDetail( "UnidadMedicion", ( D():Articulos( ::getView() ) )->cUnidad ) )

   METHOD SetPrecioCosto()
      METHOD SetPrecioCostoMedio()                          VIRTUAL         

   METHOD SetPrecioVenta()
      METHOD SetPrecioArticulo
      METHOD SetPrecioTarifaCliente                         VIRTUAL      
      METHOD SetPrecioAtipicaCliente                        VIRTUAL     
      METHOD SetPrecioOfertaArticulo                        VIRTUAL      

   METHOD SetComisionAgente() 
      METHOD SetComisionMaster()          INLINE ( ::hSetDetail( "ComisionAgente", hGet( ::oSender:hDictionaryMaster, "ComisionAgente" ) ) )
      METHOD SetComisionTarifaCliente()                     VIRTUAL   
      METHOD SetComisionAtipicaCliente()                    VIRTUAL

   METHOD SetDescuentoPorcentual()
      METHOD SetDescuentoPorcentualArticulo();
            INLINE ( ::hSetDetail( "DescuentoPorcentual", nDescuentoArticulo( hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" ), hGet( ::oSender:hDictionaryMaster, "Cliente" ), ::getView() ) ) )

      METHOD SetDescuentoPorcentualTarifaCliente()          VIRTUAL
      METHOD SetDescuentoPorcentualAtipicaCliente()         VIRTUAL
      METHOD SetDescuentoPorcentualOfertaArticulo()         VIRTUAL

   METHOD SetDescuentoPromocional()
      METHOD SetDescuentoPromocionalTarifaCliente()         VIRTUAL
      METHOD SetDescuentoPromocionalAtipicaCliente()        Virtual

   METHOD SetDescuentoLineal()
      METHOD SetDescuentoLinealTarifaCliente()              VIRTUAL       
      METHOD SetDescuentoLinealAtipicaCliente()             VIRTUAL
      METHOD SetDescuentoLinealOfertaArticulo()             VIRTUAL

   METHOD runGridProduct()

   METHOD CargaArticulo()
   METHOD resetCodigoArticulo()                             INLINE ( ::cOldCodigoArticulo := "" )

   METHOD lShowLote()   INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, "LogicoLote" ) )

   METHOD StartResourceDetail()

   METHOD recalcularTotal()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS LinesDocumentsSales

   ::oSender      := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD lSeekArticulo() CLASS LinesDocumentsSales

   local cCodigoArticulo     := ::oViewEditDetail:oGetArticulo:varGet()   //hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )

   if empty( cCodigoArticulo )
      Return .f.
   end if

   cCodigoArticulo           := cSeekCodebarView( cCodigoArticulo, ::getView() )

Return ( dbSeekArticuloUpperLower( cCodigoArticulo, ::getView() ) )

//---------------------------------------------------------------------------//

METHOD lArticuloObsoleto() CLASS LinesDocumentsSales

   if !( D():Articulos( ::getView() ) )->lObs
      Return .f.
   end if

   ApoloMsgStop( "Artículo catalogado como obsoleto" )

   ::oViewEditDetail:oGetArticulo:SetFocus()

Return .t.

//---------------------------------------------------------------------------//   

METHOD setProveedorArticulo() CLASS LinesDocumentsSales

   local cRefProveedor
   
   cRefProveedor     := Padr( cRefPrvArt( ( D():Articulos( ::getView() ) )->Codigo, ( D():Articulos( ::getView() ) )->cPrvHab , D():ProveedorArticulo( ::getView() ) ) , 18 )

   ::hSetDetail( "Proveedor", ( D():Articulos( ::getView() ) )->cPrvHab )
   ::hSetDetail( "NombreProveedor", RetFld( ( D():Articulos( ::getView() ) )->cPrvHab, D():Proveedores( ::getView() ) ) )
   ::hSetDetail( "ReferenciaProveedor", cRefProveedor )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setLote() CLASS LinesDocumentsSales

   if ( D():Articulos( ::getView() ) )->lLote

      ::hSetDetail( "LogicoLote", ( D():Articulos( ::getView() ) )->lLote )
      ::hSetDetail( "Lote", ( D():Articulos( ::getView() ) )->cLote )

      ::oViewEditDetail:ShowLote()

   else

      ::oViewEditDetail:HideLote()

   end if

   ::oViewEditDetail:RefreshLote()

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetTipoImpuesto() CLASS LinesDocumentsSales

   if hGet( ::oSender:hDictionaryMaster, "TipoImpuesto" ) <= 1
      ::hSetDetail( "PorcentajeImpuesto", nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
      ::hSetDetail( "RecargoEquivalencia", nReq( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetImpuestoEspecial() CLASS LinesDocumentsSales

   if !Empty( ( D():Articulos( ::getView() ) )->cCodImp )

      ::hSetDetail( "ImpuestoEspecial", ( D():Articulos( ::getView() ) )->cCodImp )
      ::hSetDetail( "ImporteImpuestoEspecial", ::getValorImpuestoEspecial() )
      ::hSetDetail( "VolumenImpuestosEspeciales", RetFld( ( D():Articulos( ::getView() ) )->cCodImp, D():ImpuestosEspeciales( ::getView() ):cAlias, "lIvaVol" ) )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetPrecioCosto() CLASS LinesDocumentsSales

   local nCosto   := nCosto(  hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" ),;
                              D():Articulos( ::getView() ),;
                              D():Kit( ::getView() ),;
                              .f., ,;
                              D():Divisas( ::getView() ) )


   ::hSetDetail( "PrecioCosto", nCosto )

   if !uFieldEmpresa( "lCosAct" )
      ::SetPrecioCostoMedio()       //Método Virtual no creado
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetPrecioVenta() CLASS LinesDocumentsSales

   ::SetPrecioArticulo()
   ::SetPrecioTarifaCliente()    //Método Virtual no creado
   ::SetPrecioAtipicaCliente()   //Método Virtual no creado
   ::SetPrecioOfertaArticulo()   //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetPrecioArticulo CLASS LinesDocumentsSales

   local nPrecio   := nRetPreArt(   hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Tarifa" ),;
                                    hGet( ::oSender:hDictionaryMaster, "Divisa" ),;
                                    hGet( ::oSender:hDictionaryMaster, "ImpuestosIncluidos" ),;
                                    D():Articulos( ::getView() ),;
                                    D():Divisas( ::getView() ),;
                                    D():Kit( ::getView() ),;
                                    D():TiposIva( ::getView() ) )

   ::hSetDetail( "PrecioVenta", nPrecio )

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetComisionAgente() CLASS LinesDocumentsSales

   ::SetComisionMaster()
   ::SetComisionTarifaCliente()     //Método Virtual no creado
   ::SetComisionAtipicaCliente()    //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuentoPorcentual() CLASS LinesDocumentsSales

   ::SetDescuentoPorcentualArticulo()
   ::SetDescuentoPorcentualTarifaCliente()   //Método Virtual no creado
   ::SetDescuentoPorcentualAtipicaCliente()  //Método Virtual no creado
   ::SetDescuentoPorcentualOfertaArticulo()  //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuentoPromocional() CLASS LinesDocumentsSales

   ::SetDescuentoPromocionalTarifaCliente()     //Método Virtual no creado
   ::SetDescuentoPromocionalAtipicaCliente()    //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuentoLineal() CLASS LinesDocumentsSales

   ::SetDescuentoLinealTarifaCliente()       //Método Virtual no creado
   ::SetDescuentoLinealAtipicaCliente()      //Método Virtual no creado
   ::SetDescuentoLinealOfertaArticulo()      //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD CargaArticulo() CLASS LinesDocumentsSales

   local cCodArt  := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )

   if Empty( cCodArt )
      Return .f.
   end if

   if ( cCodArt == ::cOldCodigoArticulo )
      Return .f.
   end if

   if !::lSeekArticulo()
      apoloMsgStop( "Artículo no encontrado" )
      Return .f.
   end if

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

   ::setUnidadMedicion()

   ::setTipoArticulo()

   ::SetCajas()

   ::SetUnidades()

   ::SetImpuestoEspecial()

   ::SetTipoImpuesto()

   ::SetFactorConversion()

   ::SetImagenProducto()

   ::SetPrecioRecomendado()

   ::SetPuntoVerde()

   ::SetUnidadMedicion()

   ::SetPrecioCosto()

   ::SetPrecioVenta()

   ::SetComisionAgente()

   ::SetDescuentoPorcentual()

   ::SetDescuentoPromocional()

   ::SetDescuentoLineal()

   ::cOldCodigoArticulo    := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )

   /*
   Refrescamos el diálogo, una vez insertado los datos-------------------------
   */

   ::oViewEditDetail:RefreshDialog()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD StartResourceDetail() CLASS LinesDocumentsSales

   ::cargaArticulo()

   ::recalcularTotal()

Return ( self )

//---------------------------------------------------------------------------//

METHOD recalcularTotal() CLASS LinesDocumentsSales

   if !empty( ::oViewEditDetail:oTotalLinea )
      ::oViewEditDetail:oTotalLinea:cText( ::oSender:oDocumentLineTemporal:Total() )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runGridProduct() CLASS LinesDocumentsSales

   ::oViewEditDetail:oGetArticulo:Disable()

   if !empty( ::oSender:oProduct:oGridProduct )

      ::oSender:oProduct:oGridProduct:showView()

      if ::oSender:oProduct:oGridProduct:isEndOk()
         ::oViewEditDetail:SetGetValue( ( D():Articulos( ::oSender:nView ) )->Codigo, "Articulo" )
      end if

      ::cargaArticulo()

      ::recalcularTotal()

   end if

   ::oViewEditDetail:oGetArticulo:Enable()
   ::oViewEditDetail:oGetArticulo:setFocus()

Return ( self )

//---------------------------------------------------------------------------//
