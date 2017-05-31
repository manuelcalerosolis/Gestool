#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ORenGAlb FROM TPrvGrp

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oArt        AS OBJECT
   DATA  oDbfFam     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::RentCreateFields()

   ::AddTmpIndex ( "CGRPFAM", "CGRPFAM + CCODART" )
   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo Familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf ) }, {||"Total Grupo de Familia..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ORenGAlb

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   DATABASE NEW ::oArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oDbfPrv  PATH ( cPatPrv() ) FILE "PROVEE.DBF"  VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS ORenGAlb

   ::oArt:End()
   ::oAlbPrvT:End()
   ::oAlbPrvL:End()
   ::oDbfFam:End()
   ::oDbfPrv:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS ORenGAlb

   if !::StdResource( "INF_GEN10D" )
      return .f.
   end if

   /*
   Monta Grupos de Familias
   */
   ::oDefGrFInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 70, 80, 90, 100 )

   ::oDefExcInf( 204 )

   ::oDefResInf()

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]


RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS ORenGAlb

   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local lExcCero    := .f.

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Gr. Fam.: " + AllTrim( ::cGruFamOrg )      + " > " + AllTrim (::cGruFamDes ) },;
                     {|| "Artículos: " + AllTrim( ::cArtOrg )      + " > " + AllTrim (::cArtDes ) } }

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )

   ::oAlbPrvT:GoTop()

   ::oAlbPrvT:Seek ( ::dIniInf , .t. )

   while ::oAlbPrvT:dFecAlb <= ::dFinInf .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb

               if cCodGruFam( ::oAlbPrvL:cRef, ::oArt, ::oDbfFam ) >= ::cGruFamOrg                     .AND.;
                  cCodGruFam( ::oAlbPrvL:cRef, ::oArt, ::oDbfFam ) <= ::cGruFamDes                     .AND.;
                  ::oAlbPrvL:cRef >= ::cArtOrg                                                         .AND.;
                  ::oAlbPrvL:cRef <= ::cArtDes                                                         .AND.;
                  !( ::oAlbPrvL:lKitChl )                                                              .AND.;
                  !( ::lExcCero .AND. ( nTotNAlbPrv( ::oAlbPrvL:cAlias ) == 0 ) )                      .AND.;
                  !( ::lExcMov  .AND. ( nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

                  ::AddRAlb()

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

      ::oAlbPrvT:Skip()

   end while

   ::oMtrInf:AutoInc( ::oAlbPrvT:Lastrec() )

  ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//