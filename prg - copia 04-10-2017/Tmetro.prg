/*------------------------------------------------------------------------------*/
*        Archivo: Tmetro.PRG                                                    *
*    Descripcion: Emulación de la clase Metro de Windows 8 para FWH             *
*          Fecha: Octubre del 2011                                              *
*          Autor: Antonio Linares                                               *
*                 Javier LLoris (JLL)                                           *
*    Verion para: 32Bits                                                        *
*                                                                               *
*       Libreria: FWH/FWHX 11.09                                                *
*        Harbour: Harbour 3.1.0                                                 *
*     Compilador: Borland C++ 5.8.2                                             *
*                                                                               *
*     Nuevas Funcionalidades por Javier LLoris:                                 *
*                                                                               *
*     08-10-2011 Modifico el fichero de cabecera metro.ch                       *
*                                                                               *
*     08-10-2011 Modifico el metodo AddButton() para que acepte ADJUST en las   *
*                imagenes.                                                      *
*     08-10-2011 Añadimos lo siguientes metodos a la clase:                     *
*                METHOD MouseMove()                                             *
*                METHOD AddGif()                                                *
*                METHOD AddBar()                                                *
*                METHOD AddButtonBar()                                          *
*                METHOD CenterBar()                                             *
*                METHOD SetScroll()                                             *
*                METHOD GoUp()                                                  *
*                METHOD GoDown()                                                *
*                METHOD ScrollLeft()                                            *
*                METHOD ScrollRight()                                           *
*                METHOD ScrollPgUp()                                            *
*                METHOD ScrollPgDown()                                          *
*                METHOD KeyChar()                                               *
*                METHOD LButtonDown()                                           *
*                METHOD LButtonUp()                                             *
*                METHOD ScrollLeftEnd()                                         *
*                METHOD SetRange()                                              *
*                METHOD SeparatorRow()                                          *
*                METHOD SeparatorCol()                                          *
*                METHOD Group( nGroup )                                         *
*                METHOD EndGroup()                                              *
*                METHOD EndLine()                                               *
*                METHOD RestoreSet()                                            *
*                METHOD SetButton()                                             *
/*------------------------------------------------------------------------------*/

 #include "FiveWin.ch"
 #include "gif.ch"
 #include "InKey.ch"
 #include "Constant.ch"

 #define SB_HORZ             0
 #define SB_VERT             1

 #define POS_ACTIVATE_MENU  50
 #define MOVE_HAND          20

 #define D_WIDTH             4
 #define D_HEIGHT           13

 #define LINES_VERTICAL     20
 #define LINES_HORIZONTAL   10

 Static aLayouts := { "TOP", "LEFT", "BOTTOM", "RIGHT" }

//----------------------------------------------------------------------------//

