#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuNPre FROM TInfPAge

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
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

METHOD Create()

   ::AcuCreate()

   ::AddTmpIndex( "cCodAge", "cCodAge" )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() )   FILE "PRECLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() )   FILE "ARTICULO.DBF"  VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oIva     PATH ( cPatDat () )  FILE "TIVA.DBF"      VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oPreCliT ) .and. ::oPreCliT:Used()
      ::oPreCliT:End()
   end if
   if !Empty( ::oPreCliL ) .and. ::oPreCliL:Used()
      ::oPreCliL:End()
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

   ::oPreCliT := nil
   ::oPreCliL := nil
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

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefExcInf( 200 )

   ::CreateFilter( aItmPreCli(), ::oPreCliT:cAlias )

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
                        {|| "Agentes : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                        {|| if ( ::lTvta, (if (!Empty( ::cTipVen ), "Tipo de Venta: " + ::cTipVen2, "Tipo de Venta: Todos" ) ), "Tipo de Venta: Ninguno" ) },;
                        {|| if( ::lTvta, "Aplicando comportamiento de los tipos de venta", "" ) } }

   ::oPreCliT:OrdSetFocus( "dFecPre" )
   ::oPreCliL:OrdSetFocus( "nNumPre" )

   cExpHead          := 'dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPreCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

   /*
   Líneas de albaranes
   */

   cExpLine          := '!lTotLin .and. !lControl'

   ::oPreCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPreCliL:cFile ), ::oPreCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPreCliT:GoTop()

   while !::lBreak .and. !::oPreCliT:Eof()

     if  lChkSer( ::oPreCliT:cSerPre, ::aSer )                                 .AND.;
         ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

        while ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre .AND. ! ::oPreCliL:eof()

           if !( ::lExcCero .AND. nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::lTvta

                 if  ( if (!Empty( ::cTipVen ), ::oPreCliL:cTipMov == ::cTipVen, .t. ) )

                    if !::oDbf:Seek( ::oPreCliT:cCodAge )

                        ::oDbf:Append()

                        ::oDbf:cCodAge    := ::oPreCliT:cCodAge
                        if ( ::oDbfAge:Seek (::oPreCliT:cCodAge) )
                           ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                        end if

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni := nTotNPreCli( ::oPreCliL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni := -nTotNPreCli( ::oPreCliL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni := 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nImpTot := 0
                           ::oDbf:nTotCom := 0
                        else
                           ::oDbf:nImpTot := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom := nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecPnt, ::nValDiv )
                        ::oDbf:nIvaTot    := nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                        ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                        ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .f. )

                        ::oDbf:Save()
                     else

                        ::oDbf:Load()

                        if ::oDbfTvta:nUndMov == 1
                           ::oDbf:nNumUni += nTotNPreCli( ::oPreCliL )
                        elseif ::oDbfTvta:nUndMov == 2
                           ::oDbf:nNumUni += -nTotNPreCli( ::oPreCliL )
                        elseif ::oDbfTvta:nUndMov == 3
                           ::oDbf:nNumUni += 0
                        end if

                        if ::oDbfTvta:nImpMov == 3
                           ::oDbf:nImpTot += 0
                           ::oDbf:nTotCom += 0
                        else
                           ::oDbf:nImpTot += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                           ::oDbf:nTotCom += nComLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut )
                        end if

                        ::oDbf:nImpArt    += nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nImpTrn    += nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPntVer    += nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                        ::oDbf:nIvaTot    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )
                        ::oDbf:nTotFin    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
                        ::oDbf:nTotFin    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, .t., .t., .t. )

                        ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .t. )

                        ::oDbf:Save()

                     end if

                 end if

                 /*
                 Pasamos de los tipos de ventas
                 */

              else

               ::AddPre( .t. )

              end if

           end if

           ::oPreCliL:Skip()

        end while

     end if

     ::oPreCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oPreCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPreCliT:cFile ) )

   ::oPreCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oPreCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//