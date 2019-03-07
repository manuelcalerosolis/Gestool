#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosModel FROM SQLCompanyModel

   DATA cTable                                

   DATA cTableName                     INIT "filtros"

   DATA cConstraints                   INIT "PRIMARY KEY ( id ), UNIQUE KEY ( tabla, nombre )"

   METHOD setTableToFilter( cTable )   INLINE ( ::cTable := cTable )

   METHOD getTableToFilter()           INLINE ( iif(  empty( ::cTable ),;
                                                      ::getController():getController():getName(),;
                                                      ::cTable ) )

   METHOD getColumns()

   METHOD getFilters( cTabla )

   METHOD getFilterField( cField, cNombre, cTabla )   

   METHOD getFilterSentence( cNombre, cTabla );
                                       INLINE ( ::getFilterField( 'filtro', cNombre, cTabla ) )

   METHOD getId( cNombre, cTabla )     INLINE ( ::getFilterField( 'id', cNombre, cTabla ) )

   METHOD existName( cName, cTable )   INLINE ( ::countWhere( { "nombre" => cName, "tabla" => cTable } ) > 0 )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT" } )

   hset( ::hColumns, "tabla",    {  "create"    => "CHAR ( 50 ) NOT NULL"                 ,;
                                    "default"   => {|| space( 50 ) } } ) 

   hset( ::hColumns, "nombre",   {  "create"    => "CHAR ( 50 ) NOT NULL"                 ,;
                                    "default"   => {|| space( 50 ) } }                    ) 

   hset( ::hColumns, "filtro",   {  "create"    => "TEXT"                                 ,;
                                    "default"   => {|| space( 250 ) } }                   )                     

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getFilters( cTabla )

   local cSentence   

   DEFAULT cTabla    := ::getTableToFilter()

   if empty( cTabla )
      RETURN ( {} )   
   end if 

   cSentence         := "SELECT nombre FROM " + ::getTableName() + " " + ;
                           "WHERE tabla = " + quoted( cTabla ) 

RETURN ( getSQLDatabase():selectFetchArrayOneColumn( cSentence ) )   

//---------------------------------------------------------------------------//

METHOD getFilterField( cField, cNombre, cTabla )

   local cSentence   

   DEFAULT cTabla    := ::getTableToFilter()

   if empty( cTabla )
      RETURN ( nil )   
   end if 

   cSentence         := "SELECT " + cField + " FROM " + ::getTableName()   + space( 1 ) + ;
                           "WHERE tabla = " + quoted( cTabla )             + space( 1 ) + ;
                              "AND nombre = " + quoted( cNombre )          + space( 1 ) + ;
                           "LIMIT 1"

RETURN ( getSQLDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//


