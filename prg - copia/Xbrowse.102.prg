#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "xbrowse.ch"
#include "Report.ch"
#include "dtpicker.ch"

#xtranslate MinMax( <xValue>, <nMin>, <nMax> ) => ;
   Min( Max( <xValue>, <nMin> ), <nMax> )

#define SRCCOPY      0x00CC0020

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
#define BITMAP_ALPHA          6

#define VSCROLL_MAXVALUE      10000  // never set values above 32767

#define TME_LEAVE             2
#define WM_MOUSELEAVE       675
#define PM_REMOVE        0x0001

#ifdef __XHARBOUR__
   #xtranslate hb_hKeyAt( <h>, <n> )     => hGetKeyAt( <h>, <n> )
   #xtranslate hb_hValueAt( <h>, <n> )   => hGetValueAt( <h>, <n> )
   #xtranslate hb_hCaseMatch( <h>, <n> ) => hSetCaseMatch( <h>, <n> )
#endif

//------------------------------------------------------------------------------

static lThouSep        := .f.
static cNumFormat      := 'A'
static lExcelInstl, lCalcInstl
static nxlLangID, cxlTrue := "=(1=1)", cxlFalse := "=(1=0)", cxlSum, cxlSubTotal, lxlEnglish := .f., hLib

static bXBrowse

//----------------------------------------------------------------------------//

CLASS TXBrowse FROM TControl

   DATA oVScroll,;   // Vertical scrollbar (used internally)
        oHScroll,;   // Horizontal scrollbar (used internally)
        oCapCol,;    // Actual mouse captured column (used internally)
        oSeek,;      // Optional TSay control to display the value of current ::cSeek value
        oDbf         // Just a container for a DBF object for your own use (it is not used by the class)

   DATA aCols,;      // Array of TXBrwCols (used internally)
        aDisplay,;   // Array of current diplayed ordinal columns (used internally)
        aSelected,;  // Currently records selected (only use with marquee style MARQSTYLE_HIGHLROWMS
        aArrayData   // Array data (filled on SetArray())

   DATA aSortBmp

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
   DATA bPopUp       // PopUp menu on right click on any column

   // This code-blocks should return an two dimension array with {nFore, nBack} colors

   DATA bClrHeader,; // default color pair for header
        bClrFooter,; // default color pair for footer
        bClrGrad,  ; // default colour gradient spec
        bClrStd,;    // default color pair for normal rows
        bClrSel,;    // default color pair for selected row
        bClrSelFocus,; // default color pair for selected row when control has focus
        bClrRowFocus

   DATA bColClass INIT { || TxBrwColumn() }

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

   DATA nMoveType;      // 1 Move Right
        AS NUMERIC      // 2 Move Left
                        // 3 Move Up
                        // 4 Move down
                        // 5 No Move
                        // 6 Move Right with lFastedit features, only work with lFastEdit := .t.
                        // 7 Move left with lFastedit features, only work with lFastEdit := .t.


   DATA nLen,;          // Actual data len. This data is updated with Eval( bKeyCount ) (used internally)
        nDataRows,;     // Actual number of data rows, used internally
        nCaptured,;     // Mouse captured: 0-> No, 1->In header, 2-> In footer, 3->ResizeCol, 4->ResizeLine (used internally)
        nArrayAt,;      // When SetArray() method is used return the actual array element (used internally)
        nLastEditCol;   // Last edited col (display based)
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
        lEdit,;
        lRefreshOnlyData,;    // True when only the data should be painted (used internally)
        l2007 ;               // 2007 look
        AS LOGICAL

   DATA lSeekWild       AS LOGICAL INIT .f.
   DATA lColChangeNotify   AS LOGICAL INIT .f. // if true bChange is evaluated when col is changed
   DATA lAutoSort       AS LOGICAL INIT .f.  // used internally. do not use in applications
   DATA lAllowCopy      AS LOGICAL INIT .t.
   DATA lCanPaste       AS LOGICAL INIT .f.
   DATA lExcelCellWise  AS LOGICAL INIT .t.
   DATA lMergeVert      AS LOGICAL INIT .f.  // used internally

   DATA lAutoAppend AS LOGICAL INIT .t. // AutoAppend

   DATA lHeader,;  // Browse has header, if this value is nil then is initialized automatically on the Adjust method
        lFooter  // Browse has footer, if this value is nil then is initialized automatically on the Adjust method

   DATA nSaveMarq    // used internally
   DATA oRS          // ADO recordset if Method SetAdo() is used
   DATA oTree, oTreeItem  // Do not set them directly, instead use SetTree method. Can be accessed
   DATA oColToolTip     // Used internally
   DATA bOnRowLeave
   DATA bOnSkip         INIT { || nil }
   DATA lEdited         INIT .f.
   DATA bLock           INIT { || .t. }
   DATA bUnLock
   DATA uStretchInfo    // Internal use only
   DATA nStretchCol

   DATA aHeaderTop,; // Array of header string Top
          nHeader

   DATA nBckMode     INIT 0

   DATA lContrastClr INIT .t.

   // Movement DATAS

   DATA nStartMRow,;
        nEndMRow,;
        nRowAdvance,;
        nColAdvance,;
        nStartTime,;
        nEllapsed,;
        lDown,;
        lPressed,;
        lMoved PROTECTED

   DATA lKineticBrw      AS LOGICAL INIT .T.

   CLASSDATA lKinetic    AS LOGICAL INIT SetKinetic()

   // Datas used for Kinetic Scrolling ( used Internally )

   DATA nStopRatio       AS NUMERIC INIT 4
   DATA nMaxRowToAdvance AS NUMERIC INIT 40
   DATA nMinVelocity     AS NUMERIC INIT 50
   DATA lDrawSelected    AS LOGICAL INIT .T.
   DATA hCursorHand

   CLASSDATA lRegistered AS LOGICAL // used internally

   METHOD New( oWnd )
   METHOD Destroy()

   METHOD nAt() INLINE ::colpos( ::SelectedCol() )

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD SetRDD( lAddColumns, lAutoSort, aFldNames, aRows )
   METHOD SetArray( aData, lAutoSort, nColOrder, aCols, bOnSkip )
   METHOD SetoDbf( oDbf, aCols, lAutoSort, lAutoCols, aRows )
   METHOD SetAdo( oRs, lAddCols, lAutoOrder, aFldNames ) // ADO object
   METHOD SetTree( oTree, aResource, bOnSkip )
   METHOD ClearBlocks()
   METHOD SetColFromADO( cnCol, lAutoOrder )  // Used internally
   METHOD ArrCell( nRow, nCol, cFmt )
   METHOD ArrCellSet( nRow, nCol, uNewVal )

   METHOD aJustify( aJust ) SETGET  // only for compatibility with TWBrowse

   METHOD AddCol()
   METHOD InsCol( nPos )
   METHOD DelCol( nPos )
   METHOD AddColumn()  // See the method for parameters
   METHOD SwapCols( xCol1, xCol2, lRefresh )
   METHOD MoveCol( xFrom, xTo, lRefresh )
   METHOD ReArrangeCols( aSeq, lRetainRest )

   METHOD CreateFromCode()
   METHOD CreateFromResource( nId )

   METHOD SelectCol( nCol )
   METHOD GoLeft( lOffset, lRefresh )
   METHOD GoRight( lOffset, lRefresh )
   METHOD GoLeftMost()
   METHOD GoRightMost()

   METHOD GoUp( nLines )
   METHOD GoDown( nLines )
   METHOD PageUp( nLines )
   METHOD PageDown( nLines )
   METHOD GoTop()
   METHOD GoBottom()

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD KeyCount() INLINE ( ::nLen := iif( !Empty( ::bKeyCount ), Eval( ::bKeyCount ), 0 ),;
                              iif(::oVScroll != nil , ( ::VSetRange( 1, ::nLen ), ::VUpdatePos() ), ),;
                              ::nLen )

   METHOD KeyNo( n ) SETGET
   METHOD BookMark( uBm ) SETGET
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
   METHOD SelectOne()  INLINE ( ::Select( 0 ), ::Select( 1 ) )

   METHOD Adjust()
   METHOD Resize( nSizeType, nWidth, nHeight ) INLINE ( ::MakeBrush(), ::ColStretch(), Super:ReSize( nSizeType, nWidth, nHeight ) )
   METHOD Change( lRow ) PROTECTED
   METHOD MakeTotals()
   METHOD Eval( bBlock, bFor, bWhile, nNext, nRec, lRest )
   METHOD Report( cTitle, lPreview, lModal, bSetUp, aGroupBy )
   METHOD ToExcel( bProgress, nGroupBy, aCols )
   METHOD ToCalc(  bProgress, nGroupBy, nPasteMode, aSaveAs )
   METHOD CurrentRow()

   // The rest of the methods are used internally

   METHOD Initiate( hDlg )
   METHOD Display()
   METHOD Paint()

   METHOD Refresh( lComplete )
   METHOD DelRePos()

   METHOD DrawLine( lSelected, nRowLine )

   METHOD FullPaint() INLINE ( ::lTransparent .or. ::lMergeVert )

   METHOD GotFocus( hCtlFocus )  INLINE ( Super:GotFocus( hCtlFocus ),;
                                          If( GetParent( hCtlFocus ) != ::hWnd, ::Super:Refresh( .f. ),) )
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

   METHOD VUpdatePos() INLINE ::VSetPos( ::KeyNo() )
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
   METHOD HeaderHeight() INLINE If( ::nHeaderHeight == nil, 0, ::nHeaderHeight )
   METHOD FooterHeight() INLINE If( ::nFooterHeight == nil, 0, ::nFooterHeight )
   METHOD RowCount()     INLINE ( If( ::nRowHeight == nil, ::Adjust(),), Int( ( ::BrwHeight() - ::HeaderHeight() - ::FooterHeight() ) / ::nRowHeight ) )
   METHOD FirstRow()     INLINE ::HeaderHeight()
   METHOD LastRow()      INLINE ::BrwHeight() - ::FooterHeight() - ::nRowHeight + 1
   METHOD FooterRow()    INLINE ::BrwHeight() - ::FooterHeight() + 1
   METHOD DataHeight()   INLINE ::nRowHeight - iif(::nRowDividerStyle > LINESTYLE_NOLINES, 1, 0) - ;
                                If(::nRowDividerStyle >= LINESTYLE_INSET, 1, 0)
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
   METHOD Paste( cText )
   METHOD aCellCoor( nRow, nCol ) // --> { nTop, nLeft, nBottom, nRight } in pixels for cell at nVisibleRow, nVisibleCol
   METHOD SetPos( nRow, nCol, lPixel )

   METHOD SetBackGround( uBack, nBckMode ) // call with no paratmer to clear background
   METHOD MakeBrush()
   METHOD DataRect()
   METHOD cBmpAdjBrush( cImage ) SETGET // Obsolete SETGET method created for compatibility
   METHOD ColStretch( nStretchCol ) // used internally
   // tooltip support
   METHOD DestroyToolTip()
   METHOD NcMouseMove( nHitTestCode, nRow, nCol )
   METHOD MouseLeave()

   ERROR HANDLER OnError

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TXBrowse

   local hBmp

   DEFAULT oWnd   := GetWndDefault()

   ::oWnd         := oWnd

   if oWnd != nil
      /*
      if oWnd:oFont == nil
         ? "getFont"
         oWnd:GetFont()
      endif
      */
      ::oFont     := oWnd:oFont
   endif

   ::aCols        := {}
   ::aSelected    := {}

  // ::bClrHeader   := {|| { GetSysColor( COLOR_BTNTEXT ), GetSysColor( COLOR_BTNFACE ) } }
   ::bClrHeader   := {|| { GetSysColor( COLOR_BTNTEXT ), GetSysColor( COLOR_BTNFACE ), nRGB( 125, 165, 224 ), nRGB( 203, 225, 252 ) } }
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

   ::nDataType := 0 // not set

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
   ::lTransparent        := .f.

   ::nRowSel      := 1
   ::nColSel      := 1
   ::nColOffset   := 1
   ::nFreeze      := 0
   ::nCaptured    := 0
   ::nLastEditCol := 0

   ::nRowDividerStyle := LINESTYLE_NOLINES
   ::nColDividerStyle := LINESTYLE_NOLINES
   ::nMarqueeStyle    := MARQSTYLE_SOLIDCELL

   ::nMoveType := MOVE_FAST_RIGHT

   ::nHeaderLines := 1
   ::nFooterLines := 1
   ::nDataLines   := 1

   ::hBmpRecSel := FwRArrow()

   ::lHeader          := .t.
   ::lFooter          := .f.
   ::lRefreshOnlyData := .f.

   ::l2007        := ( ColorsQty() > 256 )

   ::aSortBmp    := {}
   hBmp        := FWBmpAsc()
   AAdd( ::aSortBmp, { hBmp, 0, nBmpWidth( hBmp ), nBmpHeight( hBmp ), nil, .F. } )
   hBmp        := FWBmpDes()
   AAdd( ::aSortBmp, { hBmp, 0, nBmpWidth( hBmp ), nBmpHeight( hBmp ), nil, .F. } )

   ::bClrGrad := { | lInvert | If( lInvert, ;
      { { 1/3, nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ) }, ;
        { 2/3, nRGB( 255, 215,  84 ), nRGB( 255, 233, 162 ) }  ;
      }, ;
      { { 1/3, nRGB( 219, 230, 244 ), nRGB( 207, 221, 239 ) }, ;
        { 2/3, nRGB( 201, 217, 237 ), nRGB( 231, 242, 255 ) }  ;
      } ) }

   ::nHeader          := 0
   ::aHeaderTop       := {}

return Self

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TXBrowse

   local nFor

   ::lMoved = .F.

   if ::oBrush:hBitmap != 0 .and. ValType( ::oBrush:Cargo ) == 'N' .and. ;
      ::oBrush:hBrush != ::oBrush:Cargo
         // resized brush
      DeleteObject( ::oBrush:Cargo )
   endif

   for nFor := 1 to Len( ::aCols )
      ::aCols[ nFor ]:End()
   next

   DeleteObject( ::hBmpRecSel )
   DeleteObject( ::hBrushRecSel )

   DeleteObject( ::aSortBmp[ 1 ][ 1 ] )
   DeleteObject( ::aSortBmp[ 2 ][ 1 ] )

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

return Super:Destroy()

//----------------------------------------------------------------------------//

METHOD CreateFromCode() CLASS TXBrowse

   if ::lCreated
      return Self
   endif

   // Movement Datas
   ::hCursorHand  = CursorOpenHand()
   ::lDown        = .T.
   ::lMoved       = .F.
   ::lPressed     = .F.

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

   ::nId       	:= nId
   ::lDown      := .t.
   ::lMoved     := .f.
   ::lPressed   := .f.

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

   if Empty( ::nDataType ) .or. Empty( ::aCols )

      if ! Empty( ::aArrayData )
         if lAnd( ::nDataType, DATATYPE_RDD )
            ::SetRDD( .t., nil, nil, ::aArrayData )
         elseif lAnd( ::nDataType, DATATYPE_ODBF ) .and. !Empty( ::oDbf )
            ::SetODbf( ::oDbf, nil, nil, .t., ::aArrayData )
         else
            ::SetArray( ::aArrayData )
         endif
      elseif ! Empty( ::oRs )
         ::SetADO( ::oRs )
      elseif ! Empty ( ::oDbf )
         ::SetoDbf( ::oDbf,,, Empty( ::aCols ) )
      elseif !Empty( ::cAlias ) .and. ( ::cAlias )->( Used() ) // .or. !Empty( Alias() )
         ::SetRDD()
      endif

      if Empty( ::nDataType )  // Empty( ::cAlias )
         // no rdd open and no datasource
         ::bBof   := ::bEof := { || .t. }
         ::bKeyCount := ::bKeyNo := ::bBookMark := { || 0 }
      endif

   endif

   if ( !Empty( ::cAlias ) .and. ( ::cAlias )->( Used() ) ) .and. ( Empty( ::bKeyCount ) .or. Empty( ::bKeyNo ) )
      ::SetRdd()
   endif

   if Empty( ::aCols )
      ::AddCol():bStrData     := { || "" }
      ::aCols[ 1 ]:cHeader    := "A"
      ::nStretchCol           := 1
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
   ::MakeBrush()

return Self

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TXBrowse

   local oCol, nFor, nLen, nHeight, nStyle

   nLen    := Len( ::aCols )
   nHeight := 0

   ::GetDC()

   for each oCol in ::aCols   // nFor := 1 to nLen
      oCol:Adjust()           // ::aCols[ nFor ]:Adjust()
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
      ::VSetPos( ::KeyNo() )
   endif

   ::ColStretch()

return nil

//----------------------------------------------------------------------------//

METHOD Change( lRow ) CLASS TXBrowse

   if ::bChange != nil

      DEFAULT lRow := .t.

      if lRow .or. ::lColChangeNotify
         Eval( ::bChange, Self, lRow )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD Refresh( lComplete )  CLASS TXBrowse

   local nKeyNo

   DEFAULT lComplete := .F.

   ::KeyCount()

   if lComplete
      ::nRowSel  = 1
      ::nArrayAt = Min( 1, ::nLen )
   else
      nKeyNo     = ::KeyNo()
      ::nArrayAt = Min( ::nArrayAt, ::nLen )
      ::nRowSel  = Max( 1, Min( ::nRowSel, ::nLen ) )
      ::nRowSel  = Max( 1, Min( ::nRowSel, nKeyNo ) ) // bKeyNo for ADS is approx. can be zero also

      ::DelRepos()  // if the row is deleted for RDD

      if nKeyNo >= ::nLen .and. ::nLen > 1
         ::nRowSel   := Min( nKeyNo, ::RowCount() )
      endif
/*
      if nKeyNo <= ::RowCount()
         ::nRowSel   := nKeyNo
      endif
*/
      if ::nArrayAt == 0 .and. ::nLen > 0
         // when one or more rows are added to a blank array
         ::nArrayAt  := 1
      endif
   endif

   ::GetDisplayCols()

return Super:Refresh( .T. )

//----------------------------------------------------------------------------//

METHOD DelRepos() CLASS TXBrowse

   local lRepos := .f.
   local cFilter, bFilter

//   if lAnd( ::nDataType, DATATYPE_RDD ) .and. ::nLen > 0
   if ( ::nDataType == DATATYPE_RDD ) .and. ::nLen > 0
      if ( Set( _SET_DELETED ) .and. ( ::cAlias )->( Deleted() ) ) ;
         .or. ;
         ( ! Empty( cFilter := ( ::cAlias )->( dbFilter() ) ) .and. ;
           Type( cFilter ) == 'L' .and. ;
           ! &cFilter )

            ( ::cAlias )->( dbSkip( 1 ) )
            if ( ::cAlias )->( eof() )
               ( ::cAlias )->( DbGoBottom() )
            endif
            lRepos := .t.
      endif

   endif

return lRepos

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

   local aCols, aColors, aRect
   local oCol
   local nFor, nLen, nRow, nCol, nHeight, nLast, nTemp, nTemp2
   local nBrwWidth, nBrwHeight, nWidth
   local hBrush, hDC, hGrayPen, hWhitePen, hColPen, hRowPen, hSelBrush
   local nFirstRow, nLastRow, nMaxRows, nRowStyle, nColStyle, nRowPos, nRowHeight, nBookMark, nMarqStyle, nScan
   local lRecSel, lOnlyData, lHighLite
   local aInfo := ::DispBegin()
   local oBmp
   local hBmpDC, hDCComp, hOldBitMap, hBmp, hBmpNew
   local nBrushRow, nBrushCol, nBrushWidth, nBrushHeight
   local hHeaderPen, nColIni, nHeaderTop, nWidthHeaderTop


   // Paint Background
   aRect       := ::DataRect()
   SetBrushOrgEx( ::hDC, aRect[ 2 ], aRect[ 1 ] )
   // FillRect( ::hDC, aRect, ::oBrush:hBrush )
   FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )  //--> Ale SB
   // Paint Background end

   while ! ::IsDisplayPosVisible( ::nColSel ) .and. ::nColSel > 1
      ::nColSel--
      ::nColOffSet++
      ::GetDisplayCols()
   end

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
   /*
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
    */



    if ::lHeader
      if !lOnlyData
         If ::nHeader==0     // Silvio
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
         // FillRect( hDC, {nRow, 2, nRow + nHeight, nBrwWidth}, hBrush ) // ::hBrushRecSel Silvio
            FillRect( hDC, {nRow, If(lRecSel, RECORDSELECTOR_WIDTH, 2), nRow + nHeight, nBrwWidth}, hBrush ) // ::hBrushRecSel
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
         Else              // Silvio With two rows

            aColors := Eval( ::bClrHeader )
            hHeaderPen := CreatePen( PS_SOLID, 1, aColors[ 3 ] )

            nRow    := 0
            nHeight := ::nHeaderHeight - 3
            MoveTo( hDC, 2, nRow)
            LineTo( hDC, nBrwWidth, nRow, hColPen )
            nRow++
          // MoveTo( hDC, 2, nRow )
          // LineTo( hDC, nBrwWidth, nRow, hWhitePen )
            nRow++
            MoveTo( hDC, 2, nRow + nHeight)
            LineTo( hDC, nBrwWidth, nRow +  nHeight , hColPen )

            // aColors := Eval( ::bClrHeader )
            hBrush  := CreateSolidBrush( aColors[ 2 ] )
            FillRect( hDC, {nRow, If(lRecSel, RECORDSELECTOR_WIDTH, 2), nRow + nHeight, nBrwWidth}, hBrush )
            DeleteObject( hBrush )

            nColIni         := 0
            nHeaderTop      := 0
            nWidthHeaderTop := 0

            for nFor := 1 to nLast
               nCol := aCols[ nFor ]
               oCol := ::ColAtPos( nFor )
               If oCol:nHeaderType==0
                  MoveTo( hDC, nCol - 2, nRow + 0 )
                  LineTo( hDC, nCol - 2, nRow + nHeight - 0, hHeaderPen )
                  oCol:PaintHeader( nRow , nCol-1, nHeight )
               ElseIf oCol:nHeaderType==1
                  MoveTo( hDC, nCol - 2, nRow + nHeight/2 )
                  LineTo( hDC, nCol - 2, nRow + nHeight - 0, hHeaderPen )
                  oCol:PaintHeader( nRow + nHeight/2, nCol-1, nHeight/2,,,oCol:nWidth+1, oCol:cHeader )
                  nWidthHeaderTop:=nWidthHeaderTop+oCol:nWidth+1
               ElseIf oCol:nHeaderType==2
                  MoveTo( hDC, nCol - 2, nRow + 0 )
                  LineTo( hDC, nCol - 2, nRow + nHeight - 0, hHeaderPen )
                  oCol:PaintHeader( nRow + nHeight/2, nCol-1, nHeight/2 )
                  nColIni := nCol
                  nWidthHeaderTop := oCol:nWidth+1
               ElseIf oCol:nHeaderType==3
                  MoveTo( hDC, nCol - 2, nRow + 0 )
                  LineTo( hDC, nCol - 2, nRow + nHeight - 0, hHeaderPen )
                  oCol:PaintHeader( nRow , nCol-1, nHeight,,,oCol:nWidth+1, oCol:cHeader )
                  MoveTo( hDC, nColIni - 2, nRow + nHeight/2 )
                  LineTo( hDC, nCol - 2, nRow + nHeight/2, hHeaderPen )
                  nHeaderTop++
                  oCol:PaintHeader( nRow - 0, nColIni-1, nHeight/2,,,nWidthHeaderTop+1, ::aHeaderTop[nHeaderTop] )
                  nWidthHeaderTop:=0
               ElseIf oCol:nHeaderType==4
                  MoveTo( hDC, nCol - 2, nRow + 0 )
                  LineTo( hDC, nCol - 2, nRow + nHeight - 0, hHeaderPen )
                  oCol:PaintHeader( nRow + nHeight/2, nCol-1, nHeight/2,,,oCol:nWidth+1, oCol:cHeader )
                  MoveTo( hDC, nColIni - 2, nRow + nHeight/2 )
                  LineTo( hDC, nCol - 2, nRow + nHeight/2, hHeaderPen )
                  nHeaderTop++
                  oCol:PaintHeader( nRow - 0, nColIni-1, nHeight/2,,,nWidthHeaderTop, ::aHeaderTop[nHeaderTop] )
                  nColIni := nCol
                  nWidthHeaderTop:=oCol:nWidth+1
               EndIf
            next
            nCol := aCols[ nFor ]
            MoveTo( hDC, nCol - 2, nRow + 0 )
            LineTo( hDC, nCol - 2, nRow + nHeight - 0, hHeaderPen )
            If oCol:nHeaderType==1 .or. oCol:nHeaderType==4
               MoveTo( hDC, nColIni - 2, nRow + nHeight/2 )
               LineTo( hDC, nCol - 2, nRow + nHeight/2, hHeaderPen )
               nHeaderTop++
               oCol:PaintHeader( nRow - 0, nColIni-1, nHeight/2,,,nWidthHeaderTop+1, ::aHeaderTop[nHeaderTop] )
            EndIf
            DeleteObject( hHeaderPen )
         EndIf
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

   //   Eval( ::bSkip, 1 - Min( ::nRowSel, nMaxRows ) )
      ::Skip( 1 - Min( ::nRowSel, nMaxRows ) )

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
            oCol:PaintData( nRow, aCols[ nFor ], nHeight, lHighLite, .f., nFor, nRowPos )
         next

         nRowPos++
         nRow += nRowHeight

         if ::Skip() == 0
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
               if ::aCols[ nFor ]:HasBorder( ::nDataRows - nTemp2 )
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

   if ::nLen == 0
      return nil
   endif

   if ! ::lDrawSelected
      return  nil
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
      oCol:PaintData( nRow, nil, nDataHeight, lHighLite, lSelected, nFor, nRowSel )
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
         elseif nColStyle > 0 // We have to FullPaint the line cols :-((
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
         oCol:PaintData( nRow, nil, nDataHeight, .t., .t. , ::nColSel, nRowSel )
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

      if ! ::lTransparent              // WATCH OUT HERE
         for nFor := 1 to nLast
            oCol := ::ColAtPos( nFor )
            oCol:EraseData( nRow, , nHeight, ::oBrush:hBrush, .t. )
         next
         if ::nMarqueeStyle > MARQSTYLE_HIGHLCELL .and. nLast == Len( ::aDisplay )
            nCol := oCol:nDisplayCol + oCol:nWidth + 1
            FillRect( hDC, {nRow, nCol, nRow + nHeight, ::BrwWidth()}, ::oBrush:hBrush )
         endif
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
      cHeader    := AScan( ::aCols, {|oCol| ;
                     If( ValType( oCol:cHeader ) == 'C', ;
                     ( upper( Trim(oCol:cHeader) ) == cHeader ), .f. ) } )
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
      if ! oCol:lHide
         AAdd( aDisplay, nCol )
         oCol:nPos := Len( aDisplay )
         nFreeze--
      endif
      nCol++
   enddo

   nCol := Max( nCol, nOffset )

   do while nCol <= nLen
      oCol := ::aCols[ nCol ]
      if ! oCol:lHide
         AAdd( aDisplay, nCol )
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

   if lComplete .and. nWidth >= nMaxwidth
      nPos--
   endif

   nPos := Max( 1, nPos )

   if ::nStretchCol == STRETCHCOL_LAST .and. nPos = nLen
      if nWidth < nMaxwidth
          ::ColAtPos( nPos ):nWidth += ( nMaxWidth - nWidth - COL_SEPARATOR  ) + if( ::lRecordSelector, 1, 0 )
      elseif nWidth > nMaxwidth
          ::ColAtPos( nPos ):nWidth -= ( nWidth - nMaxWidth + COL_SEPARATOR  ) - if( ::lRecordSelector, 1, 0 )
      endif
   endif




return nPos

//---------------------------------------------------------------------------//

