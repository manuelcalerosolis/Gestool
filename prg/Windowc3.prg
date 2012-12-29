#define _FOLDER_CH
#define _ODBC_CH
#define _TREE_CH

#include "FiveWin.Ch"
#include "Constant.ch"
#include "InKey.ch"
#include "FwError.ch"

#define SW_NORMAL              1
#define SW_MAXIMIZE            3
#define SW_MINIMIZE            6
#define SW_RESTORE             9

#define WM_SYSCOMMAND        274    // 0x112
#define WM_INITMENUPOPUP     279    // 0x117
#define WM_LBUTTONDBLCLK     515    // 0x203
#define WM_DRAWITEM           43    // 0x2B
#define WM_MEASUREITEM        44    // 0x2C
#define WM_SETFONT            48    // 0x30
#define WM_QUERYDRAGICON      55    // 0x37
#define WM_ERASEBKGND         20    // 0x14
#define WM_CHILDACTIVATE      34    // 0x22
#define WM_ICONERASEBKGND     39    // 0x27
#define WM_GETFONT            49    // 0x0031
#define WM_NCPAINT           133    // 0x085
#define WM_NCMOUSEMOVE       160    // 0xA0
#define WM_MBUTTONDOWN       519
#define WM_MBUTTONUP         520
#define WM_CTLCOLOR           25    // 0x19
#define WM_CTLCOLOREDIT      307    // 0x133
#define WM_CTLCOLORLISTBOX   308    // 0x134
#define WM_CTLCOLORSTATIC    312    // 0x138
#define WM_GETMINMAXINFO      36    // 0x024
#define WM_NOTIFY             78    // 0x4E

#define WS_EX_DLGMODALFRAME    1
#define WS_EX_TOOLWINDOW     128
#define WS_EX_CLIENTEDGE     512
#define WS_EX_CONTEXTHELP   1024

#define CBN_SELCHANGE          1
#define CBN_CLOSEUP            8

#define IDC_ARROW          32512

#define SIZE_MINIMIZED         1

#define SC_RESTORE         61728
#define SC_CLOSE           61536   // 0xF060
#define SC_CLOSE_OPEN      61539   // 0xF063  Close and Popup already opened
#define SC_MINIMIZE        61472
#define SC_NEXT            61504
#define SC_MAXIMIZE        61488   // 0xF030

#define SW_HIDE                0
#define SW_SHOWNA              8

#define DLGC_BUTTON         8192   // 0x2000

#define CS_DBLCLKS             8
#define CW_USEDEFAULT      32768

#define HORZRES             8
#define VERTRES            10

#define GWL_STYLE         -16
#define GW_CHILD            5
#define GWL_EXSTYLE       -20

#define SM_CXSCREEN         0

#define COLOR_WINDOW        5
#define WM_SETICON        128  // 0x80
#define WM_MENUCHAR       288  // 0x0120
#define WM_MENUSELECT     287  // 0x11F

#define FN_ZIP          15001

#ifdef __CLIPPER__
   #define TVN_SELCHANGEDA   107  // CommCtrl TreeView notification
#else
   #define TVN_SELCHANGEDA  -402  // CommCtrl TreeView notification
#endif

#define GWL_ID   (-12)
#ifdef __CLIPPER__
   #define NO_ID  -1
#else
   #define NO_ID  65535
#endif

#ifdef __XPP__
   #define WM_MOUSEWHEEL  0x020A
#endif

#ifdef __C3__
   #define WM_MOUSEWHEEL  522
#endif

extern set

static aWindows    := {} // Keep this array here as first static !!!
static oWndDefault

// ToolTips statics support
static oToolTip, oTmr, hPrvWnd, lToolTip := .f., hWndParent := 0,;
       hToolTip := 0

static uDropInfo

//----------------------------------------------------------------------------//

function nWindows()  ; return Len( aWindows )
function GetAllWin() ; return aWindows

//----------------------------------------------------------------------------//

