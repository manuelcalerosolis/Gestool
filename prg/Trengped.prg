#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenGPed FROM TInfGrp

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oDbfFam     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcialmente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenGPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfFam PATH ( cPatEmp() )  FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenGPed

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if
   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   ::oDbfFam := nil
   ::oPedCliT := nil
   ::oPedCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::RentCreateFields()

   ::AddTmpIndex ( "CGRPFAM", "CGRPFAM + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + CLOTE" )

   ::AddGroup( {|| ::oDbf:cGrpFam }, {|| "Grupo familia  : " + Rtrim( ::oDbf:cGrpFam ) + "-" + oRetFld( ::oDbf:cGrpFam, ::oGruFam:oDbf ) }, {||"Total grupo de familia..."} )
   ::AddGroup( {|| ::oDbf:cGrpFam + ::oDbf:cCodArt }, {|| "Art�culo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) },  {||"Total art�culo..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRenGPed

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN10D" )
      return .f.
   end if

   /*
   Monta Grupos de Familias
   */
   if !::oDefGrFInf( 110, 120, 130, 140, 900 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   ::oDefExcInf( 204 )

   ::oDefResInf()

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenGPed

   local cExpHead := ""
   local cExpLine := ""
   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nImpDtoAtp

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                     {|| "Periodo: " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Gr. fam.  : " + if( ::lAllGrp, "Todos", AllTrim( ::cGruFamOrg ) + " > " + AllTrim (::cGruFamDes ) ) },;
                     {|| "Art�culos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) },;
                     {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   cExpHead          := "!lCancel "

   do case
      case ::oEstado:nAt == 1
         cExpHead    += ' .and. nEstado == 1'
      case ::oEstado:nAt == 2
         cExpHead    += ' .and. nEstado == 2'
      case ::oEstado:nAt == 3
         cExpHead    += ' .and. nEstado == 3'
   end case

   cExpHead          += ' .and. dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:AutoInc( ::oPedCliL:Recno() )

   cExpLine          := '!lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   if !::lAllGrp
      cExpLine       += ' .and. cGrpFam >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cGrpFam <= "' + Rtrim( ::cGruFamDes ) + '"'
   end if

   ::oPedCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed == ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed

               if !( ::lExcMov  .AND. ( nTotNPedCli( ::oPedCliL:cAlias ) == 0  ) )

                  /*
                  Calculamos las cajas en vendidas entre dos fechas
                  */

                  nTotUni              := nTotNPedCli( ::oPedCliL:cAlias )
                  nTotImpUni           := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                  nImpDtoAtp           := nDtoAtpPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lCosAct .or. ::oPedCliL:nCosDiv == 0
                     nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oPedCliL:cRef ) * nTotUni
                  else
                     nTotCosUni        := ::oPedCliL:nCosDiv * nTotUni
                  end if

                  ::oDbf:Append()

                  ::oDbf:cGrpFam    := cCodGruFam( ::oPedCliL:cRef, ::oDbfArt, ::oDbfFam )

                  ::oDbf:cCodArt    := ::oPedCliL:cRef
                  ::oDbf:cNomArt    := ::oPedCliL:cDetalle
                  ::oDbf:cCodPr1    := ::oPedCliL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oPedCliL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oPedCliL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oPedCliL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oPedCliL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oPedCliL:cCodPr1 + ::oPedCliL:cValPr1 )
                  ::oDbf:cValPr2    := ::oPedCliL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oPedCliL:cCodPr2 + ::oPedCliL:cValPr2 )
                  ::oDbf:cLote      := ::oPedCliL:cLote

                  ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

                  ::oDbf:nTotCaj    := ::oPedCliL:nCanEnt
                  ::oDbf:nTotUni    := nTotUni
                  ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nPesoKg" )
                  ::oDbf:nTotImp    := nTotImpUni
                  ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                  ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nVolumen" )
                  ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
                  ::oDbf:nTotCos    := nTotCosUni
                  ::oDbf:nMargen    := ( nTotImpUni ) - ( nTotCosUni )
                  ::oDbf:nDtoAtp    := nImpDtoAtp

                  if nTotUni != 0 .and. nTotCosUni != 0
                     ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
                     ::oDbf:nPreMed := nTotImpUni / nTotUni
                     ::oDbf:nCosMed := nTotCosUni / nTotUni
                  else
                     ::oDbf:nRentab := 0
                     ::oDbf:nPreMed := 0
                     ::oDbf:nCosMed := 0
                  end if

                  ::oDbf:cNumDoc    := ::oPedCliL:cSerPed + "/" + Alltrim( Str( ::oPedCliL:nNumPed ) ) + "/" + ::oPedCliL:cSufPed

                  ::oDbf:Save()

               end if

               ::oPedCliL:Skip()

            end while

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oPedCliT:Skip()

   end while

   ::oPedCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oPedCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//