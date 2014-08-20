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

   Method New()
   Method Create()                  INLINE ( Self )

   Method LoadFromIni()
   Method SaveToIni()

   Method SaveMessageToFile()

   Method Activate( oWnd )

   Method CatalogarTrasmision()

   Method DefineFiles()
   Method OpenFiles()
   Method CloseFiles()

   Method BuildFiles( lExclusive, cPath ) INLINE ( ::DefineFiles( cPath ), ::oDbfSenderReciver:Create(), ::oDbfFilesReciver:Create() )

   Method BotonSiguiente()
   Method BotonAnterior()

   Method Execute()

   Method Reindexa( cPath )

   Method SetText( cText )

   Method StartTimer()
   Method StopTimer()

   Method lPriorFileRecive( cFile )

   Method AppendFileRecive( cFile )
   Method SetProcedFileRecive( cFile, lProced )

   Method ZoomHistorial()

   Method FtpConexion()
   Method CloseConexion()

   METHOD PrintLog( cTextFile )

   METHOD SayMemo( cTextfile )

   Method lZipData( cFileName )
   Method lUnZipData( cFileName )

   Method lFileRecive( cFile )
   Method lFileProcesed( cFile )

   Method SyncAllDbf()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( oMenuItem, oWnd )

   DEFAULT oMenuItem    := "01073"

   ::nLevel             := nLevelUsr( oMenuItem )

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   ::cPro               := ""
   ::cSay               := ""
   ::nMtr               := 0
   ::aSend              := {}
   ::aFilesProcessed    := {}
   ::lFtpValido         := .f.
   ::cIniFile           := cPatEmp() + "Empresa.Ini"

   aAdd( ::aSend, TArticuloSenderReciver():New(             "Artículos",                Self ) )
   aAdd( ::aSend, TFamiliaSenderReciver():New(              "Familias",                 Self ) )
   aAdd( ::aSend, TClienteSenderReciver():New(              "Clientes",                 Self ) )
   aAdd( ::aSend, TProveedorSenderReciver():New(            "Proveedor",                Self ) )
   aAdd( ::aSend, TPedidosProveedorSenderReciver():New(     "Pedidos de proveedor",     Self ) )
   aAdd( ::aSend, TAlbaranesProveedorSenderReciver():New(   "Albaranes de proveedor",   Self ) )
   aAdd( ::aSend, TFacturasProveedorSenderReciver():New(    "Facturas de proveedor",    Self ) )
   aAdd( ::aSend, TPresupuestosClientesSenderReciver():New( "Presupuestos clientes",    Self ) )
   aAdd( ::aSend, TPedidosClientesSenderReciver():New(      "Pedidos clientes",         Self ) )
   aAdd( ::aSend, TAlbaranesClientesSenderReciver():New(    "Albaranes clientes",       Self ) )
   aAdd( ::aSend, TFacturasClientesSenderReciver():New(     "Facturas clientes",        Self ) )
   aAdd( ::aSend, TTiketsClientesSenderReciver():New(       "Tickets clientes",         Self ) )
   aAdd( ::aSend, TTurno():Initiate(                        "Sesiones",                 Self ) )
   aAdd( ::aSend, TRemMovAlm():Initiate(                    "Movimientos de almacen",   Self ) )
   aAdd( ::aSend, THisMovSenderReciver():New(               "Historico de movimientos", Self ) )
   aAdd( ::aSend, TUsuarioSenderReciver():New(              "Usuarios",                 Self ) )

   ::DefineFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

Method LoadFromIni()

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

RETURN ( Self )

//----------------------------------------------------------------------------//

Method StartTimer()

   if ::lPlanificarEnvio .or. ::lPlanificarRecepcion
      ::oTimer             := TTimer():New( 60000, {|| ::AutoExecute() }, oWnd() )
      ::oTimer:Activate()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method StopTimer()

   if ::oTimer != nil .and. ::oTimer:lActive
      ::oTimer:DeActivate()
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method SaveToIni( lMessage )

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

   if lMessage
      MsgInfo( "Configuración de envio guardada" )
   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

