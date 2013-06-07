#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfNVta FROM TInfPAge

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::Fields()

   ::AddTmpIndex( "CCODAGE", "CCODAGE + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + CLOTE" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() )  FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )  FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )  FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT() 

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )  FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() )  FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )  FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfTvta PATH ( cPatDat() )  FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat() )  FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

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
   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if
   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oIva     := nil
   ::oDbfTvta := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INF_GEN17RTIK" )
      return .f.
   end if

   ::CreateFilter( aItmVentas(), { ::oAlbCliT, ::oFacCliT, ::oFacRecT, ::oTikCliT }, .t. )

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 150, 160, 170, 180, 800 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   REDEFINE CHECKBOX ::lTvta ;
      ID       260 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen VAR ::cTipVen ;
      VALID    ( cTVta( oTipVen, This:oDbfTvta:cAlias, oTipVen2 ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  ( BrwTVta( oTipVen, This:oDbfTVta:cAlias, oTipVen2 ) ) ;
      ID       270 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTipVen2 VAR ::cTipVen2 ;
      ID       280 ;
      WHEN     ( .F. ) ;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

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
   local nLasRec  := ::oFacRecT:Lastrec()
   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : "   + Dtoc( Date() ) },;
                        {|| "Periodo : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes   : "   + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                        {|| "Artículos : "   + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                        {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 4
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 4 ]
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando tikets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   cExpLine          := '!lControl'

   if ::lAllArt
      cExpLine       += ' .and. ( !Empty( cCbaTil ) .or. !Empty( cComTil ) )'
   else
      cExpLine       += ' .and. ( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil

               if !Empty( ::oTikCliL:cCbaTil )                                    .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                   .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

                  ::AddTik( ::oTikCliL:cCbaTil, 1, .f. )

               end if

               if !Empty( ::oTikCliL:cComTil )                                    .AND.;
                  !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                   .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

                  ::AddTik( ::oTikCliL:cComTil, 2, .f. )

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


   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 1
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 1 ]
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 ) .and.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oAlbCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
                        if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
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
                        ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + lTrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim( ::oAlbCliL:cSufAlb )
                        ::oDbf:cTipDoc := "Albarán"
                        ::oDbf:dFecMov := ::oAlbCliT:dFecAlb

                        if ::oDbfTvta:Seek( ::oAlbCliL:cTipMov )
                           ::oDbf:cTipVen := ::oDbfTvta:cDesMov
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
                           ::oDbf:nNumUni := nTotNAlbCli( ::oAlbCliL )
                           ::oDbf:nUniDad := ::oAlbCliL:nUniCaja
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumCaj := -::oAlbCliL:nCanEnt
                           ::oDbf:nNumUni := -nTotNAlbCli( ::oAlbCliL )
                           ::oDbf:nUniDad := -::oAlbCliL:nUniCaja
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumCaj := 0
                           ::oDbf:nNumUni := 0
                           ::oDbf:nUniDad := 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge := 0
                           ::oDbf:nImpTot := 0
                           ::oDbf:nTotCom := 0
                        else
                           ::oDbf:nComAge := ( ::oAlbCliL:nComAge )
                           ::oDbf:nImpTot := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

                     ::oDbf:Save()

                     end if

                  /*
                  Pasamos de los tipos de ventas
                  */

                  else

                  ::AddAlb( .f. )

                  end if

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

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 2
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 2 ]
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac

               if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) .and.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oFacCliL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oFacCliT:cCodAge
                        if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
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
                        ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + lTrim( Str( ::oFacCliL:nNumFac ) ) + "/" + lTrim( ::oFacCliL:cSufFac )
                        ::oDbf:cTipDoc := "Factura"
                        ::oDbf:dFecMov := ::oFacCliT:dFecFac

                        if ::oDbfTvta:Seek( ::oFacCliL:cTipMov )
                           ::oDbf:cTipVen := ::oDbfTvta:cDesMov
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
                           ::oDbf:nNumUni := nTotNFacCli( ::oFacCliL )
                           ::oDbf:nUniDad := ::oFacCliL:nUniCaja
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumCaj := -::oFacCliL:nCanEnt
                           ::oDbf:nNumUni := -nTotNFacCli( ::oFacCliL )
                           ::oDbf:nUniDad := -::oFacCliL:nUniCaja
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumCaj := 0
                           ::oDbf:nNumUni := 0
                           ::oDbf:nUniDad := 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge := 0
                           ::oDbf:nImpTot := 0
                           ::oDbf:nTotCom := 0
                        else
                           ::oDbf:nComAge := ( ::oFacCliL:nComAge )
                           ::oDbf:nImpTot := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom := nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

                     ::oDbf:Save()

                     end if

                  /*
                  Pasamos de los tipos de ventas
                  */

                  else

                  ::AddFac( .f. )

                  end if

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:aExpFilter ) .and. len( ::oFilter:aExpFilter ) >= 3
      cExpHead       += ' .and. ' + ::oFilter:aExpFilter[ 3 ]
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Facturas rectificativas"
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL:cAlias ) == 0 ) .and.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if ::lTvta

                     if  ( if (!Empty( ::cTipVen ), ::oFacRecL:cTipMov == ::cTipVen, .t. ) )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oFacRecT:cCodAge
                        if ( ::oDbfAge:Seek (::oFacRecT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
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
                        ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim( ::oFacRecL:cSufFac )
                        ::oDbf:cTipDoc := "Fac. rec."
                        ::oDbf:dFecMov := ::oFacRecT:dFecFac

                        if ::oDbfTvta:Seek( ::oFacRecL:cTipMov )
                           ::oDbf:cTipVen := ::oDbfTvta:cDesMov
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
                           ::oDbf:nNumUni := nTotNFacRec( ::oFacRecL )
                           ::oDbf:nUniDad := ::oFacRecL:nUniCaja
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumCaj := -::oFacRecL:nCanEnt
                           ::oDbf:nNumUni := -nTotNFacRec( ::oFacRecL )
                           ::oDbf:nUniDad := -::oFacRecL:nUniCaja
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumCaj := 0
                           ::oDbf:nNumUni := 0
                           ::oDbf:nUniDad := 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge := 0
                           ::oDbf:nImpTot := 0
                           ::oDbf:nTotCom := 0
                        else
                           ::oDbf:nComAge := ( ::oFacRecL:nComAge )
                           ::oDbf:nImpTot := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom := nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

                     ::oDbf:Save()

                     end if

                  /*
                  Pasamos de los tipos de ventas
                  */

                  else

                  ::AddFacRecVta( .f. )

                  end if

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( nLasRec )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//