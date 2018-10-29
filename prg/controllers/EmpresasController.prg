#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EmpresasController FROM SQLNavigatorGestoolController

   DATA oGetSelector

   DATA oPanelView

   DATA oDireccionesController

   DATA oCamposExtraValoresController

   DATA getAjustableController

   DATA lSolicitarUsuario 

   DATA oDelegacionesController

   DATA oFormasPagosController

   DATA cFormaPagoDefecto

   DATA aDelegaciones
   DATA cDelegacionDefecto
   DATA cUuidDelegacionDefecto

   DATA aUnidades
   DATA cUnidadesDefecto
   DATA cCodigoUnidaesDefecto

   DATA aTarifas
   DATA cTarifaDefecto   
   DATA cCodigoTarifaDefecto

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD setConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   METHOD addExtraButtons()

   METHOD updateEmpresa()

   METHOD seedEmpresa()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                         INLINE ( iif( empty( ::oModel ), ::oModel := SQLEmpresasModel():New( self ), ), ::oModel )

   METHOD getAjustableController()           INLINE ( iif( empty( ::oAjustableController ), ::oAjustableController := AjustableController():New( self ), ), ::oAjustableController ) 

   METHOD getRepository()                    INLINE ( iif( empty( ::oRepository ), ::oRepository := EmpresasRepository():New( self ), ), ::oRepository ) 

   METHOD getBrowseView()                    INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := EmpresasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()                    INLINE ( iif( empty( ::oDialogView ), ::oDialogView := EmpresasView():New( self ), ), ::oDialogView )

   METHOD getPanelView()                     INLINE ( iif( empty( ::oPanelView ), ::oPanelView := EmpresasPanelView():New( self ), ), ::oPanelView )

   METHOD getValidator()                     INLINE ( iif( empty( ::oValidator ), ::oValidator := EmpresasValidator():New( self, ::getDialogView() ), ), ::oValidator )

   METHOD getDireccionesController()         INLINE ( if( empty( ::oDireccionesController ), ::oDireccionesController := DireccionesGestoolController():New( self ), ), ::oDireccionesController )

   METHOD getCamposExtraValoresController()  INLINE ( if( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresGestoolController():New( self ), ), ::oCamposExtraValoresController )

   METHOD getFormasPagosController()         INLINE ( if( empty( ::oFormasPagosController ), ::oFormasPagosController := FormasPagosController():New( self ), ), ::oFormasPagosController )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS EmpresasController

   ::Super:New( oController )

   ::cTitle                         := "Empresas"

   ::cName                          := "empresas"

   ::hImage                         := {  "16" => "gc_factory_16",;
                                          "32" => "gc_factory_32",;
                                          "48" => "gc_factory_48" }
   
   ::getModel():setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadPrincipalBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingExitButton', {|| ::addExtraButtons() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oValidator )
      ::oValidator:End()
   end if 

   if !empty( ::oFormasPagosController )
      ::oFormasPagosController:End()
   end if 
   
   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setConfig( uuidEmpresa )

   DEFAULT uuidEmpresa           := ::getRowSet():fieldGet( 'uuid' )

   if empty( uuidEmpresa )
      RETURN ( .f. )
   end if 

   if !( ::loadConfig( uuidEmpresa ) )
      RETURN ( self )
   end if 

   if ::getAjustableController():DialogViewActivate()
      ::saveConfig( uuidEmpresa )
   end if
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadConfig( uuidEmpresa )

   // Company():guardWhereUuid( uuidEmpresa )

   ::cFormaPagoDefecto           := ::getAjustableController():getModel():getEmpresaFormaPago( uuidEmpresa )

   ::lSolicitarUsuario           := ::getAjustableController():getModel():getEmpresaSeleccionarUsuarios( uuidEmpresa )

   ::aDelegaciones               := SQLDelegacionesModel():getNombres()

   ::cUuidDelegacionDefecto      := ::getAjustableController():getModel():getEmpresaDelegacionDefecto( uuidEmpresa )

   ::cDelegacionDefecto          := SQLDelegacionesModel():getNombreFromUuid( ::cUuidDelegacionDefecto )

   ::aUnidades                   := SQLUnidadesMedicionGruposModel():getNombresWithBlank()

   ::cCodigoUnidaesDefecto       := ::getAjustableController():getModel():getEmpresaUnidadesGrupoDefecto( uuidEmpresa )

   ::cUnidadesDefecto            := SQLUnidadesMedicionGruposModel():getNombreWhereCodigo( ::cCodigoUnidaesDefecto )

   ::aTarifas                    := SQLArticulosTarifasModel():getNombres()

   ::cCodigoTarifaDefecto        := ::getAjustableController():getModel():getEmpresaTarifaDefecto( uuidEmpresa )

   ::cTarifaDefecto              := SQLArticulosTarifasModel():getNombreWhereCodigo( ::cCodigoTarifaDefecto )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig( uuidEmpresa )

   ::getAjustableController():getModel():setEmpresaFormaPago( ::cFormaPagoDefecto, uuidEmpresa )

   ::getAjustableController():getModel():setEmpresaSeleccionarUsuarios( ::lSolicitarUsuario, uuidEmpresa )
   
   ::cUuidDelegacionDefecto      := SQLDelegacionesModel():getUuidFromNombre( ::cDelegacionDefecto )

   ::getAjustableController():getModel():setEmpresaDelegacionDefecto( ::cUuidDelegacionDefecto, uuidEmpresa )

   ::cCodigoUnidaesDefecto       := SQLUnidadesMedicionGruposModel():getCodigoWhereNombre( ::cUnidadesDefecto )

   ::getAjustableController():getModel():setEmpresaUnidadesGrupoDefecto( ::cCodigoUnidaesDefecto, uuidEmpresa )

   ::cCodigoTarifaDefecto        := SQLArticulosTarifasModel():getCodigoWhereNombre( ::cTarifaDefecto )

   ::getAjustableController():getModel():setEmpresaTarifaDefecto( ::cCodigoTarifaDefecto, uuidEmpresa )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel                  := ::getAjustableController():oDialogView:oExplorerBar:AddPanel( "Propiedades empresa", nil, 1 ) 

   oPanel:addCheckBox( "Solicitar usuario al realizar la venta", @::lSolicitarUsuario )
   
   // oPanel:addComboBox( "Delegación", @::cDelegacionDefecto, ::aDelegaciones )

   oPanel:addComboBox( "Grupos unidades", @::cUnidadesDefecto, ::aUnidades )

   oPanel:addComboBox( "Tarifa", @::cTarifaDefecto, ::aTarifas )

   oPanel:addGetSelector( "Delegación", @::cDelegacionDefecto ) 

   oPanel:addGetSelector( "Grupos unidades", @::cUnidadesDefecto ) 

   oPanel:addGetSelector( "Tarifa", @::cTarifaDefecto ) 

   ::getFormasPagosController():getSelector():Bind( bSETGET( ::cFormaPagoDefecto ) )
   ::getFormasPagosController():getSelector():addGetSelector( "Forma de pago", oPanel ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addExtraButtons()

   ::oNavigatorView:getMenuTreeView():AddButton( "Actualizar", "gc_server_client_exchange_16", {|| ::updateEmpresa() }, "T", ACC_APPD ) 
   
   ::oNavigatorView:getMenuTreeView():AddButton( "Importar datos", "gc_server_client_exchange_16", {|| ::seedEmpresa() }, "D", ACC_APPD ) 

   ::oNavigatorView:getMenuTreeView():AddButton( "Configuraciones", "gc_wrench_16", {|| ::setConfig() }, "N", ACC_IMPR ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateEmpresa()

   // msgRun( "Actualizando estructura de aplicación", "Espere por favor...", {|| SQLGestoolMigrations():Run() } )

   aeval( ::getBrowseView():getBrowseSelected(),;
            {|nSelect| ::getRowSet():goToRecNo( nSelect ),;
               msgRun( "Actualizando empresa : " + alltrim( ::getRowSet():fieldGet( 'nombre' ) ), "Espere por favor...", {|| SQLCompanyMigrations():Run( ::getRowSet():fieldGet( 'codigo' ) ) } ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD seedEmpresa()

   aeval( ::getBrowseView():getBrowseSelected(),;
            {|nSelect| ::getRowSet():goToRecNo( nSelect ),;
               Company():guardWhereCodigo( ::getRowSet():fieldGet( 'codigo' ) ),;
               msgRun( "Importando empresa : " + alltrim( ::getRowSet():fieldGet( 'nombre' ) ), "Espere por favor...", {|| SQLCompanySeeders():Run( ::getRowSet():fieldGet( 'codigo' ) ) } ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS EmpresasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :cSortOrder          := 'uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Código'
      :cSortOrder          := 'codigo'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'NIF/CIF'
      :cSortOrder          := 'nif'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nif' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Administrador'
      :cSortOrder          := 'administrador'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'administrador' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasView FROM SQLBaseView

   DATA oExplorerBar

   DATA oSayCamposExtra
  
   METHOD Activate()

   METHOD Activating()

   METHOD getImagenesController()   INLINE ( ::oController:oImagenesController )

   METHOD addLinksToExplorerBar()

   METHOD startDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS EmpresasView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EmpresasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "Empresas" ;
      TITLE       ::LblTitle() + "empresa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          110 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nif" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nif" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "administrador" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "registro_mercantil" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "pagina_web" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "inicio_operaciones" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fin_operaciones" ] ;
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      OF          ::oDialog

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oDialog )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS EmpresasView

   ::oController:getDireccionesController():getDialogView():startDialog()

   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS EmpresasView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if
      
   oPanel:AddLink( "Delegaciones...", {|| ::oController:getDelegacionesController():activateDialogView() }, ::oController:getDelegacionesController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   oPanel:AddLink( "Campos extra...", {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }, ::oController:getCamposExtraValoresController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasPanelView FROM SQLBaseView

   DATA oWnd

   DATA oFont
   DATA oBold

   DATA nClrBack              INIT CLR_WHITE
   DATA nClrText              INIT CLR_BLACK
   DATA nClrBorder            INIT CLR_OKBUTTON

   METHOD New( oController )  CONSTRUCTOR
   METHOD End()

   METHOD Activate()

   METHOD Resize()

   METHOD createBitmap()      INLINE ( TBitmap():New( 20, 30, 280, 140, "gestool_logo", , .t., ::oWnd, , , , , , , , , .t., , .f. ) )

   METHOD createButtonModificar()

   METHOD createButtonConfigurar()

   METHOD createButtonCopiasSeguridad()

   METHOD createButtonSalir()

   METHOD createDatosGenerales()

   METHOD getTextDatosGenerales()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS EmpresasPanelView
   
   ::Super:New( oController )

   ::oFont                    := TFont():New( "Segoe UI", 0, -12,, .f. )
   
   ::oBold                    := TFont():New( "Segoe UI", 0, -16,, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EmpresasPanelView

   if !empty( ::oWnd )
      ::oWnd:End()
   end if 
   
   if !empty( ::oFont )
      ::oFont:End()
   end if 

   if !empty( ::oBold )
      ::oBold:End()
   end if 

   ::oFont                    := nil
   
   ::oBold                    := nil

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Resize() CLASS EmpresasPanelView

   // local nWidth            := ::oWnd:GetCliRect():nWidth() - 60

   // ::oBtnModificar:nWidth  := nWidth

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createButtonModificar() CLASS EmpresasPanelView

   with object ( TBtnBmp():New( 130, 30, 140, 80, "gc_factory_32", , , , , ::oWnd, , , .f., .f., "Modificar datos de la empresa", , , , .f., , .f., , , .f., , .t., , .t., .f., .t., ::nClrText, ::nClrBack, .f. ) )
      :bAction       := {|| ::oController:Edit( Company():id ) }
      :nClrBorder    := ::nClrBorder
      :bColorMap     := {| o | o:lBorder := o:lMOver, ::nClrBorder }
      :oFontBold     := ::oBold
      :lRound        := .f.
   end 

   TSay():New( 130, 220, {|| "Modificar datos de la empresa" }, ::oWnd, , ::oBold, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )
   
   TSay():New( 160, 220, {|| "Cambie la información de la empresa actual." }, ::oWnd, , ::oFont, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createButtonConfigurar() CLASS EmpresasPanelView

   with object ( TBtnBmp():New( 230, 30, 140, 80, "gc_wrench_32",,,,, ::oWnd,,, .f., .f., "Configurar opciones de la empresa",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., ::nClrText, ::nClrBack, .f. ) )
      :bAction       := {|| ::oController:setConfig( Company():uuid  ) }
      :nClrBorder    := ::nClrBorder
      :bColorMap     := {| o | o:lBorder := o:lMOver, ::nClrBorder }
      :oFontBold     := ::oBold
      :lRound        := .f.
   end 

   TSay():New( 230, 220, {|| "Configurar opciones de la empresa" }, ::oWnd,, ::oBold, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

   TSay():New( 260, 220, {|| "Adapte la empresa a sus necesidades mediante las opciones de configuración." }, ::oWnd,, ::oFont, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createButtonCopiasSeguridad() CLASS EmpresasPanelView

   with object ( TBtnBmp():New( 330, 30, 140, 80, "gc_wrench_32",,,,, ::oWnd,,, .f., .f., "Realizar copias de seguridad",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., ::nClrText, ::nClrBack, .f. ) )
      :bAction       := {|| ::oController:Edit( Company():id ) }
      :nClrBorder    := ::nClrBorder
      :bColorMap     := {|o| o:lBorder := o:lMOver, ::nClrBorder }
      :oFontBold     := ::oBold
      :lRound        := .f.
   end 

   TSay():New( 330, 220, {|| "Realizar copias de seguridad" }, ::oWnd,, ::oBold, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )
   
   TSay():New( 360, 220, {|| "Mantega a salvo sus datos realizando copias de seguridad periodicas." }, ::oWnd, , ::oFont, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createButtonSalir() CLASS EmpresasPanelView

   with object ( TBtnBmp():New( 430, 30, 140, 80, "gc_door_open2_32",,,,, ::oWnd,,, .f., .f., "Salir del panel de control",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., ::nClrText, ::nClrBack, .f. ) )
      :bAction       := {|| ::oWnd:End() }
      :nClrBorder    := ::nClrBorder
      :bColorMap     := {|o| o:lBorder := o:lMOver, ::nClrBorder }
      :oFontBold     := ::oBold
      :lRound        := .f.
   end 

   TSay():New( 430, 220, {|| "Salir del panel de control" }, ::oWnd,, ::oBold, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )
   
   TSay():New( 460, 220, {|| "Abandonar el panel del control, y volver al programa." }, ::oWnd, , ::oFont, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD createDatosGenerales() CLASS EmpresasPanelView

   TSay():New( 30, 820, {|| ::getTextDatosGenerales() }, ::oWnd, , ::oFont, .f., .f., .f., .t., ::nClrText, ::nClrBack, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTextDatosGenerales() CLASS EmpresasPanelView

   local cText 

   cText    := "Datos generales : "    + CRLF
   cText    += CRLF
   cText    += Company():nombre        + CRLF
   cText    += Company():codigo        + CRLF

RETURN ( cText )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EmpresasPanelView

   ::oWnd            := TDialog():New( 0, 0, 850, 800, "Gestool panel del control", , , , , ::nClrText, ::nClrBack, nil, oWnd(), .t., , ::oFont, , , , .f., , "oWnd", .f., .t. ) 

   ::createBitmap()

   ::createButtonModificar()

   ::createButtonConfigurar()

   ::createButtonCopiasSeguridad()

   ::createButtonSalir()

   ::createDatosGenerales()

   ::oWnd:Activate( , , , .t., , .t., {|| ::oWnd:Maximize() }, , , , )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS EmpresasValidator

   ::hValidators  := {  "codigo" =>    {  "required"     => "El código es un dato requerido",;
                                          "unique"       => "El código introducido ya existe" },;
                        "nombre" =>    {  "required"     => "El nombre es un dato requerido",;
                                          "unique"       => "El nombre introducido ya existe" },;
                        "nif" =>       {  "required"     => "El NIF/CIF es un dato requerido" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLEmpresasModel FROM SQLBaseModel

   DATA cTableName                     INIT "empresas"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )   INLINE ( ::getField( "nombre", "uuid", uuid ) )

   METHOD validEmpresa( cNombre ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLEmpresasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )
   
   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "nif",               {  "create"    => "VARCHAR( 15 )"                           ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "administrador",     {  "create"    => "VARCHAR( 150 )"                          ,;
                                             "default"   => {|| space( 150 ) } }                       )

   hset( ::hColumns, "registro_mercantil",{  "create"    => "VARCHAR( 150 )"                          ,;
                                             "default"   => {|| space( 150 ) } }                       )

   hset( ::hColumns, "pagina_web",        {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "inicio_operaciones",{  "create"    => "DATE"                                     ,;
                                             "default"   => {|| ctod('') } }                           )

   hset( ::hColumns, "fin_operaciones",   {  "create"    => "DATE"                                     ,;
                                             "default"   => {|| ctod('') } }                           )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD validEmpresa( cNombre ) CLASS SQLEmpresasModel

   local cSQL  

   cSQL        := "SELECT * FROM " + ::getTableName()                         + " "    
   cSQL        +=    "WHERE nombre = " + quoted( cNombre )                    + " "    
   cSQL        +=    "LIMIT 1"

RETURN ( ::getDatabase():firstTrimedFetchHash( cSQL ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLEmpresasModel():getTableName() ) 

   METHOD getNombres()                    

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD getNombres() CLASS EmpresasRepository

   local cSentence     := "SELECT nombre FROM " + ::getTableName() + " ORDER BY nombre ASC"
   local aNombres      := ::getDatabase():selectFetchArrayOneColumn( cSentence )

   ains( aNombres, 1, "", .t. )

RETURN ( aNombres )

//---------------------------------------------------------------------------//

