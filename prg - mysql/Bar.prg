#include "FiveWin.Ch"
#include "Menu.ch"
#include "Font.ch"
#include "Ini.ch"

#define BAR_HEIGHT           28
#define GRAY_BRUSH            2

#define BAR_TOP               1
#define BAR_LEFT              2
#define BAR_RIGHT             3
#define BAR_DOWN              4
#define BAR_FLOAT             5

#define SM_CYBORDER           6
#define SM_CYCAPTION          4

#define COLOR_BTNFACE        15
#define COLOR_BTNSHADOW      16
#define COLOR_BTNHIGHLIGHT   20

#define GROUP_SEP            8

#ifdef __XPP__
   #define Super ::TControl
#endif

//----------------------------------------------------------------------------//

CLASS TBar FROM TControl

   DATA   nGroups, nMode
   DATA   nBtnWidth, nBtnHeight
   DATA   l3D
   DATA   lEtiqueta
   DATA   nLabelHeight

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( oWnd, nBtnWidth, nBtnHeight, l3D, cMode, oCursor, lEtiqueta ) CONSTRUCTOR

   METHOD NewAt( nRow, nCol, nWidth, nHeight, nBtnWidth, nBtnHeight, oWnd,;
                 l3D, cMode, oCursor ) CONSTRUCTOR

   METHOD Add( oBtnBmp, nPos )

   METHOD AddGroup( nPos )

   METHOD Adjust()

   METHOD BtnAdjust()

   METHOD ColPanUp() INLINE  IF( ::nClrPane != GetSysColor( COLOR_BTNFACE ) ,;
                                 ::SetColor(,GetSysColor( COLOR_BTNFACE )) , )
   METHOD Del( nPos )

   METHOD DelGroup( nPos )

   METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0

   METHOD Float()
   METHOD GoDown()
   METHOD GoLeft()
   METHOD GoRight()
   METHOD GoTop()

   METHOD cGenPRG()
   METHOD GetBtnTop( lNewGroup, nPos )
   METHOD GetBtnLeft( lNewGroup, nPos )

   METHOD RButtonDown( nRow, nCol, nFlags )

   METHOD SaveIni( cBarName, cFile )

   METHOD LButtonDown( nRow, nCol, nFlags ) INLINE ;
          Super:LButtonDown( nRow, nCol, nFlags ),;
          UpdateWindow( ::hWnd ),;
          If( ::bLClicked == nil, ( BarInvert( ::hWnd ), SetCapture( ::hWnd ) ),)

   METHOD LButtonUp( nRow, nCol, nFlags ) INLINE ;
          If( ::bLClicked == nil, If( GetCapture() == ::hWnd,;
          ( BarInvert( ::hWnd ), ReleaseCapture() ),),),;
          Super:LButtonUp( nRow, nCol, nFlags )

   METHOD MouseMove( nRow, nCol, nKeyFlags ) INLINE ;
                     Super:MouseMove( nRow, nCol, nKeyFlags ),;
                     ::oWnd:SetMsg( ::cMsg ), 0

   METHOD Paint()

   METHOD FloatClick( nRow, nCol, oWnd )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, nBtnWidth, nBtnHeight, l3D, cMode, oCursor , lEtiqueta, oFont) CLASS TBar

   local oRect := oWnd:GetCliRect()

   DEFAULT nBtnWidth := BAR_HEIGHT, nBtnHeight := BAR_HEIGHT,;
           l3D := .f., cMode := "TOP", lEtiqueta := .F., oFont := oWnd:oFont

   IF lEtiqueta .AND. EMPTY(oFont)
      DEFINE FONT oFont NAME "Ms Sans Serif" SIZE 0,12
   ENDIF
   ::oFont        = oFont
   ::nLabelHeight = IF(lEtiqueta,IF(oFont!=nil,oFont:nHeight,10),0)
   ::nStyle      = nOR( DS_MODALFRAME, WS_BORDER, WS_CHILD, WS_VISIBLE, 4 )
   ::aControls   = {}
   ::nGroups     = 0
   ::oWnd        = oWnd
   ::nTop        = If( cMode == "BOTTOM", oRect:nBottom - nBtnHeight, -1 )
   ::nLeft       = If( cMode == "RIGHT", oRect:nRight - nBtnWidth - ;
                   If( l3D, 3, 0 ), -1 )
   ::nBottom     = If( cMode == "TOP", nBtnHeight + ::nLabelHeight , oRect:nBottom + 1 )
   ::nRight      = If( cMode == "TOP" .or. cMode == "BOTTOM",;
                       oRect:nRight,;
                   If( cMode == "LEFT", nBtnWidth + If( l3D, 3, 0 ), oRect:nRight + 1 ) )
   ::nBtnWidth   = nBtnWidth
   ::nBtnHeight  = nBtnHeight
   ::nId         = ::GetNewId()
   ::lDrag       = .f.
   ::lCaptured   = .f.
   ::nClrPane    = If( l3D, GetSysColor( COLOR_BTNFACE ), CLR_GRAY )
   ::lVisible    = .t.
   ::l3D         = l3D
   ::lEtiqueta   = lEtiqueta
   ::nMode       = AScan( { "TOP", "LEFT", "RIGHT", "BOTTOM", "FLOAT" }, cMode )
   ::oCursor     = oCursor
   ::lValidating = .f.

   ::bRClicked   = {||nil} // No reallocate button bar

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::SetColor( ::nClrText, ::nClrPane )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )
   ::Create()

   if oWnd != nil
      oWnd:oBar = Self
   endif

