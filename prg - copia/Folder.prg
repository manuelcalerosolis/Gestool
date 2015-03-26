#include "FiveWin.Ch"
#include "Constant.ch"

#define COLOR_BTNFACE       15

#define FD_BORDER            8
//#define FD_HEIGHT           30

#define FD_TABMARGIN        40

#define DT_CENTER            1

#define TCM_FIRST         4864   // 0x1300
#define TCM_SETCURSEL    ( TCM_FIRST + 12 )

#define TCN_FIRST         -550
#define TCN_SELCHANGE    ( TCN_FIRST - 1 )
#define TCN_SELCHANGING  ( TCN_FIRST - 2 )

#define TCS_MULTILINE        512  // 0x0200
#define TCS_OWNERDRAWFIXED   8192 // 0x2000

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TFolder FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   aPrompts, aDialogs
   DATA   nOption, nTabSize, nFdHeight
   DATA   oFont2
   DATA   aEnable
   DATA   lAllWidth AS LOGICAL INIT .t.
   DATA   lWin95Look AS LOGICAL

   CLASSDATA aProperties ;
      INIT { "aPrompts", "cVarName", "nClrText",;
             "nClrPane", "nAlign", "nTop", "nLeft",;
             "nWidth", "nHeight", "nOption", "Cargo" }

   METHOD New( nTop, nLeft, aPrompts, aDialogs, oWnd, nOption, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg, lAllWidth, oFont ) CONSTRUCTOR

   METHOD ReDefine( nId, aPrompts, aDialogs, oWnd, nOption, nClrFore,;
                    nClrBack, bChange, lAllWidth ) CONSTRUCTOR

   #ifdef __CLIPPER__
      METHOD Display()
      METHOD Paint()
   #else
      METHOD Display() VIRTUAL
      METHOD Paint() VIRTUAL
      METHOD CtlColor( hWndChild, hDCChild )
   #endif

   METHOD Initiate( hDlg )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD Default()
   METHOD ReSize( nType, nWidth, nHeight )

   METHOD AddItem( cItem )

   #ifndef __CLIPPER__
      METHOD cToChar() INLINE Super:cToChar( "SysTabControl32" )
   #endif

   METHOD DelItem()

   METHOD DelPages()

   METHOD Destroy()

   METHOD GotFocus( hWndLoseFocus )

   METHOD LoadPages( aResNames, bRedefineControls )

   #ifndef __CLIPPER__
      METHOD MouseMove( nRow, nCol, nFlags ) INLINE ;
    ( Super:MouseMove( nRow, nCol, nFlags ), nil ) // finally invoke default behavior
   #endif

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   METHOD SetOption( nOption )

   METHOD SetPrompts( aPrompts )

   METHOD GetHotPos( nChar )


   #ifdef __CLIPPER__
     METHOD Refresh() INLINE ;
            InvalidateRect( ::hWnd, { 0, 0, ::nFdHeight + 2, ::nWidth } )
   #endif

   #ifdef __CLIPPER__
      METHOD Update() INLINE ASend( ::aDialogs, "Update" )
   #else
      METHOD Update() INLINE ASend( ::aDialogs, "Update()" )
   #endif

   METHOD KeyDown( nKey, nFlags )

   #ifndef __CLIPPER__
      METHOD AdjustRect()
   #endif

   METHOD HScroll( nWParam, nLParam ) VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, aPrompts, aDialogs, oWnd, nOption, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, lAllWidth,;
            oFont ) CLASS TFolder

   #ifdef __XPP__
      #undef New
   #endif

   local n, oDlg

   DEFAULT nTop := 0, nLeft := 0,;
           aDialogs  := {},;
           aPrompts  := { "&One", "&Two", "T&hree" },;
           oWnd      := GetWndDefault(),;
           nOption   := 1,;
           nClrFore  := oWnd:nClrText,;
           nClrBack  := GetSysColor( COLOR_BTNFACE ),;
           lPixel    := .f.,;
           lDesign   := .f.,;
           nWidth    := 100, nHeight := 100,;
           lAllWidth := .t.

   if Len( aDialogs ) < Len( aPrompts )
      aDialogs = Array( Len( aPrompts ) )
   endif

   if ::aEnable == nil
      ::aEnable = Array( Len( aPrompts ) )
      AFill( ::aEnable, .t. )
   endif

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      WS_TABSTOP /* , TCS_OWNERDRAWFIXED */ )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::aPrompts  = aPrompts
   ::aDialogs  = aDialogs
   ::nOption   = nOption
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.

   ::oFont2    = TFont():New( GetSysFont(), 0, -9,, .t. )
   ::lAllWidth = lAllWidth
   ::nFdHeight = If( LargeFonts(), 25 , 22 )
   ::cVarName  = ""
   ::lWin95Look = GetVersion()[ 1 ] > 3 .or. GetVersion()[ 2 ] > 51 .or. ;
                  IsWinNT()

   ::SetColor( nClrFore, nClrBack )

   ::Register()

   if ! Empty( oWnd:hWnd )
      #ifdef __CLIPPER__
         ::Create()
      #else
         ::Create( "SysTabControl32" )
         ::SetPrompts()
      #endif
      if oFont != nil
         ::SetFont( oFont )
      elseif oWnd != nil .and. oWnd:oFont != nil
         ::SetFont( oWnd:oFont )
      else
         ::GetFont()
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   for n = 1 to Len( ::aDialogs )
      DEFINE DIALOG oDlg OF Self STYLE WS_CHILD  ;
         FROM 0, 0 TO ::nHeight() - ::nFdHeight - 5, ::nWidth() - 6 PIXEL ;
         FONT Self:oFont
      ::aDialogs[ n ] = oDlg
      oDlg:cVarName = "Page" + AllTrim( Str( n ) )
   next

   if ! Empty( oWnd:hWnd )
      ::Default()
   endif

   if lDesign
      ::CheckDots()
   endif

   SetWndDefault( oWnd )

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, aPrompts, aDialogs, oWnd, nOption, ;
                 nClrFore, nClrBack, bChange, lAllWidth ) CLASS TFolder

   local n, oDlg

   DEFAULT nOption  := 1,;
           nClrFore := oWnd:nClrText,;
           nClrBack := oWnd:nClrPane,;
           aDialogs := Array( Len( aPrompts ) ),;
           lAllWidth := .f.

   if ::aEnable == nil
      ::aEnable = Array( Len( aPrompts ) )
      AFill( ::aEnable, .t. )
   endif

   ::nId      = nId
   ::oWnd     = oWnd
   ::aPrompts = aPrompts
   ::aDialogs = aDialogs
   ::nOption  = nOption

   if oWnd != nil .and. oWnd:oFont != nil
      ::SetFont( oWnd:oFont )
   else
      ::GetFont()
   endif

   ::oFont2     = TFont():New( GetSysFont(), 0, -9,, .t. )
   ::bChange    = bChange
   ::nClrPane   = GetSysColor( COLOR_BTNFACE )
   ::lAllWidth  = lAllWidth
   ::nFdHeight  = If( LargeFonts(), 25 , 22 )
   ::lWin95Look = GetVersion()[ 1 ] > 3 .or. GetVersion()[ 2 ] > 51 .or. ;
                  IsWinNT()

   ::Register()

   ::SetColor( nClrFore, nClrBack )

   for n = 1 to Len( ::aDialogs )
      DEFINE DIALOG oDlg OF Self RESOURCE ::aDialogs[ n ] ;
         COLOR nClrFore, nClrBack FONT Self:oFont
      ::aDialogs[ n ] = oDlg
   next

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

