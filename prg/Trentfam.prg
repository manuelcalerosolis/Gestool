#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfRenFam FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lFactura    AS LOGIC    INIT .t.
   DATA  lAlbaran    AS LOGIC    INIT .t.
   DATA  lTiket      AS LOGIC    INIT .t.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oArt        AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  oFamilia    AS OBJECT
    
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   METHOD AppAlbaran()

   METHOD AppFactura()

   METHOD AppTiket()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfRenFam

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "CREF" )

   ::oFacCliP := TDataCenter():oFacCliP()

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oArt     PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   //::oArt := DbfServer("ARTICULO.DBF"):NewOpen("ARTICULO.DBF",,cDriver() ,,(cPatEmp()),.F.,.T.,.F.,.F. ) ; ::oArt:AddBag("ARTICULO.CDX" ) ; ::oArt:AddBag() ; ::oArt:AutoIndex()

   DATABASE NEW ::oIva     PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   //::oIva := DbfServer("TIVA.DBF",):NewOpen("TIVA.DBF",,cDriver() ,,(cPatDat() ),.F.,.T.,.F.,.F. ) ; ::oIva:AddBag("TIVA.CDX" ) ; ::oIva:AddBag() ; ::oIva:AutoIndex()

    

   DATABASE NEW ::oFamilia PATH ( cPatEmp() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfRenFam

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oFacCliP:End()
   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oArt:End()
   ::oIva:End()
   ::oFamilia:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfRenFam

   ::AddField( "CCODFAM", "C", 16, 0, {|| "@!" },           "Cod.",              .t., "Código família",   8, .f. )
   ::AddField( "CNOMFAM", "C", 40, 0, {|| "@!" },           "Família",           .t., "Família",         25, .f. )
   ::AddField( "NTOTCAJ", "N", 16, 6, {|| MasUnd() },       "Cajas",             .f., "Cajas",           12, .t. )
   ::AddField( "NTOTUNI", "N", 16, 6, {|| MasUnd() },       "Unds.",             .t., "Unidades",        12, .t. )
   ::AddField( "NTOTIMP", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",    12, .t. )
   ::AddField( "NTOTCOS", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",     12, .t. )
   ::AddField( "NMARGEN", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",          12, .t. )
   ::AddField( "NRENTAB", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",    12, .f. )
   ::AddField( "NPREMED", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",    12, .f. )
   ::AddField( "NCOSMED", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",     12, .f. )

   ::AddTmpIndex( "CCODFAM", "CCODFAM" )

   //::AddGroup( {|| ::oDbf:cCodArt }, {|| "Família : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {||"Total familia..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfRenFam

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN10C" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 110, 120, 130, 140 )

   ::oDefExcInf( 204 )

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lAlbaran ;
      ID       219;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lFactura ;
      ID       220;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      WHEN     ::lFactura ;
      ITEMS    ::aEstado;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lTiket ;
      ID       221;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfRenFam

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Nos movemos por las cabeceras de los albaranes a clientes-------------------
	*/

   if ::lAlbaran
      ::AppAlbaran()
   end if

	/*
   Nos movemos por las facturas a clientes
	*/

   if ::lFactura
      ::AppFactura()
   end if

   /*
   Nos movemos por los tikets
   */

   if ::lTiket
      ::AppTiket()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AppAlbaran() CLASS TInfRenFam

   local cCodFam
   local nTotUni
   local nTotImpUni
   local nTotCosUni

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliL:Lastrec() )

   ::oAlbCliL:GoTop()

   while !::oAlbCliL:Eof()

      cCodFam  := cCodFam( ::oAlbCliL:cRef, ::oArt )

      if cCodFam >= ::cFamOrg                                                                                        .AND.;
         cCodFam <= ::cFamDes                                                                                        .AND.;
         dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) >= ::dIniInf  .AND.;
         dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) <= ::dFinInf  .AND.;
         !lFacAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT )              .AND.;
         lChkSer( ::oAlbCliL:cSerAlb, ::aSer )                                                                       .AND.;
         !( ::oAlbCliL:lKitChl )                                                                                        .AND.;
         !( ::lExcCero .AND. ( nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) )                                             .AND.;
         !( ::lExcMov  .AND. ( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
         nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

         if ::oAlbCliL:nCosDiv != 0
            nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
         else
            nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
         end if

         if !::oDbf:Seek( cCodFam )

            ::oDbf:Append()

            ::oDbf:cCodFam    := cCodFam
            ::oDbf:cNomFam    := cNomFam( cCodFam, ::oDbfFam )

            ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nMargen    := ( nTotImpUni ) - ( nTotCosUni )

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
               ::oDbf:nPreMed := nTotImpUni / nTotUni
               ::oDbf:nCosMed := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab := 0
               ::oDbf:nPreMed := 0
               ::oDbf:nCosMed := 0
            end if

            ::oDbf:Save()

         else

            ::oDbf:Load()

            ::oDbf:nTotCaj    += ::oAlbCliL:nCanEnt
            ::oDbf:nTotUni    += nTotUni
            ::oDbf:nTotImp    += nTotImpUni
            ::oDbf:nTotCos    += nTotCosUni
            ::oDbf:nMargen    += ( nTotImpUni ) - ( nTotCosUni )

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := ( ( ::oDbf:nTotImp / ::oDbf:nTotCos ) - 1 ) * 100
               ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
               ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
            end if

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc( ::oAlbCliL:OrdKeyNo() )

      ::oAlbCliL:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppFactura() CLASS TInfRenFam

   local cCodFam
   local dFacCli
   local nPagFac
   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local bValid

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| nPagFac == 2 }
      case ::oEstado:nAt == 2
         bValid   := {|| nPagFac == 1 }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::oMtrInf:SetTotal( ::oFacCliL:Lastrec() )

   ::oFacCliL:GoTop()

   WHILE !::oFacCliL:Eof()

      cCodFam  := cCodFam( ::oFacCliL:cRef, ::oArt )
      dFacCli  := dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT )
      nPagFac  := nChkPagFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias )

      IF cCodFam >= ::cFamOrg                                                                                        .AND.;
         cCodFam <= ::cFamDes                                                                                        .AND.;
         dFacCli >= ::dIniInf                                                                                        .AND.;
         dFacCli <= ::dFinInf                                                                                        .AND.;
         lChkSer( ::oFacCliL:cSerie, ::aSer )                                                                        .AND.;
         Eval( bValid )                                                                                              .AND.;
         !( ::oFacCliL:lKitChl )                                                                                     .AND.;
         !( ::lExcCero .AND. ( nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) )                                             .AND. ;
         !( ::lExcMov  .AND. ( nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
         nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
         nTotCosUni           := ::oFacCliL:nCosDiv * nTotUni

         if !::oDbf:Seek( cCodFam )

            ::oDbf:Append()

            ::oDbf:cCodFam    := cCodFam
            ::oDbf:cNomFam    := cNomFam( cCodFam, ::oDbfFam )

            ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nMargen    := ( nTotImpUni ) - ( nTotCosUni )

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
               ::oDbf:nPreMed := nTotImpUni / nTotUni
               ::oDbf:nCosMed := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab := 0
               ::oDbf:nPreMed := 0
               ::oDbf:nCosMed := 0
            end if

            ::oDbf:Save()

         else

            ::oDbf:Load()

            ::oDbf:nTotCaj    += ::oFacCliL:nCanEnt
            ::oDbf:nTotUni    += nTotUni
            ::oDbf:nTotImp    += nTotImpUni
            ::oDbf:nTotCos    += nTotCosUni
            ::oDbf:nMargen    += ( nTotImpUni ) - ( nTotCosUni )

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := ( ( ::oDbf:nTotImp / ::oDbf:nTotCos ) - 1 ) * 100
               ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
               ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
            end if

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliL:Skip()

   end while

   ::oMtrInf:AutoInc()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppTiket() CLASS TInfRenFam

   local bValid
   local cCodFam
   local nTotUni
   local nTotImpUni
   local nTotCosUni

   do case
      case ::oEstado:nAt == 1
         bValid      := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid      := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid      := {|| .t. }
   end case

   ::oTikCliL:GoTop()

   WHILE !::oTikCliL:Eof()

      cCodFam                 := cCodFam( ::oTikCliL:cCbaTil, ::oArt )

      ::oMtrInf:SetTotal( ::oTikCliL:Lastrec() )

      IF cCodFam >= ::cFamOrg                                                                                        .AND.;
         cCodFam <= ::cFamDes                                                                                        .AND.;
         dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) >= ::dIniInf            .AND.;
         dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) <= ::dFinInf            .AND.;
         cTipTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) == "1"                  .AND.;
         lChkSer( ::oTikCliL:cSerTil, ::aSer )                                                                       .AND.;
         !( ::oTikCliL:lKitChl )                                                                                     .AND.;
         !( ::lExcCero .AND. ( ::oTikCliL:nUntTil == 0 ) )                                                           .AND.;
         !( ::lExcMov  .AND. ( nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

         nTotUni              := ::oTikCliL:nUntTil
         nTotImpUni           := nTotLTpv( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut )

         if ::oTikCliL:nCosDiv != 0
            nTotCosUni        := ::oTikCliL:nCosDiv * nTotUni
         else
            nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
         end if

         if !::oDbf:Seek( cCodFam )

            ::oDbf:Append()

            ::oDbf:cCodFam    := cCodFam
            ::oDbf:cNomFam    := cNomFam( cCodFam, ::oDbfFam )

            ::oDbf:nTotUni    := nTotUni
            ::oDbf:nTotImp    := nTotImpUni
            ::oDbf:nTotCos    := nTotCosUni
            ::oDbf:nMargen    := ( nTotImpUni ) - ( nTotCosUni )

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := ( ( nTotImpUni / nTotCosUni ) - 1 ) * 100
               ::oDbf:nPreMed := nTotImpUni / nTotUni
               ::oDbf:nCosMed := nTotCosUni / nTotUni
            else
               ::oDbf:nRentab := 0
               ::oDbf:nPreMed := 0
               ::oDbf:nCosMed := 0
            end if

            ::oDbf:Save()

         else

            ::oDbf:Load()

            //::oDbf:nTotCaj    += ::oTikCliL:nCanEnt
            ::oDbf:nTotUni    += nTotUni
            ::oDbf:nTotImp    += nTotImpUni
            ::oDbf:nTotCos    += nTotCosUni
            ::oDbf:nMargen    += ( nTotImpUni ) - ( nTotCosUni )

            if nTotUni != 0 .and. nTotCosUni != 0
               ::oDbf:nRentab := ( ( ::oDbf:nTotImp / ::oDbf:nTotCos ) - 1 ) * 100
               ::oDbf:nPreMed := ::oDbf:nTotImp / ::oDbf:nTotUni
               ::oDbf:nCosMed := ::oDbf:nTotCos / ::oDbf:nTotUni
            end if

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc( ::oTikCliL:OrdKeyNo() )

      ::oTikCliL:Skip()

   end while

   ::oMtrInf:AutoInc( ::oTikCliL:OrdKeyNo() )

RETURN ( Self )

//---------------------------------------------------------------------------//