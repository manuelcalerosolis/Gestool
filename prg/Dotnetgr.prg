#include "fivewin.ch"
#include "oficebar.ch"

#ifdef __XHARBOUR__
   #define hb_CurDrive CurDrive
#endif   

CLASS TDotNetGroup

      CLASS VAR nInitId     AS NUMERIC INIT 100 SHARED

      DATA aColumns         AS ARRAY   INIT {}
      DATA aCoors           AS ARRAY   INIT {0,0,0,0}
      DATA aItems           AS ARRAY   INIT {}
      DATA aSize            AS ARRAY   INIT {0,0}
      DATA bAction
      DATA bSelected                              // for designed time
      DATA cBmpClosed       AS CHARACTER INIT ""
      DATA cName            AS CHARACTER INIT "oGrupo"
      DATA cPrompt
      DATA lByColumns       AS LOGICAL INIT .F.
      DATA lByLines         AS LOGICAL INIT .F.
      DATA lVisible
      DATA nID
      DATA nLines           AS NUMERIC INIT 2
      DATA nStyle
      DATA oCarpeta
      DATA rcBtnAction      AS ARRAY INIT {0,0,0,0}
      DATA nWAjustado       AS NUMERIC INIT 50
      DATA lAgrupado        AS LOGICAL INIT .F.

      METHOD New( oCarpeta, nWidth, cPrompt, lByLines, bAction, cBmpClosed ) CONSTRUCTOR

      METHOD AddButton( oControl, nColumna, lGrouping, lHead, lEnd )
      METHOD ClonGrupo( nRow, nCol )
      METHOD Copy()
      METHOD Delete()
      METHOD Edit()
      METHOD GenPrg()
      METHOD GetNewId()                               INLINE If( ::nInitId == nil, ::nInitId := 100,), ++::nInitId
      METHOD GetText()                                INLINE ::cPrompt
      METHOD Hide()
      METHOD IsOver( nRow, nCol )                     INLINE PtInRect( nRow, nCol, ::aCoors )
      METHOD IsOverAcc( nRow, nCol )                  INLINE PtInRect( nRow, nCol, ::rcBtnAction )
      METHOD Paint( hDC, lFromPopup )
      METHOD PaintSmall( hDC )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD Refresh()                                INLINE ::oParent:Refresh()
      METHOD ResizeCols()
      METHOD ResizeItems()
      METHOD ResizeLines()
      METHOD SetText( cItem )                         INLINE ::cPrompt := cItem
      METHOD Show()
      METHOD SizeCapSm()
      METHOD lAjustado()
      METHOD nBottom( nNewVal )                       SETGET
      METHOD nHeight( nNewVal )                       SETGET
      METHOD nLeft  ( nNewVal )                       SETGET
      METHOD nRight ( nNewVal )                       SETGET
      METHOD nTop   ( nNewVal )                       SETGET
      METHOD nWidth ( nNewVal )                       SETGET
      METHOD oBtnOver( nRow, nCol )
      METHOD oParent  INLINE ::oCarpeta:oParent
      METHOD Paste()


ENDCLASS

************************************************************************************************
  METHOD New( oCarpeta, nWidth, cPrompt, lByLines, bAction, cBmpClosed ) CLASS TDotNetGroup
************************************************************************************************

local nTop, nLeft, nBottom, nRight
local nLen

  if lByLines == nil; lByLines := .f.; endif

  DEFAULT cBmpClosed := ""

  ::cPrompt    := cPrompt
  ::lByLines   := lByLines
  ::lByColumns := if( lByLines != nil, !lByLines, nil )
  ::bAction    := bAction
  ::cBmpClosed := cBmpClosed

  ::oCarpeta   := oCarpeta
  ::nId        := ::GetNewId()

  nTop := ::oParent:nHTabs+3
  nLen := len( ::oCarpeta:aGrupos )

  if nLen == 0
     nLeft := 6
  else
     nLeft   := ::oCarpeta:aGrupos[nLen]:aCoors[4]+3
  endif

  nBottom := ::oParent:nHeight-3
  nRight  := nWidth + nLeft

  ::aCoors     := {nTop, nLeft, nBottom, nRight}
  ::aSize      := {nWidth, nBottom-nTop}

  aadd( ::oCarpeta:aGrupos, self )

return self

*****************************************************************************************
  METHOD Paint( hDC, lFromPopup ) CLASS TDotNetGroup
*****************************************************************************************

local nTop, nBottom, nLeft, nRight
local oFont, hOldFont, hFont
local nColor, nMode
local hBmp
local n, nLen
local nClrBar1     := ::oParent:oColor:nClrBar1
local nClrBar20    := ::oParent:oColor:nClrBar20
local nClrBar200   := ::oParent:oColor:nClrBar200
local nClrBar21    := ::oParent:oColor:nClrBar21
local nClrBTitle   := ::oParent:oColor:nClrBTitle
local nClrBTitle2  := ::oParent:oColor:nClrBTitle2
local lSelected    := .f.
local hBmpBtn
local nHeight      := ::rcBtnAction[3]-::rcBtnAction[1]
local nH5          := nHeight/5
local n2H5         := nH5*2
local n3H5         := n2H5 + nH5
local rc
local lIsOver      := .f.
local aPoint := {::oParent:nRow, ::oParent:nCol }
local lAjustado    := .f.

if lFromPopup == nil; lFromPopup := .f. ; endif


