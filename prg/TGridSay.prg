#include "FiveWin.Ch"  
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TGridSay FROM TSay

   DATA bRow
   DATA bCol
   DATA bWidth
   DATA bHeight

   METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
               lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
               nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised,;
               lAdjust, cVarName ) CONSTRUCTOR

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised,;
            lAdjust, lTransparent, cVarName ) CLASS TGridSay

   if isBlock( nRow )
      ::bRow         := nRow
      nRow           := Eval( nRow )
   end if 

   if isBlock( nCol )
      ::bCol         := nCol
      nCol           := Eval( nCol )
   end if 

   if isBlock( nWidth )
      ::bWidth       := nWidth
      nWidth         := Eval( nWidth )
   end if 

   if isBlock( nHeight )
      ::bHeight      := nHeight
      nHeight        := Eval( nHeight )
   end if 

   ::Super:New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised,;
            lAdjust, lTransparent, cVarName )

return Self

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridSay

   local nRow     := if( !empty(::bRow), eval(::bRow), ::nTop )
   local nLeft    := if( !empty(::bCol), eval(::bCol), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )
/*
   msgAlert( nRow, "nRow")
   msgAlert( nLeft, "nLeft")
   msgAlert( nWidth, "nWidth")
   msgAlert( nHeight, "nHeight")
*/
   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridGet FROM TGet

   DATA bRow
   DATA bCol
   DATA bWidth
   DATA bHeight

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) CONSTRUCTOR

   METHOD GotFocus( hCtlLost )   INLINE ( ShellExecute( 0, "open", "tabtip.exe" ), ::Super:GotFocus( hCtlLost ) )

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) CLASS TGridGet

   if isBlock( nRow )
      ::bRow         := nRow
      nRow           := Eval( nRow )
   end if 

   if isBlock( nCol )
      ::bCol         := nCol
      nCol           := Eval( nCol )
   end if 

   if isBlock( nWidth )
      ::bWidth       := nWidth
      nWidth         := Eval( nWidth )
   end if 

   if isBlock( nHeight )
      ::bHeight      := nHeight
      nHeight        := Eval( nHeight )
   end if 

   ::Super:New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) 

Return Self

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridGet

   local nRow     := if( !empty(::bRow), eval(::bRow), ::nTop )
   local nLeft    := if( !empty(::bCol), eval(::bCol), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )
/*
   msgAlert( nRow, "nRow")
   msgAlert( nLeft, "nLeft")
   msgAlert( nWidth, "nWidth")
   msgAlert( nHeight, "nHeight")
*/
   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridButton FROM TButton

   DATA bRow
   DATA bCol
   DATA bWidth
   DATA bHeight

   METHOD New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight, ;
            nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
            lUpdate, bWhen, bValid, lCancel, cVarName, lMultiline ) 

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

   METHOD New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight, ;
            nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
            lUpdate, bWhen, bValid, lCancel, cVarName, lMultiline ) CLASS TGridButton

   if isBlock( nRow )
      ::bRow         := nRow
      nRow           := Eval( nRow )
   end if 

   if isBlock( nCol )
      ::bCol         := nCol
      nCol           := Eval( nCol )
   end if 

   if isBlock( nWidth )
      ::bWidth       := nWidth
      nWidth         := Eval( nWidth )
   end if 

   if isBlock( nHeight )
      ::bHeight      := nHeight
      nHeight        := Eval( nHeight )
   end if 

   ::Super:New( nRow, nCol, cCaption, oWnd, bAction, nWidth, nHeight, ;
            nHelpId, oFont, lDefault, lPixel, lDesign, cMsg,;
            lUpdate, bWhen, bValid, lCancel, cVarName, lMultiline )

return Self

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridButton

   local nRow     := if( !empty(::bRow), eval(::bRow), ::nTop )
   local nLeft    := if( !empty(::bCol), eval(::bCol), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )
/*
   msgAlert( nRow, "nRow")
   msgAlert( nLeft, "nLeft")
   msgAlert( nWidth, "nWidth")
   msgAlert( nHeight, "nHeight")
*/
   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//
