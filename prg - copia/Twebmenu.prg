#include "FiveWin.Ch"
#include "Factu.ch" 
#include "font.ch"

#define COLOR_MENU                 4
#define COLOR_MENUTEXT             7
#define COLOR_ACTIVECAPTION        2
#define COLOR_CAPTIONTEXT          9
#define COLOR_ACTIVEBORDER        16   //BTNSHADOW
#define COLOR_INACTIVEBORDER      14   //HIGHLIGHTTEXT

#define STEP_CTL        2
#define STEP_BMP        5

#define TRANSPARENT     1

#define MARGENLEFT      1
#define MARGENRIGHT     1
#define MARGENTOP       1
#define MARGENBOT       1

#define SRCCOPY         13369376

//---------------------------------------------------------------------------//

function TestWebMnu()

   local oMenu
   local oItem1, oItem2, oItem3

   oMenu    := TWebMenu():New( 1, Rgb( 255, 154, 49 ), Rgb( 0, 0, 0 ), "Title", nil, .t. )

   oItem1   := TWebBtn():NewBar( ,;                                         //cResName1,
                                 ,;                                         //cResName2,
                                 ,;                                         //cBmpFile1,
                                 ,;                                         //cBmpFile2
                                 {||msginfo( "Test" ) },;                   //bAction
                                 oMenu,;                                    //oBar
                                 "Message",;                                //cMsg
                                 nil,;                                      //bWhen
                                 ,;                                         // lAdjust
                                 .t.,;                                      //lUpdate
                                 "cPrompt 1",;                              //cPrompt
                                 "LEFT",;                                   //cPad
                                 ,;                                         //oFont
                                 ,;                                         //oFontOver
                                 ,;                                         //cResName3
                                 ,;                                         //cBmpFile3
                                 Rgb( 255, 154, 49 ),;                      //nClrText
                                 Rgb( 0, 0, 0 ),;                           //nClrTextOver
                                 Rgb( 0, 0, 0 ),;                           //nClrPane
                                 Rgb( 255, 154, 49 ),;                      //nClrPaneOver,
                                 .f.,;                                      //lBorder,
                                 "cToolTip",;                               //cToolTip
                                 ,;                                         //bDrop,
                                 ,;                                         //bMenu,
                                 )                                          //lGroup )
   oItem2   := TWebBtn():NewBar( ,;                                         //cResName1,
                                 ,;                                         //cResName2,
                                 ,;                                         //cBmpFile1,
                                 ,;                                         //cBmpFile2
                                 {||msginfo( "Test" ) },;                   //bAction
                                 oMenu,;                                    //oBar
                                 "Message",;                                //cMsg
                                 nil,;                                      //bWhen
                                 ,;                                         // lAdjust
                                 .t.,;                                      //lUpdate
                                 "cPrompt 2",;                              //cPrompt
                                 "LEFT",;                                   //cPad
                                 ,;                                         //oFont
                                 ,;                                         //oFontOver
                                 ,;                                         //cResName3
                                 ,;                                         //cBmpFile3
                                 Rgb( 255, 154, 49 ),;                      //nClrText
                                 Rgb( 0, 0, 0 ),;                           //nClrTextOver
                                 Rgb( 0, 0, 0 ),;                           //nClrPane
                                 Rgb( 255, 154, 49 ),;                      //nClrPaneOver,
                                 .f.,;                                      //lBorder,
                                 "cToolTip",;                               //cToolTip
                                 ,;                                         //bDrop,
                                 ,;                                         //bMenu,
                                 )                                          //lGroup )

   oItem3   := TWebBtn():NewBar( ,;                                         //cResName1,
                                 ,;                                         //cResName2,
                                 ,;                                         //cBmpFile1,
                                 ,;                                         //cBmpFile2
                                 {||msginfo( "Test" ) },;                   //bAction
                                 oMenu,;                                    //oBar
                                 "Message",;                                //cMsg
                                 nil,;                                      //bWhen
                                 ,;                                         // lAdjust
                                 .t.,;                                      //lUpdate
                                 "cPrompt 3",;                              //cPrompt
                                 "LEFT",;                                   //cPad
                                 ,;                                         //oFont
                                 ,;                                         //oFontOver
                                 ,;                                         //cResName3
                                 ,;                                         //cBmpFile3
                                 Rgb( 255, 154, 49 ),;                      //nClrText
                                 Rgb( 0, 0, 0 ),;                           //nClrTextOver
                                 Rgb( 0, 0, 0 ),;                           //nClrPane
                                 Rgb( 255, 154, 49 ),;                      //nClrPaneOver,
                                 .f.,;                                      //lBorder,
                                 "cToolTip",;                               //cToolTip
                                 ,;                                         //bDrop,
                                 ,;                                         //bMenu,
                                 )                                          //lGroup )

   oMenu:Activate( 10, 100, oWnd() )

