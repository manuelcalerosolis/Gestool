#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oSQLBrowseView

   METHOD New()

   METHOD Dialog()
   METHOD startDialog( oRadioTipoMovimento, oGetAlmacenOrigen )

   METHOD stampAlmacenNombre( oGetAlmacenOrigen )

   METHOD stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   METHOD changeTipoMovimiento( oRadioTipoMovimento, oGetAlmacenOrigen )

   METHOD stampAgente( oGetAgente )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController     := oController

   ::cImageName      := "gc_bookmarks_16"

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog()

   local oDlg
   local oBtn
   local oGetDivisa
   local oGetAgente
   local oBmpDivisa
   local oBmpGeneral
   local oGetDivisaCambio
   local oGetAlmacenOrigen
   local oGetAlmacenDestino
   local oGetGrupoMovimiento
   local oRadioTipoMovimento

   DEFINE DIALOG oDlg RESOURCE "RemMov" TITLE ::lblTitle() + "movimientos de almacén"

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
         PICTURE     "XXX" ;
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

      oGetAlmacenOrigen:bValid   := {|| if( ::oController:validate( "almacen_origen" ), ::stampAlmacenNombre( oGetAlmacenOrigen ), .f. ) }
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

      oGetAlmacenDestino:bValid   := {|| if( ::oController:validate( "almacen_destino" ), ::stampAlmacenNombre( oGetAlmacenDestino ), .f. ) }
      oGetAlmacenDestino:bHelp    := {|| brwAlmacen( oGetAlmacenDestino, oGetAlmacenDestino:oHelpText ) }

      REDEFINE GET   oGetGrupoMovimiento ;
         VAR         ::oController:oModel:hBuffer[ "grupo_movimiento" ] ;
         ID          140 ;
         IDHELP      141 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      oGetGrupoMovimiento:bValid   := {|| if( ::oController:validate( "grupo_movimiento" ), ::stampGrupoMovimientoNombre( oGetGrupoMovimiento ), .f. ) }
      oGetGrupoMovimiento:bHelp    := {|| browseGruposMovimientos( oGetGrupoMovimiento, oGetGrupoMovimiento:oHelpText ) }

      REDEFINE GET   oGetAgente ;
         VAR         ::oController:oModel:hBuffer[ "agente" ] ;
         ID          210 ;
         IDHELP      211 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          oDlg

      oGetAgente:bValid := {|| if( ::oController:validate( "agente" ), ::stampAgente( oGetAgente ), .f. ) }
      oGetAgente:bHelp  := {|| BrwAgentes( oGetAgente, oGetAgente:oHelpText ) }

      // Divisas-------------------------------------------------------

      DivisasView();
         :New( ::oController );
         :CreateEditControl( { "idGet" => 190, "idBmp" => 191, "idValue" => 192, "dialog" => oDlg } )

      // Comentarios-------------------------------------------------------

      REDEFINE GET   ::oController:oModel:hBuffer[ "comentarios" ] ;
         ID          170 ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          oDlg

      // Buttons lineas-------------------------------------------------------

      REDEFINE BUTTON ;
         ID          500 ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Append(), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON ;
         ID          501 ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Edit(), ::oSQLBrowseView:Refresh() )

      REDEFINE BUTTON ;
         ID          502 ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Delete( ::oSQLBrowseView:getBrowseSelected() ), ::oSQLBrowseView:Refresh() )

      // Browse lineas--------------------------------------------------------- 

      ::oSQLBrowseView              := SQLBrowseView():New( Self )

      ::oSQLBrowseView:setController( ::oController:oLineasController )

      ::oSQLBrowseView:ActivateDialog( 180, oDlg )

      // Buttons---------------------------------------------------------------

      REDEFINE BUTTON oBtn ;
         ID          IDOK ;
         OF          oDlg ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:End() )

      REDEFINE BUTTON ;
         ID          3 ;
         OF          oDlg ;
         ACTION      ( msgalert( "RecalculaPrecio" ) )

      if ::oController:isNotZoomMode()
         oDlg:AddFastKey( VK_F5, {|| oBtn:Click() } )
      end if

      oDlg:bStart    := {|| ::startDialog( oRadioTipoMovimento, oGetAlmacenOrigen, oGetAlmacenDestino, oGetGrupoMovimiento, oGetAgente ) }

   oDlg:Activate( , , , .t. ) 

   oBmpGeneral:End()

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog( oRadioTipoMovimento, oGetAlmacenOrigen, oGetAlmacenDestino, oGetGrupoMovimiento, oGetAgente )
   
   ::changeTipoMovimiento( oRadioTipoMovimento, oGetAlmacenOrigen )

   ::stampAlmacenNombre( oGetAlmacenOrigen )

   ::stampAlmacenNombre( oGetAlmacenDestino )

   ::stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   ::stampAgente( oGetAgente )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD stampAlmacenNombre( oGetAlmacenOrigen )

   local cCodigoAlmacen    := oGetAlmacenOrigen:varGet()
   local cNombreAlmacen    := AlmacenesModel():getNombre( cCodigoAlmacen )

   oGetAlmacenOrigen:oHelpText:cText( cNombreAlmacen )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampGrupoMovimientoNombre( oGetGrupoMovimiento )

   local cCodigoGrupo      := oGetGrupoMovimiento:varGet()
   local cNombreGrupo      := GruposMovimientosModel():getNombre( cCodigoGrupo )

   oGetGrupoMovimiento:oHelpText:cText( cNombreGrupo )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD stampAgente( oGetAgente )

   local cCodigoAgente     := oGetAgente:varGet()
   local cNombreAgente     := AgentesModel():getNombre( cCodigoAgente )

   oGetAgente:oHelpText:cText( cNombreAgente )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeTipoMovimiento( oRadioTipoMovimento, oGetAlmacenOrigen )

   if oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__
      oGetAlmacenOrigen:Show()
   else
      oGetAlmacenOrigen:Hide()
   end if                                         

RETURN ( .t. )

//---------------------------------------------------------------------------//
