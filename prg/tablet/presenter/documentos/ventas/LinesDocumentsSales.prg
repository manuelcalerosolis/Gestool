#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS LinesDocumentsSales FROM Editable

   DATA oSender

   DATA cOldCodigoArticulo                                  INIT ""

   DATA hAtipicaClienteValues

   DATA oViewEditDetail

   METHOD New( oSender )

   METHOD getSender()                                       INLINE ( ::oSender )
   METHOD getView()                                         INLINE ( ::getSender():nView )

   METHOD hSetMaster( cField, uValue )                      INLINE ( hSet( ::oSender:hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )                              INLINE ( hGet( ::oSender:hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue )                      INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )                              INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD lSeekArticulo()
   METHOD lSeekAlmacen()
   METHOD lArticuloObsoleto()

   METHOD setCodigo( cCodigo )                              INLINE ( ::hSetDetail( "Articulo", cCodigo ) )
   METHOD setDetalle( cDetalle )                            INLINE ( ::hSetDetail( "DescripcionArticulo", cDetalle ) )
   METHOD setDescripcionAmpliada( cDescripcion )            INLINE ( ::hSetDetail( "DescripcionAmpliada", cDescripcion ) )
   METHOD setCodigoProveedor( cCodigo )                     INLINE ( ::hSetDetail( "Proveedor", cCodigo ) )
   METHOD setNombreProveedor( cNombreProveedor )            INLINE ( ::hSetDetail( "NombreProveedor", cNombreProveedor ) )
   METHOD setReferenciaProveedor( cRefProveedor )           INLINE ( ::hSetDetail( "ReferenciaProveedor", cRefProveedor ) )
   
   METHOD setAlmacen( cCodigoAlmacen )                      INLINE ( ::oViewEditDetail:oGetAlmacen:cText( cCodigoAlmacen ), ::cargaAlmacen() )
   METHOD setNombreAlmacen( cNombreAlmacen )                INLINE ( ::oViewEditDetail:oGetNombreAlmacen:cText( cNombreAlmacen ) )

   METHOD setLogicoLote( lLote )                            INLINE ( ::hSetDetail( "LogicoLote", lLote ) )
   METHOD setLote( cLote )                                  INLINE ( ::hSetDetail( "Lote", cLote ) )
   METHOD setFechaCaducidad( dFecha )                       INLINE ( ::hSetDetail( "FechaCaducidad", dFecha ) )
   METHOD setTipoVenta( lTipoVenta )                        INLINE ( ::hSetDetail( "AvisarSinStock", lTipoVenta ) )
   METHOD setNoPermitirVentaSinStock( lVentaSinStock )      INLINE ( ::hSetDetail( "NoPermitirSinStock", lVentaSinStock ) )
   METHOD setFamilia( cCodigoFamilia )                      INLINE ( ::hSetDetail( "Familia", cCodigoFamilia ) )
   METHOD setGrupoFamilia( cGrupoFamilia )                  INLINE ( ::hSetDetail( "GrupoFamilia", cGrupoFamilia ) )
   METHOD setPeso( nPeso )                                  INLINE ( ::hSetDetail( "Peso", nPeso ) )
   METHOD setUnidadMedicionPeso( cUnidadMedicion )          INLINE ( ::hSetDetail( "UnidadMedicionPeso", cUnidadMedicion ) )
   METHOD setVolumen( nVolumen )                            INLINE ( ::hSetDetail( "Volumen", nVolumen ) )
   METHOD setUnidadMedicionVolumen( cVolumen )              INLINE ( ::hSetDetail( "UnidadMedicionVolumen", cVolumen ) )
   METHOD setUnidadMedicion( cUnidadMedicion )              INLINE ( ::hSetDetail( "UnidadMedicion", cUnidadMedicion ) )
   METHOD setTipoArticulo( cTipoArticulo )                  INLINE ( ::hSetDetail( "TipoArticulo", cTipoArticulo ) )
   METHOD setCajas( nCajas )                                INLINE ( ::hSetDetail( "Cajas", if( empty( nCajas ), 1, nCajas ) ) )
   METHOD setUnidades( nUnidades )                          INLINE ( ::hSetDetail( "Unidades", if( empty( nUnidades ), 1, nUnidades ) ) )
   METHOD setImpuestoEspecial( cCodigoImpuesto )            INLINE ( ::hSetDetail( "ImpuestoEspecial", cCodigoImpuesto ) )
   METHOD setImporteImpuestoEspecial( nImporte )            INLINE ( ::hSetDetail( "ImporteImpuestoEspecial", nImporte ) )
   METHOD setVolumenImpuestosEspeciales( lImpuesto )        INLINE ( ::hSetDetail( "VolumenImpuestosEspeciales", lImpuesto ) )
   METHOD setPorcentajeImpuesto( nPorcentaje )              INLINE ( ::hSetDetail( "PorcentajeImpuesto", nPorcentaje ) )
   METHOD setRecargoEquivalencia( nPorcentaje )             INLINE ( ::hSetDetail( "RecargoEquivalencia", nPorcentaje ) )
   METHOD setFactorConversion( nFactor )                    INLINE ( ::hSetDetail( "FactorConversion", nFactor ) )
   METHOD setImagen( cImagen )                              INLINE ( ::hSetDetail( "Imagen", cImagen ) )
   METHOD setControlStock( nControlStock )                  INLINE ( ::hSetDetail( "TipoStock", nControlStock ) )
   METHOD setPrecioRecomendado( nPrecio )                   INLINE ( ::hSetDetail( "PrecioVentaRecomendado", nPrecio ) )
   METHOD setPuntoVerde( nPuntoVerde )                      INLINE ( ::hSetDetail( "PuntoVerde", nPuntoVerde ) )
   METHOD setUnidadMedicion( cUnidad )                      INLINE ( ::hSetDetail( "UnidadMedicion", cUnidad ) )
   METHOD setLineaEscandallo( lLineaEscandallo )            INLINE ( ::hSetDetail( "LineaEscandallo", lLineaEscandallo ) )
   METHOD setLineaPerteneceEscandallo( LineaPerteneceEscandallo ) ;
                                                            INLINE ( ::hSetDetail( "LineaPerteneceEscandallo", LineaPerteneceEscandallo ) )

   METHOD setFechaVentaAnterior( dFechaAnterior )           INLINE ( ::hSetDetail( "FechaUltimaVenta", dFechaAnterior ) ) 
   METHOD setPrecioVentaAnterior( nPrecioAnterior )         INLINE ( ::hSetDetail( "PrecioUltimaVenta", nPrecioAnterior ) )

   METHOD getUnidadesKit( nUnidadesArticulo )               INLINE ( if (  ( D():Kit( ::getView() ) )->nUndKit != 0,;
                                                                           nUnidadesArticulo * ( D():Kit( ::getView() ) )->nUndKit,;
                                                                           nUnidadesArticulo ) )

   METHOD setTarifa()                                       INLINE ( ::hSetDetail( "NumeroTarifa", ::hGetMaster( "NumeroTarifa" ) ) ) 
   METHOD setPrecioCosto( nCosto )                          INLINE ( ::hSetDetail( "PrecioCosto", nCosto ) )
      METHOD setPrecioCostoMedio()                          VIRTUAL         
   METHOD setPrecioVenta( nPrecioVenta )                    INLINE ( ::hSetDetail( "PrecioVenta", nPrecioVenta ) )
   METHOD setStockArticulo()

   METHOD setOldCodigoArticulo()                            INLINE ( ::cOldCodigoArticulo := ::hGetDetail( "Articulo" ) )
   METHOD resetOldCodigoArticulo()                          INLINE ( ::cOldCodigoArticulo := "" )

   METHOD getValorImpuestoEspecial();
      INLINE ( D():ImpuestosEspeciales( ::getView() ):nValImp( ( D():Articulos( ::getView() ) )->cCodImp, ::hGetMaster( "ImpuestosIncluidos" ), ::hGetMaster( "TipoImpuesto" ) ) )

   METHOD setPrecioTarifaCliente()                          VIRTUAL      
   
   METHOD setAtipicasCliente()    
      METHOD buildAtipicaClienteValues()                  

      METHOD setPrecioOfertaArticulo()                      VIRTUAL      

   METHOD setComisionFromMaster()                           INLINE ( ::hSetDetail( "ComisionAgente", ::hGetMaster( "ComisionAgente" ) ) )

      METHOD setComisionTarifaCliente()                     VIRTUAL   
      METHOD setComisionAtipicaCliente()                    VIRTUAL

   METHOD setDescuentoPorcentual( nDescuentoPorcentual )    INLINE ( ::hSetDetail( "DescuentoPorcentual", nDescuentoPorcentual ) )
   METHOD setDescuentoPorcentualFromCliente()               INLINE ( ::setDescuentoPorcentual( nDescuentoArticulo( ::hGetDetail( "Articulo" ), ::hGetMaster( "Cliente" ), ::getView() ) ) )

      METHOD setDescuentoPorcentualTarifaCliente()          VIRTUAL
      METHOD setDescuentoPorcentualAtipicaCliente()         VIRTUAL
      METHOD setDescuentoPorcentualOfertaArticulo()         VIRTUAL

   METHOD setDescuentoPromocional()
      METHOD setDescuentoPromocionalTarifaCliente()         VIRTUAL
      METHOD setDescuentoPromocionalAtipicaCliente()        VIRTUAL

   METHOD setDescuentoLineal( nDescuentoLineal )            INLINE ( ::hSetDetail( "DescuentoLineal", nDescuentoLineal ) )
   METHOD resetDescuentoLineal()                            INLINE ( ::setDescuentoLineal( 0 ) )
      METHOD setDescuentoLinealTarifaCliente()              VIRTUAL       
      METHOD setDescuentoLinealAtipicaCliente()             VIRTUAL
      METHOD setDescuentoLinealOfertaArticulo()             VIRTUAL

   METHOD setFilerObsoletos()
   METHOD clearFilerObsoletos()

   METHOD runGridProduct()
   METHOD runGridStore()
   METHOD runGridLote()

   METHOD cargaArticulo()
   METHOD cargaAlmacen()
   METHOD cargaLote()

   METHOD setLineFromArticulo() 

   METHOD lShowLote()                                       INLINE ( ::hGetDetail( "LogicoLote" ) )

   METHOD resourceDetail( nMode )
      METHOD startResourceDetail()

   METHOD recalcularTotal()

   METHOD onPreSaveAppendDetail()                           INLINE ( .t. )

   METHOD onPostSaveAppendDetail()
      
   METHOD insertKit( cCodigoArticulo ) 

   METHOD lValidResourceDetail()

   METHOD setObsequio()

   METHOD lValidStockLote()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS LinesDocumentsSales

   ::oSender      := oSender

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lSeekArticulo( cCodigoArticulo ) CLASS LinesDocumentsSales

   if empty( cCodigoArticulo )
      cCodigoArticulo         := ::oViewEditDetail:oGetArticulo:varGet()   //::hGetDetail( "Articulo" )
   end if 

   if empty( cCodigoArticulo )
      RETURN .f.
   end if

   cCodigoArticulo            := cSeekCodebarView( cCodigoArticulo, ::getView() )

RETURN ( dbSeekArticuloUpperLower( cCodigoArticulo, ::getView() ) )

//---------------------------------------------------------------------------//

METHOD lSeekAlmacen() CLASS LinesDocumentsSales

   local cCodigoAlmacen     := ::oViewEditDetail:oGetAlmacen:varGet()   //::hGetDetail( "Articulo" )

   if empty( cCodigoAlmacen )
      RETURN .f.
   end if

RETURN ( cSeekStoreView( cCodigoAlmacen, ::getView() ) )

//---------------------------------------------------------------------------//

METHOD lArticuloObsoleto() CLASS LinesDocumentsSales

   if !( D():Articulos( ::getView() ) )->lObs
      RETURN .f.
   end if

   ApoloMsgStop( "Artículo catalogado como obsoleto" )

   ::oViewEditDetail:oGetArticulo:SetFocus()

RETURN .t.

//---------------------------------------------------------------------------//   

METHOD setAtipicasCliente() CLASS LinesDocumentsSales

   local hAtipica    := hAtipica( ::buildAtipicaClienteValues() )

   if empty( hAtipica )
      RETURN ( self )
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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD buildAtipicaClienteValues() CLASS LinesDocumentsSales

   local hAtipicaClienteValues                  := {=>}
   
   hAtipicaClienteValues[ "nView"             ] := ::getView()

   hAtipicaClienteValues[ "cCodigoArticulo"   ] := ::hGetDetail( "Articulo" )
   hAtipicaClienteValues[ "cCodigoPropiedad1" ] := ::hGetDetail( "CodigoPropiedad1" )
   hAtipicaClienteValues[ "cCodigoPropiedad2" ] := ::hGetDetail( "CodigoPropiedad2" )
   hAtipicaClienteValues[ "cValorPropiedad1"  ] := ::hGetDetail( "ValorPropiedad1" )
   hAtipicaClienteValues[ "cValorPropiedad2"  ] := ::hGetDetail( "ValorPropiedad2" )
   hAtipicaClienteValues[ "cCodigoFamilia"    ] := ::hGetDetail( "Familia" )
   hAtipicaClienteValues[ "nTarifaPrecio"     ] := ::hGetDetail( "NumeroTarifa" )
   hAtipicaClienteValues[ "nCajas"            ] := ::hGetDetail( "Cajas" )
   hAtipicaClienteValues[ "nUnidades"         ] := ::hGetDetail( "Unidades" )

   hAtipicaClienteValues[ "cCodigoCliente"    ] := ::hGetMaster( "Cliente" )   
   hAtipicaClienteValues[ "cCodigoGrupo"      ] := ::hGetMaster( "GrupoCliente" )   
   hAtipicaClienteValues[ "lIvaIncluido"      ] := ::hGetMaster( "ImpuestosIncluidos" )   
   hAtipicaClienteValues[ "dFecha"            ] := ::hGetMaster( "Fecha" )   
   hAtipicaClienteValues[ "nDescuentoTarifa"  ] := ::hGetMaster( "DescuentoTarifa" )   

RETURN ( hAtipicaClienteValues )

//---------------------------------------------------------------------------//

METHOD setDescuentoPromocional() CLASS LinesDocumentsSales

   ::setDescuentoPromocionalTarifaCliente()     //Método Virtual no creado
   ::setDescuentoPromocionalAtipicaCliente()    //Método Virtual no creado

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setLineFromArticulo() CLASS LinesDocumentsSales

   local nPrecioAnterior

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

   ::setTarifa()

   ::setPrecioVenta( nRetPreArt( ::hGetDetail( "NumeroTarifa" ), ::hGetMaster( "Divisa" ), ::hGetMaster( "ImpuestosIncluidos" ), D():Articulos( ::getView() ), D():Divisas( ::getView() ), D():Kit( ::getView() ), D():TiposIva( ::getView() ) ) )

   ::setPrecioCosto( ( D():Articulos( ::getView() ) )->pCosto ) 

   ::setFechaVentaAnterior( dFechaUltimaVenta( ::hGetMaster( "Cliente" ), ( D():Articulos( ::getView() ) )->Codigo, D():AlbaranesClientesLineas( ::getView() ), D():FacturasClientesLineas( ::getView() ) ) ) 
   nPrecioAnterior      := nPrecioUltimaVenta( ::hGetMaster( "Cliente" ), ( D():Articulos( ::getView() ) )->Codigo, D():AlbaranesClientesLineas( ::getView() ), D():FacturasClientesLineas( ::getView() ) )
   ::setPrecioVentaAnterior( nPrecioAnterior ) 

   
   if ::hGetDetail( "PrecioVenta" ) == 0 .and. nPrecioAnterior != 0
      ::setPrecioVenta( nPrecioAnterior )
   end if

   if ( D():Articulos( ::getView() ) )->lLote
      
      ::setLogicoLote( ( D():Articulos( ::getView() ) )->lLote )
      
      if accessCode():lAddLote
         ::setLote( ( D():Articulos( ::getView() ) )->cLote )
      end if

      ::setFechaCaducidad( dFechaCaducidadLote( ::hGetDetail( "Articulo" ),;
                                                ::hGetDetail( "ValorPropiedad1" ),;
                                                ::hGetDetail( "ValorPropiedad2" ),;
                                                ::hGetDetail( "Lote" ),;
                                                D():AlbaranesProveedoresLineas( ::getView() ),;
                                                D():FacturasProveedoresLineas( ::getView() ),;
                                                D():PartesProduccionMaterial( ::getView() ) ) )
      
      ::oViewEditDetail:ShowLote()

   else

      ::oViewEditDetail:HideLote()

   end if

   ::setLineaEscandallo( ( D():Articulos( ::getView() ) )->lKitArt )

   ::setStockArticulo()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setStockArticulo() 
 
   if Upper( GetPvProfString( "Tablet", "Stock", ".F.", cIniAplication() ) ) != ".T."
      RETURN ( Self )
   end if 

   /*
   Stock por lote------------------------------------------------------------//
   */

   ::oViewEditDetail:nGetStock   := ::oSender:oStock:nStockAlmacen(  ::hGetDetail( "Articulo" ),;
                                                                     ::hGetDetail( "Almacen" ),;
                                                                     ::hGetDetail( "ValorPropiedad1" ),;
                                                                     ::hGetDetail( "ValorPropiedad2" ),;
                                                                     ::hGetDetail( "Lote" ) )

   if !empty( ::oViewEditDetail:oGetStock )
      ::oViewEditDetail:oGetStock:Refresh()
   end if

   ::oViewEditDetail:nGetStockAlmacen  := ::oSender:oStock:nStockAlmacen(  ::hGetDetail( "Articulo" ),;
                                                                           ::hGetDetail( "Almacen" ) )

   if !empty( ::oViewEditDetail:oGetStockAlmacen )
      ::oViewEditDetail:oGetStockAlmacen:Refresh()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD CargaArticulo( cCodigoArticulo ) CLASS LinesDocumentsSales

   if empty( cCodigoArticulo )
      cCodigoArticulo   := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )
   end if

   if empty( cCodigoArticulo )
      RETURN .f.
   end if

   if ( cCodigoArticulo == ::cOldCodigoArticulo )
      RETURN .t.
   end if

   if !::lSeekArticulo( cCodigoArticulo )
      apoloMsgStop( "Artículo no encontrado" )
      RETURN .f.
   end if

   if ::lArticuloObsoleto()
      RETURN .f.
   end if

   ::oViewEditDetail:disableDialog()

   ::setLineFromArticulo()

   ::setComisionFromMaster()

   ::setDescuentoPorcentualFromCliente()

   ::setAtipicasCliente()

   ::setOldCodigoArticulo()

   ::oViewEditDetail:enableDialog()

   ::oViewEditDetail:refreshDialog()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cargaLote( cCodigoArticulo ) CLASS LinesDocumentsSales

   ::oViewEditDetail:disableDialog()

   ::setStockArticulo()

   ::oViewEditDetail:enableDialog()

   ::oViewEditDetail:refreshDialog()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cargaAlmacen() CLASS LinesDocumentsSales

   if !::lSeekAlmacen()
      apoloMsgStop( "Almacén no encontrado" )
      RETURN .f.
   end if

   ::setNombreAlmacen( ( D():Almacen( ::getView() ) )->cNomAlm )

   ::oViewEditDetail:disableDialog()
   
   ::setStockArticulo()

   ::oViewEditDetail:enableDialog()

   ::oViewEditDetail:refreshDialog()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesDocumentsSales

   local lResult        := .f.

   ::oViewEditDetail    := ViewDetail():New( self )

   if !empty( ::oViewEditDetail )

      ::oViewEditDetail:setTitleDocumento( lblTitle( ::oSender:nModeDetail ) + ::oSender:getTextTitle() )

      lResult           := ::oViewEditDetail:Resource( nMode )

   end if