return nil

//---------------------------------------------------------------------------//

CLASS TWebMenu FROM TWindow

      CLASSDATA l3d         AS LOGICAL INIT .t.
      CLASSDATA lRegistered AS LOGICAL

      DATA aControls        AS ARRAY INIT {}
      DATA aCoors           // Array for store the coordinates of the oItems // { nTop, nLeft, nBottom, nRight }
      DATA aItems           // Array of oItems Objects

      DATA cTitle
      DATA hBmpPal
      DATA cBitmap

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
      DATA nLeftMargin
      DATA nRightMargin
      DATA nTopMargin
      DATA nBotMargin
      DATA lSepLine     AS LOGICAL  INIT .f.

      DATA nCtlHeight
      DATA nOldOption   // The last option drawed
      DATA nOption      // Active option in the menu
      DATA nRight
      DATA nTop

      DATA oItemP
      DATA oOpen
      DATA oTitle

      METHOD New( nOption, nClrText, nClrPane, cTitle, oFont, l3D, oItem,;
                  cBmpBack  ) CONSTRUCTOR

      METHOD Add( oItem )

      METHOD Activate( nRow, nCol, oWnd )

      METHOD LButtonDown( nRow, nCol, nKeyFlags )
      METHOD LButtonUp  ( nRow, nCol, nKeyFlags )

      METHOD MouseMove  ( nRow, nCol, nKeyFlags )

      METHOD Paint()
      METHOD PaintData( hDC )
      METHOD PaintSelect()

      METHOD Show() INLINE ::lVisible := .t., Super:Show()

      METHOD Destroy()

      METHOD GetOption( nRow, nCol )

      MESSAGE nWTitle METHOD _nWTitle()
      MESSAGE nHTitle METHOD _nHTitle()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nOption, nClrText, nClrPane, cTitle, oFont, l3D, cBitmap, nCtlHeight, nWidth )

   DEFAULT nClrText  := GetSysColor( COLOR_MENUTEXT )
   DEFAULT nClrPane  := GetSysColor( COLOR_MENU )
   DEFAULT l3D       := .f.
   DEFAULT nOption   := 1
   DEFAULT cTitle    := "Menu"
   DEFAULT nCtlHeight:= 18
   DEFAULT nWidth    := 100

   ::nTop            := 1
   ::nLeft           := 1
   ::nBottom         := 10
   ::nRight          := nWidth

   ::nLeftMargin     := MARGENLEFT
   ::nRightMargin    := MARGENRIGHT
   ::nTopMargin      := MARGENTOP
   ::nBotMargin      := MARGENBOT
   ::nCtlHeight      := nCtlHeight
   ::nWidth          := nWidth

   ::lPaintedOp      := .f.

   ::nLen            := 0
   ::l3D             := l3D
   ::nOption         := nOption
   ::nOldOption      := nOption

   ::nStyle          := nOr( WS_POPUP, WS_VISIBLE )

   if oFont == nil
      DEFINE FONT ::oFont NAME "Ms Sans Serif" SIZE 5, 13
      ::lKillFont    := .t.
   else
      ::oFont        := oFont
      ::lKillFont    := .f.
   endif

   ::Register()
   ::Create()

   ::SetColor( nClrText, nClrPane )

   ::cTitle          := cTitle

   ::nClrOption      := GetSysColor( COLOR_ACTIVECAPTION )
   ::nClrSelText     := if( ::l3d, ::nClrText, GetSysColor( COLOR_CAPTIONTEXT   ) )

   ::nClrBAct        :=  CLR_WHITE
   ::nClrBInAct      :=  CLR_GRAY

   ::lPressed        := .f.
   ::lCaptured       := .f.
   ::cBitmap         := cBitmap

