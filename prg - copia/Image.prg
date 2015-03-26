#include "FiveWin.ch"
#include "Constant.ch"
#include "Inkey.ch"

#define GW_CHILD      5
#define GW_HWNDNEXT   2
#define RT_BITMAP     2

#ifdef __XPP__
   #define New        _New
   #define Super      ::TBitmap
#endif

static hLib

//----------------------------------------------------------------------------//

CLASS TImage FROM TBitmap

   DATA nProgress
   DATA nFormat

   CLASSDATA cResFile                AS CHARACTER INIT "freeimage.dll"
   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
               oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
               cMsg, lUpdate, bWhen, lPixel, bValid, lDesign ) CONSTRUCTOR

   METHOD Define( cResName, cBmpFile, oWnd ) CONSTRUCTOR

   METHOD LoadImage( cResName, cBmpFile )
   METHOD SaveImage( cFile, nFormat, nQuality )

   METHOD Progress( lProgress )

   METHOD LoadFromMemory( cBuffer, nWidth, nHeight )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder,;
            oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,;
            cMsg, lUpdate, bWhen, lPixel, bValid, lDesign ) CLASS TImage

   #ifdef __XPP__
      ::lRegistered = .f.
   #endif

   ::nProgress = 1

   Super:New( nTop, nLeft, nWidth, nHeight, cResName, cBmpFile, lNoBorder, ;
              oWnd, bLClicked, bRClicked, lScroll, lStretch, oCursor,      ;
              cMsg, lUpdate, bWhen, lPixel, bValid, lDesign )
return Self

//----------------------------------------------------------------------------//
// This method does not create a control, it just creates a bitmap object to
// be used somewhere else.
METHOD Define( cResName, cBmpFile, oWnd ) CLASS TImage

   local aBmpPal

   DEFAULT oWnd := GetWndDefault()

   ::oWnd     = oWnd
   ::nZoom    = 1
   ::hWnd     = 0
   ::hBitmap  = 0
   ::hPalette = 0

   ::hAlphaLevel = 255

   if ! Empty( cResName )
      aBmpPal    = PalBmpLoad( cResName )
      ::hBitmap  = aBmpPal[ 1 ]
      ::hPalette = aBmpPal[ 2 ]
      cBmpFile  = nil
   endif

   if ! Empty( cBmpFile ) .and. File( cBmpFile )
      ::cBmpFile = cBmpFile
      ::hBitmap = FILoadImg( AllTrim( cBmpFile ), , ::cResFile )
   endif

   if ::hBitmap != 0
      PalBmpNew( 0, ::hBitmap, ::hPalette )
   endif

   ::HasAlpha()

return Self

//----------------------------------------------------------------------------//

METHOD LoadImage( cResName, cBmpFile, cResFile ) CLASS TImage

   local lChanged := .f.
   local hOldBmp  := ::hBitmap
   local hOldPal  := ::hPalette
   local aBmpPal

   DEFAULT cResName := ::cResName, cBmpFile := ::cBmpFile
   DEFAULT cResFile := ::cResFile

   if ! Empty( cResName )
      aBmpPal    = PalBmpLoad( cResName )
      ::hBitmap  = aBmpPal[ 1 ]
      ::hPalette = aBmpPal[ 2 ]
      lChanged   = .t.
      cBmpFile   = nil
   elseif File( cBmpFile )
      ::hBitmap = FILoadImg( AllTrim( cBmpFile ), , cResFile )
      lChanged  := .t.
      cResName  := nil
   endif

   if lChanged

      ::cResName = cResName
      ::cBmpFile = cBmpFile

      if ! Empty( hOldBmp )
         PalBmpFree( hOldBmp, hOldPal )
      endif

      PalBmpNew( ::hWnd, ::hBitmap, ::hPalette )

   endif

   ::HasAlpha()

return lChanged

//----------------------------------------------------------------------------//

METHOD SaveImage( cFile, nFormat, nQuality ) CLASS TImage

   //   0 -> Bmp
   //   2 -> Jpg
   //  13 -> Png

   local hDib := DibFromBitmap( ::hBitmap )
   local cTempFile := cTempFile()
   local lSaved

   DibWrite( cTempFile, hDib )
   GloBalFree( hDib )
   lSaved = FIConvertImageFile( cTempFile, cFile, nFormat, nQuality )
   FErase( cTempFile )
return lSaved

//----------------------------------------------------------------------------//

