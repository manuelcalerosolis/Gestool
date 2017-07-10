#include "FiveWin.Ch"
#include "Ini.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

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
#define DT_WORDBREAK                                                                        16
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
#define itmRecoger                        30
#define itmEncargar                       31

#define itmStateLibre                     1
#define itmStateOcupada                   2

#define ubiGeneral                        0
#define ubiLlevar                         1
#define ubiSala                           2
#define ubiRecoger                        3
#define ubiEncargar                       4

#define stateMesaLibre                    1
#define stateMesaOcupada                  2

#define NINICIO                           0
#define NROWINSERT                        28
#define NCOLINSERT                        2

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TTpvSalon

   DATA  oWnd
   DATA  oOfficeBar

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
   DATA  oBtnRecoger
   DATA  oBtnEncargar
   DATA  oBtnSalirSalon

   DATA  aMesas

   DATA  oSender

   DATA  nTop
   DATA  nLeft
   DATA  nType

   DATA Title                             INIT "Seleccione puntos de venta"

   CLASSDATA   aBitmapsState

   METHOD New( oSender )
   METHOD End()
   METHOD Close()

   METHOD Design()
   Method InitDesign()

   METHOD Selector( oDlg )
   METHOD   InitSelector()
   METHOD   StartSelector()

   METHOD SelectSala( oBtnItem )

   METHOD SelectPunto( oPunto )
   METHOD SelectGenerico()
   METHOD SelectLlevar()

   METHOD SaveToDatabase()
   METHOD LoadFromDatabase()

   METHOD SelectItem( nItem )
   METHOD UnSelectButtons()
   METHOD CreateFromPunto( sPunto )

   METHOD LoadGenericosPendientes( lPuntosPendientes )
   METHOD LoadLlevarPendientes( lPuntosPendientes )
   METHOD LoadEncargarPendientes( lPuntosPendientes )
   METHOD LoadRecogerPendientes( lPuntosPendientes )

   METHOD CreateItemMesa( nRow, nCol, uTooltip, nType, cBitmap )

   METHOD CreateItemMesaRedonda( nRow, nCol, uTooltip )                    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmMesaRedonda, "Shape_circle_80" )
   METHOD CreateItemMesaEliptica( nRow, nCol, uTooltip )                   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmMesaEliptica, "Shape_ellipse_80" )
   METHOD CreateItemMesaCuadrada( nRow, nCol, uTooltip )                   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmMesaCuadrada, "Shape_square_80" )
   METHOD CreateItemMesaRectangular( nRow, nCol, uTooltip )                INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmMesaRectangular, "Shape_rectangle_80" )
   METHOD CreateItemBarraHorizontal( nRow, nCol, uTooltip )                INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmBarrraHorizontal, "Bar_center_64" )
   METHOD CreateItemBarraVertical( nRow, nCol, uTooltip )                  INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmBarrraVertical, "Bar_left_64" )
   METHOD CreateItemBarrraEsquinaDerechaAbajo( nRow, nCol, uTooltip )      INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmBarrraEsquinaDerechaAbajo, "Bar_corner_left_64" )
   METHOD CreateItemBarrraEsquinaIzquierdaAbajo( nRow, nCol, uTooltip )    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmBarrraEsquinaIzquierdaAbajo, "Bar_corner_right_64" )
   METHOD CreateItemBarrraEsquinaDerechaArriba( nRow, nCol, uTooltip )     INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmBarrraEsquinaDerechaArriba, "Bar_corner_top_left_64" )
   METHOD CreateItemBarrraEsquinaIzquierdaArriba( nRow, nCol, uTooltip )   INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmBarrraEsquinaIzquierdaArriba, "Bar_corner_top_right_64" )
   METHOD CreateItemPlantaBlanca( nRow, nCol )                             INLINE ::CreateItemMesa( nRow, nCol, nil, itmPlantaBlanca, "Flower_white_32" )
   METHOD CreateItemPlantaAzul( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, nil, itmPlantaAzul, "Flower_blue_32" )
   METHOD CreateItemPlantaRoja( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, nil, itmPlantaRoja, "Flower_red_32" )
   METHOD CreateItemPlantaAmarilla( nRow, nCol )                           INLINE ::CreateItemMesa( nRow, nCol, nil, itmPlantaAmarilla, "Flower_yellow_32" )
   METHOD CreateItemPanelHorizontal( nRow, nCol )                          INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelHorizontal, "Navigate2_minus_64" )
   METHOD CreateItemPanelVertical( nRow, nCol )                            INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelVertical, "Navigate_panel_64" )
   METHOD CreateItemPanelCruce( nRow, nCol )                               INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelCruce, "Navigate2_plus_64" )
   METHOD CreateItemPanelConexionArriba( nRow, nCol )                      INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelConexionArriba, "Navigate_connection_up_64" )
   METHOD CreateItemPanelConexionAbajo( nRow, nCol )                       INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelConexionAbajo, "Navigate_connection_down_64" )
   METHOD CreateItemPanelConexionDerecha( nRow, nCol )                     INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelConexionDerecha, "Navigate_right_64" )
   METHOD CreateItemPanelConexionIzquierda( nRow, nCol )                   INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelConexionIzquierda, "Navigate_left_64" )
   METHOD CreateItemPanelCurvaAbajo( nRow, nCol )                          INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelCurvaAbajo, "Navigate_corner_left_64" )
   METHOD CreateItemPanelCurvaArriba( nRow, nCol )                         INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelCurvaArriba, "Navigate_corner_right_top_64" )
   METHOD CreateItemPanelCurvaDerecha( nRow, nCol )                        INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelCurvaDerecha, "Navigate_corner_right_64" )
   METHOD CreateItemPanelCurvaIzquierda( nRow, nCol )                      INLINE ::CreateItemMesa( nRow, nCol, nil, itmPanelCurvaIzquierda, "Navigate_corner_right_down_64" )
   
   METHOD CreateItemGenerico( nRow, nCol, uTooltip )                       INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmGenerico, "gc_cash_register_160" )
   METHOD CreateItemLlevar( nRow, nCol, uTooltip )                         INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmLlevar, "gc_motor_scooter_160" )
   METHOD CreateItemEncargar( nRow, nCol, uTooltip )                       INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmEncargar, "gc_notebook2_160" )
   METHOD CreateItemNewGenerico( nRow, nCol, uTooltip )                    INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmNewGenerico, "gc_cash_register_160" )
   METHOD CreateItemNewLlevar( nRow, nCol, uTooltip )                      INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmNewLlevar, "gc_motor_scooter_160" )
   METHOD CreateItemRecoger( nRow, nCol, uTooltip )                        INLINE ::CreateItemMesa( nRow, nCol, uTooltip, itmRecoger, "gc_shopping_basket_160" )

   //------------------------------------------------------------------------//

   METHOD cCodForSalon( cSalon )

   METHOD lLimpiaSalon()

   METHOD AddResource( cResource )

   METHOD CreateItem()

   METHOD LoadFromMemory()

   METHOD aNumerosTickets()

   METHOD oTactil()        INLINE ( ::oSender:oSender )
   METHOD oTiketCabecera() INLINE ( ::oTactil():oTiketCabecera )

   METHOD lBrowseMultiplesTickets( aNumerosTickets )

   METHOD StartResource( oDlg )

   METHOD LineaPrimera( oBrw )      INLINE ( oBrw:GoTop(),    oBrw:Select(0), oBrw:Select(1) )
   METHOD PaginaAnterior( oBrw )    INLINE ( oBrw:PageUp(),   oBrw:Select(0), oBrw:Select(1) )
   METHOD PaginaSiguiente( oBrw )   INLINE ( oBrw:PageDown(), oBrw:Select(0), oBrw:Select(1) )
   METHOD LineaAnterior( oBrw )     INLINE ( oBrw:GoUp(),     oBrw:Select(0), oBrw:Select(1) )
   METHOD LineaSiguiente( oBrw )    INLINE ( oBrw:GoDown(),   oBrw:Select(0), oBrw:Select(1) )
   METHOD LineaUltima( oBrw )       INLINE ( oBrw:GoBottom(), oBrw:Select(0), oBrw:Select(1) )

   METHOD cTitle( uValue )          INLINE ( if( !Empty( uValue ), ::Title := uValue, ::Title ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS TTpvSalon

   ::oSender                  := oSender

   ::nItemToInsert            := NINICIO
   ::aBitmapsState            := {}
   ::aMesas                   := {}

   if Empty( ::aBitmapsState )
      ::AddResource( "gc_check_12" )
      ::AddResource( "gc_shape_square_12" )
      ::AddResource( "gc_delete_12" )
   end if

Return ( Self )

//------------------------------------------------------------------------//

Method End( nId ) CLASS TTpvSalon

   ::Close( nId )

   if !Empty( ::aBitmapsState )
      aEval( ::aBitmapsState, {|a| PalBmpFree( a[1], a[2] ) } )
   end if

   ::aBitmapsState   := nil

Return ( Self )

//------------------------------------------------------------------------//

Method Close( nId ) CLASS TTpvSalon

   if !Empty( ::aMesas )
      aEval( ::aMesas, {|o| o:End() } )
   end if

   ::aMesas          := {}

   if !Empty( ::oWnd )
      ::oWnd:End( nId )
   end if

Return ( Self )

//---------------------------------------------------------------------------//
//
// oSender -> TTpvRestaurante
//

Method Design( oSender, oDlg ) CLASS TTpvSalon

   ::oSender                  := oSender

   ::lDesign                  := .t.

   ::oWnd                     := TDialog():New( , , , , "Diseñando sala de ventas", "SelectMesa" )

   ::oWnd:Activate( , , , .t., , , {|| ::InitDesign() } )

Return ( .t. )

//------------------------------------------------------------------------//

Method InitDesign() CLASS TTpvSalon

   local oGrupo
   local oBoton
   local oCarpeta

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 1000, 120, ::oWnd, 1 )
   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oWnd:oTop                := ::oOfficeBar

   ::oWnd:oClient             := TPanelEx():New()

   ::oWnd:oClient:OnClick     := {| nRow, nCol | ::CreateItem( nil, nRow, nCol, .t. ) } // := {| oWnd, nRow, nCol | ::CreateItem( nil, nRow, nCol, .t. ) }

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

METHOD LoadFromDatabase( cCodigoSala ) CLASS TTpvSalon

   local oMesa
   local oDbfVir  := ::oSender:oDetSalaVta:oDbfVir

   if empty( cCodigoSala )

      if !empty( oDbfVir ) .and. ( oDbfVir:Used() )

         oDbfVir:GoTop()
         while !oDbfVir:Eof()

            msgalert( "mesa " + str( oDbfVir:nTipo ), "nTipo" )
 
            oMesa    := TTpvMesa():New( oDbfVir:nFila, oDbfVir:nColumna, oDbfVir:nTipo, ::oWnd:oClient )
            oMesa:LoadFromSala( ::oSender )

            oDbfVir:Skip()

         end while

         oDbfVir:GoTop()

      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SaveToDatabase() CLASS TTpvSalon

   local oControl
   local aPuntoVenta := {}

   for each oControl in ::oWnd:oClient:aControls
      if aScan( aPuntoVenta, {|c| if( !Empty( c ) .and. !Empty( oControl:cPuntoVenta ), Rtrim( c ) == Rtrim( oControl:cPuntoVenta ), .f. ) } ) == 0
         if !Empty( oControl:cPuntoVenta )
            aAdd( aPuntoVenta, Rtrim( oControl:cPuntoVenta ) )
         end if
      else
         msgStop( "El nombre " + Rtrim( oControl:cPuntoVenta ) + " esta duplicado." )
         Return ( Self )
      end if
   next

   if !Empty( ::oSender:oDetSalaVta:oDbfVir ) .and. ( ::oSender:oDetSalaVta:oDbfVir:Used() )

      ::oSender:oDetSalaVta:oDbfVir:Zap()

      for each oControl in ::oWnd:oClient:aControls
         ::oSender:oDetSalaVta:oDbfVir:Blank()
         ::oSender:oDetSalaVta:oDbfVir:nTipo    := oControl:nType
         ::oSender:oDetSalaVta:oDbfVir:nFila    := oControl:nTop
         ::oSender:oDetSalaVta:oDbfVir:nColumna := oControl:nLeft
         ::oSender:oDetSalaVta:oDbfVir:cDescrip := oControl:cPuntoVenta
         ::oSender:oDetSalaVta:oDbfVir:Insert()
      next

      ::oSender:oDetSalaVta:oDbfVir:GoTop()

   end if

   ::End( IDOK )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SelectPunto( oPunto ) CLASS TTpvSalon

   if oPunto:nUbicacion == ubiSala .and. Len( ::aNumerosTickets( oPunto ) ) > 1

      if ::lBrowseMultiplesTickets( oPunto )

         ::oSelectedPunto  := oPunto

         ::Close( IDOK )

      end if   

   else   

      ::oSelectedPunto     := oPunto

      ::Close( IDOK )

   end if

RETURN nil

//---------------------------------------------------------------------------//

METHOD aNumerosTickets( oPunto ) Class TTpvSalon

   local aNumeros    := {}

   with object ( ::oTactil():oTiketCabecera )
      
      :GetStatus()

      :OrdSetFocus( "cCodSal" )

      if :Seek( oPunto:cCodigoSala + Padr( oPunto:cPuntoVenta, 30 ) )

         while :FieldGetByName( "cCodSala" ) + :FieldGetByName( "cPntVenta" ) == oPunto:cCodigoSala + Padr( oPunto:cPuntoVenta, 30 ) .and. !:Eof()

            aAdd( aNumeros, :FieldGetByName( "cSerTik" ) + :FieldGetByName( "cNumTik" ) + :FieldGetByName( "cSufTik" ) )

            :Skip()

         end while

      end if

      :SetStatus()

   end with

Return ( aNumeros )

//---------------------------------------------------------------------------//

Method lBrowseMultiplesTickets( oPunto ) Class TTpvSalon

   local oDlg
   local oBrw
   local oFont                := TFont():New( "Segoe UI",  0, 20, .f., .t. )

   ::oTiketCabecera():GetStatus()

   ::oTiketCabecera():OrdSetFocus( "cCodSal" )
   ::oTiketCabecera():OrdScope( oPunto:cCodigoSala + Padr( oPunto:cPuntoVenta, 30 ) )
   
   ::oTiketCabecera():GoTop()

   DEFINE DIALOG oDlg RESOURCE ( "Tpv_Lista_Multiples" )

      oBrw                   := IXBrowse():New( oDlg )

      oBrw:lRecordSelector   := .f.
      oBrw:lHScroll          := .f.
      oBrw:lVScroll          := .t.
      oBrw:nHeaderLines      := 2
      oBrw:nDataLines        := 2
      oBrw:cName             := "Tpv.Lista multiples tickets"
      oBrw:nRowHeight        := 54

      oBrw:nMarqueeStyle     := 5
      oBrw:nRowDividerStyle  := 4

      oBrw:bClrSel           := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }
      oBrw:bClrSelFocus      := {|| { CLR_WHITE, RGB( 53, 142, 182 ) } }

      oBrw:bLDblClick        := {|| oDlg:End( IDOK ) }

      oBrw:oFont             := oFont

      ::oTiketCabecera():SetBrowse( oBrw )

      oBrw:CreateFromResource( 100 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Número"
         :bEditValue       := {|| ::oTiketCabecera():FieldGetByName( "cSerTik" ) + "/" + AllTrim( ::oTiketCabecera():FieldGetByName( "cNumTik" ) ) + "/" + ::oTiketCabecera():FieldGetByName( "cSufTik" ) }
         :nWidth           := 90
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Fecha" + CRLF + "Hora"
         :bEditValue       := {|| dToc( ::oTiketCabecera():FieldGetByName( "dFecTik" ) ) + CRLF + ::oTiketCabecera():FieldGetByName( "cHorTik" ) }
         :nWidth           := 100
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Caja"
         :bEditValue       := {|| ::oTiketCabecera():FieldGetByName( "cNcjTik" ) }
         :nWidth           := 75
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Usuario"
         :bEditValue       := {|| ::oTiketCabecera():FieldGetByName( "cCcjTik" ) }
         :nWidth           := 75
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Estado"
         :bEditValue       := {|| ::oTactil():cEstado() }
         :nWidth           := 90
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Cliente"
         :bEditValue       := {|| ::oTiketCabecera():FieldGetByName( "cCliTik" ) + CRLF + ::oTiketCabecera():FieldGetByName( "cNomTik" ) }
         :nWidth           := 275
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Total"
         :bEditValue       := {|| ::oTiketCabecera():FieldGetByName( "nTotTik" ) }
         :cEditPicture     := ::oTactil():cPictureTotal
         :nDataStrAlign    := 1
         :nHeadStrAlign    := 1
         :nWidth           := 100
      end with

      oDlg:bStart          := {|| ::StartResource( oBrw, oDlg ) }

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      oPunto:cSerie        := ::oTiketCabecera():FieldGetByName( "cSerTik" )
      oPunto:cNumero       := ::oTiketCabecera():FieldGetByName( "cNumTik" )
      oPunto:cSufijo       := ::oTiketCabecera():FieldGetByName( "cSufTik" )

   end if

   ::oTiketCabecera():OrdClearScope()

   ::oTiketCabecera():SetStatus()

   oFont:End()

Return ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD StartResource( oBrw, oDlg ) CLASS TTpvSalon

   local oBoton
   local oGrupo
   local oCarpeta
   local oOfficeBar

   if Empty( oOfficeBar )

      /*
      Calculo la longitud para oGrpSalones
      */

      oOfficeBar            := TDotNetBar():New( 0, 0, 1020, 120, oDlg, 1 )

      oOfficeBar:lPaintAll  := .f.
      oOfficeBar:lDisenio   := .f.

      oOfficeBar:SetStyle( 1 )

      oDlg:oTop    := oOfficeBar

      oCarpeta       := TCarpeta():New( oOfficeBar, "Inicio" )

      oGrupo         := TDotNetGroup():New( oCarpeta, 366,  "Seleción de tickets", .f. )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_navigate_line_up_32",   "Primera línea",      1, {|| ::LineaPrimera( oBrw ) } )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_navigate_line_down_32", "Última línea",       2, {|| ::LineaUltima( oBrw ) } )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_navigate_up2a_32",      "Página anterior",    3, {|| ::PaginaAnterior( oBrw ) } )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_navigate_down2a_32",    "Página siguiente",   4, {|| ::PaginaSiguiente( oBrw ) } )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_arrow_up_32",           "Línea anterior",     5, {|| ::LineaAnterior( oBrw ) } )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_arrow_down_32",         "Línea siguiente",    6, {|| ::LineaSiguiente( oBrw ) } )

      oGrupo         := TDotNetGroup():New( oCarpeta, 126,  "Salida", .f. )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "gc_check_32",                "Aceptar",            1, {|| oDlg:End( IDOK ) }, , , .f., .f., .f. )
         oBoton      := TDotNetButton():New( 60, oGrupo,    "End32",                   "Salida",             2, {|| oDlg:End() }, , , .f., .f., .f. )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

