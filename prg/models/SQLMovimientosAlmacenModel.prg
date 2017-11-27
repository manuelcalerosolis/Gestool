#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLExportableModel

   DATA cTableName            INIT "movimientos_almacen"

   DATA cConstraints          INIT "PRIMARY KEY (uuid), KEY (id)"

   DATA cColumnOrder          INIT "id"

   DATA aTextoMovimiento      INIT { "Entre almacenes", "Regularización", "Objetivos", "Consolidación" }

   METHOD getColumns()

   METHOD getInitialSelect()
   
   METHOD cTextoMovimiento()  

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   ::getEmpresaColumns()

   hset( ::hColumns, "tipo_movimiento",   {  "create"    => "INT NOT NULL"                            ,;
                                             "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                             "default"   => {|| hb_datetime() } }                     )

   hset( ::hColumns, "almacen_origen",    {  "create"    => "CHAR ( 16 )"                             ,;
                                             "default"   => {|| space( 16 ) } }                       )

   hset( ::hColumns, "almacen_destino",   {  "create"    => "CHAR ( 16 )"                             ,;
                                             "default"   => {|| space( 16 ) } }                       )

   hset( ::hColumns, "grupo_movimiento",  {  "create"    => "CHAR ( 2 )"                              ,;
                                             "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "agente",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "divisa",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "default"   => {|| cDivEmp() } }                         )

   hset( ::hColumns, "divisa_cambio",     {  "create"    => "DECIMAL( 16, 6 )"                        ,;
                                             "default"   => {|| 1 } }                                 )

   hset( ::hColumns, "comentarios",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                             "default"   => {|| space( 250 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect     := "SELECT id, "                                            + ;
                           "tipo_movimiento, "                                   + ;
                           "CASE "                                               + ;
                              "WHEN tipo_movimiento = 1 THEN 'Entre almacenes' " + ;
                              "WHEN tipo_movimiento = 2 THEN 'Regularización' "  + ;
                              "WHEN tipo_movimiento = 3 THEN 'Objetivos' "       + ;
                              "WHEN tipo_movimiento = 4 THEN 'Consolidación' "   + ;
                           "END as nombre_movimiento, "                          + ;
                           "fecha_hora, "                                        + ;
                           "almacen_origen, "                                    + ;
                           "almacen_destino, "                                   + ;
                           "grupo_movimiento, "                                  + ;
                           "agente, "                                            + ;
                           "divisa, "                                            + ;
                           "divisa_cambio, "                                     + ;
                           "comentarios "                                        + ;        
                        "FROM " + ::getTableName()    

   msgstop( cSelect, "getInitialSelect" )

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento( nPosition )

   DEFAULT nPosition := 1

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) 

//---------------------------------------------------------------------------//