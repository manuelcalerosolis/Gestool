#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastVentasClientes FROM TFastReportInfGen

   DATA  cType                            INIT "Clientes"

   DATA  oObras
   DATA  oBancos
   DATA  oCliAtp
   DATA  oCliDoc
   DATA  oCliInc
   DATA  oTipInc

   DATA  oPais

   DATA  oStock

   DATA  cExpresionHeader

   DATA  lApplyFilters                    INIT .t.

   DATA oCamposExtra
   DATA aExtraFields                      INIT {}

   DATA  aTypeDocs                        INIT { "C", "N", "D", "L", "C" } 

   METHOD lResource()

   METHOD Create()
   METHOD lGenerate()
   METHOD lValidRegister()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD DataReport()
   METHOD AddVariable()

   METHOD StartDialog()
   METHOD BuildTree( oTree )

   METHOD AddSATCliente()
   METHOD AddPresupuestoCliente()
   METHOD AddPedidoCliente( cCodigoCliente )
   METHOD AddAlbaranCliente()
   METHOD AddFacturaCliente()
   METHOD AddFacturaRectificativa()
   METHOD AddTicket()
   METHOD AddRecibosCliente( cFieldOrder )
   METHOD AddRecibosClienteCobro()        INLINE ( ::addRecibosCliente( 'dEntrada' ) )
   METHOD AddRecibosClienteVencimiento()  INLINE ( ::addRecibosCliente( 'dFecVto' ) )

   METHOD insertFacturaCliente()
   METHOD insertRectificativa()
   METHOD insertTicketCliente()

   METHOD AddClientes()

   METHOD idDocumento()                   INLINE ( ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc )
   METHOD idDocumentoLinea()              INLINE ( ::idDocumento() )

   METHOD setMeterText( cText )           INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:cText := cText, ) )
   METHOD setMeterTotal( nTotal )         INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:SetTotal( nTotal ), ) )
   METHOD setMeterAutoIncremental()       INLINE ( if ( !empty( ::oMtrInf ), ::oMtrInf:AutoInc(), ) )

   METHOD preCliInfo( cTitle )

   METHOD RiesgoAlcanzado()               INLINE ( ::oStock:nRiesgo( ::oDbf:cCodCli ) )
   METHOD TotalFacturado()                INLINE ( ::oStock:nFacturado( ::oDbf:cCodCli ) )
   METHOD nFacturacionCliente()           INLINE ( ::oStock:nFacturacionCliente( ::oDbf:cCodCli ) )
   METHOD TotalPendiente()                INLINE ( ::oStock:nFacturacionPendiente( ::oDbf:cCodCli ) )
   METHOD nPedidoCliente()                INLINE ( ::oStock:nPedidoCliente( ::oDbf:cCodCli ) )
   METHOD nPagadoCliente()                INLINE ( ::oStock:nPagadoCliente( ::oDbf:cCodCli ) )
   
   METHOD setFilterClientIdHeader()       INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader   += ' .and. ( alltrim( Field->cCodCli ) >= "' + alltrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. alltrim( Field->cCodCli ) <= "' + alltrim( ::oGrupoCliente:Cargo:Hasta ) + '" )', ) )
   
   METHOD setFilterPaymentId()            INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cCodPgo >= "' + ::oGrupoFpago:Cargo:Desde + '" .and. Field->cCodPgo <= "' + ::oGrupoFpago:Cargo:Hasta + '" )', ) )

   METHOD setFilterPaymentInvoiceId()     INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cCodPago >= "' + ::oGrupoFpago:Cargo:Desde + '" .and. Field->cCodPago <= "' + ::oGrupoFpago:Cargo:Hasta + '" )', ) )
   
   METHOD setFilterRouteId()              INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cCodRut >= "' + ::oGrupoRuta:Cargo:Desde + '" .and. Field->cCodRut <= "' + ::oGrupoRuta:Cargo:Hasta + '" )', ) )

   METHOD setFilterAgentId()              INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cCodAge >= "' + ::oGrupoAgente:Cargo:Desde + '" .and. Field->cCodAge <= "' + ::oGrupoAgente:Cargo:Hasta + '" )', ) )

   METHOD setFilterUserId()               INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cCodUsr >= "' + ::oGrupoUsuario:Cargo:Desde + '" .and. Field->cCodUsr <= "' + ::oGrupoUsuario:Cargo:Hasta + '" )', ) )

   METHOD setFilterAlmacenId()            INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cCodAlm >= "' + ::oGrupoAlmacen:Cargo:Desde + '" .and. Field->cCodAlm <= "' + ::oGrupoAlmacen:Cargo:Hasta + '" )', ) )

   METHOD setFilterAlmacenTicketId()      INLINE ( if( ::lApplyFilters,;
                                                   ::cExpresionHeader  += ' .and. ( Field->cAlmTik >= "' + ::oGrupoAlmacen:Cargo:Desde + '" .and. Field->cAlmTik <= "' + ::oGrupoAlmacen:Cargo:Hasta + '" )', ) )

   METHOD AddFieldCamposExtra()
   METHOD loadValuesExtraFields()

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource() CLASS TFastVentasClientes

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de ventas"

   if !::lTabletVersion
      if !::NewResource()
         return .f.
      end if
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoCliente( .t. )
      return .f.
   end if

   if !::lGrupoGrupoCliente( .t. )
      return .f.
   end if

   if !::lGrupoAlmacen( .t. )
      return .f.
   end if

   if !::lGrupoFpago( .t. )
      return .f.
   end if

   if !::lGrupoRuta( .t. )
      return .f.
   end if

   if !::lGrupoAgente( .t. )
      return .f.
   end if

   if !::lGrupoUsuario( .t. )
      return .f.
   end if

   if !::lGrupoSerie( .t. )
      return .f.
   end if

   if !::lGrupoSufijo( .t. )
      return .f.
   end if

   if !::lGrupoIva( .t. )
      return .t.
   end if

   ::oFilter      := TFilterCreator():Init()
   if !Empty( ::oFilter )
      ::oFilter:SetDatabase( ::oDbf )
      ::oFilter:SetFilterType( CLI_TBL )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastVentasClientes

   local lOpen    := .t.
   local oError
   local oBlock


   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::lApplyFilters   := lAIS()

      ::oSatCliT        := TDataCenter():oSatCliT()
      ::oSatCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oSatCliL PATH ( cPatEmp() ) CLASS "SatCliL" FILE "SatCliL.DBF" VIA ( cDriver() ) SHARED INDEX "SatCliL.CDX"

      ::oPreCliT        := TDataCenter():oPreCliT()
      ::oPreCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) CLASS "PreCliL" FILE "PreCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PreCliL.CDX"

      ::oPedCliT        := TDataCenter():oPedCliT()
      ::oPedCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) CLASS "PedCliL" FILE "PedCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliL.CDX"

      ::oAlbCliT        := TDataCenter():oAlbCliT()
      ::oAlbCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

      ::oFacCliT        := TDataCenter():oFacCliT()  
      ::oFacCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      ::oFacCliP        := TDataCenter():oFacCliP()

      DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) CLASS "AntCliT" FILE "AntCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "AntcliT.Cdx"

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) CLASS "FACRECT" FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) CLASS "FACRECL" FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

      DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) CLASS "TIKET"   FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

      DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) CLASS "TIKEL"   FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

      DATABASE NEW ::oObras   PATH ( cPatCli() ) CLASS "OBRAST"  FILE "ObrasT.DBF"  VIA ( cDriver() ) SHARED INDEX "ObrasT.CDX"

      DATABASE NEW ::oBancos  PATH ( cPatCli() ) CLASS "CliBnc"  FILE "CliBnc.DBF"  VIA ( cDriver() ) SHARED INDEX "CliBnc.CDX"

      DATABASE NEW ::oCliAtp  PATH ( cPatCli() ) CLASS "CliAtp"   FILE "CliAtp.Dbf" VIA ( cDriver() ) SHARED INDEX "CliAtp.Cdx"

      DATABASE NEW ::oCliDoc  PATH ( cPatCli() ) CLASS "CliDoc"   FILE "ClientD.Dbf" VIA ( cDriver() ) SHARED INDEX "ClientD.Cdx"

      DATABASE NEW ::oCliInc  PATH ( cPatCli() ) CLASS "CliInc"   FILE "CliInc.Dbf" VIA ( cDriver() ) SHARED INDEX "CliInc.Cdx"

      DATABASE NEW ::oDbfCli PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oDbfAge PATH ( cPatCli() ) FILE "AGENTES.DBF" VIA ( cDriver() ) SHARED INDEX "AGENTES.CDX"
      
      DATABASE NEW ::oDbfRut PATH ( cPatCli() ) FILE "RUTA.DBF" VIA ( cDriver() ) SHARED INDEX "RUTA.CDX"
      
      DATABASE NEW ::oDbfFpg PATH ( cPatEmp() ) FILE "FPago.Dbf" VIA ( cDriver() ) SHARED INDEX "FPago.Cdx"

      DATABASE NEW ::oDbfUsr PATH ( cPatDat() ) FILE "USERS.DBF" VIA ( cDriver() ) SHARED INDEX "USERS.CDX"

      DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE "TIva.Dbf" VIA ( cDriver() ) SHARED INDEX "TIva.Cdx"

      ::oGrpCli               := TGrpCli():Create( cPatCli() )
      ::oGrpCli:OpenService()

      ::oCnfFlt               := TDataCenter():oCnfFlt()

      ::oPais                 := TPais():Create( cPatDat() )
      if !::oPais:OpenFiles()
         lOpen                := .f.
      end if

      /*
      Stocks de articulos------------------------------------------------------
      */

      ::oStock                := TStock():Create( cPatEmp() )
      if !::oStock:lOpenFiles()
         lOpen                := .f.
      end if

      ::oCamposExtra          := TDetCamposExtra():New( cPatEmp(), ::cDriver )
      if !::oCamposExtra:OpenFiles()
         lOpen                := .f.
      else 
         ::oCamposExtra:setTipoDocumento( "Facturas a clientes" )
         ::aExtraFields       := ::oCamposExtra:aExtraFields()
      end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de clientes" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastVentasClientes

   if !Empty( ::oSatCliL ) .and. ( ::oSatCliL:Used() )
      ::oSatCliL:end()
   end if

   if !Empty( ::oSatCliT ) .and. ( ::oSatCliT:Used() )
      ::oSatCliT:end()
   end if

   if !Empty( ::oPreCliL ) .and. ( ::oPreCliL:Used() )
      ::oPreCliL:end()
   end if

   if !Empty( ::oPreCliT ) .and. ( ::oPreCliT:Used() )
      ::oPreCliT:end()
   end if

   if !Empty( ::oPedCliL ) .and. ( ::oPedCliL:Used() )
      ::oPedCliL:end()
   end if

   if !Empty( ::oPedCliT ) .and. ( ::oPedCliT:Used() )
      ::oPedCliT:end()
   end if

   if !Empty( ::oAlbCliL ) .and. ( ::oAlbCliL:Used() )
      ::oAlbCliL:end()
   end if

   if !Empty( ::oAlbCliT ) .and. ( ::oAlbCliT:Used() )
      ::oAlbCliT:end()
   end if

   if !Empty( ::oFacCliL ) .and. ( ::oFacCliL:Used() )
      ::oFacCliL:end()
   end if

   if !Empty( ::oFacCliT ) .and. ( ::oFacCliT:Used() )
      ::oFacCliT:end()
   end if

   if !Empty( ::oFacCliP ) .and. ( ::oFacCliP:Used() )
      ::oFacCliP:end()
   end if

   if !Empty( ::oAntCliT ) .and. ( ::oAntCliT:Used() )
      ::oAntCliT:end()
   end if

   if !Empty( ::oFacRecL ) .and. ( ::oFacRecL:Used() )
      ::oFacRecL:end()
   end if

   if !Empty( ::oFacRecT ) .and. ( ::oFacRecT:Used() )
      ::oFacRecT:end()
   end if

   if !Empty( ::oTikCliT ) .and. ( ::oTikCliT:Used() )
      ::oTikCliT:End()
   end if

   if !Empty( ::oTikCliL ) .and. ( ::oTikCliL:Used() )
      ::oTikCliL:End()
   end if

   if !Empty( ::oObras ) .and. ( ::oObras:Used() )
      ::oObras:End()
   end if

   if !Empty( ::oBancos ) .and. ( ::oBancos:Used() )
      ::oBancos:End()
   end if

   if !Empty( ::oCliAtp ) .and. ( ::oCliAtp:Used() )
      ::oCliAtp:End()
   end if 

   if !Empty( ::oCliDoc ) .and. ( ::oCliDoc:Used() )
      ::oCliDoc:End()
   end if 

   if !Empty( ::oCliInc ) .and. ( ::oCliInc:Used() )
      ::oCliInc:End()
   end if 

   if !Empty( ::oTipInc ) .and. ( ::oTipInc:Used() )
      ::oTipInc:End()
   end if 

   if !Empty( ::oCnfFlt ) .and. ( ::oCnfFlt:Used() )
      ::oCnfFlt:end()
   end if

   if !empty( ::oDbfCli ) .and. ( ::oDbfCli:Used() )
      ::oDbfCli:end()
   end if 

   if !empty( ::oDbfAge ) .and. ( ::oDbfAge:Used() )
      ::oDbfAge:end()
   end if 

   if !empty( ::oDbfRut ) .and. ( ::oDbfRut:Used() )
      ::oDbfRut:end()
   end if 

   if !empty( ::oDbfFpg ) .and. ( ::oDbfFpg:Used() )
      ::oDbfFpg:end()
   end if 

   if !empty( ::oDbfUsr ) .and. ( ::oDbfUsr:Used() )
      ::oDbfUsr:end()
   end if 

   if !empty( ::oDbfIva ) .and. ( ::oDbfIva:Used() )
      ::oDbfIva:end()
   end if 

   if !empty( ::oGrpCli )
      ::oGrpCli:end()
   end if

   if !empty( ::oPais )
      ::oPais:end()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   if !Empty( ::oCamposExtra )
      ::oCamposExtra:CloseFiles()
      ::oCamposExtra:End()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasClientes

   ::AddField( "cCodCli",  "C", 12, 0, {|| "@!" }, "Código cliente"                          )
   ::AddField( "cNomCli",  "C",100, 0, {|| ""   }, "Nombre cliente"                          )
