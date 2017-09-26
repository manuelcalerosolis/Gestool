#include "FiveWin.ch"
#include "Constant.ch"

#define GWL_STYLE          -16

#ifndef __CLIPPER__
   #define COMBO_BASE      320
#else
   #define COMBO_BASE  WM_USER
#endif

#define CB_ADDSTRING     ( COMBO_BASE + 3 )
#define CB_DELETESTRING  ( COMBO_BASE +  4 )
#define CB_GETCURSEL     ( COMBO_BASE +  7 )
#define CB_INSERTSTRING  ( COMBO_BASE + 10 )
#define CB_RESETCONTENT  ( COMBO_BASE + 11 )
#define CB_FINDSTRING    ( COMBO_BASE + 12 )
#define CB_SETCURSEL     ( COMBO_BASE + 14 )
#define CB_SHOWDROPDOWN  ( COMBO_BASE + 15 )
#define CB_GETDROPPEDSTATE  ( COMBO_BASE + 23 )
#define CB_ERR              -1

#define CB_SETMINVISIBLE     5889 // 0x1701
#define CB_GETMINVISIBLE     5890 // 0x1702

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8

#define MB_ICONEXCLAMATION  48   // 0x0030

#define GW_CHILD             5
#define GW_HWNDNEXT          2

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

//----------------------------------------------------------------------------//

