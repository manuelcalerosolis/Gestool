#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfAlbTip FROM TInfTip

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oArt        AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "No facturados", "Facturados", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfAlbTip

   ::DetCreateFields()

   ::AddTmpIndex( "cCodTip", "cCodTip + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + oRetFld( ::oArt:cCodTip, ::oTipArt:oDbf, "cNomTip" ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfAlbTip

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "AlbCliL.DBF" VIA ( cDriver() ) SHARED INDEX "AlbCliL.CDX"

   DATABASE NEW ::oArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"


   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfAlbTip

   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfAlbTip

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN11C" )
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

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfAlbTip

   local bValid   := {|| .t. }
   local cCodTip

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 2
         bValid   := {|| lFacturado( ::oAlbCliT ) }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

  ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Tipos   : " + ::cTipOrg           + " > " + ::cTipDes         },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbCliT:GoTop()

   WHILE !::oAlbCliT:Eof()

      if Eval ( bValid )                                                         .AND.;
         ::oAlbCliT:dFecAlb >= ::dIniInf                                         .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                         .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb

               cCodTip := oRetFld( ::oAlbCliL:cRef, ::oArt , "cCodTip")

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

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//