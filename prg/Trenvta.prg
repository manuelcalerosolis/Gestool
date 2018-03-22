#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRenVta FROM TInfPArt

   DATA  lExcMov        AS LOGIC    INIT .f.
   DATA  lCosAct        AS LOGIC    INIT .f.
   DATA  oAlbCliT       AS OBJECT
   DATA  oAlbCliL       AS OBJECT
   DATA  oFacCliT       AS OBJECT
   DATA  oFacCliL       AS OBJECT
   DATA  oFacCliP       AS OBJECT
   DATA  oFacRecT       AS OBJECT
   DATA  oFacRecL       AS OBJECT
   DATA  oTikCliT       AS OBJECT
   DATA  oTikCliL       AS OBJECT
   DATA  oTikCliP       AS OBJECT
   DATA  oDbfArt        AS OBJECT
   DATA  oStock         AS OBJECT
   DATA  oAlbPrvL       AS OBJECT
   DATA  oFacPrvL       AS OBJECT
   DATA  oRctPrvL       AS OBJECT
   DATA  oIva           AS OBJECT
   DATA  oDivisas       AS OBJECT

   DATA  nTotVentas     AS NUMERIC   INIT 0
   DATA  nTotUnidades   AS NUMERIC   INIT 0
   DATA  nTotCosto      AS NUMERIC   INIT 0

   DATA  oEstado
   DATA  cEstado                    INIT  "Todos"
   DATA  aEstado        AS ARRAY    INIT  { "Cobrados", "Parcialmente", "Pendientes", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD ValidAlbaranCliente()

   METHOD ValidFacturaCliente()

   METHOD ValidRectifiactivaCliente()

   METHOD ValidTicketCliente()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc", "C", 14, 0, {|| "@R #/##########/##" },    "Documento",         .t., "Documento",                12, .f. )
   ::AddField( "cTipDoc", "C", 12, 0, {|| "@!" },                    "Tip. Doc.",         .t., "Tipo de Documento",         8, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },                    "Fecha",             .t., "Fecha",                    10, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },                    "Cód. cli.",         .t., "Cod. Cliente",              8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },                    "Cliente",           .t., "Nom. Cliente",             30, .f. )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },                cNombreCajas(),      .f., cNombreCajas(),             12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },                cNombreUnidades(),   .t., cNombreUnidades(),          12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicImp },               "Tot. importe",      .t., "Tot. importe",             12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },                "Tot. peso",         .f., "Total peso",               12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },               "Pre. kg.",          .f., "Precio kilo",              12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },                "Tot. volumen",      .f., "Total volumen",            12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },               "Pre. vol.",         .f., "Precio volumen",           12, .f. )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicImp },               "Tot. costo",        .t., "Total costo",              12, .t. )
   ::AddField( "nMargen", "N", 16, 6, {|| ::cPicOut },               "Margen",            .t., "Margen",                   12, .t. )
   ::AddField( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },               "Dto. Atipico",      .f., "Importe dto. atipico",     12, .t. )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },               "%Rent.",            .t., "Rentabilidad",             12, .f. )
   ::AddField( "nRentVta","N", 16, 6, {|| ::cPicOut },               "%Rent. vta.",       .t., "Rentabilidad sobre venta", 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },               "Precio medio",      .f., "Precio medio",             12, .f. )
   ::AddField( "nCosMed", "N", 16, 6, {|| ::cPicImp },               "Costo medio",       .t., "Costo medio",              12, .f. )
   ::AddField( "nTotCob", "N", 16, 6, {|| ::cPicImp },               "Tot. cobrado",      .t., "Total cobrado",            12, .t. )

   ::AddTmpIndex( "cNumDoc", "cNumDoc" )

   ::dIniInf := GetSysDate()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

    

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oTikCliP PATH ( cPatEmp() ) FILE "TIKEP.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oRctPrvL PATH ( cPatEmp() ) FILE "RctPrvL.DBF"  VIA ( cDriver() ) SHARED INDEX "RctPrvL.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDivisas PATH ( cPatDat() ) FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   ::oStock             := TStock():Create( cPatEmp() )
   if !::oStock:lOpenFiles()
      lOpen             := .f.
   end if

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
    
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   if !Empty( ::oTikCliP ) .and. ::oTikCliP:Used()
      ::oTikCliP:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oRctPrvL ) .and. ::oRctPrvL:Used()
      ::oRctPrvL:End()
   end if

   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   if !Empty( ::oDivisas ) .and. ::oDivisas:Used()
      ::oDivisas:End()
   end if

   if !Empty( ::oStock )
      ::oStock:End()
   end if

   ::oDbfArt   := nil
   ::oAlbCliT  := nil
   ::oAlbCliL  := nil
   ::oFacCliT  := nil
   ::oFacCliL  := nil
   ::oFacRecT  := nil
   ::oFacRecL  := nil
   ::oTikCliT  := nil
   ::oTikCliL  := nil
   ::oAlbPrvL  := nil
   ::oFacPrvL  := nil
   ::oRctPrvL  := nil
   ::oIva      := nil
   ::oDivisas  := nil
   ::oStock    := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "InfRenArtC" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

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
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nTotUni     := 0
   local nTotImpUni  := 0
   local nTotCosUni  := 0
   local nTotPes     := 0
   local nTotVol     := 0
   local nTotCaj     := 0
   local cExpHead    := ""
   local nImpDtoAtp  := 0

   ::nTotVentas      := 0
   ::nTotUnidades    := 0
   ::nTotCosto       := 0

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } ,;
                           {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) },;
                           {|| "Rnt.med.: " + Alltrim( Trans( ( ( ( ::nTotVentas / ::nTotCosto ) - 1 )* 100 ), ::cPicOut ) ) + "%" } }

   ::oDlg:Disable()

   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::oMtrInf:cText   := "Procesando albaranes"

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer ) .and. ::ValidAlbaranCliente()

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0
         nImpDtoAtp  := 0

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb

               if !( ::oAlbCliL:lKitChl )                                                              .AND.;
                  !( ::oAlbCliL:lTotLin )                                                              .AND.;
                  !( ::oAlbCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ( nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) )

                  nTotUni        += nTotNAlbCli( ::oAlbCliL:cAlias )
                  nTotImpUni     += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotPes        += nTotNAlbCli( ::oAlbCliL:cAlias ) * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol        += nTotNAlbCli( ::oAlbCliL:cAlias ) * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj        += ::oAlbCliL:nCanEnt
                  nImpDtoAtp     += nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotCosUni     += nCosLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                  /*
                  nTotCosUni     += ::oStock:nCostoMedio( ::oAlbCliL:cRef, ::oAlbCliL:cAlmLin, ::oAlbCliL:cCodPr1, ::oAlbCliL:cValPr1, ::oAlbCliL:cCodPr2, ::oAlbCliL:cValPr2 ) * nTotNAlbCli( ::oAlbCliL:cAlias )
                  */

               end if

               ::oAlbCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc       := ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb
            ::oDbf:cTipDoc       := "Albarán"
            ::oDbf:dFecDoc       := ::oAlbCliT:dFecAlb
            ::oDbf:cCodCli       := ::oAlbCliT:cCodCli
            ::oDbf:cNomCli       := ::oAlbCliT:cNomCli
            ::oDbf:nTotCaj       := nTotCaj
            ::oDbf:nTotUni       := nTotUni
            ::oDbf:nTotPes       := nTotPes
            ::oDbf:nTotImp       := nTotImpUni
            ::oDbf:nPreKgr       := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol       := nTotVol
            ::oDbf:nPreVol       := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos       := nTotCosUni
            ::oDbf:nMargen       := ( nTotImpUni ) - ( nTotCosUni )
            ::oDbf:nDtoAtp       := nImpDtoAtp
            ::oDbf:nTotCob       := ::oAlbCliT:nTotPag

            if nTotUni != 0 .and. ::oDbf:nTotCos != 0
               ::oDbf:nRentab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               ::oDbf:nPreMed    := nTotImpUni / nTotUni
               ::oDbf:nCosMed    := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab    := 0
               ::oDbf:nPreMed    := 0
               ::oDbf:nCosMed    := 0
            end if

            if nTotUni != 0 .and. ::oDbf:nTotImp != 0
               ::oDbf:nRentVta   := nRentabilidadVentas( nTotImpUni, nImpDtoAtp, nTotCosUni )
            else
               ::oDbf:nRentVta   := 0
            end if

            ::nTotVentas         += ::oDbf:nTotImp
            ::nTotUnidades       += ::oDbf:nTotUni
            ::nTotCosto          += ::oDbf:nTotCos

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oAlbCliT:Skip()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oMtrInf:cText   := "Procesando facturas"

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer ) .and. ::ValidFacturaCliente()

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0
         nImpDtoAtp  := 0

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac

               if !( ::oFacCliL:lKitChl )                                                              .AND.;
                  !( ::oFacCliL:lTotLin )                                                              .AND.;
                  !( ::oFacCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ( nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) )

                  nTotUni        += nTotNFacCli( ::oFacCliL:cAlias )
                  nTotImpUni     += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotPes        += nTotNFacCli( ::oFacCliL:cAlias ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol        += nTotNFacCli( ::oFacCliL:cAlias ) * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj        += ::oFacCliL:nCanEnt
                  nImpDtoAtp     += nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  nTotCosUni     += nCosLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                  //
                  // ::oStock:nCostoMedio( ::oFacCliL:cRef, ::oFacCliL:cAlmLin, ::oFacCliL:cCodPr1, ::oFacCliL:cValPr1, ::oFacCliL:cCodPr2, ::oFacCliL:cValPr2 ) * nTotNFacCli( ::oFacCliL:cAlias )
                  //

               end if

               ::oFacCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc       := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac
            ::oDbf:cTipDoc       := "Factura"
            ::oDbf:dFecDoc       := ::oFacCliT:dFecFac
            ::oDbf:cCodCli       := ::oFacCliT:cCodCli
            ::oDbf:cNomCli       := ::oFacCliT:cNomCli
            ::oDbf:nTotCaj       := nTotCaj
            ::oDbf:nTotUni       := nTotUni
            ::oDbf:nTotPes       := nTotPes
            ::oDbf:nTotImp       := nTotImpUni
            ::oDbf:nPreKgr       := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol       := nTotVol
            ::oDbf:nPreVol       := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos       := nTotCosUni
            ::oDbf:nMargen       := ( nTotImpUni ) - ( nTotCosUni )
            ::oDbf:nDtoAtp       := nImpDtoAtp
            ::oDbf:nTotCob       := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )

            if ( nTotUni != 0 .and. ::oDbf:nTotCos != 0 )
               ::oDbf:nRentab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               ::oDbf:nPreMed    := nTotImpUni / nTotUni
               ::oDbf:nCosMed    := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab    := 0
               ::oDbf:nPreMed    := 0
               ::oDbf:nCosMed    := 0
            end if

            if nTotUni != 0 .and. ::oDbf:nTotImp != 0
               ::oDbf:nRentVta   := nRentabilidadVentas( nTotImpUni, nImpDtoAtp, nTotCosUni )
            else
               ::oDbf:nRentVta   := 0
            end if

            ::nTotVentas         += ::oDbf:nTotImp
            ::nTotUnidades       += ::oDbf:nTotUni
            ::nTotCosto          += ::oDbf:nTotCos

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliT:Skip()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oMtrInf:cText   := "Procesando facturas rectificativas"

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer ) .and. ::ValidRectifiactivaCliente()

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0
         nImpDtoAtp  := 0

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac

               if !( ::oFacRecL:lKitChl )                                                              .AND.;
                  !( ::oFacRecL:lTotLin )                                                              .AND.;
                  !( ::oFacRecL:lControl )                                                             .AND.;
                  !( ::lExcMov .and. ( nTotNFacRec( ::oFacRecL:cAlias ) == 0 ) )

                  nTotUni        += nTotNFacRec( ::oFacRecL:cAlias )
                  nTotImpUni     += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                  nTotPes        += nTotNFacRec( ::oFacRecL:cAlias ) * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
                  nTotVol        += nTotNFacRec( ::oFacRecL:cAlias ) * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
                  nTotCaj        += ::oFacRecL:nCanEnt
                  nTotCosUni     += nCosLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

               end if

               ::oFacRecL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc       := ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac
            ::oDbf:cTipDoc       := "Fac. rec."
            ::oDbf:dFecDoc       := ::oFacRecT:dFecFac
            ::oDbf:cCodCli       := ::oFacRecT:cCodCli
            ::oDbf:cNomCli       := ::oFacRecT:cNomCli
            ::oDbf:nTotCaj       := nTotCaj
            ::oDbf:nTotUni       := nTotUni
            ::oDbf:nTotPes       := nTotPes
            ::oDbf:nTotImp       := nTotImpUni
            ::oDbf:nPreKgr       := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol       := nTotVol
            ::oDbf:nPreVol       := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos       := nTotCosUni
            ::oDbf:nMargen       := ( nTotImpUni ) - ( ::oDbf:nTotCos )
            ::oDbf:nDtoAtp       := nImpDtoAtp
            ::oDbf:nTotCob       := nPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacCliP:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )

            if nTotUni != 0 .and. ::oDbf:nTotCos != 0
               ::oDbf:nRentab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               ::oDbf:nPreMed    := nTotImpUni / nTotUni
               ::oDbf:nCosMed    := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab    := 0
               ::oDbf:nPreMed    := 0
               ::oDbf:nCosMed    := 0
            end if

            if nTotUni != 0 .and. ::oDbf:nTotImp != 0
               ::oDbf:nRentVta   := nRentabilidadVentas( nTotImpUni, nImpDtoAtp, nTotCosUni )
            else
               ::oDbf:nRentVta   := 0
            end if

            ::nTotVentas         += ::oDbf:nTotImp
            ::nTotUnidades       += ::oDbf:nTotUni
            ::nTotCosto          += ::oDbf:nTotCos

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oFacRecT:Skip()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oMtrInf:cText   := "Procesando tikets"

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

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer ) .and. ::ValidTicketCliente()

         nTotUni     := 0
         nTotImpUni  := 0
         nTotCosUni  := 0
         nTotPes     := 0
         nTotVol     := 0
         nTotCaj     := 0
         nImpDtoAtp  := 0

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik

               if !Empty( ::oTikCliL:cCbaTil )                                                         .AND.;
                  !( ::oTikCliL:lKitChl )                                                              .AND.;
                  !( ::oTikCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .AND. ::oTikCliL:nUntTil == 0 )

                  nTotUni        += ::oTikCliL:nUntTil
                  nTotImpUni     += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  nTotPes        += ::oTikCliL:nUntTil * oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nPesoKg" )
                  nTotVol        += ::oTikCliL:nUntTil / oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nVolumen" )
                  nTotCosUni     += nCosLTpv( ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )

               end if

               if !Empty( ::oTikCliL:cComTil )                                                         .AND.;
                  !( ::oTikCliL:lKitChl )                                                              .AND.;
                  !( ::oTikCliL:lControl )                                                             .AND.;
                  !( ::lExcMov .and. ::oTikCliL:nUntTil == 0 )

                  nTotUni        += ::oTikCliL:nUntTil
                  nTotImpUni     += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  nTotPes        += ::oTikCliL:nUntTil * oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nPesoKg" )
                  nTotVol        += ::oTikCliL:nUntTil / oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nVolumen" )
                  nTotCosUni     += nCosLTpv( ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )

               end if

               ::oTikCliL:Skip()

            end while

            ::oDbf:Append()

            ::oDbf:cNumDoc       := ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik
            ::oDbf:cTipDoc       := "Tiket"
            ::oDbf:dFecDoc       := ::oTikCliT:dFecTik
            ::oDbf:cCodCli       := ::oTikCliT:cCliTik
            ::oDbf:cNomCli       := ::oTikCliT:cNomTik
            ::oDbf:nTotCaj       := 1
            ::oDbf:nTotUni       := nTotUni
            ::oDbf:nTotPes       := nTotPes
            ::oDbf:nTotImp       := nTotImpUni
            ::oDbf:nPreKgr       := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
            ::oDbf:nTotVol       := nTotVol
            ::oDbf:nPreVol       := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
            ::oDbf:nTotCos       := nTotCosUni
            ::oDbf:nMargen       := nTotImpUni - nTotCosUni
            ::oDbf:nDtoAtp       := nImpDtoAtp
            ::oDbf:nTotCob       := nTotCobTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliP:cAlias, ::oDivisas:cAlias )

            if nTotUni != 0 .and. ::oDbf:nTotCos != 0
               ::oDbf:nRentab    := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
               ::oDbf:nPreMed    := nTotImpUni / nTotUni
               ::oDbf:nCosMed    := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab    := 0
               ::oDbf:nPreMed    := 0
               ::oDbf:nCosMed    := 0
            end if

            if nTotUni != 0 .and. ::oDbf:nTotImp != 0
               ::oDbf:nRentVta   := nRentabilidadVentas( nTotImpUni, nImpDtoAtp, nTotCosUni )
            else
               ::oDbf:nRentVta   := 0
            end if

            ::nTotVentas         += ::oDbf:nTotImp
            ::nTotUnidades       += ::oDbf:nTotUni
            ::nTotCosto          += ::oDbf:nTotCos

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

   METHOD ValidAlbaranCliente()

      do case
         case ::cEstado == "Todos"

            Return ( .t. )

         case ::cEstado == "Cobrados"

            Return ( ::oAlbCliT:nTotPag >= ::oAlbCliT:nTotAlb )

         case ::cEstado == "Parcialmente"

            Return ( ::oAlbCliT:nTotPag > 0 .and. ::oAlbCliT:nTotPag < ::oAlbCliT:nTotAlb )

         case ::cEstado == "Pendientes"

            Return ( ::oAlbCliT:nTotPag == 0 )

      end case

   RETURN ( Self )

   //---------------------------------------------------------------------------//

   METHOD ValidFacturaCliente()

      local nTotPag  := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )

      do case
         case ::cEstado == "Todos"

            Return ( .t. )

         case ::cEstado == "Cobrados"

            Return ( ::oFacCliT:lLiquidada )

         case ::cEstado == "Parcialmente"

            Return ( nTotPag > 0 .and. nTotPag < ::oFacCliT:nTotFac )

         case ::cEstado == "Pendientes"

            Return ( nTotPag == 0 )

      end case

   RETURN ( Self )

   //---------------------------------------------------------------------------//

   METHOD ValidRectifiactivaCliente()

      local nTotPag  := nPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecP:cAlias, ::oIva:cAlias, ::oDivisas:cAlias )

      do case
         case ::cEstado == "Todos"

            Return ( .t. )

         case ::cEstado == "Cobrados"

            Return ( ::oFacRecT:lLiquidada )

         case ::cEstado == "Parcialmente"

            Return ( nTotPag > 0 .and. nTotPag < ::oFacRecT:nTotFac )

         case ::cEstado == "Pendientes"

            Return ( nTotPag == 0 )

      end case

   RETURN ( Self )

   //---------------------------------------------------------------------------//

   METHOD ValidTicketCliente()

      local nTotPag  := nTotCobTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliP:cAlias, ::oDivisas:cAlias )

      do case
         case ::cEstado == "Todos"

            Return ( .t. )

         case ::cEstado == "Cobrados"

            Return ( nTotPag >= ::oTikCliT:nTotTik )

         case ::cEstado == "Parcialmente"

            Return ( nTotPag > 0 .and. nTotPag < ::oTikCliT:nTotTik )

         case ::cEstado == "Pendientes"

            Return ( nTotPag == 0 )

      end case

   RETURN ( Self )

   //---------------------------------------------------------------------------//
