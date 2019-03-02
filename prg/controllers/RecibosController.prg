#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS RecibosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD addExtraButtons()

   METHOD pagosModelLoadedBlankBuffer()

   METHOD pagosModelAppend()

   METHOD generatePayIfHasDiference()

   METHOD getImporte()           INLINE ( round( ::getRowSet():fieldGet( 'diferencia' ), 2 ) )

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

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingDeleteButton',     { || .f. } )
   ::getNavigatorView():getMenuTreeView():setEvent( 'addingShowDeleteButton', { || .f. } )

   ::getNavigatorView():getMenuTreeView():setEvent( 'addingExitButton', {|| ::addExtraButtons() } )

   ::getBrowseView:setEvent( 'activatedDialog', {|| ::getBrowseView:refresh() } )

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

   ::oNavigatorView:getMenuTreeView():AddButton( "Generar pago", "gc_hand_money_16", {|| ::generatePayIfHasDiference() } ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD generatePayIfHasDiference() CLASS RecibosController

   if ::getRowSet():fieldGet( 'diferencia' ) > 0
      
      ::getPagosController():setUuidRecibo( ::getRowset():fieldGet( 'uuid' ) )

      ::getPagosController():Append()
      
      RETURN ( nil )
   
   end if

   msgstop( "El recibo seleccionado ya est� totalmente pagado" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD pagosModelLoadedBlankBuffer() CLASS RecibosController

   local cMedioPagoCodigo
   local cMetodoPagoCodigo
   
   cMetodoPagoCodigo := SQLFacturasVentasModel():getField( "metodo_pago_codigo", "uuid", ::getRowSet():fieldGet( 'parent_uuid' ) )

   cMedioPagoCodigo  := SQLMetodoPagoModel():getField( "codigo_medio_pago", "codigo", cMetodoPagoCodigo )
   
   ::getPagosController():setModelBuffer( 'importe', ::getRowSet():fieldGet( 'diferencia' ) )
   
   ::getPagosController():setModelBuffer( 'tercero_codigo', SQLFacturasVentasModel():getField( "tercero_codigo", "uuid", ::getRowSet():fieldGet( 'parent_uuid' ) ) )

   ::getPagosController():setModelBuffer( 'medio_pago_codigo', cMedioPagoCodigo )

   ::getPagosController():setModelBuffer( 'comentario', ::getRowSet():fieldGet( 'concepto' ) )
  
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD pagosModelAppend() CLASS RecibosController
   
   with object ( ::getRecibosPagosController():getModel() )

      :loadBlankBuffer()

      :setBuffer( "recibo_uuid", ::getRowSet():fieldGet( 'uuid' ) )

      :setBuffer( "pago_uuid", ::getPagosController():getModelBuffer( 'uuid' ) )

      :setBuffer( "importe", ::getPagosController():getImporte() ) 

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

   DATA lFastEdit                      INIT .t.

   DATA nMarqueeStyle                  INIT 3

   DATA nColSel                        INIT 2

   DATA lDeletedColored                INIT .f.

   METHOD addColumns() 

   METHOD Paid()  

   METHOD paidIcon()

   METHOD hasFooter()                  INLINE ( !empty( ::oController:oController ) )

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
      :cHeader             := 'Expedici�n'
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
      :cHeader          := "Tipo"
      :bStrData         := {|| ::getRowSet():fieldGet( 'tipo' ) }
      :nWidth           := 120
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
      :cSortOrder          := 'importe'
      :cHeader             := 'Importe'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.99"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'importe' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      
      if ::hasFooter()
         :nFootStyle       := :nDataStrAlign               
         :nFooterType      := AGGR_SUM
         :cFooterPicture   := :cEditPicture
         :oFooterFont      := oFontBold()
         :cDataType        := "N"
      end if

   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Total pagado'
      :nWidth              := 80
      :cEditPicture        := "@E 99,999,999.99"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'total_pagado' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }

      if ::hasFooter()
         :nFootStyle       := :nDataStrAlign               
         :nFooterType      := AGGR_SUM
         :cFooterPicture   := :cEditPicture
         :oFooterFont      := oFontBold()
         :cDataType        := "N"
      end if

   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Importe restante'
      :nWidth              := 100
      :cEditPicture        := "@E 99,999,999.99"
      :bEditValue          := {|| ::getRowSet():fieldGet( 'diferencia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }

      if ::hasFooter()
         :nFootStyle       := :nDataStrAlign               
         :nFooterType      := AGGR_SUM
         :cFooterPicture   := :cEditPicture
         :oFooterFont      := oFontBold()
         :cDataType        := "N"
         :lHide            := .t.
      end if

   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tercero_codigo'
      :cHeader             := 'C�digo tercero'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tercero_codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tercero_nombre'
      :cHeader             := 'Nombre tercero'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tercero_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'concepto'
      :cHeader             := 'Concepto'
      :nWidth              := 400
      :bEditValue          := {|| ::getRowSet():fieldGet( 'concepto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Paid() CLASS RecibosBrowseView

   if round( ::getRowSet():fieldGet( 'diferencia' ), 2 ) == 0.00
      RETURN ( "Cobrado" ) 
   end if 

   if round( ::getRowSet():fieldGet( 'diferencia' ), 2 ) < round( ::getRowSet():fieldGet( 'importe' ), 2 ) 
      RETURN ( "Parcialmente" )
   end if 

RETURN ( "No cobrado" )

//---------------------------------------------------------------------------//

METHOD PaidIcon() CLASS RecibosBrowseView

   if round( ::getRowSet():fieldGet( 'diferencia' ), 2 ) == 0.00
      RETURN ( 1 )
   end if 

   if round( ::getRowSet():fieldGet( 'diferencia' ), 2 ) < round( ::getRowSet():fieldGet( 'importe' ), 2 ) 
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

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | {|| ::closeActivate() } }
   
   ::oDialog:bStart     := {|| ::startActivate() }

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
                        {||::oController:getFacturasVentasController():ZoomUuid( ::oController:getModelBuffer( "parent_uuid" ) ) },;
                           ::oController:getFacturasVentasController():getImage( "16" ) )

      oPanel:AddLink(   "Pagos...",;
                        {|| msgInfo( "to-do" ) },;
                           ::oController:getPagosController():getImage( "16" ) )

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
      cTitle      := alltrim( ::oController:oModel:hBuffer[ "concepto" ] )
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

   ::hValidators  := {  "codigo" =>    {  "required"           => "El c�digo es un dato requerido" ,;
                                          "unique"             => "EL c�digo introducido ya existe" },;
                        "nombre" =>    {  "required"           => "El nombre es un dato requerido"    ,;
                                          "unique"             => "El nombre introducido ya existe"   }  }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosModel FROM SQLCompanyModel

   DATA cTableName                     INIT "recibos"

   DATA cGroupBy                       INIT "recibos.uuid"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getDiferencia( uuidRecibo )

   METHOD countRecibos() 

   #ifdef __TEST__

   METHOD test_create_recibo()

   METHOD test_create_recibo_con_parent( uuid, parent_uuid )

   #endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLRecibosModel

   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                          "text"      => "Identificador"                              ,;
                                          "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;                                 
                                          "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",    {  "create"    => "VARCHAR ( 40 )"                             ,;
                                          "default"   => {|| ::getControllerParentUuid() } }          )

   hset( ::hColumns, "tipo",           {  "create"    => "ENUM ( 'Cobro', 'Pago' )"                   ,;
                                          "text"      => "Tipo"                                       ,;
                                          "default"   => {|| 'Cobro' }  }                             )

   hset( ::hColumns, "expedicion",     {  "create"    => "DATE"                                       ,;
                                          "text"      => "Expedici�n"                                 ,;
                                          "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "vencimiento",    {  "create"    => "DATE"                                       ,;
                                          "text"      => "Vencimiento"                                ,;
                                          "default"   => {|| hb_date() } }                            )

   hset( ::hColumns, "importe",        {  "create"    => "FLOAT ( 16,2 )"                             ,;
                                          "text"      => "Importe"                                    ,;
                                          "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "concepto",       {  "create"    => "VARCHAR ( 200 )"                            ,;
                                          "text"      => "Concepto"                                   ,;
                                          "default"   => {|| space( 200 ) } }                         )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLRecibosModel

   local cSql

   TEXT INTO cSql

   SELECT 
      recibos.id AS id,
      recibos.uuid AS uuid,
      recibos.parent_uuid AS parent_uuid,
      recibos.tipo AS tipo,
      recibos.expedicion AS expedicion,
      recibos.vencimiento AS vencimiento,
      recibos.concepto AS concepto,
      recibos.importe AS importe,
      recibos.total_pagado AS total_pagado,
      ( recibos.importe - recibos.total_pagado ) AS diferencia,
      recibos.tercero_codigo AS tercero_codigo,
      terceros.nombre AS tercero_nombre

   FROM
      (
      SELECT 
         raw.id AS id,
         raw.uuid AS uuid,
         raw.parent_uuid AS parent_uuid,
         raw.tipo AS tipo,
         raw.expedicion AS expedicion,
         raw.vencimiento AS vencimiento,
         raw.importe AS importe,
         raw.concepto AS concepto,
         raw.deleted_at,
         ( SELECT %7$s( raw.uuid ) ) AS total_pagado,
         ( SELECT %8$s( raw.parent_uuid ) ) AS tercero_codigo

      FROM %1$s AS raw
      ) AS recibos

   LEFT JOIN %2$s AS pagos_recibos
      ON pagos_recibos.recibo_uuid = recibos.uuid

   LEFT JOIN %3$s AS pagos
      ON pagos.uuid = pagos_recibos.pago_uuid

   LEFT JOIN %6$s AS terceros 
      ON terceros.codigo = recibos.tercero_codigo AND terceros.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat(  cSql,;
                           ::getTableName(),;
                           SQLRecibosPagosModel():getTableName(),;
                           SQLPagosModel():getTableName(),;
                           SQLFacturasVentasModel():getTableName(),;
                           SQLFacturasVentasRectificativasModel():getTableName(),;
                           SQLTercerosModel():getTableName(),;
                           Company():getTableName( 'RecibosPagosTotalPaidWhereUuid' ),;
                           Company():getTableName( 'RecibosTerceroCodigoWhereUuid' ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getDiferencia( uuidRecibo ) CLASS SQLRecibosModel 
   
   local nImporte    := ::getColumnWhereUuid( uuidRecibo, "importe" )

   nImporte          -= RecibosPagosRepository():selectFunctionTotalPaidWhereUuid( uuidRecibo )

RETURN ( nImporte )

//---------------------------------------------------------------------------//

METHOD countRecibos() CLASS SQLRecibosModel

   local cSql

   TEXT INTO cSql

      SELECT 
         COUNT(*)  
      FROM %1$s
       
   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName() )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_recibo( uuid ) CLASS SQLRecibosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "uuid", uuid )
   hset( hBuffer, "importe", 100 )
   hset( hBuffer, "concepto", "Recibo test" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_recibo_con_parent( parent_uuid ) CLASS SQLRecibosModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "importe", 100 )
   hset( hBuffer, "parent_uuid", parent_uuid )
   hset( hBuffer, "concepto", "Recibo test" )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLRecibosAssistantModel FROM SQLRecibosModel

   METHOD getInitialSelect()

   METHOD isParentUuidColumn()   INLINE ( .f. )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLRecibosAssistantModel

   local cSql

   local tercero_codigo := ::oController:oController:getModelBuffer( "tercero_codigo" )

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
   
   INNER JOIN %2$s AS facturas_ventas
      ON recibos.parent_uuid = facturas_ventas.uuid AND facturas_ventas.tercero_codigo = %5$s 
   
   LEFT JOIN %3$s AS pagos_recibos
      ON recibos.uuid = pagos_recibos.recibo_uuid
      
   LEFT JOIN %4$s AS pagos
      ON pagos.uuid = pagos_recibos.pago_uuid AND pagos.estado <> "Rechazado"

   ENDTEXT

   cSql  := hb_strformat( cSql,  ::getTableName(),;
                                 SQLFacturasVentasModel():getTableName(),;
                                 SQLRecibosPagosModel():getTableName(),;
                                 SQLPagosModel():getTableName(),;
                                 quoted( tercero_codigo ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS RecibosRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLRecibosModel():getTableName() ) 

   METHOD getSQLFunctions()            INLINE ( {  ::dropFunctionTerceroCodigoWhereUuid(),;
                                                   ::createFunctionTerceroCodigoWhereUuid() } )

   METHOD getSentenceImporteWhereDocumentUuid( uuidDocument ) 

   METHOD getImporteWhereDocumentUuid( uuidDocument ) ;
                                       INLINE ( getSQLDatabase():getValue( ::getSentenceImporteWhereDocumentUuid( uuidDocument ), 0 ) )

   METHOD getSentenceLastNoPaidWhereDocumentUuid( uuidDocument )

   METHOD getLastNoPaidWhereDocumentUuid( uuidDocument ) ;
                                       INLINE ( getSQLDatabase():getValue( ::getSentenceLastNoPaidWhereDocumentUuid( uuidDocument ) ) )

   METHOD getSentenceCountWhereDocumentUuid( uuidDocument )

   METHOD getCountWhereDocumentUuid( uuidDocument ) ;
                                       INLINE ( getSQLDatabase():getValue( ::getSentenceCountWhereDocumentUuid( uuidDocument ), 0 ) )

   METHOD dropFunctionTerceroCodigoWhereUuid()

   METHOD createFunctionTerceroCodigoWhereUuid( uuidDocumento )

END CLASS

//---------------------------------------------------------------------------//

METHOD getSentenceImporteWhereDocumentUuid( uuidDocument ) CLASS RecibosRepository

   local cSql

   TEXT INTO cSql

   SELECT 
      SUM( recibos.importe ) 

   FROM %1$s AS recibos

      WHERE recibos.parent_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidDocument ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSentenceCountWhereDocumentUuid( uuidDocument ) CLASS RecibosRepository

   local cSql

   TEXT INTO cSql

   SELECT 
      COUNT(*) 

   FROM %1$s AS recibos

      WHERE recibos.parent_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidDocument ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSentenceLastNoPaidWhereDocumentUuid( uuidDocument ) CLASS RecibosRepository

   local cSql

   TEXT INTO cSql

   SELECT 
      recibos.uuid 

   FROM %1$s AS recibos

      LEFT JOIN %2$s AS recibos_pagos
         ON recibos_pagos.recibo_uuid = recibos.uuid

      LEFT JOIN %3$s AS pagos
         ON pagos.uuid = recibos_pagos.pago_uuid

      WHERE recibos.parent_uuid = %4$s
         AND IFNULL( recibos_pagos.importe, 0 ) = 0 
         AND IFNULL( pagos.estado, '' ) <> 'Presentado'

      ORDER BY recibos.id DESC LIMIT 1

   ENDTEXT

   cSql  := hb_strformat(  cSql, ::getTableName(), SQLRecibosPagosModel():getTableName(), SQLPagosModel():getTableName(), quoted( uuidDocument ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD dropFunctionTerceroCodigoWhereUuid() CLASS RecibosRepository  

RETURN ( "DROP FUNCTION IF EXISTS " + Company():getTableName( 'RecibosTerceroCodigoWhereUuid' ) + ";" )

//---------------------------------------------------------------------------//

METHOD createFunctionTerceroCodigoWhereUuid( uuidDocumento ) CLASS RecibosRepository  

   local cSql

   TEXT INTO cSql

   CREATE DEFINER=`root`@`localhost` 
   FUNCTION %1$s ( `uuid_documento` CHAR( 40 ) )
   RETURNS CHAR( 20 )
   LANGUAGE SQL
   NOT DETERMINISTIC
   CONTAINS SQL
   SQL SECURITY DEFINER
   COMMENT ''

   BEGIN

      DECLARE terceroCodigo CHAR( 20 );

      SELECT ventas.tercero_codigo INTO terceroCodigo

         FROM 
            (
               SELECT tercero_codigo FROM %2$s WHERE uuid = uuid_documento
               UNION
               SELECT tercero_codigo FROM %3$s WHERE uuid = uuid_documento 
               UNION
               SELECT tercero_codigo FROM %4$s WHERE uuid = uuid_documento
               UNION
               SELECT tercero_codigo FROM %5$s WHERE uuid = uuid_documento 
               UNION
               SELECT tercero_codigo FROM %6$s WHERE uuid = uuid_documento
   
            ) AS ventas

      LIMIT 1;

      RETURN terceroCodigo;

   END

   ENDTEXT

   cSql  := hb_strformat(  cSql,; 
                           Company():getTableName( 'RecibosTerceroCodigoWhereUuid' ),;
                           SQLFacturasVentasModel():getTableName(),;
                           SQLFacturasVentasRectificativasModel():getTableName(),;
                           SQLFacturasVentasSimplificadasModel():getTableName(),;
                           SQLFacturasComprasModel():getTableName(),;
                           SQLfacturasComprasRectificativasModel():getTableName )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//