return nil

//----------------------------------------------------------------------------//

METHOD NewAt( nRow, nCol, nWidth, nHeight, nBtnWidth, nBtnHeight, oWnd, l3D,;
              cMode, oCursor ) CLASS TBar

   local oRect := oWnd:GetCliRect()

   DEFAULT nBtnWidth := BAR_HEIGHT, nBtnHeight := BAR_HEIGHT,;
           nHeight := BAR_HEIGHT,;
           l3D := .f., cMode := "TOP"

   ::nStyle      = nOR( WS_BORDER, WS_CHILD, WS_VISIBLE )
   ::aControls   = {}
   ::nGroups     = 0
   ::oWnd        = oWnd
   ::nTop        = nRow
   ::nLeft       = nCol
   ::nBottom     = nRow + nHeight - 1
   ::nRight      = nCol + nWidth - 1
   ::nBtnWidth   = nBtnWidth
   ::nBtnHeight  = nBtnHeight
   ::nId         = ::GetNewId()
   ::lDrag       = .f.
   ::lCaptured   = .f.
   ::nClrPane    = If( l3D, GetSysColor( COLOR_BTNFACE ), CLR_GRAY )
   ::lVisible    = .t.
   ::l3D         = l3D
   ::nMode       = AScan( { "TOP", "LEFT", "RIGHT", "BOTTOM", "FLOAT" }, cMode )
   ::oCursor     = oCursor
   ::lValidating = .f.

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif

   ::SetColor( ::nClrText, ::nClrPane )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )
   ::Create()

return nil

//----------------------------------------------------------------------------//

METHOD Add( oBtnBmp, nPos ) CLASS TBar

  if nPos == nil
     AAdd( ::aControls, oBtnBmp )
  else
     AAdd( ::aControls, nil )
     AIns( ::aControls, nPos )
     ::aControls[ nPos ] = oBtnBmp
  endif

return nil

//----------------------------------------------------------------------------//

