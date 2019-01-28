#include "FiveWin.ch"

//----------------------------------------------------------------------------//

// Class TExplorerBar

#define COLOR_BTNFACE   15
#define COLOR_LINK      RGB( 10, 152, 234 )

#define TME_LEAVE         2
#define WM_MOUSELEAVE   675

//Bitmap Array Columns

#define BMP_HANDLE         1
#define BMP_BRIGHT         2
#define BMP_HASALPHA       3
#define BMP_WIDTH          4
#define BMP_HEIGHT         5

//Bitmap Array position
#define BMPDEFAULT         0
#define BMPEXPAND          1
#define BMPCOLLAP          2

#define GWL_STYLE       (-16)
#define D_HEIGHT           13

//----------------------------------------------------------------------------//

CLASS TApoloExplorerBar FROM  TExplorerBar

   METHOD AddPanel( cName, cBmpName )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD AddPanel( cName, cBmpName, nBodyHeight ) CLASS TApoloExplorerBar

   local oPanel

   oPanel := aadd( ::aPanels, TApoloTaskPanel():New( cName, Self, len( ::aPanels ), cBmpName, nBodyHeight ) )

   ::CheckScroll( oPanel )

RETURN oPanel

//----------------------------------------------------------------------------//

CLASS TApoloTaskPanel FROM TTaskPanel

   METHOD New( cTitle, oWnd, nIndex, cBmpPanel, nBodyHeight, nTitleH, nRound, aGrad, oFont, nClrT, nClrP ) 

   METHOD getTopControl()

   METHOD setHeight( nTop, nHeight )

   METHOD loadBitmaps( nType, cnBitmap )

   METHOD Refresh()                    INLINE ( nil )

   METHOD addLink( cPrompt, bAction, cBitmap, oFnt, nClrT, nClrP, nClrO )

   METHOD addLinkAndData( cLink, cData, bAction, cBitmap )

   METHOD addGetSelector( cPrompt, cGet ) 

   METHOD addGetAction( cPrompt, cGet, bAction )

   METHOD addComboBox( cPrompt, cItem, aItems )

   METHOD addCheckBox( cPrompt, lCheckBox )

   METHOD addLeftCheckBox( cPrompt, lCheckBox ) ;
                                       INLINE ( ::addCheckBox( cPrompt, lCheckBox, 10 ) )
   
   METHOD addColorCheckBox( cPrompt, lCheckBox, nColor )

   METHOD addLeftColorCheckBox( cPrompt, lCheckBox, nColor ) ;
                                       INLINE ( ::addColorCheckBox( cPrompt, lCheckBox, nColor, 10 )  )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cTitle, oWnd, nIndex, cBmpPanel, nBodyHeight, nTitleH, nRound, aGrad, oFont, nClrT, nClrP ) CLASS TApoloTaskPanel

   DEFAULT aGrad  := {  { RGB( 240, 240, 240 ), RGB( 240, 240, 240 ) },;
                        { RGB( 240, 240, 240 ), RGB( 240, 240, 240 ) } }
   DEFAULT nClrT  := RGB( 0, 0, 0 )
   DEFAULT nClrP  := RGB( 255, 255, 255 )
   
RETURN ( ::Super:New( cTitle, oWnd, nIndex, cBmpPanel, nBodyHeight, nTitleH, nRound, aGrad, oFont, nClrT, nClrP ) )   

//----------------------------------------------------------------------------//

METHOD getTopControl() CLASS TApoloTaskPanel

RETURN ( ::nHeight + 5 )

//----------------------------------------------------------------------------//

