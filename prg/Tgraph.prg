// TGraph 2.0, FiveWin Graphics without vbx!
// Thanks to all FiveWin forum friends
// Autor: Alfredo Arteaga - 13/07/2003
// email: alfredoarteaga@terra.com.mx

#Include "FiveWin.Ch"
#Include "Constant.Ch"

#ifdef __XPP__
   #define New   _New
#endif

#Define GRAPH_TYPE_BAR   1
#Define GRAPH_TYPE_LINE  2
#Define GRAPH_TYPE_POINT 3
#Define GRAPH_TYPE_PIE   4
#Define GRAPH_TYPE_ALL   5

#Define POINT_TYPE_1     1
#Define POINT_TYPE_2     2
#Define POINT_TYPE_3     3

#Define LOGPIXELSX      88
#Define LOGPIXELSY      90

#Define CF_BITMAP        2

#Define NULL_PEN         8
#Define NULL_BRUSH       5

#Define SERIE_VALUES     1
#Define PERIOD_VALUES    2

CLASS TGraph FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA    l3D             // Show 3D
   DATA    lxGrid          // Show Grid
   DATA    lyGrid          // Show Grid
   DATA    lDotted         // Grid Dotted
   DATA    lxVal           // Show xValues
   DATA    lyVal           // Show yValues
   DATA    nBarD           // Deep bar
   DATA    lTitle          // Show Title
   DATA    lLegends        // Show Legends
   DATA    nType           // Graph Type
   DATA    cTitle          // Graph Title
   DATA    cPicture        // Mask values
   DATA    aSeries         // Series
   DATA    aData           // Data
   DATA    aSTemp          // Series
   DATA    aDTemp          // Data
   DATA    aYVals          // yValues
   DATA    aYTemp          // yValues
   DATA    aFont           // Title, xFont, yFont, Legends
                           // Subtitle, xTitle, yTitle, Values
   DATA    nClrT           // Color titles
   DATA    nClrX           // Color x labels
   DATA    nClrY           // Color y labels
   DATA    nClrL           // Color legends
   DATA    nClrV           // Color values
   DATA    nClrST          // Color subtitle
   DATA    nClrXT          // Color xTitle
   DATA    nClrYT          // Color yTitle
   DATA    nPieX           // Pie graph pos
   DATA    nPieSt          // Start pie (angle)
   DATA    nPoint          // Point type
   DATA    nBarSep         // Bar Separator
   DATA    nXRanges        // n Ranges
   DATA    nValues         // Pie values (Serie/Period)
   DATA    lViewVal        // View values
   DATA    nClr, hPen, hOldPen // Pen handles
   DATA    nPenWidth           // Graph line pen width
   DATA    lBorders        // Bar borders
   DATA    lcTitle         // Center title
   DATA    nClrGrid        // Grid color
   DATA    nClrBack        // Background color
   DATA    nClrBLeg        // Back legend color
   DATA    cBitmap         // Background bitmap
   DATA    cSubTit         // Subtitle
   DATA    cTitX           // xTitle
   DATA    cTitY           // yTitle
   DATA    nMaxVal         // Max Value
   DATA    nMinVal         // Min Value
   DATA    lPopUp          // PopUp menu
   DATA    lSelView        // Select view option
   DATA    lSelBack        // Select back option
   DATA    nLanguage       // Language (1-English, 2-Spanish, 3-...)
   DATA    aSTitle INIT {.T.,.T.,.T.,.T.}  // Shadow titles

   DATA    nTRight             // Right align
   DATA    nTLeft              // Left  align
   DATA    nTCent              // Cent  align
   DATA    oPrn                // Printer object by Galvez
   DATA    lBordLeg INIT .T.   // Legend border  by dREHER

   METHOD  New( nRow, nCol, oWnd, nWidth, nHeight, cTitle, lDesign, lPixel, ;
                l3D, lxGrid, lyGrid, lXval , lYval, lPupUp, lLegends, nType ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, cTitle, l3D, lxGrid, lyGrid, ;
                    lXval, lYval, lPupUp, lLegends, nType ) CONSTRUCTOR

   METHOD  Initiate( hDlg ) INLINE ::Super:Initiate( hDlg ), ::Default()
   METHOD  Default()
   METHOD  Paint()
   METHOD  Display()
   METHOD  DrawBar()
   METHOD  DrawBox( nTop, nLeft, nBottom, nRight, nColor )
   METHOD  DrawLine( nY, nX, nHigh, nWidth, nColor, lDotted )
   METHOD  DrawPoint()
   METHOD  DrawPie()
   METHOD  DrawPoly()
   METHOD  AddSerie()
   METHOD  SelSerie()
   METHOD  SetYVals()
   METHOD  SelPeriod()
   METHOD  Destroy()
   METHOD  End() INLINE ::Destroy()
   MESSAGE FillRect METHOD _FillRect()
   MESSAGE CreatePen METHOD _CreatePen()
   METHOD  DeletePen()
   METHOD  nMax()
   METHOD  Save2Bmp(cFile)              // save graph to bmp file
   METHOD  Copy2ClipBoard()             // to clipboard WndMove.Obj required
   METHOD  PopMenu( nRow, nCol, nKey )  // PopUp menu options
   METHOD  Print( oPrn, nTop, nLeft, nWidth, nHeight )

   METHOD GetTextWidth( oFont, cText ) ;
          INLINE If( Empty( ::oPrn ),;
                     GetTextWidth( ::hDC, cText, oFont:hFont ),;
                     ::oPrn:GetTextWidth( cText, oFont ) )
   METHOD Say( nRow, nCol, cText, oFont, nClrText, nPad, nWidth ) ;
          INLINE If( Empty( ::oPrn ),;
                     ::Super:Say( nRow, nCol, cText, nClrText, , oFont, .T., .T., nPad ),;
                     ::oPrn:Say( nRow, nCol, cText, oFont, nWidth, nClrText, , nPad ) )

   METHOD SetType( nType ) ;
          INLINE ( ::nType := nType, ::Refresh() )

ENDCLASS

//---------------------------------------------------------------------------

METHOD New( nTop, nLeft, oWnd, nWidth, nHeight, cTitle, lDesign, lPixel,  ;
            l3D, lxGrid, lyGrid, lxVal, lyVal , lPopUp, lLegends, nType ) CLASS TGraph

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT nTop     := 0,              ;
           nLeft    := 0,              ;
           oWnd     := GetWndDefault(),;
           nWidth   := 100,            ;
           nHeight  := 100,            ;
           lDesign  := .F.,            ;
           lPixel   := .T.,            ;
           l3D      := .T.,            ;
           lxGrid   := .T.,            ;
           lyGrid   := .T.,            ;
           lxVal    := .T.,            ;
           lyVal    := .T.,            ;
           lPopUp   := .F.,            ;
           lLegends := .T.,            ;
           cTitle   := "" ,            ;
           nType    := GRAPH_TYPE_BAR


   #IFDEF FWPLUS
      x2RowCol( @nTop, @nLeft, @nHeight, @nWidth, lPixel, Self, oWnd )
      ::nTop   := nTop
      ::nLeft  := nLeft
   #ELSE
      ::nTop   := If( lPixel, nTop , nTop  * BMP_CHARPIX_H )
      ::nLeft  := If( lPixel, nLeft, nLeft * BMP_CHARPIX_W )
   #ENDIF

   ::aFont := Array(9)
   ::aFont[1] := TFont():New( "Arial", 0, -15, .F., .T.,   0, 0, ,.F., .F.) // Title
   ::aFont[2] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // xFont
   ::aFont[3] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // yFont
   ::aFont[4] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // Legends
   ::aFont[5] := TFont():New( "Arial", 0, -10, .F., .T.,   0, 0, ,.F., .F.) // Subtitle
   ::aFont[6] := TFont():New( "Arial", 0, -10, .F., .T., 898, 0, ,.F., .F.) // xTitle
   ::aFont[7] := TFont():New( "Arial", 0, -10, .F., .T.,   0, 0, ,.F., .F.) // yTitle
   ::aFont[8] := TFont():New( "Arial", 0, -11, .F., .F.,   0, 0, ,.F., .F.) // Values
   ::aFont[9] := TFont():New( "Arial", 0, -11, .F., .F.,   0, 0, ,.F., .F.) // Values

   ::nBottom  := ::nTop + nHeight - 1
   ::nRight   := ::nLeft + nWidth - 1
   ::oWnd     := oWnd
   ::nStyle   := nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, nOr( WS_CLIPSIBLINGS, WS_TABSTOP ), 0 ) )
   ::nId      := ::GetNewId()
   ::lDrag    := lDesign
   ::cTitle   := ''
   ::l3D      := l3D
   ::lxGrid   := lxGrid
   ::lyGrid   := lyGrid
   ::lxVal    := lxVal
   ::lyVal    := lyVal
   ::lTitle   := .T.
   ::lLegends := lLegends
   ::nType    := nType
   ::aYVals   := {}
   ::aYTemp   := {}

   ::nMaxVal  := 0
   ::nMinVal  := 0
   ::nXRanges := 4
   ::nBarSep  := 1
   ::nPieSt   := 0
   ::nPoint   := 1
   ::nClrT    := CLR_BLACK
   ::nClrX    := CLR_BLACK
   ::nClrY    := CLR_BLACK
   ::nClrL    := CLR_BLACK
   ::nClrV    := CLR_BLACK
   ::nClrST   := CLR_BLACK
   ::nClrXT   := CLR_BLACK
   ::nClrYT   := CLR_BLACK
   ::nClrGrid := CLR_GRAY
   ::nClrBack := CLR_WHITE
   ::nClrText := CLR_BLACK
   ::nClrPane := RGB(239,239,239)
   ::nClrBLeg := CLR_WHITE
   ::nPenWidth:= 2
   ::nBarD    := 15
   ::cPicture := "@E 999,999.99"
   ::nValues  := 1
   ::nPieX    := 1
   ::lDotted  := .T.
   ::lViewVal := .F.
   ::lBorders := .F.
   ::lcTitle  := .T.
   ::aSeries  := {}
   ::aData    := {}
   ::aSTemp   := {}
   ::aDTemp   := {}
   ::lPopUp   := lPopUp
   ::lSelView := .T.
   ::lSelBack := .T.
   ::nLanguage:=  2
   ::cBitMap  := NIL
   ::cSubTit  := ''
   ::cTitX    := ''
   ::cTitY    := ''
   ::nTLeft   := 0
   ::nTRight  := 2
   ::nTCent   := 6

   #IFDEF __XPP__
      DEFAULT ::lRegistered := .f.,;
              ::aSTitle     := {.T.,.T.,.T.,.T.},;
              ::lBordLeg    := .t.
   #ENDIF

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   IF ! Empty( oWnd:hWnd )
      ::Create()
      ::Default()
      oWnd:AddControl( Self )
   ELSE
      oWnd:DefControl( Self )
   ENDIF
   IF lDesign
      ::CheckDots()
   ENDIF

RETURN (Self)

