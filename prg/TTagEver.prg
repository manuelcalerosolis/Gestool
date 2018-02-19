#include "FiveWin.ch"

************************************************************************************************************************************

CLASS TTagEver FROM TControl

   CLASSDATA lRegistered            AS LOGICAL

   DATA aItems                      AS ARRAY    INIT {} 
   DATA aCoors                      AS ARRAY    INIT {} 

   DATA nHeightLine                 AS NUMERIC  INIT 22
   
   DATA nOver                       AS NUMERIC  INIT -1
   DATA nOption                     AS NUMERIC  INIT -1

   DATA nClrTextOver                AS NUMERIC  INIT 0
   DATA nClrPaneOver                AS NUMERIC  INIT Rgb( 221, 221, 221 )
   DATA nClrBorder                  AS NUMERIC  INIT Rgb( 204, 214, 197 )
   DATA nClrBackTag                 AS NUMERIC  INIT Rgb( 235, 245, 226 )       
   
   DATA lOverClose                  AS LOGIC    INIT .f.
   
   DATA bAction
   
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, nClrBorder, nClrBackTag, aItems, nClrPane, nClrPaneOver ) CONSTRUCTOR
   METHOD Redefine( nId, oWnd, oFont, aItems ) CONSTRUCTOR

   METHOD SetItems( aItems )
   METHOD AddItem( cText )

   METHOD Paint()
   METHOD Display()                        INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint(), 0 )
   METHOD GetItems()

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD MouseMove  ( nRow, nCol, nFlags )
   METHOD LButtonUp  ( nRow, nCol, nFlags )

   METHOD EraseBkGnd( hDC )                INLINE ( 1 )

   METHOD HideItems()                      INLINE ( aeval(::aItems, {|aItem| aItem[2]  := .t. } ), ::Refresh() )

   METHOD isOver( n )                      INLINE ( .t. ) // ::isOver() )

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

//---------------------------------------------------------------------------//

METHOD GetItems() CLASS TTagEver

   local aSelectedItems := {}

   if empty( ::aItems )
      RETURN aSelectedItems
   end if 
   
   aeval( ::aItems, {|aItem| if( !aItem[ 2 ], aadd( aSelectedItems, aItem[ 1 ] ), ) } )

RETURN aSelectedItems

//---------------------------------------------------------------------------//

METHOD SetItems( aItems ) CLASS TTagEver

   ::aItems    := {}

   if empty( aItems ) .or. len( aItems ) == 0
      RETURN nil
   end if

   aeval( aItems, {|aItem| aadd( ::aItems, { aItem, .f., {0,0,0,0} } ) } ) 

RETURN nil

//---------------------------------------------------------------------------//

METHOD AddItem( cText ) CLASS TTagEver

   aadd( ::aItems, { cText, .f., { 0, 0, 0, 0 } } )

RETURN nil //oItem

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TTagEver

local aInfo := ::DispBegin()
local n
local nTop  := 2
local nT    := 0
local nL    := 0
local nLeft := 2
local nSep  := 11
local nH    := ::nHeightLine
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
local lFirst := .f.

//local nBkColor := SetBkColor(::hDC, CLR_GREEN )

hBmp := LoadBitmap( GetResources(), "GC_DELETE_12" )

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
       nColor := SetTextColor(::hDC, if( ::isOver(), ::nClrTextOver, ::nClrText) )
       //endif

       if !lFirst
          nL := nL + nW + 8
       endif

       lFirst := .f.

       nW := 5 + GetTextWidth(::hDC, ::aItems[n,1], ::oFont:hFont ) //+ if( nWBmp != 0 .and. ( ::isOver()), 5 + nWBmp + 5, 0)

       if nL + nW + 5 + nWBmp + 5 > ::nWidth
          nTop += ( ::nHeightLine  ) + 2
          nL := nLeft + 8
       endif

       nW := 5 + GetTextWidth(::hDC, ::aItems[n,1], ::oFont:hFont ) + if( nWBmp != 0 .and. ( ::isOver()), 5 + nWBmp + 5, 0)

       nT := nTop

       rc := { nT, nL, nT + nH, nL + nW }

       ::aCoors[n,1] := rc[1]
       ::aCoors[n,2] := rc[2]
       ::aCoors[n,3] := rc[3]
       ::aCoors[n,4] := rc[4]

       hOldBrush := SelectObject( ::hDC, hBrush1 )

       RoundRect( ::hDC, rc[2]-4, rc[1], rc[4], rc[3]-1, 6, 6 )

       hOldFont := SelectObject( ::hDC, ::oFont:hFont )

       DrawText(::hDC, ::aItems[n,1], {rc[1],rc[2],rc[3]-2,rc[4]}, 32+4 )

       SelectObject( ::hDC, hOldFont )

       if hBmp != 0 

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

//---------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TTagEver

RETURN 0

//---------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nFlags ) CLASS TTagEver

   local n
   local nOver := ::nOver
   local lFind := .f.
   local nLen  := len( ::aCoors )

   for n := 1 to nLen
      if PtInRect( nRow, nCol, ::aCoors[n] )
         lFind    := .t.
         ::nOver  := n
         exit
      endif
   next

   ::lOverClose := ::nOver > 0 .and. PtInRect( nRow, nCol, ::aItems[ ::nOver, 3 ] )

   if lFind

      if ::lOverClose
         CursorHand()
      else
         CursorArrow()
      endif
   
   else
   
      ::nOver := -1
   
      CursorArrow()

   endif

   if nOver != ::nOver
      ::Refresh(.f.)
   endif

RETURN 0

//---------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TTagEver

   if ::nOver > 0
      if ::lOverClose
         ::aItems[ ::nOver, 2 ] := .t.
      else
         ::nOption := ::nOver
         if ::bAction != nil
            eval( ::bAction, ::nOption, ::aItems[ ::nOption, 1 ])
         endif
      endif
      ::Refresh()
   endif

RETURN 0

***************************************************************************************************************
