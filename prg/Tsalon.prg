#ifndef __PDA__
   #include "FiveWin.Ch"
   #include "Ini.ch"
#else
   #include "FWCE.ch"
   #include "WinApi.ch"
   REQUEST DBFCDX
#endif

#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

#ifndef __PDA__

#define HTCAPTION                            2

#define WM_NCHITTEST                         0x0084
#define WM_ERASEBKGND                        0x0014
#define WM_LBUTTONDBLCLK                     515    // 0x203

#define DT_BOTTOM                            8
#define DT_CALCRECT                          1024
#define DT_CENTER                            1
#define DT_END_ELLIPSIS                      0x00008000
#define DT_EXPANDTABS                        64
#define DT_EXTERNALLEADING                   512
#define DT_INTERNAL                          4096
#define DT_LEFT                              0
#define DT_NOCLIP                            256
#define DT_NOPREFIX                          2048
#define DT_RIGHT                             2
#define DT_SINGLELINE                        32
#define DT_TABSTOP                           128
#define DT_TOP                               0
#define DT_VCENTER                           4
#define DT_WORDBREAK                         16
#define DT_WORD_ELLIPSIS                     0x00040000

#define BITMAP_HANDLE                        1
#define BITMAP_PALETTE                       2
#define BITMAP_WIDTH                         3
#define BITMAP_HEIGHT                        4
#define BITMAP_ZEROCLR                       5

#define CLRTEXTBACK                          RGB( 113, 106, 183 )

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
#define itmPanelConexionDerecha           20
#define itmPanelConexionIzquierda         21
#define itmPanelCurvaAbajo                22
#define itmPanelCurvaDerecha              23
#define itmPanelCurvaIzquierda            24
#define itmPanelCurvaArriba               25

#define itmGenerico                       26
#define itmLlevar                         27
#define itmNewGenerico                    28
#define itmNewLlevar                      29

#define itmStateLibre                     1
#define itmStateOcupada                   2

#else

#define itmMesaPda                        1

#endif

#define NINICIO                           0
#define NROWINSERT                       28
#define NCOLINSERT                        2

#define ubiGeneral                        0
#define ubiLlevar                         1
#define ubiSala                           2

//---------------------------------------------------------------------------//

Function Salones()

   local oSalon   := TSalon():New()

Return nil

//---------------------------------------------------------------------------//

CLASS TSalon

   DATA  oWnd
   DATA  oOfficeBar

   CLASSDATA   aBitmapsState

   DATA  oDbfSala
   DATA  oDbfSalon

   DATA  nItemToInsert

   DATA  lDesign

   DATA  oSelectedPunto

   DATA  oSalaVenta

   DATA  nRowToInsert
   DATA  nColToInsert
   DATA  oBtnBmp

   DATA  oBtnGenerico
   DATA  oBtnLlevar

   DATA  oBtnSalirSalon

   DATA  aMesas

   METHOD New()
   METHOD End()
   METHOD Close()

   METHOD Design()

   Method InitDesign()

   METHOD InitSelector( oDlg )

   METHOD SelectSala( oBtnItem )

   METHOD SelectGenerico()

   METHOD SelectLlevar()

   METHOD SaveToDatabase()
   METHOD LoadFromDatabase()

   METHOD SelectItem( nItem )
   METHOD UnSelectButtons()
   METHOD CreateFromPunto( sPunto )

   METHOD LoadGenericosPendientes( dbfTikT, lPuntosPendientes )
   METHOD LoadUbicacionGeneral( dbfTikT )
   METHOD LoadLlevarPendientes( dbfTikT, lPuntosPendientes )

   METHOD CreateItemMesa( nRow, nCol, uTooltip, nWidth, nHeight, nType, cBitmap )

   METHOD CreateItemMesaRedonda( nRow, nCol, uTooltip )                    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaRedonda, "Shape_circle_80" )

   METHOD CreateItemMesaEliptica( nRow, nCol, uTooltip )                   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaEliptica, "Shape_ellipse_80" )

   METHOD CreateItemMesaCuadrada( nRow, nCol, uTooltip )                   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaCuadrada, "Shape_square_80" )

   METHOD CreateItemMesaRectangular( nRow, nCol, uTooltip )                INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 80, 80, itmMesaRectangular, "Shape_rectangle_80" )

   METHOD CreateItemBarraHorizontal( nRow, nCol, uTooltip )                INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraHorizontal, "Bar_center_64" )

   METHOD CreateItemBarraVertical( nRow, nCol, uTooltip )                  INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraVertical, "Bar_left_64" )

   METHOD CreateItemBarrraEsquinaDerechaAbajo( nRow, nCol, uTooltip )      INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaDerechaAbajo, "Bar_corner_left_64" )

   METHOD CreateItemBarrraEsquinaIzquierdaAbajo( nRow, nCol, uTooltip )    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaIzquierdaAbajo, "Bar_corner_right_64" )

   METHOD CreateItemBarrraEsquinaDerechaArriba( nRow, nCol, uTooltip )     INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaDerechaArriba, "Bar_corner_top_left_64" )

   METHOD CreateItemBarrraEsquinaIzquierdaArriba( nRow, nCol, uTooltip )   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 64, 64, itmBarrraEsquinaIzquierdaArriba, "Bar_corner_top_right_64" )

   METHOD CreateItemPlantaBlanca( nRow, nCol )                             INLINE ::CreateItemMesa( nRow, nCol, nil, 32, 32, itmPlantaBlanca, "Flower_white_32" )

   METHOD CreateItemPlantaAzul( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, nil, 32, 32, itmPlantaAzul, "Flower_blue_32" )

   METHOD CreateItemPlantaRoja( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, nil, 32, 32, itmPlantaRoja, "Flower_red_32" )

   METHOD CreateItemPlantaAmarilla( nRow, nCol )                           INLINE ::CreateItemMesa( nRow, nCol, nil, 32, 32, itmPlantaAmarilla, "Flower_yellow_32" )

   METHOD CreateItemPanelHorizontal( nRow, nCol )                          INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelHorizontal, "Navigate2_minus_64" )

   METHOD CreateItemPanelVertical( nRow, nCol )                            INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelVertical, "Navigate_panel_64" )

   METHOD CreateItemPanelCruce( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelCruce, "Navigate2_plus_64" )

   METHOD CreateItemPanelConexionArriba( nRow, nCol )                      INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelConexionArriba, "Navigate_connection_up_64" )

   METHOD CreateItemPanelConexionAbajo( nRow, nCol )                       INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelConexionAbajo, "Navigate_connection_down_64" )

   METHOD CreateItemPanelConexionDerecha( nRow, nCol )                     INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelConexionDerecha, "Navigate_right_64" )

   METHOD CreateItemPanelConexionIzquierda( nRow, nCol )                   INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelConexionIzquierda, "Navigate_left_64" )

   METHOD CreateItemPanelCurvaAbajo( nRow, nCol )                          INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelCurvaAbajo, "Navigate_corner_left_64" )

   METHOD CreateItemPanelCurvaArriba( nRow, nCol )                         INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelCurvaArriba, "Navigate_corner_right_top_64" )

   METHOD CreateItemPanelCurvaDerecha( nRow, nCol )                        INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelCurvaDerecha, "Navigate_corner_right_64" )

   METHOD CreateItemPanelCurvaIzquierda( nRow, nCol )                      INLINE ::CreateItemMesa( nRow, nCol, nil, 64, 64, itmPanelCurvaIzquierda, "Navigate_corner_right_down_64" )

   METHOD CreateItemGenerico( nRow, nCol, uTooltip )                       INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 160, 100, itmGenerico, "gc_cash_register_160" )

   METHOD CreateItemLlevar( nRow, nCol, uTooltip )                         INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 160, 100, itmLlevar, "gc_motor_scooter_160" )

   METHOD CreateItemNewGenerico( nRow, nCol, uTooltip )                    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 160, 100, itmNewGenerico, "gc_cash_register_160" )

   METHOD CreateItemNewLlevar( nRow, nCol, uTooltip )                      INLINE ::CreateItemMesa( nRow, nCol, uTooltip, 160, 100, itmNewLlevar, "gc_motor_scooter_160" )

   //------------------------------------------------------------------------//

   METHOD pdaMenuSalones()

   METHOD Selector( oDlg )

   METHOD cCodForSalon( cSalon )

   METHOD lLimpiaSalon()

   METHOD PdaColorSalones()

   METHOD AddResource( cResource )

   METHOD ClickSalon()

   METHOD LoadFromMemory()

   METHOD ClickSalonTS()

   METHOD CreateItemPda( nRow, nCol, uTooltip )

