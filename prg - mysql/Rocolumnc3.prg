/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RColumn for class TReport                            ³
³         File: RCOLUMN.PRG                                                ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (Ignacio_Ortiz)                                ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 07/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
#include "FiveWin.Ch"
#include "report.ch"

#define UND_SINGLE        1
#define UND_DOUBLE        2

//----------------------------------------------------------------------------//

CLASS TROColumn

     DATA   oReport
     DATA   aData, aTitle, aPicture
     DATA   oDataFont, oTitleFont, oTotalFont, bTotalExpr, bColor
     DATA   cTotalPict
     DATA   nWidth, nHeight, nDataHeight, nTitleHeight, nTotal, nCol, nSize, nPad,;
            nPen, nOrder, nCalCol, nCurLine
     DATA   lTotal, lShadow, lGrid, lTotalExpr, lUnderline, lDobleUnd, lTextUnd,;
            lSeparator
     DATA   Cargo
     DATA   nColor
     DATA   lNewLine

     METHOD New( aTitle, nCol, aData, nSize, aPicture,;
                 oFont, lTotal, bTotalExpr, cFmt, lShadow, lGrid, lNewLine,;
                 oReport ) CONSTRUCTOR

     METHOD Stabilize()

     METHOD SayTitle( nRow, nCol, nLine )
     METHOD SayData( nRow, nCol, nLine )
     METHOD SayTotal( nRow, nCol )
     METHOD Separator( nDataLine, nRow )
     METHOD Underline( lTextLength, lDouble, nDataLine, nRow )
     METHOD TitleHeight( nLine )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( aTitle     ,;
            nCol       ,;
            aData      ,;
            nSize      ,;
            aPicture   ,;
            oFont      ,;
            oTitleFont ,;
            oTotalFont ,;
            lTotal     ,;
            bTotalExpr ,;
            nFmt       ,;
            lShadow    ,;
            lGrid      ,;
            lNewLine   ,;
            nPen       ,;
            nColor     ,;
            nHeight    ,;
            oReport     )  CLASS TROColumn

     DEFAULT aTitle      := {{|| ""} }                   ,;
             aData       := {{|| ""} }                   ,;
             nSize       := 0                            ,;
             aPicture    := {{|| ""} }                   ,;
             nCol        := 0                            ,;
				 oFont       := TFont():New( "Ms Sans Serif", 6, 12, .F. ),;
             oTitleFont  := TFont():New( "Ms Sans Serif", 6, 12, .F. ),;
             oTotalFont  := TFont():New( "Ms Sans Serif", 6, 12, .F. ),;
             nPen        := 1                            ,;
             lTotal      := .F.                          ,;
             lShadow     := .F.                          ,;
             lGrid       := .F.                          ,;
             lNewLine    := .F.                          ,;
             nColor      := 0                            ,;
             nHeight     := 0                            ,;
             nFmt        := iif(Valtype(Eval(aData[1]))=="N",RPT_RIGHT, RPT_LEFT)

     ::aTitle     = aTitle
     ::aData      = aData
     ::nSize      = nSize
     ::aPicture   = aPicture
     ::oDataFont  = oFont
     ::oTitleFont = oTitleFont
     ::oTotalFont = oTotalFont
     ::lTotal     = lTotal
     ::lShadow    = lShadow
     ::lGrid      = lGrid
     ::lNewLine   = lNewLine
     ::lUnderline = .F.
     ::lDobleUnd  = .F.
     ::lSeparator = .T.
     ::lTextUnd   = .F.
     ::nPen       = nPen
     ::nTotal     = 0
     ::oReport    = oReport
     ::bTotalExpr = bTotalExpr
     ::nCol       = nCol
     ::cTotalPict = iif(len(aPicture)>0, aPicture[1], "")
     ::nWidth     = 0
     ::nCalCol    = 0
     ::nOrder     = 0
     ::nColor     = nColor
     ::nHeight    = nHeight
     ::nPad       = nFmt

     ::lTotalExpr = !(bTotalExpr == NIL)

     DO WHILE len(::aPicture) < len(::aData)
          Aadd(::aPicture,::cTotalPict)
     ENDDO

