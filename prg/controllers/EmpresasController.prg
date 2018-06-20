#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EmpresasController FROM SQLNavigatorController

   DATA oGetSelector

   DATA oDireccionesController

   DATA oCamposExtraValoresController

   DATA cUuidEmpresa

   DATA oAjustableController

   DATA lSolicitarUsuario 

   DATA oDelegacionesController

   DATA cUuidDelegacionDefecto
   DATA cDelegacionDefecto
   DATA aDelegaciones

   DATA cCodigoUnidaesDefecto
   DATA cUnidadesDefecto
   DATA aUnidades

   METHOD New()

   METHOD End()

   METHOD setConfig()

   METHOD loadConfig()

   METHOD saveConfig()

   METHOD startingActivate()

   METHOD addExtraButtons()

   METHOD updateEmpresa()

   METHOD seedEmpresa()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS EmpresasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Empresas"

   ::cName                          := "empresas"

   ::lConfig                        := .t.

   ::hImage                         := {  "16" => "gc_factory_16",;
                                          "32" => "gc_factory_32",;
                                          "48" => "gc_factory_48" }
   
   ::oModel                         := SQLEmpresasModel():New( self )

   ::oBrowseView                    := EmpresasBrowseView():New( self )

   ::oDialogView                    := EmpresasView():New( self )

   ::oValidator                     := EmpresasValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController  := CamposExtraValoresGestoolController():New( self, ::oModel:cTableName )

   ::oRepository                    := EmpresasRepository():New( self )

   ::oGetSelector                   := ComboSelector():New( self )

   ::oAjustableController           := AjustableController():New( self )

   ::oDireccionesController         := DireccionesGestoolController():New( self )
   ::oDireccionesController:setView( ::oDialogView )

   ::oDelegacionesController        := DelegacionesController():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

   ::oNavigatorView:oMenuTreeView:setEvent( 'addedRefreshButton',     {|| ::addExtraButtons() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oCamposExtraValoresController:End()
   
   ::oAjustableController:End()

   ::oDireccionesController:End()

   ::oDelegacionesController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setConfig()

   if !( ::loadConfig() )
      RETURN ( self )
   end if 

   if ::oAjustableController:DialogViewActivate()
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

   ::lSolicitarUsuario           := ::oAjustableController:oModel:getEmpresaSeleccionarUsuarios( ::cUuidEmpresa )

   ::aDelegaciones               := SQLDelegacionesModel():getArrayNombres()

   ::cUuidDelegacionDefecto      := ::oAjustableController:oModel:getEmpresaDelegacionDefecto( ::cUuidEmpresa )

   ::cDelegacionDefecto          := SQLDelegacionesModel():getNombreFromUuid( ::cUuidDelegacionDefecto )

   ::aUnidades                   := SQLUnidadesMedicionGruposModel():getArrayNombres()

   ::cCodigoUnidaesDefecto       := ::oAjustableController:oModel:getEmpresaUnidadesGrupoDefecto( ::cUuidEmpresa )

   ::cUnidadesDefecto            := SQLUnidadesMedicionGruposModel():getNombreWhereCodigo( ::cCodigoUnidaesDefecto )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveConfig()

   ::oAjustableController:oModel:setEmpresaSeleccionarUsuarios( ::lSolicitarUsuario, ::cUuidEmpresa )
   
   ::cUuidDelegacionDefecto      := SQLDelegacionesModel():getUuidFromNombre( ::cDelegacionDefecto )

   ::oAjustableController:oModel:setEmpresaDelegacionDefecto( ::cUuidDelegacionDefecto, ::cUuidEmpresa )

   ::cCodigoUnidaesDefecto       := SQLUnidadesMedicionGruposModel():getCodigoWhereNombre( ::cUnidadesDefecto )

   ::oAjustableController:oModel:setEmpresaUnidadesGrupoDefecto( ::cCodigoUnidaesDefecto, ::cUuidEmpresa )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startingActivate()

   local oPanel                  := ::oAjustableController:oDialogView:oExplorerBar:AddPanel( "Propiedades empresa", nil, 1 ) 

   oPanel:AddCheckBox( "Solicitar usuario al realizar la venta", @::lSolicitarUsuario )
   
   oPanel:addComboBox( "Delegación defecto", @::cDelegacionDefecto, ::aDelegaciones )

   oPanel:addComboBox( "Unidades defecto", @::cUnidadesDefecto, ::aUnidades )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addExtraButtons()

   ::oNavigatorView:oMenuTreeView:AddButton( "Actualizar", "gc_server_client_exchange_16", {|| ::updateEmpresa() }, "T", ACC_APPD ) 
   
   ::oNavigatorView:oMenuTreeView:AddButton( "Importar datos", "gc_server_client_exchange_16", {|| ::seedEmpresa() }, "D", ACC_APPD ) 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD updateEmpresa()

   aeval( ::getBrowse():aSelected,;
            {|nSelect|  ::getRowSet():goToRecNo( nSelect ),;
                        msgRun( "Actualizando empresa : " + alltrim( ::getRowSet():fieldGet( 'nombre' ) ), "Espere por favor...", {|| SQLCompanyMigrations():Run( ::getRowSet():fieldGet( 'codigo' ) ) } ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD seedEmpresa()

   aeval( ::getBrowse():aSelected,;
            {|nSelect|  ::getRowSet():goToRecNo( nSelect ),;
                        Company():guardWhereCodigo( ::getRowSet():fieldGet( 'codigo' ) ),;
                        msgRun( "Importando empresa : " + alltrim( ::getRowSet():fieldGet( 'nombre' ) ), "Espere por favor...", {|| SQLCompanySeeders():Run( ::getRowSet():fieldGet( 'codigo' ) ) } ) } )

RETURN ( self )

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
      FONT        getBoldFont() ;
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

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oDialog )

   REDEFINE EXPLORERBAR ::oExplorerBar ;
      ID          700 ;
      OF          ::oDialog

   ::oExplorerBar:nBottomColor  := RGB( 255, 255, 255 )
   ::oExplorerBar:nTopColor     := RGB( 255, 255, 255 )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   ::oDialog:bStart  := {|| ::StartDialog() }

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS EmpresasView

   ::oController:oDireccionesController:oDialogView:StartDialog()

   ::addLinksToExplorerBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS EmpresasView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Delegaciones...",        {|| ::oController:oDelegacionesController:activateDialogView() }, ::oController:oDelegacionesController:getImage( "16" ) )
   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...",        {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }, ::oController:oCamposExtraValoresController:getImage( "16" ) )
   end if

RETURN ( self )

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

