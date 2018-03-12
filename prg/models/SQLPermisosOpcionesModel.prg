#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLPermisosOpcionesModel FROM SQLBaseModel

   DATA cTableName               INIT "permisos_opciones"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid), UNIQUE KEY ( permiso_uuid, nombre )"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPermisosOpcionesModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "permiso_uuid",   {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "nivel",          {  "create"    => "TINYINT UNSIGNED"                        ,;
                                          "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLPermisosOpcionesModel():getTableName() ) 

   METHOD getNivel( cPermisoUuid, cNombre )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNivel( cPermisoUuid, cNombre ) CLASS PermisosRepository

   local cSQL  := "SELECT nivel FROM " + ::getTableName()               + " " + ;
                     "WHERE permiso_uuid = " + quoted( cPermisoUuid )   + " " + ;
                        "nombre = " + quoted( cNombre )

RETURN ( ::getDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
