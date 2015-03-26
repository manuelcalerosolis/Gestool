#include "FiveWin.ch"

#define COLOR_BTNFACE    15
#define COLOR_BTNSHADOW  16

#define TIMER_INTERVAL  400

#define SRCCOPY    13369376 // 0x00CC0020

static aInitInfo := { 0, 0 }
static hBmp2007
static oMsgBarDefault

//----------------------------------------------------------------------------//

CLASS TMsgBar FROM TControl

   DATA   cMsgDef
   DATA   lCentered, lInset
   DATA   oTimer, aItems, nItem
   DATA   oKeyNum, oKeyCaps, oKeyIns, oClock, oDate
   DATA   nSizeItem, nHeight

   DATA   lCheckRes AS LOGICAL
   DATA   lInfoRes, l2007, l2010
   DATA   lPainting
   DATA   lPaint3L

   CLASSDATA lRegistered AS LOGICAL

   CLASSDATA aProperties INIT { "l2007", "cVarName", "aItems" }

   METHOD New( oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
               nClrFore, nClrBack, oFont, lInset, l2007 ) CONSTRUCTOR

   METHOD AddItem( oItem ) INLINE AAdd( ::aItems, oItem ), ::Refresh()

   METHOD DelItem( oItem )
   METHOD InsItem( oItem, nAt )

   METHOD Adjust()

   METHOD CheckTimer()
   METHOD ClockOn()
   METHOD ClockOff() INLINE ::DelItem( ::oClock ), ::oClock := nil, ::Refresh()

   METHOD DateOn()
   METHOD DateOff()  INLINE ::DelItem( ::oDate ), ::oDate := nil, ::Refresh()

   METHOD Default()

   METHOD Destroy()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC ) INLINE 1
   
   METHOD FastEdit( nRow, nCol ) 

   METHOD GetItems() INLINE Len( ::aItems )

   METHOD Height() INLINE ::nHeight

   METHOD KeybOn()
   METHOD KeybOff()  INLINE ::DelItem( ::oKeyNum ), ::DelItem( ::oKeyCaps ),;
                            ::DelItem( ::oKeyIns ),;
                            ::oKeyNum := nil, ::oKeyCaps := nil, ::oKeyIns := nil,;
                            ::Refresh()

   METHOD LDblClick( nRow, nCol, nKeyFlags )

   METHOD MouseMove( nRow, nCol, nFlags )

   METHOD Paint()
   METHOD PaintBar( nLeft, nWidth )

   METHOD RButtonDown( nRow, nCol, nFlags )
   
   METHOD SetItems( aItems )
   
   METHOD SetMsg( cText )

   METHOD SetText( cText ) INLINE ::SetMsg( cText )

   METHOD ShowMsgBar() VIRTUAL

   METHOD LButtonDown( nRow, nCol, nFlags )

   METHOD ShowToolTip()

   METHOD TimerEval()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
            nClrFore, nClrBack, oFont, lInset, l2007, l2010 ) CLASS TMsgBar

   local oRect
   
   DEFAULT oWnd := GetWndDefault(), cPrompt := "", lCentered := .F., lClock := .F.,;
           lDate := .F., lKbd := .F., nClrFore := CLR_BLACK,;
           nClrBack := GetSysColor( COLOR_BTNFACE ), lInset := .t.,;
           l2007 := .F., l2010 := .F.

   oRect = oWnd:GetCliRect()

   l2010 := If( l2007, .F., l2010 )

   ::nClrPane    = nClrBack
   ::nClrText    = nClrFore
   ::oWnd        = oWnd
   ::oWnd:oMsgBar = Self
   ::cMsg        = ::cMsgDef  := cPrompt
   ::nStyle      = nOR( WS_VISIBLE, WS_CHILD, WS_OVERLAPPED, WS_BORDER )
   ::nLeft       = -1
   ::nHeight     = GetTextHeight( oWnd:hWnd ) + 8
   ::nTop        = oRect:nBottom - ::nHeight
   ::nBottom     = oRect:nBottom
   ::nRight      = oRect:nRight  + 1
   ::lCentered   = lCentered
   ::lInset      = lInset
   ::lValidating = .F.
   ::aItems      = {}
   ::oFont       = oFont
   ::lInfoRes    = .t.
   ::l2007       = l2007
   ::l2010       = l2010
   ::lPainting   = .F.
   ::lPaint3L    = .T.

   ::Register()

   ::Create()
   ::Default()

   if lKbd
      ::KeybOn()
   endif

   if lDate
      ::DateOn()
   endif

   if lClock
      ::ClockOn()
   endif

   SetMsgBarDefault( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TMsgBar

   local rctParent := ::oWnd:GetCliRect()

   ::SetCoors( TRect():New( rctParent:nBottom - ::nHeight, rctParent:nLeft - 1,;
                            rctParent:nBottom, rctParent:nRight ) )
return nil

//----------------------------------------------------------------------------//

METHOD ClockOn() CLASS TMsgBar

   local cTime := Time()

   if ::oClock == nil
      // keep the ':=' below for XBase++ compatibility
      ::oClock := TMsgItem():New( Self, cTime, ::GetWidth( cTime ) + 12,,,, .t.,;
                                 { || WinExec( "Control date/time" ) } )
      ::oClock:lTimer = .t.
      ::oClock:bMsg   = { || Time() }
   endif
   ::CheckTimer()

return nil

//---------------------------------------------------------------------------//

METHOD DateOn() CLASS TMsgBar

   local cDate := DToC( Date() )

   if ::oDate == nil
      // keep the ':=' below for XBase++ compatibility
      ::oDate := TMsgItem():New( Self, cDate, ::GetWidth( cDate ) + 12,,,, .t.,;
                                { || WinExec( "Control date/time" ) } )
      ::oDate:lTimer = .t.
      ::oDate:bMsg   = { || DToC( Date() ) }
   endif
   ::CheckTimer()

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TMsgBar

   local oFont

   if ::oFont == nil
      DEFINE FONT oFont NAME GetSysFont() SIZE 0, -12
      ::SetFont( oFont )
      oFont:End()
   endif

/*
   // This logic results in incrementing oFont:nCount by 2 from the
   // second creating of msgbar object onwards
   // logic replaced : 2011/08/31

   if ::oFont == nil
      DEFINE FONT ::oFont NAME GetSysFont() SIZE 0, -12
      if ::oFont:lNew
         ::oFont:nCount--
      endif
   endif

   ::SetFont( ::oFont )
*/

   ::SetColor( ::nClrText, ::nClrPane )

return nil

//---------------------------------------------------------------------------//

METHOD InsItem( oItem, nAt ) CLASS TMsgBar

   if nAt == nil
      return nil
   endif

   if nAt > 0
      ASize( ::aItems, Len( ::aItems ) + 1 )
      AIns( ::aItems, nAt )
      ::aItems[ nAt ] = oItem
      ::Refresh()
   endif

return nil

//---------------------------------------------------------------------------//

METHOD DelItem( oItem ) CLASS TMsgBar

   local nAt := AScan( ::aItems, { | o | o == oItem } )

   if nAt != 0
      ADel( ::aItems, nAt )
      ASize( ::aItems, Len( ::aItems ) - 1 )
      ::Refresh()
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Destroy() CLASS TMsgBar

   AEval( ::aItems, { | o | if( o:hBitmap1 != nil, DeleteObject( o:hBitmap1 ), ),;
                           if( o:hBitmap2 != nil, DeleteObject( o:hBitmap2 ), ),;
                           if( o:hBack != nil, DeleteObject( o:hBack ), ) } )

   if ::oTimer != nil
      ::oTimer:End()
   endif


   DeleteObject( hBmp2007 )
   hBmp2007     := nil


return Super:Destroy()

//----------------------------------------------------------------------------//

METHOD FastEdit( nRow, nCol ) CLASS TMsgBar

   local oPopup
   
   MENU oPopup POPUP
      MENUITEM "Prompt..." ACTION ( ::cMsgDef := ::EditTitle( ::cMsgDef ), ::Refresh() )

      SEPARATOR
    
      if ::oDate != nil
         MENUITEM "Date" ACTION ::DateOff() CHECKED
      else   
         MENUITEM "Date" ACTION ::DateOn()
      endif      

      if ::oClock != nil
         MENUITEM "Clock" ACTION ::ClockOff() CHECKED
      else   
         MENUITEM "Clock" ACTION ::ClockOn()
      endif      

      if ::oKeyNum != nil
         MENUITEM "Keyboard" ACTION ::KeybOff() CHECKED
      else   
         MENUITEM "Keyboard" ACTION ::KeybOn()
      endif      

      SEPARATOR   

      MENUITEM "Source code..." ACTION MemoEdit( ::cGenPrg(), "Source code" )
   ENDMENU
   
   ACTIVATE POPUP oPopup WINDOW Self AT nRow, nCol

return nil

//------------------------------------------------------------------------//

METHOD KeybOn() CLASS TMsgBar

   if ::oKeyNum == nil
      // keep the ':=' below for XBase++ compatibility
      ::oKeyNum := TMsgItem():New( Self, "Num", ::GetWidth( "Num" ) + 12,,,, .t.,;
                                  { || KeyToggle( VK_NUMLOCK ), ::oKeyNum:Refresh() } )
      ::oKeyNum:lTimer = .t.
      ::oKeyNum:nClrDisabled = GetSysColor( COLOR_BTNSHADOW )
      ::oKeyNum:lActive = GetKeyToggle( VK_NUMLOCK )
      ::oKeyNum:bMsg  = { || ::oKeyNum:lActive := GetKeyToggle( VK_NUMLOCK ), "Num" }
   endif

   if ::oKeyCaps == nil
      // keep the ':=' below for XBase++ compatibility
      ::oKeyCaps := TMsgItem():New( Self, "Caps", ::GetWidth( "Caps" ) + 12,,,, .t.,;
                                  { || KeyToggle( VK_CAPITAL ), ::oKeyCaps:Refresh() } )
      ::oKeyCaps:lTimer = .t.
      ::oKeyCaps:nClrDisabled = GetSysColor( COLOR_BTNSHADOW )
      ::oKeyCaps:lActive = GetKeyToggle( VK_CAPITAL )
      ::oKeyCaps:bMsg = { || ::oKeyCaps:lActive := GetKeyToggle( VK_CAPITAL ), "Caps" }
   endif

   if ::oKeyIns == nil
      // keep the ':=' below for XBase++ compatibility
      ::oKeyIns := TMsgItem():New( Self, "Ins", ::GetWidth( "Ins" ) + 12,,,, .t.,;
                                  { || KeyToggle( VK_INSERT ), ::oKeyIns:Refresh() } )
      ::oKeyIns:lTimer = .t.
      ::oKeyIns:nClrDisabled = GetSysColor( COLOR_BTNSHADOW )
      ::oKeyIns:lActive = GetKeyToggle( VK_INSERT )
      ::oKeyIns:bMsg = { || ::oKeyIns:lActive := GetKeyToggle( VK_INSERT ), "Ins" }
   endif

   ::CheckTimer()

return nil

//---------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TMsgBar

   if ::lInfoRes .or. ( ! ::lInfoRes .and. ::lCheckRes )
      if ! ::lCheckRes
         ::Cargo := ::oWnd:GetText()
      endif
      ::lCheckRes := ! ::lCheckRes
   endif

return Super:LDblClick( nRow, nCol, nKeyFlags )

//---------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TMsgBar

  local n
  
  if ::lFastEdit
     ::FastEdit( nRow, nCol )
  endif   

  for n = 1 to Len( ::aItems )
     if ::aItems[ n ]:IsOver( nRow, nCol )
        ::aItems[ n ]:RClick( nRow, nCol )
        return nil
     endif
  next

return nil

//------------------------------------------------------------------------//

METHOD SetItems( aItems ) CLASS TMsgBar

   local n
   
   for n = 1 to Len( aItems )
      ::AddItem( TMsgItem():New( Self, aItems[ n ]) )
   next
   
return nil      

//------------------------------------------------------------------------//
      
METHOD SetMsg( cText ) CLASS TMsgBar

   DEFAULT ::cMsg := ""

   if ValType( cText ) == 'B'
      cText := Eval( cText )
   endif

   if ::l2007 .or. ::l2010
      ::cMsg = cText
      ::Refresh()
      return nil
   endif

   ::GetDC()

   if Empty( cText )
      if ! Empty( ::cMsg )
         MsgPaint( ::hWnd, ::cMsg := "", ::cMsgDef, .F.,;
                   ::lCentered, If( Len( ::aItems ) > 0, ::aItems[ 1 ]:nLeft(), 0 ),;
                   ::nClrText, ::nClrPane, ::oFont:hFont, ::lInset, ::hDC )
         if ::lPaint3L
            MsgPaint3L( ::hWnd, ::l2007 .or. ::l2010, ::hDC )
         endif
      endif
   else
      if ::cMsg != cText
         MsgPaint( ::hWnd, ::cMsg := cText, ::cMsgDef, .F.,;
                   ::lCentered, If( Len( ::aItems ) > 0, ::aItems[ 1 ]:nLeft(), 0 ),;
                   ::nClrText, ::nClrPane, ::oFont:hFont, ::lInset, ::hDC )
         if ::lPaint3L
            MsgPaint3L( ::hWnd, ::l2007 .or. ::l2010, ::hDC )
         endif
      endif
   endif

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD CheckTimer() CLASS TMsgBar

   if ::oTimer == nil
      DEFINE TIMER ::oTimer OF Self INTERVAL TIMER_INTERVAL;
         ACTION ::TimerEval()

      ACTIVATE TIMER ::oTimer
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nFlags ) CLASS TMsgBar

   local n, oItem

   for n = 1 to Len( ::aItems )
      oItem = ::aItems[ n ]
      if oItem:IsOver( nRow, nCol ) .and. oItem:bAction != nil
         CursorHand()
         if ::nItem != n
            ::nItem := n
            ::DestroyToolTip()
         endif
         ::CheckToolTip()
         return nil
      endif
   next
   ::DestroyToolTip()
   ::nItem := 0

