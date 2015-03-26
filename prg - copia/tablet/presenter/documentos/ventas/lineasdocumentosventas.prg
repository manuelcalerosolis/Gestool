#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS LineasDocumentosVentas FROM Ventas

   /*DATA nMode

   DATA oViewEdit
   DATA oViewEditDetail
   DATA oViewEditResumen
   
   DATA nUltimoCliente
   DATA cOldCodidoArticulo          INIT ""
   DATA hOrdenRutas                 INIT {   "1" => "lVisDom",;
                                             "2" => "lVisLun",;
                                             "3" => "lVisMar",;
                                             "4" => "lVisMie",;
                                             "5" => "lVisJue",;
                                             "6" => "lVisVie",;
                                             "7" => "lVisSab",;
                                             "8" => "Cod" }

   DATA hTotalIva                   INIT  {  { "Base" => 100,;
                                               "PorcentajeIva" => 21,;
                                               "ImporteIva" => 121,;
                                               "PorcentajeRe" => 1,;
                                               "ImporteRe" => 1 },;
                                             { "Base" => 100,;
                                               "PorcentajeIva" => 21,;
                                               "ImporteIva" => 121,;
                                               "PorcentajeRe" => 1,;
                                               "ImporteRe" => 1 },;
                                             { "Base" => 100,;
                                               "PorcentajeIva" => 21,;
                                               "ImporteIva" => 121,;
                                               "PorcentajeRe" => 1,;
                                               "ImporteRe" => 1 } } */ 

   METHOD New()

   /*METHOD getDataBrowse( Name )     INLINE ( hGet( ::hDictionaryDetail[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD ChangeSerieTablet( getSerie )

   METHOD lValidCliente()

   METHOD lValidDireccion()

   METHOD ChangeRuta()

   METHOD priorClient()
   METHOD nextClient()
   METHOD moveClient()

   METHOD CargaSiguienteCliente()

   METHOD gotoUltimoCliente( oCbxRuta )
   METHOD setUltimoCliente( oCbxRuta )

   METHOD RecalculaLinea( oTotal )

   METHOD AppendGuardaLinea()
   METHOD EditGuardaLinea()

   METHOD lSeekArticulo()

   METHOD hSetDetail( cField, uValue );
            INLINE ( hSet( ::hDictionaryDetailTemporal, cField, uValue ) )


   METHOD setCodigoArticulo();
            INLINE ( ::hSetDetail( "Articulo", ( D():Articulos( ::nView ) )->Codigo ),;
                     ::oViewEditDetail:oGetArticulo:Refresh() )

   METHOD lArticuloObsoleto()

   METHOD setDetalleArticulo();    
            INLINE ( ::hSetDetail( "DescripcionArticulo", ( D():Articulos( ::nView ) )->Nombre ),;
                     ::hSetDetail( "DescripcionAmpliada", ( D():Articulos( ::nView ) )->Descrip ),;
                     ::oViewEditDetail:oGetDescripcionArticulo:Refresh() )

   METHOD setProveedorArticulo()

   METHOD setLote()

   METHOD setTipoVenta();
            INLINE ( ::hSetDetail( "AvisarSinStock", ( D():Articulos( ::nView ) )->lMsgVta ),;
                     ::hSetDetail( "NoPermitirSinStock", ( D():Articulos( ::nView ) )->lNotVta ) )

   METHOD setFamilia();
            INLINE ( ::hSetDetail( "Familia", ( D():Articulos( ::nView ) )->Familia ),;
                     ::hSetDetail( "GrupoFamilia", cGruFam( ( D():Articulos( ::nView ) )->Familia, D():Familias( ::nView ) ) ) )

   METHOD setPeso();
            INLINE ( ::hSetDetail( "Peso", ( D():Articulos( ::nView ) )->nPesoKg ),;
                     ::hSetDetail( "UnidadMedicionPeso", ( D():Articulos( ::nView ) )->cUndDim ) )

   METHOD setVolumen();
            INLINE ( ::hSetDetail( "Volumen", ( D():Articulos( ::nView ) )->nVolumen ),;
                     ::hSetDetail( "UnidadMedicionVolumen", ( D():Articulos( ::nView ) )->cVolumen ) )

   METHOD setUnidadMedicion();
            INLINE ( ::hSetDetail( "UnidadMedicion", ( D():Articulos( ::nView ) )->cUnidad ) )

   METHOD setTipoArticulo();
            INLINE ( ::hSetDetail( "TipoArticulo", ( D():Articulos( ::nView ) )->cCodTip ) )

   METHOD setCajas();
            INLINE ( iif( !Empty( ( D():Articulos( ::nView ) )->nCajEnt ), ::hSetDetail( "Cajas", ( D():Articulos( ::nView ) )->nCajEnt ), ::hSetDetail( "Cajas", 1 ) ) )

   METHOD setUnidades();
            INLINE ( iif( !Empty( ( D():Articulos( ::nView ) )->nUniCaja ), ::hSetDetail( "Unidades", ( D():Articulos( ::nView ) )->nUniCaja ), ::hSetDetail( "Unidades", 1 ) ) )

   METHOD getValorImpuestoEspecial();
            INLINE ( D():ImpuestosEspeciales( ::nView ):nValImp( ( D():Articulos( ::nView ) )->cCodImp,;
                     hGet( ::hDictionaryMaster, "ImpuestosIncluidos" ),;
                     hGet( ::hDictionaryDetailTemporal, "TipoImpuesto" ) ) )

   METHOD SetImpuestoEspecial()

   METHOD SetTipoImpuesto()

   METHOD SetFactorConversion();
            INLINE ( iif( ( D():Articulos( ::nView ) )->lFacCnv, ::hSetDetail( "FactorConversion", ( D():Articulos( ::nView ) )->nFacCnv ), ) )

   METHOD SetImagenProducto();
            INLINE ( ::hSetDetail( "Imagen", ( D():Articulos( ::nView ) )->cImagen ) )

   METHOD SetControlStock();
            INLINE ( ::hSetDetail( "TipoStock", ( D():Articulos( ::nView ) )->nCtlStock ) )

   METHOD SetPrecioRecomendado();
            INLINE ( ::hSetDetail( "PrecioVentaRecomendado", ( D():Articulos( ::nView ) )->PvpRec ) )

   METHOD SetPuntoVerde();
            INLINE ( ::hSetDetail( "PuntoVerde", ( D():Articulos( ::nView ) )->nPntVer1 ) )

   METHOD SetUnidadMedicion();
            INLINE ( ::hSetDetail( "UnidadMedicion", ( D():Articulos( ::nView ) )->cUnidad ) )

   METHOD SetPrecioCosto()
      METHOD SetPrecioCostoMedio()        VIRTUAL

   METHOD SetPrecioVenta()
      METHOD SetPrecioArticulo
      METHOD SetPrecioTarifaCliente       VIRTUAL
      METHOD SetPrecioAtipicaCliente      VIRTUAL
      METHOD SetPrecioOfertaArticulo      VIRTUAL

   METHOD SetComisionAgente() 
      METHOD SetComisionMaster()          INLINE ( ::hSetDetail( "ComisionAgente", hGet( ::hDictionaryMaster, "ComisionAgente" ) ) )
      METHOD SetComisionTarifaCliente()   VIRTUAL
      METHOD SetComisionAtipicaCliente()  VIRTUAL

   METHOD SetDescuentoPorcentual()
      METHOD SetDescuentoPorcentualArticulo();
            INLINE ( ::hSetDetail( "DescuentoPorcentual", nDescuentoArticulo( hGet( ::hDictionaryDetailTemporal, "Articulo" ), hGet( ::hDictionaryMaster, "Cliente" ), ::nView ) ) )

      METHOD SetDescuentoPorcentualTarifaCliente()    VIRTUAL
      METHOD SetDescuentoPorcentualAtipicaCliente()   VIRTUAL
      METHOD SetDescuentoPorcentualOfertaArticulo()   VIRTUAL

   METHOD SetDescuentoPromocional()
      METHOD SetDescuentoPromocionalTarifaCliente()   VIRTUAL
      METHOD SetDescuentoPromocionalAtipicaCliente()  VIRTUAL

   METHOD SetDescuentoLineal()
      METHOD SetDescuentoLinealTarifaCliente()        VIRTUAL
      METHOD SetDescuentoLinealAtipicaCliente()       VIRTUAL
      METHOD SetDescuentoLinealOfertaArticulo()       VIRTUAL

   METHOD CargaArticulo()

   METHOD lShowLote()   INLINE ( hGet( ::hDictionaryDetailTemporal, "LogicoLote" ) )

   METHOD ResumenVenta( oCbxRuta )

   METHOD lValidResumenVenta()

   METHOD SetDocumentosFacturas()*/

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS LineasDocumentosVentas


