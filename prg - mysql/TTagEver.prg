#include "FiveWin.ch"

************************************************************************************************************************************

CLASS TTagEver FROM TControl

    CLASSDATA lRegistered AS LOGICAL

    DATA aItems
    DATA aFonts
    DATA nClrTextOver
    DATA nClrPaneOver
    DATA nHLine AS NUMERIC INIT 25
    DATA aCoors
    DATA nMaxDescend
    DATA nOver
    DATA nClrBorder
    DATA nClrBackTag
    DATA bAction
    DATA lOverClose
    DATA nOption

    METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, nClrBorder, nClrBackTag, aItems, nClrPane, nClrPaneOver ) CONSTRUCTOR
    METHOD Redefine( nId, oWnd, oFont, aItems ) CONSTRUCTOR
	 // METHOD Initiate( hDlg )

    METHOD SetItems( aItems )
    METHOD AddItem( cText, nPeso )

    METHOD Paint()
    METHOD Display()                        INLINE ::BeginPaint(),::Paint(),::EndPaint(), 0
    METHOD GetItems()

    METHOD LButtonDown( nRow, nCol, nFlags )
    METHOD MouseMove  ( nRow, nCol, nFlags )
    METHOD LButtonUp  ( nRow, nCol, nFlags )

    METHOD EraseBkGnd( hDC )                INLINE 1

    METHOD HideItems()                      INLINE ( aeval(::aItems, {|aItem| aItem[2]  := .t. } ), ::Refresh() )

ENDCLASS

************************************************************************************************************************************
  METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, nClrBorder, nClrBackTag, aItems, nClrPane, nClrPaneOver ) CLASS TTagEver
************************************************************************************************************************************

   local nClrText       := rgb(  0,102,227)
   local nClrTextOver   := 0 //rgb(255,102,  0)
   DEFAULT nClrPane     := CLR_WHITE
   DEFAULT nClrPaneOver := rgb(221,221,221)
   DEFAULT nTop         := 0
   DEFAULT nLeft        := 0
   DEFAULT nWidth       := 0
   DEFAULT nHeight      := 0
   DEFAULT nClrBorder   := rgb(204,214,197)
   DEFAULT nClrBackTag  := rgb(235,245,226)


   ::nStyle       := nOR( WS_CHILD, WS_VISIBLE )
   ::SetItems( aItems )

   ::aCoors       := {}

   ::oWnd         := oWnd
   ::nTop         := nTop
   ::nLeft        := nLeft
   ::nBottom      := nTop + nHeight
   ::nRight       := nLeft + nWidth
   ::nId          := ::GetNewId()
   ::lCaptured    := .f.
   ::nClrPane     := nClrPane
   ::nClrText     := nClrText
   ::nClrPaneOver := nClrPaneOver
   ::nClrTextOver := nClrTextOver
   ::oFont        := oFont
   ::nOver        := -1
   ::nClrBorder   := nClrBorder
   ::nClrBackTag  := nClrBackTag
   ::lOverClose   := .f.
   ::nOption      := 1

   ::SetColor( nClrText, nClrPane )

   ::lVisible    := .t.

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )
   ::Create()

RETURN Self

************************************************************************************************************************************
  METHOD Redefine( nId, oWnd, oFont, aItems, nClrBorder, nClrBackTag, nClrPane, nClrPaneOver ) CLASS TTagEver
************************************************************************************************************************************

   local nClrText       := 0 // rgb(  0,102,227)
   local nClrTextOver   := 0 // rgb(255,102,  0)
   DEFAULT nClrPane     := CLR_WHITE
   DEFAULT nClrPaneOver := rgb(221,221,221)
   DEFAULT nClrBorder   := rgb(204,214,197)
   DEFAULT nClrBackTag  := CLR_WHITE //rgb(235,245,226)

   ::SetItems( aItems )

   ::aCoors       := {}

   ::oWnd         := oWnd
   ::nId          := nId
   // ::nLeft        := nLeft
   // ::nBottom      := nTop + nHeight
   // ::nRight       := nLeft + nWidth
   ::nId          := nId
   ::lCaptured    := .f.
   ::nClrPane     := nClrPane
   ::nClrText     := nClrText
   ::nClrPaneOver := nClrPaneOver
   ::nClrTextOver := nClrTextOver
   ::oFont        := oFont
   ::nOver        := -1
   ::nClrBorder   := nClrBorder
   ::nClrBackTag  := nClrBackTag
   ::lOverClose   := .f.
   ::nOption      := 1

   ::SetColor( nClrText, nClrPane )

   ::lVisible    := .t.

   ::Register()

   oWnd:DefControl( Self )


