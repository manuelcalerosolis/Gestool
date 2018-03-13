#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLPermisosOpcionesModel FROM SQLBaseModel

   DATA cTableName               INIT "permisos_opciones"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPermisosOpcionesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "permiso_uuid",   {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL UNIQUE"         ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "nivel",          {  "create"    => "TINYINT UNSIGNED"                        ,;
                                          "default"   => {|| 0 } }                                 )

   ::getTimeStampColumns()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLPermisosOpcionesModel():getTableName() ) 

   METHOD getNombres() 

   METHOD getNombre( uuid )   INLINE ( ::getColumnWhereUuid( uuid, 'nombre' ) ) 

   METHOD getUuid()

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS PermisosRepository

   local cSentence            := "SELECT nombre FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSentence ) )

//---------------------------------------------------------------------------//

METHOD getUuid( cNombre ) CLASS PermisosRepository

   local cSentence            := "SELECT uuid FROM " + ::getTableName() + " " + ;
                                    "WHERE nombre = " + quoted( cNombre )

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
