#include "FiveWin.Ch"
#include "struct.ch"

#define TA_LEFT               0
#define TA_RIGHT              2
#define TA_CENTER             6

#define ETO_OPAQUE            2
#define ETO_CLIPPED           4

#define HORZSIZE            4
#define VERTSIZE            6
#define HORZRES             8
#define VERTRES            10
#define LOGPIXELSX         88
#define LOGPIXELSY         90

#define MM_TEXT             1
#define MM_LOMETRIC         2
#define MM_HIMETRIC         3
#define MM_LOENGLISH        4
#define MM_HIENGLISH        5
#define MM_TWIPS            6
#define MM_ISOTROPIC        7
#define MM_ANISOTROPIC      8

#define PAD_LEFT            0
#define PAD_RIGHT           1
#define PAD_CENTER          2

// Defines for the oPrn:SetPage(nPage) method (The printer MUST support it)

#define DMPAPER_LETTER      1           // Letter 8 1/2 x 11 in
#define DMPAPER_LETTERSMALL 2           // Letter Small 8 1/2 x 11 in
#define DMPAPER_TABLOID     3           // Tabloid 11 x 17 in
#define DMPAPER_LEDGER      4           // Ledger 17 x 11 in
#define DMPAPER_LEGAL       5           // Legal 8 1/2 x 14 in
#define DMPAPER_STATEMENT   6           // Statement 5 1/2 x 8 1/2 in
#define DMPAPER_EXECUTIVE   7           // Executive 7 1/4 x 10 1/2 in
#define DMPAPER_A3          8           // A3 297 x 420 mm
#define DMPAPER_A4          9           // A4 210 x 297 mm
#define DMPAPER_A4SMALL     10          // A4 Small 210 x 297 mm
#define DMPAPER_A5          11          // A5 148 x 210 mm
#define DMPAPER_B4          12          // B4 250 x 354
#define DMPAPER_B5          13          // B5 182 x 257 mm
#define DMPAPER_FOLIO       14          // Folio 8 1/2 x 13 in
#define DMPAPER_QUARTO      15          // Quarto 215 x 275 mm
#define DMPAPER_10X14       16          // 10x14 in
#define DMPAPER_11X17       17          // 11x17 in
#define DMPAPER_NOTE        18          // Note 8 1/2 x 11 in
#define DMPAPER_ENV_9       19          // Envelope #9 3 7/8 x 8 7/8
#define DMPAPER_ENV_10      20          // Envelope #10 4 1/8 x 9 1/2
#define DMPAPER_ENV_11      21          // Envelope #11 4 1/2 x 10 3/8
#define DMPAPER_ENV_12      22          // Envelope #12 4 \276 x 11
#define DMPAPER_ENV_14      23          // Envelope #14 5 x 11 1/2
#define DMPAPER_CSHEET      24          // C size sheet
#define DMPAPER_DSHEET      25          // D size sheet
#define DMPAPER_ESHEET      26          // E size sheet
#define DMPAPER_ENV_DL      27          // Envelope DL 110 x 220mm
#define DMPAPER_ENV_C5      28          // Envelope C5 162 x 229 mm
#define DMPAPER_ENV_C3      29          // Envelope C3  324 x 458 mm
#define DMPAPER_ENV_C4      30          // Envelope C4  229 x 324 mm
#define DMPAPER_ENV_C6      31          // Envelope C6  114 x 162 mm
#define DMPAPER_ENV_C65     32          // Envelope C65 114 x 229 mm
#define DMPAPER_ENV_B4      33          // Envelope B4  250 x 353 mm
#define DMPAPER_ENV_B5      34          // Envelope B5  176 x 250 mm
#define DMPAPER_ENV_B6      35          // Envelope B6  176 x 125 mm
#define DMPAPER_ENV_ITALY   36          // Envelope 110 x 230 mm
#define DMPAPER_ENV_MONARCH 37          // Envelope Monarch 3.875 x 7.5 in
#define DMPAPER_ENV_PERSONAL 38         // 6 3/4 Envelope 3 5/8 x 6 1/2 in
#define DMPAPER_FANFOLD_US  39          // US Std Fanfold 14 7/8 x 11 in
#define DMPAPER_FANFOLD_STD_GERMAN  40  // German Std Fanfold 8 1/2 x 12 in
#define DMPAPER_FANFOLD_LGL_GERMAN  41  // German Legal Fanfold 8 1/2 x 13 in

