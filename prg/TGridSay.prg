#include "FiveWin.Ch"  
#include "Factu.ch" 
#include "MesDbf.ch"

static oFont
static oFontBold

//----------------------------------------------------------------------------//

CLASS TGridable

   DATA bRow
   DATA bCol
   DATA bTop
   DATA bLeft
   DATA bWidth
   DATA bHeight

   METHOD EvalRow( nRow )        INLINE ( if( isBlock( nRow ), ::bRow := nRow, ),;
                                          if( !Empty( ::bRow ), nRow := Eval( ::bRow ), ), nRow ) 
   METHOD EvalCol( nCol )        INLINE ( if( isBlock( nCol ), ::bCol := nCol, ),;
                                          if( !Empty( ::bCol ), nCol := Eval( ::bCol ), ), nCol ) 
   METHOD EvalTop( nTop )        INLINE ( if( isBlock( nTop ), ::bTop := nTop, ),;
                                          if( !Empty( ::bTop ), nTop := Eval( ::bTop ), ), nTop ) 
   METHOD EvalLeft( nLeft )      INLINE ( if( isBlock( nLeft ), ::bLeft := nLeft, ),;
                                          if( !Empty( ::bLeft ), nLeft := Eval( ::bLeft ), ), nLeft ) 
   METHOD EvalWidth( nWidth )    INLINE ( if( isBlock( nWidth ), ::bWidth := nWidth, ),;
                                          if( !Empty( ::bWidth ), nWidth := Eval( ::bWidth ), ), nWidth ) 
   METHOD EvalHeight( nHeight )  INLINE ( if( isBlock( nHeight ), ::bHeight := nHeight, ),;
                                          if( !Empty( ::bHeight ), nHeight := Eval( ::bHeight ), ), nHeight ) 

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridable

   local nRow     := if( !empty(::bRow), eval(::bRow), ::nTop )
   local nLeft    := if( !empty(::bCol), eval(::bCol), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )

   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridSay FROM TSay, TGridable

   METHOD Build()

   METHOD New() CONSTRUCTOR

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridSay

   local nRow           := if( hhaskey( hBuilder, "nRow" ),          hBuilder[ "nRow"     ], nil )
   local nCol           := if( hhaskey( hBuilder, "nCol"),           hBuilder[ "nCol"     ], nil )
   local bText          := if( hhaskey( hBuilder, "bText"),          hBuilder[ "bText"    ], nil )
   local oWnd           := if( hhaskey( hBuilder, "oWnd"),           hBuilder[ "oWnd"     ], nil )
   local cPicture       := if( hhaskey( hBuilder, "cPicture"),       hBuilder[ "cPicture" ], nil )   
   local oFont          := if( hhaskey( hBuilder, "oFont"),          hBuilder[ "oFont"    ], nil )
   local lCentered      := if( hhaskey( hBuilder, "lCentered"),      hBuilder[ "lCentered"], nil )   
   local lRight         := if( hhaskey( hBuilder, "lRight"),         hBuilder[ "lRight"   ], nil )
   local lBorder        := if( hhaskey( hBuilder, "lBorder"),        hBuilder[ "lBorder"  ], nil )
   local lPixels        := if( hhaskey( hBuilder, "lPixels"),        hBuilder[ "lPixels"  ], .t. )
   local nClrText       := if( hhaskey( hBuilder, "nClrText"),       hBuilder[ "nClrText" ], nil )   
   local nClrBack       := if( hhaskey( hBuilder, "nClrBack"),       hBuilder[ "nClrBack" ], nil )   
   local nWidth         := if( hhaskey( hBuilder, "nWidth"),         hBuilder[ "nWidth"   ], nil )
   local nHeight        := if( hhaskey( hBuilder, "nHeight"),        hBuilder[ "nHeight"  ], nil )
   local lDesign        := if( hhaskey( hBuilder, "lDesign"),        hBuilder[ "lDesign"  ], nil )
   local lUpdate        := if( hhaskey( hBuilder, "lUpdate"),        hBuilder[ "lUpdate"  ], nil )
   local lShaded        := if( hhaskey( hBuilder, "lShaded"),        hBuilder[ "lShaded"  ], nil )
   local lBox           := if( hhaskey( hBuilder, "lBox"),           hBuilder[ "lBox"     ], nil )
   local lRaised        := if( hhaskey( hBuilder, "lRaised"),        hBuilder[ "lRaised"  ], nil )
   local lAdjust        := if( hhaskey( hBuilder, "lAdjust"),        hBuilder[ "lAdjust"  ], nil )
   local lTransparent   := if( hhaskey( hBuilder, "lTransparent"),   hBuilder[ "lTransparent"], nil )      
   local cVarName       := if( hhaskey( hBuilder, "cVarName"),       hBuilder[ "cVarName" ], nil )   
   local bAction        := if( hhaskey( hBuilder, "bAction"),        hBuilder[ "bAction"  ], nil )

