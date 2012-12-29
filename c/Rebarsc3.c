#include <Windows.h>
#include <CommCtrl.h>
#include "Extend.api"

//----------------------------------------------------------------------------//

#define ICC_COOL_CLASSES                                             0x00000400

#define RBHT_NOWHERE                                                     0x0001
#define RBHT_CAPTION                                                     0x0002
#define RBHT_CLIENT                                                      0x0003
#define RBHT_GRABBER                                                     0x0004
#define RBHT_CHEVRON                                                     0x0008

#define RBN_FIRST                                                 ( 0U - 831U )
#define RBN_HEIGHTCHANGE                                      ( RBN_FIRST - 0 )
#define RBN_GETOBJECT                                         ( RBN_FIRST - 1 )
#define RBN_LAYOUTCHANGED                                     ( RBN_FIRST - 2 )
#define RBN_AUTOSIZE                                          ( RBN_FIRST - 3 )
#define RBN_BEGINDRAG                                         ( RBN_FIRST - 4 )
#define RBN_ENDDRAG                                           ( RBN_FIRST - 5 )
#define RBN_DELETINGBAND                                      ( RBN_FIRST - 6 )
#define RBN_DELETEDBAND                                       ( RBN_FIRST - 7 )
#define RBN_CHILDSIZE                                         ( RBN_FIRST - 8 )

#define RBS_VARHEIGHT                                                    0x0200
#define RBS_BANDBORDERS                                                  0x0400
#define RBS_AUTOSIZE                                                     0x2000
#define RBS_VERTICALGRIPPER                                              0x4000

#define RB_INSERTBAND                                           ( WM_USER + 1 )
#define RB_DELETEBAND                                           ( WM_USER + 2 )
#define RB_SETBARINFO                                           ( WM_USER + 4 )
#define RB_GETBANDINFO                                          ( WM_USER + 5 )
#define RB_SETBANDINFO                                          ( WM_USER + 6 )
#define RB_HITTEST                                              ( WM_USER + 8 )
#define RB_GETRECT                                              ( WM_USER + 9 )
#define RB_GETBANDCOUNT                                        ( WM_USER + 12 )
#define RB_GETROWCOUNT                                         ( WM_USER + 13 )
#define RB_GETROWHEIGHT                                        ( WM_USER + 14 )
#define RB_GETBARHEIGHT                                        ( WM_USER + 27 )

#define RBBIM_STYLE                                                  0x00000001
#define RBBIM_COLORS                                                 0x00000002
#define RBBIM_TEXT                                                   0x00000004
#define RBBIM_IMAGE                                                  0x00000008
#define RBBIM_CHILD                                                  0x00000010
#define RBBIM_CHILDSIZE                                              0x00000020
#define RBBIM_SIZE                                                   0x00000040
#define RBBIM_BACKGROUND                                             0x00000080
#define RBBIM_ID                                                     0x00000100
#define RBBIM_IDEALSIZE                                              0x00000200
#define RBBIM_LPARAM                                                 0x00000400
#define RBBIM_HEADERSIZE                                             0x00000800

#define RBBS_BREAK                                                   0x00000001
#define RBBS_FIXEDSIZE                                               0x00000002
#define RBBS_CHILDEDGE                                               0x00000004
#define RBBS_HIDDEN                                                  0x00000008
#define RBBS_NOVERT                                                  0x00000010
#define RBBS_FIXEDBMP                                                0x00000020
#define RBBS_VARIABLEHEIGHT                                          0x00000040
#define RBBS_GRIPPERALWAYS                                           0x00000080
#define RBBS_NOGRIPPER                                               0x00000100
#define RBBS_USECHEVRON                                              0x00000200
#define RBBS_HIDETITLE                                               0x00000400

/*
 * Tipos de datos.
 */
typedef struct st_REBARINFO
{
   UINT cbSize;
   UINT fMask;
   HANDLE himl;
} REBARINFO;

typedef struct st_REBARBANDINFO
{
   UINT cbSize;
   UINT fMask;
   UINT fStyle;
   COLORREF clrFore;
   COLORREF clrBack;
   LPSTR lpText;
   UINT cch;
   int iImage;
   HWND hwndChild;
   UINT cxMinChild;
   UINT cyMinChild;
   UINT cx;
   HBITMAP hbmBack;
   UINT wID;
   UINT cyChild;
   UINT cyMaxChild;
   UINT cyIntegral;
   UINT cxIdeal;
   LPARAM lParam;
   UINT cxHeader;
} REBARBANDINFO;

typedef struct st_RBHITTESTINFO
{
   POINT pt;
   UINT flags;
   int iBand;
} RBHITTESTINFO;

typedef struct st_NMREBAR
{
   NMHDR hdr;
   DWORD dwMask;
   UINT uBand;
   UINT fStyle;
   UINT wID;
   LPARAM lParam;
} NMREBAR;

typedef struct st_INITCOMMONCONTROLSEX
{
   DWORD dwSize;
   DWORD dwICC;
} INITCOMMONCONTROLSEX;

//----------------------------------------------------------------------------//

extern void _bset( void *, BYTE, ULONG );

//----------------------------------------------------------------------------//

#ifdef __XPP__
   CLIPPER SETREBARIN( PARAMS )
#else
   CLIPPER SETREBARINFO()
#endif
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

#ifdef __XPP__
   CLIPPER RBINSERTBA( PARAMS )
#else
   CLIPPER RBINSERTBAND() // hReBar, hControl, cText
#endif
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