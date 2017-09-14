#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPedTip FROM TInfTip

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oArt        AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Parcialmente", "Pendiente y parc.", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfPedTip

   ::DetCreateFields()

   ::AddTmpIndex( "cCodTip", "cCodTip + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + oRetFld( ::oArt:cCodTip, ::oTipArt:oDbf, "cNomTip" ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oArt ) ) }, {||""} )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfPedTip

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PedCliL.DBF" VIA ( cDriver() ) SHARED INDEX "PedCliL.CDX"

   DATABASE NEW ::oArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfPedTip

   ::oPedCliT:End()
   ::oPedCliL:End()
   ::oArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TInfPedTip

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

METHOD lGenerate() CLASS TInfPedTip

   local bValid   := {|| .t. }
   local cCodTip

   ::oDlg:Disable()

   ::oDbf:Zap()

  do case
      case ::oEstado:nAt == 1
         bValid   := {|| ::oPedCliT:nEstado == 1 }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oPedCliT:nEstado == 2 }
      case ::oEstado:nAt == 3
         bValid   := {|| ::oPedCliT:nEstado == 1 .OR. ::oPedCliT:nEstado == 2  }
      case ::oEstado:nAt == 4
         bValid   := {|| ::oPedCliT:nEstado == 3 }
      case ::oEstado:nAt == 5
         bValid   := {|| .t. }
   end case

   ::aHeader   := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                     {|| "Periodo : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Tipos   : " + ::cTipOrg           + " > " + ::cTipDes         },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:GoTop()

   WHILE !::oPedCliT:Eof()

      if Eval ( bValid )                                                         .AND.;
         ::oPedCliT:dFecPed >= ::dIniInf                                         .AND.;
         ::oPedCliT:dFecPed <= ::dFinInf                                         .AND.;
         lChkSer( ::oPedCliT:cSerPed, ::aSer )                                   .AND.;
         !( ::lExcCero .AND. nTotNPedCli( ::oPedCliL:cAlias ) == 0 )             .AND.;
         !( ::lExcMov )

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed

               cCodTip := oRetFld( ::oPedCliL:cRef, ::oArt , "cCodTip")

               if cCodTip            >= ::cTipOrg                                 .AND.;
                  cCodTip            <= ::cTipDes                                 .AND.;
                  ::oPedCliL:cRef    >= ::cArtOrg                                 .AND.;
                  ::oPedCliL:cRef    <= ::cArtDes

                  /*
                  Añadimos un nuevo registro
                  */

                  ::oDbf:Append()

                  ::AddCliente      ( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

                  ::oDbf:cCodTip    := cCodTip
                  ::oDbf:cNomTip    := oRetFld( cCodTip, ::oTipArt:oDbf, "cNomTip" )
                  ::oDbf:cCodArt    := ::oPedCliL:cRef
                  ::oDbf:cNomArt    := ::oPedCliL:cDetalle
                  ::oDbf:nNumCaj    := ::oPedCliL:nCanPed
                  ::oDbf:nUniDad    := ::oPedCliL:NUNICAJA
                  ::oDbf:nNumUni    := nTotNPedCli( ::oPedCliL )
                  ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:nIvaArt    := Round( ::oDbf:nImpArt * ::oPedCliL:nIva / 100, ::nDerOut )

                  ::oDbf:cDocMov    := lTrim( ::oPedCliL:CSERPED ) + "/" + lTrim ( Str( ::oPedCliL:NNUMPED ) ) + "/" + lTrim ( ::oPedCliL:CSUFPED )
                  ::oDbf:dFecMov    := ::oPedCliT:DFECPED

                  ::oDbf:Save()

               end if

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//