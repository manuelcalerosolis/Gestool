#include "fivewin.ch"

static oToolTip, oTmr, hPrvWnd, lToolTip := .f., hWndParent := 0,;
       hToolTip := 0

CLASS TVistaMenu FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA nHMargen     AS NUMERIC INIT 0
      DATA nVTMargen    AS NUMERIC INIT 0
      DATA nRow, nCol
      DATA nxColumns
      DATA nWLeftImage
      DATA aItems
      DATA oOldOver
      DATA oOver
      DATA nOptionFocus AS NUMERIC INIT 1
      DATA oAbsOver
      //DATA rcItem

      DATA oFont2

      // COLORES
      DATA nClrText2

      // OVER
      DATA nColorStyle
      DATA nClrBorderOver
      DATA nClrBorderOver2
      DATA nClrPaneOver
      DATA nClrPaneOver2
      DATA nClrTextOver1
      DATA nClrTextOver2

      DATA nYOffset    AS NUMERIC INIT 0
      DATA aAlturas
      DATA nType       AS NUMERIC INIT 1
      DATA nMaxHeight  AS NUMERIC INIT 0
      DATA lKeyDown    AS LOGICAL INIT .F.

      METHOD New        ( nTop, nLeft, nWidth, nHeight, oWnd, oFont, oFont2 ) CONSTRUCTOR
      METHOD Redefine   ( nId, oWnd, oFont, oFont2 ) CONSTRUCTOR

      //METHOD IsOver     ( nRow, nCol ) INLINE PtInRect( nRow, nCol, ::rcItem )
      METHOD AddItem    ( cText, cImage, bAction )
      METHOD CheckToolTip()
      METHOD Default    ( )
      METHOD DelItem    ( nItem )
      METHOD Destroy    ( )
      METHOD DestroyToolTip()
      METHOD Display    ( ) INLINE ::BeginPaint(),::Paint(),::EndPaint(),0
      METHOD EraseBkGnd ( hDC ) INLINE 1
      METHOD GetCoors   ( )
      METHOD GoDown()
      METHOD GoUp()
      METHOD Initiate   ( hDlg ) INLINE  Super:Initiate( hDlg ), ::Default()
      METHOD InsertItem ( n, cText, cImage, bAction )
      METHOD KeyDown    ( nKey, nFlags )
      METHOD LButtonDown( nRow, nCol )
      METHOD LButtonUp  ( nRow, nCol )
      METHOD LoadColors ( nStyle )
      METHOD LostFocus  ( )
      METHOD MouseMove  ( nRow, nCol )
      METHOD Paint      ( )
      METHOD Resize     ( )
      METHOD SetMarginH ( n ) SETGET
      METHOD SetMarginT ( n ) SETGET
      METHOD ShowTooltip( nRow, nCol )
      METHOD ShowTooltip2( nRow, nCol )
      METHOD VScroll    ( )
      METHOD nAbsLen()
      METHOD nColumns   ( n ) SETGET
      METHOD nLen       ( ) INLINE len(::aItems)
      METHOD nRows      ( )
      METHOD oAbsItem( nItem )
      METHOD oAbsoluteGetOver( nRow, nCol )
      METHOD oGetOver   ( nRow, nCol )

ENDCLASS

*********************************************************************************************************
   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oFont, oFont2 ) CLASS TVistaMenu
*********************************************************************************************************

     ::oWnd           := oWnd
     ::nTop           := nTop
     ::nLeft          := nLeft
     ::nBottom        := nTop + nHeight
     ::nRight         := nLeft + nWidth

     ::nStyle         := nOR( WS_CHILD, WS_BORDER, WS_VISIBLE, WS_TABSTOP, WS_CLIPSIBLINGS, WS_CLIPCHILDREN, WS_VSCROLL )
     ::nId            := ::GetNewId()
     ::oFont  := oFont
     ::oFont2 := oFont2
     ::aItems      := {}

     ::Register(nOr( CS_VREDRAW, CS_HREDRAW ) )

     if ! Empty( oWnd:hWnd )
        ::Create()
        ::Default()
        oWnd:AddControl( Self )
     else
        oWnd:DefControl( Self )
        ::lVisible  = .f.
     endif


return self


*********************************************************************************************************
   METHOD Redefine( nId, oWnd, oFont, oFont2 ) CLASS TVistaMenu
*********************************************************************************************************

     ::aItems     :=  {}
     ::oWnd       := oWnd
     ::nId        := nId

     ::Register()

     ::oWnd:DefControl( Self )

     ::oFont  := oFont
     ::oFont2 := oFont2


return self

*********************************************************************************************************
   METHOD AddItem( cText, cImage, bAction ) CLASS TVistaMenu
*********************************************************************************************************

local oItem := TVistaMenuItem():New( self, cText, cImage, bAction, self )

oItem:lLevel1 := .t.
aadd( ::aItems, oItem )

return oItem

***************************************************************************
   METHOD CheckToolTip() CLASS TVistaMenu
