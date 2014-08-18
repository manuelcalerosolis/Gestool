#include <Windows.h>
#include <commctrl.h>
#include <hbapi.h>

//-------------------------------------------------------------------------//

HB_FUNC( GETNMHDRCODE ) // ( nPtrNMHDR ) --> nCode
{
   #ifndef _WIN64
      NMHDR * pNMHDR = ( NMHDR * ) hb_parnl( 1 );
   #else   
      NMHDR * pNMHDR = ( NMHDR * ) hb_parnll( 1 );
   #endif

   hb_retnl( pNMHDR->code );
}

//-------------------------------------------------------------------------//

HB_FUNC( GETNMHDRHWNDFROM ) // ( nPtrNMHDR ) --> nHWndFrom
{
   #ifndef _WIN64
      NMHDR * pNMHDR = ( NMHDR * ) hb_parnl( 1 );

      hb_retnl( ( LONG ) pNMHDR->hwndFrom );
   #else
      NMHDR * pNMHDR = ( NMHDR * ) hb_parnll( 1 );

      hb_retnll( ( LONGLONG ) pNMHDR->hwndFrom );
   #endif
}

//-------------------------------------------------------------------------//

HB_FUNC( GETNMHDRIDFROM ) // ( nPtrNMHDR ) --> nIdFrom
{
	 #ifndef _WIN64
      NMHDR * pNMHDR = ( NMHDR * ) hb_parnl( 1 );
   #else   
      NMHDR * pNMHDR = ( NMHDR * ) hb_parnll( 1 );
   #endif
   
   hb_retnl( pNMHDR->idFrom );
}

//-------------------------------------------------------------------------//

HB_FUNC( NMTREEVIEWACTION )
{
	 #ifndef _WIN64
      NMTREEVIEW * pNMHDR = ( NMTREEVIEW * ) hb_parnl( 1 );
   #else   
      NMTREEVIEW * pNMHDR = ( NMTREEVIEW * ) hb_parnll( 1 );
   #endif
   
   hb_retnl( pNMHDR->action );
}

//-------------------------------------------------------------------------//	

HB_FUNC( NMTREEVIEWITEMNEW )
{
	 #ifndef _WIN64
      NMTREEVIEW * pNMHDR = ( NMTREEVIEW * ) hb_parnl( 1 );
   #else   
      NMTREEVIEW * pNMHDR = ( NMTREEVIEW * ) hb_parnll( 1 );
   #endif
   
   #ifndef _WIN64
      hb_retnl( ( LONG ) pNMHDR->itemNew.hItem );
   #else
      hb_retnll( ( LONGLONG ) pNMHDR->itemNew.hItem );
   #endif
}

//-------------------------------------------------------------------------//