// Defines for the oPrn:SetBin(nBin) method (The printer MUST support it)

#define DMBIN_FIRST         DMBIN_UPPER
#define DMBIN_UPPER         1
#define DMBIN_ONLYONE       1
#define DMBIN_LOWER         2
#define DMBIN_MIDDLE        3
#define DMBIN_MANUAL        4
#define DMBIN_ENVELOPE      5
#define DMBIN_ENVMANUAL     6
#define DMBIN_AUTO          7
#define DMBIN_TRACTOR       8
#define DMBIN_SMALLFMT      9
#define DMBIN_LARGEFMT      10
#define DMBIN_LARGECAPACITY 11
#define DMBIN_CASSETTE      14
#define DMBIN_LAST          DMBIN_CASSETTE

#define DMORIENT_PORTRAIT   1
#define DMORIENT_LANDSCAPE  2

static oPrinter

//----------------------------------------------------------------------------//

CLASS TPrinter

   DATA   oFont
   DATA   hDC, hDCOut
   DATA   aMeta
   DATA   cDir, cDocument, cModel, cOldModel
   DATA   nPage, nXOffset, nYOffset, nPad, nOrient
   DATA   lMeta, lStarted, lModified, lPrvModal

   METHOD New( cDocument, lUser, lMeta, cModel, lModal ) CONSTRUCTOR

   MESSAGE StartPage() METHOD _StartPage()
   MESSAGE EndPage() METHOD _EndPage()

   METHOD End()

   METHOD Say( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad )

   METHOD CmSay( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad );
           INLINE ;
           (::Cmtr2Pix(@nRow, @nCol),;
            ::Say( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad ))

   METHOD InchSay( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad );
           INLINE ;
           (::Inch2Pix(@nRow, @nCol),;
            ::Say( nRow, nCol, cText, oFont, nWidth, nClrText, nBkMode, nPad ))

   METHOD SayBitmap( nRow, nCol, cBitmap, nWidth, nHeight, nRaster )

   METHOD SayImage( nRow, nCol, oImage, nWidth, nHeight, nRaster )

   METHOD SetPos( nRow, nCol )  INLINE MoveTo( ::hDCOut, nCol, nRow )

   METHOD Line( nTop, nLeft, nBottom, nRight, oPen ) INLINE ;
                      MoveTo( ::hDCOut, nLeft, nTop ),;
                      LineTo( ::hDCOut, nRight, nBottom,;
                              If( oPen != nil, oPen:hPen, 0 ) )

   METHOD Box( nRow, nCol, nBottom, nRight, oPen ) INLINE ;
                      Rectangle( ::hDCOut, nRow, nCol, nBottom, nRight,;
                                 If( oPen != nil, oPen:hPen, 0 ) )

   METHOD RoundBox( nRow, nCol, nBottom, nRight, nWidth, nHeight, oPen, nBGColor )

   METHOD Arc( nTop, nLeft, nBottom, nRight, nXB, nYB, nXE, nYE, oPen ) INLINE ;
            Arc( ::hDCOut, nLeft, nTop, nRight, nBottom, nXB, nYB, nXE, nYE, ;
                 If( oPen != nil, oPen:hPen, 0 ) )

   METHOD Chord( nTop, nLeft, nBottom, nRight, nXB, nYB, nXE, nYE, oPen ) INLINE ;
            Chord( ::hDCOut, nLeft, nTop, nRight, nBottom, nXB, nYB, nXE, nYE, ;
                   If( oPen != nil, oPen:hPen, 0 ) )

   METHOD Ellipse( nRow, nCol, nBottom, nRight, oPen ) INLINE ;
            Ellipse( ::hDCOut, nCol, nRow, nRight, nBottom, ;
                     If( oPen != nil, oPen:hPen, 0 ) )

   METHOD Pie( nTop, nLeft, nBottom, nRight, nxStartArc, nyStartArc, nxEndArc, nyEndArc, oPen ) INLINE ;
            Pie( ::hDCOut, nTop, nLeft, nBottom, nRight, nxStartArc, nyStartArc, nxEndArc, nyEndArc, ;
                 If( oPen != nil, oPen:hPen, 0 ) )

   METHOD GetPixel( nRow, nCol, nRGBColor ) INLINE ;
            SetPixel( ::hDCOut, nCol, nRow, nRGBColor )

   METHOD SetPixel( nRow, nCol ) INLINE ;
            SetPixel( ::hDCOut, nCol, nRow )

   METHOD Cmtr2Pix( nRow, nCol )

   METHOD DraftMode( lOnOff ) INLINE (DraftMode( lOnOff ),;
                                      ::Rebuild()         )

   METHOD Inch2Pix( nRow, nCol )

   METHOD Pix2Mmtr(nRow, nCol) INLINE ;
                               ( nRow := nRow * 25.4 / ::nLogPixelX() ,;
                                 nCol := nCol * 25.4 / ::nLogPixelY() ,;
                                 {nRow, nCol}                          )

   METHOD Pix2Inch(nRow, nCol) INLINE ;
                               ( nRow := nRow / ::nLogPixelX() ,;
                                 nCol := nCol / ::nLogPixelY() ,;
                                 {nRow, nCol}                   )

   METHOD CmRect2Pix(aRect)

   METHOD nVertRes()  INLINE  GetDeviceCaps( ::hDC, VERTRES  )
   METHOD nHorzRes()  INLINE  GetDeviceCaps( ::hDC, HORZRES  )

   METHOD nVertSize() INLINE  GetDeviceCaps( ::hDC, VERTSIZE )
   METHOD nHorzSize() INLINE  GetDeviceCaps( ::hDC, HORZSIZE )

   METHOD nLogPixelX() INLINE GetDeviceCaps( ::hDC, LOGPIXELSX )
   METHOD nLogPixelY() INLINE GetDeviceCaps( ::hDC, LOGPIXELSY )

   METHOD SetPixelMode()  INLINE SetMapMode( ::hDC, MM_TEXT )
   METHOD SetTwipsMode()  INLINE SetMapMode( ::hDC, MM_TWIPS )

   METHOD SetLoInchMode() INLINE SetMapMode( ::hDC, MM_LOENGLISH )
   METHOD SetHiInchMode() INLINE SetMapMode( ::hDC, MM_HIENGLISH )

   METHOD SetLoMetricMode() INLINE SetMapMode( ::hDC, MM_LOMETRIC )
   METHOD SetHiMetricMode() INLINE SetMapMode( ::hDC, MM_HIMETRIC )

   METHOD SetIsotropicMode()   INLINE SetMapMode( ::hDC, MM_ISOTROPIC )
   METHOD SetAnisotropicMode() INLINE SetMapMode( ::hDC, MM_ANISOTROPIC )

   METHOD SetWindowExt( nUnitsWidth, nUnitsHeight ) INLINE ;
                        SetWindowExt( ::hDC, nUnitsWidth, nUnitsHeight )

   METHOD SetViewPortExt( nWidth, nHeight ) INLINE ;
                          SetViewPortExt( ::hDC, nWidth, nHeight )

   METHOD GetTextWidth( cText, oFont ) INLINE ;
                        GetTextWidth( ::hDC, cText, ::SetFont(oFont):hFont)

   METHOD GetTextHeight( cText, oFont ) INLINE Abs( ::SetFont(oFont):nHeight )

   METHOD Preview() INLINE If( ::lMeta .and. Len( ::aMeta ) > 0 .and. ::hDC != 0,;
                               RPreview( Self ), ::End() )

   MESSAGE FillRect( aRect, oBrush )  METHOD _FillRect( aRect, oBrush )

   METHOD ResetDC() INLINE ResetDC( ::hDC )

   METHOD GetOrientation() INLINE  PrnGetOrientation()

   METHOD SetLandscape() INLINE ( PrnLandscape( ::hDC ),;
                                  ::Rebuild() )

   METHOD SetPortrait()  INLINE ( PrnPortrait( ::hDC ),;
                                  ::Rebuild() )

   METHOD SetCopies( nCopies ) INLINE ;
                               ( PrnSetCopies( nCopies ),;
                                 ::Rebuild()                    )

   METHOD SetSize( nWidth, nHeight ) INLINE ;
                               ( PrnSetSize( nWidth, nHeight ),;
                                 ::Rebuild()                   )

   METHOD SetPage( nPage ) INLINE ;
                           ( PrnSetPage( nPage ),;
                             ::Rebuild()         )

   METHOD SetBin( nBin ) INLINE ;
                           ( PrnBinSource( nBin ),;
                             ::Rebuild()          )

   METHOD GetModel()  INLINE PrnGetName()
   METHOD GetDriver() INLINE PrnGetDrive()
   METHOD GetPort()   INLINE PrnGetPort()

   METHOD GetPhySize()

   METHOD Setup() INLINE ( PrinterSetup(),;
                           ::Rebuild()    )

   METHOD Rebuild()

   METHOD SetFont( oFont )
   METHOD CharSay( nRow, nCol, cText )
   METHOD CharWidth()
   METHOD CharHeight()

   METHOD ImportWMF( cFile )
   METHOD ImportRAW( cFile )

   METHOD SizeInch2Pix( nHeight, nWidth )

   Method GetValidPrinter( cModel )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDocument, lUser, lMeta, cModel, lModal ) CLASS TPrinter

   local aOffset
   local cPrinter


   DEFAULT cDocument := "FiveWin Report" ,;
           lUser     := .f.              ,;
           lMeta     := .f.              ,;
           lModal    := .t.

   if lUser

      ::hDC       := GetPrintDC( GetActiveWindow() )
      if ::hDC != 0
         cModel   := ::GetModel()+","+::GetDriver()+","+::GetPort()
      endif

   elseif cModel == nil

      ::hDC       := GetPrintDefault( GetActiveWindow() )
      if ::hDC != 0
         cModel   := ::GetModel()+","+::GetDriver()+","+::GetPort()
      endif

   else

      ::cOldModel := ::GetModel()+","+::GetDriver()+","+::GetPort()
      cModel      := ::GetValidPrinter( cModel )
      cPrinter    := GetProfString( "windows", "device" , "" )
      WriteProfString( "windows", "device", cModel )
      PrinterInit()
      ::hDC       := GetPrintDefault( GetActiveWindow() )
      SysRefresh()
      WriteProfString( "windows", "device", cPrinter  )

   endif

   if ::hDC != 0
      aOffset    := PrnOffset( ::hDC )
      ::nXOffset := aOffset[1]
      ::nYOffset := aOffset[2]
      ::nOrient  := ::GetOrientation()
   elseif ComDlgXErr() != 0
      MsgStop( "¡No hay impresoras instaladas o la impresora especifica no existe!"  + CRLF + ;
               "Por favor revise la instalación de sus impresoras." )
      ::nXOffset := 0
      ::nYOffset := 0
   else
      ::nXOffset := 0
      ::nYOffset := 0
      ::nOrient  := DMORIENT_PORTRAIT
   endif

   ::cDocument  := cDocument
   ::cModel     := cModel
   ::nPage      := 0
   ::nPad       := 0
   ::lMeta      := lMeta
   ::lStarted   := .F.
   ::lModified  := .F.
   ::lPrvModal  := lModal

   if !lMeta
      ::hDcOut := ::hDC
   else
      ::aMeta  := {}
      ::cDir   := GetEnv("TEMP")

      if empty(::cDir)
         ::cDir := GetEnv("TMP")
      endif

      if Right( ::cDir, 1 ) == "\"
         ::cDir := SubStr( ::cDir, 1, Len( ::cDir ) - 1 )
      endif

      if !Empty( ::cDir )
         if !lIsDir( ::cDir )
            ::cDir := GetWinDir()
         endif
      else
         ::cDir := GetWinDir()
      endif

   endif