METHOD ReDefine( nId, oWnd, cTitle, l3D, lxGrid, lyGrid, lXval, ;
                 lYval, lPopUp, lLegends, nType ) CLASS TGraph

   DEFAULT oWnd     := GetWndDefault(),;
           cTitle   := '' ,            ;
           l3D      := .T.,            ;
           lxGrid   := .T.,            ;
           lyGrid   := .T.,            ;
           lxVal    := .T.,            ;
           lyVal    := .T.,            ;
           lPopUp   := .F.,            ;
           lLegends := .T.,            ;
           nType    := GRAPH_TYPE_BAR

   ::aFont := Array(9)
   ::aFont[1] := TFont():New( "Arial", 0, -15, .F., .T.,   0, 0, ,.F., .F.) // Title
   ::aFont[2] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // xFont
   ::aFont[3] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // yFont
   ::aFont[4] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // Legends
   ::aFont[5] := TFont():New( "Arial", 0, -10, .F., .T.,   0, 0, ,.F., .F.) // Subtitle
   ::aFont[6] := TFont():New( "Arial", 0, -10, .F., .T., 898, 0, ,.F., .F.) // xTitle
   ::aFont[7] := TFont():New( "Arial", 0, -10, .F., .T.,   0, 0, ,.F., .F.) // yTitle
   ::aFont[8] := TFont():New( "Arial", 0, -10, .F., .F.,   0, 0, ,.F., .F.) // Values
   ::aFont[9] := TFont():New( "Arial", 0, -11, .F., .T.,   0, 0, ,.F., .F.) // Values bold

   ::nId      := nId
   ::oWnd     := oWnd
   ::lDrag    := .F.
   ::cTitle   := ''
   ::l3D      := l3D
   ::lxGrid   := lxGrid
   ::lyGrid   := lyGrid
   ::lxVal    := lxVal
   ::lyVal    := lyVal
   ::lTitle   := .T.
   ::lLegends := lLegends
   ::nType    := nType
   ::aYVals   := {}
   ::aYTemp   := {}

   ::nMaxVal  := 0
   ::nMinVal  := 0
   ::nXRanges := 4
   ::nBarSep  := 1
   ::nPieSt   := 0
   ::nPoint   := 1
   ::nClrT    := CLR_BLACK
   ::nClrX    := CLR_BLACK
   ::nClrY    := CLR_BLACK
   ::nClrL    := CLR_BLACK
   ::nClrV    := CLR_BLACK
   ::nClrST   := CLR_BLACK
   ::nClrXT   := CLR_BLACK
   ::nClrYT   := CLR_BLACK
   ::nClrGrid := CLR_GRAY
   ::nClrBack := CLR_WHITE
   ::nClrText := CLR_BLACK
   ::nClrPane := RGB(239,239,239)
   ::nClrBLeg := CLR_WHITE
   ::nPenWidth:= 2
   ::nBarD    := 15
   ::cPicture := "@E 999,999.99"
   ::nValues  := 1
   ::nPieX    := 1
   ::lDotted  := .T.
   ::lViewVal := .F.
   ::lBorders := .F.
   ::lcTitle  := .T.
   ::aSeries  := {}
   ::aData    := {}
   ::aSTemp   := {}
   ::aDTemp   := {}
   ::lPopUp   := lPopUp
   ::lSelView := .T.
   ::lSelBack := .T.
   ::nLanguage:=  2
   ::cBitMap  := NIL
   ::cSubTit  := ''
   ::cTitX    := ''
   ::cTitY    := ''
   ::nTLeft   := 0
   ::nTRight  := 2
   ::nTCent   := 6

   #IFDEF __XPP__
      DEFAULT ::lRegistered := .f.,;
              ::aSTitle     := {.T.,.T.,.T.,.T.},;
              ::lBordLeg    := .t.
   #ENDIF

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )
   IF oWnd != nil
      oWnd:DefControl( Self )
   ENDIF

RETURN Self


METHOD Destroy() CLASS TGraph
   LOCAL oFont
   for each oFont in ::aFont
      oFont:End()
   next
   ::Super:End()
RETURN (Nil)


METHOD AddSerie( aDat, cLegend, nColor ) CLASS TGraph
   AAdd( ::aSeries, { cLegend, nColor } )
   AAdd( ::aData, aDat )
   AAdd( ::aSTemp , { cLegend, nColor } )
   AAdd( ::aDTemp, aDat )
RETURN Len( ::aSeries )


METHOD SelSerie( nlSerie ) CLASS TGraph
   LOCAL nJ, nI, aSLoc, aDLoc:={}
   IF ValType(nLSerie)="L"
      ::aYVals  := ::aYTemp
      ::aSeries := ::aSTemp
      ::aData   := ::aDTemp
   ELSE
      ::aYVals  := {}
      ::aSeries := {}
      ::aData   := {}
      FOR nJ := 1 TO Len( ::aSTemp )
         IF nJ = nlSerie
            aSLoc := { ::aSTemp[nJ,1], ::aSTemp[nJ,2] }
            FOR nI :=1 TO Len( ::aDTemp[nJ] )
               AAdd(aDLoc, ::aDTemp[nJ,nI] )
            NEXT nI
            nJ := Len( ::aSTemp )
         ENDIF
      NEXT nJ
      AAdd( ::aSeries, aSLoc )
      AAdd( ::aData, aDLoc )
      ::aYVals := ::aYTemp
   ENDIF
RETURN (Nil)

METHOD SelPeriod( nPeriod ) CLASS TGraph
   LOCAL nJ, nI, aSLoc, aDLoc:={}
   IF Len(::aYVals)>0
      ::aYVals  := {}
      ::aSeries := {}
      ::aData   := {}
      FOR nJ := 1 TO Len( ::aSTemp )
         aSLoc := { ::aSTemp[nJ,1], ::aSTemp[nJ,2] }
         AAdd( ::aSeries, aSLoc )
         FOR nI :=1 TO Len( ::aDTemp[nJ] )
            IF nI = nPeriod
               aDLoc := {}
               AAdd(aDLoc, ::aDTemp[nJ,nI] )
               AAdd( ::aData, aDLoc )
            ENDIF
         NEXT nI
      NEXT nJ
      ::aYVals := { ::aYTemp[nPeriod] }
   ENDIF
RETURN (Nil)


METHOD SetYVals( aTextos ) CLASS TGraph
   LOCAL aRet := AClone( ::aYVals )
   ::aYVals := aTextos
   ::aYTemp := aTextos
RETURN (aRet)

METHOD Display() CLASS TGraph
   ::BeginPaint()
   ::Paint()
   ::EndPaint()
RETURN (Nil)


METHOD Default() CLASS TGraph
   IF ::oFont != nil
      ::SetFont( ::oFont )
   ELSE
      ::SetFont( ::oWnd:oFont )
   ENDIF
RETURN (Nil)

//---------------------------------------------------------------------------

