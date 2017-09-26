// FWPPC Class TWBrowse (C) FiveTech Software 2005

#define _FOLDER_CH
#define _ODBC_CH
#define _TREE_CH

#include "FiveWin.ch"
#include "InKey.ch"
#include "Set.ch"
#include "Constant.ch"
#include "Report.ch"

#define GW_HWNDFIRST          0
#define GW_HWNDLAST           1
#define GW_HWNDNEXT           2
#define GWL_STYLE           -16

#define HWND_BROADCAST    65535  // 0xFFFF

#define CS_DBLCLKS            8

#define SYS_COLOR_INDEX_FLAG  0x40000000

#define COLOR_ACTIVECAPTION  nOr(  2, SYS_COLOR_INDEX_FLAG )
#define COLOR_WINDOW         nOr(  5, SYS_COLOR_INDEX_FLAG )
#define COLOR_CAPTIONTEXT    nOr(  9, SYS_COLOR_INDEX_FLAG )
#define COLOR_HIGHLIGHT      nOr( 13, SYS_COLOR_INDEX_FLAG )
#define COLOR_HIGHLIGHTTEXT  nOr( 14, SYS_COLOR_INDEX_FLAG )
#define COLOR_BTNFACE        nOr( 15, SYS_COLOR_INDEX_FLAG )
#define COLOR_BTNTEXT        nOr( 18, SYS_COLOR_INDEX_FLAG )

#define WM_SETFONT           48  // 0x30

// Lines Styles
#define LINES_NONE            0
#define LINES_BLACK           1
#define LINES_GRAY            2
#define LINES_3D              3
#define LINES_DOTED           4
#define LINES_V_BLACK         5
#define LINES_V_GRAY          6
#define LINES_H_BLACK         7
#define LINES_H_GRAY          8

#define DT_LEFT               0
#define DT_RIGHT              2

#define ETO_OPAQUE            2
#define ETO_CLIPPED           4

#define SM_CYHSCROLL          3

#define MK_MBUTTON           16

#xtranslate   _DbSkipper => DbSkipper

#define VSCROLL_MAXVALUE      10000  // never set values above 32767

extern DBSKIP

//----------------------------------------------------------------------------//

CLASS TWBrowse FROM TControl

   DATA   cAlias, cField, uValue1, uValue2
   DATA   bLine, bSkip, bGoTop, bGoBottom, bLogicLen, bChange, bAdd
   DATA   nRowPos, nColPos, nLen, nAt, nColAct
   DATA   nMaxFilter      // Maximum number of records to count
                          // on indexed filters
   DATA   lHitTop, lHitBottom, lCaptured, lMChange
   DATA   lAutoEdit, lAutoSkip
   DATA   lCellStyle AS LOGICAL INIT .f.
   DATA   aHeaders, aColSizes
   DATA   nClrBackHead, nClrForeHead
   DATA   nClrBackFocus, nClrForeFocus
   DATA   aJustify, aActions
   DATA   oGet
   DATA   nLineStyle
   DATA   lIconView, aIcons, bIconDraw, bIconText
   DATA   nIconPos, nVScrollPos

   DATA   lSingleLine

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nRow, nCol, nWidth, nHeight, bLine, aHeaders, ;
               aColSizes, oWnd, cField, uVal1, uVal2, bChange,;
               bLDblClick, bRClick, oFont, oCursor, nClrFore,;
               nForeBack, cMsg, lUpdate, cAlias, lPixel, bWhen,;
               lDesign, bValid, bLClick, aActions ) CONSTRUCTOR

   METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1,;
                    uVal2, bChange, bLDblClick, bRClick, oFont,;
                    oCursor, nClrFore, nClrBack, cMsg, lUpdate,;
                    cAlias, bWhen, bValid, bLClick, aActions ) CONSTRUCTOR

   METHOD nAtCol( nCol )

   // METHOD nAtIcon( nRow, nCol )

   METHOD lCloseArea() INLINE ;
             If( ! Empty( ::cAlias ), ( ::cAlias )->( DbCloseArea() ),),;
             If( ! Empty( ::cAlias ), ::cAlias := "",), .t.

   METHOD LDblClick( nRow, nCol, nKeyFlags )

   METHOD Default()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   // METHOD BugUp() INLINE ::UpStable()

   METHOD Display()

   // METHOD DrawIcons()

   METHOD DrawLine( nRow ) INLINE ;
               wBrwLine( ::hWnd, ::hDC, If( nRow == nil, ::nRowPos, nRow ), ;
               Eval( ::bLine, Self ), ::GetColSizes(), ::nColPos,;
               ::nClrText, ::nClrPane,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),;
               ValType( ::aColSizes ) == "B", ::aJustify, nil, ::nLineStyle,,, ::oVScroll,;
               ::bLogicLen, , , ::lSingleLine  )
   METHOD DrawSelect()

   METHOD lEditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                    aItems, bAction )

   METHOD Edit( nCol, lModal )

   METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                   aItems, bAction )

   METHOD GetColSizes() INLINE ;
          If( ValType( ::aColSizes ) == "A", ::aColSizes, Eval( ::aColSizes, Self ) )

   METHOD GetDlgCode( nLastKey )

   METHOD GoUp()
   METHOD GoDown()
   METHOD GoLeft()
   METHOD GoRight()
   METHOD GoTop()
   METHOD GoBottom()

   METHOD GotFocus() INLINE Super:GotFocus(),;
                  If( ::nLen > 0 .and. ! Empty( ::cAlias ) .and. ;
                      ! ::lIconView, ::DrawSelect(),)

   METHOD HScroll( nWParam, nLParam )

   // MESSAGE DrawIcon METHOD _DrawIcon( nIcon, lFocused )

   METHOD Initiate( hDlg ) INLINE Super:Initiate( hDlg ), ::Default()

   METHOD IsColVisible( nCol )

   METHOD KeyDown( nKey, nFlags )

   /*
   METHOD KeyChar( nKey, nFlags )

   */
   METHOD LButtonDown( nRow, nCol, nKeyFlags )

   METHOD LButtonUp( nRow, nCol, nKeyFlags )

   METHOD LostFocus( hCtlFocus ) INLINE Super:LostFocus( hCtlFocus ),;
                   If( ::nLen > 0 .and. ! Empty( ::cAlias ) .and. ;
                   ! ::lIconView, ::DrawSelect(),)

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   /*
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   */

   METHOD PageUp( nLines )
   METHOD PageDown( nLines )

   METHOD Paint()

   METHOD RecAdd() INLINE If( ::bAdd != nil, Eval( ::bAdd, Self ),)

   MESSAGE RecCount METHOD _RecCount( uSeekValue )

   // METHOD Report( cTitle, lPreview )

   METHOD ReSize( nSizeType, nWidth, nHeight )

   METHOD nRowCount() INLINE ;
          nWRows( ::hWnd, 0, If( ::oFont != nil, ::oFont:hFont, 0 ), ::lSingleLine ) - 1

   METHOD SetArray( aArray )
   METHOD SetCols( aData, aHeaders, aColSizes )

   METHOD SetFilter( cField, uVal1, uVal2 )

   METHOD SetTree( oTree )
   METHOD ShowSizes()

   METHOD Skip( n )

   METHOD UpStable()
   METHOD VertLine( nColPos, nColInit )
   METHOD VScroll( nWParam, nLParam )

   METHOD VSetPos( nPos ) INLINE ::nVScrollPos := nPos,;
                                 ::oVScroll:SetPos( iif( ::nLen <= VSCROLL_MAXVALUE,;
                                                         nPos,;
                                                         Int( nPos * VSCROLL_MAXVALUE / ::nLen ) ) )
   METHOD VThumbPos( nPos ) INLINE ::nVScrollPos := ::VGetThumbPos( nPos ),;
                                   ::oVScroll:SetPos( nPos )

   METHOD VGetPos()       INLINE ::nVScrollPos

   METHOD VSetRange()     INLINE ::nVScrollPos := 1,;
                                 ::oVScroll:SetRange( Min( 1, ::nLen ), Min( VSCROLL_MAXVALUE, ::nLen ) )
   METHOD VGetMax()       INLINE ::oVScroll:nMax * iif( ::nLen <= VSCROLL_MAXVALUE,;
                                                        1,;
                                                        ::nLen / VSCROLL_MAXVALUE )

   METHOD VGoDown()       INLINE If( ::nVScrollPos < ::nLen, ::VSetPos( ::nVScrollPos + 1 ), )
   METHOD VGoUp()         INLINE If( ::nVScrollPos > 1, ::VSetPos( ::nVScrollPos - 1 ), )

   METHOD VGetThumbPos( nPos ) INLINE If( ::nLen <= VSCROLL_MAXVALUE,;
                                          nPos,;
                                          Int( nPos * ::nLen / VSCROLL_MAXVALUE ) )

    METHOD VGoBottom() INLINE ::VSetPos( ::nLen )

    METHOD VGoTop() INLINE ::VSetPos( 1 )

    Method Select( nOption )   INLINE ::Refresh()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, nWidth, nHeight, bLine, aHeaders, aColSizes, oWnd,;
            cField, uVal1, uVal2, bChange, bLDblClick, bRClick,;
            oFont, oCursor, nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
            lPixel, bWhen, lDesign, bValid, bLClick, aActions ) CLASS TWBrowse

   DEFAULT nRow := 0, nCol := 0, nHeight := 100, nWidth := 100,;
           oWnd := GetWndDefault(), oFont := oWnd:oFont, nClrFore := CLR_BLACK,;
           nClrBack := GetSysColor( COLOR_WINDOW ),;
           lUpdate  := .f., cAlias := Alias(), lPixel := .f.,;
           lDesign  := .f.

   ::cCaption   = ""
   ::nTop       = nRow * If( lPixel, 1, BRSE_CHARPIX_H ) // 14
   ::nLeft      = nCol * If( lPixel, 1, BRSE_CHARPIX_W )  //8
   ::nBottom    = ::nTop + nHeight - 1
   ::nRight     = ::nLeft + nWidth - 1
   ::oWnd       = oWnd
   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1
   ::nStyle     = nOr( WS_CHILD, WS_VSCROLL, WS_HSCROLL,;
                       WS_BORDER, WS_VISIBLE, WS_TABSTOP,;
                       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId        = ::GetNewId()
   ::cAlias     = cAlias
   ::bLine      = bLine
   ::lAutoEdit  = .f.
   ::lAutoSkip  = .f.
   ::lIconView  = .f.
   ::lCellStyle = .f.
   ::nIconPos   = 0
   ::nTxtHeight = 0

   ::SetFilter( cField, uVal1, uVal2 )

   ::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nLen       = 0
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::lMChange   = .t.
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor

   ::nLineStyle    := LINES_GRAY
   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := GetSysColor( COLOR_BTNTEXT )
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := GetSysColor( COLOR_HIGHLIGHTTEXT )

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions
   ::nVScrollPos   = 0

   ::lSingleLine   = .f.

   ::SetColor( nClrFore, nClrBack )

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   if ! Empty( oWnd:hWnd )
      ::Create()
      if oFont != nil
         ::SetFont( oFont )
      endif
      ::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
      ::nHeight = nHeight
      ::nWidth = nWidth
   else
      ::oFont := oFont
      oWnd:DefControl( Self )
      ::lVisible = .f.
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bLine, oDlg, aHeaders, aColSizes, cField, uVal1, uVal2,;
                 bChange, bLDblClick, bRClick, oFont, oCursor,;
                 nClrFore, nClrBack, cMsg, lUpdate, cAlias,;
                 bWhen, bValid, bLClick, aActions ) CLASS TWBrowse

   DEFAULT oDlg := GetWndDefault(), nClrFore := CLR_BLACK,;
           nClrBack := GetSysColor( COLOR_WINDOW ), lUpdate := .f., cAlias := Alias()

   ::lHitTop    = .f.
   ::lHitBottom = .f.
   ::lFocused   = .f.
   ::nId        = nId
   ::nRowPos    = 1
   ::nColPos    = 1
   ::nColAct    = 1
   ::cAlias     = cAlias
   ::oWnd       = oDlg
   ::aHeaders   = aHeaders
   ::aColSizes  = aColSizes
   ::nClrPane   = CLR_LIGHTGRAY
   ::nClrText   = CLR_WHITE
   ::nLen       = 0
   ::lDrag      = .f.
   ::lCaptured  = .f.
   ::lVisible   = .f.
   ::lCaptured  = .f.
   ::lMChange   = .t.

   ::bLine      = bLine
   ::bChange    = bChange
   ::bLClicked  = bLClick
   ::bLDblClick = bLDblClick
   ::bRClicked  = bRClick

   ::oCursor    = oCursor
   ::oFont      = oFont

   ::nLineStyle    := LINES_GRAY
   //::nLineStyle    := LINES_3D
   ::nClrBackHead  := GetSysColor( COLOR_BTNFACE )
   ::nClrForeHead  := CLR_BLACK
   ::nClrBackFocus := GetSysColor( COLOR_HIGHLIGHT )
   ::nClrForeFocus := GetSysColor( COLOR_HIGHLIGHTTEXT )

   ::cMsg          = cMsg
   ::lUpdate       = lUpdate
   ::bWhen         = bWhen
   ::bValid        = bValid
   ::aActions      = aActions
   ::lAutoEdit     = .f.
   ::lAutoSkip     = .f.
   ::lIconView     = .f.
   ::lCellStyle    = .f.
   ::nIconPos      = 0
   ::nVScrollPos   = 0
   ::nHeight       = 0
   ::lSingleLine   = .f.

   ::SetColor( nClrFore, nClrBack )

   ::SetFilter( cField, uVal1, uVal2 )
   ::bAdd       = { || ( ::cAlias )->( DbAppend() ), ::UpStable() }

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   oDlg:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD DrawSelect() CLASS TWBrowse

   if ::lCellStyle
      ::DrawLine()
      WBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine, Self ),;
                ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
                If( ::lFocused, ::nClrBackFocus, CLR_GRAY ),;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle,;
                ::nColAct, ::lFocused, ::oVScroll, ::bLogicLen, ::nClrText, ::nClrPane, ::lSingleLine )
   else
      WBrwLine( ::hWnd, ::hDC, ::nRowPos, Eval( ::bLine, Self ),;
                ::GetColSizes(), ::nColPos, ::nClrForeFocus,;
                If( ::lFocused, ::nClrBackFocus, CLR_GRAY ),;
                If( ::oFont != nil, ::oFont:hFont, 0 ),;
                ValType( ::aColSizes ) == "B", ::aJustify,, ::nLineStyle, nil,;
                ::lFocused, ::oVScroll, ::bLogicLen, , , ::lSingleLine )
   endif

