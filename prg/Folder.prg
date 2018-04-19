#include "FiveWin.ch"
#include "Constant.ch"

#define COLOR_BTNFACE       15

#define FD_BORDER            8
//#define FD_HEIGHT           30

#define FD_TABMARGIN        40

#define DT_CENTER            1

#define TCM_FIRST         4864   // 0x1300
#define TCM_SETIMAGELIST ( TCM_FIRST +  3 )
#define TCM_SETCURSEL    ( TCM_FIRST + 12 )
#define TCM_SETITEMSIZE  ( TCM_FIRST + 41 )
#define TCM_SETPADDING   ( TCM_FIRST + 43 )

#define TCN_FIRST         -550
#define TCN_SELCHANGE    ( TCN_FIRST - 1 )
#define TCN_SELCHANGING  ( TCN_FIRST - 2 )

#define TCS_MULTILINE        512  // 0x0200
#define TCS_OWNERDRAWFIXED   8192 // 0x2000

#ifdef __XPP__
   #define ::Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TFolder FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   aHelps
   DATA   aPrompts, aDialogs
   DATA   nOption, nTabSize, nFdHeight
   DATA   oFont2
   DATA   aEnable
   DATA   lAllWidth AS LOGICAL INIT .t.
   DATA   lWin95Look AS LOGICAL
   DATA   oImageList

   CLASSDATA aProperties ;
      INIT { "aPrompts", "cVarName", "nClrText",;
             "nClrPane", "nAlign", "nTop", "nLeft",;
             "nWidth", "nHeight", "nOption", "Cargo" }

   METHOD New( nTop, nLeft, aPrompts, aDialogs, oWnd, nOption, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg, lAllWidth, oFont, aHelps, cVarName ) CONSTRUCTOR

   METHOD ReDefine( nId, aPrompts, aDialogs, oWnd, nOption, nClrFore,;
                    nClrBack, bChange, lAllWidth, aHelps ) CONSTRUCTOR

   METHOD Display() VIRTUAL

   METHOD Paint() VIRTUAL

   METHOD CtlColor( hWndChild, hDCChild )

   METHOD Initiate( hDlg )

   METHOD LButtonDown( nRow, nCol, nFlags, lTouch )

   METHOD Default()

   METHOD ReSize( nType, nWidth, nHeight )

   METHOD AddItem( cItem, cResName, bRedefineControls )

   METHOD cGenPrg()

   METHOD cToChar() INLINE ::Super:cToChar( "SysTabControl32" )

   METHOD DelItem()

   METHOD DelItemPos( nPos )

   METHOD DelPages()

   METHOD Destroy()

   METHOD GotFocus( hWndLoseFocus )

   METHOD LoadPages( aResNames, bRedefineControls )

   METHOD MouseMove( nRow, nCol, nFlags ) INLINE ;
          ( ::Super:MouseMove( nRow, nCol, nFlags ), nil ) // finally invoke default behavior

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   METHOD SetItemText( nItem, cText )

   METHOD SetOption( nOption )

   METHOD SetPrompts( aPrompts, aHelps )

   METHOD GetHotPos( nChar )

   METHOD Update() INLINE ASend( ::aDialogs, "Update()" )

   METHOD AdjustRect()

   METHOD HScroll( nWParam, nLParam ) VIRTUAL

   METHOD SetImageList( oImgList ) INLINE ;
          ::oImageList := oImgList,;
          ::SendMsg( TCM_SETIMAGELIST, 0, oImgList:hImageList )

   METHOD SetItemSize( nWidth, nHeigth ) INLINE ;
          ::SendMsg( TCM_SETITEMSIZE, 0, nMakeLong( nWidth, nHeigth ) )   && by Rossine

   METHOD SetPadding( nTop, nLeft ) INLINE ;
          ::SendMsg( TCM_SETPADDING, 0, nMakeLong( nTop, nLeft ) )


   METHOD AddTab( cPrompt, lEnable, n ) INLINE ;
      If( ::lUnicode, TabCtrlAddw( ::hWnd, cPrompt, lEnable, n ), TabCtrlAdd( ::hWnd, cPrompt, lEnable, n ) )

   METHOD GetCurSel() INLINE If( ::lUnicode, TabCtrl_GetCurSelW( ::hWnd ), TabCtrl_GetCurSel( ::hWnd ) ) + 1

   METHOD SetCurSel( n ) INLINE If( ::lUnicode, TabCtrl_SetCurSelW( ::hWnd, n - 1 ), ;
                                                TabCtrl_SetCurSel ( ::hWnd, n - 1 ) )


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, aPrompts, aDialogs, oWnd, nOption, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, lAllWidth,;
            oFont, aHelps, cVarName ) CLASS TFolder

   local n, oDlg

   DEFAULT nTop := 0, nLeft := 0,;
           aDialogs  := {},;
           aPrompts  := { "&One", "&Two", "T&hree" },;
           aHelps := {},;
           oWnd      := GetWndDefault(),;
           nOption   := 1,;
           nClrFore  := oWnd:nClrText,;
           nClrBack  := GetSysColor( COLOR_BTNFACE ),;
           lPixel    := .f.,;
           lDesign   := .f.,;
           nWidth    := 100, nHeight := 100,;
           lAllWidth := .t.

   if ! Empty( aPrompts ) .and. ValType( aPrompts[ 1 ] ) == 'A'
      aPrompts    = aPrompts[ 1 ]
   endif

   if Len( aDialogs ) < Len( aPrompts )
      aDialogs = Array( Len( aPrompts ) )
   endif

   if Len( aHelps ) < Len( aPrompts )
      aHelps = Array( Len( aPrompts ) )
   endif

   if ::aEnable == nil
      ::aEnable = Array( Len( aPrompts ) )
      AFill( ::aEnable, .t. )
   endif

   ::lUnicode  = FW_SetUnicode()
   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      WS_TABSTOP /* , TCS_OWNERDRAWFIXED */ )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::aPrompts  = aPrompts
   ::aDialogs  = aDialogs
   ::aHelps    = aHelps
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
   ::lTransparent = .F.

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

   DEFAULT cVarName := "oFld" + ::GetCtrlIndex()

   ::cVarName = cVarName

   for n = 1 to Len( ::aDialogs )
      DEFINE DIALOG oDlg OF Self STYLE WS_CHILD  ;
         FROM 0, 0 TO ::nHeight() - ::nFdHeight - 5, ::nWidth() - 6 PIXEL ;
         FONT Self:oFont ;
         HELPID if(len(::aHelps) >= n , ::aHelps[n] , NIL)
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
                 nClrFore, nClrBack, bChange, lAllWidth, aHelps ) CLASS TFolder

   local n, oDlg

   DEFAULT nOption  := 1,;
           nClrFore := oWnd:nClrText,;
           nClrBack := oWnd:nClrPane,;
           aDialogs := Array( Len( aPrompts ) ),;
           aHelps   := Array( Len( aPrompts ) ),;
           lAllWidth := .f., oWnd := GetWndDefault()

   if ::aEnable == nil
      ::aEnable = Array( Len( aPrompts ) )
      AFill( ::aEnable, .t. )
   endif

   ::nId      = nId
   ::oWnd     = oWnd
   ::lUnicode  = FW_SetUnicode()
   ::aPrompts = aPrompts
   ::aDialogs = aDialogs
   ::aHelps   = aHelps
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
         COLOR nClrFore, nClrBack FONT Self:oFont ;
         HELPID if(len(::aHelps) >= n , ::aHelps[n] , NIL)
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

