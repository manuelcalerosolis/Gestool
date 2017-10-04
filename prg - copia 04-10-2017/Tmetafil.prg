#include "FiveWin.Ch"
#include "Struct.ch"

#define MM_ANISOTROPIC         8

#define SW_HIDE                0
#define SW_SHOWNA              8

#define SHADOW_DEEP            5
#define SHADOW_WIDTH           5

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TMetaFile FROM TControl

   DATA   hMeta
   DATA   oPen
   DATA   nWidth, nHeight, nXorig, nYorig, nXZoom, nYZoom
   DATA   lZoom, lShadow
   DATA   lEMF AS LOGICAL

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight, cMetaFile, oWnd,;
               nClrFore, nClrBack ) CONSTRUCTOR

   METHOD Redefine( nId, cMetaFile, oWnd, nClrFore, nClrBack ) CONSTRUCTOR

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
   METHOD Paint()

   METHOD SetFile(cFile)

   METHOD Shadow()

   METHOD End()

   METHOD ZoomIn()  INLINE IIF(!::lZoom, (::nWidth  /= ::nXZoom ,;
                                          ::nHeight /= ::nYZoom ,;
                                          ::lZoom   :=      .T. ,;
                                          ::Refresh()), )
   METHOD ZoomOut() INLINE IIF(::lZoom , (::nWidth  *= ::nXZoom ,;
                                          ::nHeight *= ::nYZoom ,;
                                          ::lZoom   := .F.      ,;
                                          ::nXorig  := 0        ,;
                                          ::nYorig  := 0        ,;
                                          ::Refresh()), )

   METHOD SetZoomFactor(nXFactor, nYFactor)

   METHOD SetOrg(nX,nY)    INLINE iif(nX != NIL, ::nXorig := nX ,) ,;
                                  iif(nY != NIL, ::nYorig := nY ,)

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, cMetaFile, oWnd,;
            nClrFore, nClrBack,nLogWidth, nLogHeight ) CLASS TMetaFile

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT nWidth := 100, nHeight := 100, oWnd := GetWndDefault()

   ::nTop     = nTop
   ::nLeft    = nLeft
   ::nBottom  = nTop + nHeight - 1
   ::nRight   = nLeft + nWidth - 1
   ::cCaption = cMetaFile
   ::oWnd     = oWnd
   ::nStyle   = nOr( WS_CHILD, WS_BORDER, WS_VISIBLE )
   ::nWidth   = nLogWidth
   ::nHeight  = nLogHeight
   ::lZoom    = .F.
   ::lShadow  = .T.
   ::nXorig   = 0
   ::nYorig   = 0
   ::hMeta    = 0
   ::nXZoom   = 2
   ::nYZoom   = 4

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()

   ::SetColor( nClrFore, nClrBack )

   if ::lShadow
     DEFINE PEN ::oPen WIDTH SHADOW_WIDTH
   endif

   if oWnd:lVisible
      ::Create()
      ::Default()
      ::lVisible = .t.
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
      ::lVisible  = .f.
   endif

   ::lEMF = !IsWinNT()

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, cMetaFile, oWnd, nClrFore, nClrBack ) CLASS TMetaFile

   DEFAULT oWnd := GetWndDefault()

   ::nId      = nId
   ::cCaption = cMetaFile
   ::oWnd     = oWnd
   ::nWidth   = 100
   ::nHeight  = 100
   ::hMeta    = 0
   ::lShadow  = .t.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()

   ::SetColor( nClrFore, nClrBack )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TMetaFile

   local oRect := ::GetRect()
   local oEMFH := nil

   if ::hMeta == 0

      if file(::cCaption)

         if ::lEMF
            ::hMeta = WMF2EMF( ::cCaption )
         else
            ::hMeta = GetMetaFile( ::cCaption )
         endif

      elseif !Empty( ::cCaption )
         Alert( "Could not find the Metafile," + CRLF + "please check your TEMP environment variable" )
      endif

   endif

   if ::hMeta != 0

        ::Shadow()

        SetWindowOrg(::hDC, ::nXorig, ::nYorig)
        SetMapMode( ::hDC, MM_ANISOTROPIC )
        SetWindowExt( ::hDC, ::nWidth, ::nHeight )
        SetViewportExt( ::hDC, oRect:nRight - oRect:nLeft, oRect:nBottom - oRect:nTop )

        CursorWait()

        if ::lEMF

           STRUCT oEMFH
              MEMBER nType           AS DWORD
              MEMBER nSize           AS DWORD
              MEMBER cBounds         AS STRING LEN 16
              MEMBER cFrame          AS STRING LEN 16
              MEMBER nSignature      AS DWORD
              MEMBER nVersion        AS DWORD
              MEMBER nBytes          AS DWORD
              MEMBER nRecords        AS DWORD
              MEMBER nHandles        AS WORD
              MEMBER nReserved       AS WORD
              MEMBER nDescription    AS DWORD
              MEMBER nOffDescription AS DWORD
              MEMBER nPalEntries     AS DWORD
              MEMBER cDevice         AS STRING LEN 8
              MEMBER cMillimeters    AS STRING LEN 8
              MEMBER nPixelFormat    AS DWORD
              MEMBER nOffPixelFormat AS DWORD
              MEMBER nOpenGL         AS DWORD
           ENDSTRUCT

           GetEMFHeader( ::hMeta, oEMFH:SizeOf(), oEMFH:cBuffer )

           PlayEMF( ::hDC, ::hMeta, oEMFH:cBounds )

        else

           PlayMetaFile( ::hDC, ::hMeta )

        endif

        CursorArrow()

   endif

