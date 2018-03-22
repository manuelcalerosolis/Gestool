#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TVtaAlm FROM TInfGen

   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfArt     AS OBJECT
    

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD IncluyeCero()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam", "C", 18, 0, {|| "@!" },           "Fam.",           .t., "Código familia"    , 14, .f. )
   ::AddField( "cNomFam", "C", 50, 0, {|| "@!" },           "Nom. fam",       .t., "Familia"           , 35, .f. )
   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },           "Alm.",           .f., "Código familia"    ,  5, .f. )
   ::AddField( "cNomAlm", "C", 20, 0, {|| "@!" },           "Nom. alm.",      .f., "Familia"           , 20, .f. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),.t., cNombreUnidades()   , 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",         .f., "Precio"            , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",      .t., "Precio medio"      , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },      "Pnt. ver.",      .f., "Punto verde"       , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },      "Portes",         .f., "Portes"            , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",           .t., "Base"              , 12, .t. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      "Tot. " + cImp(),    .t., "Total " + cImp()      , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",          .t., "Total"             , 12, .t. )

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodFam" )

   ::AddGroup( {|| ::oDbf:cCodAlm  }, {|| "Almacén : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( ::oDbf:cNomAlm ) }, {||"Total almacén..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

    

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
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
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
    

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfArt  := nil
    

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFVTAALM" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   if !::lDefFamInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   if !::oDefCliInf( 150, 151, 160, 161, , 170 )
      return .f.
   end if

   ::oDefExcInf( 210 )

   ::oDefExcImp( 211 )

   ::oDefResInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacénes : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                        {|| "Familias  : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

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

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

     if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

        while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

           if !( ::lExcCero .and. nTotNAlbCli( ::oAlbCliL ) == 0 ) .AND.;
              !( ::lExcImp .and. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if !::oDbf:Seek( ::oAlbCliL:cAlmLin + ::oAlbCliL:cCodFam )

                 ::oDbf:Append()

                 ::oDbf:cCodFam := ::oAlbCliL:cCodFam
                 ::oDbf:cNomFam := cNomFam( ::oAlbCliL:cCodFam, ::oDbfFam )
                 ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin
                 ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                 ::oDbf:nNumUni := nTotNAlbCli( ::oAlbCliL )
                 ::oDbf:nImpArt := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nPntVer := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTrn := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTot := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nIvaTot := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                 ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                 ::oDbf:Save()

              else

                 ::oDbf:Load()

                 ::oDbf:nNumUni += nTotNAlbCli( ::oAlbCliL )
                 ::oDbf:nImpArt += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nPntVer += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTrn += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTot += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nIvaTot += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                 ::oDbf:Save()

              end if

           end if

           ::oAlbCliL:Skip()

        end while

     end if

     ::oAlbCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   /*
   Facturas--------------------------------------------------------------------
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

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

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

     if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

        while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

           if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 ) .AND.;
              !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if !::oDbf:Seek( ::oFacCliL:cAlmLin + ::oFacCliL:cCodFam )

                 ::oDbf:Append()

                 ::oDbf:cCodFam := ::oFacCliL:cCodFam
                 ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                 ::oDbf:cCodAlm := ::oFacCliL:cAlmLin
                 ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                 ::oDbf:nNumUni := nTotNFacCli( ::oFacCliL )
                 ::oDbf:nImpArt := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nPntVer := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTrn := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTot := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nIvaTot := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                 ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                 ::oDbf:Save()

              else

                 ::oDbf:Load()

                 ::oDbf:nNumUni += nTotNFacCli( ::oFacCliL )
                 ::oDbf:nImpArt += nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nPntVer += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTrn += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTot += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nIvaTot += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                 ::oDbf:Save()

              end if

           end if

           ::oFacCliL:Skip()

        end while

     end if

     ::oFacCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando facturas"
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

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

     if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

           if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 ) .AND.;
              !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if !::oDbf:Seek( ::oFacRecL:cAlmLin + ::oFacRecL:cCodFam )

                 ::oDbf:Append()

                 ::oDbf:cCodFam := ::oFacRecL:cCodFam
                 ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                 ::oDbf:cCodAlm := ::oFacRecL:cAlmLin
                 ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                 ::oDbf:nNumUni := nTotNFacRec( ::oFacRecL )
                 ::oDbf:nImpArt := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nPntVer := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTrn := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTot := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nIvaTot := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                 ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                 ::oDbf:Save()

              else

                 ::oDbf:Load()

                 ::oDbf:nNumUni += nTotNFacRec( ::oFacRecL )
                 ::oDbf:nImpArt += nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nPntVer += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTrn += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                 ::oDbf:nImpTot += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nIvaTot += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nTotFin += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                 ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                 ::oDbf:Save()

              end if

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   /*
   Tikets ---------------------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllAlm
      cExpHead       += ' .and. Rtrim( cAlmTik ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmTik ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando tikets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            if !Empty( ::oTikCliL:cCbaTil )                       .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

               if !::oDbf:Seek( ::oTikCliT:cAlmTik + ::oTikCliL:cCodFam )

                  ::oDbf:Append()

                  ::oDbf:cCodFam := ::oTikCliL:cCodFam
                  ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodAlm := ::oTikCliT:cAlmTik
                  ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni    := ::oTikCliL:nUntTil
                  end if
                  ::oDbf:nImpArt := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                    ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                    ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if
                  ::oDbf:nImpArt += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nTotFin += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               end if

            end if

            if !Empty( ::oTikCliL:cComTil )                       .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )      .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

               if !::oDbf:Seek( ::oTikCliT:cAlmTik + ::oTikCliL:cCodFam )

                  ::oDbf:Append()

                  ::oDbf:cCodFam := ::oTikCliL:cCodFam
                  ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodAlm := ::oTikCliT:cAlmTik
                  ::oDbf:cNomAlm := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni    := ::oTikCliL:nUntTil
                  end if
                  ::oDbf:nImpArt := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                    ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                    ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if
                  ::oDbf:nImpArt += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nTotFin += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nPreMed := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD IncluyeCero()

   ::oDbfAlm:GoTop()
   while !::oDbfAlm:Eof()

      if ( ::lAllAlm .or. ( ::oDbfAlm:cCodAlm >= ::cAlmOrg .and. ::oDbfAlm:cCodAlm <= ::cAlmDes ) )

         ::oDbfFam:GoTop()
         while !::oDbfFam:Eof()

            if ( ::lAllFam .or. ( ::oDbfFam:cCodFam >= ::cFamOrg .AND. ::oDbfFam:cCodFam <= ::cFamDes ) ) .AND.;
            !::oDbf:Seek( ::oDbfAlm:cCodAlm + ::oDbfFam:cCodFam )

            ::oDbf:Append()
            ::oDbf:Blank()
            ::oDbf:cCodFam    := ::oDbfFam:cCodFam
            ::oDbf:cNomFam    := ::oDbfFam:cNomFam
            ::oDbf:cCodAlm    := ::oDbfAlm:cCodAlm
            ::oDbf:cNomAlm    := ::oDbfAlm:cNomAlm
            ::oDbf:Save()

            end if

            ::oDbfFam:Skip()

         end while

      end if

      ::oDbfAlm:Skip()

   end while

RETURN ( self )
//---------------------------------------------------------------------------//