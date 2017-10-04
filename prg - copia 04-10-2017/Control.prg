#include "FiveWin.Ch"

#define LTGRAY_BRUSH       1
#define GRAY_BRUSH         2

#define WM_ERASEBKGND     20
#define WM_LBUTTONDBLCLK 515  // 0x203
#define WM_CTLCOLOR       25  // 0x19       // Don't remove Color Control
#define WM_MENUSELECT    287

#ifndef __CLIPPER__
   #ifndef __C3__
      #define WM_HELP 0x0053
   #else
      #define WM_HELP     83
   #endif
#else
   #define WM_HELP        83
#endif

#define GW_HWNDNEXT        2
#define GW_CHILD           5
#define GWW_INSTANCE      -6

#define SC_CLOSE       61536   // 0xF060
#define SC_NEXT        61504
#define SC_KEYMENU     61696   // 0xF100

#define WM_SYSCOMMAND    274   // 0x0112

#define DM_GETDEFID  WM_USER
#define DC_HASDEFID    21323   // 0x534B

// Controls mouse-resizing types in design mode
#define RES_NW             1
#define RES_N              2
#define RES_NE             3
#define RES_E              4
#define RES_SE             5
#define RES_S              6
#define RES_SW             7
#define RES_W              8

#define DLGC_DEFPUSHBUTTON    16     //0x0010
#define GWL_STYLE           (-16)

#define COLOR_WINDOW        5

#ifdef __XPP__
   #define Super ::TWindow
#endif

static nMRow, nMCol
static nXGrid := 8, nYGrid := 8
static lDragging := .f.

//----------------------------------------------------------------------------//