METHOD SelectGenerico() CLASS TTpvSalon

   ::oSelectedPunto           :=  ::oSender:oGenerico

   ::End( IDOK )

RETURN nil

//---------------------------------------------------------------------------//

METHOD SelectLlevar() CLASS TTpvSalon

   ::oSelectedPunto           :=  ::oSender:oLlevar

   ::End( IDOK )

RETURN nil

//---------------------------------------------------------------------------//

Method SelectSala( oBtnItem, lPuntosPendientes ) CLASS TTpvSalon

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

METHOD CreateItemMesa( nRow, nCol, cPuntoVenta, nType ) CLASS TTpvSalon

   local oItemMesa

   DEFAULT nRow                  := 0
   DEFAULT nCol                  := 0
   DEFAULT nType                 := itmMesaRectangular

   oItemMesa                     := TTpvMesa():New( nRow, nCol, nType, ::oWnd:oClient, Self )

   oItemMesa:lDesign             := ::lDesign

   do case
      case IsNil( cPuntoVenta )
         oItemMesa:cPuntoVenta   := nil
      case IsChar( cPuntoVenta )
         oItemMesa:cPuntoVenta   := Rtrim( cPuntoVenta )
      case IsTrue( cPuntoVenta )
         oItemMesa:cPuntoVenta   := VirtualKey( .f., "", "Nombre de la mesa" )
   end case

   oItemMesa:Refresh()

   aAdd( ::aMesas, oItemMesa )

