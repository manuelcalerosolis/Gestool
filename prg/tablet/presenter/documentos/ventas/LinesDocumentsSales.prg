#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS LinesDocumentsSales FROM Editable

   DATA cOldCodigoArticulo             INIT ""

   DATA hAtipicaClienteValues

   DATA oViewEditDetail

   METHOD New( oSender )

   METHOD hSetMaster( cField, uValue ) INLINE ( hSet( ::oSender:hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )         INLINE ( hGet( ::oSender:hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue ) INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )         INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD lSeekArticulo()

   METHOD setCodigo( cCodigo )         INLINE ( ::hSetDetail( "Articulo", cCodigo ), ::oViewEditDetail:refreshGetArticulo() )

   METHOD setDetalle( cDetalle )       INLINE ( ::hSetDetail( "DescripcionArticulo", cDetalle ), ::oViewEditDetail:refreshGetDescripcion() )

   METHOD setDescripcionAmpliada( cDescripcion )   INLINE ( ::hSetDetail( "DescripcionAmpliada", cDescripcion ) )

   METHOD lArticuloObsoleto()

   METHOD setCodigoProveedor( cCodigo )            INLINE ( ::hSetDetail( "Proveedor", cCodigo ) )

   METHOD setNombreProveedor( cNombreProveedor )   INLINE ( ::hSetDetail( "NombreProveedor", cNombreProveedor ) )

   METHOD setReferenciaProveedor( cRefProveedor )  INLINE ( ::hSetDetail( "ReferenciaProveedor", cRefProveedor ) )

   METHOD setLogicoLote( lLote )                   INLINE ( ::hSetDetail( "LogicoLote", ( D():Articulos( ::getView() ) )->lLote ) )
   METHOD setLote( cLote )                         INLINE ( ::hSetDetail( "Lote", ( D():Articulos( ::getView() ) )->cLote ) )

   METHOD setTipoVenta( lTipoVenta )                     INLINE ( ::hSetDetail( "AvisarSinStock", lTipoVenta ) )
   METHOD setNoPermitirVentaSinStock( lVentaSinStock )   INLINE ( ::hSetDetail( "NoPermitirSinStock", lVentaSinStock ) )

   METHOD setFamilia( cCodigoFamilia )                   INLINE ( ::hSetDetail( "Familia", cCodigoFamilia ) )
   METHOD setGrupoFamilia( cGrupoFamilia )               INLINE ( ::hSetDetail( "GrupoFamilia", cGrupoFamilia ) )

   METHOD setPeso( nPeso )                               INLINE ( ::hSetDetail( "Peso", nPeso ) )
   METHOD setUnidadMedicionPeso( cUnidadMedicion )       INLINE ( ::hSetDetail( "UnidadMedicionPeso", cUnidadMedicion ) )

   METHOD setVolumen( nVolumen )                         INLINE ( ::hSetDetail( "Volumen", nVolumen ) )
   METHOD setUnidadMedicionVolumen( cVolumen )           INLINE ( ::hSetDetail( "UnidadMedicionVolumen", cVolumen ) )

   METHOD setUnidadMedicion( cUnidadMedicion )           INLINE ( ::hSetDetail( "UnidadMedicion", cUnidadMedicion ) )

   METHOD setTipoArticulo( cTipoArticulo )               INLINE ( ::hSetDetail( "TipoArticulo", cTipoArticulo ) )

   METHOD setCajas( nCajas )                          INLINE ( ::hSetDetail( "Cajas", if( empty( nCajas ), 1, nCajas ) ) )
   METHOD setUnidades( nUnidades )                    INLINE ( ::hSetDetail( "Unidades", if( empty( nUnidades ), 1, nUnidades ) ) )

   METHOD getValorImpuestoEspecial();
      INLINE ( D():ImpuestosEspeciales( ::getView() ):nValImp( ( D():Articulos( ::getView() ) )->cCodImp, ::hGetMaster( "ImpuestosIncluidos" ), ::hGetMaster( "TipoImpuesto" ) ) )

   METHOD setImpuestoEspecial( cCodigoImpuesto )      INLINE ( ::hSetDetail( "ImpuestoEspecial", cCodigoImpuesto ) )
   METHOD setImporteImpuestoEspecial( nImporte )      INLINE ( ::hSetDetail( "ImporteImpuestoEspecial", nImporte ) )
   METHOD setVolumenImpuestosEspeciales( lImpuesto )  INLINE ( ::hSetDetail( "VolumenImpuestosEspeciales", lImpuesto ) )

   METHOD setPorcentajeImpuesto( nPorcentaje )        INLINE ( ::hSetDetail( "PorcentajeImpuesto", nPorcentaje ) )
   METHOD setRecargoEquivalencia( nPorcentaje )       INLINE ( ::hSetDetail( "RecargoEquivalencia", nPorcentaje ) )

   METHOD setFactorConversion( nFactor )              INLINE ( ::hSetDetail( "FactorConversion", nFactor ) )

   METHOD setImagen( cImagen )                        INLINE ( ::hSetDetail( "Imagen", cImagen ) )

   METHOD setControlStock( nControlStock )            INLINE ( ::hSetDetail( "TipoStock", nControlStock ) )

   METHOD setPrecioRecomendado( nPrecio )             INLINE ( ::hSetDetail( "PrecioVentaRecomendado", nPrecio ) )

   METHOD setPuntoVerde( nPuntoVerde )                INLINE ( ::hSetDetail( "PuntoVerde", nPuntoVerde ) )

   METHOD setUnidadMedicion( cUnidad )                INLINE ( ::hSetDetail( "UnidadMedicion", cUnidad ) )

   METHOD setPrecioCosto( nCosto )                    INLINE ( ::hSetDetail( "PrecioCosto", nCosto ) )
      METHOD setPrecioCostoMedio()                    VIRTUAL         

   METHOD setPrecioVenta( nPrecioVenta )              INLINE ( ::hSetDetail( "PrecioVenta", nPrecioVenta  ) )

   METHOD setPrecioTarifaCliente()                    VIRTUAL      
   
   METHOD setAtipicasCliente()    
      METHOD buildAtipicaClienteValues()                  

      METHOD setPrecioOfertaArticulo()                VIRTUAL      

   METHOD setComisionFromMaster()                         INLINE ( ::hSetDetail( "ComisionAgente", ::hGetMaster( "ComisionAgente" ) ) )

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

   METHOD resetCodigoArticulo()                             INLINE ( ::cOldCodigoArticulo := "" )
   
   METHOD cargaArticulo()

   METHOD setLineFromArticulo() 

   METHOD lShowLote()                                       INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, "LogicoLote" ) )

   METHOD startResourceDetail()

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