CLASS TControl FROM TWindow

   DATA   bSetGet, bChange, bDragBegin
   DATA   lCaptured, lDrag, lMouseDown, lUpdate AS LOGICAL
   DATA   l3DLook AS LOGICAL INIT .f. // HIDDEN
   DATA   nLastRow, nLastCol AS NUMERIC
   DATA   nMResize AS NUMERIC // Controls resize with mouse in design mode
                             // automatic initialized to zero

   DATA   nDlgCode           // Default GetDlgCode() returned value
                             // by default nil. (Default behavior).

   DATA   oJump              // After VALID set focus to this control
                             // if defined
   DATA   l97Look AS LOGICAL

   #ifdef __XPP__
      CLASS VAR nInitID SHARED
      CLASS VAR nPoint  SHARED
      CLASS VAR aDots   SHARED
   #else
      CLASSDATA nInitID INIT 100
      CLASSDATA nPoint
      CLASSDATA aDots
   #endif

   DATA nClientBevel AS NUMERIC

   CLASSDATA aProperties ;
      INIT { "cTitle", "cVarName", "l3D", "nClrText",;
             "nClrPane", "nAlign", "nTop", "nLeft",;
             "nWidth", "nHeight", "oFont", "Cargo" }

   #ifdef __XPP__
      DATA nTop, nLeft
   #endif

   METHOD nTop()  SETGET
   METHOD nLeft() SETGET

   /*
   METHOD _cVarName( cNewVarName ) INLINE If( ! ::lDrag .and. ! ::oWnd:lDesign,;
                                          OSend( ::oWnd, "_" + cNewVarName, Self ),),;
                                          Super:cVarName := cNewVarName */

   METHOD AdjBottom() INLINE WndAdjBottom( ::hWnd ),;
                      If( ::lDrag .and. GetFocus() == ::hWnd,;
                          ::ShowDots(),)

   METHOD AdjClient()

   METHOD AdjLeft()

   METHOD AdjRight()

   METHOD AdjTop() INLINE WndAdjTop( ::hWnd ),;
                      If( ::lDrag .and. GetFocus() == ::hWnd,;
                          ::ShowDots(),)

   METHOD Change() VIRTUAL

   METHOD ChangeFocus() INLINE PostMessage( ::hWnd, FM_CHANGEFOCUS )

   METHOD Click() INLINE  ::oWnd:AEvalWhen()

   METHOD CoorsUpdate() VIRTUAL

   METHOD cToChar( cCtrlClass )

   METHOD Init() VIRTUAL   // XBPP avoid calling TWindow New !!!

   METHOD Initiate( hDlg )

   METHOD Default()

   METHOD EraseBkGnd( hDC )

   METHOD FWLostFocus( hCtlFocus )

   #ifdef __CLIPPER__
      METHOD HideDots() INLINE ;
                If( ! Empty( ::aDots ),;
                    ( ASend( ::aDots, "Hide" ), SysRefresh() ),)
   #else
      #ifndef __C3__
         METHOD HideDots() INLINE ;
                   If( ! Empty( ::aDots ),;
                       ( ASend( ::aDots, "Hide()" ), SysRefresh() ),)
      #else
         METHOD HideDots() INLINE ;
                   If( ! Empty( ::aDots ),;
                       ( ASend( ::aDots, "Hide" ), SysRefresh() ),)
      #endif
   #endif

   METHOD GetDlgCode( nLastKey )

   METHOD GetNewId()

   METHOD GotFocus( hCtlLost )

   MESSAGE HelpTopic METHOD __HelpTopic()

   METHOD Inspect( cDataName )

   METHOD _l3D( lOnOff ) INLINE If( ::l3DLook := lOnOff, ::Set3DLook(),)

   METHOD l3D() INLINE ::l3DLook

   METHOD LostFocus( hWndGetFocus ) INLINE ::SetMsg(), Super:LostFocus( hWndGetFocus )

   METHOD Move( nTop, nLeft, nWidth, nHeight, lRepaint )

   METHOD MResize( nType, nRow, nCol )  // Controls resize in design mode

   METHOD End()

   METHOD nAlign() SETGET

   METHOD _nWidth( nNewWidth ) INLINE If( ! Empty( ::hWnd ), WndWidth( ::hWnd, nNewWidth ),),;
                               If( ::lDrag, ::ShowDots(),)

   METHOD _nHeight( nNewHeight ) INLINE If( ! Empty( ::hWnd ), WndHeight( ::hWnd, nNewHeight ),),;
                               If( ::lDrag, ::ShowDots(),)

   METHOD Notify( nIdCtrl, nPtrNMHDR ) VIRTUAL  // common controls notifications

   #ifdef __CLIPPER__
      METHOD HandleEvent( nMsg, nWParam, nLParam ) EXTERN ;
                          CtlHandleEvent( nMsg, nWParam, nLParam )
   #else
      METHOD HandleEvent( nMsg, nWParam, nLParam )
   #endif

   METHOD KeyChar( nKey, nFlags )
   METHOD KeyDown( nKey, nFlags )
   METHOD KeyUp( nKey, nFlags ) VIRTUAL

   MESSAGE SetFocus METHOD _SetFocus()

   METHOD CheckDots()

   METHOD Colors( hDC )

   METHOD DragBegin( nRow, nCol, nKeyFlags )

   // METHOD DrawItem( nPStruct ) VIRTUAL
   METHOD FillMeasure()        VIRTUAL

   METHOD KillFocus( hCtlFocus )

   METHOD Set3DLook() INLINE Ctl3DLook( ::hWnd )

   METHOD VarPut( uVal ) INLINE  If( ValType( ::bSetGet ) == "B",;
                                 Eval( ::bSetGet, uVal ),)

   METHOD VarGet() INLINE If( ValType( ::bSetGet ) == "B", Eval( ::bSetGet ),)

   METHOD LButtonDown( nRow, nCol, nKeyFlags )

   METHOD LButtonUp( nRow, nCol, nKeyFlags )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD ForWhen()

   METHOD Display() VIRTUAL

   METHOD Paint() VIRTUAL

   METHOD Redefine( nId, oWnd ) CONSTRUCTOR

   METHOD SysCommand( nType, nLoWord, nHiWord )

   METHOD ShowDots()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD AdjClient() CLASS TControl

   local hTop, hBottom, hLeft, hRight

   if ::oWnd:oTop != nil
      hTop = ::oWnd:oTop:hWnd
   endif

   if ::oWnd:oBar != nil
      hTop = ::oWnd:oBar:hWnd
   endif

   if ::oWnd:oBottom != nil
      hBottom = ::oWnd:oBottom:hWnd
   endif

   if ::oWnd:oMsgBar != nil
      hBottom = ::oWnd:oMsgBar:hWnd
   endif

   if ::oWnd:oLeft != nil
      hLeft = ::oWnd:oLeft:hWnd
   endif

   if ::oWnd:oRight != nil
      hRight = ::oWnd:oRight:hWnd
   endif

   WndAdjClient( ::hWnd, hTop, hBottom, hLeft, hRight,, ::nClientBevel )

   if ::lDrag .and. GetFocus() == ::hWnd
      ::ShowDots()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AdjLeft() CLASS TControl

   local hTop, hBottom

   if ::oWnd:oTop != nil
      hTop = ::oWnd:oTop:hWnd
   endif

   if ::oWnd:oBar != nil
      hTop = ::oWnd:oBar:hWnd
   endif

   if ::oWnd:oBottom != nil
      hBottom = ::oWnd:oBottom:hWnd
   endif

   if ::oWnd:oMsgBar != nil
      hBottom = ::oWnd:oMsgBar:hWnd
   endif

   WndAdjLeft( ::hWnd, hTop, hBottom )

   if ::lDrag .and. GetFocus() == ::hWnd
      ::ShowDots()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD AdjRight() CLASS TControl

   local hTop, hBottom

   if ::oWnd:oTop != nil
      hTop = ::oWnd:oTop:hWnd
   endif

   if ::oWnd:oBar != nil
      hTop = ::oWnd:oBar:hWnd
   endif

   if ::oWnd:oBottom != nil
      hBottom = ::oWnd:oBottom:hWnd
   endif

   if ::oWnd:oMsgBar != nil
      hBottom = ::oWnd:oMsgBar:hWnd
   endif

   WndAdjRight( ::hWnd, hTop, hBottom )

   if ::lDrag .and. GetFocus() == ::hWnd
      ::ShowDots()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cToChar( cCtrlClass ) CLASS TControl

   local n := GetDlgBaseUnits()

   DEFAULT cCtrlClass := ::ClassName(),;
           ::cCaption := "",;
           ::nId      := ::GetNewId(),;
           ::nStyle   := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