CLASS TComboBox FROM TControl

   DATA   aItems, aBitmaps
   DATA   lOwnerDraw, nBmpHeight, nBmpWidth
   DATA   nAt
   DATA   bDrawItem, bCloseUp
   DATA   cError AS String
   DATA   oGet

   METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId,;
               bChange, bValid, nClrText, nClrBack, lPixel, oFont,;
               cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, nStyle,;
               cPict, bEChange ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, aItems, oWnd, nHelpId, bValid, ;
               bChange, nClrText, nClrBack, cMsg, lUpdate,;
               bWhen, acBitmaps, bDrawItem, nStyle, cPict, bEChange ) CONSTRUCTOR

   METHOD Add( cItem, nAt )

   METHOD cToChar() INLINE  Super:cToChar( "COMBOBOX" )

   METHOD Change()

   METHOD Close() INLINE ::SendMsg( CB_SHOWDROPDOWN, 0 )

   METHOD CloseUp() INLINE If( ::bCloseUp != nil, Eval( ::bCloseUp, Self ),)

   METHOD CtlColor( hWndChild, hDCChild )

   METHOD Default()

   METHOD DefControl( oControl )

   METHOD Del( nAt )

   METHOD Destroy()

   METHOD DrawItem( nIdCtl, nPStruct )

   METHOD FillMeasure( nPInfo ) INLINE  LbxMeasure( nPInfo, ::nBmpHeight )

   METHOD FindString( cItem, nFrom ) INLINE ;
                              nFrom := If( nFrom == nil, 0, nFrom ),;
                              ::SendMsg( CB_FINDSTRING, nFrom, cItem ) + 1

   METHOD Find( cItem, nFrom ) INLINE ::FindString( cItem, nFrom ) != 0

   #ifndef __CLIPPER__
      METHOD GetMinVisible() INLINE If( IsAppThemed(), ;
                                    ::SendMsg( CB_GETMINVISIBLE, 0, 0 ), 0 )
   #endif

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD Initiate( hDlg )

   METHOD Insert( cItem, nAt )

   METHOD KeyChar( nKey, nFlags )

   METHOD LostFocus( hWndGetFocus )

   METHOD lValid()

   METHOD Modify( cItem, nAt )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Open() INLINE ::SendMsg( CB_SHOWDROPDOWN, 1 )

   METHOD Refresh() INLINE  ::Set( Eval( ::bSetGet ) ), Super:Refresh()

   METHOD Reset() INLINE Eval( ::bSetGet,;
                         If( ValType( Eval( ::bSetGet ) ) == "N", 0, "" ) ),;
                         ::nAt := 0, ::SendMsg( CB_RESETCONTENT ),;
                         ::Change()

   METHOD Select( nItem ) INLINE ::nAt := nItem,;
                                 ::SendMsg( CB_SETCURSEL, nItem - 1, 0 )

   METHOD Set( cNewItem )

   METHOD SetBitmaps( acBitmaps )

   METHOD SetItems( aItems ) INLINE ::Reset(), ::aItems := aItems,;
                                    ::Default(), ::Change()

   // By default, 30 is the minimum number of visible items in XP Visual Themes
   #ifndef __CLIPPER__
      METHOD SetMinVisible( nItems ) INLINE ;
         If( IsAppThemed(), ( ::SendMsg( CB_SETMINVISIBLE, nItems, 0 ) == 1 ), .f. )
   #endif

   METHOD ShowToolTip()

   METHOD VarGet()
   METHOD State() INLINE ::SendMsg( CB_GETDROPPEDSTATE, 0 )
   METHOD IsClosed() INLINE ::State() == 0
   METHOD IsOpen() INLINE ::State() == 1

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId,;
            bChange, bValid, nClrFore, nClrBack, lPixel, oFont,;
            cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, nStyle,;
            cPict, bEChange ) CLASS TComboBox

   if nClrFore == nil
      nClrBack := GetSysColor( COLOR_WINDOW )
   endif

   DEFAULT nRow     := 0, nCol := 0, bSetGet := { || nil },;
           oWnd     := GetWndDefault(),;
           oFont    := oWnd:oFont,;
           aItems   := {}, nWidth := 40, nHeight := 60,;
           nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
           lPixel   := .f., lUpdate := .f., lDesign := .f.,;
           nStyle   := CBS_DROPDOWNLIST

   ::cCaption  = ""
   ::nTop      = nRow * If( lPixel, 1, CMB_CHARPIX_H )
   ::nLeft     = nCol * If( lPixel, 1, CMB_CHARPIX_W )
   ::nBottom   = ::nTop  + nHeight - 1
   ::nRight    = ::nLeft + nWidth  - 1
   ::nAt       = 0
   ::aItems    = aItems
   ::bChange   = bChange
   ::bSetGet   = bSetGet
   ::oWnd      = oWnd
   ::oFont     = oFont

   if acBitmaps != nil
      ::SetBitmaps( acBitmaps )
   else
      ::lOwnerDraw = .f.
   endif

   ::nStyle    = nOR( If( nStyle == CBS_DROPDOWN, 0, LBS_NOTIFY ), WS_TABSTOP,;
                      nStyle,;
                      LBS_DISABLENOSCROLL, WS_CHILD, WS_VISIBLE, WS_BORDER,;
                      WS_VSCROLL, If( lDesign, WS_CLIPSIBLINGS, 0 ),;
                      If( ::lOwnerDraw, CBS_OWNERDRAWFIXED, 0 ) )

   ::nId       = ::GetNewId()
   ::nHelpId   = nHelpId
   ::bValid    = bValid
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bDrawItem = bDrawItem

   ::SetColor( nClrFore, nClrBack )

   if nStyle == CBS_DROPDOWN
      #ifdef __XPP__
         #undef New
      #endif
      ::oGet := TGet():ReDefine( nil,    ;  // ID not used
                              ::bSetGet, ;  // bSETGET(uVar)
                              Self,      ;  // oDlg
                              ::nHelpID, ;  // Help Context ID
                              cPict,     ;  // Picture
                              nil,       ;  // Valid is handled by the CBx
                              ::nClrText,;
                              ::nClrPane,;
                              ::oFont,   ;  // <oFont>
                              nil,       ;  // <oCursor>
                              cMsg,      ;  // cMsg
                              nil,       ;  // <.update.>
                              nil,       ;  // <{uWhen}>
                              bEChange,  ;  // {|nKey,nFlags,Self| <uEChange>}
                              .F.        )  // <.readonly.> )
   endif

   if ! Empty( oWnd:hWnd )
      ::Create( "COMBOBOX" )
      ::Default()
      if oFont != nil
         ::SetFont( oFont )
      endif
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if ::oGet != nil
      ::oGet:hWnd = GetWindow( ::hWnd, GW_CHILD )
      ::oGet:Link()
      ::oGet:bLostFocus = ;
      {| hCtlFocus, nAt, cItem| cItem := GetWindowText( ::hWnd ), ;
      nAt := ::SendMsg( CB_FINDSTRING, 0, Trim( cItem )) + 1,;
      Eval( ::bSetGet, cItem ),;
      ::Select( nAt ),;
      SetWindowText( ::hWnd, cItem ),;
      If( ::bValid != nil .and. ;
      GetParent( hCtlFocus ) == GetParent( ::hWnd ),;
      If( ! Eval( ::bValid ),;
      PostMessage( ::hWnd, WM_SETFOCUS ),),) }
  endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, aItems, oWnd, nHelpId, bValid, ;
                 bChange, nClrFore, nClrBack, cMsg, lUpdate, ;
                 bWhen, acBitmaps, bDrawItem, nStyle, cPict, ;
                 bEChange ) CLASS TComboBox

   if nClrFore == nil
      nClrBack := GetSysColor( COLOR_WINDOW )
   endif

   DEFAULT aItems   := {},;
           nClrFore := GetSysColor( COLOR_WINDOWTEXT ),;
           lUpdate  := .f., ;
           nStyle   := CBS_DROPDOWNLIST

   ::nId       = nId
   ::hWnd      = 0
   ::aItems    = aItems
   ::bChange   = bChange
   ::bSetGet   = bSetGet
   ::oWnd      = oWnd
   ::nHelpId   = nHelpId
   ::bValid    = bValid
   ::nAt       = 0
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen
   ::bDrawItem = bDrawItem
   ::nStyle    = nStyle

   if acBitmaps != nil
      ::SetBitmaps( acBitmaps )
   else
      ::lOwnerDraw = .f.
   endif

   ::SetColor( nClrFore, nClrBack )

   if lAnd( ::nStyle, CBS_DROPDOWN )
      #ifdef __XPP__
         #undef New
      #endif
      ::oGet := TGet():ReDefine( nil,    ;  // ID not used
                              ::bSetGet, ;  // bSETGET(uVar)
                              Self,      ;  // oDlg
                              ::nHelpID, ;  // Help Context ID
                              cPict,     ;  // Picture
                              nil,       ;  // Valid is handled by the CBx
                              ::nClrText,;
                              ::nClrPane,;
                              ::oFont,   ;  // <oFont>
                              nil,       ;  // <oCursor>
                              cMsg,      ;  // cMsg
                              nil,       ;  // <.update.>
                              nil,       ;  // <{uWhen}>
                              bEChange,  ;  // {|nKey,nFlags,Self| <uEChange>}
                              .F.        )  // <.readonly.> )
     endif

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Add( cItem, nAt ) CLASS TComboBox

   DEFAULT nAt := 0

   if nAt == 0
      AAdd( ::aItems, cItem )
   else
      ASize( ::aItems, Len( ::aItems ) + 1 )
      AIns( ::aItems, nAt )
      ::aItems[ nAt ] = cItem
   endif

   ::SendMsg( CB_ADDSTRING, nAt, cItem )

