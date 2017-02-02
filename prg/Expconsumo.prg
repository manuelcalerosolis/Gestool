#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

#define HTCAPTION                         2

#define WM_NCHITTEST                      0x0084
#define WM_ERASEBKGND                     0x0014
#define WM_LBUTTONDBLCLK                  515    // 0x203

#define DT_BOTTOM                            8
#define DT_CALCRECT                       1024
#define DT_CENTER                            1
#define DT_END_ELLIPSIS             0x00008000
#define DT_EXPANDTABS                       64
#define DT_EXTERNALLEADING                 512
#define DT_INTERNAL                       4096
#define DT_LEFT                              0
#define DT_NOCLIP                          256
#define DT_NOPREFIX                       2048
#define DT_RIGHT                             2
#define DT_SINGLELINE                       32
#define DT_TABSTOP                         128
#define DT_TOP                               0
#define DT_VCENTER                           4
#define DT_WORDBREAK                        16
#define DT_WORD_ELLIPSIS            0x00040000

#define CLRTEXTBACK         RGB( 113, 106, 183 )


//---------------------------------------------------------------------------//

#define itmMesaRedonda                    1
#define itmMesaEliptica                   2
#define itmMesaCuadrada                   3
#define itmMesaRectangular                4

#define itmBarrraHorizontal               5
#define itmBarrraVertical                 6
#define itmBarrraEsquinaDerechaAbajo      7
#define itmBarrraEsquinaIzquierdaAbajo    8
#define itmBarrraEsquinaDerechaArriba     9
#define itmBarrraEsquinaIzquierdaArriba   10

#define itmPlantaBlanca                   11
#define itmPlantaAmarilla                 12
#define itmPlantaAzul                     13
#define itmPlantaRoja                     14

#define itmPanelHorizontal                15
#define itmPanelVertical                  16
#define itmPanelCruce                     17
#define itmPanelConexionAbajo             18
#define itmPanelConexionArriba            19
#define itmPanelConexionIzquierda         20

//---------------------------------------------------------------------------//

Function Salones()

   local oSalon   := TSalon():New()

Return nil

//---------------------------------------------------------------------------//

