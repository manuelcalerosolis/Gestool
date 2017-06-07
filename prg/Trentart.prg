#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfRentArt FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lFactura    AS LOGIC    INIT .t.
   DATA  lAlbaran    AS LOGIC    INIT .t.
   DATA  lTiket      AS LOGIC    INIT .t.
   DATA  lCosAct     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oArt        AS OBJECT
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

METHOD OpenFiles() CLASS TInfRentArt

   /*
   Ficheros necesarios
   */

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "CREF" )

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"
   ::oTikCliL:OrdSetFocus( "CREF" )

   DATABASE NEW ::oArt     PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

    

   DATABASE NEW ::oFamilia PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfRentArt

   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oArt:End()
   ::oFamilia:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfRentArt

   ::AddField( "CCODART", "C", 18, 0, {|| "@!" },           "Código artículo",         .t., "Codigo artículo", 14, .f. )
   ::AddField( "CNOMART", "C",100, 0, {|| "@!" },           "Descripción",       .t., "Descripción",     35, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },           "Família",           .f., "Família",          5, .f. )
   ::AddField( "NTOTCAJ", "N", 16, 6, {|| MasUnd() },       "Cajas",             .f., "Cajas",           12, .t. )
   ::AddField( "NTOTUNI", "N", 16, 6, {|| MasUnd() },       "Unds.",             .t., "Unidades",        12, .t. )
   ::AddField( "NTOTIMP", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",    12, .t. )
   ::AddField( "NTOTCOS", "N", 16, 6, {|| ::cPicOut },      "Tot. costo",        .t., "Total costo",     12, .t. )
   ::AddField( "NMARGEN", "N", 16, 6, {|| ::cPicOut },      "Margen",            .t., "Margen",          12, .t. )
   ::AddField( "NRENTAB", "N", 16, 6, {|| ::cPicOut },      "%Rent.",            .t., "Rentabilidad",    12, .f. )
   ::AddField( "NPREMED", "N", 16, 6, {|| ::cPicImp },      "Precio medio",      .f., "Precio medio",    12, .f. )
   ::AddField( "NCOSMED", "N", 16, 6, {|| ::cPicOut },      "Costo medio",       .t., "Costo medio",     12, .f. )
   ::AddField( "CTIPDOC", "C", 12, 0, {|| "@!" },           "Tip. doc.",         .t., "Tipo documento",  12, .f. )
   ::AddField( "CNUMDOC", "C", 14, 0, {|| "@!" },           "Documento",         .t., "Documento",       12, .f. )

   ::AddTmpIndex( "CCODART", "CCODART" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + oRetFld( ::oDbf:cCodArt, ::oDbfArt ) }, {||""} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfRentArt

   local cEstado := "Todas"

   if !::StdResource( "INF_GEN10G" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 70, 80, 90, 100 )

   ::oDefExcInf( 204 )

   REDEFINE CHECKBOX ::lNoGroup ;
      ID       201;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 203 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lCosAct ;
      ID       ( 205 );
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

METHOD lGenerate() CLASS TInfRentArt

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

METHOD AppAlbaran() CLASS TInfRentArt

   local nTotUni
   local nTotImpUni
   local nTotCosUni

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliL:Lastrec() )

   ::oAlbCliL:GoTop()

   while !::oAlbCliL:Eof()

      if ::oAlbCliL:cRef >= ::cArtOrg                                                                                .AND.;
         ::oAlbCliL:cRef <= ::cArtDes                                                                                .AND.;
         dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) >= ::dIniInf  .AND.;
         dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) <= ::dFinInf  .AND.;
         !lFacAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT )              .AND.;
         lChkSer( ::oAlbCliL:cSerAlb, ::aSer )                                                                       .AND.;
         !( ::oAlbCliL:lKitChl )                                                                                     .AND.;
         !( ::lExcCero .AND. ( nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) )                                             .AND.;
         !( ::lExcMov  .AND. ( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
         nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

         if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
            nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
         else
            nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
         end if

         if !::oDbf:Seek( ::oAlbCliL:cRef ) .or. !::lNoGroup

            ::oDbf:Append()

            ::oDbf:cCodArt    := ::oAlbCliL:cRef

            if ::oDbfArt:Seek( ::oAlbCliL:cRef )
               ::oDbf:cNomArt := ::oDbfArt:Nombre
               ::oDbf:cCodFam := ::oDbfArt:Familia
            end if

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

            ::oDbf:cNumDoc    := ::oAlbCliL:cSerAlb + "/" + Alltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb
            ::oDbf:cTipDoc    := "Alb. Cli."

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

            ::oDbf:cNumDoc    := ""
            ::oDbf:cTipDoc    := ""

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc( ::oAlbCliL:OrdKeyNo() )

      ::oAlbCliL:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppFactura() CLASS TInfRentArt

   local bValid
   local nTotUni
   local nTotImpUni
   local nTotCosUni

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oFacCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::oMtrInf:SetTotal( ::oFacCliL:Lastrec() )

   ::oFacCliL:GoTop()

   WHILE !::oFacCliL:Eof()

      IF ::oFacCliL:cRef >= ::cArtOrg                                                                                .AND.;
         ::oFacCliL:cRef <= ::cArtDes                                                                                .AND.;
         dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT ) >= ::dIniInf   .AND.;
         dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT ) <= ::dFinInf   .AND.;
         Eval( bValid )                                                                                              .AND.;
         lChkSer( ::oFacCliL:cSerie, ::aSer )                                                                        .AND.;
         !( ::oFacCliL:lKitChl )                                                                                     .AND.;
         !( ::lExcCero .AND. ( nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) )                                             .AND. ;
         !( ::lExcMov  .AND. ( nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
         nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

         if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
            nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oFacCliL:cRef ) * nTotUni
         else
            nTotCosUni        := ::oFacCliL:nCosDiv * nTotUni
         end if

         if !::oDbf:Seek( ::oFacCliL:cRef ) .or. !::lNoGroup

            ::oDbf:Append()

            ::oDbf:cCodArt    := ::oFacCliL:cRef

            if ::oDbfArt:Seek( ::oFacCliL:cRef )
               ::oDbf:cNomArt := ::oDbfArt:Nombre
               ::oDbf:cCodFam := ::oDbfArt:Familia
            end if

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

            ::oDbf:cNumDoc    := ::oFacCliL:cSerie + "/" + Alltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac
            ::oDbf:cTipDoc    := "Fac. Cli."

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

            ::oDbf:cNumDoc    := ""
            ::oDbf:cTipDoc    := ""

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliL:Skip()

   end while

   ::oMtrInf:AutoInc()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppTiket() CLASS TInfRentArt

   local bValid
   local nTotUni
   local nTotCosUni
   local nTotImpUni

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

      ::oMtrInf:SetTotal( ::oTikCliL:Lastrec() )

      IF ::oTikCliL:cCbaTil >= ::cArtOrg                                                                             .AND.;
         ::oTikCliL:cCbaTil <= ::cArtDes                                                                             .AND.;
         dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) >= ::dIniInf            .AND.;
         dFecTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) <= ::dFinInf            .AND.;
         cTipTik( ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil, ::oTikCliT ) == "1"                  .AND.;
         lChkSer( ::oTikCliL:cSerTil, ::aSer )                                                                       .AND.;
         !( ::oTikCliL:lKitChl )                                                                                     .AND.;
         !( ::lExcCero .AND. ( ::oTikCliL:nUntTil == 0 ) )                                                           .AND.;
         !( ::lExcMov  .AND. ( nImpLTpv( ::oTikCliT, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )

         nTotUni              := ::oTikCliL:nUntTil
         nTotImpUni           := nTotLTpv( ::oTikCliL:cAlias, ::nDecOut, ::nDerOut )

         if ::lCosAct .or. ::oTikCliL:nCosDiv != 0
            nTotCosUni        := nRetPreCosto( ::oArt:cAlias, ::oTikCliL:cCbaTil ) * nTotUni
         else
            nTotCosUni        := ::oTikCliL:nCosDiv * nTotUni
         end if

         if !::oDbf:Seek( ::oTikCliL:cCbaTil ) .or. !::lNoGroup

            ::oDbf:Append()

            ::oDbf:cCodArt    := ::oTikCliL:cCbaTil

            if ::oDbfArt:Seek( ::oTikCliL:cCbaTil )
               ::oDbf:cNomArt := ::oDbfArt:Nombre
               ::oDbf:cCodFam := ::oDbfArt:Familia
            end if

            //::oDbf:nTotCaj    := ::oTikCliL:nCanEnt
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

            ::oDbf:cNumDoc    := ::oTikCliL:cSerTil + "/" + Alltrim( ::oTikCliL:cNumTil ) + "/" +  ::oTikCliL:cSufTil
            ::oDbf:cTipDoc    := "Tik. Cli."

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

            ::oDbf:cNumDoc    := ""
            ::oDbf:cTipDoc    := ""

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc( ::oTikCliL:OrdKeyNo() )

      ::oTikCliL:Skip()

   end while

   ::oMtrInf:AutoInc( ::oTikCliL:OrdKeyNo() )

RETURN ( Self )

//---------------------------------------------------------------------------//