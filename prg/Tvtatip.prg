#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TVtaTip FROM TInfTip

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
    

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetCreateFields()

   ::AddTmpIndex( "cCodTip", "cCodTip + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + oRetFld( ::oDbfArt:cCodTip, ::oTipArt:oDbf, "cNomTip" ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {||""} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) CLASS "TIKETT" FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) CLASS "TIKETL" FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatEmp() ) CLASS "ARTICULO" FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN11E" )
      return .f.
   end if

   /* Monta tipo de artículos */

   ::oDefTipInf( 110, 120, 130, 140 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 70, 80, 90, 100 )

   /* Meter */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   ::oDefExcInf( 204 )

   ::oDefSalInf( 201 )

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cCodTip
   local nLasTik  := ::oTikCliT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacCliT:Lastrec()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oMtrInf:SetTotal( nLasTik )
   ::oMtrInf:cText := "Procesando tikets"

   ::aHeader   := {   {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Tipos   : " + ::cTipOrg           + " > " + ::cTipDes         } }

   /*
    Recorremos tikets
   */

   ::oTikCliT:GoTop()

   WHILE !::oTikCliT:Eof()

      if ::oTikCliT:dFecTik >= ::dIniInf                                         .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                         .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )                                   .AND.;
         ( ::oTikCliT:cTipTik == "1" .or. ::oTikCliT:cTipTik == "4" )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil

               cCodTip := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt , "cCodTip")

               if !Empty( ::oTikCliL:cCbaTil )                                    .AND.;
                  cCodTip            >= ::cTipOrg                                 .AND.;
                  cCodTip            <= ::cTipDes                                 .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                 .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                 .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUniCaja == 0 )

                  /*
                  Añadimos un nuevo registro desde la clase padre
                  */

                  ::AddTik ( cCodTip )

               end if

               /*
               Productos combinados
               */

               cCodTip := oRetFld( ::oTikCliL:cComTil, ::oDbfArt , "cCodTip")

               if !Empty( ::oTikCliL:cComTil )                                    .AND.;
                  cCodTip            >= ::cTipOrg                                 .AND.;
                  cCodTip            <= ::cTipDes                                 .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                                 .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                                 .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUniCaja == 0 )

                  /*
                  Añadimos un nuevo registro desde la clase padre
                  */

                  ::AddTik ( cCodTip )

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

    WHILE !::oAlbCliT:Eof()

      if ::oAlbCliT:dFecAlb >= ::dIniInf                                         .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                         .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb

               cCodTip := oRetFld( ::oAlbCliL:cRef, ::oDbfArt , "cCodTip")

               if cCodTip            >= ::cTipOrg                                 .AND.;
                  cCodTip            <= ::cTipDes                                 .AND.;
                  ::oAlbCliL:cRef    >= ::cArtOrg                                 .AND.;
                  ::oAlbCliL:cRef    <= ::cArtDes                                 .AND.;
                  !( ::lExcCero .AND. ::oAlbCliL:nUniCaja == 0 )

                  /*
                  Añadimos un nuevo registro
                  */

                  ::AddAlb( cCodTip )

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

    WHILE !::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf                                         .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf                                         .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac

               cCodTip := oRetFld( ::oFacCliL:cRef, ::oDbfArt , "cCodTip")

               if cCodTip            >= ::cTipOrg                                 .AND.;
                  cCodTip            <= ::cTipDes                                 .AND.;
                  ::oFacCliL:cRef    >= ::cArtOrg                                 .AND.;
                  ::oFacCliL:cRef    <= ::cArtDes                                 .AND.;
                  !( ::lExcCero .AND. ::oFacCliL:nUniCaja == 0 )

                  /*
                  Añadimos un nuevo registro
                  */

                  ::AddFac( cCodTip )

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