METHOD Progress( lProgress ) CLASS TImage

   if ValType( lProgress ) == "L"
      if lProgress
         ::nProgress = 1
      else
         ::nProgress = 0
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD LoadFromMemory( cBuffer, nWidth, nHeight ) CLASS TImage

   local hOldBmp := ::hBitmap
   local hOldPal := ::hPalette
   local nFormat
   local hResizedBitmap

   if ! Empty( hOldBmp )
      PalBmpFree( hOldBmp, hOldPal )
   endif

   ::hBitmap = FILoadFromMemory( cBuffer, @nFormat )

   IF valtype( nWidth ) == "N" .and. valtype( nHeight ) == "N"
      IF nBmpWidth( ::hBitmap )>nWidth .OR. nBmpHeight( ::hBitmap )>nHeight
         hResizedBitmap := ResizeBmp( ::hBitmap, nWidth, nHeight )
         ::hBitmap      := hResizedBitmap
      endif
   elseif valtype( nWidth ) == "N"
      IF nBmpWidth( ::hBitmap ) > nWidth
         hResizedBitmap := ResizeBmp( ::hBitmap, nWidth, nBmpHeight( ::hBitmap ) / ( nBmpWidth( ::hBitmap ) /nWidth ) )
         ::hBitmap      := hResizedBitmap
      endif
   elseif valtype( nHeight )=="N"
      if nBmpHeight( ::hBitmap ) > nHeight
         hResizedBitmap := ResizeBmp( ::hBitmap, nBmpWidth( ::hBitmap ) / (nBmpHeight( ::hBitmap ) / nHeight ), nHeight )
         ::hBitmap      := hResizedBitmap
      endif
   endif

   PalBmpNew( ::hWnd, ::hBitmap, ::hPalette )
   ::nFormat   := nFormat
   ::HasAlpha()

return nil

//----------------------------------------------------------------------------//

#ifndef CBM_INIT
   #define CBM_INIT       4
#endif
#ifndef DIB_RGB_COLORS
   #define DIB_RGB_COLORS 0
#endif

function FILOADIMG( cFile, nFormat, cResFile )

   local hDib, hInfoH, hInfo, hBits, hWnd, hDC, hBmp

   if Upper( cFileExt( cFile ) ) = "BMP"
      return ReadBitmap( 0, cFile )
   endif

   if LoadFreeImage( cResFile ) > 32

      nFormat = FIGETFILETYPE( cFile, 0 )
      hDib    = FILOAD( nFormat, cFile, 0 )
      hInfoH  = FIGETINFOHEADER( hDib )
      hInfo   = FIGETINFO( hDib )
      hBits   = FIGETBITS( hDib )
      hWnd    = GETDESKTOPWINDOW()

      #ifdef __CLIPPER__
         hDC = GETDC32( hWnd )
      #else
        hDC = GETDC( hWnd )
      #endif

      hBmp = CreateDiBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo, DIB_RGB_COLORS )

      ReleaseDC( hWnd, hDC )
      FIUNLOAD( hDib )

   endif

return hBmp

//----------------------------------------------------------------------------//

function FILoadFromMemory( cBuffer, nFormat )

   local hMem, nSize := Len( cBuffer ), hBmp := 0
   local hDib, hInfoH, hInfo, hBits, hWnd, hDC


   if LoadFreeImage() > 32

      hMem    = FI_OpenMemory( cBuffer, nSize )
      nFormat = FI_GetFileTypeFromMemory( hMem, 0 )
      hDib    = FI_LoadFromMemory( nFormat, hMem, 0 )
      hInfoH  = FIGETINFOHEADER( hDib )
      hInfo   = FIGETINFO( hDib )
      hBits   = FIGETBITS( hDib )
      hWnd    = GETDESKTOPWINDOW()

      #ifdef __CLIPPER__
         hDC = GETDC32( hWnd )
      #else
         hDC = GETDC( hWnd )
      #endif

      hBmp = CreateDiBitmap( hDC, hInfoH, CBM_INIT, hBits, hInfo, DIB_RGB_COLORS )

      #ifdef __CLIPPER__
         ReleaseDC32( hWnd, hDC )
      #else
         ReleaseDC( hWnd, hDC )
      #endif

      FI_CloseMemory( hMem )

   endif


return hBmp

//----------------------------------------------------------------------------//

function FITypeFromMemory( cBuffer )

   local hMem, nFormat := -1
   local nSize    := Len( cBuffer )

   if LoadFreeImage() > 32

      hMem    = FI_OpenMemory( cBuffer, nSize )
      nFormat = FI_GetFileTypeFromMemory( hMem, 0 )
      FI_CloseMemory( hMem )

   endif

return nFormat

//------------------------------------------------------------------//

