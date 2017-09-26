#include "fivewin.ch" 
#include "oficebar.ch"

#ifdef __XHARBOUR__
   #define hb_CurDrive CurDrive
#endif   

CLASS TDotNetButton

      CLASS VAR nInitId     AS NUMERIC INIT 100 SHARED
      DATA aCoors           AS ARRAY INIT {0,0,0,0}
      DATA bAction
      DATA bRAction
      DATA bSelect          // use solo para diseñar / use only by design
      DATA bWhen
      DATA cIcon
      DATA cName            AS CHARACTER INIT "oBoton"
      DATA cPrompt          AS CHARACTER INIT ""
      DATA cxBmp
      DATA lEnabled         AS LOGICAL   INIT .T.
      DATA lEnd             AS LOGICAL   INIT .F.
      DATA lGrouping        AS LOGICAL   INIT .F.
      DATA lHead            AS LOGICAL   INIT .F.
      DATA lHorizontal      AS LOGICAL   INIT .F.
      DATA lSelected        AS LOGICAL   INIT .F.
      DATA lVisible         AS LOGICAL   INIT .T.
      DATA lWorking         AS LOGICAL   INIT .F.
      DATA nClrText
      DATA nColumna         AS NUMERIC   INIT 0
      DATA nId
      DATA oGrupo
      DATA oMenu
      DATA oPopup
      DATA oPrevio

      DATA Cargo

      METHOD New( nWidth, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd ) CONSTRUCTOR

      METHOD Click()                             VIRTUAL
      METHOD Copy()
      METHOD Delete()
      METHOD Edit()
      METHOD End()                               VIRTUAL
      METHOD GenPrg()
      METHOD GetNewId()                          INLINE If( ::nInitId == nil, ::nInitId := 100,), ++::nInitId
      METHOD GetTextWidth( )
      METHOD Hide()                              INLINE ::lVisible := .f.
      METHOD IsOver( nRow, nCol )                INLINE PtInRect( nRow, nCol,::aCoors )
      METHOD Paint( hDC )
      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD Refresh()                           INLINE ::oGrupo:Refresh()
      METHOD Show()                              INLINE ::lVisible := .t.
      METHOD cBmp( cNewVal )                     SETGET
      METHOD cCaption( cNewVal )                 SETGET
      METHOD cGetFromDLL()
      METHOD nBottom( nNewVal )                  SETGET
      METHOD nHeight( nNewVal )                  SETGET
      METHOD nHorizWidth( nHeight )
      METHOD nLeft  ( nNewVal )                  SETGET
      METHOD nRight ( nNewVal )                  SETGET
      METHOD nTop   ( nNewVal )                  SETGET
      METHOD nWidth ( nNewVal )                  SETGET
      METHOD oParent                             INLINE ::oGrupo:oCarpeta:oParent

      METHOD Selected()                          INLINE ( ::lSelected := .t. )
      METHOD UnSelected()                        INLINE ( ::lSelected := .f. )

ENDCLASS

*******************************************************************************************************
  METHOD New( nWidth, oGroup, cBmp, cCaption, nColumna, bAction, oMenu,;
              bWhen, lGrouping, lHead, lEnd ) CLASS TDotNetButton
*******************************************************************************************************

 local n, nLen, oCol

 if cCaption  == nil; cCaption  :=  ""; endif
 if cBmp      == nil; cBmp      :=  ""; endif
 if lGrouping == nil; lGrouping := .f.; endif
 if lHead     == nil; lHead     := .f.; endif
 if lEnd      == nil; lEnd      := .f.; endif

 ::cBmp      := cBmp
 ::cPrompt   := cCaption
 ::lGrouping := lGrouping
 ::lHead     := lHead
 ::lEnd      := lEnd
 ::bAction   := bAction

 ::aCoors[1] := 0
 ::aCoors[2] := 0
 ::aCoors[3] := 0  + 0
 ::aCoors[4] := 0 + nWidth

 ::oPopup    := oMenu          //revisión 09.12.06 V1.01
 ::bWhen     := bWhen

 ::nId       := ::GetNewId()

 ::oGrupo := oGroup


