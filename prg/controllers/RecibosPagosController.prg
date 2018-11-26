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
   
   METHOD getModel()             INLINE ( if( empty( ::oModel ), ::oModel := SQLRecibosPagosModel():New( self ), ), ::oModel ) 

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

   local nImporteRestante  := nImporte
   local nImportePagar     := 0

   ::getRowSet():goTop() 

   aadd(::getBrowseView():oBrowse:aSelected, ::oRowSet:RecNo() )
   
   WHILE nImporteRestante > 0 

      if nImporteRestante < ::getRowSet():fieldGet( "diferencia" )

         ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "importe", nImporteRestante )

         nImportePagar += nImporteRestante
         
         nImporteRestante := 0
      
      end if

      if nImporteRestante >= ::getRowSet():fieldGet( "diferencia" )

         nImportePagar += ::getRowSet():fieldGet( "diferencia" )

         ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "importe", ::getRowSet():fieldGet( "diferencia" ) )
         
         if ::oRowSet:RecNo() = ::getRowSet():recCount()

            nImporteRestante := 0

            ::oController:getDialogView():nImporte := nImportePagar
            
            ::oController:getDialogView():oImporte:Refresh()

         end if

         nImporteRestante -= ::getRowSet():fieldGet( "diferencia" )
         
         ::getRowSet:goDown()

      end if

      aadd(::getBrowseView():oBrowse:aSelected, ::oRowSet:RecNo() )

   END

   ::getRowSet:Refresh()

   ::oBrowseView:Refresh()

RETURN ( nil )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosPagosBrowseView FROM SQLBrowseView

   METHOD addColumns()

   METHOD getEditGet()     INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET, 0 ) )                    

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
      :cHeader             := 'Concepto'
      :cSortOrder          := 'concepto'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'concepto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
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
      :cHeader             := 'Importe recibo'
      :cSortOrder          := 'importe_recibo'
      :cEditPicture        := "@E 999999999999.99"
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe_recibo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe restante'
      :cSortOrder          := 'diferencia'
      :cEditPicture        := "@E 999999999999.99"
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'diferencia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe a pagar'
      :cSortOrder          := 'importe_pagar'
      :cEditPicture        := "@E 999999999999.99"
      :nWidth              := 90
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe_pagar' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .f.
      :nEditType           := ::getEditGet()
      :bOnPostEdit         := {|oCol, uNewValue| ::oController:updateField( uNewValue ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosPagosModel FROM SQLCompanyModel

   DATA cTableName               INIT "pagos_recibos"

   METHOD getColumns()

   METHOD getGeneralSelect( uuidPago )

   METHOD InsertPagoRecibo( uuidPago, nImporte )

   METHOD getImporte( uuidPago )    INLINE( ::getDatabase():getValue( ::getImporteSentence( uuidPago ), 0 ) )

   METHOD getImporteSentence( uuidPago )

   METHOD updateImporte( uuidPago )

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

   INSERT INTO %1$s
      ( uuid, pago_uuid, recibo_uuid, importe ) 
   SELECT 
      UUID(), %5$s, recibos.uuid, recibos.importe
   
   FROM %2$s AS recibos
   
   INNER JOIN %3$s AS facturas_clientes
      ON recibos.parent_uuid = facturas_clientes.uuid AND facturas_clientes.cliente_codigo = %6$s AND facturas_clientes.deleted_at = 0
   
   LEFT JOIN %1$s AS pagos_recibos
      ON recibos.uuid = pagos_recibos.recibo_uuid
      
   LEFT JOIN %4$s AS pagos
      ON pagos.uuid = pagos_recibos.pago_uuid AND pagos.estado = "Rechazado"
      
   WHERE recibos.deleted_at = 0 

   GROUP BY recibos.uuid
   
   HAVING ( recibos.importe - SUM( pagos_recibos.importe ) IS null OR recibos.importe - SUM( pagos_recibos.importe ) > 0 )
        
   ENDTEXT

   cSql  := hb_strformat( cSql,  ::getTableName(),;
                                 SQLRecibosModel():getTableName(),;
                                 SQLFacturasClientesModel():getTableName(),;
                                 SQLPagosModel():getTableName(),;
                                 quoted( uuidPago ),;
                                 quoted( cClienteCodigo ) )

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

METHOD getGeneralSelect( uuidPago, cCodigoCliente ) CLASS SQLRecibosPagosModel

 local cSql

   TEXT INTO cSql

   SELECT 
      pagos_recibos.id AS id,
      pagos_recibos.uuid AS uuid,
      recibos.concepto AS concepto,
      recibos.importe AS importe_recibo,
      pagos_recibos.importe AS importe_pagar,
      ( recibos.importe - SUM( pagos_recibos_realizados.importe ) ) AS diferencia,
      recibos.vencimiento AS vencimiento,
      recibos.expedicion AS expedicion
      
      FROM %1$s AS pagos_recibos

      INNER JOIN %2$s AS recibos
         ON pagos_recibos.recibo_uuid = recibos.uuid
      
      INNER JOIN %3$s AS facturas_clientes
         ON facturas_clientes.uuid = recibos.parent_uuid AND facturas_clientes.cliente_codigo = %4$s

      INNER JOIN %1$s AS pagos_recibos_realizados
         ON pagos_recibos_realizados.recibo_uuid = recibos.uuid

      WHERE pagos_recibos.pago_uuid = %5$s
      
      GROUP BY pagos_recibos.recibo_uuid 

      ORDER BY recibos.vencimiento
      

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLRecibosModel():getTableName() , SQLFacturasClientesModel():getTableName(), quoted( cCodigoCliente ), quoted( uuidPago ) )

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