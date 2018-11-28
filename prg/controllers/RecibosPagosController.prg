#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosPagosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD updateField( cField, uValue )

   METHOD calculatePayment( nImporte )

   //Construcciones tardias----------------------------------------------------

   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := RecibosPagosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosPagosModel():New( self ), ), ::oModel ) 

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := RecibosPagosBrowseView():New( self ), ), ::oBrowseView ) 

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

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateField( uValue ) CLASS RecibosPagosController

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "importe", uValue )
   
   ::getRowSet():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD calculatePayment( nImporte ) CLASS RecibosPagosController

   local nImportePagar     := 0
   local nImporteRestante  := nImporte

   ::getRowSet():goTop() 

   while nImporteRestante > 0 

      if nImporteRestante < ::getRowSet():fieldGet( "diferencia" )

         ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "importe", nImporteRestante )

         RETURN ( nil )

      end if

      if nImporteRestante >= ::getRowSet():fieldGet( "diferencia" )

         nImportePagar     += ::getRowSet():fieldGet( "diferencia" )

         ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "importe", ::getRowSet():fieldGet( "diferencia" ) )
         
         if ::oRowSet:Eof()
            
            ::getController():getDialogView():oImporte:cText( nImportePagar )

            RETURN ( nil )

         end if

         nImporteRestante  -= ::getRowSet():fieldGet( "diferencia" )
         
         ::getRowSet():goDown()

      end if

   end

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosPagosBrowseView FROM SQLBrowseView

   DATA lFooter            INIT .t.

   DATA nMarqueeStyle      INIT 3

   METHOD addColumns()

   METHOD getEditGet()     INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET, 0 ) )                    

   METHOD PaidIcon()

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RecibosPagosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Id'
      :cSortOrder          := 'id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :cSortOrder          := 'uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'expedicion'
      :cHeader             := 'Expedición'
      :cDataType           := 'D'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'expedicion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'vencimiento'
      :cHeader             := 'Vencimiento'
      :cDataType           := 'D'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'vencimiento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Concepto'
      :cSortOrder          := 'concepto'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'concepto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe recibo'
      :cSortOrder          := 'importe_recibo'
      :cEditPicture        := "@E 99,999,999.99"
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe_recibo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
      :nFootStyle          := :nDataStrAlign
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe restante'
      :cSortOrder          := 'diferencia'
      :cEditPicture        := "@E 99,999,999.99"
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'diferencia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
      :nFootStyle          := :nDataStrAlign
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe a pagar'
      :cSortOrder          := 'importe_pagar'
      :cEditPicture        := "@E 99,999,999.99"
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe_pagar' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {|oCol, uNewValue| ::oController:updateField( uNewValue ) }
      :nFootStyle          := :nDataStrAlign
      :nFooterType         := AGGR_SUM
      :cFooterPicture      := :cEditPicture
      :oFooterFont         := oFontBold()
      :cDataType           := "N"
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Pagado'
      :bBmpData            := {|| ::PaidIcon() }
      :nWidth              := 90
      :lHide               := .f.
      :AddResource( "Sel16" )
   end with


RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD PaidIcon() CLASS RecibosPagosBrowseView

   if ::getRowSet():fieldGet( 'importe_pagar' ) != 0
      RETURN ( 1 )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosPagosModel FROM SQLCompanyModel

   DATA cTableName               INIT "recibos_pagos"

   DATA cOrderBy                 INIT "recibos.vencimiento"

   DATA cConstraints             INIT "PRIMARY KEY ( pago_uuid, recibo_uuid )"

   METHOD getColumns()

   METHOD getGeneralSelect( uuidPago )

   METHOD InsertPagoRecibo( uuidPago, nImporte )

   METHOD getImporte( uuidPago )    INLINE( ::getDatabase():getValue( ::getImporteSentence( uuidPago ), 0 ) )

   METHOD getImporteSentence( uuidPago )

   METHOD updateImporte( uuidPago )

   METHOD deleteBlankPayment( uuidPago )

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