***************************************************************************

   local hWndAct

   if ::cToolTip == nil .and. ::hWnd != hWndParent
      if ::hWnd != hToolTip
         lToolTip = .f.
      endif
   endif

   if ::cToolTip == nil
      if hPrvWnd != ::hWnd
         hPrvWnd  = ::hWnd
      endif
      if oToolTip != nil
         oToolTip:End()
         oToolTip = NIL
      endif
      if oTmr != NIL
         oTmr:End()
         oTmr = NIL
      endif
   else
      if hPrvWnd != ::hWnd
         hWndParent = GetParent( ::hWnd )
         hPrvWnd    = ::hWnd
         if oToolTip != nil
            oToolTip:End()
            oToolTip = NIL
         endif
         if oTmr != NIL
            oTmr:End()
            oTmr = NIL
         endif
         //if lToolTip
         //   ::ShowToolTip()
         //else
            hWndAct = GetActiveWindow()
            DEFINE TIMER oTmr INTERVAL ::nToolTip ;
               ACTION ( If( GetActiveWindow() == hWndAct,;
                        ::ShowToolTip(),), oTmr:End(), oTmr := nil )
               oTmr:hWndOwner = GetActiveWindow() // WndApp()
            ACTIVATE TIMER oTmr
         //endif
      endif
   endif

return nil

*********************************************************************************************************
   METHOD Default() CLASS TVistaMenu
*********************************************************************************************************


  //::rcItem      := {0,0,0,0}
  ::nColumns    := 2
  ::nWLeftImage := 70
  ::LoadColors( ::nColorStyle )
  ::nVTMargen   := 20

  if ::oFont == nil
  // DEFINE FONT ::oFont  NAME "Verdana" SIZE 9, 22
     DEFINE FONT ::oFont  NAME "Segoe UI" SIZE 9, 22
  endif

  if ::oFont2 == nil
  // DEFINE FONT ::oFont2 NAME "Verdana" SIZE 6, 13
     DEFINE FONT ::oFont2 NAME "Segoe UI" SIZE 6, 15
  endif

  DEFINE SCROLLBAR ::oVScroll VERTICAL   OF Self

  ::oVScroll:SetRange(0,0)
  ::cToolTip := ::ClassName()
  ::CheckToolTip()

  ::Resize()


return 0

*********************************************************************************************************
   METHOD DelItem( nItem ) CLASS TVistaMenu
*********************************************************************************************************

  if nItem < 1 .or. nItem > ::nLen()
     MsgStop( "Índice fuera de rango al borrar elementos","Atención")
     return 0
  endif

  adel ( ::aItems,  nItem     )
  asize( ::aItems, ::nLen()-1 )

  ::Resize()

return 0

*********************************************************************************************************
   METHOD Destroy( ) CLASS TVistaMenu
*********************************************************************************************************
local n
local nLen := ::nLen()

::oFont2:End()

for n := 1 to nLen
    ::aItems[n]:Destroy()
next

return super:Destroy()

***************************************************************************
  METHOD DestroyToolTip() CLASS TVistaMenu
***************************************************************************

  if oToolTip != nil
     oToolTip:End()
     oToolTip = nil
  endif

  hPrvWnd = 0
  hWndParent = 0

return nil

*********************************************************************************************************
   METHOD GetCoors() CLASS TVistaMenu
*********************************************************************************************************
local hDC
local hOldFont
local lFirst
local n
local n2
local nAcum
local nAcumWidth
local nB
local nBottom
local nCol
local nFila
local nHItem
local nHText
local nHeight
local nL
local nLeft
local nLeft0
local nLen
local nLen2
local nR
local nRight
local nRows
local nT
local nTop
local nWColumn
local nWText
local nWidth
local rc

lFirst     := .t.
hDC        := CreateDC( "DISPLAY",0,0,0)
rc         := GetClientRect(::hWnd)
nHeight    := rc[3]-rc[1]
nWidth     := rc[4]-rc[2]-15-(::nHMargen*2)

if ::nType == 2            // ¡¡ATENCIÓN!! SI ::nType == 2 -> ::nColumns := 1
   ::nColumns := 1
endif

nWColumn   := nWidth / ::nColumns
nLen       := ::nLen()
n          := 1
nRows      := ::nRows()
nTop       := rc[1]
nLeft      := rc[2] + 5 + ::nWLeftImage + ::nHMargen
nLeft0     := nLeft
nBottom    := nTop
nRight     := rc[2]+ nWColumn - 5
nFila      := 1
nCol       := 1
nAcum      := 0
nHItem     := 0
nAcumWidth := 0


::nMaxHeight := 0
SetTextAlign( hDC, 0 )

