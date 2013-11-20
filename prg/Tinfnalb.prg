#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfNAlb FROM TInfPAge

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  cTipVen
   DATA  cTipVen2
   DATA  aEstado     AS ARRAY    INIT { "No facturados", "Facturados", "Todos" }

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfTvta  PATH ( cPatDat() ) FILE "TVTA.DBF"    VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
      ::oDbfTvta:End()
   end if
   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfTvta := nil
   ::oIva     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oTipVen
   local oTipVen2
   local cEstado     := "Todos"
   local This        := Self

   if !::StdResource( "INF_GEN17R" )
      return .f.
   end if

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

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::oDefResInf( 190 )

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead  := ""
   local cExpLine  := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {{|| "Fecha    : "  + Dtoc( Date() ) },;
                     {|| "Periodo   : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes   : "   + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                     {|| "Artículos : "   + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                     {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

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

                     if Empty( ::cTipVen ) .or. ::oAlbCliL:cTipMov == ::cTipVen

                        ::oDbf:Append()
                        ::oDbf:Blank()

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

                           if ::oDbfTvta:nImpMov == 1
                              ::oDbf:nComAge := ( ::oAlbCliL:nComAge )
                              ::oDbf:nTotCom := nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nImpTot := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
                              ::oDbf:nImpArt := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                              ::oDbf:nIvaTot := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                           elseif ::oDbfTvta:nImpMov == 2
                              ::oDbf:nComAge := ( ::oAlbCliL:nComAge )
                              ::oDbf:nTotCom := -( nComLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) )
                              ::oDbf:nImpTot := -( nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) )
                              ::oDbf:nImpArt := -( nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv ) )
                              ::oDbf:nIvaTot := -( nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. ) )
                           elseif ::oDbfTvta:nImpMov == 3
                              ::oDbf:nComAge := 0
                              ::oDbf:nTotCom := 0
                              ::oDbf:nImpTot := 0
                              ::oDbf:nImpArt := 0
                              ::oDbf:nIvaTot := 0
                           end if

                        end if

                        ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecPnt, ::nValDiv )
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

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//