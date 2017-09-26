#include "FiveWin.Ch"
#include "Font.ch"
#include "Constant.ch"

#define COLOR_INACTIVECAPTION 3
#define COLOR_WINDOW          5
#define COLOR_WINDOWTEXT      8
#define COLOR_BTNFACE        15
#define COLOR_BTNSHADOW      16
#define COLOR_BTNHIGHLIGHT   20

#define FD_BORDER             8
#define FD_HEIGHT            22

#define DT_CENTER             1
#define DT_VCENTER            4

#define WINDING               2
#define SC_KEYMENU        61696   // 0xF100

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TTabs FROM TControl

   CLASSDATA lRegistered AS LOGICAL
   CLASSDATA aProperties INIT { "aPrompts", "nAlign", "nClrText", "nClrPane",;
                                "nOption", "nTop", "nLeft", "nWidth",;
                                "nHeight", "Cargo" }

   DATA   aPrompts, aSizes
   DATA   nOption
   DATA   bAction
   DATA   cMode

   METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nOption, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg, cMode ) CONSTRUCTOR

   METHOD ReDefine( nId, aPrompts, bAction, oWnd, nOption, nClrFore,;
                    nClrBack ) CONSTRUCTOR

   METHOD Display()
   METHOD Paint()
   METHOD Initiate( hDlg )
   METHOD LButtonDown( nRow, nCol, nFlags )
   METHOD Default()
   METHOD AddItem( cItem )

   METHOD DelItem()

   METHOD SetOption( nOption )

   METHOD SetTabs( aTabs, nOption )

   METHOD GetHotPos( nChar )

   METHOD SysCommand( nType, nLoWord, nHiWord )

   METHOD Inspect( cData )

   METHOD EditPrompts()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nOption, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg, cMode ) CLASS TTabs

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT nTop     := 0, nLeft := 0,;
           aPrompts := { "&One", "&Two", "T&hree" },;
           oWnd     := GetWndDefault(),;
           nOption  := 1,;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_BTNFACE ),;
           lPixel   := .f.,;
           lDesign  := .f.,;
           nWidth   := 200,;
           nHeight  := 24 ,;
           cMode    := "BOTTOM"

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::aPrompts  = aPrompts
   ::bAction   = bAction
   ::nOption   = nOption
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::oFont     = TFont():New( "Ms Sans Serif", 0, -9 )
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack
   ::cMode     = cMode

   DEFINE BRUSH ::oBrush STYLE TABS

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()

   if ! Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, aPrompts, bAction, oWnd, nOption, nClrFore,;
                 nClrBack ) CLASS TTabs

   DEFAULT nOption  := 1,;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_BTNFACE )

   ::nId      = nId
   ::oWnd     = oWnd
   ::aPrompts = aPrompts
   ::bAction  = bAction
   ::nOption  = nOption
   ::oFont    = TFont():New( "Ms Sans Serif", 0, -9 )
   ::nClrText = nClrFore
   ::nClrPane = nClrBack
   ::cMode    = "BOTTOM"

   ::Register()

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Display() CLASS TTabs

   ::BeginPaint()
   ::Paint()
   ::EndPaint()