Method SaveMessageToFile()

   if !Empty( ::hFilTxt )
      fClose( ::hFilTxt )
   end if

   ::cFilTxt      := ""

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()

   ::cPath              := cPath

   ::oDbfSenderReciver  := nil
   ::oDbfFilesReciver   := nil

   DEFINE TABLE ::oDbfSenderReciver FILE "SndLog.Dbf" CLASS "SndLog" ALIAS "SndLog" PATH ( ::cPath ) VIA ( cDriver )COMMENT "Registro de los envios"

      FIELD NAME "lSelect"    TYPE "L" LEN   1 DEC 0  COMMENT "Seleccionado para envío"   OF ::oDbfSenderReciver
      FIELD NAME "lTipo"      TYPE "L" LEN   1 DEC 0  COMMENT "Tipo envío o recepción"    OF ::oDbfSenderReciver
      FIELD NAME "nEnvio"     TYPE "N" LEN   9 DEC 0  COMMENT "Número del envío"          OF ::oDbfSenderReciver
      FIELD NAME "dFecha"     TYPE "D" LEN   8 DEC 0  COMMENT "Fecha del envío"           OF ::oDbfSenderReciver
      FIELD NAME "cArchivo"   TYPE "C" LEN  80 DEC 0  COMMENT "Nombre fichero de datos"   OF ::oDbfSenderReciver
      FIELD NAME "cLog"       TYPE "C" LEN  80 DEC 0  COMMENT "Nombre fichero del log"    OF ::oDbfSenderReciver

      INDEX TO "SndLog.Cdx"   TAG "nEnvio"   ON "Str( nEnvio )" NODELETED                 OF ::oDbfSenderReciver

   END DATABASE ::oDbfSenderReciver

   DEFINE TABLE ::oDbfFilesReciver FILE "SndFil.Dbf" CLASS "SndFil" ALIAS "SndFil" PATH ( ::cPath ) VIA ( cDriver )COMMENT "Registro de ficheros recibidos"

      FIELD NAME "cArchivo"   TYPE "C" LEN  80 DEC 0  COMMENT "Nombre del fichero"        OF ::oDbfFilesReciver
      FIELD NAME "dFecha"     TYPE "D" LEN   8 DEC 0  COMMENT "Fecha del envío"           OF ::oDbfFilesReciver
      FIELD NAME "lProced"    TYPE "L" LEN   1 DEC 0  COMMENT "Procesado"                 OF ::oDbfFilesReciver

      INDEX TO "SndFil.Cdx"   TAG "cArchivo"  ON "cArchivo"        NODELETED              OF ::oDbfFilesReciver

   END DATABASE ::oDbfFilesReciver

RETURN ( Self )

//---------------------------------------------------------------------------//

Method OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.

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

Method CloseFiles()

   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   local lOpen    := .t.

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

METHOD Activate( oWnd, lAuto )

   local oBmp
   local oBrwSnd
   local oBrwRec
   local cTipEnv     := if( nTipConInt() == 2, "Por internet", "Por medio fisico" )

   DEFAULT lAuto     := .f.

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return ( Self )
   end if

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   if !::OpenFiles()
      return ( Self )
   end if

   ::lInProcess   := .t.

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
         RESOURCE "Satellite_dish_48_alpha" ;
         ID       500 ;
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
         ID       710 ;
         OF       ::oFld:aDialogs[1]

      /*
      Primera caja de dialogo--------------------------------------------------
      */

      oBrwSnd                        := TXBrowse():New( ::oFld:aDialogs[ 2 ] )

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

      oBrwRec                        := TXBrowse():New( ::oFld:aDialogs[ 3 ] )

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

      ::oBrwHistorial                 := TXBrowse():New( ::oFld:aDialogs[ 5 ] )

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

      ::oBrwFiles                 := TXBrowse():New( ::oFld:aDialogs[ 6 ] )

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

Method BotonSiguiente()


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

Method BotonAnterior()

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

METHOD Execute( lSend, lRecive, lImprimirEnvio )

   local n
   local nZip
   local aFiles
   local cFileCatalog
   local nUltimoEnvio      := nUltimoEnvioInformacion()

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

   /*
   Nos vamos a la ultima pagina------------------------------------------------
   */

   if !Empty( ::oFld )
      ::oFld:SetOption( 4 )
   end if

   // Borramos los mensajes anteriores-----------------------------------------

   if ::oTree != nil
      ::oTree:DeleteAll()
   end if

   /*
   Limpiamos los directorios de envios y recepciones---------------------------
   */

   EraseFilesInDirectory(cPatIn(),  "*.*" )
   EraseFilesInDirectory(cPatOut(), "*.*" )
   EraseFilesInDirectory(cPatSnd(), "*.*" )

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

      ::FtpConexion()

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
            aEval( ::aSend, {|o| if( o:lSelectRecive, ( ::SetText( o:cText, 2 ), o:ReciveData(), Self ), ) } )
         end if

         /*
         Recepciones-----------------------------------------------------------------
         */

         ::SetText( 'Procesando datos', 1 )

         if lRecive
            aEval( ::aSend, {|o| if( o:lSelectRecive, ( ::SetText( o:cText, 2 ), o:Process(), Self ), ) } )
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

                     if ftpSndFile( cPatOut() + aFiles[ n, 1 ], aFiles[ n, 1 ], 2000, Self )
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

