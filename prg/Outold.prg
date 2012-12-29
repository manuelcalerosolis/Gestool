#include "FiveWin.Ch"
#include "Constant.ch"
#include "Objects.ch"

//--------------------------------------------------------------------------//
#define BTN_HEIGHT    22
#define STEP_BMP       5
#define SAY_HEIGHT    18
#define LSPIN         14
//--------------------------------------------------------------------------//

CLASS TOutLook FROM TControl

  CLASSDATA lRegistered AS LOGICAL

  CLASSDATA aProperties ;
    INIT { "aGroup", "nAlign", "nClrText", "nClrPane", "nOption", "Cargo" }

  DATA aGroup     INIT {}
  DATA nGroup     INIT 1
  DATA nActual    INIT 1
  DATA lCaptured  INIT .F.
  DATA lIsOver    INIT .F.
  DATA nAtOver    INIT .F.
  DATA oBtnTop
  DATA oBtnBottom
  DATA nDesp      INIT 0
  DATA cBitmap
  DATA cResBmp
  DATA hBmpPal
  DATA oSayBr

  METHOD New( nTop, nLeft, nWidth, nHeight, cBitmap, cResBmp, ;
              nClrFore, nClrBack, nStyle, oBrush, oFont, ;
              lPixel, cMsg, oWnd, nHelpID, bRClick ) CONSTRUCTOR

  METHOD Redefine( nID, oWnd, cBitmap, cResBmp, ;
                   nClrFore, nClrBack, oBrush, oFont, ;
                   cMsg, nHelpID, bRClick ) CONSTRUCTOR

  METHOD End() INLINE if( ::hWnd == 0, ::Destroy(), Super:End() )

  METHOD Display() INLINE ::BeginPaint(), ::Paint(), ::EndPaint()
  METHOD Paint()
  METHOD DrawButtons()

  METHOD AddGroup( cPrompt, bAction, bWhen, cMsg )
  METHOD AddItem( cPrompt, cBitmap, cResource, bAction, ;
                  nGroup, bWhen, cMsg )
  METHOD Set( nGroup, cPrompt )

  METHOD Destroy()

ENDCLASS
//--------------------------------------------------------------------------//
METHOD New( nTop, nLeft, nWidth, nHeight, cBitmap, cResBmp, ;
            nClrFore, nClrBack, nStyle, oBrush, oFont, ;
            lPixel, cMsg, oWnd, nHelpID, bRClick ) CLASS TOutLook

  DEFAULT nClrFore  := CLR_BLACK, ;
          nClrBack  := GetSysColor( COLOR_WINDOW ), ;
          nStyle    := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, WS_BORDER ), ;
          oFont     := TFont():New( "Ms Sans Serif", 6, 12, .F. )

  ::nStyle    = nStyle
  ::nId       = ::GetNewId()
  ::oWnd      = oWnd
  ::nTop      = If( lPixel, nTop, nTop * WIN_CHARPIX_H )
  ::nLeft     = If( lPixel, nLeft, nLeft * WIN_CHARPIX_W )
  ::nBottom   = ::nTop + nHeight
  ::nRight    = ::nLeft + nWidth + 1
  ::lCaptured = .f.
  ::cBitmap   = cBitmap
  ::cResBmp   = cResBmp
  ::hBmpPal   = 0
  ::nClrPane  = nClrBack
  ::nClrText  = nClrFore
  ::bRClicked = bRClick
  ::nHelpID   = nHelpID
  ::oFont     = oFont

  if oBrush == nil
    DEFINE BRUSH ::oBrush STYLE TABS
  else
    ::oBrush := oBrush
  endif

  ::SetColor( nClrFore, nClrBack )
  ::Register()

  if ! Empty( oWnd:hWnd )
    ::Create()
    oWnd:AddControl( Self )
  else
    oWnd:DefControl( Self )
  endif

  /*
  se crean los botones de desplazamiento arriba y abajo
  */

  @ 0,0 BTNBMP ::oBtnTop SIZE 16,16 OF Self
  ::oBtnTop:bAction := {|| if( ::nDesp > 0, ( ::nDesp--, ::DrawButtons() ), ) }
  ::oBtnTop:hBmpPal1 := LoadBitmap( 0, 32753 )

  @ 0,0 BTNBMP ::oBtnBottom SIZE 16,32 OF Self
  ::oBtnBottom:bAction:= {|| if( ::nDesp + 2 < Len( ::aGroup[::nActual, 4 ] ), ;
      ( ::nDesp++, ::DrawButtons() ), ) }
  ::oBtnBottom:hBmpPal1 := LoadBitmap( 0, 32752 )

  // cargo el bitmap de fondo si existe ...
  if !Empty( cResBmp )
    ::hBmpPal := PalBmpLoad( cResBmp )
    cBitmap  := nil
  endif

  if cBitmap != nil
    cBitmap := AllTrim( cBitmap )
  endif

  if !Empty( cBitmap ) .and. File( cBitmap )
    ::cBitmap := cBitmap
    ::hBmpPal := PalBmpRead( if( oWnd != nil, oWnd:GetDC(), 0 ), cBitmap )
    if( oWnd != nil, oWnd:ReleaseDC(), )
  endif

  if ::hBmpPal != 0
    PalBmpNew( 0, ::hBmpPal )
  endif

  DEFINE BRUSH ::oSayBr STYLE NULL

  oWnd:Resize()

