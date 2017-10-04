/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: class TReport                                              ³
³         File: REPORT.PRG                                                 ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (Ignacio_Ortiz)                              ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 07/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#include "FiveWin.Ch"
#include "objects.ch"
#include "report.ch"

#define GRID_ABOVE       0
#define GRID_BELOW       1
#define GRID_ABOBEL      2

#define PORTRAIT         1
#define LANDSCAPE        2

#define TXT_CANCEL ;
        LoadString( GetResources(), 1 )
#define TXT_PRINTING_PAGE ;
        LoadString( GetResources(), 2 )
#define TXT_PREVIEW ;
        LoadString( GetResources(), 3 )
#define TXT_BUILDING_PAGE ;
        LoadString( GetResources(), 4 )
#define TXT_REPORT_WIDTH ;
        LoadString( GetResources(), 5 )
#define TXT_ATENTION ;
        LoadString( GetResources(), 6 )

#ifdef __XPP__
   #define New  _New
#endif

//----------------------------------------------------------------------------//

CLASS TReport

   DATA oDevice, oTitle, oHeader, oFooter, oRptWnd, oShdBrush, oPenHorz
   DATA aGroups, aColumns, aFont, aCols, aText, aData, aPen, ;
        aDataHeight, aClrText
   DATA bFor, bWhile , bInit, bEnd, bStartLine, bEndLine, bStartPage, ;
        bEndPage, bStartGroup, bEndGroup, bSkip, bStdFont, bPreview, ;
        bChange, bPostEnd, bPostPage, bPostGroup, bStartRecord, bEndRecord
   DATA cRptFile, cResName, cFile, cName, cPageTotal, cGrandTotal,;
        cCharPattern
   DATA nWidth, nHeight, nMargin, nRow, nPage, nMaxTitle, nMaxData,;
        nSeparator, nLeftMargin, nRightMargin, nTopMargin, nDnMargin,;
        nTitleRow, nBottomRow, nStdLineHeight, nRptWidth, nLogPixX,;
        nLogPixY, nFirstdrow, nLastdrow, nTitleHeight, nCounter,;
        nTotalLine, nGroupLine, nTitleUpLine, nTitleDnLine, nClrShadow,;
        nDataLine
   DATA hOldRes
   DATA lSummary, lTotal, lFinish, lStable, lGroup, lPrinter, lScreen,;
        lFirstRow, lCreated, lBreak, lShadow, lGrid, lJoin, lSeparator,;
        lAutoLand, lIsNarrow, lBoxOnTotal, lNoCancel, lPageTotal
   DATA Cargo

   CLASSDATA lOnProcess

   METHOD New( aTitle, aHead, aFoot, aFont, lSummary, cRptFile, ;
               cResName, lPrinter, lScreen, cFile, oDevice, ;
               cName, cTFmt, cHFmt, cFFmt ) CONSTRUCTOR

   //METHOD FromFile() CONSTRUCTOR    Not available yet!
   //METHOD Resource() CONSTRUCTOR    Not available yet!

   METHOD AddColumn(oColumn) INLINE Aadd(::aColumns,oColumn)

   METHOD DelColumn(nColumn) INLINE Adel(::aColumns,nColumn) ,;
                                    Asize(::aColumns,len(::aColumns)-1)

   METHOD InsColumn(oColumn ,;
                     nColumn) INLINE Ains(::aColumns,nColumn) ,;
                                     ::aColumns[nColumn]:= oColumn

   METHOD AddGroup(oGroup)   INLINE Aadd(::aGroups,oGroup)

   METHOD DelGroup(nGroup)   INLINE Adel(::aGroups,nGroup)   ,;
                                    Asize(::aGroups,len(::aGroups)-1)

   METHOD Stabilize()
   METHOD Skip(n)

   METHOD Init()
   METHOD End()

   METHOD StartLine(nHeight)
   METHOD EndLine(nHeight)
   METHOD StartGroup(nGroup)
   METHOD EndGroup(nGroup)
   METHOD StartPage()
   METHOD EndPage()
   METHOD NeedNewPage() INLINE (::nRow+::nStdLineHeight >= ::nBottomRow)

   METHOD NewLine( nHeight )  INLINE ( ::StartLine( nHeight ), iif( !::lFirstRow, ::EndLine( nHeight ), ) )

   METHOD BackLine( nLine )

   METHOD ColTitle()
   METHOD TotalLine(cChar, nGrid)
   METHOD PageTotal()

   METHOD Activate(bFor, bWhile, bInit, bEnd, bStartPage, ;
                   bEndPage, bStartGroup, bEndGroup, ;
                   bStartLine, bEndLine, bChange )

   METHOD Play()

   METHOD Margin(nValue,nType,nScale)

   METHOD Say(nCol, xText, nFont, nPad, nRow)

   METHOD SayBitmap(nRow, nCol, cBitmap, nWidth, nHeight, nScale)
   METHOD Box(nRow, nCol, nBottom, nRight, nPen, nScale )
   METHOD Line( nTop, nLeft, nBottom, nRight, nPen, nScale )
   METHOD Shadow(nHeight)
   METHOD Grid(nHeight, nRow, cChar)
   METHOD Separator(nPen, nRow)

   METHOD CellView() INLINE ::lJoin       := .T. ,;
                            ::lSeparator  := .f. ,;//.t.
                            ::lBoxOnTotal := .T. ,;
                            Aeval(::aColumns,{|val| val:lGrid := .T.})

   METHOD UderLine() INLINE ::lJoin       := .f. ,;
                            ::lSeparator  := .f. ,;
                            ::lBoxOnTotal := .f. ,;
                            Aeval(::aColumns,{|val| val:lUnderLine := .t.})

   METHOD PhyWidth(nScale) INLINE ;
                  ( iif(nScale==NIL,nScale:=1 ,),;
                    PrnGetSize(::oDevice:hDC)[1] / ::nLogPixX * ;
                    iif(nScale==1 ,1 ,2.54)                     )

   METHOD PhyHeight(nScale) INLINE ;
                  ( iif(nScale==NIL,nScale:=1 ,),;
                    PrnGetSize(::oDevice:hDC)[2] / ::nLogPixY * ;
                    iif(nScale==1 ,1 ,2.54)                     )

   METHOD SetTxtColor(nColor,nFont) INLINE                          ;
                  (iif(nColor != NIL .AND.                          ;
                       nFont   > 0   .AND.                          ;
                       nFont   <= len(::aClrText)                  ,;
                       ::aClrText[nFont] := nColor, ) )

   METHOD SetShdColor(nColor) INLINE ::nClrShadow := nColor

   METHOD SetPenColor(nColor)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( aTitle, aHead, aFoot, aFont, aPen, lSummary, cRptFile, ;
            cResName, lPrinter, lScreen, cFile, oDevice, cName,;
            cTFmt, cHFmt, cFFmt) CLASS TReport

   LOCAL nTFmt, nHFmt, nFFmt

   LOCAL lFontDefined := .T. ,;
         lPenDefined  := .T.

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT aTitle      := {{|| ""} }         ,;
           aHead       := {{|| ""} }         ,;
           aFoot       := {{|| ""} }         ,;
           aFont       := {}                 ,;
           aPen        := {}                 ,;
           lSummary    := .F.                ,;
           cRptFile    := ""                 ,;
           cResName    := ""                 ,;
           lPrinter    := .F.                ,;
           lScreen     := .F.                ,;
           cFile       := ""                 ,;
           cTFmt       := "CENTER"           ,;
           cHFmt       := "LEFT"             ,;
           cFFmt       := "LEFT"

   ::aColumns     := {}
   ::aGroups      := {}
   ::bStdFont     := {|| 1 }
   ::bPreview     := {|oDevice| rPreview(oDevice) }
   ::cRptFile     := cRptFile
   ::cResName     := cResName
   ::cPageTotal   := ""
   ::cGrandTotal  := ""
   ::cCharPattern := CHAR_PATTERN
   ::cFile        := cFile
   ::cName        := cName
   ::nRow         := 0
   ::nPage        := 0
   ::nSeparator   := 0
   ::nCounter     := 0
   ::nTotalLine   := RPT_DOUBLELINE
   ::nGroupLine   := RPT_SINGLELINE
   ::nTitleUpLine := RPT_DOUBLELINE
   ::nTitleDnLine := RPT_DOUBLELINE
   ::nClrShadow   := CLR_LIGHTGRAY
   ::lSummary     := lSummary
   ::lStable      := .F.
   ::lPrinter     := lPrinter
   ::lScreen      := lScreen
   ::lFirstRow    := .T.
   ::lCreated     := .F.
   ::lBreak       := .F.
   ::lShadow      := .F.
   ::lJoin        := .F.
   ::lSeparator   := .F.
   ::lAutoLand    := .T.
   ::lIsNarrow    := .F.
   ::lBoxOnTotal  := .F.
   ::lNoCancel    := .F.
   ::lPageTotal   := .T.

   IF cTFmt == "LEFT"
      nTFmt = RPT_LEFT
   ELSEIF cTFmt == "RIGHT"
      nTFmt = RPT_RIGHT
   ELSEIF cTFmt == "CENTER" .OR. cTFmt == "CENTERED"
      nTFmt = RPT_CENTER
   ELSE
      nTFmt = RPT_CENTER
   ENDIF

   IF cHFmt == "LEFT"
      nHFmt = RPT_LEFT
   ELSEIF cHFmt == "RIGHT"
      nHFmt = RPT_RIGHT
   ELSEIF cHFmt == "CENTER" .OR. cHFmt == "CENTERED"
      nHFmt = RPT_CENTER
   ELSE
      nHFmt = RPT_LEFT
   ENDIF

   IF cFFmt == "LEFT"
      nFFmt = RPT_LEFT
   ELSEIF cFFmt == "RIGHT"
      nFFmt = RPT_RIGHT
   ELSEIF cFFmt == "CENTER" .OR. cFFmt == "CENTERED"
      nFFmt = RPT_CENTER
   ELSE
      nFFmt = RPT_LEFT
   ENDIF

   /*
   Indicar device
   */

   IF oDevice <> NIL
      ::oDevice  := oDevice
      ::lScreen  := oDevice:lMeta
      ::lPrinter := !::lScreen
   ELSEIF ::lPrinter
      ::oDevice  := TPrinter():New(cName,.F.)
   ELSEIF ::lScreen
      ::oDevice  := TPrinter():New(cName,.F.,.T.)
   ELSEIF !empty(::cFile)
      ::oDevice  := TRFile():New(::cFile)
      ::lPrinter := .F.
   ELSE
      ::oDevice  := TPrinter():New(cName,.F.)
      ::lPrinter := .T.
   ENDIF

   /*
   Nombre del listado
   */

   IF empty(::cName)
     IF !empty(::oDevice:cDocument)
          ::cName := ::oDevice:cDocument
     ELSE
          ::cName := "Printing report"
     ENDIF
   ENDIF

   /*
   Control de que el device es correcto
   */

   IF empty(::oDevice:hDC)
      RETURN Self
   ELSE
      ::lCreated := .T.
   ENDIF

   /*
   Pedir coordenadas del device
   */

   ::nWidth  := ::oDevice:nHorzRes()
   ::nHeight := ::oDevice:nVertRes()

   /*
   Calcular n§ de pixels por pulgada del device
   */

   ::nLogPixX := ::oDevice:nLogPixelX()
   ::nLogPixY := ::oDevice:nLogPixelY()

   /*
   Si no ha especificado font asignar ARIAL 10
   */

   IF len(aFont) == 0
      lFontDefined := .F.
      Asize(aFont,1)
      DEFINE FONT aFont[1] NAME "Arial" SIZE 0,-10
   ENDIF

   /*
   Si no se ha especificado pen crearlo (por si acaso)
   */

   IF len(aPen) == 0
      lPenDefined := .F.
      Asize(aPen,1)
      DEFINE PEN aPen[1] STYLE 0 WIDTH 1 COLOR CLR_BLACK
   ENDIF

   /*
   Crear pen para las lineas horizontales igual que el primero definido
   */

   DEFINE PEN ::oPenHorz   ;
      STYLE aPen[1]:nStyle ;
      WIDTH aPen[1]:nWidth * ::nLogPixX/72 ;
      COLOR aPen[1]:nColor

   /*
   Crear nuevos fonts basandonos en el Device para ajustar
   el tama¤o de los mismos al device elegido
   */

   ::aFont := Array(len(aFont))

   Aeval(aFont                                        ,;
         {|val,elem|                                   ;
         ::aFont[elem]:= TFont():New(val:cFaceName    ,;
         Int(val:nWidth*::nLogPixX/72)                ,;
         Int(val:nHeight*::nLogPixY/72)               ,;
         .F.                                          ,;
         val:lBold                                    ,;
         val:nEscapement                              ,;
         val:nOrientation                             ,;
         val:nWeight                                  ,;
         val:lItalic                                  ,;
         val:lUnderline                               ,;
         val:lStrikeOut                               ,;
         val:nCharSet                                 ,;
         val:nOutPrecision                            ,;
         val:nClipPrecision                           ,;
         val:nQuality) })

   IF !lFontDefined
      aFont[1]:end()
   ENDIF

   /*
   Crear nuevos Pens basandonos en el device
   */

   ::aPen := Array(len(aPen))

   Aeval(aPen, {|val,elem|                             ;
               ::aPen[elem] := Tpen():New( val:nStyle ,;
               Int(val:nWidth*::nLogPixX/72)          ,;
               val:nColor)} )

   IF !lPenDefined
      aPen[1]:end()
   ENDIF

   /*
   Crear Matriz de colores para impresi¢n de texto
   */

   ::aClrText := Array(len(::aFont))

   Aeval(::aClrText,{|val,elem| ::aClrText[elem] := CLR_BLACK })

   /*
   Establecer margenes de impresi¢n a 0,2 pulgadas
   */

   ::nLeftMargin  := ::nLogPixX*0.2
   ::nRightMargin := ::nLogPixX*0.2
   ::nTopMargin   := ::nLogPixY*0.2
   ::nDnMargin    := ::nLogPixY*0.2

   /*
   Crear objetos del listado
   */

   ::oHeader := TrLine():New(aHead,Self,nHFmt)
   ::oTitle  := TrLine():New(aTitle,Self,nTFmt)
   ::oFooter := TrLine():New(aFoot,Self,nFFmt)