METHOD ColStretch( nStretchCol ) CLASS TXBrowse

   local n, nLen, nWidth, oCol, nBrwWidth, nOffSet
   local nMaxWidth := 0

   DEFAULT nStretchCol := ::nStretchCol

   if ! ::lCreated
      return nil
   endif

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
//               if ::nStretchCol == STRETCHCOL_LAST
//                  nStretchCol := n
               if ::nStretchCol == STRETCHCOL_WIDEST
                  if ::aCols[ n ]:cDataType == 'C' .and. ::aCols[ n ]:nWidth >= nMaxWidth
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

   local oCol

   do case
   case nKey == VK_ESCAPE
        if ::lEditMode
           oCol := ::SelectedCol()
           if oCol:oEditLbx != nil
              oCol:oEditLbx:nLastKey = VK_ESCAPE
           endif
           if oCol:oEditGet != nil
              oCol:oEditGet:nLastKey := VK_ESCAPE
           endif
           ::CancelEdit()
           return 0
        else
           return Super:KeyDown( nKey, nFlags )
        endif

   case nKey == VK_LEFT  .and. GetKeyState( VK_SHIFT ) .or. ;
        nKey == VK_RIGHT .and. GetKeyState( VK_SHIFT )
        return Super:KeyDown( nKey, nFlags )


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

   case ::lAllowCopy .and. nKey == ASC( 'C' ) .and. GetKeyState( VK_CONTROL )
         ::Copy()

   otherwise

      return Super:KeyDown( nKey, nFlags )

   endcase

return 0

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TXBrowse

   local oCol, cKey
   local oClp, uClip

   oCol := ::SelectedCol()
   if oCol:lAutoSave
      if oCol:oEditGet != nil
         oCol:oEditGet:SetFocus()
         return 0
      endif
   endif

   if ::bKeyChar != nil
      Eval( ::bKeyChar, nKey, nFlags )
      if ::lEditMode
         return nil
      endif
   endif

   do case
/*
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
*/
      case nKey == VK_RETURN
         oCol := ::SelectedCol()
         if oCol:oEditGet != nil
            PostMessage( oCol:oEditGet:hWnd, WM_KEYDOWN, nKey )   //VK_RETURN )
         elseif oCol:lEditable .and. ! oCol:hChecked
            return oCol:Edit()
         elseif ::oTreeItem!=nil
            If( ::oTreeItem:oTree != nil,( ::oTreeItem:Toggle(), ::Refresh() ),)
         else
            ::GoRight()
         endif

      case nKey == K_PGUP
         ::oVScroll:PageUp()

      case nKey == K_PGDN
         ::oVScroll:PageDown()

      case ::lCanPaste .and. nKey == 22  // Ctrl-V

         if ::SelectedCol():cDataType == 'P'
            DEFINE CLIPBOARD oClp OF ::oWnd FORMAT BITMAP
            uClip     := oClp:GetBitmap()
            if uClip != 0 .and. ::SelectedCol():nEditType > 0
               ::SelectedCol():PostEdit( BmpToStr( uClip ) )
               oClp:Clear()
            endif
            oClp:End()
         endif

         DEFINE CLIPBOARD oClp OF ::oWnd FORMAT TEXT
         uClip    := oClp:GetText()
         if ! Empty( uClip )
           oClp:Clear()
         endif
         oClp:End()
         if ! Empty( uClip )
            ::Paste( uClip )
         endif


      otherwise

         cKey := Chr( nKey )
         oCol := ::SelectedCol()
         if nKey == 32 .and. ::nMarqueeStyle <= MARQSTYLE_HIGHLCELL .and. ;
                     oCol:hChecked .and. oCol:lEditable

            oCol:CheckToggle()

         elseif ::lFastEdit .and. ::nMarqueeStyle <= MARQSTYLE_HIGHLCELL .and. ;
            oCol:lEditable .and. oCol:IsEditKey( cKey )

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
      ::GoRightMost()

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
         if ::FullPaint()
            ::Super:Refresh( .t. )
         else
            ::DrawLine( .t. )
         endif
      endif
   elseif ::nColOffset > 1
      ::nColOffset--
      ::GetDisplayCols()
      if lRefresh
         ::Super:Refresh( ::FullPaint() )
      endif
   endif

   if ::oHScroll != nil
      ::oHScroll:GoUp()
   endif
   ::Change( .f. )

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
      // lOffset := .t.  E.M. Giordano 04-Nov-08
   endif

   DEFAULT lOffset  := .f.,;
           lRefresh := .t.

   nLen := Len( ::aDisplay )

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
               ::Super:Refresh( ::FullPaint() )
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
         ::Super:Refresh( ::FullPaint() )
      endif

   endif

   if ::lHScroll
      ::oHScroll:GoDown()
   endif

   ::Change( .f. )

return nil

//----------------------------------------------------------------------------//

//----------------------------------------------------------------------------//

METHOD GoLeftMost()  CLASS TXBrowse

   ::CancelEdit()

   ::nColSel := 1
   ::nColOffset := 1
   ::GetDisplayCols()
   ::Super:Refresh( ::FullPaint() )

   if ::oHScroll != nil
      ::oHScroll:SetPos( 1 )
   endif

   ::Change( .f. )

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
   ::Super:Refresh( ::FullPaint() )

   if ::oHScroll != nil
      ::oHScroll:SetPos( ::oHScroll:nMax )
   endif
   ::Change( .f. )

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
            ::KeyNo( ::VGetThumbPos( nPos ) )
            CursorArrow()
            nBook := Eval( ::bBookMark )
            do while nRow > 0 .and. ::Skip( -1 ) == -1
               nRow--
            enddo
            ::nRowSel := ::nRowSel - nRow
            Eval( ::bBookMark, nBook )
            ::Change( .t. )
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

METHOD GoUp( nUp ) CLASS TXBrowse

   local nHeight, n, oCol, nAt

   if ::nLen == 0 .or. ::Bof()
      return nil
   endif

   ::CancelEdit()
   if !::FullPaint()
      ::DrawLine()
   endif
   ::Seek()

   DEFAULT nUp := 1

   if ( oCol := ::SelectedCol() ):lMergeVert
      nAt      := ::KeyNo()
      nUp      := oCol:aMerge[ nAt ][ 1 ] + 1
      if ( nAt - nUp ) > 0
         nUp   += oCol:aMerge[ nAt - nUp ][ 1 ]
      endif
   endif

   for n := 1 to nUp

      if ::Skip( -1 ) == -1

         if ::nRowSel > 1
            ::nRowSel--
         else
            if ! ::FullPaint()

               XBrwScrollRow( ::hWnd, -::nRowHeight, ::HeaderHeight(), ::RowCount() * ::nRowHeight )
               if n < nUp
                  ::DrawLine( .f. )
               endif

               nHeight := ::BrwHeight() - ::FooterHeight() - ::HeaderHeight()
               If nHeight % ::nRowHeight > 0
                  // ::EraseData( ( ( Int(nHeight/::nRowHeight) + 1 ) * ::nRowHeight ) + 10 )
                  ::EraseData( ::HeaderHeight() + ::nRowHeight * ::RowCount() )
               Endif

            endif
            If ::nDataRows < ::RowCount()
               ::nDataRows++
            Endif

         endif
      else
         exit
      endif

   next

   if ! ::FullPaint()
      ::DrawLine( .t. )
   endif

   nUp   := n - 1

   if nUp > 0
      ::Change( .t. )
      if ::FullPaint()
         ::Super:Refresh( .t. )
      endif

      if ::oVScroll != nil
         for n := 1 to nUp
            ::VGoUp()
         next
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoDown( nDown ) CLASS TXBrowse

   local nLines, n, oCol, nAt

   if ::nLen == 0 .or. ::Eof()
      if ::bPastEof != nil
         Eval( ::bPastEof )
      endif
      return nil
   endif

   ::CancelEdit()
   ::Seek()

   DEFAULT nDown := 1

   if ( oCol := ::SelectedCol() ):lMergeVert
      nAt         := ::KeyNo()
      nDown       := oCol:aMerge[ nAt ][ 2 ] + 1
      if ( nAt + nDown ) < ::nLen
         nDown    += oCol:aMerge[ nAt + nDown ][ 2 ]
      endif
   endif

   nLines := ::RowCount()

   if ! ::FullPaint()
      ::DrawLine()
   endif

   for n := 1 to nDown

      if ::Skip( 1 ) == 1           //Eval( ::bSkip, 1 ) == 1
         if ::nRowSel < nLines
            ::nRowSel++
         else

            if ! ::FullPaint()
               XBrwScrollRow( ::hWnd, ::nRowHeight, ::HeaderHeight(), nLines * ::nRowHeight )
               if n < nDown
                  ::DrawLine( .f. )
               endif
            endif

         endif
         if ::oVScroll != nil
            ::VGoDown()
         endif
      else
         if ::bPastEof != nil .and. nDown == 1
            Eval( ::bPastEof )
         endif
         if ::oVScroll != nil
            ::VGoBottom()
         endif
         exit        // 2008-07-24
      endif

   next
   nDown    := n - 1

   if ! ::FullPaint()
      ::DrawLine( .t. )
   endif

   if nDown > 0
      ::Change( .t. )
      if ::FullPaint()
         ::Super:Refresh( .t. )
      endif
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

   nSkipped = ::Skip( -nLines )        //Eval( ::bSkip, -nLines )

   if nSkipped = 0
      ::DrawLine(.t.)
      return nil
   endif

   if -nSkipped < nLines
      ::nRowSel = 1
      ::Change( .t. )
      // ::lRefreshOnlyData := .t.
      ::Super:Refresh( ::FullPaint() )
      if ::oVScroll != nil
         ::VGoTop()
      endif
   else
      if ::KeyNo() < ::nRowSel
         ::KeyNo( ::nRowSel )
      endif
      ::Change( .t. )
      // ::lRefreshOnlyData := .t.
      ::Super:Refresh( ::FullPaint() )

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

   // nBook1 := Eval( ::bBookMark )

   nSkipped = ::Skip( nLines )         // Eval( ::bSkip, nLines )

   if nSkipped < nLines .and. nSkipped <= ( ::nDataRows - ::nRowSel )
      nBook2 := Eval( ::bBookMark )
      Eval( ::bBookMark, nBook1 )

      if ! ::FullPaint()
         ::DrawLine()
      endif

      Eval( ::bBookMark, nBook2 )
      ::nRowSel = ::nDataRows
      ::Change( .t. )

      ::Refresh()

      /*
      if ::FullPaint()
         ::Super:Refresh( .t. ) //::Paint()
      else
         ::DrawLine( .t. )
      endif
      */

      nRow := ( ( ::nRowSel) * ::nRowHeight ) + ::HeaderHeight()

      ::EraseData( nRow )
      if ::oVScroll != nil
         ::VGoBottom()
      endif

      return nil

   endif

   ::Change( .t. )

   // ::lRefreshOnlyData := .t.
   ::Super:Refresh( ::FullPaint() )

   if ::oVScroll != nil
      ::VSetPos( ::VGetPos() + nSkipped )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyNo( nGoTo ) CLASS TXBrowse
return Eval( ::bKeyNo, nGoTo, Self )

//------------------------------------------------------------------//

METHOD BookMark( uBm ) CLASS TXBrowse
return Eval( ::bBookMark, uBm )

//------------------------------------------------------------------//

METHOD GoTop() CLASS TXBrowse

   if ::Bof() .or. ::nLen < 1
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
   ::Change( .t. )

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

   if ::Eof() .or. ::nLen < 1
      ::DrawLine( .t. )
      return nil
   endif

   nLines := ::RowCount()
   nRow   := nLines

   Eval( ::bGoBottom )

   nBook := Eval( ::bBookMark )

   do while nRow-- > 0 .and. ::Skip( -1 ) == -1    //Eval( ::bSkip, -1 ) == -1
   enddo

   ::nRowSel := nLines - nRow

   Eval( ::bBookMark, nBook )

   if ::oVScroll != nil
      ::VGoBottom()
   endif
   ::Change( .t. )
   If lNoRefresh
      ::KeyCount()
      ::lRefreshOnlyData := .t.
      ::Super:Refresh( .t. ) // ::Paint()
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
      nCol        := ::nColSel
   elseif lPixel
      ncol        := ::MouseColPos( nCol )
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
         if ::Skip( nSkip ) == nSkip      // Eval( ::bSkip, nSkip ) == nSkip
            ::nRowSel := nRow
            ::Change( .t. )
            lRepos      := .t.
         else
            Eval( ::bBookMark, bm )
            nSkip := 0
         endif

         if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
            ::Select(1)
         endif

         if ::FullPaint()
            ::Super:Refresh( .t. ) // ::Paint()
         else
            ::DrawLine( .t. )
         endif
         ::Change( .t. )
      endif

      if nSkip != 0 .and. ::oVScroll != nil
         ::VSetPos( ::KeyNo() )
      endif

      if ::oHScroll != nil
         ::oHScroll:SetPos( ::nColSel )
      endif

   endif

return lRepos

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TXBrowse

   local oCol
   local nRowPos, nColPos, nLen, nFor, nTmp, nPos
   local nRowPrev,nColPrev
   local nOldCol := ::nColSel

   ::nRowAdvance = ::MouseRowPos( nRow )
   ::nColAdvance = ::MouseColPos( nCol )
   ::nStartMRow  = ::nRowAdvance

   if !::lKinetic
      ::lKineticBrw  := .f.
   endif
   ::lPressed    = ::lKineticBrw .and. ::bDragBegin == nil

   ::nStartTime  = GetTickCount()

   ::CancelEdit()
   ::Seek()

   ::SetFocus()

   if ::lDrag
      return Super:LButtonDown( nRow, nCol, nFlags )
   endif

   nRowPrev  := ::nRowSel
   nColPrev  := ::nColSel
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
         ::Skip( nRowPos - ::nRowSel )
         ::nRowSel := nRowPos
         // ::Change( .t. )
      endif

      if nColPos > 0
         ::nColSel := nColPos
      endif

      if ::nRowSel != nRowPrev
         ::Change( .T. )
      elseif ::nColSel != nColPrev
         ::Change( .F. )
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

      if ::FullPaint()
         ::Super:Refresh( .T. )
      else
         ::DrawLine( .T. )
      endif

      if ::oVScroll != nil
         ::VSetPos( ::KeyNo() )
      endif

      if ::oHScroll != nil
         ::oHScroll:SetPos( ::nColSel )
      endif

   endif

   if ::MouseRowPos( nRow ) != 0 .and. ::MouseColPos( nCol ) != 0
      Super:LButtonDown( nRow, nCol, nFlags )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TXBrowse

   local nCaptured
   local nRowAdvanced, nTimeScrolled, nVelocity, nRowToAdvance
   local nRatio, n, cMsg := ""

   if ::lDrag
      return Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lPressed
      ::lPressed    = .F.
      ::nEndMRow    = ::MouseRowPos( nRow )
      ::nEllapsed   = GetTickCount()

      nRowAdvanced  = ::nEndMRow - ::nStartMRow
      nTimeScrolled = ( ::nEllapsed - ::nStartTime ) / 4000

      nVelocity     =  int( abs( nRowAdvanced ) / nTimeScrolled )

      if nVelocity > ::nMinVelocity
         nRowToAdvance = min( ::nMaxRowToAdvance, nVelocity * 0.125 )

         nRatio   = ( ::nStopRatio * ::nMaxRowToAdvance / nRowToAdvance )
         ::lMoved = .T.
         if nRowAdvanced > 0
            ::Skip( 1 - ::nRowSel )    // go to first visible row
            ::nRowSel = 1
         elseif nRowAdvanced < 0
            ::Skip( ::nDataRows - ::nRowSel )   // go to last visible row
            ::nRowSel   = Min( ::nLen, ::Rowcount() )
         endif
         for n = 1 to nRowToAdvance
            if ! ::lMoved
               exit
            endif
            if nRowAdvanced > 0
               ::GoUp()
               if ::KeyNo() == 1
                  exit
               endif
            elseif nRowAdvanced < 0
               ::GoDown()
               if ::KeyNo() >= ::nLen
                  exit
               endif
            endif
            ::Refresh()
            Sleep( Min( 120, n * nRatio ) )
            if PeekMessage( @cMsg, ::hWnd, 0x201, 0x202, PM_REMOVE )
               ::lPressed = .f.
               exit
            endif
            SysRefresh()
         next

      endif
      ::lMoved = .F.

      ::Refresh()
      ::nStartTime      = 0
      ::nStartMRow      = 0

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

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TXBrowse

   ::lPressed = .f.
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nLen, nFor, nPos
   local cTxt  // tooltip CELL
   local nVMove, nHMove, nOldRowPos,  nOldColPos
   local nMousePos := ::MouseRowPos( nRow )

   TrackMouseEvent( ::hWnd, TME_LEAVE )

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

   if ::lPressed
      if ::nStartTime == 0
         ::nStartTime := GetTickCount()
      endif
   else
      ::nStartTime := 0
      ::nEllapsed := 0
   endif

   if ::lPressed .and. ! ::lCaptured

      SetCursor( ::hCursorHand )

      nVMove        = ::nRowAdvance - ::MouseRowPos( nRow )
      ::nRowAdvance = nMousePos
      nHMove        = ::MouseColPos( nCol ) - ::nColAdvance

      if nHMove < 0
         ::nColSel := ::LastDisplayPos( .T. )
         ::GoRight()
      elseif nHMove > 0
         ::nColSel := 1
         ::GoLeft()
      endif

      ::nColAdvance = ::MouseColPos( nCol )

      if nVMove > 0

         if ::lDown
            ::nStartMRow = nMousePos
            ::nStartTime := GetTickCount()
         endif
         nOldRowPos = ::nRowSel

         if ::cAlias == "ARRAY"
            ::nArrayAt += ( ::RowCount() - ::nRowSel )
         endif

         ::nRowSel =  ::RowCount()
         if ::cAlias == "ARRAY"
            ::lDrawSelected = .F.
            ::GoDown()
         endif
         ::Refresh()
         ::nRowSel = Max( 1, nOldRowPos - 1 )


         if ::cAlias == "ARRAY"
            ::nArrayAt-= ( ::RowCount() - ::nRowSel )
         else
            if ( ::nLen - ::RowCount() + ::nRowSel + 1)  <= ::KeyNo()
               ::Skip( -1 )
            endif
         endif

         ::lDrawSelected = .T.
         ::Refresh()
         ::lDown = .F.
      elseif nVMove < 0
         if ! ::lDown
            ::nStartMRow = nMousePos
            ::nStartTime := GetTickCount()
         endif
         nOldRowPos = ::nRowSel

         if ::cAlias == "ARRAY"
            ::nArrayAt -= ( ::RowCount() - ::nRowSel )
         endif

         ::nRowSel = 1
         if ::cAlias == "ARRAY"
            ::lDrawSelected = .F.
            ::GoUp()
         endif
         ::Refresh()
         ::nRowSel = nOldRowPos + 1
         if ::cAlias == "ARRAY"
            ::nArrayAt+= ( ::RowCount() - ::nRowSel )
         else
            if ( ::KeyNo() == ::nRowSel - 1)
               ::Skip( )
               ::nRowSel = ::KeyNo()
            endif
         endif

         ::lDrawSelected = .T.
         ::Refresh()
         ::lDown = .T.
      endif

      if ::nRowSel != nMousePos
         ::nRowSel = nMousePos
      endif
      return nil

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

   nFor     := If( nRow < ::HeaderHeight(), ::MouseColPos( nCol ), 0 )

   // ToolTip CELL
   if nFor > 0 .and. nFor <= nLen
      oCol  := ::ColAtPos( nFor )
      CursorArrow()
      if Empty( oCol:cToolTip )
         ::DestroyToolTip()
      else
         if ::oColToolTip == nil .or. ::oColToolTip:nCreationOrder != oCol:nCreationOrder
            ::DestroyToolTip()
            ::ShowToolTip( nRow,nCol, oCol:cToolTip )
            ::oColToolTip := oCol
         endif
      endif
      return 0

   elseif ( nFor := If( nRow > ::HeaderHeight(), ::MouseColPos( nCol ), 0 ) ) > 0
       if nFor > 0 .and. nFor <= nLen
         oCol  := ::ColAtPos( ::MouseColPos( nCol ) )
         CursorArrow()
         if  ::MouseColPos( nCol ) > 0
                  if Empty( oCol:bToolTip )
                     ::DestroyToolTip()
                  else
                  if ::oColToolTip == nil .or. ::oColToolTip:nCreationOrder != oCol:nCreationOrder
                       cTxt := eval( oCol:bToolTip, Self, nRow, nCol, nkeyFlags )
                        if !empty( cTxt )
                           ::DestroyToolTip()
                           ::ShowToolTip( nRow,nCol, cTxt )
                           ::oColToolTip := oCol
                        endif
                     endif
                  endif
            endif
            return 0
         endif
      else
      if ::oColToolTip != nil
         ::DestroyToolTip()
      endif
      ::CheckToolTip()
   endif

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

   ::CancelEdit()
   ::Seek()

   ::Refresh()

   nColPos := ::MouseColPos( nCol )
   nRowPos := ::MouseRowPos( nRow )

   if nColPos == ::nColSel .and. nRowPos == ::nRowSel
      oCol := ::ColAtPos( nColPos )

      if oCol:lEditable .and. oCol:bLDClickData == nil

         if oCol:hChecked .and. oCol:bOnPostEdit != nil

            oCol:CheckToggle()
            return 0             // ver 9.06
         else
            return oCol:Edit()
         endif
      elseif oCol:bLDClickData != nil
         return Eval( oCol:bLDClickData, nRow, nCol, nKeyFlags, oCol )
      elseif ValType( oCol:Value ) $ 'AHO'
         return XBrowse( oCol:Value, oCol:cHeader, nil, nil, nil, nil, nil, ;
                  oCol:nEditType > 0 )
      endif
   endif

   If nColPos != 0 .and. nRowPos != 0
      return Super:LDblClick( nRow, nCol, nKeyFlags )
   Endif

return 0

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nColPos, nRowPos
   local bPopUp

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

   oCol     := ::ColAtPos( nColPos )
   bPopUp   := ifnil( oCol:bPopUp, ::bPopUp )

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
      if ! ::FullPaint()
         ::DrawLine()
      endif
      if nRowPos > 0
         ::Skip( nRowPos - ::nRowSel )               // Eval( ::bSkip, nRowPos - ::nRowSel )
         ::nRowSel := nRowPos
         ::Change( .t. )
      endif
      if nColPos > 0
         ::nColSel := nColPos
      endif
      if ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS
         ::Select(1)
      endif
      if ::FullPaint()
         ::Super:Refresh( .t. ) // ::Paint()
      else
         ::DrawLine( .t. )
      endif
      if ::oVScroll != nil
         ::VSetPos( ::KeyNo() )
      endif
      if bPopUp != nil
         return Eval( bPopUp, oCol ):Activate( (::nRowSel * ::nRowHeight) + ::nHeaderHeight, oCol:nDisplayCol, Self )
      elseif oCol:bRClickData != nil
         return Eval( oCol:bRClickData, nRow , nCol, nKeyFlags, oCol )
      endif
   else
      if bPopUp != nil
         Eval( bPopUp, oCol ):Activate( (::nRowSel * ::nRowHeight) + ::nHeaderHeight, oCol:nDisplayCol, Self )
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

/*
METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TXBrowse

   local aPoint := { nYPos, nXPos }

   ScreenToClient( ::hWnd, aPoint )

   if IsOverWnd( ::hWnd, aPoint[ 1 ], aPoint[ 2 ] ) .and. ;
      ::MouseRowPos( aPoint[ 1 ] ) > 0

      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            ::PageUp()
         else
            ::PageDown()
         endif
      else
         if nDelta > 0
            ::GoUp( WheelScroll() )
         else
            ::GoDown( WheelScroll() )
         endif
      endif

   endif

Return nil
*/

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

METHOD SetRDD( lAddColumns, lAutoOrder, aFldNames, aRows ) CLASS TXBrowse

   local oCol, aStruct
   local cAlias, cAdsKeyNo, cAdsKeyCount
   local nFields, nFor
   local bOnSkip

   if Empty( ::cAlias )
      ::cAlias := Alias()
      if Empty( ::cAlias )
         return nil
      endif
   endif

   if ::lCreated
      if ::nDataType == DATATYPE_RDD
         if SameDbfStruct( Self, Alias() )
            return nil
         endif
      endif
      ::cAlias := Alias()
      ::ClearBlocks()
      ::aCols  := {}
   endif

   DEFAULT lAddColumns      := Empty( ::aCols ) .or. ! Empty( aFldNames )
   DEFAULT lAutoOrder       := ::lAutoSort

   cAlias      := ::cAlias
   if ValType( aRows ) == 'A' .and. Len( aRows ) > 0

      if ValType( aRows[ 1 ] ) == 'A'
         bOnSkip        := { | oBrw | ( oBrw:cAlias )->( DbGoTo( oBrw:aArrayData[ oBrw:nArrayAt ][ 1 ] ) ) }
      else
         bOnSkip        := { | oBrw | ( oBrw:cAlias )->( DbGoTo( oBrw:aArrayData[ oBrw:nArrayAt ] ) ) }
      endif
      ::SetArray( aRows, .f., 0, .f., bOnSkip )
      ::nDataType       := nOr( DATATYPE_RDD, DATATYPE_ARRAY )
      lAutoOrder        := .f.
   else
      ::nDataType := DATATYPE_RDD
   endif

   DEFAULT ::bGoTop    := {|| ( ::cAlias )->( DbGoTop() ) }
   DEFAULT ::bGoBottom := {|| ( ::cAlias )->( DbGoBottom() ) }
   DEFAULT ::bSkip     := {| n | iif( n == nil, n := 1, ), ( ::cAlias )->( DbSkipper( n ) ) }
   DEFAULT ::bBof      := {|| ( ::cAlias )->( Bof() ) }
   DEFAULT ::bEof      := {|| ( ::cAlias )->( Eof() ) }
   DEFAULT ::bBookMark := {| n | iif( n == nil, ( ::cAlias )->( RecNo() ), ( ::cAlias )->( DbGoto( n ) ) ) }

   If ( "ADS"$( ::cAlias )->( RddName() ) .or. 'ADT' $ ( ::cAlias )->( RddName() ) ) .and. ;
      ( ::cAlias )->( LastRec() ) > 200

      // Modified in FWH 9.06
      // AdsGetRelKeyPos() returns approximate position as % and when multipilied by 100 and rounded off
      // returns incorrect values occassionally on smaller  tables. OrdKeyNo() mapped to AdsKeyNo() gives reliable
      // result in such cases. For large tables OrdKeyNo() is unacceptably slow. Limit of 200 is chosen because
      // 0.5% is 1/200.

      cAdsKeyNo    := "{| n, Self | iif( n == nil, " +;
                         "Round( " + cAlias + "->( ADSGetRelKeyPos() ) * Self:nLen, 0 ), "+;
                         cAlias + "->( ADSSetRelKeyPos( n / Self:nLen ) ) ) }"

      cAdsKeyCount := "{|| " + cAlias + "->( ADSKeyCount(,,1) )}"

      DEFAULT ::bKeyNo    := &cAdsKeyNo ,;
              ::bKeyCount := &cAdsKeyCount
   else
       DEFAULT ::bKeyNo    := {| n | iif( n == nil,;
                                        ( ::cAlias )->( OrdKeyNo() ),;
                                        ( ::cAlias )->( OrdKeyGoto( n );
                                        ) ) },;
               ::bKeyCount := {|| ( ::cAlias )->( OrdKeyCount() ) }
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
         else
            ::aCols[nFor]:cSortOrder := ( cAlias )->( FindTag( ::aCols[ nFor ]:cHeader ) )
         endif
      next nFor
   endif

   if lAutoOrder
      ::bSeek     := { |c| If( Upper(Left((::cAlias)->(OrdKey()),5))=='UPPER', c := Upper( c ), ), ;
                           If( ::lSeekWild, (::cAlias)->( OrdWildSeek( '*' + c + '*' ) ), ;
                               (::cAlias)->( DbSeek( c ) ) ) }

   endif

   ::bLock     := { || ( ::cAlias )->( DbrLock() ) }
   ::bUnlock   := { || ( ::cAlias )->( DbrUnlock() ) }

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetArray( aData, lAutoOrder, nColOrder, aCols, bOnSkip ) CLASS TXBrowse

   local oCol
   local nFor, lAddCols, aWidths
   local lReset   := .f.


   if aData == nil //.or. ( Len( aData ) == 0 .and. Empty( aCols ) )
      return nil
   endif

   if ::lCreated
      if ::nDataType == DATATYPE_ARRAY
         if SameArrayStruct( Self, aData ) //.or. empty( ::aArrayData )
            ::aArrayData = aData
            return nil
         else
            ::aCols  := {}
            lReSet   := .t.
         endif
      else
         ::ClearBlocks()
         if !empty( ::aCols )
            ::bBof   := ::bEof := NIL
            ::bKeyCount := ::bKeyNo := ::bBookMark := NIL
            if valtype( ::aArrayData ) == "U"
               aCols := .f.
            endif
         else
            ::aCols  := {}
         endif
         lReset   := .t.
      endif
   endif

   DEFAULT lAutoOrder := ::lAutosort, nColOrder := 1
   DEFAULT lAutoOrder := .f.

   ::nRowSel    := 1
   ::nArrayAt   := 1
   ::aArrayData := aData
   if ValType( bOnSkip ) == 'B'
      ::bOnSkip   := bOnSkip
   endif
   ::nDataType  := DATATYPE_ARRAY


   DEFAULT ::bGoTop    := { || ::nArrayAt := Min( 1, Len( ::aArrayData ) ), Eval( ::bOnSkip, Self ) }, ;
           ::bGoBottom := { || ::nArrayAt := Len( ::aArrayData ), Eval( ::bOnSkip, Self ) }, ;
           ::bSkip     := { | nSkip, nOld | ;
                            If( nSkip == nil, nSkip := 1, ), ;
                            nOld       := ::nArrayAt, ;
                            ::nArrayAt += nSkip, ;
                            ::nArrayAt := Min( Max( ::nArrayAt, 1 ), Len( ::aArrayData ) ), ;
                            Eval( ::bOnSkip, Self ), ;
                            ::nArrayAt - nOld }, ;
           ::bBof      := { || ::nArrayAt < 1 }, ;
           ::bEof      := { || ::nArrayAt > Len( ::aArrayData ) }, ;
           ::bBookMark := { | n | If( n == nil, ::nArrayAt, ;
                                 ( ::nArrayAt := n, Eval( ::bOnSkip, Self ), n ) ) }, ;
           ::bKeyNo    := ::bBookMark, ;
           ::bKeyCount := { || Len( ::aArrayData ) }



   lAddCols := Empty( ::aCols )
   if ValType( aCols ) == 'L'
      lAddCols       := aCols
      aCols          := nil
   endif



   if ValType( ::aArrayData ) == 'H' .and. Empty( ::aCols ) .and. lAddCols

      WITH OBJECT ::AddCol()
         :cHeader    := "Key"
         :bEditValue := { || hb_hKeyAt( aData, ::nArrayAt ) }
      END

      WITH OBJECT ::AddCol()
         :cHeader    := "Value"
         :bEditValue := { || hb_hValueAt( aData, ::nArrayAt ) }
      END
      ::bSeek        := nil
      lAddCols       := .f.

   else

      if Len( aData ) > 0 .and. ValType( aData[ 1 ] ) == 'H' .and. ;
         ValType( ATail( aData ) ) == 'H' .and. lAddCols

         AEval( aData, { |h| hb_hCaseMatch( h, .f. ) } )

         if Empty( aCols )
            for nFor := 1 to Len( aData[ 1 ] )
               WITH OBJECT ::AddCol()
                  :cHeader    := hb_hKeyAt( aData[ 1 ], nFor )
                  :bEditValue := HashEditBlock( Self, :cHeader )
               END
            next nFor
         else
            for nFor := 1 to Len( aCols )
               WITH OBJECT ::AddCol()
                  :cHeader := aCols[ nFor ]
                  :bEditValue := HashEditBlock( Self, :cHeader )
               END
            next nFor
         endif

         lAddCols := .f.
      endif

   endif

   if lAddCols
      ::aCols := {}
      if Empty( aData )
         DEFAULT aCols := { 1 }
      endif
      aWidths  := ArrCalcWidths( aData, If( Empty( aCols ), 1, Len( aCols ) ) )
      if Empty( aCols )
         for nFor := 1 to Len( aWidths ) //Len( aData[ 1 ] )
            oCol                 := ::AddCol()
            oCol:nArrayCol       := nFor
            oCol:nDataLen        := aWidths[ nFor ]
         next nFor
      else
         for nFor := 1 to Len( aCols )
            oCol               := ::AddCol()
            oCol:nArrayCol     := aCols[ nFor ]
            oCol:nDataLen      := aWidths[ oCol:nArrayCol ]
         next nFor
      endif
      AEval( ::aCols, {|oCol| oCol:cHeader := 'Col-' + LTrim(str(oCol:nArrayCol)) } )
      if lAutoOrder
         if ValType( aData[ 1 ] ) == 'A'
            AEval( ::aCols, {|oCol| oCol:cSortOrder := oCol:nArrayCol, ;
                            If( oCol:nArrayCol == nColOrder, ;
                                 (oCol:cOrder := 'D', oCol:SortArrayData() ), ;
                                 nil ) ;
                            } )
            ::bSeek := { | c | SeekOnArray( Self, ::aArrayData, c ) }
         else
            oCol:cOrder := 'D'
            oCol:cSortOrder := 1
            oCol:SortArrayData()
         endif
      endif
   endif

   if lReSet .and. ::lCreated
      ::Adjust()
      ::Refresh()
   endif

   ::lExcelCellWise  := .t.

