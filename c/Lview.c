#define NONAMELESSUNION

#ifndef __FLAT__
   #define LPCWSTR LPSTR
   #define LPWSTR  LPSTR
   #define NMHDR   void *
   #define WCHAR   char
#endif

#include <Winten.h>
#include <Windows.h>
#include <CommCtrl.h>
#include <ClipApi.h>

typedef struct tagLVGROUP
{
    UINT    cbSize;
    UINT    mask;
    LPWSTR  pszHeader;
    int     cchHeader;

    LPWSTR  pszFooter;
    int     cchFooter;

    int     iGroupId;

    UINT    stateMask;
    UINT    state;
    UINT    uAlign;
#if _WIN32_WINNT >= 0x0600
    LPWSTR  pszSubtitle;
    UINT    cchSubtitle;
    LPWSTR  pszTask;
    UINT    cchTask;
    LPWSTR  pszDescriptionTop;
    UINT    cchDescriptionTop;
    LPWSTR  pszDescriptionBottom;
    UINT    cchDescriptionBottom;
    int     iTitleImage;
    int     iExtendedImage;
    int     iFirstItem;         // Read only
    UINT    cItems;             // Read only
    LPWSTR  pszSubsetTitle;     // NULL if group is not subset
    UINT    cchSubsetTitle;
#endif
} LVGROUP, *PLVGROUP;

#define LVGF_NONE               0x00000000
#define LVGF_HEADER             0x00000001
#define LVGF_FOOTER             0x00000002
#define LVGF_STATE              0x00000004
#define LVGF_ALIGN              0x00000008
#define LVGF_GROUPID            0x00000010

#define LVGF_SUBSETITEMS        0x00010000  // readonly, cItems holds count of items in visible subset, iFirstItem is valid

#define LVM_INSERTGROUP             (LVM_FIRST + 145)
#define ListView_InsertGroup(hwnd, index, pgrp)     SNDMSG((hwnd), LVM_INSERTGROUP, (WPARAM)(index), (LPARAM)(pgrp))

#define LVM_ENABLEGROUPVIEW         (LVM_FIRST + 157)
#define ListView_EnableGroupView(hwnd, fEnable)     SNDMSG((hwnd), LVM_ENABLEGROUPVIEW, (WPARAM)(fEnable), 0)

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER LVINSERTITEM( PARAMS ) // ( hWnd, nImageListIndex, cText ) --> nIndex
#else
   CLIPPER LVINSERTIT( PARAMS ) // ( hWnd, nImageListIndex, cText ) --> nIndex
#endif
{
   LV_ITEM lvi;
   HWND hWnd = ( HWND ) _parnl( 1 );

   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );

   lvi.mask    = LVIF_TEXT | LVIF_IMAGE;
   lvi.iItem   = ListView_GetItemCount( hWnd );
   lvi.iImage  = _parnl( 2 );
   lvi.pszText = _parc( 3 );

   _retnl( ListView_InsertItem( hWnd, &lvi ) );

}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER GETNMLISTVIEWITEM( PARAMS ) // ( pnmv ) --> nItem
#else
   CLIPPER GETNMLISTV( PARAMS ) // ( pnmv ) --> nItem
#endif
{
   _retnl( ( ( NM_LISTVIEW FAR * ) _parnl( 1 ) )->iItem );
}

//-------------------------------------------------------------------------//
// hwndList is the HWND of the control.
#ifdef __HARBOUR__
   CLIPPER LVINSERTGROUP( PARAMS ) // ( pnmv ) --> nItem
#else
   CLIPPER LVINSERTGR( PARAMS ) // ( pnmv ) --> nItem
#endif
{

    LVGROUP group;

    HWND hWnd = ( HWND ) _parnl( 1 );

    _bset( ( char * ) &group, 0, sizeof( group ) );

    // group.cbSize = sizeof(LVGROUP);

    group.mask = LVGF_HEADER | LVGF_GROUPID;
    group.iGroupId = _parnl( 2 );
    group.pszHeader = "hola"; //_parc( 3 );

    _retnl( ListView_InsertGroup( hWnd, -1, &group) );

}

//-------------------------------------------------------------------------//

#ifdef __HARBOUR__
   CLIPPER LVENABLEGROUPVIEW( PARAMS ) // ( pnmv ) --> nItem
#else
   CLIPPER LVENABLEGR( PARAMS ) // ( pnmv ) --> nItem
#endif
{
    _retnl( ListView_GetCountPerPage( ( HWND ) _parnl(1) ) );

}

//-------------------------------------------------------------------------//