::aAlturas := afill(array(::nColumns),0)

  for n := 1 to nLen

      nAcum := 0

      if nFila > nRows // cambio de columna

         nFila := 1
         nCol++

         nTop     := rc[1]
         nLeft    := nR + ::nWLeftImage
         nBottom  := nTop
         nRight   := nR + nWColumn

      endif

      // Para el item general que abarca a todos
      nT := nTop
      nL := nLeft  - ::nWLeftImage
      nB := nTop
      nR := nRight + 5

      nHItem := 0

      hOldFont := SelectObject( hDC, ::oFont:hFont )
      nHText   := DrawMText( hDC, ::aItems[n]:cText, {nTop, nLeft, nBottom, nRight }, .f.)
      SelectObject( hDC, hOldFont )
      nBottom := nTop + nHText

      ::aItems[n]:rcItem := { nTop, nLeft, nBottom, nRight }

      nAcum += nHText

      nLen2 := len( ::aItems[n]:aItems )
      do case
         case ::nType == 1
              for n2 := 1 to nLen2

                  nTop     := nBottom
                  nBottom  := nTop

                  hOldFont := SelectObject( hDC, ::oFont2:hFont )

                  nHText   := DrawMText( hDC, ::aItems[n]:aItems[n2]:cText , {nTop, nLeft, nBottom, nRight }, .f.)

                  SelectObject( hDC, hOldFont )

                  nBottom := nTop + nHText

                  ::aItems[n]:aItems[n2]:rcItem := { nTop, nLeft, nBottom, nRight }

                  nAcum += nHText

              next n2

         case ::nType == 2

              nTop       := nBottom +10
              nBottom    := nTop
              nLeft      := nLeft0
              nAcumWidth := 0

              lFirst     := .t.

              for n2 := 1 to nLen2

                  hOldFont := SelectObject( hDC, ::oFont2:hFont )

                  nHText   := DrawText( hDC, ::aItems[n]:aItems[n2]:cText , {0, nLeft0, 100, rc[4]}, 1056 ) * 1.3// DT_LEFT, DT_SINGLELINE, DT_CALCRECT
                  nWText   := GetTextWidth( hDC, ::aItems[n]:aItems[n2]:cText , ::oFont2:hFont ) + 22

                  SelectObject( hDC, hOldFont )

                  if nLeft + nWText < rc[4]-5

                     nRight     := nLeft + nWText
                     nBottom    := nTop + nHText

                     ::aItems[n]:aItems[n2]:rcItem := { nTop, nLeft, nBottom, nRight }

                     nLeft      := nRight

                     if lFirst
                        nAcum += nHText
                        lFirst := .f.
                     endif

                  else


                     if nLeft == nLeft0

                        nRight   := nLeft + nWText
                        nBottom  := nTop + nHText

                        ::aItems[n]:aItems[n2]:rcItem := {nTop, nLeft, nBottom, nRight}

                        nTop     += nHText
                        nBottom  := nTop + nHText
                        nLeft    := nLeft0
                        nRight   := nLeft + nWText

                     else

                        lFirst     := .t.

                        nTop    += nHText
                        nBottom := nTop + nHText
                        nLeft   := nLeft0
                        nRight  := nLeft + nWText
                        ::aItems[n]:aItems[n2]:rcItem := {nTop, nLeft, nBottom, nRight}
                        nLeft      := nRight

                     endif

                     nAcum += nHText

                  endif

              next n2

              if lFirst
                 nAcum += nHText
              endif

              nLeft  := nLeft0
              nRight := rc[2]+ nWColumn - 5

      endcase

      nHItem := max( ::aItems[n]:nHImage, nAcum ) + 10

      nB := nT + nHItem
      nT := nT - 10

      ::aItems[n]:rcItemL1 := { nT+5, nL, nB-5, nR }

      nTop := nB + 10

      ::aAlturas[nCol] += ( nTop - ::aItems[n]:rcItemL1[1] )

      nFila++

  next n



DeleteDC( hDC )

for n := 1 to len(::aAlturas)
    ::nMaxHeight := max( ::nMaxHeight, ::aAlturas[n] )
next

if ::nMaxHeight < nHeight
   ::oVScroll:SetRange(0,0)
else
   ::oVScroll:SetRange(0, (::nMaxHeight-nHeight )/ 10)
   c5SetScrollInfo( ::hWnd, 1, int(( nHeight/::nMaxHeight)*(::nMaxHeight-nHeight))/10 , 2 ,.t.)
endif

for n := 1 to nLen

    ::aItems[n]:rcItemL1[1] += ( ::nYOffset + ::nVTMargen )
    ::aItems[n]:rcItemL1[3] += ( ::nYOffset + ::nVTMargen )

    ::aItems[n]:rcItem[1] += ( ::nYOffset + ::nVTMargen )
    ::aItems[n]:rcItem[3] += ( ::nYOffset + ::nVTMargen )

    nLen2 := len( ::aItems[n]:aItems )
    for n2 := 1 to nLen2
        ::aItems[n]:aItems[n2]:rcItem[1] += ( ::nYOffset + ::nVTMargen )
        ::aItems[n]:aItems[n2]:rcItem[3] += ( ::nYOffset + ::nVTMargen )
    next

next


return 0

*********************************************************************************************************
   METHOD GoDown() CLASS TVistaMenu
*********************************************************************************************************
local rc := GetClientRect(::hWnd)
local n := ::nOptionFocus
local o

::nOptionFocus := min( ::nAbsLen(), ::nOptionFocus+1 )
o := ::oAbsItem( ::nOptionFocus )

if !IntersectRect( rc, o:rcItem )
   ::nYOffset -= ((o:rcItem[3]-o:rcItem[1])*2)
endif

if n != ::nOptionFocus
   ::GetCoors()
   ::Refresh(.t.)
endif

return 0

*********************************************************************************************************
   METHOD GoUp() CLASS TVistaMenu
*********************************************************************************************************
local rc := GetClientRect(::hWnd)
local n := ::nOptionFocus
local o

::nOptionFocus := max( 1, ::nOptionFocus-1)
o := ::oAbsItem( ::nOptionFocus )

if !IntersectRect( rc, o:rcItem )
   ::nYOffset := min( 0, ::nYOffset + ((o:rcItem[3]-o:rcItem[1])*2) )
endif

if n != ::nOptionFocus
   ::GetCoors()
   ::Refresh(.t.)
endif

return 0

*********************************************************************************************************
   METHOD InsertItem( n, cText, cImage, bAction ) CLASS TVistaMenu
*********************************************************************************************************

local oItem := TVistaMenuItem():New( self, cText, cImage, bAction, self )
oItem:lLevel1 := .t.
aadd( ::aItems, nil )
ains( ::aItems, n )
::aItems[n] := oItem

::Resize()

return oItem

*********************************************************************************************************
   METHOD KeyDown( nKey, nFlags ) CLASS TVistaMenu
*********************************************************************************************************
   ::lKeyDown := .t.

   do case
      case nKey == VK_UP
           ::GoUp()
      case nKey == VK_DOWN
           ::GoDown()
      case nKey == VK_LEFT
      case nKey == VK_RIGHT
   endcase