CLASS TSalon

   DATA  oWnd
   DATA  oOfficeBar
   DATA  aUndo

   DATA  oDbf

   DATA  nItemToInsert

   METHOD New()
   METHOD SaveToDatabase()
   METHOD LoadFromDatabase()
   METHOD SaveToStream()
   METHOD LoadFromStream()
   METHOD AddUndo( oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 )
   METHOD Undo()
   METHOD SelectItem( nItem )
   METHOD ClickSalon()
   METHOD UnSelectButtons()

   //------------------------------------------------------------------------//

   METHOD CreateItemMesaRedonda( nRow, nCol, uTooltip )     INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaRedonda, "Shape_circle_80" )

   METHOD CreateItemMesaEliptica( nRow, nCol, uTooltip )    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaEliptica, "Shape_ellipse_80" )

   METHOD CreateItemMesaCuadrada( nRow, nCol, uTooltip )    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaCuadrada, "Shape_square_80" )

   METHOD CreateItemMesaRectangular( nRow, nCol, uTooltip ) INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaRectangular, "Shape_rectangle_80" )

   METHOD CreateItemBarraHorizontal( nRow, nCol, uTooltip )                INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraHorizontal, "Bar_center_64" )

   METHOD CreateItemBarraVertical( nRow, nCol, uTooltip )                  INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraVertical, "Bar_left_64" )

   METHOD CreateItemBarrraEsquinaDerechaAbajo( nRow, nCol, uTooltip )      INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaDerechaAbajo, "Bar_corner_left_64" )

   METHOD CreateItemBarrraEsquinaIzquierdaAbajo( nRow, nCol, uTooltip )    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaIzquierdaAbajo, "Bar_corner_right_64" )

   METHOD CreateItemBarrraEsquinaDerechaArriba( nRow, nCol, uTooltip )     INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaDerechaArriba, "Bar_corner_top_left_64" )

   METHOD CreateItemBarrraEsquinaIzquierdaArriba( nRow, nCol, uTooltip )   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaIzquierdaArriba, "Bar_corner_top_right_64" )

   METHOD CreateItemPlantaBlanca( nRow, nCol )                             INLINE ::CreateItemMesa( nRow, nCol, "", 32, 32, itmPlantaBlanca, "Flower_white_32" )

   METHOD CreateItemPlantaAzul( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, "", 32, 32, itmPlantaAzul, "Flower_blue_32" )

   METHOD CreateItemPlantaRoja( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, "", 32, 32, itmPlantaRoja, "Flower_red_32" )

   METHOD CreateItemPlantaAmarilla( nRow, nCol )                           INLINE ::CreateItemMesa( nRow, nCol, "", 32, 32, itmPlantaAmarilla, "Flower_yellow_32" )

   METHOD CreateItemPanelHorizontal( nRow, nCol )                          INLINE ::CreateItemMesa( nRow, nCol, "", 64, 64, itmPanelHorizontal, "Navigate2_minus_64" )

   METHOD CreateItemPanelVertical( nRow, nCol )                            INLINE ::CreateItemMesa( nRow, nCol, "", 64, 64, itmPanelVertical, "Navigate_panel_64" )

   METHOD CreateItemPanelCruce( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, "", 64, 64, itmPanelCruce, "Navigate2_plus_64" )

   METHOD CreateItemPanelConexionAbajo( nRow, nCol )                       INLINE ::CreateItemMesa( nRow, nCol, "", 64, 64, itmPanelConexionAbajo, "Navigate_connection_down_64" )

   METHOD CreateItemPanelConexionIzquierda( nRow, nCol )                   INLINE ::CreateItemMesa( nRow, nCol, "", 64, 64, itmPanelConexionIzquierda, "Navigate_corner_left_64" )

   //------------------------------------------------------------------------//

   INLINE METHOD CreateItemMesa( nRow, nCol, uTooltip, nWidth, nHeight, nType, cBitmap )

      DEFAULT nWidth       := 80
      DEFAULT nHeight      := 80
      DEFAULT uToolTip     := .f.
      DEFAULT nType        := itmMesaRectangular
      DEFAULT cBitmap      := "Shape_rectangle_80"

      with object ( TMesa():New( nRow, nCol, nWidth, nHeight, ::oWnd:oClient ) )

         :nType            := nType
         :cBitmap          := cBitmap

         :LoadBitmap()

         do case
         case Valtype( uTooltip ) == "C"
            :cTooltip      := uToolTip
         case Valtype( uTooltip ) == "L" .and. uTooltip
            :cTooltip      := VirtualKey( .f., "", "Nombre de la mesa" )
         end case

         :Refresh()

      end with

   ENDMETHOD

   //------------------------------------------------------------------------//

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( oDbf )

   local oGrupo
   local oBoton
   local oCarpeta

   ::oDbf                        := oDbf

   ::nItemToInsert               := 0

   DEFINE WINDOW ::oWnd TITLE "Diseñador"

      ::oOfficeBar               := TDotNetBar():New( 0, 0, 1000, 120, ::oWnd, 1 )
      ::oOfficeBar:lPaintAll     := .f.

      ::oOfficeBar:SetStyle( 1 )

      ::oWnd:oTop                := ::oOfficeBar

      ::oWnd:oClient             := TPanelEx():New()

      ::oWnd:oClient:OnClick     := {| nRow, nCol | ::ClickSalon( nil, nRow, nCol, .t. ) }

      oCarpeta                   := TCarpeta():New( ::oOfficeBar, "Objetos" )

      oGrupo                     := TDotNetGroup():New( oCarpeta, 126, "Acciones", .f. )

      oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32",         "Grabar y salir",    1, {|| ::SaveToDatabase() }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_door_open2_32",              "Salir sin grabar",  2, {|| ::oWnd:End() }, , , .f., .f., .f. )

      oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Selección", .f. )

      oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_sign_stop_32",       "Quitar selección",  1, {|| ::UnSelectButtons() }, , , .f., .f., .f. )

      oGrupo                     := TDotNetGroup():New( oCarpeta, 246, "Mesas", .f. )

      oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_circle_32",      "Redonda",        1, {| oBtn | ::SelectItem( itmMesaRedonda, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_ellipse_32",     "Eliptica",       2, {| oBtn | ::SelectItem( itmMesaEliptica, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_square_32",      "Cuadrada",       3, {| oBtn | ::SelectItem( itmMesaCuadrada, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_rectangle_32",   "Rectangular",    4, {| oBtn | ::SelectItem( itmMesaRectangular, oBtn ) }, , , .f., .f., .f. )

      oGrupo                     := TDotNetGroup():New( oCarpeta, 366, "Barra", .f. )

      oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_center_32",           "Horizontal",        1, {| oBtn | ::SelectItem( itmBarrraHorizontal, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_left_32",             "Vertical",          2, {| oBtn | ::SelectItem( itmBarrraVertical, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_left_32",      "Derecha abajo",     3, {| oBtn | ::SelectItem( itmBarrraEsquinaDerechaAbajo, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_right_32",     "Izquierda abajo",   4, {| oBtn | ::SelectItem( itmBarrraEsquinaIzquierdaAbajo, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_top_left_32",  "Derecha arriba",    5, {| oBtn | ::SelectItem( itmBarrraEsquinaDerechaArriba, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_top_right_32", "Izquierda arriba",  6, {| oBtn | ::SelectItem( itmBarrraEsquinaIzquierdaArriba, oBtn ) }, , , .f., .f., .f. )

      oGrupo                     := TDotNetGroup():New( oCarpeta, 246, "Plantas", .f. )

      oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_white_32",      "Blanca",         1, {| oBtn | ::SelectItem( itmPlantaBlanca, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_blue_32",       "Azul",           2, {| oBtn | ::SelectItem( itmPlantaAzul, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_red_32",        "Roja",           3, {| oBtn | ::SelectItem( itmPlantaRoja, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_yellow_32",     "Amarilla",       4, {| oBtn | ::SelectItem( itmPlantaAmarilla, oBtn ) }, , , .f., .f., .f. )

      oGrupo                     := TDotNetGroup():New( oCarpeta, 366, "Paneles", .f. )

      oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate2_minus_32",            "Horizontal",        1, {| oBtn | ::SelectItem( itmPanelHorizontal, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_panel_32",             "Vertical",          2, {| oBtn | ::SelectItem( itmPanelVertical, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate2_plus_32",             "Cruce",             3, {| oBtn | ::SelectItem( itmPanelCruce, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_connection_down_32",   "Conexión abajo",    4, {| oBtn | ::SelectItem( itmPanelConexionAbajo, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_connection_up_32",     "Conexión arriba",   5, {| oBtn | ::SelectItem( itmPanelConexionArriba, oBtn ) }, , , .f., .f., .f. )
      oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_corner_left_32",       "Conexión izquierda",6, {| oBtn | ::SelectItem( itmPanelConexionIzquierda, oBtn ) }, , , .f., .f., .f. )

      /*
      */

      /*
      TMesa():New( 200,920,64,64,::oWnd:oClient ):LoadBitmap( "navigate_corner_left.bmp")
      TMesa():New( 200,990,64,64,::oWnd:oClient ):LoadBitmap( "navigate_corner_right.bmp")
      TMesa():New( 200,1060,64,64,::oWnd:oClient ):LoadBitmap( "navigate_corner_right_down.bmp")
      TMesa():New( 200,1130,64,64,::oWnd:oClient ):LoadBitmap( "navigate_corner_right_top.bmp")
      TMesa():New( 200,1200,64,64,::oWnd:oClient ):LoadBitmap( "navigate_left.bmp")
      TMesa():New( 200,1270,64,64,::oWnd:oClient ):LoadBitmap( "navigate_right.bmp")

      TMesa():New( 300,10,64,64,::oWnd:oClient ):LoadBitmap(  "bar_center.bmp"           )
      TMesa():New( 300,80,64,64,::oWnd:oClient ):LoadBitmap(  "bar_corner_left.bmp"      )
      TMesa():New( 300,150,64,64,::oWnd:oClient ):LoadBitmap( "bar_corner_right.bmp"     )
      TMesa():New( 300,220,64,64,::oWnd:oClient ):LoadBitmap( "bar_corner_top_left.bmp"  )
      TMesa():New( 300,290,64,64,::oWnd:oClient ):LoadBitmap( "bar_corner_top_right.bmp" )
      TMesa():New( 300,360,64,64,::oWnd:oClient ):LoadBitmap( "bar_left.bmp"             )
      */

   ACTIVATE WINDOW ::oWnd MAXIMIZED // ON INIT ( ::LoadFromStream() )

   ::LoadFromDatabase()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD AddUndo( oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 ) CLASS TSalon

   aadd( ::aUndo, { oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 } )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaveToStream() CLASS TSalon

   local nHand
   local cStream  := ""
   local oControl

   for each oControl in ::oWnd:oClient:aControls
      cStream     += oControl:SaveToStream()
   next

   if !File( "Salon.txt" )
      nHand       := fCreate( "Salon.txt" )
   else
      nHand       := fOpen( "Salon.txt", 1 )
   endif

   fWrite( nHand, cStream )
   fClose( nHand )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaveToDatabase() CLASS TSalon

   local oControl

   if !Empty( ::oDbf ) .and. ::oDbf:Used()

      ::oDbf:Zap()

      for each oControl in ::oWnd:oClient:aControls
         ::oDbf:Blank()
         ::oDbf:nType      := oControl:nType
         ::oDbf:nRow       := oControl:nTop
         ::oDbf:nCol       := oControl:nLeft
         ::oDbf:cDescrip   := oControl:cTooltip
         ::oDbf:Insert()
      next

      ::oDbf:GoTop()

   end if

   ::oWnd:End()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadFromDatabase() CLASS TSalon

   if !Empty( ::oDbf ) .and. ::oDbf:Used()

      ::oDbf:GoTop()
      while !::oDbf:Eof()
         ::ClickSalon( Max( ::oDbf:nType, 1 ), ::oDbf:nRow, ::oDbf:nCol, Rtrim( ::oDbf:cDescrip ) )
         ::oDbf:Skip()
      end while

      ::oDbf:GoTop()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadFromStream() CLASS TSalon

   local cItem
   local cStream  := MemoRead( "Salon.txt" )

   for each cItem in hb_aTokens( cStream, ";" )
      ::ClickSalon( Val( StrToken( cItem, 1, "," ) ), Val( StrToken( cItem, 2, "," ) ), Val( StrToken( cItem, 3, "," ) ), StrToken( cItem, 4, "," ) )
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Undo() CLASS TSalon

   local oShape
   local cAction
   local uVal1
   local uVal2
   local uVal3
   local uVal4
   local uVal5
   local aUndo := aTail( ::aUndo )

   if empty( aUndo )
      msgStop( "No hay acciones para deshacer" )
      return nil
   endif

   oShape  := aUndo[1]
   cAction := aUndo[2]
   uVal1   := aUndo[3]
   uVal2   := aUndo[4]
   uVal3   := aUndo[5]
   uVal4   := aUndo[6]
   uVal5   := aUndo[7]

   OSend( oShape, cAction, uVal1, uVal2, uVal3, uVal4, uVal5 )

   aDel( ::aUndo, len( ::aUndo ), .t. )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SelectItem( nItem, oBtnItem ) CLASS TSalon

   ::UnSelectButtons()

   /*
   Seleciona el boton actual---------------------------------------------------
   */

   oBtnItem:lSelected   := .t.

   /*
   Item seleccionado-----------------------------------------------------------
   */

   ::nItemToInsert      := nItem

Return ( Self )

//---------------------------------------------------------------------------//

METHOD UnSelectButtons() CLASS TSalon

   local oCarpeta
   local oGrupo
   local oBoton

   /*
   Quita la selección de todos los controles-----------------------------------
   */

   for each oCarpeta in ::oOfficeBar:aCarpetas
      for each oGrupo in oCarpeta:aGrupos
         for each oBoton in oGrupo:aItems
            oBoton:lSelected  := .f.
         next
      next
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ClickSalon( nItem, nRow, nCol, lGetName ) CLASS TSalon

   local oItem

   DEFAULT nItem        := ::nItemToInsert
   DEFAULT nRow         := 0
   DEFAULT nCol         := 0
   DEFAULT lGetName     := .f.

   do case
      case nItem == itmMesaRedonda
         ::CreateItemMesaRedonda( nRow, nCol, lGetName )

      case nItem == itmMesaEliptica
         ::CreateItemMesaEliptica( nRow, nCol, lGetName )

      case nItem == itmMesaCuadrada
         ::CreateItemMesaCuadrada( nRow, nCol, lGetName )

      case nItem == itmMesaRectangular
         ::CreateItemMesaRectangular( nRow, nCol, lGetName )

      case nItem == itmBarrraHorizontal
         ::CreateItemBarraHorizontal( nRow, nCol, lGetName )

      case nItem == itmBarrraVertical
         ::CreateItemBarraVertical( nRow, nCol, lGetName )

      case nItem == itmBarrraEsquinaDerechaAbajo
         ::CreateItemBarrraEsquinaDerechaAbajo( nRow, nCol, lGetName )

      case nItem == itmBarrraEsquinaIzquierdaAbajo
         ::CreateItemBarrraEsquinaIzquierdaAbajo( nRow, nCol, lGetName )

      case nItem == itmBarrraEsquinaDerechaArriba
         ::CreateItemBarrraEsquinaDerechaArriba( nRow, nCol, lGetName )

      case nItem == itmBarrraEsquinaIzquierdaArriba
         ::CreateItemBarrraEsquinaIzquierdaArriba( nRow, nCol, lGetName )

      case nItem == itmPlantaBlanca
         ::CreateItemPlantaBlanca( nRow, nCol )

      case nItem == itmPlantaAzul
         ::CreateItemPlantaAzul( nRow, nCol )

      case nItem == itmPlantaAmarilla
         ::CreateItemPlantaAmarilla( nRow, nCol )

      case nItem == itmPlantaRoja
         ::CreateItemPlantaRoja( nRow, nCol )

      case nItem == itmPanelHorizontal
         ::CreateItemPanelHorizontal( nRow, nCol )

      case nItem == itmPanelVertical
         ::CreateItemPanelVertical( nRow, nCol )

      case nItem == itmPanelCruce
         ::CreateItemPanelCruce( nRow, nCol )

      case nItem == itmPanelConexionAbajo
         ::CreateItemPanelConexionAbajo( nRow, nCol )

   end case

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TMesa FROM TControl

   CLASSDATA lRegistered AS LOGICAL
   CLASSDATA oFont

   // CLASSDATA oBshEnable

   DATA nType
   DATA cBitmap
   DATA hBmp

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CONSTRUCTOR

   METHOD HandleEvent( nMsg, nWParam, nLParam )
   METHOD RButtonDown( nRow, nCol, nKeyFlags )

   Method LoadBitmap( cBitmap )

   METHOD SaveToStream()
   METHOD Rename()

   METHOD Paint()
   METHOD Display()  INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint(), 0 )
   METHOD End()      INLINE ( DeleteObject( ::hBmp ), Super:End() )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd ) CLASS TMesa

   ::nStyle    := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, 0 ) //, WS_CLIPCHILDREN
   ::nId       := ::GetNewId()
   ::oWnd      := oWnd
   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := nTop + nHeight - 1
   ::nRight    := nLeft + nWidth - 1

   ::oFont     := TFont():New( "Ms Sans Serif", 0, -12 )

   // DEFINE BRUSH ::oBshEnable COLOR CLR_GREEN

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if !Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )
   else
      oWnd:DefControl( Self )
   endif

Return self

//---------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TMesa

   local oMenu
   local bMenuSelect
   local aPoint      := { nRow, nCol }

   aPoint            := ScreenToClient( ::hWnd, aPoint )

   /*
   Montamos el menu------------------------------------------------------------
   */

   oMenu             := MenuBegin( .t. )
   bMenuSelect       := ::bMenuSelect

   ::bMenuSelect     := nil

   MenuAddItem( "Cambiar nombre", "Cambiar nombre a la mesa", .f., .t., {|| ::Rename() }, , "gc_text_field_16", oMenu )

   MenuAddItem( "Eliminar", "Eliminar mesa del salón", .f., .t., {|| ::End() }, , "Del16", oMenu )

   MenuEnd()

   oMenu:Activate( aPoint[ 1 ], aPoint[ 2 ], Self )

   ::bMenuSelect     := bMenuSelect

   oMenu:end()

Return self

//---------------------------------------------------------------------------//

METHOD LoadBitmap() CLASS TMesa

   local h

   if !Empty( ::cBitMap )
      ::hBmp            := LoadBitmap( GetResources(), ::cBitmap ) //ReadBitmap( ::hDC, ::cBitmap )
      h                 := BitmapToRegion( ::hBmp, rgb(255,0,255) )
      SetWindowRgn(::hWnd, h, .t. )
      DeleteObject( h )
   end if

Return self

//---------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TMesa

   do case
      case nMsg == 0x00A4 // WM_NCRBUTTONDOWN
         return ::RButtonDown( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )

      case nMsg == 0x00A3 // Doble click
         return 0

      case nMsg == WM_NCHITTEST
         ::Refresh()
         return HTCAPTION

      case nMsg == WM_ERASEBKGND
         return 1

   end case

Return ( Super:HandleEvent( nMsg, nWParam, nLParam ) )

//---------------------------------------------------------------------------//

METHOD SaveToStream() CLASS TMesa

   local cStream  := ""

   cStream        += Str( ::nType )             + ","
   cStream        += Str( ::nTop )              + ","
   cStream        += Str( ::nLeft )             + ","
   cStream        += cValToChar( ::cTooltip )   + ";"

Return ( cStream )

//---------------------------------------------------------------------------//

METHOD Rename() CLASS TMesa

   local cTooltip := Padr( ::cTooltip, 100 )

   cTooltip       := VirtualKey( .f., cTooltip, "Nombre de la mesa" )

   if !Empty( cTooltip )
      ::cTooltip  := cTooltip
      ::Refresh()
   end if

Return ( ::cTooltip )

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TMesa

   local hFont
   local nColor
   local nMode

   DrawBitmap( ::hDC, ::hBmp, 0, 0 )

   hFont    := SelectObject( ::hDC, ::oFont:hFont )
   nColor   := SetTextColor( ::hDC, Rgb( 0,0,0 ) )
   nMode    := SetBkMode( ::hDC, 1 )

   if !Empty( ::cTooltip )
      DrawText( ::hDC, ::cToolTip, { 0, 0, ::nWidth(), ::nHeight() }, nOr( DT_SINGLELINE, DT_WORDBREAK, DT_CENTER, DT_VCENTER, DT_WORD_ELLIPSIS ) )
   end if

   SetBkMode   ( ::hDC, nMode    )
   SetTextColor( ::hDC, nColor   )
   SelectObject( ::hDC, hFont    )

   // FillRect( ::hDC, { 40, 40, 70, 70 }, ::oBshEnable:hBrush )

Return 0

//---------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <C:\bcc55\Include\windows.h>
#include <C:\bcc55\Include\winuser.h>
#include <C:\bcc55\Include\wingdi.h>
#include "hbapi.h"

//HRGN BitmapToRegion (HBITMAP hBmp, COLORREF cTransparentColor = 0, COLORREF cTolerance = 0x101010)
HB_FUNC( BITMAPTOREGION )
{
   HBITMAP hBmp = ( HBITMAP) hb_parnl( 1 );
   COLORREF cTransparentColor = hb_parnl( 2 );
   COLORREF cTolerance = hb_parnl( 3 );
   BITMAP bm;
   HDC hMemDC;
   VOID * pbits32;
   HBITMAP hbm32;
   HBITMAP holdBmp;
   HDC hDC;
   BITMAP bm32;
   DWORD maxRects;
   HANDLE hData;
   RGNDATA *pData;
   BYTE lr;
   BYTE lg;
   BYTE lb;
   BYTE hr;
   BYTE hg;
   BYTE hb;
   BYTE *p32;
   int x;
   int y;
   int x0;
   LONG *p;
   BYTE b;
   RECT *pr;
   HRGN h;
   BITMAPINFOHEADER RGB32BITSBITMAPINFO = {
   	sizeof(BITMAPINFOHEADER),	// biSize
   	0,			// biWidth;
   	0,			// biHeight;
   	1,				// biPlanes;
   	32,				// biBitCount
   	BI_RGB,				// biCompression;
   	0,				// biSizeImage;
   	0,				// biXPelsPerMeter;
   	0,				// biYPelsPerMeter;
   	0,				// biClrUsed;
   	0				// biClrImportant;
   };

   HRGN hRgn = NULL;
   if (hBmp)
   {
   	// Create a memory DC inside which we will scan the bitmap content
   	hMemDC = CreateCompatibleDC(NULL);
   	if (hMemDC)
   	{
   		// Get bitmap size

   		GetObject(hBmp, sizeof(bm), &bm);
                RGB32BITSBITMAPINFO.biWidth = bm.bmWidth;
                RGB32BITSBITMAPINFO.biHeight = bm.bmHeight;

   		// Create a 32 bits depth bitmap and select it into the memory DC

   		hbm32 = CreateDIBSection(hMemDC, (BITMAPINFO *)&RGB32BITSBITMAPINFO, DIB_RGB_COLORS, &pbits32, NULL, 0);
   		if (hbm32)
   		{
   			holdBmp = (HBITMAP)SelectObject(hMemDC, hbm32);

   			// Create a DC just to copy the bitmap into the memory DC
   			hDC = CreateCompatibleDC(hMemDC);
   			if (hDC)
   			{
   				// Get how many bytes per row we have for the bitmap bits (rounded up to 32 bits)

   				GetObject(hbm32, sizeof(bm32), &bm32);
   				while (bm32.bmWidthBytes % 4)
   					bm32.bmWidthBytes++;

   				// Copy the bitmap into the memory DC
   				holdBmp = (HBITMAP)SelectObject(hDC, hBmp);
   				BitBlt(hMemDC, 0, 0, bm.bmWidth, bm.bmHeight, hDC, 0, 0, SRCCOPY);

   				// For better performances, we will use the ExtCreateRegion() function to create the
   				// region. This function take a RGNDATA structure on entry. We will add rectangles by
   				// amount of ALLOC_UNIT number in this structure.
   				#define ALLOC_UNIT	100
   				maxRects = ALLOC_UNIT;
   				hData   = GlobalAlloc(GMEM_MOVEABLE, sizeof(RGNDATAHEADER) + (sizeof(RECT) * maxRects));
   				pData = (RGNDATA *)GlobalLock(hData);
   				pData->rdh.dwSize = sizeof(RGNDATAHEADER);
   				pData->rdh.iType = RDH_RECTANGLES;
   				pData->rdh.nCount = pData->rdh.nRgnSize = 0;
   				SetRect(&pData->rdh.rcBound, MAXLONG, MAXLONG, 0, 0);

   				// Keep on hand highest and lowest values for the "transparent" pixels
   				lr = GetRValue(cTransparentColor);
   				lg = GetGValue(cTransparentColor);
   				lb = GetBValue(cTransparentColor);
   				hr = min(0xff, lr + GetRValue(cTolerance));
   				hg = min(0xff, lg + GetGValue(cTolerance));
   				hb = min(0xff, lb + GetBValue(cTolerance));

   				// Scan each bitmap row from bottom to top (the bitmap is inverted vertically)
   				p32 = (BYTE *)bm32.bmBits + (bm32.bmHeight - 1) * bm32.bmWidthBytes;
   				for ( y = 0; y < bm.bmHeight; y++)
   				{
   					// Scan each bitmap pixel from left to right
   					for (x = 0; x < bm.bmWidth; x++)
   					{
   						// Search for a continuous range of "non transparent pixels"
   						x0  = x;
   						p = (LONG *)p32 + x;
   						while (x < bm.bmWidth)
   						{
   							b = GetRValue(*p);
   							if (b >= lr && b <= hr)
   							{
   								b = GetGValue(*p);
   								if (b >= lg && b <= hg)
   								{
   									b = GetBValue(*p);
   									if (b >= lb && b <= hb)
   										// This pixel is "transparent"
   										break;
   								}
   							}
   							p++;
   							x++;
   						}

   						if (x > x0)
   						{
   							// Add the pixels (x0, y) to (x, y+1) as a new rectangle in the region
   							if (pData->rdh.nCount >= maxRects)
   							{
   								GlobalUnlock(hData);
   								maxRects += ALLOC_UNIT;
   								hData = GlobalReAlloc(hData, sizeof(RGNDATAHEADER) + (sizeof(RECT) * maxRects), GMEM_MOVEABLE);
   								pData = (RGNDATA *)GlobalLock(hData);
   							}
   							pr = (RECT *)&pData->Buffer;
   							SetRect(&pr[pData->rdh.nCount], x0, y, x, y+1);
   							if (x0 < pData->rdh.rcBound.left)
   								pData->rdh.rcBound.left = x0;
   							if (y < pData->rdh.rcBound.top)
   								pData->rdh.rcBound.top = y;
   							if (x > pData->rdh.rcBound.right)
   								pData->rdh.rcBound.right = x;
   							if (y+1 > pData->rdh.rcBound.bottom)
   								pData->rdh.rcBound.bottom = y+1;
   							pData->rdh.nCount++;

   							// On Windows98, ExtCreateRegion() may fail if the number of rectangles is too
   							// large (ie: > 4000). Therefore, we have to create the region by multiple steps.
   							if (pData->rdh.nCount == 2000)
   							{
   								h = ExtCreateRegion(NULL, sizeof(RGNDATAHEADER) + (sizeof(RECT) * maxRects), pData);
   								if (hRgn)
   								{
   									CombineRgn(hRgn, hRgn, h, RGN_OR);
   									DeleteObject(h);
   								}
   								else
   									hRgn = h;
   								pData->rdh.nCount = 0;
   								SetRect(&pData->rdh.rcBound, MAXLONG, MAXLONG, 0, 0);
   							}
   						}
   					}

   					// Go to next row (remember, the bitmap is inverted vertically)
   					p32 -= bm32.bmWidthBytes;
   				}

   				// Create or extend the region with the remaining rectangles
   				h = ExtCreateRegion(NULL, sizeof(RGNDATAHEADER) + (sizeof(RECT) * maxRects), pData);
   				if (hRgn)
   				{
   					CombineRgn(hRgn, hRgn, h, RGN_OR);
   					DeleteObject(h);
   				}
   				else
   					hRgn = h;

   				// Clean up
   				SelectObject(hDC, holdBmp);
   				DeleteDC(hDC);
   			}

   			DeleteObject(SelectObject(hMemDC, holdBmp));
   		}

   		DeleteDC(hMemDC);
   	}
   }

    hb_retnl( (LONG) hRgn );
}


/*int SetWindowRgn(
  HWND hWnd,     // handle to window
  HRGN hRgn,     // handle to region
  BOOL bRedraw   // window redraw option
);*/

HB_FUNC( SETWINDOWRGN )
{
   hb_retni( SetWindowRgn( ( HWND ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ), hb_parl( 3 ) ) );
}


HB_FUNC( CREATEROUNDRECTRGN )
{
   hb_retnl( (long) CreateRoundRectRgn( hb_parni( 1 ),hb_parni( 2 ),hb_parni( 3 ),hb_parni( 4 ),hb_parni( 5 ),hb_parni( 6 )));
}


#pragma ENDDUMP

//---------------------------------------------------------------------------//