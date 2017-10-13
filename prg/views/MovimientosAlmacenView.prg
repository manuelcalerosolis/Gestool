#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oSQLBrowseView

   DATA oDlg
   DATA oGetDivisa
   DATA oGetAgente
   DATA oGetAlmacenOrigen
   DATA oGetAlmacenDestino
   DATA oGetGrupoMovimiento
   DATA oRadioTipoMovimento

   METHOD New()

   METHOD Dialog()
   METHOD startDialog()

   METHOD changeTipoMovimiento()    INLINE   (  iif(  ::oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__,;
                                                      ::oGetAlmacenOrigen:Show(),;
                                                      ::oGetAlmacenOrigen:Hide() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oBtn
   local oBmpGeneral

   DEFINE DIALOG ::oDlg RESOURCE "RemMov" TITLE ::lblTitle() + "movimientos de almacén"

      REDEFINE BITMAP oBmpGeneral ;
        ID           990 ;
        RESOURCE     "gc_package_pencil_48" ;
        TRANSPARENT ;
        OF           ::oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "numero" ] ;
         ID          100 ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "delegacion" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
         ID          120 ;
         PICTURE     "@DT" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "usuario" ] ;
         ID          220 ;
         PICTURE     "XXX" ;
         WHEN        ( .f. ) ;
         OF          ::oDlg

      REDEFINE RADIO ::oRadioTipoMovimento ;
         VAR         ::oController:oModel:hBuffer[ "tipo_movimiento" ] ;
         ID          130, 131, 132, 133 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ON CHANGE   ( ::changeTipoMovimiento() ) ;
         OF          ::oDlg

      REDEFINE GET   ::oGetAlmacenOrigen ;
         VAR         ::oController:oModel:hBuffer[ "almacen_origen" ] ;
         ID          150 ;
         IDHELP      151 ;
         IDSAY       152 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDlg

      ::oGetAlmacenOrigen:bValid   := {|| ::oController:validateAlmacenOrigen() }
      ::oGetAlmacenOrigen:bHelp    := {|| brwAlmacen( ::oGetAlmacenOrigen, ::oGetAlmacenOrigen:oHelpText ) }

      REDEFINE GET   ::oGetAlmacenDestino ;
         VAR         ::oController:oModel:hBuffer[ "almacen_destino" ] ;
         ID          160 ;
         IDHELP      161 ;
         IDSAY       162 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDlg

      ::oGetAlmacenDestino:bValid   := {|| ::oController:validateAlmacenDestino() }
      ::oGetAlmacenDestino:bHelp    := {|| brwAlmacen( ::oGetAlmacenDestino, ::oGetAlmacenDestino:oHelpText ) }

      REDEFINE GET   ::oGetGrupoMovimiento ;
         VAR         ::oController:oModel:hBuffer[ "grupo_movimiento" ] ;
         ID          140 ;
         IDHELP      141 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDlg

      ::oGetGrupoMovimiento:bValid   := {|| ::oController:validateGrupoMovimiento() }
      ::oGetGrupoMovimiento:bHelp    := {|| browseGruposMovimientos( ::oGetGrupoMovimiento, ::oGetGrupoMovimiento:oHelpText ) }

      REDEFINE GET   ::oGetAgente ;
         VAR         ::oController:oModel:hBuffer[ "agente" ] ;
         ID          210 ;
         IDHELP      211 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDlg

      ::oGetAgente:bValid := {|| ::oController:validateAgente() }
      ::oGetAgente:bHelp  := {|| BrwAgentes( ::oGetAgente, ::oGetAgente:oHelpText ) }

      // Divisas-------------------------------------------------------

      DivisasView();
         :New( ::oController );
         :CreateEditControl( { "idGet" => 190, "idBmp" => 191, "idValue" => 192, "dialog" => ::oDlg } )

      // Comentarios-------------------------------------------------------

      REDEFINE GET   ::oController:oModel:hBuffer[ "comentarios" ] ;
         ID          170 ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDlg

      // Buttons lineas-------------------------------------------------------

      REDEFINE BUTTON ;
         ID          500 ;
         OF          ::oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Append(), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON ;
         ID          501 ;
         OF          ::oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Edit(), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON ;
         ID          502 ;
         OF          ::oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Delete( ::oSQLBrowseView:getBrowseSelected() ), ::oSQLBrowseView:Refresh() )

      // Browse lineas--------------------------------------------------------- 

      ::oSQLBrowseView              := SQLBrowseViewDialog():New( Self )

      ::oSQLBrowseView:setController( ::oController:oLineasController )

      ::oSQLBrowseView:Activate( 180, ::oDlg )

      // Buttons---------------------------------------------------------------

      REDEFINE BUTTON oBtn ;
         ID          IDOK ;
         OF          ::oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( if( validateDialog( ::oDlg ), ::oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          ::oDlg ;
         CANCEL ;
         ACTION      ( ::oDlg:End() )

      REDEFINE BUTTON ;
         ID          3 ;
         OF          ::oDlg ;
         ACTION      ( msgalert( "RecalculaPrecio" ) )

      if ::oController:isNotZoomMode()
         ::oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )
      end if

      ::oDlg:bStart    := {|| ::startDialog() }

   ::oDlg:Activate( , , , .t. ) 

   oBmpGeneral:End()

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog()
   
   ::changeTipoMovimiento()

   ::oController:stampAlmacenNombre( ::oGetAlmacenOrigen )

   ::oController:stampAlmacenNombre( ::oGetAlmacenDestino )

   ::oController:stampGrupoMovimientoNombre( ::oGetGrupoMovimiento )

   ::oController:stampAgente( ::oGetAgente )

RETURN ( Self )

//---------------------------------------------------------------------------//
