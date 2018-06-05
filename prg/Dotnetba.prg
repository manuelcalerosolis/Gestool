#include "fivewin.ch"
#include "oficebar.ch"

// version 1.01 09.12.06
//    No dibujaba la selección de los botones cuando la barra se añadía en MDICHILD
//
// version 1.02 10.12.06
//
//    Para poder añadir controles a la barra y que se redimensionen bien
//
// version 1.03 15.12.06
//
//    Corrije el error al pegar una carpeta en modo diseño
//
// version 1.04 15.12.06
//
//    Error al borrar botones en grupos definidos por líneas
// version 1.05 21.12.06
//
//    Si no caben las solapas se reduce el tamaño de las mismas hasta que quepan
//    Ajustar el tamaño de las solapas para que dibuje "..." si no cabe el texto
//    Añadida la posibilidad de Pintar todas las solapas con el controno DATA lPaintAll
//    Añadidos los métodos de Ocultar y Añadir solapas. Las solapas siguen existiendo pero ocultas


CLASS TDotNetBar FROM TControl

      CLASSDATA lRegistered AS LOGICAL

      DATA oColor
      DATA aCarpetas          AS ARRAY INIT {}
      DATA bChange
      DATA bSelectSolapa
      DATA cName              AS CHARACTER INIT "oBar"
      DATA cResources         AS CHARACTER INIT ""
      DATA cVars              AS CHARACTER INIT ""
      DATA cVersion           AS CHARACTER INIT "00.01"
      DATA lDisenio           AS LOGICAL INIT .F.
      DATA lPrimera           AS LOGICAL INIT .t.
      DATA lWorking           AS LOGICAL INIT .F.
      DATA nClrBorder         AS NUMERIC INIT GRISB
      DATA nClrZonaTab        AS NUMERIC INIT GRIS0
      DATA nHBanda1           AS NUMERIC INIT 19  // Height first ribon
      DATA nHTabs             AS NUMERIC INIT 24  // Tab's hight
      DATA nLeftMargin        AS NUMERIC INIT 50  // Left Margin of first tab
      DATA nMarginTab         AS NUMERIC INIT 15
      DATA nOption            AS NUMERIC INIT  0
      DATA nTopMargin         AS NUMERIC INIT  2  // Top  Margin of first tab
      DATA oBtnCaptured
      DATA oBtnOver
      DATA oGet
      DATA oGrupoOver
      DATA oLast
      DATA oWndPopup
      DATA nRow               AS NUMERIC INIT 0
      DATA nCol               AS NUMERIC INIT 0
      DATA isPopup            AS LOGICAL INIT .F.
      DATA lPaintAll          AS LOGICAL INIT .t.
      DATA oFirstTab

      METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nOption, lDisenio ) CONSTRUCTOR

      METHOD GetCoords() // Solapas

      METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), 0
      METHOD Paint()

      METHOD HandleEvent( nMsg, nWParam, nLParam )

      METHOD LButtonDown( nRow, nCol, nFlags )
      METHOD MouseMove( nRow, nCol, nFlags )
      METHOD LButtonUp( nRow, nCol, nFlags )

      METHOD RButtonDown( nRow, nCol, nFlags )
      METHOD RButtonUp( nRow, nCol, nFlags )

      METHOD LDblClick( nRow, nCol, nFlags )

      METHOD KeyDown( nKey, nFlags )

      METHOD GetOption( nRow, nCol )
      METHOD SetOption( nOption )
      METHOD oOverBtn( nRow, nCol )
      METHOD IsOverVisibleChild( nRow, nCol )

      METHOD ReSize( nType, nWidth, nHeight )
      METHOD LostFocus()
      METHOD oWPLostFocus()
      METHOD oWPEnd()

      METHOD GetText()
      METHOD SetText( cItem )

      METHOD GenPrg()
      METHOD SaveToPrg()
      METHOD LoadFromPrg( cFileName )
      METHOD Paste( cInfo, nLevel )

      METHOD InsertCarpeta( oCarpeta )

      // version 1.05 21.12.06
      METHOD HideFolder( nAbsFolder )  INLINE ::aCarpetas[nAbsFolder]:lHide := .t., ::GetCoords(),::Refresh()
      METHOD ShowFolder( nAbsFolder )  INLINE ::aCarpetas[nAbsFolder]:lHide := .f., ::GetCoords(),::Refresh()

      METHOD SetStyle( nStyle ) INLINE ::oColor:SetStyle( nStyle )
      METHOD SetFirstTab( cText, bAction, aColors )

ENDCLASS


//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, nOption,  lDisenio ) CLASS TDotNetBar

   DEFAULT lDisenio := .f.

   if nTop == nil; nTop := 0; endif
   if nLeft == nil; nLeft := 0; endif
   if nWidth == nil; nWidth := 0; endif
   if nHeight == nil; nHeight := 0; endif
   if nOption == nil; nOption := 0; endif

   ::nTop         := nTop
   ::nLeft        := nLeft
   ::nBottom      := nTop + nHeight
   ::nRight       := nLeft + nWidth
   ::oWnd         := oWnd
   ::lDisenio     := lDisenio
   ::nOption      := nOption

   ::oColor       := TClrStyle():New()

   ::nClrBorder   := ::oColor:_GRISB
   ::nClrZonaTab  := ::oColor:_GRIS0

   ::lVisible     := .f.

   ::nStyle       := nOR( WS_CHILD, WS_VISIBLE, WS_CLIPSIBLINGS, WS_CLIPCHILDREN ) //WS_TABSTOP,
   ::nId          := ::GetNewId()

   ::aControls    := {}

   ::Register( nOr( CS_VREDRAW, CS_HREDRAW ) )


   if empty( oWnd:hWnd )

      oWnd:DefControl( Self )

   else

      ::Create()

      ::lVisible  := .t.

      oWnd:AddControl( Self )

   endif

RETURN self

*****************************************************************************************************
  METHOD GetCoords() CLASS TDotNetBar
*****************************************************************************************************
local hFont
local n
local nLen
local nWidth
local nLeft, nTop, nBottom, nRight

nTop    := ::nTopMargin
nBottom := nTop + ::nHTabs

if ::oFont != nil
   hFont := ::oFont:hFont
else
   hFont := GetStockObject( DEFAULT_GUI_FONT )
endif

if ::oFirstTab != nil
   ::oFirstTab:rcSolapa := { nTop, 4, nBottom, 4 + GetTextWidth( 0, ::oFirstTab:cPrompt, hFont ) + ::nMarginTab }
   ::nLeftMargin := ::oFirstTab:rcSolapa[4]
endif

nLeft   := ::nLeftMargin
nRight  := nLeft

nLen := len( ::aCarpetas )

for n := 1 to nLen

    nLeft  := nRight
    nWidth := GetTextWidth( 0, ::aCarpetas[n]:cPrompt, hFont )
    if ::aCarpetas[n]:lHide
       nWidth := 0
    endif
    if empty( ::aCarpetas[n]:cPrompt )
       nRight := nLeft
    else
       if ::aCarpetas[n]:lHide
          nRight := nLeft
       else
          nRight := nLeft + ::nMarginTab + nWidth + ::nMarginTab
       endif
    endif

    ::aCarpetas[n]:rcSolapa := { nTop, nLeft, nBottom, nRight }

next


RETURN 0


***************************************************************************************************
   METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TDotNetBar
***************************************************************************************************
Local hBrush
local aPoint
local cText

if nMsg == 20 //WM_ERASEBKGND
   RETURN 1
endif

RETURN ::Super:HandleEvent( nMsg, nWParam, nLParam )


***************************************************************************************************
   METHOD Paint() CLASS TDotNetBar
***************************************************************************************************

local nTop, nBottom
local rc := GetClientRect( ::hWnd )
local n, nLen
local hDCMem, hBmpMem
local hOldBmp
local a := {::nRow,::nCol}
local aPoint := {a[1],a[2]}
local oCarpeta
local lSelected

if ::lWorking
   RETURN 0
endif



hDCMem  := CreateCompatibleDC( ::hDC )
hBmpMem := CreateCompatibleBitmap( ::hDC, rc[4], rc[3] )
hOldBmp := SelectObject( hDCMem, hBmpMem )

nLen := len( ::aCarpetas )




nTop    := rc[1]
nBottom := rc[1] + ::nHTabs