return Self

//------------------------------------------------------------------------------//

static function HashEditBlock( oBrw, c )
return { |x| If( x == nil, oBrw:aRow[ c ], oBrw:aRow[ c ] := x ) }

//------------------------------------------------------------------//

static function ArrCalcWidths( aData, nCols )

   local aSizes
   local nRow, nCol, nRows, cType, n, uVal, aRow

   DEFAULT nCols := 1

   nRows       := Len( aData )
   aSizes      := Array( nCols )

   if nRows > 0
      for nRow := 1 to nRows
         aRow  := aData[ nRow ]
         if ValType( aRow ) != 'A'  // Row need not be an array
            aRow  := { aRow }
         endif
         nCols   := Len( aRow ) // ragged arrays possible
         if nCols > Len( aSizes )
            ASize( aSizes, nCols )
         endif
         nCols   := Min( Len( aRow ), nCols )
         for nCol := 1 to nCols
            uVal  := aRow[ nCol ]
            cType := ValType( uVal )
            if cType == 'C'
               if ( n := Len( Trim( uVal ) ) ) > IfNil( aSizes[ nCol ], 0 )
                  aSizes[ nCol ] := n
               endif
            else
               if ( n := Len( cValToStr( uVal ) ) ) > IfNil( aSizes[ nCol ], 0 )
                  aSizes[ nCol ] := n
               endif

            endif
         next nCol
      next nRow
   endif

   for n := 1 to Len( aSizes )
      if aSizes[ n ] == nil
         aSizes[ n ] := 10
      endif
   next n

return aSizes

//------------------------------------------------------------------//

METHOD ArrCell( nRow, nCol, cPic ) CLASS TXBrowse

   local uVal

   TRY
      uVal  := ::aArrayData[ nRow ]
   CATCH
      uVal  := {}
   END
   if nCol != nil
      if ValType( uVal ) == 'A'
         if nCol > 0 .and. nCol <= Len( uVal )
            uVal  := uVal[ nCol ]
         else
            uVal  := nil
         endif
      elseif !( nCol == 1 )
         uVal  := nil
      endif
   endif
   if PCount() > 2
      if uVal == nil
         uVal  := ""
      else
         uVal  := cValToStr( uVal, cPic )
      endif
   endif

return uVal

//----------------------------------------------------------------------------//

METHOD ArrCellSet( nRow, nCol, uNewVal ) CLASS TXBrowse

   local uRow

   if nRow > 0 .and. nRow <= Len( ::aArrayData )
      uRow  := ::aArrayData[ nRow ]
      if ValType( uRow ) == 'A'
         if nCol > 0 .and. nCol <= Len( uRow )
            ::aArrayData[ nRow, nCol ] := uNewVal
         endif
      elseif nCol == 1
         ::aArrayData[ nRow ] := uNewVal
      endif
   endif

return ::ArrCell( nRow, nCol )

//------------------------------------------------------------------------------//

METHOD SetAdO( oRs, lAddCols, lAutoOrder, aFldNames ) CLASS TXBrowse

   LOCAL nFields,nFor, oCol

   if ::lCreated
      if ::nDataType == DATATYPE_ARRAY
         if SameAdoStruct( Self, oRs )
            return nil
         else
            ::aCols  := {}
         endif
      else
         ::ClearBlocks()
         ::aCols  := {}
      endif
   endif

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

   ::bSeek  := { |c| AdoSeek( ::oRs, c, , ::lSeekWild ) }

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ClearBlocks() CLASS TXBrowse

   ::bGoTop := ::bGoBottom := ::bSkip := ::bBof := ::bEof := ::bBookMark := ::bKeyNo := ::bKeyCount := nil
   ::nStretchCol     := nil
   ::nHeaderHeight   := nil
   ::nFooterHeight   := nil

return Self

//----------------------------------------------------------------------------//

METHOD aJustify( aNew ) CLASS TXBrowse

   local aJust
   local n, nCols := Len( ::aCols )
   local oCol, j

   if aNew != nil
      for n := 1 to nCols
         oCol     := ::aCols[ n ]
         if oCol:nCreationOrder <= Len( aNew )
            j     := aNew[ oCol:nCreationOrder ]
            if Valtype( j ) == 'L'
               j  := If( j, AL_RIGHT, AL_LEFT )
            elseif ValType( j ) == 'N'
               j  := Min( 3, Max( 0, j ) )  // Align TEXT from COMMAND @ 0,0
            endif
            if ValType( j ) == 'N'
               oCol:nDataStrAlign  := j
            endif
         endif
      next
   endif

   aJust    := Array( nCols )
   for n := 1 to nCols
      oCol  := ::aCols[ n ]
      j     := oCol:nDataStrAlign
      j     := If( j == AL_RIGHT, .t., If( j == AL_LEFT, .f. , AL_CENTER ) )
      aJust[ oCol:nCreationOrder ] := j
   next

return aJust

//----------------------------------------------------------------------------//

METHOD SetColFromADO( cnCol, lAutoOrder ) CLASS TXBrowse

   LOCAL   nType, cType, nLen, nDec, cName
   LOCAL   oCol, oField

   oField           := ::oRs:Fields( cnCol )
   oCol             := ::AddCol()

   oCol:cHeader     := If( ValType( cnCol ) == 'C', cnCol, oField:Name )

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

   if cType == nil
      if nType == 205 // adLongVarBinary : assumed Image.
         oCol:cDataTye     := 'P'
      elseif nType == 136 // adChapter
         oCol:bEditValue   := { || ::oRs:Fields( cnCol ):Value }
         oCol:bStrData     := { || "<Child>" }
      else
         oCol:bEditValue   := { || "..." }
      endif
   else
      oCol:bEditValue   := { | x | If( x == nil, ::oRs:Fields( cnCol ):Value, ;
                                    ::oRs:Fields( cnCol ):Value := x ) }
   endif


   oCol:bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE, o:Value := x, ) }
   oCol:cDataType    := If( cType == nil, 'C', cType )
   oCol:nDataLen     := nLen
   if nDec != nil
      oCol:nDataDec  := Min( nDec, 2 )
   endif

   if lAutoOrder
      oCol:cSortOrder   := oCol:cHeader
   endif

return oCol
//----------------------------------------------------------------------------//

static function AdoSeek( oRs, uSeek, lSoft, lWildSeek )

   local lFound   := .f.
   local cCol     := StrToken( oRs:Sort, 1 )
   local cExpr    := ''
   local cType, d, uVal

   if ! Empty( cCol ) .and. ! oRs:Eof() .and. ! oRs:Bof()

      DEFAULT lSoft := Set(_SET_SOFTSEEK), lWildSeek := .f.

      cType       := ValType( uVal := oRs:Fields( cCol ):Value )

      do case
      case cType == 'C'

         if lWildSeek
            lSoft    := .f.
            cExpr    := cCol + " LIKE '*" + uSeek + "*'"
         else
            cExpr    := If( Set( _SET_EXACT ), cCol + " = '" + uSeek + "'", ;
                                               cCol + " LIKE '" + uSeek + "*'" )
         endif

      case cType == 'N'
         cExpr    := cCol + " >= " + ;
                     LTrim( Str( Val( uSeek ) ) )
      case cType == 'D'

         if Empty( d := CToD( uSeek ) )
            d  := CToD( uSeek + SubStr( DToC( uVal ), Len( uSeek ) + 1 ) )
         endif
         if ! Empty( d )
            cExpr    := cCol + " >= #" + ;
                        StrZero( Year( d ), 4 ) + "-" + ;
                        StrZero( Month( d ), 2 ) + "-" + ;
                        StrZero( Day( d ), 2 ) + "#"

         endif
      endcase

      if ! Empty( cExpr )
         oRs:Find( cExpr, 0, 1, 1 )
         if oRs:Eof() .and. lSoft .and. cType == 'C'
            oRs:MoveFirst()
            cExpr := cCol + " > '" + uSeek + "'"
            oRs:Find( cExpr, 0, 1, 1 )
         endif
         if oRs:Eof()
            oRs:MoveLast()
         else
            lFound   := .t.
         endif
      endif

   endif


return lFound

//----------------------------------------------------------------------------//

METHOD SetTree( oTree, aResource, bOnSkip ) CLASS TXBrowse

   local oCol, nBmp1 := 0, nBmp2 := 0, nBmp3 := 0
   local n, nLevels, aBlocks, bBookMark

   DEFAULT oTree     := 2

   if ValType( oTree ) == 'N'
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

   DEFAULT bOnSkip   := { || nil }

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

   if ValType( aResource ) == 'A'
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

   ::bGoTop             := {|| oDbf:GoTop() }
   ::bGoBottom          := {|| oDbf:GoBottom()  }
   ::bSkip              := {| n | oDbf:Skipper( If( n == nil,1,n) )}
   ::bBof               := {|| oDbf:Bof() }
   ::bEof               := {|| oDbf:Eof() }
   ::bBookMark          := {| n | iif( n == nil, ( oDbf:RecNo() ), ( oDbf:GoTo( n ) ) ) }
   ::bKeyNo             := {| n | iif( n == nil, ( oDbf:OrdKeyNo() ), ( oDbf:OrdKeyGoto( n ) ) ) }
   ::bKeyCount          := {|| oDbf:OrdKeyCount() }


   ::nDataType         := DATATYPE_ODBF
   ::oDbf              := oDbf

   if aCols != nil
      for n := 1 to Len( aCols )
         AddoDbfCol( Self, acols[ n ] )
      next
   endif

   ::bOnRowLeave        := { || ::oDbf:Save() }

return Self

/*
METHOD SetoDbf( oDbf, aCols, lAutoSort, lAutoCols, aRows ) CLASS TXBrowse

   local n, oCol, oRs
   local bOnSkip

   DEFAULT lAutoSort   := .f., ;
           lAutoCols   := .f.

   if ValType( aRows ) == 'A' .and. Len( aRows ) > 0

      if ValType( aRows[ 1 ] ) == 'A'
         bOnSkip        := { | oBrw | oBrw:oDbf:GoTo( oBrw:aArrayData[ oBrw:nArrayAt ][ 1 ] ) }
      else
         bOnSkip        := { | oBrw | oBrw:oDbf:GoTo( oBrw:aArrayData[ oBrw:nArrayAt ] ) }
      endif
      ::SetArray( aRows, .f., 0, .f., bOnSkip )
      ::nDataType       := nOr( DATATYPE_ODBF, DATATYPE_ARRAY )
      lAutoSort         := .f.

   else

      DEFAULT ::bGoTop    := {|| oDbf:GoTop() },;
              ::bGoBottom := {|| oDbf:GoBottom()  },;
              ::bSkip     := {| n | oDbf:Skipper( If( n == nil, 1, n ) ) }, ;
              ::bBof      := {|| oDbf:Bof() },;
              ::bEof      := {|| oDbf:Eof() }

      if __ObjHasMethod( oDbf, 'BOOKMARK' )

         DEFAULT ::bBookMark := { |u| oDbf:BookMark( u ) }

      else

         DEFAULT ::bBookMark := {| n | If( n == nil,;
                                 ( oDbf:RecNo() ),;
                                 ( oDbf:GoTo( n ) ) ) }

      endif
      if __ObjHasMethod( oDbf, 'KEYNO' ) .and. __ObjHasMethod( oDbf, 'KEYCOUNT' ) .and. ;
         __ObjHasMethod( oDbf, 'KEYGOTO' )
         DEFAULT ;
         ::bKeyNo := { |n| If( n == nil, oDbf:KeyNo(), oDbf:KeyGoTo( n ) ) }, ;
         ::bKeyCount := { || oDbf:KeyCount() }
      else
         DEFAULT ;
         ::bKeyNo    :=::bBookMark,;
         ::bKeyCount := {|| oDbf:RecCount()}

      endif

      ::nDataType         := DATATYPE_ODBF

   endif

   ::oDbf              := oDbf

   if Empty( aCols ) .and. lAutoCols
      if __ObjHasData( oDbf, 'cAlias' ) .and. __ObjHasData( oDbf, 'nArea' ) .and. ;
         Select( oDbf:cAlias ) == oDbf:nArea .and. ! Empty( oDbf:cAlias ) .and. ;
         ! Empty( oDbf:nArea )

         // TDataBase like Object
         aCols := {}
         AEval( ( oDbf:nArea )->( DbStruct() ), { |a| AAdd( aCols, a[ 1 ] ) } )

      elseif __ObjHasData( oDbf, "oRs" )
         oRs   := oDbf:oRs

      elseif __ObjHasData( oDbf, "orecset" )
         oRs   := oDbf:oRecSet

      endif

      if ! Empty( oRs )
         aCols := {}
         for n := 0 to oRs:Fields:Count() - 1
            AAdd( aCols, oRs:Fields( n ):Name )
         next n
      endif
   endif

   if aCols != nil
      for n := 1 to Len( aCols )
         AddoDbfCol( Self, acols[ n ], If( __objHasData( oDbf, 'aStruct' ), oDbf:aStruct, nil ) )
         if lAutoSort
            ::aCols[ n ]:cSortOrder := aCols[ n ]
         endif
      next
   endif

   ::bOnRowLeave        := { || ::oDbf:Save() }

   ::bSeek  := { |c| ::oDbf:Seek( c, , ::lSeekWild ) }


return Self
*/
//----------------------------------------------------------------------------//

METHOD SetBackGround( uBack, uBckMode ) CLASS TXBrowse

   local hBmp, oBrush, nFormat := 0

   if uBack == nil .and. uBckMode == nil
      // cancel background
      ::lTransparent := .f.
      if ::oBrush:hBitmap != 0 .and. ValType( ::oBrush:Cargo ) == 'N'
         if ::oBrush:Cargo != ::oBrush:hBrush
            DeleteObject( ::oBrush:hBrush )
            ::oBrush:hBrush := ::oBrush:Cargo
         endif
      endif
      ::SetColor( ::nClrText, ::nClrPane )
      if ::lCreated
         ::Refresh()
      endif
   else
      ::lTransparent    := .t.
      if uBack == nil
         if Valtype( uBckMode ) == 'L' .and. ValType( ::oBrush:Cargo ) == 'A' .and. ;
                  ::oBrush:Cargo[ 2 ] != uBckMode
            ::oBrush:Cargo[ 2 ] := uBckMode
            ::MakeBrush()
         elseif ValType( uBckMode ) == 'N' .and. ::nBckMode != uBckMode
            ::nBckMode  := uBckMode
            ::MakeBrush()
         endif
      else
         if ValType( uBack ) == 'A'
            if uBckMode == nil
               if ValType( ::oBrush:Cargo ) == 'A'
                  uBckMode    := ::oBrush:Cargo[ 2 ]
               endif
            endif
            oBrush   := TBrush():New()
            oBrush:Cargo   := { AClone( uBack ), IfNil( uBckMode, .t. ) }
            ::SetBrush( oBrush )
         else
            if ValType( uBckMode ) == 'N'
               ::nBckMode  := uBckMode
            endif
            if ValType( uBack ) == 'C'
               if '.' $ uBack
                  if Lower( cFileExt( uBack ) ) == 'bmp'
                     hBmp     := ReadBitmap( 0, uBack )
                  else
                     hBmp     := FILoadImg( uBack, @nFormat )
                  endif
               else
                  hBmp        := LoadBitmap( GetResources(), uBack )
               endif
            elseif ValType( uBack ) == 'N'
               hBmp     := ResizeBitmap( uBack )
            elseif ValType( uBack ) == 'O'
               hBmp     := ResizeBitmap( uBack:hBitmap )
            endif
            if ! Empty( hBmp )
               if ::oBrush:hBitmap != 0 .and. ValType( ::oBrush:Cargo ) == 'N'
                  if ::oBrush:Cargo != ::oBrush:hBrush
                     DeleteObject( ::oBrush:hBrush )
                     ::oBrush:hBrush   := ::oBrush:Cargo
                  endif
               endif
               oBrush         := TBrush():New( nil, nil, nil, nil, hBmp )
               oBrush:nBmpFormat := nFormat
               oBrush:Cargo   := oBrush:hBrush  // save original brush handle in cargo
               ::SetBrush( oBrush )
            endif
         endif
         ::MakeBrush()
      endif
   endif

return Self

//------------------------------------------------------------------//

METHOD MakeBrush() CLASS TXBrowse

   local aRect, hBmp, aFullRect  := GetClientRect( ::hWnd )
   local x, y, nWidth, nHeight, nBmpW, nBmpH

   if ::lTransparent
      if ValType( ::oBrush:Cargo ) == 'A'
         if Empty( ::oBrush:cBmpRes ) .and. ! Empty( ::nID )
            ::oBrush:cBmpRes  := LTrim( Str( ::nID ) )
            // to make this brush unique to prevent premature destruction by TBrush Class
         endif
         GradientBrush( Self, ::OBrush:Cargo[ 1 ], ::oBrush:Cargo[ 2 ] )
      else

         WITH OBJECT ::oBrush
            if :hBitmap != 0
               if :Cargo == nil       // cargo to have ref of original handle
                  :Cargo   := :hBrush
               endif
               if ::nBckMode == 0
                  if :hBrush != :Cargo
                     DeleteObject( :hBrush )
                     :hBrush  := :Cargo
                  endif
               else
                  aRect          := ::DataRect()
                  nWidth         := aRect[ 4 ] - aRect[ 2 ] + 1
                  nHeight        := aRect[ 3 ] - aRect[ 1 ] + 1
                  hBmp           := ResizeBitmap( :hBitmap, nWidth, nHeight, ::nBckMode )
                  if :hBrush != :Cargo
                     DeleteObject( :hBrush )
                  endif
                  :hBrush   := CreatePatternBrush( hBmp )
                  DeleteObject( hBmp )
               endif
            endif
         END

      endif

      if ::lCreated
         ::Refresh()
      endif
   endif

return Self

//------------------------------------------------------------------//

METHOD DataRect() CLASS TXBrowse

   local aRect    := GetClientRect( ::hWnd )

   if ::lRecordSelector
      aRect[ 2 ]  += RECORDSELECTOR_WIDTH
   endif
   if ::lHeader
      aRect[ 1 ]  += ::HeaderHeight()
   endif
   if ::lFooter
      aRect[ 3 ]  -= ::FooterHeight()
   endif

return aRect

//------------------------------------------------------------------//

METHOD cBmpAdjBrush( cFile ) CLASS TXBrowse

   ::SetBackGround( cFile )

return cFile

//------------------------------------------------------------------//

METHOD AddCol() CLASS TXBrowse

   local oCol

   oCol  := Eval( ::bColClass ):New( Self )

   Aadd( ::aCols, oCol )

   oCol:nCreationOrder := Len( ::aCols )

return oCol

//----------------------------------------------------------------------------//

METHOD InsCol( nPos ) CLASS TXBrowse

   local oCol
   local nFor

   DEFAULT nPos := Len( ::aCols )

   oCol  := Eval( ::bColClass ):New( Self )

   Aadd( ::aCols, nil )
   Ains( ::aCols, nPos )

   ::aCols[ nPos ] := oCol

   for nFor := nPos to Len( ::aCols )
      ::aCols[ nFor ]:nCreationOrder := nFor
   next

   ::GetDisplayCols()
   ::Super:Refresh()

return oCol

//----------------------------------------------------------------------------//

METHOD DelCol( nPos ) CLASS TXBrowse

   local nFor

   ::aCols[ nPos ]:End()

   ADel( ::aCols, nPos )
   ASize( ::aCols, Len( ::aCols ) - 1 )

//   for nFor := nPos + 1 to Len( ::aCols )
   for nFor := nPos to Len( ::aCols )
      ::aCols[ nFor ]:nCreationOrder := nFor
   next

   ::GetDisplayCols()
   ::Super:Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD AddColumn( cHead, bData, cPic, uClrFore, uClrBack, ;
                  cAlign, nWidth, lBitmap, lEdit, bOnPostEdit,  ;
                  cMsg, bWhen, bValid, cErr, lHilite, ncOrder,;
                  nAt, bBmpData, aBmp, lHide, nTot, bFooter, uCargo )

   local oCol, uTemp

   // This method is intended only to support command syntax
   // and this method should not be called directly in the
   // application program

   if ValType( nAt ) == 'O' .and. nAt:IsKindOf( TXBrwColumn() ) // Upper( nAt:className ) == "TXBRWCOLUMN"
      nAt   := nAt:nCreationOrder
   endif
   if ValType( nAt ) == 'N' .and. nAt > 0 .and. nAt <= Len( ::aCols )
      oCol  := ::InsCol( nAt )
   else
      oCol  := ::AddCol()
   endif

   oCol:cHeader      := cHead
   oCol:cEditPicture := cPic

   if bData != nil
      if lBitmap .and. bBmpData == nil
         oCol:bBmpData        := bData
      else
         if ValType( bData ) == 'N'
            oCol:nArrayCol    := bData
         else
            oCol:bEditValue   := bData
         endif
      endif
   endif

   if bBmpData != nil
      oCol:bBmpData  := bBmpData
   endif

   if cAlign != nil
      cAlign            := Upper( Left( cAlign, 1 ) )
      cAlign            := iif( cAlign == 'R', AL_RIGHT, iif( cAlign == 'C', AL_CENTER, nil ) )
      if cAlign != nil
         oCol:nHeadStrAlign := oCol:nDataStrAlign := oCol:nFootStrAlign := cAlign
      endif
   endif

   if ValType( nWidth ) == 'N'
      oCol:nWidth       := nWidth
   endif

   if lEdit .or. ValType( bOnPostEdit ) == 'B' .or. ValType( bValid ) == 'B' .or. ValType( bWhen ) == "B"
      oCol:nEditType   := 1
      oCol:bEditWhen   := bWhen
      oCol:bEditValid  := bValid
      if bOnPostEdit == nil
         oCol:bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE .and. Eval( o:oBrw:bLock ), ;
          o:Value := x, ) }

      else
         oCol:bOnPostEdit := bOnPostEdit
      endif

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

   if ValType( aBmp ) == 'A'
      AEval( aBmp, { |c| If( "." $ c, oCol:AddBmpFile( c ), oCol:AddResource( c ) ) } )
   endif

   oCol:lHide     := lHide

   if ValType( nTot ) == 'N'
      oCol:nTotal := nTot
      oCol:lTotal  := .t.
   endif
   if ValType( bFooter ) == 'B'
      oCol:bFooter := bFooter
   elseif ValType( nTot ) == 'B'
      oCol:bFooter := nTot
   endif

   oCol:Cargo := uCargo

   if ::lCreated
      oCol:Adjust()
   endif

return oCol

//----------------------------------------------------------------------------//

METHOD SwapCols( xCol1, xCol2, lRefresh ) CLASS TXBrowse

   local oCol
   local nAt1, nAt2, nPos

   DEFAULT lRefresh := .t.

   if Valtype( xCol1 ) == 'O'
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

   if Valtype( xFrom ) == 'O'
      nFrom := Ascan( ::aCols, {|v| v:nCreationOrder == xFrom:nCreationOrder } )
   else
      nFrom := xFrom
   endif
   if ValType( xTo ) == 'O'
      nTo   := Ascan( ::aCols, {|v| v:nCreationOrder == xTo:nCreationOrder   } )
   else
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

