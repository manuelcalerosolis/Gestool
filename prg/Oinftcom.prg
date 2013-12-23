#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OInfTCom FROM TPrvTip

   DATA  lExcMov     AS LOGIC    INIT .f.
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

   ::CreateFields()
   ::AddField ( "cTipDoc", "C", 10, 0, {|| "@!" },    "Tipo documento",       .t., "Tipo documento"        , 12 )

   ::AddTmpIndex( "cCodTip", "cCodTip + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo art.  : " + Rtrim( ::oDbf:cCodTip ) + "-" + Rtrim( ::oDbf:cNomTip ) }, {||"Total tipo artículo..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodTip + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + AllTrim( ::oDbf:cNomArt ) }, {|| Space(1) } )

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

   ::oAlbPrvT  := nil
   ::oAlbPrvL  := nil
   ::oFacPrvT  := nil
   ::oFacPrvL  := nil
   ::oFacPrvP  := nil
   ::oDbfIva   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN11E" )
      return .f.
   end if

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   /* Monta tipo de artículos */

   if !::oDefTipInf( 110, 120, 130, 140, 910 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   /* Meter */

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

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

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Tipos     : " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg ) + " > " + AllTrim( ::cTipDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )
   ::oAlbPrvL:OrdSetFocus( "nNumAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   if !::lAllArt
      cExpLine       := 'cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   else
      cExpLine       := '.t.'
   end if

   ::oAlbPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ), ::oAlbPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

               if ( ::lAllTip .or. ( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip") >= ::cTipOrg .AND. oRetFld( ::oAlbPrvL:cRef, ::oDbfArt , "cCodTip") <= ::cTipDes ) ) .AND.;
                  !( ::lExcCero .AND. nTotNAlbPrv( ::oAlbPrvL ) == 0 )  .AND.;
                  !( ::lExcImp .AND. nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )== 0 )

                  ::AddAlb( .f. )
                  ::oDbf:Load()
                  ::oDbf:cTipDoc := "Albarán"
                  ::oDbf:Save()

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

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   if !::lAllArt
      cExpLine       := 'cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'

      cExpLine       := '.t.'
   end if

   ::oFacPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvT:lFacGas

            aTot              := aTotFacPrv( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, ::cDivInf )

            ::oDbf:Append()

            ::oDbf:cCodTip    := Space( 3 )
            ::oDbf:cNomTip    := Space( 50 )
            ::AddProveedor( ::oFacPrvT:cCodPrv )
            ::oDbf:cCodArt    := Space(18)
            ::oDbf:cNomArt    := "Factura de gastos. Concepto: " + ::oFacPrvT:mComGas
            ::oDbf:nNumCaj    := 1
            ::oDbf:nUniDad    := 1
            ::oDbf:cDocMov    := ::oFacPrvT:cSerFac + "/" + AllTrim ( Str( ::oFacPrvT:nNumFac ) ) + If( !Empty( ::oFacPrvT:cSufFac ), "/" + AllTrim ( ::oFacPrvT:cSufFac ), "" )
            ::oDbf:dFecMov    := ::oFacPrvT:dFecFac
            ::oDbf:nNumUni    := 1
            ::oDbf:nImpArt    := aTot[1]
            ::oDbf:nImpTot    := aTot[1]
            ::oDbf:nIvaTot    := aTot[2]
            ::oDbf:nTotFin    := aTot[4]
            ::oDbf:cTipDoc    := "Gastos"

            ::oDbf:Save()


         else

            if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

               while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

                  if ( ::lAllTip .or. ( oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip") >= ::cTipOrg .AND. oRetFld( ::oFacPrvL:cRef, ::oDbfArt , "cCodTip") <= ::cTipDes ) ) .AND.;
                     !( ::lExcCero .AND. nTotNFacPrv( ::oFacPrvL ) == 0 )  .AND.;
                     !( ::lExcImp .AND. nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                     ::AddFac( .f. )
                     ::oDbf:Load()
                     ::oDbf:cTipDoc := "Factura"
                     ::oDbf:Save()

                  end if

                  ::oFacPrvL:Skip()

               end while

            end if

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//