return cCtrl2Chr( Int( 2 * 8 * ::nTop    / nHiWord( n ) ),;
                  Int( 2 * 4 * ::nLeft   / nLoWord( n ) ),;
                  Int( 2 * 8 * ::nBottom / nHiWord( n ) ),;
                  Int( 2 * 4 * ::nRight  / nLoWord( n ) ),;
                  ::nId, ::nStyle, cCtrlClass, ::cCaption )

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TControl

   DEFAULT ::lActive := .t., ::lDrag := .f., ::lCaptured := .f.,;
           ::lFocused := .f., ::lCancel := .f.

   if( ( ::hWnd := GetDlgItem( hDlg, ::nId ) ) != 0 )

      If( ::lActive, ::Enable(), ::Disable() )
      ::Link()

      if ::oFont != nil
         ::SetFont( ::oFont )
      else
         ::GetFont()
      endif

   else
     #define NOVALID_CONTROLID   1
     Eval( ErrorBlock(), _FWGenError( NOVALID_CONTROLID, "No: " + ;
                                      Str( ::nId, 6 ) ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _SetFocus() CLASS TControl

   local hCtrlNext

   if ::lWhen()
      SetFocus( ::hWnd )
   else
      hCtrlNext = GetWindow( ::hWnd, GW_HWNDNEXT )
      if GetParent( hCtrlNext ) != ::oWnd:hWnd
         hCtrlNext = GetWindow( ::oWnd:hWnd, GW_CHILD )
      endif
      SetFocus( hCtrlNext )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Colors( hDC ) CLASS TControl

   DEFAULT ::nClrText := GetTextColor( hDC ),;
           ::nClrPane := GetBkColor( hDC ),;
           ::oBrush   := TBrush():New( , ::nClrPane )

   SetTextColor( hDC, ::nClrText )
   SetBkColor( hDC, ::nClrPane )

return ::oBrush:hBrush

//----------------------------------------------------------------------------//

METHOD Default() CLASS TControl

   ::lDrag     = .f.
   ::lCaptured = .f.

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TControl

   ::oWnd:nLastKey = 1002  // fixes CANCEL clause.

   ::lMouseDown = .t.
   ::nLastRow   = nRow
   ::nLastCol   = nCol

   if ::lDrag

      ::HideDots()
      CursorCatch()

      if ! ::lCaptured
         ::nPoint = nMakeLong( nRow -= ( nRow % nYGrid ), nCol -= ( nCol % nXGrid ) )
         nMRow  = nRow
         nMCol  = nCol

         CtrlDrawFocus( ::hWnd )
         ::Capture()
         ::lCaptured = .t.
      endif
      return 0
   else
      return Super:LButtonDown( nRow, nCol, nKeyFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nKeyFlags ) CLASS TControl

   local aPoint := { nRow, nCol }

   ::lMouseDown = .f.

   if lDragging
      lDragging = .f.
      ReleaseCapture()

      aPoint = ClientToScreen( ::hWnd, aPoint )
      if aPoint[ 1 ] > 32768
         aPoint[ 1 ] -= 65535
      endif
      if aPoint[ 2 ] > 32768
         aPoint[ 2 ] -= 65535
      endif
      SendMessage( WindowFromPoint( aPoint[ 2 ], aPoint[ 1 ] ),;
                   FM_DROPOVER, nKeyFlags, nMakeLong( nRow, nCol ) )

      return nil
   endif

   if ::lDrag
      if ::lCaptured
         ReleaseCapture()
         ::lCaptured = .f.
         CtrlDrawFocus( ::hWnd, ;
                        ( nRow := nLoWord( ::nPoint ) ) - nMRow,;
                        ( nCol := nHiWord( ::nPoint ) ) - nMCol, ;
                        nRow,;
                        nCol,;
                        ::nMResize )
         aPoint[ 1 ] = nRow
         aPoint[ 2 ] = nCol
         if Empty( ::nMResize )
            ::Move( ::nTop + nRow - nMRow, ::nLeft + nCol - nMCol,,, .t. )
         else
            // The click is relative to the control
            // and we need it relative to the control container
            aPoint = ClientToScreen( ::hWnd, aPoint )
            aPoint = ScreenToClient( ::oWnd:hWnd, aPoint )
            nRow := aPoint[ 1 ] - aPoint[ 1 ] % nYGrid
            nCol := aPoint[ 2 ] - aPoint[ 2 ] % nXGrid
            do case
                  case ::nMResize == RES_NW
                       ::Move( nRow, nCol,;
                               ::nWidth + ( ::nLeft - nCol ),;
                               ::nHeight + ( ::nTop - nRow ), .t. )

                  case ::nMResize == RES_N
                       ::Move( nRow, ::nLeft, ::nWidth, ::nHeight + ( ::nTop - nRow ), .t. )

                  case ::nMResize == RES_NE
                       ::Move( nRow, ::nLeft, nCol - ::nLeft,;
                               ::nHeight + ( ::nTop - nRow ), .t. )

                  case ::nMResize == RES_E
                       ::SetSize( nCol - ::nLeft, ::nHeight, .t. )

                  case ::nMResize == RES_W
                       ::Move( ::nTop, nCol,;
                               ::nWidth + ( ::nLeft - nCol ),;
                               ::nHeight, .t. )

                  case ::nMResize == RES_SE
                       ::SetSize( nCol - ::nLeft, nRow - ::nTop, .t. )

                  case ::nMResize == RES_S
                       ::SetSize( ::nWidth, nRow - ::nTop, .t. )

                  case ::nMResize == RES_SW
                       ::Move( ::nTop, nCol,;
                               ::nWidth + ( ::nLeft - nCol ), nRow - ::nTop, .t. )
            endcase
            ::nPoint = nil
         endif
         if ::nAlign() != 0
            ::oWnd:ReSize()
         endif
         if ::aDots != nil
            ::ShowDots()
         endif
         ::nMResize = 0
      endif
      if GetFocus() != ::hWnd
         SetFocus( ::hWnd )
      endif
      return 0
   endif

return Super:LButtonUp( nRow, nCol, nKeyFlags )

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TControl

   local nOldRow, nOldCol

   DEFAULT ::lMouseDown := .f.

   if nRow > 32768
      nRow -= 65535
   endif
   if nCol > 32768
      nCol -= 65535
   endif

   if ::lDrag
      if ::lCaptured

         if Empty( ::nMResize )
            CursorCatch()
         endif

         nOldRow := nLoWord( ::nPoint )
         nOldCol := nHiWord( ::nPoint )

         if Abs( nOldRow - nRow ) >= nXGrid .or. ;
            Abs( nOldCol - nCol ) >= nYGrid

            CtrlDrawFocus( ::hWnd, ;
                           nOldRow - nMRow,;
                           nOldCol - nMCol,;
                           nOldRow,;
                           nOldCol,;
                           ::nMResize )
            ::nPoint = nMakeLong(  nRow -= nRow % nYGrid,;
                                 nCol -= nCol % nXGrid )
            CtrlDrawFocus( ::hWnd, ;
                           nRow - nMRow,;
                           nCol - nMCol,;
                           nRow,;
                           nCol, ;
                           ::nMResize )
         endif

      else
         if ::oCursor != nil
            SetCursor( ::oCursor:hCursor )
         endif
      endif

      return 0
   else
      if ::lMouseDown .and. ;
         ( Abs( nRow - ::nLastRow ) > 5 .or. Abs( nCol - ::nLastCol ) > 5 ) ;
         .and. ! Empty( ::oDragCursor )
         SetCursor( ::oDragCursor:hCursor )
         if ! lDragging
            ::DragBegin( nRow, nCol, nKeyFlags )
         endif
      else
         return Super:MouseMove( nRow, nCol, nKeyFlags )
      endif
   endif

return 0

//----------------------------------------------------------------------------//

METHOD Move( nTop, nLeft, nWidth, nHeight, lRepaint ) CLASS TControl

   Super:Move( nTop, nLeft, nWidth, nHeight, lRepaint )

   DEFAULT ::lDrag := .f., ::lFocused := .f.

   if ::lDrag .and. ::aDots != nil .and. ::lFocused
      ::ShowDots()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TControl

   local nAt := If( ::oWnd != nil .and. ! Empty( ::oWnd:aControls ),;
                AScan( ::oWnd:aControls, { | oCtrl | oCtrl:hWnd == Self:hWnd } ),;
                0 )

   if nAt != 0
      ADel( ::oWnd:aControls, nAt )
      ASize( ::oWnd:aControls, Len( ::oWnd:aControls ) - 1 )
   endif

   if !Empty( ::oBrush )
      ::oBrush:End()
   end if 

   if ::oWnd != nil .and. ::oWnd:oCtlFocus == Self
      ::oWnd:oCtlFocus = nil
   endif

return Super:End()

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TControl

   local nDefValue, nDefButton, hDef, nAt

   do case
      case nKey == VK_TAB .and. GetKeyState( VK_SHIFT )
           ::oWnd:GoPrevCtrl( ::hWnd )
           return 0    // We don't want API default behavior

      case nKey == VK_TAB
           ::oWnd:GoNextCtrl( ::hWnd )
           return 0    // We don't want API default behavior

      case nKey == VK_ESCAPE
           ::oWnd:KeyChar( nKey, nFlags )
           return 0

      case nKey == VK_RETURN
           SysRefresh()  // A.L. 23/04/03 it valids the VALID of a control
                         // before firing the ACTION of a default pushbutton
           // if ::hWnd != GetFocus() // A.L. 23/04/03 The VALID was .t.
              if ( nDefButton := nLoWord( SendMessage( ::oWnd:hWnd,;
                  DM_GETDEFID ) ) ) != 0 .and. ;
                 ( hDef := GetDlgItem( ::oWnd:hWnd, nDefButton ) ) != 0 ;
                 .and. nDefButton != ::nId .and. ;
                 lAnd( GetWindowLong( hDef, GWL_STYLE ), BS_DEFPUSHBUTTON )
                 SendMessage( hDef, WM_KEYDOWN, VK_RETURN )
                 return 0
              else
                 // TBtnBmp control used as a default button (ID --> 1 IDOK)
                 if ( nAt := AScan( ::oWnd:aControls, { | o | o:nId == 1 } ) ) != 0
                    if Upper( ::oWnd:aControls[ nAt ]:ClassName() ) == "TBTNBMP"
                       Eval( ::oWnd:aControls[ nAt ]:bAction )
                    endif
                    return 0
                 endif
              endif
           // endif
   endcase

return Super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD nTop( nNewTop ) CLASS TControl

   if PCount() > 0
      if ! Empty( ::hWnd )
         WndTop( ::hWnd, nNewTop )
      endif
      Super:nTop = nNewTop
   else
      if ! Empty( ::hWnd )
         return WndTop( ::hWnd )
      else
         return Super:nTop
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD nLeft( nNewLeft ) CLASS TControl

   if PCount() > 0
      if ! Empty( ::hWnd )
         WndLeft( ::hWnd, nNewLeft )
      endif
      Super:nLeft = nNewLeft
   else
      if ! Empty( ::hWnd )
         return WndLeft( ::hWnd )
      else
         return Super:nLeft
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ForWhen() CLASS TControl

   ::oWnd:AEvalWhen()
   ::lCaptured = .f.

   // keyboard navigation
   if ::oJump != nil
      SetFocus( ::oJump:hWnd )
      ::oJump = nil
   elseif ::oWnd:nLastKey == VK_UP .or. ( ::oWnd:nLastKey == VK_TAB .and. ;
       GetKeyState( VK_SHIFT ) )
      ::oWnd:GoPrevCtrl( ::hWnd )
   elseif ::oWnd:nLastKey == VK_DOWN .or. ::oWnd:nLastKey == VK_RETURN .or. ;
      ::oWnd:nLastKey == VK_TAB
      ::oWnd:GoNextCtrl( ::hWnd )
   else
      if Empty( GetFocus() )
         SetFocus( ::hWnd )
      endif
   endif

   ::oWnd:nLastKey = 0

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TControl

   if ::lDrag
      do case
         case nKey == VK_DELETE
              if ApoloMsgNoYes( "Delete this control ?" )
                 ::End()
                 if Len( ::oWnd:aControls ) == 0
                    #ifdef __CLIPPER__
                       ASend( ::aDots, "Hide" )
                    #else
                       #ifndef __C3__
                          ASend( ::aDots, "Hide()" )
                       #else
                          ASend( ::aDots, "Hide" )
                       #endif
                    #endif
                 endif
              endif
      endcase
   else
      return Super:KeyDown( nKey, nFlags )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KillFocus( hCtlFocus ) CLASS TControl

   local oWnd

   if ! Empty( hCtlFocus ) .and. ::bValid != nil .and. WndParents( hCtlFocus, ::hWnd ) .and. ;
      ( oWnd := oWndFromhWnd( hCtlFocus ) ) != nil .and. ;
      Upper( oWnd:Classname() ) $ "TBUTTON;TBTNBMP" .and. ;
      ( oWnd:lCancel != nil .and. oWnd:lCancel .and. ;
        ( ::oWnd:nLastKey != VK_TAB .and. ::oWnd:nLastKey != VK_RETURN .and. ;
          ::oWnd:nLastKey != VK_DOWN .and. ::oWnd:nLastKey != VK_UP ) )
      ::oWnd:lValidating = .t.
      ::oWnd:nLastKey := 0
      ::ForWhen()
      ::oWnd:lValidating = .f.
      ::LostFocus( hCtlFocus )
      return nil
   else
      if Upper( GetClassName( hCtlFocus ) ) == "TBTNBMP"
         ::oWnd:nLastKey := 0  // it fixes TBtnBmp CANCEL clause
      endif
   endif

                                 // in FiveWin++ lValidating comes as nil sometimes
   if ! Empty( hCtlFocus ) .and. ( ::oWnd:lValidating == nil .or. ! ::oWnd:lValidating ) ;
      .and. IsWindowVisible( ::oWnd:hWnd ) .and. WndParents( hCtlFocus, ::hWnd )
      PostMessage( ::hWnd, FM_LOSTFOCUS, hCtlFocus )
   endif

return ::LostFocus( hCtlFocus )

//----------------------------------------------------------------------------//

METHOD EraseBkGnd( hDC ) CLASS TControl

   if ! Empty( ::bEraseBkGnd )
      return Eval( ::bEraseBkGnd, hDC )
   endif

  if ::oBrush != nil
     FillRect( hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
     return 1
  endif

return nil

//----------------------------------------------------------------------------//

METHOD FWLostFocus( hCtlFocus ) CLASS TControl

   local oWnd

   if ::oWnd:lValidating == nil .or. ! ::oWnd:lValidating // FW++ lValidating nil sometimes
      ::oWnd:lValidating = .t.

      if GetParent( hCtlFocus ) != ::oWnd:hWnd
         if ( oWnd := oWndFromHWnd( GetParent( hCtlFocus ) ) ) != nil
            if oWnd:lValidating == nil .or. ! oWnd:lValidating
               oWnd:lValidating = .t.
            else
               ::oWnd:lValidating = .f.
               return nil
            endif
         endif
      endif

      if ! ::lValid()
         SetFocus( ::hWnd )
      else
         if ! Upper( ::ClassName() ) $ "TFOLDER,TPAGES"
           ::ForWhen()
         endif
      endif
      ::oWnd:lValidating = .f.

      if oWnd != nil
         oWnd:lValidating = .f.
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TControl

   if .not. ::oWnd:lValidating
      if nLastKey == VK_RETURN .or. nLastKey == VK_TAB .or. ;
         nLastkey == VK_DOWN .or. nLastkey == VK_UP
         ::oWnd:nLastKey = nLastKey

      // don't do a else here with :nLastKey = 0
      // or WHEN does not work properly, as we pass here twice before
      // evaluating the WHEN
      endif
   endif

   if ::oWnd:oWnd == nil   // There is no folders !!!
      return ::nDlgCode    // standard GetDlgCode behavior (nil)
   else
      if ( Upper( ::oWnd:oWnd:ClassName() ) != "TFOLDER" .and. ;
           Upper( ::oWnd:oWnd:ClassName() ) != "TPAGES" )
         return ::nDlgCode // standard GetDlgCode behavior (nil)
      endif
   endif

return DLGC_WANTALLKEYS // It is the only way to have 100% control using Folders

//----------------------------------------------------------------------------//

METHOD GetNewId() CLASS TControl

   DEFAULT ::nInitId := 100

   if ::nInitId < 30000
      ::nInitId++
   else
      ::nInitId = 100
   endif

return ::nInitId

//----------------------------------------------------------------------------//

METHOD GotFocus( hCtlLost ) CLASS TControl

   ::lFocused       = .t.
   ::oWnd:nResult   = Self  // old code pending to be oCtlFocus
   ::oWnd:oCtlFocus = Self
   ::oWnd:hCtlFocus = ::hWnd
   ::SetMsg( ::cMsg )

   if ::lDrag
      ::ShowDots()
   endif

   if ::bGotFocus != nil
      return Eval( ::bGotFocus, Self, hCtlLost )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SysCommand( nType, nLoWord, nHiWord ) CLASS TControl

   local oFolder, nItem, nButton
   local hCtrl

   do case
      case nType == SC_KEYMENU      // Alt+... control accelerator pressed
           if ! Empty( oFolder := ::oWnd:oWnd ) .and. ;
              ( Upper( oFolder:ClassName() ) == "TFOLDER" )
              if ( nItem := oFolder:GetHotPos( nLoWord ) ) > 0
                 oFolder:SetOption( nItem )
                 return 0
              else
                 if ( hCtrl := ::oWnd:GetHotPos( nLoWord, ::hWnd ) ) != 0
                    nButton := AScan( ::oWnd:aControls, { | o | o:hWnd == hCtrl } )
                    if nButton != 0
                       SetFocus( hCtrl )
                       SysRefresh()            // process the VALID if defined
                       if GetFocus() != ::hWnd // the VALID returned .t. if defined
                          PostMessage( hCtrl, FM_CLICK )
                       endif
                       return 0
                    endif
                 elseif ( hCtrl := ::oWnd:oWnd:oWnd:GetHotPos( nLoWord, ::hWnd ) ) != 0
                    nButton := AScan( ::oWnd:oWnd:oWnd:aControls, { | o | o:hWnd == hCtrl } )
                    if nButton != 0
                       SetFocus( hCtrl )
                       SysRefresh()            // process the VALID if defined
                       if GetFocus() != ::hWnd // the VALID returned .t. if defined
                          PostMessage( hCtrl, FM_CLICK )
                       endif
                       return 0
                    endif
					  else
                    return nil
                 endif
              endif
           endif
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD __HelpTopic() CLASS TControl

   if Empty( ::nHelpId )
      if ::oWnd != nil
         ::oWnd:HelpTopic()
      else
         HelpIndex()
      endif
   else
      HelpPopup( ::nHelpId )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Inspect( cDataName ) CLASS TControl

   do case
      case cDataName == "nAlign"
           return { "None", "Top", "Left", "Bottom", "Right", "Client" }

      otherwise
           return Super:Inspect( cDataName )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD DragBegin( nRow, nCol, nKeyFlags ) CLASS TControl

   if ! lDragging
      lDragging = .t.
      SetCapture( ::hWnd )
   endif

   if ::bDragBegin != nil
      Eval( ::bDragBegin, nRow, nCol, nKeyFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CheckDots() CLASS TControl

   local oDot1, oDot2, oDot3, oDot4, oDot5, oDot6, oDot7, oDot8
   local oSizeNWSE, oSizeNESW, oSizeNS, oSizeWE
   local oWndParent := ::oWnd

   if ::lDrag
      // Ajustamos el control al grid
      ::Move( int( ::nTop  / nYGrid ) * nYGrid,;
              int( ::nLeft / nXGrid ) * nXGrid,;
              int( ( ::nRight - ::nLeft + 1 ) / nXGrid ) * nXGrid,;
              int( ( ::nBottom - ::nTop + 1 ) / nYGrid ) * nYGrid, .t. )
   endif


   if ::aDots != nil .and. ::aDots[ 1 ]:hWnd != 0
      return nil
   endif

   DEFINE CURSOR oSizeNWSE SIZENWSE
   DEFINE CURSOR oSizeNESW SIZENESW
   DEFINE CURSOR oSizeNS   SIZENS
   DEFINE CURSOR oSizeWE   SIZEWE

   DEFINE WINDOW oDot1 OF oWndParent;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS );
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNWSE

   DEFINE WINDOW oDot2 OF oWndParent;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNS

   DEFINE WINDOW oDot3 OF oWndParent;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNESW

   DEFINE WINDOW oDot4 OF oWndParent;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeWE

   DEFINE WINDOW oDot5 OF oWndParent ;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNWSE

   DEFINE WINDOW oDot6 OF oWndParent ;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNS

   DEFINE WINDOW oDot7 OF oWndParent ;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeNESW

   DEFINE WINDOW oDot8 OF oWndParent ;
      STYLE nOr( WS_CHILD, WS_CLIPSIBLINGS ) ;
      FROM 0, 0 TO 2, 2 PIXEL ;
      COLOR "N/N" ;
      CURSOR oSizeWE

   ::aDots = { oDot1, oDot2, oDot3, oDot4, oDot5, oDot6, oDot7, oDot8 }

   #ifdef __CLIPPER__
      ASend( ::aDots, "Hide" )
   #else
      #ifndef __C3__
         ASend( ::aDots, "Hide()" )
      #else
         ASend( ::aDots, "Hide" )
      #endif
   #endif

   oDot1:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_NW, nRow, nCol, oDot1 ) }
   oDot2:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_N, nRow, nCol, oDot2 )  }
   oDot3:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_NE, nRow, nCol, oDot3 ) }
   oDot4:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_E, nRow, nCol, oDot4 )  }
   oDot5:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_SE, nRow, nCol, oDot5 ) }
   oDot6:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_S, nRow, nCol, oDot6 )  }
   oDot7:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_SW, nRow, nCol, oDot7 ) }
   oDot8:bLClicked = { | nRow, nCol | ::HideDots(), oWndParent:oCtlFocus:MResize( RES_W, nRow, nCol, oDot8 )  }

