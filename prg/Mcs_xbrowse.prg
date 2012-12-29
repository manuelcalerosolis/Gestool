#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "xbrowse.ch"
#include "Report.ch"

#xtranslate MinMax( <xValue>, <nMin>, <nMax> ) => ;
   Min( Max( <xValue>, <nMin> ), <nMax> )

#define GWL_STYLE             -16

#define GW_HWNDFIRST            0
#define GW_HWNDNEXT             2

#define SM_CYVSCROLL            20
#define SM_CYHSCROLL             3

#define CS_DBLCLKS              8

#define COLOR_SCROLLBAR         0
#define COLOR_BACKGROUND        1
#define COLOR_ACTIVECAPTION     2
#define COLOR_INACTIVECAPTION   3
#define COLOR_MENU              4
#define COLOR_WINDOW            5
#define COLOR_WINDOWFRAME       6
#define COLOR_MENUTEXT          7
#define COLOR_WINDOWTEXT        8
#define COLOR_CAPTIONTEXT       9
#define COLOR_ACTIVEBORDER      10
#define COLOR_INACTIVEBORDER    11
#define COLOR_APPWORKSPACE      12
#define COLOR_HIGHLIGHT         13
#define COLOR_HIGHLIGHTTEXT     14
#define COLOR_BTNFACE           15
#define COLOR_BTNSHADOW         16
#define COLOR_GRAYTEXT          17
#define COLOR_BTNTEXT           18
#define COLOR_INACTIVECAPTIONTEXT 19
#define COLOR_BTNHIGHLIGHT      20

#define DT_TOP                      0x00000000
#define DT_LEFT                     0x00000000
#define DT_CENTER                   0x00000001
#define DT_RIGHT                    0x00000002
#define DT_VCENTER                  0x00000004
#define DT_BOTTOM                   0x00000008
#define DT_WORDBREAK                0x00000010
#define DT_SINGLELINE               0x00000020
#define DT_EXPANDTABS               0x00000040
#define DT_TABSTOP                  0x00000080
#define DT_NOCLIP                   0x00000100
#define DT_EXTERNALLEADING          0x00000200
#define DT_CALCRECT                 0x00000400
#define DT_NOPREFIX                 0x00000800
#define DT_INTERNAL                 0x00001000
#define DT_EDITCONTROL              0x00002000
#define DT_PATH_ELLIPSIS            0x00004000
#define DT_END_ELLIPSIS             0x00008000
#define DT_MODIFYSTRING             0x00010000
#define DT_RTLREADING               0x00020000
#define DT_WORD_ELLIPSIS            0x00040000
#define DT_NOFULLWIDTHCHARBREAK     0x00080000
#define DT_HIDEPREFIX               0x00100000

#define MK_MBUTTON          0x0010

#define COL_EXTRAWIDTH        6
#define ROW_EXTRAHEIGHT       4
#define COL_SEPARATOR         2
#define BMP_EXTRAWIDTH        5

#define RECORDSELECTOR_WIDTH 25

#define BITMAP_HANDLE         1
#define BITMAP_PALETTE        2
#define BITMAP_WIDTH          3
#define BITMAP_HEIGHT         4
#define BITMAP_ZEROCLR        5

#define VSCROLL_MAXVALUE      10000  // never set values above 32767

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif



//------------------------------------------------------------------------------

static lThouSep        := .t.
static cNumFormat      := "A"
static nxlLangID, cxlTrue := "=(1=1)", cxlFalse := "=(1=0)", cxlSum, cxlSubTotal, lxlEnglish := .f.
//----------------------------------------------------------------------------//

CLASS TXBrowse FROM TControl

   DATA oVScroll,;   // Horizontal scrollbar (used internally)
        oHScroll,;   // Vertical scrollbar (used internally)
        oCapCol,;    // Actual mouse captured column (used internally)
        oSeek,;      // Optional TSay control to display the value of current ::cSeek value
        oDbf         // Just a container for a DBF object for your own use (it is not used by the class)

   DATA aCols,;      // Array of TXBrwCols (used internally)
        aDisplay,;   // Array of current diplayed ordinal columns (used internally)
        aSelected,;  // Currently records selected (only use with marquee style MARQSTYLE_HIGHLROWMS
        aArrayData   // Array data (filled on SetArray())

   // Code-blocks for navitation

   DATA bGoTop,;     // codeblock for going to first row
        bGoBottom,;  // codeblock for going to last row
        bSkip,;      // codeblock for skiping rows, it receives the number of rows
        ;            // to skip. IT SHOULD RETURN THE NUMBER OF ROWS SKIPPED
        bBof,;       // codeblock to check if we are at the first row
        bEof,;       // codeblock to check if we are at the bottom row
        bKeyNo,;     // SETGET codeblock to be used for positioning the vertical scrollbar
        ;            // When no parameter is passed it should return the actual position
        ;            // When a parameter is passed should perform a jump to that position
        ;            // For example: {|n| iif( n == nil,  OrdKeyNo(), OrdKeyGoto(n) }
        bKeyCount,;  // codeblock that returns the total number of rows
        bBookMark,;  // SETGET codeblock to be used for bookmarking a specific row
        ;            // When no parameter is passed it should return a bookamark value
        ;            // When a parameter is passed should return to that bookmark position
        ;            // For example: {|n| iif( n == nil,  Recno(), DbGoto(n) }
        bSeek,;      // block expresion for autoincremental search. It should return .T. when found
        ;            // Receives the string to search
        bPastEof     // block to evaluate if trying to go down after the last row

   // This code-blocks should return an two dimension array with {nFore, nBack} colors

   DATA bClrHeader,; // default color pair for header
        bClrFooter,; // default color pair for footer
        bClrStd,;    // default color pair for normal rows
        bClrSel,;    // default color pair for selected row
        bClrSelFocus,; // default color pair for selected row when control has focus
        bClrRowFocus

   DATA cAlias,;     // Alias when accesing via RDD
        cSeek;       // string that hold the current string searched (for autoincremental seek)
        AS CHARACTER

   DATA nRowSel,;   // Current row selected based on current display
        nColSel,;   // Current columns based on current display
        nFreeze,;   // Number of columns to freeze
        nColOffset; // Actual first column to be shown after freeze
        AS NUMERIC

   DATA nHeaderLines,; // Number of lines of the header
        nFooterLines,; // Number of lines of the footer
        nDataLines;    // Number of lines of the data rows
        AS NUMERIC

   DATA nDataType;  // Data type to be used: 0->rdd, 1->array, ... (more to come)
        AS NUMERIC  // If navigation codeblocks are not specified then get automatically
                    // initialiated when adjusting the browse depending on this DATA value

   DATA nHeaderHeight,; // Header height. If this value is NIL, the is calculated on the Adjust method
        nFooterHeight,; // Footer height. If this value is NIL, the is calculated on the Adjust method
        nRowHeight,;    // Data row height. If this value is NIL, the is calculated on the Adjust method
        nRecSelColor    // Background color for the record selector column, by default uses the backgrounf footer

   DATA nRowDividerStyle,; // Row divider style
        nColDividerStyle;  // Col divider style
        AS NUMERIC         // O LINESTYLE_NOLINES
                           // 1 LINESTYLE_BLACK
                           // 2 LINESTYLE_DARKGRAY
                           // 3 LINESTYLE_FORECOLOR
                           // 4 LINESTYLE_LIGHTGRAY
                           // 5 LINESTYLE_INSET
                           // 6 LINESTYLE_RAISED

   DATA nMarqueeStyle;  // Marquee style (row selected)
        AS NUMERIC      // 0 No Marquee
                        // 1 Dotted cell
                        // 2 Solid cell
                        // 3 Highlight cell
                        // 4 Highlight row & Raise Cell
                        // 5 Highlight row
                        // 6 Highlight row & multiselect

   DATA nLen,;          // Actual data len. This data is updated with Eval( bKeyCount ) (used internally)
        nDataRows,;     // Actual number of data rows, used internally
        nCaptured,;     // Mouse captured: 0-> No, 1->In header, 2-> In footer, 3->ResizeCol, 4->ResizeLine (used internally)
        nArrayAt,;      // When SetArray() method is used return the actual array element (used internally)
        nLastEditCol;  // Last edited col (display based)
        AS NUMERIC

   DATA nVScrollPos;    // Actual absolute vertical scroll pos (used internally)
        AS NUMERIC

   DATA hBtnShadowPen,; // Pen handle for shadow buttons color (used internally)
        hWhitePen,;     // Pen handle for white color (used internally)
        hColPen,;       // Pen for column lines (used internally)
        hRowPen,;       // Pen for row lines (used internally)
        hBmpRecSel,;    // Bitmap Handle for the record selector triangle (used internally)
        hBrushRecSel    // Brush Handle for the record selector (used internally)

   DATA lCreated,;            // True when control is completaly created (used internally)
        lRecordSelector,;     // if true a record selector column is displayed
        lHScroll,;            // Horizontal Scrollbar, it should be assigned before the createfrom..() method
        lVScroll,;            // Vertical Scrollbar, it should be assigned before the createfrom..() method
        lAllowRowSizing,;     // If true horizontal row sizing is allowed
        lAllowColSwapping,;   // If true col swapping is allowed
        lAllowColHiding,;     // If true col hiding is allowed
        lColDividerComplete,; // If true the vertical lines are displayed to the bottom of the browse even
        ;                     // there are not enough data rows
        lFastEdit, ;          // Go to edit mode just pushing a alpha or digit char on a editable column
        ;                     // (incompatible with incremental seek and highlite row)
        lEditMode,;           // Some column is in edit mode (used internally)
        lRefreshOnlyData,;    // True when only the data should be painted (used internally)
        l2007 ;               // 2007 look
        AS LOGICAL

   DATA lAutoSort AS LOGICAL INIT .f.  // used internally. do not use in applications
   DATA lAllowCopy AS LOGICAL INIT .t.

   DATA lHeader,;  // Browse has header, if this value is nil then is initialized automatically on the Adjust method
        lFooter    // Browse has footer, if this value is nil then is initialized automatically on the Adjust method

   DATA nSaveMarq    // used internally
   DATA oRS          // ADO recordset if Method SetAdo() is used
   DATA oTree, oTreeItem  // Do not set them directly, instead use SetTree method. Can be accessed
   DATA bOnRowLeave
   DATA lEdited         INIT .f.
   DATA bLock           INIT { || .t. }
   DATA bUnLock
   DATA uStretchInfo    // Internal use only
   DATA nStretchCol

   CLASSDATA lRegistered AS LOGICAL // used internally

   METHOD New( oWnd )
   METHOD Destroy()

   METHOD nAt() INLINE ::colpos( ::SelectedCol() )

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD SetRDD( lAddColumns, lAutoSort, aFldNames )
   METHOD SetArray( aData, lAutoSort, nColOrder, aCols )
   METHOD SetoDbf( oDbf, aFldNames )
   METHOD SetAdo( oRs, lAddCols, lAutoOrder, aFldNames ) // ADO object
   METHOD SetTree( oTree, aResource, bOnSkip )
   METHOD SetColFromADO( cnCol, lAutoOrder )  // Used internally

   METHOD AddCol()
   METHOD InsCol( nPos )
   METHOD DelCol( nPos )
   METHOD SwapCols( xCol1, xCol2, lRefresh )
   METHOD MoveCol( xFrom, xTo, lRefresh )

   METHOD CreateFromCode()
   METHOD CreateFromResource( nId )

   METHOD SelectCol( nCol )
   METHOD GoLeft( lOffset, lRefresh )
   METHOD GoRight( lOffset, lRefresh )
   METHOD GoLeftMost()
   METHOD GoRightMost()

   METHOD GoUp()
   METHOD GoDown()
   METHOD PageUp( nLines )
   METHOD PageDown( nLines )
   METHOD GoTop()
   METHOD GoBottom()

   METHOD KeyCount() INLINE ( ::nLen := Eval( ::bKeyCount ),;
                              iif(::oVScroll != nil ,;
                                  ( ::VSetRange( 1, ::nLen ), ::VUpdatePos() ), ),;
                              ::nLen )

   METHOD KeyNo( n ) INLINE Eval( ::bKeyNo, n, Self )
   METHOD Skip( n )  INLINE Eval( ::bSkip, n )
   METHOD Bof()      INLINE Eval( ::bBof )
   METHOD Eof()      INLINE Eval( ::bEof )

   METHOD SaveState()
   METHOD RestoreState( cInfo )

   METHOD Seek( cSeek )

   METHOD Select( nOperation ) // 0 -> Delete all
                               // 1 -> Add current key
                               // 2 -> Swap current key (Ctrl+lClick)
                               // 3 -> Tipical Shift with mouse
                               // 4 -> Select all

   METHOD SelectAll()  INLINE ::Select( 4 )
   METHOD SelectNone() INLINE ::Select( 0 )

   METHOD Adjust()

   METHOD Report( cTitle, lPreview, lModal, bSetUp, aGroupBy )
   METHOD ToExcel( bProgress, aGroupBy )

   // The rest of the methods are used internally

   METHOD Initiate( hDlg )
   METHOD Display()
   METHOD Paint()

   METHOD Refresh( lComplete )

   METHOD DrawLine( lSelected, nRowLine )

   METHOD GotFocus( hCtlFocus )  INLINE ( Super:GotFocus( hCtlFocus ),;
                                          If( GetParent( hCtlFocus ) != ::hWnd, ::Super:Refresh( .f. ), ) )
   METHOD LostFocus( hCtlFocus ) INLINE ( Super:LostFocus( hCtlFocus ),;
                                          If( GetParent( hCtlFocus ) != ::hWnd, ::Super:Refresh( .f. ), ) )

   METHOD GetDlgCode( nLastKey )

   METHOD LButtonDown( nRow, nCol, nKeyFlags )
   METHOD LButtonUp( nRow, nCol, nKeyFlags )
   METHOD MouseMove( nRow, nCol, nKeyFlags )
   METHOD LDblClick( nRow, nCol, nKeyFlags )
   METHOD RButtonDown( nRow, nCol, nKeyFlags )
   METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos )
   METHOD HorzLine( nRow, nOperation ) // nOperation (1 Down, 2 Up, 3 Move )
   METHOD MouseAtHeader( nRow, nCol )
   METHOD MouseAtFooter( nRow, nCol )
   METHOD MouseColPos( nCol )
   METHOD MouseRowPos( nRow )

   METHOD EraseData( nRow )

   METHOD KeyDown( nKey, nFlags )
   METHOD KeyChar( nKey, nFlags )

   METHOD HScroll( nWParam, nLParam )
   METHOD VScroll( nWParam, nLParam )

   METHOD VUpdatePos() INLINE ::VSetPos( Eval( ::bKeyNo,,Self ) )
   METHOD VUpdateAll() INLINE ::KeyCount()

   METHOD VSetPos( nPos ) INLINE ::nVScrollPos := nPos,;
                                 ::oVScroll:SetPos( iif( ::nLen <= VSCROLL_MAXVALUE,;
                                                         nPos,;
                                                         Int( nPos * VSCROLL_MAXVALUE / ::nLen ) ) )

   METHOD VThumbPos( nPos ) INLINE ::nVScrollPos := ::VGetThumbPos( nPos ),;
                                   ::oVScroll:SetPos( nPos )

   METHOD VGetPos()        INLINE ::nVScrollPos

   METHOD VSetRange( nMin, nMax ) INLINE ::oVScroll:SetRange( Min( 1, nMin ),;
                                                              Max( Min( VSCROLL_MAXVALUE, nMax ), 2 ) )

   METHOD VGetMax()       INLINE ::oVScroll:nMax * iif( ::nLen <= VSCROLL_MAXVALUE,;
                                                        1,;
                                                        ::nLen / VSCROLL_MAXVALUE )

   METHOD VGoDown()       INLINE ::VSetPos( ::nVScrollPos + 1 )
   METHOD VGoUp()         INLINE ::VSetPos( ::nVScrollPos - 1 )

   METHOD VGetThumbPos( nPos ) INLINE iif( ::nLen <= VSCROLL_MAXVALUE,;
                                           nPos,;
                                           Int( nPos * ::nLen / VSCROLL_MAXVALUE ) )

   METHOD VGoBottom() INLINE ::VSetPos( ::nLen )
   METHOD VGoTop()    INLINE ::VSetPos( 1 )

   METHOD GetDisplayCols()
   METHOD GetVisibleCols() // returns an array of visible (Not hided) column objects
   METHOD GetDisplayColsWidth( aOptionalReturnedSizes )
   METHOD ColAtPos( nPos ) INLINE ::aCols[ ::aDisplay[ MinMax( If( nPos == nil, 1, nPos ), 1, Len( ::aDisplay ) ) ] ]
   METHOD ColPos( oCol )
   METHOD SelectedCol() INLINE ::ColAtPos( ::nColSel )

   METHOD IsDisplayPosVisible( nPos, lComplete )
   METHOD LastDisplayPos()
   METHOD BrwWidth()     INLINE ( ::nWidth - iif( ::lVScroll , GetSysMetrics( SM_CYVSCROLL ), 0 ) )
   METHOD BrwHeight()    INLINE ( ::nHeight - 2 - iif( ::lHScroll, GetSysMetrics( SM_CYHSCROLL ), 0 ) )
   METHOD HeaderHeight() INLINE iif( ::nHeaderHeight == nil, 0, ::nHeaderHeight )
   METHOD FooterHeight() INLINE iif( ::nFooterHeight == nil, 0, ::nFooterHeight )
   METHOD RowCount()     INLINE Int( ( ::BrwHeight() - ::HeaderHeight() - ::FooterHeight() ) / ::nRowHeight )
   METHOD FirstRow()     INLINE ::HeaderHeight()
   METHOD LastRow()      INLINE ::BrwHeight() - ::FooterHeight() - ::nRowHeight + 1
   METHOD FooterRow()    INLINE ::BrwHeight() - ::FooterHeight() + 1
   METHOD DataHeight()   INLINE ::nRowHeight - iif(::nRowDividerStyle > LINESTYLE_NOLINES, 1, 0) - ;
                                iif(::nRowDividerStyle >= LINESTYLE_INSET, 1, 0)
   METHOD CancelEdit()
   METHOD SetColumns()

   METHOD GoNextCtrl()
   METHOD GoPrevCtrl() VIRTUAL

   METHOD SelFont()
   // new methods
   METHOD FontSize( nPlus )
   METHOD DrawSelect()        INLINE ::DrawLine( .t. )
   METHOD RefreshCurrent()    INLINE ::DrawLine( .t. )
   METHOD aRow                INLINE ( ::aArrayData[ ::nArrayAt ] )  // to make the coding easy
   METHOD oCol( cHeader )
   METHOD RefreshFooters()    INLINE If( Empty( ::nFooterHeight ),,AEval( ::aCols, { | oCol | oCol:RefreshFooter() } ) )
   METHOD ClpRow()
   METHOD Copy()
   METHOD aCellCoor( nRow, nCol ) // --> { nTop, nLeft, nBottom, nRight } in pixels for cell at nVisibleRow, nVisibleCol
   METHOD SetPos( nRow, nCol, lPixel )
   METHOD SetBackGround( oBrush ) // call with no paratmer to clear background
   METHOD ColStretch( nStretchCol ) // used internally


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TXBrowse

   DEFAULT oWnd := GetWndDefault()

   ::oWnd  := oWnd

   If oWnd != nil
      ::oFont := oWnd:oFont
   Endif

   ::aCols       := {}
   ::aSelected   := {}

   ::bClrHeader   := {|| { GetSysColor( COLOR_BTNTEXT ), GetSysColor( COLOR_BTNFACE ) } }
   ::bClrFooter   := ::bClrHeader
   ::bClrStd      := {|| { CLR_BLACK, GetSysColor( COLOR_WINDOW )} }
   ::bClrSel      := {|| { CLR_BLACK, GetSysColor( COLOR_INACTIVECAPTIONTEXT )} }
   ::bClrSelFocus := {|| { CLR_WHITE, GetSysColor( COLOR_HIGHLIGHT )} }

   // ::bKeyCount := { || 1 }
   // ::bKeyNo    := { || 1 }
   // ::bSkip     := { || 0 }
   // ::bBookMark := { || 0 }

   ::cCaption := ""
   ::cAlias   := ""
   ::cSeek    := ""

   ::nDataType := DATATYPE_RDD

   ::nTop     := 0
   ::nLeft    := 0
   ::nBottom  := 100
   ::nRight   := 100

   ::nStyle := nOr( WS_CHILD, WS_BORDER, WS_VISIBLE, WS_TABSTOP )

   ::SetColor( CLR_BLACK, GetSysColor( COLOR_WINDOW ) )

   ::lDrag     := .f.
   ::lFocused  := .f.
   ::lHScroll  := .t.
   ::lVScroll  := .t.

   ::lRecordSelector     := .t.
   ::lAllowRowSizing     := .t.
   ::lColDividerComplete := .f.
   ::lAllowColSwapping   := .t.
   ::lAllowColHiding     := .t.
   ::lFastEdit           := .f.

   ::nRowSel      := 1
   ::nColSel      := 1
   ::nColOffset   := 1
   ::nFreeze      := 0
   ::nCaptured    := 0
   ::nLastEditCol := 0

   ::nRowDividerStyle := LINESTYLE_NOLINES
   ::nColDividerStyle := LINESTYLE_NOLINES
   ::nMarqueeStyle    := MARQSTYLE_SOLIDCELL

   ::nHeaderLines := 1
   ::nFooterLines := 1
   ::nDataLines   := 1

   ::hBmpRecSel := FwRArrow()

   ::lHeader          := .t.
   ::lFooter          := .f.
   ::lRefreshOnlyData := .f.

   ::l2007        := ( ColorsQty() > 256 )

return Self

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TXBrowse

   local nFor

   for nFor := 1 to Len( ::aCols )
      ::aCols[ nFor ]:End()
   next

   DeleteObject( ::hBmpRecSel )
   DeleteObject( ::hBrushRecSel )

   if ::hBtnShadowPen != nil
      DeleteObject( ::hBtnShadowPen )
      ::hBtnShadowPen := nil
   endif

   if ::hWhitePen != nil
      DeleteObject( ::hWhitePen )
      ::hWhitePen := nil
   endif

   if ::hColPen != nil
      DeleteObject( ::hColPen )
      ::hColPen := nil
   endif

   if ::hRowPen != nil
      DeleteObject( ::hRowPen )
      ::hRowPen := nil
   endif

return ( Super:Destroy() )

//----------------------------------------------------------------------------//

METHOD CreateFromCode() CLASS TXBrowse

   if ::lCreated
      return Self
   endif

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::nId := ::GetNewId()

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   if ::lDesign
      ::nStyle := nOr( ::nStyle, WS_CLIPSIBLINGS )
   endif

   if ::lVScroll
      ::nStyle := nOr( ::nStyle, WS_VSCROLL )
   endif

   if ::lHScroll
      ::nStyle := nOr( ::nStyle, WS_HSCROLL )
   endif

   if ! Empty( ::oWnd:hWnd )
      ::Create()
      if ::oFont != nil
         ::SetFont( ::oFont )
      endif
      ::Initiate()
      ::lVisible := .t.
      ::oWnd:AddControl( Self )
   else
      ::lVisible := .f.
      ::oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD CreateFromResource( nId ) CLASS TXBrowse

   if ::lCreated
      return Self
   endif

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::nId := nId

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW, CS_DBLCLKS ) )

   ::oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TXBrowse

   local oBrush

   if ::oBrush != nil
      oBrush := ::oBrush
      ::oBrush := nil
   endif

   if hDlg != nil
      Super:Initiate( hDlg )
      ::SetColor( CLR_BLACK, GetSysColor( COLOR_WINDOW ) )
   endif

   if ::lVScroll .or. lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_VSCROLL )
      DEFINE SCROLLBAR ::oVScroll VERTICAL OF Self
   endif

   if ::lHScroll .or. lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_HSCROLL )
      DEFINE SCROLLBAR ::oHScroll HORIZONTAL OF Self
   endif

   if ::nDataType == DATATYPE_ARRAY .or. ! Empty( ::aArrayData )
      ::SetArray( ::aArrayData )
   elseif ::nDataType == DATATYPE_ADO .or. ! Empty( ::oRs )
      ::SetADO( ::oRs )
   elseif ::nDataType == DATATYPE_ODBF .or. ! Empty ( ::oDbf )
      ::SetoDbf( ::oDbf )
   elseif ::nDataType == DATATYPE_TREE
   else
      ::SetRDD()
   endif

   ::lCreated := .t.

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::GetFont()
   endif

   if oBrush != nil
      if ::oBrush != nil
         ::oBrush:End()
      endif
      ::oBrush = oBrush
   endif

   ::Adjust()

