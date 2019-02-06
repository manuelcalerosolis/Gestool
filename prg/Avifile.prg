#include "FiveWin.Ch"
#include "Colores.ch"
#include "Factu.ch" 

#define LWA_ALPHA             0x00000002
#define LWA_COLORKEY          0x00000001

#define WS_EX_TOOLWINDOW      0x00000080

#define GWL_EXSTYLE           -20
#define WS_EX_LAYERED         524288

static oMsg
static oDlgWat
static nPrgWat                := 0
static oCur
static nCur                   := 1

//--------------------------------------------------------------------------//

Function PlayAvi( cFileAvi )

	local oBitMap
	local cBuffer		:= Space(200)

	DEFAULT cFileAvi 	:= "VRFYDATA.AVI"

	DEFINE DIALOG oDlgWat RESOURCE "TESTAVI"

	REDEFINE BITMAP oBitMap ID 500 OF oDlgWat

	ACTIVATE DIALOG oDlgWat ;
		NOWAIT ;
		ON INIT ;
			(  mciSendStr( "OPEN AVIVIDEO ALIAS VIDEO STYLE POPUP", @cBuffer,	oDlgWat:hWnd),;
				mciSendStr( "CLOSE VIDEO", @cBuffer, oDlgWat:hWnd ),;
				mciSendStr( "OPEN AVIVIDEO!" + Upper( Alltrim( cFileAvi ) ) + " ALIAS VIDEO PARENT "+ Alltrim( str( oBitMap:hWnd ) ), @cBuffer, oDlgWat:hWnd ),;
				mciSendStr( "PUT VIDEO DESTINATION AT 0 0 170 156", @cBuffer, oDlgWat:hWnd ),;
				mciSendStr( "WINDOW VIDEO HANDLE " + Alltrim( Str( oBitMap:hWnd ) ), @cBuffer, oDlgWat:hWnd),;
				mciSendStr( "PLAY VIDEO REPEAT", @cBuffer, oDlgWat:hWnd ),;
				sysRefresh();
			 )

Return nil

//--------------------------------------------------------------------------//

Function EndAvi()

	oDlgWat:end()

   oDlgWat  := nil

Return nil

//--------------------------------------------------------------------------//

Function WaitPlease( cMsg, cTitle )

   local oBmp

   DEFAULT cMsg   := "Procesando"
	DEFAULT cTitle	:= "Espere por favor..."

   CursorWait()

   DEFINE DIALOG oDlgWat NAME "WAIT_MOVE" TITLE cTitle

   REDEFINE BITMAP oBmp RESOURCE "WEBTOP" ID 600 OF oDlgWat

   TAnimat():Redefine( oDlgWat, 100, { "BAR_01" }, 1 )

   REDEFINE SAY oMsg PROMPT cMsg ID 110 OF oDlgWat

   ACTIVATE DIALOG oDlgWat CENTER NOWAIT

RETURN ( oDlgWat )

//--------------------------------------------------------------------------//

FUNCTION InitWait()

   CursorWait()

   DEFINE DIALOG oDlgWat TITLE "" FROM -10, -10 TO -10, -10

   ACTIVATE DIALOG oDlgWat NOWAIT

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION EndWait()

	oDlgWat:end()
   oDlgWat        := nil

   CursorWE()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION WatMet( oMet, dbfTmp, cTxt )

	DEFAULT cTxt	:= "Procesando"

   CursorWait()

   if oMet != nil .and. cTxt != nil
      oMet:cText  := cTxt
   end if

   if dbfTmp != nil
      oMet:nTotal := ( dbfTmp )->( LastRec() )
   end if

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION RefMet( oMet )

RETURN ( oMet:set( ++nPrgWat ) )

//--------------------------------------------------------------------------//

