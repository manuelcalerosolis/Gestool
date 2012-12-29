#include "FiveWin.Ch"
#include "Font.ch"

#define COLOR_BTNFACE    15
#define COLOR_BTNSHADOW  16
#define MSG_HEIGHT       23

#define TIMER_INTERVAL  400

#ifdef __XPP__
   #define Super ::TWindow
#endif

//----------------------------------------------------------------------------//

CLASS TMsgBar FROM TWindow

   DATA   cMsgDef
   DATA   lCentered, lInset
   DATA   oTimer, aItem
   DATA   oKeyNum, oKeyCaps, oKeyIns, oClock, oDate
   DATA   nSizeItem

   DATA   lCheckRes AS LOGICAL

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
               nClrFore, nClrBack, oFont, lInset ) CONSTRUCTOR

   METHOD AddItem( oItem ) INLINE AAdd( ::aItem, oItem ), ::Refresh()

   METHOD DelItem( oItem )

   METHOD Adjust()

   METHOD CheckTimer()
   METHOD ClockOn()
   METHOD ClockOff() INLINE ::DelItem( ::oClock ), ::oClock := nil, ::Refresh()

   METHOD DateOn()
   METHOD DateOff()  INLINE ::DelItem( ::oDate ), ::oDate := nil, ::Refresh()

   METHOD Default()

   METHOD Destroy()

   METHOD GetItem() INLINE Len( ::aItem )

   METHOD Height() INLINE MSG_HEIGHT

   METHOD KeybOn()
   METHOD KeybOff()  INLINE ::DelItem( ::oKeyNum ), ::DelItem( ::oKeyCaps ),;
                            ::DelItem( ::oKeyIns ),;
                            ::oKeyNum := nil, ::oKeyCaps := nil, ::oKeyIns := nil,;
                            ::Refresh()

   METHOD LDblClick( nRow, nCol, nKeyFlags ) INLINE ;
                            If( ! ::lCheckRes, ::Cargo := ::oWnd:GetText(),),;
                            ::lCheckRes := ! ::lCheckRes

   METHOD MouseMove( nRow, nCol, nFlags )

   METHOD Paint()

   METHOD SetMsg( cText )

   METHOD ShowMsgBar() VIRTUAL

   METHOD LButtonDown( nRow, nCol, nFlags )

   METHOD TimerEval()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
            nClrFore, nClrBack, oFont, lInset ) CLASS TMsgBar

   local oRect := oWnd:GetCliRect()

   DEFAULT cPrompt := "", lCentered := .f., lClock := .f., lDate := .f.,;
           lKbd := .f., nClrFore := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ),;
           lInset := .t.

   ::nClrPane    = nClrBack
   ::nClrText    = nClrFore
   ::oWnd        = oWnd
   ::cMsg        = ::cMsgDef  := cPrompt
   ::nStyle      = nOR( WS_VISIBLE, WS_CHILD, WS_OVERLAPPED, WS_BORDER )
   ::nLeft       = -1
   ::nTop        = oRect:nBottom - 23
   ::nBottom     = oRect:nBottom
   ::nRight      = oRect:nRight  + 1
   ::lCentered   = lCentered
   ::lInset      = lInset
   ::lValidating = .f.
   ::aItem       = {}
   ::oFont       = oFont

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
      ::lCheckRes = .f.
   #endif

   ::Register()

   ::Create()
   ::Default()

   If lKbd
      ::KeybOn()
   Endif

   If lDate
      ::DateOn()
   Endif

   If lClock
      ::ClockOn()
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TMsgBar

   local rctParent := ::oWnd:GetCliRect()

   ::SetCoors( TRect():New( rctParent:nBottom - 23, rctParent:nLeft - 1,;
                            rctParent:nBottom, rctParent:nRight ) )
return nil

//----------------------------------------------------------------------------//

METHOD ClockOn() CLASS TMsgBar

   if ::oClock == nil
      // keep the ':=' below for XBase++ compatibility
      ::oClock := TMsgItem():New( Self, Time(), ::GetWidth( Time() ) + 12,,,, .t.,;
                                 { || WinExec( "Control date/time" ) } )
      ::oClock:lTimer = .t.
      ::oClock:bMsg   = { || Time() }
   endif
   ::CheckTimer()

return nil

//---------------------------------------------------------------------------//