METHOD ReArrangeCols( aSeq, lRetainRest ) CLASS TXBrowse

   local aNew     := {}
   local nCol, oCol, n

   DEFAULT lRetainRest    := .t.

   for n := 1 to Len( aSeq )
      if ValType( aSeq[ n ] ) == 'C'
         nCol  := AScan( ::aCols, { |o| Upper( o:cHeader ) == Upper( aSeq[ n ] ) } )
      elseif ValType( aSeq[ n ] ) == n
         nCol  := AScan( ::aCols, { |o| o:CreationOrder == aSeq[ n ] } )
      else
         nCol  := 0
      endif
      if nCol > 0
         AAdd( aNew, ::aCols[ nCol ] )
         ADel( ::aCols, nCol )
         ASize( ::aCols, Len( ::aCols ) - 1 )
      endif
   next n
   if lRetainRest
      AEval( ::aCols, { |o| AAdd( aNew, o ) } )
   endif
   AEval( aNew, { |o,i| o:CreationOrder := i } )
   if ::lCreated
      ::GetDisplayCols()
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
            if oCol:nEditType < EDIT_DATE .and. !oCol:lAutoSave
               oCol:oEditGet:VarPut( oCol:Value )
            elseif oCol:lAutoSave
               if oCol:oEditGet:lValid() .and. oCol:oEditGet:nLastKey != VK_ESCAPE
                  if oCol:oEditGet:ClassName == "TGET"
                     oCol:oEditGet:Assign()
                  elseif oCol:oEditGet:ClassName == "TTIMEPICK"
                     oCol:oEditGet:cText( oCol:oEditGet:cText )
                  endif
               else
                  oCol:oEditGet:VarPut( oCol:Value )
               endif
            endif
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
         ::Super:Refresh( .t. ) // ::Paint()
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
      uCurRow := ::KeyNo()
      Eval( ::bBookMark,  Atail( ::aSelected ) )
      uOldRow := ::KeyNo()
      if uOldRow != uCurRow
         ::aSelected := { Atail( ::aSelected ) }
         if uCurRow > uOldRow
            CursorWait()
            do while ( uTemp := Eval( ::bBookMark ) ) != uBook .and. ! ::Eof()
               If Ascan( ::aSelected, uTemp ) == 0
                  Aadd( ::aSelected, uTemp )
               Endif
               ::Skip( 1 )          // Eval( ::bSkip, 1 )
            enddo
            CursorArrow()
         else
            CursorWait()
            do while ( uTemp := Eval( ::bBookMark ) ) != uBook .and. ! ::Bof()
               If Ascan( ::aSelected, uTemp ) == 0
                  Aadd( ::aSelected, uTemp )
               endif
               ::Skip( -1 )         // Eval( ::bSkip, -1 )
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
         ::Skip( 1 )             //Eval( ::bSkip, 1 )
      enddo
      Eval( ::bBookMark, uBook )
      CursorArrow()
      // ::lRefreshOnlyData := .t.
      ::GetDC()
      ::Paint()
      ::ReleaseDC()

   case nOperation == 5 // Swap key (Shift + GoDown or GoUp)

      // uCurRow := ::KeyNo()
      uBook   := Eval( ::bBookMark )
      nAt     := Ascan( ::aSelected, uBook )
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

   if ::nRowSel > ::KeyNo()
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
   ::Skip( 1 - ::nRowSel )         // Eval( ::bSkip, 1 - ::nRowSel )

   for nFor := 1 to nRows
      if Eval( ::bBookMark ) == uSeek
         lRefresh := .f.
         exit
      endif
      if ::Skip( 1 ) == 0           //Eval( ::bSkip, 1 ) == 0
         exit
      endif
   next

   if lRefresh
      Eval( ::bBookMark, uSeek )
      ::Change( .t. )
      ::Super:Refresh( .F. )
   else
      Eval( ::bBookMark, uBook )
      ::DrawLine( .f. )
      ::nRowSel := nFor
      Eval( ::bBookMark, uSeek )

      ::Change( .t. )
      ::DrawLine( .t. )
   endif

   if ::oVScroll != nil
      ::VSetPos( ::KeyNo() )
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
         MenuAddItem( oCol:cHeader, , !oCol:lHide, ;
            ( Len(::aDisplay) != 1 .or. ocol:nPos != 1 ), ;
            GenMenuBlock( ::aCols, nFor ) )
      next
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow, nCol OF Self

return nil

//----------------------------------------------------------------------------//

METHOD GoNextCtrl(hWnd)  CLASS TXBrowse

   local oCol
   local aCols
   local nCol, nNextPos, n
   local lDir := .f.
   local nI
   local nOldMove

   If hWnd != Nil
      If ::nLastKey == 9
         PostMessage(hWnd, WM_KEYDOWN, VK_RETURN)
      Endif
      return nil
   Endif

   if ::nColSel == ::nLastEditCol
      ::nLastEditCol := 0

      if ::nLastKey == VK_DOWN
         ::Select( 0 )
         ::GoDown()
         ::Select( 1 )
      elseif ::nLastKey == VK_UP
         ::Select( 0 )
         ::GoUp()
         ::Select( 1 )
      else
         if ::lFastEdit

               DO CASE
               CASE ::nMoveType == MOVE_FAST_RIGHT
                  // This is the standard default post cursor movement behavior in Fast Edit Mode
                  nNextPos    := 0
                  if ::nColSel < Len( ::aDisplay )
                     nNextPos := AScan( ::aDisplay, { |i| ::aCols[ i ]:nEditType > 0 }, ::nColSel + 1 )
                  endif
                  if nNextPos > 0
                     if ::IsDisplayPosVisible( nNextPos, .t. )
                        ::nColSel   := nNextPos
                        if ::FullPaint()
                           ::Super:Refresh( .t. ) //::Paint()
                        else
                           ::DrawLine( .t. )
                        endif
                     else
                        for n := ::nColSel + 1 to nNextPos
                           ::GoRight()
                        next n
                     endif
                  elseif ::KeyNo() < ::nLen .or. ::lAutoAppend

                     ::GoLeftMost()
                     ::Select( 0 )
                     ::GoDown()
                     ::Select( 1 )

                     if ! ::SelectedCol():lEditable
                        nNextPos := AScan( ::aDisplay, { |i| ::aCols[ i ]:lEditable  }, ::nColSel + 1 )

                        if nNextPos > ::nColSel
                           if ::IsDisplayPosVisible( nNextPos, .t. )
                              ::nColSel   := nNextPos
                              ::DrawLine( .t. )
                           else
                              for n := ::nColSel to nNextPos - 1
                                 ::GoRight()
                              next
                           endif
                        endif
                     endif
                  endif

               // Next cases are non-standard user defined post edit cursor movements
               CASE ::nMoveType == MOVE_RIGHT
                  nNextPos    := ::nColSel + 1
                  if !::IsDisplayPosVisible( nNextPos, .t. )
                     ::GoLeftMost()
                     if ::nDataRows > ::nRowSel
                      ::GoDown()
                     endif
                  else
                     ::GoRight()
                  endif
               CASE ::nMoveType == MOVE_FAST_LEFT
                  nNextPos    := ::SelectedCol():nCreationOrder  - 1
                  nI := nNextPos
                  if nNextPos > 0
                     while ::aCols[ nI ]:nEditType < 1
                        if ( --nI ) == 0
                           exit
                        endif
                     enddo
                  endif

                  nNextPos := ascan(::aDisplay,{|i| i = nI } )

                  if nNextPos > 0
                     if ::IsDisplayPosVisible( nNextPos, .t. )
                        ::nColSel   := nNextPos
                        if ::FullPaint()
                           ::Super:Refresh( .t. ) //::Paint()
                        else
                           ::DrawLine( .t. )
                        endif
                     endif
                  else
                     if nI > 0
                        for n := ::aDisplay[ ::nColSel ] - 1 to nI step -1
                           ::GoLeft()
                        next n
                     else
                        ::GoRightMost()
                        nI := len( ::aCols )
                        while ::aCols[ nI ]:nEditType < 1
                           if ( --nI ) == 0
                              exit
                           endif
                        enddo

                        nNextPos := ascan( ::aDisplay, { | i | i == nI } )
                        if nNextPos > 0
                           if ::IsDisplayPosVisible( nNextPos, .t. )
                              ::nColSel   := nNextPos
                              ::DrawLine( .t. )
                           else
                              for n := ::aDisplay[ ::nColSel ] - 1 to nI step -1
                                 ::GoLeft()
                              next n
                           endif
                           if ::nDataRows > 1
                              ::GoUp()
                           endif
                        endif
                      endif
                  endif

               CASE ::nMoveType == MOVE_LEFT
                  nNextPos  := ::aDisplay[ ::nColSel ] - 1
                  if nNextPos > 0
                     ::GoLeft()
                  else
                     ::GoRightMost()
                     if ::nRowSel > 1
                      ::GoUp()
                     endif
                  endif

               CASE ::nMoveType == MOVE_DOWN

                  if ::KeyNo() < ::nLen .or. ::lAutoAppend
                     ::Select( 0 )
                     ::GoDown()
                     ::Select( 1 )
                  endif

               CASE ::nMoveType == MOVE_UP
                  ::GoUp()
                  ::refresh()

            ENDCASE
         else
         nOldMove := ::nMoveType
         if ::nMoveType == MOVE_FAST_LEFT .or. ::nMoveType == MOVE_FAST_RIGHT
            ::nMoveType := MOVE_NONE
         endif

         DO CASE
            CASE ::nMoveType == MOVE_RIGHT
               ::GoRight()
               ::refresh()

            CASE ::nMoveType == MOVE_LEFT
                ::GoLeft()
                ::refresh()

            CASE ::nMoveType == MOVE_DOWN
                ::GoDown()
                ::refresh()

            CASE ::nMoveType == MOVE_UP
               ::GoUp()
               ::refresh()
            ENDCASE
            ::nMoveType := nOldMove
         endif
      endif
   endif

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

         if ValType( ::aCols[ n ]:oDataFont ) == 'O'
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

METHOD ClpRow( lFullRow, aCols ) CLASS TXBrowse

   local n, RetVal := ""

   DEFAULT lFullRow  := ( ::nMarqueeStyle >= 4 ) .or. aCols != nil
   DEFAULT aCols     := ::GetVisibleCols()

   if lFullRow
      for n := 1 to Len( aCols )
         RetVal += StrTran( StrTran( aCols[ n ]:ClpText, CRLF, " ; " ), Chr(9), ' ' ) + Chr( 9 )
      next
   else
      RetVal := StrTran( StrTran( ::SelectedCol():ClpText, CRLF, " ; " ), Chr(9), ' ' )
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

METHOD Paste( cText ) CLASS TXBrowse

   local aText, nRows, nCols, n, j, uBm

   if ::bPaste != nil
      Eval( ::bPaste, Self, cText )
      return nil
   endif

   if ! Empty( cText )
      if ( CRLF $ cText .or. Chr(9) $ cText )
         aText    := ClipTextAsArray( cText )
         if Len( aText ) == 1 .and. Len( aText[ 1 ] ) == 1
            ::SelectedCol():Paste( aText[ 1 ][ 1 ] )
            return nil
         endif
         if ::nDataType == DATATYPE_ARRAY
            If Empty( ::aArrayData )
               nCols := Len( aText[ 1 ] )
               for n := 1 to Len( aText )
                  for j := 1 to nCols
                     aText[ n ][ j ]   := uCharToVal( aText[ n ][ j ] )
                  next j
                  AAdd( ::aArrayData, aText[ n ] )
               next

               ::aCols  := {}
               for j := 1 to nCols
                  with object ::AddCol()
                     :nArrayCol  := j
                     :cHeader    := Chr( 64 + j )
                     :nWidth     := 80
                     :Adjust()
                  end
               next j
               ::Refresh( .t. )
            else
               nCols    := Min( Len( aText[ 1 ] ), Len( ::aDisplay ) - ::nColSel + 1 )
               if ::nColSel == 1 .and. ::lAutoAppend
                  nRows := Len( aText )
                  if ::nLen < nRows + ::nArrayAt - 1
                     ArrayResize( ::aArrayData, nRows + ::nArrayAt - 1 )
                     ::KeyCount()
                  endif
               else
                  nRows := Min( Len( aText ), ::nLen - ::nArrayAt + 1 )
               endif
               uBm      := ::nArrayAt
               for n := 1 to nRows
                  for j := 1 to nCols
                     ::aCols[ ::aDisplay[ j + ::nColSel - 1 ] ]:Paste( aText[ n, j ] )
                  next j
                  ::nArrayAt++
               next n
               ::nArrayAt  := uBm
               ::Refresh()
            endif
         else
            uBm      := Eval( ::bBookMark )
            nCols    := Min( Len( aText[ 1 ] ), Len( ::aDisplay ) - ::nColSel + 1 )
            nRows    := Len( aText )
            n        := 1
            do while n <= nRows
               for j := 1 to nCols
                  ::aCols[ ::aDisplay[ j + ::nColSel - 1 ] ]:Paste( aText[ n, j ] )
               next j
               if ::Skip( 1 ) < 1
                  exit
               endif
               n++
            enddo
            Eval( ::bBookMark, uBm )
            if nRows == 1
               ::RefreshCurrent()
            else
               ::Refresh()
            endif
         endif
      else
         ::SelectedCol():Paste( cText )
         ::RefreshCurrent()
         return nil
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Eval( bBlock, bFor, bWhile, nNext, nRec, lRest ) CLASS TXBrowse

   local lFromTop    := bWhile == nil .and. nNext == nil .and. nRec == nil .and. Empty( lRest )
   local nSaveSelect := nil
   local uBookMark
   local nRow        := 0

   DEFAULT bBlock := { || nil }, bFor := { || .t. }, bWhile := { || .t. }, ;
                     nRec := 0, lRest := .t.

   if ::nDataType == DATATYPE_RDD .and. ! Empty( ::cAlias )
      nSaveSelect := SELECT()
      SELECT( ::cAlias )
   endif

   uBookMark      := Eval( ::bBookMark )
   if lFromTop
      ::GoTop()
   endif
   if nRec > 0
      ::KeyNo( nRec )
      Eval( bBlock, Self )
   else
      do while nRow++ <= ::nLen .and. Eval( bWhile, Self )
         if Eval( bFor, Self )
            Eval( bBlock, Self )
         endif
         if ::GoDown() < 1
            exit
         endif
      enddo
   endif
   Eval( ::bBookMark, uBookMark )
   if ! Empty( nSaveSelect )
      Select( nSaveSelect )
   endif
   ::Refresh()

return Self

//----------------------------------------------------------------------------//

METHOD MakeTotals() CLASS TXBrowse

   local uBm, n, nCols
   local aCols := {}

   AEval( ::aCols, { |oCol| If( ValType( oCol:nTotal ) == 'N', ;
                        ( oCol:nTotal := 0, AAdd( aCols, oCol ) ), ;
                        nil ) } )
   if ! Empty( aCols )

      nCols    := Len( aCols )
      uBm      := Eval( ::bBookMark )
      Eval( ::bGoTop )
      do
         for n := 1 to nCols
            aCols[ n ]:nTotal += aCols[ n ]:Value
         next n
      until ( ::Skip( 1 ) < 1 )

      Eval( ::bBookMark, uBm )

   endif

return Self

//----------------------------------------------------------------------------//

METHOD Report( cTitle, lPreview, lModal, bSetUp, aGroupBy ) CLASS TXBrowse

   local oRep, oPrn, oFont, oBold, uRet
   local aCols, nFor, oCol, uBookMark
   local oBrw := Self
   local lAddCols := .T.
   local nRows, nSel, n
   local lEof     := .f.
   local lSetUpTwice := .f.
   local nLevels


   DEFAULT cTitle   := If( ::oWnd:ClassName == 'TPANEL', ::oWnd:oWnd:cTitle, ::oWnd:cTitle )
   DEFAULT lPreview := .T.
   DEFAULT lModal   := .T.

   if ::nLen < 1 .or. Empty( ::GetVisibleCols )
      return nil
   endif


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

   if ::oTree != nil
      nLevels     := ::oTree:Levels()
      oRep:Cargo  := Array( nLevels - 1 )
      ::oTree:OpenAll()

   endif

   if ! Empty( bSetUp )
      uRet := Eval( bSetUp, oRep, Self, 1 )
      if ValType( uRet ) == 'L' .and. uRet
         lAddCols := .F.
      elseif ValType( uRet ) == 'N' .and. uRet == 2
         lSetUpTwice := .t.
      endif
   endif

   if lAddCols

      aCols  := ::GetVisibleCols()

      if ValType( aGroupBy ) == 'A'
         for nFor := 1 to Len( aGroupBy )
            if ValType( aGroupBy[ nFor ] ) == 'N'
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
      if ::oTree == nil
         for n := 1 to Len( aGroupBy )
            MakeRepGroup( aGroupBy[ n ] )
         next
      else
         for n := 1 to nLevels - 1
            MakeRepTreeGroup( oBrw, oRep, n )
         next
      endif
   endif

   ENDREPORT


   if lSetUpTwice
      Eval( bSetUp, oRep, Self, 2 )
   endif

   uBookMark := Eval( ::bBookMark )

   if Len( ::aSelected ) > 1
       Eval( ::bBookMark, ::aSelected[ 1 ] )
       nRows        := Len( ::aSelected )
       nSel         := 1
       oRep:bSkip   := { || nSel++, Eval( oBrw:bBookMark, oBrw:aSelected[ min( nSel, nRows ) ] ) }
   else
      Eval( ::bGoTop )
      nRows           := Eval( ::bKeyCount )
      oRep:bSkip   := { |n| lEof := ( Eval( oBrw:bSkip, n ) != n ) }

   endif
   oRep:bWhile      := { || oRep:nCounter < nRows .and. ! lEof }
   oRep:bEnd        := ::bGoTop

   if ::oTree != nil

      oRep:bFor      := { || If( ::oTreeItem:nLevel < nLevels, ;
                           oRep:Cargo[ ::oTreeItem:nLevel ] := ::oTreeItem:cPrompt, ), ;
                           ::oTreeItem:nLevel == nLevels }
   endif

   oRep:Activate()

   if ::oTree != nil
      ::oTree:Collapse()
   endif

   Eval( ::bGoTop )
   Eval( ::bBookMark, UBookMark )

   ::Refresh()
   ::SetFocus()

   RELEASE FONT oFont
   RELEASE FONT oBold

return Self

//----------------------------------------------------------------------------//

METHOD ToExcel( bProgress, nGroupBy, aCols ) CLASS TXBrowse

   local oExcel, oBook, oSheet, oWin
   local nCol, nXCol, oCol, cType, uValue, nAt, cxlAggr
   local uBookMark, nRow
   local nDataRows
   local oClip, cText, nPasteRow, nStep, cFormat
   local aTotals  := {}, lAnyTotals := .f.
   local aWidths  := {}
   local lContinue   := .t.

   if lExcelInstl == .f.
      // already checked and found excel not installed
      if lCalcInstl == .f.
         // already checked and found Open Office Calc also is not installed
         return Self
      else
         return ::ToCalc( bProgress, nGroupBy,,, aCols )
      endif
   endif

   nDataRows   := EVAL( ::bKeyCount )
   if nDataRows == 0
      return Self
   endif

   DEFAULT aCols         := ::GetVisibleCols()

   if Empty( aCols )
      return Self
   endif

   if ( oExcel := ExcelObj() ) == nil
      lExcelInstl := .f.
      if lCalcInstl == .f.
         msgStop( "Excel not installed" )
         return Self
      else
         return ::ToCalc( bProgress, nGroupBy, , , aCols )
      endif
   endif
   lExcelInstl    := .t.

   if nxlLangID == nil
      SetExcelLanguage( oExcel )
   endif

   oExcel:ScreenUpdating := .f.
   oBook   := oExcel:WorkBooks:Add()
   oSheet   := oExcel:ActiveSheet

   uBookMark   := EVAL( ::bBookMark )

   nRow     := 1
   nCol     := 0
   aWidths  := Array( Len( aCols ) )

   for nXCol := 1 TO Len( aCols )
      oCol   := aCols[ nXCol ]

      nCol ++

      oSheet:Cells( nRow, nCol ):Value   := oCol:cHeader
      cType      := oCol:cDataType

      if ::nDataType != DATATYPE_ARRAY
         DO CASE
         CASE cType == 'N'
            cFormat     := Clp2xlNumPic( oCol:cEditPicture )
            oSheet:Columns( nCol ):NumberFormat := cFormat
            oSheet:Columns( nCol ):HorizontalAlignment := - 4152 //xlRight

         CASE cType == 'D'
            if lxlEnglish
              if ValType( oCol:cEditPicture ) == 'C' .and. Left( oCol:cEditPicture, 1 ) != '@'
                 oSheet:Columns( nCol ):NumberFormat := Lower( oCol:cEditPicture )
              else
                 oSheet:Columns( nCol ):NumberFormat := Lower( Set( _SET_DATEFORMAT ) )
              endif
              oSheet:Columns( nCol ):HorizontalAlignment := - 4152 //xlRight
            endif
         CASE cType $ 'LPFM'
            // leave as general format
         OTHERWISE
            if ::nDataType != DATATYPE_ARRAY
               oSheet:Columns( nCol ):NumberFormat := "@"
               if ! Empty( oCol:nDataStrAlign )
                  oSheet:Columns( nCol ):HorizontalAlignment := If( oCol:nDataStrAlign == AL_CENTER, -4108, -4152 )
               endif
            endif
         ENDCASE
      endif

      if cType != nil .and. cType $ 'PFM' // Picture or memo
         aWidths[ nCol ]                     := oCol:nWidth / 7.5
         oSheet:Columns( nCol ):ColumnWidth  := aWidths[ nCol ]
         oSheet:Rows( "2:" + LTrim(Str( ::nLen + 1 )) ):RowHeight := ::nRowHeight
         if cType == 'M'
            oSheet:Columns( nCol ):WrapText  := .t.
         endif
      endif

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
         nStep     := Max( 1, Min( 100, Int( nDataRows / 100 ) ) )

         if ::lExcelCellWise

            do while nRow <= ( nDataRows + 1 ) .and. lContinue

               nCol        := 0
               for nxCol   := 1 to Len( aCols )
                  oCol     := aCols[ nXCol ]
                  nCol++
                  oCol:ToExcel( oSheet, nRow, nCol )
               next nCol

               lContinue := ( ::Skip( 1 ) == 1 )
               nRow ++
               If ( nRow - 2 ) % nStep == 0
                  if Eval( bProgress, nRow - 2, nDataRows ) == .f.
                     Exit
                  endif
                  SysRefresh()
               endif

            enddo

         else

            nPasteRow := 2
            cText     := ""
            oClip := TClipBoard():New()
            if oClip:Open()

               Eval( bProgress, 0, nDataRows )

               do while nRow <= ( nDataRows + 1 ) .and. lContinue
                  if ! Empty( cText )
                     cText += CRLF
                  endif
                  cText    += ::ClpRow( .t. )

                  lContinue := ( ::Skip( 1 ) == 1 )            // Eval( ::bSkip, 1 )
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
         endif // ::lExcelCellWise
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

   if ValType( nGroupBy ) == 'N'
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
                                    .t. )       // SummaryBelowData

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
               cxlAggr     := cxlSum
               if lxlEnglish .and. ! Empty( oCol:nFooterType ) .and. oCol:nFooterType > AGGR_SUM
                  cxlAggr  := { 'SUM(', 'MAX(', 'MIN(', 'COUNT(', 'AVERAGE(', 'STDEV(', 'STDEVP(' } ;
                              [ AScan( { AGGR_SUM, AGGR_MAX, AGGR_MIN, AGGR_COUNT, AGGR_AVG, AGGR_STDEV, AGGR_STDEVP }, ;
                                oCol:nFooterType ) ]
               endif
//               oSheet:Cells( nRow, nCol ):FormulaR1C1 := "=" + cxlAggr + excelRange( 2, nCol, nRow - 1 ) + ')' // FWH 9.11 + ')' added
               oSheet:Cells( nRow, nCol ):Formula := "=" + cxlAggr + ;
                  oSheet:Range( oSheet:Cells( 2, nCol ), ;
                                oSheet:Cells( nRow - 1, nCol ) ):Address( .f., .f. ) + ")"

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
      if aWidths[ nCol ] == nil
         oSheet:Columns( nCol ):AutoFit()
      endif
      oSheet:Columns( nCol ):VerticalAlignment := -4108  // xlCenter
   next

   oSheet:Cells(1,1):Select()
   oWin   := oExcel:ActiveWindow
   oWin:SplitRow := 1
   oWin:FreezePanes := .t.

//   oWin:DisplayZeros := .f.

   Eval( ::bBookMark, uBookMark )
   ::Refresh()
   ::SetFocus()

   oExcel:ScreenUpdating   := .t.
   oExcel:visible          := .T.
   ShowWindow( oExcel:hWnd, 3 )
   BringWindowToTop( oExcel:hWnd )

return oSheet