METHOD setDescuentoPromocional() CLASS LinesDocumentsSales

   ::setDescuentoPromocionalTarifaCliente()     //Método Virtual no creado
   ::setDescuentoPromocionalAtipicaCliente()    //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD setLineFromArticulo() CLASS LinesDocumentsSales
   
   ::setCodigo( ( D():Articulos( ::getView() ) )->Codigo )
   
   ::setDetalle( ( D():Articulos( ::getView() ) )->Nombre )
   ::setDescripcionAmpliada( ( D():Articulos( ::getView() ) )->Descrip )
   
   ::setCodigoProveedor( ( D():Articulos( ::getView() ) )->cPrvHab )
   ::setNombreProveedor( retFld( ( D():Articulos( ::getView() ) )->cPrvHab, D():Proveedores( ::getView() ) ) )
   ::setReferenciaProveedor( padr( cRefPrvArt( ( D():Articulos( ::getView() ) )->Codigo, ( D():Articulos( ::getView() ) )->cPrvHab , D():ProveedorArticulo( ::getView() ) ), 18 ) )
   
   ::setTipoVenta( ( D():Articulos( ::getView() ) )->lMsgVta )
   
   ::setNoPermitirVentaSinStock( ( D():Articulos( ::getView() ) )->lNotVta )

   ::setFamilia( ( D():Articulos( ::getView() ) )->Familia )
   ::setGrupoFamilia( cGruFam( ( D():Articulos( ::getView() ) )->Familia, D():Familias( ::getView() ) ) )

   ::setPeso( ( D():Articulos( ::getView() ) )->nPesoKg )
   ::setUnidadMedicionPeso( ( D():Articulos( ::getView() ) )->cUndDim ) 

   ::setVolumen( ( D():Articulos( ::getView() ) )->nVolumen )
   ::setUnidadMedicionVolumen( ( D():Articulos( ::getView() ) )->cVolumen ) 
   ::setUnidadMedicion( ( D():Articulos( ::getView() ) )->cUnidad ) 

   ::setTipoArticulo( ( D():Articulos( ::getView() ) )->cCodTip ) 

   ::setCajas( ( D():Articulos( ::getView() ) )->nCajEnt )
   ::setUnidades( ( D():Articulos( ::getView() ) )->nUniCaja )

   ::setImpuestoEspecial( ( D():Articulos( ::getView() ) )->cCodImp )
   ::setImporteImpuestoEspecial( ::getValorImpuestoEspecial() )

   ::setVolumenImpuestosEspeciales( retFld( ( D():Articulos( ::getView() ) )->cCodImp, D():ImpuestosEspeciales( ::getView() ):Select(), "lIvaVol" ) )

   if ::hGetMaster( "TipoImpuesto" ) <= 1
      ::setPorcentajeImpuesto( nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
      ::setRecargoEquivalencia( nReq( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
   end if 

   if ( D():Articulos( ::getView() ) )->lFacCnv
      ::setFactorConversion( ( D():Articulos( ::getView() ) )->nFacCnv )
   end if

   ::setImagen( ( D():Articulos( ::getView() ) )->cImagen ) 

   ::setControlStock( ( D():Articulos( ::getView() ) )->nCtlStock ) 

   ::setPrecioRecomendado( ( D():Articulos( ::getView() ) )->PvpRec ) 

   ::setPuntoVerde( ( D():Articulos( ::getView() ) )->nPntVer1 ) 

   ::setUnidadMedicion( ( D():Articulos( ::getView() ) )->cUnidad ) 

   ::setPrecioVenta( nRetPreArt( ::hGetDetail( "Tarifa" ), ::hGetMaster( "Divisa" ), ::hGetMaster( "ImpuestosIncluidos" ), D():Articulos( ::getView() ), D():Divisas( ::getView() ), D():Kit( ::getView() ), D():TiposIva( ::getView() ) ) )

   if ( D():Articulos( ::getView() ) )->lLote
      ::setLogicoLote( ( D():Articulos( ::getView() ) )->lLote )
      ::setLote( ( D():Articulos( ::getView() ) )->cLote )
      ::oViewEditDetail:ShowLote()
   else
      ::oViewEditDetail:HideLote()
   end if

   ::oViewEditDetail:RefreshLote()

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

   ::setLineFromArticulo()
/*
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

   ::setFactorConversion()

   ::setImagenProducto()

   ::setPrecioRecomendado()

   ::setPuntoVerde()

   ::setUnidadMedicion()

   ::setPrecioCosto()


   
*/
   ::setComisionFromMaster()

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
