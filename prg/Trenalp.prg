#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenAlp FROM TPrvAlm

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oArt        AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::RentCreateFields()

   ::AddTmpIndex( "CCODALM", "CCODALM + CCODART" )
   ::AddGroup( {|| ::oDbf:cCodAlm },                     {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {||"Total almacén..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenAlp

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oArt     PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oDbfPrv  PATH ( cPatEmp() ) FILE "PROVEE.DBF"  VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenAlp

   ::oArt:End()
   ::oAlbPrvT:End()
   ::oAlbPrvL:End()
   ::oDbfPrv:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRenAlp

   if !::StdResource( "INF_GEN10E" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 110, 120, 130, 140 )

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


RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenAlp

   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local lExcCero    := .f.

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacenes: " + AllTrim( ::cAlmOrg )      + " > " + AllTrim (::cAlmDes ) },;
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

               if ::oAlbPrvL:cAlmLin >= ::cAlmOrg                                                                        .AND.;
                  ::oAlbPrvL:cAlmLin <= ::cAlmDes                                                                        .AND.;
                  ::oAlbPrvL:cRef >= ::cArtOrg                                                                           .AND.;
                  ::oAlbPrvL:cRef <= ::cArtDes                                                                           .AND.;
                  !( ::oAlbPrvL:lKitChl )                                                                                .AND.;
                  !( ::lExcCero .AND. ( nTotNAlbPrv( ::oAlbPrvL:cAlias ) == 0 ) )                                        .AND.;
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