#include "FiveWin.Ch"
#include "Factu.ch"
#include "Report.ch"
#include "MesDbf.ch"
// #include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TFastVentasClientes FROM TFastReportInfGen

   DATA  cResource       INIT "FastReportArticulos"

   METHOD lResource( cFld )

   METHOD Create()
   METHOD lGenerate()
   METHOD lValidRegister()

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD DataReport( oFr )

   METHOD StartDialog()
   METHOD BuildTree( oTree )

   METHOD AddAlbaranCliente()
   METHOD AddFacturaCliente()
   METHOD AddFacturaRectificativa()
   METHOD AddTicket()

   METHOD AddClientes()

   METHOD TreeReportingChanged()

END CLASS

//----------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TFastVentasClientes

   ::lNewInforme     := .t.
   ::lDefCondiciones := .f.

   if !::NewResource()
      return .f.
   end if

   /*
   Carga controles-------------------------------------------------------------
   */

   if !::lGrupoCliente( .t. )
      return .f.
   end if

   if !::lGrupoGCliente( .t. )
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
      return .f.
   end if

   ::CreateFilter( , ::oDbf )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TFastVentasClientes

   local lOpen    := .t.
   local oError
   local oBlock

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      DATABASE NEW ::oAlbCliT PATH ( cPatEmp() ) CLASS "ALBCLIT" FILE "ALBCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIT.CDX"

      DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
      ::oAlbCliL:OrdSetFocus( "cStkFast" )

      DATABASE NEW ::oFacCliT PATH ( cPatEmp() ) CLASS "FACCLIT" FILE "FACCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIT.CDX"
      ::oFacCliT:OrdSetFocus( "cCodCli" )

      DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oFacCliP PATH ( cPatEmp() ) CLASS "FACCLIP" FILE "FACCLIP.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIP.CDX"

      DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) CLASS "AntCliT" FILE "AntCliT.Dbf" VIA ( cDriver() ) SHARED INDEX "AntcliT.Cdx"

      DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) CLASS "FACRECT" FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

      DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) CLASS "FACRECL" FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"
      ::oFacRecL:OrdSetFocus( "cRef" )

      DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) CLASS "TIKET"   FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

      DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) CLASS "TIKEL"   FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de clientes" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TFastVentasClientes

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

RETURN .t.

//---------------------------------------------------------------------------//

METHOD Create( uParam ) CLASS TFastVentasClientes

   ::AddField( "cCodCli",  "C", 18, 0, {|| "@!" }, "Código cliente"                          )
   ::AddField( "cNomcli",  "C",100, 0, {|| ""   }, "Nombre cliente"                          )

   ::AddField( "cTipIva",  "C",  1, 0, {|| "@!" }, "Código del tipo de " + cImp()            )
   ::AddField( "cCodTip",  "C", 12, 0, {|| "@!" }, "Código del tipo de cliente"              )
   ::AddField( "cCodGrp",  "C", 12, 0, {|| "@!" }, "Código grupo de cliente"                 )
   ::AddField( "cCodPgo",  "C",  2, 0, {|| "@!" }, "Código de forma de pago"                 )
   ::AddField( "cCodRut",  "C", 12, 0, {|| "@!" }, "Código de la ruta"                       )
   ::AddField( "cCodAge",  "C", 12, 0, {|| "@!" }, "Código del agente"                       )
   ::AddField( "cCodUsr",  "C",  3, 0, {|| "@!" }, "Código usuario que realiza el cambio"    )

   ::AddField( "cTipDoc",  "C", 30, 0, {|| "" },   "Tipo de documento"                       )
   ::AddField( "cIdeDoc",  "C", 27, 0, {|| "" },   "Identificador del documento"             )
   ::AddField( "cSerDoc",  "C",  1, 0, {|| "" },   "Serie del documento"                     )
   ::AddField( "cNumDoc",  "C", 10, 0, {|| "" },   "Número del documento"                    )
   ::AddField( "cSufDoc",  "C",  2, 0, {|| "" },   "Delegación del documento"                )

   ::AddField( "nAnoDoc",  "N",  4, 0, {|| "" },   "Año del documento"                       )
   ::AddField( "nMesDoc",  "N",  2, 0, {|| "" },   "Mes del documento"                       )
   ::AddField( "dFecDoc",  "D",  8, 0, {|| "" },   "Fecha del documento"                     )
   ::AddField( "cHorDoc",  "C",  2, 0, {|| "" },   "Hora del documento"                      )
   ::AddField( "cMinDoc",  "C",  2, 0, {|| "" },   "Minutos del documento"                   )

   ::AddField( "nTotNet",  "N", 16, 6, {|| "" },   "Total neto"                              )
   ::AddField( "nTotIva",  "N", 16, 6, {|| "" },   "Total " + cImp()                               )
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

