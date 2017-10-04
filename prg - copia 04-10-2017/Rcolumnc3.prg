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

CLASS TRColumn

     DATA   oReport
     DATA   aData, aTitle, aPicture
     DATA   bDataFont, bTitleFont, bTotalFont, bTotalExpr, bColor
     DATA   cTotalPict
     DATA   nWidth, nDataHeight, nTitleHeight, nTotal, nCol, nSize, nPad,;
            nPen, nOrder, nCalCol, nCurLine
     DATA   lTotal, lShadow, lGrid, lTotalExpr, lUnderline, lDobleUnd, lTextUnd,;
            lSeparator
     DATA   Cargo
     DATA   bStartTotal

     METHOD New( aTitle, nCol, aData, nSize, aPicture,;
                 bFont, lTotal, bTotalExpr, cFmt, lShadow, lGrid,;
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
            bFont      ,;
            lTotal     ,;
            bTotalExpr ,;
            cFmt       ,;
            lShadow    ,;
            lGrid      ,;
            nPen       ,;
            oReport     )  CLASS TRColumn

     DEFAULT aTitle      := {{|| ""} }                   ,;
             aData       := {{|| ""} }                   ,;
             nSize       := 0                            ,;
             aPicture    := {""}                         ,;
             nCol        := 0                            ,;
             bFont       := {|| 1 }                      ,;
             nPen        := 1                            ,;
             lTotal      := .F.                          ,;
             lShadow     := .F.                          ,;
             lGrid       := .F.                          ,;
             cFmt        := iif(Valtype(Eval(aData[1]))=="N",;
                                "RIGHT", "LEFT")

     ::aTitle     = aTitle
     ::aData      = aData
     ::nSize      = nSize
     ::aPicture   = aPicture
     ::bDataFont  = bFont
     ::bTitleFont = {|| 1 }
     ::bTotalFont = bFont
     ::lTotal     = lTotal
     ::lShadow    = lShadow
     ::lGrid      = lGrid
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

     ::lTotalExpr = !(bTotalExpr == NIL)

     IF cFmt == "LEFT"
          ::nPad = RPT_LEFT
     ELSEIF cFmt == "RIGHT"
          ::nPad = RPT_RIGHT
     ELSEIF cFmt == "CENTER" .OR. cFmt == "CENTERED"
          ::nPad = RPT_CENTER
     ELSE
          ::nPad = RPT_LEFT
     ENDIF

     DO WHILE len(::aPicture) < len(::aData)
          Aadd(::aPicture,::cTotalPict)
     ENDDO

RETURN Self

//----------------------------------------------------------------------------//

METHOD Stabilize(nOrder) CLASS TRColumn

     LOCAL nFor, nWidth, nLen

     ::nDataHeight  := ::oReport:oDevice:GetTextHeight(::oReport:cCharPattern, ::oReport:aFont[eval(::bDataFont)])
     ::nTitleHeight := ::oReport:oDevice:GetTextHeight(::oReport:cCharPattern, ::oReport:aFont[eval(::bTitleFont)])

     IF !empty(::nSize)
          ::nWidth := ::oReport:oDevice:GetTextWidth(Replicate(::oReport:cCharPattern,::nSize), ::oReport:aFont[eval(::bDataFont)])
          RETU NIL
     ENDIF


     FOR nFor := 1 TO len(::aData)
          nLen      := len(cValtoChar(Transform(eval(::aData[nFor]),;
                           ::aPicture[nFor])))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate(::oReport:cCharPattern,nLen),;
                       ::oReport:aFont[eval(::bDataFont)])
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     FOR nFor := 1 TO len(::aTitle)
          nLen      := len(eval(::aTitle[nFor]))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate(::oReport:cCharPattern,nLen),;
                       ::oReport:aFont[eval(::bTitleFont)])
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     ::nOrder := nOrder

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTitle(nRow, nCol, nLine)  CLASS TRColumn

     LOCAL oFont
     LOCAL cTitle
     LOCAL nFont

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol ,;
             nLine := 1

     IF nLine > len(::aTitle)
          RETU NIL
     ENDIF

     cTitle := eval(::aTitle[nLine])
     nFont  := eval(::bTitleFont)
     oFont  := ::oReport:aFont[nFont]

     ::nCurLine := nLine

     ::oReport:oDevice:Say(nRow, nCol, cTitle, oFont, ::nWidth,;
                           ::oReport:aClrText[nFont],,::nPad-1)

RETURN NIL


//----------------------------------------------------------------------------//

METHOD SayData(nRow, nCol, nLine)  CLASS TRColumn

     LOCAL oFont
     LOCAL cText
     LOCAL nWidth, nFont

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol ,;
             nLine := 1

     IF nLine > len(::aData)
          RETU NIL
     ENDIF

     ::nCurLine := nLine

     nFont  := eval(::bDataFont)
     oFont  := ::oReport:aFont[nFont]
     cText  := Transform(eval(::aData[nLine]),::aPicture[nLine])
     nWidth := ::oReport:oDevice:GetTextWidth(cText, oFont)

     ::oReport:oDevice:Say(nRow, nCol, cText, oFont, ::nWidth,;
                           ::oReport:aClrText[nFont],,::nPad-1)

      IF ::lUnderline
          ::Underline(::lTextUnd        ,;
                      ::lDobleUnd       ,;
                      nLine             ,;
                      nRow+::nDataHeight)
      ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTotal(nRow, nCol)  CLASS TRColumn

     LOCAL oFont
     LOCAL cText
     LOCAL nFont

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol

     IF !::lTotal
          RETU NIL
     ENDIF

     /*
     Nuevo codigo
     */

     IF ::bStartTotal != nil
          Eval( ::bStartTotal, Self )
     ENDIF

     /*
     Fin del nuevo codigo
     */

     nFont := Eval(::bTotalFont)
     oFont := ::oReport:aFont[nFont]
     cText := Transform(::nTotal,::cTotalPict)

     ::oReport:oDevice:Say(nRow, nCol, cText, oFont, ::nWidth, ::oReport:aClrText[nFont],,::nPad-1)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD TitleHeight( nLine ) CLASS TRColumn

     LOCAL oFontT, oFontD
     LOCAL cText, cChar
     LOCAL nFor, nWidth, nLen, nFontT, nFontD, nLenData

     IF !empty(::nWidth)
          RETU NIL
     ENDIF

     nFontT := eval(::bTitleFont)
     nFontD := eval(::bDataFont)
     oFontT := ::oReport:aFont[nFontT]
     oFontD := ::oReport:aFont[nFontD]
     cChar := ::oReport:cCharPattern

     ::nDataHeight  := len(::aData) * ::oReport:oDevice:GetTextHeight(cChar, oFontD)
     ::nTitleHeight := len(::aTitle) * ::oReport:oDevice:GetTextHeight(cChar, oFontT)

     nLenData := len(::aData)

     FOR nFor := 1 TO nLenData
          cText    := Transform(eval(::aData[nLine]),::aPicture[nLine])
          nLen     := len(cText)
          nWidth   := ::oReport:oDevice:GetTextWidth(Replicate(cChar,nLen), oFontD)
          ::nWidth := Max(::nWidth,nWidth)
     NEXT

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Underline(lTextUnd, lDobleUnd, nLine, nRow)  CLASS TRColumn

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
                      Transform(eval(::aData[nLine]),::aPicture[nLine])),;
                      ::oReport:aFont[eval(::bDataFont)])
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

METHOD Separator(nRow, lForced) CLASS TRColumn

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