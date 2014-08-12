#include "Fivewin.ch"
#include "Colors.ch"

/*--------------------------------------------------------------------------------------------------------------*/
/*  C5Box                                                                                                       */
/*  DrawRect                                                                                                    */
/*  DrawButton                                                                                                  */
/*  DrawButton2                                                                                                 */
/*  FontUnder                                                                                                   */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*                                                                                                              */
/*--------------------------------------------------------------------------------------------------------------*/

#define TOP     aRcMText[1]
#define LEFT    aRcMText[2]
#define BOTTOM  aRcMText[3]
#define RIGHT   aRcMText[4]

#define ANCHO aSize[1]
#define ALTO  aSize[2]

static cMenuOpt, cMenuAct
static aImages := {}

/***************************************************************************************************************************/
   function aC5Box( hDC, aRect )
/***************************************************************************************************************************/

  local nTop, nLeft, nBottom, nRight

  nTop    := aRect[1]
  nLeft   := aRect[2]
  nBottom := aRect[3]
  nRight  := aRect[4]


  MoveTo( hDC, nLeft,  nTop    )
  LineTo( hDC, nRight, nTop    )
  LineTo( hDC, nRight, nBottom )
  LineTo( hDC, nLeft,  nBottom )
  LineTo( hDC, nLeft,  nTop    )

return nil

/***************************************************************************************************************************/
   function C5Box( hDC, nTop, nLeft, nBottom, nRight )
/***************************************************************************************************************************/

   aC5Box( hDC, {nTop, nLeft, nBottom, nRight})

return nil




//***************************************************************************************************
  function FontUnder( oFont )
//***************************************************************************************************

if valtype( oFont ) == "N"
   #ifdef __HARBOUR__
      return CreateFontUnderline( oFont )
   #else
      return CreaFunder( oFont )
   #endif
endif
// la tiene que matar quien la pida

Return CreateFont( { oFont:nInpHeight, oFont:nInpWidth, oFont:nEscapement,;
                     oFont:nOrientation, if(oFont:lBold,700,400), oFont:lItalic,;
                     .t., oFont:lStrikeOut, oFont:nCharSet,;
                     oFont:nOutPrecision, oFont:nClipPrecision,;
                     oFont:nQuality, oFont:nPitchFamily, oFont:cFaceName } )


function Colores()

   local hDC        := CreateDC( "DISPLAY", "", "" )
   local nPlanes    := GetDeviceCaps( hDC, 14 )    // PLANES
   local nBitsPixel := GetDeviceCaps( hDC, 12 )    // BITSPIXEL
   DeleteDC( hDC )

return Int( 2 ^ ( nPlanes * nBitsPixel ) )




**************************************************************************************
  function GetOriginalOrden()
**************************************************************************************
local aRet

return aRet


function LoadAccesos( cFileMenuOpt, cFileMenuAct, aItems )


return nil

#define COLORONCOLOR                 3
#define SRCCOPY 13369376


**************************************************************************************
  function GetBitmapSize( hBitmap, nW, nH, lDestroy )
**************************************************************************************
DEFAULT lDestroy := .f.

return GetBitmap16( hBitmap, nW, nH, lDestroy )

**************************************************************************************
  function GetBitmap16( hBitmap, nW, nH, lDestroy, lIcon )