return Super:MouseMove( nRow, nCol, nFlags )

//------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TMsgBar

   local n

   for n = 1 to Len( ::aItems )
      if ::aItems[ n ]:IsOver( nRow, nCol )
         ::aItems[ n ]:Click( nRow, nCol)
         return nil
      endif
   next

return nil

//------------------------------------------------------------------------//

METHOD TimerEval() CLASS TMsgBar

   local n, oItem, cBits

   for n = 1 to Len( ::aItems )
      oItem = ::aItems[ n ]
      if oItem:lTimer
         oItem:Refresh()
      endif
   next

   #ifdef __CLIPPER__
      cBits = "(16 bits) "
   #else
      cBits = "(32 bits) "
   #endif

   if ::lCheckRes
      ::oWnd:SetText( cBits + ;
                      "MemUsed: " + AllTrim( Transform( MemUsed(), "999,999,999,999" ) ) + ;
                      " MemMax: " + Alltrim( Transform( MemMax(), "999,999,999,999" ) ) + ;
                      " Resources: " + AllTrim( Str( GetFreeSystemResources( 1 ) ) ) + "%" + ;
                      " Running time: " + TimeFromStart() )
   else
      if ! Empty( ::Cargo )
         ::oWnd:SetText( ::Cargo )
         ::Cargo = nil
      endif
   endif

