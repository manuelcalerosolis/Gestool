#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Empresa.ch"
#include "hbxml.ch"
#include "Xbrowse.ch"
#include "hbwin.ch"
#include "HdoCommon.ch"
#include "hbthread.ch"
#include "gif.ch"
#include "RichEdi5.ch"
#include "colores.ch"
#include "Constant.ch"
#include "hdo.ch"
#include "hdomysql.ch"

#define CS_DBLCLKS         8

#define NUMERO_TARIFAS     6

#command CTEXT TO VAR <v> => #pragma __cstream|<v>:=%s

#define DT_TOP              0
#define DT_LEFT             0
#define DT_CENTER           1
#define DT_RIGHT            2
#define DT_VCENTER          4
#define DT_BOTTOM           8
#define DT_WORDBREAK       16
#define DT_SINGLELINE      32
#define DT_CALCRECT      1024

#define GWL_STYLE       (-16)

memvar nId

static oPnel1

static oWnd
static oWndBar
static oDlgProgress

static oMsgUser
static oMsgDelegacion
static oMsgCaja
static oMsgSesion
static oMsgProgress

static cCodigoEmpresaEnUso 
static cCodigoDelegacionEnUso

static aEmpresa
static aDelegacion

static cCodEmp          := ""

static aMnuNext         := {}
static aMnuPrev         := {}
static aDlgEmp          := {}

static hVariables       := {=>}

static nError           := 0

static lDemoMode        := .t. 

static nHndCaj
static nHndReport

static aEmpresasGrupo   := {}

static cDefPicIn
static cDefPicOut

static lAds             := .f.
static lAIS             := .f.
static lCdx             := .f.

static cAdsIp           := ""
static cAdsPort         := ""
static cAdsData         := ""
static nAdsServer       := 7
static cAdsFile         := "Gestool.Add"

static appParamsMain    := ""
static appParamsSecond  := ""
static appParamsThird   := ""

static cCodigoAgente    := ""

static dSysDate

static cEmpUsr          := ""
static cPatGrp          := ""
static cPatCli          := ""
static cPatArt          := ""
static cPatPrv          := ""
static cPatAlm          := ""
static cPatEmp          := ""
static cPatScriptEmp    := ""
static cPatTmp          := ""
static cPathPC          := ""
static cNombrePc        := ""

static cBmpVersion
static cNameVersion
static cTypeVersion     := ""

static lStandard
static lProfesional
static lOsCommerce

static oMsgAlmacen

static cUsrTik

static oFastReport

static hMapaAjuste      :=  { "#,#0"   => { "Round" => 1,  "Incrementa" => 0.00,    "Decrementa" => 0.00,   "Ceros" => .t. } ,;
                              "#,#5"   => { "Round" => 1,  "Incrementa" => 0.05,    "Decrementa" => -0.05,  "Ceros" => .f. } ,;
                              "#,#9"   => { "Round" => 1,  "Incrementa" => 0.09,    "Decrementa" => -0.01,  "Ceros" => .f. } ,;
                              "#,10"   => { "Round" => 0,  "Incrementa" => 0.10,    "Decrementa" => -0.90,  "Ceros" => .f. } ,;
                              "#,20"   => { "Round" => 0,  "Incrementa" => 0.20,    "Decrementa" => -0.80,  "Ceros" => .f. } ,;
                              "#,50"   => { "Round" => 0,  "Incrementa" => 0.50,    "Decrementa" => -0.50,  "Ceros" => .f. } ,;
                              "#,90"   => { "Round" => 0,  "Incrementa" => 0.90,    "Decrementa" => -0.10,  "Ceros" => .f. } ,;
                              "#,95"   => { "Round" => 0,  "Incrementa" => 0.95,    "Decrementa" => -0.05,  "Ceros" => .f. } ,;
                              "#,99"   => { "Round" => 0,  "Incrementa" => 0.99,    "Decrementa" => -0.01,  "Ceros" => .f. } ,;
                              "#,00"   => { "Round" => 0,  "Incrementa" => 1.00,    "Decrementa" => -9.00,  "Ceros" => .t. } ,;
                              "1,00"   => { "Round" => -1, "Incrementa" => 11.00,   "Decrementa" => -19.00, "Ceros" => .f. } ,;
                              "5,00"   => { "Round" => -1, "Incrementa" => 15.00,   "Decrementa" => -15.00, "Ceros" => .f. } ,;
                              "9,00"   => { "Round" => -1, "Incrementa" => 19.00,   "Decrementa" => -19.00, "Ceros" => .f. } ,;
                              "10,00"  => { "Round" => -2, "Incrementa" => 110.00,  "Decrementa" => 110.00, "Ceros" => .f. } ,;
                              "20,00"  => { "Round" => -2, "Incrementa" => 120.00,  "Decrementa" => 120.00, "Ceros" => .f. } ,;
                              "50,00"  => { "Round" => -2, "Incrementa" => 150.00,  "Decrementa" => 150.00, "Ceros" => .f. } ,;
                              "100,00" => { "Round" => -3, "Incrementa" => 200.00,  "Decrementa" => 200.00, "Ceros" => .f. } }

#define FW_BOLD          700

#define ID_YES           6
#define ID_NO            7

static oWndMain, oRTF, oFont
static lBold, lItalic, lUnderline, lLink, lSuper, lSub
static lNumber, lBullet, lUpp, lProtect
static oFnt
static lRich20
static oBarR

//----------------------------------------------------------------------------//

FUNCTION oWnd() ; RETURN oWnd

//---------------------------------------------------------------------------//

FUNCTION oWndBar() ; RETURN oWndBar

//---------------------------------------------------------------------------//

FUNCTION CreateMainSQLWindow()

   LoggedTest()

   // Carga o no la imagen de fondo--------------------------------------------

   DEFINE WINDOW oWnd ;
      FROM                    0, 0 TO 26, 82;
      TITLE                   __GSTROTOR__ + " " + __GSTVERSION__ + " " + cTypeVersion() + " : " + Company():Codigo() + " - " + Company():Nombre() ;
      MDI ;
      COLORS                  Rgb( 0, 0, 0 ), Rgb( 231, 234, 238 ) ;
      ICON                    getIconApp() ;
      MENU                    ( BuildMenu() )

   oWndBar                    := CreateMainSQLAcceso( oWnd )
   oWndBar:CreateButtonBar( oWnd )

   // Set the bar messages-----------------------------------------------------

   oWnd:Cargo                 := appParamsMain()

   // Mensajes-----------------------------------------------------------------

   oWnd:oMsgBar               := TMsgBar():New( oWnd, __GSTCOPYRIGHT__ + Space(2) + cNameVersion(), .f., .f., .f., .f., Rgb( 0,0,0 ), Rgb( 255,255,255 ), oFontLittleTitle(), .f. )
   oWnd:oMsgBar:lPaint3L      := .f.

   oDlgProgress               := TMsgItem():New( oWnd:oMsgBar, "", 100, , , , .t. )

   oWnd:oMsgBar:oDate         := TMsgItem():New( oWnd:oMsgBar, Dtoc( GetSysDate() ), oWnd:oMsgBar:GetWidth( dtoc( getsysdate() ) ) + 12,,,, .t., { || SelSysDate() } )
   oWnd:oMsgBar:oDate:lTimer  := .t.
   oWnd:oMsgBar:oDate:bMsg    := {|| GetSysDate() }
   oWnd:oMsgBar:checkTimer()

   oMsgUser                   := TMsgItem():New( oWnd:oMsgBar, "Usuario : " +    rtrim( Auth():Nombre() ), 200,,,, .t. )

   oMsgDelegacion             := TMsgItem():New( oWnd:oMsgBar, "Delegación : " + rtrim( Application():codigoDelegacion() ), 200,,,, .t., {|| EnviromentController():Activate() } )

   oMsgCaja                   := TMsgItem():New( oWnd:oMsgBar, "Caja : "  +      rtrim( Box():Nombre() ), 200,,,, .t., {|| EnviromentController():Activate() } )
   
   oMsgAlmacen                := TMsgItem():New( oWnd:oMsgBar, "Almacén : " +    rtrim( Application():codigoAlmacen() ), 200,,,, .t., {|| EnviromentController():Activate() } )

   oMsgSesion                 := TMsgItem():New( oWnd:oMsgBar, "Sesión : " +     alltrim( str( Session():Numero() ) ) , 100,,,, .t., {|| EnviromentController():Activate() } ) 

   // Abrimos la ventana-------------------------------------------------------

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT                ( WndPaint( hDC, oWnd ) ); 
      ON RESIZE               ( WndResize( oWnd ) );
      ON INIT                 ( EnviromentController():New():isShow() );
      VALID                   ( EndApp() ) 

   SysRefresh()

RETURN nil

//-----------------------------------------------------------------------------//

FUNCTION BuildMenu()

   local oMenu

   MENU oMenu
   
   ENDMENU

RETURN ( oMenu )

//---------------------------------------------------------------------------//

PROCEDURE loggedTest()
/*
   local cFicheroOrigen  := '"c:\Fw195\Gestool\bin\XML\TEST1.xml"'
   local cFicheroDestino := '"c:\Fw195\Gestool\bin\XML\TEST1-signed.xml"'
   local cNif            := '"' + SELCERT() + '"'

   logwrite( fullcurdir() + 'autofirma\autofirmacommandline sign -i ' + cFicheroOrigen + ' -o ' + cFicheroDestino + ' -format facturae -store windows -alias ' + cNif )
   waitRun( fullcurdir() + 'autofirma\autofirmacommandline sign -i ' + cFicheroOrigen + ' -o ' + cFicheroDestino + ' -format facturae -store windows -alias ' + cNif )
*/
RETURN 

//----------------------------------------------------------------------------//

FUNCTION WndResize( oWnd )

   local oBlock
   local oError

   if empty( oWnd )
      RETURN ( nil )
   end if 

   oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      aeval( oWnd:oWndClient:aWnd, {|o| oWnd:oWndClient:ChildMaximize( o ) } )

      if !empty( oWndBar )
         oWndBar:CreateLogo()
      end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN nil

//-----------------------------------------------------------------------------//

FUNCTION oMsgProgress()

   if empty( oMsgProgress ) .and. !empty( oWnd() )
      oMsgProgress   := TProgress():New( 3, oDlgProgress:nLeft() - 2 , oWnd():oMsgBar, 0, , , .t., .f., oDlgProgress:nWidth - 2, 16 )
   end if

RETURN ( oMsgProgress )

//--------------------------------------------------------------------------//

FUNCTION EndProgress()

   oMsgProgress:End()

   oMsgProgress      := nil

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION Titulo( cTxt )

RETURN ( if( oWnd() != nil, oWnd():cTitle( cTxt ), "" ) )

//--------------------------------------------------------------------------//

FUNCTION oMsgSesion() ; RETURN ( oMsgSesion )

//--------------------------------------------------------------------------//

FUNCTION oMsgText( cText )

   DEFAULT cText     := __GSTCOPYRIGHT__ + Space(2) + cNameVersion()

   if empty( oWnd() )
      RETURN nil 
   end if 

   if _isData( oWnd(), "oMsgBar" ) .and. ( oWnd():oMsgBar != nil ) 
      oWnd():oMsgBar:SetMsg( cText )
   end if

RETURN ( nil )

//--------------------------------------------------------------------------//

