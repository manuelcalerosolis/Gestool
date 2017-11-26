#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenModel FROM SQLExportableModel

   DATA cTableName            INIT "movimientos_almacen"

   DATA cConstraints          INIT "PRIMARY KEY (uuid), KEY (id)"

   DATA cColumnOrder          INIT "id"

   DATA aTextoMovimiento      INIT { "Entre almacenes", "Regularizaci�n", "Objetivos", "Consolidaci�n" }

   METHOD getColumns()

   METHOD getGeneralSelect()
   
   METHOD cTextoMovimiento()  

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   ::getEmpresaColumns()

   hset( ::hColumns, "tipo_movimiento",   {  "create"    => "INT NOT NULL"                            ,;
                                             "default"   => 1 }                                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"      ,;
                                             "default"   => {|| hb_datetime() }                       ,;
                                             "headAlign" => AL_LEFT                                   ,; 
                                             "dataAlign" => AL_LEFT                                   ,; 
                                             "footAlign" => AL_LEFT                                   ,; 
                                             "width"     => 140 }                                     )

   hset( ::hColumns, "almacen_origen",    {  "create"    => "CHAR ( 16 )"                             ,;
                                             "default"   => {|| space( 16 ) }                         )

   hset( ::hColumns, "almacen_destino",   {  "create"    => "CHAR ( 16 )"                             ,;
                                             "default"   => {|| space( 16 ) }                         )

   hset( ::hColumns, "grupo_movimiento",  {  "create"    => "CHAR ( 2 )"                              ,;
                                             "default"   => {|| space( 2 ) }                          )

   hset( ::hColumns, "agente",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "text"      => "Agente"                                  ,;
                                             "header"    => "Agente"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "len"       => 3                                         ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "divisa",            {  "create"    => "CHAR ( 3 )"                              ,;
                                             "text"      => "Divisa"                                  ,;
                                             "header"    => "Divisa"                                  ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "default"   => {|| cDivEmp() }                           ,;
                                             "len"       => 3                                         ,;   
                                             "width"     => 80 }                                      )

   hset( ::hColumns, "divisa_cambio",     {  "create"    => "DECIMAL(16,6)"                           ,;
                                             "text"      => "Cambio divisa"                           ,;
                                             "header"    => "Cambio"                                  ,;
                                             "visible"   => .f.                                       ,;
                                             "type"      => "N"                                       ,;
                                             "default"   => {|| 1 }                                   ,;
                                             "field"     => "nVdvDiv" }                                )

   hset( ::hColumns, "comentarios",       {  "create"    => "VARCHAR ( 250 )"                         ,;
                                             "text"      => "Comentarios"                             ,;
                                             "header"    => "Comentarios"                             ,;
                                             "visible"   => .t.                                       ,;
                                             "type"      => "C"                                       ,;
                                             "len"       => 250                                       ,;   
                                             "width"     => 240 }                                     )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect()

   ::cGeneralSelect  := "SELECT tipo_movimiento, "                               + ;
                           "CASE "                                               + ;
                              "WHEN tipo_movimiento = 1 THEN 'Entre almacenes'"  + ;
                              "WHEN tipo_movimiento = 2 THEN 'Regularizaci�n' "  + ;
                              "WHEN tipo_movimiento = 3 THEN 'Objetivos' "       + ;
                              "WHEN tipo_movimiento = 4 THEN 'Consolidaci�n' "   + ;
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

RETURN ( ::cGeneralSelect )

//---------------------------------------------------------------------------//

METHOD cTextoMovimiento( nPosition )

   DEFAULT nPosition := 1

   nPosition         := max( nPosition, 1 )
   nPosition         := min( nPosition, len( ::aTextoMovimiento ) )

RETURN ( ::aTextoMovimiento[ nPosition ] ) 

//---------------------------------------------------------------------------//