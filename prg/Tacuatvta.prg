#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuATVta FROM TInfTip

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

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },           "Cod. Alm.",      .f., "Código almacén"    ,  3, .f. )
   ::AddField( "cNomAlm", "C", 20, 0, {|| "@!" },           "Almacén",        .f., "Tipo de almacén"   , 28, .f. )
   ::AddField( "cCodTip", "C",  4, 0, {|| "@!" },           "Cod. Tip.",      .t., "Código tipo"       ,  3, .f. )
   ::AddField( "cNomTip", "C", 50, 0, {|| "@!" },           "Tipo",           .t., "Tipo de artículo"  , 28, .f. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),.t., cNombreUnidades()   , 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",         .f., "Precio"            , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },      "Pnt. ver.",      .f., "Punto verde"       , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },      "Portes",         .f., "Portes"            , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",           .t., "Base"              , 12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",      .f., "Total peso"        , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",       .f., "Precio kilo"       , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",   .f., "Total volumen"     , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",      .f., "Precio volumen"    , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",      .t., "Precio medio"      , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      "Tot. " + cImp(), .t., "Total " + cImp()   , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",          .t., "Total"             , 12, .t. )

   ::AddTmpIndex( "cCodTip", "cCodAlm + cCodTip" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( ::oDbf:cNomAlm ) }, {||"Total almacén..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAcuATVta

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

METHOD CloseFiles() CLASS TAcuATVta

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

METHOD lResource( cFld ) CLASS TAcuATVta

   if !::StdResource( "INFACUTIPALM" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefAlmInf( 110, 111, 120, 121, 130 )
      return .f.
   end if

   if !::oDefTipInf( 70, 80, 90, 100, 910 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TAcuATVta

   local cCodTip
   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg )  + " > " + AllTrim( ::cAlmDes ) ) },;
                        {|| "Tipo Art. : " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg )  + " > " + AllTrim( ::cTipDes ) ) } }
   /*
   Albaranes-------------------------------------------------------------------
   */

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

     if lChkSer( ::oAlbCliT:cSerAlb, ::aSer ) .and.;
        ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

        while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

           cCodTip := oRetFld( ::oAlbCliL:cRef, ::oDbfArt , "cCodTip")

           if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                 .AND.;
              !( ::lExcCero .and. nTotNAlbCli( ::oAlbCliL ) == 0 )                                   .AND.;
              !( ::lExcImp .and. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::oDbf:Seek( ::oAlbCliL:cAlmLin + cCodTip )

                  ::oDbf:Load()

                  ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               else

                  ::oDbf:Append()

                  ::oDbf:cCodAlm       := ::oAlbCliL:cAlmLin
                  ::oDbf:cNomAlm       := oRetFld( ::oAlbCliL:cAlmLin, ::oDbfAlm , "cNomAlm" )
                  ::oDbf:cCodTip       := cCodTip
                  ::oDbf:cNomTip       := oRetFld( ::oDbf:cCodTip, ::oTipArt:oDbf, "cNomTip" )
                  ::oDbf:nNumUni       := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt       := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer       := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn       := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot       := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot       := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:nPreMed       := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               end if

           end if

           ::oAlbCliL:Skip()

        end while

     end if

     ::oAlbCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*
   Facturas--------------------------------------------------------------------
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )
   ::oMtrInf:cText := "Procesando facturas"

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

     if lChkSer( ::oFacCliT:cSerie, ::aSer ) .and.;
        ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

        while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

           cCodTip := oRetFld( ::oFacCliL:cRef, ::oDbfArt , "cCodTip")

           if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                 .AND.;
              !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )                                   .AND.;
              !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::oDbf:Seek( ::oFacCliL:cAlmLin + cCodTip )

                  /*Acumulamos*/

                  ::oDbf:Load()

                  ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
                  ::oDbf:nImpArt    += nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               else

                  /*Añadimos*/

                  ::oDbf:Append()

                  ::oDbf:cCodAlm       := ::oFacCliL:cAlmLin
                  ::oDbf:cNomAlm       := oRetFld( ::oFacCliL:cAlmLin, ::oDbfAlm , "cNomAlm")
                  ::oDbf:cCodTip       := cCodTip
                  ::oDbf:cNomTip       := oRetFld( ::oDbf:cCodTip, ::oTipArt:oDbf, "cNomTip" )
                  ::oDbf:nNumUni       := nTotNFacCli( ::oFacCliL )
                  ::oDbf:nImpArt       := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer       := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn       := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot       := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot       := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:nPreMed       := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               end if

           end if

           ::oFacCliL:Skip()

        end while

     end if

     ::oFacCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )
   ::oMtrInf:cText := "Procesando fac. rec."

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllAlm
      cExpLine       += ' .and. Rtrim( cAlmLin ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmLin ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

     if lChkSer( ::oFacRecT:cSerie, ::aSer ) .and.;
        ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. !::oFacRecL:eof()

           cCodTip := oRetFld( ::oFacRecL:cRef, ::oDbfArt , "cCodTip")

           if ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )                 .AND.;
              !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 )                                   .AND.;
              !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::oDbf:Seek( ::oFacRecL:cAlmLin + cCodTip )

                  /*Acumulamos*/

                  ::oDbf:Load()

                  ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
                  ::oDbf:nImpArt    += nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               else

                  /*Añadimos*/

                  ::oDbf:Append()

                  ::oDbf:cCodAlm       := ::oFacRecL:cAlmLin
                  ::oDbf:cNomAlm       := oRetFld( ::oFacRecL:cAlmLin, ::oDbfAlm , "cNomAlm")
                  ::oDbf:cCodTip       := cCodTip
                  ::oDbf:cNomTip       := oRetFld( ::oDbf:cCodTip, ::oTipArt:oDbf, "cNomTip" )
                  ::oDbf:nNumUni       := nTotNFacRec( ::oFacRecL )
                  ::oDbf:nImpArt       := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer       := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn       := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot       := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot       := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::oDbf:Save()

               end if

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*
   Tikets ---------------------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead       := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllAlm
      cExpHead    += ' .and. Rtrim( cAlmTik ) >= "' + Rtrim( ::cAlmOrg ) + '" .and. Rtrim( cAlmTik ) <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:aExpFilter[ 4 ]
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )
   ::oMtrInf:cText := "Procesando tikets"

   cExpLine       := '!lControl'

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), ( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer ) .and.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            cCodTip := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt , "cCodTip")

            if !Empty( ::oTikCliL:cCbaTil )                                            .AND.;
               ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )  .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                           .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

               if !::oDbf:Seek( ::oTikCliT:cAlmTik + cCodTip )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm    := ::oTikCliT:cAlmTik
                  ::oDbf:cNomAlm    := oRetFld( ::oTikCliT:cAlmTik, ::oDbfAlm , "cNomAlm")

                  ::oDbf:cCodTip    := cCodTip
                  ::oDbf:cNomTip    := oRetFld( ::oDbf:cCodTip, ::oTipArt:oDbf, "cNomTip" )

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                  ::oDbf:nNumUni     := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oTikCliL:cCbaTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nPreMed       := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nTotFin       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )

                  ::AcuPesVol( ::oTikCliL:cCbaTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

            end if

            cCodTip := oRetFld( ::oTikCliL:cComTil, ::oDbfArt , "cCodTip")

            if !Empty( ::oTikCliL:cComTil )                                            .AND.;
               ( ::lAllTip .or. ( cCodTip >= ::cTipOrg .AND. cCodTip <= ::cTipDes ) )  .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                           .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

               if !::oDbf:Seek( ::oTikCliT:cAlmTik + cCodTip )

                  ::oDbf:Append()

                  ::oDbf:cCodAlm    := ::oTikCliT:cAlmTik
                  ::oDbf:cNomAlm    := oRetFld( ::oTikCliT:cAlmTik, ::oDbfAlm , "cNomAlm")

                  ::oDbf:cCodTip    := cCodTip
                  ::oDbf:cNomTip    := oRetFld( ::oDbf:cCodTip, ::oTipArt:oDbf, "cNomTip" )

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni    := - ::oTikCliL:nUntTil
                  else
                  ::oDbf:nNumUni     := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oTikCliL:cComTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nPreMed       := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nTotFin       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )

                  ::AcuPesVol( ::oTikCliL:cComTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//