return 0

*********************************************************************************************************
   METHOD LButtonDown( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
::oOldOver := ::oGetOver( nRow, nCol )

if !::lCaptured
   ::Capture()
   ::lCaptured = .t.
endif


return 0

*********************************************************************************************************
   METHOD LButtonUp( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
local n
local nLen
ReleaseCapture()
::lCaptured := .f.

if ::oOver != nil .and. ::oOver == ::oOldOver
   nLen := len( ::oOver:aItems )
   for n := 1 to nLen
       if ::oOver:aItems[n]:IsOver( nRow, nCol )
          if ::oOver:aItems[n]:bAction != nil
             return eval( ::oOver:aItems[n]:bAction, ::oOver:aItems[n] )
          else
             return 0
          endif
       endif
   next
   if ::oOver:bAction != nil
      if ::oOver:lEnable
         return eval( ::oOver:bAction, ::oOver )
      endif
   endif
endif

return 0

*********************************************************************************************************
   METHOD LoadColors( nStyle ) CLASS TVistaMenu
*********************************************************************************************************

DEFAULT nStyle := 1

do case
   case nStyle == 1

      ::nClrPane        := CLR_WHITE
      ::nClrText        := RGB(  0,110,  0)
      ::nClrText2       := RGB( 60, 64,238)
      ::nClrBorderOver  := RGB(218,242,252)
      ::nClrBorderOver2 := RGB(240,250,255)
      ::nClrPaneOver    := RGB(247,252,255)
      ::nClrPaneOver2   := RGB(234,247,255)
      ::nClrTextOver1   := RGB(  0,174, 29)
      ::nClrTextOver2   := RGB( 51,153,255)


endcase

return 0

***************************************************************************************************
   METHOD LostFocus() CLASS TVistaMenu
***************************************************************************************************

::lKeyDown := .f.

return Super:LostFocus()

*********************************************************************************************************
   METHOD MouseMove( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
local oOver := ::oAbsoluteGetOver( nRow, nCol )

::nRow := nRow
::nCol := nCol

if oOver != nil
   if ::oAbsOver != nil
      if oOver:nID != ::oAbsOver:nID
         ::DestroyToolTip()
         ::oAbsOver := oOver
         ::CheckToolTip()
      endif
   else
      ::DestroyToolTip()
      ::oAbsOver := oOver
      ::CheckToolTip()
   endif

else
   ::DestroyToolTip()
endif

::oOver := ::oGetOver( nRow, nCol )

::Refresh()

if ::oOver != nil
   CursorHand()
else
   Cursorarrow()
endif


return 0

*********************************************************************************************************
   METHOD Paint() CLASS TVistaMenu
*********************************************************************************************************
local hDCMem  := CreateCompatibleDC( ::hDC )
local hBmpMem
local hOldBmp
local rc := GetClientRect(::hWnd)
local n, n2
local nLen := ::nLen()
local nLen2
local hOldFont
local nColor, nMode
local lSelected
local nCount := 0

hBmpMem    := CreateCompatibleBitmap( ::hDC, rc[4]-rc[2], rc[3]-rc[1] )
hOldBmp    := SelectObject( hDCMem, hBmpMem )
nMode      := SetBkMode( hDCMem, 1 )

FillSolidRect( hDCMem, rc, ::nClrPane )

for n := 1 to nLen

    lSelected := ::oOver != nil .and. ::oOver:nId == ::aItems[n]:nId
    nCount++
    ::aItems[n]:Paint( hDCMem, lSelected, nCount == ::nOptionFocus  )

    nLen2 := ::aItems[n]:nLen()

    for n2 := 1 to nLen2
        nCount++
        ::aItems[n]:aItems[n2]:Paint( hDCMem, .f., nCount == ::nOptionFocus, n2 == nLen2 )
    next

next

SetBkMode( hDCMem, nMode )

BitBlt( ::hDC, 0, 0, rc[4]-rc[2], rc[3]-rc[1], hDCMem,  0, 0, 13369376 )
SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmpMem )
DeleteDC( hDCMem )


return 0

****************************************************************************************************
   METHOD ReSize( nType, nWidth, nHeight )  CLASS TVistaMenu
****************************************************************************************************
   ::nYOffset := 0
   ::GetCoors()
   Super:ReSize( nType, nWidth, nHeight )

return 0

*********************************************************************************************************
      METHOD SetMarginH ( n )  CLASS TVistaMenu
*********************************************************************************************************

if Pcount() > 0
   ::nHMargen := n
endif

return ::nHMargen

*********************************************************************************************************
      METHOD SetMarginT ( n )  CLASS TVistaMenu
*********************************************************************************************************

  if Pcount() > 0
     ::nVTMargen := n
  endif

return ::nVTmargen

***************************************************************************
  METHOD ShowToolTip()  CLASS TVistaMenu
***************************************************************************

   local cToolTip := ""
   local nT, nL

   if ::oAbsOver != nil

      if !Empty( ::oAbsOver:cTooltip  )
         cToolTip := ::oAbsOver:cTooltip
      endif

      nT := ::oAbsOver:rcItem[3] + 20
      nL := ::nCol

      ::cToolTip := cToolTip
      ::ShowToolTip2( nT, nL )
   endif

return nil

***************************************************************************
METHOD ShowToolTip2( nRow, nCol, cToolTip ) CLASS TVistaMenu
***************************************************************************

   local oFont, aPos, hOldFont, nTxtWidth := 0, nTxtHeight
   local aToolTip, nLenToolTip
   local a


   DEFAULT nCol := 7, nRow := ::nHeight() + 7, ;
           cToolTip := ::cToolTip



   if oToolTip == nil

      if ValType( cToolTip ) == "B"
         cToolTip = Eval( cToolTip )
      endif

      if empty( cToolTip )
         return nil
      endif

      oToolTip := TC5ToolTip():New( 0, 0, 1, 5, Self, .f., CLR_WHITE, RGB(228,229,240), RGB(100,100,100), 2, 2 )

      if ::oAbsOver:cTHeader != nil
         oToolTip:cHeader := ::oAbsOver:cTHeader
      else
         oToolTip:cHeader := ""
      endif

      if ::oAbsOver:cTooltip != nil
         oToolTip:cBody   := ::oAbsOver:cToolTip //::cToolTipEx
      else
         oToolTip:cBody   := ""
      endif
      DEFAULT ::cMsg := ""
      //if empty( ::cFoot )
      //   if At( "Alt", ::cMsg ) != 0
      //      oToolTip:cFoot := ::cMsg
      //   endif
      //else
      //   oToolTip:cFoot := ::cFoot
      //endif

      //if empty( ::cToolTipEx )
      //   oToolTip:cHeader := ""
      //   oToolTip:cBody := cToolTip
      //endif

      if ::oAbsOver:cTBmpLeft != nil
         oToolTip:cBmpLeft := ::oAbsOver:cTBmpLeft
      endif
      //oToolTip:cBmpFoot := ::cBmpFoot

      //if ::bToolTip != nil
      //   eval( ::bTooltip, self, oTooltip )
      //endif

      //oToolTip:DatosExamp( nRandom(8)+1 )

      a := oTooltip:GetSize()

      aPos = { nRow, nCol }
      aPos := ClientToScreen( ::hWnd, aPos )

      if aPos[2]+a[1] > GetSysMetrics(1)
         aPos[2] := GetSysMetrics(0) - a[1] - 20
      endif

      oToolTip:Move( aPos[1], aPos[2],a[1],a[2], .f. )
      oToolTip:Default()
      oToolTip:Show()
      hToolTip = oToolTip:hWnd

   endif

   lToolTip = .t.

return nil

*********************************************************************************************************
   METHOD VScroll( nWParam, nLParam )  CLASS TVistaMenu
*********************************************************************************************************

   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )
   local nRange      := ::oVScroll:nMax-::oVScroll:nMin

   do case
      case nScrollCode == SB_LINEUP

           ::oVScroll:GoUp()
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())


      case nScrollCode == SB_LINEDOWN

           ::oVScroll:GoDown()
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())

      case nScrollCode == SB_PAGEUP

           ::oVScroll:PageUp()
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())

      case nScrollCode == SB_PAGEDOWN

           ::oVScroll:PageDown()
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())

      case nScrollCode == SB_TOP

           ::oVScroll:GoTop()
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())

      case nScrollCode == SB_BOTTOM

           ::oVScroll:GoBottom()
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*::oVScroll:GetPos())

       case nScrollCode == SB_THUMBPOSITION

           ::oVScroll:SetPos( nPos )
           ::oVScroll:ThumbPos( nPos )

       case nScrollCode == SB_THUMBTRACK

           nPos := GetScrollInfoPos( ::hWnd, 1 )
           ::nYOffset := - int((::nMaxHeight /(::oVScroll:nMax-::oVScroll:nMin) )*nPos)



      otherwise
           return nil
   endcase