CLASS TMetro

   DATA  oWnd, oFont, oFontB
   DATA  cFileName
   DATA  aButtons
   DATA  nOriginX, nOriginY
   DATA  nBtnWidth, nBtnHeight
   DATA  cTitle
   DATA  nRow, nCol
   DATA  oTimer
   DATA  hBitmap

   /* Javier LLoris 07-10-2011 */
   DATA oBar            // Objeto para la barra
   DATA oFontBar        // Font
   DATA oFontC          // Font
   DATA oCursor         // Objeto para el cursor
   DATA lMenuActivate   // Control de activacion/desactivacion de la barra lateral
   DATA nMinV           // Rango minimo row para control scrolling vertical
   DATA nMaxV           // Rango maximo row para control scrolling vertical
   DATA nMinH           // Rango minimo col para control scrolling horizontal
   DATA nMaxH           // Rango maximo col para control scrolling horizontal
   DATA nRowMove        // Row inicial del raton para emular Hand and Push
   DATA nColMove        // Col inicial del raton para emular Hand and Push
   DATA nGroup          // Numero de botones X grupo
   DATA nBottomRow      // ::nBottom del ultimo objeto pintado
   DATA nRightCol       // ::nRight del ultimo boton pintado
   DATA lScrolingV      // Si hacemos scroll vertical
   DATA lScrolingH      // Si hacemos scroll horizontal
   DATA nOriginYY       // Es la posicion incial de ::nOriginY
   DATA nBtnWidthBack   // Es la posicion incial de nBtnWidth
   DATA nBtnHeightBack  // Es la posicion incial de nBtnHeight
   DATA nPosV           // Posicion vertical virtual actual dentro de la ventana
   DATA nPosH           // Posicion horizontal virtual actual dentro de la ventana

   /* Metodos originales de Antonio Linares */
   /* Javier Lloris: Modifico el metodo AddButton() */
   METHOD New( cTitle, nBtnWidth, nBtnHeight, cFileName )
   METHOD Activate()
   METHOD AddButton( cCaption, nClrText, nClrPane, lLarge, cImgName, bAction, oFont, cToolTip, lAdjust, cLayout )
   METHOD End() INLINE ::oWnd:End(),;
                       ::oFont:End(),;
                       ::oFontB:End(),;
                       ::oFontBar:End(),;
                       ::oFontC:End(),;
                       ::oCursor:End(),;
                       DeleteObject( ::hBitmap ),;
                       DeleteObject( ::oFont ),;
                       DeleteObject( ::oFontB ),;
                       DeleteObject( ::oFontBar ),;
                       DeleteObject( ::oFontC ),;
                       DeleteObject( ::oCursor )

   /* Javier LLoris 07-10-2011 */
   METHOD MouseMove( nRow, nCol, nKeyFlags )
   METHOD AddGif( cImgName, bAction, oFont, lAdjust, lLarge, cToolTip )
   METHOD AddBar( nBtnWidth, nBtnHeight )
   METHOD AddButtonBar( nBtnWidth, nBtnHeight, cImgName, bAction, oFont, cTooltip, lBorder, lTrans, cToolTip )
   METHOD CenterBar()
   METHOD SetScroll()
   METHOD GoUp()
   METHOD GoDown()
   METHOD ScrollLeft()
   METHOD ScrollRight()
   METHOD ScrollPgUp()
   METHOD ScrollPgDown()
   METHOD KeyChar( nKey )
   METHOD LButtonDown( nRow, nCol )
   METHOD LButtonUp( nRow, nCol )
   METHOD ScrollLeftEnd()

   METHOD SetRange( lVertical, nMin, nMax ) INLINE ;
                                 if( lVertical, ( ::nMinV := nMin, ::nMaxV := nMax ),;
                                                ( ::nMinH := nMin, ::nMaxH := nMax ) ),;
                                 SetScrollRange( ::oWnd:hWnd,;
                                                 If( lVertical, SB_VERT, SB_HORZ ), nMin, nMax, .T. )

   METHOD SeparatorRow()  INLINE ( ::nRow++ )
   METHOD SeparatorCol()  INLINE ( ::nOriginY := ::nOriginY + ::nBtnWidth + 8 )
   METHOD Group( nGroup ) INLINE ( ::nGroup := 0 )
   METHOD EndGroup()      INLINE ( ::nGroup := 4, ::SeparatorCol() )
   METHOD EndLine()       INLINE ( ::nRow++, ::nCol := 0,  ::nOriginY := ::nOriginYY )
   METHOD RestoreSet()    INLINE ( ::nBtnWidth  := ::nBtnWidthBack,;
                                   ::nBtnHeight := ::nBtnHeightBack,;
                                   ::nRow := ::nRow - 2 )

   METHOD SetButton( nWidth, nHeight ) INLINE ( ::nBtnWidth := nWidth,;
                                                ::nBtnHeight := nHeight,;
                                                ::EndLine() )
ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( cTitle, nBtnWidth, nBtnHeight, cFileName ) CLASS TMetro

   DEFAULT cTitle := "MyApp", nBtnWidth := 132, nBtnHeight := 132

   /* DATAS originales de Antonio Linares */
   ::cTitle     = cTitle
   ::aButtons   = {}
   ::nBtnWidth  = nBtnWidth
   ::nBtnHeight = nBtnHeight
   ::nOriginX   = 250
   ::nOriginY   = 200
   ::nRow       =   0
   ::nCol       =   0

   /* Javier LLoris 07-10-2011 */
   ::lMenuActivate  := .f.
   ::nMinV          := 0
   ::nMaxV          := 0
   ::nMinH          := 0
   ::nMaxH          := 0
   ::nPosV          := 0
   ::nPosH          := 0
   ::nRowMove       := 0
   ::nColMove       := 0
   ::nGroup         := 4
   ::nBottomRow     := 0
   ::nRightCol      := 0
   ::lScrolingV     := .f.
   ::lScrolingH     := .f.
   ::nOriginYY      := ::nOriginY
   ::nBtnWidthBack  := ::nBtnWidth
   ::nBtnHeightBack := ::nBtnHeight

   if File( cFileName )
      ::hBitmap = ReadBitmap( 0, cFileName )
   endif

   DEFINE FONT ::oFont    NAME "Segoe UI Light" SIZE 0, -52
   DEFINE FONT ::oFontB   NAME "Segoe UI Light" SIZE 0, -60 BOLD
   DEFINE FONT ::oFontBar NAME "Tahoma" SIZE 0,-18
   DEFINE FONT ::oFontC   NAME "Tahoma" SIZE 0,-25

   DEFINE CURSOR ::oCursor HAND

   SetBalloon( .T. )

   DEFINE WINDOW ::oWnd STYLE nOr( WS_POPUP, WS_VISIBLE );
          COLOR CLR_WHITE, RGB( 52,92,29 )

          ::oWnd:bKeyDown    = { | nKey | ::KeyChar( nKey ) }
          ::oWnd:bLClicked   = {| nRow, nCol | ::LButtonDown( nRow, nCol ) }
          ::oWnd:bLButtonUp  = {| nRow, nCol | ::LButtonUp( nRow, nCol ) }
          ::oWnd:bMMoved     = { | nRow, nCol, nFlags | ::MouseMove( nRow, nCol, nFlags ) }
          ::oWnd:bMouseWheel = { | nKey, nDelta, nXPos, nYPos | If( nDelta < 0, ::GoDown(), ::GoUp() ) }
          ::oWnd:bInit       = { || ::SetScroll() }

          @ 3, 35 SAY ::cTitle OF ::oWnd SIZE 600, 80;
                  FONT ::oFontB

          @ 8, 35 SAY "Javier LLoris, 2011 - MSN: fwh-jll@hotmail.es" SIZE 600, 80 OF ::oWnd;
                  FONT ::oFontC

  // si se usa el timer hay que averiguar pq no aplica el time() en transparente
  * DEFINE TIMER ::oTimer OF ::oWnd ACTION ::oWnd:Say( 13, 140, Time(),, RGB( 52,92,29 ), ::oFontB )
  * ACTIVATE TIMER ::oTimer

