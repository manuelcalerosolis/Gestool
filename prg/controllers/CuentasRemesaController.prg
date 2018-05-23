#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CuentasRemesaController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   DATA oBancosController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CuentasRemesaController

   ::Super:New( oSenderController )

   ::cTitle                         := "Cuentas de remesa"

   ::cName                          := "cuentas_remesa"

   ::hImage                         := {  "16" => "gc_notebook2_16",;
                                          "32" => "gc_notebook2_32",;
                                          "48" => "gc_notebook2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLCuentasRemesaModel():New( self )

   ::oBrowseView                    := CuentasRemesaBrowseView():New( self )

   ::oDialogView                    := CuentasRemesaView():New( self )

   ::oBancosController              := CuentasBancariasController():new( self )

   ::oValidator                     := CuentasRemesaValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, 'cuentas_remesa' )

   ::oRepository                    := CuentasRemesaRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oBancosController:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oBancosController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oBancosController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oBancosController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oBancosController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oBancosController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oBancosController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CuentasRemesaController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oCamposExtraValoresController:End()

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
      :cSortOrder          := 'cuenta'
      :cHeader             := 'Cuenta bancaria'
      :nWidth              := 300
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( "cuenta" ), "@R NNNN-NNNN-NNNN-NN-NNNNNNNNNNN" ) } 
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

   DATA oSayCamposExtra

   METHOD Activate()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD startActivate()

   ::oController:oBancosController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CuentasRemesaView
   
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CUENTA_REMESA" ;
      TITLE       ::LblTitle() + "cuenta remesa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
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

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          120 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

   //Banco---------------------------------------------------------------------
   ::oController:oBancosController:oDialogView:ExternalRedefine( ::oDialog )

   //-----------------------------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::startActivate() }

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

  METHOD getInitialSelect()

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLCuentasRemesaModel

   local cSelect  := "SELECT cuentas_remesa.id,"                                                               + " " + ;
                        "cuentas_remesa.uuid,"                                                                 + " " + ;
                        "cuentas_remesa.codigo,"                                                               + " " + ;
                        "cuentas_remesa.nombre,"                                                               + " " + ;
                        "CONCAT( cuentas_bancarias.iban_codigo_pais, "                                         + " " + ;  
                        "cuentas_bancarias.iban_digito_control, "                                              + " " + ; 
                        "cuentas_bancarias.cuenta_codigo_entidad, "                                            + " " + ;
                        "cuentas_bancarias.cuenta_codigo_oficina, "                                            + " " + ;
                        "cuentas_bancarias.cuenta_digito_control, "                                            + " " + ;
                        "cuentas_bancarias.cuenta_numero ) AS cuenta"                                          + " " + ;
                     "FROM cuentas_remesa"                                                                     + " " + ;
                        "INNER JOIN cuentas_bancarias ON cuentas_remesa.uuid = cuentas_bancarias.parent_uuid"  + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCuentasRemesaModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )
   ::getEmpresaColumns()


   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR( 3 )"                            ,;
                                                   "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

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
   
   ::getTimeStampColumns()

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

   METHOD getTableName()                  INLINE ( SQLCuentasRemesaModel():getTableName() )


END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