METHOD AddGroup( nPos ) CLASS TBar

   local n

   do case
      case ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
           if ! ::aControls[ nPos ]:lGroup
           for n = nPos to Len( ::aControls )
               ::aControls[ n ]:nLeft += GROUP_SEP
               ::aControls[ n ]:nRight += GROUP_SEP
           next
           ::aControls[ nPos ]:lGroup := .t.
           ::nGroups++
           endif

      case ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
           if ! ::aControls[ nPos ]:lGroup
              for n = nPos to Len( ::aControls )
                 ::aControls[ n ]:nTop += GROUP_SEP
                 ::aControls[ n ]:nBottom += GROUP_SEP
              next
              ::aControls[ nPos ]:lGroup = .t.
              ::nGroups++
           endif

      case ::nMode == BAR_FLOAT
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD BtnAdjust() CLASS TBar

   local n, nGroups := 0
   local nRow := If( ::l3D, 2, -1 )
   local nCol := If( ::l3D, 2, -1 )

   do case
      case ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
           for n = 1 to Len( ::aControls )
              nGroups += If( ::aControls[ n ]:lGroup, 1, 0 )
              ::aControls[ n ]:Move( If( ::l3D, 4, 0 ) - 1,;
                                     nCol + ( nGroups * GROUP_SEP ) + 9 )
              ::aControls[ n ]:Refresh()
              nCol    += ::nBtnWidth
           next

      case ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
           for n = 1 to Len( ::aControls )
              nGroups += If( ::aControls[ n ]:lGroup, 1, 0 )
              ::aControls[ n ]:Move( nRow + ( nGroups * GROUP_SEP ) + 8,;
                                     If( ::l3D, 3, 0 ) - 1 )
              ::aControls[ n ]:Refresh()
              nRow += ::nBtnHeight - If( ::l3D, 3, -1 )
           next

      case ::nMode == BAR_FLOAT
           nRow = 0
           nCol = 0
           for n = 1 to Len( ::aControls )
              ::aControls[ n ]:Move( nRow, nCol )
              nRow = If( nCol == ::nBtnWidth - If( ::l3D, 2, 0 ), nRow + ;
                         ::nBtnHeight - If( ::l3D, 5, -1 ), nRow )
              nCol = If( nCol == 0, ::nBtnWidth - If( ::l3D, 2, 0 ), 0 )
           next

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD cGenPRG() CLASS TBar

   local cPrg := ""
   local n

   cPrg += CRLF + CRLF + "   DEFINE BUTTONBAR oBar OF oWnd " + ;
           If( ::nMode != BAR_TOP,;
               { "TOP", "LEFT", "RIGHT", "DOWN", "FLOAT" }[ ::nMode ], "" )

   AEval( ::aControls, { | oCtrl | cPrg += oCtrl:cGenPRG() } )

return cPrg

//----------------------------------------------------------------------------//

METHOD Del( nPos ) CLASS TBar

   local n
   local lGroup:= ::aControls[nPos]:lGroup

   ADel( ::aControls, nPos )
   ASize( ::aControls, Len( ::aControls ) - 1 )
   if nPos <= Len( ::aControls )
      if ! ::aControls[ nPos ]:lGroup
         ::aControls[ nPos ]:lGroup = lGroup
      endif
   endif

   do case
      case ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
           for n = nPos to Len( ::aControls )
              ::aControls[ n ]:nLeft -= ::nBtnWidth
              ::aControls[ n ]:nRight -= ::nBtnWidth
           next

      case ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
           for n = nPos to Len( ::aControls )
              ::aControls[ n ]:nTop    -= ::nBtnHeight
              ::aControls[ n ]:nBottom -= ::nBtnHeight
           next

      case ::nMode == BAR_FLOAT
   endcase

   ::BtnAdjust()
   ::Refresh()

return nil

//----------------------------------------------------------------------------//

METHOD DelGroup( nPos ) CLASS TBar

   local n

   do case
      case ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
           if ::aControls[ nPos ]:lGroup
              for n = nPos to Len( ::aControls )
                 ::aControls[ n ]:nLeft  -= GROUP_SEP
                 ::aControls[ n ]:nRight -= GROUP_SEP
              next
              ::aControls[ nPos ]:lGroup = .f.
              ::nGroups--
           endif

      case ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
           if ::aControls[ nPos ]:lGroup
              for n = nPos to Len( ::aControls )
                 ::aControls[ n ]:nTop    -= GROUP_SEP
                 ::aControls[ n ]:nBottom -= GROUP_SEP
              next
              ::aControls[ nPos ]:lGroup := .f.
              ::nGroups--
           endif

      case ::nMode == BAR_FLOAT
   endcase

