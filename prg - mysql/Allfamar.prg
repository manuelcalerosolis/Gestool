#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TFamVtaArt FROM TInfFam

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetCreateFields()

   ::AddTmpIndex( "CCODFAM", "CFAMART + CCODART" )
   ::AddGroup( {|| ::oDbf:cFamArt }, {|| "Familia  : " + Rtrim( ::oDbf:cFamArt ) + "-" + oRetFld( ::oDbf:cFamArt, ::oDbfFam ) }, {||"Total familia..."} )
   ::AddGroup( {|| ::oDbf:cFamArt + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) CLASS "TIKETT" FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) CLASS "TIKETL" FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) CLASS "ARTICULO" FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oTikCliT != NIL
      ::oTikCliT:End()
   end if

   if ::oTikCliL != NIL
      ::oTikCliL:End()
   end if

   if ::oFacCliT != NIL
      ::oFacCliT:End()
   end if

   if ::oFacCliL != NIL
      ::oFacCliL:End()
   end if

   if ::oAlbCliT != NIL
      ::oAlbCliT:End()
   end if

   if ::oAlbCliL != NIL
      ::oAlbCliL:End()
   end if

   ::oTikCliT := NIL
   ::oTikCliL := NIL
   ::oFacCliT := NIL
   ::oFacCliL := NIL
   ::oAlbCliT := NIL
   ::oAlbCliL := NIL

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN18" )
      Return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 70, 80, 90, 100 )

   /*
   Excluir si cero
   */

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodFam
   local nLasTik  := ::oTikCliT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacCliT:Lastrec()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oMtrInf:SetTotal( nLasTik )
   ::oMtrInf:cText := "Procesando tikets"

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia : " + ::cFamOrg       + " > " + ::cFamDes       } }

   /*
    Recorremos tikets
   */

   ::oTikCliT:GoTop()
   while !::oTikCliT:Eof() .and. !::lBreak

      if ::oTikCliT:dFecTik >= ::dIniInf                               .and.;
         ::oTikCliT:dFecTik <= ::dFinInf                               .and.;
         ( ::oTikCliT:cTipTik == "1" .or. ::oTikCliT:cTipTik == "4" )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik .and.;
                  !::oTikCliL:eof()

               cCodFam := cCodFam( ::oTikCliL:cCbaTil, ::oDbfArt )

               if !Empty( ::oTikCliL:cCbaTil )                                     .and.;
                  cCodFam             >= ::cFamOrg                                 .and.;
                  cCodFam             <= ::cFamDes                                 .and.;
                  ::oTikCliL:cCbaTil  >= ::cArtOrg                                 .and.;
                  ::oTikCliL:cCbaTil  <= ::cArtDes                                 .and.;
                  ::oTikCliL:nCtlStk != 2                                          .and.;
                  if( ::lExcCero, ::oTikCliL:nUntTil != 0, .t. )

                  /*
                  Añade los Registros, viene de la clase padre
                  */
                  ::AddTik( cCodFam )

               end if

               cCodFam := cCodFam( ::oTikCliL:cComTil, ::oDbfArt )

               if !Empty( ::oTikCliL:cComTil )                                     .and.;
                  cCodFam             >= ::cFamOrg                                 .and.;
                  cCodFam             <= ::cFamDes                                 .and.;
                  ::oTikCliL:cComTil  >= ::cArtOrg                                 .and.;
                  ::oTikCliL:cComTil  <= ::cArtDes                                 .and.;
                  ::oTikCliL:nCtlStk != 2                                          .and.;
                  if( ::lExcCero, ::oTikCliL:nUntTil != 0, .t. )

                  /*
                  Añade los Registros, viene de la clase padre
                  */
                  ::AddTik( cCodFam )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Recorremos albaranes
   */

   ::oAlbCliT:GoTop()
   ::oMtrInf:SetTotal( nLasAlb )
   ::oMtrInf:cText := "Procesando albaranes"

   while !::oAlbCliT:Eof() .and. !::lBreak

      if ::oAlbCliT:dFecAlb >= ::dIniInf                 .and.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                 .and.;
         !lFacturado( ::oAlbCliT )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb )+ ::oAlbCliT:cSufAlb )

            while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb )+ ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and.;
                  !::oAlbCliL:eof()

               cCodFam := cCodFam( ::oAlbCliL:cRef, ::oDbfArt )

               if cCodFam >= ::cFamOrg                               .and.;
                  cCodFam <= ::cFamDes                               .and.;
                  ::oAlbCliL:cRef >= ::cArtOrg                       .and.;
                  ::oAlbCliL:cRef <= ::cArtDes                       .and.;
                  ::oAlbCliL:nCtlStk != 2                            .and.;
                  if( ::lExcCero, nTotNAlbCli( ::oAlbCliL ) != 0, .t. )

                  /*
                  Añade los Registros, viene de la clase padre
                  */
                  ::AddAlb( cCodFam )

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
    Recorremos facturas
   */

   ::oFacCliT:GoTop()
   ::oMtrInf:SetTotal( nLasFac )
   ::oMtrInf:cText := "Procesando factura"

   while !::oFacCliT:Eof() .and. !::lBreak

      if ::oFacCliT:dFecFac >= ::dIniInf .and. ::oFacCliT:dFecFac <= ::dFinInf

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac )+ ::oFacCliT:cSufFac )

            while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac )+ ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and.;
                  !::oFacCliL:eof()

               cCodFam := cCodFam( ::oFacCliL:cRef, ::oDbfArt )

               if cCodFam >= ::cFamOrg                               .and.;
                  cCodFam <= ::cFamDes                               .and.;
                  ::oFacCliL:cRef >= ::cArtOrg                       .and.;
                  ::oFacCliL:cRef <= ::cArtDes                       .and.;
                  ::oFacCliL:nCtlStk != 2                            .and.;
                  if( ::lExcCero, nTotNFacCli( ::oFacCliL ) != 0, .t. )

                  /*
                  Añade los Registros, viene de la clase padre
                  */
                  ::AddFac( cCodFam )

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( nLasFac )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//