RETURN Self   // Must return Self here cause 32 bits version

//----------------------------------------------------------------------------//

METHOD Margin(nValue, nType, nScale) CLASS TReport


   DEFAULT nValue := .2         ,;
           nType  := RPT_LEFT   ,;
           nScale := RPT_INCHES

   IF nScale == RPT_CMETERS
      nValue := nValue/2.54
   ENDIF

   DO CASE
   CASE nType == RPT_TOP
      ::nTopMargin   := ::nLogPixY*nValue
   CASE nType == RPT_BOTTOM
      ::nDnMargin    := ::nLogPixY*nValue
   CASE nType == RPT_LEFT
      ::nLeftMargin  := ::nLogPixX*nValue
   CASE nType == RPT_RIGHT
      ::nRightMargin := ::nLogPixX*nValue
   ENDCASE

   ::lStable := .F.

RETURN Self

//----------------------------------------------------------------------------//

METHOD Say(nCol, xText, nFont, nPad, nRow) CLASS TReport

   DEFAULT nCol  := 1        ,;
           nFont := 1        ,;
           xText := ""       ,;
           nRow  := ::nRow   ,;
           nPad  := RPT_LEFT

   IF nCol <1 .OR. nCol > len(::aCols)
      nCol := 1
   ENDIF

   IF nFont <1 .OR. nFont > len(::aFont)
      nFont := 1
   ENDIF

   ::oDevice:Say(nRow              ,;
                 ::aCols[nCol]     ,;
                 cValToChar(xText) ,;
                 ::aFont[nFont]    ,;
                 NIL               ,;
                 ::aClrText[nFont],,;
                 nPad-1)