return nil

//----------------------------------------------------------------------------//

METHOD ShowDots() CLASS TControl

   local n

   if ::aDots != nil
      if GetParent( ::aDots[ 1 ]:hWnd  ) != ::oWnd:hWnd
         #ifdef __CLIPPER__
            ASend( ::aDots, "Hide" )
         #else
            #ifndef __C3__
               ASend( ::aDots, "Hide()" )
            #else
               ASend( ::aDots, "Hide" )
            #endif
         #endif
         ::aDots[ 1 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_NW, nRow, nCol, ::aDots[ 1 ] ) }
         ::aDots[ 2 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_N, nRow, nCol, ::aDots[ 2 ] )  }
         ::aDots[ 3 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_NE, nRow, nCol, ::aDots[ 3 ] ) }
         ::aDots[ 4 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_E, nRow, nCol, ::aDots[ 4 ] )  }
         ::aDots[ 5 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_SE, nRow, nCol, ::aDots[ 5 ] ) }
         ::aDots[ 6 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_S, nRow, nCol, ::aDots[ 6 ] )  }
         ::aDots[ 7 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_SW, nRow, nCol, ::aDots[ 7 ] ) }
         ::aDots[ 8 ]:bLClicked = { | nRow, nCol | ::oWnd:oCtlFocus:MResize( RES_W, nRow, nCol, ::aDots[ 8 ] )  }
         AEval( ::aDots, { | o | o:oWnd := ::oWnd,;
                         SetParent( o:hWnd, ::oWnd:hWnd ) } )
      endif
      DotsAdjust( ::hWnd, ::aDots[ 1 ]:hWnd, ::aDots[ 2 ]:hWnd,;
                          ::aDots[ 3 ]:hWnd, ::aDots[ 4 ]:hWnd,;
                          ::aDots[ 5 ]:hWnd, ::aDots[ 6 ]:hWnd,;
                          ::aDots[ 7 ]:hWnd, ::aDots[ 8 ]:hWnd )
      #ifdef __CLIPPER__
         ASend( ::aDots, "Show" )
      #else
         #ifndef __C3__
            ASend( ::aDots, "Show()" )
         #else
            ASend( ::aDots, "Show" )
         #endif
      #endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MResize( nType, nRow, nCol, oDot ) CLASS TControl

   local aPoint := { nRow + oDot:nHeight(), nCol + oDot:nWidth() }

   if oDot:oCursor != nil
      SetCursor( oDot:oCursor:hCursor )
   endif

   // The click is relative to the Dot Client
   // and we need it relative to the Control Client

   aPoint = ClientToScreen( oDot:hWnd, aPoint )
   aPoint = ScreenToClient( ::hWnd, aPoint )
   nRow = aPoint[ 1 ]
   nCol = aPoint[ 2 ]

   ::nPoint = nMakeLong( nRow -= nRow % nYGrid,;
                       nCol -= nCol % nXGrid )

   ::nLastRow := nMRow := nRow
   ::nLastCol := nMCol := nCol
   ::nMResize = nType

   CtrlDrawFocus( ::hWnd )
   ::lCaptured = .t.
   ::Capture()

