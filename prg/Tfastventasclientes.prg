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

   DATA  oStock

   METHOD lResource( cFld )

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
   METHOD AddRecibosCliente( cCodigoCliente )

   METHOD AddClientes()

   METHOD cIdeDocumento()     INLINE ( ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc )

   METHOD preCliInfo( cTitle )

   METHOD RiesgoAlcanzado()   INLINE ( ::oStock:nRiesgo( ::oDbf:cCodCli ) )
   METHOD TotalFacturado()    INLINE ( ::oStock:nFacturado( ::oDbf:cCodCli ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastVentasClientes

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   ::cSubTitle       := "Informe de ventas"

   if !::NewResource()
      return .f.
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

   if !::lGrupoIva( .t. )
      return .t.
   end if

   ::oFilter      := TFilterCreator():Init()
   if !Empty( ::oFilter )
      ::oFilter:SetDatabase( ::oDbf )
      ::oFilter:SetFilterType( FST_CLI )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastVentasClientes

   local lOpen    := .t.
   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oSatCliT  := TDataCenter():oSatCliT()
      ::oSatCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oSatCliL PATH ( cPatEmp() ) CLASS "SatCliL" FILE "SatCliL.DBF" VIA ( cDriver() ) SHARED INDEX "SatCliL.CDX"

      ::oPreCliT  := TDataCenter():oPreCliT()
      ::oPreCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) CLASS "PreCliL" FILE "PreCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PreCliL.CDX"

      ::oPedCliT := TDataCenter():oPedCliT()
      ::oPedCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) CLASS "PedCliL" FILE "PedCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliL.CDX"

      ::oAlbCliT := TDataCenter():oAlbCliT()
      ::oAlbCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

      ::oFacCliT  := TDataCenter():oFacCliT()  
      ::oFacCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      ::oFacCliP  := TDataCenter():oFacCliP()

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

      ::oCnfFlt               := TDataCenter():oCnfFlt()

      /*
      Stocks de articulos------------------------------------------------------
      */

      ::oStock                := TStock():Create( cPatGrp() )
      if !::oStock:lOpenFiles()
         lOpen                := .f.
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

   if !Empty( ::oCnfFlt ) .and. ( ::oCnfFlt:Used() )
      ::oCnfFlt:end()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasClientes

   ::AddField( "cCodCli",  "C", 12, 0, {|| "@!" }, "Código cliente"                          )
   ::AddField( "cNomCli",  "C",100, 0, {|| ""   }, "Nombre cliente"                          )

   ::AddField( "cCodTip",  "C", 12, 0, {|| "@!" }, "Código del tipo de cliente"              )
   ::AddField( "cCodGrp",  "C", 12, 0, {|| "@!" }, "Código grupo de cliente"                 )
   ::AddField( "cCodPgo",  "C",  2, 0, {|| "@!" }, "Código de forma de pago"                 )
   ::AddField( "cCodRut",  "C", 12, 0, {|| "@!" }, "Código de la ruta"                       )
   ::AddField( "cCodAge",  "C", 12, 0, {|| "@!" }, "Código del agente"                       )
   ::AddField( "cCodUsr",  "C",  3, 0, {|| "@!" }, "Código usuario"                          )
   ::AddField( "cCodObr",  "C", 10, 0, {|| "@!" }, "Código dirección"                        )

   ::AddField( "cTipDoc",  "C", 30, 0, {|| "" },   "Tipo de documento"                       )

   ::AddField( "cClsDoc",  "C",  2, 0, {|| "" },   "Clase de documento"                      )
   ::AddField( "cIdeDoc",  "C", 27, 0, {|| "" },   "Identificador del documento"             )
   ::AddField( "cSerDoc",  "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",  "C", 10, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",  "C",  2, 0, {|| "" },   "Delegación del documento"                )
   ::AddField( "cCodPos",  "C", 15, 0, {|| "@!" }, "Código postal del documento"             )

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

   ::AddField( "uCargo",   "C", 20, 0, {|| "" },   "Cargo"                                   )

   ::AddTmpIndex( "cCodCli", "cCodCli" )

RETURN ( self )

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

   aReports := {  {  "Title" => "Listado",                        "Image" => 19, "Type" => "Listado",                      "Directory" => "Clientes\Listado",                             "File" => "Listado.fr3"  },;
                  {  "Title" => "Ventas",                         "Image" => 11, "Subnode" =>;
                  { ;
                     { "Title" => "SAT de clientes",              "Image" =>20, "Type" => "SAT de clientes",               "Directory" => "Clientes\Ventas\SAT de clientes",              "File" => "SAT de clientes.fr3" },;
                     { "Title" => "Presupuestos de clientes",     "Image" => 5, "Type" => "Presupuestos de clientes",      "Directory" => "Clientes\Ventas\Presupuestos de clientes",     "File" => "Presupuestos de clientes.fr3" },;
                     { "Title" => "Pedidos de clientes",          "Image" => 6, "Type" => "Pedidos de clientes",           "Directory" => "Clientes\Ventas\Pedidos de clientes",          "File" => "Pedidos de clientes.fr3" },;
                     { "Title" => "Albaranes de clientes",        "Image" => 7, "Type" => "Albaranes de clientes",         "Directory" => "Clientes\Ventas\Albaranes de clientes",        "File" => "Albaranes de clientes.fr3" },;
                     { "Title" => "Facturas de clientes",         "Image" => 8, "Type" => "Facturas de clientes",          "Directory" => "Clientes\Ventas\Facturas de clientes",         "File" => "Facturas de clientes.fr3" },;                                        
                     { "Title" => "Rectificativas de clientes",   "Image" => 9, "Type" => "Rectificativas de clientes",    "Directory" => "Clientes\Ventas\Rectificativas de clientes",   "File" => "Rectificativas de clientes.fr3" },;
                     { "Title" => "Tickets de clientes",          "Image" =>10, "Type" => "Tickets de clientes",           "Directory" => "Clientes\Ventas\Tickets de clientes",          "File" => "Tickets de clientes.fr3" },;
                     { "Title" => "Facturación de clientes",      "Image" => 8, "Type" => "Facturación de clientes",       "Directory" => "Clientes\Ventas\Facturación de clientes",      "File" => "Facturación de clientes.fr3" },;
                     { "Title" => "Ventas",                       "Image" =>11, "Type" => "Ventas",                        "Directory" => "Clientes\Ventas\Ventas",                       "File" => "Ventas.fr3" },;
                     { "Title" => "Recibos",                      "Image" =>21, "Type" => "Recibos",                       "Directory" => "Clientes\Ventas\Recibos",                      "File" => "Recibos de clientes.fr3" },;
                  } ;
                  }  }

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

   //::oFastReport:SetWorkArea(       "Cliente.Direcciones",              ::oObras:nArea )
   //::oFastReport:SetFieldAliases(   "Cliente.Direcciones",              cItemsToReport( aItmObr() ) )

   ::oFastReport:SetWorkArea(       "Bancos",                           ::oBancos:nArea )
   ::oFastReport:SetFieldAliases(   "Bancos",                           cItemsToReport( aCliBnc() ) )

   ::oFastReport:SetWorkArea(       "Tarifas de cliente",               ::oCliAtp:nArea )
   ::oFastReport:SetFieldAliases(   "Tarifas de cliente",               cItemsToReport( aItmAtp() ) )

   ::oFastReport:SetWorkArea(       "Documentos",                       ::oCliDoc:nArea )
   ::oFastReport:SetFieldAliases(   "Documentos",                       cItemsToReport( aCliDoc() ) )

   ::oFastReport:SetWorkArea(       "Incidencias",                      ::oCliInc:nArea )
   ::oFastReport:SetFieldAliases(   "Incidencias",                      cItemsToReport( aCliInc() ) )

   /*
   Relaciones------------------------------------------------------------------
   */

   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",               {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Direcciones",           {|| ::oDbf:cCodCli } )
   //::oFastReport:SetMasterDetail(   "Informe", "Cliente.Direcciones",   {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Bancos",                {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Clientes",              {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tarifas de cliente",    {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Documentos",            {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Incidencias",           {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Agentes",               {|| ::oDbf:cCodAge } )
   ::oFastReport:SetMasterDetail(   "Informe", "Usuarios",              {|| ::oDbf:cCodUsr } )

   ::oFastReport:SetMasterDetail(   "Clientes", "Rutas",                {|| ::oDbfCli:cCodRut } )
   ::oFastReport:SetMasterDetail(   "Clientes", "Grupos de cliente",    {|| ::oDbfCli:cCodGrp } )
   ::oFastReport:SetMasterDetail(   "Clientes", "Formas de pago",       {|| ::oDbfCli:CodPago } )

   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Facturas" )
   ::oFastReport:SetResyncPair(     "Informe", "Agentes" )
   ::oFastReport:SetResyncPair(     "Informe", "Direcciones" )
   //::oFastReport:SetResyncPair(     "Informe", "Cliente.Direcciones" )
   ::oFastReport:SetResyncPair(     "Informe", "Bancos" )
   ::oFastReport:SetResyncPair(     "Informe", "Clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Tarifas de cliente" )
   ::oFastReport:SetResyncPair(     "Informe", "Documentos" )
   ::oFastReport:SetResyncPair(     "Informe", "Incidencias" )
   ::oFastReport:SetResyncPair(     "Informe", "Usuarios" )

   ::oFastReport:SetResyncPair(     "Clientes", "Rutas" )
   ::oFastReport:SetResyncPair(     "Clientes", "Grupos de cliente" )
   ::oFastReport:SetResyncPair(     "Clientes", "Formas de pago" )

   do case
      case ::cReportType == "SAT de clientes"

         ::FastReportSATCliente()

      case ::cReportType == "Presupuestos de clientes"

         ::FastReportPresupuestoCliente()

      case ::cReportType == "Pedidos de clientes"
      
         ::FastReportPedidoCliente()

      case ::cReportType == "Albaranes de clientes"
      
         ::FastReportAlbaranCliente()

      case ::cReportType == "Facturas de clientes"
      
         ::FastReportFacturaCliente()
         