Return ( ::New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised,;
            lAdjust, lTransparent, cVarName, bAction ) )

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised,;
            lAdjust, lTransparent, cVarName, bAction ) CLASS TGridSay

   nRow           := ::EvalRow( nRow )
   nCol           := ::EvalCol( nCol )
   nWidth         := ::EvalWidth( nWidth )
   nHeight        := ::EvalHeight( nHeight )

   ::Super:New( nRow, nCol, bText, oWnd, cPicture, oFont,;
            lCentered, lRight, lBorder, lPixels, nClrText, nClrBack,;
            nWidth, nHeight, lDesign, lUpdate, lShaded, lBox, lRaised,;
            lAdjust, lTransparent, cVarName )

Return Self

//----------------------------------------------------------------------------//

CLASS TGridURLLink FROM TURLLink, TGridable

   METHOD Build()

   METHOD New() CONSTRUCTOR

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridURLLink

   local nTop           := if( hhaskey( hBuilder, "nTop" ),          hBuilder[ "nTop"     ], nil )
   local nLeft          := if( hhaskey( hBuilder, "nLeft" ),         hBuilder[ "nLeft"    ], nil )
   local oWnd           := if( hhaskey( hBuilder, "oWnd"),           hBuilder[ "oWnd"     ], nil )
   local lPixel         := if( hhaskey( hBuilder, "lPixel" ),        hBuilder[ "lPixel"   ], .t. )
   local lDesign        := if( hhaskey( hBuilder, "lDesign"),        hBuilder[ "lDesign"  ], nil )
   local oFont          := if( hhaskey( hBuilder, "oFont" ),         hBuilder[ "oFont"    ], nil )
   local cMsg           := if( hhaskey( hBuilder, "cMsg" ),          hBuilder[ "cMsg"     ], nil )   
   local cURL           := if( hhaskey( hBuilder, "cURL" ),          hBuilder[ "cURL"     ], nil )   
   local cTooltip       := if( hhaskey( hBuilder, "cTooltip" ),      hBuilder[ "lcTooltip"], nil )
   local nClrInit       := if( hhaskey( hBuilder, "nClrInit" ),      hBuilder[ "nClrInit" ], nil )
   local nClrOver       := if( hhaskey( hBuilder, "nClrOver" ),      hBuilder[ "nClrOver" ], nil )   
   local nClrVisit      := if( hhaskey( hBuilder, "nClrVisit" ),     hBuilder[ "nClrVisit"], nil )   
   local bAction        := if( hhaskey( hBuilder, "bAction" ),       hBuilder[ "bAction"  ], nil )

Return ( ::New( nTop, nLeft, oWnd, lPixel, lDesign, oFont, cMsg, cURL, ;
            cToolTip, nClrInit, nClrOver, nClrVisit, bAction ) )

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, lPixel, lDesign, oFont, cMsg, cURL, ;
            cToolTip, nClrInit, nClrOver, nClrVisit, bAction ) CLASS TGridURLLink

   nTop           := ::EvalRow( nTop )
   nLeft          := ::EvalCol( nLeft )

   ::Super:New( nTop, nLeft, oWnd, lPixel, lDesign, oFont, cMsg, cURL, ;
            cToolTip, nClrInit, nClrOver, nClrVisit )

   ::bAction      := bAction

Return Self

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridURLLink

   local nRow     := if( !empty(::bRow), eval(::bRow), ::nTop )
   local nLeft    := if( !empty(::bCol), eval(::bCol), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )

   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridGet FROM TGet, TGridable

   DATA bOldWhen

   METHOD Build( hBuilder ) 

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
               nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
               lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
               lPassword, lNoBorder, nHelpId, lSpinner,;
               bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
               cCueText ) CONSTRUCTOR

   METHOD GotFocus( hCtlLost )   INLINE ( ShowKeyboard(),; 
                                          ::Super:gotFocus( hCtlLost ) )
                                          // ::Super:selectAll() ) // , ::Supper:SetPos( ::oGet:Pos ) )

   METHOD HardEnable()

   METHOD HardDisable()

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
   local lPixel      := if( hhaskey( hBuilder, "lPixel" ),     hBuilder[ "lPixel"   ], .t. )
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

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, lPixel, cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) CLASS TGridGet

   nRow     := ::EvalRow( nRow )
   nCol     := ::EvalCol( nCol )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

   ::Super:New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, cPict, bValid,;
            nClrFore, nClrBack, oFont, lDesign, oCursor, .t., cMsg,;
            lUpdate, bWhen, lCenter, lRight, bChanged, lReadOnly,;
            lPassword, lNoBorder, nHelpId, lSpinner,;
            bUp, bDown, bMin, bMax, bAction, cBmpName, cVarName,;
            cCueText ) 

