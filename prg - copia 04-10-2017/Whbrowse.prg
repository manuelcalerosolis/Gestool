#include "FiveWin.ch"
#include "WinApi.ch"
#include "Constant.ch"

#define COLOR_BTNFACE         15
#define WM_MBUTTONUP         520
#define WM_LBUTTONDBLCLK     515   // 0x203
#define WM_NOTIFY             78   // 0x4E
#define WM_SETCURSOR          32   // 0x0020
#define GWL_STYLE      -16


#define HDS_HORZ               0
#define HDS_BUTTONS            2
#define HDS_HOTTRACK           4
#define HDS_HIDDEN             8
#define HDS_DRAGDROP          64
#define HDS_FULLDRAG         128
#define HDS_FILTERBAR        256   // 0x100
#define HDS_FLAT             512   // 0x200


#define HDN_FIRST               -300 //(0U-300U)
#define HDN_ITEMCHANGING       (HDN_FIRST-0)
#define HDN_ITEMCHANGED        (HDN_FIRST-1)
#define HDN_ITEMCLICK          (HDN_FIRST-2)
#define HDN_ITEMDBLCLICK       (HDN_FIRST-3)
#define HDN_DIVIDERDBLCLICK    (HDN_FIRST-5)
#define HDN_BEGINTRACK         (HDN_FIRST-6)
#define HDN_ENDTRACK           (HDN_FIRST-7)
#define HDN_TRACK              (HDN_FIRST-8)
#define NM_FIRST               0    // (0U-  0U)
#define NM_RELEASEDCAPTURE     (NM_FIRST-16)

//----------------------------------------------------------------------------//

CLASS TWHeader FROM TControl

   DATA   aItems
   DATA   nColTrack, nColTrackTmp
   DATA   nLastColVertLine
   DATA   lBeginTrack INIT .F.
   DATA   bClicked

   METHOD New( oWnd, nHeight, nRow, oFont, nClrFore, nClrBack ) CONSTRUCTOR
   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD Notify( nIdCtrl, nPtrNMHDR )
   METHOD GetWidth( nCol )

   METHOD Paint()

   METHOD InsertItem( nCol, cCaption, nWidth, nAlign )
   METHOD SetItem( nCol, cCaption, nWidth, nAlign, nSort )
   METHOD DeleteItem( nCol )
   METHOD SetNumCols( nCols )
   METHOD EraseBkGnd( hDC ) INLINE 0
   METHOD Initiate( hDlg )
   METHOD VertLine( nCol, lRelease )


ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oWnd, nHeight, nRow, oFont, nClrFore, nClrBack ) CLASS TWHeader

   local n, oDlg


   DEFAULT oWnd := GetWndDefault(),;
           nClrFore := oWnd:nClrText,;
           nClrBack := GetSysColor( COLOR_BTNFACE ),;
           nHeight := 0,;
           oFont := oWnd:oFont,;
           nRow:= 0


   ::nStyle   := nOR( WS_CHILD, WS_VISIBLE, HDS_HORZ, HDS_BUTTONS, HDS_HOTTRACK, HDS_FULLDRAG )

   ::nId      := ::GetNewId()
   ::oWnd     := oWnd
   ::nTop     := nRow
   ::nLeft    := 0
   ::nHeight  := nHeight
   ::nBottom  := ::nTop + nHeight - 1
   ::nRight   := ::nLeft + oWnd:nWidth - 1
   ::cVarName := ""
   ::aItems   := {}

   ::SetColor( nClrFore, nClrBack )

//   ::Register()

   if ! Empty( oWnd:hWnd )
      ::Create( "SysHeader32" )
      if oFont != nil
         ::SetFont( oFont )
      endif
   else
      ::oFont     = oFont
      oWnd:DefControl( Self )
   endif

   if ! Empty( oWnd:hWnd )
      ::Default()
   endif

   SetWndDefault( oWnd )

return Self

//----------------------------------------------------------------------------//

