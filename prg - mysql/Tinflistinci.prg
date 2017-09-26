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