return Self
//--------------------------------------------------------------------------//
METHOD Redefine( nID, oWnd, cBitmap, cResBmp, ;
                 nClrFore, nClrBack, oBrush, oFont, ;
                 cMsg, nHelpID, bRClick ) CLASS TOutLook

  ::nID       = nID
  ::oWnd      = oWnd
  ::lCaptured = .f.
  ::cBitmap   = cBitmap
  ::cResBmp   = cResBmp
  ::hBmpPal   = 0
  ::nClrPane  = nClrBack
  ::nClrText  = nClrFore
  ::bRClicked = bRClick
  ::nHelpID   = nHelpID
  ::oFont     = oFont

  if oBrush == nil
    DEFINE BRUSH ::oBrush STYLE TABS
  else
    ::oBrush := oBrush
  endif

  ::SetColor( nClrFore, nClrBack )

  if ! Empty( oWnd:hWnd )
    ::Create()
    oWnd:AddControl( Self )
  else
    oWnd:DefControl( Self )
  endif

  // se crean los botones de desplazamiento arriba y abajo
  @ 0,0 BTNBMP ::oBtnTop SIZE 16,16 OF Self
  ::oBtnTop:bAction := {|| if( ::nDesp > 0, ( ::nDesp--, ::DrawButtons() ), ) }
  ::oBtnTop:hBmpPal1 := LoadBitmap( 0, 32753 )

  @ 0,0 BTNBMP ::oBtnBottom SIZE 16,16 OF Self
  ::oBtnBottom:bAction:= {|| if( ::nDesp + 2 < Len( ::aGroup[::nActual, 4 ] ), ;
      ( ::nDesp++, ::DrawButtons() ), ) }
  ::oBtnBottom:hBmpPal1 := LoadBitmap( 0, 32752 )

  // cargo el bitmap de fondo si existe ...
  if !Empty( cResBmp )
    ::hBmpPal := PalBmpLoad( cResBmp )
    cBitmap  := nil
  endif

  if cBitmap != nil
    cBitmap := AllTrim( cBitmap )
  endif

  if !Empty( cBitmap ) .and. File( cBitmap )
    ::cBitmap := cBitmap
    ::hBmpPal := PalBmpRead( if( oWnd != nil, oWnd:GetDC(), 0 ), cBitmap )
    if( oWnd != nil, oWnd:ReleaseDC(), )
  endif

  if ::hBmpPal != 0
    PalBmpNew( 0, ::hBmpPal )
  endif

  // This doesn't work
  /*
  if oWnd != nil
    oWnd:DefControl( Self )
  endif
  */