::GetCoors()
::Refresh()

//::oWnd:cTitle := str( nPos ) + str( ::nMaxHeight-::nHeight)

RETURN( NIL )

*********************************************************************************************************
   METHOD nAbsLen() CLASS TVistaMenu
*********************************************************************************************************
local nCount := 0
local n, n2, nLen, nLen2

nLen := ::nLen()
for n := 1 to nLen
    nCount++
    nLen2 := len( ::aItems[n]:aItems )
    for n2 := 1 to nLen2
        nCount++
    next
next

return nCount

*********************************************************************************************************
      METHOD nColumns( n ) CLASS TVistaMenu
*********************************************************************************************************

  if pcount() > 0
     ::nxColumns := n
  endif

return ::nxColumns

*********************************************************************************************************
   METHOD nRows() CLASS TVistaMenu
*********************************************************************************************************
local nRows := 0
local nLen := ::nLen()

nRows := int( nLen/::nColumns )

if nLen % 2 > 0
   nRows++
endif

return nRows

*********************************************************************************************************
   METHOD oAbsItem( nItem ) CLASS TVistaMenu
*********************************************************************************************************
local nCount := 0
local n, n2, nLen, nLen2

nLen := ::nLen()
for n := 1 to nLen
    nCount++
    if nItem == nCount
       return ::aItems[n]
    endif
    nLen2 := len( ::aItems[n]:aItems )
    for n2 := 1 to nLen2
        nCount++
        if nItem == nCount
           return ::aItems[n]:aItems[n2]
        endif
    next
next

return nil

***************************************************************************
  METHOD oAbsoluteGetOver( nRow, nCol ) CLASS TVistaMenu
***************************************************************************
local n, n2, nLen2
local nLen  := ::nLen()

for n := 1 to nLen
    if PtInRect( nRow, nCol, ::aItems[n]:rcItem )
       return ::aItems[n]
    else
       nLen2 := ::aItems[n]:nLen()
       for n2 := 1 to nLen2
           if PtInRect( nRow, nCol, ::aItems[n]:aItems[n2]:rcItem )
              return ::aItems[n]:aItems[n2]
           endif
       next
    endif
