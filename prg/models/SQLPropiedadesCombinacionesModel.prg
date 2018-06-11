#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPropiedadesCombinacionesModel FROM SQLCompanyModel

   DATA cTableName                              INIT "articulos_propiedades_combinaciones"

   METHOD getColumns()


END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPropiedadesCombinacionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "producto_uuid",     {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {||space 40 } }                           )

   hset( ::hColumns, "combinacion_uuid",  {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {||space 40 } }                           )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPropiedadesCombinacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLPropiedadesCombinacionesModel():getTableName() ) 

END CLASS