return Self
//--------------------------------------------------------------------------//
METHOD AddGroup( cPrompt, bAction, bWhen, cMsg ) CLASS TOutLook

  LOCAL nItem

  aAdd( ::aGroup, { cPrompt, bAction, , {}, {} } )
  nItem := Len( ::aGroup )

  // creo el boton
  Self:aGroup[ nItem, 3 ] := TButton():New( 0, 0, cPrompt, Self, ;
    {|| ::Set( , cPrompt ) }, Self:nWidth(), BTN_HEIGHT, , ::oFont, ;
    .f., .f., .f., cMsg, .f., bWhen,, .f. )

return nil
//--------------------------------------------------------------------------//
METHOD AddItem( cPrompt, cBitmap, cResource, bAction, ;
                nGroup, bWhen, cMsg ) CLASS TOutLook

   LOCAL nItem
   LOCAL oBmp
   LOCAL oSay

   DEFAULT nGroup  := Len( ::aGroup ), ;
          bAction := {|| nil }

   if nGroup<1
      nGroup := 1
   end

   if nGroup > Len( ::aGroup )
      nGroup := Len( ::aGroup )
   endif

   @ 0, 0 BTNBMP oBmp FILE cBitmap RESOURCE cResource ;
      ACTION   Eval( bAction ) SIZE 32, 32 NOBORDER ; //ADJUST
      MESSAGE  cMsg ;
      UPDATE ;
      FONT     Self:oFont ;
      OF       Self

   oBmp:SetColor( 0, CLR_GREEN )

   oBmp:bWhen      := bWhen
   oBmp:nClrPane   := ::nClrPane
   oBmp:l97Look    := .t.

/*
   SetBkColor( oBmp:hDC, ::nClrPane )
*/

   @ 0, 0 SAY oSay PROMPT cPrompt CENTERED ;
      COLOR    ::nClrtext, ::nClrPane      ;
      FONT     Self:oFont                  ;
      OF       Self

   oSay:lWantClick := .t.
   oSay:bLClicked  := bAction
   oSay:bWhen      := bWhen
   oSay:l97Look    := .t.

   // hasta aqui

   oSay:oBrush     := ::oSayBr

   aAdd( ::aGroup[ nGroup, 4 ], oBmp )
   aAdd( ::aGroup[ nGroup, 5 ], oSay )

   oBmp:Hide()
   oSay:Hide()

return nil

//--------------------------------------------------------------------------//