//----------------------------------------------------------------------------//
/*
Method AutoExecute( lForced, lDialog, lImprimirEnvio )

   local oBmp
   local oDlg
   local cTime       := Time()

   cTime             := SubStr( cTime, 1, 2 ) + SubStr( cTime, 4, 2 )

   DEFAULT lForced   := .f.
   DEFAULT lDialog   := .t.

   // Vamos a mirar antes q no estemos en un proceso abierto

   if !::lInProcess // .and. nAreas() == 0

      if !::OpenFiles()
         return ( Self )
      end if

      // Flag pra no volver a entrar

      ::lInProcess   := .t.

      // Envio de información

      if lForced .or. ( ::lPlanificarEnvio .and. !::lEnviado .and. cTime >= ::cHoraEnvio )

         if lDialog

            DEFINE DIALOG oDlg NAME "SNDRECINF" TITLE "Proceso planificado"

               REDEFINE BITMAP oBmp;
                  RESOURCE "WEBTOP" ;
                  ID       600 ;
                  OF       oDlg

               REDEFINE SAY ::oPro ;
                  PROMPT   "Enviando información" ;
                  ID       110 ;
                  OF       oDlg

               oDlg:bStart := {|| ::Execute(), oDlg:bValid := {|| .t. }, oDlg:End() }

            ACTIVATE DIALOG oDlg CENTER VALID ( .f. )

            oBmp:End()

         else

            ::Execute( .t., .t., lImprimirEnvio )

         end if

         ::lEnviado  := .t.

         ::SaveMessageToFile()

      end if

      ::CloseFiles()

      ::lInProcess   := .f.

   else

      MsgStop( 'Proceso ya abierto' )

   end if

Return ( Self )
*/
//----------------------------------------------------------------------------//

METHOD SetText( cText, nLevel )

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

Method CatalogarTrasmision()

   local nUltimoEnvio            := nUltimoEnvioInformacion()

   ::oDbfSenderReciver:Append()
   ::oDbfSenderReciver:nEnvio    := ++nUltimoEnvio
   ::oDbfSenderReciver:dFecha    := GetSysDate()
   ::oDbfSenderReciver:cArchivo  := ::cFilTxt
   ::oDbfSenderReciver:Save()

   nUltimoEnvioInformacion( nUltimoEnvio )

Return ( Self )

//----------------------------------------------------------------------------//

Method AppendFileRecive( cFile )

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

Method SetProcedFileRecive( cFile, lProced )

   DEFAULT lProced   := .t.

   if ::oDbfFilesReciver:Seek( cFile )
      ::oDbfFilesReciver:Load()
      ::oDbfFilesReciver:lProced := lProced
      ::oDbfFilesReciver:Save()
   end if

Return ( Self )

//----------------------------------------------------------------------------//

Method lPriorFileRecive( cFile )

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

Method ZoomHistorial()

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

Method FtpConexion()

   local nRetry            := 0
   local ftpSit            := cFirstPath( Rtrim( cSitFtp() ) )
   local ftpDir            := cNoPathLeft( Rtrim( cSitFtp() ) )
   local nbrUsr            := Rtrim( cUsrFtp() )
   local accUsr            := Rtrim( cPswFtp() )
   local pasInt            := uFieldEmpresa( "lPasEnvio" )

   if nTipConInt() == 2

      while !::lFtpValido .and. nRetry < 3

         ::SetText( '> Conectando con el sitio ' + Rtrim( ftpSit ) + '...', 1 )

         ::oInt         := TInternet():New()
         ::oFtp         := TFtp():New( ftpSit, ::oInt, nbrUsr, accUsr, pasInt )

         if Empty( ::oFtp ) .or. Empty( ::oFtp:hFtp )

            ::SetText( "Imposible conectar con el sitio ftp " + Alltrim( ftpSit ), 1 )

            ::lFtpValido   := .f.

            ++nRetry
            ::SetText( "Reintento " + Alltrim( Str( nRetry ) ) + " de 3, en 10 segundos", 1 )

            DlgWait( 10 )

         else

            if !Empty( ftpDir )
               ::oFtp:SetCurrentDirectory( ftpDir )
            end if

            ::lFtpValido   := .t.

         end if

      end while

   else

      ::lFtpValido           := .t.

   end if

