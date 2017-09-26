******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
//  CopyRight de CanaFive Abril 2012. Francisco García Fernández. pacogarcia@gmail.com
//  Revisar fichero adjunto de licencia de uso.
//
//  Nota del Autor:
//  ¡En este mundo todo no vale!
//
//  Este control que tienes hoy en tus manos es el fruto de mi ingenio y de mi ilusión. Como verás te entrego el código fuente
//  del programa. Sólo tienes que comparar el precio de cualquier otro componente en internet para ver que no merece la pena piratear
//  este software. Si lo compras tendrás siempre mi ayuda además de mi gratitud.
//  Creo que es un control de calidad que está testeado. Si alguna duda te surge, ya sabes donde está mi puerta. Escribe me y lo
//  miramos.
//  Por favor, no distribuyas este código y mantenlo en buen recaudo. Tu también programas y sabes lo que te cuesta cada línea de
//  código. Tampoco a tí te gusta que te pirateen tu trabajo.
//  Un fuerte abrazo.
//
//  Paco García
//

// Testeado con FWH 1211. No necesita de librerías de apoyo.

#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000

#include "fivewin.ch"

CLASS C5ImageView FROM TControl

    CLASSDATA lRegistered AS LOGICAL

    DATA aItems
    DATA aCoors
    DATA aGrid

    DATA nOption
    DATA nFirstItem

    DATA nClrPaneTile
    DATA nClrPaneSel
    DATA nClrTextSel

    DATA nRows HIDDEN
    DATA nCols HIDDEN

    DATA nxWItem
    DATA nxHItem
    DATA nAlignText

    DATA bChanged
    DATA bAction

    DATA lShowOption
    DATA bOwnerDraw

    DATA lxVScroll
    DATA lxHScroll
    DATA lxBorder

    DATA lTitle
    DATA cTitle
    DATA lBoxSelection
    DATA aTextMargin
    DATA nHTitle
    DATA lAdjust

    DATA nSideTitle // 0 - Arriba, 1 - centro, 2 - abajo  por defecto 2

    DATA nVSep
    DATA nHSep

    DATA cAlphaBmp
    DATA nAlphaLevel

    METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR

    METHOD Redefine( nID, oWnd ) CONSTRUCTOR

    METHOD Display() INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
    METHOD Default()
    METHOD Initiate( hDlg )
    METHOD Paint()
    METHOD EraseBkGnd( hDC )   INLINE 1
    METHOD Resize( nType, nWidth, nHeight )
    METHOD KeyDown( nKey, nFlags )
    METHOD GoHome()
    METHOD GoEnd()
    METHOD GoUp()
    METHOD GoDown()
    METHOD GoLeft()
    METHOD GoRight()
    METHOD PageUp()
    METHOD PageDown()
    METHOD Page()
    METHOD LButtonDown( nRow, nCol )
    METHOD LButtonUp( nRow, nCol )
    METHOD MouseWheel( nKey, nDelta, nXPos, nYPos )
    METHOD GetOption( nRow, nCol )
    METHOD GetDlgCode( nLastKey )
    METHOD AddItem( oItem )
    METHOD VScrAdjust()
    METHOD nLineCount()
    METHOD nLineVisib() INLINE ::nRows
    METHOD nCurLine()   INLINE if( ::nOption != 0, int( ::nOption / ::nCols ), 0 )
    METHOD SetItems( aItems )
    METHOD GetSelection() INLINE if(::nOption != 0, ::aItems[::nOption], nil)
    METHOD nFactor( hBmp, rc )
    METHOD lVScroll( lNewValue ) SETGET
    METHOD lBorder ( lNewValue ) SETGET
    METHOD nHItem  ( nNewValue ) SETGET
    METHOD nWItem  ( nNewValue ) SETGET
    METHOD Goto    ( nLine )

ENDCLASS

*****************************************************************************************************************************************************************************************************
  METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS C5ImageView
*****************************************************************************************************************************************************************************************************

  ::nTop          := nTop
  ::nLeft         := nLeft
  ::nBottom       := nTop + nHeight
  ::nRight        := nLeft + nWidth
  ::oWnd          := oWnd

  ::aItems        := {}
  ::aCoors        := {}
  ::aGrid         := {}
  ::nFirstItem    := 1
  ::nOption       := 1
  ::nClrPane      := CLR_WHITE
  ::nClrText      := CLR_BLACK
  ::nClrTextSel   := CLR_WHITE
  ::nClrPaneSel   := RGB(105,105,105)
  ::nxWItem       := 120
  ::nxHItem       := 150
  ::lShowOption   := .T.
  ::lTitle        := .t.
  ::aTextMargin   := {3,3,3,3}
  ::lAdjust       := .t.
  ::nHTitle       := 30
  ::lxVScroll     := .T.
  ::lxHScroll     := .F.
  ::lxBorder      := .f.
  ::nAlignText    := nOr( DT_BOTTOM, DT_CENTER, DT_SINGLELINE ) // "\bcc582\include\winuser.h"
  ::lBoxSelection := .f.
  ::nSideTitle    := 2

  ::nVSep         := 0
  ::nHSep         := 0

  ::cAlphaBmp     := ""
  ::nAlphaLevel   := 150

  ::nStyle        := nOr( WS_CHILD, WS_TABSTOP, WS_VISIBLE, WS_VSCROLL )
  ::nId           := ::GetNewId()

  ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

  if ! Empty( oWnd:hWnd )
     ::Create()
     ::Default()
     oWnd:AddControl( Self )
  else
     oWnd:DefControl( Self )
  endif

