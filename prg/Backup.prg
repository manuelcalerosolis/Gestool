#include "FiveWin.Ch"
#include "Folder.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"

#define FO_READ         0
#define FO_READWRITE    2
#define FS_SET          0
#define FS_END          2
#define FC_NORMAL       0

#define F_NAME          1
#define F_SIZE          2
#define F_DATE          3
#define F_TIME          4
#define F_ATTR          5

#define NL  				Chr( 10 ) + Chr( 13 )

CLASS TBackup

   DATA oDbfEmpresa
   DATA oDbf

   DATA nLevel

   DATA lDate           INIT .f.

   // Variables para el manejo de los ficheros del backup

   DATA nBytes          INIT 0
   DATA nDisks          INIT 0
   DATA nActualSize     INIT 0
   DATA nFileSize       INIT 0
   DATA aFiles          INIT {}
   DATA nActualFile     INIT 0
   DATA aMsgs           INIT {}
   DATA nTotalFiles     INIT 0
   DATA bk_Serial       INIT ""
   DATA bk_Bytes        INIT 0
   DATA bk_NumFiles     INIT 0
   DATA bk_DiskNum      INIT 0

   // Variables para el manejo del dialogo

   DATA  aEmp
   DATA  aBmp
   DATA  oDlg
   DATA  oFld
   DATA  oBotonAnterior
   DATA  oBotonSiguiente
   DATA  oBotonTerminar
   DATA  oBotonImprimir
   DATA  oAccion
   DATA  nAccion
   DATA  oBrwSave
   DATA  oBrwRestore
   DATA  oBrwHistorial
   DATA  oProgreso
   DATA  nProgreso
   DATA  oProgresoTarget
   DATA  nProgresoTarget
   DATA  oProgresoInternet
   DATA  nProgresoInternet
   DATA  oProgresoRestore
   DATA  nProgresoRestore
   DATA  oDir
   DATA  cDir
   DATA  oDirOrigen
   DATA  cDirOrigen              INIT ""
   DATA  oResultado
   DATA  mResultado

   DATA  oChkPasswordRestore
   DATA  oPasswordRestore
   DATA  cPasswordRestore        INIT Space( 100 )
   DATA  lPasswordRestore        INIT .f.

   DATA  oChkDir
   DATA  lDir
   DATA  oChkInternet
   DATA  lInternet
   DATA  oUserInternet
   DATA  cUserInternet
   DATA  oPasswordInternet
   DATA  cPasswordInternet

   DATA  oChkPassword
   DATA  lPassword
   DATA  oPassword1
   DATA  cPassword1
   DATA  oPassword2
   DATA  cPassword2

   DATA  oFile
   DATA  cFile

   DATA  aBackupFiles

   METHOD Create( cPath )

   METHOD New( oMenuItem, oWnd )

   METHOD DefineFiles()

   METHOD OpenFiles()
   METHOD OpenService( lExclusive, cPath )   INLINE ( ::OpenFiles( lExclusive, cPath ))

   METHOD BuildFiles( cPath )                INLINE ( ::DefineFiles( cPath ):Create() )

   METHOD CloseFiles()

   METHOD MuestraDialogo()

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

   METHOD ZipFiles()

   METHOD doBackup( aFiles, cDriveTo )
   METHOD doRestore( cFileFrom )

   METHOD doFtp( aFiles )

   METHOD SaveToDisk( cFile )
   METHOD RestoreFromDisk( cFile )

   METHOD cGetFilesToRestore()

   METHOD GetZipFiles()

   METHOD RestoreZipFiles()

   METHOD CleanDisk( cDriveTo )

   METHOD CargarPreferencias()

   METHOD GuardarPreferencias()

   METHOD SyncAllDbf()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   ::oDbf      := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd )

   DEFAULT oWnd      := oWnd()
   DEFAULT oMenuItem := "01075"

   ::nTotalFiles     := 0
   ::nActualFile     := 0
   ::nActualSize     := 0
   ::aEmp            := {}

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::nLevel          := Auth():Level( oMenuItem )
   if nAnd( ::nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN ( nil )
   end if

   ::DefineFiles()

   if ::OpenFiles()
      ::MuestraDialogo()
   end if

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath)

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., .t. )

      DATABASE NEW ::oDbfEmpresa PATH ( cPatDat() ) FILE "Empresa.Dbf" VIA ( cDriver() ) SHARED INDEX "Empresa.Cdx"

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   local oBlock   := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   local lOpen    := .T.

   BEGIN SEQUENCE

      if !Empty( ::oDbfEmpresa ) .and. ( ::oDbfEmpresa:Used() )
         ::oDbfEmpresa:End()
      end if 

      ::oDbf:End()

   RECOVER

      msgStop( "Imposible cerrar todas las bases de datos.","Atención" )

      lOpen       := .F.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD MuestraDialogo()

   local oBmp

   while !::oDbfEmpresa:Eof()
      if !::oDbfEmpresa:lGrupo
         aAdd( ::aEmp, { ( cCodEmp() == ::oDbfEmpresa:CodEmp  ), ::oDbfEmpresa:CodEmp, ::oDbfEmpresa:cNombre } )
      end if
      ::oDbfEmpresa:Skip()
   end do

   ::CargarPreferencias()

   // Caja de Dialogo----------------------------------------------------------

   DEFINE DIALOG ::oDlg RESOURCE "Backup_0" OF oWnd()

   REDEFINE BITMAP oBmp;
         RESOURCE "gc_shield_48" ;
         ID       500 ;
         TRANSPARENT ;
         OF       ::oDlg

   REDEFINE PAGES ::oFld ;
         ID       10;
         OF       ::oDlg ;
         DIALOGS  "Backup_1", "Backup_2", "Backup_3", "Backup_4", "Backup_5", "Backup_2", "Backup_8", "Backup_6", "Backup_7"

   // Definicion de botones de la ventana principal----------------------------

   REDEFINE BUTTON ::oBotonAnterior ;           // Boton de Anterior
         ID       20 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBotonSiguiente ;         // Boton de Siguiente
         ID       30 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonSiguiente() )

   REDEFINE BUTTON ::oBotonTerminar ;          // Boton de salida
         ID       40 ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end() )

   REDEFINE BUTTON ::oBotonImprimir ;          // Boton de imprimir
         ID       50 ;
         OF       ::oDlg ;
         ACTION   ( ImprimirODbf( ::oDbf, "Copia de Seguridad " ) )

   REDEFINE RADIO ::oAccion VAR ::nAccion ;
         ID       100, 110, 120 ;
         OF       ::oFld:aDialogs[ 1 ]

   // Browse de empresas a copiar----------------------------------------------

   ::oBrwSave                        := IXBrowse():New( ::oFld:aDialogs[ 2 ] )

   ::oBrwSave:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwSave:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwSave:SetArray( ::aEmp )

   ::oBrwSave:nMarqueeStyle          := 5

   ::oBrwSave:lVScroll               := .f.

   ::oBrwSave:CreateFromResource( 200 )

   with object ( ::oBrwSave:aCols[ 1 ] )
      :cHeader       := ""
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::aEmp[ ::oBrwSave:nArrayAt, 1 ] }
      :nWidth        := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwSave:aCols[ 2 ] )
      :cHeader       := "Código"
      :bEditValue    := {|| ::aEmp[ ::oBrwSave:nArrayAt, 2 ] }
      :nWidth        := 40
   end with

   with object ( ::oBrwSave:aCols[ 3 ] )
      :cHeader       := "Empresa"
      :bEditValue    := {|| ::aEmp[ ::oBrwSave:nArrayAt, 3 ] }
      :nWidth        := 260
   end with

   ::oBrwSave:bLDblClick   := {|| ::aEmp[ ::oBrwSave:nArrayAt, 1 ] := !::aEmp[ ::oBrwSave:nArrayAt, 1 ], ::oBrwSave:Refresh() }

   REDEFINE BUTTON ;
         ID       230 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( ::aEmp[ ::oBrwSave:nArrayAt, 1 ] := !::aEmp[ ::oBrwSave:nArrayAt, 1 ], ::oBrwSave:Refresh() )

   REDEFINE BUTTON ;
         ID       210 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aEmp, { |aItem| aItem[ 1 ] := .t. } ), ::oBrwSave:Refresh() )

   REDEFINE BUTTON ;
         ID       220 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aEmp, { |aItem| aItem[ 1 ] := .f. } ), ::oBrwSave:Refresh() )

   // Caja de dialogo BACKUP_3 ------------------------------------------------

   REDEFINE CHECKBOX ::oChkDir VAR ::lDir ;
         ID       100 ;
         OF       ::oFld:aDialogs[ 3 ]

   REDEFINE GET ::oDir VAR ::cDir ;
         ID       110 ;
         WHEN     ::lDir ;
         BITMAP   "FOLDER" ;
         OF       ::oFld:aDialogs[ 3 ]

   ::oDir:bHelp   := {|| ::oDir:cText( cGetDir32( "Seleccione destino" ) ) }

   REDEFINE CHECKBOX ::oChkInternet VAR ::lInternet ;
         ID       120 ;
         OF       ::oFld:aDialogs[ 3 ]

   REDEFINE GET ::oUserInternet VAR ::cUserInternet ;
         ID       130 ;
         WHEN     ::lInternet ;
         OF       ::oFld:aDialogs[ 3 ]

   REDEFINE GET ::oPasswordInternet VAR ::cPasswordInternet ;
         ID       140 ;
         WHEN     ::lInternet ;
         OF       ::oFld:aDialogs[ 3 ]

   REDEFINE GET ::oFile VAR ::cFile ;
         ID       160 ;
         BITMAP   "FOLDER" ;
         OF       ::oFld:aDialogs[ 3 ]

   ::oFile:bHelp  := {|| ::oFile:cText( cGetFile( 'Doc ( *.txt ) | *.txt', 'Seleccione el nombre del fichero' ) ) }

   // Password para la copia de seguridad--------------------------------------

   REDEFINE CHECKBOX ::oChkPassword VAR ::lPassword ;
         ID       170 ;
         OF       ::oFld:aDialogs[ 3 ]

   REDEFINE GET ::oPassword1 VAR ::cPassword1 ;
         ID       180 ;
         WHEN     ::lPassword ;
         OF       ::oFld:aDialogs[ 3 ]

   REDEFINE GET ::oPassword2 VAR ::cPassword2 ;
         ID       190 ;
         WHEN     ::lPassword ;
         OF       ::oFld:aDialogs[ 3 ]

   //caja de dialogo BACKUP_4 -------------------------------------------------

   REDEFINE APOLOMETER ::oProgreso ;
         VAR      ::nProgreso ;
         BARCOLOR nRgb( 128, 255, 0 ), nRgb( 255, 255, 255 ) ;
         ID       400 ;
         OF       ::oFld:aDialogs[ 4 ]

   REDEFINE APOLOMETER ::oProgresoTarget ;
         VAR      ::nProgresoTarget ;
         BARCOLOR nRgb( 128, 255, 0 ), nRgb( 255, 255, 255 ) ;
         ID       410 ;
         OF       ::oFld:aDialogs[ 4 ]

   REDEFINE APOLOMETER ::oProgresoInternet ;
         VAR      ::nProgresoInternet ;
         BARCOLOR nRgb( 128, 255, 0 ), nRgb( 255, 255, 255 ) ;
         ID       420 ;
         OF       ::oFld:aDialogs[ 4 ]

   //caja de dialogo BACKUP_5 -------------------------------------------------

   REDEFINE GET ::oDirOrigen VAR ::cDirOrigen ;
         ID       530 ;
         COLOR    CLR_GET ;
         BITMAP   "FOLDER" ;
         OF       ::oFld:aDialogs[ 5 ]

   ::oDirOrigen:bHelp   := {|| ::oDirOrigen:cText( cGetFile( "Copias ( *.Seg ) | *.Seg", "Seleccione fichero de copia", 1 ) ) }

   REDEFINE CHECKBOX ::oChkPasswordRestore VAR ::lPasswordRestore ;
         ID       550 ;
         OF       ::oFld:aDialogs[ 5 ]

   REDEFINE GET ::oPasswordRestore VAR ::cPasswordRestore ;
         ID       540 ;
         WHEN     ::lPasswordRestore ;
         OF       ::oFld:aDialogs[ 5 ]

   // Caja de dialogo backup_6 ------------------------------------------------

   ::oBrwRestore                        := IXBrowse():New( ::oFld:aDialogs[ 6 ] )

   ::oBrwRestore:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwRestore:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwRestore:SetArray( ::aEmp )

   ::oBrwRestore:nMarqueeStyle          := 5

   ::oBrwRestore:lVScroll               := .f.
   ::oBrwRestore:lRecordSelector        := .f.

   ::oBrwRestore:CreateFromResource( 200 )

   with object ( ::oBrwRestore:aCols[ 1 ] )
      :cHeader       := "Se. Seleccionada"
      :bStrData      := {|| "" }
      :bEditValue    := {|| ::aEmp[ ::oBrwRestore:nArrayAt, 1 ] }
      :nWidth        := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwRestore:aCols[ 2 ] )
      :cHeader       := "Código"
      :bEditValue    := {|| ::aEmp[ ::oBrwRestore:nArrayAt, 2 ] }
      :nWidth        := 40
   end with

   with object ( ::oBrwRestore:aCols[ 3 ] )
      :cHeader       := "Empresa"
      :bEditValue    := {|| ::aEmp[ ::oBrwRestore:nArrayAt, 2 ] }
      :nWidth        := 280
   end with

   ::oBrwRestore:bLDblClick   := {|| ::aEmp[ ::oBrwRestore:nArrayAt, 1 ] := !::aEmp[ ::oBrwRestore:nArrayAt, 1 ], ::oBrwRestore:Refresh() }

   REDEFINE BUTTON ;
      ID       230 ;
      OF       ::oFld:aDialogs[ 6 ] ;
      ACTION   ( ::aEmp[ ::oBrwRestore:nArrayAt, 1 ] := !::aEmp[ ::oBrwRestore:nArrayAt, 1 ], ::oBrwRestore:Refresh() )

   REDEFINE BUTTON ;
      ID       210 ;
      OF       ::oFld:aDialogs[ 6 ] ;
      ACTION   ( aEval( ::aEmp, { |aItem| aItem[1] := .t. } ), ::oBrwRestore:Refresh() )

   REDEFINE BUTTON ;
      ID       220 ;
      OF       ::oFld:aDialogs[ 6 ] ;
      ACTION   ( aEval( ::aEmp, { |aItem| aItem[1] := .f. } ), ::oBrwRestore:Refresh() )

   //caja de dialogo BACKUP_9

   REDEFINE APOLOMETER ::oProgresoRestore ;
      VAR      ::nProgresoRestore ;
      ID       400 ;
      OF       ::oFld:aDialogs[ 7 ]

   //caja de dialogo BACKUP_7

   REDEFINE GET   ::oResultado ;
      VAR      ::mResultado ;
      MEMO ;
      READONLY;
      WHEN     .f. ;
      ID       600 ;
      OF       ::oFld:aDialogs[ 8 ]

   //caja de dialogo BACKUP_8

   ::oBrwHistorial                 := IXBrowse():New( ::oFld:aDialogs[ 9 ] )

   ::oDbf:SetBrowse( ::oBrwHistorial )

   ::oBrwHistorial:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwHistorial:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwHistorial:nMarqueeStyle   := 5
   ::oBrwHistorial:nRowHeight      := 44
   ::oBrwHistorial:nDataLines      := 3

   ::oBrwHistorial:CreateFromResource( 700 )

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader          := "Fecha"
         :bEditValue       := {|| Dtoc( ::oDbf:Fecha ) }
         :nWidth           := 70
      end with

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader          := "Hora"
         :bEditValue       := {|| ::oDbf:Hora }
         :nWidth           := 60
      end with

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ::oDbf:Usuario }
         :nWidth           := 30
      end with

      with object ( ::oBrwHistorial:AddCol() )
         :cHeader          := "Resumen"
         :bEditValue       := {|| ::oDbf:Resumen }
         :nWidth           := 300
      end with

      // Opciones generales de la ventana

      ::oDlg:bStart        := {|| ::oBotonAnterior:Hide(), ::oBotonImprimir:Hide() }

   ACTIVATE DIALOG ::oDlg CENTERED

   ::GuardarPreferencias()

   oBmp:End()

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD CargarPreferencias()

   local oIniApp                 := TIni():New( cIniAplication() )

   ::cDirOrigen                  := PadR( oIniApp:Get( "Backup", "Origen",             "C:\",                  ::cDirOrigen ),         200 )
   ::cDir                        := PadR( oIniApp:Get( "Backup", "Destino",            "C:\",                  ::cDir ),               200 )
   ::cFile                       := PadR( oIniApp:Get( "Backup", "Informe",            "C:\InfomeCopia.Txt",   ::cFile ),              200 )
   ::cUserInternet               := PadR( oIniApp:Get( "Backup", "UserInternet",       "",                     ::cUserInternet ),      100 )
   ::cPasswordInternet           := PadR( oIniApp:Get( "Backup", "PasswordInternet",   "",                     ::cPasswordInternet ),  100 )

   ::cPassword1                  := PadR( oIniApp:Get( "Backup", "PasswordCopia",      "",                     ::cPassword1 ),         100 )
   ::cPassword2                  := ::cPassword1

   ::lDir                        := oIniApp:Get( "Backup", "Local",     .t. )
   ::lInternet                   := oIniApp:Get( "Backup", "Internet",  .t. )
   ::lPassword                   := oIniApp:Get( "Backup", "Copia",     .t. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GuardarPreferencias()

   local oIniApp                 := TIni():New( cIniAplication() )

   oIniApp:Set( "Backup",  "Origen",            ::cDirOrigen )
   oIniApp:Set( "Backup",  "Destino",           ::cDir )
   oIniApp:Set( "Backup",  "Ultimo",            Dtos( Date() ) )
   oIniApp:Set( "Backup",  "Informe",           ::cFile )

   oIniApp:Set( "Backup",  "Internet",          ::lInternet )
   oIniApp:Set( "Backup",  "UserInternet",      ::cUserInternet )
   oIniApp:Set( "Backup",  "PasswordInternet",  ::cPasswordInternet )

   oIniApp:Set( "Backup",  "Local",             ::lDir )

   oIniApp:Set( "Backup",  "Copia",             ::lPassword )
   oIniApp:Set( "Backup",  "PasswordCopia",     ::cPassword1 )

RETURN ( Self )

//---------------------------------------------------------------------------//
//
//procesos a realizar al pulsar sobre siguiente de la ventana principal
//

METHOD BotonSiguiente()

   local n
   local lSeleccionado

   do case
      case ::oFld:nOption == 1 .and. ::nAccion == 1
         ::oFld:GoNext()
         ::oBotonAnterior:Show()

      case ::oFld:nOption == 1 .and. ::nAccion == 2
         ::oFld:SetOption( 5 )
         ::oBotonAnterior:Show()

      case ::oFld:nOption == 1 .and. ::nAccion == 3
         ::oFld:SetOption( 9 )
         ::oBotonSiguiente:Disable()
         ::oBotonAnterior:Show()
         ::oBotonImprimir:Show()
         SetWindowText( ::oBotonTerminar:hWnd, "&Cerrar" )

      case ::oFld:nOption == 2

         lSeleccionado  := .f.

         for n := 1 TO len( ::aEmp )
            if ::aEmp[ n, 1 ]
               lSeleccionado := .t.
            endif
         next

         if lSeleccionado
            SetWindowText( ::oBotonSiguiente:hWnd, "&Terminar" )
            ::oFld:GoNext()
         else
            msgStop( "No ha seleccionado ninguna empresa", "Atención" )
         end if

      case ::oFld:nOption == 3  //hacer una copia de seguridad

         if ::lPassword .and. ::cPassword1 != ::cPassword2
            msgStop( "Las contraseñas para las copias de seguridad, no coinciden", "Atención" )
            RETURN ( Self )
         end if

         if !::lDir .and. !::lInternet
            msgStop( "Debe especificar al menos un destino para la copia", "Atención" )
            RETURN ( Self )
         end if

         if ( !::lDir ) .or. ( len( alltrim( ::cDir ) ) > 0 )

            ::oFld:GoNext()
            ::oBotonAnterior:Disable()
            ::oBotonSiguiente:Disable()

            ::ZipFiles()

            ::oDlg:Enable()

            SetWindowText( ::oBotonTerminar:hWnd, "&Cerrar" )

            ::oBotonSiguiente:Hide()
            ::oBotonAnterior:Hide()

            ::oFld:SetOption( 8 )

         else

            msgStop( "Debe especificar el lugar de destino", "Atención" )

         endif

      case ::oFld:nOption == 4

         ::oDlg:End()

      // Restaurar una copia de seguridad

      case ::oFld:nOption == 5

         if len( AllTrim( ::cDirOrigen ) ) > 0
            ::cGetFilesToRestore()
            ::GetZipFiles()
            ::oFld:SetOption( 6 )
         else
            msgStop( "Debe especificar el lugar de origen", "Atención" )
         endif

      // Restaurar una copia de seguridad

      case ::oFld:nOption == 6

         ::oFld:SetOption( 7 )

         ::RestoreZipFiles()
         ::GuardarPreferencias()
         ::oDlg:End()

      //caso en el que estemos en la pantalla 6

      case ::oFld:nOption == 7
         //caso en el que estemos en la pantalla 7

   end case

RETURN ( Self )

//-----------------------------------------------------------------------//
//
//procesos a realizar al pulsar sobre anterior de la ventana principal
//

METHOD BotonAnterior()

   do case
      case ::oFld:nOption == 1
         //a este caso nunca deberia de llegar

      case ::oFld:nOption == 2
         ::oBotonAnterior:hide()
         ::oFld:GoPrev()

      case ::oFld:nOption == 3
         SetWindowText( ::oBotonSiguiente:hWnd, "&Siguiente >" )
         ::oFld:GoPrev()

      case ::oFld:nOption == 4
         ::oFld:GoPrev()

      case ::oFld:nOption == 5
         ::oBotonAnterior:hide()
         SetWindowText( ::oBotonSiguiente:hWnd, "&Siguiente >" )
         ::oFld:SetOption( 1 )

      case ::oFld:nOption == 6
         ::oFld:GoPrev()

      case ::oFld:nOption == 7 .or. ::oFld:nOption == 8 .or. ::oFld:nOption == 9
         ::oBotonAnterior:hide()
         ::oFld:SetOption( 1 )
         ::oBotonSiguiente:Enable()
         ::oBotonImprimir:Hide()
         SetWindowText( ::oBotonTerminar:hWnd, "&Cancelar" )

   end case

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD ZipFiles()

	local n
   local nZip
   local cZip
   local cGrp
   local cDat
   local aDir
   local cRes           := ""
   local aFil           := {}
   local lSel           := .f.
   local cCodGrp        := Space(2)
   local cPassword
   local aEstructura    := {}

   ::aMsgs              := {}

   if !Empty( ::oDlg )
      ::oDlg:Disable()
   end if

   if !empty( ::cPassword1 )
      cPassword         := rtrim( ::cPassword1 )
   end if 

   aeval( directory( cPatSafe() + "*.*" ), {|aFiles| fErase( cPatSafe() + aFiles[ 1 ] ) } )

   /*
   Backup de la base de datos SQL----------------------------------------------
   */

   ::oProgreso:cText    := "Copiando datos de SQL"

   cZip                 := cPatSafe() + "gestool"

   if ::lDate
      cZip              += dtos( date() )
   end if

   cZip                 += ".sql"

   getSQLDataBase():Export( cZip )

   aadd( aFil, cZip )

   SysRefresh()

   /*
   Comprimiendo los archivos---------------------------------------------------
   */

   for n := 1 to len( ::aEmp )

      if ::aEmp[ n, 1 ]

         lSel                 := .t.

         cZip                 := cPatSafe() + "Emp" + ::aEmp[ n, 2 ]
         if ::lDate
            cZip              += dtos( date() )
         end if
         cZip                 += ".zip"

         if file( cZip )
            ferase( cZip )
         end if

         ::nActualFile        := 0
         aDir                 := Directory( FullCurDir() + "EMP" + ::aEmp[ n, 2 ] + "\*.*" )

         ::oProgreso:SetTotal( len( aDir ) )
         ::oProgreso:cText    := "Comprimiendo " + ::aEmp[ n, 2 ] + "-" + Rtrim( ::aEmp[ n, 3 ] )

         hb_setdiskzip( {|| nil } )
         aeval( aDir, { | cName, nIndex | hb_ZipFile( cZip, FullCurDir() + "Emp" + ::aEmp[ n, 2 ] + "\" + cName[ 1 ], 9, , , cPassword, ::oProgreso:Set( nIndex ) ) } )
         hb_gcall()

         aadd( aFil, cZip )

      end if

      SysRefresh()

   next

   /*
   Ahora el directorio de DATOS------------------------------------------------
   */

   if lSel

      cDat                 := cPatSafe() + "Datos"
      if ::lDate
         cDat              += Dtos( Date() )
      end if
      cDat                 += ".Zip"

      if file( cDat )
         ferase( cDat )
      end if

      ::nActualFile        := 0
      aDir                 := Directory( FullCurDir() + "Datos\*.*" )

      ::oProgreso:SetTotal( Len( aDir ) )
      ::oProgreso:cText    := "Comprimiendo directorio de datos generales"

      hb_setdiskzip( {|| nil } )
      aeval( aDir, { | cName, nIndex | hb_ZipFile( cDat, FullCurDir() + "Datos\" + cName[ 1 ], 9, , , cPassword, ::oProgreso:Set( nIndex ) ) } )
      hb_gcall()

      aadd( aFil, cDat )

      /*
      Ahora el directorio de database---------------------------------------------
      */

      cDat                 := cPatSafe() + "Database"
      if ::lDate
         cDat              += Dtos( Date() )
      end if
      cDat                 += ".Zip"

      if file( cDat )
         ferase( cDat )
      end if

      ::nActualFile        := 0
      aDir                 := Directory( FullCurDir() + "Database\*.*" )

      ::oProgreso:SetTotal( Len( aDir ) )
      ::oProgreso:cText    := "Comprimiendo directorio de bases de datos"

      hb_SetDiskZip( {|| nil } )
      aEval( aDir, { | cName, nIndex | hb_ZipFile( cDat, FullCurDir() + "Database\" + cName[ 1 ], 9, , , cPassword, ::oProgreso:Set( nIndex ) ) } )
      hb_gcAll()

      aAdd( aFil, cDat ) 

      /*
      Ahora el directorio de SCRIPTS-------------------------------------------
      */

      cDat                 := cPatSafe() + "script"
      if ::lDate
         cDat              += Dtos( Date() )
      end if
      cDat                 += ".Zip"

      if file( cDat )
         ferase( cDat )
      end if

      ::nActualFile        := 0

      aDir                 := DirectoryRecurse( FullCurDir() + "script\*.*", "D" )

      ::oProgreso:SetTotal( Len( aDir ) )
      ::oProgreso:cText    := "Comprimiendo directorio scripts"

      aEstructura          := {}

      aEval( aDir, { | cName, nIndex | aAdd( aEstructura, cName[ 1 ] ), ::oProgreso:Set( nIndex ) } )

      hb_SetDiskZip( {|| nil } )
      hb_ZipFile( cDat, aEstructura, 9, , .t., cPassword, .t. )
      hb_gcAll()

      aAdd( aFil, cDat )

      /*
      Ahora el directorio de reporting-----------------------------------------
      */

      cDat                 := cPatSafe() + "reporting"
      if ::lDate
         cDat              += Dtos( Date() )
      end if
      cDat                 += ".Zip"

      if file( cDat )
         ferase( cDat )
      end if

      ::nActualFile        := 0

      aDir                 := DirectoryRecurse( FullCurDir() + "reporting\*.*", "D" )

      ::oProgreso:SetTotal( Len( aDir ) )
      ::oProgreso:cText    := "Comprimiendo directorio reporting"

      aEstructura          := {}

      aEval( aDir, { | cName, nIndex | aAdd( aEstructura, cName[ 1 ] ), ::oProgreso:Set( nIndex ) } )

      hb_SetDiskZip( {|| nil } )
      hb_ZipFile( cDat, aEstructura, 9, , .t., cPassword, .t. )
      hb_gcAll()

      aAdd( aFil, cDat )

      /*
      Ahora el directorio de userreporting-----------------------------------------
      */

      cDat                 := cPatSafe() + "userreporting"
      if ::lDate
         cDat              += Dtos( Date() )
      end if
      cDat                 += ".Zip"

      if file( cDat )
         ferase( cDat )
      end if

      ::nActualFile        := 0

      aDir                 := DirectoryRecurse( FullCurDir() + "userreporting\*.*", "D" )

      ::oProgreso:SetTotal( Len( aDir ) )
      ::oProgreso:cText    := "Comprimiendo directorio userreporting"

      aEstructura          := {}

      aEval( aDir, { | cName, nIndex | aAdd( aEstructura, cName[ 1 ] ), ::oProgreso:Set( nIndex ) } )

      hb_SetDiskZip( {|| nil } )
      hb_ZipFile( cDat, aEstructura, 9, , .t., cPassword, .t. )
      hb_gcAll()

      aAdd( aFil, cDat )

      /*
      Ahora pasamos los datos al dispositivo-----------------------------------
      */

      if ::lDir
         if ::doBackup( aFil, ::cDir )
            cRes           += "Copia local correcta." + CRLF
         else
            cRes           += "Copia local incompleta." + CRLF
         end if
      end if

      if ::lInternet
         if ::doFtp( aFil )
            cRes           += "Copia en servidor de backup correcta." + CRLF
         else
            cRes           += "Copia en servidor de backup incompleta." + CRLF
         end if
      end if

      ::SaveToDisk( cRes )

   else

      msgStop( "No se selecciono ninguna empresa" )

   end if

   if !Empty( ::oDlg )
      ::oDlg:Enable()
   end if

RETURN ( lSel )

//-----------------------------------------------------------------------//

METHOD cGetFilesToRestore()

   if ::doRestore( ::cDirOrigen )
      aEval( ::aEmp, { | aItm | aItm[ 1 ] := file( cPatSafe() + "Emp" + aItm[ 2 ] + ".Zip" ) } )
      ::oBrwRestore:Refresh()
   end if

RETURN ( .t. )

//-------------------------------------------------------------------------//
//
//Descomprime los ficheros de un zip
//

METHOD GetZipFiles()

   local n
   local cZipFile

   //Comprobamos que no hay ninguna empresa a restaurar

   for n := 1 to len( ::aEmp )

      cZipFile := Rtrim( cPatSafe() + "Emp" + ::aEmp[ n, 2 ] + ".ZIP" )

      if File( cZipFile ) //comprobamos si hay copias que restaurar
         ::aEmp[ n, 1 ] := .t.
      else
         ::aEmp[ n, 1 ] := .f.
      endif

   next

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD RestoreZipFiles()

   local n
   local nZip
   local lSel     := .f.
   local lErr     := .f.
   local aFiles   := {}
   local lErrors  := .f.
   local cZipFile

   for n := 1 to len( ::aEmp )
      if ::aEmp[ n, 1 ] // Seleccionado
         lSel     := .t.
      end if
   next

   if !lSel
      msgStop( "No se selecciono ninguna empresa" )
      RETURN ( Self )
   end if

   for n := 1 to len( ::aEmp )

      if ::aEmp[ n, 1 ] // Seleccionado

         cZipFile := Rtrim( cPatSafe() + "Emp" + ::aEmp[ n, 2 ] + ".ZIP" )

         if File( cZipFile )

            // Comfirme antes de sobreescribir

            if ApoloMsgNoYes( "Se dispone a sobreescribir la empresa " + ::aEmp[ n, 2 ], "¿ Desea continuar ?" )

               // De aqui no se mueve nadie

               CursorWait()

               aFiles      := Hb_GetFilesInZip( cZipFile )

               ::oProgresoRestore:SetTotal( Len( aFiles ) )

               if !Hb_UnZipFile( cZipFile, { | cName, nIndex | ::oProgresoRestore:Set( nIndex ) }, , Rtrim( ::cPasswordRestore ), FullCurDir() + "EMP" + ::aEmp[ n, 2 ], aFiles )
                  lErr     := .t.
               else
                  lErr     := .f.
               end if

               hb_gcAll()

               CursorWE()

               if lErr
                  lErrors  := .t.
                  MsgStop( "No se ha restaurado la empresa " + ::aEmp[ n, 2 ], "Error" )
               else
                  MsgInfo( "Se ha restaurado la empresa " + ::aEmp[ n, 2 ], "Aviso" )
               end if

            end if //if de sobreescribir empresa

         else

            lErrors  := .t.

            MsgStop( "Fichero " + cZipFile + " no encontrado" )

         end if

      end if

   next n

   if lErrors
      msgStop( "Errores durante la restauración de la copia" )
   else
      msgInfo( "Copia satisfactoriamente restaurada" )
      ::oDlg:end()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

FUNCTION nGetBytes( cDir )

	local i
   local aFil     := Directory( cDir )
   local nBytes   := 0

	FOR i := 1 TO len( aFil )
      nBytes      += aFil[ i, F_SIZE ]
	NEXT

RETURN nBytes

//----------------------------------------------------------------------------//

METHOD doBackup( aFiles, cDriveTo )

   local x
   local lRetVal
	local cSerial
   local nBuffer
	local nDiskNum
	local nByteCopy
	local lLogNew
	local nFilePos
	local cFileName
	local fSource
	local lTarget
	local nError
	local fTarget
	local nRead
	local cBuffer
	local nWrote
   local nBytes      := 0
   local nTotalBytes := 0
   local nTotalWrite := 0

   lRetVal           := .t.
   lLogNew           := .t.

   cSerial           := dtos( date() ) + str( seconds(), 5)   // serial number for the backup set // lbackno
   nByteCopy         := 0       // bytes copied so far        // lbyte_cop
   nBuffer           := 4096    // buffer size in bytes       // linc
   nDiskNum          := 0       // initialize disk counter    // nDiskNum
   cDriveTo          := Rtrim( cDriveTo )

   if Right( cDriveTo, 1 ) != "\"
      cDriveTo       += "\"
   end if

   CursorWait()

   /*
   Barra de progreso de escritura----------------------------------------------
   */

   for x := 1 to len( aFiles )
      nTotalBytes    += nGetBytes( aFiles[ x ] )
   next

   ::oProgresoTarget:SetTotal( nTotalBytes )

   /*
   Copiando ficheros-----------------------------------------------------------
   */

   for x := 1 to len( aFiles )

		nFilePos 			:= 0
      lTarget           := .t.
      cFileName         := aFiles[ x ]
		fSource 				:= fOpen( cFileName )
		nError  				:= fError()

      nBytes            += nGetBytes( cFileName )

      while nError == 0

			// -- LOG NEW DISKETTE --------------------------------------------

         if lLogNew

            lLogNew     := .f.
            lTarget     := .t.
				nDiskNum++     // increment disk number

            do while .t.

               if ( "A:" $ cDriveTo .or. "B:" $ cDriveTo ) .and. ;
                  !ApoloMsgNoYes( "Inserte el disco # " + lTrim( Str( nDiskNum ) ) + " en unidad " + cDriveTo, "¿ Continuar ?" )
                  RETURN ( .f. )
               endif

               ::bk_DiskNum  := nDiskNum
               ::bk_Serial   := ""

					/*
					Comprobamos que se puede escribir en el destino
					*/

               if !fClose( fCreate( cDriveTo + "x" ) )
                  if !ApoloMsgNoYes(  "No hay discos en unidad o esta protegido contra escritura.", "¿ Continuar ?" )
                     RETURN ( .f. )
                  else
                     loop
                  endif
               else
                  fErase( cDriveTo + "x" )
               endif

               if File( cDriveTo + "BkData.Seg" )
                  ::RestoreFromDisk( cDriveTo + "BkData.Seg" )
               endif

               if ::bk_DiskNum < nDiskNum .AND. ::bk_Serial == cSerial
                  MsgStop( "Por favor cambie el disco en curso.", "Cambie el disco" )
               else
                  if ( "A:" $ cDriveTo .or. "B:" $ cDriveTo )
                     MsgRun(  "Limpiando el disco en " + cDriveTo, "Espere por favor...", {|| ::CleanDisk( cDriveTo ) } )
                  end if

                  //Guardando la información q acompaña al backup----------------

                  ::bk_DiskNum  := nDiskNum
                  ::bk_Serial   := cSerial
                  ::bk_Bytes    := nBytes
                  ::bk_NumFiles := len( aFiles )

                  exit

               endif

            end do

         endif   // if llognew

         /*
         Abriendo el fichero destino____________________________________________
         */

         if lTarget

            lTarget := .f.
            fTarget := fCreate( cDriveTo + cNoPath( cFileName ) )

            if fError() <> 0
               lRetVal := .f.
               SysRefresh()
               EXIT
            endif

         endif

         cBuffer := Space( nBuffer )
         nRead   := fRead( fSource, @cBuffer, nBuffer)

         if fError() == 0

            if nRead == 0

               fClose( fTarget )
               exit

            else

               nWrote      := fWrite( fTarget, cBuffer, nRead )

               if fError() == 0

                  nFilePos    += nWrote
                  nByteCopy   += nWrote
                  nTotalWrite += nWrote

                  ::oProgresoTarget:Set( nTotalWrite )

                  SysRefresh()

                  if nWrote < nRead // THE WHOLE FILE DID NOT FIT

                     fSeek( fSource, nFilePos )    // position pointer where text ended
                     fClose( fTarget )             // close the outfile
                     lLogNew  := .t.               // log new disk

                  endif

               end if // if fError() == 0

            endif  // if nread == 0

         endif  // if ferror() == 0

         if fError() != 0

            if fClose( fTarget )
               fErase ( cDriveTo + cFileName )
            end if

         end if

      end do

		fClose( fSource )

      if fSize( cFileName ) <> nFilePos .OR. nError <> 0
         exit
      end if

   next x

   CursorWE()

RETURN ( nBytes == nByteCopy )

//---------------------------------------------------------------------------//
//
// Vacia un disquete
//

METHOD CleanDisk( cDriveTo )

   local x
   local aDiskFile

	aDiskFile := Directory( cDriveTo + "*.*" )

   for x := 1 to len( aDiskFile )
		fErase( cDriveTo + aDiskFile[ x, F_NAME ] )
   next x

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DoRestore( cFileFrom )

   local x
   local aFiles
   local cSerial
   local lRetVal        := .t.
   local nDiskNum       := 1
   local nByteCopy      := 0
   local aDiskFile
   local cDriveFrom     := cOnlyPath( cFileFrom )
   local nBytes         := 0

   do while nDiskNum != 0

      while .t.

         if ( "A:" $ cFileFrom .or. "B:" $ cFileFrom )                                                                  .and. ;
            !ApoloMsgNoYes(  "Inserte el disco # " + lTrim( Str( nDiskNum ) ) + " en unidad " + cDriveFrom, "¿ Continuar ?" )
            RETURN ( .f. )
         endif

         if !file( cFileFrom )

            if ApoloMsgNoYes( "No hay discos de copia o no esta preparado.", "¿ Continuar ?" )
               RETURN ( .f. )
            else
               loop
            end if

         else

            ::RestoreFromDisk( cFileFrom )

            if nDiskNum == 1 .and. ::bk_DiskNum == 1
               cSerial     := ::bk_Serial
               nBytes      := ::bk_Bytes
            end if

            if ::bk_DiskNum != nDiskNum .OR. ::bk_Serial != cSerial
               if !ApoloMsgNoYes( "Los discos no estan en el orden correcto en la unidad " + cDriveFrom, "¿ Continuar ?" )
                  RETURN .f.
               end if

            else

               aFiles      := {}
               aDiskFile   := Directory( cDriveFrom + "Emp*.*" )

               for x := 1 to len( aDiskFile )
                  aAdd( aFiles, aDiskFile[x, F_NAME] )
               next

               nDiskNum++

               exit

            end if  // if bk_disknum <> ndisknum .or. bk_serial <> cserial

         endif  // if !file( cdrivefrom + "bkdata.seg" )

      enddo  // do while .t.

      CursorWait()

      for x := 1 to len( aFiles )
         CopyFile( cDriveFrom + aFiles[ x ], cPatSafe() + aFiles[ x ] )
      next

      nDiskNum          := 0

      exit

      CursorWE()

   end do   // do while ndisknum <> 0

   if nBytes != nByteCopy
      lRetVal := .f.
   endif

RETURN ( .t. ) //lRetVal )

//----------------------------------------------------------------------------//

Function CompressEmpresa( cCodEmp, cFile, aBtn, oAct, oAni, oMsg, oDlg, lAuto )

   local nZip
   local aDir
   local dLastBackup
   local lLastBackup    := .f.
   local lEnableBackup  := .t.

   DEFAULT lAuto        := .t.
   DEFAULT cFile        := cPatSafe() + "Emp" + cCodEmp + Dtos( Date() ) + ".Zip"

   if oDlg != nil
      oDlg:bValid       := {|| .f. }
   end if

   if ValType( aBtn ) == "A"
      aEval( aBtn, {|oBtn| oBtn:Hide() } )
   end if

   if !Empty( oAct )
      oAct:Hide()
   end if

   if !lAuto
      dLastBackup       := Stod( GetPvProfString( "Backup", "Ultimo", Dtos( Date() ), cIniAplication() ) )

      lEnableBackup     := GetPvProfString( "Backup", "Enable", ".T.", cIniAplication() )
      lEnableBackup     := Upper( lEnableBackup ) == ".T."

      lLastBackup       := ( Date() - dLastBackup >= 7 ) .and. ( lEnableBackup ) 
   end if

   if lAuto .or. lLastBackup

      if lLastBackup
         MsgInfo( "Ultima copia de seguridad " + Dtoc( dLastBackup ) + " el programa realizará ahora una copia, de manera automática." )
      end if

      if !Empty( oAni )
         oAni:Show()
      end if

      if oMsg != nil
         oMsg:SetText( "Realizando copia de empresa " + cCodEmp )
      end if

      // Borrando anterior ----------------------------------------------------

      if File( cFile )
         fErase( cFile )
      end if

      // Comprimiendo los archivos --------------------------------------------

      hb_SetDiskZip( {|| nil } )
      aDir           := Directory( FullCurDir() + "EMP" + cCodEmp + "\*.*" )
      aEval( aDir, { | cName, nIndex | hb_ZipFile( cFile, FullCurDir() + "EMP" + cCodEmp + "\" + cName[ 1 ], 9, {|| SysRefresh() } ) } )

      hb_gcAll()

      if !Empty( oAni )
         oAni:Hide()
      end if

      WritePProString( "Backup", "Ultimo", Dtos( Date() ), cIniAplication() )

   end if

   if oDlg != nil
      oDlg:bValid    := {|| .t. }
      oDlg:End( IDOK )
   end if

RETURN nil

//-----------------------------------------------------------------------//

Function CompressGrupo( cCodGrp, cFile, aBtn, oAct, oAni, oMsg, oDlg, lAuto )

   local nZip
   local aDir
   local dLastBackup
   local lLastBackup
   local lEnableBackup

   DEFAULT lAuto     := .t.
   DEFAULT cFile     := FullCurDir() + "Safe\GRP" + cCodGrp + ".Zip"

   if oDlg != nil
      oDlg:bValid    := {|| .f. }
   end if

   if ValType( aBtn ) == "A"
      aEval( aBtn, {|oBtn| oBtn:Hide() } )
   end if

   if !Empty( oAct )
      oAct:Hide()
   end if

   lEnableBackup     := GetPvProfString( "Backup", "Enable", ".T.", cIniAplication() )
   lEnableBackup     := Upper( lEnableBackup ) == ".T."

   dLastBackup       := Stod( GetPvProfString( "Backup", "Ultimo", Dtos( Date() ), cIniAplication() ) )
   lLastBackup       := ( Date() - dLastBackup >= 7 ) .and. ( !lAuto )

   if lEnableBackup .and. ( lAuto .or. lLastBackup )

      if lLastBackup
         MsgInfo( "Ultima copia de seguridad " + Dtoc( dLastBackup ) + " el programa realizará ahora una copia, de manera automática." )
      end if

      if !Empty( oAni )
         oAni:Show()
      end if

      if oMsg != nil
         oMsg:SetText( "Realizando copia del grupo " + cCodGrp )
      end if

      // Borrando anterior ----------------------------------------------------

      if File( cFile )
         fErase( cFile )
      end if

      // Comprimiendo los archivos --------------------------------------------

      hb_SetDiskZip( {|| nil } )
      aDir           := Directory( FullCurDir() + "Emp" + cCodGrp + "\*.*" )
      aEval( aDir, { | cName, nIndex | hb_ZipFile( cFile, FullCurDir() + "Emp" + cCodGrp + "\" + cName[ 1 ], 9, {|| SysRefresh() } ) } )
      hb_gcAll()

      if !Empty( oAni )
         oAni:Hide()
      end if

      WritePProString( "Backup", "Ultimo", Dtos( Date() ), cIniAplication() )

   end if

   if oDlg != nil
      oDlg:bValid    := {|| .t. }
      oDlg:End( IDOK )
   end if

RETURN nil

//-----------------------------------------------------------------------//

METHOD SaveToDisk( Resultado )

   local n
   local oIni
   local cFile
   local hFile
   local Accion
   local hora     := Time()

   cFile          := Rtrim( ::cDir ) + '\BkData.Seg'
   Accion         := "Copias de las empresas: "

   for n := 1 to len( ::aEmp )

      if ::aEmp[ n, 1 ]
         Accion := Accion + ::aEmp[ n, 2 ] + " "
      endif

   next

   INI oIni FILE cFile
      SET SECTION "backup" TO ::bk_DiskNum                     ENTRY "DiskNum"      OF oIni
      SET SECTION "backup" TO ::bk_Serial                      ENTRY "Serial"       OF oIni
      SET SECTION "backup" TO ::bk_Bytes                       ENTRY "Bytes"        OF oIni
      SET SECTION "backup" TO ::bk_NumFiles                    ENTRY "NumFiles"     OF oIni
      SET SECTION "backup" TO Auth():Codigo()                        ENTRY "Usuario"      OF oIni
      SET SECTION "backup" TO dtoc( Date() ) + " - " + hora    ENTRY "Fecha"        OF oIni
      SET SECTION "backup" TO Resultado                        ENTRY "Estado"       OF oIni
      SET SECTION "backup" TO Accion                           ENTRY "Contenido"    OF oIni
   ENDINI

   //preparar el memo de resultado

   ::mResultado   := "Este informe quedará guardado en el fichero " + Alltrim( ::cFile ) + " de acuerdo con la Ley Orgánica 15/1999, de 13 de Diciembre, de protección de datos de carácter personal." + CRLF + CRLF
   ::mResultado   += "El proceso de copia de seguridad ha finalizado." + CRLF
   ::mResultado   += "A continuación se muestra un resumen de las operaciones realizadas." + CRLF + CRLF
   ::mResultado   += "Usuario que realizó la copia: " + Auth():Codigo()  + Space( 1 ) + oUser():cNombre() + CRLF
   ::mResultado   += "Número de discos: " + AllTrim( str( ::bk_DiskNum ) ) + CRLF
   ::mResultado   += "Número de ficheros: " + AllTrim( str( ::bk_NumFiles ) ) + CRLF
   ::mResultado   += "Fecha: " + dtoc( Date() ) + " - " + hora + CRLF
   ::mResultado   += "Contenido: " + Accion + CRLF
   ::mResultado   += CRLF
   ::mResultado   += "Resultado final: "
   ::mResultado   += CRLF
   ::mResultado   += Resultado

   if !Empty( ::oResultado )
      ::oResultado:cText( ::mResultado )
   end if

   // Guardamos el informe-----------------------------------------------------

   if !Empty( ::cFile )
      hFile       := fCreate( ::cFile )
      fWrite( hFile, ::mResultado )
      fClose( hFile )
   end if

   // Guardar en backup.dbf----------------------------------------------------

   ::oDbf:Append()
   ::oDbf:Fecha   := Date()
   ::oDbf:Hora    := hora
   ::oDbf:Usuario := Auth():Codigo()
   ::oDbf:Resumen := ::mResultado
   ::oDbf:Save()

RETURN ( Self )

//-----------------------------------------------------------------------//

METHOD RestoreFromDisk( cFile )

   local oIni

   ::bk_DiskNum  := nil
   ::bk_Serial   := nil
   ::bk_Bytes    := nil
   ::bk_NumFiles := nil

   INI oIni FILE cFile
      GET ::bk_DiskNum  SECTION "backup" ENTRY "DiskNum"      OF oIni
      GET ::bk_Serial   SECTION "backup" ENTRY "Serial"       OF oIni
      GET ::bk_Bytes    SECTION "backup" ENTRY "Bytes"        OF oIni
      GET ::bk_NumFiles SECTION "backup" ENTRY "NumFiles"     OF oIni
   ENDINI

   if Valtype( ::bk_DiskNum ) == "C"
      ::bk_DiskNum      := Val( ::bk_DiskNum )
   end if

   if Valtype( ::bk_Bytes ) == "C"
      ::bk_Bytes        := Val( ::bk_Bytes   )
   end if

   if Valtype( ::bk_NumFiles ) == "C"
      ::bk_NumFiles     := Val( ::bk_NumFiles)
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD doFtp( aFiles )

   local oInt
   local oFtp
   local cFile
   local nbrUsr   := Rtrim( ::cUserInternet )
   local accUsr   := Rtrim( ::cPasswordInternet )
   local ftpSit   := "apolosupport.serveftp.com"

   oInt           := TInternet():New()
   oFtp           := TFtp():New( ftpSit, oInt, nbrUsr, accUsr, .f. )

   if Empty( oFtp )
      msgStop( "Imposible crear la conexión" )
      RETURN .f.
   end if

   if Empty( oFTP:hFTP )
      msgStop( "Imposible conectar con el servidor de backup" )
      RETURN .f.
   endif

   for each cFile in aFiles

      ::oProgresoInternet:cText    := "Subiendo fichero : " + cNoPath( cFile )

      if File( cFile )
         TFtpFile():New( cFile, oFtp ):PutFile( ::oProgresoInternet )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf 

   DEFAULT cPath     := cPatDat()
   DEFAULT cDriver   := cDriver()

   DEFINE TABLE oDbf FILE "Backup.Dbf" CLASS "BACKUP" ALIAS "BACKUP" PATH ( cPath ) VIA ( cDriver )COMMENT "Registro de los backup"

      FIELD NAME "FECHA"   TYPE "D" LEN  10 DEC 0  COMMENT "Fecha de la copia"         OF oDbf
      FIELD NAME "HORA"    TYPE "C" LEN   8 DEC 0  COMMENT "Hora de la copia"          OF oDbf
      FIELD NAME "USUARIO" TYPE "C" LEN   3 DEC 0  COMMENT "Usuario que la realiza"    OF oDbf
      FIELD NAME "RESUMEN" TYPE "C" LEN 200 DEC 0  COMMENT "Resumen del proceso"       OF oDbf

      INDEX TO "BACKUP.CDX" TAG "Fecha"   ON "Fecha"   COMMENT "Por fecha"   NODELETED OF oDbf
      INDEX TO "BACKUP.CDX" TAG "Usuario" ON "Usuario" COMMENT "Por usuario" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf()

   local oBlock
   local oError
   local oDbfTmp
   local oDbfOld

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   oDbfTmp        := ::DefineFiles( cPatEmpTmp() )

   if !Empty( oDbfTmp )
      oDbfTmp:Activate( .f., .f. )
   end if

   oDbfOld        := ::DefineFiles()

   if !Empty( oDbfOld )
      oDbfOld:Activate( .f., .f., , , , .t. )
   end if

   while !oDbfOld:Eof()
      dbPass( oDbfOld:cAlias, oDbfTmp:cAlias, .t. )
      oDbfOld:Skip()
   end

   oDbfTmp:Close()
   oDbfOld:Close()

   if dbfErase( oDbfOld:cPath + GetFileNoExt( oDbfOld:cFile ) )
      if dbfRename( oDbfTmp:cPath + GetFileNoExt( oDbfTmp:cFile ), oDbfOld:cPath + GetFileNoExt( oDbfOld:cFile ) )
         dbfErase( oDbfTmp:cPath + GetFileNoExt( oDbfTmp:cFile ) )
      else
         MsgStop( "No se actualizo el fichero " + GetFileNoExt( oDbfOld:cFile ) + ".Dbf" )
      end if
   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible actualizar fichero a nueva estructura" )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( oDbfTmp )
      oDbfTmp:Destroy()
   end if

   if !Empty( oDbfOld )
      oDbfOld:Destroy()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//
//
// funcion para imprimir un fichero dbf
//

Function ImprimirODbf( oDbf, cTitulo )

   LOCAL oFont
   local oReport

   if oDbf == nil .or. !oDbf:Used()
      msgStop( "La base de datos esta cerrada." )
      RETURN .f.
   end if

   DEFINE FONT oFont NAME "Courier New" SIZE 0, -12

   REPORT oReport ;
      FONT     oFont ;
      CAPTION  "Imprimir DBF" ;
      PREVIEW

      COLUMN DATA " " SIZE 76

   END REPORT

   oReport:nTitleUpLine := RPT_NOLINE //cabecera
   oReport:nTitleDnLine := RPT_NOLINE //pie de pagina

   ACTIVATE REPORT oReport ON INIT SayDbf( oDbf, oReport, cTitulo )

   oFont:End()

RETURN NIL

//---------------------------------------------------------------------------//

STATIC Function SayDbf( oDbf, oReport, cTitulo )

   LOCAL cText, cLine
   LOCAL nFor, nLines, nPageln

   cText    := DbfToC( oDbf, cTitulo )

   nLines   := MlCount( cText, 76 ) //caracteres por linea
   nPageln  := 0

   FOR nFor := 1 TO nLines

        cLine := MemoLine( cText, 76, nFor )

        oReport:StartLine()
        oReport:Say(1,cLine)
        oReport:EndLine()

        nPageln := nPageln + 1
        IF nPageln = 60
           nFor := GetTop(cText,nFor,nLines)
           nPageln := 0
        ENDIF

   NEXT

RETURN NIL

//---------------------------------------------------------------------------//
//
//vuelva el contenido de un dbf a una cadena de texto
//

function DbfToC( oDbf, cTitulo )

   local Texto := ""
   local nFila
   local nColumna

   DEFAULT cTitulo := " Registro "

   oDbf:GoTop()

   for nFila := 1 to oDbf:RecCount()

      Texto    += cTitulo + str( nFila )  + CRLF
      Texto    += Replicate( "-", 76 )    + CRLF

      for nColumna := 1 to oDbf:Fcount()
         Texto += oDbf:FieldName( nColumna ) + ": "
         Texto += cValToChar( oDbf:FieldGet( nColumna ) )
         Texto += CRLF
      next

      oDbf:Skip()

      Texto    += CRLF

   next

   oDbf:GoTop()

RETURN Texto

//---------------------------------------------------------------------------//

STATIC FUNCTION GetTop(cText,nFor,nLines)

   local lTest := .t., cLine

   while lTest .and. nFor <= nLines
      nFor++
      cLine := MemoLine( cText, 76, nFor )
      lTest := Empty( cLine )
   enddo

   nFor--
   SysRefresh()

RETURN nFor

//---------------------------------------------------------------------------//