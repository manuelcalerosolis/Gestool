#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DivisasMonetariasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := DivisasMonetariasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := DivisasMonetariasView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := DivisasMonetariasValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := DivisasMonetariasRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel  := SQLDivisasMonetariasModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DivisasMonetariasController

   ::Super:New()

   ::cTitle                      := "Divisas monetarias"

   ::cName                       := "divisas_monetarias"

   ::hImage                      := {  "16" => "gc_currency_euro_16",;
                                       "32" => "gc_currency_euro_32",;
                                       "48" => "gc_currency_euro_48" }

   ::nLevel                         := Auth():Level( ::cName )


RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS DivisasMonetariasController
   
   if !empty(::oModel)
      ::oModel:End()
   end if

   if !empty(::oBrowseView)
      ::oBrowseView:End()
   end if

   if !empty(::oDialogView)
      ::oDialogView:End()
   end if

   if !empty(::oValidator)
      ::oValidator:End()
   end if

   if !empty(::oRepository)
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

CLASS DivisasMonetariasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DivisasMonetariasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
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
      :cSortOrder          := 'valor'
      :cHeader             := 'Valor en pesetas'
      :nWidth              := 120
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'valor_pesetas' ), "@E 999,999.999999" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'valor_euros'
      :cHeader             := 'Valor en euros'
      :nWidth              := 120
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'valor_euros' ), "@E 999,999.999999" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'simbolo'
      :cHeader             := 'S�mbolo'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'simbolo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DivisasMonetariasView FROM SQLBaseView

   DATA oSayCamposExtra

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DivisasMonetariasView

   local oBmpGeneral 

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DIVISA_MONETARIA" ;
      TITLE       ::LblTitle() + "divisa monetaria"

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

   REDEFINE GET   ::oController:getModel():hBuffer[ "valor_pesetas" ] ;
      ID          120 ;
      PICTURE     "@E 999,999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "valor_euros" ] ;
      ID          130 ;
      PICTURE     "@E 999,999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "simbolo" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX ::oController:getModel():hBuffer[ "texto_masculino" ] ;
      ID          150 ;
      IDSAY       152 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "precio_compra_entero" ] ;
      ID          160 ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "precio_compra_decimal" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "precio_compra_redondeo" ] ;
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "precio_venta_entero" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "precio_venta_decimal" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "precio_venta_redondeo" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "punto_verde_entero" ] ;
      ID          220 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "punto_verde_decimal" ] ;
      ID          230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "punto_verde_redondeo" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          250 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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

CLASS DivisasMonetariasValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DivisasMonetariasValidator

   ::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido",;
                                                      "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>                {  "required"           => "El c�digo es un dato requerido" ,;
                                                      "unique"             => "EL c�digo introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDivisasMonetariasModel FROM SQLCompanyModel

   DATA cTableName               INIT "divisas_monetarias"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDivisasMonetariasModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR ( 20 )"                            ,;
                                                   "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR ( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "valor_pesetas",           {  "create"    => "FLOAT( 14,6 )"                           ,;
                                                   "default"   =>{|| 0 } }                                  )

   hset( ::hColumns, "valor_euros",             {  "create"    => "FLOAT( 14,6 )"                           ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "simbolo",                 {  "create"    => "VARCHAR( 3 )"                            ,;
                                                   "default"   => {|| space( 3) } }                         )

   hset( ::hColumns, "texto_masculino",         {  "create"    => "TINYINT( 1 )"                            ,;
                                                   "default"   => {|| .f. } }                               )

   hset( ::hColumns, "precio_compra_entero",    {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_compra_decimal",   {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_compra_redondeo",  {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_venta_entero",     {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_venta_decimal",    {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "precio_venta_redondeo",   {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "punto_verde_entero",      {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "punto_verde_decimal",     {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "punto_verde_redondeo",    {  "create"    => "INTEGER"                                 ,;
                                                   "default"   => {|| 0 } }                                 )

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

CLASS DivisasMonetariasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLRutasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//