return nil

/*

//----------------------------------------------------------------------------//

METHOD DrawIcons() CLASS TWBrowse

   local nWidth := ::nWidth(), nHeight := ::nHeight()
   local nRow := 10, nCol := 10
   local n := 1, nIcons := Int( nWidth / 50 ) * Int( nHeight / 50 )
   local hIcon := ExtractIcon( "user.exe", 0 )
   local oFont, cText

   DEFINE FONT oFont NAME GetSysFont() SIZE 0, -8 UNDERLINE

   SelectObject( ::hDC, oFont:hFont )
   SetBkColor( ::hDC, CLR_BLUE )
   SetTextColor( ::hDC, CLR_WHITE )

   while n <= nIcons .and. ! ( ::cAlias )->( EoF() )
      if ::bIconDraw != nil .and. ::aIcons != nil
         hIcon = ::aIcons[ Eval( ::bIconDraw, Self ) ]
      endif
      DrawIcon( ::hDC, nRow, nCol, hIcon )
      if ::bIconText != nil
         cText = cValToChar( Eval( ::bIconText, Self ) )
      else
         cText = Str( ( ::cAlias )->( RecNo() ) )
      endif
      DrawText( ::hDC, cText, { nRow + 35, nCol - 5, nRow + 48, nCol + 40 },;
                1 )
      nCol += 50
      if nCol >= nWidth - 32
         nRow += 50
         nCol  = 10
      endif
      ( ::cAlias )->( DbSkip() )
      n++
   end
   ( ::cAlias )->( DbSkip( 1 - n ) )

   oFont:End()

return nil

*/

//----------------------------------------------------------------------------//

METHOD Edit( nCol, lModal ) CLASS TWBrowse

   local uTemp, cType, lAutoSave, lContinue

   DEFAULT nCol := 1, lModal := .t.

   DO
      uTemp = Eval( ::bLine, Self )[ nCol ]
      if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY"
         lAutoSave = ( cValToChar( ( ::cAlias )->( FieldGet( nCol ) ) ) == uTemp )
         if ( ::cAlias )->( RLock() )
            if lContinue := ::lEditCol( nCol, @uTemp )
               if lAutoSave
                  cType = ValType( ( ::cAlias )->( FieldGet( nCol ) ) )
                  do case
                     case cType == "D"
                        ( ::cAlias )->( FieldPut( nCol, CToD( uTemp ) ) )

                     case cType == "L"
                        ( ::cAlias )->( FieldPut( nCol, Upper( uTemp ) == ".T." ) )

                     case cType == "N"
                        ( ::cAlias )->( FieldPut( nCol, Val( uTemp ) ) )

                     otherwise
                        ( ::cAlias )->( FieldPut( nCol, uTemp ) )
                  endcase
               endif
               ::DrawSelect()
            endif
            ( ::cAlias )->( DbUnLock() )
         else
            MsgStop( "Record locked!", "Please, try again" )
         endif
      else
         ::lEditCol( nCol, @uTemp )
      endif
      if lContinue .and. ::lAutoSkip
         if nCol < Len( Eval( ::bLine, Self ) )
            ::GoRight()
            nCol++
         else
            ::nColPos = 1
            nCol = 1
            ::GoDown()
         endif
      endif
   UNTIL ! ( ::lAutoSkip .and. lContinue )

return nil

//----------------------------------------------------------------------------//

