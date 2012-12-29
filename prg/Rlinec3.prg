/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RLine for class TReport                              ³
³         File: RLINE.PRG                                                  ³
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

//----------------------------------------------------------------------------//

CLASS TRLine

     DATA oReport
     DATA aLine, aFont, aRow, aWidth, aPad
     DATA nCol, nHeight, nWidth
     DATA Cargo

     METHOD New(aLine, oReport, nPad) CONSTRUCTOR

     METHOD Stabilize(nFirstRow, nFirstCol)

     METHOD Say(nStartRow)

     METHOD Add(bLine, bFont, nPad)
     METHOD Ins(nLine, bLine, bFont, nPad)
     METHOD Del(nLinIni, nLinFin)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( aLine      ,;
            oReport    ,;
            nPad         )  CLASS TRLine

     DEFAULT nPad  := RPT_LEFT

     IF len(aLine) == 0
          aLine := {{|| ""} }
     ENDIF

     ::aLine   = aLine
     ::oReport = oReport
     ::aFont   = Afill(Array(len(aLine)),{|| 1 })
     ::aPad    = Afill(Array(len(aLine)), nPad )
     ::aWidth  = Afill(Array(len(aLine)), 0 )

RETURN Self

//----------------------------------------------------------------------------//

METHOD Stabilize(nFirstRow,nFirstCol) CLASS TRLine

     LOCAL nFor, nTmpRow

     DEFAULT nFirstRow := 0 ,;
             nFirstCol := 0

     nTmpRow := nFirstRow

     ::aRow   := array(len(::aLine ))
     ::nCol   := nFirstCol
     ::nWidth := 0

     IF eval(::aLine[1]) == ""
          Afill(::aWidth,0)
          ::nHeight := 0
          RETU NIL
     ENDIF

     FOR nFor := 1 TO len(::aRow)
          ::aRow[nFor]   := nTmpRow
          nTmpRow        += ::oReport:oDevice:GetTextHeight(eval(::aLine [nFor]),;
                            ::oReport:aFont[eval(::aFont[nFor])])
          ::aWidth[nFor] := ::oReport:oDevice:GetTextWidth(eval(::aLine [nFor]),;
                            ::oReport:aFont[eval(::aFont[nFor])])
          ::nWidth       := Max(::nWidth,::aWidth[nFor])
     NEXT

     ::nHeight := nTmpRow - nFirstRow

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say(nStartRow) CLASS TRLine

     LOCAL nFor, nCol, nWidth

     DEFAULT nStartRow := 0


     IF eval(::aLine[1]) == ""
          RETU NIL
     ENDIF

     FOR nFor := 1 TO len(::aLine )

          nWidth := ::oReport:oDevice:GetTextWidth(eval(::aLine [nFor]),;
                    ::oReport:aFont[eval(::aFont[nFor])])

          DO CASE
               CASE ::aPad[nFor] == RPT_LEFT
                    nCol := ::nCol
               CASE ::aPad[nFor] == RPT_RIGHT
                    nCol := ::oReport:nMargin+;
                            ::oReport:nRptWidth-;
                            nWidth
               CASE ::aPad[nFor] == RPT_CENTER
                    nCol := ::oReport:nMargin+;
                            Int(::oReport:nRptWidth/2)-;
                            Int(nWidth/2)
               OTHERWISE
                    nCol := ::nCol
          ENDCASE

          ::oReport:oDevice:Say(::aRow[nFor]+nStartRow ,;
                                nCol ,;
                                eval(::aLine [nFor]),;
                                ::oReport:aFont[eval(::aFont[nFor])] ,;
                                NIL ,;
                                ::oReport:aClrText[eval(::aFont[nFor])])

     NEXT

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Add(bLine, bFont, nPad) CLASS TRLine

     DEFAULT bLine := {|| "" }   ,;
             bFont := ::aFont[1] ,;
             nPad  := RPT_LEFT

     Aadd(::aLine, bLine)
     Aadd(::aFont, bFont)
     Aadd(::aPad, nPad)
     Aadd(::aWidth, 0)

     IF ::oReport:lStable
          ::oReport:Stabilize()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Ins(nLine, bLine, bFont, nPad) CLASS TRLine

     LOCAL nNewLen := len(::aLine) + 1

     DEFAULT nLine := 1          ,;
             bLine := {|| "" }   ,;
             bFont := ::aFont[1] ,;
             nPad  := RPT_LEFT

     ASize(::aLine,  nNewLen)
     ASize(::aFont,  nNewLen)
     ASize(::aPad,   nNewLen)
     ASize(::aWidth, nNewLen)

     Ains(::aLine,  nLine)
     Ains(::aFont,  nLine)
     Ains(::aPad,   nLine)
     Ains(::aWidth, nLine)

     ::aLine[nLine]  := bLine
     ::aFont[nLine]  := bFont
     ::aPad[nLine]   := nPad
     ::aWidth[nLine] := 0

     IF ::oReport:lStable
          ::oReport:Stabilize()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Del(nLinIni, nLinFin) CLASS TRLine

     LOCAL nFor, nLen

     DEFAULT nLinFin := nLinIni

     nLen := len(::aLine) - (nLinFin - nLinIni + 1)

     FOR nFor := 1 TO (nLinFin - nLinIni + 1)
          Adel(::aLine,nLinIni)
          Adel(::aFont, nLinIni)
          Adel(::aRow,nLinIni)
          Adel(::aWidth,nLinIni)
          Adel(::aPad,nLinIni)
     NEXT

     ASize(::aLine, nLen)
     ASize(::aFont, nLen)
     ASize(::aRow, nLen)
     ASize(::aWidth, nLen)
     ASize(::aPad, nLen)

     IF ::oReport:lStable
          ::oReport:Stabilize()
     ENDIF

RETURN NIL