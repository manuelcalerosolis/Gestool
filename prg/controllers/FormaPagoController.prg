#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FormasPagosController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()     INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := FormaPagoBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()     INLINE ( if( empty( ::oDialogView ), ::oDialogView := FormaPagoView():New( self ), ), ::oDialogView )

   METHOD getValidator()      INLINE ( if( empty( ::oValidator ), ::oValidator := FormaPagoValidator():New( self ), ), ::oValidator )

   METHOD getRepository()     INLINE ( if( empty( ::oRepository ), ::oRepository := FormaPagoRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()          INLINE ( if( empty( ::oModel ), ::oModel := SQLFormaPagoModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FormasPagosController

   ::Super:New( oController )

   ::cTitle                         := "Formas de pago"

   ::cName                          := "forma_pago"

   ::hImage                         := {  "16" => "gc_credit_cards_16",;
                                          "32" => "gc_credit_cards_32",;
                                          "48" => "gc_credit_cards_48" }

   ::nLevel                         := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS FormasPagosController

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

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FormaPagoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FormaPagoBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tactil'
      :cHeader             := 'Tactil'
      :nWidth              := 20
      :nHeadBmpNo          := 3
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tactil' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :SetCheck( { "Sel16", "Nil16" } )
      :AddResource( "Tactil16" )
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'posicion'
      :cHeader             := 'Posición'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'posicion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FormaPagoView FROM SQLBaseView

   DATA oSayCamposExtra

   DATA oTipoPago

   DATA oEmitir
  
   DATA oIcono

   DATA oGenerar

   DATA hIcono

   DATA oCodigoPago

   DATA oGetCodigo

   DATA oGetIBANCodigoPais
   DATA cGetIBANCodigoPais          INIT ""

   DATA oGetIBANDigitoControl
   DATA cGetIBANDigitoControl       INIT ""

   DATA oGetCuentaCodigoEntidad
   DATA cGetCuentaCodigoEntidad     INIT ""

   DATA oGetCuentaCodigoOficina
   DATA cGetCuentaCodigoOficina     INIT ""

   DATA oGetCuentaDigitoControl
   DATA cGetCuentaDigitoControl     INIT ""

   DATA oGetCuentaNumero
   DATA cGetCuentaNumero            INIT ""

   METHOD New()

   METHOD Activate()

   METHOD startActivate()

   METHOD bancosControllerValidated()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS FormaPagoView

   ::Super:New( oController )

   ::hIcono           := { "Dinero"                => "gc_money2_16",;
                           "Tarjeta de credito"    => "gc_credit_cards_16",;
                           "Bolsa de dinero"       => "gc_moneybag_euro_16",;
                           "Porcentaje"            => "gc_symbol_percent_16",;
                           "Cesta de compra"       => "gc_shopping_cart_16" }

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startActivate()

   ::oController:getCuentasBancariasController():oGetSelector():Start()
   
   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FormaPagoView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "FORMA_PAGO_SQL" ;
      TITLE       ::LblTitle() + "forma de pago"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE RADIO ::oTipoPago ;
      VAR         ::oController:getModel():hBuffer[ "tipo_pago" ] ;
      ID          120, 121, 122 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "comision" ] ;
      ID          130 ;
      SPINNER  ;
      MIN         0;
      PICTURE     "@E 999.99" ;
      WHEN        ( ::oController:isNotZoomMode() ) .AND. ::oController:getModel():hBuffer[ "tipo_pago" ] == 3;
      OF          ::oDialog ;

   REDEFINE RADIO ::oEmitir ;
      VAR         ::oController:getModel():hBuffer[ "emitir" ] ;
      ID          140, 141;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "numero_plazos" ] ;
      ID          150 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "primer_plazo" ] ;
      ID          160 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "entre_plazo" ] ;
      ID          170 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "ultimo_plazo" ] ;
      ID          180 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;
      
   // Banco--------------------------------------------------------------------

   ::oController:getCuentasBancariasController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "banco_uuid" ] ) )
   ::oController:getCuentasBancariasController():getSelector():setEvent( 'validated', {|| ::bancosControllerValidated() } )
   ::oController:getCuentasBancariasController():getSelector():Build( { "idGet" => 190, "idText" => 191, "idLink" => 192, "oDialog" => ::oDialog } )

   REDEFINE GET   ::oGetIBANCodigoPais ;
      VAR         ::cGetIBANCodigoPais ; 
      ID          200 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oGetIBANDigitoControl ;
      VAR         ::cGetIBANDigitoControl ;
      ID          201 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oGetCuentaCodigoEntidad ;
      VAR         ::cGetCuentaCodigoEntidad ;
      ID          202 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oGetCuentaCodigoOficina ;
      VAR         ::cGetCuentaCodigoOficina ;
      ID          203 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oGetCuentaDigitoControl ;
      VAR         ::cGetCuentaDigitoControl ;
      ID          204 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oGetCuentaNumero ;
      VAR         ::cGetCuentaNumero ;
      ID          205 ;
      WHEN        ( .f. ) ;
      OF          ::oDialog ;
      

   // Contabilidad-------------------------------------------------------------

   REDEFINE GET   ::oController:getModel():hBuffer[ "subcuenta_cobro" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "subcuenta_gastos" ] ;
      ID          220 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oCodigoPago ;
      VAR         ::oController:getModel():hBuffer[ "codigo_pago" ] ;
      ITEMS       FORMASDEPAGO_ITEMS ;
      ID           230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo_edi" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX   ::oController:getModel():hBuffer[ "tactil" ] ;
      ID          250 ;
      IDSAY       252 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oIcono ;
      VAR         ::oController:getModel():hBuffer[ "icono" ] ;
      ID          260 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetkeys( ::hIcono ) ) ;
      BITMAPS     ( hgetvalues( ::hIcono ) ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "posicion" ] ;
      ID          270 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "forma_pago" ] ;
      ID          280 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE RADIO ::oGenerar ;
      VAR         ::oController:getModel():hBuffer[ "generar_documento" ] ;
      ID          290, 291;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ::redefineExplorerBar( 500 )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ::bancosControllerValidated()

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD bancosControllerValidated() CLASS FormaPagoView

   local hColumns    
   local CodigoBanco    := ::oController:getModel():hBuffer[ "banco_uuid" ]
   
   if empty( CodigoBanco )
      RETURN ( nil )
   end if 

   hColumns          := ::oController:getCuentasBancariasController():getModel():getWhereCodigo( CodigoBanco ) 

   if !( hb_ishash( hColumns ) )
      RETURN ( nil )
   end if 

   ::oGetIBANCodigoPais:cText( hget( hColumns, "iban_codigo_pais" ) )

   ::oGetIBANDigitoControl:cText( hget( hColumns, "iban_digito_control" ) )

   ::oGetCuentaCodigoEntidad:cText( hget( hColumns, "cuenta_codigo_entidad" ) )

   ::oGetCuentaCodigoOficina:cText( hget( hColumns, "cuenta_codigo_oficina" ) )

   ::oGetCuentaDigitoControl:cText( hget( hColumns, "cuenta_digito_control" ) )

   ::oGetCuentaNumero:cText( hget( hColumns, "cuenta_numero" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS FormaPagoView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if

   oPanel:AddLink(   "Documentos...",;
                    {|| ::oController:getDocumentosController():activateDialogView( ::oController:getUuid() ) },;
                     ::oController:getDocumentosController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                     ::oController:getCamposExtraValoresController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FormaPagoValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FormaPagoValidator

   ::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFormaPagoModel FROM SQLCompanyModel

   DATA cTableName               INIT "forma_pago"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getBancoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 40 ), ::oController:getCuentasBancariasController():getModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setBancoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", ::oController:getCuentasBancariasController():getModel():getUuidWhereCodigo( uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFormaPagoModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 20 )"                               ,;
                                                "default"   => {|| space( 20 ) } }                           )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR( 200 )"                             ,;
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "tipo_pago",            {  "create"    => "INTEGER( 1 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "comision",             {  "create"    => "FLOAT( 5,2 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "emitir",               {  "create"    => "INTEGER( 1 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "numero_plazos",        {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "primer_plazo",         {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "entre_plazo",          {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "ultimo_plazo",         {  "create"    => "INTEGER( 5 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "banco_uuid",           {  "create"    => "VARCHAR( 40 )"                              ,;                                  
                                                "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "subcuenta_cobro",      {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "subcuenta_gastos",     {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "codigo_pago",          {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "codigo_edi",           {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "tactil",               {  "create"    => "TINYINT( 1 )"                               ,;
                                                "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "icono",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "posicion",             {  "create"    => "INTEGER( 2 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   hset( ::hColumns, "forma_pago",           {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "generar_documento",    {  "create"    => "INTEGER( 1 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                                )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FormaPagoRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFormaPagoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