Return Self

//---------------------------------------------------------------------------//

Method HardEnable() CLASS TGridGet

   ::bWhen     := ::bOldWhen

Return ( ::Enable() )

//---------------------------------------------------------------------------//

Method HardDisable() CLASS TGridGet

   ::bOldWhen  := ::bWhen
   ::bWhen     := {|| .f. }

return ( ::Disable() )

//----------------------------------------------------------------------------//

CLASS TGridMultiGet FROM TMultiGet, TGridable

   METHOD Build( hBuilder ) 

   METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, oFont, lHScroll,;
            nClrFore, nClrBack, oCursor, lPixel, cMsg, lUpdate,;
            bWhen, lCenter, lRight, lReadOnly, bValid, bChanged,;
            lDesign, lNoBorder, lNoVScroll )

   METHOD GotFocus( hCtlLost )   INLINE ( ShowKeyboard(), ::Super:GotFocus( hCtlLost ) )

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridMultiGet
   
   local nRow        := if( hhaskey( hBuilder, "nRow" ),       hBuilder[ "nRow"     ], nil )
   local nCol        := if( hhaskey( hBuilder, "nCol" ),       hBuilder[ "nCol"     ], nil )
   local bSetGet     := if( hhaskey( hBuilder, "bSetGet" ),    hBuilder[ "bSetGet"  ], nil )
   local oWnd        := if( hhaskey( hBuilder, "oWnd" ),       hBuilder[ "oWnd"     ], nil )
   local nWidth      := if( hhaskey( hBuilder, "nWidth" ),     hBuilder[ "nWidth"   ], nil )
   local nHeight     := if( hhaskey( hBuilder, "nHeight" ),    hBuilder[ "nHeight"  ], nil )
   local oFont       := if( hhaskey( hBuilder, "oFont" ),      hBuilder[ "oFont"    ], nil )
   local lHScroll    := if( hhaskey( hBuilder, "lHScroll" ),   hBuilder[ "lHScroll" ], nil )
   local nClrFore    := if( hhaskey( hBuilder, "nClrFore" ),   hBuilder[ "nClrFore" ], nil )
   local nClrBack    := if( hhaskey( hBuilder, "nClrBack" ),   hBuilder[ "nClrBack" ], nil )
   local oCursor     := if( hhaskey( hBuilder, "oCursor" ),    hBuilder[ "oCursor"  ], nil )
   local lPixel      := if( hhaskey( hBuilder, "lPixel" ),     hBuilder[ "lPixel"   ], .t. )
   local cMsg        := if( hhaskey( hBuilder, "cMsg" ),       hBuilder[ "cMsg"     ], nil )
   local lUpdate     := if( hhaskey( hBuilder, "lUpdate" ),    hBuilder[ "lUpdate"  ], nil )
   local bWhen       := if( hhaskey( hBuilder, "bWhen" ),      hBuilder[ "bWhen"    ], nil )
   local lCenter     := if( hhaskey( hBuilder, "lCenter" ),    hBuilder[ "lCenter"  ], nil )
   local lRight      := if( hhaskey( hBuilder, "lRight" ),     hBuilder[ "lRight"   ], nil )
   local lReadOnly   := if( hhaskey( hBuilder, "lReadOnly" ),  hBuilder[ "lReadOnly"], nil )
   local bValid      := if( hhaskey( hBuilder, "bValid" ),     hBuilder[ "bValid"   ], nil )
   local bChanged    := if( hhaskey( hBuilder, "bChanged" ),   hBuilder[ "bChanged" ], nil )
   local lDesign     := if( hhaskey( hBuilder, "lDesign" ),    hBuilder[ "lDesign"  ], nil )
   local lNoBorder   := if( hhaskey( hBuilder, "lNoBorder" ),  hBuilder[ "lNoBorder"], nil )
   local lNoVScroll  := if( hhaskey( hBuilder, "lNoVScroll" ), hBuilder[ "lNoVScroll"], nil )
   
Return ( ::New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, oFont, lHScroll,;
         nClrFore, nClrBack, oCursor, lPixel, cMsg, lUpdate,;
         bWhen, lCenter, lRight, lReadOnly, bValid, bChanged,;
         lDesign, lNoBorder, lNoVScroll ) )

//---------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, oFont, lHScroll,;
            nClrFore, nClrBack, oCursor, lPixel, cMsg, lUpdate,;
            bWhen, lCenter, lRight, lReadOnly, bValid, bChanged,;
            lDesign, lNoBorder, lNoVScroll ) CLASS TGridMultiGet

   nRow     := ::EvalRow( nRow )
   nCol     := ::EvalCol( nCol )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

   ::Super:New( nRow, nCol, bSetGet, oWnd, nWidth, nHeight, oFont, lHScroll,;
            nClrFore, nClrBack, oCursor, lPixel, cMsg, lUpdate,;
            bWhen, lCenter, lRight, lReadOnly, bValid, bChanged,;
            lDesign, lNoBorder, lNoVScroll ) 