Return ( oItemMesa )

//---------------------------------------------------------------------------//

METHOD SelectItem( nItem, oBtnItem ) CLASS TTpvSalon

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

METHOD UnSelectButtons() CLASS TTpvSalon

   local oGrupo
   local oBoton
   local oCarpeta

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

METHOD CreateFromPunto( sPunto ) CLASS TTpvSalon

   local oItemMesa

   oItemMesa               := ::CreateItem( sPunto:nTipo, sPunto:nFila, sPunto:nColumna, sPunto:cPuntoVenta )
   if !Empty( oItemMesa )
      oItemMesa:sPunto     := sPunto
      if IsChar( oItemMesa:cTooltip )
         oItemMesa:nState := ::oSender:nStatePunto( sPunto )
      end if
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD LoadGenericosPendientes( lPuntosPendientes ) CLASS TTpvSalon

   local n
   local sPunto
   local nHorizontal

   DEFAULT lPuntosPendientes  := .f.

   n                          := 0
   nHorizontal                := ::oWnd:nHorzRes() - 203

   ::nTop                     := 5
   ::nLeft                    := 1
   ::nType                    := itmGenerico

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End() 
   end while

   /*
   Creo los puntos genericos y pinto el salon----------------------------------
   */

   ::oSender:oSender:oTiketCabecera:GetStatus()
   ::oSender:oSender:oTiketCabecera:OrdSetFocus( "lCloUbiTik" )

   if ::oSender:oSender:oTiketCabecera:Seek( Str( ubiGeneral, 1 ) )

      while ::oSender:oSender:oTiketCabecera:FieldGetByName( "nUbiTik" ) == ubiGeneral .and. !::oSender:oSender:oTiketCabecera:Eof()

         sPunto               := sTpvPunto():CreateFromSalon( n++, Self )
         sPunto:CreateMesa( lPuntosPendientes )

         ::nLeft              += 164

         if ::nLeft > nHorizontal
            ::nLeft           := 1
            ::nTop            += 85
         end if

         ::oSender:oSender:oTiketCabecera:Skip()

      end while

   end if

   ::oSender:oSender:oTiketCabecera:SetStatus()

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   if !Empty( ::oBtnGenerico )
      ::UnSelectButtons()
      ::oBtnGenerico:lSelected  := .t.
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadRecogerPendientes( lPuntosPendientes ) CLASS TTpvSalon

   local n
   local sPunto
   local nHorizontal

   DEFAULT lPuntosPendientes  := .f.

   n                          := 0
   nHorizontal                := ::oWnd:nHorzRes() - 203

   ::nTop                     := 5
   ::nLeft                    := 1
   ::nType                    := itmRecoger

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End()
   end while

   /*
   Creo los puntos genericos y pinto el salon----------------------------------
   */

   ::oSender:oSender:oTiketCabecera:GetStatus()
   ::oSender:oSender:oTiketCabecera:OrdSetFocus( "nUbiTik" )

   if ::oSender:oSender:oTiketCabecera:Seek( Str( ubiRecoger, 1 ) )

      while ::oSender:oSender:oTiketCabecera:FieldGetByName( "nUbiTik" ) == ubiRecoger .and. !::oSender:oSender:oTiketCabecera:Eof()

         sPunto               := sTpvPunto():CreateFromSalon( n++, Self )
         sPunto:CreateMesa( lPuntosPendientes )

         ::nLeft              += 164

         if ::nLeft > nHorizontal
            ::nLeft           := 1
            ::nTop            += 85
         end if

         ::oSender:oSender:oTiketCabecera:Skip()

      end while

   end if

   ::oSender:oSender:oTiketCabecera:SetStatus()

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   if !Empty( ::oBtnRecoger )
      ::UnSelectButtons()
      ::oBtnRecoger:lSelected  := .t.
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadLlevarPendientes( lPuntosPendientes ) CLASS TTpvSalon

   local n
   local sPunto
   local nHorizontal

   DEFAULT lPuntosPendientes  := .f.

   n                          := 0
   nHorizontal                := ::oWnd:nHorzRes() - 203

   ::nTop                     := 5
   ::nLeft                    := 1
   ::nType                    := itmLlevar

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End()
   end while

   /*
   Creo los puntos genericos y pinto el salon----------------------------------
   */

   ::oSender:oSender:oTiketCabecera:GetStatus()
   ::oSender:oSender:oTiketCabecera:OrdSetFocus( "nUbiTik" )

   if ::oSender:oSender:oTiketCabecera:Seek( Str( ubiLlevar, 1 ) )

      while ::oSender:oSender:oTiketCabecera:FieldGetByName( "nUbiTik" ) == ubiLlevar .and. !::oSender:oSender:oTiketCabecera:Eof()

         sPunto               := sTpvPunto():CreateFromSalon( n++, Self )
         sPunto:CreateMesa( lPuntosPendientes )

         ::nLeft              += 164

         if ::nLeft > nHorizontal
            ::nLeft           := 1
            ::nTop            += 85
         end if

         ::oSender:oSender:oTiketCabecera:Skip()

      end while

   end if

   ::oSender:oSender:oTiketCabecera:SetStatus()

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   if !Empty( ::oBtnLlevar )
      ::UnSelectButtons()
      ::oBtnLlevar:lSelected  := .t.
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadEncargarPendientes( lPuntosPendientes ) CLASS TTpvSalon

   local n
   local sPunto
   local nHorizontal

   DEFAULT lPuntosPendientes  := .f.

   n                          := 0
   nHorizontal                := ::oWnd:nHorzRes() - 203

   ::nTop                     := 5
   ::nLeft                    := 1
   ::nType                    := itmEncargar

   /*
   Limpio la sala para montar los puntos de venta------------------------------
   */

   while len( ::oWnd:oClient:aControls ) > 0
      ::oWnd:oClient:aControls[ 1 ]:End()
   end while

   /*
   Creo los puntos genericos y pinto el salon----------------------------------
   */

   ::oSender:oSender:oTiketCabecera:GetStatus()
   ::oSender:oSender:oTiketCabecera:OrdSetFocus( "nUbiTik" )

   if ::oSender:oSender:oTiketCabecera:Seek( Str( ubiEncargar, 1 ) )

      while ::oSender:oSender:oTiketCabecera:FieldGetByName( "nUbiTik" ) == ubiEncargar .and. !::oSender:oSender:oTiketCabecera:Eof()

         sPunto               := sTpvPunto():CreateFromSalon( n++, Self )
         sPunto:CreateMesa( lPuntosPendientes )

         ::nLeft              += 164

         if ::nLeft > nHorizontal
            ::nLeft           := 1
            ::nTop            += 85
         end if

         ::oSender:oSender:oTiketCabecera:Skip()

      end while

   end if

   ::oSender:oSender:oTiketCabecera:SetStatus()

   /*
   Devuelvo la tabla a su orden y posición original----------------------------
   */

   if !Empty( ::oBtnEncargar )
      ::UnSelectButtons()
      ::oBtnEncargar:lSelected  := .t.
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddResource( cResource ) CLASS TTpvSalon

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