return nil

//----------------------------------------------------------------------------//

METHOD GetBtnLeft( lNewGroup, nInd ) CLASS TBar

   local nPos := If( ::l3D, 9, 0 )
   local n

   do case
      case ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
           if Len( ::aControls ) > 0
              if nInd == nil
                 nPos := ( ATail( ::aControls ):nRight )
              else
                 if nInd > 1
                    nPos := ::aControls[ nInd - 1 ]:nRight
                 endif
                 for n = nInd to Len( ::aControls )
                    ::aControls[ n ]:nLeft  += ::nBtnWidth
                    ::aControls[ n ]:nRight += ::nBtnWidth
                    if ::aControls[ n ]:lGroup
                       ::aControls[ n ]:nLeft  += GROUP_SEP
                       ::aControls[ n ]:nRight += GROUP_SEP
                    endif
                 next
              endif
           endif

           if lNewGroup != nil .and. lNewGroup
                      // Correct for new group
              ++::nGroups
              nPos += GROUP_SEP
           endif
           if ::l3D
                   // Correct for 3D-effect
              nPos += 2
           endif

      case ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
           nPos = If( ::l3D, 2, 0 )

      case ::nMode == BAR_FLOAT
           nPos = If( Len( ::aControls ) > 0,;
                  If( ATail( ::aControls ):nRight + ::nBtnWidth > ::nRight,;
                      -1, ( Len( ::aControls ) * ::nBtnWidth ) - 1 ), -1 )
   endcase

return nPos

//----------------------------------------------------------------------------//

METHOD GetBtnTop( lNewGroup ) CLASS TBar

   local nPos     := 0
   local nButtons := Len( ::aControls )

   do case
      case ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
           nPos = If( ::l3D, 3, -1 )   // 3 --> 2

      case ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
           nPos = If( ::l3D, 2, 0 ) + ;
                  ( nButtons * ( ::nBtnHeight - If( ::l3D, 3, 0 ) ) ) + ;
                  ( If( lNewGroup, ++::nGroups, ::nGroups ) * GROUP_SEP )
   endcase

return nPos

//----------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TBar

   local oMenu

   if ::bRClicked != nil
      return Eval( ::bRClicked, nRow, nCol, nFlags )
   endif

   MENU oMenu POPUP
      if ::nMode != BAR_TOP
         MENUITEM "&Arriba"    ACTION ::GoTop() ;
            WHEN Empty( ::oWnd:oTop ) .and. Empty( ::oWnd:oBar )
      endif
      if ::nMode != BAR_LEFT
         MENUITEM "&Izquierda"   ACTION ::GoLeft()   WHEN Empty( ::oWnd:oLeft )
      endif
      if ::nMode != BAR_RIGHT
          MENUITEM "&Derecha"  ACTION ::GoRight() WHEN Empty( ::oWnd:oRight )
      endif
      if ::nMode != BAR_DOWN
         MENUITEM "A&bajo" ACTION ::GoDown() ;
            WHEN Empty( ::oWnd:oBottom ) .and. Empty( ::oWnd:oMsgBar )
      endif
      SEPARATOR
      MENUITEM "&Flotante"  ACTION ::Float()
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow, nCol OF Self

