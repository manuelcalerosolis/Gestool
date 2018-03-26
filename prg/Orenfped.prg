#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS ORenFPed FROM TPrvFam

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oPedPrvT    AS OBJECT
   DATA  oPedPrvL    AS OBJECT
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

   ::AddTmpIndex( "cFamArt", "cFamArt + cCodArt" )

   ::AddGroup( {|| ::oDbf:cFamArt }, {|| "Familia  : " + Rtrim( ::oDbf:cFamArt ) + "-" + oRetFld( ::oDbf:cFamArt, ::oDbfFam ) }, {||"Total familia..."} )
   ::AddGroup( {|| ::oDbf:cFamArt + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo : " } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS ORenFPed

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) }
   BEGIN SEQUENCE

   DATABASE NEW ::oArt     PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oPedPrvT PATH ( cPatEmp() ) FILE "PEDPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVT.CDX"
   ::oPedPrvT:OrdSetFocus( "dFecPed" )

   DATABASE NEW ::oPedPrvL PATH ( cPatEmp() ) FILE "PEDPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDPROVL.CDX"

   DATABASE NEW ::oDbfPrv  PATH ( cPatEmp() ) FILE "PROVEE.DBF"  VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS ORenFPed

   ::oArt:End()
   ::oPedPrvT:End()
   ::oPedPrvL:End()
   ::oDbfFam:End()
   ::oDbfPrv:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS ORenFPed

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

METHOD lGenerate() CLASS ORenFPed

   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local lExcCero    := .f.

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Familia: " + AllTrim( ::cFamOrg )      + " > " + AllTrim (::cFamDes ) },;
                     {|| "Artículos: " + AllTrim( ::cArtOrg )      + " > " + AllTrim (::cArtDes ) } }

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedPrvT:Lastrec() )

   ::oPedPrvT:GoTop()

   ::oPedPrvT:Seek ( ::dIniInf , .t. )

   while ::oPedPrvT:dFecPed <= ::dFinInf .and. !::oPedPrvT:Eof()

      if lChkSer( ::oPedPrvT:cSerPed, ::aSer )

         if ::oPedPrvL:Seek( ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed )

            while ::oPedPrvL:cSerPed + Str( ::oPedPrvL:nNumPed ) + ::oPedPrvL:cSufPed == ::oPedPrvT:cSerPed + Str( ::oPedPrvT:nNumPed ) + ::oPedPrvT:cSufPed

               if cCodFam( ::oPedPrvL:cRef, ::oArt ) >= ::cFamOrg                  .AND.;
                  cCodFam( ::oPedPrvL:cRef, ::oArt ) <= ::cFamDes                  .AND.;
                  ::oPedPrvL:cRef >= ::cArtOrg                                     .AND.;
                  ::oPedPrvL:cRef <= ::cArtDes                                     .AND.;
                  !( ::oPedPrvL:lKitArt )                                          .AND.;
                  !( ::lExcCero .AND. ( nTotNPedPrv( ::oPedPrvL:cAlias ) == 0 ) )  .AND.;
                  !( ::lExcMov  .AND. ( nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

                  nTotUni              := nTotNPedPrv( ::oPedPrvL:cAlias )
                  nTotImpUni           := nImpLPedPrv( ::oPedPrvT:cAlias, ::oPedPrvL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lCosAct .or. ::oPedPrvL:nPreDiv == 0
                     nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oPedPrvL:cRef ) * nTotUni
                  else
                     nTotCosUni        := ::oPedPrvL:nPreDiv * nTotUni
                  end if

                  ::oDbf:Append()

                  ::oDbf:cCodArt    := ::oPedPrvL:cRef
                  ::oDbf:cFamArt    := cCodFam( ::oPedPrvL:cRef, ::oArt )
                  ::oDbf:cNomArt :=  RetArticulo( ::oPedPrvL:cRef, ::oArt )

                  ::AddProveedor( ::oPedPrvT:cCodPrv )

                  ::oDbf:nTotCaj    := ::oPedPrvL:nCanEnt
                  ::oDbf:nTotUni    := nTotUni
                  ::oDbf:nTotImp    := nTotImpUni
                  ::oDbf:nTotCos    := nTotCosUni
                  ::oDbf:nMargen    := nTotImpUni - nTotCosUni

                  if nTotUni != 0 .and. nTotCosUni != 0
                     ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
                     ::oDbf:nPreMed := nTotImpUni / nTotUni
                     ::oDbf:nCosMed := nTotCosUni / nTotUni
                  else
                     ::oDbf:nRentab := 0
                     ::oDbf:nPreMed := 0
                     ::oDbf:nCosMed := 0
                  end if

                  ::oDbf:cNumDoc    := ::oPedPrvL:cSerPed + "/" + Alltrim( Str( ::oPedPrvL:nNumPed ) ) + "/" + ::oPedPrvL:cSufPed

                  ::oDbf:Save()

               end if

               ::oPedPrvL:Skip()

            end while

         end if

      end if

      ::oMtrInf:AutoInc( ::oPedPrvT:OrdKeyNo() )

      ::oPedPrvT:Skip()

   end while

   ::oMtrInf:AutoInc( ::oPedPrvT:Lastrec() )

  ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//