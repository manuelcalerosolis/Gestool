#include "fivewin.ch"
#include "factu.ch" 
#include "hdo.ch"

//---------------------------------------------------------------------------//

CLASS SQLMovimientosAlmacenLineasModel FROM SQLExportableModel

   DATA cTableName            INIT  "movimientos_almacen_lineas"

   DATA cConstraints          INIT  "PRIMARY KEY ( id ), "                       + ; 
                                       "KEY ( uuid ), "                          + ;
                                       "KEY ( parent_uuid ), "                   + ;
                                       "KEY ( codigo_articulo ) "               

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getInsertSentence()

   METHOD getUpdateSentence()

   METHOD addInsertSentence()

   METHOD addUpdateSentence()
   
   METHOD addDeleteSentence()

   METHOD addDeleteSentenceById()

   METHOD deleteWhereUuid( uuid )

   METHOD aRowsDeleted( uuid )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns()

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT"               ,;
                                             "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"          ,;
                                             "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL"                 ,;
                                             "default"   => {|| space(40) } }         )

   hset( ::hColumns, "codigo_articulo",   {  "create"    => "VARCHAR(18) NOT NULL"                 ,;
                                             "default"   => {|| space(18) } }                      )

   hset( ::hColumns, "nombre_articulo",   {  "create"    => "VARCHAR(250) NOT NULL"                ,;
                                             "default"   => {|| space(250) } }                     )

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
                        "if( cajas_articulo = 0, 1, cajas_articulo ) * unidades_articulo as total_unidades, "  + ;
                        "precio_articulo, "                                   + ;
                        "if( cajas_articulo = 0, 1, cajas_articulo ) * unidades_articulo * precio_articulo as total_precio "  + ;
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

   msgalert( hb_valtoexp( aSQLUpdate ), "aSQLUpdate" )

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

METHOD addDeleteSentenceById( aSQLUpdate, nId )

   aadd( aSQLUpdate, "DELETE FROM " + ::cTableName + " " +                          ;
                        "WHERE id = " + quoted( nId ) + "; " )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteWhereUuid( uuid )

   local cSentence   := "DELETE FROM " + ::cTableName + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():Exec( cSentence ) )

//---------------------------------------------------------------------------//

METHOD aRowsDeleted( uuid )

   local cSentence   := "SELECT * FROM " + ::cTableName + " " + ;
                           "WHERE parent_uuid = " + quoted( uuid )

RETURN ( ::getDatabase():selectFetchHash( cSentence ) )

//---------------------------------------------------------------------------//

