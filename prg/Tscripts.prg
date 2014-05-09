#include "FiveWin.Ch"  
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TScripts FROM TMant

   DATA     cMru           INIT "text_code_colored_16"
   DATA     cBitmap        INIT "WebTopBlack"
   DATA     oBtnEjecutar
   DATA     oBtnCompilar
   DATA     cFicheroPRG
   DATA     cFicheroHbr

   DATA     oTime
   DATA     cTime
   DATA     aTime          INIT { "0 min.", "1 min.", "2 min.", "5 min.", "10 min.", "15 min.", "30 min.", "45 min.", "1 hora", "2 horas", "4 horas", "8 horas" }

   DATA     aMinutes       INIT { 0, 1, 2, 5, 10, 15, 30, 45, 60, 120, 240, 480 }

   CLASSDATA   aTimer      INIT {}

   METHOD   Activate()

   METHOD   OpenFiles( lExclusive )

   METHOD   DefineFiles()

   METHOD   Resource( nMode )

   METHOD   lPreSave()

   // Compilaciones y ejecuciones----------------------------------------------

   METHOD   CompilarFicheroScript()
   METHOD   CompilarCodigoScript( cCodScr )     INLINE ( ::CompilarFicheroScript( cPatScript() + cCodScr + ".prg" ) )

   METHOD   EjecutarFicheroScript()
   METHOD   EjecutarCodigoScript( cCodScr )     INLINE ( ::CompilarFicheroScript( cPatScript() + cCodScr + ".hbr" ) )

   METHOD   CompilarEjecutarFicheroScript( cFilePrg )

   METHOD   CompilarEjecutarCodigoScript( cCodScr ) ;  
                                                INLINE ( ::CompilarEjecutarFicheroScript( cPatScript() + cCodScr + ".prg" ) )

   METHOD   RunScript( cFichero )
   METHOD   RunCodigoScript( cCodScr )          INLINE ( ::RunScript( cPatScript() + cCodScr + ".hbr" ) )

   // Metodos para los timers--------------------------------------------------

   METHOD   StartTimer()
   METHOD   EndTimer()
   METHOD   ReStartTimer()                      INLINE ( ::EndTimer(), ::StartTimer() )

   METHOD   ActivateAllTimer()                  INLINE ( aEval( ::aTimer, {|o| o:Activate() } ) )
   METHOD   DeActivateAllTimer()                INLINE ( aEval( ::aTimer, {|o| o:DeActivate() } ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TScripts

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT  lExclusive  := .f.

   oBlock               := ErrorBlock( {| oError | ( oError ) } ) 
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TScripts
   
   local oDbf

   DEFAULT cPath        := ::cPath

   DEFINE TABLE oDbf FILE "Scripts.Dbf" CLASS "Scripts" ALIAS "Scripts" PATH ( cPath ) VIA ( cDriver() ) COMMENT "Scripts"

      FIELD NAME "cCodScr"    TYPE "C" LEN   3  DEC 0 COMMENT "Código"              COLSIZE 100    OF oDbf
      FIELD NAME "cDesScr"    TYPE "C" LEN  35  DEC 0 COMMENT "Nombre"              COLSIZE 400    OF oDbf
      FIELD NAME "nMinScr"    TYPE "N" LEN   3  DEC 0 COMMENT "Minutos"             HIDE           OF oDbf
      FIELD NAME "cCodUsr"    TYPE "C" LEN   3  DEC 0 COMMENT "Código de usuario"   HIDE           OF oDbf

      INDEX TO "Scripts.Cdx" TAG "cCodScr" ON "cCodScr" COMMENT "Código" NODELETED                 OF oDbf
      INDEX TO "Scripts.Cdx" TAG "cDesScr" ON "cDesScr" COMMENT "Nombre" NODELETED                 OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TScripts

   ::EndTimer()
 
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

      DEFINE BTNSHELL ;
         RESOURCE "Flash_" ;
         OF       ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::CompilarEjecutarCodigoScript( ::oDbf:cCodScr ) ) ;
         TOOLTIP  "E(j)ecutar";
         HOTKEY   "J" ;
         LEVEL    ACC_ZOOM

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles(), ::StartTimer() } )

   else

      msgStop( "Acceso no permitido." )

   end if
   
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TScripts

   local oDlg
   local oGet
   local oGetUsuario
   local oScript
   local cScript
   local nMinScr
   local oFont       := TFont():New( "Courier New", 8, 18, .f., .t. )

   if nMode != APPD_MODE

      ::cFicheroPRG  := cPatScript() + ::oDbf:cCodScr + ".prg"

      if File( ::cFicheroPRG )
         cScript     := MemoRead( ::cFicheroPRG )
      end if

   end if

   nMinScr           := aScan( ::aMinutes, ::oDbf:nMinScr )
   nMinScr           := Min( Max( nMinScr, 1 ), len( ::aMinutes ) )

   ::cTime           := ::aTime[ nMinScr ]

   DEFINE DIALOG oDlg RESOURCE "Scripts" TITLE LblTitle( nMode ) + "Script"

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

      REDEFINE GET oGetUsuario VAR ::oDbf:cCodUsr;
         ID       130 ;
         IDTEXT   131 ;
         BITMAP   "LUPA" ;
         VALID    ( cUser( oGetUsuario, nil, oGetUsuario:oHelpText ) );        
         OF       oDlg

      oGetUsuario:bHelp := {|| BrwUser( oGetUsuario, nil, oGetUsuario:oHelpText, .f., .f., .f., .t. ) }

      REDEFINE COMBOBOX ::oTime VAR ::cTime ;
         ITEMS    ::aTime ;
         ID       120 ;
         OF       oDlg

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
         ACTION   ( if( ::lPreSave( nMode, cScript ), ( ::CompilarCodigoScript( ::oDbf:cCodScr ), oDlg:end( IDOK ) ), ) )

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

   ::oDbf:nMinScr       := ::aMinutes[ ::oTime:nAt ]

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