**************************************************************************************
   local hBmpMem, hOldBmp, hOldBmp2
   local hDC, hDCMem, hDCMem2
   local nWidth, nHeight

   DEFAULT nW := 16
   DEFAULT nH := nW
   DEFAULT lDestroy := .f.
   DEFAULT lIcon := .f.

   hDC     = CreateDC("DISPLAY", 0, 0, 0)
   hDCMem  = CreateCompatibleDC( hDC )
   hDCMem2  = CreateCompatibleDC( hDC )


   if lIcon
      nWidth := 32
      nHeight := 32
   else
      nWidth  := BmpWidth( hBitmap )
      nHeight := BmpHeight( hBitmap )
   endif

   hOldBmp2 := SelectObject( hDCMem2, hBitmap )
   C5_ExtFloodFill( hDCMem2, 1, 1, CLR_WHITE ) //

   hBmpMem := CreateCompatibleBitmap( hDC, nW, nH )
   hOldBmp := SelectObject( hDCMem, hBmpMem )
   FillSolidRect( hDCMem, {0,0,nH,nW}, RGB( 255,0,255 ) )
   SetStretchBltMode (hDcMem, 3 )
   StretchBlt( hDcMem, 0, 0, nW, nH, hDCMem2, 0, 0, nWidth, nHeight, SRCCOPY )
   SelectObject( hDCMem, hOldBmp )
   SelectObject( hDCMem2, hOldBmp2 )
   DeleteDC( hDCMem )
   DeleteDC( hDCMem2 )
   DeleteDC( hDC )

   if lDestroy
      if lIcon
         DestroyIcon( hBitmap )
      else
         DeleteObject( hBitmap )
      endif
   endif

return hBmpMem


**************************************************************************************
  function __mirrow( hDC, aRect, color1, color2, lVertical )
**************************************************************************************


if lVertical
   VGradientFill( hDC, {aRect[1],aRect[2],aRect[1]+(aRect[3]-aRect[1])/2,aRect[4]}, color1, color2 )
   VGradientFill( hDC, {aRect[1]+(aRect[3]-aRect[1])/2,aRect[2],aRect[3],aRect[4]}, color2, color1 )
else
   HGradientFill( hDC, {aRect[1],aRect[2],aRect[3],aRect[2]+(aRect[4]-aRect[2])/2}, color1, color2 )
   HGradientFill( hDC, {aRect[1],aRect[2]+(aRect[4]-aRect[2])/2,aRect[3],aRect[4]}, color1, color2 )
endif

return 0


function XADrives( nType )  // Thanks to EMG

   local aDisk := {}
   local i

   DEFAULT nType := 0

   if nType = 0 .OR. nType = 1
      for i = ASC( "A" ) TO ASC( "B" )
          if ISDISKETTE( CHR( i ) + ":" )
             AADD( aDisk, CHR( i ) + ":" )
          endif
      next
   endif

   if nType = 0 .OR. nType = 2
      for i = ASC( "C" ) TO ASC( "Z" )
          if ISCDROM( CHR( i ) + ":" ) .OR. FILE( CHR( i ) + ":\NUL" )
             AADD( aDisk, CHR( i ) + ":" )
          endif
      next
   endif

return aDisk

function SaveScreenAsBmp( hDC, nTop, nLeft, nBottom, nRight )

   local hBmpMem, hOldBmp
   local hDCMem
   local nWidth, nHeight

   hDCMem  = CreateCompatibleDC( hDC )

   nWidth  := nRight - nLeft
   nHeight := nBottom - nTop

   hBmpMem := CreateCompatibleBitmap( hDC, nWidth, nHeight )
   hOldBmp := SelectObject( hDCMem, hBmpMem )
   BitBlt( hDCMem, 0, 0, nWidth, nHeight, hDC, nLeft, nTop, SRCCOPY )
   SelectObject( hDCMem, hOldBmp )
   DeleteDC( hDCMem )

return hBmpMem

function RestoreScreenFromBmp( hDC, hBmp, nTop, nLeft )

  DrawBitmap( hDC, hBmp, nTop, nLeft )

return nil


///////////////////////////////////////////////////////////////////////////////////////////////////////
  function GenImageList()
///////////////////////////////////////////////////////////////////////////////////////////////////////

local aAux := {}
local cFiltro := "Imágenes (*.bmp) | *.bmp |"
local cFileName
aImages := {}