RETURN Self

//----------------------------------------------------------------------------//

METHOD SayBitmap(nRow, nCol, cBitmap, nWidth, nHeight, nScale) CLASS TReport

   LOCAL nPixWidth, nPixHeight
   LOCAL aOffset     := Array( 2 )

   DEFAULT nRow      := .2       ,;
           nCol      := .2       ,;
           nWidth    := 1        ,;
           nHeight   := 1        ,;
           nScale    := RPT_INCHES

   IF nScale == RPT_CMETERS
      aOffset := ::oDevice:Cmtr2Pix(nRow, nCol)
      nWidth  := nWidth/2.54
      nHeight := nHeight/2.54
   ELSE
      aOffset := ::oDevice:Inch2Pix(nRow, nCol)
   ENDIF

   nPixWidth  := ::nLogPixY*nWidth
   nPixHeight := ::nLogPixX*nHeight

   ::oDevice:SayBitmap(aOffset[1] ,;
                       aOffset[2] ,;
                       cBitmap    ,;
                       nPixWidth  ,;
                       nPixHeight)

   /*
   do case
      case nScale == RPT_CMETERS
         aOffset     := ::oDevice:Cmtr2Pix(nRow, nCol)
         nWidth      := nWidth/2.54
         nHeight     := nHeight/2.54
         nPixWidth   := ::nLogPixY*nWidth
         nPixHeight  := ::nLogPixX*nHeight

      case nScale == RPT_INCHES
         aOffset     := ::oDevice:Inch2Pix(nRow, nCol)
         nPixWidth   := ::nLogPixY*nWidth
         nPixHeight  := ::nLogPixX*nHeight

      otherwise
         aOffset[1]  := nRow
         aOffset[2]  := nCol
         nPixWidth   := ::nLogPixY*nWidth
         nPixHeight  := ::nLogPixX*nHeight

   end case
   */

   ::oDevice:SayBitmap(aOffset[1] ,;
                       aOffset[2] ,;
                       cBitmap    ,;
                       nPixWidth  ,;
                       nPixHeight)

RETURN Self

//----------------------------------------------------------------------------//

METHOD Box(nRow, nCol, nBottom, nRight, nPen, nScale ) CLASS TReport

   LOCAL aStart, aEnd

   DEFAULT nRow    := .2   ,;
           nCol    := .2   ,;
           nBottom := 5    ,;
           nRight  := 5    ,;
           nPen    := 1    ,;
           nScale  := RPT_INCHES

   IF nScale == RPT_CMETERS
      aStart := ::oDevice:Cmtr2Pix(nRow, nCol)
      aEnd   := ::oDevice:Cmtr2Pix(nBottom, nRight)
   ELSE
      aStart := ::oDevice:Inch2Pix(nRow, nCol)
      aEnd   := ::oDevice:Inch2Pix(nBottom, nRight)
   ENDIF

   ::oDevice:Box(aStart[1]    ,;
                 aStart[2]    ,;
                 aEnd[1]      ,;
                 aEnd[2]      ,;
                 ::aPen[nPen])

RETURN Self

//----------------------------------------------------------------------------//

METHOD Line( nRow, nCol, nBottom, nRight, nPen, nScale ) CLASS TReport

   LOCAL aStart, aEnd

   DEFAULT nRow    := .2   ,;
           nCol    := .2   ,;
           nBottom := 5    ,;
           nRight  := 5    ,;
           nPen    := 1    ,;
           nScale  := RPT_INCHES

   IF nScale == RPT_CMETERS
      aStart := ::oDevice:Cmtr2Pix(nRow, nCol)
      aEnd   := ::oDevice:Cmtr2Pix(nBottom, nRight)
   ELSE
      aStart := ::oDevice:Inch2Pix(nRow, nCol)
      aEnd   := ::oDevice:Inch2Pix(nBottom, nRight)
   ENDIF

   ::oDevice:Line(aStart[1]    ,;
                  aStart[2]    ,;
                  aEnd[1]      ,;
                  aEnd[2]      ,;
                  ::aPen[nPen])

RETURN Self

//----------------------------------------------------------------------------//

METHOD Shadow (nHeight) CLASS TReport

   LOCAL nFor, nCols, nGrid

   IF !::lShadow
     RETU NIL
   ENDIF

   nCols := len(::aColumns)

   IF ::oShdBrush == NIL
       DEFINE BRUSH ::oShdBrush COLOR ::nClrShadow
   ENDIF

   FOR nFor := 1 TO nCols
      IF ::aColumns[nFor]:lShadow

         IF ::aColumns[nFor]:lGrid
            nGrid := ::aPen[::aColumns[nFor]:nPen]:nWidth * 2
         ELSE
            nGrid := 0
         ENDIF

         SetbkMode( ::oDevice:hDCOut, 1 )

         ::oDevice:FillRect({::nRow         ,;
                             ::aCols[nFor] -nGrid  ,;
                             ::nRow+nHeight  ,;
                             ::aCols[nFor]+::aColumns[nFor]:nWidth+nGrid} ,;
                              ::oShdBrush)
      ENDIF
   NEXT

RETURN Self

//----------------------------------------------------------------------------//