return nil

//----------------------------------------------------------------------------//

METHOD nAlign( nNewAlign ) CLASS TControl

   if ::oWnd == nil
      return 0
   endif

   if PCount() > 0  // SET action
      do case
         case ::oWnd:oTop == Self .and. nNewAlign != 2
              ::oWnd:oTop = nil

         case ::oWnd:oLeft == Self .and. nNewAlign != 3
              ::oWnd:oLeft = nil

         case ::oWnd:oBottom == Self .and. nNewAlign != 4
              ::oWnd:oBottom = nil

         case ::oWnd:oRight == Self .and. nNewAlign != 5
              ::oWnd:oRight = nil

         case ::oWnd:oClient == Self .and. nNewAlign != 6
              ::oWnd:oClient = nil
      endcase

      do case
         case nNewAlign == 2
              ::oWnd:oTop = Self

         case nNewAlign == 3
              ::oWnd:oLeft = Self

         case nNewAlign == 4
              ::oWnd:oBottom = Self

         case nNewAlign == 5
              ::oWnd:oRight = Self

         case nNewAlign == 6
              ::oWnd:oClient = Self
      endcase
      ::oWnd:ReSize()
   else       // GET action
      do case
         case ::oWnd:oTop == Self
              return 2

         case ::oWnd:oLeft == Self
              return 3

         case ::oWnd:oBottom == Self
              return 4

         case ::oWnd:oRight == Self
              return 5

         case ::oWnd:oClient == Self
              return 6

         otherwise
              return 1
      endcase
   endif

