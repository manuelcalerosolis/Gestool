// (c) FiveTech 1993-6

#include <WinTen.h>
#include <Windows.h>
#include <ClipApi.h>
#include <dos.h>

typedef struct
{
   WORD DUM;
   LONG lSerie;
   BYTE Volume[ 11 ];
   BYTE fat[ 8 ];
} HDINFO;

typedef struct
{
   DWORD edi, esi, ebp, reserved, ebx, edx, ecx, eax;
   WORD  flags, es, ds, fs, gs, ip, cs, sp, ss;
} REALMODEINT;

//----------------------------------------------------------------//

static BOOL RealModeInt( WORD wIntNo, REALMODEINT * pReal )
{
   asm {
      push  di
      mov   bx, wIntNo
      and   bx, 0x00FF
      mov   cx, 0
      les   di, pReal
      mov   ax, 0x0300
      int   0x31
      pop   di
   }

   return _FLAGS & 1;
}

//----------------------------------------------------------------//

static LONG lSerialHD( void )
{
   DWORD DosHandle = GlobalDosAlloc( sizeof( HDINFO ) );
   REALMODEINT sInt;
   LONG lHD;

   _bset( ( LPBYTE ) &sInt, ( BYTE ) 0, sizeof( REALMODEINT ) );

   sInt.eax = 0x00006900;
   sInt.ebx = 0x00000003;               // C:
   sInt.ds  = HIWORD( DosHandle );
   sInt.edx = 0L;

   RealModeInt( 0x0021, &sInt );

   lHD = ( ( HDINFO * ) MK_FP( LOWORD( DosHandle ), sInt.edx ) )->lSerie;

   GlobalDosFree( LOWORD( DosHandle ) );

   return lHD;
}

//----------------------------------------------------------------//

CLIPPER nSerialHD( PARAMS )
{
   _retnl( lSerialHD() );
}

//----------------------------------------------------------------//

static LONG lSerialA( void )
{
   DWORD DosHandle = GlobalDosAlloc( 512 );
   REALMODEINT sInt;
   LONG lHD;

   _bset( ( LPBYTE ) &sInt, ( BYTE ) 0, sizeof( REALMODEINT ) );

   sInt.eax = 0x00000201;          // AL nº sectors to read
   sInt.ebx = 0x00000000;          // BX offset buffer
   sInt.ecx = 0x00000001;          // CH track, CL sector (1...)
   sInt.edx = 0x00000000;          // DH Head, DL drive
   sInt.es  = HIWORD( DosHandle ); // ES segment buffer

   RealModeInt( 0x0013, &sInt );

   if( sInt.flags & 1 )
      lHD = 0;
   else
      lHD = * ( long * ) MK_FP( LOWORD( DosHandle ), 39 );

   GlobalDosFree( LOWORD( DosHandle ) );

   return lHD;
}

//----------------------------------------------------------------//

CLIPPER nSerialA( PARAMS )
{
   _retnl( lSerialA() );
}

//----------------------------------------------------------------//
