#include "FiveWin.Ch"

#define COLOR_MENU                 4
#define COLOR_MENUTEXT             7
#define COLOR_ACTIVECAPTION        2
#define COLOR_CAPTIONTEXT          9
#define COLOR_ACTIVEBORDER        16   //BTNSHADOW
#define COLOR_INACTIVEBORDER      14   //HIGHLIGHTTEXT

#define TRANSPARENT    1

#define MARGENLEFT  30
#define MARGENRIGHT 22

#define SRCCOPY  13369376

CLASS TC5Menu FROM TWindow

      CLASSDATA l3d         AS LOGICAL INIT .f.
      CLASSDATA lRegistered AS LOGICAL

      DATA aControls        AS ARRAY INIT {}
      DATA aCoors           // Array for store the coordinates of the oItems // { nTop, nLeft, nBottom, nRight }
      DATA aItems           // Array of oItems Objects

      DATA cC5Title
      DATA cBmpBack

      DATA hPenClrAct
      DATA hPenClrInAct

      DATA lCaptured
      DATA lHasControls     AS LOGICAL INIT .F.
      DATA lKillFont
      DATA lPaintedOp   // On painted the option ?
      DATA lPressed
      DATA lW95Look

      DATA nBottom
      DATA nClrBAct     // Color of the left and the up border (shadow)
      DATA nClrBInAct   // Color of the down and the right border (shadow)
      DATA nClrInAct
      DATA nClrOption
      DATA nClrPane
      DATA nClrSelText
      DATA nClrText
      DATA nLeft
      DATA nLen         // how much items are
      DATA nMargLeft
      DATA nMargRight
      DATA nMaxWidth
      DATA nOldOption   // The last option drawed
      DATA nOption      // Active option in the menu
      DATA nRight
      DATA nTop

      DATA oCanvas
      DATA oItemP
      DATA oOpen
      DATA oTitle




      METHOD New( nOption, nClrText, nClrPane, cC5Title, oFont, l3D, oItem,;
                  cBmpBack  ) CONSTRUCTOR

      METHOD AddItem( oItem )

      METHOD Activate( nRow, nCol, oWnd )

      METHOD CreaBmp()

      METHOD LButtonDown( nRow, nCol, nKeyFlags )
      METHOD LButtonUp  ( nRow, nCol, nKeyFlags )

      METHOD MouseMove  ( nRow, nCol, nKeyFlags )

      METHOD Paint()
      METHOD PaintData( hDC )
      METHOD PaintSelect()

      METHOD Show() INLINE ::lVisible := .t., Super:Show()

      METHOD Destroy()

      METHOD GetOption( nRow, nCol )
      *METHOD GotFocus()

      METHOD Hide()

      MESSAGE nWTitle METHOD _nWTitle()
      MESSAGE nHTitle METHOD _nHTitle()

ENDCLASS

*************************************************************************
 METHOD New( nOption, nClrText, nClrPane, cC5Title, oFont, l3D, oItem,;
             cBmpBack )
