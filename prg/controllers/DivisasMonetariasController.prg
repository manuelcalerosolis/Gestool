#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DivisasMonetariasController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

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

   ::oModel                         := SQLDivisasMonetariasModel():New( self )

   ::oBrowseView                    := DivisasMonetariasBrowseView():New( self )

   ::oDialogView                    := DivisasMonetariasView():New( self )

   ::oValidator                     := DivisasMonetariasValidator():New( self, ::oDialogView )

   ::oRepository                    := DivisasMonetariasRepository():New( self )


RETURN ( Self )

//---------------------------------------------------------------------------//
METHOD End() CLASS DivisasMonetariasController

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

CLASS DivisasMonetariasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DivisasMonetariasBrowseView

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
      :cHeader             := 'Símbolo'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'simbolo' ) }
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

CLASS DivisasMonetariasView FROM SQLBaseView

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
      RESOURCE    "gc_currency_euro_48" ;
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

   REDEFINE GET   ::oController:oModel:hBuffer[ "valor_pesetas" ] ;
      ID          120 ;
      PICTURE     "@E 999,999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "valor_euros" ] ;
      ID          130 ;
      PICTURE     "@E 999,999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "simbolo" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "texto_masculino" ] ;
      ID          150 ;
      IDSAY       152 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "precio_compra_entero" ] ;
      ID          160 ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "precio_compra_decimal" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "precio_compra_redondeo" ] ;
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "precio_venta_entero" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "precio_venta_decimal" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "precio_venta_redondeo" ] ;
      ID          210 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "punto_verde_entero" ] ;
      ID          220 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "punto_verde_decimal" ] ;
      ID          230 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "punto_verde_redondeo" ] ;
      ID          240 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         0 ;
      MAX         8 ;
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

CLASS DivisasMonetariasValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DivisasMonetariasValidator

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

CLASS SQLDivisasMonetariasModel FROM SQLBaseModel

   DATA cTableName               INIT "divisas_monetarias"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDivisasMonetariasModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR( 3 )"                            ,;
                                                   "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 )"                          ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "valor_pesetas",           {  "create"    => "FLOAT( 14,6 )"                           ,;
                                                   "default"   =>{|| 0 } }                                  )

   hset( ::hColumns, "valor_euros",             {  "create"    => "FLOAT( 14,6 )"                           ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "simbolo",                 {  "create"    => "VARCHAR( 3 )"                            ,;
                                                   "default"   => {|| space( 3) } }                         )

   hset( ::hColumns, "texto_masculino",         {  "create"    => "BIT"                                     ,;
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