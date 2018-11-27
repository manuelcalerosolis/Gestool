#include "FiveWin.Ch"  
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TScripts 

   CLASSDATA   aTimer      INIT {}

   DATA     cMru           INIT "gc_code_line_16"
   DATA     cBitmap        INIT "WebTopBlack"
   DATA     oBtnEjecutar
   DATA     oBtnCompilar
   DATA     cFicheroPRG
   DATA     cFicheroHbr

   DATA     oTime
   DATA     cTime
   DATA     aTime          INIT { "0 min.", "1 min.", "2 min.", "5 min.", "10 min.", "15 min.", "30 min.", "45 min.", "1 hora", "2 horas", "4 horas", "8 horas" }

   DATA     aMinutes       INIT { 0, 1, 2, 5, 10, 15, 30, 45, 60, 120, 240, 480 }

   // Compilaciones y ejecuciones----------------------------------------------

   METHOD   CompilarFicheroScript()
   METHOD   CompilarCodigoScript( cCodScr ) ; 
                                       INLINE ( ::CompilarFicheroScript( cPatScript() + cCodScr + ".prg" ) )

   METHOD   EjecutarFicheroScript()
   METHOD   EjecutarCodigoScript( cCodScr ) ; 
                                       INLINE ( ::CompilarFicheroScript( cPatScript() + cCodScr + ".hbr" ) )

   METHOD   CompilarEjecutarFicheroScript( cFilePrg )

   METHOD   CompilarEjecutarCodigoScript( cCodScr ) ;  
                                       INLINE ( ::CompilarEjecutarFicheroScript( cPatScript() + cCodScr + ".prg" ) )

   METHOD   RunScript( cFichero )
   METHOD   RunCodigoScript( cCodScr ) ;      
                                       INLINE ( ::RunScript( cPatScript() + cCodScr + ".hbr" ) )

   // Metodos para los timers--------------------------------------------------

   METHOD   StartTimer()
   METHOD   EndTimer()
   METHOD   ReStartTimer()             INLINE ( ::EndTimer(), ::StartTimer() )

   METHOD   getCompileHbr( cDirectorio )

   METHOD   runArrayScripts( aScripts, uParam1 )

   METHOD   getCompileFiles( aDirectory )

END CLASS

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