return nil

//----------------------------------------------------------------------------//
METHOD SetFile(cFile) CLASS TMetaFile

   if file(cFile)
      ::cCaption = cFile
   else
      ::cCaption = ""
   endif

   if ::hMeta != 0

      if ::lEMF
         DeleteEMF( ::hMeta )
      else
         DeleteMetafile( ::hMeta )
      endif

      ::hMeta = 0

   endif

return nil

//----------------------------------------------------------------------------//

METHOD Shadow() CLASS TMetaFile

     if !::lShadow
        return nil
     endif

     ::oWnd:GetDC()

     MoveTo( ::oWnd:hDC              ,;
          ::nLeft + SHADOW_DEEP   ,;
          ::nBottom )
     LineTo( ::oWnd:hDC              ,;
          ::nRight                ,;
          ::nBottom               ,;
          ::oPen:hPen )
     MoveTo( ::oWnd:hDC              ,;
          ::nRight                ,;
          ::nTop + SHADOW_DEEP )
     LineTo( ::oWnd:hDC              ,;
          ::nRight                ,;
          ::nBottom               ,;
          ::oPen:hPen )

     ::oWnd:ReleaseDC()

return nil

//----------------------------------------------------------------------------//

METHOD End() CLASS TMetaFile

   if ::hMeta != 0

      if ::lEMF
         DeleteEMF( ::hMeta )
      else
         DeleteMetafile( ::hMeta )
      endif

      ::hMeta = 0

   endif

   if ::lShadow
      ::oPen:End()
   endif

   Super:End()

return nil

//----------------------------------------------------------------------------//

METHOD SetZoomFactor( nX, nY ) CLASS TMetafile

   if ::lZoom
      ::nWidth  *= ::nXZoom
      ::nHeight *= ::nYZoom
   endif

   ::nXZoom := nX
   ::nYZoom := nY

   if ::lZoom
      ::nWidth  /= ::nXZoom
      ::nHeight /= ::nYZoom
      ::Refresh()
   endif

return NIL

//----------------------------------------------------------------------------//

static function WMF2EMF( cWMF )

   local hWMF    := GetMetafile( cWMF )
   local nSize   := GetMetaFBE( hWMF )
   local hGlobal := GlobalAlloc( 64, nSize )
   local pData   := GlobalLock( hGlobal )
   local hEMF    := 0

   GetMetaFBE( hWMF, nSize, pData )

   hEMF = SetWinMFB( nSize, pData, 0 )

   GlobalUnlock( hGlobal )

   GlobalFree( hGlobal )

   DeleteMetafile( hWMF )

return hEMF

//----------------------------------------------------------------------------//

dll32 static function GETMETAFBE( hWMF AS LONG, nSize AS LONG, pData AS PTR ) AS LONG ;
      PASCAL FROM "GetMetaFileBitsEx" LIB "gdi32.dll"

dll32 static function SETWINMFB( nSize AS LONG, pData AS PTR, hDC AS LONG, cRect AS LPSTR ) ;
      AS LONG PASCAL FROM "SetWinMetaFileBits" LIB "gdi32.dll"

dll32 static function PLAYEMF( hDC AS LONG, hEMF AS LONG, cRect AS LPSTR ) AS BOOL;
      PASCAL FROM "PlayEnhMetaFile" LIB "gdi32.dll"

dll32 static function DELETEEMF( hEMF AS LONG ) AS BOOL;
      PASCAL FROM "DeleteEnhMetaFile" LIB "gdi32.dll"

dll32 static function GETEMFHEADER( hEMF AS LONG, nSize AS LONG, cHeader AS LPSTR ) AS LONG;
      PASCAL FROM "GetEnhMetaFileHeader" LIB "gdi32.dll"

//----------------------------------------------------------------------------//