RETURN Self

***************************************************************************************************************
    METHOD GetItems() CLASS TTagEver
***************************************************************************************************************

   local aSelectedItems := {}

   if !empty( ::aItems )
      aeval( ::aItems, {|aItem| if( !aItem[ 2 ], aadd( aSelectedItems, aItem[ 1 ] ), ) } )
   end if 

RETURN aSelectedItems


***************************************************************************************************************
    METHOD SetItems( aItems ) CLASS TTagEver
***************************************************************************************************************

   ::aItems := {}

   if empty( aItems )
      RETURN nil
   end if

   if len(aItems) != 0
      aeval( aItems, {|aItem| aadd( ::aItems, { aItem, .f., {0,0,0,0} } ) } ) 
   endif

RETURN nil

***************************************************************************************************************
   METHOD AddItem( cText ) CLASS TTagEver
***************************************************************************************************************

  // local oItem
  // local nLen := len(::aItems)+1

   if ::aItems == nil
      ::aItems := {}
   endif

   AAdd( ::aItems, {cText,.f.,{0,0,0,0}} )

RETURN nil //oItem

***************************************************************************************************************
    METHOD Paint() CLASS TTagEver
***************************************************************************************************************
local aInfo := ::DispBegin()
local n
local nTop  := 3
local nT    := 0
local nL    := 0
local nLeft := 14
local nSep  := 11
local nH    := ::nHLine
local nLen
local nFont
local nW := 0
local hOldFont
local rc
local nMode := SetBkMode( ::hDC, 1 )
local nColor := SetTextColor(::hDC, ::nClrText )
local hBmp := 0
local nWBmp := 0
local nHBmp := 0
local nT0, nL0, nB0, nR0
local hPen, hOldPen
local hBrush, hOldBrush
local hBrush1, hOldBrush1
local lFirst := .t.

//local nBkColor := SetBkColor(::hDC, CLR_GREEN )

hBmp := LoadBitmap(GetResources(), "GC_DELETE_12" )

if hBmp != 0
   nWBmp := nBmpWidth( hBmp )
   nHBmp := nBmpHeight( hBmp )
endif

hPen        := CreatePen( PS_SOLID, 1, ::nClrBorder )
hOldPen     := SelectObject(::hDC, hPen )
   
hBrush      := CreateSolidBrush( ::nClrBackTag )

hBrush1     := CreateSolidBrush( ::nClrPaneOver )

FillSolidRect(::hDC, GetClientRect(::hWnd), ::nClrPane )