next

return nil



*********************************************************************************************************
   METHOD oGetOver( nRow, nCol ) CLASS TVistaMenu
*********************************************************************************************************
local n
local nLen  := ::nLen()
local oOver

for n := 1 to nLen
    if ::aItems[n]:lEnable .and. PtInRect( nRow, nCol, ::aItems[n]:rcItemL1 )
       oOver := ::aItems[n]
       exit
    endif
next

return oOver









*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************
*********************************************************************************************************


CLASS TVistaMenuItem

      CLASSDATA nInitID INIT 100

      DATA oWnd
      DATA cText
      DATA cImage
      DATA hBmp
      DATA bAction
      DATA lLevel1    AS LOGICAL INIT .F.
      DATA aItems

      DATA rcItem
      DATA rcItemL1
      DATA nHText

      DATA nId
      DATA nHImage     AS NUMERIC INIT 0
      DATA nWImage     AS NUMERIC INIT 0
      DATA nAlphaLevel AS NUMERIC INIT 255
      DATA lEnable     AS LOGICAL INIT .T.
      DATA lHasAlpha   AS LOGICAL INIT .F.

      // TOOLTIP
      DATA cTHeader
      DATA cTooltip    AS CHARACTER INIT ""
      DATA cTFoot
      DATA cTBmpHeader
      DATA cTBmpLeft
      DATA cTBmpFoot
      DATA cTBtnClose

      METHOD New        ( oWnd, cText, cImage, bAction ) CONSTRUCTOR

      METHOD AddItem    ( cText, cImage, bAction )
      METHOD DelItem    ( nItem )
      METHOD Destroy    ( )
      METHOD Disable    ( )
      METHOD Enable     ( )
      METHOD GetNewId   ( )            INLINE If( ::nInitId == nil, ::nInitId := 100,),++::nInitId
      METHOD InsertItem ( n, cText, cImage, bAction )
      METHOD IsOver     ( nRow, nCol ) INLINE PtInRect( nRow, nCol, ::rcItem )
      METHOD LoadImage  ( cImage )
      METHOD Paint      ( hDC, lSelected, lFocus, lLast )
      METHOD SetText    ( cText ) INLINE ::cText := cText, ::oWnd:Resize()
      METHOD SetTooltip ( cTooltip, cBmpLeft, cHeader, cBmpHeader, cBody, cBmpBody, lBtnClose )
      METHOD nLen       ( ) INLINE len(::aItems)
      METHOD oGetOver   ( nRow, nCol )


ENDCLASS

*********************************************************************************************************
  METHOD New( oWnd, cText, cImage, bAction )  CLASS TVistaMenuItem
*********************************************************************************************************

   ::oWnd        := oWnd
   ::cText       := cText
   ::cImage      := cImage
   ::bAction     := bAction
   ::aItems      := {}
   ::rcItem      := {0,0,0,0}
   ::rcItemL1    := {0,0,0,0}
   ::hBmp        := 0
   ::nID         := ::GetNewID()

   ::LoadImage( ::cImage )

return self

*********************************************************************************************************
  METHOD AddItem( cText, cImage, bAction ) CLASS TVistaMenuItem
*********************************************************************************************************

local oItem := TVistaMenuItem():New( ::oWnd, cText, cImage, bAction )

oItem:lEnable := ::lEnable

aadd(::aItems, oItem )

return oItem

*********************************************************************************************************
   METHOD DelItem( nItem ) CLASS TVistaMenuItem
*********************************************************************************************************

  if nItem < 1 .or. nItem > ::nLen()
     MsgStop( "Índice fuera de rango al borrar elementos","Atención")
     return 0
  endif

  adel ( ::aItems,  nItem     )
  asize( ::aItems, ::nLen()-1 )

  ::oWnd:Resize()

return 0

*********************************************************************************************************
  METHOD Destroy() CLASS TVistaMenuItem
*********************************************************************************************************
local nLen := ::nLen()
local n

if ::hBmp != 0
   DeleteObject( ::hBmp )
endif

if nLen > 0
   for n := 1 to nLen
       ::aItems[n]:Destroy()
   next
endif

return 0

***********************************************************************************************************************
      METHOD Disable() CLASS TVistaMenuItem
***********************************************************************************************************************
local nLen := ::nLen()
local n

::lEnable := .f.

if nLen > 0
   for n := 1 to nLen
       ::aItems[n]:lEnable := .f.
   next
endif

::Refresh()

return ::lEnable

***********************************************************************************************************************
      METHOD Enable() CLASS TVistaMenuItem
***********************************************************************************************************************
local nLen := ::nLen()
local n

::lEnable := .t.

if nLen > 0
   for n := 1 to nLen
       ::aItems[n]:lEnable := .t.
   next
endif

::Refresh()

return ::lEnable

*********************************************************************************************************
  METHOD InsertItem( n, cText, cImage, bAction ) CLASS TVistaMenuItem
*********************************************************************************************************

local oItem := TVistaMenuItem():New( ::oWnd, cText, cImage, bAction, self )

oItem:lEnable := ::lEnable

aadd( ::aItems, nil )
ains( ::aItems, n )
::aItems[n] := oItem

::oWnd:Resize()

return oItem


*********************************************************************************************************
  METHOD LoadImage( cImage ) CLASS TVistaMenuItem
*********************************************************************************************************
local nFormat := 0

if ::hBmp != 0
   DeleteObject( ::hBmp )
   ::hBmp := 0
endif

::cImage := cImage