return 0

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TTabs

   local n
   local hOldFont
   local hOldBrush
   local hOldPen
   local nCol        := 5
   local hDC         := ::GetDC()
   local hDarkPen    := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
   local hGrayPen    := CreatePen( PS_SOLID, 1, ::nClrPane )
   local hLightPen   := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )
   local hGrayBrush  := CreateSolidBrush( ::nClrPane )
   local hDarkBrush  := CreateSolidBrush( GetSysColor( COLOR_INACTIVECAPTION ) )

   hOldFont  = SelectObject( hDC, ::oFont:hFont )
   hOldPen   = SelectObject( hDC, hDarkPen )
   hOldBrush = SelectObject( hDC, hDarkBrush )

   if Len( ::aSizes ) < Len( ::aPrompts )
      ::Default()
   endif

   if ::cMode == "BOTTOM"

      SelectObject( hDC, hGrayPen )
      MoveTo( hDC, 0, 1 )
      LineTo( hDC, ::nWidth(), 1 )
      MoveTo( hDC, 0, 2 )
      LineTo( hDC, ::nWidth(), 2 )

      SetBlackPen( hDC )
      MoveTo( hDC, 0, 3 )
      LineTo( hDC, ::nWidth(), 3 )

      for n = 1 to Len( ::aPrompts )

         if n == ::nOption

            SelectObject( hDC, hGrayBrush )
            SetBlackPen( hDC )
            PolyPolygon( hDC, {  { nCol, 3 },;
                                 { nCol , 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8, 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8 + 17, 3 } } )

            SelectObject( hDC, hLightPen )
            MoveTo( hDC, nCol , 3 )
            LineTo( hDC, nCol , 20 )

            SelectObject( hDC, hGrayPen )
            MoveTo( hDC, nCol , 3 )
            LineTo( hDC, nCol + 4 + ::aSizes[ n ] + 8 + 17, 3 )

            SetTextColor( hDC, ::nClrText )
            SetBkColor( hDC, ::nClrPane )
            DrawText( hDC, ::aPrompts[ n ],;
                   { 5, nCol + 4, 19, nCol + 5 + ::aSizes[ n ] + 5 },;
                   nOr( DT_CENTER, DT_VCENTER ) )

         else

            SelectObject( hDC, hDarkBrush )
            SetBlackPen( hDC )
            PolyPolygon( hDC, {  { nCol, 3 },;
                                 { nCol , 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8, 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8 + 17, 3 } } )

            SelectObject( hDC, hGrayPen )
            MoveTo( hDC, nCol , 4 )
            LineTo( hDC, nCol , 20 )

            SetTextColor( hDC, CLR_WHITE )
            SetBkColor( hDC, GetSysColor( COLOR_INACTIVECAPTION ) )
            DrawText( hDC, ::aPrompts[ n ],;
                      { 5, nCol + 3, 19, nCol + 5 + ::aSizes[ n ] + 6 },;
                      nOr( DT_CENTER, DT_VCENTER ) )

         endif

         nCol += 4 + ::aSizes[ n ] + 26

      next

   elseif ::cMode == "TOP"

      MoveTo( hDC, 0, ::nHeight() )
      LineTo( hDC, ::nWidth(), ::nHeight() )

      SetWhitePen( hDC )
      MoveTo( hDC, 0, ::nHeight() -3  )
      LineTo( hDC, ::nWidth(), ::nHeight() - 3 )

      for n = 1 to Len( ::aPrompts )

         if n == ::nOption

            SelectObject( hDC, hGrayBrush )
            SetBlackPen( hDC )
            PolyPolygon( hDC, {  { nCol, ::nHeight() - 3 },;
                                 { nCol , ::nHeight() - 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8, ::nHeight() - 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8, ::nHeight() - 3 } } )

            SelectObject( hDC, hLightPen )
            MoveTo( hDC, nCol , ::nHeight() - 3 )
            LineTo( hDC, nCol , ::nHeight() - 20 )

            SelectObject( hDC, hGrayPen )
            MoveTo( hDC, nCol , ::nHeight() - 3 )
            LineTo( hDC, nCol + 4 + ::aSizes[ n ] + 8, ::nHeight() - 3 )

            SetTextColor( hDC, CLR_BLACK )
            SetBkColor( hDC, ::nClrPane )
            DrawText( hDC, ::aPrompts[ n ],;
                   { ::nHeight() - 19, nCol + 4, ::nHeight() - 5, nCol + 5 + ::aSizes[ n ] + 5 },;
                   nOr( DT_CENTER, DT_VCENTER ) )

         else