return Self

//----------------------------------------------------------------------------//

METHOD End() CLASS TPrinter

   If ::hDC != 0
      if !::lMeta
         if ::lStarted
            EndDoc(::hDC)
         endif
      else
         Aeval(::aMeta,{|val| fErase(val) })
         ::aMeta  := {}
         ::hDCOut := 0
      endif
      if ::nOrient != NIL
         if ::nOrient == DMORIENT_PORTRAIT
            ::SetPortrait()
         else
            ::SetLandscape()
         endif
      endif
      DeleteDC( ::hDC )
      ::hDC := 0
   endif

   if !Empty( ::cOldModel )
      WriteProfString( "windows", "device", ::cOldModel )
      PrinterInit()
   end if

   if ::oFont != NIL
     ::oFont:End()
   endif

   oPrinter := NIL

Return NIL

//----------------------------------------------------------------------------//

METHOD Rebuild() CLASS TPrinter

   if ::lStarted
      if !::lMeta
         EndDoc(::hDC)
      else
         ::hDCOut := 0
      endif
   endif

   if ::hDC != 0
      DeleteDC( ::hDC )
      ::hDC := GetPrintDefault( GetActiveWindow() )
      ::lStarted   := .F.
      ::lModified  := .T.
   endif

   if ::hDC != 0
      if !::lMeta
         ::hDcOut = ::hDC
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _StartPage() CLASS TPrinter

   local lSetFixed

   if ::hDC == 0
      return nil
   endif

   lSetFixed := Set( _SET_FIXED, .F. )

   if !::lMeta .and. ! ::lStarted
      ::lStarted := .T.
      StartDoc( ::hDC, ::cDocument )
   endif

   ::nPage++

   if ::lMeta
      #ifndef __CLIPPER__
         AAdd( ::aMeta, ::cDir + "\tmp" + PadL( ::nPage, 4, "0" ) + ".emf" )
         ::hDCOut := CreateEnhMetaFile( ::hDc,ATail( ::aMeta ), ::cDocument )  //jlcr
      #else
         AAdd( ::aMeta, ::cDir + "\tmp" + PadL( ::nPage, 4, "0" ) + ".wmf" )
         ::hDCOut := CreateMetaFile( ATail( ::aMeta ) )
      #endif
   else
      StartPage( ::hDC )
   endif

   Set( _SET_FIXED, lSetFixed )