return nil

//------------------------------------------------------------------------//

METHOD Paint() CLASS TMsgBar

   local aInfo := ::DispBegin()

   if ::l2007 .or. ::l2010
      ::PaintBar()
      ::Say( ::nHeight / 4 - 2,;
             If( ::lCentered, ( ( ( If( Len( ::aItems ) > 0, ::aItems[ 1 ]:nLeft(), ::nWidth ) ) ) / 2 ) - ( GetTextWidth( ::hDC,;
             If( Empty( ::cMsg ), ::cMsgDef, ::cMsg ),;
             ::oWnd:oFont:hFont ) / 2 ), 4 ),;
              If( Empty( ::cMsg ), ::cMsgDef, ::cMsg ),;
             ::nClrText,,, .T., .T. )
      ::lPainting := .T.
      ASend( ::aItems, "Paint()" )
      if ::lPaint3L
         MsgPaint3L( ::hWnd, ::l2007 .or. ::l2010, ::hDC )
      endif
      ::lPainting := .F.
      if ::bPainted != nil
         Eval( ::bPainted, ::hDC )
      endif
      ::DispEnd( aInfo )
      return nil
   endif

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   MsgPaint( ::hWnd, ::cMsg, ::cMsgDef, .t.,;
             ::lCentered, If( Len( ::aItems ) > 0, ::aItems[ 1 ]:nLeft(), 0 ),;
             ::nClrText, ::nClrPane, ::oFont:hFont,;
             ::lInset, ::hDC )

   ASend( ::aItems, "Paint()" )

   if ::lPaint3L
      MsgPaint3L( ::hWnd, ::l2007 .or. ::l2010, ::hDC )
   endif

   ::DispEnd( aInfo )