RETURN Self

//----------------------------------------------------------------------------//

METHOD Stabilize(nOrder) CLASS TROColumn

     LOCAL nFor, nWidth, nLen

     ::nDataHeight  := ::oReport:oDevice:GetTextHeight(::oReport:cCharPattern, ::oDataFont )
     ::nTitleHeight := ::oReport:oDevice:GetTextHeight(::oReport:cCharPattern, ::oTitleFont )

     IF !empty(::nSize)
          ::nWidth := ::oReport:oDevice:GetTextWidth( Replicate(::oReport:cCharPattern, ::nSize), ::oDataFont )
          RETU NIL
     ENDIF


     FOR nFor := 1 TO len(::aData)
          nLen      := len(cValtoChar(Transform(eval(::aData[nFor]),eval(::aPicture[nFor]))))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate(::oReport:cCharPattern,nLen),::oDataFont )
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     FOR nFor := 1 TO len(::aTitle)
          nLen      := len(eval(::aTitle[nFor]))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate(::oReport:cCharPattern,nLen),::oTitleFont )
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     ::nOrder := nOrder

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTitle(nRow, nCol, nLine)  CLASS TROColumn

     LOCAL cTitle

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol ,;
             nLine := 1

     IF nLine > len(::aTitle)
          RETU NIL
     ENDIF

     cTitle := eval(::aTitle[nLine])

     ::nCurLine := nLine

     ::oReport:oDevice:Say(nRow, nCol, cTitle, ::oTitleFont, ::nWidth, ::nColor, , ::nPad-1)

RETURN NIL


//----------------------------------------------------------------------------//

