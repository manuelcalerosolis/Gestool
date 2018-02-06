#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oOfficeBar

   DATA oSQLBrowseView

   DATA oGetNumero
   DATA oGetDivisa
   DATA oGetAgente
   DATA oGetAlmacenOrigen
   DATA oGetAlmacenDestino
   DATA oGetGrupoMovimiento
   DATA oRadioTipoMovimento

   DATA oBtnEnviado

   DATA idGoTo                      INIT     0

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate()

   METHOD setTextEnviado()

   METHOD changeTipoMovimiento()    INLINE   (  iif(  ::oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__,;
                                                      ::oGetAlmacenOrigen:Show(),;
                                                      ::oGetAlmacenOrigen:Hide() ) )

   METHOD getUsuario()              INLINE   (  alltrim( ::oController:oModel:hBuffer[ "usuario" ] ) + space( 1 ) + ;
                                                UsuariosModel():getNombre( ::oController:oModel:hBuffer[ "usuario" ] ) )

   METHOD validateAndGoTo()         
   METHOD validateAndGoDown()       INLINE   (  iif( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDDOWN ), ) )
   METHOD validateAndGoUp()         INLINE   (  iif( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDUP ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG ::oDialog RESOURCE "MOVIMIENTOS_ALMACEN" TITLE ::lblTitle() + ::oController:getTitle()

      REDEFINE GET   ::oGetNumero ;
         VAR         ::oController:oModel:hBuffer[ "numero" ] ;
         ID          100 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      ::oGetNumero:bValid   := {|| ::oController:validateNumero() }

      REDEFINE GET   ::oController:oModel:hBuffer[ "delegacion" ] ;
         ID          110 ;
         WHEN        ( .f. ) ;
         OF          ::oDialog

      REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
         ID          120 ;
         PICTURE     "@DT" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      REDEFINE SAY   ;
         PROMPT      ::getUsuario() ;
         ID          220 ;
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

      // Buttons lineas--------------------------------------------------------

      ::oController:oLineasController:Activate( ::oDialog, 180 )

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

   ::setTextEnviado()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   
   ::oOfficeBar   := OfficeBarView():New( Self )

   ::oOfficeBar:createButtonImage( {|| ::oController:oRecordController:Edit() } )

   ::oOfficeBar:createButtonsLine( ::oController:oLineasController, ::oSQLBrowseView )

   if ::oController:isNotZoomMode()
      oGrupo      := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 126,  "Otros", .f. )
                     TDotNetButton():New( 60, oGrupo, "gc_hand_truck_box_32", "Importar almacén",     1, {|| ::oController:oImportadorController:Activate() }, , , .f., .f., .f. )
                     TDotNetButton():New( 60, oGrupo, "gc_pda_32",            "Importar inventario",  2, {|| ::oController:oCapturadorController:Activate() }, , , .f., .f., .f. )
   end if 

   oGrupo         := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 226,  "Fechas", .f., , "gc_user_32" )
                     TDotNetButton():New( 220, oGrupo, "gc_calendar_16",      "Creación : " + hb_ttoc( ::oController:oModel:hBuffer[ "creado" ] ),          1, {|| nil }, , , .f., .f., .f. )
                     TDotNetButton():New( 220, oGrupo, "gc_calendar_16",      "Modificación : " + hb_ttoc( ::oController:oModel:hBuffer[ "modificado" ] ),  1, {|| nil }, , , .f., .f., .f. )
   ::oBtnEnviado  := TDotNetButton():New( 220, oGrupo, "gc_calendar_16",      "",                                                                           1, {|| ::oController:setSenderDateToNull() }, , , .f., .f., .f. )

   ::oOfficeBar:createButtonsDialog()

   if ::oController:isEditMode()
      oGrupo      := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 126,     "Navegación", .f., , "gc_user_32" )
                     TDotNetButton():New( 120, oGrupo, "gc_map_location_16",     "Ir a" ,       1, {|| ::validateAndGoTo() }, , , .f., .f., .f. )
                     TDotNetButton():New( 120, oGrupo, "gc_navigate_right_16",   "Siguiente",   1, {|| ::validateAndGoDown() }, , , .f., .f., .f. )
                     TDotNetButton():New( 120, oGrupo, "gc_navigate_left_16",    "Anterior",    1, {|| ::validateAndGoUp() }, , , .f., .f., .f. )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setTextEnviado()

   local cCaption := "Enviado : "

   if hhaskey( ::oController:oModel:hBuffer, "enviado" ) .and. !empty( ::oController:oModel:hBuffer[ "enviado" ] )
      cCaption    += hb_ttoc( ::oController:oModel:hBuffer[ "enviado" ] )
   end if 

   ::oBtnEnviado:cCaption( cCaption )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validateAndGoTo()

   if !( validateDialog( ::oDialog ) )
      RETURN .f.
   end if 

   ::idGoTo       := IdentificadorRegistroView():Activate( ::oController:oModel:hBuffer[ "id" ] )

   if !empty( ::idGoTo )
      ::oDialog:end( IDOKANDGOTO )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//


