/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RGroup for class TReport                             ³
³         File: RGROUP.PRG                                                 ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (100042,3051)                                ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 07/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
#include "FiveWin.Ch"
#include "objects.ch"
#include "font.ch"
#include "report.ch"

//----------------------------------------------------------------------------//

CLASS TRGroup

     DATA oReport
     DATA aTotal
     DATA bGroup, bHeader, bFooter, bHeadFont, bFootFont
     DATA cValue, cOldValue
     DATA nCounter, nHeaderHeight, nFooterHeight, nOrder
     DATA lEject, lNeedStart, lHeader, lFooter
     DATA Cargo

     METHOD New(bGroup, bHeader, bFooter, bFont, lEject, oReport) CONSTRUCTOR

     METHOD Reset() INLINE Afill(::aTotal,0)      ,;
                           ::nCounter := 0        ,;
                           ::cValue := ::cOldValue

     METHOD Stabilize()
     METHOD Header(nRow)
     METHOD Footer(nRow)
     METHOD Total(nRow)

     METHOD Evaluate() INLINE ::nCounter++

     METHOD Check()    INLINE !(::cOldValue := cValToChar(Eval(::bGroup)) ,;
                                ::cOldValue == ::cValue )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( bGroup     ,;
            bHeader    ,;
            bFooter    ,;
            bFont      ,;
            lEject     ,;
            oReport     )  CLASS TRGroup

     DEFAULT bGroup      := {|| ""}          ,;
             bHeader     := {|| ""}          ,;
             bFooter     := {|| "Total..."}  ,;
             bFont       := {|| 1 }          ,;
             lEject      := .F.

     ::bGroup     = bGroup
     ::bHeader    = bHeader
     ::bFooter    = bFooter
     ::bHeadFont  = bFont
     ::bFootFont  = bFont
     ::oReport    = oReport
     ::lEject     = lEject
     ::lHeader    = .F.
     ::lFooter    = .F.
     ::lNeedStart = .F.
     ::cValue     = ""
     ::cOldValue  = ""
     ::nCounter   = 0
     ::nOrder     = 0

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Total(nRow)  CLASS TRGroup

     LOCAL bFont
     LOCAL nFor, nColumns, nCol

     DEFAULT nRow  := 0

     nColumns := len(::oReport:aColumns)

     IF !(::oReport:lTotal)
          RETU NIL
     ENDIF

     FOR nFor := 1 TO nColumns

          IF !(::oReport:aColumns[nFor]:lTotal)
               LOOP
          ENDIF

          bFont := ::oReport:aColumns[nFor]:bTotalFont

          DO CASE

               CASE ::oReport:aColumns[nFor]:nPad == RPT_LEFT
                    nCol := ::oReport:aCols[nFor]

               CASE ::oReport:aColumns[nFor]:nPad == RPT_RIGHT
                    nCol := ::oReport:aCols[nFor]+;
                            ::oReport:aColumns[nFor]:nWidth-;
                            ::oReport:oDevice:GetTextWidth(;
                              Transform(::aTotal[nFor],;
                                        ::oReport:aColumns[nFor]:cTotalPict),;
                              ::oReport:aFont[eval(bFont)])

               CASE ::oReport:aColumns[nFor]:nPad == RPT_CENTER
                    nCol := ::oReport:aCols[nFor]+;
                            Int(::oReport:aColumns[nFor]:nWidth/2)-;
                            Int(::oReport:oDevice:GetTextWidth(;
                              Transform(::Total[nFor],;
                                        ::oReport:aColumns[nFor]:cTotalPict),;
                               ::oReport:aFont[eval(bFont)])/2)
               OTHERWISE
                    nCol := ::oReport:aCols[nFor]
          ENDCASE

          ::oReport:oDevice:Say(::oReport:nRow ,;
                                nCol ,;
                                Transform(::aTotal[nFor],;
                                ::oReport:aColumns[nFor]:cTotalPict),;
                                ::oReport:aFont[eval(bFont)] ,;
                                NIL                          ,;
                                ::oReport:aClrText[eval(bFont)])

     NEXT

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Stabilize(nOrder) CLASS TRGroup

     ::aTotal    := Array(len(::oReport:aColumns))
     ::cOldValue := cValToChar(Eval(::bGroup))
     ::cValue    := ::cOldValue


     IF eval(::bHeader) == ""
          ::nHeaderHeight := 0
     ELSE
          ::nHeaderHeight := ::oReport:oDevice:GetTextHeight(eval(::bHeader),;
                             ::oReport:aFont[eval(::bHeadFont)] )
     ENDIF

     IF eval(::bFooter) == ""
          ::nFooterHeight := 0
     ELSE
          ::nFooterHeight := ::oReport:oDevice:GetTextHeight(eval(::bFooter),;
                             ::oReport:aFont[eval(::bFootFont)] )
     ENDIF

     ::lHeader := !(eval(::bHeader) == "")
     ::lFooter := !(eval(::bFooter) == "")
     ::nOrder  := nOrder

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Header(nRow) CLASS TRGroup

     IF !::lHeader
          RETU .F.
     ENDIF

     ::oReport:oDevice:Say(nRow ,;
                           ::oReport:nMargin ,;
                           eval(::bHeader) ,;
                           ::oReport:aFont[eval(::bHeadFont)] ,;
                           NIL     ,;
                           ::oReport:aClrText[eval(::bHeadFont)],2)

     IF eval(::bFooter) == "" .AND. ::oReport:lSummary
          ::Total(nRow)
     ENDIF

RETURN .T.

//----------------------------------------------------------------------------//

METHOD Footer(nRow) CLASS TRGroup

     IF !::lFooter
          IF !::oReport:lSummary
               ::Total(nRow)
          ENDIF
          RETU .F.
     ENDIF

     ::oReport:oDevice:Say(nRow ,;
                           ::oReport:nMargin ,;
                           eval(::bFooter) ,;
                           ::oReport:aFont[eval(::bFootFont)] ,;
                           NIL  ,;
                           ::oReport:aClrText[eval(::bFootFont)],2)

     ::Total(nRow)

RETURN .T.