Return ( Self )

//---------------------------------------------------------------------------//
/*
Method FtpConexion()

   local oUrl
   local nRetry                     := 0
   local ftpSit                     := cFirstPath( Rtrim( cSitFtp() ) )
   local ftpDir                     := cNoPath( Rtrim( cSitFtp() ) )
   local nbrUsr                     := Rtrim( cUsrFtp() )
   local accUsr                     := Rtrim( cPswFtp() )
   local cUrl                       := "ftp://" + nbrUsr + ":" + accUsr + "@" + ftpSit

   if nTipConInt() == 2

      while !::lFtpValido .and. nRetry < 3

         ? cUrl

         ::SetText( '> Conectando con el sitio ' + Rtrim( ftpSit ) + '...', 1 )

         oUrl                       := tUrl():New( cUrl )
         ::oFtp                     := tIPClientFtp():New( oUrl, .t. )
         ::oFtp:nConnTimeout        := 20000
         ::oFtp:bUsePasv            := .t.

         if At( "@", nbrUsr ) > 0
            ::oFtp:oUrl:cServer     := ftpSit
            ::oFtp:oUrl:cUserID     := nbrUsr
            ::oFtp:oUrl:cPassword   := accUsr
         endif

         if !::oFtp:Open()

            ::SetText( "Imposible conectar con el sitio FTP " + oURL:cServer, 1 )

            ::lFtpValido            := .f.

            if ::oFTP:SocketCon == nil
               ::SetText( "Conexión no inicializada", 1 )
            elseif InetErrorCode( ::oFTP:SocketCon ) == 0
               ::SetText( "Respuesta del servidor: " + ::oFTP:cReply, 1 )
            else
               ::SetText( "Error en la conexión:" + " " + InetErrorDesc( ::oFTP:SocketCon ), 1 )
            end if

            ++nRetry
            ::SetText( "Reintento" + Str( nRetry ) + " de 3, en 10 segundos", 1 )

            DlgWait( 10 )

            ::oFtp:Close()

         else

            if !Empty( ftpDir )
               ::oFtp:CWD( ftpDir )
            end if

            ::lFtpValido            := .t.

         end if

      end while

   else

      ::lFtpValido                  := .t.

   end if

Return ( Self )
*/
//---------------------------------------------------------------------------//

Method CloseConexion()

   if !Empty( ::oInt )
      ::oInt:end()
   end if

   if !Empty( ::oFtp )
      ::oFtp:end()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

FUNCTION FtpSndFile( aSource, aTarget, nBufSize, oSender, lDisco )

   local n
   local oFile
   local hSource
   local hTarget
   local cBuffer
   local nBytes         := 0
   local nFile          := 0
   local nTotSize       := 0
   local lRet           := .f.

   DEFAULT aTarget      := aSource
   DEFAULT nBufSize     := 2000
   DEFAULT lDisco       := ( nTipConInt() == 1 )

   IF ValType( aSource ) != "A"
      aSource           := { aSource }
   END IF

   IF ValType( aTarget ) != "A"
      aTarget           := { aTarget }
   END IF

   cBuffer              := Space( nBufSize )

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

      oSender:oMtr:nTotal     := nTotSize

      oSender:SetText( "Tamaño fichero " + Alltrim( Str( nTotSize ) ) )

   end if

   /*
   Esto es para un disco-------------------------------------------------------
   */

   if lDisco

      for n := 1 to Len( aSource )

         hSource        := fOpen( aSource[ n ] )
         hTarget        := fCreate( cRutConInt() + aTarget[ n ] )

         if !Empty( oSender )
            oSender:oMtr:Set( 0 )
            oSender:oMtr:nTotal := nTotSize
         end if

         /*
         Nos vamos al principio del fichero
         */

         fSeek( hSource, 0, 0 )

         SysRefresh()

         while ( nBytes := fRead( hSource, @cBuffer, nBufSize ) ) > 0

            fWrite( hTarget, cBuffer, nBytes )

            if !Empty( oSender )
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

               lRet              := oFile:PutFile()

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

   if !Empty( oSender )
      oSender:oMtr:Set( 0 )
   end if

   SysRefresh()

return ( lRet )

//----------------------------------------------------------------------------//