if !lFromPopup

   ::lAgrupado     := ::lAjustado()

   // revision 09.12.06     V1.01
   lSelected :=  ::IsOver( aPoint[1], aPoint[2] )    //.and. GetActiveWindow() == ::oParent:oWnd:hWnd // IsOverWnd(::oWnd:hWnd, aPoint[1], aPoint[2] )
   lIsOver   :=  ::IsOverAcc( aPoint[1], aPoint[2] ) //.and. GetActiveWindow() == ::oParent:oWnd:hWnd

   if lSelected
      nClrBar1     := ::oParent:oColor:nClrBar11
      nClrBar20    := ::oParent:oColor:nClrBar201
      nClrBar21    := ::oParent:oColor:nClrBar211
      nClrBTitle   := ::oParent:oColor:nClrBTitle1
   endif

endif

if ::oParent:oFont != nil
   hFont := ::oParent:oFont:hFont
else
   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-12.3
   hFont := oFont:hFont                                 //hFont := GetStockObject( DEFAULT_GUI_FONT )
endif

hOldFont := SelectObject( hDC, hFont )
nColor := SetTextColor( hDC, ::oParent:oColor:_CLRTEXTBACK )
nMode := SetBkMode( hDC, 1 )


if ::lAgrupado

   ::PaintSmall( hDC, lSelected, lIsOver )

else

   nTop    := ::nTop()
   nLeft   := ::nLeft()
   nBottom := ::nBottom()
   nRight  := ::nRight()

   FillSolidRect   ( hDC, {nTop   ,nLeft,nTop+15   ,nRight}, nClrBar1 )

   VerticalGradient( hDC, {nTop+14,nLeft,nBottom-15,nRight}, nClrBar20, nClrBar200  )
   VerticalGradient( hDC, {nBottom-16, nLeft, nBottom-1,nRight  }, nClrBTitle, nClrBTitle2 )

   DrawText( hDC, ::cPrompt, {nBottom-15, nLeft, nBottom,nRight}, nOr( DT_SINGLELINE, DT_VCENTER, DT_CENTER, DT_NOPREFIX ) )

endif

SetBkMode( hDC, nMode )
SetTextColor( hDC, nColor )
SelectObject( hDC, hOldFont )

if ::bAction != nil .and. !::lAgrupado

   ::rcBtnAction := { nBottom-12, nRight - 14, nBottom-2, nRight - 4}

   rc      := { nBottom-12-3, nRight - 14-3+2, nBottom-2, nRight - 4+2}

   if lIsOver //.and. ::oWnd:lEnabled   //rc   := { nT+5-3, nL-4, nT+5+nH+3, nL+nW+4 }   //hScr := SaveScreen( ::oWnd:hDC, rc[1], rc[2], rc[3], rc[4] )

      Box( hDC,              {rc[1]             ,rc[2]+1,rc[3]              ,rc[4]-1}, RGB( 221,207,155) )

         VerticalGradient( hDC, {rc[1]             ,rc[2]+1,rc[1]+n2H5         ,rc[4]  }, ::oParent:oColor:nGradientGrp1, ::oParent:oColor:nGradientGrp11 )
         VerticalGradient( hDC, {rc[1]+ n2H5 -1    ,rc[2]+1,rc[1]+n3H5         ,rc[4]  }, ::oParent:oColor:nGradientGrp2, ::oParent:oColor:nGradientGrp21 )
         VerticalGradient( hDC, {rc[1]+ n3H5 -1    ,rc[2]+1,rc[3]              ,rc[4]  }, ::oParent:oColor:nGradientGrp3, ::oParent:oColor:nGradientGrp31 )   //RestoreScreen( hDC, hScr, rc[1], rc[2] )   //DeleteObject( hScr )

   endif
   hBmpBtn := BmpBtnDBar()
   DrawMasked( hDC, hBmpBtn, nBottom-12, nRight - 14+2 )
   DeleteObject( hBmpBtn )

endif

if oFont != nil
   oFont:End()
endif

nLen := len( ::aItems )

if !::lAgrupado

   if ::oParent:isPopup
      nLeft -= 5
      nBottom += 2
      nRight ++
   endif

   do case
      case ::oParent:oColor:nStyle == 1
           Line( hDC,  nTop+2, nRight-1, nBottom, nRight-1,::oParent:oColor:nClrSeparador1 )
           // Box( hDC,  nTop+2, nRight-1, nBottom, nRight-1,::oParent:oColor:nClrSeparador1 )
           VerticalGradient( hDC, {nTop+2, nRight, nBottom+1, nRight+1}, ::oParent:oColor:nClrSeparador11, ::oParent:oColor:nClrSeparador21 )
      otherwise
           RoundBox( hDC, nLeft+1,nTop+1, nRight+1, nBottom, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:_GRISBOX2 )
           RoundBox( hDC, nLeft,nTop, nRight, nBottom, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:_GRISBOX1 )
   endcase

   for n := 1 to nLen
       if "TDOTNET" $ ::aItems[n]:ClassName()
          ::aItems[n]:Paint( hDC )
       endif
   next
endif

return 0


***********************************************************************************************************************
   METHOD PaintSmall( hDC, lSelected, lIsOver ) CLASS TDotNetGroup
***********************************************************************************************************************
local nTop, nLeft, nBottom, nRight
local nClrBar1     := ::oParent:oColor:nClrBar1
local nClrBar20    := ::oParent:oColor:nClrBar20
local nClrBar200   := ::oParent:oColor:nClrBar200
local nClrBar21    := ::oParent:oColor:nClrBar21
local nClrBTitle   := ::oParent:oColor:nClrBTitle
local nClrBTitle2  := ::oParent:oColor:nClrBTitle2