Return Self

//---------------------------------------------------------------------------//

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

   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridImage FROM TImage, TGridable

   METHOD Build()

   METHOD New() 

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridImage

   local nTop           := if( hhaskey( hBuilder, "nTop"          ), hBuilder[ "nTop"        ], nil )            
   local nLeft          := if( hhaskey( hBuilder, "nLeft"         ), hBuilder[ "nLeft"       ], nil )               
   local nWidth         := if( hhaskey( hBuilder, "nWidth"        ), hBuilder[ "nWidth"      ], nil )               
   local nHeight        := if( hhaskey( hBuilder, "nHeight"       ), hBuilder[ "nHeight"     ], nil )               
   local cResName       := if( hhaskey( hBuilder, "cResName"      ), hBuilder[ "cResName"    ], nil )                  
   local cBmpFile       := if( hhaskey( hBuilder, "cBmpFile"      ), hBuilder[ "cBmpFile"    ], nil )                  
   local lNoBorder      := if( hhaskey( hBuilder, "lNoBorder"     ), hBuilder[ "lNoBorder"   ], .t. )
   local oWnd           := if( hhaskey( hBuilder, "oWnd"          ), hBuilder[ "oWnd"        ], nil )            
   local bLClicked      := if( hhaskey( hBuilder, "bLClicked"     ), hBuilder[ "bLClicked"   ], nil )
   local bRClicked      := if( hhaskey( hBuilder, "bRClicked"     ), hBuilder[ "bRClicked"   ], nil )
   local lScroll        := if( hhaskey( hBuilder, "lScroll"       ), hBuilder[ "lScroll"     ], nil )
   local lStretch       := if( hhaskey( hBuilder, "lStretch"      ), hBuilder[ "lStretch"    ], nil )
   local oCursor        := if( hhaskey( hBuilder, "oCursor"       ), hBuilder[ "oCursor"     ], nil )
   local cMsg           := if( hhaskey( hBuilder, "cMsg"          ), hBuilder[ "cMsg"        ], nil )
   local lUpdate        := if( hhaskey( hBuilder, "lUpdate"       ), hBuilder[ "lUpdate"     ], .t. )
   local bWhen          := if( hhaskey( hBuilder, "bWhen"         ), hBuilder[ "bWhen"       ], nil )
   local lPixel         := if( hhaskey( hBuilder, "lPixel"        ), hBuilder[ "lPixel"      ], .t. )
   local bValid         := if( hhaskey( hBuilder, "bValid"        ), hBuilder[ "bValid"      ], nil )
   local lDesign        := if( hhaskey( hBuilder, "lDesign"       ), hBuilder[ "lDesign"     ], nil )
   local cVarName       := if( hhaskey( hBuilder, "cVarName"      ), hBuilder[ "cVarName"    ], nil )

Return   (  ::New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign, cVarName ) )

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign, cVarName ) CLASS TGridImage

   nTop     := ::EvalTop( nTop )
   nLeft    := ::EvalLeft( nLeft )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

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