Return ( self )

//---------------------------------------------------------------------------//

/*METHOD isChangeSerieTablet( getSerie ) CLASS DocumentosVentas
   
   if hGet( ::hDictionaryMaster, "Envio" )
      ::ChangeSerieTablet( getSerie )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeSerieTablet( getSerie ) CLASS DocumentosVentas

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidCliente( oGet, oGet2, nMode ) CLASS DocumentosVentas

   local lValid      := .t.
   local cNewCodCli  := hGet( ::hDictionaryMaster, "Cliente" )

   if Empty( cNewCodCli )
      Return .t.
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( D():Clientes( ::nView ) )->( dbSeek( cNewCodCli ) )

      hSet( ::hDictionaryMaster, "Cliente", cNewCodCli )
      hSet( ::hDictionaryMaster, "NombreCliente", ( D():Clientes( ::nView ) )->Titulo )
      hSet( ::hDictionaryMaster, "DomicilioCliente", ( D():Clientes( ::nView ) )->Domicilio )
      hSet( ::hDictionaryMaster, "PoblacionCliente", ( D():Clientes( ::nView ) )->Poblacion )
      hSet( ::hDictionaryMaster, "ProvinciaCliente", ( D():Clientes( ::nView ) )->Provincia )
      hSet( ::hDictionaryMaster, "CodigoPostalCliente", ( D():Clientes( ::nView ) )->CodPostal )
      hSet( ::hDictionaryMaster, "TelefonoCliente", ( D():Clientes( ::nView ) )->Telefono )
      hSet( ::hDictionaryMaster, "DniCliente", ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "GrupoCliente", ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "ModificarDatOperarPuntoVerdeGrupoCliente", ( D():Clientes( ::nView ) )->lPntVer )

      if nMode == APPD_MODE

         if !Empty( ( D():Clientes( ::nView ) )->Serie )
            hSet( ::hDictionaryMaster, "Serie", ( D():Clientes( ::nView ) )->Serie )
         end if

         hSet( ::hDictionaryMaster, "TipoImpuesto", ( D():Clientes( ::nView ) )->nRegIva )
         hSet( ::hDictionaryMaster, "Almacen", ( D():Clientes( ::nView ) )->cCodAlm )
         hSet( ::hDictionaryMaster, "Tarifa", ( D():Clientes( ::nView ) )->cCodTar )
         hSet( ::hDictionaryMaster, "Pago", ( D():Clientes( ::nView ) )->CodPago )
         hSet( ::hDictionaryMaster, "Agente", ( D():Clientes( ::nView ) )->cAgente )
         hSet( ::hDictionaryMaster, "Ruta", ( D():Clientes( ::nView ) )->cCodRut )
         hSet( ::hDictionaryMaster, "TarifaAplicar", ( D():Clientes( ::nView ) )->nTarifa )
         hSet( ::hDictionaryMaster, "DescuentoTarifa", ( D():Clientes( ::nView ) )->nDtoArt )
         hSet( ::hDictionaryMaster, "Transportista", ( D():Clientes( ::nView ) )->cCodTrn )
         hSet( ::hDictionaryMaster, "DescripcionDescuento1", ( D():Clientes( ::nView ) )->cDtoEsp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento1", ( D():Clientes( ::nView ) )->nDtoEsp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento2", ( D():Clientes( ::nView ) )->cDpp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento2", ( D():Clientes( ::nView ) )->nDpp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento3", ( D():Clientes( ::nView ) )->cDtoUno )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento3", ( D():Clientes( ::nView ) )->nDtoCnt )
         hSet( ::hDictionaryMaster, "DescripcionDescuento4", ( D():Clientes( ::nView ) )->cDtoDos )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento4", ( D():Clientes( ::nView ) )->nDtoRap )
         hSet( ::hDictionaryMaster, "DescuentoAtipico", ( D():Clientes( ::nView ) )->nDtoAtp )
         hSet( ::hDictionaryMaster, "LugarAplicarDescuentoAtipico", ( D():Clientes( ::nView ) )->nSbrAtp )

      end if

      if !Empty( oGet )
         oGet:Refresh()
      end if

      if !Empty( oGet2 )
         oGet2:Refresh()
      end if

      lValid      := .t.

   else

      ApoloMsgStop( "Cliente no encontrado" )
      lValid := .f.

   end if

RETURN lValid

//---------------------------------------------------------------------------//

METHOD lValidDireccion( oGet, oGet2, cCodCli ) CLASS DocumentosVentas

   local lValid   := .f.
   local xValor   := oGet:VarGet()
   local nOrdAnt

   if Empty( xValor )
      if !Empty( oGet2 )
         oGet2:cText( "" )
      end if
      return .t.
   end if

   if Empty( cCodCli )
      ApoloMsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   nOrdAnt        := ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( "cCodCli" ) )

   xValor         := Padr( cCodCli, 12 ) + xValor

   if ( D():ClientesDirecciones( ::nView ) )->( dbSeek( xValor ) )

      oGet:cText( ( D():ClientesDirecciones( ::nView ) )->cCodObr )

      if !Empty( oGet2 )
         oGet2:cText( ( D():ClientesDirecciones( ::nView ) )->cNomObr )
      end if

      lValid      := .t.

   else

      ApoloMsgStop( "Dirección no encontrada" )
      
      if !Empty( oGet )
         oGet:SetFocus()
      end if

      if !Empty( oGet2 )
         oGet2:cText( Space( 50 ) )
      end if

   end if

   ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

Return lValid

//---------------------------------------------------------------------------//

METHOD ChangeRuta( oCbxRuta, oGetCliente, oGetDireccion, oSayTextRuta ) CLASS DocumentosVentas

   local cCliente          := ""
   local nOrdAnt           := ( D():Clientes( ::nView ) )->( OrdSetFocus() )

   if hhaskey( ::hOrdenRutas, AllTrim( Str( oCbxRuta:nAt ) ) )

      nOrdAnt              := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

      if ( D():Clientes( ::nView ) )->( OrdKeyCount() ) != 0 
         
         ( D():Clientes( ::nView ) )->( dbGoTop() )
         if !( D():Clientes( ::nView ) )->( Eof() )
            cCliente       := ( D():Clientes( ::nView ) )->Cod
         end if   

         if !Empty( oSayTextRuta )
            oSayTextRuta:cText( AllTrim( Str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + "/" + AllTrim( Str( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) ) ) )
            oSayTextRuta:Refresh()
         end if

      else

         ( D():Clientes( ::nView ) )->( OrdSetFocus( "Cod" ) )
         ( D():Clientes( ::nView ) )->( dbGoTop() )

         cCliente             := ( D():Clientes( ::nView ) )->Cod

         if !Empty( oSayTextRuta )
            oSayTextRuta:cText( "1/1" )
            oSayTextRuta:Refresh()
         end if
      
      end if   

      ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

   end if

   if !Empty( oGetCliente )
      oGetCliente:cText( cCliente )
      oGetCliente:Refresh()
      oGetCliente:lValid()
   end if 

   if !Empty( oGetDireccion )
      oGetDireccion:cText( Space( 10 ) )
      oGetDireccion:Refresh()
      oGetDireccion:lValid()
   end if   

return cCliente

//---------------------------------------------------------------------------//

METHOD priorClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion ) CLASS DocumentosVentas

return ( ::moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, .t. ) )

//---------------------------------------------------------------------------//

METHOD nextClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion ) CLASS DocumentosVentas

return ( ::moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, .f. ) )

//---------------------------------------------------------------------------//

METHOD moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, lAnterior ) CLASS DocumentosVentas

   local lSet              := .f.
   local nOrdAnt

   if hhaskey( ::hOrdenRutas, AllTrim( Str( oCbxRuta:nAt ) ) )
      
      nOrdAnt              := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

      if isTrue( lAnterior )

         if ( D():Clientes( ::nView ) )->( OrdKeyNo() ) != 1
            ( D():Clientes( ::nView ) )->( dbSkip( -1 ) )
            lSet           := .t.
         end if

      end if 

      if isFalse( lAnterior )

         if ( D():Clientes( ::nView ) )->( OrdKeyNo() ) != ( D():Clientes( ::nView ) )->( OrdKeyCount() )
            ( D():Clientes( ::nView ) )->( dbSkip() )
            lSet           := .t.
         end if

      end if   

      if isNil( lAnterior )
         lSet              := .t.
      end if 

      if !empty( oSayTextRuta )
         oSayTextRuta:cText( alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + "/" + alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) ) ) )
         oSayTextRuta:Refresh()
      end if

      ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )   

      if lSet

         oGetCliente:cText( ( D():Clientes( ::nView ) )->Cod )
         oGetCliente:lValid()

         hSet( ::hDictionaryMaster, "Direccion", Space( 10 ) )
         oGetDireccion:lValid()

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CargaSiguienteCliente( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, nMode ) CLASS DocumentosVentas

   ::gotoUltimoCliente( oCbxRuta )

   if ( nMode == APPD_MODE ) .and. ( ::nUltimoCliente != 0 )
      ::nextClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion )
   else
      ::moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD gotoUltimoCliente( oCbxRuta ) CLASS DocumentosVentas

   local nOrdAnt     := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

   if empty( ::nUltimoCliente )
      ( D():Clientes( ::nView ) )->( dbGoTop() )
   else
      ( D():Clientes( ::nView ) )->( OrdKeyGoto( ::nUltimoCliente ) )
   end if 

   ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) ) 
         
Return .t.

//---------------------------------------------------------------------------//

METHOD setUltimoCliente( oCbxRuta ) CLASS DocumentosVentas

   local nOrdAnt     := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

   ::nUltimoCliente  := ( D():Clientes( ::nView ) )->( OrdKeyNo() )

   ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) ) 

Return nil

//---------------------------------------------------------------------------//

METHOD RecalculaLinea() CLASS DocumentosVentas

   local nCalculo
   local nUnidades
   local nMargen
   local nCosto
   local nRentabilidad
   local nBase       := 0

   nUnidades         := nTotNPedCli( ::hDictionaryDetailTemporal )

   nCalculo          := hGet( ::hDictionaryDetailTemporal, "PrecioVenta" )

   nCalculo          -= hGet( ::hDictionaryDetailTemporal, "DescuentoLineal" )

   /*
   IVMH------------------------------------------------------------------------

   if !hGet( ::hDictionaryDetailTemporal, "LineaImpuestoIncluido" )

      if hGet( ::hDictionaryDetailTemporal, "VolumenImpuestosEspeciales" )
         nCalculo += hGet( ::hDictionaryDetailTemporal, "ImporteImpuestoEspecial" ) * NotCero( hGet( ::hDictionaryDetailTemporal, "Volumen" ) )
      else
         nCalculo += hGet( ::hDictionaryDetailTemporal, "ImporteImpuestoEspecial" )
      end if

   end if

   nCalculo          *= nUnidades

   /*
   Transporte------------------------------------------------------------------

   if hGet( ::hDictionaryDetailTemporal, "Portes" ) != 0
      nCalculo       += hGet( ::hDictionaryDetailTemporal, "Portes" ) * nUnidades
   end if

   /*
   Descuentos------------------------------------------------------------------

   if hGet( ::hDictionaryDetailTemporal, "DescuentoPorcentual" ) != 0
      nCalculo       -= nCalculo * hGet( ::hDictionaryDetailTemporal, "DescuentoPorcentual" ) / 100
   end if

   if hGet( ::hDictionaryDetailTemporal, "DescuentoPromocion" ) != 0
      nCalculo       -= nCalculo * hGet( ::hDictionaryDetailTemporal, "DescuentoPromocion" ) / 100
   end if

   /*
   Punto Verde-----------------------------------------------------------------

   if hGet( ::hDictionaryMaster, "OperarPuntoVerde" )
      nCalculo       += hGet( ::hDictionaryDetailTemporal, "PuntoVerde" ) * nUnidades
   end if

   if !Empty( ::oViewEditDetail:oTotalLinea )
      ::oViewEditDetail:oTotalLinea:cText( nCalculo )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD AppendGuardaLinea() CLASS DocumentosVentas

   aAdd( ::hDictionaryDetail, ::hDictionaryDetailTemporal )

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD EditGuardaLinea() CLASS DocumentosVentas

   ::hDictionaryDetail[ ::nPosDetail ] := ::hDictionaryDetailTemporal

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD lSeekArticulo() CLASS DocumentosVentas

   local cCodArt     := hGet( ::hDictionaryDetailTemporal, "Articulo" )

   if Empty( cCodArt )
      Return .f.
   end if

   cCodArt           := cSeekCodebarView( cCodArt, ::nView )

Return ( dbSeekUpperLower( cCodArt, ::nView ) )

//---------------------------------------------------------------------------//

METHOD lArticuloObsoleto() CLASS DocumentosVentas

   if !( D():Articulos( ::nView ) )->lObs
      Return .f.
   end if

   ApoloMsgStop( "Artículo catalogado como obsoleto" )

   ::oViewEditDetail:oGetArticulo:SetFocus()

Return .t.

//---------------------------------------------------------------------------//   

METHOD setProveedorArticulo() CLASS DocumentosVentas

   local cRefProveedor
   
   cRefProveedor     := Padr( cRefPrvArt( ( D():Articulos( ::nView ) )->Codigo, ( D():Articulos( ::nView ) )->cPrvHab , D():ProveedorArticulo( ::nView ) ) , 18 )

   ::hSetDetail( "Proveedor", ( D():Articulos( ::nView ) )->cPrvHab )
   ::hSetDetail( "NombreProveedor", RetFld( ( D():Articulos( ::nView ) )->cPrvHab, D():Proveedores( ::nView ) ) )
   ::hSetDetail( "ReferenciaProveedor", cRefProveedor )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setLote() CLASS DocumentosVentas

   if ( D():Articulos( ::nView ) )->lLote

      ::hSetDetail( "LogicoLote", ( D():Articulos( ::nView ) )->lLote )
      ::hSetDetail( "Lote", ( D():Articulos( ::nView ) )->cLote )

      ::oViewEditDetail:ShowLote()

   else

      ::oViewEditDetail:HideLote()

   end if

   ::oViewEditDetail:RefreshLote()

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetTipoImpuesto() CLASS DocumentosVentas

   if hGet( ::hDictionaryMaster, "TipoImpuesto" ) <= 1
      ::hSetDetail( "PorcentajeImpuesto", nIva( D():TiposIva( ::nView ), ( D():Articulos( ::nView ) )->TipoIva ) )
      ::hSetDetail( "RecargoEquivalencia", nReq( D():TiposIva( ::nView ), ( D():Articulos( ::nView ) )->TipoIva ) )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetImpuestoEspecial() CLASS DocumentosVentas

   if !Empty( ( D():Articulos( ::nView ) )->cCodImp )

      ::hSetDetail( "ImpuestoEspecial", ( D():Articulos( ::nView ) )->cCodImp )
      ::hSetDetail( "ImporteImpuestoEspecial", ::getValorImpuestoEspecial() )
      ::hSetDetail( "VolumenImpuestosEspeciales", RetFld( ( D():Articulos( ::nView ) )->cCodImp, D():ImpuestosEspeciales( ::nView ):cAlias, "lIvaVol" ) )

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetPrecioCosto() CLASS DocumentosVentas

   local nCosto   := nCosto(  hGet( ::hDictionaryDetailTemporal, "Articulo" ),;
                              D():Articulos( ::nView ),;
                              D():Kit( ::nView ),;
                              .f., ,;
                              D():Divisas( ::nView ) )


   ::hSetDetail( "PrecioCosto", nCosto )

   if !uFieldEmpresa( "lCosAct" )
      ::SetPrecioCostoMedio()       //Método Virtual no creado
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetPrecioVenta() CLASS DocumentosVentas

   ::SetPrecioArticulo()
   ::SetPrecioTarifaCliente()    //Método Virtual no creado
   ::SetPrecioAtipicaCliente()   //Método Virtual no creado
   ::SetPrecioOfertaArticulo()   //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetPrecioArticulo CLASS DocumentosVentas

   local nPrecio   := nRetPreArt(   hGet( ::hDictionaryDetailTemporal, "Tarifa" ),;
                                    hGet( ::hDictionaryMaster, "Divisa" ),;
                                    hGet( ::hDictionaryMaster, "ImpuestosIncluidos" ),;
                                    D():Articulos( ::nView ),;
                                    D():Divisas( ::nView ),;
                                    D():Kit( ::nView ),;
                                    D():TiposIva( ::nView ) )

   ::hSetDetail( "PrecioVenta", nPrecio )

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetComisionAgente() CLASS DocumentosVentas

   ::SetComisionMaster()
   ::SetComisionTarifaCliente()     //Método Virtual no creado
   ::SetComisionAtipicaCliente()    //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuentoPorcentual() CLASS DocumentosVentas

   ::SetDescuentoPorcentualArticulo()
   ::SetDescuentoPorcentualTarifaCliente()   //Método Virtual no creado
   ::SetDescuentoPorcentualAtipicaCliente()  //Método Virtual no creado
   ::SetDescuentoPorcentualOfertaArticulo()  //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuentoPromocional() CLASS DocumentosVentas

   ::SetDescuentoPromocionalTarifaCliente()     //Método Virtual no creado
   ::SetDescuentoPromocionalAtipicaCliente()    //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDescuentoLineal() CLASS DocumentosVentas

   ::SetDescuentoLinealTarifaCliente()       //Método Virtual no creado
   ::SetDescuentoLinealAtipicaCliente()      //Método Virtual no creado
   ::SetDescuentoLinealOfertaArticulo()      //Método Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD CargaArticulo() CLASS DocumentosVentas

   local cCodArt  := hGet( ::hDictionaryDetailTemporal, "Articulo" )

   if Empty( cCodArt )
      Return .f.
   end if

   if cCodArt == ::cOldCodidoArticulo
      Return .f.
   end if

   if !::lSeekArticulo()
      ApoloMsgStop( "Artículo no encontrado" )
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

   ::cOldCodidoArticulo    := hGet( ::hDictionaryDetailTemporal, "Articulo" )

   ::oViewEditDetail:RefreshDialog()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD lValidResumenVenta() CLASS DocumentosVentas

   local lReturn  := .t.
   
   /*
   Comprobamos que el cliente no esté vacío-----------------------------------

   if Empty( hGet( ::hDictionaryMaster, "Cliente" ) )
      ApoloMsgStop( "Cliente no puede estar vacío.", "¡Atención!" )
      return .f.
   end if

   /*
   Comprobamos que el documento tenga líneas----------------------------------

   if len( ::hDictionaryDetail ) <= 0
      ApoloMsgStop( "No puede almacenar un documento sin lineas.", "¡Atención!" )
      return .f.
   end if

Return lReturn

//---------------------------------------------------------------------------//

METHOD ResumenVenta( oCbxRuta, oDlg ) CLASS DocumentosVentas

   if !::lValidResumenVenta()
      Return .f.
   end if

   ::setUltimoCliente( oCbxRuta )

   ::oViewEditResumen            := ViewEditResumen():New( self )

   if !Empty( ::oViewEditResumen )

      ::oViewEditResumen:SetTextoTipoDocumento( "Resumen documento" )

      ::oViewEditResumen:SetCodigoCliente( hGet( ::hDictionaryMaster, "Cliente" ) )
      ::oViewEditResumen:SetNombreCliente( hGet( ::hDictionaryMaster, "NombreCliente" ) )

      ::oViewEditResumen:SetCodigoFormaPago( hGet( ::hDictionaryMaster, "Pago" ) )
      ::oViewEditResumen:SetNombreFormaPago( cNbrFPago( hGet( ::hDictionaryMaster, "Pago" ), D():FormasPago( ::nView ) ) )

      ::oViewEditResumen:SetArrayBrowseIva( ::hTotalIva )

      ::SetDocumentosFacturas()

      ::oViewEditResumen:ResourceViewEditResumen( ::oDlg )

   end if

   oDlg:End()

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDocumentosFacturas() CLASS DocumentosVentas

   local cSerie         := hGet( ::hDictionaryMaster, "Serie" )
   local cDocumento     := ""
   local cFormato
   local nFormato
   local aFormatos      := aDocs( "FC", D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( cSerie, "nFacCli", D():Contadores( ::nView ) )

   if Empty( cFormato )
      cFormato          := cFirstDoc( "FC", D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )*/

//---------------------------------------------------------------------------//