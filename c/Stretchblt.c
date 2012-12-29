#include <Windows.h>

extern void _retl( short );
extern long  _parnl( short, ... );

//----------------------------------------------------------------------------//

#undef STRETCHBLT

void pascal STRETCHBLT( void )
{
   _retl( StretchBlt( ( HDC ) _parnl(1),_parnl(2),_parnl(3),_parnl(4),_parnl(5),
                     ( HDC ) _parnl(6),_parnl(7),_parnl(8),_parnl(9),_parnl(10),
                     _parnl(11)));

}

//----------------------------------------------------------------------------//