CLASS TGridBtnBmp FROM TBtnBmp// , TGridable

   METHOD New()

   METHOD Build()

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridBtnBmp

   local nTop           := if( hhaskey( hBuilder, "nTop"          ), hBuilder[ "nTop"        ], nil )            
   local nLeft          := if( hhaskey( hBuilder, "nLeft"         ), hBuilder[ "nLeft"       ], nil )               
   local nWidth         := if( hhaskey( hBuilder, "nWidth"        ), hBuilder[ "nWidth"      ], nil )               
   local nHeight        := if( hhaskey( hBuilder, "nHeight"       ), hBuilder[ "nHeight"     ], nil )               
   local cResName1      := if( hhaskey( hBuilder, "cResName1"     ), hBuilder[ "cResName1"   ], nil )                  
   local cResName2      := if( hhaskey( hBuilder, "cResName2"     ), hBuilder[ "cResName2"   ], nil )                  
   local cBmpFile1      := if( hhaskey( hBuilder, "cBmpFile1"     ), hBuilder[ "cBmpFile1"   ], nil )                  
   local cBmpFile2      := if( hhaskey( hBuilder, "cBmpFile2"     ), hBuilder[ "cBmpFile2"   ], nil )                  
   local bAction        := if( hhaskey( hBuilder, "bAction"       ), hBuilder[ "bAction"     ], nil )               
   local oWnd           := if( hhaskey( hBuilder, "oWnd"          ), hBuilder[ "oWnd"        ], nil )            
   local cMsg           := if( hhaskey( hBuilder, "cMsg"          ), hBuilder[ "cMsg"        ], ""  )            
   local bWhen          := if( hhaskey( hBuilder, "bWhen"         ), hBuilder[ "bWhen"       ], nil )               
   local lAdjust        := if( hhaskey( hBuilder, "lAdjust"       ), hBuilder[ "lAdjust"     ], .f. )               
   local lUpdate        := if( hhaskey( hBuilder, "lUpdate"       ), hBuilder[ "lUpdate"     ], .t. )               
   local cPrompt        := if( hhaskey( hBuilder, "cPrompt"       ), hBuilder[ "cPrompt"     ], ""  )               
   local oFont          := if( hhaskey( hBuilder, "oFont"         ), hBuilder[ "oFont"       ], nil )               
   local cResName3      := if( hhaskey( hBuilder, "cResName3"     ), hBuilder[ "cResName3"   ], nil )                  
   local cBmpFile3      := if( hhaskey( hBuilder, "cBmpFile3"     ), hBuilder[ "cBmpFile3"   ], nil )                  
   local lBorder        := if( hhaskey( hBuilder, "lBorder"       ), hBuilder[ "lBorder"     ], .f. )               
   local cLayout        := if( hhaskey( hBuilder, "cLayout"       ), hBuilder[ "cLayout"     ], nil )               
   local l2007          := if( hhaskey( hBuilder, "l2007"         ), hBuilder[ "l2007"       ], .f. )               
   local cResName4      := if( hhaskey( hBuilder, "cResName4"     ), hBuilder[ "cResName4"   ], nil )                  
   local cBmpFile4      := if( hhaskey( hBuilder, "cBmpFile4"     ), hBuilder[ "cBmpFile4"   ], nil )                  
   local lTransparent   := if( hhaskey( hBuilder, "lTransparent"  ), hBuilder[ "lTransparent"], .f. )                     
   local cToolTip       := if( hhaskey( hBuilder, "cToolTip"      ), hBuilder[ "cToolTip"    ], nil ) 
   local lRound         := if( hhaskey( hBuilder, "lRound"        ), hBuilder[ "lRound"      ], nil )
   local bGradColors    := if( hhaskey( hBuilder, "bGradColors"   ), hBuilder[ "bGradColors" ], nil )
   local lPixel         := if( hhaskey( hBuilder, "lPixel"        ), hBuilder[ "lPixel"      ], nil )
   local lDesign        := if( hhaskey( hBuilder, "lDesign"       ), hBuilder[ "lDesign"     ], nil )

Return   (  ::New( nTop, nLeft, nWidth, nHeight,;
            cResName1, cResName2, cBmpFile1, cBmpFile2,;
            bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
            cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
            l2007, cResName4, cBmpFile4, lTransparent, cToolTip, lRound,;
            bGradColors, lPixel, lDesign ) )

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight,;
            cResName1, cResName2, cBmpFile1, cBmpFile2,;
            bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
            cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
            l2007, cResName4, cBmpFile4, lTransparent, cToolTip, lRound,;
            bGradColors, lPixel, lDesign ) CLASS TGridBtnBmp