local n, nLen
local oItem, hBmp
local hBmp2
local nH := 0
local nW := 0
local nHeight

   if lSelected
      nClrBar1     := ::oParent:oColor:nClrBar11
      nClrBar20    := ::oParent:oColor:nClrBar201
      nClrBar21    := ::oParent:oColor:nClrBar211
      nClrBTitle   := ::oParent:oColor:nClrBTitle1
   endif

   nTop    := ::aCoors[1]; nLeft   := ::aCoors[2]; nBottom := ::aCoors[3]; nRight  := ::aCoors[4]

   do case
      case ::oParent:oColor:nStyle == 1
           FillSolidRect   ( hDC, {nTop   ,nLeft,nTop+15   ,nRight}, nClrBar1 )

           VerticalGradient( hDC, {nTop+14,nLeft,nBottom-15,nRight}, nClrBar20, nClrBar200  )
           VerticalGradient( hDC, {nBottom-16, nLeft, nBottom-1,nRight  }, nClrBTitle, nClrBTitle2 )

      otherwise
           FillSolidRect   ( hDC, {nTop   ,nLeft,nTop+15,nRight},nClrBar1 )
           VerticalGradient( hDC, {nTop+14,nLeft,nBottom,nRight},nClrBar20, nClrBar1  )
   endcase

   nTop    := nTop  + 6
   nLeft   := nLeft + (( nRight - nLeft )/2) - 16
   nBottom := nTop  + 32
   nRight  := nLeft + 32

   // boton
   do case
      case ::oParent:oColor:nStyle == 1
           FillSolidRect   ( hDC, { nTop,   nLeft+2, nBottom, nRight }, if( lSelected, ::oParent:oColor:nClrBar1, ::oParent:oColor:nClrBar1 ))
      otherwise
           FillSolidRect   ( hDC, { nTop,   nLeft+2, nTop+2   , nRight-2 }, if( lSelected, ::oParent:oColor:nGradientGrp01, ::oParent:oColor:nGradientGrp011 ))
           FillSolidRect   ( hDC, { nTop+ 3,nLeft  , nBottom-8, nRight   }, if( lSelected, ::oParent:oColor:nGradientGrp02, ::oParent:oColor:nGradientGrp021 ))
           FillSolidRect   ( hDC, { nBottom-8,nLeft  , nBottom, nRight   }, nClrBTitle )
   endcase
   RoundBox     ( hDC, nLeft, nTop, nRight, nBottom, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:_GRISBOX1 )

   if ::cBmpClosed != nil
      if valtype( ::cBmpClosed ) == "C" .and. "." $ ::cBmpClosed
         hBmp := ReadBitmap( 0, ::cBmpClosed )
      else
         hBmp := LoadBitmap( GetResources(), ::cBmpClosed )
       endif
   else

   endif

   if hBmp != 0
      nH := BmpHeight( hBmp )
      nW := BmpWidth ( hBmp )
      DrawMasked( hDC, hBmp, nTop + 16 - nH/2, nLeft + 16 - nW/2 )
      DeleteObject( hBmp )
   endif

   nTop    := ::aCoors[1]; nLeft   := ::aCoors[2]; nBottom := ::aCoors[3]; nRight  := ::aCoors[4]

   do case
      case ::oParent:oColor:nStyle == 1
      otherwise
           RoundBox( hDC, nLeft+1,nTop+1, nRight+1, nBottom, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:_GRISBOX2 )
           RoundBox( hDC, nLeft,nTop, nRight, nBottom, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:_GRISBOX1 )
   endcase

   do case
      case ::oParent:oColor:nStyle == 1
           Line( hDC,  nTop+2, nRight-1, nBottom, nRight-1,::oParent:oColor:nClrSeparador1 )
           // Box( hDC,  nTop+2, nRight-1, nBottom, nRight-1,::oParent:oColor:nClrSeparador1 )
           VerticalGradient( hDC, {nTop+2, nRight, nBottom+1, nRight+1}, ::oParent:oColor:nClrSeparador11, ::oParent:oColor:nClrSeparador21 )
   endcase

   nTop    := ::aCoors[1]; nLeft   := ::aCoors[2]; nBottom := ::aCoors[3]; nRight  := ::aCoors[4]
   nTop += 42
   nLeft += 4
   nRight -= 4
   nBottom = nTop + 40

   nHeight := DrawText( hDC, ::cPrompt, { nTop, nLeft, nBottom,nRight}, nOr( DT_CENTER, DT_WORDBREAK  ) )

   hBmp := BmpArrowDownNet()
   if hBmp != 0
      nTop += nHeight + 8
      nLeft := nLeft + (( nRight-nLeft ) / 2) - 4
      Drawmasked( hDC, hBmp, nTop, nLeft )
      DeleteObject( hBmp )
   endif

return 0


***********************************************************************************************************************
   METHOD Hide() CLASS TDotNetGroup
***********************************************************************************************************************
local n
local nLen := len(::aItems)
for n := 1 to nLen
    ::aItems[n]:Hide()
next


return 0

***********************************************************************************************************************
   METHOD Show() CLASS TDotNetGroup
***********************************************************************************************************************
local n
local nLen := len(::aItems)
for n := 1 to nLen
    ::aItems[n]:Show()
next

return 0


****************************************************************************************
  METHOD nTop   ( nNewVal ) CLASS TDotNetGroup
****************************************************************************************

if nNewVal != nil
   ::aCoors[1] := nNewVal
endif

return ::aCoors[1]


****************************************************************************************
  METHOD nLeft  ( nNewVal ) CLASS TDotNetGroup
****************************************************************************************

if nNewVal != nil
   ::aCoors[2] := nNewVal
endif

return ::aCoors[2]

****************************************************************************************
  METHOD nBottom( nNewVal ) CLASS TDotNetGroup
****************************************************************************************

if nNewVal != nil
   ::aCoors[3] := nNewVal
endif

return ::aCoors[3]

****************************************************************************************
  METHOD nRight ( nNewVal ) CLASS TDotNetGroup
****************************************************************************************

if nNewVal != nil
   ::aCoors[4] := nNewVal
