// Win32 ListView Common Control support
// (c) FiveTech Software

#include "FiveWin.ch"
#include "Constant.ch"

#define COLOR_WINDOW       5
#define COLOR_WINDOWTEXT   8
#define COLOR_BTNFACE      15
#define COLOR_BTNSHADOW    16
#define COLOR_BTNHIGHLIGHT 20

#define NM_CLICK           -2

#define LVM_FIRST          4096 // 0x1000
#define LVM_SETIMAGELIST   ( LVM_FIRST + 3 )

#define LVN_FIRST          -100
#define LVN_ITEMCHANGED    ( LVN_FIRST - 1 )
#define LVM_SETICONSPACING ( LVM_FIRST + 53 )

#define LVSIL_NORMAL       0
#define LVSIL_SMALL        1
#define LVSIL_STATE        2

#define WM_ERASEBKGND      20

#ifdef __XPP__
   #define Super ::TControl
   #define New _New
#endif

#ifdef __CLIPPER__
   #define CTRL_CLASS  "SysListView"
#else
   #define CTRL_CLASS  "SysListView32"
#endif

//----------------------------------------------------------------------------//

CLASS TListView FROM TControl

   CLASSDATA aProperties INIT { "nAlign", "nClrText", "nClrPane",;
                                "nOption", "nTop", "nLeft", "nWidth",;
                                "nHeight", "Cargo" }
   DATA  aPrompts
   DATA  bAction
   DATA  bClick
   DATA  nOption

   METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd, bAction ) CONSTRUCTOR

   METHOD Default()

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD EraseBkGnd( hDC ) INLINE 1

   METHOD InsertItem( nImageIndex, cText )   INLINE LVInsertItem( ::hWnd, nImageIndex, cText )

   METHOD InsertItemGroup( nImageIndex, cText, nGroup ) INLINE LVInsertItemGroup( ::hWnd, nImageIndex, cText, nGroup )
   METHOD aAddItemGroup( nImageIndex, cText, nGroup )

   METHOD InsertGroup( nGroupIndex, cText )  INLINE LVInsertGroup( ::hWnd, nGroupIndex, cText )

   // METHOD SetIconSpacing( x, y )             INLINE SendMessage( ::hWnd, LVM_SETICONSPACING, nMakeLong( x, y ) )

   METHOD EnableGroupView() INLINE LVEnableGroupView( ::hWnd )

   METHOD Paint()

   METHOD Notify( nIdCtrl, nPtrNMHDR )

   METHOD SetImageList( oImageList, nType )

   METHOD HScroll( nWParam, nLParam ) VIRTUAL  // required for default behavior
   METHOD VScroll( nWParam, nLParam ) VIRTUAL  // required for default behavior

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, aPrompts, bAction, oWnd, nClrFore,;
            nClrBack, lPixel, lDesign, nWidth, nHeight, cMsg ) CLASS TListView

   DEFAULT nTop     := 0, nLeft := 0,;
           aPrompts := { "&One", "&Two", "T&hree" },;
           oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_BTNFACE ),;
           lPixel   := .f.,;
           lDesign  := .f.,;
           nWidth   := 200, nHeight := 21

   #ifdef __XPP__
      #undef New
   #endif

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE, If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::aPrompts  = aPrompts
   ::bAction   = bAction
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::oFont     = TFont():New( "Ms Sans Serif", 0, -9 )
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack
   ::nOption   = 1

   if ! Empty( oWnd:hWnd )
      ::Create( CTRL_CLASS )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd, bAction ) CLASS TListView

   DEFAULT oWnd   := GetWndDefault()

   ::nId          := nId
   ::oWnd         := oWnd
   ::bAction      := bAction
   ::aPrompts     := {}

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD Default() CLASS TListView

   local n

   for n = 1 to Len( ::aPrompts )
      ::InsertItem( n - 1, ::aPrompts[ n ] )
   next

return Super:Default()

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TListView

   local aInfo := ::DispBegin()

   if ::oBrush != nil
      FillRect( ::hDC, GetClientRect( ::hWnd ), ::oBrush:hBrush )
   else
      CallWindowProc( ::nOldProc, ::hWnd, WM_ERASEBKGND, ::hDC, 0 )
   endif

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

   ::DispEnd( aInfo )

return 1

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TListView

   local nOption
   local nCode       := GetNMHDRCode( nPtrNMHDR )

   do case
      case nCode == NM_CLICK

         nOption     := GetNMListViewItem( nPtrNMHDR ) + 1

         if ::bClick != nil
            ::nOption   := nOption
            Eval( ::bClick, ::nOption, Self )
         endif

      case nCode == LVN_ITEMCHANGED

         nOption     := GetNMListViewItem( nPtrNMHDR ) + 1

         if ::nOption != nOption

            ::nOption := nOption

            if ::bAction != nil
               Eval( ::bAction, ::nOption, Self )
            endif

         endif

   endcase