do while .t.

   aAux := cGetFileEx( "*.bmp", "Seleccione imágenes" )

   if !empty( aAux )

      AddImages( aAux )

      if MsgYesNo( "Desea terminar el proceso" )
         cFileName := cGetFile( "*.bmp","Guardar imagen como...", 1, , .t. )
         SaveImagenAs( cFileName )
         return nil
      endif

   else
      if MsgYesNo( "Desea terminar el proceso" )
         exit
      endif
   endif

enddo

return nil

********************************************************************************************************
 static function AddImages( aAux )
********************************************************************************************************

  local n, n2, nLen
  local lExiste := .f.

  for n := 1 to len( aAux )
      lExiste := .f.
      for n2 := 1 to len( aImages )
          if aAux[n] == aImages[n2]
             lExiste := .t.
             exit
          endif
      next
      if !lExiste
         aadd( aImages, aAux[n] )
      endif
  next

return nil

********************************************************************************************************
 static function SaveImagenAs( cFileName )
********************************************************************************************************
local n, nLen
local hBmp
local ahBmps := {}
local nMaxW := 0
local nMaxH := 0
local nW, nH
local hDCMem, hBmpMem, hOldBmp
local hDC := GetDC( 0 )
local cAux

for n := 1 to len( aImages )

    cAux := LFN2SFNEx( aImages[n])
    hBmp := ReadBitmap( 0, cAux )
    nW := nBmpWidth ( hBmp )
    nH := nBmpHeight( hBmp )
    aadd( ahBmps, {hBmp, nW, nH} )
    nMaxW := max( nW, nMaxW )
    nMaxH := max( nH, nMaxH )

next

hDCMem  := CreateCompatibleDC( hDC )
hBmpMem := CreateCompatibleBitmap( hDC, nMaxW * len( aImages ), nMaxH )
hOldBmp := SelectObject( hDCMem, hBmpMem )

FillSolidRect( hDCMem, {0,0, nMaxH,nMaxW * len( aImages ) }, RGB( 255, 0, 255 ) )

for n := 1 to len( aImages )
    DrawMasked( hDCMem, ahBmps[n,1], nMaxH-ahBmps[n,3], ( n - 1)* nMaxW  )
next

SelectObject( hDCMem, hOldBmp )

DeleteDC( hDCMem )
ReleaseDC( 0, hDC )

DibWrite( cFileName, DibFromBitmap( hBmpMem ) )

DeleteObject( hBmpMem )

for n := 1 to len( aImages )
    DeleteObject( aImages[n,1] )
next

return nil


