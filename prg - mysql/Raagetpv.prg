#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRLAgeTpv FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  cEstado     AS CHARACTER     INIT  ""
   DATA  oEstado     AS OBJECT
   DATA  oTpvCliT    AS OBJECT
   DATA  oTpvCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cod. age.",             .f., "Cod. agente",             3 )
   ::AddField ( "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                .f., "Nom. agente",            25 )
   ::AddField ( "CCODCLI", "C", 12, 0,  {|| "@!" },         "Cod. cli.",             .t., "Cod. cliente",           12 )
   ::AddField ( "CNOMCLI", "C", 50, 0,  {|| "@!" },         "Nombre",                .t., "Nom. cliente",           35 )
   ::AddField ( "CNIFCLI", "C", 15, 0,  {|| "@!" },         "Nif",                   .f., "Nif",                    12 )
   ::AddField ( "CDOMCLI", "C", 35, 0,  {|| "@!" },         "Domicilio",             .f., "Domicilio",              40 )
   ::AddField ( "CPOBCLI", "C", 25, 0,  {|| "@!" },         "Población",             .f., "Población",              25 )
   ::AddField ( "CPROCLI", "C", 20, 0,  {|| "@!" },         "Provincia",             .f., "Provincia",              20 )
   ::AddField ( "CCDPCLI", "C",  7, 0,  {|| "@!" },         "Cod. Postal",           .f., "Cod. Postal",             7 )
   ::AddField ( "CTLFCLI", "C", 12, 0,  {|| "@!" },         "Teléfono",              .f., "Teléfono",               12 )
   ::AddField ( "CREFART", "C", 18, 0,  {|| "@!" },         "Código artículo",             .f., "Cod. artículo",          14 )
   ::AddField ( "CDESART", "C", 50, 0,  {|| "@!" },         "Descripción",           .f., "Descripción",            25 )
   ::AddField ( "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                 .f., "Fecha",                  12 )
   ::AddField ( "NUNDART", "N", 13, 6,  {|| MasUnd () },    "Und.",                  .t., "Unidades",               14 )
   ::AddField ( "NBASCOM", "N", 13, 6,  {|| ::cPicOut },    "Base",                  .t., "Base comisión",          12 )
   ::AddField ( "NCOMAGE", "N",  4, 1,  {|| "@E 99,99" },   "%Com",                  .t., "Porcentaje de comisión", 12 )
   ::AddField ( "NTOTCOM", "N", 13, 6,  {|| ::cPicOut },    "Comisión",              .t., "Importe comisión",       12 )
   ::AddField ( "CDOCMOV", "C", 14, 0,  {|| "@!" },         "Factura",               .t., "Factura",                14 )
   ::AddField ( "DFECMOV", "D",  8, 0,  {|| "@!" },         "Fecha",                 .t., "Fecha",                   8 )
   ::AddField ( "CTIPVEN", "C", 20, 0,  {|| "@!" },         "Venta",                 .f., "Tipo de venta",          20 )

   ::AddTmpIndex ( "CNOMAGE", "CNOMAGE + CREFART" )

   ::AddGroup( {|| ::oDbf:cNomAge }, {|| "Agente   : " + Rtrim( ::oDbf:cNomAge ) + "-" + oRetFld( ::oDbf:cNomAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRLAgeTpv

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   DATABASE NEW ::oTpvCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTpvCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRLAgeTpv

   ::oTpvCliT:End()
   ::oTpvCliL:End()
   ::oDbfCli:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRLAgeTpv

   local oTipVen
   local oTipVen2
   local cEstado     := ""
   local This        := Self

   if !::StdResource( "INF_GEN17B" )
      return .f.
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

METHOD lGenerate() CLASS TRLAgeTpv

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

                  if ::oDbf:Seek( ::oTpvCliT:cCodAge + ::oTpvCliL:cCbaTil )

                     ::oDbf:Load()

                     ::oDbf:nUndArt += ::oTpvCliL:nUntTil
                     ::oDbf:nComAge += ::oTpvCliT:nComAge
                     ::oDbf:nBasCom += nTotLTpv( ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotCom += nTotComTik( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik, ::oTpvCliT:cAlias, ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  else

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

                     ::oDbf:nUndArt := ::oTpvCliL:nUntTil
                     ::oDbf:nComAge := ::oTpvCliT:nComAge
                     ::oDbf:nBasCom := nTotLTpv( ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotCom := nTotComTik( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik, ::oTpvCliT:cAlias, ::oTpvCliL:cAlias, ::nDecOut, ::nDerOut )

                     ::oDbf:Save()

                  end if

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