// Fondo Solapas generales
   FillSolidRect( hDCMem, rc, ::oColor:_GRIS0 )

   if ::oFirstTab != nil
      ::oFirstTab:PintaSolapa( hDCMem, .t., .f. )
   endif

   for n := 1 to nLen
       oCarpeta := ::aCarpetas[n]
       lSelected := n == ::nOption
       oCarpeta:PintaSolapa( hDCMem, lSelected, PtInRect( aPoint[1], aPoint[2], oCarpeta:rcSolapa ) .and. !lSelected )
   next




   Box( hDCMem, {1, rc[2],rc[3],rc[4]}, ::oColor:_GRISB )
   Box( hDCMem, {2, rc[2],rc[3],rc[4]}, ::oColor:_COLORUNDEF1 )



nTop := nBottom -1
nBottom += ::nHBanda1

// siguiente banda despues de la solapa
   FillSolidRect( hDCMem, {nTop+2,4,nBottom,rc[4]-2}, ::oColor:_GRIS1 )

nTop  := nBottom -1
nBottom := rc[3]

// gradiente del fondo del control
VerticalGradient( hDCMem, {nTop,4,nBottom,rc[4]-1},::oColor:_GRIS2, ::oColor:_GRIS3 )

if !::isPopup

   // Borde de la carpeta
   RoundBox( hDCMem, 3, rc[1] + ::nHTabs,     rc[4]-1, rc[3]-1, ::oColor:nCorner1, ::oColor:nCorner1, ::oColor:_GRISB )

   if ::oColor:nStyle != 1
      RoundBox( hDCMem, 4, rc[1] + ::nHTabs+1,   rc[4]-1, rc[3]-1, ::oColor:nCorner1, ::oColor:nCorner1, ::oColor:_GRISBOX2 )
   endif

endif

for n := 1 to nLen
    ::aCarpetas[n]:Paint( hDCMem )   //, n == ::nOption
next

BitBlt( ::hDC, 0, 0, rc[4], rc[3], hDCMem, 0, 0, SRCCOPY )

SelectObject( hDCMem, hOldBmp )
DeleteObject( hBmpMem )
DeleteDC( hDCMem )

RETURN 0


***************************************************************************************************
   METHOD LButtonDown( nRow, nCol, nFlags ) CLASS TDotNetBar
***************************************************************************************************
local nOption := ::GetOption( nRow, nCol )
local lRet
local hChild := ::IsOverVisibleChild( nRow, nCol )

if hChild != nil
   SetFocus( hChild )
   SendMessage( hChild, WM_LBUTTONDOWN, nMakeLong( nCol, nRow ), 0 )
   RETURN 1
endif

//if ::oWndPopup != nil
   SetFocus( ::hWnd )
//endif

::oBtnCaptured := ::oOverBtn( nRow, nCOl )

if ::oBtnCaptured != nil .and. !::oBtnCaptured:lEnabled
   ::oBtnCaptured := nil
endif

::lCaptured := .t.
::Capture()

if ::oBtnCaptured != nil
   ::Refresh()
endif


RETURN 0

***************************************************************************************************
   METHOD LButtonUp( nRow, nCol, nFlags ) CLASS TDotNetBar
***************************************************************************************************

   local nOption := ::GetOption( nRow, nCol )
   local lRet
   local oGrupo
   local oPopup
   local aPoint

   ReleaseCapture()

   ::lCaptured := .f.

   if ::nOption != 0 .and. len( ::aCarpetas ) > 0 // .and. ::oBtnCaptured == nil

      oGrupo   := ::aCarpetas[::nOption]:oGrupoOver( nRow, nCol )

      if oGrupo != nil .and. oGrupo:bSelected != nil
         eval( oGrupo:bSelected, oGrupo )
      endif

   endif

   if ::oFirstTab != nil

      if PtInRect( nRow, nCol, ::oFirstTab:rcSolapa )

         if ::oFirstTab:bAction != nil

            aPoint := {::oFirstTab:rcSolapa[3], ::oFirstTab:rcSolapa[2]}
            //ClientToScreen( ::hWnd, aPoint )
            nRow    := aPoint[1]
            nCol    := aPoint[2]

            RETURN eval( ::oFirstTab:bAction, nRow, nCol )

         endif

      endif

   endif

   if nOption != 0 .and. ::nOption != nOption // estoy sobre una solapa - I am over a label

      ::SetOption( nOption )

      ::Resize()

      if ::bChange != nil
         eval( ::bChange, self )
      endif

   else

      // usar solo para diseñar // use only for design

      if ::oBtnCaptured != nil .and. ::oBtnCaptured:bSelect != nil
         eval( ::oBtnCaptured:bSelect, ::oBtnCaptured )
      endif

      // Am I over a button? - ¿estoy sobre un botón?
      // msgInfo( ::oBtnCaptured != nil .and. ::oBtnCaptured:bAction != nil,   "::oBtnCaptured:bAction != nil" )
      // msgInfo( ::oBtnCaptured != nil .and. ::oBtnCaptured:oPopup != nil,    "::oBtnCaptured:oPopup != nil" )
      // msgInfo( ::oBtnCaptured != nil .and. Empty( ::oBtnCaptured:oPopup ),  "Empty( ::oBtnCaptured:oPopup )" )

      if ( oGrupo != nil .and. !oGrupo:lAgrupado ) .and.;
         ::oBtnCaptured != nil                     .and.;
         ::oBtnCaptured:IsOver( nRow, nCol )       .and.;
         ::oBtnCaptured:lEnabled                   .and.;
         ( ::oBtnCaptured:bAction != nil .or. ::oBtnCaptured:oPopup != nil )

         ::Refresh()

         if ::oBtnCaptured:oPopup != nil

            ::oWnd:NcMouseMove() // close the tooltip
            ::oWnd:oPopup := ::oBtnCaptured:oPopup
            ::oWnd:oPopup:Activate( ::oBtnCaptured:nTop + ::oBtnCaptured:nHeight(), ::oBtnCaptured:nLeft, ::oWnd, .f. )
            ::oWnd:oPopup := nil

         else

            if ::isPopup
               ::oWnd:Hide()
            endif

            ::Disable() // Añadido por MCS

            Eval( ::oBtnCaptured:bAction, ::oBtnCaptured )

            ::Enable()  // Añadido por MCS

            if ::isPopup
               ::oWnd:End()
            endif

         endif

      else

         if oGrupo != nil

            if oGrupo:IsOverAcc( nRow, nCol )

               if oGrupo:bAction != nil
                  eval( oGrupo:bAction, oGrupo )
               end if

            else

               oGrupo:ClonGrupo( nRow, nCol )

            endif

         endif

      endif

   endif

   ::oBtnCaptured    := nil

   ::Refresh()

RETURN 0

***************************************************************************************************
   METHOD RButtonDown( nRow, nCol, nFlags ) CLASS TDotNetBar
***************************************************************************************************

local nOption := ::GetOption( nRow, nCol )
local lRet
local hChild := ::IsOverVisibleChild( nRow, nCol )

if hChild != nil
   SetFocus( hChild )
   SendMessage( hChild, WM_RBUTTONDOWN, nMakeLong( nCol, nRow ), 0 )
   RETURN 1
endif

   SetFocus( ::hWnd )

   ::oBtnCaptured := ::oOverBtn( nRow, nCOl )

   if ::oBtnCaptured != nil .and. !::oBtnCaptured:lEnabled
      ::oBtnCaptured := nil
   endif

   ::lCaptured := .t.
   ::Capture()

   if ::oBtnCaptured != nil
      ::Refresh()
   endif

RETURN 0

***************************************************************************************************
   METHOD RButtonUp( nRow, nCol, nFlags ) CLASS TDotNetBar
***************************************************************************************************

   local nOption := ::GetOption( nRow, nCol )
   local lRet
   local oGrupo
   local oPopup
   local aPoint

   ReleaseCapture()

   ::lCaptured := .f.

   // msgInfo( ::oBtnCaptured != nil .and. ::oBtnCaptured:bAction != nil,   "::oBtnCaptured:bAction != nil" )
   // msgInfo( ::oBtnCaptured != nil .and. ::oBtnCaptured:oPopup != nil,    "::oBtnCaptured:oPopup != nil" )
   // msgInfo( ::oBtnCaptured != nil .and. Empty( ::oBtnCaptured:oPopup ),  "Empty( ::oBtnCaptured:oPopup )" )

   if ::oBtnCaptured != nil                     .and.;
      ::oBtnCaptured:IsOver( nRow, nCol )       .and.;
      ::oBtnCaptured:lEnabled                   .and.;
      ::oBtnCaptured:bRAction != nil

      ::Refresh()

      ::Disable() // Añadido por MCS
         Eval( ::oBtnCaptured:bRAction, ::oBtnCaptured )
      ::Enable()  // Añadido por MCS

   endif

   ::oBtnCaptured    := nil

   ::Refresh()

RETURN 0