METHOD EditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack, aItems,;
                bAction ) CLASS TWBrowse

   local oFont
   local uTemp
   local aDim, aPos
   local cType
   local nWidth, nHeight

   DEFAULT nCol := ::nColAct

   uTemp   := uVar
   aDim    := aBrwPosRect( ::hWnd, ::nRowPos, ::aColSizes, ::nColPos, nCol,;
                          If( ::oFont != nil, ::oFont:hFont, 0 ) )
   aPos    := { aDim[ 1 ], aDim[ 2 ] }
   cType   := ValType( uVar )

   nWidth  := aDim[ 4 ] - aDim[ 2 ]
   nWidth  := ::aColSizes[nCol]
   nHeight := aDim[ 3 ] - aDim[ 1 ]

   ScreenToClient( Self:hWnd, aPos )

   IF ::lCellStyle .and. nCol != ::nColAct
        ::nColAct := nCol
         if ::oHScroll != nil
            ::oHScroll:SetPos(nCol)
         endif
        ::Refresh(.F.)
   ENDIF

   DEFAULT nClrFore := ::nClrText ,;
           nClrBack := ::nClrPane ,;
           bValid   := {|| nil }

   if ::oGet != nil .AND. ! Empty( ::oGet:hWnd )
      ::oGet:End()
   endif

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nInpWidth,;
                           ::oFont:nInpHeight, .f., ::oFont:lBold )
   endif

   do case
      case cType == "L"
           DEFAULT aItems := { ".T.", ".F." }
           uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
           @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX ::oGet VAR uVar ITEMS aItems ;
              SIZE  Min(100,Max(nWidth,50)), 100 OF Self ;
              FONT oFont COLOR nClrFore, nClrBack ;
              ON CHANGE ::End() ;
              PIXEL

      case aItems != nil
           @  aPos[ 1 ] + 1, aPos[ 2 ] + 1 COMBOBOX ::oGet VAR uVar ITEMS aItems ;
              SIZE nWidth, Max( 200, Len( aItems ) * 25 ) OF Self ;
              FONT oFont COLOR nClrFore, nClrBack ;
              ON CHANGE ::End() ;
              PIXEL

      otherwise
          @ aPos[ 1 ] + 1, aPos[ 2 ] + 1 GET ::oGet VAR uVar ;
               SIZE nWidth, nHeight ;
               OF Self ;
               FONT oFont COLOR nClrFore, nClrBack ;
               PIXEL

          ::oGet:oGet:Picture = cPicture
   endcase

   ::nLastKey := 0
   #ifndef __XPP__
      ::oGet:Set3dLook()
   #endif
   ::oGet:SetFocus()

   if Upper( ::oGet:ClassName() ) != "TGET"
      ::oGet:Refresh()
   endif

   ::oGet:bLostFocus := {|| If( Upper( ::oGet:ClassName() ) == "TGET",;
      ( ::oGet:Assign(), ::oGet:VarPut( ::oGet:oGet:VarGet())),;
      ::oGet:VarPut( If( cType == "L", ( uVar == aItems[ 1 ] ), ::oGet:VarGet() ) ) ),;
      If( Self:nLastKey != VK_ESCAPE,;
      Eval( bValid, uVar, Self:nLastKey, Self ),;
      Eval( bValid, nil, Self:nLastKey, Self ) ),;
      ::oGet:End() }

   ::oGet:bKeyDown := { | nKey | If( nKey == VK_RETURN .or. ;
                                     nKey == VK_ESCAPE,;
                        ( Self:nLastKey := nKey, ::oGet:End()), ) }
return .f.

//----------------------------------------------------------------------------//

METHOD ReSize( nSizeType, nWidth, nHeight ) CLASS TWBrowse

   ::nRowPos = Min( ::nRowPos, Max( ::nRowCount(), 1 ) )

return Super:ReSize( nSizeType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD SetArray( aArray ) CLASS TWBrowse

   ::nAt       = 1
   ::cAlias    = "ARRAY"
   ::bLogicLen = { || ::nLen := Len( aArray ) }
   ::bGoTop    = { || ::nAt := 1 }
   ::bGoBottom = { || ::nAt := Eval( ::bLogicLen, Self ) }
   ::bSkip     = { | nSkip, nOld | nOld := ::nAt, ::nAt += nSkip,;
                  ::nAt := Min( Max( ::nAt, 1 ), Eval( ::bLogicLen, Self ) ),;
                  ::nAt - nOld }
return nil

//----------------------------------------------------------------------------//

METHOD SetTree( oTree ) CLASS TWBrowse

   local oItem := oTree:oFirst

   ::lMChange   = .f.
   ::bLine      = { || oItem:GetLabel() }
   ::aColSizes  = { || oItem:ColSizes() }
   ::bGoTop     = { || oItem := oTree:oFirst }
   ::bGoBottom  = { || oItem := oTree:GetLast() }
   ::bSkip      = { | n | oItem := oItem:Skip( @n ), ::Cargo := oItem, n }
   ::bLogicLen  = { || ::nLen := oTree:nCount() }
   ::bLDblClick = { || If( oItem:oTree != nil,;
                         ( oItem:Toggle(), ::Refresh() ),) }
   ::Cargo      = oItem
   ::bKeyChar   = { | nKey | If( nKey == 13 .and. oItem:oTree != nil,;
                         ( oItem:Toggle(), ::Refresh() ),) }

   if ::oHScroll != nil
      ::oHScroll:SetRange( 0, 0 )
      ::oHScroll = nil
   endif

   oTree:Draw()

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TWBrowse

   local n := 1, nSkipped := 1, nLines

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   if ::lIconView
      ::DrawIcons()
      return 0
   endif

   if ::nRowPos == 1 .and. ! Empty( ::cAlias ) .and. ;
      Upper( ::cAlias ) != "ARRAY"
      if ! ( ::cAlias )->( EoF() )
         ( ::cAlias )->( DbSkip( -1 ) )
         if ! ( ::cAlias )->( BoF() )
            ( ::cAlias )->( DbSkip() )
         endif
      endif
   endif

   WBrwLine( ::hWnd, ::hDC, 0, ::aHeaders, ::GetColSizes(),;
               ::nColPos, ::nClrForeHead, ::nClrBackHead,;
               If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                  ::aJustify, nil, ::nLineStyle,,, ::oVScroll, ::bLogicLen, , , ::lSingleLine )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) > 0

      ::Skip( 1 - ::nRowPos )

      nLines = ::nRowCount()
      while n <= nLines .and. nSkipped == 1
         ::DrawLine( n )
         nSkipped = ::Skip( 1 )
         if nSkipped == 1
            n++
         endif
      end
      ::Skip( ::nRowPos - n )

      if ::nLen < ::nRowPos
         ::nRowPos = ::nLen
      endif

      ::DrawSelect()
   endif

   if ! Empty( ::cAlias ) .and. Upper( ::cAlias ) != "ARRAY"
      ::lHitTop    = ( ::cAlias )->( BoF() )
      ::lHitBottom = ( ::cAlias )->( EoF() )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD lEditCol( nCol, uVar, cPicture, bValid, nClrFore, nClrBack,;
                 aItems, bAction ) CLASS TWBrowse

   local oDlg, oGet, oFont, oBtn, oBtnAction
   local nWidth := ::aColSizes[ nCol ]
   local uTemp
   local aDim
   local lOk
   local cType

   DEFAULT nClrFore := ::nClrText ,;
           nClrBack := ::nClrPane ,;
           nCol := ::nColAct

   uTemp  := uVar
   aDim   := aBrwPosRect( ::hWnd, ::nRowPos, ::aColSizes, ::nColPos, nCol,;
                          If( ::oFont != nil, ::oFont:hFont, 0 ) )
   aDim[ 1 ] = aDim[ 1 ] + 1
   lOk    := .f.
   cType  := ValType( uVar )

   IF ::lCellStyle .and. nCol != ::nColAct
        ::nColAct := nCol
         if ::oHScroll != nil
            ::oHScroll:SetPos(nCol)
         endif
        ::Refresh(.F.)
   ENDIF

   DEFINE DIALOG oDlg FROM aDim[ 1 ], aDim[ 2 ] TO aDim[ 3 ], aDim[ 4 ] ;
      STYLE nOR( WS_VISIBLE, WS_POPUP ) PIXEL

   if ::oFont != nil
      oFont = TFont():New( ::oFont:cFaceName, ::oFont:nInpWidth,;
                           ::oFont:nInpHeight, .f., ::oFont:lBold )
   endif

   // if we use uTemp instead of uVar, then VALID does not work!
   // because VALID is issued on uVar. !!!

   do case
      case cType == "L"
           DEFAULT aItems := { ".T.", ".F." }
           uVar = If( uTemp, aItems[ 1 ], aItems[ 2 ] )
           @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
              SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
              ON CHANGE ( oDlg:End(), lOk := .t. ) ;
              FONT oFont COLOR nClrFore, nClrBack

      case aItems != nil
           @  0, 0 COMBOBOX oGet VAR uVar ITEMS aItems ;
              SIZE ( aDim[ 4 ] - aDim[ 2 ] ) * 0.50, 50 OF oDlg ;
              ON CHANGE ( oDlg:End(), lOk := .t. ) ;
              FONT oFont COLOR nClrFore, nClrBack

      otherwise
         @  0, 0 GET oGet VAR uVar ; // we have to use here uVar to use VALID !!!
         SIZE aDim[ 4 ] - aDim[ 2 ] - If( bAction != nil, 12, 0 ),;
         aDim[ 3 ] - aDim[ 1 ]  OF oDlg ;
         FONT oFont COLOR nClrFore, nClrBack

         oGet:oGet:Picture = cPicture

         if bAction != nil
            @ 0, 0 BUTTON oBtnAction PROMPT "" OF oDlg SIZE 12, 12
            oBtnAction:bAction = { || oGet:VarPut( Eval( bAction, uVar, Self ) ),;
                                      oDlg:End(), lOk := .t.  }
         endif
   endcase

   if bValid != nil
      oGet:bValid = bValid
   else
      oGet:bValid = { || oDlg:End(), ::Refresh(), lOk := .t. }
   endif

   @ 10, 0 BUTTON oBtn PROMPT "" ACTION ( oDlg:End(), lOk := .t. ) OF oDlg DEFAULT

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgAdjust( oDlg, oGet, oBtnAction, aDim, cType )

   if ! lOk
      uVar = uTemp
   else
      if cType == "L"
         uVar = ( uVar == aItems[ 1 ] )
      endif
   endif

return lOk

//----------------------------------------------------------------------------//

