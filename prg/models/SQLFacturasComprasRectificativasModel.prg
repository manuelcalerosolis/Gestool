#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasComprasRectificativasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "FacturasComprasRectificativas"

   DATA cTableName                     INIT "facturas_compras_rectificativas"

   METHOD getColumns() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasComprasRectificativasModel
   
   ::super():getColumns()

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 ) NOT NULL"   ,;
                                                         "default"   => {||space( 40 ) } }         )

   hset( ::hColumns, "motivo",                        {  "create"    => "VARCHAR( 200 ) NOT NULL"  ,;
                                                         "default"   => {||space( 200 ) } }        )

   hset( ::hColumns, "causa",                         {  "create"    => "VARCHAR( 200 ) NOT NULL"  ,;
                                                         "default"   => {||space( 200 ) } }        )  

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