FUNCTION EndMet( oMet )

   local nMetTot  := oMet:nTotal

   if oMet != nil
      oMet:cText  := ""
      oMet:Set( nMetTot )
      Eval( oMet:bSetGet, 0 )
   end if

   CursorWe()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION IniWatCur()

   oCur  := Array( 8 )

   DEFINE CURSOR oCur[1] RESOURCE "PROC_1"
   DEFINE CURSOR oCur[2] RESOURCE "PROC_2"
   DEFINE CURSOR oCur[3] RESOURCE "PROC_3"
   DEFINE CURSOR oCur[4] RESOURCE "PROC_4"
   DEFINE CURSOR oCur[5] RESOURCE "PROC_5"
   DEFINE CURSOR oCur[6] RESOURCE "PROC_6"
   DEFINE CURSOR oCur[7] RESOURCE "PROC_7"
   DEFINE CURSOR oCur[8] RESOURCE "PROC_8"

   SetCursor( oCur[nCur]:hCursor )
   SysRefresh()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION RefWatCur()

   nCur++

   if nCur > 8
      nCur := 1
   end if

   SetCursor( oCur[nCur]:hCursor )
   SysRefresh()

RETURN NIL

//--------------------------------------------------------------------------//

FUNCTION EndWatCur()

   oCur[1]:End()
   oCur[2]:End()
   oCur[3]:End()
   oCur[4]:End()
   oCur[5]:End()
   oCur[6]:End()
   oCur[7]:End()
   oCur[8]:End()

   CursorWe()
   SysRefresh()

RETURN NIL

//--------------------------------------------------------------------------//

Function CreateWaitMeter( cMsg, cTitle, nTotal )

   oDlgWat              := TWaitMeter():New( cMsg, cTitle, nTotal )
   oDlgWat:Run()

Return ( SysRefresh() )

//--------------------------------------------------------------------------//

Function RefreshWaitMeter( nPosition )

   oDlgWat:RefreshMeter( nPosition )

Return ( SysRefresh() )

//--------------------------------------------------------------------------//

Function incWaitMeter()

   oDlgWat:incMeter()

Return ( SysRefresh() )

//--------------------------------------------------------------------------//

Function EndWaitMeter()

   oDlgWat:End()

Return ( SysRefresh() )

//--------------------------------------------------------------------------//

CLASS TWaitMeter

   DATA  oDlgWait

   DATA  oMessage
   DATA  cMessage

   DATA  oProgress

   DATA  cTitle

   DATA  oBitmap
   DATA  cBitmap                       INIT     "LogoGestool_48"

   DATA  oMeter
   DATA  nTotal
   DATA  nCurrent

   METHOD New( cMsg, cTitle, nTotal )

   METHOD setMessage( cMessage )       INLINE   ( ::oMessage:SetText( cMessage ), sysRefresh() )
   METHOD setBitmap( cBitmap )         INLINE   ( ::cBitmap := cBitmap )

   METHOD setTotalMeter( nTotal )      INLINE   ( ::oProgress:setTotal( nTotal ) )
   METHOD setTotal( nTotal )           INLINE   ( ::oProgress:setTotal( nTotal ) )
   METHOD getTotal( nTotal )           INLINE   ( ::oProgress:getTotal( nTotal ) )

   METHOD incMeter()                   INLINE   ( ::refreshMeter( ++::nCurrent ) )
   METHOD autoInc()                    INLINE   ( ::incMeter() )
   
   METHOD setMeter( nPosition )        INLINE   ( ::oProgress:set( nPosition ) )

   METHOD refreshMeter( nPosition )    INLINE   ( ::oProgress:set( nPosition ) )

   METHOD setStart( bStart )           INLINE   ( ::oDlgWait:bStart := bStart )

   METHOD Run()
   METHOD End()

ENDCLASS

//--------------------------------------------------------------------------//

METHOD New( cTitle, cMessage, nTotal ) CLASS TWaitMeter

   DEFAULT cTitle       := "Espere por favor..."
   DEFAULT cMessage     := "Procesando"
   DEFAULT nTotal       := 0

   ::cTitle             := cTitle
   ::cMessage           := cMessage
   ::nTotal             := nTotal
   ::nCurrent           := 0

   ::oDlgWait           := TDialog():New( , , , , ::cTitle, "Wait_Meter", , .f., , , , , , .f. )
 
   ::oBitmap            := TBitmap():ReDefine( 600, ::cBitmap, , ::oDlgWait, , , .f., .f., , , .f., , , .t. )

   ::oMessage           := TSay():ReDefine( 110, {|| ::cMessage }, ::oDlgWait, , , , .f. )

   ::oProgress          := TApoloMeter():ReDefine( 120, { | u | If( pCount() == 0, nPrgWat, nPrgWat := u ) }, ::nTotal, ::oDlgWait, .f., , , .t. )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Run() CLASS TWaitMeter

   cursorWait()
   
   sysRefresh()

   ::oDlgWait:Activate( , , , .t., {|| .f. }, .f. )

   sysRefresh()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD End() CLASS TWaitMeter

   ::RefreshMeter( 0 )

   ::oDlgWait:bValid    := {|| .t. }

   ::oBitmap:End()

   ::oDlgWait:End()

   ::oDlgWait           := nil

   CursorWE()

   SysRefresh()