METHOD Paint( nTop, nLeft, nBottom, nRight ) CLASS TGraph

   LOCAL nI, nPos, nMax, nMin, nMaxBar, nDeep, nJ, aPoint
   LOCAL nPenWidth, lBar, nWBar, nWText, l3D, nClrLine
   LOCAL nRange, aRange := {}, nResH, nResV,  nWide
   LOCAL nXMax, nXMin, nHigh, nRel, nWPic, nWLeg:=0
   LOCAL nZero, nRPos, nRNeg, lyVal, lxVal, aCoord[4]
   LOCAL nHTit := IF(!Empty(::cTitle) ,Abs(::aFont[1]:nHeight),0)
   LOCAL nSTit := IF(!Empty(::cSubTit),Abs(::aFont[5]:nHeight),0)
   LOCAL nXTit := IF(!Empty(::cTitX)  ,Abs(::aFont[6]:nHeight),0)
   LOCAL nYTit := IF(!Empty(::cTitY)  ,Abs(::aFont[7]:nHeight),0)
   LOCAL nLTit := IF(Len(::aYVals)>0  ,Abs(::aFont[4]:nHeight),0)

   l3D   := IF( ::nType == GRAPH_TYPE_POINT, .F., ::l3D   )
   lyVal := IF( ::nType == GRAPH_TYPE_PIE  , .F., ::lyVal )
   lxVal := IF( ::nType == GRAPH_TYPE_PIE  , .F., ::lxVal )

   nWLeg := 80
   FOR nI := 1 TO Len( ::aSeries )             // Max Width Legends
      nWLeg := Max( 5+GetTextWidth(::aFont[4],Alltrim(::aSeries[nI,1])), nWLeg )
   NEXT nI                                     // Max Width Picture
   nWPic := Max( ::GetTextWidth(::aFont[2],::cPicture), 30 )

   DEFAULT nTop    := 1+IF(::lTitle,IF(!Empty(::cSubTit),nSTit,0)+nHTit+30,15)     // Top gap
   DEFAULT nLeft   := 1+IF(::lTitle,IF(!Empty(::cTitX  ),nXTit,0)+15,15)+::nBarD   // Left
   DEFAULT nBottom := ::nHeight-2-IF(::lTitle  ,nYTit+15,15)                       // Bottom
   DEFAULT nRight  := ::nWidth -2-IF(::lLegends,nWLeg+ 5,15)                       // Right

   nLeft   += IF(::lxVal,nWPic,0)
   nBottom -= IF(::lyVal,nLTit,0)

   nResH   := nResV := 1
   IF !Empty(::oPrn)
      nResH   := ::oPrn:nLogPixelX() / LOGPIXELSX    // Printer resolution
      nResV   := ::oPrn:nLogPixelY() / LOGPIXELSY
      nTop    += 1+IF(::lTitle,IF(!Empty(::cSubTit),nSTit,0)+nHTit+30,15)     // Top gap
      nLeft   += 1+IF(::lTitle,IF(!Empty(::cTitX  ),nXTit,0)+15,15)+::nBarD   // Left
      nBottom -= ::nHeight-2-IF(::lTitle  ,nYTit+15,15)                       // Bottom
      nRight  -= ::nWidth -2-IF(::lLegends,nWLeg+ 5,15)                       // Right
   ENDIF
   nDeep   := IF( l3D, (::nBarD*nResV), 1 )
   nMaxBar := nBottom - nTop - nDeep
   nWide   := (nRight-nLeft) / (::nMax()+1)

   IF ::lPopUp
      ::bRCliCked := {| nRow, nCol, nKey | ::PopMenu( nRow, nCol, nKey ) }
   ENDIF
   nPenWidth   := ::nPenWidth
   ::nPenWidth := 1

   // Graph area
   //
   IF Empty( ::oPrn )
      ::EraseBkGnd(::hDC)
      WndBoxIn(::hDC,1,1,::nHeight-1,::nWidth-1)
      ::FillRect( 2, 2, ::nHeight-2, ::nWidth-2, ::nClrPane )
   ENDIF

   // Back area
   //
   IF ! Empty( ::cBitmap ) .AND. File( AnsiToOem( Lfn2Sfn( ::cBitmap ) ) )
      ::SayBitmap( 0, 0, AnsiToOem( Lfn2Sfn( ::cBitmap ) ), ::nWidth, ::nHeight )
   ELSEIF Empty( ::oPrn ) .AND. ::nType != GRAPH_TYPE_PIE
      ::FillRect( nTop, nLeft, nBottom-nDeep, nRight, ::nClrBack )
   ENDIF

   // Graph borders
   //
   IF ::nType != GRAPH_TYPE_PIE .AND. !l3D
      ::Drawline( nBottom, nLeft , nBottom, nRight, RGB(225,225,225))
      ::Drawline( nTop   , nRight, nBottom, nRight, RGB(225,225,225))
      ::Drawline( nTop   , nLeft , nTop   , nRight, RGB(128,128,128))
      ::Drawline( nTop   , nLeft , nBottom, nLeft , RGB(128,128,128))
   ENDIF

   IF l3D .AND. ::nType != GRAPH_TYPE_PIE

      ::DrawLine(nBottom-nDeep  ,nLeft   ,nBottom  , nLeft-nDeep   , CLR_GRAY )
      ::DrawLine(nBottom-nDeep  ,nRight-1,nBottom  , nRight-nDeep-1, CLR_BLACK)
      ::DrawLine(nTop+1,nLeft-1 ,nTop+nDeep+1      , nLeft -nDeep-1, CLR_BLACK)
      ::DrawLine(nTop-2         ,nLeft ,nTop+nDeep , nLeft-nDeep-2 , CLR_BLACK)
      ::DrawLine(nBottom-nDeep+1,nRight+1,nBottom+3, nRight-nDeep-1, CLR_BLACK)

      FOR nI := 1 TO nDeep
         ::DrawLine(nTop+nI+1, nLeft-nI, nBottom-nDeep+nI, nLeft-nI, CLR_HGRAY)
      NEXT nI

      ::DrawLine(nTop         ,nLeft        ,nTop           ,nRight       ,CLR_BLACK)
      ::DrawLine(nTop- 2      ,nLeft        ,nTop- 2        ,nRight+ 2    ,CLR_BLACK)
      ::DrawLine(nTop         ,nLeft        ,nBottom-nDeep  ,nLeft        ,CLR_GRAY )
      ::DrawLine(nTop+nDeep   ,nLeft-nDeep  ,nBottom+ 0     ,nLeft-nDeep  ,CLR_BLACK)
      ::DrawLine(nTop+nDeep   ,nLeft-nDeep-2,nBottom+ 2     ,nLeft-nDeep-2,CLR_BLACK)
      ::DrawLine(nTop         ,nRight       ,nBottom-nDeep  ,nRight       ,CLR_BLACK)
      ::DrawLine(nTop- 2      ,nRight+ 2    ,nBottom-nDeep+1,nRight+ 2    ,CLR_BLACK)
      ::DrawLine(nBottom-nDeep,nLeft        ,nBottom-nDeep  ,nRight       ,CLR_GRAY )
      ::DrawLine(nBottom+ 0   ,nLeft-nDeep  ,nBottom+ 0     ,nRight-nDeep ,CLR_BLACK)
      ::DrawLine(nBottom+ 2   ,nLeft-nDeep-2,nBottom+ 2     ,nRight-nDeep ,CLR_BLACK)

   ENDIF

   // Graph info
   //
   IF ::lTitle
      IF ::nType != GRAPH_TYPE_PIE
         nPos := 0
         IF ::lcTitle
            nWText := ::GetTextWidth(::aFont[1],Alltrim(::cTitle))
            nPos   := (nRight-nLeft) / 2
         ENDIF
         IF ::aSTitle[1]
            ::Say( nTop-(15*nResV+nStit+nHTit)+1.5, nLeft+nPos+1.5, ::cTitle, ::aFont[1], CLR_HGRAY, IF(::lcTiTle,::nTCent,0) )
         ENDIF
         ::Say( nTop-(15*nResV+nStit+nHTit), nLeft+nPos, ::cTitle, ::aFont[1], ::nClrT, IF(::lcTitle,::nTCent,0) )
         IF !Empty( ::cSubTit )
            IF ::aSTitle[2]
               ::Say( nTop-(8*nResV+nSTit)+1.5, nLeft+1.5, ::cSubTit, ::aFont[5], CLR_HGRAY )
            ENDIF
            ::Say( nTop-(8*nResV+nStit), nLeft, ::cSubTit, ::aFont[5], ::nClrST )
         ENDIF
         IF !Empty( ::cTitX )
            nWText := ::GetTextWidth(::aFont[6],::cTitX)
            nPos   := ( (nBottom-nTop) / 2 ) - nDeep
            nRPos  := nLeft-(10+IF(lxVal,nWPic,0)+IF(!Empty(::cTitX),nXTit,0)+nDeep)
            IF ::aSTitle[3]
               ::Say( nBottom-nPos-nDeep+1.5, nRPos+1.5, ::cTitX, ::aFont[6], CLR_HGRAY, ::nTCent )
            ENDIF
            ::Say( nBottom-nPos-nDeep, nRPos, ::cTitX, ::aFont[6], ::nClrXT, ::nTCent )
         ENDIF
         IF !Empty( ::cTitY )
            nWText := ::GetTextWidth(::aFont[7],::cTitY)
            nPos   := ( (nRight-nLeft) / 2 ) - nDeep
            nRPos  := nBottom+(IF(lyVal,nLTit,0)+IF(!Empty(::cTitY),nYTit,0))-2
            IF ::aSTitle[4]
               ::Say( nRPos+1.5, nLeft+nPos+1.5, ::cTitY, ::aFont[7], CLR_HGRAY, ::nTCent )
            ENDIF
            ::Say( nRPos, nLeft+nPos, ::cTitY, ::aFont[7], ::nClrYT, ::nTCent )
         ENDIF
      ELSE
         nPos := nLeft-nDeep-IF(::lxVal,nWPic,0)
         IF ::lcTitle
            nWText := ::GetTextWidth(::aFont[1],::cTitle)
            nPos   += ( nRight - nPos - nWText*nResH ) / 2
         ENDIF
         IF ::aSTitle[1]
            ::Say( nTop-(15*nResV+nStit+nHTit)+1.5, nPos+1.5, ::cTitle, ::aFont[1], CLR_HGRAY )
         ENDIF
         ::Say( nTop-(15*nResV+nStit+nHTit), nPos, ::cTitle, ::aFont[1], ::nClrT )
         nPos := nLeft-nDeep-IF(::lxVal,nWPic,0)
         IF !Empty( ::cSubTit ) .AND. ::l3D
            IF ::aSTitle[2]
               ::Say( nTop-( 8*nResV+nSTit)+1.5, nPos+1.5, ::cSubTit, ::aFont[5], CLR_HGRAY )
            ENDIF
            ::Say( nTop-( 8*nResV+nStit), nPos, ::cSubTit, ::aFont[5], ::nClrST )
         ENDIF
      ENDIF

   ENDIF

   // Pie graph
   //
   IF ::nType == GRAPH_TYPE_PIE
      ::DrawPie( { nTop+nDeep, nLeft-nDeep-IF(::lxVal,nWPic,0), nBottom, IF(::lLegends,nRight+nWLeg-15,nRight) }, nWLeg, nResH, nResV )
      RETURN (Nil)
   ENDIF

   // Legends
   //
   IF ::lLegends
      IF ::lBordLeg
         nPos := nTop - 1
         aCoord[ 1 ]:= nPos
         aCoord[ 2 ]:= nRight + ( 8 * nResH )
         aCoord[ 3 ]:= nPos   + ( Len( ::aSeries ) * ( 15*nResV ) ) + 1
         aCoord[ 4 ]:= nRight + (nWLeg * nResH)
         ::DrawLine( aCoord[ 1 ]-1, aCoord[ 2 ]-1, aCoord[ 1 ]-1, aCoord[ 4 ], CLR_GRAY )
         ::DrawLine( aCoord[ 1 ]-1, aCoord[ 2 ]-1, aCoord[ 3 ], aCoord[ 2 ]-1, CLR_GRAY )
         ::DrawLine( aCoord[ 3 ], aCoord[ 2 ], aCoord[ 3 ], aCoord[ 4 ], CLR_HGRAY )
         ::DrawLine( aCoord[ 1 ]  , aCoord[ 4 ], aCoord[ 3 ], aCoord[ 4 ], CLR_HGRAY )
         ::FillRect( aCoord[1], aCoord[2], aCoord[3], aCoord[4], ::nClrBLeg )
      ENDIF

      nPos := nTop + 2
      FOR nI := 1 TO Len( ::aSeries )
         ::DrawBar( nRight+(10*nResH), nPos+(9*nResV),  8*nResH, 7*nResV, 1, ::aSeries[nI,2] )
         ::Say( nPos, nRight+(20*nResH), ::aSeries[nI,1], ::aFont[4], ::nClrL )
         nPos += 15*nResV
      NEXT nI
   ENDIF

   // Max, Min values
   nMax := IF( ::nMaxVal <> 0 , ::nMaxVal , 0 )
   FOR nJ := 1 TO Len( ::aSeries )
      FOR nI :=1 TO Len( ::aData[nJ] )
         nMax := Max( ::aData[nJ,nI], nMax )
      NEXT nI
   NEXT nJ
   nMin := IF( ::nMinVal <> 0 , ::nMinVal , 0 )
   FOR nJ := 1 TO Len( ::aSeries )
      FOR nI :=1 TO Len( ::aData[nJ] )
         nMin := Min( ::aData[nJ,nI], nMin )
      NEXT nI
   NEXT nJ

   nXMax := IF( nMax > 0, DetMaxVal( nMax ), 0 )
   nXMin := IF( nMin < 0, DetMaxVal( nMin ), 0 )
   nHigh := nXMax + nXMin
   nMax  := Max( nXMax, nXMin )

   nRel:= ( nMaxBar / nHigh )
   nMaxBar := nMax * nRel

   // Zero pos
   //
   nZero:=Max(nBottom+(nXMin*-1*nRel),IF(nXMax>0,nTop+(nXMax*nRel)+nDeep,0))
   IF l3D
      FOR nI := 1 TO nDeep+1
         ::DrawLine(nZero-nI+1, nLeft-nDeep+nI, nZero-nI+1, nRight-nDeep+nI, CLR_HGRAY)
      NEXT nI
   ENDIF

   aPoint := Array( Len( ::aSeries ), Len( ::aData[1] ), 2 )
   nRange := nMax / ::nXRanges

   // Calculate data ranges
   FOR nI = 1 TO ::nXRanges
      AAdd( aRange, nRange * nI )
   NEXT nI

   AAdd( aRange, nMax )

   // xValues
   //
   nRPos := nRNeg := nZero - nDeep
   FOR nI := 0 TO ::nXRanges
      IF lxVal
         IF nXMax >= nRange*nI
            ::Say( nRPos+nDeep-5, nLeft-nDeep-10, Tran( nRange* nI, ::cPicture ), ;
            ::aFont[2], ::nClrX, ::nTRight )
         ENDIF
         IF nXMin*-1 <= nRange*-nI
            ::Say( nRNeg+nDeep-5, nLeft-nDeep-10, Tran( nRange*-nI, ::cPicture ), ;
            ::aFont[2], ::nClrX, ::nTRight )
         ENDIF
      ENDIF
      IF ::lxGrid
         IF nXMax > nRange*nI
            ::DrawLine( nRPos+nDeep, nLeft-nDeep, nRPos, nLeft, ::nClrGrid, ::lDotted )
            ::DrawLine( nRPos, nLeft, nRPos, nRight, ::nClrGrid, ::lDotted )
         ENDIF
         IF nXMin*-1 <  nRange*-nI
            ::DrawLine( nRNeg+nDeep, nLeft-nDeep, nRNeg, nLeft, ::nClrGrid, ::lDotted )
            ::DrawLine( nRNeg, nLeft, nRNeg, nRight, ::nClrGrid, ::lDotted )
         ENDIF
      ENDIF
      nRPos -= ( nMaxBar / ::nXRanges )
      nRNeg += ( nMaxBar / ::nXRanges )
   NEXT nI

   IF !lxVal
      ::Say( nZero-5, nLeft-nDeep-3, "0", ::aFont[8], ::nClrV, ::nTRight)
   ENDIF

   IF ::lYGrid
      nPos:= nTop
      nI  := nLeft + nWide
      FOR nJ := 1 TO ::nMax()
         ::Drawline( nBottom-nDeep , nI , nPos , nI , ::nClrGrid, ::lDotted )
         ::Drawline( nBottom , nI-nDeep , nBottom-nDeep , nI , ::nClrGrid, ::lDotted )
         nI += nWide
      NEXT
   ENDIF

   nMin := nMax / nMaxBar
   nMin := IF(nMin=0,0.01,nMin)                  // para evitar división entre cero

   IF lyVal .AND. Len(::aYVals)>0                // Show yLabels
      nI := nLeft + nWide
      FOR nJ := 1 TO ::nMax()
         ::Say(nBottom+ 5, nI-nDeep, ::aYVals[nJ], ::aFont[3], ::nClrY, ::nTCent)
         nI += nWide
      NEXT
   ENDIF

   // Bars
   //
   nWBar:=0
   IF ::nType == GRAPH_TYPE_BAR .OR. ::nType == GRAPH_TYPE_ALL
      IF Len(::aData[1])=1
         nWide:=nWide*1.5
         nWBar := (nWide / ( Len(::aSeries) + 1 )) - ::nBarSep
         nPos  := nLeft + (nWBar/2) + (nWide/6) - nDeep + ::nBarSep
      ELSE
         nWBar := (nWide / ( Len(::aSeries) + 1 )) - ::nBarSep
         nWBar += (nWBar/2)/(Len(::aSeries)+0.5)
         nPos  := nLeft + nWide - ((nWide-nWBar+(nWBar/2))/2) - nDeep + ::nBarSep
      ENDIF
      FOR nI=1 TO Len( ::aData[1] )
         FOR nJ=1 TO Len( ::aSeries )
            ::DrawBar(nPos,nZero,::aData[nJ,nI]/nMin+nDeep,nWBar,nDeep,::aSeries[nJ,2],nI,nJ)
            nPos+=nWBar+::nBarSep
         NEXT nJ
         nPos+=(nWBar/2)+::nBarSep
      NEXT nI
   ENDIF

   // Lines
   //
   IF ::nType == GRAPH_TYPE_LINE  .OR. ::nType == GRAPH_TYPE_ALL .OR. ::nType == GRAPH_TYPE_POINT
      nPos := nLeft + nWide
      FOR nI := 1 TO Len(::aData[1])
         FOR nJ=1 TO Len( ::aSeries )
            IF !l3D
               ::DrawPoint(nPos,nZero,::aData[nJ,nI]/nMin+nDeep,::aSeries[nJ,2],nResV,nResH)
            ENDIF
            aPoint[nJ,nI,2]:=nPos
            aPoint[nJ,nI,1]:=nZero-(::aData[nJ,nI]/nMin+nDeep)
         NEXT nJ
         nPos += nWide
      NEXT nI
      FOR nI := 1 TO Len(::aData[1])-1
         FOR nJ := 1 TO Len(::aSeries)
            IF l3D
               nClrLine:=IF(Len(::aYVals)>0,CLR_BLACK,::aSeries[nJ,2])
               ::DrawPoly({{aPoint[nJ,nI,2],aPoint[nJ,nI,1]},{aPoint[nJ,nI+1,2],aPoint[nJ,nI+1,1]}, ;
                           {aPoint[nJ,nI+1,2]-nDeep,aPoint[nJ,nI+1,1]+nDeep},{aPoint[nJ,nI,2]-nDeep,aPoint[nJ,nI,1]+nDeep}, ;
                           {aPoint[nJ,nI,2],aPoint[nJ,nI,1]}},::aSeries[nJ,2])
               ::DrawLine(aPoint[nJ,nI,1],aPoint[nJ,nI,2],aPoint[nJ,nI,1]+nDeep,aPoint[nJ,nI,2]-nDeep,nClrLine)
               ::DrawLine(aPoint[nJ,nI,1],aPoint[nJ,nI,2],aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2],CLR_BLACK)
               ::DrawLine(aPoint[nJ,nI,1]+nDeep,aPoint[nJ,nI,2]-nDeep,aPoint[nJ,nI+1,1]+nDeep,aPoint[nJ,nI+1,2]-nDeep,CLR_BLACK)
               ::DrawLine(aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2],aPoint[nJ,nI+1,1]+nDeep,aPoint[nJ,nI+1,2]-nDeep,CLR_BLACK)
            ELSE
               IF ::nType <> GRAPH_TYPE_POINT
                  ::nPenWidth := nPenWidth
               ENDIF
               ::DrawLine(aPoint[nJ,nI,1],aPoint[nJ,nI,2],aPoint[nJ,nI+1,1],aPoint[nJ,nI+1,2],::aSeries[nJ,2])
            ENDIF
         NEXT nI
      NEXT nI
   ENDIF

   // Points
   //
   IF ::nType == GRAPH_TYPE_POINT .OR. ::nType == GRAPH_TYPE_ALL
      IF Len(::aData[1])=1
         nWide:=nWide*1.5
         nWBar := (nWide / ( Len(::aSeries) + 1 )) - ::nBarSep
         nPos  := nLeft + (nWBar/2) + (nWide/6) - nDeep + ::nBarSep
         FOR nI=1 TO Len( ::aData[1] )
            FOR nJ=1 TO Len( ::aSeries )
               ::DrawPoint(nPos,nZero,::aData[nJ,nI]/nMin+nDeep,::aSeries[nJ,2],nResV,nResH)
               nPos+=nWBar+::nBarSep
            NEXT nJ
            nPos+=(nWBar/2)+::nBarSep
         NEXT nI
      ELSE
         nPos := nLeft + nWide
         FOR nI := 1 TO Len(::aData[1])
            FOR nJ=1 TO Len( ::aSeries )
               ::DrawPoint(nPos,nZero,::aData[nJ,nI]/nMin+nDeep,::aSeries[nJ,2],nResV,nResH)
               aPoint[nJ,nI,2]:=nPos
               aPoint[nJ,nI,1]:=nZero-(::aData[nJ,nI]/nMin)
            NEXT nJ
            nPos+= nWide
         NEXT nI
      ENDIF
   ENDIF

   // View values
   //
   lBar:=IF(::nType=GRAPH_TYPE_BAR .OR. ::nType=GRAPH_TYPE_ALL .OR. Len(::aData[1])=1,.T.,.F.)
   IF ::lViewVal
      IF Len(::aData[1])=1
         nPos:=nLeft+(nWBar/2)+(nWide/6)+::nBarSep
      ELSE
         nPos:=nLeft+IF(lBar,nWide-IF(Len(::aSeries)>1,nWBar+(nWBar/2)+::nBarSep,nWBar-nDeep)+nDeep,nWide)
         nPos+=IF(!::l3D,(nWBar-nWBar/2),0)
      ENDIF
      FOR nI := 1 TO Len(::aData[1])
         FOR nJ := 1 TO Len(::aSeries)
            if ::aData[nJ,nI] != 0
            ::Say(nZero-(::aData[nJ,nI]/nMin+nDeep),nPos,Tran(::aData[nJ,nI],::cPicture),::aFont[9],::nClrV,::nTRight)
            end if
            nPos += IF(lBar,nWBar+::nBarSep,0)
         NEXT nJ
         nPos += IF(lBar,(nWBar/2)+::nBarSep,nWide)
      NEXT nI
   ENDIF

   // Zero line
   //
   ::nPenWidth := 1
   IF l3D
      ::DrawLine(nZero-nDeep, nRight-1   , nZero, nRight-nDeep-1, IF(nXMin<>0,CLR_GRAY,CLR_BLACK))
      ::DrawLine(nZero      , nLeft-nDeep, nZero, nRight-nDeep  , IF(nXMin<>0,CLR_GRAY,CLR_BLACK))
   ELSE
      IF nXMax<>0 .AND. nXMin<>0
         ::DrawLine(nZero-1, nLeft-2, nZero-1, nRight, CLR_HRED )
      ELSE
         ::DrawLine(nZero-1, nLeft-2, nZero-1, nRight, CLR_BLACK)
      ENDIF
   ENDIF

   ::nPenWidth := nPenWidth
   ::DeletePen()

