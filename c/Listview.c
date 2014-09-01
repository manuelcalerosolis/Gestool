#define _WIN32_IE    0x0560
#define _WIN32_WINNT 0x0600

#include <Windows.h>
#include <CommCtrl.h>
#include <hbapi.h>

#ifndef LVGF_SUBSETITEMS
   #define LVGF_SUBSETITEMS  0x00010000
   #define LVGS_SELECTED     0x00000020
   #define LVGS_COLLAPSIBLE  0x00000008
#endif

#ifndef LVGF_NONE   
   #define LVGF_NONE           0x00000000
   #define LVGF_HEADER         0x00000001
   #define LVGF_FOOTER         0x00000002
   #define LVGF_STATE          0x00000004
   #define LVGF_ALIGN          0x00000008
   #define LVGF_GROUPID        0x00000010

   #define LVGS_NORMAL         0x00000000
   #define LVGS_COLLAPSED      0x00000001
   #define LVGS_HIDDEN         0x00000002

   #define LVGA_HEADER_LEFT    0x00000001
   #define LVGA_HEADER_CENTER  0x00000002
   #define LVGA_HEADER_RIGHT   0x00000004  // Don't forget to validate exclusivity
   #define LVGA_FOOTER_LEFT    0x00000008
   #define LVGA_FOOTER_CENTER  0x00000010
   #define LVGA_FOOTER_RIGHT   0x00000020  // Don't forget to validate exclusivity

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
  } LVGROUP, *PLVGROUP;

#endif   

#ifndef LVIF_GROUPID 
   #define LVIF_GROUPID         0x0100
#endif
#ifndef LVIF_COLUMNS
   #define LVIF_COLUMNS         0x0200
#endif
#ifndef LV_ITEM 
   #define LV_ITEM LVITEM
#endif

LPWSTR AnsiToWide( LPSTR szAnsi );

//-------------------------------------------------------------------------//

HB_FUNC( LVINSERTITEM ) // ( hWnd, nImageListIndex, cText, nGroup ) --> nItem
{
   LVITEM lvi;
   #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   memset( ( void * ) &lvi, 0, sizeof( LV_ITEM ) );

   lvi.mask     = LVIF_TEXT | LVIF_IMAGE | LVIF_GROUPID;
   lvi.iItem    = ListView_GetItemCount( hWnd );
   lvi.iImage   = hb_parnl( 2 );
   lvi.pszText  = ( LPTSTR ) hb_parc( 3 );
   lvi.iGroupId = hb_parnl( 4 );

   ListView_InsertItem( hWnd, &lvi );
   hb_retnl( GetLastError() );
}

//-------------------------------------------------------------------------//

HB_FUNC( GETNMLISTVIEWITEM ) // ( pnmv ) --> nItem
{
	 #ifndef _WIN64
      hb_retnl( ( ( NM_LISTVIEW FAR * ) hb_parnl( 1 ) )->iItem );
   #else   
      hb_retnl( ( ( NM_LISTVIEW FAR * ) hb_parnll( 1 ) )->iItem );
   #endif
}

//-------------------------------------------------------------------------//

HB_FUNC( LVINSERTGROUP )
{
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   LVGROUP grp;
   LPWSTR pWide = ( LPWSTR ) AnsiToWide( ( char * ) hb_parc( 2 ) );
   
   memset( &grp, 0, sizeof( LVGROUP ) );
   
   grp.cbSize = sizeof( grp );
   grp.iGroupId  = hb_parnl( 3 );
   grp.pszHeader = pWide;
   grp.cchHeader = wcslen( grp.pszHeader );
   grp.mask = LVGF_HEADER | LVGF_GROUPID | LVGF_FOOTER;
   
   ListView_InsertGroup( hWnd, -1, &grp );
   hb_xfree( pWide );   	
}	

//-------------------------------------------------------------------------//