//----------------------------------------------------------------------------//
METHOD ToCalc( bProgress, nGroupBy, nPasteMode, aSaveAs, aCols ) CLASS TXBrowse

   local oCalc, oDeskTop,oBook, oSheet, oWin, oLocal, oDispatcher
   local nCol, nXCol, oCol, cType, uValue, nAt
   local uBookMark, nRow
   local nDataRows
   local oClip, cText, nPasteRow, nStep, cFormat,cFileName,cURL,i
   local aTotals  := {}, lAnyTotals := .f. , aProp:={} , aOOFilters:={} , nPos, oCharLocale
   local lContinue := .t.

   if lCalcInstl == .f.
      // already checked and Calc not installed
      if lExcelInstl == .f.
         // already checked and excel also is not installed
      else
         return ::ToExcel( bProgress, nGroupBy, aCols )
      endif
   endif

   DEFAULT nPasteMode:=1
   DEFAULT aSaveAs:={}
   nxlLangID:=0  // This is a static variable used in ToExcel() and SetExcelLanguage()

   aOOFilters:={ {"PDF","calc_pdf_Export"},{"XLS","MS Excel 97"},{"HTML","XHTML Calc File"} }

   nDataRows   := EVAL( ::bKeyCount )
   if nDataRows == 0
     nxlLangID:=nil
     return nil
   endif

   DEFAULT aCols         := ::GetVisibleCols()

   if Empty( aCols )
     nxlLangID:=nil
     return nil
   endif

   if ( oCalc := SunCalcObj() ) == nil
      lCalcInstl  := .f.
      if lExcelInstl == .f.
         msgStop( "No spreadsheet software installed" )
         return Self
      else
         return ::ToExcel( bProgress, nGroupBy, aCols )
      endif
   endif
   lCalcInstl := .t.

   lxlEnglish:=.T.

   oDesktop := oCalc:CreateInstance( "com.sun.star.frame.Desktop" )

   // Create OpenOffice Calc Instance with the Window Hidden Property
   aProp:={}
   AAdd(aProp,GetPropertyValue(oCalc, "Hidden", .T. )  )
   oBook    := oDesktop:LoadComponentFromURL( "private:factory/scalc", "_blank", 0, aProp )
   oSheet   := oBook:GetSheets():GetByIndex( 0 )
   oDispatcher:= oCalc:CreateInstance( "com.sun.star.frame.DispatchHelper" )

   // Object to handle OpenOffice Language
   oCharLocale = oBook:GetPropertyValue("CharLocale")
   IF oCharLocale:Language == "de"  // German
      cxlSum:="=SUMME("
   ELSEIF oCharLocale:Language == "fr"  // French
      cxlSum:="=SOMME("
   ELSEIF oCharLocale:Language == "es"  // Spanish
      cxlSum:="=SUMA("
   ELSEIF oCharLocale:Language == "pt"  // Portugese
      cxlSum:="=SOMA("
   ELSEIF oCharLocale:Language == "it"  // Italian
      cxlSum:="=SOMMA("
   ELSE
      cxlSum:="=SUM("
   ENDIF

   // This routine blocks screen updating and therefore allows faster macro execution
   oBook:addActionLock()
   oBook:LockControllers()

   uBookMark   := EVAL( ::bBookMark )

   nRow   := 1
   nCol   := 0
   for nXCol := 1 TO Len( aCols )
      oCol   := aCols[ nXCol ]

      nCol ++

      oSheet:GetCellByPosition( nCol-1, nRow-1 ):SetString = oCol:cHeader
      cType      := oCol:cDataType

      DO CASE
         CASE cType == 'N'

            cFormat     := If( lThouSep, If( lxlEnglish, "#,##0", "#.##0" ), "0" )
            if oCol:cEditPicture != nil
               if "." $ oCol:cEditPicture
                  cFormat  += If( lXlEnglish, '.', ',' ) + StrTran( ;
                              StrTran( SubStr( oCol:cEditPicture, ;
                              At( '.', oCol:cEditPicture ) + 1 ), '9', '0' ), '#', '0' )
               endif
               if ( nAt := At( ' ', cFormat ) ) > 0
                  cFormat  := Left( cformat, nAt ) + '"' + SubStr( cFormat, nAt + 1 ) + '"'
               endif
            endif
            oSheet:GetColumns():GetByIndex( nCol-1 ):NumberFormat:=GetNumberFormatId(oBook, cFormat, cType)
            oSheet:GetColumns():GetByIndex( nCol-1 ):HoriJustify = 3  // 3 Right Alignement

         CASE cType == 'D'
            if lxlEnglish
              if ValType( oCol:cEditPicture ) == 'C' .and. Left( oCol:cEditPicture, 1 ) != '@'
                 oSheet:GetColumns():GetByIndex( nCol-1 ):NumberFormat:=GetNumberFormatId(oBook,  oCol:cEditPicture, oCol:cHeader, cType )
              else
                 oSheet:GetColumns():GetByIndex( nCol-1 ):NumberFormat:=GetNumberFormatId(oBook,   Set( _SET_DATEFORMAT ), oCol:cHeader, cType  )
              endif
              oSheet:GetColumns():GetByIndex( nCol-1 ):HoriJustify = 3   // 3 Right Alignment
            endif
         CASE cType == 'L'
            // leave as general format
         OTHERWISE
             oSheet:GetColumns():GetByIndex( nCol-1 ):NumberFormat:= "@"
      ENDCASE

   Next nXCol

   oBook:CurrentController:select( oSheet:GetCellRangeByPosition( 0, 0, Len( aCols )-1,0 ) )
   oSheet:getCellByPosition(0,0):Rows:Height=750   //1000 = 1cm

   // Draw Bottom Border Line on the Header Row
   aProp:={}
   AAdd(aProp,GetPropertyValue(oCalc, "OuterBorder.BottomBorder", {0,0,2,0}  )        )
   oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:SetBorderStyle", "", 0, aProp)

   // Make Header Row Font Bold
   aProp:={}
   AAdd(aProp,GetPropertyValue(oCalc, "Bold", .T.  )        )
   oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Bold", "", 0, aProp)

   // Make Setting for Paste Tab Delimited Text
   aProp:={}
   AAdd(aProp,GetPropertyValue(oCalc,  "FilterName", "Text" ) )
   AAdd(aProp,GetPropertyValue(oCalc, "FilterOptions", "9,,MS_1257,0,2/2/2/2/2/2/2/2/2/2/2/2/2/2/2/2"   )        )

    if Empty( ::aSelected ) .or. Len( ::aSelected ) == 1

      Eval( ::bGoTop )

      if bProgress == nil
         if ::oWnd:oMsgBar == nil
            bProgress := { || nil }
         else
            bProgress := { | n, t | ::oWnd:SetMsg( "To Calc  : " + Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
         endif
      endif

      nRow      := 2
      nPasteRow := 2
      nStep     := Max( 1, Min( 100, Int( nDataRows / 100 ) ) )
      cText     := ""
      oClip := TClipBoard():New()
      if oClip:Open()

         Eval( bProgress, 0, nDataRows )
         do while nRow <= ( nDataRows + 1 ) .and. lContinue
            if ! Empty( cText )
               cText += CRLF
            endif
            cText    += ::ClpRow( .t. )

            lContinue := ( ::Skip( 1 ) == 1 )             // Eval( ::bSkip, 1 )
            nRow ++

            if Len( cText ) > 16000
               oClip:SetText( cText )
               oBook:CurrentController:select( oSheet:GetCellByPosition( 0,nPasteRow-1 ) )
               IF nPasteMode == 2
                  oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Paste", "", 0, aProp)
               else
                  PasteUnformattedText(oCalc,oBook,oSheet,aCols)
               Endif
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
            oBook:CurrentController:select( oSheet:GetCellByPosition( 0,nPasteRow-1 ) )
            IF nPasteMode == 2
               oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Paste", "", 0, aProp)
            else
               PasteUnformattedText(oCalc,oBook,oSheet,aCols)
            Endif
            oClip:Clear()
            cText    := ""
         endif
         oClip:Close()

         Eval( bProgress, nDataRows, nDataRows )
         SysRefresh()

      endif
      oClip:End()

   else
      ::Copy()
      oBook:CurrentController:select( oSheet:GetCellByPosition( 2,1 ) )
      IF nPasteMode == 2
         oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Paste", "", 0, aProp)
      else
         PasteUnformattedText(oCalc,oBook,oSheet,aCols)
      Endif
      nRow := Len( ::aSelected ) + 2
   ENDIF

   nCol   := 0 ; nRow:=nRow-2
   oBook:CurrentController:select( oSheet:GetCellRangeByPosition( 0, nRow, Len( aCols )-1,nRow ) )

   // Draw Bottom Border Line on the Bottom Row
   aProp:={}
   AAdd(aProp,GetPropertyValue(oCalc, "OuterBorder.BottomBorder", {1,1,2,1}  )        )
   oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:SetBorderStyle", "", 0, aProp)

   if ValType( nGroupBy ) == 'N'
      for nxCol := 1 TO Len( aCols )
         if aCols[ nxCol ]:lTotal
            AAdd( aTotals, nxCol )
         endif
      next
      if ! Empty( aTotals )
         CalcSubTotal(oCalc,oBook,oSheet,nGroupBy,aTotals,nRow,Len(aCols)-1)
      Endif
   else

       // If lTotal is .T. for any column then create the formula to Show the Column Total
      for nXCol := 1 TO Len ( aCols )
         oCol   := aCols[ nXCol ]
         nCol ++
         if oCol:lTotal
            oBook:CurrentController:select( oSheet:GetCellByPosition( nCol-1,nRow+1 ) )
            aProp:={}
            *AAdd(aProp,GetPropertyValue(oCalc, "StringName","=SUM("+ oSheet:getColumns():getByIndex(nCol)+"2:"+oSheet:getColumns():getByIndex(nCol)+LTrim(Str(nRow+1))+")"  )    )
            AAdd(aProp,GetPropertyValue(oCalc, "StringName",cxlSum+ MakeColAlphabet(nCol)+"2:"+MakeColAlphabet(nCol)+LTrim(Str(nRow+1))+")"  )  )
            oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:EnterString", "", 0, aProp)
            lAnyTotals := .t.
         endif
      next nXCol
      if lAnyTotals
         oBook:CurrentController:select( oSheet:GetCellRangeByPosition( 0, nRow+1, Len( aCols )-1,nRow+1 ) )
         // Draw Bottom Border Line on the Total Line Row
         aProp:={}
         AAdd(aProp,GetPropertyValue(oCalc, "OuterBorder.BottomBorder", {1,1,2,1}  )        )
         oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:SetBorderStyle", "", 0, aProp)

         // Make the Total Line Bold
         aProp:={}
         AAdd(aProp,GetPropertyValue(oCalc, "Bold", .T.  )        )
         oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Bold", "", 0, aProp)
      ENDIF
   Endif

   oBook:CurrentController:select( oSheet:GetCellByPosition( 1,1 ) )

   for nCol := 1 to Len( aCols )
     oSheet:GetColumns():GetByIndex( nCol-1 ):OptimalWidth = .T.
   next

   oBook:CurrentController:select( oSheet:GetCellByPosition( 0,1 ) )
   oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:FreezePanes", "", 0, {})

   Eval( ::bBookMark, uBookMark )
   ::Refresh()
   ::SetFocus()

   // This routine allows screen updating
   oBook:UnlockControllers()
   oBook:removeActionLock()

   // If you want to convert this to other formats like PDF format or MS Excel
   IF Len(aSaveAs) > 0
      FOR I:=1 TO Len(aSaveAs)
         cFormat:=Upper(aSaveAs[i][1])
         cFileName:=aSaveAs[i][2]
         * Ensure leading slash.
         IF LEFT( cFilename, 1 ) != "/"
            cFileName:= "/" + cFileName
         ENDIF

         cURL:= StrTran( cFilename, "\", "/" )   // change backslashes to forward slashes.
         cURL = "file://" + cURL

         aProp:={} ; nPos:=0
         nPos:=AScan(aOOFilters,{ |x| x[1] == cFormat})
         IF nPos > 0
            AAdd(aProp,GetPropertyValue(oCalc, "FilterName", aOOFilters[nPos][2])  )
            cURL:=cURL+"."+cFormat
            oBook:StoreToURL( cURL, aProp )
         Endif

      Next
   ENDIF
   oBook:GetCurrentController():GetFrame():GetContainerWindow():SetVisible(.T.)
   oBook:CurrentController:select( oSheet:GetCellByPosition( 0,0 ) )
*   oBook:Close(1)  // To Close OpenOffice Calc
   nxlLangID:=nil

Return Self

//----------------------------------------------------------------------------//


//----------------------------------------------------------------------------//
STATIC Function MakeColAlphabet(nCol)
  LOCAL aColumns:={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R",;
                      "S","T","U","V","W","X","Y","Z"}
  LOCAL cColAphabet,nInt

  IF nCol <= 26
     cColAphabet:=aColumns[nCol]
  ELSEif nCol <= 676
     nInt:=Int(nCol/26)
     cColAphabet:=aColumns[nCol]
     cColAphabet+=aColumns[nCol-(nInt*26)]
  Endif
RETURN cColAphabet

//----------------------------------------------------------------------------//

STATIC FUNCTION GetPropertyValue(oService, cName, xValue )
   LOCAL oArg
   oArg := oService:Bridge_GetStruct( "com.sun.star.beans.PropertyValue" )
   oArg:Name  := cName
   oArg:Value := xValue
RETURN oArg

//----------------------------------------------------------------------------//

STATIC Function GetNumberFormatId(oBook, cNumberFormat, cColHeader, cDataType)
  LOCAL cCharLocale,nFormatId
  cCharLocale = oBook:GetPropertyValue("CharLocale")
  IF cDataType == "D"  // Date
      cNumberFormat:=Upper(cNumberFormat)
      IF cCharLocale:Language == "es" .or. cCharLocale:Language == "pt" .or. cCharLocale:Language == "it"  // Spanish,Portuguese,Italian,French
        cNumberFormat:=StrTran(cNumberFormat,"Y","A")  // All Y should be replaced to A
      ELSEIF cCharLocale:Language == "de"  // German
         cNumberFormat:=StrTran(cNumberFormat,"D","T")  // All D should be replaced to T
         cNumberFormat:=StrTran(cNumberFormat,"Y","J")  // All Y should be replaced to J
      elseif cCharLocale:Language == "fr"  // French
         cNumberFormat:=StrTran(cNumberFormat,"D","J")  // All D should be replaced to J
         cNumberFormat:=StrTran(cNumberFormat,"Y","A")  // All Y should be replaced to A
      Endif
  Endif
  nFormatId = oBook:GetNumberFormats:QueryKey(cNumberFormat, cCharLocale, .F.)
  IF nFormatId = -1 // 'Format is not yet defined
     TRY
        nFormatId = oBook:GetNumberFormats:AddNew(cNumberFormat, cCharLocale)
     CATCH
        MsgInfo("Could not set the format "+cNumberFormat+" to column "+cColHeader)
        IF cDataType == "D"  // Date
           nFormatId:=37
        Endif
     END
  ENDIF

RETURN nFormatId

//----------------------------------------------------------------------------//

STATIC FUNCTION CalcSubTotal(oCalc,oBook,oSheet,nGroupBy,aTotals,nRow,nCol)

   LOCAL oRange, oSubTotDesc,oColumns,aArg:={},nCount

   FOR nCount:=1 TO Len(aTotals)
      oColumns := oCalc:Bridge_GetStruct( "com.sun.star.sheet.SubTotalColumn" )
      //Description by columns : sum of 4th col should be 3, for 2 it should be 1
      oColumns:Column  := aTotals[nCount]-1
      oColumns:Function :=2 // com.sun.star.sheet.GeneralFunction.SUM
      AAdd(aArg,oColumns)
   Next

   oRange:= oSheet:getCellRangeByPosition( 0, 0, nCol,nRow )
   oSubTotDesc:=oRange:createSubTotalDescriptor(.T.)  // true  creates an empty descriptor. false previous settings

   //Group by: nGroupBy col-1
   oSubTotDesc:addNew(aArg, nGroupBy-1)
   oRange:applySubTotals(oSubTotDesc, .T.)   // true = replaces previous subtotal
Return NIL

//----------------------------------------------------------------------------//

STATIC Function PasteUnformattedText(oCalc,oBook,oSheet,aCols)
  LOCAL oClipContType,oClipContent,oClip,cStr,i,nClipColNo
  LOCAL lFound,nRow,nCol,k,oCol

  oClip = oCalc:CreateInstance("com.sun.star.datatransfer.clipboard.SystemClipboard")
  oClipContType = oClip:Contents:getTransferDataFlavors

  lFound = .F. ;   i:= 1

  DO while i <= Len(oClipContType) .AND. !lFound
    if oClipContType[i]:HumanPresentableName = "OEM/ANSI Text"
      lFound = .T.
      k:=i
    else
      i:=i + 1
    endif
  Enddo

  if lFound

    nRow   = oBook:CurrentSelection:getRangeAddress():startrow
    oClipContent:=oClip:Contents:getTransferData( oClipContType[k] )

    i:=1 ;  cStr:="" ; nCol:=0

    DO while i <= Len(oClipContent)
       if oClipContent[i] = 0 .OR. oClipContent[i] = 13 .OR. oClipContent[i] = 10
        i=i+2 ; nRow:=nRow + 1 ; cStr:="" ;  nCol:=0
     ELSEIF oClipContent[i] = 9  // Tab
        oCol:=aCols[nCol+1]

        IF oCol:cDataType == "C"
            oSheet:getCellByposition(nCol,nRow):SetString(cStr)
        ELSEIF oCol:cDataType == "N"
            oSheet:getCellByposition(nCol,nRow):SetValue(cStr)
        ELSEIF oCol:cDataType == "D"
           oSheet:getCellByposition(nCol,nRow):SetFormula(cStr)
        ELSE
           oSheet:getCellByposition(nCol,nRow):SetString(cStr)
        Endif
        nCol:=nCol+1 ; cStr:="" ; i:=i+1
      else
        cStr:=cStr + chr(oClipContent[i])
        i:=i+1
      endif
    Enddo

  endif
RETURN NIL

//----------------------------------------------------------------------------//

METHOD CurrentRow() CLASS TXBrowse

   local oRow
   local aHeaders := {}
   local aValues  := {}
   local n

   for n := 1 to Len( ::aCols )
      AAdd( aHeaders, ::aCols[ n ]:cHeader )
      AAdd( aValues,  ::aCols[ n ]:Value   )
   next n

   oRow  := TXBrRow():New( Self, Eval( ::bBookMark ), ::KeyNo(), aHeaders, aValues )

return oRow

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

METHOD DestroyToolTip() CLASS TXBrowse

  TWindow():DestroyToolTip()
  ::oColToolTip := nil

return nil

//----------------------------------------------------------------------------//

METHOD NcMouseMove( nHitTestCode, nRow, nCol ) CLASS TXBrowse

   TWindow():NcMouseMove( nHitTestCode, nRow, nCol )
   ::oColToolTip   := nil

return nil

//----------------------------------------------------------------------------//

METHOD OnError( uParam1 ) CLASS TXBrowse
   local cMsg   := __GetMessage()
   local nError := If( SubStr( cMsg, 1, 1 ) == "_", 1005, 1004 )
   local oCol
   local lAssign := .f.

   if Left( cMsg, 1 ) == '_'
      lAssign     := .t.
      nError      := 1005
      cMsg        := SubStr( cMsg, 2 )
   endif
   oCol           := ::oCol( cMsg )

   if oCol == nil
      if lAssign .and. ValType( uParam1 ) == 'B'
         oCol              := ::AddCol()
         oCol:cHeader      := cMsg
         oCol:bEditValue   := uParam1
         if ::lCreated
            oCol:Adjust()
         endif
         return oCol
      endif
   else
      if lAssign
         if ValType( uParam1 ) == 'B'
            oCol:bEditValue   := uParam1
            return uParam1
         else
            oCol:Value := uParam1
            return oCol:Value
         endif
      else
         return oCol
      endif
   endif

    _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )

return nil

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
                            { bData }, oxCol:nDataLen, { cPic } ,;
                            nil, oXCol:lTotal, nil ,;
                            cAlign, .F., .F., nil, ;
                            oxCol:cDataType == 'M', oxcol:cDataType == 'P', ;
                            nil, oxCol:oBrw:nRowHeight(), .t., oxCol:nAlphaLevel() )
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
static function MakeRepTreeGroup( oBrw, oRep, n )

   RptAddGroup( { || oRep:Cargo[ n ]  }, { || oRep:Cargo[ n ] }, nil, { || 2 },, .f. )

return nil

//----------------------------------------------------------------------------//

static function RepTreeFor( oBrw, oRep, nCols, nLevels )

   local nLevel   := oBrw:oTreeItem:nLevel

   nCols    := Len( oRep:aColumns )

   if nLevel < nLevels
      oRep:Cargo[ nLevel ] := oBrw:oTreeItem:cPrompt
   endif

return ( oBrw:oTreeItem:nLevel == nLevels )

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

   if ValType( aData[ 1 ] ) == 'A'
      for nFor := 1 to nLen
         if !( aCols[ nFor ]:cOrder == "" ) .and. aCols[ nFor ]:nArrayCol > 0
            lExact := Set( _SET_EXACT, .f. )
            nAt := Ascan( aData, {|v| Upper( cValToChar( v[ aCols[ nFor ]:nArrayCol ] ) ) = cSeek } )
            Set( _SET_EXACT, lExact )
            if nAt > 0
               ::nArrayAt := nAt
               return .t.
            endif
         endif
      next
   else
      lExact := Set( _SET_EXACT, .f. )
      nAt := Ascan( aData, {|v| Upper( cValToChar( v ) ) = cSeek } )
      Set( _SET_EXACT, lExact )
      if nAt > 0
         ::nArrayAt := nAt
         return .t.
      endif
   endif

return .f.

//----------------------------------------------------------------------------//

static function GenMenuBlock( aCols, nFor )

   local oCol := aCols[ nFor ]

return {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }

//----------------------------------------------------------------------------//

static function SetColFromRDD( oCol, nFld, cAlias, aFldInfo, lAutoSort )

   local cName       // if fieldname is specified in different case, header is set accordingly
   local uVal, nLen, nDec, nSelect  := SELECT( cAlias )

   if valtype( nFld ) == 'C'
      nFld  := (cAlias)->(FieldPos(cName := nFld))

   endif

   aFldInfo          := aFldInfo[ nFld ]

   oCol:cHeader      := If( cName == nil, aFldInfo[ 1 ], cName )
   if ( cName == nil )
      cName          := aFldInfo[ 1 ]
   endif

//   oCol:bEditValue   := FieldWBlock( cName, nSelect )
   oCol:bEditValue   := { |x| If( x == nil, ( oCol:oBrw:cAlias )->( FieldGet( nFld ) ), ;
                                ( oCol:oBrw:cAlias )->( FieldPut( nFld, x ) ) ) }

   uVal              := ( oCol:oBrw:cAlias )->( FieldGet( nFld ) )
   nLen              := aFldInfo[ 3 ]
   nDec              := aFldInfo[ 4 ]

   if Len( aFldInfo[ 2 ] ) == 1

      oCol:cDataType      := aFldInfo[ 2 ]

      if oCol:cDataType == "I"
         oCol:cDataType := 'N'
         if aFldInfo[ 3 ] == 2
            nLen        := 6
         else
            nLen        := 13
         endif
         nDec           := 0
      elseif oCol:cDataType == 'Y'
         oCol:cDataType := 'N'
         nLen           := 15
         nDec           := 2
      elseif oCol:cDataType == '@'
         nLen           := 20
#ifdef __XHARBOUR__
         oCol:cDataType := 'T'
#else
         oCol:cDataType := ValType( uVal )
         if oCol:cDataType == 'C'
            nLen  := Len( uVal )
         endif
#endif
      elseif oCol:cDataType == "U"
         oCol:cDataType := 'C'
      endif
   else
      // ADT table
      oCol:cDataType    := ValType( uVal )
      do case
         case oCol:cDataType == 'N'
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
#ifdef __XHARBOUR__
         case oCol:cDataType == 'D'
            if 'TIME' $ aFldInfo[ 2 ]
               oCol:cDataType    := 'T'
               oCol:cEditPicture := '@T'
            endif
#endif
         case oCol:cDataType $ "CM"
            if aFldInfo[ 2 ] = "IMAGE"
               oCol:cDataType    := 'P'
            elseif aFldInfo[ 2 ] = "RAW"
               oCol:bStrData     := { || "<Binary>" }
            endif
         otherwise
            // nothing to do
      endcase
   endif

   // in case of new unhandled data types
   if !( oCol:cDataType $ 'CDLMNPT' )
      oCol:cDataType := ValType( uVal )
   endif

   // oCol:adjust() will set bstrdata

   do case
   case oCol:cDataType == 'N'
      oCol:cEditPicture   := NumPict( nLen, nDec, .T., lThouSep )
   case oCol:cDataType  == 'D'
      oCol:cEditPicture   := '@D'

   endcase

   oCol:bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE .and. Eval( o:oBrw:bLock ), ;
          o:Value := x, ) }

   if lAutoSort
      if (cAlias)->( OrdNumber( oCol:cHeader ) ) > 0
         oCol:cSortOrder   := oCol:cHeader
      else
         oCol:cSortOrder   := ( cAlias )->( FindTag( oCol:cHeader ) )
      endif
   endif



return oCol
//----------------------------------------------------------------------------//

function findTag( cFld, nOrder )

   local nOrders  := OrdCount()
   local cTag, nAt, cKey, n, nLen, aOrders := {}

   cFld     := Upper( Trim( cFld ) )
   nLen     := Len( cFld )

   for n := 1 to nOrders
      cKey  := OrdKey( n )
      cKey  := Upper( StrTran( cKey, ' ','' ) )
      if Left( cKey, nLen ) == cFld
         nOrder   := n
         cTag     := OrdName( n )
         exit
      endif
   next
   if Empty( cTag )
      for n := 1 to nOrders
         cKey  := OrdKey( n )
         cKey  := Upper( StrTran( cKey, ' ','' ) )
         if ( nAt := At( "(", cKey ) ) > 0
            cKey  := SubStr( cKey, nAt + 1 )
            if Left( cKey, nLen ) == cFld
               nOrder   := n
               cTag     := OrdName( n )
               exit
            endif
         endif
      next
   endif

return cTag

//------------------------------------------------------------------//

function NumPict( nLen, nDec, lDBF, lThouSep )

LOCAL   Pic

   DEFAULT nDec   := 0

   nLen       += 2  // to accommdate totals

   if nDec > 0
      nLen   -= ( nDec + If( lDbf, 1, 0 ) )
   endif
   nLen      := MAX( MIN( 14, nLen ), 1 )

   Pic           := Replicate( '9', nLen )
   if lThouSep .and. nDec > 0
      if cNumFormat == "I"
         Pic          := LTrim( Transform( Val( Pic ), '99,999,99,99,99,999' ) )
      else
         Pic          := LTrim( Transform( Val( Pic ), '99,999,999,999,999' ) )
      endif
   endif
//   Pic            := '@Z ' + Pic
   if cNumFormat == "E"
     Pic             := "@E " + Pic
   endif

   if nDec > 0
      Pic      += ( '.' + Replicate( '9', nDec ) )
   endif

return Pic
//----------------------------------------------------------------------------//

static function AddOdbfCol( oBrw, cCol, aStruct )

   local oCol := oBrw:AddCol()
   local n

   oCol:cHeader         := cCol
   oCol:bEditValue      := { |x| If( x != nil, oSend( oBrw:oDbf, "_" + cCol, x ), ), OSend( oBrw:oDbf, cCol ) }
   oCol:bOnPostEdit     := { |o,x,n| If( n != VK_ESCAPE, o:Value := x, ) }

   if aStruct != nil
      if ( n := AScan( aStruct, { |a| Upper( Trim( a[ 1 ] ) ) == Upper( Trim( cCol ) ) } ) ) > 0
         oCol:cDataType    := aStruct[ n ][ 2 ]
      endif
   endif

return oCol

//----------------------------------------------------------------------------//

static function excelCell( r, c )
return "R" + LTrim( Str( r ) ) + 'C' + LTrim( Str( c ) )

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
               TRY
                   oExcel   := TOLEAuto():New( "Excel.Application" )
               CATCH
                   nxlLangID := 0
                   return nil
               END
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
        oDataFontBold,; //------------------------------------ Silvio
        oFooterFont,;   // Footer font object, by default oBrw:oFooterFont
        oDragWnd,;      // Temporal window used for swaping columns
        oBtnList,;      // Button for edit with listbox
        oBtnElip,;      // Button for edit with user code-block
        oEditGet,;      // Get object for editing
        oEditLbx,;      // Listbox object for editing
        oEditFont,;     // Edit Font
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
        bIndent,;
        bStrImage       // String data codeblock (returns a string with imagen name)

   DATA bEditValue,;    // codeblock to retrieve the value of the edit, if nil then bstrData is used
        bEditValid,;    // codeblock to validate edit gets
        bEditWhen,;     // codeblock to allow edit
        bGetChange,;    // codeblock for oEditGet change when editype is EDIT_GET
        bOnChange,;     // codeblock to evaluate if the value is edited and changed
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
        bClrGrad, ;     // gradient color spec
        bClrStd,;       // default color pair for normal rows
        bClrSel,;       // default color pair for selected row
        bClrSelFocus,;  // default color pair for selected row when control has focus
        bClrEdit        // default color pair for edition

   DATA bPaintText

   DATA bToolTip        // ToolTip for CELL

   DATA cHeader,;       // header string
        cFooter,;       // footer string
        cEditPicture,;  // Picture mask to be used for Get editing
        cOrder,;        // Used internally for autosorting (""->None, "A"->Ascending, "D"->Descending)
        cSortOrder,;    // indextag or oRs:fieldname or column number of array programmer need not code for sorting colimns
        cDataType, ;    // internally used:  data type of eval(bEditValue)
        cEditKeys, ;    // if not nil key matching the editkeys only triggers edit in lFastEdit mode
        bFooter,   ;    // Optional codeblock to calculate the footer containt
        cToolTip

   DATA nWidth,;        // Column width
        nDisplayCol,;   // Actual column display value in pixels
        nCreationOrder,;// Ordinal creation order of the columns
        nResizeCol,;    // Internal value used for column resizing
        nPos,;          // Actual column position in the browse. If columns is not visible nPos == 0
        nTotal          // optional total to be displayed in footer

   DATA nDataLen,;      // Optional Data length in characters
        nDataDec,;      // Optional Decimal length for Numbers
        nDataLines

   DATA nDataStrAlign,; // Data string alignment (left, center, right)
        nHeadStrAlign,; // Header string alignment (left, center, right)
        nFootStrAlign   // Footer string alignment (left, center, right)

   DATA nDataBmpAlign,; // Data bitmap alignment (left or right)
        nHeadBmpAlign,; // Header bitmap alignment (left or right)
        nFootBmpAlign   // Footer bitmap alignment (left or right)

   DATA nBtnBmp AS NUMERIC INIT 0  // Buttonget

   DATA nDataStyle,;    // Style for data string (DrawTextEx() flags)
        nHeadStyle,;    // Style for header string (DrawTextEx() flags)
        nFootStyle      // Style for footer string (DrawTextEx() flags)

   DATA nArrayCol AS NUMERIC INIT 0 // For Array Browse. Specifying Column Numer is all that is needed

   DATA nHeadBmpNo,;    // header ordinal bitmap to use of ::aBitmaps
        nFootBmpNo ;    // footer ordinal bitmap to use of ::aBitmaps
        AS NUMERIC

   DATA nAlphaLevelHeader AS NUMERIC INIT 255 // Alpha Channel Level for Header
   DATA nAlphaLevelFooter AS NUMERIC INIT 255 // Alpha Channel Level for Footer

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

   DATA lBmpTransparent //AS LOGICAL INIT .f.  // transparent bitmaps on brushed backgrounds ( default in adjust method )
   DATA lBtnTransparent AS LOGICAL INIT .f.  // transparent button on nEditType > 3
   DATA lAutoSave       AS LOGICAL INIT .f.
   DATA lColTransparent AS LOGICAL INIT .f.

// PROGBAR
   DATA lProgBar AS LOGICAL INIT .f.
   DATA bClrProg INIT { || { RGB(200,200,255), CLR_YELLOW } }
   DATA nProgTot AS NUMERIC INIT 1

   DATA lTotal AS LOGICAL INIT .F. // used by report and toexcel methods to include totals for the column
   DATA hChecked AS LOGICAL INIT .F.   // internal use only

   DATA Cargo           // For your own use

   DATA lMergeVert INIT .f.
   DATA aMerge

   DATA nHeaderType     // Silvio

   DATA   bAlphaLevel   // Used for set Alpha Channel Level
   DATA   hAlphaLevel   // Data for set Alpha Channel Level

   CLASSDATA lRegistered AS LOGICAL // used internally