/*
            SelectObject( hDC, hDarkBrush )
            SetBlackPen( hDC )
            PolyPolygon( hDC, {  { nCol , ::nHeight() -  3 },;
                                 { nCol , ::nHeight() - 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8, ::nHeight() - 20 },;
                                 { nCol + 4 + ::aSizes[ n ] + 8, ::nHeight() - 3 } } )
*/
            SelectObject( hDC, hGrayPen )
            MoveTo( hDC, nCol , ::nHeight() - 4 )
            LineTo( hDC, nCol , ::nHeight() - 20 )

            SetTextColor( hDC, CLR_WHITE )
            SetBkColor( hDC, ::nClrPane ) //GetSysColor( COLOR_INACTIVECAPTION ) )
            DrawText( hDC, ::aPrompts[ n ],;
                      { ::nHeight() - 19 , nCol + 3, ::nHeight() - 5, nCol + 5 + ::aSizes[ n ] + 6 },;
                      nOr( DT_CENTER, DT_VCENTER ) )


         end if

        nCol += 4 + ::aSizes[ n ] + 26

      next

   end if

   SelectObject( hDC, hOldPen )
   SelectObject( hDC, hOldFont )
   SelectObject( hDC, hOldBrush )

   DeleteObject( hDarkPen )
   DeleteObject( hGrayPen )
   DeleteObject( hLightPen )
   DeleteObject( hDarkBrush )
   DeleteObject( hGrayBrush )

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TTabs

   Super:Initiate( hDlg )

   if ::oBrush == nil
      DEFINE BRUSH ::oBrush STYLE TABS
   endif

   ::Default()

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TTabs

   local n := 1, nPos := 5

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   else
      if nRow <= FD_HEIGHT
         while nCol > nPos + ::aSizes[ n ] + 30 .and. n < Len( ::aPrompts )
            nPos += ::aSizes[ n ] + 30
            n++
         end
         ::SetOption( n )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TTabs

   local n

   ::aSizes = Array( Len( ::aPrompts ) )

   for n = 1 to Len( ::aPrompts )
      ::aSizes[ n ] = GetTextWidth( 0, StrTran( ::aPrompts[ n ], "&", "" ),;
                                    ::oFont:hFont )
   next

return nil

//----------------------------------------------------------------------------//

METHOD AddItem( cItem ) CLASS TTabs

   AAdd( ::aPrompts, cItem )
   ::Default()
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD DelItem() CLASS TTabs

   if Len( ::aPrompts ) > 1
      ::aPrompts = ADel( ::aPrompts, ::nOption )
      ::aPrompts = ASize( ::aPrompts, Len( ::aPrompts ) - 1 )
   else
      ::aPrompts = { "No Defined" }
   endif
   ::Default()
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SetOption( nOption ) CLASS TTabs

   if nOption != ::nOption
      ::nOption = nOption
      ::Paint()
      if ! Empty( ::bAction )
         Eval( ::bAction, nOption )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GetHotPos( nChar ) CLASS TTabs

   local n := 1
   local nAt

   while n <= Len( ::aPrompts )
     if ( nAt := At( "&", ::aPrompts[ n ] ) ) != 0 .and. ;
        Lower( SubStr( ::aPrompts[ n ], nAt + 1, 1 ) ) == Chr( nChar )
        return n
     endif
     n++
   end

return 0

//----------------------------------------------------------------------------//

METHOD SysCommand( nType, nLoWord, nHiWord ) CLASS TTabs

   local nItem

   do case
      case nType == SC_KEYMENU      // Alt+... control accelerator pressed
           if ( nItem := ::GetHotPos( nLoWord ) ) > 0
              ::SetOption( nItem )
              return 0
           endif
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD SetTabs( aTabs, nOption ) CLASS TTabs

   DEFAULT aTabs := { "&One", "&Two", "T&hree" }, nOption := 1

   ::aPrompts = aTabs
   ::nOption  = nOption
   ::Default()
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD Inspect( cData ) CLASS TTabs

   if cData == "aPrompts"
      return { || ::EditPrompts() }
   endif

return nil

//----------------------------------------------------------------------------//

METHOD EditPrompts() CLASS TTabs

   local oDlg, n
   local cPrompts := ""
   local oFont
   local lOk := .f.
   local aPrompts := {}

   for n = 1 to Len( ::aPrompts )
      cPrompts += ::aPrompts[ n ] + CRLF
   next

   DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0, -9

   DEFINE DIALOG oDlg SIZE 300, 178 TITLE "Edit prompts" FONT oFont

   @ 0.2, 0.3 GET cPrompts MEMO SIZE 145, 70

   @ 7.5, 10.1 BUTTON "&Ok"     SIZE 30, 11 ACTION ( lOk := .t., oDlg:End() )
   @ 7.5, 22.1 BUTTON "&Cancel" SIZE 30, 11 ACTION oDlg:End()

   ACTIVATE DIALOG oDlg CENTERED

   if lOk
      for n = 1 to MLCount( cPrompts )
         AAdd( aPrompts, AllTrim( MemoLine( cPrompts,, n ) ) )
      next
      ::SetTabs( aPrompts, 1 )
   endif

return nil

//----------------------------------------------------------------------------//