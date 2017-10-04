#include "FiveWin.Ch"
#include "Constant.ch"

#define SB_HORZ         0
#define SB_VERT         1
#define SB_CTL          2

#define COLOR_SCROLLBAR 0
#define COLOR_WINDOW    5

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TScrollBar FROM TControl

   DATA   lVertical, lReDraw, lIsChild, nMin, nMax, nPgStep
   DATA   bGoUp, bGoDown, bGoTop, bGoBottom, bPageUp, bPageDown, bPos
   DATA   bTrack

   CLASSDATA aProperties INIT { "cVarName", "nMin", "nMax",;
                                "nPgStep", "nTop", "nLeft", "Cargo" }

   METHOD New( nRow, nCol, nMin, nMax, nPgStep, lVertical, oWnd, nWidth,;
               nHeight, bUpAction, bDownAction, bPgUp, bPgDown,;
               bPos, lPixel, nClrText, nClrBack, cMsg, lUpdate,;
               bWhen, bValid, lDesign ) CONSTRUCTOR

   METHOD WinNew( nMin, nMax, nPgStep, lVertical, oWnd, bUpAction,;
                  bDownAction, bPgUp, bPgDown, bPos, nClrText, nClrBack,;
                  lUpdate, bWhen, bValid ) CONSTRUCTOR

   METHOD ReDefine( nID, nMin, nMax, nPgStep, oWnd, bUpAction, bDownAction, ;
                    bPgUp, bPgDown, bPos, nClrText, nClrBack, cMsg,;
                    lUpdate, bWhen, bValid ) CONSTRUCTOR

   METHOD cToChar() INLINE Super:cToChar( "SCROLLBAR" )

   METHOD GetPos() INLINE GetScrollPos( If( ::lIsChild, ::oWnd:hWnd, ::hWnd ),;
            If( ::lIsChild, If( ::lVertical, SB_VERT, SB_HORZ ), SB_CTL ) )

   METHOD GetRange() INLINE GetScrollRange( If( ::lIsChild, ::oWnd:hWnd, ::hWnd ),;
            If( ::lIsChild, If( ::lVertical, SB_VERT, SB_HORZ ), SB_CTL ) )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg ) INLINE  Super:Initiate( hDlg ), ;
                               ::SetRange( ::nMin, ::nMax ),;
                               ::SetPos( ::nMin )

   // These two have to be BLOCK

   METHOD GoUp()   BLOCK { | Self, nPos | nPos := ::GetPos(),;
                                          if( nPos > ::GetRange()[ 1 ],;
                                              ::SetPos( --nPos ), ),;
                          If( ::bGoUp != nil, Eval( ::bGoUp ),) }

   METHOD GoDown() BLOCK { | Self, nPos | nPos := ::GetPos(),;
                                          if( nPos < ::nMax,;
                                              ::SetPos( ++nPos ), ),;
                          If( ::bGoDown != nil, Eval( ::bGoDown ),) }


   METHOD GoTop() INLINE  ::SetPos( ::nMin ),;
                          If( ::bGoTop != nil, Eval( ::bGoTop ),)

   METHOD GoBottom() INLINE  ::SetPos( ::nMax ),;
                             If( ::bGoBottom != nil, Eval( ::bGoBottom ),)

   METHOD PageUp() INLINE  If( ::bPageUp != nil, Eval( ::bPageUp ),),;
                           ::SetPos( ::GetPos() - ::nPgStep )

   METHOD PageDown() INLINE  If( ::bPageDown != nil, Eval( ::bPageDown ),),;
                                 ::SetPos( ::GetPos() + ::nPgStep )

   METHOD SetPage( nSize )

   METHOD SetPos( nPos ) INLINE ;
                 SetScrollPos( if( ::lIsChild, ::oWnd:hWnd, ::hWnd ),;
                 If( ::lIsChild, If( ::lVertical, SB_VERT, SB_HORZ ), SB_CTL ),;
                 nPos, ::lReDraw )

   METHOD SetRange( nMin, nMax ) INLINE ;
                                  ::nMin := nMin, ::nMax := nMax, ;
           SetScrollRange( if( ::lIsChild, ::oWnd:hWnd, ::hWnd ), ;
               if( ::lIsChild, If( ::lVertical, SB_VERT, SB_HORZ ), SB_CTL ), ;
                    nMin, nMax, ::lReDraw )

   METHOD ThumbPos( nPos ) INLINE  If( ::bPos != nil, Eval( ::bPos, nPos ),)

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD ThumbTrack( nPos ) INLINE If( ::bTrack != nil, Eval( ::bTrack, nPos ),)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nMin, nMax, nPgStep, lVertical, oWnd, nWidth, nHeight,;
            bUpAct, bDownAct, bPgUp, bPgDown, bPos, lPixel, nClrText,;
            nClrBack, cMsg, lUpdate, bWhen, bValid, lDesign ) CLASS TScrollBar

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT nRow := 0, nCol := 0,;
           nMin := 0, nMax := 0, nPgStep := 1,;
           oWnd := GetWndDefault(),;
           lVertical := .t., nWidth := If( lVertical, 16, 100 ),;
           nHeight   := If( lVertical, 100, 17 ),;
           lPixel    := .f.,;
           nClrText  := GetSysColor( COLOR_WINDOW ),;
           nClrBack  := GetSysColor( COLOR_SCROLLBAR ),;
           lUpdate   := .f., lDesign := .f.

   ::cCaption   = ""
   ::nTop       = nRow * If( lPixel, 1, SCRL_CHARPIX_H ) //14
   ::nLeft      = nCol * If( lPixel, 1, SCRL_CHARPIX_W ) // 8
   ::nBottom    = ::nTop + nHeight - 1
   ::nRight     = ::nLeft + nWidth - 1
   ::nMin       = nMin
   ::nMax       = nMax
   ::nPgStep    = nPgStep
   ::lVertical  = lVertical
   ::lReDraw    = .t.
   ::nStyle     = nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP,;
                       If( lVertical, SBS_VERT, SBS_HORZ ),;
                       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::bGoUp      = bUpAct
   ::bGoDown    = bDownAct
   ::bPageUp    = bPgUp
   ::bPageDown  = bPgDown
   ::bPos       = bPos
   ::oWnd       = oWnd
   ::lIsChild   = .f.
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::cMsg       = cMsg
   ::lUpdate    = lUpdate
   ::bWhen      = bWhen
   ::bValid     = bValid

   ::SetColor( nClrText, nClrBack )

   if ! Empty( oWnd:hWnd )
      ::Create( "SCROLLBAR" )
      ::SetRange( ::nMin, ::nMax )
      ::SetPos( ::nMin )
      ::SetPage( ::nPgStep )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//---------------------------------------------------------------------------//

