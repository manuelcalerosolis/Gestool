/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class LItem for class TLabel                               ³
³         File: LITEM.PRG                                                  ³
³       Author: Manuel Calero Solis                                        ³
³       Telef.: (959) 40.23.83                                             ³
³         Date: 25/04/95                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: by Manuel Calero Solis.                                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
#include "FiveWin.Ch"
#include "Objects.ch"
#include "label.ch"

//----------------------------------------------------------------------------//

CLASS TLItem

	  DATA oLabel
	  DATA aData, aPicture
	  DATA bDataFont
	  DATA nWidth, nDataHeight, nCol, nSize, nPad, nPen
	  DATA lShadow, lGrid

	  METHOD New( nCol, aData, nSize, aPicture, bFont, cFmt, lShadow,;
					 lGrid, oLabel ) CONSTRUCTOR

     METHOD Stabilize()

	  METHOD SayData(nRow, nCol, nLine)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nCol,	aData, nSize, aPicture,	bFont, nPen,;
            cFmt, lShadow, lGrid, oLabel )

	  DEFAULT aData       := {{|| ""} }                   ,;
				 nSize       := 0                            ,;
				 aPicture    := {""}                         ,;
				 nCol        := 0                            ,;
				 bFont       := {|| 1 }                      ,;
				 nPen        := 1                            ,;
				 lShadow     := .F.                          ,;
				 lGrid       := .F.                          ,;
				 cFmt        := iif(Valtype(Eval(aData[1]))=="N",;
										  "RIGHT", "LEFT")

     ::aData      = aData
     ::nSize      = nSize
	  ::aPicture   = aPicture
     ::bDataFont  = bFont
     ::lShadow    = lShadow
     ::lGrid      = lGrid
     ::nPen       = nPen
	  ::oLabel     = oLabel
	  ::nCol       = nCol
	  ::nWidth     = 0

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
			 Aadd(::aPicture, "" )
     ENDDO

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Stabilize()

	  ::nDataHeight  := ::oLabel:oDevice:GetTextHeight("B",;
							  ::oLabel:aFont[eval(::bDataFont)])

	  /*
	  Si le pasan un tama¤o predefinido comprobamos que este sea menor
	  que la etiqueta
	  */

	  IF !empty(::nSize)

			 ::nWidth := ::oLabel:oDevice:GetTextWidth(Replicate("B",::nSize),;
							  ::oLabel:aFont[eval(::bDataFont)])

			 /*
			 Si la anchura calculada es mayor que la de la etiqueta, tendremos
			 que hacer esta igual a la de la etiqueta
			 */

			 IF ::nWidth > ::oLabel:nLblWidth
					 ::nWidth := ::oLabel:nLblWidth
			 END IF

			 RETU NIL

	  END IF

	  ::nWidth := ::oLabel:nLblWidth

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SayData(nRow, nCol, nLine)

     LOCAL nFor
     LOCAL cText
     LOCAL cLine
     LOCAL nWidth
     LOCAL nMemLine

     DEFAULT nRow  := 0      ,;
				 nCol  := 0      ,;
				 nLine := 1

     msginfo( "entro en saydata" )

     IF nLine > len(::aData)
          RETU NIL
	  ENDIF

	  IF ::nCol != 0
			 nCol += ::nCol
	  END IF

     cText  := Transform(eval(::aData[nLine]),::aPicture[nLine])
     nWidth := ::oLabel:oDevice:GetTextWidth(cText,::oLabel:aFont[eval(::bDataFont)])

     DO CASE
          CASE ::nPad == RPT_RIGHT
               nCol := nCol+::nWidth-nWidth

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-Int(nWidth/2)
     ENDCASE

     ::oLabel:oDevice:Say(nRow,nCol,cText,::oLabel:aFont[eval(::bDataFont)],::nWidth,::oLabel:aClrText[eval(::bDataFont)] )

RETURN ( cText )

//----------------------------------------------------------------------------//