***************************************************************************************************
   METHOD MouseMove( nRow, nCol, nFlags ) CLASS TDotNetBar
***************************************************************************************************
local nOption := ::GetOption( nRow, nCol )
local oCarpeta, oGrupo
local n, n2
local nLen, nLen2
local lFind := .f.
local oLastGrupo := ::oGrupoOver

if ::lWorking
   RETURN 0
endif

::nRow := nRow
::nCol := nCol

if !IsOverWnd(::hWnd, nRow, nCol ) .and. GetCapture() == ::hWnd
   ::Refresh()
   ReleaseCapture()
else
   ::Capture()
endif


if nOption != 0 .or. ( ::oFirstTab != nil .and. PtInRect( nRow, nCol, ::oFirstTab:rcSolapa ) )
   CursorHand()
   ::Refresh()
else
   CursorArrow()
endif

if ::nOption != 0

   oCarpeta := ::aCarpetas[::nOption]

   nLen := len( oCarpeta:aGrupos )

   for n := 1 to nLen

       if n > len( oCarpeta:aGrupos ) // en modo diseño al borrar un grupo no le da tiempo a actualizar
          exit                        // el tamaño del array y ya ha entrado un mensaje wm_mousemove
       endif

       oGrupo := oCarpeta:aGrupos[n]

       if oGrupo:IsOver( nRow, nCol )

          ::oBtnOver := oGrupo:oBtnOver( nRow, nCol )

          ::oGrupoOver := oGrupo

          if oGrupo:IsOverAcc( nRow, nCol ) .and. oGrupo:bAction != nil
             CursorHand()
          endif

          nLen2 := len( ::oGrupoOver:aItems )

          for n2 := 1 to nLen2

              if "TDOTNET" $ oGrupo:aItems[n2]:ClassName()

                 if oGrupo:aItems[n2]:IsOver( nRow, nCol )

                    ::Refresh()

                    if ::oBtnCaptured == nil
                       ::oBtnCaptured := oGrupo:aItems[n2]
                    endif

                    // msgStop( Valtype( ::oBtnCaptured ), "Valtype( ::oBtnCaptured )" )

                    //if ::oLast != nil .and. ::oLast:nID != oGrupo:aItems[n2]:nID
                    //   ::Refresh()
                    //   ::oLast := oGrupo:aItems[n2]
                    //   lFind := .t.
                    //   exit
                    //endif

                 endif

              endif

          next

          if lFind
             exit
          endif

          if ::oLast != nil
             ::oLast := nil
             ::Refresh()
          endif

       else
          ::oGrupoOver := nil
       endif

       if oLastGrupo == nil
          if ::oGrupoOver != nil
             ::Refresh()
             //SysRefresh()
          endif
       else
          if ::oGrupoOver != nil .and. ::oGrupoOver:nID != oLastGrupo:nID
             ::Refresh()
             //SysRefresh()
          endif
       endif

   next

   if !lFind
      ::oLast := nil
   endif

endif

RETURN 0



***************************************************************************************************
  METHOD GetOption( nRow, nCol ) CLASS TDotNetBar
***************************************************************************************************
local nOption := 0
local n
local nLen := len(::aCarpetas)
local oCarpeta

for n := 1 to nLen
    oCarpeta := ::aCarpetas[n]
    if oCarpeta:IsOverSolapa( nRow, nCol )
       nOption := n
       exit
    endif
next

RETURN nOption


***************************************************************************************************
  METHOD SetOption( nOption ) CLASS TDotNetBar
***************************************************************************************************

   ::nOption := nOption


RETURN nOption


***************************************************************************************************
  METHOD oOverBtn( nRow, nCol ) CLASS TDotNetBar
***************************************************************************************************

local oCarpeta, oGrupo
local n, n2
local nLen, nLen2

if ::nOption != 0

   oCarpeta := ::aCarpetas[::nOption]

   nLen := len( oCarpeta:aGrupos )

   for n := 1 to nLen

       oGrupo := oCarpeta:aGrupos[n]

       if oGrupo != nil .and. !oGrupo:lAjustado

          if !::lCaptured

             if oGrupo:IsOver( nRow, nCol )
                ::oGrupoOver := oGrupo
                StartTrackMouseLeave(::hWnd)
             else
                ::oGrupoOver := nil
             endif

          endif

          nLen2   := len( oGrupo:aItems )

          for n2 := 1 to nLen2

             if "TDOTNET" $ oGrupo:aItems[n2]:ClassName()
                 if oGrupo:aItems[n2]:IsOver( nRow, nCol )
                    RETURN oGrupo:aItems[n2]
                 endif
             endif

          next

       endif

   next

endif

RETURN nil


***************************************************************************************************
  METHOD IsOverVisibleChild( nRow, nCol ) CLASS TDotNetBar
***************************************************************************************************
local n, nLen, oControl

nLen := len( ::aControls )

   for n := 1 to nLen
       oControl := ::aControls[n]
       if IsWindowVisible( oControl:hWnd ) .and. PtInRect( nRow, nCol, GetCoors( oControl:hWnd ) )
          RETURN oControl:hWnd
       endif
   next

RETURN nil



***************************************************************************************************
  METHOD KeyDown( nKey, nFlags ) CLASS TDotNetBar
***************************************************************************************************
local lControl := GetKeyState( VK_CONTROL )
local lShift   := GetKeyState( VK_SHIFT )
local nOption  := ::nOption
local nLen     := len( ::aCarpetas )
local nOld     := ::nOption

do case
   case nKey == VK_TAB

        if nLen == 0
           RETURN 0
        endif
        if lControl
           do while .t.
              if lShift
                 nOption --
              else
                 nOption ++
              endif
              if nOption <= 0
                 nOption := nLen
              endif
              if nOption > nLen
                 nOption := 1
              endif
              if !::aCarpetas[nOption]:lHide .or. nOption == nOld
                 exit
              endif
           enddo
           ::SetOption( nOption )
           ::Refresh()
        endif

    case nKey == VK_RETURN

         if ::lDisenio
            ::aCarpetas[::nOption]:Edit()
         endif

    case nKey == VK_ADD

         if ::lDisenio
            if len( ::aCarpetas ) == 0 .or. ::nOption == 0
               TCarpeta():New( self, "cItem" )
            else
               TDotNetGroup():New( ::aCarpetas[::nOption], 200, "cItem"  )
            endif
            ::Refresh()
         endif

    case nKey == VK_ESCAPE

         if ::IsPopup
            ::oWnd:End()
         endif


endcase

RETURN 0

***************************************************************************************************
   METHOD ReSize( nType, nWidth, nHeight ) CLASS TDotNetBar
***************************************************************************************************

   local n
   local nLen
   local oCarpeta
   local oGrupo
   local lFin := .f.
   local lCabenTodos := .f.
   local nW
   local n2
   local nTotalW := 0
   local nRealHasta := 0
   local nLeft
   local rc := GetClientRect(::hWnd)
   local rc2 := GetClientRect( ::oWnd:hWnd )
   local nInc := 0
   local lResize := .f.
   // version 1.05 21.12.06


   ::Super:ReSize( nType, nWidth, nHeight )

   nWidth := rc[4]-rc[2]

   nW := nWidth

    // version 1.05 21.12.06
    ::GetCoords()
    nLen := len( ::aCarpetas )
    if nLen > 2
       do while ::aCarpetas[nLen]:rcSolapa[4] > rc2[4]
          lResize := .t.
          nInc := 1
          for n := 1 to nLen
              if n > 1
                 ::aCarpetas[n]:rcSolapa[2] := ::aCarpetas[n-1]:rcSolapa[4]
              endif
              ::aCarpetas[n]:rcSolapa[4] := ::aCarpetas[n]:rcSolapa[4]-nInc
              nInc++
          next
       enddo
    endif

   if ::nOption == 0
       if lResize
          ::Refresh()
       endif
      RETURN 0
   endif

   oCarpeta := ::aCarpetas[::nOption]
   oGrupo   := atail( oCarpeta:aGrupos )

   if oGrupo == nil
      if lResize
         ::Refresh()
      endif

      RETURN 0
   endif

   nLen := len( oCarpeta:aGrupos )

   for n := 1  to nLen
       oCarpeta:aGrupos[n]:nWidth = oCarpeta:aGrupos[n]:aSize[1]
   next

   oCarpeta:CalcSizes()

   if oCarpeta:aGrupos[ nLen ]:nRight > nW
      // no caben todos
      // voy quitando de atras hacia alante hasta que quepan
      for n := nLen to 1 step -1

          if len(oCarpeta:aGrupos[n]:aItems) != 1
             oCarpeta:aGrupos[n]:nWidth = max( 50, oCarpeta:aGrupos[n]:SizeCapSm()[1] )
          endif

          oCarpeta:CalcSizes()

          if oCarpeta:aGrupos[ nLen ]:nRight < nW
             oCarpeta:aGrupos[ nLen ]:lAgrupado   := .t.
             oCarpeta:lAjustados                  := .t.
             exit
          else
             oCarpeta:aGrupos[ nLen ]:lAgrupado   := .f.
          endif

       next
    else
       oCarpeta:lAjustados := .f.
    endif

    oCarpeta:CalcSizes()

    ::Refresh()

