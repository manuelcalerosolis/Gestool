// Win32 common controls RebarWindow

#include "FiveWin.Ch"

#define ICC_COOL_CLASSES      1024 // 0x0400 rebar (coolbar) control
#define ICC_BAR_CLASSES          4 // toolbar, statusbar, trackbar, tooltips

#define RBS_TOOLTIPS           256
#define RBS_VARHEIGHT          512 // 0x0200
#define RBS_BANDBORDERS       1024 // 0x0400
#define RBS_FIXEDORDER        2048
#define RBS_REGISTERDROP      4096
#define RBS_AUTOSIZE          8192
#define RBS_VERTICALGRIPPER  16384 // 0x4000
#define RBS_DBLCLKTOGGLE     32768

#define RB_DELETEBAND            (WM_USER +  2)
#define RB_MINIMIZEBAND          (WM_USER + 30)
#define RB_MAXIMIZEBAND          (WM_USER + 31)

#define RBN_FIRST             -831 // rebar
#define RBN_LAST              -859
#define RBN_BEGINDRAG            (RBN_FIRST - 4)
#define RBN_ENDDRAG              (RBN_FIRST - 5)

#define CCS_NOMOVEY              2
#define CCS_NORESIZE             4
#define CCS_NOPARENTALIGN        8
#define CCS_NODIVIDER           40
#define CCS_VERT                80

// Warning: Don't implement double buffer technique here

//----------------------------------------------------------------------------//

CLASS TReBar FROM TControl

   METHOD New( oWnd ) CONSTRUCTOR

   METHOD Command( nWParam, nLParam )

   METHOD InsertBand( oControl, cText )   INLINE RBInsertBand( ::hWnd, oControl:hWnd, cText )

   METHOD DeleteBand( oControl, cText )   INLINE SendMessage( ::hWnd, RB_DELETEBAND, 0, 0 )

   METHOD MinimizeBand( nBand )           INLINE SendMessage( ::hWnd, RB_MINIMIZEBAND, nBand - 1, 0 )

   METHOD MaximizeBand( nBand, nIdeal )   INLINE SendMessage( ::hWnd, RB_MAXIMIZEBAND, nBand - 1, nIdeal )

   METHOD MouseMove() VIRTUAL

   METHOD Notify( nIdCtrl, nPtrNMHDR )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TReBar

   DEFAULT oWnd := GetWndDefault()

   ::oWnd   = oWnd
   ::nId    = ::GetNewId()
   ::lDrag  = .f.
   ::nStyle = nOR(   WS_CHILD, WS_VISIBLE, WS_CLIPCHILDREN,;
                     RBS_BANDBORDERS, RBS_VERTICALGRIPPER, RBS_FIXEDORDER, RBS_AUTOSIZE,;
                     CCS_NODIVIDER, CCS_NOPARENTALIGN, CCS_NOMOVEY, CCS_VERT )

   ::oWnd:oTop = Self

   #ifndef __XPP__
      InitCommonControlsEx( nOr( ICC_COOL_CLASSES, ICC_BAR_CLASSES ) )
   #else
      InitCCEx( ICC_COOL_CLASSES )
   #endif

   if ! Empty( oWnd:hWnd )
      ::Create( "ReBarWindow32" )
      SetReBarInfo( ::hWnd )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TReBar

   local nCode := GetNMHDRCode( nPtrNMHDR )
   local nId   := GetNMHDRIdFrom( nPtrNMHDR )

      do case
         case nCode == RBN_BEGINDRAG
            ::oWnd:Resize()
            if ::oWnd:oWndClient:GetActive() != nil
               ::oWnd:oWndClient:GetActive():Maximize()
            end if

         case nCode == RBN_ENDDRAG
            ::oWnd:Resize()
            if ::oWnd:oWndClient:GetActive() != nil
               ::oWnd:oWndClient:GetActive():Maximize()
            end if

      end case

return ( nil )

//----------------------------------------------------------------------------//

METHOD Command( nWParam, nLParam )

Return ( nil )