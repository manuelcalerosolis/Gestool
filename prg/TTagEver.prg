#include "FiveWin.ch"

#define MARGIN_TOP                  2
#define MARGIN_LEFT                 2
#define MARGIN_ITEM                 5
#define MARGIN_NEXT                 8

//---------------------------------------------------------------------------//

CLASS TTagEver FROM TControl

   CLASSDATA lRegistered            AS LOGICAL

   DATA aItems                      AS ARRAY    INIT {} 

   DATA aCoors                      AS ARRAY    INIT {} 
   DATA aOvers                      AS ARRAY    INIT {} 

   DATA nHeightLine                 AS NUMERIC  INIT 22
   
   DATA nOver                       AS NUMERIC  INIT -1
   DATA nOption                     AS NUMERIC  INIT -1

   DATA nClrTextOver                AS NUMERIC  INIT 0
   DATA nClrPaneOver                AS NUMERIC  INIT Rgb( 221, 221, 221 )
   DATA nClrBorder                  AS NUMERIC  INIT Rgb( 204, 214, 197 )
   DATA nClrBackTag                 AS NUMERIC  INIT Rgb( 235, 245, 226 )       
   
   DATA lOverClose                  AS LOGIC    INIT .f.
   
   DATA bAction

   DATA hBmp                        AS NUMERIC  INIT 0
   DATA nWidthBmp                   AS NUMERIC  INIT 0
   DATA nHeightBmp                  AS NUMERIC  INIT 0
   
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, nClrBorder, nClrBackTag, aItems, nClrPane, nClrPaneOver ) CONSTRUCTOR
   METHOD Redefine( nId, oWnd, oFont, aItems ) CONSTRUCTOR
   METHOD End()

   METHOD Default()

   METHOD setItems( aItems )
   METHOD getItems()                INLINE ( ::aItems )
   METHOD addItem( cText )

   METHOD Paint()
   METHOD Display()                 INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint(), 0 )

   METHOD DrawText( cItem, rc )
   METHOD DrawBitmap( rc )

   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD MouseMove( nRow, nCol, nFlags )
   METHOD LButtonUp( nRow, nCol, nFlags )

   METHOD EraseBkGnd( hDC )         INLINE ( 1 )

   METHOD loadBitmap()
   METHOD deleteBitmap()            INLINE ( iif( ::hBmp != 0, deleteObject( ::hBmp ), ) )

   METHOD setOverClose()                  
   METHOD getOverClose()            INLINE ( ::lOverClose )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, nClrBorder, nClrBackTag, aItems, nClrPane, nClrPaneOver ) CLASS TTagEver

   local nClrText       := rgb( 0, 102, 227 )
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
   ::nOption      := 1

   ::Default()

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   ::Create()

RETURN Self

//---------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, oFont, aItems, nClrBorder, nClrBackTag, nClrPane, nClrPaneOver ) CLASS TTagEver


   local nClrText       := 0 // rgb(  0,102,227)
   local nClrTextOver   := 0 // rgb(255,102,  0)
   DEFAULT nClrPane     := CLR_WHITE
   DEFAULT nClrPaneOver := rgb(221,221,221)
   DEFAULT nClrBorder   := rgb(204,214,197)
   DEFAULT nClrBackTag  := CLR_WHITE //rgb(235,245,226)

   ::SetItems( aItems )

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
   ::nOption      := 1

   ::Default()

   ::Register()

   oWnd:DefControl( Self )

RETURN Self

//---------------------------------------------------------------------------//

METHOD End()

   ::deleteBitmap()

RETURN Self

//---------------------------------------------------------------------------//

METHOD Default()

   ::setColor( ::nClrText, ::nClrPane )

   ::loadBitmap()

   ::lVisible    := .t.

RETURN Self

//---------------------------------------------------------------------------//

METHOD loadBitmap()

   ::hBmp         := loadBitmap( getResources(), "GC_DELETE_12" )

   if ::hBmp == 0
      RETURN ( self )
   endif
   
   ::nWidthBmp    := nBmpWidth( ::hBmp )
   ::nHeightBmp   := nBmpHeight( ::hBmp )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD SetItems( aItems ) CLASS TTagEver

   ::aItems    := {}

   if empty( aItems ) 
      RETURN ( self )
   end if

   aeval( aItems, {|aItem| aadd( ::aItems, aItem ) } ) 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddItem( cText ) CLASS TTagEver

   aadd( ::aItems, cText )