*************************************************************************

       DEFAULT nClrText := GetSysColor( COLOR_MENUTEXT ),;
               nClrPane := GetSysColor( COLOR_MENU ),;
               nOption := 1


   ::nTop       := 1
   ::nLeft      := 1
   ::nBottom    := 10
   ::nRight     := 10

   ::nMaxWidth  := 10

   ::nMargLeft  := MARGENLEFT

   ::nMargRight := MARGENRIGHT

   ::lPaintedOp := .f.

   ::aItems     := {}
   ::aCoors     := {}
   ::nLen       := 0

   if l3D
      ::l3D := l3D
   endif

   ::nOption    := nOption

   ::nStyle     := nOr( WS_POPUP, WS_VISIBLE )

   if oFont == nil
      DEFINE FONT ::oFont NAME "Ms Sans Serif" SIZE 5, 13
      ::lKillFont := .t.
   else
      ::oFont := oFont
      ::lKillFont := .f.
   endif

   ::Register()
   ::Create()

   ::SetColor( nClrText, nClrPane )

   ::cC5Title := cC5Title

   if ::cC5Title != nil
      ::oTitle := TC5Bitmap():New( ::cC5Title, self , .f. )
   endif

   ::nClrOption  := GetSysColor( COLOR_ACTIVECAPTION )
   ::nClrSelText := if( ::l3d, ::nClrText, GetSysColor( COLOR_CAPTIONTEXT   ) )

   ::nClrBAct    :=  CLR_WHITE
   ::nClrBInAct  :=  CLR_GRAY

   ::hPenClrAct    := CreatePen( PS_SOLID, 1, ::nClrBAct   )
   ::hPenClrInAct  := CreatePen( PS_SOLID, 1, ::nClrBInAct )

   ::lPressed  := .f.
   ::lCaptured := .f.
   ::cBmpBack  := cBmpBack


   if oItem != nil
      oItem:oC5Menu := Self
   endif

   ::Hide()

Return self


*********************************************
 METHOD AddItem( oItem ) CLASS TC5Menu
*********************************************

 Local nTop, nLeft, nBottom, nRight
 Local aLast
 Local nTxtWidth

 ::nLen ++

 nLeft  := 2 + if( ::cC5Title != nil, ::nWTitle, 0 )

 If empty( ::aCoors )

    nTop  := 4

 else

    if oItem:lBreak
       nTop := 2
       nLeft  := atail( ::aCoors )[4] + 10
    else
       nTop := atail( ::aCoors )[3] + 1
    endif

 endif

 nBottom := nTop + oItem:nHeight
 nRight := nLeft + oItem:nWidth


 if nRight > ::nMaxWidth
    ::nMaxWidth := nRight
 endif

 *oItem:nId := ::nLen

 aadd( ::aItems, oItem )
 aadd( ::aCoors, { nTop, nLeft, nBottom, nRight } )

Return nil


**************************************
 METHOD Activate( nRow, nCol, oWnd )
**************************************

   Local aPoint := { nRow, nCol }
   Local nTop, nLeft, nHeight
   Local n

   ::lHasControls := Len( ::aControls ) > 0


   If ::lVisible
      *::Hide()
      ::lPaintedOp := .f.
   endif

      ClientToScreen( oWnd:hWnd, aPoint )

      nTop  := aPoint[ 1 ]
      nLeft := aPoint[ 2 ]

      If empty( ::aCoors )
         nHeight := 10
      else
         nHeight := atail( ::aCoors )[3] + 4
      endif

      if ::oTitle != nil
         if ::nHTitle > nHeight
            nHeight := ::nHTitle
         endif
      endif


      SetWindowPos( ::hWnd, 0, nTop, nLeft, ::nMaxWidth, nHeight, 16  )
      *SetWindowPos( ::hWnd, -1, nTop, nLeft, ::nMaxWidth, nHeight, 16  )



      if ::oCanvas == nil
         ::CreaBmp( ::cBmpBack )
      endif

      ::Show()


Return nil

*******************************
 METHOD CreaBmp( cBmp )
*******************************

Local n, nHeight, nWidth



for n := 1 to ::nLen
    ::aCoors[ n, 4 ] := ::nMaxWidth
next n

if cBmp != nil
   ::oCanvas := TC5Bitmap():New( cBmp, Self, .f. )
else
   ::oCanvas := TC5Bitmap():MakeMem( ::nWidth, ::nHeight , ::nClrPane, Self )
endif

::oCanvas:BeginPaint()

::PaintData( ::oCanvas:hDCMem )

::oCanvas:EndPaint()


return nil



**********************************************
 METHOD Destroy()
**********************************************
Local n

DeleteObject( ::hPenClrAct   )
DeleteObject( ::hPenClrInAct )

for n := 1 to ::nLen
    ::aItems[ n ]:Destroy()
    sysrefresh()
next

if ::oTitle != nil
   ::oTitle:Destroy()
