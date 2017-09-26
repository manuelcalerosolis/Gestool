#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfAgeArt FROM TInfGen

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oIva        AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 15, 0,  {|| "" },           "Doc.",                      .t., "Documento",                  12 )
   ::AddField( "cCodAge", "C",  3, 0,  {|| "@!" },         "Cód. age.",                 .f., "Cod. Agente",                 3 )
   ::AddField( "cNomAge", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nom. Agente",                25 )
   ::AddField( "cCodCli", "C", 12, 0,  {|| "@!" },         "Cód. cli.",                 .f., "Cod. Cliente",                8 )
   ::AddField( "cNomCli", "C", 50, 0,  {|| "@!" },         "Cliente",                   .f., "Nom. Cliente",               40 )
   ::AddField( "cNifCli", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 )
   ::AddField( "cDomCli", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 )
   ::AddField( "cPobCli", "C", 25, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 )
   ::AddField( "cProCli", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "cCdpCli", "C",  7, 0,  {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 )
   ::AddField( "cTlfCli", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 )
   ::AddField( "dFecDoc", "D",  8, 0,  {|| "" },           "Fecha",                     .t., "Fecha",                      10 )
   ::AddField( "cCodArt", "C", 18, 0,  {|| "" },           "Código artículo",                 .t., "Artículos",                  12 )
   ::AddField( "cNomArt", "C",100, 0,  {|| "" },           "Nom. Art.",                 .t., "Nombre artículo",            25 )
   ::AddField( "nUndCaj", "N", 16, 6,  {|| MasUnd () },    "Caj.",                      .f., "Cajas",                      12 )
   ::AddField( "nUndArt", "N", 16, 6,  {|| MasUnd () },    "Und.",                      .f., "Unidades",                   12 )
   ::AddField( "nTotUnd", "N", 16, 6,  {|| MasUnd () },    "Tot. und.",                 .t., "Total unidades",             12 )
   ::AddField( "nPreUni", "N", 16, 0,  {|| "" },           "Precio",                    .t., "Precio unidad",              10 )
   ::AddField( "nTotRec", "N", 16, 6,  {|| ::cPicOut },    "Total",                     .t., "Total",                      10 )

   ::AddTmpIndex( "cCodAge", "cCodAge" )
   ::AddTmpIndex( "cCodCli", "cCodAge + cCodCli" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) } , {||"Total Agentes..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodCli}, {|| "Cliente : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) } , {||"Total Clientes..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oIva:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN25A" )
      return .f.
   end if

   ::oDefAgeInf( 1450, 1451, 1460, 1461 )

   ::oDefCliInf( 1470, 1471, 1480, 1481 )

   ::lDefArtInf( 1490, 1491, 1500, 1501 )

   ::oDefResInf( 1510 )

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oFacCliT:GoTop()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes   : " + Rtrim(::cAgeOrg)         + " > " + Rtrim(::cAgeDes) },;
                        {|| "Clientes  : " + Rtrim(::cCliOrg)         + " > " + Rtrim(::cCliDes) },;
                        {|| "Articulos : " + Rtrim(::cArtOrg)         + " > " + Rtrim(::cArtDes) } }

   /*
   Damos valor al meter--------------------------------------------------------
   */

   WHILE !::oFacCliT:Eof()

       if ::oFacCliT:dFecFac >= ::dIniInf                                                     .AND.;
         ::oFacCliT:dFecFac  <= ::dFinInf                                                     .AND.;
         ::oFacCliT:cCodCli  >= ::cCliOrg                                                     .AND.;
         ::oFacCliT:cCodCli  <= ::cCliDes                                                     .AND.;
         ::oFacCliT:cCodAge  <= ::cAgeOrg                                                     .AND.;
         ::oFacCliT:cCodAge  >= ::cAgeDes                                                     .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            if ::oFacCliL:cRef >= ::cArtOrg                                                   .AND.;
               ::oFacCliL:cRef <= ::cArtDes

               ::oDbf:Append()

               ::AddCliente ( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

               ::oDbf:cNumDoc    := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac
               ::oDbf:cCodAge    := ::oFacCliT:cCodAge
               if ::oDbfAge:Seek( ::oFacCliT:cCodAge )
                  ::oDbf:cNomAge := ::oDbfAge:cApeAge + ", " + ::oDbfAge:cNbrAge
               end if

               if ::oDbfArt:Seek( ::oFacCliL:cRef )
                  ::oDbf:cNomArt := ::oDbfArt:Nombre
               end if

               ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
               ::oDbf:cCodArt    := ::oFacCliL:cRef
               ::oDbf:nUndCaj    := ::oFacCliL:nCanEnt
               ::oDbf:nUndArt    := ::oFacCliL:nUniCaja
               ::oDbf:nTotUnd    := nTotNFacCli( ::oFacCliL )
               ::oDbf:nPreUni    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oFacCliL, ::nDecOut )
               ::oDbf:nTotRec    := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::oDbf:Save()

            end if

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//