function Lfn2SfnEx( cDir )
local cDirEx := ""
local nDirs := len( cDir ) - len(strtran( cDir, "\", "" ))
local nEn, n
local cAux

for n := 1 to nDirs
    nEn := FindChar( cDir, "\", n )
    cAux := left( cDir, nEn )
    cDirEx := Lfn2Sfn( cAux )
    //? cAux, cDirEx
next

cAux := cDirEx + substr( cDir, nEn+1 )
cDirEx := cAux

return cDirEx

function FindChar( cStr, cChar, nOcurrence )
local nCount := 0
local nLen := len( cStr )
local c, n

for n := 1 to nLen
    if substr( cStr, n, len( cChar ) ) == cChar
       if nOcurrence == ++nCount
          nCount := n
          exit
       endif
    endif
next

return nCount


//////////////////////////////////////////////////////////////////////////////////////////////////////
   function DlgChangeSize( nSize, lFromCursor )
//////////////////////////////////////////////////////////////////////////////////////////////////////

local oDlg
local oGet1
local oBtn1
local oBtn2
local nAux := nSize
local a := GetCursorPos()
local aPoint := {a[1],a[2]}


DEFAULT lFromCursor := .f.





DEFINE DIALOG oDlg ;
       FROM 409, 544 TO 505, 709 PIXEL ;
       TITLE "Tamaño"

       @ 10, 25 GET oGet1 VAR nSize ;
             SIZE 15, 8 PIXEL OF oDlg ;
             SPINNER MIN 30 MAX 600

       @ 34, 43 BUTTON oBtn1 PROMPT "Aceptar" ;
             SIZE 29, 10 PIXEL OF oDlg ACTION oDlg:End() DEFAULT

       @ 34, 9 BUTTON oBtn2 PROMPT "Cancelar" ;
             SIZE 28, 10 PIXEL OF oDlg ACTION ( nSize := nAux, oDlg:End() )


ACTIVATE DIALOG oDlg CENTERED ;
         ON INIT ( if(lFromCursor, oDlg:Move( a[1], a[2] ),), oDlg:ToolWindow() )


return 0

///////////////////////////////////////////////////////////////////////////////////////////
  function strcount( cString, cChar )
///////////////////////////////////////////////////////////////////////////////////////////

return ( len( cString ) - len( strtran( cString, cChar, "" ) )/len(cChar))

///////////////////////////////////////////////////////////////////////////////////////////
  function aSplit( cString, cChar )
///////////////////////////////////////////////////////////////////////////////////////////

local nItems := strcount( cString, cChar )
local aItems := {}
local n
local uItem

if nItems == 0
   return  aItems
endif

for n := 1 to nItems + 1
    aadd( aItems, alltrim(strtoken( cString, n, cchar )) )
next

return aItems

////////////////////////////////////////////////////////////////////
  function LoadIConEx( cImage )
////////////////////////////////////////////////////////////////////

 local hBmp := 0

 hBmp := LoadIcon( GetResources(), cImage )
 if hBmp == 0
    hBmp := ExtractIcon( cImage )
 endif

return hBmp


////////////////////////////////////////////////////////////////////
  function LoadImageEx( cImage )
////////////////////////////////////////////////////////////////////

 local hBmp := 0

 hBmp := LoadBitmap( GetResources(), cImage )
 if hBmp == 0
    hBmp := ReadBitmap( 0, cImage )
 endif

return hBmp

////////////////////////////////////////////////////////////////////
  function LoadImageEx2( cImage, hBmp )
////////////////////////////////////////////////////////////////////
local lIcon := .f.

 hBmp := LoadImageEx( cImage )
 if hBmp == 0
    hBmp := LoadIcon( GetResources(), cImage )
    if hBmp == 0
       hBmp := ExtractIcon( cImage )
       lIcon := hBmp != 0
    else
       lIcon := .t.
    endif
 endif

return lIcon

////////////////////////////////////////////////////////////////////
   function GetDefFont() ; return GetStockObject( 17 )
////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////
   function lThemes()
////////////////////////////////////////////////////////////////////

return C5_IsAppThemed() .and. C5_IsThemeActive()


////////////////////////////////////////////////////////////////////
  function creavgrip( nColor, nHeight )
////////////////////////////////////////////////////////////////////
local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( hDC )
local hBmpMem := CreateCompatibleBitmap( hDC, 5, nHeight )
local hOldBmp := SelectObject( hDCMem, hBmpMem )
local rc      := {0,0,nHeight,5}
local n
local nVeces := int( nHeight / 4)

FillSolidRect( hDCMem, rc, RGB(255,0,255) )

rc := {2,2,4,4}

for n := 1 to nVeces
    FillSolidRect( hDCMem, rc, RGB(255,255,255) )
    rc[1] += 4
    rc[3] += 4
next

rc := {1,1,3,3}

for n := 1 to nVeces
    FillSolidRect( hDCMem, rc, nColor )
    rc[1] += 4
    rc[3] += 4
next

SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )
DeleteDC( hDC )

return hBmpMem

////////////////////////////////////////////////////////////////////
  function CreaArowRight()
////////////////////////////////////////////////////////////////////
local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( hDC )
local hBmpMem := CreateCompatibleBitmap( hDC, 8, 11 )
local hOldBmp := SelectObject( hDCMem, hBmpMem )
local rc      := {0,0,11,8}
local hBrush  := GetStockObject(4)
local hOldBrush := SelectObject( hDCMem, hBrush )

FillSolidRect( hDCMem, rc, RGB(255,0,255) )

PolyPolygon( hDCMem, {{2,0},{7,5},{2,10},{2,0}} )


SelectObject( hDCMem, hOldBrush )
SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )
DeleteDC( hDC )

return hBmpMem



////////////////////////////////////////////////////////////////////
  function CreaBitmapEx( nWidth, nHeight, nColor, nColor2, lVGrad )
////////////////////////////////////////////////////////////////////
local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( hDC )
local hBmpMem := CreateCompatibleBitmap( hDC, nWidth, nHeight )
local hOldBmp := SelectObject( hDCMem, hBmpMem )
local rc      := {0,0,nHeight,nWidth}

if lVGrad == nil; lVGrad := .t.; endif
if nColor2 == nil; nColor2 := nColor; endif

if lVGrad
   VerticalGradient( hDCMem, rc, nColor, nColor2 )
else
   HGradientFill( hDCMem, {rc[1],rc[2],rc[3]+2,rc[4]}, nColor, nColor2, 60 )
endif

SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )
DeleteDC( hDC )

