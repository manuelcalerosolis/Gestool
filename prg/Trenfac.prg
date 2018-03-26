#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenFac FROM TInfPArt

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oEstado     AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendientes", "Cobradas", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },                "Tipo",              .f., "Tipo de documento",      12, .f. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },                "Documento",         .t., "Documento",              12, .f. )
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
   ::AddField( "nTotAge", "N", 16, 6, {|| ::cPicImp },           "Tot. agente",       .t., "Total comisión agente",  12, .t. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },           "Dto. atipico",      .f., "Importe dto. atipico",   12, .t. )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },           "Margen",            .t., "Margen",                 12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },           "%Rent.",            .t., "Rentabilidad",           12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },           "Precio medio",      .f., "Precio medio",           12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicImp },           "Costo medio",       .t., "Costo medio",            12, .f. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::dIniInf := GetSysDate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if

   ::oDbfArt  := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"

   if !::StdResource( "INFRENARTC" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
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

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nTotUni     := 0
   local nTotPes     := 0
   local nTotVol     := 0
   local nTotCaj     := 0
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nTotImpAge  := 0
   local nTotImpPnt  := 0
   local nImpDtoAtp  := 0
   local cExpHead    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                           {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Cliente  : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                           {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada.and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Damos valor al meter
   */

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            nTotUni     := 0
            nTotPes     := 0
            nTotVol     := 0
            nTotCaj     := 0
            nTotImpUni  := 0
            nTotImpAge  := 0
            nTotImpPnt  := 0
            nTotCosUni  := 0
            nImpDtoAtp  := 0

            while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and. !::oFacCliT:Eof()

               if !( ::oFacCliL:lKitChl )                                                              .and.;
                  !( ::oFacCliL:lTotLin )                                                              .and.;
                  !( ::oFacCliL:lControl )                                                             .and.;
                  !( ::lExcMov .and. ( nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) )

                  nTotUni              += nTotNFacCli( ::oFacCliL:cAlias )
                  nTotPes              += nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol              += nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj              += ::oFacCliL:nCanEnt
                  nTotImpUni           += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotImpAge           += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotImpPnt           += nPntLFacCli( ::oFacCliL:cAlias, ::nDerPnt )
                  nImpDtoAtp           += nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                  if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
                     nTotCosUni        += nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotNFacCli( ::oFacCliL:cAlias )
                  else
                     nTotCosUni        += ::oFacCliL:nCosDiv * nTotNFacCli( ::oFacCliL:cAlias )
                  end if

               end if

               ::oFacCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc    := ::oFacCliT:cSerie + AllTrim( Str( ::oFacCliT:nNumFac ) ) + ::oFacCliT:cSufFac
            ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
            ::oDbf:cCodCli    := ::oFacCliT:cCodCli
            ::oDbf:cNomCli    := ::oFacCliT:cNomCli
            ::oDbf:nTotCaj    := nTotCaj
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotPes    := nTotPes
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol    := nTotVol
            ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nTotAge    := nTotImpAge
            ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nImpDtoAtp - nTotImpAge
            ::oDbf:nDtoAtp    := nImpDtoAtp
            ::oDbf:cTipDoc    := "Fac. cliente"

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := nRentabilidad( nTotImpUni - nTotImpAge, nImpDtoAtp, nTotCosUni )
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

      ::oFacCliT:Skip()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   /*
   comenzamos con las rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada.and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      otherwise
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Damos valor al meter--------------------------------------------------------
   */

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            nTotUni     := 0
            nTotPes     := 0
            nTotVol     := 0
            nTotCaj     := 0
            nTotImpUni  := 0
            nTotCosUni  := 0
            nTotImpAge  := 0
            nTotImpPnt  := 0

            while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac .and. !::oFacRecT:Eof()

               if !( ::oFacRecL:lKitChl )                                                              .AND.;
                  !( ::oFacRecL:lTotLin )                                                              .AND.;
                  !( ::oFacRecL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ( nTotNFacRec( ::oFacRecL:cAlias ) == 0 ) )

                  nTotUni              += nTotNFacRec( ::oFacRecL:cAlias )
                  nTotPes              += nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol              += nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj              += ::oFacRecL:nCanEnt
                  nTotImpUni           += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                  nTotImpAge           += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                  nTotImpPnt           += nPntLFacRec( ::oFacRecL:cAlias, ::nDerPnt )

                  if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
                     nTotCosUni        += nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotNFacRec( ::oFacRecL:cAlias )
                  else
                     nTotCosUni        += ::oFacRecL:nCosDiv * nTotNFacRec( ::oFacRecL:cAlias )
                  end if

               end if

               ::oFacRecL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc    := ::oFacRecT:cSerie + AllTrim( Str( ::oFacRecT:nNumFac ) ) + ::oFacRecT:cSufFac
            ::oDbf:dFecDoc    := ::oFacRecT:dFecFac
            ::oDbf:cCodCli    := ::oFacRecT:cCodCli
            ::oDbf:cNomCli    := ::oFacRecT:cNomCli
            ::oDbf:nTotCaj    := nTotCaj
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotPes    := nTotPes
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol    := nTotVol
            ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nTotAge    := nTotImpAge
            ::oDbf:nMargen    := nTotImpUni - nTotCosUni - nImpDtoAtp - nTotImpAge
            ::oDbf:nDtoAtp    := nImpDtoAtp
            ::oDbf:cTipDoc    := "Fac. rectificativa"

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := nRentabilidad( nTotImpUni - nTotImpAge, nImpDtoAtp, nTotCosUni )
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

      ::oFacRecT:Skip()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//