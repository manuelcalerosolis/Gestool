#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfOAlb FROM TInfPgo

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" } ;

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetCreateFields()

   ::AddTmpIndex( "CCODPGO", "CCODPGO + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + CLOTE" )

   ::AddGroup( {|| ::oDbf:cCodPgo }, {|| "For. Pago  : " + Rtrim( ::oDbf:cCodPgo ) + "-" + Rtrim( ::oDbf:cNomPgo ) }, {||"Total forma de pago..."}, , ::lSalto )
   ::AddGroup( {|| ::oDbf:cCodPgo + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo..." } )

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfOAlb

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfOAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TInfOAlb

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN25C" )
      return .f.
   end if

   /* Monta forma de pago */

   if !::oDefFpgInf( 1450, 1451, 1460, 1461, 920 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 1470, 1471, 1480, 1481, 800 )
      return .f.
   end if

   /* Meter */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       1490 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfOAlb

   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "F. Pago   : " + if( ::lAllFpg, "Todas", AllTrim( ::cFpgDes ) + " > " + AllTrim( ::cFpgHas ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'nFacturado == 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllFpg
      cExpHead       += ' .and. cCodPgo >= "' + Rtrim( ::cFpgDes ) + '" .and. cCodPgo <= "' + Rtrim( ::cFpgHas ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

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

               if !( ::lExcMov .AND. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 )                             .AND.;
                  !( ::lExcCero .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::AddAlb( .f. )

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )


//---------------------------------------------------------------------------//