RETURN (Nil)


METHOD DrawBar( nY, nX, nHigh, nWidth, nDeep, nColor, nI, nJ ) CLASS TGraph

   LOCAL nColTop, nShadow, hPen, hOldPen, nHTem:=nHigh

   nColTop := ClrShadow( nColor , 15 )
   nShadow := ClrShadow( nColTop, 15 )
   hOldPen := SelectObject(::hDC,hPen := GetStockObject(NULL_PEN))

   // Front
   ::FillRect( nX, nY+1, nX+nDeep-nHigh, nY+nWidth+1, nColor )

   // Lateral
   ::DrawPoly( {{nY+nWidth+1,nX-1},{nY+nWidth+1,nX+nDeep-nHigh},;
                {nY+nWidth+nDeep,nX-nHigh+1},{nY+nWidth+nDeep,nX-nDeep},;
                {nY+nWidth+1,nX-1}}, nShadow )

   // Superior
   nHigh   := Max( nHigh, nDeep )
   ::DrawPoly( {{nY+1,nX-nHigh+nDeep},{nY+nWidth+1,nX-nHigh+nDeep},;
                {nY+nWidth+nDeep,nX-nHigh+1},{nY+nDeep,nX-nHigh+1},;
                {nY+1,nX-nHigh+nDeep}}, nColTop )

   SelectObject(::hDC,hOldPen)
   DeleteObject(hPen)

   // Borders
   IF ::lBorders
      ::DrawBox( nY, nX, nHTem, nWidth, nDeep )
   ENDIF

RETURN (Nil)


METHOD DrawPoint( nY, nX, nHigh, nColor, nResV, nResH ) CLASS TGraph

   nColor := ClrShadow( nColor , 15 )

   IF ::nType == GRAPH_TYPE_POINT .OR. ::nType == GRAPH_TYPE_ALL
      IF ::nPoint=POINT_TYPE_1   // Point
         ::DrawLine(nX-nHigh, nY-3*nResH, nX-nHigh, nY+4*nResH, nColor)
         ::Circle(nX-nHigh-3*nResV, nY-3*nResH, 8*nResH)
         ::DrawLine(nX-nHigh, nY-2*nResH, nX-nHigh, nY+3*nResH, nColor)
         ::Circle(nX-nHigh-3*nResV, nY-3*nResH, 7*nResH)
         ::DrawLine(nX-nHigh, nY-2*nResH, nX-nHigh, nY+3*nResH, nColor)
         ::Circle(nX-nHigh-2*nResV, nY-2*nResH, 6*nResH)
         ::DrawLine(nX-nHigh-1*nResV, nY-1*nResH, nX-nHigh-1*nResV, nY+2*nResH, nColor)
         ::DrawLine(nX-nHigh        , nY-3*nResH, nX-nHigh        , nY+3*nResH, nColor)
         ::DrawLine(nX-nHigh+1*nResV, nY-2*nResH, nX-nHigh+1*nResV, nY+3*nResH, nColor)
         ::DrawLine(nX-nHigh+2*nResV, nY-2*nResH, nX-nHigh+2*nResV, nY+3*nResH, nColor)
      ENDIF

      IF ::nPoint=POINT_TYPE_2   // Cross
         ::DrawLine( nX - nHigh , nY -5, nX - nHigh , nY + 6, nColor )
         ::DrawLine( nX - nHigh - 5 , nY , nX - nHigh + 6 , nY , nColor )
         ::FillRect( nX - nHigh-2, nY-2, nX - nHigh + 3, nY+3, nColor )
      ENDIF

      IF ::nPoint=POINT_TYPE_3  // Shape
         ::DrawLine( nX - nHigh , nY -4, nX - nHigh , nY + 5, nColor )
         ::DrawLine( nX - nHigh - 4 , nY , nX - nHigh + 5 , nY , nColor )
         ::Circle( nX - nHigh -3, nY -3, 8)
         ::Circle( nX - nHigh -2, nY -2, 6)
         ::Circle( nX - nHigh -1, nY -1, 4)
      ENDIF

   ENDIF

   IF ::nType == GRAPH_TYPE_LINE .AND. Len( ::aYVals ) > 0
      ::Circle( nX - nHigh - 2*nResV, nY - 2*nResH, 6*nResV, CLR_BLACK )
   ENDIF