//  if ::oGrupo != nil
 ::oGrupo:AddButton( self, nColumna, lGrouping, lHead, lEnd )
// endif

return self

****************************************************************************************
  METHOD nTop   ( nNewVal ) CLASS TDotNetButton
****************************************************************************************

if nNewVal != nil
   ::aCoors[1] := nNewVal
endif

return ::aCoors[1]


****************************************************************************************
  METHOD nLeft  ( nNewVal ) CLASS TDotNetButton
****************************************************************************************

if nNewVal != nil
   ::aCoors[2] := nNewVal
endif

return ::aCoors[2]

****************************************************************************************
  METHOD nBottom( nNewVal ) CLASS TDotNetButton
****************************************************************************************

if nNewVal != nil
   ::aCoors[3] := nNewVal
endif

return ::aCoors[3]

****************************************************************************************
  METHOD nRight ( nNewVal ) CLASS TDotNetButton
****************************************************************************************

if nNewVal != nil
   ::aCoors[4] := nNewVal
endif

return ::aCoors[4]


****************************************************************************************
  METHOD nWidth ( nNewVal ) CLASS TDotNetButton
****************************************************************************************

if nNewVal != nil
   ::aCoors[4] := ::aCoors[2] + nNewVal
endif

return ::aCoors[4]-::aCoors[2]

****************************************************************************************
  METHOD nHeight( nNewVal ) CLASS TDotNetButton
****************************************************************************************

if nNewVal != nil
   ::aCoors[3] := ::aCoors[1] + nNewVal
endif

return ::aCoors[3] - ::aCoors[1]


****************************************************************************************
  METHOD cCaption( cNewVal ) CLASS TDotNetButton
****************************************************************************************

if cNewVal != nil
   ::cPrompt := cNewVal
   ::oGrupo:ResizeItems()
endif

return ::cPrompt

****************************************************************************************
  METHOD cBmp( cNewVal ) CLASS TDotNetButton
****************************************************************************************

if cNewVal != nil
   ::cxBmp := cNewVal
   if ::oGrupo != nil
      ::oGrupo:ResizeItems()
   endif
endif

return ::cxBmp


****************************************************************************************
  METHOD Paint( hDC ) CLASS TDotNetButton
****************************************************************************************
local lSmallImage := .f.
local nT          := ::nTop
local nL          := ::nLeft
local hBmp        := 0
local hScr        := 0
local rc
local hBmp2       := 0
local nH          := 0
local nW          := 0
local oFont, hFont, hOldFont
local nColor, nMode
local nTop, nLeft, nBottom, nRight
local nAlign
local a := {::oParent:nRow, ::oParent:nCol }
local aPoint := {a[1],a[2]}
local lIsOver
local nHeight := ::aCoors[3]-::aCoors[1]
local nWidth  := ::aCoors[4]-::aCoors[2]
local nH4 := nHeight/4
local nH5 := nHeight/5
local n2H5 := nH5*2
local n3H5 := n2H5 + nH5
local lCaptured
local hPen, hOldPen
local nHText
local nWText := ::GetTextWidth()
local hLib := 0

if ::lWorking
   return 0
endif

// revision 09.12.06     V1.01
lIsOver := PtInRect( aPoint[1], aPoint[2], ::aCoors ) //.and. GetActiveWindow() == ::oParent:oWnd:hWnd

// revision 09.12.06     V1.01
lCaptured := lIsOver .and. ::oParent:lCaptured .and. ::oParent:oBtnCaptured != nil .and. ::oParent:oBtnCaptured:nID == ::nID //.and. GetActiveWindow() == ::oParent:oWnd:hWnd

if !::lVisible
   return 0
endif

if ::oGrupo:lByLines // pinto el boton con la imagen pequeña y a la izda
   lSmallImage := .t.