return self

********************************************************************************************************************************************************************************
  METHOD ReDefine( nID, oWnd ) CLASS C5ImageView
********************************************************************************************************************************************************************************

  ::oWnd          := oWnd
  ::nId           := nID

  ::aItems        := {}
  ::aCoors        := {}
  ::aGrid         := {}
  ::nFirstItem    := 1
  ::nOption       := 1
  ::nClrPane      := CLR_WHITE
  ::nClrText      := CLR_BLACK
  ::nClrTextSel   := CLR_WHITE
  ::nClrPaneSel   := RGB(105,105,105)
  ::nxWItem       := 120
  ::nxHItem       := 150
  ::lShowOption   := .T.
  ::lTitle        := .t.
  ::aTextMargin   := {3,3,3,3}
  ::lAdjust       := .t.
  ::nHTitle       := 30
  ::lxVScroll     := .T.
  ::lxHScroll     := .F.
  ::lxBorder      := .f.
  ::nAlignText    := nOr( DT_TOP, DT_CENTER, DT_SINGLELINE )  // "\bcc582\include\winuser.h"
  ::lBoxSelection := .f.
  ::nSideTitle    := 2

  ::nVSep         := 0
  ::nHSep         := 0

  ::cAlphaBmp     := ""
  ::nAlphaLevel   := 150

  ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

  if oWnd != nil
     oWnd:DefControl( Self )
  endif

return Self

********************************************************************************************************************
  METHOD Default() CLASS C5ImageView
********************************************************************************************************************

  if !lAnd( GetWindowLong( ::hWnd, -16 ), WS_VSCROLL ) //GWL_STYLE
     SumarEstilo(::hWnd,WS_VSCROLL)
     ShowScrollBar(::hWnd, 1, ::lVScroll )
  endif

  /*
  DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self ;
     RANGE 0, 1 ;
     ON UP ::GoUp() ;
     ON DOWN ::GoDown() ;
     ON PAGEUP ::PageUp() ;
     ON PAGEDOWN ::PageDown() ;
     ON THUMBPOS ::Page( nPos )

  ::oVScroll:bTrack := { |nPos| ::Page( nPos ) }
  */

  ::Resize()

return 0

********************************************************************************************************************
  METHOD Initiate( hDlg )  CLASS C5ImageView
********************************************************************************************************************

   local uValue

   uValue = ::Super:Initiate( hDlg )
   ::Default()


return uValue

********************************************************************************************************************
    METHOD lVScroll( lNewValue ) CLASS C5ImageView
********************************************************************************************************************

if pcount() > 0

   if lNewValue
      if !lAnd( GetWindowLong( ::hWnd, -16 ), WS_VSCROLL )
         SumarEstilo(::hWnd, WS_VSCROLL)
      endif
      ::lxVScroll := .f.
      ShowScrollBar(::hWnd, 1, .f. )
   else
      ::lxVScroll := .f.
      ShowScrollBar(::hWnd, 1, .f. )
   endif
   ::Resize()
endif

return ::lxVScroll



********************************************************************************************************************
    METHOD lBorder( lNewValue ) CLASS C5ImageView
********************************************************************************************************************

if pcount() > 0
   if lNewValue
      ::lxBorder := .t.
      SumarEstilo(::hWnd, WS_BORDER)
   else
      ::lxBorder := .f.
      QuitarEstilo(::hWnd, WS_BORDER)
   endif
   ::Resize()
endif

return ::lxBorder


********************************************************************************************************************
    METHOD nHItem( nNewValue ) CLASS C5ImageView
********************************************************************************************************************

if pcount() > 0
   ::nxHItem := nNewValue
   ::Resize()
endif

return ::nxHItem

********************************************************************************************************************
    METHOD nWItem( nNewValue, lResize ) CLASS C5ImageView
********************************************************************************************************************

DEFAULT lResize   := .t.

if pcount() > 0
   ::nxWItem      := nNewValue
   if lResize
      ::Resize()
   endif 
endif

return ::nxWItem

********************************************************************************************************************
    METHOD SetItems( aItems ) CLASS C5ImageView
********************************************************************************************************************

if empty(aItems)
   return 0
endif

::aItems    := {}

