#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTPre FROM TInfTip

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  oArt        AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Aceptado", "Todos" }

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
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + oRetFld( ::oArt:cCodTip, ::oTipArt:oDbf, "cNomTip" ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfPreTip

   /*
   Ficheros necesarios
   */

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfPreTip

   ::oPreCliT:End()
   ::oPreCliL:End()
   ::oArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfPreTip

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

METHOD lGenerate() CLASS TInfPreTip

   local bValid   := {|| .t. }
   local cCodTip

   ::oDlg:Disable()

   ::oDbf:Zap()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oPreCliT:lEstado }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPreCliT:lEstado }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Tipos   : " + ::cTipOrg           + " > " + ::cTipDes         },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }


   ::oPreCliT:GoTop()

   WHILE !::oPreCliT:Eof()

      if Eval ( bValid )                                                         .AND.;
         ::oPreCliT:dFecPre >= ::dIniInf                                         .AND.;
         ::oPreCliT:dFecPre <= ::dFinInf                                         .AND.;
         lChkSer( ::oPreCliT:cSerPre, ::aSer )                                   .AND.;
         !( ::lExcCero .AND. nTotNPreCli( ::oPreCliL:cAlias ) == 0 )             .AND.;
         !( ::lExcMov  .AND. nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre

               cCodTip := oRetFld( ::oPreCliL:cRef, ::oArt , "cCodTip")

               if cCodTip            >= ::cTipOrg                                 .AND.;
                  cCodTip            <= ::cTipDes                                 .AND.;
                  ::oPreCliL:cRef    >= ::cArtOrg                                 .AND.;
                  ::oPreCliL:cRef    <= ::cArtDes

                  /*
                  Añadimos un nuevo registro
                  */

                  ::oDbf:Append()

                  ::AddCliente      ( ::oPreCliT:cCodCli, ::oPreCliT, .f. )

                  ::oDbf:cCodTip    := cCodTip
                  ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                  ::oDbf:cCodArt    := ::oPreCliL:cRef
                  ::oDbf:cNomArt    := ::oPreCliL:cDetalle
                  ::oDbf:nNumCaj    := ::oPreCliL:nCanPre
                  ::oDbf:nUniDad    := ::oPreCliL:NUNICAJA
                  ::oDbf:nNumUni    := nTotNPreCli( ::oPreCliL )
                  ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oPreCliL:nIva / 100, ::nDerOut )

                  ::oDbf:cDocMov    := lTrim( ::oPreCliL:CSERPRE ) + "/" + lTrim ( Str( ::oPreCliL:NNUMPRE ) ) + "/" + lTrim ( ::oPreCliL:CSUFPRE )
                  ::oDbf:dFecMov    := ::oPreCliT:DFECPRE

                  ::oDbf:Save()

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )


//---------------------------------------------------------------------------//