METHOD Initiate( hDlg ) CLASS TWHeader

   local n

   Super:Initiate( hDlg )

   SetWindowLong( ::hWnd, GWL_STYLE, nOr( WS_CHILD, WS_VISIBLE, HDS_HORZ,;
                  HDS_BUTTONS, HDS_HOTTRACK, HDS_FULLDRAG ) )

return nil

//----------------------------------------------------------------------------//

METHOD Paint() CLASS TWHeader

   CallWindowProc( ::nOldProc, ::hWnd, WM_PAINT, ::hDC, 0 )

return 0

//----------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TWHeader

   local lMChange
   local nWidth, aSizes, nColTrack

   if nMsg == WM_SETCURSOR

      lMChange:= ::oWnd:lMChange
      DEFAULT lMChange:= .T.
      if ::oWnd:aSaveScreen!= nil .or. !lMChange
          return .T.     // Windows NO me cambies el Cursor
      endif

   elseif nMsg == WM_LBUTTONDOWN

      if ::oWnd:aSaveScreen!= nil
          return 0
      endif
      ::bClicked:= {|| ::oWnd:LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ), nWParam ) }
      return nil

   elseif nMsg == WM_LBUTTONDBLCLK

      if ::oWnd:aSaveScreen!= nil
          return 0
      endif
      ::oWnd:LDblClick( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
      return nil

   elseif nMsg == WM_MOUSEMOVE

      if ::oWnd:aSaveScreen!= nil
          return 0
      endif
      if ::lBeginTrack
         ::VertLine( nLoWord( nLParam ) )
      endif
      return nil

   elseif nMsg == WM_PAINT

      ::BeginPaint()
      ::Paint()
      ::EndPaint()

      if ::nColTrack != nil .and. ! ::lBeginTrack
         nColTrack     := ::nColTrack
         ::nColTrack   := nil
         ::nColTrackTmp:= nil
         nWidth:= ::GetWidth( nColTrack ) - 1
         ::oWnd:aColSizes[ nColTrack ]:= nWidth
         if ::oWnd:nFreeze > 0
            aSizes:= ::oWnd:GetColSizes()
            if ::oWnd:aTmpColSizes == Nil
               ::oWnd:aTmpColSizes:= aClone( aSizes )
            else
               ::oWnd:aTmpColSizes[nColTrack]:= nWidth
            endif
         endif
         ::VertLine(,.T.)
         ::oWnd:lSyncH:= .T.
         ::oWnd:lSyncF:= .T.
         ::oWnd:Refresh(.F.)
         SysRefresh()
      endif

      return 0

   endif

return Super:HandleEvent( nMsg, nWParam, nLParam )

//----------------------------------------------------------------------------//

METHOD Notify( nIdCtrl, nPtrNMHDR ) CLASS TWHeader

   local nCode := GetNMHDRCode( nPtrNMHDR )
   local nCol, aSizes, nWidth
   local bClicked, lMChange


   do case

      case nCode == HDN_BEGINTRACK

         nCol:= TWHeaderNotifyPos( nPtrNMHDR )
         lMChange:= ::oWnd:lMChange
         DEFAULT lMChange:= .T.
         if lMChange .and. ::oWnd:lAdjLastCol .and. nCol>=Len(::oWnd:GetColSizes()) // La ultima no se puede Ajustar
            lMChange:= .F.
         endif
         if !lMChange
            return .T.  // --> Windows cancelame el evento.
         endif
         ::lBeginTrack:= .T.
         ::nColTrackTmp:= nCol

      // OJO-> Si Windows tiene configurado on " (*) Mostrar Contenido de Ventana Mientras Arrastra", ejecuta HDN_ITEMCHANGING
      //       sino se ejecuta HDN_TRACK
      case ( nCode == HDN_TRACK .or. nCode == HDN_ITEMCHANGING ) .and. ::lBeginTrack
         ::nColTrack  := ::nColTrackTmp
         if nCode == HDN_TRACK  // Cuando (*) esta off, al arrastrar pinta a veces una linea negra sobre el header/footer
            ::Refresh(.F.)      // Para corregir Bug de Windows (Ver Explorador que lo hace) se fuerza un refresco.
         endif

      case nCode == HDN_ENDTRACK .and. ::lBeginTrack
         ::lBeginTrack:= .F.

      case nCode == HDN_ITEMCLICK .and. ::bClicked != nil

         bClicked:= ::bClicked
         ::bClicked:= nil
         Eval( bClicked )

   endcase

return nil

//----------------------------------------------------------------------------//

METHOD InsertItem( nCol, cCaption, nWidth, nAlign, hBmp ) CLASS TWHeader

   DEFAULT nCol:= Len(::aItems)

   nCol:= Max( 1, nCol )

   if nCol >= Len( ::aItems )
      aAdd( ::aItems, { cCaption, nWidth } )
   else
      aSize( ::aItems, Len(::aItems)+1 )
      aIns( ::aItems, nCol )
      ::aItems[nCol]:= { cCaption, nWidth }
   endif

return TWHeaderAction( 1, ::hWnd, nCol, cCaption, nWidth, nAlign, hBmp )

//----------------------------------------------------------------------------//

METHOD SetItem( nCol, cCaption, nWidth, nAlign, hBmp ) CLASS TWHeader

   if nCol >= 1 .and. nCol <= Len( ::aItems )
       if !(::aItems[nCol,1]==cCaption .and. nWidth==::aItems[nCol,2])
          TWHeaderAction( 2, ::hWnd, nCol, cCaption, nWidth, nAlign, hBmp )
          ::aItems[nCol]:= { cCaption, nWidth }
       endif
   endif

return .T.

//----------------------------------------------------------------------------//

METHOD DeleteItem( nCol ) CLASS TWHeader

  if Len( ::aItems ) <= nCol .and. nCol >= 1
     TWHeaderAction( 3, ::hWnd, nCol )
     aDel( ::aItems, nCol )
     aSize( ::aItems, Len(::aItems)-1 )
  endif

return .T.

//----------------------------------------------------------------------------//

METHOD SetNumCols( nCols ) CLASS TWHeader

  while Len( ::aItems ) > nCols
     ::DeleteItem( Len(::aItems) )
  end
  while Len( ::aItems ) < nCols
     ::InsertItem(, "", 0 )
  end

return nil

//----------------------------------------------------------------------------//

METHOD GetWidth( nCol ) CLASS TWHeader

   if nCol >= 1 .and. nCol <= Len( ::aItems )
      return TWHeaderAction( 4, ::hWnd, nCol )
   endif

return 0

//----------------------------------------------------------------------------//

METHOD VertLine( nCol, lRelease ) CLASS TWHeader

   local oRect, nTop, nBottom, bDraw

   DEFAULT lRelease:= .F.

   if lRelease .and. ::nLastColVertLine == nil
      return nil
   endif

   bDraw:= {|nMCol| InvertRect( ::oWnd:hDC, { nTop, nMCol - 0.5, nBottom, nMCol + 0.5 } ) }
   oRect = ::oWnd:GetRect()

   nBottom:= oRect:nBottom
   if ::oWnd:oHeader != nil
      nTop:=  ::oWnd:nHeaderHeight+1
   endif
   if ::oWnd:oFooter != nil
      nBottom:= oRect:nBottom - (::oWnd:nFooterHeight+2)
   endif
   if lRelease
      if ::nLastColVertLine != nil
         ::oWnd:GetDC()
         Eval( bDraw, ::nLastColVertLine )
         ::nLastColVertLine:= nil
         ::oWnd:ReleaseDC()
      endif
   else
      if ::nLastColVertLine == nil .or. ::nLastColVertLine != nCol
         ::oWnd:GetDC()
         if ::nLastColVertLine != nil
            Eval( bDraw, ::nLastColVertLine )
         endif
         Eval( bDraw, nCol )
         ::nLastColVertLine:= nCol
         ::oWnd:ReleaseDC()
      endif
   endif

return nil

//----------------------------------------------------------------------------//