if valtype(aItems[1]) == "A"
   aeval( aItems, {|a| ::AddItem( a[1], if(len(a) >= 2,a[2],""), if(len(a) == 3,a[3],"") ) } )
else
   aeval( aItems, {|oItem| ::AddItem( oItem ) } )
endif

::nFirstItem := 1
::nOption    := 1
::VScrAdjust()
::Refresh()

return nil

********************************************************************************************************************
  METHOD AddItem( p1, p2, p3, p4 ) CLASS C5ImageView
********************************************************************************************************************

if valtype( p1 ) == "C"
   p1 := C5ImageViewItem():New( p1, p2, p3, p4 )
endif

aadd(::aItems, p1 )

::Resize()

return p1

********************************************************************************************************************
  METHOD GetDlgCode( nLastKey ) CLASS C5ImageView
********************************************************************************************************************

   if .not. ::oWnd:lValidating
      if nLastKey == VK_RETURN .or. nLastKey == VK_TAB
         ::oWnd:nLastKey = nLastKey
      endif
   endif

return DLGC_WANTALLKEYS

********************************************************************************************************************
  METHOD Paint() CLASS C5ImageView
********************************************************************************************************************
local aInfo
local hBmp
local hBmp2
local hOldFont
local lDraw
local n
local nClrPane
local nColor
local nCount
local nFactor
local nHImage
local nHeight
local nLeft
local nLen
local nMode
local nTop
local nWImage
local nWidth
local oItem
local rc
local rc2
local cText

local hBmpAlpha
local hBmpAlpha2

aInfo    := ::DispBegin()
nLen     := len(::aItems)
nCount   := 1

::aGrid  := aFill( Array( ::nRows * ::nCols ), 0 )

hOldFont := SelectObject(::hDC, if(::oFont == nil, GetStockObject( 17 ), ::oFont:hFont ))  // DEFAULT_GUI_FONT
nMode    := SetBkMode(::hDC, 1 )                   // Transparente
nColor   := SetTextColor(::hDC, ::nClrText )

FillSolidRect( ::hDC, GetClientRect( ::hWnd ), ::nClrPane )

