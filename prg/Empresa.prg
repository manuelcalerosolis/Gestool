#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Empresa.ch"
#include "Image.ch"
#include "Xbrowse.ch"
#include "dbInfo.ch" 

#define _MENUITEM_            "01003" 

#define fldGeneral            oFld:aDialogs[ 1 ]
#define fldValores            oFld:aDialogs[ 2 ]
#define fldArticulos          oFld:aDialogs[ 3 ]
#define fldTPV                oFld:aDialogs[ 4 ]
#define fldContadores         oFld:aDialogs[ 5 ]
#define fldContabilidad       oFld:aDialogs[ 6 ]
#define fldEnvios             oFld:aDialogs[ 7 ]
#define fldComunicaciones     oFld:aDialogs[ 8 ]

static oWndBrw
static dbfEmp
static dbfDiv
static dbfDlg
static tmpDlg
static dbfBnc
static dbfCount
static dbfUser
static oBandera

static cNewDlg
static cNewBnc
static lActEmp                := .t.
static nIvaReq                := 1

static cOldCodigoEmpresa    

static nSemillaContadores     := 1

static aImportacion         

static cOldSerie
static cOldNomSer

static cNewEmpresa            := ""

static oOfficeBar

static oBanco
static oPais

static cTmpCon
static tmpCount

static bEdit                  := {| aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode | EdtRec( aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode ) }
static bEditConfig            := {| aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode | EditConfig( aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode ) }
static bEdtDlg                := {| aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode, cCod | EdtDet( aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode, cCod ) }

static aItmEmp                := {}
static aTiempo                := { "0 min.", "1 min.", "2 min.", "5 min.", "10 min.", "15 min.", "30 min.", "45 min.", "1 hora", "2 horas", "4 horas", "8 horas" }
static aTiempoImp             := { "0 seg.", "5 seg.", "10 seg.", "15 seg.", "20 seg.", "25 seg.", "30 seg.", "35 seg.", "40 seg.", "45 seg.", "50 seg.", "55 seg.", "60 seg." }

static aTipImpTpv             := { "No imprimir", "Imprimir", "Imprimir regalo" }

static cTiempoPed

static aDocumentos    
static aImagenes

static oCmbDocumentos
static cCmbDocumentos

static oNombreSerie
static cNombreSerie

static oCmbSerie
static cCmbSerie

static oGetSerie
static cGetSerie

static oGetContador
static nGetContador

static oGetFormato
static cGetFormato

static oGetCopias
static nGetCopias

static oGetNFCPrefijo
static cGetNFCPrefijo

static oGetNFCContador
static cGetNFCContador

static oGroupNFC
static cGrupoNFC

static oGetPlantillaDefecto
static cGetPlantillaDefecto

static oGetPrecioVenta
static oGetPrecioWebVenta
static oGetPrecioProducto
static oGetPrecioCombinado

static oCmbContabilidad
static cCmbContabilidad        
static aCmbContabilidad        := { "Contaplus", "A3 CON" }   

static cMailNotificaciones
static lInformacionInmediata 

static nView

static TComercio

static NUMERO_TARIFAS          := 6     

//----------------------------------------------------------------------------//

STATIC FUNCTION OpenFiles( lCount )

   local lOpen    := .t.
   local oError
   local oBlock

   DEFAULT lCount := .t.

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE

      USE ( cPatDat() + "DIVISAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DIVISAS", @dbfDiv ) )
      SET ADSINDEX TO ( cPatDat() + "DIVISAS.CDX" ) ADDITIVE

      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDlg ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE

      if lCount
         USE ( cPatEmp() + "NCOUNT.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "NCOUNT", @dbfCount ) )
         SET ADSINDEX TO ( cPatEmp() + "NCOUNT.CDX" ) ADDITIVE
      end if

      oBanco      := TBancos():Create()
      oBanco:OpenFiles()

      oPais       := TPais():Create( cPatDat() )
      oPais:OpenFiles()

      oBandera    := TBandera():New()

      TComercio   := TComercio():Default()

      aDocumentos := {  "Pedido a proveedores",;
                        "Albaran de proveedores",;
                        "Facturas de proveedores",;
                        "Facturas rectificativas de proveedores",;
                        "S.A.T. a clientes",;
                        "Presupuestos a clientes",;
                        "Pedido de clientes",;
                        "Albaranes de clientes",;
                        "Facturas a clientes",;
                        "Anticipos de facturas clientes",;
                        "Facturas rectificativas",;
                        "Introducción depósitos",;
                        "Estado depósitos",;
                        "Tickets a clientes",;
                        "Partes de producción",;
                        "Expedientes",;
                        "Movimientos de almacén",;
                        "Sesiónes",;
                        "Remesas bancarias",;
                        "Ordenes de carga",;
                        "Cobros de clientes",;
                        "Recibos de proveedor",;
                        "Recibos de clientes",;
                        "Liquidación de agentes",;
                        "Entrega a cuenta pedido",;
                        "Entrega a cuenta albarán",;
                        "Entradas y salidas" }

      aImagenes   := {  "gc_clipboard_empty_businessman_16",;
                        "gc_document_empty_businessman_16",;
                        "gc_document_text_businessman_16",;
                        "gc_document_text_businessman_16",;
                        "gc_power_drill_sat_user_16",;
                        "gc_notebook_user_16",;
                        "gc_clipboard_empty_user_16",;
                        "gc_document_empty_16",;
                        "gc_document_text_businessman_16",;
                        "gc_document_text_money2_16",;
                        "gc_document_text_delete2_16",;
                        "gc_package_plus_16",;
                        "gc_package_check_16",;
                        "gc_cash_register_user_16",;
                        "gc_document_text_worker_16",;
                        "gc_folder_document_16",;
                        "gc_pencil_package_16",;
                        "gc_clock_16",;
                        "gc_briefcase2_document_16",;
                        "gc_small_truck_16",;
                        "gc_user_16",;
                        "gc_briefcase2_businessman_16",;
                        "gc_briefcase2_user_16",;
                        "gc_briefcase2_agent_16",;
                        "gc_clipboard_empty_bag_16",;
                        "gc_document_empty_bag_16",;
                        "gc_cash_register_refresh_16" }

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

Static Function CloseFiles()

   if !Empty( dbfEmp )
      ( dbfEmp )->( dbCloseArea() )
   end if

   if !Empty( dbfDiv )
      ( dbfDiv )->( dbCloseArea() )
   end if

   if !Empty( dbfDlg )
      ( dbfDlg )->( dbCloseArea() )
   end if

   if !Empty( dbfUser )
      ( dbfUser )->( dbCloseArea() )
   end if

   if !Empty( dbfCount )
      ( dbfCount )->( dbCloseArea() )
   end if

   if !Empty( oBanco )
      oBanco:End()
   end if

   if !Empty( oPais )
      oPais:End()
   end if

   TComercio:endInstance()

   dbfEmp      := nil
   dbfDiv      := nil
   dbfDlg      := nil
   dbfUser     := nil
   dbfCount    := nil
   oBanco      := nil
   oPais       := nil
   oWndBrw     := nil

Return .t.

//----------------------------------------------------------------------------//

FUNCTION Empresa( oMenuItem, oWnd )

   local nLevel         := 0

   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  oWnd        := oWnd()

   if oWndBrw == nil

      /*
      Obtenemos el nivel de acceso
      */

      nLevel            := nLevelUsr( oMenuItem )

      if nAnd( nLevel, 1 ) != 0
         msgStop( "Acceso no permitido." )
         return nil
      end if

      /*
      Cerramos todas las ventanas
      */

      if oWnd != nil
         sysrefresh(); oWnd:CloseAll(); sysrefresh()
      end if

      /*
      Apertura de ficheros
      */

      if !OpenFiles()
         return nil
      end if

      /*
      Anotamos el movimiento para el navegador
      */

      DEFINE SHELL oWndBrw FROM 2, 10 TO 18, 70 ;
			TITLE 	"Empresas" ;
         ALIAS    ( dbfEmp );
         PROMPTS  "Código",;
						"Nombre";
         MRU      "gc_factory_16";
         BITMAP   clrTopArchivos ;
         APPEND   ( if( oUser():lCambiarEmpresa, WinAppEmp(), ) );
         EDIT     ( if( oUser():lCambiarEmpresa, WinEdtEmp(), ) ) ;
         DELETE   ( if( oUser():lCambiarEmpresa, WinDelEmp(), ) ) ;
         LEVEL    nLevel ;
         XBROWSE ;
         OF       oWnd

      oWndBrw:lAutoPos              := .f.

      if oUser():lCambiarEmpresa 
         oWndBrw:oBrw:bLDblClick    := {||   setEmpresa( ( dbfEmp )->CodEmp, dbfEmp, dbfDlg, dbfUser ),;
                                             chkTurno( , oWnd ),;
                                             if( !Empty( oWndBrw ), oWndBrw:End( .t. ), ) }
      else
         oWndBrw:oBrw:bLDblClick    := {|| nil }
      end if

      // Columnas ---------------------------------------------------------------

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Seleccionada"
         :nHeadBmpNo       := 3
         :bStrData         := {|| "" }
         :bEditValue       := {|| ( dbfEmp )->CodEmp == cCodigoEmpresaEnUso() }
         :nWidth           := 20
         :SetCheck( { "Sel16", "Nil16" } )
         :AddResource( "gc_factory_16" )
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Código"
         :cSortOrder       := "CodEmp"
         :bEditValue       := {|| if( ( dbfEmp )->lGrupo, "<" + rTrim( ( dbfEmp )->CodEmp ) + ">", ( dbfEmp )->CodEmp ) }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      with object ( oWndBrw:AddXCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNombre"
         :bEditValue       := {|| if( ( dbfEmp )->lGrupo, "<" + rTrim( ( dbfEmp )->cNombre ) + ">", ( dbfEmp )->cNombre ) }
         :nWidth           := 340
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oWndBrw:ClickOnHeader( oCol ) }
      end with

      oWndBrw:CreateXFromCode()

      // Botones ---------------------------------------------------------------

      DEFINE BTNSHELL RESOURCE "BUS" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:SearchSetFocus() ) ;
         TOOLTIP  "(B)uscar" ;
         HOTKEY   "B"

      oWndBrw:AddSeaBar()

   if oUser():lCambiarEmpresa

      DEFINE BTNSHELL RESOURCE "SEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( Eval( oWndBrw:oBrw:bLDblClick ) ) ;
         TOOLTIP  "Sele(c)cionar";
         HOTKEY   "C" ;
         LEVEL    ACC_ZOOM

      DEFINE BTNSHELL RESOURCE "NEW" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecAdd() );
         TOOLTIP  "(A)ñadir";
         HOTKEY   "A" ;
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "DUP" OF oWndBrw ;
         NOBORDER ;
         ACTION   ( if( oUser():lCambiarEmpresa, WinDupEmp(), ) );
         TOOLTIP  "(D)uplicar";
         HOTKEY   "D";
         LEVEL    ACC_APPD

      DEFINE BTNSHELL RESOURCE "EDIT" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecEdit() );
         TOOLTIP  "(M)odificar";
         MRU ;
         HOTKEY   "M" ;
         LEVEL    ACC_EDIT

   end if         

      DEFINE BTNSHELL RESOURCE "ZOOM" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinZooRec( oWndBrw:oBrw, bEdit, dbfEmp ) );
         TOOLTIP  "(Z)oom";
         MRU ;
         HOTKEY   "Z";
         LEVEL    ACC_ZOOM

   if oUser():lCambiarEmpresa      

      DEFINE BTNSHELL RESOURCE "DEL" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:RecDel(), oWndBrw:oBrw:Refresh() );
         TOOLTIP  "(E)liminar";
         HOTKEY   "E" ;
         LEVEL    ACC_DELE

      DEFINE BTNSHELL RESOURCE "CNFCLI" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( WinEdtRec( oWndBrw:oBrw, bEditConfig, dbfEmp ) ) ;
         TOOLTIP  "Con(f)igurar";
         HOTKEY   "F" ;
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "CAL" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( ActualizaEstructuras( dbfEmp, dbfDlg, dbfUser, oWndBrw, oWnd ) );
         TOOLTIP  "Ac(t)ualizar ficheros";
         HOTKEY   "T" ;
         LEVEL    ACC_EDIT

   end if         

      DEFINE BTNSHELL RESOURCE "END" GROUP OF oWndBrw ;
			NOBORDER ;
         ACTION   ( oWndBrw:End() ) ;
         TOOLTIP  "(S)alir";
         HOTKEY   "S"

      ACTIVATE WINDOW oWndBrw VALID ( CloseFiles() )

   else

		oWndBrw:setFocus()

   end if

RETURN NIL

//----------------------------------------------------------------------------//

Static Function WinAppEmp()

   if WinAppRec( oWndBrw, bEdit, dbfEmp )
      initialProccesBuildEmpresa()
   end if

RETURN ( nil )
       
//----------------------------------------------------------------------------//

Static Function WinDupEmp()

   if WinDupRec( oWndBrw, bEdit, dbfEmp )
      initialProccesBuildEmpresa()
   end if

RETURN ( nil )
       
//----------------------------------------------------------------------------//

Static Function initialProccesBuildEmpresa()

   local cCodigoEmpresa := ( dbfEmp )->CodEmp
   local cNombreEmpresa := ( dbfEmp )->cNombre

   /*
   Cerramos la ventana---------------------------------------------------------
   */

   oWndBrw:QuitOnProcess()
   oWndBrw:End()

   /*
   Cerramos todas los servicios------------------------------------------------
   */

   stopServices()

   /*
   Creamos empresa-------------------------------------------------------------
   */

   dbCloseAll()

   mkPathEmp( cCodigoEmpresa, cNombreEmpresa, cOldCodigoEmpresa, aImportacion, .t., .t., nSemillaContadores )

   /*
   Establecemos la empresa como la seleccionada-----------------------------
   */

   setEmpresa( cCodigoEmpresa )

   chkTurno( , oWnd() )

   /*
   Reindexamos--------------------------------------------------------------
   */

   reindexaEmp( cPatEmpOld( cCodigoEmpresa ), cCodigoEmpresa )

   /*
   Iniciamos todas los servicios---------------------------------------------
   */

   initServices()

RETURN ( nil )
       
//----------------------------------------------------------------------------//

Static Function WinEdtEmp()

   if WinEdtRec( oWndBrw, bEdit, dbfEmp )
      setEmpresa( ( dbfEmp )->CodEmp )
      chkTurno( , oWnd() )
   end if

RETURN ( nil )
       
//----------------------------------------------------------------------------//
/*
Devuelve el Nombre de la Empresa Activa
*/

STATIC FUNCTION WinDelEmp()

   local lRet     := .f.
   local cPath    := FullCurDir() + "Emp" + ( dbfEmp )->CodEmp + "\"

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return ( lRet )
   end if

   if ( dbfEmp )->CodEmp == cCodigoEmpresaEnUso()

      msgStop( "Imposible borrar empresa activa" )

   else

      if ApoloMsgNoYes( "Confirme eliminación de empresa", "Supresión de empresa" )

         if ApoloMsgNoYes( "Eliminara DEFINITIVAMENTE los datos de la empresa : " + Rtrim( ( dbfEmp )->cNombre ), "Confirme supresión de empresa" )

            CursorWait()

            if IsDirectory( cPath )
               EraseFilesInDirectory(cPath )
            end if

            while ( dbfDlg )->( dbSeek( ( dbfEmp )->CodEmp ) )
               if dbLock( dbfDlg )
                  ( dbfDlg )->( dbDelete() )
                  ( dbfDlg )->( dbUnLock() )
               end if
            end while


            DelRecno( dbfEmp, oWndBrw )

            lRet  := .t.

            CursorWE()

         end if

      end if

   end if

RETURN lRet

//----------------------------------------------------------------------------//

