#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD addExtraButtons()

   METHOD pagosModelLoadedBlankBuffer()
   METHOD pagosModelAppend()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := RecibosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := RecibosView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE( if(empty( ::oRepository ), ::oRepository := RecibosRepository():New( self ), ), ::oRepository )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := RecibosValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLRecibosModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS RecibosController

   ::Super:New( oController )

   ::cTitle                      := "Recibos"

   ::cName                       := "recibos"

   ::lTransactional              := .t.

   ::hImage                      := {  "16" => "gc_briefcase2_user_16",;
                                       "32" => "gc_briefcase2_user_32",;
                                       "48" => "gc_briefcase2_user_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingExitButton', {|| ::addExtraButtons() } )

   ::getPagosController():setEvent( 'appended', {|| ::pagosModelAppend() } )
   
   ::getPagosController():getModel():setEvent( 'loadedBlankBuffer', {|| ::pagosModelLoadedBlankBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS RecibosController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD addExtraButtons() CLASS RecibosController

   ::oNavigatorView:getMenuTreeView():AddButton( "Generar pago", "gc_hand_money_16", {|| ::getPagosController():Append() } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD pagosModelLoadedBlankBuffer() CLASS RecibosController

   local cMedioPagoCodigo
   local cMetodoPagoCodigo
   
   cMetodoPagoCodigo := SQLFacturasClientesModel():getField( "metodo_pago_codigo", "uuid", ::getRowSet():fieldGet( 'parent_uuid' ) )

   cMedioPagoCodigo  := SQLMetodoPagoModel():getField( "codigo_medio_pago", "codigo", cMetodoPagoCodigo )
   
   ::getPagosController():setModelBuffer( 'importe', ::getRowSet():fieldGet( 'diferencia' ) )
   
   ::getPagosController():setModelBuffer( 'cliente_codigo', SQLFacturasClientesModel():getField( "cliente_codigo", "uuid", ::getRowSet():fieldGet( 'parent_uuid' ) ) )

   ::getPagosController():setModelBuffer( 'medio_pago_codigo', cMedioPagoCodigo )

   ::getPagosController():setModelBuffer( 'comentario', ::getRowSet():fieldGet( 'concepto' ) )
  
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD pagosModelAppend() CLASS RecibosController
   
   with object ( ::getRecibosPagosController():getModel() )

      :loadBlankBuffer()

      :setBuffer( "recibo_uuid", ::getRowSet():fieldGet( 'uuid' ) )

      :setBuffer( "pago_uuid", ::getPagosController():getModelBuffer('uuid') )

      :setBuffer( "importe", ::getPagosController():getModelBuffer('importe') ) 

      :insertBuffer()

   end with

   ::getRowset():refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosBrowseView FROM SQLBrowseView

   METHOD addColumns() 

   METHOD Paid()  

   METHOD PaidIcon()                    

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS RecibosBrowseView

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

   with object ( ::oBrowse:AddCol()  )
      :cHeader          := "Estado"
      :bStrData         := {|| ::Paid() }
      :bBmpData         := {|| ::PaidIcon() }
      :nWidth           := 120
      :AddResource( "bullet_square_green_16" )
      :AddResource( "bullet_square_yellow_16" )
      :AddResource( "bullet_square_red_16" )
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_codigo'
      :cHeader             := 'Código cliente'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'cliente_nombre'
      :cHeader             := 'Nombre cliente'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'cliente_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'concepto'
      :cHeader             := 'Concepto'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'concepto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'importe'
      :cHeader             := 'Importe'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.99"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Total pagado'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.99"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_pagado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe restante'
      :nWidth              := 100
      :cEditPicture        := "@E 99,999,999.99"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'diferencia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Paid() CLASS RecibosBrowseView

   if ::getRowSet():fieldGet( 'diferencia' ) == 0
      RETURN ( "Cobrado" )
   end if 

   if ::getRowSet():fieldGet( 'diferencia' ) < ::getRowSet():fieldGet( 'importe' ) 
      RETURN ( "Parcialmente" )
   end if 

RETURN ( "No cobrado" )

//---------------------------------------------------------------------------//

METHOD PaidIcon() CLASS RecibosBrowseView

   if ::getRowSet():fieldGet( 'diferencia' ) == 0
      RETURN ( 1 )
   end if 

   if ::getRowSet():fieldGet( 'diferencia' ) < ::getRowSet():fieldGet( 'importe' )
      RETURN ( 2 )
   end if 

RETURN ( 3 )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosView FROM SQLBaseView
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD defaultTitle()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS RecibosView

    DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "recibo"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Recibo" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ;
      DIALOGS     "RECIBOS_SQL" 

   REDEFINE GET   ::oController:getModel():hBuffer[ "expedicion" ] ;
      ID          100 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "vencimiento" ] ;
      ID          110 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

  REDEFINE GET   ::oController:getModel():hBuffer[ "importe" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 99,999,999.99";
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "concepto" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Botones------------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS RecibosView

   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS RecibosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Incidencias...",;
                        {||::oController:getIncidenciasController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getIncidenciasController():getImage( "16" ) )
   
   oPanel:AddLink(   "Documentos...",;
                        {||::oController:getDocumentosController():activateDialogView( ::oController:getUuid() ) },;
                           ::oController:getDocumentosController():getImage( "16" ) )

   if ::oController:isNotAppendOrDuplicateMode()

      oPanel:AddLink(   "Factura...",;
                        {||::oController:getFacturasClientesController():ZoomUuid( ::oController:getModelBuffer( "parent_uuid" ) ) },;
                           ::oController:getFacturasClientesController():getImage( "16" ) )

      oPanel:AddLink(   "Pagos...",;
                        {|| msgInfo( "to-do" ) },;
                           ::oController:getFacturasClientesController():getImage( "16" ) )

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD defaultTitle() CLASS RecibosView

   local cTitle   

   if empty( ::oController:oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::oController:oModel:hBuffer, "concepto" )
      cTitle      :=  alltrim( ::oController:oModel:hBuffer[ "concepto" ] )
   end if

RETURN ( cTitle )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS RecibosValidator

   ::hValidators  := {  "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "EL código introducido ya existe" },;
                        "nombre" =>    {  "required"           => "El nombre es un dato requerido"    ,;
                                          "unique"             => "El nombre introducido ya existe"   }  }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosModel FROM SQLCompanyModel

   DATA cTableName               INIT "recibos"

   DATA cGroupBy                 INIT "recibos.uuid"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosModel

   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                      "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                      "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                      "default"   => {|| ::getControllerParentUuid() } }           )

   hset( ::hColumns, "parent_table",               {  "create"    => "VARCHAR( 200 )"                             ,;
                                                      "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "expedicion",                 {  "create"    => "DATE"                                       ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "vencimiento",                {  "create"   => "DATE"                                        ,;
                                                      "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "importe",                    {  "create"    => "FLOAT( 16,2 )"                              ,;
                                                      "default"   => {||  0  } }                                  )

   hset( ::hColumns, "concepto",                   {  "create"    => "VARCHAR( 200 )"                              ,;
                                                      "default"   => {|| space( 200 ) } }                          )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLRecibosModel

 local cSql

   TEXT INTO cSql

   SELECT 
      recibos.id AS id,
      recibos.uuid AS uuid,
      recibos.parent_uuid AS parent_uuid,
      recibos.parent_table AS parent_table,
      recibos.expedicion AS expedicion,
      recibos.vencimiento AS vencimiento,
      recibos.importe AS importe,
      recibos.concepto AS concepto,
      clientes.codigo AS cliente_codigo,
      clientes.nombre AS cliente_nombre,
      @total_pagado:=( SELECT %6$s(recibos.uuid) ) AS total_pagado,
      ( recibos.importe - @total_pagado ) AS diferencia
   FROM %1$s AS recibos

   LEFT JOIN %2$s AS pagos_recibos
      ON pagos_recibos.recibo_uuid = recibos.uuid

   LEFT JOIN %3$s AS pagos
      ON pagos.uuid = pagos_recibos.pago_uuid

   INNER JOIN %4$s AS facturas_clientes
      ON recibos.parent_uuid = facturas_clientes.uuid 

   INNER JOIN %5$s AS clientes 
      ON facturas_clientes.cliente_codigo = clientes.codigo AND clientes.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLRecibosPagosModel():getTableName(),;
                           SQLPagosModel():getTableName(),;
                           SQLFacturasClientesModel():getTableName(),;
                           SQLClientesModel():getTableName(),;
                           Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ) )