//---------------------------------------------------------------------------//

Method Selector( lPuntosPendientes, lLlevar, nSelectOption ) CLASS TTpvSalon

   local n
   local sSala

   DEFAULT nSelectOption      := ubiSala

   if len( ::oSender:aSalas ) == 0
      MsgStop( "No existen salones definidos." )
      Return .f.
   end if

   ::lDesign                  := .f.

   ::oWnd                     := TDialog():New( , , , , ::cTitle(), "SelectMesa" )

   ::oWnd:bStart              := {|| ::StartSelector( lPuntosPendientes, lLlevar, nSelectOption ) }

   ::oWnd:Activate( , , , .t., , .t., {|| ::InitSelector( lPuntosPendientes, lLlevar, nSelectOption ) } )

Return ( ::oWnd:nResult == IDOK )

//---------------------------------------------------------------------------//

Method InitSelector( lPuntosPendientes, lShowLlevar, nSelectOption ) CLASS TTpvSalon

   local nSala
   local sSala
   local oGrupo
   local oBoton
   local nWidth
   local oCarpeta

   nSala                      := len( ::oSender:aSalas )

   nWidth                     := ( nSala * 60 )

   if lShowLlevar

      nWidth                  += 60

      if uFieldEmpresa( "lRecoger" )
         nWidth               += 60
      end if

      if uFieldEmpresa( "lLlevar" )
         nWidth               += 60
      end if

      if uFieldEmpresa( "lRecoger" )
         nWidth               += 60
      end if

   end if

   nWidth                     += 6

   ::oOfficeBar               := TDotNetBar():New( 0, 0, 1008, 120, ::oWnd, 1 )
   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oWnd:oTop                := ::oOfficeBar

   oCarpeta                   := TCarpeta():New( ::oOfficeBar, "Salones" )
      oGrupo                  := TDotNetGroup():New( oCarpeta, nWidth, "Salones", .f. )

      for each sSala in ::oSender:aSalas
         
         oBoton               := TDotNetButton():New( 60, oGrupo, sSala:cImagen, sSala:cDescripcion, hb_enumindex(), {| oBoton | ::SelectSala( oBoton, lPuntosPendientes ) }, , , .f., .f., .f. )
         oBoton:cName         := sSala:cCodigo

         //Si el usuario tiene asignada una sala de venta seleccionamos el boton
         
         if !empty( oUser():SalaVenta() )
            oBoton:lSelected  := ( sSala:cCodigo == oUser():SalaVenta() )
         else
            oBoton:lSelected  := ( hb_enumindex() == 1 )
         end if 

      next

   if lShowLlevar

      nSala++

      ::oBtnGenerico          := TDotNetButton():New( 60, oGrupo, "gc_cash_register_32", "General", nSala, {|| ::LoadGenericosPendientes( lPuntosPendientes ) }, , , .f., .f., .f. )

      if uFieldEmpresa( "lRecoger" )
         ::oBtnRecoger        := TDotNetButton():New( 60, oGrupo, "gc_shopping_basket_32", "Para recoger", ++nSala, {|| ::LoadRecogerPendientes( lPuntosPendientes ) }, , , .f., .f., .f. )
      end if

      if uFieldEmpresa( "lLlevar" )
         ::oBtnLlevar         := TDotNetButton():New( 60, oGrupo, "gc_motor_scooter_32", "Para llevar", ++nSala, {|| ::LoadLlevarPendientes( lPuntosPendientes ) }, , , .f., .f., .f. )
      end if

      if uFieldEmpresa( "lEncargar" )
         ::oBtnEncargar       := TDotNetButton():New( 60, oGrupo, "gc_notebook2_32", "Encargar", ++nSala, {|| ::LoadEncargarPendientes( lPuntosPendientes ) }, , , .f., .f., .f. )
      end if

   end if

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Acciones", .f., , "gc_door_open2_32" )
      oBoton                  := TDotNetButton():New( 60, oGrupo, "End32", "Salir", 1, {|| ::oSelectedPunto := nil, ::Close( IDCANCEL ) }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 246, "Leyenda ubicaciones", .f., , "" )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "gc_check_12", "Libre", 1, nil, , , .f., .f., .f. )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "gc_shape_square_12", "Ocupada", 1, nil, , , .f., .f., .f. )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "gc_delete_12", "Ticket entregado", 1, nil, , , .f., .f., .f. )
      oBoton                  := TDotNetButton():New( 120, oGrupo, "", "[...] Multiples tickets", 2, nil, , , .f., .f., .f. )

   ::oWnd:oClient             := TPanelEx():New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD StartSelector( lPuntosPendientes, lShowLlevar, nSelectOption ) CLASS TTpvSalon

   ::oWnd:Maximize()

   // Comprobamos si el usuario tiene una sala de venta asignada por defecto----

   if !Empty( oUser():SalaVenta() )
      ::LoadFromMemory( oUser():SalaVenta(), lPuntosPendientes )
   else
      ::LoadFromMemory( nil, lPuntosPendientes )
   end if

   /*
   Después de cargar todos los datos me muevo a la ubicaión que me hayan marcado
   */

   do case
      case nSelectOption == ubiGeneral

         ::oBtnGenerico:Selected()
         ::oBtnLlevar:UnSelected()
         ::oBtnRecoger:UnSelected()
         ::oBtnEncargar:UnSelected()
         
         ::LoadGenericosPendientes( lPuntosPendientes )

      case nSelectOption == ubiLlevar

         ::oBtnLlevar:Selected()
         ::oBtnGenerico:UnSelected()
         ::oBtnRecoger:UnSelected()
         ::oBtnEncargar:UnSelected()
         
         ::LoadLlevarPendientes( lPuntosPendientes )

      case nSelectOption == ubiRecoger

         ::oBtnRecoger:Selected()
         ::oBtnGenerico:UnSelected()
         ::oBtnLlevar:UnSelected()
         ::oBtnEncargar:UnSelected()
         
         ::LoadRecogerPendientes( lPuntosPendientes )

      case nSelectOption == ubiEncargar

         ::oBtnRecoger:UnSelected()
         ::oBtnGenerico:UnSelected()
         ::oBtnLlevar:UnSelected()
         ::oBtnEncargar:Selected()
         
         ::LoadEncargarPendientes( lPuntosPendientes )

   end case

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD cCodForSalon( cSalon ) CLASS TTpvSalon

   local i
   local nPos
   local cCodSalon   := ""

   if ( nPos := aScan( ::oSender:aSalas, {|a| a:cDescripcion == cSalon } ) ) != 0
      cCodSalon      := ::oSender:aSalas[ nPos ]:cCodigo
   end if