return nil

//----------------------------------------------------------------------------//

METHOD _EndPage() CLASS TPrinter

   If ::hDC = 0
      Return NIL
   endif

   if ::lMeta
      if Len( ::aMeta ) == 0
         msgStop( "The temporal metafile could not be created",;
                   "Printer object Error" )
      else
         #ifndef __CLIPPER__
            ::hDCOut := DeleteEnhMetaFile( CloseEnhMetaFile( ::hDCOut ) )
         #else
	          ::hDCOut := DeleteMetaFile( CloseMetaFile( ::hDCOut ) )
         #endif

         if ! File( Atail( ::aMeta ) )
            msgStop("Could not create temporary file: "+Atail(::aMeta)+CRLF+CRLF+;
                     "Please check your free space on your hard drive "+CRLF+;
                     "and the amount of files handles available." ,;
                     "Print preview error" )
         endif
      endif
   else
      EndPage( ::hDC )
   endif

Return NIL

//----------------------------------------------------------------------------//

METHOD RoundBox( nRow, nCol, nBottom, nRight, nWidth, nHeight, oPen, nBGColor ) ;
   CLASS TPrinter

   local hBrush, hOldBrush
   local hPen, hOldPen

   hPen = If( oPen == Nil, CreatePen( PS_SOLID, 1, CLR_BLACK ), oPen:hPen )
   hOldPen = SelectObject( ::hDCOut, hPen )

   if nBGColor != nil
      hBrush    := CreateSolidBrush( nBGColor )
      hOldBrush := SelectObject( ::hDCOut, hBrush )
   endif

   RoundRect( ::hDCOut, nRow, nCol, nBottom, nRight, nWidth, nHeight )

   if nBGColor # Nil
      SelectObject( ::hDCOut, hOldBrush )
      DeleteObject( hBrush )
   endif

   SelectObject( ::hDCOut, hOldPen )

   If( oPen == Nil, DeleteObject( hPen ), Nil )

