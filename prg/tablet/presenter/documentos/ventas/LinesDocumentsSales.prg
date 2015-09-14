#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS LinesDocumentsSales FROM Editable

   DATA cOldCodigoArticulo             INIT ""

   DATA hAtipicaClienteValues

   DATA oViewEditDetail

   METHOD New( oSender )

   METHOD hSetDetail( cField, uValue );
            INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )

   METHOD hGetDetail( cField );
            INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD lSeekArticulo()

   METHOD setCodigo( cCodigo )         INLINE ( ::hSetDetail( "Articulo", cCodigo ),;
                                                ::oViewEditDetail:oGetArticulo:Refresh() )
   METHOD setCodigoFromArticulo()      INLINE ( ::setCodigo( ( D():Articulos( ::getView() ) )->Codigo ) )


   METHOD setDetalle( cDetalle )       INLINE ( ::hSetDetail( "DescripcionArticulo", ( D():Articulos( ::getView() ) )->Nombre ),;
                                                ::oViewEditDetail:oGetDescripcionArticulo:Refresh() )
   METHOD setDetalleFromArticulo()     INLINE ( ::setDetalle( ( D():Articulos( ::getView() ) )->Nombre ) )

   METHOD setDescripcionAmpliada( cDescripcion )   INLINE ( ::hSetDetail( "DescripcionAmpliada", cDescripcion ) )
   METHOD setDescripcionAmpliadaFromArticulo()     INLINE ( ::setDescripcionAmpliada( ( D():Articulos( ::getView() ) )->Descrip ) )

   METHOD lArticuloObsoleto()

   METHOD setCodigoProveedor( cCodigo )            INLINE ( ::hSetDetail( "Proveedor", cCodigo ) )
   METHOD setCodigoProveedorFromArticulo()         INLINE ( ::setCodigoProveedor( ( D():Articulos( ::getView() ) )->cPrvHab ) )

   METHOD setNombreProveedor( cNombreProveedor )   INLINE ( ::hSetDetail( "NombreProveedor", cNombreProveedor ) )
   METHOD setNombreProveedorFromArticulo()         INLINE ( ::setNombreProveedor( retFld( ( D():Articulos( ::getView() ) )->cPrvHab, D():Proveedores( ::getView() ) ) ) )

   METHOD setReferenciaProveedor( cRefProveedor )  INLINE ( ::hSetDetail( "ReferenciaProveedor", cRefProveedor ) )
   METHOD setReferenciaProveedorFromArticulo()     INLINE ( ::setReferenciaProveedor( padr( cRefPrvArt( ( D():Articulos( ::getView() ) )->Codigo, ( D():Articulos( ::getView() ) )->cPrvHab , D():ProveedorArticulo( ::getView() ) ), 18 ) ) )

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

   METHOD setImpuestoEspecial()

   METHOD setTipoImpuesto()

   METHOD setFactorConversion();
            INLINE ( iif( ( D():Articulos( ::getView() ) )->lFacCnv, ::hSetDetail( "FactorConversion", ( D():Articulos( ::getView() ) )->nFacCnv ), ) )

   METHOD setImagenProducto();
            INLINE ( ::hSetDetail( "Imagen", ( D():Articulos( ::getView() ) )->cImagen ) )

   METHOD setControlStock();
            INLINE ( ::hSetDetail( "TipoStock", ( D():Articulos( ::getView() ) )->nCtlStock ) )

   METHOD setPrecioRecomendado();
            INLINE ( ::hSetDetail( "PrecioVentaRecomendado", ( D():Articulos( ::getView() ) )->PvpRec ) )

   METHOD setPuntoVerde();
            INLINE ( ::hSetDetail( "PuntoVerde", ( D():Articulos( ::getView() ) )->nPntVer1 ) )

   METHOD setUnidadMedicion();
            INLINE ( ::hSetDetail( "UnidadMedicion", ( D():Articulos( ::getView() ) )->cUnidad ) )

   METHOD setPrecioCosto()
      METHOD setPrecioCostoMedio()                          VIRTUAL         

      METHOD setPrecioVenta( nPrecioVenta )                 INLINE ( ::hSetDetail( "PrecioVenta", nPrecioVenta  ) )
      METHOD setPrecioVentaFromArticulo()

      METHOD setPrecioTarifaCliente()                       VIRTUAL      
      METHOD setAtipicasCliente()    
         METHOD buildAtipicaClienteValues()                  
      METHOD setPrecioOfertaArticulo()                      VIRTUAL      

   METHOD setComisionAgente() 
      METHOD setComisionMaster();
            INLINE ( ::hSetDetail( "ComisionAgente", hGet( ::oSender:hDictionaryMaster, "ComisionAgente" ) ) )

      METHOD setComisionTarifaCliente()                     VIRTUAL   
      METHOD setComisionAtipicaCliente()                    VIRTUAL

   METHOD setDescuentoPorcentual( nDescuentoPorcentual )    INLINE ( ::hSetDetail( "DescuentoPorcentual", nDescuentoPorcentual ) )
   METHOD setDescuentoPorcentualFromCliente()               INLINE ( ::setDescuentoPorcentual( nDescuentoArticulo( hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" ), hGet( ::oSender:hDictionaryMaster, "Cliente" ), ::getView() ) ) )

      METHOD setDescuentoPorcentualTarifaCliente()          VIRTUAL
      METHOD setDescuentoPorcentualAtipicaCliente()         VIRTUAL
      METHOD setDescuentoPorcentualOfertaArticulo()         VIRTUAL

   METHOD setDescuentoPromocional()
      METHOD setDescuentoPromocionalTarifaCliente()         VIRTUAL
      METHOD setDescuentoPromocionalAtipicaCliente()        Virtual

   METHOD setDescuentoLineal( nDescuentoLineal )            INLINE ( ::hSetDetail( "DescuentoLineal", nDescuentoLineal ) )
   METHOD resetDescuentoLineal()                            INLINE ( ::setDescuentoLineal( 0 ) )
      METHOD setDescuentoLinealTarifaCliente()              VIRTUAL       
      METHOD setDescuentoLinealAtipicaCliente()             VIRTUAL
      METHOD setDescuentoLinealOfertaArticulo()             VIRTUAL

   METHOD runGridProduct()

   METHOD CargaArticulo()
   METHOD resetCodigoArticulo()                             INLINE ( ::cOldCodigoArticulo := "" )

   METHOD lShowLote()                                       INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, "LogicoLote" ) )

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

METHOD setTipoImpuesto() CLASS LinesDocumentsSales

   if hGet( ::oSender:hDictionaryMaster, "TipoImpuesto" ) <= 1
      ::hSetDetail( "PorcentajeImpuesto", nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
      ::hSetDetail( "RecargoEquivalencia", nReq( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setImpuestoEspecial() CLASS LinesDocumentsSales

   if !Empty( ( D():Articulos( ::getView() ) )->cCodImp )

      ::hSetDetail( "ImpuestoEspecial", ( D():Articulos( ::getView() ) )->cCodImp )
      ::hSetDetail( "ImporteImpuestoEspecial", ::getValorImpuestoEspecial() )
      ::hSetDetail( "VolumenImpuestosEspeciales", RetFld( ( D():Articulos( ::getView() ) )->cCodImp, D():ImpuestosEspeciales( ::getView() ):cAlias, "lIvaVol" ) )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setPrecioCosto() CLASS LinesDocumentsSales

   local nCosto   := nCosto(  hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" ),;
                              D():Articulos( ::getView() ),;
                              D():Kit( ::getView() ),;
                              .f., ,;
                              D():Divisas( ::getView() ) )


   ::hSetDetail( "PrecioCosto", nCosto )

   if !uFieldEmpresa( "lCosAct" )
      ::setPrecioCostoMedio()       //Método Virtual no creado
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setPrecioVentaFromArticulo() CLASS LinesDocumentsSales

   local nPrecioArticulo   := nRetPreArt( hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Tarifa" ),;
                                          hGet( ::oSender:hDictionaryMaster, "Divisa" ),;
                                          hGet( ::oSender:hDictionaryMaster, "ImpuestosIncluidos" ),;
                                          D():Articulos( ::getView() ),;
                                          D():Divisas( ::getView() ),;
                                          D():Kit( ::getView() ),;
                                          D():TiposIva( ::getView() ) )

   ::setPrecioVenta( nPrecioArticulo )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setAtipicasCliente() CLASS LinesDocumentsSales

   local hAtipica    := hAtipica( ::buildAtipicaClienteValues() )

   if empty( hAtipica )
      Return ( self )
   end if 

   if hhaskey( hAtipica, "nImporte" ) .and. hget( hAtipica, "nImporte" ) != 0
      ::setPrecioVenta( hget( hAtipica, "nImporte" ) )
   end if

   if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. hget( hAtipica, "nDescuentoPorcentual" ) != 0 // .and. ::hGetDetail( "DescuentoPorcentual" ) == 0
      ::setDescuentoPorcentual( hget( hAtipica, "nDescuentoPorcentual" ) )   
   end if

   if hhaskey( hAtipica, "nDescuentoLineal" ) .and. hget( hAtipica, "nDescuentoLineal" ) != 0 // .and. ::hGetDetail( "DescuentoLineal" ) == 0
      ::setDescuentoLineal( hget( hAtipica, "nDescuentoLineal" ) )   
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD buildAtipicaClienteValues() CLASS LinesDocumentsSales

   local hAtipicaClienteValues                  := {=>}
   
   hAtipicaClienteValues[ "nView"             ] := ::getView()

   hAtipicaClienteValues[ "cCodigoArticulo"   ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )
   hAtipicaClienteValues[ "cCodigoPropiedad1" ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "CodigoPropiedad1" )
   hAtipicaClienteValues[ "cCodigoPropiedad2" ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "CodigoPropiedad2" )
   hAtipicaClienteValues[ "cValorPropiedad1"  ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "ValorPropiedad1" )
   hAtipicaClienteValues[ "cValorPropiedad2"  ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "ValorPropiedad2" )
   hAtipicaClienteValues[ "cCodigoFamilia"    ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Familia" )
   hAtipicaClienteValues[ "nTarifaPrecio"     ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Tarifa" )
   hAtipicaClienteValues[ "nCajas"            ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Cajas" )
   hAtipicaClienteValues[ "nUnidades"         ] := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Unidades" )

   hAtipicaClienteValues[ "cCodigoCliente"    ] := hGet( ::oSender:hDictionaryMaster, "Cliente" )   
   hAtipicaClienteValues[ "cCodigoGrupo"      ] := hGet( ::oSender:hDictionaryMaster, "GrupoCliente" )   
   hAtipicaClienteValues[ "lIvaIncluido"      ] := hGet( ::oSender:hDictionaryMaster, "ImpuestosIncluidos" )   
   hAtipicaClienteValues[ "dFecha"            ] := hGet( ::oSender:hDictionaryMaster, "Fecha" )   
   hAtipicaClienteValues[ "nDescuentoTarifa"  ] := hGet( ::oSender:hDictionaryMaster, "DescuentoTarifa" )   

Return ( hAtipicaClienteValues )

//---------------------------------------------------------------------------//

METHOD setComisionAgente() CLASS LinesDocumentsSales

   ::setComisionMaster()
   ::setComisionTarifaCliente()     //Método Virtual no creado
   ::setComisionAtipicaCliente()    //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD setDescuentoPromocional() CLASS LinesDocumentsSales

   ::setDescuentoPromocionalTarifaCliente()     //Método Virtual no creado
   ::setDescuentoPromocionalAtipicaCliente()    //Método Virtual no creado

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

   ::resetDescuentoLineal()

   ::setCodigoFromArticulo()

   ::setDetalleFromArticulo()

   ::setDescripcionAmpliadaFromArticulo()

   ::setCodigoProveedorFromArticulo()
   
   ::setNombreProveedorFromArticulo()

   ::setReferenciaProveedorFromArticulo()

   ::setLote()

   ::setTipoVenta()

   ::setFamilia()

   ::setPeso()

   ::setVolumen()

   ::setUnidadMedicion()

   ::setTipoArticulo()

   ::setCajas()

   ::setUnidades()

   ::setImpuestoEspecial()

   ::setTipoImpuesto()

   ::setFactorConversion()

   ::setImagenProducto()

   ::setPrecioRecomendado()

   ::setPuntoVerde()

   ::setUnidadMedicion()

   ::setPrecioCosto()

   ::setComisionAgente()

   ::setPrecioVentaFromArticulo()

   ::setDescuentoPorcentualFromCliente()

   // Situaciones atipicas del cliente siempre despues de cargar precios-------

   ::setAtipicasCliente()

   ::cOldCodigoArticulo    := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )

   // Refrescamos el diálogo, una vez insertado los datos----------------------

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
