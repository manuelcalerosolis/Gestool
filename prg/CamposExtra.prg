#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

static oCamposExtra

//---------------------------------------------------------------------------//

CLASS TCamposExtra FROM TMant

   DATA  cMru              INIT  "form_green_add_16"
   DATA  cBitmap           INIT  Rgb( 128, 57, 123 )

   DATA  oDlg

   DATA  lOpenFiles        INIT .f.      

   DATA  oCodigo
   DATA  oNombre
   DATA  oLongitud
   DATA  oDecimales

   Method New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   Method DefineFiles()

   Method Activate()

   Method OpenFiles( lExclusive )
   Method CloseFiles()

   Method OpenService( lExclusive )
   Method CloseService()

   Method Reindexa( oMeter )

   Method Resource( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TCamposExtra

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "01124"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

   ::bFirstKey             := {|| ::oDbf:cCodigo }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TCamposExtra

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "CAMPOEXTRA.DBF" CLASS "CAMPOEXTRA" ALIAS "CAMPOEXTRA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Campos extra"

      FIELD NAME "cCodigo"       TYPE "C" LEN   3  DEC 0 PICTURE "@!" COMMENT "Código"                 COLSIZE 100    OF ::oDbf
      FIELD NAME "cNombre"       TYPE "C" LEN 100  DEC 0 PICTURE "@!" COMMENT "Descripción"            COLSIZE 600    OF ::oDbf
      FIELD NAME "mDocumento"    TYPE "M" LEN  10  DEC 0              COMMENT "Documentos"             HIDE           OF ::oDbf
      FIELD NAME "lRequerido"    TYPE "L" LEN   1  DEC 0              COMMENT "Campo obligatorio"      HIDE           OF ::oDbf
      FIELD NAME "nTipo"         TYPE "N" LEN   1  DEC 0              COMMENT "Tipo de campo"          HIDE           OF ::oDbf
      FIELD NAME "nLongitud"     TYPE "N" LEN   3  DEC 0              COMMENT "Longitud campo"         HIDE           OF ::oDbf
      FIELD NAME "nDecimales"    TYPE "N" LEN   1  DEC 0              COMMENT "Decimales campo"        HIDE           OF ::oDbf
      FIELD NAME "mDefecto"      TYPE "M" LEN  10  DEC 0              COMMENT "Valores por defecto"    HIDE           OF ::oDbf

      INDEX TO "CAMPOEXTRA.Cdx" TAG "cCodigo"   ON "cCodigo"   COMMENT "Código"        NODELETED OF ::oDbf
      INDEX TO "CAMPOEXTRA.Cdx" TAG "cNombre"   ON "cNombre"   COMMENT "Descripción"   NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TCamposExtra

   local oSnd
   local oDel
   local oImp
   local oPrv

   if nAnd( ::nLevel, 1 ) == 0

      /*
      Cerramos todas las ventanas----------------------------------------------
      */

      if ::oWndParent != nil
         ::oWndParent:CloseAll()
      end if

      ::CreateShell( ::nLevel )

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

      DEFINE BTNSHELL oDel RESOURCE "DEL" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::oWndBrw:RecDel() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E";
         LEVEL    ACC_DELE

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   else

      msgStop( "Acceso no permitido." )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TCamposExtra

   local oError
   local oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive         := .f.

   BEGIN SEQUENCE

   if !::lOpenFiles

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::lLoadDivisa()

      ::lOpenFiles         := .t.

   end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TCamposExtra

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil

   ::lOpenFiles   := .f.

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TCamposExtra

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::CloseFiles()

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TCamposExtra

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TCamposExtra

   if Empty( ::oDbf )
      ::oDbf      := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS TCamposExtra

   local oBmp
   local oBtnAceptar
   local oBtnCancelar

   DEFINE DIALOG ::oDlg RESOURCE "EXTRA" TITLE LblTitle( nMode ) + "campo extra"

   REDEFINE BITMAP oBmp ;
      ID       600 ;
      RESOURCE "form_green_add_48_alpha" ;
      TRANSPARENT ;
      OF       ::oDlg
   
   REDEFINE GET ::oCodigo VAR ::oDbf:cCodigo ;
      ID       100 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       ::oDlg

   REDEFINE GET ::oNombre VAR ::oDbf:cNombre ;
      ID       110 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       ::oDlg

   REDEFINE CHECKBOX ::oDbf:lRequerido ;
      ID       120 ;
      WHEN     ( nMode != ZOOM_MODE ) ;
      OF       ::oDlg









   REDEFINE GET ::oLongitud VAR ::oDbf:nLongitud ;
      ID       140 ;
      PICTURE  "999" ;
      SPINNER ;
      MIN      1 ;
      MAX      200 ;
      OF       ::oDlg   

   REDEFINE GET ::oDecimales VAR ::oDbf:nDecimales ;
      ID       150 ;
      PICTURE  "9" ;
      SPINNER ;
      MIN      1 ;
      MAX      6 ;
      OF       ::oDlg




   REDEFINE BUTTON oBtnAceptar ;
      ID       IDOK ;
      OF       ::oDlg ;
      ACTION   ( ::oDlg:End( IDOK ) )

   REDEFINE BUTTON oBtnCancelar ;
      ID       IDCANCEL ;
      OF       ::oDlg ;
      CANCEL ;
      ACTION   ( ::oDlg:End( IDCANCEL ) )

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION CamposExtra( oMenuItem, oWnd ) 

   DEFAULT  oMenuItem   := "01124"
   DEFAULT  oWnd        := oWnd()

   if Empty( oCamposExtra )

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         SysRefresh(); oWnd:CloseAll(); SysRefresh()
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      AddMnuNext( "Campos extra", ProcName() )

      oCamposExtra        := TCamposExtra():New( cPatEmp(), oWnd, oMenuItem )
      
      if !Empty( oCamposExtra )
         oCamposExtra:Play()
      end if

      oCamposExtra         := nil

   end if

RETURN NIL

//--------------------------------------------------------------------------//