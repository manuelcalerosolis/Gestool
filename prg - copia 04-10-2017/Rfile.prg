/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class TRFile for class TReport                             ³
³         File: RFILE.PRG                                                  ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (Ignacio_Ortiz)                              ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 07/28/94                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1994 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TRFile

     DATA hDC
     DATA aRows
     DATA cDocument
     DATA cPrnComp
     DATA nHeight
     DATA nWidth
     DATA lPrint           INIT .T.

     METHOD New(cFile) CONSTRUCTOR

     METHOD StartPage()  INLINE Afill(::aRows,"")
     METHOD EndPage()

     METHOD End()        INLINE fClose(::hDC)

     METHOD Say( nRow, nCol, cText, oFont )

     METHOD SetHeight(nHeight)   INLINE aSize(::aRows, nHeight) ,;
                                        ::StartPage()

     METHOD GetTextWidth(cText)  INLINE len(cText)
     METHOD GetTextHeight(cText) INLINE 1

     METHOD SetSize( nWidth, nHeight ) INLINE (::nWidth  := nWidth ,;
                                               ::SetHeight(nHeight) )

     METHOD GetPhySize() INLINE ({::nWidth, ::nHeight})

     METHOD CharWidth()  INLINE 1
     METHOD CharHeight() INLINE 1

     METHOD nVertRes()        INLINE  ::nHeight
     METHOD nHorzRes()        INLINE  ::nWidth

     METHOD nVertSize()       INLINE  (::nHeight * 25.4)
     METHOD nHorzSize()       INLINE  (::nWidth  * 25.4)

     METHOD nLogPixelX()      INLINE 1
     METHOD nLogPixelY()      INLINE 1

     METHOD CharSay(nRow, nCol, cText) INLINE ::Say(nRow, nCol, cText)

     METHOD GetOrientation()  INLINE  2

     METHOD SayBitmap()       VIRTUAL
     METHOD SetPos()          VIRTUAL
     METHOD Line()            VIRTUAL
     METHOD Box()             VIRTUAL

     METHOD SetPixelMode()    VIRTUAL
     METHOD SetTwipsMode()    VIRTUAL

     METHOD SetLoInchMode()   VIRTUAL
     METHOD SetHiInchMode()   VIRTUAL

     METHOD SetLoMetricMode() VIRTUAL
     METHOD SetHiMetricMode() VIRTUAL

     METHOD SetIsotropicMode()   VIRTUAL
     METHOD SetAnisotropicMode() VIRTUAL

     METHOD SetWindowExt()    VIRTUAL

     METHOD SetViewPortExt()  VIRTUAL

     METHOD FillRect()        VIRTUAL

     METHOD SetLandscape()             VIRTUAL
     METHOD SetPortrait()              VIRTUAL
     METHOD SetCopies( nCopies )       VIRTUAL
     METHOD Setup()                    VIRTUAL
     METHOD Rebuild()                  VIRTUAL
     METHOD Font(oFont)                VIRTUAL

     METHOD Inch2Pix()                 VIRTUAL

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(cFile) CLASS TRFile

     ::cPrnComp := ""   // Chr(15)
     ::nHeight  := 1000
     ::nWidth   := 40

     ::hDC := fCreate(cFile)

     IF ::hDC < 0
          ::hDC := 0
     ENDIF

     ::aRows := Array(::nHeight)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TRFile

     LOCAL nFor

     IF ::lPrint
          FOR nFor := 1 TO ::nHeight
               IF len(::aRows[nFor]) > ::nWidth
                    fWrite(::hDC, ::cPrnComp)
                    EXIT
               ENDIF
          NEXT
     ENDIF

     FOR nFor := 1 TO ::nHeight
          fWrite(::hDC, ::aRows[nFor]+CRLF)
     NEXT

     IF ::lPrint
          fWrite(::hDC,Chr(12))
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say(nRow, nCol, cText, oFont,nMaxSize) CLASS TRFile

     LOCAL cBefore, cAfter

     DEFAULT nMaxSize := len(cText)

     IF IsAnsi(cText)
          cText := AnsiToOem(cText)
     ENDIF

     nRow++

     IF nRow > len(::aRows) .OR. nRow < 1
          RETU NIL
     ENDIF

     IF len(::aRows[nRow]) < nCol
          cBefore := Padr(::aRows[nRow],nCol-1)
     ELSE
          cBefore := Substr(::aRows[nRow],1,nCol-1)
     ENDIF

     IF len(::aRows[nRow]) < (nCol+nMaxSize-1)
          cAfter := ""
     ELSE
          cAfter := Substr(::aRows[nRow],nCol+nMaxSize)
     ENDIF

     ::aRows[nRow] := cBefore + Padr(cText, nMaxSize) + cAfter

RETURN NIL

//----------------------------------------------------------------------------//