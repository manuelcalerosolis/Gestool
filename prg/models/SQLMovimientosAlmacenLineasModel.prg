#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasModel FROM SQLBaseEmpresasModel

   DATA  cTableName         INIT "movimientos_almacen_lineas"

   METHOD getColumns()

   METHOD totalUnidades()

   METHOD totalPrecio()

   METHOD getInsertSentence()

   METHOD getUpdateSentence()

   METHOD addInsertSentence()

   METHOD addUpdateSentence()
   
   METHOD addDeleteSentence()

   METHOD deleteWhereUuid( uuid )

   METHOD aRowsDeleted( uuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",                {  "create"    => "INTEGER PRIMARY KEY AUTO_INCREMENT"      ,;
                                             "text"      => "Identificador"                           ,;
                                             "header"    => "Id"                                      ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 40 }                                      )   

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "Uuid"                                    ,;
                                             "header"    => "Uuid"                                    ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 240                                       ,;
                                             "len"       => 40                                        ,;   
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "parent_uuid"                             ,;
                                             "header"    => "Parent uuid"                             ,;
                                             "visible"   => .f.                                       ,;
                                             "len"       => 40                                        ,;   
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "codigo_articulo",   {  "create"    => "VARCHAR(18) NOT NULL"                    ,;
                                             "text"      => "Código artículo"                         ,;
                                             "header"    => "Código artículo"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "len"       => 18                                        ,;   
                                             "width"     => 120 }                                     )

   hset( ::hColumns, "nombre_articulo",   {  "create"    => "VARCHAR(250) NOT NULL"                   ,;
                                             "text"      => "Nombre artículo"                         ,;
                                             "header"    => "Nombre artículo"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "len"       => 250                                       ,;   
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "codigo_primera_propiedad",   {  "create"    => "VARCHAR(20)"                          ,;
                                                      "text"      => "Código primera propiedad artículo"    ,;
                                                      "header"    => "Código primera propiedad artículo"    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "len"       => 20                                     ,;   
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "valor_primera_propiedad",    {  "create"    => "VARCHAR(200)"                         ,;
                                                      "text"      => "Valor primera propiedad artículo"     ,;
                                                      "header"    => "Primera propiedad"                    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "len"       => 200                                    ,;   
                                                      "width"     => 80 }                                  )

   hset( ::hColumns, "codigo_segunda_propiedad",   {  "create"    => "VARCHAR(20)"                          ,;
                                                      "text"      => "Código segunda propiedad artículo"    ,;
                                                      "header"    => "Código segunda propiedad artículo"    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "len"       => 20                                     ,;   
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "valor_segunda_propiedad",    {  "create"    => "VARCHAR(200)"                         ,;
                                                      "text"      => "Valor segunda propiedad artículo"     ,;
                                                      "header"    => "Segunda propiedad"                    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "len"       => 200                                    ,;   
                                                      "width"     => 80 }                                  )

   hset( ::hColumns, "fecha_caducidad",   {  "create"    => "DATE"                                 ,;
                                             "text"      => "Fecha caducidad"                      ,;
                                             "header"    => "Caducidad"                            ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 74 }                                   )

   hset( ::hColumns, "lote",              {  "create"    => "VARCHAR(40)"                          ,;
                                             "text"      => "Lote"                                 ,;
                                             "header"    => "Lote"                                 ,;
                                             "visible"   => .f.                                    ,;
                                             "len"       => 40                                     ,;   
                                             "width"     => 100 }                                  )

   hset( ::hColumns, "bultos_articulo",   {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Bultos"                               ,;
                                             "header"    => "Bultos"                               ,;
                                             "visible"   => .f.                                    ,;
                                             "width"     => 100 }                                  )

   hset( ::hColumns, "cajas_articulo",    {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Cajas"                                ,;
                                             "header"    => "Cajas"                                ,;
                                             "picture"   => masUnd()                               ,;
                                             "visible"   => .f.                                    ,;
                                             "width"     => 100 }                                  )

   hset( ::hColumns, "unidades_articulo", {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Unidades"                             ,;
                                             "header"    => "Unidades"                             ,;
                                             "picture"   => masUnd()                               ,;
                                             "visible"   => .f.                                    ,;
                                             "width"     => 100 }                                  )

   hset( ::hColumns, "total_unidades",    {  "text"      => "Total unidades"                       ,;
                                             "header"    => "Total unidades"                       ,;
                                             "method"    => "totalUnidades"                        ,;
                                             "picture"   => masUnd()                               ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 100 }                                  )

   hset( ::hColumns, "precio_articulo",   {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "text"      => "Precio costo"                         ,;
                                             "header"    => "Costo"                                ,;
                                             "picture"   => cPinDiv()                              ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 100 }                                  )

   hset( ::hColumns, "total_precio",      {  "text"      => "Total costo"                         ,;
                                             "header"    => "Total costo"                         ,;
                                             "method"    => "totalPrecio"                          ,;
                                             "picture"   => masUnd()                               ,;
                                             "visible"   => .t.                                    ,;
                                             "width"     => 120 }                                  )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertSentence()

   local aSQLInsert  := {}

   if empty( ::oController:aProperties )
      RETURN ( ::Super:getInsertSentence() )
   end if 

   aeval( ::oController:aProperties, {| oProperty | ::addInsertSentence( aSQLInsert, oProperty ) } )

RETURN ( aSQLInsert )

//---------------------------------------------------------------------------//

METHOD getUpdateSentence()

   local oProperty
   local aSQLUpdate  := {}

   if empty( ::oController:aProperties )
      RETURN ( ::Super:getUpdateSentence() )
   end if 

   for each oProperty in ::oController:aProperties

      do case
         case !empty( oProperty:Uuid ) .and. empty( oProperty:Value )

            ::addDeleteSentence( aSQLUpdate, oProperty )

         case !empty( oProperty:Uuid ) .and. !empty( oProperty:Value )

            ::addUpdateSentence( aSQLUpdate, oProperty )
       
         case empty( oProperty:Uuid ) 

            ::addInsertSentence( aSQLUpdate, oProperty )

      end case

   next 

RETURN ( aSQLUpdate )

//---------------------------------------------------------------------------//

METHOD addInsertSentence( aSQLInsert, oProperty )

   if empty( oProperty:Value )
      RETURN ( nil )
   end if

   hset( ::hBuffer, "uuid",                     win_uuidcreatestring() )
   hset( ::hBuffer, "codigo_primera_propiedad", oProperty:cCodigoPropiedad1 )
   hset( ::hBuffer, "valor_primera_propiedad",  oProperty:cValorPropiedad1 )
   hset( ::hBuffer, "codigo_segunda_propiedad", oProperty:cCodigoPropiedad2 )
   hset( ::hBuffer, "valor_segunda_propiedad",  oProperty:cValorPropiedad2 )
   hset( ::hBuffer, "unidades_articulo",        oProperty:Value )

   aadd( aSQLInsert, ::Super:getInsertSentence() + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addUpdateSentence( aSQLUpdate, oProperty )

   aadd( aSQLUpdate, "UPDATE " + ::cTableName + " " +                                        ;
                        "SET unidades_articulo = " + toSqlString( oProperty:Value ) + " " +  ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) +  "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addDeleteSentence( aSQLUpdate, oProperty )

   aadd( aSQLUpdate, "DELETE FROM " + ::cTableName + " " +                          ;
                        "WHERE uuid = " + quoted( oProperty:Uuid ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD totalUnidades()

RETURN ( notCaja( ::getRowSet():fieldGet( "cajas_articulo" ) ) * ::getRowSet():fieldGet( "unidades_articulo" ) )

//---------------------------------------------------------------------------//

METHOD totalPrecio()

RETURN ( ::totalUnidades() * ::getRowSet():fieldGet( "precio_articulo" ) )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid )

   local cSentence := "DELETE FROM " + ::cTableName + " " + ;
                              "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD aRowsDeleted( uuid )

   local cSentence   := "SELECT * FROM " + ::cTableName + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():selectFetchHash( cSentence ) )

//---------------------------------------------------------------------------//