function FIConvertImageFile( cSrcFile, cDstFile, nDstFormat, nQuality )

   local nSrcFormat, hDib, hDib2, lOk := .f.

   DEFAULT nQuality := 0

   if LoadFreeImage() > 32

      nSrcFormat = FIGETFILETYPE( cSrcFile, 0 )

      hDib = FILOAD( nSrcFormat, cSrcFile, 0 )
      hDib2 = FICNV24( hDib )
      lOk = FISAVE( nDstFormat, hDib2, cDstFile, nQuality )

      FIUNLOAD( hDib )
      FIUNLOAD( hDib2 )

   endif

return lOk

//----------------------------------------------------------------------------//

function LoadFreeImage( cResFile )

   DEFAULT cResFile := "freeimage.dll"

   if Empty( hLib )
      #ifdef __CLIPPER__
         hLib = LoadLib32( cResFile )
      #else
         hLib = LoadLibrary( cResFile )
      #endif

      if hLib <= 32
         msgStop( "Cannot load FreeImage.dll" )
         hLib  = 0
      endif

   endif

return hLib

//----------------------------------------------------------------------------//

function UnloadFreeImage()

   if hLib != nil .and. hLib > 32

      #ifdef __CLIPPER__
         FreeLib32( hLib )
      #else
         FreeLibrary( hLib )
      #endif

      hLib  = nil

   endif

return nil

//------------------------------------------------------------------//

EXIT PROCEDURE ExitImage

   UnloadFreeImage()

return

//------------------------------------------------------------------//


DLL32 FUNCTION FISAVE( nFormat AS LONG, hDib AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS BOOL ;
      PASCAL FROM "_FreeImage_Save@16" LIB hLib

DLL32 FUNCTION FIGETWIDTH( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetWidth@4" LIB hLib

DLL32 FUNCTION FICONVTO32( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_ConvertTo32Bits@4" LIB hLib

DLL32 FUNCTION FISETTRANSPARENT( hDib AS LONG, lOnOff AS BOOL ) AS VOID ;
      PASCAL FROM "_FreeImage_SetTransparent@8" LIB hLib

DLL32 FUNCTION FIISTRANSPARENT( hDib AS LONG ) AS BOOL ;
      PASCAL FROM "_FreeImage_IsTransparent@4" LIB hLib

DLL32 FUNCTION FICNV24( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_ConvertTo24Bits@4" LIB hLib

DLL32 FUNCTION GETDC32( hWnd AS LONG ) AS LONG ;
      PASCAL FROM "GetDC" LIB "user32.dll"

DLL32 FUNCTION RELEASEDC32( hWnd AS LONG ) AS LONG ;
      PASCAL FROM "ReleaseDC" LIB "user32.dll"


DLL32 FUNCTION WOWHANDLE16( nHandle AS LONG, nHandleType AS LONG ) AS LONG ;
      PASCAL FROM "WOWHandle16" LIB "wow32.dll"

DLL32 FUNCTION FIGETFILETYPE( cFileName AS LPSTR, nSize AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetFileType@8" LIB hLib

DLL32 FUNCTION FILOAD( nFormat AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_Load@12" LIB hLib

DLL32 FUNCTION FIGETINFOHEADER( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetInfoHeader@4" LIB hLib

DLL32 FUNCTION FIGETINFO( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetInfo@4" LIB hLib

DLL32 FUNCTION FIGETBITS( hDib AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetBits@4" LIB hLib

DLL32 FUNCTION FIUNLOAD( hDib AS LONG ) AS VOID ;
      PASCAL FROM "_FreeImage_Unload@4" LIB hLib


DLL32 FUNCTION FI_OpenMemory( cData AS LPSTR, nSize AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_OpenMemory@8" LIB hLib

DLL32 FUNCTION FI_LoadFromMemory( nFormat AS LONG, nStream AS LONG, nFlags AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_LoadFromMemory@12" LIB hLib


DLL32 FUNCTION FI_CloseMemory( nStream AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_CloseMemory@4" LIB hLib

DLL32 FUNCTION FI_GetFileTypeFromMemory( nStream AS LONG, nSize AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_GetFileTypeFromMemory@8" LIB hLib

DLL32 FUNCTION FI_SaveToMemory( nFormat AS LONG, hDib AS LONG, cStream AS LPSTR, nFlags AS LONG ) AS LONG ;
      PASCAL FROM "_FreeImage_SaveToMemory@12" LIB "freeImage.dll"

//----------------------------------------------------------------------------//














































































































































































































































































































































































































































































































































































































































































































































































