HB_FUNC( LVINSERTITEMGROUP ) // ( hWnd, nImageListIndex, cText ) --> nItem
{
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   LVITEM lvi;

   memset( ( char * ) &lvi, 0, sizeof( LV_ITEM ) );

   lvi.mask       = LVIF_TEXT | LVIF_IMAGE | LVIF_GROUPID;
   lvi.iItem      = ListView_GetItemCount( hWnd );
   lvi.iImage     = hb_parnl( 2 );
   lvi.pszText    = ( LPTSTR ) hb_parc( 3 );
   lvi.iGroupId   = hb_parnl( 4 );

   hb_retnl( ListView_InsertItem( hWnd, &lvi ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVINSERTINLIST )
{
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   LVITEM lvi;
   int nGroup = hb_parnl( 4 );

   memset( ( char * ) &lvi, 0, sizeof( LV_ITEM ) );

   lvi.mask          = LVIF_IMAGE | LVIF_TEXT | LVIF_GROUPID;
   lvi.iItem         = ListView_GetItemCount( hWnd );
   lvi.iImage        = hb_parnl( 2 );
   lvi.pszText       = ( LPTSTR ) hb_parc( 3 );

   if( nGroup )
   {
      lvi.mask       |= LVIF_GROUPID;
      lvi.iGroupId   = nGroup;
   }

   hb_retnl( ListView_InsertItem( hWnd, &lvi ) );
}

//-------------------------------------------------------------------------//
// hwndList is the HWND of the control.

HB_FUNC( LVINSERTGROUPINLIST ) // ( pnmv ) --> nItem
{
   LVGROUP group;
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   LPWSTR pWide      = AnsiToWide( ( LPTSTR ) hb_parc( 3 ) );
   int nState        = hb_parnl( 4 );

   memset( ( char * ) &group, 0, sizeof( LVGROUP ) );

   group.cbSize      = sizeof( LVGROUP );
   group.iGroupId    = hb_parnl( 2 );
   group.pszHeader   = pWide;
   group.cchHeader   = wcslen( group.pszHeader );

   switch( nState )
   {
      case 0 :
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS;
         group.state = LVGS_SELECTED | LVGS_COLLAPSIBLE | LVGS_NORMAL;
         break;

      case 1 :
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS;
         group.state = LVGS_SELECTED | LVGS_COLLAPSIBLE | LVGS_COLLAPSED;
         break;

      case 2 :
         group.mask  = LVGF_STATE;
         group.state = LVGS_SELECTED | LVGS_HIDDEN;
         break;
    }

    hb_retnl( ListView_InsertGroup( hWnd, -1, &group) );
    hb_xfree( ( void * ) pWide );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVGROUPSETSTATE )
{
   LVGROUP group;
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   int nIndex   = hb_parni( 2 );
   int nState   = hb_parni( 3 );

   memset( ( char * ) &group, 0, sizeof( LVGROUP ) );

   group.cbSize      = sizeof( LVGROUP );
   group.iGroupId    = nIndex;

   switch( nState )
   {
      case LVGS_NORMAL   :
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         group.state = LVGS_SELECTED | LVGS_NORMAL;
         break;

      case LVGS_COLLAPSED:
         group.mask  = LVGF_STATE | LVGF_GROUPID | LVGF_HEADER | LVGF_SUBSETITEMS ;
         group.state = LVGS_SELECTED | LVGS_COLLAPSIBLE | LVGS_COLLAPSED;
         break;

      case LVGS_HIDDEN   :
         group.mask  = LVGF_STATE;
         group.state = LVGS_SELECTED | LVGS_HIDDEN;
         break;
   }

   ListView_SetGroupInfo( hWnd, nIndex, ( LPARAM ) &group );

   InvalidateRect( hWnd, NULL, FALSE );

   hb_retni( nState );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVENABLEGROUPVIEW ) // ( pnmv ) --> nItem
{
	 #ifndef _WIN64
      hb_retnl( ListView_EnableGroupView( ( HWND ) hb_parnl( 1 ), 1 ) );
   #else   
      hb_retnl( ListView_EnableGroupView( ( HWND ) hb_parnll( 1 ), 1 ) );
   #endif
}

//-------------------------------------------------------------------------//

HB_FUNC( LVFINDITEM ) // ( hWnd, nImageListIndex, cText ) --> nItem
{
   LVFINDINFO lvi;

	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   memset( ( void * ) &lvi, 0, sizeof( LVFINDINFO ) );

   lvi.flags   = LVFI_PARTIAL;
   lvi.psz     = ( LPTSTR ) hb_parc( 2 );

   hb_retnl( ListView_FindItem( hWnd, -1, &lvi ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVSETITEMSELECT )
{
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif

   ListView_EnsureVisible( hWnd, hb_parnl( 2 ), FALSE );
   ListView_SetItemState( hWnd, -1, 0, LVIS_SELECTED );
   ListView_SetItemState( hWnd, hb_parnl( 2 ), ( LVIS_SELECTED | LVIS_FOCUSED ), 
                          ( LVIS_SELECTED | LVIS_FOCUSED ) );
}

//-------------------------------------------------------------------------//

HB_FUNC( LVSETGROUP )
{
	 #ifndef _WIN64
      HWND hWnd = ( HWND ) hb_parnl( 1 );
   #else   
      HWND hWnd = ( HWND ) hb_parnll( 1 );
   #endif
   int nId     = hb_parnl( 2 );
   int nGroup  = hb_parnl( 3 );

   LVITEM lvi;
   memset( ( char * ) &lvi, 0, sizeof( lvi ) );
   lvi.iItem      = nId;
   lvi.mask       = LVIF_GROUPID | LVIF_COLUMNS;
   lvi.iGroupId   = nGroup;
   ListView_SetItem( hWnd, ( LPARAM ) &lvi );

   hb_retnl( nGroup );
}

//-------------------------------------------------------------------------//