//       ::FastReportFacturaRectificativa()

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

      case ::cReportType == "Recibos"

         ::FastReportRecibosCliente()

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

      case ::cReportType == "Pedidos de clientes"
      
         ::AddVariablePedidoCliente()

         ::AddVariableLineasPedidoCliente()         

      case ::cReportType == "Albaranes de clientes"
      
         ::AddVariableAlbaranCliente()

         ::AddVariableLineasAlbaranCliente()         

      case ::cReportType == "Facturas de clientes"
      
         ::AddVariableFacturaCliente()

         ::AddVariableLineasFacturaCliente()
         
//      ::AddVariableRectificativaCliente()

//       ::AddVariableLineasRectificativaCliente()

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

      case ::cReportType == "Recibos"

         ::AddVariableRecibosCliente()

   end case

   ::oFastReport:AddVariable(    "Clientes",    "Riesgo alcanzado",   "CallHbFunc( 'oTinfGen', ['RiesgoAlcanzado'])" )
   ::oFastReport:AddVariable(    "Clientes",    "Total facturado",    "CallHbFunc( 'oTinfGen', ['TotalFacturado'])" )

Return ( Super:AddVariable() )

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

      case ::cReportType == "Pedidos de clientes"

         ::AddPedidoCliente()
         
      case ::cReportType == "Albaranes de clientes"

         ::AddAlbaranCliente()

      case ::cReportType == "Facturas de clientes"

         ::AddFacturaCliente()   