function ftpGetFiles( aSource, cTarget, nBufSize, oSender, lDisco )

   local n
   local i
   local hTarget
   local cBuffer
   local nBytes
   local oFile
   local aFiles
   local nFile          := 0
   local nTotSize       := 0
   local oFtp           := oSender:oFtp
   local oMeter         := oSender:oMtr
   local lSuccess       := .f.

   DEFAULT nBufSize     := 2000
   DEFAULT lDisco       := ( nTipConInt() == 1 )

   if ValType( aSource ) != "A"
      aSource           := { aSource }
   end if

   cBuffer              := Space( nBufSize )

   /*
   Comenzemos a bajar el fichero-----------------------------------------------
   */

   for n := 1 to Len( aSource )

      if lDisco
         aFiles         := Directory( cRutConInt() + aSource[ n ] )
      else
         aFiles         := oFTP:Directory( aSource[ n ] )
      end if

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

         // Comprueba q el tamaño del fichero sea distinto de cero ------------

         if aFiles[ i, 2 ] != 0

            if IsChar( aFiles[ i, 1 ] )

               hTarget     := fCreate( cTarget + aFiles[ i, 1 ] )

               if lDisco
                  oFile    := TTxtFile():New( cRutConInt() + aFiles[ i, 1 ] )
               else
                  oFile    := TFtpFile():New( aFiles[ i, 1 ], oFTP )
                  oFile:OpenRead()
               end if

               while ( nBytes := Len( cBuffer := if( lDisco, oFile:cGetStr( nBufSize ), oFile:Read( nBufSize ) ) ) ) > 0

                  fWrite( hTarget, cBuffer, nBytes )

                  if oMeter != nil
                     oMeter:Set( nFile += nBytes )
                  end if

                  SysRefresh()

               end while

               fClose( hTarget )

               oFile:end()

               oSender:SetText( "Fichero recibido : " + cValToChar( aFiles[ i, 1 ] ) )

               oSender:AppendFileRecive( aFiles[ i, 1 ] )

            end if

         else

            oSender:SetText( "INFORMACIÓN fichero " + cValToChar( aFiles[ i, 1 ] ) + " está vacio." )

         end if

      next

      lSuccess          := ( nFile >= nTotSize )

   next

   if oMeter != nil
      oMeter:Set( 0 )
   end if

return ( lSuccess )

//----------------------------------------------------------------------------//

Function ftpDeleteMask( cMask, oSender, lDisco )

   local oFtp              := oSender:oFtp

   DEFAULT lDisco          := ( nTipConInt() == 1 )

   if lDisco
      EraseFilesInDirectory(cRutConInt(), cMask )
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
      fErase( cRutConInt() + cFile )
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

METHOD PrintLog()

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

METHOD SayMemo( oReport )

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

Method lZipData( cFileName )

   local lZip     := .t.
   local aDir     := Directory( cLastPath( cPatSnd() ) + "\*.*" )
   local aName

   hb_SetDiskZip( {|| nil } )
   
   for each aName in aDir

      SysRefresh()

      lZip        := hb_ZipFile( cPatOut() + cFileName, cLastPath( cPatSnd() ) + aName[ 1 ], 9 )
      if !lZip
         exit
      end if

   next

   hb_gcAll()

Return ( lZip )

//----------------------------------------------------------------------------//

Method lUnZipData( cFileName )

   local aDir
   local nZip
   local lUnZip   := .t.

   aDir           := Hb_GetFilesInZip( cFileName )
   lUnZip         := Hb_UnZipFile( cFileName, { | cName, nPos | ::SetText( "Descomprimiendo " + cName ) }, , , cPatSnd(), aDir )
   hb_gcAll()

Return ( lUnZip )

//----------------------------------------------------------------------------//

METHOD Reindexa( cPath )

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

Method lFileRecive( cFile )

   local lFileRecive    := .f.

   if !Empty( cFile ) .and. IsChar( cFile )
      lFileRecive    := ::oDbfFilesReciver:Seek( Rtrim( cFile ) )
   end if

Return ( lFileRecive )

//---------------------------------------------------------------------------//

Method lFileProcesed( cFile )

   local lFileProcesed  := .f.

   if !Empty( cFile ) .and. IsChar( cFile )
      lFileProcesed     := ::oDbfFilesReciver:Seek( Rtrim( cFile ) ) .and. ::oDbfFilesReciver:lProced
   end if

Return ( lFileProcesed )

//---------------------------------------------------------------------------//

Method SyncAllDbf()

   if Empty( ::oDbfSenderReciver ) .or. Empty( ::oDbfFilesReciver )
      ::DefineFiles()
   end if

   lCheckDbf( ::oDbfSenderReciver )
   lCheckDbf( ::oDbfFilesReciver )

Return ( Self )

//---------------------------------------------------------------------------//