logwrite(cSql)
RETURN ( cSql )

//---------------------------------------------------------------------------//

CLASS SQLRecibosAssistantModel FROM SQLRecibosModel

   METHOD getInitialSelect()

   METHOD isParentUuidColumn()   INLINE ( .f. )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLRecibosAssistantModel

   local cSql

   local cliente_codigo := ::oController:oController:getModelBuffer( "cliente_codigo" )

   TEXT INTO cSql

   SELECT 
         recibos.id AS id,
         recibos.uuid AS uuid,
         recibos.parent_uuid AS parent_uuid,
         recibos.parent_table AS parent_table,
         recibos.expedicion AS expedicion,
         recibos.vencimiento AS vencimiento,
         recibos.importe AS importe,
         recibos.concepto AS concepto,
         pagos.estado AS estado,
         SUM( pagos_recibos.importe ) AS total_pagado,
         ( recibos.importe - SUM( pagos_recibos.importe ) ) AS diferencia
   
   FROM %1$s AS recibos
   
   INNER JOIN %2$s AS facturas_clientes
      ON recibos.parent_uuid = facturas_clientes.uuid AND facturas_clientes.cliente_codigo = %5$s 
   
   LEFT JOIN %3$s AS pagos_recibos
      ON recibos.uuid = pagos_recibos.recibo_uuid
      
   LEFT JOIN %4$s AS pagos
      ON pagos.uuid = pagos_recibos.pago_uuid AND pagos.estado <> "Rechazado"

   ENDTEXT

   cSql  := hb_strformat( cSql,  ::getTableName(),;
                                 SQLFacturasClientesModel():getTableName(),;
                                 SQLRecibosPagosModel():getTableName(),;
                                 SQLPagosModel():getTableName(),;
                                 quoted( cliente_codigo ) )

   logwrite( cSql )   

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRecibosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//