Return self

//---------------------------------------------------------------------------//

METHOD Add( oItem, nPos ) CLASS TMenu

  if nPos == nil
     AAdd( ::aControls, oItem )
  else
     AAdd( ::aControls, nil )
     AIns( ::aControls, nPos )
     ::aControls[ nPos ] = oItem
  endif

Return nil

//---------------------------------------------------------------------------//

METHOD Activate( nRow, nCol, oWnd )

   local aPoint   := { nRow, nCol }
   local nHeight  := ::nTopMargin
   local n

   ::lHasControls    := Len( ::aControls ) > 0

   If ::lVisible
      ::lPaintedOp   := .f.
   endif

   if ::oTitle != nil
      nHeight += ::nHTitle
   endif

   if ::lHasControls

      for n := 1 to Len( ::aControls )
         nHeight  += ::aControls[n]:nHeight
         nHeight  += STEP_CTL
      next

   end if

   nHeight  += ::nBotMargin

   ClientToScreen( oWnd:hWnd, aPoint )

   SetWindowPos( ::hWnd, 0, nRow, nCol, ::nWidth, nHeight, 4 )

   ::Show()

Return nil

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TMenu

   local n
   local o
   local lDC         := .f.
   local nRow        := 0
   local nCol        := 0
   local hOldPen
   local hLinePen
   local nWidth
   local nHeight
   local nBmpWidth
   local nBmpHeight

   ::AEvalWhen()

   oWnd():cTitle     := ""

   if ::hDC == nil
      ::GetDC()
      lDC      := .t.
   end if

   if !Empty( ::hBmpPal )

      nWidth      := ::nWidth()
      nHeight     := ::nHeight()
      nBmpWidth   := nbmpwidth( ::hBmpPal )
      nBmpHeight  := nBmpHeight( ::hBmpPal )

      while nRow <= nHeight
         nCol := 0
         while nCol <= nWidth
            PalBmpDraw( ::hDC, nRow, nCol, ::hBmpPal )
            nCol += nBmpWidth
         end
         nRow += nBmpHeight
      end

   end if

   nRow  := 0

   if ::aControls != nil

      for n := 1 to len( ::aControls )

         o  := ::aControls[ n ]
         if Upper( o:ClassName() ) != "TCOMBOBOX"
         o:Move( nRow + ::nTopMargin, ::nLeftMargin, o:nWidth, o:nHeight, .t. )
         o:Show()
         end if
         nRow  += o:nHeight
         oWnd():cTitle  += str( nRow ) + "|"

         if ::lSepLine
            hLinePen := CreatePen( PS_SOLID, 1, ::nClrLine )
            hOldPen  := SelectObject( ::hDC, hLinePen )
            MoveTo( ::hDC, 0, nRow + 1 )
            LineTo( ::hDC, o:nWidth, nRow + 1 )
            SelectObject( ::hDC, hOldPen )
            DeleteObject( hLinePen )
         end if

         nRow  += STEP_CTL

      next

   end if

   if lDC
      ::ReleaseDC()
   end if

Return nil

//---------------------------------------------------------------------------//

METHOD Destroy()

   local n

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

return Super:Destroy()

//---------------------------------------------------------------------------//

METHOD GetOption( nRow, nCol )

   ::nOption   := Int( nRow / ::nCtlHeight ) + 1

Return ( ::nOption )

//---------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags )

   ::GetOption ( nRow, nCol )

   SetFocus( ::hWnd )    // To let the main window child control
   SysRefresh()          // process its valid

   if GetFocus() == ::hWnd
      ::lCaptured = .t.
      ::lPressed  = .t.
      ::Capture()
      ::PaintSelect()
   endif

return 0