return nil

//----------------------------------------------------------------------------//

function SetGridSize( nWidth, nHeight )

   nXGrid = nWidth
   nYGrid = nHeight

return nil

//----------------------------------------------------------------------------//

function GetGridSize()

return { nXGrid, nYGrid }

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd ) CLASS TControl

   ::nId  = nId
   ::oWnd = oWnd
   ::lValidating = .f.

   ::Register()

   if oWnd != nil
      oWnd:DefControl( Self )
   endif

return nil

//----------------------------------------------------------------------------//

#ifndef __CLIPPER__

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TControl

   do case
      case nMsg == FM_CLICK
           return ::Click()

      case nMsg == WM_CTLCOLOR
           return ::CtlColor( nLParam, nWParam )

      case nMsg == WM_HELP
           return ::HelpTopic()

      case nMsg == WM_KILLFOCUS
           return ::KillFocus( nWParam )

      case nMsg == WM_PAINT
           return ::Display()

      case nMsg == FM_CHANGE
           return ::Change()

      case nMsg == FM_COLOR
           return ::Colors( nWParam )

      case nMsg == FM_LOSTFOCUS
           return ::FWLostFocus( nWParam )

      case nMsg == WM_SYSCOMMAND
           return ::SysCommand( nWParam, nLoWord( nLParam ), nHiWord( nLParam ) )

   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

#endif

//----------------------------------------------------------------------------//