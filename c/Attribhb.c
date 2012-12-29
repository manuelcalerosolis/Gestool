#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

//----------------------------------------------------------------------------//

HB_FUNC(SCREENHORZRES)
{
   HDC hDC;
   long lPixelsPerInch;

   hDC = GetDC( NULL );
   lPixelsPerInch = GetDeviceCaps( hDC, HORZRES );
   ReleaseDC( NULL, hDC );

   _retnl( lPixelsPerInch );
}

//----------------------------------------------------------------------------//