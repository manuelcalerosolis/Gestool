#include "FiveWin.Ch"
#include "Ini.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

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

CLASS TTpvMesa FROM TControl

   CLASSDATA lRegistered AS LOGICAL

   CLASSDATA oFont

   DATA nType

   DATA cBitmap
   DATA hBmp
   DATA hPalette
   DATA nBmpWidth
   DATA nBmpHeight

   DATA cCodigoSala
   DATA cPuntoVenta
   DATA cAlias
   DATA cNombre

   DATA nEstado

   DATA oSender

   DATA lGenerica          INIT .f.

   DATA cSerie             INIT ""
   DATA cNumero            INIT ""
   DATA cSufijo            INIT ""

   DATA cCodigoUsuario     INIT ""
   DATA nComensales        INIT 1

   DATA nTotal             INIT 0
   DATA nProductos         INIT 0
   DATA nTiempoOcupacion   INIT 0

   DATA lMultiple          INIT .f.

   DATA cImagen
   DATA nPrecio
   DATA nPreCmb
   DATA lComensal          INIT .f.

   DATA nType

   DATA nUbicacion

   DATA lDesign            INIT .f.

   METHOD New( nTop, nLeft, nType, oWnd ) CONSTRUCTOR
   METHOD LoadFromPunto( oSender )
   METHOD LoadFromSala( oSender )

   METHOD End()            INLINE ( if( !Empty( ::hBmp ), ::DeleteBitmap(), ), ::Super:End() )

   METHOD HandleEvent( nMsg, nWParam, nLParam )

   METHOD LButtonUp( nRow, nCol, nKeyFlags )

   METHOD cBitmapMesa( nItem )
   METHOD aBitmapState()

   METHOD LoadBitmap( cBitmap )
   METHOD DeleteBitmap()

   METHOD Rename()

   METHOD Paint()
   METHOD Display()        INLINE ( ::BeginPaint(), ::Paint(), ::EndPaint(), 0 )

   METHOD oSalon()         INLINE ( ::oSender:oSender:oSalon )
   METHOD oRestaurante()   INLINE ( ::oSender:oSender:oSender )
   METHOD oTactil()        INLINE ( ::oSender:oSender:oSender:oSender )

   METHOD RButtonDown( nRow, nCol, nKeyFlags )

   METHOD uCreaToolTip( nRow, nCol, nKeyFlags )

   METHOD aCargaLineasToolTip()

   METHOD nTotLinToolTip( aLineasToolTip )

   METHOD lSeleccionable()

ENDCLASS

//---------------------------------------------------------------------------//
//
// oSender -> TTpvPunto
//

METHOD New( nTop, nLeft, nType, oWnd ) CLASS TTpvMesa

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nStyle       := nOR( WS_CHILD, WS_VISIBLE, WS_TABSTOP, 0 ) //, WS_CLIPCHILDREN
      ::nId          := ::GetNewId()

      ::nUbicacion   := ubiSala

      ::nTop         := nTop
      ::nLeft        := nLeft

      ::oWnd         := oWnd

      ::oFont        := TFont():New( "Segoe UI",  0, -12, .f., .f. )

      ::nType        := nType
      ::cBitmap      := ::cBitmapMesa( ::nType )

      ::nClrPane     := Rgb( 255, 255, 255 )

      if !Empty( ::cBitmap )
         ::LoadBitmap()
      end if

      ::nBottom      := ::nTop   + ::nBmpHeight - 1
      ::nRight       := ::nLeft  + ::nBmpWidth  - 1

      ::Register( nOR( CS_VREDRAW, CS_HREDRAW ) )

      if !Empty( ::oWnd:hWnd )
         ::Create()
         ::oWnd:AddControl( Self )
      else
         ::oWnd:DefControl( Self )
      endif

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al crear mesas" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----Rtrim( ::oSender:oDetSalaVta:oDbf::cDescrip------------------------------------------------------------------------//
//
// oSender -> TTPvPunto
//