METHOD Grid (nHeight, nRow, cChar) CLASS TReport

   LOCAL nFor, nCols

   DEFAULT nHeight    := ::nStdLineHeight ,;
           nRow       := ::nRow

   IF !::lGrid .OR. empty(nHeight)
     RETU NIL
   ENDIF

   nCols := len(::aColumns)

   IF ::lScreen .OR. ::lPrinter

        FOR nFor := 1 TO nCols

           IF ::aColumns[nFor]:lGrid

              SetbkMode( ::oDevice:hDCOut, 1 )

              ::oDevice:line(nRow    ,;
                             ::aCols[nFor]-(::nSeparator/2)   ,;
                             nRow+nHeight     ,;
                             ::aCols[nFor]-(::nSeparator/2),;
                             ::aPen[::aColumns[nFor]:nPen])
              ::oDevice:line(nRow    ,;
                             ::aCols[nFor]+::aColumns[nFor]:nWidth+(::nSeparator/2) ,;
                             nRow+nHeight     ,;
                             ::aCols[nFor]+::aColumns[nFor]:nWidth+(::nSeparator/2) ,;
                             ::aPen[::aColumns[nFor]:nPen])
           ENDIF

        NEXT

     ELSE

        IF cChar == NIL
           cChar := "³"
        ENDIF

        FOR nFor := 1 TO nCols

           IF ::aColumns[nFor]:lGrid

              ::oDevice:Say(nRow    ,;
                            ::aCols[nFor]-::nSeparator ,;
                            Replicate(cChar,::nSeparator) ,;
                            ::aFont[eval(::bStdFont)],;
                            ::nSeparator)

              ::oDevice:Say(nRow    ,;
                            ::aCols[nFor]+::aColumns[nFor]:nWidth ,;
                            Replicate(cChar,::nSeparator) ,;
                            ::aFont[eval(::bStdFont)],;
                            ::nSeparator)

           ENDIF

        NEXT

     ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD Separator (nPen, nRow) CLASS TReport

     LOCAL oPen
     LOCAL cSeparator
     LOCAL nLeft, nRight

     DEFAULT nRow := ::nRow ,;
             nPen := 1

     nLeft  := ::nMargin
     nRight := nLeft

     Aeval(::aColumns, {|v| nRight += v:nWidth } )

     nRight += ((len(::aColumns)-1)*::nSeparator)

     IF !::lPrinter .AND. !::lScreen

          cSeparator := ""
          Aeval(::aColumns,;
                {|val| cSeparator += Replicate("Ä",val:nWidth)+"Å" })
          cSeparator := "Ã"+Substr(cSeparator,1,len(cSeparator)-1)+"´"
          ::oDevice:Say(nRow, nLeft-::nSeparator, cSeparator)
          ::Shadow(::nStdLineHeight)
          ::nRow += ::nStdLineHeight
          RETU NIL

     ENDIF

     IF ::aColumns[1]:lGrid
          nLeft -= Int(::nSeparator/2)
     ENDIF

     IF Atail(::aColumns):lGrid
          nRight += Int(::nSeparator/2)
     ENDIF

     IF nPen != NIL .AND. nPen > 0 .AND. nPen < len(::aPen)
          oPen := ::aPen[nPen]
     ELSE
          oPen := ::oPenHorz
     ENDIF

     //::oDevice:Line(nRow, nLeft, nRow, nRight, oPen)
     Aeval(::aColumns, {|v| v:Separator(nRow)})
     ::NewLine(oPen:nWidth*4)

RETURN Self

//----------------------------------------------------------------------------//

METHOD SetPenColor(nColor) CLASS TReport

   IF nColor == NIL
       RETU NIL
   ENDIF

   ::oPenHorz:End()

   DEFINE PEN ::oPenHorz ;
      STYLE 0 ;
      WIDTH Int(1*::nLogPixX/72) ;
      COLOR nColor

RETURN Self

//----------------------------------------------------------------------------//