return hBmpMem

//////////////////////////////////////////////////////////////////////////////////////////////
  function CreaBitmapEx2( nWidth, nHeight, nColor, nColor2, nColor3, nColor4, lVGrad )
//////////////////////////////////////////////////////////////////////////////////////////////
local hDC     := CreateDC( "DISPLAY",0,0,0 )
local hDCMem  := CreateCompatibleDC( hDC )
local hBmpMem := CreateCompatibleBitmap( hDC, nWidth, nHeight )
local hOldBmp := SelectObject( hDCMem, hBmpMem )
local rc      := {0,0,nHeight,nWidth}

if lVGrad == nil; lVGrad := .t.; endif
if nColor2 == nil; nColor2 := nColor; endif

if lVGrad
   VerticalGradient( hDCMem, {rc[1],rc[2],rc[1]+((rc[3]-rc[1])/2),rc[4]}, nColor, nColor2 )
   VerticalGradient( hDCMem, {rc[1]+((rc[3]-rc[1])/2)-1,rc[2],rc[3]+2,rc[4]}, nColor3, nColor4 )
else
   HGradientFill( hDCMem, {rc[1],rc[2],rc[3]+2,rc[4]}, nColor, nColor2, 60 )
   HGradientFill( hDCMem, {rc[1],rc[2],rc[3]+2,rc[4]}, nColor, nColor2, 60 )
endif

SelectObject( hDCMem, hOldBmp )
DeleteDC( hDCMem )
DeleteDC( hDC )

return hBmpMem


***************************************************************************
   function MemoWritEx( cFileName, cStr )
***************************************************************************

  local nmanejador:=FCREATE(cFileName, 0)
  FWRITE(nManejador, cStr )
  FCLOSE(nManejador)

return 0

******************************************************************************************************
  function DrawMText( hDC, cText, rc, lDraw )
******************************************************************************************************
local nWidth   := rc[4]-rc[2]
local nEn
local cPalabra
local nLeft    := rc[2]
local nTop     := rc[1]
local cLinea   := ""
local sz
local nCount   := 0

DEFAULT lDraw := .T.

cText += " "
do while ( ( nEn := at( " ", cText )) != 0 )

   do while substr( cText, ++nEn, 1 ) == " " ; enddo

   cPalabra := left( cText, nEn-1 )

   nCount++

   sz = GetSizeText( hDC, cLinea + rtrim(cPalabra) )

   if sz[1] < nWidth

      cLinea += cPalabra

   else

      if lDraw
         ExtTextOut( hDC, nTop, nLeft, {nTop, rc[2], nTop+sz[2],rc[4]}, cLinea, 4 )
      endif

      cLinea := cPalabra

      if nCount > 1
         nTop += sz[2]
      endif

   endif

   cText := substr( cText, nEn )
enddo