RETURN nil //oItem

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TTagEver

   local rc
   local hPen
   local nTop        := MARGIN_TOP
   local cItem
   local nLeft       := MARGIN_LEFT
   local aInfo       
   local hBrush
   local hOldPen
   local hOldFont
   local nOldMode       
   local nTopItem    := 0
   local nOldColor      
   local hOldBrush
   local nLeftItem   := 0
   local nWidthItem  := 0

   aInfo             := ::DispBegin()

   nOldMode          := SetBkMode( ::hDC, 1 )
   nOldColor         := SetTextColor( ::hDC, ::nClrText )

   hPen              := CreatePen( PS_SOLID, 1, ::nClrBorder )
   hOldPen           := SelectObject( ::hDC, hPen )
      
   hBrush            := CreateSolidBrush( ::nClrPaneOver )
   hOldBrush         := SelectObject( ::hDC, hBrush )
   
   hOldFont          := SelectObject( ::hDC, ::oFont:hFont )

   fillSolidRect( ::hDC, GetClientRect( ::hWnd ), ::nClrPane )

   if !empty( ::aItems )

      ::aCoors          := {} 
      ::aOvers          := {}

      sysrefresh()

      nLeftItem         := MARGIN_LEFT

      for each cItem in ::aItems

         nLeftItem      := nLeftItem + nWidthItem + MARGIN_NEXT

         nWidthItem     := MARGIN_ITEM + GetTextWidth( ::hDC, cItem, ::oFont:hFont ) 

         if nLeftItem + nWidthItem + MARGIN_ITEM + ::nWidthBmp + MARGIN_ITEM > ::nWidth
            nTop        += ( ::nHeightLine  ) + MARGIN_TOP
            nLeftItem   := MARGIN_LEFT + MARGIN_NEXT
         endif

         if ::nWidthBmp != 0
            nWidthItem  += MARGIN_ITEM + ::nWidthBmp + MARGIN_ITEM
         endif

         nTopItem       := nTop

         rc             := { nTopItem, nLeftItem, nTopItem + ::nHeightLine, nLeftItem + nWidthItem }

         ::DrawText( cItem, rc )

         ::DrawBitmap( rc )

         sysrefresh()

      next 

   end if 

   SetBkMode( ::hDC, nOldMode )
   SetTextColor( ::hDC, nOldColor )

   SelectObject( ::hDC, hOldPen )
   SelectObject( ::hDC, hOldBrush )
   SelectObject( ::hDC, hOldFont )

   DeleteObject( hPen )
   DeleteObject( hBrush )

   ::DispEnd( aInfo )

RETURN 0

//---------------------------------------------------------------------------//

METHOD DrawText( cItem, rc )

   RoundRect( ::hDC, rc[2] - 4, rc[1], rc[4], rc[3] - 1, 6, 6 )

   DrawText( ::hDC, cItem, { rc[1], rc[2], rc[3] - 2, rc[4] }, 32 + 4 )

   aadd( ::aCoors, { rc[1], rc[2], rc[3], rc[4] } )

RETURN 0

//---------------------------------------------------------------------------//

METHOD DrawBitmap( rc )

   local nTopBitmap
   local nLeftBitmap

   if ::hBmp == 0
      aadd( ::aOvers, { 0, 0, 0, 0 } )   
      RETURN ( self )
   end if  
   
   nTopBitmap        := rc[1] + ( ( rc[3] - rc[1] ) / 2 ) - ( ::nHeightBmp / 2 )
   nLeftBitmap       := rc[4] - MARGIN_ITEM - ::nWidthBmp

   drawMasked( ::hDC, ::hBmp, nTopBitmap, nLeftBitmap )

   aadd( ::aOvers, { nTopBitmap, nLeftBitmap, nTopBitmap + ::nHeightBmp, nLeftBitmap + ::nWidthBmp } )   
   
RETURN ( self )

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
      if PtInRect( nRow, nCol, ::aCoors[ n ] )
         lFind    := .t.
         ::nOver  := n
         exit
      endif
   next

   ::setOverClose( nRow, nCol )

   if lFind

      if ::getOverClose()
         CursorHand()
      else
         CursorArrow()
      endif
   
   else
   
      ::nOver := -1
   
      CursorArrow()

   endif

   if nOver != ::nOver
      ::Refresh( .f. )
   endif

RETURN 0

//---------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TTagEver

   if ::nOver == 0
      RETURN 0
   end if 

   if ::getOverClose()

      adel( ::aItems, ::nOver, .t. )
   
      ::nOver     := 0

   else
      
      ::nOption   := ::nOver

      if hb_isblock( ::bAction )
         eval( ::bAction, Self )
      endif

   endif

   ::Refresh()

RETURN 0

//---------------------------------------------------------------------------//

METHOD setOverClose( nRow, nCol )

   ::lOverClose      := .f.

   if ::nOver > 0 .and. ::nOver <= len( ::aOvers )
      ::lOverClose   := ptInRect( nRow, nCol, ::aOvers[ ::nOver ] )
   end if 

RETURN ( ::lOverClose )

//---------------------------------------------------------------------------//