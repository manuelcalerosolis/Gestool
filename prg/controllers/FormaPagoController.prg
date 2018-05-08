#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FormaPagoController FROM SQLNavigatorController

   DATA oBancosController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS FormaPagoController

   ::Super:New()

   ::cTitle                      := "Formas de pago"

   ::cName                       := "forma_pago"

   ::hImage                      := {  "16" => "gc_credit_cards_16",;
                                       "32" => "gc_credit_cards_32",;
                                       "48" => "gc_credit_cards_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLFormaPagoModel():New( self )

   ::oBrowseView                 := FormaPagoBrowseView():New( self )

   ::oDialogView                 := FormaPagoView():New( self )

   ::oBancosController           := CuentasBancariasController():new( self )

   ::oValidator                  := FormaPagoValidator():New( self, ::oDialogView )

   ::oRepository                 := FormaPagoRepository():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS FormaPagoController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oBancosController:End()

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

CLASS FormaPagoBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FormaPagoBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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
      :cSortOrder          := 'tactil'
      :cHeader             := 'Tactil'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'incluir_en_terminal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'posicion'
      :cHeader             := 'Posición'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'posicion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FormaPagoView FROM SQLBaseView

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

   ::oController:oBancosController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FormaPagoView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "FORMA_PAGO" ;
      TITLE       ::LblTitle() + "forma de pago"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_credit_cards_48" ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE RADIO ::oTipoPago ;
      VAR         ::oController:oModel:hBuffer[ "tipo_pago" ] ;
      ID          120, 121, 122 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "comision" ] ;
      ID          130 ;
      SPINNER  ;
      MIN         0;
      PICTURE     "@E 999.99" ;
      WHEN        ( ::oController:isNotZoomMode() ) .AND. ::oController:oModel:hBuffer[ "tipo_pago" ] == 3;
      OF          ::oDialog ;

   REDEFINE RADIO ::oEmitir ;
      VAR         ::oController:oModel:hBuffer[ "emitir" ] ;
      ID          140, 141;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "numero_plazos" ] ;
      ID          150 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "primer_plazo" ] ;
      ID          160 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "entre_plazo" ] ;
      ID          170 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "ultimo_plazo" ] ;
      ID          180 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;
      
   // Banco--------------------------------------------------------------------

   ::oController:oBancosController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "banco_uuid" ] ) )
   
   ::oController:oBancosController:oGetSelector:setEvent( 'validated', {|| ::bancosControllerValidated() } )

   ::oController:oBancosController:oGetSelector:Activate( 190, 191, ::oDialog )

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

   REDEFINE GET   ::oController:oModel:hBuffer[ "subcuenta_cobro" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "subcuenta_gastos" ] ;
      ID          220 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oCodigoPago ;
      VAR         ::oController:oModel:hBuffer[ "codigo_pago" ] ;
      ITEMS       FORMASDEPAGO_ITEMS ;
      ID           230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_edi" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "incluir_en_terminal" ] ;
      ID          250 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE COMBOBOX ::oIcono ;
      VAR         ::oController:oModel:hBuffer[ "icono" ] ;
      ID          260 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( hgetkeys( ::hIcono ) ) ;
      BITMAPS     ( hgetvalues( ::hIcono ) ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "posicion" ] ;
      ID          270 ;
      SPINNER  ;
      MIN         0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "forma_pago" ] ;
      ID          280 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE RADIO ::oGenerar ;
      VAR         ::oController:oModel:hBuffer[ "generar_documento" ] ;
      ID          290, 291;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;


   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD bancosControllerValidated()

   local cCodigo  := ::oController:oModel:hBuffer[ "banco_uuid" ]
   local hColumns := ::oController:oBancosController:oModel:getWhereCodigo( cCodigo )  

   ::oGetIBANCodigoPais:cText( hget( hColumns, "iban_codigo_pais" ) )

   ::oGetIBANDigitoControl:cText( hget( hColumns, "iban_digito_control" ) )

   ::oGetCuentaCodigoEntidad:cText( hget( hColumns, "cuenta_codigo_entidad" ) )

   ::oGetCuentaCodigoOficina:cText( hget( hColumns, "cuenta_codigo_oficina" ) )

   ::oGetCuentaDigitoControl:cText( hget( hColumns, "cuenta_digito_control" ) )

   ::oGetCuentaNumero:cText( hget( hColumns, "cuenta_numero" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
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

   ::hValidators  := {  "nombre " =>               {  "required"           => "El nombre es un dato requerido",;
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

   METHOD getColumns()

   METHOD getBancoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), ::oController:oBancosController:oModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setBancoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", ::oController:oBancosController:oModel():getUuidWhereCodigo( uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFormaPagoModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )
   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 3 )"                               ,;
                                                "default"   => {|| space( 3 ) } }                           )

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

   hset( ::hColumns, "incluir_en_terminal",  {  "create"    => "BIT"                                        ,;
                                                "default"   => {|| .f. } }                                  )

   hset( ::hColumns, "icono",                {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "posicion",             {  "create"    => "INTEGER( 2 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                           )

   hset( ::hColumns, "forma_pago",           {  "create"    => "VARCHAR( 200 )"                             ,;                                  
                                                "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "generar_documento",    {  "create"    => "INTEGER( 1 )"                               ,;
                                                "default"   => {|| ( 0 ) } }                           )
   
   ::getTimeStampColumns()

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
