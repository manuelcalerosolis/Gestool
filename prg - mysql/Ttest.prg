#include "FiveWin.Ch"
#include "Objects.ch"
#include "Menu.ch"
#include "Factu.ch" 
#include "WColors.ch"
#include "Font.ch"
#include "Constant.ch"

#define SC_MAXIMIZE           61488    // 0xF030

#define WM_ERASEBKGND         20       // 0x14
#define WM_CHILDACTIVATE      34       // 0x22
#define WM_ICONERASEBKGND     39       // 0x27

#define  ACC_APPD             1        // Acceso Total
#define  ACC_EDIT             2        // Solo modificar
#define  ACC_ZOOM             3        // Solo visualizar

//------------------------------------------------------------------------//

CLASS TTest FROM TMdiChild

   DATA  oBrw
   DATA  oBtnBar
   DATA  oBtnTop
   DATA  oMsgBar
   DATA  oTabs
   DATA  oFont
   DATA  oIcon
   DATA  cAlias
   DATA  cTitle
   DATA  aPrompt
   DATA  aFastKey
   DATA  aFlds       AS ARRAY    INIT {}
   DATA  aHeaders    AS ARRAY    INIT {}
   DATA  aColSizes   AS ARRAY    INIT {}
   DATA  aColSelect  AS ARRAY    INIT {}
   DATA  aColPos     AS ARRAY    INIT {}
   DATA  aJustify    AS ARRAY    INIT {}
   DATA  nLevel
   DATA  lCenter
   DATA  nSizeBtn
   DATA  aMru        AS ARRAY    INIT {}
   DATA  aKey        AS ARRAY    INIT {}
   DATA  oTxtSea
   DATA  aLstSea     AS ARRAY    INIT {}
   DATA  lMru        AS LOGIC    INIT .t.
   DATA  cMru
   DATA  oIni
   DATA  nRecno
   DATA  lMin
   DATA  lZoom
   DATA  lNoSave     AS LOGIC    INIT .f.
   DATA  aOriginal   AS ARRAY    INIT {}
   DATA  lBmpMenu    AS LOGIC    INIT .f.
   DATA  lAutoSeek   AS LOGIC    INIT .t.
   DATA  bExpFilter
   DATA  aRecFilter  AS ARRAY
   DATA  dbfTmp      AS CHARACTER     INIT "TMP"
   DATA  lNewStyle   AS LOGIC    INIT .t.
   DATA  lDrag       AS LOGIC

   METHOD New( nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
               oCursor, lPixel, nHelpId, aFlds, cAlias, aHeaders,;
               aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel, bDup,;
               nSizeBtn, nLevel, cMru, cInifile, lNewStyle ) CONSTRUCTOR

   METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit,;
                    bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp )

   METHOD Paint()

   METHOD PaintTitle()

	METHOD GotFocus()

	METHOD KeyChar( nKey, nFlags )

   METHOD End()

   METHOD Destroy()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()

endCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, cTitle, oMenu, oWnd, oIcon,;
             oCursor, lPixel, nHelpId, aFlds, cAlias, aHeaders,;
             aColSizes, aColSelect, aJustify, aPrompt, bAdd, bEdit, bDel,;
             bDup, nSizeBtn, nLevel, cMru, cInifile, lNewStyle ) CLASS TShell

   local n
   local cSea
   local nSize
   local aRect
   local bLine
   local aLine
   local nFlds
   local lSelect
   local nRecno
   local nClrFore
   local aTmpFld
   local aTmpHea
   local aTmpJus
   local aCorIni     := Array( 4 )
   local aFont       := Array( 15 )
   local nStyle      := 0

   DEFAULT cTitle    := "MDI Child"
   DEFAULT oWnd      := GetWndFrame()
   DEFAULT lPixel    := .f.
   DEFAULT oIcon     := TIcon():New( ,, "BROWSE",, )
   DEFAULT oCursor   := TCursor():New( , "ARROW" )
   DEFAULT cAlias    := Alias()
   DEFAULT aPrompt   := NIL
   DEFAULT nSizeBtn  := 42
   DEFAULT nLevel    := ACC_APPD
   DEFAULT aColSizes := {}
   DEFAULT aColSelect:= {}
   DEFAULT aJustify  := {}
   DEFAULT lNewStyle := lNewStyle()

   ::lMru            := ( cMru != NIL )

   /*
   adaptamos la longitud de pantalla a la resolución
   */

   aRect := GetWndRect( GetDeskTopWindow() )
   if aRect[4] >= 800
      nBottom  += 6
      nRight   += 20
   endif

   ::nTop            := nTop
   ::nLeft           := nLeft
   ::nBottom         := nBottom
   ::nRight          := nRight
   ::cTitle          := cTitle
	::aFastKey			:= {}
   ::aPrompt         := aPrompt
   ::oFont           := TFont():New( "Ms Sans Serif", 6, 12, .F. )
   ::oIcon           := oIcon
   ::nSizeBtn        := nSizeBtn
   ::cMru            := cMru
   ::aKey            := {}
   ::aFlds           := aFlds
   ::aHeaders        := aHeaders
   ::aColSizes       := aColSizes
   ::aColSelect      := aColSelect
   ::aJustify        := aJustify
   ::lNewStyle       := lNewStyle

   /*
   Tamaño de la ventana siempre a pixels---------------------------------------
   */

   ::nTop            := nTop    * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nLeft           := nLeft   * if( !lPixel, MDIC_CHARPIX_W, 1 )
   ::nBottom         := nBottom * if( !lPixel, MDIC_CHARPIX_H, 1 )
   ::nRight          := nRight  * if( !lPixel, MDIC_CHARPIX_W, 1 )

   ::nTop            := if( aCorIni[1] != 0, aCorIni[1], ::nTop )
   ::nLeft           := if( aCorIni[2] != 0, aCorIni[2], ::nLeft )
   ::nBottom         := if( aCorIni[3] != 0, aCorIni[3], ::nBottom )
   ::nRight          := if( aCorIni[4] != 0, aCorIni[4], ::nRight  )

   if ::nTop < 0
      ::nTop := 0
   end if

   if ::nLeft < 0
      ::nLeft := 0
   end if

   if ::nBottom > oWnd:oWndClient:nHeight()
      ::nBottom := oWnd:oWndClient:nHeight()
   end if

   if ::nRight > oWnd:oWndClient:nWidth()
      ::nRight := oWnd:oWndClient:nWidth()
   end if

   /*
   Llamada al objeto padre para que se cree------------------------------------
   */

   Super:New( ::nTop, ::nLeft, ::nBottom, ::nRight, cTitle, nStyle, oMenu, oWnd,;
            oIcon, , , , oCursor, , .t., , nHelpId, , .f., .f., .f., .f. )

   /*
   Barra de botones-----------------------------------------------------------
   */

      @ 0, 0 WEBBAR        ::oBtnBar ;
               SIZE        144, 200 ;
               CTLHEIGHT   18 ;
               RESOURCE    "WEBLEFT" ;
               OF          Self

      ::oLeft              := ::oBtnBar

      @ 0, 0 WEBBAR        ::oBtnTop ;
               SIZE        400, 58 ;
               CTLHEIGHT   18 ;
               FONT        ( ::oFont ) ; //TFont():New( "Verdana", 0, -18, .f., .t. ) );
               RESOURCE    "WEBTOP" ;
               OF          Self

      ::oBtnTop:Say( 30, 160, ::cTitle )
      ::oTop               := ::oBtnTop

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit,;
                    bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp, lCenter ) CLASS TShell

   local nUp         := 0

   DEFAULT lCenter   := ::nTop == 0 .and. ::nLeft == 0

   ::lCenter         := lCenter

   super:activate( cShow, bLClicked, bRClicked, bMoved, bResized, bPainted,;
                    bKeyDown, bInit,;
                    bUp, bDown, bPgUp, bPgDn,;
                    bLeft, bRight, bPgLeft, bPgRight, bValid, bDropFiles,;
                    bLButtonUp )

   if ::lCenter
      ::Center( ::hWnd )
   end if

   if ::lMin
      ::Minimize()
   end if

   ::Maximize()

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TShell

   if IsIconic( ::hWnd )
      if Upper( ::ClassName() ) == "TMDICHILD" // ChildLevel( TMdiChild() ) > 0
         ::SendMsg( WM_ERASEBKGND, ::hDC, 0 )
      else
         ::SendMsg( WM_ICONERASEBKGND, ::hDC, 0 )
      endif
      DrawIcon( ::hDC, 0, 0, If( ::oIcon != nil, ::oIcon:hIcon, ExtractIcon( "user.exe" ) ) )
   else
      if ValType( ::bPainted ) == "B"
         return Eval( ::bPainted, ::hDC, ::cPS, Self )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TSehll

	Super:GotFocus()

   if ::oBrw != NIL
		::oBrw:SetFocus()
   end if

return 0

//----------------------------------------------------------------------------//