endif

if ::oParent:lDisenio
   if ::oParent:cResources != nil
      hLib := LoadLibrary( ::oParent:cResources )
      if hLib != 0
         hBmp := LoadBitmap( hLib, ::cBmp )
         FreeLibrary( hLib )
      endif
   endif
endif

if hBmp == 0
   if( hBmp := LoadBitmap( GetResources(), ::cBmp ) ) == 0
       hBmp := ReadBitmap( 0, ::cBmp )
   endif
endif

if hBmp != 0
   nH := BmpHeight( hBmp )
   nW := BmpWidth( hBmp )

endif

if hBmp != 0
   if lSmallImage .or. ::lHorizontal .or. empty( ::cCaption )
      nT := ::nTop + int(::nHeight/2) - nH/2
      nL := ::nLeft + if( empty(::cCaption), ::nWidth/2 - nW/2, 5 )
      if ::oPopup != nil
         nL := ::nLeft + 4
      endif
   else
      nT := ::nTop  + nH4 - (nH/2)
      nL := ::nLeft + (::nWidth /2) - (nW/2)
   endif
   if lCaptured
      nT++
      nL++
   endif
endif


rc := { ::aCoors[1], ::aCoors[2],::aCoors[3],::aCoors[4]}

if lIsOver .and. ::lEnabled .or. ::lSelected

   if lCaptured
      VerticalGradient( hDC, {rc[1]             ,rc[2]+1,rc[1]+n2H5         ,rc[4]  }, ::oParent:oColor:GRADBTN10, ::oParent:oColor:GRADBTN11 )
      VerticalGradient( hDC, {rc[1]+ n2H5 -1    ,rc[2]+1,rc[1]+n3H5         ,rc[4]  }, ::oParent:oColor:GRADBTN20, ::oParent:oColor:GRADBTN21 )
      VerticalGradient( hDC, {rc[1]+ n3H5 -1    ,rc[2]+1,rc[3]              ,rc[4]  }, ::oParent:oColor:GRADBTN30, ::oParent:oColor:GRADBTN31 )
   else
      if ::lSelected
         VerticalGradient( hDC, {rc[1]             ,rc[2]+1,rc[1]+n2H5         ,rc[4]  }, ::oParent:oColor:GRADBTN100, ::oParent:oColor:GRADBTN101 )
         VerticalGradient( hDC, {rc[1]+ n2H5 -1    ,rc[2]+1,rc[1]+n3H5         ,rc[4]  }, ::oParent:oColor:GRADBTN200, ::oParent:oColor:GRADBTN201 )
         VerticalGradient( hDC, {rc[1]+ n3H5 -1    ,rc[2]+1,rc[3]              ,rc[4]  }, ::oParent:oColor:GRADBTN300, ::oParent:oColor:GRADBTN301 )
      else
         VerticalGradient( hDC, {rc[1]             ,rc[2]+1,rc[1]+n2H5         ,rc[4]  }, ::oParent:oColor:GRADBTN1000, ::oParent:oColor:GRADBTN1001 )
         VerticalGradient( hDC, {rc[1]+ n2H5 -1    ,rc[2]+1,rc[1]+n3H5         ,rc[4]  }, ::oParent:oColor:GRADBTN2000, ::oParent:oColor:GRADBTN2001 )
         VerticalGradient( hDC, {rc[1]+ n3H5 -1    ,rc[2]+1,rc[3]              ,rc[4]  }, ::oParent:oColor:GRADBTN3000, ::oParent:oColor:GRADBTN3001 )   //RestoreScreen( hDC, hScr, rc[1], rc[2] )   //DeleteObject( hScr )      //Box( hDC,              {rc[1]+1           ,rc[2]+1  ,rc[3]-1            ,rc[4]-1  }, CLR_WHITE )//RGB( 221,207,155)
      endif
      RoundBox( hDC,rc[2]+1,rc[1]+1,rc[4]-1,rc[3]-1, ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:BORDERBTN1 )
   endif

   RoundBox( hDC,rc[2],rc[1],rc[4],rc[3], ::oParent:oColor:nCorner1, ::oParent:oColor:nCorner1, ::oParent:oColor:BORDERBTN2 )