//       ::AddFacturaRectificativa()

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

      case ::cReportType == "Recibos"

         ::AddRecibosCliente()   

   end case

   ::oDbf:SetFilter( ::oFilter:cExpresionFilter )

   ::oDbf:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

Method lValidRegister( cCodigoCliente ) CLASS TFastVentasClientes

   if ( ::oDbf:cCodCli  >= ::oGrupoCliente:Cargo:Desde  .and. ::oDbf:cCodCli  <= ::oGrupoCliente:Cargo:Hasta )  .and.;
      ( ::oDbf:cCodPgo  >= ::oGrupoFpago:Cargo:Desde    .and. ::oDbf:cCodPgo  <= ::oGrupoFpago:Cargo:Hasta )    .and.;
      ( ::oDbf:cCodRut  >= ::oGrupoRuta:Cargo:Desde     .and. ::oDbf:cCodRut  <= ::oGrupoRuta:Cargo:Hasta )     .and.;
      ( ::oDbf:cCodAge  >= ::oGrupoAgente:Cargo:Desde   .and. ::oDbf:cCodAge  <= ::oGrupoAgente:Cargo:Hasta )   .and.;
      ( ::oDbf:cCodUsr  >= ::oGrupoUsuario:Cargo:Desde  .and. ::oDbf:cCodUsr  <= ::oGrupoUsuario:Cargo:Hasta )

      // ( ::oDbf:cCodGrp  >= ::oGrupoGCliente:Cargo:Desde .and. ::oDbf:cCodGrp  <= ::oGrupoGcliente:Cargo:Hasta ) .and.;

      if ( ::oGrupoGCliente:Cargo:ValidMayorIgual( ::oDbf:cCodGrp, ::oGrupoGCliente:Cargo:Desde ) .and. ::oGrupoGCliente:Cargo:ValidMenorIgual( ::oDbf:cCodGrp, ::oGrupoGcliente:Cargo:Hasta ) )

         return .t.

      end if

   end if