return nil

//------------------------------------------------------------------------//

METHOD PaintBar( nLeft, nWidth ) CLASS TMsgBar

   local hDCMem, hOldBmp

//   static hBmp  // not released when appln ends. Hence moved to app wide

   if ! ::lPainting

      DEFAULT nLeft := 0, nWidth := ::nWidth

      if hBmp2007 == nil
         if ::l2007
            hBmp2007 = MsgBar2007( ::hDC )
         endif
      endif

      hDCMem = CreateCompatibleDC( ::hDC )
      hOldBmp = SelectObject( hDCMem, hBmp2007 )
      StretchBlt( ::hDC, nLeft, 0, nWidth, ::nHeight, hDCMem, 0, 0, nBmpWidth( hBmp2007 ), nBmpHeight( hBmp2007 ), SRCCOPY )
      SelectObject( hDCMem, hOldBmp )
      DeleteDC( hDCMem )

   endif

return nil

//------------------------------------------------------------------------//

METHOD ShowToolTip() CLASS TMsgBar

   local oItem, nTop, nLeft

   if ::nItem != 0
      oItem = ::aItems[ ::nItem ]

      if ! Empty( oItem:cToolTip )
         if ValType( oItem:cToolTip ) == "B"
            ::cToolTip = Eval( oItem:cToolTip )
         else
            ::cToolTip = oItem:cToolTip
         endif

         nLeft = oItem:nLeft()
         nTop  = - MLCount( ::cToolTip, 254 ) * 14 - 2

         Super:ShowToolTip( nTop, nLeft )
      endif
   endif