if nLen > 0

   if !Empty( ::cAlphaBmp )

      if At( ".", ::cAlphaBmp ) != 0
         hBmpAlpha   := FILoadImg( AllTrim( ::cAlphaBmp ) )
      else
         hBmpAlpha   := PalBmpLoad( ::cAlphaBmp )[1] //Bmp(GetResources(), oItem:cImage )
      endif

   endif

   // no se pinta si nLen == 0

   for n := ::nFirstItem to nLen

       lDraw               := .t.

       ::aGrid[ nCount ]   := n

       if ::bOwnerDraw != nil       // si somos nosotros los que pintamos y devolvemos .f. no se deja pintar el resto
          lDraw            := Eval( ::bOwnerDraw, self, n )
       endif

       if lDraw

          oItem            := ::aItems[ n ]

          rc               := { ::aCoors[ nCount, 1 ], ::aCoors[ nCount, 2 ], ::aCoors[ nCount, 3 ], ::aCoors[ nCount, 4 ] }

          rc[ 1 ]          += ::nVSep / 2
          rc[ 2 ]          += ::nHSep / 2

          rc[ 3 ]          -= ::nVSep / 2
          rc[ 4 ]          -= ::nHSep / 2

          nClrPane := nil

          if oItem:nClrPane != nil
             nClrPane      := oItem:nClrPane
          else
             if ::nClrPaneTile != nil
                nClrPane   := ::nClrPaneTile
             endif
          endif

          if nClrPane != nil
            if !::lBoxSelection
               FillSolidRect( ::hDC, rc, nClrPane )
            endif
          endif

          /*
          Pintamos un box------------------------------------------------------
          */

          rc2           := { rc[ 1 ], rc[ 2 ], rc[ 3 ], rc[ 4 ] }

          if ::lTitle
             rc2[ 3 ]   -= ::nHTitle
          endif

          if !Empty( oItem:cImage )

             if At( ".", oItem:cImage ) != 0
                hBmp    := FILoadImg( AllTrim( oItem:cImage ) )
             else
                hBmp    := PalBmpLoad( oItem:cImage )[1] //Bmp(GetResources(), oItem:cImage )
             endif

          else

             hBmp       := 0

          end if

          if hBmp != 0

             nHImage    := nBmpHeight( hBmp )
             nWImage    := nBmpWidth ( hBmp )

             // redimensionamos rc2 en función de ::lAdjust

             if ::lAdjust

                nFactor    := ::nFactor( hBmp, rc2 )

                nHeight    := min( nHImage  * nFactor, ( rc2[ 3 ] - rc2[ 1 ] ) )
                nWidth     := min( nWImage  * nFactor, ( rc2[ 4 ] - rc2[ 2 ] ) )

                nTop       := rc2[ 1 ] + max( ( rc2[ 3 ] - rc2[ 1 ] ) / 2 - ( nHeight / 2 ), 0 )
                nLeft      := rc2[ 2 ] + max( ( rc2[ 4 ] - rc2[ 2 ] ) / 2 - ( nWidth  / 2 ), 0 )

                rc2        := { nTop, nLeft, nTop + nHeight, nLeft + nWidth }

             else

                nTop       := rc2[ 1 ] + max( ( rc2[ 3 ] - rc2[ 1 ] ) / 2 - ( nHImage / 2 ), 0 ) + 1
                nLeft      := rc2[ 2 ] + max( ( rc2[ 4 ] - rc2[ 2 ] ) / 2 - ( nWImage / 2 ), 0 ) + 1

                nHeight    := nHImage
                nWidth     := nWImage

             endif

             if HasAlpha( hBmp )

                if ::lAdjust
                   hBmp2   := Resizebmp( hBmp, rc2[ 4 ] - rc2[ 2 ], rc2[ 3 ] - rc2[ 1 ] )
                   DeleteObject( hBmp ) //??
                   hBmp    := hBmp2
                endif

                ABPaint( ::hDC, nLeft, nTop, hBmp, 255 )

             else

                DrawBitmapEx( ::hDC, hBmp, nTop, nLeft, nWidth, nHeight, 13369376 ) //SRCCOPY

             endif

             DeleteObject( hBmp )

          endif

          if ( n == ::nOption ) .and. ::lShowOption .and. ::lBoxSelection
            Box( ::hDC, rc, nClrPane )
          endif

          cText      := oItem:cText

          if Empty( cText ) .and. !empty( oItem:cImage )
            cText    := cFileName( oItem:cImage )
          endif

          if !Empty( cText ) // ::lTitle

             rc      := {  ::aCoors[ nCount, 1 ] + ::aTextMargin[ 1 ],;
                           ::aCoors[ nCount, 2 ] + ::aTextMargin[ 2 ],;
                           ::aCoors[ nCount, 3 ] - ::aTextMargin[ 3 ],;
                           ::aCoors[ nCount, 4 ] - ::aTextMargin[ 4 ]}

             if ::nSideTitle == 1
                rc[3] := rc[1] + ::nHTitle
             elseif ::nSideTitle == 2
                rc[1] := rc[3] - ::nHTitle
             endif

             SetTextColor( ::hDC, nColor )
             nColor  := SetTextColor(::hDC, ::nClrTextSel )

             // Pintamos sobre el alpha----------------------------------------

             if !Empty( hBmpAlpha ) .and. HasAlpha( hBmpAlpha )

                hBmpAlpha2 := Resizebmp( hBmpAlpha, rc[ 4 ] - rc[ 2 ], rc[ 3 ] - rc[ 1 ] )
                DeleteObject( hBmpAlpha )
                hBmpAlpha  := hBmpAlpha2

                ABPaint( ::hDC, rc[ 2 ], rc[ 1 ], hBmpAlpha, ::nAlphaLevel )

             endif

             // Pintamos el texto----------------------------------------------

             DrawText( ::hDC, cText, rc, ::nAlignText ) //c,vc,sl

             SetTextColor( ::hDC, nColor )
             nColor  := SetTextColor(::hDC, ::nClrText )

          endif

       endif

       nCount++

       if nCount > len(::aCoors)
          exit
       endif

   next

   if !Empty( hBmpAlpha )
      DeleteObject( hBmpAlpha )
   end if

endif

SetTextColor(::hDC, nColor )
SetBkMode(::hDC, nMode )
SelectObject(::hDC, hOldFont )

::DispEnd( aInfo )

return 0

******************************************************************************************************************
  METHOD Resize( nType, nWidth, nHeight ) CLASS C5ImageView
******************************************************************************************************************
local rc
local nHRow
local nWCol
local nTop, nLeft, nBottom, nRight
local nCount := 1
local nR, nC
local nWOffset
local nHOffset

rc      := GetClientRect(::hWnd)
rc      := {rc[1],rc[2],rc[3],rc[4]}

// Calculamos las filas y las columnas en función del tamaño de la ficha

::nRows := max( int( ( rc[3] - rc[1] ) / ( ::nHItem ) ), 1 )
::nCols := max( int( ( rc[4] - rc[2] ) / ( ::nWItem ) ), 1 )

nHOffset := int( ( ( rc[3] - rc[1] ) - ( ::nHItem * ::nRows ) ) / ::nRows )
nWOffset := int( ( ( rc[4] - rc[2] ) - ( ::nWItem * ::nCols ) ) / ::nCols )

// logwrite( nWOffset )

//::nWItem( ::nWItem + int( ( ( rc[4] - rc[2] ) - ( ::nWItem * ::nCols ) ) / ::nCols ), .f. )

::aCoors := array( ::nRows * ::nCols )

