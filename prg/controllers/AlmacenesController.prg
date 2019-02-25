#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlmacenesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getName()                    INLINE ( "almacenes" )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := AlmacenesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := AlmacenesView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE ( iif(empty( ::oRepository ), ::oRepository := AlmacenesRepository():New( self ), ), ::oRepository )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := AlmacenesValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLAlmacenesModel():New( self ), ), ::oModel ) 
   
   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := AlmacenesItemRange():New( self ), ), ::oRange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlmacenesController

   ::Super:New( oController )

   ::cTitle                            := "Almacenes"

   ::hImage                            := {  "16" => "gc_warehouse_16",;
                                             "32" => "gc_warehouse_32",;
                                             "48" => "gc_warehouse_48" }

   ::nLevel                            := Auth():Level( ::getName() )

   ::getModel():setEvent( 'loadedBlankBuffer', {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer', {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer', {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer', {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer', {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection', {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AlmacenesController

   iif( !empty( ::oModel ), ::oModel:End(), )

   iif( !empty( ::oBrowseView ), ::oBrowseView:End(), )

   iif( !empty( ::oDialogView ), ::oDialogView:End(), )

   iif( !empty( ::oValidator), ::oValidator:End(), )

   iif( !empty( ::oRepository ), ::oRepository:End(), )

   iif( !empty( ::oRange ), ::oRange:End(), )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS AlmacenesBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 50
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

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesView FROM SQLBaseView
  
   DATA oSayCamposExtra

   METHOD Activate()
      METHOD startActivate()

   METHOD Activating()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS AlmacenesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:getModel():hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS AlmacenesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "almacén"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Almacén" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ;
      DIALOGS     "ALMACEN_SQL" 

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oFolder:aDialogs[1] )

   // Botones almacenes -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS AlmacenesView

   ::addLinksToExplorerBar()

   ::oController:getDireccionesController():getDialogView():startDialog()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS AlmacenesView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if Company():getDefaultUsarUbicaciones()

      oPanel:AddLink(   "Ubicaciones...",;
                           {||::oController:getUbicacionesController():activateDialogView() },;
                              ::oController:getUbicacionesController():getImage( "16" ) )

   end if 

   oPanel:AddLink(   "Campos extra...",;
                        {||::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                           ::oController:getCamposExtraValoresController():getImage( "16" ) )

   oPanel:AddLink(   "Incidencias...",;
                        {||::oController:getIncidenciasController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getIncidenciasController():getImage( "16" ) )
   
   oPanel:AddLink(   "Documentos...",;
                        {||::oController:getDocumentosController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getDocumentosController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AlmacenesValidator

   ::hValidators  := {  "nombre" =>    {  "required"     => "El nombre es un dato requerido",;
                                          "unique"       => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"     => "El código es un dato requerido" ,;
                                          "unique"       => "EL código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAlmacenesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "almacenes"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getInsertAlmacenSentence()

   METHOD countAlmacenWhereCodigo( cCodigoAlmacen )

#ifdef __TEST__

   METHOD test_create_almacen_principal()

   METHOD test_get_uuid_almacen_principal() 

   METHOD test_create_almacen_auxiliar()

   METHOD test_get_uuid_almacen_auxiliar()

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAlmacenesModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "text"      => "Identificador"                           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR ( 20 ) NOT NULL"                 ,;
                                          "text"      => "Código"                                  ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 200 ) NOT NULL"                ,;
                                          "text"      => "Nombre"                                  ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "sistema",        {  "create"    => "TINYINT ( 1 )"                           ,;
                                          "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertAlmacenSentence() CLASS SQLAlmacenesModel

   local cSql

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s 
      ( uuid, codigo, nombre, sistema, deleted_at ) 
   VALUES 
      ( UUID(), '0', 'Principal', 1, '0000-00-00 00:00:00' )

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD CountAlmacenWhereCodigo( cCodigoAlmacen ) CLASS SQLAlmacenesModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)
   
      FROM %1$s AS almacenes
   
      WHERE almacenes.codigo = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigoAlmacen ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_almacen_principal() CLASS SQLAlmacenesModel

   local hBuffer  := ::loadBlankBuffer(   {  "codigo" => "0",;
                                             "nombre" => "Almacen principal" } )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_almacen_principal() CLASS SQLAlmacenesModel

RETURN ( ::getUuidWhereCodigo( "0" ) )

//---------------------------------------------------------------------------//

METHOD test_create_almacen_auxiliar() CLASS SQLAlmacenesModel

   local hBuffer  := ::loadBlankBuffer(   {  "codigo" => "1",;
                                             "nombre" => "Almacen auxiliar" } )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_almacen_auxiliar() CLASS SQLAlmacenesModel

RETURN ( ::getUuidWhereCodigo( "1" ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLAlmacenesModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS AlmacenesRepository

   local aResult     
   local aNombres

   aResult           := {}
   aNombres          := ::getDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )

   if !empty( aNombres )
      aeval( aNombres, {| h | aadd( aResult, alltrim( hGet( h, "nombre" ) ) ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesItemRange FROM ItemRange

   DATA cKey                           INIT 'almacen_codigo'

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestAlmacenesController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD test_dialogo_sin_codigo()

   METHOD test_dialogo_sin_nombre() 

   METHOD test_dialogo_creacion()   

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestAlmacenesController

   SQLAlmacenesModel():truncateTable()

   ::oController           := AlmacenesController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestAlmacenesController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_codigo() CLASS TestAlmacenesController
   
   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

RETURN ( ::Assert():false( ::oController:Append(), "test creación de almacen sin código" ) )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_nombre() CLASS TestAlmacenesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oFolder:aDialogs[1] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )
   
RETURN ( ::Assert():false( ::oController:Append(), "test creación de almacen sin nombre" ) )

//---------------------------------------------------------------------------//

METHOD test_dialogo_creacion() CLASS TestAlmacenesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100, self:oFolder:aDialogs[1] ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 110, self:oFolder:aDialogs[1] ):cText( "Almacen principal" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

RETURN ( ::Assert():true( ::oController:Append(), "test creación de almacen" ) )

//---------------------------------------------------------------------------//

#endif


