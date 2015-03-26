#include "Fivewin.ch"
#include "Font.ch"
#include "set.ch"

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

static oPrinter

//----------------------------------------------------------------------------//

CLASS TPrinter

   DATA   oFont
   DATA   hDC, hDCOut
   DATA   aMeta
   DATA   cDir, cDocument, cModel
   DATA   nPage, nXOffset, nYOffset, nPad
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

   METHOD SetPos( nRow, nCol )  INLINE MoveTo( ::hDCOut, nCol, nRow )

   METHOD Line( nTop, nLeft, nBottom, nRight, oPen ) INLINE ;
                      MoveTo( ::hDCOut, nLeft, nTop ),;
                      LineTo( ::hDCOut, nRight, nBottom,;
                              If( oPen != nil, oPen:hPen, 0 ) )

   METHOD Box( nRow, nCol, nBottom, nRight, oPen ) INLINE ;
                      Rectangle( ::hDCOut, nRow, nCol, nBottom, nRight,;
                                 If( oPen != nil, oPen:hPen, 0 ) )

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

   METHOD GetTextHeight( cText, oFont ) INLINE ::SetFont(oFont):nHeight

   METHOD Preview() INLINE If( ::lMeta .AND. len(::aMeta) > 0, RPreview( Self ), ::End() )

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

   METHOD GetModel() INLINE PrnGetName()

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

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cDocument, lUser, lMeta, cModel, lModal ) CLASS TPrinter

   local aOffset
   local cPrinter

   DEFAULT cDocument := "FiveWin Report" ,;
           lUser     := .f.              ,;
           lMeta     := .f.              ,;
           lModal    := .f.

   if lUser
      ::hDC := GetPrintDC( GetActiveWindow() )
   elseif cModel == NIL
      ::hDC  := GetPrintDefault( GetActiveWindow() )
      cModel := ::GetModel()
   else
      cPrinter := GetProfStr( "windows", "device" , "" )
      WriteProfStr( "windows", "device", cModel )
      SysRefresh()
      PrinterInit()
      ::hDC := GetPrintDefault( GetActiveWindow() )
      SysRefresh()
      WriteProfStr( "windows", "device", cPrinter  )
   endif

   if ::hDC != 0
      aOffset    := PrnOffset( ::hDC )
      ::nXOffset := aOffset[1]
      ::nYOffset := aOffset[2]
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
         ::cDir = SubStr( ::cDir, 1, Len( ::cDir ) - 1 )
      endif

      if !empty(::cDir)
         if !lIsDir(::cDir)
            ::cDir := GetWinDir()
         endif
      else
         ::cDir := GetWinDir()
      endif

   endif

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TPrinter

   If ::hDC != 0
      if !::lMeta
         if ::lStarted
            EndDoc(::hDC)
         endif
      else
         Aeval(::aMeta,{|val| ferase(val) })
         ::hDCOut := 0
      endif
      DeleteDC(::hDC)
      ::hDC := 0
   endif

   if ::lModified
     PrinterInit()
   endif

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
         Aeval(::aMeta,{|val| ferase(val) })
         ::hDCOut := 0
      endif
   endif

   DeleteDC(::hDC)

   ::hDC        := GetPrintDefault( GetActiveWindow() )
   ::lStarted   := .F.
   ::lModified  := .T.

   if ::hDC != 0
      if !::lMeta
         ::hDcOut = ::hDC
      else
         ::aMeta  = {}
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _StartPage() CLASS TPrinter

   LOCAL lSetFixed := Set(_SET_FIXED,.F.)

   if !::lMeta .AND. !::lStarted
      ::lStarted := .T.
      StartDoc( ::hDC, ::cDocument )
   endif

   ::nPage++

   if ::lMeta
      AAdd(::aMeta,::cDir+"\tmp"+Padl(::nPage,4,"0")+".wmf")
      ::hDCOut := CreateMetaFile(Atail(::aMeta))
   else
      StartPage(::hDC)
   endif

   Set(_SET_FIXED,lSetFixed )

Return NIL

//----------------------------------------------------------------------------//

METHOD _EndPage() CLASS TPrinter


   if ::lMeta
      if len(::aMeta) == 0
         msgStop("The temporal metafile could not be created",;
                  "Printer object Error")
      else
         ::hDCOut := DeleteMetaFile( CloseMetaFile( ::hDCOut ) )
         if !file(Atail(::aMeta))
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

