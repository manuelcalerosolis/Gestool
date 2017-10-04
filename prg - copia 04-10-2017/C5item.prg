#include "FiveWin.Ch"

#define ITEMHIGHT    22
#define HSEPARATOR    5


CLASS TC5Item

      // DATA nAlign
      // DATA nClrText
      // DATA nLines
      // DATA oFont

      CLASSDATA nInitId INIT 100  // To avoid conflicts with MDI automatic MenuItems

      DATA bAction
      DATA bWhen

      DATA cBmpFile
      DATA cMsg
      DATA cPrompt
      DATA cResName
      DATA cSmallBmp

      DATA lActive  AS LOGICAL INIT .t.
      DATA lBreak   AS LOGICAL INIT .f.
      DATA lChecked AS LOGICAL INIT .f.
      DATA lHelp    AS LOGICAL INIT .f.
      DATA lSeparator

      DATA nHeight
      DATA nHelpId
      DATA nId
      DATA nTxtWidth
      DATA nVKState
      DATA nVirtKey
      DATA nWidth

      DATA oC5Bitmap
      DATA oC5Menu
      DATA oParent
      DATA oSmallBmp

      METHOD New( oParent, cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
                  cResName, nVKState, nVirtKey, lHelp, nHelpId, bWhen,;
                  lBreak, nHeight, cSmallBmp, lSeparator ) CONSTRUCTOR

      METHOD Paint( hDC, nItem, lSelected )
      METHOD Destroy()

      METHOD GetNewId() INLINE ++::nInitId

      METHOD Enable()
      METHOD Disable()


ENDCLASS

*******************************************************************************
  METHOD New( oParent, cPrompt, cMsg, lChecked, lActive, bAction, cBmpFile,;
              cResName, nVKState, nVirtKey, lHelp, nHelpId, bWhen,;
              lBreak, nHeight, cSmallBmp, lSeparator )
*******************************************************************************

      Local cBmp

      DEFAULT cPrompt := "", lSeparator := .f.,;
          nHeight := ITEMHIGHT, lHelp := .f.,;
          lChecked := .f., lActive := .t., lBreak := .f., lSeparator := .f.

       ::cPrompt    := cPrompt
       ::cMsg       := cMsg
       ::lChecked   := lChecked
       ::lActive    := lActive
       ::bAction    := bAction
       ::cBmpFile   := cBmpFile
       ::cResName   := cResName
       ::nVKState   := nVKState
       ::nVirtKey   := nVKState
       ::lHelp      := lHelp
       ::nHelpId    := nHelpId
       ::bWhen      := bWhen
       ::lBreak     := lBreak
       ::oParent    := oParent
       ::cPrompt    := cPrompt
       ::lSeparator := lSeparator

       ::nId        := ::GetNewId()

       ::nTxtWidth := ::oParent:GetWidth( ::cPrompt )
       ::nWidth    := ::oParent:nMargLeft + ::nTxtWidth + ::oParent:nMargRight

       if ::lSeparator
          ::nHeight := HSEPARATOR
       else
          ::nHeight := nHeight
       endif

      if cSmallBmp != nil
         ::oSmallBmp := TC5Bitmap():New( cSmallBmp, ::oParent , .t. )
      endif

      if ::cBmpFile != nil
         cBmp := ::cBmpFile
      else
         if ::cResName != nil
            cBmp := ::cResName
         endif
      endif

      if cBmp != nil
         ::oC5Bitmap := TC5Bitmap():New( cBmp, ::oParent, .f. ) // <-- ojo el .f.
      endif

      ::oParent:AddItem( Self )

Return self

*********************************************************
 METHOD Paint( hDC, nItem, lSelected ) CLASS TC5Item
