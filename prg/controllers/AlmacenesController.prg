#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlmacenesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentence()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := AlmacenesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := AlmacenesView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE( if(empty( ::oRepository ), ::oRepository := AlmacenesRepository():New( self ), ), ::oRepository )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := AlmacenesValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLAlmacenesModel():New( self ), ), ::oModel ) 
   
   METHOD getName()                    INLINE ( "almacenes" )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AlmacenesController

   ::Super:New( oController )

   ::cTitle                         := "Almacenes"

   ::hImage                         := {  "16" => "gc_warehouse_16",;
                                          "32" => "gc_warehouse_32",;
                                          "48" => "gc_warehouse_48" }

   ::nLevel                         := Auth():Level( ::getName() )

   ::getModel():setEvent( 'loadedBlankBuffer',           {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',              {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',         {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',               {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection',            {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

   ::getModel():setEvent( 'gettingSelectSentence',       {|| ::gettingSelectSentence() } ) 

   ::setEvents( { 'editing', 'deleting' },               {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AlmacenesController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator)
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS AlmacenesController

RETURN ( ::getModel():setGeneralWhere( "almacen_uuid = ''" ) )

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

RETURN ( self )

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

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS AlmacenesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:getModel():hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS AlmacenesView

   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ALMACEN_SQL" ;
      TITLE       ::LblTitle() + "almacén"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" )  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          160 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oDialog() )

   // Zonas--------------------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          120 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction      := {|| ::oController:getZonasController():Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction     := {|| ::oController:getZonasController():Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          140 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:getZonasController():Delete() }

   ::oController:getZonasController():Activate( 150, ::oDialog ) 

   // Botones almacenes -------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS AlmacenesView

RETURN ( ::oController:getDireccionesController():getDialogView():startDialog() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getUniqueSentence( uValue )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AlmacenesValidator

   ::hValidators  := {  "nombre" =>    {  "required"     => "El nombre es un dato requerido",;
                                          "unique"       => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"     => "El código es un dato requerido" ,;
                                          "unique"       => "EL código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getUniqueSentence( uValue ) CLASS AlmacenesValidator

   local cSQLSentence   := ::Super:getUniqueSentence( uValue ) + " "

   if empty( ::oController ) .or. empty( ::oController:getController() )
      cSQLSentence      +=    "AND almacen_uuid = ''"
   else 
      cSQLSentence      +=    "AND almacen_uuid = " + quoted( ::oController:getController():getUuid() )
   end if

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAlmacenesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "almacenes"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, almacen_uuid, deleted_at )"

   METHOD getColumns()

   METHOD getAlmacenUuidAttribute( value )

   METHOD getInsertAlmacenSentence()

   METHOD CountAlmacenWhereCodigo( cCodigoAlmacen )

#ifdef __TEST__

   METHOD testCreate()

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAlmacenesModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "almacen_uuid",   {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 20 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "sistema",        {  "create"    => "TINYINT( 1 )"                            ,;
                                          "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getAlmacenUuidAttribute( value ) CLASS SQLAlmacenesModel
   
   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:getController() )
      RETURN ( value )
   end if

RETURN ( ::oController:getController():getUuid() )

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

RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD testCreate() CLASS SQLAlmacenesModel

   local hBuffer  := ::loadBlankBuffer(   {  "codigo" => "0",;
                                             "nombre" => "Test de almacen" } )

RETURN ( ::insertBuffer( hBuffer ) )

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
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

RETURN ( ::assert:false( ::oController:Append(), "test creación de almacen sin código" ) )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_nombre() CLASS TestAlmacenesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100 ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )
   
RETURN ( ::assert:false( ::oController:Append(), "test creación de almacen sin nombre" ) )

//---------------------------------------------------------------------------//

METHOD test_dialogo_creacion() CLASS TestAlmacenesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         apoloWaitSeconds( 1 ),;
         self:getControl( 100 ):cText( "0" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( 110 ):cText( "Almacen principal" ),;
         apoloWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

RETURN ( ::assert:true( ::oController:Append(), "test creación de almacen" ) )

//---------------------------------------------------------------------------//

#endif