endif

return ::aCoors[4]


***********************************************************************************************************************
  METHOD nWidth( nNewVal ) CLASS TDotNetGroup
***********************************************************************************************************************

if nNewVal != nil
   ::aCoors[4] := ::aCoors[2] + nNewVal
endif

return ::aCoors[4]-::aCoors[2]

***********************************************************************************************************************
  METHOD nHeight( nNewVal ) CLASS TDotNetGroup
***********************************************************************************************************************

if nNewVal != nil
   ::aCoors[3] := ::aCoors[1] + nNewVal
endif

return ::aCoors[3]-::aCoors[1]


***********************************************************************************************************************
  METHOD SizeCapSm() CLASS TDotNetGroup
***********************************************************************************************************************
local oFont, hOldFont, hFont
local aRect := {::aCoors[1]+43, ::aCoors[2]+3, ::aCoors[3],::aCoors[2]+60-3}
local nWidth, nHeight, nHeight2

local hDC := ::oParent:GetDC()

if ::oParent:oFont != nil
   hFont := ::oParent:oFont:hFont
else
   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -12.3
   hFont := oFont:hFont                                 //hFont := GetStockObject( DEFAULT_GUI_FONT )
endif

hOldFont := SelectObject( hDC, hFont )

nWidth   := GetTextWidth ( hDC, ::cPrompt, hFont )
nHeight  := nWndChrHeight( ::oParent:hWnd, hFont )
nHeight2 := C5DrawText   ( hDC, ::cPrompt, aRect , nOr( DT_CENTER, DT_WORDBREAK, DT_CALCRECT ) )

//::oWnd:oWnd:cTitle := str( nHeight ) + str( nHeight2 ) + str( nWidth )+ str(  aRect[4]-aRect[2] )

SelectObject( hDC, hOldFont )

::oParent:ReleaseDC()

if oFont != nil
   oFont:End()
endif

return { if( nHeight != nHeight2, (aRect[4]-aRect[2])+10, nWidth+10 ), nHeight }



***********************************************************************************************************************
METHOD lAjustado() CLASS TDotNetGroup
***********************************************************************************************************************

return ::nWidth != ::aSize[1]

***********************************************************************************************************************
   METHOD ClonGrupo( nRow, nCol ) CLASS TDotNetGroup
***********************************************************************************************************************
local oWndPopup
local lValid := .f.
local aPoint
local nTop, nLeft, nBottom, nRight
local oBrush
local oThis := self
local oBar, oCarpeta, oGrp
local n, n2, nLen, nLen2
local oBtn, o
local bAction


if !::lAjustado
   return 0
endif

if ::lByColumns == nil
   return 0
endif


nRow := ::nBottom
nCol := ::nLeft

aPoint := {nRow, nCol}

DEFINE BRUSH oBrush STYLE "NULL"

  ClientToScreen( ::oParent:hWnd, aPoint )

  nTop    := aPoint[1]
  nLeft   := aPoint[2]
  nBottom := nTop + ::nHeight()
  nRight  := nLeft + ::aSize[1]

  if nRight > GetSysMetrics(0)
     nLeft := GetSysMetrics(0) - ::aSize[1] - 20
     nRight  := nLeft + ::aSize[1]
  endif

  if othis:oParent:oWndPopup != nil
     othis:oParent:oWPEnd()
  endif

   oWndPopup := TWindowExt1():New( nTop, nLeft, nBottom-1, nRight+7,, nOr( 2147483648 ),, oBrush,, ::oParent,,,,,,, !.F., !.F., !.F., !.F., .T. )

  //oWndPopup:Show()
  //ACTIVATE WINDOW oWndPopup //NOWAIT VALID .f.


     oBar := TDotNetBar():New( 0, -3, nRight-nLeft, nBottom-nTop, oWndPopup )

     oBar:SetStyle( ::oParent:oColor:nStyle )

     oBar:SetFocus()

     oBar:isPopup := .t.

     oWndPopup:oTop := oBar
     oWndPopup:Resize()
     oBar:nOption := 1

     oBar:nHTabs := 0

     oCarpeta  := TCarpeta():New( oBar, ::oCarpeta:cPrompt  )

        oGrp := TDotNetGroup():New(oCarpeta, ::aSize[1], ::cPrompt, ::lByLines, ::bAction )

        if ::lByColumns

           nLen := len( ::aColumns )

           for n := 1 to nLen

               nLen2 := len( ::aColumns[n]:aItems )

               for n2 := 1 to nLen2

                   o             := ::aColumns[n]:aItems[n2]
                   bAction       := o:bAction
                   oBtn          := TDotNetButton():New(  o:nWidth, oGrp, o:cBmp, o:cPrompt,n,bAction, o:oPopup, o:bWhen, o:lGrouping ,o:lHead, o:lEnd )
                   oBtn:oPopup   := o:oPopup

               next

           next

        else

           nLen  := len( ::aItems )

           for n := 1 to nLen
               o           := ::aItems[n]
               bAction     := o:bAction
               oBtn        := TDotNetButton():New(   o:nWidth, oGrp, o:cBmp, o:cPrompt,, bAction, o:oPopup, o:bWhen, o:lGrouping ,o:lHead, o:lEnd  )
               oBtn:oPopup := o:oPopup
           next

        endif

     oBar:nOption := 1

  oBar:bKeyDown      := {|nKey| if( nKey == VK_ESCAPE, (othis:oParent:oWndPopup:bValid := {||.t.},othis:oParent:oWPEnd()),.f.)}
  oWndPopup:bLostFocus := {|| oWndPopup:End() }

  oWndPopup:Show()

return 0

***********************************************************************************************
      METHOD oBtnOver( nRow, nCol ) CLASS TDotNetGroup