static function DlgAdjust( oDlg, oGet, oBtnAction, aDim, cType )

   oDlg:Move( aDim[ 1 ] + 1, aDim[ 2 ] + 1,;
              aDim[ 4 ] - aDim[ 2 ], aDim[ 3 ] - aDim[ 1 ] )

   do case
      case cType == "L"
           oGet:Move( -3, -1, aDim[ 4 ] - aDim[ 2 ] + 3, 50 )

      case oBtnAction != nil
           oGet:Move( -3, -1, aDim[ 4 ] - aDim[ 2 ] - 14,;
                      aDim[ 3 ] - aDim[ 1 ] + 6 )
           oBtnAction:Move( 0, aDim[ 4 ] - aDim[ 2 ] - 15, 15,;
           aDim[ 3 ] - aDim[ 1 ] )

    otherwise
           oGet:Move( -2, 0 )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TWBrowse

   local nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      ::DrawLine()
      if ::Skip( -1 ) == -1
         ::lHitBottom = .f.
         if ::nRowPos > 1
            ::nRowPos--
         else
            WBrwScroll( ::hWnd, -1, If( ::oFont != nil, ::oFont:hFont, 0 ), ::lSingleLine )
         endif
      else
         ::lHitTop = .t.
      endif
      ::DrawSelect()
      if ::oVScroll != nil
         ::VGoUp()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TWBrowse

   local nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()
      if ::Skip( 1 ) == 1
         ::lHitTop = .f.
         if ::nRowPos < nLines
            ::nRowPos++
         else
            WBrwScroll( ::hWnd, 1, If( ::oFont != nil, ::oFont:hFont, 0 ), ::lSingleLine )
         endif
      else
         ::lHitBottom = .t.
      endif
      ::DrawSelect()
      if ::oVScroll != nil
         ::VGoDown()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoLeft()  CLASS TWBrowse

   if ::nColAct > 1
      if ::lCellStyle .and. ::IsColVisible( ::nColAct-1 )
         ::nColAct--
         ::DrawSelect()
      else
         ::nColPos--
         ::nColAct--
         ::Refresh()
      endif
      if ::oHScroll != nil
         ::oHScroll:SetPos( ::nColAct )
      endif
   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoRight() CLASS TWBrowse

   local lColVisible

   if ::nColAct < Len( ::GetColSizes() )
      lColVisible = ::IsColVisible( ::nColAct + 1 )
      ::nColAct++
      do while ! ::IsColVisible( ::nColAct ) .and. ::nColPos < ::nColAct
         ::nColPos++
      enddo
      if ! ::lCellStyle
         ::nColPos := ::nColAct
         ::Refresh()
      else
         if lColVisible
            ::DrawSelect()
         else
            ::Refresh()
         endif
      endif
      if ::oHScroll != nil
         ::oHScroll:SetPos( ::nColAct )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TWBrowse

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      Eval( ::bGoTop, Self )
      ::lHitTop = .t.
      ::lHitBottom = .f.
      ::nRowPos = 1
      ::Refresh( .f. )
      if ::oVScroll != nil
         ::VGoTop()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom() CLASS TWBrowse

   local nSkipped
   local nLines := ::nRowCount()
   local n
   local nOldLen := ::nLen

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ::nLen > nOldLen
      ::lHitBottom = .f.
   endif

   if ! ::lHitBottom
      ::lHitBottom = .t.
      ::lHitTop    = .f.

      Eval( ::bGoBottom, Self )

      nSkipped = ::Skip( -( nLines - 1 ) )
      ::nRowPos = 1 - nSkipped

      ::GetDC()
      for n = 1 to -nSkipped
          ::DrawLine( n )
          ::Skip( 1 )
      next
      ::DrawSelect()
      ::ReleaseDC()
      if ::oVScroll != nil
         ::nLen = Eval( ::bLogicLen, Self )
         if ::VGetMax() != ::nLen
            ::VSetRange()
         endif
         ::VGoBottom()
      endif
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TWBrowse

   local nClickRow := nWRow( ::hWnd, ::hDC, nRow, If( ::oFont != nil, ::oFont:hFont, 0 ), ::lSingleLine )

   local nBrwCol

   if nClickRow == ::nRowPos .and. ::nLen > 0
      nBrwCol = ::nAtCol( nCol )
      if ::lAutoEdit
         ::Edit( nBrwCol )
      else
         return Super:LDblClick( nRow, nCol, nKeyFlags )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TWBrowse

   local nClickRow, nSkipped
   local nColPos := 0, nColInit := ::nColPos - 1
   local nAtCol

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nKeyFlags )
   endif

   nClickRow = nWRow( ::hWnd, ::hDC, nRow, If( ::oFont != nil, ::oFont:hFont, 0 ), ::lSingleLine )

   if ::nLen < 1 .and. nClickRow != 0
      return nil
   endif

   if ::lMChange .and. AScan( ::GetColSizes(),;
             { | nColumn | nColPos += nColumn,;
                           nColInit++,;
                           nCol >= nColPos - 1 .and. ;
                           nCol <= nColPos + 1 }, ::nColPos ) != 0
      if ! ::lCaptured
         ::lCaptured = .t.
         ::Capture()
         ::VertLine( nColPos, nColInit )
      endif
      return nil
   endif

   ::SetFocus()

   if nClickRow == 0 .and. Valtype(nKeyFlags) == "N"
      if ::aActions != nil .and. ;
         ( nAtCol := ::nAtCol( nCol ) ) <= Len( ::aActions )
            if ::aActions[ nAtCol ] != nil
               wBrwLine( ::hWnd, ::GetDC(), 0, ::aHeaders, ::GetColSizes(),;
                         ::nColPos, ::nClrForeHead, ::nClrBackHead,;
                         If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                         ::aJustify, nAtCol, ::nLineStyle,,, ::oVScroll, ::bLogicLen, , , ::lSingleLine )
               ::ReleaseDC()
               Eval( ::aActions[ nAtCol ], Self, nRow, nCol )
               wBrwLine( ::hWnd, ::GetDC(), 0, ::aHeaders, ::GetColSizes(),;
                         ::nColPos, ::nClrForeHead, ::nClrBackHead,;
                         If( ::oFont != nil, ::oFont:hFont, 0 ),.f.,;
                         ::aJustify,, ::nLineStyle,,, ::oVScroll, ::bLogicLen, , , ::lSingleLine )
               ::ReleaseDC()
            else
               MsgBeep()
            endif
      else
         MsgBeep()
      endif
   endif

   if nClickRow > ::nLen
      return 0
   endif

   if nClickRow > 0 .and. nClickRow != ::nRowPos .and. ;
      nClickRow < ::nRowCount() + 1
      ::DrawLine()
      nSkipped  = ::Skip( nClickRow - ::nRowPos )
      ::nRowPos += nSkipped
      if ::oVScroll != nil
         ::VSetPos( ::VGetPos() + nSkipped )
      endif
      if ::lCellStyle
           ::nColAct := ::nAtCol( nCol )
           if ::oHScroll != nil
              ::oHScroll:SetPos(::nColAct)
           endif
      endif
      ::DrawSelect()
      ::lHitTop = .f.
      ::lHitBottom = .f.
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif
   else
      if ::lCellStyle
           ::nColAct := ::nAtCol( nCol )
           if ::oHScroll != nil
              ::oHScroll:SetPos(::nColAct)
           endif
           ::Refresh(.f.)
      endif
   endif

   Super:LButtonDown( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TWBrowse

   if ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lCaptured
      ::lCaptured = .f.
      ReleaseCapture()
      ::VertLine()
   endif

   Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TWBrowse

   local n, aFields
   local cAlias := Alias()
   local nElements, nTotal := 0

   DEFAULT ::aHeaders := {}, ::aColSizes := {}

   if ::bLine == nil
      if Empty( ::cAlias )
         ::cAlias = cAlias
      else
         cAlias = ::cAlias
      endif
      ::bLine  = { || _aFields( Self ) }
      if ::aJustify == nil
         ::aJustify = Array( nElements := Len( Eval( ::bLine, Self ) ) )
         for n = 1 to nElements
             ::aJustify[ n ] = ( ValType( ( cAlias )->( FieldGet( n ) ) ) == "N" )
         next
      endif
   endif

   DEFAULT nElements := Len( Eval( ::bLine, Self ) )

   if Len( ::aHeaders ) < nElements
      if ::Cargo == nil
         ::aHeaders = Array( nElements )
         for n = 1 to nElements
             ::aHeaders[ n ] = ( cAlias )->( FieldName( n ) )
         next
      else
         ::aHeaders = { "" }
      endif
   endif

   if Len( ::GetColSizes() ) < nElements
      ::aColSizes = Afill(Array( nElements ), 0 )
      aFields = Eval( ::bLine, Self )
      for n = 1 to nElements
          ::aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
                                   15,; // Bitmap handle
                                   GetTextWidth( 0, Replicate( "B", ;
                                   Max( Len( ::aHeaders[ n ] ), ;
                                        Len( aFields[ n ] ) ) + 1 ),;
                                   If( ! Empty( ::oFont ), ::oFont:hFont,) ) )
      next
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_VSCROLL ) .or. ;
      GetClassName( ::hWnd ) == "ListBox"
      DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self
      ::nLen := Eval( ::bLogicLen, Self )
      ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ) )
      ::VSetRange()
   endif

   if lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_HSCROLL )
      if ::Cargo == nil // it is not a tree
         DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self ;
            RANGE 1, Len( ::GetColSizes() )
         AEval( ::GetColSizes(), { | nSize | nTotal += nSize } )
         ::oHScroll:SetPage( nTotal / ::nWidth() )
      endif
   endif

   if ::uValue1 != nil
      Eval( ::bGoTop, Self )
   endif
   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil

//---------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TWBrowse

   do case
      case nKey == VK_UP
           ::GoUp()

      case nKey == VK_DOWN
           ::GoDown()

      case nKey == VK_LEFT
           ::GoLeft()

      case nKey == VK_RIGHT
           ::GoRight()

      case nKey == VK_HOME
           ::GoTop()

      case nKey == VK_END
           ::GoBottom()

      case nKey == VK_PRIOR
           if GetKeyState( VK_CONTROL )
              ::GoTop()
           else
              ::PageUp()
           endif

      case nKey == VK_NEXT
           if GetKeyState( VK_CONTROL )
              ::GoBottom()
           else
              ::PageDown()
           endif

      otherwise
           return Super:KeyDown( nKey, nFlags )
   endcase