return nil

//----------------------------------------------------------------------------//

METHOD Change() CLASS TComboBox

   local cItem := GetWindowText( ::hWnd ) // Current Value
   local nAt

   nAt = ::SendMsg( CB_GETCURSEL ) + 1

   if nAt == ::nAt .and. ! Empty( Eval( ::bSetGet ) )
      return nil
   endif

   ::nAt := nAt

   if ::nAt != 0 .and. ::nAt <= Len( ::aItems )
      if ValType( Eval( ::bSetGet ) ) == "N"
         Eval( ::bSetGet, ::nAt )
      else
         Eval( ::bSetGet, ::aItems[ ::nAt ] )
      endif
   endif

   if ::oGet != nil                        // Always not nil for dropdown
      ::oGet:VarPut( Eval( ::bSetGet ) )   // udate variable before calling bChange
      ::oGet:Refresh()
   endif

   if ::bChange != nil
      Eval( ::bChange, Self, cItem )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DefControl( oControl ) CLASS TComboBox

   if ::aControls == nil
      ::aControls = {}
   endif

   AAdd( ::AControls, oControl )

return nil

//----------------------------------------------------------------------------//

METHOD Set( cNewItem ) CLASS TComboBox

   local nAt

   if ValType( cNewItem ) == "N"
      nAt = cNewItem
      if nAt == 0
         nAt = 1
      endif
   else
      nAt = AScan( ::aItems, { | cItem | Upper( AllTrim( cItem ) ) == Upper( AllTrim( cNewItem ) ) } )
   endif

   if ValType( cNewItem ) == "N" .or. nAt != 0
      ::Select( nAt )
      Eval( ::bSetGet, cNewItem )
   else
      cNewItem := cValToChar( cNewItem )
      Eval( ::bSetGet, cNewItem )
      SetWindowText( ::hWnd , cNewItem )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LostFocus( hWndGetFocus ) CLASS TComboBox

   local nAt := ::SendMsg( CB_GETCURSEL )

   Super:LostFocus( hWndGetFocus )

   if nAt != CB_ERR
      ::nAt = nAt + 1
      if ValType( Eval( ::bSetGet ) ) == "N"
         Eval( ::bSetGet, nAt + 1 )
      else
         Eval( ::bSetGet, ::aItems[ nAt + 1 ] )
      endif
   else
      Eval( ::bSetGet, GetWindowText( ::hWnd ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Modify( cItem, nAt ) CLASS TComboBox

   DEFAULT nAt := 0

   if nAt != 0
      ::aItems[ nAt ] = cItem
      ::SendMsg( CB_DELETESTRING, nAt - 1 )
      ::SendMsg( CB_INSERTSTRING, nAt - 1, cItem )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Insert( cItem, nAt ) CLASS TComboBox

   DEFAULT nAt := 0

   if nAt != 0
      ASize( ::aItems, Len( ::aItems ) + 1 )
      AIns( ::aItems, nAt )
      ::aItems[ nAt ] = cItem
      ::SendMsg( CB_INSERTSTRING, nAt - 1, cItem )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TComboBox

   if nKey == VK_RETURN
      return ::oWnd:GoNextCtrl( ::hWnd )
   endif

return Super:KeyChar( nKey, nFlags )

//----------------------------------------------------------------------------//

METHOD Del( nAt ) CLASS TComboBox

   DEFAULT nAt := 0

   if nAt != 0
      ADel( ::aItems, nAt )
      ASize( ::aItems, Len( ::aItems ) - 1 )
      ::SendMsg( CB_DELETESTRING, nAt - 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TComboBox

   if nMsg == FM_CLOSEUP
      return ::CloseUp()
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TComboBox

   Super:Initiate( hDlg )

   ::Default()

   if ::oGet != nil
      ::oGet:hWnd = GetWindow( ::hWnd, GW_CHILD )
      ::oGet:Link()

      ::oGet:bLostFocus = ;
      {| hCtlFocus, nAt, cItem| cItem := GetWindowText( ::hWnd ), ;
      nAt := ::SendMsg( CB_FINDSTRING, 0, Trim( cItem )) + 1,;
      Eval( ::bSetGet, cItem ),;
      ::Select( nAt ),;
      SetWindowText( ::hWnd, cItem ),;
      If( ::bValid != nil .and. ;
      GetParent( hCtlFocus ) == GetParent( ::hWnd ),;
      If( ! Eval( ::bValid ),;
      PostMessage( ::hWnd, WM_SETFOCUS ),),) }
   endif

   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD CtlColor( hWndChild, hDCChild ) CLASS TComboBox

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), CBS_DROPDOWN )
      SetTextColor( hDCChild, ::nClrText )
      SetBkColor( hDCChild, ::nClrPane )

      DEFAULT ::oBrush := TBrush():New( , ::nClrPane )

      return ::oBrush:hBrush
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TComboBox

   local cStart := Eval( ::bSetGet )
   if ! Empty( ::hWnd ) .and. ::nStyle == CBS_DROPDOWNLIST
      ::nStyle := GetWindowLong( ::hWnd, GWL_STYLE )
   endif

   if cStart == nil
      Eval( ::bSetGet, If( Len( ::aItems ) > 0, ::aItems[ 1 ], "" ) )
      cStart = If( Len( ::aItems ) > 0, ::aItems[ 1 ], "" )
   endif

   AEval( ::aItems, { | cItem, nAt | ::SendMsg( CB_ADDSTRING, nAt, cItem ) } )

   if ValType( cStart ) != "N"
      ::nAt = AScan( ::aItems, { | cItem | Upper( AllTrim( cItem ) ) == ;
                                           Upper( AllTrim( cStart ) ) } )
   else
      ::nAt = cStart
   endif

   ::nAt = If( ::nAt > 0, ::nAt, 1 )

   if cStart == nil
      ::Select( ::nAt )
   else
      ::Set( cStart )
   endif

/*
   if ::oGet != nil
      ::oGet:hWnd = GetWindow( ::hWnd, GW_CHILD )
      ::oGet:Link( .t. )

      ::oGet:bLostFocus = ;
      {| hCtlFocus, nAt, cItem| cItem := GetWindowText( ::hWnd ), ;
      nAt := ::SendMsg( CB_FINDSTRING, 0, Trim( cItem )) + 1,;
      Eval( ::bSetGet, cItem ),;
      ::Select( nAt ),;
      SetWindowText( ::hWnd, cItem ),;
      If( ::bValid != nil .and. ;
      GetParent( hCtlFocus ) == GetParent( ::hWnd ),;
      If( ! Eval( ::bValid ),;
      PostMessage( ::hWnd, WM_SETFOCUS ),),) }
   endif
*/

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TComboBox

   local nResult := Super:MouseMove( nRow, nCol, nKeyFlags )

return If( ::lDrag, nResult, nil )    // We want standard behavior !!!

//----------------------------------------------------------------------------//

METHOD SetBitmaps( acBitmaps ) CLASS TComboBox

   local n

   ::lOwnerDraw = .t.

   if acBitmaps != nil
      ::aBitmaps = Array( Len( acBitmaps ) )
      for n = 1 to Len( acBitmaps )
         if File( acBitmaps[ n ] )
            ::aBitmaps[ n ] = ReadBitmap( 0, acBitmaps[ n ] )
         else
            ::aBitmaps[ n ] = LoadBitmap( GetResources(), acBitmaps[ n ] )
         endif
      next
      ::nBmpHeight = nBmpHeight( ::aBitmaps[ 1 ] )
      ::nBmpWidth  = nBmpWidth( ::aBitmaps[ 1 ] )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TComboBox

   local n

   if ::aBitmaps != nil
      for n = 1 to Len( ::aBitmaps )
         DeleteObject( ::aBitmaps[ n ] )
      next
   endif

   if ::oGet != nil
      ::oGet:Destroy()
   endif

return Super:Destroy()

//----------------------------------------------------------------------------//

METHOD DrawItem( nIdCtl, nPStruct ) CLASS TComboBox

return LbxDrawItem( nPStruct, ::aBitmaps, ::aItems, ::nBmpWidth, ::bDrawItem )

//----------------------------------------------------------------------------//

METHOD VarGet() CLASS TComboBox

   local cRet, nAt := ::SendMsg( CB_GETCURSEL )

   if nAt != CB_ERR
      ::nAt = nAt + 1
      cRet :=  ::aItems[ nAt + 1 ]
   else
      cRet := GetWindowText( ::hWnd )
   endif

return cRet

//----------------------------------------------------------------------------//

METHOD lValid() CLASS TComboBox

   local lRet := .t.

   if ValType( ::bValid ) == "B"
      lRet = Eval( ::bValid, ::oGet  )
   endif

return lRet

//----------------------------------------------------------------------------//

METHOD ShowToolTip() CLASS TComboBox

   local nOldBottom

   nOldBottom = ::nBottom
   ::nBottom  = ::nTop + GetTextHeight( ::hWnd ) + 8

   Super:ShowToolTip()
   ::nBottom  = nOldBottom

return nil

//----------------------------------------------------------------------------//










































































































































































































































