METHOD LoadFromPunto( oSender ) CLASS TTpvMesa

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oSender      := oSender

      ::nEstado      := oSender:nEstado

      ::nUbicacion   := oSender:nUbicacion

      ::nTotal       := oSender:nTotal
      ::lMultiple    := oSender:lMultiple

      ::cPuntoVenta  := Rtrim( oSender:cPuntoVenta )

      ::cAlias       := Rtrim( oSender:cAlias )
      ::cNombre      := Rtrim( oSender:cNombre )

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al cargar desde punto" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//
//
// oSender -> TTpvSala
//

METHOD LoadFromSala( oSender ) CLASS TTpvMesa

   local oBlock
   local oError

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::oSender      := oSender

      ::cPuntoVenta  := Rtrim( oSender:oDetSalaVta:oDbfVir:cDescrip )

      ::lDesign      := .t.
      ::nUbicacion   := ubiSala

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Error al cargar desde sala" )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( Self )

//----------------------------------------------------------------------------//

Method cBitmapMesa( nItem ) CLASS TTpvMesa

   do case
      case nItem == itmMesaRedonda
         Return ( "Shape_circle_80" )

      case nItem == itmMesaEliptica
         Return ( "Shape_ellipse_80" )

      case nItem == itmMesaCuadrada
         Return ( "Shape_square_80" )

      case nItem == itmMesaRectangular
         Return ( "Shape_rectangle_80" )

      case nItem == itmBarrraHorizontal
         Return ( "Bar_center_64" )

      case nItem == itmBarrraVertical
         Return ( "Bar_left_64" )

      case nItem == itmBarrraEsquinaDerechaAbajo
         Return ( "Bar_corner_left_64" )

      case nItem == itmBarrraEsquinaIzquierdaAbajo
         Return ( "Bar_corner_right_64" )

      case nItem == itmBarrraEsquinaDerechaArriba
         Return ( "Bar_corner_top_left_64" )

      case nItem == itmBarrraEsquinaIzquierdaArriba
         Return ( "Bar_corner_top_right_64" )

      case nItem == itmPlantaBlanca
         Return( "Flower_white_32" )

      case nItem == itmPlantaAzul
         Return( "Flower_blue_32" )

      case nItem == itmPlantaAmarilla
         Return( "Flower_yellow_32" )

      case nItem == itmPlantaRoja
         Return( "Flower_red_32" )

      case nItem == itmPanelHorizontal
         Return( "Navigate2_minus_64" )

      case nItem == itmPanelVertical
         Return( "Navigate_panel_64" )

      case nItem == itmPanelCruce
         Return( "Navigate2_plus_64" )

      case nItem == itmPanelConexionArriba
         Return( "Navigate_connection_up_64" )

      case nItem == itmPanelConexionAbajo
         Return( "Navigate_connection_down_64" )

      case nItem == itmPanelCurvaAbajo
         Return( "Navigate_corner_left_64" )

      case nItem == itmPanelCurvaArriba
         Return( "Navigate_corner_right_top_64" )

      case nItem == itmPanelCurvaDerecha
         Return( "Navigate_corner_right_64" )

      case nItem == itmPanelCurvaIzquierda
         Return( "Navigate_corner_right_down_64" )

      case nItem == itmPanelConexionDerecha
         Return( "Navigate_right_64"  )

      case nItem == itmPanelConexionIzquierda
         Return( "Navigate_left_64" )

      case nItem == itmGenerico
         Return( "gc_cash_register_160" )

      case nItem == itmLlevar
         Return( "gc_motor_scooter_160" )

      case nItem == itmNewGenerico
         Return( "gc_cash_register_160" )

      case nItem == itmNewLlevar
         Return( "gc_motor_scooter_160" )

      case nItem == itmEncargar
         Return( "gc_notebook2_160" )

      case nItem == itmRecoger
         Return( "gc_shopping_basket_160" )

   end case

