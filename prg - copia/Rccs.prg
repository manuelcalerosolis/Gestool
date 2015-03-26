#include "FiveWin.Ch"
#include "Font.ch"

#define HORZSIZE            4
#define VERTSIZE            6
#define HORZRES             8
#define VERTRES            10
#define LOGPIXELSX         88
#define LOGPIXELSY         90

//----------------------------------------------------------------------------//

CLASS TRCcs

   DATA hDC
   DATA hDCOut
   DATA aRows
   DATA oFont
   DATA cFile
   DATA hFile     AS NUMERIC  INIT  0
   DATA nFile     AS NUMERIC  INIT  1
   DATA lMeta     AS LOGIC    INIT  .f.
   DATA nXOffset
   DATA nYOffset
   DATA lPrvModal AS LOGIC    INIT  .t.

   METHOD New( cFile ) CONSTRUCTOR

   METHOD StartPage()

   METHOD EndPage()

   METHOD End()

   METHOD Say( nRow, nCol, cText, oFont )

   METHOD SetHeight(nHeight)   VIRTUAL

   METHOD GetTextWidth( cText, oFont )    INLINE GetTextWidth( ::hDC, cText, ::SetFont( oFont ):hFont )

   METHOD GetTextHeight( cText, oFont )   INLINE ::SetFont( oFont ):nHeight

   METHOD SetSize( nWidth, nHeight ) VIRTUAL

   METHOD GetPhySize() INLINE ({::nWidth, ::nHeight})

   METHOD CharWidth()   INLINE 1
   METHOD CharHeight()  INLINE 2

   METHOD nVertRes()  INLINE  GetDeviceCaps( ::hDC, VERTRES  )
   METHOD nHorzRes()  INLINE  GetDeviceCaps( ::hDC, HORZRES  )

   METHOD nVertSize() INLINE  GetDeviceCaps( ::hDC, VERTSIZE )
   METHOD nHorzSize() INLINE  GetDeviceCaps( ::hDC, HORZSIZE )

/*
   METHOD nVertRes()  INLINE  1
   METHOD nHorzRes()  INLINE  1

   METHOD nVertSize() INLINE  800
   METHOD nHorzSize() INLINE  600
*/

   METHOD nLogPixelX() INLINE GetDeviceCaps( ::hDC, LOGPIXELSX )
   METHOD nLogPixelY() INLINE GetDeviceCaps( ::hDC, LOGPIXELSY )

   METHOD CharSay(nRow, nCol, cText) INLINE ::Say(nRow, nCol, cText)

   METHOD GetOrientation()  INLINE  2

   METHOD SayBitmap()       VIRTUAL
   METHOD SetPos()          VIRTUAL

   METHOD Line()
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

   METHOD CreateFile()

   METHOD SetFont( oFont )

   METHOD Pix2MmX( nRow ) INLINE  ( nRow * 25.4 / ::nLogPixelX() )

   METHOD Pix2MmY( nCol ) INLINE  ( nCol * 25.4 / ::nLogPixelY() )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New(cFile)

   ::hFile  := 0
   ::nFile  := 1
   ::lMeta  := .f.

   ::cFile  := cFile
   ::hDC    := GetPrintDefault( GetActiveWindow() )

RETURN Self

//----------------------------------------------------------------------------//

METHOD End()

   If ::hDC != 0
      DeleteDC(::hDC)
      ::hDC := 0
   endif

RETURN nil

//---------------------------------------------------------------------------//

METHOD CreateFile()

   if File( ::cFile + StrZero( ::nFile, 5 ) + ".Htm" )
      fErase( ::cFile + StrZero( ::nFile, 5 ) + ".Htm" )
   end if

   ::hFile     := fCreate( ::cFile + StrZero( ::nFile, 5 ) + ".Htm" )

   if ::hFile < 0
      ::hFile  := 0
   endif

   ::aRows     := {}

   aAdd( ::aRows, '<HTML>' )
   aAdd( ::aRows, '<HEAD>' )
   aAdd( ::aRows, '</HEAD>' )
   aAdd( ::aRows, '<BODY style="border: 0 0;margin: 0 0 0 0;overflow-x: hidden;">' )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD StartPage()

   if ::hFile == 0
      ::CreateFile()
   end if

   ::nFile++

RETURN NIL

//----------------------------------------------------------------------------//

METHOD EndPage()

   local nFor

   aAdd( ::aRows, '</BODY>' )
   aAdd( ::aRows, '</HTML>' )

   for nFor := 1 TO len( ::aRows )
      fWrite( ::hFile, ::aRows[ nFor ] + CRLF )
   next

   fClose( ::hFile )

   ::hFile := 0

RETURN NIL

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont, nMaxSize )

   local cChar

   cChar := '<P CLASS="DEFAULT" style="'
   cChar += 'position:absolute;'
   cChar += 'font-family:' + Rtrim( oFont:cFaceName ) + ';'
   cChar += 'font-size:' + Ltrim( Str( Round( oFont:nHeight / ::nLogPixelY() * 72, 0 ) ) ) + ';'
   cChar += 'top:' + Ltrim( Str( ::Pix2MmX( nRow ) ) ) + 'mm;'
   cChar += 'left:' + Ltrim( Str( ::Pix2MmY( nCol ) ) ) + 'mm;'
   cChar += '">'
   cChar += StrTran( cText, Space( 1 ), '&nbsp;' )
   cChar += '</P>'

   aAdd( ::aRows, cChar )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SetFont( oFont )

   IF oFont != NIL
      ::oFont := oFont
   ELSEIF ::oFont == NIL
      DEFINE FONT ::oFont NAME "COURIER" SIZE 0,-12 OF Self
   ENDIF

RETURN ::oFont

//----------------------------------------------------------------------------//

METHOD Line( nTop, nLeft, nBottom, nRight, oPen )

   local cChar
   local nWidth
   local nHeight

   cChar       := '<P CLASS="DEFAULT" style="'
   cChar       += 'position:absolute;'

   cChar       += 'top:' + Ltrim( Str( ::Pix2MmX( nTop ) ) ) + 'mm;'
   cChar       += 'left:' + Ltrim( Str( ::Pix2MmY( nLeft ) ) ) + 'mm;'

   nWidth      := nRight - nLeft
   if nWidth != 0
      nWidth   := ::Pix2MmY( nWidth )
      cChar    += 'width:' + Ltrim( Str( nWidth ) ) + 'mm;'
      cChar    += 'border-top-style:solid;'
   end if

   nHeight     := nBottom - nTop
   if nHeight != 0
      nHeight  := ::Pix2MmY( nHeight )
      cChar    += 'height:' + Ltrim( Str( ::Pix2MmY( nHeight ) ) ) + "mm;"
      cChar    += 'border:solid;'
   end if

   cChar       += 'border-width:1px;'
   cChar       += '">'
   cChar       += '</P>'

   aAdd( ::aRows, cChar )

RETURN NIL

//---------------------------------------------------------------------------//