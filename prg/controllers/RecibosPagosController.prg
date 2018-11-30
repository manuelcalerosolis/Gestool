#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosPagosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := RecibosPagosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosPagosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosPagosController
   
   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosPagosController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosPagosModel FROM SQLCompanyModel

   DATA cTableName               INIT "recibos_pagos"

   DATA cConstraints             INIT "PRIMARY KEY ( pago_uuid, recibo_uuid )"

   METHOD getColumns()

   METHOD InsertPagoRecibo()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosPagosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "recibo_uuid",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "pago_uuid",                  {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 16,2 )"                              ,;
                                                      "default"   => {||  0  } }                                   )


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD InsertPagoRecibo() CLASS SQLRecibosPagosModel

   local cSql

   TEXT INTO cSql

   INSERT  INTO %1$s
      ( uuid, pago_uuid, recibo_uuid, importe ) 

   SELECT 
       UUID(), pago_uuid,recibo_uuid, importe
   
      FROM %2$s AS tmp

      WHERE tmp.importe > 0
      
   ENDTEXT

   cSql  := hb_strformat( cSql,  ::getTableName(),;
                                 SQLRecibosPagosTemporalModel():getTableName() )
                                 
RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosPagosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRecibosPagosModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionTotalPaidWhereUuid(),;
                                                      ::createFunctionTotalPaidWhereUuid(),;
                                                      ::dropFunctionTotalDifferenceWhereUuid(),;
                                                      ::createFunctionTotalDifferenceWhereUuid() } )

   METHOD createFunctionTotalPaidWhereUuid()

   METHOD dropFunctionTotalPaidWhereUuid()

   METHOD createFunctionTotalDifferenceWhereUuid()

   METHOD dropFunctionTotalDifferenceWhereUuid()

END CLASS

//---------------------------------------------------------------------------//

METHOD createFunctionTotalPaidWhereUuid() CLASS RecibosPagosRepository

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_recibo_cliente` CHAR( 40 ) )
   RETURNS DECIMAL(19,6)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE totalPaid DECIMAL( 19,6 );

      SELECT 
         SUM( recibos_pagos.importe ) INTO totalPaid
      
         FROM %2$s AS recibos_pagos

         LEFT JOIN %3$s AS pagos
            ON pagos.uuid = recibos_pagos.pago_uuid

         WHERE recibos_pagos.recibo_uuid = uuid_recibo_cliente 
         
         GROUP BY pagos.estado 
         
         HAVING pagos.estado = "Presentado";  

      RETURN IFNULL( totalPaid, 0 );

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ),;
                           ::getTableName(),;
                           SQLPagosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

 METHOD createFunctionTotalDifferenceWhereUuid()

 local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_recibo_cliente` CHAR( 40 ) )
   RETURNS DECIMAL(19,6)
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE totalDifference DECIMAL( 19,6 );

      SELECT 
         ( recibos.importe - ( SELECT ( %2$s( recibos.uuid ) ) ) ) INTO totalDifference
      
         FROM %3$s AS recibos

         WHERE recibos.uuid = uuid_recibo_cliente;

      RETURN totalDifference;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'RecibosPagosTotalDifferenceWhereUuid' ),;
                           Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ),;
                           SQLRecibosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalPaidWhereUuid() CLASS RecibosPagosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalDifferenceWhereUuid()

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'RecibosPagosTotalDifferenceWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//


