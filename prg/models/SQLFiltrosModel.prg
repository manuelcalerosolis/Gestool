#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosModel FROM SQLBaseModel

   DATA cTableName               INIT "filtros"

   METHOD getColumns()

   METHOD getFilters( cTabla )

   METHOD getFilterField( cField, cNombre, cTabla )   

   METHOD getFilterSentence( cNombre, cTabla )        INLINE ( ::getFilterField( 'filtro', cNombre, cTabla ) )

   METHOD getFilterId( cNombre, cTabla )              INLINE ( ::getFilterField( 'id', cNombre, cTabla ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",       {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT" ,;
                                    "text"		=> "Identificador"                      ,;
                                    "header"    => "Id"                                 ,;
                                    "visible"   => .t.                                  ,;
                                    "width"     => 40 }                                 )

   hset( ::hColumns, "tabla",    {  "create"    => "CHAR( 50 ) NOT NULL"                ,;
                                    "text"      => "Tabla"                              ,;
                                    "header"    => "Tabla"                              ,;
                                    "len"       => 50 }                                 ) 

   hset( ::hColumns, "nombre",   {  "create"    => "CHAR( 50 ) NOT NULL"                ,;
                                    "text"      => "Nombre de filtro"                   ,;
                                    "header"    => "Nombre"                             ,;
                                    "len"       => 50 }                                  )

   hset( ::hColumns, "filtro",   {  "create"    => "TEXT"                               ,;
                                    "text"      => "Sentencia filtro"                   ,;
                                    "header"    => "Filtro"                             ,;
                                    "len"       => 50 }                                  )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getFilters( cTabla )

   local aFilters    := {}
   local cSentence   := "SELECT nombre FROM " + ::getTableName() + " WHERE tabla = " + quoted( cTabla ) 

   aFilters          := ::getDatabase():selectFetchArrayOneColumn( cSentence )

RETURN ( aFilters )   

//---------------------------------------------------------------------------//

METHOD getFilterField( cField, cNombre, cTabla )

   local aFields     := {}
   local cSentence   := "SELECT " + cField + " FROM " + ::getTableName()   + space( 1 ) + ;
                           "WHERE tabla = " + quoted( cTabla )             + space( 1 ) + ;
                              "AND nombre = " + quoted( cNombre )          + space( 1 ) + ;
                           "LIMIT 1"

   aFields           := ::getDatabase():selectFetchArrayOneColumn( cSentence )

RETURN ( atail( aFields ) )

//---------------------------------------------------------------------------//


