#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>

#define SEGMENT 4096

extern HANDLE __hInstance;

static far GLOBALHANDLE ghEditDS = 0;
static far LPVOID lpPtr = 0;

//----------------------------------------------------------------------------//

CLIPPER MGETCREATE( PARAMS ) // ( cClassName, cTitle, nStyle, nLeft, nTop,
                             //   nWidth, nHeight, hWndOwner, hMenu,
                             //   cExtraData, nExStyle ) --> hWnd
{

   DWORD dwStyle   = ( DWORD ) _parnl( 3 );
   DWORD dwExStyle = ( DWORD ) _parnl( 11 );

   #ifndef __FLAT__
   if( ! ghEditDS )
   {
      if( ghEditDS = GlobalAlloc( GMEM_DDESHARE | GMEM_MOVEABLE | GMEM_ZEROINIT, SEGMENT ) )
      {
         lpPtr = GlobalLock( ghEditDS );
         LocalInit( HIWORD( (LONG) lpPtr ), 0,
                    ( WORD )( GlobalSize( ghEditDS ) - 16 ) );
         UnlockSegment( HIWORD( ( LONG ) lpPtr ) );
      }
   }
   _stornl( ( LONG ) ( IF( ghEditDS, ghEditDS, 0 ) ), 10 );    // lpPtr
   #endif

   _retnl( ( LONG ) CreateWindowEx( dwExStyle,
                         _parc( 1 ),      // Class
                         _parc( 2 ),      // Title
                         dwStyle,         // Style
                         _parni( 4 ),     // Left
                         _parni( 5 ),     // Top
                         _parni( 6 ),     // Width
                         _parni( 7 ),     // Height
                         ( HWND ) _parnl( 8 ),     // Parent
                         ( HMENU ) _parnl( 9 ),     // Menu
                         ( HINSTANCE ) IF( ghEditDS,
                         HIWORD( ( LONG ) lpPtr ), __hInstance ),
   ( LPVOID ) ( ( PCOUNT() > 9) ? _parc( 10 ): 0 ) ) ); // Address Window-Creation-Data
}

//----------------------------------------------------------------------------//