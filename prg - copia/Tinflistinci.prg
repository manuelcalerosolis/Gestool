#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfListInci FROM TInfGen

   DATA  oDbfInci    AS OBJECT
   DATA  cInciOrg    AS CHARACTER
   DATA  cInciDes    AS CHARACTER

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodInci", "C",  3, 0, {|| "@!" },        "Código ",       .t., "Código",           15, .f. )
   ::AddField( "cNomInci", "C", 50, 0, {|| "@!" },        "Incidencia",    .t., "Incidencia",       50, .f. )

   ::AddTmpIndex( "CCODINCI", "CCODINCI" )

   ::lDefSerInf := .f.
   ::lDefFecInf := .f.
   ::lDefDivInf := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfInci PATH ( cPatEmp() ) FILE "TIPINCI.DBF" VIA ( cDriver() ) SHARED INDEX "TIPINCI.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfInci ) .and. ::oDbfInci:Used()
      ::oDbfInci:End()
   end if

   ::oDbfInci := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local cSayInciOrg
   local cSayInciDes
   local oSayInciOrg
   local oSayInciDes
   local oInciOrg
   local oInciDes

   if !::StdResource( "INF_INCI" )
      return .f.
   end if

   ::cInciOrg   := dbFirst( ::oDbfInci, 1 )
   ::cInciDes   := dbLast(  ::oDbfInci, 1 )
   cSayInciOrg  := dbFirst( ::oDbfInci, 2 )
   cSayInciDes  := dbLast(  ::oDbfInci, 2 )

   REDEFINE GET oInciOrg VAR ::cInciOrg;
      ID       ( 1110 ) ;
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oInciOrg:bHELP := {|| BrwIncidencia( ::oDbfInci:cAlias, oInciOrg, oSayInciOrg ) }

   REDEFINE GET oSayInciOrg VAR cSayInciOrg ;
      WHEN     .f.;
      ID       ( 1111 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oInciDes VAR ::cInciDes;
      ID       ( 1120 ) ;
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oInciDes:bHELP := {|| BrwIncidencia( ::oDbfInci:cAlias, oInciDes, oSayInciDes ) }

   REDEFINE GET oSayInciDes VAR cSayInciDes ;
      WHEN     .f.;
      ID       ( 1121 ) ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oDbfInci:Lastrec() )

   ::CreateFilter( aItmInci(), ::oDbfInci:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha                : " + Dtoc( Date() ) },;
                        {|| "Tipos de incidencias : " + AllTrim( ::cInciOrg ) + " > " + AllTrim( ::cInciDes ) } }

   ::oDbfInci:GoTop()
   while !::lBreak .and. !::oDbfInci:Eof()

      if ::oDbfInci:cCodInci >= ::cInciOrg .and. ::odbfInci:cCodInci <= ::cInciDes .and. ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cCodInci := ::oDbfInci:cCodInci
         ::oDbf:cNomInci := ::oDbfInci:cNomInci

         ::oDbf:Save()

      end if

      ::oDbfInci:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfInci:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//