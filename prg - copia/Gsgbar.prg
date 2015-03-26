#include "FiveWin.Ch"

#define COLOR_BTNFACE    15
#define COLOR_BTNSHADOW  16
#define MSG_HEIGHT       23

#define CLOCK_SIZE       54
#define DATE_SIZE        56
#define TIMER_INTERVAL  400

//----------------------------------------------------------------------------//

CLASS TMsgBar FROM TWindow

   DATA   cMsgDef
   DATA   lCentered, lActive, lDate, lClock, lKbd, lInset
   DATA   oTimer, aItem
	DATA   nSizeItem
	DATA   nHeight

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
               nClrFore, nClrBack, oFont, lInset ) CONSTRUCTOR

   METHOD AddItem( oItem ) INLINE oItem:nId := Len( ::aItem ) + 1,;
                                  AAdd( ::aItem, oItem ), ::Refresh( .t. )

   METHOD DelItem( oItem ) INLINE If( oItem:nId > 0,;
                                  ( ADel( ::aItem, oItem:nId ),;
                                  ASize( ::aItem, Len( ::aItem ) - 1 ),;
                                  oItem:nId := 0, ::Refresh( .t. ) ),)

   METHOD Adjust()

   METHOD CheckTimer()
   METHOD ClockOn()
   METHOD ClockOff() INLINE If( ::lClock, ( ::lClock := .f.,;
                                ADel( ::aItem, 1 ),;
                                ASize( ::aItem, Len( ::aItem ) - 1 ),;
                                ::Refresh( .t. ) ),)

   METHOD DateOn()
   METHOD DateOff()  INLINE If( ::lDate, ( ::lDate := .f.,;
                                ADel( ::aItem, If( ::lClock, 2, 1 ) ),;
                                ASize( ::aItem, Len( ::aItem ) - 1 ),;
                                ::Refresh( .t. ) ),)

   METHOD Default()

   METHOD Destroy()

   METHOD GetItem() INLINE Len( ::aItem )

   METHOD Height() INLINE MSG_HEIGHT

   METHOD KeybOn()
   METHOD KeybOff()  INLINE If(::lKbd, ( ::lKbd := .f.,;
                               ADel( ::aItem, GetPos( ::lClock, ::lDate ) ),;
                               ADel( ::aItem, GetPos( ::lClock, ::lDate ) ),;
                               ADel( ::aItem, GetPos( ::lClock, ::lDate ) ),;
                               ASize( ::aItem, Len( ::aItem ) - 3 ),;
                               ::Refresh( .t. ) ),)


   METHOD Paint() INLINE MsgPaint( ::hWnd, ::cMsg, ::cMsgDef, .t.,;
                                   ::lCentered, GetSizeItem( ::aItem ),;
                                   ::nClrText, ::nClrPane, ::oFont:hFont,;
                                   ::lInset ),;
                                   ShowItem( Self, ::aItem, ::nRight )

   METHOD Refresh( lChange )
   METHOD SetMsg( cText )

   METHOD ShowMsgBar() VIRTUAL

   METHOD LButtonDown( nRow, nCol, nFlags )

   METHOD TimerEval()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, cPrompt, lCentered, lClock, lDate, lKbd,;
				nClrFore, nClrBack, oFont, lInset, nHeight ) CLASS TMsgBar

   local oRect := oWnd:GetCliRect()

   DEFAULT cPrompt := "", lCentered := .f., lClock := .f., lDate := .f.,;
           lKbd := .f., nClrFore := CLR_BLACK, nClrBack := GetSysColor( COLOR_BTNFACE ),;
			  lInset := .t., nHeight := 23

   ::nClrPane    = nClrBack
   ::nClrText    = nClrFore
   ::oWnd        = oWnd
   ::cMsg        = ::cMsgDef  := cPrompt
   ::nStyle      = nOR( WS_VISIBLE, WS_CHILD, WS_OVERLAPPED, WS_BORDER )
   ::nLeft       = -1
	::nTop        = oRect:nBottom - nHeight
   ::nBottom     = oRect:nBottom
   ::nRight      = oRect:nRight  + 1
   ::lCentered   = lCentered
   ::lValidating = .f.
   ::aItem       = {}
   ::lDate       = lDate
   ::lClock      = lClock
   ::lKbd        = lKbd
   ::oFont       = oFont
   ::lInset      = lInset
	::nHeight	  = nHeight
   ::Register()

   ::Create()
   ::Default()

   If ::lClock
      ::ClockOn()
   Endif

   If ::lDate
      ::DateOn()
   Endif

   If ::lKbd
      ::KeybOn()
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

   ::lClock := .t.

   ASize( ::aItem, Len( ::aItem ) + 1 )
   AIns( ::aItem, 1 )
   ::aItem[ 1 ] := TMsgItem():New( Self,, CLOCK_SIZE,,,,, { || WinExec( "Control date/time" ) } )

   ::SetMsg()
   ::CheckTimer()
   ::Refresh( .t. )