return nil

//----------------------------------------------------------------------------//

METHOD Say( nRow, nCol, cText, oFont,;
            nWidth, nClrText, nBkMode, nPad ) CLASS TPrinter

   LOCAL nTemp

   If ::hDC = 0
      Return NIL
   endif

   DEFAULT oFont   := ::oFont ,;
           nBkMode := 1       ,;
           nPad    := ::nPad  ,;
           nWidth  := ::GetTextWidth( cText, oFont )

   if oFont != nil
      oFont:Activate( ::hDCOut )
   endif

   SetbkMode( ::hDCOut, nBkMode )               // 1,2 transparent or Opaque

   if nClrText != NIL
      SetTextColor( ::hDCOut, nClrText )
   endif

   Do Case
      Case nPad == PAD_RIGHT
         nTemp := nCol + nWidth
         SetTextAlign( ::hDCOut, TA_RIGHT )
      Case nPad == PAD_CENTER
         nTemp := nCol + (nWidth/2)
         SetTextAlign( ::hDCOut, TA_CENTER )
      otherwise
         nTemp := nCol
         SetTextAlign( ::hDCOut, TA_LEFT )
   Endcase

   ExtTextOut( ::hDCOut, nRow, nTemp, {nRow, nCol, nRow+oFont:nHeight, nCol+nWidth}, cText, ETO_CLIPPED )

   if oFont != nil
      oFont:DeActivate( ::hDCOut )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SayBitmap( nRow, nCol, xBitmap, nWidth, nHeight, nRaster ) CLASS TPrinter

   local hDib, aBmpPal, hBitmap, hPalette

   if ::hDC = 0
      return nil
   endif

   if ( ValType( xBitmap ) == "N" ) .or. ! File( xBitmap )
      aBmpPal  = PalBmpLoad( xBitmap )
      hBitmap  = aBmpPal[ 1 ]
      hPalette = aBmpPal[ 2 ]
      hDib     = DibFromBitmap( hBitmap, hPalette )
      PalBmpFree( hBitmap, hPalette )
   else
      hDib = DibRead( xBitmap )
   endif

   if hDib == 0
      return nil
   endif

   if ! ::lMeta
      hPalette = DibPalette( hDib )
   endif

   DibDraw( ::hDCOut, hDib, hPalette, nRow, nCol,;
            nWidth, nHeight, nRaster )

   GlobalFree( hDib )

   if ! ::lMeta
      DeleteObject( hPalette )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SayImage( nRow, nCol, oImage, nWidth, nHeight, nRaster ) CLASS TPrinter

   local hDib, hPal, nRatio, n

   DEFAULT nWidth := 0, nHeight := 0

   if ::hDC = 0
      return nil
   endif

   do case
      case ValType( oImage ) == "O"
           hDib = DibFromBitmap( oImage:hBitmap, oImage:hPalette )
      otherwise
           hDib = 0
   endcase

   if hDib = 0
      return nil
   endif

   if ! ::lMeta
      hPal := DibPalette( hDib )
   endif

   // try to keep aspect ratio if only one size is passed in.
   iF nWidth == 0 .and. nHeight > 0 .and. ( n := oImage:nHeight() ) > 0
      nRatio := oImage:nWidth() / n
      nWidth := int( nHeight * nRatio )
   elseif nWidth > 0 .and. nHeight == 0 .and. ( n := oImage:nWidth() ) > 0
      nRatio  := oImage:nHeight() / n
      nHeight := int( nWidth * nRatio )
   endif

   DibDraw( ::hDCOut, hDib, hPal, nRow, nCol, nWidth, nHeight, nRaster )

   GlobalFree( hDib )

   if ! ::lMeta
      DeleteObject( hPal )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _FillRect (aCols, oBrush) CLASS TPrinter

   If ::hDC = 0
      Return NIL
   endif

   FillRect(::hDCOut ,aCols, oBrush:hBrush)

