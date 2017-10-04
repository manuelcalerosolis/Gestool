// Win32 common controls RebarWindow

#include "FiveWin.ch"

#define ICC_COOL_CLASSES      1024 // 0x0400 rebar (coolbar) control

#define RB_DELETEBAND            (WM_USER +  2)
#define RB_MINIMIZEBAND          (WM_USER + 30)
#define RB_MAXIMIZEBAND          (WM_USER + 31)
#define RB_SETBKCOLOR            (WM_USER + 19) // sets the default BK color

#define RBS_VARHEIGHT          512 // 0x0200
#define RBS_BANDBORDERS       1024 // 0x0400
#define RBS_VERTICALGRIPPER  16384 // 0x4000

#define CCS_NOPARENTALIGN        8
#define CCS_NOMOVEY              2

#define RBN_FIRST             -831 // rebar
#define RBN_LAST              -859
#define RBN_BEGINDRAG            (RBN_FIRST - 4)
#define RBN_ENDDRAG              (RBN_FIRST - 5)

#ifdef __XPP__
   #define Super ::TControl
#endif

// Warning: Don't implement double buffer technique here

//----------------------------------------------------------------------------//

CLASS TReBar FROM TControl

   METHOD New( oWnd ) CONSTRUCTOR

   METHOD Command( nWParam, nLParam )

   METHOD InsertBand( oControl, cText )   INLINE RBInsertBand( ::hWnd, oControl:hWnd, cText )

   METHOD DeleteBand( oControl, cText )   INLINE SendMessage( ::hWnd, RB_DELETEBAND, 0, 0 )

   METHOD MinimizeBand( nBand )           INLINE SendMessage( ::hWnd, RB_MINIMIZEBAND, nBand - 1, 0 )

   METHOD SetBkColor( nColor )            INLINE SendMessage( ::hWnd, RB_SETBKCOLOR, 0, nColor )

   METHOD SetColorMaximizeBand( nBand, nIdeal )   INLINE SendMessage( ::hWnd, RB_MAXIMIZEBAND, nBand - 1, nIdeal )

   METHOD MouseMove() VIRTUAL

   METHOD Notify( nIdCtrl, nPtrNMHDR )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd ) CLASS TReBar

   DEFAULT oWnd := GetWndDefault()

   ::oWnd   = oWnd
   ::nId    = ::GetNewId()
   ::nStyle = nOR(   WS_CHILD,;
                     WS_VISIBLE,;
                     RBS_VARHEIGHT,;
                     RBS_BANDBORDERS,;
                     RBS_VERTICALGRIPPER,;
                     WS_CLIPCHILDREN,;
                     CCS_NOPARENTALIGN,;
                     CCS_NOMOVEY )
   ::lDrag = .f.

   ::oWnd:oTop = Self

   InitCommonControlsEx( ICC_COOL_CLASSES )

   if ! Empty( oWnd:hWnd )
      ::Create( "ReBarWindow32" )
      SetReBarInfo( ::hWnd )
      oWnd:AddControl( Self )
      ::nWidth = ::oWnd:nWidth
   else
      oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Command( nWParam, nLParam ) CLASS TReBar // Keep this here cause Xbase++

   local hWndCtl := nLParam

   if GetClassName( hWndCtl ) != "ToolbarWindow32"
      Super:Command( nWParam, nLParam )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TReBar

   local nCode := GetNMHDRCode( nPtrNMHDR )

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