RETURN ( lResult )   

//---------------------------------------------------------------------------//

METHOD StartResourceDetail() CLASS LinesDocumentsSales

   ::setOldCodigoArticulo()

   ::cargaAlmacen()

   ::recalcularTotal()

/*
   ::oViewEditDetail:oGetArticulo:SetFocus()
   ::oViewEditDetail:oGetUnidades:SetFocus()
   ::oViewEditDetail:oGetArticulo:SetFocus()
*/

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD recalcularTotal() CLASS LinesDocumentsSales

   if !empty( ::oViewEditDetail:oTotalLinea )
      ::oViewEditDetail:oTotalLinea:cText( ::oSender:oDocumentLineTemporal:getBruto() )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runGridProduct() CLASS LinesDocumentsSales

   if empty( ::oSender:oProduct:oGridProduct )
      RETURN ( Self )
   end if

   if GetPvProfString( "Tablet", "OcultarObsoletos", ".F.", cIniAplication() ) == ".T."
      ::setFilerObsoletos()
   end if

   ::oViewEditDetail:oGetArticulo:Disable()

   ::oSender:oProduct:oGridProduct:showView()

   if ::oSender:oProduct:oGridProduct:isEndOk()
      ::oViewEditDetail:SetGetValue( ( D():Articulos( ::oSender:nView ) )->Codigo, "Articulo" )
   end if

   ::cargaArticulo()

   ::recalcularTotal()

   ::oViewEditDetail:oGetArticulo:Enable()
   ::oViewEditDetail:oGetArticulo:setFocus()

   if GetPvProfString( "Tablet", "OcultarObsoletos", ".F.", cIniAplication() ) == ".T."
      ::clearFilerObsoletos()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setFilerObsoletos() CLASS LinesDocumentsSales

   ( D():Articulos( ::oSender:nView ) )->( dbsetfilter( {|| !Field->lObs }, "!Field->lObs" ) )
   ( D():Articulos( ::oSender:nView ) )->( dbgotop() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD clearFilerObsoletos() CLASS LinesDocumentsSales

   ( D():Articulos( ::oSender:nView ) )->( dbClearFilter() )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runGridLote() CLASS LinesDocumentsSales

   local aArrayData
   local nArrayData

   if empty( ::oSender:oProductStock:oGridProductStock )
      RETURN ( Self )
   end if

   ::oViewEditDetail:oGetLote:Disable()

   ::oSender:oProductStock:setEnviroment( ::oViewEditDetail:oGetArticulo:varGet(), ::oViewEditDetail:oGetAlmacen:varGet() )
   ::oSender:oProductStock:oGridProductStock:setSubTitle( ::oViewEditDetail:oGetArticulo:varGet(), ::oViewEditDetail:oGetAlmacen:varGet() )
   ::oSender:oProductStock:oGridProductStock:showView()

   if ::oSender:oProductStock:oGridProductStock:isEndOk() .and. ;
      !empty( ::oSender:oProductStock:oGridProductStock:oBrowse )

      aArrayData     := ::oSender:oProductStock:oGridProductStock:oBrowse:aArrayData
      nArrayData     := ::oSender:oProductStock:oGridProductStock:oBrowse:nArrayAt

      if nArrayData > 0 .and. nArrayData <= len( aArrayData ) 
         ::oViewEditDetail:SetGetValue( aArrayData[ nArrayData ]:cLote, "Lote" )
      end if

   end if

   ::cargaArticulo()

   ::recalcularTotal()

   ::oViewEditDetail:oGetLote:Enable()
   ::oViewEditDetail:oGetLote:SetFocus()
   ::oViewEditDetail:oGetLote:Refresh()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runGridStore() CLASS LinesDocumentsSales

   if ( GetPvProfString( "Tablet", "BloqueoAlmacen", ".F.", cIniAplication() ) == ".T." )
      RETURN ( self )
   end if

   if empty( ::oSender:oStore:oGrid )
      RETURN ( Self )
   end if 

   ::oViewEditDetail:oGetAlmacen:Disable()

   ::oSender:oStore:oGrid:showView()

   if ::oSender:oStore:oGrid:isEndOk()
      ::setAlmacen( ( D():Almacen( ::oSender:nView ) )->cCodAlm )
   end if

   ::cargaAlmacen()

   ::oViewEditDetail:oGetAlmacen:Enable()
   ::oViewEditDetail:oGetAlmacen:setFocus()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lValidResourceDetail() CLASS LinesDocumentsSales

   ::oViewEditDetail:oGetArticulo:lValid()   

   ::oViewEditDetail:oGetLote:lValid()

   if ::hGetDetail( "LogicoLote" ) .and. empty( ::hGetDetail( "Lote" ) )

      apoloMsgStop( "El campo lote es obligatorio" )

      ::oViewEditDetail:oGetLote:SetFocus()
 
      RETURN ( .f. )

   end if

   if !::lValidStockLote()
      RETURN ( .f. )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD onPostSaveAppendDetail() CLASS LinesDocumentsSales

   local aStatusKit
   local cCodigoArticulo
   local nUnidadesArticulo
   local lLineaPertencienteEscandallo

   aStatusKit                    := D():getStatusKit( ::getView() )

   cCodigoArticulo               := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )
   nUnidadesArticulo             := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Unidades" )
   lLineaPertencienteEscandallo  := lKitAsociado( cCodigoArticulo, D():Articulos( ::getView() ) )

   ( D():Kit( ::getView() ) )->( ordsetfocus( "cCodKit" ) )
   if ( D():Kit( ::getView() ) )->( dbSeek( cCodigoArticulo ) )

      while ( D():Kit( ::getView() ) )->cCodKit == cCodigoArticulo .and. !( D():Kit( ::getView() ) )->( eof() )

         ::insertKit( nUnidadesArticulo, lLineaPertencienteEscandallo )

         ( D():Kit( ::getView() ) )->( dbSkip() )

      end while

   end if

   D():setStatusKit( aStatusKit, ::getView() )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertKit( nUnidadesArticulo, lLineaPertencienteEscandallo ) CLASS LinesDocumentsSales

   if !::lSeekArticulo( ( D():Kit( ::getView() ) )->cRefKit )
      RETURN .f.
   end if

   ::oSender:getAppendDetail()

   ::resetDescuentoLineal()

   ::setLineFromArticulo()

   ::setComisionFromMaster()

   ::setDescuentoPorcentualFromCliente()

   ::setAtipicasCliente()

   ::setLineaPerteneceEscandallo( lLineaPertencienteEscandallo )

   ::setUnidades( ::getUnidadesKit( nUnidadesArticulo ) )

   ::oSender:saveAppendDetail()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setObsequio() CLASS LinesDocumentsSales

   ::hSetDetail( "PrecioVenta", 0 )
   ::oViewEditDetail:oGetPrecio:Refresh()

   ::recalcularTotal()

   ::oViewEditDetail:oGetArticulo:SetFocus()
   ::oViewEditDetail:oGetArticulo:lValid()

   ::oViewEditDetail:refreshDialog()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD lValidStockLote() CLASS LinesDocumentsSales

   local nUnidades   := 0

   if !::hGetDetail( "NoPermitirSinStock" )
      RETURN .t.
   end if

   nUnidades         := NotCaja( ::hGetDetail( "Cajas" ) ) * ::hGetDetail( "Unidades" )

   if ( ::oViewEditDetail:nGetStock - nUnidades ) < 0
      ApoloMsgStop( "No hay stock suficiente." )
      RETURN .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//