return NIL

//----------------------------------------------------------------------------//

METHOD Cmtr2Pix( nRow, nCol ) CLASS TPrinter

   nRow := Max( 0, ( nRow * 10 * ::nVertRes() / ::nVertSize() ) - ::nYoffset )
   nCol := Max( 0, ( nCol * 10 * ::nHorzRes() / ::nHorzSize() ) - ::nXoffset )

return { nRow, nCol }

//----------------------------------------------------------------------------//

METHOD CmRect2Pix(aRect)  CLASS TPrinter

   LOCAL aTmp[4]

   aTmp[1] := Max( 0, ( aRect[1] * 10 * ::nVertRes() / ::nVertSize() ) - ::nYoffset )
   aTmp[2] := Max( 0, ( aRect[2] * 10 * ::nHorzRes() / ::nHorzSize() ) - ::nXoffset )
   aTmp[3] := Max( 0, ( aRect[3] * 10 * ::nVertRes() / ::nVertSize() ) - ::nYoffset )
   aTmp[4] := Max( 0, ( aRect[4] * 10 * ::nHorzRes() / ::nHorzSize() ) - ::nXoffset )

RETURN aTmp

//----------------------------------------------------------------------------//

METHOD Inch2Pix( nRow, nCol ) CLASS TPrinter

   nRow := Max( 0, ( nRow * ::nVertRes() / (::nVertSize() / 25.4 ))-::nYoffset )
   nCol := Max( 0, ( nCol * ::nHorzRes() / (::nHorzSize() / 25.4 ))-::nXoffset )