Return Self

//----------------------------------------------------------------------------//

METHOD Activate() CLASS TMetro

   ::oBar:nClrPane := CLR_BLACK
   ::oBar:SetColor( If( ValType( ::oBar:nClrText ) == "B", Eval( ::oBar:nClrText, .F. ), ::oBar:nClrText ), ::oBar:nClrPane )

   ACTIVATE WINDOW ::oWnd MAXIMIZED ;
      ON PAINT ( DrawBitmap( hDC, ::hBitmap, 0, 0, GetSysMetrics( 0 ), GetSysMetrics( 1 ) ) )

Return NIL

//----------------------------------------------------------------------------//

METHOD AddButton( cCaption, nClrText, nClrPane, lLarge, cImgName, bAction, oFont, cToolTip, lAdjust, cLayout ) CLASS TMetro

   local oBtn
   local nX := ::nOriginX + ( ::nRow * ( ::nBtnHeight + 8 ) )
   local nY := ::nOriginY + ( ::nCol * ( ::nBtnWidth + 8 ) )

   DEFAULT lLarge  := .F.,;
           lAdjust := .F.,;
           cLayout := "TOP"

   @ nX, nY BTNBMP oBtn ;
      SIZE ( ::nBtnWidth * If( lLarge, 2, 1 ) ) + If( lLarge, 8, 0 ), ::nBtnHeight ;
      OF ::oWnd FILENAME cImgName

   oBtn:oCursor  := ::oCursor
   oBtn:oFont    := oFont
   oBtn:cCaption := cCaption
   oBtn:bAction  := bAction
   oBtn:cToolTip := cToolTip
   oBtn:lAdjust  := lAdjust
   oBtn:lBorder  := .F.
   oBtn:nLayout  := AScan( aLayouts, cLayout )

   oBtn:SetColor( nClrText, nClrPane )

   AAdd( ::aButtons, oBtn )

   ::nCol++
   if lLarge
      ::nCol++
   endif

   ::nGroup++

   if ::nBottomRow <= oBtn:nBottom
      ::nBottomRow := oBtn:nBottom
   end

   if ::nRightCol <= oBtn:nRight
      ::nRightCol := oBtn:nRight
   end

return nil

//----------------------------------------------------------------------------//

