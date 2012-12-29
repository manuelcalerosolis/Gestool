#include <Windows.h>
#include "Extend.api"

#define FC_NORMAL       0
#define FC_READONLY     1
#define FC_HIDDEN       2
#define FC_SYSTEM       4


// BOOL WriteFileEx( HANDLE, LPCVOID, DWORD, LPOVERLAPPED, LPOVERLAPPED_COMPLETION_ROUTINE );

//----------------------------------------------------------------------------//

CLIPPER SETATTRIBUTES( void )
{
    DWORD dwFlags=FILE_ATTRIBUTE_ARCHIVE;
    DWORD dwLastError=ERROR_SUCCESS;
    BOOL lSuccess;
    LPCTSTR cFile=_parc( 1 );
    int iAttr=_parni( 2 );

    if( iAttr & FC_READONLY )
       dwFlags |= FILE_ATTRIBUTE_READONLY;

    if( iAttr & FC_HIDDEN )
       dwFlags |= FILE_ATTRIBUTE_HIDDEN;

    if( iAttr & FC_SYSTEM )
       dwFlags |= FILE_ATTRIBUTE_SYSTEM;

    if( iAttr & FC_NORMAL )
       dwFlags |= FILE_ATTRIBUTE_NORMAL;

    lSuccess=SetFileAttributes( cFile, dwFlags );

    if ( lSuccess )
    {
       _retni( dwLastError );
    }
    else
    {
       dwLastError=GetLastError();

       switch ( dwLastError )
       {
          case ERROR_FILE_NOT_FOUND :
             _retni( -2 );
             break;
          case ERROR_PATH_NOT_FOUND :
             _retni( -3 );
             break;
          case ERROR_ACCESS_DENIED:
             _retni( -5 );
             break;
          default:
             _retni( -1 );
       }
    }
}

//----------------------------------------------------------------------------//

CLIPPER SCREENHORZRES( void )
{
   HDC hDC;
   long lPixelsPerInch;

   hDC = GetDC( NULL );
   lPixelsPerInch = GetDeviceCaps( hDC, HORZRES );
   ReleaseDC( NULL, hDC );

   _retnl( lPixelsPerInch );
}

//----------------------------------------------------------------------------//