RETURN ( nil )

//--------------------------------------------------------------------------//

CLASS TGetDialog

   DATA  oDlg

   DATA  oGet
   DATA  cGet

   DATA  oGetRelacion
   DATA  cGetRelacion

   DATA  oBitmap
   DATA  cBitmap              INIT  "LogoGestool_48"

   DATA  aErrors              INIT  {}

   DATA  bAction 

   METHOD New()
   METHOD Run()
   METHOD Action()
   METHOD End()

   METHOD cleanGet()          INLINE ( ::oGet:cText( space( 200 ) ), ::oGet:setFocus() )
   METHOD cleanGetRelacion()  INLINE ( ::oGetRelacion:cText( "" ), ::oGetRelacion:setFocus() )

   METHOD cleanErrors()       INLINE ( ::aErrors := {} )
   METHOD showErrors()

ENDCLASS

//--------------------------------------------------------------------------//

METHOD New( bAction, cGet ) CLASS TGetDialog

   DEFAULT bAction      := {|| msgInfo( "Please redefine bAction" ) }
   DEFAULT cGet         := space( 200 )

   ::bAction            := bAction
   ::cGet               := cGet

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Run() CLASS TGetDialog

   ::oDlg               := TDialog():New( , , , , , "massive_append_lines", , .f., , , , , , .f. )
 
   ::oBitmap            := TBitmap():ReDefine( 600, ::cBitmap, , ::oDlg, , , .f., .f., , , .f., , , .t. )

   ::oGet               := TGet():ReDefine( 100, { | u | if( pcount() == 0, ::cGet, ::cGet := u ) }, ::oDlg, , "",,,,,,, .f.,,, .f., .f. )

   ::oGetRelacion       := TMultiGet():ReDefine( 110, { | u | if( pcount() == 0, ::cGetRelacion, ::cGetRelacion := u ) }, ::oDlg,,,,,,, .f.,, .f. )

   TButton():ReDefine( IDOK, {|| ::Action() }, ::oDlg, , , .f. )
    
   TButton():ReDefine( IDCANCEL, {|| ::oDlg:end() }, ::oDlg, , , .f. )

   ::oDlg:AddFastKey( VK_F5, {|| ::Action() } )

   ::oDlg:Activate( , , , .t., ,.t. )

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Action()

   eval( ::bAction, self ) 

   ::showErrors()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD End() CLASS TGetDialog

   ::oBitmap:End()

   ::oDlg:End()

   ::oDlg            := nil

   SysRefresh()

RETURN ( nil )

//--------------------------------------------------------------------------//

METHOD showErrors() CLASS TGetDialog

   local cError
   local cErrorText  := ""

   for each cError in ::aErrors
      cErrorText     += cError + CRLF
   next

   if !empty( cErrorText )
      msgStop( cErrorText, "Error de importación" )
   end if 

Return ( cErrorText )

//--------------------------------------------------------------------------//

FUNCTION successAlert( cMessage )

   with object ( TToast():NewToast( 1, cMessage, "hand_thumb_up.bmp", 400, 42, oWnd(), CLR_WHITE, , rgb( 76, 176, 80 ), 255, 4000, .t., , .f. ) )
      :lBtnClose    := .f.
      :lBtnSetup    := .f.
      :ActivaAlert()
   end with

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION warningAlert( cMessage )

   with object ( TToast():NewToast( 1, cMessage, "hand_thumb_up.bmp", 400, 42, oWnd(), CLR_WHITE, , rgb( 255, 151, 0 ), 255, 4000, .t., , .f. ) )
      :lBtnClose    := .f.
      :lBtnSetup    := .f.
      :ActivaAlert()
   end with

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION errorAlert( cMessage )

   with object ( TToast():NewToast( 1, cMessage, "sign_stop.bmp", 400, 42, oWnd(), CLR_WHITE, , rgb( 255, 83, 83 ), 255, 4000, .t., , .f. ) )
      :lBtnClose    := .f.
      :lBtnSetup    := .f.
      :ActivaAlert()
   end with