return cCodSalon

//---------------------------------------------------------------------------//

METHOD lLimpiaSalon( lPuntosPendientes ) CLASS TTpvSalon

   local n
   local oMesas

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

METHOD CreateItem( nItem, nRow, nCol, uToolTip ) CLASS TTpvSalon

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

      case nItem == itmEncargar
         Return( ::CreateItemEncargar( nRow, nCol, uToolTip ) )

      case nItem == itmNewGenerico
         Return( ::CreateItemNewGenerico( nRow, nCol, uToolTip ) )

      case nItem == itmNewLlevar
         Return( ::CreateItemNewLlevar( nRow, nCol, uToolTip ) )

      case nItem == itmRecoger
         Return( ::CreateItemRecoger( nRow, nCol, uToolTip ) )

   end case

Return ( nil )

//---------------------------------------------------------------------------//

METHOD LoadFromMemory( cCodigoSala, lPuntosPendientes ) CLASS TTpvSalon

   local sSala
   local sPunto
   local oBlock
   local oError

   CursorWait()

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if empty( cCodigoSala ) .and. len( ::oSender:aSalas ) >= 1
      cCodigoSala    := ::oSender:aSalas[ 1 ]:cCodigo
   end if

   if isChar( cCodigoSala )

      while len( ::oWnd:oClient:aControls ) > 0
         ::oWnd:oClient:aControls[ 1 ]:End()
      end while

      for each sSala in ::oSender:aSalas

         if sSala:cCodigo == cCodigoSala

            for each sPunto in sSala:aPunto

               sPunto:LoadMesa()
               sPunto:CreateMesa( lPuntosPendientes )

            next

         end if

      next

   end if

   RECOVER USING oError
      msgStop( ErrorMessage( oError ), "Error al crear las mesas" )
   END SEQUENCE
   ErrorBlock( oBlock )
   
   CursorWE()

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS sTpvSala

   DATA oSender

   DATA cCodigo
   DATA cDescripcion
   DATA nPrecio
   DATA nPreCmb
   DATA cImagen
   DATA lComensal
   DATA cArticulo
   DATA lMultiplicar

   DATA aPunto          AS ARRAY INIT {}

   Method New( oSender )
   Method BuildPuntos()
   Method AddPunto( nNumero )