//---------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nKeyFlags )

   local lClick   := IsOverWnd( ::hWnd, nRow, nCol )

   ::GetOption ( nRow, nCol )

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

//---------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags )

   ::GetOption( nRow, nCol )

   If IsOverWnd( ::hWnd, nRow, nCol )

      ::Capture()
      ::aControls[ ::nOldOption ]:Paint( .f. )
      ::aControls[ ::nOption ]:Paint( .t. )

   else

      ::lPressed   := .f.
      ::lPaintedOp := .f.
      ::nOldOption := ::nOption
      ReleaseCapture()

   endif

return super:MouseMove( nRow, nCol, nKeyFlags )

//---------------------------------------------------------------------------//

METHOD PaintData( hDC )

   local n
   local nOldMode
   local nOldColor
   local hOldFont
   local nTop, nLeft, nBottom, nRight
   local hOldPen


   local hMemDC   := hDC

   nOldColor      := SetTextColor( hMemDC, ::nClrText  )
   nOldMode       := SetBkMode   ( hMemDC, TRANSPARENT )
   hOldFont       := SelectObject( hMemDC, ::oFont:hFont )

   Moveto( hMemDC, ::nWidth-1, 0 )
   Lineto( hMemDC, ::nWidth-1, ::nHeight -1 )
   Lineto( hMemDC,         -1, ::nHeight -1 )

   if ::nLen > 0

      for n := 1 to ::nLen

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

//---------------------------------------------------------------------------//

METHOD PaintSelect() CLASS TMenu

   local n
   local hDC
   local nOldMode, nOldColor, hOldFont
   local nTop, nLeft, nWidth, nHeight

   // voy a pintar en el siguiente paso un bmp construido en memoria
   // y en paint solo pintar‚ de verdad la opci¢n activa

   hDC := ::GetDC()

   if ::nOldOption != nil
      n :=    ::nOldOption
      nTop    := ::aCoors[ n ][1]
      nLeft   := ::aCoors[ n ][2]
      nWidth  := ::aCoors[ n ][4] - ::aCoors[ n ][2] + 1
      nHeight := ::aCoors[ n ][3] - ::aCoors[ n ][1] + 1
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

//---------------------------------------------------------------------------//

METHOD _nWTitle()

   Local nWidth := 0

   if ::oTitle != nil
      nWidth := ::oTitle:nWidth
   endif

return nWidth

//---------------------------------------------------------------------------//

METHOD _nHTitle()

   local nHeight := 0

   if ::oTitle != nil
      nHeight := ::oTitle:nHeight
   endif

return nHeight

//---------------------------------------------------------------------------//

function TestShell()

   LOCAL n
   local oWnd

   for n := 1 to 50
      oWnd  := Articulo( "01002", oWnd() )
      msgwait( "Test" + str( n ) , , 1 )
      oWnd:end()
   next

   /*
   local oWndBrw
   local aTabla      := {  { "1", "Uno" },;
                           { "2", "Dos" },;
                           { "3", "Tres" },;
                           { "4", "Cuatro" },;
                           { "5", "Cinco" } }

   DEFINE SHELL oWndBrw FROM 0, 0 TO 22, 80 ;
         TITLE    "Test" ;
			FIELDS ;
                  aTabla[ oBrw:nAt, 1 ],;
                  aTabla[ oBrw:nAt, 2 ] ;
         HEAD ;
                  "Num",;
                  "Text";
			FIELDSIZES ;
						17,;
                  220;
         PROMPTS  "Número";
         JUSTIFY  .T., .F. ;
         OF       oWnd()

		DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "NEW" OF oWndBrw ;
			NOBORDER ;
         ACTION   ( msginfo( "Uno" ) );
			TOOLTIP 	"(A)ñadir";
			HOTKEY 	"A"

      DEFINE BTNSHELL RESOURCE "END"  GROUP OF oWndBrw;
			NOBORDER ;
			ACTION 	( oWndBrw:End() ) ;
			TOOLTIP 	"Salir" ;
			HOTKEY 	"S"

   ACTIVATE WINDOW oWndBrw ON INIT ( oWndBrw:oBrw:SetArray( aTabla ) )
   */

return nil