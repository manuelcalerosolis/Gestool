#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuVtaTip FROM TInfTip

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::TipAnuCreateFld()

   ::AddTmpIndex( "cCodTip", "cCodTip + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + oRetFld( ::oDbfArt:cCodTip, ::oTipArt:oDbf, "cNomTip" ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if

   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if

  if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

  if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "RETIPTIK" )
      return .f.
   end if

   /*
   Monta los años
   */

   ::oDefYea()

   /* Monta tipo de artículos */

   ::oDefTipInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nPreDiv
   local cCodTip

   ::oDlg:Disable()

   /*
   Nos movemos por las cabeceras de los pedidos
	*/

   ::oDbf:Zap()

   ::oTikCliT:GoTop()

   /*
   Damos valor al meter
   */

   ::oMtrInf:cText   := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   /*
   Nos movemos por las cabeceras de los albaranes a proveedores
	*/

   ::oAlbCliT:GoTop()
   while ! ::oAlbCliT:Eof()

      if Year( ::oAlbCliT:dFecAlb ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oAlbCliT:CSERALB, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB )

            while ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB == ::oAlbCliL:CSERALB + Str( ::oAlbCliL:NNUMALB ) + ::oAlbCliL:CSUFALB .AND. ! ::oAlbCliL:eof()

               cCodTip := oRetFld( ::oAlbCliL:CREF, ::oDbfArt , "cCodTip")

               if ::oAlbCliL:CREF >= ::cArtOrg                           .AND.;
                  ::oAlbCliL:CREF <= ::cArtDes                           .AND.;
                  cCodTip >= ::cTipOrg                                   .AND.;
                  cCodTip <= ::cTipDes                                   .AND.;
                  !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 )

                  //if !::oDbf:Seek( cCodTip + ::oAlbCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cCodTip := cCodTip
                     ::oDbf:cCodArt := ::oAlbCliL:cRef
                     ::oDbf:cNomTip := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:cNomArt := oRetFld( ::oAlbCliL:cRef, ::oDbfArt )
                     ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                     ::oDbf:Insert()
                  //end if

                  ::AddImporte( ::oAlbCliT:dFecAlb, nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Nos movemos por las cabeceras de los facturas a proveedores
	*/

   ::oMtrInf:cText   := "Facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oFacCliT:GoTop()
   while !::oFacCliT:Eof()

      if Year( ::oFacCliT:dFecFac ) == ::nYeaInf                             .AND.;
         lChkSer( ::oFacCliT:CSERIE, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oFacCliL:Seek( ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC )

            while ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC == ::oFacCliL:CSERIE + Str( ::oFacCliL:NNUMFAC ) + ::oFacCliL:CSUFFAC .AND. ! ::oFacCliL:eof()

               cCodTip := oRetFld( ::oFacCliL:cRef, ::oDbfArt , "cCodTip")

               if ::oFacCliL:CREF >= ::cArtOrg                                                .AND.;
                  ::oFacCliL:CREF <= ::cArtDes                                                .AND.;
                  cCodTip >= ::cTipOrg                                                        .AND.;
                  cCodTip <= ::cTipDes                                                        .AND.;
                  !( ::lExcCero .AND. ( NotCaja( ::oFacCliL:nCanFac ) * ::oFacCliL:nUniCaje ) == 0 )

                  //if !::oDbf:Seek( cCodTip + ::oFacCliL:cRef )
                     ::oDbf:Blank()
                     ::oDbf:cCodTip := cCodTip
                     ::oDbf:cCodArt := ::oFacCliL:cRef
                     ::oDbf:cNomTip := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:cNomArt := oRetFld( ::oFacCliL:cRef, ::oDbfArt )
                     ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
                     ::oDbf:Insert()
                  //end if

                  ::AddImporte( ::oFacCliT:dFecFac, nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oMtrInf:cText   := "Tickets"
   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oTikCliT:GoTop()
   while ! ::oTikCliT:Eof()

      if ( ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4" )   .AND.;
         Year( ::oTikCliT:dFecTik ) == ::nYeaInf                        .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               cCodTip := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt , "cCodTip")

               if !Empty( ::oTikCliL:cCbaTil )                                                .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                             .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                             .AND.;
                  cCodTip >= ::cTipOrg                                                        .AND.;
                  cCodTip <= ::cTipDes                                                        .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nPvpTil == 0 )

                  //if !::oDbf:Seek( cCodTip + ::oTikCliL:cCbaTil )
                     ::oDbf:Blank()
                     ::oDbf:cCodTip := cCodTip
                     ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                     ::oDbf:cNomTip := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt )
                     ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
                     ::oDbf:Insert()
                  //end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               /*
               Productos combinados--------------------------------------------
               */

               cCodTip := oRetFld( ::oTikCliL:cComTil, ::oDbfArt , "cCodTip")

               if !Empty( ::oTikCliL:cComTil )                                                .AND.;
                  ::oTikCliL:cComTil >= ::cArtOrg                                             .AND.;
                  ::oTikCliL:cComTil <= ::cArtDes                                             .AND.;
                  cCodTip >= ::cTipOrg                                                        .AND.;
                  cCodTip <= ::cTipDes                                                        .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPcmTil == 0 )

                 // if !::oDbf:Seek( cCodTip + ::oTikCliL:cComTil )
                     ::oDbf:Blank()
                     ::oDbf:cCodTip := cCodTip
                     ::oDbf:cCodArt := ::oTikCliL:cComTil
                     ::oDbf:cNomTip := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cComTil, ::oDbfArt )
                     ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
                     ::oDbf:Insert()
                 // end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//