return { nRow, nCol }

//----------------------------------------------------------------------------//

METHOD GetPhySize() CLASS TPrinter

   local aData := PrnGetSize( ::hDC )
   local nWidth, nHeight

   nWidth  := aData[ 1 ] / ::nLogPixelX() * 25.4
   nHeight := aData[ 2 ] / ::nLogPixelY() * 25.4

return { nWidth, nHeight }

//----------------------------------------------------------------------------//

METHOD SetFont( oFont ) CLASS TPrinter

   IF oFont != NIL
      ::oFont := oFont
   ELSEIF ::oFont == NIL
      DEFINE FONT ::oFont NAME "COURIER" SIZE 0,-12 OF Self
   ENDIF

RETURN ::oFont

//----------------------------------------------------------------------------//

METHOD CharSay( nRow, nCol, cText ) CLASS TPrinter

   LOCAL nPxRow, nPxCol

   ::SetFont()

   nRow   := Max(--nRow, 0)
   nCol   := Max(--nCol, 0)
   nPxRow := nRow * ::GetTextHeight( "", ::oFont )
   nPxCol := nCol * ::GetTextWidth( "B", ::oFont )

   ::Say( nPxRow, nPxCol, cText, ::oFont )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD CharWidth() CLASS TPrinter

   ::SetFont()

RETURN Int( ::nHorzRes() / ::GetTextWidth( "B", ::oFont ))

//----------------------------------------------------------------------------//

METHOD CharHeight() CLASS TPrinter

   ::SetFont()

RETURN Int( ::nVertRes() / ::GetTextHeight( "",::oFont ))

//----------------------------------------------------------------------------//

METHOD ImportWMF( cFile, lPlaceable ) CLASS TPrinter

     LOCAL hMeta
     LOCAL aData := PrnGetSize( ::hDC )
     LOCAL aInfo := Array(5)

     DEFAULT lPlaceable := .T.

     IF !file(cFile)
          RETU NIL
     ENDIF

     SaveDC( ::hDCOut )

     IF lPlaceable
          hMeta := GetPMetaFile( cFile, aInfo )
     ELSE
          hMeta := GetMetaFile( cFile )
     ENDIF

     ::SetIsoTropicMode()
     ::SetWindowExt( aData[1], aData[2] )
     ::SetViewPortExt( aData[1], aData[2] )

     IF !::lMeta
          SetViewOrg( ::hDCOut, -::nXoffset, -::nYoffset )
     ENDIF

     SetBkMode(::hDCOut, 1)

     PlayMetaFile( ::hDCOut, hMeta )

     DeleteMetafile(hMeta)

     RestoreDC( ::hDCOut )

RETURN NIL

//----------------------------------------------------------------------------//

