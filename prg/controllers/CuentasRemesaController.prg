#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CuentasRemesaController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CuentasRemesaController

   ::Super:New()

   ::cTitle                         := "Cuentas de remesa"

   ::cName                          := "cuentas_remesa"

   ::hImage                         := {  "16" => "gc_notebook2_16",;
                                       "32" => "gc_notebook2_32",;
                                       "48" => "gc_notebook2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLCuentasRemesaModel():New( self )

   ::oBrowseView                    := CuentasRemesaBrowseView():New( self )

   ::oDialogView                    := CuentasRemesaView():New( self )

   ::oValidator                     := CuentasRemesaValidator():New( self, ::oDialogView )

   ::oRepository                    := CuentasRemesaRepository():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS CuentasRemesaController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

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

CLASS CuentasRemesaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CuentasRemesaBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
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
      :cSortOrder          := 'cuenta bancaria'
      :cHeader             := 'Cuenta Bancaria'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'iban_codigo_pais' ) + ::getRowSet():fieldGet( 'iban_digito_control' ) + '-' + ::getRowSet():fieldGet( 'cuenta_codigo_entidad' ) + '-' +  ::getRowSet():fieldGet( 'cuenta_codigo_oficina' ) + '-' +  ::getRowSet():fieldGet( 'cuenta_digito_control' ) + '-' +  ::getRowSet():fieldGet( 'cuenta_numero' ) } 
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

CLASS CuentasRemesaView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CuentasRemesaView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CUENTA_REMESA" ;
      TITLE       ::LblTitle() + "cuenta remesa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_notebook2_48" ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( replicate( 'N', 3 ) ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "banco" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "iban_codigo_pais" ] ;
      ID          130 ;
      PICTURE     "@!" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "iban_digito_control" ] ;
      ID          131 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_codigo_entidad" ] ;
      ID          132 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_codigo_oficina" ] ;
      ID          133 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_digito_control" ] ;
      ID          134 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_numero" ] ;
      ID          135 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "sufijo" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_ine" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;


   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_banco" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "cuenta_descuento" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "presentador_codigo" ] ;
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "presentador_iso_pais" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "presentador_nombre" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "presentador_nif" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "acreedor_codigo" ] ;
      ID          220 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "acreedor_iso_pais" ] ;
      ID          230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "acreedor_nombre" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "acreedor_nif" ] ;
      ID          250 ;
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

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasRemesaValidator FROM SQLCompanyValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CuentasRemesaValidator

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCuentasRemesaModel FROM SQLCompanyModel

   DATA cTableName               INIT "cuentas_remesa"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCuentasRemesaModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )
   ::getEmpresaColumns()

   ::getTimeStampColumns()

   hset( ::hColumns, "banco_uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR( 3 )"                            ,;
                                                   "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "banco",                   {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

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

   hset( ::hColumns, "cuenta_numero",           {  "create"    => "VARCHAR( 9 )"                            ,;
                                                   "default"   => {|| space( 9 ) } }                        )

   hset( ::hColumns, "sufijo",                  {  "create"    => "VARCHAR( 3 )"                            ,;
                                                   "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "codigo_ine",              {  "create"    => "VARCHAR( 6 )"                            ,;
                                                   "default"   => {|| space( 6 ) } }                        )

   hset( ::hColumns, "cuenta_banco",            {  "create"    => "VARCHAR( 12 )"                           ,;
                                                   "default"   => {|| space( 12 ) } }                       )

   hset( ::hColumns, "cuenta_descuento",        {  "create"    => "VARCHAR( 12 )"                           ,;
                                                   "default"   => {|| space( 12 ) } }                       )

   hset( ::hColumns, "presentador_codigo",      {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "presentador_iso_pais",    {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "presentador_nombre",      {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "presentador_nif",         {  "create"    => "VARCHAR( 9 )"                            ,;
                                                   "default"   => {|| space( 9 ) } }                        )

   hset( ::hColumns, "acreedor_codigo",         {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "acreedor_iso_pais",       {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "acreedor_nombre",         {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "acreedor_nif",            {  "create"    => "VARCHAR( 9 )"                            ,;
                                                   "default"   => {|| space( 9 ) } }                        )

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

CLASS CuentasRemesaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosTipoModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//