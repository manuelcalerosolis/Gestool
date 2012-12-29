#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TScripts FROM TMant

   DATA   cMru          INIT "text_code_colored_16"
   DATA   cBitmap       INIT "WebTopBlack"
   DATA   oBtnEjecutar
   DATA   oBtnCompilar
   DATA   cFicheroPRG

   METHOD Activate()

   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave()

   METHOD CompilarScript()

   METHOD EjecutarScript()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TScripts

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TScripts

   DEFAULT cPath        := ::cPath

   DEFINE TABLE ::oDbf FILE "Scripts.Dbf" CLASS "Scripts" ALIAS "Scri" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Scripts"

      FIELD NAME "cCodScr"    TYPE "C" LEN   3  DEC 0 COMMENT "Código"        COLSIZE 100          OF ::oDbf
      FIELD NAME "cDesScr"    TYPE "C" LEN  35  DEC 0 COMMENT "Nombre"        COLSIZE 400          OF ::oDbf

      INDEX TO "Scripts.Cdx" TAG "cCodScr" ON "cCodScr" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "Scripts.Cdx" TAG "cDesScr" ON "cDesScr" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TScripts

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      if Empty( ::oDbf )
         if !::OpenFiles()
            return nil
         end if
      end if

      /*
      Creamos el Shell---------------------------------------------------------
      */

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      DEFINE BTNSHELL RESOURCE "BUS" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B";

         ::oWndBrw:AddSeaBar()

      DEFINE BTNSHELL RESOURCE "NEW" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecAdd() );
         ON DROP  ( ::oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         BEGIN GROUP ;
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "DUP" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDup() );
         TOOLTIP  "(D)uplicar";
         HOTKEY   "D" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "ZOOM" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecZoom() );
         TOOLTIP  "(Z)oom";
         HOTKEY   "Z" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "DEL" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         MRU ;
         HOTKEY   "E";
         LEVEL    ACC_DELE

      DEFINE BTNSHELL ::oBtnCompilar ;
         RESOURCE "gears_run_" ;
         OF       ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::CompilarScript( ::oDbf:cCodScr ) ) ;
         TOOLTIP  "(C)ompilar";
         HOTKEY   "C" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL ::oBtnEjecutar ;
         RESOURCE "Flash_" ;
         OF       ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::EjecutarScript() ) ;
         TOOLTIP  "E(j)ecutar";
         HOTKEY   "J" ;
         LEVEL    ACC_ZOOM

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TScripts

   local oDlg
   local oGet
   local oScript
   local cScript
   local oFont       := TFont():New( "Courier New", 8, 18, .f., .t. )

   if nMode != APPD_MODE

      ::cFicheroPRG  := cPatScript() + ::oDbf:cCodScr + ".prg"

      if File( ::cFicheroPRG )
         cScript     := MemoRead( ::cFicheroPRG )
      end if

   end if

   DEFINE DIALOG oDlg RESOURCE "SCRIPTS" TITLE LblTitle( nMode ) + "Script"

      REDEFINE GET oGet VAR ::oDbf:cCodScr ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesScr ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET oScript VAR cScript MEMO ;
         ID       200 ;
         FONT     oFont ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode, cScript ), oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode, cScript ), ( ::CompilarScript( ::oDbf:cCodScr ), oDlg:end( IDOK ) ), ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode, cScript ), oDlg:end( IDOK ), ) } )
      end if

      oDlg:bStart := { || oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

   if !Empty( oFont )
      oFont:End()
   end if

   ::cFicheroPRG  := ""

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode, cScript ) CLASS TScripts

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodScr, "cCodScr" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodScr ) )
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cDesScr )
      MsgStop( "La descripción del Script no puede estar vacía." )
      Return .f.
   end if

   if nMode != ZOOM_MODE

      /*
      Guardamos el fichero prg con lo que tenemos escrito en el Memo-----------
      */

      if Empty( ::cFicheroPRG )
         ::cFicheroPRG  := cPatScript() + ::oDbf:cCodScr + ".prg"
      end if

      MemoWrit( ::cFicheroPRG, cScript )

   end if

Return .t.

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

METHOD CompilarScript( cCodScr ) CLASS TScripts

   local cFichero    := cPatScript() + cCodScr + ".prg"

   WinExec( FullCurDir() + "harbour.exe " + cFichero + " /gh /n /o" + cPatScript(), 2 ) // Minimized

Return .t.

//---------------------------------------------------------------------------//

METHOD EjecutarScript() CLASS TScripts

   local cFichero
   Local pHrb
   Local u

   /*
   Comprobamos que el script haya sido compilado-------------------------------
   */

   cFichero       := cPatScript() + ::oDbf:cCodScr + ".hrb"

   if !File( cFichero )
      ::CompilarScript( ::oDbf:cCodScr )
   end if

   /*
   Ejecutamos el script compilado----------------------------------------------
   */

   if File( cFichero )

      pHrb  := __hrbLoad( cFichero )
      u     := __hrbDo( pHrb )
      __hrbUnload( pHrb )

   end if

Return .t.

//---------------------------------------------------------------------------//