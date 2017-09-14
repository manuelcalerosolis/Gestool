#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenPed FROM TInfPArt

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 14, 0, {|| "@R #/#########/##" }, "Documento",         .t., "Documento",              12, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },                "Fecha",             .t., "Fecha",                  10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },                "Cód. cli.",         .t., "Cod. Cliente",            8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },                "Cliente",           .t., "Nom. Cliente",           30, .f. )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },            cNombreCajas(),      .f., cNombreCajas(),           12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },            cNombreUnidades(),   .t., cNombreUnidades(),        12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicImp },           "Tot. importe",      .t., "Tot. importe",           12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },            "Tot. peso",         .f., "Total peso",             12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },           "Pre. Kg.",          .f., "Precio kilo",            12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },            "Tot. volumen",      .f., "Total volumen",          12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },           "Pre. vol.",         .f., "Precio volumen",         12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicImp },           "Tot. costo",        .t., "Total costo",            12, .t. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },           "Dto. Atipico",      .f., "Importe dto. atipico",   12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },           "Margen",            .t., "Margen",                 12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },           "%Rent.",            .t., "Rentabilidad",           12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },           "Precio medio",      .f., "Precio medio",           12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicImp },           "Costo medio",       .t., "Costo medio",            12, .f. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::dIniInf := GetSysDate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenPed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

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

METHOD CloseFiles() CLASS TRenPed

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if

   ::oDbfArt  := nil
   ::oPedCliT := nil
   ::oPedCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRenPed

   local cEstado := "Todos"

   if !::StdResource( "INFRENARTC" )
      return .f.
   end if

   /*
   Monta los Clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   ::oDefExcInf( 204 )

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

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenPed

   local nTotUni     := 0
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nTotPes     := 0
   local nTotVol     := 0
   local nTotCaj     := 0
   local cExpHead    := ""
   local nImpDtoAtp  := 0

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                           {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oPedCliT:OrdSetFocus( "dFecPed" )

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

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

      if lChkSer( ::oPedCliT:cSerPed, ::aSer )

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0

         if ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

            while ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed == ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed

               if !( ::oPedCliL:lKitChl )                                                              .AND.;
                  !( ::oPedCliL:lTotLin )                                                              .AND.;
                  !( ::oPedCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ( nTotNPedCli( ::oPedCliL:cAlias ) == 0 ) )

                  nTotUni              += nTotNPedCli( ::oPedCliL:cAlias )
                  nTotImpUni           += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotPes              += nTotUni * oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol              += nTotUni * oRetFld( ::oPedCliL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj              += ::oPedCliL:nCanEnt
                  nImpDtoAtp           += nDtoAtpPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lCosAct .or. ::oPedCliL:nCosDiv == 0
                     nTotCosUni        += nRetPreCosto( ::oDbfArt:cAlias, ::oPedCliL:cRef ) * nTotNPedCli( ::oPedCliL:cAlias )
                  else
                     nTotCosUni        += ::oPedCliL:nCosDiv * nTotNPedCli( ::oPedCliL:cAlias )
                  end if

               end if

               ::oPedCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc    := ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed
            ::oDbf:dFecDoc    := ::oPedCliT:dFecPed
            ::oDbf:cCodCli    := ::oPedCliT:cCodCli
            ::oDbf:cNomCli    := ::oPedCliT:cNomCli
            ::oDbf:nTotCaj    := nTotCaj
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotPes    := nTotPes
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol    := nTotVol
            ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nImpDtoAtp
            ::oDbf:nDtoAtp    := nImpDtoAtp

            if nTotUni != 0 .and. ::oDbf:nTotCos != 0
               ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               ::oDbf:nPreMed := nTotImpUni / nTotUni
               ::oDbf:nCosMed := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab := 0
               ::oDbf:nPreMed := 0
               ::oDbf:nCosMed := 0
            end if

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oPedCliT:Skip()

   end while

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

  ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//