endif

if ::lGrouping

   nTop    := rc[1]
   nLeft   := rc[2]
   nBottom := rc[3]
   nRight  := rc[4]

  //RGB( 129,164,209)
   if !lCaptured .and. !lIsOver .and. ::lEnabled .and. !::lSelected
      FillSolidRect(hDC, {nTop                     , nLeft, nTop + (nBottom-nTop)*0.4, nRight}, ::oParent:oColor:PANE_BTN_GRP1 )
      FillSolidRect(hDC, {nTop + (nBottom-nTop)*0.4, nLeft,                   nBottom, nRight}, ::oParent:oColor:PANE_BTN_GRP2 )
   endif

   if ::lHead

      //top
      Line( hDC, nTop     , nLeft+1 , nTop     , nRight  , ::oParent:oColor:BORDER_TOP_BTN_HEAD1 )
      Line( hDC, nTop+1   , nLeft+1 , nTop+1   , nRight-1, ::oParent:oColor:BORDER_TOP_BTN_HEAD2 )

      //left
      Line( hDC, nTop + 1 , nLeft   , nBottom  , nLeft   , ::oParent:oColor:BORDER_LEFT_BTN_HEAD1 )
      Line( hDC, nTop + 2 , nLeft+1 , nBottom-1, nLeft+1 , ::oParent:oColor:BORDER_LEFT_BTN_HEAD2 )

      //bottom
      Line( hDC, nBottom  , nLeft+1 , nBottom  , nRight  , ::oParent:oColor:BORDER_BOTTOM_BTN_HEAD1 )
      Line( hDC, nBottom-1, nLeft+2 , nBottom-1, nRight-1, ::oParent:oColor:BORDER_BOTTOM_BTN_HEAD2 )

      //right
      Line( hDC, nTop + 1 , nRight-1, nBottom-1, nRight-1, ::oParent:oColor:BORDER_RIGHT_BTN_HEAD1 )

   endif

   if ::lEnd

      if ::lHead

         //top
         Line( hDC, nTop     , nLeft+4 , nTop     , nRight  , ::oParent:oColor:BORDER_TOP_BTN_HEAD_END1 )
         Line( hDC, nTop+1   , nLeft+4 , nTop+1   , nRight-1, ::oParent:oColor:BORDER_TOP_BTN_HEAD_END2 )

         //left
         //Line( hDC, nTop+1  , nLeft    , nBottom-1, nLeft   , RGB( 213,227,241) )

         //bottom
         Line( hDC, nBottom  , nLeft +4, nBottom  , nRight  , ::oParent:oColor:BORDER_BOTTOM_BTN_HEAD_END1 )
         Line( hDC, nBottom-1, nLeft +4, nBottom-1, nRight-1, ::oParent:oColor:BORDER_BOTTOM_BTN_HEAD_END2 )

         //right
         Line( hDC, nTop + 1 , nRight  , nBottom  , nRight  , ::oParent:oColor:BORDER_RIGHT_BTN_HEAD_END1 )
         Line( hDC, nTop + 1 , nRight-1, nBottom-1, nRight-1, ::oParent:oColor:BORDER_RIGHT_BTN_HEAD_END2 )

      else

         //top
         Line( hDC, nTop     , nLeft   , nTop     , nRight  , ::oParent:oColor:BORDER_TOP_BTN_END1 )
         Line( hDC, nTop+1   , nLeft+1 , nTop+1   , nRight-1, ::oParent:oColor:BORDER_TOP_BTN_END2 )

         //left
         Line( hDC, nTop+1  , nLeft    , nBottom-1, nLeft   , ::oParent:oColor:BORDER_LEFT_BTN_END1   )

         //bottom
         Line( hDC, nBottom  , nLeft   , nBottom  , nRight  , ::oParent:oColor:BORDER_BOTTOM_BTN_END1 )
         Line( hDC, nBottom-1, nLeft   , nBottom-1, nRight-1, ::oParent:oColor:BORDER_BOTTOM_BTN_END2 )

         //right
         Line( hDC, nTop + 1 , nRight  , nBottom  , nRight  , ::oParent:oColor:BORDER_RIGHT_BTN_END1 )
         Line( hDC, nTop + 1 , nRight-1, nBottom-1, nRight-1, ::oParent:oColor:BORDER_RIGHT_BTN_END2 )

      endif

   endif

   if !::lEnd .and. !::lHead
      //top
      Line( hDC, nTop    , nLeft    , nTop     , nRight  , ::oParent:oColor:BORDER_MIDLE_TOP1     )
      Line( hDC, nTop+1   , nLeft+1 , nTop+1   , nRight-1, ::oParent:oColor:BORDER_MIDLE_TOP2     )
      //left
      Line( hDC, nTop+1  , nLeft    , nBottom-1, nLeft   , ::oParent:oColor:BORDER_MIDLE_LEFT1    )
      //bottom
      Line( hDC, nBottom , nLeft    , nBottom  , nRight  , ::oParent:oColor:BORDER_MIDLE_BOTTOM1  )
      Line( hDC, nBottom-1, nLeft   , nBottom-1, nRight-1, ::oParent:oColor:BORDER_MIDLE_BOTTOM2  )
      //right
      Line( hDC, nTop + 1 , nRight-1, nBottom-1, nRight-1, ::oParent:oColor:BORDER_MIDLE_RIGHT1   )
   endif