RETURN 0

***************************************************************************************************
   METHOD LostFocus() CLASS TDotNetBar
***************************************************************************************************

if ::IsPopup
   ::oWPEnd()
endif

RETURN ::Super:LostFocus()

***********************************************************************************************************************
   METHOD oWPLostFocus() CLASS TDotNetBar
***********************************************************************************************************************

if ::oWndPopup != nil .and. GetParent(GetFocus()) != ::oWndPopup:hWnd

   ::oWPEnd()

endif

RETURN .t.

***********************************************************************************************************************
   METHOD oWPEnd() CLASS TDotNetBar
***********************************************************************************************************************


   ::bValid := {||.t.}
   ::End()


RETURN 0

#define IMAGE_BITMAP        0

#define LR_DEFAULTCOLOR     0x0000
#define LR_MONOCHROME       0x0001
#define LR_COLOR            0x0002
#define LR_COPYRETURNORG    0x0004
#define LR_COPYDELETEORG    0x0008
#define LR_LOADFROMFILE     0x0010
#define LR_LOADTRANSPARENT  0x0020
#define LR_DEFAULTSIZE      0x0040
#define LR_VGACOLOR         0x0080
#define LR_LOADMAP3DCOLORS  0x1000
#define LR_CREATEDIBSECTION 0x2000
#define LR_COPYFROMRESOURCE 0x4000
#define LR_SHARED           0x8000



***********************************************************************************************
    METHOD GetText() CLASS TDotNetBar
***********************************************************************************************

if ::nOption != 0
   RETURN ::aCarpetas[::nOption]:cPrompt
endif

RETURN ""

***********************************************************************************************
    METHOD SetText( cItem ) CLASS TDotNetBar
***********************************************************************************************
local cText := ""

if ::nOption != 0
   ::aCarpetas[::nOption]:cPrompt := cItem
   cText := cItem
   ::GetCoords()
endif

RETURN cText

***********************************************************************************************
   METHOD LDblClick( nRow, nCol, nFlags ) CLASS TDotNetBar
***********************************************************************************************
local n
local nLen := len( ::aCarpetas )
local oCarpeta
local oGrupo
local oBtn

if !::lDisenio
   RETURN 0
endif

if nLen == 0
   RETURN 0
endif

for n := 1 to nLen
    oCarpeta := ::aCarpetas[n]
    if oCarpeta:IsOverSolapa( nRow, nCol )
       RETURN oCarpeta:Edit()
    endif
next

if ::nOption == 0
   RETURN 0
endif

oCarpeta := ::aCarpetas[::nOption]

oGrupo := oCarpeta:oGrupoOver( nRow, nCol )

if oGrupo == nil
   RETURN nil
endif

oBtn := oGrupo:oBtnOver( nRow, nCol )

if oBtn != nil
   oBtn:Edit()
else
   oGrupo:Edit()
endif


RETURN nil


***********************************************************************************************
   METHOD GenPrg() CLASS TDotNetBar
***********************************************************************************************
local cPrg := CRLF + CRLF
local n
local nCarpetas

::cVars := '#include "fivewin.ch"' + CRLF + CRLF
::cVars += "function main()" + CRLF
::cVars += "local oWnd" + CRLF

if ::cName == nil; ::cName := "oBar" ; endif

  ::cVars += "local " + ::cName + CRLF
  ::cVars += "local oMenu, bWhen, oIL" + CRLF + CRLF

  cPrg += "DEFINE WINDOW oWnd" + CRLF + CRLF

  cPrg += "//Inicio Definición" + CRLF + CRLF

  cPrg += space(7) + ::cName + " := TDotNetBar():New( 0, 0, 1000, 120, oWnd, " + alltrim(str(::nOption)) +;
            " )" + CRLF + CRLF

  cPrg += space(7) + "oWnd:oTop := oBar" + CRLF + CRLF

  nCarpetas := len( ::aCarpetas )

  for n := 1 to nCarpetas

      cPrg += ::aCarpetas[n]:GenPrg()

  next

  cPrg += "//Fin Definición" + CRLF + CRLF

  cPrg := ::cVars + CRLF + cPrg

  ::cVars := ""

  cPrg += "ACTIVATE WINDOW oWnd" + CRLF + CRLF
  cPrg += "RETURN nil" + CRLF + CRLF


RETURN cPrg


////////////////////////////////////////////////////////////////////////////////////////////////
  static function str4( nVal ) ; RETURN str(nVal,4)
////////////////////////////////////////////////////////////////////////////////////////////////

***********************************************************************************************
   METHOD SaveToPrg( cFileName ) CLASS TDotNetBar
***********************************************************************************************

if cFileName == nil
   cFileName := cGetFile( "*.prg","Guardar imagen como...", 1, , .t. )
endif

if empty( cFileName)
   MsgInfo("Proceso cancelado")
   RETURN 0
endif

if lower(right(cFileName,4 ) ) != ".prg"
   if at(".",cFileName) == 0
      cFileName += ".prg"
   endif
endif

if file( cFileName )
   if !ApoloMsgNoYes( "El fichero" + CRLF + cFileName + CRLF + "Ya existe" + CRLF + CRLF + "¿Desea sobreescribirlo?")
      MsgInfo("Proceso cancelado")
      RETURN 0
   endif
endif

DeleteFile( cFileName )

MemoWrit( cFileName ,::GenPrg())

//ShellExecute( GetActiveWindow() ,nil, cFileName ,'','',5)

RETURN 0


***********************************************************************************************
   METHOD LoadFromPrg( cFileName ) CLASS TDotNetBar
***********************************************************************************************
local cInfo
local aLines := {}
local nLines
local n := 1
local n2
local nEstado := BUSCANDO
local cLinea
local aParams := {}
local cWord
local cObject
local aWords := {{"tdotnetbar():new("   ,PARSEANDO_BAR    },;
                 {"tcarpeta():new("     ,PARSEANDO_CARPETA},;
                 {"tdotnetgroup():new(" ,PARSEANDO_GRUPO  },;
                 {"tdotnetbutton():new(",PARSEANDO_BUTTON } }
local cBar
local aCarpetas := {}
local aGrupos   := {}
local o
local lDefinida := .f.
local oError
local cLine
local lPuntoYComa := .f.
local nLen

if cFileName == nil
   cFileName := cGetFile( "*.prg","Seleccione fichero", 1,  )
endif

if empty( cFileName )
   MsgInfo("Proceso cancelado")
   RETURN 0
endif

cInfo := memoread( cFileName )

::Paste( cInfo )