#ifdef __CLIPPER__

METHOD Display() CLASS TFolder

   ::BeginPaint()
   ::Paint()
   ::EndPaint()

return 0

#endif

//----------------------------------------------------------------------------//

#ifndef __CLIPPER__

METHOD CtlColor( hWndChild, hDCChild ) CLASS TFolder

   if GetClassName( hWndChild ) $ "Button,Static" .and. IsAppThemed()
      return DrawThemed( hWndChild, hDCChild )
   endif

return Super:CtlColor( hWndChild, hDCChild )

#endif

//----------------------------------------------------------------------------//

#ifdef __CLIPPER__

METHOD Paint() CLASS TFolder

   SetBkMode( ::hDC, 1 ) // make it transparent to allow bitmaps in background
   FoldPaint( ::hWnd, ::hDC, ::aPrompts, ::oFont:hFont,;
              ::oFont2:hFont, ::nClrPane, ::nOption, ::aEnable, ::nTabSize,;
              ::lWin95Look, ::nFdHeight )

return nil

#endif

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TFolder

   local n

   Super:Initiate( hDlg )

   ::Default()

   for n = 1 to Len( ::aDialogs )
      #ifdef __CLIPPER__
         ::aDialogs[ n ]:SetSize( ::nWidth() - 6,;
                                  ::nHeight() - ::nFdHeight - 5 )
      #else
         ::aDialogs[ n ]:SetSize( ::nWidth() - 5,;
                                  ::nHeight() - ::nFdHeight - 4 )
      #endif
   next

   #ifndef __CLIPPER__
      ::SetPrompts( ::aPrompts )
   #endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TFolder

   local n := 1

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   else

      #ifdef __CLIPPER__
         if nRow <= ::nFdHeight
            while nCol > ( nPos + If( ::lWin95Look,;
                  nTabSize := GetTextWidth( 0, ::aPrompts[ n ],;
                              ::oFont:hFont ) + 13, nTabSize ) ) .and. ;
                  n < Len( ::aPrompts )
               nPos += nTabSize
               n++
            end
         endif
      #else
         n = TabCtrl_HitTest( ::hWnd ) + 1
      #endif
      ::SetOption( n )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TFolder

   local nLen := Len( ::aPrompts ), n
   local oDlg
   local nHeight := ::nFdHeight

   if nLen > 0
      if ::lAllWidth
         ::nTabSize = int( ::nWidth() / nLen )
      else
         ::nTabSize := 0
         for n = 1 to nLen
            ::nTabSize = Max( ::nTabSize, ;
                              int( GetTextWidth( 0, ::aPrompts[n], ;
                              ::oFont:hFont ) + FD_TABMARGIN ) )
         next n
         ::nTabSize = Min( ::nTabSize, int( ::nWidth() / nLen ) )
      endif
   else
      ::nTabSize = ::nWidth()
   endif

   for nLen = 1 to Len( ::aDialogs )
      oDlg = ::aDialogs[ nLen ]

      #ifdef __CLIPPER__
         ACTIVATE DIALOG oDlg NOWAIT ;
            ON INIT ( oDlg:Move( nHeight + 2, 3 ) ) ;
            VALID .f.                // to avoid exiting pressing Esc !!!
      #else
         ACTIVATE DIALOG oDlg NOWAIT ;
            ON INIT oDlg:Move( nHeight, 1 ) ;
            VALID .f.                // to avoid exiting pressing Esc !!!
      #endif

      #ifndef __CLIPPER__
         if IsAppThemed()
            // oDlg:SetBrush( TBrush():New( "NULL" ) )
            oDlg:bEraseBkGnd = { | hDC | DrawPBack( oDlg:hWnd, hDC ), 1 }
         endif
      #endif

      oDlg:Hide()
   next

   if Len( ::aDialogs ) > 0
      if ::nOption <= Len( ::aDialogs )
         ::aDialogs[ ::nOption ]:Show()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