Return ( "" )

//----------------------------------------------------------------------------//

METHOD LButtonUp( nRow, nCol, nKeyFlags ) CLASS TTpvMesa

   if ::lDesign
      Return ( Self )
   end if 
   
   if ::lSeleccionable()
      ::oSender:GetSalon():SelectPunto( ::oSender )
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD RButtonDown( nRow, nCol, nKeyFlags ) CLASS TTpvMesa

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

      if IsChar( ::cPuntoVenta )
         MenuAddItem( "Cambiar nombre", "Cambiar nombre a la mesa", .f., .t., {|| ::Rename() }, , "gc_text_field_16", oMenu )
      end if

      MenuAddItem( "&Eliminar", "Eliminar mesa del salón", .f., .t., {|| ::End() }, , "Del16", oMenu )

      MenuEnd()

      oMenu:Activate( aPoint[ 1 ], aPoint[ 2 ], Self )

      ::bMenuSelect     := bMenuSelect

      oMenu:end()

   else

      if !::oSender:lMultiple
         ::uCreaToolTip( nRow, nCol, nKeyFlags )
      end if

   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD uCreaToolTip( nRow, nCol, nKeyFlags )

   local oBmp
   local oDlgToolTip
   local oBrwLinToolTip
   local aLineasToolTip

   aLineasToolTip    := ::aCargaLineasToolTip()

   if !hb_isarray( aLineasToolTip ) .or. ( len( aLineasToolTip ) == 0 )
      RETURN .f.
   end if 

   DEFINE DIALOG oDlgToolTip RESOURCE "ToolTipSala"

      REDEFINE BITMAP oBmp ;
         ID          500 ;
         RESOURCE    "gc_notebook2_48" ;
         TRANSPARENT ;
         OF          oDlgToolTip

      oBrwLinToolTip                        := IXBrowse():New( oDlgToolTip )

      oBrwLinToolTip:bClrSel                := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrwLinToolTip:bClrSelFocus           := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrwLinToolTip:SetArray( aLineasToolTip, , , .f. )

      oBrwLinToolTip:lFooter                := .t.
      oBrwLinToolTip:lHScroll               := .f.
      oBrwLinToolTip:nMarqueeStyle          := 5
      oBrwLinToolTip:cName                  := "Tooltip mesas"
      oBrwLinToolTip:oFont                  := ::oSender:oSender:oSender:oSender:oFntBrw
      oBrwLinToolTip:lRecordSelector        := .f.

      with object ( oBrwLinToolTip:AddCol() )
         :cHeader             := "Und"
         :nWidth              := 50
         :bEditValue          := {|| oBrwLinToolTip:aArrayData[ oBrwLinToolTip:nArrayAt ]:nUnidades }
         :cEditPicture        := MasUnd()
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
      end with

      with object ( oBrwLinToolTip:AddCol() )
         :cHeader             := "Nombre"
         :nWidth              := 200
         :bStrData            := {|| oBrwLinToolTip:aArrayData[ oBrwLinToolTip:nArrayAt ]:cNomArt }
      end with

      with object ( oBrwLinToolTip:AddCol() )
         :cHeader             := "Total"
         :nWidth              := 62
         :bEditValue          := {|| Trans( oBrwLinToolTip:aArrayData[ oBrwLinToolTip:nArrayAt ]:nImporte, ::oSender:oSender:oSender:oSender:cPictureImporte ) }
         :bFooter             := {|| Trans( ::nTotLinToolTip( aLineasToolTip ), ::oSender:oSender:oSender:oSender:cPictureImporte ) }
         :nDataStrAlign       := AL_RIGHT
         :nHeadStrAlign       := AL_RIGHT
         :nFootStrAlign       := AL_RIGHT
      end with

      oBrwLinToolTip:CreateFromResource( 100 )

      REDEFINE BUTTONBMP BITMAP "gc_arrow_up_32" ID 120 OF oDlgToolTip ACTION ( oBrwLinToolTip:GoUp() )

      REDEFINE BUTTONBMP BITMAP "gc_arrow_down_32" ID 130 OF oDlgToolTip ACTION ( oBrwLinToolTip:GoDown() )

      REDEFINE BUTTONBMP BITMAP "gc_check_32" ID IDOK OF oDlgToolTip ACTION ( oDlgToolTip:End( IDOK ), ::LButtonUp( nRow, nCol, nKeyFlags ) )

      REDEFINE BUTTONBMP BITMAP "delete_32" ID IDCANCEL OF oDlgToolTip ACTION ( oDlgToolTip:End() )

      oDlgToolTip:bStart      := {|| oBrwLinToolTip:Load() }

   ACTIVATE DIALOG oDlgToolTip

   oBrwLinToolTip:CloseData()

   if !Empty( oBmp )
      oBmp:End()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD aCargaLineasToolTip()

   local aLineas  := {}
   local oParent  := ::oSender:oSender:oSender:oSender
   local nRec     := oParent:oTiketLinea:Recno()
   local nOrdAnt  := oParent:oTiketLinea:OrdSetFocus( "CNUMTIL" )
   local oLineas

   if oParent:oTiketLinea:Seek( ::oSender:cSerie + ::oSender:cNumero + ::oSender:cSufijo )

      while oParent:oTiketLinea:cSerTil + oParent:oTiketLinea:cNumTil + oParent:oTiketLinea:cSufTil == ::oSender:cSerie + ::oSender:cNumero + ::oSender:cSufijo .and. !oParent:oTiketLinea:Eof()

         if !oParent:oTiketLinea:lKitChl

            oLineas                     := SValorLineas()
            oLineas:cNomArt             := oParent:oTiketLinea:cNomTil
            oLineas:nUnidades           := oParent:oTiketLinea:nUntTil
            oLineas:nImporte            := oParent:nTotalLinea( oParent:oTiketLinea )

            aAdd( aLineas, oLineas )

         end if

         oParent:oTiketLinea:Skip()

      end while

   end if

   oParent:oTiketLinea:OrdSetFocus( nOrdAnt )
   oParent:oTiketLinea:GoTo( nRec )