//   ::AddField( "cNifCli",  "C", 30, 0, {|| "@!" }, "NIF cliente"                             )

   ::AddField( "cCodTip",  "C", 12, 0, {|| "@!" }, "Código del tipo de cliente"              )
   ::AddField( "cCodGrp",  "C", 12, 0, {|| "@!" }, "Código grupo de cliente"                 )
   ::AddField( "cCodPgo",  "C",  2, 0, {|| "@!" }, "Código de forma de pago"                 )
   ::AddField( "cCodRut",  "C", 12, 0, {|| "@!" }, "Código de la ruta"                       )
   ::AddField( "cCodAge",  "C", 12, 0, {|| "@!" }, "Código del agente"                       )
   ::AddField( "cCodUsr",  "C",  3, 0, {|| "@!" }, "Código usuario"                          )
   ::AddField( "cCodObr",  "C", 10, 0, {|| "@!" }, "Código dirección"                        )
   ::AddField( "cCodAlm",  "C", 16, 0, {|| "@!" }, "Código almacén"                          )

   ::AddField( "cCodTip",  "C", 12, 0, {|| "@!" }, "Código del tipo de cliente"              )

   ::AddField( "cTipDoc",  "C", 30, 0, {|| "" },   "Tipo de documento"                       )

   ::AddField( "cClsDoc",  "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cIdeDoc",  "C", 27, 0, {|| "" },   "Identificador del documento"             )
   ::AddField( "cSerDoc",  "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",  "C", 10, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",  "C",  2, 0, {|| "" },   "Delegación del documento"                )
   ::AddField( "cNumRec",  "C",  2, 0, {|| "" },   "Número del recibo"                       )
   ::AddField( "cCodPos",  "C", 15, 0, {|| "@!" }, "Código postal del documento"             )
   ::AddField( "cTipRec",  "C",  1, 0, {|| "@!" }, "Tipo de recibo"                          )

   ::AddField( "nAnoDoc",  "N",  4, 0, {|| "" },   "Año del documento"                       )
   ::AddField( "nMesDoc",  "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecDoc",  "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cHorDoc",  "C",  2, 0, {|| "" },   "Hora del documento"                      )
   ::AddField( "cMinDoc",  "C",  2, 0, {|| "" },   "Minutos del documento"                   )

   ::AddField( "nTotNet",  "N", 16, 6, {|| "" },   "Total neto"                              )
   ::AddField( "nTotIva",  "N", 16, 6, {|| "" },   "Total " + cImp()                         )
   ::AddField( "nTotReq",  "N", 16, 6, {|| "" },   "Total RE"                                )
   ::AddField( "nTotDoc",  "N", 16, 6, {|| "" },   "Total documento"                         )
   ::AddField( "nTotPnt",  "N", 16, 6, {|| "" },   "Total punto verde"                       )
   ::AddField( "nTotTrn",  "N", 16, 6, {|| "" },   "Total transporte"                        )
   ::AddField( "nTotAge",  "N", 16, 6, {|| "" },   "Total agente"                            )
   ::AddField( "nTotCos",  "N", 16, 6, {|| "" },   "Total costo"                             )
   ::AddField( "nTotIvm",  "N", 16, 6, {|| "" },   "Total impuestos especiales"              )
   ::AddField( "nTotRnt",  "N", 16, 6, {|| "" },   "Total rentabilidad"                      )
   ::AddField( "nTotRet",  "N", 16, 6, {|| "" },   "Total retenciones"                       )
   ::AddField( "nTotCob",  "N", 16, 6, {|| "" },   "Total cobros"                            )
   ::AddField( "nIva",     "N",  6, 2, {|| "" },   "Porcentaje impuesto"                     )
   ::AddField( "nReq",     "N",  6, 2, {|| "" },   "Porcentaje recargo"                      )
   ::AddField( "lCobRec",  "L",  1, 0, {|| "" },   "Lógico recibo cobrado"                   )
   ::AddField( "nComAge",  "N",  6, 2, {|| "" },   "Comisión agente"                         )

   ::AddField( "uCargo",   "C", 20, 0, {|| "" },   "Cargo"                                   )

   ::AddField( "nNumRem",  "N",  9, 0, {|| "999999999" },   "Número de la remesa"            )
   ::AddField( "cSufRem",  "C",  2, 0, {|| "@!" },          "Sufijo de la remesa"            )
   ::AddField( "cEstado",  "C", 20, 0, {|| "" },            "Estado del documento"           )

   ::AddField( "nRieCli",  "N", 16, 0, {|| "" },            "Riesgo del cliente"             )
   ::AddField( "dFecVto",  "D",  8, 0, {|| "" },            "Vencimiento del recibo"         )

   ::AddFieldCamposExtra()

   ::AddTmpIndex( "cCodCli", "cCodCli" )
//   ::AddTmpIndex( "cNifCli", "cNifCli" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFieldCamposExtra() CLASS TFastVentasClientes

   local cField
   
   if isArray( ::aExtraFields ) .and. Len( ::aExtraFields ) != 0

      for each cField in ::aExtraFields

         ::AddField( "fld" + cField[ "código" ],;
                     ::aTypeDocs[ cField[ "tipo" ] ] ,;
                     cField[ "longitud" ],;
                     cField[ "decimales" ],;
                     {|| ::oCamposExtra:cPictData( cField ) },;
                     Capitalize( cField[ "descripción" ] ) )

      next

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TFastVentasClientes

   /*
   Imagenes--------------------------------------------------------------------
   */

   ::CreateTreeImageList()

   ::BuildTree( ::oTreeReporting, .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastVentasClientes

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports := {  {  "Title" => "Listado",                              "Image" => 0, "Type" => "Listado",                            "Directory" => "Clientes\Listado",                             "File" => "Listado.fr3"  },;
                  {  "Title" => "Ventas",                               "Image" => 11, "Subnode" =>;
                  { ;
                     { "Title" => "SAT de clientes",                    "Image" =>20, "Type" => "SAT de clientes",                     "Directory" => "Clientes\Ventas\SAT de clientes",              "File" => "SAT de clientes.fr3" },;
                     { "Title" => "Presupuestos de clientes",           "Image" => 5, "Type" => "Presupuestos de clientes",            "Directory" => "Clientes\Ventas\Presupuestos de clientes",     "File" => "Presupuestos de clientes.fr3" },;
                     { "Title" => "Pedidos de clientes",                "Image" => 6, "Type" => "Pedidos de clientes",                 "Directory" => "Clientes\Ventas\Pedidos de clientes",          "File" => "Pedidos de clientes.fr3" },;
                     { "Title" => "Albaranes de clientes",              "Image" => 7, "Type" => "Albaranes de clientes",               "Directory" => "Clientes\Ventas\Albaranes de clientes",        "File" => "Albaranes de clientes.fr3" },;
                     { "Title" => "Facturas de clientes",               "Image" => 8, "Type" => "Facturas de clientes",                "Directory" => "Clientes\Ventas\Facturas de clientes",         "File" => "Facturas de clientes.fr3" },;                                        
                     { "Title" => "Rectificativas de clientes",         "Image" => 9, "Type" => "Rectificativas de clientes",          "Directory" => "Clientes\Ventas\Rectificativas de clientes",   "File" => "Rectificativas de clientes.fr3" },;
                     { "Title" => "Tickets de clientes",                "Image" =>10, "Type" => "Tickets de clientes",                 "Directory" => "Clientes\Ventas\Tickets de clientes",          "File" => "Tickets de clientes.fr3" },;
                     { "Title" => "Facturación de clientes",            "Image" => 8, "Type" => "Facturación de clientes",             "Directory" => "Clientes\Ventas\Facturación de clientes",      "File" => "Facturación de clientes.fr3" },;
                     { "Title" => "Ventas",                             "Image" =>11, "Type" => "Ventas",                              "Directory" => "Clientes\Ventas\Ventas",                       "File" => "Ventas.fr3" },;
                     { "Title" => "Recibos fecha de emisión",           "Image" =>21, "Type" => "Recibos emisión",                     "Directory" => "Clientes\Ventas\Recibos",                      "File" => "Recibos de clientes.fr3" },;
                     { "Title" => "Recibos fecha de cobro",             "Image" =>21, "Type" => "Recibos cobro",                       "Directory" => "Clientes\Ventas\RecibosCobro",                 "File" => "Recibos de clientes fecha de cobro.fr3" },;
                     { "Title" => "Recibos fecha de vencimiento",       "Image" =>21, "Type" => "Recibos vencimiento",                 "Directory" => "Clientes\Ventas\RecibosVencimiento",           "File" => "Recibos de clientes fecha de vencimiento.fr3" },;
                  } ;
                  },;
                  {  "Title" => "Tipo de impuesto",                     "Image" =>23, "Type" => "Tipo de impuesto",                    "Directory" => "Clientes\TipoImpuesto",                         "File" => "Ventas por tipo de impuesto.fr3"  } }

   ::BuildNode( aReports, oTree, lLoadFile ) 

   //oTree:ExpandAll()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport() CLASS TFastVentasClientes

   /*
   Zona de detalle-------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Informe", ::oDbf:nArea )

   ::oFastReport:SetFieldAliases(   "Informe", cObjectsToReport( ::oDbf ) )

   /*
   Zona de datos---------------------------------------------------------------
   */

   ::oFastReport:SetWorkArea(       "Empresa",                          ::oDbfEmp:nArea )
   ::oFastReport:SetFieldAliases(   "Empresa",                          cItemsToReport( aItmEmp() ) )

   ::oFastReport:SetWorkArea(       "Clientes",                         ::oDbfCli:nArea )
   ::oFastReport:SetFieldAliases(   "Clientes",                         cItemsToReport( aItmCli() ) )

   ::oFastReport:SetWorkArea(       "País",                             ::oPais:Select() )   
   ::oFastReport:SetFieldAliases(   "País",                             cObjectsToReport( ::oPais:oDbf ) )

   ::oFastReport:SetWorkArea(       "Agentes",                          ::oDbfAge:nArea )
   ::oFastReport:SetFieldAliases(   "Agentes",                          cItemsToReport( aItmAge() ) )

   ::oFastReport:SetWorkArea(       "Rutas",                            ::oDbfRut:nArea )
   ::oFastReport:SetFieldAliases(   "Rutas",                            cItemsToReport( aItmRut() ) )

   ::oFastReport:SetWorkArea(       "Formas de pago",                   ::oDbfFpg:nArea )
   ::oFastReport:SetFieldAliases(   "Formas de pago",                   cItemsToReport( aItmFPago() ) )

   ::oFastReport:SetWorkArea(       "Grupos de cliente",                ::oGrpCli:Select() )
   ::oFastReport:SetFieldAliases(   "Grupos de cliente",                cObjectsToReport( ::oGrpCli:oDbf ) )

   ::oFastReport:SetWorkArea(       "Usuarios",                         ::oDbfUsr:nArea ) 
   ::oFastReport:SetFieldAliases(   "Usuarios",                         cItemsToReport( aItmUsuario() ) )

   ::oFastReport:SetWorkArea(       "Direcciones",                      ::oObras:nArea )
   ::oFastReport:SetFieldAliases(   "Direcciones",                      cItemsToReport( aItmObr() ) )

   ::oFastReport:SetWorkArea(       "Bancos",                           ::oBancos:nArea )
   ::oFastReport:SetFieldAliases(   "Bancos",                           cItemsToReport( aCliBnc() ) )

   ::oFastReport:SetWorkArea(       "Tarifas de cliente",               ::oCliAtp:nArea )
   ::oFastReport:SetFieldAliases(   "Tarifas de cliente",               cItemsToReport( aItmAtp() ) )

   ::oFastReport:SetWorkArea(       "Documentos",                       ::oCliDoc:nArea )
   ::oFastReport:SetFieldAliases(   "Documentos",                       cItemsToReport( aCliDoc() ) )

   ::oFastReport:SetWorkArea(       "Incidencias",                      ::oCliInc:nArea )
   ::oFastReport:SetFieldAliases(   "Incidencias",                      cItemsToReport( aCliInc() ) )

   ::oFastReport:SetWorkArea(       "Tipos de incidencias",             ::oTipInc:nArea )
   ::oFastReport:SetFieldAliases(   "Tipos de incidencias",             cItemsToReport( aItmInci() ) )

   /*
   Relaciones------------------------------------------------------------------
   */

   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",               {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Bancos",                {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Clientes",              {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tarifas de cliente",    {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Documentos",            {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Incidencias",           {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Agentes",               {|| ::oDbf:cCodAge } )
   ::oFastReport:SetMasterDetail(   "Informe", "Usuarios",              {|| ::oDbf:cCodUsr } )
   ::oFastReport:SetMasterDetail(   "Informe", "Rutas",                 {|| ::oDbf:cCodRut } )
   ::oFastReport:SetMasterDetail(   "Informe", "Formas de pago",        {|| ::oDbf:cCodPgo } )

   ::oFastReport:SetMasterDetail(   "Clientes", "Grupos de cliente",    {|| ::oDbfCli:cCodGrp } )
   ::oFastReport:SetMasterDetail(   "Clientes", "País",                 {|| ::oDbfCli:cCodPai } )

   ::oFastReport:SetMasterDetail(   "Incidencias", "Tipos de incidencias", {|| ::oCliInc:cCodTip } )

   /*
   Relación con la tabla de direcciones en funcion del tipo de informe
   */

   if ::cReportType == "Listado" 
      ::oFastReport:SetMasterDetail(   "Informe", "Direcciones",           {|| ::oDbf:cCodCli } )      
   else
      ::oFastReport:SetMasterDetail(   "Informe", "Direcciones",           {|| ::oDbf:cCodCli + ::oDbf:cCodObr } )
   end if

   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Facturas" )
   ::oFastReport:SetResyncPair(     "Informe", "Agentes" )
   ::oFastReport:SetResyncPair(     "Informe", "Bancos" )
   ::oFastReport:SetResyncPair(     "Informe", "Clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Tarifas de cliente" )
   ::oFastReport:SetResyncPair(     "Informe", "Documentos" )
   ::oFastReport:SetResyncPair(     "Informe", "Incidencias" )
   ::oFastReport:SetResyncPair(     "Informe", "Usuarios" )
   ::oFastReport:SetResyncPair(     "Informe", "Rutas" )
   ::oFastReport:SetResyncPair(     "Informe", "Formas de pago" )

   ::oFastReport:SetResyncPair(     "Clientes", "Grupos de cliente" )
   ::oFastReport:SetResyncPair(     "Clientes", "País" )

   ::oFastReport:SetResyncPair(     "Incidencias", "Tipos de incidencias" ) 

   do case
      case ::cReportType == "SAT de clientes"

         ::FastReportSATCliente()

      case ::cReportType == "Presupuestos de clientes"

         ::FastReportPresupuestoCliente()

      case ::cReportType == getConfigTraslation("Pedidos de clientes")
      
         ::FastReportPedidoCliente()

      case ::cReportType == "Albaranes de clientes"
      
         ::FastReportAlbaranCliente()

      case ::cReportType == "Facturas de clientes"
      
         ::FastReportFacturaCliente()
         
      case ::cReportType == "Rectificativas de clientes"

         ::FastReportFacturaRectificativa()

      case ::cReportType == "Tickets de clientes"

         ::FastReportTicket( .t. )

      case ::cReportType == "Facturación de clientes"

         ::FastReportFacturaCliente()
         
         ::FastReportFacturaRectificativa()

         ::FastReportTicket( .t. )

      case ::cReportType == "Ventas"

         ::FastReportAlbaranCliente()

         ::FastReportFacturaCliente()

         ::FastReportFacturaRectificativa()

         ::FastReportTicket( .t. )

      case ( "Recibos" $ ::cReportType )

         ::FastReportRecibosCliente() 

      case ::cReportType == "Tipo de impuesto"

         ::FastReportFacturaCliente()

         ::FastReportFacturaRectificativa()

         ::FastReportTicket( .t. )

   end case

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddVariable() CLASS TFastVentasClientes

   /*
   Tablas en funcion del tipo de informe---------------------------------------
   */

   do case
      case ::cReportType == "SAT de clientes"

         ::AddVariableSATCliente()

         ::AddVariableLineasSATCliente()         

      case ::cReportType == "Presupuestos de clientes"

         ::AddVariablePresupuestoCliente()

         ::AddVariableLineasPresupuestoCliente()         

      case ::cReportType == getConfigTraslation("Pedidos de clientes")
      
         ::AddVariablePedidoCliente()

         ::AddVariableLineasPedidoCliente()         

      case ::cReportType == "Albaranes de clientes"
      
         ::AddVariableAlbaranCliente()

         ::AddVariableLineasAlbaranCliente()         

      case ::cReportType == "Facturas de clientes"
      
         ::AddVariableFacturaCliente()

         ::AddVariableLineasFacturaCliente()
         
      case ::cReportType == "Rectificativas de clientes"

         ::AddVariableRectificativaCliente()
         
         ::AddVariableLineasRectificativaCliente()

      case ::cReportType == "Tickets de clientes"

         ::AddVariableTicketCliente()

         ::AddVariableLineasTicketCliente()

      case ::cReportType == "Facturación de clientes"
      
         ::AddVariableFacturaCliente()

         ::AddVariableLineasFacturaCliente()
         
         ::AddVariableRectificativaCliente()

         ::AddVariableLineasRectificativaCliente()

         ::AddVariableTicketCliente()

         ::AddVariableLineasTicketCliente()

      case ::cReportType == "Ventas"

         ::AddVariableAlbaranCliente()

         ::AddVariableFacturaCliente()
         
         ::AddVariableRectificativaCliente()

         ::AddVariableTicketCliente()   

         ::AddVariableLineasAlbaranCliente()  

         ::AddVariableLineasFacturaCliente()
         
         ::AddVariableLineasRectificativaCliente() 

         ::AddVariableLineasTicketCliente()

      case ( "Recibos" $ ::cReportType )

         ::AddVariableRecibosCliente()

      case ::cReportType == "Tipo de impuesto"
         
         ::AddVariableLineasFacturaCliente()
         
         ::AddVariableLineasRectificativaCliente()

         ::AddVariableLineasTicketCliente()

   end case

   ::oFastReport:AddVariable(    "Clientes",    "Riesgo alcanzado",   "CallHbFunc( 'oTinfGen', ['RiesgoAlcanzado'])" )
   ::oFastReport:AddVariable(    "Clientes",    "Total movimientos",  "CallHbFunc( 'oTinfGen', ['TotalFacturado'])" )
   ::oFastReport:AddVariable(    "Clientes",    "Total pendiente",    "CallHbFunc( 'oTinfGen', ['TotalPendiente'])" )
   ::oFastReport:AddVariable(    "Clientes",    "Total pagado",       "CallHbFunc( 'oTinfGen', ['nPagadoCliente'])" )
   ::oFastReport:AddVariable(    "Clientes",    "Total pedido",       "CallHbFunc( 'oTinfGen', ['nPedidoCliente'])" )
   ::oFastReport:AddVariable(    "Clientes",    "Total facturado",    "CallHbFunc( 'oTinfGen', ['nFacturacionCliente'])" )

Return ( ::Super:AddVariable() )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastVentasClientes
   
   ::oDbf:Zap()

   /*
   Recorremos clientes---------------------------------------------------------
   */

   do case
      case ::cReportType == "SAT de clientes"

         ::AddSATCliente()

      case ::cReportType == "Presupuestos de clientes"

         ::AddPresupuestoCliente()

      case ::cReportType == getConfigTraslation("Pedidos de clientes")

         ::AddPedidoCliente()
         
      case ::cReportType == "Albaranes de clientes"

         ::AddAlbaranCliente()

      case ::cReportType == "Facturas de clientes"

         ::AddFacturaCliente()   

      case ::cReportType == "Rectificativas de clientes"

         ::AddFacturaRectificativa()

      case ::cReportType == "Tickets de clientes"

         ::AddTicket( .t. )

      case ::cReportType == "Facturación de clientes"   
         ::AddFacturaCliente()
         ::AddFacturaRectificativa()
         ::AddTicket()

      case ::cReportType == "Ventas"

         ::AddAlbaranCliente( .t. )

         ::AddFacturaCliente()

         ::AddFacturaRectificativa()

         ::AddTicket()      

      case ::cReportType == "Listado"

         ::AddClientes()

      case ::cReportType == "Recibos emisión"

         ::AddRecibosCliente()   

      case ::cReportType == "Recibos cobro"

         ::AddRecibosClienteCobro()   

      case ::cReportType == "Recibos vencimiento"

         ::AddRecibosClienteVencimiento()   

      case ::cReportType == "Tipo de impuesto"

         ::insertFacturaCliente()
         ::insertRectificativa()
         ::insertTicketCliente()

   end case

   if !empty(::oFilter)
      ::oDbf:SetFilter( ::oFilter:cExpresionFilter )
   end if 

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoCliente ) CLASS TFastVentasClientes

   if !empty( ::oGrupoCliente ) .and. !( ::oDbf:cCodCli >= ::oGrupoCliente:Cargo:Desde .and. ::oDbf:cCodCli <= ::oGrupoCliente:Cargo:Hasta )
      Return .f.
   end if 

   if !empty( ::oGrupoFpago ) .and. !( ::oDbf:cCodPgo >= ::oGrupoFpago:Cargo:Desde .and. ::oDbf:cCodPgo <= ::oGrupoFpago:Cargo:Hasta )
      Return .f.
   end if 

   if !empty( ::oGrupoRuta ) .and. !( ::oDbf:cCodRut >= ::oGrupoRuta:Cargo:Desde .and. ::oDbf:cCodRut  <= ::oGrupoRuta:Cargo:Hasta )
      Return .f.
   end if 
      
   if !empty( ::oGrupoAgente ) .and. !( ::oDbf:cCodAge  >= ::oGrupoAgente:Cargo:Desde .and. ::oDbf:cCodAge <= ::oGrupoAgente:Cargo:Hasta )
      Return .f.
   end if 

   if !empty( ::oGrupoUsuario ) .and. !( ::oDbf:cCodUsr  >= ::oGrupoUsuario:Cargo:Desde  .and. ::oDbf:cCodUsr <= ::oGrupoUsuario:Cargo:Hasta )
      Return .f.
   end if 

   if !empty( ::oGrupoGCliente ) .and. !( ::oGrupoGCliente:Cargo:ValidMayorIgual( ::oDbf:cCodGrp, ::oGrupoGCliente:Cargo:Desde ) .and. ::oGrupoGCliente:Cargo:ValidMenorIgual( ::oDbf:cCodGrp, ::oGrupoGcliente:Cargo:Hasta ) )
      return .f.
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD AddSATCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitSATClientes()

      ::oSatCliT:OrdSetFocus( "cCodCli" )
      ::oSatCliL:OrdSetFocus( "nNumSat" )

      // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->dFecSat >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecSat <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. Field->cSerSat >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerSat <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. Field->cSufSat >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufSat <= "'    + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '"'

      ::setFilterClientIdHeader()

      ::setFilterPaymentId()

      ::setFilterRouteId()

      ::setFilterAgentId()

      ::setFilterUserId()

      ::setFilterAlmacenId()

      // Procesando SAT----------------------------------------------------------

      ::setMeterText( "Procesando SAT" )

      ::oSatCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oSatCliT:cFile ), ::oSatCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oSatCliT:OrdKeyCount() )

      ::oSatCliT:GoTop()

      while !::lBreak .and. !::oSatCliT:Eof()

         if lChkSer( ::oSatCliT:cSerSat, ::aSer )

            sTot              := sTotSatCli( ::oSatCliT:cSerSat + Str( ::oSatCliT:nNumSat ) + ::oSatCliT:cSufSat, ::oSatCliT:cAlias, ::oSatCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oSatCliT:cCodCli
            ::oDbf:cNomCli    := ::oSatCliT:cNomCli
           // ::oDbf:cNifCli    := ::oSatCliT:cDniCli
            ::oDbf:cCodAge    := ::oSatCliT:cCodAge
            ::oDbf:cCodPgo    := ::oSatCliT:cCodPgo
            ::oDbf:cCodRut    := ::oSatCliT:cCodRut
            ::oDbf:cCodUsr    := ::oSatCliT:cCodUsr
            ::oDbf:cCodObr    := ::oSatCliT:cCodObr
            ::oDbf:cCodAlm    := ::oSatCliT:cCodAlm

            ::oDbf:nComAge    := ::oSatCliT:nPctComAge

            ::oDbf:cCodPos    := ::oSatCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oSatCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "SAT clientes"
            ::oDbf:cClsDoc    := SAT_CLI
            ::oDbf:cSerDoc    := ::oSatCliT:cSerSat
            ::oDbf:cNumDoc    := Str( ::oSatCliT:nNumSat )
            ::oDbf:cSufDoc    := ::oSatCliT:cSufSat

            ::oDbf:cIdeDoc    :=  ::idDocumento()            

            ::oDbf:nAnoDoc    := Year( ::oSatCliT:dFecSat )
            ::oDbf:nMesDoc    := Month( ::oSatCliT:dFecSat )
            ::oDbf:dFecDoc    := ::oSatCliT:dFecSat
            ::oDbf:cHorDoc    := SubStr( ::oSatCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oSatCliT:cTimCre, 4, 2 )

            ::oDbf:nTotNet    := sTot:nTotalNeto
            ::oDbf:nTotIva    := sTot:nTotalIva
            ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc    := sTot:nTotalDocumento
            ::oDbf:nTotPnt    := sTot:nTotalPuntoVerde
            ::oDbf:nTotTrn    := sTot:nTotalTransporte
            ::oDbf:nTotAge    := sTot:nTotalAgente
            ::oDbf:nTotCos    := sTot:nTotalCosto
            ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
            ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
            ::oDbf:nTotRet    := sTot:nTotalRetencion
            ::oDbf:nTotCob    := sTot:nTotalCobrado

            ::oDbf:nRieCli    := oRetFld( ::oSatCliT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

            if ::oSatCliT:lEstado
               ::oDbf:cEstado := "Pendiente"
            else
               ::oDbf:cEstado := "Finalizado"
            end if

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::addSATClientes()

         end if

         ::oSatCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oSatCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oSatCliT:cFile ) ) 

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir SAT de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPresupuestoCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitPresupuestosClientes()

      ::oPreCliT:OrdSetFocus( "cCodCli" )
      ::oPreCliL:OrdSetFocus( "nNumPre" )

   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. Field->cSerPre >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerPre <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. Field->cSufPre >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufPre <= "'    + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '"'

      ::setFilterClientIdHeader()

      ::setFilterPaymentId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

      // procesando presupuestos-------------------------------------------------

      ::setMeterText( "Procesando presupuestos" )
      
      ::oPreCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oPreCliT:OrdKeyCount() )

      ::oPreCliT:GoTop()

      while !::lBreak .and. !::oPreCliT:Eof()

         if lChkSer( ::oPreCliT:cSerPre, ::aSer )

            sTot              := sTotPreCli( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oPreCliT:cCodCli
            ::oDbf:cNomCli    := ::oPreCliT:cNomCli
           // ::oDbf:cNifCli    := ::oPreCliT:cDniCli

            ::oDbf:cCodAge    := ::oPreCliT:cCodAge
            ::oDbf:cCodPgo    := ::oPreCliT:cCodPgo
            ::oDbf:cCodRut    := ::oPreCliT:cCodRut
            ::oDbf:cCodUsr    := ::oPreCliT:cCodUsr
            ::oDbf:cCodObr    := ::oPreCliT:cCodObr
            ::oDbf:cCodAlm    := ::oPreCliT:cCodAlm

            ::oDbf:nComAge    := ::oPreCliT:nPctComAge

            ::oDbf:cCodPos    := ::oPreCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oPreCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "Presupuesto clientes"
            ::oDbf:cClsDoc    := PRE_CLI
            ::oDbf:cSerDoc    := ::oPreCliT:cSerPre
            ::oDbf:cNumDoc    := Str( ::oPreCliT:nNumPre )
            ::oDbf:cSufDoc    := ::oPreCliT:cSufPre

            ::oDbf:cIdeDoc    :=  ::idDocumento()

            ::oDbf:nAnoDoc    := Year( ::oPreCliT:dFecPre )
            ::oDbf:nMesDoc    := Month( ::oPreCliT:dFecPre )
            ::oDbf:dFecDoc    := ::oPreCliT:dFecPre
            ::oDbf:cHorDoc    := SubStr( ::oPreCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oPreCliT:cTimCre, 4, 2 )

            ::oDbf:nTotNet    := sTot:nTotalNeto
            ::oDbf:nTotIva    := sTot:nTotalIva
            ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc    := sTot:nTotalDocumento
            ::oDbf:nTotPnt    := sTot:nTotalPuntoVerde
            ::oDbf:nTotTrn    := sTot:nTotalTransporte
            ::oDbf:nTotAge    := sTot:nTotalAgente
            ::oDbf:nTotCos    := sTot:nTotalCosto
            ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
            ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
            ::oDbf:nTotRet    := sTot:nTotalRetencion
            ::oDbf:nTotCob    := sTot:nTotalCobrado

            ::oDbf:nRieCli    := oRetFld( ::oPreCliT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

            if ::oPreCliT:lEstado
               ::oDbf:cEstado    := "Pendiente"
            else
               ::oDbf:cEstado    := "Finalizado"
            end if

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::addPresupuestosClientes()

         end if

         ::oPreCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oPreCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ) ) 

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir presupuestos de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddPedidoCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitPedidosClientes()

      ::oPedCliT:OrdSetFocus( "dFecPed" )
      ::oPedCliL:OrdSetFocus( "nNumPed" )

   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. Field->cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerPed <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. Field->cSufPed >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufPed <= "'    + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '"'
      
      ::setFilterClientIdHeader()

      ::setFilterPaymentId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

   // Procesando pedidos------------------------------------------------
   
      ::setMeterText( "Procesando pedidos" )

      ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oPedCliT:OrdKeyCount() )
      
      ::oPedCliT:GoTop()

      while !::lBreak .and. !::oPedCliT:Eof()

         if lChkSer( ::oPedCliT:cSerPed, ::aSer )

            sTot              := sTotPedCli( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oPedCliT:cCodCli
            ::oDbf:cNomCli    := ::oPedCliT:cNomCli
           // ::oDbf:cNifCli    := ::oPedCliT:cDniCli

            ::oDbf:cCodAge    := ::oPedCliT:cCodAge
            ::oDbf:cCodPgo    := ::oPedCliT:cCodPgo
            ::oDbf:cCodRut    := ::oPedCliT:cCodRut
            ::oDbf:cCodObr    := ::oPedCliT:cCodObr
            ::oDbf:cCodAlm    := ::oPedCliT:cCodAlm

            ::oDbf:nComAge    := ::oPedCliT:nPctComAge

            ::oDbf:cCodPos    := ::oPedCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oPedCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "Pedidos clientes"
            ::oDbf:cClsDoc    := PED_CLI
            ::oDbf:cSerDoc    := ::oPedCliT:cSerPed
            ::oDbf:cNumDoc    := Str( ::oPedCliT:nNumPed )
            ::oDbf:cSufDoc    := ::oPedCliT:cSufPed
            ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

            ::oDbf:nAnoDoc    := Year( ::oPedCliT:dFecPed )
            ::oDbf:nMesDoc    := Month( ::oPedCliT:dFecPed )
            ::oDbf:dFecDoc    := ::oPedCliT:dFecPed
            ::oDbf:cHorDoc    := SubStr( ::oPedCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oPedCliT:cTimCre, 4, 2 )

            ::oDbf:nTotNet    := sTot:nTotalNeto
            ::oDbf:nTotIva    := sTot:nTotalIva
            ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc    := sTot:nTotalDocumento
            ::oDbf:nTotPnt    := sTot:nTotalPuntoVerde
            ::oDbf:nTotTrn    := sTot:nTotalTransporte
            ::oDbf:nTotAge    := sTot:nTotalAgente
            ::oDbf:nTotCos    := sTot:nTotalCosto
            ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
            ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
            ::oDbf:nTotRet    := sTot:nTotalRetencion
            ::oDbf:nTotCob    := sTot:nTotalCobrado

            ::oDbf:nRieCli    := oRetFld( ::oPedCliT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

            do case
               case ::oPedCliT:nEstado <= 1
                  ::oDbf:cEstado    := "Pendiente"

               case ::oPedCliT:nEstado == 2
                  ::oDbf:cEstado    := "Parcialmente"

               case ::oPedCliT:nEstado == 3
                  ::oDbf:cEstado    := "Finalizado"

            end case

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::addPedidosClientes()

         end if

         ::oPedCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir pedidos de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaranCliente( lNoFacturados ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   DEFAULT lNoFacturados   := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitAlbaranesClientes()

      ::oAlbCliT:OrdSetFocus( "dFecAlb" )
      ::oAlbCliL:OrdSetFocus( "nNumAlb" )

      // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader       := '( Field->dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
      
      if lNoFacturados
         ::cExpresionHeader    += ' .and. ( nFacturado < 3 ) ' 
      end if

      ::cExpresionHeader       += ' .and. ( Field->cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerAlb <= "' + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '" ) '
      ::cExpresionHeader       += ' .and. ( Field->cSufAlb >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufAlb <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'

      ::setFilterClientIdHeader()

      ::setFilterPaymentInvoiceId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

      // Procesando albaranes-----------------------------------------------------

      ::setMeterText( "Procesando albaranes" )
      
      ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oAlbCliT:OrdKeyCount() )

      ::oAlbCliT:GoTop()
      while !::lBreak .and. !::oAlbCliT:Eof()

         if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

            sTot              := sTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
            ::oDbf:cNomCli    := ::oAlbCliT:cNomCli
           // ::oDbf:cNifCli    := ::oAlbCliT:cDniCli

            ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
            ::oDbf:cCodPgo    := ::oAlbCliT:cCodPago
            ::oDbf:cCodRut    := ::oAlbCliT:cCodRut
            ::oDbf:cCodObr    := ::oAlbCliT:cCodObr
            ::oDbf:cCodAlm    := ::oAlbCliT:cCodAlm

            ::oDbf:nComAge    := ::oAlbCliT:nPctComAge

            ::oDbf:cCodPos    := ::oAlbCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "Albaranes clientes"
            ::oDbf:cClsDoc    := ALB_CLI
            ::oDbf:cSerDoc    := ::oAlbCliT:cSerAlb
            ::oDbf:cNumDoc    := Str( ::oAlbCliT:nNumAlb )
            ::oDbf:cSufDoc    := ::oAlbCliT:cSufAlb
            ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

            ::oDbf:nAnoDoc    := Year( ::oAlbCliT:dFecAlb )
            ::oDbf:nMesDoc    := Month( ::oAlbCliT:dFecAlb )
            ::oDbf:dFecDoc    := ::oAlbCliT:dFecAlb
            ::oDbf:cHorDoc    := SubStr( ::oAlbCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oAlbCliT:cTimCre, 4, 2 )

            ::oDbf:nTotNet    := sTot:nTotalNeto
            ::oDbf:nTotIva    := sTot:nTotalIva
            ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc    := sTot:nTotalDocumento
            ::oDbf:nTotPnt    := sTot:nTotalPuntoVerde
            ::oDbf:nTotTrn    := sTot:nTotalTransporte
            ::oDbf:nTotAge    := sTot:nTotalAgente
            ::oDbf:nTotCos    := sTot:nTotalCosto
            ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
            ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
            ::oDbf:nTotRet    := sTot:nTotalRetencion
            ::oDbf:nTotCob    := sTot:nTotalCobrado

            ::oDbf:nRieCli    := oRetFld( ::oAlbCliT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

            do case
               case ::oAlbCliT:nFacturado <= 1
                  ::oDbf:cEstado    := "Pendiente"

               case ::oAlbCliT:nFacturado == 2
                  ::oDbf:cEstado    := "Parcialmente"

               case ::oAlbCliT:nFacturado == 3
                  ::oDbf:cEstado    := "Finalizado"

            end case

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::addAlbaranesClientes()

         end if

         ::oAlbCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir albaranes de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   //oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   //BEGIN SEQUENCE
   
      ::InitFacturasClientes()

      ::oFacCliT:OrdSetFocus( "dFecFac" )
      ::oFacCliL:OrdSetFocus( "nNumFac" )

      // filtros para la cabecera----------------------------------------------
   
      ::cExpresionHeader          := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      if !empty( ::oGrupoSerie )
         ::cExpresionHeader       += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '" ) '
      end if 
      if !Empty( ::oGrupoSufijo )
         ::cExpresionHeader       += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'
      end if

      ::setFilterClientIdHeader()

      ::setFilterPaymentInvoiceId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

      // procesando facturas------------------------------------------------
   
      ::setMeterText( "Procesando facturas" )
      
      ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oFacCliT:OrdKeyCount() )

      ::oFacCliT:GoTop()
      while !::lBreak .and. !::oFacCliT:Eof()

         if lChkSer( ::oFacCliT:cSerie, ::aSer )

            sTot              := sTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oFacCliT:cCodCli
            ::oDbf:cNomCli    := ::oFacCliT:cNomCli
           // ::oDbf:cNifCli    := ::oFacCliT:cDniCli

            ::oDbf:cCodAge    := ::oFacCliT:cCodAge
            ::oDbf:cCodPgo    := ::oFacCliT:cCodPago
            ::oDbf:cCodRut    := ::oFacCliT:cCodRut
            ::oDbf:cCodUsr    := ::oFacCliT:cCodUsr
            ::oDbf:cCodObr    := ::oFacCliT:cCodObr
            ::oDbf:cCodAlm    := ::oFacCliT:cCodAlm

            ::oDbf:nComAge    := ::oFacCliT:nPctComAge

            ::oDbf:cCodPos    := ::oFacCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "Factura clientes"
            ::oDbf:cClsDoc    := FAC_CLI          
            ::oDbf:cSerDoc    := ::oFacCliT:cSerie
            ::oDbf:cNumDoc    := Str( ::oFacCliT:nNumFac )
            ::oDbf:cSufDoc    := ::oFacCliT:cSufFac
            ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

            ::oDbf:nAnoDoc    := Year( ::oFacCliT:dFecFac )
            ::oDbf:nMesDoc    := Month( ::oFacCliT:dFecFac )
            ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
            ::oDbf:cHorDoc    := SubStr( ::oFacCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oFacCliT:cTimCre, 4, 2 )

            ::oDbf:nTotNet    := sTot:nTotalNeto
            ::oDbf:nTotIva    := sTot:nTotalIva
            ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
            ::oDbf:nTotDoc    := sTot:nTotalDocumento
            ::oDbf:nTotPnt    := sTot:nTotalPuntoVerde
            ::oDbf:nTotTrn    := sTot:nTotalTransporte
            ::oDbf:nTotAge    := sTot:nTotalAgente
            ::oDbf:nTotCos    := sTot:nTotalCosto
            ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
            ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
            ::oDbf:nTotRet    := sTot:nTotalRetencion
            ::oDbf:nTotCob    := sTot:nTotalCobrado

            ::oDbf:nRieCli    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

            ::oDbf:cEstado    := cChkPagFacCli( ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc, ::oFacCliT:cAlias, ::oFacCliP:cAlias )

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::loadValuesExtraFields()

         end if

         ::oFacCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   
   // RECOVER USING oError
   //    msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )
   // END SEQUENCE
   // ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitFacturasRectificativasClientes()

      ::oFacRecT:OrdSetFocus( "dFecFac" )
      ::oFacRecL:OrdSetFocus( "nNumFac" )

   // filtros para la cabecera------------------------------------------------
   
      ::cExpresionHeader          := '( Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
      ::cExpresionHeader          += ' .and. ( Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '" )'
      ::cExpresionHeader          += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'
      
      ::setFilterClientIdHeader()

      ::setFilterPaymentInvoiceId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

   // Procesando facturas recitificativas-------------------------------------

      ::setMeterText( "Procesando facturas rectificativas" )
      
      ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oFacRecT:OrdKeyCount() )

      ::oFacRecT:GoTop()

      while !::lBreak .and. !::oFacRecT:Eof()

         sTot              := sTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias )

         ::oDbf:Blank()

         ::oDbf:cCodCli    := ::oFacRecT:cCodCli            
         ::oDbf:cNomCli    := ::oFacRecT:cNomCli
        // ::oDbf:cNifCli    := ::oFacRecT:cDniCli

         ::oDbf:cCodAge    := ::oFacRecT:cCodAge
         ::oDbf:cCodPgo    := ::oFacRecT:cCodPago
         ::oDbf:cCodRut    := ::oFacRecT:cCodRut
         ::oDbf:cCodUsr    := ::oFacRecT:cCodUsr
         ::oDbf:cCodObr    := ::oFacRecT:cCodObr
         ::oDbf:cCodAlm    := ::oFacRecT:cCodAlm

         ::oDbf:nComAge    := ::oFacRecT:nPctComAge

         ::oDbf:cCodPos    := ::oFacRecT:cPosCli

         ::oDbf:cCodGrp    := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )

         ::oDbf:cTipDoc    := "Factura rectificativa"
         ::oDbf:cClsDoc    := FAC_REC
         ::oDbf:cSerDoc    := ::oFacRecT:cSerie
         ::oDbf:cNumDoc    := Str( ::oFacRecT:nNumFac )
         ::oDbf:cSufDoc    := ::oFacRecT:cSufFac
         ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

         ::oDbf:nAnoDoc    := Year( ::oFacRecT:dFecFac )
         ::oDbf:nMesDoc    := Month( ::oFacRecT:dFecFac )
         ::oDbf:dFecDoc    := ::oFacRecT:dFecFac
         ::oDbf:cHorDoc    := SubStr( ::oFacRecT:cTimCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oFacRecT:cTimCre, 4, 2 )

         ::oDbf:nTotNet    := sTot:nTotalNeto
         ::oDbf:nTotIva    := sTot:nTotalIva
         ::oDbf:nTotReq    := sTot:nTotalRecargoEquivalencia
         ::oDbf:nTotDoc    := sTot:nTotalDocumento
         ::oDbf:nTotPnt    := sTot:nTotalPuntoVerde
         ::oDbf:nTotTrn    := sTot:nTotalTransporte
         ::oDbf:nTotAge    := sTot:nTotalAgente
         ::oDbf:nTotCos    := sTot:nTotalCosto
         ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
         ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
         ::oDbf:nTotRet    := sTot:nTotalRetencion
         ::oDbf:nTotCob    := sTot:nTotalCobrado

         ::oDbf:nRieCli    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

         /*
         Añadimos un nuevo registro--------------------------------------------
         */

         if ::lValidRegister()
            ::oDbf:Insert()
         else
            ::oDbf:Cancel()
         end if

         ::addFacturasRectificativasClientes()

         ::oFacRecT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas rectificativa" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddTicket() CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitTicketsClientes()

      ::oTikCliT:OrdSetFocus( "dFecTik" )
      ::oTikCliL:OrdSetFocus( "cNumTik" )
   
   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := '( Field->dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'
      ::cExpresionHeader          += ' .and. ( Rtrim( cCliTik ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCliTik ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '")'
      ::cExpresionHeader          += ' .and. ( Field->cSerTik >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerTik <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '" )'
      ::cExpresionHeader          += ' .and. ( Field->cSufTik >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufTik <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'
     
      ::setFilterRouteId()

      ::setFilterAgentId()

      ::setFilterAlmacenTicketId()
      
   // filtros para la cabecera------------------------------------------------
   
      ::setMeterText( "Procesando tickets" )
   
      ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oTikCliT:OrdKeyCount() )

      ::oTikCliT:GoTop()
      while !::lBreak .and. !::oTikCliT:Eof()

         if lChkSer( ::oTikCliT:cSerTik, ::aSer )

            sTot              := sTotTikCli( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oTikCliT:cCliTik
            ::oDbf:cNomCli    := ::oTikCliT:cNomTik
           // ::oDbf:cNifCli    := ::oTikCliT:cDniCli

            ::oDbf:cCodAge    := ::oTikCliT:cCodAge
            ::oDbf:cCodPgo    := ::oTikCliT:cFpgTik
            ::oDbf:cCodRut    := ::oTikCliT:cCodRut
            ::oDbf:cCodUsr    := ::oTikCliT:cCcjTik
            ::oDbf:cCodObr    := ::oTikCliT:cCodObr
            ::oDbf:cCodAlm    := ::oTikCliT:cAlmTik

            ::oDbf:cCodPos    := ::oTikCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oTikCliT:cCliTik, ::oDbfCli )

            ::oDbf:cTipDoc    := "Tickets clientes"
            ::oDbf:cClsDoc    := TIK_CLI          
            ::oDbf:cSerDoc    := ::oTikCliT:cSerTik
            ::oDbf:cNumDoc    := ::oTikCliT:cNumTik
            ::oDbf:cSufDoc    := ::oTikCliT:cSufTik
            ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc
            
            ::oDbf:nAnoDoc    := Year( ::oTikCliT:dFecTik )
            ::oDbf:nMesDoc    := Month( ::oTikCliT:dFecTik )
            ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
            ::oDbf:cHorDoc    := SubStr( ::oTikCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oTikCliT:cTimCre, 4, 2 )

            ::oDbf:nTotNet    := sTot:nTotalNeto
            ::oDbf:nTotIva    := sTot:nTotalIva
            ::oDbf:nTotDoc    := sTot:nTotalDocumento
            ::oDbf:nTotAge    := sTot:nTotalAgente
            ::oDbf:nTotCos    := sTot:nTotalCosto
            ::oDbf:nTotIvm    := sTot:nTotalImpuestoHidrocarburos
            ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
            ::oDbf:nTotCob    := sTot:nTotalCobrado

            ::oDbf:nRieCli    := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Riesgo", "COD" )

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::addTicketsClientes()

         end if

         ::oTikCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddRecibosCliente( cFieldOrder ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   
   DEFAULT cFieldOrder  := 'dPreCob'

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::oFacCliP:OrdSetFocus( cFieldOrder )

      // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->' + cFieldOrder + ' >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->' + cFieldOrder + ' <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      
      if !Empty( ::oGrupoSerie )
         ::cExpresionHeader       += ' .and. Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerie <= "' + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      end if

      if !Empty( ::oGrupoSufijo )
         ::cExpresionHeader       += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'
      end if

      ::setFilterClientIdHeader()

      ::setFilterPaymentId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      // Procesando recibos------------------------------------------------------

      ::setMeterText( "Procesando recibos" )

      ::oFacCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oFacCliP:OrdKeyCount() )

      ::oFacCliP:GoTop()
      while !::lBreak .and. !::oFacCliP:Eof()

         ::oDbf:Blank()

         ::oDbf:cCodCli    := ::oFacCliP:cCodCli
         ::oDbf:cNomCli    := ::oFacCliP:cNomCli
        // ::oDbf:cNifCli    := oRetFld( ::oFacCliP:cCodCli, ::oDbfCli, 'Nif' )

         ::oDbf:cCodAge    := ::oFacCliP:cCodAge
         ::oDbf:cCodPgo    := ::oFacCliP:cCodPgo
         ::oDbf:cCodUsr    := ::oFacCliP:cCodUsr

         ::oDbf:cCodRut    := oRetFld( ::oFacCliP:cCodCli, ::oDbfCli, 'cCodRut' )
         ::oDbf:cCodPos    := oRetFld( ::oFacCliP:cCodCli, ::oDbfCli, 'cCodPos' )
         ::oDbf:cCodGrp    := cGruCli( ::oFacCliP:cCodCli, ::oDbfCli )

         ::oDbf:cTipDoc    := "Recibos clientes"
         ::oDbf:cClsDoc    := REC_CLI          
         ::oDbf:cSerDoc    := ::oFacCliP:cSerie
         ::oDbf:cNumDoc    := Str( ::oFacCliP:nNumFac )
         ::oDbf:cSufDoc    := ::oFacCliP:cSufFac
         ::oDbf:cNumRec    := Str( ::oFacCliP:nNumRec )
         ::oDbf:cIdeDoc    := Upper( ::oDbf:cClsDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc
         ::oDbf:cTipRec    := ::oFacCliP:cTipRec

         ::oDbf:nAnoDoc    := Year( ::oFacCliP:dPreCob )
         ::oDbf:nMesDoc    := Month( ::oFacCliP:dPreCob )
         ::oDbf:dFecDoc    := ::oFacCliP:dPreCob
         ::oDbf:cHorDoc    := SubStr( ::oFacCliP:cHorCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oFacCliP:cHorCre, 4, 2 )

         ::oDbf:nTotNet    := nTotRecCli( ::oFacCliP )
         ::oDbf:nTotCob    := nTotCobCli( ::oFacCliP )

         ::oDbf:nNumRem    := ::oFacCliP:nNumRem
         ::oDbf:cSufRem    := ::oFacCliP:cSufRem

         ::oDbf:dFecVto    := ::oFacCliP:dFecVto

         ::oDbf:cEstado    := cEstadoRecibo( ::oFacCliP:cAlias )

         ::oDbf:nRieCli    := oRetFld( ::oFacCliP:cCodCli, ::oDbfCli, "Riesgo", "COD" )

         // Añadimos un nuevo registro--------------------------------------------

         if ::lValidRegister()
            ::oDbf:Insert()
         else
            ::oDbf:Cancel()
         end if

         ::oFacCliP:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oFacCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir recibos de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertFacturaCliente()

   local sTot
   local oError
   local oBlock
   local aTotIva

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitFacturasClientes()

      ::oFacCliT:OrdSetFocus( "dFecFac" )
      ::oFacCliL:OrdSetFocus( "nNumFac" )

   // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'

      ::setFilterClientIdHeader()

      ::setFilterPaymentId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

   // Procesando facturas-----------------------------------------------------

      ::setMeterText( "Procesando facturas" )

      ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oFacCliT:OrdKeyCount() )

      ::oFacCliT:GoTop()

      while !::lBreak .and. !::oFacCliT:Eof()

         if lChkSer( ::oFacCliT:cSerie, ::aSer )

            sTot              := sTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )

            for each aTotIva in sTot:aTotalIva 

               if aTotIva[ 8 ] != 0       .and.;
                  ( cCodigoIva( ::oDbfIva:cAlias, aTotIva[ 3 ] ) >= ::oGrupoIva:Cargo:Desde .and. cCodigoIva( ::oDbfIva:cAlias, aTotIva[ 3 ] ) <= ::oGrupoIva:Cargo:Hasta )

                  ::oDbf:Blank()

                  ::oDbf:cCodCli    := ::oFacCliT:cCodCli
                  ::oDbf:cNomCli    := ::oFacCliT:cNomCli
                  //// ::oDbf:cNifCli    := ::oFacCliT:cDniCli

                  ::oDbf:cCodAge    := ::oFacCliT:cCodAge
                  ::oDbf:cCodPgo    := ::oFacCliT:cCodPago
                  ::oDbf:cCodRut    := ::oFacCliT:cCodRut
                  ::oDbf:cCodUsr    := ::oFacCliT:cCodUsr
                  ::oDbf:cCodObr    := ::oFacCliT:cCodObr
                  ::oDbf:nComAge    := ::oFacCliT:nPctComAge

                  ::oDbf:cCodAlm    := ::oFacCliT:cCodAlm

                  ::oDbf:cCodPos    := ::oFacCliT:cPosCli

                  ::oDbf:cCodGrp    := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )

                  ::oDbf:cTipDoc    := "Factura clientes"
                  ::oDbf:cClsDoc    := FAC_CLI          
                  ::oDbf:cSerDoc    := ::oFacCliT:cSerie
                  ::oDbf:cNumDoc    := Str( ::oFacCliT:nNumFac )
                  ::oDbf:cSufDoc    := ::oFacCliT:cSufFac
                  ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

                  ::oDbf:nAnoDoc    := Year( ::oFacCliT:dFecFac )
                  ::oDbf:nMesDoc    := Month( ::oFacCliT:dFecFac )
                  ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
                  ::oDbf:cHorDoc    := SubStr( ::oFacCliT:cTimCre, 1, 2 )
                  ::oDbf:cMinDoc    := SubStr( ::oFacCliT:cTimCre, 4, 2 )

                  ::oDbf:nIva       := aTotIva[ 3 ]
                  ::oDbf:nReq       := aTotIva[ 4 ]
                  ::oDbf:nTotNet    := aTotIva[ 2 ]
                  ::oDbf:nTotIva    := aTotIva[ 8 ]
                  ::oDbf:nTotReq    := aTotIva[ 9 ]
                  ::oDbf:nTotDoc    := sTot:nTotalDocumento
                  ::oDbf:nTotPnt    := aTotIva[ 5 ]
                  ::oDbf:nTotTrn    := aTotIva[ 7 ]
                  ::oDbf:nTotCos    := sTot:nTotalCosto
                  ::oDbf:nTotIvm    := aTotIva[ 6 ]
                  ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
                  ::oDbf:nTotRet    := sTot:nTotalRetencion
                  ::oDbf:nTotCob    := sTot:nTotalCobrado

                  ::oDbf:nRieCli    := oRetFld( ::oFacCliT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

                  /*
                  Añadimos un nuevo registro--------------------------------------------
                  */

                  if ::lValidRegister()
                     ::oDbf:Insert()
                  else
                     ::oDbf:Cancel()
                  end if

               end if

            next

         end if

         ::oFacCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertRectificativa()

   local sTot
   local oError
   local oBlock
   local aTotIva
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitFacturasRectificativasClientes()

      ::oFacRecT:OrdSetFocus( "dFecFac" )
      ::oFacRecL:OrdSetFocus( "nNumFac" )

      // filtros para la cabecera------------------------------------------------

      ::cExpresionHeader          := 'Field->dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. Field->cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. ( Field->cSufFac >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufFac <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'
      
      ::setFilterClientIdHeader()

      ::setFilterPaymentId()

      ::setFilterRouteId()

      ::setFilterAgentId()
      
      ::setFilterUserId()

      ::setFilterAlmacenId()

      // Procesando facturas rectificativas--------------------------------------

      ::setMeterText( "Procesando facturas rectificativas" )
      
      ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oFacRecT:OrdKeyCount() )

      ::oFacRecT:GoTop()
      
      while !::lBreak .and. !::oFacRecT:Eof()

         if lChkSer( ::oFacRecT:cSerie, ::aSer )

            sTot              := sTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias )

            for each aTotIva in sTot:aTotalIva 

               if aTotIva[ 8 ] != 0       .and.;
                  ( cCodigoIva( ::oDbfIva:cAlias, aTotIva[ 3 ] ) >= ::oGrupoIva:Cargo:Desde .and. cCodigoIva( ::oDbfIva:cAlias, aTotIva[ 3 ] ) <= ::oGrupoIva:Cargo:Hasta )

                  ::oDbf:Blank()

                  ::oDbf:cCodCli    := ::oFacRecT:cCodCli            
                  ::oDbf:cNomCli    := ::oFacRecT:cNomCli
                  //// ::oDbf:cNifCli    := ::oFacRecT:cDniCli

                  ::oDbf:cCodAge    := ::oFacRecT:cCodAge
                  ::oDbf:cCodPgo    := ::oFacRecT:cCodPago
                  ::oDbf:cCodRut    := ::oFacRecT:cCodRut
                  ::oDbf:cCodUsr    := ::oFacRecT:cCodUsr
                  ::oDbf:cCodObr    := ::oFacRecT:cCodObr
                  ::oDbf:nComAge    := ::oFacrecT:nPctComAge
                  ::oDbf:cCodAlm    := ::oFacRecT:cCodAlm

                  ::oDbf:cCodPos    := ::oFacRecT:cPosCli

                  ::oDbf:cCodGrp    := cGruCli( ::oFacRecT:cCodCli, ::oDbfCli )

                  ::oDbf:cTipDoc    := "Factura rectificativa"
                  ::oDbf:cClsDoc    := FAC_REC
                  ::oDbf:cSerDoc    := ::oFacRecT:cSerie
                  ::oDbf:cNumDoc    := Str( ::oFacRecT:nNumFac )
                  ::oDbf:cSufDoc    := ::oFacRecT:cSufFac
                  ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

                  ::oDbf:nAnoDoc    := Year( ::oFacRecT:dFecFac )
                  ::oDbf:nMesDoc    := Month( ::oFacRecT:dFecFac )
                  ::oDbf:dFecDoc    := ::oFacRecT:dFecFac
                  ::oDbf:cHorDoc    := SubStr( ::oFacRecT:cTimCre, 1, 2 )
                  ::oDbf:cMinDoc    := SubStr( ::oFacRecT:cTimCre, 4, 2 )

                  ::oDbf:nIva       := aTotIva[ 3 ]
                  ::oDbf:nReq       := aTotIva[ 4 ]
                  ::oDbf:nTotNet    := aTotIva[ 2 ]
                  ::oDbf:nTotIva    := aTotIva[ 8 ]
                  ::oDbf:nTotReq    := aTotIva[ 9 ]
                  ::oDbf:nTotDoc    := sTot:nTotalDocumento
                  ::oDbf:nTotPnt    := aTotIva[ 5 ]
                  ::oDbf:nTotTrn    := aTotIva[ 7 ]
                  ::oDbf:nTotCos    := sTot:nTotalCosto
                  ::oDbf:nTotIvm    := aTotIva[ 6 ]
                  ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
                  ::oDbf:nTotRet    := sTot:nTotalRetencion
                  ::oDbf:nTotCob    := sTot:nTotalCobrado

                  ::oDbf:nRieCli    := oRetFld( ::oFacRecT:cCodCli, ::oDbfCli, "Riesgo", "COD" )

                  /*
                  Añadimos un nuevo registro--------------------------------------------
                  */

                  if ::lValidRegister()
                     ::oDbf:Insert()
                  else
                     ::oDbf:Cancel()
                  end if

                  ::addFacturasRectificativasClientes()

               end if

            next

         end if

         ::oFacRecT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas rectificativa" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD insertTicketCliente()

   local sTot
   local oError
   local oBlock
   local nPosIva        := 1
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitTicketsClientes()

      ::oTikCliT:OrdSetFocus( "dFecTik" )
      ::oTikCliL:OrdSetFocus( "cNumTik" )
   
   // filtros para la cabecera------------------------------------------------
   
      ::cExpresionHeader          := 'Field->dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Field->dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      ::cExpresionHeader          += ' .and. Rtrim( cCliTik ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCliTik ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. Field->cSerTik >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. Field->cSerTik <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'
      ::cExpresionHeader          += ' .and. ( Field->cSufTik >= "' + Rtrim( ::oGrupoSufijo:Cargo:Desde ) + '" .and. Field->cSufTik <= "' + Rtrim( ::oGrupoSufijo:Cargo:Hasta ) + '" )'

      ::setFilterRouteId()

      ::setFilterAgentId()

      ::setFilterAlmacenId()

   // Procesando tickets------------------------------------------------

      ::setMeterText( "Procesando tickets" )
      
      ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( ::cExpresionHeader ), , , , , , , , .t. )

      ::setMeterTotal( ::oTikCliT:OrdKeyCount() )

      ::oTikCliT:GoTop()
      
      while !::lBreak .and. !::oTikCliT:Eof()

         if lChkSer( ::oTikCliT:cSerTik, ::aSer )

            sTot              := sTotTikCli( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias )

            for nPosIva := 1 to 3

               if sTot:aIvaTik[ nPosIva ] != nil
                  
                  if ( cCodigoIva( ::oDbfIva:cAlias, sTot:aIvaTik[ nPosIva ] ) >= ::oGrupoIva:Cargo:Desde .and. cCodigoIva( ::oDbfIva:cAlias, sTot:aIvaTik[ nPosIva ] ) <= ::oGrupoIva:Cargo:Hasta )

                     ::oDbf:Blank()

                     ::oDbf:cCodCli    := ::oTikCliT:cCliTik
                     ::oDbf:cNomCli    := ::oTikCliT:cNomTik
                     //// ::oDbf:cNifCli    := ::oTikCliT:cDniCli

                     ::oDbf:cCodAge    := ::oTikCliT:cCodAge
                     ::oDbf:cCodPgo    := ::oTikCliT:cFpgTik
                     ::oDbf:cCodRut    := ::oTikCliT:cCodRut
                     ::oDbf:cCodUsr    := ::oTikCliT:cCcjTik
                     ::oDbf:cCodObr    := ::oTikCliT:cCodObr
                     ::oDbf:cCodAlm    := ::oTikCliT:cAlmTik

                     ::oDbf:cCodPos    := ::oTikCliT:cPosCli

                     ::oDbf:cCodGrp    := cGruCli( ::oTikCliT:cCliTik, ::oDbfCli )

                     ::oDbf:cTipDoc    := "Tickets clientes"
                     ::oDbf:cClsDoc    := TIK_CLI          
                     ::oDbf:cSerDoc    := ::oTikCliT:cSerTik
                     ::oDbf:cNumDoc    := ::oTikCliT:cNumTik
                     ::oDbf:cSufDoc    := ::oTikCliT:cSufTik
                     ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc
                     
                     ::oDbf:nAnoDoc    := Year( ::oTikCliT:dFecTik )
                     ::oDbf:nMesDoc    := Month( ::oTikCliT:dFecTik )
                     ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
                     ::oDbf:cHorDoc    := SubStr( ::oTikCliT:cTimCre, 1, 2 )
                     ::oDbf:cMinDoc    := SubStr( ::oTikCliT:cTimCre, 4, 2 )

                     ::oDbf:nIva       := sTot:aIvaTik[ nPosIva ]
                     ::oDbf:nReq       := 0
                     ::oDbf:nTotNet    := sTot:aBasTik[ nPosIva ]
                     ::oDbf:nTotIva    := sTot:nTotalIva
                     ::oDbf:nTotDoc    := sTot:nTotalDocumento
                     ::oDbf:nTotAge    := sTot:nTotalAgente
                     ::oDbf:nTotCos    := sTot:nTotalCosto
                     ::oDbf:nTotIvm    := sTot:aIvmTik[ nPosIva ]
                     ::oDbf:nTotRnt    := sTot:nTotalRentabilidad
                     ::oDbf:nTotCob    := sTot:nTotalCobrado

                     ::oDbf:nRieCli    := oRetFld( ::oTikCliT:cCliTik, ::oDbfCli, "Riesgo", "COD" )

                     /*
                     Añadimos un nuevo registro--------------------------------------------
                     */

                     if ::lValidRegister()
                        ::oDbf:Insert()
                     else
                        ::oDbf:Cancel()
                     end if

                     ::addTicketsClientes()

                  end if

               end if

            next

         end if

         ::oTikCliT:Skip()

         ::setMeterAutoIncremental()

      end while

      ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddClientes() CLASS TFastVentasClientes

   ::setMeterTotal( ::oDbfCli:OrdKeyCount() )

   ::setMeterText( "Procesando clientes" )

   /*
   Recorremos clientes---------------------------------------------------------
   */

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDbfCli:GoTop()
   while !::oDbfCli:Eof() .and. !::lBreak

      ::oDbf:Blank()

      ::oDbf:cCodCli := ::oDbfCli:Cod
      ::oDbf:cNomCli := ::oDbfCli:Titulo
      ::oDbf:cCodGrp := ::oDbfCli:cCodGrp
      ::oDbf:cCodPgo := ::oDbfCli:CodPago
      ::oDbf:cCodRut := ::oDbfCli:cCodRut
      ::oDbf:cCodAge := ::oDbfCli:cAgente
      ::oDbf:cCodUsr := ""
      ::oDbf:cCodObr := ""
      ::oDbf:cCodPos := ::oDbfCli:CodPostal
      ::oDbf:nRieCli := ::oDbfCli:Riesgo

      if ::lValidRegister()
         ::oDbf:Insert()
      else
         ::oDbf:Cancel()
      end if

      ::oDbfCli:Skip()

      ::setMeterAutoIncremental()

   end while

   ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyCount() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD preCliInfo() CLASS TFastVentasClientes

   local cKey  := ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

   if ::oPreCliT:Seek( cKey )
      msgInfo( cKey, "found" )
   else
      msgStop( cKey, "not found" )
      msgStop( len( cvaltochar( ::oPreCliT:OrdKeyVal() ) ), "len OrdKeyVal")
      msgStop( ::oPreCliT:OrdSetFocus(), "ordsetfocus" )
   end if

