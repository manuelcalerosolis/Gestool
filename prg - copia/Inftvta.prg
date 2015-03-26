#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfTVta FROM TInfGen

   DATA  oDbfTVta   AS OBJECT
   DATA  cTVtaOrg   AS CHARACTER
   DATA  cTVtaDes   AS CHARACTER
   DATA  lAllTVta   AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODMOV",      "C",  2, 0, {|| "" },   "Cod. Mov.",      .t., "Tipo de movimiento",                  8, .f. )
   ::AddField( "CDESMOV",      "C", 20, 0, {|| "" },   "Nom. Mov.",      .t., "Descripción del tipo de movimiento", 20, .f. )

   ::AddTmpIndex ( "CCODMOV", "CCODMOV" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfTVta PATH ( cPatDat() )   FILE "TVTA.DBF"   VIA ( cDriver() ) SHARED INDEX "TVTA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfTVta ) .and. ::oDbfTVta:Used()
      ::oDbfTVta:End()
   end if

   ::oDbfTVta  := nil


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayTVtaOrg
   local cSayTVtaDes
   local oSayTVtaOrg
   local oSayTVtaDes
   local oTVtaOrg
   local oTVtaDes

   if !::StdResource( "INF_TVTA01" )
      return .f.
   end if

   ::cTVtaOrg   := dbFirst( ::oDbfTVta, 1 )
   ::cTVtaDes   := dbLast(  ::oDbfTVta, 1 )
   cSayTVtaOrg  := dbFirst( ::oDbfTVta, 2 )
   cSayTVtaDes  := dbLast(  ::oDbfTVta, 2 )

   REDEFINE CHECKBOX ::lAllTVta ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTVtaOrg VAR ::cTVtaOrg;
      ID       ( 70 );
      WHEN     ( !::lAllTVta );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTVtaOrg:bValid   := {|| cTVta( oTVtaOrg, ::oDbfTVta:cAlias, oSayTVtaOrg ) }
      oTVtaOrg:bHelp    := {|| BrwTVta( oTVtaOrg, ::oDbfTVta:cAlias, oSayTVtaOrg ) }

   REDEFINE GET oSayTVtaOrg VAR cSayTVtaOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTVtaDes VAR ::cTVtaDes;
      ID       ( 90 );
      WHEN     ( !::lAllTVta );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTVtaDes:bValid   := {|| cTVta( oTVtaDes, ::oDbfTVta:cAlias, oSayTVtaDes ) }
      oTVtaDes:bHelp    := {|| BrwTVta( oTVtaDes, ::oDbfTVta:cAlias, oSayTVtaDes ) }

   REDEFINE GET oSayTVtaDes VAR cSayTVtaDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oDbfTVta:Lastrec() )

   ::CreateFilter( aItmTVta(), ::oDbfTVta:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha          : " + Dtoc( Date() ) },;
                        {|| "Tipos de venta : " + if( ::lAllTVta, "Todos", AllTrim( ::cTVtaOrg ) + " > " + AllTrim( ::cTVtaDes ) ) } }

   ::oDbfTVta:OrdSetFocus( "CCODMOV" )

   ::oDbfTVta:GoTop()
   while !::lBreak .and. !::oDbfTVta:Eof()

      if ( ::lAllTVta .or. ( ::oDbfTVta:cCodMov >= ::cTVtaOrg .AND. ::oDbfTVta:cCodMov <= ::cTVtaDes ) )

         ::oDbf:Append()

         ::oDbf:cCodMov   := ::oDbfTVta:cCodMov
         ::oDbf:cDesMov   := ::oDbfTVta:cDesMov

         ::oDbf:Save()

      end if

      ::oDbfTVta:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfTVta:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//