RETURN ( nil )

//--------------------------------------------------------------------------//

FUNCTION informationAlert( cMessage )

   with object ( TToast():NewToast( 1, cMessage, "hand_thumb_up.bmp", 400, 42, oWnd(), CLR_WHITE, , CLR_BLACK, 255, 4000, .t., , .f. ) )
      :lBtnClose    := .f.
      :lBtnSetup    := .f.
      :ActivaAlert()
   end with

RETURN ( nil )

//--------------------------------------------------------------------------//

CLASS TLightToast FROM TWindow

   CLASSDATA lRegistered   AS LOGICAL
   
   CLASSDATA aToast        INIT {}

   DATA lLeft              AS LOGICAL INIT .F.
   DATA cText              INIT "Toast message"

   DATA cBitmap            AS CHARACTER INIT  ""

   DATA nWidthRadio        INIT 0
   DATA nHeightRadio       INIT 0

   DATA oTimer

   DATA lShowAgain         AS LOGICAL INIT .F.

   DATA nTimer             AS NUMERIC INIT 4000

   DATA oWndEvent

   DATA nHeight            AS NUMERIC INIT 44
   DATA nWidth             AS NUMERIC INIT 400

   DATA lUp                AS LOGICAL INIT .t.
   DATA lLeft              AS LOGICAL INIT .f.

   DATA lShadow            AS LOGICAL INIT .t.

   DATA nLevel             AS NUMERIC INIT 255

   DATA nXOffSet           INIT 0
   DATA nYOffSet           INIT 0

   DATA lWordBreak         INIT .t.
   DATA lCenterText        INIT .f.

   DATA nClrText           AS NUMERIC INIT 0
   DATA nClrPane           AS NUMERIC INIT CLR_WHITE

   DATA nStyle             INIT nOR( WS_POPUP ) 
   DATA nStyleEx           INIT WS_EX_TOOLWINDOW

   DATA cFontFace          INIT "Tahoma"
   DATA nFontSize          INIT -12

   DATA hRgn

   METHOD Build()

   METHOD getTop()
   
   METHOD getLeft()   

   METHOD Activate()

   METHOD calculatePositions()

   METHOD buildFont() 

   METHOD Activate()

   METHOD InitActivate()

   METHOD Destroy()

   METHOD TToolWindow()

   METHOD GetDefaultSize()

   METHOD Default( lShowDlg )

   METHOD BuildTimer( lEnd )

   METHOD Paint()

   METHOD PaintBorder( hDCMem, hRgn )

   METHOD PaintToast( hDC, rc )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Build() CLASS TLightToast

   ::nStyle          := nOR( WS_POPUP )
   
   ::nStyleEx        := WS_EX_TOOLWINDOW

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD getTop() CLASS TLightToast

   if empty( ::oWndEvent )
      RETURN ( ScreenHeight() - ::nHeight - if( ::lShadow, 4, 0 ) )
   end if 

RETURN ( ::oWndEvent:GetCliAreaRect()[ 3 ] )

//---------------------------------------------------------------------------//
 
METHOD getLeft() CLASS TLightToast

   if empty( ::oWndEvent )
      RETURN ( ScreenWidth() - ::nWidth - if( ::lShadow, 4, 0 ) )
   end if 

RETURN ( ::oWndEvent:GetCliAreaRect()[ 4 ] )

//---------------------------------------------------------------------------//

METHOD calculatePositions() CLASS TLightToast

   local aPoint

   ::nTop            := ::getTop()
   ::nLeft           := ::getLeft()

   if !empty( ::oWndEvent )
      aPoint         := ClientToScreen( ::oWndEvent:hWnd, { ::nTop, ::nLeft } )
      aPoint         := ScreenToClient( ::hWnd, aPoint )
      ::nTop         := aPoint[ 1 ] - 2
      ::nLeft        := aPoint[ 2 ]
      ::nBottom      := aPoint[ 1 ] + ::nHeight - 2
      ::nRight       := aPoint[ 2 ] + ::nWidth
   else
      ::nBottom      := ::nTop + ::nHeight
      ::nRight       := ::nLeft + ::nWidth
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD buildFont() CLASS TLightToast

   DEFINE FONT ::oFont NAME ::cFontFace SIZE 0, ::nFontSize - 6 BOLD

