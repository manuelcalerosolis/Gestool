// TPages Class. Used for managing a group of child DialogBoxes

#include "FiveWin.ch"

#define COLOR_BTNFACE  15

#ifdef __XPP__
   #define ::Super ::TControl
   #define New   _New
#endif

//----------------------------------------------------------------------------//

CLASS TPages FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   DATA   nOption
   DATA   aDialogs
   DATA   aHelps

   METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CONSTRUCTOR

   METHOD Redefine( nId, oWnd, aDialogs, nOption, bChange, oFont, aHelps ) CONSTRUCTOR

   METHOD AddPage( oControl )

   #ifndef __CLIPPER__
      METHOD cToChar() INLINE ::Super:cToChar( "SysTabControl32" )
   #endif

   METHOD Initiate( hDlg ) INLINE ::Super:Initiate( hDlg ), ::Default()

   METHOD Default()

   METHOD DelPage( nPage )

   METHOD Destroy()

   METHOD SetOption( nOption )

   METHOD GoPrev() INLINE If( ::nOption > 1,;
                              ::SetOption( ::nOption - 1 ),)

   METHOD GoNext() INLINE If( ::nOption < Len( ::aDialogs ),;
                              ::SetOption( ::nOption + 1 ),)
   METHOD GotFocus()

   METHOD ReSize( nType, nWidth, nHeight )

   METHOD Show()

   METHOD Hide()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nBottom, nRight, oWnd ) CLASS TPages

   DEFAULT nTop := 0, nLeft := 0, nBottom := 100, nRight := 100,;
           oWnd := GetWndDefault()

   #ifdef __XPP__
      #undef New
   #endif

	::lUnicode	   := FW_SetUnicode()
   ::nTop         := nTop
   ::nLeft        := nLeft
   ::nBottom      := nBottom
   ::nRight       := nRight
   ::oWnd         := oWnd
   ::nStyle       := nOr( WS_CHILD, WS_VISIBLE )
   ::nClrPane     := GetSysColor( COLOR_BTNFACE )
   ::nOption      := 1
   ::aDialogs     := {}
   ::aHelps       := {}
   ::lDrag        := .f.
   ::lVisible     := .t.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::Register()

   if ! Empty( ::oWnd:hWnd )
      #ifdef __CLIPPER__
         ::Create()
      #else
         ::Create( "SysTabControl32" )
      #endif
      ::oWnd:AddControl( Self )
   else
      ::oWnd:DefControl( Self )
   endif

return Self

//----------------------------------------------------------------------------//

METHOD Redefine( nId, oWnd, aDialogs, nOption, bChange, oFont, aHelps ) CLASS TPages

   local n, oDlg

   DEFAULT  nOption  := 1,;
            oWnd     := GetWndDefault(),;
            oFont    := ::GetFont(),;
            aHelps   := array( len( aDialogs ) )

   ::nId          := nId
   ::oWnd         := oWnd
	::lUnicode	   := FW_SetUnicode()
   ::nOption      := nOption
   ::bChange      := bChange
   ::aDialogs     := aDialogs
   ::aHelps       := aHelps
   ::lVisible     := .t.
   ::SetFont( oFont )

   ::Register()
   ::SetColor( 0, GetSysColor( COLOR_BTNFACE ) )

   for n = 1 to Len( ::aDialogs )
      DEFINE DIALOG oDlg OF Self RESOURCE ::aDialogs[ n ] FONT Self:oFont ;
        HELPID if(len(::aHelps) >= n , ::aHelps[n] , NIL)
      ::aDialogs[ n ] = oDlg
   next

   oWnd:DefControl( Self )

return Self

//----------------------------------------------------------------------------//