METHOD CompilarFicheroScript( lMessage ) CLASS TScripts

   DEFAULT lMessage := .t.

   if !File( FullCurDir() + "harbour\harbour.exe" )
      msgStop( "No existe compilador" )
      RETURN .t.
   end if 

   if !File( ::cFicheroPrg ) 
      msgStop( "No existe el fichero " + ::cFicheroPrg )
      RETURN .t.
   end if 

   // Vemos si tenemos q compilar por tiempos de los ficheros------------------

   if GetFileDateTime( ::cFicheroPrg ) > GetFileDateTime( ::cFicheroHbr )

      ferase( ::cFicheroHbr )

      if lMessage
         msginfo( FullCurDir() + "harbour\harbour.exe " + ::cFicheroPrg + " /i" + FullCurDir() + "include /gh /n /p /o" + ::cFicheroHbr + " > " + FullCurDir() + "compile.log" ) 
      end if

      logwrite( FullCurDir() + "harbour\harbour.exe " + valtoprg( ::cFicheroPrg ) + " /i" + FullCurDir() + "include /gh /n /p /o" + valtoprg( ::cFicheroHbr ) + " | " + FullCurDir() + "compile.log" )     

      waitRun( FullCurDir() + "harbour\harbour.exe " + ::cFicheroPrg + " /i" + FullCurDir() + "include /gh /n /p /o" + ::cFicheroHbr + " | " + FullCurDir() + "compile.log", 6 )

      if !file( ::cFicheroHbr )
         msgStop( "Error al compilar el fichero " + ::cFicheroHbr )
      end if

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD EjecutarFicheroScript( uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 ) CLASS TScripts

   local uReturn  := ::RunScript( ::cFicheroHbr, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

   ::ActivateAllTimer()

RETURN uReturn

//---------------------------------------------------------------------------//

METHOD RunScript( cFichero, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 ) CLASS TScripts

   local pHrb
   local oError
   local oBlock
   local uReturn

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if file( cFichero )
         pHrb        := hb_hrbLoad( cFichero )
         uReturn     := hb_hrbDo( pHrb, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )
         hb_hrbUnload( pHrb )   
      end if

   RECOVER USING oError
      msgStop( "Error de ejecución script." + CRLF + ErrorMessage( oError ) )
   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( uReturn )

//---------------------------------------------------------------------------//

METHOD EndTimer()

   local oTimer

   for each oTimer in ::aTimer
      oTimer:End()
   next

Return .t.

//---------------------------------------------------------------------------//

METHOD CompilarEjecutarFicheroScript( cFicheroPrg, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

   local uReturn

   if !empty( cFicheroPrg )
      ::cFicheroPrg  := cFicheroPrg
      ::cFicheroHbr  := strtran( cFicheroPrg, ".prg", ".hbr" )
   end if 

   ::CompilarFicheroScript()

   uReturn           := ::EjecutarFicheroScript( uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

Return ( uReturn )

//---------------------------------------------------------------------------//

METHOD StartTimer()

   local cCodScr
   local oTimer

   ::aTimer          := {} 

   CursorWait()

   oTimer   := TTimer():New( ::oDbf:nMinScr * 60000, {|| ::RunCodigoScript( cCodScr ) }, oWnd() )
   oTimer:Activate()

   aAdd( ::aTimer, oTimer ) 

   CursorWE()

Return .t.

//---------------------------------------------------------------------------//

METHOD getCompileHbr( cDirectory ) CLASS TScripts

   local aDirectory  := {}

   aDirectory        := aDirectoryEventScript( cDirectory ) 

   if !empty( aDirectory )
      Return ( ::getCompileFiles( aDirectory ) )
   end if

Return ( {} )

//---------------------------------------------------------------------------//

METHOD getCompileFiles( aDirectory ) CLASS TScripts

   local aFile
   local aFilesHbr   := {}

   for each aFile in aDirectory

      if !empty( aFile[1] )
         ::cFicheroPrg  := aFile[1]
         ::cFicheroHbr  := strtran( aFile[1], ".prg", ".hbr" )
      end if 

      ::CompilarFicheroScript( .f. )

      if file( ::cFicheroHbr )
         aAdd( aFilesHbr, ::cFicheroHbr )
      end if

   next 

Return ( aFilesHbr )

//---------------------------------------------------------------------------//

METHOD runArrayScripts( aScripts, uParam1 ) CLASS TScripts

   local cScript
   local uReturn     := .t.

   if !Empty( aScripts )

      for each cScript in aScripts

         uReturn     := ::RunScript( cScript, uParam1 )

      next

   end if

Return uReturn

//---------------------------------------------------------------------------//

FUNCTION ImportScript( oMainWindow, oBoton, cDirectory, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

   local aFile
   local aDirectory  

   aDirectory  := aDirectoryEventScript( cDirectory )

   if !empty( aDirectory )

      for each aFile in aDirectory

         oMainWindow:NewAt( "gc_document_white_", , , {|| TScripts():CompilarEjecutarFicheroScript( aFile[ 1 ], uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 ) }, GetFileNoExt( Rtrim( aFile[ 1 ] ) ), , , , , oBoton )

      next 

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION aDirectoryEventScript( cDirectory )

   local aDirectory

   aDirectory     := Directory( cPatScriptEmp() + cDirectory + "\*.prg" )
   if !empty( aDirectory )
      aEval( aDirectory, {|a| a[1] := cPatScriptEmp() + cDirectory + "\" + a[1]} )
      Return ( aDirectory )
   end if 

   aDirectory     := Directory( cPatScript() + cDirectory + "\*.prg" )
   if !empty( aDirectory )
      aEval( aDirectory, {|a| a[1] := cPatScript() + cDirectory + "\" + a[1]} )
   end if 

RETURN ( aDirectory )

//---------------------------------------------------------------------------//

FUNCTION runEventScript( cDirectory, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

   local aFile
   local aFiles
   local uReturn  
   
   aFiles         := aDirectoryEventScript( cDirectory ) 

   if empty( aFiles )
      RETURN ( nil )
   end if 

   for each aFile in aFiles

      uReturn  := TScripts():CompilarEjecutarFicheroScript( aFile[ 1 ], uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 )

      if isfalse( uReturn )
         exit
      end if 

   next 

RETURN ( uReturn )

//---------------------------------------------------------------------------//

FUNCTION runScript( cFichero, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 ) 

   if file( cPatScriptEmp() + cFichero )
      RETURN ( TScripts():CompilarEjecutarFicheroScript( cPatScriptEmp() + cFichero, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 ) )
   end if 

   if file( cPatScript() + cFichero )
      RETURN ( TScripts():CompilarEjecutarFicheroScript( cPatScript() + cFichero, uParam1, uParam2, uParam3, uParam4, uParam5, uParam6, uParam7, uParam8, uParam9, uParam10 ) )
   end if 

RETURN ( .f. )

//---------------------------------------------------------------------------//