METHOD Activate(bFor, bWhile, bInit, bEnd, bStartPage, ;
                bEndPage, bStartGroup, bEndGroup, ;
                bStartLine, bEndLine, bChange, ;
                bPostEnd, bPostPage, bPostGroup ;
                ) CLASS TReport


   LOCAL oPagina

   DEFAULT bFor     := {|| .T.    } ,;
           bWhile   := {|| !eof() }

   /*
   ::hOldRes := GetResources()

   #ifdef __CLIPPER__
      SET RESOURCES TO "preview.dll"
   #else
      SET RESOURCES TO "prev32.dll"
   #endif

   IF GetResources() < 32
       #ifdef __CLIPPER__
          MsgStop( "Preview.dll not found", "Error" )
       #else
          MsgStop( "Prev32.dll not found", "Error" )
       #endif
       SetResources(::hOldRes)
       RETU NIL
   ENDIF
   */

   DEFAULT ::bFor        := bFor        ,;
           ::bWhile      := bWhile      ,;
           ::bInit       := bInit       ,;
           ::bEnd        := bEnd        ,;
           ::bStartPage  := bStartPage  ,;
           ::bEndPage    := bEndPage    ,;
           ::bStartGroup := bStartGroup ,;
           ::bEndGroup   := bEndGroup   ,;
           ::bStartLine  := bStartLine  ,;
           ::bEndLine    := bEndLine    ,;
           ::bChange     := bChange     ,;
           ::bPostEnd    := bPostEnd    ,;
           ::bPostPage   := bPostPage   ,;
           ::bPostGroup  := bPostGroup

   /*
   Si hay una condici¢n For y ademas grupos entonces
   nos posicionamos en el primer registro valido
   */

   IF len(::aGroups) > 0
      DO WHILE eval(::bWhile) .AND. !eval(::bFor)
         SysRefresh()
         ::Skip(1)
      ENDDO
   ENDIF

   /*
   Estabilizar el listado
   */

   IF !::lCreated
       ::End()
       RETU NIL
   ENDIF

   ::Stabilize()

   IF ::lIsNarrow
        ::oDevice:SetLandScape()
        ::nWidth  := ::oDevice:nHorzRes()
        ::nHeight := ::oDevice:nVertRes()
        ::Stabilize()
   ENDIF

   IF !::lStable
       ::End()
       RETU NIL
   ENDIF

   /*
   Creaci¢n de la ventana de impresi¢n
   */

   IF !::lScreen

      DEFINE DIALOG ::oRptWnd TITLE ::cName RESOURCE "PRINT_PROC"

      REDEFINE BUTTON ID IDCANCEL OF ::oRptWnd ;
         ACTION (::lBreak := .T., ::oRptWnd:End()) ;
         WHEN (!::lNoCancel)

      REDEFINE SAY oPagina VAR ::nPage ID 101 OF ::oRptWnd

      ::oRptWnd:bPainted := {|| iif(::nPage>0,oPagina:Refresh(), )}

      ::oRptWnd:bStart := {|| ::Play(), ::oRptWnd:End() }

      ACTIVATE DIALOG ::oRptWnd CENTER

   ELSE

      DEFINE DIALOG ::oRptWnd TITLE ::cName RESOURCE "PREVIEW_PROC"

      REDEFINE BUTTON ID IDCANCEL OF ::oRptWnd ;
         ACTION (::lBreak := .T., ::oRptWnd:End()) ;
         WHEN (!::lNoCancel)

      REDEFINE SAY oPagina VAR ::nPage ID 101 OF ::oRptWnd

      ::oRptWnd:bPainted := {|| iif(::nPage>0,oPagina:Refresh(), )}

      ::oRptWnd:bStart := {|| ::Play(), ::oRptWnd:End()}

      ACTIVATE DIALOG ::oRptWnd CENTER

      Eval( ::bPreview, ::oDevice )

   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD Play() CLASS TReport

   LOCAL nColumns, nGroups, nFor1, nFor2, nFor3, nTotalValue
   LOCAL lSeparator

   /*
   Inicializar variables
   */

   nColumns   := len(::aColumns)
   nGroups    := len(::aGroups)

   /*
   Comienzo de la Impresi¢n
   */

   ::StartPage()
   ::Init()

   /*
   Reset de totales por grupo
   */

   #ifdef __CLIPPER__
      ASend( ::aGroups, "Reset" )
   #else
      ASend( ::aGroups, "Reset()" )
   #endif

   /*
   Start de grupo
   */

   Aeval(::aGroups,{|val,elem| ::StartGroup(elem) })

   /*
   Bucle de rastreo
   */

   DO WHILE !::lBreak .AND. eval(::bWhile)

      /*
      Refresh
      */

      SysRefresh()

      /*
      Comprobar condici¢n for
      */

      IF !eval(::bFor)
         ::Skip(1)
         LOOP
       ENDIF

      /*
      Condici¢n de Grupo
      */

      #ifdef __CLIPPER__
         IF ::lGroup
            ASend( ::aGroups, "Evaluate" )
         ENDIF
      #else
         IF ::lGroup
            ASend( ::aGroups, "Evaluate()" )
         ENDIF
      #endif

      /*
      Cuerpo del Listado
      */

      // si hay un code-block de evaluación por cada registro a procesar llamarlo

      IF ::bStartRecord != Nil
         Eval(::bStartRecord, Self)
      ENDIF

      FOR nFor1 := 1 TO ::nMaxData

         ::nDataLine := nFor1

         IF !::lSummary
            lSeparator := (::lSeparator .AND. ;
                           !::lFirstRow .AND. ;
                           nFor1 == 1)
            ::StartLine(::aDataHeight[nFor1], lSeparator)
         ENDIF

         FOR nFor2 := 1 TO nColumns

            IF !::lSummary
                ::aColumns[nFor2]:SayData(::nRow ,;
                                          ::aCols[nFor2] ,;
                                          nFor1)
            ENDIF

            /*
            Control Sumas
            */

            IF ::lTotal                                    .AND. ;
               ::aColumns[nFor2]:lTotal                    .AND. ;
               (!::aColumns[nFor2]:lTotalExpr .OR.               ;
               (::aColumns[nFor2]:bTotalExpr != nil) )

               if ::aColumns[nFor2]:bTotalExpr != nil
                  nTotalValue := eval(::aColumns[nFor2]:bTotalExpr)
               else
                  nTotalValue := eval(::aData[nFor2][nFor1])
               end if

               IF valtype(nTotalValue) == "N"
                    ::aColumns[nFor2]:nTotal += nTotalValue
                    IF ::lGroup
                       FOR nFor3 := 1 TO nGroups
                          ::aGroups[nFor3]:aTotal[nFor2] += nTotalValue
                       NEXT
                    ENDIF
               ENDIF
            ENDIF
         NEXT

         IF !::lSummary
            ::EndLine(::aDataHeight[nFor1])
         ENDIF
      NEXT

      /*
      Proximo registro o equivalente
      */

      ::Skip(1)

      // si hay un code-block de evaluación por cada registro a procesar llamarlo

      IF ::bEndRecord != Nil
         Eval(::bEndRecord, Self)
      ENDIF

      /*
      Control Grupo
      */

      IF ::lGroup

         DO WHILE eval(::bWhile) .AND. !eval(::bFor)
            SysRefresh()
            ::Skip(1)
         ENDDO

         FOR nFor1 := nGroups TO 1 STEP -1
            IF ::aGroups[nFor1]:Check()
               ::EndGroup(nFor1)
            ENDIF
         NEXT
         FOR nFor1 := 1 TO nGroups
            IF ::aGroups[nFor1]:lNeedStart
               ::StartGroup(nFor1)
            ENDIF
         NEXT

       ENDIF

   ENDDO

   IF ::lGroup
      FOR nFor1 := nGroups TO 1 STEP -1
         IF !Empty(::aGroups[nFor1]:nCounter)
            ::EndGroup(nFor1)
         ENDIF
      NEXT
   ENDIF

   ::End()

RETURN Self

//----------------------------------------------------------------------------//