METHOD Say( nRow, nCol, cText, oFont,;
            nWidth, nClrText, nBkMode, nPad ) CLASS TPrinter

   DEFAULT oFont   := ::oFont ,;
           nBkMode := 1       ,;
           nPad    := ::nPad

   if oFont != nil
      oFont:Activate( ::hDCOut )
   endif

   SetbkMode( ::hDCOut, nBkMode )               // 1,2 transparent or Opaque

   if nClrText != NIL
     SetTextColor( ::hDCOut, nClrText )
   endif

   DO CASE
      CASE nPad == 0
      CASE nPad == PAD_RIGHT
          nCol := Max(0, nCol - ::GetTextWidth( cText, oFont ))
      CASE nPad == PAD_CENTER
          nCol := Max(0, nCol - (::GetTextWidth( cText, oFont )/2))
   ENDCASE

   TextOut( ::hDCOut, nRow, nCol, cText )

   if oFont != nil
      oFont:DeActivate( ::hDCOut )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD SayBitmap( nRow, nCol, xBitmap, nWidth, nHeight, nRaster ) CLASS TPrinter

   local hDib, hPalBmp, hPal

   if ( ValType( xBitmap ) == "N" ) .or. ! File( xBitmap )
      hPalBmp := PalBmpLoad( xBitmap )
      hDib    := DibFromBitmap( nLoWord( hPalBmp ), nHiWord( hPalBmp ) )
      DeleteObject( nLoWord( hPalBmp ) )
      DeleteObject( nHiWord( hPalBmp ) )
   else
      hDib := DibRead( xBitmap )
   endif

   if hDib <= 0
     return nil
   endif

   if ! ::lMeta
     hPal := DibPalette( hDib )
   endif

   DibDraw( ::hDCOut, hDib, hPal, nRow, nCol,;
            nWidth, nHeight, nRaster )

   GlobalFree( hDib )

   if ! ::lMeta
     DeleteObject( hPal )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD _FillRect (aCols, oBrush) CLASS TPrinter

   FillRect(::hDCOut ,aCols, oBrush:hBrush)

return NIL

//----------------------------------------------------------------------------//

METHOD Cmtr2Pix( nRow, nCol ) CLASS TPrinter

   nRow := Max( 0, ( nRow * 10 * ::nVertRes() / ::nVertSize() ) - ::nXoffset )
   nCol := Max( 0, ( nCol * 10 * ::nHorzRes() / ::nHorzSize() ) - ::nYoffset )

return { nRow, nCol }

//----------------------------------------------------------------------------//

METHOD Inch2Pix( nRow, nCol ) CLASS TPrinter

   nRow := Max( 0, ( nRow * ::nVertRes() / (::nVertSize() / 25.4 ))-::nXoffset )
   nCol := Max( 0, ( nCol * ::nHorzRes() / (::nHorzSize() / 25.4 ))-::nYoffset )

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

     DEFAULT lPlaceable := .T.

     IF !file(cFile)
          RETU NIL
     ENDIF

     SaveDC( ::hDCOut )

     IF lPlaceable
          hMeta := GetPMetaFile( cFile )
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

FUNCTION PrintBegin( cDoc, lUser, lPreview, xModel, lModal )

   local oIni, cText, lFound, cDevice

   if xModel == NIL
      return oPrinter := TPrinter():New( cDoc, lUser, lPreview,, lModal )
   endif

   oIni := tTxtFile():New(GetWinDir()+"\WIN.INI")

   if !oIni:Seek("[DEVICES]", 0, 1)
      tone(100,1)
      oIni:End()
      return oPrinter := TPrinter():New( cDoc, .T., lPreview,, lModal )
   endif

   if Valtype(xModel) == "C"

      oIni:Advance()

      xModel := upper(xModel)
      cText  := oIni:ReadLine()
      lFound := .F.

      Do While !empty(cText) .and. !"["$cText
         if xModel$upper(cText)
             lFound := .T.
             Exit
         endif
         oIni:Advance()
         cText := oIni:ReadLine()
      Enddo

   else

      oIni:Advance()
      cText := oIni:ReadLine()

      Do While !empty(cText) .and. !"["$cText
          xModel--
          if xModel == 0
               lFound := .T.
               Exit
          endif
         oIni:Advance()
         cText := oIni:ReadLine()
      Enddo

   endif

   oIni:End()

   if !lFound
      tone(100,1)
      return oPrinter := TPrinter():New( cDoc, .T., lPreview,, lModal )
   endif

   cDevice := StrToken( cText, 1, "=" )
   cText   := StrToken( cText, 2, "=" )
   cDevice += "," + StrToken( cText, 1, "," )
   cDevice += "," + StrToken( cText, 2, "," )

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