#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OAcuRBCom FROM TPrvArt

   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oDbfIva     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },           "Prv.",          .f., "Cod. Proveedor"    ,  9, .f. )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },           "Proveedor",     .f., "Nombre Proveedor"  , 35, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },           "Cod. Art",      .t., "Código artículo"         , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },           "Artículo",      .t., "Artículo"          , 35, .f. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },       "Tot. und.",     .t., "Total unidades"    , 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",        .f., "Precio"            , 12, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",          .t., "Base"              , 12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",     .f., "Total peso"        , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },      "Pre. Kg.",      .f., "Precio kilo"       , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",  .f., "Total volumen"     , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",     .f., "Precio volumen"    , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",     .t., "Precio medio"      , 12, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      cImp(),        .t., cImp()            , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",         .t., "Total"             , 12, .t. )

   ::AddTmpIndex( "CCODPRV", "CCODPRV + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor  : " + Rtrim( ::oDbf:cCodPrv ) + "-" + Rtrim( ::oDbf:cNomPrv ) }, {||"Total proveedor..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if

   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if

   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if

   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN12" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefPrvInf( 110, 120, 130, 140, 700 )
      return .f.
   end if

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   /*
   Excluir si cero
   */

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""
   local aTot     := {}

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Periodo  : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor: " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim ( ::cPrvDes ) ) },;
                     {|| "Artículo : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim ( ::cArtDes ) ) } }

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )
   ::oAlbPrvL:OrdSetFocus( "nNumAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   if !::lAllArt
      cExpLine       += 'cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oAlbPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ), ::oAlbPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

               if !( ::lExcCero .and. nTotNAlbPrv( ::oAlbPrvL ) == 0 )  .AND.;
                  !( ::lExcImp .and. nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oAlbPrvT:cCodPrv + ::oAlbPrvL:cRef )

                     ::oDbf:Append()

                     ::oDbf:cCodPrv      := ::oAlbPrvT:cCodPrv
                     ::oDbf:cNomPrv      := ::oAlbPrvT:cNomPrv
                     ::oDbf:cCodArt      := ::oAlbPrvL:cRef
                     ::oDbf:cNomArt      := Descrip( ::oAlbPrvL:cAlias )
                     ::oDbf:nNumUni      := nTotNAlbPrv( ::oAlbPrvL )
                     ::oDbf:nImpArt      := nTotUAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nValDiv )
                     ::oDbf:nImpTot      := nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed      := ::oDbf:nImpTot / ::oDbf:nNumUni
                     ::oDbf:nIvaTot      := nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin      := ::oDbf:nImpTot + ::oDbf:nIvaTot

                     ::AcuPesVol( ::oAlbPrvL:cRef, nTotNAlbPrv( ::oAlbPrvL ), ::oDbf:nImpTot, .f. )

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     ::oDbf:nNumUni    += nTotNAlbPrv( ::oAlbPrvL )
                     ::oDbf:nImpArt    += nTotUAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nValDiv )
                     ::oDbf:nImpTot    += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                     ::oDbf:nIvaTot    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                     ::oDbf:nTotFin    += nIvaLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                     ::AcuPesVol( ::oAlbPrvL:cRef, nTotNAlbPrv( ::oAlbPrvL ), ::oDbf:nImpTot, .t. )

                     ::oDbf:Save()

                  end if

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )
   ::oAlbPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ) )

   /*Facturas*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + Rtrim( ::cPrvOrg ) + '" .and. cCodPrv <= "' + Rtrim( ::cPrvDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   if !::lAllArt
      cExpLine       := 'cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oFacPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas .and. ::lAllArt

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            if !::oDbf:Seek( ::oFacPrvT:cCodPrv + Space( 18 ) )

               ::oDbf:Append()

               ::oDbf:cCodPrv    := ::oFacPrvT:cCodPrv
               ::oDbf:cNomPrv    := ::oFacPrvT:cNomPrv
               ::oDbf:cCodArt    := Space( 18 )
               ::oDbf:cNomArt    := Space( 100 )
               ::oDbf:nNumUni    := 1
               ::oDbf:nImpArt    := aTot[1]
               ::oDbf:nImpTot    := aTot[1]
               ::oDbf:nIvaTot    := aTot[2]
               ::oDbf:nTotFin    := aTot[4]

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nNumUni    += 1
               ::oDbf:nImpArt    += aTot[1]
               ::oDbf:nImpTot    += aTot[1]
               ::oDbf:nIvaTot    += aTot[2]
               ::oDbf:nTotFin    += aTot[4]

               ::oDbf:Save()

            end if


         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if !( ::lExcCero .and. nTotNFacPrv( ::oFacPrvL ) == 0 )  .AND.;
                     !( ::lExcImp .and. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     if !::oDbf:Seek( ::oFacPrvT:cCodPrv + ::oFacPrvL:cRef )

                        ::oDbf:Append()

                        ::oDbf:cCodPrv      := ::oFacPrvT:cCodPrv
                        ::oDbf:cNomPrv      := ::oFacPrvT:cNomPrv
                        ::oDbf:cCodArt      := ::oFacPrvL:cRef
                        ::oDbf:cNomArt      := Descrip( ::oFacPrvL:cAlias )
                        ::oDbf:nNumUni      := nTotNFacPrv( ::oFacPrvL )
                        ::oDbf:nImpArt      := nTotUFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTot      := nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreMed      := ::oDbf:nImpTot / ::oDbf:nNumUni
                        ::oDbf:nIvaTot      := nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin      := ::oDbf:nImpTot + ::oDbf:nIvaTot

                        ::AcuPesVol( ::oFacPrvL:cRef, nTotNFacPrv( ::oFacPrvL ), ::oDbf:nImpTot, .f. )

                        ::oDbf:Save()

                     else

                        ::oDbf:Load()

                        ::oDbf:nNumUni    += nTotNFacPrv( ::oFacPrvL )
                        ::oDbf:nImpArt    += nTotUFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTot    += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                        ::oDbf:nIvaTot    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    += nIvaLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                        ::AcuPesVol( ::oFacPrvL:cRef, nTotNFacPrv( ::oFacPrvL ), ::oDbf:nImpTot, .t. )

                        ::oDbf:Save()

                     end if

                  end if

                  ::oFacPrvL:Skip()

               end while

            end if

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )
   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//