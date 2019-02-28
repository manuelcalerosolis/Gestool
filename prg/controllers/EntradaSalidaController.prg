#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EntradaSalidaController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := EntradaSalidaBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := EntradaSalidaView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE(if(empty( ::oRepository ), ::oRepository := EntradaSalidaRepository():New( self ), ), ::oRepository )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := EntradaSalidaValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLEntradaSalidaModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS EntradaSalidaController

   ::Super:New()

   ::cTitle                      := "Entradas y salidas"

   ::cName                       := "entradas_salidas"

   ::hImage                      := {  "16" => "gc_cash_register_refresh_16",;
                                       "32" => "gc_cash_register_refresh_32",;
                                       "48" => "gc_cash_register_refresh_48" }

   ::nLevel                         := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EntradaSalidaController

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

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntradaSalidaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS EntradaSalidaBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tipo'
      :cHeader             := 'Tipo'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sesion'
      :cHeader             := 'Sesión'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'sesion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_caja'
      :cHeader             := 'Código Caja'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_caja' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

  with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre_caja'
      :cHeader             := 'Nombre caja'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_caja' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntradaSalidaView FROM SQLBaseView

   DATA oSayCamposExtra

   DATA oTipo

   DATA aTipo INIT { "Entrada", "Salida" }

   METHOD StartActivate()
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EntradaSalidaView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENTRADA_SALIDA" ;
      TITLE       ::LblTitle() + "Entrada o salida de caja"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:getModel():hBuffer[ "tipo" ] ;
      ID          100 ;
      ITEMS       ::aTipo;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "importe" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "importe" ) ) ;
      SPINNER ;
      PICTURE     "@E 9999999.999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          120 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "sesion" ] ;
      ID          130 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;
   // codigo caja-------------------------------------------------------------------------------------------------------//

   ::oController:getCajasController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "caja_codigo" ] ) )
   
   /*::oController:getCajasController():oGetSelector:setEvent( 'validated', {|| ::CajasControllerValidated() } )*/

   ::oController:getCajasController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oDialog } )

   // cliente------------------------------------------------------------------------------------------------------------//
  
  REDEFINE GET   ::oController:getModel():hBuffer[ "fecha_hora" ] ;
      ID          150 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

      ::redefineExplorerBar( 160 )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER
   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS EntradaSalidaView

   local oPanel                  := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                         ::oController:getCamposExtraValoresController():getImage( "16" ) )

   oPanel:AddLink(   "Documentos...",;
                     {|| ::oController:getDocumentosController():activateDialogView() },;
                         ::oController:getDocumentosController():getImage( "16" ) )

   ::oController:getCajasController():getSelector():Start()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntradaSalidaValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS EntradaSalidaValidator

   ::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido"    ,;
                                                      "unique"             => "El nombre introducido ya existe"   },;
                        "tipos"  =>                {  "required"           => "El tipo es un datos requerido"     },;
                        "Importe"  =>              {  "required"           => "El importe es un datos requerido"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLEntradaSalidaModel FROM SQLCompanyModel

   DATA cTableName               INIT "cajas_entradas_salidas"

   DATA cConstraints             INIT "PRIMARY KEY ( nombre, deleted_at )"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLEntradaSalidaModel

   local cSql

   TEXT INTO cSql

   SELECT cajas_entradas_salidas.id AS id,
      cajas_entradas_salidas.uuid AS uuid,
      cajas_entradas_salidas.sesion AS sesion,
      cajas_entradas_salidas.nombre AS nombre,
      cajas_entradas_salidas.fecha_hora AS fecha_hora,
      cajas_entradas_salidas.caja_codigo AS codigo,
      cajas_entradas_salidas.tipo AS tipo,
      cajas_entradas_salidas.importe AS importe,
      cajas_entradas_salidas.delegacion_uuid AS delegacion_uuid,
      cajas_entradas_salidas.deleted_at AS deleted_at,
      cajas.codigo AS codigo_caja,
      cajas.nombre AS nombre_caja


   FROM %1$s AS cajas_entradas_salidas
      
      INNER JOIN %2$s AS cajas 
         ON cajas_entradas_salidas.caja_codigo = cajas.codigo

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLCajasModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLEntradaSalidaModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "sesion",            {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "fecha_hora",        {  "create"    => "TIMESTAMP"                               ,;
                                             "default"   => {|| hb_datetime() } }                      )

   hset( ::hColumns, "caja_codigo",       {  "create"   => "VARCHAR ( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "tipo",              {  "create"     => "ENUM( 'Entrada', 'Salida' )"             ,;
                                             "default"    => {|| 'Entrada' }  }                        )

   hset( ::hColumns, "importe",           {  "create"     => "FLOAT( 10, 3 )"                          ,;
                                             "default"    => {|| 0  } }                                )

   hset( ::hColumns, "delegacion_uuid",   {  "create"   => "VARCHAR ( 40 )"                            ,;
                                             "default"   => {|| space( 40 ) } }                        )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntradaSalidaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLEntradaSalidaModel():getTableName() ) 

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//