return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TBar

   local oRect

   if ::nMode != BAR_DOWN
      do case
         case ::nMode == BAR_TOP
              ::oWnd:oBar = nil
              ::oWnd:oTop = nil

         case ::nMode == BAR_LEFT
              ::oWnd:oLeft = nil

         case ::nMode == BAR_RIGHT
              ::oWnd:oRight = nil
      endcase

      ::nMode = BAR_DOWN
      if ::oWnd:ChildLevel( TMdiFrame() ) != 0 .and. ::oWnd:oWndClient != nil
         ::oWnd:oWndClient:Refresh()
      endif
      ::oWnd:oBottom = Self
      ::nWidth  = ::oWnd:nWidth
      ::nHeight = ::nBtnHeight + If( ::l3D, 2, 1 ) + ::nLabelHeight
      ::oWnd:Resize()
      if ::oWnd:ChildLevel( TMdiFrame() ) != 0 .and. ::oWnd:oWndClient != nil
         ::oWnd:oWndClient:Refresh()
      endif
      ::BtnAdjust()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoLeft() CLASS TBar

   if ::nMode != BAR_LEFT
      do case
         case ::nMode == BAR_TOP
              ::oWnd:oTop = nil
              ::oWnd:oBar = nil

         case ::nMode == BAR_RIGHT
              ::oWnd:oRight = nil

         case ::nMode == BAR_DOWN
              ::oWnd:oBottom = nil
      endcase
      ::nMode = BAR_LEFT
      ::oWnd:oLeft = Self
      ::nWidth = ::nBtnWidth + If( ::l3D, 5, 3 )
      ::oWnd:Resize()
      #ifndef __XPP__
         if ::oWnd:ChildLevel( TMdiFrame() ) != 0 .and. ::oWnd:oWndClient != nil
            ::oWnd:oWndClient:Refresh()
         endif
      #else
         if Upper( ::oWnd:ClassName() ) == "TMDIFRAME" .and. ::oWnd:oWndClient != nil
            ::oWnd:oWndClient:Refresh()
         endif
      #endif
      ::BtnAdjust()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoRight() CLASS TBar

   local oRect

   if ::nMode != BAR_RIGHT
      do case
         case ::nMode == BAR_TOP
              ::oWnd:oTop = nil
              ::oWnd:oBar = nil

         case ::nMode == BAR_LEFT
              ::oWnd:oLeft = nil

         case ::nMode == BAR_DOWN
              ::oWnd:oBottom = nil
      endcase
      ::nMode = BAR_RIGHT
      ::oWnd:oRight = Self
      ::nWidth = ::nBtnWidth + If( ::l3D, 5, 3 )
      ::oWnd:Resize()
      if ::oWnd:ChildLevel( TMdiFrame() ) != 0 .and. ::oWnd:oWndClient != nil
         ::oWnd:oWndClient:Refresh()
      endif
      ::BtnAdjust()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD GoTop() CLASS TBar

   if ::nMode != BAR_TOP
      do case
         case ::nMode == BAR_LEFT
              ::oWnd:oLeft = nil

         case ::nMode == BAR_RIGHT
              ::oWnd:oRight = nil

         case ::nMode == BAR_DOWN
              ::oWnd:oBottom = nil
      endcase
      ::nMode = BAR_TOP
      ::oWnd:oBar := ::oWnd:oTop := Self
      ::nWidth  = ::oWnd:nWidth
      ::nHeight = ::nBtnHeight + If( ::l3D, 2, 1 ) + ::nLabelHeight

      ::oWnd:Resize()
      if ::oWnd:ChildLevel( TMdiFrame() ) != 0 .and. ::oWnd:oWndClient != nil
         ::oWnd:oWndClient:Refresh()
      endif

      ::BtnAdjust()
      ::Refresh()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Float() CLASS TBar

   local oWnd
   local oBar := Self
   local n

   local nWidth
   local nHeight
   local nAdjust   := If( ::l3D, - 5, 1 )
   local nControls := If( Len( ::aControls ) % 2 == 0, ;
                          ( Len( ::aControls ) / 2 ), ;
                          ( ( Len( ::aControls ) + 1 ) / 2 ) )

   if ::nMode != BAR_FLOAT

      do case
         case ::nMode == BAR_TOP
              ::oWnd:oBar = nil
              ::oWnd:oTop = nil

         case ::nMode == BAR_LEFT
              ::oWnd:oLeft = nil

         case ::nMode == BAR_RIGHT
              ::oWnd:oRight = nil

         case ::nMode == BAR_DOWN
              ::oWnd:oBottom = nil
      endcase

      ::nMode = BAR_FLOAT

      DEFINE WINDOW oWnd ;
         TITLE "" OF ::oWnd ;
         BORDER NONE ;
         NOZOOM NOICONIZE

      oWnd:ToolWindow()

      REDEFINE SYSMENU OF oWnd
         SEPARATOR
         MENUITEM "&Arriba"    ACTION ( AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), oWnd:End(), ::Show(), ::GoTop() )
         MENUITEM "A&bajo" ACTION ( AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), oWnd:End(), ::Show(), ::GoDown() )
         MENUITEM "&Izquierda"   ACTION ( AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), oWnd:End(), ::Show(), ::GoLeft() )
         MENUITEM "&Derecha"  ACTION ( AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), oWnd:End(), ::Show(), ::GoRight() )
      ENDSYSMENU

      for n = 1 to Len( ::aControls )
         SetParent( ::aControls[ n ]:hWnd, oWnd:hWnd )
      next

      nWidth  = ( oBar:nBtnWidth * 2 ) - If( ::l3D, 2, - 2 )
      nHeight = GetSysMetrics( SM_CYCAPTION ) + 1 + ;
                ( ( oBar:nBtnHeight + nAdjust ) * nControls ) + 10

      oWnd:Move( 90, 30, nWidth, nHeight, .t. )

      oWnd:bRClicked = { | nRow, nCol | ::FloatClick( nRow, nCol, oWnd ) }

      ::Hide()
      ::oWnd:Resize()

      oWnd:Show()
      ::BtnAdjust()
      oWnd:SetFocus()

      if ::ChildLevel( TMdiFrame() ) != 0 .and. ::oWnd:oWndClient != nil
         ::oWnd:oWndClient:Refresh()
      endif
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TBar

   local hOldPen, n := 1
   local hDarkPen, hLightPen

   ::ColPanUp()

   if ! ::l3D
      Super:Paint()
   else
      hDarkPen  = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNSHADOW ) )
      hLightPen = CreatePen( PS_SOLID, 1, GetSysColor( COLOR_BTNHIGHLIGHT ) )
      BarPaint( ::hWnd, ::hDC )
      if Len( ::aControls ) > 0 .and. ::aControls[ 1 ]:l97Look
         hOldPen = SelectObject( ::hDC, hDarkPen )
         while n <= Len( ::aControls )
            while ! ( Upper( ::aControls[ n ]:ClassName() ) == "TBTNBMP" .and. ;
                      ::aControls[ n ]:lGroup ) .and. n < Len( ::aControls )
               n++
            end
            if Upper( ::aControls[ n ]:ClassName() ) == "TBTNBMP" .and. ::aControls[ n ]:lGroup
               SelectObject( ::hDC, hDarkPen )
               if ::nMode == BAR_TOP .or. ::nMode == BAR_DOWN
                  MoveTo( ::hDC, ::aControls[ n ]:nLeft - ( GROUP_SEP / 2 ) - 1, 2 )
                  LineTo( ::hDC, ::aControls[ n ]:nLeft - ( GROUP_SEP / 2 ) - 1, ::nHeight() - 3 )
                  SelectObject( ::hDC, hLightPen )
                  MoveTo( ::hDC, ::aControls[ n ]:nLeft - ( GROUP_SEP / 2 ), 2 )
                  LineTo( ::hDC, ::aControls[ n ]:nLeft - ( GROUP_SEP / 2 ), ::nHeight() - 3 )
               endif
               if ::nMode == BAR_LEFT .or. ::nMode == BAR_RIGHT
                  MoveTo( ::hDC, 2, ::aControls[ n ]:nTop - ( GROUP_SEP / 2 ) - 1 )
                  LineTo( ::hDC, ::nWidth() - 3, ::aControls[ n ]:nTop - ( GROUP_SEP / 2 ) - 1 )
                  SelectObject( ::hDC, hLightPen )
                  MoveTo( ::hDC, 2, ::aControls[ n ]:nTop - ( GROUP_SEP / 2 ) )
                  LineTo( ::hDC, ::nWidth() - 3, ::aControls[ n ]:nTop - ( GROUP_SEP / 2 ) )
               endif
            end
            n++
         end
         SelectObject( ::hDC, hOldPen )
      endif
      DeleteObject( hDarkPen )
      DeleteObject( hLightPen )
   endif

   ::AEvalWhen()