/*
if at("tdotnetbar", lower( cInfo ) ) == 0
   MsgStop( "No se encontró la definición de TDotNetBar","Atención")
   RETURN 0
endif

nLines := strcount( cInfo, CRLF )

for n := 1 to nLines

    if lPuntoYComa
       cLine := substr( cLine, 1, len( cLine )-1) + alltrim(memoline( cInfo,255,n))
    else
       cLine := alltrim(memoline( cInfo,255,n))
    endif
    if empty( cLine )
       loop
    endif

    if right( cLine, 1 ) == ";"
       lPuntoYcoma := .t.
       loop
    else
       lPuntoYcoma := .f.
    endif
    aadd( aLines, cLine )

next

n := 1

aSize( ::aCarpetas, 0 )
::nOption := 0
::Refresh()

nLines := len( aLines )

do while n < nLines .and. nEstado != FIN

    cLinea := alltrim(aLines[n])
    cLinea := strtran(cLinea,'"',"")

    if left( lower(cLinea), len( "local "   )) == "local "   ; cLinea := substr( cLinea, len( "local "   )+1); endif
    if left( lower(cLinea), len( "private " )) == "private " ; cLinea := substr( cLinea, len( "private " )+1); endif
    if left( lower(cLinea), len( "public "  )) == "public "  ; cLinea := substr( cLinea, len( "public "  )+1); endif

    nEstado := BUSCANDO

    cWord := ""

    for n2 := 1 to len( aWords )
        cWord := lower(aWords[n2,1])
        if at( cWord, lower(cLinea) ) != 0
           nEstado := aWords[n2,2]
           exit
        endif
    next

       if nEstado != BUSCANDO

          asize( aParams, 0 )

          cObject := left  ( cLinea, at(":=",cLinea)-1 )
          cLinea  := substr( cLinea, at( lower(cWord), lower(cLinea) )+len(cWord)+1 )
          cLinea  := left  ( cLinea, len( cLinea ) - 1 )
          aParams := aSplit( cLinea, "," )
          do case
             case nEstado == PARSEANDO_BAR

                  if lDefinida
                     nEstado := FIN
                  else

                     ::nOption := val( aParams[6] )
                     lDefinida := .t.

                  endif

             case nEstado == PARSEANDO_CARPETA

                  aadd( aCarpetas, {cObject, TCarpeta():New( self, aParams[2] )} )

             case nEstado == PARSEANDO_GRUPO

                     o := GetMyObject( aCarpetas, aParams[1] )
                     nLen := 12-len( aParams )
                     for n2 := 1 to nLen
                         aadd( aParams, nil )
                     next n2
                     if aParams[ 1] == nil; aParams[ 1] :=  "200"   ;endif
                     if aParams[ 2] == nil; aParams[ 2] :=  o       ;endif
                     if aParams[ 3] == nil; aParams[ 3] :=  ""      ;endif
                     if aParams[ 4] == nil; aParams[ 4] :=  ".f."   ;endif
                     if aParams[ 5] == nil; aParams[ 5] :=  {||.t.} ;endif
                     if aParams[ 6] == nil; aParams[ 6] :=  ""      ;endif

                     o := TDotNetGroup():New( o                       ,;
                                              val( aParams[2])        ,;
                                              aParams[3]              ,;
                                              lower(aParams[4])==".t.",;
                                              nil                     ,;
                                              aParams[6] )
                     aadd( aGrupos, {cObject, o } )

             case nEstado == PARSEANDO_BUTTON

                     o := GetMyObject( aGrupos, aParams[2] )
                     nLen := 12-len( aParams )
                     for n2 := 1 to nLen
                         aadd( aParams, nil )
                     next n2


                     if aParams[ 1] == nil; aParams[ 1] :=   "60"   ;endif
                     if aParams[ 2] == nil; aParams[ 2] :=  o       ;endif
                     if aParams[ 3] == nil; aParams[ 3] :=  ""      ;endif
                     if aParams[ 4] == nil; aParams[ 4] :=  ""      ;endif
                     if aParams[ 5] == nil; aParams[ 5] :=  "1"     ;endif
                     if aParams[ 6] == nil; aParams[ 6] :=  {||.t.} ;endif
                     if aParams[ 7] == nil; aParams[ 7] :=  nil     ;endif
                     if aParams[ 8] == nil; aParams[ 8] :=  {||.t.} ;endif
                     if aParams[ 9] == nil; aParams[ 9] :=  ".f."   ;endif
                     if aParams[10] == nil; aParams[10] :=  ".f."   ;endif
                     if aParams[11] == nil; aParams[11] :=  ".f."   ;endif
                     if aParams[12] == nil; aParams[12] :=  ""      ;endif

                     o := TDotNetButton():New( val( aParams[1])         ,;
                                               o                        ,;
                                               alltrim( aParams[3])      ,;
                                               alltrim( aParams[4])      ,;
                                               val(     aParams[5]), , ,     ,;
                                               lower(   aParams[9])==".t." ,;
                                               lower(   aParams[10])==".t.",;
                                               lower(   aParams[11])==".t.",;
                                               alltrim( aParams[12]) )
          endcase

       endif


    n++


enddo

::Refresh()

*/
RETURN 0

/*
***********************************************************************************************
   METHOD Paste( objEn ) CLASS TDotNetBar
***********************************************************************************************
local cInfo
local aLines := {}
local nLines
local n := 1
local n2
local nEstado := BUSCANDO
local cLinea
local aParams := {}
local cWord
local cObject
local aWords := {{"tcarpeta():new("     ,PARSEANDO_CARPETA},;
                 {"tdotnetgroup():new(" ,PARSEANDO_GRUPO  }    ,;
                 {"tdotnetbutton():new(",PARSEANDO_BUTTON } }
local cBar
local aCarpetas := {}
local aGrupos   := {}
local o
local lDefinida := .f.
local oError
local oClp
local lPuntoYComa := .f.
local cLine


   DEFINE CLIPBOARD oClp OF Self FORMAT TEXT

   if oClp:Open()
      cInfo := oClp:GetText()
      oClp:End()
   else
      msgStop( "The clipboard is not available now!" )
   endif


if empty( cInfo )
   MsgInfo("Proceso cancelado")
   RETURN 0
endif

nLines := strcount( cInfo, CRLF )

for n := 1 to nLines

    if lPuntoYComa
       cLine := substr( cLine, 1, len( cLine )-1) + alltrim(memoline( cInfo,255,n))
    else
       cLine := alltrim(memoline( cInfo,255,n))
    endif
    if empty( cLine )
       loop
    endif

    if right( cLine, 1 ) == ";"
       lPuntoYcoma := .t.
       loop
    else
       lPuntoYcoma := .f.
    endif
    aadd( aLines, cLine )
next

n := 1

do while n < nLines .and. nEstado != FIN

    cLinea := alltrim(aLines[n])
    cLinea := strtran(cLinea,'"',"")

    if left( lower(cLinea), len( "local "   )) == "local "   ; cLinea := substr( cLinea, len( "local "   )+1); endif
    if left( lower(cLinea), len( "private " )) == "private " ; cLinea := substr( cLinea, len( "private " )+1); endif
    if left( lower(cLinea), len( "public "  )) == "public "  ; cLinea := substr( cLinea, len( "public "  )+1); endif


    nEstado := BUSCANDO

    cWord := ""

    for n2 := 1 to len( aWords )
        cWord := lower(aWords[n2,1])
        if at( cWord, lower(cLinea) ) != 0
           nEstado := aWords[n2,2]
           exit
        endif
    next

       if nEstado != BUSCANDO

          asize( aParams, 0 )

          cObject := left  ( cLinea, at(":=",cLinea)-1 )
          cLinea  := substr( cLinea, at( lower(cWord), lower(cLinea) )+len(cWord)+1 )
          cLinea  := left  ( cLinea, len( cLinea ) - 1 )
          aParams := aSplit( cLinea, "," )


          do case
             case nEstado == PARSEANDO_BAR

                  if lDefinida
                     nEstado := FIN
                  else
                     //( nTop, nLeft, nWidth, nHeight, oWnd, nOption, cILBig, cILSmall, lDisenio )
                     //wqout( aParams )
                     ::nOption := val( aParams[6] )

                     lDefinida := .t.
                  endif
             case nEstado == PARSEANDO_CARPETA
                  // ( oWnd, cText )

                  aadd( aCarpetas, {cObject, TCarpeta():New( self, aParams[2] )} )

             case nEstado == PARSEANDO_GRUPO
                  // ( oCarpeta, nWidth, cPrompt, lByLines, bAction, cBmpClosed )

                     o := GetMyObject( aCarpetas, aParams[1] )
                     o := TDotNetGroup():New( o,;
                                              val( aParams[2]),;
                                              aParams[3],;
                                              lower(aParams[4])==".t.",;
                                              nil,;
                                              aParams[6] )
                     aadd( aGrupos, {cObject, o } )

             case nEstado == PARSEANDO_BUTTON
                  //( nTop, nLeft, nWidth, nHeight, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd )
                  //  nWidth, oGroup, cBmp, cCaption, nColumna, bAction, oMenu, bWhen, lGrouping, lHead, lEnd

                     o := GetMyObject( aGrupos, aParams[2] )       //wqout( aParams )
                     o := TDotNetButton():New( val( aParams[1]),;
                                               o,;
                                               alltrim(aParams[3]),;
                                               alltrim(aParams[4]),;
                                               val(aParams[5]), , , ,;
                                               lower(aParams[9])==".t.",;
                                               lower(aParams[10])==".t.",;
                                               lower(aParams[11])==".t." )
          endcase

       endif


    n++


enddo

::Refresh()


RETURN 0
*/


***********************************************************************************************
   METHOD Paste( cInfo, nLevel ) CLASS TDotNetBar
***********************************************************************************************
local aLines := {}
local nLines
local n := 1
local n2
local nEstado := BUSCANDO
local cLinea
local aParams := {}
local cWord
local cObject
local aWords := {{"tdotnetbar():new("   ,PARSEANDO_BAR    },;
                 {"tcarpeta():new("     ,PARSEANDO_CARPETA},;
                 {"tdotnetgroup():new(" ,PARSEANDO_GRUPO  },;
                 {"tdotnetbutton():new(",PARSEANDO_BUTTON } }
