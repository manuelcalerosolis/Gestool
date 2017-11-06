#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oDialog

   DATA oOfficeBar

   DATA oBtnOk
   DATA oBtnEdit
   DATA oBtnAppend
   DATA oBtnDelete

   DATA oSQLBrowseView

   DATA oGetDivisa
   DATA oGetAgente
   DATA oGetAlmacenOrigen
   DATA oGetAlmacenDestino
   DATA oGetGrupoMovimiento
   DATA oRadioTipoMovimento

   METHOD New()

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate()

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

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "Movimientos_Almacen" TITLE ::lblTitle() + "movimientos de almacén"

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

      // Divisas-------------------------------------------------------

      DivisasView();
         :New( ::oController );
         :CreateEditControl( { "idGet" => 190, "idBmp" => 191, "idValue" => 192, "dialog" => ::oDialog } )

      // Comentarios-------------------------------------------------------

      REDEFINE GET   ::oController:oModel:hBuffer[ "comentarios" ] ;
         ID          170 ;
         MEMO ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      // Buttons lineas-------------------------------------------------------
/*
      REDEFINE BUTTON oBtnAppend ;
         ID          500 ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Append() )

      REDEFINE BUTTON oBtnEdit ;
         ID          501 ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Edit() )

      REDEFINE BUTTON oBtnDelete ;
         ID          502 ;
         OF          ::oDialog ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         ACTION      ( ::oController:oLineasController:Delete( ::oSQLBrowseView:getBrowseSelected() ) )

      REDEFINE BUTTON ;
         ID          503 ;
         OF          ::oDialog ;
         ACTION      ( ::oController:oLineasController:Search() )

      REDEFINE BUTTON ;
         ID          509 ;
         OF          ::oDialog ;
         ACTION      ( ::oController:oImportadorController:Activate() )
*/
      // Browse lineas--------------------------------------------------------- 

      ::oSQLBrowseView              := SQLBrowseViewDialog():New( Self )

      ::oSQLBrowseView:setController( ::oController:oLineasController )

      ::oSQLBrowseView:Activate( 180, ::oDialog )

      ::oSQLBrowseView:setView()

      ::oDialog:bStart    := {|| ::startActivate() }

   ::oDialog:Activate( , , , .t., , , {|| ::initActivate() } ) 

   ::oOfficeBar:End()

RETURN ( ::oDialog:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startActivate()
   
   ::changeTipoMovimiento()

   ::oController:stampAlmacenNombre( ::oGetAlmacenOrigen )

   ::oController:stampAlmacenNombre( ::oGetAlmacenDestino )

   ::oController:stampGrupoMovimientoNombre( ::oGetGrupoMovimiento )

   ::oController:stampAgente( ::oGetAgente )

   if ::oController:isNotZoomMode()
      ::oDialog:AddFastKey( VK_F5, {|| ::oBtnOk:Action() } )
      ::oDialog:AddFastKey( VK_F2, {|| ::oBtnAppend:Action() } )
      ::oDialog:AddFastKey( VK_F3, {|| ::oBtnEdit:Action() } )
      ::oDialog:AddFastKey( VK_F4, {|| ::oBtnDelete:Action() } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   local oCarpeta
   
   ::oOfficeBar               := TDotNetBar():New( 0, 0, 2020, 115, ::oDialog, 1 )
   ::oOfficeBar:Disable()

   ::oOfficeBar:lPaintAll     := .f.
   ::oOfficeBar:lDisenio      := .f.

   ::oOfficeBar:SetStyle( 1 )

   ::oDialog:oTop             := ::oOfficeBar

   oCarpeta                   := TCarpeta():New( ::oOfficeBar, "Movimientos almacén" )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "", .f. )
      TDotNetButton():New( 60, oGrupo, "gc_package_pencil_48", "", 1, {|| msgalert("Append") }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 246, "Líneas", .f. )
      ::oBtnAppend            := TDotNetButton():New( 60, oGrupo, "new32", "Añadir [F2]", 1, {|| ::oController:oLineasController:Append() }, , {|| ::oController:isNotZoomMode() }, .f., .f., .f. )
      ::oBtnEdit              := TDotNetButton():New( 60, oGrupo, "gc_pencil__32", "Modificar [F3]", 2, {|| ::oController:oLineasController:Edit() }, , {|| ::oController:isNotZoomMode() }, .f., .f., .f. )
      ::oBtnDelete            := TDotNetButton():New( 60, oGrupo, "del32", "Eliminar [F4]", 3, {|| ::oController:oLineasController:Delete( ::oSQLBrowseView:getBrowseSelected() ) }, , {|| ::oController:isNotZoomMode() }, .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupo, "gc_binocular_32", "Buscar", 4, {|| ::oController:oLineasController:Search() }, , , .f., .f., .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 66, "Acciones", .f. )

   oGrupo                     := TDotNetGroup():New( oCarpeta, 186, "Acciones", .f. )
      ::oBtnOk                := TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar [F5]", 1, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, , , .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupo, "gc_floppy_disk_32", "Aceptar y añadir [F6]", 2, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, , , .f., .f., .f. )
                                 TDotNetButton():New( 60, oGrupo, "End32", "Salir", 3, {|| ::oDialog:End() }, , , .f., .f., .f. )

   ::oOfficeBar:Enable()

RETURN ( Self )

//---------------------------------------------------------------------------//
