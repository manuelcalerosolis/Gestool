#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuNPed FROM TInfPAge

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oDbfTvta    AS OBJECT
   DATA  oDbfArt     AS OBJECT
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  oIva        AS OBJECT
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AcuCreate()

   ::AddTmpIndex( "cCodAge", "cCodAge" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oPedCliT PATH ( cPatEmp() ) FILE "PEDCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDCLIT.CDX"

   DATABASE NEW ::oPedCliL PATH ( cPatEmp() ) FILE "PEDCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

   DATABASE NEW ::oDbfTvta PATH ( cPatDat() ) FILE "TVTA.DBF"     VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
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

   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oDbfTvta := nil
   ::oDbfArt  := nil
   ::oIva     := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INFACUAGE" )
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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

   ::oDefExcInf( 200 )

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

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

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : "   + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                        {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                        {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )
   ::oPedCliL:OrdSetFocus( "nNumPed" )

   cExpHead          := 'dFecPed >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPed <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpFilter
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPedCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   ::oPedCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ), ::oPedCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPedCliT:GoTop()

   while !::lBreak .and. !::oPedCliT:Eof()

     if  lChkSer( ::oPedCliT:cSerPed, ::aSer ) .and. ::oPedCliL:Seek( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed )

        while ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed == ::oPedCliL:cSerPed + Str( ::oPedCliL:nNumPed ) + ::oPedCliL:cSufPed .AND. ! ::oPedCliL:eof()

           if !( ::lExcCero .AND. nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::lTvta

                 if  ( if (!Empty( ::cTipVen ), ::oPedCliL:cTipMov == ::cTipVen, .t. ) )

                    if !::oDbf:Seek( ::oPedCliT:cCodAge )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oPedCliT:cCodAge
                        if ( ::oDbfAge:Seek (::oPedCliT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni := nTotNPedCli( ::oPedCliL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni := -nTotNPedCli( ::oPedCliL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni := 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge := 0
                           ::oDbf:nImpTot := 0
                           ::oDbf:nTotCom := 0
                        else
                           ::oDbf:nComAge := ( ::oPedCliL:nComAge )
                           ::oDbf:nImpTot := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom := nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nIvaArt    := nIvaUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                        ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .f. )

                        ::oDbf:Save()
                     else

                        ::oDbf:Load()

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni += nTotNPedCli( ::oPedCliL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni += -nTotNPedCli( ::oPedCliL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni += 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nComAge += 0
                           ::oDbf:nImpTot += 0
                           ::oDbf:nTotCom += 0
                        else
                           ::oDbf:nComAge += ( ::oPedCliL:nComAge )
                           ::oDbf:nImpTot += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom += nComLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    += nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nIvaArt    += nIvaUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    += nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    += nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                        ::oDbf:nIvaTot    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                        ::oDbf:nTotFin    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  )
                        ::oDbf:nTotFin    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                        ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .t. )

                        ::oDbf:Save()

                     end if

                 end if

                 /*
                 Pasamos de los tipos de ventas
                 */

              else

               ::AddPed( .t. )

              end if

           end if

           ::oPedCliL:Skip()

        end while

     end if

     ::oPedCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPedCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oPedCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliL:cFile ) )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//