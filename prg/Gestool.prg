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

static hDLLRich

//---------------------------------------------------------------------------//

PROCEDURE RddInit()

   ANNOUNCE RDDSYS

   REQUEST DBFCDX
   REQUEST DBFFPT
   REQUEST ADS

   REQUEST RDLMYSQL 

   REQUEST OrdKeyCount
   REQUEST OrdKeyNo
   REQUEST OrdKeyGoto

   REQUEST AdsKeyNo
   REQUEST AdsKeyCount
   REQUEST AdsGetRelKeyPos 
   REQUEST AdsSetRelKeyPos

RETURN

//---------------------------------------------------------------------------//

INIT PROCEDURE InitAplication()

   REQUEST HB_LANG_ES         // Para establecer idioma de Mensajes, fechas, etc..
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer código de página a Español (Ordenación, etc..)

   hb_langselect( "ES" )      // Para mensajes, fechas, etc..
   hb_setcodepage( "ESWIN" )  // Para ordenación (arrays, cadenas, etc..) *Requiere CodePage.lib

   loadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit

RETURN

//---------------------------------------------------------------------------//
/*
-------------------------------------------------------------------------------
//Comenzamos la parte de código que se compila para el ejecutable normal-------
-------------------------------------------------------------------------------
*/

FUNCTION Main( paramsMain, paramsSecond, paramsThird )

   local oIndex
   local oIconApp

   appParamsMain( paramsMain )

   appParamsSecond( paramsSecond )
   
   appParamsThird( paramsThird )

   appSettings()
   
   appDialogExtend() 

   appLoadAds()

   // Motor de bases de datos--------------------------------------------------

   if ( "ADMINISTRADOR" $ upper( appParamsMain() ) )
      TDataCenter():lAdministratorTask()
      RETURN ( nil )
   end if

   // Conexión con MySql------------------------------------------------------

   if !( getSQLDatabase():Connect() )
      msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )
      RETURN ( nil )
   end if 

   // Motor de bases de datos--------------------------------------------------

   if !( appConnectADS() ) 
      msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
      RETURN ( nil )
   end if

   TDataCenter():BuildData()

   mainTest()

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

         RETURN ( nil )

      case ( "REINDEXA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

         if lInitCheck()
            oIndex               := TReindex():New()
            oIndex:lMessageEnd   := .f.
            oIndex:Resource( .t. )
         end if

         RETURN ( nil )

      case ( "EMPRESA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

      case ( !empty( appParamsMain() ) .and. !empty( appParamsSecond() ) .and. !empty( appParamsThird() ) )

         Auth():guardWhereUuid( appParamsMain() )

         setEmpresa( appParamsSecond() )

         ApplicationLoad()

         controllerReportGallery( appParamsThird() )

         RETURN ( nil )

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
      RETURN .f.
   end if

   XbrNumFormat( "E", .t. )

   do case
      case ( "TACTIL" $ appParamsMain() )
         
         if UsuariosController():New():isTactilLogin()
            CreateMainTactilWindow( oIconApp )
         end if

      case ( "TABLET" $ appParamsMain() ) 

         if AccessCode():loadTableConfiguration()
            CreateMainTabletWindow( oIconApp )
         end if

      case ( "SQL" $ appParamsMain() ) 
<<<<<<< HEAD

=======
>>>>>>> fe2eb91008cea233b433eba6c64b7e8283e6949d
         if UsuariosController():New():isLogin()
            CreateMainSqlWindow( oIconApp )
         end if

      otherwise

         if UsuariosController():New():isLogin()
            CreateMainWindow( oIconApp )
         end if

   end case

   if !empty( oIconApp )
      oIconApp:end()
   end if

   // Conexión con SQL---------------------------------------------------------

   getSQLDatabase():Disconnect() 

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION controllerReportGallery( cInitOptions )

   local hReportGallery    

   do case
      case upper( cInitOptions ) == "ARTICULOS"

         if validRunReport( "reporting_articulos" )
            TFastVentasArticulos():New():Play()
         endif

      case upper( cInitOptions ) == "CLIENTES"

         if validRunReport( "reporting_clientes" )
            TFastVentasClientes():New():Play()
         endif

      case upper( cInitOptions ) == "PROVEEDORES"

         if validRunReport( "reporting_proveedores" )
            TFastComprasProveedores():New():Play()
         end if 

      case upper( cInitOptions ) == "PRODUCCION"

         if validRunReport( "reporting_produccion" )
            TFastProduccion():New():Play()
         end if 

   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION HelpTopic()

   msgStop( "Help wanted!" )

RETURN ( Nil )

//----------------------------------------------------------------------------//

FUNCTION HelpIndex()

   goWeb( __GSTHELP__ )

RETURN ( Nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION CreateMainTabletWindow()

   lDemoMode( .f. )

   if lInitCheck()
      MainTablet()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __HARBOUR__

STATIC FUNCTION CreateMainPdaWindow( oIconApp )

   /*
   Chequeo inicial de la aplicacion--------------------------------------------
   */

   lInitCheck()

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION ExecuteMainPdaWindow( oListView, oDlg )

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION CreateMainTactilWindow()

   lDemoMode( .f. )

   if !( lInitCheck() )
      RETURN nil
   end if 

   selCajTactil( , .t. )

   // Colocamos la sesion actual-----------------------------------------------

   chkTurno()

   TpvTactil():New():Activate( .t. )

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION SetFidelity( oBtnFidelity ) 

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

RETURN ( lFidelity )

//---------------------------------------------------------------------------//   
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

FUNCTION MainTablet()

	local oDlg
   local nRow           := 0           
   local cTitle         := "GESTOOL TABLET : " + uFieldEmpresa( "CodEmp" ) + "-" + uFieldEmpresa( "cNombre" )
   local oGridTree

   cCodigoAgente( GetPvProfString( "Tablet", "Agente", "", cIniAplication() ) )

   oDlg                 := TDialog():New( 1, 5, 40, 100, cTitle,,, .f., nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MINIMIZEBOX, WS_MAXIMIZEBOX ),, rgb( 255, 255, 255 ),,, .F.,, oGridFont(),,,, .f.,, "oDlg" )  

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
                           "bLClicked" => {|| runAsistenciaRemota() },;
                           "oWnd"      => oDlg } )

   //----------------Clientes--------------------------------------------------

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_user_64",;
                           "bLClicked" => {|| NeedReindex(), Customer():New():runNavigatorCustomer() },;
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
                           "bAction"   => {|| NeedReindex(), Customer():New():runNavigatorCustomer() } } )

   //----------------Salir-----------------------------------------------------

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 3 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_door_open_64",;
                           "bLClicked" => {|| oDlg:End() },;
                           "oWnd"      => oDlg } )
   
   //----------------Pedidos de clientes---------------------------------------

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 6 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_clipboard_empty_user_64",;
                           "bLClicked" => {|| NeedReindex(), OrderCustomer():New():Play() },;
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
                           "bAction"   => {|| NeedReindex(), OrderCustomer():New():Play() } } )

   //----------------Resumen diario--------------------------------------------

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
   GALERÍA DE INFORMES---------------------------------------------------------
   */

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_cabinet_open_64",;
                           "bLClicked" => {|| NeedReindex(), Reporting():New():Resource() },;
                           "oWnd"      => oDlg } )

   //----------------Albaranes de clientes-------------------------------------
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_document_empty_user_64",;
                           "bLClicked" => {|| NeedReindex(), DeliveryNoteCustomer():New():Play() },;
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
                           "bAction"   => {|| NeedReindex(), DeliveryNoteCustomer():New():Play() } } )

   /*
   Copias de Seguridad---------------------------------------------------------
   */

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 12 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_shield_64",;
                           "bLClicked" => {|| BackupPresenter():New():Play() },;
                           "oWnd"      => oDlg } )


   //----------------Facturas--------------------------------------------------
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 12 ) },;
                     		"nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                     		"nWidth"    => 64,;
                     		"nHeight"   => 64,;
                     		"cResName"  => "gc_document_text_user_64",;
                     		"bLClicked" => {|| NeedReindex(), InvoiceCustomer():New():play() },;
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
                           "bAction"   => {|| NeedReindex(), InvoiceCustomer():New():play() } } )

   //----------------Recibos---------------------------------------------------
   
   TGridImage():Build(  {  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_briefcase2_user_64",;
                           "bLClicked" => {|| NeedReindex(), ReceiptInvoiceCustomer():New():play() },;
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
                           "bAction"   => {|| NeedReindex(), ReceiptInvoiceCustomer():New():play() } } )

   //Reindexa------------------------------------------------------------------

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "GC_RECYCLE_64",;
                           "bLClicked" => {|| ReindexaPresenter():New():Play() },;
                           "oWnd"      => oDlg } )

   //----------------Envio y recepcion-----------------------------------------

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 18 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_satellite_dish_64",;
                           "bLClicked" => {|| NeedReindex(), TSndRecInf():New():ActivateTablet() },;
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
                           "bAction"   => {|| NeedReindex(), TSndRecInf():New():ActivateTablet() } } )

   //----------------Informacion empresa---------------------------------------

   oGridTree   := TGridTreeView():Build( ;
                        {  "nTop"      => {|| GridRow( 10 ) },;
                           "nLeft"     => {|| GridWidth( 0.5, oDlg ) },;
                           "oWnd"      => oDlg,;
                           "lPixel"    => .t.,;
                           "nWidth"    => {|| GridWidth( 17, oDlg ) },;
                           "nHeight"   => {|| GridRow( 21, oDlg ) } } )

	// Redimensionamos y activamos el diálogo----------------------------------- 

   oDlg:bResized        := {|| GridResize( oDlg ) }
   oDlg:bStart          := {|| StartMainTablet( oGridTree ) } 

	ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION StartMainTablet( oGridTree )

   oGridTree:Add( "Empresa : "      + uFieldEmpresa( "CodEmp" ) + "-" + uFieldEmpresa( "cNombre" ) )
   oGridTree:Add( "Usuario : "      + rtrim( oUser():cNombre() ) )
   oGridTree:Add( "Delegación : "   + rtrim( Application():CodigoDelegacion() ) )
   oGridTree:Add( "Caja : "         + Application():CodigoCaja() )
   oGridTree:Add( "Almacén : "      + rtrim( Application():codigoAlmacen() ) + "-" + RetAlmacen( Application():codigoAlmacen() ) )
   oGridTree:Add( "Agente : "       + rtrim( cCodigoAgente() ) + "-" + alltrim( RetNbrAge( cCodigoAgente() ) ) )
   oGridTree:Add( "Sesión : "       + alltrim( Transform( cCurSesion(), "######" ) ) )

   NeedReindex()

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION NeedReindex()

   local dLastReindex   
   local oReindexPresenter
   
   dLastReindex            := stod( getPvProfString( "Tablet", "LastReindex", "", cIniAplication() ) )

   if empty( dLastReindex ) .or. ( date() > dLastReindex )
      oReindexPresenter    := ReindexaPresenter():New()
      oReindexPresenter:setSyncronize( .f. )
      oReindexPresenter:Play()
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION nextRow( nRow )

   nRow := nRow + 3

RETURN ( by( nRow ) )

//---------------------------------------------------------------------------//

Function mainTest()

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION GetSysFont()

RETURN "Ms Sans Serif" 

//---------------------------------------------------------------------------//

FUNCTION getBoldFont()

   static oBoldFont 

   if empty( oBoldFont )
      oBoldFont   := TFont():New( GetSysFont(), 0, -8, .f., .t. )
   end if 

RETURN ( oBoldFont )

//---------------------------------------------------------------------------//
