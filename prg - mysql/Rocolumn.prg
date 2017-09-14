/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class RColumn for class TReport                            ³
³         File: RCOLUMN.PRG                                                ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (100042,3051)                                ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 07/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

#include "FiveWin.Ch"
#include "Objects.ch"
#include "Report.ch"

#define SEP_SINGLE        1
#define SEP_DOUBLE        2

//----------------------------------------------------------------------------//

CLASS TRoColumn

     DATA oReport
     DATA aData, aTitle, aPicture
	  DATA oDataFont, oTitleFont, oTotalFont, bTotalExpr
     DATA cTotalPict
     DATA nWidth, nDataHeight, nTitleHeight, nTotal, nCol, nSize, nPad,;
			 nPen, nOrder, nCalCol, nCurLine, nColor
     DATA lTotal, lShadow, lGrid, lTotalExpr, lSeparator, lDobleSep, lTextSep
     DATA lNewLine
     DATA Cargo

	  METHOD New(aTitle, nCol, aData, nSize, aPicture,;
					 oFont, oTitleFont, oTotalFont, lTotal, bTotalExpr, nFmt, lShadow, lGrid,;
					 nColor, oReport  ) CONSTRUCTOR

     METHOD Stabilize()

     METHOD SayTitle(nRow, nCol, nLine)
     METHOD SayData(nRow, nCol, nLine)
     METHOD SayTotal(nRow, nCol)
     METHOD Separator(lTextLength, lDouble, nDataLine, nRow)

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
				oReport     )  CLASS TRColumn

     DEFAULT aTitle      := {{|| ""} }                   ,;
             aData       := {{|| ""} }                   ,;
             nSize       := 0                            ,;
             aPicture    := {{|| ""} }                   ,;
             nCol        := 0                            ,;
				 oFont       := TFont():New( "Ms Sans Serif", 6, 12, .F. ),;
				 nPen        := 1                            ,;
             lTotal      := .F.                          ,;
             lShadow     := .F.                          ,;
				 lGrid       := .F.                          ,;
             lNewLine    := .F.                          ,;
             nColor      := 0                            ,;
             nFmt        := iif(Valtype(Eval(aData[1]))=="N", RPT_RIGHT, RPT_LEFT )

     ::aTitle     = aTitle
     ::aData      = aData
     ::nSize      = nSize
     ::aPicture   = aPicture
	  ::oDataFont  = oFont
	  ::oTitleFont = iif( oTitleFont==NIL, oFont, oTitleFont )
	  ::oTotalFont = iif( oTotalFont==NIL, oFont, oTotalFont )
	  ::lTotal     = lTotal
     ::lShadow    = lShadow
     ::lGrid      = lGrid
     ::lNewLine   = lNewLine
     ::lSeparator = .F.
     ::lDobleSep  = .F.
     ::lTextSep   = .F.
     ::nPen       = nPen
     ::nTotal     = 0
     ::oReport    = oReport
     ::bTotalExpr = bTotalExpr
     ::nCol       = nCol
     ::cTotalPict = iif(len(aPicture)>0, aPicture[1], "")
     ::nWidth     = 0
     ::nCalCol    = 0
     ::nOrder     = 0
	  ::nPad 		= nFmt

     ::nColor     = nColor

	  ::lTotalExpr = !(bTotalExpr == NIL)

	  DO WHILE len(::aPicture) < len(::aData)
          Aadd(::aPicture,::cTotalPict)
     ENDDO

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Stabilize(nOrder) CLASS TRColumn

     LOCAL nFor, nWidth, nLen

	  ::nDataHeight  := ::oReport:oDevice:GetTextHeight("B", ::oDataFont )
	  ::nTitleHeight := ::oReport:oDevice:GetTextHeight("B", ::oTitleFont )

     IF !empty(::nSize)
			 ::nWidth := ::oReport:oDevice:GetTextWidth(Replicate("B",::nSize),;
							  ::oDataFont )
			 RETU NIL
	  ENDIF


	  FOR nFor := 1 TO len(::aData)
          nLen      := len(cValtoChar(Transform(eval(::aData[nFor]),;
									eval( ::aPicture[nFor] ))))
			 nWidth    := ::oReport:oDevice:GetTextWidth(Replicate("B",nLen),;
							  ::oDataFont )
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     FOR nFor := 1 TO len(::aTitle)
          nLen      := len(eval(::aTitle[nFor]))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate("B",nLen),;
							  ::oTitleFont)
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

     ::nOrder := nOrder

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTitle(nRow, nCol, nLine)  CLASS TRColumn

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol ,;
             nLine := 1

     IF nLine > len(::aTitle)
          RETU NIL
     ENDIF

     ::nCurLine := nLine

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-;
                       ::oReport:oDevice:GetTextWidth(eval(::aTitle[nLine]),;
							  ::oTitleFont)

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-;
                       Int(::oReport:oDevice:GetTextWidth(eval(::aTitle[nLine]),;
								  ::oTitleFont)/2)
     ENDCASE

     ::oReport:oDevice:Say(nRow ,;
                           nCol ,;
                           eval(::aTitle[nLine]) ,;
									::oTitleFont,;
									::nWidth,;
									::nColor)