METHOD SayData(nRow, nCol, nLine)  CLASS TROColumn

   LOCAL cText
   LOCAL cLine
   LOCAL nFor
   LOCAL nWidth
   LOCAL uData

   DEFAULT nRow  := 0      ,;
           nCol  := ::nCol ,;
           nLine := 1

   IF nLine > len(::aData)
      Return Nil
   ENDIF

   ::nCurLine  := nLine

   uData       := Eval( ::aData[ nLine ] )

   if Valtype( uData ) == "C" .AND. File( Rtrim( uData ) )
      ::oReport:oDevice:SayBitmap( nRow, nCol, Rtrim( uData ), ::nSize, ::nHeight )
      ::oReport:EndLine( ::nHeight )
      Return nil
   end if

   cText    := Transform( uData, Eval( ::aPicture[nLine] ) )
   nWidth   := ::oReport:oDevice:GetTextWidth( cText, ::oDataFont )

   IF Valtype( uData ) == "C" .AND. len( AllTrim( cText ) ) > ::nSize

      nLine := mlCount( cText, ::nSize )

      FOR nFor := 1 TO nLine
         cLine := AllTrim( MemoLine( cText, ::nSize, nFor ) )
         ::oReport:StartLine()
         ::oReport:oDevice:Say( ::oReport:nRow, nCol, cLine, ::oDataFont, ::nWidth, ::nColor, , ::nPad - 1 )
         ::oReport:EndLine()
      NEXT

      if !::lNewLine
         ::oReport:BackLine( 1 )
      end if


   ELSE

      ::oReport:oDevice:Say( nRow, nCol, cText, ::oDataFont, ::nWidth, ::nColor, , ::nPad - 1 )

      if ::lNewLine
         ::oReport:StartLine()
         ::oReport:EndLine()
      end if

   END IF

   IF ::lUnderline
      ::Underline( ::lTextUnd, ::lDobleUnd, nLine , nRow + ::nDataHeight )
   ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTotal(nRow, nCol)  CLASS TROColumn

     LOCAL cText

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol

     IF !::lTotal
          RETU NIL
     ENDIF

     cText := Transform(::nTotal,::cTotalPict)

     ::oReport:oDevice:Say(nRow, nCol, cText, ::oDataFont, ::nWidth, ::nColor, , ::nPad-1)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD TitleHeight( nLine ) CLASS TROColumn

     LOCAL cText, cChar
     LOCAL nFor, nWidth, nLen, nLenData

     IF !empty(::nWidth)
          RETU NIL
     ENDIF

     cChar := ::oReport:cCharPattern

     ::nDataHeight  := len(::aData) * ::oReport:oDevice:GetTextHeight(cChar, ::oDataFont)
     ::nTitleHeight := len(::aTitle) * ::oReport:oDevice:GetTextHeight(cChar, ::oFontTitle)

     nLenData := len(::aData)

     FOR nFor := 1 TO nLenData
          cText    := Transform(eval(::aData[nLine]),eval(::aPicture[nLine]))
          nLen     := len(cText)
          nWidth   := ::oReport:oDevice:GetTextWidth(Replicate(cChar,nLen), ::oDataFont)
          ::nWidth := Max(::nWidth,nWidth)
     NEXT

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Underline(lTextUnd, lDobleUnd, nLine, nRow)  CLASS TROColumn

     LOCAL nLeft, nRight, nWidth

     DEFAULT lTextUnd  := ::lTextUnd  ,;
             lDobleUnd := ::lDobleUnd ,;
             nLine     := 1           ,;
             nRow      := ::oReport:nRow

     DO CASE
     CASE !lTextUnd .AND. ::lGrid
          nLeft  := ::nCalCol  + Int(::oReport:nSeparator/2)
          nRight := nLeft + ::nWidth + Int(::oReport:nSeparator/2)
     CASE lTextUnd
          nWidth := ::oReport:oDevice:GetTextWidth(alltrim(;
                      Transform(eval(::aData[nLine]),eval(::aPicture[nLine]))),::oDataFont)
          DO CASE
               CASE ::nPad == RPT_RIGHT
                    nLeft := ::nCalCol+::nWidth-nWidth
               CASE ::nPad == RPT_CENTER
                    nLeft := ::nCalCol+Int(::nWidth/2)-Int(nWidth/2)
               OTHERWISE
                    nLeft := ::nCalCol
          ENDCASE
          nRight := nLeft + nWidth
     OTHERWISE
          nLeft  := ::nCalCol
          nRight := nLeft + ::nWidth
     ENDCASE


     IF lDobleUnd
          nWidth := ::oReport:aPen[::nPen]:nWidth
          ::oReport:oDevice:Line(nRow-nWidth,;
                                 nLeft,;
                                 nRow-nWidth,;
                                 nRight,;
                                 ::oReport:aPen[::nPen])

          ::oReport:oDevice:Line(nRow+nWidth,;
                                 nLeft,;
                                 nRow+nWidth,;
                                 nRight,;
                                 ::oReport:aPen[::nPen])
     ELSE
          ::oReport:oDevice:Line(nRow,;
                                 nLeft,;
                                 nRow,;
                                 nRight,;
                                 ::oReport:aPen[::nPen])
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Separator(nRow, lForced) CLASS TROColumn

   LOCAL nLeft, nRight, nSep

   DEFAULT nRow    := ::oReport:nRow,;
           lForced := .f.

   IF !::lSeparator .and. !lForced
      RETURN NIL
   ENDIF

   nSep   := iif( ::lGrid, Int(::oReport:nSeparator/2), 0)
   nLeft  := ::nCalCol  - nSep
   nRight := nLeft + ::nWidth + (nSep*2)

   ::oReport:oDevice:Line(nRow,;
                          nLeft,;
                          nRow,;
                          nRight,;
                          ::oReport:aPen[::nPen])

RETURN NIL

//----------------------------------------------------------------------------//