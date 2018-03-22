#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenTik FROM TInfPArt

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
    

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 14, 0, {|| "@R #/##########/##" }, "Documento",         .t., "Documento",       14, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },                 "Fecha",             .t., "Fecha",           10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },                 "Cód. cli.",         .t., "Cod. Cliente",     8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },                 "Cliente",           .t., "Nom. Cliente",    30, .f. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },             cNombreUnidades(),   .t., cNombreUnidades(), 12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicImp },            "Tot. importe",      .t., "Tot. importe",    12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },             "Tot. peso",         .f., "Total peso",      12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },            "Pre. Kg.",          .f., "Precio kilo",     12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },             "Tot. volumen",      .f., "Total volumen",   12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },            "Pre. vol.",         .f., "Precio volumen",  12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicImp },            "Tot. costo",        .t., "Total costo",     12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },            "Margen",            .t., "Margen",          12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },            "%Rent.",            .t., "Rentabilidad",    12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },            "Precio medio",      .f., "Precio medio",    12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicImp },            "Costo medio",       .t., "Costo medio",     12, .f. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::dIniInf := GetSysDate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRenTik

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

    

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRenTik

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
    
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   ::oDbfArt  := nil
    
   ::oTikCliT := nil
   ::oTikCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TRenTik

   if !::StdResource( "INFRENARTCB" )
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

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TRenTik

   local nTotUni     := 0
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nTotPes     := 0
   local nTotVol     := 0
   local nTotCaj     := 0
   local lExcCero    := .f.
   local cExpHead    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                           {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } ,;
                           {|| "Cliente   : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*
   Damos valor al meter
   */

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik

               if !Empty( ::oTikCliL:cCbaTil )                                                         .AND.;
                  !( ::oTikCliL:lKitChl )                                                              .AND.;
                  !( ::oTikCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ::oTikCliL:nUntTil == 0 )                                         .AND.;
                  !( ::lExcCero .AND. nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 ) == 0  )

                  nTotUni              += ::oTikCliL:nUntTil
                  nTotImpUni           += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  nTotPes              += nTotUni * oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nPesoKg" )
                  nTotVol              += nTotUni / oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nVolumen" )

                  if ::lCosAct .or. ::oTikCliL:nCosDiv == 0
                     nTotCosUni        += ::oTikCliL:nCosDiv * nTotUni
                  else
                     nTotCosUni        += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
                  end if

               end if

               ::oTikCliL:Skip()

               if !Empty( ::oTikCliL:cComTil )                                                         .AND.;
                  !( ::oTikCliL:lKitChl )                                                              .AND.;
                  !( ::oTikCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ::oTikCliL:nUntTil == 0 )                                         .AND.;
                  !( ::lExcCero .AND. nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 ) == 0  )

                  nTotUni              += ::oTikCliL:nUntTil
                  nTotImpUni           += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  nTotPes              += nTotUni * oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nPesoKg" )
                  nTotVol              += nTotUni / oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nVolumen" )

                  if ::lCosAct .or. ::oTikCliL:nCosDiv == 0
                     nTotCosUni        += ::oTikCliL:nCosDiv * nTotUni
                  else
                     nTotCosUni        += nRetPreCosto( ::oDbfArt:cAlias, ::oTikCliL:cComTil ) * nTotUni
                  end if

               end if

               ::oTikCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc    := ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik
            ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
            ::oDbf:cCodCli    := ::oTikCliT:cCliTik
            ::oDbf:cNomCli    := ::oTikCliT:cNomTik
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotPes    := nTotPes
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol    := nTotVol
            ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nMargen    := ( nTotImpUni ) - ( ::oDbf:nTotCos )

            if nTotUni != 0 .and. ::oDbf:nTotCos != 0
               ::oDbf:nRentab := ( ( nTotImpUni / ::oDbf:nTotCos ) - 1 ) * 100
               ::oDbf:nPreMed := nTotImpUni / nTotUni
               ::oDbf:nCosMed := ::oDbf:nTotCos / nTotUni
            else
               ::oDbf:nRentab := 0
               ::oDbf:nPreMed := 0
               ::oDbf:nCosMed := 0
            end if

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oTikCliT:Skip()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//