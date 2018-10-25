#include "FiveWin.Ch"
#include "Factu.ch" 

#define LAYOUT_LEFT    2

//---------------------------------------------------------------------------//

CLASS EmpresasController FROM SQLNavigatorGestoolController

   DATA oGetSelector

   DATA oPanelView

   DATA oDireccionesController

   DATA oCamposExtraValoresController

   DATA cUuidEmpresa

   DATA getAjustableController

   DATA lSolicitarUsuario 

   DATA oDelegacionesController

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

   METHOD getAjustableController()           INLINE ( iif( empty( ::oAjustableController ), ::oAjustableController := AjustableController():New( self ), ), ::oAjustableController ) 

   METHOD getRepository()                    INLINE ( iif( empty( ::oRepository ), ::oRepository := EmpresasRepository():New( self ), ), ::oRepository ) 

   METHOD getBrowseView()                    INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := EmpresasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()                    INLINE ( iif( empty( ::oDialogView ), ::oDialogView := EmpresasView():New( self ), ), ::oDialogView )

   METHOD getPanelView()                     INLINE ( iif( empty( ::oPanelView ), ::oPanelView := EmpresasPanelView():New( self ), ), ::oPanelView )

   METHOD getValidator()                     INLINE ( iif( empty( ::oValidator ), ::oValidator := EmpresasValidator():New( self, ::getDialogView() ), ), ::oValidator )

   METHOD getDireccionesController()         INLINE ( if( empty( ::oDireccionesController ), ::oDireccionesController := DireccionesGestoolController():New( self ), ), ::oDireccionesController )

   METHOD getCamposExtraValoresController()  INLINE ( if( empty( ::oCamposExtraValoresController ), ::oCamposExtraValoresController := CamposExtraValoresGestoolController():New( self ), ), ::oCamposExtraValoresController )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS EmpresasController

   ::Super:New( oController )

   ::cTitle                         := "Empresas"

   ::cName                          := "empresas"

   ::hImage                         := {  "16" => "gc_factory_16",;
                                          "32" => "gc_factory_32",;
                                          "48" => "gc_factory_48" }
   
   ::oModel                         := SQLEmpresasModel():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

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
   
   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setConfig()

   if !( ::loadConfig() )
      RETURN ( self )
   end if 

   if ::getAjustableController():DialogViewActivate()
      ::saveConfig()
   end if
   
RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadConfig()

   ::cUuidEmpresa                := ::getRowSet():fieldGet( 'uuid' )

   if empty( ::cUuidEmpresa )
      RETURN ( .f. )
   end if 

   Company():guardWhereUuid( ::cUuidEmpresa )

   msgalert( ::getAjustableController():className(), "className" )

   ::lSolicitarUsuario           := ::getAjustableController():getModel():getEmpresaSeleccionarUsuarios( ::cUuidEmpresa )

   ::aDelegaciones               := SQLDelegacionesModel():getNombres()

   ::cUuidDelegacionDefecto      := ::getAjustableController():getModel():getEmpresaDelegacionDefecto( ::cUuidEmpresa )

   ::cDelegacionDefecto          := SQLDelegacionesModel():getNombreFromUuid( ::cUuidDelegacionDefecto )

   ::aUnidades                   := SQLUnidadesMedicionGruposModel():getNombresWithBlank()

   ::cCodigoUnidaesDefecto       := ::getAjustableController():getModel():getEmpresaUnidadesGrupoDefecto( ::cUuidEmpresa )

   ::cUnidadesDefecto            := SQLUnidadesMedicionGruposModel():getNombreWhereCodigo( ::cCodigoUnidaesDefecto )

   ::aTarifas                    := SQLArticulosTarifasModel():getNombres()

   ::cCodigoTarifaDefecto        := ::getAjustableController():getModel():getEmpresaTarifaDefecto( ::cUuidEmpresa )

   ::cTarifaDefecto              := SQLArticulosTarifasModel():getNombreWhereCodigo( ::cCodigoTarifaDefecto )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   ::getAjustableController():getModel():setEmpresaSeleccionarUsuarios( ::lSolicitarUsuario, ::cUuidEmpresa )
   
   ::cUuidDelegacionDefecto      := SQLDelegacionesModel():getUuidFromNombre( ::cDelegacionDefecto )

   ::getAjustableController():getModel():setEmpresaDelegacionDefecto( ::cUuidDelegacionDefecto, ::cUuidEmpresa )

   ::cCodigoUnidaesDefecto       := SQLUnidadesMedicionGruposModel():getCodigoWhereNombre( ::cUnidadesDefecto )

   ::getAjustableController():getModel():setEmpresaUnidadesGrupoDefecto( ::cCodigoUnidaesDefecto, ::cUuidEmpresa )

   ::cCodigoTarifaDefecto        := SQLArticulosTarifasModel():getCodigoWhereNombre( ::cTarifaDefecto )

   ::getAjustableController():getModel():setEmpresaTarifaDefecto( ::cCodigoTarifaDefecto, ::cUuidEmpresa )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel                  := ::getAjustableController():oDialogView:oExplorerBar:AddPanel( "Propiedades empresa", nil, 1 ) 

   oPanel:AddCheckBox( "Solicitar usuario al realizar la venta", @::lSolicitarUsuario )
   
   oPanel:addComboBox( "Delegación", @::cDelegacionDefecto, ::aDelegaciones )

   oPanel:addComboBox( "Grupos unidades", @::cUnidadesDefecto, ::aUnidades )

   oPanel:addComboBox( "Tarifa", @::cTarifaDefecto, ::aTarifas )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addExtraButtons()

   ::oNavigatorView:getMenuTreeView():AddButton( "Actualizar", "gc_server_client_exchange_16", {|| ::updateEmpresa() }, "T", ACC_APPD ) 
   
   ::oNavigatorView:getMenuTreeView():AddButton( "Importar datos", "gc_server_client_exchange_16", {|| ::seedEmpresa() }, "D", ACC_APPD ) 

   ::oNavigatorView:getMenuTreeView():AddButton( "Configuraciones", "gc_wrench_16", {|| ::setConfig() }, "N", ACC_IMPR ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateEmpresa()

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

RETURN ( self )

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

   METHOD StartDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS EmpresasView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EmpresasView

   local getImagen
   local bmpImagen

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

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nif" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nif" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "administrador" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "registro_mercantil" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "pagina_web" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "inicio_operaciones" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fin_operaciones" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      OF          ::oDialog

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oDialog )

   REDEFINE EXPLORERBAR ::oExplorerBar ;
      ID          700 ;
      OF          ::oDialog

   ::oExplorerBar:nBottomColor  := RGB( 255, 255, 255 )
   ::oExplorerBar:nTopColor     := RGB( 255, 255, 255 )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS EmpresasView

   ::oController:getDireccionesController():getDialogView():StartDialog()

   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS EmpresasView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Delegaciones...", {|| ::oController:getDelegacionesController():activateDialogView() }, ::oController:getDelegacionesController():getImage( "16" ) )
   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...", {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }, ::oController:getCamposExtraValoresController():getImage( "16" ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EmpresasPanelView FROM SQLBaseView

   DATA oWnd

   METHOD Activate()

   METHOD Resize()

