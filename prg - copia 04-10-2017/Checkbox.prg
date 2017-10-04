#include "FiveWin.Ch"
#include "Constant.ch"

#ifdef __CLIPPER__
   #define BM_SETCHECK   ( WM_USER + 1 )
#else
   #define BM_SETCHECK   241
#endif

#define CB_RESETCONTENT   ( WM_USER + 11 )

#define GWL_EXSTYLE       (-20)
#define WS_EX_TRANSPARENT   32

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TCheckBox FROM TControl

   DATA bOldWhen

   METHOD New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight,;
               nHelpTopic, bChange, oFont, bValid, nClrFore, nClrBack,;
               lDesign, lPixel, cMsg, lUpdate, bWhen ) CONSTRUCTOR

   METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, bChange, bValid,;
                    nClrFore, nClrBack, cMsg, lUpdate, bWhen ) CONSTRUCTOR

   METHOD Click()

   METHOD Default()

   METHOD cToChar() INLINE Super:cToChar( "CHECKBOX" )

   #ifndef __CLIPPER__
      METHOD EraseBkGnd( hDC )
      METHOD LostFocus( hCtl )
   #endif

   METHOD Initiate( hDlg ) INLINE  Super:Initiate( hDlg ),;
                  ::cCaption := GetWindowText( ::hWnd ),;
                  ::SendMsg( BM_SETCHECK, If( Eval( ::bSetGet ), 1, 0 ) )

   METHOD MouseMove( nRow, nCol, nKeyFlags )

   METHOD Refresh() INLINE ;
                    ::SendMsg( BM_SETCHECK, If( Eval( ::bSetGet ), 1, 0 ) )

   METHOD Reset() INLINE Eval( ::bSetGet,;
                         If( ValType( Eval( ::bSetGet ) ) == "N", 0, "" ) ),;
                         ::SendMsg( CB_RESETCONTENT )

   METHOD cGenPrg()

   METHOD Check() INLINE Eval( ::bSetGet, .T. ), ::SendMsg( BM_SETCHECK, 1 )

   METHOD UnCheck() INLINE Eval( ::bSetGet, .F. ), ::SendMsg( BM_SETCHECK, 0 )

   METHOD SetCheck( lOnOff ) INLINE If( lOnOff, ::Check(), ::UnCheck() )

   METHOD SetText( cText )

   METHOD HardEnable()

   METHOD HardDisable()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nRow, nCol, cCaption, bSetGet, oWnd, nWidth, nHeight, nHelpTopic,;
            bChange, oFont, bValid, nClrFore, nClrBack, lDesign, lPixel,;
            cMsg, lUpdate, bWhen ) CLASS TCheckBox

#ifdef __XPP__
   #undef New
#endif

   local lTemp := .f.

   DEFAULT nRow       := 0, nCol := 0,;
           cCaption   := "&CheckBox",;
           oWnd       := GetWndDefault(),;
           nWidth     := Len( cCaption ) * CHB_CHARPIX_W,;
           nHeight    := CHB_CHARPIX_H + Int( CHB_CHARPIX_H / 2 ),;
           nHelpTopic := 100,;
           nClrFore   := oWnd:nClrText, nClrBack := oWnd:nClrPane,;
           lPixel     := .f., lDesign := .f., lUpdate := .f.,;
           bSetGet    := bSETGET( lTemp )

   if ValType( Eval( bSetGet ) ) != "L"
      Eval( bSetGet, .f. )
   endif

   ::nTop       = nRow * If( lPixel, 1, CHB_CHARPIX_H )
   ::nLeft      = nCol * If( lPixel, 1, CHB_CHARPIX_W )
   ::nBottom    = ::nTop + nHeight
   ::nRight     = ::nLeft + nWidth - If( lPixel, 0, 24 )
   ::cCaption   = cCaption
   ::nStyle     = nOR( WS_CHILD, WS_VISIBLE, BS_AUTOCHECKBOX,;
                       WS_TABSTOP,;
                       If( lDesign, WS_CLIPSIBLINGS, 0 ) )
   ::nId        = ::GetNewId()
   ::nHelpId    = nHelpTopic
   ::bSetGet    = bSetGet
   ::bChange    = bChange
   ::oWnd       = oWnd
   ::oFont      = oFont
   ::bValid     = bValid
   ::lDrag      = lDesign
   ::lCaptured  = .f.
   ::cMsg       = cMsg
   ::lUpdate    = lUpdate
   ::bWhen      = bWhen

   ::SetColor( nClrFore, nClrBack )

   if ! Empty( oWnd:hWnd )
      ::Create( "BUTTON" )
      ::Default()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

   if lDesign
      ::CheckDots()
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Click( lValue ) CLASS TCheckBox

   DEFAULT lValue := !Eval( ::bSetGet )

   if ::bSetGet != nil
      Eval( ::bSetGet, lValue )
      ::Refresh()
   endif

   if ::bChange != nil
      Eval( ::bChange, Eval( ::bSetGet ), Self )
   endif

   Super:Click()           // keep it here, the latest !!!