for nR := 1 to ::nRows

    nTop     := ( nR - 1 ) * ( ::nHItem + nHOffset ) + rc[1] 
    nBottom  := nTop + ::nHItem + nHOffset

    for nC := 1 to ::nCols
        nLeft               := ( nC - 1 ) * ( ::nWItem + rc[2] + nWOffset )
        nRight              := nLeft + ::nWItem + nWOffset
        ::aCoors[ nCount ]  := { nTop, nLeft, nBottom, nRight }
        nCount++
    next

next

::VScrAdjust()

return ::Super:Resize( nType, nWidth, nHeight )

******************************************************************************************************************
  METHOD KeyDown( nKey, nFlags )  CLASS C5ImageView
******************************************************************************************************************

      do case
         case nKey == VK_RETURN .or. nKey == VK_SPACE
              if ::nOption != 0
                 if ::bAction != nil
                    eval(::bAction, self )
                 endif
              endif

         case nKey == VK_HOME
              ::GoHome()

         case nKey == VK_END
              ::GoEnd()

         case nKey == VK_UP

              ::oVScroll:GoUp()

         case nKey == VK_DOWN

              ::oVScroll:GoDown()

         case nKey == VK_LEFT
              ::GoLeft()

         case nKey == VK_RIGHT
              ::GoRight()

         case nKey == VK_PRIOR

              ::oVScroll:PageUp()

         case nKey == VK_NEXT

              ::oVScroll:PageDown()

         otherwise
              return ::Super:KeyDown( nKey, nFlags )
      endcase

return 0

******************************************************************************************************************
    METHOD GoHome()  CLASS C5ImageView
******************************************************************************************************************

  ::nOption    := 1
  ::nFirstItem := 1

  if ::bChanged != nil
     eval( ::bChanged, ::GetSelection() )
  endif

  ::Refresh(.T.)

return 0

******************************************************************************************************************
    METHOD GoEnd()  CLASS C5ImageView
******************************************************************************************************************

  ::nOption    := len(::aItems)
  ::nFirstItem := max(1, len(::aItems)- (::nCols*::nRows)+1)

   if ::bChanged != nil
      eval( ::bChanged, ::GetSelection() )
   endif

  ::Refresh(.T.)

return 0



******************************************************************************************************************
    METHOD PageUp()  CLASS C5ImageView
******************************************************************************************************************

  ::nOption    := max(1, ::nOption    - (::nCols*::nRows))
  ::nFirstItem := max(1, ::nFirstItem - (::nCols*::nRows))

   if ::bChanged != nil
      eval( ::bChanged, ::GetSelection() )
   endif

  ::Refresh(.T.)

return 0

******************************************************************************************************************
    METHOD PageDown()  CLASS C5ImageView
******************************************************************************************************************

  ::nOption    := min(len(::aItems), ::nOption    + (::nCols*::nRows))
  ::nFirstItem := min(len(::aItems), ::nFirstItem + (::nCols*::nRows))

   if ::bChanged != nil
      eval( ::bChanged, ::GetSelection() )
   endif

  ::Refresh(.T.)

return 0


******************************************************************************************************************
   METHOD Page( nLine ) CLASS C5ImageView
******************************************************************************************************************

   ::oVScroll:SetPos( nLine )
   ::Goto( nLine )

   if ::bChanged != nil
      eval( ::bChanged, ::GetSelection() )
   endif


return nil


******************************************************************************************************************
    METHOD Goto ( nLine ) CLASS C5ImageView
******************************************************************************************************************

::nFirstItem := (nLine-1)*::nCols + 1

::Refresh()



return nil


******************************************************************************************************************
    METHOD GoLeft()  CLASS C5ImageView
******************************************************************************************************************

if !::lShowOption
   return ::PageUp()
endif

::nOption := max( 1, ::nOption-1)

if ::nOption < ::nFirstItem
   ::nFirstItem := max( 1, ::nFirstItem - ::nCols )
endif

   if ::bChanged != nil
      eval( ::bChanged, ::GetSelection() )
   endif


::Refresh()

return 0

******************************************************************************************************************
    METHOD GoRight()  CLASS C5ImageView
******************************************************************************************************************

if !::lShowOption
   return ::PageDown()
endif

::nOption := min( len(::aItems), ::nOption+1)
if ::nOption - ::nFirstItem >= ::nRows*::nCols
   ::nFirstItem := min( len(::aItems), ::nFirstItem+::nCols)
endif

   if ::bChanged != nil
      eval( ::bChanged, ::GetSelection() )
   endif


::Refresh()


return 0


******************************************************************************************************************
    METHOD GoUp()  CLASS C5ImageView
******************************************************************************************************************

if !::lShowOption
   return ::PageUp()
endif

if ::nLineCount == 1
   return 0
endif

::nOption := max( 1, ::nOption-::nCols)

if ::nOption < ::nFirstItem
   ::nFirstItem := max( 1, ::nFirstItem - ::nCols )
endif

