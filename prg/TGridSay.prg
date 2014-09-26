#include "FiveWin.Ch"  
#include "Factu.ch" 
#include "MesDbf.ch"


static oFont

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
            lCentered, lRight, lBorder, .t., nClrText, nClrBack,;
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

   METHOD Build( hBuilder ) 

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

METHOD Build( hBuilder ) CLASS TGridGet
   
   local nRow        := if( hhaskey( hBuilder, "nRow" ),       hBuilder[ "nRow"     ], nil )
   local nCol        := if( hhaskey( hBuilder, "nCol" ),       hBuilder[ "nCol"     ], nil )
   local bSetGet     := if( hhaskey( hBuilder, "bSetGet" ),    hBuilder[ "bSetGet"  ], nil )
   local oWnd        := if( hhaskey( hBuilder, "oWnd" ),       hBuilder[ "oWnd"     ], nil )
   local nWidth      := if( hhaskey( hBuilder, "nWidth" ),     hBuilder[ "nWidth"   ], nil )
   local nHeight     := if( hhaskey( hBuilder, "nHeight" ),    hBuilder[ "nHeight"  ], nil )
   local cPict       := if( hhaskey( hBuilder, "cPict" ),      hBuilder[ "cPict"    ], nil )
   local bValid      := if( hhaskey( hBuilder, "bValid" ),     hBuilder[ "bValid"   ], nil )
   local nClrFore    := if( hhaskey( hBuilder, "nClrFore" ),   hBuilder[ "nClrFore" ], nil )
   local nClrBack    := if( hhaskey( hBuilder, "nClrBack" ),   hBuilder[ "nClrBack" ], nil )
   local oFont       := if( hhaskey( hBuilder, "oFont" ),      hBuilder[ "oFont"    ], nil )
   local lDesign     := if( hhaskey( hBuilder, "lDesign" ),    hBuilder[ "lDesign"  ], nil )
   local oCursor     := if( hhaskey( hBuilder, "oCursor" ),    hBuilder[ "oCursor"  ], nil )
   local lPixel      := if( hhaskey( hBuilder, "lPixel" ),     hBuilder[ "lPixel"   ], nil )
   local cMsg        := if( hhaskey( hBuilder, "cMsg" ),       hBuilder[ "cMsg"     ], nil )
   local lUpdate     := if( hhaskey( hBuilder, "lUpdate" ),    hBuilder[ "lUpdate"  ], nil )
   local bWhen       := if( hhaskey( hBuilder, "bWhen" ),      hBuilder[ "bWhen"    ], nil )
   local lCenter     := if( hhaskey( hBuilder, "lCenter" ),    hBuilder[ "lCenter"  ], nil )
   local lRight      := if( hhaskey( hBuilder, "lRight" ),     hBuilder[ "lRight"   ], nil )
   local bChanged    := if( hhaskey( hBuilder, "bChanged" ),   hBuilder[ "bChanged" ], nil )
   local lReadOnly   := if( hhaskey( hBuilder, "lReadOnly" ),  hBuilder[ "lReadOnly"], nil )
   local lPassword   := if( hhaskey( hBuilder, "lPassword" ),  hBuilder[ "lPassword"], nil )
   local lNoBorder   := if( hhaskey( hBuilder, "lNoBorder" ),  hBuilder[ "lNoBorder"], nil )
   local nHelpId     := if( hhaskey( hBuilder, "nHelpId" ),    hBuilder[ "nHelpId"  ], nil )
   local lSpinner    := if( hhaskey( hBuilder, "lSpinner" ),   hBuilder[ "lSpinner" ], nil )
   local bUp         := if( hhaskey( hBuilder, "bUp" ),        hBuilder[ "bUp"      ], nil )
   local bDown       := if( hhaskey( hBuilder, "bDown" ),      hBuilder[ "bDown"    ], nil )
   local bMin        := if( hhaskey( hBuilder, "bMin" ),       hBuilder[ "bMin"     ], nil )
   local bMax        := if( hhaskey( hBuilder, "bMax" ),       hBuilder[ "bMax"     ], nil )
   local bAction     := if( hhaskey( hBuilder, "bAction" ),    hBuilder[ "bAction"  ], nil )
   local cBmpName    := if( hhaskey( hBuilder, "cBmpName" ),   hBuilder[ "cBmpName" ], nil )
   local cVarName    := if( hhaskey( hBuilder, "cVarName" ),   hBuilder[ "cVarName" ], nil )
   local cCueText    := if( hhaskey( hBuilder, "cCueText" ),   hBuilder[ "cCueText" ], nil )

   Return ( ::New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) )

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
            nClrFore, nClrBack, oFont, lDesign, oCursor, .t., cMsg,;
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
            nHelpId, oFont, lDefault, .t., lDesign, cMsg,;
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

CLASS TGridImage FROM TImage

   DATA bTop
   DATA bLeft
   DATA bWidth
   DATA bHeight

   METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign, cVarName ) 

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign, cVarName ) CLASS TGridImage

   if isBlock( nTop )
      ::bTop         := nTop
      nTop           := Eval( nTop )
   end if 

   if isBlock( nLeft )
      ::bLeft         := nLeft
      nLeft           := Eval( nLeft )
   end if 

   if isBlock( nWidth )
      ::bWidth       := nWidth
      nWidth         := Eval( nWidth )
   end if 

   if isBlock( nHeight )
      ::bHeight      := nHeight
      nHeight        := Eval( nHeight )
   end if 

   ::Super:New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, .t., bValid, lDesign, cVarName ) 

return Self

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridImage

   local nTop     := if( !empty(::bTop), eval(::bTop), ::nTop )
   local nLeft    := if( !empty(::bLeft), eval(::bLeft), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )

   ::Move( nTop, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

Function oGridFont()

   if empty( oFont )
      oFont    := TFont():New( "Segoe UI Light",  0, 42, .f., .f. )
   end if 

Return ( oFont )   

//----------------------------------------------------------------------------//

Function GridMaximize( oDlg )

   oDlg:Maximize()

Return nil

//----------------------------------------------------------------------------//

Function GridResize( oDlg )

   local o

   for each o in oDlg:aControls
      if ( o:ClassName() $ "TGRIDGET,TGRIDSAY,TGRIDBUTTON,TGRIDIMAGE" )
         o:ReAdjust()
      end if
   next

Return nil   

//----------------------------------------------------------------------------//

Function GridWidth( nCols, oDlg )
   
Return ( oDlg:nWidth() / 12 * nCols )

