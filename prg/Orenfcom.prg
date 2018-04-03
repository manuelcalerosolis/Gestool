#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ORenFCom FROM TPrvFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
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

   ::AddTmpIndex( "cFamArt", "cFamArt + cCodArt" )

   ::AddGroup( {|| ::oDbf:cFamArt }, {|| "Familia  : " + Rtrim( ::oDbf:cFamArt ) + "-" + oRetFld( ::oDbf:cFamArt, ::oDbfFam ) }, {||"Total familia..."} )
   ::AddGroup( {|| ::oDbf:cFamArt + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo : " } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ORenFCom

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   DATABASE NEW ::oArt PATH ( cPatEmp() )  FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"
   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"
   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfPrv  PATH ( cPatEmp() ) FILE "PROVEE.DBF"  VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS ORenFCom

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oArt ) .and. ::oArt:Used()
      ::oArt:End()
   end if

   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS ORenFCom

   if !::StdResource( "INF_GEN10C" )
      return .f.
   end if

   /* Monta familias */

   ::lDefFamInf( 110, 120, 130, 140 )

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

METHOD lGenerate() CLASS ORenGCom

   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local lExcCero    := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + AllTrim( ::cFamOrg )      + " > " + AllTrim (::cFamDes ) },;
                     {|| "Artículos: " + AllTrim( ::cArtOrg )      + " > " + AllTrim (::cArtDes ) } }

   /*
   Recorremos las cabeceras de los albaranes
   */

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )
   ::oMtrInf:cText := "Procesando albaranes"

   ::oAlbPrvT:GoTop()

   ::oAlbPrvT:Seek( ::dIniInf , .t. )

   while ::oAlbPrvT:dFecAlb <= ::dFinInf .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb

               if cCodFam( ::oAlbPrvL:cRef, ::oArt ) >= ::cFamOrg                                      .AND.;
                  cCodFam( ::oAlbPrvL:cRef, ::oArt ) <= ::cFamDes                                      .AND.;
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

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   /*
    Recorremos facturas
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )
   ::oMtrInf:cText := "Procesando factura"

   ::oFacPrvT:GoTop()

   ::oFacPrvT:Seek( ::dIniInf, .t. )

   while ::oFacPrvT:dFecFac <= ::dFinInf .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

            while ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac == ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac

               if cCodFam( ::oFacPrvL:cRef, ::oArt ) >= ::cFamOrg                                      .AND.;
                  cCodFam( ::oFacPrvL:cRef, ::oArt ) <= ::cFamDes                                      .AND.;
                  ::oFacPrvL:cRef >= ::cArtOrg                                                         .AND.;
                  ::oFacPrvL:cRef <= ::cArtDes                                                         .AND.;
                  !( ::oFacPrvL:lKitChl )                                                              .AND.;
                  !( ::lExcCero .AND. ( nTotNFacPrv( ::oFacPrvL:cAlias ) == 0 ) )                      .AND.;
                  !( ::lExcMov  .AND. ( nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

                  ::AddRFac()

               end if

               ::oFacPrvL:Skip()

            end while

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:Set( ::oFacPrvT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//