return nil

//------------------------------------------------------------------------//

init procedure InitTime()

   aInitInfo = { Date(), Seconds() }

return

//------------------------------------------------------------------------//

function TimeFromStart()

   local nSeconds, nHours, nMins, nSecs

   if ValType( aInitInfo[ 1 ] ) == "N"
      aInitInfo = { Date(), Seconds() }
   endif

   nSeconds = SecsFromStart( aInitInfo[ 1 ], aInitInfo[ 2 ] )
   nHours   = Int( nSeconds / 3600 )
   nMins    = Int( ( nSeconds - ( nHours * 3600 ) ) / 60 )
   nSecs    = Int( nSeconds - ( nHours * 3600 ) - ( nMins * 60 ) )

return AllTrim( Str( nHours ) ) + " hours " + ;
       AllTrim( Str( nMins ) ) + " mins " + ;
       AllTrim( Str( nSecs ) ) + " secs "

//----------------------------------------------------------------------------//

static function SecsFromStart( dInitDate, nInitSecs ) // by hDC

   local nSeconds:= Seconds()
   local nDays := Date() - dInitDate

   if ValType( nDays ) == "D"  // C3 temporary workaround
      nDays = Day( Date() ) - Day( dInitDate )
   endif
   if nDays < 0  // Surely you change the date after the beginning of the system
      return 0
   endif

   if nDays > 0
      nDays--
      return ( 86399 - nInitSecs ) + ( nDays * 86399 ) + nSeconds
   endif

return nSeconds - nInitSecs

//------------------------------------------------------------------------//

function SetMsgBarDefault( oMsgBar ) ; oMsgBarDefault := oMsgBar ; return nil

function GetMsgBarDefault() ; return oMsgBarDefault

//------------------------------------------------------------------------//
