#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenXPed FROM TInfGCli

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
    
   DATA  oDbfCli     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenXPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

    

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenXPed

    
   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

    
   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::RentCreateFields()

   ::AddTmpIndex ( "CCODGRC", "CCODGRC + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + CLOTE" )

   ::AddGroup( {|| ::oDbf:cCodGrC }, {|| "Grupo clientes  : " + Rtrim( ::oDbf:cCodGrC ) + "-" + oRetFld( ::oDbf:cCodGrC, ::oGrpCli:oDbf) }, {||"Total grupo clientes..."} )
   ::AddGroup( {|| ::oDbf:cCodGrC + ::oDbf:cCodArt },    {|| "Art�culo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total art�culo..." } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRenXPed

   local cEstado := "Todos"

   if !::StdResource( "INFRENGRCB" )
      return .f.
   end if

   /*
   Montamos grupos de clientes
   */
   if !::oDefGrpCli ( 70, 71, 80, 81, 90 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
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

   ::bPreGenerate    := {|| ::NewGroupR( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenXPed

   local cExpHead    := ""
   local cExpLine    := ""
   local nTotUni
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nImpDtoAtp  := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Periodo       : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Grp. clientes : " + if( ::lGrpAll, "Todos", Rtrim( ::cGrpOrg ) + " > " + Rtrim( ::cGrpDes ) ) },;
                        {|| "Art�culos     : " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) ) },;
                        {|| "Estado        : " + ::aEstado[ ::oEstado:nAt ] } }

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

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   cExpLine          := ' !lTotLin .and. !lControl .and. !lKitChl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oPedCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if ( ::lGrpAll .or. ( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ) >= ::cGrpOrg .AND. cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ) <= ::cGrpDes ) ) .AND.;
         lChkSer( ::oPedCliT:cSerPed, ::aSer )

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
                  ::oDbf:cCodGrc    := cGruCli( ::oPedCliT:cCodCli, ::oDbfCli )
                  ::oDbf:cNomGrc    := oRetFld( cGruCli( ::oPedCliT:cCodCli, ::oDbfCli ), ::oGrpCli:oDbf)

                  ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

                  ::oDbf:nTotCaj    := ::oPedCliL:nCanEnt
                  ::oDbf:nTotUni    := nTotUni
                  ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nPesoKg" )
                  ::oDbf:nTotImp    := nTotImpUni
                  ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
                  ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nVolumen" )
                  ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
                  ::oDbf:nTotCos    := nTotCosUni
                  ::oDbf:nMargen    := nTotImpUni - nTotCosUni
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

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   ::oPedCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliT:cFile ) )
   ::oPedCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPedCliL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//