if ::bChanged != nil
   eval( ::bChanged, ::GetSelection() )
endif

::Refresh()


return 0

******************************************************************************************************************
    METHOD GoDown()  CLASS C5ImageView
******************************************************************************************************************

if !::lShowOption
   return ::PageDown()
endif

if ::nLineCount == 1
   return 0
endif

::nOption := min( len(::aItems), ::nOption+::nCols)

if ::nOption - ::nFirstItem >= ::nRows*::nCols
   ::nFirstItem := min( len(::aItems), ::nFirstItem+::nCols)
endif

if ::bChanged != nil
   eval( ::bChanged, ::GetSelection() )
endif
::Refresh()

return 0

******************************************************************************************************************
   METHOD LButtonDown( nRow, nCol )  CLASS C5ImageView
******************************************************************************************************************

local nOldOption  := ::nOption

::nOption         := ::GetOption( nRow, nCol )

//::Refresh()

if ::nOption != 0

   if !Empty( ::oVScroll )
      ::oVScroll:SetPos( ::nCurLine() )
   end if

   if ::bChanged != nil .and. ::nOption != nOldOption
      eval( ::bChanged, ::GetSelection() )
   endif

   if ::bAction != nil
      eval(::bAction, self ) 
   endif

   ::nOption := 0

endif

return 0

******************************************************************************************************************
METHOD LButtonUp( nRow, nCol )  CLASS C5ImageView
******************************************************************************************************************
/*
local nOldOption  := ::nOption

::nOption         := ::GetOption( nRow, nCol )

if ::nOption != 0

   if !Empty( ::oVScroll )
      ::oVScroll:SetPos( ::nCurLine() )
   end if

   if !Empty( ::bChanged ) .and. ( ::nOption != nOldOption )
      eval( ::bChanged, ::GetSelection() )
   endif

   if ::bAction != nil
      eval(::bAction, self )
   endif

   ::nOption := 0

endif
*/
return 0

******************************************************************************************************************
 METHOD MouseWheel( nKey, nDelta, nXPos, nYPos ) CLASS C5ImageView
******************************************************************************************************************

if !Empty( ::oVScroll )
   if nDelta > 0
      ::oVScroll:GoUp()
   else
      ::oVScroll:GoDown()
   endif
end if

return nil


return 0


******************************************************************************************************************
  METHOD GetOption( nRow, nCol )  CLASS C5ImageView
******************************************************************************************************************
local n
local nCell := 0

//localizo la casilla del grid donde se pulsó

for n := 1 to len(::aCoors)

    if PtInRect( nRow, nCol, ::aCoors[n] )
       nCell := n
       exit
    endif
next

if nCell == 0
   return 0
endif

nCell := ::nFirstItem + nCell -1

if nCell <= 0 .or. nCell > len(::aItems)
   return 0
endif

return nCell

#define SB_VERT   1

*******************************************************************************************************
   METHOD VScrAdjust() CLASS C5ImageView
*******************************************************************************************************

local nRes

   if !Empty( ::oVScroll )

   if ::lVScroll

      if ::nLineCount == 1
         ::oVScroll:SetRange( 0, 1 )
         SetScrollInfo( ::hWnd, SB_VERT, -1, .t. )
         ShowScrollBar(::hWnd, 1, .f. )
      else
         ShowScrollBar(::hWnd, 1, .f. )
         nRes := ::nLineCount + ::nLineVisib - 1
         ::oVScroll:SetRange( 1, nRes )
         SetScrollInfo( ::hWnd, SB_VERT, ::nLineVisib, .t. )
      endif

   endif

   end if

return nil

*******************************************************************************************************
   METHOD nLineCount() CLASS C5ImageView
*******************************************************************************************************
local nLines
local nLen := len(::aItems)


if nLen == 0
   return 0
endif

if ::lShowOption
   nLines := int(nLen / ::nCols ) + if( nLen % ::nCols > 0, 1, 0)
else
   nLines := int(nLen / (::nRows*::nCols)) + if( nLen % (::nRows*::nCols) > 0, 1, 0)
endif

return nLines

*******************************************************************************************************
  METHOD nFactor( hImage, rc ) CLASS C5ImageView
*******************************************************************************************************
Local nHImage
Local nWImage
local nFactor

nHImage := nBmpHeight( hImage )
nWImage := nBmpWidth( hImage )

if nHImage > nWImage     //alta
   nFactor := (rc[3]-rc[1]) / nHImage
else
   nFactor := (rc[4]-rc[2]) / nWImage
endif

//if nFactor >= 1;   nFactor := 1; endif

return nFactor

******************************************************************************************************
*****************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************
******************************************************************************************************

CLASS C5ImageViewItem

   DATA cImage
   DATA cText
   DATA Cargo
   DATA bAction
   DATA nClrPane

   METHOD New( cImage, cText, nClrPane, Cargo )  CONSTRUCTOR
   METHOD cFileName()

   METHOD Add( aItems )                INLINE ( aAdd( aItems, Self ) )

