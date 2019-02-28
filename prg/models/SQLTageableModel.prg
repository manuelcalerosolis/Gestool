#include "fivewin.ch"

//---------------------------------------------------------------------------//

CLASS SQLTageableModel FROM SQLCompanyModel

   DATA cTableName                     INIT "tageables"

   DATA cConstraints                   INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"            ,;
                                          "default"   => {|| 0 } }                           )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"     ,;
                                          "default"   => {|| win_uuidcreatestring() } }      )

   hset( ::hColumns, "tag_uuid",       {  "create"    => "VARCHAR ( 40 ) NOT NULL"            ,;
                                          "default"   => {|| space( 40 ) } }                 )

   hset( ::hColumns, "tageable_type",  {  "create"    => "VARCHAR( 50 )"                     ,;
                                          "default"   => {|| space( 50 ) } }                 )

   hset( ::hColumns, "tageable_uuid",  {  "create"    => "VARCHAR ( 40 ) NOT NULL"            ,;
                                          "default"   => {|| space( 40 ) } }                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TageableRepository FROM SQLBaseRepository

   METHOD getTableName()      INLINE ( SQLTageableModel():getTableName() ) 

   METHOD getTagsModel()      INLINE ( SQLTagsModel():getTableName() )

   METHOD getHashTageableTags( tageableUuid ) ;
                              INLINE ( ::getDatabase():selectTrimedFetchHash( ::getSQLTageableTags( tageableUuid ) ) )

   METHOD getSQLTageableTags( tageableUuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSQLTageableTags( tageableUuid ) CLASS TageableRepository 

   local cSql

   cSql  := "SELECT Tags.nombre,"                                             + " " + ;
                  "Tageable.id,"                                              + " " + ; 
                  "Tageable.uuid"                                             + " " + ; 
               "FROM " + ::getTableName() + " AS Tageable"                    + " " + ;
               "INNER JOIN " + ::getTagsModel() + " AS Tags"                  + " " + ;
                  "ON Tags.uuid = Tageable.tag_uuid"                          + " " + ;
               "WHERE Tageable.tageable_uuid = " + quoted( tageableUuid )

RETURN ( cSql ) 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

