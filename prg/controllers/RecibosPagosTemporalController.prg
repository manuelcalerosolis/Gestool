#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosPagosTemporalController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD updateField( cField, uValue )

   METHOD calculatePayment( nImporte )

   METHOD validateAmount( uValue )

   //Construcciones tardias----------------------------------------------------
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosPagosTemporalModel():New( self ), ), ::oModel ) 

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := RecibosPagosTemporalBrowseView():New( self ), ), ::oBrowseView ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosPagosTemporalController
   
   ::Super:New( oController )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosPagosTemporalController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateField( uValue ) CLASS RecibosPagosTemporalController

   ::validateAmount( uValue )
   
   ::getRowSet():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validateAmount( uValue ) CLASS RecibosPagosTemporalController

   if uValue == ::getRowSet():fieldGet( "importe_pagar" )
      RETURN ( nil )
   end if 

   if uValue > ::getRowSet():fieldGet( "diferencia" )
      msgstop("Importe introducido incorrecto")
      RETURN ( nil )
   end if

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), "importe", uValue )

   ::getRowSet():goTop()

   ::getController():getDialogView():oImporte:cText( ::getModel():getSumImporte() )

   ::getRowSet():Refresh()

   ::getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD calculatePayment( nImporte ) CLASS RecibosPagosTemporalController

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

CLASS RecibosPagosTemporalBrowseView FROM SQLBrowseView

   DATA lFooter            INIT .t.

   DATA nMarqueeStyle      INIT 3

   METHOD addColumns()

   METHOD getEditGet()     INLINE ( if( ::getSuperController():isNotZoomMode(), EDIT_GET, 0 ) )                    

   METHOD PaidIcon()

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RecibosPagosTemporalBrowseView

with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Id'
      :cSortOrder          := 'id'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
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

METHOD PaidIcon() CLASS RecibosPagosTemporalBrowseView

   if ::getRowSet():fieldGet( 'importe_pagar' ) != 0
      RETURN ( 1 )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosPagosTemporalModel FROM SQLCompanyModel

   DATA cTableName               INIT "tmp_recibos_pagos"

   METHOD getColumns()

   METHOD getGeneralSelect( uuidPago )

   METHOD createTemporalTable()

   METHOD dropTemporalTable()

   METHOD deleteTemporal()

   METHOD InsertPagoReciboTemporal( uuidPago, cClienteCodigo )

   METHOD insertRecibosPagos()

   METHOD getSumImporte()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosPagosTemporalModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER UNIQUE"                             ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "recibo_uuid",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "pago_uuid",                  {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 16,2 )"                              ,;
                                                      "default"   => {||  0  } }                                  )

   hset( ::hColumns, "diferencia",                 {  "create"    => "FLOAT( 16,2 )"                              ,;
                                                      "default"   => {||  0  } }                                   )


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD InsertPagoReciboTemporal( uuidPago, cClienteCodigo ) CLASS SQLRecibosPagosTemporalModel

   local cSql

   TEXT INTO cSql

   INSERT INTO %6$s
      ( id, pago_uuid, recibo_uuid, importe, diferencia ) 

   SELECT 
        recibos.id, %8$s, recibos.uuid, 0, (SELECT %7$s( recibos.uuid ) )
   
      FROM %2$s AS recibos
      
      INNER JOIN %3$s AS facturas_clientes
         ON recibos.parent_uuid = facturas_clientes.uuid AND facturas_clientes.cliente_codigo = %9$s
      
      LEFT JOIN %1$s AS pagos_recibos
         ON recibos.uuid = pagos_recibos.recibo_uuid
         
      LEFT JOIN %4$s AS pagos
         ON pagos.uuid = pagos_recibos.pago_uuid
      
      WHERE ( ( SELECT %5$s( recibos.uuid ) ) < recibos.importe ) 
            

      GROUP BY recibos.uuid
   
   ENDTEXT

   cSql  := hb_strformat( cSql,  SQLRecibosPagosModel():getTableName(),;
                                 SQLRecibosModel():getTableName(),;
                                 SQLFacturasClientesModel():getTableName(),;
                                 SQLPagosModel():getTableName(),;
                                 Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ),;
                                 ::getTableName(),;
                                 Company():getTableName( 'RecibosPagosTotalDifferenceWhereUuid' ),;
                                 quoted( uuidPago ),;
                                 quoted( cClienteCodigo ) )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD deleteTemporal() CLASS SQLRecibosPagosTemporalModel

   local cSql

   TEXT INTO cSql

   TRUNCATE TABLE  %1$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( getSQLDatabase():Exec ( cSql ) )

//---------------------------------------------------------------------------//

METHOD insertRecibosPagos() CLASS SQLRecibosPagosTemporalModel

   ::getRecibosPagosModel():InsertPagoRecibo()

   ::dropTemporalTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect( uuidPago, cCodigoCliente ) CLASS SQLRecibosPagosTemporalModel

 local cSql

   TEXT INTO cSql

   SELECT 
      tmp.id AS id,
      tmp.pago_uuid AS pago_uuid,
      tmp.recibo_uuid AS recibo_uuid,
      tmp.diferencia AS diferencia,
      tmp.importe AS importe_pagar,
      recibos.importe AS importe_recibo,
      recibos.vencimiento AS vencimiento,
      recibos.expedicion AS expedicion,
      recibos.concepto AS concepto

   FROM %1$s AS tmp

      INNER JOIN %2$s AS recibos 
         ON recibos.uuid = tmp.recibo_uuid

      
   ENDTEXT

   cSql  := hb_strformat(  cSql, ;
                           ::getTableName(),;
                           SQLRecibosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD createTemporalTable() CLASS SQLRecibosPagosTemporalModel

RETURN ( getSQLDatabase():Exec( ::getCreateTableTemporalSentence( Company() ) ) )

//---------------------------------------------------------------------------//

METHOD dropTemporalTable() CLASS SQLRecibosPagosTemporalModel

local cSql

   TEXT INTO cSql

      DROP TABLE %1$s
      
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName() )

RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD getSumImporte() CLASS SQLRecibosPagosTemporalModel

   local cSql

   TEXT INTO cSql

      SELECT 
         SUM( importe )

      FROM %1$s

   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName() )

RETURN ( getSQLDatabase():getValue( cSql ) )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//