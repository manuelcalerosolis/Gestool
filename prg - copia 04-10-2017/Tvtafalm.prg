#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TVtaFAlm FROM TInfGen

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD NewGroup()

   METHOD QuiGroup()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },            "Familia",                   .f., "Familia"                   ,  5, .f. )
   ::AddField( "cNomFam", "C", 50, 0, {|| "@!" },            "Nom. fam.",                 .f., "Nombre familia"            , 35, .f. )
   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },            "Alm.",                      .f., "Código almacén"            ,  5, .f. )
   ::AddField( "cNomAlm", "C", 20, 0, {|| "@!" },            "Nom. alm.",                 .f., "Nombre almacén"            , 20, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },            "Art.",                      .f., "Código artículo"           , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },            "Descripción",               .f., "Descripción"               , 35, .f. )
   ::FldPropiedades()
   ::AddField( "cLote",   "C", 14, 0, ,                      "Lote",                      .f., "Número de lote"            , 10, .f. )
   ::FldCliente()
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },        cNombreCajas(),              .f., cNombreCajas()              , 12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },        cNombreUnidades(),           .f., cNombreUnidades()           , 12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },        "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },       "Precio",                    .f., "Precio"                    , 12, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },       "Base",                      .t., "Base"                      , 12, .t. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },       cImp(),                    .t., cImp()                    , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },       "Total",                     .t., "Total"                     , 12, .t. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },            "Doc.",                      .t., "Documento"                 , 14, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },            "Tipo",                      .t., "Tipo de documento"         , 10, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },            "Fecha",                     .t., "Fecha"                     , 10, .f. )

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodFam + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( ::oDbf:cNomAlm ) }, {||"Total almacén..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {||"Total familia..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodFam + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( ::oDbf:cNomArt ) }, {|| "Total artículo..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

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

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
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
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFFAMALM" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

   if !::lDefFamInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   if !::lDefArtInf( 150, 160, 170, 180, 900 )
      return .f.
   end if

   ::oDefExcInf( 210 )

   ::oDefExcImp( 211 )

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local nLasTik  := ::oTikCliT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacCliT:Lastrec()
   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Almacenes : " + if( ::lAllAlm, "Todos los almacenes", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                     {|| "Familia   : " + if( ::lAllFam, "Todas las familias",  AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos los artículos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   /*
   Recorremos albaranes
   */

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb )+ ::oAlbCliT:cSufAlb )

            while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb )+ ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and.;
                  !::oAlbCliL:eof()

               if !( ::lExcCero .and. nTotNAlbCli( ::oAlbCliL ) == 0 )     .and.;
                  !( ::lExcImp .and. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  /*
                  Añade los Registros, viene de la clase padre
                  */

                  ::oDbf:Append()

                  ::oDbf:cCodFam := ::oAlbCliL:cCodFam
                  ::oDbf:cNomFam := cNomFam( ::oAlbCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin
                  ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:cCodArt := ::oAlbCliL:cRef
                  ::oDbf:cNomArt := ::oAlbCliL:cDetalle
                  ::oDbf:cCodPr1 := ::oAlbCliL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oAlbCliL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oAlbCliL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oAlbCliL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oAlbCliL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
                  ::oDbf:cValPr2 := ::oAlbCliL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
                  ::oDbf:cLote   := ::oAlbCliL:cLote
                  
                  ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                  
                  ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
                  ::oDbf:nUniDad := ::oAlbCliL:nUniCaja
                  ::oDbf:nNumUni := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + lTrim ( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim ( ::oAlbCliL:cSufAlb )
                  ::oDbf:cTipDoc := "Albarán"
                  ::oDbf:dFecMov := ::oAlbCliT:dFecAlb

                  ::oDbf:Save()

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*
   Recorremos facturas
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )   .AND.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac )+ ::oFacCliT:cSufFac )

         while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac )+ ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and.;
               !::oFacCliL:eof()

            if !( ::lExcCero .and. nTotNFacCli( ::oFacCliL ) == 0 )  .and.;
               !( ::lExcImp .and. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               ::oDbf:Append()

               ::oDbf:cCodFam := ::oFacCliL:cCodFam
               ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
               ::oDbf:cCodAlm := ::oFacCliL:cAlmLin
               ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
               ::oDbf:cCodArt := ::oFacCliL:cRef
               ::oDbf:cNomArt := ::oFacCliL:cDetalle
               ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
               ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
               ::oDbf:cValPr1 := ::oFacCliL:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
               ::oDbf:cValPr2 := ::oFacCliL:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
               ::oDbf:cLote   := ::oFacCliL:cLote
               ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
               ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
               ::oDbf:nUniDad := ::oFacCliL:nUniCaja
               ::oDbf:nNumUni := nTotNFacCli( ::oFacCliL )
               ::oDbf:nImpArt := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nIvaTot := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
               ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + lTrim ( Str( ::oFacCliL:nNumFac ) ) + "/" + lTrim ( ::oFacCliL:cSufFac )
               ::oDbf:cTipDoc := "Factura"
               ::oDbf:dFecMov := ::oFacCliT:dFecFac

               ::oDbf:Save()

            end if

            ::oFacCliL:Skip()

         end while

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:Set( nLasFac )

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Recorremos facturas rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )   .AND.;
         ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac )+ ::oFacRecT:cSufFac )

         while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac )+ ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac .and.;
               !::oFacRecL:eof()

            if !( ::lExcCero .and. nTotNFacRec( ::oFacRecL ) == 0 ) .and.;
               !( ::lExcImp .and. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  ) == 0 )

               ::oDbf:Append()

               ::oDbf:cCodFam := ::oFacRecL:cCodFam
               ::oDbf:cNomFam := cNomFam( ::oFacRecL:cCodFam, ::oDbfFam )
               ::oDbf:cCodAlm := ::oFacRecL:cAlmLin
               ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
               ::oDbf:cCodArt := ::oFacRecL:cRef
               ::oDbf:cNomArt := ::oFacRecL:cDetalle
               ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
               ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
               ::oDbf:cValPr1 := ::oFacRecL:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
               ::oDbf:cValPr2 := ::oFacRecL:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
               ::oDbf:cLote   := ::oFacRecL:cLote
               ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
               ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
               ::oDbf:nUniDad := ::oFacRecL:nUniCaja
               ::oDbf:nNumUni := nTotNFacRec( ::oFacRecL )
               ::oDbf:nImpArt := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nIvaTot := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
               ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )
               ::oDbf:cTipDoc := "Fac. rec."
               ::oDbf:dFecMov := ::oFacRecT:dFecFac

               ::oDbf:Save()

            end if

            ::oFacRecL:Skip()

         end while

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( nLasFac )

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*
   Recorremos tikets-----------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   /*
   Cabeceras de tikets creamos el indice sobre la cabecera
   */

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllAlm
      cExpHead       += ' .and. Rtrim( cAlmTik ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmTik ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando tikets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   cExpLine          := '!lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if ::lAllArt
      cExpLine       += ' .and. ( !Empty( cCbaTil ) .or. !Empty( cComTil ) )'
   else
      cExpLine       += ' .and. '
      cExpLine       += '( ( cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" ) .or. ( cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik .and.;
                  !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                    .AND.;
                  !( ::lExcCero .and. ::oTikCliL:nUntTil == 0 )   .AND.;
                  !( ::lExcImp .and. ::oTikCliL:nPvpTil == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodFam := ::oTikCliL:cCodFam
                  ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodAlm := ::oTikCliT:cAlmTik
                  ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt := RetArticulo( ::oTikCliL:cCbaTil, ::oDbfArt )
                  ::oDbf:cCodPr1 := ::oTikCliL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oTikCliL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oTikCliL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oTikCliL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oTikCliL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                  ::oDbf:cValPr2 := ::oTikCliL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
                  ::oDbf:cLote   := ::oTikCliL:cLote
                  ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     := ::oTikCliL:nUntTil
                  end if
                  ::oDbf:nImpArt := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::oDbf:cDocMov := ::oTikCliL:cSerTil + "/" + lTrim ( ::oTikCliL:cNumTil ) + "/" + lTrim ( ::oTikCliL:cSufTil )
                  ::oDbf:cTipDoc := "Tiket"
                  ::oDbf:dFecMov := ::oTikCliT:dFecTik

                  ::oDbf:Save()

               end if

               if !Empty( ::oTikCliL:cComTil )                   .AND.;
                  !( ::lExcCero .and. ::oTikCliL:nUntTil == 0 )  .AND.;
                  !( ::lExcImp .and. ::oTikCliL:nPcmTil == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodFam := ::oTikCliL:cCodFam
                  ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodAlm := ::oTikCliT:cAlmTik
                  ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:cCodArt := ::oTikCliL:cComTil
                  ::oDbf:cNomArt := RetArticulo( ::oTikCliL:cComTil, ::oDbfArt )
                  ::oDbf:cCodPr1 := ::oTikCliL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oTikCliL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oTikCliL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oTikCliL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oTikCliL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                  ::oDbf:cValPr2 := ::oTikCliL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )
                  ::oDbf:cLote   := ::oTikCliL:cLote
                  ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )
                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     := ::oTikCliL:nUntTil
                  end if
                  ::oDbf:nImpArt := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::oDbf:cDocMov := ::oTikCliL:cSerTil + "/" + lTrim ( ::oTikCliL:cNumTil ) + "/" + lTrim ( ::oTikCliL:cSufTil )
                  ::oDbf:cTipDoc := "Tiket"
                  ::oDbf:dFecMov := ::oTikCliT:dFecTik

                  ::oDbf:Save()

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD NewGroup( lDesPrp )

   if lDesPrp
      ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodFam + ::oDbf:cCodArt + ::oDbf:cCodPr1 + ::oDbf:cCodPr2 + ::oDbf:cValPr1 + ::oDbf:cValPr2 + ::oDbf:cLote },;
      {||   if( !Empty( ::oDbf:cValPr1 ), AllTrim( ::oDbf:cNomPr1 ) + ": " + AllTrim( ::oDbf:cNomVl1 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cValPr2 ), AllTrim( ::oDbf:cNomPr2 ) + ": " + AllTrim( ::oDbf:cNomVl2 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cLote ), "Lote:" + AllTrim( ::oDbf:cLote ), Space(1) ) },;
      {|| Space(1) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup( lDesPrp )

   if lDesPrp
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//