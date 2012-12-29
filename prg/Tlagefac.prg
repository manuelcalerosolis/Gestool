#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION TlAgeFac()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age.",                 .f., "Cod. agente",                 3 } )
   aAdd( aCol, { "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nom. agente",                25 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0,  {|| "@!" },         "Cod. cli.",                 .t., "Cod. cliente",               12 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0,  {|| "@!" },         "Nombre",                    .t., "Nom. cliente",               35 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  40 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0,  {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 } )
   aAdd( aCol, { "CDEFI01", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(1) },   .f., {|| oInf:cNameIniCli(1) },    50 } )
   aAdd( aCol, { "CDEFI02", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(2) },   .f., {|| oInf:cNameIniCli(2) },    50 } )
   aAdd( aCol, { "CDEFI03", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(3) },   .f., {|| oInf:cNameIniCli(3) },    50 } )
   aAdd( aCol, { "CDEFI04", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(4) },   .f., {|| oInf:cNameIniCli(4) },    50 } )
   aAdd( aCol, { "CDEFI05", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(5) },   .f., {|| oInf:cNameIniCli(5) },    50 } )
   aAdd( aCol, { "CDEFI06", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(6) },   .f., {|| oInf:cNameIniCli(6) },    50 } )
   aAdd( aCol, { "CDEFI07", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(7) },   .f., {|| oInf:cNameIniCli(7) },    50 } )
   aAdd( aCol, { "CDEFI08", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(8) },   .f., {|| oInf:cNameIniCli(8) },    50 } )
   aAdd( aCol, { "CDEFI09", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(9) },   .f., {|| oInf:cNameIniCli(9) },    50 } )
   aAdd( aCol, { "CDEFI10", "C",100, 0,  {|| "@!" },         {|| oInf:cNameIniCli(10)},   .f., {|| oInf:cNameIniCli(10)},    50 } )
   aAdd( aCol, { "CREFART", "C", 18, 0,  {|| "@!" },         "Cod. art.",                 .f., "Cod. artículo",              14 } )
   aAdd( aCol, { "CDESART", "C", 50, 0,  {|| "@!" },         "Descripción",               .f., "Descripción",                25 } )
   aAdd( aCol, { "CCSUFAC", "C", 12, 0,  {|| "@!" },         "Su factura",                .f., "Su factura Nº",              12 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .f., "Fecha",                      12 } )
   aAdd( aCol, { "NUNDCAJ", "N", 16, 6,  {|| MasUnd () },    "Cajas",                     .f., "Cajas",                      14 } )
   aAdd( aCol, { "NUNDART", "N", 16, 6,  {|| MasUnd () },    "Und.",                      .f., "Unidades",                   14 } )
   aAdd( aCol, { "NCAJUND", "N", 16, 6,  {|| MasUnd () },    "Tot. Und.",                 .t., "Total unidades",             12 } )
   aAdd( aCol, { "NTOTPES", "N", 19, 6,  {|| MasUnd() },     "Tot. pes.",                 .f., "Total peso",                 12 } )
   aAdd( aCol, { "NBASCOM", "N", 16, 6,  {|| oInf:cPicOut }, "Base",                      .t., "Base comisión",              12 } )
   aAdd( aCol, { "NCOMAGE", "N",  4, 1,  {|| "@E 99,99" },   "%Com",                      .t., "Porcentaje de comisión",     12 } )
   aAdd( aCol, { "NTOTCOM", "N", 16, 6,  {|| oInf:cPicOut }, "Comisión",                  .t., "Importe comisión",           12 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Factura",                   .t., "Factura",                    14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .t., "Fecha",                       8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",              20 } )

   aAdd( aIdx, { "CNOMAGE", "CNOMAGE + CREFART" } )

   oInf  := TdlAgeFac():New( "Informe detallado de la liquidación de agentes agrupados por artículos", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cNomAge },                     {|| "Agente   : " + Rtrim( oInf:oDbf:cNomAge ) + "-" + oRetFld( oInf:oDbf:cNomAge, oInf:oDbfAge ) }, {||"Total agente..."} )
   oInf:AddGroup( {|| oInf:oDbf:cNomAge + oInf:oDbf:cDesArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cRefArt ) + "-" + Rtrim( oInf:oDbf:cDesArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TdlAgeFac FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  cEstado     AS CHARACTER     INIT  "Todas"
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  oIndice     AS OBJECT
   DATA  aIndice     AS ARRAY    INIT  { "Factura", "Su factura", "Artículos" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdlAgeFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

    /*
   Ficheros necesarios
   */

   BEGIN SEQUENCE

   DATABASE NEW ::oFacCliT  PATH ( cPatEmp() ) FILE "FACCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIT.CDX"

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TdlAgeFac

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TdlAgeFac

   local oTipVen
   local oTipVen2
   local cEstado     := "Todas"
   local This        := Self
   local cIndice     := "Albarán"

   if !::StdResource( "INF_GEN17A" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   ::oDefResInf()

   /*
   Damos valor al meter
   */

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcImp()

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   REDEFINE GET oTipVen VAR ::cTipVen ;
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

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TdlAgeFac

   local bValid   := {|| .t. }
   local lExcCero := .f.
   local nKlgEnt  := 0

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

     ::aHeader   := {{|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes },;
                     {|| "Facturas: " + ::cEstado },;
                     {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   ::oFacCliT:GoTop()
   WHILE ! ::oFacCliT:Eof()

      if Eval( bValid )                                                                     .AND.;
         ::oFacCliT:DFECFAC >= ::dIniInf                                                    .AND.;
         ::oFacCliT:DFECFAC <= ::dFinInf                                                    .AND.;
         ::oFacCliT:CCODAGE >= ::cAgeOrg                                                    .AND.;
         ::oFacCliT:CCODAGE <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:cSerie + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               if !::oFacCliL:lControl                                              .AND.;
                  ::oFacCliL:CREF >= ::cArtOrg                                      .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                                      .AND.;
                  !( ::lExcImp .and. ( nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                  nKlgEnt  := oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )

                  /* Preguntamos y tratamos el tipo de venta */

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oFacCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge := ::oFacCliT:cCodAge
                        ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                        ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                        ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                        ::oDbf:CCSUFAC := ::oFacCliT:cSufFac
                        ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC
                        ::oDbf:CREFART := ::oFacCliL:CREF
                        ::oDbf:CDESART := ::oFacCliL:cDetalle

                        ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

                        if ( ::oDbfTvta:Seek ( ::oFacCliL:cTipMov ) )
                           ::oDbf:cTipVen    := ::oDbfTvta:cDesMov
                        end if

                        if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:NUNDCAJ := ::oFacCliL:NCANENT
                           ::oDbf:NUNDART := ::oFacCliL:NUNICAJA
                           ::oDbf:NCAJUND := nTotNFacCli( ::oFacCliL )
                           ::oDbf:nTotPes := nTotNFacCli( ::oFacCliL ) * nKlgEnt
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:NUNDCAJ := - ::oFacCliL:NCANENT
                           ::oDbf:NUNDART := - ::oFacCliL:NUNICAJA
                           ::oDbf:NCAJUND := - nTotNFacCli( ::oFacCliL )
                           ::oDbf:nTotPes := - nTotNFacCli( ::oFacCliL ) * nKlgEnt
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:NUNDCAJ := 0
                           ::oDbf:NCAJUND := 0
                           ::oDbf:NUNDART := 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge := 0
                           ::oDbf:nBasCom := 0
                           ::oDbf:nTotCom := 0
                        else
                           ::oDbf:nComAge := ( ::oFacCliL:nComAge )
                           ::oDbf:nBasCom := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                           ::oDbf:nTotCom := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        end if

                        ::oDbf:Save()

                    end if

               /* Pasamos de los tipos de ventas */

               else

                  ::oDbf:Append()

                  ::oDbf:cCodAge := ::oFacCliT:cCodAge
                  ::oDbf:CCODCLI := ::oFacCliT:CCODCLI
                  ::oDbf:CNOMCLI := ::oFacCliT:CNOMCLI
                  ::oDbf:DFECMOV := ::oFacCliT:DFECFAC
                  ::oDbf:CCSUFAC := ::oFacCliT:cSufFac
                  ::oDbf:CDOCMOV := ::oFacCliT:cSerie + "/" + Str( ::oFacCliT:NNUMFAC ) + "/" + ::oFacCliT:CSUFFAC
                  ::oDbf:CREFART := ::oFacCliL:CREF
                  ::oDbf:CDESART := ::oFacCliL:cDetalle

                  ::AddCliente( ::oFacCliT:CCODCLI, ::oFacCliT, .f. )

                  if ( ::oDbfAge:Seek ( ::oFacCliT:cCodAge ) )
                     ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + Rtrim( ::oDbfAge:cNbrAge )
                  end if

                  ::oDbf:nUndCaj := ::oFacCliL:NCANENT
                  ::oDbf:nUndArt := ::oFacCliL:NUNICAJA
                  ::oDbf:nCajUnd := nTotNFacCli( ::oFacCliL )
                  ::oDbf:nTotPes := nTotNFacCli( ::oFacCliL ) * nKlgEnt
                  ::oDbf:nComAge := ::oFacCliL:nComAge
                  ::oDbf:nBasCom := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .f., .t., .f., .f. )
                  ::oDbf:nTotCom := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

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