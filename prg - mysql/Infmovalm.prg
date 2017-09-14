#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfMovAlm FROM TInfGen

   DATA  oDbfTMov  AS OBJECT
   DATA  cTMovOrg  AS CHARACTER
   DATA  cTMovDes  AS CHARACTER
   DATA  lAllTMov  AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodMov",   "C",  2, 0, {|| "" },     "Código",            .t., "Tipo de movimiento",         3, .f. )
   ::AddField( "cDesMov",   "C", 20, 0, {|| "" },     "Nombre",            .t., "Descripción",               30, .f. )

   ::AddTmpIndex ( "cCodMov", "cCodMov" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfTMov PATH ( cPatDat() ) FILE "TMOV.DBF" VIA ( cDriver() ) SHARED INDEX "TMOV.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfTMov ) .and. ::oDbfTMov:Used()
      ::oDbfTMov:End()
   end if

   ::oDbfTMov := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayTMovOrg
   local cSayTMovDes
   local oSayTMovOrg
   local oSayTMovDes
   local oTMovOrg
   local oTMovDes

   if !::StdResource( "INF_TMOV01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cTMovOrg   := dbFirst( ::oDbfTMov, 1 )
   ::cTMovDes   := dbLast(  ::oDbfTMov, 1 )
   cSayTMovOrg  := dbFirst( ::oDbfTMov, 2 )
   cSayTMovDes  := dbLast(  ::oDbfTMov, 2 )

   REDEFINE CHECKBOX ::lAllTMov ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTMovOrg VAR ::cTMovOrg;
      ID       ( 70 );
      WHEN     ( !::lAllTMov );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTMovOrg:bValid   := {|| cTMov( oTMovOrg, ::oDbfTMov:cAlias, oSayTMovOrg ) }
      oTMovOrg:bHelp    := {|| browseGruposMovimientos( oTMovOrg, oSayTMovOrg, ::oDbfTMov:cAlias ) }

   REDEFINE GET oSayTMovOrg VAR cSayTMovOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTMovDes VAR ::cTMovDes;
      ID       ( 90 );
      WHEN     ( !::lAllTMov );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTMovDes:bValid   := {|| cTMov( oTMovDes, ::oDbfTMov:cAlias, oSayTMovDes ) }
      oTMovDes:bHelp    := {|| browseGruposMovimientos( oTMovDes, oSayTMovDes, ::oDbfTMov:cAlias ) }

   REDEFINE GET oSayTMovDes VAR cSayTMovDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfTMov:Lastrec() )

   ::CreateFilter( aItmMovAlm(), ::oDbfTMov:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha        : " + Dtoc( Date() ) },;
                        {|| "Mov. Almacén : " + if( ::lAllTMov, "Todos", AllTrim( ::cTMovOrg ) + " > " + AllTrim( ::cTMovDes ) ) } }

   ::oDbfTMov:OrdSetFocus( "CCODMOV" )

   ::oDbfTMov:GoTop()
      while !::lBreak .and. !::oDbfTMov:Eof()

      if ( ::lAllTMov .or. ( ::oDbfTMov:cCodMov >= ::cTMovOrg .AND. ::oDbfTMov:cCodMov <= ::cTMovDes ) ) .and.;
         ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cCodMov     := ::oDbfTMov:cCodMov
         ::oDbf:cDesMov     := ::oDbfTMov:cDesMov

         ::oDbf:Save()

      end if

      ::oDbfTMov:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfTMov:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//