RETURN (Nil)


METHOD DrawLine( nY1, nX1, nY2, nX2, nColor, lDotted ) CLASS TGraph

   LOCAL hPen, nPend, nInter, nI

   DEFAULT lDotted := .F.

   hPen := ::CreatePen( nColor )
   IF !lDotted
      MoveTo( ::hDC, nX1, nY1 )
      LineTo( ::hDC, nX2, nY2 )
   ELSE
      IF nX1 == nX2
         IF nY1 <= nY2
            FOR nI = nY1 TO nY2 STEP 3
               MoveTo( ::hDC, nX1, nI )
               LineTo( ::hDC, nX2, MIN(nI+2,nY2) )
            NEXT nI
         ELSE
            FOR nI = nY1 TO nY2 STEP -3
               MoveTo( ::hDC, nX1, nI )
               LineTo( ::hDC, nX2, MAX(nI-2,nY2) )
            NEXT nI
         ENDIF
      ELSE
         nPend := (nY2-nY1)/(nX2-nX1)
         nInter := nY1-nPend * nX1
         FOR nI = nX1 TO nX2 STEP 3
            MoveTo( ::hDC, nI, nInter+nPend*nI )
            LineTo( ::hDC, MIN(nI+2,nX2), nInter+nPend*(Min(nI+2,nX2)) )
         NEXT nI
      ENDIF
   ENDIF
   DeleteObject( hPen )

RETURN (Nil)


METHOD DrawPoly( aPoly, nColor ) CLASS TGraph

   LOCAL hBrush, hOldBrush, hOldPen

   hBrush := CreateSolidBrush( nColor )
   hOldBrush := SelectObject( ::hDC, hBrush )
   hOldPen   := SelectObject( ::hDC, GetStockObject( NULL_PEN ) )

   PolyPolygon( ::hDC, aPoly )

   SelectObject( ::hDC, hOldBrush )
   SelectObject( ::hDC, hOldPen )
   DeleteObject( hBrush )

RETURN (Nil)


Static Function ClrShadow( nColor, nFactor ) // CLASS TGraph

   LOCAL aHSL, aRGB

   aHSL := RGB2HSL( nRGBRed(nColor) , nRGBGreen(nColor) , nRGBBlue(nColor) )
   aHSL[3] -= nFactor
   aRGB := HSL2RGB( aHSL[1], aHSL[2], aHSL[3] )

RETURN nRGB( aRGB[1], aRGB[2], aRGB[3] )


METHOD nMax() CLASS TGraph
   LOCAL nI, nMax := 0
   FOR nI :=1 TO Len( ::aData )
      nMax := Max( Len(::aData[nI]) , nMax )
   NEXT nI
RETURN( nMax )


