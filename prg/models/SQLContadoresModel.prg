#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLExportableModel

   DATA cTableName            INIT "contadores"

   DATA cConstraints          INIT "PRIMARY KEY (id)"

   DATA cColumnOrder          INIT "id"

   METHOD getColumns()

   METHOD getInitialSelect()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   ::getEmpresaColumns()

   hset( ::hColumns, "tabla",             {  "create"    => "VARCHAR ( 250 )"                         ,;
                                             "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "contador",          {  "create"    => "INT UNSIGNED NOT NULL"                   ,;
                                             "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect     := "SELECT * FROM " + ::getTableName()    

RETURN ( cSelect )

//---------------------------------------------------------------------------//