METHOD ImportRAW(cFile) CLASS TPrinter

     IF !file(cFile)
          RETU NIL
     ENDIF

     ImportRawFile(::HDCOut, cFile)

RETURN NIL

//----------------------------------------------------------------------------//

METHOD SizeInch2Pix( nHeight, nWidth ) CLASS TPrinter

   // Inch2Pix() is for coordinates and is affected by page offsets
   // SizeInch2Pix is for converting width and height

   DEFAULT nWidth := 0, nHeight := 0

   if nHeight <> 0
      nHeight := Max( 0, ( nHeight * ::nVertRes() / ( ::nVertSize() / 25.4 ) ) )
   endif

   if nWidth <> 0
      nWidth := Max( 0, ( nWidth * ::nHorzRes() / ( ::nHorzSize() / 25.4 ) ) )
   endif

return { nWidth, nHeight }

//----------------------------------------------------------------------------//

FUNCTION PrintBegin( cDoc, lUser, lPreview, xModel, lModal )

   local aPrn
   local cText, cDevice
   local nScan

   if xModel == NIL
      return oPrinter := TPrinter():New( cDoc, lUser, lPreview,, lModal )
   endif

   cText := StrTran(GetProfString("Devices"),Chr(0), chr(13)+chr(10))
   aPrn  := Array(Mlcount(cText, 250))

   Aeval(aPrn, {|v,e| aPrn[e] := Trim(Memoline(cText, 250, e)) } )

   if Valtype(xModel) == "N"
      if xModel < 0 .or. xModel > len(aPrn)
         nScan := 0
      else
         nScan := xModel
      endif
   else
      nScan := Ascan(aPrn, {|v| Upper(xModel)$Upper(v) })
   endif

   if nScan == 0
      MsgBeep()
      return oPrinter := TPrinter():New( cDoc, .T., lPreview,, lModal )
   endif

   cText   := GetProfString("Devices", aPrn[ nScan ] )
   cDevice := aPrn[nScan]+","+cText

RETURN oPrinter := TPrinter():New( cDoc, .f., lPreview, cDevice, lModal )

//----------------------------------------------------------------------------//

FUNCTION PageBegin() ; oPrinter:StartPage() ; RETURN nil

//----------------------------------------------------------------------------//

FUNCTION PageEnd() ; oPrinter:EndPage(); RETURN nil

//----------------------------------------------------------------------------//

FUNCTION PrintEnd()

     IF oPrinter:lMeta
          oPrinter:Preview()
     ELSE
          oPrinter:End()
     ENDIF

     oPrinter := nil

RETURN nil

//----------------------------------------------------------------------------//

Method GetValidPrinter( cModel )

   local nPos
   local aPrinters   := GetPrinters()

   if ( nPos := At( ",", cModel ) ) != 0
      cModel         := SubStr( cModel, 1, nPos - 1 )
   end if

   if aScan( aPrinters, {| cPrinter | Rtrim( Upper( cPrinter ) ) == Rtrim( Upper( cModel ) ) } ) == 0
      cModel         := ::GetModel() + "," + ::GetDriver() + "," + ::GetPort()
   end if

RETURN cModel

//----------------------------------------------------------------------------//

function aGetPrinters() // returns an array with all the available printers

   local aPrinters
   local cText
   local cToken      := Chr( 15 )

   cText             := StrTran( StrTran( StrTran( GetProfString( "Devices", 0 ), Chr( 0 ), cToken ), Chr( 13 ) ), Chr( 10 ) )
   aPrinters         := Array( Len( cText ) - Len( StrTran( cText, cToken ) ) )
   AEval( aPrinters, { |cPrn, nEle | aPrinters[ nEle ] := StrToken( cText, nEle, cToken ) } )

return aPrinters

//----------------------------------------------------------------------------//

function SetPrintDefault( cModel )

   local cDriver := StrToken( GetProfString( "Devices", cModel, "" ), 1, "," )
   local cPort   := StrToken( GetProfString( "Devices", cModel, "" ), 2, "," )

   WriteProfString( "Windows", "Device", cModel + ",", + cDriver + "," + cPort )

return nil

//----------------------------------------------------------------------------//