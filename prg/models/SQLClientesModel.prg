#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS SQLClientesModel FROM SQLTercerosModel

   DATA cTableName               INIT "clientes"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLClientesModel

   ::super:getColumns()

   hset( ::hColumns, "agente_uuid",          {  "create"    => "VARCHAR( 40 )"                        ,;
                                                "default"   => {|| space( 40 ) } }                    )

RETURN ( ::hColumns )