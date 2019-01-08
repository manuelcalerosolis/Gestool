#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS SQLFacturasVentasRectificativasModel FROM SQLOperacionesComercialesModel

   DATA cPackage                       INIT "FacturasVentasRectificativas"

   DATA cTableName                     INIT "facturas_ventas_rectificativas"

   METHOD getColumns() 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFacturasVentasRectificativasModel
   
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