return nil

//---------------------------------------------------------------------------//

METHOD DateOn() CLASS TMsgBar

   local nPos   := If( ::lClock, 2, 1 )
   local nWidth := DATE_SIZE + If( __SetCentury(), 11, 0 )

   ::lDate := .t.

   ASize( ::aItem, Len( ::aItem ) + 1 )
   AIns( ::aItem, nPos )
   ::aItem[ nPos ] = TMsgItem():New( Self,, nWidth,,,,,;
                                     { || WinExec( "Control date/time" ) } )
   ::SetMsg()
   ::CheckTimer()
   ::Refresh( .t. )

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

METHOD Destroy() CLASS TMsgBar

   if ::oTimer != nil
      ::oTimer:End()
   endif

   ::ClockOff()
   ::DateOff()
   ::keybOff()

   Super:Destroy()

return nil

//----------------------------------------------------------------------------//

METHOD KeybOn() CLASS TMsgBar

   local nCount, nPos

   ::lKbd := .t.
   ASize( ::aItem, Len( ::aItem ) + 3 )

   nPos := GetPos( ::lClock, ::lDate )
   for nCount := nPos to nPos + 2
      AIns( ::aItem, nCount )
      ::aItem[ nCount ] := TMsgItem():New( Self )
   next

   ::aItem[ nPos     ]:nSize   = 26
   ::aItem[ nPos     ]:bAction = { || KeyToggle( VK_INSERT ) }
   ::aItem[ nPos + 1 ]:nSize   = 34
   ::aItem[ nPos + 1 ]:bAction = { || KeyToggle( VK_CAPITAL ) }
   ::aItem[ nPos + 2 ]:nSize   = 30
   ::aItem[ nPos + 2 ]:bAction = { || KeyToggle( VK_NUMLOCK ) }

   ::SetMsg()
   ::CheckTimer()
   ::Refresh( .t. )

return nil

//---------------------------------------------------------------------------//

METHOD Refresh( lChange ) CLASS TMsgBar

   DEFAULT lChange := .f.

   if lChange
      AEval( ::aItem, { | oItem, nPos | oItem:nId := nPos } )
   endif
   Super:Refresh()

return nil

//---------------------------------------------------------------------------//

METHOD SetMsg( cText ) CLASS TMsgBar

   DEFAULT ::cMsg := ""

   if Empty( cText )
      if ! Empty( ::cMsg )
         MsgPaint( ::hWnd, ::cMsg := "", ::cMsgDef, .f.,;
                   ::lCentered, GetSizeItem( ::aItem ),;
                   ::nClrText, ::nClrPane, ::oFont:hFont )
      endif
   else
      if ::cMsg != cText
         MsgPaint( ::hWnd, ::cMsg := cText, ::cMsgDef, .f.,;
                   ::lCentered, GetSizeItem( ::aItem ),;
                   ::nClrText, ::nClrPane, ::oFont:hFont )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CheckTimer() CLASS TMsgBar

   if ::oTimer == NIL
      DEFINE TIMER ::oTimer OF Self INTERVAL TIMER_INTERVAL;
         ACTION ::TimerEval()

      ACTIVATE TIMER ::oTimer
   endif

return nil

//----------------------------------------------------------------------------//

static function GetKeybPos( nPos, lClock, lDate )

   local aPos     := Array( 3 )
   local lCentury := __SetCentury()

   do case
      case lClock .and. lDate
         aPos[ 1 ] = 215 + If( lCentury, 10, 0 )
         aPos[ 2 ] = 179 + If( lCentury, 10, 0 )
         aPos[ 3 ] = 140 + If( lCentury, 10, 0 )

      Case lClock .or. lDate
         aPos[ 1 ] = 157 + If( lCentury, 10, 0 )
         aPos[ 2 ] = 120 + If( lCentury, 10, 0 )
         aPos[ 3 ] =  82 + If( lCentury, 10, 0 )

      Case ! lClock .and. ! lDate
         aPos[ 1 ] =  96 + If( lCentury, 10, 0 )
         aPos[ 2 ] =  62 + If( lCentury, 10, 0 )
         aPos[ 3 ] =  22 + If( lCentury, 10, 0 )
   endcase