METHOD Stabilize() CLASS TReport

   LOCAL nColumns, nFor1, nFor2, nMaxHeight, nPrnWidth

   nColumns   := len(::aColumns)
   nMaxHeight := 0

   IF nColumns == 0
      ::lCreated := .F.
      RETU NIL                           // No hay columnas
   ENDIF

   /*
   Calculo del tama¤o del separador de columnas
   */

   IF empty(::nSeparator)
       ::nSeparator := ::oDevice:GetTextWidth(::cCharPattern,::aFont[eval(::bStdFont)])
   ENDIF

   /*
   C lculo del alto standard de una linea
   */

   ::nStdLineHeight := ::oDevice:GetTextHeight(::cCharPattern,::aFont[eval(::bStdFont)])

   /*
   C lculo del n£mero maximo de titulos y datos pasados a los objetos
   columna
   */

   ::nMaxTitle := 0
   ::nMaxData  := 0

   AEval( ::aColumns, {|Val| ::nMaxTitle := Max(len(Val:aTitle),::nMaxTitle) } )
   AEval( ::aColumns, {|Val| ::nMaxData  := Max(len(Val:aData),::nMaxData) } )

   /*
   Generar matriz de trabajo para titulos
   */

   ::aText := Array(nColumns,::nMaxTitle)

   FOR nFor1 := 1 TO nColumns
      FOR nFor2 := 1 TO ::nMaxTitle
         IF len(::aColumns[nFor1]:aTitle) < nFor2
               ::aText[nFor1][nFor2] := {|| "" }
         ELSE
               ::aText[nFor1][nFor2] := ::aColumns[nFor1]:aTitle[nFor2]
         ENDIF
      NEXT
   NEXT

   /*
   Generar matrices de trabajo para datos de las columnas
   */

   ::aData    := Array(nColumns,::nMaxData)

   FOR nFor1 := 1 TO nColumns
      FOR nFor2 := 1 TO ::nMaxData
         IF len(::aColumns[nFor1]:aData) < nFor2
               ::aData[nFor1][nFor2] := {|| "" }
         ELSE
               ::aData[nFor1][nFor2] := ::aColumns[nFor1]:aData[nFor2]
         ENDIF
      NEXT
   NEXT

   /*
   Comprobar si hay grupos
   */

   ::lGroup := (len(::aGroups)>0)

   /*
   Estabilizar objetos
   */

   ::oHeader:Stabilize()
   ::oFooter:Stabilize()
   ::oTitle:Stabilize()

   Aeval(::aGroups , {|val,elem| val:Stabilize(elem) })
   Aeval(::aColumns, {|val,elem| val:Stabilize(elem) })

   /*
   Comprobar si hay algun total
   */

   ::lTotal := .F.
   aeval(::aColumns,{|Val| iif(Val:lTotal,::lTotal := .T. ,NIL ) })

   /*
   Comprobar si hay alguna columna con Sombra

   ::lShadow := .F.
   aeval(::aColumns,{|Val| iif(Val:lShadow,::lShadow := .T. ,NIL ) })
   */

   /*
   Comprobar si hay alguna columna con Grid
   */

   ::lGrid := .F.
   aeval(::aColumns,{|Val| iif(Val:lGrid,::lGrid := .T. ,NIL ) })

   /*
   C lculo del ancho del listado
   */

   ::nRptWidth := 0
   aeval(::aColumns,{|Val| ::nRptWidth += Val:nWidth+::nSeparator })

   ::nRptWidth -= ::nSeparator

   ::nRptWidth := max(::nRptWidth,::oTitle:nWidth)
   ::nRptWidth := max(::nRptWidth,::oHeader:nWidth)
   ::nRptWidth := max(::nRptWidth,::oFooter:nWidth)

   /*
   Si es a un fichero Ascii dimensionar su ancho
   */

   IF !::lPrinter .AND. !::lScreen
     ::oDevice:nWidth := ::nRptWidth+ (::nSeparator*10)
     ::nWidth         := ::oDevice:nHorzRes()
   ENDIF

   /*
   Si el listado es m s ancho que la p gina advertirlo
   */

   IF ::nRptWidth > ::nWidth .AND. (::lScreen .OR. ::lPrinter)
      IF  ::lAutoLand .AND. ;
         !::lIsNarrow .AND. ;
         ::oDevice:GetOrientation() == PORTRAIT

          ::lStable   := .F.
          ::lIsNarrow := .T.
          RETU NIL

      ENDIF
      /*
      IF !ApoloMsgNoYes(TXT_REPORT_WIDTH, TXT_ATENTION)
          ::lStable := .F.
          RETU NIL
      ENDIF
      */
   ENDIF

   ::nRptWidth := min(::nRptWidth,::nWidth)


   /*
   Margen del Listado
   */

   nPrnWidth := ::nWidth - ::nLeftMargin - ::nRightMargin
   ::nMargin := max((nPrnWidth-::nRptWidth)/2,0) + ::nLeftMargin

   /*
   Calculo de las distintas coordenadas de las columnas del listado
   */

   ::aCols := Array(nColumns)

   ::aCols[1] := iif(::aColumns[1]:nCol!=0, ::aColumns[1]:nCol, ::nMargin)
   ::aColumns[1]:nCalCol := ::aCols[1]

   FOR nFor1 := 2 TO nColumns
      IF ::aColumns[nFor1]:nCol>0
         ::aCols[nFor1] := ::aColumns[nFor1]:nCol
      ELSE
         ::aCols[nFor1] := ::aCols[nFor1-1] + ;
                           ::aColumns[nFor1-1]:nWidth + ;
                           ::nSeparator
      ENDIF
      ::aColumns[nFor1]:nCalCol := ::aCols[nFor1]
   NEXT

   /*
   Estabilizar lineas fijas de nuevo indicando coordenadas
   */

   ::oHeader:Stabilize(::nTopMargin,::nMargin)
   ::oTitle:Stabilize(::oHeader:nHeight+::nTopMargin,::nMargin)
   ::oFooter:Stabilize(::nHeight-::nDnMargin-::oFooter:nHeight,::nMargin)

   /*
   Inicializar variables de coordenadas
   */

   Aeval(::aColumns,;
            {|val| nMaxHeight:=Max(nMaxHeight,val:nDataHeight) })

   ::nTitleRow  := ::oHeader:nHeight + ::oTitle:nHeight + ::nTopMargin

   ::nBottomRow := ::nHeight-::oFooter:nHeight-::nDnMargin- ;
                  iif(!::lTotal,0,::nStdLineHeight+nMaxHeight) - ;
                  iif(!::lTotal .AND. ::lSeparator,::oPenHorz:nWidth*10 ,0 ) - ;
                  iif(::lTotal .AND. ::lBoxOnTotal,::nStdLineHeight ,0 )

   /*
   Calcular alto de los titulos
   */

   nMaxHeight     := 0
   ::nTitleHeight := 0

   FOR nFor1 := 1 TO ::nMaxTitle

      FOR nFor2 := 1 TO nColumns
         nMaxHeight := Max(nMaxHeight, ::aColumns[nFor2]:nTitleHeight)
      NEXT
      ::nTitleHeight += nMaxHeight

   NEXT

   /*
   Calcular m ximo alto de cada linea de datos
   */

   ::aDataHeight := Afill(Array(::nMaxData),0)

   FOR nFor1 := 1 TO ::nMaxData

      Aeval(::aColumns,;
            {|val| ::aDataHeight[nFor1] := Max(::aDataHeight[nFor1],;
                                             val:nDataHeight) })
   NEXT

   /*
   Calcular coordenadas de impresi¢n de datos
   */

   ::nFirstdRow := ::nTitleRow +;
                   iif(!empty(::nTitleUpLine),::nStdLineHeight,0) +;
                   ::nTitleHeight +;
                   iif(!empty(::nTitleDnLine),::nStdLineHeight,0)

   ::nLastdRow  := ::nBottomRow -;
                   iif(::lTotal,::nStdLineHeight/2 ,0 ) - ;
                   iif(!::lTotal .AND. ::lSeparator,::oPenHorz:nWidth*10 ,0 ) -;
                   iif(::lTotal .AND. ::lBoxOnTotal,::nStdLineHeight ,0 )

   /*
   Indicar que ya esta estable
   */

   ::lStable := .T.
   ::lFinish := .F.

RETURN (NIL)

//----------------------------------------------------------------------------//

METHOD Init() CLASS TReport

   IF ::bInit != nil
       Eval( ::bInit, Self )
   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TReport

   ::lFinish := .T.

   IF !::lCreated .OR. !::lStable

        IF ::oShdBrush != NIL
            ::oShdBrush:end()
        ENDIF

        #ifndef __XPP__
            ASend( ::aFont, "End" )
            ASend( ::aPen, "End" )
        #else
            ASend( ::aFont, "_End()" )
            ASend( ::aPen, "_End()" )
        #endif

        if ::oPenHorz != nil
           ::oPenHorz:End()
        endif

        ::oDevice:End()
        RETU NIL

   ENDIF

   IF !::lBreak .AND. ::bEnd != nil
       Eval( ::bEnd, Self )
   ENDIF


   ::EndPage()


   IF !::lScreen
       ::oDevice:End()
   ENDIF

   IF ::oShdBrush != NIL
       ::oShdBrush:end()
   ENDIF

   #ifndef __XPP__
      ASend( ::aFont, "End" )
      ASend( ::aPen, "End" )
   #else
      ASend( ::aFont, "_End()" )
      ASend( ::aPen, "_End()" )
   #endif

   ::oPenHorz:End()

