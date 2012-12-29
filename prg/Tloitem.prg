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

CLASS TLOItem

	  DATA oLabel
	  DATA aData, aPicture
	  DATA oFont
	  DATA nColor
	  DATA nWidth, nDataHeight, nCol, nSize, nPad, nPen
	  DATA lShadow, lGrid
	  DATA lEan13, lHorz, lBanner

	  METHOD New( nCol, aData, nSize, aPicture, oFont, cFmt, lShadow,;
					 lGrid, lEan13, lHorz, lBanner, nColor, oLabel ) CONSTRUCTOR

     METHOD Stabilize()

	  METHOD SayData(nRow, nCol, nLine)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nCol,	aData, nSize, aPicture,	oFont, nPen,;
            cFmt, lShadow, lGrid, lEan13, lHorz, lBanner, nColor, oLabel )

	  DEFAULT aData       := {{|| ""} }                   ,;
				 nSize       := 0                            ,;
				 aPicture    := {""}                         ,;
				 nCol        := 0                            ,;
				 oFont       := TFont():New( "Ms Sans Serif", 6, 12, .F. ),;
				 nPen        := 1                            ,;
				 lShadow     := .F.                          ,;
				 lGrid       := .F.                          ,;
				 nColor      := 0                            ,;
				 lEan13      := .F.                          ,;
				 lHorz       := .T.                          ,;
				 lBanner     := .T.                          ,;
				 cFmt        := iif(Valtype(Eval(aData[1]))=="N",;
										  "RIGHT", "LEFT")

     ::aData      = aData
     ::nSize      = nSize
	  ::aPicture   = aPicture
	  ::oFont  	   = oFont
     ::lShadow    = lShadow
     ::lGrid      = lGrid
     ::nPen       = nPen
	  ::oLabel     = oLabel
	  ::nCol       = nCol
	  ::nWidth     = 0
	  ::lEan13     = lEan13
	  ::lHorz      = lHorz
	  ::lBanner    = lBanner
	  ::nColor     = nColor

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

RETURN Self

//----------------------------------------------------------------------------//

METHOD Stabilize()

	  ::nDataHeight  := ::oLabel:oDevice:GetTextHeight("B", ::oFont )

	  /*
	  Si la altura calculada es mayor que la de la etiqueta, tendremos
	  que hacer esta igual a la de la etiqueta
	  */

	  IF ::nDataHeight > ::oLabel:nLblHeight
			 ::nDataHeight := ::oLabel:nLblHeight
	  END IF

	  /*
	  Si le pasan un tama¤o predefinido comprobamos que este sea menor
	  que la etiqueta
	  */

/*
     IF !empty(::nSize)

			 ::nWidth := ::oLabel:oDevice:GetTextWidth( Replicate( "B", ::nSize ), ::oFont )
*/
			 /*
			 Si la anchura calculada es mayor que la de la etiqueta, tendremos
			 que hacer esta igual a la de la etiqueta
			 */
/*
			 IF ::nWidth > ::oLabel:nLblWidth
					 ::nWidth := ::oLabel:nLblWidth
			 END IF

     ELSE
*/
          ::nWidth := ::oLabel:nLblWidth
/*
	  END IF
*/
RETURN Self
/*
//----------------------------------------------------------------------------//

METHOD SayData(nRow, nCol, nLine)  CLASS TRItem

	  local cText

     DEFAULT nRow  := 0      ,;
				 nCol  := 0      ,;
				 nLine := 1

	  cText         := Transform( eval( ::aData[nLine]), ::aPicture[nLine] )

     IF nLine > len(::aData)
          RETU NIL
	  ENDIF

	  IF ::nCol != 0
			 nCol += ::nCol
	  END IF

	  DO CASE
			 CASE ::nPad == RPT_RIGHT
					nCol := nCol+::nWidth-;
							  ::oLabel:oDevice:GetTextWidth( cText, ::oFont )

          CASE ::nPad == RPT_CENTER
               nCol := nCol+Int(::nWidth/2)-;
							  Int(::oLabel:oDevice:GetTextWidth( cText, ::oFont)/2)
	  ENDCASE

     ::oLabel:oDevice:Say( nRow, nCol, cText, ::oFont, ::nWidth, ::nColor )

RETURN Self

//----------------------------------------------------------------------------//
*/
METHOD SayData(nRow, nCol, nLine)

     LOCAL cText
     LOCAL nWidth
     LOCAL cLine
     LOCAL nPos      := 0

     DEFAULT nRow  := 0      ,;
				 nCol  := 0      ,;
				 nLine := 1

     IF nLine > len(::aData)
          RETU NIL
	  ENDIF

	  IF ::nCol != 0
			 nCol += ::nCol
	  END IF

     cText  := Transform(eval(::aData[nLine]),::aPicture[nLine])

     while len( cText ) != 0

         nWidth         := ::oLabel:oDevice:GetTextWidth(cText,::oFont)
         cLine          := cText

         while nWidth > ::nWidth
            nPos        := Rat( " ", cLine )
            if nPos != 0
               cLine    := SubStr( cLine, 1, nPos - 1 )
               nWidth   := ::oLabel:oDevice:GetTextWidth( cLine, ::oFont )
            else
               exit
            end if
         end while

         if nPos != 0
            ::oLabel:oDevice:Say( nRow, nCol, cLine, ::oFont, ::nWidth, ::nColor, , ::nPad - 1 )
            ::oLabel:NewLine()
            cText       := SubStr( cText, nPos + 1 )
            nRow        += ::nDataHeight
            nPos        := 0
         else
            ::oLabel:oDevice:Say( nRow, nCol, cText, ::oFont, ::nWidth, ::nColor, , ::nPad - 1 )
            cText       := ""
         end if

     end while

RETURN NIL

//----------------------------------------------------------------------------//