if !empty(::aItems)

   nLen := len( ::aItems )

   ::aCoors := array(nLen)
   for n := 1 to nLen
       ::aCoors[n] :={0,0,0,0}
   next

   sysrefresh()

   nL := nLeft

   for n := 1 to nLen

       if ::aItems[n,2] // oculto
          loop
       endif

       //if n == ::nOver
       SetTextColor(::hDC, nColor )
       nColor := SetTextColor(::hDC, if( n == ::nOver .or. n == ::nOption, ::nClrTextOver, ::nClrText) )
       //endif

       if !lFirst
          nL := nL + nW + 8
       endif

       lFirst := .f.

       nW := 5 + GetTextWidth(::hDC, ::aItems[n,1], ::oFont:hFont ) //+ if( nWBmp != 0 .and. ( n == ::nOver .or. n == ::nOption), 5 + nWBmp + 5, 0)

       if nL + nW + 5 + nWBmp + 5 > ::nWidth
          nTop += ( ::nHLine  ) +2
          nL := nLeft
       endif

       nW := 5 + GetTextWidth(::hDC, ::aItems[n,1], ::oFont:hFont ) + if( nWBmp != 0 .and. ( n == ::nOver .or. n == ::nOption), 5 + nWBmp + 5, 0)

       nT := nTop

       rc := { nT, nL, nT + nH, nL + nW }

       ::aCoors[n,1] := rc[1]
       ::aCoors[n,2] := rc[2]
       ::aCoors[n,3] := rc[3]
       ::aCoors[n,4] := rc[4]
       //FillSolidRect(::hDC, {nTop+::nHLine-::nMaxDescend,0,nTop+::nHLine-::nMaxDescend+1,::nWidth}, CLR_HBLUE )
       //wqout( rc )

       hOldBrush := SelectObject( ::hDC, if( n == ::nOver .or. n == ::nOption, hBrush1, hBrush ) )

       RoundRect( ::hDC, rc[2]-4, rc[1], rc[4], rc[3]-1, 6, 6 )

       hOldFont := SelectObject( ::hDC, ::oFont:hFont )

       DrawText(::hDC, ::aItems[n,1], {rc[1],rc[2],rc[3]-2,rc[4]}, 32+4 )

       SelectObject( ::hDC, hOldFont )

       if hBmp != 0 .and. ( n == ::nOver .or. n == ::nOption)

          nT0 := rc[1]+((rc[3]-rc[1])/2)-nHBmp/2
          nL0 := rc[4]-5-nWBmp
          nB0 := nT0 + nHBmp
          nR0 := nL0 + nWBmp
          DrawMasked( ::hDC, hBmp, nT0, nL0 )
          ::aItems[n,3] := {nT0,nL0,nB0,nR0}
       else
          ::aItems[n,3] := {0,0,0,0}
       endif

       if n == ::nOver
          SetTextColor(::hDC, nColor )
          nColor := SetTextColor(::hDC, ::nClrText )
       endif

       sysrefresh()

   next n

end if 

SetBkMode( ::hDC, nMode )
SetTextColor(::hDC, nColor )

if hBmp != 0
   DeleteObject( hBmp )
endif

SelectObject( ::hDC, hOldPen )
SelectObject( ::hDC, hOldBrush )

DeleteObject( hPen )
DeleteObject( hBrush )
DeleteObject( hBrush1 )

::DispEnd( aInfo )

RETURN 0

***************************************************************************************************************
    METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TTagEver
***************************************************************************************************************

RETURN 0

***************************************************************************************************************
    METHOD MouseMove  ( nRow, nCol, nFlags ) CLASS TTagEver
***************************************************************************************************************
local nOver := ::nOver
local n
local nLen := len(::aCoors)
local lFind := .f.


for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aCoors[n] )
       lFind := .t.
       ::nOver := n
       if nOver != n
          //::Refresh(.f.)
       endif
       exit
    endif
next

::lOverClose := ::nOver > 0 .and. PtInRect( nRow, nCol, ::aItems[::nOver,3] )

//::oWnd:cTitle := cValToChar(::lOverClose)+ " " + str(nRow)+str(nCol)+str(::aOverClose[1])+str(::aOverClose[2])+str(::aOverClose[3])+str(::aOverClose[4])


if lFind
   if ::lOverClose
      CursorHand()
   else
      CursorArrow()
   endif
   if ::oWnd:oMsgBar != nil
      if ::nOver > 0
         ::oWnd:oMsgBar:SetMsg( 'Nube de tags "' + ::aItems[::nOver,1] + '" ' + str(::aItems[::nOver,1]) )
      endif
   endif
else
   ::nOver := -1
   CursorArrow()
endif

if nOver != ::nOver
   ::Refresh(.f.)
endif


RETURN 0

***************************************************************************************************************
    METHOD LButtonUp  ( nRow, nCol, nFlags ) CLASS TTagEver
***************************************************************************************************************

if ::nOver > 0
   if ::lOverClose
      ::aItems[::nOver,2] := .t.
   else
      ::nOption := ::nOver
      if ::bAction != nil
         eval(::bAction, ::nOption, ::aItems[::nOption,1])
      endif
   endif
   ::Refresh()
endif

RETURN 0

***************************************************************************************************************
