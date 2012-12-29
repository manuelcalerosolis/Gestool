#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400

#include <windows.h>
#include "item.api"
#include "hbapi.h"
#include "hbvm.h"
#include "hbstack.h"

extern PHB_ITEM Rect2Array( RECT *rc  );
extern BOOL Array2Rect(PHB_ITEM aRect, RECT *rc );
extern PHB_ITEM Point2Array( POINT *pt  );
extern BOOL Array2Point(PHB_ITEM aPoint, POINT *pt );

int CALLBACK GenericCallblockProc( LONG param1, LONG param2, int wParam, LPARAM lParam );

//-----------------------------------------------------------------------------
// WINGDIAPI int WINAPI AddFontResourceA(IN LPCSTR);

HB_FUNC( ADDFONTRESOURCE )
{
   hb_retni( AddFontResource( (LPCSTR) hb_parc( 1 ) ) ) ;
}

//-----------------------------------------------------------------------------
// WINGDIAPI HFONT WINAPI CreateFontIndirectA( IN CONST LOGFONTA *);

HB_FUNC( CREATEFONTINDIRECT )
{
   LOGFONT *lf = (LOGFONT * ) hb_param( 1, HB_IT_STRING )->item.asString.value;

   hb_retnl( (LONG) CreateFontIndirect( lf ) ) ;
}

//-----------------------------------------------------------------------------
// WINGDIAPI int WINAPI EnumFontsA( IN HDC, IN LPCSTR, IN FONTENUMPROCA, IN LPARAM);

// syntax
// EnumFonts(hDC,cTypeFace,codeBlock) -> HBFuncLastReturnValue or NIL if problem

HB_FUNC( ENUMFONTS )
{
   HDC hDC;
   LPARAM lParam ;

   if ( ISBLOCK( 1 ) )
   {
     lParam = (LPARAM) (PHB_ITEM ) hb_param( 1, HB_IT_BLOCK ) ;

     hDC = GetDC( NULL );
     hb_retni( EnumFonts( hDC,
                         NULL,
                         (FONTENUMPROC) GenericCallblockProc  ,
                         lParam
                         ) ) ;
     ReleaseDC( NULL, hDC );

   }
   else
     OutputDebugString("EnumFonts(): No codeblock");

}

//-----------------------------------------------------------------------------
// using a codeblock

int CALLBACK GenericCallblockProc( LONG param1, LONG param2, int wParam, LPARAM lParam )
{
   PHB_ITEM pItem ;
   long int res   ;
   static PHB_DYNS s_pEval = NULL;

   if( s_pEval == NULL )
   {
      s_pEval = hb_dynsymFind( "__EVAL" );
   }

   pItem = (PHB_ITEM ) lParam ;

   if ( pItem )
   {
      hb_vmPushSymbol( s_pEval->pSymbol );
      hb_vmPush(pItem);

      hb_vmPushLong( (LONG ) param1 );
      hb_vmPushLong( (LONG ) param2 );
      hb_vmPushLong( (LONG ) wParam );
      hb_vmPushLong( (LONG ) lParam );

      hb_vmSend( 4 );
      res = hb_itemGetNL( (PHB_ITEM) hb_param( -1, HB_IT_ANY ) );

      return res;
   }
   else // shouldn't happen
   {
      return( 0 );
   }
}