return nil

//----------------------------------------------------------------------------//

METHOD FloatClick( nRow, nCol, oWnd ) CLASS TBar

   local oMenu
   local lEnd   := .f.

   MENU oMenu POPUP
      MENUITEM "&Arriba"    ACTION ( oWnd:Hide(), AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), lEnd := .t., ::Show(), ::GoTop() )
      MENUITEM "&Izquierda"   ACTION ( oWnd:Hide(), AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), lEnd := .t., ::Show(), ::GoLeft() )
      MENUITEM "&Derecha"  ACTION ( oWnd:Hide(), AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), lEnd := .t., ::Show(), ::GoRight() )
      MENUITEM "A&bajo" ACTION ( oWnd:Hide(), AEval( ::aControls, { | oCtrl | SetParent( oCtrl:hWnd, ::hWnd ) } ), lEnd := .t., ::Show(), ::GoDown() )
   ENDMENU

   ACTIVATE POPUP oMenu AT nRow, nCol OF oWnd

   if lEnd
      oWnd:End()
   endif

return nil

//----------------------------------------------------------------------------//

METHOD Adjust() CLASS TBar

   local oMsgBar := ::oWnd:oMsgBar

   BarAdjust( ::hWnd, ::nMode, oMsgBar != nil,;
              If( oMsgBar != nil, oMsgBar:Height(),) )