/*
   nTop     := ::EvalTop( nTop )
   nLeft    := ::EvalLeft( nLeft )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )
*/
Return ( ::Super:New( nTop, nLeft, nWidth, nHeight,;
         cResName1, cResName2, cBmpFile1, cBmpFile2,;
         bAction, oWnd, cMsg, bWhen, lAdjust, lUpdate,;
         cPrompt, oFont, cResName3, cBmpFile3, lBorder, cLayout, ;
         l2007, cResName4, cBmpFile4, lTransparent, cToolTip, lRound,;
         bGradColors, lPixel, lDesign ) )

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridBtnBmp

   local nTop     := if( !empty(::bTop), eval(::bTop), ::nTop )
   local nLeft    := if( !empty(::bLeft), eval(::bLeft), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )

   ::Move( nTop, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridComboBox FROM TComboBox, TGridable

   METHOD Build( hBuilder )

   METHOD New()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridComboBox

   local nRow        := if( hhaskey( hBuilder, "nRow" ),       hBuilder[ "nRow"     ], nil )
   local nCol        := if( hhaskey( hBuilder, "nCol" ),       hBuilder[ "nCol"     ], nil )
   local bSetGet     := if( hhaskey( hBuilder, "bSetGet" ),    hBuilder[ "bSetGet"  ], nil )
   local aItems      := if( hhaskey( hBuilder, "aItems" ),     hBuilder[ "aItems"   ], nil )
   local nWidth      := if( hhaskey( hBuilder, "nWidth" ),     hBuilder[ "nWidth"   ], nil )
   local nHeight     := if( hhaskey( hBuilder, "nHeight" ),    hBuilder[ "nHeight"  ], nil )
   local oWnd        := if( hhaskey( hBuilder, "oWnd" ),       hBuilder[ "oWnd"     ], nil )
   local nHelpId     := if( hhaskey( hBuilder, "nHelpId" ),    hBuilder[ "nHelpId"  ], nil )
   local bChange     := if( hhaskey( hBuilder, "bChange" ),    hBuilder[ "bChange"  ], nil )
   local bValid      := if( hhaskey( hBuilder, "bValid" ),     hBuilder[ "bValid"   ], nil )
   local nClrFore    := if( hhaskey( hBuilder, "nClrFore" ),   hBuilder[ "nClrFore" ], nil )
   local nClrBack    := if( hhaskey( hBuilder, "nClrBack" ),   hBuilder[ "nClrBack" ], nil )
   local lPixel      := if( hhaskey( hBuilder, "lPixel" ),     hBuilder[ "lPixel"   ], .t. )
   local oFont       := if( hhaskey( hBuilder, "oFont" ),      hBuilder[ "oFont"    ], nil )
   local cMsg        := if( hhaskey( hBuilder, "cMsg" ),       hBuilder[ "cMsg"     ], nil )
   local lUpdate     := if( hhaskey( hBuilder, "lUpdate" ),    hBuilder[ "lUpdate"  ], nil )
   local bWhen       := if( hhaskey( hBuilder, "bWhen" ),      hBuilder[ "bWhen"    ], nil )
   local lDesign     := if( hhaskey( hBuilder, "lDesign" ),    hBuilder[ "lDesign"  ], nil )
   local acBitmaps   := if( hhaskey( hBuilder, "acBitmaps" ),  hBuilder[ "acBitmaps"], nil )
   local bDrawItem   := if( hhaskey( hBuilder, "bDrawItem" ),  hBuilder[ "bDrawItem"], nil )
   local nStyle      := if( hhaskey( hBuilder, "nStyle" ),     hBuilder[ "nStyle"   ], nil )
   local cPict       := if( hhaskey( hBuilder, "cPict" ),      hBuilder[ "cPict"    ], nil )
   local bEChange    := if( hhaskey( hBuilder, "bEChange" ),   hBuilder[ "bEChange" ], nil )
   local cVarName    := if( hhaskey( hBuilder, "cVarName" ),   hBuilder[ "cVarName" ], nil )

Return ( ::New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId,;
            bChange, bValid, nClrFore, nClrBack, lPixel, oFont,;
            cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, nStyle,;
            cPict, bEChange, cVarName ) )

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId,;
            bChange, bValid, nClrFore, nClrBack, lPixel, oFont,;
            cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, nStyle,;
            cPict, bEChange, cVarName ) CLASS TGridComboBox

   nRow     := ::EvalRow( nRow )
   nCol     := ::EvalCol( nCol )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

   ::Super:New( nRow, nCol, bSetGet, aItems, nWidth, nHeight, oWnd, nHelpId,;
            bChange, bValid, nClrFore, nClrBack, lPixel, oFont,;
            cMsg, lUpdate, bWhen, lDesign, acBitmaps, bDrawItem, nStyle,;
            cPict, bEChange, cVarName ) 

Return Self

//----------------------------------------------------------------------------//

CLASS TGridIXBrowse FROM IXBrowse, TGridable

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD ReAdjust()

   local nRow     
   local nLeft    
   local nWidth   
   local nHeight  

   nRow     		:= if( !empty(::bRow), eval(::bRow), ::nTop )
   nLeft    		:= if( !empty(::bCol), eval(::bCol), ::nLeft )
   nWidth   		:= if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   nHeight  		:= if( !empty(::bHeight), eval(::bHeight), ::nHeight )

   ::Move( nRow, nLeft, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//

CLASS TGridTreeView FROM TTreeView, TGridable

   METHOD Build()

   METHOD New()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridTreeView

   local nTop        := if( hhaskey( hBuilder, "nTop" ),          hBuilder[ "nTop"        ], nil )
   local nLeft       := if( hhaskey( hBuilder, "nLeft" ),         hBuilder[ "nLeft"       ], nil )
   local oWnd        := if( hhaskey( hBuilder, "oWnd" ),          hBuilder[ "oWnd"        ], nil )
   local nClrFore    := if( hhaskey( hBuilder, "nClrFore" ),      hBuilder[ "nClrFore"    ], nil )
   local nClrBack    := if( hhaskey( hBuilder, "nClrBack" ),      hBuilder[ "nClrBack"    ], nil )
   local lPixel      := if( hhaskey( hBuilder, "lPixel" ),        hBuilder[ "lPixel"      ], .t. )
   local lDesign     := if( hhaskey( hBuilder, "lDesign" ),       hBuilder[ "lDesign"     ], nil )
   local nWidth      := if( hhaskey( hBuilder, "nWidth" ),        hBuilder[ "nWidth"      ], nil )
   local nHeight     := if( hhaskey( hBuilder, "nHeight" ),       hBuilder[ "nHeight"     ], nil )
   local cMsg        := if( hhaskey( hBuilder, "cMsg" ),          hBuilder[ "cMsg"        ], nil )
   local lCheckBoxes := if( hhaskey( hBuilder, "lCheckBoxes" ),   hBuilder[ "lCheckBoxes" ], .f. )
   local bChange     := if( hhaskey( hBuilder, "bChange" ),       hBuilder[ "bChange"     ], nil )

Return ( ::New( nTop, nLeft, oWnd, nClrFore, nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, lCheckBoxes, bChange ) ) 

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, nClrFore, nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, lCheckBoxes, bChange ) CLASS TGridTreeView

   nTop     := ::EvalTop( nTop )
   nLeft    := ::EvalLeft( nLeft )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

   ::Super:New( nTop, nLeft, oWnd, nClrFore, nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, lCheckBoxes, bChange )

