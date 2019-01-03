#include "FiveWin.ch"
#include "InKey.ch"
#include "constant.ch"
#include "wcolors.ch"
#include "xbrowse.ch"
#include "Report.ch"
#include "dtpicker.ch"
#include "dbinfo.ch"
#include "adodef.ch"

#xtranslate MinMax( <xValue>, <nMin>, <nMax> ) => ;
   Min( Max( <xValue>, <nMin> ), <nMax> )

#ifdef __HARBOUR__
   #ifndef __XHARBOUR__
      #xtranslate DbSkipper => __DbSkipper
   #endif
#endif

#define SRCCOPY      0x00CC0020

#define GWL_STYLE             -16
#define GWL_EXSTYLE           -20   // 2009-11-11

#define GW_HWNDFIRST            0
#define GW_HWNDNEXT             2

#define SM_CYVSCROLL            20
#define SM_CYHSCROLL             3

#define CS_DBLCLKS              8

#define NULL_BRUSH    5
#define HOLLOW_BRUSH  NULL_BRUSH

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

#define MK_SHIFT            0x0004
#define MK_CONTROL          0x0008
#define MK_MBUTTON          0x0010

#define LB_SETITEMHEIGHT        0x01A0
#define LB_GETITEMHEIGHT        0x01A1

#define COL_EXTRAWIDTH        6
#define ROW_EXTRAHEIGHT       4
#define COL_SEPARATOR         2
#define BMP_EXTRAWIDTH        5

#define RECORDSELECTOR_WIDTH 25

#define BITMAP_HANDLE         1
#define BITMAP_PALETTE        2
#define BITMAP_WIDTH          3
#define BITMAP_HEIGHT         4
#define BITMAP_ALPHA          5

#define VSCROLL_MAXVALUE      10000  // never set values above 32767

#define TME_LEAVE             2
#define WM_MOUSELEAVE       675
#define PM_REMOVE        0x0001

#define CB_SETITEMHEIGHT            0x0153

#ifdef __XHARBOUR__
   #xtranslate hb_hKeyAt( <h>, <n> )     => hGetKeyAt( <h>, <n> )
   #xtranslate hb_hValueAt( <h>, <n>, <x> )   => hSetValueAt( <h>, <n>, <x> )
   #xtranslate hb_hValueAt( <h>, <n> )   => hGetValueAt( <h>, <n> )
   #xtranslate hb_HHasKey( [<x,...>] )         => HHasKey( <x> )
   #xtranslate hb_HSetCaseMatch( [<x,...>] )   => HSetCaseMatch( <x> )
   #xtranslate hb_HSetAutoAdd( [<x,...>] )     => HSetAutoAdd( <x> )
   #xtranslate hb_WildMatch( <a>, <b> [, <c> ] ) => WildMatch( <a>, <b> [, <c> ] )
   #xtranslate HB_STRTOHEX( <c> ) => STRTOHEX( <c> )
   #xtranslate HB_HEXTOSTR( <c> ) => HEXTOSTR( <c> )
   #xtranslate HB_CToT( <c> )     => CToT( <c> )
   #xtranslate HB_TToS( <t> )     => TToS( <t> )
#endif

/*
// this is included in fivewin.ch
#ifndef __XHARBOUR__
   #xtranslate \<|[<x,...>]| => {|<x>|
   #xcommand > [<*x*>]       => } <x>
#endif
*/

//------------------------------------------------------------------------------

static lExcelInstl, lCalcInstl
static nxlLangID, cxlTrue := "=(1=1)", cxlFalse := "=(1=0)", cxlSum, lxlEnglish := .f., hLib
static lLocked := .f.

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
        cSeek ;      // string that hold the current string searched (for autoincremental seek)
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

   DATA nHeaderPad   INIT 0 // pixels padded to header height and footer height
   DATA nFooterPad   INIT 0 // to fit the datarows without gap
   DATA nGetBarHeight

   DATA nRowDividerStyle,; // Row divider style
        nColDividerStyle ; // Col divider style
        AS NUMERIC         // O LINESTYLE_NOLINES
                           // 1 LINESTYLE_BLACK
                           // 2 LINESTYLE_DARKGRAY
                           // 3 LINESTYLE_FORECOLOR
                           // 4 LINESTYLE_LIGHTGRAY
                           // 5 LINESTYLE_INSET
                           // 6 LINESTYLE_RAISED

   DATA  nHeadDividerStyle // init value should be NIL

      /* nHeadDividerStyle: DEFAULT nil. Limited impementation from 16.04
         Applies to both Header and Footer
         Applies only to FlatStyle and used only when set to LINESTYLE_NONE
         If both HeadDividerStyle and ColDivderStyle are 0, no vertical lines are drawn
         If both HeadDividerStyle and RowDivderStyle are 0, no Horgiz lines are drawn
      */

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

   DATA nRecSelWidth INIT RECORDSELECTOR_WIDTH   // FWH 11.06

   // RecSel Painting Data
   DATA bRecSelData, bRecSelFooter, bRecSelHeader, oRecSelFont, nRecSelHeadBmpNo, bRecSelClick

   DATA hBtnShadowPen,; // Pen handle for shadow buttons color (used internally)
        hWhitePen,;     // Pen handle for white color (used internally)
        hColPen,;       // Pen for column lines (used internally)
        hRowPen,;       // Pen for row lines (used internally)
        hBmpRecSel,;    // Bitmap Handle for the record selector triangle (used internally)
        hBrushRecSel    // Brush Handle for the record selector (used internally)

   DATA lCreated,;            // True when control is completaly created (used internally)
        lAdjusted,;           // True when Adjust method is completed (used internally)
        lPainted,;            // True if Paint() method is executed atleast once.
        lRecordSelector,;     // if true a record selector column is displayed
        lHScroll,;            // Horizontal Scrollbar, it should be assigned before the createfrom..() method
        lVScroll,;            // Vertical Scrollbar, it should be assigned before the createfrom..() method
        lAllowRowSizing,;     // If true horizontal row sizing is allowed
        lAllowColSwapping,;   // If true col swapping is allowed
        lAllowColHiding,;     // If true col hiding is allowed
        lColDividerComplete,; // If true the vertical lines are displayed to the bottom of the browse even
        ;                     // there are not enough data rows
        lRowDividerComplete,; //
        lGradientComplete,;
        lFullGrid,;           // Draw full horiz and vert lines even if not all rows have data
        lFastEdit, ;          // Go to edit mode just pushing a alpha or digit char on a editable column
        ;                     // (incompatible with incremental seek and highlite row)
        lEditMode,;           // Some column is in edit mode (used internally)
        lEdit,;
        lRefreshOnlyData ;    // True when only the data should be painted (used internally)
        AS LOGICAL

   DATA lFullPaint AS LOGICAL INIT .f.
   DATA lFastDraw AS LOGICAL INIT .f. // User to Set .t. for no-frill browse
   DATA nRefreshSecs READONLY INIT 0
   DATA nSaveSecs    INIT 0
   DATA nSortSecs    INIT 0

   DATA nBarHdr   INIT 0 PROTECTED
   ACCESS lSeekBar INLINE ::nBarHdr == 2
   ASSIGN lSeekBar( lOnOff ) INLINE If( ValType( lOnOff ) == 'L', ::nBarHdr := If( lOnOff, 2, 0 ), nil )
   ACCESS lGetBar INLINE ::nBarHdr == 1
   ASSIGN lGetBar( lOnOff ) INLINE If( ValType( lOnOff ) == 'L', ::nBarHdr := If( lOnOff, 1, 0 ), nil )
   DATA hRightCol

   // Datas for Styles, eg: 2007, flat, etc
   DATA n2KStyle           INIT 2007
   ACCESS l2007            INLINE ( ::n2KStyle == 2007 )
   ASSIGN l2007( l )       INLINE If( l, ::n2KStyle := 2007, If( ::n2KStyle == 2007, ::n2KStyle := 0, nil ) )
   ACCESS lFlatStyle       INLINE ( ::n2KStyle == -1 )
   ASSIGN lFlatStyle( l )  INLINE If( l, ::n2KStyle := -1, If( ::n2KStyle == -1, ::n2KStyle := 0, nil ) )
   ACCESS l2000        INLINE ( ::n2KStyle >= 2007 )

   // Datas for Multiselect
   DATA   hMultiSelect  PROTECTED  // nil or logical
   ACCESS lMultiSelect  INLINE IfNil( ::hMultiSelect, ( ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS .or. ;
                                                        ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7 ) )
   ASSIGN lMultiSelect( lSet ) INLINE ( ::hMultiSelect := lSet )
   DATA   bOnMultiSelect
   DATA   bChangeInternal      // Internally used by FWH libs. Not to be used by programmers

   // Datas for Excel Compatibility
   DATA lFormulaEdit    AS LOGICAL INIT .f.  // If .t. enables entry of formula starting with '=' for numerics
   DATA lEnterKey2Edit  AS LOGICAL INIT .t.
   DATA lF2KeyToEdit    AS LOGICAL INIT .f.
   DATA lFreezeLikeExcel AS LOGICAL INIT .f.
   DATA lTabLikeExcel   AS LOGICAL INIT .f.

   // Data for Incremental Seeks/Filters
   DATA lSeekWild       AS LOGICAL INIT .f.
   DATA lIncrFilter     AS LOGICAL INIT .f.
   DATA bFilterExp
   DATA cFilterFld
   DATA oFilterCol
   // end of block

   DATA lLockFreeze     AS LOGICAL INIT .f.
   DATA lScreenUpdating AS LOGICAL INIT .t.
   DATA hScrnBmp

   // Data for SQLRDD compatibility
   DATA lSqlRDD      INIT .f.
   DATA nSqlRddMode  AS NUMERIC INIT 0 READONLY
   // eo:sqlrdd
   DATA lRelyOnKeyNo AS LOGICAL INIT .t.
   DATA lVThumbTrack    AS LOGICAL INIT .f. // When .t., thumbtrack scrolls the browse. (not suited for slow data access)
   DATA lColChangeNotify   AS LOGICAL INIT .f. // if true bChange is evaluated when col is changed
   DATA lAutoSort       AS LOGICAL INIT .f.  // used internally. do not use in applications
   DATA lSortDescend    AS LOGICAL INIT .t.
   DATA lAllowCopy      AS LOGICAL INIT .t.
   DATA lCanPaste       AS LOGICAL INIT .f.
   DATA lExcelCellWise  AS LOGICAL INIT .f.
   DATA lMergeVert      AS LOGICAL INIT .f.  // used internally
   DATA lExitGetOnTypeOut AS LOGICAL INIT .f.
   DATA lOemAnsi        AS LOGICAL INIT .f.  // When .t. SetRDD() method creates codeblock to convert oem/ansi for bEditValue.
   DATA lFitGridHeight  AS LOGICAL INIT .f.
   DATA lHoverSelect    AS LOGICAL INIT .f.
   DATA lLimitChars     AS LOGICAL INIT .f.  // Unicode edit mode in MySql/MsSql

   DATA lAutoAppend AS LOGICAL INIT .t. // AutoAppend

   DATA lHeader,;  // Browse has header, if this value is nil then is initialized automatically on the Adjust method
        lFooter,;  // Browse has footer, if this value is nil then is initialized automatically on the Adjust method
        lGrpHeader // Browse has Group Header
   DATA lAllowColReGroup INIT .f.
   DATA lDisplayZeros  // init nil

   DATA nSaveMarq    // used internally
   // ADO
   DATA oRS          // ADO recordset if Method SetAdo() is used
   DATA lRsCanResync INIT .f.                              // Internally used for ADO Browses
   DATA lAdoOverRideConflicts AS LOGICAL INIT .t.  // Can be modified by programmer
   //
   DATA oMysql       // TMySQL recordset if Method Setmysql() is used
   DATA oTree, oTreeItem  // Do not set them directly, instead use SetTree method. Can be accessed
   DATA oColToolTip     // Used internally
   DATA nRowToolTip     // Used Internally
   DATA bOnRowLeave
   DATA bOnSkip         INIT { || nil }
   DATA lEdited         INIT .f.
   DATA bLock           INIT { || .t. }
   DATA bUnLock         INIT { || nil }
   DATA bSaveData       INIT { || .t. }
   DATA bDelete, bEdit, bDataRow
   DATA aStretchInfo    // Internal use only
   DATA nStretchCol
   DATA bOnSwapCol
   DATA nRightMargin
   DATA nBottomMargin
   DATA bOnRefresh
   DATA bToExcel
   DATA abOnAdjust       INIT Array( 0 ) PROTECTED // Actions immediatly after Adjust()

   // Earlier Group Header related DATA. Now Obsolete
   DATA aHeaderTop,; // Array of header string Top
          nHeader

   DATA lContrastClr INIT .t.
   DATA lReadOnly       AS LOGICAL INIT .f.
   DATA lGDIP AS LOGICAL INIT ( .not. ISXHBCOM() )
   DATA lDrawBorder      INIT .f.

   // DATAS used for Kinetic scrolling
   DATA nStartMRow,;
        nEndMRow,;
        nRowAdvance,;
        nColAdvance,;
        nStartTime,;
        nEllapsed

   DATA lDown INIT   .t.
   DATA lPressed INIT.f.
   DATA lMoved PROTECTED INIT .f.
   DATA nStopRatio       AS NUMERIC INIT 4
   DATA nMaxRowToAdvance AS NUMERIC INIT 40
   DATA nMinVelocity     AS NUMERIC INIT 50
   DATA lDrawSelected    AS LOGICAL INIT .T.
   DATA hCursorHand

   DATA lKineticBrw      AS LOGICAL INIT .T.
   // End of Datas used for Kinetic Scrolling ( used Internally )

   DATA oSortCol
   DATA uSortVal
   DATA aSumCols INIT Array( 0 )       // Array of all columns to be totaled. Used internally
   DATA aSumSave                    // Array with previous val/totals for recalc totals
   DATA aBitmaps INIT Array( 0 )
   DATA nSizePen INIT 1
   DATA nColorPen INIT CLR_BLACK
   DATA nColorBox INIT CLR_BLACK  // nRGB Color or hPen or CodeBlock eval with Col object returning nClr/hPen
   DATA bPaintRow       INIT { || .t. }
   DATA bPaintHeader, bPaintFooter

   DATA oClp      // clipboard

   DATA hCargo PROTECTED
   //
   CLASSDATA oActive
   CLASSDATA lKinetic         AS LOGICAL INIT SetKinetic()
   CLASSDATA lInheritStyle    AS LOGICAL INIT .f.
   CLASSDATA lRegistered      AS LOGICAL // used internally
   //
   METHOD New( oWnd )
   METHOD Destroy()
   METHOD SetStyle( nStyle )
   METHOD SetRecSelBmp()
   METHOD SetRightFreeze( oCol )
   ACCESS oRightCol     INLINE ::hRightCol
   ASSIGN oRightCol( oCol ) INLINE ::SetRightFreeze( oCol )

   METHOD nAt() INLINE ::colpos( ::SelectedCol() )

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD cGenPrg()

   METHOD SetRDD( lAddColumns, lAutoSort, aFldNames, aRows )
   METHOD SetArray( aData, lAutoSort, nColOrder, aCols, bOnSkip )
   METHOD SetoDbf( oDbf, aCols, lAutoSort, lAutoCols, aRows )
   METHOD SetExcelRange( oRange, lHeaders, aCols )
   METHOD SetAdo( oRs, lAddCols, lAutoOrder, aFldNames ) // ADO object
   METHOD SetTree( oTree, aResource, bOnSkip, aCols )
   METHOD SetColsForTree( uData )
   METHOD InvertPivot()
   METHOD ArrCalcWidths( aData, aCols, nMaxRows )

   METHOD GetColsData( cData, lByCreationOrder )
   METHOD SetColsData( cData, aValues, lByCreationOrder )

   METHOD SetGroupHeader( cGrpHdr, nFrom, nUpto, oFont, nAlign )
   METHOD SetGroupTotal( aCols, cHead, nType, oFont )
   METHOD ClearBlocks()
   METHOD SetColFromADO( cnCol, lAutoOrder, aColNames, l1900 )  // Used internally
   METHOD ArrCell( nRow, nCol, cFmt )
   METHOD ArrCellSet( nRow, nCol, uNewVal )

   METHOD SetDolphin( oMysql, lAddCols, lAutoOrder, aFldNames )
   METHOD SetMySql( oMysql, lAddCols, lAutoOrder, aFldNames ) // TMySql object
   METHOD SetColFromMySQL( cnCol, cHeader )   // used internally from mysql
   METHOD SetPostGre( oQry, lAddCols, lAutoOrder, aFldNames )
   METHOD SetPostGreCol( nCol, oQry )

   METHOD aJustify( aJust ) SETGET  // only for compatibility with TWBrowse

   METHOD AddCol()
   METHOD InsCol( nPos )
   METHOD DelCol( nPos )
   METHOD AddColumn()  // See the method for parameters
   METHOD SwapCols( xCol1, xCol2, lRefresh )
   METHOD MoveCol( xFrom, xTo, lRefresh, lUser )
   METHOD ReArrangeCols( aSeq, lRetainRest )

   METHOD CreateFromCode()
   METHOD CreateFromResource( nId )

   METHOD SelectCol( nCol, lOffSet )
   METHOD GoToCol( oCol )
   METHOD GoLeft( lOffset, lRefresh )
   METHOD GoRight( lOffset, lRefresh )
   METHOD GoLeftMost()
   METHOD GoRightMost()
   METHOD GoFirstEditCol()

   METHOD GoUp( nLines )
   METHOD GoDown( nLines, nKey )
   METHOD PageUp( nLines )
   METHOD PageDown( nLines )
   METHOD GoTop()
   METHOD GoBottom()

   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD HandleGesture( nGesture, nLParam )
   METHOD GesturePan( aPanInfo )

   METHOD KeyCount() INLINE ( ::nLen := Eval( ::bKeyCount ),;
                              iif(::oVScroll != nil ,;
                                  ( ::VSetRange( 1, ::nLen ), ::VUpdatePos() ), ),;
                              ::nLen )

   ACCESS BookMark      INLINE Eval( ::bBookMark )
   ASSIGN BookMark(u)   INLINE ( Eval( ::bBookMark, u ), Eval( ::bBookMark ) )
   ACCESS KeyNo         INLINE Eval( ::bKeyNo, nil, Self )
   ASSIGN Keyno( n )    INLINE ( Eval( ::bKeyNo, n, Self ), Eval( ::bKeyNo, nil, Self ) )
   METHOD Skip( n )     INLINE Eval( ::bSkip, n )
   METHOD Bof()         INLINE Eval( ::bBof )
   METHOD Eof()         INLINE Eval( ::bEof )

   METHOD SaveState( aData )
   METHOD RestoreState( cInfo )
   METHOD OldRestoreState( cInfo )  // retained for comatibility 10.8 for another few versions

   METHOD Lock()        INLINE If( ::bLock == nil,  .t.,  Eval( ::bLock ) )
   METHOD UnLock()      INLINE ( If( ::bUnLock == nil, nil, Eval( ::bUnLock ) ), lLocked := .f. )
   METHOD SaveData( lRefresh ) INLINE If( ::bSaveData == nil, .t., Eval( ::bSaveData, Self, @lRefresh ) )

   METHOD ShowSeek( cSeek )
   METHOD Seek( cSeek )
   METHOD RddIncrSeek( cseek, uSeek )
   METHOD RddIncrFilter( cExpr, uSeek )
   METHOD ArrayIncrSeek( cSeek )
   METHOD ArrayIncrFilter( cSeek, nGoTo )
   METHOD AdoIncrSeek( cSeek )

   METHOD Select( nOperation ) // 0 -> Delete all
                               // 1 -> Add current key
                               // 2 -> Swap current key (Ctrl+lClick)
                               // 3 -> Tipical Shift with mouse
                               // 4 -> Select all

   METHOD SelectAll()  INLINE ::Select( 4 )
   METHOD SelectNone() INLINE ::Select( 0 )

   METHOD Adjust()
   METHOD AutoFit( aCols, nRowsOrlVisible, lDataOnly, nMaxWidth )
   METHOD CheckSize()
   METHOD Resize( nSizeType, nWidth, nHeight ) INLINE ( ::MakeBrush(), ::ColStretch(), ::Super:ReSize( nSizeType, nWidth, nHeight ), If( ::lAdjusted, ::Refresh(), ) )
   METHOD Change( lRow ) PROTECTED
   METHOD MakeTotals( aCols )
   METHOD SaveTotals( lBlank )
   METHOD ReCalcTotals( lReduce )
   METHOD Eval( bBlock, bFor, bWhile, nNext, nRec, lRest )
   METHOD Report( cTitle, lPreview, lModal, bSetUp, aGroupBy, cPDF )
   METHOD ToWord( bProgress, aCols, nWrdTblFormat, nPageOrientation )
   METHOD ToHTML( cHtml, lShow )
   METHOD ToCSV( cFile, aCols, lHeaders, cTrue, cFalse )
   METHOD ToExcel( bProgress, nGroupBy, aCols, lShow, cPDF, bPrePDF )
   METHOD ToCalc( bProgress, nGroupBy, nPasteMode, aSaveAs, aCols )
   METHOD ToDbf( cFile, bProgress, aCols, lPrompt )
   METHOD CurrentRow()
   //
   METHOD AddBitmap( uBmp, aResize ) INLINE fnAddBitmap( Self, uBmp, aResize )
   METHOD aBitmap( n )      INLINE ( n := Abs( IfNil( n, 0  ) ), If( n > 0 .and. n <= Len( ::aBitmaps ), ::aBitmaps[ n ], nil ) )

   // The rest of the methods are used internally

   METHOD Initiate( hDlg )
   METHOD Display()
   METHOD Paint()
   METHOD GetPaintCols( nLast )  // @nLast
   METHOD PaintHDivider( hDC, nRow, nLeft, nRight, nStyle, hRowPen, hWhitePen )
   METHOD PaintVDivider( hDC, nCol, nTop, nBottom, nStyle, hColPen, hWhitePen )
   METHOD PaintHeader( hDC, aCols, nLast, hWhitePen, hGrayPen, hColPen )
   METHOD PaintFooter( hDC, nGridWidth, nBrwHeight, hWhitePen, hGrayPen )

   METHOD Refresh( lComplete )
   METHOD CalcRowSelPos() PROTECTED // Used internally
   METHOD DelRePos()

   METHOD DrawLine( lSelected, nRowLine )

   METHOD FullPaint() INLINE ( ::lTransparent .or. ::lMergeVert .or. ::lFullPaint .or. ;
                               ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7 )

   METHOD GotFocus( hCtlFocus )  INLINE ( ::oActive := Self, ::Super:GotFocus( hCtlFocus ),;
                                          If( GetParent( hCtlFocus ) != ::hWnd, ::Super:Refresh( .f. ),) )
   METHOD LostFocus( hCtlFocus ) INLINE ( ::Super:LostFocus( hCtlFocus ),;
                                          If( GetParent( hCtlFocus ) != ::hWnd, ::Super:Refresh( .f. ), ) )

   METHOD GetDlgCode( nLastKey )
   METHOD HasBorder( lEx ) INLINE If( lEx == .t., ;
                                    lAnd( GetWindowLong( ::hWnd, GWL_EXSTYLE ), 0X200 ), ;
                                    lAnd( GetWindowLong( ::hWnd, GWL_STYLE ), WS_BORDER ) )

   METHOD LButtonDown( nRow, nCol, nKeyFlags, lTouch )
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
/*
   METHOD ColAtPos( nPos ) INLINE ::aCols[ ::aDisplay[ MinMax( If( nPos == nil .or. ;
                                  nPos == 0, 1, nPos ), 1, Len( ::aDisplay ) ) ] ]
*/

   METHOD ColAtPos( nPos )

   METHOD ColPos( oCol ) INLINE oCol:nPos
   METHOD SelectedCol() INLINE ::ColAtPos( ::nColSel )

   METHOD IsDisplayPosVisible( nPos, lComplete )
   METHOD LastDisplayPos()
/*
   // old code removed on 2009-11-11
   METHOD BrwWidth()     INLINE ( ::nWidth - iif( ::lVScroll , GetSysMetrics( SM_CYVSCROLL ), 0 ) )
   METHOD BrwHeight()    INLINE ( ::nHeight - 2 - iif( ::lHScroll, GetSysMetrics( SM_CYHSCROLL ), 0 ) )
   // revised accurate method
   METHOD BrwWidth()     INLINE ( ::nWidth -  If( ::HasBorder(), 2, If( ::HasBorder( .t. ), 4, 0 ) ) - iif( ::lVScroll, GetSysMetrics( SM_CYVSCROLL ), 0 ) )
   METHOD BrwHeight()    INLINE ( ::nHeight - If( ::HasBorder(), 2, If( ::HasBorder( .t. ), 4, 0 ) ) - iif( ::lHScroll, GetSysMetrics( SM_CYHSCROLL ), 0 ) )
*/

   METHOD BrwWidth()     INLINE  GetClientRect( ::hWnd )[ 4 ]
   METHOD GridWidth()    INLINE ::BrwWidth() - If( ::hRightCol == nil, 0, ::hRightCol:nWidth + 2 )
   METHOD BrwHeight()    INLINE GetClientRect( ::hWnd )[ 3 ]

   METHOD HeaderHeight( lFull ) INLINE If( ::lHeader, IfNil( ::nHeaderHeight, 0 ) + ;
                                       If( lFull == .t. .and. ::nBarHdr > 0, IfNil( ::nGetBarHeight, 0 ), 0 ), ;
                                       If( ::lDrawBorder, 1, 0 ) )

   METHOD FooterHeight() INLINE If( ::lFooter .and. ::nFooterHeight != nil, ::nFooterHeight, 0 )
   METHOD CalcHdrHeight()
   METHOD RowCount()     INLINE ( If( ::nRowHeight == nil, ::Adjust(),), Int( ( ::BrwHeight() - ::FirstRow() - ::FooterHeight() ) / ::nRowHeight ) )
//   METHOD FirstRow()     INLINE ::HeaderHeight() + If( ::nBarHdr > 0, IfNil( ::nGetBarHeight, 0 ), 0 )
   METHOD FirstRow()     INLINE ::HeaderHeight( .t. )
   METHOD LastRow()      INLINE ::BrwHeight() - ::FooterHeight() - ::nRowHeight + 1
   METHOD FooterRow()    INLINE ::BrwHeight() - ::FooterHeight() + 1
   METHOD DataHeight()   INLINE ::nRowHeight - iif(::nRowDividerStyle > LINESTYLE_NOLINES, 1, 0) - ;
                                If(::nRowDividerStyle >= LINESTYLE_INSET, 1, 0)
   METHOD BrwFitSize( lReSize ) // -> { nReqdWidth, nReqdHt }. If lResize is .t. resizes browse
   METHOD CancelEdit()
   METHOD SetColumns()

   METHOD GoNextCtrl()
   METHOD GoPrevCtrl() VIRTUAL

   METHOD SelFont()
   METHOD SetFont( oFont, lResizeCols )
   METHOD FontSize( nPlus )
   METHOD ReCalcWH() PROTECTED
   //
   METHOD DrawSelect()        INLINE ::DrawLine( .t. )
   METHOD RefreshCurrent()    //INLINE ::DrawLine( .t. )
   METHOD aRow                INLINE ( ::aArrayData[ ::nArrayAt ] )  // to make the coding easy
   METHOD oCol( cHeader )
   METHOD RefreshHeaders()    INLINE ( ::PaintHeader( ::GetDC() ), ::ReleaseDC() )
   METHOD RefreshFooters()    INLINE If( Empty( ::nFooterHeight ),,AEval( ::aCols, { | oCol | oCol:RefreshFooter() } ) )
   METHOD ClpRow()
   METHOD Copy()
   METHOD Paste( cText )
   METHOD aCellCoor( nRow, nCol ) // --> { nTop, nLeft, nBottom, nRight } in pixels for cell at nVisibleRow, nVisibleCol
   METHOD CellBitmap( nRow, nCol )
   METHOD ShowMessage( cMsg, nSecs, nClrText, nClrBack )
   METHOD SetPos( nRow, nCol, lPixel, bAction )

   METHOD SetBackGround( uBack, nBckMode ) // call with no paratmer to clear background
   METHOD MakeBrush()
   METHOD DataRect()
   METHOD cBmpAdjBrush( cImage ) SETGET // Obsolete SETGET method created for compatibility
   METHOD ColStretch( nStretchCol ) // used internally
   // tooltip support
   METHOD DestroyToolTip()
   METHOD NcMouseMove( nHitTestCode, nRow, nCol )
   METHOD MouseLeave()

   ACCESS uDataSource   INLINE IfNil( ::oDbf, ::oRs, ::oMySql, ::oTree, ::cAlias, ::aArrayData )
   METHOD DataRow( lNew, cFieldList, lSourceData )
   METHOD EditSource( lNew, cFieldList, lNavigate ) INLINE ::Edit( lNew, cFieldList, .t., lNavigate )
   METHOD EditBrowse( lNew, cFieldList, lNavigate ) INLINE ::Edit( lNEw, cFieldList, .f., lNavigate )
   METHOD Edit( lNew, cFieldList, lSourceData, lNavigate )
   METHOD Delete()         INLINE If( ::lReadOnly .or. ::nLen < 1 .or. ::bDelete == nil, nil, ;
                                    ( ::SaveTotals(), Eval( ::bDelete, Self ), ;
                                      ::ReCalcTotals( .t. ), ;
                                      ::Refresh(), ::Change( .t. ), ::SetFocus() ) )
   METHOD SetChecks( aBmp, lEdit, aPrompt )
   METHOD AddVar( uKey, uVal ) INLINE ::hCargo[ uKey ] := uVal
   //
   ACCESS lPasteReady   INLINE ( GetClipContentFormat( 13, 1, 2, 15 ) > 0 )
   //
   ERROR HANDLER OnError

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TXBrowse

   local hBmp, o

   BrwClasses( ::ClassName ) // inserted in FWH 13.03

   DEFAULT oWnd := GetWndDefault()

   ::oWnd  := oWnd
   ::lUnicode := FW_SetUnicode()

/*
   if oWnd != nil
      if oWnd:oFont == nil
         oWnd:GetFont()
      endif
      ::oFont := oWnd:oFont
   endif
*/

   ::GetFont()

   ::l2007        := ( ColorsQty() > 256 )
   //::lFlatStyle   := .f.
   ::aCols        := {}
   ::aSelected    := {}

//   ::bClrHeader   := {|| { GetSysColor( COLOR_BTNTEXT ), GetSysColor( COLOR_BTNFACE ) } }
//   ::bClrHeader   := {|| { GetSysColor( COLOR_BTNTEXT ), GetSysColor( COLOR_BTNFACE ), nRGB( 125, 165, 224 ), nRGB( 203, 225, 252 ) } }
//   ::bClrFooter   := ::bClrHeader

   ::bClrHeader   := ;
   ::bClrFooter   := {|| { GetSysColor( COLOR_BTNTEXT ), If( ::l2000, nRGB( 231, 242, 255 ), GetSysColor( COLOR_BTNFACE ) ), ;
                           nRGB( 125, 165, 224 ), nRGB( 203, 225, 252 ) } }
   ::bClrStd      := {|| { CLR_BLACK, GetSysColor( COLOR_WINDOW )} }
//   ::bClrSel      := {|| { CLR_BLACK, GetSysColor( COLOR_INACTIVECAPTIONTEXT )} }
   ::bClrSel      := {|| { GetSysColor( COLOR_INACTIVECAPTIONTEXT ), GetSysColor( COLOR_INACTIVECAPTION )} }
   if IsWindows10()
      ::bClrSelFocus := {|| { CLR_WHITE, GetSysColor( COLOR_MENUHILIGHT )} }
   else
      ::bClrSelFocus := {|| { CLR_WHITE, GetSysColor( COLOR_HIGHLIGHT )} }
   endif

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
   ::nBottom  := oWnd:nHeight // 100
   ::nRight   := oWnd:nWidth  // 100

   ::nStyle := nOr( WS_CHILD, WS_BORDER, WS_VISIBLE, WS_TABSTOP )

   ::SetColor( CLR_BLACK, GetSysColor( COLOR_WINDOW ) )

   ::lDrag     := .f.
   ::lFocused  := .f.
   ::lHScroll  := .t.
   ::lVScroll  := .t.

   ::lRecordSelector     := .t.
   ::lAllowRowSizing     := .t.
   ::lColDividerComplete := .f.
   ::lRowDividerComplete := .f.
   ::lGradientComplete   := .f.
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

   ::nHeader          := 0          // Obsolete
   ::aHeaderTop       := {}         // Obsolete

   ::hCursorHand      := CursorOpenHand()
   ::lKineticBrw      := ::lKinetic
   ::lAdjusted        := .f.
   ::lPainted         := .f.

   ::hCargo          := {=>}
   HB_HSetCaseMatch( ::hCargo, .f. )
   HB_HSetAutoAdd(   ::hCargo, .t. )

   if ::lInheritStyle
      // Default Style
      if ( o := IfNil( oWnd:oBar, oWnd:oMenu ) ) == nil
         o  := If( WndMain() == nil, nil, If( WndMain():oBar == nil, WndMain():oMenu, WndMain():oBar ) )
      endif
      if o != nil
         ::SetStyle( If( o:l2007, 2007, If( o:l2010, 2010, If( o:l2013, 2013, If( o:l2015, 2015, 0 ) ) ) ) )
      endif
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TXBrowse

   local nFor

   if ::oActive == Self
      ::oActive   := nil
   endif

   ::lMoved = .F.

   if ::oBrush:hBitmap != 0 .and. ValType( ::oBrush:Cargo ) == 'N' .and. ;
      ::oBrush:hBrush != ::oBrush:Cargo
         // resized brush
      DeleteObject( ::oBrush:Cargo )
   endif

   for nFor := 1 to Len( ::aCols )
      ::aCols[ nFor ]:End()
   next

   for nFor := 1 to Len( ::aBitmaps )
      if ! Empty( ::aBitmaps[ nFor, BITMAP_HANDLE ] )
         PalBmpFree( ::aBitmaps[ nFor, BITMAP_HANDLE ], ::aBitmaps[ nFor, BITMAP_PALETTE ] )
         ::aBitmaps[ nFor, BITMAP_HANDLE ] := 0
      endif
   next
   ::aBitmaps  := {}

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

   if ::hScrnBmp != nil
      DeleteObject( ::hScrnBmp )
      ::hScrnBmp  := nil
   endif

   ::oRs := ::oMySql := ::oDbf := nil // Necessary to release the reference to oRs from memory

   if ::oClp != nil
      ::oClp:End()
      ::oClp   := nil
   endif

return ::Super:Destroy()

//----------------------------------------------------------------------------//

METHOD SetStyle( nStyle ) CLASS TXBrowse

   local tmp

   if ASCan( { -1, 0, 2007, 2010, 2013, 2015 }, nStyle ) == 0
      return nil
   endif

   ::n2KStyle  := nStyle

   if ::n2KStyle <= 2007
      ::bClrGrad := { | lInvert | If( lInvert, ;
         { { 1/3, nRGB( 255, 253, 222 ), nRGB( 255, 231, 151 ) }, ;
           { 2/3, nRGB( 255, 215,  84 ), nRGB( 255, 233, 162 ) }  ;
         }, ;
         { { 1/3, nRGB( 219, 230, 244 ), nRGB( 207, 221, 239 ) }, ;
           { 2/3, nRGB( 201, 217, 237 ), nRGB( 231, 242, 255 ) }  ;
         } ) }
   else
      ::bClrGrad  := Gradient2000( ::n2KStyle )
   endif

   ::nRecSelColor    := If( ::n2KStyle >= 2007, ATail( Eval( ::bClrGrad, .f. ) )[ 3 ], GetSysColor( COLOR_BTNFACE ) )

   tmp            := ::nRecSelColor
   ::bClrHeader   := ;
   ::bClrFooter   := {|| { GetSysColor( COLOR_BTNTEXT ), tmp, ;
                           nRGB( 125, 165, 224 ), nRGB( 203, 225, 252 ) } }

return nil

//----------------------------------------------------------------------------//

METHOD SetRecSelBmp( uNew ) CLASS TXBrowse

   local aBmp
   local nWidth   := 0

   if ! Empty( ::hBmpRecSel )
      nWidth      := nBmpWidth( ::hBmpRecSel )
      DeleteObject( ::hBmpRecSel )
      ::hBmpRecSel   := 0
   endif

   if uNew == nil
      ::hBmpRecSel   := FWRArrow()
   elseif ValType( uNew ) == 'N' .and. uNew == 0
      // no bmp
   else
      aBmp  := ::ReadImage( uNew, { 16, 16 } )
      if ! Empty( aBmp )
         ::hBmpRecSel   := aBmp[ 1 ]
         if ! Empty( aBmp[ 2 ] )
            DeleteObject( aBmp[ 2 ] )
         endif
         if ValType( ::nRecSelWidth ) == 'N'
            ::nRecSelWidth += ( nBmpWidth( ::hBmpRecSel ) - nWidth )
         endif
      endif
   endif

   if ::lAdjusted
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetRightFreeze( oCol ) CLASS TXBrowse

   local nAt

   if PCount() > 0
      if oCol == nil
         ::hRightCol    := nil
      else
         oCol  := ::oCol( oCol )
         if oCol != nil
            nAt := AScan( ::aCols, { |o| o == oCol } )
            if nAt < Len( ::aCols )
               ADel( ::aCols, nAt )
               ::aCols[ Len( ::aCols ) ] := oCol
            endif
            oCol:lHide  := .f.
            ::hRightCol := oCol
         endif
      endif
      if ::lAdjusted
         ::GetDisplayCols()
         ::Refresh()
      endif
   endif

return ::hRightCol

//----------------------------------------------------------------------------//

METHOD CreateFromCode() CLASS TXBrowse

   if ::lCreated
      return Self
   endif

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

   DEFAULT ::cVarName := "oBrw" + ::GetCtrlIndex()
   if ::lDesign
      ::CheckDots()
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

METHOD cGenPrg() CLASS TXBrowse

   local cCode := ""
   local n

   cCode += CRLF + "   @ " + Str( ::nTop, 3 ) + ", " + Str( ::nLeft, 3 ) + ;
            " XBROWSE " + ::cVarName + ;
            " OF " + ::oWnd:cVarName + ;
            "; " + CRLF + ;
            "      SIZE " + ;
            AllTrim( Str( ::nWidth ) ) + ", " + ;
            AllTrim( Str( ::nHeight ) ) + " PIXEL DESIGN" + CRLF + CRLF

   cCode += "   " + ::cVarName + ":CreateFromCode()" + CRLF

return cCode

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TXBrowse

   local oBrush

   if ::oBrush != nil
      oBrush := ::oBrush
      ::oBrush := nil
   endif

   if hDlg != nil
      ::Super:Initiate( hDlg )
//      ::SetColor( CLR_BLACK, GetSysColor( COLOR_WINDOW ) ) // Was resetting colors already set. Now commented out v9.12
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
      elseif ! Empty( ::oMysql ) .AND. ::oMysql:IsKindOf( 'TMYSQLQUERY' )
         ::SetMysql( ::oMysql )
      elseif ! Empty( ::oMysql ) .AND. ::oMysql:IsKindOf( 'TDOLPHINQRY' )
         ::SetDolphin( ::oMysql )
      elseif ! Empty ( ::oDbf )
         ::SetoDbf( ::oDbf,,, Empty( ::aCols ) )
      elseif ! Empty( ::cAlias ) .or. ! Empty( Alias() )
         ::SetRDD()
      endif
      if Empty( ::nDataType )  // Empty( ::cAlias )
         // no rdd open and no datasource
         ::bBof   := ::bEof := { || .t. }
         ::bKeyCount := ::bKeyNo := ::bBookMark := { || 0 }
      endif

   endif

   if ( ! Empty( ::cAlias ) ) .and. ( Empty( ::bKeyCount ) .or. Empty( ::bKeyNo ) )
      ::SetRdd()
   endif

   if Empty( ::aCols )
      ::AddCol():bStrData     := { || "" }
      ::aCols[ 1 ]:cHeader    := "A"
      ::nStretchCol := 1
   endif

   ::lCreated := .t.

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

METHOD CheckSize()  CLASS TXBrowse

   local aRect
   local nGap

   if ( ::nRightMargin != nil .or. ::nBottomMargin != nil ) .and. !( ::oWnd:oClient == Self )
      aRect    := GetClientRect( ::oWnd:hWnd )
      if ::nRightMargin != nil
         ::nWidth       := aRect[ 4 ] - ::nRightMargin - ::nLeft
      endif
      if ::nBottomMargin != nil
         ::nHeight      := aRect[ 3 ] - ::nBottomMargin - ::nTop
      endif

   endif

   if ::nHeaderPad > 0
      ::nHeaderHeight   -= ::nHeaderPad
   endif
   if ::nFooterPad > 0
      ::nFooterHeight   -= ::nFooterPad
   endif
   ::nHeaderPad := ::nFooterPad := 0

   if ::lAdjusted .and. ::lFitGridHeight .and. ;
      ( ( ::lHeader .and. ::nHeaderHeight > 1 ) .or. ::lFooter )

      if ( nGap  := ::DataRect:nHeight % ::nRowHeight ) > 0

         if ::lHeader .and. ::nHeaderHeight > 1
            if ::lFooter
               ::nFooterPad   := Int( nGap * ::nFooterHeight / ( ::nHeaderHeight + ::nFooterHeight ) )
               ::nHeaderPad   := nGap - ::nFooterPad

               ::nFooterHeight   += ::nHeaderPad
               ::nHeaderHeight   += ::nFooterPad
            else
               ::nHeaderHeight   += ( ::nHeaderPad := nGap )
            endif
         else
            ::nFooterHeight   += ( ::nFooterPad := nGap )
         endif
      endif

   endif

return Self

//----------------------------------------------------------------------------//

METHOD BrwFitSize( lReSize, nMaxRows ) CLASS TXBrowse

   local oRect, nX, nY
   local nWidth      := ::nWidth
   local nHeight     := ::nHeight

   if ::lAdjusted

      DEFAULT lReSize   := .f., nMaxRows := ::RowCount()

      oRect    := ::GetCliRect()
      nX             := nWidth  - oRect:nWidth
      nY             := nHeight - oRect:nHeight

      nWidth         := ::GetDisplayColsWidth() + 1 + nX
      nHeight        := Max( 3, Min( nMaxRows, ::KeyCount() ) ) * ::nRowHeight + ;
                        ::HeaderHeight( .t. ) + ;
                        ::FooterHeight() + 1 + nY

      if lReSize
         oRect := ::oWnd:GetCliRect()
         ::nWidth    := Min( nWidth, oRect:nWidth - IfNil( ::nRightMargin, 0 ) * 2 )
         ::nHeight   := nHeight
         if ! Empty( ::nRightMargin )
            ::nLeft  := oRect:nRight - ::nRightMargin - nWidth + 1
         endif
         if ! Empty( ::nBottomMargin )
            ::nTop   := oRect:nBottom - ::nBottomMargin - nHeight + 1
         endif
      endif

   endif

return { nWidth, nHeight }

//------------------------------------------------------------------//

METHOD Adjust() CLASS TXBrowse

   local nFor, nLen, nHeight, nStyle, nTemp, oCol, h

   if ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7
      if ValType( Eval( ::bClrSelFocus )[ 2 ] ) != 'A'
         ::bClrSelFocus := { || { CLR_BLACK, { { 1, RGB( 220, 235, 252 ), ;
                                                    RGB( 193, 219, 252 ) } } } }
      endif
      if ValType( Eval( ::bClrSel )[ 2 ] ) != 'A'
         ::bClrSel := ::bClrSelFocus
      endif
   endif

   if ValType( ::nRecSelWidth ) == 'C'
      ::nRecSelWidth := CalcTextWH( Self, ::nRecSelWidth, IfNil( ::oRecSelFont, ::oFont ) )[ 1 ] + ;
         6 + 5 + nBmpWidth( ::hBmpRecSel ) + 6
   endif

   if ::nRecSelHeadBmpNo != nil .and. ValType( ::nRecSelHeadBmpNo ) != 'N'
      ::nRecSelHeadBmpNo   := ::AddBitmap( ::nRecSelHeadBmpNo )
   endif

/*
   if ::lFlatStyle
      ::l2007  := .f.
   endif
*/
   ::CheckSize()

   nLen    := Len( ::aCols )
   nHeight := 0

   if ! Empty( ::nHeader )    // Backward Compatibility with earlier GroupHeader logic
      nTemp      := 0
      for nFor := 1 to nLen
         WITH OBJECT ::aCols[ nFor ]
            if :nHeaderType > 0  //.and. :nHeaderType != 3 //( uncomment for full compat with Mr. Silvio's earlier code,
                                                           //  but inconsitent with documentation )
               if :nHeaderType == 2 .or. :nHeaderType == 4  // type 4 was undocumented, but used in earlier samples
                  nTemp++
               endif
               if nTemp <= Len( ::aHeaderTop )
                  :cGrpHdr   := ::aHeaderTop[ nTemp ]
               endif
            endif
         END
      next
   endif  // End backward compatibility

   ::GetDC()

   for nFor := 1 to nLen
      ::aCols[ nFor ]:Adjust()
   next

   ::ReleaseDC()

   ::CalcHdrHeight()
    DEFAULT ::nGetBarHeight   := FontHeight( Self, IfNil( ::oFont, ::oWnd:oFont ) ) + 8

   if ::lFooter .and. ::nFooterHeight == nil
      nHeight := 0
      for nFor := 1 to nLen
         nHeight := Max( nHeight, ::aCols[ nFor ]:FooterHeight() )
      next
      ::nFooterHeight := ( nHeight * ::nFooterLines ) + ROW_EXTRAHEIGHT + 3 // lines to give 3d look
   endif

   for each oCol in ::aCols
      if ! Empty( oCol:aRows )
         AEval( oCol:aRows, { |o| oCol:nWidth := Max( oCol:nWidth, o:nWidth ) } )
         AEval( oCol:aRows, { |o| o:nWidth := oCol:nWidth } )
      endif
   next oCol

   if ::nRowHeight == nil
      nHeight := 0
      for nFor := 1 to nLen
         nHeight := Max( nHeight, ::aCols[ nFor ]:DataHeight() )
      next
      // if some columns have multiple rows
      for each oCol in ::aCols
         if ! Empty( oCol:aRows )
            h  := 0
            AEval( oCol:aRows, { |o| h += o:nCellHeight } )
            nHeight  := Max( nHeight, Ceiling( h / ::nDataLines ) )
         endif
      next oCol

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
      ::hColPen := CreatePen( If( ::nColorPen == nil, PS_NULL, PS_SOLID ), ::nSizePen, ::nColorPen )
   case nStyle == LINESTYLE_DARKGRAY
      ::hColPen := CreatePen( PS_SOLID, ::nSizePen, CLR_GRAY )
   case nStyle == LINESTYLE_FORECOLOR
      ::hColPen := CreatePen( PS_SOLID, ::nSizePen, ::nClrText )
   case nStyle == LINESTYLE_LIGHTGRAY
      ::hColPen := CreatePen( PS_SOLID, ::nSizePen, CLR_LIGHTGRAY )

   end case

   nStyle := ::nRowDividerStyle

   do case
   case nStyle == LINESTYLE_BLACK .or. nStyle == LINESTYLE_RAISED .or. nStyle == LINESTYLE_INSET
      ::hRowPen := CreatePen( If( ::nColorPen == nil, PS_NULL, PS_SOLID ), ::nSizePen, ::nColorPen )
   case nStyle == LINESTYLE_DARKGRAY
      ::hRowPen := CreatePen( PS_SOLID, ::nSizePen, CLR_GRAY )
   case nStyle == LINESTYLE_FORECOLOR
      ::hRowPen := CreatePen( PS_SOLID, ::nSizePen, ::nClrText )
   case nStyle == LINESTYLE_LIGHTGRAY
      ::hRowPen := CreatePen( PS_SOLID, ::nSizePen, CLR_LIGHTGRAY )

   end case

   if ::nRecSelColor == nil
      ::nRecSelColor := If( ::l2000, nRGB( 231, 242, 255 ), Eval( ::bClrHeader )[ 2 ] )
   endif

   if ::hBrushRecSel != nil
      DeleteObject( ::hBrushRecSel )
   endif
   ::hBrushRecSel = CreateColorBrush( ::nRecSelColor )

   ::GetDisplayCols()

   ::KeyCount()

   if ::lMultiSelect   // ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS .or. ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7
      ::Select(1)
   endif

   if ::oVScroll != nil
      ::VSetRange( 1, ::nLen )
      ::VSetPos( ::KeyNo() )
   endif

   ::lAdjusted    := .t.

   AEval( ::abOnAdjust, { |b| Eval( b ) } )

   ::ColStretch()

   if ::lLockFreeze
      ::nColSel   := ::nFreeze + 1
   endif

   ::lScreenUpdating := .t.
   DEFINE CLIPBOARD ::oClp OF Self

return nil

//----------------------------------------------------------------------------//

METHOD AutoFit( aColsToFit, nRows, lDataOnly, nMaxWidth ) CLASS TXBrowse

   // aCols defaults to all cols
   // nRows defaults to all rows
   // 2nd param can be logical (lVisible) during runtime
   // If lVisible is .t., only the visible rows are autofib

   local aCols    := {}
   local lVisible := .f.
   local aWidths
   local uBm, n, r

   if ! ::lAdjusted
      if aColsToFit == nil
         aColsToFit  := {}
         AEval( ::aCols, ;
         { |o| If( Empty( o:nWidth ) .and. o:nEditType != EDIT_LISTBOX .and. o:nEditType != EDIT_GET_LISTBOX, ;
                   AAdd( aColsToFit, o ), nil ) } )
      endif
      if ! Empty( aColsToFit )
         AAdd( ::abOnAdjust, { || ::AutoFit( aColsToFit, nRows, lDataOnly, nMaxWidth ) } )
      endif
      return nil
   endif
   if aColsToFit == nil
      aCols    := ::aCols
   else
      AEval( aColsToFit, { |u| If( ( u := ::oCol( u ) ) == nil, nil, AAdd( aCols, ::oCol( u ) ) ) } )
   endif
   if Empty( aCols )
      return nil
   endif

   aWidths  := Array( Len( aCols ) )
   AFill( aWidths, 0 )

   if HB_ISLOGICAL( nRows )
      if ! Empty( ::nDataRows )
         lVisible    := nRows
      endif
      nRows    := nil
   endif

   uBm      := ::BookMark
   if lVisible
      Eval( ::bSkip, 1 - ::nRowSel )
      nRows    := ::nDataRows
   else
      Eval( ::bGoTop )
      DEFAULT nRows := Eval( ::bKeyCount )
   endif
   r        := 0
   REPEAT
      r++
      for n := 1 to Len( aCols )
         aWidths[ n ]   := Max( aWidths[ n ], aCols[ n ]:DataTextWidth( .t. ) )
      next
   UNTIL Eval( ::bSkip, 1 ) == 0 .or. r >= nRows
   ::BookMark  := uBm

   DEFAULT lDataOnly := .f.

   for n := 1 to Len( aCols )
      aWidths[ n ]   := aCols[ n ]:DataWidth( aWidths[ n ] )
      if ! lDataOnly
         if ::lHeader
            aWidths[ n ] := Max( aWidths[ n ], aCols[ n ]:HeaderWidth() )
         endif
         if ::lFooter
            aWidths[ n ] := Max( aWidths[ n ], aCols[ n ]:FooterWidth() )
         endif
      endif
      aCols[ n ]:nWidth := aWidths[ n ]
      if aCols[ n ]:nWidth > 0
         aCols[ n ]:nWidth += COL_EXTRAWIDTH
      endif
      if nMaxWidth != nil .and. aCols[ n ]:nWidth > nMaxWidth
         aCols[ n ]:nWidth := nMaxWidth
      endif
   next

   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD CalcHdrHeight() CLASS TXBrowse

   local nFor, nLen, nGrp, nCol, oCol, nHeight
   local cGrpHdr
   local aGroup, aBitmap

   if ::lHeader //.and. ::nHeaderHeight == nil

      nLen           := Len( ::aCols )
      nHeight        := 0
      ::aHeaderTop   := {}
      if ::lGrpHeader == nil
         ::lGrpHeader   := .f.
         for nFor := 1 to nLen
            if ! Empty( ::aCols[ nFor ]:cGrpHdr )
               ::lGrpHeader := .t.
            endif
         next
      endif
      if ::lGrpHeader .or. ::nHeaderHeight == nil
         if ::lGrpHeader
            nHeight     := 0
            for nFor := 1 to nLen
               oCol     := ::aCols[ nFor ]
               if oCol:cGrpHdr != cGrpHdr
                  if aGroup != nil
                     AAdd( ::aHeaderTop, aGroup )
                     for nCol := aGroup[ 3 ] to aGroup[ 4 ]
                        ::aCols[ nCol ]:nGrpHeight := aGroup[ 5 ]
                     next
                     aGroup  := nil
                  endif
                  cGrpHdr     := oCol:cGrpHdr
                  if ! Empty( oCol:cGrpHdr )
                     // new group starts
                     aGroup      := { oCol:cGrpHdr, oCol, nFor, nFor, oCol:HeaderHeight( .t. ), ;
                                      oCol:aBitmap( oCol:nGrpBmpNo ) }
                  endif
               else
                  // same group or nogroup
                  if ! Empty( oCol:cGrpHdr )
                     aGroup[ 2 ]      := oCol
                     aGroup[ 4 ]      := nFor
                     aGroup[ 5 ]      := Max( aGroup[ 5 ], oCol:HeaderHeight( .t. ) )
                     if ! Empty( oCol:nGrpBmpNo )
                        aGroup[ 6 ]    := oCol:aBitmap( oCol:nGrpBmpNo )
                     endif
                  endif
               endif
            next
            if aGroup != nil
               AAdd( ::aHeaderTop, aGroup )
               for nCol := aGroup[ 3 ] to aGroup[ 4 ]
                  ::aCols[ nCol ]:nGrpHeight := aGroup[ 5 ]
               next
               aGroup  := nil
            endif
         endif

         for nFor := 1 to nLen
            nHeight  := Max( nHeight, ::aCols[ nFor ]:HeaderHeight() )
         next
//         DEFAULT ::nGetBarHeight   := FontHeight( Self, IfNil( ::oFont, ::oWnd:oFont ) ) + 8
         if ::nHeaderLines > 1
            nHeight  := Max( nHeight, FontHeight( Self, ::oWnd:oFont ) * ::nHeaderLines )
         endif
         ::nHeaderHeight := nHeight + ROW_EXTRAHEIGHT + 3 // lines to give 3d look
      endif
   endif

return ::nHeaderHeight

//------------------------------------------------------------------//

METHOD Change( lRow ) CLASS TXBrowse

   DEFAULT lRow := .t.

   if lRow .and. ::oSortCol != nil
      ::uSortVal  := ::oSortCol:Value
   endif

   if lRow .and. ::bChangeInternal != nil
      Eval( ::bChangeInternal, Self, .t. )
   endif

   if ::bChange != nil

      if lRow .or. ::lColChangeNotify
         Eval( ::bChange, Self, lRow )
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD Refresh( lComplete )  CLASS TXBrowse

   local nKeyNo

   if ::lAdjusted

      DEFAULT lComplete := .F.

      ::KeyCount()

      if lComplete
         ::nRowSel  = 1
         ::nArrayAt = Min( 1, ::nLen )
      else
         ::DelRepos()  // if the row is deleted for RDD
         nKeyNo     = ::KeyNo()
         if nKeyNo > ::nLen         // Rare case
            ::KeyNo  := ::nLen
            nKeyNo  = ::nLen
         endif
         if ::nArrayAt == 0 .and. ::nLen > 0
            // when one or more rows are added to a blank array
            ::nArrayAt  := 1
         endif
      endif
      ::CalcRowSelPos()
      ::GetDisplayCols()
      if ::bOnRefresh != nil
         Eval( ::bOnRefresh, Self )
      endif

   endif

return ::Super:Refresh( .t. )

//----------------------------------------------------------------------------//

METHOD CalcRowSelPos() CLASS TXBrowse

   local nKeyNo, nMaxRows, nBookMark, nSkipped

   nMaxRows    := ::RowCount()
   if ::lRelyOnKeyNo
      nKeyNo      := ::KeyNo()
      if ::nLen <= nMaxRows
         ::nRowSel   := nKeyNo
      else
         if ( ::nLen - nKeyNo  ) < ( nMaxRows - ::nRowSel )
            ::nRowSel   := nMaxRows - ( ::nLen - nKeyNo )
         endif
         ::nRowSel   := Max( 1, Min( ::nRowSel, nKeyNo ) )
      endif
   else
      nBookMark   := ::BookMark
//      nSkipped    := ::Skip( nMaxRows - ::nRowSel )
      nSkipped    := ::Skip( Min( ::nLen - ::KeyNo, nMaxRows - ::nRowSel ) )
      ::nRowSel   := Max( ::nRowSel, nMaxRows - nSkipped )
      ::BookMark  := nBookMark
      ::nRowSel   := 1 - ::Skip( 1 - ::nRowSel )
      ::BookMark  := nBookMark
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DelRepos() CLASS TXBrowse

   local lRepos := .f.
   local cFilter, bFilter

   if ( ::nDataType == DATATYPE_RDD ) .and. ::nLen > 0
      if ( Set( _SET_DELETED ) .and. ( ::cAlias )->( Deleted() ) )

/*
      ;
         .or. ;
         ( ! Empty( cFilter := ( ::cAlias )->( dbFilter() ) ) .and. ;
           Type( cFilter ) == 'L' .and. ;
           ! &cFilter )
*/

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

   local nSecs    := SECONDS()

   if !::lCreated
      return nil
   endif

   ::BeginPaint()
   ::Paint()
   ::EndPaint()

   ::nRefreshSecs := SECONDS() - nSecs

return 0

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TXBrowse

   local aCols, aColors, oRect
   local oCol
   local nFor, nLen, nRow, nCol, nHeight, nLast, nTemp, nTemp2, nKeyNo
   local nGridWidth, nBrwHeight, nWidth
   local hBrush, hDC, hGrayPen, hWhitePen, hColPen, hRowPen, hSelBrush
   local nFirstRow, nLastRow, nMaxRows, nRowStyle, nColStyle, nRowPos, nRowHeight, nBookMark, nMarqStyle, nScan
   local lRecSel, lOnlyData, lHighLite, nRecSelBmpWidth, aBitmap
   local aInfo

   if ::lScreenUpdating
      if ::hScrnBmp != nil
         DeleteObject( ::hScrnBmp )
         ::hScrnBmp  := nil
      endif
   else
      if ::hScrnBmp == nil
         oRect    := ::GetCliRect()
         ::hScrnBmp  := MakeBkBmpEx( ::hWnd, oRect:nTop, oRect:nLeft, oRect:nWidth, oRect:nHeight )
      endif
      if ::hScrnBmp != nil
         ::DrawImage( ::hScrnBmp,, .f. )
         return 0
      endif
   endif

   if ::lDrawBorder
      if ! ::lHeader
         ::nHeaderHeight := 1
      endif
      if ! ::lRecordSelector
         ::nRecSelWidth := 1
      endif
   endif

   if ::nRecSelWidth > 1 .and. ::nRecSelWidth < RECORDSELECTOR_WIDTH
      ::nRecSelWidth    := RECORDSELECTOR_WIDTH
   endif

   if ::SelectedCol():oEditLbx != nil
      return nil
   endif

   aInfo := ::DispBegin()
   ::CheckSize()

   // Paint Background
   if ::lTransparent .and. Empty( ::oBrush:hBitmap )
      if ! Empty( ::oWnd:oBrush:hBitmap )
         SetBrushOrgEx( ::hDC, nBmpWidth( ::oWnd:oBrush:hBitmap ) - ::nLeft, ;
                               nBmpHeight( ::oWnd:oBrush:hBitmap ) - ::nTop )
      endif
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oWnd:oBrush:hBrush )
   else
      oRect       := ::DataRect()
      SetBrushOrgEx( ::hDC, oRect:nLeft, oRect:nTop )
      FillRect( ::hDC, oRect:aRect, ::oBrush:hBrush )
   endif
   // Paint Background end

   if ! ( ::oRightCol != nil .and. ::oRightCol:nPos == ::nColSel )
      while ! ::IsDisplayPosVisible( ::nColSel ) .and. ::nColSel > 1
         ::nColSel--
         ::nColOffSet++
         ::GetDisplayCols()
      end
   endif

   nLen       := Len( ::aDisplay )
   aCols      := Array( nLen + 1 )
   nGridWidth  := ::GridWidth()
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
   nRecSelBmpWidth   := If( Empty( ::hBmpRecSel ), 0, nBmpWidth( ::hBmpRecSel ) )

   /*
   Rowselector
   */

   if lRecSel
      nCol += ::nRecSelWidth

      // To enable programmer to change color during runtime
      DeleteObject( ::hBrushRecSel )
      ::hBrushRecSel := CreateColorBrush( ::nRecSelColor )

      if !lOnlyData
         FillRect( hDC, {0, 0, nLastRow + 3, nCol }, ::hBrushRecSel ) // Fills one pixel gap between recsel and data area
         nHeight := ::HeaderHeight()
         nTemp   := nBrwHeight - ::FooterHeight() + 3
         if ::lFlatStyle
            DrawVert( hDC, nCol - 2, nHeight, nTemp, hColPen )
            DrawVert( hDC, 0,        0,       nBrwHeight + 3, hColPen )
         else
            DrawVert( hDC, nCol - 3, nHeight, nTemp,          hWhitePen )
            DrawVert( hDC, nCol - 2, nHeight, nTemp,          hGrayPen )
            DrawVert( hDC, 0,        0,       nBrwHeight + 3, hGrayPen )
            DrawVert( hDC, 1,        0,       nBrwHeight + 3, hWhitePen )
         endif
      endif

      //nCol --
   elseif ::nRecSelWidth == 1
      nCol  += ::nRecSelWidth
   endif

   AEval( ::aCols, { |o| o:nDisplayCol := 0 } )  // inserted 2016-04-16
/*
   for nFor := 1 to nLast
      aCols[ nFor ] := nCol
      oCol := ::ColAtPos( nFor )
      oCol:nDisplayCol  := nCol           // inserted 2016-04-16
      nCol += oCol:nWidth + COL_SEPARATOR
   next

   aCols[ nFor ] := nCol
*/

   aCols    := ::GetPaintCols( @nLast )
   for nFor := 1 to nLast
      oCol  := ::ColAtPos( nFor )
      oCol:nDisplayCol  := aCols[ nFor ]
   next

   if ::hRightCol != nil
      ::hRightCol:nDisplayCol := ::BrwWidth() - ::hRightCol:nWidth
   endif

   // Paint Header
   if ::lHeader .or. ::nHeaderHeight == 1
      if !lOnlyData
         ::PaintHeader( hDC, aCols, nLast, hWhitePen, hGrayPen, hColPen )
      endif
      nFirstRow   := ::FirstRow()
   endif

   // Paint Footer
   if ::lFooter
      if !lOnlyData
         ::PaintFooter( hDC, aCols, nLast, nGridWidth, nBrwHeight, hWhitePen, hGrayPen )
      endif
      nLastRow -= ::nFooterHeight
   endif

   /*
   Paint cols data
   */

   ::lRefreshOnlyData := .f.

   if ::nLen == 0
      ::EraseData( nFirstRow  )
      if ::bPainted != nil
         Eval( ::bPainted, ::hDC, ::cPS, Self )
      endif
      ::DispEnd( aInfo )
      ::lPainted  := .t.
      return nil
   endif

   nRowHeight := ::nRowHeight
   nHeight    := ::DataHeight() // nRowHeight - 2
   nMaxRows   := ::RowCount()
   nRowPos    := 1
   nRow       := nFirstRow

   TRY
   nBookMark  := ::BookMark
   CATCH
   END

   ::nRowSel   := Max( 1, Min( ::nRowSel, nMaxRows ) )
   if Empty( ::nDataRows )
      ::CalcRowSelPos()
   endif
   ::nRowSel   := 1 - ::Skip( 1 - ::nRowSel )

   if nMarqStyle > MARQSTYLE_HIGHLCELL // .and. aCols[ nLast + 1 ] < nGridWidth
      if ::hWnd == GetFocus()
         hSelBrush := CreateColorBrush( Eval( If( ::bClrRowFocus == nil, ::bClrSelFocus, ::bClrRowFocus ) )[ 2 ] )
      else
         hSelBrush := CreateColorBrush( Eval( ::bClrSel )[ 2 ] )
      endif
   endif

   if ::lFastDraw
      ::oFont:Activate( hDC )
   endif

   do while nRowPos <= nMaxRows

      // We must also paint some times after the last visible column

      if hSelBrush != nil

         lHighLite := ::lMultiSelect .and. ( Ascan( ::aSelected, Eval( ::bBookMark ) ) > 0 )

         if ::lFastDraw
            if lHighLite
               FillRect( hDC, { nRow, aCols[ 1 ], nRow + nHeight, nGridWidth }, hSelBrush )
            endif
         else
            if aCols[ nLast + 1 ] < nGridWidth
               nTemp     := nRow + nHeight
               nTemp2    := aCols[nLast + 1]
               if nColStyle < LINESTYLE_INSET
                  nTemp2--
               endif
               if lHighLite .and. ::nMarqueeStyle != MARQSTYLE_HIGHLWIN7
                  FillRect( hDC, {nRow, nTemp2, nTemp, nGridWidth }, hSelBrush )
               elseif nMarqStyle >= MARQSTYLE_HIGHLROWRC //== MARQSTYLE_HIGHLROWMS  //12 aug 2013
                  if ! ::lTransparent
                     hBrush := CreateColorBrush( Eval( ::bClrStd )[ 2 ] )
                     FillRect( hDC, {nRow, nTemp2, nTemp, nGridWidth }, hBrush )
                     DeleteObject( hBrush )
                  endif
               endif
            endif
         endif
      endif

      if ::lFastDraw
         for nFor := 1 to nLast
            if aCols[ nFor ] > nGridWidth
               exit
            endif
            oCol := ::ColAtPos( nFor )
            if ! Empty( oCol:bBmpData ) .and. ! Empty( aBitmap := oCol:aBitmap( IfNil( XEval( oCol:bBmpData, oCol:Value() ), 0 ) ) )
               ::DrawImage( aBitmap, { nRow + 3, aCols[ nFor ] + 3, nRow + nHeight - 3, aCols[ nFor ] + oCol:nWidth - 3 }, ;
                     oCol:lBmpTransparent, oCol:lBmpStretch, ;
                     oCol:nAlphaLevel(), .f., "" )
            else
               DrawTextEx( hDC, oCol:StrData, { nRow + 3, aCols[ nFor ] + 3, nRow + nHeight - 3, aCols[ nFor ] + oCol:nWidth - 3 }, oCol:nDataStyle )
            endif
         next
      else

         if Eval( ::bPaintRow, Self, nRow, aCols[ 1 ], nHeight, lHighLite, .f., nRowPos )

            if lRecSel .and. ::bRecSelData != nil
               ::SayText( cValToChar( Eval( ::bRecSelData, Self ) ), { nRow, 0, nRow + nHeight, ;
                        ::nRecSelWidth - nRecSelBmpWidth - 11 }, 'R', ;
                        IfNil( ::oRecSelFont, ::oFont ) )
            endif

            for nFor := 1 to nLast
               if aCols[ nFor ] > nGridWidth
                  exit
               endif
               oCol := ::ColAtPos( nFor )
               oCol:PaintData( nRow, aCols[ nFor ], nHeight, lHighLite, .f., nFor, nRowPos )
            next

            if ::oRightCol != nil .and. ! ::oRightCol:lFullHeight
               ::oRightCol:PaintData( nRow, nil, nHeight, lHighLite, .f., ::oRightCol:nPos, nRowPos )
            endif

         endif
      endif

      nRowPos++
      nRow += nRowHeight
      if ::Skip() == 0
         exit
      endif

   enddo

   if ::lFastDraw
      ::oFont:DeActivate()
   endif

   if nMarqStyle <= MARQSTYLE_HIGHLCELL .and. aCols[ nLast + 1 ] < nGridWidth .and. ! ::lTransparent
      hBrush := CreateColorBrush( ::nClrPane )
      nTemp  := aCols[nLast + 1] - 1
      FillRect( hDC, {nFirstRow, nTemp, ::BrwHeight() - ::FooterHeight(), nGridWidth }, hBrush )
      DeleteObject( hBrush )
   endif

   if hSelBrush != nil
      DeleteObject( hSelBrush )
   endif

   ::nDataRows := nRowPos - 1
//      ::nRowSel := Max( Min( ::nRowSel, ::nDataRows ), 1)

   if nRow < nLastRow
      ::EraseData( nRow  )
   endif

   ::BookMark     := nBookMark
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
         nHeight := ( ::nRowHeight * ( nRowPos - 1 ) ) + nFirstRow
      endif
      for nFor := 2 to nLast + 1
         nCol := acols[ nFor ]
         if nCol <= ::GridWidth()
            oCol := ::aCols[ nFor - 1 ]
            hColPen     := IfNil( oCol:hColPen, ::hColPen )
            nColStyle   := IfNil( oCol:nColDividerStyle, ::nColDividerStyle )
            ::PaintVDivider( hDC, nCol, nFirstRow, nHeight, nColStyle, hColPen, hWhitePen )
         endif
      next
      if ::oRightCol != nil //.and. nCol < ::GridWidth()
         ::PaintVDivider( hDC, ::GridWidth(), nFirstRow, nHeight, ::nColDividerStyle, ::hColPen, hWhitePen )
      endif
      if ! lRecSel .and. ::lVScroll .and. ::nColDividerStyle > 0 .and. ::lColDividerComplete
         DrawVert( hDC, 0, 0, nBrwHeight + 3, hGrayPen )
      endif

   endif

   if nRowStyle > 0
      nRow   := ::FirstRow() - 1
      nTemp2 := If( ::lFullGrid, nMaxRows, ::nDataRows )
      do while nTemp2-- > 0
         nRow += nRowHeight
         if lRecSel
            DrawHorz( hDC, nRow,     1, ::nRecSelWidth - 2, hGrayPen  )
            if ! ::lFlatStyle
               DrawHorz( hDC, nRow + 1, 1, ::nRecSelWidth - 2, hWhitePen )
            endif
         endif
         for nFor := 1 to nLast
            if ::aCols[ nFor ]:HasBorder( ::nDataRows - nTemp2 )
               nCol   := acols[ nFor ] - If( nFor != 1, nTemp, 0 )
               nWidth := nCol + ::ColAtPos( nFor ):nWidth + If( nFor != 1, nTemp, 0 )
               nWidth   := Min( nWidth, ::GridWidth() - 2 )
               ::PaintHDivider( hDC, nRow, nCol, nWidth, nRowStyle, hRowPen, hWhitePen )
            endif
         next

         if ( ::lRowDividerComplete .or. ::oRightCol != nil .or. ::lFullGrid .or. nMarqStyle >= MARQSTYLE_HIGHLROWRC ) .and. nLast == Len( ::aDisplay )
            nCol   := Min( acols[ nFor ] - nTemp, ::GridWidth() - 2 )
            nWidth := ::GridWidth() - 2 // - 4      // this is really nRight (not nwidth)
            if nWidth > nCol
               ::PaintHDivider( hDC, nRow, nCol, nWidth, nRowStyle, hRowPen, hWhitePen )
            endif
         endif

         if ::oRightCol != nil .and. ! ::oRightCol:lFullHeight
            nCol     := ::GridWidth()
            nWidth   := ::BrwWidth()
            ::PaintHDivider( hDC, nRow, nCol, nWidth, nRowStyle, hRowPen, hWhitePen )
         endif
      enddo
   endif

   if ::lDrawBorder
      ::Box( 0, 0, ::nHeight - 1, ::nWidth - 1 )
   endif

   if ::bPainted != nil
      Eval( ::bPainted, ::hDC, ::cPS, Self )
   endif
/*
   if !::lScreenUpdating .and. ::hScrnBmp == nil
      ::hScrnBmp  := DUPLICATEBITMAP( aInfo[ 5 ] )
   endif
*/
   ::DispEnd( aInfo )

   ::lPainted  := .t.

return 0

//----------------------------------------------------------------------------//

METHOD GetPaintCols( nLast ) CLASS TXBrowse  // ( @nLast )

   local aCols, nCol, nFor, oCol

   nCol     := If( ::lRecordSelector .or. ::nRecSelWidth == 1, ::nRecSelWidth, 0 )
   aCols    := Array( Len( ::aDisplay ) + 1 )
   nLast    := ::LastDisplayPos()
   for nFor := 1 to nLast
      aCols[ nFor ] := nCol
      oCol := ::ColAtPos( nFor )
      nCol += oCol:nWidth + COL_SEPARATOR
   next
   aCols[ nFor ] := nCol

return aCols

//----------------------------------------------------------------------------//

METHOD PaintHDivider( hDC, nRow, nLeft, nRight, nStyle, hRowPen, hWhitePen ) CLASS TXBrowse

   if nStyle > 0
      if nStyle != LINESTYLE_RAISED
         DrawHorz( hDC, nRow,     nLeft, nRight, hRowPen )
      else
         DrawHorz( hDC, nRow,     nLeft, nRight, hWhitePen )
         DrawHorz( hDC, nRow - 1, nLeft, nRight, hRowPen   )
      endif
      if nStyle = LINESTYLE_INSET
         DrawHorz( hDC, nRow - 1, nLeft, nRight, hWhitePen )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintVDivider( hDC, nCol, nTop, nBottom, nStyle, hColPen, hWhitePen ) CLASS TXBrowse

   if nStyle > 0
      if nStyle != LINESTYLE_RAISED
         DrawVert( hDC, nCol - 2, nTop, nBottom, hColPen )
      else
         DrawVert( hDC, nCol - 2, nTop, nBottom, hWhitePen )
         DrawVert( hDC, nCol - 1, nTop, nBottom, hColPen )
      endif
      if nStyle = LINESTYLE_INSET
         DrawVert( hDC, nCol - 1, nTop, nBottom, hWhitePen )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintHeader( hDC, aCols, nLast, hWhitePen, hGrayPen, hColPen ) CLASS TxBrowse

   local nRow, nCol, oCol, nHeight, nGridWidth, nBrwWidth, aGroup
   local hHeaderPen, aColors, hBrush
   local nFor, nAt
   local cGrpHdr, nGrpHt, nGrpFrom := 0
   local nFullHeight, lGetRefresh := .f.

   if aCols == nil
      aCols    := ::GetPaintCols( @nLast )
   endif

   ::oSortCol  := nil

   if ::bPaintHeader != nil
      return Eval( ::bPaintHeader, Self, hDC, aCols, nLast, hWhitePen, hGrayPen, hColPen )
   endif

   if ::nHeaderHeight == 1
      hHeaderPen  := CreatePen( PS_SOLID, 1, If( Len( aColors := Eval( ::bClrHeader ) ) >= 3, aColors[ 3 ], aColors[ 1 ] ) )
      DrawHorz( hDC, nRow, 1, ::GridWidth(), hHeaderPen )
      DeleteObject( hHeaderPen )
      return nil
   endif

   AEval( ::aCols, { |o| o:CheckBarGet( .f. ) } )

   DEFAULT hWhitePen := ::hWhitePen, hGrayPen := ::hBtnShadowPen, hColPen := ::hColPen

   nGridWidth  := ::GridWidth()
   nBrwWidth   := ::BrwWidth()
   aColors     := Eval( ::bClrHeader )
   hBrush      := CreateColorBrush( aColors[ 2 ] )
   hHeaderPen  := CreatePen( PS_SOLID, 1, If( Len( aColors ) >= 3, aColors[ 3 ], aColors[ 1 ] ) )
   // aColors[ Min( 3, Len( aColors ) ) ] )

   nRow    := 0
   if ::lFlatStyle
      nHeight     := ::nHeaderHeight
      nFullHeight := ::FirstRow()
      if !( ::nHeadDividerStyle == 0 .and. ::nRowDividerStyle == 0 )
         DrawHorz( hDC, nRow, 1, nBrwWidth, hHeaderPen ) //hColPen )
         nHeight--
         nFullHeight--
         nRow++
      endif
   else
      nHeight := ::nHeaderHeight - 3 // Caution: Do not change -3 in a haste. This adjusts 3 pixels added in Adjust method
      nFullHeight := ::FirstRow() - 3
      DrawHorz( hDC, nRow, 2, nBrwWidth, hGrayPen )
      nRow++
      DrawHorz( hDC, nRow, 2, nBrwWidth, hWhitePen )
      nRow++
   endif

   // Fill entire header
   FillRect( hDC, { nRow, If( ::lFlatStyle, 1, 2 ), nRow + nFullHeight, nBrwWidth }, hBrush ) //::hBrushRecSel )
   if ::lRecordSelector
      if ! Empty( ::nRecSelHeadBmpNo )
         ::DrawImage( ::aBitmap( ::nRecSelHeadBmpNo ), { nRow, 2, nRow + nHeight, ::nRecSelWidth - 4 } )
      elseif ! Empty( ::bRecSelHeader )
         ::SayText( cValToChar( XEval( ::bRecSelHeader, Self ) ), { nRow, 2, nRow + nHeight, ::nRecSelWidth - 4 },,;
                    IfNil( ::oRecSelFont, ::oFont ) )
      endif
   endif

   for nFor := 1 to nLast
      nCol     := aCols[ nFor ]
      oCol     := ::ColAtPos( nFor )

      if ::lFlatStyle
         if !( ::nHeadDividerStyle == 0 .and. ::nColDividerStyle == 0 )
            DrawVert( hDC, nCol - 2, nRow,     nRow + nFullHeight - 1, hHeaderPen ) // from FWH 16.04
         endif
      else
         DrawVert( hDC, nCol - 2, nRow,     nRow + nFullHeight - 0, hGrayPen  )
         DrawVert( hDC, nCol - 1, nRow,     nRow + nFullHeight - 0, hWhitePen )
      endif

      oCol:PaintHeader( nRow, nCol, nHeight, .f., hDC )

      if ! ( oCol:cGrpHdr == cGrpHdr )
         cGrpHdr     := oCol:cGrpHdr
         if Empty( oCol:cGrpHdr )
            nGrpFrom       := 0
            aGroup         := nil
         else
            nGrpFrom       := nCol
            nGrpHt         := oCol:nGrpHeight
            nAt            := AScan( ::aHeaderTop, { |a| a[ 3 ] == oCol:nPos } )
            aGroup         := If( nAt > 0, ::aHeaderTop[ nAt ], nil )
         endif
      endif

      if nFor == nLast .or. oCol:cGrpHdr != ::ColAtPos( nFor + 1 ):cGrpHdr
         if ! Empty( cGrpHdr )
            // paint group header
            oCol:PaintHeader( nRow, nGrpFrom, nHeight, .f., hDC, aCols[ nFor + 1 ] - nGrpFrom, ;
                              If( aGroup == nil, nil, aGroup[ 6 ] ) )
            if !( ::lFlatStyle .and. ::nHeadDividerStyle == 0 .and. ::nRowDividerStyle == 0 )
               DrawHorz( hDC, nRow + nGrpHt, nGrpFrom - 2, aCols[ nFor + 1 ] - 2, If( ::lFlatStyle, hHeaderPen, hGrayPen ) ) //hHeaderPen )
            endif
         endif
      endif

      oCol:CheckBarGet( .t. )

   next nFor

   nCol     := aCols[ nFor ]

   if nCol < ::GridWidth()
      if ::lFlatStyle
         if !( ::nHeadDividerStyle == 0 .and. ::nColDividerStyle == 0 )
            DrawVert( hDC, nCol - 2,       nRow,     nRow + nFullHeight - 1, hHeaderPen )
         endif
      else
         DrawVert( hDC, nCol - 2,       nRow,     nRow + nFullHeight - 0, hGrayPen  )
         DrawVert( hDC, nCol - 1,       nRow,     nRow + nFullHeight - 0, hWhitePen )
      endif
   endif

   if ::l2000 .and. ::lGradientComplete
      GradientFill( hDC, nRow - 1, nCol, nRow + nHeight - 1, nGridWidth, ;
               Eval( ::bClrGrad, .f. ) )
   endif

   if ::lFlatStyle
      if !( ::nHeadDividerStyle == 0 .and. ::nRowDividerStyle == 0 )
         DrawHorz( hDC, nRow + nHeight - 1, 0, nBrwWidth, hHeaderPen  )
      endif
   else
      DrawHorz( hDC, nRow + nHeight, 0, nBrwWidth, hGrayPen  )
   endif

   if ::nBarHdr > 0
      if ::lFlatStyle
         DrawHorz( hDC, nRow + nFullHeight - 1, 0, nBrwWidth, hHeaderPen  )
      else
         DrawHorz( hDC, nRow + nFullHeight, 0, nBrwWidth, hGrayPen  )
      endif
   endif

   if ::hRightCol != nil
      ::hRightCol:PaintHeader( nRow, ::GridWidth() + 1, nHeight, .f., hDC )
      nCol  := ::GridWidth()
      if ::lFlatStyle
         DrawVert( hDC, nCol - 2,       nRow,     nRow + nFullHeight - 1, hHeaderPen )
      else
         DrawVert( hDC, nCol - 2,       nRow,     nRow + nFullHeight - 0, hGrayPen  )
         DrawVert( hDC, nCol - 1,       nRow,     nRow + nFullHeight - 0, hWhitePen )
      endif
   endif

   DeleteObject( hBrush )
   DeleteObject( hHeaderPen )

return nil

//------------------------------------------------------------------//

METHOD PaintFooter( hDC, aCols, nLast, nGridWidth, nBrwHeight, hWhitePen, hGrayPen ) CLASS TXBrowse

   local nRow, nCol, nFor, oCol
   local nHeight, hBrush, aColors, hPen
   local nBrwWidth := ::BrwWidth()

   if ::bPaintFooter != nil
      return Eval( ::bPaintFooter, Self, hDC, aCols, nLast, nGridWidth, nBrwHeight, hWhitePen, hGrayPen )
   endif

   nHeight  := ::nFooterHeight - 3 // Caution: Do not change -3 in a haste. This adjusts 3 pixels added in Adjust method
   nRow     := nBrwHeight - ::nFooterHeight
   aColors  := Eval( ::bClrFooter )
   hPen     := CreatePen( PS_SOLID, 1, If( Len( aColors ) >= 3, aColors[ 3 ], aColors[ 1 ] ) )

   if ::lFlatStyle
      if !( ::nHeadDividerStyle == 0 .and. ::nRowDividerStyle == 0 )
         DrawHorz( hDC, nRow, 0, nBrwWidth, hPen )
         nRow++
      else
         nHeight  += 2
      endif
   else
      DrawHorz( hDC, nRow, 0, nBrwWidth, hGrayPen )
      nRow++
      DrawHorz( hDC, nRow, 0, nBrwWidth, hWhitePen )
      nRow++
      DrawHorz( hDC, nRow + nHeight, 0, nBrwWidth, hGrayPen )
   endif
   hBrush  := CreateColorBrush( aColors[ 2 ] )
//   FillRect( hDC, { nRow, 1, nRow + nHeight, nGridWidth}, ::hBrushRecSel ) // col 0 is painted with vert line. So paint has to start at col 1 ( not col 0 )

   FillRect( hDC, { nRow, 1, nRow + nHeight + 1, nBrwWidth}, hBrush )
   DeleteObject( hBrush )

   if ::lRecordSelector .and. ::bRecSelFooter != nil
      ::SayText( cValToChar( XEval( ::bRecSelFooter, Self ) ), { nRow, 2, nRow + nHeight, ;
         ::nRecSelWidth - nBmpWidth( ::hBmpRecSel ) - 11 }, 'R', ;
                 IfNil( ::oRecSelFont, ::oFont ) )
   endif

   for nFor := 1 to nLast
      nCol := aCols[ nFor ]
      oCol := ::ColAtPos( nFor )
      if ::lFlatStyle
//       DrawVert( hDC, nCol - 2, nRow + 1, nRow + nHeight - 2, hPen ) //till 16.03
         if !( ::nHeadDividerStyle == 0 .and. ::nColDividerStyle == 0 )
            DrawVert( hDC, nCol - 2, nRow,     nRow + nHeight + 1, hPen ) //from 16.04
         endif
      else
//       DrawVert( hDC, nCol - 2, nRow + 1, nRow + nHeight - 2, hGrayPen )
//       DrawVert( hDC, nCol - 1, nRow + 1, nRow + nHeight - 2, hWhitePen )
         DrawVert( hDC, nCol - 2, nRow,     nRow + nHeight - 0, hGrayPen )
         DrawVert( hDC, nCol - 1, nRow,     nRow + nHeight - 0, hWhitePen )
      endif
      oCol:PaintFooter( nRow, nCol, nHeight )
   next
   nCol := aCols[ nFor ]

   if ::l2000 .and. ::lGradientComplete
      GradientFill( hDC, nRow - 0, nCol, nRow + nHeight - 1, nBrwWidth, ;
               Eval( ::bClrGrad, .f. ) )
   endif

   if ::lFlatStyle
//    DrawVert( hDC, nCol - 2, nRow + 1, nRow + nHeight - 2, hPen )
      if nCol <= nGridWidth
         if !( ::nHeadDividerStyle == 0 .and. ::nColDividerStyle == 0 )
            DrawVert( hDC, nCol - 2, nRow,     nRow + nHeight + 1, hPen )
         endif
      endif
      if !( ::nHeadDividerStyle == 0 .and. ::nRowDividerStyle == 0 )
         DrawHorz( hDC, nRow + nHeight + 1, 0, nBrwWidth, hPen )
      endif
   else
//    DrawVert( hDC, nCol - 2, nRow + 1, nRow + nHeight - 2, hGrayPen )
//    DrawVert( hDC, nCol - 1, nRow + 1, nRow + nHeight - 2, hWhitePen )
      if nCol <= ::GridWidth()
         DrawVert( hDC, nCol - 2, nRow,     nRow + nHeight - 0, hGrayPen )
         DrawVert( hDC, nCol - 1, nRow,     nRow + nHeight - 0, hWhitePen )
      endif
   endif

   if ::hRightCol != nil
      ::hRightCol:PaintFooter( nRow, ::GridWidth() + 1, nHeight )
      nCol  := ::GridWidth()
      if ::lFlatStyle
         DrawVert( hDC, nCol - 2, nRow,     nRow + nHeight + 1, hPen ) //from 16.04
      else
         DrawVert( hDC, nCol - 2, nRow,     nRow + nHeight - 0, hGrayPen )
         DrawVert( hDC, nCol - 1, nRow,     nRow + nHeight - 0, hWhitePen )
      endif
   endif

   DeleteObject( hPen )

return nil

//------------------------------------------------------------------//

METHOD RefreshCurrent() CLASS TXBrowse

   local uVal

   // When append or delete, but this may slow down for RDD
   // Let the programmer call Refresh
   //
   if ::lRelyOnKeyNo
      if Eval( ::bKeyCount ) != ::nLen
         return ::Refresh()
      endif
   endif

   if ::oSortCol != nil
      uVal  := ::oSortCol:Value
      if !( ValType( uVal ) == ValType( ::uSortVal ) .and. ;
            uVal == ::uSortVal )

         return ::Refresh()
      endif
   endif

return ::DrawLine( .t. )

//----------------------------------------------------------------------------//

METHOD DrawLine( lSelected, nRowSel ) CLASS TXBrowse

   local oCol
   local nRow, nCol, nFor, nLast, nHeight, nStyle, nWidth,;
         nColStyle, nTemp, nHt, nDataHeight, nRight
   local hDC, hBrush, hWhitePen, hColPen
   local lHighLite

   if !::lScreenUpdating
      return nil
   endif

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
   nRow        := ( ( nRowSel - 1 ) * nHeight ) + ::FirstRow()
   if nRow > ::LastRow()
      return nil
   endif

   hDC       := ::GetDC()
   nLast     := ::LastDisplayPos()
   nStyle    := ::nMarqueeStyle

   lHighLite := ( nStyle >= MARQSTYLE_HIGHLROWRC .and. lSelected ) // Why this line ?????

   if ::lMultiSelect .and. ( nStyle == MARQSTYLE_HIGHLROWMS .or. ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7 )

      lHighLite := ( Ascan( ::aSelected, Eval( ::bBookMark ) ) > 0 )
   endif
/*
   lHighLite := ( nStyle >= MARQSTYLE_HIGHLROWRC .and. lSelected )

   if nStyle == MARQSTYLE_HIGHLROWMS .or. ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7
      lHighLite := ( Ascan( ::aSelected, Eval( ::bBookMark ) ) > 0 )
   endif
*/

   if Eval( ::bPaintRow, Self, nRow, ::ColAtPos ( 1 ):nDisplayCol, nDataHeight, lHighLite, lSelected, nRowSel )
      for nFor := 1 to nLast
         oCol := ::ColAtPos ( nFor )
         oCol:PaintData( nRow, nil, nDataHeight, lHighLite, lSelected, nFor, nRowSel )
      next
      if ::oRightCol != nil
         ::oRightCol:PaintData( nRow, nil, nDataHeight, lHighLite, lSelected, ::oRightCol:nPos, nRowSel )
      endif
   else
      oCol  := ::ColAtPos( nLast )
   endif

   if nStyle >= MARQSTYLE_HIGHLROWRC .and. nStyle != MARQSTYLE_HIGHLWIN7
      nColStyle := ::nColDividerStyle
      nCol      := oCol:nDisplayCol + oCol:nWidth + 2
      nWidth    := ::GridWidth() - 2
      if nColStyle < LINESTYLE_INSET
         nCol--
         nWidth++
      endif
      nTemp := nRow + nDataHeight
      if nCol < nWidth
         if lHighLite
            if ::hWnd == GetFocus()
               hBrush := CreateColorBrush( Eval( If( ::bClrRowFocus == nil, ::bClrSelFocus, ::bClrRowFocus ) )[ 2 ] )
            else
               hBrush := CreateColorBrush( Eval( ::bClrSel )[ 2 ] )
            endif
         else
            hBrush := CreateColorBrush( Eval( ::bClrStd )[ 2 ] )
         endif
         if lHighLite .or. ! ::lTransparent
            if ::oRightCol == nil
               FillRect( hDC, {nRow, nCol, nTemp, nWidth + 1 }, hBrush )
            else
               FillRect( hDC, {nRow, nCol, nTemp, nWidth - 1 }, hBrush )
            endif
         endif
         DeleteObject( hBrush )
      endif
      if nStyle == MARQSTYLE_HIGHLROWMS
         nCol := iif(::lRecordSelector, ::nRecSelWidth - 1, 0 )
         if lSelected
            FrameDot(hDC, nRow, nCol, nRow + nDataHeight - 1, nWidth - 1)
         elseif nColStyle > 0 // We have to FullPaint the line cols :-((
            hColPen   := ::hColPen
            hWhitePen := ::hWhitePen
            for nFor := 1 to nLast
               oCol := ::ColAtPos ( nFor )
               nCol := oCol:nDisplayCol + oCol:nWidth
               if nColStyle != LINESTYLE_RAISED
                  DrawVert( hDC, nCol, nRow, nRow + nDataHeight, hColPen )
               else
                  DrawVert( hDC, nCol,     nRow, nRow + nDataHeight, hWhitePen )
                  DrawVert( hDC, nCol + 1, nRow, nRow + nDataHeight, hColPen   )
               endif
               if nColStyle = LINESTYLE_INSET
                  DrawVert( hDC, nCol + 1, nRow, nRow + nDataHeight, hWhitePen )
               endif
            next
            /*
            if ::oRightCol != nil
               ::PaintVDivider( hDC, ::GridWidth(), nRow, nRow + nDataHeight, nColStyle, hColPen, hWhitePen )
            endif
            */
         endif
      endif
   endif

   if ::lRecordSelector

      nTemp    := nBmpWidth(  ::hBmpRecSel )
      nHt      := nBmpHeight( ::hBmpRecSel )

      if ::bRecSelData != nil
         FillRect( hDC, { nRow + 1, 2, nRow + nDataHeight - 1 , ::nRecSelWidth - 3 }, ::hBrushRecSel )

         ::SayText( cValToChar( Eval( ::bRecSelData, Self ) ), { nRow, 0, nRow + nHeight, ;
                     ::nRecSelWidth - 5 - nTemp - 6 }, 'R', ;
                     IfNil( ::oRecSelFont, ::oFont ) )
         if lSelected .and. ! Empty( ::hBmpRecSel )

            PalBmpDraw( hDC, nRow + ( nHeight / 2 ) - nHt / 2 - 1, ;
                        ::nRecSelWidth - nTemp - 6,;
                        ::hBmpRecSel, 0, nTemp, nHt,, .t., ::nRecSelColor )

         endif
      else
         if lSelected .and. ! Empty( ::hBmpRecSel )
            PalBmpDraw( hDC, nRow + ( nHeight / 2 ) - nHt / 2 - 1, ;
                        ::nRecSelWidth - nTemp - 6,;
                        ::hBmpRecSel, 0, nTemp, nHt,, .t., ::nRecSelColor )

         else
            FillRect( hDC, { nRow + 1, ;
               ::nRecSelWidth - nTemp - 6, ;
               nRow + nDataHeight - 1 ,;
               ::nRecSelWidth - 3 }, ::hBrushRecSel )
         endif
      endif
   endif

   if lSelected
      nHeight -= 2
      oCol := ::ColAtPos( ::nColSel )
      if Eval( ::bPaintRow, Self, nRow, ::ColAtPos ( 1 ):nDisplayCol, nDataHeight, lHighLite, lSelected, nRowSel, ;
                  ::nColSel, oCol )
         do case
         case nStyle == MARQSTYLE_DOTEDCELL
            oCol:Box( nRow, nil, nDataHeight, 1 )
         case nStyle == MARQSTYLE_SOLIDCELL
            oCol:Box( nRow, nil, nDataHeight, 2 )
         case nStyle == MARQSTYLE_HIGHLCELL
            oCol:PaintData( nRow, nil, nDataHeight, .t., .t. , ::nColSel, nRowSel )
         case nStyle == MARQSTYLE_HIGHLROWRC
            oCol:Box( nRow, nil, nDataHeight, 3 )
         case nStyle == MARQSTYLE_HIGHLWIN7
            oCol     := ::ColAtPos( nLast )
            nLast    := Min( oCol:nDisplayCol + oCol:nWidth, ::GridWidth() )
            RoundBox( hDC, 2, nRow - 1, nLast - 1, nRow + nDataHeight,     2, 2,;
                      RGB( 235, 244, 253 ), 1 )
            RoundBox( hDC, 1, nRow - 2, nLast,     nRow + nDataHeight + 1, 2, 2,;
                      RGB( 125, 162, 206 ), 1 )

         endcase
      endif
   endif

   ::ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD EraseData( nRow ) CLASS TXBrowse

   local oCol
   local nLast, nFor, nHeight, nCol
   local hDC, oBrush

   if ::lTransparent .and. Empty( ::oBrush:hBitmap )
      oBrush      := ::oWnd:oBrush
   else
      oBrush      := ::oBrush
   endif

   hDC     := ::GetDC()
   nHeight := ::BrwHeight() - ::FooterHeight() - nRow

   if ! ::lColDividerComplete
      nCol := 0
      if ::lRecordSelector
         nCol += ::nRecSelWidth
      endif
      FillRect( hDC, { nRow, nCol, nRow + nHeight, ::GridWidth() }, oBrush:hBrush )
   else
      nLast   := ::LastDisplayPos()

      if ! ::lTransparent              // WATCH OUT HERE
         for nFor := 1 to nLast
            oCol := ::ColAtPos( nFor )
            oCol:EraseData( nRow, , nHeight, ::oBrush:hBrush, .t. )
         next
         if ::nMarqueeStyle > MARQSTYLE_HIGHLCELL .and. nLast == Len( ::aDisplay )
            nCol := oCol:nDisplayCol + oCol:nWidth + 1
            FillRect( hDC, { nRow, nCol, nRow + nHeight, ::GridWidth() }, oBrush:hBrush )
         endif
      endif
   endif

   if ::lRecordSelector .and. ::nRowDividerStyle > LINESTYLE_NOLINES
      FillRect( hDC, { nRow, 2, nRow + nHeight, ::nRecSelWidth - 3 }, ::hBrushRecSel )
   endif

   ::ReleaseDC()

return nil

//---------------------------------------------------------------------------//
METHOD oCol( u ) CLASS TXBrowse

   local nAt   := AScan( ::aCols, { |o| o == u } )

return If( nAt > 0, ::aCols[ nAt ], nil )
//----------------------------------------------------------------------------//

METHOD GetDisplayCols() CLASS TXBrowse

   local oCol
   local aDisplay
   local nFor, nLen, nOffset, nFreeze, nCol, nCols
   local lRightCol

   // Protection against the programmer deleting all columns
   if Empty( ::aCols )
      ::aCols     := {}
      WITH OBJECT ::AddCol()
         :cHeader    := "Empty Col"
         :bEditValue := { || "Empty Col" }
         :Adjust()
      END
   endif
   //

   if ::oRightCol != nil
      if ::oRightCol:lHide
         ::oRightCol := nil
      endif
   endif
   lRightCol := ::oRightCol != nil .and. ::nColSel == ::oRightCol:nPos

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
      if ! oCol:lHide .and. !( oCol == ::hRightCol )
         AAdd( aDisplay, nCol )
         oCol:nPos := Len( aDisplay )
         nFreeze--
      endif
      nCol++
   enddo

   nCol := Max( nCol, nOffset )

   do while nCol <= nLen
      oCol := ::aCols[ nCol ]
      if ! oCol:lHide .and. !( oCol == ::hRightCol )
         AAdd( aDisplay, nCol )
         oCol:nPos := Len( aDisplay )
      endif
      nCol++
   enddo

   if ::hRightCol != nil
      ::hRightCol:nPos  := Len( aDisplay ) + 1
   endif

   // protection against the programme hiding all columns
   if Empty( aDisplay )
      ::aCols[ 1 ]:lHide   := .f.
      aDisplay             := { 1 }
   endif
   //

   ::aDisplay := aDisplay

   if lRightCol
      ::nColSel   := ::oRightCol:nPos
   else
      ::nColSel  := Min( Len( ::aDisplay ), ::nColSel )
   endif

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
      nWidth := ::nRecSelWidth
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
      nWidth := ::nRecSelWidth
   else
      nWidth := 0
   endif

   for nFor := 1 to nPos - 1
//      nWidth += ::ColAtPos( nFor ):nWidth + COL_SEPARATOR
      nWidth += ::ColAtPos( nFor ):nWidth // + COL_SEPARATOR // testing this modification 2016-04-24
   next

   if lcomplete
      nWidth += ::ColAtPos( nPos ):nWidth + COL_SEPARATOR

//    2008-03-30
//      if nWidth > ::GridWidth() && By Rossine - Reajusta a largura da coluna
//         ::ColAtPos( nPos ):nWidth -= ( nWidth - ::GridWidth() + COL_SEPARATOR )
//      endif

   endif

return ( nWidth  < ::GridWidth() )

//---------------------------------------------------------------------------//

METHOD LastDisplayPos( lComplete ) CLASS TXBrowse

   local nWidth, nMaxWidth, nPos, nLen

   DEFAULT lComplete := .f.

   nPos      := 1
   nMaxWidth := ::GridWidth()
   nLen      := Len( ::aDisplay )

   if ::lRecordSelector
      nWidth := ::nRecSelWidth
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
/*
   if ::nStretchCol == STRETCHCOL_LAST .and. nPos = nLen
      if nWidth < nMaxwidth
          ::ColAtPos( nPos ):nWidth += ( nMaxWidth - nWidth - COL_SEPARATOR  ) + if( ::lRecordSelector, 1, 0 )
      elseif nWidth > nMaxwidth
          ::ColAtPos( nPos ):nWidth -= ( nWidth - nMaxWidth + COL_SEPARATOR  ) - if( ::lRecordSelector, 1, 0 )
      endif
   endif
*/

return nPos

//---------------------------------------------------------------------------//

METHOD ColStretch( nStretchCol ) CLASS TXBrowse

   local aSizes, nDispWidth, nGridWidth, oCol, nLen, n, o
   local nMaxWidth   := 0

   if ! ::lAdjusted
      return nil
   endif

   if ::aStretchInfo != nil
      for n := 1 to Len( ::aCols )
         if ::aCols[ n ]:nCreationOrder == ::aStretchInfo[ 1 ]
            ::aCols[ n ]:nWidth  := ::aStretchInfo[ 2 ]
            exit
         endif
      next
      ::aStretchInfo := nil
   endif

   DEFAULT nStretchCol := ::nStretchCol

   if nStretchCol != STRETCHCOL_NONE
      nDispWidth  := ::GetDisplayColsWidth( @aSizes )
      nGridWidth   := ::GridWidth()

      if nDispWidth < nGridWidth

         if ::oRightCol != nil .and. ;
            ( ::nStretchCol == STRETCHCOL_LAST .or. ::nStretchCol == ::oRightCol:nPos )

            ::oRightCol:nWidth := ::BrwWidth() - nDispWidth
         else

            nLen        := Len( ::aDisplay )
            do case
            case ::nStretchCol > 0
               if ( n  := AScan( ::aDisplay, { |nCol| ::aCols[ nCol ]:nCreationOrder == ::nStretchCol } ) ) > 0
                  oCol     := ::aCols[ ::aDisplay[ n ] ]
               endif
            case ::nStretchCol == STRETCHCOL_LAST
               oCol        := ::aCols[ ::aDisplay[ nLen ] ]
            case ::nStretchCol == STRETCHCOL_WIDEST
               for n := nLen to 1 step -1
                  o        := ::aCols[ ::aDisplay[ n ] ]
                  if o:cDataType != nil .and. o:cDataType $ 'FMP'
                     oCol  := o
                     exit
                  elseif o:cDataType == 'C' .or. o:cDataType == nil
                     if o:nWidth > nMaxWidth
                        nMaxWidth   := o:nWidth
                        oCol        := o
                     endif
                  endif
               next n
               if oCol == nil
                  oCol     := ::aCols[ ::aDisplay[ nLen ] ]
               endif
            endcase
         endif
      endif

      if oCol != nil
         ::aStretchInfo    := { oCol:nCreationOrder, oCol:nWidth }
         oCol:nWidth       += ( nGridWidth - nDispWidth - 1 )

         if ! Empty( oCol:aRows )
            AEval( oCol:aRows, { |o| o:nWidth := oCol:nWidth } )
         endif

         ::GetDisplayCols()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD KeyDown( nKey, nFlags ) CLASS TXBrowse

   local oCol, uRet

   if ! ::lScreenUpdating
      return ::Super:KeyDown( nKey, nFlags )
   endif

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
           return ::Super:KeyDown( nKey, nFlags )
        endif

   case nKey == VK_LEFT  .and. GetKeyState( VK_SHIFT ) .or. ;
        nKey == VK_RIGHT .and. GetKeyState( VK_SHIFT )
        return ::Super:KeyDown( nKey, nFlags )

     case nKey == VK_UP .and. GetKeyState( VK_SHIFT )
        ::Select( 5 )
        ::GoUp()
        ::Select( 5 )

     case nKey == VK_DOWN .and. GetKeyState( VK_SHIFT )
        ::Select( 5 )
        ::GoDown()
        ::Select( 5 )

   case nKey == VK_UP .and. !GetKeyState( VK_CONTROL )
      if ::KeyNo == 1 .and. ::lRelyOnKeyNo
         return 0
      endif
      ::Select( 0 )
      ::GoUp()
      ::Select( 1 )

   case nKey == VK_DOWN .and. !GetKeyState( VK_CONTROL )
      if ::KeyNo == ::nLen .and. Empty( ::bPastEof ) .and. ::lRelyOnKeyNo
         return 0
      endif
      ::Select( 0 )
      ::GoDown( 1, VK_DOWN )
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

//   case ( nKey == VK_ADD .or. nKey == 187 ) .and. GetKeyState( VK_CONTROL )
   case nKey == VK_ADD .and. GetKeyState( VK_CONTROL )
         ::FontSize( +1 )
         ::Refresh()

//   case ( nKey == VK_SUBTRACT .or. nKey == 189 ) .and. GetKeyState( VK_CONTROL )
   case nKey == VK_SUBTRACT .and. GetKeyState( VK_CONTROL )
         ::FontSize( -1 )
         ::Refresh()

   case ::lAllowCopy .and. nKey == ASC( 'C' ) .and. GetKeyState( VK_CONTROL )
         ::Copy()

   case nKey == VK_F2 .and. ::lF2KeyToEdit .and. ! ::lReadOnly
        if ! ::lEditMode
            WITH OBJECT ::SelectedCol()
               if ! :lReadOnly
                  :Edit()
               endif
            END
        endif

   case ::lTabLikeExcel .and. nKey == VK_TAB

         if GetKeyState( VK_CONTROL )
            ::GoRightMost()
         else
            ::GoRight()
         endif

   case ( oCol := ::SelectedCol() ):bKeyDown != nil
      uRet  := Eval( oCol:bKeyDown, nKey, nFlags, Self, oCol )
      if ValType( uRet ) == 'N' .and. uRet == 0
         return 0
      endif
      return ::Super:KeyDown( nKey, nFlags )

   otherwise

      return ::Super:KeyDown( nKey, nFlags )

   endcase

return 0

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey, nFlags ) CLASS TXBrowse

   local bKeyChar
   local oCol, cKey, uRet
   local uClip, nFormat

   oCol := ::SelectedCol()
   if oCol:lAutoSave
      if oCol:oEditGet != nil
         oCol:oEditGet:SetFocus()
         return 0
      endif
   endif

//   if ::bKeyChar != nil
   if ( bKeyChar := IfNil( oCol:bKeyChar, ::bKeyChar ) ) != nil // 2014-10-18
      uRet  := Eval( bKeyChar, @nKey, nFlags, Self, oCol )
      if ::lEditMode
         return nil
      endif
      if ValType( uRet ) == 'N' .and. uRet == 0
         return 0
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
         elseif oCol:lEditable .and. ! oCol:hChecked .and. ::lEnterKey2Edit .and. ! ( oCol:nEditType == EDIT_LISTBOX )
            return oCol:Edit()
         elseif oCol:nEditType == EDIT_LISTBOX .and. oCol:lEditable
            //Simulate Click over button for no lost focus
            PostMessage( oCol:oBtnList:hWnd, WM_LBUTTONDOWN, 1, 1 )
            PostMessage( oCol:oBtnList:hWnd, WM_LBUTTONUP, 1, 1 )
         elseif ::oTreeItem!=nil
            If( ::oTreeItem:oTree != nil,( ::oTreeItem:Toggle(), ::Refresh() ),)
         else
            ::GoRight()
         endif
/*
      // 2015-03-04: K_PGUP and K_PGDN represent Ctrl-R and Ctrl-C
      // So the following lines do not serve the purported purpose but
      // on the other hand mask Ctrl-R and Ctrl-C as well as raising
      // run-time error when oVScroll is nil. So Commented Out

      case nKey == K_PGUP
         ::oVScroll:PageUp()

      case nKey == K_PGDN
         ::oVScroll:PageDown()
*/
      case ::lCanPaste .and. nKey == 22  // Ctrl-V

         if oCol:nEditType > 0
            ::Paste()
         endif

      case ::lMultiSelect .and. nKey == 1  // Ctrl-A
         ::SelectAll()

      otherwise

         cKey := Chr( nKey )
         oCol := ::SelectedCol()
         if nKey == 32 .and. ::nMarqueeStyle <= MARQSTYLE_HIGHLROWRC .and. ;
                     oCol:hChecked .and. oCol:lEditable

            oCol:CheckToggle()

         elseif ( ::lFastEdit .or. nKey == Asc( '=' ) ) .and. ;
            ( ::nMarqueeStyle <= MARQSTYLE_HIGHLROWRC .or. ::bClrRowFocus != nil ) .and. ;
            oCol:lEditable .and. oCol:IsEditKey( nKey ) //cKey )

            oCol:Edit( nKey )

         else
//            If nKey == VK_BACK .and. !Empty( ::cSeek ) // Backspace not working when ::cSeek is Space(n)

            if oCol:oBarGet != nil .and. oCol:lBarGetOnKey .and. !::lFastEdit .and. oCol:IsEditKey( nKey )
               oCol:oBarGet:SetFocus()
               oCol:oBarGet:PostMsg( WM_CHAR, nKey )
               return 0
            endif

            If nKey == VK_BACK .and. ::cSeek != nil .and. Len( ::cSeek ) > 0
               if ::lUnicode .or. FW_SetUnicode()
                  ::Seek( HB_UTF8LEFT( ::cSeek, HB_UTF8LEN( ::cSeek ) - 1 ) )
               else
                  ::Seek( Left( ::cSeek, Len( ::cSeek ) -1 ) )
               endif
            elseIf nKey > 31 .and. nKey != Asc( '*' ) .and. nKey != Asc( '?' )
               DEFAULT ::cSeek := ""
               if ::lUnicode .or. FW_SetUnicode()
                  ::Seek( ::cSeek + HB_UTF8CHR( nKey ) )
               else
                  ::Seek( ::cSeek + cKey )
               endif
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
      // While browsing single column, nPos can be 2 because
      // hScroll range was set to 1 to 2.
      // setting range 1..1 hides the thumbpos
      // Hence limit nPos to len(::aCols)
      ::SelectCol( Min( nPos, Len( ::aCols ) ), .t. )    // 2011-10-13

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
   if ::oHScroll != nil
      ::oHScroll:SetPos( nCol )
   endif

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

METHOD GoToCol( oCol ) CLASS TXBrowse

   local nPos, nCol

   oCol     := ::oCol( oCol )
   if oCol == nil .or. oCol:lHide
      return .f.
   endif

   if oCol:nPos > 0
      if ::IsDisplayPosVisible( oCol:nPos, .t. )
         if ::nColSel != oCol:nPos
            ::nColSel   := oCol:nPos
            ::DrawLine( .t. )
            //::RefreshCurrent()
         endif
         return .t.
      elseif oCol:nPos <= ::nFreeze + ::nColOffSet
         return .f.
      else
         do while ! ::IsDisplayPosVisible( oCol:nPos, .t. ) .and. ;
            oCol:nPos > ::nFreeze + ::nColOffSet

            ::nColOffSet++
            ::GetDisplayCols()
         enddo
      endif
   else
      nCol  := AScan( ::GetVisibleCols(), { |o| o:nCreationOrder == oCol:nCreationOrder } )
      ::nColOffSet   := nCol - ::nFreeze
      ::GetDisplayCols()
   endif

   ::nColSel      := oCol:nPos
   ::Refresh()

return .t.

//----------------------------------------------------------------------------//

METHOD GoLeft( lOffset, lRefresh )  CLASS TXBrowse

   local oFirstCol

   DEFAULT lOffset  := .f.,;
           lRefresh := .t.

   ::CancelEdit()

   if ::oRightCol != nil .and. ::oRightCol:nPos == ::nColSel
      ::GoRightMost()
      return nil
   endif

   if ::nMarqueeStyle == MARQSTYLE_NOMARQUEE  .or. ( ::nMarqueeStyle >= MARQSTYLE_HIGHLROW .and. ::bClrRowFocus == nil )
      lOffset := .t.
   endif

   if ( ::lLockFreeze .or. ::lFreezeLikeExcel ) .and. ::nFreeze > 0 .and. ::nColOffSet > 1 .and. ::nColSel == ::nFreeze + 1
      lOffset := .t.
   endif

   if ( !lOffset .and. ::IsDisplayPosVisible( ::nColSel - 1 ) ) .or. ;
      ( ::nColOffset == 1 .and. ::nColSel > 1 )

      if ::nColSel > If( ::lLockFreeze, ::nFreeze, 0 ) + 1
         ::nColSel--
         if lRefresh
            if ::FullPaint()
               ::Super:Refresh( .t. )
            else
               ::DrawLine( .t. )
            endif
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

   local oCol, oLastCol, oSelCol, oNextCol
   local nLen

   ::CancelEdit()

   oLastcol    := ::aCols[ ATail( ::aDisplay ) ]

/*
   if ::SelectedCol():nCreationOrder == oLastCol:nCreationOrder
      return nil
   endif
*/

   oSelCol     := ::SelectedCol()
   if oSelCol == ::hRightCol
      return nil
   elseif oSelCol == oLastCol
      if ::hRightCol != nil
         ::nColSel   := ::hRightCol:nPos
         ::GetDisplayCols()
         ::DrawLine( .t. )
         return nil
      else
         return nil
      endif
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
#ifdef UPTO1709
      // Results in full refresh everytime
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
#else
      ::nColSel++
      lRefresh := .f.
      ::GetDisplayCols()
      oCol     := ::SelectedCol()
      do while ! ::IsDisplayPosVisible( oCol:nPos, .t. ) .and. ::nColSel > ( ::nFreeze + 1 )
         ::nColOffSet++
         ::nColSel--
         ::GetDisplayCols()
         lRefresh := .t.
      enddo

      if lRefresh
         ::Super:Refresh( ::FullPaint() )
      else
         ::RefreshCurrent()
      endif
#endif

   endif

//   if ::lHScroll
   if ::oHScroll != nil
      ::oHScroll:GoDown()
   endif

   ::Change( .f. )

return nil

//----------------------------------------------------------------------------//

METHOD GoFirstEditCol() CLASS TXBrowse

   local nNextPos, n

   ::CancelEdit()

   ::nColSel := 1
   ::nColOffset := 1
   ::GetDisplayCols()

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

   if ::oHScroll != nil
      ::oHScroll:SetPos( ::nColSel )
   endif

   ::Change( .f. )

return ::SelectedCol()

//----------------------------------------------------------------------------//

METHOD GoLeftMost()  CLASS TXBrowse

   ::CancelEdit()

//   ::nColSel := 1
   ::nColSel   := If( ::lLockFreeze, ::nFreeze, 0 ) + 1
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

      case nScrollCode == SB_THUMBPOSITION .or. ( ::lVThumbTrack .and. ;
           nScrollCode == SB_THUMBTRACK )
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
            Eval( ::bSkip, ::VGetThumbPos( nPos ) - ::VGetPos() )
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

               XBrwScrollRow( ::hWnd, -::nRowHeight, ::FirstRow(), ::RowCount() * ::nRowHeight )
               if n < nUp
                  ::DrawLine( .f. )
               endif

               nHeight := ::BrwHeight() - ::FooterHeight() - ::FirstRow()
               If nHeight % ::nRowHeight > 0
                  // ::EraseData( ( ( Int(nHeight/::nRowHeight) + 1 ) * ::nRowHeight ) + 10 )
                  ::EraseData( ::FirstRow() + ::nRowHeight * ::RowCount() )
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

METHOD GoDown( nDown, nKey ) CLASS TXBrowse

   local nLines, n, oCol, nAt

   if ::nLen == 0 .or. ::Eof()
      if ::bPastEof != nil
         Eval( ::bPastEof, Self, IfNil( nKey, 0 ) )
      endif
      // return nil
      return 0 // need to return numeric value, 2014-02-13
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

      if ::Skip( 1 ) == 1
         if ::nRowSel < nLines
            ::nRowSel++
         else

            if ! ::FullPaint()
               XBrwScrollRow( ::hWnd, ::nRowHeight, ::FirstRow(), nLines * ::nRowHeight )
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
            Eval( ::bPastEof, Self, nKey )
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

return nDown      // return number of rows actually skipped

//----------------------------------------------------------------------------//

METHOD PageUp( nLines ) CLASS TXBrowse

   local nSkipped

   if ::nLen < 1
      return nil
   endif

   DEFAULT nLines := ::RowCount()

   ::CancelEdit()
   ::Seek()
*   ::DrawLine()

   nSkipped = ::Skip( -nLines )

   if nSkipped = 0
*      ::DrawLine(.t.)
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

   local nSkipped

   if ::nLen < 1
      return nil
   endif

   DEFAULT nLines := ::RowCount()

   ::CancelEdit()
   ::Seek()

   nSkipped := ::Skip( nLines )
   if nSkipped > 0
      ::Change( .t. )
      if nSkipped < nLines // .and. nSkipped <= ( ::nDataRows - ::nRowSel )
         ::Refresh()
         if ::oVScroll != nil
            ::VGoBottom()
         endif
      else
         //::Super:Refresh( ::FullPaint() )
         ::Refresh()    // Refresh is called for adjusting fullscreen fwh13.04
         if ::oVScroll != nil
            ::VSetPos( ::VGetPos() + nSkipped )
         endif
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TXBrowse

   if ::Bof() .or. ::nLen < 1
      return nil
   endif

   ::CancelEdit()
   ::Seek()

   Eval( ::bGoTop )

   if ::oVScroll != nil
      ::VGoTop()
   endif

   ::nRowSel := 1
   ::Change( .t. )

   ::Super:Refresh( .f. )

return nil

//----------------------------------------------------------------------------//

METHOD GoBottom() CLASS TXBrowse

   local nLines, nRow, nBook

   ::CancelEdit()
   ::Seek()
   ::DrawLine()

   if ::Eof() .or. ::nLen < 1
      ::DrawLine( .t. )
      return nil
   endif

   Eval( ::bGoBottom )
   if ::lRelyOnKeyNo
      ::nRowSel      := Max( 1, Min( ::nLen, ::RowCount() ) )
   else
      nBook          := ::BookMark
      ::nRowSel      := 1 - ::Skip( 1 - ::RowCount() )
      ::BookMark     := nBook
   endif

   if ::oVScroll != nil
      ::VGoBottom()
   endif
   ::Change( .t. )
   //::Super:Refresh( .f. )
   ::Refresh()   // force keycount() again 2017-03-27

return nil

//----------------------------------------------------------------------------//

/*
METHOD ColPos( oCol )  CLASS TXBrowse

   local nAt

   nAt := Ascan( ::aDisplay, {|v| ::ColAtPos( v ):nCreationOrder == oCol:nCreationOrder } )

return nAt
*/

METHOD ColAtPos( nPos ) CLASS TXBrowse

   local oCol, nAt

   DEFAULT nPos := 1

   nPos     := Max( 1, nPos )
   nAt      := AScan( ::aCols, { |o| o:nPos == nPos } )
   if nAt > 0
      oCol  := ::aCols[ nAt ]
   else
      oCol  := ::aCols[ ATail( ::aDisplay ) ]
   endif

return oCol

//----------------------------------------------------------------------------//

METHOD MouseAtHeader( nRow, nCol ) CLASS TXBrowse

return ( ::MouseColPos( nCol ) > 0 .and. nRow < ::HeaderHeight() )

//----------------------------------------------------------------------------//

METHOD MouseAtFooter( nRow, nCol ) CLASS TXBrowse

return ( ::MouseColPos( nCol ) > 0 .and. nRow > ( ::BrwHeight() - ::FooterHeight() ) )

//----------------------------------------------------------------------------//

METHOD MouseRowPos( nRow ) CLASS TXBrowse

   local nRowPos, nTmp

   if nRow <= ::FirstRow()
      return 0
   endif

   nTmp    := nRow - ::FirstRow()
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
      nWidth := ::nRecSelWidth
   else
      nWidth := 0
   endif

   if nCol < nWidth
      return -1
   endif

   if nCol > nWidth
      if ::oRightCol != nil .and. nCol > ::GridWidth()
         nColPos  := ::oRightCol:nPos
      else
         for nFor := 1 to nLen
            nWidth += ::ColAtPos( nFor ):nWidth + COL_SEPARATOR
            if ( nWidth - COL_SEPARATOR ) > nCol
               nColPos := nFor
               exit
            endif
         next
      endif
   endif

return nColPos

//----------------------------------------------------------------------------//

METHOD SetPos( nRow, nCol, lPixel, bAction ) CLASS TXBrowse

   // If optional bAction is specified, the record is
   // temporarily moved to the new position, bAction is
   // evaluated and original position is restored

   local lRepos   := .f.
   local bm       := ::BookMark
   local nSkip    := 0
   local nRowSel  := ::nRowSel
   local nColSel  := ::nColSel
   local lMove    := Empty( bAction )

   if ::lEditMode
      return .f.
   endif

   DEFAULT lPixel := .f., lMove := .t.

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

      if nRow > 0 .and. nRow != ::nRowSel

         if lMove
            ::Seek()
            if ::lMultiSelect
               ::Select(0)
            endif
            SysRefresh()
            ::DrawLine()
         endif

         nSkip     := nRow - ::nRowSel
         if ::Skip( nSkip ) != nSkip
            ::BookMark  := bm
            nSkip := 0
         endif

      else
         if lMove .and. ::nColSel != nCol
            ::nColSel  := nCol
            lRepos      := .t.
         endif
      endif

      if ! lMove
         XEval( bAction, Self, nRow, nCol )
         ::BookMark  := bm
      else

         if nSkip != 0
            // row moved
            ::nRowSel   := nRow
            ::nColSel   := nCol
            lRepos      := .t.
            if ::lMultiSelect
               ::Select( 1 )
            endif

            if ::FullPaint()
               ::Super:Refresh( .t. ) // ::Paint()
            else
               ::DrawLine( .t. )
            endif
            if ::oVScroll != nil
               ::VSetPos( ::KeyNo() )
            endif
            ::Change( .t. )

         elseif lRepos

            ::DrawLine( .t. )

         endif

         if nSkip != 0 .or. lRepos
            ::Change( .t. )
            if ::oHScroll != nil
               ::oHScroll:SetPos( ::nColSel )
            endif
         endif

      endif

   elseif ! lMove
      XEval( bAction, Self, 0, 0 )
   endif

return nSkip != 0 .or. lRepos

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nFlags, lTouch ) CLASS TXBrowse

   local oCol, oPopUp
   local nRowPos, nColPos, nLen, nFor, nTmp, nPos
   local nRowPrev,nColPrev
   local nOldCol := ::nColSel

   if !::lScreenUpdating
      return 0
   endif

   ::nRowAdvance = ::MouseRowPos( nRow )
   ::nColAdvance = ::MouseColPos( nCol )
   ::nStartMRow  = ::nRowAdvance
   if ! ::lKinetic
      ::lKineticBrw  := .f.
   endif
   ::lPressed    = ::lKineticBrw .and. ::bDragBegin == nil
   ::nStartTime  = GetTickCount()

   ::CancelEdit()
   ::Seek()

   ::SetFocus()

   if ::lDrag
      return ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
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
         nPos := ( nFor * ::nRowHeight ) + ::HeaderHeight( .t. )
         if nRow >= ( nPos - 1 ) .and. nRow <= ( nPos + 1 )
            ::HorzLine( nRow, 1, nFor )
            return 0
         endif
      next
   endif

   nColPos := ::MouseColPos( nCol )

   if nColPos == 0 .and. ::nMarqueeStyle < MARQSTYLE_HIGHLROWRC
      ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
      return nil
   endif

   if nRow < ::HeaderHeight()
      if nColPos > 0
         oCol := ::ColAtPos( nColPos )
         if oCol != nil
            oCol:HeaderLButtonDown( nRow, nCol, nFlags, lTouch )
         else
            ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
         endif
         return nil
      elseif nCol < ::nRecSelWidth
         if ::bRecSelClick != nil
            oPopup := Eval( ::bRecSelClick, Self )
            if ValType( oPopUp ) == 'O' .and. oPopUp:IsKindOf( "TMENU" )
               oPopup:Activate( ::nHeaderHeight, 0, Self )
               return 0
            endif
            return oPopUp
         endif
      endif
   elseif nRow < ::HeaderHeight( .t. )
      //
   elseif nRow > ( ::BrwHeight() - ::FooterHeight() ) .and. nColPos > 0
      oCol := ::ColAtPos( nColPos )
      if oCol != nil
         oCol:FooterLButtonDown( nRow, nCol, nFlags, lTouch )
      else
         ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
      endif
      return nil
   else
      nTmp    := nRow - ::FirstRow()
      nRowPos := Int( nTmp / ::nRowHeight ) + 1
      if nRowPos > ::nDataRows .or. nRow < ::FirstRow()
         nRowPos := 0
      endif
      if nRowPos == 0
         ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
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
      if ::lMultiSelect    // ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS .or. ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7
         if !GetKeyState( VK_CONTROL ) .and. !GetKeyState( VK_SHIFT )
            ::Select( 0 )
         endif
      endif

 //     SysRefresh()
      ::DrawLine()

      if nRowPos > 0
         if ::lRelyOnKeyNo
            ::KeyNo  += ( nRowPos - ::nRowSel )
         else
            ::Skip( nRowPos - ::nRowSel )
         endif

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

      if ::lMultiSelect    // ::nMarqueeStyle == MARQSTYLE_HIGHLROWMS .or. ::nMarqueeStyle == MARQSTYLE_HIGHLWIN7
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
      ::Super:LButtonDown( nRow, nCol, nFlags, lTouch )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TXBrowse

   local nCaptured
   local nRowAdvanced, nTimeScrolled, nVelocity, nRowToAdvance
   local nRatio, n, cMsg := ""

   if ::lDrag
      return ::Super:LButtonUp( nRow, nCol, nFlags )
   endif

   if ::lPressed
      ::lPressed    = .F.
      ::nEndMRow    = ::MouseRowPos( nRow )
      ::nEllapsed   = GetTickCount()

      nRowAdvanced  = ::nEndMRow - ::nStartMRow
      nTimeScrolled = ( ::nEllapsed - ::nStartTime ) / 4000
      nTimeScrolled = If( nTimeScrolled == 0, 1, nTimeScrolled )

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
         case nCaptured == 4
              ::HorzLine( nRow, 2 )

         case ::oCapCol == nil
            // do not execute next lines

         case nCaptured == 1
              ::oCapCol:HeaderLButtonUp( nRow, nCol, nFlags )

         case nCaptured == 2
              ::oCapCol:FooterLButtonUp( nRow, nCol, nFlags )

         case nCaptured == 3
              ::oCapCol:ResizeEnd( nRow, nCol, nFlags )

      endcase
      ::oCapCol := nil
   endif

   ::Super:LButtonUp( nRow, nCol, nFlags )

return nil

//----------------------------------------------------------------------------//

METHOD MouseLeave( nRow, nCol, nFlags ) CLASS TXBrowse

   if ::lKineticBrw .and. ::lPressed
      ::lPressed = .f.
      ::Refresh()
   endif

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
      return ::Super:MouseMove( nRow, nCol, nKeyFlags )
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
      // temporarily moved here
      TrackMouseEvent( ::hWnd, TME_LEAVE )
      //
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
         ::nColSel := ::MouseColPos( nCol )
      elseif nHMove > 0
         ::nColSel := 1
         ::GoLeft()
         ::nColSel := ::MouseColPos( nCol )
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

   nFor  := ::MouseColPos( nCol )
   if nFor > 0 .and. nFor <= nLen
      // Column visible in window
      CursorArrow()
      oCol     := ::ColAtPos( nFor )
      if ! Empty( ::oColToolTip ) // There is an active tooltip
         if nMousePos != ::nRowToolTip .or. oCol != ::oColToolTip
            ::DestroyToolTip()
         endif
      endif
      if nRow < ::HeaderHeight()    // Mouse is on Header
         if ! Empty( oCol:cToolTip )
            ::ShowToolTip( nRow, nCol, oCol:cToolTip )
            ::oColToolTip     := oCol
            ::nRowToolTip     := 0
            //
            return 0
         endif
      elseif nMousePos > 0 // Row
//         if ::bDragBegin == nil .and. ! Empty( oCol:bToolTip ) // 2014-10-23 : Showing tooltip is not inconsistent with Drag oprn
         if ! Empty( oCol:bCellToolTip )
            Eval( ::bSkip, nMousePos - ::nRowSel )
            cTxt  := Eval( oCol:bCellToolTip, oCol )
            Eval( ::bSkip, ::nRowSel - nMousePos )
            if ! Empty( cTxt )
               ::ShowToolTip( nRow, nCol, cTxt )
               ::oColToolTip  := oCol
               ::nRowToolTip  := nMousePos
               return 0
            endif
         elseif ! Empty( oCol:bToolTip )
            if ! Empty( cTxt := Eval( oCol:bToolTip, Self, nRow, nCol, nkeyFlags, oCol, nMousePos ) )
               ::ShowToolTip( nRow, nCol, cTxt )
               ::oColToolTip  := oCol
               ::nRowToolTip  := nMousePos
               //
               return 0
            endif
         endif
      else
         if ::oColToolTip != nil
            ::DestroyToolTip()
         endif
         ::CheckToolTip( nRow, nCol )
      endif
   endif

   nLen := ::nDataRows

   if ::lAllowRowSizing .and. ::nRowDividerStyle > 0 .and. ;
      ( ::MouseColPos( nCol ) > 0 .or. ::nMarqueeStyle >= MARQSTYLE_HIGHLROWRC )
      for nFor := 1 to nLen
         nPos := ( nFor * ::nRowHeight ) + ::HeaderHeight( .t. )
         if nRow >= ( nPos - 1 ) .and. nRow <= ( nPos + 1 )
            CursorNS()
            return 0
         endif
      next
   endif

   if ::lHoverSelect
      ::SetPos( nRow, nCol, .t. )
   endif

   ::Super:MouseMove( nRow, nCol, nKeyFlags )

return 0

//----------------------------------------------------------------------------//

METHOD LDblClick( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nColPos, nRowPos

   ::CancelEdit()
   ::Seek()

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

   if nColPos != 0 .and. nRowPos != 0
      return ::Super:LDblClick( nRow, nCol, nKeyFlags )
   Endif

return 0

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TXBrowse

   local oCol
   local nColPos, nRowPos
   local oPopup

   ::CancelEdit()
   ::Seek()

   nRowPos := ::MouseRowPos( nRow )
   nColPos := ::MouseColPos( nCol )

   if nColPos <= 0
      if nRow >= ::FirstRow()
         ::Super:RButtonDown( nRow, nCol, nKeyFlags )
         return nil
      else
         if ::lAllowColHiding
            ::SetColumns( nRow, nCol, nKeyFlags )
         endif
         return nil
      endif
   endif

   oCol     := ::ColAtPos( nColPos )

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
   elseif nRowPos > 0
      if nRowPos != ::nRowSel
         if ! ::FullPaint()
            ::DrawLine()
         endif
         ::Skip( nRowPos - ::nRowSel )
         ::nRowSel := nRowPos
         if nColPos > 0
            ::nColSel   := nColPos
         endif
         ::Change( .t. )
      elseif nColPos > 0 .and. ::nColSel != nColPos
         ::nColSel := nColPos
         ::Change( .f. )
      endif
      if Len( ::aSelected ) > 0 .and. AScan( ::aSelected, ::BookMark ) == 0
         ::Select( 0 )
         ::Select( 1 )
      endif
      if ::FullPaint()
         ::Super:Refresh( .t. )
      else
         ::DrawLine( .t. )
      endif
      if ::oVScroll != nil
         ::VSetPos( ::KeyNo() )
      endif
      if ::oHScroll != nil
         ::oHScroll:SetPos( ::nColSel )
      endif
      if ::bPopup == nil .or. ( oPopup := Eval( ::bPopup, oCol ) ) == nil
         if oCol:bPopup != nil
            oPopup   := Eval( oCol:bPopup, oCol )
         endif
      endif
      if oPopup != nil
         oPopup:Activate( (::nRowSel * ::nRowHeight) + ::HeaderHeight( .t. ), oCol:nDisplayCol, Self )
         return 0
      elseif oCol:bRClickData != nil
         return Eval( oCol:bRClickData, nRow, nCol, nKeyFlags, oCol )
      endif
   else
      return ::Super:RButtonDown( nRow, nCol, nKeyFlags )
   endif

   If nColPos != 0 .and. nRowPos != 0
      return ::Super:RButtonDown( nRow, nCol, nKeyFlags )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD MouseWheel( nKeys, nDelta, nXPos, nYPos ) CLASS TXBrowse

   local aPoint := { nYPos, nXPos }

   if !::lScreenUpdating
      return 0
   endif

   ScreenToClient( ::hWnd, aPoint )

   if IsOverWnd( ::hWnd, aPoint[ 1 ], aPoint[ 2 ] ) .and. ;
      ::MouseRowPos( aPoint[ 1 ] ) > 0

      if lAnd( nKeys, MK_MBUTTON )
         if nDelta > 0
            ::PageUp()
         else
            ::PageDown()
         endif
      elseif lAnd( nKeys, MK_SHIFT )
         if nDelta > 0
            ::GoLeft()
         else
            ::GoRight()
         endif
      elseif lAnd( nKeys, MK_CONTROL )
         if nDelta > 0
            ::FontSize( +1 )
         else
            ::FontSize( -1 )
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
      InvertRect( ::GetDC(), { nRow - 1, 0 , nRow + 1, ::GridWidth() } )
      ::ReleaseDC()

   case nOperation == 2
      nTop := ( sLine * ::nRowHeight ) + ::HeaderHeight( .t. )
      InvertRect( ::GetDC(), { sRow - 1, 0 , sRow + 1, ::GridWidth() } )
      ::ReleaseDC()
      if Abs( nRow - nTop ) > 2
         nTop := ( ( sLine - 1 ) * ::nRowHeight ) + ::HeaderHeight( .t. )
         ::nRowHeight := Min( Max( nRow - nTop, 20 ), ::BrwHeight() - nTop - 20 )
         ::Super:Refresh()
      endif

   case nOperation == 3
      nTop := ( ( sLine - 1 ) * ::nRowHeight ) + ::HeaderHeight( .t. ) + 20
      CursorNS()
      if nRow > nTop .and. nRow < (::BrwHeight() - 20 )
         hDC := ::GetDC()
         InvertRect( hDC, { sRow - 1, 0 , sRow + 1, ::GridWidth() } )
         sRow := nRow
         InvertRect( hDC, { sRow - 1, 0 , sRow + 1, ::GridWidth() } )
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
   local nFields, nFor, n, uData
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
   ::lAutoSort              := lAutoOrder
   ::lRelyOnKeyNo           := .f.

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

   ::lSqlRDD := ( ( ::cAlias )->( RddName() ) == "SQLRDD" )
   if ::lSqlRDD
      DEFAULT ::bKeyNo  := { |n| 0 }
   endif

   DEFAULT ::bGoTop    := {|| ( ::cAlias )->( DbGoTop() ) },;
           ::bGoBottom := {|| ( ::cAlias )->( DbGoBottom() ) },;
           ::bSkip     := {| n | ( ::cAlias )->( DbSkipper( IfNil( n, 1 ) ) ) },;
           ::bBof      := {|| ( ::cAlias )->( Bof() ) },;
           ::bEof      := {|| ( ::cAlias )->( Eof() ) },;
           ::bBookMark := {| n | iif( n == nil,;
                                     ( ::cAlias )->( RecNo() ),;
                                     ( ::cAlias )->( DbGoto( n );
                                    ) ) }

   If ( "ADS"$( ::cAlias )->( RddName() ) .or. 'ADT' $ ( ::cAlias )->( RddName() ) ) // .and. ( ::cAlias )->( LastRec() ) > 200

      // Modified in FWH 9.06
      // AdsGetRelKeyPos() returns approximate position as % and when multipilied by 100 and rounded off
      // returns incorrect values occassionally on smaller  tables. OrdKeyNo() mapped to AdsKeyNo() gives reliable
      // result in such cases. For large tables OrdKeyNo() is unacceptably slow. Limit of 200 is chosen because
      // 0.5% is 1/200.

      if ( ::cAlias )->( LastRec() ) > 200

         cAdsKeyNo    := "{| n, Self | iif( n == nil, " +;
                            "Round( " + cAlias + "->( ADSGetRelKeyPos() ) * Self:nLen, 0 ), "+;
                            cAlias + "->( ADSSetRelKeyPos( n / Self:nLen ) ) ) }"
      else
//         cAdsKeyNo   := "{|x,Self| " + cAlias + "->(If(x==nil,AdsKeyNo(,,1),If(Empty(OrdSetFocus()),ADSSetRelKeyPos(x/Self:nLen),OrdKeyGoTo(x))))}"
         cAdsKeyNo   := "{|x,Self| " + cAlias + "->(If(x==nil,AdsKeyNo(,,1),xads_KeyGoTo(x)))}"
      endif

      cAdsKeyCount := "{|| " + cAlias + "->( ADSKeyCount(,,1) )}"

      DEFAULT ::bKeyNo    := &cAdsKeyNo ,;
              ::bKeyCount := &cAdsKeyCount

   else
       DEFAULT ::bKeyNo    := {| n | iif( n == nil,;
                                        ( ::cAlias )->( OrdKeyNo() ),;
                                        ( ::cAlias )->( OrdKeyGoto( n );
                                        ) ) },;
               ::bKeyCount := {|| ( ::cAlias )->( If( eof() .and. bof(), 0, OrdKeyCount() ) ) }

      if ( ( ::cAlias )->( RDDName() ) == "DBFCDX" )
         ::lRelyOnKeyNo := If( Set( _SET_DELETED ), "DELETED()" $ Upper( DbFilter() ), .t. )
      endif
   Endif

   ::lReadOnly    := ( ( ::cAlias )->( DbInfo( DBI_ISREADONLY ) ) == .t. )
   aStruct        := ( ::cAlias )->( dbstruct() )

   if lAddColumns
      if Empty( aFldNames )
         aFldNames   := { '*' }
      endif
      for each uData in aFldNames
         if ValType( uData ) == 'C' .and. uData == '*'
            for nFor := 1 to ( ::cAlias )->( FCount() )
               ( ::cAlias )->( SetColFromRDD( ::AddCol(), nFor ) )
            next
         else
            ( ::cAlias )->( SetColFromRDD( ::AddCol(), uData, aStruct ) )
         endif
      next
   endif

   (::cAlias)->( OrderTagInfo( aStruct, 8 ) )

   for nFor := 1 to Len( ::aCols )
      if ( n := AScan( aStruct, { |a| a[ 1 ] == Upper( ::aCols[ nFor ]:cHeader ) } ) ) > 0
         ::aCols[ nFor ]:cSortOrder    := aStruct[ n ][ 8 ]
         ::aCols[ nFor ]:cOrdBag       := ( cAlias )->( OrdBagName( ::aCols[ nFor ]:cSortOrder ) )
      endif
   next nFor

   DEFAULT ::bSeek  := { |c,u| ( ::cAlias )->( ::RddIncrSeek( c, @u ) ) }

   if ( ::cAlias )->( DbInfo( DBI_SHARED ) )
      if ( ::cAlias )->( RddName() ) $ "DBFNTX,DBFCDX"
         ::bLock     := { || ( ::cAlias )->( If( DbInfo( DBI_ISFLOCK ) .or. DbRecordInfo( DBRI_LOCKED, RECNO() ), ;
                              .t., lLocked := DbrLock( RECNO() ) ) ) }
         ::bUnlock   := { || If( lLocked, ( ::cAlias )->( DbrUnlock( RECNO() ) ), nil ) }
      else
         ::bLock     := { || ( ::cAlias )->( DbrLock() ) }
         ::bUnlock   := { || ( ::cAlias )->( DbrUnlock() ) }
      endif
   endif

   if ::lReadOnly
      ::bLock     := { || .f. }
   endif

   ::bDelete   := { || ( ::cAlias )->( If( ::nLen > 0 .and. ::Lock(), ( DbDelete(), ::Unlock(), ;
                       If( Set( _SET_DELETED ), ( DbSkip(1), If( Eof(), DbGoBottom(), nil ) ), nil ) ;
                       ), nil ) ) }

   if Empty( ::cTitle )
      ::cTitle := cFileNoExt( ( ::cAlias )->( DBINFO( DBI_FULLPATH ) ) )
   endif

   if ( ::cAlias )->( Eof() .and. LastRec() > 0 )
      ( ::cAlias )->( DbGoBottom() )
   endif

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

function xads_keygoto( n )

   if Empty( OrdSetFocus() )
      DbSkip( n - OrdKeyNo() )
      if Bof()
         DbGoTop()
      elseif Eof()
         DbGoBottom()
      endif
   else
      OrdKeyGoTo( n )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetArray( aData, lAutoOrder, nColOrder, aCols, bOnSkip ) CLASS TXBrowse

   local oCol, c, n
   local nFor, lAddCols, aWidths
   local cPivotHead, aHead
   local lReset   := .f.

   if aData == nil
      return nil
   endif

   if ::lCreated
      if ::nDataType == DATATYPE_ARRAY
         ::aArrayData   := aData
         lReset         := .t.
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

   DEFAULT lAutoOrder := ::lAutosort
   ::lAutosort  := lAutoOrder

   ::nRowSel    := 1
   ::nArrayAt   := 1
   ::aArrayData := aData
   if ValType( bOnSkip ) == 'B'
      ::bOnSkip   := bOnSkip
   endif
   ::nDataType  := DATATYPE_ARRAY

   DEFAULT ::bGoTop    := { || ::nArrayAt := Min( 1, Eval( ::bKeyCount ) ), Eval( ::bOnSkip, Self ) }, ;
           ::bGoBottom := { || ::nArrayAt := Eval( ::bKeyCount ), Eval( ::bOnSkip, Self ) }, ;
           ::bSkip     := { | nSkip, nOld | ;
                            If( nSkip == nil, nSkip := 1, ), ;
                            nOld       := ::nArrayAt, ;
                            ::nArrayAt += nSkip, ;
                            ::nArrayAt := Min( Max( ::nArrayAt, 1 ), Eval( ::bKeyCount ) ), ;
                            Eval( ::bOnSkip, Self ), ;
                            ::nArrayAt - nOld }, ;
           ::bBof      := { || ::nArrayAt < 1 }, ;
           ::bEof      := { || ::nArrayAt > Eval( ::bKeyCount ) }, ;
           ::bBookMark := { | n | If( n == nil, ::nArrayAt, ;
                                 ( ::nArrayAt := n, Eval( ::bOnSkip, Self ), n ) ) }, ;
           ::bKeyNo    := ::bBookMark, ;
           ::bKeyCount := { || Len( ::aArrayData ) }

   lAddCols := Empty( ::aCols )
   if ValType( aCols ) == 'L'
      lAddCols       := aCols
      aCols          := nil
   elseif ValType( aCols ) == 'C'
      cPivotHead     := aCols
      lAddCols       := .t.
      aCols          := nil
   endif

   if ValType( ::aArrayData ) == 'A' .and. cPivotHead == nil
      // Check if pivot data
      if ! Empty( ::aArrayData ) .and. ValType( ::aArrayData[ 1 ] ) == 'A' .and. ;
         ! Empty( ::aArrayData[ 1 ] ) .and. ValType( c := ::aArrayData[ 1, 1 ] ) == 'C'

         if Upper( Left( c, 6 ) ) == "PIVOT:"
            c     := SubStr( c, 7 )
            if ( n := At( ':', c ) ) > 0
               ::aArrayData[ 1, 1 ] := Left( c, n - 1 )
               cPivotHead     := SubStr( c, n + 1 )
            endif
            DEFAULT cPivotHead   := "DETAIL"
         endif
      endif
   endif

   if ! Empty( cPivotHead )
      aHead          := ::aArrayData[ 1 ]
      ADel( ::aArrayData, 1, .t. )
      lAddCols    := .t.
   endif

   if ValType( ::aArrayData ) == 'H'  // if aData is a HASH

      if Empty( ::aCols ) .and. lAddCols

         WITH OBJECT ::AddCol()
            :cHeader    := "Key"
            :bEditValue := { || hb_hKeyAt( ::aArrayData, ::nArrayAt ) }
         END

         WITH OBJECT ::AddCol()
            :cHeader    := "Value"
            :bEditValue := { |x| If( x == nil, hb_hValueAt( ::aArrayData, ::nArrayAt ), hb_hValueAt( ::aArrayData, ::nArrayAt, x ) ) }
         END
         ::bSeek        := nil
         lAddCols       := .f.

         aWidths        := { 10, 10 }
         HEval( ::aArrayData, { |k,v| aWidths[ 1 ] := Max( aWidths[ 1 ], Len( Trim( cValToStr( k ) ) ) ), ;
                                      aWidths[ 2 ] := Max( aWidths[ 2 ], Len( Trim( cValToStr( v ) ) ) ) } )
         ::aCols[ 1 ]:nDataLen   := aWidths[ 1 ]
         ::aCols[ 2 ]:nDataLen   := aWidths[ 2 ]
      endif

   else
      // If aData is an Array of Hashes
      if Len( aData ) > 0 .and. ValType( aData[ 1 ] ) == 'H' .and. ;
         ValType( ATail( aData ) ) == 'H' .and. lAddCols

         AEval( aData, { |h| hb_hSetCaseMatch( h, .f. ) } )

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

      // If aData is an Array of Objects
      if Len( aData ) > 0 .and. ValType( aData[ 1 ] ) == 'O' .and. ;
         ValType( ATail( aData ) ) == 'O' .and. lAddCols

         if Empty( aCols )
            aCols    := AOData( aData[ 1 ] )
         endif

         for nFor := 1 to Len( aCols )
            WITH OBJECT ::AddCol()
               :cHeader := cValToChar( aCols[ nFor ] )
               :cExpr   := aCols[ nFor ]
               if ValType( :cExpr ) == 'N'
                  :bEditValue := { |x,o| If( x == nil, o:oBrw:aRow[ o:cExpr ], ;
                                    o:oBrw:aRow[ o:cExpr ] := x ) }
               else
                  :bEditValue := { |x,o| If( x == nil, OSend( o:oBrw:aRow, o:cExpr ), ;
                               OSend( o:oBrw:aRow, '_' + o:cExpr, x ) ) }
               endif
            END
         next nFor

         lAddCols := .f.
      endif

   endif

   if lAddCols
      ::aCols := {}
      if Empty( aData )
         DEFAULT aCols := { 1 }
      endif
      aWidths  := ::ArrCalcWidths( aData, aCols )
      if Empty( aCols )
         for nFor := 1 to Len( aWidths ) //Len( aData[ 1 ] )
            oCol                 := ::AddCol()
            oCol:nArrayCol       := nFor
            oCol:nDataLen        := aWidths[ nFor ]
         next nFor
      else
         for nFor := 1 to Len( aCols )
            oCol               := ::AddCol()
            if ValType( aCols[ nFor ] ) == 'N'
               oCol:nArrayCol     := aCols[ nFor ]
               oCol:nDataLen      := aWidths[ oCol:nArrayCol ]
            else
               oCol:nArrayCol    := 0
               oCol:cSortOrder   := 1
               if ValType( aCols[ nFor ] ) == 'B'
                  oCol:bEditValue   := aCols[ nFor ]
               elseif ValType( aCols[ nFor ] ) == 'A'
                  oCol:aChartCols   := aCols[ nFor ]
                  oCol:cHeader      := "CHART"
               else
//                  oCol:bEditValue   := &( "{ |x,oCol| " + cValToChar( aCols[ nFor ] ) + " }" )
                  oCol:bEditValue   := ( 0 )->( MakeBlock( oCol, aCols[ nFor ] ) )
               endif
            endif
         next nFor
      endif
      AEval( ::aCols, {| oCol, i | oCol:cHeader := MakeColAlphabet( i ), ;
                              oCol:nHeadStrAlign := AL_CENTER } )
         if Len( ::aCols ) > 1 //ValType( aData[ 1 ] ) == 'A' // Ver 10.8 to avoid runtime error for empty array

            DEFAULT nColOrder := ::aCols[ 1 ]:nArrayCol
            if Empty( nColOrder )
               nColOrder      := 1
            endif
            if lAutoOrder
               AEval( ::aCols, {|oCol| oCol:cSortOrder := oCol:nArrayCol, ;
                               If( oCol:nArrayCol == nColOrder, ;
                                    (oCol:cOrder := 'D', oCol:SortArrayData() ), ;
                                    nil ) ;
                               } )
            endif
         else
            oCol:cSortOrder := 1
            if lAutoOrder
               oCol:cOrder := 'D'
               oCol:SortArrayData()
            endif
         endif
         ::nArrayAt  := 1
   endif

   ::bSeek := { | c,u | ::ArrayIncrSeek( c, @u ) }

   if ! Empty( cPivotHead )
      // Pivot Table
      ::lFooter      := .t.
      ::cHeaders     := aHead
      ::SetGroupHeader( cPivotHead, 2 )
      ::SetGroupTotal(  cPivotHead, "TOTAL" )
      AEval( ::aCols, { |o| o:cDataType := 'N', O:nHeadStrAlign := AL_CENTER, ;
                            o:nFooterType := AGGR_SUM }, 2 )
      ::MakeTotals()

      ::aCols[ 1 ]:bLClickHeader := { || ::InvertPivot() }

   endif

   if lReSet .and. ::lCreated
      ::Adjust()
      ::Refresh()
   endif

   ::lExcelCellWise  := .t.
   ::lVThumbTrack    := .t.
   ::AddVar( "ADELETED", Array( 0 ) )
   if ValType( ::aArrayData ) == 'A'
      ::bDelete      := { || If( ::nLen < 1, nil,  ;
                              ( AAdd( ::aDeleted, ::aRow ), ;
                                ADel( ::aArrayData, ::nArrayAt, .t. ), ;
                                ::nArrayAt := Min( ::nArrayAt, Len( ::aArrayData ) ) ) ) }
   endif

   ::AddVar( "SWAPUP", < |Self|
                        if ! ::lAutoSort .and. ::nArrayAt > 1
                           StackPush( ::aRow )
                           ::aArrayData[ ::nArrayAt ] := ::aArrayData[ ::nArrayAt - 1 ]
                           ::aArrayData[ ::nArrayAt - 1 ] := StackPop()
                           ::GoUp()
                        endif
                        return nil
                        > )
   ::AddVar( "SWAPDN", < |Self|
                        if !::lAutoSort .and. ::nArrayAt > 0 .and. ::nArrayAt < ::nLen
                           StackPush( ::aRow )
                           ::aArrayData[ ::nArrayAt ] := ::aArrayData[ ::nArrayAt + 1 ]
                           ::aArrayData[ ::nArrayAt + 1 ] := StackPop()
                           ::GoDown()
                        endif
                        return nil
                        > )

   DEFAULT ::bkeydown := ;
      { |k,f,o| If( GetKeyState(VK_CONTROL), If( k == VK_UP, o:swapup(), If( k == VK_DOWN, o:swapdn(), nil ) ), nil ) }

return Self

//------------------------------------------------------------------------------//

static function HashEditBlock( oBrw, c )
return { |x| If( x == nil, oBrw:aRow[ c ], oBrw:aRow[ c ] := x ) }

//------------------------------------------------------------------//

METHOD ArrCalcWidths( aData, aCols, nMaxRows ) CLASS TXBrowse

   local aSizes
   local nRow, nCol, nRows, cType, n, uVal, aRow, nCols := 1

   if ! Empty( aCols )
      AEval( aCols, { |n| If( ValType( n ) == 'N', nCols := Max( nCols, n ), nil ) } )
   endif

   nRows       := Len( aData )
   if nMaxRows != nil .and. nMaxRows < nRows
      nRows    := nMaxRows
   endif
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
            n     := Len( Trim( cValToStr( aRow[ nCol ] ) ) )
            if n  > IfNil( aSizes[ nCol ], 0 )
               aSizes[ nCol ] := n
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

METHOD ArrCell( nRow, nCol, cPic, lDispZeros ) CLASS TXBrowse

   local uVal

   // Previous TRY .. CATCH construct is replaced with normal bounds check
   // When TRY/CATCH was used inside codeblock and Harbour ( not xhabour )
   // program encounters undefined symbol in some other code, the
   // program crashes instead of generating runtime error.
   // this change fixes the problem
   if nRow > 0 .and. nRow <= Len( ::aArrayData )
      uVal  := ::aArrayData[ nRow ]
   else
      uVal  := {}
   endif

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
         uVal  := cValToStr( uVal, cPic,, IfNil( lDispZeros, ::lDisplayZeros ) )
      endif
   endif

return uVal

//----------------------------------------------------------------------------//

METHOD ArrCellSet( nRow, nCol, uNewVal ) CLASS TXBrowse

   local uRow

   if nRow > 0 .and. nRow <= Len( ::aArrayData )
      uRow  := ::aArrayData[ nRow ]
      if ValType( uRow ) == 'A'
         if nCol > 0
           if nCol > Len( uRow )
              ASize( uRow, nCol )
           endif
           ::aArrayData[ nRow, nCol ] := uNewVal
         endif
      elseif nCol > 1
         ::aArrayData[ nRow ] := ASize( { uRow }, nCol )
         ::aArrayData[ nRow, nCol ] := uNewVal
      else
         ::aArrayData[ nRow ] := uNewVal
      endif
   endif

return ::ArrCell( nRow, nCol )

//------------------------------------------------------------------------------//

METHOD InvertPivot() CLASS TXBrowse

   local aHead, aData, cPivotHead

   aData          := AClone( ::aArrayData )
   aHead          := ::cHeaders
   ASize( aHead, Len( aHead ) - 1 )
   AIns( aData, 1, aHead, .t. )
   aData          := ArrTranspose( aData )
   cPivotHead     := ::aCols[ 1 ]:cHeader
   aData[ 1, 1 ]  := ::aCols[ 2 ]:cGrpHdr
   ::lAdjusted    := .f.
   AEval( ::aCols, { |o| o:End() } )
   ::aCols        := nil
   ::SetArray( aData,,, cPivotHead )
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD SetExcelRange( oRange, lHeaders, aCols ) CLASS TXBrowse

   local oHead
   local nCols, n

   ::oRs       := oRange
   ::nArrayAt  := 1
   ::nDataType := DATATYPE_EXCEL
   nCols       := ::oRs:Columns:Count

   if Empty( aCols )
      aCols    := {}
      for n := 1 to nCols
         AAdd( aCols, n )
      next n
   endif

   DEFAULT lHeaders := .f.
   if lHeaders
      oHead    := ::oRs:Rows( 1 )
      ::oRs    := ::oRs:OffSet( 1, 0 ):Resize( ::oRs:Rows:Count - 1 )
   endif

   ::bKeyCount  := { || ::oRs:Rows:Count }
   ::bGoTop     := { || ::nArrayAt := 1 }
   ::bGoBottom  := { || ::nArrayAt := ::oRs:Rows:Count }
   ::bSkip      := { |nSkip,nOld| If( nSkip == nil, nSkip := 1, nil ), ;
                    nOld := ::nArrayAt, ::nArrayAt += nSkip, ;
                    ::nArrayAt := Min( Max( 1, ::nArrayAt ), ::oRs:Rows:Count ), ;
                    ::nArrayAt - nOld }
   ::bBof       := { || ::nArrayAt < 1 }
   ::bEof       := { || ::nArrayAt > ::oRs:Rows:Count }
   ::bBookMark  := { |n| If( n == nil, ::nArrayAt, ::nArrayAt := n ) }
   ::bKeyNo     := ::bBookMark

   for n := 1 to Len( aCols )
      WITH OBJECT ::AddCol()
         if oHead == nil
            :cHeader   := Chr( aCols[ n ] + 64 )
         else
            :cHeader   := cValToChar( oHead:Cells( 1, aCols[ n ] ):Value )
         endif
         :nArrayCol    := aCols[ n ]
         :bEditValue    := ExcelColBlock( Self, aCols[ n ] )
      END
   next n

return Self

//----------------------------------------------------------------------------//

static function ExcelColBlock( oBrw, nCol )

return { |x| If( x == nil, oBrw:oRs:Cells( oBrw:nArrayAt, nCol ):Value, ;
             oBrw:oRs:Cells( oBrw:nArrayAt, nCol ):Value := x ) }

//----------------------------------------------------------------------------//

METHOD SetAdO( oRs, lAddCols, lAutoOrder, aFldNames ) CLASS TXBrowse

   local c, nFields,nFor, oCol, aRsColNames
   local l1900  := .f.

   if ::lCreated
      if ::nDataType == DATATYPE_ADO
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
           ::bSkip     := {| n | AdoSkip( ::oRs, IfNil( n, 1 ) ) },;
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
   ::lAutosort        := lAutoOrder

   ::nDataType       := DATATYPE_ADO
   ::lReadOnly       := ( ::oRs:LockType < 2 )
   if ::lReadOnly
      ::lRsCanResync := .f.
   else
      TRY
         ::oRs:Resync( 1, 1 )
         ::oRs:Resync( 1, 2 )
         ::lRsCanResync    := .t.
      CATCH
         ::lRsCanResync    := .f.
      END
   endif

   l1900     := ! Empty( c := FW_RDBMSName( oRs:ActiveConnection ) ) .and. c $ "MSACCESS,MSSQL"

   // list of columns in oRs
   aRsColNames    := {}
   for nFor := 0 to oRs:Fields:Count - 1
      AAdd( aRsColNames, Upper( oRs:Fields( nFor ):Name ) )
   next
   ASort( aRsColNames,,,{ |x,y| Len( x ) > Len( y ) } )

   if lAddCols
      if aFldNames == nil
         nFields := oRs:Fields:Count - 1
         for nFor := 0 to nFields
            ::SetColFromADO( nFor, lAutoOrder, aRsColNames, l1900 )
         next
      else
         nFields := Len( aFldnames )
         for nFor := 1 to nFields
            oCol  := ::SetColFromADO( aFldNames[ nFor ], lAutoOrder, aRsColNames, l1900 )
            if Empty( oCol:cHeader )
               oCol:cHeader   := "Col-" + LTrim( Str( nFor ) )
            endif
         next nFor
      endif
   endif

   if ::oRs:LockType > 1 .and. ::oRs:LockType < 4
      ::bSaveData    := { || XbrAdoSave( Self ) }
   endif
   ::bDelete      := { || XbrAdoDelete( Self ) }
   ::bSeek        := { |c| ::AdoIncrSeek( c ) }
   ::lVThumbTrack := .t.

   if ::lUnicode
      ::lLimitChars  := .t.
   endif

   if Empty( ::cTitle )
      TRY
         ::cTitle := ::oRs:Fields( 0 ):Properties( "BASETABLENAME" ):Value
      CATCH
      END
   endif

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD SetMySql( oMysql, lAddCols, lAutoOrder, aFldNames ) CLASS TXBrowse
   LOCAL xField    := NIL
   LOCAL cHeader   := ""
   LOCAL cCol      := ""

   if oMySql:IsKindOf( "FWMARIAROWSET" )
      return ::SetODBF( oMySql, aFldNames, lAutoOrder, lAddCols )
   endif

   DEFAULT oMysql      := ::oMysql
   DEFAULT aFldNames   := {}
   DEFAULT lAddCols    :=  Empty( ::aCols ) .or. ! Empty( aFldNames )
   DEFAULT lAutoOrder  := ::lAutoSort
   ::lAutoSort         := lAutoOrder

   ::oMysql            := oMysql

   DEFAULT ::bGoTop    := {|| If( ::oMysql:RecCount() > 0, ::oMysql:GoTop(), NIL ) },;
           ::bGoBottom := {|| If( ::oMysql:RecCount() > 0, ::oMysql:GoBottom(), nil )  },;
           ::bSkip     := { |n,x| If( ::oMySql:RecCount() > 0, ( x := ::oMySql:RecNo(), ;
                                      ::oMySql:GoTo( Max( 1, ;
                                      Min( ::oMySql:RecCount(), ::oMySql:RecNo() + IfNil( n, 1 ) ) ) ), ;
                                      ::oMySql:RecNo() - x ), 0 ) }, ;
           ::bBof      := {|| ::oMysql:Bof() },;
           ::bEof      := {|| ::oMysql:Eof() },;
           ::bBookMark := {| n | If( n == nil,;
                                 If( ::oMysql:RecCount() > 0, ::oMysql:RecNo(), 0 ), ;
                                 If( ::oMysql:RecCount() > 0, ::oMysql:goto( n ), 0 ) ) }, ;
           ::bKeyNo    := {| n | If( n == nil, ;
                                 If( ::oMysql:RecCount() > 0, ::oMysql:RecNo(), 0 ), ;
                                 If( ::oMysql:RecCount() > 0, ::oMysql:Goto( n ), 0 ) ) },;
           ::bKeyCount := {|| ::oMysql:RecCount() }

   ::nDataType         := DATATYPE_MYSQL

   IF lAddCols

      IF Len(aFldNames) == 0
         aFldNames := ::oMysql:aFieldStruct
      ENDIF

      FOR EACH xField IN aFldNames
         IF Valtype( xField ) == "A" .AND. Len(xField) == 2
            cCol    := xField[1]
            cHeader := xField[2]
         ELSEIF Valtype( xField ) == "A" .AND. Len(xField) # 2
            cCol    := xField[1]
            cHeader := xField[1]
         ELSE
            cCol    := xField
            cHeader := xField
         ENDIF

         ::SetColFromMySQL( cCol, cHeader, lAutoOrder )
      NEXT

      if __ObjHasMethod( oMySql, "WSEEKPLUS" )
         ::bSeek  := { |c| MysqlSeek( ::oMysql, c, , ::lSeekWild ) }
      endif

   ENDIF

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

   RETURN Self

//----------------------------------------------------------------------------//

METHOD SetDolphin( oQry, lAddCols, lAutoOrder, aFldNames, bSeptup ) CLASS TXBrowse

   LOCAL xField    := NIL
   LOCAL cHeader   := ""
   LOCAL cCol      := ""
   LOCAL oCol
   local cWhere, aQryFldNames

   if oQry:IsKindOf( "FWMARIAROWSET" )
      return ::SetODBF( oQry, aFldNames, lAutoOrder, lAddCols )
   endif

   DEFAULT oQry        := ::oMysql
   DEFAULT aFldNames   := {}//oQry:aStructure
   DEFAULT lAddCols    :=  Empty( ::aCols ) .or. ! Empty( aFldNames )
   DEFAULT lAutoOrder  := ::lAutoSort

   ::lAutoSort    := lAutoOrder
   ::oMysql = oQry
   cWhere         := oQry:cWhere

   DEFAULT ;
      ::bGoTop    := {|| If( ::oMysql:RecCount() > 0, ::oMysql:GoTop(), NIL ) },;
      ::bGoBottom := {|| If( ::oMysql:RecCount() > 0, ::oMysql:GoBottom(), nil )  },;
      ::bBof      := {|| ::oMysql:Bof() },;
      ::bEof      := {|| ::oMysql:Eof() },;
      ::bBookMark := {| n | If( n == nil,;
                           If( ::oMysql:RecCount() > 0, ::oMysql:RecNo(), 0 ), ;
                           If( ::oMysql:RecCount() > 0, ::oMysql:goto( n ), 0 ) ) },;
      ::bKeyNo    := {| n | If( n == nil, ;
                           If( ::oMysql:RecCount() > 0, ::oMysql:RecNo(), 0 ), ;
                           If( ::oMysql:RecCount() > 0, ::oMysql:Goto( n ), 0 ) ) },;
      ::bKeyCount := {|| ::oMysql:RecCount() }

    IF ::oMysql:lPagination
       DEFAULT ::bSkip     := {| n | If ( n != NIL, If( n + ::oMysql:nRecNo < 1 .AND. ::oMysql:nCurrentPage > 1,;
                                               ( ::oMysql:PrevPage(, .T. ), 0 ), ;
                                               If( n + ::oMysql:nRecNo > ::oMysql:nRecCount .AND. ::oMysql:nCurrentPage < ::oMysql:nTotalRows,;
                                                   ( ::oMysql:NextPage( , .T. ), 0 ), ::oMysql:Skip( n ) ) ), ::oMysql:Skip( n ) )  }
    ELSE
       DEFAULT ::bSkip     := { | n | ::oMysql:Skip( n ) }
    ENDIF

   ::nDataType          := DATATYPE_MYSQL

   IF lAddCols

      aQryFldNames   := ArrTranspose( ::oMySql:aStructure )[ 1 ]
      AEval( aQryFldNames, { |c,i| aQryFldNames[ i ] := Upper( c ) } )
      ASort( aQryFldNames,,,{ |x,y| Len( x ) > Len( y ) } )

      IF Len(aFldNames) == 0
         aFldNames := ::oMysql:aStructure
      ENDIF

      FOR EACH xField IN aFldNames

         if bSeptup != NIL
            Eval( bSeptup, xField, Self )
         else
            IF Valtype( xField ) == "A" .AND. Len(xField) == 2
               cCol    := xField[1]
               cHeader := xField[2]
            ELSEIF Valtype( xField ) == "A" .AND. Len(xField) # 2
               cCol    := xField[1]
               cHeader := xField[1]
            ELSE
               cCol    := xField
               cHeader := xField
            ENDIF
            ::SetColFromMySQL( cCol, cHeader, lAutoOrder, aQryFldNames )
         endif

      NEXT

      ::bSeek  := { | c | DolphinSeek( c, Self, cWhere ) }

   ENDIF

   ::bSaveData    := { || ::oMySql:Save(), .t. }
   ::bDelete      := { || If( ::nLen < 1, nil, ( ::oMySql:Delete(), ::oMySql:Refresh() ) ) }

   if ::lCreated
      ::Adjust()
      ::Refresh()
   endif

   RETURN Self

//----------------------------------------------------------------------------//

METHOD SetPostGre( oQry, lAddCols, lAutoOrder, aFldNames ) CLASS TXBrowse

   local n, nCol, nCols, aStruct

   DEFAULT lAddCols     := !Empty( aFldNames )
   DEFAULT lAutoOrder   := .f.

   ::oDbf          := oQry
   ::nDataType     := DATATYPE_ODBF
   ::AddVar( "ASTRUCTPG", FWPG_Structure( oQry ) )
   DEFAULT ;
      ::bGoTop        := {|| ::oDbf:GoTo( 1 ) }, ;
      ::bGoBottom     := {|| ::oDbf:GoTo( ::oDbf:nLastRec ) }, ;
      ::bSkip         := {| n | FWPG_Skipper( ::oDbf, n ) }, ;
      ::bBof          := {|| ::oDbf:Bof() }, ;
      ::bEof          := {|| ::oDbf:Eof() }, ;
      ::bBookMark     := { |u| If( PCount() == 0, ::oDbf:RecNo(), ::oDbf:GoTo( u ) ) }, ;
      ::bKeyNo        := { |n| If( n == nil, ::oDbf:RecNo(), ::oDbf:GoTo( n ) ) }, ;
      ::bKeyCount     := { || ::oDbf:nLastRec }, ;
      ::bOnRowLeave   := { || nil }, ;
      ::bDataRow      := { |brw,list,lNew| TDataRow():New( brw:oDbf, list, lNew ) }
      ::lLimitChars   := FW_SetUnicode()

   ::lAutoSort    := lAutoOrder
   DEFAULT ::bSeek   := { |c| FWPG_XbrSeek( Self, c ) }

   aStruct     := FWPG_Structure( oQry )
   ::lReadOnly := Empty( oQry:TableName )

   if lAddCols
      if Empty( aFldNames )
         nCols    := oQry:FCount()
         for nCol := 1 to nCols
            ::SetPostGreCol( nCol, oQry, nil, aStruct  )
         next
      else
         nCols    := Len( aFldNames )
         for n := 1 to nCols
            nCol  := oQry:FieldPos( aFldNames[ n ] )
            if nCol > 0
               ::SetPostGreCol( nCol, oQry, aFldNames[ n ], aStruct )
            else
               ::SetPostGreCol( aFldNames[ n ], oQry, aFldNames[ n ], aStruct )
            endif
         next
      endif
   endif

return Self

//----------------------------------------------------------------------------//

METHOD SetPostGreCol( nCol, oQry, cHead, aStruct ) CLASS TXBrowse

   local oCol, aStr

   WITH OBJECT ::AddCol()
      if ValType( nCol ) == 'N'
         :nFieldPos     := nCol
         :cHeader       := IfNil( cHead, oQry:FieldName( nCol ) )
         :cExpr         := oQry:FieldName( nCol )
         :cDataType     := aStruct[ nCol, 2 ]   //oQry:FieldType( nCol )
         :nDataLen      := aStruct[ nCol, 3 ]   //oQry:FieldLen( nCol )
         :nDataDec      := oQry:FieldDec( nCol )
         :cSortOrder    := oQry:Fieldname( nCol )
         if :cDataType == 'N'
            :cEditPicture  := NumPict( :nDataLen, :nDataDec )
            if aStruct[ nCol, 2 ] == "+"
               :lReadOnly  := .t.
            endif
         endif

         if :cDataType == 'C' .and. :nDataLen == 0
            :cDataType     := "M"
            :nDataLen      := 10
         endif

         if :cDataType == 'K'
            :cDataType     := "M"
            :nDataLen      := 10
         endif

         :bEditValue    := { |x,o| FWPG_FieldGet( ::oDbf, nCol ) }
         :bOnPostEdit   := { |o,x,n| If( n == VK_ESCAPE,, FWPG_XBrSaveData( o, x ) ) }
      elseif ValType( nCol ) == 'C'
         :bEditValue    := { |x,o| FWPG_FieldGet( ::oDbf, nCol ) }
         :cHeader       := nCol
         :cDataType     := ValType( FWPG_FieldGet( ::oDbf, nCol ) )
      elseif ValType( nCol ) == 'B'
         :bEditValue    := nCol
         :cDataType     := Eval( nCol )
      endif
   END

return oCol

//----------------------------------------------------------------------------//

METHOD ClearBlocks() CLASS TXBrowse

   ::bGoTop := ::bGoBottom := ::bSkip := ::bBof := ::bEof := ;
   ::bBookMark := ::bKeyNo := ::bKeyCount := nil
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

METHOD SetColFromADO( cnCol, lAutoOrder, aRsColNames, l1900 ) CLASS TXBrowse

   local   nType, cType, nLen, nDec, cName
   local   oCol, oField, bExpr, uVal
   local   bReplace := { |c| " oCol:oBrw:oRs:Fields('" + Lower( c ) + "'):Value " }

   oCol              := ::AddCol()
   if ValType( cnCol ) $ 'CN'
      TRY
         oField         := ::oRs:Fields( cnCol )
      CATCH
      END
   endif

   if oField == nil
      // not a valid field num / name
      if ValType( cnCol ) == 'B'
         oCol:bEditValue   := cnCol
      elseif ValType( cnCol ) == 'A'
         oCol:aChartCols   := cnCol
         oCol:cHeader      := "CHART"
      else
         if ValType( cnCol ) == 'C'
            if !( 'U' $ Type( cnCol ) )
               oCol:bEditValue   := &( "{||" + cnCol + "}" )
            else
               bExpr             := RsExprnBlock( aRsColNames, cnCol, bReplace )
               if bExpr != nil
                  oCol:bEditValue   := bExpr
                  TRY
                     Eval( oCol:bEditValue, nil, oCol )
                  CATCH
                     oCol:bEditValue   := nil
                  END
               endif
            endif
         endif
         if Empty( oCol:bEditValue )
//            oCol:bEditValue   := &( "{ |x,oCol|" +  cValToChar( cnCol ) + " }" )
            oCol:bEditValue   := ( 0 )->( MakeBlock( oCol, cnCol ) )
         endif
         oCol:cHeader   := cValToChar( cnCol )
         oCol:cExpr     := oCol:cHeader
      endif
      return oCol
   endif

   oCol:cHeader     := If( ValType( cnCol ) == 'C', cnCol, oField:Name )
   oCol:cExpr       := oCol:cHeader
   nType            := oField:Type

   DO CASE
   CASE ASCAN( { 2, 3, 16, 17, 18, 19, 20, 21 }, nType ) > 0
      cType         := 'N'
      nLen          := oField:Precision
      nDec          := 0
   CASE ASCAN( { 14, 131, 139 }, nType ) > 0
      cType         := 'N'
      nLen          := Min( 19, oField:Precision )
      nDec          := If( oField:NumericScale >= 255, 0, Min( nLen - 2, oField:NumericScale ) )
   CASE ASCAN( { 4, 5 }, nType ) > 0  // Single, Double, Currency
      cType         := 'N'
      nLen          := oField:Precision
      nDec          := Set( _SET_DECIMALS )

   CASE ASCAN( { 6 }, nType ) > 0  // Single, Double, Currency
      cType         := 'N'
      nLen          := oField:Precision
      nDec          := 2

   CASE ASCAN( { 7, 133, 135 }, nType ) > 0
      cType         := 'D'
      if ::oRs:RecordCount() > 0 .and. ValType( uVal := oField:Value ) == 'T' .and. ;
         FW_TIMEPART( uVal ) >= 1.0
         //
         cType      := 'T'
      endif
      // Programmer can change oCol:cDataType to 'D' or 'T', before Adjust() is called
      if l1900
         oCol:bEditValue := < |x,o|
               if x != nil
                  ::oRs:Fields( cnCol ):Value := If( Empty( x ) .or. Year( x ) < 1900, AdoNull(), x )
               endif
               return IfNil( ::oRs:Fields( cnCol ):Value, If( o:cDataType == 'T', HB_CTOT( "" ), CTOD( "" ) ) )
               >
      else
         oCol:bEditValue := < |x,o|
               if x != nil
                  ::oRs:Fields( cnCol ):Value := If( Empty( x ), AdoNull(), x )
               endif
               return IfNil( ::oRs:Fields( cnCol ):Value, If( o:cDataType == 'T', HB_CTOT( "" ), CTOD( "" ) ) )
               >
      endif

   CASE nType == 11
      cType         := 'L'
      oCol:bEditValue := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := ! Empty( x ), ;
                                   ! Empty( ::oRs:Fields( cnCol ):Value ) ) }
   CASE ASCAN( { 128, 204, 205 }, nType ) > 0 // Binary
      cType         := 'M'
      nLen          := 10
      oCol:bEditValue := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := HB_StrToHex( x ), ;
                                    ::oRs:Fields( cnCol ):Value ) }

   CASE ASCAN( { 8,129,130,200,201,202,203 }, nType ) > 0
      cType         := 'C'
      nLen          := oField:DefinedSize
      if ! lAnd( oField:Attributes, 0x10 ) // not fixed length
         if nLen == 0 .or. nLen > 100
            cType      := 'M'
            nLen       := 40
         else
            nLen       := Min( 100, nLen )
         endif
      endif
      if cType == 'M'
         oCol:bEditValue   := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := Trim( x ), ;
                                    If( ::oRs:RecordCount > 0,;
                                    IfNil( ::oRs:Fields( cnCol ):Value, "" ), "" ) ) }
      elseif lAnd( oField:Attributes, 0x10 )
         oCol:bEditValue   := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := PadR( x, nLen ), ;
                                 PadR( IfNil( ::oRs:Fields( cnCol ):Value, "" ), nLen ) ) }

      else
         if ::lUnicode .and. AScan( { adWChar, adVarWChar, adLongVarWChar }, nType ) > 0
            oCol:bEditValue   := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := Trim( x ), ;
                                    FW_UTF8PADCHAR( IfNil( ::oRs:Fields( cnCol ):Value, "" ), nLen ) ) }

            oCol:nChrGrp      := CHR_WIDE
         else
            oCol:bEditValue   := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := Trim( x ), ;
                                    PadR( IfNil( ::oRs:Fields( cnCol ):Value, "" ), nLen ) ) }
         endif
      endif
   ENDCASE

   if oCol:bEditValue == nil .and. cType == 'N'
      oCol:bEditValue := { |x| If( x != nil, ::oRs:Fields( cnCol ):Value := x, ;
                                   IfNil( ::oRs:Fields( cnCol ):Value, 0.00 ) ) }

   endif

   oCol:lReadOnly    := ( FW_AdoFieldUpdateable( ::oRs, oField ) == .f. )

   if cType == nil
      if nType == 136 // adChapter
         oCol:bEditValue   := { || ::oRs:Fields( cnCol ):Value }
         oCol:bStrData     := { || "<Child>" }
      else
         oCol:bEditValue   := { || "..." }
      endif
   endif

   if oCol:lReadOnly
      oCol:bOnPostEdit  := { || nil }
   else
      oCol:bOnPostEdit  := { |o,x,n| If( n == VK_ESCAPE .or. x == nil .or. EQ( o:Value, x, .t., .t. ), nil, o:Value := x ) }
   endif

   oCol:cDataType    := If( cType == nil, 'C', cType )
   oCol:nDataLen     := nLen

   if nDec != nil
      oCol:nDataDec  := nDec
   endif
   if oCol:cDataType == 'D'
      oCol:cEditPicture := '@D'
   elseif oCol:cDataType == 'N'
      oCol:cEditPicture := NumPict( nLen, nDec )
   endif

   oCol:cSortOrder   := '[' + oField:Name + ']'

return oCol

//----------------------------------------------------------------------------//

static function RsExprnBlock( aFldNames, cStr, bReplace )

   local nAt, c, cCol, bExpr, cSave

   cSave := cStr
   cStr  := Upper( cStr )

   for each cCol in aFldNames

      do while ( nAt := At( cCol, cStr ) ) > 0
         c := Left( LTrim( SubStr( cStr, nAt + Len( cCol ) ) ), 1 )
         if c $ ")+-*/%^<>," .or. Empty( c )

            cStr  := Stuff( cStr, nAt, Len( cCol ), Eval( bReplace, cCol )  )

         else
            cStr  := Stuff( cStr, nAt, Len( cCol ), Lower( cCol ) )
         endif
      enddo

   next
   TRY
      bExpr    := &( "{ |x,oCol| " + cStr + "}" )
   CATCH
   END

return bExpr

//----------------------------------------------------------------------------//

METHOD SetColFromMySQL( cnCol, cHeader, lAutoOrder, aQryFldNames ) CLASS TXBrowse

   LOCAL nType, cType, nLen, nDec, cName
   LOCAL oCol, nCol := 0
   local bReplace    := { |c| " oCol:oBrw:oMySql:" + Lower( c ) + " " }

   if ValType( cnCol ) == 'B'
      WITH OBJECT ( oCol := ::AddCol() )
         :bEditValue    := cnCol
         :cHeader       := If( ValType( cHeader ) == 'C', cHeader, "Col-" + LTrim( Str( :nCreationOrder ) ) )
      END
      return oCol
   endif

   if ValType( cnCol ) == 'N' .and. cnCol > 0 .and. cnCol <= ::oMySql:FCount()
      nCol              := cnCol
   elseif ValType( cnCol ) == "C"
      TRY
         nCol            := ::oMysql:FieldPos( cnCol )
      CATCH
      END
   endif
   if nCol == 0
      WITH OBJECT ( oCol := ::AddCol() )
         if ValType( cnCol ) == 'C' .and. aQryFldNames != nil
            :bEditValue    := RsExprnBlock( aQryFldNames, cnCol, bReplace )
         else
            :bEditValue    := &( '{ |x,oCol| ' + cValToChar( cnCol ) + ' }' )
         endif
         :cHeader       := If( ValType( cHeader ) == 'C', cHeader, "Col-" + LTrim( Str( :nCreationOrder ) ) )
      END
      return oCol
   endif

   cName                 := ::oMysql:FieldName( nCol )
   DEFAULT ;
   nCol                  := cnCol
   oCol                  := ::AddCol()
   WITH OBJECT oCol
      :cHeader           := If( ValType( cHeader ) == 'C', cHeader, cName )
   END
   cType                 := ::oMysql:FieldType( nCol )
   nLen                  := 0
   nDec                  := 0

   DO CASE
   CASE cType       == 'N'
      nLen               := ::oMysql:FieldLen( nCol )
      nDec               := ::oMysql:FieldDec( nCol )
      oCol:cEditPicture  := NumPict( nLen, nDec )

   CASE cType       == 'C'
      nLen               := MIN( 100, ::oMysql:FieldLen( nCol ) )

   CASE cType       == 'M'
      nLen               := MIN( 100, Len(AllTrim(::oMysql:FieldGet( nCol ))) )
      nLen               := IF(nLen < 30, 30, nLen )

   CASE cType       == 'D'
      nLen              := 8

   CASE cType       == 'T'  // Dolphin returns Char Value (time stamp sting) Fix; 2014-JUN-19
      nLen              := 19
      cType             := 'C'

   CASE cType       == 'L'
      nLen              := 1

   OTHERWISE
      // just in case.  this will not be executed
      oCol:bEditValue    := { || "..." }
      nLen              := 3

   ENDCASE

   DEFAULT oCol:bEditValue := { |x| If( x == nil, ::oMySql:FieldGet( cName ), ::oMySql:FieldPut( nCol, x ) ) }

   WITH OBJECT oCol
      :cDataType           := If( cType == nil, 'C', cType )
      :nDataLen            := nLen
      :nDataDec            := nDec
      :bOnPostEdit         := { |o,x,n| If( n == VK_ESCAPE,,o:Value := x ) }
      if lAutoOrder
         :cSortOrder   := cName
      endif
   END

RETURN oCol

//----------------------------------------------------------------------------//

METHOD RddIncrSeek( cExpr, uSeek ) CLASS TXBrowse

   local lFound      := .f.
   local lSoft       := .t.
   local cTemp, uOrdKeyVal, cOrdKeyType

   if ::lIncrFilter
      return ::RDDIncrFilter( cExpr, @uSeek )
   endif

   if Empty( OrdSetFocus() ) //.or. Empty( cExpr )
      return .f.
   endif

   uOrdKeyVal  := OrdKeyVal()
   cOrdKeyType := ValType( uOrdKeyVal )

   if cOrdKeyType == 'C'
      if ::lSeekWild
         if "UPPER" $ Upper( OrdKey() )
            cExpr := Upper( cExpr )
         endif
         lFound   := OrdWildSeek( StrTran( "*" + cExpr + "*", "**", "*" ) )
      else
         lFound   := DbSeek( Upper( cExpr ) ) .or. DbSeek( cExpr )
      endif
   else
      do case
      case cOrdKeyType == 'N'
         cExpr    := Val( cExpr )
      case cOrdKeyType $ 'DT'
         cExpr    := SeekDate( cExpr, uOrdKeyVal )
      case cOrdKeyType == 'L'
         cExpr    := Upper( Left( cExpr, 1 ) ) == 'T'
      otherwise
         lSoft    := .f.
      endcase
      DbSeek( cExpr, lSoft )
      lFound      := !Eof()
   endif

   if lFound .and. ::oDbf != nil
      ::oDbf:Load()
   endif

return lFound

//----------------------------------------------------------------------------//

METHOD RddIncrFilter( cExpr, uSeek ) CLASS TXBrowse

   local oBrw     := Self
   local lFound   := .f.
   local cKey, oCol
   local cFilter

   if ::bFilterExp == nil
      DEFAULT ::cFilterFld   := OrdKey()
      cKey  := ::cFilterFld
      if Empty( cKey )
         cKey  := "DBRECORDINFO(" + LTRIM(STR(DBRI_RAWRECORD)) + ")"
      endif
      if ::lSQLRDD
         if Empty( cExpr )
            cFilter  := ""
         else
            cExpr := If( ::lSeekWild, "'%", "'" ) + Upper( Trim( cExpr ) ) + "%'"
            cFilter  := cKey + " LIKE " + cExpr
         endif
      else
         if ValType( &cKey ) == 'C'
            if ! "UPPER" $ Upper( cKey )
               cKey  := "UPPER( " + cKey + " )"
            endif
         else
            cKey  := "CVALTOCHAR(" + cKey + ")"
         endif
         if Empty( cExpr )
            cFilter     := '!deleted()'
         elseif ::lSeekWild
#ifdef __XHARBOUR__
            cFilter     := 'WildMatch("*' + Upper( Trim( cExpr ) ) + '*",' + cKey + ')'
#else
            cFilter     := 'HB_WildMatch("*' + Upper( Trim( cExpr ) ) + '*",' + cKey + ')'
#endif
         else
            cFilter     := cKey + '="' + Upper( Trim( cExpr ) ) + '"'
         endif
      endif
   else
      cFilter        := Eval( ::bFilterExp, cExpr )
   endif

   if ! ::lSQLRDD .and. &cFilter
      uSeek          := ::BookMark
   endif
   SET FILTER TO &cFilter
   GO TOP
   lFound      := ::KeyCount() > 0

   if lFound .and. ::oDbf != nil
      ::oDbf:Load()
   endif

return lFound

//----------------------------------------------------------------------------//

METHOD AdoIncrSeek( uSeek ) CLASS TXBrowse

   local lFound   := .f.
   local cCol     := CharRem( "[]", StrToken( ::oRs:Sort, 1 ) )
   local cExpr    := ''
   local cType, d, uVal, lSoft, cSaveFilt

   if ::lIncrFilter
      if ::bFilterExp == nil
         DEFAULT ::cFilterFld := cCol
         cCol     := ::cFilterFld
      else
         cExpr    := Eval( ::bFilterExp, uSeek )
      endif
   endif

   if Empty( cExpr ) .and. ! Empty( cCol ) .and. ! ::oRs:Eof() .and. ! ::oRs:Bof()

      DEFAULT lSoft := Set(_SET_SOFTSEEK), ::lSeekWild := .f.

      uVal     := ::oRs:Fields( cCol ):Value
      cType    := If( uVal == nil, FieldTypeAdoToDbf( ::oRs:Fields( cCol ):Type ), ValType( uVal ) )

      do case
      case cType == 'C'
         uSeek       := StrTran( uSeek, "'", "''" )
         if ::lSeekWild
            lSoft    := .f.
            cExpr    := cCol + " LIKE '*" + uSeek + "*'"
         else
            cExpr    := If( Set( _SET_EXACT ), cCol + " = '" + uSeek + "'", ;
                                               cCol + " LIKE '" + uSeek + "*'" )
         endif

      case cType == 'N'
         cExpr    := cCol + " >= " + ;
                     LTrim( Str( Val( uSeek ) ) )

      case cType $ 'DT'
         cExpr    := cCol + " >= " + d2ado( SeekDate( uSeek, uVal ) )
      endcase

      if ! Empty( cExpr )
         if ::lIncrFilter
            if Empty( uSeek )
               ::oRs:Filter   := ''
               ::oRs:MoveFirst()
               lFound         := .t.
            else
               cSaveFilt      := ::oRs:Filter
               ::oRs:Filter   := cExpr
               if ! ( lFound := ( ::oRs:RecordCount > 0 ) )
                  ::oRs:Filter   := cSaveFilt
               endif
            endif
         else
            if Empty( uSeek )
               if ::oRs:RecordCount() > 0
                  ::oRs:MoveFirst()
               endif
               lFound   := .t.
            else
               ::oRs:Find( cExpr, 0, 1, 1 )
               if ::oRs:Eof() .and. lSoft .and. cType == 'C'
                  ::oRs:MoveFirst()
                  cExpr := cCol + " > '" + uSeek + "'"
                  ::oRs:Find( cExpr, 0, 1, 1 )
               endif
               if ::oRs:Eof()
                  ::oRs:MoveLast()
               else
                  lFound   := .t.
               endif
            endif
         endif
      endif

   endif

return lFound

//----------------------------------------------------------------------------//

static FUNCTION DolphinSeek( c, oBrw, cQryWhere )

   local oQry        := oBrw:oMySql
   local nStart
   local uData, nNum, lRet, lNumeric := .f.
   local cSortOrder

   static aLastRec := {}

   if oBrw:lIncrFilter
      DEFAULT oBrw:cFilterFld := TOken( oQry:cOrder, , 1 )
      if Empty( oBrw:cFilterFld )
         return .f.
      endif

      if Empty( c )
         c     := cQryWhere
      else
         c     := If( Empty( cQryWhere ), "", "(" + cQryWhere + ") and " ) + ;
                  Lower( oBrw:cFilterFld ) + " like '" + ;
                  If( oBrw:lSeekWild, "%", "" ) + ;
                  c + "%'"
      endif
      oQry:SetWhere( c, .t. )
      oQry:GoTop()
      return ( oQry:LastRec() > 0 )

   endif

   if Empty( c )
      return .t.
   endif

   nNum = AScan( oBrw:aCols, {| o | !Empty( o:cOrder ) } )

   if nNum < 1
      RETURN .f.
   endif

   cSortOrder = oBrw:aCols[ nNum ]:cSortOrder

   if Len( c ) == 1
      aLastRec    := {}
   endif

   IF Len( aLastRec ) < Len( c )
      IF Len( aLastRec ) == 0
         nStart = 1
      ELSE
         nStart = oQry:RecNo()
      ENDIF
      AAdd( aLastRec, nStart )
   ELSE
//      ADel( aLastRec, Len( aLastRec ) )
//      ASize( aLastRec, Len( aLastRec ) - 1 )
      ASize( aLastRec, Len( c ) - 1 )
      IF Len( aLastRec ) == 0
         nStart = 1
      ELSE
         nStart = ATail( aLastRec )
      ENDIF
   ENDIF

   if ( lNumeric := ( oQry:FieldType( cSortorder  ) == 'N' ) ) .and. !ISDIGIT( Right( c, 1 ) )
      return .f.
   endif

//   lRet  := ( oQry:Seek( c, cSortOrder, nStart - 1, oQry:LastRec(), .T., .T. ) != 0 )
   lRet  := ( oQry:Seek( c, cSortOrder, Max( 1, nStart - 1 ), oQry:LastRec(), ;
      If( lNumeric, .F., .T. ), .T. ) != 0 )

return lRet

//----------------------------------------------------------------------------//

static function MysqlSeek( oMysql, uSeek, lSoft, lWildSeek )

   local lFound   := .f.
   local cCol     := oMysql:cSort
   local cExpr    := ''
   local cType, d, uVal

   if ! Empty( cCol ) .and. ! oMysql:Eof() .and. ! oMysql:Bof()

      DEFAULT lSoft := Set(_SET_SOFTSEEK), lWildSeek := .f.

      uVal   := oMysql:FieldGet( cCol )
      cType  := oMysql:FieldType( cCol )

      do case
      case cType == 'C'

         if lWildSeek
            lSoft    := .f.
            cExpr    := cCol + " LIKE '%" + uSeek + "%'"
         else
            cExpr    := If( Set( _SET_EXACT ), cCol + " = '" + uSeek + "'", ;
                                               cCol + " LIKE '" + uSeek + "%'" )
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
         oMysql:WSeekplus( cExpr, oMysql:cSort, oMysql:recno() )
         if oMysql:Eof() .and. lSoft .and. cType == 'C'
            oMysql:GoTop()
            cExpr := cCol + " > '" + uSeek + "'"
            oMysql:WSeekplus( cExpr, oMysql:cSort, oMysql:recno() )
         endif
         if oMysql:Eof()
            oMysql:GoBottom()
         else
            lFound   := .t.
         endif
      endif

   endif

return lFound

//----------------------------------------------------------------------------//

METHOD SetTree( oTree, aResource, bOnSkip, aCols ) CLASS TXBrowse

   local oCol, aBmp := { 0, 0, 0 }
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
                     ( n--, ::oTreeItem := ::oTree:oFirst:Skip( @n ), Eval( bOnSkip, ::oTreeITem ), n + 1 ) ) }

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

   oCol:bEditValue   := { |x| If( x == nil, ::oTreeItem:cPrompt, ::oTreeItem:cPrompt := x ) }
   oCol:cHeader      := "Item"
   oCol:nWidth       := 200
   oCol:bLDClickData := { || If( ::oTreeItem:oTree != nil,( ::oTreeItem:Toggle(), ::Refresh() ),) }
   oCol:bIndent      := { || ::oTreeItem:nLevel * 20 - 20 }

   if ValType( aResource ) == 'A'
      oCol:AddBitmap( aResource )
   endif
   oCol:bBmpData   := { || If( ::oTreeItem:oTree == nil, 3, If( ::oTreeItem:lOpened, 1, 2 ) ) }

   ::nFreeze         := 1

   if ValType( aCols ) == 'L' .and. aCols .and. ValType( ::oTreeItem:Cargo ) == 'A'
      for n := 1 to Len( ::oTreeItem:Cargo )
         ::SetColsForTree( n )
      next n
   elseif ValType( aCols ) == 'A'
      for n := 1 to Len( aCols )
         ::SetColsForTree( aCols[ n ] )
      next n
   endif

return Self

//----------------------------------------------------------------------------//

METHOD SetColsForTree( uData ) CLASS TXBrowse

   local oCol  := ::AddCol()

   if ValType( uData ) == 'B'
      oCol:bEditValue   := uData
   elseif ValType( ::oTreeItem:Cargo ) == 'A' .and. ValType( uData ) == 'N'
      oCol:bEditValue   := { |x| If( x == nil, ::oTreeItem:Cargo[ uData ], ::oTreeItem:Cargo[ uData ] := x ) }
   else
      oCol:bEditValue   := &( "{ |x,oCol| " + cValToChar( uData )+ " }" )
   endif

return oCol

//----------------------------------------------------------------------------//

METHOD SetoDbf( oDbf, aCols, lAutoSort, lAutoCols, aRows ) CLASS TXBrowse

   local n, oCol, oRs
   local bOnSkip

   DEFAULT lAutoSort   := ::lAutoSort, ;
           lAutoCols   := .f.

   ::oDbf              := oDbf
   ::nDataType         := DATATYPE_ODBF   // 2014-07-04
   ::lRelyOnKeyNo      := .f.

   if ValType( aRows ) == 'A' .and. Len( aRows ) > 0

      if ValType( aRows[ 1 ] ) == 'A'
         bOnSkip        := { | oBrw | oBrw:oDbf:GoTo( oBrw:aArrayData[ oBrw:nArrayAt ][ 1 ] ) }
      else
         bOnSkip        := { | oBrw | oBrw:oDbf:GoTo( oBrw:aArrayData[ oBrw:nArrayAt ] ) }
      endif
      ::SetArray( aRows, .f., 0, .f., bOnSkip )
      ::nDataType       := nOr( DATATYPE_ODBF, DATATYPE_ARRAY )
      lAutoSort         := .f.

   elseif __ObjHasMethod( oDbf, 'SETXBROWSE' )
      oDbf:SetXBrowse( Self, aCols, lAutoSort, lAutoCols )
      aCols       := nil
      lAutoCols   := .f.
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

      if __ObjHasMethod( oDbf, 'SAVE' )
         DEFAULT ::bSaveData := { || ::oDbf:Save() }
      endif

      ::nDataType         := DATATYPE_ODBF

   endif

   ::lAutoSort       := lAutoSort

   if Empty( aCols ) .and. lAutoCols
      if oDbf:ClassName == "TTXTFILE"
         WITH OBJECT ::AddCol()
            :bEditValue    := < |x,o|
                              if x != nil
                                 ::oDbf:RepLine( Trim( x ) )
                              endif
                              if Len( ::oDbf:cLine ) < 255
                                 return PADR( ::oDbf:cLine, 255 )
                              endif
                              return ::oDbf:cLine + Space( 10 )
                              >

            :cHeader       := "LineText"
         END
      elseif __ObjHasData( oDbf, "aStruct" )
         aCols := {}
         AEval( oDbf:aStruct, { |a| AAdd( aCols, a[ 1 ] ) } )
      elseif __ObjHasData( oDbf, 'cAlias' ) .and. __ObjHasData( oDbf, 'nArea' ) .and. ;
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

   if __ObjHasMethod( oDbf, 'SAVE' )
      DEFAULT ::bOnRowLeave   := { || ::oDbf:Save() }
   endif

   if __ObjHasMethod( oDbf, 'SEEK' )
      DEFAULT ::bSeek := { |c| ::oDbf:Seek( c, , ::lSeekWild ) }
   endif

   if __ObjHasMethod( oDbf, "Delete" )
      ::bDelete      := { || ::oDbf:Delete() }
   endif

   if ::lUnicode .and. ::oDbf:IsKindOf( "FWMARIAROWSET" ) .and. ::oDbf:oCn:lUnicode
      ::lLimitChars  := .t.
   endif

return Self

//----------------------------------------------------------------------------//

METHOD GetColsData( cData, lByCreationOrder ) CLASS TXBrowse

   local aValues  := {}
   local oCol

   cData          := Upper( cData )
   DEFAULT lByCreationOrder   := !( cData == 'NCREATIONORDER' )

   if ! Empty( ::aCols ) .and. __ObjHasData( ::aCols[ 1 ], cData )
      if lByCreationOrder
         aValues  := Array( Len( ::aCols ) )
         for each oCol in ::aCols
            aValues[ oCol:nCreationOrder ]   := OSend( oCol, cData )
         next oCol
      else
         AEval( ::aCols, { |o| AAdd( aValues, OSend( o, cData ) ) } )
      endif
   endif

return aValues

//----------------------------------------------------------------------------//

METHOD SetColsData( cData, aValues, lByCreationOrder ) CLASS TXBrowse

   local oCol

   cData       := Upper( cData )
   if ! Empty( ::aCols ) .and. __ObjHasData( ::aCols[ 1 ], cData )

      DEFAULT lByCreationOrder   := !( cData == 'NCREATIONORDER' )

      cData       := "_" + cData

      if ValType( aValues ) == 'A'
         if lByCreationOrder
            for each oCol in ::aCols
               if oCol:nCreationOrder <= Len( aValues )
                  OSend( oCol, cData, aValues[ oCol:nCreationOrder ] )
               endif
            next oCol
         else
            AEval( ::aCols, { |o,i| OSend( o, cData, aValues[ i ] ) }, 1, Len( aValues ) )
         endif
      else
         AEval( ::aCols, { |o,i| OSend( o, cData, aValues ) } )
      endif
   endif

return aValues

//----------------------------------------------------------------------------//

METHOD SetGroupHeader( cGrpHdr, nFrom, nUpto, oFont, nAlign ) CLASS TXBrowse

   local nFor

   DEFAULT nFrom := 1, nUpto := Len( ::aCols ), cGrpHdr := "GROUP"

   cGrpHdr  := AllTrim( cGrpHdr )
   if nAlign == AL_LEFT
      cGrpHdr  += ' '
   elseif nAlign == AL_RIGHT
      cGrpHdr  := ' ' + cGrpHdr
   endif

   for nFor := nFrom to nUpto
      ::aCols[ nFor ]:cGrpHdr       := cGrpHdr
      if oFont != nil
         ::aCols[ nFor ]:oGrpFont   := oFont
      endif

      if ::lAdjusted
         ::aCols[ nFor ]:nGrpHeight   := nil
         ::aCols[ nFor ]:Adjust()
      endif

   next nFor

   if ::lAdjusted
      ::CalcHdrHeight()
      ::Refresh()
   endif

return Self

//------------------------------------------------------------------//

METHOD SetGroupTotal( aCols, cHead, nType, oFont ) CLASS TXBrowse

   local oCol, nLastCol, n
   local cGroup

   DEFAULT nType := AGGR_SUM

   if ValType( aCols ) == 'C'
      cGroup      := Upper( aCols )
      for n := Len( ::aCols ) to 1 step -1
         if ! Empty( ::aCols[ n ]:cGrpHdr ) .and. Upper( ::aCols[ n ]:cGrpHdr ) == cGroup
            nLastCol := n
            exit
         endif
      next n
   elseif ValType( aCols ) == 'A'
      nLastCol := 0
      for n := 1 to Len( aCols )
         oCol     := ::oCol( aCols[ n ] )
         if ValType( oCol ) == 'O'
            nLastCol := Max( nLastCol, oCol:nCreationOrder )
         endif
      next n
   endif
   if Empty( nLastCol )
      return nil
   endif

   oCol     := ::InsCol( nLastCol + 1 )
   WITH OBJECT oCol
      :cHeader    := cHead
      :bEditValue := { || oCol:SumOfCols( aCols, nType ) }
      if oFont == nil .and. ! Empty( cGroup )
         oFont    := ::aCols[ nLastCol ]:GrpFont
      endif
      if ! Empty( oFont )
         :oHeaderFont := :oDataFont := :oFooterFont := oFont
         if ! Empty( cGroup )
            :oGrpFont   := oFont
         endif
      endif
      if ! Empty( cGroup )
         :cGrpHdr    := ::aCols[ nLastCol ]:cGrpHdr
      endif
   END

return oCol

//------------------------------------------------------------------//

METHOD SetBackGround( uBack, uBckMode ) CLASS TXBrowse

   local oBrush

   if uBack == nil .and. uBckMode == nil
      // cancel background
      ::lTransparent := .f.
      ::SetColor( ::nClrText, ::nClrPane )
      if ::lCreated
         ::Refresh()
      endif
   else
      if uBack == nil
         if ::oBrush:aGrad != nil
            uBckMode    := If( Empty( uBckMode ), 2, 1 )
         elseif Empty( ::oBrush:hBitmap ) .or. ValType( uBckMode ) != 'N'
            uBckMode := nil
         endif
         if uBckMode != nil .and. ::oBrush:nResizeMode != uBckMode
            ::lTransparent    := .t.
            ::oBrush:nResizeMode := uBckMode
            ::oBrush:oRect       := nil
            ::MakeBrush()
         endif
      else
         DEFAULT uBckMode := If( Empty( ::oBrush ), 0, ::oBrush:nResizeMode )
         SWITCH ValType( uBack )
         CASE 'A'
            if ValType( uBckMode ) == 'N'
               uBckMode    := uBckMode < 2
            endif
            DEFINE BRUSH oBrush GRADIENT uBack ;
               STYLE ( If( ! Empty( uBckMode ), "VERTICAL", "HORIZONTAL" ) )
            EXIT
         CASE 'N'
            oBrush := TBrush():New( nil, nil, nil, nil, uBack, ;
               FW_Decode( uBckMode, 1, "STRETCH", 2, "RESIZE", "TILED" ) )
            EXIT
         CASE 'C'
            uBckMode    := FW_Decode( uBckMode, 1, "STRETCH", 2, "RESIZE", "TILED" )
            if "." $ uBack
               DEFINE BRUSH oBrush FILE uBack STYLE ( uBckMode )
            else
               DEFINE BRUSH oBrush RESOURCE uBack STYLE ( uBckMode )
            endif
            EXIT
         CASE 'O'
            oBrush      := uBack
            oBrush:nCount++
            EXIT
         END

         if oBrush != nil
            ::lTransparent := .t.
            if ::oBrush != nil
               ::oBrush:End()
            endif
            ::oBrush    := oBrush
            // note: nCount is already set
            if ::lAdjusted
               ::Refresh()
            endif

         endif
      endif
   endif

return Self

//------------------------------------------------------------------//

METHOD MakeBrush() CLASS TXBrowse

   if ::oBrush != nil
      if !( Empty( ::oBrush:hBitmap ) .and. Empty( ::oBrush:aGrad ) )
         ::oBrush:Resize( Self )
         if ::lAdjusted //::lCreated
            ::Refresh()
         endif
      endif
   endif
return Self

//------------------------------------------------------------------//

METHOD DataRect() CLASS TXBrowse

   local oRect    := ::GetCliRect()

   if ::lRecordSelector
      oRect:nLeft    += ( ::nRecSelWidth - 1 ) // -1 added on 2009-08-28
   endif
   if ::lHeader
      oRect:nTop     += ::HeaderHeight( .t. )
   endif
   if ::lFooter
      oRect:nBottom  -= ::FooterHeight()
   endif

return oRect

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

   if Len( ::aCols ) > 1
      ::aCols[ nPos ]:End()

      ADel( ::aCols, nPos )
      ASize( ::aCols, Len( ::aCols ) - 1 )

   //   for nFor := nPos + 1 to Len( ::aCols )
      for nFor := nPos to Len( ::aCols )
         ::aCols[ nFor ]:nCreationOrder := nFor
      next

      ::GetDisplayCols()
      ::Super:Refresh()
   endif

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

   oCol:cHeader      := IfNil( cHead, '' )
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
/*
         oCol:bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE .and. Eval( o:oBrw:bLock ), ;
          ( o:Value := x, Eval( o:oBrw:bUnLock ) ), nil ) }
*/
         oCol:bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE .and. o:oBrw:Lock(), ;
                                o:Value := x, nil ) }    // FWH 13.03

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
      ::lAutoSort     := .t.
      if ::nDataType == DATATYPE_RDD .and. ! Empty( ::cAlias ) .and. SELECT( ::cAlias ) > 0
         oCol:cOrdBag    := ( ::cAlias )->( OrdBagName( ncOrder ) )
      endif
   endif

   if ValType( aBmp ) == 'A'
      oCol:AddBitmap( aBmp )
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

METHOD MoveCol( xFrom, xTo, lRefresh, lUser ) CLASS TXBrowse

   local oCol
   local nFrom, nTo, nPos, n, cPrevGrp

   DEFAULT lRefresh := .t., lUser := .f.

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

   if lUser .and. ! Empty( ::nFreeze )
      // User can not drag columns into and out of freeze area
      if ( nFrom >  ::nFreeze .and. nTo <= ::nFreeze ) .or. ;
         ( nFrom <= ::nFreeze .and. nTo >  ::nFreeze )
         // swapping in and out of Freezed columns not alloed
         return nil
      endif
   endif

   if nFrom > 0 .and. nTo > 0 .and. ( ::lAllowColReGroup .or. ;
         ::aCols[ nFrom ]:cGrpHdr == ::aCols[ nTo ]:cGrpHdr )
      oCol := ::aCols[ nFrom ]
      if ::lAllowColReGroup
         cPrevGrp       := oCol:cGrpHdr
         oCol:cGrpHdr   := ::aCols[ nTo ]:cGrpHdr
      endif
      nPos := oCol:nPos
      ADel( ::aCols, nFrom )
      AIns( ::aCols, nTo   )
      ::aCols[ nTo ] := oCol
      ::GetDisplayCols()

      if ::bOnSwapCol != nil
         Eval( ::bOnSwapCol, Self, nFrom, nTo )
      endif

      if oCol:cGrpHdr != cPrevGrp
         ::CalcHdrHeight()
      endif

      if lRefresh
         ::Super:Refresh()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReArrangeCols( aSeq, lRetainRest, lReNumber ) CLASS TXBrowse

   local aNew     := {}
   local nCol, oCol, n

   DEFAULT lRetainRest    := .t., ;
           lReNumber      := .f.

   for n := 1 to Len( aSeq )

      nCol  := AScan( ::aCols, { |o| o == aSeq[ n ] } )
      if nCol > 0
         AAdd( aNew, ::aCols[ nCol ] )
         ADel( ::aCols, nCol )
         ASize( ::aCols, Len( ::aCols ) - 1 )
      endif
   next n

   if ! Empty( ::aCols )
      if lRetainRest
         AEval( ::aCols, { |o| AAdd( aNew, o ) } )
      else
         for n := 1 to Len( ::aCols )
            ::aCols[ n ]:End()
         next
      endif
      if ! lReNumber
         for n := 1 to Len ( aNew )
            if aNew[ n ]:nCreationOrder > Len( aNew )
               lReNumber   := .t.
               exit
            endif
         next
      endif
   endif
   if lReNumber
      AEval( aNew, { |o,i| o:nCreationOrder := i } )
   endif
   ::aCols  := aNew
   if ::lCreated
      ::GetDisplayCols()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SaveState( aAdditionalData ) CLASS TXBrowse

   local aData    := { "nCreationOrders", "nRowHeight", "nWidths", "lHides", "cGrpHdrs", "cHeaders" }
   local aState   := {}

   if ValType( aAdditionalData ) == 'A'
      AEval( aAdditionalData, { |c| AAdd( aData, c ) } )
   endif

   AEval( aData, { |c| AAdd( aState, { "_" + c, OSend( Self, c ) } ) } )

   //return "XSS:" + HB_StrToHex( ASave( aState ) ) // Upto FWH 11.07

return "XS1:" + FW_ValToExp( aState )            // From FWH 11.08

//----------------------------------------------------------------------------//

METHOD RestoreState( cState ) CLASS TXBrowse

   local aState

   if ! Empty( cState )
      if Left( cState, 2 ) == "XS"
         if Left( cState, 4 ) == 'XS1:'
            cState      := SubStr( cState, 5 )
            aState      := &( cState )
         elseif Left( cState, 4 ) == 'XSS:'
            aState      := ARead( HB_HexToStr( SubStr( cState, 5 ) ) )
         else
            return nil
         endif
         ::ReArrangeCols( aState[ 1, 2 ], .t. , .f. )
         AEval( aState, { |a| OSend( Self, a[ 1 ], a[ 2 ] ) }, 2 )
      else
         return ::OldRestoreState( cState )
      endif

      ::GetDisplayCols()
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD OldRestoreState( cState ) CLASS TXBrowse

   local aCols       := {}
   local aNewOrder   := {}
   local nFor, nLen, nHeight, cCol, oCol, nOrder

   if Empty( cState )
      return nil
   endif

   nLen   := Len( ::aCols )
   nHeight := Val(StrToken( cState, 1, ";" ) )

   if Empty( ::nRowHeight )
      return nil
   endif

   for nFor := 1 to nLen
      cCol := StrToken( cState, nFor + 1, ";" )
      if Empty( cCol )
         return nil
      endif
      nOrder         := Val( StrToken( cCol, 1, ":" ) )
      if nOrder < 1 .or. nOrder > nLen
         return nil
      endif
      aadd( aNewOrder, nOrder )
   next

   ASort( ::aCols,,, { |x,y| x:nCreationOrder < y:nCreationOrder } )

   ::nRowHeight := nHeight

   for nFor := 1 to nLen
      cCol           := StrToken( cState, nFor + 1, ";" )
      nOrder         := Val( StrToken( cCol, 1, ":" ) )

      WITH OBJECT ::aCols[ nOrder ]
         :lHide      := ( AllTrim( StrToken( cCol, 4, ":" ) ) == "H" )
         :nWidth     := Val( StrToken( cCol, 2, ":" ) )
         :cHeader    := StrToken( cCol, 3, ":" )
         :cGrpHdr    := StrToken( cCol, 5, ":" )
         if Empty( :cGrpHdr )
            :cGrpHdr := nil
         endif
      END
   next

   AEval( aNewOrder, { |n| AAdd( aCols, ::aCols[ n ] ) } )
   ::aCols        := aCols

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

   if .not. ::lMultiSelect // ::nMarqueeStyle != MARQSTYLE_HIGHLROWMS .and. ::nMarqueeStyle != MARQSTYLE_HIGHLWIN7
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
      if ::lSqlRDD
         uCurRow  := ( ::cAlias )->( IfNil( OrdKeyVal(), "" ) + Str( RecNo() ) )
      endif
      Eval( ::bBookMark,  Atail( ::aSelected ) )
      uOldRow := ::KeyNo()
      if ::lSqlRDD
         uOldRow  := ( ::cAlias )->( IfNil( OrdKeyVal(), "" ) + Str( RecNo() ) )
      endif
      if uOldRow != uCurRow
         ::aSelected := { Atail( ::aSelected ) }
         if uCurRow > uOldRow
            CursorWait()
            do while ( uTemp := Eval( ::bBookMark ) ) != uBook .and. ! ::Eof()
               If Ascan( ::aSelected, uTemp ) == 0
                  Aadd( ::aSelected, uTemp )
               Endif
               ::Skip( 1 )
            enddo
            CursorArrow()
         else
            CursorWait()
            do while ( uTemp := Eval( ::bBookMark ) ) != uBook .and. ! ::Bof()
               If Ascan( ::aSelected, uTemp ) == 0
                  Aadd( ::aSelected, uTemp )
               endif
               ::Skip( -1 )
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
         ::Skip( 1 )
      enddo
      Eval( ::bBookMark, uBook )
      CursorArrow()
      // ::lRefreshOnlyData := .t.
      ::GetDC()
      ::Paint()
      ::ReleaseDC()

   case nOperation == 5 // Swap key (Shift + GoDown or GoUp)
      uBook = Eval( ::bBookMark )
      nAt = Ascan( ::aSelected, uBook )
      if nAt == 1 .and. Len( ::aSelected ) == 1
         return nil
      elseif nAt == 0
         Aadd( ::aSelected, uBook )
         ::DrawLine( .T. )
      else
         if nAt != Len( ::aSelected )
            Asize( ::aSelected, Len( ::aSelected ) - 1 )
            ::Refresh()
         endif
      endif

   end case

   if ::bOnMultiSelect != nil
      Eval( ::bOnMultiSelect, Self, nOperation )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowSeek( cSeek ) CLASS TXBrowse

   local oCol

   if ::oSeek != nil
      ::oSeek:SetText( IfNil( ::cSeek, "" ) )
   else
      for each oCol in ::aCols
         if If( ::lIncrFilter, ::oFilterCol == oCol, !Empty( oCol:cOrder ) )
            oCol:ShowSeek()
            EXIT
         endif
      next
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Seek( cSeek ) CLASS TXBrowse

   local uBook, uSeek
   local nFor, nRows, lRet := .f.
   local lRefresh

   if ::bSeek == nil
      return lRet
   endif

   if ::lIncrFilter
      if ValType( cSeek ) == 'C'
         uBook    := ::BookMark
         if Eval( ::bSeek, cSeek, @uSeek )
            lRet     := .t.
            if Empty( uSeek )
               ::Refresh( .t. )
//               if ::BookMark != uBook
                  ::Change( .t. )
//               endif
            else
               ::BookMark  := uSeek
               ::Refresh()
            endif
            ::cSeek     := cSeek
/*
            if ::oSeek != nil
               ::oSeek:SetText( cSeek )
            endif
*/
            ::ShowSeek( cSeek )
         else
            Eval( ::bSeek, ::cSeek )
            ::BookMark  := uBook
         endif
      endif

      return lRet

   endif

   If cSeek == nil
      if ! Empty( ::cSeek )
         ::cSeek := ""
         /*
         If ::oSeek != nil
            ::oSeek:SetText( "" )
         Endif
         */
         ::ShowSeek( "" )
      endif
      return lRet
   Endif

   uBook := ::BookMark

   if !Eval( ::bSeek, cSeek )
      ::BookMark  := uBook
      if Set( _SET_BELL )
         MsgBeep()
      endif
      return lRet
   endif

   lRet     := .t.
   ::cSeek  := cSeek
   uSeek    := ::BookMark
   /*
   if ::oSeek != nil
      ::oSeek:SetText( cSeek )
   endif
   */
   ::ShowSeek( cSeek )

   if uSeek == uBook
      // found on the same row. no change
      return .t.
   endif
   nRows    := ::nDataRows
   lRefresh := .t.
   // if the new position is already on the screen
   // change rowpos only
   ::BookMark  := uBook
   ::DrawLine( .f. )
   ::Skip( 1 - ::nRowSel )

   for nFor := 1 to nRows
      if ::BookMark == uSeek
         lRefresh := .f.
         exit
      endif
      if ::Skip( 1 ) == 0
         exit
      endif
   next

   if lRefresh
      ::BookMark  := uSeek
      ::Change( .t. )
//      ::Super:Refresh( .F. )
      ::Refresh()
   else
      if ! ::FullPaint
         ::BookMark  := uBook
         ::DrawLine( .f. )
      endif
      ::nRowSel   := nFor
      ::BookMark  := uSeek
      ::Change( .t. )
      if ::FullPaint
         ::Super:Refresh( .f. )
      else
         ::DrawLine( .t. )
      endif
   endif

   if ::oVScroll != nil
      ::VSetPos( ::KeyNo() )
   endif

return lRet

//----------------------------------------------------------------------------//

METHOD SetColumns( nRow, nCol, nFlags ) CLASS TXBrowse

   local oMenu, oCol, cPrompt
   local nFor, nLen
   local cPrvGrp  := ""
   local oGrpMenu
   local lChecked

   nLen := Len( ::aCols )

   MENU oMenu POPUP
      if ::l2000
         OSend( oMenu, "_L" + Str( ::n2KStyle, 4 ), .t. )
      endif

      for nFor := 1 to nLen
         oCol := ::aCols[ nFor ]
         if !( IfNil( oCol:cGrpHdr, "" ) == cPrvGrp )
            if ! Empty( cPrvGrp )
               ENDMENU
               oGrpMenu := nil
            endif
            if ! Empty( oCol:cGrpHdr )
               MENUITEM oCol:cGrpHdr BOLD
               MENU
                  MENUITEM oGrpMenu PROMPT oCol:cGrpHdr BOLD ;
                     ACTION ( lChecked := oMenuItem:lChecked, ;
                        AEval( oMenuItem:Cargo, ;
                        { |o| If( lChecked, o:Hide(), o:Show() ) } ) )
                  oGrpMenu:Cargo := {}
                  SEPARATOR
            endif
            cPrvGrp  := IfNil( oCol:cGrpHdr, "" )
         endif

         MenuAddItem( If( Empty( oCol:cHeader ), "Col-" + cValToChar( nFor ), oCol:cHeader ), ;
            nil, !oCol:lHide, ;
            ( Len(::aDisplay) != 1 .or. ocol:nPos != 1 ), ;
            { |o| If( o:Cargo:lHide, o:Cargo:Show(), o:Cargo:Hide() ) } ):Cargo := oCol

         if oGrpMenu != nil
            AAdd( oGrpMenu:Cargo, oCol )
            if !oCol:lHide
               oGrpMenu:lChecked := .t.
            endif
         endif

      next
      if ! Empty( cPrvGrp )
         ENDMENU
      endif

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
                     nNextPos := AScan( ::aDisplay, { |i| ::aCols[ i ]:lEditable }, ::nColSel + 1 )
                  endif
                  if nNextPos > 0
                     if .f. //::IsDisplayPosVisible( nNextPos, .t. )
                        // this alternative is temporarily disabled because due to some bug
                        // new column is not painted as hightlighted.
                        // this should be restored after fixing the bug  dt.2016-10-24
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
                     ::GoDown( 1, 1 )
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

   local oFont
   local nClr  := ::nClrText

   oFont       := ::oFont:Choose( @nClr )
   if oFont:hFont == ::oFont:hFont
      if nClr != ::nClrText
         ::nClrText  := nClr
         ::Refresh()
      endif
   else
      ::oFont     := oFont
      ::nClrText  := nClr
      ::ReCalcWH()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SetFont( oFont, lResizeCols ) CLASS TXBrowse

   if oFont != nil .and. oFont:hFont != ::oFont:hFont

      DEFAULT lResizeCols  := .f.

      ::Super:SetFont( oFont )

      if lResizeCols
         ::ReCalcWH()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD FontSize( nPlus ) CLASS TXBrowse

   local oFont

   if ::lCreated .and. ::oFont:nInpHeight < 0
      DEFAULT nPlus := 1
      DEFINE FONT oFont NAME ::oFont:cFaceName SIZE 0, ::oFont:nInpHeight - nPlus
      ::oFont:End()
      ::oFont  := oFont
      ::ReCalcWH()

   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReCalcWH() CLASS TXBrowse

   local oCol

   if ::lAdjusted
      AEval( ::aCols, { |o| o:oBtnList:SetFont( o:DataFont ), o:oBtnElip:SetFont( o:DataFont ) } )
      AEval( ::aCols, { |o| If( o:hChecked .and. o:bStrData == nil, o:bStrData := .f., nil ) } )   // FWH1712
      ::nWidths         := nil
      ::nCellHeights    := nil
      ::nHeaderHeight   := nil
      ::nRowHeight      := nil
      ::nFooterHeight   := nil

      ::lAdjusted       := .f.
      ::Adjust()
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ClpRow( lFullRow, aCols, lFormatted ) CLASS TXBrowse

   local n, u, RetVal := ""

   DEFAULT lFullRow     := ( ::nMarqueeStyle >= 4 ) .or. aCols != nil
   DEFAULT aCols        := ::GetVisibleCols()
   DEFAULT lFormatted   := .f. // Used for Export to MSWord

   AEval( aCols, { |u,i| If( ValType( u ) == 'O',, aCols[ i ] := ::oCol( u ) ) } )

   if lFullRow
      for n := 1 to Len( aCols )
         if lFormatted
            if aCols[ n ]:bStrData == nil
               RetVal   += If( ValType( u := aCols[ n ]:Value ) == 'L', If( u, "True", "False" ), "" ) + Chr( 9 )
            else
               RetVal += StrTran( StrTran( aCols[ n ]:StrData, CRLF, " ; " ), Chr(9), ' ' ) + Chr( 9 )
            endif
         else
            RetVal += aCols[ n ]:ClpText + Chr( 9 )
         endif
      next
   else
      RetVal := ::SelectedCol():ClpText
   endif

return RetVal

//----------------------------------------------------------------------------//

METHOD Copy( laRows, aCols ) CLASS TXBrowse

   local cText
   local uBm, n, aRows
   local lAll  := .f.

   if ValType( laRows ) == 'L' .and. laRows
      lAll     := .t.
   elseif ValType( laRows ) == 'A'
      aRows    := laRows
   else
      if !Empty( ::aSelected )
         aRows    := AClone( ::aSelected )
      endif
   endif

   uBm      := ::BookMark
   cText    := ""
   if lAll
      Eval( ::bGoTop )
      do while .t.
         if Empty( cText )
            cText    := ::ClpRow( .t., aCols )
         else
            cText    += CRLF + ::ClpRow( .t., aCols )
         endif
         if Eval( ::bSkip, 1 ) != 1
            EXIT
         endif
      enddo
   elseif Empty( aRows )
      cText       := ::ClpRow( nil, aCols )
   else
      for n := 1 to Len( aRows )
         ::BookMark  := aRows[ n ]
         if n > 1
            cText    += CRLF
         endif
         cText       += ::ClpRow( .t., aCols )
      next
   endif
   ::BookMark  := uBm

   if ::oClp:Open()
      ::oClp:SetText( cText )
      ::oClp:Close()
   endif

return cText

//----------------------------------------------------------------------------//

METHOD Paste( cText ) CLASS TXBrowse

   local aText, hBmp, nRows, nCols, n, j, uBm, cFile, oCol, nFormat

   if ::bPaste != nil
      Eval( ::bPaste, Self, cText )
      return nil
   endif

   if ::lReadOnly
      return nil
   endif

   oCol     := ::SelectedCol()
   if Empty( cText )
      nFormat     := GetClipContentFormat( 13, 1, 2, 15 )  // unicodetext, text, bitmap, file
      if nFormat == 2 // BITMAP
         if !oCol:lReadOnly .and. ( oCol:cDataType == nil .or. ;
                                    oCol:cDataType $ 'MPmU' )
            hBmp  := ::oClp:GetBitmap()
            if !Empty( hBmp )
               oCol:VarPut( BmpToStr( hBmp ) )
            endif
            cText    := nil
            ::oClp:Clear()
         else
            return nil
         endif
      elseif nFormat == 15  // FILE NAME
         if oCol:lReadOnly
            return nil
         else
            cFile    := ::oClp:GetFiles()[ 1 ]
            cText := MemoRead( cFile )
            ::oClp:Clear()
            if oCol:cDataType $ "F"
               oCol:VarPut( cFile )
               return nil
            else
               if IsBinaryData( cText )
                  if ( oCol:cDataType == nil .or. oCol:cDataType $ "MPm" )
                     oCol:VarPut( cText )
                  endif
                  return nil
               else
                  if oCol:cDataType == 'M'
                     oCol:VarPut( cText )
                     return nil
                  endif
               endif
            endif
         endif
      elseif nFormat == 13 .or. nFormat == 1
         if ::lUnicode .or. FW_SetUnicode()
            cText    := ::oClp:GetUnicodeText()
         else
            cText    := ::oClp:GetText()
         endif
         ::oClp:Clear()
      else
         return nil
      endif
      if oCol:cDataType $ "MPm" .and. !Empty( cText )
         if !oCol:lReadOnly
            oCol:VarPut( cText )
         endif
         return nil
      endif
   endif

   if Empty( cText )
      return nil
   endif

   if ( CRLF $ cText .or. Chr(9) $ cText )
      aText    := ClipTextAsArray( cText )
      if Len( aText ) == 1 .and. Len( aText[ 1 ] ) == 1
         ::SelectedCol():Paste( aText[ 1 ][ 1 ] )
         return nil
      endif
      if ::nDataType == DATATYPE_ARRAY
         If Empty( ::aArrayData )
            for n := 1 to Len( aText )
               AEval( aText[ n ], { |c,i| aText[ n, i ] := uCharToVal( c ) } )
            next
            ::aCols     := {}
            ::SetArray( aText )
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
               if HB_ISARRAY( aText[ n ] )
                  for j := 1 to Min( nCols, Len( aText[ n ] ) )
                     ::aCols[ ::aDisplay[ j + ::nColSel - 1 ] ]:Paste( aText[ n, j ] )
                  next j
               endif
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
            if HB_ISARRAY( aText[ n ] )
               for j := 1 to Min( nCols, Len( aText[ n ] ) )
                  ::aCols[ ::aDisplay[ j + ::nColSel - 1 ] ]:Paste( aText[ n, j ] )
               next j
            endif
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
   endif

   ::MakeTotals()
   ::RefreshFooters()

return nil

//----------------------------------------------------------------------------//

METHOD Eval( bBlock, bFor, bWhile, nNext, nRec, lRest ) CLASS TXBrowse

   local lFromTop    := bWhile == nil .and. nNext == nil .and. nRec == nil .and. Empty( lRest )
   local uBookMark
   local nRow        := 0

   DEFAULT bBlock := { || nil }, bFor := { || .t. }, bWhile := { || .t. }, ;
                     nNext := ::nLen, nRec := 0, lRest := .t.

   uBookMark      := ::BookMark
   if lFromTop
      ::GoTop()
   endif
   if nRec > 0
      ::BookMark  := nRec
      Eval( bBlock, Self )
   else
      do while ( ::cAlias )->( Eval( bWhile, Self ) )
         nRow++
         if ( ::cAlias )->( Eval( bFor, Self ) )
            ( ::cAlias )->( Eval( bBlock, Self ) )
         endif
         if nRow >= nNext .or. ::GoDown() < 1
            exit
         endif
      enddo
   endif
   ::BookMark     := uBookMark
   ::Refresh()

return Self

//----------------------------------------------------------------------------//

METHOD MakeTotals( aCols ) CLASS TXBrowse

   local uBm, n, k, nCols, oCol, nValue
   local bCond    := { |u,o| u != nil }

   if aCols == nil
      aCols    := {}
      for each oCol in ::aCols
         WITH OBJECT oCol
            if ( ValType( :nTotal ) == 'N' .and. :lTotal ) .or. ! Empty( :nFooterType )
               AAdd( aCols, oCol )
            endif
         END
      next
      ::aSumCols  := aCols
   else
      if ValType( aCols ) == 'O'
         aCols := { aCols }
      endif
      for n := 1 to Len( aCols )
         aCols[ n ]  := ::oCol( aCols[ n ] )
         if Empty( aCols[ n ]:nFooterType )
            ADel( aCols, n )
            ASize( aCols, Len( aCols ) - 1 )
         endif
      next
   endif

   if ! Empty( aCols )

      for each oCol in aCols
         WITH OBJECT oCol
            DEFAULT :nFooterType := AGGR_SUM
            :nTotal := :nTotalSq := 0.0
            :nCount := 0
            if :nFooterType == AGGR_MIN .or. :nFooterType == AGGR_MAX
               :nMinVal := nil
               :nMaxVal := nil
            endif
         END
      next

      nCols    := Len( aCols )
      uBm      := ::BookMark()
      Eval( ::bGoTop )
      k := 1
      ::KeyCount()
      if ::nLen > 0
         do
            for each oCol in aCols
               WITH OBJECT oCol
                  nValue   := :SumValue()
                  if nValue != nil
                     :nCount++
                     if :nMinVal == nil .or. nValue < :nMinVal
                        :nMinVal   := nValue
                     endif
                     if :nMaxVal == nil .or. nValue > :nMaxVal
                        :nMaxVal   := nValue
                     endif
                     if HB_ISNUMERIC( nValue )
                        :nTotal    += nValue
                        :nTotalSQ  += ( nValue * nValue )
                     endif
                  endif
               END
            next n
         until ( ++k > ::nLen .or. ::Skip( 1 ) < 1 )
      endif
      ::BookMark  := uBm      // ( uBm )  //2014-07-10 (uBm) does not work

   endif

return Self

//----------------------------------------------------------------------------//

METHOD SaveTotals( lBlank ) CLASS TXBrowse

   local oCol

   if ! Empty( ::aSumCols )

      ::aSumSave     := {}
      DEFAULT lBlank := .f.

      for each oCol in ::aSumCols
         AAdd( ::aSumSave, { If( lBlank, nil, oCol:SumValue ), oCol:nTotal } )
      next

   endif

return ::aSumSave

//----------------------------------------------------------------------------//

METHOD ReCalcTotals( lReduce ) CLASS TXBrowse

   local n, oCol, nNewVal, nOldVal
   local lRetotal := .f.

   DEFAULT lReduce := .f.

   if ! Empty( ::aSumSave )

      for n := 1 to Len( ::aSumSave )

         oCol     := ::aSumCols[ n ]
         nNewVal  := If( lReduce, nil, oCol:SumValue() )
         if ::aSumSave[ n, 2 ] == oCol:nTotal .and. ; // totals are same
            ::aSumSave[ n, 1 ] != nNewVal  // Value changed

            nOldVal     := ::aSumSave[ n, 1 ]
            WITH OBJECT oCol
               if nOldVal != nil
                  :nCount--
                  if :nMinVal != nil .and. nOldVal == :nMinVal .and. ;
                        ( nNewVal == nil .or. nOldVal < nNewVal )
                     :nMinVal := nil
                  endif
                  if :nMaxVal != nil .and. nOldVal == :nMaxVal .and. ;
                        ( nNewVal == nil .or. nOldVal > nNewVal )
                     :nMaxVal := nil
                  endif
                  if HB_ISNUMERIC( nOldVal )
                     :nTotal     -= nOldVal
                     :nTotalSQ   -= ( nOldVal * nOldVal )
                  endif
               endif
               if nNewVal != nil
                  :nCount++
                  if :nMinVal != nil .and. nNewVal < :nMinVal
                     :nMinVal := nNewVal
                  endif
                  if :nMaxVal != nil .and. nNewVal > :nMaxVal
                     :nMaxVal := nNewVal
                  endif
                  if HB_ISNUMERIC( nNewVal )
                     :nTotal     += nNewVal
                     :nTotalSQ   += ( nNewVal * nNewVal )
                  endif
               endif
            END
            lRetotal    := .t.
         endif

      next
      ::aSumSave  := nil
   endif

return lRetotal

//----------------------------------------------------------------------------//

METHOD Report( cTitle, lPreview, lModal, bSetUp, aGroupBy, cPDF ) CLASS TXBrowse

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

   oPrn :=  PrintBegin( cTitle, ;            // document
                        .f., ;            // luser
                        lPreview, nil, ;  // xmodel
                        lModal, ;
                        .f.,    ;         // lselect
                        cPDF )            // PDF to Save

   if oPrn:hDC == 0
       return .f.
   endif

   if ValType( aGroupBy ) $ "ON"
      aGroupBy    := { aGroupBy }
   endif

   DEFINE FONT oFont NAME 'TAHOMA' SIZE 0, - 8
   DEFINE FONT oBold NAME 'TAHOMA' SIZE 0, - 8 BOLD

   REPORT oRep TITLE cTitle ;
          FOOTER "Page : " + cValToChar( oRep:nPage ) CENTER ;
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
   oRep:bToExcel    := { || oBrw:ToExcel( nil, If( Empty( aGroupBy ), nil, 1 ) ) }
   oRep:lJoin       := .t.

   if ::oTree != nil

      oRep:bFor      := { || If( ::oTreeItem:nLevel < nLevels, ;
                           oRep:Cargo[ ::oTreeItem:nLevel ] := ::oTreeItem:cPrompt, ), ;
                           ::oTreeItem:nLevel == nLevels }
   endif

   ( ::cAlias )->( oRep:Activate() )

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

METHOD ToWord( bProgress, aCols, nWrdTblFormat, nPageOrientation ) CLASS TXBrowse

   // by Mr. Anser K.K

   Local oWord, oDoc, oRange, oCol
   Local nRow, nCol
   Local uBookMark, cRowData, cTableData
   Local lFooterExist:=.F.

   DEFAULT aCols              := ::GetVisibleCols()
   if ::nLen < 1 .or. Empty( aCols )
      return nil
   endif

   DEFAULT nWrdTblFormat      := wdTableFormatGrid8  //18, 23, 37, 41
   DEFAULT nPageOrientation   := 0 //   wdOrientPortrait = 0 , wdOrientLandscape = 1

   nPageOrientation           := minmax( nPageOrientation, 0, 1 )
   nWrdTblFormat              := minmax( nWrdTblFormat, 0, 42 )

   if ( oWord := WinWordObj() ) == nil
      MsgAlert( FWString( "Word not installed" ) )
      return nil
   endif

   CursorWait()
   // Word settings to improve perfomance
   oWord:ScreenUpdating     := .F.

   oDoc:=oWord:Documents:Add()
   oRange                     := oDoc:Range()

   oWord:ActiveDocument:PageSetup:Orientation = nPageOrientation //  wdOrientLandscape = 1, wdOrientPortrait = 0

   if bProgress == nil
      if ::oWnd:oMsgBar == nil
         bProgress := { || nil }
      else
         bProgress := { | n, t | ::oWnd:SetMsg( "MS Word" + " : " + ;
                                 Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
      endif
   endif
   Eval( bProgress, 0, ::nLen )

   // Create Col Header String
   cRowData:=""; cTableData:=""
   for nCol := 1 TO Len( aCols )
      oCol   := aCols[ nCol ]
      cRowData += oCol:cHeader + chr(9)
   next
   cRowData    := Left( cRowData, Len( cRowData ) - 1 )
   cRowData    +=CRLF
   cTableData  :=cRowData

   // Create Data Rows
   cRowData:=""

   uBookMark   := ::BookMark
   Eval( ::bGoTop )
   nRow        := 1
   REPEAT
      cRowData    := Alltrim( ::ClpRow( .T., aCols, .T. ) )
      cRowData    :=Left( cRowData, Len( cRowData ) - 1 )
      cTableData  += cRowData + CRLF
      Eval( bProgress, nRow, ::nLen )
      nRow++
   UNTIL Eval( ::bSkip, 1 ) == 0
   ::BookMark     := uBookMark

   // Getting Footer Text
   cRowData    := ""
   for nCol := 1 TO Len( aCols )
      oCol     := aCols[ nCol ]
      if !Empty( oCol:FooterStr() )
         lFooterExist:=.T.
      Endif
      cRowData += oCol:FooterStr() + chr(9)
   next
   cRowData := Left( cRowData, Len( cRowData ) - 1 )

   if lFooterExist
      cTableData  += cRowData + CRLF
   Endif

   Eval( bProgress, ::nLen, ::nLen )

   oRange:Text = cTableData
   oRange:ConvertToTable( VK_TAB,AdoDefault() ,AdoDefault() ,AdoDefault() , nWrdTblFormat,;
                          AdoDefault(), AdoDefault(), AdoDefault(), AdoDefault(), .T.,;
                          AdoDefault(), AdoDefault(), AdoDefault(), .T., .T. , AdoDefault() )

   // Do the Alignment Process
   for nCol := 1 TO Len( aCols )
      oCol   := aCols[ nCol ]
      oDoc:Tables[1]:Columns[nCol]:Select()
      DO CASE
          CASE oCol:nDataStrAlign == AL_LEFT
            oWord:Selection:ParagraphFormat:Alignment = 0
          CASE oCol:nDataStrAlign == AL_CENTER
            oWord:Selection:ParagraphFormat:Alignment = 1
          CASE oCol:nDataStrAlign == AL_RIGHT
            oWord:Selection:ParagraphFormat:Alignment = 2
      ENDCASE
   Next

   if lFooterExist  // Make the last Row ie Totals Bold
      oDoc:Tables[1]:ApplyStyleLastRow = .T.
   Endif

   oDoc:Tables[1]:Rows[1]:Select()
   oWord:Selection:Collapse( 1)

   ::Refresh()
   ::SetFocus()

   oWord:ScreenUpdating   := .T.
   oWord:Visible          := .T.

Return oDoc

//----------------------------------------------------------------

METHOD ToHtml( cHtml, lShow ) CLASS TXBrowse

   local xlHtml      := 44
   local oSheet

   DEFAULT cHtml := If( Empty( ::cTitle ), If( Empty( ::oWnd:cTitle ), "XBROWSE", ::oWnd:cTitle ), ::cTitle ) + ".html"
   DEFAULT lShow  := .t.

   CursorWait()
   oSheet      := ::ToExcel( nil, nil, nil, .f. )

   if ValType( oSheet ) != 'O' .or. lExcelInstl == .f.
      return ""
   endif

   cHtml       := TrueName( cHtml )
   WITH OBJECT oSheet:Parent
      :Application:DisplayAlerts := .f.
      :SaveAs( cHtml, xlHtml )
      :Close()
   END

   if lShow
      ShellExecute( 0, "Open", cHtml )
   endif
   CursorArrow()
   ::SetFocus()

return cHtml

//----------------------------------------------------------------------------//

METHOD ToCSV( cFile, aCols, lHeaders, cTrue, cFalse ) CLASS TXBrowse

   local cCsv    := ""
   local n, cLine, uVal, c, uBm, hFile
   local oExcel, oBook

   if aCols == nil
      aCols  := ::GetVisibleCols()
   else
      AEval( aCols, { |o,i| aCols[ i ] := ::oCol( o ) } )
   endif

   DEFAULT lHeaders := .t., cTrue := cXlTrue, cFalse := cXlFalse

   if lHeaders
      for n := 1 to Len( aCols )
         if n > 1
            cCsv  += ","
         endif
         cCsv  += '"' + StrTran( aCols[ n ]:cHeader, CRLF, " " ) + '"'
      next
   endif

   uBm      := ::BookMark
   Eval( ::bGoTop )

   REPEAT
      cLine    := ""

      for n := 1 to Len( aCols )

         c     := ""

         uVal  := aCols[ n ]:Value
         c := FW_ValToCSV( uVal, cTrue, cFalse )

         if n > 1
            cLine    += ","
         endif
         cLine    += c

      next

      if !Empty( cCsv )
         cCsv += CRLF
      endif

      cCsv    += cLine

   UNTIL Eval( ::bSkip, 1 ) == 0
   ::BookMark  := uBm

   if !Empty( cFile )
      cFile    := TrueName( cFile )
      if ( hFile := fCreate( cFile, 0 ) ) > 0
         fWrite( hFile, cCsv )
         fClose( hFile )
         cCsv  := nil
      endif
   endif

return IfNil( cFile, cCsv )

//----------------------------------------------------------------------------//

METHOD ToExcel( bProgress, nGroupBy, aCols, lShow, cPDF, bPrePDF ) CLASS TXBrowse

   local oExcel, oBook, oSheet, oWin
   local nCol, nXCol, oCol, cType, uValue, nAt, cFormula
   local uBookMark, nRow
   local nDataRows
   local cText, nPasteRow, nStep, cFormat
   local aTotals  := {}, lAnyTotals := .f.
   local aWidths  := {}
   local lContinue   := .t.
   // locals used for group header export
   local n, nGrpStart := 0, nGrpLast, cGrpHdr, cPrvHdr, oRange

   if ::bToExcel != nil
      return Eval( ::bToExcel, Self, bProgress, nGroupBy, aCols, lShow, cPDF, bPrePDF )
   endif

   DEFAULT lShow  := .t.

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
         MsgAlert( FWString( "Excel not installed" ), FWString( "Alert" ) )
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
         CASE Empty( cType )
            // no action
         CASE cType == 'N'
            cFormat     := Dbf2ExcelNumFormat( oCol:cEditPicture )
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
                  oSheet:Columns( nCol ):HorizontalAlignment := If( lAnd( oCol:nDataStrAlign, AL_CENTER ), -4108, -4152 )
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
               bProgress := { | n, t | ::oWnd:SetMsg( FWString( "To Excel" ) + ;
                              " : " + Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
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
            if ::oClp:Open()

               Eval( bProgress, 0, nDataRows )

               do while nRow <= ( nDataRows + 1 ) .and. lContinue
                  if ! Empty( cText )
                     cText += CRLF
                  endif
                  cText    += ::ClpRow( .t., aCols )

//                  lContinue := ( ::Skip( 1 ) == 1 )
                  lContinue := nRow < ( nDataRows + 1 ) .and. ( ::Skip( 1 ) == 1 )
                  nRow ++

                  if Len( cText ) > 16000
                     ::oClp:SetText( cText )
                     oSheet:Cells( nPasteRow, 1 ):Select()
                     oSheet:Paste()
                     ::oClp:Clear()
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
                  ::oClp:SetText( cText )
                  oSheet:Cells( nPasteRow, 1 ):Select()
                  oSheet:Paste()
                  ::oClp:Clear()
                  cText    := ""
               endif

               Eval( bProgress, nDataRows, nDataRows )
               SysRefresh()

            endif
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
            cFormula:= "SUBTOTAL(" + ;
                        LTrim( Str( FW_DeCode( IfNil( oCol:nFooterType, 0 ), AGGR_SUM, 9, AGGR_MAX, 4, AGGR_MIN, 5, ;
                        AGGR_COUNT, 3, AGGR_AVG, 1, AGGR_STDEV, 7, AGGR_STDEVP, 8, 9 ) ) ) + ;
                        "," + ;
                        oSheet:Range( oSheet:Cells( 2, nCol ), ;
                                      oSheet:Cells( nRow - 1, nCol ) ):Address( .f., .f. ) + ;
                        ")"
            oSheet:Cells( nRow, nCol ):Formula := '=' + ExcelTranslate( cFormula )
            lAnyTotals := .t.
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

   if ::lGrpHeader == .t.

      nGrpStart   := 0

      WITH OBJECT oSheet:Rows( "1:1" )
         :Insert()
         :Font:Bold := .t.
      END
      for n := 1 to Len( ::aCols )
         cGrpHdr     := ::aCols[ n ]:cGrpHdr
         if Empty( cGrpHdr )
            cPrvHdr     := nil
            if nGrpStart > 0
               oRange   := oSheet:Range( oSheet:Cells( 1, nGrpStart ), oSheet:Cells( 1, nGrpLast ) )
               oRange:MergeCells := .t.
               oRange:HorizontalAlignment := -4108
            endif
            nGrpStart   := 0
            nGrpLast    := 0
            oRange   := oSheet:Range( oSheet:Cells( 1, n ), oSheet:Cells( 2, n ) )
            oRange:MergeCells := .t.
         else
            if cGrpHdr == cPrvHdr
               nGrpLast    := n
            else
               oSheet:Cells( 1, n ):Value := cGrpHdr
               cPrvHdr     := cGrpHdr
               if nGrpStart > 0
                  oRange   := oSheet:Range( oSheet:Cells( 1, nGrpStart ), oSheet:Cells( 1, nGrpLast ) )
                  oRange:MergeCells := .t.
                  oRange:HorizontalAlignment := -4108
               endif
               nGrpStart   := n
               nGrpLast    := n
            endif
         endif
      next

   endif
/*
   oSheet:Cells(1,1):Select()
   oWin   := oExcel:ActiveWindow
   oWin:SplitRow := 1
   oWin:FreezePanes := .t.
*/

//   oWin:DisplayZeros := .f.

   Eval( ::bBookMark, uBookMark )
   ::Refresh()
   ::SetFocus()

   if ValType( cPDF ) == 'C'

      cPdf        := cFileSetExt( cPDF, "pdf" )
      cPdf        := TrueName( cPDF )
      if bPrePDF != nil
         Eval( bPrePDF, oSheet, Self )
      endif
      oSheet:Parent:ExportAsFixedFormat( 0, cpdf, AdoDefault(), AdoDefault(), ;
                 AdoDefault(), AdoDefault(), AdoDefault(), lShow )

      SysRefresh()

   elseif lShow
      oExcel:ScreenUpdating   := .t.
      oExcel:visible          := .T.
      ShowWindow( oExcel:hWnd, 3 )
      BringWindowToTop( oExcel:hWnd )

#ifndef __XHARBOUR__
   else
      //
      SysRefresh()
      //
      // This requires explanation.
      // With xHarbour there is no problem. Problem is with Harbour only
      // return value of this function is oSheet which is an Object. xHarbour returns as object
      // If SysRefresh() is called here, Harbour returns oSheet as an object
      // if not it returns an Array of two numeric elements.
      // I am unable to understand this phenomenon.
      // Till we understand what is happening, keep SysRefresh() here for
      // Harbour build.
      // 2015-06-02
#endif
   endif

return oSheet

//----------------------------------------------------------------------------//

METHOD ToCalc( bProgress, nGroupBy, nPasteMode, aSaveAs, aCols ) CLASS TXBrowse

   local oCalc, oDeskTop,oBook, oSheet, oWin, oLocal, oDispatcher
   local nCol, nXCol, oCol, cType, uValue, nAt
   local uBookMark, nRow
   local nDataRows
   local cText, nPasteRow, nStep, cFormat,cFileName,cURL,i
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

   DEFAULT nPasteMode:=2
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
         MsgAlert( FWString( "No spreadsheet software installed" ),;
                   FWString( "Alert" ) )
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

      oSheet:GetCellByPosition( nCol-1, nRow-1 ):SetString( oCol:cHeader )
      cType      := oCol:cDataType

      DO CASE
         CASE cType == 'N'

            cFormat     := If( FWNumFormat()[ 2 ], If( lxlEnglish, "#,##0", "#.##0" ), "0" )
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
             // oSheet:GetColumns():GetByIndex( nCol-1 ):NumberFormat:= "@"
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
   /*  Commented by Anser. This is not required. Shall remove this later
   AAdd(aProp,GetPropertyValue(oCalc,  "FilterName", "Text" ) )
   AAdd(aProp,GetPropertyValue(oCalc, "FilterOptions", "9,,MS_1257,0,2/2/2/2/2/2/2/2/2/2/2/2/2/2/2/2"   )        )
   AAdd(aProp,GetPropertyValue(oCalc,  "Format" , 10 ) )
   */
    if Empty( ::aSelected ) .or. Len( ::aSelected ) == 1

      Eval( ::bGoTop )

      if bProgress == nil
         if ::oWnd:oMsgBar == nil
            bProgress := { || nil }
         else
            bProgress := { | n, t | ::oWnd:SetMsg( FWString( "To Calc" ) + " : " + ;
                                    Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
         endif
      endif

      nRow      := 2
      nPasteRow := 2
      nStep     := Max( 1, Min( 100, Int( nDataRows / 100 ) ) )
      cText     := ""
      if ::oClp:Open()

         Eval( bProgress, 0, nDataRows )
         do while nRow <= ( nDataRows + 1 ) .and. lContinue
            if ! Empty( cText )
               cText += Chr(13) // Changed CRLF to Chr(13)
            endif
            cText    += ::ClpRow( .t. )

            lContinue := ( ::Skip( 1 ) == 1 )
            nRow ++

            if Len( cText ) > 16000
               ::oClp:SetText( cText )
               oBook:CurrentController:select( oSheet:GetCellByPosition( 0,nPasteRow-1 ) )
               IF nPasteMode == 2
                  oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Paste", "", 0, aProp)
               else
                  PasteUnformattedText(oCalc,oBook,oSheet,aCols)
               Endif
               ::oClp:Clear()
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
            ::oClp:SetText( cText )
            oBook:CurrentController:select( oSheet:GetCellByPosition( 0,nPasteRow-1 ) )
            IF nPasteMode == 2
               oDispatcher:ExecuteDispatch(oBook:GetCurrentController():GetFrame(), ".uno:Paste", "", 0, aProp)
            else
               PasteUnformattedText(oCalc,oBook,oSheet,aCols)
            Endif
            ::oClp:Clear()
            cText    := ""
         endif
         ::oClp:Close()

         Eval( bProgress, nDataRows, nDataRows )
         SysRefresh()

      endif

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

METHOD ToDbf( cFile, bProgress, aCols, lPrompt ) CLASS TXBrowse

   local aStruct  := {}
   local nKeyNo   := ::KeyNo
   local nRowPos  := ::nRowSel
   local n, uVal, c, oCol, nCols
   local nSelect

   if ::nLen < 1
      return nil
   endif

   DEFAULT lPrompt := .f.

   if aCols == nil
      aCols    := ::GetVisibleCols()
   else
      AEval( aCols, { |u,i| aCols[ i ] := ::oCol[ u ] } )
   endif

   ::GoTop()
   nCols       := Len( aCols )

   for each oCol in aCols
      uVal     := oCol:Value
      AAdd( aStruct, { Upper( PadR( oCol:cHeader, 10 ) ), oCol:cDataType, oCol:nDataLen, oCol:nDataDec } )
      if Empty( oCol:cHeader )
         ATail( aStruct )[ 1 ]   := "COL" + StrZero( oCol:nCreationOrder, 2 )
      endif
      if Empty( c := oCol:cDataType ) .or. !( c $ 'DLMNT' )
         ATail( aStruct )[ 2 ]   := c := If( uVal == nil, 'C', ValType( uVal ) )
      endif
      if Empty( oCol:nDataLen ) .or. c $ "DTLM"
         ATail( aStruct )[ 3 ]   := HB_DeCode( c, 'C', 40, 'D', 8, 'T', 8, 'L', 1, 'N', 14, 10 )
      endif
      if c == 'N'
         if oCol:nDataDec == nil
            ATail( aStruct )[ 4 ]   := 0
         endif
      else
         ATail( aStruct )[ 4 ]   := 0
      endif

   next

   if lPrompt
      XBROWSER aStruct TITLE cFile + ":STRUCTURE" FASTEDIT ;
         SETUP (oBrw:cEditPictures := { '@!', '!', '99','99' } )
   endif

   nSelect  := Select()

   DBCREATE( cFile, aStruct )

   if bProgress == nil
      if ::oWnd:oMsgBar == nil
         bProgress := { || nil }
      else
         bProgress := { | n, t | ::oWnd:SetMsg( FWString( "To DBF" ) + " : " + ;
                                 Ltrim( Str( n ) ) + "/" + Ltrim( Str( t ) ) ) }
      endif
   endif

   Eval( bProgress, 0, ::nLen )

   USE (cFile) NEW ALIAS XBRTODBF EXCLUSIVE
   REPEAT

      XBRTODBF->( DbAppend() )
      for n := 1 to nCols
         C     := aStruct[ n ][ 2 ] // datatype
         uVal  := aCols[ n ]:Value
         if ! Empty( uVal )
            if c == 'C'
               if ValType( uVal ) != 'C'
                  uVal     := cValToChar( uVal )
               endif
            elseif ValType( uVal ) == 'C'
               uVal  := uCharToVal( uVal, c )
            endif
            TRY
               XBRTODBF->( FieldPut( n, aCols[ n ]:Value ) )
            CATCH
               // datatype mismatch or data len exceeds
            END
         endif
      next
      Eval( bProgress, XBRTODBF->( RecNo() ), ::nLen )

   UNTIL ::Skip( 1 ) == 0
   Eval( bProgress, XBRTODBF->( LASTREC() ), XBRTODBF->( LASTREC() ) )
   CLOSE XBRTODBF

   ::KeyNo     := nKeyNo
   ::nRowSel   := nRowPos
   ::Refresh()

   if lPrompt .and. MsgYesNo( If( FWSetLanguage() == 2, "¿ ", "" ) + ;
                              FWString( "View" ) + " " + cFile + " ?",;
                              FWString( "Please select" ) )
      XBrowse( cFile )
   endif

   ::SetFocus()

return nil

//----------------------------------------------------------------------------//

/*
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
*/

//----------------------------------------------------------------------------//

static Function MakeColAlphabet( nCol )

   local cCol  := ""
   local nDigit

   do while nCol > 0
      nDigit   := nCol % 26
      if nDigit == 0
         nDigit   := 26
         nCol     -= 26
      endif
      cCol     := Chr( nDigit + 64 ) + cCol
      nCol     := Int( nCol / 26 )
   enddo

return cCol

//------------------------------------------------------------------//

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
        MsgInfo( FWString( "Could not set the format" ) + " " + cNumberFormat + " " + ;
                 FWString( "to column" ) + " " + cColHeader, FWString( "Information" ) )
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

METHOD DataRow( lNew, cFieldList, lSourceData ) CLASS TXBrowse

   local oRec
   local u

   if ValType( cFieldList ) == 'L' .or. ValType( lSourceData ) == 'C'
      u           := lSourceData
      lSourceData := cFieldList
      cFieldList  := u
   endif

   DEFAULT lNew   := ( ::nLen == 0 ), lSourceData := .f.

   if ::bDataRow == nil
      oRec  := TDataRow():New( If( lSourceData, ::uDataSource, Self ), cFieldList, lNew )
   else
      oRec  := Eval( ::bDataRow, Self, cFieldList, lNew )
   endif
   DEFAULT oRec:bEdit     := ::bEdit
   oRec:oBrw      := Self
   if !Empty( oRec:RecNo )
      ::RefreshCurrent()
   endif
   if ! Empty( ::cTitle )
      oRec:cTitle    := ::cTitle
   endif

return oRec

//----------------------------------------------------------------------------//

METHOD Edit( lNew, cFieldList, lSourceData, lNavigate ) CLASS TXBrowse

   local u

   if ValType( cFieldList ) == 'L' .or. ValType( lSourceData ) == 'C'
      u           := lSourceData
      lSourceData := cFieldList
      cFieldList  := u
   endif

   ::DataRow( lNew, lSourceData, cFieldList ):Edit( nil, lNavigate )
/*
   if lSourceData == .t.
      ::Refresh()
   endif
*/
   ::SetFocus()

return Self

//----------------------------------------------------------------------------//

METHOD aCellCoor( nRow, nCol ) CLASS TXBrowse

   local nTop, nLeft, nBottom, nRight
   local oCol

   DEFAULT nRow := ::nRowSel, nCol := ::nColSel

   oCol     := ::ColAtPos( nCol )
   nTop     := ( ( nRow - 1 ) * ::nRowHeight ) + ::HeaderHeight( .t. )
   nLeft    := oCol:nDisplayCol
   nBottom  := nTop + ::nRowHeight - 1
   nRight   := nLeft + oCol:nWidth - 1

return { nTop, nLeft, nBottom, nRight }

//----------------------------------------------------------------------------//

METHOD CellBitmap( nRow, nCol ) CLASS TXBrowse

   local oRect    := TRect():New( ::aCellCoor( nRow, nCol ) )

return MakeBkBmpEx( ::hWnd, oRect:nTop, oRect:nLeft, oRect:nWidth, oRect:nHeight )

//----------------------------------------------------------------------------//

METHOD ShowMessage( cMsg, nSecs, nClrText, nClrBack ) CLASS TXBrowse

   local nTop, nLeft, nBottom, nRight
   local oBrush, hBack
   local nWidth, nHeight, u

   DEFAULT cMsg      := "This is a message" , ;
           nSecs     := 2, ;
           nClrText  := CLR_YELLOW, ;
           nClrBack  := { { 1, CLR_BLACK, CLR_HRED }, .F. }

   u        := CalcTextWH( Self, cMsg, ::oFont )
   nWidth   := u[ 1 ] + 20
   nHeight  := u[ 2 ] + 20

   nTop     := ( ( ::nRowSel - 1 ) * ::nRowHeight ) + ::HeaderHeight( .t. )

   if nTop >= nHeight
      nBottom  := nTop - 2
      nTop     := nBottom - nHeight
   else
      nTop     += ::nRowHeight + 2
      nBottom  := nTop + nHeight
   endif
   nLeft       := ::SelectedCol():nDisplayCol
   nRight      := nLeft + nWidth
   if nRight > ( u := ::DataRect():nRight )
      u  := nRight - u
      nRight   -= u
      nLeft    -= u
   endif

   hBack    := FWSaveScreen( ::hWnd, nTop, nLeft, nBottom, nRight )

   if ValType( nClrBack ) == 'N' .and. nClrBack >= 0 .and. nClrBack <= 0x00ffffff
      // color constant
      nClrBack := NARGB( 255, nClrBack )
   endif

   ::SayText( cMsg, { nTop, nLeft, nBottom, nRight }, nil, nil, nClrText, nClrBack, .t. )
   Sleep( nSecs * 1000 )
   FWRestScreen( ::hWnd, hBack, nTop, nLeft, nBottom, nRight )

return .f.   // for use in bEditValid

//----------------------------------------------------------------------------//

METHOD DestroyToolTip() CLASS TXBrowse

  TWindow():DestroyToolTip()
  ::oColToolTip   := nil
  ::nRowToolTip   := nil

return nil

//----------------------------------------------------------------------------//

METHOD NcMouseMove( nHitTestCode, nRow, nCol ) CLASS TXBrowse

   TWindow():NcMouseMove( nHitTestCode, nRow, nCol )
   ::oColToolTip   := nil

return nil

//----------------------------------------------------------------------------//

METHOD OnError(...) CLASS TXBrowse

   local aParams  := HB_AParams()
   local uParam1  := If( Len( aParams ) > 0, aParams[ 1 ], nil )
   local cMsg     := __GetMessage()
   local nError   := If( SubStr( cMsg, 1, 1 ) == "_", 1005, 1004 )
   local oCol, aRet, uVal
   local lByCreationOrder  := .t.
   local lAssign  := .f.

   if Left( cMsg, 1 ) == '_'
      lAssign     := .t.
      nError      := 1005
      cMsg        := SubStr( cMsg, 2 )
   endif
   oCol           := ::oCol( cMsg )

   if oCol == nil
      if ! Empty( ::aCols ) .and. Len( cMsg ) > 3 .and. Upper( Right( cMsg, 1 ) ) == 'S' .and. ;
         __ObjHasData( ::aCols[ 1 ], Left( cMsg, Len( cMsg ) - 1 ) )
         cMsg     := Left( cMsg, Len( cMsg ) - 1 )
         if lAssign
            ::SetColsData( cMsg, uParam1 )
            return uParam1
         else
            return ::GetColsData( cMsg )
         endif
      elseif HB_HHasKey( ::hCargo, cMsg )
         if lAssign
            ::hCargo[ cMsg ] := uParam1
            return ::hCargo[ cMsg ]
         else
            if ValType( uVal := ::hCargo[ cMsg ] ) == 'B'
               AIns( aParams, 1, Self, .t. )
               uVal  := HB_ExecFromArray( uVal, aParams )
            endif
            return uVal
         endif
      elseif lAssign .and. ValType( uParam1 ) == 'B'
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

/*
static function treerecno( oItem )

   local nRec  := - 10000

   oItem:Skip( @nRec )

return -nRec

//----------------------------------------------------------------------------//
*/

static function MakeRepCol( oRep, oXCol )

   local oCol, bData, cPic, nSize, aChart
   local cAlign, vAlign, aClr
   local aHeader

   aHeader  := HB_ATokens( oXCol:cHeader, CRLF )
   AEval( aHeader, { |c,i| aHeader[ i ] := MakeRecColBlock( c ) } )
/*
   if ! Empty( oXCol:cGrpHdr )
      AIns( aHeader, 1, { || oXCol:cGrpHdr }, .t. )
   endif
*/
   bData := { || oXCol:Value }
   if oXCol:bEditValue != nil
      cPic  := oXCol:cEditPicture
   endif

   if Empty( cPic )
      nSize       := oxCol:nWidthChr
   endif

   if oxCol:lProgBar
      aClr     := Eval( oxCol:bClrProg, oxCol )
      if Len( oxCol:aBitmaps ) > 1 .and. ;
         HB_ISNUMERIC( aClr[ 1 ] ) .and. aClr[ 1 ] <= Len( oxCol:aBitmaps ) .and. ;
         HB_ISNUMERIC( aClr[ 2 ] ) .and. aClr[ 2 ] <= Len( oxCol:aBitmaps )

         aClr[ 1 ]   := oxCol:aBitmap( aClr[ 1 ] )
         aClr[ 2 ]   := oxCol:aBitmap( aClr[ 2 ] )

      endif
      nSize    := oxCol:nWidth / 10
      oCol := RptAddColumn( aHeader, nil ,;
                            { bData }, nSize, nil ,;
                            nil, nil, nil ,;
                            "RIGHT", .F., .F., nil, ;
                            nil, nil, ;
                            nil, nil, nil, nil, nil, ;
                            nil, nil, nil, nil, nil, nil, ;
                            nil, ;
                            XEval( oxCol:nProgTot , oxCol ), aClr )

   elseif ! Empty( oxCol:aChartCols )
      bData    := { || "" }
      aChart   := oxCol:ChartArrayVals( .t. )
      oCol := RptAddColumn( aHeader, nil ,;
                            { bData }, nSize, nil ,;
                            nil, nil, nil ,;
                            "CENTER", .F., .F., nil, ;
                            nil, nil, ;
                            nil, nil, nil, nil, nil, ;
                            aChart, nil, nil, oxCol:nChartMaxVal, oxCol:aChartColors, oxCol:cChartType )

   elseif bData != nil

      cAlign   := If( lAnd( oXCol:nDataStrAlign, AL_RIGHT  ), "RIGHT", ;
                  If( lAnd( oXCol:nDataStrAlign, AL_CENTER ), "CENTER", "LEFT" ))

      vAlign   := If( lAnd( oXCol:nDataStrAlign, AL_TOP ), "TOP", ;
                  If( lAnd( oXCol:nDataStrAlign, AL_BOTTOM ), "BOTTOM", "VCENTER" ))

      oCol := RptAddColumn( aHeader, nil ,;
                            { bData }, nSize, { cPic } ,;
                            nil, oXCol:lTotal, nil ,;
                            cAlign, .F., .F., nil, ;
                            oxCol:cDataType == 'M', oxcol:cDataType $ 'FP', ;
                            nil, nil, nil, oxCol:nAlphaLevel(), nil, ;
                            nil, nil, nil, nil, nil, nil, vAlign )

   endif

   if ! Empty( oXCol:cGrpHdr )
//      AIns( aHeader, 1, { || oXCol:cGrpHdr }, .t. )
      oCol:cGrpTitle    := oxCol:cGrpHdr
   endif

return oCol

//----------------------------------------------------------------------------//

static function MakeRecColBlock( c )
return { || c }

//----------------------------------------------------------------------------//

static function MakeRepGroup( oCol )

//   local bData    := { || oCol:cHeader + " " + Eval( oCol:bStrData, nil, oCol ) }
   local bData    := { || oCol:cHeader + " " + cValToChar( oCol:StrData ) }

   if ! Empty( bData )
       RptAddGroup( bData, bData, nil, { || 2 }, .f. )
   endif

return nil

//----------------------------------------------------------------------------//
static function MakeRepTreeGroup( oBrw, oRep, n )

   RptAddGroup( { || oRep:Cargo[ n ]  }, { || oRep:Cargo[ n ] }, nil, { || 2 },, .f. )

return nil

//----------------------------------------------------------------------------//

/*
static function RepTreeFor( oBrw, oRep, nCols, nLevels )

   local nLevel   := oBrw:oTreeItem:nLevel

   nCols    := Len( oRep:aColumns )

   if nLevel < nLevels
      oRep:Cargo[ nLevel ] := oBrw:oTreeItem:cPrompt
   endif

return ( oBrw:oTreeItem:nLevel == nLevels )
*/

//----------------------------------------------------------------------------//

static function AdoSkip( oRs, n )

   LOCAL nRec

   if oRs:RecordCount() == 0
      return 0
   endif

   nRec := oRs:AbsolutePosition
   If( oRs:Eof, oRs:MoveLast(), If( oRs:Bof, oRs:MoveFirst(),) )
   oRs:Move( n )
   If( oRs:Eof, oRs:MoveLast(), If( oRs:Bof, oRs:MoveFirst(),) )

return oRs:AbsolutePosition - nRec

//----------------------------------------------------------------------------//

METHOD ArrayIncrSeek( cSeek, nGoTo ) CLASS TXBrowse

   local nAt, nBrwCol, nSortCol, nRow, uVal
   local lExact

   if ::lIncrFilter
      return ::ArrayIncrFilter( cSeek, @nGoTo )
   endif

   if ( nBrwCol := AScan( ::aCols, { |o| !Empty( o:cOrder ) } ) ) > 0
      if ! Empty( nSortCol := ::aCols[ nBrwCol ]:cSortOrder ) .and. ValTyPe( nSortCol ) == 'N'
         if ! ::aCols[ nBrwCol ]:lCaseSensitive
            cSeek    := Upper( cSeek )
         endif
         for nRow := 1 to ::nLen
            uVal  := ::ArrCell( nRow, nSortCol )
            if ValType( uVal ) $ 'CDLN'
               uVal     := cValToChar( uVal )
               if ! ::aCols[ nBrwCol ]:lCaseSensitive
                  uVal  := Upper( uVal )
               endif
               if ::lSeekWild
                  if hb_WildMatch( '*' + cSeek, uVal )
                     nAt   := nRow
                  endif
               else
                  lExact := Set( _SET_EXACT, .f. )
                  if uVal = cSeek
                     nAt   := nRow
                  endif
                  Set( _SET_EXACT, lExact )
               endif
               if ! Empty( nAt )
                  ::nArrayAt  := nAt
                  return .t.
               endif
            endif
         next nRow
      endif
   endif

return .f.

//----------------------------------------------------------------------------//

METHOD ArrayIncrFilter( cSeek, nGoTo ) CLASS TXBrowse

   local lFound   := .f.
   local nLen, x, n, nSave, cVal, lMatch := .f.
   local oCol
   local nMatches := 0

   if !ISUTF8( cSeek )
      cSeek    := Upper( cSeek )
      if cSeek == Upper( ::cSeek )
         return .t.
      endif
   endif
   if cSeek == ''
      ::bKeyCount    := { || Len( ::aArrayData ) }
       AEval( ::aCols, { |o| If( Empty( o:cOrder ), nil, oCol := o ) } )
       oCol:cOrder := If( oCol:cOrder == 'A', 'D', 'A' )
       ::KeyCount()
       oCol:SetOrder()
       nGoTo   := ::nArrayAt
      return .t.
   endif

   DEFAULT ::cFilterFld   := ::SelectedCol():cHeader
   oCol     := ::oCol( ::cFilterFld )
   nLen     := If( Len( cSeek ) >= Len( ::cSeek ), ::nLen, Len( ::aArrayData ) )
   if ::lSeekWild
      cSeek    := "*" + cSeek + "*"
   endif
   nSave       := ::nArrayAt
//   cVal     := Upper( Eval( oCol:bStrData, nil, oCol ) )
   cVal        := Upper( cValToChar( oCol:StrData ) )

   lMatch      := If( Empty( ::bFilterExp ), ;
                     If( ::lSeekWild, WildMatch( cSeek, cVal ), cVal = cSeek ), ;
                     Eval( ::bFilterExp, cSeek, ::aRow, Self ) )

   for n := 1 to nLen
      ::nArrayAt     := n
      //cVal     := Upper( Eval( oCol:bStrData, nil, oCol ) )
      cVal     := Upper( cValToChar( oCol:StrData ) )

      if If( Empty( ::bFilterExp ) , If( ::lSeekWild, WildMatch( cSeek, cVal ), cVal = cSeek ), ;
             Eval( ::bFilterExp, cSeek, ::aArrayData[ n ], Self ) )
         nMatches++
         if n > nMatches
            x                          := ::aArrayData[ nMatches ]
            ::aArrayData[ nMatches ]   := ::aArrayData[ n ]
            ::aArrayData[ n ]          := x
            if lMatch .and. n == nSave
               // current row moved to nMatches
               nSave    := nMatches
            endif
         endif
      endif
   next
   if nMatches > 0
      lFound         := .t.
      ::nArrayAt     := If( lMatch, nSave, 1 )
      ::bKeyCount    := { || nMatches }
      if nLen > ::nLen
         oCol        := nil
         AEval( ::aCols, { |o| If( Empty( o:cOrder ), nil, oCol := o ) } )
         oCol:cOrder := If( oCol:cOrder == 'A', 'D', 'A' )
         ::KeyCount()
         oCol:SetOrder()
      endif
      if lMatch
         nGoTo       := ::nArrayAt
      endif
   else
      ::nArrayAt  := nSave
   endif

return lFound

//----------------------------------------------------------------------------//

METHOD SetChecks( aBmp, lEdit, aPrompt ) CLASS TXBrowse

   AEval( ::aCols, { |o| If( o:cDataType == 'L', o:SetCheck( aBmp, lEdit, aPrompt ), nil ) } )

return nil

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TXBrowse

   if nMsg == WM_MOUSELEAVE
      return ::MouseLeave( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
   endif

return ::Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD HandleGesture( nGesture, nLParam ) CLASS TXBrowse

   local aInfo, uRet

   if Empty( ::bDragBegin )
      if nGesture == GID_PAN
         aInfo    := GestureInfo( nLParam )
         if aInfo[ 1 ] == GID_PAN
            uRet  := ::GesturePan( aInfo )
            if ValType( uRet ) == 'N' .and. uRet == 0
               return 0
            endif
         endif
      endif
   endif

return ::Super:HandleGesture( nGesture, nLParam )

//----------------------------------------------------------------------------//

METHOD GesturePan( aPanInfo ) CLASS TXBrowse

   static nPrevRowPix   := 0
   static nPrevColPix   := 0

   local uRet     := nil
   local nRowPix  := aPanInfo[ 3 ]
   local nColPix  := aPanInfo[ 4 ]
   local nScrollPix, nScrollRows, nSkipped

   if aPanInfo[ 2 ] == GF_BEGIN
      nPrevRowPix := nRowPix
      nPrevColPix := nColPix
   else
      // Row Scroll
      if nRowPix > nPrevRowPix
         nScrollPix     := nRowPix - nPrevRowPix
         nScrollRows    := Min( Int( nScrollPix / ::nRowHeight ), ::KeyNo - ::nRowSel )
         if nScrollRows > 0
            nSkipped    := -::Skip( -nScrollRows )
            //::nRowSel      += nSkipped
            ::Refresh()
            nPrevRowPix    := nRowPix
            uRet           := 0
         endif
      else
         nScrollPix     := nPrevRowPix - nRowPix
         nScrollRows    := Min( Int( nScrollPix / ::nRowHeight ), ::nLen - ::nRowSel - ::KeyNo )
         if nScrollRows > 0
            nSkipped    := ::Skip( nScrollRows )
            //::nRowSel      -= nSkipped
            ::Refresh()
            nPrevRowPix    := nRowPix
            uRet           := 0
         endif

      endif
      // Col Scroll
/*
      if nColPix > nPrevColPix
         if ::nColOffSet > 1
            if ( nColPix - nPrevColPix ) - ::aCols[ ::nColOffset ]:nWidth
               ::nColOffSet--
               ::GetDisplayCols()
               ::Refresh()
               ::nPrevColPix  := nColPix
            endif
         endif
      endif
*/
   endif

   uRet := 0

return uRet

//----------------------------------------------------------------------------//

/*
static function SeekOnArray( Self, aData, cSeek )

   local nAt, nBrwCol, nSortCol, nRow, uVal
   local lExact

   if ( nBrwCol := AScan( ::aCols, { |o| !Empty( o:cOrder ) } ) ) > 0
      if ! Empty( nSortCol := ::aCols[ nBrwCol ]:cSortOrder ) .and. ValTyPe( nSortCol ) == 'N'
         if ! ::aCols[ nBrwCol ]:lCaseSensitive
            cSeek    := Upper( cSeek )
         endif
         for nRow := 1 to ::nLen
            uVal  := ::ArrCell( nRow, nSortCol )
            if ValType( uVal ) $ 'CDLN'
               uVal     := cValToChar( uVal )
               if ! ::aCols[ nBrwCol ]:lCaseSensitive
                  uVal  := Upper( uVal )
               endif
               if ::lSeekWild
                  if hb_WildMatch( '*' + cSeek, uVal )
                     nAt   := nRow
                  endif
               else
                  lExact := Set( _SET_EXACT, .f. )
                  if uVal = cSeek
                     nAt   := nRow
                  endif
                  Set( _SET_EXACT, lExact )
               endif
               if ! Empty( nAt )
                  ::nArrayAt  := nAt
                  return .t.
               endif
            endif
         next nRow
      endif
   endif

return .f.

//----------------------------------------------------------------------------//
*/

/*
static function GenMenuBlock( aCols, nFor )

   local oCol := aCols[ nFor ]

return {|| iif( oCol:lHide, oCol:Show(), oCol:Hide() ) }
*/

//----------------------------------------------------------------------------//

static function MakeBlock( oCol, uSpec )

   local bRet

   if ValType( uSpec ) == 'C' .and. ! Empty( uSpec )
      TRY
         bRet  := &( "{ |x,o| " + uSpec + " }" )
         Eval( bRet, nil, oCol )
      CATCH
         bRet  := nil
      END
   endif
   if bRet == nil
      bRet     := { || uSpec }
   endif

return bRet

//----------------------------------------------------------------------------//

static function SetColFromRDD( oCol, uData )

   local cFldType, cFldName, nFldPos
   local a,c

   oCol:cHeader      := "Col-" + LTrim( Str( oCol:nCreationOrder ) )
   oCol:cExpr        := cValToChar( uData )

   SWITCH ValType( uData )
   CASE 'A'
      oCol:aChartCols   := uData
      oCol:cHeader      := "CHART"
      oCol:cExpr        := FW_ArrayAsList( uData )
      return oCol
      EXIT
   CASE 'B'
      oCol:bEditValue   := uData
      EXIT
   CASE 'N'
      if ! Empty( cFldName := FieldName( uData ) )
         nFldPos        := uData
         oCol:cExpr     := cFldName // FWH 17.01
      endif
      EXIT
   CASE 'C'
      if At( "FIELD->", uData ) == 1 .or. At( Alias() + "->", uData ) == 1
         uData          := AFTERATNUM( "->", uData, 1 )
         oCol:cExpr     := uData
      endif
      if ( nFldPos := FieldPos( uData ) ) > 0
         cFldName       := uData
      endif
      EXIT
   END

   if Empty( oCol:bEditValue )
      if Empty( nFldPos ) .or. Empty( cFldName )
/*
         oCol:bEditValue   := &( "{ |x,oCol| " + cValToChar( uData ) + " }" )
         TRY
            Eval( oCol:bEditValue )
         CATCH
            oCol:bEditValue   := { || uData }
         END
*/
         oCol:bEditValue   := MakeBlock( oCol, uData )
         oCol:cDataType    := ValType( Eval( oCol:bEditValue , nil, oCol ) )
         if oCol:cDataType == 'N'
            oCol:cEditPicture := NumPict( 12, 2 )
         endif
         if Empty( c := FieldInExpr( oCol:cExpr ) )
            oCol:cHeader   := oCol:cExpr
         else
            oCol:cHeader   := c
         endif
      else
         // regular field in Alias()
         cFldType             := FieldType( nFldPos )
         WITH OBJECT oCol
            //
            :cHeader          := cFldName
            :bEditValue       := FIELDBLOCK( cFldName )
            :nDataLen         := FieldLen( nFldPos )
            :nDataDec         := FieldDec( nFldPos )
            //
            if Len( cFldType ) == 1
               :cDataType     := cFldType
            else
               for each a in { ;
                  { 'M', { "CHAR", "VARBIN", "MEMO", "BLOB", "RAW" } }, ;
                  { '@', { "TIMESTAMP" } }, ;
                  { '=', { "MODITIME"  } }, ;
                  { 'T', { "TIME" } }, ;
                  { '^', { "ROWVER" } }, ;
                  { '+', { "AUTOINC" } }, ;
                  { 'B', { "DOUBLE" } }, ;
                  { 'Y', { "CURR" } }, ;
                  { 'Z', { "CURD" } }, ;
                  { 'P', { "IMAGE" } } }

                  for each c in a[ 2 ]
                     if c $ cFldType
                        :cDataType  := a[ 1 ]
                        exit
                     endif
                  next
                  if ! Empty( :cDataType )
                     exit
                  endif
               next
               if Empty( :cDataType )
                  :cDataType  := 'C'
               endif
            endif

            if :cDataType $ "+="
               :lReadOnly    := .t.
            endif

            do case
            case :cDataType == "CDLN"
               // no action                                                                                     c
            case :cDataType $ "MWQ"
               :cDataType     := 'M'
               :nDataLen      := 10
            case :cDataType == 'I'
               :nDataLen      := If( :nDataLen < 3, 6, 13 )
               :nDataDec      := 0
            case :cDataType $ "^+"
               :cDataType     := 'N'
               :nDataLen      := If( :cDataType == '^', 20, :nDataLen )
            case :cDataType $ "YZ"
               :cDataType     := 'N'
               :nDataDec      := 2
            case :cDataType $ "T@="
               :cDataType     := 'T'
               :cEditPicture  := "@T"
            otherwise
               :cDataType     := ValType( FieldGet( nFldPos ) )
            endcase
         END

      endif
   endif

   if DBINFO( DBI_ISREADONLY ) == .t. .or. oCol:lReadOnly
      oCol:bOnPostEdit  := { || nil }
   else
      oCol:bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE .and. !eq( o:Value, x, .t., .t. ) .and. o:oBrw:Lock(),  ;
                                     o:Value := x, nil ) }
   endif

return oCol

//----------------------------------------------------------------------------//

static function AddOdbfCol( oBrw, cCol, aStruct )

   local oCol := oBrw:AddCol()
   local n

   if ValType( cCol ) == 'C'
      oCol:cHeader         := cCol
      oCol:bEditValue      := { |x| If( x != nil, oSend( oBrw:oDbf, "_" + cCol, x ), ), OSend( oBrw:oDbf, cCol ) }
      oCol:bOnPostEdit     := { |o,x,n| If( n != VK_ESCAPE, o:Value := x, ) }

      if aStruct != nil
         if ( n := AScan( aStruct, { |a| Upper( Trim( a[ 1 ] ) ) == Upper( Trim( cCol ) ) } ) ) > 0
            oCol:cDataType    := aStruct[ n ][ 2 ]
            oCol:nDataLen     := aStruct[ n ][ 3 ]
            oCol:nDataDec     := aStruct[ n ][ 4 ]
         endif
      endif
   elseif ValType( cCol ) == 'A'
      oCol:aChartCols      := cCol
      oCol:cHeader         := "CHART"
   elseif ValType( cCol ) == 'B'
      oCol:bEditValue      := cCol
      oCol:bOnPostEdit     := { |o,x,n| If( n != VK_ESCAPE, o:Value := x, ) }
   endif

return oCol

//----------------------------------------------------------------------------//

static function SetExcelLanguage( oExcel )

   if nxlLangID == nil
      nxlLangID   := ExcelLangID()
      cxlTrue     := ExcelTranslate( "TRUE" )
      cxlFalse    := ExcelTranslate( "FALSE" )
      lxlEnglish  := ( ExcelLang() == 'en' )
   endif

return nil

//----------------------------------------------------------------------------//

CLASS TXBrwColumn

   DATA oBrw,;          // Browse conteiner
        oDataFont,;     // Data font object, by default oBrw:oDataFont. It also supports a codeblock to return the font to use
        oHeaderFont,;   // Header font object, by default oBrw:oHeaderFont
        oDataFontBold,; //------------------------------------ Silvio
        oGrpFont,;      // Group Header font
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
        bLeftText,;     // Additional Left aligned text where main text is right aligned
        bLeftFooter,;   // Addition left aligned text in footer
        bEditBlock;     // codeblock to evaluate for the  "..." button.
                        // If there is a Get active the value returned by the block is stuffed on the get

   DATA bOnPostEdit     // Code-block to be evaluated after the edition of the column.
                        // It receives ...
   DATA bOnPreEdit    // codeblock to be evaluated after build get object in edit mode

   DATA bKeyDown, bKeyChar

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

   DATA aDataFont, aClrText // 2016-11-28 : Fonts & Color for multi-line

   DATA bPaintText, bPaintHeader, bPaintFooter

   DATA bToolTip        // ToolTip for CELL : Depricated. Use bCellToolTip
   DATA bCellToolTip    // ToolTip for Cell : Improve version supercedes bToolTip 2016-12-21

   DATA cHeader,;       // header string
        cExpr,;
        cGrpHdr,;       // Optional Group Header String
        cFooter,;       // footer string
        cFooterPicture,;// Picture mask used to display footer
        cOrder,;        // Used internally for autosorting (""->None, "A"->Ascending, "D"->Descending)
        cSortOrder,;    // indextag or oRs:fieldname or column number of array programmer need not code for sorting colimns
        cOrdBag, ;      // Index OrderBagName ( Optional ) Can be codeblock also.
        cDataType, ;    // internally used:  data type of eval(bEditValue)
        cEditKeys, ;    // if not nil key matching the editkeys only triggers edit in lFastEdit mode
        bFooter,   ;    // Optional codeblock to calculate the footer containt
        cToolTip

   DATA xEditPicture PROTECTED  // Picture mask to be used for Get editing and display of data
   ASSIGN cEditPicture( u ) INLINE ::xEditPicture := u
   ACCESS cEditPicture      INLINE XEval( ::xEditPicture, ::Value, Self )

   DATA nWidth,;        // Column width
        nDisplayCol,;   // Actual column display value in pixels
        nCreationOrder,;// Ordinal creation order of the columns
        nResizeCol,;    // Internal value used for column resizing
        nPos,;          // Actual column position in the browse. If columns is not visible nPos == 0
        nTotal,;        // optional total to be displayed in footer
        nFieldPos, ;    // optional storage for fieldpos in database
        nChrGrp         // 0 for any, -1 for ANSI, 1 for WIDE

   DATA nCellHeight     //READONLY
   DATA aRows           READONLY // Column objects for showing as multiple rows in the same cell

   DATA nCount          INIT 0
   DATA nTotalSq        INIT 0.0
   DATA nMinVal, nMaxVal
   DATA bSumCondition   // Maketotals aggregates if this condition is true, if codeblock is specified
                        // evaluated with uValue, oCol as parameters

   DATA nGrpHeight      INIT 0

   DATA nDataLen,;      // Optional Data length in characters
        nDataDec,;      // Optional Decimal length for Numbers
        nDataLines,;
        nMaxLen

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

   DATA nColDividerStyle, nColDividerColor, hColPen // DEFAULT all NIL
   DATA nColDividerWidth PROTECTED // not yet implemented.

   DATA nArrayCol AS NUMERIC INIT 0 // For Array Browse. Specifying Column Numer is all that is needed

   DATA nHeadBmpNo      // Numeric or CodeBlock header ordinal bitmap to use of ::aBitmaps

   DATA nGrpBmpNo, ;    // Group Header ordinal bitmap
        nFootBmpNo ;    // footer ordinal bitmap to use of ::aBitmaps
        AS NUMERIC

   DATA nAlphaLevelHeader AS NUMERIC INIT 255 // Alpha Channel Level for Header
   DATA nAlphaLevelFooter AS NUMERIC INIT 255 // Alpha Channel Level for Footer

   DATA hEditType;      // 0-> None, 1-> Get, 2-> ListBox, 3-> User block
        AS NUMERIC;     // 4-> Get+ListBox, 5-> Get+User block
        PROTECTED       // For types 4 and 5 the buttons only update the edit value
                        // with the array aEditListBound on case 4 and with the value
                        // returned by the codeblock on case 5.
                        // It must be accesed through ::nEditType

   DATA lAllowSizing,;  // If .t. Column visual resizing is allowed
        lEditBorder,;   // If .t. Edit Get has border
        lHide,;         // If .t. the column is not visible
        lOnPostEdit,;   // .t. when OnPostEdit validating
        lBmpStretch ;   // If .t. and bStrData == nil, bitmap in sretched to fill the cell
        AS LOGICAL

   DATA aImgRect
   DATA nBmpWidth, nClrBmpBack
   DATA lCaseSensitive  AS LOGICAL INIT .f. // Used for array sort only
   DATA cnLocaleID      // Used for Unicode UTF-8 strings fo ArraySort only
   DATA lBmpTransparent //AS LOGICAL INIT .f.  // transparent bitmaps on brushed backgrounds ( default in adjust method )
   DATA lBtnTransparent AS LOGICAL INIT .f.  // transparent button on nEditType > 3
   DATA lAutoSave       AS LOGICAL INIT .f.
   DATA lColTransparent
   DATA lDisplayZeros // init nil
   DATA lOemAnsi
   DATA lRTF

// PROGBAR
   DATA lProgBar AS LOGICAL INIT .f.
   DATA bClrProg INIT { || { RGB(200,200,255), CLR_YELLOW } }
   DATA nProgTot INIT 1  // can be codeblock also
   DATA aProgBarRect

// CHARTS
   DATA aChartCols
   DATA nChartMaxVal
   DATA aChartColors
   DATA cChartType      // "LINE" or "BAR"
   //
   DATA lTotal AS LOGICAL INIT .F. // used by report and toexcel methods to include totals for the column
   DATA hFooterType PROTECTED
   DATA hChecked AS LOGICAL INIT .F.   // internal use only

   DATA Cargo           // For your own use

   DATA lMergeVert INIT .f.
   DATA bMergeValue     // If specified result is used to work meged rows
   DATA aMerge

   DATA nHeaderType     // Silvio

   DATA bAlphaLevel   // Used for set Alpha Channel Level
   DATA hAlphaLevel   // Data for set Alpha Channel Level

   DATA lWillShowABtn AS LOGICAL INIT .F. // Will show a edit button so data remains properly positioned
   DATA nBtnWidth, cBtnCaption, bClrBtn, cBtnToolTip
   DATA bCreateBtn

   DATA lReadOnly    AS LOGICAL INIT .f.
   DATA lRunBtnAction
   DATA lFullHeight  AS LOGICAL INIT .f.

// ACCESS METHODS
   ACCESS DataFont   INLINE XEval( IfNil( ::oDataFont,   ::oBrw:oFont ), Self )
   ACCESS HeaderFont INLINE XEval( IfNil( ::oHeaderFont, ::oBrw:oFont ), Self )
   ACCESS FooterFont INLINE XEval( IfNil( ::oFooterFont, ::oBrw:oFont ), Self )
   ACCESS EditFont   INLINE XEval( IfNil( ::oEditFont, ::oDataFont, ::oBrw:oFont ), Self )
   METHOD GrpFont    INLINE XEval( IfNil( ::oGrpFont, ::HeaderFont ), Self )
   ACCESS StrData    INLINE XEval( ::bStrData, nil, Self )

   DATA oBarGet, uBarGetVal, bBarGetValid, cBarGetPic, bBarGetChange, bBarGetAction, cBarGetBmp, aBarGetList
   DATA lBarGetOnKey    INIT .f.  // If .t., barget is activated when key is pressed

   DATA hCargo PROTECTED

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

   METHOD nFooterType   SETGET

// Adds a new bitmap to the ::aBitmaps array
   METHOD AddBitmap(    uBmp, aResize )     INLINE fnAddBitmap( Self, uBmp, aResize )
   METHOD AddBmpFile(   cBmpFile, nBmpNo )  INLINE ( ( nbmpNo := fnAddBitmap( Self, cBmpFile ) ) > 0 )
   METHOD AddResource(  cnResource, nBmpNo ) INLINE ( ( nbmpNo := fnAddBitmap( Self, cnResource ) ) > 0 )
   METHOD AddBmpHandle( hBmp, nBmpNo )      INLINE ( ( nbmpNo := fnAddBitmap( Self, hBmp) ) > 0 )
   METHOD aBitmap( n ) INLINE ( n := IfNil( n, 0 ), ;
                                     If( n > 0, If( n <= Len( ::aBitmaps ), ::aBitmaps[ n ], ::oBrw:aBitmap( n ) ), ;
                                     If( n < 0, ::oBrw:aBitmap( -n ), nil ) ) )

//   METHOD ChangeBitmap( ) // ButtonGet

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
   METHOD AutoFit( nRowsOrlVisible, lDataOnly ) INLINE ::oBrw:AutoFit( { Self }, nRowsOrlVisible, lDataOnly )

   METHOD HeaderHeight()
   METHOD HeaderWidth()
   METHOD FooterHeight()
   METHOD FooterWidth()
   METHOD DataHeight()
   METHOD CalcBmpWidth()
   METHOD DataWidth( lActual )
   METHOD DataTextWidth()
   METHOD nWidthChr() SETGET

   METHOD PaintBmpAndText( aRect, cText, nStrAlign, bLeftText, oFont, nTxtColor, ;
                        nBmpNo, nBmpAlign, lBmpTransparent, nAlpha, lBmpStretch, cOrder, hDC )
   METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC, nGrpWidth )
   METHOD DataCol()
   METHOD PaintData( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow )
   METHOD PaintCellBack( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow )
   METHOD PaintCell( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow )
   METHOD PaintCellBtn( hDC, oRect )
   METHOD PaintCellImage( cImageData, oRect )
   METHOD PaintCellText( hDC, cData, aRect, aColors, lHighLite, nHeight, nFontHeight, oFont )
   METHOD EraseData( nRow, nCol, nHeight, hBrush, lFixHeight )
   METHOD Box( nRow, nCol, nHeight, lDotted)
   METHOD PaintFooter( nRow, nCol, nHeight, lInvert )
   METHOD RefreshFooter()
   METHOD footerStr()      // used internally
   METHOD IsVisible( lComplete ) INLINE ( ! ::lHide .and. ::oBrw:IsDisplayPosVisible( ::nPos, lComplete ) )

   METHOD HeaderLButtonDown( nRow, nCol, nFlags, lTouch )
   METHOD HeaderLButtonUp( nRow, nCol, nFlags )
   METHOD FooterLButtonDown( nRow, nCol, nFlags, lTouch )
   METHOD FooterLButtonUp( nRow, nCol, nFlags )
   METHOD MouseMove( nRow, nCol, nFlags )
   METHOD ResizeBeg( nRow, nCol, nFlags )
   METHOD ResizeEnd( nRow, nCol, nFlags )

   METHOD CreateButtons()
   METHOD ShowBtnList()
   METHOD RunBtnAction()
   METHOD CreateBarGet()
   METHOD ShowSeek( cSeek )
   METHOD CheckBarGet( lShow )
   METHOD PostEdit()

   METHOD SetCheck( aBmps, uEdit, aPrompts )
   METHOD SetLogical( uTrue, uFalse )  // uTrue and uFalse are optional
   METHOD CheckToggle()
   METHOD SetProgBar( nProgTotal, nWidth, bClrProg )
   METHOD SetAlign( nAlign )
   METHOD cAlign( nAlign ) INLINE If( lAnd( nAlign, AL_RIGHT ), 'R', If( lAnd( nAlign, AL_CENTER ), '', 'L' ) ) + ;
                                  If( lAnd( nAlign, AL_TOP   ), 'T', If( lAnd( nAlign, AL_BOTTOM ), 'B', '' ) )

   METHOD SetOrder()                      // used internally
   METHOD SortArrayData()                 // used internally
   METHOD ClpText
   METHOD Paste( cText )
   METHOD ToExcel( oSheet, nRow, nCol )
   METHOD isEditKey( nKey )               // used internally
   METHOD Value( uVal ) SETGET
   METHOD BlankValue()
   METHOD SumValue()  // Value for aggregation. Used internally
   METHOD VarGet() INLINE ::Value
   METHOD VarPut( uVal ) INLINE If( ::bOnPostEdit == nil, nil, ( ::PostEdit( uVal,, .t. ), uVal ) )
   ACCESS Var INLINE ::Value
   ASSIGN var( x ) INLINE ::VarPut( x )

   ACCESS lEditable INLINE ( ! ::oBrw:lReadOnly .and. ! ::lReadOnly .and. ;
                             ::nEditType > 0 .and. ::bOnPostEdit != nil .and. ;
                             ( ::bEditWhen == nil .or. Eval( ::bEditWhen, Self ) ) )

   METHOD IsMemo() INLINE  ( IfNil( ::cDataType, 'C' ) $ 'MPm' .or. ;
                     ( ValType( ::Value ) == 'C' .and. ( Len( ::Value ) > FWAdoMemoSizeThreshold() .or. ;
                       CRLF $ ::Value .or. IsBinaryData( ::Value ) ) ) )
   METHOD SetColsAsRows( aCols ) // Show multiple columns as rows in the cell of this column

   METHOD WorkMergeData()
   METHOD HasBorder()
   METHOD MergeArea()
   METHOD SumOfCols( aCols, nType )

   METHOD ChartArrayVals( lReport )
   METHOD DrawChart()
   METHOD DrawChartInRect()

   METHOD SameColAs( u ) PROTECTED
   OPERATOR "==" ARG u INLINE ::SameColAs( u )
   OPERATOR "<>" ARG u INLINE ! ::SameColAs( u )

   METHOD AddVar( uKey, uVal ) INLINE ::hCargo[ uKey ] := uVal

   ERROR HANDLER OnError()

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

   ::hCargo          := {=>}
   HB_HSetCaseMatch( ::hCargo, .f. )
   HB_HSetAutoAdd(   ::hCargo, .t. )

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

   if ::hColPen != nil
      DeleteObject( ::hColPen )
      ::hColPen   := nil
   endif
/*
   for nFor := 1 to Len( ::aBitmaps )
      PalBmpFree( ::aBitmaps[ nFor, BITMAP_HANDLE ], ::aBitmaps[ nFor, BITMAP_PALETTE ] )
   next
*/
   for nFor := 1 to Len( ::aBitmaps )
      if ! Empty( ::aBitmaps[ nFor, BITMAP_HANDLE ] )
         PalBmpFree( ::aBitmaps[ nFor, BITMAP_HANDLE ], ::aBitmaps[ nFor, BITMAP_PALETTE ] )
         ::aBitmaps[ nFor, BITMAP_HANDLE ] := 0
      endif
   next
   ::aBitmaps := {}

return nil

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TXBrwColumn

   local nWid, tmp, aToken, cOrder, cType

   DEFAULT ::cOrder   := ""

   if ! Empty( ::aChartCols )
      DEFAULT ::cHeader       := "CHART"
      DEFAULT ::nHeadStrAlign := AL_CENTER
      ::lReadOnly             := .t.
      ::bEditValue            := { || "" }

   endif

   if ::cEditPicture == nil .and. ::cDataType == 'T'
      ::cEditPicture := '@T'
   endif

   if ! Empty( ::aEditListTxt ) .and. Empty( ::aEditListBound ) .and. ;
      ValType( ::aEditListTxt[ 1 ] ) == 'A'
      // If multi-dim array 1st col as ListBound and 2nd col as ListTxt
      //
      ::aEditListBound     := ArrTranspose( ::aEditListTxt )
      ::aEditListTxt       := ::aEditListBound[ 2 ]
      ::aEditListBound     := ::aEditListBound[ 1 ]
      ::nDataStrAlign      := AL_LEFT
   endif

   if ValType( ::oBrw:aArrayData ) == 'A'
      DEFAULT ::cEditPicture := { |u| If( ValType( u ) == 'N', ;
               NumPict( ::nWidthChr, Len( AfterAtNum( '.', cValToChar( u ) ) ) ), nil ) }
      if ::bEditValue == nil
         if ::nArrayCol > 0
            ::bEditValue   := ;
               { |x| If( x == nil, ::oBrw:ArrCell( ::oBrw:nArrayAt, ::nArrayCol ), ;
                                   ::oBrw:ArrCellSet( ::oBrw:nArrayAt, ::nArrayCol, x ) ) }
            if ValType( ::bBmpData) == 'N'
               tmp                     := ::bBmpData
               ::bBmpData              := { || ::oBrw:aRow[ tmp ] }
            elseif ::bStrData == nil .and. ! ::hChecked
               if /*::nEditType == EDIT_LISTBOX .and.*/ ! Empty( ::aEditListTxt ) .and. ! Empty( ::aEditListBound )
                  ::bStrData  := { || XbrLbxLookUp( ::Value, ::aEditListBound, ::aEditListTxt, ::nEditType == EDIT_LISTBOX ) }
               else
                  ::bStrData     := ;
                     { || ::oBrw:ArrCell( ::oBrw:nArrayAt, ::nArrayCol, ::cEditPicture, ;
                            ::lDisplayZeros ) }
               endif
            endif
         endif
      endif
/*
   elseif ValType( ::oBrw:aArrayData ) == 'H'
         DEFAULT ::nWidth        := 100
*/
   endif

   if ::bEditValue != nil

      if Empty( ::cDataType ) .or. ::cDataType == 'U' //$ 'CU'
         ::cDataType := ValType( ::Value )
         if ::cDataType == 'P'  // pointer not picture
            ::cDataType := 'N'
         endif
      endif

      if ::cEditPicture == nil .and. ::cDataType == 'N' .and. ;
         ::nDataLen != nil .and. ::oBrw:nDataType != DATATYPE_ARRAY
         ::cEditPicture := NumPict( ::nDataLen, ::nDataDec, .t. )
      endif

#ifdef __XHARBOUR__
      if ::cDataType == 'T'
         DEFAULT ::cEditPicture  := '@D'
      endif
#endif
      if ::cDataType $ 'DT'
         DEFAULT ::nDataStrAlign   := AL_RIGHT, ;
                 ::nHeadStrAlign   := AL_RIGHT
      endif

      if ::cDataType $ "N+,I:+"
         DEFAULT ::nDataStrAlign := AL_RIGHT, ;
                 ::nHeadStrAlign := AL_RIGHT, ;
                 ::nFootStrAlign := AL_RIGHT
      else
         ::lTotal := .F.
      endif

      if ::bStrData == nil
         if ! Empty( ::aEditListTxt ) .and. ! Empty( ::aEditListBound )
            ::bStrData  := { || XbrLbxLookUp( ::Value, ::aEditListBound, ::aEditListTxt, ::nEditType == EDIT_LISTBOX ) }
         else
            ::bStrData  := { || cValToStr( ::Value, ::cEditPicture,, ;
                  IfNil( ::lDisplayZeros, ::oBrw:lDisplayZeros ) ) }
         endif
      elseif ValType( ::bStrData ) != 'B'
         ::bStrData  := nil
      endif

      DEFAULT ::bOnPostEdit := { |o,x,n| If( n != VK_ESCAPE .and. ::oBrw:Lock(), ::Value := x, nil ) }

      if ::cSortOrder != nil
         if ValType( ::cSortOrder ) != 'B'
            if ( ::oBrw:nDataType == DATATYPE_RDD )
               if Empty( ::cOrdBag ) .or. ( ValType( ::cOrdBag ) == 'C' .and. ;
                   (::oBrw:cAlias)->( OrdNumber( ::cSortOrder, ::cOrdBag ) ) == 0 )
                  ::cOrdBag    := (::oBrw:cAlias)->( OrdBagName( ::cSortOrder ) )
               endif
               if EQ( (::oBrw:cAlias)->( OrdSetFocus() ), ::cSortOrder )
                  ::cOrder       := 'A'
               endif
            elseif ( ::oBrw:nDataType == DATATYPE_ADO )
               if EQ( CharRem( "[]", ::oBrw:oRs:Sort ), CharRem( "[]", ::cSortOrder ) )
                  ::cOrder       := 'A'
               endif
            elseif ( ::oBrw:nDataType == DATATYPE_MYSQL )
               if ::oBrw:oMysql:IsKindOf( 'TDOLPHINQRY' )
                  if ! Empty( ::oBrw:oMySql:cOrder )
                     aToken := HB_ATokens( ::oBrw:oMySql:cOrder, " " )
                     IF Len( aToken ) == 1
                        AAdd( aToken, "ASC" )
                     ENDIF
                     cOrder = AllTrim( Lower( aToken[ 1 ] ) )
                     cType = aToken[ 2 ]
                     if EQ( cOrder, ::cSortOrder )
                        IF Upper( cType ) == "ASC"
                           ::cOrder = "A"
                        ELSE
                           ::cOrder = "D"
                        ENDIF
                     endif
                  endif
               else
                  if EQ( ::oBrw:oMysql:cSort, ::cSortOrder )
                     ::cOrder       := 'A'
                  endif
               endif
            elseif ( ::oBrw:nDataType == DATATYPE_ODBF )
               if __ObjHasMethod( ::oBrw:oDbf, "SETORDER" )
                  if EQ( ::oBrw:oDbf:SetOrder, ::cSortOrder )
                     ::cOrder       := 'A'
                  endif
               endif
            endif
         endif
      endif
   endif

   if ::nEditType == -1 .or. ::bStrImage != nil    // TYPE_IMAGE
      ::cDataType        := 'F'
   endif

   if ValType( tmp := ::Value ) == 'C' .and. IsBinaryData( tmp )
      if Left( MemoryBufferType( tmp ), 4 ) == "IMG."
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

   if ( ::bStrData == nil .or. Eval( ::bStrData, nil, Self ) == nil ) .and. ;
      ( ::bBmpData != nil .or. ::cDataType $ 'PF')

      DEFAULT ::nDataBmpAlign := AL_CENTER

   endif

   if ! Empty( ::hFooterType )
      DEFAULT ::nTotal := 0
   endif
   if ValType( ::nTotal ) == 'N'
      DEFAULT ::hFooterType := AGGR_SUM
   endif
/*
   DEFAULT ; // ::oDataFont   := ::oBrw:oFont,;
           ; //::oHeaderFont := ::oBrw:oFont,;
           ::oDataFontBold := ::oBrw:oFont,;  //---------------------- Silvio
           ; //::oFooterFont := ::oBrw:oFont,;
           ::oGrpFont    := ::oDataFontBold  //  ::oEditFont   := ::oBrw:oFont // Edit Font
*/

   DEFAULT ::oDataFontBold := ::oBrw:oFont

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

/*
   DEFAULT ::nWidth := Max( Max( ::HeaderWidth(),;
                                 ::FooterWidth() ),;
                            ::DataWidth() ) + COL_EXTRAWIDTH
*/

   ::CalcBmpWidth()

   if !( ValType( ::nWidth ) == 'N' .and. ::nWidth >= 0 )
      ::nWidth := Max( Max( ::HeaderWidth(),;
                            ::FooterWidth() ),;
                            ::DataWidth() ) + COL_EXTRAWIDTH
   endif

   DEFAULT ::nDataStyle := ::DefStyle( ::nDataStrAlign, ( ::oBrw:nDataLines == 1 ) ),;
           ::nHeadStyle := ::DefStyle( ::nHeadStrAlign, ( ::oBrw:nHeaderLines == 1 ) ),;
           ::nFootStyle := ::DefStyle( ::nFootStrAlign, ( ::oBrw:nFooterLines == 1 ) )

   if ! Empty( ::cGrpHdr ) .and. Empty( ::nGrpHeight )
      ::nGrpHeight   := FontHeight( ::oBrw, ::GrpFont )
   endif

   if ::nColDividerStyle != nil
      ::hColPen   := CreateLinePen( ::oBrw, ::nColDividerStyle, PS_SOLID, ::nColDividerWidth, ::nColDividerColor )
   endif

   ::CreateButtons()
   ::CreateBarGet()
   if ::lMergeVert
      ::oBrw:lMergeVert := .t.
      ::WorkMergeData()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Value( uNew ) CLASS TXBrwColumn

   local uVal

   if ! ::oBrw:lReadOnly .and. ! ::lReadOnly .and. ;
      PCount() > 0 .and. ::bEditValue != nil

      if HB_IsString( uNew ) .and. IfNil( ::lOemAnsi, ::oBrw:lOemAnsi )
         uNew     := AnsiToOem( uNew )
      endif
      TRY
         ( ::oBrw:cAlias )->( Eval( ::bEditValue, uNew, Self ) )
         ::oBrw:lEdited    := .t.
      CATCH
      END

   endif

   if ::bEditValue == nil .and. ::nArrayCol > 0
      // this is the case for arrays before oCol:Adjust
      uVal     := ::oBrw:ArrCell( ::oBrw:nArrayAt, ::nArrayCol )
   elseif ::bEditValue != nil
      TRY
         uVal  := ( ::oBrw:cAlias )->( Eval( ::bEditValue, nil, Self ) )
      CATCH
         uVal  := ::BlankValue()
      END
   elseif ::bStrData != nil
      TRY
         uVal  := ( ::oBrw:cAlias )->( Eval( ::bStrData, nil, Self ) )
      CATCH
         uVal  := ''
      END
   endif

   if HB_IsString( uVal ) .and. IfNil( ::lOemAnsi, ::oBrw:lOemAnsi )
      uVal  := OemToAnsi( uVal )
   endif

return uVal

//----------------------------------------------------------------------------//

METHOD BlankValue() CLASS TXBrwColumn

   local uVal  := ''

   if ::cDataType == 'N'
      if IfNil( ::nDataDec, 0 ) > 0
         uVal  := Val( "0." + Replicate( '0', ::nDataDec ) )
      else
         uVal  := 0
      endif
   elseif ::cDataType == 'D'
      uVal     := CToD( '' )
   elseif ::cDataType == 'T'
      uVal     := HB_CTOT( '' )
   elseif ::cDataType == 'L'
      uVal     := .f.
   else
      uVal     := Space( If( Empty( ::nDataLen ), ::nWidthChr, ::nDataLen ) )
   endif

return uVal

//------------------------------------------------------------------//

METHOD SumValue() CLASS TXBrwColumn

   local uValue   := ::Value
   local lRet

   if ::bSumCondition != nil
      lRet  := Eval( ::bSumCondition, @uValue, Self )
      if HB_ISLOGICAL( lRet ) .and. lRet == .f.
         uValue   := nil
      endif
   endif
   if ValType( uValue ) == 'C'
      uValue   := Upper( uValue )
   endif

return uValue

//----------------------------------------------------------------------------//

METHOD SameColAs( u ) CLASS TXBrwColumn

   local lRet  := .f.
   local cParType := ValType( u )
   local cHeader, cHead

   if cParType == 'O'
      lRet  :=  ( u:IsKindOf( 'TXBRWCOLUMN' ) .and. ::nCreationOrder == u:nCreationOrder )
   elseif cParType == 'N'
      lRet  :=  ( ::nCreationOrder == u )
   elseif cParType == 'C' .and. ValType( ::cHeader ) == 'C' .and. ;
      ! Empty( ::cHeader ) .and. ! Empty( u )

      u        := Upper( u )
      cHeader  := Upper( ::cHeader )
      cHead    := CharRem( Chr(9) + Chr(10) + Chr(13) + Chr(32), cHeader )
      if cHeader == u .or. cHead == u
         lRet  := .t.
      elseif ! Empty( ::cGrpHdr )
         if Upper( AllTrim( ::cGrpHdr ) ) + "_" + cHeader == u
            lRet  := .t.
         elseif Upper( AllTrim( ::cGrpHdr ) ) + "_" + cHead == u
            lRet  := .t.
         endif
      endif
   endif

return lRet

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

METHOD SetLogical( uTrue, uFalse ) CLASS TXBrwColumn

   local lSet     := .f.
   local b

   if ! Empty( ::bEditValue )
      b     := ::bEditValue
      if ::cDataType == 'N'
         ::bEditValue   := { |x| If( x == nil, ! Empty( Eval( b ) ), Eval( b, If( x, 1, 0 ) ) ) }
         ::cDataType    := 'L'
         lSet     := .t.
      elseif ::cDataType == 'C'
         DEFAULT uTrue := 'Y', uFalse := 'N'
         uTrue    := Upper( Left( uTrue, 1 ) )
         uFalse   := Upper( Left( uFalse, 1 ) )
         ::bEditValue   := { |x| If( x == nil, !( Upper( Left( IfNil( Eval( b ), uFalse ), 1 ) ) == uFalse ), ;
                                 Eval( b, If( x, uTrue, uFalse ) ) ) }
         ::cDataType    := 'L'
         lSet     := .t.
      endif
   endif

return lSet

//----------------------------------------------------------------------------//

METHOD SetCheck( aBmps, uEdit, aPrompts ) CLASS TXBrwColumn

   local nBmpOn, nBmpOff := 0, nBmpNull := 0
   local hBmp, LogiVal := .f.

   if ::hchecked
      // SetCheck executed already before
      return nil
   endif

   DEFAULT aBmps := {}
   if Len( aBmps ) >= 1
      nBmpOn   := ::AddBitmap( aBmps[ 1 ] )
      if Len( aBmps ) >= 2
         nBmpOff  := ::AddBitmap( aBmps[ 2 ] )
         if Len( aBmps ) >= 3
            nBmpNull := ::AddBitmap( aBmps[ 3 ] )
         endif
      else
         nBmpOff  := ::AddBitmap( hBmp := FWBmpOff() )
      endif
   else
      nBmpOn   := ::AddBitmap( hBmp := FWBmpOn() )
      nBmpOff  := ::AddBitmap( hBmp := FWBmpOff() )
   endif

   ::bBmpData  := { | u | If( ValType( u := ::Value ) == 'L', If( u, nBmpOn, nBmpOff ), nBmpNull ) }
   ::bStrData  := If( ::oBrw:lAdjusted, nil, .f. )
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
      ::nDataBmpAlign   := AL_LEFT
   else
      ::nDataBmpAlign   := AL_CENTER
      ::nHeadStrAlign   := AL_CENTER
      ::nFootStrAlign   := AL_CENTER
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CheckToggle( lOverRide ) CLASS TXBrwColumn

   local uVal  := IfNil( ::Value, .f. )

   // If lOverRide is .t., the value is toggled ignoring ::nEditType
   // Otheriwse toggled only if ::nEditType == EDIT_GET
   // ::bEditWhen is ignored in both cases

   if ValType( uVal ) == 'L'
      ::PostEdit( ! uVal, nil, lOverRide )
   endif

return Self

//------------------------------------------------------------------//

METHOD SetProgBar( nProgTotal, nWidth, bClrProg ) CLASS TXBrwColumn

   ::lProgBar        := .t.
   if nProgTotal != nil
      ::nProgTot     := nProgTotal
   endif
   if ValType( bClrProg )  == 'B'
      ::bClrProg     := bClrProg
   endif
   ::aProgBarRect    := Array( 4 )

   ::nDataStrAlign := ::nHeadStrAlign := AL_CENTER

   if HB_ISNUMERIC( nWidth )
      ::aProgBarRect[ 4 ] := nWidth
      if ::nWidth == nil
         ::nWidth       := nWidth
      endif
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

METHOD HeaderHeight( lGrpHdr ) CLASS TXBrwColumn

   local nHeight := 0
   local aBitmap

   DEFAULT lGrpHdr   := .f.

   if lGrpHdr
      if ! Empty( ::cGrpHdr )
         nHeight  := ( FontHeight( ::oBrw, ::GrpFont ) + 2 ) * MLCount( ::cGrpHdr ) + 2
      endif
      if ! Empty( aBitmap := ::aBitmap( ::nGrpBmpNo ) )
         nHeight := Max( nHeight, aBitmap[ BITMAP_HEIGHT ] + 2 )
      endif
   else

      nHeight := FontHeight( ::oBrw, ::oBrw:oWnd:oFont )
      if ! Empty( ::cHeader ) //.and. ::oHeaderFont != nil
         nHeight := FontHeight( ::oBrw, ::HeaderFont ) * MLCount( ::cHeader )
         if FontEsc( ::HeaderFont ) % 1800  == 900
            nHeight := Max( nHeight, ::oBrw:GetWidth( ::cHeader, ::HeaderFont ) + 6 )
         endif
      endif

      if ! Empty( aBitmap := ::aBitmap( If( ValType( ::nHeadBmpNo ) == 'B', Eval( ::nHeadBmpNo ), ::nHeadBmpNo ) ) )
         nHeight := Max( nHeight, aBitmap[ BITMAP_HEIGHT ] + 2 )
      endif
      if Empty( ::cGrpHdr )
         ::nGrpHeight   := 0
      else
         nHeight  += ::nGrpHeight + 1
      endif

   endif

return nHeight

//----------------------------------------------------------------------------//

METHOD HeaderWidth() CLASS TXBrwColumn

   local cText, cLine
   local nWidth, nFrom, nLen, nFor, nTemp
   local aBitmap

   cText  := ::cHeader
   nWidth := 0
   nFrom  := 1

   if !Empty( cText )
      if FontEsc( ::HeaderFont ) % 1800 == 900
         nWidth   := FontHeight( ::oBrw, ::HeaderFont ) + 6
      else
          nLen  := Len( cText )
          While nFrom <= nLen
            cLine  := ExtractLine( cText, @nFrom )
            nWidth := Max( nWidth, ::oBrw:GetWidth( cLine, ::HeaderFont ) )
          enddo
      endif
   endif

   if ! Empty( aBitmap := ::aBitmap( If( ValType( ::nHeadBmpNo ) == 'B', Eval( ::nHeadBmpNo ), ::nHeadBmpNo ) ) )
      nWidth   += aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
   elseif ! Empty( ::cSortOrder )
      nWidth += ::oBrw:aSortBmp[ 1 ][ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
   endif

return Max( nWidth, 16 )

//----------------------------------------------------------------------------//

METHOD FooterHeight() CLASS TXBrwColumn

   local nHeight
   local cFooter
   local aBitmap

   nHeight := FontHeight( ::oBrw, ::oBrw:oWnd:oFont )

   cFooter := ::footerStr()

   if cFooter != nil // .and. ::oFooterFont != nil
      nHeight := FontHeight( ::oBrw, ::FooterFont )
   endif

   if ! Empty( aBitmap := ::aBitmap( ::nFootBmpNo ) )
      nHeight := Max( nHeight, aBitmap[ BITMAP_HEIGHT ] )
   endif

return nHeight

//----------------------------------------------------------------------------//

METHOD FooterWidth() CLASS TXBrwColumn

   local cText, cLeftText, cLine
   local nWidth, nFrom, nLen
   local aBitmap

   cText  := ::footerStr()
   if ! Empty( cLeftText := XEval( ::bLeftFooter, Self ) )
      cText := cLeftText + ' ' + IfNil( cText, "" )
   endif

   nWidth := 0
   nFrom  := 1
   if !Empty( cText )
       nLen  := Len( cText )
       While nFrom <= nLen
         cLine  := ExtractLine( cText, @nFrom )
         nWidth := Max( nWidth, ::oBrw:GetWidth( cLine, ::FooterFont ) )
       enddo
   endif

   if ! Empty( aBitmap := ::aBitmap( ::nFootBmpNo ) )
      nWidth := Max( nWidth, aBitmap[ BITMAP_WIDTH ] ) + BMP_EXTRAWIDTH
   endif

return Max( nWidth, 16 )

//----------------------------------------------------------------------------//

METHOD DataHeight() CLASS TXBrwColumn

   local n, h, nHeight, nBmpHeight, cData, nBmp := 0
   local aPalBmp, aBitmaps

   nHeight := FontHeight( ::oBrw, ::DataFont )

   if ::bBmpData != nil

      nBmpHeight  := 0
      aBitmaps    := If( Empty( ::aBitmaps ), ::oBrw:aBitmaps, ::aBitmaps )
      for n := 1 to Len( aBitmaps )
         if aBitmaps[ n, BITMAP_WIDTH ] > ::nBmpWidth
            h  := ::nBmpWidth * aBitmaps[ n, BITMAP_HEIGHT ] / aBitmaps[ n, BITMAP_WIDTH ]
         else
            h  := aBitmaps[ n, BITMAP_HEIGHT ]
         endif
         nBmpHeight  := Max( nBmpHeight, h )
      next
      nHeight  := Max( nHeight, nBmpHeight )

   endif

   if ::cDataType $ "PF" .and. ! ::lFullHeight
      // image
      if ValType( ::Value ) == 'C' .and. ! Empty( ::Value )
         aPalBmp  := ::oBrw:ReadImage( ::Value,, ::oBrw:lGDIP )
         if ! Empty( aPalBmp[ 1 ] )
            nHeight  := Max( nHeight, Min( Int( ScreenHeight() / 10 ), aPalBmp[ 4 ] ) )
            PalBmpFree( aPalBmp )
            aPalBmp[ 1 ] := 0
         endif
      endif
      if ::oBrw:nDataLines > 1
         nheight  := Round( nHeight / ::oBrw:nDataLines, 0 )  // dont want this height to be multiplied by datalines
      endif
   endif

   if ::nEditType == EDIT_DATE
      nHeight  := Max( 24, nHeight )
   endif

   if ::nCellHeight != nil .and. ::nCellHeight > nHeight
      nHeight     := ::nCellHeight
   endif

   ::nCellHeight  := nHeight

return nHeight

//----------------------------------------------------------------------------//

METHOD CalcBmpWidth() CLASS TXBrwColumn

   local n, w, h
   local nBmpWidth   := 0
   local aBitmaps

   if ::bBmpData != nil .or. !Empty( ::aBitmaps )
      if ::nBmpWidth == nil
         nBmpWidth   := 0
         aBitmaps    := If( Empty( ::aBitmaps ), ::oBrw:aBitmaps, ::aBitmaps )
         if Empty( h := ::oBrw:nRowHeight )
            AEval( aBitmaps, { |a| nBmpWidth := Max( nBmpWidth, Min( 48, a[ BITMAP_WIDTH ] ) ) } )
         else
            for n := 1 to Len( aBitmaps )
               if aBitmaps[ n, BITMAP_HEIGHT ] > h
                  w  := h * aBitmaps[ n, BITMAP_WIDTH ] / aBitmaps[ n, BITMAP_HEIGHT ]
               else
                  w  := aBitmaps[ n, BITMAP_WIDTH ]
               endif
               nBmpWidth   := Max( nBmpWidth, w )
            next
         endif
         ::nBmpWidth := Ceiling( nBmpWidth )
      endif
   endif

return ::nBmpWidth

//----------------------------------------------------------------------------//

METHOD DataWidth( nTxtWidth ) CLASS TXBrwColumn

   local cText, cLeftText, cLine, oFont
   local n, h, w, nWidth, nFrom, nLen, nBmp := 0
   local nBmpWidth, aPalBmp

   nWidth := 0
   nFrom  := 1

   if ! Empty( ::aChartCols )
      nWidth   := 64
   else
      if ::cDataType != nil .and. ::cDataType $ 'PF'
         // image
         if ValType( ::Value ) == 'C' .and. ! Empty( ::Value )
            aPalBmp  := ::oBrw:ReadImage( ::Value,, ::oBrw:lGDIP )
            if ! Empty( aPalBmp[ 1 ] )
               nWidth  := Min( Int( ScreenWidth() / 10 ), aPalBmp[ 3 ] )
               PalBmpFree( aPalBmp )
               aPalBmp[ 1 ] := 0
            endif
         endif
      else
/*
         oFont    := ::DataFont
         cText    := cValToChar( ::StrData )
         if FontEsc( oFont ) % 1800 == 900
            nWidth   := FontHeight( ::oBrw, oFont ) * ( Occurs( CRLF, cText ) + 1 )
         else
            if ::nDataLen != nil .and. ::bEditValue != nil
               nWidth   := Max( nWidth, ::oBrw:GetWidth( Replicate( 'B', ::nDataLen + 2 ), oFont ) )
            else
               nWidth   := CalcTextWH( ::oBrw, cText, oFont )[ 1 ]
            endif
         endif
*/

         nWidth   := IfNil( nTxtWidth, ::DataTextWidth() )

      endif
   endif

   if ::bBmpData != nil
      nBmpWidth   := ::nBmpWidth
      nWidth   += Ceiling( nBmpWidth + BMP_EXTRAWIDTH )
   endif

   if ::nEditType > 1
      nWidth += ( IfNil( ::nBtnWidth, 10 ) + 5 )
   endif

return nWidth

//----------------------------------------------------------------------------//

METHOD DataTextWidth( lCurrent ) CLASS TXBrwColumn

   local nWidth      := 0
   local lUser       := .f.
   local cText       := cValToChar( ::StrData )
   local uVal, cType, cPic
   local nDataLen, nDataDec
   local oFont       := ::DataFont
   local tmp, nLen

   DEFAULT lCurrent  := .f.

   if FontEsc( oFont ) % 1800 == 900
      return FontHeight( ::oBrw, oFont ) * ( Occurs( CRLF, cText ) + 1 )
   endif

   if lCurrent
      // Exact width required for the current value
      cText    := Trim( cText )
      if ValType( ::Value ) == 'N'
         cText := LTrim( cText )
      endif
      return CalcTextWH( ::oBrw, Trim( cText ), oFont )[ 1 ]
   endif

   if ValType( ::nWidth ) == 'C'
      // User specified a string for calcn of width
      nWidth   := CalcTextWH( ::oBrw, Trim( ::nWidth ), oFont )[ 1 ]
      ::nWidth := nil
      return nWidth
   endif

   uVal     := ::Value
   cType    := IfNil( ::cDataType, ValType( uVal ) )

   if ValType( ::nWidth ) == 'N' .and. ::nWidth < 0
      // User specified number of characters
      ::nWidth    := -::nWidth
      nDataLen    := Int( ::nWidth )
      nDataDec    := Int( ( ::nWidth - nDataLen ) * 10 )
      ::nWidth    := nil
      if cType $ "N+"
         ::cEditPicture := NUMPICT( nDataLen, nDataDec )
      endif
      lUser       := .t.
   endif

   DEFAULT nDataLen := ::nDataLen, nDataDec := IfNil( ::nDataDec, 0 )

   if !Empty( ::cEditPicture ) .and. cType $ "N+" //"CN+"
      lUser    := .t.
   endif

   if ( ! Empty( nDataLen ) .and. cType $ "CN+" ) .or. lUser
      if cType $ 'N+'
         DEFAULT ::cEditPicture := NUMPICT( nDataLen, nDataDec )
         cText    := CharOnly( "9.", StrTran( ::cEditPicture, "#", "9" ) )
         cText    := Transform( Val( cText ), ::cEditPicture )
         nWidth   := ::oBrw:GetWidth( cText, oFont )
      elseif cType == 'C'
         cText    := Replicate( If( nDataLen <= 4, 'W', 'B' ), nDataLen )
         if ! Empty( ::cEditPicture )
            cText    := cValToStr( cText, ::cEditPicture )
         endif
         nWidth   := ::oBrw:GetWidth( cText, oFont )
      endif
   endif

   if lUser
      return nWidth
   endif

   cText       := cValToChar( ::StrData )

   if Chr( 10 ) $ cText
      cText    := StrTran( cText, Chr( 13 ), Chr( 10 ) )
      cText    := CharOne( Chr( 10 ), cText )
      nLen     := 0
      AEval( HB_ATokens( cText, Chr( 10 ) ), { |c| nLen := Max( nLen, HB_UTF8Len( c ) ) } )
   else
      nLen     := HB_UTF8Len( cText )
   endif

   if ::bEditValue != nil .and. ! Empty( ::nDataLen )
      nLen        := Max( nLen,   IfNil( ::nDataLen, 0 ) )
   endif
   nWidth      := Max( nWidth, ::oBrw:GetWidth( Replicate( If( nLen <= 4, 'W', 'B' ), nLen ), oFont ) )

//   if ( ::nEditType == EDIT_LISTBOX .or. ::nEditType == EDIT_GET_LISTBOX ) .and. ! Empty( tmp := ::aEditListTxt )
   if ! Empty( tmp := ::aEditListTxt )
      if ValType( ::aEditListTxt[ 1 ] ) == 'A'
         tmp   := ArrTranspose( tmp )[ 2 ]
      endif
      nWidth   := Max( If( ::nEditType != EDIT_LISTBOX, nWidth, 0 ), CalcTextWH( ::oBrw, tmp, oFont )[ 1 ] )
      //
      return nWidth
   endif

   uVal     := ::Value
   cType    := ValType( uVal )
   cPic     := ::cEditPicture

   if ! Empty( cPic )
      do case
      case cType $ 'DT'
         nLen     := Len( cValToStr( STOD( "20000929" ), cPic ) )
         nWidth   := Max( nWidth, ::oBrw:GetWidth( Replicate( 'B', nLen ), oFont ) )
      endcase
   endif

return nWidth

//----------------------------------------------------------------------------//

METHOD nWidthChr( nChars ) CLASS TXBrwColumn

   local oFont
   local n

   oFont    := ::DataFont

   if PCount() == 0
      n        := ::oBrw:GetWidth( Replicate( 'B', 100 ), oFont )
      nChars   := If( ::nWidth == nil, 10, Int( ::nWidth * 100 /  n ) )
   elseif ValType( nChars ) $ "NC"
      if ValType( nChars ) == 'N'
         nChars   := -Abs( nChars )
      endif
      ::nWidth := nChars
      if ::oBrw:lAdjusted
         ::nWidth := ::DataWidth( ::DataTextWidth() ) + COL_EXTRAWIDTH
      endif
   endif

return nChars

//------------------------------------------------------------------//

METHOD PaintBmpAndText( aRect, cText, nStrAlign, bLeftText, oFont, nTxtColor, ;
                        nBmpNo, nBmpAlign, lBmpTransparent, nAlpha, lBmpStretch, cOrder, hDC ) CLASS TXBrwColumn

   local oCellRect, oBmpRect, oTxtRect, cLeftText, aBitmap, cAlign
   local nBmpWidth

   DEFAULT lBmpStretch  := .f.

   oCellRect          := If( ValType( aRect ) == 'O', aRect, TRect():New( aRect ) )
   oCellRect:nRight   := Min( oCellRect:nRight, If( Self == ::oBrw:oRightCol, ::oBrw:BrwWidth - 1, ::oBrw:GridWidth() - 4 ) )
   WITH OBJECT oCellRect
      :nLeft         += ( COL_EXTRAWIDTH  / 2 )
      :nTop          += ( ROW_EXTRAHEIGHT / 2 )
      :nRight        -= ( COL_EXTRAWIDTH  / 2 )
      :nBottom       -= ( ROW_EXTRAHEIGHT / 2 )
   END

   if ! Empty( cOrder ) // Need to paint Sort Bmp in Header
      aBitmap     := ::oBrw:aSortBmp[ If( ::cOrder == 'A', 1, 2 ) ]
      if hDC == nil
         ::oBrw:DrawImage( aBitmap, oCellRect:aRect, .t., 0, nil, .f., "R" )
      else
         FW_DrawImage( hDC, aBitmap, oCellRect:aRect, .t., 0, nil, .f., "R" )
      endif
      oCellRect:nRight  -= ( aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH )
   endif

   oBmpRect          := TRect():New( oCellRect:aRect )
   oTxtRect          := TRect():New( oCellRect:aRect )
   aBitmap           := If( HB_IsArray( nBmpNo ), nBmpNo, ::aBitmap( XEval( nBmpNo, Self ) ) )
   if ! Empty( aBitmap ) .and. Empty( aBitmap[ BITMAP_HANDLE ] )
      aBitmap        := nil
   endif
   if ! Empty( aBitmap )
      if ! lBmpStretch .and. ! Empty( cText )
         nBmpWidth   := aBitmap[ BITMAP_WIDTH ]
         if aBitmap[ BITMAP_HEIGHT ] > oBmpRect:nHeight
            nBmpWidth   *= ( oBmpRect:nHeight / aBitmap[ BITMAP_HEIGHT ] )
         endif
         if lAnd( nBmpAlign, AL_RIGHT )
            oBmpRect:nLeft    := oBmpRect:nRight - nBmpWidth // aBitmap[ BITMAP_WIDTH ]
            oTxtRect:nRight   := oBmpRect:nLeft - BMP_EXTRAWIDTH
         else
            oBmpRect:nRight   := oBmpRect:nLeft + nBmpWidth // aBitmap[ BITMAP_WIDTH ]
            oTxtRect:nLeft    := oBmpRect:nRight + BMP_EXTRAWIDTH
         endif
      endif
      if hDC == nil
         ::oBrw:DrawImage( aBitmap, oBmpRect:aRect, lBmpTransparent, If( lBmpStretch, .t., 0 ), nAlpha )
      else
         FW_DrawImage( hDC, aBitmap, oBmpRect:aRect, lBmpTransparent, If( lBmpStretch, .t., 0 ), nAlpha )
      endif
   endif

   if ! Empty( cText ) .and. ValType( cText ) == 'C'
      cLeftText   := LeftText( Self, bLeftText, @cText, lAnd( nStrAlign, AL_RIGHT ) .and. FontEsc( oFont ) == 0 )
      if ! Empty( cLeftText )
         if hDC == nil
            ::oBrw:SayText( cLeftText, oTxtRect:aRect, 'L', oFont, nTxtColor, nil, nil, nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX ) )
         else
            FW_SayText( hDC, cLeftText, oTxtRect:aRect, 'L', oFont, nTxtColor, nil, nil, nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX ) )
         endif
      endif
      cAlign      := If( lAnd( nStrAlign, AL_RIGHT ), 'R', If( lAnd( nStrAlign, AL_CENTER ), "", 'L' ) )
      if hDC == nil
         ::oBrw:SayText( cText, oTxtRect:aRect, cAlign, oFont, nTxtColor, nil, nil, nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX ) )
      else
         FW_SayText( hDC, cText, oTxtRect:aRect, cAlign, oFont, nTxtColor, nil, nil, nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX ) )
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintHeader( nRow, nCol, nHeight, lInvert, hDC, nGrpWidth, aBitmap ) CLASS TXBrwColumn

   local hBrush
   local oFont
   local aColors
   local cHeader
   local nWidth, nRight, nBmpRow, nBmpCol, nBmpNo, nBmpAlign, nStrAlign
   local lOwnDC, nBottom, nStyle, cAlign := ""

   if ::bPaintHeader != nil
      return Eval( ::bPaintHeader, Self, nRow, nCol, nHeight, lInvert, hDC, nGrpWidth, aBitmap )
   endif

   DEFAULT lInvert := .f.

   if ::bClrHeader == nil
      ::Adjust()
   endif

   if nGrpWidth == nil // not group header painting
      if ! Empty( ::cOrder )
         ::oBrw:oSortCol   := Self
         ::oBrw:uSortVal   := ::Value()
      endif
   endif

   if nCol != nil
      if nCol != 0 .and. nGrpWidth == nil  // if not group header col
         ::nDisplayCol := nCol
      endif
   else
      nCol := ::nDisplayCol
   endif

   if ! lInvert
      aColors := Eval( ::bClrHeader )
   else
      aColors := { If( ::oBrw:l2000, CLR_BLACK, CLR_WHITE ), CLR_BLUE }
   endif

   if hDC == nil
      hDC := ::oBrw:GetDC()
      lOwnDC := .T.
   else
      lOwnDC := .F.
   endif

   if nGrpWidth == nil
      // normal header
      nWidth   := ::nWidth
      if ::cHeader == nil
         // This should never be the case, but some application code may assign nil to cheader
         ::cHeader := ''
      endif
      cHeader  := ::cHeader
      nRow     := nRow + ::nGrpHeight
      nHeight  := nHeight - ::nGrpHeight
      oFont    := ::HeaderFont
      nBmpNo      := ::nHeadBmpNo
      nBmpAlign   := ::nHeadBmpAlign
      nStrAlign   := ::nHeadStrAlign
   else
      // paint group header
      nWidth   := nGrpWidth
      cHeader  := ::cGrpHdr
      nHeight  := ::nGrpHeight
      oFont    := ::GrpFont
      if Empty( aBitmap )
         nBmpNo      := ::nGrpBmpNo
         aBitmap     := ::aBitmap( nBmpNo )
      endif
      nBmpAlign   := AL_LEFT
      nStrAlign   := If( Right( cHeader, 1 ) == ' ', AL_LEFT, If( Left( cHeader, 1 ) == ' ', AL_RIGHT, AL_CENTER ) )
   endif

   if Self == ::oBrw:oRightCol
      nRight   := ::oBrw:BrwWidth()
   else
      nRight   := Min( nCol + nWidth, ::oBrw:GridWidth() )
   endif

   if ::oBrw:l2000
      GradientFill( hDC, nRow - 1, nCol, nRow + nHeight - 1, nRight, ; //nCol + nWidth, ;
               Eval( ::bClrGrad, lInvert ) )
   else
      hBrush  := CreateColorBrush( aColors[ 2 ] )
      FillRect( hDC, { nRow, nCol, nRow + nHeight, nRight }, hBrush )
      DeleteObject( hBrush )
   endif

   if lOwnDC
      ::oBrw:ReleaseDC()
      hDC   := nil
   endif

   ::PaintBmpAndText( { nRow, nCol, nRow + nHeight, nCol + nWidth }, ;
                        cHeader, nStrAlign, nil, oFont, aColors[ 1 ], ;
                        IfNil( aBitmap, nBmpNo ), nBmpAlign, .t., ;
                        ::nAlphaLevelHeader, .f., ;
                        If( nGrpWidth == nil, ::cOrder, nil ), hDC )

return nil

//----------------------------------------------------------------------------//

METHOD nFooterType( nType ) CLASS TXBrwColumn

   if PCount() > 0
      if ValType( nType ) == 'N' .and. ;
         AScan( { AGGR_SUM, AGGR_MAX, AGGR_MIN, AGGR_COUNT, AGGR_AVG, AGGR_STD, AGGR_STDEVP }, nType ) > 0
         if ValType( ::nTotal ) != 'N'
            ::nTotal := 0.0
         endif
         ::hFooterType  := nType
         ::lTotal       := .t.
      else
         ::hFooterType  := nil
         ::nTotal       := nil
         ::lTotal       := .f.
      endif
   endif

RETURN ::hFooterType

//------------------------------------------------------------------//

METHOD footerStr() CLASS TXBrwColumn

   local cFooter := "", cType

   if ::bFooter != nil
      cFooter  := Eval( ::bFooter, Self )
      DEFAULT cFooter := ""
   elseif ::nTotal != nil .or. ! Empty( ::nFooterType )
      DEFAULT ::nFooterType := AGGR_SUM, ::nTotal := 0.0
      if ::nFooterType >= AGGR_STD
         if ::nCount > 0
            cFooter  := ::nTotalSq - ( ::nTotal * ::nTotal / ::nCount )
            cFooter  /= ::nCount - If( ::nFooterType == AGGR_STDEVP, 0, 1 )
            cFooter  ^= 0.5
         else
            cFooter  := 0
         endif
      elseif ::nFooterType == AGGR_AVG
         cFooter  := If( ::nCount > 0, ::nTotal / ::nCount, 0 )
      elseif ::nFooterType == AGGR_COUNT
         cFooter  := ::nCount
      elseif ::nFooterType == AGGR_SUM
         cFooter  := ::nTotal
      elseif ::nFooterType == AGGR_MIN
         if ::oBrw:nLen > 0 .and. ::nMinVal == nil
            ::oBrw:MakeTotals( Self )
         endif
         cFooter  := cValToChar( ::nMinVal )
      elseif ::nFooterType == AGGR_MAX
         if ::oBrw:nLen > 0 .and. ::nMaxVal == nil
            ::oBrw:MakeTotals( Self )
         endif
         cFooter  := cValToChar( ::nMaxVal )
      endif
   elseif ::cFooter != nil
      cFooter  := ::cFooter
   endif

   cType    := ValType( cFooter )
   if cType != 'C'
      if cType == ::cDataType .and. IfNil( ::cFooterPicture, ::cEditPicture ) != nil
         cFooter  := cValToStr( cFooter, IfNil( ::cFooterPicture, ::cEditPicture ),, ;
                     IfNil( ::lDisplayZeros, ::oBrw:lDisplayZeros ) )
      else
         cFooter := cValToChar( cFooter )
      endif
      cFooter := LTrim( cFooter )
   endif

return cFooter

//----------------------------------------------------------------------------//

METHOD PaintFooter( nRow, nCol, nHeight, lInvert ) CLASS TXBrwColumn

   local hDC, hBrush
   local oFont
   local aColors, aBitmap
   local cFooter, cLeftText
   local nWidth, nRight, nBmpRow, nBmpCol, nBmpNo, nBottom
   local oBmpRect, oTxtRect, cAlign

   if ::bPaintFooter != nil
      return Eval( ::bPaintFooter, Self, nRow, nCol, nHeight, lInvert )
   endif

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
   oFont   := ::FooterFont
   cFooter := ::footerStr()
   nWidth  := ::nWidth
   nBmpNo  := ::nFootBmpNo

   nBottom = nRow + ( nHeight / 3 )
   if Self == ::oBrw:oRightCol
      nRight   := ::oBrw:BrwWidth()
   else
      nRight   := Min( nCol + nWidth, ::oBrw:GridWidth())
   endif

   if ::oBrw:l2000
      GradientFill( hDC, nRow - 1, nCol, nRow + nHeight - 1, nRight, ;
            Eval( ::bClrGrad, lInvert ) )

   else
      hBrush  := CreateColorBrush( aColors[ 2 ] )
      FillRect( hDC, {nRow, nCol, nRow + nHeight, nRight }, hBrush )
      DeleteObject( hBrush )
   endif

   ::PaintBmpAndText( { nRow, nCol, nRow + nHeight, nRight }, ;
                        cFooter, ::nFootStrAlign, ::bLeftText, oFont, aColors[ 1 ], ;
                        nBmpNo, ::nFootBmpAlign, .t., ::nAlphaLevelFooter, .f. )
   ::oBrw:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

static function LeftText( oCol, bLeft, cText, lRightAlign )

   local cLeftText    := XEval( bLeft, oCol )

   if lRightAlign
      if Empty( cLeftText ) .and. ! Empty( cText )
         // Extract currency symbol as cLeftText
         if Left( cText, 1 ) $ "$" + Chr( 128 ) + Chr( 162 ) + Chr( 163 ) + Chr( 165 )
            cLeftText   := Left( cText, 1 )
            cText       := LTrim( SubStr( cText, 2 ) )
         elseif Left( cText, 4 ) == Chr( 0xe2 ) + Chr( 0x82 ) + Chr( 0xb9 ) + ' '
            cLeftText   := Left( cText, 3 )
            cText       := LTrim( SubStr( cText, 5 ) )
         endif
      endif
   elseif ! Empty( cLeftText )
      cText    := cLeftText + ' ' + cText
   endif

return cLeftText

//----------------------------------------------------------------------------//

METHOD RefreshFooter() CLASS TXBrwColumn

   if ! Empty( ::oBrw:nFooterHeight ) .and. ::IsVisible()
      ::PaintFooter(::oBrw:FooterRow()+1,nil,::oBrw:nFooterHeight-4)
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DataCol() CLASS TXBrwColumn

   local nCol  := ::nDisplayCol
   local aBitmap

   if ::bIndent != nil
      nCol     += IfNil( Eval( ::bIndent, Self ), 0 )
   endif
   if ::nDataBmpAlign == AL_LEFT .and. ::bBmpData != nil
      aBitmap  := ::aBitmap( Eval( ::bBmpData ) )
      if !Empty( aBitmap )
         nCol  += aBitmap[ BITMAP_WIDTH ] + BMP_EXTRAWIDTH
      endif
   endif

return nCol

//----------------------------------------------------------------------------//

METHOD SetColsAsRows(...) CLASS TXBrwColumn

   // Call this method before oBrw:CreateFromCode()

   local aCols := HB_AParams()

   if ! Empty( aCols )
      if ValType( aCols[ 1 ] ) == 'A'
         aCols    := aCols[ 1 ]
      endif
      ::aRows     := {}
      AEval( aCols, { |u| AAdd( ::aRows, ::oBrw:oCol( u ) ) } )
      AEval( ::aRows, { |o| o:lHide := .t. }, 2 )
      WITH OBJECT ATail( ::aRows )
         :nDataStyle := :DefStyle( :nDataStrAlign, .f. )
      END
   endif

return Self

//----------------------------------------------------------------------------//

METHOD PaintData( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow ) CLASS TXBrwColumn

   local oCol, n, nDataHeight

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif
   if ::oBrw:lTransparent .and. Empty( ::oBrw:nRowDividerStyle )
      nHeight     -= ROW_EXTRAHEIGHT
   endif
   nDataHeight    := If( Empty( ::aRows ), nHeight, IfNil( ::nCellHeight, ::DataHeight() ) )
   ::PaintCell( nRow, nCol, nDataHeight, lHighLite, lSelected, nOrder, nPaintRow )

   if ! Empty( ::aRows )
      for n := 2 to Len( ::aRows )
         nHeight        -= nDataHeight
         nRow           += nDataHeight
         oCol           := ::aRows[ n ]
         nDataHeight    := If( n == Len( ::aRows ), nHeight, IfNil( oCol:nCellHeight, oCol:DataHeight() ) )
         oCol:PaintCell( nRow, nCol, nDataHeight, lHighLite, lSelected, nOrder, nPaintRow )
      next n

   endif

return nil

//----------------------------------------------------------------------------//

METHOD PaintCellBack( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow ) CLASS TXBrwColumn

   local lTransparent      := .f.
   local oRect, oBrush, hBrush, aColors, nBottom
   local nTop, nRectCol, nRectWidth
   local nWidth
   local oRec2

   oBrush            := XEval( ::oBrush, Self )
   lTransparent      := Empty( oBrush ) .and. IfNil( ::lColTransparent, ::oBrw:lTransparent ) .and. ;
                        ! lHighLite // .and. ! lSelected

   if lHighLite
      if ::oBrw:lFocused
         if lSelected .and. nOrder == ::oBrw:nColSel  // nOrder is visible order of the column
            aColors  := Eval( ::bClrSelFocus )
         else
            if ::lFullHeight
               aColors  := Eval( ::bClrStd )
            else
               aColors := Eval( IfNil( ::oBrw:bClrRowFocus, ::bClrSelFocus ) )
            endif
         endif
      else
         aColors := Eval( ::bClrSel )
      endif
   else
      aColors := Eval( ::bClrStd )
   endif

   if ! lTransparent

      oRect       := TRect():New( nRow, nCol, nil, nil, ::nWidth, nHeight )
      if ::oBrw:nColDividerStyle == 0
         if ::oBrw:lTransparent .and. ::oBrw:nMarqueeStyle < MARQSTYLE_HIGHLROWRC
            oRect:nWidth   -= COL_EXTRAWIDTH
         endif
         oRect:nWidth   += 2
      elseif ::oBrw:nColDividerStyle < 5 .and. nOrder > 1
         oRect:nLeft    -= 1
      endif
      if ::lMergeVert .and. lHighLite .and. lSelected .and. nOrder == ::oBrw:nColSel
         nBottom        := oRect:nBottom
         ::MergeArea( @nRow, @nBottom, nPaintRow )
         oRect:nTop     := nRow
         oRect:nBottom  := nBottom
      endif

      oRect:nRight      := Min( oRect:nRight, If( Self == ::oBrw:oRightCol, ::oBrw:BrwWidth() - 2 , ::oBrw:GridWidth() - 2 ) )

      if ValType( aColors[ 2 ] ) == 'A'
         GradientFill( ::oBrw:GetDC(), oRect:nTop, oRect:nLeft, oRect:nBottom-1, oRect:nRight, aColors[ 2 ], .t. )
      else
         if oBrush == nil
            hBrush   := CreateColorBrush( aColors[ 2 ] )
         else
            hBrush   := oBrush:hBrush
         endif
         FillRect( ::oBrw:GetDC(), oRect:aRect, hBrush )
         if oBrush == nil
            DeleteObject( hBrush )
         endif
      endif
      if ::nBmpWidth != nil .and. ::nClrBmpBack != nil .and. !::lBmpStretch .and. ;
         ::nDataBmpAlign < AL_CENTER
         if lAnd( ::nDataBmpAlign, AL_RIGHT )
            oRect:nLeft    := oRect:nRight - ::nBmpWidth - COL_EXTRAWIDTH / 2 - BMP_EXTRAWIDTH / 2
         else
            oRect:nRight   := oRect:nLeft + ::nBmpWidth + COL_EXTRAWIDTH / 2 + BMP_EXTRAWIDTH / 2
         endif
         hBrush   := CreateColorBrush( ::nClrBmpBack )
         FillRect( ::oBrw:hDC, oRect:aRect, hBrush )
         DeleteObject( hBrush )
      endif
      ::oBrw:ReleaseDC()
   endif

return aColors

//----------------------------------------------------------------------------//

METHOD PaintCell( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow ) CLASS TXBrwColumn

   local hDC, oBrush, hBrush, nTextColor, nOldColor, hBmp, oBtn
   local oBrush1, oBrush2, hBrush1, hBrush2, aColor2, nWidth1
   local oFont
   local aColors, aBitmap, aBmpPal
   local cData, cStrData, nTxtHeight, aRect
   local nWidth, nTop, nBottom, nBmpRow, nBmpCol, nBmpNo, nButtonRow, nButtonCol,nBtnWidth,;
         nRectWidth, nRectCol, nStyle, nType, nIndent, nBtnBmp, nFontHeight, nBmpWidth
   local lTransparent := .f.
   local lStretch     := .f.
   local lBrush       := .f.
   local cImgData, nBmpW, nBmpH, cAlign
   local oRect, oBtnRect, n

   DEFAULT lHighLite := .f.,;
           lSelected := .f.,;
           nOrder    := 0

   if ::lFullHeight .and. Self == ::oBrw:oRightCol
      nRow     := ::oBrw:FirstRow()
      nHeight  := ::oBrw:BrwHeight() - IfNil( ::oBrw:nFooterHeight, 0 ) - nRow - 2
   endif

   nBtnBmp  := 0

   if ( ::oEditGet != nil .and. nPaintRow == ::oBrw:nRowSel ) .or. ::oEditLbx != nil .or. ::oBrw:nLen == 0
      return nil
   endif

   if nCol != nil
      ::nDisplayCol := nCol
   else
      nCol := ::nDisplayCol
   endif

   //----------------------------------------------------------------------------//
   // PAINT BACKGROUND
   //----------------------------------------------------------------------------//

   aColors  := ::PaintCellBack( nRow, nCol, nHeight, lHighLite, lSelected, nOrder, nPaintRow )

   hDC     := ::oBrw:GetDC()
   oFont   := ::DataFont

   //----------------------------------------------------------------------------//
   // CALCULATE DATA PAINT AREA
   //----------------------------------------------------------------------------//

   oRect          := TRect():New( nRow + ROW_EXTRAHEIGHT / 2, nCol + COL_EXTRAWIDTH / 2, nil, nil, ;
                           ::nWidth - COL_EXTRAWIDTH, nHeight - ROW_EXTRAHEIGHT )

   oRect:nLeft    += IfNil( XEval( ::bIndent, Self ), 0 )
   if Self == ::oBrw:oRightCol
      oRect:nRight := ::oBrw:BrwWidth() - 4
   else
      oRect:nRight   := Min( oRect:nRight, ::oBrw:GridWidth() - 4 )
   endif

   nBtnWidth   := 0
   if ::nEditType > 1 .or. ::lWillShowABtn
      if Empty( aBitmap := ::aBitmap( ::nBtnBmp ) )
         nBtnWidth   := IfNil( ::nBtnWidth, 10 )
      else
         if Empty( ::nBtnWidth )
            oBtnRect    := TRect():New( 0, 0, aBitmap[ BITMAP_HEIGHT ] + 2, aBitmap[ BITMAP_WIDTH ] + 2 )
            oBtnRect:FitInside( oRect, nil, "R" )
            oBtnRect:nTop     := oRect:nTop
            oBtnRect:nBottom  := oRect:nBottom
         else
            nBtnWidth   := ::nBtnWidth
         endif
      endif
      if nBtnWidth > 0
         oBtnRect       := TRect():New( oRect:nTop, oRect:nRight - nBtnWidth, oRect:nBottom, oRect:nRight )
      endif
      oRect:nRight   := oBtnRect:nLeft - 5
   endif

   if ::lMergeVert
      nTop           := oRect:nTop
      nBottom        := oRect:nBottom
      ::MergeArea( @nTop, @nBottom, nPaintRow )
      oRect:nTop     := nTop
      oRect:nBottom  := nBottom
   endif

   //----------------------------------------------------------------------------//
   // PROGRESS BAR
   //----------------------------------------------------------------------------//

   if ::lProgBar .and. oRect:nWidth > 4

      aRect    := oRect:Modify( ::aProgBarRect, .t. ):aRect
      aColor2  := Eval( ::bClrProg )

      if Len( ::aBitmaps ) > 1 .and. ;
         HB_ISNUMERIC( aColor2[ 1 ] ) .and. aColor2[ 1 ] <= Len( ::aBitmaps ) .and. ;
         HB_ISNUMERIC( aColor2[ 2 ] ) .and. aColor2[ 2 ] <= Len( ::aBitmaps )

         aColor2[ 1 ]   := ::aBitmap( aColor2[ 1 ] )
         aColor2[ 2 ]   := ::aBitmap( aColor2[ 2 ] )

      endif

      DrawProgressBar( hDC, aRect, ::Value, IfNil( XEval( ::nProgTot, Self ), 1 ), aColor2 )

   endif

   //----------------------------------------------------------------------------//
   // BITMAP
   //----------------------------------------------------------------------------//

   nBmpNo      := IfNil( XEval( ::bBmpData, ::Value() ), 0 )
   if !Empty( aBitmap := ::aBitmap( nBmpNo ) )
/*
      if ::nBmpWidth == nil .or. ::lBmpStretch
         nBmpWidth      := aBitmap[ BITMAP_WIDTH ]
         if aBitmap[ BITMAP_HEIGHT ] > oRect:nHeight
            nBmpWidth   *= ( oRect:nHeight / aBitmap[ BITMAP_HEIGHT ] )
         endif
      else
         nBmpWidth   := ::nBmpWidth
      endif
*/

      if Empty( ::nBmpWidth ) // 0 or nil
         // this can happen if the column is created after Adjust() is called
         ::nBmpWidth := ::oBrw:nRowHeight
      endif

      nBmpWidth   := ::nBmpWidth

      if oRect:nWidth >= nBmpWidth //aBitmap[ BITMAP_WIDTH ]
         aRect       := AClone( oRect:aRect )
         if !::lBmpStretch
            if lAnd( ::nDataBmpAlign, AL_RIGHT )
               aRect[ 2 ]  := aRect[ 4 ] - nBmpWidth
            elseif !lAnd( ::nDataBmpAlign, AL_CENTER )
               aRect[ 4 ]  := aRect[ 2 ] + nBmpWidth
            endif
         endif
         ::oBrw:DrawImage( aBitmap, aRect, ::lBmpTransparent, ::lBmpStretch, ::nAlphaLevel(), .f. ) //, ::cAlign( ::nDataBmpAlign ) )
//         ::oBrw:DrawImage( aBitmap, oRect:aRect, ::lBmpTransparent, ::lBmpStretch, ::nAlphaLevel(), .f., ::cAlign( ::nDataBmpAlign )  ) )
         if lAnd( ::nDataBmpAlign, AL_RIGHT )
            oRect:nRight   -= ( nBmpWidth + BMP_EXTRAWIDTH )
         elseif ! lAnd( ::nDataBmpAlign, AL_CENTER )
            oRect:nLeft    += ( nBmpWidth + BMP_EXTRAWIDTH )
         endif
      endif
   endif

   //----------------------------------------------------------------------------//
   // CHART
   //----------------------------------------------------------------------------//

   if HB_IsArray( ::aChartCols )
//      ::DrawChart( hDC, { nRow, nCol, nRow + nHeight, Min( nCol + nWidth, ::oBrw:GridWidth() - 4 ) } )
      ::DrawChart( hDC, oRect:aRect )
      cData       := nil
   endif

   //----------------------------------------------------------------------------//
   // READ DATA
   //----------------------------------------------------------------------------//

   cStrData := Trim( cValToChar( ::StrData ) )
   cData    := LTrim( cStrData )
   if ::nDataStrAlign == AL_CENTER
      cStrData := cData
   endif
   if isrtf( cData )
      cData := "<RichText>"
   elseif isGtf( cData )
      cData := GtfToTxt( cData )
   endif

   if ::cDataType == 'F' .and. ( File( cData ) .or. Lower( Left( cData, 7 ) ) == "http://" .or. ;
                                                    Lower( Left( cData, 8 ) ) == "https://" )

      //----------------------------------------------------------------------------//
      // CHECK EMF FILE AND SHOW EMF
      //----------------------------------------------------------------------------//

      if File( cData ) .and. Lower( cFileExt( cData ) ) == "emf"
         hBmp     := GetEnhMetaFile( cData )
         XPlayEnhMetaFile( hDC, hBmp, oRect:nTop, oRect:nLeft, oRect:nBottom, oRect:nRight )
         DeleteEnhMetaFile( hBmp )
         cData       := ""
         cImgData    := ""
      else
         cImgData    := cData
         cData       := ""
      endif

   endif

   if ! Empty( ::bStrImage )
      cImgData    := Eval( ::bStrImage, Self, ::oBrw )
   endif

   if ! Empty( cData )
      if ::cDataType == 'P'
         cImgData := cData; cData := ""
      elseif IsBinaryData( cData )
         if Empty( cImgData ) .and. Left( MemoryBufferType( cData ), 4 ) == "IMG."
            cImgData  := cData
            cData    := ''
         else
            cData    := RangeRepl( Chr(0), Chr(31), cData, '.' )
         endif
      endif
   endif

   //----------------------------------------------------------------------------//
   // PAINT IMAGE DATA
   //----------------------------------------------------------------------------//

   if ! Empty( cImgData )
      ::PaintCellImage( cImgData, oRect )
   endif

   //----------------------------------------------------------------------------//
   // PAINT TEXT DATA
   //----------------------------------------------------------------------------//

   oFont:Activate( hDC )
   nFontHeight := GetTextHeight( ::oBrw:hWnd, hDC )
   if ::oBrw:lTransparent .and. ::oBrw:lContrastClr
      nTextColor  := ContrastColor( hDC, oRect, aColors[ 1 ] )
   else
      nTextColor     := aColors[ 1 ]
   endif

   if ::bPaintText == nil
      if ! Empty( cData )
         ::PaintCellText( hDC, cStrData, oRect:aRect, { nTextColor, aColors[ 2 ] }, lHighLite, nHeight, nFontHeight, oFont )
      endif
   else
      SetTextColor( hDC, nTextColor )
      SetBkMode( hDC, 1 )
      Eval( ::bPaintText, Self, hDC, cStrData, oRect:aRect, aColors, lHighLite, lSelected )

   endif
   oFont:Deactivate( hDC )

   //----------------------------------------------------------------------------//
   // PAINT BUTTON
   //----------------------------------------------------------------------------//

   if ::nEditType > 1 .and. ::nEditType < EDIT_DATE
      if lSelected
         ::PaintCellBtn( hDC, oBtnRect )
      endif
   endif

   if aBmpPal != nil
      //DeleteObject( aBmpPal[ BITMAP_HANDLE ]  )
      PalBmpFree( aBmpPal[ 1 ], aBmpPal[ 2 ] )
      aBmpPal[ 1 ] := 0
   endif
   ::oBrw:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD PaintCellBtn( hDC, oRect ) CLASS TXBrwColumn

   local oBtn, oBrush

   if !::lBtnTransparent
      WndBoxRaised(hDC, oRect:nTop - 1, oRect:nLeft - 1,;
                        oRect:nBottom, oRect:nRight + 1 ) // ButtonGet
   endif

   if ::nEditType == EDIT_LISTBOX .or. ::nEditType == EDIT_GET_LISTBOX
      ::oBtnElip:Hide()
      oBtn     := ::oBtnList
   else
      ::oBtnList:Hide()
      oBtn     := ::oBtnElip
   endif
//   oBtn:Move( nButtonRow, nButtonCol, nBtnWidth + 1, nHeight, .f.) // ButtonGet
   oBtn:Move( oRect:nTop, oRect:nLeft, oRect:nWidth + 1, oRect:nHeight, .f.) // ButtonGet
   oBtn:Show()
   oBtn:GetDC()

   if .not. ::lBtnTransparent
/*
      FillRect( hDC, {nButtonRow, nButtonCol, nButtonRow + nHeight , nButtonCol + nBtnWidth + 1 },; // ButtonGet
                oBtn:oBrush:hBrush )
*/
      oRect:nRight   += 1
      FillRect( hDC, oRect:aRect, oBtn:oBrush:hBrush )

   endif
   oBtn:lTransparent := ::lBtnTransparent
   if ! Empty( oBtn:hBitmap1 )
      oBtn:PaintBitmap()
   elseif ! Empty( oBtn:cCaption )
      oBtn:PaintCaption()
   endif
   oBtn:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD PaintCellImage( cImageData, oRect ) CLASS TXBrwColumn

   local aBmpPal, aRect, ResizeMode, aImgRect

   aRect    := oRect:aRect
   if ::aImgRect == nil
      ResizeMode  := ::lBmpStretch
   else
      aImgRect    := XEval( ::aImgRect, Self )
      if ValType( aImgRect ) $ 'CN'
         ResizeMode  := aImgRect
      elseif ValType( aImgRect ) == 'A'
         if Len( aImgRect ) > 4
            ResizeMode := aImgRect[ 5 ]
         else
            ASize( aImgRect, 4 )
         endif
         aRect := oRect:Modify( aImgRect ):aRect
      endif
   endif

   aBmpPal     := ::oBrw:ReadImage( cImageData,, ::oBrw:lGDIP )
   if !Empty( aBmpPal ) .and. !Empty( aBmpPal[ 1 ] )
      ::oBrw:DrawImage( aBmpPal, aRect, ;
            ::lBmpTransparent, ResizeMode, ::nAlphaLevel(), .f., ::cAlign( ::nDataBmpAlign ) )
      PalBmpFree( aBmpPal[ 1 ], aBmpPal[ 2 ] )
   endif
   aBmpPal  := nil

return nil

//----------------------------------------------------------------------------//

METHOD PaintCellText( hDC, cData, aRect, aColors, lHighLite, nHeight, nFontHeight, oFont ) CLASS TXBrwColumn

   local nAlign      := ::nDataStrAlign
   local cAlign      := If( lAnd( nAlign, AL_TOP ), 'T', If( lAnd( nAlign, AL_BOTTOM ), 'B', '' ) )
   local nEsc        := FontEsc( oFont )
   local cLeftText, uFont, uColor

   if ::oBrw:nDataType == DATATYPE_ARRAY .and. nAlign == AL_LEFT .and. ;
      ValType( ::Value ) $ 'ND' .and. Empty( ::aEditListTxt )
      nAlign   := AL_RIGHT
   endif

   cLeftText   := LeftText( Self, ::bLeftText, @cData, lAnd( nAlign, AL_RIGHT ) .and. nEsc == 0 )
   if ! Empty( cLeftText )
      ::oBrw:SayText( cLeftText, aRect, 'L' + cAlign, oFont, aColors[ 1 ] )
   endif

   cAlign      += If( lAnd( nAlign, AL_RIGHT ), 'R', If( lAnd( nAlign, AL_CENTER ), "", 'L' ) )

   if Empty( ::aDataFont ) .and. Empty( ::aClrText )
      ::oBrw:SayText( cData, aRect, cAlign, oFont, aColors[ 1 ], nil, nil, nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX ) )
   else
      ::oBrw:SayText( cData, aRect, cAlign, IfNil( ::aDataFont, oFont ), ;
            IfNil( ::aClrText, aColors[ 1 ] ), nil, nil, ;
            nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ChartArrayVals( lReport ) CLASS TXBrwColumn

   local aRet
   local i,j,o,a
   local nLen     := 0

   DEFAULT lReport   := .f.

   aRet    := AClone( ::aChartCols )
   for i := 1 to Len( aRet )
      if ValType( aRet[ i ] ) == 'C'
         a     := {}
         for each o in ::oBrw:aCols
            if ! Empty( o:cGrpHdr ) .and. Upper( o:cGrpHdr ) == Upper( aRet[ i ] )
               AAdd( a, o )
            endif
         next
         if ! Empty( a )
            aRet[ i ]  := a
         endif
      endif
      if ValType( aRet[ i ] ) == 'A'
         nLen        := Max( nLen, Len( aRet[ i ] ) )
      endif
   next
   if nLen > 0 // multi dim array
      for i := 1 to Len( aRet )
         if ValType( aRet[ i ] ) == 'A'
            ASize( aRet[ i ], nLen )
         else
            aRet[ i ]  := { aRet[ i ] }
            ASize( aRet[ i ], nLen )
         endif
      next i
   else
      aRet := { aRet }
   endif

   if lReport
      for i := 1 to Len( aRet )
         for j := 1 to Len( aRet[ 1 ] )
            if ValType( aRet[ i, j ] ) != 'B'
               o             := ::oBrw:oCol( aRet[ i, j ] )
               aRet[ i, j ]  := If( o == nil, nil, o:bEditValue )
            endif
         next
      next
   else
      for i := 1 to Len( aRet )
         for j := 1 to Len( aRet[ 1 ] )
            if ValType( aRet[ i, j ] ) == 'B'
               aRet[ i, j ]  := Eval( aRet[ i, j ] )
            else
               o             := ::oBrw:oCol( aRet[ i, j ] )
               aRet[ i, j ]  := If( o == nil, nil, o:Value )
            endif
         next
      next
   endif

return aRet

//----------------------------------------------------------------------------//

METHOD DrawChart( hDC, aRect ) CLASS TXBrwColumn

   local aVals, nMaxVal
   local i, j, o, a

   aVals    := ::ChartArrayVals()

   if ValType( ::aChartColors ) == 'N'
      ::aChartColors    := { ::aChartColors }
   endif

   if ValType( ::aChartColors ) == 'A'
      if Len( ::aChartColors ) < Len( aVals )
         ASize( ::aChartColors, Len( aVals ) )
      endif
   else
      ::aChartColors := Array( Len( aVals ) )
   endif
   for i := 1 to Len( aVals )
      DEFAULT ::aChartColors[ i ] := ;
      { METRO_AMBER, METRO_OLIVE, CLR_HMAGENTA, CLR_HBLUE, CLR_HRED, CLR_HGREEN, CLR_RED, CLR_MAGENTA, CLR_GREEN }[ i ]
   next
   nMaxVal     := ::nChartMaxVal
   ::DrawChartInRect( hDC, TRect():New( aRect ), aVals, @nMaxVal, ::aChartColors, ::cChartType )
   if ::nChartMaxVal == nil .or. nMaxVal > ::nChartMaxVal
      ::nChartMaxVal    := nMaxVal
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DrawChartInRect( hDC, oRect, aVals, nMaxVal, aColor, cnType ) CLASS TXBrwColumn

   local i,j,nCol, nBarWidth, ay, nBlockWidth, nRatio
   local hPen, hBrush, hOldBrush
   local nSeries, nValues

//   DEFAULT aColor    := { CLR_GREEN, CLR_HMAGENTA, CLR_HBLUE, CLR_HRED, CLR_HGREEN, CLR_RED, CLR_MAGENTA }
   DEFAULT cnType    := "BAR"

   nSeries        := Len( aVals )
   nValues        := Len( aVals[ 1 ] )
   for i := 1 to Len( aVals )
      AEval( aVals[ i ], { |u,j| If( ValType( u ) == 'N', nil, aVals[ i, j ] := nil ) } )
   next i
   nMaxVal        := Max( IfNil( nMaxVal, 0 ), IfNil( FW_Greatest( aVals ), 0 ) )
   if Empty( nMaxVal )
      return nil
   endif
   nRatio         := ( oRect:nHeight - 4 ) / nMaxVal

   aY             := Array( nSeries, nValues ) //AClone( aVals )
   for i := 1 to Len( aVals )
      for j := 1 to Len( aVals[ i ] )
         if ValType( aVals[ i, j ] ) == 'N'
            aY[ i, j ] := oRect:nBottom - 2 - Round( nRatio * aVals[ i, j ], 0 )
            aY[ i, j ] := Min( oRect:nBottom, Max( oRect:nTop + 2, aY[ i, j ] ) )
         endif
      next
   next

   if Upper( cnType ) == "LINE"
      nBlockWidth       := Int( ( oRect:nWidth - 4 ) / ( Len( aY[ 1 ] ) - 1 ) )
      if nBlockWidth >= 3
         for i := 1 to Len( aY )
            hPen     := CreatePen( PS_SOLID, 2, aColor[ i ] )
            nCol        := oRect:nLeft + 2
            MoveTo( hDC, nCol, ay[ i, 1 ] )
            for j := 2 to Len( aY[ i ] )
               nCol     += nBlockWidth
               if aY[ i, j ] != nil
                  LineTo( hDC, nCol, ay[ i, j ], hPen )
               endif
            next j
            DeleteObject( hPen )
         next i
      endif
   elseif Upper( cnType ) == "BAR"
      MoveTo( hDC, oRect:nLeft,  oRect:nBottom - 2 )
      LineTo( hDC, oRect:nRight, oRect:nBottom - 2 )
      nBlockWidth       := Int( ( oRect:nWidth - 4 ) / Len( aY[ 1 ] ) )
      if nBlockWidth > Len( aY[ 1 ] ) + 2
         nBarWidth     := Int( ( nBlockWidth - 2 ) / Len( aY ) )
         for i := 1 to Len( aY )

            hBrush   := CreateColorBrush( aColor[ i ] )
            nCol        := oRect:nLeft + 2  + ( i - 1 ) * nBarWidth
            for j := 1 to Len( aY[ i ] )
               if aY[ i, j ] != nil
                  FillRect( hDC, { aY[ i, j ], nCol, oRect:nBottom - 2, nCol + nBarWidth }, hBrush )
                  wndbox( hDC, aY[ i, j ], nCol, oRect:nBottom - 2, nCol + nBarWidth )
               endif
               nCol     += nBlockWidth
            next j
            DeleteObject( hBrush )

         next i
      endif
   endif

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
      hBrush   := CreateColorBrush( aColors[ 2 ] )
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

   ::oBrw:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD Box( nRow, nCol, nHeight, nType ) CLASS TXBrwColumn

   local hDC
   local nWidth, nClr

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
      nClr     := XEval( ::oBrw:nColorBox, Self )
      if Empty( nClr )
         WndBox( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1 )
      elseif ISGDIOBJECT( nClr )
         WndBoxClr( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1, nClr )
      else
         WndBox2007( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1, nClr )
      endif
   case nType == 3 // Raise
      WndBoxRaised( hDC, nRow, nCol, nRow + nHeight - 1, nCol + nWidth - 1 )
   endcase

   ::oBrw:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD DefStyle( nAlign, lSingleLine ) CLASS TXBrwColumn

   local nStyle, nVAlign

   nStyle   := nOr( DT_MODIFYSTRING, DT_EDITCONTROL, DT_NOPREFIX )
   nVAlign  := nAnd( nAlign, 12 )
   nVAlign  := If( nVAlign == AL_TOP, DT_TOP, If( nVAlign == AL_BOTTOM, DT_BOTTOM, DT_VCENTER ) )
   nAlign   := nAnd( nAlign, 3 )

   do case
   case nAlign == AL_LEFT
      nStyle  := nOr( nStyle, DT_LEFT )
   case nAlign == AL_RIGHT
      nStyle  := nOr( nStyle, DT_RIGHT )
   case nAlign == AL_CENTER
      nStyle  := nOr( nStyle, DT_CENTER )
   end case

   if lSingleLine
      nStyle := nOr( nStyle, DT_SINGLELINE, nVAlign ) //DT_VCENTER)
   else
      nStyle := nOr( nStyle, DT_WORDBREAK)
   endif

return nStyle

//----------------------------------------------------------------------------//

METHOD HeaderLButtonDown( nMRow, nMCol, nFlags, lTouch ) CLASS TXBrwColumn

   if ::oBrw:nCaptured == 0 .and. ;
      ( ::oBrw:lAllowColSwapping .or. ! Empty( ::cSortOrder ) .or. ;
        ::bLClickHeader != nil )

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
            ::oBrw:MoveCol( Self, oCol, .t., .t. )
         endif
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD FooterLButtonDown( nMRow, nMCol, nFlags, lTouch ) CLASS TXBrwColumn

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
         ::oBrw:ColStretch()
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
      if nMCol > ( ::nDisplayCol + 10 ) .and. nMCol < ( ::oBrw:GridWidth() - 10 )
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

   local aColors, aBitmap

    if ::oBtnList != nil .and. ::oBtnElip != nil
        ::oBtnList:Hide()
        ::oBtnElip:Hide()
        return nil
    endif

   if ::oBrw:lCreated

      aColors  := If( ::bClrBtn == nil, Eval( ::bClrHeader ), Eval( ::bClrBtn, Self ) )
      aBitmap  := ::aBitmap( ::nBtnBmp )

      if ::oBtnList != nil
         ::oBtnList:End()
         ::oBtnList  := nil
      endif
      if ::oBtnElip != nil
         ::oBtnElip:End()
         ::oBtnElip  := nil
      endif

      if ValType( ::bCreateBtn ) == 'B'
         Eval( ::bCreateBtn, Self )
      endif

      if ::oBtnList == nil
         if ::bClrBtn == nil
            @ 0,0 BTNBMP ::oBtnList RESOURCE "" OF ::oBrw NOBORDER SIZE 0,0
         else
            @ 0,0 BTNBMP ::oBtnList RESOURCE "" OF ::oBrw NOBORDER SIZE 0,0 FLAT
            ::oBtnList:bClrGrad := nil
         endif
         ::oBtnList:lGDIP  := ::oBrw:lGDIP
         WITH OBJECT ::oBtnList
            if Empty( aBitmap )
               :hBitmap1 := FwDArrow()
            else
               :SetImages( aBitmap[ BITMAP_HANDLE ] )

               //:hBitmap1   := aBitmap[ BITMAP_HANDLE ]
               //:hPalette1  := aBitmap[ BITMAP_PALETTE ]
               // :HasAlpha(  :hBitmap1, 1 )
            endif
            // :bAction := { || ::ShowBtnList() }
            :SetFont( ::DataFont )
            :SetColor( aColors[ 1 ], aColors[ 2 ] )
         END
      endif
      ::oBtnList:cToolTip := ::cBtnToolTip
      ::oBtnList:bAction := { || ::ShowBtnList() }

      if ::oBtnElip == nil
         if ::bClrBtn == nil
            @ 0,0 BTNBMP ::oBtnElip OF ::oBrw NOBORDER SIZE 0,0 CENTER
         else
            @ 0,0 BTNBMP ::oBtnElip OF ::oBrw NOBORDER SIZE 0,0 CENTER FLAT
            ::oBtnElip:bClrGrad := nil
         endif
         ::oBtnElip:lGDIP  := ::oBrw:lGDIP
         WITH OBJECT ::oBtnElip
            if Empty( aBitmap )
               :cCaption := IfNil( ::cBtnCaption, "..." )
            else
               :SetImages( aBitmap[ BITMAP_HANDLE ] )
/*
               :hBitmap1   := aBitmap[ BITMAP_HANDLE ]
               :hPalette1  := aBitmap[ BITMAP_PALETTE ]
               :HasAlpha(  :hBitmap1, 1 )
               :aAlpha[ 1 ] := aBitmap[ BITMAP_ALPHA ]
*/
               :cCaption := ""
            endif
            // :bAction := {|| ::RunBtnAction() }
            :SetFont( ::DataFont )
            :SetColor( aColors[ 1 ], aColors[ 2 ] )
         END
      endif
      ::oBtnElip:cToolTip := ::cBtnToolTip
      ::oBtnElip:bAction := {|| ::RunBtnAction() }
/*
      if ::nBtnBmp > 0 .and. !empty( ::aBitMaps )
         if ::nBtnBmp > len( ::aBitMaps )
            ::nBtnBmp := len( ::aBitMaps )
         endif
         ::ChangeBitMap( )
      endif
*/
      ::oBtnList:Hide()
      ::oBtnElip:Hide()

   endif

return nil

//------------------------------------------------------------------------------

METHOD CreateBarGet() CLASS  TXBrwColumn

   local aColors  //:= Eval( ::bClrEdit )
   local lRight   := .f.

   if ::uBarGetVal != nil .and. ::oBarGet == nil
      aColors     := Eval( ::bClrEdit ) // Inserted
      if .not. Empty( ::aBarGetList )
         @ 0,0 COMBOBOX ::oBarGet VAR ::uBarGetVal SIZE ::nWidth, 200 PIXEL OF ::oBrw ;
            ITEMS ::aBarGetList COLOR aColors[ 1 ], aColors[ 2 ] ;
            FONT ::DataFont()
         ::oBarGet:bValid  := ::bBarGetValid()
      elseif ValType( ::uBarGetVal ) == "L"
         @ 0,0 CHECKBOX ::oBarGet VAR ::uBarGetVal PROMPT "" SIZE 16,16 PIXEL OF ::oBrw
      else
         lRight      := ( ValType( ::uBarGetVal ) $ 'NDT' )
         ::oBarGet   := TGet():New( 0, 0, { |x| If( x == nil, ::uBarGetVal, ::uBarGetVal := x ) }, ;
            ::oBrw, 10, 10, ::cBarGetPic, ::bBarGetValid, aColors[ 1 ], aColors[ 2 ], ;
            ::HeaderFont, nil, nil, .t., nil, .t., nil, nil, lRight, ;
             nil, .f., .f., nil, nil, .f.,;
             nil, nil, nil, nil, ::bBarGetAction, ::cBarGetBmp, nil,;
             nil, nil, ::oBrw:lLimitChars )
         ::oBarGet:bKeyChar := { |k,f,o| If( k == VK_TAB .or. k == VK_RETURN, ;
            ( If( o:lValid(), ::oBrw:SetFocus(), o:SetFocus() ), 0 ), nil ) }  //FWH17.07
      endif
      ::oBarGet:bChange    := ::bBarGetChange
   endif

   if ::oBarGet != nil
      ::oBarGet:Hide()
      ::oBarGet:Disable()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD CheckBarGet( lOn ) CLASS  TXBrwColumn

   local lCheckHide  := !( lOn == .t. )
   local lCheckShow  := !( lOn == .f. )
   local lShow
   local nRow, nCol

   if ::oBrw:lSeekBar
      return ::ShowSeek( lOn )
   endif

   if ::oBarGet != nil
      WITH OBJECT ::oBarGet
         lShow    := ::oBrw:lGetBar .and. ::nPos > 0 .and. ;
                     ::nDisplayCol >= 0 .and. ;
                     ::nDisplayCol + ::nWidth < ::oBrw:GridWidth()

         if :lVisible
            if lCheckHide .and. !lShow
               :Hide()
               :Disable()
            endif
            if lCheckShow
               nRow  := ::oBrw:HeaderHeight() + 2
               nCol  := ::nDisplayCol + 4
               if :IsKindOf( "TCHECKBOX" )
                  nCol  := ::nDisplayCol + Int( ( ::nWidth - 16 ) / 2 )
                  :Move( nRow, nCol, 16, 16, .t. )
               elseif :nTop != nRow .or. :nLeft != nCol .or. :nWidth != ( ::nWidth - 8 )
                  :Move( nRow, nCol, ::nWidth - 4 - 4, ::oBrw:nGetBarHeight - 4, .t. )
                  :Refresh()
                  if :IsKindOf( "TGET" ) .and. :oBtn != nil
                     :oBtn:Move( 1, :nWidth - :nHeight, Max( :oBtn:nWidth, :nHeight ), :nHeight - 2, .t. )
                  endif
                  if :IsKindOf( "TCOMBOBOX" )
                  //   :SendMsg( CB_SETITEMHEIGHT, -1, ::oBrw:nGetBarHeight - 4 )
                  endif
               endif
            endif
         else
            if lCheckShow .and. lShow
               nRow  := ::oBrw:HeaderHeight() + 2
               nCol  := ::nDisplayCol + 4
               if :IsKindOf( "TCHECKBOX" )
                  nCol  := ::nDisplayCol + Int( ( ::nWidth - 16 ) / 2 )
                  :Move( nRow, nCol, 16, 16, .f. )
                  :Show()
                  :Enable()
                  :Refresh()
               else
                  :Move( nRow, nCol, ::nWidth - 4 - 4, ::oBrw:nGetBarHeight - 4, .f. )
                  :Show()
                  :Enable()
                  :Refresh()
                  if :IsKindOf( "TGET" ) .and. :oBtn != nil
                     :oBtn:Move( 1, :nWidth - :nHeight, Max( :oBtn:nWidth, :nHeight ), :nHeight - 2, .f. )
                  endif
                  if :IsKindOf( "TCOMBOBOX" )
                  //   :SendMsg( CB_SETITEMHEIGHT, -1, ::oBrw:nGetBarHeight - 4 )
                  endif
               endif
            endif
         endif
      END
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ShowSeek( lOn ) CLASS  TXBrwColumn

   local nRow, nCol, nBottom, nRight
   local hDC, hBmp, aColor

   DEFAULT lOn := .t.

   if lOn .and. ::oBrw:lSeekBar .and. ::nPos > 0 .and. !::lHide .and. ;
      If( ::oBrw:lIncrFilter, Self == ::oBrw:oFilterCol, !Empty( ::cOrder ) )

      nCol        := ::nDisplayCol + 6
      nRow        := ::oBrw:HeaderHeight() + 2
      nBottom     := nRow + ::oBrw:nGetBarHeight - 4
      nRight      := Min( nCol + ::nWidth - 12, ::oBrw:GridWidth() - 2 )

      if nRight > nCol + 10
         aColor   := XEval( ::bClrEdit )
         hDC      := ::oBrw:GetDC()
         FillRectEx( hDC, { nRow, nCol, nBottom, nRight }, aColor[ 2 ] )
         WndBox( hDC, nRow, nCol-3, nBottom, nRight )
         ::oBrw:ReleaseDC()

         ::oBrw:SayText( ::oBrw:cSeek, { nRow, nCol, nBottom, nRight }, ;
            "L", ::HeaderFont, aColor[ 1 ] )

         hBmp  := FWBitmap( "zoom2" )
         ::oBrw:DrawImage( hBmp, { nRow, nCol, nBottom, nRight - 4 }, .t., nil, nil, nil, "R" )
         DeleteObject( hBmp )

      endif
   endif

return nil

//----------------------------------------------------------------------------//

/*
METHOD ChangeBitmap( ) CLASS TXBrwColumn // BtnGet

   if ::nBtnBmp > 0 .and. len( ::aBitmaps ) >= ::nBtnBmp
      DeleteObject( ::oBtnList:hBitmap1 )
      ::oBtnElip:hBitmap1 := ::aBitMaps[::nBtnBmp, BITMAP_HANDLE ]
      ::oBtnList:hBitmap1 := ::aBitMaps[::nBtnBmp, BITMAP_HANDLE ]
      ::oBtnElip:cCaption := ""
   else
      ::oBtnElip:hBitmap1 := 0
      ::oBtnList:hBitmap1 := 0
      ::oBtnElip:cCaption := "..."
   endif

   if ::oBrw:lAdjusted    // 2014-10-08 to avoid calling refresh() prematurely
      ::oBrw:refresh()
   endif

return nil
*/

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
   local cDataType

   if ValType( cKey ) == 'N'
      if cKey > 256
         return ( ::cDataType == 'C' .or. ::cDataType == nil )
      endif
      cKey     := Upper( Chr( cKey ) )
   endif

   if ::cEditKeys != nil
      if cKey $ ::cEditKeys
         lEditKey := .t.
      endif
   else
      cDataType      := ::cDataType
      if cDataType == nil
         cDataType   := ValType( ::Value )
      endif
      if cDataType == 'N'
         if IsDigit( cKey ) .or. cKey == '-' .or. cKey == '.' .or. ( cKey == '=' .and. ::oBrw:lFormulaEdit )
            lEditKey := .t.
         endif
      elseif cDataType $ 'DT'
         lEditKey := IsDigit( cKey )
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
   local nRow, nCol, nWidth, nHeight
   local nBtnWidth := 0// ButtonGet
   local hBrush
   local lCenter, lRight
   local oFont // Edit Font

   if ::cDataType != nil .and. ::cDataType $ 'FP'
      return nil
   endif

   oFont    = ::EditFont

   if ::bOnPostEdit == nil
      MsgStop( "oCol:bOnPostEdit not defined",;
               "Fivewin: Class TXBrwColumn" )
      return .f.
   endif

/*
   if ::nEditType == EDIT_GET
      if ! Empty( ::aEditListTxt )
         ::nEditType := EDIT_LISTBOX
      elseif ! Empty( ::bEditBlock )
         ::nEditType := EDIT_BUTTON
      endif
   endif
*/
   if ::nEditType == EDIT_LISTBOX
      return ::ShowBtnList( nKey )
    endif

    if ::nEditType == EDIT_BUTTON
        return ::RunBtnAction( nKey )
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

   uValue  := IfNil( ::Value, ::BlankValue() )

   if ValType( uValue ) == 'B'
      uValue   := Eval( uValue )
   endif

   if ValType( uValue ) == 'T' .and. cPic == '@D'
      uValue   := FW_TTOD( uValue )
   endif
   if ValType( uValue ) $ 'DT'
      cPic     := nil
   endif

   if ::nEditType >= EDIT_DATE
      return ::EditDateTime( nKey )
   endif

   aColors := Eval( ::bClrEdit )
   lCenter := lAnd( ::nDataStrAlign, AL_CENTER )
   lRight  := lAnd( ::nDataStrAlign, AL_RIGHT )

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. )

   if ValType( uValue ) == 'C'
      if IsBinaryData( uValue ) .or. IsRTF( uValue ) .or. IsGTF( uValue ) .or. ;
         ( ::cDataType == 'M' .and. ( ::lRTF == .t. .or. ;
                                      IfNil( ::nDataLines, ::oBrw:nDataLines ) < 2 ) )

         return ::RunBtnAction()
      endif
   endif

   hBrush := CreateColorBrush( aColors[ 2 ] )
   ::EraseData( nRow, ::nDisplayCol, ::oBrw:nRowHeight  , hBrush )
   DeleteObject( hBrush )

   // cPic     := xEval( cPic, uValue )  // commented out bcuz xeval() already done by access method 2015-12-15
   if ValType( uValue ) == 'C' .and. IfNil( ::nDataLines, ::oBrw:nDataLines ) >= 2 .and. ;
      Empty( cPic ) .or. ::lFullHeight

         ::oEditGet := TMultiGet():New( 0,0,{ | u | If(PCount()==0,uValue,uValue:= u ) },;
                                       ::oBrw,0,0,oFont,.F.,aColors[ 1 ],aColors[ 2 ];
                                       ,,.F.,,.F.,,lCenter,lRight,.F.,,,.F.,.T.,.F. ) // oFont ADDED
   else

      if ValType( uValue ) $ 'AHO'
         XBrowse( uValue, ::cHeader, nil, nil, nil, nil, nil, .t. )
         return .f.
      else
         if nKey == Asc( '=' )
            uValue   := Space( 128 )
            cPic     := "@KS" + LTrim( Str( ::nWidthChr() ) )
         endif

#ifndef __XHARBOUR__
         if Empty( cPic ) .and. ValType( uValue ) == 'N'
            cPic     := NumPict( ::nWidthChr, Len( AfterAtNum( '.', cValToChar( uValue ) ) ) )
         endif
#endif

         ::oEditGet := TGet():New( 0,0,{ | u | If(PCount()==0,uValue,uValue:= u ) },;
                                  ::oBrw,0,0,cPic,,aColors[ 1 ],aColors[ 2 ], ;
                                  oFont,.F.,,.F.,,.F.,,lCenter,lRight,,.F.,.f.,.T.,,.F.,,,,,;
                                  nil, nil, nil, nil, ::nChrGrp, ::nMaxLen )

         if !( ::bClrEdit == ::bClrStd )
            ::oEditGet:bColor := { || aColors }
         endif

      endif
   endif

   nRow    := ( ( ::oBrw:nRowSel - 1  ) * ::oBrw:nRowHeight ) + ::oBrw:FirstRow() + 2

   nCol     := ::DataCol()

   nHeight := ::oBrw:nRowHeight - 4

   if ::lFullHeight
      nRow     := ::oBrw:FirstRow() + 1
      nHeight  := ::oBrw:BrwHeight() - ::oBrw:FooterHeight() - nRow - 3
   endif

   if ::nEditType == EDIT_GET_LISTBOX
      nBtnWidth      := ::oBtnList:nWidth + 2
   elseif ::nEditType == EDIT_GET_BUTTON
      nBtnWidth      := ::oBtnElip:nWidth + 2
   endif

   nWidth   := ::nWidth - nBtnWidth - 1

   if nKey == Asc( '=' )
     ::oEditGet:bValid  := < | oGet |
                              local lValid, cBuf

                              oGet:lValidating := .t.
                              cBuf        := SubStr( oGet:VarGet(), 2 )
                              lValid      := Type( StrTran( cBuf, '%', '/100' ) ) == 'N'
                              if lValid
                                 oGet:VarPut( &( StrTran( cBuf, '%', '/100' ) ) )
                                 if ::bEditValid != nil
                                    if ! ( lValid := Eval( ::bEditValid, oGet, Self ) )
                                       oGet:VarPut( '=' + cBuf )
                                    endif
                                 endif
                              endif
                              if lValid
                                 oGet:bValid := nil
                              else
                                 oGet:SetFocus()
                              endif
                              oGet:lValidating := .f.
                              return lValid
                           >
   else

   if ::bEditValid != nil
/*
*      This works well with browse created from source. But with browse created from Resource,
*      Valid is executed twice. This code is replaced with the next line: 2010-03-29
*
*      ::oEditGet:bValid := { | oGet, lRet | oGet:lValidating := .T., lRet := Eval( ::bEditValid, oGet, Self ), oGet:lValidating := .F., If( ! lRet, oGet:SetFocus(),), lRet }
*/

      ::oEditGet:bValid := { | oGet, lRet | oGet:lValidating := .T., ;
                             lRet := Eval( ::bEditValid, oGet, Self ), oGet:lValidating := .F., ;
                             If( lRet, oGet:bValid := nil, oGet:SetFocus() ), lRet }

   endif

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
   if XbrGetSelectAll() == .t. .or. ;
         ( XBrGetSelectAll() == nil .and. nKey != nil .and. ValType( uValue ) != 'N' .and. ;
            ::oEditGet:ClassName() == 'TGET' )
      ::oEditGet:SelectAll()
   endif

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

   if ::bOnPreEdit != nil
      Eval( ::bOnPreEdit, Self )
   endif

return .t.

//-------------------------------------------------------------------//

static function fnAddBitmap( o, uBmp, aResize )

   local nBmpNo := 0, aBmpPal, hBmp, oBrw

   oBrw     := If( o:IsKindOf( 'TXBROWSE' ), o, o:oBrw )

   if ValType( uBmp ) == 'A' .and. !FW_CreateBitmap( uBmp,,.t. )
      AEval( uBmp, { |u| nBmpNo := fnAddBitmap( o, u, aResize ) } )
      return nBmpNo
   endif

   aBmpPal  := oBrw:ReadImage( uBmp, aResize, oBrw:lGDIP .and. Empty( aResize ) )
   AAdd( o:aBitmaps, aBmpPal )
   nBmpNo   := Len( o:aBitmaps )

return nBmpNo

//------------------------------------------------------------------//

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
      if oCol:lRunBtnAction == .t. .and. ;
         ( ! Empty( oCol:bEditBlock ) .or. ! Empty( oCol:aEditListTxt ) )
            oCol:lRunBtnAction := nil

         oCol:oEditGet:End()
         oCol:oEditGet  := nil
         oBrw:lEditMode  := .f.
         oCol:RunBtnAction()

      else
         oCol:PostEdit()
      endif
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

      case nKey == VK_TAB
           lExit  := .t.

      case nKey == VK_DOWN .or. nKey == VK_UP
           if !( Empty( ::cEditPicture ) .and. ::oBrw:nDataLines > 1 )
              lExit := .t.
           endif

      case ::oBrw:lExitGetOnTypeOut .and. ;
           ( nKey == VK_SPACE .or. ( nKey > 47 .and. nKey < 96 ) ) .and. ;
           ::oEditGet:oGet:TypeOut .and. !Set( _SET_CONFIRM )

           lExit    := .t.
           ::oEditGet:nLastKey := VK_RETURN
           ::oEditGet:End()
           ::PostEdit()
           if ::oBrw:lFastEdit
              PostMessage( ::oBrw:hWnd, WM_KEYDOWN, nKey )
           endif

           return nil

   endcase

   If lExit .and. ::nEditType != EDIT_DATE
      if ::oEditGet != nil     // AL 2007-07-10
         ::oEditGet:nLastKey := nKey
         ::oEditGet:End()
      endif
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

   oFont = ::EditFont

   uValue  := ::Value

   aColors := Eval( ::bClrEdit )
   lCenter := lAnd( ::nDataStrAlign, AL_CENTER )
   lRight  := lAnd( ::nDataStrAlign, AL_RIGHT )

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. )

   hBrush := CreateColorBrush( aColors[ 2 ] )
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

   nRow    := ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. ) + 2
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
   local nAt, nRow, nCol, nWidth, nHeight, aColors, oFont
   local lWhen    := ( ::bEditWhen == nil .or. Eval( ::bEditWhen, Self ) )
   local lTouch   := isEventByTouch()

//   if ::aEditListTxt == nil
   if Empty( ::aEditListTxt )
      MsgStop( "oCol:aEditListTxt not defined", "Fivewin: Class TXBrwColumn" )
      return .f.
   endif

   if ::bOnPostEdit == nil
      MsgStop( "oCol:bOnPostEdit not defined",;
               "Fivewin: Class TXBrwColumn" )
      return .f.
   endif

   ::oBrw:nColSel := ::nPos

   if ValType( ::aEditListTxt[ 1 ] ) == 'A'
      ::aEditListBound  := ArrTranspose( ::aEditListTxt )[ 1 ]
      ::aEditListTxt    := ArrTranspose( ::aEditListTxt )[ 2 ]
   endif

   aBound   := IfNil( ::aEditListBound, AClone( ::aEditListTxt ) )
   if ValType( xValue := ::Value ) == 'C'
      xValue   := Trim( xValue )
   endif
   if ( nAt := Ascan( aBound, xValue ) ) == 0
      if ValType( xValue ) == 'C'
         do while Len( xValue ) > 1 .and. nAt == 0
            xValue      := Left( xValue, Len( xValue ) - 1 )
            nAt         := AScan( aBound, xValue )
         enddo
      elseif ( nAt := AScan( aBound, { |u| xValue <= u } ) ) == 0
         nAt   := Len( aBound )
      endif
   endif
   xValue   := nil

   oFont    := ::EditFont
   nRow     := ( ::oBrw:nRowSel * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. ) - 1
   nCol     := ::nDisplayCol - 2
   nWidth   := ::nWidth + 3
   nWidth   := Max( nWidth, CalcTextWH( ::oBrw, ::aEditListTxt, oFont )[ 1 ] + COL_EXTRAWIDTH + ;
                            IfNil( ::nBtnWidth, 10 ) + 5 )
   nWidth   := Min( nWidth, ::oBrw:BrwWidth() - 2 )
   nCol     := Max( 1, Min( nCol, ::oBrw:BrwWidth() - nWidth -2 ) )
   nHeight  := Len( ::aEditListTxt ) * If( lTouch, DeviceTouchSpace(), FontHeight( ::oBrw, oFont ) ) + 2

   If nRow + nHeight > ::oBrw:BrwHeight() - ::oBrw:FooterHeight()
      if nHeight <= ( nRow - ::oBrw:nRowHeight - ::oBrw:HeaderHeight( .t. ) )
         nRow     := nRow - ::oBrw:nRowHeight - nHeight
      elseif ( nRow - ::oBrw:nRowHeight - ::oBrw:HeaderHeight( .t. ) ) > ( ::oBrw:BrwHeight() - ::oBrw:FooterHeight() - nRow )
         nHeight  := Min( nHeight, nRow - ::oBrw:nRowHeight - ::oBrw:HeaderHeight( .t. ) )
         nRow     -= ( nHeight + ::oBrw:nRowHeight )
      else
         nHeight  := Min( nHeight, ::oBrw:BrwHeight() - ::oBrw:FooterHeight() - nRow )
      endif
   Endif

   if ::oEditGet != nil
      ::oEditGet:End()
      ::oEditGet := nil
      hBrush := CreateColorBrush( Eval( ::bClrSel )[ 2 ] )
      ::EraseData( ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. ),;
                  ::nDisplayCol, ::oBrw:nRowHeight , hBrush )
      DeleteObject( hBrush )
   endif

   aColors  := Eval( ::bClrEdit )
//   oFont    := ::EditFont
   @ 0, 0 LISTBOX ::oEditLbx VAR nAt OF ::oBrw SIZE 0,0 ITEMS ::aEditListTxt ;
         COLOR aColors[ 1 ], aColors[ 2 ] FONT oFont

   if lTouch
      ::oEditLbx:SendMsg( LB_SETITEMHEIGHT, 0, DeviceTouchSpace() )
   endif

//   ::oEditLbx:bLostFocus := { | oLbx, hWndFocus | ::PostEdit( aBound[ Max( 1, nAt ) ], .t. ) }

   ::oEditLbx:bLostFocus := { | oLbx, hWndFocus | ::PostEdit( nil, .t. ) }

   ::oEditLbx:bLButtonUp := {|| ::oEditLbx:Change(), ::PostEdit( If( lWhen, aBound[ nAt ], nil ), .t. ) }

   ::oEditLbx:bChange = {|| If( ::oEditLbx != nil, ::oEditLbx:nLastKey := VK_RETURN,) }

   IF ::oBrw:oWnd:IsKindOf( "TDIALOG" )
      ::oEditLbx:nDlgCode = DLGC_WANTALLKEYS
      ::oEditLbx:bKeyDown   := { | nKey | If( nKey == VK_RETURN,;
                                            ( If( ::oEditLbx != nil, ::oEditLbx:Change(),),;
                                              ::PostEdit( If( lWhen, aBound[ nAt ], nil ), .t. ) ),) }

   ELSE
      ::oEditLbx:bKeyDown   := {|k| ::oEditLbx:nLastKey := k, ;
                                 If( k == VK_RETURN .and. nAt > 0 .and. lWhen,  xValue := aBound[ nAt ], ),;
                                 If( k == VK_RETURN .or. k == VK_ESCAPE, ::PostEdit( xValue, .t. ), ) }
   ENDIF

   ::oEditLbx:Move( nRow, nCol, nWidth, nHeight, .t. )
   ::oEditLbx:SetFocus()

   ::oBrw:lEditMode := .T.

   if nKey != nil
      PostMessage( ::oEditLbx:hWnd, WM_CHAR, nKey )
   endif

   ::oBrw:nLastEditCol := ::nPos

return .T.

//----------------------------------------------------------------------------//

METHOD RunBtnAction( nKey ) CLASS TXBrwColumn

   local nRow, nCol
   local hBrush, bEditBlock

   if ::bEditBlock == nil
      if ::IsMemo()
         bEditBlock     := { |r,c,o,k| XbrEditMemo( r,c,o,k ) }
      else
         MsgStop( "oCol:bEditBlock not defined", "Fivewin: Class TXBrwColumn")
         return .f.
      endif
   else
      bEditBlock  := ::bEditBlock
   endif

   ::oBrw:nColSel := ::nPos

   if ::oEditGet != nil
      ::oEditGet:End()
      ::oEditGet := nil
      hBrush := CreateColorBrush( Eval( ::bClrSel )[ 2 ] )
      ::EraseData( ( ( ::oBrw:nRowSel - 1 ) * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. ),;
                  ::nDisplayCol, ::oBrw:nRowHeight , hBrush )
      DeleteObject( hBrush )
   endif

   nRow := ( ::oBrw:nRowSel * ::oBrw:nRowHeight ) + ::oBrw:HeaderHeight( .t. ) - 3
   nCol := ::nDisplayCol

   ::oBrw:lEditMode := .T.
   ::PostEdit( Eval( bEditBlock, nRow, nCol, Self, nKey ), .t. )
   ::oBrw:nLastEditCol := ::nPos

return .t.

//----------------------------------------------------------------------------//

METHOD PostEdit( xValue, lButton, lDirectAssign ) CLASS TXBrwColumn

   local lGoNext := .f.
   local uOriginal    := ::Value()
   local nLastKey := 0
   local bOnPostEdit
   local lRefresh := .f.
   local oCol
   local aPreSum, aPreVal
   local nSecs    := SECONDS()

   if ::lOnPostEdit
      return nil
   Endif

   if ::lReadOnly .or. ::oBrw:lReadOnly
      return nil
   endif

   if ! Empty( ::oBrw:aSumCols )
      ::oBrw:SaveTotals()
   endif

   ::lOnPostEdit := .t.
   if ValType( uOriginal ) == 'B'
      bOnPostEdit       := { |o,x,k| If( k != VK_ESCAPE, xEval( uOriginal, x, o ), nil ) }
   else
      if ::bOnPostEdit == nil
         if ::bEditValue == nil
            ::bOnPostEdit  := { || nil } // dummy
         else
            ::bOnPostEdit  := { |o,x,n| If( n != VK_ESCAPE .and. ::oBrw:Lock(), ::Value := x, nil ) }
         endif
      endif
      bOnPostEdit       := ::bOnPostEdit
   endif

   DEFAULT lButton := .f., lDirectAssign := .f.

   do case
      case xValue != nil .and. ( ::nEditType == EDIT_GET .or. lDirectAssign )

         Eval( bOnPostEdit, Self, xValue, VK_RETURN )
         nLastKey    := If( lDirectAssign, 0, VK_RETURN )

      case ::nEditType == EDIT_GET .or. ::nEditType >= EDIT_DATE
         if ::oEditGet != nil
            Eval( bOnPostEdit, Self, Eval( ::oEditGet:bSetGet ), ::oEditGet:nLastKey )
            nLastKey := ::oEditGet:nLastKey
            ::oEditGet:End()
            ::oEditGet := nil
         endif

      case ::nEditType == EDIT_LISTBOX
         if xValue != nil
            if ::oEditLbx != nil .and. ::oEditLbx:nLastKey == VK_RETURN
               Eval( bOnPostEdit, Self, xValue, If( ::oEditLbx != nil, ::oEditLbx:nLastKey, 0 ) )
            endif
            nLastKey   := If( ::oEditLbx != nil, ::oEditLbx:nLastKey, 0 )
         endif
         if ::oEditLbx != nil .and. IsWindow( ::oEditLbx:hWnd )
            ::oEditLbx:End()
            ::oEditLbx := nil
         endif

      case ::nEditType == EDIT_BUTTON

         nLastKey     := If( xValue == nil, VK_ESCAPE, VK_RETURN )
         Eval( bOnPostEdit, Self, xValue, nLastKey )

      case ::nEditType == EDIT_GET_LISTBOX
         if ::oEditLbx != nil .and. IsWindow( ::oEditLbx:hWnd )
            nLastKey  := ::oEditLbx:nLastKey
            ::oEditLbx:End()
            ::oEditLbx := nil
         endif
         if ::oEditGet != nil
            if ! lButton
               xValue    := Eval( ::oEditGet:bSetGet )
               nLastKey  := ::oEditGet:nLastKey
            endif
            ::oEditGet:End()
            ::oEditGet   := nil
         endif
         if xValue != nil .and. ( ::bEditWhen == nil .or. Eval( ::bEditWhen, Self ) )
            Eval( bOnPostEdit, Self, xValue, nLastKey )
         endif

      case ::nEditType == EDIT_GET_BUTTON
         if ! lButton
            if ::oEditGet != nil
               Eval( bOnPostEdit, Self, Eval( ::oEditGet:bSetGet ), ::oEditGet:nLastKey )
               nLastKey    := ::oEditGet:nLastKey
               ::oEditGet:End()
               ::oEditGet := nil
            endif
         else     // if xValue != nil
            nLastKey    := If( xValue == nil, VK_ESCAPE, VK_RETURN )
            Eval( bOnPostEdit, Self, xValue, nLastKey )
         endif
   endcase

   lGoNext := !lDirectAssign .and. ( AScan( { VK_RETURN, VK_DOWN, VK_UP, VK_TAB }, nLastKey ) > 0 )

   ::oBrw:SaveData( @lRefresh )
//   ::oBrw:Unlock() // FWH 17.01 moved after evak* ::bOnChange

   ::lOnPostEdit     := .f.
   ::oBrw:lEditMode  := .f.
   ::oBrw:nLastKey   := nLastKey
   ::oBrw:nSaveSecs := SECONDS() - nSecs

   if ::bOnChange != nil .and. ( ! EQ( ::Value, uOriginal, .t., .t. ) .or. ;
                                 ValType( uOriginal ) == 'B' )
      Eval( ::bOnChange, Self, uOriginal )
   endif

   ::oBrw:Unlock() // FWH 17.01 moved down here

   ::oBrw:nSaveSecs := SECONDS() - nSecs

   if !lDirectAssign
      ::oBrw:SetFocus()
   endif

   if lRefresh
      ::oBrw:Refresh()
   elseif Empty( ::cOrder )
      ::oBrw:DrawLine( .t. )
   else
      if ::oBrw:nDataType == DATATYPE_ARRAY
         ::cOrder    := If( ::cOrder == 'A', 'D', 'A' )
         ::SetOrder()
      endif
      ::oBrw:Refresh()
   endif

   if !Empty( ::oBrw:aSumCols )
      ::oBrw:ReCalcTotals()
      ::oBrw:RefreshFooters()
   endif

   If lGoNext
//      ::oBrw:nLastKey   := nLastKey  // already assigned a few lines above
      ::oBrw:GoNextCtrl()
   Endif

return nil

//----------------------------------------------------------------------------//

METHOD SumOfCols( aCols, nType ) CLASS TXBrwColumn

   local nSum, nSumSq, nCount
   local u, n, oCol

   DEFAULT nType := AGGR_SUM

   if ValType( aCols ) == 'C'
      // Group
      u     := Upper( aCols )
      aCols := {}

      for each oCol in ::oBrw:aCols
         if ! Empty( oCol:cGrpHdr ) .and. Upper( oCol:cGrpHdr ) == u
            AAdd( aCols, oCol )
         endif
      next oCol

   endif

   nCount   := 0
   if nType != AGGR_MIN .and. nType != AGGR_MAX
      nSum := nSumSq := 0
   endif
   if ! Empty( aCols )
      for each oCol in aCols
         if ValType( oCol ) != 'O'
            oCol     := ::oBrw:oCol( oCol )
         endif
         if oCol != nil .and. oCol != Self
            if ValType( n := oCol:Value() ) == 'N'
               if nType == AGGR_MIN
                  nSum  := If( nSum == nil, n, Min( n, nSum ) )
               elseif nType == AGGR_MAX
                  nSum  := If( nSum == nil, n, Max( n, nSum ) )
               else
                  nSum     += n
                  nCount++
                  if lAnd( nType, AGGR_STD )
                     nSumSq   += ( n * n )
                  endif
               endif
            endif
         endif
      next oCol
   endif

   if nType == AGGR_COUNT
      nSum  := nCount
   elseif nType == AGGR_AVG
      nSum  := If( nCount > 0, nSum / nCount, 0 )
   elseif nType >= AGGR_STD
      if nCount > 0
         nSum  := nSumSq - ( nSum * nSum / nCount )
         if nType == AGGR_STDEVP .or. nCount == 1
            nSum  /= nCount
         else
            nSum  /= ( nCount - 1 )
         endif
         nSum  ^= 0.5
      else
         nSum  := 0
      endif
   endif

return nSum

//------------------------------------------------------------------//

METHOD SetOrder() CLASS TXBrwColumn

   LOCAL   lSorted   := .F.
   LOCAL   n, cSort, uVal, nSecs
   LOCAL   lDolphin  := .f.
   LOCAL   cOrdBag   := If( ValType( ::cOrdBag ) == 'B', Eval( ::cOrdBag ), ::cOrdBag )

   if ::cOrder == 'A' .and. ! ::oBrw:lSortDescend
      return .f.
   endif

   if ::oBrw:lAutoSort .and. ::cSortOrder != nil

      nSecs    := SECONDS()

      if ValType( ::cSortOrder ) == "B"
         uVal  := Eval( ::cSortOrder, Self )
         lSorted := ( ValType( uVal ) == 'C' .and. Upper( uVal ) $ 'AD' )
         if lSorted
            ::oBrw:cOrders := " "
            ::cOrder       := Upper( uVal )
         endif

      elseif ::oBrw:nDataType == DATATYPE_ARRAY
         lSorted := ::SortArrayData()

      elseif lAnd( ::oBrw:nDataType, DATATYPE_ADO ) .and. ::oBrw:oRs != nil

         n       := If( ::oBrw:oRs:RecordCount > 0, ::oBrw:oRs:BookMark, nil )
         cSort   := Upper( ::oBrw:oRs:Sort )
         cSort   := TRIM( StrTran( StrTran( cSort, ' DESC', '' ), ' ASC', '' ) )
         if EQ( CharRem( "[]", cSort ), CharRem( "[]", ::cSortOrder ) )
            ::cOrder       := If( ::cOrder == 'D', 'A', 'D' )
         else
            ::oBrw:cOrders := ' '
            ::cOrder       := 'A'
         endif
/*
         lSorted           := .t.
         ::oBrw:oRs:Sort   := ::cSortOrder + If( ::cOrder == 'D', ' DESC', '' )
         if lSorted .and. n != nil
            ::oBrw:oRs:BookMark  := n
         endif
*/
         TRY
            ::oBrw:oRs:Sort   := ::cSortOrder + If( ::cOrder == 'D', ' DESC', '' )
            lSorted           := .t.
         CATCH
            ::cSortOrder      := nil
            ::cOrder          := ' '
         END
         if lSorted .and. n != nil
            ::oBrw:oRs:BookMark  := n
         endif

      elseif lAnd( ::oBrw:nDataType, DATATYPE_MYSQL ) .and. ::oBrw:oMysql != nil
         n                 := 0
         lDolphin          := ::oBrw:oMysql:IsKindOf( 'TDOLPHINQRY' )
         if lDolphin
            cSort   := Lower( ::oBrw:oMysql:cOrder )
         else
            cSort   := Lower( ::oBrw:oMysql:cSort )
         endif
         cSort   := AllTrim( StrTran( StrTran( cSort, ' desc', '' ), ' asc', '' ) )
         if EQ( cSort, ::cSortOrder ) // already sorted on this column
            ::cOrder    := If( ::cOrder == 'D', 'A', 'D' )
            n           := ::oBrw:oMySql:LastRec() - ::oBrw:oMySql:RecNo() + 1
         else
            ::oBrw:cOrders       := " "
            ::cOrder             := 'A'
         endif
         lSorted     := .t.
         cSort       := ::cSortOrder + If( ::cOrder == 'D', " DESC", "" )
         if lDolphin
            uVal     := ::Value
            ::oBrw:oMySql:lInverted := ( ::cOrder == 'D' )
            ::oBrw:oMySql:SetOrder( cSort )
            if n > 0
               ::oBrw:oMySql:GoTo( n )
            else
               ::oBrw:oMySql:Seek( uVal, Token( ::cSortOrder, nil, 1 ), 1, ::oBrw:oMySql:LastRec(), .t., .t. )
            endif
            // note: seek is not working in the descending order
         else
            ::oBrw:oMysql:cSort := cSort
         endif

      elseif lAnd( ::oBrw:nDataType, DATATYPE_ODBF ) .and. ValType( ::cSortOrder ) == 'C'

         if ::oBrw:oDbf:IsKindOf( "TDATABASE" )

            DEFAULT cOrdBag   := ::oBrw:oDbf:IndexBagName()

            if ValType( cOrdBag ) == 'C'
               cOrdBag        := Upper( cOrdBag )
            endif

            if ::oBrw:oDbf:SetOrder() == Upper( ::cSortOrder )
               if !Empty( ::cOrder ) .and. ::oBrw:oDbf:IndexBagName() == cOrdBag
                  ::oBrw:oDbf:OrdDescend( nil, nil, ::cOrder == 'A' )
                  ::cOrder       := If( ::cOrder == 'A', 'D', 'A' )
                  lSorted        := .t.
               else
                  ::oBrw:oDbf:SetOrder( ::cSortOrder, cOrdBag )
                  lSorted        := .t.
                  ::oBrw:cOrders := ' '
                  ::cOrder       := 'A'
               endif
            else
               ::oBrw:oDbf:SetOrder( ::cSortOrder, cOrdBag )
               lSorted  := .t.
               ::oBrw:cOrders     := " "
               ::cOrder           := 'A'
            endif
         elseif ::oBrw:oDbf:IsKindOf( "TPQQUERY" )
            uVal     := FWPG_QuerySetOrder( ::oBrw:oDbf, ::cSortOrder, ::cOrder == "A" )
            lSorted  := ( uVal == "A" .or. uVal == "D" )
            if lSorted
               ::oBrw:cOrders := " "
               ::cOrder    := uVal
            endif
         else
            if __ObjHasMethod( ::oBrw:oDbf, 'ORDDESCEND' ) .and. ;
               ( ::cOrder == 'A' .or. ::cOrder == 'D' )
               ::oBrw:oDbf:OrdDescend( nil, nil, ::cOrder == 'A' )
               ::cOrder          := If( ::cOrder == 'A', 'D', 'A' )
               lSorted           := .t.

            elseif ! Eq( ::oBrw:oDbf:SetOrder(), ::cSortOrder )
               ::oBrw:oDbf:SetOrder( ::cSortOrder, cOrdBag )
               lSorted  := .t.
               ::oBrw:cOrders     := ' '
               ::cOrder           := 'A'
            endif
         endif
      elseif ValType( ::oBrw:cAlias ) == 'C' .and. ValType( ::cSortOrder ) == 'C'

         cSort         := ( ::oBrw:cAlias )->( OrdSetFocus() )   // Save the present value

         DEFAULT cOrdBag := ( ::oBrw:cAlias )->( OrdBagName() )

         if (::oBrw:cAlias)->( OrdSetFocus() ) == Upper( ::cSortOrder )
            if !Empty( ::cOrder ) .and. Upper( cOrdBag ) == ( ::oBrw:cAlias )->( OrdBagName() )
               (::oBrw:cAlias)->( OrdDescend( , , ! OrdDescend() ) )
               if ::oBrw:lSQLRDD
                  M->u__bm       := ::oBrw:BookMark
                  ::oBrw:GoTop()
                  ::oBrw:BookMark   := M->u__bm
               endif
               ::cOrder          := If( ( ::oBrw:cAlias )->( OrdDescend() ), 'D', 'A' )
            else
               (::oBrw:cAlias)->( OrdSetFocus( ::cSortOrder, cOrdBag ) )
               ::cOrder          := 'A'
            endif
            lSorted              := .t.

         else

            (::oBrw:cAlias)->( OrdSetFocus( ::cSortOrder, cOrdBag ) )
            lSorted   := .T.
            ::oBrw:cOrders     := ' '
            ::cOrder           := If( ( ::oBrw:cAlias )->( OrdDescend() ), 'D', 'A' )

         endif

      endif

      ::oBrw:nSortSecs  := SECONDS() - nSecs

   endif

   if lSorted
      if ::oBrw:lMergeVert
         AEval( ::oBrw:aCols, { |o| If( o:lMergeVert, o:WorkMergeData(), nil ) } )
      endif
      ::oBrw:Seek()
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
   if ValType( nAt ) == 'N' .and. nAt <= 0
      return .f.
   endif
   if Empty( nAt ) .or. ValType( nAt ) != 'N'
      nAt   := 1
   endif

   if Len( ::oBrw:aArrayData ) > 0

      for nFor := 1 to nLen
         if aCols[ nFor ]:nArrayCol != ::nArrayCol
            aCols[ nFor ]:cOrder := ""
         endif
      next

      uSave    := ::oBrw:aArrayData[ ::oBrw:nArrayAt ]
      if cOrder == 'A'
         ::oBrw:aArrayData := Asort( ::oBrw:aArrayData,,::oBrw:nLen, {|x,y| ACompare( x, y, nAt, ::lCaseSensitive, ::cnLocaleID ) < 0 } )
         ::cOrder     := 'D'
      else
         ::oBrw:aArrayData := Asort( ::oBrw:aArrayData,,::oBrw:nLen, {|x,y| ACompare( x, y, nAt, ::lCaseSensitive, ::cnLocaleID ) > 0 } )
         ::cOrder     := 'A'
      endif
      ::oBrw:nArrayAt   := AScan( ::oBrw:aArrayData, { |a| a == uSave } )

//      ::oBrw:Refresh()

   endif

return .t.

//---------------------------------------------------------------------------//

static function ACompare( x, y, nAt, lCaseSensitive, cnLocaleID )

   local nRet := -1
   local xVal, yVal, xType, yType
   local aType := 'ULNPDCHO'

   if ValType( x ) != 'A'
      x     := { x }
   endif
   xVal     := If( nAt <= Len( x ), x[ nAt ], nil )
   xType    := ValType( xVal )

   if ValType( y ) != 'A'
      y     := { y }
   endif
   yVal     := If( nAt <= Len( y ), y[ nAt ], nil )
   yType    := ValType( yVal )

   if xType == yType .and. xType $ 'CDLN'
      if xType == 'C' .and. ValType( cnLocaleID ) == 'N' //! Empty( cnLocaleID )
         if ValType( cnLocaleID ) == 'N'
            nRet  := CompareUniStr( cnLocaleID, xVal, yVal )
/*
         else
            nRet  := CompareUniStrEx( cnLocaleID, xVal, yVal ) // not available in bcc582
*/
         endif
         nRet     := If( nRet <= 2, 1, -1 )
      endif
      if xType == 'C' .and. ! lCaseSensitive
         xVal  := Upper( xVal )
         yVal  := Upper( yVal )
      endif
   else
      xVal  := At( xType, aType )
      yVal  := At( yType, aType )
   endif

   nRet  := If( xVal == yVal, 0, If( xVal < yVal, 1, -1 ) )

return nRet

//------------------------------------------------------------------//

METHOD ClpText() CLASS TXBrwColumn

   local uVal        := ::Value
   local cRet        := ""
   local cValType    := ValType( uVal )
   local cDeciSep

   if cValType $ "DT" .and. Year( uVal ) < 1900
      return cRet
   endif

   if !( cValType $ "LN" ) .and. Empty( uVal )
      return cRet
   endif

   do case
   case cValType == 'C'
      if ! IsBinaryData( uval )
         cRet     := StrTran( StrTran( AllTrim( uVal ), CRLF, " ; " ), Chr( 9 ), ' ' )
      endif
   case cValType $ "DT"
      if IfNil( ::cDataType, cValType ) == 'D'
         cRet     := TRANSFORM( DTOS( FW_TTOD( uVal ) ), "@R 9999-99-99" )
      elseif IfNil( ::cDataType, cValType ) == 'D'
         cRet     := TRANSFORM( TTOS( FW_DTOT( uVal ) ), "@R 9999-99-99 99:99:99" )
      endif
   case cValType == 'L'
      cRet        := If( uVal == nil, "", If( uVal, cxlTrue, cXlFalse ) )
   case cValType == 'N'
      cRet        := cValToChar( uVal )
      if '.' $ cRet .and. ( cDeciSep := ExcelSeparators()[ 1 ] ) != '.'
         cRet     := StrTran( cRet, '.', cDeciSep )
      endif
   endcase

   if Left( cRet, 1 ) == '"'
      cRet        := ' ' + cRet
   endif

return cRet

//----------------------------------------------------------------------------//

METHOD ToExcel( oSheet, nRow, nCol ) CLASS TXBrwColumn

   local uVal     := ::Value
   local aBmpPal, hBmp, hBmp2, nHeight, nWidth

   if ValType( uVal ) $ 'DT' .and. Empty( uVal )
      oSheet:Cells( nRow, nCol ):NumberFormat   := Lower( Set( _SET_DATEFORMAT ) )
      return Self
   endif

   if uVal != nil

      if ::cDataType $ 'PF'
         aBmpPal    := ::oBrw:ReadImage( uVal,, .f. )
         hBmp := aBmpPal[1]
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
               hBmp        := ResizeImg( hBmp2, nWidth, nHeight )
               DeleteObject( hBmp2 )
            endif

            GDIPLUSHBITMAPTOCLIPBOARD ( hbmp, ::obrw:hWnd  )

            oSheet:Cells( nRow, nCol ):Select()

            oSheet:Paste()
            OpenClipboard( ::oBrw:hWnd )
            EmptyClipboard()
            CloseClipboard()

         endif
         DeleteObject( hBmp )
      else
         if ValType( uVal ) == 'C' .and. IsUtf8( uVal := Trim( uVal ) )
            ::oClp:SetWideText( UTF8TOUTF16( uVal ) )
            oSheet:Cells( nRow, nCol ):Select()
            oSheet:Paste()
            ::oClp:Clear()
         else
            if ValType( uVal ) $ 'DT' .and. Year( uVal ) < 1900
               uVal  := DToC( uVal )
            endif
            oSheet:Cells( nRow, nCol ):Value := uVal
         endif

      endif
   endif

return Self

//------------------------------------------------------------------//

METHOD Paste( cText ) CLASS TXBrwColumn

   local uNew, cType

   if ::cDataType $  'CFM'
      ::VarPut( Trim( cText ) )
   else
      uNew        := uCharToVal( cText, @cType )
      if uNew != nil
         if ::cDataType == nil .or. ::cDataType = "U" .or. ::cDataType == cType
            ::VarPut( uNew )
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
      uVal  := If( ::bMergeValue == nil, ::Value(), Eval( ::bMergeValue, Self ) )
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

METHOD OnError(...) CLASS TXBrwColumn

   local uRet, e
   local cMessage    := __GetMessage()
   local aParams     := HB_AParams()
   local uParam1     := If( Empty( aParams ), nil, aParams[ 1 ] )
   local lAssign     := .f.

   if Left( cMessage, 1 ) == '_'
      lAssign     := .t.
      cMessage    := Substr( cMessage, 2 )
   endif

   if HB_HHasKey( ::hCargo, cMessage )
      if lAssign
         ::hCargo[ cMessage ] := uParam1
         uRet  := ::hCargo[ cMessage ]
      else
         if ValType( uRet := ::hCargo[ cMessage ] ) == 'B'
            AIns( aParams, 1, Self, .t. )
            uRet  := HB_ExecFromArray( uRet, aParams )
         endif
      endif
   else
       _ClsSetError( _GenError( If( lAssign, 1005, 1004 ), ::ClassName(), cMessage ) )
   endif

return uRet

//----------------------------------------------------------------------------//
// Support functions for TXBrwColumn
//----------------------------------------------------------------------------//

#ifdef UNUSED

static function GetZeroZeroClr( hDC, hBmp )

    local hDCMem, hOldBmp, nZeroZeroClr

    hDCMem = CreateCompatibleDC( hDC )
    hOldBmp = SelectObject( hDCMem, hBmp )
    nZeroZeroClr = GetPixel( hDCMem,0,0)
    SelectObject( hDCMem, hOldBmp )
    DeleteDC( hDCMem )

return nZerozeroClr

#endif

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

static function EQ( uFirst, uSecond, lExact, lCaseSensitive )

   local   c, lRet := .f.

   DEFAULT lExact := .t., lCaseSensitive := .f.

   TRY
      uFirst   := xEval( uFirst )
   CATCH
   END

   TRY
      uSecond  := xEval( uSecond )
   CATCH
   END

   if ( C := valtype( uFirst ) ) == valtype( uSecond )
      if c == 'C'
         if lExact
            if lCaseSensitive
               lRet     := ( AllTrim( uFirst ) == AllTrim( uSecond ) )
            else
               lRet     := ( Upper( AllTrim( uFirst ) ) == Upper( AllTrim( uSecond ) ) )
            endif
         else
            lRet        := Upper( AllTrim( uFirst ) ) = Upper( AllTrim( uSecond ) )
         endif
      else
         lRet  := ( uFirst == uSecond )
      endif
   endif

return lRet

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

   if Right( cText, 1 ) == Chr(10)
      cText    := Left( cText, Len( cText ) - 1 )
   endif
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
                     lCell, lLines, aRows, uBack, cBckMode, bClass, lTransparent,;
                     lNoBorder, cVarName, c2KStyle )

   local oBrw, n, i, oCol, oClass

   DEFAULT lTransparent := .F.
   DEFAULT oWnd := If( GetWndDefault() == nil, TWindow():New(), GetWndDefault() )

   // This function is intended only to support command syntax
   // and not to be used directly in application program

   if ValType( bClass ) == 'B'
      oClass      := Eval( bClass )
   endif
   if oClass != nil .and. oClass:IsKindOf( 'TXBROWSE' )
      oBrw        := oClass:New( oWnd )
   else
      oBrw        := TXBrows():New( oWnd )
      if oClass != nil .and. oClass:IsKindOf( 'TXBRWCOLUMN' )
         oBrw:bColClass := bClass
      endif
   endif

   if ValType( aCols ) == 'A' .and. Len( aCols ) == 1 .and. ValType( aCols[ 1 ] ) == 'C' .and. AllTrim( aCols[ 1 ] ) == "*"
      lAddCols    := .t.
      aCols       := nil
   endif
   if ValType( aSort ) == 'A' .and. Len( aSort ) == 1 .and. ValType( aSort[ 1 ] ) == 'C' .and. Upper( AllTrim( aSort[ 1 ] ) ) == "AUTO"
      lAutoSort   := .t.
      aSort       := nil
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

   if aCols != nil
      aCols          := ASize( ArrTranspose( aCols ), 6 )
   endif

   XbrwSetDataSource( oBrw, cDataSrc, lAddCols, lAutoSort, ;
      If( aCols == nil, nil, aCols[ 1 ] ), aRows, aHeaders, bChange  )

   if c2KStyle != nil
      oBrw:SetStyle( If( c2KStyle == "FLAT", -1, Val( c2KStyle ) ) )
   endif

   DEFAULT oBrw:bChange := bChange

   DEFAULT aHeaders := {}, aPics := {}, aColSizes := {}, aSort := {}

   if aCols != nil
      aHeaders       := ArrMerge( aCols[ 2 ], aHeaders )
      aPics          := ArrMerge( aCols[ 3 ], aPics )
      aColSizes      := ArrMerge( aCols[ 4 ], aColSizes )
      aJust          := ArrMerge( aCols[ 5 ], aJust )
      aSort          := ArrMerge( aCols[ 6 ], aSort )
      //
      AEval( oBrw:aCols, { |o,i| If( Empty( o:cExpr ), o:cExpr := cValToChar( aCols[ 1, i ] ), nil ) },,Len( aCols[ 1 ] ) )
   endif

   if ! Empty( aFlds )
      for n := 1 to Len( aFlds )
         oBrw:AddCol():bEditValue   := aFlds[ n ]
      next
   endif

   for i := 1 to Len( oBrw:aCols )
      oCol  := oBrw:aCols[ i ]
      if Len( aPics ) >= i .and. aPics[ i ] != nil
         if ValType( aPics[ i ] ) == 'A'
            oCol:SetCheck( aPics[ i ] )
         elseif !Empty( aPics[ i ] )
            oCol:cEditPicture := aPics[ i ]
         endif
      endif
      if Len( aHeaders ) >= i .and. aHeaders[ i ] != nil
        oCol:cHeader   := cValToChar( aHeaders[ i ] )
      endif
      if Len( aColSizes ) >= i
         if .F. //aColSizes[ i ] != nil .and. aColSizes[ i ] < 0
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

   if oFont != nil
      oBrw:SetFont( oFont )
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
   oBrw:lDrag         := lDesign

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
         if nWidth <= 0
            oBrw:nRightMargin := -nWidth
            if oWnd:IsKindOf( "TDIALOG" ) .and. Empty( oWnd:hWnd ) .and. !oWnd:lTruePixel
               oBrw:nRightMargin *= 2
            endif
         else
            oBrw:nRight     := oBrw:nLeft + nWidth - 1
         endif
      endif

      if nHeight != nil
         if nHeight <= 0
            oBrw:nBottomMargin    := -nHeight
            if oWnd:IsKindOf( "TDIALOG" ) .and. Empty( oWnd:hWnd ) .and. !oWnd:lTruePixel
               oBrw:nBottomMargin *= 2
            endif
         else
            oBrw:nBottom    := oBrw:nTop + nHeight - 1
         endif
      endif

      if lNoBorder == .t. .and. lAnd( oBrw:nStyle, WS_BORDER )
         oBrw:nStyle       -= WS_BORDER
      endif
      if lTransparent
         oBrw:lTransparent := .t.
      endif
      oBrw:lUpdate      := lUpdate
   endif

   oBrw:cVarName = cVarName

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

function XbrwSetDataSource( oBrw, uDataSrc, lAddCols, lAutoSort, aCols, aRows, aHeaders, bChange  )

   // This function is internally used by FWH libraries
   // Not advised for use in application programs

   local cType    := ValType( uDataSrc ), tmp, lSet := .f.

   if ! Empty( aCols )
      lAddCols    := .t.
   endif

   do case
   case cType == 'C'

      if Select( uDataSrc ) > 0
         oBrw:cAlias    := uDataSrc
         oBrw:nDataType := DATATYPE_RDD
         if .t.   // lAddCols .or. ! Empty( aCols )   // 21 sep 2013
            oBrw:SetRDD( lAddCols, lAutoSort, aCols, aRows )
         elseif ! Empty( aRows )
            oBrw:SetRDD( .f., lAutoSort, nil, aRows )
         endif
         oBrw:bChange   := bChange
      endif

   case cType == 'A'
      oBrw:nDataType    := DATATYPE_ARRAY
      oBrw:aArrayData   := uDataSrc
      if lAddCols .or. ! Empty( aCols )
         oBrw:SetArray( uDataSrc, lAutoSort, nil, aCols )
      else
         oBrw:SetArray( uDataSrc, nil, nil, .f. )
      endif
      oBrw:bChange   := bChange

   case cType == 'H'
      oBrw:aArrayData   := uDataSrc
      oBrw:nDataType    := DATATYPE_ARRAY
      oBrw:SetArray( uDataSrc, nil, nil, .t. )
      if bChange != nil
         oBrw:bChange   := bChange
      endif

   case cType == 'O'

      if IsRecordSet( uDataSrc )
         oBrw:nDataType := DATATYPE_ADO
         oBrw:oRs       := uDataSrc
         if .t.   // lAddCols .or. ! Empty( aCols )   // 21 sep 2013
            oBrw:SetADO( uDataSrc, lAddCols, lAutoSort, aCols )
         endif
         lSet  := .t.
      elseif IsXlRange( uDataSrc )
         oBrw:nDataType := DATATYPE_EXCEL
         oBrw:oRs       := uDataSrc
         oBrw:SetExcelRange( uDataSrc, Empty( aHeaders ), aCols )
         lSet  := .t.
      elseif uDataSrc:ClassName() == "TOLEAUTO" .and. ! Empty( tmp := GetOleProperties( uDataSrc ) )
         oBrw:SetArray( tmp, .f., nil, { 1, 2, 3 } )
         oBrw:cHeaders  := { "Num", "Name", "Value" }
         oBrw:lReadOnly := .t.
         lSet  := .t.
      elseif __ObjHasMethod( uDataSrc, 'ISKINDOF' )
         if uDataSrc:IsKindOf( 'TMYSQLQUERY' )
            oBrw:nDataType := DATATYPE_MYSQL
            oBrw:oMysql       := uDataSrc
            if .t.   // lAddCols .or. ! Empty( aCols )   // 21 sep 2013
               oBrw:SetMysql( uDataSrc, lAddCols, lAutoSort, aCols )
            endif
            oBrw:bChange   := bChange
            lSet  := .t.
         elseif  uDataSrc:IsKindOf( 'TDOLPHINQRY' )
            oBrw:nDataType := DATATYPE_MYSQL
            oBrw:oMysql       := uDataSrc
            if .t.      //lAddCols .or. ! Empty( aCols )    // 21 sep 2013
               oBrw:SetDolphin( uDataSrc, lAddCols, lAutoSort, aCols )
            endif
            oBrw:bChange   := bChange
            lSet  := .t.

         elseif  uDataSrc:IsKindOf( 'TPQQUERY' )
            oBrw:nDataType := DATATYPE_ODBF
            oBrw:oDbf      := uDataSrc
            oBrw:SetPostGre( uDataSrc, lAddCols, lAutoSort, aCols )
            oBrw:bChange   := bChange
            lSet  := .t.

         elseif uDataSrc:IsKindOf( "TLINKLIST" )
            oBrw:SetTree( uDataSrc, , bChange, If( aCols == nil, lAddCols, aCols ) )
            lSet  := .t.

         elseif uDataSrc:IsKindOf( "TSTRUCT" )
            oBrw:SetArray( aObjStructure( uDataSrc ), .f., nil, { 1, 2 } )
            oBrw:aCols[ 1 ]:cHeader := 'Member'
            WITH OBJECT oBrw:aCols[ 2 ]
               :cHeader    := 'Value'
               :nEditType  := EDIT_GET
               :bOnPostEdit:= { |o,x,n| If( n != VK_ESCAPE, ;
                  ( OSend( uDataSrc, '_' + oBrw:aRow[ 1 ], x ),    ;
                    o:Value := OSend( uDataSrc, oBrw:aRow[ 1 ] ) ), ;
                  nil ) }
            END
            oBrw:lFastEdit := .t.
            oBrw:bChange   := bChange
            lSet = .t.

         elseif XBrowsableObj( uDataSrc )
            oBrw:SetoDbf( uDataSrc, aCols, lAutoSort, lAddCols, aRows )
            oBrw:bChange   := bChange
            lSet  := .t.
         endif
      endif // __objHasMethod( 'iskindof' )

      if ! lSet
         // Object Inspector
         oBrw:SetArray( aObjData( uDataSrc ), .f., nil, { 1, 2, 3 } )
         oBrw:aCols[ 1 ]:cHeader := 'Num'
         oBrw:aCols[ 1 ]:nWidth := 40
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
         oBrw:bChange   := bChange
         lSet  := .t.
      endif
   otherwise
      // can not set xbrowse
   endcase

return nil

//----------------------------------------------------------------------------//

static function IsRecordSet( o )

   local lRecSet  := .f.
   local u

   // logic replaced on 2014-07-04

   if o:ClassName() == "TOLEAUTO"
      TRY
         u  := o:Fields:Count()
         TRY
            u  := o:RecordCount()
            lRecSet  := .t.
         CATCH
         END
      CATCH
      END
   endif

return lRecSet

//----------------------------------------------------------------------------//

static function IsXlRange( o )

   local lXlRange  := .f.

#ifdef __XHARBOUR__
   lXlRange  := ( o:IsDerivedFrom( "TOLEAUTO" ) .and. "EXCEL" $ Upper( o:cClassName ) )
#else
   local u

   TRY
      u  := o:Cells(1,1):Value
      lXlRange  := .t.
   CATCH
   END
#endif

return lXlRange

//----------------------------------------------------------------------------//

static function GetOleProperties( o )

   local aProp    := {}
   local nProp, oProp, i

   TRY
      nProp    := o:Properties:Count()
      oProp    := o:Properties
   CATCH
      TRY
         nProp    := o:Count()
         oProp    := o
      CATCH
      END
   END
   if nProp != nil .and. nProp > 0
      for i := 0 to nProp - 1
         AAdd( aProp, { i, oProp:Item( i ):Name, oProp:Item( i ):Value } )
      next
   endif

return aProp

//----------------------------------------------------------------------------//

function XBrowsableObj( oObj )

   return ;
   __ObjHasMethod( oObj, 'SETXBROWSE' ) .or. ;
   ( AScan( { 'GOTOP', 'GOBOTTOM', 'BOF', 'EOF', 'SKIPPER', 'RECCOUNT' }, ;
          { |c| ! __ObjHasMethod( oObj, c ) } ;
        ) == 0 .and. ;
     ( __ObjHasMethod( oObj, 'BOOKMARK' ) .or. ;
        (__ObjHasMsg( oObj, 'RECNO' ) .and. __ObjHasMethod( oObj, 'GOTO' ) ) ;
     ) ;
   )

//------------------------------------------------------------------//

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

#define MEMBER_NAME   1

static function aObjStructure( obj )
   local n, aData := {}

   for n = 1 to len( obj:aMembers )
      AAdd( aData, { obj:aMembers[ n ][ MEMBER_NAME ], obj:GetMember( n ) } )
   next

return aData

//------------------------------------------------------------------//

function XbrJustify( oBrw, aJust )
return   ( oBrw:aJustify := aJust )

//--------------------------------------------------------------------------//

function xbrNumFormat(...)
return   HB_ExecFromArray( "FWNumFormat", HB_AParams() )

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

   Eval( ::oBrw:bBookMark, ::nRecNo )
   if ::oBrw:Lock()
      for n := 1 to Len( ::aHeaders )
         if ::aOriginals[ n ] != ::aValues[ n ]
            oCol     := ::oBrw:oCol( ::aHeaders[ n ] )
            if oCol:bOnPostEdit == nil
               if oCol:bEditValue != nil
                  oCol:Value := ::aValues[ n ]
               endif
            else
               Eval( oCol:bOnPostEdit, oCol, ::aValues[ n ], 13 )
            endif
         endif
      next n
      if ::bSave != nil
         Eval( ::bSave, Self )
      endif
      Eval( ::oBrw:bUnlock())
      if ::oBrw:bOnRowLeave != nil
         Eval( ::oBrw:bOnRowLeave )
      endif
      lSaved   := .t.
      ACopy( ::aValues, ::aOriginals )
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

//function ContrastColor( hDC, nCol, nRow, nWidth, nHeight, nDefClr )
function ContrastColor( hDC, oRect, nDefClr )

   local nClr, nLuma, nLuma0, nContrast, n, k
   local nRow

   DEFAULT nDefClr  := CLR_BLACK
   nContrast        := nDefClr

//   nRow     += Int( nHeight / 2 )
   nRow     := Int( oRect:nTop + oRect:nHeight / 2 )
   nLuma    := 0
   k        := 0
//   for n    := Int( nCol ) + 10 to nCol + nWidth step 10
   for n    := Int( oRect:nLeft ) + 10 to oRect:nRight step 10
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

static function CreateColorBrush( uClr )

   if ValType( uClr ) == 'A'
      uClr     := uClr[ 1 ][ 2 ]
   endif

   if uClr == nil
      return GetStockObject( NULL_BRUSH )
   endif

return CreateSolidBrush( uClr )

//------------------------------------------------------------------//

static function CreateLinePen( oBrw, nLineStyle, nPenStyle, nWidth, nColor )

   local hPen

   DEFAULT  nLineStyle     := LINESTYLE_BLACK,  ;
            nPenStyle      := PS_SOLID,         ;
            nWidth         := 1,                ;
            nColor         := CLR_BLACK

   do case
   case nLineStyle == LINESTYLE_BLACK .or. nLineStyle == LINESTYLE_RAISED .or. nLineStyle == LINESTYLE_INSET
      hPen := CreatePen( If( nColor == nil, PS_NULL, PS_SOLID ), nWidth, nColor )
   case nLineStyle == LINESTYLE_DARKGRAY
      hPen := CreatePen( PS_SOLID, nWidth, CLR_GRAY )
   case nLineStyle == LINESTYLE_FORECOLOR
      hPen := CreatePen( PS_SOLID, nWidth, oBrw:nClrText )
   case nLineStyle == LINESTYLE_LIGHTGRAY
      hPen := CreatePen( PS_SOLID, nWidth, CLR_LIGHTGRAY )
   otherwise
      hPen  := 0
   end case

return hPen

//----------------------------------------------------------------------------//

function DrawPen( hDC, aFromRC, aUptoRC, hPen )

   if ! Empty( hPen )
      MoveTo( hDC, aFromRC[ 2 ], aFromRC[ 1 ] )
      LineTo( hDC, aUptoRC[ 2 ], aUptoRC[ 1 ], hPen )
   endif

return nil

//------------------------------------------------------------------//

function DrawHorz( hDC, nRow, nLeft, nRight, hPen )
return   DrawPen(  hDC, { nRow, nLeft }, { nRow, nRight }, hPen )

//------------------------------------------------------------------//

function DrawVert( hDC, nCol, nTop, nBottom, hPen )
return   DrawPen(  hDC, { nTop, nCol }, { nBottom, nCol }, hPen )

//------------------------------------------------------------------//

function SetKinetic( lOnOff )

   local lOldStatus

   static lStatus := .T.

   lOldStatus = lStatus

   if PCount() == 1 .and. ValType( lOnOff ) == "L"
      lStatus = lOnOff
   endif

return lOldStatus

//----------------------------------------------------------------------------//

static function ArrMerge( aArray1, aArray2 )

   local n, nLen

   if Empty( aArray1 )
      aArray1    := aArray2
   elseif ! Empty( aArray2 )
      if Len( aArray1 ) < Len( aArray2 )
         ASize( aArray1, Len( aArray2 ) )
      endif
      AEval( aArray2, { |u,i| If( u == nil, , aArray1[ i ] := u ) } )
   endif

return aArray1

//----------------------------------------------------------------------------//

static function XbrLbxLookUp( uVal, aBound, aText, lBlank )

   local uRetVal
   local tmp, nAt

   if ! Empty( aText ) .and. ValType( aText[ 1 ] ) == 'A'
      tmp      := AClone( aText )
      ASize( aText,  0 )
      if aBound == nil
         aBound   := {}
      else
         ASize( aBound, 0 )
      endif
      AEval( tmp, { |a| AAdd( aBound, a[ 1 ] ), AAdd( aText, a[ 2 ] ) } )
   endif

   DEFAULT lBlank := .t.
   uRetVal  := If( lBlank, Blank( aText[ 1 ] ), cValToChar( uVal ) )

   if ! Empty( uVal )
      if ValType( uVal ) == 'C'
         uVal     := Upper( uVal )
         nAt      := AScan( aBound, { |c| Upper( c ) == uVal } )
      else
         nAt      := AScan( aBound, uVal )
      endif
      if nAt > 0
         uRetVal  := aText[ nAt ]
      endif
   endif

return uRetVal

//----------------------------------------------------------------------------//
// ADO Support Funcs
//----------------------------------------------------------------------------//

/*
static function adoIsEmptyRow( oRs )

   local lEmpty := .t.
   local n, nFlds := oRs:Fields:Count() - 1

   for n := 0 to nFlds
      if ! ( oRs:Fields( n ):Value == nil )
         lEmpty   := .f.
         exit
      endif
   next

return lEmpty
*/

//----------------------------------------------------------------------------//

function XbrAdoSave( oBrw )

   local lSaved   := .f.
   local oRs      := oBrw:oRs
   local lCanResync  := oBrw:lRsCanResync
   local tmp

   if oRs:LockType > 1 // not readonly
      TRY
         oRs:Update()
         oRs:ReSync( 1, 2 )
         lSaved   := .t.
      CATCH
         oRs:CancelUpdate()
         tmp   := oRs:AbsolutePosition
         if lCanResync
            TRY
               oRs:Resync( 1, 2 )
            CATCH
               oRs:ReQuery()
               oRs:AbsolutePosition := Max( 1, Min( tmp, oRs:RecordCount() ) )
               oBrw:Refresh()
            END
         endif
      END
   endif

return lSaved

//----------------------------------------------------------------------------//

static function XBrAdoDelete( oBrw )

   local oRs   := oBrw:oRs
   local n

   WITH OBJECT oRs
      if :RecordCount() > 0
         n  := :AbsolutePosition
         TRY
            :Delete()
         CATCH
            :CancelUpdate()
            :ReQuery()
         END
         if :RecordCount() > 0
            :AbsolutePosition := Max( 1, Min( n, :RecordCount() ) )
         endif
      endif
   END

return nil

//----------------------------------------------------------------------------//

static function SeekDate( cSeek, dDefault )  // convert imcomplete seek val to nearest date

   local dSeek
   local nLen

   if IsDigit( SubStr( cSeek, 3 ) )
      cSeek    := CharOnly( "0123456789", cSeek )
      if IsDigit( SubStr( cSeek, 3 ) )
         if ( nLen := Len( cSeek ) ) >= 8
            cSeek    := Left( cSeek, 8 )
         elseif nLen >= 6
            cSeek    := Left( cSeek, 6 ) + "01"
         elseif nLen >= 4
            cSeek    := Left( cSeek, 4 ) + "0101"
         else
            cSeek    += "00101"
         endif
      endif
      dSeek          := SToD( cSeek )
   elseif Len( cSeek ) > 6
      cSeek       := PadR( cSeek, 10, '0' )
      dSeek       := CToD( cSeek )
   endif

return If( Empty( dSeek ), dDefault, dSeek )

//----------------------------------------------------------------------------//

static function d2ado( dDate )

   if Empty( dDate ) .or. dDate < {^ 1900/01/01 }
      return "#1900-01-01#"
   endif

return '#' + TRANSFORM( DTOS( dDate ), "@R XXXX-XX-XX" ) + '#'

//----------------------------------------------------------------------------//

function XbrSQLRDDmode( nSet )      // For future use

   static nMode := 0

   local nOldMode    := nMode

   if ValType( nSet ) == 'N'
      nMode    := nSet
   endif

return nOldMode

//----------------------------------------------------------------------------//

function XbrGetSelectAll( uNew )  // uNew : .t. / .f. / nil

   static lSet

   local lPrevSet
/*
   if lSet == nil
      lSet  := !FW_SetUnicode()
   endif
*/
   lPrevSet := lSet

   if PCount() > 0 .and. ( uNew == nil .or. ValType( uNew ) == 'L' )
      lSet     := uNew
   endif

return lPrevSet

//----------------------------------------------------------------------------//

function XbrHexEdit( cVal, cTitle, lReadOnly )

   local cTmp, cUpper, nLen, nLines, hFile
   local oDlg, oBrw, oFont, lEdited := .f.
   local cFile

   if Len( cVal ) <= 255 .and. File( cVal )
      cFile    := cVal
      cVal     := MemoRead( cFile )
   endif

   cTmp     := cVal
   cUpper   := Upper( cVal )
   nLen     := Len( cTmp )
   nLines   := Ceiling( nLen / 16 )

   DEFAULT cTitle := IfNil( cFile, "HEXEDIT" ), lReadOnly := .f.

   DEFINE FONT oFont NAME "Lucida Console" SIZE 0,-14
   DEFINE DIALOG oDlg SIZE 700,400 PIXEL FONT oFont TITLE cTitle ;
      STYLE nOR( DS_MODALFRAME, WS_POPUP, WS_CAPTION, WS_SYSMENU, WS_MAXIMIZEBOX, WS_MINIMIZEBOX, WS_THICKFRAME )

   @ 30,10 XBROWSE oBrw SIZE -10,-30 PIXEL OF oDlg DATASOURCE {} NOBORDER FOOTERS

   ADD TO oBrw DATA RangeRepl( Chr(0), Chr(31), SubStr( cTmp, oBrw:nArrayAt * 16 - 15, 16 ), '.' ) ;
       HEADER "Text"
   ADD TO oBrw DATA STRTOHEX( SubStr( cTmp, oBrw:nArrayAt * 16 -15, 16 ) ) ;
      HEADER "HexChar" PICTURE "@R" + Replicate( " !!", 16 )

   WITH OBJECT oBrw
      :bSeek            := { |c,nAt| If( Empty( c ), nAt := 1, nAt := At( Upper( c ), cUpper ) ), ;
                           If( nAt > 0, oBrw:nArrayAt := Int( nAt / 16 ) + 1, nil ), ;
                           nAt > 0 }
      :bKeyCount        := { || nLines }
      :nHeadStrAligns   := AL_CENTER
      :nColDividerStyle := 1
      :nStretchCol      := 1
      WITH OBJECT :aCols[ 2 ]
         :nEditType     := If( lReadOnly, EDIT_NONE, EDIT_GET )
         :bEditValid    := { |o| Len( HEXTOSTR( CharRem( ' ', o:VarGet() ) ) ) == 16  }
         :bClrEdit      := { || { CLR_BLACK, CLR_YELLOW } }
         :bOnPostEdit   := { |o,x,n| If( n == VK_ESCAPE, nil, ( ;
                              x := HEXTOSTR( CharRem( ' ', x ) ), ;
                              If( x == o:Value, nil, ( cTmp := ;
                                 Left( cTmp, oBrw:nArrayAt * 16 - 16 ) + ;
                                 x + SubStr( cTmp, oBrw:nArrayAt * 16 + 1 ), ;
                                 oDlg:AEvalWhen() ) ;
                                 ) ) ) }
      END

      :bRecSelHeader    := { || "LineHex" }
      :bRecSelData      := { |o| NUMTOHEX( o:nArrayAt, 8 ) }
      :bRecSelFooter    := { |o| NUMTOHEX( o:nLen, 8 ) }
      :nRecSelWidth     := "BBBBBBBBB"

      //
      :CreateFromCode()
   END

   @  10, 10 BUTTON "Save"   SIZE 40,12 PIXEL OF oDlg WHEN cTmp != cVal ACTION ( oDlg:End() )
   @  10, 60 BUTTON "Cancel" SIZE 40,12 PIXEL OF oDlg ACTION ( cTmp := cVal, oDlg:End() )
   @  11,110 SAY oBrw:oSeek VAR oBrw:cSeek SIZE 100,10 PIXEL OF oDlg COLOR CLR_BLACK,CLR_YELLOW

   oDlg:bPainted := { || oDlg:Box( 20,219,42,421 ) }

   ACTIVATE DIALOG oDlg CENTERED
   RELEASE FONT oFont

   lEdited    := !( cVal == cTmp )
   if lEdited
      cVal     := cTmp
      if cFile != nil
         hFile    := fCreate( cFile, 0 )
         fWrite( hFile, cVal )
         fClose( hFile )
      endif
   endif

return lEdited

//----------------------------------------------------------------------------//

function XBrImageEdit( cBuf, cTitle, lReadOnly )

   local cTmp        := cBuf
   local hBitmap, hBmp
   local oDlg, oImage, oFont, cFile
   local oClp, uClip, lEdited := .f.

   DEFAULT cTitle := "IMAGE", lReadOnly := .f.

   DEFINE FONT oFont NAME "TAHOMA" SIZE 0,-12
   DEFINE DIALOG oDlg SIZE 600,400 PIXEL FONT oFont

   if !lReadOnly
      DEFINE CLIPBOARD oClp OF oDlg FORMAT BITMAP
      uClip    := oClp:GetBitmap()
   endif

   @ 10,10 IMAGE oImage SIZE 280,160 PIXEL OF oDlg NOBORDER
   oImage:LoadFromMemory( cTmp, , 320 )

   if lReadOnly

      @ 180,250 BUTTON "Close" SIZE 40,12 PIXEL OF oDlg ACTION oDlg:End()

   else

      @ 180, 10 BUTTON "Open"   SIZE 40,12 PIXEL OF oDlg ACTION ( ;
         If( Empty( cFile := cGetFile( "Image File (*.bmp,jpg,png)|*.bmp;*.jpg;*.jpeg;*.png|", ;
                     CurDir() ) ), nil, ;
           ( cTmp := MemoRead( cFile ), oImage:LoadFromMemory( cTmp, , 320 ), ;
             oImage:Refresh(), oDlg:AEvalWhen() ) ) ;
      )
      @ 180, 55 BUTTON "Paste"   SIZE 40,12 WHEN ! Empty( uClip ) PIXEL OF oDlg ;
         ACTION ( cTmp := BmpToStr( uClip ),  oClp:Clear(), uClip := nil, ;
                  oImage:LoadFromMemory( cTmp, , 320 ), oImage:Refresh(), ;
                  oDlg:AEvalWhen() )

      @ 180,160 BUTTON "Undo"   SIZE 40,12 WHEN !( cTmp  == cBuf ) PIXEL OF oDlg ;
         ACTION ( cTmp := cBuf, oImage:LoadFromMemory( cTmp, , 320 ), oImage:Refresh(), ;
                  oDlg:AEvalWhen() )
      @ 180,205 BUTTON "Save"   SIZE 40,12 WHEN !( cTmp  == cBuf ) PIXEL OF oDlg ACTION oDlg:End()
      @ 180,250 BUTTON "Cancel" SIZE 40,12 PIXEL OF oDlg ACTION ( cTmp := cBuf, oDlg:End() )

   endif

   if ! lReadOnly
      oDlg:bGotFocus    := { || uClip := oClp:GetBitmap(), oDlg:AEvalWhen() }
   endif

   ACTIVATE DIALOG oDlg CENTERED ;
      ON RIGHT CLICK ( oImage:LoadFromMemory( memoread( "everest.jpg" ), , 320 ), oImage:Refresh() )

   RELEASE FONT oFont
   if oClp != nil
      oClp:End()
   endif

   if ! lReadOnly
      lEdited  := !( cBuf == cTmp )
      if lEdited
         cBuf  := cTmp
      endif
   endif

return lEdited

//----------------------------------------------------------------------------//

function XbrEditMemo( nRow, nCol, oCol, nKey, cTitle )

   local lReadOnly      := ! oCol:lEditable
   local cVal           := IfNil( oCol:Value, "" )
   local lBinaryData    := IsBinaryData( cVal )
   local lText          := ( ! lBinaryData .and. ! IsRTF( cVal ) .and. ! IsGTF( cVal ) )
   local lEdited        := .f.

   DEFAULT cTitle       := oCol:cHeader

   if IsRtf( cVal ) .or. IsGtf( cVal ) .or. ! lBinaryData
      lEdited     := MemoEdit( @cVal, cTitle, nil, nil, nil, nil, ;
                               oCol:lRTF, nil )
   elseif IsImageData( cVal )
      lEdited     := XbrImageEdit( @cVal, cTitle, lReadOnly )
   else
      lEdited     := XBrHexEdit( @cVal, cTitle, lReadOnly )
   endif

   lEdited     := !lReadOnly .and. lEdited .and. ! ( cVal == oCol:Value )

return If( lEdited, cVal, nil )

//----------------------------------------------------------------------------//

function CalcLineWH( oWnd, cLine )

   local aRect    := GetClientRect( oWnd:hWnd )
   local h,r

   h  := DrawTextEx( oWnd:GetDC(), cLine, aRect, DT_SINGLELINE + DT_CALCRECT, nil, nil, @r )
   oWnd:ReleaseDC()

return { r - aRect[ 2 ], h }

//----------------------------------------------------------------------------//

