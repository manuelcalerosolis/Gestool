#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS MovimientosAlmacenView FROM SQLBaseView

   DATA oOfficeBar

   DATA oSQLBrowseView

   DATA oGetNumero
   DATA oGetDivisa
   DATA oGetAlmacenOrigen
   DATA oGetAlmacenDestino

   DATA oRadioTipoMovimento

   DATA idGoTo                         INIT     0

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate()

   METHOD changeTipoMovimiento()       INLINE   (  iif(  ::oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__,;
                                                         ::oGetAlmacenOrigen:Show(),;
                                                         ::oGetAlmacenOrigen:Hide() ) )

   METHOD getUsuario()                 INLINE   (  SQLUsuariosModel():getNombreWhereUuid( ::oController:oModel:hBuffer[ "usuario_uuid" ] ) )

   METHOD validateAndGoTo()         
   METHOD validateAndGoDown()          INLINE   (  iif( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDDOWN ), ) )
   METHOD validateAndGoUp()            INLINE   (  iif( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDUP ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate()

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "MOVIMIENTOS_ALMACEN" ;
      TITLE          ::lblTitle() + ::oController:getTitle() 

      REDEFINE SAY   ;
         PROMPT      alltrim( str( ::oController:oModel:hBuffer[ "id" ] ) );
         ID          200 ;
         OF          ::oDialog

      ::oController:oNumeroDocumentoController:BindValue( bSETGET( ::oController:oModel:hBuffer[ "numero" ] ) )
      ::oController:oNumeroDocumentoController:Activate( 100, ::oDialog )

      REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
         ID          120 ;
         PICTURE     "@DT" ;
         SPINNER ;
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

      // Marcadores---------------------------------------------------------------

      ::oController:getTagsController():getDialogView():ExternalRedefine( { "idGet" => 140, "idButton" => 141, "idTags" => 142 }, ::oDialog )

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

      ::oController:oLineasController:Activate( 180, ::oDialog )

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

   ::oController:getTagsController():getDialogView():Start()

   ::oController:oLineasController:oBrowseView:getBrowse():makeTotals()

   ::oController:oLineasController:oBrowseView:getBrowse():goTop()

   ::oGetAlmacenOrigen:setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD initActivate()

   local oGrupo
   
   ::oOfficeBar   := OfficeBarView():New( Self )

   ::oOfficeBar:createButtonImage()

   ::oOfficeBar:createButtonsLine( ::oController:oLineasController, ::oSQLBrowseView )

   if ::oController:isNotZoomMode()

      oGrupo      := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 66, "", .f. )
                     TDotNetButton():New( 60, oGrupo, "gc_form_plus2_32", "Campos extra",             1, {|| CamposExtraValoresController():New( 'movimientos_almacen', ::oController:getUuid() ):Edit() }, , , .f., .f., .f. )

      oGrupo      := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 126,  "Otros", .f. )
                     TDotNetButton():New( 60, oGrupo, "gc_hand_truck_box_32", "Importar almac�n",     1, {|| ::oController:oImportadorController:Activate() }, , , .f., .f., .f. )
                     TDotNetButton():New( 60, oGrupo, "gc_pda_32",            "Importar inventario",  2, {|| ::oController:oCapturadorController:Activate() }, , , .f., .f., .f. )
   end if 

   ::oOfficeBar:createButtonsDialog()

   if ::oController:isEditMode()
      oGrupo      := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 126,     "Navegaci�n", .f., , "gc_user_32" )
                     TDotNetButton():New( 120, oGrupo, "gc_map_location_16",     "Ir a" ,       1, {|| ::validateAndGoTo() }, , , .f., .f., .f. )
                     TDotNetButton():New( 120, oGrupo, "gc_navigate_right_16",   "Siguiente",   1, {|| ::validateAndGoDown() }, , , .f., .f., .f. )
                     TDotNetButton():New( 120, oGrupo, "gc_navigate_left_16",    "Anterior",    1, {|| ::validateAndGoUp() }, , , .f., .f., .f. )
   end if 

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

