#include "FiveWin.ch"

#define MARGIN_TOP                  2
#define MARGIN_LEFT                 2
#define MARGIN_ITEM                 5

//---------------------------------------------------------------------------//

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
   METHOD DrawBitmap( rc, n )

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

   aeval( aItems, {|aItem| aadd( ::aItems, { aItem, { 0, 0, 0, 0 } } ) } ) 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddItem( cText ) CLASS TTagEver

   aadd( ::aItems, { cText, .f., { 0, 0, 0, 0 } } )

RETURN nil //oItem

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TTagEver

   local n
   local nLen
   local nTop        := MARGIN_TOP
   local nLeft       := MARGIN_LEFT
   local aInfo       := ::DispBegin()
   local nTopItem    := 0
   local nLeftItem   := 0
   local nWidthItem  := 0
   local rc
   local nMode       := SetBkMode( ::hDC, 1 )
   local nColor      := SetTextColor(::hDC, ::nClrText )
   local hPen
   local hOldPen
   local hOldFont
   local hOldBrush
   local hBrushOver

   hPen           := CreatePen( PS_SOLID, 1, ::nClrBorder )
   hOldPen        := SelectObject( ::hDC, hPen )
      
   hBrushOver     := CreateSolidBrush( ::nClrPaneOver )

   fillSolidRect( ::hDC, GetClientRect( ::hWnd ), ::nClrPane )

   if !empty( ::aItems )

      nLen              := len( ::aItems )

      ::aCoors          := array( nLen )
      for n := 1 to nLen
         ::aCoors[ n ]  := {0,0,0,0}
      next

      sysrefresh()

      nLeftItem                := MARGIN_LEFT

      for n := 1 to nLen

         setTextColor( ::hDC, nColor )
          
         nColor         := SetTextColor( ::hDC, ::nClrTextOver ) 

         nLeftItem      := nLeftItem + nWidthItem + 8

         nWidthItem     := MARGIN_ITEM + GetTextWidth( ::hDC, ::aItems[ n, 1 ], ::oFont:hFont ) 

         if nLeftItem + nWidthItem + MARGIN_ITEM + ::nWidthBmp + MARGIN_ITEM > ::nWidth
            nTop        += ( ::nHeightLine  ) + MARGIN_TOP
            nLeftItem   := MARGIN_LEFT + 8
         endif

         nWidthItem     := MARGIN_ITEM + GetTextWidth( ::hDC, ::aItems[n,1], ::oFont:hFont ) + if( ::nWidthBmp != 0, 5 + ::nWidthBmp + 5, 0)

         nTopItem       := nTop

         rc             := { nTopItem, nLeftItem, nTopItem + ::nHeightLine, nLeftItem + nWidthItem }

         ::aCoors[n,1]  := rc[1]
         ::aCoors[n,2]  := rc[2]
         ::aCoors[n,3]  := rc[3]
         ::aCoors[n,4]  := rc[4]

         hOldBrush      := SelectObject( ::hDC, hBrushOver )

         RoundRect( ::hDC, rc[2] - 4, rc[1], rc[4], rc[3] - 1, 6, 6 )

         hOldFont       := SelectObject( ::hDC, ::oFont:hFont )

         DrawText( ::hDC, ::aItems[n,1], { rc[1], rc[2], rc[3] - 2, rc[4] }, 32 + 4 )

         SelectObject( ::hDC, hOldFont )

         ::DrawBitmap( rc, n )
         /*
         if ::hBmp != 0 
             nT0 := rc[1] + ( ( rc[3] - rc[1] ) / 2 ) - ::nHeightBmp / 2
             nL0 := rc[4] - MARGIN_ITEM - ::nWidthBmp
             nB0 := nT0 + ::nHeightBmp
             nR0 := nL0 + ::nWidthBmp
             DrawMasked( ::hDC, ::hBmp, nT0, nL0 )
             ::aItems[n,2] := {nT0,nL0,nB0,nR0}
         else
            ::aItems[n,2] := {0,0,0,0}
         endif
         */
         sysrefresh()

      next n

   end if 

   SetBkMode( ::hDC, nMode )
   SetTextColor(::hDC, nColor )

   SelectObject( ::hDC, hOldPen )
   SelectObject( ::hDC, hOldBrush )

   DeleteObject( hPen )
   DeleteObject( hBrushOver )

   ::DispEnd( aInfo )

RETURN 0

//---------------------------------------------------------------------------//

METHOD DrawBitmap( rc, n )

   local nTopBitmap
   local nLeftBitmap

   if ::hBmp = 0
      ::aItems[ n, 2 ]  := { 0, 0, 0, 0}   
      RETURN ( self )
   end if  
   
   nTopBitmap           := rc[1] + ( ( rc[3] - rc[1] ) / 2 ) - ::nHeightBmp / 2
   nLeftBitmap          := rc[4] - MARGIN_ITEM - ::nWidthBmp

   drawMasked( ::hDC, ::hBmp, nTopBitmap, nLeftBitmap )

   ::aItems[ n, 2 ]     := { nTopBitmap, nLeftBitmap, nTopBitmap + ::nHeightBmp, nLeftBitmap + ::nWidthBmp }
   
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
      if PtInRect( nRow, nCol, ::aCoors[n] )
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

   if ::nOver > 0 .and. ::nOver <= len( ::aItems )
      ::lOverClose   := ptInRect( nRow, nCol, ::aItems[ ::nOver, 2 ] )
   end if 

RETURN ( ::lOverClose )

//---------------------------------------------------------------------------//