RETURN ( ::oFont )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TLightToast

   ::calculatePositions()

   ::Super:New( ::nTop, ::nLeft, ::nBottom, ::nRight,, ::nStyle,,,, ::oWndEvent,,, ::nClrText, ::nClrPane,,,,,,,.t., ::nStyleEx, , , )

   ::buildFont()

   if ::lShadow
      ::Shadow()
   end if 

   ::bInit   := { || ::InitActivate() }

   ACTIVATE WINDOW Self

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD InitActivate() CLASS TLightToast

   ::TToolWindow()

   if !empty( ::oWndEvent )
      ::oWndEvent:setFocus()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TLightToast

   if !Empty( ::oFont )
      ::oFont:End()
   endif

   if !Empty( ::hRgn )
      DeleteObject( ::hRgn )
   endif

   ::Super:Destroy()

   if ::lHistory
      ::DelToast()
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD TToolWindow() CLASS TLightToast

   SetWindowLong( ::hWnd, GWL_EXSTYLE, nOr( GetWindowLong( ::hWnd, GWL_EXSTYLE ), WS_EX_TOOLWINDOW, WS_EX_TOPMOST, WS_EX_ACCEPTFILES ) )

return nil

//----------------------------------------------------------------------------//

METHOD GetDefaultSize() CLASS TLightToast

   local rc        := GetClientRect( ::hWnd )
   local aSize     := { rc[ 3 ] - rc[ 1 ], rc[ 4 ] - rc[ 2 ] }

return aSize

//----------------------------------------------------------------------------//

METHOD Default( lShowDlg ) CLASS TLightToast

   local rc          := { 0, 0, ::nHeight, ::nWidth }

   ::hRgn            := CreateRoundRectRgn( { rc[ 1 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] }, ::nWRadio, ::nHRadio )

   SetWindowRgn( ::hWnd, ::hRgn, .T. )

   DeleteObject( ::hRgn )

RETURN 0

//----------------------------------------------------------------------------//

METHOD BuildTimer( lEnd ) CLASS TLightToast

   if !empty( ::oTimer )
      ::oTimer:Deactivate()
      ::oTimer:End()
   endif

   if ::nTimer > 0
      DEFINE TIMER ::oTimer INTERVAL ::nTimer; 
         ACTION ( ::oTimer:Deactivate(), ::oTimer:End(), ::End() ) OF Self
      ACTIVATE TIMER ::oTimer
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TLightToast

   local rc
   local nClrText
   local hRgn
   local hDCMem   := ::hDC      //CreateCompatibleDC( ::hDC )
   local aInfo    := ::DispBegin()

   rc             := GetClientRect( ::hWnd )
   nClrText       := SetTextColor( hDCMem, ::nClrText )
   hRgn           := CreateRoundRectRgn( { rc[ 1 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] }, ::nWidthRadio, ::nHeightRadio )

   VerticalGradient( hDCMem, { rc[ 1 ] - 1, rc[ 2 ], --rc[ 3 ], --rc[ 4 ] }, ::nClrPane, ::nClrPane )

   ::PaintBitmap( hDCMem, rc )

   ::PaintText( hDCMem, rc )

   ::PaintBorder( hDCMem, hRgn )

   DeleteObject( hRgn )

   SetTextColor( hDCMem, nClrText )

   DeleteDC( hDCMem )

   ::DispEnd( aInfo )

   ::BuildTimer()

RETURN ( 0 )

//----------------------------------------------------------------------------//

METHOD PaintBorder( hDCMem, hRgn ) CLASS TLightToast

   local hBrush

   if ::lBorder
   
      hBrush         := CreateSolidBrush( ::nClrBorder )
      
      frameRgn( hDCMem, hRgn, hBrush, 1, 1 )
      
      deleteObject( hBrush )

   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD PaintToast( hDC, rc ) CLASS TLightToast

RETURN ( 0 )

//----------------------------------------------------------------------------//

