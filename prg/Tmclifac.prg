#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TmCliFac()

   local oInf
   local aCol  := {}
   local aIdx  := {}


   aAdd( aCol, { "CCODCLI", "C", 12, 0, {|| "@!" },         "Código",                    .f., "Código cliente",              8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0, {|| "@!" },         "Cliente",                   .f., "Nombre cliente",             40 } )
   aAdd( aCol, { "CCODART", "C", 18, 0, {|| "@!" },         "Cod. Art.",                 .t., "Cod. Artículo",              14 } )
   aAdd( aCol, { "CNOMART", "C",100, 0, {|| "@!" },         "Artículo",                  .t., "Descripción",                25 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0, {|| "@!" },         "Nif",                       .f., "Nif",                         8 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0, {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  25 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0, {|| "@!" },         "Población",                 .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0, {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0, {|| "@!" },         "CP",                        .f., "Cod. Postal",                20 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0, {|| "@!" },         "Tlf",                       .f., "Teléfono",                   12 } )
   aAdd( aCol, { "CDEFI01", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(1) },   .f., {|| oInf:cNameIniCli(1) },  50 } )
   aAdd( aCol, { "CDEFI02", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(2) },   .f., {|| oInf:cNameIniCli(2) },  50 } )
   aAdd( aCol, { "CDEFI03", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(3) },   .f., {|| oInf:cNameIniCli(3) },  50 } )
   aAdd( aCol, { "CDEFI04", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(4) },   .f., {|| oInf:cNameIniCli(4) },  50 } )
   aAdd( aCol, { "CDEFI05", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(5) },   .f., {|| oInf:cNameIniCli(5) },  50 } )
   aAdd( aCol, { "CDEFI06", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(6) },   .f., {|| oInf:cNameIniCli(6) },  50 } )
   aAdd( aCol, { "CDEFI07", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(7) },   .f., {|| oInf:cNameIniCli(7) },  50 } )
   aAdd( aCol, { "CDEFI08", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(8) },   .f., {|| oInf:cNameIniCli(8) },  50 } )
   aAdd( aCol, { "CDEFI09", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(9) },   .f., {|| oInf:cNameIniCli(9) },  50 } )
   aAdd( aCol, { "CDEFI10", "C",100, 0, {|| "@!" },         {|| oInf:cNameIniCli(10)},   .f., {|| oInf:cNameIniCli(10)},  50 } )
   aAdd( aCol, { "NCAJENT", "N", 16, 6, {|| MasUnd() },     "Caj.",                      .f., "Cajas",                    10 } )
   aAdd( aCol, { "NUNIDAD", "N", 16, 6, {|| MasUnd() },     "Und.",                      .t., "Unidades",                 10 } )
   aAdd( aCol, { "NUNTENT", "N", 16, 6, {|| MasUnd() },     "Tot. und.",                 .f., "Total unidades",           10 } )
   aAdd( aCol, { "NPREDIV", "N", 16, 6, {|| oInf:cPicOut }, "Importe",                   .t., "Importe",                  10 } )
   aAdd( aCol, { "NCOMAGE", "N", 16, 6, {|| oInf:cPicOut }, "Com. age",                  .t., "Comisión agente",          10 } )
   aAdd( aCol, { "NTOTAGE", "N", 16, 6, {|| oInf:cPicOut }, "Imp. age",                  .t., "Importe agente",           10 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0, {|| "@!" },         "Factura",                   .t., "Factura",                  12 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0, {|| "@!" },         "Fecha",                     .t., "Fecha",                    14 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0, {|| "@!" },         "Venta",                     .f., "Tipo de venta",            20 } )

   aAdd( aIdx, { "CCODCLI", "CCODCLI + CNOMART" } )

   oInf  := TMovCFac():New( "Informe detallado de facturas de clientes agrupados por clientes", aCol, aIdx, "01045" )

   oInf:AddGroup( {|| oInf:oDbf:cCodCli },                     {|| "Cliente  : " + Rtrim( oInf:oDbf:cCodCli ) + "-" + oRetFld( oInf:oDbf:cCodCli, oInf:oDbfCli ) } )
   oInf:AddGroup( {|| oInf:oDbf:cCodCli + oInf:oDbf:cNomArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cNomArt ) + "-" + oRetFld( oInf:oDbf:cNomArt, oInf:oDbfArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TMovCFac FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Liquidada", "Todas" }
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TMovCFac

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TMovCFac

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oDbfTvta:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TMovCFac

   local cEstado := "Todas"
   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INF_GEN04" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   ::oDefCliInf( 70, 80, 90, 100 )

   /*
   Monta los clientes de manera automatica
   */

   ::oDefObrInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen VAR ::cTipVen ;
      WHEN     ( ::lTvta ) ;
      VALID    ( cTVta( oTipVen, This:oDbfTvta:cAlias, oTipVen2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oTipVen, This:oDbfTVta:cAlias, oTipVen2 ) ) ;
      ID       270 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen2 VAR ::cTipVen2 ;
      ID       280 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TMovCFac

   local bValid   := {|| .t. }

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oFacCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

     ::aHeader   := {{|| "Fecha  : "   + Dtoc( Date() ) },;
                     {|| "Periodo: "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Clientes: "  + ::cCliOrg         + " > " + ::cCliDes },;
                     {|| "Obras: "     + ::cObrOrg         + " > " + ::cObrDes },;
                     {|| "Artículos: " + ::cArtOrg         + " > " + ::cArtDes },;
                     {|| if ( ::lTvta,( if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado : " + ::aEstado[ ::oEstado:nAt ] } }

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   WHILE ! ::oFacCliT:Eof()

      if Eval( bValid )                                                                     .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODCLI >= ::cCliOrg                                                    .AND.;
         ::oFacCliT:CCODCLI <= ::cCliDes                                                    .AND.;
         if ( !Empty( ::cObrOrg ),;
            ( ::oFacCliT:CCODOBR >= ::cObrOrg .AND. ::oFacCliT:CCODOBR <= ::cObrDes ),;
            .t. )                                                                           .AND.;
            lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if ::lTvta

                  if ::oFacCliL:CREF >= ::cArtOrg                                      .AND.;
                     ::oFacCliL:CREF <= ::cArtDes                                      .AND.;
                     (if (!Empty(::cTipVen), ::oFacCliL:cTipMov == ::cTipVen, .t. ))   .AND.;
                     !( ::lExcCero .AND. ::oFacCliL:NPREUNIT == 0 )                    .AND.;
                     !::oFacCliL:lControl                                              .AND.;
                     !::oFacCliL:lTotlin

                     ::oDbf:Append()

                     ::oDbfTvta:Seek ( ::oFacCliL:cTipMov )
                     ::oDbf:cTipVen    := ::oDbfTvta:cDesMov

                     ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                     ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                     ::oDbf:CCODART := ::oFacCliL:CREF
                     ::oDbf:CNOMART := ::oFacCliL:cDetalle
                     ::oDbf:CDOCMOV := ::oFacCliL:CSERIE + "/" + Str( ::oFacCliL:NNUMFAC ) + "/" + ::oFacCliL:CSUFFAC

                     if ::oDbfTvta:nUndMov == 1
                        ::oDbf:NCAJENT := ::oFacCliL:NCANENT
                        ::oDbf:nUnidad := ::oFacCliL:NUNICAJA
                        ::oDbf:NUNTENT := nTotNFacCli( ::oFacCliL )
                     elseif ::oDbfTvta:nUndMov == 2
                        ::oDbf:NCAJENT := ( ::oFacCliL:NCANENT )        * (-1)
                        ::oDbf:nUnidad := ( ::oFacCliL:NUNICAJA )       * (-1)
                        ::oDbf:NUNTENT := ( nTotNFacCli( ::oFacCliL ) ) * (-1)
                     elseif ::oDbfTvta:nUndMov == 3
                        ::oDbf:NCAJENT := 0
                        ::oDbf:NUNTENT := 0
                        ::oDbf:nUnidad := 0
                     end

                     if ::oDbfTvta:nImpMov == 3
                        ::oDbf:nComAge := 0
                        ::oDbf:nPreDiv := 0
                     else
                        ::oDbf:nComAge := ( ::oFacCliL:nComAge )
                        ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                     end

                     ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

                     ::oDbf:Save()

                  end if

               else

                  if ::oFacCliL:CREF >= ::cArtOrg                                      .AND.;
                     ::oFacCliL:CREF <= ::cArtDes                                      .AND.;
                     !( ::lExcCero .AND. ::oFacCliL:NPREUNIT == 0 )                    .AND.;
                     !::oFacCliL:lControl                                              .AND.;
                     !::oFacCliL:lTotlin

                     ::oDbf:Append()

                     ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                     ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                     ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                     ::oDbf:CCODART := ::oFacCliL:CREF
                     ::oDbf:CNOMART := ::oFacCliL:cDetalle
                     ::oDbf:CDOCMOV := ::oFacCliL:CSERIE + "/" + Str( ::oFacCliL:NNUMFAC ) + "/" + ::oFacCliL:CSUFFAC
                     ::oDbf:NCAJENT := ::oFacCliL:NCANENT
                     ::oDbf:nUnidad := ::oFacCliL:NUNICAJA
                     ::oDbf:NUNTENT := nTotNFacCli( ::oFacCliL )
                     ::oDbf:nComAge := ( ::oFacCliL:nComAge )
                     ::oDbf:nTotAge := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreDiv := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )

                     ::AddClientes( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

                     ::oDbf:Save()

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//