RETURN NIL


//----------------------------------------------------------------------------//

METHOD SayData(nRow, nCol, nLine)  CLASS TRColumn

	  LOCAL nWidth
	  LOCAL nMemLine
	  LOCAL cLine
	  LOCAL cText		:= eval(::aData[nLine])


	  DEFAULT nRow  := 0      ,;
				 nCol  := ::nCol ,;
				 nLine := 1

     IF nLine > len(::aData)
          RETU NIL
     ENDIF

	  IF Valtype( cText ) == "C"
			 cText := rtrim( cText )
	  ENDIF

     ::nCurLine := nLine

     nWidth := ::oReport:oDevice:GetTextWidth(;
                    Transform(eval(::aData[nLine]),eval( ::aPicture[nLine] )),;
						  ::oDataFont )

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-nWidth

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-Int(nWidth/2)
     ENDCASE

	  /*
	  Quizas

	  ::oReport:oDevice:GetTextWidth( Replicate( "B", len( cText ) ) )

	  */

	  IF Valtype( cText ) == "C" .AND. len( cText ) > ::nSize

			 nMemLine := mlCount( cText, ::nSize )

			 FOR nFor := 1 TO nMemLine

					cLine := rTrim( MemoLine( cText, ::nSize, nFor ) )

					::oReport:StartLine()
					::oReport:oDevice:Say( ::oReport:nRow,;
												  nCol,;
												  cLine,;
												  ::oDataFont,;
												  nWidth,;
												  ::nColor )
					::oReport:EndLine()

          NEXT

          if !::lNewLine
               ::oReport:BackLine(1)
          end if

	  ELSE

          ::oReport:oDevice:Say(nRow,;
										  nCol,;
										  Transform( cText, eval( ::aPicture[nLine] ) ),;
										  ::oDataFont,;
										  nWidth,;
										  ::nColor )

          if ::lNewLine
               ::oReport:NewLine()
          end if

	  END IF

	  IF ::lSeparator
			 ::Separator(::lTextSep        ,;
							 ::lDobleSep       ,;
							 nLine             ,;
							 nRow+::nDataHeight)
	  ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayTotal(nRow, nCol)  CLASS TRColumn

     DEFAULT nRow  := 0      ,;
             nCol  := ::nCol

     IF !::lTotal
          RETU NIL
     ENDIF

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-;
                       ::oReport:oDevice:GetTextWidth(Transform(::nTotal,::cTotalPict),;
							  ::oTotalFont)

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-;
                       Int(::oReport:oDevice:GetTextWidth(Transform(::nTotal,::cTotalPict),;
								  ::oTotalFont)/2)
     ENDCASE

     ::oReport:oDevice:Say(nRow,;
                           nCol,;
                           Transform(::nTotal, ::cTotalPict),;
									::oTotalFont,;
									::nWidth,;
									::nColor	)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD TitleHeight(nLine) CLASS TRColumn

     LOCAL nFor, nWidth, nLen

     ::nDataHeight  := len(::aData) * ;
                       ::oReport:oDevice:GetTextHeight("B",;
							  ::oDataFont)
     ::nTitleHeight := len(::aTitle) * ;
                       ::oReport:oDevice:GetTextHeight("B",;
							  ::oTitleFont)

     IF !empty(::nWidth)
          RETU NIL
     ENDIF

     FOR nFor := 1 TO len(::aData)
          nLen      := cValtoChar(len(eval(::aLine [nFor])))
          nWidth    := ::oReport:oDevice:GetTextWidth(Replicate("B",nLen),;
							  ::oDataFont )
          ::nWidth  := Max(::nWidth,nWidth)
     NEXT

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Separator(lTextSep, lDobleSep, nLine, nRow)  CLASS TRColumn

     LOCAL nLeft, nRight, nWidth

     DEFAULT lTextSep  := ::lTextSep  ,;
             lDobleSep := ::lDobleSep ,;
             nLine     := 1           ,;
             nRow      := ::oReport:nRow

     DO CASE
     CASE !lTextSep .AND. ::lGrid
          nLeft  := ::nCalCol  + Int(::oReport:nSeparator/2)
          nRight := nLeft + ::nWidth + Int(::oReport:nSeparator/2)
     CASE lTextSep
          nWidth := ::oReport:oDevice:GetTextWidth(alltrim(;
                      Transform(eval(::aData[nLine]),eval( ::aPicture[nLine] ))),;
							 ::oDataFont )
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


     IF lDobleSep
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