CLASS TWindow

   DATA   hWnd, nOldProc

   DATA   bInit, bMoved, bLClicked, bLButtonUp, bKeyDown, bPainted
   DATA   bMButtonDown, bMButtonUp, bRClicked, bRButtonUp
   DATA   bResized, bLDblClick, bWhen, bValid, bKeyChar, bMMoved
   DATA   bGotFocus, bLostFocus, bDropFiles, bDdeInit, bDdeExecute
   DATA   bCommNotify, bMenuSelect, bZip, bUnZip, bDropOver

   // default editing capabilities
   DATA   bCopy, bCut, bFind, bPaste, bPrint
   DATA   bUnDo, bReDo, bDelete, bSelectAll, bFindNext, bReplace, bProperties

   DATA   hDrop
   DATA   cCaption, cPS, cVarName, nPaintCount, cMsg, cToolTip
   DATA   Cargo                // Ok here you have it <g>
   DATA   hDC, nId
   DATA   lActive AS LOGICAL INIT .t.
   DATA   lCancel, lFocused, lVisible, lDesign, lVbx, lValidating AS LOGICAL
   DATA   nTop, nLeft, nBottom, nRight AS NUMERIC INIT 0
   DATA   nStyle, nChrHeight, nChrWidth, nLastKey
   DATA   nClrPane, nClrText
   DATA   nResult, nHelpId, hCtlFocus
   DATA   aControls, aMinMaxInfo
   DATA   oBar, oBrush, oCursor, oFont, oIcon, oMenu
   DATA   oSysMenu, oPopup, oMsgBar, oWnd, oVScroll, oHScroll
   DATA   oDragCursor // Cursor object to use for a Drag&Drop process
   DATA   oCtlFocus   // Current control object focused
   DATA   oTop, oLeft, oBottom, oRight, oClient

   DATA   bSocket, bTaskBar

   DATA   OnClick, OnMouseMove, OnKeyDown, OnMove, OnPaint, OnResize

   CLASSDATA lRegistered AS LOGICAL

   CLASSDATA oMItemSelect            // current menu item selected
   CLASSDATA nToolTip AS NUMERIC INIT 900

   #ifndef __XPP__
   CLASSDATA aProperties INIT { "cTitle", "cVarName", "nClrText",;
                                "nClrPane", "nTop", "nLeft", "nWidth", "nHeight",;
                                "Cargo", "oMenu", "oFont" }
   #else
      CLASS VAR aProperties SHARED

      METHOD cVarName( cName ) INLINE ;
         If( PCount() > 0, ::cVarName := cName, ::cVarName )
   #endif

   CLASSDATA aEvents INIT { { "OnClick", "nRow", "nCol" },;
                            { "OnMouseMove", "nRow", "nCol", "nKeyFlags" },;
                            { "OnKeyDown", "nKey", "nFlags" },;
                            { "OnMove" },;
                            { "OnPaint" }, { "OnResize" } }

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
               oBrush, oIcon, oParent, lVScroll, lHScroll,;
               nClrFore, nClrBack, oCursor, cBorder, lSysMenu, lCaption,;
               lMin, lMax, lPixel ) CONSTRUCTOR

   METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit,;
                    bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp )

   METHOD AddControl( oControl ) INLINE ;
                        If( ::aControls == nil, ::aControls := {},),;
                        AAdd( ::aControls, oControl ), ::lValidating := .f.

   METHOD AsyncSelect( nSocket, nLParam )

   MESSAGE BeginPaint METHOD _BeginPaint()

   METHOD Box( nTop, nLeft, nBottom, nRight )

   METHOD Capture() INLINE  SetCapture( ::hWnd )

   METHOD Center( oWnd ) INLINE ;
                 WndCenter( ::hWnd, If( oWnd != nil, oWnd:hWnd, 0 ) )

   METHOD CheckToolTip()

   #ifndef __CLIPPER__
      #ifndef __C3__
         METHOD ChildLevel( oClass ) INLINE ChildLevel( Self, oClass )
         //defined at db10.prg and at harbour.prg
      #endif
   #endif

   METHOD Close() VIRTUAL

   METHOD Command( nWParam, nLParam )

   METHOD CommNotify( nDevice, nStatus )

   METHOD Circle( nRow, nCol, nWidth )

   METHOD CoorsUpdate()

   // METHOD Copy( lAll ) INLINE  WndCopy( ::hWnd, lAll )
   METHOD Copy() INLINE If( ::bCopy != nil, Eval( ::bCopy, Self ),)

   METHOD Create( cClsName )

   METHOD CtlColor( hWndChild, hDCChild ) INLINE ;
          If( GetWindowLong( hWndChild, GWL_ID ) == NO_ID .or. ;
              GetParent( hWndChild ) != ::hWnd,, ;
              SendMessage( hWndChild, FM_COLOR, hDCChild ) )

   METHOD cTitle( cNewTitle ) SETGET

   METHOD Cut() INLINE If( ::bCut != nil, Eval( ::bCut ),)

   METHOD DdeInitiate( hWndClient, nAppName, nTopicName )

   METHOD DdeAck( hWndSender, nLParam ) INLINE  DdeAck( hWndSender, nLParam )

   METHOD DdeExecute( hWndSender, nCommand ) INLINE ;
          If( ::bDdeExecute != nil,;
              Eval( ::bDdeExecute, hWndSender, DdeGetCommand( nCommand ) ),),;
        PostMessage( hWndSender, WM_DDE_ACK, ::hWnd, nMakeLong( 1, nCommand ) )

   METHOD DdeTerminate( hWndSender ) INLINE DdeTerminate( hWndSender )

   METHOD Delete() INLINE If( ::bDelete != nil, Eval( ::bDelete, Self ),)

   METHOD DestroyToolTip()

   METHOD Disable()  INLINE ::lActive := .f.,;
                            If( ::hWnd != 0, EnableWindow( ::hWnd, .f. ),)

   METHOD DrawItem( nIdCtl, pItemStruct )

   METHOD DropFiles( hDrop )

   METHOD DropOver( nRow, nCol, nKeyFlags )

   METHOD Enable()   INLINE ::lActive := .t.,;
                            If( ::hWnd != 0, EnableWindow( ::hWnd, .t. ),)

   METHOD End() BLOCK ;   // It has to be Block
      { | Self, lEnd | If( lEnd := ::lValid(), ::PostMsg( WM_CLOSE ),), lEnd }

   METHOD EndPaint() INLINE ::nPaintCount--,;
                     EndPaint( ::hWnd, ::cPS ), ::cPS := nil, ::hDC := nil

   METHOD EraseBkGnd( hDC )

   METHOD Event( nEvent ) INLINE ::aEvents[ nEvent ][ 1 ]

   METHOD EveCount() INLINE Len( ::aEvents )

   METHOD Find() INLINE If( ::bFind != nil, Eval( ::bFind, Self ),)

   METHOD FindNext() INLINE If( ::bFindNext != nil, Eval( ::bFindNext, Self ),)

   METHOD FirstActiveCtrl()

   METHOD FloodFill( nRow, nCol, nRGBColor ) INLINE ;
          FloodFill( ::hDC, nRow, nCol, nRGBColor )

   METHOD GenDbf()
   METHOD cGenPrg()

   METHOD nGetChrHeight() INLINE ;
                          ::nChrHeight := nWndChrHeight( ::hWnd,;
                          If( ::oFont != nil, ::oFont:hFont,) )

   METHOD GetCliRect()

   METHOD GetFont()

   METHOD GetRect()

   METHOD GetDC() INLINE ;
       If( ::hDC == nil, ::hDC := GetDC( ::hWnd ),),;
       If( ::nPaintCount == nil, ::nPaintCount := 1, ::nPaintCount++ ), ::hDC

   METHOD GetDlgCode( nLastKey ) VIRTUAL

   METHOD GetMinMaxInfo( pMinMaxInfo ) INLINE ;
                If( ::aMinMaxInfo != nil,;
                    SetMinMax( pMinMaxInfo, ::aMinMaxInfo ),)

   METHOD GetWidth( cText, oFont ) BLOCK { | Self, cText, oFont, nSize | ;
                    oFont := If( oFont == nil, ::oFont, oFont ),;
                    nSize := GetTextWidth( ::GetDC(), cText,;
                    If( oFont != nil, oFont:hFont,) ),;
                    ::ReleaseDC(), nSize }

   METHOD GetText() INLINE GetWindowText( ::hWnd )

   METHOD GoNextCtrl( hCtrl )
   METHOD GoPrevCtrl( hCtrl )

   METHOD GotFocus()

   METHOD GoTop() INLINE BringWindowToTop( ::hWnd )

   #ifdef __C3__
      METHOD HandleEvent( nMsg, nWParam, nLParam )
   #endif

   #ifdef __CLIPPER__
      METHOD HandleEvent( nMsg, nWParam, nLParam ) EXTERN ;
                          WndHandleEvent( nMsg, nWParam, nLParam )
   #endif

   #ifdef __XPP__
      METHOD HandleEvent( nMsg, nWParam, nLParam )
   #endif

   #ifdef __HARBOUR__
      METHOD HandleEvent( nMsg, nWParam, nLParam ) EXTERN ;
                          WndHandleEvent( Self, nMsg, nWParam, nLParam )
   #endif

   METHOD HardCopy( nScale, lFromUser )

   METHOD nHeight( nNewHeight ) SETGET

   // Generated by pressing F1 on an open Menu

   METHOD Help() VIRTUAL

   METHOD HelpF1() INLINE If( ::oMItemSelect != nil,;
                              ::oMItemSelect:HelpTopic(), ::HelpTopic() )

   MESSAGE HelpTopic METHOD __HelpTopic()

   METHOD Hide() INLINE ShowWindow( ::hWnd, SW_HIDE )

   METHOD HScroll( nWParam, nLParam )

   METHOD Iconize() INLINE CloseWindow( ::hWnd )

   METHOD InitMenuPopup( hPopup, nIndex, lSystem )

   METHOD Inspect( cData ) VIRTUAL

   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )

   METHOD KillFocus( hWndFocus ) INLINE ::LostFocus( hWndFocus )

   METHOD LastActiveCtrl()

   METHOD LButtonDown( nRow, nCol, nKeyFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )
   METHOD LDblClick( nRow, nCol, nKeyFlags )

   METHOD Line( nTop, nLeft, nBottom, nRight )
   METHOD Link( lSubClass )

   METHOD Load( cInfo )
   METHOD LoadFile( cFileName )

   METHOD LostFocus( hWndGetFocus )

   METHOD MenuChar( nAscii, nType, nHMenu )

   METHOD MenuSelect( nIdItem, nFlags, nHMenu )

   METHOD Moved( nRow, nCol ) INLINE ;
            If( ::bMoved != nil, Eval( ::bMoved, nRow, nCol ),)

   METHOD NcActivate( lOnOff ) INLINE If( ! lOnOff .and. ;
                                          ::bLostFocus != nil .and. ;
                                          GetFocus() != ::hWnd,;
                                      Eval( ::bLostFocus, GetFocus() ),), nil

   METHOD NcMouseMove( nHitTestCode, nRow, nCol )

   METHOD lWhen() INLINE  If( ::bWhen != nil, Eval( ::bWhen ), .t. )

   METHOD Maximize() INLINE ShowWindow( ::hWnd, SW_MAXIMIZE )

   METHOD MButtonDown( nRow, nCol, nKeyFlags )
   METHOD MButtonUp( nRow, nCol, nKeyFlags )

   METHOD MeasureItem( nIdCtl, pMitStruct )

   METHOD Minimize() INLINE  ShowWindow( ::hWnd, SW_MINIMIZE )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) VIRTUAL

   METHOD Move( nTop, nLeft, nWidth, nHeight, lRepaint )

   METHOD Normal() INLINE ShowWindow( ::hWnd, SW_NORMAL )

   METHOD Notify( nIdCtrl, nPtrNMHDR ) // Common controls notifications

   METHOD NcPaint() VIRTUAL //

   // SETGET separately
   METHOD nWidth( nNewWidth ) SETGET

   METHOD Paint()

   METHOD PaletteChanged( hWndPalChg ) INLINE PalChgEvent( hWndPalChg )

   METHOD Paste() INLINE If( ::bPaste != nil, Eval( ::bPaste, Self ),)

   METHOD PostMsg( nMsg, nWParam, nLParam ) INLINE ;
               PostMessage( ::hWnd, nMsg, nWParam, nLParam )

   METHOD Print( oTarget, nRow, nCol, nScale )

   METHOD Property( n ) INLINE ::aProperties[ n ]

   METHOD Properties() INLINE If( ::bProperties != nil,;
                       Eval( ::bProperties, Self ),)

   METHOD PropCount() INLINE Len( ::aProperties )

   METHOD QueryDragIcon() INLINE ;
          If( ::oIcon != nil, ::oIcon:hIcon, ExtractIcon( "user.exe" ) )

   METHOD QueryEndSession() INLINE If( ::End(), 1, 0 )

   METHOD QueryNewPalette() INLINE If( IsIconic( ::hWnd ), 0, QryNewPalEvent() )

   METHOD RButtonDown( nRow, nCol, nKeyFlags )
   METHOD RButtonUp( nRow, nCol, nKeyFlags )

   METHOD Restore() INLINE ShowWindow( ::hWnd, SW_RESTORE )

   METHOD Destroy()     // previously called Release()

   METHOD ReDo() INLINE If( ::bReDo != nil, Eval( ::bReDo, Self ),)

   METHOD ReleaseDC() INLINE  If( --::nPaintCount == 0,;
                              If( ReleaseDC( ::hWnd, ::hDC ), ::hDC := nil,),)


   METHOD Refresh( lErase ) INLINE InvalidateRect( ::hWnd,;
                                   If( lErase != nil, lErase, .t. ) )

   METHOD Register( nClsStyle )

   METHOD ReSize( nSizeType, nWidth, nHeight )

   METHOD ReadFile( cFileName ) INLINE uLoadObject( cFileName )

   METHOD Replace() INLINE If( ::bReplace != nil, Eval( ::bReplace, Self ),)

   METHOD Save()

   METHOD SaveFile( cFileName )

   METHOD SaveToText( nIndent )

   METHOD Say( nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel,;
               lTransparent, nAlign )

   METHOD SayBitmap( nRow, nCol, coBitmap, nWidth, nHeight )

   METHOD SayRect( nRow, nCol, cText, nClrFore, nClrBack, nWidth )

   METHOD SelColor( lFore )  INLINE ;
          lFore := If( lFore == nil, lFore := .f., lFore ),;
          ::SetColor( If( lFore, ChooseColor( ::nClrText ), ::nClrText ),;
                      If( lFore, ::nClrPane, ChooseColor( ::nClrPane ) ) ),;
          ::Refresh()

   METHOD SelectAll() INLINE If( ::bSelectAll != nil, Eval( ::bSelectAll, Self ),)

   METHOD SendMsg( nMsg, nWParam, nLParam ) INLINE ;
                           SendMessage( ::hWnd, nMsg, nWParam, nLParam )

   METHOD SetBrush( oBrush ) INLINE If( ::oBrush != nil, ::oBrush:End(),),;
                                    ::oBrush := oBrush, ::Refresh()

   METHOD SetColor( nClrFore, nClrBack, oBrush )

   METHOD SetCoors( oRect )

   MESSAGE SetFocus METHOD __SetFocus()

   METHOD SelFont() BLOCK { | Self, nClr | nClr := ::nClrText,;
                            ::SetFont( If( ::oFont == nil,;
                            TFont():New( ,,,.t. ),;
                            ::oFont:Choose( @nClr ) ) ),;
                            ::oFont:nCount--,;
                            ::nClrText := nClr, ::Refresh() }

   METHOD SetFont( oFont )

   METHOD SetIcon( oIcon ) INLINE If( ::oIcon != nil, ::oIcon:End(), nil ),;
                           ::oIcon := oIcon,;
                           If( ::oIcon != nil,;
                           SendMessage( ::hWnd, WM_SETICON, 0, oIcon:hIcon ), nil )

   METHOD SetMenu( oMenu ) INLINE  ::oMenu := oMenu, oMenu:oWnd := Self,;
                                   SetMenu( ::hWnd, oMenu:hMenu ),;
                                   If( oMenu:oAccTable != nil, oMenu:oAccTable:Activate(), nil )

   METHOD SetMsg( cText, lDefault )

   METHOD SetPixel( nX, nY, nColor ) INLINE ;
                               SetPixel( ::GetDC(), nX, nY, nColor ),;
                               ::ReleaseDC()

   METHOD SetSize( nWidth, nHeight, lRepaint ) INLINE ;
                   WndSetSize( ::hWnd, nWidth, nHeight, lRepaint ),;
                   ::CoorsUpdate()

   METHOD SetText( cText ) INLINE ;
                           ::cCaption := cText,;
                           SetWindowText( ::hWnd, cText )

   METHOD Show() INLINE  ShowWindow( ::hWnd, SW_SHOWNA )

   METHOD ShowToolTip( nRow, nCol, cToolTip )

   METHOD SysCommand( nWParam, nLParam )

   METHOD TaskBar( nWParam, nLParam ) INLINE If( ::bTaskBar != nil,;
                          Eval( ::bTaskBar, nWParam, nLParam ),)

   METHOD Timer( nTimerId ) INLINE  TimerEvent( nTimerId )

   METHOD ToolWindow()

   METHOD UnDo() INLINE If( ::bUnDo != nil, Eval( ::bUnDo, Self ),)

   METHOD UnLink()

   METHOD UnZip( nPercent ) INLINE ;
                            If( ::bUnZip != nil, Eval( ::bUnZip, nPercent ),)

   METHOD ClientEdge() INLINE SetWindowLong( ::hWnd, GWL_EXSTYLE,;
             nOr( GetWindowLong( ::hWnd, GWL_EXSTYLE ), WS_EX_CLIENTEDGE ) ),;
             ::Refresh()

   METHOD Zip( nZipInfo ) INLINE ;
                      If( ::bZip != nil, Eval( ::bZip, nZipInfo ),)

   METHOD Update() INLINE AEval( ::aControls,;
          { | o | If( Upper( o:ClassName() ) == "TFOLDER", o:Update(),;
          If( o:lUpdate, o:Refresh(),)) } )

   METHOD lValid() INLINE If( ::bValid != nil, Eval( ::bValid ), .t. )

   METHOD VScroll( nCode, nPos )

   METHOD nVertRes() BLOCK ;
          { | Self, nRes | nRes := GetDeviceCaps( ::GetDC(), VERTRES  ),;
                           ::ReleaseDC(), nRes }


   METHOD nHorzRes() BLOCK ;
          { | Self, nRes | nRes := GetDeviceCaps( ::GetDC(), HORZRES  ),;
                           ::ReleaseDC(), nRes }

   METHOD AEvalWhen()

   METHOD VbxFireEvent( pEventInfo ) INLINE VBXEvent( pEventInfo )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD Register( nClsStyle )  CLASS TWindow

   local hUser

   DEFAULT ::lRegistered := .f. // XBPP workaround

   if ::lRegistered
      return nil
   endif

   #ifdef __CLIPPER__
      hUser = GetModuleHandle( "user.exe" )
   #else
      hUser = GetInstance()
   #endif

   DEFAULT nClsStyle  := nOR( CS_VREDRAW, CS_HREDRAW ),;
           ::nClrPane := GetSysColor( COLOR_WINDOW ),;
           ::oBrush   := TBrush():New( ,::nClrPane )

   nClsStyle = nOr( nClsStyle, CS_GLOBALCLASS, CS_DBLCLKS )

   if GetClassInfo( hUser, ::ClassName() ) == nil
      #ifdef __CLIPPER__
         ::lRegistered = RegisterClass( ::ClassName(), nClsStyle,,, hUser, 0,;
                                        ::oBrush:hBrush )
      #else
         ::lRegistered = RegisterClass( ::ClassName(), nClsStyle,,, hUser, 0,;
                                        ::oBrush:hBrush,,,;
                                        If( ::oIcon != nil, ::oIcon:hIcon, 0 ) )
      #endif
   else
      ::lRegistered = .t.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Create( cClsName )  CLASS TWindow

   DEFAULT cClsName := ::ClassName(), ::cCaption := "",;
           ::nStyle := WS_OVERLAPPEDWINDOW,;
           ::nTop   := 0, ::nLeft := 0, ::nBottom := 10, ::nRight := 10,;
           ::nId    := 0

   if ::oWnd != nil
      ::nStyle = nOR( ::nStyle, WS_CHILD )
   endif

   if ::nBottom != CW_USEDEFAULT
      ::hWnd = CreateWindow( cClsName, ::cCaption, ::nStyle, ;
                             ::nLeft, ::nTop, ::nRight - ::nLeft + 1, ;
                             ::nBottom - ::nTop + 1, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
   else
      ::hWnd = CreateWindow( cClsName, ::cCaption, ::nStyle, ;
                             ::nLeft, ::nTop, ::nRight, ::nBottom, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
   endif

   if ::hWnd == 0
      WndCreateError( Self )
   else
      ::Link()
   endif

return nil

//----------------------------------------------------------------------------//

function WndCreateError( Self )

   local cInfo := Chr( 13 ) + Chr( 10 ) + ;
                  "Class: " + ::ClassName() + CRLF + ;
                  "Caption: " + cValToChar( ::cCaption )

   #ifndef __CLIPPER__
      cInfo += CRLF + "System Error: " + GetErrMsg() // Win32 System Error
   #endif

   Eval( ErrorBlock(), _FwGenError( CANNOTCREATE_WINDOW_OR_CONTROL, cInfo ) )

return nil

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, nStyle, oMenu,;
            oBrush, oIcon, oWnd, lVScroll, lHScroll, nClrFore, nClrBack,;
            oCursor, cBorder, lSysMenu, lCaption, lMin, lMax, lPixel ) ;
                                                               CLASS TWindow

   DEFAULT nTop     := 2, nLeft := 2, nBottom := 20, nRight := 70,;
           lVScroll := .f., lHScroll := .f.,;
           nClrFore := CLR_WHITE, nClrBack := GetSysColor( COLOR_WINDOW ),;
           nStyle   := 0,;
           cBorder  := "SINGLE", lSysMenu := .t., lCaption := .t.,;
           lMin     := .t., lMax := .t., lPixel := .f.

   if nStyle == 0
      nStyle = nOr( WS_CLIPCHILDREN,;
                    If( cBorder == "NONE",   WS_POPUP, 0 ),;
                    If( cBorder == "SINGLE", WS_THICKFRAME, 0 ),;
                    If( lCaption, WS_CAPTION, 0 ),;
                    If( lSysMenu .and. lCaption, WS_SYSMENU, 0 ),;
                    If( lMin .and. lCaption, WS_MINIMIZEBOX, 0 ),;
                    If( lMax .and. lCaption, WS_MAXIMIZEBOX, 0 ),;
                    If( lVScroll, WS_VSCROLL, 0 ),;
                    If( lHScroll, WS_HSCROLL, 0 ) )
   endif

   ::nTop      = nTop * If( lPixel, 1, WIN_CHARPIX_H )
   ::nLeft     = nLeft * If( lPixel, 1, WIN_CHARPIX_W )
   ::nBottom   = nBottom * If( lPixel, 1, WIN_CHARPIX_H )
   ::nRight    = nRight * If( lPixel, 1, WIN_CHARPIX_W )
   ::nStyle    = nStyle
   ::cCaption  = cTitle
   ::oCursor   = oCursor
   ::oMenu     = oMenu
   ::oWnd      = oWnd
   ::oIcon     = oIcon
   ::lVisible  = .t.               // As soon as we create it, it exists!
   ::aControls = {}
   ::nLastKey  = 0
   ::lValidating = .f.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.

      DEFAULT ::aProperties := { "cTitle", "cVarName", "nClrText",;
                                 "nClrPane", "nTop", "nLeft",;
                                 "nWidth", "nHeight", "Cargo",;
                                 "oMenu" }
   #endif

   if ValType( oIcon ) == "C"
      if File( oIcon )
         DEFINE ICON oIcon FILENAME oIcon
      else
         DEFINE ICON oIcon RESOURCE oIcon
      endif
      ::oIcon = oIcon
   endif

   ::Register()
   ::Create()

   ::SetColor( nClrFore, nClrBack, oBrush )

   #ifdef __CLIPPER__
      if oIcon != nil
         SendMessage( ::hWnd, WM_SETICON, 0, oIcon:hIcon )
      endif
   #endif

   if oMenu != nil
      SetMenu( ::hWnd, oMenu:hMenu )
      oMenu:oWnd = Self
      if oMenu:oAccTable != nil
         oMenu:oAccTable:Activate()
      endif
   endif

   if lVScroll
      DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self
   endif
   if lHScroll
      DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self
   endif

   ::GetFont()

   SetWndDefault( Self )                   // Set Default DEFINEd Window

return Self

//----------------------------------------------------------------------------//

METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                 bKeyDown, bInit, bUp, bDown, bPgUp, bPgDown,;
                 bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                 bLButtonUp ) CLASS TWindow

   local oVScroll, oHScroll

   DEFAULT cShow := "NORMAL"

   ::nResult     = nil
   ::lValidating = .f.

   if bValid != nil
      ::bValid = bValid
   endif

   if bDropFiles != nil
      ::bDropFiles = bDropFiles
      DragAcceptFiles( ::hWnd, .t. )
   endif

   if bPainted != nil
      if Upper( ::ClassName() ) == "TMDIFRAME"
         #ifdef __XPP__
            ::TMdiFrame:oWndClient:bPainted = bPainted
         #else
            ::oWndClient:bPainted = bPainted
         #endif
      else
         ::bPainted  = bPainted
      endif
   endif

   if bRClicked != nil
      if Upper( ::ClassName() ) == "TMDIFRAME"
         #ifdef __XPP__
            ::TMdiFrame:oWndClient:bRClicked = bRClicked
         #else
            ::oWndClient:bRClicked = bRClicked
         #endif
      else
         ::bRClicked = bRClicked
      endif
   endif

   // For WS_VSCROLL and WS_HSCROLL styles

   if Upper( ::ClassName() ) == "TMDIFRAME"
      #ifndef __XPP__
      oVScroll = ::oWndClient:oVScroll
      oHScroll = ::oWndClient:oHScroll
      #endif
   else
      oVScroll = ::oVScroll
      oHScroll = ::oHScroll
   endif

   if oVScroll != nil       // When using VSCROLL clause
      if bUp != nil
         oVScroll:bGoUp = bUp
      endif
      if bDown != nil
         oVScroll:bGoDown = bDown
      endif
      if bPgUp != nil
         oVScroll:bPageUp = bPgUp
      endif
      if bPgDown != nil
         oVScroll:bPageDown = bPgDown
      endif
   endif

   if oHScroll != nil       // When using HSCROLL clause
      if bLeft != nil
         oHScroll:bGoUp = bLeft
      endif
      if bRight != nil
         oHScroll:bGoDown = bRight
      endif
      if bPgLeft != nil
         oHScroll:bPageUp = bPgLeft
      endif
      if bPgRight != nil
         oHScroll:bPageDown = bPgRight
      endif
   endif

   ::AEvalWhen()

   ShowWindow( ::hWnd, AScan( { "NORMAL", "ICONIZED", "MAXIMIZED" }, cShow ) )
   UpdateWindow( ::hWnd )

   ::lVisible = .t.

   if ! lWRunning()
      SetWndApp( ::hWnd )
   endif

   if ::bInit != nil
      Eval( ::bInit, Self )
   endif

   ::Resize()

   if ::oWnd == nil
      if ! lWRunning()
         WinRun( Self:hWnd )
      endif
   endif

   if Self != nil  // FiveWin++ difference
      ::lVisible = .f.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AsyncSelect( nSocket, nLParam ) CLASS TWindow

   if ::bSocket != nil
      Eval( ::bSocket, nSocket, nLParam )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Circle( nRow, nCol, nWidth ) CLASS TWindow

   ::GetDC()
   Ellipse( ::hDC, nCol, nRow, nCol + nWidth - 1, nRow + nWidth - 1 )
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Command( nWParam, nLParam ) CLASS TWindow

   local nNotifyCode, nID, hWndCtl

   #ifdef __CLIPPER__
      nNotifyCode = nHiWord( nLParam )
      nID         = nWParam
      hWndCtl     = nLoWord( nLParam )
   #else
      nNotifyCode = nHiWord( nWParam )
      nID         = nLoWord( nWParam )
      hWndCtl     = nLParam
   #endif

   do case
      case ::oPopup != nil
           ::oPopup:Command( nID )

      case hWndCtl == 0 .and. ::oMenu != nil
           ::oMenu:Command( nID )

      case hWndCtl != 0
           do case
              case nNotifyCode == BN_CLICKED
                   SendMessage( hWndCtl, FM_CLICK, 0, 0 )

              case nNotifyCode == CBN_CLOSEUP
                   SendMessage( hWndCtl, FM_CLOSEUP, 0, 0 )

              case nNotifyCode == CBN_SELCHANGE
                   SendMessage( hWndCtl, FM_CHANGE, 0, 0 )

              case nWParam == FN_UNZIP // FiveWin notification codes
                   ::UnZip( nPtrWord( nLParam ) )

              case nWParam == FN_ZIP
                   ::Zip( nLParam )
           endcase
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD CoorsUpdate() CLASS TWindow

   local aRect := GetCoors( ::hWnd )

   ::nTop    = aRect[ 1 ]
   ::nLeft   = aRect[ 2 ]
   ::nBottom = aRect[ 3 ]
   ::nRight  = aRect[ 4 ]

