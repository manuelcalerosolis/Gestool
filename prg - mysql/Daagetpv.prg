#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION DAAgeTpv()

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
   aAdd( aCol, { "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .f., "Fecha",                      12 } )
   aAdd( aCol, { "NUNDART", "N", 13, 6,  {|| MasUnd () },    "Und.",                      .t., "Unidades",                   14 } )
   aAdd( aCol, { "NBASCOM", "N", 13, 6,  {|| oInf:cPicOut }, "Base",                      .t., "Base comisión",              12 } )
   aAdd( aCol, { "NCOMAGE", "N",  4, 1,  {|| "@E 99,99" },   "%Com",                      .t., "Porcentaje de comisión",     12 } )
   aAdd( aCol, { "NTOTCOM", "N", 13, 6,  {|| oInf:cPicOut }, "Comisión",                  .t., "Importe comisión",           12 } )
   aAdd( aCol, { "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Factura",                   .t., "Factura",                    14 } )
   aAdd( aCol, { "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                     .t., "Fecha",                       8 } )
   aAdd( aCol, { "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                     .f., "Tipo de venta",              20 } )

   aAdd( aIdx, { "CNOMAGE", "CNOMAGE + CREFART" } )

   oInf  := TDLAgeTpv():New( "Informe detallado de la liquidación de agentes agrupados por artículos en tikets", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cNomAge },                     {|| "Agente   : " + Rtrim( oInf:oDbf:cNomAge ) + "-" + oRetFld( oInf:oDbf:cNomAge, oInf:oDbfAge ) }, {||"Total agente..."} )
   oInf:AddGroup( {|| oInf:oDbf:cNomAge + oInf:oDbf:cDesArt }, {|| "Artículo : " + Rtrim( oInf:oDbf:cRefArt ) + "-" + Rtrim( oInf:oDbf:cDesArt ) }, {||""} )

   oInf:Resource()
   oInf:Activate()

   // oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDLAgeTpv FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  cEstado     AS CHARACTER     INIT  ""
   DATA  oEstado     AS OBJECT
   DATA  oTpvCliT    AS OBJECT
   DATA  oTpvCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "" }

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDLAgeTpv

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTpvCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTpvCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDLAgeTpv

   ::oTpvCliT:End()
   ::oTpvCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDLAgeTpv

   local oTipVen
   local oTipVen2
   local cEstado     := ""
   local This        := Self

   if !::StdResource( "INF_GEN17B" )
      Return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   ::oDefResInf()

   ::oDefExcImp()

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oMtrInf:SetTotal( ::oTpvCliT:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDLAgeTpv

   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTpvCliT:GoTop()

  ::aHeader       := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE ! ::oTpvCliT:Eof()

      if ::oTpvCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTpvCliT:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTpvCliT:cCodAge >= ::cAgeOrg                                                    .AND.;
         ::oTpvCliT:cCodAge <= ::cAgeDes                                                    .AND.;
         ::oTpvCliT:cTipTik == "1"                                                          .AND.;
         lChkSer( ::oTpvCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oTpvCliL:Seek( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik )

            while ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik == ::oTpvCliL:cSerTil + ::oTpvCliL:cNumTil + ::oTpvCliL:cSufTil .AND. ! ::oTpvCliL:eof()

               if ::oTpvCliL:cCbaTil >= ::cArtOrg                                      .AND.;
                  ::oTpvCliL:cCbaTil <= ::cArtDes                                      .AND.;
                  !( ::lExcImp .and. nTotLTpv( ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAge := ::oTpvCliT:cCodAge
                  ::oDbf:CCODCLI := ::oTpvCliT:cCliTik
                  ::oDbf:CNOMCLI := ::oTpvCliT:cNomTik
                  ::oDbf:DFECMOV := ::oTpvCliT:dFecTik
                  ::oDbf:CDOCMOV := ::oTpvCliT:cSerTik + "/" + ::oTpvCliT:cNumTik + "/" + ::oTpvCliT:cSufTik
                  ::oDbf:CREFART := ::oTpvCliL:cCbaTil
                  ::oDbf:CDESART := ::oTpvCliL:cNomTil

                  ::AddCliente( ::oTpvCliT:cCliTik, ::oTpvCliT, .t. )

                  if ( ::oDbfAge:Seek ( ::oTpvCliT:cCodAge ) )
                     ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + Rtrim( ::oDbfAge:cNbrAge )
                  end if

                  ::oDbf:NUNDART := ::oTpvCliL:nUntTil
                  ::oDbf:nComAge := ::oTpvCliT:nComAge
                  ::oDbf:nBasCom := nTotLTpv( ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotCom := nTotComTik( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik, ::oTpvCliT:cAlias, ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:Save()

               end if

            ::oTpvCliL:Skip()

            end while

         end if

      end if

      ::oTpvCliT:Skip()

      ::oMtrInf:AutoInc( ::oTpvCliT:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//