***********************************************************************************************
local n
local nLen := len( ::aItems )
local o := nil

for n := 1 to nLen
    o := ::aItems[n]

    // revision 10.12.06     V1.02
    if "TDOTNET" $ o:ClassName() .and. o:IsOver( nRow, nCol )
       return o
    endif
next

return nil


***********************************************************************************************
  METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TDotNetGroup
***********************************************************************************************
local oPopup
local o := self
local nSize, n, nLen
local oClp
local lPaste := .f.
local cInfo := ""

  DEFINE CLIPBOARD oClp FORMAT TEXT

  if oClp:Open()
     cInfo := oClp:GetText()
     oClp:End()
  endif

  lPaste := at("tdotnetgroup",lower(cInfo) ) == 0 .and. at("tdotnetbutton",lower(cInfo) ) != 0

  MENU oPopup POPUP

     if !::lByLines .and. len(::aItems) == 0
        MENUITEM DEFINE_GROUP_BY_LINES   ACTION ( o:lByLines := .t., o:lByColumns := .f. )
     endif
        if ::lByLines
           if !::lAjustado
              MENUITEM ADDBUTTON ACTION ( TDotNetButton():New( 60, o,,"item",,,,,.T.) ,o:oParent:Refresh())
           endif
        else

               n := len( ::aColumns )
               if n >= 0
                  MENUITEM ADDBUTTONCOL1 ACTION ( TDotNetButton():New( 60, o,,"New item",  1)  ,o:oParent:Refresh())
               endif
               if n >= 1
                  MENUITEM ADDBUTTONCOL2 ACTION ( TDotNetButton():New( 60, o,,"New item",  2)  ,o:oParent:Refresh())
               endif
               if n >= 2
                  MENUITEM ADDBUTTONCOL3 ACTION ( TDotNetButton():New( 60, o,,"New item",  3)  ,o:oParent:Refresh())
               endif
               if n >= 3
                  MENUITEM ADDBUTTONCOL4 ACTION ( TDotNetButton():New( 60, o,,"New item",  4)  ,o:oParent:Refresh())
               endif
               if n >= 4
                  MENUITEM ADDBUTTONCOL5 ACTION ( TDotNetButton():New( 60, o,,"New item",  5)  ,o:oParent:Refresh())
               endif
               if n >= 5
                  MENUITEM ADDBUTTONCOL6 ACTION ( TDotNetButton():New( 60, o,,"New item",  6)  ,o:oParent:Refresh())
               endif
               if n >= 6
                  MENUITEM ADDBUTTONCOL7 ACTION ( TDotNetButton():New( 60, o,,"New item",  7)  ,o:oParent:Refresh())
               endif
               if n >= 7
                  MENUITEM ADDBUTTONCOL8 ACTION ( TDotNetButton():New( 60, o,,"New item",  8)  ,o:oParent:Refresh()) BREAK
               endif
               if n >= 8
                  MENUITEM ADDBUTTONCOL9 ACTION ( TDotNetButton():New( 60, o,,"New item",  9)  ,o:oParent:Refresh())
               endif
               if n >= 9
                  MENUITEM ADDBUTTONCOL10 ACTION ( TDotNetButton():New( 60, o,,"New item", 10)  ,o:oParent:Refresh())
               endif
               if n >= 10
                  MENUITEM ADDBUTTONCOL11 ACTION ( TDotNetButton():New( 60, o,,"New item", 11)  ,o:oParent:Refresh())
               endif
               if n >= 11
                  MENUITEM ADDBUTTONCOL12 ACTION ( TDotNetButton():New( 60, o,,"New item", 12)  ,o:oParent:Refresh())
               endif
               if n >= 12
                  MENUITEM ADDBUTTONCOL13 ACTION ( TDotNetButton():New( 60, o,,"New item", 13)  ,o:oParent:Refresh())
               endif
               if n >= 13
                  MENUITEM ADDBUTTONCOL14 ACTION ( TDotNetButton():New( 60, o,,"New item", 14)  ,o:oParent:Refresh())
               endif
        endif

     if ::lAjustado
        MENUITEM SELECTIMAGE ACTION ( o:cBmpClosed := cGetFile("*.bmp", SELECTIMAGE ), o:oParent:Refresh())
     else
        SEPARATOR
        MENUITEM CHANGESIZE   ACTION ( nSize := o:aSize[1], DlgChangeSize( @nSize, .t.  ), o:aSize[1] := nSize, o:ResizeItems(),o:oParent:Resize() )
        MENUITEM DELETEGROUP  ACTION (::oParent:lWorking := .t.,o:Delete())
        MENUITEM if( o:bAction != nil, RESETACTION,ADDACTION ) ACTION ( if( o:bAction == nil, o:bAction := __MiAccion(), o:bAction := nil ), o:oParent:Refresh())
        SEPARATOR
        MENUITEM "Copy"  ACTION o:Copy()
        if lPaste
           MENUITEM "Paste"
           MENU
               n := len( ::aColumns )
               if n >= 0
                  MENUITEM ADDBUTTONCOL1 ACTION o:Paste( 1 )
               endif
               if n >= 1
                  MENUITEM ADDBUTTONCOL2 ACTION o:Paste( 2 )
               endif
               if n >= 2
                  MENUITEM ADDBUTTONCOL3 ACTION o:Paste( 3 )
               endif
               if n >= 3
                  MENUITEM ADDBUTTONCOL4 ACTION o:Paste( 4 )
               endif
               if n >= 4
                  MENUITEM ADDBUTTONCOL5 ACTION o:Paste( 5 )
               endif
               if n >= 5
                  MENUITEM ADDBUTTONCOL6 ACTION o:Paste( 6 )
               endif
               if n >= 6
                  MENUITEM ADDBUTTONCOL7 ACTION o:Paste( 7 )
               endif
               if n >= 7
                  MENUITEM ADDBUTTONCOL8 ACTION o:Paste( 8 ) BREAK
               endif
               if n >= 8
                  MENUITEM ADDBUTTONCOL9 ACTION o:Paste( 9 )
               endif
               if n >= 9
                  MENUITEM ADDBUTTONCOL10 ACTION o:Paste( 10 )
               endif
               if n >= 10
                  MENUITEM ADDBUTTONCOL11 ACTION o:Paste( 11 )
               endif
               if n >= 11
                  MENUITEM ADDBUTTONCOL12 ACTION o:Paste( 12 )
               endif
               if n >= 12
                  MENUITEM ADDBUTTONCOL13 ACTION o:Paste( 13 )
               endif
               if n >= 13
                  MENUITEM ADDBUTTONCOL14 ACTION o:Paste( 14 )
               endif

           ENDMENU
        endif
     endif

  ENDMENU
  ACTIVATE POPUP oPopup AT nRow, nCol OF ::oParent

