#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   METHOD   New()

   METHOD   Dialog()

   METHOD   stampAlmacenNombre( oGetAlmacenOrigen )

   METHOD   stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   METHOD   changeTipoMovimiento( oRadioTipoMovimento, oGetAlmacenOrigen )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBmpGeneral
   local oGetGrupoMovimiento
   local oGetAlmacenOrigen
   local oGetAlmacenDestino
   local oRadioTipoMovimento

   DEFINE DIALOG oDlg RESOURCE "RemMov" TITLE ::lblTitle() + "movimientos de almac�n"

      REDEFINE BITMAP oBmpGeneral ;
        ID           990 ;
        RESOURCE     "gc_package_pencil_48" ;
        TRANSPARENT ;
        OF           oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "numero" ] ;
         ID          100 ;
         WHEN        ( .f. ) ;
         OF          oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "delegacion" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
         ID          120 ;
         PICTURE     "@DT" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "usuario" ] ;
         ID          220 ;
         WHEN        ( .f. ) ;
         OF          oDlg

      REDEFINE RADIO oRadioTipoMovimento ;
         VAR         ::oController:oModel:hBuffer[ "tipo_movimiento" ] ;
         ID          130, 131, 132, 133 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ON CHANGE   ( ::changeTipoMovimiento( oRadioTipoMovimento, oGetAlmacenOrigen ) ) ;
         OF          oDlg

      REDEFINE GET   oGetAlmacenOrigen ;
         VAR         ::oController:oModel:hBuffer[ "almacen_origen" ] ;
         ID          150 ;
         IDHELP      151 ;
         IDSAY       152 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      oGetAlmacenOrigen:bValid   := {|| ::stampAlmacenNombre( oGetAlmacenOrigen ) }
      oGetAlmacenOrigen:bHelp    := {|| brwAlmacen( oGetAlmacenOrigen, oGetAlmacenOrigen:oHelpText ) }

      REDEFINE GET   oGetAlmacenDestino ;
         VAR         ::oController:oModel:hBuffer[ "almacen_destino" ] ;
         ID          160 ;
         IDHELP      161 ;
         IDSAY       162 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      oGetAlmacenDestino:bValid   := {|| ::stampAlmacenNombre( oGetAlmacenDestino ) }
      oGetAlmacenDestino:bHelp    := {|| brwAlmacen( oGetAlmacenDestino, oGetAlmacenDestino:oHelpText ) }

      REDEFINE GET   oGetGrupoMovimiento ;
         VAR         ::oController:oModel:hBuffer[ "grupo_movimiento" ] ;
         ID          140 ;
         IDHELP      141 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      oGetGrupoMovimiento:bValid   := {|| ::stampGrupoMovimientoNombre( oGetGrupoMovimiento ) }
      oGetGrupoMovimiento:bHelp    := {|| browseGruposMovimientos( oGetGrupoMovimiento, oGetGrupoMovimiento:oHelpText ) }

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( oDlg:end( IDOK ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:End() )

      REDEFINE BUTTON ;
         ID          3 ;
         OF          oDlg ;
         ACTION      ( msgalert( "RecalculaPrecio" ) )

   ACTIVATE DIALOG oDlg CENTER

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD stampAlmacenNombre( oGetAlmacenOrigen )

   local cCodigoAlmacen    := oGetAlmacenOrigen:varGet()
   local cNombreAlmacen    := AlmacenesModel():getNombre( cCodigoAlmacen )

   oGetAlmacenOrigen:oHelpText:cText( cNombreAlmacen )

RETURN ( !empty( cNombreAlmacen ) )

//---------------------------------------------------------------------------//

METHOD stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   local cCodigoGrupo      := oGetGrupoMovimiento:varGet()
   local cNombreGrupo      := GruposMovimientosModel():getNombre( cCodigoGrupo )

   oGetGrupoMovimiento:oHelpText:cText( cNombreGrupo )

RETURN ( !empty( cNombreGrupo ) )

//---------------------------------------------------------------------------//

METHOD changeTipoMovimiento( oRadioTipoMovimento, oGetAlmacenOrigen )

   if oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__
      oGetAlmacenOrigen:Show()
   else
      oGetAlmacenOrigen:Hide()
   end if                                         

RETURN ( .t. )

//---------------------------------------------------------------------------//