METHOD BuildTree( oTree, lSubNode ) CLASS TFastVentasClientes

   local oTreeVentas
   local oTreeFacturas

   DEFAULT lSubNode        := .t.

   oTreeVentas             := oTree:Add( "Ventas", 11 )
   oTreeVentas:Add( "Listado",                 19, "Listado"  )
   oTreeVentas:Add( "Informe de presupuestos",  5, "Informe de presupuestos" )
   oTreeVentas:Add( "Informe de pedidos",       6, "Informe de pedidos" )
   oTreeVentas:Add( "Informe de albaranes",     7, "Informe de albaranes" )

   oTreeFacturas           := oTreeVentas:Add( "Informe de facturas",   8 )

   if lSubNode
      oTreeFacturas:Add( "Relación de facturas",                                                8, "Informe de facturas" )
      oTreeFacturas:Add( "Declaración anual de operaciones con terceras personas. Modelo 347",  8, "Informe de facturas" )
   end if

   oTreeVentas:Add( "Informe de tickets",       10, "Informe de tickets" )
   oTreeVentas:Add( "Informe de ventas",        11, "Informe de ventas" )

   oTreeVentas:Expand()
   oTreeFacturas:Expand()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DataReport( oFr ) CLASS TFastVentasClientes

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
   ::oFastReport:SetFieldAliases(   "Usuarios",                         cItemsToReport( aItmUsr() ) )

   ::oFastReport:SetWorkArea(       "Tipos de " + cImp(),               ::oDbfIva:nArea )
   ::oFastReport:SetFieldAliases(   "Tipos de " + cImp(),               cItemsToReport( aItmTIva() ) )

   ::oFastReport:SetWorkArea(       "Facturas",                         ::oFacCliT:nArea )
   ::oFastReport:SetFieldAliases(   "Facturas",                         cItemsToReport( aItmFacCli() ) )

   ::oFastReport:SetWorkArea(       "Lineas de facturas",               ::oFacCliL:nArea )
   ::oFastReport:SetFieldAliases(   "Lineas de facturas",               cItemsToReport( aColFacCli() ) )

   ::oFastReport:SetMasterDetail(   "Informe", "Empresa",               {|| cCodEmp() } )
   ::oFastReport:SetMasterDetail(   "Informe", "Tipos de " + cImp(),    {|| ::oDbf:cTipIva } )
   ::oFastReport:SetMasterDetail(   "Informe", "Facturas",              {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Clientes",              {|| ::oDbf:cCodCli } )
   ::oFastReport:SetMasterDetail(   "Informe", "Agentes",               {|| ::oDbf:cCodAge } )

   ::oFastReport:SetMasterDetail(   "Clientes", "Rutas",                {|| ::oDbfCli:cCodRut } )
   ::oFastReport:SetMasterDetail(   "Clientes", "Grupos de cliente",    {|| ::oDbfCli:cCodGrp } )
   ::oFastReport:SetMasterDetail(   "Clientes", "Formas de pago",       {|| ::oDbfCli:CodPago } )
   ::oFastReport:SetMasterDetail(   "Clientes", "Usuarios",             {|| ::oDbfCli:cCodUsr } )
   ::oFastReport:SetMasterDetail(   "Facturas", "Lineas de facturas",   {|| ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac } )

   ::oFastReport:SetResyncPair(     "Informe", "Empresa" )
   ::oFastReport:SetResyncPair(     "Informe", "Tipos de " + cImp() )
   ::oFastReport:SetResyncPair(     "Informe", "Clientes" )
   ::oFastReport:SetResyncPair(     "Informe", "Facturas" )
   ::oFastReport:SetResyncPair(     "Informe", "Agentes" )

   ::oFastReport:SetResyncPair(     "Clientes", "Rutas" )
   ::oFastReport:SetResyncPair(     "Clientes", "Grupos de cliente" )
   ::oFastReport:SetResyncPair(     "Clientes", "Formas de pago" )
   ::oFastReport:SetResyncPair(     "Clientes", "Usuarios" )

   ::oFastReport:SetResyncPair(     "Facturas", "Lineas de facturas" )

   ::AddVariable()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD TreeReportingChanged() CLASS TFastVentasClientes

   if ::oTreeReporting:GetSelText() == "Listado"
      ::lHideFecha()
   else
      ::lShowFecha()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TFastVentasClientes

   ::oDbf:Zap()

   /*
   Recorremos clientes---------------------------------------------------------
   */

   do case
      case ::cReportName == "Informe de albaranes"

   //      ::AddAlbaranCliente( .t. )

      case ::cTypeName == "Informe de facturas"

         ::AddFacturaCliente()

   //      ::AddFacturaCliente()

   //      ::AddFacturaRectificativa()

      case ::cReportName == "Informe de facturas rectificativas"

   //      ::AddFacturaRectificativa( .t. )

      case ::cReportName == "Informe de tickets"

   //      ::AddTicket( .t. )

      case ::cReportName == "Informe de ventas"

   //      ::AddAlbaranCliente()

         ::AddFacturaCliente()

   //      ::AddFacturaRectificativa()

   //      ::AddTicket()

      case ::cTypeName == "Listado"

         ::AddClientes()

   end case

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

METHOD AddAlbaranCliente( lFacturados ) CLASS TFastVentasClientes

   local cExpHead
   local cExpLine

   DEFAULT lFacturados  := .f.

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   if lFacturados
      cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   else
      cExpHead          := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end if

   cExpHead             += ' .and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'

   /*
   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 1
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 1 ]
   end if
   */

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes---------------------------------------------------------
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while !::lBreak .and. ( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb ) .and. !( ::oAlbCliL:eof() )

               if !( ::lExcCero  .and. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 )  .and.;
                  !( ::lExcImp   .and. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*
                  Añadimos un nuevo registro-----------------------------------
                  */

                  ::oDbf:Blank()
                  ::oDbf:cCodArt  := ::oAlbCliL:cRef
                  ::oDbf:cNomArt  := ::oAlbCliL:cDetalle

                  ::oDbf:cCodTip  := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "cCodTip", "Codigo" )
                  ::oDbf:cCodCli  := ::oAlbCliT:cCodCli
                  ::oDbf:cCodGrp  := RetFld( ::oAlbCliL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
                  ::oDbf:cCodPago := ::oAlbCliT:cCodPago
                  ::oDbf:cCodRut  := ::oAlbCliT:cCodRut
                  ::oDbf:cAgente  := ::oAlbCliT:cCodAge
                  ::oDbf:cCodUsr  := ::oAlbCliT:cCodUsr

                  ::oDbf:cSerDoc  := ::oAlbCliT:cSerAlb
                  ::oDbf:cNumDoc  := Str( ::oAlbCliT:nNumAlb )
                  ::oDbf:cSufDoc  := ::oAlbCliT:cSufAlb

                  /*
                  Añadimos un nuevo registro-----------------------------------
                  */

                  if ::lValidRegister()
                     ::oDbf:Insert()
                  else
                     ::oDbf:Cancel()
                  end if

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddFacturaRectificativa( cCodigoCliente ) CLASS TFastVentasClientes

   local cExpHead
   local cExpLine

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'

   /*
   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 1
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 1 ]
   end if
   */

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas rectificativas"
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   // Lineas de facturas rectificativas----------------------------------------

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cRef <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while !::lBreak .and. ( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac )

               if !( ::lExcCero  .and. nTotNFacRec ( ::oFacRecL:cAlias ) == 0 )  .and.;
                  !( ::lExcImp   .and. nImpLFacRec ( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  // Añadimos un nuevo registro--------------------------------

                  if ::lValidRegister( ::oFacRecL:cRef )

                     ::oDbf:Append()

                     ::oDbf:cCodArt  := ::oFacRecL:cRef
                     ::oDbf:cNomArt  := ::oFacRecL:cDetalle

                     //::oDbf:tipoiva  := ::oFacRecL:tipoiva
                     ::oDbf:cCodCli  := ::oFacRecT:cCodCli
                     ::oDbf:cCodGrp  := RetFld( ::oFacRecL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
                     ::oDbf:cCodPago := ::oFacRecT:cCodPago
                     ::oDbf:cCodRut  := ::oFacRecT:cCodRut
                     ::oDbf:cAgente  := ::oFacRecT:cCodAge
                     ::oDbf:cCodUsr  := ::oFacRecT:cCodUsr

                     ::oDbf:cSerDoc := ::oFacRecT:cSerie
                     ::oDbf:cNumDoc := Str( ::oFacRecT:nNumFac )
                     ::oDbf:cSufDoc := ::oFacRecT:cSufFac

                     ::oDbf:Save()

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddTicket() CLASS TFastVentasClientes

   local cExpHead
   local cExpLine

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead       := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'
   cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCliTik <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'

   /*
   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 4
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 4 ]
   end if
   */

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando tikets"

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   // Lineas de tickets -------------------------------------------------------

   cExpLine       := 'cCbaTil >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cCbaTil <= "' + ::oGrupoArticulo:Cargo:Hasta + '" .or. '
   cExpLine       += 'cComTil >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cComTil <= "' + ::oGrupoArticulo:Cargo:Hasta + ' )"'

   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   // Proceso -----------------------------------------------------------------

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer ) .and. ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            if !Empty( ::oTikCliL:cCbaTil ) .and. !( ::oTikCliL:lControl )

               // Añadimos un nuevo registro--------------------------------

               if ::lValidRegister( ::oTikCliL:cCbaTil )

                  ::oDbf:Append()
                  ::oDbf:cCodArt  := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt  := ::oTikCliL:cDetalle

                   //::oDbf:tipoiva  := ::oTikCliL:tipoiva
                   ::oDbf:cCodCli  := ::oTikCliT:cCodCli
                   ::oDbf:cCodGrp  := RetFld( ::oTikCliL:cRef, ::oDbfArt:cAlias, "GrpVent", "Codigo" )
                   ::oDbf:cCodPago := ::oTikCliT:cCodPago
                   ::oDbf:cCodRut  := ::oTikCliT:cCodRut
                   ::oDbf:cagente  := ::oTikCliT:cCodAge
                   ::oDbf:cCodUsr  := ::oTikCliT:cCodUsr

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nUniArt := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nUniArt := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:cSerDoc  := ::oTikCliT:cSerTik
                  ::oDbf:cNumDoc  := ::oTikCliT:cNumTik
                  ::oDbf:cSufDoc  := ::oTikCliT:cSufTik
                  ::oDbf:Save()

               end if

            end if

            if !Empty( ::oTikCliL:cComTil ) .and. !( ::oTikCliL:lControl )

               // Añadimos un nuevo registro--------------------------------

               if ::lValidRegister( ::oTikCliL:cComTil )

                  ::oDbf:Append()
                  ::oDbf:cCodArt  := ::oTikCliL:cComTil
                  ::oDbf:cNomArt  := ::oFacRecL:cDetalle

                   //::oDbf:tipoiva  := ::oTikCliL:tipoiva
                   ::oDbf:cCodCli  := ::oTikCliT:cCodCli
                   ::oDbf:cCodGrp  := RetFld( ::oTikCliL:cRef, ::oDbfArt:cAlias, "GRPVENT", "Codigo" )
                   ::oDbf:cCodPago := ::oTikCliT:cCodPago
                   ::oDbf:cCodRut  := ::oTikCliT:cCodRut
                   ::oDbf:cagente  := ::oTikCliT:cCodAge
                   ::oDbf:cCodUsr  := ::oTikCliT:cCodUsr

                  ::oDbf:cSerDoc  := ::oTikCliT:cSerTik
                  ::oDbf:cNumDoc  := ::oTikCliT:cNumTik
                  ::oDbf:cSufDoc  := ::oTikCliT:cSufTik
                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:Set( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddClientes() CLASS TFastVentasClientes

   ::oMtrInf:SetTotal( ::oDbfCli:OrdKeyCount() )

   ::oMtrInf:cText         := "Procesando clientes"

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

METHOD AddFacturaCliente( cCodigoCliente ) CLASS TFastVentasClientes

   local sTot
   local oError
   local oBlock
   local cExpHead
   /*
   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   */
      ::InitFacturasClientes()

      ::oFacCliT:OrdSetFocus( "dFecFac" )

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

            ::oDbf:cCodGrp    := cGruCli( ::oFacCliT:cCodCli, ::oDbfCli )

            ::oDbf:cTipDoc    := "Factura clientes"
            ::oDbf:cSerDoc    := ::oFacCliT:cSerie
            ::oDbf:cNumDoc    := Str( ::oFacCliT:nNumFac )
            ::oDbf:cSufDoc    := ::oFacCliT:cSufFac
            ::oDbf:cIdeDoc    := Upper( ::oDbf:cTipDoc ) + ::oDbf:cSerDoc + ::oDbf:cNumDoc + ::oDbf:cSufDoc

            ::oDbf:nAnoDoc    := Year( ::oFacCliT:dFecFac )
            ::oDbf:nMesDoc    := Month( ::oFacCliT:dFecFac )
            ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
            ::oDbf:cHorDoc    := SubStr( ::oFacCliT:cTimCre, 1, 2 )
            ::oDbf:cMinDoc    := SubStr( ::oFacCliT:cTimCre, 3, 2 )

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
   /*
   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible añadir facturas de clientes" )

   END SEQUENCE

   ErrorBlock( oBlock )
   */
RETURN ( Self )

//---------------------------------------------------------------------------//