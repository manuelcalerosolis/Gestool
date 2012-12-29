#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>
#include <CommCtrl.h>

//----------------------------------------------------------------------------//

HB_FUNC(SETREBARINFO)
{
   HWND hReBar = ( HWND ) _parnl( 1 );
   REBARINFO ri;

   _bset( ( char * ) &ri, 0, sizeof( REBARINFO ) );
   ri.cbSize = sizeof( REBARINFO );
   ri.fMask = 0;
   ri.himl = NULL;
   SendMessage( hReBar, RB_SETBARINFO, 0, ( LPARAM )&ri );
}

//----------------------------------------------------------------------------//

HB_FUNC(RBINSERTBAND) // hReBar, hControl, cText
{
   HWND hReBar = ( HWND ) _parnl( 1 );
   HWND hControl = ( HWND ) _parnl( 2 );
   REBARBANDINFO rbinfo;
   RECT rct;

   GetWindowRect( hControl, &rct );

   _bset( ( char * ) &rbinfo, 0, sizeof( REBARBANDINFO ) );
   rbinfo.cbSize = sizeof( REBARBANDINFO );
   rbinfo.fMask = RBBIM_TEXT | RBBIM_STYLE | RBBIM_CHILD | RBBIM_CHILDSIZE | RBBIM_SIZE;
   rbinfo.fStyle = RBBS_CHILDEDGE | RBBS_BREAK;
   rbinfo.lpText = _parc( 3 );
   rbinfo.hwndChild = hControl;
   rbinfo.cxMinChild = rct.right - rct.left;
   rbinfo.cyMinChild = rct.bottom - rct.top;
   rbinfo.cx = rct.right - rct.left;

   SendMessage( hReBar, RB_INSERTBAND, ( WPARAM ) -1, ( LPARAM ) &rbinfo );
}

//----------------------------------------------------------------------------//