return aLineas

//---------------------------------------------------------------------------//

METHOD nTotLinToolTip( aLineasToolTip )

   local nTotal      := 0
   local aLinToolTip

   for each aLinToolTip in aLineasToolTip
       nTotal              += aLinToolTip:nImporte
   next

Return nTotal

//---------------------------------------------------------------------------//

METHOD lSeleccionable() CLASS TTpvMesa

   if ::nType == itmMesaRedonda                    .or.;
      ::nType == itmMesaEliptica                   .or.;
      ::nType == itmMesaCuadrada                   .or.;
      ::nType == itmMesaRectangular                .or.;
      ::nType == itmBarrraHorizontal               .or.;
      ::nType == itmBarrraVertical                 .or.;
      ::nType == itmBarrraEsquinaDerechaAbajo      .or.;
      ::nType == itmBarrraEsquinaIzquierdaAbajo    .or.;
      ::nType == itmBarrraEsquinaDerechaArriba     .or.;
      ::nType == itmBarrraEsquinaIzquierdaArriba   .or.;
      ::nType == itmGenerico                       .or.;
      ::nType == itmLlevar                         .or.;
      ::nType == itmRecoger                        .or.;
      ::nType == itmEncargar                       .or.;
      ::nType == itmNewGenerico                    .or.;
      ::nType == itmNewLlevar

      return .t.

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD LoadBitmap() CLASS TTpvMesa

   if !Empty( ::hBmp )
      DeleteObject( ::hBmp )
   end if

   if !Empty( ::cBitmap )

      /*
      aBmpPal        := PalBmpLoad( ::cBitmap )
      ::hBmp         := aBmpPal[ 1 ]
      ::hPalette     := aBmpPal[ 2 ]
      */

      ::hBmp            := LoadBitmap( GetResources(), ::cBitmap )
      if ::hBmp != 0
         ::nBmpWidth    := nBmpWidth( ::hBmp )
         ::nBmpHeight   := nBmpHeight( ::hBmp )
      end if

   end if

   sysrefresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD DeleteBitmap() CLASS TTpvMesa

   if !Empty( ::hBmp )
      DeleteObject( ::hBmp )
   end if

   ::hBmp               := 0