if empty( ::cImage )
   ::hBmp := 0
   ::nHImage := 0
   ::nWImage := 0
   return 0
endif

if ValType( ::cImage ) == 'C' .and. '.' $ ::cImage
   if Lower( cFileExt( ::cImage ) ) == 'bmp'
      ::hBmp := ReadBitmap( 0, ::cImage )
   else
      ::hBmp := FILoadImg( ::cImage, @nFormat )
   endif
else
   ::hBmp := LoadBitmap( GetResources(), ::cImage )
endif

if ::hBmp == 0
   ::nHImage := 0
   ::nWImage := 0
   return 0
endif

::nHImage := nBmpHeight( ::hBmp )
::nWImage := nBmpWidth ( ::hBmp )

::lHasAlpha := HasAlpha(::hBmp)


return ::hBmp

*********************************************************************************************************
  METHOD Paint( hDC, lSelected, lFocus, lLast ) CLASS TVistaMenuItem
*********************************************************************************************************
local hFont, hOldFont
local nClrText
local nColor
local nTop     := ::rcItem[1]
local nLeft    := ::rcItem[2]
local nBottom  := ::rcItem[3]
local nRight   := ::rcItem[4]
local lDelFont := .f.
local hOldBrush, hPen, hOldPen, oBrush

if ::lLevel1
   hFont    := ::oWnd:oFont:hFont
   nClrText := ::oWnd:nClrText
else
   hFont    := ::oWnd:oFont2:hFont
   nClrText := ::oWnd:nClrText2
endif

if ::lEnable .and. PtInRect( ::oWnd:nRow, ::oWnd:nCol, ::rcItem )
   hFont := CreateFontUnderline( hFont )
   lDelFont := .t.
   if ::lLevel1
      nClrText := ::oWnd:nClrTextOver1
   else
      nClrText := ::oWnd:nClrTextOver2
   endif
endif

if lSelected .and. ::lEnable
   hPen    := CreatePen( PS_SOLID, 1, ::oWnd:nClrBorderOver )
   hOldPen := SelectObject( hDC, hPen )

   oBrush := TBrushEx():New( 3, ::rcItemL1[3]-::rcItemL1[1] ,::oWnd:nClrPaneOver, ::oWnd:nClrPaneOver2, .t. )
   hOldBrush := SelectObject( hDC, oBrush:hbrush)

   SetBrushOrg( hDC, oBrush:hBrush, ::rcItemL1[2], ::rcItemL1[1] )

   C5RoundRect( hDC, ::rcItemL1[1], ::rcItemL1[2]+2, ::rcItemL1[3], ::rcItemL1[4]-2, 5, 5 )
   C5RoundBox ( hDC, ::rcItemL1[2]+3, ::rcItemL1[1]+1, ::rcItemL1[4]-3, ::rcItemL1[3]-1, 6, 6, ::oWnd:nClrBorderOver2 )

   SelectObject( hDC, hOldPen )
   SelectObject( hDC, hOldBrush )
   DeleteObject( hPen )
   oBrush:End()

endif

if lFocus .and. ::oWnd:lKeyDown
   if ::lLevel1 .or. (!::lLevel1 .and. ::oWnd:nType == 1 )
      DrawFocusRect( hDC, nTop, nLeft-5, nBottom, nRight+5 )
   else
      DrawFocusRect( hDC, nTop-2, nLeft-5, nBottom-2, nRight-15 )
   endif
endif


hOldFont := SelectObject( hDC, hFont )

if !::lEnable
   nColor   := SetTextColor( hDC, CLR_HGRAY )
else
   nColor   := SetTextColor( hDC, nClrText )
endif



if ::hBmp != 0
   if ::lHasAlpha
      ABPaint( hDC, nLeft-::oWnd:nWLeftImage+10, nTop, ::hBmp, ::nAlphaLevel )
   else
      DrawMasked( hDC, ::hBmp, nTop, nLeft-::oWnd:nWLeftImage+10 )
   endif
endif

//if ::lLevel1
//   nLeft += ::oWnd:nWLeftImage
//endif

if ::lLevel1 .or. (!::lLevel1 .and. ::oWnd:nType == 1 )
   DrawMText( hDC, ::cText , {nTop,nLeft,nBottom,nRight} )
else
   DrawText( hDC, ::cText , {nTop,nLeft,nBottom,nRight}, 32 )
   if !lLast
      Linea( hDC, nTop+1, nRight-11, nBottom-1, nRight-11, rgb( 207,207,207))
   endif
endif


SelectObject( hDC, hOldFont )
SetTextColor( hDC, nColor   )


if lDelFont
   DeleteObject( hFont )
endif

return 0



***********************************************************************************************************************
  METHOD SetTooltip( cTooltip, cBmp, cHeader, cBmpHeader, cFoot, cBmpFoot, cBtnClose ) CLASS TVistaMenuItem
***********************************************************************************************************************


::cTHeader    := cHeader
::cTooltip    := cTooltip
::cTFoot      := cFoot
::cTBmpHeader := cBmpHeader
::cTBmpLeft   := cBmp
::cTBmpFoot   := cBmpFoot
::cTBtnClose  := cBtnClose

return 0



*********************************************************************************************************
   METHOD oGetOver( nRow, nCol ) CLASS TVistaMenuItem
*********************************************************************************************************
local n
local nLen  := ::nLen()
local oOver

for n := 1 to nLen
    if ::aItems[n]:lEnable .and. PtInRect( nRow, nCol, ::aItems[n]:rcItemL1 )
       oOver := ::aItems[n]
       exit
    endif
next