METHOD MouseMove( nRow, nCol, nKeyFlags ) CLASS TMetro

  local aClient := GetClientRect( ::oWnd:hWnd )

  if nCol >= ( aClient[4] - POS_ACTIVATE_MENU )

     /* Cuando se activa la barra y existen boton debajo, hay un problema estetico que el */
     /* boton se sobrepone a la barra, para evitar esto, creo el metodo ::ScrollLeftEnd() */
     /* y lo que hacemos aqui es: que cuando se active la barra se desplacen todos los    */
     /* botones a la izquierda, ademas que queda un efecto bonito, evitamos este problema */
     /* hasta que pueda solucionarlo.                                                     */
      ::ScrollLeftEnd()

     /* Activamos que mostramos la barra */
     ::lMenuActivate = .t.

     /* Obtenemos las nuevas posiciones de la ventana */
     ::oBar:nTop  := ::oWnd:nTop
     ::oBar:nLeft := aClient[4] - ::oBar:nBtnWidth

     /* Mostramos la barra */
     ::oBar:Show()

  else

      if ::lMenuActivate
         ::oBar:Hide()
         ::lMenuActivate = .f.
      end

  End

Return NIL

//----------------------------------------------------------------------------//

METHOD AddGif( cImgName, bAction, oFont, lAdjust, lLarge, cToolTip ) CLASS TMetro

   local oBtn
   local nX := ::nOriginX + ( ::nRow * ( ::nBtnHeight + 8 ) )
   local nY := ::nOriginY + ( ::nCol * ( ::nBtnWidth + 8 ) )

   DEFAULT lLarge  := .F.,;
           lAdjust := .T.

   oBtn := TGif():New( ::oWnd,;
                       cImgName,;
                       nX,;
                       nY,;
                       ::nBtnHeight,;
                       ( ::nBtnWidth * If( lLarge, 2, 1 ) ) + If( lLarge, 8, 0 ),,;
                       lAdjust, )

   oBtn:oCursor   := ::oCursor
   oBtn:cToolTip  := cToolTip
   oBtn:bLClicked := bAction

   AAdd( ::aButtons, oBtn )

   ::nCol++
   if lLarge
      ::nCol++
   endif

   ::nGroup++

   if ::nBottomRow <= oBtn:nBottom
      ::nBottomRow := oBtn:nBottom
   end

   if ::nRightCol <= oBtn:nRight
      ::nRightCol := oBtn:nRight
   end

return nil

//----------------------------------------------------------------------------//

METHOD AddBar( nBtnWidth, nBtnHeight ) CLASS TMetro

  ::oBar := TBar():New( ::oWnd, nBtnWidth, nBtnHeight, .f.,,,.f. )
  ::oBar:GoRight()
  ::oBar:bRClicked := {|| NIL }
  ::oBar:Hide()

Return NIL

//----------------------------------------------------------------------------//

METHOD AddButtonBar( cImgName, bAction, oFont, cTooltip, lBorder, lTrans ) CLASS TMetro

   TBtnBmp():NewBar( ,,cImgName,,,;
                     bAction,;
                     .F.,;
                     ::oBar,;
                     .F.,,;
                     cToolTip,;
                     .F.,,,,,;
                     oFont,,,;
                     lBorder,,,,,;
                     lTrans )

   ::oBar:oCursor := ::oCursor
   ::oBar:Refresh()

Return NIL

//----------------------------------------------------------------------------//

METHOD CenterBar() CLASS TMetro

   local aClient  := GetClientRect( ::oWnd:hWnd )
   local nPos     := 0
   local i        := 0
   local nButtons := 0

   If Len( ::oBar:aControls ) >= 1

      nPos     := ( aClient[4] / 2 )
      nButtons := ( ( Len( ::oBar:aControls ) / 2 ) * ::oBar:nBtnWidth ) - ::oBar:nBtnWidth
      nPos     := nPos - nButtons

      for i := 1 TO  len( ::oBar:aControls )
          ::oBar:aControls[i]:nTop := nPos
          nPos := nPos + ::oBar:nBtnWidth
      next
      SysRefresh()

   end

   ::oBar:Refresh()

Return NIL

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol ) CLASS TMetro

   ::nRowMove := nRow
   ::nColMove := nCol

Return NIL

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol ) CLASS TMetro

   local i := MOVE_HAND
   local x := 0

   if ::lMenuActivate
      ::oBar:Hide()
      ::lMenuActivate = .f.
   end

   if ::lScrolingV

      if nRow < ::nRowMove
         for x := 1 TO i ; ::GoUp() ; next
      else
         if nRow > ::nRowMove
            for x := 1 TO i ; ::GoDown() ; next
         end
      end
   end

   if ::lScrolingH

      if nCol < ::nColMove
         for x := 1 TO i ; ::ScrollLeft() ; next
      else
         if nCol > ::nColMove
            for x := 1 TO i ; ::ScrollRight() ; next
         end
      end
   end

   SysRefresh()