// Constructor for non-true ScrollBar Controls
// ( when using WS_VSCROLL, WS_HSCROLL styles in a Window )
// They are NOT controls but we consider them as real Objects!

METHOD WinNew( nMin, nMax, nPgStep, lVertical, oWnd, bUpAction,;
               bDownAction, bPgUp, bPgDown, bPos, nClrText, nClrBack,;
               lUpdate, bWhen, bValid ) CLASS TScrollBar

   DEFAULT nMin := 1, nMax := 2, nPgStep := 1, lVertical := .t.,;
           nClrText  := GetSysColor( COLOR_WINDOW ),;
           nClrBack  := GetSysColor( COLOR_SCROLLBAR ),;
           lUpdate   := .f.

   ::oWnd      = oWnd
   ::lVertical = lVertical
   ::lReDraw   = .t.
   ::lIsChild  = .t.
   ::nMin      = nMin
   ::nMax      = nMax
   ::nPgStep   = nPgStep
   ::bGoUp     = bUpAction
   ::bGoDown   = bDownAction
   ::bPageUp   = bPgUp
   ::bPageDown = bPgDown
   ::bPos      = bPos
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bValid    = bValid
   ::hWnd      = 0

   ::SetColor( nClrText, nClrBack )
   ::SetRange( nMin, nMax )
   ::SetPage( nPgStep )
   ::SetPos( nMin )

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nID, nMin, nMax, nPgStep, oWnd, bUpAction, bDownAction, ;
                 bPgUp, bPgDown, bPos, nClrText, nClrBack, cMsg,;
                 lUpdate, bWhen, bValid ) CLASS TScrollbar

   DEFAULT nMin := 0, nMax := 0, nPgStep := 1,;
           nClrText  := GetSysColor( COLOR_WINDOW ),;
           nClrBack  := GetSysColor( COLOR_SCROLLBAR ),;
           lUpdate   := .f.

   ::nID        = nID
   ::nMin       = nMin
   ::nMax       = nMax
   ::nPgStep    = nPgStep
   ::lVertical  = .f.
   ::lReDraw    = .t.
   ::bGoUp      = bUpAction
   ::bGoDown    = bDownAction
   ::bPageUp    = bPgUp
   ::bPageDown  = bPgDown
   ::bPos       = bPos
   ::oWnd       = oWnd
   ::lIsChild   = .f. // .t. only for Windows with WS_HSCROLL ¢ WS_VSCROLL style
   ::lRedraw    = .t.
   ::oWnd       = oWnd
   ::lDrag      = .f.
   ::lCaptured  = .f.
   ::cMsg       = cMsg
   ::lUpdate    = lUpdate
   ::bWhen      = bWhen
   ::bValid     = bValid

   ::SetColor( nClrText, nClrBack )
   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TScrollBar

   do case
      case nMsg == FM_SCROLLUP
           ::GoUp()
           return 0

      case nMsg == FM_SCROLLDOWN
           ::GoDown()
           return 0

      case nMsg == FM_SCROLLPGUP
           ::PageUp()
           return 0

      case nMsg == FM_SCROLLPGDN
           ::PageDown()
           return 0

      case nMsg == FM_THUMBPOS
           ::ThumbPos( nWParam )
           return 0

      case nMsg == FM_THUMBTRACK
           ::ThumbTrack( nWParam )
           return 0
   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TScrollBar

   local nResult := Super:MouseMove( nRow, nCol, nKeyFlags )

return If( ::lDrag, nResult, nil )    // We want standard behavior !!!

//----------------------------------------------------------------------------//

METHOD SetPage( nSize, lReDraw, lShowDisabled ) CLASS TScrollBar

   local nFlags

   If ! IsWinNT()  // Cuando NO Sea NT o W2K porque no va bien

      DEFAULT lRedraw := .f., lShowDisabled := .f.

      if ! Empty( ::hWnd )
         nFlags = SB_CTL
      else
         if ::lVertical
            nFlags = SB_VERT
         else
            nFlags = SB_HORZ
         endif
      endif
      SetScrollInfo( If( ! Empty( ::hWnd ), ::hWnd, ::oWnd:hWnd ),;
                     nFlags, nSize, lReDraw, lShowDisabled )
   EndIf

return nil

//----------------------------------------------------------------------------//