RETURN Self

//----------------------------------------------------------------------------//

METHOD Skip( n ) CLASS TReport

   STATIC lRunning := .F.

   ::nCounter++

   IF ::bChange != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::bChange, Self )
       lRunning := .F.
   ENDIF

   IF ::bSkip != nil
       retu Eval( ::bSkip, n )
   ENDIF

RETURN DbSkip( n )

//----------------------------------------------------------------------------//

METHOD StartPage() CLASS TReport

   STATIC lRunning := .F.

   ::oDevice:StartPage()

   ::nPage++

   ::oRptWnd:Refresh()

   IF ::bStartPage != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::bStartPage, Self )
       lRunning := .F.
   ENDIF

   ::oHeader:Say()
   ::oTitle:Say()
   ::ColTitle()
   ::lFirstRow := .T.

RETURN Self

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TReport

   STATIC lRunning := .F.

   IF ::bEndPage != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::bEndPage, Self )
       lRunning := .F.
   ENDIF

   ::PageTotal()
   ::oFooter:Say()

   IF ::bPostPage != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::bPostPage, Self )
       lRunning := .F.
   ENDIF

   IF !::lBreak .AND. ::lFinish .AND. ::bPostEnd != nil .AND. !lRunning
       lRunning := .T.
       Eval( ::bPostEnd, Self )
       lRunning := .F.
   ENDIF

   ::oDevice:EndPage()

   IF !(::lFinish)
       ::StartPage()
   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD StartLine(nHeight, lSeparator) CLASS TReport

   STATIC lRunning := .F.

   DEFAULT nHeight    := ::nStdLineHeight ,;
           lSeparator := .F.

   IF nHeight == 0
     RETU NIL
   ENDIF

   IF (nHeight+::nRow) >= ::nBottomRow
         ::EndPage()
         lSeparator := .F.
   ENDIF

   IF lSeparator
     ::Separator()
   ENDIF

   ::Shadow(nHeight)
   ::Grid(nHeight)

   IF ::bStartLine != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::bStartLine, Self)
      lRunning := .F.
   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD EndLine(nHeight) CLASS TReport

   STATIC lRunning := .F.

   DEFAULT nHeight := ::nStdLineHeight

   IF ::bEndLine != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::bEndLine, Self)
      lRunning := .F.
   ENDIF

   ::nRow      += nHeight
   ::lFirstRow := .F.

   IF ::NeedNewPage()
       ::EndPage()
   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD StartGroup(nGroup) CLASS TReport

   STATIC lRunning := .F.

   ::aGroups[nGroup]:lNeedStart := .F.

   IF !eval(::bWhile) // .OR. !eval(::bFor)
         RETU NIL
   ENDIF

   IF ::bStartGroup != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::bStartGroup, ::aGroups[nGroup])
      lRunning := .F.
   ENDIF

   IF ::aGroups[nGroup]:lHeader
      ::StartLine(::aGroups[nGroup]:nHeaderHeight)
      ::aGroups[nGroup]:Header(::nRow)
      ::EndLine(::aGroups[nGroup]:nHeaderHeight)
   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD EndGroup(nGroup) CLASS TReport

   STATIC lRunning := .F.

   IF ::bEndGroup != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::bEndGroup, ::aGroups[nGroup])
      lRunning := .F.
   ENDIF

   IF !::lSummary .AND. ::lTotal
       ::StartLine(::aGroups[nGroup]:nFooterHeight*2)
       ::TotalLine(::nGroupLine, GRID_ABOVE)
   ENDIF

   IF ::aGroups[nGroup]:lFooter
      ::StartLine(::aGroups[nGroup]:nFooterHeight)
      ::aGroups[nGroup]:Footer(::nRow)
      ::EndLine(::aGroups[nGroup]:nFooterHeight)
   ENDIF

   IF ::bPostGroup != nil .AND. !lRunning
      lRunning := .T.
      Eval( ::bPostGroup, ::aGroups[nGroup])
      lRunning := .F.
   ENDIF

   IF !::lFirstRow              .AND. ;
      ::aGroups[nGroup]:lEject  .AND. ;
      eval(::bWhile)            .AND. ;
      eval(::bFor)

      ::EndPage()
   ENDIF

   ::aGroups[nGroup]:Reset()
   ::aGroups[nGroup]:lNeedStart := .T.

RETURN Self

//----------------------------------------------------------------------------//

METHOD PageTotal() CLASS TReport

   LOCAL nFor, nColumns

   /*
   Si no hay ningun total no hacer nada (salvo separator)
   */

   IF !(::lTotal) .or. (!::lPageTotal .and. !::lFinish)
      IF ::lSeparator .OR. ::lJoin
          ::TotalLine(::nTotalLine, GRID_ABOVE)
      ENDIF
      RETU (NIL)
   ENDIF

   nColumns := len(::aColumns)

   /*
   Mostrar linea de totales
   */

   IF ::lBoxOnTotal
     ::TotalLine(::nTotalLine, GRID_ABOBEL)
     ::Grid()
   ELSE
     ::TotalLine(::nTotalLine, GRID_ABOVE)
   ENDIF

   /*
   Imprimir leyenda de totales (si esta definida, ojo por defecto no esta)
   */

   IF ::lFinish
      IF !empty(::cGrandTotal)
         ::oDevice:Say(::nRow                    ,;
                        ::aCols[1]                ,;
                        ::cGrandTotal             ,;
                        ::aFont[eval(::bStdFont)] ,;
                        NIL                       ,;
                        ::aClrText[eval(::bStdFont)],2)
      ENDIF
   ELSE
      IF !empty(::cPageTotal)
         ::oDevice:Say(::nRow                    ,;
                        ::aCols[1]                ,;
                        ::cPageTotal              ,;
                        ::aFont[eval(::bStdFont)] ,;
                        NIL                       ,;
                        ::aClrText[eval(::bStdFont)],2)
      ENDIF
   ENDIF

   /*
   Imprimir los totales para las columnas que lo lleven
   */

   FOR nFor := 1 TO nColumns
      ::aColumns[nFor]:SayTotal(::nRow, ::aCols[nFor])
   NEXT

   ::nRow += ::nStdLineHeight

   IF ::lBoxOnTotal
      ::TotalLine(::nTotalLine, GRID_ABOVE)
   ENDIF

RETURN Self

//----------------------------------------------------------------------------//