return nil

//----------------------------------------------------------------------------//

METHOD SaveIni( cBarName, cFile ) CLASS TBar

   local oIni, n
   local cDatos, cVar

   if Len( ::aControls ) > 0
      INI oIni FILE cFile
         cDatos = cBarName + "," + Str( ::nMode, 1 )
         SET SECTION "ButtonBar" ENTRY "1" OF oIni TO cDatos
         SET SECTION "ButtonBar." + cBarName ENTRY 0 OF oIni TO nil
         for n = 1 To Len( ::aControls )
            cDatos := If( ::aControls[ n ]:cResName1 == nil, "", ::aControls[ n ]:cResName1 ) + "," + ;
                      If( ::aControls[ n ]:cResName2 == nil, "", ::aControls[ n ]:cResName2 ) + "," + ;
                      If( ::aControls[ n ]:cBmpFile1 == nil, "", ::aControls[ n ]:cBmpFile1 ) + "," + ;
                      If( ::aControls[ n ]:cBmpFile2 == nil, "", ::aControls[ n ]:cBmpFile2 ) + "," + ;
                      If( ::aControls[ n ]:cMsg      == nil, "", ::aControls[ n ]:cMsg ) + "," + ;
                      If( ::aControls[ n ]:cAction   == nil, "", ::aControls[ n ]:cAction ) + "," + ;
                      If( ::aControls[ n ]:lGroup, "T", "F" ) + "," + ;
                      If( ::aControls[ n ]:lAdjust, "T", "F" ) + "," + ;
                      If( ::aControls[ n ]:cToolTip  == nil, "", ::aControls[ n ]:cToolTip ) + "," + ;
                      If( ::aControls[ n ]:lPressed, "T", "F" )

           SET SECTION "ButtonBar." + cBarName ENTRY "Button" + ;
             Alltrim( Str( n ) ) OF oIni TO cDatos
         next
      ENDINI

   endif

return nil

//----------------------------------------------------------------------------//