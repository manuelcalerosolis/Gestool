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
   REQUEST HB_CODEPAGE_ESWIN  // Para establecer c�digo de p�gina a Espa�ol (Ordenaci�n, etc..)

   hb_langselect( "ES" )      // Para mensajes, fechas, etc..
   hb_setcodepage( "ESWIN" )  // Para ordenaci�n (arrays, cadenas, etc..) *Requiere CodePage.lib

   loadLibrary( "Riched20.dll" ) // Cargamos la libreria para richedit

RETURN

//---------------------------------------------------------------------------//
/*
-------------------------------------------------------------------------------
//Comenzamos la parte de c�digo que se compila para el ejecutable normal-------
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

   // Conexi�n con MySql------------------------------------------------------

   if !( "TABLET" $ appParamsMain() ) .and. !empty( getSQLDatabase() )

      if getSQLDatabase():Connect() 
         
         getSQLDatabase():addModels()
      
    
      else 
         
         msgStop( "No se ha podido conectar a la base de datos MySQL" + CRLF + getSQLDatabase():sayConexionInfo() )

         RETURN ( nil )

      end if 

   end if 

   // Motor de bases de datos--------------------------------------------------

   if ( "ADMINISTRADOR" $ appParamsMain() )
      TDataCenter():lAdministratorTask()
      RETURN nil
   end if

   // Motor de bases de datos--------------------------------------------------

   if !( appConnectADS() ) 
      msgStop( "Imposible conectar con GstApolo ADS data dictionary" )
      RETURN nil
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

         RETURN nil

      case ( "REINDEXA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

         if lInitCheck()
            oIndex               := TReindex():New()
            oIndex:lMessageEnd   := .f.
            oIndex:Resource( .t. )
         end if

         RETURN nil

      case ( "EMPRESA" $ appParamsMain() )

         if ( ":" $ appParamsMain() )
            cEmpUsr( Right( appParamsMain(), 2 ) )
         end if

      case ( !empty( appParamsSecond() ) .and. !empty( appParamsThird() ) )

         oUser( appParamsMain(), .f. )

         setEmpresa( appParamsSecond() )

         controllerReportGallery( appParamsThird() )

         RETURN nil

   end case

   // Obtenemos la versi�n del programa----------------------------------------

   IsStandard()
   IsProfesional()
   IsOsCommerce()

   cNameVersion()

   // Chequeamos los datos de los usuarios-------------------------------------

   if !TReindex():lFreeHandle()
      msgStop( "Existen procesos exclusivos, no se puede acceder a la aplicaci�n" + CRLF + ;
               "en estos momentos, reintentelo pasados unos segundos." )
      RETURN .f.
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

   // Conexi�n con SQLite------------------------------------------------------

   getSQLDatabase():Disconnect() 

RETURN ( nil )

//----------------------------------------------------------------------------//

STATIC FUNCTION controllerReportGallery( cInitOptions )

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

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION HelpTopic()

   msgStop( "Help wanted!" )

RETURN Nil

//----------------------------------------------------------------------------//

FUNCTION HelpIndex()

   goWeb( __GSTHELP__ )

RETURN Nil

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

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ExecuteMainPdaWindow( oListView, oDlg )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION InitMainTactilWindow()

   lDemoMode( .f. )

   selCajTactil( , .t. )

   // Colocamos la sesion actual-----------------------------------------------

   chkTurno()

   TpvTactil():New():Activate( .t. )

RETURN nil

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
   cPcnUsr        := rtrim( NetName() )

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

      //Montamos el di�logo con la im�gen de fondo--------------------------------

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
      Botones de la caja de di�logo--------------------------------------------
      */

      REDEFINE BUTTON ;
            ID       IDCANCEL ;
            OF       oDlg ;
            ACTION   ( oDlg:end() )

      /*
      Al iniciar el di�logo cargamos las im�genes de los usuarios--------------
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

FUNCTION InitBrw( oDlg, oImgUsr, oLstUsr, dbfUsr )

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

            if !Empty( ( dbfUsr )->cImagen ) .and. File( rtrim( ( dbfUsr )->cImagen ) )

               oImgUsr:Add( TBitmap():Define( , rtrim( ( dbfUsr )->cImagen ) ) )

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
//Funci�n que chequea el usuario, la clave y nos deja pasar

STATIC FUNCTION clickAccessTctCode( nOpt, oLstUsr, dbfUsr )

   local oItem

   // Chequeamos que seleccione almenos un usuario-----------------------------

   if Empty( nOpt )
      MsgStop( "Seleccione usuario" )
      RETURN .f.
   end if

   oItem       := oLstUsr:GetItem( nOpt )

   if !Empty( oItem ) .and. dbSeekInOrd( oItem:Cargo, "cCodUse", dbfUsr )

      if !( dbfUsr )->lUseUse

         // Comprobamos la clave del usuario-----------------------------------

         if lGetPsw( dbfUsr, .t. )
            RETURN .t.
         end if

      else

         MsgStop( "Usuario en uso" )

         RETURN .f.

      end if

   else

      MsgStop( "El usuario no existe" )

   end if

RETURN ( .f. )

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

      oMsgText( 'Inicializamos las clases de la aplicaci�n' )

      InitClasses()

      // Comprobamos q exista al menos un almacen---------------------------------

      oMsgText( 'Control de tablas de almac�n' )

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

FUNCTION lCheckSaasMode()

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

                     cTypeVersion( "[Demo finalizaci�n licencia]" )

                     // msgStop( "Periodo de gracia expirado, el programa pasara a modo demo", "�Atenci�n!")

                  end if 

               end if   

            else

               // Numero de serie no esta activo ver numeros de gracia---------------


               if nDaySaas > 0
                  
                  lCheck      := .t.

                  cTypeVersion( "[Saas dias: " + Alltrim( Str( nDaySaas ) ) +" ]")
                  
                  msgStop( "Le quedan " + Alltrim( Str( nDaySaas ) ) + " dias para activar su licencia", "Licencia inactiva." )

               else 

                  cTypeVersion( "[Demo finalizaci�n licencia]" )

                  // msgStop( "Periodo de gracia expirado, el programa pasara a modo demo", "�Atenci�n!")

               end if 

            end if 

         end if

      end if

      oCon:Destroy()

   end if

RETURN ( lCheck )

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

//--------------------------------------------------------------------------//   

STATIC FUNCTION nDaySaas()

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
      
RETURN ( uVar + __DAYS__ - Date() )

//---------------------------------------------------------------------------//

STATIC FUNCTION DeleteDaySaas()

   local oReg
   local cRef

   cRef     := "SOFTWARE\" + HB_Crypt( "Gestool", SERIALNUMBER )
   oReg     := TReg32():Create( HKEY_LOCAL_MACHINE )
   oReg:Delete( cRef )
   oReg:Close()

RETURN ( nil )
 
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
   GALER�A DE INFORMES---------------------------------------------------------
   */

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 9 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "gc_cabinet_open_64",;
                           "bLClicked" => {|| Reporting():New():Resource() },;
                           "oWnd"      => oDlg } )

   //----------------Albaranes de clientes-------------------------------------
   
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
   Copias de Seguridad---------------------------------------------------------
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

   //Reindexa------------------------------------------------------------------

   TGridImage():Build(  {  "nTop"      => {|| GridRow( 15 ) },;
                           "nLeft"     => {|| GridWidth( 11.5, oDlg ) - 64 },;
                           "nWidth"    => 64,;
                           "nHeight"   => 64,;
                           "cResName"  => "GC_RECYCLE_64",;
                           "bLClicked" => {|| ReindexaPresenter():New():Play() },;
                           "oWnd"      => oDlg } )

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
                           "cURL"      => "Env�o y recepci�n",;
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

	// Redimensionamos y activamos el di�logo----------------------------------- 

   oDlg:bResized       := {|| GridResize( oDlg ) }
   oDlg:bStart         := {|| oGridTree:Add( "Empresa : "      + uFieldEmpresa( "CodEmp" ) + "-" + uFieldEmpresa( "cNombre" ) ),;
                              oGridTree:Add( "Usuario : "      + rtrim( oUser():cNombre() ) ),;
                              oGridTree:Add( "Delegaci�n : "   + rtrim( oUser():cDelegacion() ) ),;
                              oGridTree:Add( "Caja : "         + oUser():cCaja() ),;
                              oGridTree:Add( "Almac�n : "      + rtrim( oUser():cAlmacen() ) + "-" + RetAlmacen( oUser():cAlmacen() ) ),;
                              oGridTree:Add( "Agente : "       + rtrim( cCodigoAgente() ) + "-" + AllTrim( RetNbrAge( cCodigoAgente() ) ) ),;
                              oGridTree:Add( "Sesi�n : "       + Alltrim( Transform( cCurSesion(), "######" ) ) ) } 

	ACTIVATE DIALOG oDlg CENTER ON INIT ( GridMaximize( oDlg ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION nextRow( nRow )

   nRow := nRow + 3

RETURN ( by( nRow ) )

//---------------------------------------------------------------------------//

Function mainTest()

Return ( nil )

//---------------------------------------------------------------------------//

FUNCTION orderTest()

    local oWnd, oBrw, oCol
    local oDb, oStmt, oRS // Objetos de HDO

    oStmt   := getSQLDatabase():query( "SELECT * FROM etiquetas ORDER BY id" )
   
    oRS     := oStmt:fetchRowSet()

    DEFINE WINDOW oWnd TITLE "Testing HDO - Fivewin"

      oBrw  := TXBrowse():New()
      
         oCol := oBrw:AddCol()
         oCol:nWidth   := 50
         oCol:bStrData := { || oRS:FieldGet( 1 ) }
         oCol:cHeader  := oRS:FieldName( 1 )

         oCol := oBrw:AddCol()
         oCol:nWidth   := 250
         oCol:bStrData := { || oRS:FieldGet( 2 ) }
         oCol:cHeader  := oRS:FieldName( 2 )

         oCol := oBrw:AddCol()
         oCol:nWidth   := 50
         oCol:bStrData := { || oRS:FieldGet( 3 ) }
         oCol:cHeader  := oRS:FieldName( 3 )

         oCol := oBrw:AddCol()
         oCol:nWidth   := 50
         oCol:bStrData := { || oRS:FieldGet( 4 ) }
         oCol:cHeader  := oRS:FieldName( 4 )

      // Asignamos los codeblock de movimiento
      
      MySetBrowse( oBrw, oRS )

      oWnd:oClient  := oBrw

      oBrw:CreateFromCode()
   
    ACTIVATE WINDOW oWnd ON INIT ( oBrw:Refresh() )

    oRS:free()
    oStmt:free()
    
RETURN nil

//---------------------------------------------------------------------------//
// Asigna los codeblock de movimiento a un Browse

STATIC FUNCTION MySetBrowse( oBrw, oRS )

   oBrw:lAutoSort := .f.
    oBrw:nDataType := DATATYPE_USER
    oBrw:bGoTop := {|| oRS:GoTop() }
    oBrw:bGoBottom := {|| oRS:GoBottom() }
    oBrw:bSkip := {| n | oRS:Skipper( n ) }
    oBrw:bBof := {|| oRS:Bof() }
    oBrw:bEof := {|| oRS:Eof() }
    oBrw:bKeyCount := {|| oRS:RecCount() }
    oBrw:bKeyNo := {| n | if( n == nil, oRS:RecNo(), oRS:GoTo( n ) ) }
    oBrw:bBookMark := oBrw:bKeyNo

   if oBrw:oVScroll() != nil
      oBrw:oVscroll():SetRange( 1, oRS:RecCount() )
   endif

   oBrw:lFastEdit := .t.

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION GetSysFont()

RETURN "Ms Sans Serif" 

//---------------------------------------------------------------------------//
