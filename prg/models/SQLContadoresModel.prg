#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLContadoresModel FROM SQLCompanyModel

   DATA cTableName                     INIT "contadores"

   DATA cConstraints                   INIT "PRIMARY KEY (id)"

   METHOD getColumns()

   METHOD isSerie( cSerie )
   METHOD createSerie( cSerie, nContador )

   METHOD getLastCounter()
   METHOD setLastCounter( cDocumento, nContador )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                          "default"   => {|| 0 } }                                 )

   getEmpresaColumns()

   hset( ::hColumns, "documento",      {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "serie",          {  "create"    => "VARCHAR ( 250 )"                         ,;
                                          "default"   => {|| space( 250 ) } }                      )

   hset( ::hColumns, "contador",       {  "create"    => "INT UNSIGNED"                            ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "actualizado",    {  "create"    => "TIMESTAMP NULL DEFAULT NULL"             ,;
                                          "default"   => {|| hb_datetime() } }                     )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//