RETURN nil 

//---------------------------------------------------------------------------//

METHOD loadValuesExtraFields() CLASS TFastVentasClientes

   local cField
   local uValor

   if isArray( ::aExtraFields ) .and. len( ::aExtraFields ) != 0

      for each cField in ::aExtraFields

         uValor             := ::oCamposExtra:valueExtraField( cField[ "código" ], ::oDbf:cSerDoc + Padr( ::oDbf:cNumDoc, 9 ) + ::oDbf:cSufDoc, cField )

         ::oDbf:fieldPutByName( "fld" + cField[ "código" ], uValor )

      next

   end if

Return nil

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TFastVentasRecibos FROM TFastVentasClientes

   METHOD BuildTree( oTree, lLoadFile ) 

   METHOD lResource() 

   METHOD lResource()
   
   METHOD Create( uParam )

END CLASS

//----------------------------------------------------------------------------//

METHOD BuildTree( oTree, lLoadFile ) CLASS TFastVentasRecibos

   local aReports

   DEFAULT oTree     := ::oTreeReporting
   DEFAULT lLoadFile := .t.

   aReports          := {  {  "Title" => "Recibos fecha de emisión",;                
                                 "Image" =>21,; 
                                 "Type" => "Recibos emisión",;              
                                 "Directory" => "Clientes\Ventas\Recibos",;                      
                                 "File" => "Recibos de clientes.fr3" },;
                           {  "Title" => "Recibos fecha de cobro",; 
                                 "Image" =>21,; 
                                 "Type" => "Recibos cobro",;        
                                 "Directory" => "Clientes\Ventas\RecibosCobro",;      
                                 "File" => "Recibos de clientes fecha de cobro.fr3" },;
                           { "Title" => "Recibos fecha de vencimiento",;
                                 "Image" =>21,; 
                                 "Type" => "Recibos vencimiento",;  
                                 "Directory" => "Clientes\Ventas\RecibosVencimiento",; 
                                 "File" => "Recibos de clientes fecha de vencimiento.fr3" } }

   ::BuildNode( aReports, oTree, lLoadFile ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource() CLASS TFastVentasRecibos

   ::Super:lResource()

   if !::lGrupoRemesas( .t. )
      return .t.
   end if 

   if !::lGrupoSufijo( .t. )
      return .t.
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasRecibos

   ::Super:Create( uParam )

RETURN ( self )

//---------------------------------------------------------------------------//

