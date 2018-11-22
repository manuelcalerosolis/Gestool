#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosPagosController 

   DATA oRepository
   
   DATA oModel

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := RecibosPagosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()             INLINE ( if( empty( ::oModel ), ::oModel := SQLRecibosPagosModel():New( self ), ), ::oModel ) 

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosPagosModel FROM SQLCompanyModel

   DATA cTableName               INIT "pagos_recibos"

   METHOD getColumns()

   METHOD InsertPagoRecibo( uuidPago, nImporte )

   METHOD getImporte( uuidPago )    INLINE( ::getDatabase():getValue( ::getImporteSentence( uuidPago ), 0 ) )

   METHOD getImporteSentence( uuidPago )

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

   ::getDeletedStampColumn()


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD InsertPagoRecibo( uuidPago,uuidRecibo, nImporte ) CLASS SQLRecibosPagosModel

   DEFAULT nImporte := 0
   DEFAULT uuidRecibo := ""

   ::loadBlankBuffer()
   hset( ::hBuffer,"pago_uuid", uuidPago ) 
   hset( ::hBuffer,"recibo_uuid", uuidRecibo ) 
   hset( ::hBuffer, "importe", nImporte  )
   ::insertBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getImporteSentence( uuidPago ) CLASS SQLRecibosPagosModel

local cSql

   TEXT INTO cSql

   SELECT 
      SUM( pagos_recibos.importe ) AS importe

   FROM %1$s AS pagos_recibos

   WHERE pagos_recibos.pago_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(),quoted( uuidPago ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosPagosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRecibosPagosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//