return ::Super:CtlColor( hWndChild, hDCChild )

#endif

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TFolder

   local n

   ::Super:Initiate( hDlg )

   for n = 1 to Len( ::aDialogs )
      if ::lTransparent
         ::aDialogs[ n ]:lTransparent = .t.
         if ::aDialogs[ n ]:oBrush:nRGBColor == RGB( 240, 240, 240 )
            ::aDialogs[ n ]:SetBrush( ::oBrush )
         endif
      endif
   next

   ::Default()

   for n = 1 to Len( ::aDialogs )
       ::aDialogs[ n ]:SetSize( ::nWidth() - 5,;
                                ::nHeight() - ::nFdHeight - 4 )
   next

   ::SetPrompts( ::aPrompts )
   ::AdjustRect()

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags, lTouch ) CLASS TFolder

   local n := 1

   if ::lDrag
      return ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
   else
      n = TabCtrl_HitTest( ::hWnd ) + 1
      if n != ::nOption
         ::SetOption( n )
      else
         return 0
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TFolder

   local nLen := Len( ::aPrompts ), n
   local oDlg
   local nHeight := ::nFdHeight

   nHeight *= If( ::lUnicode, TabGetRowCountW( ::hWnd ), TabGetRowCount( ::hWnd ) )

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
         if ::oWnd:IsKindOf( "TDIALOG" )
            if ! ::oWnd:lResize16
               ACTIVATE DIALOG oDlg NOWAIT ;
                  ON INIT oDlg:Move( nHeight - 1, 1 ) ;
                  VALID .f.                // to avoid exiting pressing Esc !!!
            else
               ACTIVATE DIALOG oDlg NOWAIT ;
                  ON INIT oDlg:Move( nHeight - 1, 1 ) ;
                  VALID .f. RESIZE16       // to avoid exiting pressing Esc !!!
            endif
         else
            ACTIVATE DIALOG oDlg NOWAIT ;
               ON INIT oDlg:Move( nHeight - 1, 1 ) ;
               VALID .f.                   // to avoid exiting pressing Esc !!!
         endif
      #endif

      #ifndef __CLIPPER__
         if IsAppThemed() .and. ! ::lTransparent
            if Empty( oDlg:oBrush:hBitmap )
               oDlg:bEraseBkGnd = { | hDC | DrawPBack( oDlg:hWnd, hDC ), 1 }
            endif
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