return ( Self )

//----------------------------------------------------------------------------//

METHOD ReDefine( nId, bSetGet, oWnd, nHelpId, bChange, bValid, nClrFore,;
                 nClrBack, cMsg, lUpdate, bWhen ) CLASS TCheckBox

   DEFAULT oWnd := GetWndDefault(), nClrFore := oWnd:nClrText, nClrBack := oWnd:nClrPane

   if ValType( Eval( bSetGet ) ) != "L"
      Eval( bSetGet, .f. )
   endif

   ::nId       = nId
   ::bSetGet   = bSetGet
   ::bChange   = bChange
   ::oWnd      = oWnd
   ::nHelpId   = nHelpId
   ::bValid    = bValid
   ::lDrag     = .f.
   ::lCaptured = .f.
   ::cMsg      = cMsg
   ::lUpdate   = lUpdate
   ::bWhen     = bWhen

   ::SetColor( nClrFore, nClrBack )

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

#ifndef __CLIPPER__

METHOD EraseBkGnd( hDC ) CLASS TCheckBox

   if IsAppThemed()
      return 1
   endif

return Super:EraseBkGnd( hDC )

METHOD LostFocus( hCtl ) CLASS TCheckBox

   if IsAppThemed()
      CheckFocus( ::hWnd, hCtl )
   endif

return Super:LostFocus( hCtl )

#endif

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TCheckBox

   if ::lDrag
      return Super:MouseMove( nRow, nCol, nKeyFlags )
   else
      Super:MouseMove( nRow, nCol, nKeyFlags )
   endif

return nil    //  We want standard behavior  !!!

//----------------------------------------------------------------------------//

METHOD Default() CLASS TCheckBox

   ::SendMsg( BM_SETCHECK, If( Eval( ::bSetGet ), 1, 0 ) )

   if ::oFont != nil
      ::SetFont( ::oFont )
   else
      ::SetFont( ::oWnd:oFont )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TCheckBox

   local cPrg := ""

   ::CoorsUpdate()

   if ::cCaption == nil
      ::cCaption = GetWindowText( ::hWnd )
   endif

   cPrg += CRLF + ;
           "   @ " + LTrim( Str( ::nTop ) ) + ", " + ;
           LTrim( Str( ::nLeft ) ) + ;
           ' CHECKBOX lVar PROMPT "' + ::cCaption + '" SIZE ' + ;
           LTrim( Str( ::nRight - ::nLeft + 1 ) ) + ", " + ;
           LTrim( Str( ::nBottom - ::nTop + 1 ) ) + ;
           " PIXEL OF oWnd " + CRLF

return cPrg

//----------------------------------------------------------------------------//

METHOD SetText( cText ) CLASS TCheckBox

   local hDC

   #ifndef __CLIPPER__
      if IsAppThemed()
         DrawPBack( ::hWnd, hDC := GetDC( ::hWnd ) )
         ReleaseDC( ::hWnd, hDC )
      endif
   #endif

   SetWindowText( ::hWnd, ::cCaption := cText )

return nil

//----------------------------------------------------------------------------//

Method HardEnable() CLASS TCheckBox

   ::bWhen     := ::bOldWhen

Return ( ::Enable() )

//---------------------------------------------------------------------------//

Method HardDisable() CLASS TCheckBox

   ::bOldWhen  := ::bWhen
   ::bWhen     := {|| .f. }

return ( ::Disable() )

//---------------------------------------------------------------------------//