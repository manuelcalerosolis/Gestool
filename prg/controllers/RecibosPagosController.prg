#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosPagosController 

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------


   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := RecibosPagosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosPagosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosPagosController

   ::Super:New( oController )

   ::nLevel                         := Auth():Level( ::cName )

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

   METHOD countWhereUuidRecibo( uuidRecibo )

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

METHOD countWhereUuidRecibo( hUuidRecibo ) CLASS SQLRecibosPagosModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

   FROM %1$s AS pagos_recibos
    
   WHERE pagos_recibos.recibo_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( hUuidRecibo ) )

RETURN ( getSQLDatabase():getValue ( cSql, 0 ) )

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