END CLASS

//---------------------------------------------------------------------------//

METHOD Resize() CLASS EmpresasPanelView

   // local nWidth            := ::oWnd:GetCliRect():nWidth() - 60

   // ::oBtnModificar:nWidth  := nWidth

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EmpresasPanelView

   local oFont
   local oBold
   local nClrBack   := CLR_WHITE
   local nClrText   := CLR_BLACK
   local nClrBorder := CLR_OKBUTTON

   oFont             := TFont():New( "Segoe UI", 0, -12,, .f. )
   oBold             := TFont():New( "Segoe UI", 0, -16,, .t. )

   ::oWnd            := TWindow():New( , , , , "", , , , , , , , , , , , .t., .t., .t., .t., .f., , "oWnd" )
   ::oWnd:SetFont( oFont )

   TBitmap():New( 20, 180, 140, 140, "LogoGestool_48", , .t., ::oWnd, , , , , , , , , , , .f. ) 

   TSay():New( 20, 220, {|| "Gestool panel de control" }, ::oWnd, , oBold, .f., .f., .f., .t., , , 420, 80, .f., .f., .f., .f., .f., .f., .f., "oSay",, .f. )

   with object ( TBtnBmp():New( 100, 180, 140, 140, "gc_factory_32",,,,, ::oWnd,,, .f., .f., "Modificar datos de la empresa",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., nClrText, nClrBack, .f. ) )
      :bAction       := {|| msgalert( "Modificar" ) }
      :nClrBorder    := nClrBorder
      :bColorMap     := {| o | o:lBorder := o:lMOver, nClrBorder }
      :oFontBold     := oBold
      :lRound        := .f.
      :nLeft         := 30
      :nHeight       := 80
   end 

   TSay():New( 100, 220, {|| "Modificar datos de la empresa" }, ::oWnd,, oBold, .f., .f., .f., .t.,,, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )
   
   TSay():New( 130, 220, {|| "Cambie la información de la empresa actual." }, ::oWnd,, oFont, .f., .f., .f., .t.,,, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

   with object ( TBtnBmp():New( 200, 180, 140, 140, "gc_wrench_32",,,,, ::oWnd,,, .f., .f., "Configurar datos de la empresa",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., nClrText, nClrBack, .f. ) )
      :bAction       := {|| msgalert( "Configurar" ) }
      :nClrBorder    := nClrBorder
      :bColorMap     := {| o | o:lBorder := o:lMOver, nClrBorder }
      :oFontBold     := oBold
      :lRound        := .f.
      :nLeft         := 30
      :nHeight       := 80
   end 

   TSay():New( 200, 220, {|| "Configurar opciones de la empresa" }, ::oWnd,, oBold, .f., .f., .f., .t.,,, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )
   
   TSay():New( 230, 220, {|| "Adapte la empresa a sus necesidades mediante las opciones de configuración." }, ::oWnd,, oFont, .f., .f., .f., .t.,,, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

   with object ( TBtnBmp():New( 300, 180, 140, 140, "gc_wrench_32",,,,, ::oWnd,,, .f., .f., "Realizar copias de seguridad",,,, .f.,, .f.,,, .f.,, .t.,, .t., .f., .t., nClrText, nClrBack, .f. ) )
      :bAction       := {|| msgalert( "Backup" ) }
      :nClrBorder    := nClrBorder
      :bColorMap     := {| o | o:lBorder := o:lMOver, nClrBorder }
      :oFontBold     := oBold
      :lRound        := .f.
      :nLeft         := 30
      :nHeight       := 80
   end 

   TSay():New( 300, 220, {|| "Realizar copias de seguridad" }, ::oWnd,, oBold, .f., .f., .f., .t.,,, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )
   
   TSay():New( 330, 220, {|| "Mantega a salvo sus datos realizando copias de seguridad periodicas." }, ::oWnd,, oFont, .f., .f., .f., .t.,,, 420, 80, .f., .f., .f., .f., .f., .f., .f., "osay", , .f. )

   ::oWnd:nWidth     := 850
   ::oWnd:nHeight    := 800

   ::oWnd:Activate( "MAXIMIZED", , , , ::oWnd:bResized := {|| ::Resize() }, , , , , , , , , , , , , , , .f. )

   oFont:End()
   oBold:End()

   oFont             := nil
   oBold             := nil

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

