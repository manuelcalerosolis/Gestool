#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CuentasBancariasController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

   DATA oContactosController

   METHOD CalculaIBAN()

   METHOD CalculaDigitoControl()

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CuentasBancariasController

   ::Super:New( oSenderController )

   ::cTitle                      := "Cuentas bancarias"

   ::cName                       := "cuenta_bancaria"

   ::hImage                      := {  "16" => "gc_central_bank_euro_16",;
                                       "32" => "gc_central_bank_euro_32",;
                                       "48" => "gc_central_bank_euro_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLCuentasBancariasModel():New( self )

   ::oBrowseView                 := CuentasBancariasBrowseView():New( self )

   ::oDialogView                 := CuentasBancariasView():New( self )

   ::oValidator                  := CuentasBancariasValidator():New( self, ::oDialogView )

   ::oDireccionesController      := DireccionesController():New( self )
   ::oDireccionesController:oValidator:setDialog( ::oDialogView )

   ::oRepository                 := CuentasBancariasRepository():New( self )

   ::oPaisesController           := PaisesController():New( self )

   ::oProvinciasController       := ProvinciasController():New( self )

   ::oContactosController        := ContactosController():New( self )
   ::oContactosController:oValidator:setDialog( ::oDialogView )

   /*::oComboSelector              := ComboSelector():New( self )*/

   ::oGetSelector                := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oContactosController:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oContactosController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oContactosController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oContactosController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oContactosController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oContactosController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oContactosController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CalculaIBAN()

   lIbanDigit( ::oModel:hBuffer[ "iban_codigo_pais" ],;
               ::oModel:hBuffer[ "cuenta_codigo_entidad" ] ,;
               ::oModel:hBuffer[ "cuenta_codigo_oficina" ],;
               ::oModel:hBuffer[ "cuenta_digito_control" ],;
               ::oModel:hBuffer[ "cuenta_numero" ],;
               ::oDialogView:oIBAN ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CalculaDigitoControl()

   lCalcDC( ::oModel:hBuffer[ "cuenta_codigo_entidad" ],;
            ::oModel:hBuffer[ "cuenta_codigo_oficina" ],;
            ::oModel:hBuffer[ "cuenta_digito_control" ],;
            ::oModel:hBuffer[ "cuenta_numero" ],;
            ::oDialogView:oDigitoControl )

   ::oDialogView:oIBAN:lValid() 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD End() CLASS CuentasBancariasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oDireccionesController:End()

   ::oRepository:End()

   ::oPaisesController:End()

   ::oProvinciasController:End()

   ::oContactosController:End()

   ::oGetSelector :End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasBancariasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CuentasBancariasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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
      :cSortOrder          := 'sucursal'
      :cHeader             := 'Sucursal'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'sucursal' ) }
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

CLASS CuentasBancariasView FROM SQLBaseView
  
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais
   DATA oGetDni

   DATA oIBAN 
   DATA oDigitoControl

   METHOD Activate()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CuentasBancariasView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "BANCOS_SQL" ;
      TITLE       ::LblTitle() + "cuenta bancaria"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_central_bank_euro_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "sucursal" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "iban_codigo_pais" ] ;
      ID          130 ;
      PICTURE     "@!" ;
      VALID       ::oController:CalculaIBAN() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET    ::oIBAN  ;
      VAR         ::oController:oModel:hBuffer[ "iban_digito_control" ] ;
      ID          131 ;
      VALID       ::oController:CalculaIBAN() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_codigo_entidad" ] ;
      ID          132 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_codigo_oficina" ] ;
      ID          133 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oDigitoControl ;
      VAR         ::oController:oModel:hBuffer[ "cuenta_digito_control" ];
      ID          134 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_numero" ] ;
      ID          135 ;
      VALID      ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oDialog )

   ::oController:oContactosController:oDialogView:ExternalRedefine( ::oDialog )

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart  := {|| ::oController:oDireccionesController:oDialogView:StartDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasBancariasValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CuentasBancariasValidator

   ::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El código es un dato requerido" ,;
                                                      "unique"             => "EL código introducido ya existe"  } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCuentasBancariasModel FROM SQLCompanyModel

   DATA cTableName               INIT "cuentas_bancarias"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCuentasBancariasModel
   
   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                                   "default"   => {|| win_uuidcreatestring() } }            )
   ::getEmpresaColumns()

   ::getTimeStampColumns()

   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR(3) NOT NULL UNIQUE"             ,;
                                                   "default"   => {|| space( 3 ) } } )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 140 )"                          ,;
                                                   "default"   => {|| space( 140 ) } }                       )

   hset( ::hColumns, "sucursal",                {  "create"    => "VARCHAR( 20 )"                          ,;
                                                   "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "entidad",                 { "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "iban_codigo_pais",        {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "iban_digito_control",     {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "cuenta_codigo_entidad",   {  "create"    => "VARCHAR( 4 )"                            ,;
                                                   "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "cuenta_codigo_oficina",   {  "create"    => "VARCHAR( 4 )"                            ,;
                                                   "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "cuenta_digito_control",   {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "cuenta_numero",           {  "create"    => "VARCHAR( 10 )"                            ,;
                                                   "default"   => {|| space( 10 ) } }                        )

   hset( ::hColumns, "oficina",                 { "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "contacto",                { "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

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

CLASS CuentasBancariasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCuentasBancariasModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )


END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS CuentasBancariasRepository

   local aNombres    := ::getDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )
   local aResult     := {}

   if !empty( aNombres )
      aeval( aNombres, {| h | aadd( aResult, alltrim( hGet( h, "nombre" ) ) ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//