METHOD DrawPie( aRect, nWLeg, nResH, nResV, lPrint ) CLASS TGraph

   LOCAL hMemCDC, hPen, hOldPen, hBrush, hBOld, hOldFont, nI
   LOCAL nY, nX, nAngle, nCount, nSizeX, nSizeY, nAngT
   LOCAL aItems := {}, hBru1, hBruO, nFor, nSum
   LOCAL hMyDC, aPT1, aPT2, nyEdge, nxEdge, cText, aSRect[4]
   LOCAL nDiam, aGRect[4], aColor, nColor, nPos, aPt3, nColr
   LOCAL nSepX, nSepY, hBrDark, nClr, aValrs:={} , aCoord[4]
   LOCAL nXSep, nYSep, cVals, nRow, nCol, nWText, nLenL

   DEFAULT lPrint := .F.

   ::nValues:=IF(Len(::aYVals)>0,::nValues,PERIOD_VALUES)
   aColor:={RGB(128,128,255),RGB(255,100, 10),RGB( 50,200, 50),RGB(180, 50,130),;
            RGB(255,255, 10),RGB( 10,255,255),RGB(255, 10,255),RGB(180, 10, 50),;
            RGB( 10,128, 10),RGB(255,100, 80),RGB(100, 80,255),RGB(255,100,255) }
   nColor:= 1
   nSum  := 0

   IF ::nValues == SERIE_VALUES .AND. Len(::aData[1])>1 // Serie
      FOR nFor := 1 TO Len( ::aData[1] )
         nSum += Abs(::aData[::nPieX, nFor])
         AAdd( aValrs, ::aData[::nPieX, nFor] )
      NEXT nFor
      FOR nFor := 1 TO Len( ::aData[1] )
         IF ::aData[::nPieX, nFor]<>0
            AAdd( aItems, { Abs(::aData[::nPieX, nFor] * 360) / nSum, aColor[nColor] } )
            nColor++
            IF nColor>12
               nColor:=1
            ENDIF
         ENDIF
      NEXT nFor
   ENDIF

   hMemCDC := ::hDC
   hPen    := CreatePen( PS_SOLID, 1, RGB( 0, 0, 0 ) )
   hOldPen := SelectObject( hMemCDC, GetStockObject( NULL_PEN ) )

   IF ::nValues == PERIOD_VALUES .OR. Len(::aData[1])=1 // Period
      nColor:= 1
      nSum  := 0
      FOR nFor := 1 TO Len( ::aData )
         nSum += Abs(::aData[nFor,::nPieX])
         AAdd( aValrs, ::aData[nFor,::nPieX] )
      NEXT nFor
      FOR nFor := 1 TO Len( ::aData )
         IF ::aData[nFor,::nPieX]<>0
            AAdd( aItems, { Abs(::aData[nFor,::nPieX] * 360) / nSum, ::aSeries[nFor,2] } )
            nColor++
            IF nColor>12
               nColor:=1
            ENDIF
         ENDIF
      NEXT nFor
   ENDIF

   IF ::lLegends
      nWLeg:=0
      IF ::nValues == SERIE_VALUES
         FOR nI := 1 TO Len( ::aYVals )
            nWLeg := Max( 30+::GetTextWidth(::aFont[4],Alltrim(::aYVals[nI])), nWLeg )
         NEXT nI
         nLenL := (Len(::aData[1])*(15*nResV)) - ::nBarD + 1
      ENDIF
      IF ::nValues == PERIOD_VALUES
         nWLeg:=0
         FOR nI := 1 TO Len( ::aSeries )
            nWLeg := Max( 30+::GetTextWidth(::aFont[4],Alltrim(::aSeries[nI,1])), nWLeg )
         NEXT nI
         nLenL := (Len(::aSeries)*(15*nResV))  - ::nBarD + 1
      ENDIF
      aRect[4] -= nWLeg

      IF ::lBordLeg
         aCoord[1]:= aRect[1] - ::nBarD
         aCoord[2]:= aRect[4] + 8
         aCoord[3]:= aRect[1] + nLenL
         aCoord[4]:= aRect[4] + Max(nWLeg,30)
         ::DrawLine( aCoord[1]-1, aCoord[2]-1, aCoord[1]-1, aCoord[4]  , CLR_GRAY )
         ::DrawLine( aCoord[1]-1, aCoord[2]-1, aCoord[3]  , aCoord[2]-1, CLR_GRAY )
         ::DrawLine( aCoord[3]  , aCoord[2]  , aCoord[3]  , aCoord[4]  , CLR_HGRAY)
         ::DrawLine( aCoord[1]  , aCoord[4]  , aCoord[3]  , aCoord[4]  , CLR_HGRAY)
         ::FillRect( aCoord[1], aCoord[2], aCoord[3], aCoord[4], ::nClrBLeg )
      ENDIF

      nColor:=1
      nPos := aRect[1] - ::nBarD + 2
      IF ::nValues == SERIE_VALUES .AND. Len(::aData[1])>1 // Serie
         FOR nFor := 1 TO Len( ::aData[1] )
            ::Say( nPos, aRect[4]+(25*nResH), ::aYVals[nFor], ::aFont[4], ::nClrL )
            ::DrawBar( aRect[4]+(10*nResH), nPos+(9*nResV), 8*nResH, 7*nResV, 1, aColor[nColor] )
            nPos += 15*nResV
            nColor++
            IF nColor>12
               nColor:=1
            ENDIF
         NEXT nFor
      ENDIF
      IF ::nValues == PERIOD_VALUES .OR. Len(::aData[1])=1 // Period
         FOR nFor := 1 TO Len( ::aSeries )
            ::Say( nPos, aRect[4]+(20*nResH), ::aSeries[nFor,1], ::aFont[4], ::nClrL )
            ::DrawBar( aRect[4]+(10*nResH), nPos+(9*nResV), 8*nResH, 7*nResV, 1, ::aSeries[nFor,2] )
            nPos += 15*nResV
            nColor++
            IF nColor>12
               nColor:=1
            ENDIF
         NEXT nFor
      ENDIF
   ENDIF

   aCoord[1]:= aRect[1] - ::nBarD
   aCoord[2]:= aRect[2]
   aCoord[3]:= aRect[3]
   aCoord[4]:= aRect[4]
   ::DrawLine( aCoord[1]-1, aCoord[2]-1, aCoord[1]-1, aCoord[4]  , CLR_GRAY )
   ::DrawLine( aCoord[1]-1, aCoord[2]-1, aCoord[3]  , aCoord[2]-1, CLR_GRAY )
   ::DrawLine( aCoord[3]  , aCoord[2]  , aCoord[3]  , aCoord[4]  , CLR_HGRAY)
   ::DrawLine( aCoord[1]  , aCoord[4]  , aCoord[3]  , aCoord[4]  , CLR_HGRAY)
   ::FillRect( aCoord[1], aCoord[2], aCoord[3], aCoord[4], ::nClrBack )

   IF ::l3D

      nxEdge := ( aCoord[4] - aCoord[2] ) / 4 * 3
      nyEdge := aCoord[3] - aCoord[1]
      nyEdge := Min ( nyEdge , nxEdge  / 3 )

      aGRect[1] := 0
      aGRect[2] := 0
      aGRect[3] := nyEdge
      aGRect[4] := nxEdge
      nX := aCoord[2] + Abs( (aCoord[4]-aCoord[2]) - aGRect[4] ) / 2
      nY := aCoord[1] + Abs( (aCoord[3]-aCoord[1]) - aGRect[3] ) / 2

      aSRect[1] := aGRect[1] + (nY+10*nResV)
      aSRect[2] := aGRect[2] + nX
      aSRect[3] := aGRect[3] + (nY+10*nResV)
      aSRect[4] := aGRect[4] + nX
      SelectObject( hMemCDC, hPen )
      SelectObject( hMemCDC, GetStockObject( 5 ) )

      hBrush  := CreateSolidBrush( ClrShadow( CLR_BROWN, 3 ) )
      hBOld   := SelectObject( hMemCDC, hBrush )
      Ellipse( hMemCDC, aSRect[2], aSRect[1], aSRect[4], aSRect[3] )
      SelectObject( hMemCDC, hBOld )
      DeleteObject( hBrush )

      aGRect[1] += nY - (10*nResV)
      aGRect[2] += nX
      aGRect[3] += nY - (10*nResV)
      aGRect[4] += nX

      hBrush  := CreateSolidBrush( ClrShadow( CLR_BROWN, 3 ) )
      hBOld   := SelectObject( hMemCDC, hBrush )
      FillRect( hMEMCDC, { aGRect[1]+((aGRect[3]-aGRect[1])/2), ;
                           aSRect[2], ;
                           aSRect[3]-((aSRect[3]-aSRect[1])/2),;
                           aSRect[4] }, hBrush )
      SelectObject( hMemCDC, hBOld )
      DeleteObject( hBrush )

   ELSE

      aGRect[1] := aCoord[1] + 10      // Circle
      aGRect[2] := aCoord[2] + 10
      aGRect[3] := aCoord[3] - 10
      aGRect[4] := aCoord[4] - 10

      nDiam := Min( aGRect[3]-aGRect[1], aGRect[4]-aGRect[2] )

      aGRect[1] := 0
      aGRect[2] := 0
      aGRect[3] := aGRect[1] + nDiam
      aGRect[4] := aGRect[2] + nDiam

      nX := aCoord[2] + Abs( (aCoord[4]-aCoord[2]) - aGRect[4] ) / 2
      nY := aCoord[1] + Abs( (aCoord[3]-aCoord[1]) - aGRect[3] ) / 2

      aGRect[1] += nY
      aGRect[2] += nX
      aGRect[3] += nY
      aGRect[4] += nX

   ENDIF

   nAngle := ::nPieSt
   aPT1   := CountPoint( aGRect, nAngle )

   FOR nCount := 1 TO Len( aItems )

      hBru1 := CreateSolidBrush( aItems[nCount,2] )
      hBruO := SelectObject( hMemCDC, hBru1 )
      SelectObject( hMemCDC, GetStockObject( 8 ) )
      nAngle += aItems[nCount,1]
      nAngT := nAngle - aItems[nCount,1]
      aPT2  := CountPoint( aGRect, nAngle )

      IF (nAngle-nAngT)>1
         Pie( hMemCDC, aGRect[1], aGRect[2], aGRect[3]+1, aGRect[4]+1, ;
                       aPT2[2], aPT2[1], aPT1[2], aPT1[1] )
      ENDIF
      SelectObject( hMemCDC, hPen )
      IF Len( aItems ) > 1
         MoveTo( hMemCDC, aPT1[1], aPT1[2] )
         LineTo( hMemCDC, ((aGRect[4]-aGRect[2]) / 2) + aGRect[2], ; // Center
                          ((aGRect[3]-aGRect[1]) / 2) + aGRect[1] )
         MoveTo( hMemCDC, aPT2[1], aPT2[2] )
         LineTo( hMemCDC, ((aGRect[4]-aGRect[2]) / 2) + aGRect[2], ; // Center
                          ((aGRect[3]-aGRect[1]) / 2) + aGRect[1] )
         IF ::l3D .AND. aItems[nCount,1]<>0
            nAngT := nAngle - aItems[nCount,1]
            aPt3  := CountPoint( aGRect, nAngT )
            IF nAngle > 100 .AND. nAngT < 260
               hBrDark := CreateSolidBrush( ClrShadow( aItems[nCount,2], 48 ) )
               hBru1 := SelectObject( hMemCDC, hBrDark )
               IF nAngle < 270
                  MoveTo( hMemCDC, aPT2[1], aPT2[2] )
                  LineTo( hMemCDC, aPT2[1], aPT2[2] + 20*nResV )
                  FOR nI=3 TO 5
                     nClr := GetPixel( hMemCDC, aPt2[1]+(1*nResV), aPt2[2]+(nI*nResH) )
                     ExtFloodFill( hMemCDC, aPt2[1]+(1*nResV), aPt2[2]+(nI*nResH), nClr, 1 )
                  NEXT nI
               ELSE
                  IF nAngT <  90
                     nAngT := nAngle - (aItems[nCount,1]/2)
                     aPt3  := CountPoint( aGRect, nAngT )
                  ENDIF
                  FOR nI=3 TO 5
                     nClr := GetPixel( hMemCDC, aPt3[1]-(1*nResV), aPt3[2]+(nI*nResH) )
                     ExtFloodFill( hMemCDC, aPt3[1]-(1*nResV), aPt3[2]+(nI*nResH), nClr, 1 )
                  NEXT nI
               ENDIF
               SelectObject( hMemCDC, hBru1 )
               DeleteObject( hBrDark )
            ENDIF
         ENDIF
      ENDIF

      hOldFont := SelectObject( hMemCDC, ::aFont[2]:hFont )
      SetBkMode( hMemCDC, 1 ) // Transparent

      IF aItems[nCount,1] > 3
         nAngT   := nAngle - (aItems[nCount,1] / 2)
         aPt3    := CountPoint( aGRect, nAngT )
         hMyDC   := hMemCDC
         hMemCDC := ::oWnd:GetDC()
         cText   := Tran( aItems[nCount,1]*100/360, "999%" )
         nSizeX  := GetTextWidth( hMemCDC, cText ) * nResH
         nSizeY  := Abs(::aFont[2]:nHeight) * nResV
         ::oWnd:ReleaseDC()
         hMemCDC := hMyDC
         IF     nAngT >=   0 .AND. nAngT <  20
            nSepX:=  5              ; nXSep:= 20
            nSepY:= -8              ; nYSep:=  0
         ELSEIF nAngT >=   0 .AND. nAngT <  45
            nSepX:= 25              ; nXSep:= 20
            nSepY:= -5              ; nYSep:=  0
         ELSEIF nAngT >=  45 .AND. nAngT <  90
            nSepX:= 25              ; nXSep:= 25
            nSepY:= -5              ; nYSep:=- 5
         ELSEIF nAngT >=  90 .AND. nAngT < 135
            nSepX:= 25              ; nXSep:= 40
            nSepY:= IF(::l3D,25, 5) ; nYSep:=-20
         ELSEIF nAngT >= 135 .AND. nAngT < 180
            nSepX:= 25              ; nXSep:= 20
            nSepY:= IF(::l3D,25, 5) ; nYSep:=-20
         ELSEIF nAngT >= 180 .AND. nAngT < 225
            nSepX:=-15              ; nXSep:= 10
            nSepY:= IF(::l3D,25, 5) ; nYSep:=-20
         ELSEIF nAngT >= 225 .AND. nAngT < 270
            nSepX:=-15              ; nXSep:=-20
            nSepY:= IF(::l3D,25, 5) ; nYSep:=-20
         ELSEIF nAngT >= 270 .AND. nAngT < 315
            nSepX:=-20              ; nXSep:= 0
            nSepY:= -5              ; nYSep:= 0
         ELSEIF nAngT >= 315 .AND. nAngT < 360
            nSepX:=-20              ; nXSep:= 0
            nSepY:= -8              ; nYSep:= 0
         ENDIF
         nColr := IF(aValrs[nCount]<0,CLR_RED,::nClrX)
         ::Say(aPt3[2]-(nSizeY/2)+nSepY,aPt3[1]-(nSizeX/2)+nSepX,cText,::aFont[8],nColr)
         IF ::lViewVal
            cVals := Tran( aValrs[nCount],::cPicture )
            ::Say(aPt3[2]+(nSizeY/2)+nYSep,aPt3[1]-(nSizeX/2)-nXSep,cVals,::aFont[9],nColr)
         ENDIF
      ENDIF

      SelectObject( hMemCDC, hOldFont )
      SelectObject( hMemCDC, hBruO )

      DeleteObject( hBru1 )

      aPT1[1] := aPT2[1]
      aPT1[2] := aPT2[2]
   NEXT nCount

   IF !Empty( ::cTitY )
      nWText := GetTextWidth( ::cTitY, ::aFont[9] )
      nCol   := aCoord[4]-nWText-25
      nRow   := aCoord[3]-25
      IF ::aSTitle[4]
         ::Say( nRow+1.5, nCol+1.5, ::cTitY, ::aFont[9], CLR_HGRAY, ::nTRight )
      ENDIF
      ::Say( nRow, nCol, ::cTitY, ::aFont[9], ::nClrYT, ::nTRight )
   ENDIF

   IF nSum==0
      aPT2  := CountPoint( aGRect, nAngle )
      hBru1 := CreateSolidBrush( CLR_WHITE )
      hBruO := SelectObject( hMemCDC, hBru1 )
      SelectObject( hMemCDC, GetStockObject( 8 ) )
      Pie( hMemCDC, aGRect[1], aGRect[2], aGRect[3]+1, aGRect[4]+1, ;
                    aPT2[2], aPT2[1], aPT1[2], aPT1[1] )
      SelectObject( hMemCDC, hPen )
   ENDIF

   SelectObject( hMemCDC, hPen )
   SelectObject( hMemCDC, GetStockObject( 5 ) )

   Ellipse( hMemCDC, aGRect[2], aGRect[1], aGRect[4], aGRect[3] )

   SelectObject( hMemCDC, hOldPen )
   SelectObject( hMemCDC, hBOld )
   DeleteObject( hPen )
   DeleteObject( hBrush )

RETURN (Nil)


METHOD _CreatePen( nColor ) CLASS TGraph

   IF ::nClr != nColor
      ::DeletePen()
      ::nClr    := nColor
      ::hPen    := CreatePen( 0, ::nPenWidth, nColor)
      ::hOldPen := SelectObject( ::hDC, ::hPen )
   ENDIF

RETURN (.T.)


METHOD DeletePen() CLASS TGraph

   IF ::hOldPen   != -1
      SelectObject( ::hDC, ::hOldPen )
      if( !Empty( ::hPen ), DeleteObject( ::hPen ), )
      ::hPen      = -1
      ::hOldPen   = -1
   ENDIF

RETURN (Nil)


METHOD _FillRect( nTop, nLeft, nBottom, nRight, nColor ) CLASS TGraph

   LOCAL hBru, hOld

   hBru := CreateSolidBrush( nColor )
   hOld := SelectObject( ::hDC, hBru )
   FillRect( ::hDC, { nTop, nLeft, nBottom, nRight }, hBru )
   SelectObject( ::hDC, hOld )
   DeleteObject( hBru )

RETURN (Nil)