METHOD setHeight( nTop, nHeight ) CLASS TApoloTaskPanel

   if nTop + nHeight > ::nHeight
      ::nHeight      := nTop + nHeight 
      ::nBodyHeight  := ::nHeight - ::nTitleHeight
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD loadBitmaps( nType, cnBitmap ) CLASS TApoloTaskPanel

   local nWidth
   local nHeight
   local hBitmap
   local lHasAlpha

   DEFAULT nType  := BMPDEFAULT

   if nType > BMPCOLLAP .OR. nType < BMPDEFAULT
      RETURN ( nil )
   endif

   if nType == BMPDEFAULT
      ::aBitmaps  := {}
      hBitmap     := fwBmpDes()
      aadd( ::aBitmaps, { hBitmap, 0, HasAlpha( hBitmap ), nBmpWidth( hBitmap ), nBmpHeight( hBitmap ) } )
      ::aBitmaps[ BMPEXPAND ][ BMP_BRIGHT ]  := BrightImg( ::hDC, hBitmap, 90 )
      hBitmap     := fwBmpAsc()
      aadd( ::aBitmaps, { hBitmap, 0, HasAlpha( hBitmap ), nBmpWidth( hBitmap ), nBmpHeight( hBitmap ) } )
      ::aBitmaps[ BMPCOLLAP ][ BMP_BRIGHT ]  := BrightImg( ::hDC, hBitmap, 90 )
   else
      if file( cnBitmap )
         hBitmap  := ReadBitmap( 0, cnBitmap )
      else
         hBitmap  := LoadBitmap( GetResources(), cnBitmap )
      endif
      nWidth      := nBmpWidth( hBitmap )
      nHeight     := nBmpHeight( hBitmap )
      lHasAlpha   := HasAlpha( hBitmap )
      DeleteObject( ::aBitmaps[ nType ][ BMP_HANDLE ] )
      DeleteObject( ::aBitmaps[ nType ][ BMP_BRIGHT ] )
      ::aBitmaps[ nType ] := { hBitmap, , lHasAlpha, nWidth, nHeight }
      ::aBitmaps[ nType ][ BMP_BRIGHT ] = BrightImg( ::hDC, hBitmap, 2 )
   endif

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addLink( cPrompt, bAction, cBitmap, oFnt, nClrT, nClrP, nClrO ) CLASS TApoloTaskPanel

   local n
   local nTop  
   local oUrlLink

   nTop                 := ::getTopControl()

   DEFAULT nClrT        := COLOR_LINK
   DEFAULT nClrO        := COLOR_LINK

   oUrlLink             := TUrlLink():New( nTop, 33, Self, .T., .F., if( hb_isnil( oFnt ), ::oFont, oFnt ), "", cPrompt, , nClrT, nClrP, nClrO )
   
   if !hb_isnil( nClrT )
      oUrlLink:nClrText := nClrT
   endif

   if hb_isnil( nClrO )
      oUrlLink:nClrOver := ::nClrHover
   else  
      oUrlLink:nClrOver := nClrO
   end if 
   
   oUrlLink:SetColor( oUrlLink:nClrText, if( hb_isnil( nClrP ), ::nClrPane, nClrP ) )

   oUrlLink:bAction     := bAction

   if !empty( cBitmap )
      oUrlLink:hBmp     := LoadBitmap( GetResources(), cBitmap )
   endif

   ::setHeight( nTop, oUrlLink:nHeight )

   ::UpdateRegion()

RETURN ( oUrlLink )

//----------------------------------------------------------------------------//

METHOD addLinkAndData( cLink, cPrompt, bAction, cBitmap ) CLASS TApoloTaskPanel

   local nTop                 
   local oUrlLink

   nTop                       := ::getTopControl()

   oUrlLink                   := ::addLink( cLink, bAction, cBitmap )

   @ nTop, 110 SAY oUrlLink:Cargo PROMPT cPrompt OF Self RIGHT PIXEL COLOR Rgb( 10, 152, 234 ), Rgb( 255, 255, 255 ) SIZE ( Self:nWidth - 110 ), 12

   oUrlLink:Cargo:lWantClick  := .t.
   oUrlLink:Cargo:OnClick     := bAction

   ::UpdateRegion()