METHOD CompilarFicheroScript() CLASS TScripts

   if !File( FullCurDir() + "harbour.exe" )
      msgStop( "No existe compilador" )
      Return .t.
   end if 

   if !File( ::cFicheroPrg ) 
      msgStop( "No existe el fichero " + ::cFicheroPrg )
      Return .t.
   end if 

   // Vemos si tenemos q compilar por tiempos de los ficheros------------------

   if GetFileDateTime( ::cFicheroPrg ) > GetFileDateTime( ::cFicheroHbr )

      ferase( ::cFicheroHbr )
      
      logwrite( FullCurDir() + "harbour\harbour.exe " + ::cFicheroPrg + " /i" + FullCurDir() + "include /gh /n /p /o" + ::cFicheroHbr + " > " )      
      
      waitRun( FullCurDir() + "harbour\harbour.exe " + ::cFicheroPrg + " /i" + FullCurDir() + "include /gh /n /p /o" + ::cFicheroHbr + " > " + FullCurDir() + "compile.log", 6 )

      if !file( ::cFicheroHbr )
         msgStop( "Error al compilar el fichero " + ::cFicheroHbr )
      end if

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD EjecutarFicheroScript() CLASS TScripts

   local oError
   local oBlock

   // Desactivamos todos los Scripts-------------------------------------------

   ::DeActivateAllTimer()

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      // Ejecutamos el script compilado----------------------------------------

      ::RunScript( ::cFicheroHbr )

   RECOVER USING oError

      msgStop( "Error de ejecución." + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   // Activamos todos los scripts----------------------------------------------

   ::ActivateAllTimer()

Return .t.

//---------------------------------------------------------------------------//

METHOD RunScript( cFichero ) CLASS TScripts

   local u
   local pHrb

   if File( cFichero )
      pHrb        := __hrbLoad( cFichero )
      u           := __hrbDo( pHrb )
      __hrbUnload( pHrb )   
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartTimer()

   local cCodScr
   local oTimer

   ::aTimer          := {} 

   CursorWait()

   if ::OpenFiles()

      ::oDbf:GoTop()
      while !::oDbf:Eof()

         if ( ::oDbf:nMinScr != 0 ) .and. ( Empty( ::oDbf:cCodUsr ) .or. ( ::oDbf:cCodUsr == cCurUsr() ) )
            
            cCodScr  := by( ::oDbf:cCodScr )

            oTimer   := TTimer():New( ::oDbf:nMinScr * 60000, {|| ::RunCodigoScript( cCodScr ) }, oWnd() )
            oTimer:Activate()

            aAdd( ::aTimer, oTimer ) 

         end if

         ::oDbf:Skip()

      end while

      ::CloseFiles()

   end if

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD EndTimer()

   local oTimer

   for each oTimer in ::aTimer
      oTimer:End()
   next

Return .t.

//---------------------------------------------------------------------------//

METHOD CompilarEjecutarFicheroScript( cFicheroPrg )

   if !empty( cFicheroPrg )
      ::cFicheroPrg  := cFicheroPrg
      ::cFicheroHbr  := strtran( cFicheroPrg, ".prg", ".hbr" )
   end if 

   ::CompilarFicheroScript()

   ::EjecutarFicheroScript()

Return ( Self )

//---------------------------------------------------------------------------//

Function ImportScript( oMainWindow, oBoton, cDirectory )

   local aFile
   local aDirectory  
   
   aDirectory  := Directory( cPatScript() + cDirectory + "\*.prg" )

   if !Empty( aDirectory )

      for each aFile in aDirectory
         oMainWindow:NewAt( "Document", , , {|| TScripts():CompilarEjecutarFicheroScript( cPatScript() + cDirectory + '\' + aFile[ 1 ] ) }, GetFileNoExt( Rtrim( aFile[ 1 ] ) ), , , , , oBoton )
      next 

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