RETURN ( .f. )

//---------------------------------------------------------------------------//

METHOD AddSATCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitSATClientes()

      ::oSatCliT:OrdSetFocus( "cCodCli" )
      ::oSatCliL:OrdSetFocus( "nNumSat" )

      cExpHead          := 'dFecSat >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecSat <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerSat >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerSat <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oSatCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oSatCliT:cFile ), ::oSatCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando SAT"
      ::oMtrInf:SetTotal( ::oSatCliT:OrdKeyCount() )

      ::oSatCliT:GoTop()
      while !::lBreak .and. !::oSatCliT:Eof()

         if lChkSer( ::oSatCliT:cSerSat, ::aSer )

            sTot              := sTotSatCli( ::oSatCliT:cSerSat + Str( ::oSatCliT:nNumSat ) + ::oSatCliT:cSufSat, ::oSatCliT:cAlias, ::oSatCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oSatCliT:cCodCli
            ::oDbf:cNomCli    := ::oSatCliT:cNomCli
            ::oDbf:cCodAge    := ::oSatCliT:cCodAge
            ::oDbf:cCodPgo    := ::oSatCliT:cCodPgo
            ::oDbf:cCodRut    := ::oSatCliT:cCodRut
            ::oDbf:cCodUsr    := ::oSatCliT:cCodUsr
            ::oDbf:cCodObr    := ::oSatCliT:cCodObr

            ::oDbf:cCodPos    := ::oSatCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oSatCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "SAT clientes"
            ::oDbf:cClsDoc    := SAT_CLI
            ::oDbf:cSerDoc    := ::oSatCliT:cSerSat
            ::oDbf:cNumDoc    := Str( ::oSatCliT:nNumSat )
            ::oDbf:cSufDoc    := ::oSatCliT:cSufSat

            ::oDbf:cIdeDoc    :=  ::cIdeDocumento()            

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

         ::oMtrInf:AutoInc()

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
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitPresupuestosClientes()

      ::oPreCliT:OrdSetFocus( "cCodCli" )
      ::oPreCliL:OrdSetFocus( "nNumPre" )

      cExpHead          := 'dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerPre >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerPre <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oPreCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando presupuestos"
      ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

      ::oPreCliT:GoTop()
      while !::lBreak .and. !::oPreCliT:Eof()

         if lChkSer( ::oPreCliT:cSerPre, ::aSer )

            sTot              := sTotPreCli( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre, ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oPreCliT:cCodCli
            ::oDbf:cNomCli    := ::oPreCliT:cNomCli
            ::oDbf:cCodAge    := ::oPreCliT:cCodAge
            ::oDbf:cCodPgo    := ::oPreCliT:cCodPgo
            ::oDbf:cCodRut    := ::oPreCliT:cCodRut
            ::oDbf:cCodUsr    := ::oPreCliT:cCodUsr
            ::oDbf:cCodObr    := ::oPreCliT:cCodObr

            ::oDbf:cCodPos    := ::oPreCliT:cPosCli

            ::oDbf:cCodGrp    := cGruCli( ::oPreCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "Presupuesto clientes"
            ::oDbf:cClsDoc    := PRE_CLI
            ::oDbf:cSerDoc    := ::oPreCliT:cSerPre
            ::oDbf:cNumDoc    := Str( ::oPreCliT:nNumPre )
            ::oDbf:cSufDoc    := ::oPreCliT:cSufPre

            ::oDbf:cIdeDoc    :=  ::cIdeDocumento()

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

         ::oMtrInf:AutoInc()

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
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitPedidosClientes()

      ::oPedCliT:OrdSetFocus( "dFecPed" )
      ::oPedCliL:OrdSetFocus( "nNumPed" )

      cExpHead          := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerPed >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerPed <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando pedidos"
      ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

      ::oPedCliT:GoTop()
      while !::lBreak .and. !::oPedCliT:Eof()

         if lChkSer( ::oPedCliT:cSerPed, ::aSer )

            sTot              := sTotPedCli( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oPedCliT:cCodCli
            ::oDbf:cNomCli    := ::oPedCliT:cNomCli
            ::oDbf:cCodAge    := ::oPedCliT:cCodAge
            ::oDbf:cCodPgo    := ::oPedCliT:cCodPgo
            ::oDbf:cCodRut    := ::oPedCliT:cCodRut
            ::oDbf:cCodObr    := ::oPedCliT:cCodObr

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

         ::oMtrInf:AutoInc()

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
   local cExpHead
   
   DEFAULT lNoFacturados   := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitAlbaranesClientes()

      ::oAlbCliT:OrdSetFocus( "dFecAlb" )
      ::oAlbCliL:OrdSetFocus( "nNumAlb" )

      if lNoFacturados
         cExpHead       := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      else
         cExpHead       := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      end if
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerAlb >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerAlb <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando albaranes"
      ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

      ::oAlbCliT:GoTop()
      while !::lBreak .and. !::oAlbCliT:Eof()

         if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

            sTot              := sTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
            ::oDbf:cNomCli    := ::oAlbCliT:cNomCli
            ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
            ::oDbf:cCodPgo    := ::oAlbCliT:cCodPago
            ::oDbf:cCodRut    := ::oAlbCliT:cCodRut
            ::oDbf:cCodObr    := ::oAlbCliT:cCodObr

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

         ::oMtrInf:AutoInc()

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
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitFacturasClientes()

      ::oFacCliT:OrdSetFocus( "dFecFac" )
      ::oFacCliL:OrdSetFocus( "nNumFac" )

      cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando facturas"
      ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

      ::oFacCliT:GoTop()
      while !::lBreak .and. !::oFacCliT:Eof()

         if lChkSer( ::oFacCliT:cSerie, ::aSer )

            sTot              := sTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oFacCliT:cCodCli
            ::oDbf:cNomCli    := ::oFacCliT:cNomCli
            ::oDbf:cCodAge    := ::oFacCliT:cCodAge
            ::oDbf:cCodPgo    := ::oFacCliT:cCodPago
            ::oDbf:cCodRut    := ::oFacCliT:cCodRut
            ::oDbf:cCodUsr    := ::oFacCliT:cCodUsr
            ::oDbf:cCodObr    := ::oFacCliT:cCodObr

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

            /*
            Añadimos un nuevo registro--------------------------------------------
            */

            if ::lValidRegister()
               ::oDbf:Insert()
            else
               ::oDbf:Cancel()
            end if

            ::addFacturasClientes()

         end if

         ::oFacCliT:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitFacturasRectificativasClientes()

      ::oFacRecT:OrdSetFocus( "dFecFac" )
      ::oFacRecL:OrdSetFocus( "nNumFac" )

      cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando facturas rectificativas"
      ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

      ::oFacRecT:GoTop()
      while !::lBreak .and. !::oFacRecT:Eof()

         if lChkSer( ::oFacRecT:cSerie, ::aSer )

            sTot              := sTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oFacRecT:cCodCli            
            ::oDbf:cNomCli    := ::oFacRecT:cNomCli
            ::oDbf:cCodAge    := ::oFacRecT:cCodAge
            ::oDbf:cCodPgo    := ::oFacRecT:cCodPago
            ::oDbf:cCodRut    := ::oFacRecT:cCodRut
            ::oDbf:cCodUsr    := ::oFacRecT:cCodUsr
            ::oDbf:cCodObr    := ::oFacRecT:cCodObr

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

         ::oFacRecT:Skip()

         ::oMtrInf:AutoInc()

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
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::InitTicketsClientes()

      ::oTikCliT:OrdSetFocus( "dFecTik" )
      ::oTikCliL:OrdSetFocus( "cNumTik" )

      cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCliTik ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCliTik ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerTik >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerTik <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando tickets"
      ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

      ::oTikCliT:GoTop()
      while !::lBreak .and. !::oTikCliT:Eof()

         if lChkSer( ::oTikCliT:cSerTik, ::aSer )

            sTot              := sTotTikCli( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:Blank()

            ::oDbf:cCodCli    := ::oTikCliT:cCliTik
            ::oDbf:cNomCli    := ::oTikCliT:cNomTik
            ::oDbf:cCodAge    := ::oTikCliT:cCodAge
            ::oDbf:cCodPgo    := ::oTikCliT:cFpgTik
            ::oDbf:cCodRut    := ::oTikCliT:cCodRut
            ::oDbf:cCodUsr    := ::oTikCliT:cCcjTik
            ::oDbf:cCodObr    := ::oTikCliT:cCodObr

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

         ::oMtrInf:AutoInc()

      end while

      ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddRecibosCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   local cExpHead
   
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
      ::oFacCliP:OrdSetFocus( "dPreCob" )

      cExpHead          := 'dPreCob >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dPreCob <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      cExpHead          += ' .and. Rtrim( cCodCli ) >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde )   + '" .and. Rtrim( cCodCli ) <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
      cExpHead          += ' .and. cSerie >= "' + Rtrim( ::oGrupoSerie:Cargo:Desde ) + '" .and. cSerie <= "'    + Rtrim( ::oGrupoSerie:Cargo:Hasta ) + '"'

      ::oFacCliP:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ), ::oFacCliP:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:cText   := "Procesando recibos"
      ::oMtrInf:SetTotal( ::oFacCliP:OrdKeyCount() )

      ::oFacCliP:GoTop()
      while !::lBreak .and. !::oFacCliP:Eof()

         ::oDbf:Blank()

         ::oDbf:cCodCli    := ::oFacCliP:cCodCli
         ::oDbf:cNomCli    := ::oFacCliP:cNomCli
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
         ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

         ::oDbf:nAnoDoc    := Year( ::oFacCliP:dPreCob )
         ::oDbf:nMesDoc    := Month( ::oFacCliP:dPreCob )
         ::oDbf:dFecDoc    := ::oFacCliP:dPreCob
         ::oDbf:cHorDoc    := SubStr( ::oFacCliP:cHorCre, 1, 2 )
         ::oDbf:cMinDoc    := SubStr( ::oFacCliP:cHorCre, 4, 2 )

         ::oDbf:nTotNet    := nTotRecCli( ::oFacCliP )
         ::oDbf:nTotCob    := nTotCobCli( ::oFacCliP )

         // Añadimos un nuevo registro--------------------------------------------

         if ::lValidRegister()
            ::oDbf:Insert()
         else
            ::oDbf:Cancel()
         end if

         msgWait( "procesa" + str( ::oFacCliP:OrdKeyCount() ), , .1 )

         ::oFacCliP:Skip()

         ::oMtrInf:AutoInc()

      end while

      ::oFacCliP:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliP:cFile ) )
   
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir recibos de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   
RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddClientes() CLASS TFastVentasClientes

   ::oMtrInf:SetTotal( ::oDbfCli:OrdKeyCount() )

   ::oMtrInf:cText   := "Procesando clientes"

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

      if ::lValidRegister()
         ::oDbf:Insert()
      else
         ::oDbf:Save()
      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyCount() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD preCliInfo()

   local cKey  := ::oDbf:cClsDoc + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

   if ::oPreCliT:Seek( cKey )
      msgInfo( cKey, "found" )
   else
      msgStop( cKey, "not found" )
      msgStop( len( cvaltochar( ::oPreCliT:OrdKeyVal() ) ), "len OrdKeyVal")
      msgStop( ::oPreCliT:OrdSetFocus(), "ordsetfocus" )
   end if

return nil 

//---------------------------------------------------------------------------//
