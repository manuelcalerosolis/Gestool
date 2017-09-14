/*
ÚÄ Programa ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Aplication: Class TDosPrint                                            ³
³         File: TDOSPRN.PRG                                                ³
³       Author: Ignacio Ortiz de Z£¤iga Echeverr¡a                         ³
³          CIS: Ignacio Ortiz (Ignacio_Ortiz)                              ³
³     Internet: http://ourworld.compuserve.com/homepages/Ignacio_Ortiz     ³
³         Date: 09/13/96                                                   ³
³         Time: 20:20:07                                                   ³
³    Copyright: 1997 by Ortiz de Zu¤iga, S.L.                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

NOTES:

This peace of software is freeware and is not part of FiveWin.

The following code will let you print directly to the printer from inside
any Fivewin program, like OLD DOS days. Those users that need DOS printing
speed can use this class instead of the TPrinter class.

The use of the class is very easy and is very similar to the TPrinter class
of Fivewin, but we have not create any command to avoid the use of any
static vars.

This is a little sample of how to use the new class:

  LOCAL oPrn

  oPrn := TDosPrn():New("lpt1")

  oPrn:StartPage()                                    // optional
  oPrn:Say(10,20, "This goes in line 10, column 20")
  oPrn:EndPage()                                      // optional

  oPrn:End()

A little description of all the members of this class:

DATA:

 cPort:        Printing port, by default "LPT1"
 cCompress:    String for compressed mode, by default "15"
 cNormal:      String for normal mode, by default "18"
 cFormFeed:    String for EJECT, by default "12"
 hDC:          Printing file Handle (Internal use)
 nRow:         Current printing row
 nCol:         Current pringing column
 nLeftMargin:  Left margin, by default 0
 nTopMargin:   Top margin, by default 0
 lAnsiToOem:   If .T. a Ansi to Oem translation is done automatically
               whe printing, by default is .T.

METHODS:

 New(cPort)    Constructor, no comment
 End()         Destructor, no comment
 StartPage()   Begining of a page, this method is optional
 EndPage()     End of page, this method is optional if there is only on page
 Command(c)    Let you send any command to the printer without changing the
               current row and col. The string to pass as a parameter should
               content the ascii values of the command separated with commas,
               for example, the command to reset Epson printers should
               be: "27,69"
 SetCoors(r,c) Let you change the current row and col is the equivalent of
               SetPrc() of Ca-Clipper
 NewLine()     Increments the current row
 Write(cText)  Prints the string cText in the current row and column
 Say(nRow   ,; Prints the string cText in nRow, nCol
     nCol   ,; lAtoO indicates if the string should be transformed to Oem,
     cText  ,; by default is ::lAnsiToOem
     lAtoO )
 SayCmp()      The same as the method Say but prints in compressed mode and
               the row is updated accordly.

NOTE:

If you try TO PRINTER on a row before the current one a EJECT will be
done automatically.

In the same way if you try TO PRINTER on the same row as the current, but
in a previous column from the current one a EJECT will be done automatically

At the end of this class is a little function call WorkSheet that will make
the job of DOS printing a lot easier.

Enjoy it!
*/

#include "FiveWin.Ch"
#include "objects.ch"

#translate nTrim(<n>)  => AllTrim(Str(<n>,10,0))

//----------------------------------------------------------------------------//

