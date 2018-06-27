#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ImpresorasController FROM SQLNavigatorController

   DATA oTiposImpresorasController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ImpresorasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Impresoras"

   ::cName                          := "impresoras"

   ::hImage                         := {  "16" => "gc_printer2_16",;
                                          "32" => "gc_printer2_32",;
                                          "48" => "gc_printer2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLImpresorasModel():New( self )

   ::oBrowseView                    := ImpresorasBrowseView():New( self )

   ::oDialogView                    := ImpresorasView():New( self )

   ::oValidator                     := ImpresorasValidator():New( self, ::oDialogView )

   ::oTiposImpresorasController     := TiposImpresorasController():New( self )

   ::oRepository                    := ImpresorasRepository():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ImpresorasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImpresorasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ImpresorasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tipo_impresora'
      :cHeader             := 'Tipo impresora'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_impresora'
      :cHeader             := 'Nombre impresora'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_impresora' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImpresorasView FROM SQLBaseView

   DATA oTipo

   DATA aTipo 
 
   METHOD Activate()

   METHOD OnActivate() 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ImpresorasView

   ::onActivate()

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "IMPRESORA" ;
      TITLE       ::LblTitle() + "Impresora"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "tipo_impresora_uuid" ] ;
      ID          100 ;
      ITEMS       ::aTipo;
      VALID       ( ::oController:validate( "tipo_impresora_uuid" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre_impresora" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre_impresora" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_corte" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "ruta_comandas" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "ruta_anulacion" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   // Botones impresoras -------------------------------------------------------

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

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD onActivate() CLASS ImpresorasView

   ::aTipo        := ::oController:oTiposImpresorasController:oModel:getNombres()
   
RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImpresorasValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ImpresorasValidator

      ::hValidators  := {  "nombre_impresora"      => {  "required"  => "El nombre es un dato requerido" } ,; 
                           "tipo_impresora_uuid"   => {  "required"  => "El tipo es un datos requerido"  }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLImpresorasModel FROM SQLCompanyModel

   DATA cTableName               INIT "impresoras"

   DATA cConstraints             INIT "FOREIGN KEY (parent_uuid) REFERENCES " + SQLUnidadesMedicionGruposModel():getTableName() + " (uuid) ON DELETE CASCADE"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getTipoImpresoraUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 40 ), SQLTiposImpresorasModel():getNombreWhereUuid( uValue ) ) )

   METHOD setTipoImpresoraUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLTiposImpresorasModel():getUuidWhereNombre( uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLImpresorasModel

   local cSelect  := "SELECT impresoras.id,"                                                               + " " + ;
                        "impresoras.uuid,"                                                                 + " " + ;
                        "impresoras.nombre_impresora,"                                                     + " " + ;
                        "impresoras.tipo_impresora_uuid,"                                                  + " " + ;
                        "impresoras.codigo_corte,"                                                         + " " + ;
                        "impresoras.ruta_comandas,"                                                        + " " + ;
                        "impresoras.ruta_anulacion,"                                                       + " " + ;
                        "tipos_impresoras.nombre as tipo_nombre,"                                          + " " + ;
                        "tipos_impresoras.uuid"                                                            + " " + ;
                     "FROM " + ::getTableName() + " AS impresoras"                                         + " " + ;
                     "INNER JOIN " + SQLTiposImpresorasModel():getTableName() + " AS tipos_impresoras"     + " " + ; 
                        "ON impresoras.tipo_impresora_uuid = tipos_impresoras.uuid"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLImpresorasModel
   
   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                "default"   => {|| ::getSenderControllerParentUuid() } } )

   hset( ::hColumns, "nombre_impresora",     {  "create"    => "VARCHAR( 200 )"                          ,;
                                                "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "tipo_impresora_uuid",  {  "create"    => "VARCHAR( 40 )"                           ,;
                                                "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo_corte",         {  "create"    => "VARCHAR( 50 )"                           ,;
                                                "default"   => {|| space( 50 ) } }                       )

   hset( ::hColumns, "ruta_comandas",        {  "create"    => "VARCHAR( 200 )"                          ,;
                                                "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "ruta_anulacion",       {  "create"    => "VARCHAR( 200 )"                          ,;
                                                "default"   => {|| space( 200 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ImpresorasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLImpresorasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//

