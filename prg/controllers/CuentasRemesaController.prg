#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CuentasRemesaController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := CuentasRemesaBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := CuentasRemesaView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE(if(empty( ::oRepository ), ::oRepository := CuentasRemesaRepository():New( self ), ), ::oRepository )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := CuentasRemesaValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLCuentasRemesaModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CuentasRemesaController

   ::Super:New( oController )

   ::cTitle                         := "Cuentas de remesa"

   ::cName                          := "cuentas_remesa"

   ::hImage                         := {  "16" => "gc_notebook2_16",;
                                          "32" => "gc_notebook2_32",;
                                          "48" => "gc_notebook2_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getModel():setEvent( 'loadedBlankBuffer',            {|| ::getCuentasBancariasController():loadBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',               {|| ::getCuentasBancariasController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',          {|| ::getCuentasBancariasController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                {|| ::getCuentasBancariasController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getCuentasBancariasController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',        {|| ::getCuentasBancariasController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection',             {|| ::getCuentasBancariasController():deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CuentasRemesaController

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

RETURN ( nil )

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

   ::oController:getCuentasBancariasController():getSelector():Start()

RETURN ( nil )

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

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          120 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   //Banco---------------------------------------------------------------------

   ::oController:getCuentasBancariasController():getDialogView():ExternalRedefine( ::oDialog )

   //-----------------------------------------------------------------------------

   REDEFINE GET   ::oController:getModel():hBuffer[ "sufijo" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo_ine" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;


   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_banco" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_descuento" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "presentador_codigo" ] ;
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "presentador_iso_pais" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "presentador_nombre" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "presentador_nif" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "acreedor_codigo" ] ;
      ID          220 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "acreedor_iso_pais" ] ;
      ID          230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "acreedor_nombre" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "acreedor_nif" ] ;
      ID          250 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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

CLASS CuentasRemesaValidator FROM SQLBaseValidator

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

   METHOD getCuentasBancariasTablename()           INLINE( SQLCuentasBancariasModel():getTableName() )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLCuentasRemesaModel

   local cSelect  := "SELECT remesa.id,"                                                               + " " + ;
                        "remesa.uuid,"                                                                         + " " + ;
                        "remesa.codigo,"                                                                       + " " + ;
                        "remesa.nombre,"                                                                       + " " + ;
                        "CONCAT( bancaria.iban_codigo_pais, "                                         + " " + ;  
                        "bancaria.iban_digito_control, "                                              + " " + ; 
                        "bancaria.cuenta_codigo_entidad, "                                            + " " + ;
                        "bancaria.cuenta_codigo_oficina, "                                            + " " + ;
                        "bancaria.cuenta_digito_control, "                                            + " " + ;
                        "bancaria.cuenta_numero ) AS cuenta"                                          + " " + ;
                     "FROM " + ::getTableName() + " AS remesa"                                                   + " " + ;
                        "INNER JOIN " + ::getCuentasBancariasTablename() +" AS bancaria ON remesa.uuid = bancaria.parent_uuid"  + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCuentasRemesaModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )


   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR( 20 )"                            ,;
                                                   "default"   => {|| space( 20 ) } }                        )

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