return Self

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TXBrowse

   local nFor, nLen, nHeight, nStyle

   nLen    := Len( ::aCols )
   nHeight := 0

   ::GetDC()

   for nFor := 1 to nLen
      ::aCols[ nFor ]:Adjust()
   next

   ::ReleaseDC()

   if ::lHeader .and. ::nHeaderHeight == nil
      for nFor := 1 to nLen
         nHeight := Max( nHeight, ::aCols[ nFor ]:HeaderHeight() )
      next
      ::nHeaderHeight := ( nHeight * ::nHeaderLines ) + ROW_EXTRAHEIGHT + 3 // lines to give 3d look
   endif

   if ::lFooter .and. ::nFooterHeight == nil
      nHeight := 0
      for nFor := 1 to nLen
         nHeight := Max( nHeight, ::aCols[ nFor ]:FooterHeight() )
      next
      ::nFooterHeight := ( nHeight * ::nFooterLines ) + ROW_EXTRAHEIGHT + 3 // lines to give 3d look
   endif

   if ::nRowHeight == nil
      nHeight := 0
      for nFor := 1 to nLen
         nHeight := Max( nHeight, ::aCols[ nFor ]:DataHeight() )
      next
      ::nRowHeight := ( nHeight * ::nDataLines ) + ROW_EXTRAHEIGHT //+ 2 // lines to give 3d look
      if ::nRowDividerStyle != LINESTYLE_NOLINES
         ::nRowHeight++
      endif
      if ::nRowDividerStyle >= LINESTYLE_INSET
         ::nRowHeight++
      endif
   endif

   DEFAULT ::hBtnShadowPen := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) ),;
           ::hWhitePen     := CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )

   if ::hColPen != nil
      DeleteObject( ::hColPen )
      ::hColPen := nil
   endif

   nStyle := ::nColDividerStyle

   do case
   case nStyle == LINESTYLE_BLACK .or. nStyle == LINESTYLE_RAISED .or. nStyle == LINESTYLE_INSET
      ::hColPen := CreatePen( PS_SOLID, 1, CLR_BLACK )
   case nStyle == LINESTYLE_DARKGRAY
      ::hColPen := CreatePen( PS_SOLID, 1, CLR_GRAY )
   case nStyle == LINESTYLE_FORECOLOR
      ::hColPen := CreatePen( PS_SOLID, 1, ::nClrText )
   case nStyle == LINESTYLE_LIGHTGRAY
      ::hColPen := CreatePen( PS_SOLID, 1, CLR_LIGHTGRAY )
   end case

   nStyle := ::nRowDividerStyle

   do case
   case nStyle == LINESTYLE_BLACK .or. nStyle == LINESTYLE_RAISED .or. nStyle == LINESTYLE_INSET
      ::hRowPen := CreatePen( PS_SOLID, 1, CLR_BLACK )
   case nStyle == LINESTYLE_DARKGRAY
      ::hRowPen := CreatePen( PS_SOLID, 1, CLR_GRAY )
   case nStyle == LINESTYLE_FORECOLOR
      ::hRowPen := CreatePen( PS_SOLID, 1, ::nClrText )
   case nStyle == LINESTYLE_LIGHTGRAY
      ::hRowPen := CreatePen( PS_SOLID, 1, CLR_LIGHTGRAY )
   end case

   if ::nRecSelColor == nil
      ::nRecSelColor := If( ::l2007, nRGB( 231, 242, 255 ), Eval( ::bClrHeader )[ 2 ] )
   endif

   ::hBrushRecSel := CreateSolidBrush( ::nRecSelColor )

   ::GetDisplayCols()

   ::KeyCount()

   if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
      ::Select(1)
   endif

   if ::oVScroll != nil
      ::VSetRange( 1, ::nLen )
      ::VSetPos( Eval( ::bKeyNo,,Self ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Refresh( lComplete )  CLASS TXBrowse

   local nKeyNo

   DEFAULT lComplete := .F.

   if ::nDataType == DATATYPE_RDD .and. Select( ::cAlias ) == 0
      return .f.
   end if

   ::KeyCount()

   if lComplete
      ::nRowSel  = 1
      ::nArrayAt = Min( 1, ::nLen )
   else
      nKeyNo     = Eval( ::bKeyNo,,Self )
      ::nArrayAt = Min( ::nArrayAt, ::nLen )
      ::nRowSel  = Max( 1, Min( ::nRowSel, ::nLen ) )
      ::nRowSel  = Max( 1, Min( ::nRowSel, nKeyNo ) ) // bKeyNo for ADS is approx. can be zero also
      if nKeyNo == ::nLen .and. ::nLen > 1
         ::nRowSel   := Min( ::nLen, ::RowCount() )
      endif

      if ::nArrayAt == 0 .and. ::nLen > 0
         // when one or more rows are added to a blank array
         ::nArrayAt  := 1
      endif
   endif

   ::GetDisplayCols()

return Super:Refresh( .T. )

//----------------------------------------------------------------------------//

METHOD Display() CLASS TXBrowse

   if !::lCreated
      return nil
   endif

   ::BeginPaint()
   ::Paint()
   ::EndPaint()

return 0

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TXBrowse

   local aCols, aColors
   local oCol
   local nFor, nLen, nRow, nCol, nHeight, nLast, nTemp, nTemp2
   local nBrwWidth, nBrwHeight, nWidth
   local hBrush, hDC, hGrayPen, hWhitePen, hColPen, hRowPen, hSelBrush
   local nFirstRow, nLastRow, nMaxRows, nRowStyle, nColStyle, nRowPos, nRowHeight, nBookMark, nMarqStyle, nScan
   local lRecSel, lOnlyData, lHighLite
   local aInfo := ::DispBegin()

   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )

   ::ColStretch()

   nLen       := Len( ::aDisplay )
   aCols      := Array( nLen + 1)
   nBrwWidth  := ::BrwWidth()
   nBrwHeight := ::BrwHeight()
   nRow       := 0
   nCol       := 0
   nFirstRow  := 0
   nLastRow   := nBrwHeight
   nLast      := ::LastDisplayPos()
   nMarqStyle := ::nMarqueeStyle
   nRowStyle  := ::nRowDividerStyle
   nColStyle  := ::nColDividerStyle
   hDC        := ::hDC
   hGrayPen   := ::hBtnShadowPen
   hWhitePen  := ::hWhitePen
   hColPen    := ::hColPen
   hRowPen    := ::hRowPen
   lRecSel    := ::lRecordSelector
   lOnlyData  := ::lRefreshOnlyData
   lHighLite  := .f.

   /*
   Rowselector
   */

   if lRecSel
      nCol += RECORDSELECTOR_WIDTH
      if !lOnlyData
         FillRect( hDC, {0, 0, nLastRow + 3, nCol - 1}, ::hBrushRecSel )
         nHeight := ::HeaderHeight()
         nTemp   := ::BrwHeight() - ::FooterHeight() + 3
         MoveTo( hDC, nCol - 3, nHeight )
         LineTo( hDC, nCol - 3, nTemp , hWhitePen )
         MoveTo( hDC, nCol - 2, nHeight )
         LineTo( hDC, nCol - 2, nTemp , hGrayPen )
         MoveTo( hDC, 0, 0 )
         LineTo( hDC, 0, ::BrwHeight() + 3 , hGrayPen )
         MoveTo( hDC, 1, 0 )
         LineTo( hDC, 1, ::BrwHeight() + 3, hWhitePen )
      endif

      //nCol --
   endif

   for nFor := 1 to nLast
      aCols[ nFor ] := nCol
      oCol := ::ColAtPos( nFor )
      nCol += oCol:nWidth + COL_SEPARATOR
   next

   aCols[ nFor ] := nCol

   /*
   Paint Header
   */

   if ::lHeader
      if !lOnlyData
         nRow    := 0
         nHeight := ::nHeaderHeight - 3
         MoveTo( hDC, 2, nRow)
         LineTo( hDC, nBrwWidth, nRow, hGrayPen )
         nRow++
         MoveTo( hDC, 2, nRow )
         LineTo( hDC, nBrwWidth, nRow, hWhitePen )
         nRow++
         MoveTo( hDC, 2, nRow + nHeight)
         LineTo( hDC, nBrwWidth, nRow +  nHeight , hGrayPen )
         aColors := Eval( ::bClrHeader )
         hBrush  := CreateSolidBrush( aColors[ 2 ] )
         FillRect( hDC, {nRow, 2, nRow + nHeight, nBrwWidth}, ::hBrushRecSel ) // hBrush )
         DeleteObject( hBrush )
         for nFor := 1 to nLast
            nCol := aCols[ nFor ]
            oCol := ::ColAtPos( nFor )
            MoveTo( hDC, nCol - 2, nRow + 1 )
            LineTo( hDC, nCol - 2, nRow + nHeight - 2, hGrayPen )
            MoveTo( hDC, nCol - 1, nRow + 1 )
            LineTo( hDC, nCol - 1, nRow + nHeight - 2, hWhitePen )
            oCol:PaintHeader( nRow, nCol, nHeight )
         next
         nCol := aCols[ nFor ]
         MoveTo( hDC, nCol - 2, nRow + 1 )
         LineTo( hDC, nCol - 2, nRow + nHeight - 2, hGrayPen )
         MoveTo( hDC, nCol - 1, nRow + 1 )
         LineTo( hDC, nCol - 1, nRow + nHeight - 2, hWhitePen )
      endif
      nFirstRow += ::nHeaderHeight
   endif

   /*
   Paint Footer
   */

   if ::lFooter
      if !lOnlyData
         nHeight  := ::nFooterHeight - 3
         nRow     := nBrwHeight - ::nFooterHeight
         aColors := Eval( ::bClrFooter )
         MoveTo( hDC, 0, nRow)
         LineTo( hDC, nBrwWidth, nRow, hGrayPen )
         nRow++
         MoveTo( hDC, 0, nRow )
         LineTo( hDC, nBrwWidth, nRow, hWhitePen )
         nRow++
         MoveTo( hDC, 0, nRow + nHeight)
         LineTo( hDC, nBrwWidth, nRow +  nHeight , hGrayPen )
         hBrush  := CreateSolidBrush( aColors[ 2 ] )
         FillRect( hDC, {nRow, 0, nRow + nHeight, nBrwWidth}, ::hBrushRecSel ) // hBrush )
         DeleteObject( hBrush )
         for nFor := 1 to nLast
            nCol := aCols[ nFor ]
            oCol := ::ColAtPos( nFor )
            MoveTo( hDC, nCol - 2, nRow + 1 )
            LineTo( hDC, nCol - 2, nRow + nHeight - 2, hGrayPen )
            MoveTo( hDC, nCol - 1, nRow + 1 )
            LineTo( hDC, nCol - 1, nRow + nHeight - 2, hWhitePen )
            oCol:PaintFooter( nRow, nCol, nHeight )
         next
         nCol := aCols[ nFor ]
         MoveTo( hDC, nCol - 2, nRow + 1 )
         LineTo( hDC, nCol - 2, nRow + nHeight - 2, hGrayPen )
         MoveTo( hDC, nCol - 1, nRow + 1 )
         LineTo( hDC, nCol - 1, nRow + nHeight - 2, hWhitePen )
      endif
      nLastRow -= ::nFooterHeight
   endif

   /*
   Paint cols data
   */

   ::lRefreshOnlyData := .f.

   if ::nLen == 0
      ::EraseData( nFirstRow  )
      ::DispEnd( aInfo )
      return nil
   endif

   nRowHeight := ::nRowHeight
   nHeight    := ::DataHeight() // nRowHeight - 2
   nMaxRows   := ::RowCount()
   nRowPos    := 1
   nRow       := nFirstRow
   nBookMark  := Eval( ::bBookMark )

   Eval( ::bSkip, 1 - Min( ::nRowSel, nMaxRows ) )

   if nMarqStyle > MARQSTYLE_HIGHLCELL // .and. aCols[ nLast + 1 ] < nBrwWidth
      if ::hWnd == GetFocus()
         hSelBrush := CreateSolidBrush( Eval( If( ::bClrRowFocus == nil, ::bClrSelFocus, ::bClrRowFocus ) )[ 2 ] )
      else
         hSelBrush := CreateSolidBrush( Eval( ::bClrSel )[ 2 ] )
      endif
   endif

   do while nRowPos <= nMaxRows

      // We must also paint some times after the last visible column

      if hSelBrush != nil

         lHighLite := ( nMarqStyle == MARQSTYLE_HIGHLROWMS ) .and. ;
                      ( Ascan( ::aSelected, Eval( ::bBookMark ) ) > 0 )

         if aCols[ nLast + 1 ] < nBrwWidth
            nTemp     := nRow + nHeight
            nTemp2    := aCols[nLast + 1]
            if nColStyle < LINESTYLE_INSET
               nTemp2--
            endif
            if lHighLite
               FillRect( hDC, {nRow, nTemp2, nTemp, nBrwWidth }, hSelBrush )
            else

               if ! ( ::lTransparent == .t. )
                  hBrush := CreateSolidBrush( Eval( ::bClrStd )[ 2 ] )
                  FillRect( hDC, {nRow, nTemp2, nTemp, nBrwWidth }, hBrush )
                  DeleteObject( hBrush )
               endif

            endif
         endif

      endif

      for nFor := 1 to nLast
         if aCols[ nFor ] > nBrwWidth
            exit
         endif
         oCol := ::ColAtPos( nFor )
         oCol:PaintData( nRow, aCols[ nFor ], nHeight, lHighLite, .f., nFor )
      next

      nRowPos++
      nRow += nRowHeight

      if Eval( ::bSkip ) == 0
         exit
      endif

   enddo

   if nMarqStyle <= MARQSTYLE_HIGHLCELL .and. aCols[ nLast + 1 ] < nBrwWidth .and. ! ( ::lTransparent == .t. )
      hBrush := CreateSolidBrush( ::nClrPane )
      nTemp  := aCols[nLast + 1] - 1
      FillRect( hDC, {nFirstRow, nTemp, ::BrwHeight() - ::FooterHeight(), nBrwWidth }, hBrush )
      DeleteObject( hBrush )
   endif

   if hSelBrush != nil
      DeleteObject( hSelBrush )
   endif

   ::nDataRows := nRowPos - 1
   ::nRowSel := Max( Min( ::nRowSel, ::nDataRows ), 1)

   if nRow < nLastRow
      ::EraseData( nRow  )
   endif

   Eval( ::bBookMark, nBookMark )

   ::DrawLine( .t. )

   /*
   Paint lines
   */

   do case
   case nColStyle == LINESTYLE_NOLINES
      nTemp := 2
   case nColStyle < LINESTYLE_INSET
      nTemp := 1
   otherwise
      nTemp := 0
   end case

   if nColStyle > 0
      if ::lColDividerComplete
         nHeight := nLastRow
      else
         nHeight := ( ::nRowHeight * ( nRowPos - 1 )) + nFirstRow
      endif
      for nFor := 2 to nLast + 1
         nCol := acols[ nFor ]
         MoveTo( hDC, nCol - 2, nFirstRow)
         if nColStyle != LINESTYLE_RAISED
            LineTo( hDC, nCol - 2, nHeight, hColPen )
         else
            LineTo( hDC, nCol - 2, nHeight, hWhitePen )
            MoveTo( hDC, nCol - 1, nFirstRow)
            LineTo( hDC, nCol - 1, nHeight, hColPen )
         endif
         if nColStyle = LINESTYLE_INSET
            MoveTo( hDC, nCol - 1, nFirstRow)
            LineTo( hDC, nCol - 1, nHeight, hWhitePen )
         endif
      next
   endif

   if nRowStyle > 0
      nRow   := ::HeaderHeight() - 1
      nTemp2 := ::nDataRows
      do while nTemp2-- > 0
         nRow += nRowHeight
         if lRecSel
            MoveTo( hDC, 2, nRow )
            LineTo( hDC, RECORDSELECTOR_WIDTH - 4, nRow , hGrayPen )
            MoveTo( hDC, 2, nRow + 1 )
            LineTo( hDC, RECORDSELECTOR_WIDTH - 4, nRow + 1 , hWhitePen )
         endif
         for nFor := 1 to nLast
            nCol   := acols[ nFor ] - iif( nFor != 1, nTemp, 0 )
            nWidth := nCol + ::ColAtPos( nFor ):nWidth + iif( nFor != 1, nTemp, 0 )
            MoveTo( hDC, nCol, nRow )
            if nRowStyle != LINESTYLE_RAISED
               LineTo( hDC, nWidth, nRow, hRowPen )
            else
               LineTo( hDC, nWidth, nRow, hWhitePen )
               MoveTo( hDC, nCol, nRow - 1)
               LineTo( hDC, nWidth, nRow - 1, hColPen )
            endif
            if nRowStyle = LINESTYLE_INSET
               MoveTo( hDC, nCol, nRow - 1)
               LineTo( hDC, nWidth, nRow - 1, hWhitePen )
            endif
         next
         if nMarqStyle >= MARQSTYLE_HIGHLROWRC .and. nLast == Len( ::aDisplay )
            nCol   := acols[ nFor ] - nTemp
            nWidth := ::BrwWidth() - 4
            MoveTo( hDC, nCol, nRow )
            if nRowStyle != LINESTYLE_RAISED
               LineTo( hDC, nWidth, nRow, hRowPen )
            else
               LineTo( hDC, nWidth, nRow, hWhitePen )
               MoveTo( hDC, nCol, nRow - 1)
               LineTo( hDC, nWidth, nRow - 1, hColPen )
            endif
            if nRowStyle = LINESTYLE_INSET
               MoveTo( hDC, nCol, nRow - 1)
               LineTo( hDC, nWidth, nRow - 1, hWhitePen )
            endif
         endif
      enddo
   endif

   ::DispEnd( aInfo )

return 0

//----------------------------------------------------------------------------//

METHOD DrawLine( lSelected, nRowSel ) CLASS TXBrowse

   local oCol
   local nRow, nCol, nFor, nLast, nHeight, nStyle, nWidth,;
         nColStyle, nTemp, nDataHeight
   local hDC, hBrush, hWhitePen, hColPen
   local lHighLite

   DEFAULT lSelected := .f.,;
           nRowSel   := ::nRowSel

   if ::nlen == 0
      return nil
   endif

   nHeight     := ::nRowHeight
   nDataHeight := ::DataHeight
   nRow        := ( ( nRowSel - 1 ) * nHeight ) + ::HeaderHeight()

   if nRow > ::LastRow()
      return nil
   endif

   hDC       := ::GetDC()
   nLast     := ::LastDisplayPos()
   nStyle    := ::nMarqueeStyle
   lHighLite := ( nStyle >= MARQSTYLE_HIGHLROWRC .and. lSelected )

   if nStyle == MARQSTYLE_HIGHLROWMS
      lHighLite := ( Ascan( ::aSelected, Eval( ::bBookMark ) ) > 0 )
   endif

   for nFor := 1 to nLast
      oCol := ::ColAtPos ( nFor )
      oCol:PaintData( nRow, nil, nDataHeight, lHighLite, lSelected, nFor )
   next

   if nStyle >= MARQSTYLE_HIGHLROWRC
      nColStyle := ::nColDividerStyle
      nCol      := oCol:nDisplayCol + oCol:nWidth + 2
      nWidth    := ::BrwWidth() - 2
      if nColStyle < LINESTYLE_INSET
         nCol--
         nWidth++
      endif
      nTemp := nRow + nDataHeight
      if nCol < nWidth
         if lHighLite
            if ::hWnd == GetFocus()
               hBrush := CreateSolidBrush( Eval( If( ::bClrRowFocus == nil, ::bClrSelFocus, ::bClrRowFocus ) )[ 2 ] )
            else
               hBrush := CreateSolidBrush( Eval( ::bClrSel )[ 2 ] )
            endif
         else
            hBrush := CreateSolidBrush( Eval( ::bClrStd )[ 2 ] )
         endif
         if lHighLite .or. ! ( ::lTransparent == .t. )
            FillRect( hDC, {nRow, nCol, nTemp, nWidth }, hBrush )
         endif
         DeleteObject( hBrush )
      endif
      if nStyle == MARQSTYLE_HIGHLROWMS
         nCol := iif(::lRecordSelector, RECORDSELECTOR_WIDTH - 1, 0 )
         if lSelected
            FrameDot(hDC, nRow, nCol, nRow + nDataHeight - 1, nWidth - 1)
         elseif nColStyle > 0 // We have to repaint the line cols :-((
            hColPen   := ::hColPen
            hWhitePen := ::hWhitePen
            for nFor := 1 to nLast
               oCol := ::ColAtPos ( nFor )
               nCol := oCol:nDisplayCol + oCol:nWidth
               MoveTo( hDC, nCol, nRow )
               if nColStyle != LINESTYLE_RAISED
                  LineTo( hDC, nCol, nRow + nDataHeight , hColPen )
               else
                  LineTo( hDC, nCol, nHeight, hWhitePen )
                  MoveTo( hDC, nCol + 1, nRow )
                  LineTo( hDC, nCol + 1, nRow + nDataHeight, hColPen )
               endif
               if nColStyle = LINESTYLE_INSET
                  MoveTo( hDC, nCol + 1, nRow)
                  LineTo( hDC, nCol + 1, nRow + nDataHeight, hWhitePen )
               endif
            next
         endif
      endif
   endif

   if ::lRecordSelector
      if lSelected
         PalBmpDraw( hDC, nRow + ( nHeight / 2 ) - 8, RECORDSELECTOR_WIDTH - 15,;
                     ::hBmpRecSel, 0, 9, 14,, .t., ::nRecSelColor )
      else
         FillRect( hDC,;
                   {nRow + 1,;
                    RECORDSELECTOR_WIDTH - 15,;
                    nRow + nDataHeight - 1 ,;
                    RECORDSELECTOR_WIDTH - 3},;
                   ::hBrushRecSel )
      endif

   endif

   if lSelected
      nHeight -= 2
      oCol := ::ColAtPos( ::nColSel )
      do case
      case nStyle == MARQSTYLE_DOTEDCELL
         oCol:Box( nRow, nil, nDataHeight, 1 )
      case nStyle == MARQSTYLE_SOLIDCELL
         oCol:Box( nRow, nil, nDataHeight, 2 )
      case nStyle == MARQSTYLE_HIGHLCELL
         oCol:PaintData( nRow, nil, nDataHeight, .t., .t. , ::nColSel )
      case nStyle == MARQSTYLE_HIGHLROWRC
         oCol:Box( nRow, nil, nDataHeight, 3 )
      endcase
   endif

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD EraseData( nRow ) CLASS TXBrowse

   local oCol
   local nLast, nFor, nHeight, nCol
   local hDC

   hDC     := ::GetDC()
   nHeight := ::BrwHeight() - ::FooterHeight() - nRow

   if !::lColDividerComplete
      nCol := 0
      if ::lRecordSelector
         nCol += RECORDSELECTOR_WIDTH
      endif
      FillRect( hDC, {nRow, nCol, nRow + nHeight, ::BrwWidth()}, ::oBrush:hBrush )
   else
      nLast   := ::LastDisplayPos()

      for nFor := 1 to nLast
         oCol := ::ColAtPos( nFor )
         oCol:EraseData( nRow, , nHeight, ::oBrush:hBrush, .t. )
      next
      if ::nMarqueeStyle > MARQSTYLE_HIGHLCELL .and. nLast == Len( ::aDisplay )
         nCol := oCol:nDisplayCol + oCol:nWidth + 1
         FillRect( hDC, {nRow, nCol, nRow + nHeight, ::BrwWidth()}, ::oBrush:hBrush )
      endif
   endif

   if ::lRecordSelector .and. ::nRowDividerStyle > LINESTYLE_NOLINES
      FillRect( hDC, {nRow, 2, nRow + nHeight, RECORDSELECTOR_WIDTH - 3}, ::hBrushRecSel )
   endif

   ::ReleaseDC()

return nil

//---------------------------------------------------------------------------//
METHOD oCol( cHeader ) CLASS TXBrowse

   if valtype( cHeader ) == 'C'
      cHeader    := AllTrim( Upper( cHeader ) )
      cHeader    := ASCAN( ::aCols, {|oCol| upper( oCol:cHeader ) == cHeader } )
   endif

   if cHeader > 0 .and. cHeader <= Len( ::aCols )
      return ::aCols[cHeader]
   endif

return nil
//----------------------------------------------------------------------------//

METHOD GetDisplayCols() CLASS TXBrowse

   local oCol
   local aDisplay
   local nFor, nLen, nOffset, nFreeze, nCol, nCols

   nFreeze  := ::nFreeze
   nOffset  := ::nColOffset + nFreeze
   nLen     := Len( ::aCols )
   aDisplay := {}

   for nFor := 1 to nlen
      oCol := ::aCols[ nFor ]
      oCol:nPos := 0
      if oCol:oBtnList != nil
         oCol:oBtnList:Hide()
      endif
      if oCol:oBtnElip != nil
         oCol:oBtnElip:Hide()
      endif
   next

   nCol := 1

   do while nFreeze > 0 .and. nCol <= nLen
      oCol := ::aCols[ nCol ]
      if !oCol:lHide
         Aadd( aDisplay, nCol )
         oCol:nPos := Len( aDisplay )
         nFreeze--
      endif
      nCol++
   enddo

   nCol := Max( nCol, nOffset )

   do while nCol <= nLen
      oCol := ::aCols[ nCol ]
      if !oCol:lHide
         Aadd( aDisplay, nCol )
         oCol:nPos := Len( aDisplay )
      endif
      nCol++
   enddo

   ::aDisplay := aDisplay
   ::nColSel  := Min( Len( ::aDisplay ), ::nColSel )

   if ::oHScroll != nil
      nCols := 0
      for nFor := 1 to nlen
         oCol := ::aCols[ nFor ]
         if !oCol:lHide
            nCols++
         endif
      next
      ::oHScroll:SetRange( 1, Max( nCols, 2 ) )
   endif

return aDisplay

//---------------------------------------------------------------------------//

METHOD GetVisibleCols() CLASS TXBrowse

   local oCol
   local aVisible
   local nFor, nLen, nCol

   aVisible := {}
   nLen     := Len( ::aCols )

   For nCol := 1 to nLen
      oCol := ::aCols[ nCol ]
      if !oCol:lHide
         Aadd( aVisible, oCol )
      endif
   Next

return aVisible

//---------------------------------------------------------------------------//

METHOD GetDisplayColsWidth( aSizes ) CLASS TXBrowse

   local nWidth, nPos, nLen

   aSizes := {}
   nPos   := 1
   nLen   := Len( ::aDisplay )

   if ::lRecordSelector
      nWidth := RECORDSELECTOR_WIDTH
   else
      nWidth := 0
   endif

   for nPos := 1 to nLen
      nWidth += ::ColAtPos( nPos ):nWidth + COL_SEPARATOR
      Aadd(aSizes, ::ColAtPos( nPos ):nWidth )
   next

return nWidth

//---------------------------------------------------------------------------//

METHOD IsDisplayPosVisible( nPos, lComplete ) CLASS TXBrowse

   local nWidth, nFor

   DEFAULT lComplete := .f.

   if nPos < 1 .or. nPos > Len( ::aDisplay )
      return .f.
   endif

   if ::lRecordSelector
      nWidth := RECORDSELECTOR_WIDTH
   else
      nWidth := 0
   endif

   for nFor := 1 to nPos - 1
      nWidth += ::ColAtPos( nFor ):nWidth + COL_SEPARATOR
   next

   if lcomplete
      nWidth += ::ColAtPos( nPos ):nWidth + COL_SEPARATOR

//    2008-03-30
//      if nWidth > ::BrwWidth() && By Rossine - Reajusta a largura da coluna
//         ::ColAtPos( nPos ):nWidth -= ( nWidth - ::BrwWidth() + COL_SEPARATOR )
//      endif

   endif

return ( nWidth  < ::BrwWidth() )

//---------------------------------------------------------------------------//

METHOD LastDisplayPos( lComplete ) CLASS TXBrowse

   local nWidth, nMaxWidth, nPos, nLen

   DEFAULT lComplete := .f.

   nPos      := 1
   nMaxWidth := ::BrwWidth()
   nLen      := Len( ::aDisplay )

   if ::lRecordSelector
      nWidth := RECORDSELECTOR_WIDTH
   else
      nWidth := 0
   endif

   do while nPos <= nLen .and. nWidth < nMaxWidth
      nWidth += ::ColAtPos( nPos++ ):nWidth + COL_SEPARATOR
   enddo

   nPos --

//   if lComplete
   if lComplete .and. nWidth >= nMaxwidth     // 2008-03-30
      nPos--
   endif

   nPos := Max( 1, nPos )

return nPos

//---------------------------------------------------------------------------//

METHOD ColStretch( nStretchCol ) CLASS TXBrowse

   local n, nLen, nWidth, oCol, nBrwWidth, nOffSet
   local nMaxWidth := 0

   DEFAULT nStretchCol := ::nStretchCol

   if ::uStretchInfo != nil
      for n := 1 to Len( ::aCols )
         if ::aCols[ n ]:nCreationOrder == ::uStretchInfo[ 1 ]
            ::aCols[ n ]:nWidth  := ::uStretchInfo[ 2 ]
            exit
         endif
      next
      ::uStretchInfo := nil
   endif


   if nStretchCol != STRETCHCOL_NONE

      nWidth   := If( ::lRecordSelector, RECORDSELECTOR_WIDTH, 0 )
      nLen     := Len( ::aCols )
      nOffSet  := ::nFreeze + ::nColOffSet

      for n := 1 to nLen
         if ! ::aCols[ n ]:lHide
            if ! ( n > ::nFreeze .and. n < nOffSet )
               nWidth   += ::aCols[ n ]:nWidth + COL_SEPARATOR
               if ::nStretchCol == STRETCHCOL_LAST
                  nStretchCol := n
               elseif ::nStretchCol == STRETCHCOL_WIDEST
                  if ::aCols[ n ]:cDataType == "C" .and. ::aCols[ n ]:nWidth >= nMaxWidth
                     nstretchcol := n
                     nMaxwidth   := ::aCols[ n ]:nWidth
                  endif
               endif
               if ::aCols[ n ]:nCreationOrder == nStretchCol
                  oCol     := ::aCols[ n ]
               endif
            endif
         endif
      next

      if oCol != nil
         ::uStretchInfo := { oCol:nCreationOrder, oCol:nWidth }
         nBrwWidth   := ::BrwWidth()
         if nWidth < nBrwWidth
            oCol:nWidth += ( nBrwWidth - nWidth - 1 )
         elseif nWidth > nBrwWidth
            oCol:nWidth    := oCol:nwidth - ( nwidth - nBrwWidth - 1 )
            oCol:nWidth    := Max( oCol:nWidth, Max( oCol:DataWidth(), Max( oCol:HeaderWidth(), oCol:FooterWidth() ) ) )
         endif

         ::GetDisplayCols()

      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TXBrowse

   do case
   case nKey == VK_UP .and. GetKeyState( VK_SHIFT )
        ::Select( 5 )
        ::GoUp()
        ::Select( 5 )

   case nKey == VK_DOWN .and. GetKeyState( VK_SHIFT )
        ::Select( 5 )
        ::GoDown()
        ::Select( 5 )

   case nKey == VK_UP
      ::Select( 0 )
      ::GoUp()
      ::Select( 1 )

   case nKey == VK_DOWN
      ::Select( 0 )
      ::GoDown()
      ::Select( 1 )

   case nKey == VK_LEFT
      if GetKeyState( VK_CONTROL )
         ::GoLeftMost()
      else
         ::GoLeft()
      endif

   case nKey == VK_RIGHT
      if GetKeyState( VK_CONTROL )
         ::GoRightMost()
      else
         ::GoRight()
      endif

   case nKey == VK_HOME
         ::Select( 0 )
         ::GoTop()
         ::Select( 1 )

   case nKey == VK_END
         ::Select( 0 )
         ::GoBottom()
         ::Select( 1 )

   case nKey == VK_PRIOR
         ::Select( 0 )
         if GetKeyState( VK_CONTROL )
            ::GoTop()
         else
            ::PageUp()
         endif
         ::Select( 1 )

   case nKey == VK_NEXT
         ::Select( 0 )
         if GetKeyState( VK_CONTROL )
            ::GoBottom()
         else
            ::PageDown()
         endif
         ::Select( 1 )

   case ::lAllowCopy .and. nKey == ASC( "C" ) .and. GetKeyState( VK_CONTROL )
         ::Copy()

   case nKey == VK_LEFT  .and. GetKeyState( VK_SHIFT ) .or. nKey == VK_RIGHT .and. GetKeyState( VK_SHIFT )
         return Super:KeyDown( nKey, nFlags )

   otherwise
         return Super:KeyDown( nKey, nFlags )

   endcase

return 0

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TXBrowse

   local oCol, cKey

   if ::bKeyChar != nil
      Eval( ::bKeyChar, nKey, nFlags )
   endif

   do case
      case nKey == VK_ESCAPE
           if Upper( ::oWnd:ClassName() ) == "TDIALOG" .and. ! ::lEditMode
              // PostMessage( ::oWnd:hWnd, WM_KEYDOWN, VK_ESCAPE )
           else
              // Avoid exiting on Mdichild windows
           endif
           if ::lEditMode
              oCol := ::SelectedCol()
              if oCol:oEditLbx != nil
                 oCol:oEditLbx:nLastKey = VK_ESCAPE
              endif
              ::CancelEdit()
           endif

      case nKey == VK_RETURN
         oCol := ::SelectedCol()
         if oCol:nEditType > 0
            if oCol:oEditGet == nil
               if oCol:bEditWhen == nil .or. Eval( oCol:bEditWhen, oCol )
                  return oCol:Edit()
               endif
            else
               PostMessage( oCol:oEditGet:hWnd, WM_KEYDOWN, nKey )   //VK_RETURN )
            endif
         endif

      case nKey == K_PGUP
         ::oVScroll:PageUp()

      case nKey == K_PGDN
         ::oVScroll:PageDown()

      otherwise
         cKey := Chr( nKey )
         oCol := ::SelectedCol()
         if nKey == 32 .and. ::nMarqueeStyle <= MARQSTYLE_HIGHLCELL .and. ;
                     oCol:hChecked .and. oCol:bOnPostEdit != nil .and. ;
                     ( oCol:bEditWhen == nil .or. Eval( oCol:bEditWhen, oCol ) )

            Eval( oCol:bOnPostEdit, oCol, ! Eval( oCol:bEditValue ), 13 )
            ::DrawLine( .t. )

         elseif ::lFastEdit .and. ::nMarqueeStyle <= MARQSTYLE_HIGHLCELL .and. ;
            oCol:nEditType > 0 .and. oCol:IsEditKey( cKey ) .and. ;
            ( oCol:bEditWhen == nil .or. Eval( oCol:bEditWhen, oCol ) )

            oCol:Edit( nKey )

         else
            If nKey == VK_BACK .and. !Empty( ::cSeek )
               ::Seek( Left( ::cSeek, Len( ::cSeek ) -1 ) )
            elseIf nKey > 31
               ::Seek( ::cSeek + cKey )
            Endif
         Endif
   endcase

return 0

//---------------------------------------------------------------------------//

METHOD HScroll( nWParam, nLParam ) CLASS TXBrowse

   local nScrHandle  := nLParam
   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   do case
   case nScrollCode == SB_LINEUP
      ::GoLeft()

   case nScrollCode == SB_LINEDOWN
      ::GoRight()

   case nScrollCode == SB_PAGEUP
      ::GoLeft( .t. )

   case nScrollCode == SB_PAGEDOWN
      ::GoRight( .t. )

   case nScrollCode == SB_TOP
      ::GoLeftMost()

   case nScrollCode == SB_BOTTOM
      ::GoRigthMost()

   case nScrollCode == SB_THUMBPOSITION
      ::SelectCol( nPos, .t. )

   otherwise
      return nil

   endcase

return 0

//----------------------------------------------------------------------------//

METHOD SelectCol( nCol, lOffset ) CLASS TXBrowse

   DEFAULT lOffset := .f.

   if ::nMarqueeStyle == MARQSTYLE_NOMARQUEE .or. ( ::nMarqueeStyle >= MARQSTYLE_HIGHLROW .and. ::bClrRowFocus == nil )
      lOffset := .t.
   endif

   ::CancelEdit()
   ::oHScroll:SetPos( nCol )

   If lOffset
      ::nColOffset := Max( nCol - ::nFreeze, 1 )
   else
      ::nColSel    := nCol
   Endif

   ::GetDisplayCols()
   ::nColSel := Min( ::nColSel, ::LastDisplayPos() )
   ::Super:Refresh( .t. )

return nil

//----------------------------------------------------------------------------//

METHOD GoLeft( lOffset, lRefresh )  CLASS TXBrowse

   ::CancelEdit()

   if ::nMarqueeStyle == MARQSTYLE_NOMARQUEE  .or. ( ::nMarqueeStyle >= MARQSTYLE_HIGHLROW .and. ::bClrRowFocus == nil )
      lOffset := .t.
   endif

   DEFAULT lOffset  := .f.,;
           lRefresh := .t.

   if ( !lOffset .and. ::IsDisplayPosVisible( ::nColSel - 1 ) ) .or. ;
      ( ::nColOffset == 1 .and. ::nColSel > 1 )
      ::nColSel--
      if lRefresh
         ::DrawLine( .t. )
      endif
   elseif ::nColOffset > 1
      ::nColOffset--
      ::GetDisplayCols()
      if lRefresh
         ::Super:Refresh( .f. )
      endif
   endif

   if ::lTransparent == .t.
      ::Paint()
   endif

   if ::oHScroll != nil
      ::oHScroll:GoUp()
   endif

return nil

//---------------------------------------------------------------------------//

METHOD GoRight( lOffset, lRefresh ) CLASS TXBrowse

   local oCol, oLastCol, oNextCol
   local nLen

   ::CancelEdit()


   oLastcol    := ::aCols[ ATail( ::aDisplay ) ]
   if ::SelectedCol():nCreationOrder == oLastCol:nCreationOrder
      return nil
   endif

   if ::nMarqueeStyle == MARQSTYLE_NOMARQUEE .or. ( ::nMarqueeStyle >= MARQSTYLE_HIGHLROW .and. ::bClrRowFocus == nil )
      lOffset := .t.
   endif

   DEFAULT lOffset  := .f.,;
           lRefresh := .t.

   nLen := len( ::aDisplay )

   if lOffSet
      if ::IsDisplayPosVisible( oLastCol:nPos, .t. )
         ::nColSel++
         if lRefresh
            ::Super:Refresh( .t. )
         endif

      else
         if ::nColOffSet < ( nLen - ::nFreeze )
            ::nColOffSet++
            ::GetDisplayCols()
            if lRefresh
               ::Super:Refresh( .f. )
            endif
         endif
      endif

   else

      ::nColSel++
      ::GetDisplayCols()
      oCol     := ::SelectedCol()
      do while ! ::IsDisplayPosVisible( oCol:nPos, .t. ) .and. ::nColSel > ( ::nFreeze + 1 )
         ::nColOffSet++
         ::nColSel--
         ::GetDisplayCols()
      enddo

      if lRefresh
         ::Super:Refresh( .f. )
      endif

   endif

   if ::lHScroll
      ::oHScroll:GoDown()
   endif


return nil

//----------------------------------------------------------------------------//

METHOD GoLeftMost()  CLASS TXBrowse

   ::CancelEdit()

   ::nColSel := 1
   ::nColOffset := 1
   ::GetDisplayCols()
   ::Super:Refresh( .f. )

   if ::lTransparent == .t.
      ::Paint()
   endif

   if ::oHScroll != nil
      ::oHScroll:SetPos( 1 )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoRightMost()  CLASS TXBrowse

   local oLast, nLast

   ::CancelEdit()

   nLast    := ATail( ::aDisplay )
   oLast    := ::aCols[ nLast ]



   do while ! ::IsDisplayPosvisible( oLast:nPos, .t. ) .and. ( ::nFreeze + ::nColOffSet ) < Len( ::aDisplay )
      ::nColOffSet++
      ::GetDisplayCols()
   enddo
   ::nColSel   := ::aCols[ nLast ]:nPos
   ::Super:Refresh( .f. )

   if ::lTransparent == .t.
      ::Paint()
   endif

   if ::oHScroll != nil
      ::oHScroll:SetPos( ::oHScroll:nMax )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD VScroll( nWParam, nLParam ) CLASS TXBrowse

   local nScrHandle  := nLParam
   local nScrollCode := nLoWord( nWParam )
   local nPos        := nHiWord( nWParam )
   local nRow, nBook

   if GetFocus() != ::hWnd
      SetFocus( ::hWnd )
   endif

   if nScrHandle == 0 .and. ::oVScroll != nil
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
         if ::nLen < 1
            return nil
         endif
         do case
         case nPos == 1
            ::GoTop()
         case nPos == ::oVScroll:GetRange()[ 2 ]
            ::GoBottom()
         otherwise
            ::CancelEdit()
            nRow := ::nRowSel
            CursorWait()
            //Eval( ::bSkip, ::VGetThumbPos( nPos ) - ::VGetPos() )
            Eval( ::bKeyNo, ::VGetThumbPos( nPos ), Self )
            CursorArrow()
            nBook := Eval( ::bBookMark )
            do while nRow > 0 .and. Eval( ::bSkip, -1 ) == -1
               nRow--
            enddo
            ::nRowSel := ::nRowSel - nRow
            Eval( ::bBookMark, nBook )
            if ::bChange != nil
               Eval( ::bChange, Self, .t. )
            endif
            ::VThumbPos( nPos )
            ::lRefreshOnlyData := .f.
            ::Super:Refresh( .f. )
         endcase

      otherwise
         return nil
      endcase
   endif

return 0

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TXBrowse

   local nHeight

   if ::nLen == 0 .or. Eval( ::bBof )
      return nil
   endif

   ::CancelEdit()
   ::DrawLine()
   ::Seek()

   if Eval( ::bSkip, -1 ) == -1
      if ::nRowSel > 1
         ::nRowSel--
      else
         if ! ( ::lTransparent == .t. )
            XBrwScrollRow( ::hWnd, -::nRowHeight, ::HeaderHeight(), ::RowCount() * ::nRowHeight )
         endif
         nHeight := ::BrwHeight() - ::FooterHeight() - ::HeaderHeight()
         If nHeight % ::nRowHeight > 0
            // ::EraseData( ( ( Int(nHeight/::nRowHeight) + 1 ) * ::nRowHeight ) + 10 )
            ::EraseData( ::HeaderHeight() + ::nRowHeight * ::RowCount() )
         Endif
         If ::nDataRows < ::RowCount()
            ::nDataRows++
         Endif
      endif
   endif

   if ::bChange != nil
      Eval( ::bChange, Self, .t. )
   endif

   if ::lTransparent == .t.
      ::Paint()
   else
      ::DrawLine( .t. )
   endif

   if ::oVScroll != nil
      ::VGoUp()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TXBrowse

   local nLines

   if ::nLen == 0 .or. Eval( ::bEof )
      if ::bPastEof != nil
         Eval( ::bPastEof )
      endif
      return nil
   endif

   ::CancelEdit()
   ::Seek()

   nLines := ::RowCount()

   if ::lTransparent != .t.
      ::DrawLine()
   endif

   if Eval( ::bSkip, 1 ) == 1
      if ::nRowSel < nLines
         ::nRowSel++
      else
         if ! ( ::lTransparent == .t. )
            XBrwScrollRow( ::hWnd, ::nRowHeight, ::HeaderHeight(), nLines * ::nRowHeight )
         endif

      endif
      if ::bChange != nil
         Eval( ::bChange, Self, .t. )
      endif
      if ::oVScroll != nil
         ::VGoDown()
      endif
   else
      if ::bPastEof != nil
         Eval( ::bPastEof )
      endif
      if ::oVScroll != nil
         ::VGoBottom()
      endif
   endif

//  ::DrawLine( .t. )

   if ::lTransparent == .t.
      ::Paint()
   else
      ::DrawLine( .t. )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageUp( nLines ) CLASS TXBrowse

   local nSkipped

   if ::nLen < 1
      return nil
   endif

   DEFAULT nLines := ::RowCount()

   ::CancelEdit()
   ::Seek()
   ::DrawLine()

   nSkipped = Eval( ::bSkip, -nLines )

   if nSkipped = 0
      ::DrawLine(.t.)
      return nil
   endif

   if -nSkipped < nLines
      ::nRowSel = 1
      if ::bChange != nil
         Eval( ::bChange, Self, .t. )
      endif
      // ::lRefreshOnlyData := .t.
      ::Super:Refresh( .f. )
      if ::oVScroll != nil
         ::VGoTop()
      endif
   else
      if Eval( ::bkeyno,, Self ) < ::nRowSel
         Eval( ::bKeyNo, ::nRowSel, Self )
      endif
      if ::bChange != nil
         Eval( ::bChange, Self, .t. )
      endif
      // ::lRefreshOnlyData := .t.
      ::Super:Refresh( .f. )

      if ::lTransparent == .t.
         ::Paint()
      endif

      if ::oVScroll != nil
         ::VSetPos( ::VGetPos() + nSkipped )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PageDown( nLines ) CLASS TXBrowse

   local nSkipped, nBook1, nBook2, nRow

   if ::nLen < 1
      return nil
   endif

   DEFAULT nLines := ::RowCount()

   ::CancelEdit()
   ::Seek()

   nBook1 := Eval( ::bBookMark )

   nSkipped = Eval( ::bSkip, nLines )

   if nSkipped < nLines .and. nSkipped <= ( ::nDataRows - ::nRowSel )
      nBook2 := Eval( ::bBookMark )
      Eval( ::bBookMark, nBook1 )
      ::DrawLine()
      Eval( ::bBookMark, nBook2 )
      ::nRowSel = ::nDataRows
      if ::bChange != nil
         Eval( ::bChange, Self, .t. )
      endif
      if ::lTransparent == .t.
         ::Paint()
      else
         ::DrawLine( .t. )
      endif
      nRow := ( ( ::nRowSel) * ::nRowHeight ) + ::HeaderHeight()
      ::EraseData( nRow )
      if ::oVScroll != nil
         ::VGoBottom()
      endif
      return nil
   endif

   if ::bChange != nil
      Eval( ::bChange, Self, .t. )
   endif

   // ::lRefreshOnlyData := .t.
   ::Super:Refresh( .f. )

   if ::oVScroll != nil
      ::VSetPos( ::VGetPos() + nSkipped )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TXBrowse

   if Eval( ::bBof ) .or. ::nLen < 1
      return nil
   endif

   ::CancelEdit()
   ::Seek()

   ::DrawLine()

   Eval( ::bGoTop )

   if ::oVScroll != nil
      ::VGoTop()
   endif

   ::nRowSel := 1

   if ::bChange != nil
      Eval( ::bChange, Self, .t. )
   endif

//   ::lRefreshOnlyData := .t.
   ::Super:Refresh( .f. )

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom( lNoRefresh ) CLASS TXBrowse

   local nLines, nRow, nBook

   DEFAULT lNoRefresh := .f.

   ::CancelEdit()
   ::Seek()
   ::DrawLine()

   if Eval( ::bEof ) .or. ::nLen < 1
      ::DrawLine( .t. )
      return nil
   endif

   nLines := ::RowCount()
   nRow   := nLines

   Eval( ::bGoBottom )

   nBook := Eval( ::bBookMark )

   do while nRow-- > 0 .and. Eval( ::bSkip, -1 ) == -1
   enddo

   ::nRowSel := nLines - nRow

   Eval( ::bBookMark, nBook )

   if ::oVScroll != nil
      ::VGoBottom()
   endif

   if ::bChange != nil
      Eval( ::bChange, Self, .t. )
   endif

   If lNoRefresh
      ::KeyCount()
      ::lRefreshOnlyData := .t.
      ::Paint()
   else
      ::Super:Refresh( .f. )
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD ColPos( oCol )  CLASS TXBrowse

   local nAt

   nAt := Ascan( ::aDisplay, {|v| ::ColAtPos( v ):nCreationOrder == oCol:nCreationOrder } )

return nAt

//----------------------------------------------------------------------------//

METHOD MouseAtHeader( nRow, nCol ) CLASS TXBrowse

return ( ::MouseColPos( nCol ) > 0 .and. nRow < ::HeaderHeight() )

//----------------------------------------------------------------------------//

METHOD MouseAtFooter( nRow, nCol ) CLASS TXBrowse

return ( ::MouseColPos( nCol ) > 0 .and. nRow > ( ::BrwHeight() - ::FooterHeight() ) )

//----------------------------------------------------------------------------//

METHOD MouseRowPos( nRow ) CLASS TXBrowse

   local nRowPos, nTmp

   if nRow <= ::HeaderHeight()
      return 0
   endif

   nTmp    := nRow - ::HeaderHeight()
   nRowPos := Int( nTmp / ::nRowHeight ) + 1

   if nRowPos > ::nDataRows
      nRowPos := 0
   endif

return nRowPos

//----------------------------------------------------------------------------//

METHOD MouseColPos( nCol ) CLASS TXBrowse

   local nWidth, nColPos, nLen, nFor

   nColPos   := 0
   nLen      := ::LastDisplayPos()

   if ::lRecordSelector
      nWidth := RECORDSELECTOR_WIDTH
   else
      nWidth := 0
   endif

   if nCol < nWidth
      return -1
   endif

   if nCol > nWidth
      for nFor := 1 to nLen
         nWidth += ::ColAtPos( nFor ):nWidth + COL_SEPARATOR
         if ( nWidth - COL_SEPARATOR ) > nCol
            nColPos := nFor
            exit
         endif
      next
   endif

return nColPos

//----------------------------------------------------------------------------//

METHOD SetPos( nRow, nCol, lPixel ) CLASS TXBrowse

   local lRepos   := .f.
   local bm, nSkip := 0

   DEFAULT lPixel := .f.

   if nRow == nil
      nRow        := ::nRowSel
   elseif lPixel
      nRow        := ::MouseRowPos( nRow )
   endif
   if nCol == nil
      nCol        := ::nSelCol
   elseif lPixel
      ncol        := ::MouseColPos( nRow )
   endif

   if nCol > 0 .and. nCol <= ::LastDisplayPos( .f. ) .and. ;
      nRow > 0 .and. nRow <= ::RowCount()

      if ::nColSel != nCol
         ::nColSel  := nCol
         lRepos      := .t.
      endif

      if nRow > 0 .and. nRow != ::nRowSel

         ::CancelEdit()
         ::Seek()

         if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
            ::Select(0)
         endif
         SysRefresh()
         ::DrawLine()

         bm          := Eval( ::bBookMark )
         nSkip     := nRow - ::nRowSel
         if Eval( ::bSkip, nSkip ) == nSkip
            ::nRowSel := nRow
            if ::bChange != nil
               Eval( ::bChange, Self, .t. )
            endif
            lRepos      := .t.
         else
            Eval( ::bBookMark, bm )
            nSkip := 0
         endif

         if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
            ::Select(1)
         endif

         if ::lTransparent == .t.
            ::Paint()
         else
            ::DrawLine( .t. )
         endif

         if ::bChange != nil
            Eval( ::bChange, Self, .t. )
         endif

      endif

      if nSkip != 0 .and. ::oVScroll != nil
         ::VSetPos( Eval( ::bKeyNo,,Self ) )
      endif

   endif

return lRepos

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TXBrowse

   local oCol
   local nRowPos, nColPos, nLen, nFor, nTmp, nPos
   local nOldCol := ::nColSel

   ::CancelEdit()
   ::Seek()

   ::SetFocus()

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   endif

   nRowPos   := 0
   nColPos   := 0
   nLen      := ::LastDisplayPos()

   for nFor := 1 to nLen
      oCol := ::ColAtPos( nFor )
      if oCol:lAllowSizing .and. ;
         nCol >= ( oCol:nDisplayCol + oCol:nWidth - 1 ) .and. ;
         nCol <= ( oCol:nDisplayCol + oCol:nWidth + 1 ) .and. ;
         ( ::nColDividerStyle > 0 .or. nRow < ::HeaderHeight() )
         oCol:ResizeBeg( nRow, nCol, nFlags )
         return nil
      endif
   next

   nLen := ::nDataRows

   if ::lAllowRowSizing .and. ::nRowDividerStyle > 0 .and. ;
      ( ::MouseColPos( nCol ) > 0 .or. ::nMarqueeStyle >= MARQSTYLE_HIGHLROWRC )
      for nFor := 1 to nLen
         nPos := ( nFor * ::nRowHeight ) + ::HeaderHeight()
         if nRow >= ( nPos - 1 ) .and. nRow <= ( nPos + 1 )
            ::HorzLine( nRow, 1, nFor )
            return 0
         endif
      next
   endif

   nColPos := ::MouseColPos( nCol )

   if nColPos == 0 .and. ::nMarqueeStyle < MARQSTYLE_HIGHLROWRC
      Super:LButtonDown( nRow, nCol, nFlags )
      return nil
   endif

   if nRow < ::HeaderHeight() .and. nColPos > 0
      oCol := ::ColAtPos( nColPos )
      if oCol != nil
         oCol:HeaderLButtonDown( nRow, nCol, nFlags )
      else
         Super:LButtonDown( nRow, nCol, nFlags )
      endif
      return nil
   elseif nRow > ( ::BrwHeight() - ::FooterHeight() ) .and. nColPos > 0
      oCol := ::ColAtPos( nColPos )
      if oCol != nil
         oCol:FooterLButtonDown( nRow, nCol, nFlags )
      else
         Super:LButtonDown( nRow, nCol, nFlags )
      endif
      return nil
   else
      nTmp    := nRow - ::HeaderHeight()
      nRowPos := Int( nTmp / ::nRowHeight ) + 1
      if nRowPos > ::nDataRows .or. nRow < ::HeaderHeight()
         nRowPos := 0
      endif
      if nRowPos == 0
         Super:LButtonDown( nRow, nCol, nFlags )
         return nil
      endif
   endif

   if nRowPos > 0 .or. nColPos > 0


      if ::nMarqueeStyle == MARQSTYLE_HIGHLCELL
         if GetKeyState( VK_SHIFT )
            ::nMarqueeStyle := MARQSTYLE_HIGHLROWMS
            ::aSelected := { Eval( ::bBookMark ) }
            ::nSaveMarq := MARQSTYLE_HIGHLCELL
         endif
      endif

      if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
         if !GetKeyState( VK_CONTROL ) .and. !GetKeyState( VK_SHIFT )
            ::Select( 0 )
         endif
      endif

      SysRefresh()
      ::DrawLine()

      if nRowPos > 0
         Eval( ::bSkip, nRowPos - ::nRowSel )
         ::nRowSel := nRowPos
         if ::bChange != nil
            Eval( ::bChange, Self, .t. )
         endif
      endif

      if nColPos > 0
         ::nColSel := nColPos
      endif

      if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
         do case
         case GetKeyState( VK_CONTROL )
            ::Select( 2 )
         case GetKeyState( VK_SHIFT )
             ::Select( 3 )
         otherwise
            ::Select( 1 )
         endcase
      endif

      if ::lTransparent == .t.
         ::Paint()
      else
         ::DrawLine( .t. )
      endif

      if ::bChange != nil
        Eval( ::bChange, Self, .t. )
      endif

      if ::oVScroll != nil
         ::VSetPos( Eval( ::bKeyNo,,Self ) )
      endif

   endif

   if ::MouseRowPos( nRow ) != 0 .and. ::MouseColPos( nCol ) != 0
      Super:LButtonDown( nRow, nCol, nFlags )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TXBrowse

   local nCaptured

   if ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::nCaptured > 0
      nCaptured   := ::nCaptured
      ::nCaptured := 0
      ReleaseCapture()
      do case
         case nCaptured == 1
              ::oCapCol:HeaderLButtonUp( nRow, nCol, nFlags )

         case nCaptured == 2
              ::oCapCol:FooterLButtonUp( nRow, nCol, nFlags )

         case nCaptured == 3
              ::oCapCol:ResizeEnd( nRow, nCol, nFlags )

         case nCaptured == 4
              ::HorzLine( nRow, 2 )
      endcase
      ::oCapCol := nil
   endif

   Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nLen, nFor, nPos

   if ::lDrag .or. ::lEditMode
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

   if ::oCapCol != nil
      ::oCapCol:MouseMove( nRow, nCol, nKeyFlags )
      return 0
   endif

   if ::nCaptured == 4
      ::HorzLine( nRow, 3 )
      return 0
   endif

   nLen := ::LastDisplayPos()

   for nFor := 1 to nLen
      oCol := ::ColAtPos( nFor )
      if oCol:lAllowSizing .and. ;
         nCol >= ( oCol:nDisplayCol + oCol:nWidth - 1 ) .and. ;
         nCol <= ( oCol:nDisplayCol + oCol:nWidth + 1 ) .and. ;
         ( ::nColDividerStyle > 0 .or. nRow < ::HeaderHeight() )
         CursorWE()
         return 0
      endif
   next

   nLen := ::nDataRows

   if ::lAllowRowSizing .and. ::nRowDividerStyle > 0 .and. ;
      ( ::MouseColPos( nCol ) > 0 .or. ::nMarqueeStyle >= MARQSTYLE_HIGHLROWRC )
      for nFor := 1 to nLen
         nPos := ( nFor * ::nRowHeight ) + ::HeaderHeight()
         if nRow >= ( nPos - 1 ) .and. nRow <= ( nPos + 1 )
            CursorNS()
            return 0
         endif
      next
   endif

   Super:MouseMove( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nColPos, nRowPos

   /*
   ::CancelEdit()
   ::Seek()

   if ::MouseRowPos( nRow ) != 0 .and. ::MouseColPos( nCol ) != 0
      sysrefresh()
      ::DrawLine()
      Super:LButtonDown( nRow, nCol, nKeyFlags )
   endif
   */

   ::LButtonDown( nRow, nCol, nKeyFlags )

   // Añadido por mcs

   nColPos := ::MouseColPos( nCol )
   nRowPos := ::MouseRowPos( nRow )

   if nColPos == ::nColSel .and. nRowPos == ::nRowSel

      oCol := ::ColAtPos( nColPos )

      if oCol:nEditType > 0

         if ( oCol:bEditWhen == nil .or. Eval( oCol:bEditWhen, oCol ) )

            if oCol:hChecked .and. oCol:bOnPostEdit != nil
               Eval( oCol:bOnPostEdit, oCol, ! Eval( oCol:bEditValue ), 13 )
               ::DrawLine( .t. )
            else
               return oCol:Edit()
            endif

         endif

      elseif oCol:bLDClickData != nil

         return Eval( oCol:bLDClickData, nRow, nCol, nKeyFlags, oCol )

      endif

   /*
   else

      msginfo( nColPos == ::nColSel, "nColPos == ::nColSel" )
      msginfo( nRowPos == ::nRowSel, "nRowPos == ::nRowSel" )

      msginfo( nColPos, "nColPos" )
      msginfo( ::nColSel, "::nColSel" )
      msginfo( nRowPos, "nRowPos" )
      msginfo( ::nRowSel, "::nRowSel" )
   */
   endif

   If nColPos != 0 .and. nRowPos != 0
      return Super:LDblClick( nRow, nCol, nKeyFlags )
   Endif

return 0

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nColPos, nRowPos

   ::CancelEdit()
   ::Seek()

   nRowPos := ::MouseRowPos( nRow )
   nColPos := ::MouseColPos( nCol )

   if nColPos <= 0
      if nRow >= ::FirstRow()
         Super:RButtonDown( nRow, nCol, nKeyFlags )
         return nil
      else
         if ::lAllowColHiding
            ::SetColumns( nRow, nCol, nKeyFlags )
         endif
         return nil
      endif
   endif

   oCol := ::ColAtPos( nColPos )

   if ::MouseAtHeader( nRow, nCol )
      if oCol:bRClickHeader != nil
         return Eval( oCol:bRClickHeader, nRow, nCol, nKeyFlags, oCol )
      elseif ::lAllowColHiding
         return ::SetColumns( nRow, nCol, nKeyFlags )
      endif
   elseif ::MouseAtFooter( nRow, nCol )
      if oCol:bRClickFooter != nil
         return Eval( oCol:bRClickFooter, nRow, nCol, nKeyFlags, oCol )
      endif
   elseif ( ::nRowSel != nRowPos .and. nRowPos > 0 ) .or. ::nColSel != nColPos

      if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
         ::Select(0)
      endif

      SysRefresh()
      if !( ::lTransparent == .t. )
         ::DrawLine()
      endif
      if nRowPos > 0
         Eval( ::bSkip, nRowPos - ::nRowSel )
         ::nRowSel := nRowPos
         if ::bChange != nil
            Eval( ::bChange, Self, .t. )
         endif
      endif
      if nColPos > 0
         ::nColSel := nColPos
      endif
      if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
         ::Select(1)
      endif
      if ::lTransparent == .t.
         ::Paint()
      else
         ::DrawLine( .t. )
      endif
      if ::oVScroll != nil
         ::VSetPos( Eval( ::bKeyNo,,Self ) )
      endif
      if oCol:bPopUp != nil
         return Eval( oCol:bPopUp, oCol ):Activate( (::nRowSel * ::nRowHeight) + ::nHeaderHeight, oCol:nDisplayCol, Self )
      elseif oCol:bRClickData != nil
         return Eval( oCol:bRClickData, nRow , nCol, nKeyFlags, oCol )
      endif
   else
      if oCol:bPopUp != nil
         Eval( oCol:bPopUp, oCol ):Activate( (::nRowSel * ::nRowHeight) + ::nHeaderHeight, oCol:nDisplayCol, Self )
         return 0
      elseif oCol:bRClickData != nil
         return Eval( oCol:bRClickData, nRow, nCol, nKeyFlags, oCol )
      endif
   endif

   If nColPos != 0 .and. nRowPos != 0
      return Super:RButtonDown( nRow, nCol, nKeyFlags )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TXBrowse

   if lAnd( nKeys, MK_MBUTTON )
      if nDelta > 0
         ::PageUp()
      else
         ::PageDown()
      endif
   else
      ::Select( 0 ) // mcs
      if nDelta > 0
         ::GoUp()
      else
         ::GoDown()
      endif
      ::Select( 1 ) // mcs
   endif

Return nil

//----------------------------------------------------------------------------//

METHOD HorzLine( nRow, nOperation, nLine ) CLASS TXBrowse

   static sLine := 0, sRow := 0

   local hDC, nTop

   if nLine != nil
      sLine := nLine
   endif

   do case
   case nOperation == 1
      ::nCaptured = 4
      ::Capture()
      sRow := nRow
      InvertRect( ::GetDC(), { nRow - 1, 0 , nRow + 1, ::BrwWidth() } )
      ::ReleaseDC()

   case nOperation == 2
      nTop := ( sLine * ::nRowHeight ) + ::HeaderHeight()
      InvertRect( ::GetDC(), { sRow - 1, 0 , sRow + 1, ::BrwWidth() } )
      ::ReleaseDC()
      if Abs( nRow - nTop ) > 2
         nTop := ( ( sLine - 1 ) * ::nRowHeight ) + ::HeaderHeight()
         ::nRowHeight := Min( Max( nRow - nTop, 20 ), ::BrwHeight() - nTop - 20 )
         ::Super:Refresh()
      endif

   case nOperation == 3
      nTop := ( ( sLine - 1 ) * ::nRowHeight ) + ::HeaderHeight() + 20
      CursorNS()
      if nRow > nTop .and. nRow < (::BrwHeight() - 20 )
         hDC := ::GetDC()
         InvertRect( hDC, { sRow - 1, 0 , sRow + 1, ::BrwWidth() } )
         sRow := nRow
         InvertRect( hDC, { sRow - 1, 0 , sRow + 1, ::BrwWidth() } )
         ::ReleaseDC()
      endif

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD GetDlgCode( nLastKey ) CLASS TXBrowse

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

METHOD SetRDD( lAddColumns, lAutoOrder, aFldNames ) CLASS TXBrowse

   local oCol, aStruct
   local cAlias, cAdsKeyNo, cAdsKeyCount
   local nFields, nFor

   DEFAULT lAddColumns      := Empty( ::aCols ) .or. ! Empty( aFldNames )
   DEFAULT lAutoOrder       := ::lAutoSort

   if Empty( ::cAlias )
      ::cAlias := Alias()
      if Empty( ::cAlias )
         return nil
      endif
   endif

   cAlias := ::cAlias

   DEFAULT ::bGoTop    := {|| ( cAlias )->( DbGoTop() ) },;
           ::bGoBottom := {|| ( cAlias )->( DbGoBottom() ) },;
           ::bSkip     := {| n | iif( n == nil, n := 1, ), ( cAlias )->( DbSkipper( n ) ) },;
           ::bBof      := {|| ( cAlias )->( Bof() ) },;
           ::bEof      := {|| ( cAlias )->( Eof() ) },;
           ::bBookMark := {| n | iif( n == nil,;
                                     ( cAlias )->( RecNo() ),;
                                     ( cAlias )->( DbGoto( n );
                                    ) ) }

   If "ADS"$( ::cAlias )->( RddName() )
      cAdsKeyNo    := "{| n, Self | iif( n == nil, " +;
                         "Round( " + cAlias + "->( ADSGetRelKeyPos() ) * Self:nLen, 0 ), "+;
                         cAlias + "->( ADSSetRelKeyPos( n / Self:nLen ) ) ) }"

      cAdsKeyCount := "{|| " + cAlias + "->( ADSKeyCount(,,1) )}"

      DEFAULT ::bKeyNo    := &cAdsKeyNo ,;
              ::bKeyCount := &cAdsKeyCount
   else
       DEFAULT ::bKeyNo    := {| n | iif( n == nil,;
                                        ( cAlias )->( OrdKeyNo() ),;
                                        ( cAlias )->( OrdKeyGoto( n );
                                        ) ) },;
               ::bKeyCount := {|| ( cAlias )->( OrdKeyCount() ) }
   Endif

   if lAddColumns
      aStruct      := ( ::cAlias )->( dbstruct() )

      if Empty( aFldNames )
         nFields      := ( ::cAlias )->( FCount() )
         nFields      := Len( aStruct )

         for nFor := 1 to nFields
            oCol    := ::AddCol()
            oCol    := SetColFromRDD( oCol, nFor, ::cAlias, aStruct, lAutoOrder )
         next nFor
      else
         nFields    := Len( aFldNames )
         for nFor := 1 to nFields
            oCol    := ::AddCol
            oCol    := SetColFromRDD( oCol, aFldNames[nFor], ::cAlias, aStruct, lAutoOrder )
         next nFor
      endif
   elseif lAutoOrder
      for nFor := 1 to Len( ::aCols )
         if ( ::cAlias )->( OrdNumber( ::aCols[ nFor ]:cHeader ) ) > 0
            ::aCols[nFor]:cSortOrder := ::aCols[ nFor ]:cHeader
         endif
      next nFor
   endif

   ::bLock     := { || ( ::cAlias )->( DbrLock() ) }
   ::bUnlock   := { || ( ::cAlias )->( DbrUnlock() ) }


return nil

//----------------------------------------------------------------------------//

METHOD SetArray( aData, lAutoOrder, nColOrder, aCols ) CLASS TXBrowse

   local oCol
   local nFor, lAddCols

   if aData == nil .or. Len( aData ) == 0
      return nil
   endif

   DEFAULT lAutoOrder := ::lAutosort, nColOrder := 1
   DEFAULT lAutoOrder := .f.

   ::nRowSel    := 1
   ::nArrayAt   := 1
   ::aArrayData := aData

   ::nDataType  := DATATYPE_ARRAY

   DEFAULT ::bGoTop    := { || ::nArrayAt := Min( 1, Len( ::aArrayData ) ) }, ;
           ::bGoBottom := { || ::nArrayAt := Len( ::aArrayData ) }, ;
           ::bSkip     := { | nSkip, nOld | ;
                            If( nSkip == nil, nSkip := 1, ), ;
                            nOld       := ::nArrayAt, ;
                            ::nArrayAt += nSkip, ;
                            ::nArrayAt := Min( Max( ::nArrayAt, 1 ), Len( ::aArrayData ) ), ;
                            ::nArrayAt - nOld }, ;
           ::bBof      := { || ::nArrayAt < 1 }, ;
           ::bEof      := { || ::nArrayAt > Len( ::aArrayData ) }, ;
           ::bBookMark := { | n | If( n == nil, ::nArrayAt, ::nArrayAt := n ) }, ;
           ::bKeyNo    := ::bBookMark, ;
           ::bKeyCount := { || Len( ::aArrayData ) }

   lAddCols := Empty( ::aCols )
   if ValType( aCols ) == "L"
      lAddCols       := aCols
      aCols          := nil
   endif

   if lAddCols
      ::aCols := {}
      if empty( aCols )
         for nFor := 1 to Len( aData[ 1 ] )
            oCol               := ::AddCol()
            oCol:nArrayCol      := nFor
         next nFor
      else
         for nFor := 1 to Len( aCols )
            oCol               := ::AddCol()
            oCol:nArrayCol      := aCols[ nFor ]
         next nFor
      endif
      AEval( ::aCols, {|oCol| oCol:cHeader := 'Col-' + LTrim(str(oCol:nArrayCol)) } )
      if lAutoOrder
         AEval( ::aCols, {|oCol| oCol:cSortOrder := oCol:nArrayCol, ;
                         If( oCol:nArrayCol == nColOrder, ;
                              (oCol:cOrder := 'D', oCol:SortArrayData(), oCol:nHeadBmpNo := -1 ), ;
                              nil ) ;
                         } )
         ::bSeek := { | c | SeekOnArray( Self, ::aArrayData, c ) }
      endif
      // NEED TO CHANGE SEEKONARRAY
   endif

return Self

//------------------------------------------------------------------------------//

METHOD SetAdO( oRs, lAddCols, lAutoOrder, aFldNames ) CLASS TXBrowse

   LOCAL nFields,nFor, oCol

   ::oRs    := oRs

   DEFAULT ::bGoTop    := {|| If( ::oRs:RecordCount() > 0, ::oRs:MoveFirst(), nil ) },;
           ::bGoBottom := {|| If( ::oRs:RecordCount() > 0, ::oRs:MoveLast(), nil )  },;
           ::bSkip     := {| n | AdoSkip( ::oRs, If( n==nil, 1, n ) ) },;
           ::bBof      := {|| ::oRs:Bof },;
           ::bEof      := {|| ::oRs:Eof },;
           ::bBookMark := {| n | If( n == nil,;
                                 If( ::oRs:RecordCount() > 0, ::oRs:BookMark, 0 ), ;
                                 If( ::oRs:RecordCount() > 0, ( ::oRs:BookMark := n ), 0 ) ) }, ;
           ::bKeyNo    := {| n | If( n == nil, ;
                                 If( ::oRs:RecordCount() > 0, ::oRs:AbsolutePosition, 0 ), ;
                                 If( ::oRs:RecordCount() > 0, ( ::oRs:AbsolutePosition := n ), 0 ) ) },;
           ::bKeyCount := {|| ::oRs:RecordCount() }

   DEFAULT lAddCols   :=  Empty( ::aCols ) .or. ! Empty( aFldNames )
   DEFAULT lAutoOrder := ::lAutoSort

   ::nDataType       := DATATYPE_ADO

   if lAddCols
      if aFldNames == nil
         nFields := oRs:Fields:Count - 1
         for nFor := 0 to nFields
            ::SetColFromADO( nFor, lAutoOrder )
         next
      else
         nFields := Len( aFldnames )
         for nFor := 1 to nFields
            ::SetColFromADO( aFldNames[ nFor ], lAutoOrder )
         next nFor
      endif
   endif

   if oRs:LockType == 4
      ::bOnRowLeave  := { || ::oRs:UpdateBatch() }
   elseif oRs:LockType > 1
      ::bOnRowLeave  := { || ::oRs:Update() }
   endif

return Self

//----------------------------------------------------------------------------//

METHOD SetColFromADO( cnCol, lAutoOrder ) CLASS TXBrowse

   LOCAL   nType, cType, nLen, nDec, cName
   LOCAL   oCol, oField

   oField           := ::oRs:Fields( cnCol )
   oCol             := ::AddCol()

   oCol:cHeader     := If( ValType( cnCol ) == "C", cnCol, oField:Name )

   nType            := oField:Type

   DO CASE
   CASE ASCAN( { 2, 3, 4, 16, 17, 18, 19, 20, 21 }, nType ) > 0
      cType         := 'N'
      nLen          := oField:Precision
      nDec         := 0
   CASE ASCAN( { 14, 131, 139 }, nType ) > 0
      cType         := 'N'
      nLen          := oField:Precision
      nDec          := oField:NumericScale
   CASE ASCAN( { 5, 6 }, nType ) > 0
      cType         := 'N'
      nLen          := oField:Precision
      nDec          := 2

   CASE ASCAN( { 7, 133, 135 }, nType ) > 0
      cType         := 'D'
   CASE nType == 11
      cType         := 'L'
   CASE ASCAN( { 8,128,129,130,200,202,204,205 }, nType ) > 0
      cType         := 'C'
      nLen          := MIN( 100, oField:DefinedSize )
   ENDCASE

   DO CASE
   CASE cType == 'N'
      oCol:bEditValue   := { | x, u | If( x != nil, ::oRs:Fields( cnCol ):Value := x , ), ;
                              u := If( ::oRs:RecordCount() > 0, ::oRs:Fields( cnCol ):Value, 0 ), ;
                              If( Empty( u ), 0, u ) }
      oCol:cEditPicture    := NumPict( nLen, nDec, .F., lThouSep )

   CASE cType == 'D'
      oCol:bEditValue   := { | x, u | If( x != nil, ::oRs:Fields( cnCol ):Value := x, ), ;
                              u := If( ::oRs:RecordCount() > 0, ::oRs:Fields( cnCol ):Value, nil ), ;
                              If( Empty( u ), CTOD( "" ), u ) }

   CASE cType == 'L'
      oCol:bEditValue   := { | x | If( x != nil, ::oRs:Fields( cnCol ):Value := x, ), ;
                            ! Empty( If( ::oRs:RecordCount() > 0, ::oRs:Fields( cnCol ):Value, .f. ) ) }

   CASE cType == 'C'
      oCol:bEditValue   := { | x, u | If( x != nil, ::oRs:Fields( cnCol ):Value := x, ), ;
                             u :=  If( ::oRs:RecordCount() > 0, ::oRs:Fields( cnCol ):Value, "" ), ;
                             If( Empty( u ), Space( nLen ), PadR( u, nLen ) ) }
   CASE cType == nil
      // some types like adChapter( child recset), etc. can not be shown
      // programmer who uses such types should make his own coding for
      // such columns
      oCol:bEditValue   := { || "..." }

   OTHERWISE
      // just in case.  this will not be executed
      oCol:bEditValue := { || "   " }

   ENDCASE

   oCol:bOnPostEdit  := { |o,x,n| If( n == 13, ( Eval( o:bEditValue, x ), o:oBrw:lEdited := .t. ), ) }

   oCol:cDataType         := If( cType == nil, "C", cType )

   if lAutoOrder
      oCol:cSortOrder   := oCol:cHeader
   endif

return oCol
//----------------------------------------------------------------------------//

METHOD SetTree( oTree, aResource, bOnSkip ) CLASS TXBrowse

   local oCol, nBmp1 := 0, nBmp2 := 0, nBmp3 := 0
   local n, nLevels, aBlocks, bBookMark

   DEFAULT bOnSkip   := { || nil }
   DEFAULT oTree     := 2

   if ValType( oTree ) == "N"
      if ! Empty( ::aCols ) .and. Len( ::aCols ) >= 2
         nLevels  := Min( oTree, Len( ::aCols ) )
      else
         return nil
      end
      // MakeTree
      aBlocks := Array( nLevels )
      for n := 1 to nLevels
         aBlocks[ n ] := If( ::aCols[ n ]:bStrData == nil, ::aCols[ n ]:bEditvalue, ::aCols[ n ]:bStrData )
         ::aCols[ n ]:lHide   := .t.      //Hide()
      next
      ::nLen      := Eval( ::bKeyCount )
      bBookMark   := ::bBookMark
      oTree       := SummaryDataAsTree( ::bSkip, { |nRow| nRow > ::nLen }, aBlocks, ::bBookMark )
      bOnSkip     := { || Eval( bBookMark, ::oTreeItem:cargo ) }
      ::nDataType := nOr( ::nDataType, DATATYPE_TREE )
   else
      ::nDataType := DATATYPE_TREE
   endif


   ::oTree     := oTree
   ::oTreeItem := oTree:oFirst


   ::bGoTop    := { || ::oTreeItem := ::oTree:oFirst, Eval( bOnSkip, ::oTreeITem ) }
   ::bGoBottom := { || ::oTreeItem := ::oTree:GetLast(), Eval( bOnSkip, ::oTreeITem ) }
   ::bBof      := { || .f. }
   ::bEof      := { || .f. }
   ::bKeyCount := { || ::oTree:ncount() }

   ::bKeyNo    := { |n| If( n == nil, ::oTreeItem:ItemNo() , ;
                     ( ::oTreeItem := ::oTree:oFirst:Skip( @n ), Eval( bOnSkip, ::oTreeITem ), n ) ) }

   ::bBookMark := ::bKeyNo
   ::bSkip     := { |n| If( n == nil, n := 1, ), ;
                     ::oTreeItem := ::oTreeItem:Skip( @n ),  ;
                     Eval( bOnSkip, ::oTreeITem ), ;
                     n }

   if Empty( ::aCols )
      oCol  := ::AddCol()
   else
      oCol  := ::InsCol( 1 )
   endif

   oCol:bStrData     := ;
   oCol:bEditValue   := { || ::oTreeItem:cPrompt }
   oCol:cHeader      := "Item"
   oCol:nWidth       := 200
   oCol:bLDClickData := { || If( ::oTreeItem:oTree != nil,( ::oTreeItem:Toggle(), ::Refresh() ),) }
   oCol:bIndent      := { || ::oTreeItem:nLevel * 20 - 20 }

   if ValType( aResource ) == "A"
      oCol:AddResource( aResource[ 1 ] )
      nBmp1 := Len( oCol:aBitmaps )
      if Len( aResource ) >= 2
         oCol:AddResource( aResource[ 2 ] )
         nBmp2 := nBmp1 + 1
         if Len( aResource ) >= 3
            oCol:AddResource( aResource[ 3 ] )
            nBmp3 := nBmp1 + 2
         endif
      endif
      oCol:bBmpData   := { || If( ::oTreeItem:oTree == nil, nBmp3, If( ::oTreeItem:lOpened, nBmp1, nBmp2 ) ) }
   endif

   ::nFreeze         := 1


return Self

//----------------------------------------------------------------------------//

METHOD   SetoDbf( oDbf, aCols ) CLASS TXBrowse

   local n, oCol

   DEFAULT ::bGoTop    := {|| oDbf:GoTop() },;
           ::bGoBottom := {|| oDbf:GoBottom()  },;
           ::bSkip     := {| n | oDbf:Skipper( If( n == nil,1,n) )}, ;
           ::bBof      := {|| oDbf:Bof() },;
           ::bEof      := {|| oDbf:Eof() },;
           ::bBookMark := {| n | If( n == nil,;
                                   ( oDbf:RecNo() ),;
                                   ( oDbf:GoTo( n ) ) ) },;
           ::bKeyNo    :=::bBookMark,;
           ::bKeyCount := {|| oDbf:RecCount()}

   ::nDataType         := DATATYPE_ODBF
   ::oDbf              := oDbf

   if aCols != nil
      for n := 1 to Len( aCols )
         AddoDbfCol( Self, acols[ n ] )
      next
   endif

   ::bOnRowLeave        := { || ::oDbf:Save() }

return Self

//----------------------------------------------------------------------------//

METHOD SetBackGround( oBrush ) CLASS TXBrowse

   if oBrush == nil
      ::lTransparent := .f.
      ::SetColor( ::nClrText, ::nClrPane )
      ::Refresh()
   else
      ::lTransparent := .t.
      ::SetBrush( oBrush )
      ::Refresh()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD AddCol() CLASS TXBrowse

   local oCol

   oCol := TXBrwColumn():New( Self )

   Aadd( ::aCols, oCol )

   oCol:nCreationOrder := Len( ::aCols )

return oCol

//----------------------------------------------------------------------------//

METHOD InsCol( nPos ) CLASS TXBrowse

   local oCol
   local nFor

   DEFAULT nPos := Len( ::aCols )

   oCol := TXBrwColumn():New( Self )

   Aadd( ::aCols, nil )
   Ains( ::aCols, nPos )

   ::aCols[ nPos ] := oCol

   for nFor := nPos + 1 to Len( ::aCols )
      ::aCols[ nFor ]:nCreationOrder := nFor
   next

   ::GetDisplayCols()
   ::Super:Refresh()

return oCol

//----------------------------------------------------------------------------//

METHOD DelCol( nPos ) CLASS TXBrowse

   local nFor

   ADel( ::aCols, nPos )
   ASize( ::aCols, Len( ::aCols ) - 1 )

   for nFor := nPos + 1 to Len( ::aCols )
      ::aCols[ nFor ]:nCreationOrder := nFor
   next

   ::GetDisplayCols()
   ::Super:Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SwapCols( xCol1, xCol2, lRefresh ) CLASS TXBrowse

   local oCol
   local nAt1, nAt2, nPos

   DEFAULT lRefresh := .t.

   if Valtype( xCol1 ) == "O"
      nAt1 := Ascan( ::aCols, {|v| v:nCreationOrder == xCol1:nCreationOrder } )
      nAt2 := Ascan( ::aCols, {|v| v:nCreationOrder == xCol2:nCreationOrder } )
   else
      nAt1 := xCol1
      nAt2 := xCol2
   endif

   if nAt1 > 0 .and. nAt2 > 0
      oCol := ::aCols[ nAt1 ]
      nPos := oCol:nPos
      ::aCols[ nAt1 ]:nPos := ::aCols[ nAt2 ]:nPos
      ::aCols[ nAt2 ]:nPos := nPos
      ::aCols[ nAt1 ] := ::aCols[ nAt2 ]
      ::aCols[ nAt2 ] := oCol
      if lRefresh
         ::GetDisplayCols()
         ::Super:Refresh()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MoveCol( xFrom, xTo, lRefresh ) CLASS TXBrowse

   local oCol
   local nFrom, nTo, nPos, n

   DEFAULT lRefresh := .t.

   if Valtype( xFrom ) == "O"
      nFrom := Ascan( ::aCols, {|v| v:nCreationOrder == xFrom:nCreationOrder } )
      nTo   := Ascan( ::aCols, {|v| v:nCreationOrder == xTo:nCreationOrder   } )
   else
      nFrom := xFrom
      nTo   := xTo
   endif

   if nFrom > 0 .and. nTo > 0
      oCol := ::aCols[ nFrom ]
      nPos := oCol:nPos
      ADel( ::aCols, nFrom )
      AIns( ::aCols, nTo   )
      ::aCols[ nTo ] := oCol
      ::GetDisplayCols()

      if lRefresh
         ::Super:Refresh()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SaveState() CLASS TXBrowse

   local oCol
   local cState
   local nFor, nLen

   nLen   := Len( ::aCols )
   cState := Ltrim( Str( ::nRowHeight ) ) + ";"

   for nFor := 1 to nLen
      oCol   := ::aCols[ nFor ]
      cState += Ltrim( Str( oCol:nCreationOrder ) ) + ":" +;
                Ltrim( str( oCol:nWidth ) ) + ":" +;
                oCol:cHeader + ":" +;
                iif(oCol:lHide, "H", "S")
      if nFor < nLen
         cState += ";"
      endif
   next

return cState

//----------------------------------------------------------------------------//

METHOD RestoreState( cState ) CLASS TXBrowse

   local oCol
   local aMoved, aNaturalOrder
   local cCol
   local nLen, nOrder, nWidth, nFor, nAt, nHeight
   local lHide,cHeader,j

   if Empty( cState )
      return nil
   endif

   aMoved := {}
   aNaturalOrder := {}
   nLen   := Len( ::aCols )

   nHeight := Val(StrToken( cState, 1, ";" ) )

   if Empty( ::nRowHeight )
      return nil
   endif

   // Check integrity

   for nFor := 1 to nLen
      cCol := StrToken( cState, nFor + 1, ";" )
      if Empty( cCol )
         return nil
      endif
      aadd( aNaturalOrder, nFor )
   next

   ::nRowHeight := nHeight

   for nFor := 1 to nLen
      cCol   := StrToken( cState, nFor + 1, ";" )
      nOrder := Val( StrToken( cCol, 1, ":" ) )
      nWidth := Val( StrToken( cCol, 2, ":" ) )
      cHeader :=  StrToken( cCol, 3, ":" )
      lHide  := ( AllTrim( StrToken( cCol, 4, ":" ) ) == "H" )
      nAt := Ascan( ::aCols, {|v| v:nCreationOrder == nOrder } )
      if nAt > 0
         oCol := ::aCols[ nAt ]
         oCol:lHide  := lHide
         oCol:nWidth := nWidth
         oCol:cHeader := cHeader
      endif
      if nOrder != nFor
         if nOrder != aNaturalOrder[ nFor ] .and. ( nAt := Ascan( aNaturalOrder, nOrder ) ) != 0
         ::SwapCols( nFor, nAt, .f. )
         aNaturalOrder[ nFor ]:= nOrder
         aNaturalOrder[ nAt ]:= nFor
        endif
      endif
   next

   ::GetDisplayCols()
   ::Super:Refresh()

return nil



//----------------------------------------------------------------------------//

METHOD CancelEdit() CLASS TXBrowse

   local oCol, nFor, nlen
/*
   if ! ::lEditMode
      return nil
   endif
*/

   if ::lEditMode
      nLen := Len( ::aCols )

      for nFor := 1 to nLen
         oCol := ::aCols[ nFor ]
         if oCol:oEditGet != nil
            oCol:oEditGet:VarPut( Eval( oCol:bEditValue ) )
            oCol:oEditGet:bValid = nil
            oCol:PostEdit()
         endif
         if oCol:oEditLbx != nil
            oCol:oEditLbx:End()
         endif
      next

      ::lEditMode := .f.
   endif

   if ::lEdited
      if ::bOnRowLeave != nil
         Eval( ::bOnRowLeave, Self )
      endif
      ::lEdited   := .f.
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Select( nOperation ) CLASS TXBrowse

   local uBook, uCurRow, uOldRow, uTemp
   local aTemp
   local nAt, nLen
   local lRefresh

   if ::nMarqueeStyle != MARQSTYLE_HIGHLROWMS
      return nil
   endif

   DEFAULT nOperation := 1

   do case
   case nOperation ==   0 // delete all
      if Len( ::aSelected ) == 1 .and.  Eval( ::bBookMark ) == ::aSelected[ 1 ]
         lRefresh := .f.
      else
         lRefresh := .t.
      endif
      ::aSelected   := {}

      if ! Empty( ::nSaveMarq )
         ::nMarqueeStyle   := ::nSaveMarq
         ::nSaveMarq       := nil
      endif

      if lRefresh
         // ::lRefreshOnlyData := .t.
         ::GetDC()
         ::Paint()
         ::ReleaseDC()
      endif

   case nOperation == 1 .or. ( Len( ::aSelected ) == 0 .and. nOperation != 4 )// Add current
      uBook := Eval( ::bBookMark )
      nAt   := Ascan( ::aSelected, uBook )
      if nAt == 0
         Aadd( ::aSelected, uBook )
         ::DrawLine( .t. )
      endif

   case nOperation == 2 // Swap key (Ctrl+LClick)
      uBook := Eval( ::bBookMark )
      nAt   := Ascan( ::aSelected, uBook )
      if nAt > 0
         ::DrawLine( .f. )
         ::aSelected[ nAt ] := Atail( ::aSelected )
         Asize( ::aSelected, Len( ::aSelected ) - 1 )
      else
         Aadd( ::aSelected, Eval( ::bBookMark ))
         ::DrawLine( .t. )
      endif

   case nOperation == 3 // Shift & lclick
      uBook   := Eval( ::bBookMark )
      uCurRow := Eval( ::bKeyNo,,Self )
      Eval( ::bBookMark,  Atail( ::aSelected ) )
      uOldRow := Eval( ::bKeyNo,,Self )
      if uOldRow != uCurRow
         ::aSelected := { Atail( ::aSelected ) }
         if uCurRow > uOldRow
            CursorWait()
            do while ( uTemp := Eval( ::bBookMark ) ) != uBook .and. !Eval( ::bEof )
               If Ascan( ::aSelected, uTemp ) == 0
                  Aadd( ::aSelected, uTemp )
               Endif
               Eval( ::bSkip, 1 )
            enddo
            CursorArrow()
         else
            CursorWait()
            do while ( uTemp := Eval( ::bBookMark ) ) != uBook .and. !Eval( ::bBof )
               If Ascan( ::aSelected, uTemp ) == 0
                  Aadd( ::aSelected, uTemp )
               endif
               Eval( ::bSkip, -1 )
            enddo
            CursorArrow()
         endif
         Aadd( ::aSelected, uBook )
         Eval( ::bBookMark, uBook )
         // ::lRefreshOnlyData := .t.
         ::GetDC()
         ::Paint()
         ::ReleaseDC()

      else
         Eval( ::bBookMark, uBook )
      endif

   case nOperation == 4 // Select all
      uBook       := Eval( ::bBookMark )
      ::aSelected := Array( ::KeyCount() )
      nAt         := 1
      nLen        := ::nLen
      aTemp       := ::aSelected
      CursorWait()
      Eval( ::bGotop )
      do while nAt <= nLen //.and. !Eval( ::bEof )
         aTemp[ nAt++ ] := Eval( ::bBookMark )
         Eval( ::bSkip, 1 )
      enddo
      Eval( ::bBookMark, uBook )
      CursorArrow()
      // ::lRefreshOnlyData := .t.
      ::GetDC()
      ::Paint()
      ::ReleaseDC()

   case nOperation == 5 // Swap key (Shift + GoDown or GoUp)
      uCurRow := ::KeyNo()
      nAt     := Ascan( ::aSelected, uCurRow )
      uBook   := Eval( ::bBookMark )
      if nAt == 1 .and. len( ::aSelected ) == 1
         return nil
      elseif nAt == 0
         Aadd( ::aSelected, uBook )
         ::DrawLine( .t. )
      else
         if nAt != len( ::aSelected )
            Asize( ::aSelected, Len( ::aSelected ) - 1 )
            ::Refresh()
         endif
      endif

   end case

return nil

//----------------------------------------------------------------------------//

METHOD Seek( cSeek ) CLASS TXBrowse

   local uBook, uSeek
   local nFor, nRows
   local lRefresh

   if ::bSeek == nil
      return nil
   endif

   If cSeek == nil
      if ! Empty( ::cSeek )
         ::cSeek := ""
         If ::oSeek != nil
            ::oSeek:SetText( "" )
         Endif
      endif
      return nil
   Endif

   uBook := Eval( ::bBookMark )

   if !Eval( ::bSeek, cSeek )
      Eval( ::bBookMark, uBook )
      MsgBeep()
      return nil
   endif

   if ::nRowSel > Eval( ::bKeyNo,, Self )
      ::nRowsel := 1
   endif

   ::cSeek  := cSeek
   uSeek    := Eval( ::bBookMark )
   nRows    := ::nDataRows
   lRefresh := .t.

   if ::oSeek != nil
      ::oSeek:SetText( cSeek )
   endif

   Eval( ::bBookMark, uBook )
   Eval( ::bSkip, 1 - ::nRowSel )

   for nFor := 1 to nRows
      if Eval( ::bBookMark ) == uSeek
         lRefresh := .f.
         exit
      endif
      if Eval( ::bSkip, 1 ) == 0
         exit
      endif
   next

   if lRefresh
      Eval( ::bBookMark, uSeek )
        if ::bChange != nil
           Eval( ::bChange, Self, .t. )
        endif
        ::Super:Refresh( .F. )
   else
      Eval( ::bBookMark, uBook )
      ::DrawLine( .f. )
      ::nRowSel := nFor
      Eval( ::bBookMark, uSeek )
      if ::bChange != nil
           Eval( ::bChange, Self, .t. )
        endif
      ::DrawLine( .t. )
   endif

   if ::oVScroll != nil
      ::VSetPos( Eval( ::bKeyNo,,Self ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetColumns( nRow, nCol, nFlags ) CLASS TXBrowse

   local oMenu, oCol
   local nFor, nLen

   nLen := Len( ::aCols )

   MENU oMenu POPUP
      for nFor := 1 to nLen
         oCol := ::aCols[ nFor ]
         MenuAddItem( oCol:cHeader, , !oCol:lHide, ( Len(::aDisplay) != 1 .or. ocol:nPos != 1 ), GenMenuBlock( ::aCols, nFor ) )
      next
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow, nCol OF Self

return nil

//----------------------------------------------------------------------------//

METHOD GoNextCtrl(hWnd)  CLASS TXBrowse

   local oCol
   local aCols
   local nCol
   local lDir := .f.

   If hWnd != Nil
      If ::nLastKey == 9
         PostMessage(hWnd, WM_KEYDOWN, VK_RETURN)
      Endif
      return nil
   Endif

   If ::lFastEdit .and. ::nColSel == ::nLastEditCol
      ::nLastEditCol := 0
      aCols := ::GetVisibleCols()
      nCol  := ::nColSel + 1
      If ::IsDisplayPosVisible( nCol )
         oCol := aCols[nCol]
         If oCol:nEditType > 0
            ::GoRight()
         Endif
      endif
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD SelFont() CLASS TXBrowse

   local oFont, n

   DEFINE FONT oFont FROM USER

   if oFont:cFaceName != "SYSTEM_FONT"

      for n = 1 to Len( ::aCols )
         ::aCols[ n ]:oDataFont = oFont
      next

      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD FontSize( nPlus ) CLASS TXBrowse

   local oFont, n

   if ::lCreated .and. ::oFont:nInpHeight < 0

      DEFAULT nPlus := 1

      DEFINE FONT oFont NAME ::oFont:cFaceName SIZE 0, ::oFont:nInpHeight - nPlus

      ::SetFont( oFont )

      for n = 1 to Len( ::aCols )

         if ValType( ::aCols[ n ]:oDataFont ) == "O"
            ::aCols[ n ]:oDataFont := oFont
            ::aCols[ n ]:nWidth    := Max( Max( ::aCols[ n ]:HeaderWidth(),;
                                      ::aCols[ n ]:FooterWidth() ),;
                                      ::aCols[ n ]:DataWidth() ) + ;
                                      COL_EXTRAWIDTH
         endif

      next

      ::Refresh()

   endif

return nil

//----------------------------------------------------------------------------//

METHOD ClpRow( lFullRow ) CLASS TXBrowse

   local nLast := Len( ::aCols )
   local n, RetVal := ""

   DEFAULT lFullRow := ( ::nMarqueeStyle >= 4 )

   if lFullRow
      for n := 1 to nLast
         if ! ::aCols[ n ]:lHide
            if ! Empty( RetVal )
               RetVal   += Chr( 9 )
            endif
            RetVal += ::aCols[ n ]:ClpText
         endif
      next
   else
      RetVal   := ::SelectedCol():ClpText
   endif

return RetVal

//----------------------------------------------------------------------------//

METHOD Copy() CLASS TXBrowse

   local oClip
   local cText
   local uBm, n, aSel

   if Empty( ::aSelected )
      cText       := ::ClpRow()
   else
      aSel     := AClone( ::aSelected )
      ubm      := Eval( ::bBookMark )
      cText    := ""
      for n := 1 to Len( aSel )
         Eval( ::bBookMark, asel[ n ] )
         if n > 1
            cText    += CRLF
         endif
         cText       += ::ClpRow()
      next
      Eval( ::bBookMark, ubm )
   endif

   oClip := TClipBoard():New()
   if oClip:Open()
      oClip:SetText( cText )
      oClip:Close()
   endif
   oClip:End()

return cText

//----------------------------------------------------------------------------//

METHOD Report( cTitle, lPreview, lModal, bSetUp, aGroupBy ) CLASS TXBrowse

   local oRep, oPrn, oFont, oBold, uRet
   local aCols, nFor, oCol, uBookMark
   local oBrw := Self
   local lAddCols := .T.
   local nRows, nSel, n
   local bEof

   DEFAULT cTitle   := If( ::oWnd:ClassName == 'TPANEL', ::oWnd:oWnd:cTitle, ::oWnd:cTitle )
   DEFAULT lPreview := .T.
   DEFAULT lModal   := .T.

   oPrn :=  PrintBegin( nil, ;            // document
                        .F., ;            // luser
                        lPreview, nil, ;  // xmodel
                        lModal, .F. )     // lselect

   if oPrn:hDC == 0
       return .f.
   endif

   if ValType( aGroupBy ) $ "ON"
      aGroupBy    := { aGroupBy }
   endif


   DEFINE FONT oFont NAME 'TAHOMA' SIZE 0, - 8
   DEFINE FONT oBold NAME 'TAHOMA' SIZE 0, - 8 BOLD

   REPORT oRep TITLE cTitle ;
          FONT oFont,oBold ;
          TO DEVICE oPrn

   if ! Empty( bSetUp )
      uRet := Eval( bSetUp, oRep, Self )
      if ( ValType( uRet ) == 'L' .and. uRet )
         lAddCols := .F.
      endif
   endif

   if lAddCols

      aCols  := ::GetVisibleCols()

      if ValType( aGroupBy ) == "A"
         for nFor := 1 to Len( aGroupBy )
            if ValType( aGroupBy[ nFor ] ) == "N"
               aGroupBy[ nFor ] := aCols[ aGroupBy[ nFor ] ]
            endif
         next
      else
         aGroupBy := {}
      endif

      for nFor := 1 to Len( aCols )
         if AScan( aGroupBy, { |o| o:nCreationOrder == aCols[ nFor ]:nCreationOrder } ) == 0
            oCol := MakeRepCol( oRep, aCols[ nFor ] )
         endif
      next nFor

      for n := 1 to Len( aGroupBy )
         MakeRepGroup( aGroupBy[ n ] )
      next

   endif


   ENDREPORT

   uBookMark := Eval( ::bBookMark )

    if Len( ::aSelected ) > 1
        Eval( ::bBookMark, ::aSelected[ 1 ] )
        nRows        := Len( ::aSelected )
        nSel         := 1
        oRep:bSkip   := { || nSel++, Eval( oBrw:bBookMark, oBrw:aSelected[ min( nSel, nRows ) ] ) }
    else
       Eval( ::bGoTop )
        nRows           := Eval( ::bKeyCount )
        oRep:bSkip   := { |n| Eval( oBrw:bSkip, n ) }
    endif
    oRep:bWhile      := { || oRep:nCounter < nRows }
    oRep:bEnd        := ::bGoTop
   oRep:Activate()

   Eval( ::bGoTop )
   Eval( ::bBookMark, UBookMark )

   ::Refresh()
   ::SetFocus()

   RELEASE FONT oFont

return Self

//----------------------------------------------------------------------------//

METHOD ToExcel( bProgress, nGroupBy ) CLASS TXBrowse

   local oExcel, oBook, oSheet, oWin
   local nCol, nXCol, oCol, cType, uValue
   local uBookMark, nRow
   local nDataRows
   local aCols
   local oClip, cText, nPasteRow, nStep
   local aTotals  := {}, lAnyTotals := .f.
   local cFormat

   nDataRows   := EVAL( ::bKeyCount )
   if nDataRows == 0
      return nil
   endif

   TRY
      oExcel   := GetActiveObject( "Excel.Application" )
   CATCH
      TRY
         oExcel   := CreateObject( "Excel.Application" )
      CATCH
         MsgAlert( "Excel not installed" )
         return Self
      END
   END

   if nxlLangID == nil
      SetExcelLanguage( oExcel )
   endif

   oBook   := oExcel:WorkBooks:Add()
   oSheet   := oExcel:ActiveSheet


   uBookMark   := EVAL( ::bBookMark )

   aCols         := ::GetVisibleCols()

   nRow   := 1
   nCol   := 0
   for nXCol := 1 TO Len( aCols )
      oCol   := aCols[ nXCol ]

      nCol ++

      oSheet:Cells( nRow, nCol ):Value   := oCol:cHeader
      cType      := oCol:cDataType

      DO CASE
      CASE cType == 'N'

            cFormat     := If( lThouSep, If( lxlEnglish, "#,##0", "#.##0" ), "0" )
            if ( oCol:cEditPicture != nil ) .AND. ( "." $ oCol:cEditPicture )
               cFormat  += If( lxlEnglish, ".00", ",00"  )
            endif
            oSheet:Columns( nCol ):NumberFormat := cFormat
            oSheet:Columns( nCol ):HorizontalAlignment := - 4152 //xlRight

		 /*
         if oCol:cEditPicture != nil .AND. "." $ oCol:cEditPicture
            oSheet:Columns( nCol ):NumberFormat := If( lxlEnglish, "#,##0.00", "#.##0,00" )
            oSheet:Columns( nCol ):Style := "Comma"
         else
            oSheet:Columns( nCol ):NumberFormat := If( lxlEnglish, "#,##0", "#.##0" )
            oSheet:Columns( nCol ):Style := "Comma [0]"
         endif
         oSheet:Columns( nCol ):HorizontalAlignment := - 4152 //xlRight
		 */

      CASE cType == 'D'
         if lxlEnglish
           oSheet:Columns( nCol ):NumberFormat := Lower( Set( _SET_DATEFORMAT ) )
           oSheet:Columns( nCol ):HorizontalAlignment := - 4152 //xlRight
         endif
      CASE cType == 'L'
         // leave as general format
      OTHERWISE
         oSheet:Columns( nCol ):NumberFormat := "@"
      ENDCASE

   next nXCol

   oSheet:Range( oSheet:Cells( 1, 1 ), oSheet:Cells( 1, Len( aCols ) ) ):Select()
   // xlEdgeBottom = 9, xlEdgeTop = 8, xlEdgeLeft = 8, xlEdgeRight = 10
   oExcel:Selection:Borders(9):LineStyle := 1   // xlContinuous = 1
   oExcel:Selection:Borders(9):Weight    := -4138   // xlThin = 2, xlHairLine = 1, xlThick = 4, xlMedium = -4138


   if Empty( ::aSelected ) .or. Len( ::aSelected ) == 1

      Eval( ::bGoTop )
      if ::oRs != nil .AND. Len( aCols ) == ::oRs:Fields:Count()
            ::oRs:MoveFirst()
            nRow   := oSheet:Cells( 2, 1 ):CopyFromRecordSet( ::oRs )
            ::oRs:MoveFirst()
         nRow   += 2
      else

         if bProgress == nil
            if ::oWnd:oMsgBar == nil
               bProgress := { || nil }
            else
               bProgress := { | n, t | ::oWnd:SetMsg( "To Excel : " + Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
            endif
         endif

         nRow      := 2
         nPasteRow := 2
         nStep     := Max( 1, Min( 100, Int( nDataRows / 100 ) ) )
         cText     := ""
         oClip := TClipBoard():New()
         if oClip:Open()

            Eval( bProgress, 0, nDataRows )
            do while nRow <= ( nDataRows + 1 )
               if ! Empty( cText )
                  cText += CRLF
               endif
               cText    += ::ClpRow( .t. )

               Eval( ::bSkip, 1 )
               nRow ++

               if Len( cText ) > 16000
                  oClip:SetText( cText )
                  oSheet:Cells( nPasteRow, 1 ):Select()
                  oSheet:Paste()
                  oClip:Clear()
                  cText       := ""
                  nPasteRow   := nRow
               endif

               If ( nRow - 2 ) % nStep == 0
                  if Eval( bProgress, nRow - 2, nDataRows ) == .f.
                     Exit
                  endif
                  SysRefresh()
               endif

            enddo
            if ! Empty( cText )
               oClip:SetText( cText )
               oSheet:Cells( nPasteRow, 1 ):Select()
               oSheet:Paste()
               oClip:Clear()
               cText    := ""
            endif
            oClip:Close()

            Eval( bProgress, nDataRows, nDataRows )
            SysRefresh()

         endif
         oClip:End()
      endif
   else
      ::Copy()
      oSheet:Cells( 2, 1 ):Select()
      oSheet:Paste()
      nRow := Len( ::aSelected ) + 2
   endif
   oSheet:Cells( 1, 1 ):Select()

   // Totals, if needed

   oSheet:Rows(    1 ):Font:Bold   := .T.
   oSheet:Rows( nRow ):Font:Bold   := .T.

   if ValType( nGroupBy ) == "N"
      for nxCol := 1 TO Len( aCols )
         if aCols[ nxCol ]:lTotal
            AAdd( aTotals, nxCol )
         endif
      next
      if ! Empty( aTotals )
         oSheet:Activate()
         oExcel:Selection:Subtotal( nGroupBy , -4157,  ;    // xlSum = -4157
                                    aTotals, ;
                                    .t., ;    // Replace .t. or .f.
                                    .f., ;    // PageBreaks
                                    .f. )       // SummaryBelowData

      endif
   else
      nCol   := 0
      oSheet:Range( oSheet:Cells( nRow, 1 ), oSheet:Cells( nRow, Len( aCols ) ) ):Select()
      // xlEdgeBottom = 9, xlEdgeTop = 8, xlEdgeLeft = 8, xlEdgeRight = 10
      oExcel:Selection:Borders(8):LineStyle := 1   // xlContinuous = 1
      oExcel:Selection:Borders(8):Weight    := -4138   // xlThin = 2, xlHairLine = 1, xlThick = 4, xlMedium = -4138

      for nXCol := 1 TO Len ( aCols )
         oCol   := aCols[ nXCol ]
         nCol ++
         if oCol:lTotal
            if ! Empty( cxlSum )
               oSheet:Cells( nRow, nCol ):FormulaR1C1 := "=" + cxlSum + excelRange( 2, nCol, nRow - 1 )
               lAnyTotals := .t.
            endif
         endif
      next nXCol
      if lAnyTotals
        oExcel:Selection:Borders(9):LineStyle := 1   // xlContinuous = 1
        oExcel:Selection:Borders(9):Weight    := 4   // xlThin = 2, xlHairLine = 1, xlThick = 4, xlMedium = -4138
      endif
   endif

   for nCol := 1 to Len( aCols )
      oSheet:Columns( nCol ):AutoFit()
   next

   oSheet:Cells(1,1):Select()
   oWin   := oExcel:ActiveWindow
   oWin:SplitRow := 1
   oWin:FreezePanes := .t.

//   oWin:DisplayZeros := .f.

   Eval( ::bBookMark, uBookMark )
   ::Refresh()
   ::SetFocus()
   oExcel:visible   := .T.

return Self

//----------------------------------------------------------------------------//

METHOD aCellCoor( nRow, nCol ) CLASS TXBrowse

   local nTop, nLeft, nBottom, nRight
   local oCol := ::ColAtPos( nCol )

   DEFAULT nRow := ::nRowSel, nCol := ::nColSel

   nTop     := ( ( nRow - 1 ) * ::nRowHeight ) + ::HeaderHeight()
   nLeft    := oCol:nDisplayCol
   nBottom  := nTop + ::nRowHeight - 1
   nRight   := nLeft + oCol:nWidth - 1

return { nTop, nLeft, nBottom, nRight }

//----------------------------------------------------------------------------//
// Support functions for Txbrowse
//----------------------------------------------------------------------------//

static function treerecno( oItem )

   local nRec  := - 10000

   oItem:Skip( @nRec )

return -nRec

//----------------------------------------------------------------------------//

static function MakeRepCol( oRep, oXCol )

   local oCol, bData, cPic //, lTotal := .F.
   local cAlign

   if ( bData := oXCol:bEditValue ) == nil
      bData := oXCol:bStrData
   else
      cPic := oXCol:cEditPicture
   endif

   if bData != nil

      cAlign   := If( oXCol:nDataStrAlign  == AL_RIGHT, "RIGHT", ;
                  If( oXCol:nDataStrAlign  == AL_CENTER, "CENTER", "LEFT" ))

      oCol := RptAddColumn( { { || oXCol:cHeader } }, nil ,;
                            { bData }, nil, { cPic } ,;
                            nil, oXCol:lTotal, nil ,;
                            cAlign, .F., .F., nil )
   endif

return oCol

//----------------------------------------------------------------------------//

static function MakeRepGroup( oCol )

   local bData    := { || oCol:cHeader + " " + Eval( oCol:bStrData ) }

   if ! Empty( bData )
       RptAddGroup( bData, bData, nil, { || 2 }, .f. )
   endif

return nil

//----------------------------------------------------------------------------//

static function AdoSkip(oRs,n)  //Biel

   LOCAL nRec

   if oRs:RecordCount() == 0
      return 0
   endif

   nRec := oRs:AbsolutePosition
   oRs:Move( n )
   If( oRs:Eof, oRs:MoveLast(), If( oRs:Bof, oRs:MoveFirst(),) )

return oRs:AbsolutePosition - nRec

//----------------------------------------------------------------------------//

function SeekOnArray( Self, aData, cSeek )

   local aCols
   local nAt, nFor, nLen
   local lExact

   aCols  := ::aCols
   nLen   := Len( aCols )
   cSeek  := Upper( cSeek )

   for nFor := 1 to nLen
      if !( aCols[ nFor ]:cOrder == "" )
         lExact := Set( _SET_EXACT, .f. )
         nAt := Ascan( aData, {|v| Upper( cValToChar( v[ aCols[ nFor ]:nCreationOrder ] ) ) = cSeek } )
         Set( _SET_EXACT, lExact )
         if nAt > 0
            ::nArrayAt := nAt
            return .t.
         endif
      endif
   next

return .f.

//----------------------------------------------------------------------------//

static function GenMenuBlock( aCols, nFor )

   local oCol := aCols[ nFor ]

return {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//


static function SetColFromRDD( oCol, nFld, cAlias, aFldInfo, lAutoSort )

   local cName       // if fieldname is specified in different case, header is set accordingly
   local nLen, nDec, nSelect  := SELECT( cAlias )

   if valtype( nFld ) == 'C'
      nFld  := (cAlias)->(FieldPos(cName := nFld))
   endif

   aFldInfo          := aFldInfo[ nFld ]

   oCol:cHeader      := If( cName == nil, aFldInfo[ 1 ], cName )
   if ( cName == nil )
      cName          := aFldInfo[ 1 ]
   endif
//   oCol:bEditValue   := {|| (cAlias)->( fieldget( nFld ) ) }
   oCol:bEditValue   := FieldWBlock( cName, nSelect )
   nLen              := aFldInfo[ 3 ]
   nDec              := aFldInfo[ 4 ]

   if Len( aFldInfo[ 2 ] ) == 1
      oCol:cDataType      := aFldInfo[ 2 ]
      if oCol:cDataType == "I"
         oCol:cDataType := "N"
         if aFldInfo[ 3 ] == 2
            nLen        := 6
         else
            nLen        := 13
         endif
         nDec           := 0
      elseif oCol:cDataType == "U"
         oCol:cDataType := "C"
      endif
   else
      // ADT table
      oCol:cDataType    := ValType( ( cAlias )->( FieldGet( nFld ) ) )
      do case
         case oCol:cDataType == "N"
            do case
               case "DOUBLE" $ aFldInfo[ 2 ] .or. "MONEY" $ aFldInfo[ 2 ]
                  nLen           := 15
                  nDec           := 2
               case AScan( { "AUTOINC", "ROWVERSION" }, aFldInfo[ 2 ] ) > 0
                  nLen           := 15
                  nDec           := 0
               otherwise
                  nLen           := 15
                  nDec           := 0
            endcase
         case oCol:cDataType $ "CM"
            if aFldInfo[ 2 ] = "IMAGE"
               oCol:bStrData     := { || "<Image>" }
            elseif aFldInfo[ 2 ] = "RAW"
               oCol:bStrData     := { || "<Binary>" }
            endif
         otherwise
            // nothing to do
      endcase
   endif

   // oCol:adjust() will set bstrdata

   do case
   case oCol:cDataType == 'N'
      oCol:cEditPicture   := NumPict( nLen, nDec, .T., lThouSep )
   case oCol:cDataType  == 'D'
      oCol:cEditPicture   := '@D'
#ifdef __XHARBOUR__
      if hb_IsDateTime( (cAlias)->( FieldGet( nFld ) ) )
         oCol:bStrData     := { || TTOC( (cAlias)->( FieldGet( nFld ) ) ) }
      endif
#endif
   endcase

   oCol:bOnPostEdit  := { |o,x,n| If( n == 13 .and. Eval( o:oBrw:bLock ), ;
          (Eval( o:bEditValue, x ), o:oBrw:lEdited := .t. ), ) }

   if lAutoSort
      if (cAlias)->( OrdNumber( oCol:cHeader ) ) > 0
         oCol:cSortOrder   := oCol:cHeader
      endif
   endif

return oCol
//----------------------------------------------------------------------------//

function NumPict( nLen, nDec, lDBF, lThouSep )

LOCAL   Pic

   nLen       += 2  // to accommdate totals

   if nDec > 0
      nLen   -= ( nDec + If( lDbf, 1, 0 ) )
   endif
   nLen      := MAX( MIN( 14, nLen ), 1 )

   Pic           := replicate( '9', nLen )
   if lThouSep .and. nDec > 0
      if cNumFormat == "I"
         Pic          := ltrim( transform( val( Pic ), '99,999,99,99,99,999' ) )
      else
         Pic          := ltrim( transform( val( Pic ), '99,999,999,999,999' ) )
      endif
   endif
//   Pic            := '@Z ' + Pic
   if cNumFormat == "E"
     Pic             := "@E " + Pic
   endif

   if nDec > 0
      Pic      += ( '.' + replicate( '9', nDec ) )
   endif

return Pic
//----------------------------------------------------------------------------//

static function AddOdbfCol( oBrw, cCol )

   local oCol := oBrw:AddCol()

   oCol:cHeader         := cCol
   oCol:bEditValue      := { |x| If( x != nil, oSend( oBrw:oDbf, "_" + cCol, x ), ), OSend( oBrw:oDbf, cCol ) }
   oCol:bOnPostEdit     := { |o,x,n| If( n == 13, ( Eval( o:bEditValue, x ), o:oBrw:lEdited := .t. ), ) }

return oCol

//----------------------------------------------------------------------------//

static function excelCell( r, c )
return "R" + LTrim( Str( r ) ) + "C" + LTrim( Str( c ) )

static function excelRange( r1, c1, r2, c2 )
   DEFAULT r2 := r1, c2 := c1
return excelCell( r1, c1 ) + ":" + excelCell( r2, c2 )

//----------------------------------------------------------------------------//


static function SetExcelLanguage( oExcel )

   local aEng     := { 1033, 2057, 10249, 4105, 9225, 14345, 6153, 8201, 5129, 13321, 7177, 11273, 12297 }
   local aSpanish := {3082,1034,11274,16394,13322,9226,5130,7178,12298,17418,4106,18442,;
                     58378,2058,19466,6154,15370,10250,20490,21514,14346,8202}
   local aGerman  := {1031,3079,5127,4103,2055}
   local aFrench  := {1036,2060,11276,3084,9228,12300,15372,5132,13324,6156,14348,58380,8204,10252,4108,7180}

   local lLocal  := .f.

   if nxlLangID == nil
      if oExcel == nil

#ifdef __XHARBOUR__
         TRY
            oExcel   := GetActiveObject( "Excel.Application" )
         CATCH
            TRY
               oExcel   := CreateObject( "Excel.Application" )
            CATCH
               nxlLangID := 0
               return nil
            END
         END
         lLocal  := .t.
#else
         oExcel   := TOLEAuto():New( "Excel.Application" )
#endif
      endif

      nxlLangID := oExcel:LanguageSettings:LanguageID( 2 )
      do case
         case AScan( aEng, nxlLangID ) > 0 // English
            cxlTrue     := "TRUE"
            cxlFalse    := "FALSE"
            cxlSum      := "SUBTOTAL(9,"
            lxlEnglish  := .t.

         case AScan( aSpanish, nxlLangID ) > 0 // Spanish
            cxlTrue     := "VERDADERO"
            cxlFalse    := "FALSO"
            cxlSum      := "SUBTOTALES(9;"

         case nxlLangID == 1040 .or. nxlLangID == 2064 // Italian
            cxlTrue     := "VERO"
            cxlFalse    := "FALSO"
            cxlSum      := "SOMMA("

         case AScan( aGerman, nxlLangID ) > 0 // German
            cxlTrue     := "WAHR"
            cxlFalse    := "FALSCH"
            cxlSum      := "SUMME("

         case AScan( aFrench, nxlLangID ) > 0 // French
            cxlTrue     := "VRAI"
            cxlFalse    := "FAUX"
            cxlSum      := "SOMME("

         case nxlLangID == 2070 .or. nxlLangID == 1046 // Portugese
            cxlTrue     := "VERDADEIRO"
            cxlFalse    := "FALSO"
            cxlSum      := "SOMA("
         otherwise
            cxlTrue     := "=(1=1)"
            cxlFalse    := "=(1=0)"
      endcase
   endif


return nil

//----------------------------------------------------------------------------//

CLASS TXBrwColumn

   DATA oBrw,;          // Browse conteiner
        oDataFont,;     // Data font object, by default oBrw:oDataFont. It also supports a codeblock to return the font to use
        oHeaderFont,;   // Header font object, by default oBrw:oHeaderFont
        oFooterFont,;   // Footer font object, by default oBrw:oFooterFont
        oDragWnd,;      // Temporal window used for swaping columns
        oBtnList,;      // Button for edit with listbox
        oBtnElip,;      // Button for edit with user code-block
        oEditGet,;      // Get object for editing
        oEditLbx,;      // Listbox object for editing
        bPopUp,;        // PopupMenu on Right Click
        oBrush

   DATA aBitmaps        // Two dimension arrays that holds all the bitmaps added
                        // aBitmaps[n, 1] -> handle
                        // aBitmaps[n, 2] -> palette
                        // aBitmaps[n, 3] -> width
                        // aBitmaps[n, 4] -> heigth

   DATA aEditListTxt,;  // Array with all the literals to be shown on the Edit listbox
        aEditListBound  // Array with all the data to bound to the the edit get
                        // Wen this array is nil then aEditListTxt act as the bound array

   DATA bStrData,;      // String data codeblock (returns a string)
        bBmpData,;      // Ordinal bitmap data codeblock (returns a
        ;               // number in the range 1-len(aBitmaps))
        bIndent

   DATA bEditValue,;    // codeblock to retrieve the value of the edit, if nil then bstrData is used
        bEditValid,;    // codeblock to validate edit gets
        bEditWhen,;     // codeblock to allow edit
        bEditBlock;     // codeblock to evaluate for the  "..." button.
                        // If there is a Get active the value returned by the block is stuffed on the get

   DATA bOnPostEdit     // Code-block to be evaluated after the edition of the column.
                        // It receives ...

   DATA bLClickHeader,; // codeblock to be evaluated when left clicking on the header
        bRClickHeader,; // codeblock to be evaluated when right clicking on the header
        bLClickFooter,; // codeblock to be evaluated when left clicking on the footer
        bRClickFooter,; // codeblock to be evaluated when right clicking on the footer
        bLDClickData,;  // codeblock to be evaluated when left double clicking on the data
        bRClickData     // codeblock to be evaluated when right clicking on the data

   DATA bClrHeader,;    // default color pair for header
        bClrFooter,;    // default color pair for footer
        bClrStd,;       // default color pair for normal rows
        bClrSel,;       // default color pair for selected row
        bClrSelFocus,;  // default color pair for selected row when control has focus
        bClrEdit        // default color pair for edition

   DATA cHeader,;       // header string
        cFooter,;       // footer string
        cEditPicture,;  // Picture mask to be used for Get editing
        cOrder,;        // Used internally for autosorting (""->None, "A"->Ascending, "D"->Descending)
        cSortOrder,;    // indextag or oRs:fieldname or column number of array programmer need not code for sorting colimns
        cDataType, ;    // internally used:  data type of eval(bEditValue)
        cEditKeys, ;    // if not nil key matching the editkeys only triggers edit in lFastEdit mode
        bFooter         // Optional codeblock to calculate the footer containt

   DATA nWidth,;        // Column width
        nDisplayCol,;   // Actual column display value in pixels
        nCreationOrder,;// Ordinal creation order of the columns
        nResizeCol,;    // Internal value used for column resizing
        nPos            // Actual column position in the browse. If columns is not visible nPos == 0

   DATA nDataStrAlign,; // Data string alignment (left, center, right)
        nHeadStrAlign,; // Header string alignment (left, center, right)
        nFootStrAlign   // Footer string alignment (left, center, right)

   DATA nDataBmpAlign,; // Data bitmap alignment (left or right)
        nHeadBmpAlign,; // Header bitmap alignment (left or right)
        nFootBmpAlign   // Footer bitmap alignment (left or right)

   DATA nDataStyle,;    // Style for data string (DrawTextEx() flags)
        nHeadStyle,;    // Style for header string (DrawTextEx() flags)
        nFootStyle      // Style for footer string (DrawTextEx() flags)

   DATA nArrayCol AS NUMERIC INIT 0 // For Array Browse. Specifying Column Numer is all that is needed

   DATA nHeadBmpNo,;    // header ordinal bitmap to use of ::aBitmaps
        nFootBmpNo,;    // footer ordinal bitmap to use of ::aBitmaps
        nSortBmpNo ;    // used internally. not to be used in application
        AS NUMERIC

   DATA hEditType;      // 0-> None, 1-> Get, 2-> ListBox, 3-> User block
        AS NUMERIC;     // 4-> Get+ListBox, 5-> Get+User block
        HIDDEN          // For types 4 and 5 the buttons only update the edit value
                        // with the array aEditListBound on case 4 and with the value
                        // returned by the codeblock on case 5.
                        // It must be accesed through ::nEditType

   DATA lAllowSizing,;  // If .t. Column visual resizing is allowed
        lEditBorder,;   // If .t. Edit Get has border
        lHide,;         // If .t. the column is not visible
        lOnPostEdit,;   // .t. when OnPostEdit validating
        lBmpStretch ;   // If .t. and bStrData == nil, bitmap in sretched to fill the cell
        AS LOGICAL

   DATA lTotal AS LOGICAL INIT .F. // used by report and toexcel methods to include totals for the column
   DATA hChecked AS LOGICAL INIT .F.   // internal use only

   DATA Cargo           // For your own use

   METHOD New( oBrw )   // Creates a new instance of the class

   METHOD End()

   METHOD Edit( nKey )  // Goes to Edit mode (::nEditMode should be 1,2, 0 3)
                        // When nEditMode is greater than 0,this method is called
                        // automatically when doubleclicling with the mouse or pushing
                        // the Enter key. nKey is a first key to stuff into the Get
                        // Note: On multiline gets Ctrl+Enter is used to confirm the edition

   METHOD nEditType();  // Sets or Gets de Edit Mode
          SETGET        // 0=none, 1=Get, 2=Listbox, 3=block, 4=Get+Listbox, 5 = Get+block

   METHOD AddResource( cRes )  // Adds a new bitmap to the ::aBitmpas array giving his resource name
   METHOD AddBmpFile( cFile )  // Adds a new bitmap to the ::aBitmpas array giving his file name
   METHOD AddBmpHandle( hBmp ) // Adds a new bitmap to the ::aBitmpas array giving his bitmap handle

   METHOD DefStyle( nAlign,;  // Aid method to set the flag style for draw text operation
                lSingleLine ) // Draw Text operations are based on the Windows API function
                              // DrawTextEx(). This method receives two parameters: the alignment
                              // and if is a single line or multiline.

   METHOD Show() INLINE ( ::lHide := .f.,;             // Hides the column
                          ::oBrw:GetDisplayCols(),;
                          ::oBrw:Refresh() )

   METHOD Hide() INLINE ( ::lHide := .t.,;             // Shows the column
                          ::oBrw:GetDisplayCols(),;
                          ::oBrw:Refresh() )

   // The rest of the methods are used internally

   METHOD Adjust()

   METHOD HeaderHeight()
   METHOD HeaderWidth()
   METHOD FooterHeight()
   METHOD FooterWidth()
   METHOD DataHeight()
   METHOD DataWidth()

   METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC )
   METHOD PaintData( nRow, nCol, nHeight, lHighLite, lSelected, nOrder )
   METHOD EraseData( nRow, nCol, nHeight, hBrush, lFixHeight )
   METHOD Box( nRow, nCol, nHeight, lDotted)
   METHOD PaintFooter( nRow, nCol, nHeight, lInvert )
   METHOD RefreshFooter()
   METHOD footerStr()      // used internally
   METHOD IsVisible( lComplete ) INLINE ( ! ::lHide .and. ::oBrw:IsDisplayPosVisible( ::nPos, lComplete ) )

   METHOD HeaderLButtonDown( nRow, nCol, nFlags )
   METHOD HeaderLButtonUp( nRow, nCol, nFlags )
   METHOD FooterLButtonDown( nRow, nCol, nFlags )
   METHOD FooterLButtonUp( nRow, nCol, nFlags )
   METHOD MouseMove( nRow, nCol, nFlags )
   METHOD ResizeBeg( nRow, nCol, nFlags )
   METHOD ResizeEnd( nRow, nCol, nFlags )

   METHOD CreateButtons()
   METHOD ShowBtnList()
   METHOD RunBtnAction()
   METHOD PostEdit()

   METHOD SetCheck( aBmps, bOnPostEdit )
   METHOD SetAlign( nAlign )
   METHOD SetOrder()                      // used internally
   METHOD SortArrayData()                 // used internally
   METHOD ClpText
   METHOD isEditKey( nKey )               // used internally
   METHOD Value( uVal ) SETGET

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oBrw ) CLASS TXBrwColumn

   ::oBrw  := oBrw

   ::aBitmaps := {}

   ::cHeader := ""
   ::cFooter := ""
   ::cOrder  := ""

   ::nDisplayCol    := 0
   ::nCreationOrder := Len( oBrw:aCols ) + 1

   ::lAllowSizing := .t.
   ::lBmpStretch  := .f.

return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TXBrwColumn

   local nFor

   if ::oBtnList != nil
      ::oBtnList:End()
   endif

   if ::oBtnElip != nil
      ::oBtnElip:End()
   endif

   if ::oEditGet != nil
      ::oEditGet:End()
   endif

   for nFor := 1 to Len( ::aBitmaps )
      PalBmpFree( ::aBitmaps[ nFor, BITMAP_HANDLE ], ::aBitmaps[ nFor, BITMAP_PALETTE ] )
   next

return nil

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TXBrwColumn

   local nWid

   DEFAULT ::cOrder   := ""


   if ::oBrw:aArrayData != nil .AND. ::nArrayCol > 0
      // not checking upper bound .. shd result in runtime error
      DEFAULT ::bEditValue       := { |x| If( x != nil, ::oBrw:aRow[ ::nArrayCol ] := x, ), ::oBrw:aRow[ ::nArrayCol ] }
      DEFAULT ::bOnPostEdit      := { |o,x,n| If( n == 13, o:oBrw:aRow[ o:nArrayCol ] := x,) }

      nWid  := If( ::nWidth == nil, 30, ::nWidth )

      if ::bStrData == nil .and. ::bBmpData == nil
         if ::cEditPicture == nil
            ::bStrData   := { || If( Len( ::oBrw:aArrayData ) > 0, ;
                                      cValToChar( ::oBrw:aRow[ ::nArrayCol ] ), ;
                                      Space( nwid ) ) }
         else
            ::bStrData   := { || If( Len( ::oBrw:aArrayData ) > 0,  ;
                                      Transform( ::oBrw:aRow[ ::nArrayCol ], ::cEditPicture ), ;
                                      Space( nwid ) ) }
         endif
      endif

   endif

   if ::bEditValue != nil
      DEFAULT ::cDataType := valtype( EVAL( ::bEditValue ) )
      DEFAULT ::cDataType := 'C'

      if ::cDataType = "D"
         DEFAULT ::nDataStrAlign   := AL_RIGHT, ;
                 ::nHeadStrAlign   := AL_RIGHT, ;
                 ::cEditPicture    := "@D"
      endif

      if ::cDataType == "N"
         DEFAULT ::nDataStrAlign := AL_RIGHT, ;
                 ::nHeadStrAlign := AL_RIGHT, ;
                 ::nFootStrAlign := AL_RIGHT
      else
         ::lTotal := .F.
      endif

      if ::bStrData == nil .and. ::bBmpData == nil
         if ::cEditPicture == nil
            ::bStrData := { || cValToChar( Eval( ::bEditValue ) ) }
         else
            ::bstrData := { || Transform( Eval( ::bEditValue ), ::cEditPicture ) }
         endif
      endif

      if ::cSortOrder != nil
         ::AddBmpHandle( FwBmpAsc() )
         ::nSortBmpNo   := Len( ::aBitmaps )
         ::AddBmpHandle( FwBmpDes() )
         ::nHeadBmpAlign := AL_RIGHT
         ::nHeadBmpNo    := -1
         ::cOrder      := ""
         if ValType( ::cSortOrder ) != 'B'
            if ( ::oBrw:nDataType == DATATYPE_RDD )
               if EQ( (::oBrw:cAlias)->( OrdSetFocus() ), ::cSortOrder )
                  ::cOrder       := 'A'
                  ::nHeadBmpNo   := ::nSortBmpNo
               endif
            elseif ( ::oBrw:nDataType == DATATYPE_ADO )
               if EQ( ::oBrw:oRs:Sort, ::cSortOrder )
                  ::cOrder       := 'A'
                  ::nHeadBmpNo   := ::nSortBmpNo
               endif
            endif
         endif
      endif
   endif

   DEFAULT ::cDataType := 'C'

   DEFAULT ::oDataFont   := ::oBrw:oFont,;
           ::oHeaderFont := ::oBrw:oFont,;
           ::oFooterFont := ::oBrw:oFont

   DEFAULT ::nDataStrAlign := AL_LEFT,;
           ::nDataBmpAlign := AL_LEFT,;
           ::nHeadStrAlign := AL_LEFT,;
           ::nFootStrAlign := AL_LEFT,;
           ::nHeadBmpAlign := AL_LEFT,;
           ::nFootBmpAlign := AL_LEFT

   DEFAULT ::bClrHeader   := ::oBrw:bClrHeader,;
           ::bClrFooter   := ::oBrw:bClrFooter,;
           ::bClrStd      := ::oBrw:bClrStd,;
           ::bClrSel      := ::oBrw:bClrSel,;
           ::bClrSelFocus := ::oBrw:bClrSelFocus ,;
           ::bClrEdit     := ::bClrStd

   DEFAULT ::nWidth := Max( Max( ::HeaderWidth(),;
                                 ::FooterWidth() ),;
                            ::DataWidth() ) + COL_EXTRAWIDTH

   DEFAULT ::nDataStyle := ::DefStyle( ::nDataStrAlign, ( ::oBrw:nDataLines == 1 ) ),;
           ::nHeadStyle := ::DefStyle( ::nHeadStrAlign, ( ::oBrw:nHeaderLines == 1 ) ),;
           ::nFootStyle := ::DefStyle( ::nFootStrAlign, ( ::oBrw:nFooterLines == 1 ) )

   ::CreateButtons()

return nil

//----------------------------------------------------------------------------//

METHOD Value( uNew ) CLASS TXBrwColumn

   if PCount() > 0 .and. ::bEditValue != nil
         Eval( ::bEditValue, uNew )
   endif

return If( ::bEditValue == nil, Eval( ::bStrData ), Eval( ::bEditValue ) )

//----------------------------------------------------------------------------//

METHOD SetCheck( aBmps, bOnPostEdit ) CLASS TXBrwColumn

   local nBmpOn, nBmpOff := 0, nBmpNull := 0
   local LogiVal := .f.

   if Empty( ::nArrayCol )
      if ::bEditvalue != nil
         LogiVal := ( ValType( Eval( ::bEditvalue ) ) == "L" )
      endif
   else
      LogiVal := ( ValType( ::oBrw:aArrayData[ 1, ::nArrayCol ] ) == "L" )
   endif

   if LogiVal
      if If( ".bmp" $ Lower( aBmps[ 1 ] ), ::AddBmpFile ( aBmps[ 1 ] ), ::AddResource( aBmps[ 1 ] ) )
         nBmpOn      := Len( ::aBitMaps )
         if If( ".bmp" $ Lower( aBmps[ 2 ] ), ::AddBmpFile ( aBmps[ 2 ] ), ::AddResource( aBmps[ 2 ] ) )
            nBmpOff  := Len( ::aBitMaps )
         endif
         ::bBmpData  := { | u | If( ( u := Eval( ::bEditValue ) ) == nil, nBmpNull, If( u, nBmpOn, nBmpOff ) ) }
         ::hChecked  := .t.
         if bOnPostEdit != nil
            ::bOnPostEdit := bOnPostEdit
            ::nEditType   := EDIT_GET
         endif
      endif
   else
      MsgStop( "Method Valid only for logical values" )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetAlign( nAlign ) CLASS TXBrwColumn

   if ValType( nAlign ) == "N"
      nAlign      := MinMax( nAlign, 0, 2 )
      if nAlign != ::nDataStrAlign
         ::nDataStrAlign      := nAlign
         ::nDataStyle         := ::DefStyle( nAlign, ::oBrw:nDataLines == 1 )
         ::oBrw:Refresh()
      endif
   endif

Return Self

//----------------------------------------------------------------------------//

METHOD HeaderHeight() CLASS TXBrwColumn

   local nHeight

   nHeight := 0

   if !Empty( ::cHeader ) .and. ::oHeaderFont != nil
      nHeight := FontHeight( ::oBrw, ::oHeaderFont )
   endif

   if ::nHeadBmpNo > 0 .and. ::nHeadBmpNo <= Len( ::aBitmaps )
      nHeight := Max( nHeight, ::aBitmaps[ ::nHeadBmpNo, BITMAP_HEIGHT ] )
   endif

return nHeight

//----------------------------------------------------------------------------//

METHOD HeaderWidth() CLASS TXBrwColumn

   local cText, cLine
   local nWidth, nFrom, nLen, nFor, nTemp

   cText  := ::cHeader
   nWidth := 0
   nFrom  := 1

   if !Empty( cText )
       nLen  := Len( cText )
       While nFrom <= nLen
         cLine  := ExtractLine( cText, @nFrom )
         nWidth := Max( nWidth, ::oBrw:GetWidth( cLine, ::oHeaderFont ) )
       enddo
   endif

   if ::nHeadBmpNo > 0 .and. ::nHeadBmpNo <= Len( ::aBitmaps )
      nWidth += ::aBitmaps[ ::nHeadBmpNo, BITMAP_WIDTH ] + BMP_EXTRAWIDTH
   endif

   if ::nHeadBmpNo == -1
      nTemp := nWidth
      for nFor := 1 to Len( ::aBitmaps )
         nWidth := Max( nWidth, nTemp + ::aBitmaps[ nFor, BITMAP_WIDTH ] + BMP_EXTRAWIDTH )
      next
      ::nHeadBmpNo := 0
   endif

return Max( nWidth, 16 )

//----------------------------------------------------------------------------//

METHOD FooterHeight() CLASS TXBrwColumn

   local nHeight
   local cFooter

   nHeight := 0

   cFooter := ::footerStr()

   if cFooter != nil .and. ::oFooterFont != nil
      nHeight := FontHeight( ::oBrw, ::oFooterFont )
   endif

   if ::nFootBmpNo > 0 .and. ::nFootBmpNo <= Len( ::aBitmaps )
      nHeight := Max( nHeight, ::aBitmaps[ ::nFootBmpNo, BITMAP_HEIGHT ] )
   endif

return nHeight

//----------------------------------------------------------------------------//

METHOD FooterWidth() CLASS TXBrwColumn

   local cText, cLine
   local nWidth, nFrom, nLen

   cText  := ::footerStr()
   nWidth := 0
   nFrom  := 1

   if !Empty( cText )
       nLen  := Len( cText )
       While nFrom <= nLen
         cLine  := ExtractLine( cText, @nFrom )
         nWidth := Max( nWidth, ::oBrw:GetWidth( cLine, ::oFooterFont ) )
       enddo
   endif

   if ::nFootBmpNo > 0 .and. ::nFootBmpNo <= Len( ::aBitmaps )
      nWidth += ::aBitmaps[ ::nFootBmpNo, BITMAP_WIDTH ] + BMP_EXTRAWIDTH
   endif

return Max( nWidth, 16 )

//----------------------------------------------------------------------------//

METHOD DataHeight() CLASS TXBrwColumn

   local nHeight, nBmp, nBmpHeight

   nHeight := 0

   if ::bStrData != nil .and. ::oDataFont != nil
      if ValType( ::oDataFont ) == "B"
         nHeight := FontHeight( ::oBrw, Eval( ::oDataFont, Self ) )
      else
         nHeight := FontHeight( ::oBrw, ::oDataFont )
      endif
   endif

   if ::bBmpData != nil

      nBmpHeight   := 0
      AEval( ::aBitmaps, { |a| nBmpHeight := Max( nBmpHeight, a[ BITMAP_HEIGHT ] ) } )
      nHeight  := Max( nHeight, nBmpHeight )

   endif

return nHeight

//----------------------------------------------------------------------------//

METHOD DataWidth() CLASS TXBrwColumn

   local cText, cLine, oFont
   local nWidth, nFrom, nBmp, nLen
   local nBmpWidth

   nWidth := 0
   nFrom  := 1

   if ::bStrData != nil
      cText := Eval( ::bStrData )
      nLen  := Len( cText )
      if ValType ( ::oDataFont ) == "B"
         oFont = Eval( ::oDataFont, Self )
      else
         oFont = ::oDataFont
      endif
      while nFrom <= nLen
        cLine  := ExtractLine( cText, @nFrom )
        cLine  := Replicate( "B", Len( cLine ) )
        nWidth := Max( nWidth, ::oBrw:GetWidth( cLine, oFont ) )
      enddo

   endif

   if ::bBmpData != nil
      nBmpWidth   := 0
      AEval( ::aBitmaps, { |a| nBmpWidth := Max( nBmpWidth, a[ BITMAP_WIDTH ] ) } )
      nWidth   += nBmpWidth + BMP_EXTRAWIDTH
   endif

   if ::nEditType > 1
      nWidth += 15
   endif

return nWidth

//----------------------------------------------------------------------------//

METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC ) CLASS TXBrwColumn

   local hBrush
   local oFont
   local aColors, aBitmap
   local cHeader
   local nWidth, nBmpRow, nBmpCol, nBmpNo
   local lOwnDC, nBottom

   DEFAULT lInvert := .f.

   if ::bClrHeader == nil
      ::Adjust()
   endif

   if nCol != nil
      if nCol != 0
         ::nDisplayCol := nCol
      endif
   else
      nCol := ::nDisplayCol
   endif

   if ! lInvert
      aColors := Eval( ::bClrHeader )
   else
      aColors := { CLR_WHITE, CLR_BLUE }
   endif

   if hDC == nil
      hDC := ::oBrw:GetDC()
      lOwnDC := .f.
   else
      lOwnDC := .t.
   endif

   oFont   := ::oHeaderFont
   cHeader := ::cHeader
   nWidth  := ::nWidth
   nBmpNo  := ::nHeadBmpNo

   nBottom = nRow + ( nHeight / 3 )
   if ::oBrw:l2007
      if ! lInvert
         Gradient( hDC, { nRow - 1, nCol, nBottom, nCol + nWidth + 2 },;
                   nRGB( 219, 230, 244 ), nRGB( 207, 221, 239 ), .T. )
         Gradient( hDC, { nBottom + 1, nCol, nRow + nHeight - 1, nCol + nWidth },;
                   nRGB( 201, 217, 237 ), nRGB( 231, 242, 255 ), .T. )
      else
         Gradient( hDC, { nRow - 1, nCol, nBottom, nCol + nWidth },;
                   nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ), .T. )
         Gradient( hDC, { nBottom + 1, nCol, nRow + nHeight - 1, nCol + nWidth },;
                   nRGB( 255, 215, 84 ), nRGB( 255, 233, 162 ), .T. )
      endif
   else
      hBrush  := CreateSolidBrush( aColors[ 2 ] )
      FillRect( hDC, { nRow, nCol, nRow + nHeight, nCol + nWidth }, hBrush )
      DeleteObject( hBrush )
   endif

   nCol    += ( COL_EXTRAWIDTH / 2 )
   nWidth  -=  COL_EXTRAWIDTH
   nRow    += ( ROW_EXTRAHEIGHT / 2 )
   nHeight -=  ROW_EXTRAHEIGHT

   if nBmpNo > 0 .and. nBmpNo <= Len( ::aBitmaps )
      aBitmap := ::aBitmaps[ nBmpNo ]
      nWidth  -= aBitmap[ BITMAP_WIDTH ]
      if Empty(cHeader)
         nBmpCol := nCol + nwidth / 2
      elseif ::nHeadBmpAlign == AL_LEFT
         nBmpCol := nCol
         nCol    += aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
      else
         nBmpCol := nCol + nWidth
      endif
      nWidth  -= BMP_EXTRAWIDTH
      nBmpRow := ( nHeight - aBitmap[ BITMAP_HEIGHT ] ) / 2 + 4
      if ! ::oBrw:l2007
         PalBmpDraw( hDC, nBmpRow, nBmpCol,;
                     aBitmap[ BITMAP_HANDLE ],;
                     aBitmap[ BITMAP_PALETTE ],;
                     aBitmap[ BITMAP_WIDTH ],;
                     aBitmap[ BITMAP_HEIGHT ];
                     ,, .t., aColors[ 2 ] )
      else

         DEFAULT aBitmap[ BITMAP_ZEROCLR ] := GetZeroZeroClr( hDC, aBitmap[ BITMAP_HANDLE ] )
         SetBkColor( hDC, nRGB( 255, 255, 255 ) )
         TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                   aBitmap[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, nBmpWidth( aBitmap[ BITMAP_HANDLE ] ),;
                   nBmpHeight( aBitmap[ BITMAP_HANDLE ] ) )
      endif
   endif

   if Empty( cHeader )
      ::oBrw:ReleaseDC()
      return nil
   endif

   oFont:Activate( hDC )
   SetTextColor( hDC, aColors[ 1 ] )
   SetBkColor( hDC, aColors[ 2 ] )
   SetBkMode ( hDC, 1 ) // transparent
   DrawTextEx( hDC, cHeader,;
               {nRow, nCol, nRow + nHeight, nCol + nWidth},;
               ::nHeadStyle )
   oFont:Deactivate( hDC )

   if !lOwnDC
      ::oBrw:ReleaseDC()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD footerStr() CLASS TXBrwColumn

   local cFooter := "", cType

   if ::bFooter != nil
      cFooter  := Eval( ::bFooter, Self )
      DEFAULT cFooter := ""
   elseif ::cFooter != nil
      cFooter  := ::cFooter
   endif

   cType    := ValType( cFooter )
   if cType != "C"
      if cType == ::cDataType .and. ::cEditPicture != nil
         cFooter  := Transform( cFooter, ::cEditPicture )
      else
         cFooter := cValToChar( cFooter )
      endif
   endif

return cFooter

//----------------------------------------------------------------------------//

METHOD PaintFooter( nRow, nCol, nHeight, lInvert ) CLASS TXBrwColumn

   local hDC, hBrush
   local oFont
   local aColors, aBitmap
   local cFooter
   local nWidth, nBmpRow, nBmpCol, nBmpNo, nBottom

   DEFAULT lInvert := .f.

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif

   if !lInvert
      aColors := Eval( ::bClrFooter )
   else
      aColors := { CLR_WHITE, CLR_BLUE }
   endif

   hDC     := ::oBrw:GetDC()
   oFont   := ::oFooterFont
   cFooter := ::footerStr()
   nWidth  := ::nWidth
   nBmpNo  := ::nFootBmpNo

   nBottom = nRow + ( nHeight / 3 )
   if ::oBrw:l2007
      if ! lInvert
         Gradient( hDC, { nRow - 1, nCol, nBottom, nCol + nWidth + 2 },;
                   nRGB( 219, 230, 244 ), nRGB( 207, 221, 239 ), .T. )
         Gradient( hDC, { nBottom + 1, nCol, nRow + nHeight - 1, nCol + nWidth },;
                   nRGB( 201, 217, 237 ), nRGB( 231, 242, 255 ), .T. )
      else
         Gradient( hDC, { nRow - 1, nCol, nBottom, nCol + nWidth },;
                   nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ), .T. )
         Gradient( hDC, { nBottom + 1, nCol, nRow + nHeight - 1, nCol + nWidth },;
                   nRGB( 255, 215, 84 ), nRGB( 255, 233, 162 ), .T. )
      endif
   else
      hBrush  := CreateSolidBrush( aColors[ 2 ] )
      FillRect( hDC, {nRow, nCol, nRow + nHeight, nCol + nWidth}, hBrush )
      DeleteObject( hBrush )
   endif

   nCol    += ( COL_EXTRAWIDTH / 2 )
   nWidth  -=  COL_EXTRAWIDTH
   nRow    += ( ROW_EXTRAHEIGHT / 2 )
   nHeight -=  ROW_EXTRAHEIGHT

   if nBmpNo > 0 .and. nBmpNo <= Len( ::aBitmaps )
      aBitmap := ::aBitmaps[ nBmpNo ]
      nWidth  -= aBitmap[ BITMAP_WIDTH ]
      if Empty(cFooter)
         nBmpCol := nCol + nWidth / 2
      elseif ::nFootBmpAlign == AL_LEFT
         nBmpCol := nCol
         nCol    += aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
      else
         nBmpCol := nCol + nWidth
      endif
      nWidth  -= BMP_EXTRAWIDTH
      nBmpRow := nRow + ( nHeight - aBitmap[ BITMAP_HEIGHT ] ) / 2 + 2
      if ! ::oBrw:l2007
         PalBmpDraw( hDC, nBmpRow, nBmpCol,;
                     aBitmap[ BITMAP_HANDLE ],;
                     aBitmap[ BITMAP_PALETTE ],;
                     aBitmap[ BITMAP_WIDTH ],;
                     aBitmap[ BITMAP_HEIGHT ];
                     ,, .t., aColors[ 2 ] )
      else
         DEFAULT aBitmap[ BITMAP_ZEROCLR ] := GetZeroZeroClr( hDC, aBitmap[ BITMAP_HANDLE ] )
         SetBkColor( hDC, nRGB( 255, 255, 255 ) )
         TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                   aBitmap[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, nBmpWidth( aBitmap[ BITMAP_HANDLE ] ),;
                   nBmpHeight( aBitmap[ BITMAP_HANDLE ] ) )
      endif
   endif

   if Empty( cFooter )
      ::oBrw:ReleaseDC()
      return nil
   endif

   oFont:Activate( hDC )
   SetTextColor( hDC, aColors[ 1 ] )
   SetBkColor( hDC, aColors[ 2 ] )
   SetBkMode ( hDC, 1 ) // transparent
   DrawTextEx( hDC, cFooter,;
               {nRow, nCol, nRow + nHeight, nCol + nWidth},;
               ::nFootStyle )
   oFont:Deactivate( hDC )

   ::oBrw:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD RefreshFooter() CLASS TXBrwColumn

   if ! Empty( ::oBrw:nFooterHeight ) .and. ::IsVisible()
      ::PaintFooter(::oBrw:FooterRow()+1,nil,::oBrw:nFooterHeight-4)
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintData( nRow, nCol, nHeight, lHighLite, lSelected, nOrder ) CLASS TXBrwColumn

   local hDC, oBrush, hBrush, nOldColor
   local oFont
   local aColors, aBitmap
   local cData
   local nWidth, nBmpRow, nBmpCol, nBmpNo, nButtonRow, nButtonCol,;
         nRectWidth, nRectHeight, nRectCol, nStyle, nType, nIndent
   local lTransparent := .f.
   local lStretch     := .f.
   local lBrush       := .f.

   DEFAULT lHighLite := .f.,;
           lSelected := .f.,;
           nOrder    := 0

   if ( ::oEditGet != nil .and. nRow == ::oBrw:nRowSel ) .or. ::oEditLbx != nil .or. ::oBrw:nLen == 0
      return nil
   endif

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif

   if ::bStrData != nil
      cData := Eval( ::bStrData )
      if ! Empty( ::nDataStrAlign )
         cData := AllTrim( cData )
      endif
      if isrtf( cData )
         cData := "<RichText>"
      endif
   else
      cData := ""
   endif

   if ::bBmpData != nil
      nBmpNo := Eval( ::bBmpData )
   else
      nBmpNo := 0
   endif

   if lHighLite
      if ::oBrw:hWnd == GetFocus()
         if lSelected
            if nOrder == ::oBrw:nColSel
               aColors  := Eval( ::oBrw:bClrSelFocus )
            else
               acolors := Eval( If( ::oBrw:bClrRowFocus != nil, ::oBrw:bClrRowFocus, ::bClrSelFocus ) )
            endif
          else
            aColors := Eval( If( ::oBrw:bClrRowFocus != nil, ::oBrw:bClrRowFocus, ::bClrSelFocus ) )
          endif
      else
         aColors := Eval( ::bClrSel )
      endif
   else
      aColors := Eval( ::bClrStd )
      lTransparent := ( ::oBrw:lTransparent == .t. )
   endif

   hDC     := ::oBrw:GetDC()
   oFont   := ::oDataFont
   if ValType( oFont ) == "B"
      oFont = Eval( oFont, Self )
   endif
   nWidth  := ::nWidth

   if ::oBrush != nil
      if ValType( ::oBrush ) == "B"
         oBrush   := Eval( ::oBrush, Self )
      else
         oBrush   := ::oBrush
      endif
   endif
   if oBrush != nil
      hBrush      := oBrush:hBrush
      lBrush      := .t.
      lTransparent:= .f.
   elseif ! lTransparent
      hBrush  := CreateSolidBrush( aColors[ 2 ] )
   endif

   nStyle  := ::oBrw:nColDividerStyle
   nType   := ::nEditType

   if nStyle == 0
      nRectWidth := nWidth + 2
      nRectCol   := nCol
   elseif nStyle < 5 .and. nOrder > 1
      nRectWidth := nWidth + 1
      nRectCol   := nCol - 1
   else
      nRectWidth := nWidth
      nRectCol   := nCol
   endif

   nRectHeight := nRow + nHeight
   if ! lTransparent
      FillRect( hDC, {nRow, nRectCol, nRectHeight, Min( nRectCol + nRectWidth, ::oBrw:BrwWidth() - 4 ) }, hBrush )
   endif

   if ::bIndent != nil
      nIndent  := Eval( ::bIndent, Self )
      if ! Empty( nIndent )
         nCol   += nIndent
         nWidth -= nIndent
      endif
   endif

   nCol    += ( COL_EXTRAWIDTH / 2 )
   nWidth  -=  COL_EXTRAWIDTH
   nRow    += ( ROW_EXTRAHEIGHT / 2 )
   nHeight -=  ROW_EXTRAHEIGHT

   if nType > 1
      nButtonRow := nRow
      nButtonCol := nCol + nWidth - 10
      nWidth -= 15
   endif

   if nBmpNo > 0 .and. nBmpNo <= Len( ::aBitmaps )
      aBitmap := ::aBitmaps[ nBmpNo ]
      nWidth  -= aBitmap[ BITMAP_WIDTH ]
      if ::bStrData == nil
         nBmpCol  := Max( 0, nCol + nWidth / 2 )
         lStretch := ::lBmpStretch

      elseif ::nDataBmpAlign == AL_LEFT
         nBmpCol := nCol
         nCol    += aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
      else
         nBmpCol := nCol + nWidth
      endif
      nWidth  -= BMP_EXTRAWIDTH
      nBmpRow := nRow + ( ( nHeight - aBitmap[ BITMAP_HEIGHT ] ) / 2 )

      DEFAULT aBitmap[ BITMAP_ZEROCLR ] := GetZeroZeroClr( hDC, aBitmap[ BITMAP_HANDLE ] )

      if lStretch

         nOldColor  := SetBkColor( hDC, nRGB( 255, 255, 255 ) )
         TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                   aBitmap[ BITMAP_ZEROCLR ], hDC, nRectCol, nRow, Min( nRectWidth,::oBrw:BrwWidth() - nRectCol - 4 ), ;
                   nRectHeight - nRow )
         SetBkColor( hDC, nOldcolor )
/*
      elseif lTransparent .or. lBrush

         nOldColor := SetBkColor( hDC, nRGB( 255, 255, 255 ) )
         TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                   aBitmap[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, aBitmap[ BITMAP_WIDTH ], ;
                   aBitmap[ BITMAP_HEIGHT ] )
         SetBkColor( hDC, nOldColor )
*/

      else
         PalBmpDraw( hDC, nBmpRow, nBmpCol,;
                     aBitmap[ BITMAP_HANDLE ],;
                     aBitmap[ BITMAP_PALETTE ],;
                     aBitmap[ BITMAP_WIDTH ],;
                     aBitmap[ BITMAP_HEIGHT ];
                     ,, .t., aColors[ 2 ] )
      endif

   endif

   if !Empty( cData )
      oFont:Activate( hDC )
      SetTextColor( hDC, aColors[ 1 ] )
      if lTransparent .or. lBrush
         SetBkMode( hDC, 1 )
      else
         nOldColor := SetBkColor( hDC, aColors[ 2 ] )
      endif
      DrawTextEx( hDC, cData,;
                  {nRow, nCol, nRow + nHeight, Min( nCol + nWidth, ::oBrw:BrwWidth() - 5 ) },;
                  ::nDataStyle )
      if nOldColor != nil
         SetBkcolor( hDC, nOldColor )
         nOldColor := nil
      endif
      oFont:Deactivate( hDC )
   endif

   if nType > 1
      if lSelected
         WndBoxRaised(hDC, nButtonRow -1 , nButtonCol - 1,;
                     nButtonRow + nHeight, nButtonCol + 11 )
         if nType == EDIT_LISTBOX .or. nType == EDIT_GET_LISTBOX
            ::oBtnElip:Hide()
            ::oBtnList:Move( nButtonRow, nButtonCol, 11, nHeight, .f.)
            ::oBtnList:Show()
            ::oBtnList:GetDC()
            FillRect( hDC, {nButtonRow, nButtonCol,  nButtonRow + nHeight , nButtonCol + 11 },;
                      ::oBtnList:oBrush:hBrush )
            ::oBtnList:Paint()
            ::oBtnList:ReleaseDC()
         else
            ::oBtnList:Hide()
            ::oBtnElip:Move( nButtonRow, nButtonCol, 11, nHeight, .f.)
            ::oBtnElip:Show()
            ::oBtnElip:GetDC()
            FillRect( hDC, {nButtonRow, nButtonCol,  nButtonRow + nHeight , nButtonCol + 11 },;
                      ::oBtnElip:oBrush:hBrush )
            ::oBtnElip:Paint()
            ::oBtnElip:ReleaseDC()
         endif
      endif
   endif

   if hBrush != nil .and. ! lBrush
      DeleteObject( hBrush )
   endif

   ::oBrw:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD EraseData( nRow, nCol, nHeight, hBrush, lFixHeight ) CLASS TXBrwColumn

   local hDC
   local aColors
   local nWidth
   local lCreated

   DEFAULT lFixHeight := .f.

   lCreated := .f.

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif

   if hBrush == nil
      aColors  := Eval( ::bClrStd )
      hBrush   := CreateSolidBrush( aColors[ 2 ] )
      lCreated := .t.
   endif

   hDC     := ::oBrw:GetDC()
   nWidth  := ::nWidth

   if ::oBrw:nColDividerStyle < LINESTYLE_INSET
      nCol--
      nWidth++
   endif

   if ::oBrw:nColDividerStyle == LINESTYLE_NOLINES
      nWidth += 2
   endif

   if !lFixHeight .and. ::oBrw:nRowDividerStyle > LINESTYLE_NOLINES
      nHeight --
   endif

   if !lFixHeight .and. ::oBrw:nRowDividerStyle >= LINESTYLE_INSET
      nHeight --
   endif

   FillRect( hDC, {nRow, nCol, nRow + nHeight, nCol + nWidth}, hBrush )

   if lCreated
      DeleteObject( hBrush )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Box( nRow, nCol, nHeight, nType ) CLASS TXBrwColumn

   local hDC
   local nWidth

   DEFAULT nType := 1

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif

   hDC     := ::oBrw:GetDC()
   nWidth  := ::nWidth

   if ::nPos > 1 .and. ::oBrw:nColDividerStyle < LINESTYLE_INSET
      nCol--
      nWidth++
   endif

   do case
   case nType == 1 // dotted
      DrawFocusRect( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1 )
   case nType == 2 // solid
      WndBox( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1 )
   case nType == 3 // Raise
      WndBoxRaised( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1 )
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD AddResource( cResource ) CLASS TXBrwColumn

   local aBmpPal

   aBmpPal := PalBmpLoad( cResource )

   if aBmpPal[ BITMAP_HANDLE ] != 0
      Aadd(aBmpPal, nBmpWidth( aBmpPal[ BITMAP_HANDLE ] ) )
      Aadd(aBmpPal, nBmpHeight( aBmpPal[ BITMAP_HANDLE ] ) )
      Aadd(aBmpPal, nil )
      Aadd(::aBitmaps, aBmpPal )
      return .t.
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD AddBmpFile( cFile ) CLASS TXBrwColumn

   local aBmpPal

   aBmpPal := PalBmpRead( ::oBrw:GetDC(), cFile )

   ::oBrw:ReleaseDC()

   if aBmpPal[ BITMAP_HANDLE ] != 0
      Aadd(aBmpPal, nBmpWidth( aBmpPal[ BITMAP_HANDLE ] ) )
      Aadd(aBmpPal, nBmpHeight( aBmpPal[ BITMAP_HANDLE ] ) )
      Aadd(aBmpPal, nil )
      Aadd(::aBitmaps, aBmpPal )
      return .t.
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD AddBmpHandle( hBmp ) CLASS TXBrwColumn

   local aBmpPal

   aBmpPal := { hBmp, 0 }

   if aBmpPal[ BITMAP_HANDLE ] != 0
      Aadd(aBmpPal, nBmpWidth( aBmpPal[ BITMAP_HANDLE ] ) )
      Aadd(aBmpPal, nBmpHeight( aBmpPal[ BITMAP_HANDLE ] ) )
      Aadd(aBmpPal, nil )
      Aadd(::aBitmaps, aBmpPal )
      return .t.
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD DefStyle( nAlign, lSingleLine ) CLASS TXBrwColumn

   local nStyle

   nStyle := nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX )

   do case
   case nAlign == AL_LEFT
      nStyle  := nOr( nStyle, DT_LEFT )
   case nAlign == AL_RIGHT
      nStyle  := nOr( nStyle, DT_RIGHT )
   case nAlign == AL_CENTER
      nStyle  := nOr( nStyle, DT_CENTER )
   end case

   if lSingleLine
      nStyle := nOr( nStyle, DT_SINGLELINE, DT_VCENTER)
   else
      nStyle := nOr( nStyle, DT_WORDBREAK)
   endif

