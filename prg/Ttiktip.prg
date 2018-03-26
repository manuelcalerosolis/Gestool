#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTTik FROM TInfTip

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
    
   DATA  oArt        AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfTikTip

   ::DetCreateFields()

   ::AddTmpIndex( "cCodTip", "cCodTip + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + oRetFld( ::oArt:cCodTip, ::oTipArt:oDbf, "cNomTip" ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfTikTip

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oArt PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfTikTip

   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfTikTip

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

METHOD lGenerate() CLASS TInfTikTip

   local bValid   := {|| .t. }
   local cCodTip

   ::oDlg:Disable()

   ::oDbf:Zap()

  ::aHeader   := {   {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Tipos   : " + ::cTipOrg           + " > " + ::cTipDes         } }

   ::oTikCliT:GoTop()

   WHILE !::oTikCliT:Eof()

      if Eval ( bValid )                                                         .AND.;
         ::oTikCliT:dFecTik >= ::dIniInf                                         .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                         .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )                                   .AND.;
         ( ::oTikCliT:cTipTik == "1" .or. ::oTikCliT:cTipTik == "4" )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil

               cCodTip := oRetFld( ::oTikCliL:cCbaTil, ::oArt , "cCodTip")

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

               cCodTip := oRetFld( ::oTikCliL:cComTil, ::oArt , "cCodTip")

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

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//