METHOD DateOn() CLASS TMsgBar

   if ::oDate == nil
      // keep the ':=' below for XBase++ compatibility
      ::oDate := TMsgItem():New( Self, DToC( Date() ),;
                                ::GetWidth( DToC( Date() ) ) + 12,,,, .t.,;
                                { || WinExec( "Control date/time" ) } )
      ::oDate:lTimer = .t.
      ::oDate:bMsg   = { || Date() }
   endif
   ::CheckTimer()

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TMsgBar

   if ::oFont != Nil
      ::SetFont( ::oFont )
   else
      DEFINE FONT ::oFont NAME "Ms Sans Serif" SIZE 0, -8
   endif

   ::SetColor( ::nClrText, ::nClrPane )

return nil

//---------------------------------------------------------------------------//

METHOD DelItem( oItem ) CLASS TMsgBar

   local nAt := AScan( ::aItem, { | o | o == oItem } )

   if nAt != 0
      ADel( ::aItem, nAt )
      ASize( ::aItem, Len( ::aItem ) - 1 )
      ::Refresh()
   endif

return nil

//---------------------------------------------------------------------------//

METHOD Destroy() CLASS TMsgBar

   if ::oTimer != nil
      ::oTimer:End()
   endif

return Super:Destroy()

//----------------------------------------------------------------------------//

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

METHOD SetMsg( cText ) CLASS TMsgBar

   DEFAULT ::cMsg := ""

   if Empty( cText )
      if ! Empty( ::cMsg )
         MsgPaint( ::hWnd, ::cMsg := "", ::cMsgDef, .f.,;
                   ::lCentered, If( Len( ::aitem ) > 0, ::aItem[ 1 ]:nLeft(), 0 ),;
                   ::nClrText, ::nClrPane, ::oFont:hFont )
      endif
   else
      if ::cMsg != cText
         MsgPaint( ::hWnd, ::cMsg := cText, ::cMsgDef, .f.,;
                   ::lCentered, If( Len( ::aitem ) > 0, ::aItem[ 1 ]:nLeft(), 0 ),;
                   ::nClrText, ::nClrPane, ::oFont:hFont )
      endif
   endif

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

   local n

   for n = 1 to Len( ::aItem )
      if ::aItem[ n ]:IsOver( nRow, nCol )
         CursorHand()
         return nil
      endif
   next

return Super:MouseMove( nRow, nCol, nFlags )

//------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TMsgBar

   local n

   for n = 1 to Len( ::aItem )
      if ::aItem[ n ]:IsOver( nRow, nCol )
         ::aItem[ n ]:Click()
         return nil
      endif
   next

return nil

//------------------------------------------------------------------------//

METHOD TimerEval() CLASS TMsgBar

   local n, oItem

   for n = 1 to Len( ::aItem )
      oItem = ::aItem[ n ]
      if oItem:lTimer
         oItem:Refresh()
      endif
   next

   if ::lCheckRes
      //Toninho@fwi.com.br
      n := "Local Private Total:" + LTrim( Str ( BLILOCTOT(), 5 ) )
      n += " Used:" + LTrim( Str ( BLILOCUSE(), 5 ) )
      n += " Free:" + LTrim( Str ( BLILOCAVL(), 5 ) ) + "* | " + If ( BLISTCSHR (), " SH | ", "")
      n += "Static Total:"  + LTrim( Str ( BLISTCTOT(), 5 ) )
      n += " Used:"  + LTrim( Str ( BLISTCUSE(), 5 ) )
      n += " Free:"  + LTrim( Str ( BLISTCAVL(), 5 ) ) + "*"

      ::oWnd:SetText( "Mem.Used:" + AllTrim( Transform( MemUsed(), "999,999,999,999" ) ) + ;
                      " Max:" + AllTrim( Transform( MemMax(), "999,999,999,999" ) ) + " | " + ;
                      " Res:" + AllTrim( Str( 0 ) ) + "% | " + n )
   else
      if ! Empty( ::Cargo )
         ::oWnd:SetText( ::Cargo )
         ::Cargo = nil
      endif
   endif

return nil

//------------------------------------------------------------------------//

METHOD Paint() CLASS TMsgBar

   MsgPaint( ::hWnd, ::cMsg, ::cMsgDef, .t.,;
             ::lCentered, If( Len( ::aItem ) > 0, ::aItem[ 1 ]:nLeft(), 0 ),;
             ::nClrText, ::nClrPane, ::oFont:hFont,;
             ::lInset )

   #ifndef __XPP__
      ASend( ::aItem, "Paint" ) // ShowItem( Self, ::aItem, ::nRight )
   #else
      ASend( ::aItem, "Paint()" )
   #endif

return nil

//------------------------------------------------------------------------//








































































































































































































































































































































































