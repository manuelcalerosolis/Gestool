#ifndef _FWHARB_H
#define _FWHARB_H

#ifndef HB_OS_WIN_32_USED
   #define HB_OS_WIN_32_USED
#endif

#ifndef HB_OS_WIN_USED
   #define HB_OS_WIN_USED
#endif

#ifndef HB_OS_WIN_32  
   #define HB_OS_WIN_32
#endif   

#if defined(__HARBOUR__) > 0x020100
#include <hbapi.h>
#define ISLOG HB_ISLOG
#else
#include <extend.h>
#endif

#define ISLOGICAL    ISLOG
#define PCLIPVAR     PHB_ITEM
#define LPCLIPSYMBOL PHB_DYNS
#define PCLIPSYMBOL  PHB_DYNS

#define __hInstance hb_hInstance

void _bcopy( char * pDest, char * pOrigin, LONG lSize );
void _bset( char * pDest, LONG lValue, LONG lLen );
void _strcpy( char * pDest, char * pOrigin );

#undef PCOUNT
#define PCOUNT()  hb_pcount()

#define _xgrab          hb_xgrab
#define _xrealloc       hb_xrealloc
#define _xfree          hb_xfree

#define _pcount         hb_pcount

// #define _tcreat         hb_fsCreate
// #define _tunlink        hb_fsDelete
// #define _topen          hb_fsOpen
#define _tclose         hb_fsClose
#define _tread          hb_fsRead
#define _twrite         hb_fsWrite
#define _tlseek         hb_fsSeek
// #define _trename        hb_fsRename
#define _tlock          hb_fsLock
#define _tcommit        hb_fsCommit

#endif
