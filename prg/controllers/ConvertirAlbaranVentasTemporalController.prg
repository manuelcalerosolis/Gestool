#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ConvertirAlbaranVentasTemporalController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLConvertirAlbaranVentasTemporalModel():New( self ), ), ::oModel ) 

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := OperacionesComercialesBrowseView():New( self ), ), ::oBrowseView ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ConvertirAlbaranVentasTemporalController
   
   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ConvertirAlbaranVentasTemporalController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

/*CLASS ConvertirAlbaranVentasTemporalBrowseView FROM SQLBrowseView

   METHOD addColumns()

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ConvertirAlbaranVentasTemporalBrowseView

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Id'
      :cSortOrder          := 'id'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
   end with

RETURN ( nil )*/

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLConvertirAlbaranVentasTemporalModel FROM SQLCompanyModel

   DATA cTableName               INIT "tmp_albaran_ventas"

   METHOD getColumns()

   METHOD insertTemporalAlbaranes( dFechaDesde, dFEchaHasta, hWhere )

   METHOD createTemporalTable()

   METHOD dropTemporalTable()

   METHOD deleteTemporal()

   //METHOD getColumnsSelect()
   
   //METHOD getInitialSelect()

   METHOD getGeneralSelect( uuidPago )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLConvertirAlbaranVentasTemporalModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"        ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"        ,;
                                                         "default"   => {|| win_uuidcreatestring() } }         )

   hset( ::hColumns, "delegacion_uuid",               {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Delegation():Uuid() } }            )

   hset( ::hColumns, "sesion_uuid",                   {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| Session():Uuid() } }               )

   hset( ::hColumns, "serie",                         {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "numero",                        {  "create"    => "INT UNSIGNED"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "fecha",                         {  "create"    => "DATE"                                 ,;
                                                         "default"   => {|| date() } }                         )

   hset( ::hColumns, "fecha_valor_stock",             {  "create"    => "DATETIME DEFAULT CURRENT_TIMESTAMP"   ,;
                                                         "default"   => {|| hb_datetime() } }                  )

   hset( ::hColumns, "tercero_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "recargo_equivalencia",          {  "create"    => "TINYINT( 1 )"                         ,;
                                                         "default"   => {|| 0 } }                              )

   hset( ::hColumns, "direccion_principal_uuid",      {  "create"    => "VARCHAR( 40 )"                        ,;
                                                         "default"   => {|| space( 40 ) } }                    )

   hset( ::hColumns, "metodo_pago_codigo",             {  "create"   => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "almacen_codigo",                {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| Store():getCodigo() } }            )

   hset( ::hColumns, "agente_codigo",                 {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "ruta_codigo",                   {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "transportista_codigo",          {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )

   hset( ::hColumns, "tarifa_codigo",                 {  "create"    => "VARCHAR( 20 )"                        ,;
                                                         "default"   => {|| space( 20 ) } }                    )
   ::getTimeStampColumns() 

   ::getClosedColumns()

   ::getCanceledColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD deleteTemporal() CLASS SQLConvertirAlbaranVentasTemporalModel

   local cSql

   TEXT INTO cSql

   TRUNCATE TABLE  %1$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect( uuidPago, cCodigoCliente ) CLASS SQLConvertirAlbaranVentasTemporalModel

   local cSql

   TEXT INTO cSql

   SELECT 
      tmp.id AS id,
      tmp.uuid AS uuid,
      tmp.canceled_at AS canceled_at,
      tmp.numero AS numero,
      tmp.delegacion_uuid AS delegacion_uuid, 
      tmp.sesion_uuid AS sesion_uuid,
      tmp.fecha AS fecha,
      tmp.fecha_valor_stock AS fecha_valor_stock,
      tmp.created_at AS created_at,
      tmp.recargo_equivalencia AS recargo_equivalencia,
      tmp.tarifa_codigo AS tarifa_codigo,
      tmp.tercero_codigo AS tercero_codigo,
      terceros.nombre AS tercero_nombre, 
      terceros.dni AS cliente_dni,
      direcciones.direccion AS direccion_direccion,
      direcciones.poblacion AS direccion_poblacion,
      direcciones.codigo_provincia AS direccion_codigo_provincia,
      direcciones.provincia AS direccion_provincia,
      direcciones.codigo_postal AS direccion_codigo_postal,
      direcciones.telefono AS direccion_telefono,
      direcciones.movil AS direccion_movil,
      direcciones.email AS direccion_email,
      tarifas.codigo AS tarifa_codigo,
      tarifas.nombre AS tarifa_nombre

   FROM %1$s AS tmp

   LEFT JOIN %2$s AS terceros
      ON tmp.tercero_codigo = terceros.codigo AND terceros.deleted_at = 0

   LEFT JOIN %3$s AS direcciones
         ON terceros.uuid = direcciones.parent_uuid AND direcciones.codigo = 0

   LEFT JOIN %4$s AS tarifas
         ON tmp.tarifa_codigo = tarifas.codigo
      
   ENDTEXT

   cSql  := hb_strformat(  cSql, ;
                           ::getTableName(),;
                           SQLTercerosModel():getTableName(),;
                           SQLDireccionesModel():getTableName(),;
                           SQLArticulosTarifasModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD createTemporalTable() CLASS SQLConvertirAlbaranVentasTemporalModel

RETURN ( getSQLDatabase():Exec( ::getCreateTableTemporalSentence( Company() ) ) )

//---------------------------------------------------------------------------//

METHOD dropTemporalTable() CLASS SQLConvertirAlbaranVentasTemporalModel

   local cSql

   TEXT INTO cSql

      DROP TABLE %1$s
      
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName() )

RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD insertTemporalAlbaranes( dFechaDesde, dFEchaHasta, hWhere ) CLASS SQLConvertirAlbaranVentasTemporalModel

   local cSql

   TEXT INTO cSql

      INSERT INTO %1$s
         %2$s 
      
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), SQLAlbaranesVentasModel():getSentenceAlbaranWhereHash( dFechaDesde, dFechaHasta, hWhere ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//