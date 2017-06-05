#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfLot FROM TInfGen

   DATA  cLotIni
   DATA  cLotFin
   DATA  lExcMov     AS LOGIC    INIT  .f.
   DATA  lFactura    AS LOGIC    INIT  .t.
   DATA  lAlbaran    AS LOGIC    INIT  .t.
   DATA  lDepAge     AS LOGIC    INIT  .t.
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oDepAgeT    AS OBJECT
   DATA  oDepAgeL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   METHOD AppAlbaran()

   METHOD AppFactura()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfLot

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDepAgeT PATH ( cPatEmp() ) FILE "DEPAGET.DBF" VIA ( cDriver() ) SHARED INDEX "DEPAGET.CDX"

   DATABASE NEW ::oDepAgeL PATH ( cPatEmp() ) FILE "DEPAGEL.DBF" VIA ( cDriver() ) SHARED INDEX "DEPAGEL.CDX"
   ::oDepAgeL:OrdSetFocus( "CREF" )

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "CREF" )

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "CREF" )

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfLot

   if !Empty( ::oDepAgeT ) .and. ::oDepAgeT:Used()
      ::oDepAgeT:End()
   end if
   if !Empty( ::oDepAgeL ) .and. ::oDepAgeL:Used()
      ::oDepAgeL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oDepAgeT := nil
   ::oDepAgeL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS TInfLot

   ::AddField( "cNumLot", "C", 12, 0, {|| "@!" },           "Lote",              .f., "Lote",             9, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código artículo",         .t., "Código artículo", 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Artículo",          .t., "Artículo",        35, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },           "Família",           .f., "Família",          5, .f. )
   ::AddField( "cCodCli", "C", 18, 0, {|| "@!" },           "Cod. cli.",         .t., "Código cliente",  12, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },           "Cliente",           .t., "Cliente",         35, .f. )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),      .f., cNombreCajas(),    12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),   .t., cNombreUnidades(), 12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",    12, .t. )
   ::AddField( "cTipDoc", "C", 12, 0, {|| "@!" },           "Tip. doc.",         .t., "Tipo documento",  12, .f. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },           "Documento",         .t., "Documento",       12, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },           "Fecha",             .t., "Fecha",           12, .f. )

   ::AddTmpIndex( "cNumLot", "cNumLot + cCodArt + cNumDoc + dtos( dFecDoc )" )

   ::AddGroup( {|| ::oDbf:cNumLot }, {|| "Lote : " + ::oDbf:cNumLot }, {|| Space(1) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TInfLot

   if !::StdResource( "INF_GEN30" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefCliInf( 70, 71, 80, 81, , 920 )
      return .f.
   end if

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   REDEFINE GET ::cLotIni;
      ID       ( 110 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::cLotFin;
      ID       ( 120 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcCero ;
      ID       ( 200 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcMov ;
      ID       ( 210 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lDepAge ;
      ID       ( 220 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lAlbaran ;
      ID       ( 221 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lFactura ;
      ID       ( 222 );
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfLot

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
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

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AppAlbaran()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliL:Lastrec() )

   ::oAlbCliL:GoTop()

   while !::lBreak .and. !::oAlbCliL:Eof()

      if ( ::lAllArt .or. ( ::oAlbCliL:cRef >= ::cArtOrg .AND. ::oAlbCliL:cRef <= ::cArtDes ) )                      .AND.;
         if( !Empty( ::cLotIni ) .and. !Empty( ::cLotFin ), AllTrim( ::oAlbCliL:cLote ) >= AllTrim( ::cLotIni ) .and. AllTrim( ::oAlbCliL:cLote ) <= AllTrim( ::cLotFin ), .t. ) .AND.;
         ( ::lAllCli .or. ( cCliAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) >= ::cCliOrg .AND. cCliAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) <= ::cCliDes ) ) .AND.;
         dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) >= ::dIniInf  .AND.;
         dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT ) <= ::dFinInf  .AND.;
         lChkSer( ::oAlbCliL:cSerAlb, ::aSer )                                                                       .AND.;
         !( ::oAlbCliL:lKitChl )                                                                                     .AND.;
         !( ::oAlbCliL:lTotLin )                                                                                     .AND.;
         !( ::oAlbCliL:lControl )                                                                                    .AND.;
         !( ::lExcCero .AND. ( nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) )                                             .AND.;
         !( ::lExcMov  .AND. ( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )   .AND.;
         ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         ::oDbf:Append()

         ::oDbf:cNumLot    := ::oAlbCliL:cLote
         ::oDbf:cCodArt    := ::oAlbCliL:cRef
         ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
         ::oDbf:cNomCli    := ::oAlbCliT:cNomCli
         ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
         ::oDbf:nTotUni    := nTotNAlbCli( ::oAlbCliL:cAlias )
         ::oDbf:nTotImp    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
         ::oDbf:cTipDoc    := "Alb. Cli."
         ::oDbf:cNumDoc    := StrTran( ::oAlbCliL:cSerAlb + "/" + Str( ::oAlbCliL:nNumAlb ) + "/" + ::oAlbCliL:cSufAlb, Space( 1 ), "" )

         if ::oDbfArt:Seek( ::oAlbCliL:cRef )
            ::oDbf:cNomArt := ::oDbfArt:Nombre
            ::oDbf:cCodFam := ::oDbfArt:Familia
         end if

         ::oDbf:dFecDoc    := dFecAlbCli( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb, ::oAlbCliT )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oAlbCliL:OrdKeyNo() )

      ::oAlbCliL:Skip()

   end while

   ::oMtrInf:AutoInc( ::oAlbCliL:LastRec() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppFactura()

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliL:Lastrec() )

   ::oFacCliL:GoTop()

   while !::lBreak .and. !::oFacCliL:Eof()

      if ( ::lAllArt .or. ( ::oFacCliL:cRef >= ::cArtOrg .AND. ::oFacCliL:cRef <= ::cArtDes ) )                      .AND.;
         if( !Empty( ::cLotIni ) .and. !Empty( ::cLotFin ), AllTRim( ::oFacCliL:cLote ) >= AllTrim( ::cLotIni ) .and. AllTrim( ::oFacCliL:cLote ) <= AllTrim( ::cLotFin ), .t. ) .AND.;
         dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT ) >= ::dIniInf   .AND.;
         dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT ) <= ::dFinInf   .AND.;
         ( ::lAllCli .or. ( cCliFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT ) >= ::cCliOrg .AND. cCliFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT ) <= ::cCliDes ) ) .AND.;
         lChkSer( ::oFacCliL:cSerie, ::aSer )                                                                        .AND.;
         !( ::oFacCliL:lKitChl )                                                                                     .AND.;
         !( ::oFacCliL:lTotLin )                                                                                     .AND.;
         !( ::oFacCliL:lControl )                                                                                    .AND.;
         !( ::lExcCero .AND. ( nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) )                                             .AND.;
         !( ::lExcMov  .AND. ( nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut ) == 0  ) )   .AND.;
         ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

         /*
         Calculamos las cajas en vendidas entre dos fechas
         */

         ::oDbf:Append()

         ::oDbf:cNumLot    := ::oFacCliL:cLote
         ::oDbf:cCodArt    := ::oFacCliL:cRef
         ::oDbf:cCodCli    := ::oFacCliT:cCodCli
         ::oDbf:cNomCli    := ::oFacCliT:cNomCli
         ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
         ::oDbf:nTotUni    := nTotNFacCli( ::oFacCliL:cAlias )
         ::oDbf:nTotImp    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
         ::oDbf:cTipDoc    := "Fac. Cli."
         ::oDbf:cNumDoc    := StrTran( ::oFacCliL:cSerie + "/" + Str( ::oFacCliL:nNumFac ) + "/" + ::oFacCliL:cSufFac, Space( 1 ), "" )
         ::oDbf:dFecDoc    := dFecFacCli( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac, ::oFacCliT )

         if ::oDbfArt:Seek( ::oFacCliL:cRef )
            ::oDbf:cNomArt := ::oDbfArt:Nombre
            ::oDbf:cCodFam := ::oDbfArt:Familia
         end if

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliL:Skip()

   end while

   ::oMtrInf:AutoInc( ::oFacCliL:LastRec() )

RETURN ( Self )

//---------------------------------------------------------------------------//