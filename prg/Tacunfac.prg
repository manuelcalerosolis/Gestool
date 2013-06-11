#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuNFac FROM TInfPAge

   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oIva        AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AcuCreate()

   ::AddTmpIndex( "cCodAge", "cCodAge" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TAcuNFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRecT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRecT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRecL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRecL.CDX"

   DATABASE NEW ::oDbfTvta PATH ( cPatDat() ) FILE "TVTA.DBF" VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oIva PATH ( cPatDat () ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TAcuNFac

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
   if !Empty( ::oDbfTvta ) .and. ::oDbfTvta:Used()
   ::oDbfTvta:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
   ::oDbfArt:End()
   end if
   if !Empty( ::oIva ) .and. ::oIva:Used()
   ::oIva:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfTvta := nil
   ::oDbfArt  := nil
   ::oIva     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TAcuNFac

   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INFACUAGER" )
      return .f.
   end if

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TAcuNFac

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes   : "   + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                        {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                        {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

     if  lChkSer( ::oFacCliT:cSerie, ::aSer ) .and. ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

        while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac) + ::oFacCliL:cSufFac.AND. ! ::oFacCliL:eof()

           if  !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL:cAlias ) == 0 ) .and.;
               !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::lTvta

                 if  ( if (!Empty( ::cTipVen ), ::oFacCliL:cTipMov == ::cTipVen, .t. ) )

                    if !::oDbf:Seek( ::oFacCliT:cCodAge )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oFacCliT:cCodAge
                        if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni := nTotNFacCli( ::oFacCliL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni := -nTotNFacCli( ::oFacCliL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni := 0
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
                        ::oDbf:nIvaArt    := nIvaUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                        ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

                        ::oDbf:Save()
                     else

                        ::oDbf:Load()

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni += nTotNFacCli( ::oFacCliL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni += -nTotNFacCli( ::oFacCliL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni += 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge += 0
                           ::oDbf:nImpTot += 0
                           ::oDbf:nTotCom += 0
                        else
                           ::oDbf:nComAge += ( ::oFacCliL:nComAge )
                           ::oDbf:nImpTot += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom += nComLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    += nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nIvaArt    += nIvaUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                        ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                        ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                        ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

                        ::oDbf:Save()

                     end if

                 end if

                 /*
                 Pasamos de los tipos de ventas
                 */

              else

               ::AddFac( .t. )

              end if

           end if

           ::oFacCliL:Skip()

        end while

     end if

     ::oFacCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )
   /*
   comenzamos con las rectificativas
   */
   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

     if  lChkSer( ::oFacRecT:cSerie, ::aSer ) .and. ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac) + ::oFacRecL:cSufFac.AND. ! ::oFacRecL:eof()

           if  !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL:cAlias ) == 0 ) .and.;
               !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::lTvta

                 if  ( if (!Empty( ::cTipVen ), ::oFacRecL:cTipMov == ::cTipVen, .t. ) )

                    if !::oDbf:Seek( ::oFacRecT:cCodAge )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oFacRecT:cCodAge
                        if ( ::oDbfAge:Seek (::oFacRecT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni := nTotNFacRec( ::oFacRecL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni := -nTotNFacRec( ::oFacRecL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni := 0
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
                        ::oDbf:nIvaArt    := nIvaUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                        ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

                        ::oDbf:Save()
                     else

                        ::oDbf:Load()

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni += nTotNFacRec( ::oFacRecL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni += -nTotNFacRec( ::oFacRecL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni += 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge += 0
                           ::oDbf:nImpTot += 0
                           ::oDbf:nTotCom += 0
                        else
                           ::oDbf:nComAge += ( ::oFacRecL:nComAge )
                           ::oDbf:nImpTot += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom += nComLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    += nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nIvaArt    += nIvaUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                        ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                        ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                        ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

                        ::oDbf:Save()

                     end if

                 end if

                 /*
                 Pasamos de los tipos de ventas
                 */

              else

               ::AddFacRec( .t. )

              end if

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )





   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//