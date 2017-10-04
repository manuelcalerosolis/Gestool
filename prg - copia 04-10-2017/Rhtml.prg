/*
*/
#include "FiveWin.Ch"

//----------------------------------------------------------------------------//

CLASS TRHtml

     DATA hDC
     DATA aPreRows
     DATA aPosRows
     DATA aRows
     DATA cDocument
     DATA cFile
     DATA nHeight
     DATA nWidth

     METHOD New(cFile) CONSTRUCTOR

     METHOD StartPage()    INLINE   Afill(::aRows,"")
     METHOD EndPage()      VIRTUAL

     METHOD End()          VIRTUAL

     METHOD Say( nRow, nCol, cText, oFont, nPad )

     METHOD SetHeight(nHeight)   INLINE aSize(::aRows, nHeight) ,;
                                        ::StartPage()

     METHOD GetTextWidth(cText)  INLINE len(cText)
     METHOD GetTextHeight(cText) INLINE 1

     METHOD SetSize( nWidth, nHeight ) INLINE ( ::nWidth  := nWidth, ::SetHeight( nHeight ) )

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

METHOD New( cFile )

     ::cFile    := cFile

     ::nHeight  := 64
     ::nWidth   := 80

     ::hDC      := fCreate( ::cFile )

     IF ::hDC < 0
          ::hDC := 0
     ENDIF

     fWrite(::hDC, '<HTML>' + CRLF )
     fWrite(::hDC, '<HEAD>' + CRLF )
     fWrite(::hDC, '<TITLE>' + cFile + '</TITLE>' )
     fWrite(::hDC, '</HTML>' + CRLF )
     fWrite(::hDC, '</HEAD>' + CRLF )

     ::aRows      := Array(::nHeight)
     ::aPreRows   := Array(::nHeight)
     ::aPosRows   := Array(::nHeight)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont, nMaxSize, nPad )

     DEFAULT nMaxSize := len(cText)

     fWrite(::hDC, '<TABLE BORDER="1" >' + CRLF )


     cText := AnsiToXml( cText, nCol, nPad )

     /*
     msginfo(  "nRow" + Str( nRow, 3 ) + CRLF + ;
               "nCol" + Str( nCol, 3 ) + CRLF + ;
               "cTxt" + cText )
     */

     nRow++

     IF nRow > len(::aRows) .OR. nRow < 1
          RETU NIL
     ENDIF

     ::aRows[nRow] += cText

RETURN NIL

//---------------------------------------------------------------------------//

static function AnsiToXml( cText, nRow )

   cText := '<nCol' + lTrim( Str( nRow, 3 ) ) + '>' + cText + '</nCol' + lTrim( Str( nRow, 3 ) ) + '>'

return ( cText )

//---------------------------------------------------------------------------//




















































































































































































































































































































