METHOD Print( oPrn, nTop, nLeft, nWidth, nHeight ) CLASS TGraph

   LOCAL nRight, nBottom, nI
   LOCAL cOldBitmap:= ::cBitmap
   LOCAL aOldF := { oClone( ::aFont[1] ), oClone( ::aFont[2] ), ;
                    oClone( ::aFont[3] ), oClone( ::aFont[4] ), ;
                    oClone( ::aFont[5] ), oClone( ::aFont[6] ), ;
                    oClone( ::aFont[7] ), oClone( ::aFont[8] ), ;
                    oClone( ::aFont[9] ) }
   ::oPrn    := oPrn
   ::nTRight := 1
   ::nTLeft  := 0
   ::nTCent  := 2
   ::cBitmap := " "

   nRight    := nLeft + nWidth
   nBottom   := nTop  + nHeight

   ::oWnd:ReleaseDC()

   DEFINE FONT ::aFont[1] NAME aOldF[1]:cFaceName SIZE 0,-aOldF[1]:nHeight+3 OF oPrn BOLD
   DEFINE FONT ::aFont[2] NAME aOldF[2]:cFaceName SIZE 0,-aOldF[2]:nHeight+3 OF oPrn
   DEFINE FONT ::aFont[3] NAME aOldF[3]:cFaceName SIZE 0,-aOldF[3]:nHeight+3 OF oPrn
   DEFINE FONT ::aFont[4] NAME aOldF[4]:cFaceName SIZE 0,-aOldF[4]:nHeight+3 OF oPrn
   DEFINE FONT ::aFont[5] NAME aOldF[5]:cFaceName SIZE 0,-aOldF[5]:nHeight+3 OF oPrn
   DEFINE FONT ::aFont[6] NAME aOldF[6]:cFaceName SIZE 0,-aOldF[6]:nHeight+3 OF oPrn NESCAPEMENT 898
   DEFINE FONT ::aFont[7] NAME aOldF[7]:cFaceName SIZE 0,-aOldF[7]:nHeight+3 OF oPrn
   DEFINE FONT ::aFont[8] NAME aOldF[8]:cFaceName SIZE 0,-aOldF[8]:nHeight+3 OF oPrn
   DEFINE FONT ::aFont[9] NAME aOldF[9]:cFaceName SIZE 0,-aOldF[9]:nHeight+3 OF oPrn

   ::hDC := oPrn:hDCOut
   ::Paint( nTop, nLeft, nBottom, nRight )
   ::hDC := Nil

   FOR nI = 1 TO 9
      ::aFont[nI]:End()
      ::aFont[nI] := aOldF[nI]
   NEXT nI

   ::cBitmap := cOldBitmap
   ::oPrn    := NIL
   ::nTLeft  := 0
   ::nTRight := 2
   ::nTCent  := 6

RETURN (Nil)


Static Function CountPoint( aRect, nAngle ) // CLASS TGraph

   LOCAL dAngle, rX, rY, nX, nY, nRX, nRY

   DO WHILE nAngle <   0
      nAngle += 360
   ENDDO
   DO WHILE nAngle > 359
      nAngle -= 360
   ENDDO

   dAngle := nAngle * PI()   / 180.0
   rX := (aRect[3]-aRect[1]) /   2.0
   rY := (aRect[4]-aRect[2]) /   2.0

   nRX := rY * Sin( dAngle )
   nRY := 0.0 - ( rX * Cos( dAngle ) )
   nX  := nRX + ( ( aRect[4] + aRect[2] ) / 2.0 )
   nY  := nRY + ( ( aRect[3] + aRect[1] ) / 2.0 )

RETURN ( { nX, nY } )


METHOD DrawBox( nY, nX, nHigh, nWidth, nDeep ) CLASS TGraph

   // Set Border
   ::DrawLine(nX, nY       , nX-nHigh+nDeep , nY        , CLR_BLACK )       // Left
   ::DrawLine(nX, nY+nWidth, nX-nHigh+nDeep , nY+nWidth , CLR_BLACK )       // Right
   ::DrawLine(nX-nHigh+nDeep, nY, nX-nHigh+nDeep , nY+nWidth , CLR_BLACK )  // Top
   ::DrawLine(nX, nY, nX , nY+nWidth , CLR_BLACK )                          // Bottom
   IF ::l3D
      // Set shadow
      ::DrawLine(nX-nHigh+nDeep, nY+nWidth, nX-nHigh, nY+nDeep+nWidth, CLR_BLACK )
      ::DrawLine(nX, nY+nWidth, nX-nDeep, nY+nWidth+nDeep, CLR_BLACK )
      IF nHigh > 0
         ::DrawLine(nX-nDeep, nY+nWidth+nDeep, nX-nHigh, nY+nWidth+nDeep, CLR_BLACK )
         ::DrawLine(nX-nHigh, nY+nDeep, nX-nHigh , nY+nWidth+nDeep , CLR_BLACK )
         ::DrawLine(nX-nHigh+nDeep, nY, nX-nHigh, nY+nDeep  , CLR_BLACK )
      ELSE
         ::DrawLine(nX-nDeep, nY+nWidth+nDeep, nX-nHigh+1, nY+nWidth+nDeep, CLR_BLACK )
         ::DrawLine(nX, nY, nX-nDeep, nY+nDeep  , CLR_BLACK )
      ENDIF
   ENDIF

RETURN ( NIL )

METHOD Save2Bmp( cFile ) CLASS TGraph

   LOCAL hBmp, hDib
   DEFAULT cFile := "TGraph.Bmp"

   hBmp := WndBitmap( Self:hWnd )
   hDib := DibFromBitmap( hBmp )
   DibWrite( cFile, hDib )
   GloBalFree( hDib )
   DeleteObject( hBmp )

RETURN ( FILE( cFile ) )


METHOD Copy2ClipBoard() CLASS TGraph
/*
   LOCAL oClip := TClipBoard():New( CF_BITMAP, ::oWnd )

   IF oClip:Open()
      oClip:Empty()
      oClip:SetData ( WndBitmap ( ::hWnd ) )
      oClip:End()
   ELSE
      msgStop( "The clipboard is not available now!" )
   ENDIF
*/
   WndCopy( Self:hWnd, .F., .T. )
   IF ::nLanguage=2
      MsgInfo("La imagen ha sido enviada al portapapeles.","Información")
   ELSE
      MsgInfo("Graph image on clipboard.","Info")
   ENDIF
RETURN (Nil)


METHOD PopMenu( nRow, nCol, nKey ) CLASS TGraph

   LOCAL oPopup, oItem[15], nOpt:=0, cFile
   LOCAL aLang, nI:=::nLanguage, cMsg

   aLang:={ {"&View",               ;      // English
                "&3D",              ;
                "&Titles" ,         ;
                "&X Values",        ;
                "&Y Labels",        ;
                "&Legends",         ;
                "&Values",          ;
                "X &Grid",          ;
                "Y G&rid",          ;
                "&Bar border",      ;
             "Graph &Type",         ;
                "&Bar",             ;
                "&Line",            ;
                "&Point",           ;
                "P&ie",             ;
             "&Background",         ;
                "&Select",          ;
                "&Remove",          ;
             "&Copy" },             ;
             {"&Ver",               ;      // Spanish
                 "&3D",             ;
                 "&Títulos",        ;
                 "Valores en &X",   ;
                 "Etiquetas en &Y", ;
                 "&Leyendas",       ;
                 "&Valores",        ;
                 "&Rejilla en X",   ;
                 "Re&jilla en Y",   ;
                 "&Bordes",         ;
              "Gráfica &tipo",      ;
                 "&Barras",         ;
                 "&Líneas",         ;
                 "&Puntos",         ;
                 "P&ie",            ;
              "Imagen de &fondo",   ;
                 "&Selecionar",     ;
                 "&Remover",        ;
              "&Copiar" } }

   MENU oPopUp POPUP
      SEPARATOR
      IF ::lSelView
         MENUITEM aLang[nI, 1]
            MENU
               MENUITEM oItem[ 1] PROMPT aLang[nI, 2] ACTION ( ::l3D      := !::l3D     , ::Refresh() )
               MENUITEM oItem[ 2] PROMPT aLang[nI, 3] ACTION ( ::lTitle   := !::lTitle  , ::Refresh() )
               IF ::nType <> GRAPH_TYPE_PIE
                  MENUITEM oItem[ 3] PROMPT aLang[nI, 4] ACTION ( ::lxVal    := !::lxVal   , ::Refresh() )
                  MENUITEM oItem[ 4] PROMPT aLang[nI, 5] ACTION ( ::lyVal    := !::lyVal   , ::Refresh() )
               ENDIF
               MENUITEM oItem[ 5] PROMPT aLang[nI, 6] ACTION ( ::lLegends := !::lLegends, ::Refresh() )
               MENUITEM oItem[ 6] PROMPT aLang[nI, 7] ACTION ( ::lViewVal := !::lViewVal, ::Refresh() )
               IF ::nType <> GRAPH_TYPE_PIE
                  MENUITEM oItem[ 7] PROMPT aLang[nI, 8] ACTION ( ::lxGrid   := !::lxGrid  , ::Refresh() )
                  MENUITEM oItem[ 8] PROMPT aLang[nI, 9] ACTION ( ::lyGrid   := !::lyGrid  , ::Refresh() )
               ENDIF
               IF ::nType == GRAPH_TYPE_BAR
                  MENUITEM oItem[ 9] PROMPT aLang[nI,10] ACTION ( ::lBorders := !::lBorders, ::Refresh() )
               ENDIF
            ENDMENU
      ENDIF
      MENUITEM aLang[nI,11]
         MENU
            MENUITEM oItem[10] PROMPT aLang[nI,12] ACTION ( ::nType := GRAPH_TYPE_BAR   , ::Refresh() )
            MENUITEM oItem[11] PROMPT aLang[nI,13] ACTION ( ::nType := GRAPH_TYPE_LINE  , ::Refresh() )
            MENUITEM oItem[12] PROMPT aLang[nI,14] ACTION ( ::nType := GRAPH_TYPE_POINT , ::Refresh() )
            MENUITEM oItem[13] PROMPT aLang[nI,15] ACTION ( ::nType := GRAPH_TYPE_PIE   , ::Refresh() )
         ENDMENU
      IF ::lSelBack
         MENUITEM aLang[nI,16]
            MENU
               MENUITEM oItem[14] PROMPT aLang[nI,17] ACTION nOpt:=1
               MENUITEM oItem[15] PROMPT aLang[nI,18] ACTION nOpt:=2
            ENDMENU
         SEPARATOR
      ENDIF
      MENUITEM aLang[nI,19] ACTION nOpt:=3
      SEPARATOR

   ENDMENU

   IF ::lSelView
      oItem[ 1]:SetCheck(::l3D)
      oItem[ 2]:SetCheck(::lTitle)
      IF ::nType <> GRAPH_TYPE_PIE
         oItem[ 3]:SetCheck(::lxVal)
         oItem[ 4]:SetCheck(::lyVal)
      ENDIF
      oItem[ 5]:SetCheck(::lLegends)
      oItem[ 6]:SetCheck(::lViewVal)
      IF ::nType <> GRAPH_TYPE_PIE
         oItem[ 7]:SetCheck(::lxGrid)
         oItem[ 8]:SetCheck(::lyGrid)
      ENDIF
      IF ::nType == GRAPH_TYPE_BAR
         oItem[ 9]:SetCheck(::lBorders)
      ENDIF
   ENDIF
   oItem[10]:SetCheck(IF(::nType=GRAPH_TYPE_BAR  ,.T.,.F.))
   oItem[11]:SetCheck(IF(::nType=GRAPH_TYPE_LINE ,.T.,.F.))
   oItem[12]:SetCheck(IF(::nType=GRAPH_TYPE_POINT,.T.,.F.))
   oItem[13]:SetCheck(IF(::nType=GRAPH_TYPE_PIE  ,.T.,.F.))
   IF ::lSelBack
      oItem[14]:SetCheck(IF(File(::cBitmap),.F.,.T.))
      oItem[15]:SetCheck(IF(File(::cBitmap),.T.,.F.))
   ENDIF
   IF Len(::aData[1])<=1
      oItem[11]:Disable()
      oItem[12]:Disable()
   ENDIF
   ACTIVATE POPUP oPopup OF ::oWnd AT nRow, nCol

   DO CASE
      CASE nOpt = 1
         cMsg := IF ( ::nLanguage=2,"Seleccione imagen de fondo","Select background image" )
         #ifdef __CLIPPER__
           IF !Empty( ( cFile:=cGetFile("Bitmaps|*.bmp","" ) ) )
         #else
           IF !Empty( ( cFile:=cGetFile("Bitmaps|*.bmp","" ) ) )
         #endif
            ::cBitmap:= cFile
            ::Refresh( .F. )
         ENDIF
      CASE nOpt = 2
         ::cBitmap:= ""
         ::Refresh(.F.)
      CASE nOpt = 3
         ::Copy2Clipboard()
      CASE nOpt = 4
         ::Save2Bmp()
   ENDCASE