return 0

/*

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TWBrowse

   do case
      case nKey == K_PGUP
           ::oVScroll:PageUp()

      case nKey == K_PGDN
           ::oVScroll:PageDown()

      otherwise
           return Super:KeyChar( nKey, nFlags )
   endcase

return 0

//----------------------------------------------------------------------------//

*/

METHOD PageUp( nLines ) CLASS TWBrowse

   local nSkipped

   DEFAULT nLines := ::nRowCount()

   nSkipped = ::Skip( -nLines )

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitTop
      if nSkipped == 0
         ::lHitTop = .t.
      else
         ::lHitBottom = .f.
         if -nSkipped < nLines
            ::nRowPos = 1
            if ::oVScroll != nil
               ::VSetPos( 1 )
            endif
         else

            nSkipped = ::Skip( -nLines )
            ::Skip( -nSkipped )

            if ::oVScroll != nil
               ::VSetPos( ::VGetPos() + nSkipped )
            endif

         endif
         ::Refresh( .f. )
         if ::bChange != nil
            Eval( ::bChange, Self )
         endif

      endif

   else
      if ::oVScroll != nil
         ::VGoTop()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageDown( nLines ) CLASS TWBrowse

   local nSkipped, n

   DEFAULT nLines := ::nRowCount()

   if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
      return nil
   endif

   if ! ::lHitBottom
      ::DrawLine()

      if ::lSingleLine
         nSkipped = ::Skip( nLines - ::nRowPos )
      else
         nSkipped = ::Skip( ( nLines * 2 ) - ::nRowPos )
      end if

      if nSkipped != 0
         ::lHitTop = .f.
      endif

      do case
         case nSkipped == 0 .or. nSkipped < nLines
              if nLines - ::nRowPos < nSkipped
                 ::GetDC()
                 ::Skip( -( nLines ) )
                 for n = 1 to ( nLines - 1 )
                     ::Skip( 1 )
                     ::DrawLine( n )
                 next
                 ::ReleaseDC()
                 ::Skip( 1 )
              endif
              ::nRowPos = Min( ::nRowPos + nSkipped, nLines )
              ::lHitBottom = .t.
              if ::oVScroll != nil
                 ::VGoBottom()
              endif

         otherwise
              ::GetDC()
              for n = nLines to 1 step -1
                  ::DrawLine( n )
                  ::Skip( -1 )
              next
              ::ReleaseDC()
              ::Skip( ::nRowPos )
      endcase
      ::DrawSelect()
      if ::bChange != nil
         Eval( ::bChange, Self )
      endif

      if ::oVScroll != nil
         if ! ::lHitBottom
            ::VSetPos( ::VGetPos() + nSkipped - ( nLines - ::nRowPos ) )
         else
            ::VGoBottom()
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nWParam, nLParam ) CLASS TWBrowse

   local nLines := ::nRowCount()
   local nLen
   local nScrHandle  := nLParam
   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   if ::oVScroll != nil
   		do case
      		case nScrollCode == SB_LINEUP
           		 ::GoUp()

      		case nScrollCode == SB_LINEDOWN
           		 ::GoDown()

      		case nScrollCode == SB_PAGEUP
               ::PageUp()

      		case nScrollCode == SB_PAGEDOWN
           		 ::PageDown()

      		case nScrollCode == SB_TOP
           		 ::GoTop()

      		case nScrollCode == SB_BOTTOM
           		 ::GoBottom()

      		case nScrollCode == SB_THUMBPOSITION
               if ( ::nLen := Eval( ::bLogicLen, Self ) ) < 1
              		return 0
           		 endif

               if nPos <= 1
              		::GoTop()
           		elseif nPos == ::oVScroll:GetRange()[ 2 ]
              		::GoBottom()
           		else
              		CursorWait()
                  ::Skip( ::VGetThumbPos( nPos ) - ::VGetPos() )
              		::lHitTop = .f.
              		::lHitBottom = .f.
              		CursorArrow()
           		endif
               ::VThumbPos( nPos )

               nLen = Eval( ::bLogicLen, Self )
           		if nPos - ::oVScroll:nMin < nLines
              		::nRowPos = 1
           		endif
           		if ::oVScroll:nMax - nPos < Min( nLines, nLen )
              		::nRowPos = Min( nLines, nLen ) - ( ::oVScroll:nMax - nPos )
           		endif
           		::Refresh( .f. )
           		if ::bChange != nil
              		Eval( ::bChange, Self )
           		endif

      		otherwise
           		return nil
   		endcase
		endif

return 0

//----------------------------------------------------------------------------//

METHOD HScroll( nWParam, nLParam ) CLASS TWBrowse

   local nCol := ::nColPos

   #ifdef __CLIPPER__
      local nScrHandle  := nHiWord( nLParam )
      local nScrollCode := nWParam
      local nPos        := nLoWord( nLParam )
   #else
      local nScrHandle  := nLParam
      local nScrollCode := nLoWord( nWParam )
      local nPos        := nHiWord( nWParam )
   #endif

   if ::oGet != nil .and. ! Empty( ::oGet:hWnd )
      ::oGet:End()
   endif

   do case
      case nScrollCode == SB_LINEUP
           ::GoLeft()

      case nScrollCode == SB_LINEDOWN
           ::GoRight()

      case nScrollCode == SB_PAGEUP
           while ::nColPos > 1 .and. ;
                (::IsColVisible( nCol ) .or. ::nColPos == nCol)
              ::nColPos--
           end
           ::nColAct := ::nColPos
           ::oHScroll:SetPos( ::nColAct )
           ::Refresh( .f. )

      case nScrollCode == SB_PAGEDOWN
           while nCol < Len( ::GetColSizes() ) .and. ;
                (::IsColVisible( nCol ) .or. ::nColPos == nCol)
              nCol++
           end
           ::nColPos := nCol
           ::nColAct := nCol
           ::oHScroll:SetPos( nCol )
           ::Refresh( .f. )

      case nScrollCode == SB_TOP
           ::nColPos = 1
           ::nColAct = 1
           ::oHScroll:SetPos( 1 )
           ::Refresh( .f. )

      case nScrollCode == SB_BOTTOM
           ::nColPos = Len( ::GetColSizes() )
           ::nColAct = ::nColPos
           ::oHScroll:SetPos( ::nColPos )
           ::Refresh( .f. )

      case nScrollCode == SB_THUMBPOSITION
           ::nColPos = Max( nPos, 1 )
           ::nColAct = ::nColPos
           ::oHScroll:SetPos( nPos )
           ::Refresh( .f. )

      otherwise
           return nil
   endcase

return 0

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TWBrowse

   if ::bSkip != nil
      return Eval( ::bSkip, n, Self )
   endif

return ( ::cAlias )->( _DBSkipper( n ) )

//----------------------------------------------------------------------------//

static function BrwGoBottom( uExpr )

   local lSoftSeek := Set( _SET_SOFTSEEK, .t. )

   if ValType( uExpr ) == "C"
      DbSeek( SubStr( uExpr, 1, Len( uExpr ) - 1 ) + ;
              Chr( Asc( SubStr( uExpr, Len( uExpr ) ) ) + 1 ) )
   else
      DbSeek( uExpr + 1 )
   endif
   DbSkip( -1 )

   Set( _SET_SOFTSEEK, lSoftSeek )

return nil

//----------------------------------------------------------------------------//

// To simulate Filters using INDEXES         -they go extremely fast!-

static function BuildSkip( cAlias, cField, uValue1, uValue2 )

   local bSkipBlock
   local cType := ValType( uValue1 )

   do case
      case cType == "C"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= '" + uValue1 + "' .and." + ;
           cField + "<= '" + uValue2 + "' }" ) ) ) }

      case cType == "D"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= CToD( '" + DToC( uValue1 ) + "') .and." + ;
            cField + "<= CToD( '" + DToC( uValue2 ) + "') }" ) ) ) }

      case cType == "N"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }

      case cType == "L"
           bSkipBlock = { | n | ( cAlias )->( BrwGoTo( n, ;
           &( "{||" + cField + ">= " + cValToChar( uValue1 ) + " .and." + ;
           cField + "<= " + cValToChar( uValue2 ) + " }" ) ) ) }
   endcase

return bSkipBlock

//----------------------------------------------------------------------------//

static function BrwGoTo( n, bWhile )

   local nSkipped := 0, nDirection := If( n > 0, 1, -1 )

   while nSkipped != n .and. Eval( bWhile ) .and. ! EoF() .and. ! BoF()
      DbSkip( nDirection )
      nSkipped += nDirection
   enddo

   do case
      case EoF()
         DbSkip( -1 )
         nSkipped += -nDirection

      case BoF()
         DbGoTo( RecNo() )
         nSkipped++

      case ! Eval( bWhile )
         DbSkip( -nDirection )
         nSkipped += -nDirection
   endcase

return nSkipped

//----------------------------------------------------------------------------//

METHOD _RecCount( uSeekValue ) CLASS TWBrowse

   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRecs  := 1
   local bField := &( "{ || " + ::cField + "}" )

   if .not. ( ::cAlias )->( DbSeek( uSeekValue, .t. ) )
      if ( ::cAlias )->( Eval( bField, Self ) ) > ::uValue2 ;
         .or. ( ::cAlias )->( EoF() )
         nRecs := 0
      endif
   endif

   // When Filters show a lot of records, the application
   // may loose a lot of time counting. nMaxFilter controls this
   if ::nMaxFilter == nil
      while ::Skip( 1 ) == 1
         nRecs++
      end
   else
      while ::Skip( 1 ) == 1 .and. nRecs < ::nMaxFilter
         nRecs++
      end
   endif

   ( ::cAlias )->( DbGoTo( nRecNo ) )

