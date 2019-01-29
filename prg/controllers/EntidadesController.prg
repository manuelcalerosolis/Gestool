#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EntidadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := EntidadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := EntidadesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := EntidadesValidator():New( self  ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := EntidadesRepository():New( self ), ), ::oRepository ) 

   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLEntidadesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS EntidadesController

   ::Super:New( oController )

   ::cTitle                            := "Entidades"

   ::cName                             := "entidades"

   ::hImage                            := {  "16" => "gc_office_building2_16",;
                                             "32" => "gc_office_building2_32",;
                                             "48" => "gc_office_building2_48" }

   ::nLevel                            := Auth():Level( ::cName )
   
   ::getModel():addEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():addEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():addEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():addEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():addEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():addEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():addEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

   ::getModel():addEvent( 'loadedBlankBuffer',            {|| ::getContactosController():loadBlankBuffer() } )
   ::getModel():addEvent( 'insertedBuffer',               {|| ::getContactosController():insertBuffer() } )
   
   ::getModel():addEvent( 'loadedCurrentBuffer',          {|| ::getContactosController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():addEvent( 'updatedBuffer',                {|| ::getContactosController():updateBuffer( ::getUuid() ) } )

   ::getModel():addEvent( 'loadedDuplicateCurrentBuffer', {|| ::getContactosController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():addEvent( 'loadedDuplicateBuffer',        {|| ::getContactosController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():addEvent( 'deletedSelection',             {|| ::getContactosController():deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EntidadesController
   
   if !empty( ::oModel)
      ::oModel:End()
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

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntidadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS EntidadesBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripción'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion" )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'Código postal'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Población'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'pais'
      :cHeader             := 'País'
      :nWidth              := 100
      :bEditValue          := {|| SQLPaisesModel():getNombreWhereCodigo( ::getRowSet():fieldGet( 'codigo_pais' )  ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'contacto_nombre'
      :cHeader             := 'Nombre contacto'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'contacto_nombre' )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono1'
      :cHeader             := 'telefono 1'
      :nWidth              := 100
      :bEditValue          := {||::getRowSet():fieldGet( 'telefono1' )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with   

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono2'
      :cHeader             := 'telefono 2'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono2' )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email'
      :cHeader             := 'email'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt() 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntidadesView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()
   
   METHOD StartDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EntidadesView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENTIDAD" ;
      TITLE       ::LblTitle() + "entidades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::getController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

    REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::getController():isAppendOrDuplicateMode() ) ;
      VALID       ( ::getController():validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "descripcion" ] ;
      ID          110 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( ::getController():validate( "descripcion" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "nombre" ] ;
      ID          120 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( ::getController():validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "gnl_fisico" ] ;
      ID          130 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( ::getController():validate( "gnl_fisico" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "punto_logico_op" ] ;
      ID          140 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      VALID       ( ::getController():validate( "punto_logico_op" ) ) ;
      OF          ::oDialog

   // Direcciones--------------------------------------------------------------

   ::getController():getDireccionesController():getDialogView():ExternalCoreRedefine( ::oDialog )

   // Contacto-----------------------------------------------------------------

   ::getController():getContactosController():getDialogView():ExternalRedefine( ::oDialog )

   REDEFINE GET   ::getController():getModel():hBuffer[ "web" ] ;
      ID          150 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "codigo_ine" ] ;
      ID          160 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "cno_cnae" ] ;
      ID          170 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getController():getModel():hBuffer[ "otros" ] ;
      ID          180 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          190 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::getController():getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart        := {|| ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog()

   ::oController:getDireccionesController():oDialogView:StartDialog() 
   
   ::oController:getContactosController():oDialogView( ::oDialog ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntidadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS EntidadesValidator

   ::hValidators  := {  "codigo" =>          {  "required"     => "El código es un dato requerido",;
                                                "unique"       => "El código introducido ya existe" } ,;
                        "descripcion" =>     {  "required"     => "La descripción es un dato requerido" } ,;
                        "gnl_fisico" =>      {  "required"     => "GNL físico es un dato requerido" } ,;
                        "punto_logico_op" => {  "required"     => "Punto lógico op es un dato requerido" } ,;
                        "nombre" =>          {  "required"     => "El nombre es un dato requerido"  },;
                                                "unique"       => "El nombre introducido ya existe"  } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLEntidadesModel FROM SQLCompanyModel

   DATA cTableName                           INIT "entidades"

   DATA cConstraints                         INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLEntidadesModel

   local cSql

   TEXT INTO cSql

   SELECT entidades.id AS id,
      entidades.uuid AS uuid,
      entidades.codigo AS codigo,
      entidades.descripcion AS descripcion,
      entidades.nombre AS nombre,
      entidades.gnl_fisico AS gnl_fisico,
      entidades.punto_logico_op AS punto_logico_op,
      entidades.web AS web,
      entidades.codigo_ine AS codigo_ine,
      entidades.cno_cnae AS cno_cnae,
      entidades.otros AS otros,
      entidades.deleted_at AS deleted_at,
      direcciones.direccion ,
      direcciones.codigo_postal AS codigo_postal,
      direcciones.poblacion AS poblacion,
      direcciones.provincia AS provincia,
      direcciones.codigo_pais AS codigo_pais,
      contactos.nombre AS contacto_nombre,
      contactos.telefono1 AS telefono1,
      contactos.telefono2 AS telefono2,
      contactos.email AS email

   FROM %1$s AS entidades

      LEFT JOIN %2$s AS direcciones 
         ON entidades.uuid = direcciones.parent_uuid

      LEFT JOIN %3$s AS contactos 
         ON entidades.uuid = contactos.parent_uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDireccionesModel():getTableName(), SQLContactosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLEntidadesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL"                   ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "descripcion",       {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "gnl_fisico",        {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "punto_logico_op",   {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "web",               {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "codigo_ine",        {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "cno_cnae",          {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "otros",             {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLEntidadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestEntidadesController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 
   
   METHOD test_create()                

   METHOD test_dialogo_sin_codigo()     

   METHOD test_dialogo_creacion()       

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestEntidadesController

   ::oController  := EntidadesController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestEntidadesController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestEntidadesController

   SQLEntidadesModel():truncateTable()

   SQLDireccionesModel():truncateTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create() CLASS TestEntidadesController

   local hBuffer

   hBuffer  := ::oController:getModel();
                  :loadBlankBuffer( {  "codigo"          => "0",;
                                       "nombre"          => "Test de entidades",;
                                       "descripcion"     => "Descripción de entidades",;
                                       "gnl_fisico"      => "GNL",;
                                       "punto_logico_op" => "Punto lógico" } )
   
   ::Assert():notEquals( 0, ::oController:getModel():insertBuffer( hBuffer ), "test creacion entidades" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_codigo() CLASS TestEntidadesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 1 ),;
         self:getControl( 110 ):cText( "Test de entidades" ),;
         testWaitSeconds( 1 ),;
         self:getControl( 120 ):cText( "Descripción" ),;
         testWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test creación de enditades sin codigo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_creacion() CLASS TestEntidadesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds( 1 ),;
         self:getControl( 100 ):cText( "0" ),;
         testWaitSeconds( 1 ),;
         self:getControl( 110 ):cText( "Test de entidades" ),;
         testWaitSeconds( 1 ),;
         self:getControl( 120 ):cText( "Nombre de entidad" ),;
         testWaitSeconds( 1 ),;
         self:getControl( 130 ):cText( "GNL fisico" ),;
         testWaitSeconds( 1 ),;
         self:getControl( 140 ):cText( "Punto lógico" ),;
         testWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creación de entidades al completo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