return 0

function __MiAccion()

return {|| MsgInfo( GROUPACTION ) }


***********************************************************************************************
      METHOD ResizeItems() CLASS TDotNetGroup
***********************************************************************************************

if empty( ::aItems )
   return 0
endif

if ::lByLines
   ::ResizeLines()
else
   ::ResizeCols()
endif

return 0


***********************************************************************************************
      METHOD ResizeLines() CLASS TDotNetGroup
***********************************************************************************************

local nHLine := 28
local oLast := nil
local n
local nLen := len( ::aItems )
local oBtn
local nTop
local nLeft
local nBottom
local nRight
local lDotNet
local nWidth

for n := 1 to nLen

    oBtn := ::aItems[n]
    nWidth := oBtn:nWidth

    lDotNet := "TDOTNET" $ oBtn:ClassName()

   if oLast == nil
      nTop     := ::aCoors[1] + 13
      nLeft    := ::aCoors[2] + 5
   else
      if oLast:nRight + 3 + oBtn:nHorizWidth() > ::aCoors[4]
         nTop     := oLast:nTop + nHLine + 3
         nLeft    := ::aCoors[2] + 5
      else
         nTop     := oLast:nTop
         nLeft    := oLast:nRight + if( lDotNet .and. oBtn:lGrouping, if( oBtn:lHead, 3, 0), 3 )
      endif
   endif

   nBottom  := nTop + nHLine - 6

   if lDotNet
      nRight   := nLeft + if( oBtn:lGrouping, oBtn:nHorizWidth(), nWidth )
   else
      nRight   := nLeft + oBtn:nWidth
   endif

   oBtn:nTop    := nTop
   oBtn:nLeft   := nLeft
   oBtn:nBottom := nBottom
   oBtn:nRight  := nRight

   oLast := oBtn

next

if !::oParent:lWorking
   ::oParent:Refresh()
endif

return 0




***********************************************************************************************
      METHOD ResizeCols() CLASS TDotNetGroup
***********************************************************************************************
local n
local nColumna
local nLen := len( ::aColumns )
local nWidth := 0
local nTop
local nLeft := 0
local nBottom
local nRight
local nH
local nHeight := ::nHeight
local oControl

   for nColumna := 1 to len( ::aColumns )

       nLen := len( ::aColumns[nColumna]:aItems )

       // redimensiono los controles

       nH := (nHeight-18) / nLen


       for n := 1 to nLen

           oControl := ::aColumns[nColumna]:aItems[n]
           nWidth := oControl:nWidth

           if n == 1
              nTop := ::aCoors[1] + 3
           else
              nTop := nBottom
           endif

           nBottom := nTop + nH

           if nColumna == 1
              nLeft   := ::aCoors[2] + 3
           else
              nLeft   := ::aColumns[nColumna-1]:aItems[1]:nLeft + ::aColumns[nColumna-1]:MaxWidthOfCol()
           endif

           nRight  := nLeft + nWidth

           if "TDOTNET" $ oControl:ClassName()

              oControl:nTop        := nTop
              oControl:nLeft       := nLeft
              oControl:nBottom     := nBottom
              oControl:nRight      := nRight

              oControl:lHorizontal := nLen > 1

           else

              // revision 10.12.06     V1.02
              SetWindowPos( oControl:hWnd, 0, nTop, nLeft, oControl:nWidth,oControl:nHeight, SWP_SHOWWINDOW )

           endif

        next

   next

return 0


***************************************************************************************************
   METHOD Edit() CLASS TDotNetGroup
***************************************************************************************************
local oFont
local bValid := {||.t.}
local o := self
local uVar
local nTop, nLeft, nWidth, nHeight
local nClrBTitle   := RGB(200,224,255)
uVar := padr(::cPrompt, 100)

nTop    := ::nBottom - 14
nLeft   := ::nLeft + 5
nWidth  := ::nWidth -8
nHeight := ::nBottom - 5

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

   ::oParent:oGet := TGet():New(nTop,nLeft,{ | u | If( PCount()==0, uVar, uVar:= u ) },o:oParent,nWidth,nHeight,,,0,nClrBTitle,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

   ::oParent:nLastKey := 0
   ::oParent:oGet:SetFocus()
   ::oParent:oGet:bValid := {|| .t. }

   ::oParent:oGet:bLostFocus := {||  o:oParent:oGet:Assign(),;
                                  o:oParent:oGet:VarPut( o:oParent:oGet:oGet:VarGet() ),;
                                  o:cPrompt := if( o:oParent:nLastKey != VK_ESCAPE, alltrim(o:oParent:oGet:oGet:VarGet()), o:cPrompt ) ,;
                                  o:oParent:GetCoords(), o:oParent:Refresh() }

   ::oParent:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE, ( o:oParent:nLastKey := nKey, o:oParent:oGet:End()), ) }