local cBar
local aCarpetas := {}
local aGrupos   := {}
local o
local lDefinida := .f.
local oError
local cLine
local lPuntoYComa := .f.
local nLen

DEFAULT nLevel := PARSEANDO_BAR

if nLevel == 1
   if at("tdotnetbar", lower( cInfo ) ) == 0
      MsgStop( "No se encontró la definición de TDotNetBar","Atención")
      RETURN 0
   endif
endif

nLines := strcount( cInfo, CRLF )

for n := 1 to nLines

    if lPuntoYComa
       cLine := substr( cLine, 1, len( cLine )-1) + alltrim(memoline( cInfo,255,n))
    else
       cLine := alltrim(memoline( cInfo,255,n))
    endif
    if empty( cLine )
       loop
    endif

    if right( cLine, 1 ) == ";"
       lPuntoYcoma := .t.
       loop
    else
       lPuntoYcoma := .f.
    endif
    aadd( aLines, cLine )

next

n := 1
// revision 15.12.06     V1.03
if nLevel == PARSEANDO_BAR
   aSize( ::aCarpetas, 0 )
   ::nOption := 0
   ::Refresh()
endif

nLines := len( aLines )

do while n < nLines .and. nEstado != FIN

    cLinea := alltrim(aLines[n])
    cLinea := strtran(cLinea,'"',"")

    if left( lower(cLinea), len( "local "   )) == "local "   ; cLinea := substr( cLinea, len( "local "   )+1); endif
    if left( lower(cLinea), len( "private " )) == "private " ; cLinea := substr( cLinea, len( "private " )+1); endif
    if left( lower(cLinea), len( "public "  )) == "public "  ; cLinea := substr( cLinea, len( "public "  )+1); endif

    nEstado := BUSCANDO

    cWord := ""

    for n2 := nLevel to len( aWords )
        cWord := lower(aWords[n2,1])
        if at( cWord, lower(cLinea) ) != 0
           nEstado := aWords[n2,2]
           exit
        endif
    next

       if nEstado != BUSCANDO

          asize( aParams, 0 )

          cObject := left  ( cLinea, at(":=",cLinea)-1 )
          cLinea  := substr( cLinea, at( lower(cWord), lower(cLinea) )+len(cWord)+1 )
          cLinea  := left  ( cLinea, len( cLinea ) - 1 )
          aParams := aSplit( cLinea, "," )
          do case
             case nEstado == PARSEANDO_BAR

                  if lDefinida
                     nEstado := FIN
                  else

                     ::nOption := val( aParams[6] )
                     lDefinida := .t.

                  endif

             case nEstado == PARSEANDO_CARPETA

                  aadd( aCarpetas, {cObject, TCarpeta():New( self, aParams[2] )} )

             case nEstado == PARSEANDO_GRUPO

                     o := GetMyObject( aCarpetas, aParams[1] )
                     nLen := 12-len( aParams )
                     for n2 := 1 to nLen
                         aadd( aParams, nil )
                     next n2
                     if aParams[ 1] == nil; aParams[ 1] :=  "200"   ;endif
                     if aParams[ 2] == nil; aParams[ 2] :=  o       ;endif
                     if aParams[ 3] == nil; aParams[ 3] :=  ""      ;endif
                     if aParams[ 4] == nil; aParams[ 4] :=  ".f."   ;endif
                     if aParams[ 5] == nil; aParams[ 5] :=  {||.t.} ;endif
                     if aParams[ 6] == nil; aParams[ 6] :=  ""      ;endif

                     o := TDotNetGroup():New( o                       ,;
                                              val( aParams[2])        ,;
                                              aParams[3]              ,;
                                              lower(aParams[4])==".t.",;
                                              nil                     ,;
                                              aParams[6] )
                     aadd( aGrupos, {cObject, o } )

             case nEstado == PARSEANDO_BUTTON

                     o := GetMyObject( aGrupos, aParams[2] )
                     nLen := 12-len( aParams )
                     for n2 := 1 to nLen
                         aadd( aParams, nil )
                     next n2


                     if aParams[ 1] == nil; aParams[ 1] :=   "60"   ;endif
                     if aParams[ 2] == nil; aParams[ 2] :=  o       ;endif
                     if aParams[ 3] == nil; aParams[ 3] :=  ""      ;endif
                     if aParams[ 4] == nil; aParams[ 4] :=  ""      ;endif
                     if aParams[ 5] == nil; aParams[ 5] :=  "1"     ;endif
                     if aParams[ 6] == nil; aParams[ 6] :=  {||.t.} ;endif
                     if aParams[ 7] == nil; aParams[ 7] :=  nil     ;endif
                     if aParams[ 8] == nil; aParams[ 8] :=  {||.t.} ;endif
                     if aParams[ 9] == nil; aParams[ 9] :=  ".f."   ;endif
                     if aParams[10] == nil; aParams[10] :=  ".f."   ;endif
                     if aParams[11] == nil; aParams[11] :=  ".f."   ;endif
                     if aParams[12] == nil; aParams[12] :=  ""      ;endif

                     o := TDotNetButton():New( val( aParams[1])         ,;
                                               o                        ,;
                                               alltrim( aParams[3])      ,;
                                               alltrim( aParams[4])      ,;
                                               val(     aParams[5]), , ,     ,;
                                               lower(   aParams[9])==".t." ,;
                                               lower(   aParams[10])==".t.",;
                                               lower(   aParams[11])==".t.",;
                                               alltrim( aParams[12]) )
          endcase

       endif


    n++


enddo

::Refresh()


RETURN 0





***********************************************************************************************
      METHOD InsertCarpeta( oCarpeta, nPos ) CLASS TDotNetBar
***********************************************************************************************

if nPos == nil; nPos := 1; endif

::lWorking := .t.

aadd( ::aCarpetas, nil )
ains( ::aCarpetas, nPos )
::aCarpetas[nPos] := oCarpeta
::Resize()
::GetCoords()

::lWorking := .f.

::Refresh()

RETURN nil



***********************************************************************************************
      METHOD SetFirstTab( cText, bAction, aColors ) CLASS TDotNetBar
***********************************************************************************************

if empty( aColors )
   // 1 primer degradado
   // 2 segundo
   // 3 borde exterior
   // 4 borde interior
   // 5 texto
   aColors := { ::oColor:GRADBTN10, ::oColor:GRADBTN20, ,RGB(181,127,27) , CLR_WHITE }

endif

::oFirstTab := TCarpeta():New( self, cText, .t., bAction, aColors )

RETURN nil


function GetMyObject( aObjects, cName )
local n
local nLen := len( aObjects )

cName := alltrim( cName )

for n := 1 to nLen
    if alltrim(lower(aObjects[n,1])) == lower( cName )
       RETURN aObjects[n,2]
    endif
next

RETURN nil




