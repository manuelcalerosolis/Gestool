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

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "permiso_uuid",   {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                          "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 100 ) NOT NULL"                ,;
                                          "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "nivel",          {  "create"    => "INTEGER ( 3 )"                           ,;
                                          "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PermisosOpcionesRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLPermisosOpcionesModel():getTableName() ) 

   METHOD getNivelUsuario( cUuidUser, cNombreOpcion )

   METHOD getNivelRol( cUuidRol, cOpcion )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNivelUsuario( cUuidUser, cNombreOpcion ) CLASS PermisosOpcionesRepository

   local cSQL  := "SELECT permisos_opciones.nivel FROM " + ::getTableName()         + " " +  ;
                     "INNER JOIN roles"                                             + " " +  ;
                        "ON roles.permiso_uuid = permisos_opciones.permiso_uuid"    + " " +  ;
                     "INNER JOIN usuarios"                                          + " " +  ;
                        "ON usuarios.rol_uuid = roles.uuid"                         + " " +  ;
                     "WHERE usuarios.uuid = " + quoted( cUuidUser )                 + " " +  ; 
                        "AND permisos_opciones.nombre = " + quoted( cNombreOpcion )  

RETURN ( getSQLDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

METHOD getNivelRol( cUuidRol, cOption ) CLASS PermisosOpcionesRepository

   local cSQL  := "SELECT nivel FROM " + ::getTableName()                     + " " +  ;
                     "INNER JOIN permisos"                                    + " " +  ;
                        "ON permisos.uuid = permisos_opciones.permiso_uuid"   + " " +  ;
                     "INNER JOIN roles"                                       + " " +  ;
                        "ON roles.permiso_uuid = permisos.uuid"               + " " +  ;
                     "WHERE roles.uuid = " + quoted( cUuidRol )               + " " +  ;
                        "AND permisos_opciones.nombre = " + quoted( cOption )

RETURN ( getSQLDatabase():getValue( cSQL ) )

//---------------------------------------------------------------------------//