Return nil

//----------------------------------------------------------------------------//

METHOD SetImageList( oImageList, nType ) CLASS TListView

   local nResult

   DEFAULT nType := LVSIL_NORMAL

   nResult = SendMessage( ::hWnd, LVM_SETIMAGELIST, nType, oImageList:hImageList )

   SysRefresh()

return nResult

//----------------------------------------------------------------------------//

METHOD aAddItemGroup( nImageIndex, cText, nGroup ) CLASS TListView

   aAdd( ::aPrompts, cText )

RETURN ( LVInsertItemGroup( ::hWnd, nImageIndex, cText, nGroup ) )

//----------------------------------------------------------------------------//

#pragma BEGINDUMP

#define NONAMELESSUNION

#ifndef __FLAT__
   #define LPCWSTR LPSTR
   #define LPWSTR  LPSTR
   #define NMHDR   void *
   #define WCHAR   char
#endif

#include <Windows.h>
#include <CommCtrl.h>

void _bset( char * pDest, LONG lValue, LONG lLen );

typedef struct _LVITEM {
  UINT mask;
  int iItem;
  int iSubItem;
  UINT state;
  UINT stateMask;
  LPTSTR pszText;
  int cchTextMax;
  int iImage;
  LPARAM lParam;
  #if (_WIN32_IE >= 0x0300)
    int iIndent;
  #endif
    int iGroupId;
} LVITEMNEW;

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

#define LVIF_GROUPID            0x0100

#define LVM_INSERTGROUP             (LVM_FIRST + 145)
#define ListView_InsertGroup(hwnd, index, pgrp)     SNDMSG((hwnd), LVM_INSERTGROUP, (WPARAM)(index), (LPARAM)(pgrp))

#define LVM_ENABLEGROUPVIEW         (LVM_FIRST + 157)
#define ListView_EnableGroupView(hwnd, fEnable)     SNDMSG((hwnd), LVM_ENABLEGROUPVIEW, (WPARAM)(fEnable), 0)

//-------------------------------------------------------------------------//

LPWSTR AnsiToWide( LPSTR szAnsi )
{
   int nLen = MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szAnsi, -1, NULL, 0 );

   if( nLen )
   {
      LPWSTR szWide = ( LPWSTR ) hb_xgrab( nLen * 2 );

      if( MultiByteToWideChar( CP_ACP, MB_PRECOMPOSED, szAnsi, -1, szWide, nLen ) )
         return szWide;
      else
         hb_xfree( szWide );
   }

   return NULL;
}

//-------------------------------------------------------------------------//

HB_FUNC ( LVINSERTITEMGROUP ) // ( hWnd, nImageListIndex, cText ) --> nIndex
{
   LVITEMNEW lvi;
   HWND hWnd = ( HWND ) hb_parnl( 1 );

   _bset( ( char * ) &lvi, 0, sizeof( lvi ) );

   lvi.mask    = LVIF_TEXT | LVIF_IMAGE | LVIF_GROUPID;
   lvi.iItem   = ListView_GetItemCount( hWnd );
   lvi.iImage  = hb_parnl( 2 );
   lvi.pszText = hb_parc( 3 ) ;
   lvi.iGroupId = hb_parnl( 4 );

   hb_retnl( ListView_InsertItem( hWnd, &lvi ) );

}

//-------------------------------------------------------------------------//
// hwndList is the HWND of the control.

HB_FUNC ( LVINSERTGROUP ) // ( pnmv ) --> nItem
{

    LVGROUP group;

    HWND hWnd = ( HWND ) hb_parnl( 1 );
    LPWSTR pWide = AnsiToWide( hb_parc( 3 ) );

    _bset( ( char * ) &group, 0, sizeof( group ) );

    group.cbSize = sizeof( LVGROUP );
    group.mask = LVGF_HEADER | LVGF_GROUPID | LVGF_SUBSETITEMS;
    group.iGroupId = hb_parnl( 2 );
    group.pszHeader = pWide;

    hb_retnl( ListView_InsertGroup( hWnd, -1, &group) );

    hb_xfree( ( void * ) pWide );

}

//-------------------------------------------------------------------------//

HB_FUNC ( LVENABLEGROUPVIEW ) // ( pnmv ) --> nItem
{

    hb_retnl( ListView_EnableGroupView( ( HWND ) hb_parnl( 1 ), 1 ) );

}

//-------------------------------------------------------------------------//

#pragma ENDDUMP

//-----------------------------------------------------------------------------























































































































































































































































































































































































































































































































































































































