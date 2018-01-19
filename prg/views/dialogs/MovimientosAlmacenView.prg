#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oOfficeBar

   DATA oSQLBrowseView

   DATA oGetDivisa
   DATA oGetAgente
   DATA oGetAlmacenOrigen
   DATA oGetAlmacenDestino
   DATA oGetGrupoMovimiento
   DATA oRadioTipoMovimento

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate()

   METHOD changeTipoMovimiento()    INLINE   (  iif(  ::oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__,;
                                                      ::oGetAlmacenOrigen:Show(),;
                                                      ::oGetAlmacenOrigen:Hide() ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "MOVIMIENTOS_ALMACEN" TITLE ::lblTitle() + ::oController:getTitle()

      REDEFINE GET   ::oController:oModel:hBuffer[ "numero" ] ;
         ID          100 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "delegacion" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
         ID          120 ;
         PICTURE     "@DT" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "usuario" ] ;
         ID          220 ;
         PICTURE     "XXX" ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE RADIO ::oRadioTipoMovimento ;
         VAR         ::oController:oModel:hBuffer[ "tipo_movimiento" ] ;
         ID          130, 131, 132, 133 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ON CHANGE   ( ::changeTipoMovimiento() ) ;
         OF          ::oDialog

      REDEFINE GET   ::oGetAlmacenOrigen ;
         VAR         ::oController:oModel:hBuffer[ "almacen_origen" ] ;
         ID          150 ;
         IDHELP      151 ;
         IDSAY       152 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

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
         OF          ::oDialog

      ::oGetAlmacenDestino:bValid   := {|| ::oController:validateAlmacenDestino() }
      ::oGetAlmacenDestino:bHelp    := {|| brwAlmacen( ::oGetAlmacenDestino, ::oGetAlmacenDestino:oHelpText ) }

      REDEFINE GET   ::oGetGrupoMovimiento ;
         VAR         ::oController:oModel:hBuffer[ "grupo_movimiento" ] ;
         ID          140 ;
         IDHELP      141 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetGrupoMovimiento:bValid   := {|| ::oController:validateGrupoMovimiento() }
      ::oGetGrupoMovimiento:bHelp    := {|| browseGruposMovimientos( ::oGetGrupoMovimiento, ::oGetGrupoMovimiento:oHelpText ) }

      REDEFINE GET   ::oGetAgente ;
         VAR         ::oController:oModel:hBuffer[ "agente" ] ;
         ID          210 ;
         IDHELP      211 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "Lupa" ;
         OF          ::oDialog

      ::oGetAgente:bValid := {|| ::oController:validateAgente() }
      ::oGetAgente:bHelp  := {|| BrwAgentes( ::oGetAgente, ::oGetAgente:oHelpText ) }

      // Divisas---------------------------------------------------------------

      DivisasView();
         :New( ::oController );
         :CreateEditControl( { "idGet" => 190, "idBmp" => 191, "idValue" => 192, "dialog" => ::oDialog } )

      // Comentarios-----------------------------------------------------------

      REDEFINE GET   ::oController:oModel:hBuffer[ "comentarios" ] ;
         ID          170 ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      // Buttons lineas-------------------------------------------------------

      ::oController:oLineasController:Activate( ::oDialog, 180 )

      /*
      ::oSQLBrowseView              := SQLBrowseView():New( Self )
      ::oSQLBrowseView:setFooter( .t. )

      ::oSQLBrowseView:setController( ::oController:oLineasController )

      ::oSQLBrowseView:ActivateDialog( 180, ::oDialog )

      ::oSQLBrowseView:setView()
      */

      // Dialog activate-------------------------------------------------------

      ::oDialog:bStart    := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } ) 

   ::oOfficeBar:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()
   
   ::changeTipoMovimiento()

   ::oController:stampAlmacenNombre( ::oGetAlmacenOrigen )

   ::oController:stampAlmacenNombre( ::oGetAlmacenDestino )

   ::oController:stampGrupoMovimientoNombre( ::oGetGrupoMovimiento )

   ::oController:stampAgente( ::oGetAgente )

   ::oController:oLineasController:oBrowseView:getBrowse():makeTotals()
   ::oController:oLineasController:oBrowseView:getBrowse():goTop()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   
   ::oOfficeBar   := OfficeBarView():New( Self )

   ::oOfficeBar:createButtonImage()

   ::oOfficeBar:createButtonsLine( ::oController:oLineasController, ::oSQLBrowseView )

   oGrupo         := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 126, "Otros", .f. )
   
   TDotNetButton():New( 60, oGrupo, "gc_hand_truck_box_32", "Importar almacén",     1, {|| ::oController:oImportadorController:Activate() }, , , .f., .f., .f. )
   TDotNetButton():New( 60, oGrupo, "gc_pda_32",            "Importar inventario",  2, {|| ::oController:oCapturadorController:Activate() }, , , .f., .f., .f. )

   ::oOfficeBar:createButtonsDialog()

RETURN ( Self )

//---------------------------------------------------------------------------//