endif

if hBmp != 0
   if !::lEnabled
      hBmp2 := BmpToGray( hBmp, 20 )
      DeleteObject( hBmp )
      hBmp := hBmp2
   endif
   DrawMasked( hDC, hBmp, nT, nL )
   DeleteObject( hBmp )
endif

if ::oParent:oFont != nil
   hFont := ::oParent:oFont:hFont
else
   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-12.3
   hFont := oFont:hFont                                 //hFont := GetStockObject( DEFAULT_GUI_FONT )
endif

do case
   case ::lHorizontal

      nTop    := ::nTop
      nLeft   := nL +  nW + 4
      nBottom := ::nBottom
      nRight  := ::nRight

   case hBmp == 0 .and. nWText < ::nWidth

      nTop    := ::nTop
      nLeft   := ::nLeft
      nBottom := ::nBottom
      nRight  := ::nRight

   case lSmallImage

      nTop    := ::nTop
      nLeft   := ::nLeft + nW + 8
      nBottom := ::nBottom
      nRight  := ::nRight

   otherwise

      nTop    := ::nTop + nH + 8
      nLeft   := ::nLeft
      nBottom := ::nBottom
      nRight  := ::nRight

endcase

if lCaptured
   nTop++
   nLeft++
   nBottom++
   nRight++
endif

hOldFont := SelectObject( hDC, hFont )
nColor   := SetTextColor( hDC, if( ::lEnabled, ::oParent:oColor:_CLRTEXTBACK, CLR_HGRAY ) )
nMode    := SetBkMode( hDC, 1 )

do case
   case ::lHorizontal .and. ( ::oPopup != nil .or. hBmp != 0 )
        nAlign := nOr( DT_SINGLELINE, DT_VCENTER, DT_WORD_ELLIPSIS )
   case hBmp == 0 .and. nWText < ::nWidth
        nAlign := nOr( DT_SINGLELINE, DT_VCENTER, DT_CENTER )
   case lSmallImage
        nAlign := nOR( DT_SINGLELINE, DT_LEFT, DT_VCENTER )
   otherwise
        nAlign := nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP )
endcase

if ::oGrupo:lByLines .and. hBmp == 0 .and. ::oPopup != nil
   nRight -= 11
endif