return ::Super:Resize( nType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD SetItemText( nItem, cText ) CLASS TFolder

   if ::lUnicode
      TabSetItemW( ::hWnd, nItem, cText )
   else
      TabSetItem ( ::hWnd, nItem, cText )
   endif
   ::aPrompts[ nItem ] = cText

return nil

//----------------------------------------------------------------------------//

METHOD SetPrompts( aPrompts, aHelps ) CLASS TFolder

   local n

   if ! Empty( aPrompts )
      ::aPrompts = aPrompts
   endif

   #ifndef __CLIPPER__
      if ::lUnicode
         TabDelAllItemsW( ::hWnd )
      else
         TabDelAllItems( ::hWnd )
      endif

      for n = Len( ::aPrompts ) to 1 step -1
         ::AddTab( ::aPrompts[ n ], ::aEnable[ n ], n )
         if n <= Len( ::aDialogs )
            if ::aDialogs[ n ] != nil
               ::aDialogs[ n ]:nHelpid = If( Len( ::aHelps ) >= n, ::aHelps[ n ], nil )
            endif
         endif
      next

      SendMessage( ::hWnd, TCM_SETCURSEL, ::nOption - 1 )
      ::Super:Refresh()
   #endif

return nil

//----------------------------------------------------------------------------//

METHOD AddItem( cItem, cResName, bRedefineControls, cnHelpId ) CLASS TFolder

   local oDlg, nLen, n
   local oThis := Self

   if Empty( cResName )
      DEFINE DIALOG oDlg OF Self STYLE WS_CHILD ;
         FROM 0, 0 TO oThis:nHeight - oThis:nFdHeight - 5, oThis:nWidth - 6 PIXEL
   else
      DEFINE DIALOG oDlg OF Self STYLE WS_CHILD ;
         FROM 0, 0 TO oThis:nHeight - oThis:nFdHeight - 5, oThis:nWidth - 6 PIXEL ;
         NAME cResName
   endif

   AAdd( ::aDialogs, oDlg )
   AAdd( ::aPrompts, cItem )
   AAdd( ::aHelps, cnHelpId )
   AAdd( ::aEnable, .t. )

   if ValType( bRedefineControls ) == "B"
      Eval( bRedefineControls, oDlg )
   endif

   ACTIVATE DIALOG oDlg NOWAIT ;
      ON INIT ( oDlg:Move( oThis:nFdHeight + 2, 3, oThis:nWidth - 6, oThis:nHeight - oThis:nFdHeight - 5 ) ) ;
      VALID .f.            // to avoid exiting pressing Esc !!!

   oDlg:Hide()

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
      ::SetPrompts( ::aPrompts, ::aHelps )
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

METHOD cGenPrg() CLASS TFolder

   local cPrg := ""
   local cPrompts := ArrayToText( ::aPrompts )

   cPrg += CRLF + "   @ " + AllTrim( Str( ::nTop ) ) + ", " + ;
           AllTrim( Str( ::nLeft ) ) + ;
           " FOLDER " + ::cVarName + " PROMPTS " + cPrompts + ;
           " ;" + CRLF + '      SIZE ' + AllTrim( Str( ::nWidth ) ) + ", " + ;
           AllTrim( Str( ::nHeight ) ) + ;
           " PIXEL OF " + ::oWnd:cVarName + CRLF

return cPrg

//----------------------------------------------------------------------------//

METHOD DelItem() CLASS TFolder

   local nLen, n

   if Len( ::aPrompts ) > 0
      ::aPrompts = ADel( ::aPrompts, ::nOption )
      ::aPrompts = ASize( ::aPrompts, Len( ::aPrompts ) - 1 )
      ::aDialogs[ ::nOption ]:bValid = { || .t. }
      ::aDialogs[ ::nOption ]:End()
      ::aDialogs = ADel( ::aDialogs, ::nOption )
      ::aDialogs = ASize( ::aDialogs, Len( ::aDialogs ) - 1 )
      ::aHelps = ADel( ::aHelps, ::nOption )
      ::aHelps = ASize( ::aHelps, Len( ::aHelps ) - 1 )
   endif
   ::nOption = Min( ::nOption, Len( ::aPrompts ) )

   if ( nLen := Len( ::aPrompts ) ) > 0
      if ::lAllWidth
         ::nTabSize = int( ::nWidth / nLen )
      else
         ::nTabSize := 0
         for n = 1 to nLen
            ::nTabSize = Max( ::nTabSize, ;
                              Int( GetTextWidth( 0, ::aPrompts[n], ;
                                   ::oFont:hFont ) + FD_TABMARGIN ) )
         next n
         ::nTabSize = Min( ::nTabSize, Int( ::nWidth / nLen ) )
      endif
   else
      ::nTabSize = ::nWidth + 1
   endif

   ::Refresh()
   ::SetPrompts( ::aPrompts, ::aHelps )

   if Len( ::aDialogs ) > 0
      ::aDialogs[ ::nOption ]:Show()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DelItemPos( nPos ) CLASS TFolder

   local nLen, n

   if Len( ::aPrompts ) > 0 .and. nPos > 0 .and. nPos <= Len( ::aPrompts )
      ::aPrompts = ADel( ::aPrompts, nPos )
      ::aPrompts = ASize( ::aPrompts, Len( ::aPrompts ) - 1 )
      ::aDialogs[ nPos ]:bValid = { || .t. }
      ::aDialogs[ nPos ]:End()
      ::aDialogs = ADel( ::aDialogs, nPos )
      ::aDialogs = ASize( ::aDialogs, Len( ::aDialogs ) - 1 )
      ::aHelps = ADel( ::aHelps, nPos )
      ::aHelps = ASize( ::aHelps, Len( ::aHelps ) - 1 )
   endif

   ::nOption = Min( ::nOption, Len( ::aPrompts ) )

   if ( nLen := Len( ::aPrompts ) ) > 0
      if ::lAllWidth
         ::nTabSize = int( ::nWidth / nLen )
      else
         ::nTabSize := 0
         for n = 1 to nLen
            ::nTabSize = Max( ::nTabSize, ;
                              Int( GetTextWidth( 0, ::aPrompts[n], ;
                                   ::oFont:hFont ) + FD_TABMARGIN ) )
         next n
         ::nTabSize = Min( ::nTabSize, int( ::nWidth / nLen ) )
      endif
   else
      ::nTabSize = ::nWidth + 1
   endif

   ::Refresh()
   ::SetPrompts( ::aPrompts, ::aHelps )

   if Len( ::aDialogs ) > 0
      ::aDialogs[ ::nOption ]:Show()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TFolder

   local n

   ::oFont2:End()

   if ::oFont != nil
      ::oFont:End()
      ::oFont  := nil   // Prevent Super:Destroy from End()ing again
   endif

   for n = 1 to Len( ::aDialogs )
      ::aDialogs[ n ]:bValid = { || .t. }
      ::aDialogs[ n ]:End()
   next

   if ::oImageList != nil
      ::oImageList:End()
   endif

return ::Super:Destroy()

//----------------------------------------------------------------------------//

METHOD GotFocus( hWndLoseFocus ) CLASS TFolder

   ::Super:GotFocus( hWndLoseFocus )

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
         ON INIT ( oDlg:Move( oThis:nFdHeight + 2, 3, oThis:nWidth - 6, oThis:nHeight - oThis:nFdHeight - 5 ) ) ;
         VALID .f.                // to avoid exiting pressing Esc !!!

      #ifndef __CLIPPER__
         if IsAppThemed()
            if Empty( oDlg:oBrush:hBitmap )
               oDlg:bEraseBkGnd = { | hDC | DrawPBack( oDlg:hWnd, hDC ), 1 }
            endif
         endif
      #endif

      oDlg:Hide()
   next

   ::nOption = 1
   ::aDialogs[ 1 ]:Show()

return nil

//----------------------------------------------------------------------------//

METHOD SetOption( nOption ) CLASS TFolder

   local nOldOption

   if nOption > 0 .and. nOption != ::nOption .and. ::aEnable[ nOption ]
      if ::nOption <= Len( ::aDialogs ) .and. ::nOption != 0 .and. ;
          ::aDialogs[ ::nOption ] != nil
         ::aDialogs[ ::nOption ]:Hide()
      endif
      nOldOption = ::nOption
      ::nOption  = nOption

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
      PostMessage( ::hWnd, TCM_SETCURSEL, ::nOption - 1 )
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
           nOldOption = ::GetCurSel()

      case nCode == TCN_SELCHANGE
           if ! ::aEnable[ ::GetCurSel() ]
              ::SetCurSel( nOldOption )
           endif
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD AdjustRect() CLASS TFolder

   local aRect:= If( ::lUnicode, TabCtrl_AdjustRectW( ::hWnd ), TabCtrl_AdjustRect( ::hWnd ) )

   if Len( ::aDialogs ) > 0 .and. ::aDialogs[ 1 ]:nTop <> aRect[ 1 ]
      AEval( ::aDialogs, { | oDlg | oDlg:Move( aRect[ 1 ], aRect[ 2 ] - 2 ) } )
   endif

return nil

//----------------------------------------------------------------------------//