STATIC FUNCTION EndApp()

   local oDlg
   local oBrush
   local oBtnOk
   local lFinish
   local oBtnCancel
   local oBmpVersion

   SysRefresh()

   if !empty( oWnd() )
      oWnd():CloseAll()
   end if

   SysRefresh()

   DEFINE BRUSH oBrush COLOR Rgb( 255, 255, 255 ) // FILE ( cBmpVersion() )

   DEFINE DIALOG oDlg RESOURCE "EndApp" BRUSH oBrush

      REDEFINE BITMAP oBmpVersion ;
         RESOURCE    cBmpVersion() ;
         ID          600 ;
         OF          oDlg

      oBtnOk         := ApoloBtnFlat():Redefine( IDOK, {|| oDlg:end( IDOK ) }, oDlg, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      oBtnCancel     := ApoloBtnFlat():Redefine( IDCANCEL, {|| oDlg:end()  }, oDlg, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

      oDlg:bKeyDown  := {| nKey | if( nKey == VK_F5, oDlg:end( IDOK ), ) }    

   ACTIVATE DIALOG oDlg CENTER

   if !empty( oBrush )
      oBrush:End()
   end if

   if !empty( oBmpVersion )
      oBmpVersion:End()
   end if 

   lFinish           := !empty( oDlg ) .and. ( oDlg:nResult == IDOK )

   if ( lFinish )
      FinishAplication()
   end if

RETURN ( lFinish )

//-----------------------------------------------------------------------------//
//
//Procesos de comprobaciones iniciales y lectura de archivos .INI, cuando existan
//

FUNCTION ControlAplicacion()

   local oDlg
   local oBmpPerpetua
   local oBmpSaas
   local oBmpDemo
   local oSayDemo
   local oSerialHD
   local nSerialHD
   local oSerialUSR
   local nSerialUSR
   local oLicencia
   local nlicencia      
   local oSayPerpetua   
   local oSayAlquiler   
   local cSayAlquiler   

   if lControlAcceso() 
      RETURN .t.
   end if 

   nSerialHD      := Abs( nSerialHD() )
   nSerialUSR     := 0
   nlicencia      := 1
   oSayPerpetua   := Array( 2 )
   oSayAlquiler   := Array( 8 )
   cSayAlquiler   := Array( 8 )

   DEFINE DIALOG oDlg RESOURCE "GetSerialNo" TITLE "Sistema de protección"

   REDEFINE BITMAP oBmpPerpetua ;
      RESOURCE    "gc_certificate_32" ;
      TRANSPARENT ;
      ID          500;
      OF          oDlg

   REDEFINE BITMAP oBmpSaas ;
      RESOURCE    "gc_piggy_bank_32" ;
      TRANSPARENT ;
      ID          510;
      OF          oDlg
      
   REDEFINE BITMAP oBmpDemo ;
      RESOURCE    "gc_lock2_32" ;
      TRANSPARENT ;
      ID          520;
      OF          oDlg

   /*
   Licencia perpetua-----------------------------------------------------------
   */

   REDEFINE RADIO oLicencia ;
      VAR         nLicencia ;
      ID          100, 200, 300 ;
      ON CHANGE   ( ChangeLicenciaMode( nLicencia, oSerialHd, oSerialUsr, oSayPerpetua, oSayAlquiler, oSayDemo ) ) ;
      OF          oDlg

   REDEFINE SAY   oSerialHD ;
      PROMPT      nSerialHD ;
      ID          110 ;
      OF          oDlg

   REDEFINE SAY   oSayPerpetua[1] ID 111 OF oDlg   

   REDEFINE GET   oSerialUsr ;
      VAR         nSerialUSR ;
      ID          120 ;
      IDSAY       121 ;
      PICTURE     "99999999999999" ;
      OF          oDlg

   REDEFINE SAY   oSayPerpetua[2] ID 130 OF oDlg

   /*
   Licencia Alquiler-----------------------------------------------------------
   */

   REDEFINE GET   oSayAlquiler[1] ;
      VAR         cSayAlquiler[1] ;
      ID          210 ;
      IDSAY       211 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[2] ;
      VAR         cSayAlquiler[2] ;
      ID          220 ;
      IDSAY       221 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[3] ;
      VAR         cSayAlquiler[3] ;
      ID          230 ;
      IDSAY       231 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[4] ;
      VAR         cSayAlquiler[4] ;
      ID          240 ;
      IDSAY       241 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[5] ;
      VAR         cSayAlquiler[5] ;
      ID          250 ;
      IDSAY       251 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[6] ;
      VAR         cSayAlquiler[6] ;
      ID          260 ;
      IDSAY       261 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[7] ;
      VAR         cSayAlquiler[7] ;
      ID          270 ;
      IDSAY       271 ;
      OF          oDlg

   REDEFINE GET   oSayAlquiler[8] ;
      VAR         cSayAlquiler[8] ;
      ID          280 ;
      OF          oDlg

   /*
   Licencia demo---------------------------------------------------------------
   */

   REDEFINE SAY oSayDemo ID 310 OF oDlg

   with object ( TWebBtn():Redefine( 400,,,,,  {|| goWeb( __GSTWEB__ ) }, oDlg,,,,, "LEFT",,,,, Rgb( 0, 0, 255 ), Rgb( 0, 0, 255 ),,,, "Ir a la página web de " + __GSTFACTORY__ ) )
      :SetTransparent()
      :SetText( __GSTWEB__ )
   end with 

   REDEFINE BUTTON ;
      ID          IDOK ; 
      OF          oDlg ;
      ACTION      ( ExitDialog( oDlg, nLicencia, nSerialHD, nSerialUSR, oSerialUsr, oSayAlquiler, cSayAlquiler ) )

      oDlg:bStart := {|| ChangeLicenciaMode( nLicencia, oSerialHd, oSerialUsr, oSayPerpetua, oSayAlquiler, oSayDemo ) }

   ACTIVATE DIALOG oDlg CENTER

   oBmpPerpetua:end()
   oBmpSaas:end()
   oBmpDemo:end() 

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION ExitDialog( oDlg, nLicencia, nSerialHD, nSerialUSR, oSerialUsr, oSayAlquiler, cSayAlquiler )

   local n 
   local nSerialCRC
   local aSerialCRC     := {}
   local cFileIni       := FullCurDir() + "2Ktorce.Num"

   do case
      case nLicencia == 1

         if lCheckPerpetuoMode( nSerialUSR )

            MsgInfo( "Programa registrado con éxito" )

            oDlg:End( IDOK )

         else
            
            MsgStop( "Número invalido" )

            oSerialUsr:SetFocus()

         end if 

      case nLicencia == 2

         if empty( cSayAlquiler[1] )
            MsgStop( "El campo N.I.F./ C.I.F. no puede estar vacío" )
            oSayAlquiler[1]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[2] )
            MsgStop( "El campo nombre no puede estar vacío" )
            oSayAlquiler[2]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[3] )
            MsgStop( "El campo domicilio no puede estar vacío" )
            oSayAlquiler[3]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[4] )
            MsgStop( "El campo población no puede estar vacío" )
            oSayAlquiler[4]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[5] )
            MsgStop( "El campo código postal no puede estar vacío" )
            oSayAlquiler[5]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[6] )
            MsgStop( "El campo email no puede estar vacío" )
            oSayAlquiler[6]:SetFocus()
            RETURN .f.
         end if

         if !lValidMail( cSayAlquiler[6] )
            MsgStop( "El campo email no es valido" )
            oSayAlquiler[6]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[7] )
            MsgStop( "El campo teléfono no puede estar vacío" )
            oSayAlquiler[7]:SetFocus()
            RETURN .f.
         end if

         if empty( cSayAlquiler[8] )
            MsgStop( "El campo provincia no puede estar vacío" )
            oSayAlquiler[8]:SetFocus()
            RETURN .f.
         end if

         CursorWait()

         lEnviarCorreoWatchdog( cSayAlquiler, oDlg )

         lEnviarCorreoCliente( cSayAlquiler, oDlg )

         oDlg:End( IDOK )
   
         CursorWE()

      case nLicencia == 3

         cTypeVersion( "[VERSIÓN DEMO]" )

         oDlg:End( IDOK )

   end case      

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION ChangeLicenciaMode( nLicencia, oSerialHd, oSerialUsr, oSayPerpetua, oSayAlquiler, oSayDemo )

   do case
      case nLicencia == 1

         oSerialHd:Show()
         oSerialUsr:Show()
         aEval( oSayPerpetua, { |o| o:Show() } )
         aEval( oSayAlquiler, { |o| o:Hide() } )
         oSayDemo:Hide()   

      case nLicencia == 2

         oSerialHd:Hide()
         oSerialUsr:Hide()
         aEval( oSayPerpetua, { |o| o:Hide() } )
         aEval( oSayAlquiler, { |o| o:Show() } )   
         oSayDemo:Hide()   

      case nLicencia == 3

         oSerialHd:Hide()
         oSerialUsr:Hide()
         aEval( oSayPerpetua, { |o| o:Hide() } )
         aEval( oSayAlquiler, { |o| o:Hide() } ) 
         oSayDemo:Show()   

   end case

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION About()

   local oDlg
   local oTree
   local oBrush
   local oImgLst

   DEFINE BRUSH oBrush FILE ( cBmpVersion() )

   DEFINE DIALOG oDlg RESOURCE "About" BRUSH oBrush TITLE "Acerca de " + __GSTROTOR__ + Space( 1 ) + __GSTVERSION__

      oImgLst        := TImageList():New( 24, 24 )
      oImgLst:Add( TBitmap():Define( "gc_businessman_24", ,      oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_businessman2_24", ,   oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_dude4_24", ,          oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_mail2_24", ,          oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_user_telephone_24", , oDlg ) )
      oImgLst:Add( TBitmap():Define( "gc_mail_earth_24", ,     oDlg ) )

      oTree          := TTreeView():Redefine( 100, oDlg  )
      oTree:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )

      REDEFINE SAY ID 200 COLOR Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) OF oDlg

      REDEFINE BUTTON ID IDCANCEL OF oDlg ACTION ( oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      ON INIT     (  oTree:SetImageList( oImgLst ),;
                     oTree:Add( "Manuel Calero Solís",                  0 ),;
                     oTree:Add( "Antonio Ebrero Burgos",                1 ),;
                     oTree:Add( "Dario Cruz Mauro",                     2 ),;
                     oTree:Add( "C. Ronda de legionarios, 58",          3 ),;
                     oTree:Add( "21700 - La Palma del Condado - Huelva",3 ),;
                     oTree:Add( "902 930 252",                          4 ),;
                     oTree:Add( "mcalero@gestool.es",                   5 ),;
                     oTree:Add( "aebrero@gestool.es",                   5 ),;
                     oTree:Add( "dario@gestool.es",                     5 ) ) ;
      CENTER

   oBrush:End()

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION RunAsistenciaRemota()

   local nHnd

   if File( FullCurDir() + "Client\Client.Exe" )

      nHnd     := WinExec( FullCurDir() + "Client\Client.Exe" , 1 )

      if !( nHnd > 21 .or. nHnd < 0 )
         MsgStop( "Error en la ejecución de la asistencia remota" )
      end if

   else

      goWeb( __GSTWEB__ + "/Client.exe" )

   end if

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION lEnviarCorreoWatchdog( cSay, oDlg )

RETURN ( .t. )

//---------------------------------------------------------------------------//
         
FUNCTION lEnviarCorreoCliente( cSay, oDlg )

RETURN ( .t. )

//---------------------------------------------------------------------------//
// Remember to use 'exit' procedures to asure that resources are
// freed on a possible application error

Static FUNCTION FinishAplication() //  Static FUNCTION

   CursorWait()

   // Cerramos las auditorias--------------------------------------------------

   stopServices()

   // Cerramos el Activex------------------------------------------------------

   closeWebBrowser()

   // Limpiamos los recursos estaticos-----------------------------------------

   TAcceso():End()

   TBandera():Destroy()

   freeResources()

   cursorWE()

   /* winExec( "notepad checkres.txt" ) */

RETURN nil

//---------------------------------------------------------------------------//

Static FUNCTION addMenu( oMenu, oTree )

   local n
   local cPrompt
   local oItem

   for n = 1 to len( oMenu:aItems )

      cPrompt     := oMenu:aItems[ n ]:cPrompt

      if ValType( oMenu:aItems[ n ]:bAction ) == "O"

         oItem    := oTree:add( strtran( cPrompt, "&", "" ) )
         addMenu( oMenu:aItems[ n ]:bAction, oItem )

      else

         if !empty( cPrompt )
            oItem := oTree:add( strtran( cPrompt, "&", "" ) )
         end if

      endif

   next

RETURN .t.

//----------------------------------------------------------------------------//

static FUNCTION nLeft( oMsgBar )

   local n
   local nLen  := Len( oMsgBar:aItems )
   local nPos  := oMsgBar:nRight - 3

   if nLen > 0
      for n := 1 to nLen
         nPos -= ( oMsgBar:aItems[ n ]:nWidth + 4 )
      next
   end if

RETURN nPos

//------------------------------------------------------------------------------------------------------------------------------

STATIC PROCEDURE GoToWeb()

   WinExec( "Start " + __GSTWEB__, 0 )

RETURN

//---------------------------------------------------------------------------//

static FUNCTION WndPaint( hDC, oWnd )

   local oBlock

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if !empty( oWnd ) .and. !empty( oWnd:oWndClient )

         if len( oWnd:oWndClient:aWnd ) > 0
            aTail( oWnd:oWndClient:aWnd ):SetFocus()
         end if

      end if

   RECOVER

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cNbrUsr( cNbr )

   if cNbr != nil .and. oMsgUser != nil
      oMsgUser:SetText( "Usuario : " + RTrim( cNbr ) )
   end if

RETURN cNbr

//---------------------------------------------------------------------------//

FUNCTION setCajaMessageBar( cCaja )

   if !empty( cCaja ) .and. oMsgCaja != nil
      oMsgCaja:SetText( "Caja : " + rtrim( cCaja ) )
   end if

RETURN ( cCaja )

//---------------------------------------------------------------------------//

FUNCTION setSesionMessageBar( nNumero )

   if !empty( nNumero ) .and. oMsgCaja != nil
      oMsgSesion:SetText( "Sesión : " + alltrim( str( nNumero ) ) )
   end if

RETURN ( nNumero )

//---------------------------------------------------------------------------//

FUNCTION setAlmacenMessageBar( cAlmacen )

   if cAlmacen != nil .and. oMsgAlmacen != nil
      oMsgAlmacen:SetText( "Almacén : " + rtrim( cAlmacen ) )
   end if

RETURN ( cAlmacen )

//---------------------------------------------------------------------------//

FUNCTION setDelegacionMessageBar( cDelegacion )

   if cDelegacion != nil .and. oMsgDelegacion != nil
      oMsgDelegacion:SetText( "Delegación : " + rtrim( cDelegacion ) )
   end if

RETURN ( cDelegacion )

//---------------------------------------------------------------------------//

FUNCTION EnableAcceso()

RETURN ( nil ) // if( !empty( oWndBar ), oWndBar:Enable(), ) )

//---------------------------------------------------------------------------//

FUNCTION DisableAcceso()

RETURN ( nil ) // if( !empty( oWndBar ), oWndBar:Disable(), ) )

//---------------------------------------------------------------------------//

FUNCTION CreateMainSQLAcceso()

   local oAcceso
   local oGrupo

   local oItem
   local oItemArchivo
   local oItemCompras
   local oItemAlmacen
   local oItemProduccion
   local oItemExpediente
   local oItemVentas
   local oItemTpv
   local oItemHerramientas
   local oItemAyudas
   local oItemReporting
   local oItemSQL

   oAcceso              := TAcceso():New()

   oItemArchivo         := oAcceso:Add()
   oItemArchivo:cPrompt := 'ARCHIVOS'
   oItemArchivo:cBmp    := "gc_folder_open_16"
   oItemArchivo:cBmpBig := "gc_folder_open_32"
   oItemArchivo:lShow   := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Inicio'
   oGrupo:cLittleBitmap := "gc_clock_16"
   oGrupo:cBigBitmap    := "gc_clock_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Sesiones'
   oItem:cMessage       := 'Sesiones'
   oItem:bAction        := {||SesionesController():New():ActivateNavigatorView() }
   oItem:cId            := "sesiones"
   oItem:cBmp           := "gc_clock_16"
   oItem:cBmpBig        := "gc_clock_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Empresa'
   oGrupo:cLittleBitmap := "gc_factory_16"
   oGrupo:cBigBitmap    := "gc_factory_32"

   /*oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Empresa'
   oItem:cMessage       := 'Empresas'
   oItem:bAction        := {|| EmpresasController():New():ActivateNavigatorView() }
   oItem:cId            := "empresa"
   oItem:cBmp           := "gc_factory_16"
   oItem:cBmpBig        := "gc_factory_32"
   oItem:lShow          := .f.*/

   // Articulos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:nLittleItems  := 3
   oGrupo:cPrompt       := 'Artículos'
   oGrupo:cLittleBitmap := "gc_object_cube_16"
   oGrupo:cBigBitmap    := "gc_object_cube_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Familia de articulos'
   oItem:cMessage       := 'Familia de articulos'
   oItem:bAction        := {|| ArticulosFamiliasController():New():ActivateNavigatorView() }
   oItem:cId            := "familias_articulos"
   oItem:cBmp           := "gc_cubes_16"
   oItem:cBmpBig        := "gc_cubes_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Artículos'
   oItem:cMessage       := 'Artículos'
   oItem:bAction        := {|| ArticulosController():New():ActivateNavigatorView() }
   oItem:cId            := "articulos"
   oItem:cBmp           := "gc_object_cube_16"
   oItem:cBmpBig        := "gc_object_cube_32"
   oItem:lShow          := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Categorias de artículo'
   oItem:cMessage       := 'Categorias de artículo'
   oItem:bAction        := {|| ArticulosCategoriasController():New():ActivateNavigatorView() }
   oItem:cId            := "categorias"
   oItem:cBmp           := "gc_photographic_filters_16"
   oItem:cBmpBig        := "gc_photographic_filters_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Fabricantes'
   oItem:cMessage       := 'Solicitar fabricante'
   oItem:bAction        := {|| ArticulosFabricantesController():New():ActivateNavigatorView() }
   oItem:cId            := "fabricantes"
   oItem:cBmp           := "gc_wrench_16"
   oItem:cBmpBig        := "gc_wrench_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Comentarios'
   oItem:cMessage       := 'Solicitar comentario'
   oItem:bAction        := {|| ComentariosController():New():ActivateNavigatorView() }
   oItem:cId            := "comentarios"
   oItem:cBmp           := "gc_message_16"
   oItem:cBmpBig        := "gc_message_32"
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Propiedades'
   oItem:cMessage       := 'Propiedades'
   oItem:bAction        := {|| PropiedadesController():New():ActivateNavigatorView() }
   oItem:cId            := "propiedades"
   oItem:cBmp           := "gc_coathanger_16"
   oItem:cBmpBig        := "gc_coathanger_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Caracteristicas'
   oItem:cMessage       := 'Caracteristicas'
   oItem:bAction        := {|| CaracteristicasController():New():ActivateNavigatorView() }
   oItem:cId            := "caracteristicas"
   oItem:cBmp           := "gc_tags_16"
   oItem:cBmpBig        := "gc_tags_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Unidades de medición'
   oItem:cMessage       := 'Unidades de medición'
   oItem:bAction        := {|| UnidadesMedicionController():New():ActivateNavigatorView() }
   oItem:cId            := "unidades_medicion"
   oItem:cBmp           := "gc_tape_measure2_16"
   oItem:cBmpBig        := "gc_tape_measure2_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos de unidades de medición'
   oItem:cMessage       := 'Grupos de unidades de medición'
   oItem:bAction        := {|| UnidadesMedicionGruposController():New():ActivateNavigatorView() }
   oItem:cId            := "unidades_medicion_grupos"
   oItem:cBmp           := "tab_pane_tape_measure2_16"
   oItem:cBmpBig        := "tab_pane_tape_measure2_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos de artículo'
   oItem:cMessage       := 'Tipos de artículo'
   oItem:bAction        := {|| ArticulosTipoController():New():ActivateNavigatorView() }
   oItem:cId            := "tipo_articulos"
   oItem:cBmp           := "gc_objects_16"
   oItem:cBmpBig        := "gc_objects_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Temporadas de artículo'
   oItem:cMessage       := 'Temporadas de artículo'
   oItem:bAction        := {|| ArticulosTemporadasController():New():ActivateNavigatorView() }
   oItem:cId            := "articulos_temporada"
   oItem:cBmp           := "gc_cloud_sun_16"
   oItem:cBmpBig        := "gc_cloud_sun_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Envasado'
   oItem:cMessage       := 'Envasado'
   oItem:bAction        := {|| ArticulosEnvasadoController():New():ActivateNavigatorView() }
   oItem:cId            := "envasado_articulo"
   oItem:cBmp           := "gc_box_closed_16"
   oItem:cBmpBig        := "gc_box_closed_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Tarifas------------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Tarifas'
   oGrupo:cLittleBitmap := "gc_symbol_percent_16"
   oGrupo:cBigBitmap    := "gc_symbol_percent_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tarifas'
   oItem:cMessage       := 'Tarifas'
   oItem:bAction        := {|| ArticulosTarifasController():New():ActivateNavigatorView() }
   oItem:cId            := "tarifas"
   oItem:cBmp           := "gc_money_interest_16"
   oItem:cBmpBig        := "gc_money_interest_32"
   oItem:lShow          := .f.

   // Impuestos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Impuestos'
   oGrupo:cLittleBitmap := "gc_moneybag_16"
   oGrupo:cBigBitmap    := "gc_moneybag_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Tipos de IVA'
   oItem:cMessage       := 'Tipos de IVA'
   oItem:bAction        := {|| TipoIvaController():New():ActivateNavigatorView() }
   oItem:cId            := "tipos_iva"
   oItem:cBmp           := "gc_moneybag_16"
   oItem:cBmpBig        := "gc_moneybag_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Impuestos especiales'
   oItem:cMessage       := 'Impuestos especiales'
   oItem:bAction        := {|| ImpuestosEspecialesController():New():ActivateNavigatorView() }
   oItem:cId            := "impuestos_especiales"
   oItem:cBmp           := "gc_moneybag_euro_16"
   oItem:cBmpBig        := "gc_moneybag_euro_32"
   oItem:lShow          := .f.

   // Impuestos----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:cPrompt       := 'Pagos'
   oGrupo:cLittleBitmap := "gc_currency_euro_16"
   oGrupo:cBigBitmap    := "gc_currency_euro_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Divisas monetarias'
   oItem:cMessage       := 'Divisas monetarias'
   oItem:bAction        := {|| DivisasMonetariasController():New():ActivateNavigatorView() }
   oItem:cId            := "divisas"
   oItem:cBmp           := "gc_currency_euro_16"
   oItem:cBmpBig        := "gc_currency_euro_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Metodos de pago'
   oItem:cMessage       := 'Metodos de pago'
   oItem:bAction        := {|| MetodosPagosController():New():ActivateNavigatorView() }
   oItem:cId            := "forma_pago"
   oItem:cBmp           := "gc_credit_cards_16"
   oItem:cBmpBig        := "gc_credit_cards_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cuentas de remesa'
   oItem:cMessage       := 'Cuentas de remesa'
   oItem:bAction        := {|| CuentasRemesaController():New():ActivateNavigatorView() }
   oItem:cId            := "cuentas_remesas"
   oItem:cBmp           := "gc_notebook2_16"
   oItem:cBmpBig        := "gc_notebook2_32"
   oItem:lShow          := .f.

   // Otros--------------------------------------------------------------------

   oGrupo               := TGrupoAcceso() 
   oGrupo:nBigItems     := 10
   oGrupo:cPrompt       := 'Global'
   oGrupo:cLittleBitmap := "gc_folder2_16"
   oGrupo:cBigBitmap    := "gc_folder2_32"

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cajas'
   oItem:cMessage       := 'Cajas'
   oItem:bAction        := {||CajasController():New():ActivateNavigatorView() }
   oItem:cId            := "cajas"
   oItem:cBmp           := "gc_cash_register_16"
   oItem:cBmpBig        := "gc_cash_register_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Codigos postales'
   oItem:cMessage       := 'Acceso al fichero de codigos postales'
   oItem:bAction        := {|| CodigosPostalesController():New():ActivateNavigatorView() }
   oItem:cId            := "codigos_postales"
   oItem:cBmp           := "gc_postage_stamp_16"
   oItem:cBmpBig        := "gc_postage_stamp_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Provincias'
   oItem:cMessage       := 'Acceso al fichero de grupos de provincias'
   oItem:bAction        := {|| ProvinciasController():New():ActivateNavigatorView() }
   oItem:cId            := "provincias"
   oItem:cBmp           := "gc_flag_spain_16"
   oItem:cBmpBig        := "gc_flag_spain_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Paises"
   oItem:cMessage       := "Acceso a los paises"
   oItem:bAction        := {|| PaisesController():New():ActivateNavigatorView() }
   oItem:cId            := "paises"
   oItem:cBmp           := "gc_globe_16"
   oItem:cBmpBig        := "gc_globe_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Lenguajes"
   oItem:cMessage       := "Acceso a los lenguajes"
   oItem:bAction        := {|| LenguajesController():New():ActivateNavigatorView() }
   oItem:cId            := "lenguajes"
   oItem:cBmp           := "gc_user_message_16"
   oItem:cBmpBig        := "gc_user_message_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Transportistas"
   oItem:cMessage       := "Acceso a los transportistas"
   oItem:bAction        := {|| TransportistasController():New():ActivateNavigatorView() }
   oItem:cId            := "transportistas"
   oItem:cBmp           := "gc_small_truck_16"
   oItem:cBmpBig        := "gc_small_truck_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Situaciones"
   oItem:cMessage       := "Acceso a los tipos de situaciones"
   oItem:bAction        := {|| SituacionesController():New():ActivateNavigatorView() }
   oItem:cId            := "situaciones"
   oItem:cBmp           := "gc_document_attachment_16"
   oItem:cBmpBig        := "gc_document_attachment_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Marcadores'
   oItem:cMessage       := 'Marcadores'
   oItem:bAction        := {|| TagsController():New():ActivateNavigatorView() }
   oItem:cId            := "marcadores"
   oItem:cBmp           := "gc_bookmarks_16"
   oItem:cBmpBig        := "gc_bookmarks_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de impresoras"
   oItem:cMessage       := "Acceso a los tipos de impresoras"
   oItem:bAction        := {|| TiposImpresorasController():New():ActivateNavigatorView() }
   oItem:cId            := "tipos_de_impresoras"
   oItem:cBmp           := "gc_printer2_16"
   oItem:cBmpBig        := "gc_printer2_32"
   oItem:lShow          := .f.

   oItem                := oItemArchivo:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := "Tipos de direcciones"
   oItem:cMessage       := "Acceso a los tipos de direcciones"
   oItem:bAction        := {|| DireccionesTiposController():New():ActivateNavigatorView() }
   oItem:cId            := "tipos_de_direcciones"
   oItem:cBmp           := "gc_map_route_16"
   oItem:cBmpBig        := "gc_map_route_32"
   oItem:lShow          := .f.

   // Compras-------------------------------------------------------------------

   oItemCompras         := oAcceso:Add()
   oItemCompras:cPrompt := 'COMPRAS'
   oItemCompras:cBmp    := "gc_folder_open_16"
   oItemCompras:cBmpBig := "gc_folder_open_32"
   oItemCompras:lShow   := .t.

   // Proveedores--------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Proveedores'
   oGrupo:cLittleBitmap := "gc_businessmen2_16"
   oGrupo:cBigBitmap    := "gc_businessmen2_32"

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Terceros'
   oItem:cMessage       := 'Solicitar tercero'
   oItem:bAction        := {|| TercerosController():New():ActivateNavigatorView() }
   oItem:cId            := "terceros"
   oItem:cBmp           := "gc_user_16"
   oItem:cBmpBig        := "gc_user_32"
   oItem:lShow          := .t.

   oItem                := oItemCompras:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas de compras'
   oItem:cMessage       := 'Facturas de compras'
   oItem:bAction        := {|| FacturasComprasController():New():ActivateNavigatorView() }
   oItem:cId            := "facturas_compras"
   oItem:cBmp           := "gc_document_text_businessman_16"
   oItem:cBmpBig        := "gc_document_text_businessman_32"
   oItem:lShow          := .t.

   oItemAlmacen         := oAcceso:Add()
   oItemAlmacen:cPrompt := 'ALMACENES'
   oItemAlmacen:cBmp    := "gc_folder_open_16"
   oItemAlmacen:cBmpBig := "gc_folder_open_32"
   oItemAlmacen:lShow   := .t.

   // Almacenes----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Almacenes'
   oGrupo:cLittleBitmap := "gc_package_16"
   oGrupo:cBigBitmap    := "gc_package_16"

   oItem                := oItemAlmacen:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Almacenes'
   oItem:cMessage       := 'Almacenes'
   oItem:bAction        := {|| AlmacenesController():New():ActivateNavigatorView() }
   oItem:cId            := "almacenes"
   oItem:cBmp           := "gc_warehouse_16"
   oItem:cBmpBig        := "gc_warehouse_32"
   oItem:lShow          := .f.

   // Ventas-------------------------------------------------------------------

   oItemVentas          := oAcceso:Add()
   oItemVentas:cPrompt  := 'VENTAS'
   oItemVentas:cBmp     := "gc_folder_open_16"
   oItemVentas:cBmpBig  := "gc_folder_open_32"
   oItemVentas:lShow    := .t.

   // Clientes----------------------------------------------------------------

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 5
   oGrupo:cPrompt       := 'Clientes'
   oGrupo:cLittleBitmap := "gc_user_16"
   oGrupo:cBigBitmap    := "gc_user_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Grupos de terceros'
   oItem:cMessage       := 'Grupos de terceros'
   oItem:bAction        := {|| TercerosGruposController():New():ActivateNavigatorView() }
   oItem:cId            := "grupos_terceros"
   oItem:cBmp           := "gc_users3_16"
   oItem:cBmpBig        := "gc_users3_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Rutas'
   oItem:cMessage       := 'Rutas'
   oItem:bAction        := {|| RutasController():New():ActivateNavigatorView() }
   oItem:cId            := "rutas"
   oItem:cBmp           := "gc_map_route_16"
   oItem:cBmpBig        := "gc_map_route_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Terceros'
   oItem:cMessage       := 'Solicitar tercero'
   oItem:bAction        := {|| TercerosController():New():ActivateNavigatorView() }
   oItem:cId            := "terceros"
   oItem:cBmp           := "gc_user_16"
   oItem:cBmpBig        := "gc_user_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Agentes'
   oItem:cMessage       := 'Solicitar agente'
   oItem:bAction        := {|| AgentesController():New():ActivateNavigatorView() }
   oItem:cId            := "agentes"
   oItem:cBmp           := "gc_businessman2_16"
   oItem:cBmpBig        := "gc_businessman2_32"
   oItem:lShow          := .f.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Entidades'
   oItem:cMessage       := 'Entidades'
   oItem:bAction        := {||EntidadesController():New():ActivateNavigatorView() }
   oItem:cId            := "entidades"
   oItem:cBmp           := "gc_office_building2_16"
   oItem:cBmpBig        := "gc_office_building2_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 1
   oGrupo:cPrompt       := 'Ventas'
   oGrupo:cLittleBitmap := "gc_notebook_user_16"
   oGrupo:cBigBitmap    := "gc_notebook_user_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Facturas de ventas'
   oItem:cMessage       := 'Facturas de ventas'
   oItem:bAction        := {|| FacturasVentasController():New():ActivateNavigatorView() }
   // oItem:bAction        := {|| FacturasVentasController1000() }
   oItem:cId            := "facturas_ventas"
   oItem:cBmp           := "gc_document_text_user_16"
   oItem:cBmpBig        := "gc_document_text_user_32"
   oItem:lShow          := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:cPrompt       := 'Cobros'
   oGrupo:cLittleBitmap := "gc_briefcase2_user_16"
   oGrupo:cBigBitmap    := "gc_briefcase2_user_32"

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Recibos'
   oItem:cMessage       := 'Recibos'
   oItem:bAction        := {||RecibosController():New():ActivateNavigatorView() }
   oItem:cId            := "recibos"
   oItem:cBmp           := "gc_briefcase2_user_16"
   oItem:cBmpBig        := "gc_briefcase2_user_32"
   oItem:lShow          := .t.

   oItem                := oItemVentas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cobros'
   oItem:cMessage       := 'Cobros'
   oItem:bAction        := {||PagosController():New():ActivateNavigatorView() }
   oItem:cId            := "cobros"
   oItem:cBmp           := "gc_hand_money_16"
   oItem:cBmpBig        := "gc_hand_money_32"
   oItem:lShow          := .t.


   // TPV----------------------------------------------------------------------

   oItemTpv             := oAcceso:Add()
   oItemTpv:cPrompt     := 'T.P.V.'
   oItemTpv:cBmp        := "gc_folder_open_16"
   oItemTpv:cBmpBig     := "gc_folder_open_32"
   oItemTpv:lShow       := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'T.P.V.'
   oGrupo:cLittleBitmap := "gc_cash_register_user_16"
   oGrupo:cBigBitmap    := "gc_cash_register_user_32"

   oItem                := oItemTpv:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Entradas y salidas'
   oItem:cMessage       := 'Entradas y salidas'
   oItem:bAction        := {||EntradaSalidaController():New():ActivateNavigatorView() }
   oItem:cId            := "entradas_salidas"
   oItem:cBmp           := "gc_cash_register_refresh_16"
   oItem:cBmpBig        := "gc_cash_register_refresh_32"
   oItem:lShow          := .f.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Orden de comandas'
   oItem:cMessage       := 'Orden de comandas'
   oItem:bAction        := {||OrdenComandasController():New():ActivateNavigatorView() }
   oItem:cId            := "orden_comandas"
   oItem:cBmp           := "gc_sort_az_descending_16"
   oItem:cBmpBig        := "gc_sort_az_descending_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nLittleItems  := 1
   oGrupo:cPrompt       := 'Útiles'
   oGrupo:cLittleBitmap := "gc_window_pencil_16"
   oGrupo:cBigBitmap    := "gc_window_pencil_32"

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Balanzas'
   oItem:cMessage       := 'Balanzas'
   oItem:bAction        := {||BalanzasController():New():ActivateNavigatorView() }
   oItem:cId            := "balanzas"
   oItem:cBmp           := "gc_balance_16"
   oItem:cBmpBig        := "gc_balance_32"
   oItem:lLittle        := .t.

   oItem                := oItemTPV:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Cajón portamonedas'
   oItem:cMessage       := 'Cajón portamonedas'
   oItem:bAction        := {|| CajonesPortamonedasController():New():ActivateNavigatorView() }
   oItem:cId            := "cajon_portamonedas"
   oItem:cBmp           := "gc_modem_screw_16"
   oItem:cBmpBig        := "gc_modem_screw_32"
   oItem:lShow          := .f.
   oItem:lLittle        := .t.

   // Herramientas-------------------------------------------------------------

   oItemHerramientas          := oAcceso:Add()
   oItemHerramientas:cPrompt  := 'HERRAMIENTAS'
   oItemHerramientas:cBmp     := "gc_folder_open_16"
   oItemHerramientas:cBmpBig  := "gc_folder_open_32"
   oItemHerramientas:lShow    := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3

   oGrupo:cPrompt       := 'Usuarios, roles y permisos'
   oGrupo:cLittleBitmap := "gc_document_text_screw_16"
   oGrupo:cBigBitmap    := "gc_document_text_screw_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Usuarios'
   oItem:cMessage       := 'Acceso a los usuarios del programa'
   oItem:bAction        := {|| UsuariosController():New():ActivateNavigatorView() }
   oItem:cId            := "usuarios"
   oItem:cBmp           := "gc_businesspeople_16"
   oItem:cBmpBig        := "gc_businesspeople_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Roles'
   oItem:cMessage       := 'Roles'
   oItem:bAction        := {|| RolesController():New():ActivateNavigatorView() }
   oItem:cId            := "usuarios_roles"
   oItem:cBmp           := "GC_ID_CARDS_16"
   oItem:cBmpBig        := "GC_ID_CARDS_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Permisos'
   oItem:cMessage       := 'Permisos'
   oItem:bAction        := {|| PermisosController():New():ActivateNavigatorView() }
   oItem:cId            := "usuarios_permisos"
   oItem:cBmp           := "GC_ID_BADGE_16"
   oItem:cBmpBig        := "GC_ID_BADGE_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Útiles'
   oGrupo:cLittleBitmap := "gc_notebook2_16"
   oGrupo:cBigBitmap    := "gc_notebook2_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Campos extra'
   oItem:cMessage       := 'Solicitar campos extra'
   oItem:bAction        := {|| CamposExtraController():New():ActivateNavigatorView() }
   oItem:cId            := "campos_extra"
   oItem:cBmp           := "gc_form_plus2_16"
   oItem:cBmpBig        := "gc_form_plus2_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Listín telefónico'
   oItem:cMessage       := 'Acceso al listín telefónico'
   oItem:bAction        := {|| ListinController():New():ActivateNavigatorView() }
   oItem:cId            := "listin_telefonico"
   oItem:cBmp           := "gc_book_telephone_16"
   oItem:cBmpBig        := "gc_book_telephone_32"
   oItem:lShow          := .f.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 2
   oGrupo:cPrompt       := 'Servidor'
   oGrupo:cLittleBitmap := "gc_notebook2_16"
   oGrupo:cBigBitmap    := "gc_notebook2_32"

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Iniciar servidor web'
   oItem:cMessage       := 'Iniciar servidor web'
   oItem:bAction        := {|| StartServer() }
   oItem:cId            := "iniciar_servidor"
   oItem:cBmp           := "gc_book_telephone_16"
   oItem:cBmpBig        := "gc_book_telephone_32"
   oItem:lShow          := .f.

   oItem                := oItemHerramientas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Parar servidor web'
   oItem:cMessage       := 'Parar servidor web'
   oItem:bAction        := {|| StopServer() }
   oItem:cId            := "parar_servidor"
   oItem:cBmp           := "gc_book_telephone_16"
   oItem:cBmpBig        := "gc_book_telephone_32"
   oItem:lShow          := .f.

   // Ayudas-------------------------------------------------------------------

   oItemAyudas          := oAcceso:Add()
   oItemAyudas:cPrompt  := 'AYUDAS'
   oItemAyudas:cBmp     := "gc_folder_open_16"
   oItemAyudas:cBmpBig  := "gc_folder_open_32"
   oItemAyudas:lShow    := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 3
   oGrupo:cPrompt       := 'Ayudas'
   oGrupo:cLittleBitmap := "gc_lifebelt_16"
   oGrupo:cBigBitmap    := "gc_lifebelt_32"

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Visitar web'
   oItem:cMessage       := 'Visitar web'
   oItem:bAction        := {|| goWeb( __GSTWEB__ ) }
   oItem:cId            := "visitar_web"
   oItem:cBmp           := "gc_earth_16"
   oItem:cBmpBig        := "gc_earth_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Acerca de...'
   oItem:cMessage       := 'Datos sobre el autor'
   oItem:bAction        := {|| About() }
   oItem:cId            := "acerca_de"
   oItem:cBmp           := "gc_question_16"
   oItem:cBmpBig        := "gc_question_32"
   oItem:lShow          := .f.

   oItem                := oItemAyudas:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "asistencia_remota"
   oItem:cBmp           := "gc_user_headset_16"
   oItem:cBmpBig        := "gc_user_headset_32"
   oItem:lShow          := .f.

RETURN ( oAcceso )

//---------------------------------------------------------------------------//

FUNCTION CreateAdminSQLAcceso()

   local oItem
   local oGrupo
   local oAcceso
   local oItemGeneral

   oAcceso                             := TAcceso():New()
   oAcceso:lCreateEmpresaOfficeBar     := .f.
   oAcceso:lCreateFavoritosOfficeBar   := .f.

   oItemGeneral         := oAcceso:Add()
   oItemGeneral:cPrompt := 'General'
   oItemGeneral:cBmp    := "gc_folder_open_16"
   oItemGeneral:cBmpBig := "gc_folder_open_32"
   oItemGeneral:lShow   := .t.

   oGrupo               := TGrupoAcceso()
   oGrupo:nBigItems     := 7
   oGrupo:cPrompt       := ''
   oGrupo:cLittleBitmap := "gc_factory_16"
   oGrupo:cBigBitmap    := "gc_factory_32"

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Empresa'
   oItem:cMessage       := 'Empresas'
   oItem:bAction        := {|| EmpresasController():New():ActivateNavigatorView() }
   oItem:cId            := "empresa"
   oItem:cBmp           := "gc_factory_16"
   oItem:cBmpBig        := "gc_factory_32"
   oItem:lShow          := .f.

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Usuarios'
   oItem:cMessage       := 'Acceso a los usuarios del programa'
   oItem:bAction        := {|| UsuariosController():New():ActivateNavigatorView() }
   oItem:cId            := "usuarios"
   oItem:cBmp           := "gc_businesspeople_16"
   oItem:cBmpBig        := "gc_businesspeople_32"
   oItem:lShow          := .f.

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Roles'
   oItem:cMessage       := 'Roles'
   oItem:bAction        := {|| RolesController():New():ActivateNavigatorView() }
   oItem:cId            := "usuarios_roles"
   oItem:cBmp           := "gc_id_cards_16"
   oItem:cBmpBig        := "gc_id_cards_32"
   oItem:lShow          := .f.

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Permisos'
   oItem:cMessage       := 'Permisos'
   oItem:bAction        := {|| PermisosController():New():ActivateNavigatorView() }
   oItem:cId            := "usuarios_permisos"
   oItem:cBmp           := "gc_id_badge_16"
   oItem:cBmpBig        := "gc_id_badge_32"
   oItem:lShow          := .f.

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Campos extra'
   oItem:cMessage       := 'Solicitar campos extra'
   oItem:bAction        := {|| CamposExtraGestoolController():New():ActivateNavigatorView() }
   oItem:cId            := "campos_extra"
   oItem:cBmp           := "gc_form_plus2_16"
   oItem:cBmpBig        := "gc_form_plus2_32"
   oItem:lShow          := .f.

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Asistencia remota'
   oItem:cMessage       := 'Solicitar asistencia remota'
   oItem:bAction        := {|| RunAsistenciaRemota() }
   oItem:cId            := "asistencia_remota"
   oItem:cBmp           := "gc_user_headset_16"
   oItem:cBmpBig        := "gc_user_headset_32"
   oItem:lShow          := .f.

   oItem                := oItemGeneral:Add()
   oItem:oGroup         := oGrupo
   oItem:cPrompt        := 'Salir'
   oItem:cMessage       := 'Salir'
   oItem:bAction        := {|| if( !empty( oWnd() ), oWnd():End(), ) }
   oItem:cId            := "asistencia_remota"
   oItem:cBmp           := "gc_door_open2_16"
   oItem:cBmpBig        := "gc_door_open2_32"
   oItem:lShow          := .f.

RETURN ( oAcceso )

//---------------------------------------------------------------------------//

FUNCTION IsReport()

RETURN ( .f. )

//---------------------------------------------------------------------------//

FUNCTION validRunReport( cOption )

   if nAnd( Auth():Level( cOption ), 1 ) == 0
      msgStop( "Acceso no permitido." )
      RETURN .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//

FUNCTION cBmpVersion() 

   if isNil( cBmpVersion )

      do case
         case file( FullCurDir() + "scmmrc" )

            cBmpVersion      := "gc_GestoolPrestashop"

         case file( FullCurDir() + "prfsnl" )

            cBmpVersion      := "GestoolPro"

         case file( FullCurDir() + "stndrd" )

            cBmpVersion      := "GestoolStandard"

         otherwise

            cBmpVersion      := "GestoolLite"

      end case

   end if

RETURN ( cBmpVersion ) 

//---------------------------------------------------------------------------//
/*
Guardamos el nombre de la versión
*/

FUNCTION cNameVersion()

   if IsNil( cNameVersion )

      do case
         case File( FullCurDir() + "scmmrc" )

            cNameVersion      := "PrestaShop 1.6"

         case File( FullCurDir() + "prfsnl" )

            cNameVersion      := "Profesional"

         case File( FullCurDir() + "stndrd" )

            cNameVersion      := "Standard"

         otherwise

            cNameVersion      := "Lite"

      end case

   end if

RETURN ( cNameVersion )

//---------------------------------------------------------------------------//

FUNCTION cTypeVersion( cType )

   if !empty( cType )
      cTypeVersion   := cType
   end if 

RETURN ( cTypeVersion )

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Oscommerce
*/

FUNCTION IsOsCommerce()

   if IsNil( lOsCommerce )

      if File( FullCurDir() + "scmmrc" )
         lOsCommerce       := .t.
      else
         lOsCommerce       := .f.
      end if

   end if

RETURN lOsCommerce

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Profesional
*/

FUNCTION IsProfesional()

   if IsNil( lProfesional )

      if File( FullCurDir() + "scmmrc" ) .or.;
         File( FullCurDir() + "prfsnl" )
         lProfesional     := .t.
      else
         lProfesional      := .f.
      end if

   end if

RETURN lProfesional

//---------------------------------------------------------------------------//
/*
Damos valor a la estatica para la versión Standard
*/

FUNCTION IsStandard()

   if IsNil( lStandard )

      if File( FullCurDir() + "scmmrc" ) .or.; 
         File( FullCurDir() + "prfsnl" ) .or.;
         File( FullCurDir() + "stndrd" )

         lStandard     := .t.

      else
         lStandard     := .f.
      end if

   end if

RETURN lStandard

//---------------------------------------------------------------------------//

FUNCTION appCheckDirectory()

   local hDirectory

   for each hDirectory in getScafolding()
      checkDirectory( hDirectory )
   next 

RETURN ( nil )

//---------------------------------------------------------------------------//

STATIC FUNCTION checkDirectory( hDirectory )

   if empty( hget( hDirectory, "Directory" ) )
      RETURN ( nil )
   end if 

   if !lIsDir( hget( hDirectory, "Directory" ) )      
      makedir( cNamePath( hget( hDirectory, "Directory" ) ) )
   end if 

   if hhaskey( hDirectory, "Subdirectory" )
      checkDirectory( hget( hDirectory, "Subdirectory" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

FUNCTION Ejecutascript()

   Local u
   Local pHrb
   Local dFecha
   local cScript  
   local aScripts

   /*
   Comprobaciones iniciales antes de mandar el script--------------------------
   */

   dFecha         := cToD( GetPvProfString( "SCRIPT", "Fecha",    "", cIniAplication() ) )

   /*
   Ejecutamos el script--------------------------------------------------------
   */

   if dFecha  < GetSysDate()

      aScripts    := directory( cPatScript() + "*.hrb" )
      if len( aScripts ) > 0
         for each cScript in aScripts
            TScripts():RunScript( cPatScript() + cScript[1] )
         next
      end if

   end if

   /*
   Anotamos la fecha del último Envío de  script-------------------------------
   */

   WritePProString( "SCRIPT", "Fecha", Dtoc( GetSysDate() ), cIniAplication() )

RETURN u

//---------------------------------------------------------------------------//
/*
Ejecuta un fichero .hrb creado a partir de un .prg directamente
c:\xharbour\bin>harbour c:\test.prg /gh /n
*/

FUNCTION DirectEjecutaScript()

   Local u
   Local pHrb
   local aScripts
   local cScript  := ""

   /*
   Cerramos todas las ventanas antes de entrar---------------------------------
   */

   if !empty( oWnd() )
      SysRefresh(); oWnd():CloseAll(); SysRefresh()
   end if

   /*
   Comprobaciones iniciales antes de mandar el script--------------------------
   */

   aScripts       := Directory( cPatScript() + "*.hrb" )

   if Len( aScripts ) > 0

      for each cScript in aScripts

         TScripts():RunScript( cPatScript() + cScript[1] )

      next

   end if

RETURN u

//---------------------------------------------------------------------------//

FUNCTION InitClasses()

RETURN .t.

//--------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
// Comprobaciones iniciales

FUNCTION lInitCheck( oMessage, oProgress )

   local oError
   local lCheck      := .t.

   CursorWait()

   if !empty( oProgress )
      oProgress:SetTotal( 4 )
   end if

   // Comprobamos que exista los directorios necesarios------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Comprobando directorios' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   appCheckDirectory()

   // Selección de la empresa actual------------------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Selección de la empresa actual' ) 
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   SQLAjustableModel():getUsuarioEmpresa( Auth():Uuid() )

   // Selección de los datos de la aplicacion----------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Selección de datos de la aplicación' ) 
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   Application()

   // Eventos del inicio---------------------------------

   if !empty( oMessage )
      oMessage:SetText( 'Comprobaciones finalizadas' )
   end if

   if !empty( oProgress )
      oProgress:AutoInc()
   end if

   runEventScript( "IniciarAplicacion" )

   CursorWe()

RETURN ( lCheck )

//---------------------------------------------------------------------------//

FUNCTION InitServices()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION StopServices()

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION lDemoMode( lDemo )

   if lDemo != nil
      lDemoMode   := lDemo
   end if

RETURN ( lDemoMode )

//---------------------------------------------------------------------------//

FUNCTION nAjuste( nNumber, cAdjust )

   local n
   local nAjusteDecimales
   local nAjusteIncrementa
   local nAjusteDecrementa
   local cNumber
   local nResult
   local cResult
   local aAdjust
   local aNumber        := {}

   if empty( nNumber )
      RETURN ( 0 )
   end if 

   /*
   Posible ajuste doble--------------------------------------------------------
   */

   nResult              := 0
   aAdjust              := hb_aTokens( cAdjust, "|" )

   for each cAdjust in aAdjust

      nAjusteDecimales  := nAjusteDecimales( cAdjust )
      nAjusteIncrementa := nAjusteIncrementa( cAdjust )
      nAjusteDecrementa := nAjusteDecrementa( cAdjust )

      if !empty(nAjusteDecimales)

        nResult         := Round( nNumber, nAjusteDecimales )

        if nResult - nNumber > 0
           nResult      += nAjusteDecrementa
        else 
           nResult      += nAjusteIncrementa 
        end if 

        aAdd( aNumber, nResult )

      end if 

   next 

   for each n in aNumber
      if ( ( n - nNumber ) >= -0.000001 )
         nResult        := n
         exit 
      end if 
   next

RETURN ( nResult )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteDecimales( cAjuste )

  local hAjuste
  local nAjusteDecimales

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteDecimales  := hGet( hAjuste, "Round" )
    end if
  end if

RETURN ( nAjusteDecimales )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteIncrementa( cAjuste )

  local hAjuste
  local nAjusteIncrementa

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteIncrementa := hGet( hAjuste, "Incrementa" )
    end if
  end if

RETURN ( nAjusteIncrementa )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteDecrementa( cAjuste )

  local hAjuste
  local nAjusteDecrementa

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteDecrementa := hGet( hAjuste, "Decrementa" )
    end if
  end if

RETURN ( nAjusteDecrementa )

//---------------------------------------------------------------------------//

Static FUNCTION nAjusteCeros( cAjuste )

  local hAjuste
  local nAjusteCeros

  if hHasKey( hMapaAjuste, cAjuste )
    hAjuste             := hGet( hMapaAjuste, cAjuste )
    if !empty( hAjuste )
      nAjusteCeros      := hGet( hAjuste, "Ceros" )
    end if
  end if

RETURN ( nAjusteCeros )

//---------------------------------------------------------------------------//

FUNCTION lAds( lSetAds )

   if IsLogic( lSetAds )
      lAds     := lSetAds
   end if

RETURN ( lAds )

//----------------------------------------------------------------------------//

FUNCTION lAIS( lSetAIS )

   if IsLogic( lSetAIS )
      lAIS     := lSetAIS
   end if

RETURN ( lAIS )

//----------------------------------------------------------------------------//

FUNCTION lAdsRdd()

RETURN ( lAds() .or. lAIS() )

//----------------------------------------------------------------------------//

FUNCTION cFieldTimeStamp()

RETURN ( if( lAdsRdd(), "Timestamp", "T" ) )

//----------------------------------------------------------------------------//

FUNCTION cAdsIp( cSetIp )

   if IsChar( cSetIp )
      cAdsIp      := cSetIp
   end if

RETURN ( cAdsIp )

//----------------------------------------------------------------------------//

FUNCTION cAdsPort( cPort )

   if isChar( cPort )
      cAdsPort  := cPort
   end if 

RETURN ( cAdsPort )

//----------------------------------------------------------------------------//

FUNCTION cAdsData( cSetData )

   if IsChar( cSetData )
      cAdsData  := cSetData
   end if

RETURN ( if( !empty( cAdsData ), cPath( cAdsData ), "" ) )

//----------------------------------------------------------------------------//

FUNCTION nAdsServer( nServer )

   if IsNum( nServer )
      nAdsServer  := nServer
   end if

RETURN ( nAdsServer )

//----------------------------------------------------------------------------//

FUNCTION cAdsUNC()

RETURN ( cAdsIp() + cPath( cAdsData() ) )

//----------------------------------------------------------------------------//

FUNCTION cAdsFile( cFile )

   if ( isChar( cFile ) .and. !empty( cFile ) )
      cAdsFile    := cFile
   end if 

RETURN ( cAdsFile )

//----------------------------------------------------------------------------//

FUNCTION lCdx( lSetCdx )

   if IsLogic( lSetCdx )
      lCdx     := lSetCdx
   end if

RETURN ( lCdx )

//---------------------------------------------------------------------------//

FUNCTION cCodigoAgente( cAgente )

   if IsChar( cAgente )
      cCodigoAgente    := cAgente
   end if

RETURN ( cCodigoAgente )

//----------------------------------------------------------------------------//

FUNCTION lPda()

RETURN ( "PDA" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION SetIndexToADSCDX()

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION SetIndexToCDX()

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION SetIndexToADS()

   lCdx( .f. )
   lAIS( .t. )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION cDriver()

   if lAIS() .or. lAds()
      RETURN ( 'ADS' )
   end if

RETURN ( 'DBFCDX' )

//---------------------------------------------------------------------------//

FUNCTION cADSDriver()

RETURN ( 'ADS' )

//---------------------------------------------------------------------------//

FUNCTION isADSDriver( cDriver )

  DEFAULT cDriver   := cDriver()

RETURN ( cDriver == 'ADS' )

//---------------------------------------------------------------------------//

FUNCTION cLocalDriver()

RETURN ( 'DBFCDX' )

//---------------------------------------------------------------------------//

FUNCTION cNombrePc( xValue )

   if !empty( xValue )
      cNombrePc   := xValue
   end if

RETURN ( cNombrePc )

//--------------------------------------------------------------------------//

FUNCTION CacheRecords( cAlias )

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cPathDatos()

RETURN ( "Datos" )

//---------------------------------------------------------------------------//

FUNCTION cFullPathEmpresa()

  local cCodigoEmpresa  := ""

  cCodigoEmpresa        += fullCurDir()
  cCodigoEmpresa        += cPatEmp
  cCodigoEmpresa        += "\"
  
RETURN ( cCodigoEmpresa )

//---------------------------------------------------------------------------//

FUNCTION cPatDat( lFull )

   DEFAULT lFull  := .f.

   if lAIS() 
      RETURN ( if( lFull, cAdsUNC() + cPathDatos() + "\", cPathDatos() ) )
   end if

RETURN ( fullCurDir() + cPathDatos() + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatADS( lFull )

   DEFAULT lFull  := .f.

   if lAIS()
      RETURN ( if( lFull, cAdsUNC() + getSinglePathADS(), getSinglePathADS() ) )
   end if

RETURN ( fullCurDir() + getSinglePathADS() )

//----------------------------------------------------------------------------//

FUNCTION getSinglePathADS()

RETURN ( "ADS\" )

//----------------------------------------------------------------------------//

FUNCTION cPatEmpTmp( lShort )

   DEFAULT lShort  := .f.

   if lAds()
      RETURN ( cAdsUNC() + "EmpTmp\" )
   end if

RETURN ( if( !lShort, fullCurDir(), "" ) + "EmpTmp\" )

//----------------------------------------------------------------------------//

FUNCTION cPatEmpOld( cCodEmp )

   if lAds()
      RETURN ( cAdsUNC() + "Emp" + cCodEmp + "\" )
   end if

RETURN ( fullCurDir() + "Emp" + cCodEmp + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatGrpOld( cCodGrp )

   if lAds()
      RETURN ( cAdsUNC() + "Emp" + cCodGrp + "\" )
   end if

RETURN ( fullCurDir() + "Emp" + cCodGrp + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatTmp()

   if empty( cPatTmp )

      cPatTmp     := GetEnv( 'TEMP' )

      if empty( cPatTmp )
         cPatTmp  := GetEnv( 'TMP' )
      endif

      if empty( cPatTmp ) .or. ! lIsDir( cPatTmp )
         cPatTmp  := GetWinDir()
      endif

      cPatTmp     += If( Right( cPatTmp, 1 ) == '\', '', '\' ) + 'Apolo'

      if !lIsDir( cPatTmp )
         MakeDir( cPatTmp )
      endif

      if Right( cPatTmp, 1 ) != '\'
         cPatTmp  += '\'
      end if

   end if

RETURN ( cPatTmp )

//----------------------------------------------------------------------------//

FUNCTION cPatIn( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "In\" )

//---------------------------------------------------------------------------//

FUNCTION cPatInFrq( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "InFrq\" )

//---------------------------------------------------------------------------//

FUNCTION cPatScript( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Script\" )

//---------------------------------------------------------------------------//

FUNCTION cPatScriptEmp( cPath, lShort )

   DEFAULT cPath    := ""
   DEFAULT lShort   := .f.

   if !empty( cPath )
      cPatScriptEmp := "Script" + cPath
   end if

RETURN ( if( !lShort, fullCurDir(), "" ) + cPatScriptEmp + "\" )

//---------------------------------------------------------------------------//

FUNCTION cPatOut( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Out\" )

//----------------------------------------------------------------------------//

FUNCTION cPatSafe( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Safe\" )

//----------------------------------------------------------------------------//

FUNCTION cPatBmp( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Bmp\" )

//----------------------------------------------------------------------------//

FUNCTION cPatPsion( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Psion\" )

//----------------------------------------------------------------------------//

FUNCTION cPatHtml( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Html\" )

//----------------------------------------------------------------------------//

FUNCTION cPatXml( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Xml\" )

//----------------------------------------------------------------------------//

FUNCTION cPatReport( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Reports\" )

//----------------------------------------------------------------------------//

FUNCTION by( uVal )

   local uRet     := uVal

RETURN ( uRet )

//---------------------------------------------------------------------------//

FUNCTION nHndCaj( nHnd )

   if nHnd != nil
      nHndCaj  := nHnd
   end if

RETURN nHndCaj

//---------------------------------------------------------------------------//

FUNCTION SelSysDate( oMenuItem )

   DEFAULT oMenuItem := "01084"

   if dSysDate == nil
      dSysDate       := Date()
   end if

   /*
   Obtenemos el nivel de acceso
   */

   if nAnd( Auth():Level( oMenuItem ), 1 ) == 0
      msgStop( "Acceso no permitido." )
   else
      dSysDate       := Calendario( dSysDate, "Fecha de trabajo" )
   end if

RETURN ( dSysDate )

//----------------------------------------------------------------------------//

FUNCTION Visor( aMsg )

   local oDlg
   local oBrwCon
   //local hBmp     := LoadBitmap( GetResources(), "BSTOP" )

   if len( aMsg ) == 0
      RETURN .f.
   end if


   DEFINE DIALOG oDlg RESOURCE "VISOR"

   oBrwCon                        := IXBrowse():New( oDlg )

   oBrwCon:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwCon:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwCon:SetArray( aMsg, , , .f. )

   oBrwCon:nMarqueeStyle          := 5
   oBrwCon:lRecordSelector        := .f.
   oBrwCon:lHScroll               := .f.
   oBrwCon:lHeader                := .f.

   oBrwCon:CreateFromResource( 100 )

   with object ( oBrwCon:AddCol() )
      :cHeader          := Space(1)
      :bStrData         := {|| Space(1) }
      :bEditValue       := {|| aMsg[ oBrwCon:nArrayAt, 1 ] }
      :nWidth           := 20
      :SetCheck( { "Cnt16", "Nil16" } )
   end with

   with object ( oBrwCon:AddCol() )
      :cHeader          := Space(1)
      :bStrData         := {|| aMsg[ oBrwCon:nArrayAt, 2 ] }
      :nWidth           := 300
   end with

   REDEFINE BUTTON ;
      ID       IDOK ;
		OF 		oDlg ;
      ACTION   ( oDlg:end() )

	ACTIVATE DIALOG oDlg CENTER

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION lTactilMode()

RETURN ( "TACTIL" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION lTpvMode()

RETURN ( "TPV" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION GoogleMaps( cStreetTo, cCityTo, cCountryTo )

   local oDlg
   local oWebMap
   local oActiveX

   local oStreetFrom
   local cStreetFrom
   local oCityFrom
   local cCityFrom
   local oCountryFrom
   local cCountryFrom

   cStreetTo         := Padr( cStreetTo, 200 )
   cCityTo           := Padr( cCityTo, 200 )

   if empty( cCountryTo )
      cCountryTo     := Padr( "Spain", 100 )
   end if

   cStreetFrom       := Space( 200 )
   cCityFrom         := Space( 200 )
   cCountryFrom      := Space( 100 )

   oWebMap           := WebMap():new()

   DEFINE DIALOG oDlg RESOURCE "GoogleMap"

   REDEFINE ACTIVEX oActiveX  ID 100   OF oDlg  PROGID "Shell.Explorer"

   REDEFINE GET oStreetFrom   VAR cStreetFrom   ON HELP  load( oStreetFrom, oCityFrom, oCountryFrom ) BITMAP "gc_factory_16" ID 200 OF oDlg

   REDEFINE GET oCityFrom     VAR cCityFrom     ID 210   OF oDlg

   REDEFINE GET oCountryFrom  VAR cCountryFrom  ID 220   OF oDlg

   REDEFINE GET cStreetTo     ID 300   OF oDlg

   REDEFINE GET cCityTo       ID 310   OF oDlg

   REDEFINE GET cCountryTo    ID 320   OF oDlg

   REDEFINE BUTTON            ID 1     OF oDlg  ACTION ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   REDEFINE BUTTON            ID 3     OF oDlg  ACTION ShowInExplorer( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   ACTIVATE DIALOG oDlg CENTERED       ON INIT  ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION Load( oStreetFrom, oCityFrom, oCountryFrom )

   oStreetFrom:cText(   space( 200 ) )
   oCityFrom:cText(     space( 200 ) )
   oCountryFrom:cText(  space( 100 ) )

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ShowInWin( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   oWebMap:aAddress  := {}

   if !empty( cStreetFrom )
      oWebMap:AddStopSep( cStreetFrom, cCityFrom, , , cCountryFrom )
   end if

   oWebMap:AddStopSep( cStreetTo, cCityTo, , , cCountryTo )

   oWebMap:GenLink()

   if !empty( oWebMap:cLink )
      oActiveX:Do( "Navigate", oWebMap:cLink )
      sysrefresh()
   end if

RETURN nil

//---------------------------------------------------------------------------//

STATIC FUNCTION ShowInExplorer( cStreetFrom, cCityFrom, cCountryFrom, cStreetTo, cCityTo, cCountryTo, oWebMap, oActiveX )

   oWebMap:aAddress  := {}

   if !empty( cStreetFrom )
      oWebMap:AddStopSep( cStreetFrom, cCityFrom, , , cCountryFrom )
   end if

   oWebMap:AddStopSep( cStreetTo, cCityTo, , , cCountryTo )

   oWebMap:ShowMap()

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION sErrorBlock( bBlock )

   nError++

   titulo( str( nError ) )
   logwrite( "suma control del errores 1:" + procname(1) + "2:" + procname(2) + str( nError ) )

RETURN ( ErrorBlock( {| oError | ApoloBreak( oError ) } ) )

//---------------------------------------------------------------------------//

FUNCTION rErrorBlock( oBlock )

   nError--

   titulo( str( nError ) )
   logwrite( "resta control del errores 1:" + procname(1) + "2:" + procname(2) + str( nError ) )

RETURN ( ErrorBlock( oBlock ) )

//---------------------------------------------------------------------------//

FUNCTION appSettings()

   SET DATE             FORMAT "dd/mm/yyyy"
   SET TIME             FORMAT TO "hh:mm:ss"
   SET DELETED          ON
   SET EXCLUSIVE        OFF
   SET EPOCH TO         2000
   SET OPTIMIZE         ON
   SET EXACT            ON
   SET AUTOPEN          ON
   SET AUTORDER         TO 1
   SET DECIMALS         TO 6

   setHandleCount( 240 )

   setResDebug( .t. )

   fwNumFormat( 'E', .t. )

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION appLoadAds()

RETURN nil 

//---------------------------------------------------------------------------//

FUNCTION AppSql( cEmpDbf, cEmpSql, cFile )

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION cSqlTableName( cTableName )

RETURN ( cTableName )

//--------------------------------------------------------------------------//

FUNCTION PrinterPreferences( oGet )

   PrinterSetup()

   if !empty( oGet )
      oGet:cText( PrnGetName() )
   end if

RETURN ( Nil )

//---------------------------------------------------------------------------//

FUNCTION DateTimeRich( oRTF )

   local aLbx := REGetDateTime()
   local nLbx := 1
   local oDlg, oLbx

   DEFINE DIALOG oDlg RESOURCE "DateRich"

   REDEFINE LISTBOX oLbx VAR nLbx ITEMS aLbx ID 101 OF oDlg

   REDEFINE BUTTON ID 201 ACTION ( oDlg:End( IDOK ) )

   REDEFINE BUTTON ID 202 ACTION ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK
      oRTF:InsertRTF( aLbx[ nLbx ] )
   endif

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION FindRich( oRTF )

   local oDlg
   local oFind
   local cFind    := Space( 100 )
   local nDir     := 1
   local lCase    := .f.
   local lWord    := .t.

   DEFINE DIALOG oDlg RESOURCE "FindRich"

   REDEFINE GET oFind VAR cFind ID 101 OF oDlg UPDATE

   REDEFINE RADIO nDir ID 102, 103 OF oDlg

   REDEFINE CHECKBOX lCase ID 104 OF oDlg

   REDEFINE CHECKBOX lWord ID 105 OF oDlg

   REDEFINE BUTTON ID 201 ACTION ( oRTF:SetFocus(), oRTF:Find( AllTrim( cFind ), ( nDir == 1 ), lCase, lWord ) )

   REDEFINE BUTTON ID 202 ACTION ( oDlg:End() )

   oDlg:bStart := { || oDlg:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER NOWAIT

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION ReportBackLine( oInf, nLines )

   DEFAULT nLines := 1

   if !empty( oInf )
      oInf:BackLine( nLines )
   end if

RETURN ( "" )

//---------------------------------------------------------------------------//

FUNCTION SetBrwOpt( cName, cOption )

RETURN ( writePProString( "browse", cName, cValToChar( cOption ), cIniEmpresa() ) )

//---------------------------------------------------------------------------//

FUNCTION GetBrwOpt( cName )

RETURN ( GetPvProfInt( "browse", cName, 2, cIniEmpresa() ) )

//---------------------------------------------------------------------------//

FUNCTION setGridOrder( cName, cOption )

RETURN ( writePProString( "grid", cName, cValToChar( cOption ), cIniEmpresa() ) )

//---------------------------------------------------------------------------//

FUNCTION getGridOrder( cName )

RETURN ( getPvProfString( "grid", cName, "", cIniEmpresa() ) )

//---------------------------------------------------------------------------//

FUNCTION cPatPc( cPath )

   if !empty( cPath )
      cPathPC     := cPath
   end if

RETURN ( cPathPc )

//---------------------------------------------------------------------------//

FUNCTION cEmpUsr( cEmp )

   if cEmp != nil
      cEmpUsr  := cEmp
   end if

RETURN cEmpUsr

//---------------------------------------------------------------------------//

FUNCTION cPatStk( cPath, lPath, lShort, lGrp )

RETURN ( if( !lShort, fullCurDir(), "" ) + if( lGrp, "Emp", "Emp" ) + cPath + if( lPath, "\", "" ) )

//---------------------------------------------------------------------------//

FUNCTION AppDbf( cEmpOld, cEmpTmp, cFile, aStruct )

   local oBlock
   local oError
   local dbfOld
	local dbfTmp
   local dbfNamOld   := cEmpOld + cFile + ".Dbf"
   local dbfNamTmp   := cEmpTmp + cFile + ".Dbf"
   local cdxNamOld   := cEmpOld + cFile + ".Cdx"
   local cdxNamTmp   := cEmpTmp + cFile + ".Cdx"

   IF !File( dbfNamOld )
      MsgStop( "No existe : " + dbfNamOld )
      RETURN NIL
	END IF

   IF !File( dbfNamTmp )
      MsgStop( "No existe : " + dbfNamTmp )
      RETURN NIL
	END IF

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   USE ( dbfNamOld ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "OLD", @dbfOld ) ) EXCLUSIVE
   if File( cdxNamOld )
      SET INDEX TO ( cdxNamOld ) ADDITIVE
   end if

   USE ( dbfNamTmp ) NEW VIA ( cDriver() ) ALIAS ( cCheckArea( "TMP", @dbfTmp ) ) EXCLUSIVE
   if File( cdxNamTmp )
      SET INDEX TO ( cdxNamTmp ) ADDITIVE
   end if

   if !empty( aStruct )

      while !( dbfOld )->( eof() )
         dbAppendDefault( dbfOld, dbfTmp, aStruct )
         ( dbfOld )->( dbSkip() )
      end while

   else

      while !( dbfOld )->( eof() )
         dbPass( dbfOld, dbfTmp, .t. )
         ( dbfOld )->( dbSkip() )
      end while

   end if

   RECOVER USING oError

      msgStop( "Error en el trasbase de registros " + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

	CLOSE ( dbfOld )
	CLOSE ( dbfTmp )

RETURN NIL

//---------------------------------------------------------------------------//

FUNCTION GetSysDate()

RETURN ( if( dSysDate != nil, dSysDate, Date() ) )

//---------------------------------------------------------------------------//

FUNCTION aEmp( nField ) 

   if empty( nField )
      RETURN ( aEmpresa )
   end if 

   if empty( aEmpresa )
      RETURN ( nil )
   end if 
   
RETURN ( if( nField > 1 .and. nField < len( aEmpresa ), aEmpresa[ nField ], nil ) )

//---------------------------------------------------------------------------//

FUNCTION getArrayEmpresa() ; RETURN ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION setArrayEmpresa( aEmp )

   aEmpresa    := aEmp

RETURN ( aEmpresa )

//---------------------------------------------------------------------------//

FUNCTION cPathEmpresa()

RETURN ( cPatEmp )

//---------------------------------------------------------------------------//

FUNCTION cPatEmp( cPath, lFull )

   DEFAULT cPath  := ""
   DEFAULT lFull  := .f.

   if !empty( cPath )
      cPatEmp     := "Emp" + cPath
   end if

   if lAds()
      RETURN ( cAdsUNC() + cPatEmp + "\" )
   end if

   if lAIS() .and. lFull
      RETURN ( cAdsUNC() + cPatEmp + "\" )
   end if

   if lAIS() .and. !lFull
      RETURN ( cPatEmp )
   end if

   if lCdx()
      RETURN ( fullCurDir() + cPatEmp + "\" )
   end if

RETURN ( if( lFull, fullCurDir(), "" ) + cPatEmp + "\" )

//---------------------------------------------------------------------------//

FUNCTION appParamsMain( paramsMain )

   if !empty( paramsMain )
      appParamsMain     := upper( paramsMain )
   end if 

RETURN ( appParamsMain )

//---------------------------------------------------------------------------//

FUNCTION appParamsSecond( paramsSecond )

   if !empty( paramsSecond )
      appParamsSecond   := upper( paramsSecond )
   end if 

RETURN ( appParamsSecond )

//---------------------------------------------------------------------------//

FUNCTION appParamsThird( paramsThird )

   if !empty( paramsThird )
      appParamsThird   := upper( paramsThird )
   end if 

RETURN ( appParamsThird )

//---------------------------------------------------------------------------//

FUNCTION cIniEmpresa()

RETURN ( cPath( cPatEmp() ) + "Empresa.Ini" )

//---------------------------------------------------------------------------//

FUNCTION cIniAplication()

RETURN ( fullCurDir() + "GstApolo.Ini" )

//---------------------------------------------------------------------------//

FUNCTION IsMuebles()

RETURN ( "MUEBLES" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION ChmHelp( cTema )

RETURN WinExec( ( "HH " + cPatHelp() + "HELP.CHM::/" + AllTrim( cTema ) + ".HTM" ) )

//----------------------------------------------------------------------------//

FUNCTION cPatHelp()

RETURN ( fullCurDir() + "Help\" )

//----------------------------------------------------------------------------//

FUNCTION cPatReporting()

RETURN ( fullCurDir() + "Reporting\" )

//----------------------------------------------------------------------------//

FUNCTION cCompanyPathDocuments( cCompany, cDirectory )

RETURN ( fullCurDir() + "Documents\" + cCompany + "\" + cDirectory + "\" )

//----------------------------------------------------------------------------//

FUNCTION cPatDocuments( cSubDirectory )

   if !empty( cSubDirectory )
      RETURN ( fullCurDir() + "Documents\" + cSubDirectory + "\" )
   end if 

RETURN ( fullCurDir() + "Documents\" )

//----------------------------------------------------------------------------//

FUNCTION cPatLabels( cSubDirectory )

   if !empty( cSubDirectory )
      RETURN ( fullCurDir() + "Labels\" + cSubDirectory + "\" )
   end if 

RETURN ( fullCurDir() + "Labels\" )

//----------------------------------------------------------------------------//

FUNCTION cPatUserReporting()

RETURN ( fullCurDir() + "UserReporting\" )

//----------------------------------------------------------------------------//

FUNCTION cPatConfig()

RETURN ( fullCurDir() + "Config\" )

//----------------------------------------------------------------------------//

FUNCTION HtmlHelp()

RETURN ( "" )

//---------------------------------------------------------------------------//

FUNCTION lUsrMaster()

RETURN ( Auth():Codigo() == "000" )

//---------------------------------------------------------------------------//

FUNCTION IsPda()

RETURN ( "PDA" $ appParamsMain() )

//---------------------------------------------------------------------------//

FUNCTION cPatSnd( lShort )

   DEFAULT lShort := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Snd\" )

//----------------------------------------------------------------------------//

FUNCTION cEmpTmp( lPath, lShort )

   DEFAULT lPath  := .t.
   DEFAULT lShort := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "EmpTmp" + if( lPath, "\", "" ) )

//----------------------------------------------------------------------------//

FUNCTION cPatUsr()

RETURN ( fullCurDir() + "Usr\" )

//----------------------------------------------------------------------------//

FUNCTION cValToChar( uVal )

   local cType := ValType( uVal )

   do case
      case cType == "C" .or. cType == "M"
           RETURN uVal

      case cType == "D"
           RETURN DToC( uVal )

      case cType == "L"
           RETURN If( uVal, ".T.", ".F." )

      case cType == "N"
           RETURN AllTrim( Str( uVal ) )

      case cType == "B"
           RETURN "{|| ... }"

      case cType == "A"
           RETURN "{ ... }"

      case cType == "O"
           RETURN "Object"

      otherwise
           RETURN ""
   endcase

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION cCharToVal( xVal, cType )

   local cTemp      := ""

   DEFAULT cType    := ValType( xVal )

   do case
      case cType == "C" .or. cType == "M"

         if !empty( xVal )
            cTemp   := Padr( Rtrim( xVal ), 100 )
         end if
         
      case cType == "N"
         cTemp    := Val( cValToChar( xVal ) )

      case cType == "D"

         cTemp    := Ctod( Rtrim( cValToChar( xVal ) ) )

      case cType == "L"
         if "S" $ Rtrim( Upper( xVal ) )
            cTemp := .t.
         else
            cTemp := .f.
         end if

   end case

RETURN ( cTemp )

//---------------------------------------------------------------------------//

FUNCTION cValToText( uVal, lBarraFecha )

   local cType             := ValType( uVal )

   DEFAULT lBarraFecha     := .f.

   do case
      case cType == "C" .or. cType == "M"
           RETURN uVal

      case cType == "D"
           if lBarraFecha
               RETURN DToC( uVal )
           else
               RETURN StrTran( DToC( uVal ), "/", "" )
           end if

      case cType == "L"
           RETURN If( uVal, "S", "N" )

      case cType == "N"
           RETURN AllTrim( Str( uVal ) )

      case cType == "B"
           RETURN "{|| ... }"

      case cType == "A"
           RETURN "{ ... }"

      case cType == "O"
           RETURN "Object"

      otherwise
           RETURN ""
   endcase

RETURN nil

//---------------------------------------------------------------------------//

FUNCTION dToIso( dDate )

   local cDate := ""

   if Valtype( dDate ) != "D"
      dDate    := Date()
   endif

   cDate       := Alltrim( Str( Year( dDate ) ) + "-" + StrZero( Month( dDate ), 2 ) + "-" + StrZero( Day( dDate ), 2 ) )

RETURN ( cDate )

//---------------------------------------------------------------------------//

FUNCTION LogWrite( cText, cFileName )

   local nHand

   DEFAULT cFileName := "Trace.Log"

   if !empty( cText )

      if !File( cFileName )
         nHand       := fCreate( cFileName )
      else
        nHand        := fOpen( cFileName, 1 )
      endif

      fSeek( nHand, 0 , 2 )

      fWrite( nHand, Time() + '-' + Trans( Seconds(), "999999.9999" ) + ">" + cValToChar( cText ) + CRLF )
      
      fClose( nHand )

   end if

RETURN NIL

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ApoloBtnBmp FROM TBtnBmp

   METHOD aGrad      INLINE eval( if( ::bClrGrad == nil, ::oWnd:bClrGrad, ::bClrGrad ), ( ::lMOver .or. ::lBtnDown ) )

ENDCLASS

//----------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ApoloBtnFlat FROM TBtnFlat

   DATA  nMargin     INIT 0

   METHOD Paint() 

   METHOD setCaption( cCaption )    

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Paint() CLASS ApoloBtnFlat

   local aInfo, aRect, nClrText, hBrush

   if ValType( ::bSetGet ) == 'B'
      ::SetText( Eval( ::bSetGet ) )
   endif

   aInfo    := ::DispBegin()

   nClrText := if( ::IsEnabled(), ::nClrText, ::nClrTextDis )

   aRect    := GetClientRect( ::hWnd )
   if ::IsEnabled()
      FillRect( ::hDC, aRect, ::oBrush:hBrush )
   else
      hBrush   := CreateSolidBrush( ::nClrPaneDis )
      FillRect( ::hDC, aRect, hBrush )
      DeleteObject( hBrush )
   endif

   ::DrawMultiLine( ::cCaption, ::oFont, nClrText, DT_CENTER + DT_VCENTER + DT_WORDBREAK )

   if ::lBorder
      WndBox2007( ::hDC, aRect[ 1 ] + 0, aRect[ 2 ] + 0, aRect[ 3 ] - 1, aRect[ 4 ] - 1, ::nClrText )
   endif

   if ::lFocused
      WndBox2007( ::hDC, aRect[ 1 ] + 2, aRect[ 2 ] + 2, aRect[ 3 ] - 3, aRect[ 4 ] - 3, nClrText )
   endif
   
   ::DispEnd( aInfo )

RETURN nil

//----------------------------------------------------------------------------//

METHOD setCaption( cCaption ) CLASS ApoloBtnFlat   

   ::cCaption  := cCaption

RETURN ( ::Refresh() )

//----------------------------------------------------------------------------//

FUNCTION cPatLog( lShort )

   DEFAULT lShort  := .f.

RETURN ( if( !lShort, fullCurDir(), "" ) + "Log\" )

//----------------------------------------------------------------------------//

FUNCTION cCodigoEmpresa( xValue )

   if !empty( xValue )
      cCodEmp     := xValue
   end if

RETURN ( cCodEmp )

//--------------------------------------------------------------------------//

Static FUNCTION lControlAcceso()

   if lCheckPerpetuoMode()

      lDemoMode( .f. )

      RETURN .t.

   end if 

RETURN .f.

//---------------------------------------------------------------------------//

FUNCTION lCheckPerpetuoMode( nSerialUSR )

   local n 
   local cFileIni       
   local oSerialHD
   local nSerialHD      := Abs( nSerialHD() )
   local aSerialCRC     := {}
   local nSerialCRC     := 0

   if empty( nSerialHD )
      RETURN .f.
   end if

   cFileIni             := FullCurDir() + "2Ktorce.Num"  

   // Leemos las claves--------------------------------------------------------

   for n := 1 to 50

      nSerialCRC        := Val( GetPvProfString( "Main", "Access code " + Str( n, 2 ), "0", cFileIni ) )
   
      if !empty( nSerialCRC )
   
         aAdd( aSerialCRC, nSerialCRC )
            
         if nSerialCRC == nXor( nSerialHD, SERIALNUMBER )
               
            RETURN .t.
   
         end if
   
      end if
   
   next

   // Parametro para registrar la aplicacion-----------------------------------

   if !empty( nSerialUSR )

      if nSerialUSR == nXor( nSerialHD, SERIALNUMBER )

         aAdd( aSerialCRC, nSerialUSR )

         for n := 1 to len( aSerialCRC )
            WritePProString( "Main", "Access code " + Str( n, 2 ), cValToChar( aSerialCRC[ n ] ), cFileIni )
         next

         RETURN .t.

      end if

   end if

RETURN .f.

//---------------------------------------------------------------------------//

PROCEDURE xmlIterator( cFileName, cNode, cAttrib, cValue, cData )

   LOCAL hFile, cXml
   LOCAL oDoc, oNode, oIter, lFind
   LOCAL cText    := ""

   SET EXACT OFF

   CLS

   cText          += "X H A R B O U R - XML ITERATOR test "

   IF cFileName == NIL
      cFileName := "xmltest.xml"
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cNode ) == "C" .and. Len( cNode ) == 0
      cNode := NIL
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cAttrib ) == "C" .and. Len( cAttrib ) == 0
      cAttrib := NIL
   ENDIF

   // this can happen if I call xmltest filename "" cdata
   IF ValType( cValue ) == "C" .and. Len( cValue ) == 0
      cValue := NIL
   ENDIF

   cText          +=  "Processing file " + cFileName + "..." + CRLF

   oDoc := TXmlDocument():New( cFileName )

   IF oDoc:nStatus != HBXML_STATUS_OK
      cText       +=  "Error While Processing File: "+cFileName
      cText       +=  "On Line: " + AllTrim( Str( oDoc:nLine ) )
      cText       +=  "Error: " + oDoc:ErrorMsg
      cText       +=  "Program Terminating, press any key"
      RETURN
   ENDIF

   lFind := ( cNode != NIL .or. cAttrib != NIL .or. cValue != NIL .or. cData != NIL )

   cText          += "Navigating all nodes with a base iterator" + CRLF

   oNode := oDoc:CurNode

if ! lFind 

   DO WHILE oNode != NIL
      cXml := oNode:Path()
      IF cXml == NIL
         cXml :=  "(Node without path)"
      ENDIF

      cText       += Alltrim( Str( oNode:nType ) ) + ", " + cValToChar( oNode:cName ) + ", " + ValToPrg( oNode:aAttributes ) + ", " + cValToChar( oNode:cData ) + ": " + cValToChar( cXml ) + CRLF

      oNode       := oDoc:Next()
   ENDDO

else
      cText       += "Iterator - Navigating all nodes" +  cValToChar( cNode ) +  "," + cValToChar( cAttrib ) + "=" + cValToChar( cValue ) + " with data having " + cValToChar( cData ) + CRLF

      oIter := TXmlIterator():New( oDoc:oRoot )
      oIter:lRegex := .t.

      IF cNode != NIL
         cNode := HB_RegexComp( cNode )
      ENDIF

      IF cAttrib != NIL
         cAttrib := HB_RegexComp( cAttrib )
      ENDIF

      IF cValue != NIL
         cValue := HB_RegexComp( cValue )
      ENDIF

      IF cData != NIL
         cData := HB_RegexComp( cData )
      ENDIF

      oNode := oIter:Find( cNode, cAttrib, cValue, cData )

      WHILE oNode != NIL
         cText    += "Found node " + oNode:Path() + ValToPrg( oNode:ToArray() ) + CRLF
         oNode    := oIter:FindNext()
      ENDDO

endif

   cText          += "Terminated. Press any key to continue"

RETURN

//---------------------------------------------------------------------------//

FUNCTION GetOleObject( cApp )

   local oObj

   TRY
      oObj  := GetActiveObject( cApp )
   CATCH
      TRY
         oObj  := CreateObject( cApp )
      CATCH
      END
   END

RETURN oObj

//----------------------------------------------------------------------------//

FUNCTION WinWordObj()

   local lInstalled
   local oWord

   if !( lInstalled == .f. )
      lInstalled  := ( ( oWord := GetOleObject( "Word.Application" ) ) != nil )
   endif

RETURN oWord

//----------------------------------------------------------------------------//

FUNCTION ExcelObj()

   local lInstalled
   local oExcel

   if !( lInstalled == .f. )
      lInstalled  := ( ( oExcel := GetOleObject( "Excel.Application" ) ) != nil )
   endif

RETURN oExcel

//----------------------------------------------------------------------------//

FUNCTION SunCalcObj()

   local lInstalled
   local oCalc

   if !( lInstalled == .f. )
      lInstalled  := ( ( oCalc := GetOleObject( "com.sun.star.ServiceManager" ) ) != nil )
   endif

RETURN oCalc

//----------------------------------------------------------------------------//

FUNCTION GetExcelRange( cBook, cSheet, acRange )

   local oExcel, oBook, oSheet, oRange

   if ( oExcel := ExcelObj() ) != nil
      if ( oBook := GetExcelBook( cBook ) ) != nil
         TRY
            oSheet   := oBook:WorkSheets( cSheet )
            if ValType( acRange ) == 'A'
               oRange   := oSheet:Range( oSheet:Cells( acRange[ 1 ], acRange[ 2 ] ), ;
                                         oSheet:Cells( acRange[ 3 ], acRange[ 4 ] ) )
            else
               oRange   := oSheet:Range( acRange )
            endif
         CATCH
         END
      endif
   endif

RETURN oRange

//----------------------------------------------------------------------------//

FUNCTION GetExcelBook( cBook )

   local oExcel, oBook
   local c, n, nBooks

   cBook := Upper( cFilePath( cBook ) + cFileNoExt( cBook ) )
   if ( oExcel := ExcelObj() ) != nil
      nBooks   := oExcel:WorkBooks:Count()
      for n := 1 to nBooks
         c  := oExcel:WorkBooks( n ):FullName
         if cBook == Upper( cFilePath( c ) + cFileNoExt( c ) )
            RETURN oExcel:WorkBooks( n )
         endif
      next n
      TRY
         oBook := oExcel:WorkBooks:Open( cBook )
      CATCH
      END
   endif

RETURN oBook

//----------------------------------------------------------------------------//

FUNCTION SpecialVal( cNumber )

   local cChar
   local cResult  := ""

   cNumber        := Alltrim( cNumber )

   for each cChar in cNumber
      if Str( Val( cChar ) ) == cChar
         cResult  += cChar
      end if
   next

RETURN ( Val( cResult ) )

//----------------------------------------------------------------------------//

FUNCTION ApoloMsgNoYes( cText, cTitle, lTactil ) 

   local oDlg
   local oBtnOk
   local oBtnCancel

   DEFAULT cText              := "¿Desea eliminar el registro en curso?"
   DEFAULT cTitle             := "Confirme"
   DEFAULT lTactil            := .f.

   if lTactil
      DEFINE DIALOG oDlg RESOURCE "DeleteRecnoTct" TITLE ( cTitle )
   else
      DEFINE DIALOG oDlg RESOURCE "DeleteRecno" TITLE ( cTitle )
   end if

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   REDEFINE BUTTON oBtnCancel ID IDCANCEL    OF oDlg ACTION ( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

FUNCTION ApoloMsgStop( cText, cTitle ) 

   local oDlg
   local oBtnOk

   DEFAULT cText              := "¿Desea eliminar el registro en curso?"
   DEFAULT cTitle             := "¡Atención!"

   DEFINE DIALOG oDlg RESOURCE "MsgStopTCT" TITLE ( cTitle )

   REDEFINE SAY PROMPT cText  ID 100         OF oDlg

   REDEFINE BUTTON oBtnOk     ID IDOK        OF oDlg ACTION ( oDlg:end( IDOK ) )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

FUNCTION ApoloErrorMsgStop( cText, cTitle )

   ApoloMsgStop( cText, cTitle )

RETURN ( .f. )

//----------------------------------------------------------------------------//

FUNCTION ApoloWaitSeconds( nSecs )

   local n

   for n := 1 to nSecs
      waitSeconds( 1 )
      sysRefresh()
   next

RETURN nil

//----------------------------------------------------------------------------//

FUNCTION ApoloDescend( uParam )

RETURN ( Descend( uParam ) )

//----------------------------------------------------------------------------//

FUNCTION CreateFastReport()

   if empty( oFastReport )

      oFastReport    := frReportManager():new()

      oFastReport:LoadLangRes( "Spanish.Xml" )
      oFastReport:SetIcon( 1 )

   end if

RETURN ( oFastReport )

//----------------------------------------------------------------------------//

FUNCTION DestroyFastReport()

   if empty( oFastReport )
      oFastReport:DestroyFR()
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//
/*
Pasa del formato RGB al format RGB Hexadecimal  #000000-------------------------
*/

FUNCTION RgbToRgbHex( nColorRgb )

   local cRgbHex  := ""

   cRgbHex        += "#"
   cRgbHex        += NumToHex( nRgbRed( nColorRgb ), 2 )
   cRgbHex        += NumToHex( nRgbGreen( nColorRgb ), 2 )
   cRgbHex        += NumToHex( nRgbBlue( nColorRgb ), 2 )

RETURN cRgbHex

//----------------------------------------------------------------------------//

FUNCTION InfoStack()

   local i
   local cStack

   i              := 2
   cStack         := ""

   while !empty( ProcName( i ) )
      cStack      += "Llamado desde " + Trim( ProcName( i ) ) + "(" + LTrim( Str( ProcLine( i ) ) ) + ")" + CRLF
      i++
   enddo

   MsgInfo( cStack )

RETURN nil

//----------------------------------------------------------------------------//

FUNCTION lValidMail( cMail )

RETURN ( HB_RegExMatch( "[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}", cMail, .f. ) )

//----------------------------------------------------------------------------//

FUNCTION hashRecord( dbf )

  local n
  local hHash   := {=>}

  for n := 1 to ( dbf )->( fcount() )
    hSet( hHash, ( dbf )->( fieldname( n ) ), ( dbf )->( fieldget( n ) ) )
  next 

RETURN ( hHash )

//----------------------------------------------------------------------------//

FUNCTION appendHashRecord( hHash, dbf, aExclude )

  ( dbf )->( dbappend() )
  if !( dbf )->( neterr() )  
    writeHashRecord( hHash, dbf, aExclude )
  end if

RETURN ( hHash )

//----------------------------------------------------------------------------//

FUNCTION writeHashRecord( hHash, dbf, aExclude )

  local n

  DEFAULT aExclude  := {}

  for n := 1 to ( dbf )->( fcount() )
    if hHasKey( hHash, ( dbf )->( fieldname( n ) ) ) .and. aScan( aExclude, ( dbf )->( fieldname( n ) ) ) == 0
      ( dbf )->( fieldput( n, hGet( hHash, ( dbf )->( fieldname( n ) ) ) ) )
    end if
  next 

RETURN ( hHash )

//----------------------------------------------------------------------------//

FUNCTION readHashDictionary( hashTable, dbf )

  local hash      := {=>}

  hEval( hashTable, {|key,value| hSet( hash, key, ( dbf )->( fieldget( ( dbf )->( fieldPos( value ) ) ) ) ) } )

RETURN ( hash )

//----------------------------------------------------------------------------//

FUNCTION writeHashDictionary( hashValue, hashTable, dbf )

   local h
   local value

   for each h in hashValue
      value     := getValueHashDictionary( h:__enumKey(), hashTable )
      if value != nil
         ( dbf )->( fieldput( ( dbf )->( fieldname( value ) ), h:__enumValue() ) )
      end if
   next

RETURN ( nil )

//----------------------------------------------------------------------------//

FUNCTION getValueHashDictionary( key, hashTable )

   local n
   local value

   n  := hScan( hashTable, {|k,v,i| k == key } ) 
   if n != 0
      value   := haaGetValueAt( hashTable, n )
   end if 

RETURN ( value )

//----------------------------------------------------------------------------//

FUNCTION hashDictionary( aItems )

   local aItem
   local hash        := {=>}

   for each aItem in aItems
      if !empty( aItem[6] )
         hSet( hash, aItem[6], aItem[1] )      
      end if
   next

RETURN ( hash )

//---------------------------------------------------------------------------//

FUNCTION hashDefaultValue( aItems )

  local aItem
  local hash        := {=>}

  for each aItem in aItems
    if !empty( aItem[6] ) .and. isBlock( aItem[9] )
      hSet( hash, aItem[6], aItem[9] )
    end if
  next

RETURN ( hash )

//---------------------------------------------------------------------------//

FUNCTION hashIndex( aItems )

   local aItem
   local hash        := {=>}

   for each aItem in aItems
      if !empty( aItem[1] )
         hSet( hash, aItem[1], aItem[2] )      
      end if
   next

RETURN ( hash )

//---------------------------------------------------------------------------//

FUNCTION getFieldNameFromDictionary( cName, hashDictionary )

  local cFieldName  := ""

  if empty( hashDictionary )
    RETURN ( cFieldName )
  end if 

  if hhaskey( hashDictionary, cName )
    cFieldName      := hGet( hashDictionary, cName )
  end if 

RETURN ( cFieldName )

//---------------------------------------------------------------------------//

FUNCTION HtmlConvertChars( cString, cQuote_style, aTranslations )

   DEFAULT cQuote_style := "ENT_COMPAT"

   do case
      case cQuote_style == "ENT_COMPAT"
         aAdd( aTranslations, { '"', '&quot;'  } )
      case cQuote_style == "ENT_QUOTES"
         aAdd( aTranslations, { '"', '&quot;'  } )
         aAdd( aTranslations, { "'", '&#039;'  } )
      case cQuote_style == "ENT_NOQUOTES"
   end case

RETURN TranslateStrings( cString, aTranslations )

//---------------------------------------------------------------------------//

FUNCTION TranslateStrings( cString, aTranslate )

   local aTran

   for each aTran in aTranslate
      if aTran[ 2 ] $ cString
         cString  := StrTran( cString, aTran[ 2 ], aTran[ 1 ] )
      endif
   next

RETURN cString

//---------------------------------------------------------------------------//

FUNCTION HtmlEntities( cString, cQuote_style )

   local i
   local aTranslations := {}

   for i := 160 TO 255
      aAdd( aTranslations, { Chr( i ), "&#" + Str( i, 3 ) + ";" } )
   next

RETURN HtmlConvertChars( cString, cQuote_style, aTranslations )

//---------------------------------------------------------------------------//

FUNCTION dateTimeToString( dDate, cTime )

RETURN ( dtoc( dDate ) + space( 1 ) + trans( cTime, "@R 99:99:99" ) )

//---------------------------------------------------------------------------//

FUNCTION dateTimeToTimeStamp( dDate, cTime )

   if at( ":", cTime ) == 0
      cTime    := trans( cTime, "@R 99:99:99" )
   end if

RETURN ( hb_dtot( dDate, cTime ) )

//---------------------------------------------------------------------------//

FUNCTION validTime( uTime )

   local cTime
   local nHour    
   local nMinutes 
   local nSeconds 

   if isObject( uTime )
      cTime       := uTime:varGet()
   else 
      cTime       := uTime
   end if 

   nHour          := val( substr( cTime, 1, 2 ) )
   nMinutes       := val( substr( cTime, 3, 2 ) )
   nSeconds       := val( substr( cTime, 5, 2 ) )

   if !validHour( nHour )
      RETURN .f.
   end if 

   if !validMinutesSeconds( nMinutes )
      RETURN .f.
   end if 

   if !validMinutesSeconds( nSeconds )
      RETURN .f.
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION validHour( nHour )

RETURN ( nHour >= 0 .and. nHour <= 23 )

//---------------------------------------------------------------------------//

FUNCTION validMinutesSeconds( nMinutes )

RETURN ( nMinutes >= 0 .and. nMinutes <= 59 )

//---------------------------------------------------------------------------//

FUNCTION validHourMinutes( uTime )

   local cTime
   local nHour
   local nMinutes

   if isObject( uTime )
      cTime       := uTime:varGet()
   else 
      cTime       := uTime
   end if 

   nHour          := val( substr( cTime, 1, 2 ) )
   nMinutes       := val( substr( cTime, 3, 2 ) )

   if !validHour( nHour )
      RETURN .f.
   end if 

   if !validMinutesSeconds( nMinutes )
      RETURN .f.
   end if 

RETURN ( .t. )

//--------------------------------------------------------------------------//

FUNCTION getSysTime()

RETURN ( strtran( time(), ":", "" ) )

//--------------------------------------------------------------------------//

FUNCTION DownLoadFileToUrl( cUrl, cName )

RETURN DOWNLOADFILE( cUrl, cName )

//---------------------------------------------------------------------------//

FUNCTION trimNif( cNif )

   cNif   := strtran( cNif, " ", "" )
   cNif   := strtran( cNif, ".", "" )
   cNif   := strtran( cNif, "-", "" )
   cNif   := strtran( cNif, "_", "" )

RETURN( cNif )

//--------------------------------------------------------------------------//

FUNCTION CreateAdminSQLWindow()

   DEFINE WINDOW oWnd ;
      FROM                    0, 0 TO 26, 82;
      TITLE                   "Administrador : " + __GSTROTOR__ + Space( 1 ) + __GSTVERSION__; 
      MDI ;
      COLORS                  Rgb( 0, 0, 0 ), Rgb( 231, 234, 238 ) ;
      ICON                    getIconApp() ;
      MENU                    ( BuildMenu() )

   oWndBar                    := CreateAdminSQLAcceso( oWnd )
   oWndBar:CreateButtonBar( oWnd )

   // Set the bar messages-----------------------------------------------------

   oWnd:Cargo                 := appParamsMain()

   // Mensajes-----------------------------------------------------------------

   oWnd:oMsgBar               := TMsgBar():New( oWnd, __GSTCOPYRIGHT__ + Space( 2 ) + cNameVersion(), .f., .f., .f., .f., Rgb( 0,0,0 ), Rgb( 255,255,255 ), oFontLittleTitle(), .f. )

   // Abrimos la ventana-------------------------------------------------------

   ACTIVATE WINDOW oWnd ;
      MAXIMIZED ;
      ON PAINT                ( WndPaint( hDC, oWnd ) ); 
      ON RESIZE               ( WndResize( oWnd ) )

   sysrefresh()

RETURN nil

//-----------------------------------------------------------------------------//

FUNCTION inicializateHashVariables()

   hVariables := {=>}

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION setVariablesInHash( cClave, uValor )

   hset( hVariables, cClave, uValor )

RETURN ( .t. )

//---------------------------------------------------------------------------//

FUNCTION getVariablesToHash( cClave )

   local uVariable   := ""

   if hhaskey( hVariables, cClave )
      uVariable      := hGet( hVariables, cClave )
   end if

RETURN ( uVariable )

//---------------------------------------------------------------------------//

Function cTextRichText( cText )

   local nLen     := 0
   local nPos     := 1
   local cFormat  := ""
   local cTexto   := ""

   nLen           := At( "\rtf", SubStr( cText, nPos ) )
   nPos           += nLen
   cFormat        := Upper( SubStr( cText, nPos, 3 ) )

   if cFormat == "RTF"
      cTexto      := RTFToGTF( cText )
   end if

Return cTexto

//---------------------------------------------------------------------------//

Function fwBmpAsc()

RETURN ( LoadBitMap( GetResources(), "Up16" ) )

//---------------------------------------------------------------------------//

Function fwBmpDes()

RETURN ( LoadBitMap( GetResources(), "Down16" ) )

//---------------------------------------------------------------------------//

static Function getScafolding()

   local hScafolding    := {  {  "Directory"    => cPatDat(),;
                                 "Backup"       => .t. },;
                              {  "Directory"    => cPatUsr(),;   
                                 "Backup"       => .t. },;
                              {  "Directory"    => cPatScript(),;   
                                 "Backup"       => .t. },;
                              {  "Directory"    => cPatConfig(),;   
                                 "Backup"       => .t. },;
                              {  "Directory"    => cPatDocuments(),;   
                                 "Backup"       => .t.,;
                                 "Subdirectory" => ;
                                 {  "Directory"    => cPatDocuments() + FacturasVentasController():getName() + "\" } },;
                                 {  "Directory"    => cPatLabels(),;   
                                    "Backup"       => .t.,;
                                    "Subdirectory" => ;
                                    {  "Directory"  => cPatLabels() + FacturasVentasController():getName() + "\" } },;
                              {  "Directory"    => cPatReporting(),;  
                                 "Backup"       => .t. },;
                              {  "Directory"    => cPatUserReporting(),;   
                                 "Backup"       => .t. },;
                              {  "Directory"    => cPatIn(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatOut(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatTmp(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatSnd(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatLog(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatBmp(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatHtml(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatXml(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatSafe(),;   
                                 "Backup"       => .f. },;
                              {  "Directory"    => cPatEmpTmp(),;   
                                 "Backup"       => .f. } }

RETURN ( hScafolding )

//---------------------------------------------------------------------------//

FUNCTION writeResources()

   freeResources()

   hb_gcall( .t. )

   __mvClear()

   if file( "checkres.txt" )
      ferase( "checkres.txt" )
   endif

   checkRes()

   winExec( "notepad checkres.txt" )

RETURN ( nil )

//---------------------------------------------------------------------------//

FUNCTION E1EXECDIRECT()
RETURN ( nil )

FUNCTION TMSQUERY()
RETURN ( nil )

FUNCTION TMSCOMMAND()
RETURN ( nil )

FUNCTION TMSCONNECT()
RETURN ( nil )

FUNCTION TMSDATABASE()
RETURN ( nil )

FUNCTION MYGENCLASS()
RETURN ( nil )

FUNCTION MYGENDATAFIELD()
RETURN ( nil )

FUNCTION E1FIELDAUTOINC()
RETURN ( nil )

FUNCTION E1LISTKEY()
RETURN ( nil )

FUNCTION E1ISAUTOINC()
RETURN ( nil )

FUNCTION E1ISNUMERIC()
RETURN ( nil )

FUNCTION E1LOAD()
RETURN ( nil )

FUNCTION E1IMPORTDATA()
RETURN ( nil )

FUNCTION E1SETBLANK()
RETURN ( nil )

FUNCTION TSQLVIRTUAL()
RETURN ( nil )

FUNCTION E1ISERROR()
RETURN ( nil )

FUNCTION E1ERROR()
RETURN ( nil )

FUNCTION E1ERRNO()
RETURN ( nil )

FUNCTION E1STATE()
RETURN ( nil )

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#include "windows.h"
#include "shlobj.h"
#include "hbapi.h" 
#include "math.h"
#include "hbvm.h"
#include "hbstack.h"
#include "hbapiitm.h"
#include "hbapigt.h"
#include "urlmon.h"
#include "hbapiitm.h" 

HB_MAXUINT hb_dateMilliSeconds( void );

HB_FUNC ( SHOWTASKBAR ) //Habilita o botao INICIAR
{
HWND hWnd = FindWindow("Shell_TrayWnd", "");

ShowWindow( hWnd, 1 );
}

HB_FUNC ( HIDETASKBAR ) //Desabilita o botao Iniciar
{
HWND hWnd = FindWindow("Shell_TrayWnd", "");

ShowWindow( hWnd, 0 );
}

HB_FUNC ( FLASHWINDOW ) // VAI PISCAR O SEU EXE NA BARRA
{
HWND Handle = GetForegroundWindow();

FlashWindow(Handle,TRUE); // VAI PISCAR O SEU EXE NA BARRA

Sleep(300); // TEMPO DE ESPERA
}

HB_FUNC ( DISABLECLOSEWINDOWS ) // DESABILITA O X da janela
{
HMENU MenuH = GetSystemMenu(GetForegroundWindow(),FALSE);

EnableMenuItem(MenuH,SC_CLOSE,MF_GRAYED);
}

HB_FUNC ( ENABLECLOSEWINDOWS ) // HABILITA O X da janela

{
HMENU MenuH = GetSystemMenu(GetForegroundWindow(),TRUE);

EnableMenuItem(MenuH,SC_CLOSE,MF_GRAYED);
}

HB_FUNC( DOWNLOADFILE )
{
   HRESULT hr;

   hr = URLDownloadToFileA( NULL, hb_parc( 1 ), hb_parc( 2 ), 0, NULL );
  
   hb_retnl( hr ) ;
}

HB_FUNC( HB_MILLISECONDS )
{
   hb_retnl( hb_dateMilliSeconds() );
}

HB_FUNC( CHGATEND )
{
    const char * szStr1 = hb_parc( 1 );
    const char * szStr2 = hb_parc( 2 );
    unsigned int uiLen = hb_parclen( 1 ) - hb_parni( 3 );
    unsigned int uiTotalLen = uiLen + hb_parclen( 2 );
    char * szRet = (char *) hb_xgrab( uiTotalLen + 1 );

    hb_xmemcpy( szRet, szStr1, uiLen );
    szRet[ uiLen ] = '\0';
    hb_xstrcat( szRet, szStr2, NULL );

    hb_retclen_buffer( szRet, uiTotalLen );
}

#pragma ENDDUMP

//---------------------------------------------------------------------------//