CLASS TDosPrn

     DATA LastError
     DATA cPort, cCompress, cNormal, cFormFeed, cBuffer
     DATA hDC, nRow, nCol, nLeftMargin, nTopMargin
     DATA lAnsiToOem

     METHOD New(cPort) CONSTRUCTOR

     METHOD End()

     METHOD StartPage()  VIRTUAL
     METHOD EndPage()

     METHOD Command(cStr1, cStr2, cStr3, cStr4, cStr5)

     METHOD SetCoors(nRow, nCol)

     METHOD NewLine()       INLINE (::cBuffer += CRLF ,;
                                    ::nRow++          ,;
                                    ::nCol    := 0     )

     METHOD Write(cText, lAToO) ;
            INLINE (iif(lAtoO == NIL, lAtoO := .T.,),;
                    ::cBuffer += iif(lAtoO, AnsitoOem(cText), cText) ,;
                    ::nCol    += len(cText)                           )

     METHOD Say(nRow, nCol, cText)

     METHOD SayCmp(nRow, nCol, cText)

     METHOD LoadFile( cFile )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(cPort, lFile) CLASS TDosPrn

     DEFAULT cPort := "LPT1" ,;
             lFile := .T.

     cPort := Upper(cPort)

     ::cCompress   := "15"
     ::cNormal     := "18"
     ::cFormFeed   := "12"
     ::cBuffer     := ""
     ::nLeftMargin := 0
     ::nTopMargin  := 0
     ::nRow        := 0
     ::nCol        := 0
     ::lAnsiToOem  := .T.
     ::cPort       := cPort+iif(!"."$cPort,".PRN","")
     ::hDC         := fCreate(::cPort)
     ::LastError   := 0

     IF ::hDC < 0
          ::LastError := fError()
     ENDIF

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End() CLASS TDosPrn

     IF !empty(::nRow+::nCol)
          ::EndPage()
     ENDIF

     ::LastError := 0

     IF !fClose(::hDC)
          ::LastError := fError()
     ENDIF

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndPage() CLASS TDosPrn

     ::Command(::cFormFeed)

     ::LastError := 0

     IF fWrite(::hDC, ::cBuffer) < len(::cBuffer)
          ::LastError := fError()
     ENDIF

     ::cBuffer := ""
     ::nRow    := 0
     ::nCol    := 0

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Command(cStr1, cStr2, cStr3, cStr4, cStr5) CLASS TDosPrn

     LOCAL cCommand, cToken, cString
     LOCAL nToken

     cString  := cStr1

     IF cStr2 != NIL
          cString += ","+cStr2
     ENDIF

     IF cStr3 != NIL
          cString += ","+cStr3
     ENDIF

     IF cStr4 != NIL
          cString += ","+cStr4
     ENDIF

     IF cStr5 != NIL
          cString += ","+cStr5
     ENDIF

     cCommand := ""
     nToken   := 1

     DO WHILE !Empty(cToken := StrToken(cString, nToken++, ","))
          cCommand += Chr(Val(cToken))
     ENDDO

     ::cBuffer += cCommand

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SetCoors(nRow, nCol) CLASS TDosPrn

     nRow += ::nTopMargin
     nCol += ::nLeftMargin

     IF ::nRow > nRow
          ::EndPage()
          ::StartPage()
     ENDIF

     IF nRow == ::nRow  .AND. nCol < ::nCol
          ::EndPage()
          ::StartPage()
     ENDIF

     DO WHILE ::nRow < nRow
          ::NewLine()
     ENDDO

     IF nCol > ::nCol
          ::Write(Space(nCol-::nCol))
     ENDIF

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Say(nRow, nCol, cText, lAToO) CLASS TDosPrn

     DEFAULT lAToO := ::lAnsiToOem

     ::SetCoors(nRow, nCol)
     ::Write(cText, lAToO)

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD SayCmp(nRow, nCol, cText, lAToO) CLASS TDosPrn

     DEFAULT lAToO := ::lAnsiToOem

     ::SetCoors(nRow, nCol)
     ::Command(::cCompress)
     ::cBuffer += iif(lAToO, AnsitoOem(cText), cText)
     ::nCol    += Int(len(cText)/1.7+.5)
     ::Command(::cNormal)

RETURN ( Self )

//----------------------------------------------------------------------------//

FUNCTION WorkSheet(cPort)

     LOCAL oPrn
     LOCAL cLine
     LOCAL nFor

     cLine := ""

     FOR nFor := 0 TO 7
          cLine += Str(nFor,1)+Replicate(".",9)
     NEXT

     cLine := Substr(cLine,3)

     oPrn := TDosPrn():New(cPort)

     oPrn:StartPage()

     FOR nFor := 0 TO 65
          oPrn:Say(nFor,0,StrZero(nFor,2)+cLine)
     NEXT

     oPrn:EndPage()

     oPrn:End()

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD LoadFile( cFile ) CLASS TDosPrn

     local cRead
     local hFile
     local nBytes
     local nBufSize  := 2000

     if !file( cFile )
         return nil
     end if

     ::cBuffer := ""

     hFile  := FOpen( cFile )
     while ( nBytes := FRead( hFile, @cRead, nBufSize ) ) > 0
          ::cBuffer  := SubStr( cRead, 1, nBytes )
     end

     ::cBuffer := AnsiToOem( ::cBuffer )
     FClose( hFile )

RETURN ( Self )

//----------------------------------------------------------------------------//