// METHODS

   METHOD New( oBrw )   // Creates a new instance of the class

   METHOD End()         // Destroys the object

   METHOD Edit( nKey )  // Goes to Edit mode (::nEditType should be 1,2, 0 3)
                        // When nEditType is greater than 0,this method is called
                        // automatically when doubleclicling with the mouse or pushing
                        // the Enter key. nKey is a first key to stuff into the Get
                        // Note: On multiline gets Ctrl+Enter is used to confirm the edition

   METHOD EditDateTime( nKey )

   METHOD nEditType();  // Sets or Gets de Edit Mode
          SETGET        // 0=none, 1=Get, 2=Listbox, 3=block, 4=Get+Listbox, 5 = Get+block, 6 DtPicker

   METHOD AddResource( cRes )  // Adds a new bitmap to the ::aBitmaps array giving his resource name
   METHOD AddBmpFile( cFile )  // Adds a new bitmap to the ::aBitmaps array giving his file name
   METHOD AddBmpHandle( hBmp ) // Adds a new bitmap to the ::aBitmaps array giving his bitmap handle

    METHOD ChangeBitmap( ) // ButtonGet

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

   METHOD nAlphaLevel( nLevel ) SETGET // Set Alpha Channel Tranparence Level

   // The rest of the methods are used internally

   METHOD Adjust()

   METHOD HeaderHeight()
   METHOD HeaderWidth()
   METHOD FooterHeight()
   METHOD FooterWidth()
   METHOD DataHeight()
   METHOD DataWidth()

// METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC )
   METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC, nWidthTop, cHeaderTop ) // Silvio (..., nWidthTop, cHeaderTop)

   METHOD PaintData( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow )
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

   METHOD SetCheck( aBmps, uEdit, aPrompts )
   METHOD CheckToggle()
   METHOD SetProgBar( nLimit, bClrProg )
   METHOD SetAlign( nAlign )
   METHOD SetOrder()                      // used internally
   METHOD SortArrayData()                 // used internally
   METHOD ClpText
   METHOD Paste( cText )
   METHOD ToExcel( oSheet, nRow, nCol )
   METHOD isEditKey( nKey )               // used internally
   METHOD Value( uVal ) SETGET
   METHOD BlankValue()
   ACCESS lEditable INLINE ( ::nEditType > 0 .and. ::bOnPostEdit != nil .and. ( ::bEditWhen == nil .or. Eval( ::bEditWhen, Self ) ) )

   METHOD WorkMergeData()
   METHOD HasBorder()
   METHOD MergeArea()

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

   local nWid, tmp

   DEFAULT ::cOrder   := ""

   if ::cEditPicture == nil .and. ::cDataType == 'T'
      ::cEditPicture := '@T'
   endif

   if ValType( ::oBrw:aArrayData ) == 'A'
      if ::bEditValue == nil
         if ::nArrayCol > 0
            ::bEditValue   := ;
               { |x| If( x == nil, ::oBrw:ArrCell( ::oBrw:nArrayAt, ::nArrayCol ), ;
                                   ::oBrw:ArrCellSet( ::oBrw:nArrayAt, ::nArrayCol, x ) ) }
            if ValType( ::bBmpData) == 'N'
               tmp                     := ::bBmpData
               ::bBmpData              := { || ::oBrw:aRow[ tmp ] }
            elseif ::bStrData == nil .and. ! ::hChecked
               ::bStrData     := ;
                  { || ::oBrw:ArrCell( ::oBrw:nArrayAt, ::nArrayCol, ::cEditPicture ) }
            endif
         endif
      endif

   elseif ValType( ::oBrw:aArrayData ) == 'H'
         DEFAULT ::nWidth        := 100
   endif

   if ::bEditValue != nil

      if Empty( ::cDataType ) .or. ::cDataType $ 'CU'
         ::cDataType := ValType( ::Value )
      endif

      if ::cEditPicture == nil .and. ::cDataType == 'N' .and. ;
         ::nDataLen != nil .and. ::oBrw:nDataType != DATATYPE_ARRAY
         ::cEditPicture := NumPict( ::nDataLen, ::nDataDec, .t., lThouSep )
      endif

      if ::cDataType $ 'DT'
         DEFAULT ::nDataStrAlign   := AL_RIGHT, ;
                 ::nHeadStrAlign   := AL_RIGHT
      endif

      if ::cDataType == 'N'
         DEFAULT ::nDataStrAlign := AL_RIGHT, ;
                 ::nHeadStrAlign := AL_RIGHT, ;
                 ::nFootStrAlign := AL_RIGHT
      else
         ::lTotal := .F.
      endif

      if ::bStrData == nil .and. !( ::cDataType $ 'PF' )// .and. ::bBmpData == nil
         ::bStrData  := { || cValToStr( ::Value, ::cEditPicture ) }
      elseif ValType( ::bStrData ) != 'B'
         ::bStrData  := nil
      endif

      DEFAULT ::bOnPostEdit := { |o,x,n| If( n != VK_ESCAPE, ::Value := x,) }

      if ::cSortOrder != nil
         if ValType( ::cSortOrder ) != 'B'
            if ( ::oBrw:nDataType == DATATYPE_RDD )
               if EQ( (::oBrw:cAlias)->( OrdSetFocus() ), ::cSortOrder )
                  ::cOrder       := 'A'
               endif
            elseif ( ::oBrw:nDataType == DATATYPE_ADO )
               if EQ( ::oBrw:oRs:Sort, ::cSortOrder )
                  ::cOrder       := 'A'
               endif
            elseif ( ::oBrw:nDataType == DATATYPE_ODBF )
               if EQ( ::oBrw:oDbf:SetOrder, ::cSortOrder )
                  ::cOrder       := 'A'
               endif
            endif
         endif
      endif
   endif

   if ::nEditType == -1 .or. ::bStrImage != nil    // TYPE_IMAGE
      ::cDataType        := 'F'
   endif

   if ValType( tmp := ::Value ) == 'C' .and. IsBinaryData( tmp )
      if FITypeFromMemory( tmp ) >= 0
         ::cDataType    := 'P'
      endif
   endif

   DEFAULT ::cDataType   := 'C'

   if ::cDataType $ 'PF'
      ::oBrw:lExcelCellWise   := .t.   // cellwise export to excel
      DEFAULT ::lBmpTransparent := .f.
   elseif ::cDataType == 'M'
      DEFAULT ::nWidth   := 200
   endif

   DEFAULT ::lBmpTransparent := .t.

   if ( ::bStrData == nil .or. Eval( ::bStrData ) == nil ) .and. ;
      ( ::bBmpData != nil .or. ::cDataType $ 'PF')


      DEFAULT ::nDataBmpAlign := AL_CENTER

   endif

   DEFAULT ::oDataFont   := ::oBrw:oFont,;
           ::oHeaderFont := ::oBrw:oFont,;
           ::oDataFontBold := ::oBrw:oFont,;  //---------------------- Silvio
           ::oFooterFont := ::oBrw:oFont,;
           ::oEditFont   := ::oBrw:oFont // Edit Font


   DEFAULT ::nDataStrAlign := AL_LEFT,;
           ::nDataBmpAlign := AL_LEFT,;
           ::nHeadStrAlign := AL_LEFT,;
           ::nFootStrAlign := AL_LEFT,;
           ::nHeadBmpAlign := AL_LEFT,;
           ::nFootBmpAlign := AL_LEFT

   DEFAULT ::bClrHeader   := ::oBrw:bClrHeader,;
           ::bClrFooter   := ::oBrw:bClrFooter,;
           ::bClrGrad     := ::oBrw:bClrGrad, ;
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


   if ::lMergeVert
      ::oBrw:lMergeVert := .t.
      ::WorkMergeData()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Value( uNew ) CLASS TXBrwColumn

   local uVal

   if PCount() > 0 .and. ::bEditValue != nil

      TRY
         uVal   := Eval( ::bEditValue )
      CATCH
      END
      if ! ( ValType( uVal ) == ValType( uNew ) .and. uVal == uNew )
         TRY
            Eval( ::bEditValue, uNew )
            ::oBrw:lEdited    := .t.
         CATCH
         END
      endif

   endif

   uVal     := nil
   if ::bEditValue == nil .and. ::nArrayCol > 0
      // this is the case for arrays before oCol:Adjust
      uVal     := ::oBrw:ArrCell( ::oBrw:nArrayAt, ::nArrayCol )
   elseif ::bEditValue != nil
      TRY
         uVal  := Eval( ::bEditValue )
      CATCH
         uVal  := ::BlankValue()
      END
   elseif ::bStrData != nil
      TRY
         uVal  := Eval( ::bStrData )
      CATCH
         uVal  := ''
      END
   endif

return uVal


//----------------------------------------------------------------------------//

METHOD BlankValue() CLASS TXBrwColumn

   local uVal  := ''

   if ::cDataType == 'N'
      uVal     := 0
   elseif ::cDataType == 'D'
      uVal     := CToD( '' )
   elseif ::cDataType == 'L'
      uVal     := .f.
   endif

return uVal

//------------------------------------------------------------------//

METHOD nAlphaLevel( uNew ) CLASS TXBrwColumn

   if uNew != NIL
      ::hAlphaLevel := uNew
   else
      if ::bAlphaLevel != NIL
         ::hAlphaLevel = eval( ::bAlphaLevel, Self )
      endif
   endif

return ::hAlphaLevel


//----------------------------------------------------------------------------//


METHOD SetCheck( aBmps, uEdit, aPrompts ) CLASS TXBrwColumn

   local nBmpOn, nBmpOff := 0, nBmpNull := 0
   local LogiVal := .f.

   if ValType( aBmps ) != 'A' .or. Len( aBmps ) < 1
      aBmps    := { '', '' }
   endif
   if Len( aBmps ) < 2
      AAdd( aBmps, '' )
   endif

   if ValType( aBmps[ 1 ] ) == 'C' .and. ;
      If( ".bmp" $ Lower( aBmps[ 1 ] ), ::AddBmpFile ( aBmps[ 1 ] ), ::AddResource( aBmps[ 1 ] ) )
         nBmpOn      := Len( ::aBitMaps )
   else
      ::AddBmpHandle( FWBmpOn() )   ; nBmpOn    := Len( ::aBitmaps )
   endif
   if ValType( aBmps[ 2 ] ) == 'C' .and. ;
      If( ".bmp" $ Lower( aBmps[ 2 ] ), ::AddBmpFile ( aBmps[ 2 ] ), ::AddResource( aBmps[ 2 ] ) )
         nBmpOff  := Len( ::aBitMaps )
   else
      ::AddBmpHandle( FWBmpOff() )  ; nBmpOff   := Len( ::aBitmaps )
   endif

   ::bBmpData  := { | u | If( ValType( u := ::Value ) == 'L', If( u, nBmpOn, nBmpOff ), nBmpNull ) }
   ::bStrData  := .f.
   ::hChecked  := .t.
   if ValType( uEdit ) == 'B'
      ::bOnPostEdit  := uEdit
      ::nEditType    := EDIT_GET
   elseif ValType( uEdit ) == 'N'
      ::nEditType    := uEdit
   elseif ValType( uEdit ) == 'L'
      ::nEditType    := If( uEdit, EDIT_GET, 0 )
   endif
   if ValType( aPrompts ) == 'A'
      if Len( aPrompts ) < 3
         ASize( aPrompts, 3 )
      endif
      AEval( aPrompts, { |c, i| If( ValType( c ) != 'C', aPrompts[ i ] := '', ) } )
      ::bStrData  := { | u | If( ValType( u := ::Value ) == 'L', ;
                     If( u, aPrompts[ 1 ], aPrompts[ 2 ] ), aPrompts[ 3 ] ) }
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CheckToggle() CLASS TXBrwColumn

   local uVal  := IfNil( ::Value, .f. )

   if ValType( uVal ) == 'L'
      ::PostEdit( ! uVal )
   endif

return Self

//------------------------------------------------------------------//

METHOD SetProgBar( nLimit, nWidth, bClrProg ) CLASS TXBrwColumn

   DEFAULT nWidth := 104

   ::lProgBar        := .t.
   if nLimit != nil
      ::nProgTot     := nLimit
   endif
   if ValType( bClrProg )  == 'B'
      ::bClrProg     := bClrProg
   endif

   ::nDataStrAlign := ::nHeadStrAlign := AL_CENTER
   nWidth            := Max( 104, nWidth )
   if ::nWidth == nil .or. ::nWidth < nWidth
      ::nWidth       := nWidth
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetAlign( nAlign ) CLASS TXBrwColumn

   if ValType( nAlign ) == 'N'
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

   nHeight := FontHeight( ::oBrw, ::oBrw:oWnd:oFont )

   if !Empty( ::cHeader ) .and. ::oHeaderFont != nil
      nHeight := FontHeight( ::oBrw, ::oHeaderFont )
      if FontEsc( ::oHeaderFont ) % 1800  == 900
         nHeight := Max( nHeight, ::oBrw:GetWidth( ::cHeader, ::oHeaderFont ) + 6 )
      endif
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
      if FontEsc( ::oHeaderFont ) % 1800 == 900
         nWidth   := FontHeight( ::oBrw, ::oHeaderFont ) + 6
      else
          nLen  := Len( cText )
          While nFrom <= nLen
            cLine  := ExtractLine( cText, @nFrom )
            nWidth := Max( nWidth, ::oBrw:GetWidth( cLine, ::oHeaderFont ) )
          enddo
      endif
   endif

   if ::nHeadBmpNo > 0 .and. ::nHeadBmpNo <= Len( ::aBitmaps )
      nWidth += ::aBitmaps[ ::nHeadBmpNo, BITMAP_WIDTH ] + BMP_EXTRAWIDTH
   elseif ! Empty( ::cSortOrder )
      nWidth += ::oBrw:aSortBmp[ 1 ][ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
   endif
/*
   // commented out 2008-07-16

   if ::nHeadBmpNo == -1
      nTemp := nWidth
      for nFor := 1 to Len( ::aBitmaps )
         nWidth := Max( nWidth, nTemp + ::aBitmaps[ nFor, BITMAP_WIDTH ] + BMP_EXTRAWIDTH )
      next
      ::nHeadBmpNo := 0
   endif
*/

return Max( nWidth, 16 )

//----------------------------------------------------------------------------//

METHOD FooterHeight() CLASS TXBrwColumn

   local nHeight
   local cFooter

   nHeight := FontHeight( ::oBrw, ::oBrw:oWnd:oFont )

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

   local nHeight, nBmp, nBmpHeight, cData

   nHeight := FontHeight( ::oBrw, ::oBrw:oWnd:oFont )

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

   if ::cDataType $ "PF"
      // image
      if ::cDataType == 'F' .and. File( ::Value )
         nBmp     := FILoadImg( ::Value )
      else
         nBmp     := FILoadFromMemory( ::Value )
      endif
      nHeight     := Int( GetSysMetrics( 1 ) / 10 )
      if nBmp > 0
         nHeight  := Min( nBmpHeight( nBmp ) + 4, nHeight )
      endif
      DeleteObject( nBmp )
      if ::oBrw:nDataLines > 1
         nheight  := Round( nHeight / ::oBrw:nDataLines, 0 )  // dont want this height to be multiplied by datalines
      endif
   endif

   if ::nEditType == EDIT_DATE
      nHeight  := Max( 24, nHeight )
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

      if ::nDataLen != nil
         nWidth   := Max( nWidth, ::oBrw:GetWidth( Replicate( 'B', ::nDataLen ), oFont ) )
      endif

   endif

   if ::bBmpData != nil
      nBmpWidth   := 0
      AEval( ::aBitmaps, { |a| nBmpWidth := Max( nBmpWidth, a[ BITMAP_WIDTH ] ) } )
      nWidth   += nBmpWidth + BMP_EXTRAWIDTH
   endif

   if ::cDataType $ 'PF'
      // image
      if ::cDataType == 'F' .and. File( ::Value )
         nBmp     := FILoadImg( ::Value )
      else
         nBmp     := FILoadFromMemory( ::Value )
      endif
      nWidth      := Int( GetSysMetrics( 0 ) / 10 )
      if nBmp > 0
         nWidth   := Min( nBmpWidth( nBmp ) + 4, nWidth )
      endif
      DeleteObject( nBmp )
   endif

   if ::lProgBar
      nWidth   := Max( nWidth, 104 )
   endif

   if ::nEditType > 1
      nWidth += 15
   endif

return nWidth

//----------------------------------------------------------------------------//

//METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC ) CLASS TXBrwColumn
METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC, nWidthTop, cHeaderTop ) CLASS TXBrwColumn
   local hBrush
   local oFont
   local aColors, aBitmap
   local cHeader
   local nWidth, nBmpRow, nBmpCol, nBmpNo, nBmpAlign
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
  // nWidth  := ::nWidth
     nWidth  := ::nWidth+1   //---------- Silvio
   nBmpNo  := ::nHeadBmpNo
       //---------------------------------- Silvio
   If ::nHeaderType==1 .or. ::nHeaderType==3 .or. ::nHeaderType==4
      cHeader := cHeaderTop
      nWidth  := If(nWidthTop==Nil, nWidth, nWidthTop+1)
   EndIf
   //----------------------------------
   if ::oBrw:l2007
      GradientFill( hDC, nRow - 1, nCol, nRow + nHeight - 1, nCol + nWidth, ;
               Eval( ::bClrGrad, lInvert ) )
   else
      hBrush  := CreateSolidBrush( aColors[ 2 ] )
      FillRect( hDC, { nRow, nCol, nRow + nHeight, nCol + nWidth }, hBrush )
      DeleteObject( hBrush )
   endif



   nCol    += ( COL_EXTRAWIDTH / 2 )
   nWidth  -=  COL_EXTRAWIDTH
   nRow    += ( ROW_EXTRAHEIGHT / 2 )
   nHeight -=  ROW_EXTRAHEIGHT

//   if ! Empty( ::cOrder ) .or. nBmpNo > 0 .and. nBmpNo <= Len( ::aBitmaps )
   if ( ValType( ::cOrder ) == 'C' .and. ::cOrder $ 'AD' ) .or. ;       //2008-07-16
      ( nBmpNo > 0 .and. nBmpNo <= Len( ::aBitmaps ) )

      if ! Empty( ::cOrder )
         aBitmap     := ::oBrw:aSortBmp[ If( ::cOrder == 'A', 1, 2 ) ]
         nBmpAlign   := AL_RIGHT
      else
         aBitmap     := ::aBitmaps[ nBmpNo ]
         nBmpAlign   := ::nHeadBmpAlign
      endif
      nWidth         -= aBitmap[ BITMAP_WIDTH ]
      if Empty(cHeader)
         nBmpCol := nCol + nwidth / 2
      elseif nBmpAlign == AL_LEFT
         nBmpCol     := nCol
         nCol        += aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
      else
         nBmpCol := nCol + nWidth
      endif
      nWidth         -= BMP_EXTRAWIDTH
      nBmpRow        := ( nHeight - aBitmap[ BITMAP_HEIGHT ] ) / 2 + 4
      if ! ::oBrw:l2007
         if SetAlpha() .and. aBitmap[ BITMAP_ALPHA ]
            ABPaint( hDC, nBmpRow, nBmpCol, aBitmap[ BITMAP_HANDLE ], ::nAlphaLevelHeader )
         else
            PalBmpDraw( hDC, nBmpRow, nBmpCol,;
                        aBitmap[ BITMAP_HANDLE ],;
                        aBitmap[ BITMAP_PALETTE ],;
                        aBitmap[ BITMAP_WIDTH ],;
                        aBitmap[ BITMAP_HEIGHT ];
                        ,, .t., aColors[ 2 ] )
         endif
      else
         if SetAlpha() .and. aBitmap[ BITMAP_ALPHA ]
            ABPaint( hDC, nBmpCol, nBmpRow, aBitmap[ BITMAP_HANDLE ], ::nAlphaLevelHeader )
         else
            DEFAULT aBitmap[ BITMAP_ZEROCLR ] := GetZeroZeroClr( hDC, aBitmap[ BITMAP_HANDLE ] )
            SetBkColor( hDC, nRGB( 255, 255, 255 ) )
            TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                      aBitmap[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, nBmpWidth( aBitmap[ BITMAP_HANDLE ] ),;
                      nBmpHeight( aBitmap[ BITMAP_HANDLE ] ) )
         endif
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

   if FontEsc( oFont ) % 3600 == 900

      nBottom  := nRow + nHeight / 2
      nBottom  += ( ::oBrw:GetWidth( cHeader, ::oHeaderFont ) / 2 )
      nCol     := nCol + nWidth / 2
      nCol     -= FontHeight( ::oBrw, ::oHeaderFont ) / 2

      DrawTextEx( hDC, cHeader,;
                  { nBottom, nCol, nRow, nCol + nWidth }, ;
                  DT_LEFT + DT_VCENTER )

   elseif FontEsc( oFont ) % 3600  == 2700

      nBottom  := nRow + nHeight / 2
      nBottom  += ( ::oBrw:GetWidth( cHeader, ::oHeaderFont ) / 2 )
      nCol     := nCol + nWidth / 2
      nCol     += FontHeight( ::oBrw, ::oHeaderFont ) / 2

      DrawTextEx( hDC, cHeader,;
                  { nRow, nCol, nBottom, nCol - nWidth / 2 }, ;
                  DT_LEFT + DT_VCENTER )

   else
      nBottom  := nRow + nHeight

      DrawTextEx( hDC, cHeader,;
                  {nRow, nCol, nBottom, nCol + nWidth},;
                  ::nHeadStyle )
   endif

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
   elseif ::nTotal != nil
      cFooter  := ::nTotal
   elseif ::cFooter != nil
      cFooter  := ::cFooter
   endif

   cType    := ValType( cFooter )
   if cType != 'C'
      if cType == ::cDataType .and. ::cEditPicture != nil
         cFooter  := cValToStr( cFooter, ::cEditPicture )
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
      GradientFill( hDC, nRow - 1, nCol, nRow + nHeight - 1, nCol + nWidth, ;
            Eval( ::bClrGrad, lInvert ) )

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
         if SetAlpha() .and. aBitmap[ BITMAP_ALPHA ]
            ABPaint( hDC, nBmpCol, nBmpRow, aBitmap[ BITMAP_HANDLE ], ::nAlphaLevelFooter )
         else

            PalBmpDraw( hDC, nBmpRow, nBmpCol,;
                        aBitmap[ BITMAP_HANDLE ],;
                        aBitmap[ BITMAP_PALETTE ],;
                        aBitmap[ BITMAP_WIDTH ],;
                        aBitmap[ BITMAP_HEIGHT ];
                        ,, .t., aColors[ 2 ] )
         endif
      else
         if SetAlpha() .and. aBitmap[ BITMAP_ALPHA ]
            ABPaint( hDC, nBmpCol, nBmpRow, aBitmap[ BITMAP_HANDLE ], ::nAlphaLevelFooter )
         else

            DEFAULT aBitmap[ BITMAP_ZEROCLR ] := GetZeroZeroClr( hDC, aBitmap[ BITMAP_HANDLE ] )
            SetBkColor( hDC, nRGB( 255, 255, 255 ) )
            TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                      aBitmap[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, nBmpWidth( aBitmap[ BITMAP_HANDLE ] ),;
                      nBmpHeight( aBitmap[ BITMAP_HANDLE ] ) )
         endif
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

METHOD PaintData( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow ) CLASS TXBrwColumn

   local hDC, oBrush, hBrush, nOldColor, hBmp
   local oBrush1, oBrush2, hBrush1, hBrush2, aColor2, nWidth1
   local oFont
   local aColors, aBitmap, aBmpPal
   local cData
   local nWidth, nTop, nBottom, nBmpRow, nBmpCol, nBmpNo, nButtonRow, nButtonCol,nBtnWidth,;
         nRectWidth, nRectCol, nStyle, nType, nIndent, nBtnBmp, nFontHeight
   local lTransparent := .f.
   local lStretch     := .f.
   local lBrush       := .f.
   local cImagen, nBmpW, nBmpH

   DEFAULT lHighLite := .f.,;
           lSelected := .f.,;
           nOrder    := 0

   nBtnBmp := 0

   if ( ::oEditGet != nil .and. nRow == ::oBrw:nRowSel ) .or. ::oEditLbx != nil .or. ::oBrw:nLen == 0
      return nil
   endif

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif

   if ::bStrData != nil //.and. !::hChecked
      cData := Eval( ::bStrData )
      if ValType( cData ) != 'C'
         cData := cValToChar( cData )
      endif
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
               aColors  := Eval( ::bClrSelFocus )  // Eval( ::oBrw:bClrSelFocus )
            else
               aColors := Eval( If( ::oBrw:bClrRowFocus != nil, ::oBrw:bClrRowFocus, ::bClrSelFocus ) )
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
   elseif ! lTransparent .and. !::lColTransparent
      hBrush  := CreateSolidBrush( aColors[ 2 ] )
   elseif ::lColTransparent
         hBrush := CreateSolidBrush( 0 )
         lTransparent := .t.
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

   nBottom  := nRow + nHeight
   if ! lTransparent
      nTop        := nRow
      if ::lMergeVert .and. lHighLite .and. lSelected .and. nOrder == ::oBrw:nColSel
         ::MergeArea( @nTop, @nBottom, nPaintRow )
      endif
      FillRect( hDC, {nTop, nRectCol, nBottom, Min( nRectCol + nRectWidth, ::oBrw:BrwWidth() - 4 ) }, hBrush )
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