**********************************************************

 Local nTop, nLeft, nBottom, nRight
 Local nMedH := int( ::nHeight / 2 )
 Local hPen, hOldPen, hBrush, hOldBrush


 DEFAULT lSelected := .f.

 nTop    := ::oParent:aCoors[ nItem, 1 ]
 nLeft   := ::oParent:aCoors[ nItem, 2 ]
 nBottom := ::oParent:aCoors[ nItem, 3 ]
 nRight  := ::oParent:aCoors[ nItem, 4 ]

 do case
    case ::lSeparator

         hOldPen := SelectObject( hDC, ::oParent:hPenClrInAct )

         Moveto( hDC, nLeft, nTop + 2 )
         Lineto( hDC, nRight - 2, nTop + 2 )

         SelectObject( hDC, hOldPen )

         hOldPen := SelectObject( hDC, ::oParent:hPenClrAct )

         Moveto( hDC, nLeft, nTop + 3 )
         Lineto( hDC, nRight - 2, nTop + 3 )

         SelectObject( hDC, hOldPen )

    otherwise



       if ::lActive

          if ::oParent:l3D .and. lSelected
             if ::oParent:lPressed
                WndBoxIn( hDC,  nTop, nLeft + 3, nBottom, nRight - 5  )
             else
                WndBoxRaised( hDC,  nTop, nLeft + 3, nBottom, nRight - 5  )
             endif
          else

             if lSelected

                hBrush := CreateSolidBrush( ::oParent:nClrOption )
                FillRect( hDC, { nTop, nLeft, nBottom, nRight - 3 }, hBrush )
                DeleteObject( hBrush )

             endif

          endif

       endif

       DrawText( hDC, ::cPrompt,;
            { nTop,;
              nLeft  + ::oParent:nMargLeft,;
              nBottom,;
              nRight                        }, 36 ) // LEFT

 endcase

 if ::oSmallBmp != nil

    ::oSmallBmp:Paint( hDC, nTop + nMedH - ::oSmallBmp:nMedH  ,;
            nLeft + ( ::oParent:nMargLeft / 2 ) - ::oSmallBmp:nMedW )

 endif


 if ::oParent != nil .or. ::lChecked

    if lSelected  .and. !::oParent:l3d
       hPen   := GetStockObject( 6 )  // WHITE
       hBrush := GetStockObject( 0 )  // WHITE
    else
       hPen   := GetStockObject( 7 )  // BLACK
       hBrush := GetStockObject( 4 )  // BLACK
    endif

    hOldPen   := SelectObject( hDC, hPen )
    hOldBrush := SelectObject( hDC, hBrush )



    if ::lChecked

       * checked
       PolyPolyGon( hDC, { { nLeft + 10, nTop + nMedH     },;
                           { nLeft + 10, nTop + nMedH + 2 },;
                           { nLeft + 12, nTop + nMedH + 4 },;
                           { nLeft + 16, nTop + nMedH     },;
                           { nLeft + 16, nTop + nMedH - 2 },;
                           { nLeft + 12, nTop + nMedH + 2 },;
                           { nLeft + 10, nTop + nMedH     } } )

    endif

    nTop    += ( nMedH - 3 )
    nLeft   := nRight - 13

    if ::oC5Menu != nil
       * mark of the menu
       PolyPolyGon( hDC, { { nLeft    , nTop    },;
                           { nLeft + 3, nTop + 3},;
                           { nLeft    , nTop + 6},;
                           { nLeft    , nTop    } } )
    endif

    SelectObject( hDC, hOldPen    )
    SelectObject( hDC, hOldBrush  )

  endif



Return nil

***************************
 METHOD Destroy()
***************************

if ::oC5Menu != nil
   ::oC5Menu:Destroy()
   sysrefresh()
endif

if ::oSmallBmp != nil
   ::oSmallBmp:Destroy()
   sysrefresh()
endif

if ::oC5Bitmap != nil
   ::oC5Bitmap:Destroy()
   sysrefresh()
endif

return nil

*******************************
      METHOD Enable()
*******************************
If !::lActive
   ::oParent:oCanvas:BeginPaint()

   ::lActive := .t.
   ::oParent:PaintData( ::oParent:oCanvas:hDCMem )

   ::oParent:oCanvas:EndPaint()
endif
return nil
*******************************
      METHOD Disable()
*******************************
If !::lActive
   ::oParent:oCanvas:BeginPaint()
   ::lActive := .f.
   ::oParent:PaintData( ::oParent:oCanvas:hDCMem )
   ::oParent:oCanvas:EndPaint()
endif

return nil