METHOD ColTitle() CLASS TReport

   LOCAL nFor1, nFor2, nColumns, nMaxHeight

   nColumns   := len(::aColumns)
   nMaxHeight := 0

   ::nRow := ::nTitleRow

   /*
   Imprimir linea superior de titulos
   */

   ::TotalLine(::nTitleUpLine, GRID_BELOW)

   /*
   Descriptores de titulos de cada columna
   */

   FOR nFor1 := 1 TO ::nMaxTitle

      FOR nFor2 := 1 TO nColumns

         ::aColumns[nFor2]:saytitle(::nRow ,;
                                    ::aCols[nFor2] ,;
                                    nFor1 )
         nMaxHeight := Max(nMaxHeight, ::aColumns[nFor2]:nTitleHeight)
      NEXT

      IF !empty(::nTitleUpLine)
           ::Grid(nMaxHeight)
      ENDIF

      ::nRow += nMaxHeight
      nMaxHeight := 0

   NEXT

   /*
   Imprimir linea inferior de titulos
   */

   ::TotalLine(::nTitleDnLine, GRID_ABOBEL)

   ::lFirstRow := .T.

RETURN Self

//----------------------------------------------------------------------------//

METHOD TotalLine(nType, nGrid) CLASS TReport

     LOCAL nFor, nColumns, nJoin, nGridRow, nGridHeight, nHeight
     LOCAL cChar, cLeft, cRight

     IF nType == NIL .OR. empty(nType)
          RETU NIL
     ENDIF

     DEFAULT nGrid := GRID_ABOVE

     nJoin       := iif(::lJoin,::nSeparator/2 ,0 )
     nGridRow    := 0
     nGridHeight := 0
     cChar       := "³"
     cLeft       := "À"
     cRight      := "Ù"

     nColumns := len(::aColumns)

     IF nType == RPT_SINGLELINE

          IF ::lScreen .OR. ::lPrinter

               nHeight := Int(::oPenHorz:nWidth*10)

               DO CASE
               CASE nGrid == GRID_ABOVE
                    nGridRow    := ::nRow
                    nGridHeight := Int(nHeight*.5)
               CASE nGrid == GRID_BELOW
                    nGridRow    := ::nRow+Int(nHeight*.5)
                    nGridHeight := Int(nHeight*.5)
               CASE nGrid == GRID_ABOBEL
                    nGridRow    := ::nRow
                    nGridHeight := nHeight
               ENDCASE

               ::Grid(nGridHeight, nGridRow, cChar)

               FOR nFor := 1 TO nColumns

                    ::oDevice:Line(::nRow+Int(nHeight*.5) ,;
                        ::aCols[nFor] - nJoin ,;
                        ::nRow+Int(nHeight*.5) ,;
                        ::aCols[nFor]+::aColumns[nFor]:nWidth + nJoin ,;
                        ::oPenHorz)

               NEXT nFor

          ELSE

               nHeight     := ::nStdLineHeight
               nGridRow    := ::nRow
               nGridHeight := nHeight

               DO CASE
               CASE nGrid == GRID_ABOVE
                    cChar  := "Á"
                    cLeft  := "À"
                    cRight := "Ù"
               CASE nGrid == GRID_BELOW
                    cChar  := "Â"
                    cLeft  := "Ú"
                    cRight := "¿"
               CASE nGrid == GRID_ABOBEL
                    cChar  := "Å"
                    cLeft  := "Ã"
                    cRight := "´"
               ENDCASE

               ::Grid(nGridHeight, nGridRow, cChar)

               FOR nFor := 1 TO nColumns

                    ::oDevice:Say(::nRow,;
                        ::aCols[nFor],;
                        Replicate("Ä",::aColumns[nFor]:nWidth) ,;
                        ::aFont[eval(::bStdFont)],;
                        ::aColumns[nFor]:nWidth)

                    IF nFor == 1 .AND. ::aColumns[nFor]:lGrid
                         ::oDevice:Say(::nRow,;
                             ::aCols[nFor]-1,;
                             cLeft ,;
                             ::aFont[eval(::bStdFont)],1)
                    ENDIF

                    IF nFor == nColumns .AND. ::aColumns[nFor]:lGrid
                         ::oDevice:Say(::nRow,;
                             ::aCols[nFor]+::aColumns[nFor]:nWidth,;
                             cRight ,;
                             ::aFont[eval(::bStdFont)],1)
                    ENDIF

               NEXT nFor

          ENDIF

     ELSEIF nType == RPT_DOUBLELINE

          IF ::lScreen .OR. ::lPrinter

               nHeight := ::oPenHorz:nWidth*10

               DO CASE
               CASE nGrid == GRID_ABOVE
                    nGridRow    := ::nRow
                    nGridHeight := Int(nHeight*.6)
               CASE nGrid == GRID_BELOW
                    nGridRow    := ::nRow+Int(nHeight*.4)
                    nGridHeight := Int(nHeight*.6)
               CASE nGrid == GRID_ABOBEL
                    nGridRow    := ::nRow
                    nGridHeight := nHeight
               ENDCASE

               ::Grid(nGridHeight, nGridRow, cChar)

               FOR nFor := 1 TO nColumns

                    ::oDevice:Line(::nRow+Int(nHeight*.4) ,;
                        ::aCols[nFor] - nJoin ,;
                        ::nRow+Int(nHeight*.4) ,;
                        ::aCols[nFor]+::aColumns[nFor]:nWidth + nJoin ,;
                        ::oPenHorz)

                    ::oDevice:Line(::nRow+Int(nHeight*.6),;
                        ::aCols[nFor] - nJoin ,;
                        ::nRow+Int(nHeight*.6) ,;
                        ::aCols[nFor]+::aColumns[nFor]:nWidth + nJoin ,;
                        ::oPenHorz)

               NEXT nFor

          ELSE

               nHeight     := ::nStdLineHeight
               nGridRow    := ::nRow
               nGridHeight := nHeight

               DO CASE
               CASE nGrid == GRID_ABOVE
                    cChar  := "Ï"
                    cLeft  := "Ô"
                    cRight := "¾"
               CASE nGrid == GRID_BELOW
                    cChar  := "Ñ"
                    cLeft  := "Õ"
                    cRight := "¸"
               CASE nGrid == GRID_ABOBEL
                    cChar  := "Ø"
                    cLeft  := "Æ"
                    cRight := "µ"
               ENDCASE

               ::Grid(nGridHeight, nGridRow, cChar)

               FOR nFor := 1 TO nColumns

                    ::oDevice:Say(::nRow,;
                        ::aCols[nFor],;
                        Replicate("Í",::aColumns[nFor]:nWidth) ,;
                        ::aFont[eval(::bStdFont)],;
                        ::aColumns[nFor]:nWidth)

                    IF nFor == 1 .AND. ::aColumns[nFor]:lGrid
                         ::oDevice:Say(::nRow,;
                             ::aCols[nFor]-1,;
                             cLeft ,;
                             ::aFont[eval(::bStdFont)],1)
                    ENDIF

                    IF nFor == nColumns .AND. ::aColumns[nFor]:lGrid
                         ::oDevice:Say(::nRow,;
                             ::aCols[nFor]+::aColumns[nFor]:nWidth,;
                             cRight ,;
                             ::aFont[eval(::bStdFont)],1)
                    ENDIF

               NEXT nFor

          ENDIF

     ENDIF

     ::nRow += nHeight

RETURN Self

METHOD BackLine( nLine )

   if !Empty( ::nStdLineHeight )
      ::nRow -= ::nStdLineHeight * iif( nLine == nil, 1 , nLine )
   end if

RETURN ( ::nRow )