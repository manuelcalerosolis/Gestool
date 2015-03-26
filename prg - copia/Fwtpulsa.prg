*****************************************************************************
********************** Funciones £tiles s¢lo en FiveWin *********************
********************** 55¦ parte ********************************************

#include "FiveWin.Ch"

#ifdef __XPP__
   #define Super ::TControl
   #define New   _New
#endif



CLASS TPulsador FROM TControl

   DATA bPulsado, bDesPulsad
   DATA lPulsado
   DATA nAltura, nAnchura, nColorSupe

   CLASSDATA lRegistered AS LOGICAL

   METHOD New( nTop, nLeft, nWidth, nHeight,    ;
               cCaption, bPulsado, bDesPulsad,  ;
               oWnd,                            ;
               nColorSupe )   CONSTRUCTOR

   METHOD Display()  INLINE ::BeginPaint(), ::Paint(), ::EndPaint(), ;
                            0
   METHOD Paint()

   METHOD DrawDots()

   METHOD Resizear( nTop, nLeft, nWidth, nHeight )

   METHOD CambiarEst() INLINE ::lPulsado := !::lPulsado, ;
                              ::Refresh(),               ; //ni ::Display() ni ::Paint()
                              ::Accion2()

   METHOD Accion2()    INLINE If( ::lPulsado,                  ;
                                  Eval( ::bPulsado  , Self ),  ;
                                  Eval( ::bDespulsad, Self )   ;
                                )

ENDCLASS


METHOD Resizear( nTop, nLeft, nWidth, nHeight )

   ::nAltura   := nHeight
   ::nAnchura  := nWidth
   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := nTop + nHeight
   ::nRight    := nLeft + nWidth

RETURN nil


METHOD New( nTop, nLeft, nWidth, nHeight,    ;
            cCaption, bPulsado, bDesPulsad,  ;
            oWnd,                            ;
            nColorSupe )  CLASS TPulsador

   #ifdef __XPP__
      #undef New
   #endif

   DEFAULT oWnd := GetWndDefault()
   DEFAULT bPulsado := { | Self | Tone( 777, 1 ) },;
         bDesPulsad := { | Self | Tone( 222, 1 ) }
   DEFAULT nColorSupe := CLR_HGRAY

   ::lPulsado   := .f.
   ::bPulsado   := bPulsado
   ::bDesPulsad := bDesPulsad
   ::nColorSupe := nColorSupe
   ::cCaption   := cCaption
   ::oWnd       := oWnd
   ::bLClicked  := { || ::CambiarEst() }
   ::lCaptured  := .f.

   ::lDrag      := .f.
   ::nStyle     := nOr( WS_CHILD, WS_VISIBLE, WS_TABSTOP )

   ::Resizear( nTop, nLeft, nWidth, nHeight )

   #ifdef __XPP__
      DEFAULT ::lRegistered := .f.
   #endif
   ::Register()

   If Empty( ::oWnd:hWnd )
      ::oWnd:DefControl( Self )
   Else
      ::Create()
      ::oWnd:AddControl( Self )
   End

   ::SetFocus()

RETURN Self


METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TPulsador

   ::SetFocus()
   ::Refresh()

RETURN nil


METHOD DrawDots() CLASS TSayMenu

   local hDC      := ::hDC
   local nAnchura := ::nWidth()
   local nAltura  := ::nHeight()
   local lXor              := .f.      //con        .T.  no se ve doteada la l¡nea
   local nColorPen         := CLR_GRAY //con  CLR_WHITE  no se ve doteada la l¡nea
   local nDistanciaAlBorde := nAltura / 7
   local nPenStyle := PS_DOT
  *local nPenStyle := PS_DASH
  *local nPenStyle := PS_DASHDOT
   local hNewPen := CreatePen( nPenStyle, 1, nColorPen )
   local hOldPen := SelectObject( hDC, hNewPen )

   MoveTo   ( hDC,            nDistanciaAlBorde, nAltura - nDistanciaAlBorde )
If lXor
   LineToXor( hDC,            nDistanciaAlBorde,           nDistanciaAlBorde )
   LineToXor( hDC, nAnchura - nDistanciaAlBorde,           nDistanciaAlBorde )
   LineToXor( hDC, nAnchura - nDistanciaAlBorde, nAltura - nDistanciaAlBorde )
   LineToXor( hDC,            nDistanciaAlBorde, nAltura - nDistanciaAlBorde )
Else
   LineTo(    hDC,            nDistanciaAlBorde,           nDistanciaAlBorde )
   LineTo(    hDC, nAnchura - nDistanciaAlBorde,           nDistanciaAlBorde )
   LineTo(    hDC, nAnchura - nDistanciaAlBorde, nAltura - nDistanciaAlBorde )
   LineTo(    hDC,            nDistanciaAlBorde, nAltura - nDistanciaAlBorde )
End

   SelectObject( hDC, hOldPen  )
   DeleteObject( hNewPen )

RETURN nil


METHOD Paint() CLASS TPulsador

   local nY, nX
   local hBrush    := CreateSolidBrush( ::nColorSupe )
   local hWhitePen := CreatePen( PS_SOLID, 2, CLR_WHITE )
   local hGrayPen  := CreatePen( PS_SOLID, 2, CLR_GRAY  )
   local hOldBrush, hOldPen, nOldTextColor, nOldBackColor

   ::GetDC() //carga  ::hDC

  *Rellenar la superficie del pulsador.-
   hOldBrush := SelectObject( ::hDC, hBrush    )
   Rectangle( ::hDC,       000,        000, ;
                   ::nAltura, ::nAnchura )
   SelectObject( ::hDC, hOldBrush )

  *Angulito superior.-
   If ::lPulsado
      hOldPen := SelectObject( ::hDC, hGrayPen  )
   Else
      hOldPen := SelectObject( ::hDC, hWhitePen )
   End
   MoveTo( ::hDC,              0, ::nAltura - 0 )
   LineTo( ::hDC,              0,             0 )
   LineTo( ::hDC, ::nAnchura - 0,             0 )
   SelectObject( ::hDC, hOldPen   )

  *Angulito inferior.-
   If ::lPulsado
      hOldPen := SelectObject( ::hDC, hWhitePen )
   Else
      hOldPen := SelectObject( ::hDC, hGrayPen )
   End
   MoveTo( ::hDC,              0, ::nAltura - 0 )
   LineTo( ::hDC, ::nAnchura - 0, ::nAltura - 0 )
   LineTo( ::hDC, ::nAnchura - 0,             0 )
   SelectObject( ::hDC, hOldPen  )

   nY := ( ::nAltura / 2 ) - 8
   nX := 24
   nOldTextColor := SetTextColor( ::hDC, nColorInve( ::nColorSupe ) )
   nOldBackColor := SetBkColor(   ::hDC,             ::nColorSupe   )
   If ::lPulsado
      TextOut( ::hDC, nY - 2, nX - 2, ::cCaption )
   Else
      TextOut( ::hDC, nY    , nX    , ::cCaption )
   End
   SetBkColor(   ::hDC, nOldBackColor )
   SetTextColor( ::hDC, nOldTextColor )

   DeleteObject( hWhitePen )
   DeleteObject( hGrayPen )
   DeleteObject( hBrush )

   If ::lFocused
      ::DrawDots()
   End

   ::ReleaseDC()

RETURN nil