METHOD Paint() CLASS TOutLook

   LOCAL nWidth
   LOCAL nBottom
   LOCAL nHeight
   LOCAL nOffLeft
   LOCAL nOffset
   LOCAL nEnd
   LOCAL n, m
   LOCAL nSpace
   LOCAL hDc         := ::GetDC()
   LOCAL hWhitePen   := CreatePen( PS_SOLID, 1, CLR_WHITE )
   LOCAL hHGrayPen   := CreatePen( PS_SOLID, 1, CLR_HGRAY )
   LOCAL hGrayPen    := CreatePen( PS_SOLID, 1, CLR_GRAY  )
   LOCAL hBlackPen   := CreatePen( PS_SOLID, 1, CLR_BLACK )
   LOCAL hOldPen

   ::CoorsUpdate()
   ::AEvalWhen()

   nWidth  := ::nWidth  - 7
   nBottom := ::nHeight - 11
   nHeight := ::nHeight - BTN_HEIGHT

   /*
   recoriendo los grupos, los recoloca
   */

   for n := 1 to Len( ::aGroup )
      if n <= ::nActual
         /*
         Botones posicion superior
         */
         ::aGroup[ n, 3 ]:Move( ( n - 1 ) * BTN_HEIGHT + 5, 0, nWidth, BTN_HEIGHT, .t.  )
      else
         /*
         Botones posición inferior
         */
         ::aGroup[ n, 3 ]:Move( nHeight - ( Len( ::aGroup ) - n ) * BTN_HEIGHT - 10, 0, nWidth, BTN_HEIGHT, .t.  )
      endif

      if n != ::nActual
         for m := 1 to Len( ::aGroup[ n, 4 ] )
            ::aGroup[ n, 4, m ]:Hide()
            ::aGroup[ n, 5, m ]:Hide()
         next
      endif
   next

   if !Empty( ::hBmpPal )
      BmpTiled( Self, ::hBmpPal )
   endif

   for n := 1 to Len( ::aGroup )
      ::aGroup[ n, 3 ]:Refresh( .t. )
   next

   ::DrawButtons()

   /*
   Dibujamos el marco del Control
   */

   hOldPen   := SelectObject( hDC, hHGrayPen )
   for n := 0 to 2
      /*
      MoveTo( hDC, 0, n )
      LineTo( hDC, ::nWidth - n - 3, n, hHGrayPen )
      MoveTo( hDC, ::nWidth - n - 3, n )
      LineTo( hDC, ::nWidth - n - 3, ::nHeight - n - 3, hHGrayPen )
      */
      MoveTo( hDC, ::nWidth - n , ::nHeight - n - 5 )
      LineTo( hDC, 0, ::nHeight - n - 5, hHGrayPen )
   next
   SelectObject( hDC, hOldPen )

   /*
   hOldPen  := SelectObject( hDC, hGrayPen )
   MoveTo( hDC, 0, 3 )
   LineTo( hDC, ::nWidth - 3 - 3, 3, hGrayPen )
   SelectObject( hDC, hOldPen )

   hOldPen  := SelectObject( hDC, hBlackPen )
   MoveTo( hDC, 0, 4 )
   LineTo( hDC, ::nWidth - 3 - 4, 4, hBlackPen )
   SelectObject( hDC, hOldPen )

   hOldPen  := SelectObject( hDC, hWhitePen )
   MoveTo( hDC, ::nWidth - 3 - 3, 3 )
   LineTo( hDC, ::nWidth - 3 - 3, ::nHeight - 3 - 3, hWhitePen )
   SelectObject( hDC, hOldPen )

   hOldPen  := SelectObject( hDC, hHGrayPen )
   MoveTo( hDC, ::nWidth - 3 - 4, 3 )
   LineTo( hDC, ::nWidth - 3 - 4, ::nHeight - 3 - 4, hHGrayPen )
   SelectObject( hDC, hOldPen )

   hOldPen  := SelectObject( hDC, hWhitePen )
   MoveTo( hDC, ::nWidth - 3, ::nHeight - 3 - 3 )
   LineTo( hDC, 0, ::nHeight - 3 - 3, hWhitePen )
   SelectObject( hDC, hOldPen )

   hOldPen  := SelectObject( hDC, hHGrayPen )
   MoveTo( hDC, ::nWidth - 4, ::nHeight - 4 - 3 )
   LineTo( hDC, 0, ::nHeight - 4 - 3, hHGrayPen )
   SelectObject( hDC, hOldPen )
   */

   ::ReleaseDC()

return nil

//--------------------------------------------------------------------------//