END CLASS

//---------------------------------------------------------------------------//

Method New( oSender ) CLASS sTpvSala

   ::oSender      := oSender

   ::cCodigo      := oSender:oDbf:cCodigo
   ::nPrecio      := oSender:oDbf:nPrecio
   ::nPreCmb      := oSender:oDbf:nPreCmb
   ::cDescripcion := Rtrim( oSender:oDbf:cDescrip )
   ::lComensal    := oSender:oDbf:lComensal
   ::cArticulo    := oSender:oDbf:cArticulo
   ::lMultiplicar := oSender:oDbf:lMultipli

   ::cImagen      := oSender:cBigResource()

   ::aPunto       := {}

Return ( Self )

//---------------------------------------------------------------------------//

Method AddPunto( nNumero ) CLASS sTpvSala

   aAdd( ::aPunto, sTpvPunto():Create( nNumero, Self ) )

Return ( Self )

//---------------------------------------------------------------------------//

Method BuildPuntos() CLASS sTpvSala

   local n        := 0
   local sPunto

   if ::oSender:oDetSalaVta:oDbf:Seek( ::oSender:oDbf:cCodigo )

      while ( ::oSender:oDetSalaVta:oDbf:cCodigo == ::oSender:oDbf:cCodigo ) .and. !( ::oSender:oDetSalaVta:oDbf:eof() )

         if !::oSender:lPuntosVenta
            ::oSender:lPuntosVenta  := .t.
         end if

         sPunto   := sTpvPunto():CreateFromSala( n++, Self )

         aAdd( ::aPunto, sPunto )

         ::oSender:oDetSalaVta:oDbf:Skip()

      end while

   end if

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//