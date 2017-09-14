// Windows 95 Progress Control support

#include "FiveWin.Ch"
#include "Constant.ch"
#include "Objects.ch"

#define COLOR_WINDOW         5
#define COLOR_WINDOWTEXT     8
#define COLOR_BTNFACE       15
#define COLOR_BTNSHADOW     16
#define COLOR_BTNHIGHLIGHT  20

#define PBM_SETRANGE      1025
#define PBM_SETPOS        1026
#define PBM_DELTAPOS      1027
#define PBM_SETSTEP       1028
#define PBM_STEPIT        1029

#ifdef __XPP__
   #define Super ::TControl
#endif

//----------------------------------------------------------------------------//

CLASS TProgress FROM TControl

   DATA   nMin, nMax, nPos, nStep  AS NUMERIC

   METHOD New( nTop, nLeft, oWnd, nPos, nClrFore,;
               nClrBack, lPixel, lDesign, nWidth, nHeight,;
               cMsg ) CONSTRUCTOR

   METHOD ReDefine( nId, oWnd ) CONSTRUCTOR

   METHOD DeltaPos( nIncrement ) INLINE ;
          SendMessage( ::hWnd, PBM_DELTAPOS, nIncrement )

   MESSAGE SetPos( nPos ) METHOD _SetPos( nPos )

   METHOD SetRange( nMin, nMax ) INLINE ;
          SendMessage( ::hWnd, PBM_SETRANGE, 0, nMakeLong( nMin, nMax ) ),;
          ::nMin := nMin, ::nMax := nMax

   #ifndef __XPP__
      MESSAGE _nPosition( nPos ) METHOD _SetPos( nPos )
      MESSAGE nPosition ALIAS OF nPos
   #endif

   METHOD SetStep( nStepInc ) INLINE ;
          SendMessage( ::hWnd, PBM_SETSTEP, ::nStep := nStepInc )

   METHOD Deltapos(1) INLINE SendMessage( ::hWnd, PBM_STEPIT )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, oWnd, nPos, nClrFore, nClrBack, lPixel,;
            lDesign, nWidth, nHeight, cMsg ) CLASS TProgress

   DEFAULT nTop     := 0, nLeft := 0,;
           oWnd     := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_BTNFACE ),;
           lPixel   := .f.,;
           lDesign  := .f.,;
           nWidth   := 200, nHeight := 21

   ::nStyle    = nOR( WS_CHILD, WS_VISIBLE,;
                      If( lDesign, WS_CLIPSIBLINGS, 0 ), WS_TABSTOP )
   ::nId       = ::GetNewId()
   ::oWnd      = oWnd
   ::cMsg      = cMsg
   ::nTop      = If( lPixel, nTop, nTop * SAY_CHARPIX_H )
   ::nLeft     = If( lPixel, nLeft, nLeft * SAY_CHARPIX_W )
   ::nBottom   = ::nTop + nHeight - 1
   ::nRight    = ::nLeft + nWidth - 1
   ::lDrag     = lDesign
   ::lCaptured = .f.
   ::nClrText  = nClrFore
   ::nClrPane  = nClrBack

   if ! Empty( oWnd:hWnd )
      ::Create( "msctls_progress32" )
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   ::Default()

   if lDesign
      ::CheckDots()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, oWnd ) CLASS TProgress

   ::nId     = nId
   ::oWnd    = oWnd

   oWnd:DefControl( Self )

return nil

//----------------------------------------------------------------------------//

METHOD _SetPos( nPos ) CLASS TProgress

   SendMessage( ::hWnd, PBM_SETPOS, nPos )
   ::nPos := nPos

return nil

//----------------------------------------------------------------------------//