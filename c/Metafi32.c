#ifdef __C3__

#include <Windows.h>
#include "Extend.api"

#else

#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#endif

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER CREATEENHM( PARAMS ) // ()   cFileName --> hDC
#else
   CLIPPER CREATEENHMETAFILE( void ) // ()   cFileName --> hDC
#endif
{
   RECT rect ;
   LONG iWidthMM, iHeightMM ;
   HDC  hdcRet;

   iWidthMM    = GetDeviceCaps( ( HDC ) _parnl( 1 ), HORZSIZE) * 100;
   iHeightMM   = GetDeviceCaps( ( HDC ) _parnl( 1 ), VERTSIZE) * 100;

   rect.left   = 0 ;
   rect.top    = 0 ;
   rect.right  = iWidthMM ;
   rect.bottom = iHeightMM ;

   hdcRet = ( HDC ) CreateEnhMetaFile( (HDC)_parnl(1), (LPSTR)_parc( 2 ), &rect, (LPSTR)_parc(3) );

   if( !hdcRet )
   {
      char sBuffer[ 200 ];

   	  wsprintf( sBuffer, "Error (%d) creating enhanced metafile", GetLastError() );
      MessageBox( NULL, sBuffer, ( LPSTR ) _parc( 2 ), MB_OK && MB_ICONEXCLAMATION );

   }
   else
      _retnl( ( LONG ) hdcRet );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER CLOSEENHME( PARAMS ) // ()   hDC --> hMetaFile
#else
   CLIPPER CLOSEENHMETAFILE( void ) // ()   hDC --> hMetaFile
#endif
{
   _retnl( ( LONG ) CloseEnhMetaFile( ( HDC ) _parnl( 1 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER DELETEENHM( PARAMS ) // ()   hDC --> hMetaFile
#else
   CLIPPER DELETEENHMETAFILE( void ) // ()   hDC --> hMetaFile
#endif
{
   BOOL lRet ;

   lRet = ( BOOL ) DeleteEnhMetaFile( ( HENHMETAFILE ) _parnl( 1 ) );

   if( ! lRet )
   {
      char sBuffer[ 200 ];

   	  wsprintf( sBuffer, "Error (%d) deleting enhanced metafile\n\n\Error description", GetLastError() );
     	MessageBox( NULL, sBuffer, ( LPSTR ) _parc( 2 ), MB_OK | MB_ICONEXCLAMATION );
   }

   _retnl( (LONG) lRet  );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER GETENHMETA( PARAMS ) // ()  cFileName --> hMetaFile
#else
   CLIPPER GETENHMETAFILE( void ) // ()  cFileName --> hMetaFile
#endif
{
   _retnl( ( LONG ) GetEnhMetaFile( _parc( 1 ) ) );
}

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER PLAYENHMET( PARAMS ) // ()  hDC, hMetaFile, hWnd, lPrinter --> lSuccess
#else
   CLIPPER PLAYENHMETAFILE( void ) // ()  hDC, hMetaFile, hWnd, lPrinter --> lSuccess
#endif
{
   RECT rect;
   BOOL lRet;

   if( _parl( 4 ) )
   {
      rect.left = 0;
      rect.top  = 0;
      rect.right  = GetDeviceCaps( ( HDC ) _parnl( 1 ), HORZRES );
      rect.bottom = GetDeviceCaps( ( HDC ) _parnl( 1 ), VERTRES );
   }
   else
      GetClientRect ( (HWND)_parnl( 3 ), &rect );

   lRet = ( BOOL ) PlayEnhMetaFile( ( HDC ) _parnl( 1 ), ( HENHMETAFILE ) _parnl( 2 ), &rect );

   if( ! lRet && lRet != ERROR_SUCCESS )
   {
      char sBuffer[ 200 ];

   	  wsprintf( sBuffer, "Error (%d) showing Enhanced Metafile\n\nError description:", GetLastError() );
     	MessageBox( NULL, sBuffer, ( LPSTR ) "Printing EMF", MB_OK | MB_ICONEXCLAMATION );
   }

   _retl( lRet );
}

//----------------------------------------------------------------------------//