ENDCLASS

******************************************************************************************************
   METHOD New( cImage, cText, nClrPane, Cargo ) CLASS C5ImageViewItem
******************************************************************************************************

   ::cImage   := cImage
   ::cText    := cText
   ::nClrPane := nClrPane
   ::Cargo    := Cargo

return self

******************************************************************************************************
   METHOD cFileName() CLASS C5ImageViewItem
******************************************************************************************************

local n := RAt( "\", ::cImage )

return if( n > 0, substr( ::cImage, n+1 ), ::cImage )

******************************************************************************************************

Function SaveImage( cFileIn, cFileOut, nWidth, nHeight )

   local hDib
   local cTempFile
   local lSaved
   local hBitmap
   local hBmp
   local cExt     := cFileExt(cFileOut)
   local nFormat  := 0
   //   0 -> Bmp
   //   2 -> Jpg
   //  13 -> Png

   if Upper(cExt) == "JPG"
      nFormat := 2
   elseif Upper(cExt) == "PNG"
      nFormat := 13
   endif

   hBmp        := FiLoadImg( cFileIn )
   hBitmap     := ResizeBmpEx( hBmp, nWidth, nHeight )

   hDib        := DibFromBitmap( hBitmap )
   cTempFile   := cTempFile()

   DibWrite( cTempFile, hDib )
   GloBalFree( hDib )
   DeleteObject( hBmp )
   DeleteObject( hBitmap )

   lSaved      := FIConvertImageFile( cTempFile, cFileOut, nFormat, 100 )

   FErase( cTempFile )

return lSaved

******************************************************************************************************

Function ResizeBmpEx( hBmp, nWidth, nHeight  )

   local hBmpMem
   local hOldBmp
   local hDCMem
   local hDCMem2
   local hDC

   DEFAULT nWidth    := nBmpWidth( hBmp )
   DEFAULT nHeight   := nBmpHeight( hBmp )

   hDc               := CreateDC( "DISPLAY",0,0,0)
   hDCMem            := CreateCompatibleDC( hDC )
   hDCMem2           := CreateCompatibleDC( hDC )
   hOldBmp           := SelectObject( hDCMem2, hBmp )
   hBmpMem           := CreateCompatibleBitmap( hDC, nWidth, nHeight )
   hOldBmp           := SelectObject( hDCMem, hBmpMem )

   SetStretchBltMode( hDCMem, 3 )
   StretchBlt( hDCMem, 0, 0, nWidth, nHeight, hDCMem2, 0, 0, nBmpWidth( hBmp ), nBmpHeight( hBmp ), 13369376 ) //SRCCOPY

   SelectObject( hDCMem, hOldBmp )
   SelectObject( hDCMem2, hBmp )

   DeleteDC( hDCMem )
   DeleteDC( hDCMem2 )
   DeleteDC( hDC )

return hBmpMem

******************************************************************************************************

#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"

void DrawBitmapEx( HDC hdc, HBITMAP hbm, WORD wCol, WORD wRow, WORD wWidth,
                 WORD wHeight, DWORD dwRaster )
{
    HDC       hDcMem, hDcMemX;
    BITMAP    bm, bmx;
    HBITMAP   hBmpOld, hbmx, hBmpOldX;

    if( !hdc || !hbm )
       return;

    hDcMem  = CreateCompatibleDC( hdc );
    hBmpOld = ( HBITMAP ) SelectObject( hDcMem, hbm );

    if( ! dwRaster )
       dwRaster = SRCCOPY;

    GetObject( hbm, sizeof( BITMAP ), ( LPSTR ) &bm );

    if( ! wWidth || ! wHeight )
       BitBlt( hdc, wRow, wCol, bm.bmWidth, bm.bmHeight, hDcMem, 0, 0, dwRaster );
    else
    {
       hDcMemX          = CreateCompatibleDC( hdc );
       bmx              = bm;
       bmx.bmWidth      = wWidth;
       bmx.bmHeight     = wHeight;

       bmx.bmWidthBytes = ( bmx.bmWidth * bmx.bmBitsPixel + 15 ) / 16 * 2;

       hbmx = CreateBitmapIndirect( &bmx );

       SetStretchBltMode (hDcMemX, COLORONCOLOR);
       hBmpOldX = ( HBITMAP ) SelectObject( hDcMemX, hbmx );
       StretchBlt( hDcMemX, 0, 0, wWidth, wHeight, hDcMem, 0, 0,
                   bm.bmWidth, bm.bmHeight, dwRaster );
       BitBlt( hdc, wRow, wCol, wWidth, wHeight, hDcMemX, 0, 0, dwRaster );
       SelectObject( hDcMemX, hBmpOldX );
       DeleteDC( hDcMemX );
       DeleteObject( hbmx );
    }

    SelectObject( hDcMem, hBmpOld );
    DeleteDC( hDcMem );
}
HB_FUNC_STATIC( DRAWBITMAPEX ) //  hDC, hBitmap, nRow, nCol, nWidth, nHeight, nRaster
{
   DrawBitmapEx( ( HDC ) hb_parnl( 1 ), ( HBITMAP ) hb_parnl( 2 ),
               hb_parni( 3 ), hb_parni( 4 ),
               hb_parni( 5 ), hb_parni( 6 ), hb_parnl( 7 ) );
}

HB_FUNC_STATIC( FILLSOLIDRECT )
{
    RECT rct;
    COLORREF nColor;
    HPEN hPen, hOldPen;
    HDC hDC = ( HDC ) hb_parnl( 1 );
    rct.top    = hb_parvni( 2, 1 );
    rct.left   = hb_parvni( 2, 2 );
    rct.bottom = hb_parvni( 2, 3 );
    rct.right  = hb_parvni( 2, 4 );

    nColor = SetBkColor( hDC, hb_parnl( 3 ) );
    ExtTextOut( hDC, 0, 0, ETO_OPAQUE, &rct, NULL, 0, NULL);
    SetBkColor( hDC, nColor );

    if( hb_pcount()  > 3 )
    {
       hPen = CreatePen( PS_SOLID, 1,(COLORREF)hb_parnl( 4 ));
       hOldPen = (HPEN) SelectObject( hDC, hPen );
       MoveToEx( hDC, rct.left, rct.top, NULL );
       LineTo( hDC, rct.right-3, rct.top );
       LineTo( hDC, rct.right-3, rct.bottom );
       LineTo( hDC, rct.left, rct.bottom );
       LineTo( hDC, rct.left, rct.top );
       SelectObject( hDC, hOldPen );
       DeleteObject( hPen );
    }
}

HB_FUNC_STATIC( PTINRECT )
{
   POINT pt;
   RECT  rct;

   pt.y = hb_parnl( 1 );
   pt.x = hb_parnl( 2 );

   rct.top    = hb_parvni( 3, 1 );
   rct.left   = hb_parvni( 3, 2 );
   rct.bottom = hb_parvni( 3, 3 );
   rct.right  = hb_parvni( 3, 4 );

   hb_retl( PtInRect( &rct, pt ) );
}

HB_FUNC_STATIC( SHOWSCROLLBAR )
{
   hb_retl( ShowScrollBar( (HWND)hb_parnl(1), hb_parni(2), hb_parl( 3 ) ) );
}

//#define SB_HORZ             0
//#define SB_VERT             1
//#define SB_CTL              2
//#define SB_BOTH             3

HB_FUNC_STATIC( SETSTRETCHBLTMODE )
{
    hb_retni( SetStretchBltMode( ( HDC ) hb_parnl( 1 ), 4 ));
}

HB_FUNC_STATIC( QUITARESTILO )
{
   HWND hWnd = (HWND) hb_parnl( 1 );
   DWORD dwStyle = GetWindowLong( hWnd, GWL_STYLE );
   dwStyle &= ~ ((DWORD)hb_parnl(2));
   SetWindowLong( hWnd, GWL_STYLE, dwStyle );
   SetWindowPos( hWnd,0,0,0,0,0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_DRAWFRAME);
}

HB_FUNC_STATIC( SUMARESTILO )
{
   HWND hWnd = (HWND) hb_parnl( 1 );
   DWORD dwStyle = GetWindowLong( hWnd, GWL_STYLE );
   dwStyle |= ((DWORD)hb_parnl(2));
   SetWindowLong( hWnd, GWL_STYLE, dwStyle );
   SetWindowPos( hWnd,0,0,0,0,0, SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER | SWP_FRAMECHANGED | SWP_DRAWFRAME);
}


HB_FUNC_STATIC( BOX )
{
      HDC hDC = (HDC) hb_parnl( 1 );
      HPEN hPen;
      HPEN hOldPen;
      RECT rc;

      if( hb_pcount() > 3 )
      {
         hPen = CreatePen( hb_parni(4),1, (COLORREF)hb_parnl( 3 ));
      }
      else
      {
         hPen = CreatePen( PS_SOLID,1, (COLORREF)hb_parnl( 3 ));
      }
      rc.top    = hb_parvni( 2, 1);
      rc.left   = hb_parvni( 2, 2);
      rc.bottom = hb_parvni( 2, 3);
      rc.right  = hb_parvni( 2, 4);
      hOldPen = (HPEN) SelectObject( hDC, hPen );
      MoveToEx( hDC, rc.left, rc.top, NULL );
      LineTo( hDC, rc.right, rc.top );
      LineTo( hDC, rc.right, rc.bottom );
      LineTo( hDC, rc.left, rc.bottom );
      LineTo( hDC, rc.left, rc.top );
      SelectObject( hDC, hOldPen );
      DeleteObject( hPen );
}


#pragma ENDDUMP