if lDraw; ExtTextOut( hDC, nTop, nLeft, {nTop, rc[2], nTop+sz[2],rc[4]}, cLinea, 4 ) ; endif

return (nTop + sz[2])-rc[1]



//function LoadAllImage( cImage )
//
//   local lFile := (at( ".", cImage ) != 0)
//   local nFormat, hInfoH, hInfo, hBits, hWnd, hDC, hBmp, hDib, hLib
//   local cExt := lower(right(cImage,4))
//
//   if !lFile
//      return LoadBitmap( GetResources(),cImage )
//   endif
//
//   if ".bmp" == cExt
//      return ReadBitmap( 0, cImage )
//   endif
//
//
//   nFormat := fiGetFileType( cImage, 0 )
//   hDib    := fiLoad( nFormat, cImage, 0 )
//   hInfoH  := fiGetInfoHeader( hDib )
//   hInfo   := fiGetInfo( hDib )
//   hBits   := fiGetBits( hDib )
//   hWnd    := GetDesktopWindow()
//   hDC     := GetDC( hWnd )
//   hBmp    := CreateDIBitmap( hDC, hInfoH, 4, hBits, hInfo,0 )
//
//   ReleaseDC( hWnd, hDC )
//
//return hBmp
//


//DLL32 STATIC FUNCTION FIGETFILETYPE( cFileName AS LPSTR, nSize AS LONG )AS LONG;
//PASCAL FROM "_FreeImage_GetFileType@8" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FILOAD( nFormat AS LONG, cFileName AS LPSTR,nFlags AS LONG ) AS LONG;
//PASCAL FROM "_FreeImage_Load@12" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FIGETINFOHEADER( hDib AS LONG ) AS LONG;
//PASCAL FROM "_FreeImage_GetInfoHeader@4" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FIGETINFO( hDib AS LONG ) AS LONG;
//PASCAL FROM "_FreeImage_GetInfo@4" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FIGETBITS( hDib AS LONG ) AS LONG;
//PASCAL FROM "_FreeImage_GetBits@4" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION CREATEDIBITMAP( hDC AS LONG, hInfoH AS LONG,nFlags AS LONG, hBits AS LONG, hInfo AS LONG, nUsage AS LONG ) AS LONG;
//PASCAL FROM "CreateDIBitmap" LIB "gdi32.dll"
//
//DLL32 STATIC FUNCTION ROTATECLASSIC( hDib AS LONG, angle AS _DOUBLE ) AS LONG;
//PASCAL FROM "_FreeImage_RotateClassic@12" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FISETBKCOLOR(hDib AS LONG, bkcolor AS _DOUBLE ) AS BOOL ;
//PASCAL FROM "FreeImage_SetBackgroundColor" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FISAVE( nFormat AS LONG, hDib AS LONG, cFileName AS LPSTR, nFlags AS LONG ) AS BOOL;
//PASCAL FROM "_FreeImage_Save@16" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FIADJUSTBRIGHTNESS( hDib AS LONG, percentage AS _DOUBLE ) AS BOOL ;
//PASCAL FROM "_FreeImage_AdjustBrightness@12" LIB "Freeimage.dll"
//
//DLL32 STATIC FUNCTION FIADJUSTCONTRAST( hDib AS LONG, percentage AS _DOUBLE ) AS BOOL ;
//PASCAL FROM "_FreeImage_AdjustContrast@12" LIB "Freeimage.dll"

**********************************************************************************************************************
  function Icon2Bmp( cIcon )
**********************************************************************************************************************

   local hBmpMem, hOldBmp
   local hDC, hDCMem
   local nWidth, nHeight
   local hIcon := LoadIConEx( cIcon )

   hDC      := CreateDC("DISPLAY", 0, 0, 0)
   hDCMem   := CreateCompatibleDC( hDC )

   nWidth := 32
   nHeight := 32

   hBmpMem := CreateCompatibleBitmap( hDC, nWidth, nHeight )
   hOldBmp := SelectObject( hDCMem, hBmpMem )
   FillSolidRect( hDCMem, {0,0,nHeight,nWidth}, RGB( 255,0,255 ) )
   DrawIcon( hDCMem, 0, 0, hIcon )
   SelectObject( hDCMem, hOldBmp )
   DeleteDC( hDCMem )
   DeleteDC( hDC )
   DestroyIcon( hIcon )
 
