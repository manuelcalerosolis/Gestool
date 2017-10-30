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

   METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getTotalUnidadesStock( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   METHOD getTotalUnidadesEntrada( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) ; 
      INLINE ( ::getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, .t. ) )

   METHOD getTotalUnidadesSalida( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote ) ;
      INLINE ( ::getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, .f. ) )

   METHOD getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

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
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "text"      => "parent_uuid"                             ,;
                                             "header"    => "Parent uuid"                             ,;
                                             "visible"   => .f.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "codigo_articulo",   {  "create"    => "VARCHAR(18) NOT NULL"                    ,;
                                             "text"      => "Código artículo"                         ,;
                                             "header"    => "Código artículo"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 120 }                                     )

   hset( ::hColumns, "nombre_articulo",   {  "create"    => "VARCHAR(250) NOT NULL"                   ,;
                                             "text"      => "Nombre artículo"                         ,;
                                             "header"    => "Nombre artículo"                         ,;
                                             "visible"   => .t.                                       ,;
                                             "width"     => 240 }                                     )

   hset( ::hColumns, "codigo_primera_propiedad",   {  "create"    => "VARCHAR(20)"                          ,;
                                                      "text"      => "Código primera propiedad artículo"    ,;
                                                      "header"    => "Código primera propiedad artículo"    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "valor_primera_propiedad",    {  "create"    => "VARCHAR(200)"                         ,;
                                                      "text"      => "Valor primera propiedad artículo"     ,;
                                                      "header"    => "Primera propiedad"                    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 80 }                                  )

   hset( ::hColumns, "codigo_segunda_propiedad",   {  "create"    => "VARCHAR(20)"                          ,;
                                                      "text"      => "Código segunda propiedad artículo"    ,;
                                                      "header"    => "Código segunda propiedad artículo"    ,;
                                                      "visible"   => .f.                                    ,;
                                                      "width"     => 240 }                                  )

   hset( ::hColumns, "valor_segunda_propiedad",    {  "create"    => "VARCHAR(200)"                         ,;
                                                      "text"      => "Valor segunda propiedad artículo"     ,;
                                                      "header"    => "Segunda propiedad"                    ,;
                                                      "visible"   => .f.                                    ,;
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

METHOD getFechaHoraConsolidacion( cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

   local aBuffer
   local hResult     := { => }
   local cSql        := "SELECT   movimientos_almacen.uuid, "
         cSql        +=                   "movimientos_almacen.fecha_hora, "
         cSql        +=                   "movimientos_almacen.almacen_destino, "
         cSql        +=                   "movimientos_almacen.tipo_movimiento, "
         cSql        +=                   "movimientos_almacen_lineas.parent_uuid, "
         cSql        +=                   "movimientos_almacen_lineas.codigo_articulo, "
         cSql        +=                   "movimientos_almacen_lineas.valor_primera_propiedad, "
         cSql        +=                   "movimientos_almacen_lineas.valor_segunda_propiedad, "
         cSql        +=                   "movimientos_almacen_lineas.lote "
         cSql        +=          "FROM     movimientos_almacen "
         cSql        +=          "INNER JOIN movimientos_almacen_lineas "
         cSql        +=                   "ON movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid " 
         cSql        +=          "WHERE    movimientos_almacen.almacen_destino = " + quoted( cCodigoAlmacen ) + " AND "
         cSql        +=                   "movimientos_almacen.tipo_movimiento = '4' AND "
         cSql        +=                   "movimientos_almacen_lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " AND "
         cSql        +=                   "movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( cValorPropiedad1 ) + " AND "
         cSql        +=                   "movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( cValorPropiedad2 ) + " AND "
         cSql        +=                   "movimientos_almacen_lineas.lote = " + quoted( cLote ) + " "
         cSql        +=          "ORDER BY movimientos_almacen.fecha_hora DESC "
         cSql        +=          "LIMIT 1"

   aBuffer           := ::getDatabase():selectFetchHash( cSql )

   if hb_isArray( aBuffer ) .and. len( aBuffer ) > 0

      hResult        := { "fecha" => hb_TtoD( hGet( aBuffer[1], "fecha_hora" ) ),;
                          "hora" => SubStr( hb_TSToStr( hGet( aBuffer[1], "fecha_hora" ) ), 12, 8 ),;
                          "fecha_hora" => hGet( aBuffer[1], "fecha_hora" ) }

   end if

RETURN ( hResult )

//---------------------------------------------------------------------------//

METHOD getTotalUnidadesStock( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   
   local nEntrada    := ::getTotalUnidadesEntrada( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )
   local nSalida     := ::getTotalUnidadesSalida( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote )

RETURN ( nEntrada - nSalida )

//---------------------------------------------------------------------------//

METHOD getTotalUnidades( tConsolidacion, cCodigoArticulo, cCodigoAlmacen, cValorPropiedad1, cValorPropiedad2, cLote, lEntrada )

   local nTotal      := 0
   local aBuffer
   local cSentence

   cSentence         := "SELECT   movimientos_almacen.uuid, "
   cSentence         +=          "movimientos_almacen.fecha_hora, "
   cSentence         +=          "movimientos_almacen.almacen_destino, "
   cSentence         +=          "movimientos_almacen.almacen_origen, "
   cSentence         +=          "movimientos_almacen_lineas.parent_uuid, "
   cSentence         +=          "movimientos_almacen_lineas.codigo_articulo, "
   cSentence         +=          "movimientos_almacen_lineas.valor_primera_propiedad, "
   cSentence         +=          "movimientos_almacen_lineas.valor_segunda_propiedad, "
   cSentence         +=          "movimientos_almacen_lineas.lote, "
   cSentence         +=          "movimientos_almacen_lineas.cajas_articulo, "
   cSentence         +=          "movimientos_almacen_lineas.unidades_articulo, "
   cSentence         +=          "SUM( IF( movimientos_almacen_lineas.cajas_articulo = 0, 1, movimientos_almacen_lineas.cajas_articulo ) * movimientos_almacen_lineas.unidades_articulo ) as totalUnidadesStock "
   cSentence         += "FROM    movimientos_almacen "
   cSentence         += "INNER JOIN movimientos_almacen_lineas "
   cSentence         += "ON      movimientos_almacen_lineas.parent_uuid = movimientos_almacen.uuid "
   
   if lEntrada
      cSentence      += "WHERE   movimientos_almacen.almacen_destino = " + quoted( cCodigoAlmacen ) + " AND "
   else
      cSentence      += "WHERE   movimientos_almacen.almacen_origen = " + quoted( cCodigoAlmacen ) + " AND "
   end if
   
   if !Empty( tConsolidacion )
      cSentence      +=         "movimientos_almacen.fecha_hora >= " + quoted( hb_TSToStr( tConsolidacion ) ) + " AND "
   end if

   cSentence         +=         "movimientos_almacen_lineas.codigo_articulo = " + quoted( cCodigoArticulo ) + " AND "
   cSentence         +=         "movimientos_almacen_lineas.valor_primera_propiedad = " + quoted( cValorPropiedad1 ) + " AND "
   cSentence         +=         "movimientos_almacen_lineas.valor_segunda_propiedad = " + quoted( cValorPropiedad2 ) + " AND "
   cSentence         +=         "movimientos_almacen_lineas.lote = " + quoted( cLote ) + " "
   cSentence         += "LIMIT 1"

   LogWrite( cSentence )

   aBuffer           := ::getDatabase():selectFetchHash( cSentence )

   if !hb_isnil( aBuffer )
      nTotal         := hGet( aBuffer[1], "totalUnidadesStock" )
   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//