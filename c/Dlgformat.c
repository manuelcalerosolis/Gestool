#include <windows.h>
#include <clipapi.h>

#define SHFD_FORMAT_QUICK     0
#define SHFD_FORMAT_FULL      1
#define SHFD_FORMAT_SYSONLY   2

#define SHFMT_ERROR           0xFFFFFFFF
#define SHFMT_CANCEL          0xFFFFFFFE
#define SHFMT_NOFORMAT        0xFFFFFFFD

#define SHFMT_ID_DEFAULT      0xFFFF
#define SHFMT_ID_720          0x0005
#define SHFMT_ID_1440         0x0006

//--------------------------------------------------------------------------

typedef DWORD (WINAPI * SHFORMAT)( HWND, WORD, WORD, WORD );

CLIPPER TDLGFORMAT_ACTIVATE( void )
{
   HMODULE hModule = LoadLibrary( "shell32.dll" );
   BOOL bSuccess = FALSE;

   if( hModule )
   {
      PCLIPVAR Self = _param( 1, SOBJECT ); //__lBase+14;
      PCLIPVAR oParent;
      HWND hwndParent;
      char * cDrive = ObjGetC( Self, "cDrive" );
      WORD wDrive = * cDrive - (char) 'A';
      WORD wFlags = ObjGetNL( Self, "nFlags" );
      SHFORMAT fnFormat = (SHFORMAT) GetProcAddress( hModule, "SHFormatDrive" );
      DWORD dwResult;

      if( fnFormat )
      {
         oParent = ObjGetItem( Self, "oParent" );
         hwndParent = GetHandleOf( oParent );
         dwResult = fnFormat( hwndParent, wDrive, 0xFFFF, wFlags );

         if( IsWin9X() )
            bSuccess = ( dwResult == 6 );
         else if( IsWinNT() )
            bSuccess = ( dwResult == 0 );

         if( ! bSuccess )
            hb_objSendMsg( Self, "_nError", 1, hb_itemPutNL( NULL, dwResult ) );
      }

      FreeLibrary( hModule );
   }

   hb_retl( bSuccess );
}

//--------------------------------------------------------------------------