METHOD AddPage( oControl ) CLASS TPages

   AAdd( ::aDialogs, oControl )

   if ::oWnd:hWnd != nil
      #ifndef __XPP__
         oControl:nWidth  = ::nWidth()
         oControl:nHeight = ::nHeight()
      #else
         WndWidth( oControl:hWnd, ::nWidth() )
         WndHeight( oControl:hWnd, ::nHeight() )
      #endif

      if Upper( oControl:ClassName() ) == "TDIALOG"
         ACTIVATE DIALOG oControl NOWAIT ;
            ON INIT ( SysWait(), oControl:Move( 0, 0 ) ) ;
            VALID .f.

         #ifndef __CLIPPER__
            if IsAppThemed()
               oControl:bEraseBkGnd = { | hDC | DrawPBack( oControl:hWnd, hDC ), 1 }
            endif
         #endif
      else
         oControl:Move( 0, 0 )
      endif

      ::SetOption( Len( ::aDialogs ) )
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Default() CLASS TPages

   local n, oDlg

   for n = 1 to Len( ::aDialogs )
      oDlg = ::aDialogs[ n ]

      ACTIVATE DIALOG oDlg NOWAIT ;
         ON INIT ( SysWait(), oDlg:Move( 0, 0 ) ) ;
         VALID .f.         // to avoid exiting pressing Esc !!!

      #ifndef __CLIPPER__
         if IsAppThemed()
            oDlg:bEraseBkGnd = { | hDC | DrawPBack( oDlg:hWnd, hDC ), 1 }
         endif
      #endif

      oDlg:Hide()
   next

   if Len( ::aDialogs ) > 0
      if ::nOption <= Len( ::aDialogs )
         ::aDialogs[ ::nOption ]:Show()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD DelPage( nPage ) CLASS TPages

   local nNewPage

   DEFAULT nPage := ::nOption

   if nPage > 0 .and. nPage <= Len( ::aDialogs )
      ::aDialogs[ nPage ]:bValid = { || .t. }
      ::aDialogs[ nPage ]:End()
      SysRefresh()
      ADel( ::aDialogs, nPage )
      ASize( ::aDialogs, Len( ::aDialogs ) - 1 )
      ADel( ::aHelps, nPage )
      ASize( ::aHelps, Len( ::aDialogs ) - 1 )
      if Len( ::aDialogs ) > 0
         nNewPage = If( nPage > 1, nPage - 1, 1 )
         if ::bChange != nil
            Eval( ::bChange, nNewPage, nPage )
         endif
         ::nOption  = nNewPage
         ::aDialogs[ nNewPage ]:Show()
         ::aDialogs[ nNewPage ]:SetFocus()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Destroy() CLASS TPages

   aeval( ::aDialogs, {|oDialog| oDialog:bValid := { || .t. }, oDialog:End(), sysrefresh() } )

return ::Super:Destroy()

//----------------------------------------------------------------------------//

METHOD GotFocus() CLASS TPages

   ::Super:GotFocus()

   if ::nOption <= Len( ::aDialogs )
      ::aDialogs[ ::nOption ]:SetFocus()
   endif

return 0

//----------------------------------------------------------------------------//

METHOD SetOption( nOption ) CLASS TPages

   local nOldOption

   if nOption > 0 .and. nOption != ::nOption
      if ::nOption <= Len( ::aDialogs ) .and. ::aDialogs[ ::nOption ] != nil
         ::aDialogs[ ::nOption ]:Hide()
      endif
      nOldOption = ::nOption
      ::nOption  = nOption
      if nOption <= Len( ::aDialogs ) .and. ::aDialogs[ nOption ] != nil
         if ::bChange != nil
            Eval( ::bChange, nOption, nOldOption )
         endif
         ::aDialogs[ nOption ]:Show()
         ::aDialogs[ nOption ]:SetFocus()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Resize( nType, nWidth, nHeight ) CLASS TPages

   DEFAULT  nWidth   := ::nWidth(),;
            nHeight  := ::nHeight

   aeval( ::aDialogs, {|oDialog| oDialog:SetSize( nWidth, nHeight ) } )

return ::Super:Resize( nType, nWidth, nHeight )

//----------------------------------------------------------------------------//

METHOD Show() CLASS TPages

   aeval( ::aDialogs, {|oDialog| aeval(oDialog:aControls, {|oControl| oControl:Show() } ) } )

RETURN ( ::Super:Show() )

//----------------------------------------------------------------------------//

METHOD Hide() CLASS TPages

   aeval( ::aDialogs, {|oDialog| aeval(oDialog:aControls, {|oControl| oControl:Hide() } ) } )

RETURN ( ::Super:Hide() )

//----------------------------------------------------------------------------//