METHOD InsertPagoRecibo( uuidPago, cClienteCodigo ) CLASS SQLRecibosPagosModel

   local cSql

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s
      ( uuid, pago_uuid, recibo_uuid, importe ) 

   SELECT 
      UUID(), %5$s, recibos.uuid, recibos.importe
   
      FROM %2$s AS recibos
      
      INNER JOIN %3$s AS facturas_clientes
         ON recibos.parent_uuid = facturas_clientes.uuid 
            AND facturas_clientes.cliente_codigo = %6$s 
            AND facturas_clientes.deleted_at = 0
      
      LEFT JOIN %1$s AS pagos_recibos
         ON recibos.uuid = pagos_recibos.recibo_uuid
         
      LEFT JOIN %4$s AS pagos
         ON pagos.uuid = pagos_recibos.pago_uuid
      
      WHERE ( recibos.importe - IFNULL( SUM( pagos_recibos.importe ), 0 ) > 0 ) 
         AND ( pagos.estado = "Rechazado" OR pagos.estado IS NULL ) 

      GROUP BY recibos.uuid
   
   ENDTEXT

   cSql  := hb_strformat( cSql,  ::getTableName(),;
                                 SQLRecibosModel():getTableName(),;
                                 SQLFacturasClientesModel():getTableName(),;
                                 SQLPagosModel():getTableName(),;
                                 quoted( uuidPago ),;
                                 quoted( cClienteCodigo ) )

   logwrite( "InsertPagoRecibo" )
   logwrite( cSql )

RETURN ( getSQLDatabase():Exec ( cSql ) )

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

METHOD updateImporte( uuidPago ) CLASS SQLRecibosPagosModel

   local cSql

   TEXT INTO cSql

   UPDATE %1$s
      SET importe = 0
   WHERE pago_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(),quoted( uuidPago ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD deleteBlankPayment( uuidPago ) CLASS SQLRecibosPagosModel

   local cSql

   TEXT INTO cSql

   DELETE FROM %1$s
      WHERE importe = 0
   AND pago_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(),quoted( uuidPago ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect( uuidPago, cCodigoCliente ) CLASS SQLRecibosPagosModel

 local cSql

   TEXT INTO cSql

   SELECT 
      pagos_recibos.id AS id,
      pagos_recibos.uuid AS uuid,
      pagos_recibos.importe AS importe_pagar,
      recibos.concepto AS concepto,
      recibos.importe AS importe_recibo,
      recibos.vencimiento AS vencimiento,
      recibos.expedicion AS expedicion,
      ( recibos.importe - IFNULL( SUM( pagos_recibos_realizados.importe ), 0 ) ) AS diferencia
      
      FROM %1$s AS pagos_recibos

      INNER JOIN %2$s AS recibos
         ON pagos_recibos.recibo_uuid = recibos.uuid 
      
      INNER JOIN %3$s AS facturas_clientes
         ON facturas_clientes.uuid = recibos.parent_uuid AND facturas_clientes.cliente_codigo = %5$s AND facturas_clientes.deleted_at = 0

      INNER JOIN %1$s AS pagos_recibos_realizados
         ON pagos_recibos_realizados.recibo_uuid = recibos.uuid

      LEFT JOIN %4$s AS pagos
         ON pagos.uuid = pagos_recibos_realizados.pago_uuid

      WHERE pagos_recibos.pago_uuid = %6$s AND ( pagos.estado <> "Rechazado" OR pagos.estado IS NULL )
      
      GROUP BY pagos_recibos.recibo_uuid  

   ENDTEXT

   cSql  := hb_strformat(  cSql, ;
                           ::getTableName(),;
                           SQLRecibosModel():getTableName(),;
                           SQLFacturasClientesModel():getTableName(),;
                           SQLPagosModel():getTableName(),;
                           quoted( cCodigoCliente ),;
                           quoted( uuidPago ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosPagosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRecibosPagosModel():getTableName() ) 

   METHOD getSQLFunctions()               INLINE ( {  ::dropFunctionTotalPaidWhereUuid(),;
                                                      ::createFunctionTotalPaidWhereUuid() } )

   METHOD createFunctionTotalPaidWhereUuid()

   METHOD dropFunctionTotalPaidWhereUuid()

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

      RETURN totalPaid;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ),;
                           ::getTableName(),;
                           SQLPagosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionTotalPaidWhereUuid() CLASS RecibosPagosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//
