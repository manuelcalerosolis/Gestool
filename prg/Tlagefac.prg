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
   aAdd( aCol, { "CREFART", "C", 18, 0,  {|| "@!" },         "Código artículo",                 .f., "Cod. artículo",              14 } )
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

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatEmp() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

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

   ::oDefExcImp()

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

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

                        if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
                           ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
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