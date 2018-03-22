#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OInfLot FROM TInfGen

   DATA  cLotIni
   DATA  cLotFin
   DATA  lExcMov     AS LOGIC       INIT  .f.
   DATA  lFactura    AS LOGIC       INIT  .t.
   DATA  lAlbaran    AS LOGIC       INIT  .t.
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS OInfLot

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS OInfLot

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oAlbPrvT := nil
   ::oAlbPrvL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create() CLASS OInfLot

   ::AddField( "cLote",   "C", 14, 0, {|| "@!" },           "Lote",              .f., "Lote",             12, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Código artículo",         .t., "Código artículo",  14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Artículo",          .t., "Artículo",         35, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },           "Família",           .f., "Família",           5, .f. )
   ::AddField( "cCodPrv", "C", 18, 0, {|| "@!" },           "Cod. Prv.",         .t., "Código Proveedor", 12, .f. )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },           "Proveedor",         .t., "Proveedor",        35, .f. )
   ::AddField( "nTotCaj", "N", 16, 6, {|| MasUnd() },       cNombreCajas(),      .f., cNombreCajas(),     12, .t. )
   ::AddField( "nTotUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),   .t., cNombreUnidades(),  12, .t. )
   ::AddField( "nTotImp", "N", 16, 6, {|| ::cPicOut },      "Tot. importe",      .t., "Tot. importe",     12, .t. )
   ::AddField( "cTipDoc", "C", 12, 0, {|| "@!" },           "Tip. doc.",         .t., "Tipo documento",   12, .f. )
   ::AddField( "cNumDoc", "C", 14, 0, {|| "@!" },           "Documento",         .t., "Documento",        15, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "@!" },           "Fecha",             .t., "Fecha",            12, .f. )

   ::AddTmpIndex( "cLote", "cLote + cCodArt" )

   ::AddGroup( {|| ::oDbf:cLote }, {|| "Lote : " + ::oDbf:cLote }, {|| Space(1) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS OInfLot

   if !::StdResource( "INF_GEN30P" )
      return .f.
   end if

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   if !::oDefPrvInf( 70, 71, 80, 81, 920 )
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

   ::oDefExcInf( 200 )

   ::oDefExcImp( 210 )

   REDEFINE CHECKBOX ::lAlbaran ;
      ID       ( 221 );
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lFactura ;
      ID       ( 222 );
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*Esta funcion crea la base de datos para generar posteriormente el informe*/

METHOD lGenerate() CLASS OInfLot

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todas", AllTrim( ::cPrvOrg ) + " > " + AllTrim( ::cPrvDes ) ) },;
                     {|| "Artículo  : " + if( ::lAllArt, "Todas", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                     {|| "Lotes     : " + AllTrim( ::cLotIni ) + " > " + AllTrim( ::cLotFin ) } }

   /*Albaranes de proveedor*/

   if ::lAlbaran

      ::oAlbPrvT:OrdSetFocus( "dFecAlb" )
      ::oAlbPrvL:OrdSetFocus( "nNumAlb" )

      cExpHead          := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

      if !::lAllPrv
         cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
      end if

      if !Empty( ::oFilter:cExpresionFilter ) 
         cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
      end if

      ::oAlbPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

      cExpLine          := '!lControl .and. !lKitChl'

      if !Empty( ::cLotIni ) .and. !Empty( ::cLotFin )
         cExpLine       += ' .and. AllTrim( cLote ) >= "' + AllTrim( ::cLotIni ) + '" .and. AllTrim( cLote ) <= "' + AllTrim( ::cLotFin ) + '"'
      end if

      if !::lAllArt
         cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
      end if

      ::oAlbPrvL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbPrvL:cFile ), ::oAlbPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

      ::oAlbPrvT:GoTop()

      while !::lBreak .and. !::oAlbPrvT:Eof()

         if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

            if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

               while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

                  if !( ::lExcCero .AND. ( nTotNAlbPrv( ::oAlbPrvL ) == 0 ) )                                                 .AND.;
                     !( ::lExcImp .AND. ( nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                     ::oDbf:Append()

                     ::oDbf:cCodPrv    := ::oAlbPrvT:cCodPrv
                     ::oDbf:cNomPrv    := ::oAlbPrvT:cNomPrv
                     ::oDbf:cTipDoc    := "Alb. Prv."
                     ::oDbf:cNumDoc    := ::oAlbPrvT:cSerAlb + "/" + Str( ::oAlbPrvT:nNumAlb ) + "/" + ::oAlbPrvT:cSufAlb
                     ::oDbf:dFecDoc    := ::oAlbPrvT:dFecAlb
                     ::oDbf:cCodArt    := ::oAlbPrvL:cRef
                     ::oDbf:cNomArt    := ::oAlbPrvL:cDetalle
                     ::oDbf:cCodFam    := ::oAlbPrvL:cCodFam
                     ::oDbf:cLote      := ::oAlbPrvL:cLote
                     ::oDbf:nTotCaj    := ::oAlbPrvL:nCanEnt
                     ::oDbf:nTotUni    := nTotNAlbPrv( ::oAlbPrvL )
                     ::oDbf:nTotImp    := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     ::oDbf:Save()

                  end if

                  ::oAlbPrvL:Skip()

               end while

            end if

         end if

         ::oAlbPrvT:Skip()

         ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

      end while

      ::oAlbPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ) )

      ::oAlbPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbPrvL:cFile ) )

   end if

   /*Facturas de proveedor*/

   if ::lFactura

      ::oFacPrvT:OrdSetFocus( "dFecFac" )
      ::oFacPrvL:OrdSetFocus( "nNumFac" )

      cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

      if !::lAllPrv
         cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
      end if

      if !Empty( ::oFilter:cExpresionFilter )
         cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
      end if

      ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

      ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

      cExpLine          := '!lControl .and. !lKitChl'

      if !Empty( ::cLotIni ) .and. !Empty( ::cLotFin )
         cExpLine       += ' .and. cLote >= "' + ::cLotIni + '" .and. cLote <= "' + ::cLotFin + '"'
      end if

      if !::lAllArt
         cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
      end if

      ::oFacPrvL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

      ::oFacPrvT:GoTop()

      while !::lBreak .and. !::oFacPrvT:Eof()

         if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .AND. ( nTotNFacPrv( ::oFacPrvL ) == 0 ) )                                                 .AND.;
                     !( ::lExcImp .AND. ( nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 ) )

                     ::oDbf:Append()

                     ::oDbf:cCodPrv    := ::oFacPrvT:cCodPrv
                     ::oDbf:cNomPrv    := ::oFacPrvT:cNomPrv
                     ::oDbf:cTipDoc    := "Fac. Prv."
                     ::oDbf:cNumDoc    := ::oFacPrvT:cSerFac + "/" + Str( ::oFacPrvT:nNumFac ) + "/" + ::oFacPrvT:cSufFac
                     ::oDbf:dFecDoc    := ::oFacPrvT:dFecFac
                     ::oDbf:cCodArt    := ::oFacPrvL:cRef
                     ::oDbf:cNomArt    := ::oFacPrvL:cDetalle
                     ::oDbf:cCodFam    := ::oFacPrvL:cCodFam
                     ::oDbf:cLote      := ::oFacPrvL:cLote
                     ::oDbf:nTotCaj    := ::oFacPrvL:nCanEnt
                     ::oDbf:nTotUni    := nTotNFacPrv( ::oFacPrvL )
                     ::oDbf:nTotImp    := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     ::oDbf:Save()

                  end if

                  ::oFacPrvL:Skip()

               end while

            end if

         end if

         ::oFacPrvT:Skip()

         ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

      end while

      ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

      ::oFacPrvL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvL:cFile ) )

   end if

   ::oMtrInf:AutoInc( ::oFacPrvT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//