ENDCLASS

//---------------------------------------------------------------------------//

#ifndef __PDA__

//---------------------------------------------------------------------------//

Method InitDesign() CLASS TSalon

   local oGrupo
   local oBoton
   local oCarpeta

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 1000, 120, ::oWnd, 1 )
   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oWnd:oTop                := ::oOfficeBar

   ::oWnd:oClient             := TPanelEx():New()

   ::oWnd:oClient:OnClick     := {| nRow, nCol | ::ClickSalon( nil, nRow, nCol, .t. ) } // := {| oWnd, nRow, nCol | ::ClickSalon( nil, nRow, nCol, .t. ) }

   oCarpeta                   := TCarpeta():New( ::oOfficeBar, "Objetos" )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 126, "Acciones", .f., , "gc_floppy_disk_32" )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32",         "Grabar y salir",    1, {|| ::SaveToDatabase() }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "End32",                "Salir sin grabar",  2, {|| ::End() }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Selección", .f. )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "gc_sign_stop_32",              "Quitar selección",  1, {|| ::UnSelectButtons() }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 246, "Mesas", .f., , "Shape_circle_32" )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_circle_32",      "Redonda",        1, {| oBtn | ::SelectItem( itmMesaRedonda, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_ellipse_32",     "Eliptica",       2, {| oBtn | ::SelectItem( itmMesaEliptica, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_square_32",      "Cuadrada",       3, {| oBtn | ::SelectItem( itmMesaCuadrada, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Shape_rectangle_32",   "Rectangular",    4, {| oBtn | ::SelectItem( itmMesaRectangular, oBtn ) }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 366, "Barra", .f., , "Bar_center_32" )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_center_32",           "Horizontal",        1, {| oBtn | ::SelectItem( itmBarrraHorizontal, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_left_32",             "Vertical",          2, {| oBtn | ::SelectItem( itmBarrraVertical, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_left_32",      "Derecha abajo",     3, {| oBtn | ::SelectItem( itmBarrraEsquinaDerechaAbajo, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_right_32",     "Izquierda abajo",   4, {| oBtn | ::SelectItem( itmBarrraEsquinaIzquierdaAbajo, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_top_left_32",  "Derecha arriba",    5, {| oBtn | ::SelectItem( itmBarrraEsquinaDerechaArriba, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Bar_corner_top_right_32", "Izquierda arriba",  6, {| oBtn | ::SelectItem( itmBarrraEsquinaIzquierdaArriba, oBtn ) }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 246, "Plantas", .f., , "Flower_white_32" )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_white_32",      "Blanca",         1, {| oBtn | ::SelectItem( itmPlantaBlanca, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_blue_32",       "Azul",           2, {| oBtn | ::SelectItem( itmPlantaAzul, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_red_32",        "Roja",           3, {| oBtn | ::SelectItem( itmPlantaRoja, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Flower_yellow_32",     "Amarilla",       4, {| oBtn | ::SelectItem( itmPlantaAmarilla, oBtn ) }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 666, "Paneles", .f., , "Navigate2_minus_32" )

   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate2_minus_32",            "Horizontal",              1, {| oBtn | ::SelectItem( itmPanelHorizontal, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_panel_32",             "Vertical",                2, {| oBtn | ::SelectItem( itmPanelVertical, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate2_plus_32",             "Cruce",                   3, {| oBtn | ::SelectItem( itmPanelCruce, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_connection_down_32",   "Conexión abajo",          4, {| oBtn | ::SelectItem( itmPanelConexionAbajo, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_connection_up_32",     "Conexión arriba",         5, {| oBtn | ::SelectItem( itmPanelConexionArriba, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_left_32",              "Conexión izquierda",      6, {| oBtn | ::SelectItem( itmPanelConexionIzquierda, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_right_32",             "Conexión derecha",        7, {| oBtn | ::SelectItem( itmPanelConexionDerecha, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_corner_left_32",       "Izquierda abajo",         8, {| oBtn | ::SelectItem( itmPanelCurvaAbajo, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_corner_right_32",      "Abajo derecha",           9, {| oBtn | ::SelectItem( itmPanelCurvaDerecha, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_corner_right_down_32", "Derecha abajo",          10, {| oBtn | ::SelectItem( itmPanelCurvaIzquierda, oBtn ) }, , , .f., .f., .f. )
   oBoton                     := TDotNetButton():New( 60, oGrupo, "Navigate_corner_right_top_32",  "Arriba derecha",         11, {| oBtn | ::SelectItem( itmPanelCurvaArriba, oBtn ) }, , , .f., .f., .f. )

   ::LoadFromDatabase()

   ::oWnd:Maximize()

Return ( Self )

//---------------------------------------------------------------------------//

Method InitSelector( lPuntosPendientes, lLlevar, dbfTikT ) CLASS TSalon

   local sSala
   local oGrupo
   local oBoton
   local oCarpeta
   local nWidth               := ( ( len( ::oSalaVenta:aSalas ) + 2 ) * 60 ) + 6

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 1008, 120, ::oWnd, 1 )
   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oWnd:oTop                := ::oOfficeBar

   oCarpeta                   := TCarpeta():New( ::oOfficeBar, "Salones" )
      oGrupo                  := TDotNetGroup():New( oCarpeta, nWidth, "Salones", .f. )

      for each sSala in ::oSalaVenta:aSalas
         oBoton               := TDotNetButton():New( 60, oGrupo, sSala:cImagen, sSala:cDescripcion, hb_enumindex(), {| oBoton | ::SelectSala( oBoton, lPuntosPendientes ) }, , , .f., .f., .f. )
         oBoton:cName         := sSala:cCodigo
         oBoton:lSelected     := ( hb_enumindex() == 1 )
      next

   if lLlevar
      ::oBtnGenerico          := TDotNetButton():New( 60, oGrupo, "gc_cash_register_32",  "General",        len( ::oSalaVenta:aSalas ) + 1, {|| ::LoadGenericosPendientes( dbfTikT, lPuntosPendientes ) }, , , .f., .f., .f. )
      ::oBtnLlevar            := TDotNetButton():New( 60, oGrupo, "gc_motor_scooter_32",    "Para llevar",    len( ::oSalaVenta:aSalas ) + 2, {|| ::LoadLlevarPendientes( dbfTikT, lPuntosPendientes ) }, , , .f., .f., .f. )
   end if

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Acciones", .f., , "gc_door_open2_32" )
      oBoton                  := TDotNetButton():New( 60, oGrupo, "End32", "Salir",  1, {|| ::oSelectedPunto := nil, ::Close( IDCANCEL ) }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 126, "Leyenda", .f., , "" )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "gc_check_12",    "Libre",             1, nil, , , .f., .f., .f. )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "gc_shape_square_12",   "Ocupada",           1, nil, , , .f., .f., .f. )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "gc_delete_12",      "Ticket entregado",  1, nil, , , .f., .f., .f. )

   ::oWnd:oClient             := TPanelEx():New()

   ::oWnd:Maximize()

   ::LoadFromMemory( nil, lPuntosPendientes )

Return ( Self )

//---------------------------------------------------------------------------//

Method Design( oDbfSala, oDlg ) CLASS TSalon

   ::lDesign                  := .t.
   ::oDbfSala                 := oDbfSala

   ::oWnd                     := TDialog():New( , , , , "Diseñando sala de ventas", "SelectMesa" )

   ::oWnd:Activate( , , , .t., , , {|| ::InitDesign() } )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD SelectGenerico() CLASS TSalon

   ::oSelectedPunto           :=  ::oSalaVenta:oGenerico

   ::End( IDOK )

RETURN nil

//---------------------------------------------------------------------------//

METHOD SelectLlevar() CLASS TSalon

   ::oSelectedPunto           :=  ::oSalaVenta:oLlevar

   ::End( IDOK )

RETURN nil

//---------------------------------------------------------------------------//

Method SelectSala( oBtnItem, lPuntosPendientes ) CLASS TSalon

   ::UnSelectButtons()

   /*
   Seleciona el boton actual---------------------------------------------------
   */

   oBtnItem:lSelected   := .t.

   /*
   Carga el salon--------------------------------------------------------------
   */

   ::LoadFromMemory( oBtnItem:cName, lPuntosPendientes )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateItemMesa( nRow, nCol, uTooltip, nWidth, nHeight, nType, cBitmap ) CLASS TSalon

   local oItemMesa

   DEFAULT nWidth             := 80
   DEFAULT nHeight            := 80
   DEFAULT nType              := itmMesaRectangular
   DEFAULT cBitmap            := "Shape_rectangle_80"

   oItemMesa                  := TMesa():New( nRow, nCol, nWidth, nHeight, ::oWnd:oClient, Self )

   oItemMesa:lDesign          := ::lDesign

   oItemMesa:nType            := nType
   oItemMesa:cBitmap          := cBitmap

   oItemMesa:LoadBitmap()

   do case
      case IsNil( uTooltip )
         oItemMesa:cTooltip   := nil
      case IsChar( uTooltip )
         oItemMesa:cTooltip   := Rtrim( uToolTip )
      case IsTrue( uTooltip )
         oItemMesa:cTooltip   := VirtualKey( .f., "", "Nombre de la mesa" )
   end case

   oItemMesa:Refresh()

   aAdd( ::aMesas, oItemMesa )

Return ( oItemMesa )

//---------------------------------------------------------------------------//

METHOD SaveToDatabase() CLASS TSalon

   local oControl

   if !Empty( ::oDbfSala ) .and. ::oDbfSala:Used()

      ::oDbfSala:Zap()

      for each oControl in ::oWnd:oClient:aControls
         ::oDbfSala:Blank()
         ::oDbfSala:nTipo     := oControl:nType
         ::oDbfSala:nFila     := oControl:nTop
         ::oDbfSala:nColumna  := oControl:nLeft
         ::oDbfSala:cDescrip  := oControl:cTooltip
         ::oDbfSala:Insert()
      next

      ::oDbfSala:GoTop()

   end if

   ::End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadFromDatabase( cCodigoSala ) CLASS TSalon

   if Empty( cCodigoSala )

      if !Empty( ::oDbfSala ) .and. ::oDbfSala:Used()

         ::oDbfSala:GoTop()
         while !::oDbfSala:Eof()
            ::ClickSalon( Max( ::oDbfSala:nTipo, 1 ), ::oDbfSala:nFila, ::oDbfSala:nColumna, Rtrim( ::oDbfSala:cDescrip ) )
            ::oDbfSala:Skip()
         end while

         ::oDbfSala:GoTop()

      end if

   end if

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

   ::nItemToInsert            := 0

Return ( Self )

//---------------------------------------------------------------------------//

METHOD CreateFromPunto( sPunto ) CLASS TSalon

   local oItemMesa

   oItemMesa               := ::ClickSalon( sPunto:nTipo, sPunto:nFila, sPunto:nColumna, sPunto:cPuntoVenta )
   if !Empty( oItemMesa )
      oItemMesa:sPunto     := sPunto
      if IsChar( oItemMesa:cTooltip )
         oItemMesa:nState := ::oSalaVenta:nStatePunto( sPunto )
      end if
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadGenericosPendientes( dbfTikT, lPuntosPendientes ) CLASS TSalon

   local nFila
   local nRecAnt
   local nOrdAnt
   local nColumna
   local oItemMesa
   local nHorizontal

   DEFAULT lPuntosPendientes  := .f.

   nRecAnt                    := ( dbfTikT )->( Recno() )
   nOrdAnt                    := ( dbfTikT )->( OrdSetFocus( "cCodSal" ) )
   nFila                      := 5
   nColumna                   := 1
   nHorizontal                := ::oWnd:nHorzRes() - 203

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End()
   end while

   /*
   Monto el añadir-------------------------------------------------------------
   */

   if !lPuntosPendientes

      oItemMesa                  := ::ClickSalon( itmNewGenerico, nFila, nColumna )

      if !Empty( oItemMesa )
         oItemMesa:sPunto        := sPunto():Generico()
         oItemMesa:sPunto:cTikT  := dbfTikT
         oItemMesa:cToolTip      := "Nuevo general"
      end if

      nColumna                   += 164

   end if

   /*
   Creo los puntos genericos y pinto el salon----------------------------------
   */

   if ( dbfTikT )->( dbSeek( Space( 3 ) + "General" ) )

      while ( dbfTikT )->cCodSala + RTrim( ( dbfTikT )->cPntVenta ) == Space( 3 ) + "General" .and. !( dbfTikT )->( Eof() )

         oItemMesa                  := ::ClickSalon( itmGenerico, nFila, nColumna )
         if !Empty( oItemMesa )
            oItemMesa:sPunto        := sPunto():Generico( dbfTikT )
            oItemMesa:sPunto:cTikT  := dbfTikT
            oItemMesa:cToolTip      := ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik + CRLF + AllTrim( ( dbfTikT )->cAliasTik )
            oItemMesa:nEstado       := if( ( dbfTikT )->lAbierto, 2, 3 )
         end if

         if nColumna < nHorizontal
            nColumna    += 164
         else
            nFila       += 102
            nColumna    := 1
         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   if !Empty( ::oBtnGenerico )
      ::UnSelectButtons()
      ::oBtnGenerico:lSelected  := .t.
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadUbicacionGeneral( dbfTikT ) CLASS TSalon

   local nFila
   local oBlock
   local oError
   local nRecAnt
   local nOrdAnt
   local nColumna
   local oItemMesa
   local nHorizontal

   nRecAnt                    := ( dbfTikT )->( Recno() )
   nOrdAnt                    := ( dbfTikT )->( OrdSetFocus( "nUbiTik" ) )
   nFila                      := 5
   nColumna                   := 1
   nHorizontal                := ::oWnd:nHorzRes() - 203

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End()
   end while

   /*
   Creo los puntos genericos y pinto el salon----------------------------------
   */

   while !( ( dbfTikT )->( eof() ) )

      if ( ( dbfTikT )->nUbiTik == ubiSala )

         oItemMesa                  := ::ClickSalon( itmGenerico, nFila, nColumna )
         if !Empty( oItemMesa )
            oItemMesa:sPunto        := sPunto():Generico( dbfTikT )
            oItemMesa:sPunto:cTikT  := dbfTikT
            oItemMesa:cToolTip      := ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik + CRLF + AllTrim( ( dbfTikT )->cAliasTik )
            oItemMesa:nEstado       := if( ( dbfTikT )->lAbierto, 2, 3 )
         end if

         if nColumna < nHorizontal
            nColumna    += 164
         else
            nFila       += 102
            nColumna    := 1
         end if

      end if

      ( dbfTikT )->( dbSkip() )

   end while

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   if !Empty( ::oBtnGenerico )
      ::UnSelectButtons()
      ::oBtnGenerico:lSelected  := .t.
   end if

Return ( Self )

//-------------------------------------------------------------------------//

METHOD LoadLlevarPendientes( dbfTikT, lPuntosPendientes ) CLASS TSalon

   local oItemMesa
   local nRecAnt              := ( dbfTikT )->( Recno() )
   local nOrdAnt              := ( dbfTikT )->( OrdSetFocus( "cCodSal" ) )
   local nFila                := 5
   local nColumna             := 1
   local nHorizontal          := ::oWnd:nHorzRes() - 203

   DEFAULT lPuntosPendientes  := .f.

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End()
   end while

   /*
   Monto el añadir-------------------------------------------------------------
   */

   if !lPuntosPendientes

      oItemMesa                  := ::ClickSalon( itmNewLlevar, nFila, nColumna )

      if !Empty( oItemMesa )
         oItemMesa:sPunto        := sPunto():Llevar()
         oItemMesa:sPunto:cTikT  := dbfTikT
         oItemMesa:cToolTip      := "Nuevo llevar"
      end if

      nColumna    += 164

   end if

   /*
   Creo los puntos llevar y pinto el salon----------------------------------
   */

   if ( dbfTikT )->( dbSeek( Space( 3 ) + "Llevar" ) )

      while ( dbfTikT )->cCodSala + RTrim( ( dbfTikT )->cPntVenta ) == Space( 3 ) + "Llevar" .and. !( dbfTikT )->( Eof() )

         oItemMesa                  := ::ClickSalon( itmLlevar, nFila, nColumna )
         if !Empty( oItemMesa )
            oItemMesa:sPunto        := sPunto():Llevar( dbfTikT )
            oItemMesa:sPunto:cTikT  := dbfTikT
            oItemMesa:cToolTip      := ( dbfTikT )->cSerTik + "/" + AllTrim( ( dbfTikT )->cNumTik ) + "/" + ( dbfTikT )->cSufTik + CRLF + AllTrim( ( dbfTikT )->cNomTik )
            oItemMesa:nEstado       := if( ( dbfTikT )->lAbierto, 2, 3 )
         end if

         if nColumna < nHorizontal
            nColumna    += 164
         else
            nFila       += 102
            nColumna    := 1
         end if

         ( dbfTikT )->( dbSkip() )

      end while

   end if

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   ( dbfTikT )->( OrdSetFocus( nOrdAnt ) )
   ( dbfTikT )->( dbGoTo( nRecAnt ) )

   if !Empty( ::oBtnLlevar )
      ::UnSelectButtons()
      ::oBtnLlevar:lSelected  := .t.
   end if

RETURN ( nil )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifndef __PDA__

METHOD New() CLASS TSalon

   ::nItemToInsert               := NINICIO
   ::aBitmapsState               := {}
   ::aMesas                      := {}

   if Empty( ::aBitmapsState )
      ::AddResource( "gc_check_12" )
      ::AddResource( "gc_shape_square_12" )
      ::AddResource( "gc_delete_12" )
   end if

Return ( Self )

//------------------------------------------------------------------------//

Method End( nId )

   ::Close( nId )

   if !Empty( ::aBitmapsState )
      aEval( ::aBitmapsState, {|a| PalBmpFree( a[1], a[2] ) } )
   end if

   ::aBitmapsState   := nil
   ::aMesas          := {}

   ::oWnd            := nil

Return ( Self )

//------------------------------------------------------------------------//

Method Close( nId )

   if !Empty( ::aMesas )
      aEval( ::aMesas, {|o| o:End() } )
   end if

   if !Empty( ::oWnd )
      ::oWnd:End( nId )
   end if

Return ( Self )

//------------------------------------------------------------------------//

#else

METHOD New() CLASS TSalon

   ::nItemToInsert               := NINICIO
   ::nRowToInsert                := NROWINSERT
   ::nColToInsert                := NCOLINSERT

Return ( Self )

#endif

//---------------------------------------------------------------------------//

#ifndef __PDA__

METHOD AddResource( cResource ) CLASS TSalon

   local aBmpPal

   aBmpPal        := PalBmpLoad( cResource )

   if aBmpPal[ BITMAP_HANDLE ] != 0
      aAdd( aBmpPal, nBmpWidth( aBmpPal[ BITMAP_HANDLE ] ) )
      aAdd( aBmpPal, nBmpHeight( aBmpPal[ BITMAP_HANDLE ] ) )
      aAdd( aBmpPal, nil )
      aAdd( ::aBitmapsState, aBmpPal )
      return .t.
   endif

return .f.

#else

METHOD AddResource( cBmpFile ) CLASS TSalon

   local hBmpPal  := ReadBitmap( AllTrim( cBmpFile ) )

   if hBmpPal != 0
      Aadd( ::aBitmapsState, hBmpPal )
   endif

return .t.

#endif

//---------------------------------------------------------------------------//
#ifndef __PDA__

Method Selector( oSalaVenta, lPuntosPendientes, lLlevar, dbfTikT ) CLASS TSalon

   local n
   local sSala
   local aBtnSala                := Array( 5 )

   if !lPda()

      if len( oSalaVenta:aSalas ) == 0
         MsgStop( "No existen salones definidos." )
         Return .f.
      end if

      ::lDesign                  := .f.
      ::oSalaVenta               := oSalaVenta

      ::oWnd                     := TDialog():New( , , , , if( IsTrue( lPuntosPendientes ), "Selecionar punto pendiente", "Seleccionar punto de venta" ), "SelectMesa" )

      ::oWnd:Activate( , , , .t., , , {|| ::InitSelector( lPuntosPendientes, lLlevar, dbfTikT ) } )

   else

      if len( oSalaVenta:aSalas ) == 0
         MsgStop( "No existen salones definidos." )
         Return .f.
      end if

      ::lDesign                  := .f.
      ::oSalaVenta               := oSalaVenta
      ::nItemToInsert            := NINICIO
      ::nRowToInsert             := NROWINSERT
      ::nColToInsert             := NCOLINSERT

      ::oWnd                     := TDialog():New( , , , , if( IsTrue( lPuntosPendientes ), "Selecionar punto pendiente", "Seleccionar punto de venta" ), "TIKET_PDA" )

      for n := 1 to 5

         if n <= len( ::oSalaVenta:aSalas )
            aBtnSala[ n ]           := TBtnBmp():ReDefine( 100 + n,,,,,,, ::oWnd, .f.,, .f.,, ::oSalaVenta:aSalas[ n ]:cDescripcion ,,,, .f., )
            aBtnSala[ n ]:bAction   := bLimpiaSala( Self, ::oSalaVenta:aSalas[ n ]:cDescripcion, lPuntosPendientes, aBtnSala )
         else
            aBtnSala[ n ]           := TBtnBmp():ReDefine( 100 + n,,,,,,, ::oWnd, .f.,, .f.,, "" ,,,, .f., )
         end if

      next

      ::oWnd:Activate( , , , , , , {|| ::LoadFromMemory( ::cCodForSalon( cPdaZona() ) ), lPuntosPendientes, ::PdaColorSalones( aBtnSala, cPdaZona() ) } )

      end if

Return ( ::oWnd:nResult == IDOK )

#else

Method Selector( oSalaVenta, lPuntosPendientes, dbfTikT ) CLASS TSalon

   local n
   local sSala
   local aBtnSala             := Array( 5 )

   if len( oSalaVenta:aSalas ) == 0
      MsgStop( "No existen salones definidos." )
      Return .f.
   end if

   ::lDesign                  := .f.
   ::oSalaVenta               := oSalaVenta
   ::nItemToInsert            := NINICIO
   ::nRowToInsert             := NROWINSERT
   ::nColToInsert             := NCOLINSERT

   ::oWnd                     := TDialog():New( , , , , if( IsTrue( lPuntosPendientes ), "Selecionar punto pendiente", "Seleccionar punto de venta" ), "TIKET_PDA" )

   for n := 1 to 5

      if n <= len( ::oSalaVenta:aSalas )
         aBtnSala[ n ]           := TBtnBmp():ReDefine( 100 + n,,,,,,, ::oWnd, .f.,, .f.,, ::oSalaVenta:aSalas[ n ]:cDescripcion ,,,, .f., )
         aBtnSala[ n ]:bAction   := bLimpiaSala( Self, ::oSalaVenta:aSalas[ n ]:cDescripcion, lPuntosPendientes, aBtnSala )
      else
         aBtnSala[ n ]           := TBtnBmp():ReDefine( 100 + n,,,,,,, ::oWnd, .f.,, .f.,, "" ,,,, .f., )
      end if

   next

   ::oWnd:Activate( , , , , , , {|| ::PdaMenuSalones(), ::LoadFromMemory( ::cCodForSalon( cPdaZona() ) , lPuntosPendientes, ::PdaColorSalones( aBtnSala, cPdaZona() ) ) } )

Return ( ::oWnd:nResult == IDOK )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

Static Function bLimpiaSala( Self, cNombre, lPuntosPendientes, aBtnSala )

return ( {|| ::PdaColorSalones( aBtnSala, cNombre ), ::lLimpiaSalon( lPuntosPendientes ), ::LoadFromMemory( ::cCodForSalon( cNombre ), lPuntosPendientes ) } )

//---------------------------------------------------------------------------//

Method pdaMenuSalones() CLASS TSalon

   local oMenu

   /*DEFINE MENU oMenu ;
      RESOURCE 400 ;
      BITMAPS  50 ; // bitmaps resoruces ID
      IMAGES   1     // number of images in the bitmap

      REDEFINE MENUITEM ID 410 OF oMenu ACTION ( ::oWnd:End() )

   ::oWnd:SetMenu( oMenu )*/

Return oMenu

//---------------------------------------------------------------------------//

METHOD PdaColorSalones( aBtnSala, cNombre ) CLASS TSalon

   local n

   for n := 1 to 5

      if aBtnSala[ n ]:cCaption == cNombre
         aBtnSala[ n ]:SetColor( nRgb( 0, 0, 0 ), nRgb( 100, 100, 232 ) )
      else
         aBtnSala[ n ]:SetColor( nRgb( 0, 0, 0 ), nRgb( 63, 240, 254 ) )
      end if

      aBtnSala[ n ]:Refresh()

   next

return nil

//---------------------------------------------------------------------------//

METHOD cCodForSalon( cSalon ) CLASS TSalon

   local cCodSalon   := ""
   local nPos
   local i

   if ( nPos := aScan( ::oSalaVenta:aSalas, {|a| a:cDescripcion == cSalon } ) ) != 0
      cCodSalon   := ::oSalaVenta:aSalas[ nPos ]:cCodigo
   end if

return cCodSalon

//---------------------------------------------------------------------------//

METHOD lLimpiaSalon( lPuntosPendientes ) CLASS TSalon

   local oMesas
   local n

   ::nItemToInsert               := NINICIO
   ::nRowToInsert                := NROWINSERT
   ::nColToInsert                := NCOLINSERT

   for each oMesas in ::oWnd:aControls

      if oMesas:ClassName() == "TBTNBMP" .and. !Empty( oMesas:Cargo )
         oMesas:Hide()
         oMesas:Destroy()
      end if

   next

   ::oWnd:aControls              := {}

   ::oWnd:Refresh()

   UpdateWindow()

Return .t.

//---------------------------------------------------------------------------//

METHOD ClickSalon( nItem, nRow, nCol, uToolTip ) CLASS TSalon

   DEFAULT nItem        := ::nItemToInsert
   DEFAULT nRow         := 0
   DEFAULT nCol         := 0
   DEFAULT uToolTip     := .f.

   do case
      case nItem == itmMesaRedonda
         Return( ::CreateItemMesaRedonda( nRow, nCol, uToolTip ) )

      case nItem == itmMesaEliptica
         Return( ::CreateItemMesaEliptica( nRow, nCol, uToolTip ) )

      case nItem == itmMesaCuadrada
         Return( ::CreateItemMesaCuadrada( nRow, nCol, uToolTip ) )

      case nItem == itmMesaRectangular
         Return( ::CreateItemMesaRectangular( nRow, nCol, uToolTip ) )

      case nItem == itmBarrraHorizontal
         Return( ::CreateItemBarraHorizontal( nRow, nCol, uToolTip ) )

      case nItem == itmBarrraVertical
         Return( ::CreateItemBarraVertical( nRow, nCol, uToolTip ) )

      case nItem == itmBarrraEsquinaDerechaAbajo
         Return( ::CreateItemBarrraEsquinaDerechaAbajo( nRow, nCol, uToolTip ) )

      case nItem == itmBarrraEsquinaIzquierdaAbajo
         Return( ::CreateItemBarrraEsquinaIzquierdaAbajo( nRow, nCol, uToolTip ) )

      case nItem == itmBarrraEsquinaDerechaArriba
         Return( ::CreateItemBarrraEsquinaDerechaArriba( nRow, nCol, uToolTip ) )

      case nItem == itmBarrraEsquinaIzquierdaArriba
         Return( ::CreateItemBarrraEsquinaIzquierdaArriba( nRow, nCol, uToolTip ) )

      case nItem == itmPlantaBlanca
         Return( ::CreateItemPlantaBlanca( nRow, nCol ) )

      case nItem == itmPlantaAzul
         Return( ::CreateItemPlantaAzul( nRow, nCol ) )

      case nItem == itmPlantaAmarilla
         Return( ::CreateItemPlantaAmarilla( nRow, nCol ) )

      case nItem == itmPlantaRoja
         Return( ::CreateItemPlantaRoja( nRow, nCol ) )

      case nItem == itmPanelHorizontal
         Return( ::CreateItemPanelHorizontal( nRow, nCol ) )

      case nItem == itmPanelVertical
         Return( ::CreateItemPanelVertical( nRow, nCol ) )

      case nItem == itmPanelCruce
         Return( ::CreateItemPanelCruce( nRow, nCol ) )

      case nItem == itmPanelConexionArriba
         Return( ::CreateItemPanelConexionArriba( nRow, nCol ) )

      case nItem == itmPanelConexionAbajo
         Return( ::CreateItemPanelConexionAbajo( nRow, nCol ) )

      case nItem == itmPanelCurvaAbajo
         Return( ::CreateItemPanelCurvaAbajo( nRow, nCol ) )

      case nItem == itmPanelCurvaArriba
         Return( ::CreateItemPanelCurvaArriba( nRow, nCol ) )

      case nItem == itmPanelCurvaDerecha
         Return( ::CreateItemPanelCurvaDerecha( nRow, nCol ) )

      case nItem == itmPanelCurvaIzquierda
         Return( ::CreateItemPanelCurvaIzquierda( nRow, nCol ) )

      case nItem == itmPanelConexionDerecha
         Return( ::CreateItemPanelConexionDerecha( nRow, nCol ) )

      case nItem == itmPanelConexionIzquierda
         Return( ::CreateItemPanelConexionIzquierda( nRow, nCol ) )

      case nItem == itmGenerico
         Return( ::CreateItemGenerico( nRow, nCol, uToolTip ) )

      case nItem == itmLlevar
         Return( ::CreateItemLlevar( nRow, nCol, uToolTip ) )

      case nItem == itmNewGenerico
         Return( ::CreateItemNewGenerico( nRow, nCol, uToolTip ) )

      case nItem == itmNewLlevar
         Return( ::CreateItemNewLlevar( nRow, nCol, uToolTip ) )

   end case

Return ( nil )

//---------------------------------------------------------------------------//

METHOD ClickSalonTS( nItem, nRow, nCol, sPunto ) CLASS TSalon

   DEFAULT nItem        := ::nItemToInsert
   DEFAULT nRow         := 0
   DEFAULT nCol         := 0

Return ( ::CreateItemPda( nRow, nCol, sPunto ) )

//---------------------------------------------------------------------------//

METHOD CreateItemPda( nRow, nCol, sPunto ) CLASS TSalon

   local oBtn
   local oItemMesa

   oItemMesa            := TMesaTs():New( ::nRowToInsert, ::nColToInsert, 46, 46, ::oWnd, sPunto, Self )

   if ::nColToInsert >= 190
      ::nColToInsert    := 2
      ::nRowToInsert    += 47
   else
      ::nColToInsert    += 47
   endif

Return ( oItemMesa )

//---------------------------------------------------------------------------//

#ifndef __PDA__

METHOD LoadFromMemory( cCodigoSala, lPuntosPendientes ) CLASS TSalon

   local oMesa
   local sSala
   local sPunto
   local oError
   local oBlock
   local nCount         := 1

   if !lPda()

      if Empty( cCodigoSala ) .and. len( ::oSalaVenta:aSalas ) >= 1
         cCodigoSala    := ::oSalaVenta:aSalas[ 1 ]:cCodigo
      end if

      if isChar( cCodigoSala )

         while len( ::oWnd:oClient:aControls ) > 0
            ::oWnd:oClient:aControls[ 1 ]:End()
         end while

         for each sSala in ::oSalaVenta:aSalas

            if sSala:cCodigo == cCodigoSala

               for each sPunto in sSala:aPunto
                  sPunto:CreateMesa( Self, lPuntosPendientes )
               next

            end if

         next

      end if

   else

      if Empty( cCodigoSala ) .and. len( ::oSalaVenta:aSalas ) >= 1
         cCodigoSala    := ::oSalaVenta:aSalas[ 1 ]:cCodigo
      end if

      if isChar( cCodigoSala )

         for each sSala in ::oSalaVenta:aSalas

            if sSala:cCodigo == cCodigoSala

               for each sPunto in sSala:aPunto

                  if nCount < 25
                     sPunto:CreateMesa( Self, lPuntosPendientes )
                  end if

                  nCount++

               next

            end if

            nCount      := 1

         next

      end if

      ::oBtnSalirSalon  := TBtnBmp():New( 216, 190, 46, 46, "END32" ,,,, {|| if( ApoloMsgNoYes( "Desea salir de la aplicación", "" ), ::oWnd:End(), ) }, ::oWnd,,, .F., .T.,,,,, !.T., "BOTTOM",,,,,, 106 )

   end if

Return ( if( !lPda(), Self, nil ) )

#else

METHOD LoadFromMemory( cCodigoSala, lPuntosPendientes ) CLASS TSalon

   local sSala
   local sPunto
   local oError
   local oBlock

   if !pdaAbrirTablas()
      return .f.
   end if

   if Empty( cCodigoSala ) .and. len( ::oSalaVenta:aSalas ) >= 1
      cCodigoSala    := ::oSalaVenta:aSalas[ 1 ]:cCodigo
   end if

   if isChar( cCodigoSala )

      for each sSala in ::oSalaVenta:aSalas

         if sSala:cCodigo == cCodigoSala

            for each sPunto in sSala:aPunto
               sPunto:CreateMesa( Self, lPuntosPendientes )
            next

         end if

      next

   end if

   pdaCerrarTablas()

Return ( Self )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS sSala

   DATA cCodigo
   DATA cDescripcion
   DATA nPrecio
   DATA nPreCmb
   DATA cImagen
   DATA aPunto     AS ARRAY INIT {}

   Method New( oDbf, cImagen )
   Method AddPunto( nNumero, oDbfSalaVta )
   Method AddMesa( oDbfSalaVta )

END CLASS

//---------------------------------------------------------------------------//

Method New( oDbf, cImagen ) CLASS sSala

   ::cCodigo      := oDbf:cCodigo
   ::nPrecio      := oDbf:nPrecio
   ::nPreCmb      := oDbf:nPreCmb
   ::cDescripcion := Rtrim( oDbf:cDescrip )
   ::cImagen      := cImagen
   ::aPunto       := {}

Return ( Self )

//---------------------------------------------------------------------------//

Method AddPunto( nNumero, oDbfSalaVta, dbfTikT ) CLASS sSala

   aAdd( ::aPunto, sPunto():Create( nNumero, oDbfSalaVta:cDescrip, oDbfSalaVta:nTipo, oDbfSalaVta:nFila, oDbfSalaVta:nColumna, Self, dbfTikT ) )

Return ( Self )

//---------------------------------------------------------------------------//

Method AddMesa( oDbfSalaVta ) CLASS sSala

   local oItemMesa

   oItemMesa      := TMesa():Build( oDbfSalaVta:nTipo, oDbfSalaVta:nFila, oDbfSalaVta:nColumna, oDbfSalaVta:cDescrip )
   if !Empty( oItemMesa )
      aAdd( ::aMesa, oItemMesa )
   end if

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS sPunto

   DATA nNumero            INIT 0

   DATA oSala

   DATA cCodigoSala
   DATA cPuntoVenta
   DATA cAlias             INIT ""

   DATA nEstado

   DATA cSerie             INIT ""
   DATA cNumero            INIT ""
   DATA cSufijo            INIT ""

   DATA cImagen
   DATA nPrecio
   DATA nPreCmb

   DATA lComensal          INIT .f.

   DATA nTotal             INIT 0

   DATA nTipo
   DATA nFila
   DATA nColumna

   DATA cTikT

   DATA aMesas

   Method New( nNumero, dbfTikT, oSala )
   Method Create( nNumero, cDescripcion, nTipo, nFila, nColumna, oSala )
   Method Generico()
   Method Llevar()

   Method CreateMesa( oSalon )

   Method cPunto()         INLINE ( ::cCodigoSala + ::cPuntoVenta )
   Method cSala()          INLINE ( ::cCodigoSala )

   Method cTiket()         INLINE ( ::cSerie + ::cNumero + ::cSufijo )
   Method cTextoTiket()    INLINE ( ::cSerie + "/" + Alltrim( ::cNumero ) + "/" + Alltrim( ::cSufijo ) )
   Method cTextoPunto()
   Method cImagenPunto( nItem )

   Method cTexto()         INLINE ( if( !Empty( ::cPuntoVenta ), ::cTextoPunto(), ::cTextoTiket() ) )

   Method lGenerico()      INLINE ( Empty( ::oSala ) .and. ::cPuntoVenta == "General" )

   Method lLlevar()        INLINE ( Empty( ::oSala ) .and. ::cPuntoVenta == "Llevar" )

END CLASS

//---------------------------------------------------------------------------//

Method New( nNumero, dbfTikT, oSala ) CLASS sPunto

   ::nNumero         := nNumero
   ::cSerie          := ( dbfTikT )->cSerTik
   ::cNumero         := ( dbfTikT )->cNumTik
   ::cSufijo         := ( dbfTikT )->cSufTik
   ::cCodigoSala     := ( dbfTikT )->cCodSala
   ::cPuntoVenta     := ( dbfTikT )->cPntVenta
   ::cAlias          := ( dbfTikT )->cAliasTik
   ::nPrecio         := ( dbfTikT )->nTarifa
   ::nTotal          := ( dbfTikT )->nTotTik
   ::lComensal       := .f.
   ::nPreCmb         := uFieldEmpresa( "nPreTCmb" )
   ::cTikT           := dbfTikT

   if Empty( oSala )
      ::cImagen      := "gc_cup_32"
   else
      ::oSala        := oSala
      ::cImagen      := oSala:cImagen
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method Create( nNumero, cDescripcion, nTipo, nFila, nColumna, oSala, dbfTikT ) CLASS sPunto

   ::nNumero         := nNumero
   ::cPuntoVenta     := cDescripcion
   ::nTipo           := nTipo
   ::nFila           := nFila
   ::nColumna        := nColumna

   ::oSala           := oSala
   ::cCodigoSala     := oSala:cCodigo
   ::nPrecio         := oSala:nPrecio
   ::nPreCmb         := oSala:nPreCmb
   ::lComensal       := oSala:lComensal

   ::cImagen         := ::cImagenPunto( nTipo )

   ::cTikT           := dbfTikT

Return ( Self )

//---------------------------------------------------------------------------//

Method Generico( dbfTikT ) CLASS sPunto

   ::nNumero         := 0

   if !Empty( dbfTikT )
      ::cSerie       := ( dbfTikT )->cSerTik
      ::cNumero      := ( dbfTikT )->cNumTik
      ::cSufijo      := ( dbfTikT )->cSufTik
      ::cAlias       := ( dbfTikT )->cAliasTik
   else
      ::cSerie       := ""
      ::cNumero      := ""
      ::cSufijo      := ""
      ::cAlias       := ""
   end if

   ::cCodigoSala     := ""
   ::cPuntoVenta     := "General"
   if !Empty( uFieldEmpresa( "nPreTPro" ) )
      ::nPrecio      := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   else
      ::nPrecio      := 1
   end if
   if !Empty( uFieldEmpresa( "nPreTCmb" ) )
      ::nPreCmb         := Max( uFieldEmpresa( "nPreTCmb" ), 1 )
   else
      ::nPreCmb      := 1
   end if
   ::cImagen         := "gc_cup_32"
   ::oSala           := nil
   ::lComensal       := .f.

Return ( Self )

//---------------------------------------------------------------------------//

Method Llevar( dbfTikT ) CLASS sPunto

   ::nNumero         := 0

   if !Empty( dbfTikT )
      ::cSerie       := ( dbfTikT )->cSerTik
      ::cNumero      := ( dbfTikT )->cNumTik
      ::cSufijo      := ( dbfTikT )->cSufTik
      ::cAlias       := ( dbfTikT )->cAliasTik
   else
      ::cSerie       := ""
      ::cNumero      := ""
      ::cSufijo      := ""
      ::cAlias       := ""
   end if

   ::cCodigoSala     := ""
   ::cPuntoVenta     := "Llevar"
   if !Empty( uFieldEmpresa( "nPreTPro" ) )
      ::nPrecio      := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   else
      ::nPrecio      := 1
   end if
   if !Empty( uFieldEmpresa( "nPreTCmb" ) )
      ::nPreCmb         := Max( uFieldEmpresa( "nPreTCmb" ), 1 )
   else
      ::nPreCmb      := 1
   end if
   ::cImagen         := "gc_motor_scooter_32"
   ::oSala           := nil
   ::lComensal       := .f.

Return ( Self )

//---------------------------------------------------------------------------//

Method CreateMesa( oSalon, lPuntosPendientes ) CLASS sPunto

   local oMesa
   local nRecno
   local oError
   local oBlock

   // DEFAULT lPuntosPendientes  := .f.

   /*
   Carga informacion del punto-------------------------------------------------
   */

   if !Empty( ::cPunto() ) .and. !Empty( ::cPuntoVenta )

      nRecno            := ( ::cTikT )->( Recno() )

      do case
      case ( dbSeekInOrd( ::cPunto(), "cCodSal", ::cTikT ) .and. !( ::cTikT )->lAbierto )

         ::nEstado      := 3
         ::cSerie       := ( ::cTikT )->cSerTik
         ::cNumero      := ( ::cTikT )->cNumTik
         ::cSufijo      := ( ::cTikT )->cSufTik
         ::cCodigoSala  := ( ::cTikT )->cCodSala
         ::cPuntoVenta  := ( ::cTikT )->cPntVenta
         ::cAlias       := ( ::cTikT )->cAliasTik
         ::nPrecio      := ( ::cTikT )->nTarifa
         ::nTotal       := ( ::cTikT )->nTotTik
         ::nPreCmb      := uFieldEmpresa( "nPreTCmb" )

      case ( dbSeekInOrd( ::cPunto(), "cCodSal", ::cTikT ) .and. ( ::cTikT )->lAbierto )

         ::nEstado      := 2
         ::cSerie       := ( ::cTikT )->cSerTik
         ::cNumero      := ( ::cTikT )->cNumTik
         ::cSufijo      := ( ::cTikT )->cSufTik
         ::cCodigoSala  := ( ::cTikT )->cCodSala
         ::cPuntoVenta  := ( ::cTikT )->cPntVenta
         ::cAlias       := ( ::cTikT )->cAliasTik
         ::nPrecio      := ( ::cTikT )->nTarifa
         ::nTotal       := ( ::cTikT )->nTotTik
         ::nPreCmb      := uFieldEmpresa( "nPreTCmb" )

      otherwise

         ::nEstado      := 1
         ::cSerie       := ""
         ::cNumero      := ""
         ::nTotal       := 0
         ::cSufijo      := ""
         ::lComensal    := .f.

      end case

      ( ::cTikT )->( dbGoTo( nRecno ) )

   end if

   /*
   Crea la mesa----------------------------------------------------------------
   */

   oMesa                := oSalon:ClickSalon( ::nTipo, ::nFila, ::nColumna, ::cPuntoVenta )

   if !Empty( oMesa ) .and. IsChar( oMesa:cTooltip )

      oMesa:nEstado     := ::nEstado

      oMesa:sPunto      := Self

      if ( IsTrue( lPuntosPendientes ) .and. ::nEstado <= 1 )
         oMesa:Disable()
      end if

      if ( IsFalse( lPuntosPendientes ) .and. ::nEstado > 1 )
         oMesa:Disable()
      end if

   end if

Return ( self )

//---------------------------------------------------------------------------//

Method cTextoPunto() CLASS sPunto

   local cTextoPunto    := ""

   if !Empty( ::cPuntoVenta )
      cTextoPunto       += Alltrim( ::cPuntoVenta )
   else
      if !Empty( ::oSala )
         cTextoPunto    += Alltrim( ::oSala:cDescripcion )
      end if
   end if

Return ( cTextoPunto )

//---------------------------------------------------------------------------//

Method cImagenPunto( nItem ) CLASS sPunto

   do case
      case nItem == itmMesaRedonda
         Return ( "Shape_circle_32" )

      case nItem == itmMesaEliptica
         Return ( "Shape_ellipse_32" )

      case nItem == itmMesaCuadrada
         Return ( "Shape_square_32" )

      case nItem == itmMesaRectangular
         Return ( "Shape_rectangle_32" )

      case nItem == itmBarrraHorizontal
         Return ( "Bar_center_32" )

      case nItem == itmBarrraVertical
         Return ( "Bar_left_32" )

      case nItem == itmBarrraEsquinaDerechaAbajo
         Return ( "Bar_corner_left_32" )

      case nItem == itmBarrraEsquinaIzquierdaAbajo
         Return ( "Bar_corner_right_32" )

      case nItem == itmBarrraEsquinaDerechaArriba
         Return ( "Bar_corner_top_left_32" )

      case nItem == itmBarrraEsquinaIzquierdaArriba
         Return ( "Bar_corner_top_right_32" )

   end case

Return ( "" )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifndef __PDA__

CLASS TMesa FROM TControl

   CLASSDATA lRegistered AS LOGICAL
   CLASSDATA oFont
   CLASSDATA oSalon

   DATA nType
   DATA cBitmap
   DATA hBmp

   DATA cCodigoSala
   DATA cPuntoVenta

   DATA nEstado
   DATA sPunto

   DATA lGenerica          INIT .f.

   DATA cSerie             INIT ""
   DATA cNumero            INIT ""
   DATA cSufijo            INIT ""

   DATA cCodigoUsuario     INIT ""
   DATA nComensales        INIT 1

   DATA nTotal             INIT 0
   DATA nProductos         INIT 0
   DATA nTiempoOcupacion   INIT 0

   DATA cImagen
   DATA nPrecio
   DATA nPreCmb

   DATA nTipo
   DATA nFila
   DATA nColumna

   DATA lDesign

   METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oSalon ) CONSTRUCTOR

   METHOD End()            INLINE ( if( !Empty( ::hBmp ), DeleteObject( ::hBmp ), ), ::Super:End() )

   METHOD Build( cDescripcion, nTipo, nFila, nColumna, oSalon ) CONSTRUCTOR
   METHOD Generica() CONSTRUCTOR

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD LButtonDown( nRow, nCol, nKeyFlags )

   Method LoadBitmap( cBitmap )

   Method cImagenPunto( nItem )

   METHOD Rename()

   METHOD Paint()
   METHOD Display()        INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint(), 0 )

   METHOD RButtonDown( nRow, nCol, nKeyFlags )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, oSalon ) CLASS TMesa

   ::nStyle    := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, 0 ) //, WS_CLIPCHILDREN
   ::nId       := ::GetNewId()
   ::oWnd      := oWnd
   ::nTop      := nTop
   ::nLeft     := nLeft
   ::nBottom   := nTop + nHeight - 1
   ::nRight    := nLeft + nWidth - 1
   ::oSalon    := oSalon

   ::oFont     := TFont():New( "Ms Sans Serif", 0, -12 )

   ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

   if !Empty( oWnd:hWnd )
      ::Create()
      oWnd:AddControl( Self )

   else
      oWnd:DefControl( Self )

   endif

Return self

//----------------------------------------------------------------------------//

Method Build( cDescripcion, nTipo, nFila, nColumna, oSalon ) CLASS TMesa

   ::cPuntoVenta     := cDescripcion
   ::nTipo           := nTipo
   ::nFila           := nFila
   ::nColumna        := nColumna
   ::cCodigoSala     := oSalon:cCodigo
   ::nPrecio         := oSalon:nPrecio
   ::nPreCmb         := oSalon:nPreCmb
   ::oSalon          := oSalon
   ::cImagen         := ::cImagenPunto( nTipo )
   ::lGenerica       := .f.

Return ( Self )

//----------------------------------------------------------------------------//

Method Generica() CLASS TMesa

   ::cPuntoVenta     := "General"
   ::nTipo           := 0
   ::nFila           := 0
   ::nColumna        := 0
   ::cCodigoSala     := ""
   ::nPrecio         := Max( uFieldEmpresa( "nPreTPro" ), 1 )
   ::nPreCmb         := Max( uFieldEmpresa( "nPreTCmb" ), 1 )
   ::oSalon          := nil
   ::cImagen         := "gc_cup_32"
   ::lGenerica       := .t.

Return ( Self )

//----------------------------------------------------------------------------//

Method cImagenPunto( nItem ) CLASS TMesa

   do case
      case nItem == itmMesaRedonda
         Return ( "Shape_circle_32" )

      case nItem == itmMesaEliptica
         Return ( "Shape_ellipse_32" )

      case nItem == itmMesaCuadrada
         Return ( "Shape_square_32" )

      case nItem == itmMesaRectangular
         Return ( "Shape_rectangle_32" )

      case nItem == itmBarrraHorizontal
         Return ( "Bar_center_32" )

      case nItem == itmBarrraVertical
         Return ( "Bar_left_32" )

      case nItem == itmBarrraEsquinaDerechaAbajo
         Return ( "Bar_corner_left_32" )

      case nItem == itmBarrraEsquinaIzquierdaAbajo
         Return ( "Bar_corner_right_32" )

      case nItem == itmBarrraEsquinaDerechaArriba
         Return ( "Bar_corner_top_left_32" )

      case nItem == itmBarrraEsquinaIzquierdaArriba
         Return ( "Bar_corner_top_right_32" )

   end case

Return ( "" )

//----------------------------------------------------------------------------//

METHOD LButtonDown( nRow, nCol, nKeyFlags ) CLASS TMesa

   if !Empty( ::cTooltip )

      do case
         case Empty( ::sPunto:cTiket() )

            ::oSalon:oSelectedPunto    := ::sPunto
            ::oSalon:Close( IDOK )

         case !Empty( ::sPunto:cTiket() ) 

            if dbSeekInOrd( ::sPunto:cTiket(), "cNumTik", ::sPunto:cTikT ) .and. dbDialogLock( ::sPunto:cTikT )
               ::oSalon:oSelectedPunto := ::sPunto
               ::oSalon:Close( IDOK )
            end if

      end case

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TMesa

   local oMenu
   local bMenuSelect
   local aPoint         := { nRow, nCol }

   if ::lDesign

      aPoint            := ScreenToClient( ::hWnd, aPoint )

      /*
      Montamos el menu------------------------------------------------------------
      */

      oMenu             := MenuBegin( .t. )
      bMenuSelect       := ::bMenuSelect

      ::bMenuSelect     := nil

      if IsChar( ::cTooltip )
         MenuAddItem( "Cambiar nombre", "Cambiar nombre a la mesa", .f., .t., {|| ::Rename() }, , "gc_text_field_16", oMenu )
      end if

      MenuAddItem( "&Eliminar", "Eliminar mesa del salón", .f., .t., {|| ::End() }, , "Del16", oMenu )

      MenuEnd()

      oMenu:Activate( aPoint[ 1 ], aPoint[ 2 ], Self )

      ::bMenuSelect     := bMenuSelect

      oMenu:end()

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadBitmap() CLASS TMesa

   local h

   if !Empty( ::hBmp )
      DeleteObject( ::hBmp )
   end if

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

      /*
      case nMsg == 0x00A1 // WM_NCLBUTTONDOWN
         return ::LButtonDown( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )
      */

      case nMsg == WM_NCHITTEST .and. ::lDesign
         ::Refresh()
         return HTCAPTION

      case nMsg == WM_ERASEBKGND
         return 1

   end case

Return ( ::Super:HandleEvent( nMsg, nWParam, nLParam ) )

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
   local aBitmap

   // Bitmap de la mesa--------------------------------------------------------

   if IsWindowEnabled( ::hWnd )

      DrawBitmap( ::hDC, ::hBmp, 0, 0 )

      // Bitmap del estado-----------------------------------------------------

      if IsNum( ::nEstado )

         aBitmap                             := ::oSalon:aBitmapsState[ ::nEstado ]

         aBitmap[ BITMAP_ZEROCLR ]           := Rgb( 255, 0, 255 )

         SetBkColor( ::hDC, nRGB( 255, 255, 255 ) )

         TransBmp(   aBitmap[ BITMAP_HANDLE ],;
                     aBitmap[ BITMAP_WIDTH ],;
                     aBitmap[ BITMAP_HEIGHT ],;
                     aBitmap[ BITMAP_ZEROCLR ],;
                     ::hDC,;
                     ( ::nWidth() - 16 ) / 2,;
                     ( ::nHeight() - 16 ) / 2 ,; // 24,;
                     nBmpWidth( aBitmap[ BITMAP_HANDLE ] ),;
                     nBmpHeight( aBitmap[ BITMAP_HANDLE ] ) )

      end if

   else

      DrawGray( ::hDC, ::hBmp, 0, 0 )

   endif

   // Texto--------------------------------------------------------------------

   hFont          := SelectObject( ::hDC, ::oFont:hFont )
   nColor         := SetTextColor( ::hDC, Rgb( 0,0,0 ) )
   nMode          := SetBkMode( ::hDC, 1 )

   // Nombre de la mesa--------------------------------------------------------

   if !Empty( ::cTooltip )
      DrawText( ::hDC, Rtrim( ::cToolTip ), { 14, 0, ::nHeight(), ::nWidth() }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) ) // nOr( DT_WORDBREAK, DT_CENTER, DT_VCENTER, DT_WORD_ELLIPSIS ) )  + "W" + Str( ::nWidth() ) + "H" + Str( ::nHeight() )  + "W" + Alltrim( Str( ::nWidth() ) ) + "H" + Alltrim( Str( ::nHeight() ) )
   end if

   // Total de la mesa---------------------------------------------------------

   if !Empty( ::sPunto ) .and. !Empty( ::sPunto:nTotal )
      DrawText( ::hDC, Alltrim( Trans( ::sPunto:nTotal, cPorDiv() ) ) + cSimDiv(), { ( ::nHeight() - 24 ), 0, ::nHeight(), ::nWidth() }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) ) // nOr( DT_WORDBREAK, DT_CENTER, DT_VCENTER, DT_WORD_ELLIPSIS ) )  + "W" + Str( ::nWidth() ) + "H" + Str( ::nHeight() )  + "W" + Alltrim( Str( ::nWidth() ) ) + "H" + Alltrim( Str( ::nHeight() ) )
   end if

   SetBkMode   ( ::hDC, nMode    )
   SetTextColor( ::hDC, nColor   )
   SelectObject( ::hDC, hFont    )

Return 0

#else

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TMesa

   DATA oSalon
   DATA oBtnBmp

   DATA nEstado
   DATA sPunto

   DATA cCodigoSala
   DATA cPuntoVenta

   DATA nColorLibre     AS NUMERIC INIT nRgb( 0, 255, 0 )
   DATA nColorCurso     AS NUMERIC INIT nRgb( 255,255, 0 )
   DATA nColorOcupado   AS NUMERIC INIT nRgb( 255, 38, 7 )

   Method New()
   Method ColorEstado()
   Method SelectedMesa()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, sPunto, oSalon ) CLASS TMesa

   local oBtn
   local oFont       := TFont():New( "Ms Sans Serif", 0, -12 )
   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oSalon          := oSalon

   ::oBtnBmp         := TBtnBmp():New( nTop, nLeft, nWidth, nHeight,,,,, {|| ::SelectedMesa( oWnd ) }, oWnd,,, .F., .T., AllTrim( sPunto:cPuntoVenta ) , oFont,,, !.T., )

   ::oBtnBmp:SetColor( nRgb( 0,0,0 ), ::ColorEstado( sPunto:nEstado ) )
   ::oBtnBmp:Cargo   := sPunto

   RECOVER USING oError

      msgStop( "Error al conectar con el pc" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectedMesa( oWnd )

   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oSalon:oSelectedPunto := ::oBtnBmp:Cargo
   oWnd:End( IDOK )

   RECOVER USING oError

      msgStop( "Error al conectar con el pc" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//---------------------------------------------------------------------------//

Method ColorEstado( nEstado )

   local nColor

   do case
      case ( nEstado = 1 )
         nColor := ::nColorLibre
      case ( nEstado = 2 )
         nColor := ::nColorCurso
      case ( nEstado = 3 )
         nColor := ::nColorOcupado
   end case

Return nColor

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//

CLASS TMesaTS

   DATA oSalon
   DATA oBtnBmp

   DATA nEstado
   DATA sPunto

   DATA cCodigoSala
   DATA cPuntoVenta

   DATA nColorLibre     AS NUMERIC INIT nRgb( 0, 255, 0 )
   DATA nColorCurso     AS NUMERIC INIT nRgb( 255,255, 0 )
   DATA nColorOcupado   AS NUMERIC INIT nRgb( 255, 38, 7 )

   Method New()
   Method ColorEstado()
   Method SelectedMesa()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nTop, nLeft, nWidth, nHeight, oWnd, sPunto, oSalon ) CLASS TMesaTS

   local oBtn
   local oFont       := TFont():New( "Ms Sans Serif", 0, -12 )
   local oError
   local oBlock

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oSalon          := oSalon

   ::oBtnBmp         := TBtnBmp():New( nTop, nLeft, nWidth, nHeight,,,,, {|| ::SelectedMesa( oWnd ) }, oWnd,,, .F., .T., AllTrim( sPunto:cPuntoVenta ) , oFont,,, !.T., "BOTTOM" )

   ::oBtnBmp:SetColor( nRgb( 0,0,0 ), ::ColorEstado( sPunto:nEstado ) )
   ::oBtnBmp:Cargo   := sPunto

   RECOVER USING oError

      msgStop( "Error al conectar con el pc" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//---------------------------------------------------------------------------//

Method SelectedMesa( oWnd ) CLASS TMesaTS

   local oError
   local oBlock

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oSalon:oSelectedPunto    := ::oBtnBmp:Cargo

   oWnd:End( IDOK )

   RECOVER USING oError

      msgStop( "Error al conectar con el pc" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return nil

//---------------------------------------------------------------------------//

Method ColorEstado( nEstado ) CLASS TMesaTS

   local nColor

   do case
      case ( nEstado = 1 )
         nColor := ::nColorLibre
      case ( nEstado = 2 )
         nColor := ::nColorCurso
      case ( nEstado = 3 )
         nColor := ::nColorOcupado
   end case

Return nColor

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifndef __PDA__

#pragma BEGINDUMP

#include <C:\bcc582\Include\windows.h>
#include <C:\bcc582\Include\winuser.h>
#include <C:\bcc582\Include\wingdi.h>
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
/*
HB_FUNC( SETWINDOWRGN )
{
   hb_retni( SetWindowRgn( ( HWND ) hb_parnl( 1 ), ( HRGN ) hb_parnl( 2 ), hb_parl( 3 ) ) );
}
*/
#pragma ENDDUMP

#endif