Return NIL

//----------------------------------------------------------------------------//

METHOD KeyChar( nKey ) CLASS TMetro

   DO CASE

      CASE nKey == VK_UP
           ::GoUp()

      CASE nKey == VK_DOWN
           ::Godown()

      CASE nKey == VK_PRIOR
           ::ScrollPgUp()

      CASE nKey == VK_NEXT
           ::ScrollPgDown()

      CASE nKey == VK_HOME

      CASE nKey == VK_END

      CASE nKey == VK_LEFT
           ::ScrollLeft()

      CASE nKey == VK_RIGHT
           ::ScrollRight()

   ENDCASE

Return 0

//----------------------------------------------------------------------------//

METHOD GoUp() CLASS TMetro

  if ! ::lScrolingV
     Return NIL
  end

  if ::nPosV <= ::nMaxV
     ScrollWindow( ::oWnd:hWnd, 0, ( -1 ) * D_HEIGHT, 0 , GetClientRect( ::oWnd:hWnd ) )
     ::nPosV++
  end

Return nil

//----------------------------------------------------------------------------//

METHOD GoDown() CLASS TMetro

  if ! ::lScrolingV
     Return NIL
  end

  if ::nPosV >= ::nMinV
     ScrollWindow( ::oWnd:hWnd, 0, ( 1 ) * D_HEIGHT, 0 , GetClientRect( ::oWnd:hWnd ) )
     ::nPosV--
  end

Return nil

//----------------------------------------------------------------------------//

METHOD ScrollPgUp() CLASS TMetro

  if ! ::lScrolingV
     Return NIL
  end

  if ::nPosV <= ::nMaxV
     ScrollWindow( ::oWnd:hWnd, 0, ( -20 ), 0, GetClientRect( ::oWnd:hWnd ) )
     ::nPosV := ::nPosV + 1.5
  end

Return NIL

//----------------------------------------------------------------------------//

METHOD ScrollPgDown() CLASS TMetro

  if ! ::lScrolingV
     Return NIL
  end

  if ::nPosV >= ::nMinV
     ScrollWindow( ::oWnd:hWnd, 0, ( 20 ), 0, GetClientRect( ::oWnd:hWnd ) )
     ::nPosV := ::nPosV - 1.5
  end

Return NIL

//----------------------------------------------------------------------------//

METHOD ScrollLeft() CLASS TMetro

  if ! ::lScrolingH
     Return NIL
  end

  if ::nPosH <= ::nMaxH
     ScrollWindow( ::oWnd:hWnd, ( -1 ) * D_WIDTH, 0, 0, GetClientRect( ::oWnd:hWnd ) )
     ::nPosH++
  end

Return NIL

//----------------------------------------------------------------------------//

METHOD ScrollRight() CLASS TMetro

  if ! ::lScrolingH
     Return NIL
  end

  if ::nPosH >= ::nMinH
     ScrollWindow( ::oWnd:hWnd, ( 1 ) * D_WIDTH, 0, 0, GetClientRect( ::oWnd:hWnd ) )
     ::nPosH--
  end

Return NIL

//----------------------------------------------------------------------------//

METHOD ScrollLeftEnd() CLASS TMetro

   local n

   if ! ::lScrolingH
      Return nil
   end

  for n := ::nPosH TO ::nMaxH
     ScrollWindow( ::oWnd:hWnd, ( -1 ) * D_WIDTH, 0, 0, GetClientRect( ::oWnd:hWnd ) )
     ::nPosH++
     SysREfresh()
  next

Return NIL

//----------------------------------------------------------------------------//

METHOD SetScroll() CLASS TMetro

   local nBottom := Round ( ::nBottomRow / LINES_VERTICAL, 0 )
   local nRight  := Round ( ::nRightCol / LINES_HORIZONTAL, 0 )

   if ::nBottomRow > ::oWnd:nBottom
      ::lScrolingV := .t.
   else
     ::lScrolingV := .f.
   end

   ::SetRange( .T., ::nMinV, nBottom )

   if ::nRightCol > ::oWnd:nRight
      ::lScrolingH := .t.
   else
     ::lScrolingH := .f.
   end

   ::SetRange( .f., ::nMinH, nRight )

Return NIL