//   if nType > 1
//      nButtonRow := nRow
//      nButtonCol := nCol + nWidth - 10
//      nWidth -= 15
//   endif

   if nType > 1
      if ::nBtnBmp > 0 .and. len( ::aBitmaps ) >= ::nBtnBmp
         nBtnWidth      :=    ::aBitMaps[ ::nBtnBmp, BITMAP_WIDTH ] + 1
      else
         nBtnWidth      :=    10
      endif
      nButtonRow := nRow
      nButtonCol := nCol + nWidth - nBtnWidth
    nWidth -= ( nBtnWidth + 5 )
   endif

   if ::lProgBar
      aColor2  := Eval( ::bClrProg )
      hBrush1  := CreateSolidBrush( aColor2[ 1 ] )
      hBrush2  := CreateSolidBrush( aColor2[ 2 ] )
      nWidth1  := Min( ::Value() * nWidth / ::nProgTot, nWidth )

      FillRect( hDC, { nRow, nCol, nRow + nHeight, Min( nCol + nWidth1, ::oBrw:BrwWidth() - 4 ) }, hBrush1 )

      if nCol + nWidth1 < ::oBrw:BrwWidth() - 4
         FillRect( hDC, { nRow, nCol + nWidth1 + 1, nRow + nHeight, ;
             Min( nCol + nWidth, ::oBrw:BrwWidth() - 4 ) }, hBrush2 )
      endif
      DeleteObject( hBrush1 )
      DeleteObject( hBrush2 )

   endif

   if nBmpNo > 0 .and. nBmpNo <= Len( ::aBitmaps )
      aBitmap := ::aBitmaps[ nBmpNo ]
      nWidth  -= aBitmap[ BITMAP_WIDTH ]
      if ::bStrData == nil .OR. ::nDataBmpAlign == AL_CENTER // Align Imagen SetCheck
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

      if ::lMergeVert
         nTop     := nRow
         nBottom  := nRow + nHeight - 1
         ::MergeArea( @nTop, @nBottom, nPaintRow )
         nBmpRow := nTop + ( ( ( nBottom - nTop + 1 ) - aBitmap[ BITMAP_HEIGHT ] ) / 2 )
      endif
      // Paint bitmaps
      DEFAULT aBitmap[ BITMAP_ZEROCLR ] := GetZeroZeroClr( hDC, aBitmap[ BITMAP_HANDLE ] )

      if lStretch

         if SetAlpha() .and. aBitmap[ BITMAP_ALPHA ]
            hBmp := resizebmp( aBitmap[ BITMAP_HANDLE ], Min( nRectWidth,::oBrw:BrwWidth() - nRectCol - 4 ), nBottom - nRow )
            ABPaint( hDC, nRectCol, nRow, hBmp, ::nAlphaLevel() )
         else
            nOldColor  := SetBkColor( hDC, nRGB( 255, 255, 255 ) )
            TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                      aBitmap[ BITMAP_ZEROCLR ], hDC, nRectCol, nRow, Min( nRectWidth,::oBrw:BrwWidth() - nRectCol - 4 ), ;
                      nBottom - nRow )
            SetBkColor( hDC, nOldcolor )
         endif

      else
         if SetAlpha() .and. aBitmap[ BITMAP_ALPHA ]
            ABPaint( hDC, nBmpCol, nBmpRow,aBitmap[ BITMAP_HANDLE ], ::nAlphaLevel() )
         else
            if ::oBrw:lTransparent // transparent bitmaps with brush
                nOldColor := SetBkColor( hDC, nRGB( 255, 255, 255 ) )

                TransBmp( aBitmap[ BITMAP_HANDLE ], aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ],;
                         aBitmap[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, aBitmap[ BITMAP_WIDTH ], ;
                         aBitmap[ BITMAP_HEIGHT ] )

                SetBkColor( hDC, nOldColor )
             else
                PalBmpDraw( hDC, nBmpRow, nBmpCol,;
                           aBitmap[ BITMAP_HANDLE ],;
                           aBitmap[ BITMAP_PALETTE ],;
                           aBitmap[ BITMAP_WIDTH ],;
                           aBitmap[ BITMAP_HEIGHT ];
                           ,, ::lBmpTransparent, aColors[ 2 ] )

            endif
         endif
      endif
   endif


   if ! Empty( cData ) .and. IsBinaryData( cData )
      if FITypeFromMemory( cData ) >= 0
         cImagen  := cData
         cData    := ''
      else
         cData    := '<binary>'
      endif
   endif

   if ! Empty( cImagen ) .or. ::cDataType $ "FP"   // IMAGE
      if ! Empty( cImagen )
         hBmp     := FILoadFromMemory( cImagen )
      else
         if ::bStrImage == NIL
            cImagen := ::Value()
         else
            cImagen := Eval( ::bStrImage, Self, ::oBrw )
         endif
         if ::cDataType == 'F' .and. File( cImagen )
            hBmp     := FILoadImg( cImagen )
         else
            hBmp     := FILoadFromMemory( cImagen )
         endif
      endif

      aBmpPal     := { hBmp, 0 }
      if aBmpPal[ BITMAP_HANDLE ] == 0
         aBmpPal := PalBmpLoad( cImagen )
      endif


      if aBmpPal[ BITMAP_HANDLE ] != 0
         Aadd(aBmpPal, nBmpWidth( aBmpPal[ BITMAP_HANDLE ] ) )
         Aadd(aBmpPal, nBmpHeight( aBmpPal[ BITMAP_HANDLE ] ) )
         Aadd(aBmpPal, if ( ::lBmpTransparent, GetZeroZeroClr( hDC, aBmpPal[ BITMAP_HANDLE ] ),0) )
         Aadd(aBmpPal, HasAlpha( aBmpPal[ BITMAP_HANDLE ] ) )

         if ::lBmpStretch
            nBmpW       := nWidth - 2
            nBmpH       := nBottom - nRow - 2
            nBmpCol     := nCol + 1
            nBmpRow     := nRow + 1
         else
            nBmpW       := aBmpPal[ BITMAP_WIDTH ]
            nBmpH       := aBmpPal[ BITMAP_HEIGHT ]
            if nBmpW > ( nWidth - 4 )
               nBmpH    *= ( ( nWidth - 4 ) / nBmpW )
               nBmpW    := nWidth - 4
            endif
            if nBmpH > ( nBottom - nRow - 4 )
               nBmpW    *= ( ( nBottom - nRow - 4 ) / nBmpH )
               nBmpH    := ( nBottom - nRow ) - 4
            endif
            nBmpRow     := nRow + ( nHeight - nBmpH ) / 2 + 2
            nBmpCol     := nCol + 2

            if ::nDataBmpAlign == AL_CENTER
               nBmpCol  := nCol + ( nWidth - nBmpW ) / 2
            elseif ::nDataBmpAlign == AL_RIGHT
               nBmpCol  := nCol + nWidth - nBmpW
            endif

         endif

         if SetAlpha() .and. aBmpPal[ BITMAP_ALPHA ]

            hBmp := resizebmp( aBmpPal[ BITMAP_HANDLE ], nBmpW, nBmpH )
            ABPaint( hDC, nBmpCol, nBmpRow, hBmp, ::nAlphaLevel() )
            DeleteObject( hBmp )

         elseif ::lBmpTransparent

            nOldColor := SetBkColor( hDC, nRGB( 255, 255, 255 ) )
            TransBmp( aBmpPal[ BITMAP_HANDLE ], aBmpPal[ BITMAP_WIDTH ], aBmpPal[ BITMAP_HEIGHT ],;
                      aBmpPal[ BITMAP_ZEROCLR ], hDC, nBmpCol, nBmpRow, nBmpW, nBmpH )
            SetBkColor( hDC, nOldColor )

         else

            if nBmpW != aBmpPal[ BITMAP_WIDTH ] .or. nBmpH != aBmpPal[ BITMAP_HEIGHT ]
               hBmp := resizebmp( aBmpPal[ BITMAP_HANDLE ], nBmpW, nBmpH )
               DrawBitmap( hDC, hBmp, nBmpRow, nBmpCol )
               DeleteObject( hBmp )
            else
               DrawBitmap( hDC, aBmpPal[ BITMAP_HANDLE ], nBmpRow, nBmpCol )
            endif

         endif

      endif

   endif


   if ! Empty( cData ) .and. ! ( ::cDataType $ "PF" ) //.and. nType >= 0
      oFont:Activate( hDC )
      nFontHeight := GetTextHeight( ::oBrw:hWnd, hDC )
      if ::oBrw:lTransparent .and. ::oBrw:lContrastClr
         SetTextColor( hDC, ContrastColor( hDC, nCol, nRow, ;
            Min( nWidth, ::oBrw:BrwWidth() - nCol ), ;
            nHeight, aColors[ 1 ] ) )
      else
         SetTextColor( hDC, aColors[ 1 ] )
      endif
      if lTransparent .or. lBrush .or. ::lProgBar
         SetBkMode( hDC, 1 )
      else
         nOldColor := SetBkColor( hDC, aColors[ 2 ] )
      endif

      nTop     := nRow
      nBottom  := nRow + nHeight

      if ::lMergeVert
         ::MergeArea( @nTop, @nBottom, nPaintRow )
      endif

      if ::bPaintText == nil

         nStyle      := ::nDataStyle
         if ::oBrw:nDataType == DATATYPE_ARRAY .and. ;
            ::nDataStrAlign == AL_LEFT .and. ;
            ValType( ::Value ) $ 'ND'

            nStyle   := ::DefStyle( AL_RIGHT, .t. )
         endif

         if ::cDataType == 'M' .and. ::nDataLines == nil
            if ::oBrw:nDataLines > 1
               ::nDataLines   := ::oBrw:nDataLines
            elseif ( ::oBrw:nRowHeight >= 2 * nFontHeight + 4 )
               ::nDataLines   := 2
               ::nDataStyle   := ;
               nStyle         := ::DefStyle( ::nDataStrAlign, .f. )
            endif
         endif

         DrawTextEx( hDC, cData,;
                  {nTop, nCol, nBottom, Min( nCol + nWidth, ::oBrw:BrwWidth() - 5 ) }, nStyle )
      else
         Eval( ::bPaintText, Self, hDC, cData, ;
                  { nRow, nCol, nRow + nHeight,Min( nCol + nWidth, ::oBrw:BrwWidth() - 5 ) } )
      endif
      if nOldColor != nil
         SetBkcolor( hDC, nOldColor )
         nOldColor := nil
      endif
      oFont:Deactivate( hDC )
   endif

   if nType > 1 .and. nType < EDIT_DATE
      if lSelected
         if !::lBtnTransparent
               WndBoxRaised(hDC, nButtonRow -1 , nButtonCol - 1,;
                                 nButtonRow + nHeight, nButtonCol + nBtnWidth + 1 ) // ButtonGet
         endif

         if nType == EDIT_LISTBOX .or. nType == EDIT_GET_LISTBOX
           ::oBtnElip:Hide()
           ::oBtnList:Move( nButtonRow, nButtonCol, nBtnWidth + 1, nHeight, .f.) // ButtonGet
           ::oBtnList:Show()
           ::oBtnList:GetDC()
           if ::lBtnTransparent
              ::oBtnList:SetColor( aColors[ 1 ],aColors[ 2 ] )
           else
              FillRect( hDC, {nButtonRow, nButtonCol, nButtonRow + nHeight , nButtonCol + nBtnWidth + 1 } ,;   // ButtonGet
                       ::oBtnList:oBrush:hBrush  )
           endif
           ::oBtnList:Paint()
           ::oBtnList:ReleaseDC()
         else
            ::oBtnList:Hide()
            ::oBtnElip:Move( nButtonRow, nButtonCol, nBtnWidth + 1, nHeight, .f.) // ButtonGet
            ::oBtnElip:Show()
            ::oBtnElip:GetDC()
           if ::lBtnTransparent
              ::oBtnElip:SetColor( aColors[ 1 ],aColors[ 2 ] )
           else
              FillRect( hDC, {nButtonRow, nButtonCol, nButtonRow + nHeight , nButtonCol + nBtnWidth + 1 },; // ButtonGet
                      ::oBtnElip:oBrush:hBrush )
           endif
            ::oBtnElip:Paint()
            ::oBtnElip:ReleaseDC()
         endif
      endif
   endif



   if hBrush != nil .and. ! lBrush
      DeleteObject( hBrush )
   endif
   if aBmpPal != nil
      DeleteObject( aBmpPal[ BITMAP_HANDLE ]  )
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
      Aadd(aBmpPal, HasAlpha( aBmpPal[ BITMAP_HANDLE ] ) )
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
      Aadd(aBmpPal, HasAlpha( aBmpPal[ BITMAP_HANDLE ] ) )
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
      Aadd(aBmpPal, HasAlpha( aBmpPal[ BITMAP_HANDLE ] ) )
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
            ::oBrw:oWnd:Update()
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

      // En Windows NT esto no va bien

      if .t. // !IsWinNT()

      if Empty( ::oDragWnd )
         ::PaintHeader( 2, nil, ::oBrw:nHeaderHeight - 3 )
         DEFINE WINDOW ::oDragWnd OF ::oBrw STYLE WS_CHILD
            ::oDragWnd:bPainted := {| hDC | ::PaintHeader( 0, 0, ::oBrw:nHeaderHeight, .t., hDC ), WndRaised( ::oDragWnd:hWnd, hDC ) }
            ::oDragWnd:Move(nRow, nCol, ::nWidth, ::oBrw:nHeaderHeight)
         ACTIVATE WINDOW ::oDragWnd
      else
         ::oDragWnd:Move(nRow, nCol, ::nWidth, ::oBrw:nHeaderHeight, .t.)
      endif

      end if

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

         if ::nBtnBmp > 0 .and. !empty( ::aBitMaps )
            if ::nBtnBmp > len( ::aBitMaps )
               ::nBtnBmp := len( ::aBitMaps )
            endif
               ::ChangeBitMap( )
         endif

      ::oBtnList:Hide()
      ::oBtnElip:Hide()

   endif

return nil

//------------------------------------------------------------------------------

