#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch" 
#include "Font.ch"
#include "Inkey.ch"
#include "Ads.ch"
#include "Xbrowse.ch"
#include "dbInfo.ch" 
#include "directry.ch"
#include "hbcurl.ch"
#include "hdo.ch"

#require "hbcurl"

#define GR_GDIOBJECTS         0
#define GR_USEROBJECTS        1   

#define CS_DBLCLKS            8

#define HKEY_LOCAL_MACHINE    2147483650

#define FONT_NAME             "Segoe UI"     

ANNOUNCE RDDSYS

REQUEST ADS
REQUEST DBFCDX
REQUEST DBFFPT

REQUEST AdsKeyNo
REQUEST AdsKeyCount
REQUEST AdsGetRelKeyPos 
REQUEST AdsSetRelKeyPos

static hDLLRich

static oDb, oSel, oUpd, oIns, oDel, oRS, oWnd


//---------------------------------------------------------------------------//
/*
-------------------------------------------------------------------------------
//Comenzamos la parte de código que se compila para el ejecutable normal-------
-------------------------------------------------------------------------------
*/

function Main( paramsMain, paramsSecond, paramsThird )

   local oIndex
   local oIconApp
   
   appParamsMain( paramsMain )

   appParamsSecond( paramsSecond )
   
   appParamsThird( paramsThird )

   appSettings()
   
   appDialogExtend() 

   mainTest()

   appLoadAds()

   // Motor de bases de datos--------------------------------------------------

   if ( "ADMINISTRADOR" $ appParamsMain() )
      TDataCenter():lAdministratorTask()
      Return nil
   end if 

   // Motor de bases de datos--------------------------------------------------

   if ( "ADSINTERNET" $ cAdsType() )

      if !( appConnectADS() )
         msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
         Return nil
      end if

   else 
      
      appConnectCDX()

   end if

   TDataCenter():BuildData()

   // Conexión con SQLite------------------------------------------------------

   if ( getSQLDatabase():Connect() )
      getSQLDatabase():checkModelsExistence()
   end if 

   // Icono--------------------------------------------------------------------

   DEFINE ICON oIconApp RESOURCE "Gestool"

   // Opciones especiales de arranque hace la operacion y salir----------------

   do case
      case ( "ENVIO" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

         if lInitCheck()
            TSndRecInf():Init():AutoExecute()
         end if

         return nil

      case ( "REINDEXA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

         if lInitCheck()
            oIndex               := TReindex():New()
            oIndex:lMessageEnd   := .f.
            oIndex:Resource( .t. )
         end if

         return nil

      case ( "EMPRESA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

      case ( !empty( appParamsSecond() ) .and. !empty( appParamsThird() ) )

         oUser( appParamsMain(), .f. )

         setEmpresa( appParamsSecond() )

         controllerReportGallery( appParamsThird() )

         return nil

   end case

   // Obtenemos la versión del programa----------------------------------------

   IsStandard()
   IsProfesional()
   IsOsCommerce()

   cNameVersion()

   // Chequeamos los datos de los usuarios-------------------------------------

   if !TReindex():lFreeHandle()
      msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicación" + CRLF + ;
               "en estos momentos, reintentelo pasados unos segundos." )
      Return .f.
   end if

   XbrNumFormat( "E", .t. )

   do case
      case ( "TACTIL" $ appParamsMain() )
         
         if AccessCode():TactilResource()
            InitMainTactilWindow( oIconApp )
         end if

      case ( "PDA" $ appParamsMain() )
         
         if AccessCode():Resource()
            CreateMainPdaWindow( oIconApp )
         end if

      case ( "TABLET" $ appParamsMain() )
         
         if AccessCode():loadTableConfiguration()
            CreateMainTabletWindow( oIconApp )
         end if

      otherwise
         
         if AccessCode():Resource()
            CreateMainWindow( oIconApp )
         end if

   end case

   if !empty( oIconApp )
      oIconApp:end()
   end if

   // Conexión con SQLite------------------------------------------------------

   getSQLDatabase():Disconnect() 

Return Nil

//----------------------------------------------------------------------------//

Static Function controllerReportGallery( cInitOptions )

   local hReportGallery    

   do case
      case cInitOptions == "ARTICULOS"

         if validRunReport( "01118" )
            TFastVentasArticulos():New():Play()
         end if 

      case cInitOptions == "CLIENTES"

         if validRunReport( "01120" )
            TFastVentasClientes():New():Play()
         end if 

      case cInitOptions == "PROVEEDORES"

         if validRunReport( "01121" )
            TFastComprasProveedores():New():Play()
         end if 

      case cInitOptions == "PRODUCCION"

         if validRunReport( "01123" )
            TFastProduccion():New():Play()
         end if 

   end case

Return nil

//---------------------------------------------------------------------------//

Function HelpTopic()

   msgStop( "Help wanted!" )

Return Nil

//----------------------------------------------------------------------------//

Function HelpIndex()

   goWeb( __GSTHELP__ )

Return Nil

//----------------------------------------------------------------------------//

Static Function CreateMainTabletWindow()

   lDemoMode( .f. )

   if lInitCheck()
      MainTablet()
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//


init procedure InitAplication()

   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   hb_langselect( "ES" )      // Para mensajes, fechas, etc..
   hb_setcodepage( "ESWIN" )  // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

   loadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit

return

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __HARBOUR__

Static Function CreateMainPdaWindow( oIconApp )

   /*
   Chequeo inicial de la aplicacion--------------------------------------------
   */

   lInitCheck()

Return nil

//---------------------------------------------------------------------------//

Static Function ExecuteMainPdaWindow( oListView, oDlg )

Return nil

//---------------------------------------------------------------------------//

Static Function InitMainTactilWindow()

   lDemoMode( .f. )

   selCajTactil( , .t. )

   // Colocamos la sesion actual-----------------------------------------------

   chkTurno()

   TpvTactil():New():Activate( .t. )

Return nil

//--------------------------------------------------------------------------//
// Controla los accesos al programa

FUNCTION AccesTctCode()

   local oBlock
   local oError
   local oDlg
   local oBrush
   local dbfUser
   local dbfCajas
   local oImgUsr
   local oLstUsr
   local cPath
   local cPcnUsr

   /*
   Comprobamos que exista el direcotrio USR------------------------------------
   */

   if( !lIsDir( cPatUsr() ), MakeDir( cNamePath( cPatUsr() ) ), )

   cPath          := cPatDat()
   cPcnUsr        := Rtrim( NetName() )

   // Comprobamos q exista al menos un usuario master--------------------------

   IF !File( cPath + "USERS.DBF" ) .or. ;
      !File( cPath + "MAPAS.DBF" )
		mkUsuario()
	END IF

   IF !File( cPath + "USERS.CDX" ) .or. ;
      !File( cPath + "MAPAS.CDX" )
      rxUsuario()
	END IF

   While !IsMaster()
      rxUsuario()
   End While

   // Comprobamos q exista al menos una caja-----------------------------------

   While !IsCaja()
      rxCajas()
   End While

   // Comprobamos q exista al menos una impresora de ticket--------------------

   while !IsImpTik()
      rxImpTik( cPatDat() )
   end while

   // Comprobamos q exista al menos un visor-----------------------------------

   while !IsVisor()
      rxVisor( cPatDat() )
   end while

   // Comprobamos q exista al menos un cajon portamonedas----------------------

   IsCajPorta()

   // Comprobamos q exista al menos una divisa---------------------------------

   while !IsDiv()
      rxDiv()
   end while

   //Abrimos la tabla de usuarios----------------------------------------------

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      USE ( cPath + "USERS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "USERS", @dbfUser ) )
      SET ADSINDEX TO ( cPath + "USERS.CDX" ) ADDITIVE

      USE ( cPatDat() + "CAJAS.DBF" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CAJAS", @dbfCajas ) )
      SET ADSINDEX TO ( cPatDat() + "CAJAS.CDX" ) ADDITIVE

      nUsrInUse( dbfUser )

      //Cargamos la imagen de fondo de la pantalla de bienvenida------------------

      if !Os_IsWTSClient()
         DEFINE BRUSH oBrush FILE ( cBmpVersion() )
      end if

      //Montamos el diálogo con la imágen de fondo--------------------------------

      DEFINE DIALOG  oDlg ;
         RESOURCE    "WelSerTactil" ;
         TITLE       __GSTROTOR__ + Space( 1 ) + __GSTVERSION__ + " - " + __GSTFACTORY__ ;
         BRUSH       oBrush

      /*
      Montamos la lista con los usuarios-------------------------------------
      */

         oImgUsr           := TImageList():New( 50, 50 ) //

         oLstUsr           := TListView():Redefine( 100, oDlg )
         oLstUsr:nOption   := 0
         oLstUsr:bClick    := {| nOpt | if( clickAccessTctCode( nOpt, oLstUsr, dbfUser ), oDlg:End( IDOK ), ) }

      /*
      Botones de la caja de diálogo--------------------------------------------
      */

      REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            ACTION   ( oDlg:end() )

      /*
      Al iniciar el diálogo cargamos las imágenes de los usuarios--------------
      */

      ACTIVATE DIALOG oDlg ;
         CENTER ;
         ON INIT     ( InitBrw( oDlg, oImgUsr, oLstUsr, dbfUser ) ) ;

      SysRefresh()

      if oDlg:nResult == IDOK
         oSetUsr( ( dbfUser )->cCodUse, .t. ):Save( dbfUser, dbfCajas )
      end if

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !Empty( dbfUser )
      ( dbfUser )->( dbCloseArea() )
   end if

   if !Empty( dbfCajas )
      ( dbfCajas )->( dbCloseArea() )
   end if

   if oBrush != nil
      oBrush:End()
   end if

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

Function InitBrw( oDlg, oImgUsr, oLstUsr, dbfUsr )

   local nImg     := -1
   local nUser    := 0

   if !Empty( oImgUsr ) .and. !Empty( oLstUsr )

      oImgUsr:AddMasked( TBitmap():Define( "GC_BUSINESSMAN2_50" ),   Rgb( 255, 0, 255 ) )
      oImgUsr:AddMasked( TBitmap():Define( "GC_USER2_50" ),    Rgb( 255, 0, 255 ) )

      oLstUsr:SetImageList( oImgUsr )

      oLstUsr:EnableGroupView()

      oLstUsr:SetIconSpacing( 120, 140 )

      with object ( TListViewGroup():New() )
         :cHeader := "Administradores"
         :Create( oLstUsr )
      end with

      with object ( TListViewGroup():New() )
         :cHeader := "Usuarios"
         :Create( oLstUsr )
      end with

      ( dbfUsr )->( dbGoTop() )
      while !( dbfUsr )->( eof() )

         if !( dbfUsr )->lUseUse .and. !( dbfUsr )->lGrupo

            if !Empty( ( dbfUsr )->cImagen ) .and. File( Rtrim( ( dbfUsr )->cImagen ) )

               oImgUsr:Add( TBitmap():Define( , Rtrim( ( dbfUsr )->cImagen ) ) )

               nImg++

               with object ( TListViewItem():New() )
                  :Cargo   := ( dbfUsr )->cCodUse
                  :cText   := Capitalize( ( dbfUsr )->cNbrUse )
                  :nImage  := nImg
                  :nGroup  := if( ( dbfUsr )->nGrpUse <= 1, 1, 2 )
                  :Create( oLstUsr )
               end with

            else

               with object ( TListViewItem():New() )
                  :Cargo   := ( dbfUsr )->cCodUse
                  :cText   := Capitalize( ( dbfUsr )->cNbrUse )
                  :nImage  := if( ( dbfUsr )->nGrpUse <= 1, 0, 1 )
                  :nGroup  := if( ( dbfUsr )->nGrpUse <= 1, 1, 2 )
                  :Create( oLstUsr )
               end with

            end if

         end if


         ( dbfUsr )->( dbSkip() )

      end while

      oLstUsr:Refresh()

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//Función que chequea el usuario, la clave y nos deja pasar

Static Function clickAccessTctCode( nOpt, oLstUsr, dbfUsr )

   local oItem

   // Chequeamos que seleccione almenos un usuario-----------------------------

   if Empty( nOpt )
      MsgStop( "Seleccione usuario" )
      Return .f.
   end if

   oItem       := oLstUsr:GetItem( nOpt )

   if !Empty( oItem ) .and. dbSeekInOrd( oItem:Cargo, "cCodUse", dbfUsr )

      if !( dbfUsr )->lUseUse

         // Comprobamos la clave del usuario-----------------------------------

         if lGetPsw( dbfUsr, .t. )
            Return .t.
         end if

      else

         MsgStop( "Usuario en uso" )

         Return .f.

      end if

   else

      MsgStop( "El usuario no existe" )

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

STATIC FUNCTION lTctInitCheck( lDir, oMessage, oProgress )

   local oError
   local oBlock
   local lCheck   := .t.

   DEFAULT lDir   := .f.

   CursorWait()

   oMsgText( 'Comprobando directorios' )

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      lDemoMode( .f. )

      // Comprobamos que exista los directorios necesarios------------------------

      appCheckDirectory()

      // Borrar los ficheros de los directorios temporales------------------------

      oMsgText( 'Borrando ficheros temporales' )

      EraseFilesInDirectory( cPatTmp(), "*.*" )

      // Cargamos los datos de la empresa-----------------------------------------

      oMsgText( 'Control de tablas de empresa' )

      TstEmpresa()

      // Chequea los cambios de las bases de datos--------------------------------

      oMsgText( 'Control de actualizaciones' )

      ChkAllEmp()

      // Apertura de ficheros-----------------------------------------------------

      SetEmpresa()

      // Inicializamos classes----------------------------------------------------

      oMsgText( 'Inicializamos las clases de la aplicación' )

      InitClasses()

      // Comprobamos q exista al menos un almacen---------------------------------

      oMsgText( 'Control de tablas de almacén' )

      IsAlmacen()

      // Comprobamos q exista al menos una forma de pago--------------------------

      oMsgText( 'Control de formas de pagos' )

      IsFPago()

      // Chequea q exista los contadores------------------------------------------

      oMsgText( 'Control de contadores' )

      mkCount( cPatEmp() )

      oMsgText()

      // Opciones de inicio-------------------------------------------------------

      CursorWe()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), 'Imposible realizar comprobaciones iniciales' )

      lCheck   := .f.

   END SEQUENCE
   ErrorBlock( oBlock )

RETURN ( lCheck )

//---------------------------------------------------------------------------//

function lCheckSaasMode()

   local oCon
   local oQuery
   local oQuery2
   local nIdClient
   local nDaySaas          := nDaySaas()
   local lCheck            := .f.

   oCon                    := TMSConnect():New()

   if oCon:Connect( "gestool.serveftp.com", "root", "nidorino", "gestool_saas", "3306" )

      oQuery               := TMSQuery():New( oCon, "SELECT * FROM numerosserie WHERE serial='" + AllTrim( Str( Abs( nSerialHD() ) ) ) + "'" )

      if oQuery:Open() 

         // Existe el registro en la base de datos-----------------------------

         if oQuery:RecCount() > 0

            // El numero de serie no esta activo-------------------------------

            if oQuery:FieldGetByName( "activo" ) != 0

               nIdClient      := oQuery:FieldGetByName( "id_client" )

               oQuery2        := TMSQuery():New( oCon, "SELECT * FROM clientes WHERE id='" + AllTrim( Str( nIdClient ) ) + "' AND activo" )

               if oQuery2:Open() .and. oQuery2:RecCount() > 0

                  lCheck      := .t.

                  cTypeVersion( "[Saas]")

                  DeleteDaySaas()

               else 

                  // Cliente esta bloqueado------------------------------------

                  if nDaySaas > 0
                     
                     lCheck   := .t.

                     cTypeVersion( "[Saas dias: " + Alltrim( Str( nDaySaas ) ) +" ]")
                     
                     msgStop( "Le quedan " + Alltrim( Str( nDaySaas ) ) + " dias para activar su licencia", "Cliente inactivo." )

                  else 

                     cTypeVersion( "[Demo finalización licencia]" )

                     // msgStop( "Periodo de gracia expirado, el programa pasara a modo demo", "¡Atención!")

                  end if 

               end if   

            else

               // Numero de serie no esta activo ver numeros de gracia---------------


               if nDaySaas > 0
                  
                  lCheck      := .t.

                  cTypeVersion( "[Saas dias: " + Alltrim( Str( nDaySaas ) ) +" ]")
                  
                  msgStop( "Le quedan " + Alltrim( Str( nDaySaas ) ) + " dias para activar su licencia", "Licencia inactiva." )

               else 

                  cTypeVersion( "[Demo finalización licencia]" )

                  // msgStop( "Periodo de gracia expirado, el programa pasara a modo demo", "¡Atención!")

               end if 

            end if 

         end if

      end if

      oCon:Destroy()

   end if

Return ( lCheck )

//---------------------------------------------------------------------------//

Static Function SetFidelity( oBtnFidelity )

   local lFidelity            := !uFieldEmpresa( "lFidelity" )

   SetFieldEmpresa( lFidelity, "lFidelity" )

   if !Empty( oBtnFidelity )
      oBtnFidelity:lSelected  := lFidelity
      if lFidelity
         oBtnFidelity:cCaption( "Fidelity activado" )
      else
         oBtnFidelity:cCaption( "Fidelity desactivado" )
      end if
   end if

Return ( lFidelity )

//--------------------------------------------------------------------------//   

Static Function nDaySaas()

   local cRef  := "SOFTWARE\" + HB_Crypt( "Gestool", SERIALNUMBER )
   local oReg  := TReg32():Create( HKEY_LOCAL_MACHINE, cRef )
   local uVar  := oReg:Get( "Date", Date() )

   if Empty( uVar ) 
      oReg:Set( "Date", Date() )
   end if

   oReg:Close()

   if Empty( uVar )
      uVar  := Date()
   end if 
      
Return ( uVar + __DAYS__ - Date() )

//---------------------------------------------------------------------------//

Static Function DeleteDaySaas()

   local oReg
   local cRef

   cRef     := "SOFTWARE\" + HB_Crypt( "Gestool", SERIALNUMBER )
   oReg     := TReg32():Create( HKEY_LOCAL_MACHINE )
   oReg:Delete( cRef )
   oReg:Close()

Return ( nil )
 
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function MainTablet()

	local oDlg
   local nRow           
   local oGridTree
   local cAgente        := GetPvProfString( "Tablet", "Agente", "", cIniAplication() )

   nRow                 := 0
   oDlg                 := TDialog():New( 1, 5, 40, 100, "GESTOOL TABLET",,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )  

	/*
	Cabeceras------------------------------------------------------------------
   */

   TGridSay():Build(    { 	"nRow"      => nRow,;
                     		"nCol"      => {|| GridWidth( 0.5, oDlg ) },;
                     		"bText"     => {|| "Gestool tablet" },;
                     		"oWnd"      => oDlg,;
                     		"oFont"     => oGridFontBold(),;
                     		"lPixels"   => .t.,;
                     		"nClrText"  => Rgb( 0, 0, 0 ),;
                     		"nClrBack"  => Rgb( 255, 255, 255 ),;
                     		"nWidth"    => {|| GridWidth( 5, oDlg ) },;
                     		"nHeight"   => {|| GridRow() },;
                     		"lDesign"   => .f. } )

   TGridImage():Build(  {  "nTop"      => 4,;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 138 },;
                           "nWidth"    => 138,;
                           "nHeight"   => 64,;
                           "cResName"  => "Gestool",;
                           "oWnd"      => oDlg } )

   //----------------Clientes

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_user_64",;
                           "bLClicked" => {|| Customer():New():runNavigatorCustomer() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| Customer():New():runNavigatorCustomer() } } )

   //----------------Salir

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_door_open_64",;
                           "bLClicked" => {|| oDlg:End() },;
                           "oWnd"      => oDlg } )
   
   //----------------Pedidos de clientes

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_clipboard_empty_user_64",;
                           "bLClicked" => {|| OrderCustomer():New():Play() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => getConfigTraslation("Pedidos de clientes"),;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| OrderCustomer():New():Play() } } )

   //----------------Resumen diario

   if AccessCode():lSalesView

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_speech_balloon_answer_64",;
                           "bLClicked" => {|| DailySummarySales():New():Play() },;
                           "oWnd"      => oDlg } )

   end if 

   /*
   GALERÍA DE INFORMES*********************************************************
   */

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_cabinet_open_64",;
                           "bLClicked" => {|| Reporting():New():Resource() },;
                           "oWnd"      => oDlg } )

   //----------------Albaranes de clientes
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_document_empty_user_64",;
                           "bLClicked" => {|| DeliveryNoteCustomer():New():Play() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Albaranes de clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| DeliveryNoteCustomer():New():Play() } } )

   /*
   Copias de Seguridad*********************************************************
   */

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 12 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_shield_64",;
                           "bLClicked" => {|| BackupPresenter():New():Play() },;
                           "oWnd"      => oDlg } )


   //----------------Facturas
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 12 ) },;
                     		"nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                     		"nWidth"    => 64,;
                     		"nHeight"   => 64,;
                     		"cResName"  => "gc_document_text_user_64",;
                     		"bLClicked" => {|| InvoiceCustomer():New():play() },;
                     		"oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 12 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Facturas de clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| InvoiceCustomer():New():play() } } )

   //----------------Recibos---------------------------------------------------
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_briefcase2_user_64",;
                           "bLClicked" => {|| ReceiptInvoiceCustomer():New():play() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Recibos de clientes",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| ReceiptInvoiceCustomer():New():play() } } )

   //----------------Envio y recepcion

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 18 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_satellite_dish_64",;
                           "bLClicked" => {|| TSndRecInf():New():ActivateTablet() },;
                           "oWnd"      => oDlg } )

   TGridUrllink():Build({  "nTop"      => {|| GridRow( 18 ) },;
                           "nLeft"     => {|| GridWidth( 1.5, oDlg ) },;
                           "cURL"      => "Envío y recepción",;
                           "oWnd"      => oDlg,;
                           "oFont"     => oGridFont(),;
                           "lPixel"    => .t.,;
                           "nClrInit"  => nGridColor(),;
                           "nClrOver"  => nGridColor(),;
                           "nClrVisit" => nGridColor(),;
                           "bAction"   => {|| TSndRecInf():New():ActivateTablet() } } )

   //----------------Informacion empresa

   oGridTree   := TGridTreeView():Build( ;
                        {  "nTop"      => {|| GridRow( 10 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "oWnd"      => oDlg,;
                           "lPixel"    => .t.,;
                           "nWidth"    => {|| GridWidth( 17, oDlg ) },;
                           "nHeight"   => {|| GridRow( 21, oDlg ) } } )

	// Redimensionamos y activamos el diálogo----------------------------------- 

   oDlg:bResized       := {|| GridResize( oDlg ) }
   oDlg:bStart         := {|| oGridTree:Add( "Empresa : "      + uFieldEmpresa( "CodEmp" ) + "-" + uFieldEmpresa( "cNombre" ) ),;
                              oGridTree:Add( "Usuario : "      + Rtrim( oUser():cNombre() ) ),;
                              oGridTree:Add( "Delegación : "   + Rtrim( oUser():cDelegacion() ) ),;
                              oGridTree:Add( "Caja : "         + oUser():cCaja() ),;
                              oGridTree:Add( "Almacén : "      + Rtrim( oUser():cAlmacen() ) + "-" + RetAlmacen( oUser():cAlmacen() ) ),;
                              oGridTree:Add( "Agente : "       + Rtrim( cAgente ) + "-" + AllTrim( RetNbrAge( cAgente ) ) ),;
                              oGridTree:Add( "Sesión : "       + Alltrim( Transform( cCurSesion(), "######" ) ) ) } 

	ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

Function nextRow( nRow )

   nRow := nRow + 3

Return ( by( nRow ) )

//---------------------------------------------------------------------------//

Function mainTest()

<<<<<<< HEAD
=======
   /*local i
   local e
   local oDb
   local cDb
   local oCur
   local oStmt
   local cTabla      := "test"
   local cSql        := "SELECT * FROM " + cTabla + ";"
   local cIns        := "INSERT INTO " + cTabla + ;
                           " ( first, last, street, city, state, zip, hiredate, married, age, salary, notes ) "  + ;
                           "VALUES ( 'Manu', 'Exposito', 'Pico de Almanzor, 35', 'Avila', 'ES', 41700, 20161231, 0, 52, 40456.89, 'Esta es una nota cualquiera' );"
   local cCreaTabla  := "CREATE TABLE " + cTabla  + " ( " + ;
                           "idreg INTEGER PRIMARY KEY,"    + ;
                           "first       VARCHAR( 20 ),"     + ;
                           "last        VARCHAR( 20 ),"     + ;
                           "street      VARCHAR( 30 ),"     + ;
                           "city        VARCHAR( 30 ),"     + ;
                           "state       VARCHAR( 2 ),"      + ;
                           "zip         VARCHAR( 20 ),"     + ;
                           "hiredate    DATE,"             + ;
                           "married     BOOLEAN,"          + ;
                           "age         INTEGER,"          + ;
                           "salary      DECIMAL( 9, 2 ),"   + ;
                           "notes       VARCHAR( 70 ) );"

   oDb   := THDO():new( "sqlite" )
   
   cDb   := "demo.db"
=======
Return ( nil )

//---------------------------------------------------------------------------//

#define SEL_TABLE "SELECT * FROM clientes ORDER BY nombre;"
#define DEL_TABLE "DELETE FROM clientes WHERE idReg = ?;"
#define UPD_TABLE "UPDATE clientes SET Nombre = ?, Direccion = ?, Telefono = ?, Edad = ?, Productos = ?, Nivel = ? WHERE idReg = ?;"
#define INS_TABLE "INSERT INTO clientes ( Nombre, Direccion, Telefono, Edad, Productos, Nivel ) VALUES ( ?, ?, ?, ?, ?, ? );"

//----------------------------------------------------------------------------//

function TestHBO()

   local oBrush, oBar

   SET _3DLOOK ON                         // Microsoft 3D Look

   SkinButtons()

   DEFINE BRUSH oBrush STYLE TILED       // FiveWin new predefined Brushes

   DEFINE WINDOW oWnd FROM 4, 4 TO 50, 150 ;
      TITLE "HDO y FWH - Browsing power" ;
      MENU BuildMenu() ;
      BRUSH oBrush

   DEFINE BUTTONBAR oBar OF oWnd

   DEFINE BUTTON FILENAME "..\bitmaps\Exit.bmp" OF oBar ;
      ACTION If( MsgYesNo( "Do you want to End ?", "Please, Select" ), oWnd:End(), ) ;
      MESSAGE "End this session"

   DEFINE BUTTON FILENAME "..\bitmaps\Edit.bmp" OF oBar GROUP ;
      MESSAGE "Using a Browse with dynamic Bitmap selection" ACTION Clients() ;
      TOOLTIP "Edit"

   DEFINE BUTTON FILENAME "..\bitmaps\Ques2.bmp" OF oBar ;
      MESSAGE "FiveWin info" ACTION MsgAbout()

   SET MESSAGE OF oWnd TO "HDO for SQLite by Manu Exposito Version 1.00" CLOCK DATE

   ACTIVATE WINDOW oWnd 

return nil

//----------------------------------------------------------------------------//

static function BuildMenu()

   local oMenu

   MENU oMenu
>>>>>>> origin/master

      MENUITEM "&Information"
      MENU
         MENUITEM "&About..." + Chr( 9 ) + "Alt+A" ;
            ACTION MsgAbout( "HDO for SQLite by Manu Exposito", "V.1.00" ) ;
            MESSAGE "Some information about this demo" ;
            ACCELERATOR ACC_ALT, Asc( "A" ) ;
            FILENAME "..\bitmaps\16x16\info.bmp"
         SEPARATOR
         MENUITEM "&Exit demo..." ACTION ;
            If( MsgYesNo( "Do you want to end ?", "Please, Select" ), oWnd:End,) ;
            MESSAGE "End the execution of this demo"
      ENDMENU

      MENUITEM "&Clients Control" ACTION Clients()

      MENUITEM "&Utilities"
      MENU
         MENUITEM "&Calculator..." ACTION WinExec( "Calc" ) ;
            MESSAGE "Calling Windows Calculator"

         MENUITEM "C&alendar..."  ACTION WinExec( "Calendar" ) ;
            MESSAGE "Calling Windows Calendar"

         SEPARATOR

         MENUITEM "&Writing..."    ACTION WinExec( "Write" ) ;
            MESSAGE "Calling Windows Write"
      ENDMENU

   ENDMENU

return oMenu

//----------------------------------------------------------------------------//

static function Clients()

   local oDlg
   local oLbx
   local cVar

   local aHBitMaps:= { ReadBitmap( 0, "..\bitmaps\Level1.bmp" ), ; // BitMaps de 14 x 32
                       ReadBitmap( 0, "..\bitmaps\Level2.bmp" ), ;
                       ReadBitmap( 0, "..\bitmaps\Level3.bmp" ), ;
                       ReadBitmap( 0, "..\bitmaps\Level4.bmp" ),;
                       ReadBitmap( 0, "..\bitmaps\Level5.bmp" ) }
   local n

   openDataBase()

   DEFINE DIALOG oDlg FROM 3, 3 TO 26, 79 TITLE "Clients Management"

   @ 0,  1 SAY " &Clients List"  OF oDlg

   @ 1, 1 LISTBOX oLbx FIELDS aHBitmaps[ Max( 1, oRS:fieldGet( "Nivel" ) ) ],;
                              oRS:fieldGet( "Nombre" ), rtrim( oRS:fieldGet( "Direccion" ) ),;
                              oRS:fieldGet( "Telefono" ),;
                              Str( oRS:fieldGet( "Edad" ), 3 ) ;
          HEADERS    "L", "Name", "Address", "Phone", "Age" ;
          FIELDSIZES 16, 222, 213, 58, 24 ;
          SIZE 284, 137 OF oDlg

   // Lets use different row colors
   oLbx:nClrText      = { || SelColor( oRS:getValueByName( "Nivel" ) ) }
   oLbx:nClrForeFocus = { || SelColor( oRS:getValueByName( "Nivel" ) ) }
   oLbx:bRClicked     = { | nRow, nCol | ShowPopup( nRow, nCol, oLbx ) }
   // Try different line styles !!!
   oLbx:nLineStyle = 1

   oLbx:aJustify = { .f., .f., .t., .f., .t. }

   @ 8.7,  1.4 BUTTON "&New"    OF oDlg ACTION EditClient( oLbx, .t. ) ;
                                            SIZE 40, 12
   @ 8.7,  9.4 BUTTON "&Modify" OF oDlg ACTION EditClient( oLbx, .f. ) ;
                                              SIZE 40, 12
   @ 8.7, 17.4 BUTTON "&Delete" OF oDlg ACTION DelClient( oLbx )  SIZE 40, 12
   @ 8.7, 25.4 BUTTON "&Search" OF oDlg ACTION SeekClient( oLbx ) SIZE 40, 12

   @ 8.7, 33.4 BUTTON "&Print"  OF oDlg ;
      ACTION oLbx:Report( "clients Report", .t. ) ;  // .t. --> wants preview
      SIZE 40, 12

   @ 8.7, 42 BUTTON "&Exit"   OF oDlg ACTION oDlg:End()         SIZE 40, 12

   MySetBrowse( oLbx, oRS )

   ACTIVATE DIALOG oDlg CENTERED

   closeDataBase()

   AEval( aHBitmaps, { | hBmp | DeleteObject( hBmp ) } )

return nil

//----------------------------------------------------------------------------//

static function ShowPopup( nRow, nCol, oLbx )

   local oPopup

   MENU oPopup POPUP
      MENUITEM "&New"      ACTION EditClient( oLbx, .t. )
      MENUITEM "&Modify"   ACTION EditClient( oLbx, .f. )
      MENUITEM "&Delete"   ACTION DelClient( oLbx )
      MENUITEM "&Search"   ACTION SeekClient( oLbx )
      MENUITEM "&Print"    ACTION oLbx:Report( "clients Report", .t. )
      SEPARATOR
      MENUITEM "&Browse lines style"
      MENU
         MENUITEM "None    (0)" ACTION oLbx:nLineStyle := 0, oLbx:Refresh()
         MENUITEM "Black   (1)" ACTION oLbx:nLineStyle := 1, oLbx:Refresh()
         MENUITEM "Gray    (2)" ACTION oLbx:nLineStyle := 2, oLbx:Refresh()
         MENUITEM "3D      (3)" ACTION oLbx:nLineStyle := 3, oLbx:Refresh()
         MENUITEM "DOTED   (4)" ACTION oLbx:nLineStyle := 4, oLbx:Refresh()
         MENUITEM "V_BLACK (5)" ACTION oLbx:nLineStyle := 5, oLbx:Refresh()
         MENUITEM "V_GRAY  (6)" ACTION oLbx:nLineStyle := 6, oLbx:Refresh()
         MENUITEM "H_BLACK (7)" ACTION oLbx:nLineStyle := 7, oLbx:Refresh()
         MENUITEM "H_GRAY  (8)" ACTION oLbx:nLineStyle := 8, oLbx:Refresh()
      ENDMENU
      SEPARATOR
      MENUITEM "&Exit"     ACTION oLbx:oWnd:End()
   ENDMENU

   ACTIVATE POPUP oPopup AT nRow, nCol OF oLbx

return nil

//----------------------------------------------------------------------------//

static function SelColor( nNivel )

   local nColor := CLR_BLACK

   do case
      case nNivel == 1
           nColor = CLR_HRED

      case nNivel == 2
           nColor = CLR_HGREEN

      case nNivel == 3
           nColor = CLR_HBLUE
   endcase

return nColor
>>>>>>> 10704f7bbf72dcd3c05acfc5c0aa3f3005901f18


<<<<<<< HEAD
Return ( nil )
=======
   @ 3,  1 GROUP TO 7, 8 LABEL "&Products" OF oDlg
   @ 4,  2 CHECKBOX lFivePro PROMPT "&FivePro" OF oDlg
   @ 5,  2 CHECKBOX lDialog  PROMPT "&Dialog"  OF oDlg
   @ 6,  2 CHECKBOX lObjects PROMPT "&Objects" OF oDlg

   @ 3,  9 GROUP TO 7, 17 LABEL "&Nivel" OF oDlg
   @ 4,  9 RADIO nNivel PROMPT "&Novice", "A&vanced", "&Expert" OF oDlg

   @ 3.5, 23 SAY "&Phone:" OF oDlg
   @ 4, 21 GET cPhone OF oDlg SIZE 60, 11 PICTURE "@R 99-999-9999999"

   @ 5, 23 SAY "&Age:" OF oDlg
   @ 6, 21 GET nAge OF oDlg SIZE 20, 11

   @ 6,  9 BUTTON "&Acept"  OF oDlg SIZE 50, 12 ACTION ( lSave := .t. , oDlg:End() )
   @ 6, 19 BUTTON "&Cancel" OF oDlg SIZE 50, 12 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

      if lSave .and. !empty( cName )
      cProductos := If( lFivePro, "F", "" ) + If( lDialog,  "D", "" ) + If( lObjects, "O", "" )
         
         if lAppend
         oStmt := oIns
         else
         oStmt := oUpd
         oStmt:bindValue( 7, nIdReg ) // Este es solo para las actualizaciones
         endif
         
        oStmt:bindValue( 1, cName )
         oStmt:bindValue( 2, cAddress )
         oStmt:bindValue( 3, cPhone )
         oStmt:bindValue( 4, nAge )
         oStmt:bindValue( 5, cProductos )
         oStmt:bindValue( 6, nNivel )
        oStmt:execute()
      
         refresh( oLbx )
         oLbx:Refresh()          // We want the ListBox to be repainted
      else
         if Empty( cName ) .and. lSave
            MsgAlert( "Please write a name" )
         endif
         oRS:goTo( nOldRec )
      endif

return nil

//---------------------------------------------------------------------------//

static function DelClient( oLbx )

   if MsgYesNo( "Are you sure to delete this record? -> " + alltrim( oRS:fieldGet( "nombre" ) ) )
      oDel:bindValue(  1, oRS:fieldGet( "idReg" ) )
        oDel:execute()
        refresh( oLbx )
         oLbx:Refresh()  // Repaint the ListBox
   endif

<<<<<<< HEAD
   if oDb:disconnect()
      msgalert( cDb + " cerrada" )
   endif*/
//=======
return nil

//----------------------------------------------------------------------------//

static function SeekClient( oLbx )

   local cNombre := Space( 30 )
      local nRecNo  := oRS:RecNo()
      local nRec

      if MsgGet( "Search", "Customer Name", @cNombre, "..\bitmaps\lupa.bmp" )
      nRec := oRS:find( cNombre, 2, .t. )
         if nRec == 0
            MsgAlert( "I don't find that customer" )
            oRS:goTo( nRecNo )
         else
         oRS:goTo( nRec )
            UpStable( oLbx )          // Corrects same page stabilizing Bug
            oLbx:Refresh()            // Repaint the ListBox
            MsgAlert( "I find that customer in position: " + ltrim( str( nRec ) ) )
         endif
   endif
//>>>>>>> origin/master

return nil

//----------------------------------------------------------------------------//

static procedure refresh( oLbx )

      //oRS:free()
    //oRS := oSel:fetchRowSet()
    //MySetBrowse( oLbx, oRS )
   oRS:refresh()

return

//---------------------------------------------------------------------------//

static procedure openDataBase()

    oDb := THDO():new( "sqlite" )

    oDb:setAttribute( ATTR_ERRMODE, .t. )

    if oDb:connect( "HDOdemo.db" )
      oSel := oDb:prepare( SEL_TABLE ) // Crea el objeto consultar
      oIns := oDb:prepare( INS_TABLE ) // Crea el objeto para insertar
      oUpd := oDb:prepare( UPD_TABLE ) // Crea el objeto para actualizar
      oDel := oDb:prepare( DEL_TABLE ) // Crea el objeto para borrar

      oRS := oSel:fetchRowSet()
    endif

return
>>>>>>> 10704f7bbf72dcd3c05acfc5c0aa3f3005901f18

//---------------------------------------------------------------------------//