return aPos[ nPos ]

//---------------------------------------------------------------------------//

static function GetSizeItem( aItem )

   local nCount, nSize := 5

   if Empty( aItem )
      return nSize
   endif

   for nCount := 1 to Len( aItem )
      nSize += aItem[ nCount ]:nSize + 4
   next

return nSize

//---------------------------------------------------------------------//

static function ShowItem( oWnd, aItem, nRight )

   Local nCount, nPos, hDC
   Local oRect, oBrush

   hDC := GetDC( oWnd:hWnd )
   nPos := nRight

   for nCount := 1 to Len(aItem)

      nPos -= aItem[nCount]:nSize
      WndBoxIn(hDC, 3, nPos, 18, (nPos + aItem[nCount]:nSize) - 4)
      oRect:= TRect():New(4, nPos + 1, 17, nPos + (aItem[nCount]:nSize - 5))

      If aItem[ nCount ]:cMsg != nil
         DrawMsgItem( hDC, aItem[ nCount ]:cMsg, oRect,;
                  aItem[ nCount ]:nClrText, aItem[ nCount ]:nClrPane,;
                  aItem[ nCount ]:oFont:hFont )
      else
         oBrush := TBrush():New( , aItem[ nCount ]:nClrPane )
         FillRect( hDC, oRect, oBrush:hBrush )
         oBrush:End()
      endif

      nPos -= 4
   next

   ReleaseDC( oWnd:hWnd, hDC )

return nil

//------------------------------------------------------------------------//

static function GetPos( lClock, lDate )

   local nPos

   do case
      case lClock .and. lDate
         nPos = 3

      case lClock .or. lDate
         nPos = 2

      case ! lClock .and. ! lDate
         nPos = 1
   endcase

return nPos

//------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TMsgBar

   local n := 1
   local nPos

   nPos = ::nWidth

   if ::lClock
      if nCol >= ( ::nRight - CLOCK_SIZE )
         ::aItem[ 1 ]:Click()
         return nil
      else
         nPos -= CLOCK_SIZE + 6
         n++
      endif
   endif

   if ::lDate
      if nCol >= ( nPos - DATE_SIZE )
         ::aItem[ 1 + If( ::lClock, 1, 0 ) ]:Click()
         return nil
      else
         nPos -= DATE_SIZE + If( __SetCentury(), 10, 0 ) + 6
         n++
      endif
   endif

   while n <= Len( ::aItem ) .and. nCol <= nPos
      nPos -= ::aItem[ n++ ]:nSize
   end

   if --n > 0 .and. nCol >= nPos - 6
      ::aItem[ n ]:Click()
   endif

return nil

//------------------------------------------------------------------------//

METHOD TimerEval() CLASS TMsgBar

   local nWidth := DATE_SIZE + If( __SetCentury(), 11, 0 )

   if ::lClock
      ::Say( 4, ::nRight - 52, Time(), ::nClrText,;
            ::nClrPane, ::oFont, .t.)
   endif

   if ::lDate
      ::Say( 4, ::nRight - If( ::lClock, 56 + nWidth, nWidth ),;
             Date(), ::nClrText, ::nClrPane, ::oFont, .t. )
   endif

   if ::lKbd
      ::Say( 4, ::nRight - GetKeybPos( 1, ::lClock, ::lDate ), "Num",;
            If( GetKeyToggle( VK_NUMLOCK ), CLR_BLACK, CLR_GRAY ),;
            ::nClrPane, ::oFont, .t.)

      ::Say( 4, ::nRight - GetKeybPos( 2, ::lClock, ::lDate ), "Caps",;
             If( GetKeyToggle( VK_CAPITAL ), CLR_BLACK, CLR_GRAY ),;
             ::nClrPane, ::oFont, .t. )

      ::Say( 4, ::nRight - GetKeybPos( 3, ::lClock, ::lDate ), "Ins",;
             If( GetKeyToggle( VK_INSERT ), CLR_BLACK, CLR_GRAY ),;
             ::nClrPane, ::oFont, .t. )
  endif

return nil

//------------------------------------------------------------------------//