Return ( Self )

//---------------------------------------------------------------------------//

METHOD HandleEvent( nMsg, nWParam, nLParam ) CLASS TTpvMesa

   do case
      case nMsg == 0x00A4 // WM_NCRBUTTONDOWN
         return ::RButtonDown( nHiWord( nLParam ), nLoWord( nLParam ), nWParam )

      case nMsg == 0x00A3 // Doble click
         return 0

      case nMsg == WM_NCHITTEST .and. ::lDesign
         // ::Refresh()
         return HTCAPTION
         //return DefWindowProc( ::hWnd, nMsg, nWParam, nLParam )

         /*
         */

      case nMsg == WM_ERASEBKGND
         return 1

   end case

Return ( ::Super:HandleEvent( nMsg, nWParam, nLParam ) )

//---------------------------------------------------------------------------//

METHOD Rename() CLASS TTpvMesa

   local cPuntoVenta := Padr( ::cPuntoVenta, 100 )

   cPuntoVenta       := VirtualKey( .f., cPuntoVenta, "Nombre de la mesa" )

   if !Empty( cPuntoVenta )
      ::cPuntoVenta  := cPuntoVenta
      ::Refresh()
   end if

Return ( ::cPuntoVenta )

//---------------------------------------------------------------------------//

METHOD Paint() CLASS TTpvMesa

   local hFont
   local nMode
   local nColor
   local nOldClr
   local hBmpOld
   local aBitmap
   local nBmpLeft       := 0
   local nBmpTop        := 0
   local nRowText       := 0
   local nRowTotal      := 0

   fillSolidRect( ::hDC, GetClientRect( ::hWnd ), ::nClrPane )

   if Empty( ::hBmp )
      ::LoadBitmap()
   end if

   if ( ::nUbicacion == ubiSala )
      nRowText          := ( ( ::nBmpHeight - 16 ) / 2 ) - 12
      nRowTotal         := ( ( ::nBmpHeight - 16 ) / 2 ) + 12
   else
      nRowText          := ( ::nBmpHeight - 30 )
      nRowTotal         := ( ::nBmpHeight - 14 )
   end if

   if IsWindowEnabled( ::hWnd )

      // Bitmap de la mesa--------------------------------------------------

      nOldClr           := SetBkColor( ::hDC, Rgb( 255, 0, 255 ) )
      TransparentBlt( ::hDC, ::hBmp, nBmpLeft, nBmpTop, ::nBmpWidth, ::nBmpHeight, )
      SetBkColor( ::hDC, nOldClr )

      // Bitmap del estado--------------------------------------------------

      aBitmap           := ::aBitmapState()
      if !Empty( aBitmap )
         TransparentBlt( ::hDC, aBitmap[ BITMAP_HANDLE ], ( ::nBmpWidth - 16 ) / 2, ( ::nBmpHeight - 16 ) / 2, aBitmap[ BITMAP_WIDTH ], aBitmap[ BITMAP_HEIGHT ] )
      end if

   else

      DrawGray( ::hDC, ::hBmp, 0, 0 )

   endif

   ::DeleteBitmap()

   // Texto--------------------------------------------------------------------

   hFont                := SelectObject( ::hDC, ::oFont:hFont )
   nColor               := SetTextColor( ::hDC, Rgb( 0, 0, 0 ) )
   nMode                := SetBkMode( ::hDC, 1 )

   // Nombre de la mesa--------------------------------------------------------

   if !Empty( ::cPuntoVenta ) .and. ( ::nUbicacion == ubiSala )
      DrawText( ::hDC, Rtrim( ::cPuntoVenta ), { nRowText, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )
   end if

   // Alias de la ubicacion----------------------------------------------------

   if !Empty( ::cAlias ) .and. ( ::nUbicacion == ubiGeneral )
      DrawText( ::hDC, Rtrim( ::cAlias ), { nRowText, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )
   end if

   // Alias de la ubicacion----------------------------------------------------

   if !Empty( ::cAlias ) .and. ( ::nUbicacion == ubiRecoger )
      DrawText( ::hDC, Rtrim( ::cAlias ), { nRowText, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )
   end if

   // Cliente para llevar------------------------------------------------------

   if !Empty( ::cNombre ) .and. ( ::nUbicacion == ubiLlevar )
      DrawText( ::hDC, Rtrim( ::cNombre ), { nRowText, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )
   end if

   // Cliente encargar------------------------------------------------------

   if !Empty( ::cNombre ) .and. ( ::nUbicacion == ubiEncargar )
      DrawText( ::hDC, Rtrim( ::cNombre ), { nRowText, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )
   end if

   // Total de la mesa---------------------------------------------------------

   if !Empty( ::nTotal )

      if ::lMultiple
         DrawText( ::hDC, "[" + Alltrim( Trans( ::nTotal, cPorDiv() ) ) + cSimDiv() + "]", { nRowTotal, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )
      else
         DrawText( ::hDC, Alltrim( Trans( ::nTotal, cPorDiv() ) ) + cSimDiv(), { nRowTotal, 0, ::nBmpHeight, ::nBmpWidth }, nOR( DT_CENTER, DT_WORDBREAK, DT_WORD_ELLIPSIS, DT_TOP ) )   
      end if

   end if

   SetBkMode   ( ::hDC, nMode    )
   SetTextColor( ::hDC, nColor   )
   SelectObject( ::hDC, hFont    )

Return 0

//---------------------------------------------------------------------------//

Method aBitmapState()

   local aBitmapState

   if IsNum( ::nEstado ) .and. !Empty( ::cPuntoVenta )

      if ::nEstado > 0 .and. ::nEstado <= len( ::oSender:GetSalon():aBitmapsState )
         aBitmapState   := ::oSender:GetSalon():aBitmapsState[ ::nEstado ]
      end if

   end if

Return ( aBitmapState )

//---------------------------------------------------------------------------//

CLASS SValorLineas

   DATA cNomArt
   DATA nUnidades
   DATA nImporte

END CLASS

//---------------------------------------------------------------------------//

#pragma BEGINDUMP

#include "windows.h"
#include "hbapi.h"

// TransparentBlt( hDC, hBmp, nTop, nLeft, nWidth, nHeight )

HB_FUNC( TRANSPARENTBLT )
{
    HDC hDC = (HDC) hb_parnl( 1 );
    HBITMAP hBmp = (HBITMAP) hb_parnl( 2 );
    HBITMAP hOldBmp ;

    HDC hDC0 = CreateDC( "DISPLAY", NULL, NULL, NULL);
    HDC hDCMem = CreateCompatibleDC(hDC0);

    BITMAP bm;
    GetObject( ( HGDIOBJ ) hBmp, sizeof( BITMAP ), ( LPSTR ) &bm );

    hOldBmp = (HBITMAP) SelectObject( hDCMem, hBmp );

    hb_retl( TransparentBlt( hDC, hb_parni( 3 ), hb_parni( 4 ), hb_parni( 5 ), hb_parni( 6 ), hDCMem, 0, 0, bm.bmWidth, bm.bmHeight, (UINT) GetPixel(hDCMem,0,0) ));

    SelectObject( hDCMem, hOldBmp );
    DeleteDC( hDCMem );
    DeleteDC( hDC0 );

}

#pragma ENDDUMP