return nil

//----------------------------------------------------------------------------//

METHOD cTitle( cNewTitle ) CLASS TWindow

   if cNewTitle != nil
      SetWindowText( ::hWnd, cNewTitle )
      ::cCaption = cNewTitle
   endif

return GetWindowText( ::hWnd )

//----------------------------------------------------------------------------//

METHOD DdeInitiate( hWndClient, nAppName, nTopicName )  CLASS TWindow

   local xRet

   If ::bDdeInit == nil
      return nil
   endif

   xRet := Eval( ::bDdeInit, hWndClient,;
                 GlobalGetAtomName( nAppName ),;
                 GlobalGetAtomName( nTopicName ) )

   if xRet == Nil .or. Valtype(xRet) != "L" .or. xRet
      SendMessage( hWndClient, WM_DDE_ACK, ::hWnd,;
                   nMakeLong( nAppName, nTopicName ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DrawItem( nIdCtl, pItemStruct ) CLASS TWindow

   local oItem
   local oPopup := If( ::oPopup != nil, ::oPopup, If( ::oSysMenu != nil, ::oSysMenu, nil ) )

   if nIdCtl == 0
      if oPopup != nil .or. ::oMenu != nil
         if oPopup != nil .and. oPopup:GetPopup( GetDrawMenu( pItemStruct ) ) != nil
            oItem = oPopup:GetMenuItem( GetDrawItem( pItemStruct ) )
            if oItem == nil
               if ::oPopup != nil
                  ::oPopup = nil
               endif
            endif
         endif
         if oItem == nil .and. ::oMenu != nil
            oItem = ::oMenu:GetMenuItem( GetDrawItem( pItemStruct ) )
         endif
         if oItem != nil
            return MenuDrawItem( pItemStruct, oItem:cPrompt,;
                   ValType( oItem:bAction ) == "O", oItem:hBitmap )
         endif
      endif
   else
      return SendMessage( GetDlgItem( ::hWnd, nIdCtl ), FM_DRAW, nIdCtl, pItemStruct )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DropFiles( hDrop ) CLASS TWindow

   local aFiles
   local aCoors := { 0, 0 }

   ::hDrop = hDrop

   if ! Empty( ::bDropFiles )
      DragQueryPoint( hDrop, aCoors )
      Eval( ::bDropFiles, aCoors[ 2 ], aCoors[ 1 ], DragQueryFiles( hDrop ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GenDbf( cDbfName ) CLASS TWindow

   DEFAULT cDbfName := RTrim( SubStr( ::GetText(), 1, 8 ) ) + ".dbf"

   ::CoorsUpdate()

   if File( cDbfName )
      if ! ApoloMsgNoYes( cDbfName + CRLF + ;
                     "This file already exists" + CRLF + ;
                     "Do you want to overwrite it ?" )
         return nil
      endif
   else
      DbCreate( cDbfName,;
                { { "CONTROL", "C", 15, 0},;
                  { "CAPTION", "C", 40, 0},;
                  { "ID", "N", 4, 0},;
                  { "TOP", "N", 4, 0},;
                  { "LEFT", "N", 4, 0},;
                  { "WIDTH", "N", 4, 0},;
                  { "HEIGHT", "N", 4, 0},;
                  { "STYLE", "N", 15, 0},;
                  { "CLRFORE", "N", 8, 0},;
                  { "CLRBACK", "N", 8, 0},;
                  { "FNTNAME", "C", 15, 0},;
                  { "FNTWIDTH", "N", 4, 0},;
                  { "FNTHEIGHT", "N", 4, 0},;
                  { "FNTBOLD", "L", 1, 0},;
                  { "FNTITALIC", "L", 1, 0} } )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPRG( cFileName ) CLASS TWindow

   local cPrg := ""

   ::CoorsUpdate()

   cPrg += '#include "FiveWin.Ch"' + CRLF + CRLF
   cPrg += "static oWnd" + CRLF + CRLF
   cPrg += "//" + Replicate( "-", 76 ) + "//" + CRLF + CRLF
   cPrg += "function Main()" + CRLF + CRLF

   if ::oBar != nil
      cPrg += "   local oBar" + CRLF
   endif

   if ::oBrush != nil
      cPrg += "   local oBrush" + CRLF
   endif

   if ::oBrush != nil
      cPrg += ::oBrush:cGenPRG()
   endif

   cPrg += CRLF + ;
           '   DEFINE WINDOW oWnd TITLE "' + ::cTitle + '" ;' + CRLF + ;
           "      FROM " + ;
           Str( ::nTop / WIN_CHARPIX_H , 3 ) + ", " + Str( ::nLeft / WIN_CHARPIX_W, 3 ) + " TO " + ;				  // 16, 8
           Str( ::nBottom / WIN_CHARPIX_H, 3 ) + ", " + Str( ::nRight / WIN_CHARPIX_W, 3 )							  // 16,8

   if ::oMenu != nil
      cPrg += " ;" + CRLF + "      MENU BuildMenu()"
   endif

   if ::oBrush != nil
      cPrg += " ;" + CRLF + "      BRUSH oBrush" + CRLF
   endif

   if ::oBar != nil
      cPrg += ::oBar:cGenPRG()
   endif

   if ::oMsgBar != nil
      cPrg += CRLF + CRLF + '   SET MESSAGE OF oWnd TO "' + ;
              ::oMsgBar:cMsgDef + '"'
   endif

   if ! Empty( ::aControls )
      AEval( ::aControls, { | oCtrl | cPrg += oCtrl:cGenPRG() } )
   endif

   cPrg += CRLF + "   ACTIVATE WINDOW oWnd" + CRLF + CRLF
   cPrg += "return nil" + CRLF + CRLF
   cPrg += "//" + Replicate( "-", 76 ) + "//" + CRLF

   if ! Empty( cFileName )
      MemoWrit( cFileName, cPrg )
   endif

return cPrg

//----------------------------------------------------------------------------//

METHOD EraseBkGnd( hDC ) CLASS TWindow

   if IsIconic( ::hWnd )
      if ::oWnd != nil
         FillRect( hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )
         return 1
      endif
      return 0
   endif

   if ::oBrush != nil .and. ! Empty( ::oBrush:hBrush )
      FillRect( hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
      return 1
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetCliRect() CLASS TWindow

   local aRect := GetClientRect( ::hWnd )

return TRect():New( aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ] )

//----------------------------------------------------------------------------//

METHOD GetRect() CLASS TWindow

   local aRect := GetWndRect( ::hWnd )

return TRect():New( aRect[ 1 ], aRect[ 2 ], aRect[ 3 ], aRect[ 4 ] )

//----------------------------------------------------------------------------//

METHOD MeasureItem( nIdCtl, pMitStruct ) CLASS TWindow

   local nAt, oItem

   // Warning: On this message the Controls still are not initialized
   // because WM_MEASUREITEM is sent before of WM_INITDIALOG

   if nIdCtl == 0 // Menu
      if ::oPopup != nil
         oItem = ::oPopup:GetMenuItem( GetMeaItem( pMitStruct ) )
      endif
      if oItem == nil .and. ::oSysMenu != nil
         oItem = ::oSysMenu:GetMenuItem( GetMeaItem( pMitStruct ) )
      endif
      if oItem == nil
         ::oPopup = nil
         oItem = ::oMenu:GetMenuItem( GetMeaItem( pMitStruct ) )
      endif
      if oItem != nil
         MenuMeasureItem( pMitStruct,;
                          GetTextWidth( 0, StrTran( oItem:cPrompt, "&", "" ) ) + ;
                          If( ValType( oItem:bAction ) == "B", 20, 0 )+20 )
      endif        //+20 introduced due Error on NT on width calculation 1999/05/19
      return .f.  // default behavior
   endif

   if ( nAt := AScan( ::aControls, { | oCtrl | oCtrl:nId == nIdCtl } ) ) != 0
      return ::aControls[ nAt ]:FillMeasure( pMitStruct )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MenuChar( nAscii, nType, nHMenu ) CLASS TWindow

   local oMenu, n, nAt

   if ::oPopup != nil
      oMenu = ::oPopup
   else
      if ::oMenu != nil
         oMenu = ::oMenu
      endif
   endif

   if oMenu != nil
      if oMenu:hMenu == nHMenu .or. ( oMenu := oMenu:GetSubMenu( nHMenu ) ) != nil
         for n = 1 to Len( oMenu:aItems )
            if ! Empty( oMenu:aItems[ n ]:cPrompt )
               if ( nAt := At( "&", oMenu:aItems[ n ]:cPrompt ) ) != 0 .and. ;
                  Upper( SubStr( oMenu:aItems[ n ]:cPrompt, nAt + 1, 1 ) ) == ;
                  Upper( Chr( nAscii ) )
                  return nMakeLong( n - 1, 2 )
               endif
            endif
         next
         return 0
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MenuSelect( nIdItem, nFlags, nHMenu ) CLASS TWindow

   if oToolTip != nil
      oToolTip:End()
      SysRefresh()
      oToolTip = nil
   endif

   if nFlags == -1 .and. nHMenu == 0   // The pulldown is beeing closed !
      ::oMItemSelect = nil
   else
      if ::oMenu != nil .or. ::oPopup != nil
         if ::oPopup != nil
            ::oMItemSelect = ::oPopup:GetMenuItem( nIdItem )
         else
            ::oMItemSelect = ::oMenu:GetMenuItem( nIdItem )
         endif
         ::SetMsg( If( ::oMItemSelect != nil, ::oMItemSelect:cMsg,) )
      endif
   endif

   if ::bMenuSelect != nil
      Eval( ::bMenuSelect, ::oMItemSelect, nFlags, nHMenu )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD nHeight( nNewHeight ) CLASS TWindow

   if PCount() > 0
      return WndHeight( ::hWnd, nNewHeight )
   else
      if ! Empty( ::hWnd )
         return WndHeight( ::hWnd )
      else
         return ::nBottom - ::nTop + 1
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TWindow

   local nCode     := GetNMHDRCode( nPtrNMHDR )
   local nHWndFrom := GetNMHDRHWndFrom( nPtrNMHDR )
   local oCtrl     := oWndFromHwnd( nHWndFrom )

   if oCtrl != nil
      do case
         case nCode == 103 .or. nCode == TVN_SELCHANGEDA  // TreeView item selected
              oCtrl:SelChanged()

         case nCode == -759  // Date-time picker changed
              oCtrl:Changed()

         otherwise
              return oCtrl:Notify( nIdCtrl, nPtrNMHDR )
      endcase
   endif

return nil

//----------------------------------------------------------------------------//

METHOD nWidth( nNewWidth ) CLASS TWindow

   if PCount() > 0
      return WndWidth( ::hWnd, nNewWidth )
   else
      if ! Empty( ::hWnd )
         return WndWidth( ::hWnd )
      else
         return ::nRight - ::nLeft + 1
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Print( oTarget, nRow, nCol, nScale ) CLASS TWindow

   local lNew := .f.

   DEFAULT nRow := 0, nCol := 0, nScale := 4

   if ::bPrint != nil
      Eval( ::bPrint, Self )
      return nil
   endif

   if oTarget == nil
      lNew = .t.
      PRINTER oTarget NAME ::GetText()
         PAGE
         SysRefresh()
   endif

   WndPrint( ::hWnd, oTarget:hDC, nRow, nCol, nScale )

   if lNew
         ENDPAGE
      ENDPRINT
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Save() CLASS TWindow

   local n
   local cType, cInfo := "", cMethod
   local oWnd  := &( ::ClassName() + "()" )
   local uData, nProps := 0

   oWnd = oWnd:New()

   for n = 1 to Len( ::aProperties )
       if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
          OSend( oWnd, ::aProperties[ n ] )
          cInfo += ( I2Bin( Len( ::aProperties[ n ] ) ) + ;
                     ::aProperties[ n ] )
          nProps++
          cType = ValType( uData )
          do case
             case cType == "A"
                  cInfo += ASave( uData )

             case cType == "O"
                  cInfo += uData:Save()

             otherwise
                  cInfo += ( cType + I2Bin( Len( uData := cValToChar( uData ) ) ) + ;
                             uData )
          endcase
       endif
   next

   if ::aEvents != nil
      for n = 1 to Len( ::aEvents )
         if ( cMethod := OSend( Self, ::aEvents[ n ] ) ) != nil
            cInfo += ( I2Bin( Len( ::aEvents[ n ] ) ) + ;
                       ::aEvents[ n ] )
            nProps++
            cInfo += ( "C" + I2Bin( Len( cMethod ) ) + cMethod )
         endif
      next
   endif

   oWnd:End()

return "O" + I2Bin( 2 + Len( ::ClassName() ) + 2 + Len( cInfo ) ) + ;
       I2Bin( Len( ::ClassName() ) ) + ;
       ::ClassName() + I2Bin( nProps ) + cInfo

//----------------------------------------------------------------------------//

static function AToText( aArray, cArrayName, nIndent )

   local cText := "", cType
   local n

   for n = 1 to Len( aArray )
      cType = ValType( aArray[ n ] )
      do case
         case cType == "C"
              cText += Space( nIndent ) + "::" + cArrayName + "[ " + LTrim( Str( n ) ) + " ] = "
              cText += '"' + aArray[ n ] + '"' + CRLF

         case cType == "L"
              cText += Space( nIndent ) + "::" + cArrayName + "[ " + LTrim( Str( n ) ) + " ] = "
              cText += If( aArray[ n ], ".T.", ".F." ) + CRLF

         case cType == "N"
              cText += Space( nIndent ) + "::" + cArrayName + "[ " + LTrim( Str( n ) ) + " ] = "
              cText += LTrim( Str( aArray[ n ] ) ) + CRLF

         case cType == "A"
              cText += AToText( aArray[ n ], "::" + cArrayName + "[ " + LTrim( Str( n ) ) + " ]", nIndent + 3 ) + CRLF

         case cType == "O"
              cText += aArray[ n ]:SaveToText( nIndent ) + CRLF + CRLF

         case cType == "U"
              cText += Space( nIndent ) + "::" + cArrayName + "[ " + LTrim( Str( n ) ) + " ] = "
              cText += "nil" + CRLF
      endcase
   next

return cText

//----------------------------------------------------------------------------//

METHOD SaveToText( nIndent ) CLASS TWindow

   local n, m, cType, cInfo
   local cMethod, uData, nProps := 0
   local oWnd  := &( ::ClassName() + "()" )
   local cParams1, cParams2

   DEFAULT nIndent := 0

   DEFAULT ::cVarName := "noname"

   #ifndef __XPP__
   cInfo := Space( nIndent ) + "OBJECT " + If( nIndent > 0, "::", "" ) + ;
            ::cVarName + " AS " + ;
            If( nIndent > 0, Upper( Left( ::ClassName(), 2 ) ) + ;
            Lower( SubStr( ::ClassName(), 3 ) ), ::cClassName ) + ;
            CRLF + CRLF
   #else
   cInfo := Space( nIndent ) + "OBJECT " + If( nIndent > 0, "::", "" ) + ;
            ::cVarName + " AS " + ;
            If( nIndent > 0, Upper( Left( ::ClassName(), 2 ) ) + ;
            Lower( SubStr( ::ClassName(), 3 ) ), Self:TDesigner:cClassName ) + ;
            CRLF + CRLF
   #endif

   oWnd = oWnd:New()

   for n = 1 to Len( ::aProperties )
       // if ::aProperties[ n ] == "cVarName"

       // else
          if ! ( uData := OSend( Self, ::aProperties[ n ] ) ) == ;
             OSend( oWnd, ::aProperties[ n ] )
             nProps++
             cType = ValType( uData )
             do case
                case cType == "C"
                     cInfo += Space( nIndent ) + "   ::" + ::aProperties[ n ] + " = "
                     cInfo += '"' + uData + '"' + CRLF

                case cType == "A"
                     cInfo += Space( nIndent + 3 ) + "::" + ::aProperties[ n ] + ;
                              " = Array( " + AllTrim( Str( Len( uData ) ) ) + " )" + CRLF + CRLF
                     cInfo += AToText( uData, ::aProperties[ n ], nIndent + 3 )

                case cType == "O"
                     cInfo += CRLF + uData:SaveToText( nIndent + 3 )

                otherwise
                     cInfo += Space( nIndent ) + "   ::" + ::aProperties[ n ] + " = "
                     cInfo += cValToChar( uData ) + CRLF
             endcase
          endif
       // endif
   next

   if ::aEvents != nil
      for n = 1 to Len( ::aEvents )
         if ( cMethod := OSend( Self, ::aEvents[ n ][ 1 ] ) ) != nil
            cInfo += Space( nIndent ) + "   ::" + ::aEvents[ n ][ 1 ] + " = "
            nProps++
            cParams1 = "{ | Self"
            cParams2 = "( Self"
            for m = 2 to Len( ::aEvents[ n ] )
               cParams1 += ", " + ::aEvents[ n ][ m ]
               cParams2 += ", " + ::aEvents[ n ][ m ]
            next
            cParams1 += " | "
            cParams2 += " )"
            if ::oWnd != nil
               cInfo += cParams1 + "::oWnd:" + cMethod + cParams2 + " }" + CRLF
            else
               cInfo += cParams1 + " ::" + cMethod + cParams2 + " }" + CRLF
            endif
         endif
      next
   endif

   cInfo += CRLF + Space( nIndent ) + "ENDOBJECT"

   oWnd:End()

return cInfo

//----------------------------------------------------------------------------//

function ASave( aArray )

   local n, cType, uData
   local cInfo := ""

   for n = 1 to Len( aArray )
      cType = ValType( aArray[ n ] )
      do case
         case cType == "A"
              cInfo += ASave( aArray[ n ] )

         case cType == "O"
              cInfo += aArray[ n ]:Save()

         otherwise
              cInfo += ( cType + I2Bin( Len( uData := cValToChar( aArray[ n ] ) ) ) + ;
                         uData )
      endcase
   next

return "A" + I2Bin( 2 + Len( cInfo ) ) + I2Bin( Len( aArray ) ) + cInfo

//----------------------------------------------------------------------------//

function ARead( cInfo )

   local nPos := 4, nLen, n
   local aArray, cType, cBuffer

   nLen   = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos  += 2
   aArray = Array( nLen )

   for n = 1 to Len( aArray )
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              aArray[ n ] = ARead( "A" + I2Bin( nLen ) + cBuffer )

         case cType == "O"
              aArray[ n ] = ORead( cBuffer )

         case cType == "C"
              aArray[ n ] = cBuffer

         case cType == "D"
              aArray[ n ] = CToD( cBuffer )

         case cType == "L"
              aArray[ n ] = ( cBuffer == ".T." )

         case cType == "N"
              aArray[ n ] = Val( cBuffer )
      endcase
   next

return aArray

//----------------------------------------------------------------------------//

function ORead( cInfo )

   local nLen, cClassName, oObj
   local nPos := 1

   nLen       = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos      += 2
   cClassName = SubStr( cInfo, nPos, nLen )
   nPos      += nLen
   oObj       = &( cClassName + "()" )

   oObj:New()
   oObj:Load( SubStr( cInfo, nPos ) )

return oObj

//----------------------------------------------------------------------------//

METHOD SaveFile( cFileName ) CLASS TWindow

   DEFAULT cFileName := SubStr( ::cVarName, 2 ) + ".ffm"

return MemoWrit( cFileName, ::Save() )

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, nClrFore, nClrBack, oFont, lPixel,;
            lTransparent, nAlign ) CLASS TWindow

   DEFAULT nClrFore := ::nClrText,;
           nClrBack := ::nClrPane,;
           oFont    := ::oFont,;
           lPixel   := .f.,;
           lTransparent := .f.

   if ValType( nClrFore ) == "C"      //  xBase Color string
      nClrBack = nClrFore
      nClrFore = nGetForeRGB( nClrFore )
      nClrBack = nGetBackRGB( nClrBack )
   endif

   ::GetDC()

   DEFAULT nAlign := GetTextAlign( ::hDC )

   WSay( ::hWnd, ::hDC, nRow, nCol, cValToChar( cText ), nClrFore, nClrBack,;
         If( oFont != nil, oFont:hFont, 0 ), lPixel, lTransparent, nAlign )
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD SayBitmap( nRow, nCol, coBitmap, nWidth, nHeight ) CLASS TWindow

   local hDib, hPal
   local cType := ValType( coBitmap )

   if cType == "C"
      DEFINE BITMAP coBitmap FILENAME coBitmap
   endif

   PalBmpDraw( ::GetDC(), nRow, nCol, coBitmap:hBitmap, coBitmap:hPalette,;
               nWidth, nHeight,,, ::nClrPane )
   ::ReleaseDC()

   if cType == "C"
      coBitmap:End()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SayRect( nRow, nCol, cText, nClrFore, nClrBack, nWidth ) CLASS TWindow

   DEFAULT nClrFore := CLR_BLACK, nClrBack := CLR_WHITE

   ::GetDC()
   WSayRect( ::hWnd, ::hDC, nRow, nCol, cText, nClrFore, nClrBack, nWidth )
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bLClicked != nil
      return Eval( ::bLClicked, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nKeyFlags ) CLASS TWindow

   // Visual FiveWin
   if ::OnClick != nil
      Eval( ::OnClick, Self, nRow, nCol )
   endif

   if ::bLButtonUp != nil
      return Eval( ::bLButtonUp, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bLDblClick != nil
      return Eval( ::bLDblClick, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Line( nTop, nLeft, nBottom, nRight ) CLASS TWindow

   ::GetDC()
   MoveTo( ::hDC, nLeft, nTop )
   LineTo( ::hDC, nRight, nBottom )
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bRClicked != nil
      Eval( ::bRClicked, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD RButtonUp( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bRButtonUp != nil
      Eval( ::bRButtonUp, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MButtonDown( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bMButtonDown != nil
      Eval( ::bMButtonDown, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MButtonUp( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bMButtonUp != nil
      Eval( ::bMButtonUp, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetMsg( cText, lDefault ) CLASS TWindow

   DEFAULT lDefault := .f.

   if ::oMsgBar != nil   // Thanks to HMP
      if lDefault
         ::oMsgBar:cMsgDef := cText
      else
         ::oMsgBar:SetMsg( cText )
      endif
   else
      if ::oWnd != nil
         ::oWnd:SetMsg( cText )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Box( nTop, nLeft, nBottom, nRight ) CLASS TWindow

   ::GetDC()
   WndBox( ::hDC, nTop, nLeft, nBottom, nRight )
   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Link( lSubClass ) CLASS TWindow

   local nAt := AScan( aWindows, 0 )

   DEFAULT lSubClass := .t.

   if ::hWnd != 0
      if nAt != 0
         aWindows[ nAt ] = Self
         #ifdef __CLIPPER__
            while GetProp( ::hWnd, "WP" ) != nAt
               SetProp( ::hWnd, "WP", nAt )
            end
         #endif
      else
         AAdd( aWindows, Self )
         nAt = Len( aWindows )
         #ifdef __CLIPPER__
            while GetProp( ::hWnd, "WP" ) != Len( aWindows )
               SetProp( ::hWnd, "WP", Len( aWindows ) )
            end
         #endif
      endif

      #ifdef __CLIPPER__
         if Len( aWindows ) == 1
            WindowsFix()
         endif
      #endif

      if lSubClass
         #ifdef __CLIPPER__
            ::nOldProc = ChangeProc( ::hWnd )
         #else
            ::nOldProc = XChangeProc( ::hWnd, nAt )
         #endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TWindow

   if ::hWnd == nil .or. ::hWnd == 0
      return nil
   endif

   if ::oBrush != nil
      ::oBrush:End()
   endif
   if ::oCursor != nil
      ::oCursor:End()
   endif
   if ::oDragCursor != nil
      ::oDragCursor:End()
   endif
   if ::oIcon != nil
      ::oIcon:End()
   endif
   if ::oFont != nil
      ::oFont:End()
   endif
   if ::oMenu != nil
      ::oMenu:Destroy()  // Don't use End() here because it sends a Msg !!!
   endif
   if ::oSysMenu != nil
      ::oSysMenu:End()
   endif
   if ::bDropFiles != nil
      DragFinish( ::hDrop )
   endif

   if ::oVScroll != nil
      ::oVScroll:Destroy()
   endif
   if ::oHScroll != nil
      ::oHScroll:Destroy()
   endif

   if ! Empty( ::hWnd )
      ::UnLink()
   endif

   if ::hWnd != 0 .and. GetWndApp() == ::hWnd
      PostQuitMessage( 0 )
   endif

   #ifndef __XPP__
      if ::ChildLevel( TDialog() ) != 0 ; // TDialog Class or inherited Class
         .and. ! ::lModal
         DeRegDialog( ::hWnd )
      endif
   #else
      if ::ChildLevel( TDialog() ) != 0 ; // TDialog Class or inherited Class
         .and. ! ::TDialog:lModal
         DeRegDialog( ::hWnd )
      endif
   #endif

   if oWndDefault == Self
      oWndDefault = nil
   endif

   ::hWnd = 0

return nil

//----------------------------------------------------------------------------//

DLL STATIC FUNCTION VbxTerm() AS VOID PASCAL LIB "BIVBX10.DLL"

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TWindow

   ::CoorsUpdate()

   // New Alignment techniques
   if ::oTop != nil
      ::oTop:AdjTop()
   endif
   if ::oBottom != nil
      ::oBottom:AdjBottom()
   endif

   if ::oMsgBar != nil
      ::oMsgBar:Adjust()
   endif
   if ::oBar != nil
      ::oBar:Adjust()
   endif

   if ::oLeft != nil
      ::oLeft:AdjLeft()
   endif
   if ::oRight != nil
      ::oRight:AdjRight()
   endif

   if ::oClient != nil
      ::oClient:AdjClient()
   endif

   if ::OnResize != nil
      Eval( ::OnResize, Self )
   endif

   if ::bResized != nil
      Eval( ::bResized, nSizeType, nWidth, nHeight )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetCoors( oRect ) CLASS TWindow

   SetWindowPos( ::hWnd, 0, oRect:nTop, oRect:nLeft,;
                 oRect:nRight - oRect:nLeft + 1,;
                 oRect:nBottom - oRect:nTop + 1, 4 )    // Important:
                                                        // Use 4 for
   ::nTop    = oRect:nTop                               // for keeping
   ::nLeft   = oRect:nLeft                              // ZOrder !!!!
   ::nBottom = oRect:nBottom
   ::nRight  = oRect:nRight

return nil

//----------------------------------------------------------------------------//

METHOD UnLink() CLASS TWindow

   local nOldProc

   #ifdef __CLIPPER__
      local nAt := If( ::hWnd != 0, GetProp( ::hWnd, "WP" ), 0 )
   #else
      local nAt := AScan( aWindows,;
                          { | o | ValType( o ) == "O" .and. o:hWnd == ::hWnd } )
   #endif

   if ::nOldProc != nil .and. ::hWnd != 0
      nOldProc = RestProc( ::hWnd, ::nOldProc )
      #ifndef __XPP__
         ::nOldProc = nil
      #endif
   endif

   if nAt > 0 .and. nAt <= Len( aWindows )
      aWindows[ nAt ] = 0
   endif

   #ifdef __CLIPPER__
      SetProp( ::hWnd, "WP", 0 )
      RemoveProp( ::hWnd, "WP" )
   #else
      XFreeProc( nOldProc )
   #endif

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nWParam, nLParam ) CLASS TWindow

   #ifdef __CLIPPER__
      local nScrHandle  := nHiWord( nLParam )
      local nScrollCode := nWParam
      local nPos        := nLoWord( nLParam )
   #else
      local nScrHandle  := nLParam
      local nScrollCode := nLoWord( nWParam )
      local nPos        := nHiWord( nWParam )
   #endif

   if nScrHandle == 0                   // Window ScrollBar
      if ::oVScroll != nil
         do case
            case nScrollCode == SB_LINEUP
                 ::oVScroll:GoUp()

            case nScrollCode == SB_LINEDOWN
                 ::oVScroll:GoDown()

            case nScrollCode == SB_PAGEUP
                 ::oVScroll:PageUp()

            case nScrollCode == SB_PAGEDOWN
                 ::oVScroll:PageDown()

            case nScrollCode == SB_THUMBPOSITION
                 ::oVScroll:ThumbPos( nPos )

            case nScrollCode == SB_THUMBTRACK
                 ::oVScroll:ThumbTrack( nPos )

            case nScrollCode == SB_ENDSCROLL
                 return 0
         endcase
      endif
   else                                 // Control ScrollBar
      do case
         case nScrollCode == SB_LINEUP
              SendMessage( nScrHandle, FM_SCROLLUP )

         case nScrollCode == SB_LINEDOWN
              SendMessage( nScrHandle, FM_SCROLLDOWN )

         case nScrollCode == SB_PAGEUP
              SendMessage( nScrHandle, FM_SCROLLPGUP )

         case nScrollCode == SB_PAGEDOWN
              SendMessage( nScrHandle, FM_SCROLLPGDN )

         case nScrollCode == SB_THUMBPOSITION
              SendMessage( nScrHandle, FM_THUMBPOS, nPos )

         case nScrollCode == SB_THUMBTRACK
              SendMessage( nScrHandle, FM_THUMBTRACK, nPos )
      endcase
   endif

return 0

//----------------------------------------------------------------------------//

METHOD ToolWindow() CLASS TWindow

   SetWindowLong( ::hWnd, GWL_EXSTYLE,;
                  nOr( GetWindowLong( ::hWnd, GWL_EXSTYLE ), WS_EX_TOOLWINDOW ) )
   SetWindowPos( ::hWnd, 0, ::nTop, ::nLeft, ::nRight - ::nLeft + 1,;
                 ::nBottom - ::nTop + 1, 55 )
   // 55 is nOr( SWP_NOSIZE, SWP_NOMOVE, SWP_NOZORDER,;
   // SWP_NOACTIVATE, SWP_FRAMECHANGED )

return nil

//----------------------------------------------------------------------------//

METHOD HScroll( nWParam, nLParam ) CLASS TWindow

   #ifdef __CLIPPER__
      local nScrHandle  := nHiWord( nLParam )
      local nScrollCode := nWParam
      local nPos        := nLoWord( nLParam )
   #else
      local nScrHandle  := nLParam
      local nScrollCode := nLoWord( nWParam )
      local nPos        := nHiWord( nWParam )
   #endif

   if nScrHandle == 0                   // Window ScrollBar
      do case
         case nScrollCode == SB_LINEUP
              ::oHScroll:GoUp()

         case nScrollCode == SB_LINEDOWN
              ::oHScroll:GoDown()

         case nScrollCode == SB_PAGEUP
              ::oHScroll:PageUp()

         case nScrollCode == SB_PAGEDOWN
              ::oHScroll:PageDown()

         case nScrollCode == SB_THUMBPOSITION
              ::oHScroll:ThumbPos( nPos )

         case nScrollCode == SB_THUMBTRACK
              ::oHScroll:ThumbTrack( nPos )

         case nScrollCode == SB_ENDSCROLL
              return 0
      endcase
   else                                 // Control ScrollBar
      do case
         case nScrollCode == SB_LINEUP
              SendMessage( nScrHandle, FM_SCROLLUP )

         case nScrollCode == SB_LINEDOWN
              SendMessage( nScrHandle, FM_SCROLLDOWN )

         case nScrollCode == SB_PAGEUP
              SendMessage( nScrHandle, FM_SCROLLPGUP )

         case nScrollCode == SB_PAGEDOWN
              SendMessage( nScrHandle, FM_SCROLLPGDN )

         case nScrollCode == SB_THUMBPOSITION
              SendMessage( nScrHandle, FM_THUMBPOS, nPos )

         case nScrollCode == SB_THUMBTRACK
              SendMessage( nScrHandle, FM_THUMBTRACK, nPos )
      endcase
   endif

return 0

//----------------------------------------------------------------------------//

METHOD SysCommand( nWParam, nLParam ) CLASS TWindow

   local bKeyAction

   /*
   if nWParam == 61696 // VK_F10
      if ( bKeyAction := SetKey( VK_F10 ) ) != nil
         Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ), Self )
         return 0
      endif
   endif
   */

   if ::oSysMenu != nil .and. nWParam < 61440           // 0xF000
      ::oSysMenu:Command( nWParam )
   else
      do case
         case nWParam == SC_CLOSE .or. nWParam == SC_CLOSE_OPEN
              return ::End()
      endcase
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TWindow

   if IsIconic( ::hWnd )
      if Upper( ::ClassName() ) == "TMDICHILD" // ChildLevel( TMdiChild() ) > 0
         ::SendMsg( WM_ERASEBKGND, ::hDC, 0 )
      else
         ::SendMsg( WM_ICONERASEBKGND, ::hDC, 0 )
      endif
      DrawIcon( ::hDC, 0, 0,;
      If( ::oIcon != nil, ::oIcon:hIcon, ExtractIcon( "user.exe" ) ) )
   else
      if ValType( ::bPainted ) == "B"
         return Eval( ::bPainted, ::hDC, ::cPS, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HardCopy( nScale, lUser ) CLASS TWindow

   local oPrn

   DEFAULT lUser := .t.

   if lUser
      PRINT oPrn NAME ::cTitle FROM USER
   else
      PRINT oPrn NAME ::cTitle
   endif

      PAGE
         ::Refresh()
         SysRefresh()                      // Let Windows process
         ::Print( oPrn, 0, 0, nScale )
      ENDPAGE
   ENDPRINT

return nil

//----------------------------------------------------------------------------//

METHOD Move( nTop, nLeft, nWidth, nHeight, lRepaint ) CLASS TWindow

   MoveWindow( ::hWnd, nTop, nLeft, nWidth, nHeight, lRepaint )

   ::CoorsUpdate()

return nil

//----------------------------------------------------------------------------//

METHOD SetColor( nClrFore, nClrBack, oBrush ) CLASS TWindow

   // DEFAULT colors get assigned at :Colors() method
   // because there we _do_ have a hDC already created

   if ValType( nClrFore ) == "C"
      nClrBack = nClrFore                   // It is a dBase Color string
      nClrFore = nGetForeRGB( nClrFore )
      nClrBack = nGetBackRGB( nClrBack )
   endif

   ::nClrText = nClrFore
   ::nClrPane = nClrBack

   if ::oBrush != nil
      ::oBrush:End()
   endif
   if oBrush != nil
      ::oBrush = oBrush
   else
      // Keep the := here for XBase++ translation
      ::oBrush := TBrush():New(,nClrBack,)
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TWindow

   local bKeyAction := SetKey( nKey )

   if bKeyAction != nil .and. lAnd( nFlags, 16777216 ) // function Key
      return Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ), Self )
   endif

   if ::bKeyChar != nil
      return Eval( ::bKeyChar, nKey, nFlags )
   endif

   if nKey == VK_ESCAPE .and. ::oWnd != nil
      ::oWnd:KeyChar( nKey, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD InitMenuPopup( hPopup, nIndex, lSystem ) CLASS TWindow

   local oPopup

   if ! lSystem
      if ! Empty( ::oPopup ) .and. ::oPopup:hMenu == hPopup
         ::oPopup:Initiate()
         return nil
      endif
      if ! Empty( ::oMenu )
         ::oMenu:Initiate()
         if ( oPopup := ::oMenu:GetPopup( hPopup ) ) != nil
            oPopup:Initiate()
         endif
      endif
   else
      if ! Empty( ::oSysMenu )
         ::oSysMenu:Initiate()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TWindow

   local bKeyAction := SetKey( nKey )

   if nKey == VK_TAB .and. ::oWnd != nil .and. GetKeyState( VK_SHIFT )
      ::oWnd:GoPrevCtrl( ::hWnd )
      return 0
   endif
   // By Hernan Ceccarelli !!!

   if nKey == VK_TAB .and. ::oWnd != nil
      ::oWnd:GoNextCtrl( ::hWnd )
      return 0
   endif

   if nKey == VK_F4 .and. GetKeyState( VK_CONTROL ) .and. ;
      ::oWnd != nil .and. ::oWnd:ChildLevel( TMdiChild() ) > 0
      ::oWnd:KeyDown( nKey, nFlags )
      return 0
   endif

   if nKey == VK_F6 .and. GetKeyState( VK_CONTROL ) .and. ;
      ::oWnd != nil .and. ::oWnd:ChildLevel( TMdiChild() ) > 0
      ::oWnd:KeyDown( nKey, nFlags )
      return 0
   endif

  if bKeyAction != nil     // Clipper SET KEYs !!!
     Eval( bKeyAction, ProcName( 4 ), ProcLine( 4 ), Self )
     return 0
   endif

   if nKey == VK_F1
      ::HelpTopic()
      return 0
   endif

   if ::OnKeyDown != nil
      Eval( ::OnKeyDown, Self, nKey, nFlags )
   endif

   if ::bKeyDown != nil
      return Eval( ::bKeyDown, nKey, nFlags )
   endif

   if ::oWnd != nil .and. IsChild( ::oWnd:hWnd, ::hWnd )
      ::oWnd:KeyDown( nKey, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//
// Some friends functions

function SetWndDefault( oWnd ) ; oWndDefault := oWnd ; return nil
function _SetWndDefaul( oWnd ) ; oWndDefault := oWnd ; return nil  // XBPP

function GetWndDefault() ; return oWndDefault

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TWindow

   ::lFocused = .t.

   if ::bGotFocus != nil
      Eval( ::bGotFocus )
   endif

   if ! Empty( ::hCtlFocus )
      if Upper( GetClassName( ::hCtlFocus ) ) $ "TFOLDER | TPAGES"
         AEval( ::aControls, {| Ctrl | If( Ctrl:hWnd != ::hCtlFocus, , ;
                  SetFocus( Ctrl:aDialogs[ Ctrl:nOption ]:hCtlFocus ) ) } )
      else
         SetFocus( ::hCtlFocus )
      endif
   else
      if ::aControls != nil .and. Len( ::aControls ) > 0
         if ::aControls[ 1 ] != nil
            ::hCtlFocus = ::aControls[ 1 ]:hWnd
            SetFocus( ::hCtlFocus )
         endif
      endif
   endif

return 0   // no standard behavior

//----------------------------------------------------------------------------//

METHOD GoNextCtrl( hCtrl ) CLASS TWindow

   local hCtlNext := NextDlgTab( ::hWnd, hCtrl )

   ::hCtlFocus = hCtlNext

   if ! Empty( ::aControls ) .and. hCtrl == ::LastActiveCtrl():hWnd //ATail( ::aControls ):hWnd
      if ! Empty( ::oWnd ) .and. ;
         ( Upper( ::oWnd:ClassName() ) == "TFOLDER" .or. ;
           Upper( ::oWnd:ClassName() ) == "TPAGES" )
         hCtlNext = NextDlgTab( ::oWnd:oWnd:hWnd, ::oWnd:hWnd )
         ::hCtlFocus = hCtrl
      endif
   endif

   // Fix for Combobox with Dropdown by IOZ 12/06/00
   if hCtlNext == hCtrl .and. Upper(getclassname(hCtrl)) == "EDIT"
      hCtlNext := NextDlgTab( GetParent(::hWnd), hCtrl )
   endif

   if hCtlNext != hCtrl
      SetFocus( hCtlNext )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoPrevCtrl( hCtrl ) CLASS TWindow

   local hCtlPrev := NextDlgTab( ::hWnd, hCtrl, .t. )
   local n

   ::hCtlFocus = hCtlPrev

   if ! Empty( ::aControls ) .and. hCtrl == ::FirstActiveCtrl():hWnd //::aControls[ 1 ]:hWnd
      if ! Empty( ::oWnd ) .and. ;
         ( Upper( ::oWnd:ClassName() ) == "TFOLDER" .or. ;
           Upper( ::oWnd:ClassName() ) == "TPAGES" )
         hCtlPrev = NextDlgTab( ::oWnd:oWnd:hWnd, ::oWnd:hWnd, .t. )
         ::hCtlFocus = hCtrl
      endif
   endif

   If hCtlPrev != hCtrl
      If Upper( GetClassName( hCtlPrev ) ) == "TFOLDER" .or. ;
         Upper( GetClassName( hCtlPrev ) ) == "TPAGES"
         n = AScan( ::aControls, { | o | o:hWnd == hCtlPrev } )
         if n > 0
            ::aControls[ n ]:aDialogs[ ::aControls[ n ]:nOption ]:LastActiveCtrl():SetFocus()
         endif
      else
         SetFocus( hCtlPrev )
      EndIF
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetFont() CLASS TWindow

   local hFont, aInfo, oFont

   if ::oFont == nil .and. ::oWnd != nil .and. ::oWnd:oFont != nil
      ::oFont = ::oWnd:oFont
      SendMessage( ::hWnd, WM_SETFONT, ::oFont:hFont )
      DEFAULT ::oFont:nCount := 0
      ::oFont:nCount++
      return ::oFont
   endif

   if ::oFont == nil
      if ( hFont := SendMessage( ::hWnd, WM_GETFONT ) ) != 0
         aInfo = GetFontInfo( hFont )
         #ifndef __XPP__
            oFont = TFont()
         #else
            oFont = TFont():New()
         #endif
         oFont:hFont     = hFont
         oFont:nCount    = 1
         oFont:nHeight   = aInfo[ 1 ]
         oFont:nWeight   = aInfo[ 2 ]
         oFont:lBold     = aInfo[ 3 ]
         oFont:cFaceName = aInfo[ 4 ]
         oFont:lDestroy  = .f.
         ::oFont = oFont
         ::nChrHeight    = aInfo[ 1 ]
         ::nChrWidth     = GetTextWidth( , "B" )
      else
         DEFINE FONT ::oFont NAME GetSysFont() SIZE 0, -12
         if ::oFont:lNew
            ::oFont:nCount--
         endif
      endif
   endif

return ::oFont

//----------------------------------------------------------------------------//

METHOD AEvalWhen() CLASS TWindow

   local n
   local aControls := ::aControls

   if aControls != nil .and. ! Empty( aControls )
      for n = 1 to Len( aControls )
          if aControls[ n ] != nil .and. aControls[ n ]:bWhen != nil
             if Eval( aControls[ n ]:bWhen )
                ::aControls[ n ]:Enable()   // keep this as ::
             else
                ::aControls[ n ]:Disable()  // keep this as ::
             endif
         endif
      next
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFont( oFont ) CLASS TWindow

   if ::oFont != nil .and. oFont != nil
      if ::oFont:hFont != oFont:hFont
         ::oFont:End()
      endif
   endif

   if oFont != nil
      ::oFont = oFont
      DEFAULT oFont:nCount := 0  // Xbase++ requirement
      oFont:nCount++
      SendMessage( ::hWnd, WM_SETFONT, oFont:hFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD __SetFocus() CLASS TWindow

   if ::lWhen()
      SetFocus( ::hWnd )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Load( cInfo ) CLASS TWindow

   local nPos := 1, nProps, n, nLen
   local cData, cType, cBuffer

   nProps = Bin2I( SubStr( cInfo, nPos, 2 ) )
   nPos += 2

   for n = 1 to nProps
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cData = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      cType = SubStr( cInfo, nPos++, 1 )
      nLen  = Bin2I( SubStr( cInfo, nPos, 2 ) )
      nPos += 2
      cBuffer = SubStr( cInfo, nPos, nLen )
      nPos += nLen
      do case
         case cType == "A"
              OSend( Self, "_" + cData, ARead( cBuffer ) )

         case cType == "O"
              OSend( Self, "_" + cData, ORead( cBuffer ) )

         case cType == "C"
              OSend( Self, "_" + cData, cBuffer )

         case cType == "L"
              OSend( Self, "_" + cData, cBuffer == ".T." )

         case cType == "N"
              OSend( Self, "_" + cData, Val( cBuffer ) )
      endcase
   next

return nil

//----------------------------------------------------------------------------//

METHOD LoadFile( cFileName ) CLASS TWindow

   local cInfo, nPos := 4

   DEFAULT cFileName := ""

   if ! File( cFileName )
      MsgStop( "File not found: " + cFileName )
      return nil
   endif

   cInfo  = MemoRead( cFileName )
   nPos  += ( 2 + Bin2I( SubStr( cInfo, nPos, 2 ) ) )

   ::Load( SubStr( cInfo, nPos ) )

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus( hWndGetFocus ) CLASS TWindow

   ::lFocused = .f.

   if oToolTip != nil
      oToolTip:End()
      oToolTip = nil
   endif

   if ! Empty( ::bLostFocus )
      return Eval( ::bLostFocus, hWndGetFocus )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::oCursor != nil
      SetCursor( ::oCursor:hCursor )
   else
      CursorArrow()
   endif

   ::SetMsg( ::cMsg )

   ::CheckToolTip()

   if ::OnMouseMove != nil
      Eval( ::OnMouseMove, Self, nRow, nCol, nKeyFlags )
   endif

   if ::bMMoved != nil
      return Eval( ::bMMoved, nRow, nCol, nKeyFlags )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD CheckToolTip() CLASS TWindow

   local hWndAct

   if ::cToolTip == nil .and. ::hWnd != hWndParent
      if ::hWnd != hToolTip
         lToolTip = .f.
      endif
   endif

   if ::cToolTip == nil
      if hPrvWnd != ::hWnd
         hPrvWnd  = ::hWnd
      endif
      if oToolTip != nil
         oToolTip:End()
         oToolTip = NIL
      endif
      if oTmr != NIL
         oTmr:End()
         oTmr = NIL
      endif
   else
      if hPrvWnd != ::hWnd
         hWndParent = GetParent( ::hWnd )
         hPrvWnd    = ::hWnd
         if oToolTip != nil
            oToolTip:End()
            oToolTip = NIL
         endif
         if oTmr != NIL
            oTmr:End()
            oTmr = NIL
         endif
         if lToolTip
            ::ShowToolTip()
         else
            hWndAct = GetActiveWindow()
            DEFINE TIMER oTmr INTERVAL ::nToolTip ;
               ACTION ( If( GetActiveWindow() == hWndAct,;
                        ::ShowToolTip(),), oTmr:End(), oTmr := nil )
               oTmr:hWndOwner = GetActiveWindow() // WndApp()
            ACTIVATE TIMER oTmr
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowToolTip( nRow, nCol, cToolTip ) CLASS TWindow

   local oFont, aPos, hOldFont, nTxtWidth := 0, nTxtHeight
   local aToolTip, nLenToolTip

   DEFAULT nCol := 7, nRow := ::nHeight() + 7, ;
           cToolTip := ::cToolTip

   if oToolTip == nil

      DEFINE FONT oFont NAME GetSysFont() SIZE 0, -8

      DEFINE WINDOW oToolTip FROM 0, 0 TO 1, 5 ;
         STYLE nOr( WS_POPUP, WS_BORDER ) ;
         COLOR 0, RGB( 255, 255, 225 ) OF Self

      aPos = { nRow, nCol }

      aPos = ClientToScreen( ::hWnd, aPos )

      nTxtHeight := Max(14, GetTextHeight( oToolTip:hWnd )-2)

      if ValType( cToolTip ) == "B"
         cToolTip = Eval( cToolTip )
      endif

      aToolTip = Array( nLenToolTip := MLCount( cToolTip, 254 ) )
      AEval( aToolTip, {|c, n| aToolTip[ n ] := Trim( MemoLine( cToolTip, 252, n ) ), ;
             nTxtWidth := Max( nTxtWidth, GetTextWidth( 0, aToolTip[ n ], oFont:hFont ) + 7 ) } )

      if aPos[ 2 ] + nTxtWidth + 3 > GetSysMetrics( SM_CXSCREEN )
         aPos[ 2 ] = GetSysMetrics( SM_CXSCREEN ) - nTxtWidth - 3
      endif

      oToolTip:Move( aPos[ 1 ], aPos[ 2 ], nTxtWidth, nTxtHeight * nLenToolTip + 3 )
      oToolTip:Show()
      hToolTip = oToolTip:hWnd

      SetBkMode( oToolTip:GetDC(), 1 )
      SetTextColor( oToolTip:hDC, 0 )
      hOldFont = SelectObject( oToolTip:hDC, oFont:hFont )
      AEval( aToolTip, {| c, n | TextOut( oToolTip:hDC, n * nTxtHeight - (nTxtHeight-1), 2, aToolTip[ n ] ) } )
      SelectObject( oToolTip:hDC, hOldFont )
      oToolTip:ReleaseDC()
      oFont:End()
   endif

   lToolTip = .t.

return nil

//----------------------------------------------------------------------------//

METHOD DestroyToolTip() CLASS TWindow

  if oToolTip != nil
     oToolTip:End()
     oToolTip = nil
  endif

  hPrvWnd = 0
  hWndParent = 0

return nil

//----------------------------------------------------------------------------//

METHOD NcMouseMove( nHitTestCode, nRow, nCol ) CLASS TWindow

   hWndParent = 0
   hPrvWnd  = 0
   lToolTip = .f.
   if oToolTip != NIL
      oToolTip:End()
      oToolTip = NIL
   endif
   if oTmr != NIL
      oTmr:End()
      oTmr = NIL
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CommNotify( nDevice, nStatus ) CLASS TWindow

   if ::bCommNotify != nil
      return Eval( ::bCommNotify, nDevice, nStatus )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD __HelpTopic() CLASS TWindow

   if Empty( ::nHelpId )
      if ::oWnd != nil
         ::oWnd:HelpTopic()
      else
         if Empty( GetHelpTopic() )
            HelpIndex()
         else
            HelpTopic()
         endif
      endif
   else
      HelpTopic( ::nHelpId )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DropOver( nRow, nCol, nKeyFlags ) CLASS TWindow

   if ::bDropOver != nil
      Eval( ::bDropOver, GetDropInfo(), nRow, nCol, nKeyFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _BeginPaint() CLASS TWindow

   local cPS

   if ::nPaintCount == nil
      ::nPaintCount = 1
   else
      ::nPaintCount++
   endif

   ::hDC = BeginPaint( ::hWnd, @cPS )
   ::cPS = cPS

return nil

//----------------------------------------------------------------------------//
// FiveWin own Drag & Drop support functions

function SetDropInfo( uInfo )

   uDropInfo = uInfo

return nil

//----------------------------------------------------------------------------//

function GetDropInfo()

   local uInfo := uDropInfo

   uDropInfo = nil

return uInfo

//----------------------------------------------------------------------------//

function WndMain()

   local nAt := AScan( aWindows, { | o | ! Empty( o ) .and. o:hWnd == GetWndApp() } )

return If( nAt != 0, aWindows[ nAt ], nil )

//----------------------------------------------------------------------------//

#ifdef __C3__
   #define __XPP__
#endif

#ifdef __XPP__

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWindow

   do case
      case nMsg == WM_CHAR
           return ::KeyChar( nWParam, nLParam )

      case nMsg == WM_CLOSE
           return ::Close( nWParam )

      case nMsg == WM_COMMAND
           return ::Command( nWParam, nLParam )

      case nMsg == WM_GETMINMAXINFO
           return ::GetMinMaxInfo( nLParam )

      case nMsg == WM_PAINT
           ::BeginPaint()
           ::Paint()
           ::EndPaint()

      case nMsg == WM_DDE_INITIATE
           ::DdeInitiate( nWParam, nLoWord( nLParam ), nHiWord( nLParam ) )

      case nMsg == WM_DDE_ACK
           ::DdeAck( nWParam, nLParam )

      case nMsg == WM_DDE_EXECUTE
           ::DdeExecute( nWParam, nLParam )

      case nMsg == WM_DDE_TERMINATE
           ::DdeTerminate( nWParam )

      case nMsg == WM_DESTROY
           return ::Destroy()

      case nMsg == WM_DRAWITEM
           return ::DrawItem( nWParam, nLParam )

      case nMsg == WM_ERASEBKGND
           return ::EraseBkGnd( nWParam )

      case nMsg == WM_GETDLGCODE
           return ::GetDlgCode()

      case nMsg == WM_HSCROLL
           return ::HScroll( nWParam, nLParam )

      case nMsg == WM_KEYDOWN
           return ::KeyDown( nWParam, nLParam )

      case nMsg == WM_INITMENUPOPUP
           return ::InitMenuPopup( nWParam, nLoWord( nLParam ), nHiWord( nLParam ) != 0 )

      case nMsg == WM_KILLFOCUS
           return ::LostFocus( nWParam ) // LostFocus(), not KillFocus()!!!

      case nMsg == WM_LBUTTONDOWN
           return ::LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
                                 nWParam )
      case nMsg == WM_LBUTTONUP
           return ::LButtonUp( nHiWord( nLParam ), nLoWord( nLParam ),;
                               nWParam )
      case nMsg == WM_LBUTTONDBLCLK
           return ::LDblClick( nHiWord( nLParam ), nLoWord( nLParam ),;
                               nWParam )
      case nMsg == WM_MBUTTONDOWN
           return ::MButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
                                 nWParam )
      case nMsg == WM_MBUTTONUP
           return ::MButtonUp( nHiWord( nLParam ), nLoWord( nLParam ),;
                               nWParam )
      case nMsg == WM_MEASUREITEM
           return ::MeasureItem( nWParam, nLParam )

      case nMsg == WM_MENUCHAR
           return ::MenuChar( nLoWord( nWParam ), nHiWord( nWParam ), nLParam )

      case nMsg == WM_MENUSELECT
           return ::MenuSelect( nLoWord( nWParam ), nHiWord( nWParam ), nLParam )

      case nMsg == WM_MOUSEMOVE
           return ::MouseMove( nHiWord( nLParam ), nLoWord( nLParam ),;
                               nWParam )

      case nMsg == WM_MOUSEWHEEL
           return ::MouseWheel( nLoWord( nWParam ),;
                                If( nHiWord( nWParam ) > 32768,;
                                nHiWord( nWParam ) - 65535, nHiWord( nWParam ) ),;
                                nLoWord( nLParam ), nHiWord( nLParam ) )

      case nMsg == WM_MOVE
           return ::Moved( nLoWord( nLParam ), nHiWord( nLParam ) )

      case nMsg == WM_NCMOUSEMOVE
           return ::NcMouseMove( nWParam, nHiWord( nLParam ), nLoWord( nLParam ) );

      case nMsg == WM_RBUTTONDOWN
           return ::RButtonDown( nHiWord( nLParam ), nLoWord( nLParam ),;
                                 nWParam )
      case nMsg == WM_RBUTTONUP
           return ::RButtonUp( nHiWord( nLParam ), nLoWord( nLParam ),;
                               nWParam )
      case nMsg == WM_SETFOCUS
           return ::GotFocus( nWParam )

      case nMsg == WM_VSCROLL
           return ::VScroll( nWParam, nLParam )

      case nMsg == WM_SIZE
           return ::ReSize( nWParam, nLoWord( nLParam ), nHiWord( nLParam ) )

      case nMsg == WM_SYSCOMMAND
           return ::SysCommand( nWParam, nLParam )

      case nMsg == WM_TIMER
           return ::Timer( nWParam, nLParam )

      case nMsg == WM_CTLCOLORSTATIC .or. ;
           nMsg == WM_CTLCOLOREDIT   .or. ;
           nMsg == WM_CTLCOLORLISTBOX
           return ::CtlColor( nLParam, nWParam )

      case nMsg == WM_ASYNCSELECT
           return ::AsyncSelect( nWParam, nLParam )

      case nMsg == FM_DRAW
           return ::DrawItem( nWParam, nLParam )

      case nMsg == FM_DROPOVER
           return ::DropOver( nLoWord( nWParam ), nHiWord( nWParam ), nLParam )

      case nMsg == WM_NOTIFY
           return ::Notify( nWParam, nLParam )
   endcase

return nil

#endif

//----------------------------------------------------------------------------//

#ifdef __C3__
   #undef __XPP__
#endif

#ifdef __XPP__
   function _XBPP( hWnd, nMsg, nWParam, nLParam, nAt )
#else
   #ifdef __C3__
      function _FWC3( hWnd, nMsg, nWParam, nLParam, nAt )
   #else
      function _FWH( hWnd, nMsg, nWParam, nLParam, nAt )
   #endif
#endif

   local oWnd

   static aRet := { 0, 0 }

   if nAt != 0
      oWnd = aWindows[ nAt ]
      if ValType( oWnd ) == "O"
         aRet[ 1 ] = oWnd:HandleEvent( nMsg, nWParam, nLParam )
         aRet[ 2 ] = oWnd:nOldProc
      endif
      return aRet
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LastActiveCtrl() CLASS TWindow

   local n := Len( ::aControls )
   local oControl, oRadMenu

   if n == 1
      return ::aControls[ 1 ]
   endif

   while n >= 1
      If Upper( ::aControls[ n ]:ClassName() ) == 'TRADIO'
         oRadMenu = ::aControls[ n ]:oRadMenu
         while n >= 1 .and. Upper( ::aControls[ n ]:ClassName() ) == 'TRADIO' .and. ;
               ::aControls[ n ]:oRadMenu == oRadMenu .and. ( !::aControls[ n ]:lChecked .or. ;
               !::aControls[ n ]:lActive)
            n--
         end
         oControl := ::aControls[ n ]
         exit
      endif
      #ifdef __XPP__
         DEFAULT ::aControls[ n ]:lActive := .t.
      #endif
      If ::aControls[ n ]:lActive .and. ;
         lAnd( GetWindowLong( ::aControls[ n ]:hWnd, GWL_STYLE ), WS_TABSTOP )
         oControl := ::aControls[ n ]
         exit
      endif
      n--
   end

   if oControl == nil
      oControl := ::aControls[ 1 ]
   endif

return oControl

//------------------------------------------------------------------------//

METHOD FirstActiveCtrl() CLASS TWindow

   local n := 1
   local oControl, oRadMenu

   if len(::aControls) == 1
      return ::aControls[ 1 ]
   endif

   while n <= Len( ::aControls )
      If Upper( ::aControls[ n ]:ClassName() ) == 'TRADIO'
         oRadMenu = ::aControls[ n ]:oRadMenu
         while n <= Len( ::aControls ) .and. Upper( ::aControls[ n ]:ClassName() ) == 'TRADIO' .and. ;
               ::aControls[ n ]:oRadMenu == oRadMenu .and. ( !::aControls[ n ]:lChecked .or. ;
               !::aControls[ n ]:lActive )
            n++
         end
         oControl := ::aControls[ n ]
         exit
      endif
      If ::aControls[ n ]:lActive .and. ;
         lAnd( GetWindowLong( ::aControls[ n ]:hWnd, GWL_STYLE ), WS_TABSTOP )
         oControl := ::aControls[ n ]
         exit
      endif
      n++
   end

   if oControl == nil
      oControl := ::aControls[ 1 ]
   endif

return oControl

//------------------------------------------------------------------------//

function WndParents( xWnd1, xWnd2 )

   Local aParent1, aParent2
   Local nFor, nLen

   aParent1 := ScanParents( xWnd1 )
   aParent2 := ScanParents( xWnd2 )

   nLen := Len( aParent1 )

   for nFor := 1 to nLen
      if Ascan( aParent2, aParent1[ nFor ] ) > 0
         return .t.
      end
   next

return .f.

//----------------------------------------------------------------------------//

static function ScanParents( xWnd )

   local aWnd := {}
   local cClassName
   local hWnd

   if ValType( xWnd ) == "O"
      xWnd = xWnd:hWnd
   end

   while ( hWnd := GetParent( xWnd ) ) != 0
      cClassName = Upper( GetClassName( hWnd ) )
      if "BROWSE" $ cClassName // Both TWBrowse and TCBrowse
         exit
      endif
      AAdd( aWnd, hWnd )
      if cClassName == "#32770" .and. ;
         ! lAnd( GetWindowLong( hWnd, GWL_STYLE ), WS_CHILD )
         exit
      endif
      if cClassName $ "TMDICHILD;TWINDOW"
         exit
      end
      xWnd := hWnd
   end

return aWnd

//----------------------------------------------------------------------------//

function oWndFromhWnd( hWnd )

   local nAt := AScan( aWindows,;
                       { | o | ValType( o ) == "O" .and. o:hWnd == hWnd } )

return If( nAt > 0, aWindows[ nAt ] , nil )

//----------------------------------------------------------------------------//