nHText := DrawText( hDC, ::cCaption, {nTop, nLeft, nBottom, nRight}, nOr( nAlign, DT_CALCRECT, DT_NOPREFIX ))

if ::oPopup != nil .and. !::lHorizontal
   if !lSmallImage .and. nTop + nHText + 12 > ::nTop + ::nHeight
      nAlign := nOR( DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP )
   endif
   nLeft += 4
endif

DrawText( hDC, alltrim(::cCaption), {nTop, nLeft + if( nAlign == nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP, DT_NOPREFIX ),4,0), nBottom, nRight}, nAlign )

//Box( hDC,{nTop, nLeft, nBottom, nRight},0)

if ::oGrupo:lByLines .and. hBmp == 0 .and. ::oPopup != nil
   nRight += 11
endif


if ::oPopup != nil

   hBmp := BmpArrowDownNet()

   if ::lHorizontal
      nTop  := nTop + int(nHeight/2) - 2
      nLeft := nRight - 10
   else
      if !lSmallImage .and. nTop + nHText + 12 > ::nTop + ::nHeight
         nTop  := nBottom - 8
         nLeft := nRight - 10 //12
      else
         if lSmallImage
            nTop  := nTop + int(nHeight/2) - 2
            nLeft := nRight - 10
         else
            nTop  := nTop + nHText + 3
            nLeft := nLeft + nWidth/2 - 3
         endif
      endif
   endif
   Drawmasked( hDC, hBmp, nTop, nLeft )
   DeleteObject( hBmp )

endif

SetBkMode   ( hDC, nMode    )
SetTextColor( hDC, nColor   )
SelectObject( hDC, hOldFont )

if oFont != nil
   oFont:End()
endif

return 0

***********************************************************************************************
  METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TDotNetButton
***********************************************************************************************

return 0

static function MakePopup( o )
local oPopup

MENU oPopup POPUP
    MENUITEM "Item 1"
    MENUITEM "Item 2"
    MENUITEM "Item 3"
    SEPARATOR
    MENUITEM "Item 4"
ENDMENU

return oPopup

***************************************************************************************************
   METHOD Edit() CLASS TDotNetButton
***************************************************************************************************
local oFont
local bValid := {||.t.}
local o := self
local uVar
local nTop, nLeft, nWidth, nHeight

uVar := padr(::cPrompt, 100)

nTop    := ::nTop + 6
nLeft   := ::nLeft +4
nWidth  := ::nWidth -8
nHeight := ::nHeight -8

DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-10

   ::oParent:oGet := TGet():New(nTop,nLeft,{ | u | If( PCount()==0, uVar, uVar:= u ) },o:oParent,nWidth,nHeight,,,0,RGB( 255,215, 94) ,oFont,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,.T.,)

   ::oParent:nLastKey := 0
   ::oParent:oGet:SetFocus()
   ::oParent:oGet:bValid := {|| .t. }

   ::oParent:oGet:bLostFocus := {||  o:oParent:oGet:Assign(),;
                                  o:oParent:oGet:VarPut( o:oParent:oGet:oGet:VarGet() ),;
                                  o:cCaption := if( o:oParent:nLastKey != VK_ESCAPE, alltrim(o:oParent:oGet:oGet:VarGet()), o:cCaption ) ,;
                                  o:oParent:GetCoords(), o:oParent:Refresh() }

   ::oParent:oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. nKey == VK_ESCAPE, ( o:oParent:nLastKey := nKey, o:oParent:oGet:End()), ) }



return nil

****************************************************************************************
  METHOD nHorizWidth( nHeight ) CLASS TDotNetButton
****************************************************************************************
local nWidth
local hBmp
local nW := 0
local nH := 0

if valtype( ::cBmp ) == "C" .and. "." $ ::cBmp
   hBmp := ReadBitmap( 0, ::cBmp )
else
   hBmp := LoadBitmap( GetResources(), ::cBmp )
endif