return oOver

*********************************************************************************************************
static function Linea( hDC, nTop, nLeft, nBottom, nRight, nColor, nWPen, nStyle )
*********************************************************************************************************

local hPen, hOldPen

DEFAULT nWPen  := 1
DEFAULT nColor := 0
DEFAULT nStyle := PS_SOLID

hPen := CreatePen( nStyle, nWPen, nColor )

hOldPen := SelectObject( hDC, hPen )
MoveTo( hDC, nLeft, nTop )
LineTo( hDC, nRight, nBottom )

SelectObject( hDC, hOldPen )

DeleteObject( hPen )

return 0

*********************************************************************************************************

#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"

void DrawGradientFill( HDC hDC, RECT rct, COLORREF crStart, COLORREF crEnd, int nSegments, int bVertical )
{
        // Get the starting RGB values and calculate the incremental
        // changes to be applied.

        COLORREF cr;
        int nR = GetRValue(crStart);
        int nG = GetGValue(crStart);
        int nB = GetBValue(crStart);

        int neB = GetBValue(crEnd);
        int neG = GetGValue(crEnd);
        int neR = GetRValue(crEnd);


        int nDiffR = (neR - nR);
        int nDiffG = (neG - nG);
        int nDiffB = (neB - nB);

        int ndR = 256 * (nDiffR) / (max(nSegments,1));
        int ndG = 256 * (nDiffG) / (max(nSegments,1));
        int ndB = 256 * (nDiffB) / (max(nSegments,1));

        int nCX = (rct.right-rct.left) / max(nSegments,1);
        int nCY = (rct.bottom-rct.top) / max(nSegments,1);
        int nTop = rct.top;
        int nBottom = rct.bottom;
        int nLeft = rct.left;
        int nRight = rct.right;

        HPEN hPen;
        HPEN hOldPen;
        HBRUSH hBrush;
        HBRUSH pbrOld;

        int i;

        if(nSegments > ( rct.right - rct.left ) )
                nSegments = ( rct.right - rct.left );


        nR *= 256;
        nG *= 256;
        nB *= 256;

        hPen    = CreatePen( PS_NULL, 1, 0 );
        hOldPen = (HPEN) SelectObject( hDC, hPen );

        for (i = 0; i < nSegments; i++, nR += ndR, nG += ndG, nB += ndB)
        {
                // Use special code for the last segment to avoid any problems
                // with integer division.

                if (i == (nSegments - 1))
                {
                        nRight  = rct.right;
                        nBottom = rct.bottom;
                }
                else
                {
                        nBottom = nTop + nCY;
                        nRight = nLeft + nCX;
                }

                cr = RGB(nR / 256, nG / 256, nB / 256);

                {

                        hBrush = CreateSolidBrush( cr );
                        pbrOld = (HBRUSH) SelectObject( hDC, hBrush );

                        if( bVertical )
                           Rectangle(hDC, rct.left, nTop, rct.right, nBottom + 1 );
                        else
                           Rectangle(hDC, nLeft, rct.top, nRight + 1, rct.bottom);

                        (HBRUSH) SelectObject( hDC, pbrOld );
                        DeleteObject( hBrush );
                }

                // Reset the left side of the drawing rectangle.

                nLeft = nRight;
                nTop = nBottom;
        }

        (HPEN) SelectObject( hDC, hOldPen );
        DeleteObject( hPen );
}


HB_FUNC( DRAWGRADIENTFILL )
{
        RECT rct;

        rct.top    = hb_parni( 2, 1 );
        rct.left   = hb_parni( 2, 2 );
        rct.bottom = hb_parni( 2, 3 );
        rct.right  = hb_parni( 2, 4 );

        DrawGradientFill( ( HDC ) hb_parnl( 1 ) , rct, hb_parnl( 3 ), hb_parnl( 4 ), hb_parni(5), hb_parl( 6 ) );

}


HB_FUNC( GETSIZETEXT )
{
   HDC hDC = ( HDC ) hb_parnl( 1 );
   SIZE sz;
   GetTextExtentPoint32( hDC, hb_parc( 2 ), hb_parclen( 2 ), &sz );
   hb_reta(2);
   hb_storni( sz.cx, -1, 1 );
   hb_storni( sz.cy, -1, 2 );
}
HB_FUNC( C5ROUNDRECT )
{

  hb_parl( RoundRect( (HDC) hb_parnl( 1 ), hb_parni( 3 ), hb_parni( 2 ), hb_parni( 5 ), hb_parni( 4 ), hb_parni( 6 ), hb_parni( 7 )  ));

}
HB_FUNC( C5ROUNDBOX )

{
   HBRUSH hBrush = (HBRUSH) GetStockObject( 5 );
   HBRUSH hOldBrush = (HBRUSH) SelectObject( (HDC) hb_parnl( 1 ), hBrush );
   HPEN hPen = CreatePen( PS_SOLID, 1, (COLORREF)hb_parnl( 8 ));
   HPEN hOldPen = (HPEN) SelectObject( (HDC) hb_parnl( 1 ), hPen );

   hb_retl( RoundRect( ( HDC ) hb_parnl( 1 ),
                               hb_parni( 2 ),
                               hb_parni( 3 ),
                               hb_parni( 4 ),
                               hb_parni( 5 ),
                               hb_parni( 6 ),
                               hb_parni( 7 ) ) );

   SelectObject( (HDC) hb_parnl( 1 ), hOldBrush );
   SelectObject( (HDC) hb_parnl( 1 ), hOldPen );
   DeleteObject( hPen );

}

#pragma ENDDUMP