return nil



***************************************************************************************************
   METHOD Delete() CLASS TDotNetGroup
***************************************************************************************************
local n
local nLen := len( ::oCarpeta:aGrupos )
local oGrupo
local lDel := .f.

::oParent:lWorking := .t.

for n := 1 to nLen
    oGrupo := ::oCarpeta:aGrupos[n]
    if oGrupo:nId == ::nId
       aeval( ::aItems, {|x| x:End() }   )
       adel ( ::oCarpeta:aGrupos,  n     )
       asize( ::oCarpeta:aGrupos, nLen-1 )
       ::oCarpeta:CalcSizes()
       aeval( ::oCarpeta:aGrupos, {|x| x:ResizeItems() } )
       exit
    endif
next

::oParent:lWorking := .f.
::oParent:Refresh()

return 0

***********************************************************************************************************************
  METHOD AddButton( oControl, nColumna, lGrouping, lHead, lEnd ) CLASS TDotNetGroup
***********************************************************************************************************************
local nTop, nLeft, nBottom, nRight, nHeight, nWidth
local oLast
local nHLine
local n, nLen
local oCtrl
local nH
local nMax := 0
local lDotNet := "TDOTNET" $ oControl:ClassName()
local oCol

DEFAULT lHead     := .f.
DEFAULT lEnd      := .f.
DEFAULT lGrouping := .f.

if valtype( nColumna ) == "C"
   nColumna := val( nColumna )
endif

if nColumna == nil; nColumna := 1 ; endif

nHeight  := ::aCoors[3]-::aCoors[1]
nWidth   := ::aCoors[4]-::aCoors[2]

nHLine   := (nHeight-18) / ::nLines

if !::lByLines .and. nColumna > len( ::aColumns )
   nLen := ( nColumna - len( ::aColumns ))
   for n := 1 to nLen
       oCol := TDotNetColumn():New( self )
   next
endif


oLast := atail(::aItems )
aadd( ::aItems, oControl )

//if lGrouping
//   ::lByLines := .t.
//endif

if !::lByLines
   ::aColumns[nColumna]:AddItem( oControl )
endif

if lDotNet
   lHead             := oControl:lHead
   lEnd              := oControl:lEnd
   lGrouping         := oControl:lGrouping
   oControl:oGrupo   := self
   oControl:nColumna := nColumna
endif

// si es lGrouping ::lByLines tienes que ser true
// calculamos las coordenadas dependiendo de si esta en lineas o en columnas



if ::lByLines

   ::ResizeLines()

else

   ::ResizeCols()

endif

if "TDOTNET" $ oControl:ClassName()
else
    // revision 10.12.06     V1.02
//   SetWindowPos( oControl:hWnd, 0, nTop, nLeft, nRight - nLeft,nBottom - nTop, SWP_SHOWWINDOW )
endif

return 0



***********************************************************************************************************************
  METHOD GenPrg() CLASS TDotNetGroup
***********************************************************************************************************************
local cPrg := ""
local n
local nBtns
local aBtns
local cBtn := ""

::cName := "oGrp" +  alltrim(str(::nId-100))

// falta bAction

::oParent:cVars += "local " + ::cName + CRLF

cPrg := space( 12 ) + ::cName + " := "  +;
         "TDotNetGroup():New( " + ::oCarpeta:cName  + ", " +;
                              alltrim(str(::aSize[1])) +;
                              ', "' + alltrim(::cPrompt) + '", ' +;
                              if ( ::lByLines != nil, if( ::lByLines, ".t.",".f." ),".f.") + ",, " +;
                              '"' + ::cBmpClosed + '"' + " )" + CRLF

nBtns := len( ::aItems )
aBtns := array(nBtns)

for n := 1 to nBtns
    aBtns[n] := ::aItems[n]:GenPrg()
next

for n := 1 to nBtns
    cBtn += aBtns[n]
next


cPrg += cBtn  + CRLF + CRLF

return cPrg

***********************************************************************************************************************
  METHOD Copy() CLASS TDotNetGroup
***********************************************************************************************************************
local cInfo := ::GenPrg()
local oClp


   DEFINE CLIPBOARD oClp FORMAT TEXT

   if oClp:Open()
      oClp:Clear()
      oClp:SetText( cInfo )
      oClp:End()
   else
      msgStop( "The clipboard is not available now!" )
   endif

return nil

***************************************************************************************************
   METHOD Paste( nEnColumna ) CLASS TDotNetGroup
***************************************************************************************************
local cInfo
local aLines := {}
local nLines
local n := 1
local n2
local nEstado := BUSCANDO
local cLinea
local aParams := {}
local cWord
local cObject
local aWords := {{"tdotnetbutton():new(",PARSEANDO_BUTTON } }
local cBar
local aCarpetas := {}
local aGrupos   := {}
local o
local lDefinida := .f.
local oError
local oClp
local lResize := nEnColumna > len( ::aColumns )

   DEFINE CLIPBOARD oClp FORMAT TEXT

   if oClp:Open()
      cInfo := oClp:GetText()
      oClp:End()
   else
      msgStop( "The clipboard is not available now!" )
   endif


if empty( cInfo )
   MsgInfo("Proceso cancelado")
   return 0
endif

nLines := strcount( cInfo, CRLF )

for n := 1 to nLines
    aadd( aLines, memoline( cInfo,255,n) )
next

n := 1