if hBmp != 0
   nH := BmpHeight( hBmp )
   nW := BmpWidth( hBmp )
   DeleteObject( hBmp )
endif

if empty( ::cCaption )
   nWidth := 5 + nW + 5
else
   if hBmp == 0
      nWidth := 5 + ::GetTextWidth() + 5
   else
      nWidth := 5 + nW + 5 + ::GetTextWidth() //+ 10
   endif
endif

if ::oGrupo:lByLines
   if ::oPopup != nil
      nWidth += 11
   endif
endif

if nWidth < ::nWidth
   nWidth := ::nWidth
endif

return nWidth




***************************************************************************************************
   METHOD GetTextWidth() CLASS TDotNetButton
***************************************************************************************************
local hFont
local oFont
local nWidth := 0

if ::oParent:oFont != nil
   hFont := ::oParent:oFont:hFont
else
   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,-12.3
   hFont := oFont:hFont                                 //hFont := GetStockObject( DEFAULT_GUI_FONT )
endif

nWidth := GetTextWidth( 0, ::cCaption, hFont )

if oFont != nil
   oFont:End()
endif


return nWidth


****************************************************************************************************
   METHOD Delete() CLASS TDotNetButton
****************************************************************************************************
local n, n2, nLen2
local nLen := len( ::oGrupo:aItems )

::lWorking := .t.

for n := 1 to nLen
    if ::oGrupo:aItems[n]:nId == ::nId
       adel( ::oGrupo:aItems, n )
       asize( ::oGrupo:aItems, nLen - 1 )
       exit
    endif
next
// V1.04 15.12.06
if ::oGrupo:lByColumns
   nLen := len( ::oGrupo:aColumns[::nColumna] )
   for n := 1 to nLen
       if ::oGrupo:aColumns[::nColumna]:aItems[n]:nId == ::nId
          adel( ::oGrupo:aColumns[::nColumna]:aItems, n )
          asize( ::oGrupo:aColumns[::nColumna]:aItems, len(::oGrupo:aColumns[::nColumna]:aItems) - 1 )
          exit
       endif
   next

   if len(::oGrupo:aColumns[::nColumna]:aItems) == 0
      adel( ::oGrupo:aColumns,::nColumna )
      asize( ::oGrupo:aColumns, len( ::oGrupo:aColumns ) - 1 )
   endif

   // reubico ::nColumna de cada columna

   for n := 1 to len(::oGrupo:aColumns)
       nLen2 := len(::oGrupo:aColumns[n]:aItems)
       for n2 := 1 to nLen2
           ::oGrupo:aColumns[n]:aItems[n2]:nColumna := n
       next
   next
endif

::lWorking := .f.

return nil


****************************************************************************************************
   METHOD GenPrg() CLASS TDotNetButton
****************************************************************************************************
local cPrg := ""

::cName := "oBtn" +  alltrim(str(::nId-100))

  ::oParent:cVars += "local " + ::cName + CRLF

  cPrg += space(16) + ::cName + " := "
  cPrg += "TDotNetButton():New( " + alltrim( str(::nWidth))   +", "     +;
                                    ::oGrupo:cName +", "     +;
                                    if( valtype(::cBmp) == "N", alltrim(str(::cBmp)),'"'+::cBmp+'"') + ","  +;
                                    '"'+ ::cPrompt +'", '             +;
                                    if( ::nColumna > 0, alltrim(str(::nColumna)),) +", " +;
                                    "{|| .t.}, "                      +;
                                    " oMenu ,"                        + ;
                                    " bWhen, "                        +;
                                    if(::lGrouping,".t.",".f.")+ ", " +;
                                    if(::lHead,".t.",".f.")+ ", "     +;
                                    if(::lEnd,".t.",".f.") +         " ) " + CRLF


return cPrg






***********************************************************************************************
      METHOD cGetFromDLL() CLASS TDotNetButton
***********************************************************************************************

// under construction

return 0

***********************************************************************************************************************
  METHOD Copy() CLASS TDotNetButton
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