return nRecs

//----------------------------------------------------------------------------//

static function GenLocal( aArray, nPos )

return { || If( nPos <= Len( aArray ), aArray[ nPos ], "  " ) }

static function GenBlock( bLine, nPos ) ;  return { || Eval( bLine )[ nPos ] }

//----------------------------------------------------------------------------//

/*

METHOD Report( cTitle, lPreview ) CLASS TWBrowse

   local oRpt
   local nRecNo := If( Upper( ::cAlias ) != "ARRAY", ( ::cAlias )->( RecNo() ), 0 )
   local aData  := Eval( ::bLine, Self )
   local n
   local nCharWidth

   nCharWidth := GetTextWidth( 0, "B", If( ::oFont != nil, ::oFont:hFont, 0 ))

   DEFAULT cTitle := ::oWnd:cTitle, lPreview := .t.

   if lPreview
      REPORT oRpt TITLE cTitle PREVIEW ;
         HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
         FOOTER "Page: " + Str( oRpt:nPage, 3 )
   else
      REPORT oRpt TITLE cTitle ;
         HEADER "Date: " + DToC( Date() ) + ", Time: " + Time() ;
         FOOTER "Page: " + Str( oRpt:nPage, 3 )
   endif

   if Empty( oRpt ) .or. oRpt:oDevice:hDC == 0
      return nil
   else
      Eval( ::bGoTop, Self )
   endif

   if ::aColSizes == nil
      ::aColSizes = Array( Len( aData ) )
      for n = 1 to Len( aData )
         ::aColSizes[ n ] = 80
      next
   else
      if Len( ::aColSizes ) < Len( aData )
         n = Len( ::aColSizes )
         while n++ < Len( aData )
            AAdd( ::aColSizes, 80 )
         end
      endif
   endif

   for n = 1 to Len( aData )
      if ValType( aData[ n ] ) != "N"
         oRpt:AddColumn( TrColumn():New( { GenLocal( ::aHeaders, n ) },,;
                         { GenBlock( ::bLine, n ) },;
                         Int( ::aColSizes[ n ]/ nCharWidth ),,,,,,,,, oRpt ) )
      else
         oRpt:AddColumn( TrColumn():New( { GenLocal( ::aHeaders, n ) },,;
                         { { || "   " } },;
                         Int( ::aColSizes[ n ] / nCharWidth ),,,,,,,,, oRpt ) )
      endif
   next
   ENDREPORT

   oRpt:bSkip = { || oRpt:Cargo := ::Skip( 1 ) }
   oRpt:Cargo = 1

   ACTIVATE REPORT oRpt ;
      WHILE If( Upper( ::cAlias ) == "ARRAY",;
                oRpt:nCounter < Eval( ::bLogicLen, Self ),;
                oRpt:Cargo == 1 )

   if Upper( ::cAlias ) != "ARRAY"
      ( ::cAlias )->( DbGoTo( nRecNo ) )
   endif
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

*/

