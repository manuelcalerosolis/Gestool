#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EmpresasController FROM SQLNavigatorGestoolController

   DATA oGetSelector

   DATA oPanelView

   DATA oCamposExtraValoresController

   DATA lSolicitarUsuario 

   DATA oDelegacionesController

   DATA cMetodoPagoDefecto
   DATA cAlmacenDefecto
   DATA cUnidadesDefecto
   DATA cCertificadoDefecto

   DATA aDelegaciones
   DATA cDelegacionDefecto
   DATA cUuidDelegacionDefecto

   DATA aUnidades
   DATA cCodigoUnidaesDefecto

   DATA aTarifas
   DATA cTarifaDefecto   
   DATA cCodigoTarifaDefecto

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD editConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   METHOD selectCertificado( oGetCertificado )   

   METHOD addExtraButtons()

   METHOD updateEmpresa()

   METHOD seedEmpresa()

   METHOD BackUp()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLEmpresasModel():New( self ), ), ::oModel )

   METHOD getAjustableController()     INLINE ( iif( empty( ::oAjustableController ), ::oAjustableController := AjustableController():New( self ), ), ::oAjustableController ) 

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := EmpresasRepository():New( self ), ), ::oRepository ) 

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := EmpresasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := EmpresasView():New( self ), ), ::oDialogView )

   METHOD getPanelView()               INLINE ( iif( empty( ::oPanelView ), ::oPanelView := EmpresasPanelView():New( self ), ), ::oPanelView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := EmpresasValidator():New( self, ::getDialogView() ), ), ::oValidator )

   METHOD getCamposExtraValoresController();
                                       INLINE ( iif( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresGestoolController():New( self ), ), ::oCamposExtraValoresController )

   METHOD getConfiguracionVistasController();
                                       INLINE ( iif( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )
   
   METHOD getDireccionesController()   INLINE ( iif( empty( ::oDireccionesController ), ::oDireccionesController := DireccionesGestoolController():New( self ), ), ::oDireccionesController )

   METHOD getCuentasBancariasController();
                                       INLINE ( iif( empty( ::oCuentasBancariasController ), ::oCuentasBancariasController := CuentasBancariasGestoolController():New( self ), ), ::oCuentasBancariasController )

   METHOD getDelegacionesController();
                                    INLINE ( if( empty( ::oDelegacionesController ), ::oDelegacionesController := DelegacionesController():New( self ), ), ::oDelegacionesController )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS EmpresasController

   ::Super:New( oController )

   ::cTitle                         := "Empresas"

   ::cName                          := "empresas"

   ::lFilterBar                     := .f.

   ::hImage                         := {  "16" => "gc_factory_16",;
                                          "32" => "gc_factory_32",;
                                          "48" => "gc_factory_48" }

   ::getModel():setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadMainBlankBuffer() } )
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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD editConfig( uuidEmpresa )

   DEFAULT uuidEmpresa           := ::getRowSet():fieldGet( 'uuid' )

   if empty( uuidEmpresa )
      RETURN ( .f. )
   end if 

   if !( ::loadConfig( uuidEmpresa ) )
      RETURN ( nil )
   end if 

   if ::getAjustableController():DialogViewActivate()
      ::saveConfig( uuidEmpresa )
   end if
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadConfig( uuidEmpresa )

   ::cMetodoPagoDefecto          := ::getAjustableController():getModel():getMetodoPago( uuidEmpresa )

   ::cAlmacenDefecto             := ::getAjustableController():getModel():getAlmacen( uuidEmpresa )
   
   ::cUnidadesDefecto            := ::getAjustableController():getModel():getUnidadesGrupo( uuidEmpresa )

   ::cCertificadoDefecto         := ::getAjustableController():getModel():getCertificado( uuidEmpresa )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig( uuidEmpresa )

   ::getAjustableController():getModel():setMetodoPago( ::cMetodoPagoDefecto, uuidEmpresa )

   ::getAjustableController():getModel():setAlmacen( ::cAlmacenDefecto, uuidEmpresa )

   ::getAjustableController():getModel():setUnidadesGrupo( ::cUnidadesDefecto, uuidEmpresa )

   ::getAjustableController():getModel():setCertificado( ::cCertificadoDefecto, uuidEmpresa )
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel                  
   local oGetCertificado

   oPanel               := ::getAjustableController():getDialogView():oExplorerBar:addPanel( "Propiedades empresa", nil, 1 ) 

   ::getMetodosPagosController():getSelector():Bind( bSETGET( ::cMetodoPagoDefecto ) )
   ::getMetodosPagosController():getSelector():addGetSelector( "Metodo de pago", oPanel ) 

   ::getAlmacenesController():getSelector():Bind( bSETGET( ::cAlmacenDefecto ) )
   ::getAlmacenesController():getSelector():addGetSelector( "Almacen", oPanel ) 

   ::getUnidadesMedicionController():getSelector():Bind( bSETGET( ::cUnidadesDefecto ) )
   ::getUnidadesMedicionController():getSelector():addGetSelector( "Grupos unidades", oPanel ) 

   oGetCertificado      := oPanel:addGetAction( "Certificado", bSETGET( ::cCertificadoDefecto ), {|| ::selectCertificado( oGetCertificado ) } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD selectCertificado( oGetCertificado )

   local cCertificado   := selCert()

   if !empty( cCertificado )
      oGetCertificado:cText( cCertificado )
   end if 

RETURN ( nil )
   
//---------------------------------------------------------------------------//

METHOD addExtraButtons()

   ::oNavigatorView:getMenuTreeView():AddButton( "Actualizar", "gc_server_client_exchange_16", {|| ::updateEmpresa() }, "T", ACC_APPD ) 
   
   ::oNavigatorView:getMenuTreeView():AddButton( "Importar datos", "gc_server_client_exchange_16", {|| ::seedEmpresa() }, "D", ACC_APPD ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateEmpresa()

   aeval( ::getBrowseView():getBrowseSelected(),;
            {|nSelect| ::getRowSet():goToRecNo( nSelect ),;
               msgRun( "Actualizando empresa : " + alltrim( cvaltostr( ::getRowSet():fieldGet( 'nombre' ) ) ),;
                  "Espere por favor...", {|| SQLCompanyMigrations():Run( cvaltostr( ::getRowSet():fieldGet( 'codigo' ) ) ) } ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD seedEmpresa()

   aeval( ::getBrowseView():getBrowseSelected(),;
            {|nSelect| ::getRowSet():goToRecNo( nSelect ),;
               Company():guardWhereCodigo( ::getRowSet():fieldGet( 'codigo' ) ),;
               msgRun( "Importando empresa : " + alltrim( cvaltostr( ::getRowSet():fieldGet( 'nombre' ) ) ),;
                  "Espere por favor...", {|| SQLCompanySeeders():Run( cvaltostr( ::getRowSet():fieldGet( 'codigo' ) ) ) } ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD BackUp()

   local lExport
   local oDialogWait

   oDialogWait          := TWaitMeter():New( "Espere por favor", "Creando copia de seguridad..." )
   oDialogWait:setStart( {|| lExport := getSQLDatabase():Export(), oDialogWait:End() } )
   oDialogWait:Run()

   if lExport
      msgInfo( "Copia de seguridad realizada con exito en : " + hb_osnewline() + hb_osnewline() + getSQLDatabase():cBackUpFileName )
   else 
      msgStop( "Error al realizar la copia de seguridad." )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasBrowseView FROM SQLBrowseView

   DATA lDeletedColored    INIT .f.

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

   ::oDialog:bStart        := {|| ::startDialog() }

   ::oDialog:Activate( , , {|| ::paintedActivate() }, .t. )

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
      
   oPanel:AddLink( "Delegaciones...",;
                           {|| ::oController:getDelegacionesController():activateDialogView() },;
                               ::oController:getDelegacionesController():getImage( "16" ) )

   oPanel:AddLink(   "Cuentas bancadias...",;
                           {||::oController:getCuentasBancariasController():activateDialogView( ::oController:getUuid() ) },;
                              ::oController:getCuentasBancariasController():getImage( "16" ) )

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

RETURN ( ::Super:End() )

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
      :bAction       := {|| ::oController:editConfig( Company():uuid  ) }
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

   with object ( TBtnBmp():New( 330, 30, 140, 80, "gc_backup_32",,,,, ::oWnd,,, .f., .f., "Realizar copias de seguridad",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., ::nClrText, ::nClrBack, .f. ) )
      :bAction       := {|| ::oController:BackUp() }
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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestEmpresasController FROM TestCase

   METHOD test_dialog_append()

   METHOD test_delete()

   METHOD test_dialog_empty_cif()

END CLASS

//---------------------------------------------------------------------------//

METHOD test_dialog_append() CLASS TestEmpresasController

   local oController := EmpresasController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         self:getControl( 110 ):cText( 'TEST' ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 120 ):cText( 'Test empresa' ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 130 ):cText( '99999999A' ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::assert:true( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_delete() CLASS TestEmpresasController

   local nId         := EmpresasController():getModel():getField( 'id', 'codigo', 'TEST' )
   
   if nId != 0
      EmpresasController():getModel():deleteSelection( nId ) 
   end if 

   ::assert:equals( nil, EmpresasController():getModel():getField( 'id', 'codigo', 'TEST' ), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialog_empty_cif() CLASS TestEmpresasController

   local oController := EmpresasController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         self:getControl( 110 ):cText( 'TEST' ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 120 ):cText( 'Test empresa' ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

/*
METHOD testDialogEmptyNombre() CLASS TestArticulosController

   local oController := ArticulosController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         ::oGetCodigo:cText( '002' ),;
         apoloWaitSeconds( 1 ),;
         ::oBtnAceptar:Click(),;
         apoloWaitSeconds( 1 ),;
         ::oBtnCancelar:Click() } )

   ::assert:false( oController:Append(), "test ::assert:true with .t." )

RETURN ( nil )
*/
//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#pragma BEGINDUMP

#include <windows.h>

#define CRYPTUI_SELECT_LOCATION_COLUMN 0x000000010

//Definir el prototipo de las funciones:
typedef HCERTSTORE (WINAPI * PTYPECERTOPEN) (HCRYPTPROV, LPTSTR);
typedef PCCERT_CONTEXT (WINAPI * PTYPECERTSELECTDLG) (HCERTSTORE, HWND, LPCWSTR, LPCWSTR, DWORD, DWORD, void*);
typedef PCCERT_CONTEXT (WINAPI * PTYPECERTENUM) (HCERTSTORE, PCCERT_CONTEXT);
typedef DWORD (WINAPI * PTYPECERTGETNAME) (PCCERT_CONTEXT, DWORD, DWORD, VOID*, LPTSTR, DWORD);
typedef DWORD (WINAPI * PTYPECERTNAMETOSTR) (DWORD, PCERT_NAME_BLOB, DWORD, LPTSTR, DWORD);
typedef BOOL (WINAPI * PTYPECERTFREECC) (PCCERT_CONTEXT);
typedef BOOL (WINAPI * PTYPECERTCLOSESTORE) (HCERTSTORE, DWORD);

HB_FUNC(SELCERT)
{

   // Hay varios ejemplos en: https://msdn.microsoft.com/en-us/librar ... 61(v=vs.85).aspx

   HCERTSTORE hStore;
   PCCERT_CONTEXT PrevContext, CurContext;
   PCHAR sNombre = NULL;
   DWORD cbSize;
   PHB_ITEM pArray;
   PHB_ITEM pItem;
   PCCERT_CONTEXT pCertContext;

   // Cargamos las librerías de las que queremos la dirección de las funciones.
   
   HMODULE HCrypt = LoadLibrary("Crypt32.dll");
   HMODULE HCrypt2 = LoadLibrary("Cryptui.dll");

   // Declaramos el tipo de puntero a la función, tenemos la definición arriba.

   PTYPECERTOPEN    pCertOpen;
   PTYPECERTSELECTDLG    pCertSelectDlg;
   PTYPECERTGETNAME pCertGetName;
   PTYPECERTNAMETOSTR pCertNameToStr;
   PTYPECERTFREECC pCertFreeCC;
   PTYPECERTCLOSESTORE pCertCloseStore;

   if (HCrypt != NULL && HCrypt2 != NULL){
      //Sacamos el puntero todas las funciones que vamos a usar mediante GetProcAddress:
      #ifdef UNICODE
         pCertOpen    = (PTYPECERTOPEN) GetProcAddress(HCrypt, "CertOpenSystemStoreW");
         pCertGetName = (PTYPECERTGETNAME) GetProcAddress(HCrypt, "CertGetNameStringW");
      #else
         pCertOpen    = (PTYPECERTOPEN) GetProcAddress(HCrypt, "CertOpenSystemStoreA");
         pCertGetName = (PTYPECERTGETNAME) GetProcAddress(HCrypt, "CertGetNameStringA");
      #endif
      pCertSelectDlg = (PTYPECERTSELECTDLG) GetProcAddress(HCrypt2, "CryptUIDlgSelectCertificateFromStore");
      pCertFreeCC  = (PTYPECERTFREECC) GetProcAddress(HCrypt, "CertFreeCertificateContext");
      pCertCloseStore  = (PTYPECERTCLOSESTORE) GetProcAddress(HCrypt, "CertCloseStore");
   }

   if (pCertOpen){
      // Llamada a CertOpenSystemStore:
      hStore = pCertOpen(NULL, TEXT("MY"));
   }

   if (hStore){
      // Diálogo de selección de certificado:
      pCertContext = pCertSelectDlg( hStore, NULL, NULL, NULL, CRYPTUI_SELECT_LOCATION_COLUMN, 0, NULL );

      if (pCertContext){
         cbSize = pCertGetName( pCertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, NULL, NULL, 0 );
         if (cbSize>0) {
            //Reservamos la memoria que necesitamos para el texto que recibiremos
            sNombre = (LPTSTR) malloc( cbSize * sizeof(TCHAR) );

            pCertGetName( pCertContext, CERT_NAME_SIMPLE_DISPLAY_TYPE, 0, NULL, sNombre, cbSize);

            // Llamada a CertFreeCertificateContext:
            pCertFreeCC(pCertContext);
         }
      }

      // Cerrar el almacen de certificados:
      // Llamada a CertCloseStore:
      pCertCloseStore(hStore, 0);
    }

    FreeLibrary(HCrypt);
    FreeLibrary(HCrypt2);

    hb_retc(sNombre);

}

#pragma ENDDUMP