**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************

 CLASS TClrStyle

         DATA _CLRTEXTTOP                   INIT RGB(  21,  66, 139 )
         DATA _CLRTEXTBACK                  INIT RGB( 113, 106, 183 )
         DATA _CLRTEXTTOPDISABLE            INIT RGB( 141, 141, 141 )
         DATA _GRISB                        INIT RGB( 141, 178, 227 )      // borde
         DATA _GRISBOX1                     INIT RGB( 161, 190, 213 )
         DATA _GRIS0                        INIT RGB( 191, 219, 255 )      // fondo solapas generales
         DATA _BACKTITLE                    INIT RGB( 194, 218, 242 )
         DATA _GRIS2                        INIT RGB( 199, 216, 237 )      // gradient 1
         DATA ROUNDBOXCAR1                  INIT RGB( 215, 183, 127 )
         DATA _GRIS3                        INIT RGB( 217, 232, 246 )      // gradient 2
         DATA P1GRUPOS                      INIT RGB( 218, 229, 243 )
         DATA _GRIS1                        INIT RGB( 219, 230, 243 )      // primera banda
         DATA COLORUNDEF1                   INIT RGB( 220, 232, 249 )
         DATA _GRISBOX2                     INIT RGB( 239, 244, 250 )
         DATA ROUNDBOXCAR2                  INIT RGB( 255, 255, 189 )

         // Gradientes botones
         DATA GRADBTN10                     INIT RGB( 248, 186, 107 )
         DATA GRADBTN11                     INIT RGB( 252, 161,  96 )
         DATA GRADBTN20                     INIT RGB( 251, 140,  60 )
         DATA GRADBTN21                     INIT RGB( 253, 160,  69 )
         DATA GRADBTN30                     INIT RGB( 253, 160,  69 )
         DATA GRADBTN31                     INIT RGB( 254, 189,  97 )

         DATA GRADBTN100                    INIT RGB( 251, 219, 181 )
         DATA GRADBTN101                    INIT RGB( 254, 199, 120 )
         DATA GRADBTN200                    INIT RGB( 253, 179,  84 )
         DATA GRADBTN201                    INIT RGB( 253, 216, 134 )
         DATA GRADBTN300                    INIT RGB( 253, 228, 151 )
         DATA GRADBTN301                    INIT RGB( 253, 235, 159 )

         DATA GRADBTN1000                   INIT RGB( 255, 253, 224 )
         DATA GRADBTN1001                   INIT RGB( 255, 231, 155 )
         DATA GRADBTN2000                   INIT RGB( 255, 215,  94 )
         DATA GRADBTN2001                   INIT RGB( 255, 218, 112 )
         DATA GRADBTN3000                   INIT RGB( 255, 218, 112 )
         DATA GRADBTN3001                   INIT RGB( 255, 250, 186 )

         DATA BORDERBTN1                    INIT RGB( 255, 255, 255 )
         DATA BORDERBTN2                    INIT RGB( 221, 207, 155 )

         DATA PANE_BTN_GRP1                 INIT RGB( 202, 221, 241 )
         DATA PANE_BTN_GRP2                 INIT RGB( 197, 215, 240 )

         DATA BORDER_TOP_BTN_HEAD1          INIT RGB( 129, 164, 209 )
         DATA BORDER_TOP_BTN_HEAD2          INIT RGB( 213, 227, 241 )

         DATA BORDER_LEFT_BTN_HEAD1         INIT RGB( 129, 164, 209 )
         DATA BORDER_LEFT_BTN_HEAD2         INIT RGB( 234, 242, 251 )

         DATA BORDER_BOTTOM_BTN_HEAD1       INIT RGB( 129, 164, 209 )
         DATA BORDER_BOTTOM_BTN_HEAD2       INIT RGB( 234, 242, 251 )

         DATA BORDER_RIGHT_BTN_HEAD1        INIT RGB( 191, 213, 240 )

         DATA BORDER_TOP_BTN_HEAD_END1      INIT RGB( 129, 164, 209 )
         DATA BORDER_TOP_BTN_HEAD_END2      INIT RGB( 213, 227, 241 )

         DATA BORDER_BOTTOM_BTN_HEAD_END1   INIT RGB( 129, 164, 209 )
         DATA BORDER_BOTTOM_BTN_HEAD_END2   INIT RGB( 234, 242, 251 )

         DATA BORDER_RIGHT_BTN_HEAD_END1    INIT RGB( 129, 164, 209 )
         DATA BORDER_RIGHT_BTN_HEAD_END2    INIT RGB( 234, 242, 251 )

         DATA BORDER_TOP_BTN_END1           INIT RGB( 129, 164, 209 )
         DATA BORDER_TOP_BTN_END2           INIT RGB( 213, 227, 241 )

         DATA BORDER_LEFT_BTN_END1          INIT RGB( 213, 227, 241 )

         DATA BORDER_BOTTOM_BTN_END1        INIT RGB( 129, 164, 209 )
         DATA BORDER_BOTTOM_BTN_END2        INIT RGB( 234, 242, 251 )

         DATA BORDER_RIGHT_BTN_END1         INIT RGB( 129, 164, 209 )
         DATA BORDER_RIGHT_BTN_END2         INIT RGB( 234, 242, 251 )

         DATA BORDER_MIDLE_TOP1             INIT RGB( 129, 164, 209 )
         DATA BORDER_MIDLE_TOP2             INIT RGB( 216, 230, 247 )

         DATA BORDER_MIDLE_LEFT1            INIT RGB( 213, 227, 241 )

         DATA BORDER_MIDLE_BOTTOM1          INIT RGB( 129, 164, 209 )
         DATA BORDER_MIDLE_BOTTOM2          INIT RGB( 234, 242, 251 )

         DATA BORDER_MIDLE_RIGHT1           INIT RGB( 191, 213, 240 )

         DATA _BACKTITLE                    INIT RGB( 194, 218, 242 )
         DATA _CLRTEXTBACK                  INIT RGB( 113, 106, 183 )
         DATA _CLRTEXTTOP                   INIT RGB(  21,  66, 139 )
         DATA _CLRTEXTTOPDISABLE            INIT RGB( 141, 141, 141 )

         DATA nClrBar1                      INIT RGB( 219, 230, 243 )
         DATA nClrBar20                     INIT RGB( 199, 216, 237 )
         DATA nClrBar200                    INIT RGB( 219, 230, 243 )
         DATA nClrBar21                     INIT RGB( 217, 232, 246 )
         DATA nClrBTitle                    INIT RGB( 194, 218, 242 )
         DATA nClrBTitle2                   INIT RGB( 194, 218, 242 )

         DATA nClrBar11                     INIT RGB(232,240,252)
         DATA nClrBar201                    INIT RGB(220,234,251)
         DATA nClrBar211                    INIT RGB(220,232,248)
         DATA nClrBTitle1                   INIT RGB(200,224,255)
         DATA nClrBTitle12                  INIT RGB(200,224,255)

         DATA nGradientGrp1                 INIT RGB( 255,253,224)
         DATA nGradientGrp11                INIT RGB( 255,231,155)
         DATA nGradientGrp2                 INIT RGB( 255,215, 94)
         DATA nGradientGrp21                INIT RGB( 255,218, 112)
         DATA nGradientGrp3                 INIT RGB( 255,218,112)
         DATA nGradientGrp31                INIT RGB( 255,250, 186)

         DATA nGradientGrp01                INIT RGB( 240, 244, 249 )
         DATA nGradientGrp011               INIT RGB( 226, 236, 249 )
         DATA nGradientGrp02                INIT RGB( 240, 244, 249 )
         DATA nGradientGrp021               INIT RGB( 226, 236, 249 )

         DATA nClrPaneSolapa1               INIT RGB( 255, 255, 255 )
         DATA nClrPaneSolapa2               INIT RGB( 219, 230, 243 )

         DATA nClrPaneSolapaOver1           INIT RGB( 197,221,251)
         DATA nClrPaneSolapaOver2           INIT RGB( 226,209,162)

         DATA nClrSeparador1                INIT RGB( 255, 255, 255 )
         DATA nClrSeparador11               INIT RGB( 240, 242, 243 )
         DATA nClrSeparador21               INIT RGB( 205, 210, 215 )

         DATA nCorner1                      INIT 5

       DATA nStyle  INIT 1

       METHOD New() CONSTRUCTOR

       METHOD SetStyle( nStyle )

 ENDCLASS


********************************************************************************************
  METHOD New() CLASS TClrStyle
********************************************************************************************

RETURN self

********************************************************************************************
  METHOD SetStyle( nStyle ) CLASS TClrStyle