do while n < nLines .and. nEstado != FIN

    cLinea := alltrim(aLines[n])
    cLinea := strtran(cLinea,'"',"")

    if left( lower(cLinea), len( "local "   )) == "local "   ; cLinea := substr( cLinea, len( "local "   )+1); endif
    if left( lower(cLinea), len( "private " )) == "private " ; cLinea := substr( cLinea, len( "private " )+1); endif
    if left( lower(cLinea), len( "public "  )) == "public "  ; cLinea := substr( cLinea, len( "public "  )+1); endif


    nEstado := BUSCANDO

    cWord := ""

    for n2 := 1 to len( aWords )
        cWord := lower(aWords[n2,1])
        if at( cWord, lower(cLinea) ) != 0
           nEstado := aWords[n2,2]
           exit
        endif
    next

       if nEstado != BUSCANDO

          asize( aParams, 0 )                                             // ? cLinea

          cObject := left  ( cLinea, at(":=",cLinea)-1 )                  // ? cObject
          cLinea  := substr( cLinea, at( lower(cWord), lower(cLinea) )+len(cWord)+1 )
          cLinea  := left  ( cLinea, len( cLinea ) - 1 )                  // ? cLinea
          aParams := aSplit( cLinea, "," )                                // wqout( aParams )


          do case
             case nEstado == PARSEANDO_BUTTON
                  //( nTop, nLeft, nWidth, nHeight, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd )
                  //  nWidth, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd


                     //wqout( aParams )
                     o := TDotNetButton():New( val( aParams[1]),;
                                               self,;
                                               alltrim(aParams[3]),;
                                               alltrim(aParams[4]),;
                                               nEnColumna, , , ,;
                                               lower(aParams[9])==".t.",;
                                               lower(aParams[10])==".t.",;
                                               lower(aParams[11])==".t." )
          endcase

       endif


    n++


enddo

if lResize
   ::aSize[1] += o:nWidth + 3
endif

::oCarpeta:CalcSizes()
::oParent:Resize()

for n := 1 to len( ::oCarpeta:aGrupos )
    ::oCarpeta:aGrupos[n]:ResizeItems()
next
::oParent:Resize()


return 0

*********************************************************************************************************************************
*********************************************************************************************************************************
*********************************************************************************************************************************
*********************************************************************************************************************************
*********************************************************************************************************************************

CLASS TWindowExt1 FROM TWindow

      CLASSDATA lRegistered AS LOGICAL

      METHOD Create( clsName )
      METHOD HandleEvent( nMsg, nWParam, nLParam )

ENDCLASS

*********************************************************************************************************************************
METHOD Create( cClsName )  CLASS TWindowExt1
*********************************************************************************************************************************

   DEFAULT cClsName := ::ClassName(), ::cCaption := "",;
           ::nStyle := WS_OVERLAPPEDWINDOW,;
           ::nTop   := 0, ::nLeft := 0, ::nBottom := 10, ::nRight := 10,;
           ::nId    := 0

   if ::oWnd != nil
      ::nStyle = nOR( ::nStyle, WS_CHILD )
   endif

   if ::nBottom != 32768
      ::hWnd = CreateWindow( "#32768", ::cCaption,  WS_POPUP ,;
                             ::nLeft, ::nTop, ::nRight - ::nLeft + 1, ;
                             ::nBottom - ::nTop + 1, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
   else
      ::hWnd = CreateWindow( "#32768", ::cCaption, WS_POPUP, ;
                             ::nLeft, ::nTop, ::nRight, ::nBottom, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
   endif

   if ::hWnd == 0
      WndCreateError( Self )
   else
      ::Link()
   endif
   ::bKeydown   := {|nKey| if( nKey == VK_ESCAPE,::End(),)}

return nil

*********************************************************************************************************************************
METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWindowExt1
*********************************************************************************************************************************

  if nMsg == 6 .and. nWParam == 0
     ::End()
  endif

  /*
  if nMsg == 6 .and. nWParam == 1 //WM_ACTIVATE
     SendMessage( oWnd():hWnd, 134, 1, 0 )
  endif
  */

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

*********************************************************************************************************************************
function Line( hDC, nTop, nLeft, nBottom, nRight, nColor, nGrueso )
*********************************************************************************************************************************

  local hPen, hOldPen
  
  DEFAULT nGrueso := 1
  DEFAULT nColor := CLR_BLACK
  
  hPen := CreatePen( PS_SOLID, nGrueso, nColor )
  hOldPen := SelectObject( hDC, hPen )
  MoveTo( hDC, nLeft,  nTop    )
  LineTo( hDC, nRight, nTop    )
  SelectObject( hDC, hOldPen )
  DeleteObject( hPen )

return 0

*********************************************************************************************************************************

/*
CLASS TWindowExt1 FROM TWindow

      METHOD Create( clsName )

ENDCLASS

METHOD Create( cClsName )  CLASS TWindowExt1

   DEFAULT cClsName := ::ClassName(), ::cCaption := "",;
           ::nStyle := WS_OVERLAPPEDWINDOW,;
           ::nTop   := 0, ::nLeft := 0, ::nBottom := 10, ::nRight := 10,;
           ::nId    := 0

   if ::oWnd != nil
      ::nStyle = nOR( ::nStyle, WS_CHILD )
   endif

   if ::nBottom != 32768
      ::hWnd = CreateWindow( "#32768", ::cCaption,  WS_POPUP ,;
                             ::nLeft, ::nTop, ::nRight - ::nLeft + 1, ;
                             ::nBottom - ::nTop + 1, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
   else
      ::hWnd = CreateWindow( "#32768", ::cCaption, WS_POPUP, ;
                             ::nLeft, ::nTop, ::nRight, ::nBottom, ;
                             If( ::oWnd != nil, ::oWnd:hWnd, 0 ), ;
                             ::nId )
   endif

   if ::hWnd == 0
      WndCreateError( Self )
   else
      ::Link()
   endif

return nil
*/