#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfXPre FROM TInfGCli

   DATA  lDesglose   AS LOGIC    INIT .t.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oPreCliT    AS OBJECT
   DATA  oPreCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendiente", "Aceptado", "Todos" }

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::DetCreateFields()

   ::AddTmpIndex ( "CCODGRC", "CCODGRC + CCODCLI + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + CLOTE" )

   ::AddGroup( {|| ::oDbf:cCodGrC }, {|| "Grupo clientes  : " + Rtrim( ::oDbf:cCodGrC ) + "-" + oRetFld( ::oDbf:cCodGrC, ::oGrpCli:oDbf) }, {||"Total grupo clientes..."} )
   ::AddGroup( {|| ::oDbf:cCodGrC + ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + Rtrim( ::oDbf:cNomCli ) }, {||"Total cliente..."} )
   ::AddGroup( {|| ::oDbf:cCodGrC + ::oDbf:cCodCli + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo..." } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPreCliT  := TDataCenter():oPreCliT()

   DATABASE NEW ::oPreCliL PATH ( cPatEmp() ) FILE "PRECLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PRECLIL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
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

   ::oPreCliT := nil
   ::oPreCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource ( cFld )

   local cEstado := "Todos"

   if !::StdResource( "INFDETGRC" )
      return .f.
   end if

   /*
   Montamos desde - hasta grupos de clientes
   */
   if !::oDefGrpCli ( 70, 71, 80, 81, 90 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   /*
   Monta los Clientes
   */

   if !::oDefCliInf( 150, 151, 160, 161, , 170 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oPreCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lDesglose ;
      ID       600 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmPreCli(), ::oPreCliT:cAlias )

   ::bPreGenerate    := {|| ::NewGroup( ::lDesglose ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lDesglose ) }

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

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Periodo       : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Grp. clientes : " + if( ::lGrpAll, "Todos", Rtrim( ::cGrpOrg ) + " > " + Rtrim( ::cGrpDes ) ) },;
                        {|| "Clientes      : " + if( ::lAllCli, "Todos", Rtrim( ::cCliOrg ) + " > " + Rtrim( ::cCliDes ) ) },;
                        {|| "Artículos     : " + if( ::lAllArt, "Todos", Rtrim( ::cArtOrg ) + " > " + Rtrim( ::cArtDes ) ) },;
                        {|| "Estado        : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oPreCliT:OrdSetFocus( "dFecPre" )
   ::oPreCliL:OrdSetFocus( "nNumPre" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lEstado .and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lEstado .and. dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecPre >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecPre <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oPreCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ), ::oPreCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oPreCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := ' !lTotLin .and. !lControl '

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oPreCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oPreCliL:cFile ), ::oPreCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oPreCliT:GoTop()

   while !::lBreak .and. !::oPreCliT:Eof()

      if ( ::lGrpAll .or. ( cGruCli( ::oPreCliT:cCodCli, ::oDbfCli ) >= ::cGrpOrg .AND. cGruCli( ::oPreCliT:cCodCli, ::oDbfCli ) <= ::cGrpDes ) ) .AND.;
         lChkSer( ::oPreCliT:cSerPre, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         if ::oPreCliL:Seek( ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre )

            while ::oPreCliT:cSerPre + Str( ::oPreCliT:nNumPre ) + ::oPreCliT:cSufPre == ::oPreCliL:cSerPre + Str( ::oPreCliL:nNumPre ) + ::oPreCliL:cSufPre .AND. ! ::oPreCliL:eof()

               if !( ::lExcCero .AND. nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  ) == 0 )

                  ::AddPre( .f. )

               end if

               ::oPreCliL:Skip()

            end while

         end if

      end if

      ::oPreCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oPreCliT:Lastrec() )

   ::oPreCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliT:cFile ) )
   ::oPreCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oPreCliL:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//