METHOD UpStable() CLASS TWBrowse

   local nRow   := ::nRowPos
   local nRecNo := ( ::cAlias )->( RecNo() )
   local nRows  := ::nRowCount()
   local n      := 1
   local lSkip  := .t.

   ::nRowPos    = 1
   ::GoTop()
   ::lHitTop    = .f.
   ::lHitBottom = .f.

   while ! ( ::cAlias )->( EoF() )
      if n > nRows
         ( ::cAlias )->( DbGoTo( nRecNo ) )
         ::nRowPos = nRow
         lSkip     = .f.
         exit
      endif
      if nRecNo == ( ::cAlias )->( RecNo() )
         ::nRowPos = n
         exit
      else
         ( ::cAlias )->( DbSkip() )
      endif
      n++
   end

   if lSkip
      ( ::cAlias )->( DbSkip( -::nRowPos ) )
   endif

   if ::bChange != nil
      Eval( ::bChange, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFilter( cField, uVal1, uVal2 ) CLASS TWBrowse

   local cIndexType

   DEFAULT uVal2 := uVal1

   ::cField     = cField
   ::uValue1    = uVal1
   ::uValue2    = uVal2

   if uVal1 != nil
      cIndexType := ( ::cAlias )->( ValType( &( IndexKey() ) ) )
      if ( ::cAlias )->( ValType( &cField ) ) != cIndexType .or. ;
         ValType( uVal1 ) != cIndexType .or. ;
         ValType( uVal2 ) != cIndexType
         msgStop( "TWBrowse SetFilter() types don't match with current Index Key type!" )
      endif
   endif

   // Posibility of using FILTERs based on INDEXES!!!

   if ! Empty( ::cAlias )

      ::bGoTop     = If( uVal1 != nil, { || ( ::cAlias )->( DbSeek( uVal1, .t. ) ) },;
                                    { || ( ::cAlias )->( DbGoTop() ) } )

      ::bGoBottom  = If( uVal2 != nil, { || ( ::cAlias )->( BrwGoBottom( uVal2 ) ) },;
                                    { || ( ::cAlias )->( DbGoBottom() ) } )

      ::bSkip      = If( uVal1 != nil, BuildSkip( ::cAlias, cField, uVal1, uVal2 ),;
                      { | n | ( ::cAlias )->( _DbSkipper( n ) ) } )

      ::bLogicLen  = If( uVal1 != nil,;
                      { || ( ::cAlias )->( Self:RecCount( uVal1 ) ) },;
                      { || ( ::cAlias )->( RecCount() ) } )

      ::nLen       = Eval( ::bLogicLen, Self )

      ::lHitTop    = .f.
      ::lHitBottom = .f.

      if uVal1 != nil
         Eval( ::bGoTop, Self )
      endif
   else
      ::bLogiclen = { || 0 }
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TWBrowse

   local nColPos := 0

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if ::lCaptured
      CursorWE()
      ::VertLine( nCol )
      return 0
   endif

   if ::lMChange .and. AScan( ::GetColSizes(),;
              { | nColumn | nColPos += nColumn,;
                            nCol >= nColPos - 1 .and. ;
                            nCol <= nColPos + 1 }, ::nColPos ) != 0
      CursorWE()
   else
      Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

return 0

//----------------------------------------------------------------------------//

/*

METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TWBrowse

   local aPos := { nYPos, nXPos }

   aPos = ScreenToClient( ::hWnd, aPos )

   if aPos[ 1 ] > ::nHeight * 0.80
      if nDelta > 0
         ::GoLeft()
      else
         ::GoRight()
      endif
   else
      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            ::PageUp()
         else
            ::PageDown()
         endif
      else
         if nDelta > 0
            ::GoUp()
         else
            ::GoDown()
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

#ifndef __HARBOUR__
Dll32 Static Function GetMsgInfo() AS LONG PASCAL ;
      FROM "GetMessageExtraInfo" LIB "User32.dll"
#endif

//----------------------------------------------------------------------------//

*/

METHOD VertLine( nColPos, nColInit ) CLASS TWBrowse

   local oRect, aSizes, nFor

   static nCol, nWidth, nMin, nOldPos := 0

   if nColInit != nil
      nCol    = nColInit
      nWidth  = nColPos
      nOldPos = 0
      nMin := 0
      aSizes := ::GetColSizes()

      FOR nFor := ::nColPos TO nColInit - 1
          nMin += aSizes[nFor]
      NEXT

      nMin += 5
   endif

   if nColPos == nil .and. nColInit == nil   // We have finish draging
      ::aColSizes[ nCol ] -= ( nWidth - nOldPos )
      ::Refresh()
   endif

   if nColPos != nil
     nColPos := Max(nColPos, nMin)
   endif

   oRect = ::GetRect()
   ::GetDC()

   if nOldPos != 0
      InvertRect( ::hDC, { 0, nOldPos - 2, oRect:nBottom, nOldPos + 2 } )
      nOldPos = 0
   endif
   if nColPos != nil .and. ( nColPos - 2 ) > 0
      InvertRect( ::hDC, { 0, nColPos - 2, oRect:nBottom, nColPos + 2 } )
      nOldPos = nColPos
   endif

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD nAtCol( nColPixel ) CLASS TWBrowse

   local nColumn := ::nColPos - 1
   local aSizes  := ::GetColSizes()
   local nPos    := 0

   DEFAULT nColPixel := 0

   while nPos < nColPixel .and. nColumn < Len( aSizes )
      nPos += aSizes[ nColumn + 1 ]
      nColumn++
   end

return nColumn

//----------------------------------------------------------------------------//

/*
METHOD nAtIcon( nRow, nCol ) CLASS TWBrowse

   local nIconsByRow := Int( ::nWidth() / 50 )

   nRow -= 9
   nCol -= 1

   if ( nCol % 50 ) >= 9 .and. ( nCol % 50 ) <= 41
      return Int( ( nIconsByRow * Int( nRow / 50 ) ) + Int( nCol / 50 ) ) + 1
   else
      return 0
   endif

return nil

*/

//----------------------------------------------------------------------------//

METHOD Display() CLASS TWBrowse

   local nRecs

   ::BeginPaint()
   if ::oVScroll != nil   // They generate WM_PAINT msgs when range 0
      nRecs := Eval( ::bLogicLen, Self )
      if ::VGetMax() != nRecs .or. nRecs != ::nLen
         ::nLen := nRecs
         ::VSetRange()
         ::oVScroll:SetPage( Min( ::nRowCount(), ::nLen - 1 ), .t. )
      endif
   endif                  // so here we avoid 'flicking'
   if ::oHScroll != nil
      ::oHScroll:SetRange( 1, Len( ::GetColSizes() ) )
   endif
   ::Paint()
   ::EndPaint()

return 0

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TWBrowse

   // This method is very similar to TControl:GetDlgCode() but it is
   // necessary to have WHEN working

   if .not. ::oWnd:lValidating
      if nLastKey == VK_UP .or. nLastKey == VK_DOWN ;
         .or. nLastKey == VK_RETURN .or. nLastKey == VK_TAB
         ::oWnd:nLastKey = nLastKey
      else
         ::oWnd:nLastKey = 0
      endif
   endif

return If( IsWindowEnabled( ::hWnd ), DLGC_WANTALLKEYS, 0 )

//----------------------------------------------------------------------------//

function _aFields( Self )

   local aFld, aSizes, cAlias := ::cAlias
   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth

   if Empty( cAlias )
      return {}
   endif

   if Len( ::aColSizes ) == 0
      return Array( ( cAlias )->( Fcount() ) )
   endif

  aSizes    = ::aColSizes
  nCols     = Len( aSizes )
  nFirstCol = ::nColPos
  nLastCol  = nFirstCol
  nWidth    = 0
  nBrwWidth = ::nWidth()
  aFld      = Array( nCols )

  AFill( aFld, "" ) // , 1, nFirstCol - 1 )

  while nWidth < nBrwWidth .and. nLastCol <= nCols
     nWidth += aSizes[ nLastCol ]
     if ValType( ( cAlias )->( FieldGet( nLastCol ) ) ) == "M"
        aFld[ nLastCol ] = If( ! Empty( ( cAlias )->( ;
              FieldGet( nLastCol ) ) ), "<Memo>", "<memo>" )
        nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     else
        aFld[ nLastCol ] = cValToChar( ( cAlias )->( FieldGet( nLastCol ) ) )
        nLastCol++   // Keep this here! XBase+ and Clipper difference!!!
     endif
  end

return aFld

//----------------------------------------------------------------------------//

METHOD SetCols( aData, aHeaders, aColSizes ) CLASS TWBrowse

   local aFields
   local nElements, n

   nElements   := Len( aData )

   ::aHeaders  := If( aHeaders  != nil, aHeaders, ::aHeaders )
   ::aColSizes := If( aColSizes != nil, aColSizes, {} )
   ::bLine     := {|| _aData( aData ) }
   ::aJustify  := AFill( Array( nElements ), .F. )

   if Len( ::GetColSizes() ) < nElements
      ::aColSizes = AFill( Array( nElements ), 0 )
      aFields = Eval( ::bLine, Self )
      for n = 1 to nElements
          ::aColSizes[ n ] := If( ValType( aFields[ n ] ) != "C",;
                                   15,; // Bitmap handle
                                   GetTextWidth( 0, Replicate( "B", ;
                                   Max( Len( ::aHeaders[ n ] ), ;
                                        Len( aFields[ n ] ) ) + 1 ),;
                                   If( ! Empty( ::oFont ), ::oFont:hFont,) ) )
      next
   endif

   if ::oHScroll != nil
      ::oHScroll:nMax := ::GetColSizes()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowSizes() CLASS TWBrowse

   local cText := ""

   AEval( ::aColSizes,;
          { | v,e | cText += ::aHeaders[ e ] + ": " + Str( v, 3 ) + CRLF } )

   MsgInfo( cText )

return nil

//----------------------------------------------------------------------------//

/*

METHOD _DrawIcon( nIcon, lFocused ) CLASS TWBrowse

   local nIconsByRow := Int( ::nWidth() / 50 )
   local nRow := Int( --nIcon / nIconsByRow )
   local nCol := If( nRow > 0, nIcon % ( nRow * nIconsByRow ), nIcon )

   DEFAULT lFocused := .f.

   if lFocused
      DrawIconFocus( ::GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
                     ExtractIcon( "user.exe" ) )
   else
      DrawIcon( ::GetDC(), ( nRow * 50 ) + 10, ( nCol * 50 ) + 10,;
                ExtractIcon( "user.exe" ) )
   endif

return nil

//----------------------------------------------------------------------------//

*/

METHOD IsColVisible( nCol ) CLASS TWBrowse

   local nCols, nFirstCol, nLastCol, nWidth, nBrwWidth

   nCols     := Len( ::GetColSizes() )
   nFirstCol := ::nColPos
   nLastCol  := nFirstCol
   nWidth    := 0
   nBrwWidth := ::nWidth - If( ::oVScroll != nil, 16, 0 )

   if nCol < nFirstCol
      return .f.
   endif

   while nWidth < nBrwWidth .and. nLastCol <= nCol
      nWidth += ::GetColSizes()[ nLastCol ]
      nLastCol++
   end

   if nCol <= --nLastCol

      // La columna es solo visible en parte por ser muy larga
      if nWidth > nBrwWidth
          return .f.
      endif

      return .t.

   endif

return .F.

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWBrowse

   do case
      case nMsg == WM_PAINT
           return ::Display()
           // ::BeginPaint()
           // ::Paint()
           // ::EndPaint()

      case nMsg == WM_KEYDOWN
           return ::KeyDown( nWParam, nLParam )

      case nMsg == WM_GETDLGCODE
           return ::GetDlgCode()

   endcase

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

static function _aData( aFields )

  local aFld
  local nFor, nLen

  nLen = Len( aFields )
  aFld = Array( nLen )

  for nFor = 1 to nLen
     aFld[ nFor ] = Eval( aFields[ nFor ] )
  next

return aFld

//----------------------------------------------------------------------------//

static function wBrwLine( hWnd, hDC, nRowPos, aValues, aColSizes,;
                          nColPos, nClrText, nClrPane,;
                          hFont, lTree, aJustify, nPressed, nLineStyle,;
                          nColAct, lFocused, oVScroll, bLogicLen, nClrTxt, nClrBack, lSingleLine )
   local nTxtHeight, hOldFont
   local nColStart  := -1
   local nWidth     := WndWidth( hWnd ) - If( oVScroll != nil .and. ;
                       Eval( bLogicLen ) > 1,;
                       GetSysMetrics( SM_CYHSCROLL ) + 3, 0 )
   local nRow := nRowPos, nTop, nBottom, nLeft, nRight, n
   local lReleaseDC := .f.
   local  hPen, hOld, hBrush

   DEFAULT lTree := .f.
   DEFAULT lSingleLine := .f.

   if Empty( hDC )
      hDC = GetDC( hWnd )
      lReleaseDC = .t.
   endif

   hOldFont   = SelectObject( hDC, hFont )

   //if ( ::nTxtHeight != 0 )
   //   nTxtHeight := ::nTxtHeight
   //else
   if lSingleLine
      nTxtHeight := GetTextHeight( hWnd, hDC ) + 1
   else
      nTxtHeight := ( GetTextHeight( hWnd, hDC ) * 2 ) + 1
   end if

   //msginfo( ::nTxtHeight, "Data" )

   nTop    = nTxtHeight * nRow
   nBottom = nTop + nTxtHeight - 1

   SetTextColor( hDC, If( ValType( nClrText ) == "B",;
                 nClrText := Eval( nClrText ), nClrText ) )
   SetBkColor( hDC, If( ValType( nClrPane ) == "B",;
               nClrPane := Eval( nClrPane ), nClrPane ) )

   for n := nColPos to Len( aValues )
      nLeft   = nColStart + 1
      nRight  = Min( nColStart := ( nLeft + aColSizes[ n ] - 1 ), nWidth )
      if nLeft > nWidth
         exit
      endif
      if n == Len( aValues )
         nRight = nWidth
      endif

      if ValType( aValues[ n ] ) == "N"
         hBrush = CreateSolidBrush( If( nColAct != nil, nClrBack, GetBkColor( hDC ) ) )
         hOld   = SelectObject( hDC, hBrush )
         FillRect( hDC, { nTop, nLeft, nBottom, nRight + If( ( nLineStyle == ;
                   LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. nLineStyle == ;
                   LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) }, hBrush )
         DrawMasked( hDC, aValues[ n ], nTop, nLeft + 0 )
         SelectObject( hDC, hOld )
         DeleteObject( hBrush )
      else
         if nColAct != nil .and. n == nColAct
            SetTextColor( hDC, nClrText )
            SetBkColor( hDC, nClrPane )
         else
            if nRowPos != 0
               SetTextColor( hDC, If( nColAct != nil, nClrTxt,;
                                      nClrText ) )
               SetBkColor( hDC, If( nRowPos == 0, GetSysColor( COLOR_BTNFACE ),;
                           If( nColAct == nil, nClrPane, nClrBack ) ) )
            endif
         endif
         if ! lTree
            if nRowPos == 0 .and. IsAppThemed()
               // DrawHeader( hWnd, hDC, nTop - 1, nLeft, nBottom, nRight, AnsiToOem( aValues[ n ] ) )
            else
               hBrush = CreateSolidBrush( GetBkColor( hDC ) )
               hOld   = SelectObject( hDC, hBrush )
               FillRect( hDC, { nTop, nLeft, nBottom, nRight + If( ( nLineStyle == ;
                         LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. nLineStyle == ;
                         LINES_H_BLACK ) .and. nRowPos != 0, 2, 0 ) }, hBrush )
               SelectObject( hDC, hOld )
               DeleteObject( hBrush )
               DrawText( hDC, cValToChar( aValues[ n ] ),;
                         { nTop, nLeft + 2, nBottom, nRight + If( ( nLineStyle == ;
                           LINES_NONE .or. nLineStyle == LINES_H_GRAY .or. ;
                           nLineStyle == LINES_H_BLACK ) .and. nRowPos != 0, -1, -2 ) },;
                           If( aJustify != nil .and. aJustify[ n ], DT_RIGHT, DT_LEFT ) )
            endif
         else
            DrawText( hDC, cValToChar( aValues[ n ] ),;
                      { nTop, nLeft + 4, nBottom, nRight } )
         endif
      endif
      if ! lTree
         if nRowPos == 0
            if ! IsAppThemed()
               WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )
               WndBoxRaised( hDC, nTop, nLeft, nBottom - 1, nRight - 1 )
            endif
         else
            do case
               case nLineStyle == LINES_BLACK
                    WndBox( hDC, nTop - 1, nLeft - 1, nBottom, nRight )
               case nLineStyle == LINES_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    if GetVersion()[ 1 ] < 4 // Windows Mobile 3.0 bug
                       MoveToLineTo( hDC, nLeft - 2, nTop - 2,;
                                          nLeft - 2, nBottom )
                       MoveToLineTo( hDC, nLeft - 2, nBottom,;
                                          nRight, nBottom )
                    else
                       MoveTo( hDC, nLeft - 2, nTop - 2 )
                       LineTo( hDC, nLeft - 2, nBottom )
                       LineTo( hDC, nRight , nBottom )
                    endif
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )
               case nLineStyle == LINES_3D
                    WndBoxRaised( hDC, nTop, nLeft, nBottom, nRight )

               case nLineStyle == LINES_DOTED
                    SetTextColor( hDC, CLR_BLACK )
                    FrameDot( hDC, nTop - 1, nLeft - 1, nBottom, nRight )

               case nLineStyle == LINES_V_BLACK
                    hPen = CreatePen( PS_SOLID, 1, CLR_BLACK )
                    hOld = SelectObject( hDC, hPen )
                    if GetVersion()[ 1 ] < 4 // Windows Mobile 3.0 bug
                       MoveToLineTo( hDC, nLeft - 1, nTop - 2,;
                                          nLeft - 1, nBottom )
                    else
                       MoveTo( hDC, nLeft - 1, nTop - 2 )
                       LineTo( hDC, nLeft - 1, nBottom )
                    endif
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_V_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    if GetVersion()[ 1 ] < 4  // Windows Mobile 3.0 bug
                       MoveToLineTo( hDC, nLeft - 1, nTop - 2,;
                                          nLeft - 1, nBottom )
                    else
                       MoveTo( hDC, nLeft - 1, nTop - 2 )
                       LineTo( hDC, nLeft - 1, nBottom )
                    endif
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_H_BLACK
                    hPen = CreatePen( PS_SOLID, 1, CLR_BLACK )
                    hOld = SelectObject( hDC, hPen )
                    if GetVersion()[ 1 ] < 4  // Windows Mobile 3.0 bug
                       MoveToLineTo( hDC, nLeft - 2, nBottom,;
                                          nRight , nBottom )
                    else
                       MoveTo( hDC, nLeft - 2, nBottom )
                       LineTo( hDC, nRight , nBottom )
                    endif
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )

               case nLineStyle == LINES_H_GRAY
                    hPen = CreatePen( PS_SOLID, 1, CLR_GRAY )
                    hOld = SelectObject( hDC, hPen )
                    if GetVersion()[ 1 ] < 4  // Windows Mobile 3.0 bug
                       MoveToLineTo( hDC, nLeft - 2, nBottom,;
                                          nRight , nBottom )
                    else
                       MoveTo( hDC, nLeft - 2, nBottom )
                       LineTo( hDC, nRight , nBottom )
                    endif
                    SelectObject( hDC, hOld )
                    DeleteObject( hPen )
            endcase
         endif
      endif

      if nColPos > nWidth
         exit
      endif
   next

   SelectObject( hDC, hOldFont )

   if lReleaseDC
      ReleaseDC( hWnd, hDC )
   endif

