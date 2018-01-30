#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"

//----------------------------------------------------------------------------//

CLASS TSndRecInf

   DATA  lFtpValido

   DATA  lConnect
   DATA  lServer
   DATA  lFranquiciado
   DATA  aSend
   DATA  aReciver
   DATA  acSay
   DATA  oMtr
   DATA  nMtr
   DATA  oPro
   DATA  cPro
   DATA  oSay
   DATA  cSay
   DATA  oFtp
   DATA  oInt

   DATA  oTimer
   DATA  oSubItem
   DATA  oSubItem2

   DATA  cIniFile

   DATA  lPlanificarEnvio     INIT  .f.
   DATA  cHoraEnvio           INIT  "0000"
   DATA  lPlanificarRecepcion INIT  .f.
   DATA  cHoraRecepcion       INIT  "0000"
   DATA  lEnviado             INIT  .f.
   DATA  lRecibido            INIT  .f.
   DATA  lInProcess           INIT  .f.
   DATA  lGetProcesados       INIT  .f.
   DATA  lGetFueraSecuencia   INIT  .f.
   DATA  lGetEliminarFicheros INIT  .f.
   DATA  lImprimirEnvio       INIT  .f.
   DATA  lExportarPda         INIT  .f.

   DATA  nTipoEnvio           INIT  1

   DATA  nLevel

   DATA  oDbfSenderReciver
   DATA  oDbfFilesReciver

   DATA  aFilesProcessed

   DATA  oBrwHistorial
   DATA  oBrwFiles

   DATA  oBmpSel
   DATA  oDlg
   DATA  oFld

   DATA  oBotonAnterior
   DATA  oBotonSiguiente
   DATA  oBotonTerminar

   DATA  cFilTxt
   DATA  oFilTxt
   DATA  hFilTxt

   DATA  oBtnOk
   DATA  oBtnCancel

   DATA  oTree
   DATA  oImageList

   DATA  cPath
   DATA  cPathComunication                INIT ""

   METHOD New()
   METHOD Init()
   METHOD Create()                        INLINE ( Self )

   METHOD LoadFromIni()
   METHOD SaveToIni()

   METHOD SaveMessageToFile()

   METHOD Activate( lAuto )
   METHOD ActivateTablet()
   METHOD AutoExecute()                   INLINE ( ::Activate( .t. ) )

   METHOD DefineFiles()
   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD BuildFiles( cPath )             INLINE ( ::DefineFiles( cPath ), ::oDbfSenderReciver:Create(), ::oDbfFilesReciver:Create() )

   METHOD BotonSiguiente()
   METHOD BotonAnterior()

   METHOD Execute()

   METHOD Reindexa( cPath )

   METHOD SetText( cText )

   METHOD StartTimer()
   METHOD StopTimer()

   METHOD lPriorFileRecive( cFile )

   METHOD AppendFileRecive( cFile )

   METHOD ZoomHistorial()

   METHOD testFtpConexion()               
   METHOD ftpConexion()
   METHOD closeConexion()

   METHOD PrintLog( cTextFile )

   METHOD SayMemo( cTextfile )

   METHOD lZipData( cFileName )
   METHOD lUnZipData( cFileName )

   METHOD lFileRecive( cFile )
   METHOD lFileProcesed( cFile )
   METHOD SendFiles()
   METHOD GetFiles()

   METHOD SyncAllDbf()

   METHOD setPathComunication( cPathComunication ) INLINE ( ::cPathComunication := cPathComunication )
   METHOD getPathComunication()                    INLINE ( ::cPathComunication )

   METHOD lLocalGetFiles( aSource, cTarget )
   METHOD lFtpGetFiles( aSource, cTarget )

   METHOD lLocalSendFiles( aSource, cTarget )
   METHOD lFtpSendFiles( aSource, cTarget )

   METHOD aExtensions()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd ) CLASS TSndRecInf

   DEFAULT oMenuItem    := "01073"
   DEFAULT oWnd         := oWnd()

   ::nLevel             := nLevelUsr( oMenuItem )

   // Cerramos todas las ventanas----------------------------------------------

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::Init()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Init() CLASS TSndRecInf

   ::cPro               := ""
   ::cSay               := ""
   ::nMtr               := 0
   ::aSend              := {}
   ::aFilesProcessed    := {}
   ::lFtpValido         := .f.
   ::cIniFile           := cIniEmpresa()
   
   // Path de comunicaciones---------------------------------------------------

   ::setPathComunication( cRutConInt() )

   aAdd( ::aSend, TArticuloSenderReciver():New(                "Artículos",                  Self ) )
   aAdd( ::aSend, TFamiliaSenderReciver():New(                 "Familias",                   Self ) )
   aAdd( ::aSend, TTipArt():Initiate(                          "Tipos de artículos",         Self ) )
   aAdd( ::aSend, TPropiedadesSenderReciver():New(             "Propiedades",                Self ) )
   aAdd( ::aSend, TClienteSenderReciver():New(                 "Clientes",                   Self ) )
   aAdd( ::aSend, TProveedorSenderReciver():New(               "Proveedor",                  Self ) )
   aAdd( ::aSend, TPedidosProveedorSenderReciver():New(        "Pedidos de proveedor",       Self ) )
   aAdd( ::aSend, TAlbaranesProveedorSenderReciver():New(      "Albaranes de proveedor",     Self ) )
   aAdd( ::aSend, TFacturasProveedorSenderReciver():New(       "Facturas de proveedor",      Self ) )
   aAdd( ::aSend, TRectificativasProveedorSenderReciver():New( "Rectificativas proveedor",   Self ) )
   aAdd( ::aSend, TSATClientesSenderReciver():New(             "SAT de clientes",            Self ) )
   aAdd( ::aSend, TPresupuestosClientesSenderReciver():New(    "Presupuestos clientes",      Self ) )
   aAdd( ::aSend, TPedidosClientesSenderReciver():New(         "Pedidos clientes",           Self ) )
   aAdd( ::aSend, TAlbaranesClientesSenderReciver():New(       "Albaranes clientes",         Self ) )
   aAdd( ::aSend, TFacturasClientesSenderReciver():New(        "Facturas clientes",          Self ) )
   aAdd( ::aSend, TFacturasRectificativasSenderReciver():New(  "Rectificativas clientes",    Self ) )
   aAdd( ::aSend, TTiketsClientesSenderReciver():New(          "Tickets clientes",           Self ) )
   aAdd( ::aSend, TEntradasSalidasSenderReciver():New(         "Entradas y salidas",         Self ) )
   aAdd( ::aSend, TTurno():Initiate(                           "Sesiones",                   Self ) )
   aAdd( ::aSend, TUsuarioSenderReciver():New(                 "Usuarios",                   Self ) )

   ::DefineFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD LoadFromIni() CLASS TSndRecInf

   if !Empty( ::aSend )
      aSend( ::aSend, "Load" )
   end if

   ::lServer               := ( "Servidor" $ cCodEnvUsr() )

   ::lFranquiciado         := uFieldEmpresa( "lEmpFrnq" )

   ::lPlanificarEnvio      := GetPvProfString( "Envioyrecepcion", "lPlanificarEnvio", cValToChar( ::lPlanificarEnvio ), ::cIniFile )
   ::lPlanificarEnvio      := Upper( ::lPlanificarEnvio ) == ".T."

   ::cHoraEnvio            := GetPvProfString( "Envioyrecepcion", "cHoraEnvio", cValToChar( ::cHoraEnvio ), ::cIniFile )

   ::lPlanificarRecepcion  := GetPvProfString( "Envioyrecepcion", "lPlanificarRecepcion", cValToChar( ::lPlanificarRecepcion ), ::cIniFile )
   ::lPlanificarRecepcion  := Upper( ::lPlanificarRecepcion ) == ".T."

   ::cHoraRecepcion        := GetPvProfString( "Envioyrecepcion", "cHoraRecepcion", cValToChar( ::cHoraRecepcion ), ::cIniFile )

   ::lGetProcesados        := GetPvProfString( "Envioyrecepcion", "lAceptarProcesados", cValToChar( ::lGetProcesados ), ::cIniFile )
   ::lGetProcesados        := Upper( ::lGetProcesados ) == ".T."

   ::lGetFueraSecuencia    := GetPvProfString( "Envioyrecepcion", "lAceptarFueraSecuencia", cValToChar( ::lGetFueraSecuencia ), ::cIniFile )
   ::lGetFueraSecuencia    := Upper( ::lGetFueraSecuencia ) == ".T."

   ::lGetEliminarFicheros  := GetPvProfString( "Envioyrecepcion", "lEliminarFicheros", cValToChar( ::lGetEliminarFicheros ), ::cIniFile )
   ::lGetEliminarFicheros  := Upper( ::lGetEliminarFicheros ) == ".T."

   ::lImprimirEnvio        := GetPvProfString( "Envioyrecepcion", "lImprimirEnvio", cValToChar( ::lImprimirEnvio ), ::cIniFile )
   ::lImprimirEnvio        := Upper( ::lImprimirEnvio ) == ".T."

   ::lExportarPda          := GetPvProfString( "Envioyrecepcion", "lExportarPda", cValToChar( ::lExportarPda ), ::cIniFile )
   ::lExportarPda          := Upper( ::lExportarPda ) == ".T."

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SaveToIni( lMessage ) CLASS TSndRecInf

   DEFAULT lMessage  := .f.

   if !Empty( ::aSend )
      aSend( ::aSend, "Save" )
   end if

   WritePProString( "Envioyrecepcion", "lPlanificarEnvio",        cValToChar( ::lPlanificarEnvio ),      ::cIniFile )
   WritePProString( "Envioyrecepcion", "cHoraEnvio",              cValToChar( ::cHoraEnvio ),            ::cIniFile )
   WritePProString( "Envioyrecepcion", "lPlanificarRecepcion",    cValToChar( ::lPlanificarRecepcion ),  ::cIniFile )
   WritePProString( "Envioyrecepcion", "cHoraRecepcion",          cValToChar( ::cHoraRecepcion ),        ::cIniFile )
   WritePProString( "Envioyrecepcion", "lAceptarFueraSecuencia",  cValToChar( ::lGetFueraSecuencia ),    ::cIniFile )
   WritePProString( "Envioyrecepcion", "lAceptarProcesados",      cValToChar( ::lGetProcesados ),        ::cIniFile )
   WritePProString( "Envioyrecepcion", "lEliminarFicheros",       cValToChar( ::lGetEliminarFicheros ),  ::cIniFile )
   WritePProString( "Envioyrecepcion", "lImprimirEnvio",          cValToChar( ::lImprimirEnvio ),        ::cIniFile )
   WritePProString( "Envioyrecepcion", "lExportarPda",            cValToChar( ::lExportarPda ),          ::cIniFile )

   if lMessage
      MsgInfo( "Configuración de envio guardada" )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD StartTimer() CLASS TSndRecInf

   if ::lPlanificarEnvio .or. ::lPlanificarRecepcion
      ::oTimer             := TTimer():New( 60000, {|| ::AutoExecute() }, oWnd() )
      ::oTimer:Activate()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD StopTimer() CLASS TSndRecInf

   if ::oTimer != nil .and. ::oTimer:lActive
      ::oTimer:DeActivate()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SaveMessageToFile() CLASS TSndRecInf

   if !Empty( ::hFilTxt )
      fClose( ::hFilTxt )
   end if

   ::cFilTxt      := ""

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TSndRecInf

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath

   ::oDbfSenderReciver  := nil
   ::oDbfFilesReciver   := nil

   DEFINE TABLE ::oDbfSenderReciver FILE "SndLog.Dbf" CLASS "SndLog" ALIAS "SndLog" PATH ( ::cPath ) VIA ( cDriver ) COMMENT "Registro de los envios"

      FIELD NAME "lSelect"    TYPE "L" LEN   1 DEC 0  COMMENT "Seleccionado para envío"   OF ::oDbfSenderReciver
      FIELD NAME "lTipo"      TYPE "L" LEN   1 DEC 0  COMMENT "Tipo envío o recepción"    OF ::oDbfSenderReciver
      FIELD NAME "nEnvio"     TYPE "N" LEN   9 DEC 0  COMMENT "Número del envío"          OF ::oDbfSenderReciver
      FIELD NAME "dFecha"     TYPE "D" LEN   8 DEC 0  COMMENT "Fecha del envío"           OF ::oDbfSenderReciver
      FIELD NAME "cArchivo"   TYPE "C" LEN  80 DEC 0  COMMENT "Nombre fichero de datos"   OF ::oDbfSenderReciver
      FIELD NAME "cLog"       TYPE "C" LEN  80 DEC 0  COMMENT "Nombre fichero del log"    OF ::oDbfSenderReciver

      INDEX TO "SndLog.Cdx"   TAG "nEnvio"   ON "Str( nEnvio )" NODELETED                 OF ::oDbfSenderReciver

   END DATABASE ::oDbfSenderReciver

   DEFINE TABLE ::oDbfFilesReciver FILE "SndFil.Dbf" CLASS "SndFil" ALIAS "SndFil" PATH ( ::cPath ) VIA ( cDriver ) COMMENT "Registro de ficheros recibidos"

      FIELD NAME "cArchivo"   TYPE "C" LEN  80 DEC 0  COMMENT "Nombre del fichero"        OF ::oDbfFilesReciver
      FIELD NAME "dFecha"     TYPE "D" LEN   8 DEC 0  COMMENT "Fecha del envío"           OF ::oDbfFilesReciver
      FIELD NAME "lProced"    TYPE "L" LEN   1 DEC 0  COMMENT "Procesado"                 OF ::oDbfFilesReciver

      INDEX TO "SndFil.Cdx"   TAG "cArchivo"  ON "cArchivo"        NODELETED              OF ::oDbfFilesReciver

   END DATABASE ::oDbfFilesReciver

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath ) CLASS TSndRecInf

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

   dbcloseall()

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbfSenderReciver ) .or. Empty( ::oDbfFilesReciver )
         ::DefineFiles()
      end if

      ::oDbfSenderReciver:Activate( .f., !( lExclusive ) )

      ::oDbfFilesReciver:Activate(  .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de envios y recepciones" )

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TSndRecInf

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      if !Empty( ::oDbfSenderReciver ) .or. Empty( ::oDbfFilesReciver )
         ::oDbfSenderReciver:End()
      end if

      if !Empty( ::oDbfFilesReciver )
         ::oDbfFilesReciver:End()
      end if

   RECOVER

      lOpen       := .f.

      msgStop( "Imposible cerrar todas las bases de datos.", "Atención" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::oDbfSenderReciver  := nil
   ::oDbfFilesReciver   := nil

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD Activate( lAuto ) CLASS TSndRecInf

   local oBmp
   local oBrwSnd
   local oBrwRec
   local cTipEnv     := if( nTipConInt() == 2, "Por internet", "Por medio fisico" )

   DEFAULT lAuto     := .f.

   if ( nTipConInt() == 2 .and. !isInternet() )
      msgStop( "No dispone de conexión a internet en estos momentos.")
      return ( Self )
   end if

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( Self )
   end if

   if !::OpenFiles()
      return ( Self )
   end if

   ::lInProcess      := .t.

   ::LoadFromIni()

   /*
   Apertura del fichero de texto ----------------------------------------------
   */

   DEFINE DIALOG ::oDlg RESOURCE "Internet_0" OF oWnd()

      REDEFINE PAGES ::oFld ;
         ID       10;
         OF       ::oDlg ;
         DIALOGS  "Internet_1",;
                  "Internet_2",;
                  "Internet_3",;
                  "Internet_4",;
                  "Internet_5",;
                  "Internet_6"

      /*
      Bitmap-------------------------------------------------------------------
		*/

      REDEFINE BITMAP oBmp ;
         RESOURCE "gc_satellite_dish2_48" ;
         ID       500 ;
         TRANSPARENT ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY PROMPT cCodEnvUsr() ;
         ID       100 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY PROMPT cTipEnv ;
         ID       110 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY PROMPT cNomConInt();
         ID       120 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY PROMPT cUsrConInt();
         ID       130 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY PROMPT cSitFtp();
         ID       140 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE SAY PROMPT cUsrFtp();
         ID       150 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE RADIO ::nTipoEnvio ;
         ID       160, 161, 162 ;
         OF       ::oFld:aDialogs[ 1 ]

      REDEFINE CHECKBOX ::lGetProcesados ;
         ID       170 ;
         WHEN     ( lUsrMaster() ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE CHECKBOX ::lGetFueraSecuencia ;
         ID       180 ;
         WHEN     ( lUsrMaster() ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE CHECKBOX ::lGetEliminarFicheros ;
         ID       190 ;
         WHEN     ( lUsrMaster() ) ;
         OF       ::oFld:aDialogs[1]

      REDEFINE CHECKBOX ::lImprimirEnvio ;
         ID       200 ;
         OF       ::oFld:aDialogs[1]

      REDEFINE CHECKBOX ::lExportarPda ;
         ID       210 ;
         OF       ::oFld:aDialogs[1]

      /*
      Primera caja de dialogo--------------------------------------------------
      */

      oBrwSnd                        := IXBrowse():New( ::oFld:aDialogs[ 2 ] )

      oBrwSnd:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwSnd:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwSnd:SetArray( ::aSend, , , .f. )

      oBrwSnd:lHScroll               := .f.
      oBrwSnd:nMarqueeStyle          := 5

      oBrwSnd:CreateFromResource( 100 )

      with object ( oBrwSnd:addCol() )
         :cHeader       := "Se. Seleccionada"
         :bEditValue    := {|| ::aSend[ oBrwSnd:nArrayAt ]:lSelectSend }
         :nWidth        := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwSnd:addCol() )
         :cHeader       := "Documento"
         :bEditValue    := {|| ::aSend[ oBrwSnd:nArrayAt ]:cText + " envio" }
         :nWidth        := 300
      end with

      oBrwSnd:bLDblClick   := {|| ::aSend[ oBrwSnd:nArrayAt ]:lSelectSend := !::aSend[ oBrwSnd:nArrayAt ]:lSelectSend, oBrwSnd:Refresh() }

      REDEFINE BUTTON ;
         ID       501 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( ::aSend[ oBrwSnd:nArrayAt ]:lSelectSend := !::aSend[ oBrwSnd:nArrayAt ]:lSelectSend, oBrwSnd:Refresh() )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aSend, {|o| o:lSelectSend := .t. }, oBrwSnd:Refresh() ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       ::oFld:aDialogs[ 2 ] ;
         ACTION   ( aEval( ::aSend, {|o| o:lSelectSend := .f. }, oBrwSnd:Refresh() ) )

      /*
      Segunda caja de dialogo--------------------------------------------------
      */

      oBrwRec                        := IXBrowse():New( ::oFld:aDialogs[ 3 ] )

      oBrwRec:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwRec:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwRec:SetArray( ::aSend, , , .f. )

      oBrwRec:lHScroll               := .f.
      oBrwRec:nMarqueeStyle          := 5

      oBrwRec:CreateFromResource( 100 )

      with object ( oBrwRec:addCol() )
         :cHeader       := "Se. Seleccionada"
         :bEditValue    := {|| ::aSend[ oBrwRec:nArrayAt ]:lSelectRecive }
         :nWidth        := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( oBrwRec:addCol() )
         :cHeader       := "Documento"
         :bEditValue    := {|| ::aSend[ oBrwRec:nArrayAt ]:cText + " recepción" }
         :nWidth        := 300
      end with

      oBrwRec:bLDblClick   := {|| ::aSend[ oBrwRec:nArrayAt ]:lSelectRecive := !::aSend[ oBrwRec:nArrayAt ]:lSelectRecive, oBrwRec:Refresh() }

      REDEFINE BUTTON ;
         ID       501 ;
         OF       ::oFld:aDialogs[ 3 ] ;
         ACTION   ( ::aSend[ oBrwRec:nArrayAt ]:lSelectRecive := !::aSend[ oBrwRec:nArrayAt ]:lSelectRecive, oBrwRec:Refresh() )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       ::oFld:aDialogs[ 3 ] ;
         ACTION   ( aEval( ::aSend, {|o| o:lSelectRecive := .t. }, oBrwRec:Refresh() ) )

      REDEFINE BUTTON ;
         ID       503 ;
         OF       ::oFld:aDialogs[ 3 ] ;
         ACTION   ( aEval( ::aSend, {|o| o:lSelectRecive := .f. }, oBrwRec:Refresh() ) )

      /*
      Tercera caja de dialogo--------------------------------------------------
      */

      ::oTree     := TTreeView():Redefine( 100, ::oFld:aDialogs[ 4 ] )

      REDEFINE SAY ::oPro ;
         PROMPT   ::cPro ;
         ID       110 ;
         OF       ::oFld:aDialogs[ 4 ]

      REDEFINE APOLOMETER ::oMtr ;
         VAR      ::nMtr ;
         ID       120 ;
         OF       ::oFld:aDialogs[ 4 ]

      /*
      Browse-------------------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       501 ;
         OF       ::oFld:aDialogs[ 5 ] ;
         ACTION   ( ::oDbfSenderReciver:FieldPutByName( "lSelect", ! ::oDbfSenderReciver:lSelect ), ::oBrwHistorial:Refresh() )

      REDEFINE BUTTON ;
         ID       502 ;
         OF       ::oFld:aDialogs[ 5 ] ;
         ACTION   ( ::ZoomHistorial() )

      ::oBrwHistorial                 := IXBrowse():New( ::oFld:aDialogs[ 5 ] )

      ::oDbfSenderReciver:SetBrowse( ::oBrwHistorial, .f. )

      ::oBrwHistorial:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwHistorial:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwHistorial:nMarqueeStyle   := 5

      ::oBrwHistorial:CreateFromResource( 100 )

      with object ( ::oBrwHistorial:addCol() )
         :cHeader       := "Se. Seleccionada"
         :bStrData      := {|| "" }
         :bEditValue    := {|| ::oDbfSenderReciver:lSelect }
         :nWidth        := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwHistorial:addCol() )
         :cHeader       := "Envio"
         :bEditValue    := {|| ::oDbfSenderReciver:nEnvio }
         :nWidth        := 70
         :cEditPicture  := "999999999"
         :nDataStrAlign := 1
         :nHeadStrAlign := 1
      end with

      with object ( ::oBrwHistorial:addCol() )
         :cHeader       := "Fecha"
         :bEditValue    := {|| Dtoc( ::oDbfSenderReciver:dFecha ) }
         :nWidth        := 70
      end with

      with object ( ::oBrwHistorial:addCol() )
         :cHeader       := "Fichero"
         :bEditValue    := {|| ::oDbfSenderReciver:cLog }
         :nWidth        := 300
      end with

      ::oBrwHistorial:bLDblClick := {|| ::ZoomHistorial() }

      /*
      Ficheros a enviar--------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       500 ;
         OF       ::oFld:aDialogs[ 6 ] ;
         ACTION   (  ::oDbfFilesReciver:FieldPutByName( "lProced", !::oDbfFilesReciver:lProced ), ::oBrwFiles:Refresh() )

      REDEFINE BUTTON ;
         ID       510 ;
         OF       ::oFld:aDialogs[ 6 ] ;
         ACTION   (  ::oDbfFilesReciver:Delete(), ::oBrwFiles:Refresh() )

      ::oBrwFiles                 := IXBrowse():New( ::oFld:aDialogs[ 6 ] )

      ::oDbfFilesReciver:SetBrowse( ::oBrwFiles, .f. )

      ::oBrwFiles:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      ::oBrwFiles:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oBrwFiles:nMarqueeStyle   := 5

      ::oBrwFiles:CreateFromResource( 100 )

      with object ( ::oBrwFiles:addCol() )
         :cHeader       := "Se. Seleccionada"
         :bStrData      := {|| "" }
         :bEditValue    := {|| ::oDbfFilesReciver:lProced }
         :nWidth        := 20
         :SetCheck( { "Sel16", "Nil16" } )
      end with

      with object ( ::oBrwFiles:addCol() )
         :cHeader       := "Fecha"
         :bEditValue    := {|| Dtoc( ::oDbfFilesReciver:dFecha ) }
         :nWidth        := 70
      end with

      with object ( ::oBrwFiles:addCol() )
         :cHeader       := "Fichero"
         :bEditValue    := {|| ::oDbfFilesReciver:cArchivo }
         :nWidth        := 300
      end with

      /*
      REDEFINE LISTBOX ::oBrwFiles ;
         FIELDS   if( ::oDbfFilesReciver:lProced, ::oBmpSel, "" ) ,;
                  Dtoc( ::oDbfFilesReciver:dFecha ),;
                  ::oDbfFilesReciver:cArchivo ;
         SIZES    14,;
                  70,;
                  300 ;
         HEAD     "S",;
                  "Fecha",;
                  "Fichero" ;
         ID       100 ;
         OF       ::oFld:aDialogs[ 6 ]

      ::oDbfFilesReciver:SetBrowse( ::oBrwFiles )
      */

      /*
      Botones------------------------------------------------------------------
      */

      REDEFINE BUTTON ;                            // Boton guardar
         ID       40 ;
         OF       ::oDlg ;
         ACTION   ( ::SaveToIni( .t. ) )

      REDEFINE BUTTON ::oBotonAnterior ;          // Boton anterior
         ID       20 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonAnterior() )

      REDEFINE BUTTON ::oBotonSiguiente ;         // Boton de Siguiente
         ID       30 ;
         OF       ::oDlg ;
         ACTION   ( ::BotonSiguiente() )

      REDEFINE BUTTON ::oBtnOk ;
         ID       IDOK ;
         OF       ::oDlg ;
         ACTION   ( ::Execute( .t., .t., ::lImprimirEnvio) )

      REDEFINE BUTTON ::oBtnCancel ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         ACTION   ( ::oDlg:end() )

   if lAuto
      ::oDlg:bStart  := {|| ::Execute( .t., .t., .f. ), ::oDlg:End() }
   end if

   ACTIVATE DIALOG ::oDlg CENTER

   /*
   Grabamos el fichero---------------------------------------------------------
   */

   ::SaveMessageToFile()

   /*
   Saliendo--------------------------------------------------------------------
   */

   oBmp:End()

   ::CloseFiles()

   ::lInProcess   := .f.

Return nil

//----------------------------------------------------------------------------//

METHOD BotonSiguiente() CLASS TSndRecInf

   do case
      case ::oFld:nOption == 1 .and. ::nTipoEnvio == 1
         ::oFld:GoNext()
         ::oBotonAnterior:Show()

      case ::oFld:nOption == 2 .and. ::nTipoEnvio == 1
         ::oFld:GoNext()
         ::oBotonSiguiente:Hide()
         ::oBtnOk:Show()

      case ::oFld:nOption == 1 .and. ::nTipoEnvio == 2
         ::oFld:SetOption( 5 )
         ::oBotonAnterior:Show()
         ::oBotonSiguiente:Hide()
         ::oBtnOk:Hide()

      case ::oFld:nOption == 1 .and. ::nTipoEnvio == 3
         ::oFld:SetOption( 6 )
         ::oBotonAnterior:Show()
         ::oBotonSiguiente:Hide()
         ::oBtnOk:Hide()

   end case

return ( Self )

//-----------------------------------------------------------------------//
//
//procesos a realizar al pulsar sobre anterior de la ventana principal
//

METHOD BotonAnterior() CLASS TSndRecInf

   do case
      case ::oFld:nOption == 2
         ::oBotonAnterior:Hide()
         ::oFld:GoPrev()
         ::oBtnOk:Show()

      case ::oFld:nOption == 5 .or. ::oFld:nOption == 6
         ::oFld:SetOption( 1 )
         ::oBotonAnterior:Hide()
         ::oBotonSiguiente:Show()
         ::oBtnOk:Show()

      otherwise
         ::oBotonSiguiente:Show()
         ::oFld:GoPrev()
         ::oBtnOk:Show()

   end case

return ( Self )

//-----------------------------------------------------------------------//

METHOD Execute( lSend, lRecive, lImprimirEnvio ) CLASS TSndRecInf

   local n
   local nZip
   local aFiles
   local cFileCatalog
   local nUltimoEnvio      := nUltimoEnvioInformacion()
   local aSend

   DEFAULT lSend           := .t.
   DEFAULT lRecive         := .t.
   DEFAULT lImprimirEnvio  := .f.

   if ::oDlg != nil
      ::oDlg:Disable()
   end if

   if !Empty( ::oBotonAnterior )
      ::oBotonAnterior:Hide()
   end if

   if !Empty( ::oBotonSiguiente )
      ::oBotonSiguiente:Hide()
   end if

   if !Empty( ::oBtnOk )
      ::oBtnOk:Hide()
   end if

   ::SaveToIni()

   // Nos vamos a la ultima pagina------------------------------------------------

   if !Empty( ::oFld )
      ::oFld:SetOption( 4 )
   end if

   // Borramos los mensajes anteriores-----------------------------------------

   if ::oTree != nil
      ::oTree:DeleteAll()
   end if

   // Limpiamos los directorios de envios y recepciones---------------------------

   eraseFilesInDirectory( cPatIn(),  "*.*" )
   eraseFilesInDirectory( cPatOut(), "*.*" )
   eraseFilesInDirectory( cPatSnd(), "*.*" )

   /*
   Segun el tipo de envio------------------------------------------------------
   */

   if ::nTipoEnvio == 1

      /*
      Envios----------------------------------------------------------------------
      */

      ::SetText( 'Seleccionando datos', 1 ) 

      if lSend
         aEval( ::aSend, {|o| if( o:lSelectSend, ( ::SetText( o:cText, 2 ), o:CreateData(), EraseFilesInDirectory(cPatSnd(), "*.*" ), Self ), ) } )
      end if

      /*
      Conexion con el sitio ftp---------------------------------------------------
      */

      ::ftpConexion()

      if ::lFtpValido

         /*
         Enviarlos a internet--------------------------------------------------------
         */

         ::SetText( 'Enviando datos', 1 )

         if lSend
            aEval( ::aSend, {|o| if( o:lSelectSend, ( ::SetText( o:cText, 2 ), o:SendData(), Self ), ) } )
         end if

         /*
         Recepciones-----------------------------------------------------------------
         */

         ::SetText( 'Recibiendo datos', 1 )

         if lRecive
            aEval( ::aSend, {|o| if ( o:lSelectRecive, ( ::SetText( o:cText, 2 ), o:ReciveData(), Self ), ) } )
         end if

         /*
         Recepciones-----------------------------------------------------------------
         */

         ::SetText( 'Procesando datos', 1 )

         if lRecive
            aEval( ::aSend, {|o| if ( o:lSelectRecive, ( ::SetText( o:cText, 2 ), o:Process(), Self ), ) } )
         end if

         /*
         Recepciones-----------------------------------------------------------------
         */

         ::SetText( 'Borrando de recepciones', 1 )

         if lRecive .and. ::lServer .and. !::lGetEliminarFicheros
            aEval( ::aFilesProcessed, {| cFile | ::SetText( 'Borrando fichero ' + cFile, 2 ), ftpEraseFile( cFile, Self ) } )
         end if

         /*
         Cerramos las comunicaciones-------------------------------------------
         */

         ::CloseConexion()

         /*
         Dejar los datos como estaban------------------------------------------
         */

         ::SetText( 'Restaurando datos', 1 )

         if lSend
            aEval( ::aSend, {|o| if( o:lSelectSend, ( ::SetText( o:cText, 2 ), o:RestoreData(), Self ), ) } )
         end if

         /*
         Catalogar el envio y la recepcion-------------------------------------
         */

         if lSend .or. lRecive

            ::oDbfSenderReciver:Append()

            cFileCatalog                        := cPatLog() + "Snd" + StrZero( nUltimoEnvio, 6 ) + ".Zip"
            ::oDbfSenderReciver:nEnvio          := nUltimoEnvio
            ::oDbfSenderReciver:lTipo           := .t.
            ::oDbfSenderReciver:dFecha          := GetSysDate()
            ::oDbfSenderReciver:cLog            := ::cFilTxt

            ::SetText( "Comprimiendo información para el catalogo", 1 )

            hb_SetDiskZip( {|| nil } )
            aEval( Directory( cPatOut() + "*.*" ), { | cName, nIndex | hb_ZipFile( cFileCatalog, cPatOut() + "\" + cName[ 1 ], 9 ) } )
            hb_gcAll()

            ::oDbfSenderReciver:Save()

            nUltimoEnvioInformacion( ++nUltimoEnvio )

         end if

      else

         ::SetText( 'Conexion invalida', 1 )

      end if

   else

      ::oDbfSenderReciver:GoTop()
      while !::oDbfSenderReciver:Eof()

         if ::oDbfSenderReciver:lSelect

            if file( Rtrim( ::oDbfSenderReciver:cArchivo ) )

               aFiles      := Hb_GetFilesInZip( Rtrim( ::oDbfSenderReciver:cArchivo ) )
               if !Hb_UnZipFile( Rtrim( ::oDbfSenderReciver:cArchivo ), , , , cPatOut(), aFiles )
                  MsgStop( "No se ha descomprimido el fichero " + Rtrim( ::oDbfSenderReciver:cArchivo ), "Error" )
               end if
               hb_gcAll()

               ::oDbfSenderReciver:FieldPutByName( 'lSelect', .f. )

               /*
               Conexion con el sitio ftp------------------------------------------
               */

               ::FtpConexion()

               if ::lFtpValido

                  ::SetText( 'Reenviando envio número ' + Trans( ::oDbfSenderReciver:nEnvio, "999999999" ), 1 )

                  aFiles   := Directory( cPatOut() + "*.*" )

                  for n := 1 to len( aFiles )

                     if ftpSndFile( cPatOut() + aFiles[ n, 1 ], aFiles[ n, 1 ], Self )
                        ::SetText( "Fichero reenviados " + cValToChar( aFiles[ n, 1 ] ), 2 )
                     else
                        ::SetText( "ERROR reenviando fichero " + cValToChar( aFiles[ n, 1 ] ), 2 )
                     end if

                  next

               end if

            else

               ::SetText( "ERROR el fichero comprimido " + Rtrim( ::oDbfSenderReciver:cArchivo ) + " no existe", 2 )

            end if

         end if

         ::oDbfSenderReciver:Skip()

      end while

   end if

   /*
   Limpiamos los directorios de envios y recepciones---------------------------
   */

   EraseFilesInDirectory(cPatIn(),  "*.*" )
   EraseFilesInDirectory(cPatOut(), "*.*" )
   EraseFilesInDirectory(cPatSnd(), "*.*" )

   /*
   Exportamos los datos a la pda-----------------------------------------------
   */

   if ::lExportarPda
      PdaEnvioRecepcionController():getInstance():exportJson()
   end if 

   /*
   Cerrando--------------------------------------------------------------------
   */

   ::SetText( 'Proceso finalizado', 1 )

   if !Empty( ::oBtnCancel )
      ::oBtnCancel:bAction  := {|| ::oDlg:end() }
      SetWindowText( ::oBtnCancel:hWnd, "&Cerrar" )
   end if

   if lImprimirEnvio
      ::PrintLog()
   end if

   if ::oDlg != nil
      ::oDlg:Enable()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD FtpConexion() CLASS TSndRecInf

   local cUrl
   local nRetry            := 0
   local ftpSit            := Rtrim( cSitFtp() )    //cFirstPath( Rtrim( cSitFtp() ) )
   local ftpDir            := cNoPathLeft( Rtrim( cSitFtp() ) )
   local nbrUsr            := Rtrim( cUsrFtp() )
   local accUsr            := Rtrim( cPswFtp() )
   local pasInt            := uFieldEmpresa( "lPasEnvio" )
   local nPuerto           := 21

   ::lFtpValido            := .f.

   if nTipConInt() == 2

      ::oFtp               := TFtpCurl():New( nbrUsr, accUsr, ftpSit, nPuerto )
      ::oFtp:setPassive( pasInt )

      if ::oFtp:CreateConexion()

         ::lFtpValido      := .t.

      else

         msgStop( "Imposible conectar al sitio ftp " + ::oFtp:cServer )

      end if

   else

      ::lFtpValido         := .t.

   end if

Return ( ::lFtpValido )

//---------------------------------------------------------------------------//

METHOD CloseConexion() CLASS TSndRecInf

   if !Empty( ::oFtp )
      ::oFtp:EndConexion()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD testFtpConexion()

   local lConnect

   if ::ftpConexion() .and. !empty( ::oFtp )
      lConnect      := ::oFtp:testConexion() 
   end if 

   ::closeConexion()

   if ( lConnect )
      msgStop( "Conexión con servidor FTP establecida" )
   else
      msgStop( "Error al conectar con servidor FTP" )
   end if 

RETURN ( lConnect )

//---------------------------------------------------------------------------//

METHOD SetText( cText, nLevel ) CLASS TSndRecInf

   DEFAULT nLevel    := 3

   if nLevel < 3 .and. ::oPro != nil
      ::oPro:SetText( cText )
   end if

   if Empty( ::cFilTxt )
      ::cFilTxt      := cGetNewFileName( cPatLog() + "Snd" + Dtos( Date() ) + StrTran( Time(), ":", "" ) ) + ".Txt"
      ::hFilTxt      := fCreate( ::cFilTxt )
   end if

   if Empty( ::hFilTxt )
      ::hFilTxt      := fOpen( ::cFilTxt, 1 )
   endif

   /*
   Escritura en el fichero
   */

   do case
      case nLevel == 1
         fWrite( ::hFilTxt, cValToChar( cText ) + CRLF )
      case nLevel == 2
         fWrite( ::hFilTxt, Space( 3 ) + cValToChar( cText ) + CRLF )
      case nLevel == 3
         fWrite( ::hFilTxt, Space( 6 ) + cValToChar( cText ) + CRLF )
   end case

   if ::oTree != nil
      do case
         case nLevel == 1
            ::oSubItem  := ::oTree:Add( cText )
            ::oTree:Select( ::oSubItem )
         case nLevel == 2
            ::oSubItem2 := ::oSubItem:Add( cText )
            ::oTree:Select( ::oSubItem2 )
            ::oSubItem:Expand()
         case nLevel == 3
            ::oTree:Select( ::oSubItem2:Add( cText ) )
            ::oSubItem2:Expand()
      end case
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AppendFileRecive( cFile ) CLASS TSndRecInf

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   aAdd( ::aFilesProcessed, cFile )

   if !::oDbfFilesReciver:Seek( cFile )
      ::oDbfFilesReciver:Append()
   else
      ::oDbfFilesReciver:Load()
   end if

   ::oDbfFilesReciver:cArchivo   := cFile
   ::oDbfFilesReciver:dFecha     := GetSysDate()
   ::oDbfFilesReciver:lProced    := .t.

   ::oDbfFilesReciver:Save()

   RECOVER USING oError

      msgStop( "Error al añadir registro " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

METHOD lPriorFileRecive( cFile ) CLASS TSndRecInf

   local lResult     := .f.
   local cFileExt    := GetFileExt( cFile )
   local cFileNoExt  := GetFileNoExt( cFile )
   local cTypeFile   := Left( cFileNoExt, At( "0", cFileNoExt ) - 1 )
   local nNumberFile := Val( Right( cFileNoExt, 6 ) ) - 1
   local cNumberFile := StrZero( nNumberFile, 6 )

   if nNumberFile < 0
      lResult        := .t.
   else
      lResult        := ::oDbfFilesReciver:Seek( cTypeFile + cNumberFile + "." + cFileExt )
   end if

Return ( lResult )

//----------------------------------------------------------------------------//

METHOD ZoomHistorial() CLASS TSndRecInf

   local oMemo
   local cMemo
   local oDlg

   cMemo          := Memoread( ::oDbfSenderReciver:cLog )

   DEFINE DIALOG oDlg RESOURCE "InfoEnvio"

   REDEFINE GET ::oDbfSenderReciver:nEnvio ;
      ID       100 ;
      PICTURE  "999999999" ;
      WHEN     ( .f. ) ;
      OF       oDlg

   REDEFINE GET ::oDbfSenderReciver:dFecha ;
      ID       110 ;
      SPINNER;
      WHEN     ( .f. ) ;
      OF       oDlg

   REDEFINE GET oMemo VAR cMemo ;
      MEMO ;
      READONLY ;
      ID       120  ;
      OF       oDlg

   REDEFINE BUTTON ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   ( oDlg:End() )

   ACTIVATE DIALOG oDlg CENTER

Return ( Self )

//---------------------------------------------------------------------------//

METHOD GetFiles( aSource, cTarget, lDisco ) CLASS TSndRecInf

   local lSuccess       := .f.

   DEFAULT lDisco       := ( nTipConInt() == 1 )

   if ValType( aSource ) != "A"
      aSource           := { aSource }
   end if

   if lDisco
      lSuccess          := ::lLocalGetFiles( aSource, cTarget )
   else
      lSuccess          := ::lFtpGetFiles( aSource, cTarget )
   end if

return ( lSuccess )

//---------------------------------------------------------------------------//

METHOD lLocalGetFiles( aSource, cTarget )

   local n 
   local i
   local aFiles      := {}
   local lResult     := .t.

   for n := 1 to Len( aSource )

      aFiles         := Directory( ::getPathComunication() + aSource[ n ] )

      for i := 1 to Len( aFiles )

         if ::lFileProcesed( aFiles[ i, 1 ] )
            ::SetText( "INFORMACIÓN fichero " + cValToChar( aFiles[ i, 1 ] ) + " ya procesado." )
            if !::lGetProcesados
               loop
            end if
         end if

         if !::lFileRecive( aFiles[ i, 1 ] ) .and. !::lPriorFileRecive( aFiles[ i, 1 ] )
            ::SetText( "INFORMACIÓN fichero " + cValToChar( aFiles[ i, 1 ] ) + " fuera de secuencia." )
            if !::lGetFueraSecuencia
               loop
            end if
         end if

         if isFalse( __CopyFile( ::getPathComunication() + aFiles[ i, 1 ], cTarget + aFiles[ i, 1 ] ) )
            lResult  := .f.
         end if

      next

   next

return ( lResult )

//---------------------------------------------------------------------------//

METHOD lFtpGetFiles( aSource, cTarget )

   local n 
   local i
   local aFiles            := {}
   local lResult           := .t.
   local lValido           := .t.
   local cFile

   for n := 1 to Len( aSource )

      aFiles                  := aFileSource( ::oFTP:listFiles(), aSource[ n ] )
   
      for each cFile in aFiles

         if ::lFileProcesed( cFile )
            ::SetText( "INFORMACIÓN fichero " + cValToChar( cFile ) + " ya procesado." )
            lValido     := .f.
            if !::lGetProcesados
               loop
            end if
         end if

         if !::lFileRecive( cFile ) .and. !::lPriorFileRecive( cFile )
            ::SetText( "INFORMACIÓN fichero " + cValToChar( cFile ) + " fuera de secuencia." )
            lValido     := .f.
            if !::lGetFueraSecuencia
               loop
            end if
         end if

         if lValido 
            ::SetText( "INFORMACIÓN fichero " + cValToChar( cFile ) + " para procesar." )
         end if

         if ::oFtp:downloadFile( cFile, cTarget + cFile ) != 0
            lResult        := .f.
         end if

      next

   next

return ( lResult )

//---------------------------------------------------------------------------//

METHOD SendFiles( aSource, aTarget, cDirectory ) CLASS TSndRecInf

   local n
   local oFile
   local hSource
   local hTarget
   local cBuffer
   local nBuffer        := 2000
   local nBytes         := 0
   local nFile          := 0
   local nTotSize       := 0
   local lRet           := .f.
   local lDisco         := ( nTipConInt() == 1 )

   DEFAULT aTarget      := aSource

   if ValType( aSource ) != "A"
      aSource           := { aSource }
   end if

   if ValType( aTarget ) != "A"
      aTarget           := { aTarget }
   end if

   if ( nTipConInt() == 1 )
      lRet              := ::lLocalSendFiles( aSource, aTarget, cDirectory )
   else
      lRet              := ::lFtpSendFiles( aSource, aTarget, cDirectory )
   end if

return ( lRet )

//----------------------------------------------------------------------------//

METHOD lLocalSendFiles( aSource, aTarget, cDirectory ) CLASS TSndRecInf

   local n
   local lRet  := .t.

   if !empty( cDirectory ) .and. !lIsDir( ::getPathComunication() + cDirectory )
      makeDir( cNamePath( ::getPathComunication() + cDirectory ) )
   end if 

   for n := 1 to Len( aSource )

      if isFalse( __CopyFile( aSource[ n ], ::getPathComunication() + aTarget[ n ] ) )
         lRet  := .f.
      end if

   next

Return ( lRet )

//---------------------------------------------------------------------------//

METHOD lFtpSendFiles( aSource, aTarget, cDirectory ) CLASS TSndRecInf

   local n 
   local lRet  := .t.

   for n := 1 to Len( aSource )

      if file( aSource[ n ] )

         LogWrite( aSource[ n ] )

         ::SetText( "El fichero " + aSource[ n ] + " exite." )      

         if isFalse( ::oFtp:createFile( aSource[ n ] ) )
            lRet  := .f.
         end if

      else

         ::SetText( "El fichero " + aSource[ n ] + " no exite." )

      end if

   next

Return ( lRet )

//---------------------------------------------------------------------------//

METHOD PrintLog() CLASS TSndRecInf

   local oFont
   local oReport
   local oColumn

   oFont       := TFont():New("Courier New", 9, -12 )

   oReport     := TReport():New( {  { || AllTrim( cCodEmp() + " - " + cNbrEmp() ) }, { || "Informe de envío y recepción" } },;
                                 {  { || "Fecha: " + Dtoc( Date() ) + " - " + Time() } },;
                                 {  { || "Página: " + Str( oReport:nPage, 3 ) } },;
                                 { oFont },;
                                 {},;
                                 .f.,;
                                 ,;
                                 ,;
                                 .f.,;
                                 .t.,;
                                 ,;
                                 ,;
                                 "Imprimiendo Log" )

   if !Empty( oReport ) .and. oReport:lCreated

      oColumn  := TRColumn():New( {}, 1, { {|| "" } }, 76, {}, , .f., , , .f., .f., , oReport )

      oReport:AddColumn( oColumn )

      oReport:nTitleUpLine := RPT_NOLINE
      oReport:nTitleDnLine := RPT_NOLINE

      oReport:Margin( .25, RPT_LEFT, RPT_INCHES)
      oReport:Margin( .25, RPT_TOP, RPT_INCHES)
      oReport:Margin( .25, RPT_BOTTOM, RPT_INCHES)

   else

      msgStop( "No se ha podido crear informe, revise la configuración de sus impresoras." )

   end if

   if !Empty( oReport )
      oReport:Activate( , , {|| ::SayMemo( oReport ) } )
   end if

   oFont:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SayMemo( oReport ) CLASS TSndRecInf

   local cText
   local cLine
   local nFor
   local nLines
   local nPageln

   cText    := MemoRead( ::cFilTxt )

   nLines   := MlCount( cText, 76 )
   nPageln  := 0

   for nFor := 1 to nLines

      cLine := MemoLine( cText, 76, nFor)

      oReport:StartLine()
      oReport:Say( 1, cLine )
      oReport:EndLine()

      nPageln     := nPageln + 1

      if nPageln == 60

         nFor     := GetTop( cText, nFor, nLines)
         nPageln  := 0

      endif

   next

return ( Self )

//---------------------------------------------------------------------------//

METHOD lZipData( cFileName ) CLASS TSndRecInf

   local lZip     := .t.
   local aDir     := Directory( cLastPath( cPatSnd() ) + "\*.*" )
   local aName

   hb_SetDiskZip( {|| nil } )
   
   for each aName in aDir

      SysRefresh()

      lZip        := hb_ZipFile( cPatOut() + cFileName, cLastPath( cPatSnd() ) + aName[ 1 ], 9 )
      if lZip
         ::SetText( "Comprimiendo " + lower( cLastPath( cPatSnd() ) + aName[ 1 ] ) + " en " + lower( cPatOut() + cFileName ) )
      else
         ::SetText( "Error comprimiendo " + lower( cLastPath( cPatSnd() ) + aName[ 1 ] ) + " en " + lower( cPatOut() + cFileName ) )
         exit
      end if

   next

   hb_gcAll()

Return ( lZip )

//----------------------------------------------------------------------------//

METHOD lUnZipData( cFileName, lInfo ) CLASS TSndRecInf

   local aDir
   local lUnZip   := .t.

   aDir           := hb_getfilesinzip( cFileName )
   lUnZip         := hb_unzipfile( cFileName, {|cName| if( istrue( lInfo), ::SetText( "Descomprimiendo " + lower( cName ) ), ) }, , , cPatSnd(), aDir )
   hb_gcAll()

Return ( lUnZip )

//----------------------------------------------------------------------------//

METHOD Reindexa( cPath ) CLASS TSndRecInf

   ::DefineFiles( cPath )

   if !Empty( ::oDbfSenderReciver )
      ::oDbfSenderReciver:IdxFDel()
      ::oDbfSenderReciver:Activate( .f., .t., .f. )
      ::oDbfSenderReciver:Pack()
      ::oDbfSenderReciver:End()
   end if

   if !Empty( ::oDbfFilesReciver )
      ::oDbfFilesReciver:IdxFDel()
      ::oDbfFilesReciver:Activate( .f., .t., .f. )
      ::oDbfFilesReciver:Pack()
      ::oDbfFilesReciver:End()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lFileRecive( cFile ) CLASS TSndRecInf

   local lFileRecive := .f.

   if !Empty( cFile ) .and. IsChar( cFile )
      lFileRecive    := ::oDbfFilesReciver:Seek( Rtrim( cFile ) )
   end if

Return ( lFileRecive )

//---------------------------------------------------------------------------//

METHOD lFileProcesed( cFile ) CLASS TSndRecInf

   local lFileProcesed  := .f.

   if !Empty( cFile ) .and. IsChar( cFile )
      lFileProcesed     := ::oDbfFilesReciver:Seek( Rtrim( cFile ) ) .and. ::oDbfFilesReciver:lProced
   end if

Return ( lFileProcesed )

//---------------------------------------------------------------------------//

METHOD SyncAllDbf() CLASS TSndRecInf

   if Empty( ::oDbfSenderReciver ) .or. Empty( ::oDbfFilesReciver )
      ::DefineFiles()
   end if

   lCheckDbf( ::oDbfSenderReciver )

   lCheckDbf( ::oDbfFilesReciver )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ActivateTablet() CLASS TSndRecInf

   local oDlg
   local oSayGeneral
   local oBtnAceptar
   local oBtnSalir

   if !::OpenFiles()
      return ( Self )
   end if

   ::lInProcess   := .t.

   ::LoadFromIni()

   /*
   Diálogo--------------------------------------------------------------------
   */

   oDlg              := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )  

   /*
   Cabeceras------------------------------------------------------------------
   */

   oSayGeneral       := TGridSay():Build(    {     "nRow"      => 0,;
                                                   "nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                                                   "bText"     => {|| "Envío y recepción de información" },;
                                                   "oWnd"      => oDlg,;
                                                   "oFont"     => oGridFontBold(),;
                                                   "lPixels"   => .t.,;
                                                   "nClrText"  => Rgb( 0, 0, 0 ),;
                                                   "nClrBack"  => Rgb( 255, 255, 255 ),;
                                                   "nWidth"    => {|| GridWidth( 8, oDlg ) },;
                                                   "nHeight"   => 32,;
                                                   "lDesign"   => .f. } )

   oBtnAceptar       := TGridImage():Build(  {     "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 9.0, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_ok_64",;
                                                   "bLClicked" => {|| oBtnAceptar:Hide(), oBtnSalir:Disable(), ::Execute(), oBtnSalir:Enable() },;
                                                   "oWnd"      => oDlg } )

   oBtnSalir         := TGridImage():Build(  {     "nTop"      => 5,;
                                                   "nLeft"     => {|| GridWidth( 10.5, oDlg ) },;
                                                   "nWidth"    => 64,;
                                                   "nHeight"   => 64,;
                                                   "cResName"  => "gc_error_64",;
                                                   "bLClicked" => {|| oDlg:End() },;
                                                   "oWnd"      => oDlg } )

   /*
   Montamos el treeview--------------------------------------------------------
   */

   ::oTree           := TGridTreeView():Build(  {  "nTop"      => 50 ,;
                                                   "nLeft"     => GridWidth( 0.5, oDlg ),;
                                                   "oWnd"      => oDlg,;
                                                   "lPixel"    => .t.,;
                                                   "nWidth"    => GridWidth( 9, oDlg ),;
                                                   "nHeight"   => GridWidth( 6.75, oDlg ) } ) 

   /*
   Redimensionamos y activamos el diálogo-------------------------------------
   */

   oDlg:bResized     := {|| GridResize( oDlg ) }

   ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

   /*
   Grabamos el fichero---------------------------------------------------------
   */

   ::SaveMessageToFile()

   /*
   Saliendo--------------------------------------------------------------------
   */

   ::CloseFiles()

   ::lInProcess   := .f.

Return ( Self )

//----------------------------------------------------------------------------//

METHOD aExtensions() CLASS TSndRecInf

   local aExt  := {}

   if ::lServer
      aExt  := aRetDlgEmp()
   else
      aExt  := aRetDlgEmp()
      aAdd( aExt, "All" )
   end if

Return ( aExt )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//--------------------------FUNCIONES----------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function CopyFtpFile( cOrigen, cDestino, oFTP )

   local oFile
   local nBytes
   local cBytes
   local hTarget

   hTarget        := fCreate( cDestino )

   if fError() != 0

      oFile       := TFtpFile():New( cOrigen, oFTP )
      oFile:OpenRead()

      while ( nBytes := Len( cBytes := oFile:Read( 2000 ) ) ) > 0
         fWrite( hTarget, cBytes, nBytes )
      end while

      fClose( hTarget )

      oFile:end()

      Return .t.

   end if 

Return .f.

//---------------------------------------------------------------------------//

FUNCTION FtpSndFile( aSource, aTarget, oSender, cDirectory )

   local n
   local oFile
   local hSource
   local hTarget
   local cBuffer
   local nBuffer        := 2000
   local nBytes         := 0
   local nFile          := 0
   local nTotSize       := 0
   local lRet           := .f.
   local lDisco         := ( nTipConInt() == 1 )

   DEFAULT aTarget      := aSource

   IF ValType( aSource ) != "A"
      aSource           := { aSource }
   END IF

   IF ValType( aTarget ) != "A"
      aTarget           := { aTarget }
   END IF

   cBuffer              := Space( nBuffer )

   for n := 1 to Len( aSource )

      if File( aSource[ n ] )
         hSource        := fOpen( aSource[ n ] )
         nTotSize       += fSeek( hSource, 0, 2 )
         fClose( hSource )
      end if

      SysRefresh()

   next

   /*
   Tamaño cero salida----------------------------------------------------------
   */

   if nTotSize == 0
      Return .f.
   end if

   if !Empty( oSender )

      if !Empty( oSender:oMtr )
         oSender:oMtr:nTotal     := nTotSize
      end if   

      oSender:SetText( "Tamaño fichero " + Alltrim( Str( nTotSize ) ) )

   end if

   /*
   Esto es para un disco-------------------------------------------------------
   */

   if lDisco

      if !empty( cDirectory ) .and. !lIsDir( cDirectory )
         makeDir( cNamePath( cDirectory ) )
      end if 

      for n := 1 to Len( aSource )

         hSource        := fOpen( aSource[ n ] )
         hTarget        := fCreate( oSender:getPathComunication() + aTarget[ n ] )

         if !Empty( oSender ) .and. !Empty( oSender:oMtr )
            oSender:oMtr:Set( 0 )
            oSender:oMtr:nTotal := nTotSize
         end if

         /*
         Nos vamos al principio del fichero------------------------------------
         */

         fSeek( hSource, 0, 0 )

         SysRefresh()

         while ( nBytes := fRead( hSource, @cBuffer, nBuffer ) ) > 0

            fWrite( hTarget, cBuffer, nBytes )

            if !Empty( oSender:oMtr )
               oSender:oMtr:Set( nFile += nBytes )
            end if

            SysRefresh()

         end while

         fClose( hSource )
         fClose( hTarget )

      next

      lRet  := nTotSize == nFile

   else

      for n := 1 to Len( aSource )

         if !Empty( oSender )

            if Empty( oSender:oFtp )

               msgInfo( "No hay conexiones de internet disponibles." )

            else

               oFile             := TFtpFile():New( aSource[ n ], oSender:oFtp ) 
               lRet              := oFile:CopyFtpFile( aSource[ n ], aTarget[ n ], oSender:oFtp )
               lRet              := CopyFtpFile( aSource[ n ], aTarget[ n ], oSender:oFtp )    
               

               //CopyFtpFile( aSource[ n ], aTarget[ n ], oSender:oFtp )

            end if

            oSender:SetText( "Procesando fichero " + aTarget[ n ] )

         end if

         if !lRet

            if !Empty( oSender )

               oSender:SetText( "Error procesando fichero " + aTarget[ n ] )
               oSender:SetText( GetErrMsg() )

            end if

         end if

         oFile:End()

      next

   end if

   if !Empty( oSender:oMtr )
      oSender:oMtr:Set( 0 )
   end if

   SysRefresh()

return ( lRet )

//----------------------------------------------------------------------------//

function ftpGetFiles( aSource, cTarget, oSender, lDisco )

   local n
   local i
   local hTarget
   local cBuffer
   local nBuffer        := 2000
   local nBytes
   local oFile
   local aFiles
   local nFile          := 0
   local nTotSize       := 0
   local oFtp           := oSender:oFtp
   local oMeter         := oSender:oMtr
   local lSuccess       := .f.

   DEFAULT lDisco       := ( nTipConInt() == 1 )

   if ValType( aSource ) != "A"
      aSource           := { aSource }
   end if

   cBuffer              := Space( nBuffer )

   /*
   Comenzemos a bajar el fichero-----------------------------------------------
   */

   for n := 1 to Len( aSource )

      if lDisco
         aFiles         := Directory( oSender:getPathComunication() + aSource[ n ] )
      else
         aFiles         := TrimFileName( oFTP:listFiles( aSource[ n ] ) )
      end if

      Msginfo( ValToPrg( aFiles ) )
      TraceLog( ValToPrg( aFiles ) )

      for i := 1 to Len( aFiles )

         oSender:SetText( "Ficheros en el servidor : " + cValToChar( aFiles[ i, 1 ] ) )

         if ( Len( aFiles ) > 0 ) .and. isNum( aFiles[ i, 2 ] ) .and. ( aFiles[ i, 2 ] != 0 )
            nTotSize    += aFiles[ i , 2 ]
         endif

      next

      if oMeter != nil
         oMeter:nTotal  := nTotSize
      end if

      for i := 1 to Len( aFiles )

         if oSender:lFileProcesed( aFiles[ i, 1 ] )
            oSender:SetText( "INFORMACIÓN fichero " + cValToChar( aFiles[ i, 1 ] ) + " ya procesado." )
            if !oSender:lGetProcesados
               loop
            end if
         end if

         if !oSender:lFileRecive( aFiles[ i, 1 ] ) .and. !oSender:lPriorFileRecive( aFiles[ i, 1 ] )
            oSender:SetText( "INFORMACIÓN fichero " + cValToChar( aFiles[ i, 1 ] ) + " fuera de secuencia." )
            if !oSender:lGetFueraSecuencia
               loop
            end if
         end if

         
         if lDisco

            //__CopyFile( ::getPathComunication() + cFileName, cTarget + cFileName )

            //oFile    := TTxtFile():New( oSender:getPathComunication() + aFiles[ i, 1 ] )

         else

            ?cTarget + aFiles[ i, 1 ]

            oFtp:DownLoadFile( cTarget + aFiles[ i, 1 ] )

            /*oFile    := TFtpFile():New( aFiles[ i, 1 ], oFTP )
            oFile:OpenRead()*/

         end if


         // Comprueba q el tamaño del fichero sea distinto de cero ------------

         




         /*if aFiles[ i, 2 ] != 0

            if IsChar( aFiles[ i, 1 ] )

               //hTarget     := fCreate( cTarget + aFiles[ i, 1 ] )

               Msginfo( ValToPrg( aFiles ) )

               if lDisco

                  //__CopyFile( ::getPathComunication() + cFileName, cTarget + cFileName )


                  //oFile    := TTxtFile():New( oSender:getPathComunication() + aFiles[ i, 1 ] )

               else

                  ?cTarget + aFiles[ i, 1 ]

                  objinspect(aFiles)

                  //oFtp:DownLoadFile( cLocalFile, cRemoteFile )


                  /*oFile    := TFtpFile():New( aFiles[ i, 1 ], oFTP )
                  oFile:OpenRead()*/

               //end if

               /*while ( nBytes := Len( cBuffer := if( lDisco, oFile:cGetStr( nBuffer ), oFile:Read( nBuffer ) ) ) ) > 0

                  fWrite( hTarget, cBuffer, nBytes )

                  if oMeter != nil
                     oMeter:Set( nFile += nBytes )
                  end if

                  SysRefresh()

               end while

               fClose( hTarget )*/

               //oFile:end()

               /*oSender:SetText( "Fichero recibido : " + cValToChar( aFiles[ i, 1 ] ) )

               oSender:AppendFileRecive( aFiles[ i, 1 ] )

            end if*/

         /*else

            oSender:SetText( "INFORMACIÓN fichero " + cValToChar( aFiles[ i, 1 ] ) + " está vacio." )

         end if*/

      next

      lSuccess          := ( nFile >= nTotSize )

   next

   if oMeter != nil
      oMeter:Set( 0 )
   end if

return ( lSuccess )

//----------------------------------------------------------------------------//

Function TrimFileName( aFiles )

   local cFile

   for each cFile in aFiles

      cFile[1]    :=  SubStr( cFile[1], 40 )

   next

Return ( aFiles )

//----------------------------------------------------------------------------//

Function ftpDeleteMask( cMask, oSender, lDisco )

   local oFtp              := oSender:oFtp

   DEFAULT lDisco          := ( nTipConInt() == 1 )

   if lDisco
      EraseFilesInDirectory( oSender:getPathComunication(), cMask )
   else
      if oFtp != nil
         oFtp:DeleteMask( cMask )
      end if
   end if

Return nil

//----------------------------------------------------------------------------//

Function ftpEraseFile( cFile, oSender, lDisco )

   local oFtp              := oSender:oFtp

   DEFAULT lDisco          := ( nTipConInt() == 1 )

   if lDisco
      fErase( oSender:getPathComunication() + cFile )
   else
      if oFtp != nil
         oFtp:DeleteFile( cFile )
      end if
   end if

Return nil

//----------------------------------------------------------------------------//

Function nAreas()

   local n
   local nAreas   := 0

   for n := 1 to 255
      if !Empty( Alias( n ) )
         ++nAreas
      end if
   next

return ( nAreas )

//----------------------------------------------------------------------------//

Static Function GetTop( cText, nFor, nLines )

   local cLine
   local lTest := .t.

   while lTest = .t. .and. nFor <= nLines

      nFor  := nFor + 1

      cLine := MemoLine( cText, 76, nFor )

      lTest := Empty( cLine )

   end while

   nFor -= 1

   SysRefresh()

Return nFor

//----------------------------------------------------------------------------//

Static Function aFileSource( aFiles, cSource )

   local cFile
   local aFileSource    := {}

   for each cFile in aFiles

      if lValidSourdeFile( cFile, cSource )

         aAdd( aFileSource, cFile ) 

      end if

   next

Return aFileSource

//---------------------------------------------------------------------------//

Static function lValidSourdeFile( cFile, cSource )

   local lReturn  := .f.

   if Empty( cFile )
      Return .f.
   end if

   if SubStr( cFile, 1, 3 ) == SubStr( cSource, 1, 3 ) .and.;
      Right( cFile, 3 ) == Right( cSource, 3 )

      lReturn     := .t.

   end if

Return lReturn

//---------------------------------------------------------------------------//