********************************************************************************************

   ::nStyle := nStyle

   do case
      case ::nStyle == 0

        ::_CLRTEXTTOP                   := RGB(  21,  66, 139 )
        ::_CLRTEXTBACK                  := RGB( 113, 106, 183 )
        ::_CLRTEXTTOPDISABLE            := RGB( 141, 141, 141 )
        ::_GRISB                        := RGB( 141, 178, 227 )      // borde
        ::_GRISBOX1                     := RGB( 161, 190, 213 )
        ::_GRIS0                        := RGB( 191, 219, 255 )      // fondo solapas generales
        ::_BACKTITLE                    := RGB( 194, 218, 242 )
        ::_GRIS2                        := RGB( 199, 216, 237 )      // gradient 1
        ::ROUNDBOXCAR1                  := RGB( 215, 183, 127 )
        ::_GRIS3                        := RGB( 217, 232, 246 )      // gradient 2
        ::P1GRUPOS                      := RGB( 218, 229, 243 )
        ::_GRIS1                        := RGB( 219, 230, 243 )      // primera banda
        ::COLORUNDEF1                   := RGB( 220, 232, 249 )
        ::_GRISBOX2                     := RGB( 239, 244, 250 )
        ::ROUNDBOXCAR2                  := RGB( 255, 255, 189 )

        // Gradientes botones
        ::GRADBTN10                     := RGB( 248, 186, 107 )
        ::GRADBTN11                     := RGB( 252, 161,  96 )
        ::GRADBTN20                     := RGB( 251, 140,  60 )
        ::GRADBTN21                     := RGB( 253, 160,  69 )
        ::GRADBTN30                     := RGB( 253, 160,  69 )
        ::GRADBTN31                     := RGB( 254, 189,  97 )

        ::GRADBTN100                    := RGB( 251, 219, 181 )
        ::GRADBTN101                    := RGB( 254, 199, 120 )
        ::GRADBTN200                    := RGB( 253, 179,  84 )
        ::GRADBTN201                    := RGB( 253, 216, 134 )
        ::GRADBTN300                    := RGB( 253, 228, 151 )
        ::GRADBTN301                    := RGB( 253, 235, 159 )

        ::GRADBTN1000                   := RGB( 255, 253, 224 )
        ::GRADBTN1001                   := RGB( 255, 231, 155 )
        ::GRADBTN2000                   := RGB( 255, 215,  94 )
        ::GRADBTN2001                   := RGB( 255, 218, 112 )
        ::GRADBTN3000                   := RGB( 255, 218, 112 )
        ::GRADBTN3001                   := RGB( 255, 250, 186 )

        ::BORDERBTN1                    := RGB( 255, 255, 255 )
        ::BORDERBTN2                    := RGB( 221, 207, 155 )

        ::PANE_BTN_GRP1                 := RGB( 202, 221, 241 )
        ::PANE_BTN_GRP2                 := RGB( 197, 215, 240 )

        ::BORDER_TOP_BTN_HEAD1          := RGB( 129, 164, 209 )
        ::BORDER_TOP_BTN_HEAD2          := RGB( 213, 227, 241 )

        ::BORDER_LEFT_BTN_HEAD1         := RGB( 129, 164, 209 )
        ::BORDER_LEFT_BTN_HEAD2         := RGB( 234, 242, 251 )

        ::BORDER_BOTTOM_BTN_HEAD1       := RGB( 129, 164, 209 )
        ::BORDER_BOTTOM_BTN_HEAD2       := RGB( 234, 242, 251 )

        ::BORDER_RIGHT_BTN_HEAD1        := RGB( 191, 213, 240 )

        ::BORDER_TOP_BTN_HEAD_END1      := RGB( 129, 164, 209 )
        ::BORDER_TOP_BTN_HEAD_END2      := RGB( 213, 227, 241 )

        ::BORDER_BOTTOM_BTN_HEAD_END1   := RGB( 129, 164, 209 )
        ::BORDER_BOTTOM_BTN_HEAD_END2   := RGB( 234, 242, 251 )

        ::BORDER_RIGHT_BTN_HEAD_END1    := RGB( 129, 164, 209 )
        ::BORDER_RIGHT_BTN_HEAD_END2    := RGB( 234, 242, 251 )

        ::BORDER_TOP_BTN_END1           := RGB( 129, 164, 209 )
        ::BORDER_TOP_BTN_END2           := RGB( 213, 227, 241 )

        ::BORDER_LEFT_BTN_END1          := RGB( 213, 227, 241 )

        ::BORDER_BOTTOM_BTN_END1        := RGB( 129, 164, 209 )
        ::BORDER_BOTTOM_BTN_END2        := RGB( 234, 242, 251 )

        ::BORDER_RIGHT_BTN_END1         := RGB( 129, 164, 209 )
        ::BORDER_RIGHT_BTN_END2         := RGB( 234, 242, 251 )

        ::BORDER_MIDLE_TOP1             := RGB( 129, 164, 209 )
        ::BORDER_MIDLE_TOP2             := RGB( 216, 230, 247 )

        ::BORDER_MIDLE_LEFT1            := RGB( 213, 227, 241 )

        ::BORDER_MIDLE_BOTTOM1          := RGB( 129, 164, 209 )
        ::BORDER_MIDLE_BOTTOM2          := RGB( 234, 242, 251 )

        ::BORDER_MIDLE_RIGHT1           := RGB( 191, 213, 240 )

        ::_BACKTITLE                    := RGB( 194, 218, 242 )
        ::_CLRTEXTBACK                  := RGB( 113, 106, 183 )
        ::_CLRTEXTTOP                   := RGB(  21,  66, 139 )
        ::_CLRTEXTTOPDISABLE            := RGB( 141, 141, 141 )

        ::nClrBar1                      := RGB( 219, 230, 243 )
        ::nClrBar20                     := RGB( 199, 216, 237 )
        ::nClrBar200                    := RGB( 219, 230, 243 )
        ::nClrBar21                     := RGB( 217, 232, 246 )
        ::nClrBTitle                    := RGB( 194, 218, 242 )
        ::nClrBTitle2                   := RGB( 194, 218, 242 )

        ::nClrBar11                     := RGB( 232, 240, 252 )
        ::nClrBar201                    := RGB( 220, 234, 251 )
        ::nClrBar211                    := RGB( 220, 232, 248 )
        ::nClrBTitle1                   := RGB( 200, 224, 255 )
        ::nClrBTitle12                  := RGB( 200, 224, 255 )

        ::nGradientGrp1                 := RGB( 255, 253, 224 )
        ::nGradientGrp11                := RGB( 255, 231, 155 )
        ::nGradientGrp2                 := RGB( 255, 215,  94 )
        ::nGradientGrp21                := RGB( 255, 218, 112 )
        ::nGradientGrp3                 := RGB( 255, 218, 112 )
        ::nGradientGrp31                := RGB( 255, 250, 186 )

        ::nGradientGrp01                := RGB( 240, 244, 249 )
        ::nGradientGrp011               := RGB( 226, 236, 249 )
        ::nGradientGrp02                := RGB( 240, 244, 249 )
        ::nGradientGrp021               := RGB( 226, 236, 249 )

        ::nClrPaneSolapa1               := RGB( 255, 255, 255 )
        ::nClrPaneSolapa2               := RGB( 219, 230, 243 )
        ::nClrPaneSolapaOver1           := RGB( 197, 221, 251 )
        ::nClrPaneSolapaOver2           := RGB( 226, 209, 162 )

        ::nCorner1                      := 5

      case ::nStyle == 2

        ::_GRIS0                        := RGB( 229, 231, 234 )
        ::_GRIS1                        := RGB( 255, 255, 255 )
        ::_GRIS2                        := RGB( 255, 255, 255 )
        ::_GRIS3                        := RGB( 232, 235, 239 )
        ::_GRISB                        := RGB( 140, 150, 157 )      // borde

        ::nClrPaneSolapa1               := RGB( 255, 255, 255 )
        ::nClrPaneSolapa2               := RGB( 255, 255, 255 )
        ::nClrPaneSolapaOver1           := RGB( 233, 235, 237 )
        ::nClrPaneSolapaOver2           := RGB( 233, 235, 237 )

        ::nClrBar1                      := RGB( 255, 255, 255 )
        ::nClrBar20                     := RGB( 255, 255, 255 )
        ::nClrBar200                    := RGB( 242, 245, 249 )

        ::nClrBTitle                    := RGB( 242, 245, 249 )
        ::nClrBTitle2                   := RGB( 232, 235, 239 )

        ::nClrBar11                     := RGB( 244, 244, 244 )
        ::nClrBar201                    := RGB( 244, 244, 244 )
        ::nClrBar211                    := RGB( 245, 247, 248 )
        ::nClrBTitle1                   := RGB( 245, 247, 248 )
        ::nClrBTitle12                  := RGB( 233, 237, 242 )

        ::nCorner1                      := 1

      case ::nStyle == 1

        ::_GRIS0                        := RGB( 255, 255, 255 )
        ::_GRIS1                        := RGB( 255, 255, 255 )
        ::_GRIS2                        := RGB( 255, 255, 255 )
        ::_GRIS3                        := RGB( 255, 255, 255 )
        ::_GRISB                        := RGB( 140, 150, 157 )      // borde

        ::nClrPaneSolapa1               := RGB( 255, 255, 255 )
        ::nClrPaneSolapa2               := RGB( 255, 255, 255 )
        ::nClrPaneSolapaOver1           := RGB( 255, 255, 255 )
        ::nClrPaneSolapaOver2           := RGB( 255, 255, 255 )

        ::nClrBar1                      := RGB( 255, 255, 255 )
        ::nClrBar20                     := RGB( 255, 255, 255 )
        ::nClrBar200                    := RGB( 255, 255, 255 ) // RGB( 242, 245, 249 )

        ::nClrBTitle                    := RGB( 255, 255, 255 ) //RGB( 242, 245, 249 )
        ::nClrBTitle2                   := RGB( 255, 255, 255 )

        ::nClrBar11                     := RGB( 255, 255, 255 )
        ::nClrBar201                    := RGB( 255, 255, 255 )
        ::nClrBar211                    := RGB( 220, 232, 248 )
        ::nClrBTitle1                   := RGB( 255, 255, 255 )
        ::nClrBTitle12                  := RGB( 255, 255, 255 )

        ::nCorner1                      := 0

   endcase

RETURN 0