return hBmpMem

**********************************************************************************************************************

#pragma BEGINDUMP
#include "windows.h"
#include "hbapi.h"

#ifdef __XHARBOUR__
   #define hb_parvc        hb_parc
   #define hb_parvni       hb_parni
   #define hb_storvc       hb_storc
   #define hb_storvni      hb_storni 
#endif

void DrawGradientFill( HDC hDC, RECT rct, COLORREF crStart, COLORREF crEnd, int nSegments, int bVertical )
{
        // Get the starting RGB values and calculate the incremental
        // changes to be applied.

        COLORREF cr;
        int nR = GetRValue(crStart);
        int nG = GetGValue(crStart);
        int nB = GetBValue(crStart);

        int neB = GetBValue(crEnd);
        int neG = GetGValue(crEnd);
        int neR = GetRValue(crEnd);

        int nDiffR = (neR - nR);
        int nDiffG = (neG - nG);
        int nDiffB = (neB - nB);

        int ndR = 256 * (nDiffR) / (max(nSegments,1));
        int ndG = 256 * (nDiffG) / (max(nSegments,1));
        int ndB = 256 * (nDiffB) / (max(nSegments,1));

        int nCX = (rct.right-rct.left) / max(nSegments,1);
        int nCY = (rct.bottom-rct.top) / max(nSegments,1);
        int nTop = rct.top;
        int nBottom = rct.bottom;
        int nLeft = rct.left;
        int nRight = rct.right;

        HPEN hPen;
        HPEN hOldPen;
        HBRUSH hBrush;
        HBRUSH pbrOld;

        int i;

        if(nSegments > ( rct.right - rct.left ) )
                nSegments = ( rct.right - rct.left );


        nR *= 256;
        nG *= 256;
        nB *= 256;

        hPen    = CreatePen( PS_NULL, 1, 0 );
        hOldPen = (HPEN) SelectObject( hDC, hPen );

        for (i = 0; i < nSegments; i++, nR += ndR, nG += ndG, nB += ndB)
        {
                // Use special code for the last segment to avoid any problems
                // with integer division.

                if (i == (nSegments - 1))
                {
                        nRight  = rct.right;
                        nBottom = rct.bottom;
                }
                else
                {
                        nBottom = nTop + nCY;
                        nRight = nLeft + nCX;
                }

                cr = RGB(nR / 256, nG / 256, nB / 256);

                {

                        hBrush = CreateSolidBrush( cr );
                        pbrOld = (HBRUSH) SelectObject( hDC, hBrush );

                        if( bVertical )
                           Rectangle(hDC, rct.left, nTop, rct.right, nBottom + 1 );
                        else
                           Rectangle(hDC, nLeft, rct.top, nRight + 1, rct.bottom);

                        (HBRUSH) SelectObject( hDC, pbrOld );
                        DeleteObject( hBrush );
                }

                // Reset the left side of the drawing rectangle.

                nLeft = nRight;
                nTop = nBottom;
        }

        (HPEN) SelectObject( hDC, hOldPen );
        DeleteObject( hPen );
}


HB_FUNC( DRAWGRADIENTFILL )
{
        RECT rct;

        rct.top    = hb_parvni( 2, 1 );
        rct.left   = hb_parvni( 2, 2 );
        rct.bottom = hb_parvni( 2, 3 );
        rct.right  = hb_parvni( 2, 4 );

        DrawGradientFill( ( HDC ) hb_parnl( 1 ) , rct, hb_parnl( 3 ), hb_parnl( 4 ), hb_parni(5), hb_parl( 6 ) );
}