#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UbicacionesController FROM SQLNavigatorController

   DATA parentUuid

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getControllerParentUuid()

   METHOD setControllerParentUuid( parentUuid ) ;
                                       INLINE ( ::parentUuid := parentUuid )

   // Construcciones tardias---------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := AlmacenesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := UbicacionesView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE( if( empty( ::oRepository ), ::oRepository := UbicacionesRepository():New( self ), ), ::oRepository )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := UbicacionesValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLUbicacionesModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UbicacionesController

   ::Super:New( oController )

   ::cTitle                            := "Ubicaciones"

   ::cName                             := "ubicaciones"

   ::hImage                            := {  "16" => "gc_package_16",;
                                             "32" => "gc_package_32",;
                                             "48" => "gc_package_48" }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD getControllerParentUuid()    

   if !empty( ::parentUuid )
      RETURN ( ::parentUuid )
   end if 

RETURN ( ::Super:getControllerParentUuid() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UbicacionesView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS UbicacionesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:getModel():hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS UbicacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "UBICACION_SQL" ;
      TITLE       ::LblTitle() + "ubicación"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "pasillo" ] ;
      ID          120 ;
      PICTURE     "999999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "estanteria" ] ;
      ID          130 ;
      PICTURE     "999999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "altura" ] ;
      ID          140 ;
      PICTURE     "999999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UbicacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UbicacionesValidator

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

CLASS SQLUbicacionesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "ubicaciones"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, parent_uuid, deleted_at )"

   METHOD getColumns()

   METHOD getControllerParentUuid() 

   METHOD CountUbicacionWhereCodigo( cCodigoUbicacion )   

#ifdef __TEST__

   METHOD test_create_trhee_with_parent( uuidParent )

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUbicacionesModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| ::getControllerParentUuid() } }       )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR( 20 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                          "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "sistema",        {  "create"    => "TINYINT( 1 )"                            ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "pasillo",        {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "estanteria",     {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "altura",         {  "create"    => "INT"                                     ,;
                                          "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getControllerParentUuid() CLASS SQLUbicacionesModel

   if !empty( ::oController ) .and. !empty( ::oController:parentUuid )
      RETURN ( ::oController:parentUuid )
   end if 

RETURN ( ::Super:getControllerParentUuid() )

//---------------------------------------------------------------------------//

METHOD CountUbicacionWhereCodigo( cCodigoUbicacion ) CLASS SQLUbicacionesModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)
   
      FROM %1$s AS ubicaciones
   
      WHERE ubicaciones.codigo = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigoUbicacion ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_trhee_with_parent( uuidParent ) CLASS SQLUbicacionesModel

   local hBuffer  := ::loadBlankBuffer(   {  "codigo" => "0",;
                                             "parent_uuid" => uuidParent,;
                                             "nombre" => "Test de ubicación 0" } )

   ::insertBuffer( hBuffer )

   hBuffer        := ::loadBlankBuffer(   {  "codigo" => "1",;
                                             "parent_uuid" => uuidParent,;
                                             "nombre" => "Test de ubicación 1" } )

   ::insertBuffer( hBuffer )

   hBuffer        := ::loadBlankBuffer(   {  "codigo" => "2",;
                                             "parent_uuid" => uuidParent,;
                                             "nombre" => "Test de ubicación 2" } )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UbicacionesRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLUbicacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//