RETURN (Nil)

// --------------------------------------------------------------------------

static FUNCTION DetMaxVal(nNum)
   LOCAL nE, nMax, nMan, nVal, nOffset
   nE:=9
   nVal:=0
   nNum:=Abs(nNum)
   DO WHILE .T.
      nMax := 10**nE
      IF Int(nNum/nMax)>0
         nMan:=(nNum/nMax)-Int(nNum/nMax)
         nOffset:=1
         nOffset:=IF(nMan<=.75,.75,nOffset)
         nOffset:=IF(nMan<=.50,.50,nOffset)
         nOffset:=IF(nMan<=.25,.25,nOffset)
         nOffset:=IF(nMan<=.00,.00,nOffset)
         nVal := (Int(nNum/nMax)+nOffset)*nMax
         EXIT
      ENDIF
      nE--
   ENDDO
RETURN (nVal)


static FUNCTION RGB2HSL( nR, nG, nB )

   LOCAL nMax, nMin
   LOCAL nH, nS, nL

   IF nR < 0
      nR := Abs( nR )
      nG := nRGBGreen( nR )
      nB := nRGBBlue( nR )
      nR := nRGBRed( nR )
   ENDIF

   nR := nR / 255
   nG := nG / 255
   nB := nB / 255
   nMax := Max( nR, Max( nG, nB ) )
   nMin := Min( nR, Min( nG, nB ) )
   nL := ( nMax + nMin ) / 2

   IF nMax = nMin
      nH := 0
      nS := 0
   ELSE
      IF nL < 0.5
         nS := ( nMax - nMin ) / ( nMax + nMin )
      ELSE
         nS := ( nMax - nMin ) / ( 2.0 - nMax - nMin )
      ENDIF
      DO CASE
         CASE nR = nMax
            nH := ( nG - nB ) / ( nMax - nMin )
         CASE nG = nMax
            nH := 2.0 + ( nB - nR ) / ( nMax - nMin )
         CASE nB = nMax
            nH := 4.0 + ( nR - nG ) / ( nMax - nMin )
      ENDCASE
   ENDIF

   nH := Int( (nH * 239) / 6 )
   IF nH < 0 ; nH += 240 ; ENDIF
   nS := Int( nS * 239 )
   nL := Int( nL * 239 )

RETURN { nH, nS, nL }


static FUNCTION HSL2RGB( nH, nS, nL )

   LOCAL nFor                // Toninho@fwi
   LOCAL nR, nG, nB
   LOCAL nTmp1, nTmp2, aTmp3 := { 0, 0, 0 }

   nH /= 239
   nS /= 239
   nL /= 239
   IF nS == 0
      nR := nL
      nG := nL
      nB := nL
   ELSE
      IF nL < 0.5
         nTmp2 := nL * ( 1 + nS )
      ELSE
         nTmp2 := nL + nS - ( nL * nS )
      ENDIF
      nTmp1 := 2 * nL - nTmp2
      aTmp3[1] := nH + 1 / 3
      aTmp3[2] := nH
      aTmp3[3] := nH - 1 / 3
      FOR nFor := 1 TO 3
         IF aTmp3[nFor] < 0
            aTmp3[nFor] += 1
         ENDIF
         IF aTmp3[nFor] > 1
            aTmp3[nFor] -= 1
         ENDIF
         IF 6 * aTmp3[nFor] < 1
            aTmp3[nFor] := nTmp1 + ( nTmp2 - nTmp1 ) * 6 * aTmp3[nFor]
         ELSE
            IF 2 * aTmp3[nFor] < 1
               aTmp3[nFor] := nTmp2
            ELSE
               IF 3 * aTmp3[nFor] < 2
                  aTmp3[nFor] := nTmp1 + ( nTmp2 - nTmp1 ) * ( ( 2 / 3 ) - aTmp3[nFor] ) * 6
               ELSE
                  aTmp3[nFor] := nTmp1
               ENDIF
            ENDIF
         ENDIF
      NEXT nFor
      nR := aTmp3[1]
      nG := aTmp3[2]
      nB := aTmp3[3]
   ENDIF

RETURN { Int( nR * 255 ), Int( nG * 255 ), Int( nB * 255 ) }

// --------------------------------------------------------------------------

static FUNC PI(); RETURN (3.1415926536)

static FUNC RadToDeg(x); RETURN (180.0*x/PI())

static FUNC DegToRad(x); RETURN (x*PI()/180.0)

static FUNC Signo(nValue)
RETURN (IF(nValue<0, -1.0, 1.0))

// --------------------------------------------------------------------------

FUNCTION GetPrtCoors(oGraph)

   LOCAL oDlg,;
         nTop        := 2.5,;
         nLeft       := 2.5,;
         nHeight     := 8.0,;
         nWidth      := 9.5,;
         aPrinters   := GetPrinters(),;
         cPrinter    := PrnGetName(),;
         lPrnDefault := .t.

   DEFINE DIALOG oDlg RESOURCE "IMP_GRAPH"

   REDEFINE GET   nTop ;
         ID       100 ;
         PICTURE  "99.99" ;
         SPINNER ;
         OF       oDlg

   REDEFINE GET   nLeft ;
         ID       110 ;
         PICTURE  "99.99" ;
         SPINNER ;
         OF       oDlg

   REDEFINE GET   nHeight ;
         ID       120 ;
         PICTURE  "99.99" ;
         SPINNER ;
         OF       oDlg

   REDEFINE GET   nWidth ;
         ID       130 ;
         PICTURE  "99.99" ;
         SPINNER ;
         OF       oDlg

   REDEFINE CHECKBOX lPrnDefault ;
         ID       140 ;
         OF       oDlg

   REDEFINE COMBOBOX cPrinter ;
         ITEMS    aPrinters ;
         WHEN     !lPrnDefault ;
         ID       150 ;
         OF       oDlg

   REDEFINE BUTTON ;
         ID       IDOK ;
         OF       oDlg ;
         ACTION   ( PrintGraph( oGraph, nTop, nLeft, nWidth, nHeight, lPrnDefault, cPrinter ), oDlg:End() )

   REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       oDlg ;
         ACTION   ( oDlg:End() )

   oDlg:AddFastKey( VK_F5, {|| PrintGraph( oGraph, nTop, nLeft, nWidth, nHeight, lPrnDefault, cPrinter ), oDlg:End() } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( nil )

// --------------------------------------------------------------------------

FUNCTION PrintGraph( oGraph, nTop, nLeft, nWidth, nHeight, lPrnDefault, cPrinter )

   LOCAL oPrn

   if !Empty( cPrinter ) .and. !lPrnDefault
      PRINT oPrn NAME oGraph:cTitle PREVIEW TO cPrinter
   else
      PRINT oPrn NAME oGraph:cTitle PREVIEW
   end if

      oPrn:Cmtr2Pix( @nTop  , @nLeft )    // you can change to inchs

      oPrn:Cmtr2Pix( @nWidth, @nHeight )

      PAGE

         oGraph:Print( oPrn, nTop, nLeft, nWidth, nHeight )

      ENDPAGE

   ENDPRINT

RETURN Nil

// --------------------------------------------------------------------------

Function GraphPropierties( oGraph )

   local oCbx
   local aType    := { "Barras", "Lineas", "Puntos", "Tarta", "Combinado" }
   local oDlg
   local oPnt
   local aPoint   := { "Punto", "Cruz", "Forma" }
   local cPoint   := aPoint[ oGraph:nPoint ]
   local nType    := oGraph:nType
   local cType    := aType[ nType ]
   local l3D      := oGraph:l3D
   local lTitle   := oGraph:lTitle
   local lxVal    := oGraph:lxVal
   local lyVal    := oGraph:lyVal
   local lLegends := oGraph:lLegends
   local lxGrid   := oGraph:lxGrid
   local lyGrid   := oGraph:lyGrid
   local nXRanges := oGraph:nXRanges
   local nBarD    := oGraph:nBarD
   local nValues  := oGraph:nValues
   local cTitle   := PadR( oGraph:cTitle, 50 )
   local cPicture := oGraph:cPicture
   local lViewVal := oGraph:lViewVal

   DEFINE DIALOG oDlg RESOURCE "Prop_Graph"

      REDEFINE CHECKBOX l3d      ID 101 OF oDlg

      REDEFINE CHECKBOX lTitle   ID 102 OF oDlg

      REDEFINE CHECKBOX lxVal    ID 103 OF oDlg

      REDEFINE CHECKBOX lyVal    ID 104 OF oDlg

      REDEFINE CHECKBOX lLegends ID 105 OF oDlg

      REDEFINE CHECKBOX lxGrid   ID 106 OF oDlg

      REDEFINE CHECKBOX lyGrid   ID 107 OF oDlg

      REDEFINE GET nXRanges      ID 108 OF oDlg PICTURE "99" SPINNER

      REDEFINE GET nBarD         ID 109 OF oDlg PICTURE "99" SPINNER

      REDEFINE COMBOBOX oCbx     VAR cType   ITEMS aType    ID 110 OF oDlg

      REDEFINE COMBOBOX oPnt     VAR cPoint  ITEMS aPoint   ID 112 OF oDlg;
            BITMAPS              { "Point13", "Cross13", "Shape13" } ;

      REDEFINE GET cTitle        ID 115 OF oDlg

      REDEFINE GET cPicture      ID 116 OF oDlg PICTURE "@X"

      REDEFINE CHECKBOX lViewVal ID 117 OF oDlg

      REDEFINE BUTTON            ID   1 OF oDlg ACTION oDlg:End( IDOK )

      REDEFINE BUTTON            ID   2 OF oDlg ACTION oDlg:End() CANCEL

      oDlg:AddFastKey( VK_F5, {|| oDlg:End( IDOK ) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oGraph:l3D        := l3D
      oGraph:lTitle     := lTitle
      oGraph:lxVal      := lxVal
      oGraph:lyVal      := lyVal
      oGraph:lLegends   := lLegends
      oGraph:lxGrid     := lxGrid
      oGraph:lyGrid     := lyGrid
      oGraph:nXRanges   := nXRanges
      oGraph:nBarD      := nBarD
      oGraph:nValues    := nValues
      oGraph:cTitle     := cTitle
      oGraph:cPicture   := cPicture
      oGraph:nType      := nType
      oGraph:lViewVal   := lViewVal
      oGraph:nType      := oCbx:nAt
      oGraph:nPoint     := oPnt:nAt

      oGraph:Refresh()

   end if

Return ( nil )