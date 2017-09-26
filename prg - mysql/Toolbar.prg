// Win32 common controls ToolBar

#include "FiveWin.Ch"

#define CCS_TOP                   1
#define CCS_NOMOVEY               2
#define CCS_BOTTOM                3
#define CCS_NORESIZE              4
#define CCS_NOPARENTALIGN         8
#define CCS_ADJUSTABLE           32
#define CCS_NODIVIDER            64
#define CCS_VERT                128
#define CCS_LEFT                129
#define CCS_NOMOVEX             130
#define CCS_RIGHT               131

#define TBSTYLE_TRANSPARENT   32768 // 0x8000
#define TBSTYLE_FLAT           2048 // 0x0800
#define TBSTYLE_TOOLTIPS        256 // 0x0100
#define TBSTYLE_WRAPABLE        512 // 0x0200

#define TB_CUSTOMIZE           1051
#define TB_AUTOSIZE            1057
#define TB_SETIMAGELIST        1072
#define TB_SETSTYLE            1080
#define TB_GETSTYLE            1081

#define TTN_GETDISPINFO        -530

#define WM_ERASEBKGND            20

//----------------------------------------------------------------------------//

CLASS TToolBar FROM TControl

   DATA   nBtnWidth, nBtnHeight
   DATA   aButtons
   DATA   oImageList

   METHOD New( oWnd, nBtnWidth, nBtnHeight, oImageList ) CONSTRUCTOR

   METHOD Create()

   METHOD AddButton( bAction, cToolTip, cText, bWhen )

   METHOD AddSeparator() INLINE TBAddSeparator( ::hWnd )

   METHOD Command( nWParam, nLParam )

   #ifndef __C3__
      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   #endif

   METHOD EnableButton( nButton, lOnOff ) INLINE  TBEnableButton( ::hWnd, nButton, lOnOff )
   METHOD AutoSize()                      INLINE  SendMessage( ::hWnd, TB_AUTOSIZE, 0, 0 );

   #ifndef __C3__
      METHOD EraseBkGnd( hDC ) INLINE 1
   #endif

   METHOD GotFocus() INLINE 1  // To avoid getting focus!

   METHOD RButtonDown() VIRTUAL

   METHOD MouseMove() VIRTUAL

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   #ifndef __C3__
      METHOD Paint()
   #endif

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, nBtnWidth, nBtnHeight, oImageList ) CLASS TToolBar

   DEFAULT oWnd := GetWndDefault(), nBtnWidth := 33, nBtnHeight := 33

   ::oWnd         = oWnd
   ::nId          = ::GetNewId()
   ::nBtnWidth    = nBtnWidth
   ::nBtnHeight   = nBtnHeight
   ::aButtons     = {}
   ::oImageList   = oImageList
   ::lDrag        = .f.

   if Upper( oWnd:ClassName() ) != "TREBAR"
      oWnd:oTop   = Self
   endif

   InitCommonControls()

   if ! Empty( oWnd:hWnd )
      ::Create()
      ::nHeight   = nBtnHeight + 3
      oWnd:AddControl( Self )
      if oImageList != nil
         SendMessage( ::hWnd, TB_SETIMAGELIST, 0, oImageList:hImageList )
      endif
   else
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD AddButton( bAction, nBitmap, cToolTip, cText, bWhen ) CLASS TToolBar

   AAdd( ::aButtons, { bAction, cToolTip } )

   DEFAULT nBitmap   := Len( ::aButtons )

   TBAddButton( ::hWnd, Len( ::aButtons ), nBitmap, cText )

   if bWhen != nil .and. ! Eval( bWhen )
      ::EnableButton( Len( ::aButtons ), .f. )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Create() CLASS TToolBar

   local nTransStyle := If( ! Upper( ::oWnd:ClassName() ) $ "TWINDOW,TMDIFRAME,TMDICHILD", TBSTYLE_TRANSPARENT, 0 )

   nTransStyle       := nOr(  nTransStyle,;
                              TBSTYLE_WRAPABLE,;
                              TBSTYLE_FLAT,;
                              TBSTYLE_TOOLTIPS,;
                              CCS_NODIVIDER,;
                              CCS_NORESIZE,;
                              CCS_ADJUSTABLE )

   ::hWnd            := CreateTlBar( ::oWnd:hWnd, ::nId, ::nBtnWidth, ::nBtnHeight )

   if ::hWnd == 0
      WndCreateError( Self )
   else
      nTransStyle    := nOr( SendMessage( ::hWnd, TB_GETSTYLE ), nTransStyle )

      SendMessage( ::hWnd, TB_SETSTYLE, 0, nTransStyle )

      ::Link()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Command( nWParam, nLParam ) CLASS TToolBar

   local nNotifyCode, nID, hWndCtl
   local bAction

   #ifdef __CLIPPER__
      nNotifyCode = nHiWord( nLParam )
      nID         = nWParam
      hWndCtl     = nLoWord( nLParam )
   #else
      nNotifyCode = nHiWord( nWParam )
      nID         = nLoWord( nWParam )
      hWndCtl     = nLParam
   #endif

   if ( nID <= len( ::aButtons ) ) .and. ( bAction := ::aButtons[ nID, 1 ] ) != nil
      Eval( bAction, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TToolBar

   local nCode := GetNMHDRCode( nPtrNMHDR )

   // LogFile( "notify.txt", { nCode } )

   do case
      case nCode == TTN_GETDISPINFO
           TTNSetText( nPtrNMHDR, ::aButtons[ GetNMHDRIdFrom( nPtrNMHDR ) ][ 2 ] )
   endcase

return nil

//----------------------------------------------------------------------------//

#ifndef __C3__

METHOD Paint() CLASS TToolBar

   local aInfo := ::DispBegin()

   if ::oBrush != nil
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_ERASEBKGND, ::hDC, 0 )
   endif
   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

   ::DispEnd( aInfo )

return 1

#endif

//----------------------------------------------------------------------------//