function SysWait( nLong )

   local nSeconds

   DEFAULT nLong := .1
   nSeconds := Seconds() + nLong

   while Seconds() < nSeconds
     SysRefresh()
   end

return nil

//----------------------------------------------------------------------------//

METHOD Resize( nType, nWidth, nHeight ) CLASS TFolder

   local nLen := Len( ::aPrompts ), n

   if nLen > 0
      if ::lAllWidth
         ::nTabSize = int( nWidth / nLen )
      else
         ::nTabSize := 0
         for n = 1 to nLen
            ::nTabSize = Max( ::nTabSize, ;
                              int( GetTextWidth( 0, ::aPrompts[n], ;
                                            ::oFont:hFont ) + FD_TABMARGIN ) )
         next n
         ::nTabSize = Min( ::nTabSize, int( nWidth / nLen ) )
      endif
   else
      ::nTabSize = nWidth + 1
   endif

   for n = 1 to Len( ::aDialogs )
      ::aDialogs[ n ]:SetSize( nWidth - 6, nHeight - ::nFdHeight - 5 )
   next

return Super:Resize( nType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD SetPrompts( aPrompts ) CLASS TFolder

   local n

   if ! Empty( aPrompts )
      ::aPrompts = aPrompts
   endif

   #ifndef __CLIPPER__
      TabDelAllItems( ::hWnd )

      for n = Len( ::aPrompts ) to 1 step -1
         TabCtrlAdd( ::hWnd, ::aPrompts[ n ], ::aEnable[ n ] )
      next

      SendMessage( ::hWnd, TCM_SETCURSEL, ::nOption - 1 )
      Super:Refresh()
   #endif

return nil

//----------------------------------------------------------------------------//

METHOD AddItem( cItem ) CLASS TFolder

   local oDlg
   local oThis := Self

   DEFINE DIALOG oDlg OF Self STYLE WS_CHILD ;
      FROM 0, 0 TO oThis:nHeight - oThis:nFdHeight - 5, oThis:nWidth - 6 PIXEL

   AAdd( ::aDialogs, oDlg )
   AAdd( ::aPrompts, cItem )
   AAdd( ::aEnable, .t. )

   ACTIVATE DIALOG oDlg NOWAIT ;
      ON INIT ( oDlg:Move( oThis:nFdHeight + 2, 3 ) ) ;
      VALID .f.            // to avoid exiting pressing Esc !!!

   oDlg:Hide()
   oDlg:SetSize( ::nWidth - 6, ::nHeight - ::nFdHeight - 5 )

   #ifdef __CLIPPER__
      if ( nLen := Len( ::aPrompts ) ) > 0
         if ::lAllWidth
            ::nTabSize = int( ::nWidth / nLen )
         else
            ::nTabSize := 0
            for n = 1 to nLen
               ::nTabSize = Max( ::nTabSize, ;
                                 int( GetTextWidth( 0, ::aPrompts[n], ;
                                            ::oFont:hFont ) + FD_TABMARGIN ) )
            next n
            ::nTabSize = Min( ::nTabSize, int( ::nWidth / nLen ) )
         endif
      else
         ::nTabSize = ::nWidth + 1
      endif
      ::Refresh()
   #else
      ::SetPrompts( ::aPrompts )
      ::SetOption( Len( ::aDialogs ) )
   #endif

return nil

//----------------------------------------------------------------------------//

METHOD DelPages() CLASS TFolder

   while Len( ::aPrompts ) > 0
      ::DelItem()
   end

return nil

//----------------------------------------------------------------------------//

METHOD DelItem( nOption ) CLASS TFolder

   local nLen, n

   DEFAULT nOption   := ::nOption

   if Len( ::aPrompts ) > 0
      ::aPrompts = ADel( ::aPrompts, nOption )
      ::aPrompts = ASize( ::aPrompts, Len( ::aPrompts ) - 1 )
      ::aDialogs[ nOption ]:bValid = { || .t. }
      ::aDialogs[ nOption ]:End()
      ::aDialogs = ADel( ::aDialogs, nOption )
      ::aDialogs = ASize( ::aDialogs, Len( ::aDialogs ) - 1 )
   endif

   ::nOption         := Min( nOption, Len( ::aPrompts ) )

   if ( nLen := Len( ::aPrompts ) ) > 0
      if ::lAllWidth
         ::nTabSize = int( ::nWidth / nLen )
      else
         ::nTabSize  := 0
         for n = 1 to nLen
            ::nTabSize  := Max( ::nTabSize, int( GetTextWidth( 0, ::aPrompts[n], ::oFont:hFont ) + FD_TABMARGIN ) )
         next n
         ::nTabSize  := Min( ::nTabSize, int( ::nWidth / nLen ) )
      endif
   else
      ::nTabSize     := ::nWidth + 1
   endif

   ::Refresh()
   ::SetPrompts( ::aPrompts )

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TFolder

   local n

   ::oFont2:End()

   if ::oFont != nil
      ::oFont:End()
   endif

   for n = 1 to Len( ::aDialogs )
      ::aDialogs[ n ]:bValid = { || .t. }
      ::aDialogs[ n ]:End()
   next

return Super:Destroy()

//----------------------------------------------------------------------------//

METHOD GotFocus( hWndLoseFocus ) CLASS TFolder

   Super:GotFocus()

   if ::nOption > 0 .and. ::nOption <= Len( ::aDialogs )
      ::aDialogs[ ::nOption ]:AEvalWhen()
      ::aDialogs[ ::nOption ]:SetFocus()
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LoadPages( aResNames, bRedefineControls ) CLASS TFolder

   local n, oDlg
   local oThis := Self

   ::DelPages()

   ::aPrompts = aResNames
   ::aDialogs = Array( Len( aResNames ) )

   for n = 1 to Len( ::aDialogs )
      DEFINE DIALOG oDlg OF Self RESOURCE aResNames[ n ] ;
         FONT Self:oFont

      ::aDialogs[ n ] = oDlg

      if bRedefineControls != nil
         Eval( bRedefineControls, Self, n )
      endif

      ACTIVATE DIALOG oDlg NOWAIT ;
         ON INIT ( oDlg:Move( oThis:nFdHeight + 2, 3 ) ) ;
         VALID .f.                // to avoid exiting pressing Esc !!!

      oDlg:Hide()
   next

   ::nOption = 1
   ::aDialogs[ 1 ]:Show()

return nil

//----------------------------------------------------------------------------//

METHOD SetOption( nOption ) CLASS TFolder

   local nOldOption


   if nOption > 0 .and. nOption != ::nOption .and. ::aEnable[ nOption ]
      if ::nOption <= Len( ::aDialogs ) .and. ::aDialogs[ ::nOption ] != nil
         ::aDialogs[ ::nOption ]:Hide()
      endif
      nOldOption = ::nOption
      ::nOption  = nOption

      #ifdef __CLIPPER__
         InvalidateRect( ::hWnd, { 0, 0, ::nFdHeight + 2, ::nWidth() } )
      #endif

      if nOption <= Len( ::aDialogs ) .and. ::aDialogs[ nOption ] != nil
         if ::bChange != nil
            Eval( ::bChange, nOption, nOldOption )
         endif
         ::aDialogs[ nOption ]:AEvalWhen()
         ::aDialogs[ nOption ]:Show()
         ::aDialogs[ nOption ]:SetFocus()
      endif
   endif


   if nOption > 0
      #ifndef __CLIPPER__
         PostMessage( ::hWnd, TCM_SETCURSEL, ::nOption - 1 )
      #endif
      if ! ::aEnable[ nOption ]
         MsgBeep()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetHotPos( nChar ) CLASS TFolder

   local n := 1
   local nAt

   while n <= Len( ::aPrompts )
     if n != ::nOption .and. ::aEnable[n] .and. ;
        ( nAt := At( "&", ::aPrompts[ n ] ) ) != 0 .and. ;
        Lower( SubStr( ::aPrompts[ n ], nAt + 1, 1 ) ) == ;
        Lower( Chr( nChar ) )
        return n
     endif
     n++
   end

return 0

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TFolder

   local nCode := GetNMHDRCode( nPtrNMHDR )

   static nOldOption

   do case
      case nCode == TCN_SELCHANGING
           #ifndef __CLIPPER__
              nOldOption = TabCtrl_GetCurSel( ::hWnd ) + 1
           #endif

      case nCode == TCN_SELCHANGE
           #ifndef __CLIPPER__
              if ! ::aEnable[ TabCtrl_GetCurSel( ::hWnd ) + 1 ]
                 TabCtrl_SetCurSel( ::hWnd, nOldOption - 1 )
              endif
           #endif
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TFolder

   do case
      case nKey == VK_NEXT
           TONE(155,3)
           return 0

      case nKey == VK_PRIOR
           TONE(955,3)
           return 0
   endcase

return Super:KeyDown( nKey, nFlags )


//----------------------------------------------------------------------------//

#ifndef __CLIPPER__

METHOD AdjustRect() CLASS TFolder

   local aRect:= TabCtrl_AdjustRect( ::hWnd )

   if Len( ::aDialogs ) > 0 .and. ::aDialogs[ 1 ]:nTop <> aRect[ 1 ]
      AEval( ::aDialogs, { | oDlg | oDlg:Move( aRect[ 1 ], aRect[ 2 ] ) } )
   endif

return nil

#endif

//----------------------------------------------------------------------------//