endif

if ::lKillFont
   ::oFont:End()
endif

if ::oCanvas != nil
   ::oCanvas:Destroy()
   sysrefresh()
endif

return Super:Destroy()

**********************************************
 METHOD GetOption( nRow, nCol )
**********************************************

 Local n

 For n := 1 to ::nLen

     If nRow >= ::aCoors[ n, 1 ] .and. nRow <= ::aCoors[ n, 3 ] .and.;
        nCol >= ::aCoors[ n, 2 ] .and. nCol <= ::aCoors[ n, 4 ]
        Return n
     endif

 next

 Return ::nOption

**************************************************
   METHOD LButtonDown( nRow, nCol, nKeyFlags )
**************************************************

   ::nOption := ::GetOption ( nRow, nCol )

   SetFocus( ::hWnd )    // To let the main window child control
   SysRefresh()          // process its valid

   if GetFocus() == ::hWnd
      ::lCaptured = .t.
      ::lPressed  = .t.
      ::Capture()
      ::PaintSelect()
   endif

return 0



**************************************************
   METHOD LButtonUp( nRow, nCol, nKeyFlags )
**************************************************

   local lClick := IsOverWnd( ::hWnd, nRow, nCol )
      ::nOption := ::GetOption ( nRow, nCol )

      if ::lCaptured
         ::lCaptured = .f.
         ReleaseCapture()
         ::lPressed := .f.
         ::PaintSelect()
         if lClick
            if ::aItems[ ::nOption ]:bAction != nil
               eval( ::aItems[ ::nOption ]:bAction )
            endif
         endif
      endif

return 0






**************************************************
  METHOD MouseMove( nRow, nCol, nKeyFlags )
**************************************************
 Local oItem

 ::nOption := ::GetOption ( nRow, nCol )

If IsOverWnd( ::hWnd, nRow, nCol ) .and. nRow <= atail( ::aCoors )[3]

   ::Capture()

   if ::nOldOption == nil .or. ::nOldOption != ::nOption .or. !::lPaintedOp

      if ::oOpen != nil .and. ::nOldOption != ::nOption
         ::oOpen:Hide()
         sysrefresh()
         ::oOpen := nil
      endif


      *::Paint()
      ::PaintSelect()

      ::nOldOption := ::nOption

      ::lPaintedOp := .t.

      oItem := ::aItems[ ::nOption ]

      if oItem:oC5Menu != nil

         ::CoorsUpdate()

         ::oOpen := oItem:oC5Menu

         if !oItem:oC5Menu:lVisible

            oItem:oC5Menu:Activate( ::aCoors[ ::nOption, 1 ] ,;
                                    ::aCoors[ ::nOption, 4 ] - 5, ;
                                    self )
         endif

      else

         if ::oOpen != nil
            ::oOpen:Hide()
            sysrefresh()
            ::oOpen := nil
            *::Paint()
            ::PaintSelect()
         endif

      endif

   endif

else
    ::lPressed   := .f.
    ::lPaintedOp := .f.
    ::nOldOption := ::nOption
    ReleaseCapture()

endif

return super: MouseMove( nRow, nCol, nKeyFlags )




************************************
 METHOD Hide()
************************************
Local oItem

super:Hide()
::lVisible := .f.

if ::oOpen != nil
   ::oOpen:Hide()
   ::oOpen := nil
endif

return nil

******************************************
 METHOD Paint() CLASS TC5Menu
******************************************

Local hDC
Local n

// voy a pintar en el siguiente paso un bmp construido en memoria
// y en paint solo pintar‚ de verdad la opci¢n activa

hDC := ::GetDC()

::oCanvas:Paint( hDC, 0, 0 )

if ::lHasControl
   for n := 1 to Len( ::aControls )
       ::aControls[n]:Refresh()
   next
endif

*PalBmpDraw( hDC, 0,0, ::hImg, ::nWidth, ::nHeight )

::ReleaseDC()

Return nil
**********************************
 METHOD PaintData( hDC )
