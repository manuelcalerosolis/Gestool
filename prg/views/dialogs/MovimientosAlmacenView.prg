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

   DATA oGetMarcador
   DATA cGetMarcador                INIT     space( 100 )

   DATA oTagsEver
   
   DATA oBtnTags
   
   DATA oRadioTipoMovimento

   DATA idGoTo                      INIT     0

   METHOD Activate()
      METHOD startActivate()
      METHOD initActivate()

   METHOD changeTipoMovimiento()    INLINE   (  iif(  ::oRadioTipoMovimento:nOption() == __tipo_movimiento_entre_almacenes__,;
                                                      ::oGetAlmacenOrigen:Show(),;
                                                      ::oGetAlmacenOrigen:Hide() ) )

   METHOD getUsuario()              INLINE   (  SQLUsuariosModel():getNombreWhereCodigo( ::oController:oModel:hBuffer[ "usuario_uuid" ] ) )

   METHOD validateAndGoTo()         
   METHOD validateAndGoDown()       INLINE   (  iif( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDDOWN ), ) )
   METHOD validateAndGoUp()         INLINE   (  iif( validateDialog( ::oDialog ), ::oDialog:end( IDOKANDUP ), ) )

   METHOD validateAndAddMarcador()

   METHOD selectorAndAddMarcador()

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

      REDEFINE GET   ::oGetNumero ;
         VAR         ::oController:oModel:hBuffer[ "numero" ] ;
         ID          100 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog

      ::oGetNumero:bValid   := {|| ::oController:validateNumero() }

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

      REDEFINE GET   ::oGetMarcador ;
         VAR         ::cGetMarcador ;
         ID          140 ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         PICTURE     "@!" ;
         BITMAP      "gc_navigate_plus_16" ;
         OF          ::oDialog

      ::oGetMarcador:bValid   := {|| .t. }
      ::oGetMarcador:bHelp    := {|| iif( ::validateAndAddMarcador( ::cGetMarcador ), ::oGetMarcador:cText( space( 100 ) ), ) }

      REDEFINE BTNBMP ::oBtnTags ;
         ID          141 ;
         OF          ::oDialog ;
         RESOURCE    "lupa" ;
         WHEN        ( ::oController:isNotZoomMode() ) ;

      ::oBtnTags:bAction      := {|| ::selectorAndAddMarcador() }

      ::oTagsEver             := TTagEver():Redefine( 142, ::oDialog )
      ::oTagsEver:bOnDelete   := {| oTag, oTagItem | ::oController:deleteTag( oTagItem:uCargo ) }

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

   ::oTagsEver:End()
   ::oOfficeBar:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()
   
   ::changeTipoMovimiento()

   ::oController:stampAlmacenNombre( ::oGetAlmacenOrigen )

   ::oController:stampAlmacenNombre( ::oGetAlmacenDestino )

   ::oController:stampAgente( ::oGetAgente )

   ::oController:stampMarcadores( ::oTagsEver )

   ::oController:oLineasController:oBrowseView:getBrowse():makeTotals()
   ::oController:oLineasController:oBrowseView:getBrowse():goTop()

RETURN ( Self )

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
                     TDotNetButton():New( 60, oGrupo, "gc_hand_truck_box_32", "Importar almacén",     1, {|| ::oController:oImportadorController:Activate() }, , , .f., .f., .f. )
                     TDotNetButton():New( 60, oGrupo, "gc_pda_32",            "Importar inventario",  2, {|| ::oController:oCapturadorController:Activate() }, , , .f., .f., .f. )
   end if 

   ::oOfficeBar:createButtonsDialog()

   if ::oController:isEditMode()
      oGrupo      := TDotNetGroup():New( ::oOfficeBar:oOfficeBarFolder, 126,     "Navegación", .f., , "gc_user_32" )
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

METHOD validateAndAddMarcador( cMarcador )

   cMarcador      := alltrim( cMarcador )

   if empty( cMarcador )
      RETURN ( .f. )
   end if 

   if ascan( ::oTagsEver:aItems, {|oItem| upper( oItem:cText ) == upper( cMarcador ) } ) != 0
      msgStop( "Este marcador ya está incluido" )
      RETURN ( .f. )
   end if 

   if !( ::oController:isAddedTag( cMarcador ) )
      msgStop( "Este marcador : " + cMarcador + " , no existe" )
      RETURN ( .f. )
   end if 

   ::oTagsEver:addItem( cMarcador )
   ::oTagsEver:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD selectorAndAddMarcador()

   local hMarcador   := ::oController:oTagsController:ActivateSelectorView()

   if !empty( hMarcador ) .and. !empty( hget( hMarcador, "nombre" ) )
      ::validateAndAddMarcador( hget( hMarcador, "nombre" ) )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