Return Self

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//


CLASS TGridCheckBox FROM TCheckBox, TGridable

   METHOD Build( hBuilder )

   METHOD New()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridCheckBox

   local nRow        := if( hhaskey( hBuilder, "nRow" ),       hBuilder[ "nRow"       ], nil )
   local nCol        := if( hhaskey( hBuilder, "nCol" ),       hBuilder[ "nCol"       ], nil )
   local cCaption    := if( hhaskey( hBuilder, "cCaption" ),   hBuilder[ "cCaption"   ], nil )
   local bSetGet     := if( hhaskey( hBuilder, "bSetGet" ),    hBuilder[ "bSetGet"    ], nil )
   local oWnd        := if( hhaskey( hBuilder, "oWnd" ),       hBuilder[ "oWnd"       ], nil )
   local nWidth      := if( hhaskey( hBuilder, "nWidth" ),     hBuilder[ "nWidth"     ], nil )
   local nHeight     := if( hhaskey( hBuilder, "nHeight" ),    hBuilder[ "nHeight"    ], nil )
   local nHelpTopic  := if( hhaskey( hBuilder, "nHelpTopic" ), hBuilder[ "nHelpTopic" ], nil )
   local bChange     := if( hhaskey( hBuilder, "bChange" ),    hBuilder[ "bChange"    ], nil )
   local bValid      := if( hhaskey( hBuilder, "bValid" ),     hBuilder[ "bValid"     ], nil )
   local nClrFore    := if( hhaskey( hBuilder, "nClrFore" ),   hBuilder[ "nClrFore"   ], nil )
   local nClrBack    := if( hhaskey( hBuilder, "nClrBack" ),   hBuilder[ "nClrBack"   ], nil )
   local lPixel      := if( hhaskey( hBuilder, "lPixel" ),     hBuilder[ "lPixel"     ], .t. )
   local oFont       := if( hhaskey( hBuilder, "oFont" ),      hBuilder[ "oFont"      ], nil )
   local cMsg        := if( hhaskey( hBuilder, "cMsg" ),       hBuilder[ "cMsg"       ], nil )
   local lUpdate     := if( hhaskey( hBuilder, "lUpdate" ),    hBuilder[ "lUpdate"    ], nil )
   local bWhen       := if( hhaskey( hBuilder, "bWhen" ),      hBuilder[ "bWhen"      ], nil )
   local lDesign     := if( hhaskey( hBuilder, "lDesign" ),    hBuilder[ "lDesign"    ], nil )

Return ( ::New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight,;
               nHelpTopic, bChange, oFont, bValid, nClrFore, nClrBack,;
               lDesign, lPixel, cMsg, lUpdate, bWhen ) )

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight,;
               nHelpTopic, bChange, oFont, bValid, nClrFore, nClrBack,;
               lDesign, lPixel, cMsg, lUpdate, bWhen ) CLASS TGridCheckBox

   nRow     := ::EvalRow( nRow )
   nCol     := ::EvalCol( nCol )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

   ::Super:New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight,;
               nHelpTopic, bChange, oFont, bValid, nClrFore, nClrBack,;
               lDesign, lPixel, cMsg, lUpdate, bWhen ) 

Return Self

//----------------------------------------------------------------------------//

CLASS TGridMeter FROM TApoloMeter, TGridable

   METHOD Build()

   METHOD New() 

   METHOD ReAdjust()

END CLASS

//----------------------------------------------------------------------------//

