#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLFiltrosModel FROM SQLCompanyModel

   DATA cTableToFilter                                

   DATA cTableName                                    INIT "filtros"

   METHOD setTableToFilter( cTableToFilter )          INLINE ( ::cTableToFilter := cTableToFilter )
   METHOD getTableToFilter()                          INLINE ( if( empty( ::cTableToFilter ), ::getController():getController():getName(), ::cTableToFilter ) )

   METHOD getColumns()

   METHOD getFilters( cTabla )

   METHOD getFilterField( cField, cNombre, cTabla )   

   METHOD getFilterSentence( cNombre, cTabla )        INLINE ( ::getFilterField( 'filtro', cNombre, cTabla ) )

   METHOD getId( cNombre, cTabla )                    INLINE ( ::getFilterField( 'id', cNombre, cTabla ) )

   METHOD setTablaAttribute()                         INLINE ( ::getTableToFilter() )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",       {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT" } )

   hset( ::hColumns, "tabla",    {  "create"    => "CHAR( 50 ) NOT NULL"                  ,;
                                    "default"   => {|| space( 50 ) } } ) 

   hset( ::hColumns, "nombre",   {  "create"    => "CHAR( 50 ) NOT NULL"                  ,;
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

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSentence ) )   

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

RETURN ( ::getDatabase():getValue( cSentence ) )

//---------------------------------------------------------------------------//