STATIC FUNCTION EdtRec( aTmp, aGet, dbfEmp, oBrw, bWhen, bValid, nMode )

	local oDlg
   local oFld
   local oBtnPrv
   local oBtnOk
	local oNomEmp
	local cNomEmp
	local oCodEmp
	local bmpEmp

   local oBmpEmp
   local oBmpChg

   local oBrwDet
   local oBrwBnc
   
   local oSemilla
   
   local oSayGrp
   local cSayGrp

   local oGetSemilla
   
   local oBmpGeneral
   local oBmpImportacion
   local oBmpDelegaciones
   local oBmpBancos
   local lAppendMode       := ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

   if ( lAppendMode ) .and. ( nUsrInUse() > 1 )
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return .f.
   end if

   cOldCodigoEmpresa       := Space( 4 )
   nSemillaContadores      := 1
   aImportacion            := aImportacion()

   // Para los servicios ------------------------------------------------------

   StopServices()

   if ( nMode == DUPL_MODE )
      cOldCodigoEmpresa    := aTmp[ _CODEMP ]
      aTmp[ _DINIOPE ]     := Ctod( "01/01/" + Str( Year( Date() ), 4 ) )
      aTmp[ _DFINOPE ]     := Ctod( "31/12/" + Str( Year( Date() ), 4 ) )
   end if 

   if ( nMode == APPD_MODE )
      aTmp[ _NCODCLI ]     := 7
      aTmp[ _NCODPRV ]     := 7
      aTmp[ _NNUMTUR ]     := 1
      aTmp[ _NNUMREM ]     := 1
      aTmp[ _NNUMMOV ]     := 1
      aTmp[ _NNUMLIQ ]     := 1
      aTmp[ _NNUMCOB ]     := 1
      aTmp[ _NNUMCAR ]     := 1
      aTmp[ _NDGTUND ]     := 8
      aTmp[ _NDGTESC ]     := 8
      aTmp[ _CDIVEMP ]     := "EUR"
      aTmp[ _CDIVCHG ]     := "PTS"
      aTmp[ _LSHWTAR1 ]    := .t.
      aTmp[ _LSHWTAR2 ]    := .t.
      aTmp[ _LSHWTAR3 ]    := .t.
      aTmp[ _LSHWTAR4 ]    := .t.
      aTmp[ _LSHWTAR5 ]    := .t.
      aTmp[ _LSHWTAR6 ]    := .t.
      aTmp[ _CTXTTAR1 ]    := "Precio 1"
      aTmp[ _CTXTTAR2 ]    := "Precio 2"
      aTmp[ _CTXTTAR3 ]    := "Precio 3"
      aTmp[ _CTXTTAR4 ]    := "Precio 4"
      aTmp[ _CTXTTAR5 ]    := "Precio 5"
      aTmp[ _CTXTTAR6 ]    := "Precio 6"
      aTmp[ _CNOMIMP  ]    := "IVA"
      aTmp[ _DINIOPE ]     := Ctod( "01/01/" + Str( Year( Date() ), 4 ) )
      aTmp[ _DFINOPE ]     := Ctod( "31/12/" + Str( Year( Date() ), 4 ) )
   end if

   cSayGrp                 := RetFld( aTmp[ _CCODGRP ], dbfEmp )

   if BeginEdtRec( aTmp, nMode )
      Return .f.
   end if

   DEFINE DIALOG oDlg RESOURCE "EMPRESA" TITLE LblTitle( nMode ) + "Empresas"

   if ( lAppendMode )

   REDEFINE FOLDER oFld ;
      ID       400 ;
      OF       oDlg ;
      PROMPT   "Em&presa",;
               "&Importación",;
               "De&legaciones";
      DIALOGS  "EMPRESA_1",;
               "EMPRESA_9",;
               "EMPRESA_11"

   else

   REDEFINE FOLDER oFld ;
      ID       400 ;
      OF       oDlg ;
      PROMPT   "Em&presa",;
               "De&legaciones" ;
      DIALOGS  "EMPRESA_1",;
               "EMPRESA_11"

   end if

   REDEFINE BITMAP oBmpGeneral ;
         ID       500 ;
         RESOURCE "gc_factory_48" ;
         TRANSPARENT ;
         OF       fldGeneral

   REDEFINE GET   aGet[ _CODEMP ] VAR aTmp[ _CODEMP ];
			ID 		100 ;
         WHEN     ( lAppendMode ) ;
         VALID    ( NotValid( aGet[ _CODEMP ], dbfEmp, .t., "0" ) .and. !Empty( aTmp[ _CODEMP ] ) ) ;
         PICTURE  "@!" ;
         OF       fldGeneral

   REDEFINE GET aTmp[ _CNOMBRE ];
			ID 		110 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			PICTURE 	"@!" ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _CNIF ] ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _CADMINIS ] ;
			ID 		130 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CNUMREGMER] ;
         ID       230 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CDOMICILIO] ;
			ID 		140 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CPOBLACION] ;
			ID 		150 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CPROVINCIA] ;
			ID 		160 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CCODPOS];
			ID 		170 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CTLF];
			ID 		180 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_CFAX];
			ID 		190 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[_EMAIL];
         ID       200 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _WEB ];
         ID       194 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE CHECKBOX aGet[ _LRECC ] VAR aTmp[ _LRECC ] ;
         ID       195 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ON CHANGE( if( aTmp[ _LRECC ], ( aGet[ _NINIRECC ]:varPut( Year( Date() ) + 1 ), aGet[ _NFINRECC ]:varPut( 0 ) ), ) ) ;
         OF       oFld:aDialogs[ 1 ]

   REDEFINE GET aGet[ _NINIRECC ] VAR aTmp[ _NINIRECC ] ;
         PICTURE  "9999" ;
         ID       196 ;
         WHEN     ( aTmp[ _LRECC ] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

   REDEFINE GET aGet[ _NFINRECC ] VAR aTmp[ _NFINRECC ] ;
         PICTURE  "9999" ;
         ID       197 ;
         WHEN     ( aTmp[ _LRECC ] .and. nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[ 1 ]

   /*
   Codigo de Divisas______________________________________________________________
   */

   REDEFINE GET aGet[ _CCODGRP ] VAR aTmp[ _CCODGRP ] ;
         ID       400 ;
         PICTURE  "@!" ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( if( cEmpresa( aGet[ _CCODGRP ], dbfEmp, oSayGrp ) .and. aTmp[ _CCODGRP ] != aTmp[ _CODEMP ], .t., ( MsgStop( "Empresa martiz no valida" ), .f. ) ) );
         BITMAP   "LUPA";
         ON HELP  ( BrwEmpresa( aGet[ _CCODGRP ], dbfEmp, oSayGrp ) ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET oSayGrp VAR cSayGrp ;
         ID       410 ;
         WHEN     ( .F. ) ;
         OF       oFld:aDialogs[1]

   REDEFINE CHECKBOX aGet[ _LGRPCLI ] VAR aTmp[ _LGRPCLI ] ;
         ID       420 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE CHECKBOX aGet[ _LGRPPRV ] VAR aTmp[ _LGRPPRV ] ;
         ID       430 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE CHECKBOX aGet[ _LGRPART ] VAR aTmp[ _LGRPART ] ;
         ID       440 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE CHECKBOX aGet[ _LGRPALM ] VAR aTmp[ _LGRPALM ] ;
         ID       450 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aGet[ _CDIVEMP ] VAR aTmp[ _CDIVEMP ];
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDiv( aGet[ _CDIVEMP ], oBmpEmp, , , , dbfDiv, oBandera ) ) ;
         PICTURE  "@!";
         ID       360 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVEMP ], oBmpEmp, nil, dbfDiv, oBandera ) ;
         OF       oFld:aDialogs[1]

   REDEFINE BITMAP oBmpEmp ;
         RESOURCE "BAN_EURO" ;
         ID       361;
         OF       oFld:aDialogs[1]

   REDEFINE GET aGet[ _CDIVCHG ] VAR aTmp[ _CDIVCHG ];
         WHEN     ( nMode != ZOOM_MODE ) ;
         VALID    ( cDiv( aGet[ _CDIVCHG ], oBmpChg, , , , dbfDiv, oBandera ) ) ;
         PICTURE  "@!";
         ID       370 ;
         BITMAP   "LUPA" ;
         ON HELP  BrwDiv( aGet[ _CDIVCHG ], oBmpChg, nil, dbfDiv, oBandera ) ;
         OF       oFld:aDialogs[1]

   REDEFINE BITMAP oBmpChg ;
         RESOURCE "BAN_EURO" ;
         ID       371;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _NCODCLI ];
         ID       201 ;
			PICTURE 	"99" ;
         SPINNER ;
         MIN      4 MAX 12 ;
         VALID    ( aTmp[ _NCODCLI ] >= 4 .AND. aTmp[ _NCODCLI ] <= 12 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _NCODPRV ];
			ID 		205 ;
			PICTURE 	"99" ;
			SPINNER ;
         MIN      4 MAX 12 ;
         VALID    ( aTmp[ _NCODPRV ] >= 4 .AND. aTmp[ _NCODPRV ] <= 12 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;  
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _DINIOPE ];
         ID       210 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   REDEFINE GET aTmp[ _DFINOPE ];
         ID       220 ;
         SPINNER ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oFld:aDialogs[1]

   if ( lAppendMode )

      REDEFINE BITMAP oBmpImportacion ;
         ID       500 ;
         RESOURCE "gc_office_building_48" ;
         TRANSPARENT ;
         OF       fldValores

      REDEFINE GET oCodEmp VAR cOldCodigoEmpresa ;
         ID       100 ;
         PICTURE  "@!" ;
			WHEN  	( lAppendMode ) ;
         VALID    ( if( cEmpresa( oCodEmp, dbfEmp, oNomEmp ), AppFromEmpresa( cOldCodigoEmpresa, dbfEmp, aGet, aTmp, tmpDlg, dbfDlg ), .f. ) ) ;
         BITMAP   "LUPA";
         ON HELP  ( BrwEmpresa( oCodEmp, dbfEmp, oNomEmp ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oNomEmp VAR cNomEmp ;
         ID       110 ;
         WHEN     ( .F. ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lArticulos ;
         ID       230 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE RADIO aImportacion:nCosto ;
         ID       231, 232 ;
         WHEN     ( ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) .and. aImportacion:lArticulos ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lClientes ;
         ID       240 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lProveedor ;
         ID       250 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lOferta ;
         ID       251 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lPromocion ;
         ID       252 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lAlmacen ;
         ID       260 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lAgente ;
         ID       270 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lRuta ;
         ID       280 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lDocument ;
         ID       285 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lStockIni ;
         ID       290 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lFPago ;
         ID       300 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lPedPrv ;
         ID       310 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lAlbPrv ;
         ID       320 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lPreCli ;
         ID       330 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lPedCli ;
         ID       340 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lAlbCli ;
         ID       350 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lVale ;
         ID       360 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lAnticipo ;
         ID       370 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lProduccion ;
         ID       380 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lBancos ;
         ID       390 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lScript ;
         ID       400 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE CHECKBOX aImportacion:lEntidades ;
         ID       410 ;
         WHEN     ( !Empty( cOldCodigoEmpresa ) .AND. ( lAppendMode ) ) ;
         OF       oFld:aDialogs[2]

      REDEFINE GET oGetSemilla VAR nSemillaContadores ;
         ID       130 ;
         VALID    ( nSemillaContadores > 0 ) ;
         PICTURE  "999999999" ;
			WHEN  	( lAppendMode ) ;
         OF       oFld:aDialogs[2]

   end if

      /*
      Botones --------------------------------------------------------------------
      */

      REDEFINE BITMAP oBmpDelegaciones ;
         ID       600 ;
         RESOURCE "Flag_Eu_48_Alpha" ;
         TRANSPARENT ;
         OF       oFld:aDialogs[ if( lAppendMode, 3, 2 ) ] ;

      REDEFINE BUTTON;
			ID 		500 ;
         OF       oFld:aDialogs[ if( lAppendMode, 3, 2 ) ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinAppRec( oBrwDet, bEdtDlg, tmpDlg, , , aTmp[ _CODEMP] ), oBrwDet:DrawSelect() )

      REDEFINE BUTTON;
			ID 		501 ;
         OF       oFld:aDialogs[ if( lAppendMode, 3, 2 ) ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( WinEdtRec( oBrwDet, bEdtDlg, tmpDlg ) )

      REDEFINE BUTTON;
			ID 		502 ;
         OF       oFld:aDialogs[ if( lAppendMode, 3, 2 ) ] ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( DbDelRec( oBrwDet, tmpDlg ) )

      /*
      Browse delegaciones --------------------------------------------------------
      */

      oBrwDet                 := IXBrowse():New( if( lAppendMode, fldArticulos, fldValores ) )

      oBrwDet:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwDet:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwDet:cAlias          := tmpDlg
      oBrwDet:nMarqueeStyle   := 6
      oBrwDet:cName           := "Delegacion.Empresa"

      with object ( oBrwDet:AddCol() )
         :cHeader             := "Código"
         :cSortOrder          := "cCodDlg"
         :bEditValue          := {|| ( tmpDlg )->cCodDlg }
         :nWidth              := 80
      end with

      with object ( oBrwDet:AddCol() )
         :cHeader             := "Nombre"
         :cSortOrder          := "cNomDlg"
         :bEditValue          := {|| ( tmpDlg )->cNomDlg }
         :nWidth              := 260
      end with

      oBrwDet:bRClicked       := {| nRow, nCol, nFlags | oBrwDet:RButtonDown( nRow, nCol, nFlags ) }

      if ( nMode != ZOOM_MODE )
         oBrwDet:bLDblClick   := {|| WinEdtRec( oBrwDet, bEdtDlg, tmpDlg ) }
      end if

      oBrwDet:CreateFromResource( 100 )

   /*
   Botones --------------------------------------------------------------------
   */

      REDEFINE BUTTON oBtnPrv ;
         ID       3 ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( PrvTrans( oFld, oBtnOk ) )

      REDEFINE BUTTON oBtnOk ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( EndTrans( aTmp, aGet, oBrw, oFld, oDlg, oBtnOk, oBrwDet, dbfEmp, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oFld:aDialogs[2]:AddFastKey( VK_F2, {|| WinAppRec( oBrwDet, bEdtDlg, tmpDlg, , , aTmp[_CODEMP] ), oBrwDet:DrawSelect() } )
         oFld:aDialogs[2]:AddFastKey( VK_F3, {|| WinEdtRec( oBrwDet, bEdtDlg, tmpDlg ) } )
         oFld:aDialogs[2]:AddFastKey( VK_F4, {|| DBDelRec( oBrwDet, tmpDlg ) } )
         oDlg:AddFastKey( VK_F5, {|| oBtnOk:Click() } )
      end if

      oDlg:bStart    := {|| oBrwDet:Load(), aGet[ _CODEMP ]:SetFocus(), aGet[ _CDIVEMP ]:lValid(), aGet[ _CDIVCHG ]:lValid() }

   ACTIVATE DIALOG oDlg ;
         ON INIT     ( if( !lAppendMode, oBtnPrv:Hide(), SetWindowText( oBtnOk:hWnd, "&Siguiente >" ) ) ) ;
         CENTER

   oBmpChg:End()
   oBmpEmp:End()

   if !Empty( oBmpGeneral )
      oBmpGeneral:End()
   end if

   if !Empty( oBmpImportacion )
      oBmpImportacion:End()
   end if

   if !Empty( oBmpDelegaciones )
      oBmpDelegaciones:End()
   end if

   DeleteObject( bmpEmp )

   /*
   Matamos las tablas temporales-----------------------------------------------
   */

   KillTrans()

   // Para los servicios ------------------------------------------------------

   // InitServices()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

STATIC FUNCTION EditConfig( aTmp, aGet, dbfEmp, oBrw, nSelFolder, bValid, nMode )

   local n
   local oFnt
	local oDlg
   local oFld
   local oSay                    := Array( 47 )
   local cSay                    := AFill( Array( 47 ), "" )
   local oError
   local oBlock

   local oBrwEmp
   local oBrwCon

   local oBmpComportamiento
   local oBmpDefecto
   local oBmpArticulos
   local oBmpContadores
   local oBmpContabilidad
   local oBmpEnvios
   local oBmpComunicacion
   local oBmpTPV

   local aBnfSobre               := { "Costo", "Venta" }
   local aCifRut                 := { "Cálculo de C.I.F.", "Cálculo de R.U.T." }
   local aPrinters               := GetPrinters()
   local oSayFmt
   local cSayFmt                 := ""
   local oGroupNFC
   local oSerie
   local cSerie                  := "A"

   local oPrestashopFile
   local cPrestashopFile         := ""

   /*
   Obtenemos el nivel de acceso------------------------------------------------
   */

   if nAnd( nLevelUsr( _MENUITEM_ ), ACC_EDIT ) == 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   if lGrupoEmpresa( ( ( dbfEmp )->CodEmp ), dbfEmp )
      msgStop( "No se puede configurar un grupo de empresas." )
      return .f.
   end if

   if BeginEditConfig( aTmp, nMode )
      return .f.
   end if

   cCmbDocumentos                := aDocumentos[ 1 ]
   cCmbSerie                     := "A"
   nGetContador                  := 1
   cGetFormato                   := Space( 3 )
   cGetPlantillaDefecto          := Space( 250 )
   nGetCopias                    := 1
   cGetSerie                     := Space( 1 )  

   cNombreSerie                  := aTmp[ _CNOMSERA ]


   // Detenemos los servicios -------------------------------------------------

   StopServices()

   // Seleccionamos la empresa ------------------------------------------------

   setEmpresa( ( dbfEmp )->CodEmp, dbfEmp, dbfDlg, dbfUser, oBrw )

   checkEmpresaTablesExistences()

   // Control de errores-------------------------------------------------------

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( aTmp[ _CDEFSER ] )
      aTmp[ _CDEFSER ]     := Space( 1 )
   end if

   if Empty( aTmp[ _CENVUSR ] )
      aTmp[ _CENVUSR ]     := "Cliente"
   end if

   if Empty( aTmp[ _CRUTCON ] )
      aTmp[ _CRUTCON ]     := "A:"
   end if

   if Empty( aTmp[ _CNBRCAJ ] )
      aTmp[ _CNBRCAJ ]     := Padr( "Cajas", 100 )
   end if

   if Empty( aTmp[ _CNBRUND ] )
      aTmp[ _CNBRUND ]     := Padr( "Unidades", 100 )
   end if

   if Empty( aTmp[ _CNBRBULTOS ] )
      aTmp[ _CNBRBULTOS ]  := Padr( "Bultos", 100 )
   end if

   if Empty( aTmp[ _CINIJOR ] )
      aTmp[ _CINIJOR ]     := "0800"
   end if

   if Empty( aTmp[ _CNOMIMP ] )
      aTmp[ _CNOMIMP ]     := "IVA" 
   end if

   cOldNomSer              := "A" 

   n                       := aScan( aPrinters, {| cPrinter | Rtrim( cPrinter ) == Rtrim( aTmp[ _CPRNPDF ] ) } )
   if n != 0
      aTmp[ _CPRNPDF ]     := aPrinters[ n ]
   else
      aTmp[ _CPRNPDF ]     := Space( 200 )
   end if

   if Empty( nSelFolder )
      nSelFolder           := 1
   end if

   cSay[ 36 ]              := aBnfSobre[ Max( aTmp[ _NDEFSBR1 ], 1 ) ]
   cSay[ 37 ]              := aBnfSobre[ Max( aTmp[ _NDEFSBR2 ], 1 ) ]
   cSay[ 38 ]              := aBnfSobre[ Max( aTmp[ _NDEFSBR3 ], 1 ) ]
   cSay[ 39 ]              := aBnfSobre[ Max( aTmp[ _NDEFSBR4 ], 1 ) ]
   cSay[ 40 ]              := aBnfSobre[ Max( aTmp[ _NDEFSBR5 ], 1 ) ]
   cSay[ 41 ]              := aBnfSobre[ Max( aTmp[ _NDEFSBR6 ], 1 ) ]
   cSay[ 42 ]              := aCifRut[ Max( aTmp[ _NCIFRUT ], 1 ) ]

   cSay[ 47 ]              := RetFld( aTmp[ _CSUFDOC ], dbfDlg, "cNomDlg" )
 
   cTiempoPed              := cTiempoToCadena( aTmp[ _NTIEMPOPED ] ) 

   cCmbContabilidad        := aCmbContabilidad[ Min( Max( aTmp[ _NEXPCONTBL ], 1 ), len( aCmbContabilidad ) ) ] 

   cMailNotificaciones     := padr( ConfiguracionEmpresasModel():getValue( 'mail_notificaciones', '' ), 200 )
   
   lInformacionInmediata   := ConfiguracionEmpresasModel():getLogic( 'informacion_inmediata', .f. )

   LoaItmEmp( aTmp )

   DEFINE DIALOG  oDlg ;
      RESOURCE    "EmpresaCfg" ;
      TITLE       "Configuración de empresa : " + aTmp[ _CODEMP ] + "-" + aTmp[ _CNOMBRE ] ;
      OF          oWnd()

      REDEFINE PAGES oFld ;
         ID       400;
         OF       oDlg ;
         DIALOGS  "EMPRESA_2",;
                  "EMPRESA_3",;
                  "EMPRESA_8",;
                  "EMPRESA_TPV",;
                  "EMPRESA_10",;
                  "EMPRESA_CONTABILIDAD",;
                  "EMPRESA_6",;
                  "EMPRESA_COMUNICACIONES"

      // Page 1 Comportamientos---------------------------------------------------
 
      REDEFINE BITMAP oBmpComportamiento ;
         ID       500 ;
         RESOURCE "gc_wrench_48" ;
         TRANSPARENT ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LCODART ] ;
         VAR      aTmp[ _LCODART ] ;
         ID       140 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LENTCON ] ;
         VAR      aTmp[ _LENTCON ] ;
         ID       150 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LMODDES ] ;
         VAR      aTmp[ _LMODDES ] ;
         ID       160 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LMODIVA ] ;
         VAR      aTmp[ _LMODIVA ] ;
         ID       170 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LFLTYEA ] ;
         VAR      aTmp[ _LFLTYEA ] ;
         ID       206 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LGETUSR ] ;
         VAR      aTmp[ _LGETUSR ] ;
         ID       187 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LGETLOT ] ;
         VAR      aTmp[ _LGETLOT ] ;
         ID       185 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aTmp[ _LUSETBL ] ;
         ID       138;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNOMIMP ] ;
         VAR      aTmp[ _CNOMIMP ] ;
         ID       139 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LACTCOS ] ;
         VAR      aTmp[ _LACTCOS ] ;
         ID       190 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LGETCOB ] ;
         VAR      aTmp[ _LGETCOB ] ;
         ID       181 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LGETAGE ] ;
         VAR      aTmp[ _LGETAGE ] ;
         ID       182 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LUSEPNT ] ;
         VAR      aTmp[ _LUSEPNT ] ;
         ID       191 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LUSEPOR ] ;
         VAR      aTmp[ _LUSEPOR ] ;
         ID       189 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LDTOLIN ] ;
         VAR      aTmp[ _LDTOLIN ] ;
         ID       300 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LPRELIN ] ;
         VAR      aTmp[ _LPRELIN ] ;
         ID       110 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LGRPENT ] ;
         VAR      aTmp[ _LGRPENT ] ;
         ID       204 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LBUSIMP ] ;
         VAR      aTmp[ _LBUSIMP ] ;
         ID       195 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LPREMIN ] ;
         VAR      aTmp[ _LPREMIN ] ;
         ID       196 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LSTKALM ] ;
         VAR      aTmp[ _LSTKALM ] ;
         ID       197 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LTIPMOV ] ;
         VAR      aTmp[ _LTIPMOV ] ;
         ID       180 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LPASNIL ] ;
         VAR      aTmp[ _LPASNIL ] ;
         ID       184 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LSALPDT ] ;
         VAR      aTmp[ _LSALPDT ] ;
         ID       192 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LUSEIMP ] ;
         VAR      aTmp[ _LUSEIMP ] ;
         ID       183 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LMODIMP ] ;
         VAR      aTmp[ _LMODIMP ] ;
         ID       188 ;
         WHEN     aTmp[ _LUSEIMP ] ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LIVAIMPESP ] ;
         VAR      aTmp[ _LIVAIMPESP ] ;
         ID       153 ;
         WHEN     aTmp[ _LUSEIMP ] ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LSHWCOS ] ;
         VAR      aTmp[ _LSHWCOS ] ;
         ID       205 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LMOVCOS ] ;
         VAR      aTmp[ _LMOVCOS ] ;
         ID       203 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LCOSACT ] ;
         VAR      aTmp[ _LCOSACT ] ;
         ID       761 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LCOSPRV ] ;
         VAR      aTmp[ _LCOSPRV ] ;
         ID       198 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LSHOWORG ] ;
         VAR      aTmp[ _LSHOWORG ] ;
         ID       306 ;
         OF       fldGeneral         

      REDEFINE CHECKBOX aGet[ _LNUMPED ] ;
         VAR      aTmp[ _LNUMPED ] ;
         ID       260 ;   
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LRECCOSTES ] ;
         VAR      aTmp[ _LRECCOSTES ] ;
         ID       360 ;   
         OF       fldGeneral   

      REDEFINE GET aGet[ _CNUMPED ] ;
         VAR      aTmp[ _CNUMPED ] ;
         ID       270 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LNUMOBR ] ;
         VAR      aTmp[ _LNUMOBR ] ;
         ID       200 ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNUMOBR ] ;
         VAR      aTmp[ _CNUMOBR ] ;
         ID       210 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LNUMALB ] ;
         VAR      aTmp[ _LNUMALB ] ;
         ID       220 ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CNUMALB ] ;
         VAR      aTmp[ _CNUMALB ] ;
         ID       230 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LSUALB ] ;
         VAR      aTmp[ _LSUALB ] ;
         ID       240 ;
         OF       fldGeneral

      REDEFINE GET aGet[ _CSUALB ] ;
         VAR      aTmp[ _CSUALB ] ;
         ID       250 ;
         OF       fldGeneral

      REDEFINE CHECKBOX aGet[ _LSERVICIO ] ;
         VAR      aTmp[ _LSERVICIO ] ;
         ID       199 ;
         OF       fldGeneral

      // Controles de TPV---------------------------------------------------------

      REDEFINE BITMAP oBmpTPV ;
         ID       500 ;
         RESOURCE "gc_cash_register_48" ;
         TRANSPARENT ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LIMPEXA ] VAR aTmp[ _LIMPEXA ] ;
         ID       186 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LGETUBI ] VAR aTmp[ _LGETUBI ] ;
         ID       196 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LSHOWSALA ] ;
         VAR      aTmp[ _LSHOWSALA ] ;
         ID       158 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LORDNOMTPV ] ;
         VAR      aTmp[ _LORDNOMTPV ] ;
         ID       159 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LNUMTIK ] VAR aTmp[ _LNUMTIK ] ;
         ID       197 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LFIDELITY ] VAR aTmp[ _LFIDELITY ] ;
         ID       193 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LLLEVAR ] VAR aTmp[ _LLLEVAR ] ;
         ID       126 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LRECOGER ] VAR aTmp[ _LRECOGER ] ;
         ID       125 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LENCARGAR ] VAR aTmp[ _LENCARGAR ] ;
         ID       127 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LADDCUT ] VAR aTmp[ _LADDCUT ] ;
         ID       128 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LALBTCT ] VAR aTmp[ _LALBTCT ] ;
         ID       129 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LFACTCT ] VAR aTmp[ _LFACTCT ] ;
         ID       130 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LSHOWLIN ] VAR aTmp[ _LSHOWLIN ] ;
         ID       131 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LIMGART ] VAR aTmp[ _LIMGART ] ;
         ID       990 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ _LTOTTIKCOB ] VAR aTmp[ _LTOTTIKCOB ] ;
         ID       200 ;
         OF       fldTPV

      REDEFINE COMBOBOX aGet[ _NTIPIMPTPV ] VAR aTmp[ _NTIPIMPTPV ] ;
         ITEMS    aTipImpTpv ;
         ID       210;
         OF       fldTPV  

      REDEFINE GET cMailNotificaciones ;
         ID       230 ;
         OF       fldTPV

      REDEFINE CHECKBOX aGet[ ( dbfEmp )->( fieldpos( "lOpenTik" ) ) ] ;
         VAR      aTmp[ ( dbfEmp )->( fieldpos( "lOpenTik" ) ) ] ;
         ID       220;
         OF       fldTPV  

      // Page 2 Defecto-----------------------------------------------------------

      REDEFINE BITMAP oBmpDefecto ;
         ID       500 ;
         RESOURCE "gc_clipboard_pencil_48" ;
         TRANSPARENT ;
         OF       fldValores

      REDEFINE GET aGet[ _CSUFDOC ] VAR aTmp[ _CSUFDOC ];
         ID       105 ;
         VALID    ( cDelegacion( aGet[ _CSUFDOC ], dbfDlg, oSay[47], aTmp[ _CODEMP ] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwDelegacion( aGet[ _CSUFDOC ], dbfDlg, oSay[47], aTmp[ _CODEMP ] ) ) ;
         OF       fldValores

      REDEFINE GET oSay[47] VAR cSay[47] ;
         ID       106;
         WHEN     .f. ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFCLI ] VAR aTmp[ _CDEFCLI ] ;
         ID       100;
         VALID    ( cClient( aGet[ _CDEFCLI ], , oSay[32] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwClient( aGet[ _CDEFCLI ], oSay[32] ) ) ;
         OF       fldValores

      REDEFINE GET oSay[32] VAR cSay[32] ;
         ID       101;
         WHEN     .f. ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFSER ] VAR aTmp[ _CDEFSER ];
         ID       110;
         PICTURE  "@!" ;
         UPDATE ;
         SPINNER ;
         ON UP    ( UpSerie( aGet[ _CDEFSER ] ) );
         ON DOWN  ( DwSerie( aGet[ _CDEFSER ] ) );
         VALID    ( aTmp[ _CDEFSER ] == Space( 1 ) .or. ( aTmp[ _CDEFSER ] >= "A" .and. aTmp[ _CDEFSER ] <= "Z" ) );
         OF       fldValores

      REDEFINE GET aGet[ _CDEFCAJ ] VAR aTmp[ _CDEFCAJ ] ;
         ID       140;
         PICTURE  "@!" ;
         VALID    ( cCajas( aGet[ _CDEFCAJ ], , oSay[33] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwCajas( aGet[ _CDEFCAJ ], oSay[33] ) ) ;
         OF       fldValores

      REDEFINE GET oSay[ 33 ] VAR cSay[ 33 ] ;
         WHEN     .f. ;
         ID       141 ;
         OF       fldValores

      REDEFINE CHECKBOX aGet[ _LSELCAJ ] VAR aTmp[ _LSELCAJ ] ;
         ID       142 ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFALM ] VAR aTmp[ _CDEFALM ] ;
         ID       120;
         PICTURE  "@!" ;
         VALID    ( cAlmacen( aGet[ _CDEFALM ], , oSay[1] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwAlmacen( aGet[ _CDEFALM ], oSay[1] ) );
         OF       fldValores

      REDEFINE GET oSay[1] VAR cSay[1] ;
         WHEN     .F. ;
         ID       121 ;
         OF       fldValores

      REDEFINE CHECKBOX aGet[ _LSELALM ] VAR aTmp[ _LSELALM ] ;
         ID       122 ;
         OF       fldValores

      REDEFINE CHECKBOX aGet[ _LSTOCKALM ] VAR aTmp[ _LSTOCKALM ] ;
         ID       123 ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFFPG ] VAR aTmp[ _CDEFFPG ] ;
         ID       130;
         PICTURE  "@!" ;
         VALID    ( cFPago( aGet[ _CDEFFPG ], , oSay[2] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwFPago( aGet[ _CDEFFPG ], oSay[2] ) );
         OF       fldValores

      REDEFINE GET oSay[2] VAR cSay[2] ;
         WHEN     .F. ;
         ID       131 ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFIVA ] VAR aTmp[ _CDEFIVA ] ;
         ID       135;
         PICTURE  "@!" ;
         VALID    ( cTiva( aGet[ _CDEFIVA ], , oSay[35] ) );
         BITMAP   "LUPA" ;
         ON HELP  ( BrwIva( aGet[ _CDEFIVA ], , oSay[35] ) ) ;
         OF       fldValores

      REDEFINE GET oSay[35] VAR cSay[35] ;
         WHEN     .F. ;
         ID       136 ;
         OF       fldValores

      REDEFINE CHECKBOX aGet[ _LIVAINC ] VAR aTmp[ _LIVAINC ] ;
         ID       137 ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFCJR ] VAR aTmp[ _CDEFCJR ] ;
         ID       150;
         PICTURE  "@!" ;
         VALID    ( cUser( aGet[ _CDEFCJR ], , oSay[34] ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwUser( aGet[ _CDEFCJR ], , oSay[34] ) ) ;
         OF       fldValores

      REDEFINE GET oSay[34] VAR cSay[34] ;
         WHEN     .f. ;
         ID       151 ;
         OF       fldValores

      REDEFINE GET aGet[ _CDEFTEM ] VAR aTmp[ _CDEFTEM ] ;
         ID       200;
         VALID    ( cTemporada( aGet[ _CDEFTEM ], , oSay[ 46 ] ) ) ;
         PICTURE  "@!" ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwTemporada( aGet[ _CDEFTEM ], oSay[ 46 ] ) ) ;
         OF       fldValores

      REDEFINE GET oSay[ 46 ] VAR cSay[ 46 ] ;
         ID       201;
         WHEN     .f. ;
         OF       fldValores

      REDEFINE GET aGet[ _CDIRIMG ] VAR aTmp[ _CDIRIMG ] ;
         ID       155;
         PICTURE  "@!" ;
         BITMAP   "FOLDER" ;
         ON HELP  ( aGet[ _CDIRIMG ]:cText( Padr( cGetDir32( "Seleccione directorio", Rtrim( aTmp[ _CDIRIMG ] ), .t. ), 100 ) ) );
         OF       fldValores

      REDEFINE GET aGet[ _CINIJOR ] VAR aTmp[ _CINIJOR ] ;
         PICTURE  "@R 99:99" ;
         SPINNER ;
         ON UP    ( UpTime( aGet[ _CINIJOR ] ) );
         ON DOWN  ( DwTime( aGet[ _CINIJOR ] ) );
         VALID    ( validHourMinutes( aGet[ _CINIJOR ], .t. ) );
         ID       280 ;
         OF       fldValores

      REDEFINE GET oSerie VAR cSerie ;
         ID       290 ;
         PICTURE  "@!" ;
         SPINNER ;
         ON UP    ( ChangeSerie( aGet, aTmp, oSerie, cSerie, .f. ) );
         ON DOWN  ( ChangeSerie( aGet, aTmp, oSerie, cSerie, .t. ) );
         VALID    ( cSerie >= "A" .AND. cSerie <= "Z" ) ;
         OF       fldValores

      REDEFINE GET oNombreSerie VAR cNombreSerie ;
         ID       291;
         VALID    ( GuardaNombreSerie( aTmp, cSerie ) );
         OF       fldValores

      REDEFINE CHECKBOX aGet[ _LRECNUMFAC ] VAR aTmp[ _LRECNUMFAC ] ; 
         ID       300 ;
         OF       fldValores   

      REDEFINE GET aGet[ _NAUTSER ] VAR aTmp[ _NAUTSER ] ;
         PICTURE  "999999999" ;
         SPINNER ;
         VALID    ( aTmp[ _NAUTSER ] > 0 );
         ID       295 ;
         OF       fldValores

      REDEFINE GET aGet[ _NDIAVAL ] VAR aTmp[ _NDIAVAL ];
         ID       156;
         PICTURE  "999" ;
         SPINNER ;
         OF       fldValores

      REDEFINE GET aGet[ _NDIAVALE ] VAR aTmp[ _NDIAVALE ];
         ID       220;
         PICTURE  "999" ;
         SPINNER ;
         OF       fldValores

      REDEFINE COMBOBOX oSay[ 42 ] VAR cSay[ 42 ] ;
         ITEMS    aCifRut ;
         ID       160;
         OF       fldValores

      REDEFINE CHECKBOX aGet[ _LBRFAMTRE ] VAR aTmp[ _LBRFAMTRE ];
         ID       650;
         OF       fldValores

      // Page 3 Articulos---------------------------------------------------------

      REDEFINE BITMAP oBmpArticulos ;
         ID       500 ;
         RESOURCE "gc_object_cube_48" ;
         TRANSPARENT ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWTAR1 ] VAR aTmp[ _LSHWTAR1 ] ;
         ID       100 ;
         WHEN     .f. ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CTXTTAR1 ] VAR aTmp[ _CTXTTAR1 ] ;
         ID       110;
         SPINNER ;
         OF       fldArticulos

      REDEFINE GET aGet[ _NDEFBNF1 ] VAR aTmp[ _NDEFBNF1 ] ;
         ID       120;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       fldArticulos

      REDEFINE COMBOBOX oSay[ 36 ] VAR cSay[ 36 ] ;
         ITEMS    aBnfSobre ;
         ID       130;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWTAR2 ] VAR aTmp[ _LSHWTAR2 ] ;
         ID       200 ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CTXTTAR2 ] VAR aTmp[ _CTXTTAR2 ] ;
         ID       210;
         WHEN     ( aTmp[ _LSHWTAR2 ] ) ;
         SPINNER ;
         OF       fldArticulos

      REDEFINE GET aGet[ _NDEFBNF2 ] VAR aTmp[ _NDEFBNF2 ] ;
         ID       220;
         WHEN     ( aTmp[ _LSHWTAR2 ] ) ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       fldArticulos

      REDEFINE COMBOBOX oSay[ 37 ] VAR cSay[ 37 ] ;
         ITEMS    aBnfSobre ;
         WHEN     ( aTmp[ _LSHWTAR2 ] ) ;
         ID       230;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWTAR3 ] VAR aTmp[ _LSHWTAR3 ] ;
         ID       300 ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CTXTTAR3 ] VAR aTmp[ _CTXTTAR3 ] ;
         ID       310;
         WHEN     ( aTmp[ _LSHWTAR3 ] ) ;
         SPINNER ;
         OF       fldArticulos

      REDEFINE GET aGet[ _NDEFBNF3 ] VAR aTmp[ _NDEFBNF3 ] ;
         ID       320;
         WHEN     ( aTmp[ _LSHWTAR3 ] ) ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       fldArticulos

      REDEFINE COMBOBOX oSay[ 38 ] VAR cSay[ 38 ] ;
         ITEMS    aBnfSobre ;
         WHEN     ( aTmp[ _LSHWTAR3 ] ) ;
         ID       330;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWTAR4 ] VAR aTmp[ _LSHWTAR4 ] ;
         ID       400 ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CTXTTAR4 ] VAR aTmp[ _CTXTTAR4 ] ;
         ID       410;
         WHEN     ( aTmp[ _LSHWTAR4 ] ) ;
         SPINNER ;
         OF       fldArticulos

      REDEFINE GET aGet[ _NDEFBNF4 ] VAR aTmp[ _NDEFBNF4 ] ;
         ID       420;
         WHEN     ( aTmp[ _LSHWTAR4 ] ) ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       fldArticulos

      REDEFINE COMBOBOX oSay[ 39 ] VAR cSay[ 39 ] ;
         ITEMS    aBnfSobre ;
         WHEN     ( aTmp[ _LSHWTAR4 ] ) ;
         ID       430;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWTAR5 ] VAR aTmp[ _LSHWTAR5 ] ;
         ID       501 ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CTXTTAR5 ] VAR aTmp[ _CTXTTAR5 ] ;
         ID       510;
         WHEN     ( aTmp[ _LSHWTAR5 ] ) ;
         SPINNER ;
         OF       fldArticulos

      REDEFINE GET aGet[ _NDEFBNF5 ] VAR aTmp[ _NDEFBNF5 ] ;
         ID       520;
         WHEN     ( aTmp[ _LSHWTAR5 ] ) ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       fldArticulos

      REDEFINE COMBOBOX oSay[ 40 ] VAR cSay[ 40 ] ;
         ITEMS    aBnfSobre ;
         WHEN     ( aTmp[ _LSHWTAR5 ] ) ;
         ID       530;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWTAR6 ] VAR aTmp[ _LSHWTAR6 ] ;
         ID          600 ;
         OF          fldArticulos

      REDEFINE GET aGet[ _CTXTTAR6 ] VAR aTmp[ _CTXTTAR6 ] ;
         ID       610;
         WHEN     ( aTmp[ _LSHWTAR6 ] ) ;
         SPINNER ;
         OF       fldArticulos

      REDEFINE GET aGet[ _NDEFBNF6 ] VAR aTmp[ _NDEFBNF6 ] ;
         ID       620;
         WHEN     ( aTmp[ _LSHWTAR6 ] ) ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
         OF       fldArticulos

      REDEFINE COMBOBOX oSay[ 41 ] VAR cSay[ 41 ] ;
         ITEMS    aBnfSobre ;
         WHEN     ( aTmp[ _LSHWTAR6 ] ) ;
         ID       630;
         OF       fldArticulos

      // Precio Venta------------------------------

      oGetPrecioVenta   := comboTarifa():Build( { "idCombo" => 800, "uValue" => aTmp[ _NPREVTA ] } )
      oGetPrecioVenta:Resource( fldArticulos )

      // Precio venta web--------------------------

      oGetPrecioWebVenta   := comboTarifa():Build( { "idCombo" => 810, "uValue" => aTmp[ _NPREWEBVTA ] } ) 
      oGetPrecioWebVenta:Resource( fldArticulos )

      // Precio Producto----------------------------

      oGetPrecioProducto   := comboTarifa():Build( { "idCombo" => 740, "uValue" => aTmp[ _NPRETPRO ] } )
      oGetPrecioProducto:Resource( fldArticulos )

      // Precio de Combinado-------------------------

      oGetPrecioCombinado    := comboTarifa():Build( { "idCombo" => 750, "uValue" => aTmp[ _NPRETCMB ] } )
      oGetPrecioCombinado:Resource( fldArticulos )

      REDEFINE CHECKBOX aGet[ _LUSEBULTOS ] VAR aTmp[ _LUSEBULTOS ] ;
         ID       450 ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CNBRBULTOS ] VAR aTmp[ _CNBRBULTOS ] ;
         ID       460 ;
         WHEN     aTmp[ _LUSEBULTOS ] ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LUSECAJ ] VAR aTmp[ _LUSECAJ ] ;
         ID       250 ;
         ON CHANGE ( lChgCajCaj( aGet, aTmp ) );
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LCALCAJ ] VAR aTmp[ _LCALCAJ ] ;
         ID       260 ;
         WHEN     aTmp[ _LUSECAJ ] ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CNBRCAJ ] VAR aTmp[ _CNBRCAJ ] ;
         ID       270 ;
         WHEN     aTmp[ _LUSECAJ ] ;
         OF       fldArticulos

      REDEFINE GET aGet[ _CNBRUND ] VAR aTmp[ _CNBRUND ] ;
         ID       280 ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSHWPOP ] VAR aTmp[ _LSHWPOP ] ;
         ID       770 ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSTKCERO ] VAR aTmp[ _LSTKCERO ] ;
         ID       193 ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LSERNOCOM ] VAR aTmp[ _LSERNOCOM ] ;
         ID       196 ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LNSTKACT ] ;
         VAR      aTmp[ _LNSTKACT ] ;
         ID       194 ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LCALLOT ] VAR aTmp[ _LCALLOT ] ;
         ID       197 ;
         OF       fldArticulos

      REDEFINE CHECKBOX aGet[ _LCALSER ] VAR aTmp[ _LCALSER ] ;
         ID       198 ;
         OF       fldArticulos

      REDEFINE GET aTmp[ _NDGTUND ] ;
         ID       700 ;
         PICTURE  "99" ;
         SPINNER  MIN 8 MAX 12 ;
         VALID    ( aTmp[ _NDGTUND ] >= 8 .AND. aTmp[ _NDGTUND ] <= 12 ) ;
         OF       fldArticulos

      REDEFINE GET aTmp[ _NDECUND ] ;
         ID       710;
         PICTURE  "99" ;
         SPINNER  MIN 0 MAX 6 ;
         VALID    ( aTmp[ _NDECUND ] >= 0 .AND. aTmp[ _NDECUND ]  <= 6 ) ;
         OF       fldArticulos

      REDEFINE GET aTmp[ _NDGTESC ] ;
         ID       720 ;
         PICTURE  "99" ;
         SPINNER  MIN 8 MAX 12 ;
         VALID    ( aTmp[ _NDGTESC ] >= 8 .AND. aTmp[ _NDGTESC ] <= 12 ) ;
         OF       fldArticulos

      REDEFINE GET aTmp[ _NDECESC ] ;
         ID       730;
         PICTURE  "99" ;
         SPINNER  MIN 0 MAX 6 ;
         VALID    ( aTmp[ _NDECESC ] >= 0 .AND. aTmp[ _NDECESC ]  <= 6 ) ;
         OF       fldArticulos

      REDEFINE RADIO aTmp[ _NCOPSEA ] ; 
         ID       760, 761, 762 ;
         OF       fldArticulos

      // Page 4 Contadores--------------------------------------------------------

      REDEFINE BITMAP oBmpContadores ;
            ID       500 ;
            RESOURCE "gc_document_text_pencil_48" ;
            TRANSPARENT ;
            OF       fldContadores 

      REDEFINE COMBOBOX oCmbDocumentos VAR cCmbDocumentos ;
            ID       100;
            OF       fldContadores  ;
            WHEN     ( nMode != ZOOM_MODE ) ;
            ITEMS    aDocumentos ;
            BITMAPS  aImagenes

      oCmbDocumentos:bChange  := {|| CmbDocumentosChanged() }

      REDEFINE GET oGetSerie VAR cGetSerie ;
            ID       150 ;
            IDSAY    151 ;
            PICTURE  "@!" ;
            SPINNER ;
            ON UP    ( UpSerie( oGetSerie ) );
            ON DOWN  ( DwSerie( oGetSerie ) );
            VALID    ( Empty( cGetSerie ) .or. ( cGetSerie >= "A" .and. cGetSerie <= "Z" ) ) ;
            OF       fldContadores 

      REDEFINE COMBOBOX oCmbSerie VAR cCmbSerie ;
            ITEMS    DOCUMENT_SERIES ;
            ID       110 ;
            OF       fldContadores 

      oCmbSerie:bChange       := {|| CmbSerieChanged() }

      REDEFINE GET oGetContador VAR nGetContador ;
         ID       120 ;
         IDSAY    122 ;
         SPINNER ;
         PICTURE  "999999999" ;
         VALID    ( nGetContador > 0 ) ;
         OF       fldContadores 

      REDEFINE GET oGetFormato VAR cGetFormato ;
         ID       130 ;
         IDTEXT   131 ;
         IDSAY    132 ;
         BITMAP   "LUPA" ;
         VALID    ( cDocumento( oGetFormato, oGetFormato:oHelpText ) ) ;
         ON HELP  ( brwDocumento( oGetFormato, oGetFormato:oHelpText ) ) ;
         OF       fldContadores 

      REDEFINE GET oGetCopias VAR nGetCopias ;
            ID       140 ;
            IDSAY    141 ;
            VALID    nGetCopias >= 0 ;
            PICTURE  "9" ;
            SPINNER ;
            MIN      0 ;
            MAX      9 ;
            OF       fldContadores 

      REDEFINE GET oGetNFCPrefijo VAR cGetNFCPrefijo ;
            ID       160 ;
            IDSAY    161 ;
            OF       fldContadores 

      REDEFINE GET oGetNFCContador VAR cGetNFCContador ;
            ID       170 ;
            IDSAY    171 ;
            OF       fldContadores 

      REDEFINE GET oGetPlantillaDefecto VAR cGetPlantillaDefecto ;
            ID       190 ;
            BITMAP   "Folder" ;
            ON HELP  ( oGetPlantillaDefecto:cText( cGetFile( 'Html (*.html, *.htm) |*.html;*.htm|', 'Seleccione el fichero HTML', , cPatHtml() ) ) ) ;
            OF       fldContadores 

      // Page 4 Contabilidad------------------------------------------------------

      REDEFINE BITMAP oBmpContabilidad ;
         ID       500 ;
         RESOURCE "gc_folders2_48" ;
         TRANSPARENT ;
         OF       fldContabilidad

      // Tipo de exportacion contable------------------------------------------

      REDEFINE COMBOBOX oCmbContabilidad VAR cCmbContabilidad ;
         ITEMS    { "Contaplus", "A3 CON" } ;
         ID       90 ;
         OF       fldContabilidad

      oCmbContabilidad:bChange      := {|| SetAplicacionContable( oCmbContabilidad:nAt ) }

      // Directorio contabilidad o exportacion---------------------------------

      REDEFINE GET aGet[ _CRUTCNT ] ;
         VAR      aTmp[ _CRUTCNT ] ;
         ID       100;
         PICTURE  "@!" ;
         BITMAP   "FOLDER" ;
         OF       fldContabilidad

      aGet[ _CRUTCNT ]:bHelp        := {|| aGet[ _CRUTCNT ]:cText( Padr( cGetDir32( "Seleccione directorio", Rtrim( aTmp[ _CRUTCNT ] ), .t. ), 100 ) ) }
      aGet[ _CRUTCNT ]:bValid       := {|| ValidRutaContabilidad( aGet, aTmp ) }

      // Empresa contabilidad--------------------------------------------------

      oBrwEmp                       := IXBrowse():New( fldContabilidad )

      oBrwEmp:bClrSel               := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwEmp:bClrSelFocus          := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwEmp:bWhen                 := {|| ChkRuta( aTmp[ _CRUTCNT ], .f. ) }
      oBrwEmp:bLDblClick            := {|| EditConta( oBrwEmp:nArrayAt, aTmp ), oBrwEmp:Refresh() }

      oBrwEmp:SetArray( aItmEmp, , , .f. )

      oBrwEmp:nMarqueeStyle         := 5
      oBrwEmp:nRowHeight            := 22      
      oBrwEmp:lHScroll              := .f.

      oBrwEmp:CreateFromResource( 110 )

      with object ( oBrwEmp:AddCol() )
         :cHeader          := "Serie"
         :bEditValue       := {|| aItmEmp[ oBrwEmp:nArrayAt, 1 ] }
         :nWidth           := 30
      end with

      with object ( oBrwEmp:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| aItmEmp[ oBrwEmp:nArrayAt, 2 ] }
         :nWidth           := 60
      end with

      with object ( oBrwEmp:AddCol() )
         :cHeader          := "Empresa"
         :bEditValue       := {|| cEmpresaContaplus( AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ oBrwEmp:nArrayAt, 2 ] ) }
         :nWidth           := 190
      end with

      with object ( oBrwEmp:AddCol() )
         :cHeader          := "Proyecto"
         :bEditValue       := {|| Transform( aItmEmp[ oBrwEmp:nArrayAt, 3 ], "@R ###.#######" ) }
         :nWidth           := 80
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
      end with

      with object ( oBrwEmp:AddCol() )
         :cHeader          := "Modificar"
         :bStrData         := {|| "" }
         :bOnPostEdit      := {|| .t. }
         :bEditBlock       := {|| EditConta( oBrwEmp:nArrayAt, aTmp ), oBrwEmp:Refresh() }
         :nEditType        := 5
         :nWidth           := 20
         :nHeadBmpNo       := 1
         :nBtnBmp          := 1
         :nHeadBmpAlign    := 1
         :AddResource( "Edit16" )
     end with

      // Cliente---------------------------------------------------------------

      REDEFINE GET aGet[ _CCTACLI ] VAR aTmp[ _CCTACLI ] ;
         ID       370;
         IDSAY    371;
         PICTURE  "999" ;
         WHEN     ChkRuta( aTmp[ _CRUTCNT ], .f. ) ;
         BITMAP   "LUPA" ;
         VALID    ( ChkCta( aTmp[ _CCTACLI ], aGet[ _CCTACLI ]:oSay, .f., AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         ON HELP  ( BrwChkCta( aGet[ _CCTACLI ], aGet[ _CCTACLI ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTAPRV ] VAR aTmp[ _CCTAPRV ] ;
         ID       380;
         IDSAY    381;
         PICTURE  "999" ;
         WHEN     ChkRuta( aTmp[ _CRUTCNT ], .f. ) ;
         BITMAP   "LUPA" ;
         VALID    ( ChkCta( aTmp[ _CCTAPRV ], aGet[ _CCTAPRV ]:oSay, .f., AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         ON HELP  ( BrwChkCta( aGet[ _CCTAPRV ], aGet[ _CCTAPRV ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTAVTA ] VAR aTmp[ _CCTAVTA ] ;
         ID       390;
         IDSAY    391;
         PICTURE  "999" ;
         WHEN     ChkRuta( aTmp[ _CRUTCNT ], .f. ) ;
         BITMAP   "LUPA" ;
         VALID    ( ChkCta( aTmp[ _CCTAVTA ], aGet[ _CCTAVTA ]:oSay, .f., AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         ON HELP  ( BrwChkCta( aGet[ _CCTAVTA ], aGet[ _CCTAVTA ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTACOB ] VAR aTmp[ _CCTACOB ] ;
         ID       400 ;
         IDSAY    401 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTACOB ], aGet[ _CCTACOB ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTACOB ], nil, aGet[ _CCTACOB ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTASIN ] VAR aTmp[ _CCTASIN ] ;
         ID       410 ;
         IDSAY    411 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTASIN ], aGet[ _CCTASIN ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTASIN ], nil, aGet[ _CCTASIN ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTAANT ] VAR aTmp[ _CCTAANT ] ;
         ID       430 ;
         IDSAY    431 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAANT ], aGet[ _CCTAANT ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAANT ], nil, aGet[ _CCTAANT ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTARET ] VAR aTmp[ _CCTARET ] ;
         ID       440 ;
         IDSAY    441 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTARET ], aGet[ _CCTARET ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTARET ], nil, aGet[ _CCTARET ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTAPOR ] VAR aTmp[ _CCTAPOR ] ;
         ID       445 ;
         IDSAY    446 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAPOR ], aGet[ _CCTAPOR ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAPOR ], nil, aGet[ _CCTAPOR ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTAGAS ] VAR aTmp[ _CCTAGAS ] ;
         ID       510 ;
         IDSAY    511 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTAGAS ], aGet[ _CCTAGAS ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTAGAS ], nil, aGet[ _CCTAGAS ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTACEESPT ] VAR aTmp[ _CCTACEESPT ] ;
         ID       450 ;
         IDSAY    451 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTACEESPT ], aGet[ _CCTACEESPT ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTACEESPT ], nil, aGet[ _CCTACEESPT ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCTACEERPT ] VAR aTmp[ _CCTACEERPT ] ;
         ID       460 ;
         IDSAY    461 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCTACEERPT ], aGet[ _CCTACEERPT ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCTACEERPT ], nil, aGet[ _CCTACEERPT ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      // IVA COMPRAS------------------------------------------------------------------

      REDEFINE GET aGet[ _CCEESPTCOM ] VAR aTmp[ _CCEESPTCOM ] ;
         ID       550 ;
         IDSAY    551 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCEESPTCOM ], aGet[ _CCEESPTCOM ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCEESPTCOM ], nil, aGet[ _CCEESPTCOM ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      REDEFINE GET aGet[ _CCEERPTCOM ] VAR aTmp[ _CCEERPTCOM ] ;
         ID       560 ;
         IDSAY    561 ;
         PICTURE  ( Replicate( "X", nLenSubcuentaContaplus() ) ) ;
         WHEN     ( ChkRuta( aTmp[ _CRUTCNT ], .f. ) ) ;
         BITMAP   "LUPA" ;
         ON HELP  ( BrwChkSubcuenta( aGet[ _CCEERPTCOM ], aGet[ _CCEERPTCOM ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) ) ;
         VALID    ( MkSubcuenta( aGet[ _CCEERPTCOM ], nil, aGet[ _CCEERPTCOM ]:oSay, AllTrim( aTmp[ _CRUTCNT ] ), aItmEmp[ 1, 2 ] ) );
         OF       fldContabilidad

      //-----------------------------------------------------------------------------         

      REDEFINE RADIO nIvaReq ;
         ID       420, 421 ;
         WHEN     ChkRuta( aTmp[ _CRUTCNT ], .f. ) ;
         OF       fldContabilidad

      REDEFINE CHECKBOX aGet[ _LCONIVA ] VAR aTmp[ _LCONIVA ] ;
         ID       470 ;
         OF       fldContabilidad

      REDEFINE CHECKBOX aGet[ _LREQDEC ] VAR aTmp[ _LREQDEC ] ;
         ID       480 ;
         OF       fldContabilidad

      REDEFINE CHECKBOX aGet[ _LAPTNEG ] VAR aTmp[ _LAPTNEG ] ;
         ID       490 ;
         OF       fldContabilidad

      REDEFINE CHECKBOX aGet[ _LCONTREC ] VAR aTmp[ _LCONTREC ] ;
         ID       530 ;
         OF       fldContabilidad

      REDEFINE CHECKBOX lInformacionInmediata ;
         ID       240;
         OF       fldContabilidad  

      // Page 6 Envios------------------------------------------------------------

      REDEFINE BITMAP oBmpEnvios ;
         ID          500 ;
         RESOURCE    "gc_satellite_dish2_48" ;
         TRANSPARENT ;
         OF          fldEnvios

      REDEFINE COMBOBOX aGet[ _CENVUSR ] VAR aTmp[ _CENVUSR ] ;
         ITEMS    { "Cliente", "Servidor" } ;
         ID       100 ;
         OF       fldEnvios

      REDEFINE CHECKBOX aGet[ _LEMPFRNQ ] VAR aTmp[ _LEMPFRNQ ] ;
         ID       400 ;
         OF       fldEnvios      

      REDEFINE RADIO aTmp[ _NTIPCON ] ;
         ID       110, 111 ;
         OF       fldEnvios

      REDEFINE GET aGet[ _CRUTCON ] VAR aTmp[ _CRUTCON ] ;
         ID       120;
         PICTURE  "@!" ;
         BITMAP   "FOLDER" ;
         ON HELP  ( aGet[ _CRUTCON ]:cText( Padr( cGetDir32( "Seleccione directorio", Rtrim( aTmp[ _CRUTCON ] ), .t. ), 100 ) ) );
         OF       fldEnvios

      REDEFINE GET aTmp[ _CSITFTP ] ;
         ID       160;
         WHEN     ( aTmp[ _NTIPCON ] == 2 ) ;
         OF       fldEnvios

      REDEFINE GET aTmp[ _CUSRFTP ] ;
         ID       170 ;
         WHEN     ( aTmp[_NTIPCON] == 2 ) ;
         OF       fldEnvios

      REDEFINE GET aTmp[ _CPSWFTP ] ;
         ID       180;
         WHEN     ( aTmp[ _NTIPCON ] == 2 ) ;
         OF       fldEnvios

      REDEFINE CHECKBOX aGet[ _LPASENVIO ] VAR aTmp[ _LPASENVIO ] ;
         ID       200 ;
         OF       fldEnvios

      REDEFINE CHECKBOX aGet[ _LENVENT ] VAR aTmp[ _LENVENT ] ;
         ID       190 ;
         OF       fldEnvios

      REDEFINE CHECKBOX aGet[ _LRECENT ] VAR aTmp[ _LRECENT ] ;
         ID       191 ;
         OF       fldEnvios

      REDEFINE CHECKBOX aTmp[ _LMAILTRNO ] ;
         ID       300;
         WHEN     ( lUsrMaster() ) ;
         OF       fldEnvios

      REDEFINE GET aTmp[ _CMAILTRNO ] ;
         ID       310 ;
         WHEN     ( lUsrMaster() .and. aTmp[ _LMAILTRNO ] ) ;
         OF       fldEnvios

      REDEFINE GET aTmp[ _CCODCLIFRQ ] ;
         ID       320 ;
         PICTURE  ( Replicate( "X", RetNumCodCliEmp() ) ) ;
         OF       fldEnvios

      REDEFINE GET aTmp[ _CCODPRVFRQ ] ;
         ID       330;
         PICTURE  ( Replicate( "X", RetNumCodPrvEmp() ) ) ;
         OF       fldEnvios

      // Page 7 comunicacion------------------------------------------------------

      REDEFINE BITMAP oBmpComunicacion ;
         ID       500 ;
         RESOURCE "gc_earth_48" ;
         TRANSPARENT ;
         OF       fldComunicaciones

      REDEFINE GET aTmp[ _CSRVMAI ] ;
         ID       160;
         OF       fldComunicaciones

      REDEFINE GET aTmp[ _NPRTMAI ] ;
            ID       165;
            OF       fldComunicaciones

      REDEFINE GET aTmp[ _CCTAMAI ] ;
            ID       170;
            OF       fldComunicaciones

      REDEFINE GET aTmp[ _CPSSMAI ] ;
            ID       176;
            OF       fldComunicaciones

      REDEFINE CHECKBOX aTmp[ _LAUTMAI ] ;
            ID       175;
            OF       fldComunicaciones

      REDEFINE CHECKBOX aTmp[ _LSSLMAI ] ;
            ID       177;
            OF       fldComunicaciones

      REDEFINE GET aTmp[ _CCCPMAI ] ;
            ID       180;
            OF       fldComunicaciones

      REDEFINE GET aTmp[ _CCCOMAI ] ;
            ID       185;
            OF       fldComunicaciones

      // Web----------------------------------------------------------------------

      TComercio:dialogCreateWebCombobox( 100, fldComunicaciones )

      REDEFINE BTNBMP ;
            ID       101 ;
            OF       fldComunicaciones ;
            RESOURCE "gc_data_16" ;
            NOBORDER ;
            TOOLTIP  "" ;
            ACTION   ( TestConexionDatabase() )

      REDEFINE BTNBMP ;
            ID       102 ;
            OF       fldComunicaciones ;
            RESOURCE "gc_data_16" ;
            NOBORDER ;
            TOOLTIP  "" ;
            ACTION   ( TestConexionFTP() )

      REDEFINE SAY   ;
            PROMPT   TComercio:getErrorJson() ;
            ID       105 ;
            OF       fldComunicaciones ;

      REDEFINE GET   aGet[ _CRUTEDI ] ;
            VAR      aTmp[ _CRUTEDI ] ;
            ID       300 ;
            PICTURE  "@!" ;
            BITMAP   "FOLDER" ;
            ON HELP  ( aGet[ _CRUTEDI ]:cText( Padr( cGetDir32( "Seleccione directorio", Rtrim( aTmp[ _CRUTEDI ] ), .t. ), 100 ) ) );
            OF       fldComunicaciones

      REDEFINE GET aTmp[ _CCODEDI ] ;
            ID       310 ;
            OF       fldComunicaciones

      // Botones --------------------------------------------------------------------

      fldContadores:AddFastKey( VK_F3, {|| EdtCon( oBrwCon ) } )

      oDlg:AddFastKey( VK_F5, {|| SaveEditConfig( aTmp, oSay, oBrw, oDlg, nMode ) } )

      oDlg:bStart    := {|| StartEditConfig( aTmp, oSay, oBrw, oDlg, oFld, nMode ) }

   ACTIVATE DIALOG oDlg ;
      ON INIT        ( InitEditConfig( oFld, nSelFolder ) ) ;
      CENTER

   // Fin del control de errores--------------------------------------------------

   RECOVER USING oError

      msgStop( "Imposible editar configuración de empresas" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE
   ErrorBlock( oBlock ) 
   
   // Matamos los objetos con las imágenes----------------------------------------

   KillTrans()

   if oDlg:nResult == IDOK
      setEmpresa( ( dbfEmp )->CodEmp, dbfEmp, dbfDlg, dbfUser, oBrw )
      
      checkEmpresaTablesExistences()

      chkTurno( , oWnd() )
   end if

   // Reanudamos los servicios ---------------------------------------------------

   InitServices()

   // Matamos los objetos con las imágenes----------------------------------------

   if !Empty( oBmpComportamiento )
      oBmpComportamiento:End()
   end if

   if !Empty( oBmpDefecto )
      oBmpDefecto:End()
   end if

   if !Empty( oBmpArticulos )
      oBmpArticulos:End()
   end if

   if !Empty( oBmpContadores )
      oBmpContadores:End()
   end if

   if !Empty( oBmpContabilidad )
      oBmpContabilidad:End()
   end if

   if !Empty( oBmpEnvios )
      oBmpEnvios:End()
   end if

   if !Empty( oBmpComunicacion )
      oBmpComunicacion:End()
   end if

   if !Empty( oBmpTPV )
      oBmpTPV:End()
   end if 

   if !Empty( oFnt )
      oFnt:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function InitEditConfig( oFld, nSelFolder )

   oFld:SetOption( nSelFolder ) 

Return ( nil )

//--------------------------------------------------------------------------//

Static Function StartEditConfig( aTmp, oSay, oBrw, oDlg, oFld, nMode )

   local oBoton
   local oGrupo
   local oCarpeta

   oOfficeBar              := TDotNetBar():New( 0, 0, 2020, 128, oDlg, 1 )
   oOfficeBar:lPaintAll    := .f.
   oOfficeBar:lDisenio     := .f.
   oOfficeBar:SetStyle( 1 )

   oDlg:oTop         := oOfficeBar

   oCarpeta          := TCarpeta():New( oOfficeBar, "Configurar empresa." )

   oGrupo            := TDotNetGroup():New( oCarpeta, 488, "Opciones", .f. ) 
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_wrench_32",               "General",           1, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_clipboard_pencil_32",     "Valores",           2, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_object_cube_32",          "Artículos",         3, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_cash_register_32",        "T.P.V.",            4, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_document_text_pencil_32", "Contadores",        5, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_folders2_32",             "Contabilidad",      6, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_satellite_dish2_32",      "Envios",            7, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_earth_32",                "Comunicaciones",    8, {| oBtn | oFld:SetOption( oBtn:nColumna ) }, , , .f., .f., .f. )

   oGrupo            := TDotNetGroup():New( oCarpeta, 122, "Guardar", .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32",          "Guardar",           1, {|| SaveEditConfig( aTmp, oSay, oBrw, oDlg, nMode ) }, , , .f., .f., .f. )
      oBoton         := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",           "Salida",            2, {|| oDlg:End() }, , , .f., .f., .f. )

   aEvalValid( fldValores )

   aEvalValid( fldContabilidad ) 

   CmbDocumentosChanged( .f. ) 

Return nil

//---------------------------------------------------------------------------//

Static Function KillTrans()

	/*
   Borramos los ficheros-------------------------------------------------------
   */

   if !Empty( tmpDlg ) .and. ( tmpDlg )->( Used() )
      ( tmpDlg )->( dbCloseArea() )
      tmpDlg         := nil
   end if

   dbfErase( cNewDlg )

   if !Empty( tmpCount ) .and. ( tmpCount )->( Used() )
      ( tmpCount )->( dbCloseArea() )
      tmpCount      := nil
   end if

   dbfErase( cTmpCon )

Return nil

//------------------------------------------------------------------------//

Static Function CmbDocumentosChanged( lCmbSerieSaved )

   local cItemText

   DEFAULT lCmbSerieSaved  := .t.

   /*
   Documento seleccionado------------------------------------------------------
   */

   cItemText               := Upper( Rtrim( cCmbDocumentos ) )
   if Empty( cItemText )
      return ( .t. )
   end if

   /*
   Guardamos los datos de las series-------------------------------------------
   */

   if lCmbSerieSaved
      CmbSerieSave( oCmbSerie )
   end if 

   /*
   Nuevo tipo de documento-----------------------------------------------------
   */

   if dbSeekInOrd( cItemText, "Des", tmpCount )

      cOldSerie         := nil

      if ( tmpCount )->lSerie
         if( !empty( oCmbSerie ), oCmbSerie:Show(), )
         if( !empty( oCmbSerie ), oCmbSerie:Select( 1 ), )
         if( !empty( oGetSerie ), oGetSerie:Show(), )
      else
         if( !empty( oCmbSerie ), oCmbSerie:Hide(), )
         if( !empty( oGetSerie ), oGetSerie:Hide(), )
      end if

      if ( tmpCount )->lDoc
         if( !empty( oGetFormato ), oGetFormato:Show(), )
         if( !empty( oGetCopias ), oGetCopias:Show(), )
      else
         if( !empty( oGetFormato ), oGetFormato:Hide(), )
         if( !empty( oGetCopias ), oGetCopias:Hide(), )
      end if

      if ( tmpCount )->lCon
         if( !empty( oGetContador ), oGetContador:Show(), )
      else
         if( !empty( oGetContador ), oGetContador:Hide(), )
      end if

      if( !empty( oGetSerie ), oGetSerie:cText( ( tmpCount )->cSerie ), )

      if( !empty( oGetPlantillaDefecto ), oGetPlantillaDefecto:cText( ( tmpCount )->cPltDfl ), )

      if ( tmpCount )->lNFC
         if( !empty( oGetNFCPrefijo ), oGetNFCPrefijo:Show(), )
         if( !empty( oGetNFCContador ), oGetNFCContador:Show(), )
      else
         if( !empty( oGetNFCPrefijo ), oGetNFCPrefijo:Hide(), )
         if( !empty( oGetNFCContador ), oGetNFCContador:Hide(), )
      end if

      /*
      Cargamos los datos de la serie-------------------------------------------
      */

      CmbSerieChanged()

   end if

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function CmbSerieSave( uSerie )

   local cSerie

   do case
      case isObject( uSerie )
         cSerie         := uSerie:VarGet()
      case isChar( uSerie)
         cSerie         := uSerie
   end case 

   if Empty( cSerie )
      Return ( .t. )
   end if

   /*
   msgStop( "Serie q voy a guardar :" + cSerie     + CRLF + ;
            "nGetContador :" + Str( nGetContador)  + CRLF + ;
            "cGetFormato : " + cGetFormato         + CRLF + ;
            "nGetCopias : " + Str( nGetCopias )    + CRLF + ;
            "nGetNFCPrefijo : " + cGetNFCPrefijo   + CRLF + ;
            "cGetNFCContador : " + cGetNFCContador, "CmbSerieSave" ) */

   if !Empty( cSerie ) .and. dbDialogLock( tmpCount )
      ( tmpCount )->( FieldPut( FieldPos( cSerie ),               nGetContador      ) )
      ( tmpCount )->( FieldPut( FieldPos( "Doc"    + cSerie ),    cGetFormato       ) )
      ( tmpCount )->( FieldPut( FieldPos( "Copias" + cSerie ),    nGetCopias        ) )
      ( tmpCount )->( FieldPut( FieldPos( "cNCF"   + cSerie ),    cGetNFCPrefijo    ) )
      ( tmpCount )->( FieldPut( FieldPos( "nCNF"   + cSerie ),    cGetNFCContador   ) )

      ( tmpCount )->cSerie                                       := cGetSerie         
      ( tmpCount )->cPltDfl                                      := cGetPlantillaDefecto
      ( tmpCount )->( dbUnLock() )
   end if

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function CmbSerieChanged()

   local cSerie         

   if empty( oCmbSerie )
      return .t.
   end if 
   cSerie               := oCmbSerie:VarGet()

   if !Empty( cOldSerie ) .and. ( cOldSerie != cSerie )
      cmbSerieSave( cOldSerie )
   end if

   oGetContador:cText( ( tmpCount )->( FieldGet( FieldPos( cSerie ) ) ) )
   oGetCopias:cText( Max( ( tmpCount )->( FieldGet( FieldPos( "Copias" + cSerie ) ) ), 0 ) )
   oGetFormato:cText( ( tmpCount )->( FieldGet( FieldPos( "Doc" + cSerie ) ) ) )

   oGetNFCPrefijo:cText( ( tmpCount )->( FieldGet( FieldPos( "cNFC" + cSerie ) ) ) )
   oGetNFCContador:cText( ( tmpCount )->( FieldGet( FieldPos( "nNFC" + cSerie ) ) ) )

   oGetPlantillaDefecto:cText( ( tmpCount )->cPltDfl )

   oGetFormato:lValid()

   cOldSerie            := cSerie

Return ( .t. )

//--------------------------------------------------------------------------//

Static Function EdtDet( aTmp, aGet, tmpDlg, oBrw, bVal, bWhe, nMode, cCod )

   local oDlg

   DEFINE DIALOG oDlg RESOURCE "Delega" TITLE LblTitle( nMode ) + "delegaciones"

      REDEFINE GET aTmp[ ( tmpDlg )->( FieldPos( "cCodDlg" ) ) ];
         WHEN     ( nMode == APPD_MODE );
         PICTURE  "@!";
         VALID    ( lValidDelega( cCod, aTmp[ ( tmpDlg )->( FieldPos( "cCodDlg" ) ) ] ) );
         ID       100 ;
			OF 		oDlg

      REDEFINE GET aTmp[ ( tmpDlg )->( FieldPos( "cNomDlg" ) ) ];
         ID       110 ;
			OF 		oDlg

      REDEFINE BUTTON;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( EndDelega( aTmp, aGet, tmpDlg, oBrw, nMode, oDlg, cCod ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| EndDelega( aTmp, aGet, tmpDlg, oBrw, nMode, oDlg, cCod ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function EndDelega( aTmp, aGet, tmpDlg, oBrw, nMode, oDlg, cCod )

   if nMode == APPD_MODE
      if Empty( aTmp[ ( tmpDlg )->( FieldPos( "cCodDlg" ) ) ] ) .or. ( tmpDlg )->( dbSeek( cCod + aTmp[ ( tmpDlg )->( FieldPos( "cCodDlg" ) ) ] ) )
         MsgStop( "Código no valido" )
         return nil
      end if
   end if

   WinGather( aTmp, aGet, tmpDlg, oBrw, nMode )

Return ( oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Static Function lValidDelega( cCodEmpresa, cCodDelega )

   if Empty( cCodDelega )
      MsgStop( "Código de delgación no puede estar vacio" )
      return .f.
   end if

   if ( tmpDlg )->( dbSeek( cCodEmpresa + cCodDelega ) )
      MsgStop( "Delegación existente" )
      return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//

STATIC FUNCTION EdtCon( oBrwCon )

   local cPic
   local nCol     := oBrwCon:nColAct
   local uVar     := ( tmpCount )->( fieldGet( nCol + 1 ) )
   local bValid

   if nCol <= 1
      return .f.
   end if

   if nCol == 2
      cPic        := "@!"
      bValid      := { |oGet| Empty( oGet:VarGet() ) .or. ( oGet:VarGet() >= "A" .and. oGet:VarGet() <= "Z" ) }
   else
      cPic        := "999999999"
      bValid      := { |oGet| oGet:VarGet() > 0 }
   end if

   if oBrwCon:lEditCol( nCol, @uVar, cPic, bValid )

      if dbDialogLock( tmpCount )
         ( tmpCount )->( fieldPut( nCol + 1, uVar ) )
         ( tmpCount )->( dbUnlock() )
      end if

      oBrwCon:DrawSelect()

   end if

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION cEmpresa( oGet, dbfEmp, oGet2, aGet, aTmp, tmpDlg, dbfDlg )

   local nRec
   local lValid   := .f.
   local cCodEmp  := oGet:VarGet()

   if Empty( cCodEmp )

      if !Empty( oGet2 )
			oGet2:cText( "" )
      end if

      return .t.

   end if

   nRec           := ( dbfEmp )->( Recno() )

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmp )

      oGet:cText( ( dbfEmp )->CodEmp )

      if !Empty( oGet2 )
         oGet2:cText( ( dbfEmp )->cNombre )
      end if

      lValid      := .t.

   else

		msgStop( "Empresa no encontrada", "Cadena buscada : " + cCodEmp )

   end if

   ( dbfEmp )->( dbGoTo( nRec ) )

RETURN lValid

//---------------------------------------------------------------------------//

FUNCTION lEmpresa( cCodEmp, dbfEmp )

   local lClose   := .f.
   local lValid   := .f.

   if Empty( cCodEmp )
      return .f.
   end if

   if Empty( dbfEmp )
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lClose      := .t.
   end if

   if ( dbfEmp )->( dbSeek( cCodEmp ) )
      lValid      := .t.
   end if

   if lClose
      CLOSE ( dbfEmp )
   end if

RETURN lValid

//---------------------------------------------------------------------------//

Static Function lGrupo( cCodEmp, dbfEmp )

   local lGrupo   := .f.

   if Empty( cCodEmp )
      return .f.
   end if

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmp )
      lGrupo      := ( dbfEmp )->lGrupo
   end if

RETURN lGrupo

//---------------------------------------------------------------------------//

FUNCTION BrwEmpresa( oGet, dbfEmp, oGet2, lGrupo )

	local oDlg
	local oBrw
	local oGet1
	local cGet1
   local aSta
   local nRec
   local nOrd     := GetBrwOpt( "BrwEmpresa" )
	local oCbxOrd
   local aCbxOrd  := { "Código", "Nombre" }
   local cCbxOrd

   DEFAULT lGrupo := .f.

   nOrd           := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd        := aCbxOrd[ nOrd ]

   nRec           := ( dbfEmp )->( Recno() )
   nOrd           := ( dbfEmp )->( OrdSetFocus( nOrd ) )

   if lGrupo
      ( dbfEmp )->( dbSetFilter( {|| Field->lGrupo }, "lGrupo" ) )
   else
      ( dbfEmp )->( dbSetFilter( {|| !Field->lGrupo }, "!lGrupo" ) )
   end if

   aSta           := aGetStatus( dbfEmp )

   ( dbfEmp )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE if( lGrupo, "Grupo", "Empresa" )

		REDEFINE GET oGet1 VAR cGet1;
         ID       104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfEmp ) );
         VALID    ( OrdClearScope( oBrw, dbfEmp ) );
         BITMAP   "Find" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfEmp )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfEmp
      oBrw:nMarqueeStyle   := 6
      oBrw:cName           := "Browse.Empresa"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "CodEmp"
         :bEditValue       := {|| ( dbfEmp )->CodEmp }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNombre"
         :bEditValue       := {|| ( dbfEmp )->cNombre }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:end() )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     .f. ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     .f. ;
         ACTION   ( nil )

      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )

      oDlg:bStart := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   IF oDlg:nResult == IDOK

      oGet:cText( ( dbfEmp )->CodEmp )

		IF ValType( oGet2 ) == "O"
         oGet2:cText( (dbfEmp)->cNombre )
		END IF

	END IF

   DestroyFastFilter( dbfEmp )

   SetStatus( dbfEmp, aSta )

   ( dbfEmp )->( dbClearFilter() )
   ( dbfEmp )->( OrdSetFocus( nOrd ) )
   ( dbfEmp )->( dbGoTo( nRec ) )

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function SetEmpresa( cCodEmp, dbfEmp, dbfDlg, dbfUsr, oBrw )

   local nOrd
   local oBlock
   local oError
   local lError      := .f.
   local lCloDlg     := .f.
   local lCloEmp     := .f.
   local lCloUsr     := .f.
   local lCmbEmpUsr  := oUser():lCambiarEmpresa
   local cCodEmpUsr  := oUser():_EmpresaFija

   if !empty( oWnd() )
      oWnd():Disable()
   end if

   CursorWait()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE
   
   if Empty( dbfEmp )
      USE ( cPatDat() + "EMPRESA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPRESA", @dbfEmp ) )
      SET ADSINDEX TO ( cPatDat() + "EMPRESA.CDX" ) ADDITIVE
      lCloEmp        := .t.
   end if

   if Empty( dbfUsr )
      USE ( cPatDat() + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUsr ) )
      SET ADSINDEX TO ( cPatDat() + "USERS.CDX" ) ADDITIVE
      lCloUsr        := .t.
   end if

   if Empty( dbfDlg )
      USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDlg ) )
      SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE
      lCloDlg        := .t.
   end if

   /*
   Si la empresa esta vacia----------------------------------------------------
   */

   if Empty( cCodEmp )

      if ( dbfEmp )->( lastrec() ) == 0
         AppEmpresa()
      end if

      if !Empty( cEmpUsr() )
         cCodEmp     := cEmpUsr()
      else
         cCodEmp     := GetCodEmp( dbfEmp )
      end if

   end if

   /*
   Quitamos la empresa actual--------------------------------------------------
   */

   if Empty( cCodEmp )
      ( dbfEmp )->( dbGoTop() )
      cCodEmp        := ( dbfEmp )->CodEmp 
   end if

   cCodEmp           := RJust( cCodEmp, "0", 4 ) 

   nOrd              := ( dbfEmp )->( OrdSetFocus( "CodEmp" ) )
   if !( dbfEmp )->( dbSeek( cCodEmp ) )
      lError         := .t.
      msgStop( "La empresa " + cCodEmp + " no existe." )
   else
      if ( dbfEmp )->lGrupo
         lError      := .t.
         msgStop( "La empresa que desea seleccionar es un grupo de empresas no existe." )
      end if
   end if
  ( dbfEmp )->( OrdSetFocus( nOrd ) )

   if !lAdsRdd()
      if !lIsDir( FullCurDir() + "Emp" + cCodEmp )
         lError      := .t.
         msgStop( "El directorio de la empresa " + cCodEmp + " no existe." )
      end if
   end if

   /*
   Si hay errores buscamos alternativas----------------------------------------
   */

   if lError

      ( dbfEmp )->( dbGoTop() )
      while !( dbfEmp )->( eof() )

         if ( dbfEmp )->lGrupo

            ( dbfEmp )->( dbSkip() )

         else

            if dbLock( dbfEmp )
               ( dbfEmp )->lActiva  := .t.
               ( dbfEmp )->( dbUnLock() )
            end if

            msgStop( "La nueva empresa activa es " + ( dbfEmp )->CodEmp + " - " + Rtrim( ( dbfEmp )->cNombre ) )

            cCodEmp  := Alltrim( ( dbfEmp )->CodEmp )

            exit

         end if

      end while

   end if

   /*
   Ponemos el directorio para los ficheros-------------------------------------
   */

   cPatEmp( cCodEmp )
   
   cPatScriptEmp( cCodEmp )

   /*
   Directorios si no tiene grupo-----------------------------------------------
   */

   if Empty( ( dbfEmp )->cCodGrp ) 

      cPatCli( cCodEmp, nil, .t. )

      cPatArt( cCodEmp, nil, .t. )

      cPatPrv( cCodEmp, nil, .t. )

      cPatAlm( cCodEmp, nil, .t. )

      aEmpGrp( cCodEmp, dbfEmp, .t. )

   else

      if RetFld( cCodEmp, dbfEmp, "lGrpCli", "CodEmp" )
         cPatCli( ( dbfEmp )->cCodGrp, nil, .f. )
      else
         cPatCli( cCodEmp, nil, .t. )
      end if

      if RetFld( cCodEmp, dbfEmp, "lGrpArt", "CodEmp" )
         cPatArt( ( dbfEmp )->cCodGrp, nil, .f. )
      else
         cPatArt( cCodEmp, nil, .t. )
      end if

      if RetFld( cCodEmp, dbfEmp, "lGrpPrv", "CodEmp" )
         cPatPrv( ( dbfEmp )->cCodGrp, nil, .f. )
      else
         cPatPrv( cCodEmp, nil, .t. )
      end if

      if RetFld( cCodEmp, dbfEmp, "lGrpAlm", "CodEmp" )
         cPatAlm( ( dbfEmp )->cCodGrp, nil, .f. )
      else
         cPatAlm( cCodEmp, nil, .t. )
      end if

      aEmpGrp( ( dbfEmp )->cCodGrp, dbfEmp, .f. )

   end if

   /*
   Cargamos el buffer----------------------------------------------------------
   */

   cCodigoEmpresaEnUso( cCodEmp )

   if !aEmpresa( cCodEmp, dbfEmp, dbfDlg, dbfUsr )
      Empresa()
   end if
   
   /*
   Cargamos la estructura de ficheros de la empresa----------------------------
   */

   TDataCenter():BuildEmpresa()

   // TDataCenter():BuildData()

   /*
   Ponemos el titulo de la empresa---------------------------------------------
   */

   SetTituloEmpresa()

   /*
   Anotamos la empresa activa--------------------------------------------------
   */

   WritePProString( "main", "Ultima Empresa", cCodEmp, cIniAplication() )

   /*
   Colocamos la empresa actual a usuario actual-------------------------------
   */

   if !Empty( dbfUsr ) .and. ( dbfUsr )->( dbSeek( cCurUsr() ) )
      if ( dbfUsr )->( dbRLock() )
         ( dbfUsr )->cEmpUse  := cCodEmp
         ( dbfUsr )->( dbRUnLock() )
      end if
   end if

   /*
   Cerrando ficheros-----------------------------------------------------------
   */

   if !Empty( dbfDlg ) .and. lCloDlg
      ( dbfDlg )->( dbCloseArea() )
   end if

   if !Empty( dbfUsr ) .and. lCloUsr
      ( dbfUsr )->( dbCloseArea() )
   end if

   if !Empty( dbfEmp )
      if lCloEmp
         ( dbfEmp )->( dbCloseArea() )
      end if
   end if

   if !Empty( oBrw )
      oBrw:Refresh()
      oBrw:SetFocus()
   end if

   RECOVER USING oError

      msgStop( "Imposible seleccionar empresa" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   CursorWE()

   if !empty( oWnd() )
      oWnd():Enable()
   end if

Return nil

//---------------------------------------------------------------------------//

Function checkEmpresaTablesExistences()

   oMsgText( 'Comprobando existencia de tablas' )
   IsEntSal()

   oMsgText( 'Comprobando almacenes' )
   IsAlmacen()

   oMsgText( 'Comprobando formas de pago' )
   IsFPago()

   oMsgText( 'Comprobando articulos' )
   IsArticulo()

   oMsgText( 'Comprobando facturas a proveedor' )
   IsFacPrv()

   oMsgText( 'Comprobando presupuestos a clientes' )
   IsPreCli()

   oMsgText( 'Comprobando pedidos a clientes' )
   IsPedCli()

   oMsgText( 'Comprobando albaranes a clientes' )
   IsAlbCli()

   oMsgText( 'Comprobando facturas a clientes' )
   IsFacCli()

   oMsgText( 'Comprobando facturas rectificativas a clientes' )
   IsFacRec()
   
   oMsgText( 'Comprobando anticipos a clientes' )
   IsAntCli()

   oMsgText( 'Comprobando tickets' )
   IsTpv()

   oMsgText( 'Comprobando bancos' )
   IsBancos()

   oMsgText( 'Comprobando contadores' )
   IsCount()

Return nil

//---------------------------------------------------------------------------//

/*Funcion que borra el grupo de empresas y el directorio*/

STATIC FUNCTION WinDelGrp( oBrw, dbfEmp )

   local lRet     := .f.
   local cPath    := FullCurDir() + "Emp" + ( dbfEmp )->CodEmp + "\"
   local cCodEmp  := ( dbfEmp )->CodEmp
   local nRec     := ( dbfEmp )->( Recno() )

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return ( lRet )
   end if

   if dbSeekInOrd( cCodEmp, "CCODGRP", dbfEmp )
      msgStop( "No se puede eliminar un grupo asignado a empresas" )
      ( dbfEmp )->( dbGoto( nRec ) )
      return ( lRet )
   end if

   ( dbfEmp )->( dbGoto( nRec ) )

   if ApoloMsgNoYes( "Confirme eliminación de grupo", "Supresión de grupo" )

      if ApoloMsgNoYes( "Eliminara DEFINITIVAMENTE los datos del grupo: " + Rtrim( ( dbfEmp )->cNombre ), "Confirme supresión de grupo" )

         CursorWait()

         if IsDirectory( cPath )
            EraseFilesInDirectory(cPath )
            if DirRemove( cPath ) != 0
               msgStop( "Error al borrar el directorio " + Str( fError() ), cPath )
            end if
         end if

         DelRecno( dbfEmp, oBrw )

         lRet     := .t.

         CursorWE()

      end if

   end if

RETURN lRet

//---------------------------------------------------------------------------//

FUNCTION mkPathEmp( cCodEmpNew, cNomEmpNew, cCodEmpOld, aImportacion, lDialog, lNewEmp, nGetSemilla, oMsg )

   local oDlgWat
   local oBmp
   local lEnd           := .f.
   local acImages       := { "BAR_01" }
   local cMsg           := "Creando nueva empresa"
   local cPath          := cPatEmpOld( cCodEmpNew )
   local cPathOld       := if( !Empty( cCodEmpOld ), cPatEmpOld( cCodEmpOld ), nil )

   DEFAULT lDialog      := .f.
   DEFAULT lNewEmp      := .f.
   DEFAULT cNomEmpNew   := ""
   DEFAULT aImportacion := aImportacion():False()

   if IsDirectory( cPath )
      EraseFilesInDirectory( cPath )
   end if

   /*
   Dialogo para mostrar nueva empresa------------------------------------------
   */

   if lDialog

      DEFINE DIALOG oDlgWat NAME "CreaEmp" TITLE "Creando empresa : " + cCodEmpNew + " - " + Rtrim( cNomEmpNew )

         REDEFINE BITMAP oBmp ;
            RESOURCE "gc_factory_48" ;
            TRANSPARENT ;
            ID       500 ;
            OF       oDlgWat

         TAnimat():Redefine( oDlgWat, 100, acImages, 1 )

         REDEFINE SAY oMsg PROMPT cMsg ;
            ID       110 ;
            OF       oDlgWat

         oDlgWat:bStart := {|| StartPathEmp( cPath, cPathOld, cCodEmpNew, cNomEmpNew, cCodEmpOld, aImportacion, lDialog, lNewEmp, nGetSemilla, oMsg ), lEnd := .t., oDlgWat:End() }

      ACTIVATE DIALOG oDlgWat CENTER VALID ( lEnd )

      oBmp:End()

   else

      StartPathEmp( cPath, cPathOld, cCodEmpNew, cNomEmpNew, cCodEmpOld, aImportacion, lDialog, lNewEmp, nGetSemilla, oMsg )

   end if

   sysrefresh()

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function StartPathEmp( cPath, cPathOld, cCodEmpNew, cNomEmpNew, cCodEmpOld, aImportacion, lDialog, lNewEmp, nGetSemilla, oMsg )

   local oError
   local oBlock
   local cCodGrp        := Space( 4 )
   local cPathGrp       := ""
   local lAIS           := lAIS()

//   if lAIS()
//      msgStop( "Esta opción no esta permitida para motor de bases de datos ADS.")
//      Return ( nil )
//   end if

   // oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   // BEGIN SEQUENCE

   if lAIS
      setIndexToCDX()
   end if

   dbCloseAll()

   sysrefresh()

   if lChDir( cNamePath( cPath ) ) .or. makeDir( cNamePath( cPath ) ) != -1

      if cCodEmpOld != nil
         cCodGrp        := cCodigoGrupo( cCodEmpOld )
      end if

      if !Empty( cCodGrp )
         cPathGrp       := cPatStk( cCodGrp, , , .t. )
      else
         cPathGrp       := cPathOld
      end if

      /*
      Contadores---------------------------------------------------------------
      */

      if oMsg != nil
         oMsg:SetText( "Creando contadores" )
      end if
      mkCount( cPath ); synCount( cPath, nGetSemilla ); sysrefresh()

		/*
      Ficheros Maestros--------------------------------------------------------
		*/

      if oMsg != nil
         oMsg:SetText( "Creando familias" )
      end if
      mkFamilia( cPath, aImportacion:lArticulos, cPathGrp ) ; rxFamilia( cPath ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando Estados de los SAT" )
      end if
      mkEstadoSat( cPath, aImportacion:lSatCli, cPathGrp ); rxEstadoSat( cPath )   ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando " + getConfigTraslation( "temporadas" ) )
      end if
      mkTemporada( cPath, aImportacion:lArticulos, cPathGrp ); rxTemporada( cPath )   ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando grupos de familias" )
      end if
      if cPathOld != nil
         TGrpFam():Create( cPath ):CheckFiles( cPathGrp + "GrpFam.Dbf" )   ; sysrefresh()
      else
         TGrpFam():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando comandas" )
      end if
      if cPathOld != nil
         TComandas():Create( cPath ):CheckFiles( cPathGrp + "TComandas.Dbf" ); sysrefresh()
      else
         TComandas():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando fabricantes" )
      end if
      if cPathOld != nil
         TFabricantes():Create( cPath ):CheckFiles( cPathGrp + "Fabricantes.Dbf" )  ; sysrefresh()
      else
         TFabricantes():Create( cPath ):CheckFiles()                                ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando movimientos de almacén" )
      end if
      TRemMovAlm():Create( cPath ):CheckFiles()                                     ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando lineas de movimientos de almacén" )
      end if
      TDetMovimientos():Create( cPath ):CheckFiles()                                ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando campos extras" )
      end if
      TCamposExtra():Create( cPath ):CheckFiles()                                     ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando lineas de campos extras" )
      end if
      TDetCamposExtra():Create( cPath ):CheckFiles()                                     ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando catálogos" )
      end if
      if cPathOld != nil
         TCatalogo():Create( cPath ):CheckFiles( cPathGrp + "Catalogo.Dbf" )  ; sysrefresh()
      else
         TCatalogo():Create( cPath ):CheckFiles()                             ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando unidades de medición" )
      end if

      if cPathOld != nil
         UniMedicion():Create( cPath ):CheckFiles( cPathGrp + "UndMed.Dbf" ) ; sysrefresh()
      else
         UniMedicion():Create( cPath ):CheckFiles() ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando propiedades" )
      end if
      mkPro( cPath, aImportacion:lArticulos, cPathGrp ); rxPro( cPath ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando tarifas" )
      end if
      mkTarifa(   cPath, nil, aImportacion:lArticulos, cPathOld )       ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando promociones" )
      end if
      mkPromo(    cPath, aImportacion:lPromocion, cPathOld )            ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando articulos" )
      end if
      mkArticulo( cPath, aImportacion:lArticulos, cPathGrp, nil, .f. )  ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando grupos de venta" )
      end if
      mkGrpVenta( cPath, aImportacion:lArticulos, cPathOld )            ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando clientes" )
      end if
      mkClient( cPath, aImportacion:lClientes, cPathGrp )             ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando proveedores" )
      end if
      mkProvee( cPath, aImportacion:lProveedor, cPathGrp )            ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando agentes" )
      end if
      mkAgentes( cPath, aImportacion:lAgente, cPathGrp, nil )          ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando rutas" )
      end if
      mkRuta( cPath, aImportacion:lRuta, cPathGrp, nil )            ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando almacén" )
      end if
      mkAlmacen( cPath, aImportacion:lAlmacen, cPathGrp, nil ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando ubicaciones" )
      end if
      mkUbi( cPath, aImportacion:lAlmacen, cPathGrp, nil ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando ofertas" )
      end if
      mkOferta( cPath, aImportacion:lOferta, cPathGrp ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando tpv" )
      end if
      mkTpv( cPath, aImportacion:lVale, cPathOld ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando menus tpv" )
      end if

      if cPathOld != nil
         TPVMenu():Create( cPath ):CheckFiles( cPathGrp + "TpvMenus.Dbf" ) ; sysrefresh()
      else
         TPVMenu():Create( cPath ):CheckFiles() ; sysrefresh()
      end if

      if cPathOld != nil
         TPVMenuArticulo():Create( cPath ):CheckFiles( cPathGrp + "TpvMnuArt.Dbf" ) ; sysrefresh()
      else
         TPVMenuArticulo():Create( cPath ):CheckFiles()                             ; sysrefresh()
      end if

      if cPathOld != nil
         TPVMenuOrdenes():Create( cPath ):CheckFiles( cPathGrp + "TpvMnuOrd.Dbf" )  ; sysrefresh()
      else
         TPVMenuOrdenes():Create( cPath ):CheckFiles()                              ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando forma de pago" )
      end if
      mkFPago( cPath, aImportacion:lFPago, cPathGrp )                ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando entrada y salidas" )
      end if
      mkEntSal( cPath )                                               ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando bancos" )
      end if
      if cPathOld != nil .and. aImportacion:lBancos
         TBancos():Create( cPath ):CheckFiles( cPathOld + "Bancos.Dbf" )
      else
         TBancos():Create( cPath ):CheckFiles()
      end if

      if cPathOld != nil .and. aImportacion:lBancos
         TCuentasBancarias():Create( cPath ):CheckFiles( cPathOld + "EmpBnc.Dbf" )
      else
         TCuentasBancarias():Create( cPath ):CheckFiles()
      end if

      if cPathOld != nil .and. aImportacion:lScript
         TScripts():Create( cPath ):CheckFiles( cPathOld + "Scripts.Dbf" )
      else
         TScripts():Create( cPath ):CheckFiles()
      end if

      if cPathOld != nil .and. aImportacion:lEntidades
         TEntidades():Create( cPath ):CheckFiles( cPathOld + "Entidades.Dbf" )
      else
         TEntidades():Create( cPath ):CheckFiles()
      end if

      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando impuesto de hidrocarburos" )
      end if
      TNewImp():Create( cPath ):CheckFiles()                            ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando sesiones" )
      end if
      TTurno():Create( cPath ):CheckFiles()                             ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando tipos de articulos" )
      end if

      if cPathOld != nil .and. aImportacion:lArticulos
         TTipArt():Create( cPath ):CheckFiles( cPathOld + "TipArt.Dbf" )   ; sysrefresh()
      else
         TTipArt():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando proyectos" )
      end if

      if oMsg != nil
         oMsg:SetText( "Creando atípicas de clientes y grupos" )
      end if

      if cPathOld != nil .and. aImportacion:lArticulos
         TAtipicas():Create( cPath ):CheckFiles( cPathOld + "CliAtp.Dbf" ) ; sysrefresh()
      else
         TAtipicas():Create( cPath ):CheckFiles()                          ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando grupos de clientes" )
      end if

      if cPathOld != nil .and. aImportacion:lClientes
         TGrpCli():Create( cPath ):CheckFiles( cPathOld + "GrpCli.Dbf" )   ; sysrefresh()
      else
         TGrpCli():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando grupos de facturas automáticas" )
      end if

      if cPathOld != nil .and. aImportacion:lClientes
         TGrpFacturasAutomaticas():Create( cPath ):CheckFiles( cPathOld + "GrpFac.Dbf" )   ; sysrefresh()
      else
         TGrpFacturasAutomaticas():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando transportistas" )
      end if

      if cPathOld != nil .and. aImportacion:lClientes
         TTrans():Create( cPath ):CheckFiles( cPathOld + "Transpor.Dbf" )  ; sysrefresh()
      else
         TTrans():Create( cPath ):CheckFiles()                             ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando grupos de proveedores" )
      end if

      if cPathOld != nil .and. aImportacion:lProveedor
         TGrpPrv():Create( cPath ):CheckFiles( cPathOld + "GrpPrv.Dbf" )   ; sysrefresh()
      else
         TGrpPrv():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando cuentas de remesas" )
      end if

      if cPathOld != nil
         TCtaRem():Create( cPath ):CheckFiles( cPathOld + "CtaRem.Dbf" )   ; sysrefresh()
      else
         TCtaRem():Create( cPath ):CheckFiles()                            ; sysrefresh()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando salas y puntos de ventas" )
      end if

      if cPathOld != nil
         TTpvRestaurante():Create( cPath ):CheckFiles( cPathOld + "SalaVta.Dbf" )     ; sysrefresh()
         TDetSalaVta():Create( cPath ):CheckFiles( cPathOld + "SlaPnt.Dbf" )     ; sysrefresh()
      else
         TTpvRestaurante():Create( cPath ):CheckFiles()                               ; sysrefresh()
         TDetSalaVta():Create( cPath ):CheckFiles()                              ; sysrefresh()
      end if

      /*
      Documentos de proveedores------------------------------------------------
		*/

      if oMsg != nil
         oMsg:SetText( "Creando pedido a proveedores" )
      end if
      mkPedPrv( cPath, aImportacion:lAlbPrv, cPathOld, nil, {| dbf | ( dbf )->nEstado != 3 } ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando albaran a proveedores" )
      end if
      mkAlbPrv( cPath, aImportacion:lAlbPrv, cPathOld, nil, {| dbf | !( dbf )->nFacturado != 3 } ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando factura a proveedores" )
      end if
      mkFacPrv( cPath, nil ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando facturas rectificativas a proveedores" )
      end if
      mkRctPrv( cPath, nil ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando recibos a proveedores" )
      end if
      mkRecPrv( cPath, nil ) ; sysrefresh()

		/*
      Documentos de clientes---------------------------------------------------
		*/

      if oMsg != nil
         oMsg:SetText( "Creando presupuesto a clientes" )
      end if
      mkPreCli( cPath, aImportacion:lPreCli, cPathOld, nil, {| dbf | !( dbf )->lEstado } ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando S.A.T. a clientes" )
      end if
      mkSatCli( cPath, aImportacion:lSatCli, cPathOld, nil, {| dbf | !( dbf )->lEstado } ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando pedidos a clientes" )
      end if
      mkPedCli( cPath, aImportacion:lPedCli, cPathOld, nil, {| dbf | ( dbf )->nEstado != 3 } ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando albaranes a clientes" )
      end if
      mkAlbCli( cPath, aImportacion:lAlbCli, cPathOld, nil, {| dbf | !lFacturado( dbf ) } ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando facturas a clientes" )
      end if
      mkFacCli( cPath ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando facturas rectificativas a clientes" )
      end if
      mkFacRec( cPath ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando recibos a clientes" )
      end if
      mkRecCli( cPath ) ; sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando facturas de anticipos a clientes" )
      end if
      mkAntCli( cPath, aImportacion:lAnticipo, cPathOld )
      sysrefresh()

      /*
      Tablas de producción----------------------------------------------
		*/

      if oMsg != nil
         oMsg:SetText( "Creando secciones de producción" )
      end if

      if cPathOld != nil
         TSeccion():Create( cPath ):CheckFiles( cPathOld + "Seccion.Dbf" )
      else
         TSeccion():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando horas de producción" )
      end if

      if cPathOld != nil
         THoras():Create( cPath ):CheckFiles( cPathOld + "Horas.Dbf" )
      else
         THoras():Create( cPath ):CheckFiles()
      end if

      if oMsg != nil
         oMsg:SetText( "Creando detalle de horas de producción" )
      end if

      if cPathOld != nil
         TDetHoras():Create( cPath ):CheckFiles( cPathOld + "OpeL.Dbf" )
      else
         TDetHoras():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando operarios de producción" )
      end if

      if cPathOld != nil
         TOperarios():Create( cPath ):CheckFiles( cPathOld + "OpeT.Dbf" )
      else
         TOperarios():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando operaciones de producción" )
      end if

      if cPathOld != nil
         TOperacion():Create( cPath ):CheckFiles( cPathOld + "Operacio.Dbf" )
      else
         TOperacion():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando tipos de operaciones de producción" )
      end if

      if cPathOld != nil
         TTipOpera():Create( cPath ):CheckFiles( cPathOld + "TipOpera.Dbf" )
      else
         TTipOpera():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando maquinarias de producción" )
      end if

      if cPathOld != nil
         TMaquina():Create( cPath ):CheckFiles( cPathOld + "MaqCosT.Dbf" )
      else
         TMaquina():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando costos de maquinarias de producción" )
      end if

      if cPathOld != nil
         TCosMaq():Create( cPath ):CheckFiles( cPathOld + "Costes.Dbf" )
      else
         TCosMaq():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if cPathOld != nil
         TFideliza():Create( cPath ):CheckFiles( cPathOld + "Fideliza.Dbf" )
      else
         TFideliza():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if cPathOld != nil
         TDetFideliza():Create( cPath ):CheckFiles( cPathOld + "DetFideliza.Dbf" )
      else
         TDetFideliza():Create( cPath ):CheckFiles()
      end if
      sysrefresh()

      if oMsg != nil
         oMsg:SetText( "Creando identificadores de prestashop" )
      end if

      TPrestaShopId():Create( cPath ):CheckFiles()
      sysrefresh()

      // Columnas de usuario---------------------------------------------------

      if oMsg != nil
         oMsg:SetText( "Creando columnas de usuarios" )
      end if

      if cPathOld != nil
         TShell():AppendData( cPath, cPathOld )
      else
         TShell():ReindexData( cPath )
      end if

      // Favoritos de informes-------------------------------------------------

      if oMsg != nil
         oMsg:SetText( "Creando favoritos de informes" )
      end if

      if cPathOld != nil
         mkReport( cPath, .t., cPathOld )
      else
         mkReport( cPath )
      end if

      /*
      Documentos---------------------------------------------------------------
      */

      if oMsg != nil
         oMsg:SetText( "Creando documentos" )
      end if

      mkDocs( cPath, aImportacion:lDocument, cPathOld ) ; sysrefresh()

      /*
      Cerramos todas las tablas------------------------------------------------
      */

      dbDialog()

      /*
      Calculo de stocks--------------------------------------------------------
      */

      if oMsg != nil
         oMsg:SetText( "Creando stocks" )
      end if

      if aImportacion:lStockIni .and. cPathOld != nil
         TStock():StockInit( cPath, cPathOld, oMsg, aImportacion:nCosto )
      end if

      /*
      Si hay nueva empresa calculamos stocks y regeneramos indices-------------
      */

      dbDialog()

      if lNewEmp
         reindexaEmp( cPath, cCodEmpNew, oMsg )
      end if

   else

      MsgStop( "Imposible crear el directorio " + cPath )

   end if

//   RECOVER USING oError
//
//      msgStop( "Error creando estructura de directorios" + CRLF + ErrorMessage( oError ) )
//
//   END SEQUENCE
//
//   ErrorBlock( oBlock )

   /*
   Tipo de driver q usamos--------------------------------------------------
   */

   if lAIS

      msgStop( "Tenemos q meter esta empresa en el diccionario de datos")

      with object ( TDataCenter() )
         :CreateEmpresaTable()
         :BuildEmpresa()     
      end with

      SetIndexToADSCDX()

      msgStop( "Proceso finalizado")

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function ReindexaEmp( cPath, cCodigoEmpresa, oMsg )

   with object ( TReindex():New( nil, nil, cPath ) )
      :lEmpresa      := .f.
      :lDatos        := .f.
      :lMessageEnd   := .f.
      :cCodEmp       := cCodigoEmpresa
      :cPatCli       := cPatCli( cCodigoEmpresa, .f., .t. )
      :cPatArt       := cPatArt( cCodigoEmpresa, .f., .t. )
      :cPatPrv       := cPatPrv( cCodigoEmpresa, .f., .t. )
      :cPatAlm       := cPatAlm( cCodigoEmpresa, .f., .t. )
      :GenIndices( oMsg )
   end with

Return .t.

//---------------------------------------------------------------------------//
/*
Cambia los datos de una empresa a las nuevas estructuras
*/

FUNCTION lActualiza( cCodEmp, oWndBrw, lNoWait, cNomEmp, lSincroniza )

   local oBmp
   local oAni
   local oAct
   local oMsg
   local oDlgWat
   local hBmp           := LoadBitmap( GetResources(), "BSTOP" )
   local cMsg           := ""
   local aMsg           := {}
   local acImages       := { "BAR_01" }
   local oBtnAceptar
   local oBtnCancelar

   DEFAULT lNoWait      := .f.
   DEFAULT lSincroniza  := .t.

   if nUsrInUse() > 1
      msgStop( "Hay más de un usuario conectado a la aplicación", "Atención" )
      return .f.
   end if

   if !TReindex():lFreeHandle()
      msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicación" + CRLF + ;
               "en estos momentos, reintentelo pasados unos segundos." )
      return .f.
   end if

   if !TReindex():lCreateHandle()
      msgStop( "Esta opción ya ha sido inicada por otro usuario", "Atención" )
      return .f.
   end if

   if lNoWait
      lActEmp           := .t.
   end if

   if oWndBrw != nil
      oWndBrw:End( .t. )
   end if

   DEFINE DIALOG oDlgWat NAME "ACTEMPRESA" TITLE "Actualizando empresa : " + AllTrim( cCodEmp ) + " - " + AllTrim( cNomEmp )

      REDEFINE BITMAP oBmp;
         RESOURCE "gc_factory_48" ;
         TRANSPARENT ;
         ID       500 ;
         OF       oDlgWat

      oAni        := TAnimat():Redefine( oDlgWat, 100, acImages, 1 )

      REDEFINE SAY oMsg PROMPT cMsg ;
         ID       110 ;
         OF       oDlgWat

      REDEFINE CHECKBOX oAct VAR lActEmp ;
         ID       120 ;
         OF       oDlgWat

      REDEFINE BUTTON oBtnAceptar ;
         ID       IDOK ;
         OF       oDlgWat ;
         ACTION   ( ActualizaEmpresa( cCodEmp, aMsg, oAni, oBtnAceptar, oBtnCancelar, oDlgWat, oMsg, oAct, lActEmp, lSincroniza ) )

      REDEFINE BUTTON oBtnCancelar ;
         ID       IDCANCEL ;
         OF       oDlgWat ;
         ACTION   ( oDlgWat:End() ) ;

      oDlgWat:AddFastKey( VK_F5, {|| Eval( oBtnAceptar:bAction ) } )

      if lNoWait
         oDlgWat:bStart := oBtnAceptar:bAction
      else
         oDlgWat:bStart := {|| oAni:Hide() }
      end if

   ACTIVATE DIALOG oDlgWat CENTER

   TReindex():lCloseHandle()

   oAni:End()
   oBmp:End()

   DeleteObject( hBmp )

RETURN ( oDlgWat:nResult == IDOK )

//--------------------------------------------------------------------------//

Static Function ActualizaEmpresa( cCodEmp, aMsg, oAni, oBtnAceptar, oBtnCancelar, oDlg, oMsg, oAct, lActEmp, lSincroniza )

   oDlg:bValid          := {|| .f. }

   oAct:Disable()
   oBtnAceptar:Hide()
   oBtnCancelar:Hide()

   if lAIS()
      TDataCenter():ActualizaEmpresa( oMsg )
   else 
      ActDbfEmp( cCodEmp, aMsg, oAni, oDlg, oMsg, nil, lActEmp, lSincroniza )
   end if 

   oDlg:bValid          := {|| .t. }

   oDlg:End( IDOK )

Return nil

//---------------------------------------------------------------------------//

Static Function ActDbfEmp( cCodEmp, aMsg, oAni, oDlg, oMsg, oMet, lActEmp, lSincroniza )

   local oBlock
   local oError
   local cEmpDat  := cPatDat()
   local cEmpTmp  := cPatEmpTmp()
   local cEmpOld  := cPatEmpOld( cCodEmp )

   oAni:Show()

   oMsg:SetText( "Generando nueva estructura" )

   /*
   Cerramos todas las tablas---------------------------------------------------
   */

   dbCloseAll()

   aEval( Directory( cEmpTmp + "*.*" ), {| aFiles | fErase( cEmpTmp + aFiles[ 1 ] ) } )

   if mkPathEmp( "Tmp", nil, nil, aImportacion():False(), .f., .f., nil, oMsg )

      /*
      CloseFiles()-------------------------------------------------------------
      */

      oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         /*
         Fichero del subdirectorio datos---------------------------------------
         */

         if mkUsuario( cEmpTmp, , .f. )
            ActDbf( cEmpDat, cEmpTmp, "Users", "usuarios", oMet, oMsg, aMsg )
            ActDbf( cEmpDat, cEmpTmp, "Mapas", "mapas", oMet, oMsg, aMsg )
         end if

         if mkDiv( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "Divisas", "divisas monetarias", oMet, oMsg, aMsg )
         end if

         if mkTiva( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "Tiva", "tipos de impuestos", oMet, oMsg, aMsg )
         end if

         oMsg:SetText( "Añadiendo filtros" )
            TFilterDatabase():Create():SyncAllDbf() 

         if mkCajas( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "Cajas", "cajas", oMet, oMsg, aMsg )
            ActDbf( cEmpDat, cEmpTmp, "CajasL", "impresoras de comanda", oMet, oMsg, aMsg )
         end if

         if mkImpTik( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "ImpTik", "impresora de tikets", oMet, oMsg, aMsg )
         end if

         if mkVisor( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "Visor", "visor", oMet, oMsg, aMsg )
         end if

         if mkCajPorta( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "CajPorta", "cajón portamonedas", oMet, oMsg, aMsg )
         end if

         if mkLogPorta( cEmpTmp )
            ActDbf( cEmpOld, cEmpTmp, "LogPorta", "log cajón portamonedas", oMet, oMsg, aMsg )
         end if

         if mkReport( cEmpTmp, .f. )
            ActDbf( cEmpOld, cEmpTmp, "CfgCar", "Añadiendo datos de documentos", oMet, oMsg, aMsg )
         end if

         /*
         Ficheros del subdirectorio empresa------------------------------------
         */

         ActDbf( cEmpOld, cEmpTmp, "FPago",     "formas de pago", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Familias",  "familias", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FamPrv",    "familias de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FamLeng",   "familias lenguajes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Categorias","categorías", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Temporadas","temporadas", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "EstadoSat","estado de los SAT", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Pro",       "propiedades", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TblPro",    "tabla de propiedades", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "RDocumen",  "documentos", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RItems",    "items de documentos", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RColum",    "columnas de documentos", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RBitmap",   "bitmaps de documentos", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RBox",      "cajas de documentos", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "ObrasT",    "obras", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "TarPreT",   "tarifas de precios", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TarPreL",   "tarifas de precios", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TarPreS",   "tarifas de precios", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "PromoT",    "promociones", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PromoL",    "promociones", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Articulo",  "artículos", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "ArtCodebar","códigos de barras", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ArtDiv",    "precios por ventas propiedades", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ArtKit",    "artículos kits", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ArtLbl",    "artículos relación de codigos de barras", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ArtImg",    "artículos relación de imagenes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ProvArt",   "artículos por proveedor", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ArtAlm",    "stock por almacenes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "HisMov",    "historicos de movimientos", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Client",    "clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ClientD",   "documentos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "CliAtp",    "atipicas de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "CliBnc",    "bancos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "CliInc",    "incidencias de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "CliCto",    "contactos de clientes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Provee",    "proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ProveeD",   "documentos de proveedor", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PrvBnc",    "bancos de proveedores", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Agentes",   "agentes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Ruta",      "rutas", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Almacen",   "almacen", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "EntSal",    "entradas y salidas de caja", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "TikeT",     "tickets", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TikeL",     "líneas de tickets", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TikeP",     "pagos de tickets", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TikeC",     "pagos de clientes tickets", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "TikeS",     "series de tickets", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "Oferta",    "ofertas", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "PedProvT",  "pedidos a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedProvL",  "líneas de pedidos a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedPrvI",   "incidencias de pedidos a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedPrvD",   "documentos de pedidos a proveedores", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "AlbProvT",  "albaran de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbProvL",  "líneas de albarán a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbPrvI",   "incidencias de albaranes a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbPrvD",   "documentos de albaranes a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbPrvS",   "números de serie de albaranes a proveedores", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "FacPrvT",   "facturas de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacPrvL",   "líneas de facturas de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacPrvP",   "pagos de facturas de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacPrvI",   "incidencias de facturas a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacPrvD",   "documentos de facturas a proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacPrvS",   "números de serie de facturas a proveedores", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "RctPrvT",   "facturas rectificativas de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RctPrvL",   "líneas de facturas rectificativas de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RctPrvI",   "incidencias de facturas rectificativas de proveedores", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "RctPrvS",   "números de serie de facturas rectificativas a proveedores", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "DepAgeT",   "depositos a almacenes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "DepAgeL",   "líneas de depositos a almacenes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "ExtAgeT",   "existencias a almacenes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "ExtAgeL",   "líneas de existencias a almacenes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "SatCliT",   "S.A.T. a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "SatCliL",   "líneas de S.A.T. a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "SatCliI",   "incidencias de S.A.T. a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "SatCliD",   "documentos de S.A.T. a clientes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "PreCliT",   "presupuestos a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PreCliL",   "líneas de presupuestos a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PreCliI",   "incidencias de presupuestos a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PreCliD",   "documentos de presupuestos a clientes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "PedCliT",   getConfigTraslation("Pedidos de clientes"), oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedCliL",   "líneas de pedidos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedCliR",   "reservas de pedidos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedCliI",   "incidencias de pedidos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedCliD",   "documentos de pedidos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedCliP",   "entregas a cuenta de pedidos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "PedCliE",   "situaciones de pedido de cliente", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "AlbCliT",   "albaranes de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbCliL",   "líneas de albaranes de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbCliI",   "incidencias de albaranes a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbCliD",   "documentos de albaranes a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbCliP",   "entregas a cuenta de albaranes a clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AlbCliS",   "números de series de albaranes a clientes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "FacCliT",   "facturas de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacCliL",   "líneas de facturas de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacCliP",   "pagos de facturas de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacCliI",   "incidencias de facturas de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacCliD",   "documentos de facturas de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacCliS",   "series de facturas de clientes", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "FacRecT",   "facturas rectificativas", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacRecL",   "líneas de facturas rectificativas", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacRecI",   "incidencias de facturas rectificativas", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacRecD",   "documentos de facturas rectificativas", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "FacRecS",   "series de facturas rectificativas", oMet, oMsg, aMsg )

         ActDbf( cEmpOld, cEmpTmp, "AntCliT",   "anticipos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AntCliI",   "anticipos de clientes", oMet, oMsg, aMsg )
         ActDbf( cEmpOld, cEmpTmp, "AntCliD",   "documentos de anticipos de clientes", oMet, oMsg, aMsg )

         /*
         if mkSitua( cEmpTmp )
            ActDbf( cEmpDat, cEmpTmp, "Situa", "situaciones", oMet, oMsg, aMsg )
         end if
         */

         oMsg:SetText( "País" )
         TPais():Create( cPatDat() ):SyncAllDbf()

         oMsg:SetText( "Lenguaje" )
         TLenguaje():Create( cPatDat() ):SyncAllDbf()

         oMsg:SetText( "Centro de coste" )
         TCentroCoste():Create( cPatDat() ):SyncAllDbf()

         oMsg:SetText( "Unidades de medición" )
         UniMedicion():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo bancos" )
         TBancos():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo cuentas bancarias" )
         TCuentasBancarias():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo backup" )
         TBackup():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo envios y recepciones" )
         TSndRecInf():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo frases publicitarias" )
         TFrasesPublicitarias():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo datos de documentos" )
         TInfGen():SyncAllDbf()

         oMsg:SetText( "Añadiendo grupos de familias" )
         TGrpFam():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo fabricante" )
         TFabricantes():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo tipos de comandas" )
         TComandas():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo movimientos de almacén" )
         TRemMovAlm():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo campos extra" )
         TCamposExtra():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo detalles de campos extra" )
         TDetCamposExtra():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo notas" )
         TNotas():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo agenda" )
         TAgenda():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo sala de ventas" )
         TSalaVenta():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo ubicaciones de sala de ventas" )
         TDetSalaVta():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo plantillas de ventas automáticas" )
         TFacAutomatica():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de plantillas de ventas automáticas" )
         TDetFacAutomatica():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo histórico de plantillas de ventas automáticas" )
         THisFacAutomatica():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo invitaciones" )
         TInvitacion():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo partes de producción" )
         TProduccion():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo expedientes" )
         TExpediente():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo ordenes de carga" )
         TOrdCarga():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas ordenes de carga" )
         TDetOrdCar():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo tipos de artículos" )
         TTipArt():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo catálogos de artículos" )
         TCatalogo():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo grupos de clientes" )
         TGrpCli():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo grupos de proveedores" )
         TGrpPrv():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo nuevos impuestos" )
         TNewImp():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo transportistas" )
         TTrans():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo turnos" )
         TTurno():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo cuentas de remesas" )
         TCtaRem():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo remesas" )
         TRemesas():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo secciones" )
         TSeccion():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo tipos de horas" )
         THoras():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo operarios" )
         TOperarios():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo horas de operarios" )
         TDetHoras():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo operaciones" )
         TOperacion():Create():SyncAllDbf()

         oMsg:SetText( "Tipos de operación" )
         TTipOpera():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo costes maquinaria" )
         TCosMaq():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo máquina" )
         TMaquina():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo detalle máquinas" )
         TDetCostes():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de partes de producción" )
         TDetProduccion():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo series de partes de producción" )
         TDetSeriesProduccion():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de personal" )
         TDetPersonal():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de horas de personal" )
         TDetHorasPersonal():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de materias primas" )
         TDetMaterial():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo series de materiales de producción" )
         TDetSeriesMaterial():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo lineas de movimientos de almacén" )
         TDetMovimientos():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo series de movimientos de almacén" )
         TDetSeriesMovimientos():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de maquinaria" )
         TDetMaquina():New():SyncAllDbf()

         oMsg:SetText( "Añadiendo tipos de expedientes" )
         TTipoExpediente():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo subtipos de expediente" )
         TDetTipoExpediente():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo entidades" )
         TEntidades():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo colaboradores" )
         TColaboradores():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo actuaciones" )
         TActuaciones():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo expedientes" )
         TExpediente():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo actuaciones de expedientes" )
         TDetActuacion():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo comentarios" )
         TComentarios():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo detalles de comentarios" )
         TDetComentarios():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo ordenes de comandas" )
         TOrdenComanda():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo programas de fidelización" )
         TFideliza():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo detalles de programas de fidelización" )
         TDetFideliza():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo capturas" )
         TCaptura():Create( cPatDat() ):SyncAllDbf()

         oMsg:SetText( "Añadiendo detalles de capturas" )
         TDetCaptura():Create( cPatDat() ):SyncAllDbf()

         oMsg:SetText( "Añadiendo plantillas XML" )
         TPlantillaXml():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo detalles de plantillas XML" )
         TDetCabeceraPlantillaXML():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo liquidaciones de agentes" )
         TCobAge():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo líneas de liquidaciones de agentes" )
         TDetCobAge():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo reporting" )
         TFastReportInfGen():SyncAllDbf()

         oMsg:SetText( "Añadiendo scripts" )
         TScripts():Create():SyncAllDbf()

         oMsg:SetText( "Añadiendo envios y recepciones de internet" )
         TSndRecInf():SyncAllDbf()

         oMsg:SetText( "Menús" )
         TpvMenu():Create():SyncAllDbf()

         oMsg:SetText( "Ordenes de menús" )
         TpvMenuOrdenes():Create():SyncAllDbf()

         oMsg:SetText( "Articulos de menú" )
         TPVMenuArticulo():Create():SyncAllDbf()

         oMsg:SetText( "Identificadores de prestashop" )
         TPrestaShopId():Create():SyncAllDbf()

      RECOVER USING oError

         msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      END SEQUENCE

      ErrorBlock( oBlock )

      /*
      Eliminamos las classes---------------------------------------------------
      */

      InitDbClass()

      /*
      Regeneramos indices------------------------------------------------------
      */

      with object ( TReindex():New() )
         :lSincroniza   := lSincroniza
         :lMessageEnd   := .f.
         :GenIndices( oMsg )
      end with

   end if

   /*
   Borramos los datos del directorio temporal----------------------------------
   */

   aEval( Directory( cEmpTmp + "*.*" ), {|aFiles| fErase( cEmpTmp + aFiles[ 1 ] ) } )

   oAni:Hide()

RETURN .t.

//---------------------------------------------------------------------------//

Static Function cGetInfo( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C"
           return uVal

      case cType == "O"
           return "Class: " + uVal:ClassName()

      case cType == "A"
           return "Len: " + Str( Len( uVal ), 4 )

      otherwise
           return cValToChar( uVal )
   endcase

return nil

//---------------------------------------------------------------------------//

static function IsChgStru( dbfOld, dbfNew )

   local i
   local lChg     := .f.
   local cCharOld
   local cCharNew
   local aStruOld := ( dbfOld )->( dbStruct() )
   local aStruNew := ( dbfNew )->( dbStruct() )

   if len( aStruOld ) != len( aStruNew )
      lChg        := .t.
   else
      for i := 1 to len( aStruNew )
         cCharOld := aStruOld[ i, 1 ] + aStruOld[ i, 2 ] + str( aStruOld[ i, 3 ], 3 ) + str( aStruOld[ i, 4 ], 2 )
         cCharNew := aStruNew[ i, 1 ] + aStruNew[ i, 2 ] + str( aStruNew[ i, 3 ], 3 ) + str( aStruNew[ i, 4 ], 2 )
         if cCharOld != cCharNew
            lChg  := .t.
            exit
         endif
      next
   endif

return lChg

//---------------------------------------------------------------------------//

Static Function BeginEdtRec( aTmp )

   local oBlock
   local oError
   local lErrors  := .f.
   local cCodEmp  := aTmp[ _CODEMP ]

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Delegaciones----------------------------------------------------------------
	*/

   cNewDlg        := cGetNewFileName( cPatTmp() + "Dlg"  )

   dbCreate( cNewDlg, aSqlStruct( aItmDlg() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cNewDlg, cCheckArea( "Dlg", @tmpDlg ), .f. )

   if !NetErr() .and. ( tmpDlg )->( Used() )

      ( tmpDlg )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( tmpDlg )->( ordCreate( cNewDlg, "Recno", "Recno()", {|| Recno() } ) )

   else

      lErrors     := .t.

   end if

	/*
   Añadimos a los temporales---------------------------------------------------
	*/

   if !lErrors

      if ( dbfDlg )->( dbSeek( cCodEmp ) )
         while ( dbfDlg )->cCodEmp == cCodEmp .and. !( dbfDlg )->( eof() )
            dbPass( dbfDlg, tmpDlg, .t. )
            ( dbfDlg )->( dbSkip() )
         end while
      end if

      ( tmpDlg )->( dbGoTop() )

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear tablas temporales." )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//---------------------------------------------------------------------------//

Static Function BeginEditConfig( aTmp )

   local oBlock
   local oError
   local lErrors  := .f.
   local cCodEmp  := aTmp[ _CODEMP ]

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   /*
   Contadores------------------------------------------------------------------
	*/

   cTmpCon        := cGetNewFileName( cPatTmp() + "CON" )

   dbCreate( cTmpCon, aSqlStruct( aItmCount() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpCon, cCheckArea( "CON", @tmpCount ), .f. )

   if !NetErr() .and. ( tmpCount )->( Used() )

      ( tmpCount )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpCount )->( ordCreate( cTmpCon, "Doc", "Upper( Doc )", {|| Upper( Field->Doc ) } ) )

      ( tmpCount )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( tmpCount )->( ordCreate( cTmpCon, "Des", "Upper( Des )", {|| Upper( Field->Des ) } ) )

   else

      lErrors     := .t.

   end if

	/*
   Añadimos a los temporales---------------------------------------------------
	*/

   if !lErrors

      ( dbfCount )->( dbGoTop() )
      while !( dbfCount )->( eof() )
         dbPass( dbfCount, tmpCount, .t. )
         ( dbfCount )->( dbSkip() )
      end while

      ( tmpCount )->( dbGoTop() )

   end if

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible crear tablas temporales." )

      KillTrans()

      lErrors     := .t.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lErrors )

//---------------------------------------------------------------------------//

Static Function PrvTrans( oFld, oBtnOk )

   if oFld:nOption > 1
      oFld:SetOption( oFld:nOption - 1 )
   end if

   if oFld:nOption != 3
      SetWindowText( oBtnOk:hWnd, "&Siguiente >" )
   end if

Return nil

//---------------------------------------------------------------------------//

/*
Comprueba los cambios de estructura y añade registros
*/

FUNCTION ActDbf( cEmpOld, cEmpTmp, cFile, cText, oMtr, oMsg )

   local i
   local cField 
   local dbfOld
   local dbfTmp
   local dbfNamOld            := cEmpOld + cFile
   local dbfNamTmp            := cEmpTmp + cFile
   local lCopy                := .f.
   local nField               := 0
   local aField

   sysrefresh()

   if oMsg != nil
      oMsg:SetText( "Añadiendo " + cText )
   end if

   if !lExistTable( dbfNamOld + ".Dbf" )
      return .f.
   end if

   if !lExistTable( dbfNamTmp + ".Dbf" )
      return .f.
   end if

   USE ( dbfNamOld + ".Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "OLD", @dbfOld ) )
   if NetErr()
      msgStop( "Error al abrir el fichero " + ( dbfNamOld ) + ".Dbf" )
      return .f.
   end if

   USE ( dbfNamTmp + ".Dbf" ) NEW VIA ( cLocalDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "TMP", @dbfTmp ) )
   if NetErr()
      msgStop( "Error al abrir el fichero " + ( dbfNamTmp ) + ".Dbf" )
      return .f.
   end if

   // Numero de campos------------------------------------------------------------

   nField                     := ( dbfTmp )->( fCount() )
   aField                     := array( nField )

   for i := 1 to nField
      aField[ i ]             := ( dbfTmp )->( fieldPos( ( dbfOld )->( fieldName( i ) ) ) )
   next

   // Proceso de cambios----------------------------------------------------------

   ( dbfOld )->( dbGoTop() )
   while !( dbfOld )->( eof() )

      ( dbfTmp )->( dbAppend() )

      aEval( aField, {| nFld, i | if( nFld != 0, ( dbfTmp )->( FieldPut( nFld, ( dbfOld )->( FieldGet( i ) ) ) ), ) } )

      ( dbfOld )->( dbSkip() )

      sysrefresh()

   end while

   lCopy                      := ( dbfOld )->( eof() )

   CLOSE ( dbfOld )
   CLOSE ( dbfTmp )

   // Si hay copia satisfactoria cambiamos los ficheros

   if lCopy

      if lExistTable( dbfNamOld + ".Dbf" )
         fEraseTable( dbfNamOld + ".Dbf" )
      end if

      if lExistTable( dbfNamOld + ".Fpt" )
         fEraseTable( dbfNamOld + ".Fpt" )
      end if

      if lExistTable( dbfNamOld + ".Cdx" )
         fEraseTable( dbfNamOld + ".Cdx" )
      end if

      if lExistTable( dbfNamTmp + ".Dbf" )
         if fRenameTable( dbfNamTmp + ".Dbf", dbfNamOld + ".Dbf" ) == -1
            msgStop( "La tabla " + ( dbfNamTmp ) + ".Dbf" + " no ha sido renombrada a " + ( dbfNamOld ) + ".Dbf" )
         end if
      end if

      if lExistTable( dbfNamTmp + ".Fpt" )
         if fRenameTable( dbfNamTmp + ".Fpt", dbfNamOld + ".Fpt" ) == -1
            msgStop( "La tabla " + ( dbfNamTmp ) + ".Fpt" + " no ha sido renombrada a " + ( dbfNamOld ) + ".Fpt" )
         end if
      end if

      if lExistTable( dbfNamTmp + ".Cdx" )
         if fRenameTable( dbfNamTmp + ".Cdx", dbfNamOld + ".Cdx" ) == -1
            msgStop( "La tabla " + ( dbfNamTmp ) + ".Cdx" + " no ha sido renombrada a " + ( dbfNamOld ) + ".Cdx" )
         end if
      end if

   else

      MsgStop( "No se actualizo el fichero " + ( dbfNamOld ) + ".Dbf" )

   end if

Return ( lCopy )

//-----------------------------------------------------------------------//

STATIC FUNCTION EndTrans( aTmp, aGet, oBrw, oFld, oDlg, oBtnOk, oBrwDet, dbfEmp, nMode )

   local n
   local cCodEmp           := aTmp[ _CODEMP ]
   cNewEmpresa             := aTmp[ _CODEMP ]

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if oFld:nOption != 3

         oFld:SetOption( oFld:nOption + 1 )

         if oFld:nOption == 3
            SetWindowText( oBtnOk:hWnd, "&Terminar" )
         end if

         Return nil

      end if

      if !Empty( cOldCodigoEmpresa ) .and. !dbSeekInOrd( cOldCodigoEmpresa, "CodEmp", dbfEmp )
         msgStop( "Empresa " + cOldCodigoEmpresa + " no encontrada." )
         Return nil
      end if

   end if

   /*
   Para q nadie toque mientras grabamos----------------------------------------
   */

   oDlg:Disable()

	/*
   Primero hacer el RollBack---------------------------------------------------
	*/

   while ( dbfDlg )->( dbSeek( cCodEmp ) )
      if( dbLock( dbfDlg ), ( ( dbfDlg )->( dbDelete() ), ( dbfDlg )->( dbUnLock() ) ), )
   end while

   /*
   Ahora escribimos en el fichero definitivo-----------------------------------
	*/

   ( tmpDlg )->( dbGoTop() )
   while !( tmpDlg )->( eof() )
      dbPass( tmpDlg, dbfDlg, .t., cCodEmp )
      ( tmpDlg )->( dbSkip() )
   end while

   /*
   Valores por defecto---------------------------------------------------------
   */

   if nMode == APPD_MODE
/*
      if !empty( cOldCodigoEmpresa ) .and. dbSeekInOrd( cOldCodigoEmpresa, "CodEmp", dbfEmp )
         for n := 14 to ( dbfEmp )->( fCount() )
            aTmp[ n ]      := ( dbfEmp )->( fieldget( ( dbfEmp )->( fieldpos( n ) ) ) )
         next 
      end if
*/
      if Empty( aTmp[ _CDEFFPG ] )
         aTmp[ _CDEFFPG ]  := "00"
      end if

      if Empty( aTmp[ _CDEFALM ] )
         aTmp[ _CDEFALM ]  := "000"
      end if

      if Empty( aTmp[ _CDEFCAJ ] )
         aTmp[ _CDEFCAJ ]  := "000"
      end if

      if Empty( aTmp[ _CDEFCJR ] )
         aTmp[ _CDEFCJR ]  := "000"
      end if

      if Empty( aTmp[ _CDIRIMG ] )
         aTmp[ _CDIRIMG ]  := ".\Imagen"
      end if

      aTmp[ _NNUMREM ]     := nSemillaContadores
      aTmp[ _NNUMLIQ ]     := nSemillaContadores
      aTmp[ _NNUMCAR ]     := nSemillaContadores
      aTmp[ _NNUMMOV ]     := nSemillaContadores
      aTmp[ _NNUMCOB ]     := nSemillaContadores
      aTmp[ _NNUMPGO ]     := nSemillaContadores

   end if

   /*
   Grabamos el registro--------------------------------------------------------
   */

   WinGather( aTmp, aGet, dbfEmp, oBrw, nMode, , .f. )

   /*
   Escribe los datos pendientes------------------------------------------------
   */

   dbCommitAll()

   /*
   Cerrando dialog-------------------------------------------------------------
   */

   oDlg:Enable()
   oDlg:End( IDOK )

Return .t.

//---------------------------------------------------------------------------//

FUNCTION ConfEmpresa( oWnd, oMenuItem, nSelFolder )

   local nLevel         := 0

   DEFAULT  oWnd        := oWnd()
   DEFAULT  oMenuItem   := _MENUITEM_
   DEFAULT  nSelFolder  := 1

   /*
   Obtenemos el nivel de acceso------------------------------------------------
   */

   nLevel               := nLevelUsr( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWnd != nil
      sysrefresh(); oWnd:CloseAll(); sysrefresh()
   end if

   if OpenFiles()

      if ( dbfEmp )->( dbSeek( cCodEmp() ) )
         WinEdtRec( nil, bEditConfig, dbfEmp, nSelFolder )
      else
         MsgStop( "Código de empresa " + cCodEmp() + " no encontrada." )
      end if

      CloseFiles()

   end if

RETURN NIL

//------------------------------------------------------------------------//

Static Function AppFromEmpresa( cCodEmp, dbfEmp, aGet, aTmp, tmpDlg, dbfDlg )

   local nRec              := ( dbfEmp )->( Recno() )

   if dbSeekInOrd( cCodEmp, "CodEmp", dbfEmp )

      aTmp[ _CSUFDOC ]     := (dbfEmp)->cSufDoc
      aTmp[ _NCODCLI ]     := (dbfEmp)->nCodCli
      aTmp[ _NCODPRV ]     := (dbfEmp)->nCodPrv
      aTmp[ _LUSECAJ ]     := (dbfEmp)->lUseCaj
      aTmp[ _LCALCAJ ]     := (dbfEmp)->lCalCaj
      aTmp[ _LCODART ]     := (dbfEmp)->lCodArt
      aTmp[ _LENTCON ]     := (dbfEmp)->lEntCon
      aTmp[ _LMODDES ]     := (dbfEmp)->lModDes
      aTmp[ _LMODIVA ]     := (dbfEmp)->lModIva
      aTmp[ _LTIPMOV ]     := (dbfEmp)->lTipMov
      aTmp[ _LGETCOB ]     := (dbfEmp)->lGetCob
      aTmp[ _LSELFAM ]     := (dbfEmp)->lSelFam
      aTmp[ _LMODIMP ]     := (dbfEmp)->lModImp
      aTmp[ _LACTCOS ]     := (dbfEmp)->lActCos
      aTmp[ _LNUMOBR ]     := (dbfEmp)->lNumObr
      aTmp[ _CNUMOBR ]     := (dbfEmp)->cNumObr
      aTmp[ _LNUMPED ]     := (dbfEmp)->lNumPed
      aTmp[ _CNUMPED ]     := (dbfEmp)->cNumPed
      aTmp[ _LNUMALB ]     := (dbfEmp)->lNumAlb
      aTmp[ _CNUMALB ]     := (dbfEmp)->cNumAlb
      aTmp[ _LSUALB  ]     := (dbfEmp)->lSuaLb
      aTmp[ _CSUALB  ]     := (dbfEmp)->cSuaLb
      aTmp[ _NDGTUND ]     := (dbfEmp)->nDgtUnd
      aTmp[ _NDECUND ]     := (dbfEmp)->nDecUnd
      aTmp[ _NDGTESC ]     := (dbfEmp)->nDgtEsc
      aTmp[ _NDECESC ]     := (dbfEmp)->nDecEsc
      aTmp[ _CRUTCNT ]     := (dbfEmp)->cRutCnt
      aTmp[ _CCTACLI ]     := (dbfEmp)->cCtaCli
      aTmp[ _CCTAPRV ]     := (dbfEmp)->cCtaPrv
      aTmp[ _CCTAVTA ]     := (dbfEmp)->cCtaVta
      aTmp[ _CCTACOB ]     := (dbfEmp)->cCtaCob
      aTmp[ _CCTASIN ]     := (dbfEmp)->cCtaSin
      aTmp[ _CCTAANT ]     := (dbfEmp)->cCtaAnt
      aTmp[ _DFECVER ]     := (dbfEmp)->dFecVer
      aTmp[ _LSELFAM ]     := (dbfEmp)->lSelFam
      aTmp[ _LMODIMP ]     := (dbfEmp)->lModImp
      aTmp[ _NNUMLIQ ]     := (dbfEmp)->nNumLiq
      aTmp[ _NNUMCAR ]     := (dbfEmp)->nNumCar
      aTmp[ _CENVUSR ]     := (dbfEmp)->cEnvUsr
      aTmp[ _NTIPCON ]     := (dbfEmp)->nTipCon
      aTmp[ _CRUTCON ]     := (dbfEmp)->cRutCon
      aTmp[ _CNOMCON ]     := (dbfEmp)->cNomCon
      aTmp[ _CUSRCON ]     := (dbfEmp)->cUsrCon
      aTmp[ _CPSWCON ]     := (dbfEmp)->cPswCon
      aTmp[ _CSITFTP ]     := (dbfEmp)->cSitFtp
      aTmp[ _CUSRFTP ]     := (dbfEmp)->cUsrFtp
      aTmp[ _CPSWFTP ]     := (dbfEmp)->cPswFtp
      aTmp[ _CDEFALM ]     := (dbfEmp)->cDefAlm
      aTmp[ _CDEFFPG ]     := (dbfEmp)->cDefFpg
      aTmp[ _CDEFCLI ]     := (dbfEmp)->cDefCli
      aTmp[ _CDEFSER ]     := (dbfEmp)->cDefSer
      aTmp[ _CDEFCAJ ]     := (dbfEmp)->cDefCaj
      aTmp[ _CDEFCJR ]     := (dbfEmp)->cDefCjr
      aTmp[ _LGETLOT ]     := (dbfEmp)->lGetLot
      aTmp[ _LBUSIMP ]     := (dbfEmp)->lBusImp
      aTmp[ _LSHWCOS ]     := (dbfEmp)->lShwCos
      aTmp[ _LGETAGE ]     := (dbfEmp)->lGetAge
      aTmp[ _LGETUSR ]     := (dbfEmp)->lGetUsr
      aTmp[ _LIMPEXA ]     := (dbfEmp)->lImpExa
      aTmp[ _CPRNPDF ]     := (dbfEmp)->cPrnPdf
      aTmp[ _CDEFIVA ]     := (dbfEmp)->cDefIva
      aTmp[ _NDIAVAL ]     := (dbfEmp)->nDiaVal
      aTmp[ _CCTACEERPT ]  := (dbfEmp)->cCtaCeeRpt
      aTmp[ _CCTACEESPT ]  := (dbfEmp)->cCtaCeeSpt
      aTmp[ _CCEERPTCOM ]  := (dbfEmp)->cCeeRptCom
      aTmp[ _CCEESPTCOM ]  := (dbfEmp)->cCeeSptCom

      /*
      Agregamos las delegaciones-----------------------------------------------
      */

      if ( dbfDlg )->( dbSeek( cCodEmp ) )
         while ( ( dbfDlg )->cCodEmp == cCodEmp .and. !( dbfDlg )->( eof() ) )
            dbPass( dbfDlg, tmpDlg, .t. )
            ( dbfDlg )->( dbSkip() )
         end while
      end if

      ( tmpDlg )->( dbGoTop() )

   end if

   ( dbfEmp )->( dbGoTo( nRec ) )

return ( .t. )

//---------------------------------------------------------------------------//

Function ChkAllEmp( lForced )

   local n
   local dbfEmp
   local nHandle
   local aEmp        := {}

   DEFAULT lForced   := .f.

   if ( !File( FullCurDir() + "ChkEmp.nil" ) .or. fSize( FullCurDir() + "ChkEmp.nil" ) == 0 .or. lForced )

      aEmp           := aFullEmpresas()

      if lForced .or. ;
         ApoloMsgNoYes(    "El sistema ha detectado una nueva versión, es"       + CRLF + ;
                           "conveniente que inicie el proceso de actualización"  + CRLF + ;
                           "de sus datos, para ello deben de salir todos los"    + CRLF + ;
                           "usuarios de la aplicación."                          + CRLF + ;
                                                                                 + CRLF + ;
                           "¿Desea actualizar todos sus datos?",;
                           "Seleccione una opción" )


         if !Empty( oWnd() )
            oWnd():Disable()
         end if

         for n := 1 to len( aEmp )

            setEmpresa( aEmp[ n, 1 ] )

            checkEmpresaTablesExistences()
            
            lActualiza( aEmp[ n, 1 ], oWndBrw, .t., aEmp[ n, 2 ] )

         next

         if !Empty( oWnd() )
            oWnd():Enable()
         end if

      end if

      if !File( FullCurDir() + "ChkEmp.nil" )

         if ( nHandle := fCreate( FullCurDir() + "ChkEmp.nil", 0 ) ) == -1
            MsgStop( "No puedo crear el fichero, " + FullCurDir() + "ChkEmp.nil", "Error " + cValToChar( fError() ) )
         else
            fClose( nHandle )
         end if

      end if

      nHandle        := fOpen( FullCurDir() + "ChkEmp.nil", 2 )

      if fError() != 0
         msgStop( "No puedo abrir el fichero, " + FullCurDir() + "ChkEmp.nil", "Error " + cValToChar( fError() ) )
      else
         fWrite( nHandle, Dtos( Date() ) )
      end if

      fClose( nHandle )

   end if

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION EditConta( nAt, aTmp )

   local oDlg
   local oGetEmp
   local cGetEmp  := aItmEmp[ nAt, 2 ]
   local oSayEmp
   local cSayEmp
   local oGetPrj
   local cGetPrj  := aItmEmp[ nAt, 3 ]
   local oSayPrj
   local cSayPrj

   DEFINE DIALOG oDlg RESOURCE "EDTEMPCNT"

      REDEFINE GET oGetEmp VAR cGetEmp ;
         ID       100;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET oSayEmp VAR cSayEmp ;
         ID       110 ;
         WHEN     .f. ;
         PICTURE  "@!" ;
         OF       oDlg

      REDEFINE GET oGetPrj VAR cGetPrj ;
         ID       120 ;
         PICTURE  "@R ###.######" ;
         OF       oDlg

      REDEFINE GET oSayPrj VAR cSayPrj ;
         ID       130 ;
         WHEN     .f.;
         OF       oDlg

      // Botones --------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      // controles para contaplus----------------------------------------------

      if lAplicacionContaplus()
         
         oGetEmp:bValid    := {|| ChkEmpresaContaplus( AllTrim( aTmp[ _CRUTCNT ] ), cGetEmp, oSayEmp ), .t. }
         oGetEmp:bHelp     := {|| BrwEmpresaContaplus( AllTrim( aTmp[ _CRUTCNT ] ), oGetEmp ) }
         oGetEmp:cBmp      := "Lupa" 

         oGetPrj:bValid    := {|| ChkProyecto( cGetPrj, oSayPrj, AllTrim( aTmp[ _CRUTCNT ] ), cGetEmp ), .t. }
         oGetPrj:bHelp     := {|| BrwProyecto( oGetPrj, oSayPrj, AllTrim( aTmp[ _CRUTCNT ] ), cGetEmp ) }
         oGetPrj:cBmp      := "Lupa"

         oDlg:bStart       := {|| oGetEmp:lValid(), oGetPrj:lValid() }

      end if 

      // Teclas rapidas--------------------------------------------------------

      oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER 

   if oDlg:nResult == IDOK
      aItmEmp[ nAt, 2 ]   := cGetEmp
      aItmEmp[ nAt, 3 ]   := cGetPrj
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

Static Function SaveEditConfig( aTmp, oSay, oBrw, oDlg, nMode )

   CursorWait()

   oDlg:Disable()

   /*
   Ejecutamos el valid para que guarde el nombre de la serie-------------------
   */

   oNombreSerie:lValid()

   /*
   Guardamos los datos de las series-------------------------------------------
   */

   CmbSerieSave( oCmbSerie )

   /*
   Guarda los cambios----------------------------------------------------------
   */

   aTmp[ _NEXPCONTBL ]  := oCmbContabilidad:nAt

   aTmp[ _CCODEMPA ]    := aItmEmp[ 1, 2 ]
   aTmp[ _CCODEMPB ]    := aItmEmp[ 2, 2 ]
   aTmp[ _CCODEMPC ]    := aItmEmp[ 3, 2 ]
   aTmp[ _CCODEMPD ]    := aItmEmp[ 4, 2 ]
   aTmp[ _CCODEMPE ]    := aItmEmp[ 5, 2 ]
   aTmp[ _CCODEMPF ]    := aItmEmp[ 6, 2 ]
   aTmp[ _CCODEMPG ]    := aItmEmp[ 7, 2 ]
   aTmp[ _CCODEMPH ]    := aItmEmp[ 8, 2 ]
   aTmp[ _CCODEMPI ]    := aItmEmp[ 9, 2 ]
   aTmp[ _CCODEMPJ ]    := aItmEmp[10, 2 ]
   aTmp[ _CCODEMPK ]    := aItmEmp[11, 2 ]
   aTmp[ _CCODEMPL ]    := aItmEmp[12, 2 ]
   aTmp[ _CCODEMPM ]    := aItmEmp[13, 2 ]
   aTmp[ _CCODEMPN ]    := aItmEmp[14, 2 ]
   aTmp[ _CCODEMPO ]    := aItmEmp[15, 2 ]
   aTmp[ _CCODEMPP ]    := aItmEmp[16, 2 ]
   aTmp[ _CCODEMPQ ]    := aItmEmp[17, 2 ]
   aTmp[ _CCODEMPR ]    := aItmEmp[18, 2 ]
   aTmp[ _CCODEMPS ]    := aItmEmp[19, 2 ]
   aTmp[ _CCODEMPT ]    := aItmEmp[20, 2 ]
   aTmp[ _CCODEMPU ]    := aItmEmp[21, 2 ]
   aTmp[ _CCODEMPV ]    := aItmEmp[22, 2 ]
   aTmp[ _CCODEMPW ]    := aItmEmp[23, 2 ]
   aTmp[ _CCODEMPX ]    := aItmEmp[24, 2 ]
   aTmp[ _CCODEMPY ]    := aItmEmp[25, 2 ]
   aTmp[ _CCODEMPZ ]    := aItmEmp[26, 2 ]

   aTmp[ _CCODPROA ]    := aItmEmp[ 1, 3 ]
   aTmp[ _CCODPROB ]    := aItmEmp[ 2, 3 ]
   aTmp[ _CCODPROC ]    := aItmEmp[ 3, 3 ]
   aTmp[ _CCODPROD ]    := aItmEmp[ 4, 3 ]
   aTmp[ _CCODPROE ]    := aItmEmp[ 5, 3 ]
   aTmp[ _CCODPROF ]    := aItmEmp[ 6, 3 ]
   aTmp[ _CCODPROG ]    := aItmEmp[ 7, 3 ]
   aTmp[ _CCODPROH ]    := aItmEmp[ 8, 3 ]
   aTmp[ _CCODPROI ]    := aItmEmp[ 9, 3 ]
   aTmp[ _CCODPROJ ]    := aItmEmp[10, 3 ]
   aTmp[ _CCODPROK ]    := aItmEmp[11, 3 ]
   aTmp[ _CCODPROL ]    := aItmEmp[12, 3 ]
   aTmp[ _CCODPROM ]    := aItmEmp[13, 3 ]
   aTmp[ _CCODPRON ]    := aItmEmp[14, 3 ]
   aTmp[ _CCODPROO ]    := aItmEmp[15, 3 ]
   aTmp[ _CCODPROP ]    := aItmEmp[16, 3 ]
   aTmp[ _CCODPROQ ]    := aItmEmp[17, 3 ]
   aTmp[ _CCODPROR ]    := aItmEmp[18, 3 ]
   aTmp[ _CCODPROS ]    := aItmEmp[19, 3 ]
   aTmp[ _CCODPROT ]    := aItmEmp[20, 3 ]
   aTmp[ _CCODPROU ]    := aItmEmp[21, 3 ]
   aTmp[ _CCODPROV ]    := aItmEmp[22, 3 ]
   aTmp[ _CCODPROW ]    := aItmEmp[23, 3 ]
   aTmp[ _CCODPROX ]    := aItmEmp[24, 3 ]
   aTmp[ _CCODPROY ]    := aItmEmp[25, 3 ]
   aTmp[ _CCODPROZ ]    := aItmEmp[26, 3 ]

   aTmp[ _LIVAREQ  ]    := ( nIvaReq == 1 )

   aTmp[ _NDEFSBR1 ]    := oSay[ 36 ]:nAt
   aTmp[ _NDEFSBR2 ]    := oSay[ 37 ]:nAt
   aTmp[ _NDEFSBR3 ]    := oSay[ 38 ]:nAt
   aTmp[ _NDEFSBR4 ]    := oSay[ 39 ]:nAt
   aTmp[ _NDEFSBR5 ]    := oSay[ 40 ]:nAt
   aTmp[ _NDEFSBR6 ]    := oSay[ 41 ]:nAt

   aTmp[ _NCIFRUT ]     := oSay[ 42 ]:nAt

   aTmp[ _NTIEMPOPED ]  := cCadenaToTiempo( cTiempoPed )

   if !empty( oGetPrecioVenta )
      aTmp[ _NPREVTA ]        := oGetPrecioVenta:getTarifa()
   else
      aTmp[ _NPREVTA ]        := 1
   endif

   if !empty( oGetPrecioWebVenta )
      aTmp[ _NPREWEBVTA ]     := oGetPrecioWebVenta:getTarifa()
   else
      aTmp[ _NPREWEBVTA ]     := 1
   endif

   if !empty( oGetPrecioProducto )
      aTmp[ _NPRETPRO ]       := oGetPrecioProducto:getTarifa()
   else
      aTmp[ _NPRETPRO ]       := 1
   endif

   if !empty( oGetPrecioCombinado )
      aTmp[ _NPRETCMB ]       := oGetPrecioCombinado:getTarifa() 
   else
      aTmp[ _NPRETCMB ]       := 1
   endif

   // Pasamos los contadores---------------------------------------------------

   ( tmpCount )->( dbGoTop() )
   while !( tmpCount )->( eof() )

      if dbSeekInOrd( ( tmpCount )->Doc, "Doc", dbfCount )
         dbPass( tmpCount, dbfCount )
      end if

      ( tmpCount )->( dbSkip() )

   end while

   ConfiguracionEmpresasModel():setValue( 'mail_notificaciones',     alltrim( cMailNotificaciones ) )
   ConfiguracionEmpresasModel():setValue( 'informacion_inmediata',   lInformacionInmediata )

   // Escribimos en el definitivo----------------------------------------------

   winGather( aTmp, , dbfEmp, oBrw, nMode )

   oDlg:Enable()
   oDlg:End( IDOK )

   CursorWE()

Return nil

//---------------------------------------------------------------------------//

static function LoaItmEmp( aTmp )

   aItmEmp       := {}

   aAdd( aItmEmp, { "A", aTmp[ _CCODEMPA ], aTmp[ _CCODPROA ] } )
   aAdd( aItmEmp, { "B", aTmp[ _CCODEMPB ], aTmp[ _CCODPROB ] } )
   aAdd( aItmEmp, { "C", aTmp[ _CCODEMPC ], aTmp[ _CCODPROC ] } )
   aAdd( aItmEmp, { "D", aTmp[ _CCODEMPD ], aTmp[ _CCODPROD ] } )
   aAdd( aItmEmp, { "E", aTmp[ _CCODEMPE ], aTmp[ _CCODPROE ] } )
   aAdd( aItmEmp, { "F", aTmp[ _CCODEMPF ], aTmp[ _CCODPROF ] } )
   aAdd( aItmEmp, { "G", aTmp[ _CCODEMPG ], aTmp[ _CCODPROG ] } )
   aAdd( aItmEmp, { "H", aTmp[ _CCODEMPH ], aTmp[ _CCODPROH ] } )
   aAdd( aItmEmp, { "I", aTmp[ _CCODEMPI ], aTmp[ _CCODPROI ] } )
   aAdd( aItmEmp, { "J", aTmp[ _CCODEMPJ ], aTmp[ _CCODPROJ ] } )
   aAdd( aItmEmp, { "K", aTmp[ _CCODEMPK ], aTmp[ _CCODPROK ] } )
   aAdd( aItmEmp, { "L", aTmp[ _CCODEMPL ], aTmp[ _CCODPROL ] } )
   aAdd( aItmEmp, { "M", aTmp[ _CCODEMPM ], aTmp[ _CCODPROM ] } )
   aAdd( aItmEmp, { "N", aTmp[ _CCODEMPN ], aTmp[ _CCODPRON ] } )
   aAdd( aItmEmp, { "O", aTmp[ _CCODEMPO ], aTmp[ _CCODPROO ] } )
   aAdd( aItmEmp, { "P", aTmp[ _CCODEMPP ], aTmp[ _CCODPROP ] } )
   aAdd( aItmEmp, { "Q", aTmp[ _CCODEMPQ ], aTmp[ _CCODPROQ ] } )
   aAdd( aItmEmp, { "R", aTmp[ _CCODEMPR ], aTmp[ _CCODPROR ] } )
   aAdd( aItmEmp, { "S", aTmp[ _CCODEMPS ], aTmp[ _CCODPROS ] } )
   aAdd( aItmEmp, { "T", aTmp[ _CCODEMPT ], aTmp[ _CCODPROT ] } )
   aAdd( aItmEmp, { "U", aTmp[ _CCODEMPU ], aTmp[ _CCODPROU ] } )
   aAdd( aItmEmp, { "V", aTmp[ _CCODEMPV ], aTmp[ _CCODPROV ] } )
   aAdd( aItmEmp, { "W", aTmp[ _CCODEMPW ], aTmp[ _CCODPROW ] } )
   aAdd( aItmEmp, { "X", aTmp[ _CCODEMPX ], aTmp[ _CCODPROX ] } )
   aAdd( aItmEmp, { "Y", aTmp[ _CCODEMPY ], aTmp[ _CCODPROY ] } )
   aAdd( aItmEmp, { "Z", aTmp[ _CCODEMPZ ], aTmp[ _CCODPROZ ] } )

   nIvaReq     := if( aTmp[ _LIVAREQ ], 1, 2 )

return nil

//---------------------------------------------------------------------------//

Function PosEmpresa( cCodEmp, dbfEmp, oWndBrw )

   local nRec           := ( dbfEmp )->( Recno() )
   local nOrd           := ( dbfEmp )->( OrdSetFocus( "CodEmp" ) )

   if !( dbfEmp )->( dbSeek( cCodEmp ) )
      ( dbfEmp )->( dbGoTo( nRec ) )
   end if

   ( dbfEmp )->( OrdSetFocus( nOrd ) )

   oWndBrw:Refresh()

Return nil

//---------------------------------------------------------------------------//

CLASS AImportacion

   DATA lArticulos      INIT   .t.
   DATA lClientes       INIT   .t.
   DATA lProveedor      INIT   .t.
   DATA lAgente         INIT   .t.
   DATA lRuta           INIT   .t.
   DATA lPedPrv         INIT   .t.
   DATA lAlbPrv         INIT   .t.
   DATA lPreCli         INIT   .t.
   DATA lSatCli         INIT   .t.
   DATA lPedCli         INIT   .t.
   DATA lAlbCli         INIT   .t.
   DATA lAlmacen        INIT   .t.
   DATA lDocument       INIT   .t.
   DATA lStockIni       INIT   .t.
   DATA lOferta         INIT   .t.
   DATA lPromocion      INIT   .t.
   DATA lFPago          INIT   .t.
   DATA lVale           INIT   .t.
   DATA lAnticipo       INIT   .t.
   DATA lProduccion     INIT   .t.
   DATA lBancos         INIT   .t.
   DATA lExpedientes    INIT   .t.
   DATA lFidelizacion   INIT   .t.
   DATA nCosto          INIT   1
   DATA lScript         INIT   .t.
   DATA lEntidades      INIT   .t.

   Method False()

   Method Load( aTmp )

END CLASS

//---------------------------------------------------------------------------//

Method False() Class AImportacion

   ::lArticulos      := .f.
   ::lClientes       := .f.
   ::lProveedor      := .f.
   ::lAgente         := .f.
   ::lRuta           := .f.
   ::lPedPrv         := .f.
   ::lAlbPrv         := .f.
   ::lPreCli         := .f.
   ::lPedCli         := .f.
   ::lAlbCli         := .f.
   ::lAlmacen        := .f.
   ::lStockIni       := .f.
   ::lOferta         := .f.
   ::lPromocion      := .f.
   ::lFPago          := .f.
   ::lVale           := .f.
   ::lAnticipo       := .f.
   ::lDocument       := .f.
   ::lProduccion     := .f.
   ::lBancos         := .f.
   ::lExpedientes    := .f.
   ::lFidelizacion   := .f.
   ::nCosto          := 1
   ::lScript         := .f.
   ::lEntidades      := .f.

Return ( Self )

//---------------------------------------------------------------------------//

Method Load( aTmp ) Class AImportacion

   ::lArticulos      := aTmp[ _LGRPART ]
   ::lClientes       := aTmp[ _LGRPCLI ]
   ::lProveedor      := aTmp[ _LGRPPRV ]
   ::lAlmacen        := aTmp[ _LGRPALM ]

Return ( Self )

//---------------------------------------------------------------------------//

FUNCTION cPrinterPDF() ; return ( if( !Empty( aEmp()[ _CPRNPDF ] ), Rtrim( aEmp()[ _CPRNPDF ] ), "" ) )

//---------------------------------------------------------------------------//

FUNCTION nUltimaRecpcionInformacion( nRecepcion )

   if !Empty( nRecepcion )
      SetFieldEmpresa( nRecepcion, "nRecInf" )
   end if

RETURN ( aEmp()[ _NRECINF ] )

//---------------------------------------------------------------------------//

FUNCTION nUltimoEnvioInformacion( nEnvio )

   if !Empty( nEnvio )
      SetFieldEmpresa( nEnvio, "nSndInf" )
   end if

RETURN ( aEmp()[ _NSNDINF ] )

//---------------------------------------------------------------------------//

function BrwDelegacion( oGet, dbfDelega, oGetNombre, cCodigoEmpresa )

	local oDlg
	local oBrw
   local nRec
   local nOrd              := GetBrwOpt( "BrwDelegacion" )
   local oGet1
   local cGet1
	local oCbxOrd
   local cCbxOrd
   local aCbxOrd           := { "Código" }

   DEFAULT cCodigoEmpresa  := cCodEmp()

   nOrd                    := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd                 := aCbxOrd[ nOrd ]

   nRec                    := ( dbfDelega )->( Recno() )
   nOrd                    := ( dbfDelega )->( OrdSetFocus( nOrd ) )

   ( dbfDelega )->( dbSetFilter( {|| Field->cCodEmp == cCodigoEmpresa }, "cCodEmp == " + cCodigoEmpresa ) )
   ( dbfDelega )->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Delegación"

		REDEFINE GET oGet1 VAR cGet1;
         ID          104 ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfDelega ) );
         VALID       ( OrdClearScope( oBrw, dbfDelega ) );
         BITMAP      "FIND" ;
         OF          oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		   cCbxOrd ;
			ID 		   102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( dbfDelega )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:refresh(), oGet1:SetFocus() ) ;
         OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfDelega
      oBrw:nMarqueeStyle   := 6
      oBrw:cName           := "Browse.Delegacion.Empresa"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodDlg"
         :bEditValue       := {|| ( dbfDelega )->cCodDlg }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomDlg"
         :bEditValue       := {|| ( dbfDelega )->cNomDlg }
         :nWidth           := 260
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         ACTION      ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         ACTION      ( oDlg:end() )

		REDEFINE BUTTON ;
         ID          500 ;
         OF          oDlg ;
         WHEN        .f. ;
         ACTION      ( nil )

		REDEFINE BUTTON ;
         ID          501 ;
         OF          oDlg ;
         WHEN        .f. ;
         ACTION      ( nil )

      oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
      oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

      oDlg:bStart    := {|| oBrw:Load() }

   ACTIVATE DIALOG oDlg CENTER

   DestroyFastFilter( dbfDelega )

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfDelega )->cCodDlg )

      if isObject( oGetNombre )
         oGetNombre:cText( ( dbfDelega )->cNomDlg )
      end if

   end if

   ( dbfDelega )->( dbGoTo( nRec ) )
   ( dbfDelega )->( OrdSetFocus( nOrd ) )

	oGet:SetFocus()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

function cDelegacion( oGet, dbfDelega, oGetNombre, cCodigoEmpresa )

   local lValid            := .f.
   local cCodDlg           := oGet:varGet()

   DEFAULT cCodigoEmpresa  := cCodEmp()

   if Empty( cCodDlg )

      if !Empty( oGetNombre )
			oGetNombre:cText( "" )
      end if

      return .t.

   end if

   if ( dbfDelega )->( dbSeek( cCodigoEmpresa + cCodDlg ) )

      oGet:cText( ( dbfDelega )->cCodDlg )

      if !Empty( oGetNombre )
         oGetNombre:cText( ( dbfDelega )->cNomDlg )
      end if
      
      lValid      := .t.

   else
      
      msgStop( "Delegación no encontrada" )

   end if

return lValid

//---------------------------------------------------------------------------//

Function AppEmpresa()

   if OpenFiles( .f. )

      WinAppRec( nil, bEdit, dbfEmp )

      CloseFiles()

   end if

RETURN .t.

//---------------------------------------------------------------------------//

Function NextEmpresa()

   if Empty( oWnd() )
      Return .f.
   end if

   /*
   Obtenemos el nivel de acceso------------------------------------------------
   */

   if nAnd( nLevelUsr( _MENUITEM_ ), 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   CursorWait()

   /*
   Cerramos las ventanas-------------------------------------------------------
   */

   if oWnd() != nil
      oWnd():Disable()
      oWnd():CloseAll()
   end if

   if OpenFiles( .f. )

      if ( dbfEmp )->( dbSeek( cCodigoEmpresaEnUso() ) ) .and. ( dbfEmp )->( OrdKeyNo() ) != ( dbfEmp )->( OrdKeyCount() )

         ( dbfEmp )->( dbSkip() )

         if ( dbfEmp )->lGrupo
            ( dbfEmp )->( dbSkip() )
         end if

         setEmpresa( ( dbfEmp )->CodEmp, dbfEmp, dbfDlg, dbfUser )

         chkTurno()

         msgInfo( "Nueva empresa activa : " + ( dbfEmp )->CodEmp + " - " + Rtrim( ( dbfEmp )->cNombre ), "Cambio de empresa" )

      end if

      CloseFiles()

   end if

   oWnd():Enable()

   CursorWE()

RETURN .t.

//---------------------------------------------------------------------------//

Function PriorEmpresa()

   if Empty( oWnd() )
      Return .f.
   end if

   /*
   Obtenemos el nivel de acceso------------------------------------------------
   */

   if nAnd( nLevelUsr( _MENUITEM_ ), 1 ) != 0
      msgStop( "Acceso no permitido." )
      return .f.
   end if

   CursorWait()

   /*
   Cerramos las ventanas-------------------------------------------------------
   */

   if oWnd() != nil
      oWnd():Disable()
      oWnd():CloseAll()
   end if

   if OpenFiles( .f. )

      if ( dbfEmp )->( dbSeek( cCodigoEmpresaEnUso() ) ) .and. ( dbfEmp )->( OrdKeyNo() ) != 1

         ( dbfEmp )->( dbSkip( -1 ) )

         if ( dbfEmp )->lGrupo
            ( dbfEmp )->( dbSkip( -1 ) )
         end if

         setEmpresa( ( dbfEmp )->CodEmp, dbfEmp, dbfDlg, dbfUser )

         chkTurno()

         msgInfo( "Nueva empresa activa : " + ( dbfEmp )->CodEmp + " - " + Rtrim( ( dbfEmp )->cNombre ), "Cambio de empresa" )

      end if

      CloseFiles()

   end if

   oWnd():Enable()

   CursorWE()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Actualiza la base de datos
*/

FUNCTION TstEmpresa( cPatDat )

   local dbfEmp
   local dbfDlg
   local cCodEmp
   local lChangeCode
   local lChangeStruct  

   if !lExistTable( cPatDat() + "Empresa.Dbf" )
      dbCreate( cPatDat() + "Empresa.Dbf", aSqlStruct( aItmEmp() ), cDriver() )
   end if

   if !lExistTable( cPatDat() + "Delega.Dbf" )
      dbCreate( cPatDat() + "Delega.Dbf", aSqlStruct( aItmDlg() ), cDriver() )
   end if

   if !lExistIndex( cPatDat() + "Empresa.Cdx" ) .or. !lExistIndex( cPatDat() + "Delega.Cdx" )
      rxEmpresa( cPatDat() )
   end if

   /*
   Empresa---------------------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), ( cPatDat() + "Empresa.Dbf" ), cCheckArea( "Empresa", @dbfEmp ), .f. )

   if ( dbfEmp )->( netErr() )
      if( ( dbfEmp )->( Used() ), ( dbfEmp )->( dbCloseArea() ), )
      RETURN .f.
   end if 

   lChangeStruct  := lChangeStruct( dbfEmp, aItmEmp() )

   ( dbfEmp )->( dbCloseArea() )

   if lChangeStruct
      changeStructEmpresa()
   end if

   /*
   Delegaciones----------------------------------------------------------------
   */

   dbUseArea( .t., cDriver(), ( cPatDat() + "Delega.Dbf" ), cCheckArea( "Delega", @dbfDlg ), .f. )

   if ( dbfDlg )->( netErr() )
      if( ( dbfDlg )->( Used() ), ( dbfDlg )->( dbCloseArea() ), )
      RETURN .f.
   end if 

   lChangeStruct  := lChangeStruct( dbfDlg, aItmDlg() )

   ( dbfDlg )->( dbCloseArea() )

   if lChangeStruct
      changeStructDelegacion()
   end if

   CursorWait()

   /*
   Situacion especial para cambio de codigo------------------------------------
   */

   dbUseArea( .t.,  cDriver(), ( cPatDat() + "Empresa.Dbf" ), cCheckArea( "EMPRESA", @dbfEmp ), .f. )
      
   if ( dbfEmp )->( netErr() )
      if( ( dbfEmp )->( Used() ), ( dbfEmp )->( dbCloseArea() ), )
      RETURN .f.
   else 
      if( !lAIS(), ( dbfEmp )->( ordListAdd( ( cPatDat() + "Empresa.Cdx" ) ) ), ordSetFocus( 1 ) )
   end if 
      
   /*
   Comprobamos la longitud del codigo------------------------------------------
   */

   ( dbfEmp )->( dbgotop() )
   while !( dbfEmp )->( eof() )
      
      cCodEmp     := alltrim( ( dbfEmp )->CodEmp )
      
      if len( cCodEmp ) < 4
      
         if IsDirectory( FullCurDir() + "Emp" + cCodEmp )
            if fRename( FullCurDir() + "Emp" + cCodEmp, FullCurDir() + "Emp" + RJust( cCodEmp, "0", 4 ) ) == -1
               msgStop( "No he podido renombrar el directorio " + FullCurDir() + "Emp" + cCodEmp )
            end if
         end if 
    
      end if 
              
      ( dbfEmp )->( dbskip() )
                  
   end while

   ( dbfEmp )->( dbclosearea() )

   /*
   Comprobamos que el campo de codigo de empresa de las delegaciones se rellenen por 0
   */

   EmpresasModel():UpdateEmpresaCodigoEmpresa()

   EmpresasModel():UpdateDelegacionCodigoEmpresa()

   CursorWE()

RETURN ( .t. )

//---------------------------------------------------------------------------//

Static Function changeStructEmpresa()

   TDataCenter():DeleteTableName( "Empresa" )

   lCdx( .t. )
   lAIS( .f. )

   mkEmpresa( cPatEmpTmp(), cLocalDriver() )

   /*
   Trasbase a empresas---------------------------------------------------------
   */

   appDbf( cPatDat(), cPatEmpTmp(), "Empresa", aItmEmp() )

   fEraseTable( cPatDat() + "Empresa.Dbf" )

   fRenameTable( cPatEmpTmp() + "Empresa.Dbf", cPatDat() + "Empresa.Dbf" )
   fRenameTable( cPatEmpTmp() + "Empresa.Cdx", cPatDat() + "Empresa.Cdx" )

   lCdx( .f. )
   lAIS( .t. )

   TDataCenter():AddTableName( "Empresa" )

RETURN ( .t. )

//---------------------------------------------------------------------------//
/*
Trasbase a delegaciones--------------------------------------------------------
*/

Static Function changeStructDelegacion()

   TDataCenter():DeleteTableName( "Delega" )

   lCdx( .t. )
   lAIS( .f. )

   mkEmpresa( cPatEmpTmp(), cLocalDriver() )

   appDbf( cPatDat(), cPatEmpTmp(), "Delega", aItmDlg() )

   fEraseTable( cPatDat() + "Delega.Dbf" )

   fRenameTable( cPatEmpTmp() + "Delega.Dbf", cPatDat() + "Delega.Dbf" )
   fRenameTable( cPatEmpTmp() + "Delega.Cdx", cPatDat() + "Delega.Cdx" )

   lCdx( .f. )
   lAIS( .t. )

   TDataCenter():AddTableName( "Delega" )

RETURN ( .t. )

//---------------------------------------------------------------------------//


FUNCTION aItmEmp()

   local aDbf  := {}

   aAdd( aDbf, {"CodEmp",     "C",  4, 0, "Código de la empresa",            "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"cNombre",    "C", 45, 0, "Nombre de la empresa",            "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CNIF",       "C", 15, 0, "Nif de la empresa",               "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CADMINIS",   "C", 35, 0, "Administrador",                   "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CDOMICILIO", "C", 35, 0, "Domicilio",                       "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CPOBLACION", "C", 35, 0, "Población",                       "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CPROVINCIA", "C", 30, 0, "Provincia",                       "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CCODPOS",    "C",  5, 0, "Código postal",                   "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CTLF",       "C", 15, 0, "Teléfono",                        "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CFAX",       "C", 15, 0, "Fax",                             "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"EMAIL",      "C", 50, 0, "E-mail",                          "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"WEB",        "C",120, 0, "Página web",                      "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"LACTIVA",    "L",  1, 0, "Activa",                          "",                   "", "aEmp()", .f. } )
   aAdd( aDbf, {"NCODCLI",    "N",  2, 0, "Número de digitos del código de cliente", "",           "", "aEmp()", 0 } )
   aAdd( aDbf, {"NCODPRV",    "N",  2, 0, "Número de digitos del código de proveedor", "",         "", "aEmp()", 0 } )
   aAdd( aDbf, {"CSUFDOC",    "C",  2, 0, "Sufijo para documentos",          "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CDIVEMP",    "C",  3, 0, "Divisa de la empresa",            "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"CDIVCHG",    "C",  3, 0, "Divisa para cambios",             "",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"NTURTIK",    "N",  4, 0, "Contador para turnos",            "",                   "", "aEmp()", 0 } )
   aAdd( aDbf, {"LCODART",    "L",  1, 0, "Permitir solo artículos codificados", "",               "", "aEmp()", .f. } )
   aAdd( aDbf, {"CENVUSR",    "C", 20, 0, "Tipo de envio cliente o servidor","",                   "", "aEmp()", "" } )
   aAdd( aDbf, {"NTIPCON",    "N",  1, 0, "Tipo de conexión",                "",                   "", "aEmp()", 0 } )
   aAdd( aDbf, {"CRUTCON",    "C",250, 0, "Ruta de la conexión",             "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CNOMCON",    "C", 50, 0, "Nombre de la conexión",           "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CUSRCON",    "C", 50, 0, "Nombre de usuario de la conexión","",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CPSWCON",    "C", 20, 0, "Password para conexión",          "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CSITFTP",    "C",100, 0, "Nombre del servidor ftp",         "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CUSRFTP",    "C", 50, 0, "Nombre de usuario para ftp",      "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CPSWFTP",    "C", 20, 0, "Password para usuario",           "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"NNUMTUR",    "N",  9, 0, "Número del turno",                "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"NNUMREM",    "N",  9, 0, "Número de la remesa",             "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LUSECAJ",    "L",  1, 0, "Usar cajas",                      "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LCALCAJ",    "L",  1, 0, "Cajas en calculo",                "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LENTCON",    "L",  1, 0, "Entradas continuas",              "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LMODDES",    "L",  1, 0, "Modificar descripciones",         "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LMODIVA",    "L",  1, 0, "Modificar tipo de impuestos",     "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LTIPMOV",    "L",  1, 0, "Permitir multiples tipos de venta","",                  "", "aEmp()", nil } )
   aAdd( aDbf, {"LACTCOS",    "L",  1, 0, "Actualizar precios de costo",     "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"LNUMPED" ,   "L",  1, 0, "Incluir comentarios de su pedido", "",                  "", "aEmp()", nil } )
   aAdd( aDbf, {"CNUMPED" ,   "C", 50, 0, "Texto a incluir comentarios de su pedido", "",          "", "aEmp()", nil } )
   aAdd( aDbf, {"LNUMALB",    "L",  1, 0, "Incluir comentarios de nuestro albaran", "",            "", "aEmp()", nil } )
   aAdd( aDbf, {"CNUMALB",    "C", 50, 0, "Texto a incluir comentarios de nuestro albaran", "",    "", "aEmp()", nil } )
   aAdd( aDbf, {"LSUALB" ,    "L",  1, 0, "Incluir comentarios de su albaran", "",                 "", "aEmp()", nil } )
   aAdd( aDbf, {"CSUALB" ,    "C", 50, 0, "Texto a incluir comentarios de su albaran", "",         "", "aEmp()", nil } )
   aAdd( aDbf, {"LNUMOBR",    "L",  1, 0, "Incluir comentarios de la dirección",  "",              "", "aEmp()", nil } )
   aAdd( aDbf, {"CNUMOBR",    "C", 50, 0, "Texto a incluir comentarios de la dirección", "",       "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFALM",    "C", 16, 0, "Almacen por defecto",             "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFFPG",    "C",  2, 0, "Forma de pago por defecto",       "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"NDGTUND",    "N",  2, 0, "Número de digitos para las unidades", "",               "", "aEmp()", nil } )
   aAdd( aDbf, {"NDECUND",    "N",  1, 0, "Número de decimales para las unidades", "",             "", "aEmp()", nil } )
   aAdd( aDbf, {"CRUTCNT",    "C",100, 0, "Ruta de contabilidad",            "",                   "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpA",   "C",  5, 0, "Código de la empresa en contaplus para la serie A", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpB",   "C",  5, 0, "Código de la empresa en contaplus para la serie B", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpC",   "C",  5, 0, "Código de la empresa en contaplus para la serie C", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpD",   "C",  5, 0, "Código de la empresa en contaplus para la serie D", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpE",   "C",  5, 0, "Código de la empresa en contaplus para la serie E", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpF",   "C",  5, 0, "Código de la empresa en contaplus para la serie F", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpG",   "C",  5, 0, "Código de la empresa en contaplus para la serie G", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpH",   "C",  5, 0, "Código de la empresa en contaplus para la serie H", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpI",   "C",  5, 0, "Código de la empresa en contaplus para la serie I", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpJ",   "C",  5, 0, "Código de la empresa en contaplus para la serie J", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpK",   "C",  5, 0, "Código de la empresa en contaplus para la serie K", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpL",   "C",  5, 0, "Código de la empresa en contaplus para la serie L", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpM",   "C",  5, 0, "Código de la empresa en contaplus para la serie M", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpN",   "C",  5, 0, "Código de la empresa en contaplus para la serie N", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpO",   "C",  5, 0, "Código de la empresa en contaplus para la serie O", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpP",   "C",  5, 0, "Código de la empresa en contaplus para la serie P", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpQ",   "C",  5, 0, "Código de la empresa en contaplus para la serie Q", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpR",   "C",  5, 0, "Código de la empresa en contaplus para la serie R", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpS",   "C",  5, 0, "Código de la empresa en contaplus para la serie S", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpT",   "C",  5, 0, "Código de la empresa en contaplus para la serie T", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpU",   "C",  5, 0, "Código de la empresa en contaplus para la serie U", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpV",   "C",  5, 0, "Código de la empresa en contaplus para la serie V", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpW",   "C",  5, 0, "Código de la empresa en contaplus para la serie W", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpX",   "C",  5, 0, "Código de la empresa en contaplus para la serie X", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpY",   "C",  5, 0, "Código de la empresa en contaplus para la serie Y", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodEmpZ",   "C",  5, 0, "Codigo de la empresa en contaplus para la serie Z", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProA",   "C",  9, 0, "Código del proyecto en contaplus para la serie A" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProB",   "C",  9, 0, "Código del proyecto en contaplus para la serie B" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProC",   "C",  9, 0, "Código del proyecto en contaplus para la serie C" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProD",   "C",  9, 0, "Código del proyecto en contaplus para la serie D" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProE",   "C",  9, 0, "Código del proyecto en contaplus para la serie E" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProF",   "C",  9, 0, "Código del proyecto en contaplus para la serie F" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProG",   "C",  9, 0, "Código del proyecto en contaplus para la serie G" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProH",   "C",  9, 0, "Código del proyecto en contaplus para la serie H" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProI",   "C",  9, 0, "Código del proyecto en contaplus para la serie I" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProJ",   "C",  9, 0, "Código del proyecto en contaplus para la serie J" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProK",   "C",  9, 0, "Código del proyecto en contaplus para la serie K" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProL",   "C",  9, 0, "Código del proyecto en contaplus para la serie L" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProM",   "C",  9, 0, "Código del proyecto en contaplus para la serie M" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProN",   "C",  9, 0, "Código del proyecto en contaplus para la serie N" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProO",   "C",  9, 0, "Código del proyecto en contaplus para la serie O" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProP",   "C",  9, 0, "Código del proyecto en contaplus para la serie P" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProQ",   "C",  9, 0, "Código del proyecto en contaplus para la serie Q" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProR",   "C",  9, 0, "Código del proyecto en contaplus para la serie R" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProS",   "C",  9, 0, "Código del proyecto en contaplus para la serie S" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProT",   "C",  9, 0, "Código del proyecto en contaplus para la serie T" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProU",   "C",  9, 0, "Código del proyecto en contaplus para la serie U" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProV",   "C",  9, 0, "Código del proyecto en contaplus para la serie V" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProW",   "C",  9, 0, "Código del proyecto en contaplus para la serie W" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProX",   "C",  9, 0, "Código del proyecto en contaplus para la serie X" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProY",   "C",  9, 0, "Código del proyecto en contaplus para la serie Y" , "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodProZ",   "C",  9, 0, "Código del proyecto en contaplus para la serie Z",  "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CCTACLI",    "C",  3, 0, "Cuenta en contaplus de clientes",                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CCTAPRV",    "C",  3, 0, "Cuenta en contaplus de proveedores",                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CCTAVTA",    "C",  3, 0, "Cuenta en contaplus de venta",                      "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFCLI",    "C", 12, 0, "Cliente por defecto",                                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFSER",    "C",  1, 0, "Serie por defecto",                                     "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFCAJ",    "C",  3, 0, "Caja por defecto",                                      "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFCJR",    "C",  3, 0, "Cajero por defecto",                                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CCTACOB",    "C", 12, 0, "Subcuenta de cobros en T.P.V.",                         "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CCTASIN",    "C", 12, 0, "Subcuenta de clientes sin codificar",                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"LGETCOB",    "L",  1, 0, "Recoger obras",                                         "", "", "aEmp()", nil } )
   aAdd( aDbf, {"DFECVER",    "D",  8, 0, "Fecha de la versión",                                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"LSELFAM",    "L",  1, 0, "Selector por família",                                  "", "", "aEmp()", nil } )
   aAdd( aDbf, {"LUSEIMP",    "L",  1, 0, "Habilitar impuestos especiales",                        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"LMODIMP",    "L",  1, 0, "Modificar impuestos especiales",                        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NNUMLIQ",    "N",  9, 0, "Número de la liquidación",                              "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NNUMCAR",    "N",  9, 0, "Número de la ordenes de carga",                         "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CDIRIMG",    "C",100, 0, "Directorio de imagenes",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"CDEFIVA",    "C",  1, 0, "Tipo de impuesto por defecto",                          "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NNUMMOV",    "N",  9, 0, "Número del movimiento de almacen",                      "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NNUMCOB",    "N",  9, 0, "Número del cobro de agentes",                           "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NDEFBNF1",   "N",  6, 2, "Primer porcentaje de beneficio por defecto",            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NDEFBNF2",   "N",  6, 2, "Segundo porcentaje de beneficio por defecto",           "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NDEFBNF3",   "N",  6, 2, "Tercer porcentaje de beneficio por defecto",            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NDEFBNF4",   "N",  6, 2, "Cuarto porcentaje de beneficio por defecto",            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"NDEFBNF5",   "N",  6, 2, "Quinto porcentaje de beneficio por defecto",            "", "", "aEmp()", nil} )
   aAdd( aDbf, {"NDEFBNF6",   "N",  6, 2, "Sexto porcentaje de beneficio por defecto",             "", "", "aEmp()", nil} )
   aAdd( aDbf, {"nDefSbr1",   "N",  1, 0, "Primer beneficio sobre el costo o sobre venta por defecto", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDefSbr2",   "N",  1, 0, "Segundo beneficio sobre el costo o sobre venta por defecto","", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDefSbr3",   "N",  1, 0, "Tercer beneficio sobre el costo o sobre venta por defecto", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDefSbr4",   "N",  1, 0, "Cuarto beneficio sobre el costo o sobre venta por defecto", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDefSbr5",   "N",  1, 0, "Quinto beneficio sobre el costo o sobre venta por defecto", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDefSbr6",   "N",  1, 0, "Sexto beneficio sobre el costo o sobre venta por defecto",  "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lShwKit",    "L",  1, 0, "Mostrar productos kit",                                 "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lPasNil",    "L",  1, 0, "Confirmar artículos sin valorar",                       "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDgtEsc",    "N",  1, 0, "Número de digitos para escandallos",                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDecEsc",    "N",  1, 0, "Número de decimales para escandallos",                  "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lGetLot",    "L",  1, 0, "Recoger lotes",                                         "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lBusImp",    "L",  1, 0, "Buscar importes en la tarifa inferior",                 "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lShwCos",    "L",  1, 0, "Mostrar precios de costo",                              "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lGetAge",    "L",  1, 0, "Recoger el agente",                                     "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lImpExa",    "L",  1, 0, "Importe exacto al cobrar",                              "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lGetUsr",    "L",  1, 0, "Recoger el usuario",                                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lIvaReq",    "L",  1, 0, "Lógico para creación de cuentas de contabilidad",       "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lEnvEnt",    "L",  1, 0, "Lógico para enviar solo albaranes entregados",          "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDiaVal",    "N",  3, 0, "Dias de validez para un presupuesto",                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCtaAnt",    "C", 12, 0, "Subcuenta de anticipos de clientes",                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nSndInf",    "N",  9, 0, "Número del último envio",                               "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nRecInf",    "N",  9, 0, "Número del la última recepción",                        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cPrnPdf",    "C",220, 0, "Impresora para generar PDF",                            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lCodeBar",   "L",  1, 0, "Lógico seleccionar multiples códigos de barras",        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cDedVta",    "C",  2, 0, "Tipo de venta por defecto",                             "", "", "aEmp()", nil } )
   aAdd( aDbf, {"dIniOpe",    "D",  8, 0, "Fecha de inicio de las operaciones",                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"dFinOpe",    "D",  8, 0, "Fecha de fin de las operaciones",                       "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCtaRet",    "C", 12, 0, "Cuenta en contaplus de IRPF",                           "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cSitSql",    "C",100, 0, "Nombre del servidor para MySql",                        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cUsrSql",    "C", 50, 0, "Nombre de usuario para MySql",                          "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cPswSql",    "C", 20, 0, "Password para usuario para MySql",                      "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nPrtSql",    "N",  5, 0, "Puerto para conexión de MySql",                         "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cDtbSql",    "C",100, 0, "Base de datos MySql",                                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNbrCaj",    "C",100, 0, "Descripción para cajas",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNbrUnd",    "C",100, 0, "Descripción para unidades",                             "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lUsePor",    "L",  1, 0, "Lógico habilitar portes",                               "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lUsePnt",    "L",  1, 0, "Lógico habilitar punto verde",                          "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lIvaInc",    "L",  1, 0, "Lógico para impuestos incluido",                        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCtaCeeRpt", "C", 12, 0, "Cuenta en contaplus de impuestos repercutido",          "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCtaCeeSpt", "C", 12, 0, "Cuenta en contaplus de impuestos soportado",            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lUseTbl",    "L",  1, 0, "Lógico para usar tabla de propiedades",                 "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lShwTar1",   "L",  1, 0, "Lógico para mostrar la primera tarifa",                 "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lShwTar2",   "L",  1, 0, "Lógico para mostrar la segunda tarifa",                 "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lShwTar3",   "L",  1, 0, "Lógico para mostrar la tercera tarifa",                 "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lShwTar4",   "L",  1, 0, "Lógico para mostrar la cuarta tarifa",                  "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lShwTar5",   "L",  1, 0, "Lógico para mostrar la quinta tarifa",                  "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lShwTar6",   "L",  1, 0, "Lógico para mostrar la sexta tarifa",                   "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"cTxtTar1",   "C", 50, 0, "Nombre para la primera tarifa",                         "", "", "aEmp()", "Precio 1"} )
   aAdd( aDbf, {"cTxtTar2",   "C", 50, 0, "Nombre para la segunda tarifa",                         "", "", "aEmp()", "Precio 2"} )
   aAdd( aDbf, {"cTxtTar3",   "C", 50, 0, "Nombre para la tercera tarifa",                         "", "", "aEmp()", "Precio 3"} )
   aAdd( aDbf, {"cTxtTar4",   "C", 50, 0, "Nombre para la cuarta tarifa",                          "", "", "aEmp()", "Precio 4"} )
   aAdd( aDbf, {"cTxtTar5",   "C", 50, 0, "Nombre para la quinta tarifa",                          "", "", "aEmp()", "Precio 5"} )
   aAdd( aDbf, {"cTxtTar6",   "C", 50, 0, "Nombre para la sexta tarifa",                           "", "", "aEmp()", "Precio 6"} )
   aAdd( aDbf, {"cIniJor",    "C",  5, 0, "Hora de inicio de la jornada laboral",                  "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cSrvMai",    "C",250, 0, "Servidor de correo",                                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCtaMai",    "C",250, 0, "Cuenta de correo",                                      "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cPssMai",    "C",250, 0, "Clave de cuenta de correo",                             "", "", "aEmp()", "" } )
   aAdd( aDbf, {"cCcpMai",    "C",250, 0, "Enviar copias de mail a cuenta de correo",              "", "", "aEmp()", "" } )
   aAdd( aDbf, {"nNumPgo",    "N",  9, 0, "Contador para pago de clientes",                        "", "", "aEmp()", 1 } )
   aAdd( aDbf, {"lSelCaj",    "L",  1, 0, "Lógico seleccionar cajas",                              "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lSelAlm",    "L",  1, 0, "Lógico seleccionar almacenes",                          "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lAddCut",    "L",  1, 0, "Lógico sumar unidades en TPV",                          "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lFidelity",  "L",  1, 0, "Lógico para iniciar el modo fidelity",                  "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lPreLin",    "L",  1, 0, "Lógico seleccionar precios en línea",                   "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lDtoLin",    "L",  1, 0, "Lógico habilitar descuento lineal",                     "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lSalPdt",    "L",  1, 0, "Lógico avisar saldo pendiente",                         "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"nPrtMai",    "N",  5, 0, "Puerto del servidor de correo",                         "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lAutMai",    "L",  1, 0, "Lógico de autenticación del servidor de correo",        "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lGetUbi",    "L",  1, 0, "Recoger ubicación de venta",                            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lGrupo",     "L",  1, 0, "Lógico de grupo",                                       "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodGrp",    "C",  4, 0, "Código del grupo",                                      "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lStkCero",   "L",  1, 0, "Lógico para mostrar estokaje cero",                     "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lShowSala",  "L",  1, 0, "Lógico para mostrar las sala de venta siempre",         "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"nPreTPro",   "N",  1, 0, "Precios para productos en táctil",                      "", "", "aEmp()", 1 } )
   aAdd( aDbf, {"nPreTCmb",   "N",  1, 0, "Precios para combinados en táctil",                     "", "", "aEmp()", 2 } )
   aAdd( aDbf, {"lCosPrv",    "L",  1, 0, "Lógico costo por proveedor",                            "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lShwPop",    "L",  1, 0, "Lógico de mostrar ventanas de stocks",                  "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"nCifRut",    "N",  1, 0, "Númerico para calclulo de CIF o RUT",                   "", "", "aEmp()", 1 } )
   aAdd( aDbf, {"cDImagen",   "C",250, 0, "Ruta para las imagenes en FTP",                         "", "", "aEmp()", Space( 250 ) } )
   aAdd( aDbf, {"lGetFpg",    "L",  1, 0, "Lógico de solicitar siempre forma de pago",             "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"cSeriePed",  "C",  1, 0, "Serie para pedidos de internet",                        "", "", "aEmp()", "A" } )
   aAdd( aDbf, {"nTiempoPed", "N",  3, 0, "Tiempo en recargar los pedidos",                        "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"lNStkAct",   "L",  1, 0, "Logico para no mostrar el stock actual en ventas",      "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"cRutEdi",    "C",250, 0, "Ruta para exportar las facturas a EDI",                 "", "", "aEmp()", Space( 250 ) } )
   aAdd( aDbf, {"cCodEdi",    "C", 17, 0, "Código EDI [EAN] de nuestras empresa",                  "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cUsrFtpImg", "C", 50, 0, "Nombre de usuario para ftp de imagenes",                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cPswFtpImg", "C", 50, 0, "Contraseña de usuario para ftp de imagenes",            "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cHstFtpImg", "C", 50, 0, "Host para ftp de imagenes",                             "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nPrtFtp",    "N",  5, 0, "Puerto del servidor ftp para imagenes",                 "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNumRegMer", "C",250, 0, "Número del registro mercantil",                         "", "", "aEmp()", Space( 250 ) } )
   aAdd( aDbf, {"nTiempoImp", "N",  3, 0, "Tiempo de recarga de impresión pda",                    "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"lPasEnvio",  "L",  1, 0, "Lógico envio pasivo de datos",                          "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"lPasFtp",    "L",  1, 0, "Lógico envio pasivo ftp",                               "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"lOrdNomTpv", "L",  1, 0, "Lógico ordén TPV por nombre",                           "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"lGrpCli",    "L",  1, 0, "Lógico de grupo tablas de cliente",                     "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lGrpArt",    "L",  1, 0, "Lógico de grupo tablas de artículos",                   "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"CDefTem",    "C", 10, 0, "Temporada por defecto",                                 "", "", "aEmp()", nil } )
   aAdd( aDbf, {"nDiaVale",   "N",  3, 0, "Numeros de dias para que el vale sea valido",           "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lNumTik",    "L",  1, 0, "Lógico numero del tiket obligatorio para devolución",   "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lCosAct",    "L",  1, 0, "Lógico para usar costo actual en movimientos",          "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lGrpPrv",    "L",  1, 0, "Lógico de grupo tablas de proveedores",                 "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lGrpAlm",    "L",  1, 0, "Lógico de grupo tablas de almacén",                     "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"nPreVta",    "N",  1, 0, "Precios para ventas generales",                         "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"nPreWebVta", "N",  1, 0, "Precios para ventas web",                               "", "", "aEmp()", 0 } )
   aAdd( aDbf, {"lSerNoCom",  "L",  1, 0, "Avisar en ventas de números de serie no comprados",     "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lConIva",    "L",  1, 0, "Lógico para contabilizar apuntes de impuestos siempre", "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lIvaImpEsp", "L",  1, 0, "Aplicar impuestos a impuestos especiales",              "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lBtnFam",    "L",  1, 0, "Seleccion de familias por botones en PDA",              "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lPreMin",    "L",  1, 0, "Lógico no permitir ventas bajo precio mínimo",          "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lCalLot",    "L",  1, 0, "Lógico calculo de lotes en stock",                      "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lCalSer",    "L",  1, 0, "Lógico calculo de números de serie en stock",           "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lMovCos",    "L",  1, 0, "Lógico no usar movimientos en costo medio",             "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lGrpEnt",    "L",  1, 0, "Lógico agrupar entregas a cuenta en recibos",           "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lBusCir",    "L",  1, 0, "Lógico activar búsqueda circular",                      "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"cNomSerA",   "C", 60, 0, "Nombre para la serie A",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerB",   "C", 60, 0, "Nombre para la serie B",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerC",   "C", 60, 0, "Nombre para la serie C",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerD",   "C", 60, 0, "Nombre para la serie D",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerE",   "C", 60, 0, "Nombre para la serie E",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerF",   "C", 60, 0, "Nombre para la serie F",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerG",   "C", 60, 0, "Nombre para la serie G",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerH",   "C", 60, 0, "Nombre para la serie H",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerI",   "C", 60, 0, "Nombre para la serie I",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerJ",   "C", 60, 0, "Nombre para la serie J",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerK",   "C", 60, 0, "Nombre para la serie K",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerL",   "C", 60, 0, "Nombre para la serie L",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerM",   "C", 60, 0, "Nombre para la serie M",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerN",   "C", 60, 0, "Nombre para la serie N",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerO",   "C", 60, 0, "Nombre para la serie O",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerP",   "C", 60, 0, "Nombre para la serie P",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerQ",   "C", 60, 0, "Nombre para la serie Q",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerR",   "C", 60, 0, "Nombre para la serie R",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerS",   "C", 60, 0, "Nombre para la serie S",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerT",   "C", 60, 0, "Nombre para la serie T",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerU",   "C", 60, 0, "Nombre para la serie U",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerV",   "C", 60, 0, "Nombre para la serie V",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerW",   "C", 60, 0, "Nombre para la serie W",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerX",   "C", 60, 0, "Nombre para la serie X",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerY",   "C", 60, 0, "Nombre para la serie Y",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomSerZ",   "C", 60, 0, "Nombre para la serie Z",                                "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lCntNeg",    "L",  1, 0, "Contabilizar negativo",                                 "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lImgArt",    "L",  1, 0, "Lógico si un artículo lleva imagen",                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lFltYea",    "L",  1, 0, "Lógico filtro de documentos por año",                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNomImp",    "C", 20, 0, "Nombre del impuesto",                                   "", "", "aEmp()", "IVA" } )
   aAdd( aDbf, {"lReqDec",    "L",  1, 0, "Lógico si el recargo se aplica con decimales",          "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lAptNeg",    "L",  1, 0, "Lógico de realizar apunte en contaplus en negativo",    "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lLlevar",    "L",  1, 0, "Lógico realizar para llevar en táctil",                 "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lRecoger",   "L",  1, 0, "Lógico realizar para recoger en táctil",                "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"nAutSer",    "N", 16, 0, "Número de autserializado",                              "", "", "aEmp()", 1 } )
   aAdd( aDbf, {"lEncargar",  "L",  1, 0, "Lógico realizar para encargos en táctil",               "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"nCopSea",    "N",  1, 0, "Número para comportamiento en caso de conflicto",       "", "", "aEmp()", 1 } )
   aAdd( aDbf, {"lRealWeb",   "L",  1, 0, "Lógico conectar tiempo real con la web",                "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lRecNumFac", "L",  1, 0, "Lógico para recuperar el número de las facturas",       "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lAlbTct",    "L",  1, 0, "Lógico para realizar albaranes desde táctil",           "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lFacTct",    "L",  1, 0, "Lógico para realizar facturas desde táctil",            "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lMailTrno",  "L",  1, 0, "Lógico para enviar mail de cierre de turno",            "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"cMailTrno",  "C",200, 0, "dirección de correo electónico para cierre de turno",   "", "", "aEmp()", "" } )
   aAdd( aDbf, {"cCtaPor",    "C", 12, 0, "Subcuenta de portes",                                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCtaGas",    "C", 12, 0, "Subcuenta de gastos",                                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lApeNomb",   "L",  1, 0, "Lógico recibir apellidos, nombre desde la web",         "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lTotTikCob", "L",  1, 0, "Lógico mostrar total ticket al cobrar",                 "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"nTipImpTpv", "N",  1, 0, "Opción impresión al cobrar en tpv táctil",              "", "", "aEmp()", 1 } )
   aAdd( aDbf, {"lEmpFrnq",   "L",  1, 0, "Lógico empresa franquiciada",                           "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lRECC",      "L",  1, 0, "Régimen especial del criterio de caja",                 "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"nIniRECC",   "N",  4, 0, "Año inicio régimen especial del criterio de caja",      "", "", "aEmp()", } )
   aAdd( aDbf, {"nFinRECC",   "N",  4, 0, "Año fin régimen especial del criterio de caja",         "", "", "aEmp()", } )
   aAdd( aDbf, {"lHExpWeb",   "L",  1, 0, "Ocultar botón exportar web",                            "", "", "aEmp()", } )
   aAdd( aDbf, {"lRecCostes", "L",  1, 0, "Recalcula costes en partes de producción",              "", "", "aEmp()", } )
   aAdd( aDbf, {"nExpContbl", "N",  1, 0, "Exportación contable",                                  "", "", "aEmp()", } )
   aAdd( aDbf, {"lShowLin",   "L",  1, 0, "Ocultar lineas borradas",                               "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lShowOrg",   "L",  1, 0, "Mostrar almacén origen en compras",                     "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lUseBultos", "L",  1, 0, "Usar bultos",                                           "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cNbrBultos", "C",100, 0, "Descripción para bultos",                               "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodCliFrq", "C", 12, 0, "Código de cliente para franquicia",                     "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCodPrvFrq", "C", 12, 0, "Código de proveedor para franquicia",                   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lStkAlm",    "L",  1, 0, "Lógico de usar stock por almacenes",                    "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lSSLMai",    "L",  1, 0, "Lógico de uso de protocolo SSL del servidor de correo", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCcoMai",    "C",250, 0, "Enviar con copia oculta de mail a cuenta de correo",    "", "", "aEmp()", "" } )
   aAdd( aDbf, {"lRecEnt",    "L",  1, 0, "Lógico para recibir albaranes como entregados",         "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"cSeriePre",  "C",  1, 0, "Serie para presupuestos de internet",                   "", "", "aEmp()", "A" } )
   aAdd( aDbf, {"lServicio",  "L",  1, 0, "Lógico Fecha servicio",                                 "", "", "aEmp()" } )
   aAdd( aDbf, {"cCeeRptCom", "C", 12, 0, "Cuenta en contaplus de impuestos repercutido en compras", "", "", "aEmp()", nil } )
   aAdd( aDbf, {"cCeeSptCom", "C", 12, 0, "Cuenta en contaplus de impuestos devengado en compras",   "", "", "aEmp()", nil } )
   aAdd( aDbf, {"lOpenTik",   "L",  1, 0, "Lógico permitir tickets abiertos en sesiones",          "", "", "aEmp()", .t. } )
   aAdd( aDbf, {"lContRec",   "L",  1, 0, "Lógico permitir contabilizar recibos con factura sin contabilizar", "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lStockAlm",  "L",  1, 0, "Lógico mostrar stock por almacén en ventas",            "", "", "aEmp()", .f. } )
   aAdd( aDbf, {"lBrFamTre",  "L",  1, 0, "Mostrar browse de familias tree",                       "", "", "aEmp()", .f. } )

Return ( aDbf )

//---------------------------------------------------------------------------//

static function aItmDlg()

   local aItmDlg  := {}

   aAdd( aItmDlg, { "CCODEMP", "C", 4, 0, "Código de empresa"    } )
   aAdd( aItmDlg, { "CCODDLG", "C", 2, 0, "Código de delegación" } )
   aAdd( aItmDlg, { "CNOMDLG", "C",50, 0, "Nombre de delegación" } )

return ( aItmDlg )

//---------------------------------------------------------------------------//

FUNCTION mkEmpresa( cPath, cDriver )

   DEFAULT cPath     := cPatDat()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "EMPRESA.DBF" )
      dbCreate( cPath + "EMPRESA.DBF", aSqlStruct( aItmEmp() ), cDriver )
   end if

   if !lExistTable( cPath + "DELEGA.DBF" )
      dbCreate( cPath + "DELEGA.DBF", aSqlStruct( aItmDlg() ), cDriver )
   end if

   if !lExistIndex( cPath + "EMPRESA.CDX" ) .or. !lExistIndex( cPath + "DELEGA.CDX" )
      rxEmpresa( cPath, cDriver )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION rxEmpresa( cPath, cDriver )

   local dbfEmp

   DEFAULT cPath     := cPatDat()
   DEFAULT cDriver   := cDriver()

   if !lExistTable( cPath + "EMPRESA.DBF" )
      dbCreate( cPath + "EMPRESA.DBF", aSqlStruct( aItmEmp() ), cDriver )
   end if

   dbUseArea( .t., cDriver(), cPath + "Empresa.Dbf", cCheckArea( "EMPRESA", @dbfEmp ), .f. )
   if !( dbfEmp )->( neterr() )
      ( dbfEmp)->( __dbPack() )

      ( dbfEmp )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfEmp )->( ordCreate( cPath + "EMPRESA.CDX", "CODEMP", "CodEmp", {|| Field->CodEmp }, ) )

      ( dbfEmp )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfEmp )->( ordCreate( cPath + "EMPRESA.CDX", "CNOMBRE", "CNOMBRE", {|| Field->cNomBre } ) )

      ( dbfEmp )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfEmp )->( ordCreate( cPath + "EMPRESA.CDX", "CCODGRP", "CCODGRP", {|| Field->cCodGrp } ) )

      ( dbfEmp )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de empresas" )
   end if

   if !lExistTable( cPath + "DELEGA.DBF" )
      dbCreate( cPath + "DELEGA.DBF", aSqlStruct( aItmDlg() ), cDriver )
   end if

   dbUseArea( .t., cDriver(), cPath + "DELEGA.DBF", cCheckArea( "DELEGA", @dbfDlg ), .f. )

   if !( dbfDlg )->( neterr() )
      ( dbfDlg)->( __dbPack() )

      ( dbfDlg )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
      ( dbfDlg )->( ordCreate( cPath + "DELEGA.CDX", "CCODEMP", "CCODEMP + CCODDLG", {|| Field->cCodEmp + Field->cCodDlg } ) )

      ( dbfDlg )->( dbCloseArea() )
   else
      msgStop( "Imposible abrir en modo exclusivo la tabla de delegaciones" )
   end if

RETURN NIL

//--------------------------------------------------------------------------//
/*
Valida la fecha del documento que estamos haciendo para que estén en el rango marcado en la empresa
*/

Function lValidaOperacion( dOperacion, lMessage )

   DEFAULT lMessage  := .t.

   if ( Empty( aEmp()[ _DINIOPE ] ) .OR. Empty( aEmp()[ _DFINOPE ] ) ) .or. ;
      ( dOperacion >= aEmp()[ _DINIOPE ] .and. dOperacion <= aEmp()[ _DFINOPE ] )
      Return .t.
   end if

   if lMessage
      msgStop( "La fecha del documento no está entre la fecha de operaciones marcada en la empresa" )
   end if

Return ( .f. )

//---------------------------------------------------------------------------//

Function lValidaSerie( cSerie, lMessage )

   DEFAULT lMessage  := .t.

   if ( cSerie >= "A" .and. cSerie <= "Z" )
      Return .t.
   end if

   if lMessage
      msgStop( "La serie del documento debe estar comprendida entre la A y la Z." )
   end if 

Return ( .f. )

//---------------------------------------------------------------------------//

Function cNombreUnidades()

   local cNombreUnidades   := "Unidades"

   if !Empty( aEmp() ) .and. _CNBRUND <= len( aEmp() ) .and. !Empty( aEmp()[ _CNBRUND ] )
      cNombreUnidades      := Rtrim( aEmp()[ _CNBRUND ] )
   end if

Return ( cNombreUnidades )

//---------------------------------------------------------------------------//

Function cNombreCajas()

   local cNombreCajas   := "Cajas"

   if !Empty( aEmp() ) .and. _CNBRCAJ <= len( aEmp() ) .and. !Empty( aEmp()[ _CNBRCAJ ] )
      cNombreCajas      := Rtrim( aEmp()[ _CNBRCAJ ] )
   end if

Return ( cNombreCajas )

//---------------------------------------------------------------------------//

Static function lChgCajCaj( aGet, aTmp )

   if !aTmp[ _LUSECAJ ]
      aTmp[ _LCALCAJ ]  := .f.
      aGet[ _LCALCAJ ]:Refresh()
   end if

Return (.t.)

//---------------------------------------------------------------------------//

Static Function cTiempoToCadena( nTiempo )

   local cTiempo  := aTiempo[ 1 ]

   do case
      case nTiempo == 0
         cTiempo  := aTiempo[ 1 ]
      case nTiempo == 1
         cTiempo  := aTiempo[ 2 ]
      case nTiempo == 2
         cTiempo  := aTiempo[ 3 ]
      case nTiempo == 5
         cTiempo  := aTiempo[ 4 ]
      case nTiempo == 10
         cTiempo  := aTiempo[ 5 ]
      case nTiempo == 15
         cTiempo  := aTiempo[ 6 ]
      case nTiempo == 30
         cTiempo  := aTiempo[ 7 ]
      case nTiempo == 45
         cTiempo  := aTiempo[ 8 ]
      case nTiempo == 60
         cTiempo  := aTiempo[ 9 ]
      case nTiempo == 120
         cTiempo  := aTiempo[ 10 ]
      case nTiempo == 240
         cTiempo  := aTiempo[ 11 ]
      case nTiempo == 480
         cTiempo  := aTiempo[ 12 ]
   endcase

Return ( cTiempo )

//---------------------------------------------------------------------------//

Static Function cTiempoToCadenaImp( nTiempo )

   local cTiempo  := aTiempoImp[ 1 ]

   do case
      case nTiempo == 0
         cTiempo  := aTiempoImp[ 1 ]
      case nTiempo == 5
         cTiempo  := aTiempoImp[ 2 ]
      case nTiempo == 10
         cTiempo  := aTiempoImp[ 3 ]
      case nTiempo == 15
         cTiempo  := aTiempoImp[ 4 ]
      case nTiempo == 20
         cTiempo  := aTiempoImp[ 5 ]
      case nTiempo == 25
         cTiempo  := aTiempoImp[ 6 ]
      case nTiempo == 30
         cTiempo  := aTiempoImp[ 7 ]
      case nTiempo == 35
         cTiempo  := aTiempoImp[ 8 ]
      case nTiempo == 40
         cTiempo  := aTiempoImp[ 9 ]
      case nTiempo == 45
         cTiempo  := aTiempoImp[ 10 ]
      case nTiempo == 50
         cTiempo  := aTiempoImp[ 11 ]
      case nTiempo == 55
         cTiempo  := aTiempoImp[ 12 ]
      case nTiempo == 60
         cTiempo  := aTiempoImp[ 13 ]
   endcase

Return ( cTiempo )

//---------------------------------------------------------------------------//

Static Function cCadenaToTiempo( cTiempo )

   local nTiempo := 0

   do case
      case cTiempo == aTiempo[ 1 ]
         nTiempo  := 0
      case cTiempo == aTiempo[ 2 ]
         nTiempo  := 1
      case cTiempo == aTiempo[ 3 ]
         nTiempo  := 2
      case cTiempo == aTiempo[ 4 ]
         nTiempo  := 5
      case cTiempo == aTiempo[ 5 ]
         nTiempo  := 10
      case cTiempo == aTiempo[ 6 ]
         nTiempo  := 15
      case cTiempo == aTiempo[ 7 ]
         nTiempo  := 30
      case cTiempo == aTiempo[ 8 ]
         nTiempo  := 45
      case cTiempo == aTiempo[ 9 ]
         nTiempo  := 60
      case cTiempo == aTiempo[ 10 ]
         nTiempo  := 120
      case cTiempo == aTiempo[ 11 ]
         nTiempo  := 240
      case cTiempo == aTiempo[ 12 ]
         nTiempo  := 480
   endcase

Return ( nTiempo )

//---------------------------------------------------------------------------//

Function SetTituloEmpresa()

   if oWnd() != nil
      oWnd():cTitle( __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ + Space( 1 ) + cTypeVersion() + " : " + uFieldEmpresa( "CodEmp", "" ) + " - " + Rtrim( uFieldEmpresa( "cNombre", "" ) ) )
   end if

Return ( nil )

//--------------------------------------------------------------------------//

FUNCTION aItmBnc()

   local aBase := {}

   aAdd( aBase, { "cCodEmp",     "C",  4, 0, "Código de empresa",                "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cEntBnc",     "C",  4, 0, "Entidad bancaria",                 "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cSucBnc",     "C",  4, 0, "Sucursal bancaria",                "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cDigBnc",     "C",  2, 0, "Dígito control",                   "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCtaBnc",     "C", 10, 0, "Cuenta",                           "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCodBnc",     "C", 50, 0, "Nombre del banco",                 "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cDirBnc",     "C", 35, 0, "Domicilio del banco",              "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPobBnc",     "C", 25, 0, "Población del banco",              "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cProBnc",     "C", 20, 0, "Provincia del banco",              "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cCPBnc",      "C", 15, 0, "Código postal",                    "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cTlfBnc",     "C", 20, 0, "Teléfono",                         "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cFaxBnc",     "C", 20, 0, "Fax",                              "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPContBnc",   "C", 35, 0, "Persona de contacto",              "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "cPaiBnc",     "C",  4, 0, "Pais",                             "",                   "", "( cDbfBnc )" } )
   aAdd( aBase, { "nSalIni",     "N", 16, 6, "Saldo inicial",                    "",                   "", "( cDbfBnc )" } )

RETURN ( aBase )

//----------------------------------------------------------------------------//

FUNCTION rxBnc( cPath, oMeter )

   local dbfBnc

   DEFAULT cPath  := cPatEmp()

   dbUseArea( .t., cDriver(), cPath + "EmpBnc.Dbf", cCheckArea( "EmpBnc", @dbfBnc ), .f. )

   if !( dbfBnc )->( neterr() )

      ( dbfBnc )->( __dbPack() )

      ( dbfBnc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfBnc )->( ordCreate( cPath + "EmpBnc.CDX", "cCodEmp", "cCodEmp + cCodBnc", {|| Field->cCodEmp + Field->cCodBnc } ) )

      ( dbfBnc )->( ordCondSet( "!Deleted()", {||!Deleted() } ) )
      ( dbfBnc )->( ordCreate( cPath + "EmpBnc.CDX", "cCtaBnc", "cCodEmp + cEntBnc + cSucBnc + cDigBnc + cCtaBnc", {|| Field->cCodEmp + Field->cEntBnc + Field->cSucBnc + Field->cDigBnc + Field->cCtaBnc } ) )

      ( dbfBnc )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de delegaciones" )

   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION BrwBncEmp( oGet, oGetPaisIBAN, oGetControlIBAN, oGetEntidad, oGetSucursal, oGetDigitoControl, oGetCuenta, dbfBancos )

	local oDlg
	local oBrw
   local oFont
   local oBtn
	local oGet1
	local cGet1
   local nOrd        := GetBrwOpt( "BrwBncEmp" )
	local oCbxOrd
   local aCbxOrd     := { "Nombre", "Cuenta" }
   local cCbxOrd     := "Nombre"
   local nLevel      := nLevelUsr( "01003" )
   local lClose      := .f.
   local nOrdAnt

   nOrd              := Min( Max( nOrd, 1 ), len( aCbxOrd ) )
   cCbxOrd           := aCbxOrd[ nOrd ]

   if !lExistTable( cPatEmp() + "EmpBnc.Dbf" )
      MsgStop( 'No existe el fichero de bancos' )
      Return .f.
   end if

   if Empty( dbfBancos )
      USE ( cPatEmp() + "EmpBnc.Dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "EMPBNC", @dbfBancos ) )
      SET ADSINDEX TO ( cPatEmp() + "EmpBnc.Cdx" ) ADDITIVE
      lClose         := .t.
   end if

   nOrdAnt           := ( dbfBancos )->( ordSetFocus( nOrd ) )

   ( dbfBancos )->( dbGoTop() )

   DEFINE DIALOG     oDlg ;
      RESOURCE       "HelpEntry" ;
      TITLE          "Seleccionar cuentas bancarias"

      REDEFINE GET oGet1 VAR cGet1;
         ID          104 ;
         ON CHANGE   ( AutoSeek( nKey, nFlags, Self, oBrw, dbfBancos, nil, cCodEmp() ) );
         BITMAP      "Find" ;
         OF          oDlg

		REDEFINE COMBOBOX oCbxOrd ;
         VAR         cCbxOrd ;
         ID          102 ;
         ITEMS       aCbxOrd ;
         ON CHANGE   ( ( dbfBancos )->( OrdSetFocus( oCbxOrd:nAt ) ), oBrw:Refresh(), oGet1:SetFocus() );
         OF          oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfBancos
      oBrw:nMarqueeStyle   := 5

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodBnc"
         :bEditValue       := {|| ( dbfBancos )->cCodBnc }
         :nWidth           := 80
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomBnc"
         :bEditValue       := {|| ( dbfBancos )->cNomBnc }
         :nWidth           := 200
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cuenta"
         :cSortOrder       := "cCtaBnc"
         :bEditValue       := {|| PictureCuentaIBAN( dbfBancos ) }
         :nWidth           := 180
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | oCbxOrd:Set( oCol:cHeader ) }
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Domicilio"
         :bEditValue       := {|| ( dbfBancos )->cDirBnc }
         :nWidth           := 180
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Población"
         :bEditValue       := {|| ( dbfBancos )->cPobBnc }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Código postal"
         :bEditValue       := {|| ( dbfBancos )->cCPBnc }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Provincia"
         :bEditValue       := {|| ( dbfBancos )->cProBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Teléfono"
         :bEditValue       := {|| ( dbfBancos )->cTlfBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fax"
         :bEditValue       := {|| ( dbfBancos )->cFaxBnc }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Contacto"
         :bEditValue       := {|| ( dbfBancos )->cPContBnc }
         :nWidth           := 140
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

		REDEFINE BUTTON ;
         ID       500 ;
         OF       oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

		REDEFINE BUTTON ;
         ID       501 ;
         OF       oDlg ;
         WHEN     ( .f. );
         ACTION   ( nil )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGet:cText( ( dbfBancos )->cNomBnc )

      oGetPaisIBAN:cText( ( dbfBancos )->cPaisIBAN )
      oGetControlIBAN:cText( ( dbfBancos )->cCtrlIBAN )
      oGetEntidad:cText( ( dbfBancos )->cEntBnc )
      oGetSucursal:cText( ( dbfBancos )->cSucBnc )
      oGetDigitoControl:cText( ( dbfBancos )->cDigBnc )
      oGetCuenta:cText( ( dbfBancos )->cCtaBnc )

   end if

   DestroyFastFilter( dbfBancos )

   SetBrwOpt( "BrwBancos", ( dbfBancos )->( OrdNumber() ) )

   ( dbfBancos )->( dbClearFilter() )

   ( dbfBancos )->( OrdSetFocus( nOrdAnt ) )

   if lClose
      ( dbfBancos )->( dbCloseArea() )
   end if

	oGet:setFocus()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

static function ChangeSerie( aGet, aTmp, oSerie, cSerie, lDown )

   /*
   Guardamos el nombre de la serie que tenemos seleccionada--------------------
   */

   GuardaNombreSerie( aTmp, cSerie )

   /*
   Cambiamos la serie----------------------------------------------------------
   */

   if lDown
      DwSerie( oSerie )
   else
      UpSerie( oSerie )
   end if

   /*
   Cargamos la nueva serie-----------------------------------------------------
   */

   CargaNombreSerie( aTmp, oSerie )

return ( .t. )

//---------------------------------------------------------------------------//

static function GuardaNombreSerie( aTmp, cSerie )

   do case
      case cSerie == "A"
         aTmp[ _CNOMSERA ] := cNombreSerie
      case cSerie == "B"
         aTmp[ _CNOMSERB ] := cNombreSerie
      case cSerie == "C"
         aTmp[ _CNOMSERC ] := cNombreSerie
      case cSerie == "D"
         aTmp[ _CNOMSERD ] := cNombreSerie
      case cSerie == "E"
         aTmp[ _CNOMSERE ] := cNombreSerie
      case cSerie == "F"
         aTmp[ _CNOMSERF ] := cNombreSerie
      case cSerie == "G"
         aTmp[ _CNOMSERG ] := cNombreSerie
      case cSerie == "H"
         aTmp[ _CNOMSERH ] := cNombreSerie
      case cSerie == "I"
         aTmp[ _CNOMSERI ] := cNombreSerie
      case cSerie == "J"
         aTmp[ _CNOMSERJ ] := cNombreSerie
      case cSerie == "K"
         aTmp[ _CNOMSERK ] := cNombreSerie
      case cSerie == "L"
         aTmp[ _CNOMSERL ] := cNombreSerie
      case cSerie == "M"
         aTmp[ _CNOMSERM ] := cNombreSerie
      case cSerie == "N"
         aTmp[ _CNOMSERN ] := cNombreSerie
      case cSerie == "O"
         aTmp[ _CNOMSERO ] := cNombreSerie
      case cSerie == "P"
         aTmp[ _CNOMSERP ] := cNombreSerie
      case cSerie == "Q"
         aTmp[ _CNOMSERQ ] := cNombreSerie
      case cSerie == "R"
         aTmp[ _CNOMSERR ] := cNombreSerie
      case cSerie == "S"
         aTmp[ _CNOMSERS ] := cNombreSerie
      case cSerie == "T"
         aTmp[ _CNOMSERT ] := cNombreSerie
      case cSerie == "U"
         aTmp[ _CNOMSERU ] := cNombreSerie
      case cSerie == "V"
         aTmp[ _CNOMSERV ] := cNombreSerie
      case cSerie == "W"
         aTmp[ _CNOMSERW ] := cNombreSerie
      case cSerie == "X"
         aTmp[ _CNOMSERX ] := cNombreSerie
      case cSerie == "Y"
         aTmp[ _CNOMSERY ] := cNombreSerie
      case cSerie == "Z"
         aTmp[ _CNOMSERZ ] := cNombreSerie
   end case

return ( .t. )

//---------------------------------------------------------------------------//

static function CargaNombreSerie( aTmp, oSerie )

   do Case
      case oSerie:VarGet() == "A"
         oNombreSerie:cText( aTmp[ _CNOMSERA ] )
      case oSerie:VarGet() == "B"
         oNombreSerie:cText( aTmp[ _CNOMSERB ] )
      case oSerie:VarGet() == "C"
         oNombreSerie:cText( aTmp[ _CNOMSERC ] )
      case oSerie:VarGet() == "D"
         oNombreSerie:cText( aTmp[ _CNOMSERD ] )
      case oSerie:VarGet() == "E"
         oNombreSerie:cText( aTmp[ _CNOMSERE ] )
      case oSerie:VarGet() == "F"
         oNombreSerie:cText( aTmp[ _CNOMSERF ] )
      case oSerie:VarGet() == "G"
         oNombreSerie:cText( aTmp[ _CNOMSERG ] )
      case oSerie:VarGet() == "H"
         oNombreSerie:cText( aTmp[ _CNOMSERH ] )
      case oSerie:VarGet() == "I"
         oNombreSerie:cText( aTmp[ _CNOMSERI ] )
      case oSerie:VarGet() == "J"
         oNombreSerie:cText( aTmp[ _CNOMSERJ ] )
      case oSerie:VarGet() == "K"
         oNombreSerie:cText( aTmp[ _CNOMSERK ] )
      case oSerie:VarGet() == "L"
         oNombreSerie:cText( aTmp[ _CNOMSERL ] )
      case oSerie:VarGet() == "M"
         oNombreSerie:cText( aTmp[ _CNOMSERM ] )
      case oSerie:VarGet() == "N"
         oNombreSerie:cText( aTmp[ _CNOMSERN ] )
      case oSerie:VarGet() == "O"
         oNombreSerie:cText( aTmp[ _CNOMSERO ] )
      case oSerie:VarGet() == "P"
         oNombreSerie:cText( aTmp[ _CNOMSERP ] )
      case oSerie:VarGet() == "Q"
         oNombreSerie:cText( aTmp[ _CNOMSERQ ] )
      case oSerie:VarGet() == "R"
         oNombreSerie:cText( aTmp[ _CNOMSERR ] )
      case oSerie:VarGet() == "S"
         oNombreSerie:cText( aTmp[ _CNOMSERS ] )
      case oSerie:VarGet() == "T"
         oNombreSerie:cText( aTmp[ _CNOMSERT ] )
      case oSerie:VarGet() == "U"
         oNombreSerie:cText( aTmp[ _CNOMSERU ] )
      case oSerie:VarGet() == "V"
         oNombreSerie:cText( aTmp[ _CNOMSERV ] )
      case oSerie:VarGet() == "W"
         oNombreSerie:cText( aTmp[ _CNOMSERW ] )
      case oSerie:VarGet() == "X"
         oNombreSerie:cText( aTmp[ _CNOMSERX ] )
      case oSerie:VarGet() == "Y"
         oNombreSerie:cText( aTmp[ _CNOMSERY ] )
      case oSerie:VarGet() == "Z"
         oNombreSerie:cText( aTmp[ _CNOMSERZ ] )
   end case

return ( .t. )

//---------------------------------------------------------------------------//

Static Function ValidRutaContabilidad( aGet, aTmp )

   // Contaplus----------------------------------------------------------------

   if lAplicacionContaplus()

      ChkRuta( aTmp[ _CRUTCNT ], .t. )

   else 

      if !Empty( aTmp[ _CRUTCNT ] ) .and. !IsDir( aTmp[ _CRUTCNT ] )
         msgStop( "Directorio " + alltrim( aTmp[ _CRUTCNT ] ) + " no existe." )
         Return .f.
      end if 

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

Function SelectDelegacion()

   local oDlg
   local oBrw
   local oBmp
   local dbfDlg
   local oGetBuscar
   local cGetBuscar     := Space( 100 )
   local oCbxOrden
   local cCbxOrden      := "Código"

   /*
   Apertura de ficharos--------------------------------------------------------
   */

   USE ( cPatDat() + "DELEGA.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "DELEGA", @dbfDlg ) )
   SET ADSINDEX TO ( cPatDat() + "DELEGA.CDX" ) ADDITIVE

   if lAIS()
      ( dbfDlg )->( AdsSetAOF( "Field->cCodEmp == '" + cCodEmp() + "'" ) )
   else
      ( dbfDlg )->( dbSetFilter( {|| Field->cCodEmp == cCodEmp() }, "Field->cCodEmp == cCodEmp()" ) )
   end if 

   ( dbfDlg )->( dbGoTop() )

   /*
   Dialogo---------------------------------------------------------------------
   */

   DEFINE DIALOG  oDlg ;
      RESOURCE    "SelectItem" ;
      TITLE       "Seleccionar delegación" ;

      REDEFINE BITMAP oBmp ;
         ID       300 ;
         RESOURCE "Flag_Eu_48_Alpha" ; 
         TRANSPARENT ;
         OF       oDlg

      REDEFINE GET oGetBuscar ;
         VAR      cGetBuscar;
         ID       100 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfDlg, nil, nil, .f. ) );
         BITMAP   "FIND" ;
         OF       oDlg

      REDEFINE COMBOBOX oCbxOrden ;
         VAR      cCbxOrden ;
         ID       110 ;
         ITEMS    { "Código", "Nombre" } ;
         ON CHANGE( ( dbfDlg )->( OrdSetFocus( oCbxOrden:nAt ) ), oBrw:Refresh(), oGetBuscar:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfDlg

      oBrw:nMarqueeStyle   := 5

      oBrw:CreateFromResource( 200 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :cSortOrder       := "cCodDlg"
         :bEditValue       := {|| ( dbfDlg )->cCodDlg }
         :nWidth           := 40
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :cSortOrder       := "cNomDlg"
         :bEditValue       := {|| ( dbfDlg )->cNomDlg }
         :nWidth           := 160
      end with

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }
      oBrw:bRClicked       := {| nRow, nCol, nFlags | oBrw:RButtonDown( nRow, nCol, nFlags ) }

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

   oDlg:AddFastKey( VK_F5,       {|| oDlg:end( IDOK ) } )
   oDlg:AddFastKey( VK_RETURN,   {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oUser():cDelegacion( ( dbfDlg )->cCodDlg )
      ChkTurno()
   end if

   if !Empty( dbfDlg )
      ( dbfDlg )->( dbCloseArea() )
   end if 

   if !Empty( oBmp )
      oBmp:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

function ActualizaEstructuras( dbfEmp, dbfDlg, dbfUser, oBrw, oWnd )

   local cCodEmp  := ""
   local cNomEmp  := ""

   if lAIS()
      msgStop( "Esta opción no esta disponible para versiones ADS.", "Actualizar empresas." )
      Return nil
   end if 

   // Paramos los servicios----------------------------------------------------

   CursorWait()

   // Paramos los servicios----------------------------------------------------

   oWnd:Disable()

   StopServices()

   cCodEmp        := ( dbfEmp )->CodEmp
   cNomEmp        := ( dbfEmp )->cNombre

   if !( dbfEmp )->lGrupo
      
      setEmpresa( cCodEmp, dbfEmp, dbfDlg, dbfUser )

      checkEmpresaTablesExistences()      
      
   end if

   CursorWE()

   oBrw:End()

   sysrefresh()

   lActualiza( cCodEmp, oBrw, .f., cNomEmp )
   
   // Iniciamos los servicios----------------------------------------------------

   InitServices()

   oWnd:Enable()

RETURN nil

//---------------------------------------------------------------------------//

Function aSerializedEmpresas()

Return ( aFullEmpresas( .t., .t. ) )

//---------------------------------------------------------------------------//

Function aFullEmpresas( lExcludeGroup, lSerialize )

   local dbfEmp
   local aFullEmpresas     := {}

   DEFAULT lExcludeGroup   := .f.
   DEFAULT lSerialize      := .f.

   USE ( cPatDat() + "Empresa.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "Empresa", @dbfEmp ) )
   SET ADSINDEX TO ( cPatDat() + "Empresa.CDX" ) ADDITIVE

   while !( dbfEmp )->( eof() )

      if !( ( dbfEmp )->lGrupo .and. lExcludeGroup )
         if lSerialize
            aAdd( aFullEmpresas, ( dbfEmp )->CodEmp + " - " + alltrim( ( dbfEmp )->cNombre ) )
         else
            aAdd( aFullEmpresas, { ( dbfEmp )->CodEmp, ( dbfEmp )->cNombre, ( dbfEmp )->lGrupo } )
         end if 
      end if 

      ( dbfEmp )->( dbSkip() )

   end while

   ( dbfEmp )->( dbCloseArea() )

Return ( aFullEmpresas )

//---------------------------------------------------------------------------//

Static Function TestConexionDatabase()

   local lConected   := .f.

   if !( TComercio:isValidNameWebToExport() )
      Return .f.
   end if 

   if !( TComercio:TComercioConfig:setCurrentWebName( TComercio:getWebToExport() ) )
      Return .f.
   end if 

   msgRun( "Intentando conectar con base de datos", "Espere por favor...", {|| lConected  :=  TComercio:prestaShopConnect() } )

   if lConected
      msgInfo( "Conexión con base de datos realizada correctamente" )
      TComercio:prestashopDisConnect() 
   else
      msgStop( "Servidor : "  + TComercio:TComercioConfig:getMySqlServer()   + CRLF + ;
               "User : "      + TComercio:TComercioConfig:getMySqlUser()     + CRLF + ;
               "Database : "  + TComercio:TComercioConfig:getMySqlDatabase() + CRLF + ;
               "Port : "      + alltrim( str( TComercio:TComercioConfig:getMySqlPort() ) ),;
               "Error al conectar con la base de datos" ) 
   end if     

Return ( .t. )

//---------------------------------------------------------------------------//

Static Function TestConexionFTP()

   local lConected   := .f.

   if !( TComercio:isValidNameWebToExport() )
      Return .f.
   end if 

   if !( TComercio:TComercioConfig:setCurrentWebName( TComercio:getWebToExport() ) )
      Return .f.
   end if 

   msgRun( "Intentando conectar con servidor FTP", "Espere por favor...", {|| TComercio:buildFTP(), lConected := TComercio:oFtp:CreateConexion() } )

   if lConected
      msgInfo( "Conexión servidor FTP realizada correctamente" )
      TComercio:oFtp:EndConexion()
   else 
      msgStop( "Error al conectar con servidor FTP" )
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//