METHOD Build( hBuilder ) CLASS TGridMeter

   local nRow           := if( hhaskey( hBuilder, "nRow"          ), hBuilder[ "nRow"           ], nil )
   local nCol           := if( hhaskey( hBuilder, "nCol"          ), hBuilder[ "nCol"           ], nil )
   local bSetGet        := if( hhaskey( hBuilder, "bSetGet"       ), hBuilder[ "bSetGet"        ], nil )
   local nTotal         := if( hhaskey( hBuilder, "nTotal"        ), hBuilder[ "nTotal"         ], 0 )
   local oWnd           := if( hhaskey( hBuilder, "oWnd"          ), hBuilder[ "oWnd"           ], nil )
   local nWidth         := if( hhaskey( hBuilder, "nWidth"        ), hBuilder[ "nWidth"         ], nil )
   local nHeight        := if( hhaskey( hBuilder, "nHeight"       ), hBuilder[ "nHeight"        ], nil )
   local lUpdate        := if( hhaskey( hBuilder, "lUpdate"       ), hBuilder[ "lUpdate"        ], nil )
   local lPixel         := if( hhaskey( hBuilder, "lPixel"        ), hBuilder[ "lPixel"         ], nil )
   local oFont          := if( hhaskey( hBuilder, "oFont"         ), hBuilder[ "oFont"          ], nil )
   local cText          := if( hhaskey( hBuilder, "cText"         ), hBuilder[ "cText"          ], nil )
   local lNoPercentage  := if( hhaskey( hBuilder, "lNoPercentage" ), hBuilder[ "lNoPercentage"  ], nil )
   local nClrPane       := if( hhaskey( hBuilder, "nClrPane"      ), hBuilder[ "nClrPane"       ], nil )
   local nClrText       := if( hhaskey( hBuilder, "nClrText"      ), hBuilder[ "nClrText"       ], nil )
   local nClrBar        := if( hhaskey( hBuilder, "nClrBar"       ), hBuilder[ "nClrBar"        ], nil )
   local nClrBText      := if( hhaskey( hBuilder, "nClrBText"     ), hBuilder[ "nClrBText"      ], nil )
   local lDesign        := if( hhaskey( hBuilder, "lDesign"       ), hBuilder[ "lDesign"        ], nil )

Return   (  ::New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
            lUpdate, lPixel, oFont, cText, lNoPercentage, nClrPane, nClrText, ;
            nClrBar, nClrBText, lDesign ) )

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
            lUpdate, lPixel, oFont, cText, lNoPercentage, nClrPane, nClrText, ;
            nClrBar, nClrBText, lDesign ) CLASS TGridMeter

   nRow     := ::EvalTop( nRow )
   nCol     := ::EvalLeft( nCol )
   nWidth   := ::EvalWidth( nWidth )
   nHeight  := ::EvalHeight( nHeight )

   ::Super:New( nRow, nCol, bSetGet, nTotal, oWnd, nWidth, nHeight,;
            lUpdate, lPixel, oFont, cText, lNoPercentage, nClrPane, nClrText, ;
            nClrBar, nClrBText, lDesign ) 

return Self

//----------------------------------------------------------------------------//

METHOD ReAdjust() CLASS TGridMeter

   local nRow     := if( !empty(::bRow), eval(::bRow), ::nTop )
   local nCol    := if( !empty(::bCol), eval(::bCol), ::nLeft )
   local nWidth   := if( !empty(::bWidth), eval(::bWidth), ::nWidth )
   local nHeight  := if( !empty(::bHeight), eval(::bHeight), ::nHeight )

   ::Move( nRow, nCol, nWidth, nHeight )  

return Self

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

Function oGridFont()

   if empty( oFont )
      oFont       := TFont():New( "Segoe UI Light", 0, 42, .f., .f. ) // Segoe UI Light"
   end if 

Return ( oFont )   

//----------------------------------------------------------------------------//

Function oGridFontBold()

   if empty( oFontBold )
      oFontBold   := TFont():New( "Segoe UI", 0, 42, .f., .t. ) // Segoe UI Light"
   end if 

Return ( oFontBold )   

//----------------------------------------------------------------------------//

Function nGridColor()

Return ( Rgb( 78, 166, 234 ) )

//----------------------------------------------------------------------------//

Function GridMaximize( oDlg )

Return ( oDlg:Maximize() )

//----------------------------------------------------------------------------//

Function GridResize( oDlg )

   local o

   for each o in oDlg:aControls
      if ( "TGRID" $ o:ClassName()  )
         o:ReAdjust()
      end if
   next

Return nil   

//----------------------------------------------------------------------------//

Function GridRow( nLines )
   
   DEFAULT nLines    := 1

Return ( nLines * 35 )

//----------------------------------------------------------------------------//

Function GridWidth( nCols, oDlg )
   
Return ( oDlg:nWidth() / 12 * nCols )

//----------------------------------------------------------------------------//

Function GridHeigth( oDlg )
   
Return ( oDlg:nHeight() )

//----------------------------------------------------------------------------//

Function ShowKeyboard( lNumeric )

 	ShellExecute( 0, "open", "tabtip.exe" )

Return .t. 

//----------------------------------------------------------------------------//

Static Function HideKeyboard()

   SendMessage( FindWindow( 0, "Teclado en pantalla" ), WM_CLOSE )

Return .t. 

//----------------------------------------------------------------------------//