return nil

/*

static function aBrwPosRect( hWnd, nRow, aColSizes, nColPos, nCol, hFont )

   local hDC        := GetDC( hWnd )
   local hOldFont   := SelectObject( hDC, hFont )
   local nTxtHeight := GetTextHeight( hWnd, hDC ) + 1
   local nTop       := nTxtHeight * nRow
   local nLeft      := 0
   local n

   for n := nColPos TO nCol - 1
      nLeft += aColSizes[ n ]
   next

   SelectObject( hDC, hOldFont )
   ReleaseDC( hWnd, hDC )

return { nTop-1, nLeft-1, nTop + nTxtHeight - 1, nLeft + aColSizes[ nCol ] - 2 }

*/

//----------------------------------------------------------------------------//

static function IsAppThemed()

return .f.

//----------------------------------------------------------------------------//
//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#include "Windows.h"
#include "hbapi.h"

//----------------------------------------------------------------------------//

WORD GetWindowRows( HWND hWnd, HDC hDC, HFONT hFont, BOOL bSingle )
{
   TEXTMETRIC tm;
   RECT rct;
   WORD wRows;
   BOOL bDCDestroy = FALSE;
   HFONT hOldFont;

   if( ! hDC )
   {
      bDCDestroy = TRUE;
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );

   if ( ! bSingle )
      tm.tmHeight *= 2;

   tm.tmHeight += 1;

   GetClientRect( hWnd, &rct );
   wRows = ( rct.bottom - rct.top ) / tm.tmHeight;

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDCDestroy )
      ReleaseDC( hWnd, hDC );

   return wRows;
}

//----------------------------------------------------------------------------//

HB_FUNC( NWROWS )        // hWnd, hDC, hFont
{
   hb_retni( GetWindowRows( ( HWND ) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ),
                          ( HFONT ) hb_parnl( 3 ) , hb_parl( 4 ) ) );
}

//----------------------------------------------------------------------------//

WORD GetWindowRow( HWND hWnd, HDC hDC, WORD wGraphRow, HFONT hFont, BOOL bSingle ) // -> wTextRow
{
   TEXTMETRIC tm;
   RECT rct;
   WORD wRow;
   BOOL bDCDestroy = FALSE;
   HFONT hOldFont;

   if( ! hDC )
   {
      bDCDestroy = TRUE;
      hDC = GetDC( hWnd );
   }

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );

   if ( ! bSingle )
      tm.tmHeight *= 2;

   tm.tmHeight += 1;

   GetClientRect( hWnd, &rct );
   wRow = ( wGraphRow - rct.top ) / tm.tmHeight;

   if( hFont )
      SelectObject( hDC, hOldFont );

   if( bDCDestroy )
      ReleaseDC( hWnd, hDC );

   return wRow;
}

//----------------------------------------------------------------------------//

HB_FUNC( NWROW )        // hWnd, hDC, nGraphRow, hFont -> nTextRow
{
   hb_retni( GetWindowRow( ( HWND ) hb_parnl( 1 ), ( HDC ) hb_parnl( 2 ),
                         hb_parni( 3 ), ( HFONT ) hb_parnl( 4 ), hb_parl( 5 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef UNICODE
   BOOL ScrollWindow( HWND hWnd, int XAmount, int YAmount, CONST RECT *lpRect,
                      CONST RECT *lpClipRect );
#endif

//----------------------------------------------------------------------------//

HB_FUNC ( SCROLLWINDOW ) // ()  hWnd, nX, nY, aRect, aClip   --> nil
{
   RECT rctScroll, rctClip;

   if( ISARRAY( 4 ) )
   {
      rctScroll.top    = hb_parni( 4, 1 );
      rctScroll.left   = hb_parni( 4, 2 );
      rctScroll.bottom = hb_parni( 4, 3 );
      rctScroll.right  = hb_parni( 4, 4 );
   }

   if( ISARRAY( 5 ) )
   {
      rctClip.top    = hb_parni( 5, 1 );
      rctClip.left   = hb_parni( 5, 2 );
      rctClip.bottom = hb_parni( 5, 3 );
      rctClip.right  = hb_parni( 5, 4 );
   }

   if( ISARRAY( 4 ) )
      ScrollWindow( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ),
                    &rctScroll, 0 );
   else
      ScrollWindow( ( HWND ) hb_parnl( 1 ), hb_parni( 2 ), hb_parni( 3 ),
                    0, &rctClip );
}

//----------------------------------------------------------------------------//

HB_FUNC ( WSCROLL )
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );
   int wRows  = hb_parni( 2 );  // leave it as int, J.M. 23/7/01
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   TEXTMETRIC tm;
   RECT rct;

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetTextMetrics( hDC, &tm );

   GetClientRect( hWnd, &rct );
   rct.bottom -= ( ( rct.bottom - rct.top ) % tm.tmHeight );
   ScrollWindowEx( hWnd, 0, -( tm.tmHeight * wRows ), 0, &rct, 0, 0, 0 );

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

//----------------------------------------------------------------------------//

HB_FUNC( WBRWSCROLL ) // ( hWnd, nRows, hFont ) --> nil
{
   HWND hWnd   = ( HWND ) hb_parnl( 1 );
   int wRows  = hb_parni( 2 );
   HFONT hFont = ( HFONT ) hb_parnl( 3 );
   BOOL bSingle = hb_parl( 4 );
   HFONT hOldFont;
   HDC hDC     = GetDC( hWnd );
   RECT rct;
   TEXTMETRIC tm;

   if( hFont )
      hOldFont = ( HFONT ) SelectObject( hDC, hFont );

   GetClientRect( hWnd, &rct );
   GetTextMetrics( hDC, &tm );

   if( ! bSingle )
      tm.tmHeight *= 2;

   tm.tmHeight += 1;

   rct.top += tm.tmHeight;
   rct.bottom -= ( ( rct.bottom - rct.top ) % tm.tmHeight );

   ScrollWindowEx( hWnd, 0, -( tm.tmHeight * wRows ), 0, &rct, 0, 0, 0 );

   if( hFont )
      SelectObject( hDC, hOldFont );

   ReleaseDC( hWnd, hDC );
}

#pragma ENDDUMP

//----------------------------------------------------------------------------//