METHOD ChangeBitmap( ) CLASS TXBrwColumn // BtnGet

   if ::nBtnBmp > 0 .and. len( ::aBitmaps ) >= ::nBtnBmp
      ::oBtnElip:hBitmap1 := ::aBitMaps[::nBtnBmp, BITMAP_HANDLE ]
      ::oBtnList:hBitmap1 := ::aBitMaps[::nBtnBmp, BITMAP_HANDLE ]
      ::oBtnElip:cCaption := ""
  else
   ::oBtnElip:hBitmap1 := 0
      ::oBtnList:hBitmap1 := 0
      ::oBtnElip:cCaption := "..."
  endif

  ::oBrw:refresh()

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

   if ValType( cKey ) == 'N'
      cKey     := Upper( Chr( cKey ) )
   endif

   if ::cEditKeys != nil
      if cKey $ ::cEditKeys
         lEditKey := .t.
      endif
   else
      if ::cDataType $ 'ND'
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
   local uValue, cPic
   local nRow, nCol, nWidth, nHeight, nBtnWidth // ButtonGet
   local hBrush
   local lCenter, lRight
   local oFont // Edit Font

   if ::cDataType != nil .and. ::cDataType $ 'FP'
      return nil
   endif


   if ValType ( ::oEditFont ) == "B"
         oFont = Eval( ::oEditFont, Self )
    else
         oFont = ::oEditFont
   endif

   nBtnWidth := 10 // ButtonGet

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
/*
   if ::bEditValue == nil
      ::bEditValue := ::bStrData
   endif
*/
   cPic    := ::cEditPicture
   DEFAULT cPic := ""


   uValue  := ::Value      //Eval( ::bEditValue )
   if ValType( uValue ) == 'D'
      if !Empty( cPic ) .and. Left( cPic, 1 ) != '@'
         cPic  := '@D'
      endif
      if cPic == '@T'
         cPic  := '@D'
      endif

   endif

   if ::nEditType >= EDIT_DATE
      return ::EditDateTime( nKey )
   endif


   aColors := Eval( ::bClrEdit )
   lCenter := ( ::nDataStrAlign == AL_CENTER )
   lRight  := ( ::nDataStrAlign == AL_RIGHT )

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight()

   hBrush := CreateSolidBrush( aColors[ 2 ] )
   ::EraseData( nRow, ::nDisplayCol, ::oBrw:nRowHeight  , hBrush )
   DeleteObject( hBrush )

   if ValType( uValue ) == 'C' .and. IfNil( ::nDataLines, ::oBrw:nDataLines ) > 1 .and. ;
      Empty( cPic )

      if isRtf( uValue )
         return nil
      else
         ::oEditGet := TMultiGet():New( 0,0,{ | u | If(PCount()==0,uValue,uValue:= u ) },;
                                       ::oBrw,0,0,oFont,.F.,aColors[ 1 ],aColors[ 2 ];
                                       ,,.F.,,.F.,,lCenter,lRight,.F.,,,.F.,.T.,.F. ) // oFont ADDED
      endif
   else

      if ValType( uValue ) $ 'AHO'
         XBrowse( uValue, ::cHeader, nil, nil, nil, nil, nil, .t. )
         return .f.
      else
         ::oEditGet := TGet():New( 0,0,{ | u | If(PCount()==0,uValue,uValue:= u ) },;
                                  ::oBrw,0,0,cPic,,aColors[ 1 ],aColors[ 2 ];
                                  ,oFont,.F.,,.F.,,.F.,,lCenter,lRight,,.F.,.f.,.T.,,.F.,,,,) // oFont ADDED
      endif
   endif

   nRow    := ( ( ::oBrw:nRowSel - 1  ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight() + 2

   nCol    := ::nDisplayCol + 3

   if ::nBtnBmp > 0 .and. len( ::aBitmaps ) >= ::nBtnBmp      // ButtonGet
      nBtnWidth      :=    ::aBitMaps[ ::nBtnBmp, BITMAP_WIDTH ]  // ButtonGet
   else
      nBtnWidth      :=    4
   endif

   nWidth  := ::nWidth - nBtnWidth

   nHeight := ::oBrw:nRowHeight - 4

   if ::nEditType > 2
      nWidth -= 13
   endif

   if ::bEditValid != nil
      ::oEditGet:bValid := { | oGet, lRet | oGet:lValidating := .T., lRet := Eval( ::bEditValid, oGet, Self ), oGet:lValidating := .F., If( ! lRet, oGet:SetFocus(),), lRet }
   endif

   ::oEditGet:bKeyDown   := { | nKey | EditGetkeyDown( Self, nKey ) }

   ::oEditGet:bLostFocus := { | oGet, hWndFocus | EditGetLostFocus( oGet, hWndFocus, ::oBrw, ::oEditGet, Self ) }

   if ::bGetChange != nil
      ::oEditGet:bChange   := { | k, f, o | ::oBrw:nLastKey := k, Eval( ::bGetChange, k, f, o, Self ) }
   else
      ::oEditGet:bChange    := { | k, f, o | ::oBrw:nLastKey := k, .t. }
   endif

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
      if !oCol:lAutoSave
         oBrw:CancelEdit()
      endif
      return nil
   endif

   if oEditGet != nil .and. !oEditGet:lValidating
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
           if !Empty( ::oEditGet )
              ::oEditGet:bValid = nil
           end if

      case nKey == VK_RETURN
           if Empty( ::cEditPicture ) .and. ::oBrw:nDataLines > 1
              if !GetKeyState( VK_CONTROL )
                 lExit := .t.
              endif
           else
              lExit := .t.
           endif

      case nKey == VK_DOWN .or. nKey == VK_UP
           if !( Empty( ::cEditPicture ) .and. ::oBrw:nDataLines > 1 )
              lExit := .t.
           endif

   endcase

   If lExit .and. ::nEditType != EDIT_DATE
      if !Empty( ::oEditGet )
         ::oEditGet:nLastKey := nKey
         ::oEditGet:End()
      end if
   else
      if lExit
         ::PostEdit()
      endif
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD EditDateTime( nKey ) CLASS TXBrwColumn
local aColors
local lCenter, lRight
local nRow, nCol, nWidth, nHeight
local hBrush
local oFont
local uValue



   if ValType ( ::oEditFont ) == "B"
         oFont = Eval( ::oEditFont, Self )
    else
         oFont = ::oEditFont
   endif

   uValue  := ::Value

   aColors := Eval( ::bClrEdit )
   lCenter := ( ::nDataStrAlign == AL_CENTER )
   lRight  := ( ::nDataStrAlign == AL_RIGHT )

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight()

   hBrush := CreateSolidBrush( aColors[ 2 ] )
   ::EraseData( nRow, ::nDisplayCol, ::oBrw:nRowHeight , hBrush )
   DeleteObject( hBrush )

   if ::nEditType == EDIT_DATE
      ::oEditGet := TDatePick():New( 0, 0, { | u | If(PCount()==0,uValue,uValue:= u ) }, ::oBrw, 0, 0, , aColors[ 1 ],;
                  aColors[ 2 ], oFont, .f., , , , .f., , , ::cEditPicture )
   else
      ::oEditGet := TTimePick():New( 0, 0, { | u | If(PCount()==0,uValue,uValue:= u ) }, ::oBrw, 0, 0, , aColors[ 1 ],;
                  aColors[ 2 ], oFont, .f., , , , .f., , , )
      ::oEditGet:SetTime( uValue )
   endif

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight() + 2
   nCol    := ::nDisplayCol + 3

   nWidth  := ::nWidth - 4

   nHeight := ::oBrw:nRowHeight - 4

   if ::bEditValid != nil
      ::oEditGet:bValid := { | oGet, lRet | oGet:lValidating := .T., lRet := Eval( ::bEditValid, oGet, Self ), oGet:lValidating := .F., If( ! lRet, oGet:SetFocus(),), lRet }
   endif

   ::oEditGet:bKeyDown   := { | nKey | EditGetkeyDown( Self, nKey ) }

   if ::nEditType != EDIT_DATE
      ::oEditGet:bLostFocus := { | oGet, hWndFocus | EditGetLostFocus( oGet, hWndFocus, ::oBrw, ::oEditGet, Self ) }
   endif


   ::oEditGet:nLastKey := 0

   ::oEditGet:Move( nRow, nCol, nWidth, nHeight, .t. )
   ::oEditGet:SetFocus()
   ::oEditGet:SelectAll()

   ::oBrw:lEditMode := .T.

    if ::lEditBorder
      WndBoxIn( ::oBrw:GetDC(), nRow-1, nCol-1, nRow + nHeight + 1, nCol + nWidth + 1)
       ::oBrw:ReleaseDC()
   endif

    if nKey != nil
      PostMessage( ::oEditGet:hWnd, WM_CHAR, nKey )
    endif

   ::oBrw:nLastEditCol := ::nPos


RETURN .t.

//--------------------------------------------------------------------//

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
      AEval( aBound, {|v,e| aBound[ e ] := ::aEditListTxt[ e ] } )
//      AEval( aBound, {|v,e| aBound[ e ] := e } )
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
/*
   ::oEditLbx:bKeyDown   := {|k| ::oEditLbx:nLastKey := k,;
                                   If( k == VK_RETURN .and. nAt > 0,  xValue := aBound[ nAt ], ),;
                                 If( k == VK_RETURN .or. k == VK_ESCAPE, ::PostEdit( xValue, .t. ), ) }
*/
   ::oEditLbx:bKeyDown   := {|k| ::oEditLbx:nLastKey := k,;
                                   If( k == VK_RETURN,  xValue := aBound[ Max( 1, nAt ) ], ),;
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
      MsgStop( "oCol:bEditBlock not defined", "Fivewin: Class TXBrwColumn")
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

   ::oBrw:lEditMode := .T.
   ::PostEdit( Eval( ::bEditBlock, nRow, nCol, Self ), .t. )
   ::oBrw:nLastEditCol := ::nPos

return .t.

//----------------------------------------------------------------------------//

METHOD PostEdit( xValue, lButton ) CLASS TXBrwColumn

   local lGoNext := .f.
   local uOriginal    := ::Value()

   local nLastKey := 0

   If ::lOnPostEdit
      return nil
   Endif

   ::lOnPostEdit := .t.

   DEFAULT lButton := .f.

   do case
      case xValue != nil .and. ::nEditType == EDIT_GET
         Eval( ::bOnPostEdit, Self, xValue, 13 )
      case ::nEditType == EDIT_GET .or. ::nEditType >= EDIT_DATE
         if ::oEditGet != nil
            Eval( ::bOnPostEdit, Self, Eval( ::oEditGet:bSetGet ), ::oEditGet:nLastKey )
            nLastKey := ::oEditGet:nLastKey
            lGoNext := ( AScan( { VK_RETURN, VK_DOWN, VK_UP, VK_TAB }, ::oEditGet:nLastKey ) > 0 )
            ::oEditGet:End()
            ::oEditGet := nil
         endif

      case ::nEditType == EDIT_LISTBOX

           if xValue != nil
              Eval( ::bOnPostEdit, Self, xValue, ::oEditLbx:nLastKey )
           endif
           if ::oEditLbx != nil .and. IsWindow( ::oEditLbx:hWnd )
              ::oEditLbx:End()
              ::oEditLbx := nil
           endif

      case ::nEditType == EDIT_BUTTON
           if ::bOnPostEdit != nil
              Eval( ::bOnPostEdit, Self, xValue, 0 )
              lGoNext   := .t.
              nLastKey := VK_RETURN
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

   if ::cDataType == 'N' .and. ( ::cFooter != nil .or. ::bFooter != nil .or. ::nTotal != nil )
      if ::nTotal != nil
         ::nTotal    += ( ::Value() - uOriginal )
      elseif ::bFooter != nil
         Eval( ::bFooter, Self, ::Value() - uOriginal )
      endif
      ::RefreshFooter()
   endif

   ::lOnPostEdit := .f.

   if ::bOnChange != nil .and. ! EQ( ::Value, uOriginal )
      Eval( ::bOnChange, Self, uOriginal )
   endif


   If lGoNext
      ::oBrw:nLastKey   := nLastKey
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
               oCol   := ::oBrw:aCols[ n ]
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

         if ! Eq( ::oBrw:oDbf:SetOrder(), ::cSortOrder )
            ::oBrw:oDbf:SetOrder( ::cSortOrder )
            lSorted  := .t.
            For n := 1 TO Len(::oBrw:aCols)
               oCol   := ::oBrw:aCols[ n ]
               oCol:cOrder      := " "
            Next n
            ::cOrder           := 'A'
         endif

      elseif ValType( ::oBrw:cAlias ) == 'C' .and. ValType( ::cSortOrder ) == 'C'

         /*
         if Eq( (::oBrw:cAlias)->( OrdSetFocus() ), ::cSortOrder )

            // (::oBrw:cAlias)->( OrdDescend( , , ! OrdDescend() ) )

            ::cOrder             := If( ( ::oBrw:cAlias )->( OrdDescend() ), 'D', 'A' )
            lSorted              := .t.

         else
         */
            ( ::oBrw:cAlias )->( OrdSetFocus( ::cSortOrder ) )

            lSorted              := .t.
            for each oCol in ( ::oBrw:aCols )
               oCol:cOrder       := " "
            next
            ::cOrder             := if( ( ::oBrw:cAlias )->( OrdDescend() ), 'D', 'A' )
         /*
         endif
         */
      endif

   endif

   if lSorted
      ::oBrw:cSeek   := ""
   endif

return lSorted

//----------------------------------------------------------------------------//

METHOD SortArrayData()  CLASS TXBrwColumn

   local aCols
   local cOrder
   local nAt, nFor, nLen
   local uSave, cType

   aCols  := ::oBrw:aCols
   cOrder := ::cOrder
   nLen   := Len( aCols )
   nAt    := If( ValType( ::cSortOrder ) == 'N', ::cSortOrder, ::nArrayCol )

   if Len( ::oBrw:aArrayData ) > 0

      cType       := ValType( ::oBrw:aArrayData[ 1 ] )

      if cType == 'A'

         if ValType( nAt ) == 'N' .and. nAt > 0 .and. ;
               nAt <= Len( ::oBrw:aArrayData[ 1 ] )
            for nFor := 1 to nLen
               if aCols[ nFor ]:nArrayCol != ::nArrayCol
                  aCols[ nFor ]:cOrder := ""
               endif
            next

            uSave    := ::oBrw:aArrayData[ ::oBrw:nArrayAt ][ ::nArrayCol ]

            if cOrder == 'A'
               ::oBrw:aArrayData := Asort( ::oBrw:aArrayData,,, {|x,y| x[ nAt ] > y[ nAt ] } )
               ::cOrder     := 'D'
            else
               ::oBrw:aArrayData := Asort( ::oBrw:aArrayData,,, {|x,y| x[ nAt ] < y[ nAt ] } )
               ::cOrder     := 'A'
            endif

            ::oBrw:nArrayAt   := AScan( ::oBrw:aArrayData, { |a| a[ ::nArrayCol ] == uSave } )
      //      ::oBrw:nArrayAt   := AScan( ::oBrw:aArrayData, { |a| a == uSave } )

         ::oBrw:Refresh()

         endif

      elseif cType $ 'CDLN'

         if ! Empty( cOrder )
            uSave    := ::oBrw:aArrayData[ ::oBrw:nArrayAt ]
            if cOrder == 'A'
               ::oBrw:aArrayData := ASort( ::oBrw:aArrayData,,,{|x,y| cValToChar( x ) > cValToChar( y ) } )
               ::cOrder := 'D'
            else
               ::oBrw:aArrayData := ASort( ::oBrw:aArrayData,,,{|x,y| cValToChar( x ) < cValToChar( y ) } )
               ::cOrder := 'A'
            endif
            ::oBrw:nArrayAt      := AScan( ::oBrw:aArrayData, uSave )
            ::oBrw:Refresh()
         endif

      endif

   endif

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

      endif

   endif

return RetVal

//----------------------------------------------------------------------------//

METHOD ToExcel( oSheet, nRow, nCol ) CLASS TXBrwColumn

   local uVal     := ::Value
   local hBmp, hBmp2, nHeight, nWidth, oClp

   if uVal != nil
      if ::cDataType $ 'PF'
         if ::cDataType == 'F' .and. File( uVal )
            hBmp     := FILoadImg( uVal )
         else
            hBmp     := FILoadFromMemory( uVal )
         endif
         if hBmp != 0
            nHeight  := nBmpHeight( hBmp )
            nWidth   := nBmpWidth(  hBmp )
            if nWidth > ::nWidth .or. nHeight > ::oBrw:nRowHeight
               if nWidth > ::nWidth
                  nHeight  *= ( ::nWidth / nWidth )
                  nWidth   := ::nWidth
               endif
               if nHeight > ::oBrw:nRowHeight
                  nWidth   *= ( ::oBrw:nRowHeight / nHeight )
                  nHeight  := ::oBrw:nRowHeight
               endif
               hBmp2       := hBmp
               hBmp        := ResizeBmp( hBmp2, nWidth, nHeight )
               DeleteObject( hBmp2 )
            endif


            oClp     := TClipBoard():New( 2 )
            oClp:Open()
            oClp:Empty()
            SetClipboardData( 2, hBmp )
            oClp:Close()
            oSheet:Cells( nRow, nCol ):Select()
            oSheet:Paste()
            oClp:Clear()
            oClp:End()
         endif
         DeleteObject( hBmp )

      else
         if ValType( uVal ) $ 'DT'
            if ! Empty( uVal ) .and. Year( uVal ) < 1900
               uVal  := DToC( uVal )
            endif
         endif
         oSheet:Cells( nRow, nCol ):Value := uVal
      endif
   endif

return Self

//------------------------------------------------------------------//

METHOD Paste( cText ) CLASS TXBrwColumn

   local uNew, cType

   if ::cDataType $  'CM'
      if Eval( ::oBrw:bLock )
         ::Value     := Trim( cText )
      endif
   else
      uNew        := uCharToVal( cText, @cType )
      if uNew != nil
         if ::cDataType == nil .or. ::cDataType == cType
            if EVal( ::oBrw:bLock )
               ::Value  := uNew
            endif
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD WorkMergeData() CLASS TXBrwColumn

   local nKount   := 0
   local uPrev, uVal, nAt
   local nLen     := Eval( ::oBrw:bKeyCount )   //::oBrw:nLen is not yet initialized

   ::aMerge    := {}

   Eval( ::oBrw:bGoTop )   // note : ::oBrw:GoTop() does not work here
   for nAt  := 1 to nLen
      uVal  := ::Value()
      if uVal == nil
         msgStop( 'Column value is nil' )
         quit
      endif
      if uVal == uPrev
         nKount++
      else
         nKount  := 0
         uPrev := uVal
      endif
      AAdd( ::aMerge, { nKount, 0, ::oBrw:KeyNo() } )
      ::oBrw:Skip(1)
   next
   Eval( ::oBrw:bGoTop )

   nKount   := 0
   for nAt := nLen to 1 step -1
      ::aMerge[ nAt ][ 2 ] := nKount
      nKount++
      if ::aMerge[ nAt ][ 1 ] == 0
         nKount   := 0
      endif
   next


return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TXBrowse

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD HasBorder( nRowPos ) CLASS TXBrwColumn

   local lBorder     := .t.
   local nDataRows   := If( Empty( ::oBrw:nDataRows ), ::oBrw:RowCount(), ::oBrw:nDataRows )
   local nAt

   if ::lMergeVert .and. nRowPos < nDataRows
      nAt   := nRowPos - ::oBrw:nRowSel + ::oBrw:KeyNo() // ::oBrw:nArrayAt
      lBorder  := ( ::aMerge[ nAt ][ 2 ] == 0 )
   endif


return lBorder

//----------------------------------------------------------------------------//

METHOD MergeArea( nTop, nBottom, nRowPos ) CLASS TXBrwColumn

   local nAt, uVal, nRowOffset, nPos
   local aData
   local nFirstRow, nLastRow
   local n1, n2
   local nDataRows   := If( Empty( ::oBrw:nDataRows ), ::oBrw:Rowcount(), ::oBrw:nDataRows )
   if ::lMergeVert
      nAt         := ::oBrw:KeyNo()    // ::oBrw:nArrayAt
      n1          := Min( nRowPos - 1, ::aMerge[ nAt ][ 1 ] )
      n2          := Min( nDataRows - nRowPos, ::aMerge[ nAt ][ 2 ] )
      nTop        -= n1 * ::oBrw:nRowHeight
      nBottom     += n2 * ::oBrw:nRowHeight
   endif


return nTop

//----------------------------------------------------------------------------//

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

function EQ( uFirst, uSecond, lExact )

LOCAL   c

   DEFAULT lExact := .t.

   if ( C := valtype( uFirst ) ) == valtype( uSecond )
      if c == 'C'
         if lExact
            if Upper( AllTrim( uFirst ) ) == Upper( AllTrim( uSecond ) )
               return .t.
            endif
         else
            if Upper( AllTrim( uFirst ) ) = Upper( AllTrim( uSecond ) )
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

//----------------------------------------------------------------------------//

static function IfNil( u, u1, u2, u3 )

   if u == nil
      u  := u1
   endif

return If( u == nil, If( u1 == nil, If( u2 == nil, u3, u2 ), u1 ), u )

//----------------------------------------------------------------------------//

static function FontEsc( oFont )

   local nEsc := 0

   if oFont != nil .and. ValType( oFont:nEscapement ) == 'N'
      nEsc = Abs( oFont:nEscapement )
   endif

return nEsc

//----------------------------------------------------------------------------//

static function ClipTextAsArray( cText )

   local aText, n

   cText       := StrTran( cText, CRLF, Chr(10) )

#ifndef __XHARBOUR__
   if Right( cText, 1 ) == Chr(10)
      cText    := Left( cText, Len( cText ) - 1 )
   endif
#endif
   aText       := hb_aTokens( cText, Chr(10) )
   for n := 1 to Len( aText )
      aText[ n ]  := hb_aTokens( aText[ n ], Chr(9) )
   next


return aText

//----------------------------------------------------------------------------//

static function ArrayResize( aData, nSize )

   local aBlank   := {}
   local n

   if nSize < Len( aData )
      ASize( aData, nSize )
   elseif nSize > Len( aData )
      for n := 1 to Len( aData[ 1 ] )
         AAdd( aBlank, uValBlank( aData [ 1 ][ n ] ) )
      next n
      for n := Len( aData ) + 1 to nSize
         AAdd( aData, AClone( aBlank ) )
      next n
   endif

return aData

//----------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
// Support functions for Commands in xbrowse.ch
//----------------------------------------------------------------------------//

function XbrowseNew( oWnd, nRow, nCol, nWidth, nHeight,;
                     aFlds, aHeaders, aColSizes,  ;
                     bChange, bLDblClick, bRClick, ;
                     oFont, oCursor, nClrFore, nClrBack, ;
                     cMsg, lUpdate, cDataSrc, bWhen, ;
                     lDesign, bValid, lPixel, nResID, lAutoSort, lAddCols, ;
                     aPics, aCols, aJust, aSort, lFooter, lFastEdit, ;
                     lCell, lLines, aRows, uBack, cBckMode, bClass )

   local oBrw, n, i, oCol

   // This function is intended only to support command syntax
   // and not to be used directly in application program

   if ValType( bClass ) == 'B'
      oBrw         := Eval( bClass ):New( oWnd )
   else
      oBrw         := TXBrows():New( oWnd )
   endif

   oBrw:lAutoSort  := lAutoSort
   oBrw:bLDblClick := bLDblClick
   oBrw:bRClicked  := bRClick

   aFlds          := CheckArray( aFlds )
   aHeaders       := CheckArray( aHeaders )
   aColSizes      := CheckArray( aColSizes )
   aPics          := CheckArray( aPics )
   aCols          := CheckArray( aCols )
   aJust          := CheckArray( aJust )
   aSort          := CheckArray( aSort )

   XbrwSetDataSource( oBrw, cDataSrc, lAddCols, lAutoSort, aCols, aRows  )

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
         if aColSizes[ i ] != nil .and. aColSizes[ i ] < 0
            n              := -aColSizes[ i ]
            oCol:nDataLen  := Int( n )
            if n > oCol:nDataLen
               n           := Int( 10 * ( n - oCol:nDataLen ) )
               oCol:nDataDec  := n
            endif
         else
            oCol:nWidth    := aColSizes[ i ]
         endif
      endif
      if Len( aSort ) >= i .and. ! Empty( aSort[ i ] )
         oCol:cSortOrder := aSort[ i ]
      endif
   next i

   if valtype( nClrFore ) == 'N'
      DEFAULT nClrBack  := CLR_WHITE
      oBrw:bClrStd      := {|| { nClrFore, nClrBack } }
      oBrw:SetColor( nClrFore, nClrBack )
   endif

   if ValType( uBack ) $ 'ACNO'
      if ValType( uBack ) == 'A'
         n     := If( ValType( cBckMode ) == 'C', ( cBckMode != 'HORIZONTAL' ), .t. )
      else
         n     := If( ValType( cBckMode ) == 'C', AScan( { 'TILED','STRETCH','FILL' }, cBckMode ), 0 )

         n     := If( n > 0, n - 1, nil )
      endif
      oBrw:SetBackGround( uBack, n )
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

   if ! Empty( aJust )
      oBrw:aJustify  := aJust
   endif

   oBrw:lFooter   := lFooter
   oBrw:lFastEdit := lFastEdit

   if lLines
      oBrw:nColDividerStyle         := LINESTYLE_BLACK
      oBrw:nRowDividerStyle         := LINESTYLE_BLACK
      oBrw:lColDividerComplete      := .T.
   endif

   if lCell
      oBrw:nMarqueeStyle            := MARQSTYLE_HIGHLCELL
   endif

   if ValType( nResID ) == 'N'
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


return oBrw

//--------------------------------------------------------------------------//

static function CheckArray( aArray )

   if ValType( aArray ) == 'A' .and. ;
      Len( aArray ) == 1 .and. ;
      ValType( aArray[ 1 ] ) == 'A'

      aArray   := aArray[ 1 ]
   endif

return aArray

//----------------------------------------------------------------------------//

static function XbrwSetDataSource( oBrw, uDataSrc, lAddCols, lAutoSort, aCols, aRows  )

   local cType    := ValType( uDataSrc )

   if ! Empty( aCols )
      lAddCols    := .t.
   endif

   if cType == 'C'

      if Select( uDataSrc ) > 0
         oBrw:cAlias    := uDataSrc
         oBrw:nDataType := DATATYPE_RDD
         if lAddCols .or. ! Empty( aCols )
            oBrw:SetRDD( lAddCols, lAutoSort, aCols, aRows )
         elseif ! Empty( aRows )
            oBrw:SetRDD( .f., lAutoSort, nil, aRows )
         endif
      endif

   elseif cType == 'A'
      oBrw:nDataType    := DATATYPE_ARRAY
      oBrw:aArrayData   := uDataSrc
      if lAddCols .or. ! Empty( aCols )
         oBrw:SetArray( uDataSrc, lAutoSort, 1, aCols )
      else
         oBrw:SetArray( uDataSrc, nil, nil, .f. )
      endif


   elseif cType == 'H'
      oBrw:aArrayData   := uDataSrc
      oBrw:nDataType    := DATATYPE_ARRAY
      oBrw:SetArray( uDataSrc, nil, nil, lAddCols )


   elseif cType == 'O'

      if Upper( uDataSrc:ClassName ) == "TOLEAUTO"

         oBrw:nDataType := DATATYPE_ADO
         oBrw:oRs       := uDataSrc
         if lAddCols .or. ! Empty( aCols )
            oBrw:SetADO( uDataSrc, lAddCols, lAutoSort, aCols )
         endif

      elseif uDataSrc:IsKindOf( TLinkList() )
         oBrw:SetTree( uDataSrc, , , If( aCols == nil, lAddCols, aCols ) )
      elseif __ObjHasMethod( uDataSrc, "Skipper" )
         oBrw:SetoDbf( uDataSrc, aCols, lAutoSort, lAddCols, aRows )
      else
         oBrw:SetArray( aObjData( uDataSrc ), .f., nil, { 1, 2, 3 } )
         oBrw:aCols[ 1 ]:cHeader := 'Num'
         oBrw:aCols[ 2 ]:cHeader := 'Data'
         WITH OBJECT oBrw:aCols[ 3 ]
            :cHeader    := 'Value'
            :nEditType  := EDIT_GET
            :bEditWhen  := { || oBrw:aArrayData[ oBrw:nArrayAt, 4 ] }
            :bOnPostEdit:= { |o,x,n| If( n != VK_ESCAPE, ;
               ( OSend( uDataSrc, '_' + oBrw:aRow[ 2 ], x ),    ;
                 o:Value := OSend( uDataSrc, oBrw:aRow[ 2 ] ) ), ;
               nil ) }
         END
         oBrw:lFastEdit := .t.
      endif

   endif

return nil

//----------------------------------------------------------------------------//

static function aObjData( obj )

   local n, v, l, aData := AOData( obj )

   for n := 1 to Len( aData )
      TRY
         v  := OSend( obj, aData[ n ] )
         l  := .t.
      CATCH
         v  := '<protected>'
         l  := .f.
      END
      aData[ n ]  := Lower( Left( aData[ n ], 1 ) ) + ;
                     SubStr( aData[ n ], 2 , 1 ) + ;
                     Lower( SubStr( aData[ n ], 3 ) )
      aData[ n ]  := { n, aData[ n ], V, l }
   next n

return aData

//------------------------------------------------------------------//

function XbrJustify( oBrw, aJust )
return   ( oBrw:aJustify := aJust )

//--------------------------------------------------------------------------//

function xbrNumFormat( cIntl, lSep )

   local aPrevSet := { cNumFormat, lThouSep }

   if cIntl != nil .and. cIntl $ 'AEI'
      cNumFormat  := cIntl
   endif

   if ValType( lSep ) == 'L'
      lThouSep    := lSep
   endif

return aPrevSet

//----------------------------------------------------------------------------//

function TXBrows( bChild )

   if bXBrowse == nil
      bXBrowse    := { || TXBrowse() }
   endif

   if ValType( bChild ) == 'B' .and. ; // retained for backward compatibility
      ValType( Eval( bChild ) ) == 'O' .and. ;
      Eval( bChild ):IsKindOf( TXBrowse() )

      bXBrowse    := bChild
   endif


return Eval( bXBrowse )

//----------------------------------------------------------------------------//

function SetXBrowse( bChild )

   local bPrev

   if bXBrowse == nil
      bXBrowse    := { || TXBrowse() }
   endif

   bPrev          := bXBrowse

   if ValType( bChild ) == 'B' .and. ;
      ValType( Eval( bChild ) ) == 'O' .and. ;
      Eval( bChild ):IsKindOf( TXBrowse() )

      bXBrowse    := bChild
   endif


return bPrev

//------------------------------------------------------------------//

CLASS TXbrRow STATIC

   DATA oBrw

   DATA nRecNo, ;
        nKeyNo

   DATA aHeaders
   DATA aOriginals
   DATA aValues
   DATA bSave

   METHOD New( oBrw, nRecNo, nKeyNo, aHeaders, aValues )
   METHOD Save
   METHOD Undo INLINE ACopy( ::aOriginals, ::aValues )
   METHOD Modified()

   ERROR HANDLER onError

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oBrw, nRecNo, nKeyNo, aHeaders, aValues ) CLASS TXBrRow

   ::oBrw      := oBrw
   ::nRecNo    := nRecNo
   ::nKeyNo    := nKeyNo
   ::aHeaders  := AClone( aHeaders )
   ::aValues   := aValues
   ::aOriginals:= AClone( aValues )
return Self

//----------------------------------------------------------------------------//

METHOD Save() CLASS TXBrRow

   local lSaved   := .f.
   local uBm      := Eval( ::oBrw:bBookMark )
   local oCol, n

   Eval( ::oBrw:bBookMark )
   if ::oBrw:bLock == nil .or. Eval( ::oBrw:bLock )
      for n := 1 to Len( ::aHeaders )
         if ::aOriginals[ n ] != ::aValues[ n ]
            oCol     := ::oBrw:oCol( ::Headers[ n ] )
            if oCol:bOnPostEdit == nil
               if oCol:bEditValue != nil
                  Eval( oCol:bEditValue, ::aValues[ n ] )
               endif
            else
               Eval( oCol:bOnPostEdit, oCol, ::aValues[ n ], 13 )
            endif
         endif
      next n
      if ::bSave != nil
         Eval( ::bSave, Self )
      endif
      if ::oBrw:bUnlock != nil
         Eval( ::oBrw:bUnlock )
      endif
      if ::oBrw:bOnRowLeave != nil
         Eval( ::oBrw:bOnRowLeave )
      endif
      lSaved   := .t.
   endif
   if uBm == Eval( ::oBrw:bBookMark )
      ::oBrw:RefreshCurrent()
   else
      Eval( ::oBrw:bBookMark, uBm )
      ::oBrw:Refresh()
   endif

return lSaved

//----------------------------------------------------------------------------//

METHOD Modified() CLASS TXBrRow

Return ( AScan( ::aValues, { |u,i| u != ::aOriginals[ i ] } ) > 0 )

//----------------------------------------------------------------------------//

METHOD OnError( uParam1 ) CLASS TXBrRow

   local cMsg   := __GetMessage()
   local nError := If( SubStr( cMsg, 1, 1 ) == "_", 1005, 1004 )
   local nCol
   local lAssign := .f.

   if Left( cMsg, 1 ) == '_'
      lAssign     := .t.
      nError      := 1005
      cMsg        := SubStr( cMsg, 2 )
   endif
   nCol           := AScan( ::aHeaders, { |c| Upper( c ) == Upper( cMsg ) } )

   if nCol > 0
      if lAssign
         ::aValues[ nCol ] := uParam1
      endif
      return ::aValues[ nCol ]
   endif

    _ClsSetError( _GenError( nError, ::ClassName(), cMsg ) )

return nil

//----------------------------------------------------------------------------//

static function SameDbfStruct( oBrw, cAlias )

   local aStr1, aStr2
   local lSame    := .t.

   if ! Empty( oBrw:cAlias ) .and. Select( oBrw:cAlias ) > 0
      aStr1    := ( oBrw:cAlias )->( dbStruct() )
      aStr2    := ( cAlias )->( dbStruct() )
      if Len( aStr1 ) == Len( aStr2 )

         lSame := ( AScan( aStr1, { |a,i| Upper( a[ 1 ] ) != Upper( aStr2[ i ][ 1 ] ) .or. ;
                   a[ 2 ] != aStr2[ i ][ 2 ] } ) == 0 )
      else
         lSame := .f.
      endif
   else
      lSame    := .f.
   endif

return lSame

//----------------------------------------------------------------------------//

static function SameAdoStruct( oBrw, oRs )

   local lSame    := .t.
   local n, nFlds, oFld

   nFlds := oBrw:oRs:Fields:Count()
   if nFlds == oRs:Fields:Count()
      for n := 0 to nFlds - 1
         if Upper( oBrw:oRs:Fields( n ):Name ) != Upper( oRs:Fields( n ):Name )
            lSame := .f.
            exit
         endif
         if Upper( oBrw:oRs:Fields( n ):Type ) != Upper( oRs:Fields( n ):Type )
            lSame := .f.
            exit
         endif
      next n
   else
      lSame    := .f.
   endif

return lSame

//----------------------------------------------------------------------------//

static function SameArrayStruct( oBrw, aNew )

   local lSame := .t.
   local n, nLen, aData

   aData    := oBrw:aArrayData
   if ValType( aData ) == ValType( aNew )
      if ValType( aData ) == 'A'
         if Len( aData ) > 0 .and. Len( aNew ) > 0
            if ValType( aData[ 1 ] ) == 'A' .and. ValType( aNew[ 1 ] ) == 'A'
               nLen  := Len( aData[ 1 ] )
               if nLen <= Len( aNew[ 1 ] )
                  lSame := ( AScan( aData[ 1 ], { |u,i| ValType( u ) != ;
                           ValType( aNew[ 1 ][ i ] ) }, 1, nLen ) == 0 )
               else
                  lSame := .f.
               endif
            endif
         else
            lSame    := .f.
         endif
      endif
   else
      lsame    := .f.
   endif
return lSame

//----------------------------------------------------------------------------//

function XBrowse( uData, cTitle, lAutoSort, bSetUp, aCols, bSelect, lExcel, lFastEdit )

   local oDlg, oBrw, oFont, nSaveSelect
   local nWd, nHt
   local cDbf, cAlias
   local lAddCols := Empty( aCols )

   DEFAULT  uData    := Alias(), ;
            cTitle   := If( ValType( uData ) == 'C', uData, ;
                        If( ValType( uData ) == 'O', uData:ClassName(), ;
                        'XBROWSE' ) ), ;
            lAutoSort:= .f., ;
            bSetUp   := { || nil },;
            lExcel   := .t.

   if WndMain() == nil
      DEFINE FONT oFont NAME 'TAHOMA' ;
         SIZE 0,-Max( 8, Int( GetSysMetrics(0) / 100 ) )
   else
      oFont := WndMain():oFont
   endif

   nWd      := GetSysMetrics(0) * .75
   nHt      := GetSysMetrics(1) / 2

   if ValType( uData ) == 'C' .and. Select( uData ) == 0
      cDbf           := uData
      cAlias         := cGetNewAlias( Left( cFileNoExt( uData ), 4 ) )
      nSaveSelect    := SELECT()
      TRY
         dbUseArea( .t., nil, cDbf, cAlias, .t. )
         uData    := cAlias
      CATCH
         uData       := { { uData } }
      END
   endif

   if ValType( uData ) == 'N'
      if ! Empty( Alias( uData ) )
         uData          := Alias( uData )
      else
         uData           := {{ uData }}
      endif
   endif

   if ValType( uData ) $ 'BDLP'
      uData            := {{ uData }}
   endif

   DEFINE DIALOG oDlg SIZE nWd,nHt PIXEL ;
      TITLE cTitle FONT oFont

   nWd      /= 2
   nHt      /= 2

   oBrw                 := TXBrows():New( oDlg )
   WITH OBJECT oBrw

      :nTop                   := 10
      :nLeft                  := 10
      :nBottom                := :nTop + nHt - 30 - ;
                                 If( ValType( bSelect ) == 'B', 14, 0 )
      :nRight                 := :nLeft + nWd - 20
      :nMarqueeStyle          := MARQSTYLE_HIGHLCELL
      :nRowDividerStyle       := ;
      :nColDividerStyle       := LINESTYLE_BLACK
      :lColDividerComplete    := .t.

   END

   aCols                      := CheckArray( aCols )

   XBrwSetDataSource( oBrw, uData, lAddCols, lAutoSort, aCols  )

   if lFastEdit == .t.
      oBrw:lFastEdit := .t.
      AEval( oBrw:aCols, { |o| o:nEditType := 1 } )
   endif



   @ nHt-15, 10 BUTTON 'Print' SIZE 35,11 PIXEL OF oDlg ;
      ACTION oBrw:Report()

   @ nHt-15, 48 BUTTON if( lExcel, 'Excel', 'Calc' ) SIZE 35,11 PIXEL OF oDlg ;
      ACTION ( if ( lExcel, oBrw:ToExcel(), oBrw:ToCalc() ) )

   if ValType( bSelect ) == 'B'
      @ nHt-15,nWd-83 BUTTON 'Select' SIZE 35,11 PIXEL OF oDlg ;
         ACTION ( Eval( bSelect, oBrw, oBrw:SelectedCol() ), oDlg:End() )
      oBrw:bKeyChar  := { |n| If( n == 13, ;
            (Eval( bSelect, oBrw, oBrw:SelectedCol() ), oDlg:End()),)}
   endif

   @ nHt-15,nWd-45 BUTTON 'Close' SIZE 35,11 PIXEL OF oDlg ;
      ACTION oDlg:End()

   AEval( oDlg:aControls, { |o| o:nStyle -= WS_TABSTOP } )


   Eval( bSetUp, oBrw )

   if ValType( bSelect ) == 'B'
      @ nHt - 28, 10 say 'Search For :' size 30,10 pixel of oDlg
      @ nHt - 28, 45 say oBrw:oSeek prompt oBrw:cSeek ;
         size nWd-115,10 pixel update of oDlg ;
         color CLR_RED,CLR_YELLOW
      @ nHt - 28,nWd - 60 checkbox oBrw:lSeekWild prompt 'WildSeek' ;
         size 50, 10 pixel of oDlg ;
         on change ( oBrw:Seek( oBrw:cSeek ), oBrw:SetFocus() )
   endif

   oBrw:CreateFromCode()

   ACTIVATE DIALOG oDlg ;
      ON INIT FitSizes( oBrw )

   if WndMain() == nil
      RELEASE FONT oFont
   endif

   if ! Empty( cAlias )
      ( cAlias )->( dbCloseArea() )
   endif

   if ! Empty( nSaveSelect )
      SELECT( nSaveSelect )
   endif


return nil

//----------------------------------------------------------------------------//

static function FitSizes( oBrw )

   local nColsWidth  := oBrw:GetDisplayColsWidth() + 24

   if oBrw:nWidth > nColsWidth
      oBrw:nWidth       := nColsWidth
      oBrw:oWnd:nWidth  := Max( 340, oBrw:nWidth + 40 )
      oBrw:nWidth       := Max( oBrw:nWidth, oBrw:oWnd:nWidth - 40 )
      oBrw:nStretchCol  := STRETCHCOL_LAST
      oBrw:oWnd:aControls[ Len( oBrw:oWnd:aControls ) - 1 ]:nLeft := ;
               oBrw:oWnd:nWidth - 90
      if Upper( oBrw:oWnd:aControls[ Len( oBrw:oWnd:aControls ) - 2 ]:cCaption ) == 'SELECT'
         oBrw:oWnd:aControls[ Len( oBrw:oWnd:aControls ) - 2 ]:nLeft := ;
                  oBrw:oWnd:nWidth - 166
      endif

   endif
   oBrw:oWnd:Center()
   oBrw:SetFocus()

return .f.

//----------------------------------------------------------------------------//

function PalBmpFree( hBmp, hPal )

   DeleteObject( hBmp )
   DeleteObject( hPal )

return nil

//------------------------------------------------------------------//

function ContrastColor( hDC, nCol, nRow, nWidth, nHeight, nDefClr )

   local nClr, nLuma, nLuma0, nContrast, n, k

   DEFAULT nDefClr  := CLR_BLACK
   nContrast        := nDefClr

   nRow     += Int( nHeight / 2 )
   nLuma    := 0
   k        := 0
   for n    := Int( nCol ) + 10 to nCol + nWidth step 10
      nClr  := GetPixel( hDC, n, nRow )
      nLuma += ( 0.299 * nRGBRed( nClr ) + 0.587 * nRGBGreen( nClr ) + 0.114 * nRGBBlue( nClr ) )
      k++
   next

   if k > 0
      nLuma /= k
      nLuma0   := 0.299 * nRGBRed( nDefClr ) + 0.587 * nRGBGreen( nDefClr ) + 0.114 * nRGBBlue( nDefClr )
      if Abs( nLuma - nLuma0 ) < 150
         nContrast   := If( nLuma < 150, CLR_WHITE, CLR_BLACK )
      endif
   endif


return nContrast

//------------------------------------------------------------------//

static function GradientBrush( oBrw, aColors , lVert )

   local hDC, hBmp, hBmpOld , nWidth , nHeight, aRect

   default lVert := .t.


   if ! Empty( oBrw:oBrush:hBitmap )
      deleteobject( oBrw:oBrush:hBitmap )
   endif

   aRect   = oBrw:DataRect()
   nHeight = If( lVert, aRect[ 3 ] - aRect[ 1 ], 1 )
   nWidth  = if( lVert, 1, aRect[ 4 ] - aRect[ 2 ] )

   hDC = CreateCompatibleDC( oBrw:GetDC() )
   hBmp = CreateCompatibleBitMap( oBrw:hDC, nWidth, nHeight )
   hBmpOld = SelectObject( hDC, hBmp )
   GradientFill( hDC, 0, 0, nHeight, nWidth, aColors,lVert )

   DeleteObject( oBrw:oBrush:hBrush )
   oBrw:oBrush:hBitmap = hBmp
   oBrw:oBrush:hBrush = CreatePatternBrush( hBmp )
   SelectObject( hDC, hBmpOld )

   oBrw:ReleaseDC()

return nil

//------------------------------------------------------------------//

Function clp2xlnumpic( cPic )

   local cFormat, aPic, c, lEnglish := lxlEnglish

   if cPic == nil
      cFormat  := If( lThouSep, If( lEnglish, "#,##0", "#.##0" ), "0" )
   else
      cPic     := StrTran( cPic, "#", "9" )
      aPic     := HB_ATokens( cPic, " " )

      cFormat  := ""
      for each c in aPic
         if Left( c, 1 ) == "@"
/*
            if 'E' $ c
               lEnglish := .f.
            endif
*/
         else
            if "9" $ c
               if Left( c, 1 ) == '$'
                  cFormat  += '$'
               endif
               cFormat  += If( lThouSep .or. ",9" $ cPic, If( lEnglish, "#,##0", "#.##0" ), "0" )
               if ".9" $ c
                  cFormat  += If( lEnglish, ".", "," )
                  cFormat  += StrTran( SubStr( c, At( ".", c ) + 1 ), "9", "0" )

               endif
               cFormat  += " "
            else
               cFormat  += ( '"' + c + '" ' )
            endif
         endif
      next
   endif

return Trim( cFormat )

//------------------------------------------------------------------//

Function SetKinetic( lOnOff )

   local lOldStatus

   static lStatus := .t.

   lOldStatus     := lStatus

   if PCount() == 1 .and. ValType( lOnOff ) == "L"
      lStatus     := lOnOff
   endif

Return lOldStatus

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

//----------------------------------------------------------------------------//

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

//----------------------------------------------------------------------------//

#pragma ENDDUMP

//--------------------------------------------------------------------------//