**********************************
Local n
Local nMode, nOldColor, hOldFont

Local nTop, nLeft, nBottom, nRight
Local hOldPen

hMemDC  := hDC


nOldColor := SetTextColor( hMemDC, ::nClrText  )
nOldMode  := SetBkMode   ( hMemDC, TRANSPARENT )
hOldFont  := SelectObject( hMemDC, ::oFont:hFont )


   * raya negra abajo y derecha

   Moveto( hMemDC, ::nWidth-1, 0 )
   Lineto( hMemDC, ::nWidth-1, ::nHeight -1 )
   Lineto( hMemDC,          -1, ::nHeight -1 )

   if ::nLen > 0

      For n := 1 to ::nLen

          if !::aItems[ n ]:lActive
             SetTextColor( hMemDC, nOldColor )
             nOldColor := SetTextColor( hMemDC, ::nClrText  )
          endif

          ::aItems[ n ]:Paint( hMemDC, n )

          if !::aItems[ n ]:lActive
             SetTextColor( hMemDC, nOldColor )
          endif

      next n

   endif

   if ::oTitle != nil
      ::oTitle:Paint( hMemDC, 2, 2 )
   endif

   SetTextColor( hMemDC, nOldColor )
   SetBkMode   ( hMemDC, nOldMode  )
   SelectObject( hMemDC, hOldFont  )

   hOldPen := SelectObject( hMemDC, ::hPenClrAct )

   Moveto( hMemDC, 1, ::nHeight - 2 )
   Lineto( hMemDC, 1, 1 )
   Lineto( hMemDC, ::nWidth - 2, 1 )

   SelectObject( hMemDC, hOldPen )

   hOldPen := SelectObject( hMemDC, ::hPenClrInAct )

   Moveto( hMemDC, 1,            ::nHeight - 2 )
   Lineto( hMemDC, ::nWidth - 2, ::nHeight - 2 )
   Lineto( hMemDC, ::nWidth - 2, 0 )

   SelectObject( hMemDC, hOldPen )


return nil




******************************************
 METHOD PaintSelect() CLASS TC5Menu
******************************************

Local n
Local hDC
Local nMode, nOldColor, hOldFont

Local nTop, nLeft, nWidth, nHeight

// voy a pintar en el siguiente paso un bmp construido en memoria
// y en paint solo pintar‚ de verdad la opci¢n activa


hDC := ::GetDC()

 if ::nOldOption != nil
    n :=    ::nOldOption
    nTop    := ::aCoors[ n ][1]
    nLeft   := ::aCoors[ n ][2]
    nWidth  := ::aCoors[ n ][4] - ::aCoors[ n ][2] + 1
    nHeight := ::aCoors[ n ][3] - ::aCoors[ n ][1] + 1
    ::oCanvas:BeginPaint()
    bitblt( hDC, nLeft, nTop, nWidth, nHeight,;
            ::oCanvas:hDCMem, nLeft, nTop, SRCCOPY )
    ::oCanvas:EndPaint()
 endif

 nOldColor := SetTextColor( hDC, ::nClrSelText  )
 nOldMode  := SetBkMode   ( hDC, TRANSPARENT )
 hOldFont  := SelectObject( hDC, ::oFont:hFont )


::aItems[ ::nOption ]:Paint( hDC, ::nOption, .t.  )

 SetTextColor( hDC, nOldColor )
 SetBkMode   ( hDC, nOldMode  )
 SelectObject( hDC, hOldFont  )


::ReleaseDC()

Return nil

***************************************
 METHOD _nWTitle()
***************************************
Local nWidth := 0

if ::oTitle != nil
   nWidth := ::oTitle:nWidth
endif

return nWidth

***************************************
 METHOD _nHTitle()
***************************************
Local nHeight := 0

if ::oTitle != nil
   nHeight := ::oTitle:nHeight
endif

return nHeight


*METHOD GotFocus() CLASS TWindow

*Return 0