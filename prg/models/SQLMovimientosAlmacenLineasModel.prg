#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasModel FROM SQLExportableModel

   DATA cTableName            INIT "movimientos_almacen_lineas"

   DATA cConstraints          INIT "PRIMARY KEY (uuid), KEY (id), KEY ( parent_uuid )"

   METHOD getColumns()

   METHOD getInitialSelect()

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

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                    ,;
                                             "default"   => {|| space(40) } }                         )

   hset( ::hColumns, "codigo_articulo",   {  "create"    => "VARCHAR(18) NOT NULL"                    ,;
                                             "default"   => {|| space(18) } }                         )

   hset( ::hColumns, "nombre_articulo",   {  "create"    => "VARCHAR(250) NOT NULL"                   ,;
                                             "default"   => {|| space(250) } }                        )

   hset( ::hColumns, "codigo_primera_propiedad",   {  "create"    => "VARCHAR(20)"                 ,;
                                                      "default"   => {|| space(20) } }             )

   hset( ::hColumns, "valor_primera_propiedad",    {  "create"    => "VARCHAR(200)"                ,;
                                                      "default"   => {|| space(200) } }            )

   hset( ::hColumns, "codigo_segunda_propiedad",   {  "create"    => "VARCHAR(20)"                 ,;
                                                      "default"   => {|| space(20) } }             )

   hset( ::hColumns, "valor_segunda_propiedad",    {  "create"    => "VARCHAR(200)"                ,;
                                                      "default"   => {|| space(200) } }            )

   hset( ::hColumns, "fecha_caducidad",   {  "create"    => "DATE"                                 ,;
                                             "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "lote",              {  "create"    => "VARCHAR(40)"                          ,;
                                             "default"   => {|| space(40) } }                      )

   hset( ::hColumns, "bultos_articulo",   {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "default"   => {|| 0 } }                              )

   hset( ::hColumns, "cajas_articulo",    {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "default"   => {|| 0 } }                              )

   hset( ::hColumns, "unidades_articulo", {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "default"   => {|| 1 } }                              )

   hset( ::hColumns, "precio_articulo",   {  "create"    => "DECIMAL(19,6)"                        ,;
                                             "default"   => {|| 0 } }                              )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect()

   local cSelect  := "SELECT id, "                                            + ;
                        "uuid, "                                              + ;
                        "parent_uuid, "                                       + ;
                        "codigo_articulo, "                                   + ;
                        "nombre_articulo, "                                   + ;
                        "codigo_primera_propiedad, "                          + ;
                        "valor_primera_propiedad, "                           + ;
                        "codigo_segunda_propiedad, "                          + ;
                        "valor_segunda_propiedad, "                           + ;
                        "fecha_caducidad, "                                   + ;
                        "lote, "                                              + ;
                        "bultos_articulo, "                                   + ;
                        "cajas_articulo, "                                    + ;
                        "unidades_articulo, "                                 + ;
                        "if( cajas_articulo = 0, 1, cajas_articulo * unidades_articulo ) as total_unidades, "  + ;
                        "precio_articulo, "                                   + ;
                        "if( cajas_articulo = 0, 1, cajas_articulo * unidades_articulo ) * precio_articulo as total_precio "  + ;
                     "FROM " + ::getTableName()    

RETURN ( cSelect )

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

   aBuffer           := ::getDatabase():selectFetchHash( cSentence )

   if !hb_isnil( aBuffer )
      nTotal         := hGet( aBuffer[1], "totalUnidadesStock" )
   end if

RETURN ( nTotal )

//---------------------------------------------------------------------------//