RETURN ( oUrlLink )

//----------------------------------------------------------------------------//

METHOD addGetAction( cPrompt, bSetGet, bAction ) CLASS TApoloTaskPanel

   local oSay
   local oGet
   local nTop        := ::getTopControl()

   @ nTop + 3, 10 SAY oSay PROMPT cPrompt OF Self PIXEL COLOR Rgb( 10, 152, 234 ), Rgb( 255, 255, 255 )

   oSay:lWantClick   := .t.
   oSay:OnClick      := bAction

   oGet              := TGet():New( nTop, 120, bSetGet, Self, 460, 20,,,,,, .f.,, .t.,, .f.,, .f., .f.,, .f., .f.,,,,,,,, bAction, "Lupa", "oGet" )

   ::setHeight( oGet:nTop, oGet:nHeight )

   ::UpdateRegion()

RETURN ( oGet )

//----------------------------------------------------------------------------//

METHOD addGetSelector( cPrompt, cGet ) CLASS TApoloTaskPanel

   local oGet
   local cHelp
   local oHelp
   local oPrompt
   local nTop           := ::getTopControl()

   @ nTop + 3, 10 SAY oPrompt PROMPT cPrompt OF Self PIXEL COLOR Rgb( 10, 152, 234 ), Rgb( 255, 255, 255 )

   oPrompt:lWantClick   := .t.

   @ nTop, 120 GET oGet VAR cGet SIZE 100, 20 ACTION msgInfo( "helpAction()" ) BITMAP "Lupa" OF Self PIXEL

   @ nTop, 222 GET oHelp VAR cHelp SIZE 360, 20 WHEN ( .f. ) OF Self PIXEL

   ::setHeight( oGet:nTop, oGet:nHeight )

   ::UpdateRegion()

RETURN ( oGet )

//----------------------------------------------------------------------------//

METHOD addComboBox( cPrompt, cItem, aItems ) CLASS TApoloTaskPanel

   local oSay
   local oCbx
   local nTop        := ::getTopControl()

   @ nTop + 6, 10 SAY oSay PROMPT cPrompt OF Self PIXEL COLOR RGB( 0, 0, 0 ), RGB( 255, 255, 255 )

   @ nTop, 120 COMBOBOX oCbx VAR cItem ITEMS aItems SIZE 400, 460 OF Self PIXEL HEIGHTGET 20  

   ::setHeight( oCbx:nTop, oCbx:nHeight )
   
   ::UpdateRegion()

RETURN ( oCbx )

//----------------------------------------------------------------------------//

METHOD AddCheckBox( cPrompt, lCheckBox, nLeft ) CLASS TApoloTaskPanel

   local oChk
   local nTop        := ::getTopControl()

   DEFAULT nLeft     := 120

   @ nTop, nLeft CHECKBOX oChk VAR lCheckBox PROMPT cPrompt SIZE 400, 12 OF Self PIXEL 

   ::setHeight( oChk:nTop, oChk:nHeight )

   ::UpdateRegion()

RETURN ( oChk )

//----------------------------------------------------------------------------//

METHOD AddColorCheckBox( cPrompt, lCheckBox, nColor, nLeft ) CLASS TApoloTaskPanel

   local oChk
   local oSay
   local nTop        := ::getTopControl()

   DEFAULT nColor    := rgb( 0, 0 , 0)
   DEFAULT nLeft     := 120

   @ nTop, nLeft SAY oSay PROMPT "" SIZE 12, 12 COLOR nColor, nColor OF Self PIXEL 

   @ nTop, nLeft + 20 CHECKBOX oChk VAR lCheckBox PROMPT cPrompt SIZE 400, 12 OF Self PIXEL 

   ::setHeight( oChk:nTop, oChk:nHeight )
   
   ::UpdateRegion()

RETURN ( oChk )

//----------------------------------------------------------------------------//