METHOD DrawButtons() CLASS TOutLook

  LOCAL nWidth
  LOCAL nHeight
  LOCAL nOffLeft
  LOCAL nOffset
  LOCAL nEnd
  LOCAL n, m
  LOCAL nSpace

  nWidth  := ::nWidth() - 2
  nHeight := ::nHeight() - BTN_HEIGHT

  if !Empty( ::aGroup[ ::nActual, 4 ] )
    nOffset   := ::nActual * BTN_HEIGHT + 6
    nEnd      := ::nHeight() - ( Len( ::aGroup ) * BTN_HEIGHT )
    nOffLeft  := Int( ::nWidth() / 2 ) - 16 // 32 / 2

    // caben todos los iconos en la barra ??
    nSpace := Int( ( nEnd - nOffset + STEP_BMP ) / ( STEP_BMP + 32 + SAY_HEIGHT ) )
    for n := 1 to ::nDesp
      ::aGroup[ ::nActual, 4, n ]:Hide()
      ::aGroup[ ::nActual, 5, n ]:Hide()
    next

    for n := ::nDesp + 1 to ::nDesp + ;
          Min( Len( ::aGroup[ ::nActual, 4 ] ) - ::nDesp, nSpace ) + 1
      if n <= Len( ::aGroup[ ::nActual, 4 ] )
        ::aGroup[ ::nActual, 4, n]:Move( nOffset + ( STEP_BMP + 32 + SAY_HEIGHT ) * ( n - 1 - ::nDesp ), ;
            nOffLeft, 32, 32, .t. )
        ::aGroup[ ::nActual, 4, n ]:Show()

        ::aGroup[ ::nActual, 5, n ]:Move( nOffset + ;
            ( STEP_BMP + 32 + SAY_HEIGHT ) * ( n - 1 - ::nDesp ) + 32, 0, ;
            nWidth, SAY_HEIGHT, .t. )
        ::aGroup[ ::nActual, 5, n ]:Show()
      endif
    next

    for n := n to Len( ::aGroup[ ::nActual, 4 ] )
      ::aGroup[ ::nActual, 4, n ]:Hide()
      ::aGroup[ ::nActual, 5, n ]:Hide()
    next

    if nSpace < ( STEP_BMP + 32 + SAY_HEIGHT )
      if ::nDesp > 0
        ::oBtnTop:Move( ( ::nActual ) * BTN_HEIGHT + 6, 6, LSPIN, LSPIN, .t.  )
        ::oBtnTop:Show()
      else
        ::oBtnTop:Hide()
      endif

      if Len( ::aGroup[ ::nActual, 4 ] ) - ::nDesp > nSpace
        ::oBtnBottom:Move( nEnd + BTN_HEIGHT - LSPIN - 6, 6, LSPIN, LSPIN, .t. )
        ::oBtnBottom:Show()
      else
        ::oBtnBottom:Hide()
      endif
    else
      ::oBtnTop:Hide()
      ::oBtnBottom:Hide()
    endif
  else
    ::oBtnTop:Hide()
    ::oBtnBottom:Hide()
  endif

return nil
//--------------------------------------------------------------------------//
METHOD Set( nGroup, cPrompt ) CLASS TOutLook

  if Empty( nGroup )
    nGroup := aScan( ::aGroup, {|x| x[1] = cPrompt } )
  endif

  if nGroup > 0
    if nGroup > Len( ::aGroup )
      nGroup := Len( ::aGroup )
    endif

    if ::nActual != nGroup
      ::nActual := nGroup
      /* JOSE
         He quitado esta linea para que conservar
         la "vista" al cambia de grupo
      */
      ::nDesp := 0
      ::Paint()
    endif
  endif

return nil
//--------------------------------------------------------------------------//
METHOD Destroy() CLASS TOutLook

  if ::hBmpPal != 0
    DeleteObject( ::hBmpPal )
    ::hBmpPal = 0
  endif

  ::oSayBr:End()

  if ::hWnd != 0
    Super:Destroy()
  endif

return nil
//--------------------------------------------------------------------------//
static function BmpTiled( oWnd, hBmp )

   LOCAL nWidth   := oWnd:nWidth()
   LOCAL nHeight  := oWnd:nHeight()
   LOCAL nRow     := 0
   LOCAL nCol     := 0
   LOCAL nBmpWidth  := nbmpwidth( hBmp )
   LOCAL nBmpHeight := nBmpHeight( hBmp )
   LOCAL hDC
   LOCAL n

   hDC := oWnd:GetDC()

   while nRow < nHeight
      nCol := 0
      while nCol < nWidth
         PalBmpDraw( hDC, nRow, nCol, hBmp, , , , .t. )
         nCol += nBmpWidth
      end
      nRow += nBmpHeight
   end

   oWnd:ReleaseDC()

return nil
//--------------------------------------------------------------------------//