return nStyle

//----------------------------------------------------------------------------//

METHOD HeaderLButtonDown( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   if ::oBrw:nCaptured == 0 .and. ::oBrw:lAllowColSwapping
      ::oBrw:oCapCol   := Self
      ::oBrw:nCaptured := 1
      ::oBrw:Capture()
      ::PaintHeader( 2, nil, ::oBrw:nHeaderHeight - 3, .t. )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD HeaderLButtonUp( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   local oCol
   local nCol
   local lDragged

   lDragged := .f.

   if ::oDragWnd != nil
      ::oDragWnd:End()
      ::oDragWnd := nil
      lDragged := .t.
   endif

   ::PaintHeader( 2, nil, ::oBrw:nHeaderHeight - 3 )

   if !lDragged

      if nMRow <= ::oBrw:nHeaderHeight  ;
         .and. nMCol <= ( ::nWidth + ::nDisplayCol )

         if ::SetOrder()
            ::oBrw:Refresh()     //.T.)
         else
            ::PaintHeader( 2, nil, ::oBrw:nHeaderHeight - 3 )
         endif

         if ::bLClickHeader != nil
            Eval( ::bLClickHeader, nMRow, nMCol, nFlags, Self )
            ::PaintHeader( 2, nil, ::oBrw:nHeaderHeight - 3 )
         endif

      endif


   else

      nCol := ::oBrw:MouseColPos( nMCol )
      if nCol > 0
         oCol := ::oBrw:ColAtPos( nCol )
         if oCol:nCreationOrder != ::nCreationOrder
//            ::oBrw:SwapCols( Self, oCol )
            ::oBrw:MoveCol( Self, oCol, .t. )
         endif
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD FooterLButtonDown( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   if ::oBrw:nCaptured == 0 .and. ::blClickFooter != nil
      ::oBrw:oCapCol   := Self
      ::oBrw:nCaptured := 2
      ::oBrw:Capture()
      ::PaintFooter( ::oBrw:FooterRow()+ 1 , nil, ::oBrw:nFooterHeight - 4, .t. )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD FooterLButtonUp( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   ::PaintFooter( ::oBrw:FooterRow()+ 1 , nil, ::oBrw:nFooterHeight - 4)

   if ::bLClickFooter != nil .and. ;
      nMRow >= ::oBrw:FooterRow() .and. ;
      nMRow <= ( ::oBrw:FooterRow() + ::oBrw:nFooterHeight - 3 ) .and. ;
      nMCol >= ::nDisplayCol .and. ;
      nMCol <= ( ::nWidth + ::nDisplayCol )
      Eval( ::bLClickFooter, nMRow, nMCol, nFlags, Self )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ResizeBeg( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   local nCol, nWidth

   if ::oBrw:nCaptured == 0
      ::oBrw:oCapCol   := Self
      ::oBrw:nCaptured := 3
      ::oBrw:Capture()
      nCol   := ::nDisplayCol + ::nWidth
      nWidth := nCol + iif( ::oBrw:nColDividerStyle >= LINESTYLE_INSET, 3, 1)
      ::nResizeCol := nCol
      InvertRect( ::oBrw:GetDC(), { 0, nCol - 1 , ::oBrw:BrwHeight(),  nWidth + 1} )
      ::oBrw:ReleaseDC()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ResizeEnd( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   local nWidth

   if ::nResizeCol != nil
      nWidth := ::nResizeCol + iif( ::oBrw:nColDividerStyle >= LINESTYLE_INSET, 3, 1)
      InvertRect( ::oBrw:GetDC(), { 0, ::nResizeCol - 1, ::oBrw:BrwHeight(),  nWidth + 1 } )
      ::oBrw:ReleaseDC()
      if Abs( nMCol - ::nDisplayCol - ::nWidth ) > 2
         ::nWidth := Max( nMCol - ::nDisplayCol, 10 )
         ::oBrw:Refresh()
      endif
      ::nResizeCol := nil
   endif

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nMRow, nMCol, nFlags ) CLASS TXBrwColumn

   local nRow, nCol, nWidth
   local hDC

   do case
   case ::oBrw:nCaptured == 1 // header
      if ::oDragWnd == nil .and. ;
         nMRow <= ::oBrw:nHeaderHeight  .and. ;
         nMCol <= ( ::nWidth + ::nDisplayCol ) .and. ;
         nMCol >= ::nDisplayCol
         return nil
      endif

      if !::oBrw:lAllowColSwapping
         return nil
      endif

      nRow := 0
      nCol := nMCol - ( ::nWidth / 2 )

      if ::oDragWnd == nil
         ::PaintHeader( 2, nil, ::oBrw:nHeaderHeight - 3 )
         DEFINE WINDOW ::oDragWnd OF ::oBrw STYLE WS_CHILD
         ::oDragWnd:bPainted := {| hDC | ::PaintHeader( 0, 0, ::oBrw:nHeaderHeight, .t., hDC ),;
                                 WndRaised( ::oDragWnd:hWnd, hDC ) }
         ::oDragWnd:Move(nRow, nCol, ::nWidth, ::oBrw:nHeaderHeight)
         ACTIVATE WINDOW ::oDragWnd
      else
         ::oDragWnd:Move(nRow, nCol, ::nWidth, ::oBrw:nHeaderHeight, .t.)
      endif

   case ::oBrw:nCaptured == 3 // width
      CursorWE()
      if nMCol > ( ::nDisplayCol + 10 ) .and. nMCol < ( ::oBrw:BrwWidth() - 10 )
         hDC    := ::oBrw:GetDC()
         nWidth := iif( ::oBrw:nColDividerStyle >= LINESTYLE_INSET, 3, 1)
         if ::nResizeCol != nil
            InvertRect( hDC, { 0, ::nResizeCol - 1 , ::oBrw:BrwHeight(),  ::nResizeCol + nWidth + 1 } )
         endif
         ::nResizeCol := nMCol
         InvertRect( hDC, { 0, nMCol - 1, ::oBrw:BrwHeight(),  nMCol + nWidth + 1} )
         ::oBrw:ReleaseDC()
      endif

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD CreateButtons() CLASS TXBrwColumn

   local aColors

    if ::oBtnList != nil .and. ::oBtnElip != nil
        ::oBtnList:Hide()
        ::oBtnElip:Hide()
        return nil
    endif

   if ::oBrw:lCreated

      aColors := Eval( ::bClrHeader )

      if ::oBtnList != nil
         ::oBtnList:End()
      endif

      if ::oBtnElip != nil
         ::oBtnElip:End()
      endif

      @ 0,0 BTNBMP ::oBtnList RESOURCE "" OF ::oBrw NOBORDER SIZE 0,0
      ::oBtnList:hBitmap1 := FwDArrow()
      ::oBtnList:bAction := { || ::ShowBtnList() }
      ::oBtnList:SetFont( If( ValType( ::oDataFont ) == "B", Eval( ::oDataFont, Self ), ::oDataFont ) )
      ::oBtnList:SetColor( aColors[ 1 ], aColors[ 2 ] )

      @ 0,0 BTNBMP ::oBtnElip OF ::oBrw NOBORDER SIZE 0,0
      ::oBtnElip:cCaption := "..."
      ::oBtnElip:bAction := {|| ::RunBtnAction() }
      ::oBtnElip:SetFont( If( ValType( ::oDataFont ) == "B", Eval( ::oDataFont, Self ), ::oDataFont ) )
      ::oBtnElip:SetColor( aColors[ 1 ], aColors[ 2 ] )

      ::oBtnList:Hide()
      ::oBtnElip:Hide()

   endif

return nil

//----------------------------------------------------------------------------//

METHOD nEditType( nType ) CLASS TXBrwColumn

   if nType != nil
      ::hEditType := ntype
      ::CreateButtons()
   endif

return ::hEditType

//----------------------------------------------------------------------------//

METHOD IsEditKey( cKey ) CLASS TXBrwColumn

   local lEditKey := .f.

   if ValType( cKey ) == "N"
      cKey     := Upper( Chr( cKey ) )
   endif

   if ::cEditKeys != nil
      if cKey $ ::cEditKeys
         lEditKey := .t.
      endif
   else
      if ::cDataType $ "ND"
         if IsDigit( cKey ) .or. cKey == '-'
            lEditKey := .t.
         endif
      else
         if IsAlpha( cKey ) .or. IsDigit( cKey )
            lEditKey := .t.
         endif
      endif
   endif

return lEditKey

//----------------------------------------------------------------------------//

METHOD Edit( nKey ) CLASS TXBrwColumn

   local aColors
   local uValue
   local nRow, nCol, nWidth, nHeight
   local hBrush
   local lCenter, lRight

   if ::bOnPostEdit == nil
      MsgStop( "oCol:bOnPostEdit not defined",;
               "Fivewin: Class TXBrwColumn" )
      return .f.
   endif

   if ::nEditType == EDIT_LISTBOX
      return ::ShowBtnList( nKey )
    endif

    if ::nEditType == EDIT_BUTTON
        return ::RunBtnAction()
    endif

    if ::oEditGet != nil
        ::oEditGet:End()
    endif

   if ::bEditValue == nil
      ::bEditValue := ::bStrData
   endif

   DEFAULT ::cEditPicture := ""

   uValue  := Eval( ::bEditValue )
   aColors := Eval( ::bClrEdit )
   lCenter := ( ::nDataStrAlign == AL_CENTER )
   lRight  := ( ::nDataStrAlign == AL_RIGHT )

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight()

   hBrush := CreateSolidBrush( aColors[ 2 ] )
   ::EraseData( nRow, ::nDisplayCol, ::oBrw:nRowHeight , hBrush )
   DeleteObject( hBrush )

   if Empty( ::cEditPicture ) .and. ::oBrw:nDataLines > 1
      ::oEditGet := TMultiGet():New( 0,0,{ | u | If(PCount()==0,uValue,uValue:= u ) },;
                                    ::oBrw,0,0,,.F.,aColors[ 1 ],aColors[ 2 ];
                                    ,,.F.,,.F.,,lCenter,lRight,.F.,,,.F.,.T.,.T. )
   else
      ::oEditGet := TGet():New( 0,0,{ | u | If(PCount()==0,uValue,uValue:= u ) },;
                               ::oBrw,0,0,::cEditPicture,,aColors[ 1 ],aColors[ 2 ];
                               ,,.F.,,.F.,,.F.,,lCenter,lRight,,.F.,.f.,.T.,,.F.,,,,)
   endif

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight() + 2
   nCol    := ::nDisplayCol + 3
   nWidth  := ::nWidth - 4
   nHeight := ::oBrw:nRowHeight - 4

   if ::nEditType > 2
      nWidth -= 13
   endif

   if ::bEditValid != nil
      ::oEditGet:bValid := { | oGet, lRet | oGet:lValidating := .T., lRet := Eval( ::bEditValid, oGet, Self ), oGet:lValidating := .F., If( ! lRet, oGet:SetFocus(),), lRet }
   endif

   ::oEditGet:bKeyDown   := { | nKey | EditGetkeyDown( Self, nKey ) }
   ::oEditGet:bLostFocus := { | oGet, hWndFocus | EditGetLostFocus( oGet, hWndFocus, ::oBrw, ::oEditGet, Self ) }
   ::oEditGet:bChange    := { | k, f, o | ::oBrw:nLastKey := k, .t. }

   ::oEditGet:nLastKey := 0

   ::oEditGet:Move( nRow, nCol, nWidth, nHeight, .t. )
   ::oEditGet:SetFocus()
   ::oEditGet:SelectAll()

   ::oBrw:lEditMode := .T.

   if ::oBtnElip != nil
      ::oBtnElip:Refresh()
   endif

   if ::oBtnList != nil
      ::oBtnList:Refresh()
   endif

    if ::lEditBorder
      WndBoxIn( ::oBrw:GetDC(), nRow-1, nCol-1, nRow + nHeight + 1, nCol + nWidth + 1)
       ::oBrw:ReleaseDC()
   endif

    if nKey != nil
      PostMessage( ::oEditGet:hWnd, WM_CHAR, nKey )
    endif

   ::oBrw:nLastEditCol := ::nPos

return .t.

//----------------------------------------------------------------------------//

static function EditGetLostFocus( oGet, hWndFocus, oBrw, oEditGet, oCol )

   local oWnd

   // focus goes to another control in the same application, and not to the browse
   if ( oWnd := oWndFromHwnd( hWndFocus ) ) != nil .and. ! ( oWnd == oBrw ) .and. ;
      Upper( oWnd:ClassName() ) != "TGET"
      oBrw:CancelEdit()
      SetFocus( hWndFocus )
      return nil
   endif

   // focus goes to another application
   if GetWindowThreadProcessId( hWndFocus ) != GetWindowThreadProcessId( oBrw:hWnd )
      oBrw:CancelEdit()
      return nil
   endif

   if oEditGet != nil .and. ! oEditGet:lValidating
      oCol:PostEdit()
   endif

return nil

//----------------------------------------------------------------------------//

static function EditGetkeyDown( Self, nKey )

   local lExit

   lExit := .f.

   do case
      case nKey == VK_ESCAPE
           lExit := .t.
           ::oEditGet:bValid = nil

      case nKey == VK_RETURN
           if Empty( ::cEditPicture ) .and. ::oBrw:nDataLines > 1
              if ! GetKeyState( VK_CONTROL )
                 lExit := .t.
              endif
           else
              lExit := .t.
           endif
   endcase

   If lExit
      ::oEditGet:nLastKey := nKey
      ::oEditGet:End()
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowBtnList( nKey ) CLASS TXBrwColumn

   local aBound
   local xValue
   local hBrush
   local nAt, nRow, nCol, nWidth, nHeight

   if ::aEditListTxt == nil
      MsgStop( "oCol:aEditListTxt not defined", "Fivewin: Class TXBrwColumn" )
      return .f.
   endif

   if ::bOnPostEdit == nil
      MsgStop( "oCol:bOnPostEdit not defined",;
               "Fivewin: Class TXBrwColumn" )
      return .f.
   endif

   ::oBrw:nColSel := ::nPos

   if ::bEditValue == nil
      ::bEditValue := ::bStrData
   endif

   nAt     := Ascan( ::aEditListBound, Eval( ::bEditValue ) )
   nRow    := ( ::oBrw:nRowSel * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight() - 1
   nCol    := ::nDisplayCol - 2
   nWidth  := ::nWidth + 3
   nHeight := Len( ::aEditListTxt ) * ( FontHeight( ::oBrw, ::oBrw:oFont ) ) + 2

   If nRow + nHeight > ::oBrw:BrwHeight()
      If (::oBrw:BrwHeight() - nRow) < ::oBrw:nRowHeight
         do while ( nRow -  nHeight - ::oBrw:nRowHeight + 1 ) < 0
            nHeight -= FontHeight( ::oBrw, ::oBrw:oFont )
         enddo
         nRow :=  nRow - nHeight - ::oBrw:nRowHeight + 1
      else
         nHeight := ::oBrw:BrwHeight() - nRow
      Endif
   Endif

   if ::aEditListBound == nil
      aBound := Array( Len( ::aEditListTxt ) )
      AEval( aBound, {|v,e| aBound[ e ] := e } )
   else
      aBound := ::aEditListBound
   endif

   if ::oEditGet != nil
      ::oEditGet:End()
      ::oEditGet := nil
      hBrush := CreateSolidBrush( Eval( ::bClrSel )[ 2 ] )
      ::EraseData( ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight(),;
                  ::nDisplayCol, ::oBrw:nRowHeight , hBrush )
      DeleteObject( hBrush )
   endif

   @ 0, 0 LISTBOX ::oEditLbx VAR nAt OF ::oBrw SIZE 0,0 ITEMS ::aEditListTxt

   ::oEditLbx:bLostFocus := { | oLbx, hWndFocus | ::PostEdit( aBound[ Max( 1, nAt ) ], .t. ) } // iif(::oEditLbx != nil, ::oEditLbx:End(),) } A.L. Nov 2007

   ::oEditLbx:bLButtonUp := {|| ::oEditLbx:Change(), ::oEditLbx:nLastKey := VK_RETURN,;
                                ::PostEdit( aBound[ nAt ], .t. ) }

   ::oEditLbx:bKeyDown   := {|k| ::oEditLbx:nLastKey := k,;
                                   If( k == VK_RETURN .and. nAt > 0,  xValue := aBound[ nAt ], ),;
                                 If( k == VK_RETURN .or. k == VK_ESCAPE, ::PostEdit( xValue, .t. ), ) }

   ::oEditLbx:Move( nRow, nCol, nWidth, nHeight, .t. )
   ::oEditLbx:SetFocus()

   ::oBrw:lEditMode := .T.

return .T.

//----------------------------------------------------------------------------//

METHOD RunBtnAction() CLASS TXBrwColumn

   local nRow, nCol
   local hBrush

   if ::bEditBlock == nil
      MsgStop("oCol:bEditBlock not defined", "Fivewin: Class TXBrwColumn")
      return .f.
   endif

   ::oBrw:nColSel := ::nPos

   if ::oEditGet != nil
      ::oEditGet:End()
      ::oEditGet := nil
      hBrush := CreateSolidBrush( Eval( ::bClrSel )[ 2 ] )
      ::EraseData( ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight(),;
                  ::nDisplayCol, ::oBrw:nRowHeight , hBrush )
      DeleteObject( hBrush )
   endif

   nRow := ( ::oBrw:nRowSel * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight() - 3
   nCol := ::nDisplayCol

   ::PostEdit( Eval( ::bEditBlock, nRow, nCol, Self ), .t. )

return .t.

//----------------------------------------------------------------------------//

METHOD PostEdit( xValue, lButton ) CLASS TXBrwColumn

   local lGoNext := .f.

   If ::lOnPostEdit
      return nil
   Endif

   ::lOnPostEdit := .t.

   DEFAULT lButton := .f.

   do case
      case ::nEditType == EDIT_GET
           if ::oEditGet != nil
              Eval( ::bOnPostEdit, Self, Eval( ::oEditGet:bSetGet ), ::oEditGet:nLastKey )
              lGoNext := ( ::oEditGet:nLastKey == VK_RETURN )
              ::oEditGet:End()
              ::oEditGet := nil
           endif

      case ::nEditType == EDIT_LISTBOX
           Eval( ::bOnPostEdit, Self, xValue, ::oEditLbx:nLastKey )
           if ::oEditLbx != nil .and. IsWindow( ::oEditLbx:hWnd )
              ::oEditLbx:End()
              ::oEditLbx := nil
           endif

      case ::nEditType == EDIT_BUTTON
           if ::bOnPostEdit != nil
              Eval( ::bOnPostEdit, Self, xValue, 0 )
           endif

      case ::nEditType == EDIT_GET_LISTBOX
           if ::oEditLbx != nil .and. IsWindow( ::oEditLbx:hWnd )
              ::oEditLbx:End()
              ::oEditLbx := nil
           endif
           if ! lButton
              if ::oEditGet != nil
                 Eval( ::bOnPostEdit, Self, Eval( ::oEditGet:bSetGet ), ::oEditGet:nLastKey )
                 lGoNext := ( ::oEditGet:nLastKey == VK_RETURN )
                 ::oEditGet:End()
                 ::oEditGet := nil
              endif
           elseif xValue != nil
              Eval( ::bOnPostEdit, Self, xValue, 0 )
           endif

      case ::nEditType == EDIT_GET_BUTTON
           if ! lButton
              if ::oEditGet != nil
                 Eval( ::bOnPostEdit, Self, Eval( ::oEditGet:bSetGet ), ::oEditGet:nLastKey )
                 lGoNext := ( ::oEditGet:nLastKey == VK_RETURN )
                 ::oEditGet:End()
                 ::oEditGet := nil
              endif
           elseif xValue != nil
              if ::bOnPostEdit != nil
                 Eval( ::bOnPostEdit, Self, xValue, 0 )
              endif
           endif
   endcase

   ::oBrw:SetFocus()
   if Empty( ::cOrder )
      ::oBrw:DrawLine( .t. )
   else
      ::oBrw:Refresh()
   endif

   if ::cDataType == "N" .and. ( ::cFooter != nil .or. ::bFooter != nil )
      ::RefreshFooter()
   endif

   ::lOnPostEdit := .f.

   If lGoNext
      ::oBrw:GoNextCtrl()
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD SetOrder() CLASS TXBrwColumn

   LOCAL   lSorted   := .F.
   LOCAL   n, oCol, cSort, uRet

   if ::cSortOrder != nil

      if ValType( ::cSortOrder ) == "B"
         uRet  := Eval( ::cSortOrder, Self )
         lSorted := ( ValType( uRet ) == 'C' .and. Upper( uRet ) $ 'AD' )
         if lSorted
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrW:aCols[ n ]
               oCol:cOrder      := " "
            Next n
            ::cOrder       := Upper( uRet )
         endif

      elseif ::oBrw:nDataType == DATATYPE_ARRAY
         ::SortArrayData()

      elseif nAnd( ::oBrw:nDataType, DATATYPE_ADO ) == DATATYPE_ADO .and. ;
         ::oBrw:oRs != nil

         cSort   := Upper( ::oBrw:oRs:Sort )
         cSort   := TRIM( StrTran( StrTran( cSort, 'DESC', '' ), 'ASC', '' ) )
         if EQ( cSort, ::cSortOrder )
            // Asc -> Desc or Desc -> Asc
            if ::cOrder == 'D'
               ::oBrw:oRs:Sort   := ::cSortOrder
               ::cOrder          := 'A'
            else
               ::oBrw:oRs:Sort   := ::cSortOrder + " DESC"
               ::cOrder          := 'D'
            endif
            lSorted      := .T.
         else
            // Asc Sort
            ::oBrw:oRs:Sort      := ::cSortOrder
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrW:aCols[ n ]
               oCol:cOrder       := " "
            Next n
            ::cOrder             := 'A'
            lSorted              := .T.
         endif

      elseif nAnd( ::oBrw:nDataType, DATATYPE_ODBF ) == DATATYPE_ODBF .and. ;
         ValType( ::cSortOrder ) == 'C'

         if !Eq( ::oBrw:oDbf:SetOrder(), ::cSortOrder )
            ::oBrw:oDbf:SetOrder( ::cSortOrder )
            lSorted  := .t.
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrw:aCols[ n ]
               oCol:cOrder      := " "
            Next n
            ::cOrder           := 'A'
         endif

      elseif ValType( ::oBrw:cAlias ) == 'C' .and. ValType( ::cSortOrder ) == 'C'

         // if !Eq( ( ::oBrw:cAlias )->( OrdSetFocus() ), ::cSortOrder )

            ( ::oBrw:cAlias )->( OrdSetFocus( ::cSortOrder ) )

            lSorted                 := .t.
            for n := 1 to Len( ::oBrw:aCols )
               oCol                 := ::oBrw:aCols[ n ]
               oCol:cOrder          := " "
               if oCol:nHeadBmpNo == ::nSortBmpNo
                  oCol:nHeadBmpNo   := 0
               end if
            next n
            ::nHeadBmpNo            := ::nSortBmpNo
            ::cOrder                := 'D'

         // end if

         /*
         if Eq( (::oBrw:cAlias)->( OrdSetFocus() ), ::cSortOrder )

            (::oBrw:cAlias)->( OrdDescend( , , ! OrdDescend() ) )
            ::cOrder             := If( ( ::oBrw:cAlias )->( OrdDescend() ), 'D', 'A' )
            lSorted              := .t.

         else

            (::oBrw:cAlias)->( OrdSetFocus( ::cSortOrder ) )
            lSorted   := .T.
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrw:aCols[ n ]
               oCol:cOrder      := " "
            Next n
            ::cOrder           := If( ( ::oBrw:cAlias )->( OrdDescend() ), 'D', 'A' )

         endif
         */

      endif

   endif

   if lSorted
      ::oBrw:cSeek   := ""
   endif

return lSorted

/*
METHOD   SetOrder() CLASS TXBrwColumn

   LOCAL   lSorted   := .F.
   LOCAL   n, oCol, cSort, uRet

   if ::cSortOrder != nil
      if ValType( ::cSortOrder ) == "B"
         uRet  := Eval( ::cSortOrder, Self )
         lSorted := ( uRet == .t. .or. uRet == "A" .or. uRet == "D" )
         if lSorted
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrW:aCols[ n ]
               oCol:nHeadBmpNo   := 0
               oCol:cOrder      := " "
            Next n
            ::cOrder       := If( uRet == "D", "D", "A" )
            ::nHeadBmpNo   := ::nSortBmpNo + If( ::cOrder == "A", 0, 1 )
         endif
      elseif ::oBrw:nDataType == DATATYPE_RDD .AND. ;
         ::oBrw:cAlias != nil .AND. .NOT. EQ( (::oBrw:cAlias)->(OrdSetFocus()), ::cSortOrder )

         (::oBrw:cAlias)->( OrdSetFocus( ::cSortOrder ) )
         lSorted   := .T.
         For n := 1 TO Len(::oBrw:aCols)
            oCol   := ::oBrw:aCols[ n ]
            oCol:nHeadBmpNo   := 0
            oCol:cOrder      := " "
         Next n
         ::nHeadBmpNo       := ::nSortBmpNo
         ::cOrder           := 'A'
      elseif ::oBrw:nDataType == DATATYPE_ADO
         cSort   := Upper( ::oBrw:oRs:Sort )
         cSort   := TRIM( StrTran( StrTran( cSort, 'DESC', '' ), 'ASC', '' ) )
         if EQ( cSort, ::cSortOrder )
            // Asc -> Desc or Desc -> Asc
            if ::cOrder == 'D'
               ::oBrw:oRs:Sort   := ::cSortOrder
               ::nHeadBmpNo      := ::nSortBmpNo
               ::cOrder          := 'A'
            else
               ::oBrw:oRs:Sort   := ::cSortOrder + " DESC"
               ::nHeadBmpNo      := ::nSortBmpNo + 1
               ::cOrder          := 'D'
            endif
            lSorted      := .T.
         else
            // Asc Sort
            ::oBrw:oRs:Sort      := ::cSortOrder
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrW:aCols[ n ]
               oCol:nHeadBmpNo   := 0
               oCol:cOrder       := " "
            Next n
            ::nHeadBmpNo         := ::nSortBmpNo
            ::cOrder             := 'A'
            lSorted              := .T.
         endif
      elseif ::oBrw:nDataType == DATATYPE_ARRAY
         ::SortArrayData()
      endif
   endif

return lSorted
*/
//----------------------------------------------------------------------------//

METHOD SortArrayData()  CLASS TXBrwColumn

   local aCols
   local cOrder
   local nAt, nFor, nLen

   aCols  := ::oBrw:aCols
   cOrder := ::cOrder
   nAt    := ::nArrayCol      // ::nCreationOrder  // changed
   nLen   := Len( aCols )

   for nFor := 1 to nLen
      if aCols[ nFor ]:nArrayCol != ::nArrayCol
         aCols[ nFor ]:nHeadBmpNo := 0
         aCols[ nFor ]:cOrder := ""
      endif
   next

   if cOrder == 'A'
      ::oBrw:aArrayData := Asort( ::oBrw:aArrayData,,, {|x,y| x[ nAt ] > y[ nAt ] } )
      ::cOrder     := "D"
      ::nHeadBmpNo := ::nSortBmpNo + 1
   else
      ::oBrw:aArrayData := Asort( ::oBrw:aArrayData,,, {|x,y| x[ nAt ] < y[ nAt ] } )
      ::cOrder     := "A"
      ::nHeadBmpNo := ::nSortBmpNo
   endif

   ::oBrw:Refresh()

return self
//---------------------------------------------------------------------------//

METHOD ClpText() CLASS TXBrwColumn

   local RetVal    := ""
   local cDtFmt, cTmFmt

   if nxlLangID == nil
      SetExcelLanguage()
   endif

   if ::bEditValue == nil
      if ::bStrData == nil
         RetVal   := ""
      else
         RetVal   := AllTrim( Eval( ::bStrData ) )
      endif
   else
      RetVal       := ::Value()

	  if ::cDataType == 'P' .or. ::nEditType < 0
         RetVal    := ""
      elseif ::cDataType == 'D'

         cDtFmt    := Set( _SET_DATEFORMAT )
         Set( _SET_DATEFORMAT, "YYYY-MM-DD" )
         RetVal   := DTOC( RetVal )
         Set(_SET_DATEFORMAT, cDtFmt )

#ifdef __XHARBOUR__
      elseif ::cDataType == 'T'

         cDtFmt    := Set( _SET_DATEFORMAT )
         cTmFmt    := Set( _SET_TIMEFORMAT )
         Set( _SET_DATEFORMAT, "YYYY-MM-DD" )
         Set( _SET_TIMEFORMAT, "HH:MM:SS" )
         RetVal   := TTOC( RetVal )
         Set( _SET_TIMEFORMAT, cTmFmt )
         Set( _SET_DATEFORMAT, cDtFmt )
#endif

      elseif ::cDataType == 'L'

         RetVal    := If( RetVal == nil, "", If( RetVal, cxlTrue, cxlFalse ) )

      else

         RetVal    := cValToChar( RetVal )

		 if !lxlEnglish
		 	RetVal := StrTran( RetVal, ".", "," )
		 end if

      endif

   endif

return RetVal

/*
METHOD ClpText() CLASS TXBrwColumn

   local RetVal    := ""
   local cDtFmt, cTmFmt

   if nxlLangID == nil
      SetExcelLanguage()
   endif

   if ::bEditValue == nil
      if ::bStrData == nil
         RetVal   := ""
      else
         RetVal   := AllTrim( Eval( ::bStrData ) )
      endif
   else
      RetVal       := Eval( ::bEditValue )
      if ::cDataType == "D"

         cDtFmt    := Set( _SET_DATEFORMAT )
         Set( _SET_DATEFORMAT, "YYYY-MM-DD" )

         #ifdef __XHARBOUR__
            if hb_IsDateTime( RetVal )
               cTmFmt    := Set( _SET_TIMEFORMAT )
               Set(_SET_TIMEFORMAT, "HH:MM:SS" )
               RetVal   := TTOC( RetVal )
               Set(_SET_TIMEFORMAT, cTmFmt )
            else
         #endif
               RetVal   := DTOC( RetVal )
         #ifdef __XHARBOUR__
            endif
         #endif

         Set(_SET_DATEFORMAT, cDtFmt )

      elseif ::cDataType == "L"

         RetVal    := If( RetVal == nil, "", If( RetVal, cxlTrue, cxlFalse ) )

      else

         RetVal    := cValToChar( RetVal )

      endif
   endif


return RetVal
*/

//----------------------------------------------------------------------------//
// Support functions for TXBrwColumn
//----------------------------------------------------------------------------//

static function GetZeroZeroClr( hDC, hBmp )

    local hDCMem, hOldBmp, nZeroZeroClr

    hDCMem = CreateCompatibleDC( hDC )
    hOldBmp = SelectObject( hDCMem, hBmp )
    nZeroZeroClr = GetPixel( hDCMem,0,0)
    SelectObject( hDCMem, hOldBmp )
    DeleteDC( hDCMem )

return nZerozeroClr

//----------------------------------------------------------------------------//

static function FontHeight( oBrw, oFont )

   local hDC
   local nHeight

   hDC := oBrw:GetDC()
   oFont:Activate( hDC )
   nHeight := GetTextHeight( oBrw:hWnd, hDC )
   oBrw:ReleaseDC()

return nHeight

//----------------------------------------------------------------------------//

function ExtractLine( cText, nFrom )

  local cLine, nAt

  nAt := At( CRLF, SubStr( cText, nFrom ) )

  if nAt > 0
    cLine := Substr( cText, nFrom, nAt - 1 )
    nFrom += nAt + 1
  else
    cLine := Substr( cText, nFrom )
    nFrom := Len( cText ) + 1
  endif

return cLine

//----------------------------------------------------------------------------//

static function EQ( uFirst, uSecond, lExact )

LOCAL   c

   DEFAULT lExact := .t.

   if ( C := valtype( uFirst ) ) == valtype( uSecond )
      if c == 'C'
         if lExact
            if Upper(alltrim(uFirst)) == Upper(alltrim(uSecond))
               return .t.
            endif
         else
            if Upper(alltrim(uFirst)) = Upper(alltrim(uSecond))
               return .t.
            endif
         endif
      else
         if uFirst == uSecond
            return .t.
         endif
      endif
   endif

return .f.

//---------------------------------------------------------------------------//
// Support functions for Commands in xbrowse.ch
//----------------------------------------------------------------------------//

function XbrowseNew( oWnd, nRow, nCol, nWidth, nHeight,;
                     aFlds, aHeaders, aColSizes,  ;
                     bChange, bLDblClick, bRClick, ;
                     oFont, oCursor, nClrFore, nClrBack, ;
                     cMsg, lUpdate, cDataSrc, bWhen, ;
                     lDesign, bValid, lPixel, nResID, lAutoSort, lAddCols, ;
                     aPics, aCols, aJust, aSort )

   local oBrw, n, i, oCol

   oBrw            := TXBrowse():New( oWnd )
   oBrw:lAutoSort  := lAutoSort
   oBrw:bLDblClick := bLDblClick
   oBrw:bRClicked  := bRClick

   XbrwSetDataSource( oBrw, cDataSrc, lAddCols, lAutoSort, aCols  )

   DEFAULT aHeaders := {}, aPics := {}, aColSizes := {}, aSort := {}

   if ! Empty( aFlds )
      for n := 1 to Len( aFlds )
         oBrw:AddCol():bEditValue   := aFlds[ n ]
      next
   endif

   for i := 1 to Len( oBrw:aCols )
      oCol  := oBrw:aCols[ i ]
      if Len( aPics ) >= i .and. ! Empty( aPics[ i ] )
         oCol:cEditPicture := aPics[ i ]
      endif
      if Len( aHeaders ) >= i .and. ! Empty( aHeaders[ i ] )
         oCol:cHeader   := aHeaders[ i ]
      endif
      if Len( aColSizes ) >= i
         oCol:nWidth    := aColSizes[ i ]
      endif
      if Len( aSort ) >= i .and. ! Empty( aSort[ i ] )
         oCol:cSortOrder := aSort[ i ]
      endif
   next

   if valtype( nClrFore ) == 'N'
      DEFAULT nClrBack := CLR_WHITE
      oBrw:bClrStd := {|| {nClrFore, nClrBack} }
   endif

   oBrw:bChange       := bChange
   if oFont != nil
      oBrw:oFont      := oFont
   endif
   if bWhen != nil
      oBrw:bWhen      := bWhen
   endif
   if bValid != nil
      oBrw:bValid     := bValid
   endif
   if oCursor != nil
      oBrw:oCursor    := oCursor
   endif
   if cMsg != nil
      oBrw:cMsg       := cMsg
   endif

   oBrw:lDesign       := lDesign

   if ValType( nResID ) == "N"
      oBrw:CreateFromResource( nResID )
   else
      if nRow != nil
         oBrw:nTop       := nRow * If( lPixel, 1, BRSE_CHARPIX_H ) // 14
      endif

      if nCol != nil
         oBrw:nLeft      := nCol * If( lPixel, 1, BRSE_CHARPIX_W )  //8
      endif

      if nWidth != nil
         oBrw:nRight     := oBrw:nLeft + nWidth - 1
      endif

      if nHeight != nil
         oBrw:nBottom    := oBrw:nTop + nHeight - 1
     endif
   endif

   if ! Empty( aJust )
      xbrJustify( oBrw, aJust )
   endif

return oBrw

//--------------------------------------------------------------------------//

static function XbrwSetDataSource( oBrw, uDataSrc, lAddCols, lAutoSort, aCols  )

   local cType    := ValType( uDataSrc )

   if ! Empty( aCols )
      lAddCols    := .t.
   endif

   if cType == "C"

      if Select( uDataSrc ) > 0
         oBrw:cAlias    := uDataSrc
         oBrw:nDataType := DATATYPE_RDD
         if lAddCols .or. ! Empty( aCols )
            oBrw:SetRDD( lAddCols, lAutoSort, aCols )
         endif
      endif

   elseif cType == "A"

      oBrw:aArrayData   := uDataSrc
      oBrw:nDataType    := DATATYPE_ARRAY
      if lAddCols .or. ! Empty( aCols )
         oBrw:SetArray( uDataSrc, lAutoSort, 1, aCols )
      else
         oBrw:SetArray( uDataSrc, nil, nil, .f. )
      endif

   elseif cType == "O"

      if Upper( uDataSrc:ClassName ) == "TOLEAUTO"

         oBrw:nDataType := DATATYPE_ADO
         oBrw:oRs       := uDataSrc
         if lAddCols .or. ! Empty( aCols )
            oBrw:SetADO( uDataSrc, lAddCols, lAutoSort, aCols )
         endif

      else
         oBrw:SetoDbf( uDataSrc, aCols )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

function XbrwAddColumn( oBrw, cHead, bData, cPic, uClrFore, uClrBack, ;
                              cAlign, nWidth, lBitmap, lEdit, bOnPostEdit,  ;
                                cMsg, bWhen, bValid, cErr, lHilite, ncOrder, nAt )

   local oCol, uTemp

   if ValType( nAt ) == "O" .and. Upper( nAt:className ) == "TXBRWCOLUMN"
      nAt   := nAt:nCreationOrder
   endif
   if ValType( nAt ) == "N" .and. nAt > 0 .and. nAt <= Len( oBrw:aCols )
      oCol  := oBrw:InsCol( nAt )
   else
      oCol := oBrw:AddCol()
   endif

   oCol:cHeader      := cHead
   oCol:cEditPicture := cPic

   if bData != nil
      if ValType( bData ) == "N"
         oCol:nArrayCol := bData
      else
         oCol:bEditValue   := bData
      endif
   endif

   if cAlign != nil
      cAlign            := iif( cAlign = 'R', AL_RIGHT, iif( cAlign = 'C', AL_CENTER, nil ) )
      if cAlign != nil
         oCol:nHeadStrAlign := oCol:nDataStrAlign := oCol:nFootStrAlign := cAlign
      endif
   endif

   if nWidth != nil
      oCol:nWidth       := nWidth
   endif

   if lEdit .or. ValType( bOnPostEdit ) == 'B' .or. ValType( bValid ) == 'B' .or. ValType( bWhen ) == "B"
       oCol:nEditType   := 1
       oCol:bEditWhen   := bWhen
       oCol:bEditValid  := bValid
       oCol:bOnPostEdit := If( ValType( bOnPostEdit ) == 'B', bOnPostEdit, ;
                              {|o,u,n|if( n != VK_ESCAPE,eval(bData,u),)} ) // works if bData is getset block
   endif

   if valtype( uClrFore ) == 'N'
      if valtype( uClrBack ) == 'N'
         oCol:bClrStd   := {|| {uClrFore,uClrBack} }
      elseif valtype( uClrBack ) == 'B'
         oCol:bClrStd   := { || {uClrFore,eval(uClrBack)} }
      else
         oCol:bClrStd   := { || { uClrFore, eval( oCol:oBrw:bClrStd )[2] } }
      endif
   elseif valtype( uClrFore ) == 'B'
      if uClrBack == nil
         if valtype( uTemp := eval( uClrFore ) ) == 'A' .and. Len( uTemp ) == 2
            oCol:bClrStd   := uClrFore
         else
            oCol:bClrStd   := { || { eval(uClrFore), eval( oCol:oBrw:bClrStd )[2] } }
         endif
      elseif valtype( uClrBack ) == 'N'
         oCol:bClrStd      := { || { eval(uClrFore), uClrBack } }
      elseif valtype( uClrBack ) == 'B'
         oCol:bClrStd      := { || { eval(uClrFore), eval(uClrBack) } }
      endif
   endif

   if ncOrder != nil
      oCol:cSortOrder := ncOrder
   endif

return oCol

//--------------------------------------------------------------------------//

function XbrJustify( oBrw, aJust )

   local n, v, nCols

   if ! Empty( aJust )
      nCols := Min( Len( aJust ), Len( oBrw:aCols ) )
      for n := 1 to nCols
         v  := aJust[ n ]
         if ValType( v ) == "L"
            V  := If( v, AL_RIGHT, AL_LEFT )
         endif
         if ValType( v ) == "N"
            oBrw:aCols[ n ]:nDataStrAlign := MinMax( v, 0, 2 )
         endif
      next
   endif

return oBrw

//--------------------------------------------------------------------------//

function xbrNumFormat( cIntl, lSep )

   local aPrevSet := { cNumFormat, lThouSep }

   if cIntl != nil .and. cIntl $ 'AEI'
      cNumFormat  := cIntl
   endif

   if ValType( lSep ) == "L"
      lThouSep    := lSep
   endif

return aPrevSet

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <windows.h>

HB_FUNC( XBRWSCROLLROW ) // hWnd, nScroll, nHeaderHeight, nBottomInPixels
{
   HWND hWnd  = ( HWND ) hb_parnl( 1 );
   RECT rct;

   GetClientRect( hWnd, &rct );

   rct.top     += hb_parni( 3 );
   rct.bottom  = rct.top + hb_parni( 4 ) ;

   ScrollWindowEx( hWnd, 0, - hb_parni( 2 ), 0, &rct, 0, 0, 0 );
}

#pragma ENDDUMP