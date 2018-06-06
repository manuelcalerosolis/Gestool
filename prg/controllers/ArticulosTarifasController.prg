#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosTarifasController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   METHOD New()

   METHOD End()

   METHOD Delete( aSelectedRecno )

   METHOD insertPreciosWhereTarifa()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosTarifasController

   ::Super:New()

   ::cTitle                         := "Tarifas"

   ::cName                          := "tarifas"

   ::hImage                         := {  "16" => "gc_money_interest_16",;
                                          "32" => "gc_money_interest_32",;
                                          "48" => "gc_money_interest_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosTarifasModel():New( self )

   ::oBrowseView                    := ArticulosTarifasBrowseView():New( self )

   ::oDialogView                    := ArticulosTarifasView():New( self )

   ::oValidator                     := ArticulosTarifasValidator():New( self, ::oDialogView )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oRepository                    := ArticulosTarifasRepository():New( self )

   ::setEvent( 'appended', {|| ::insertPreciosWhereTarifa() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosTarifasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oCamposExtraValoresController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Delete( aSelectedRecno ) CLASS ArticulosTarifasController

   if len( aSelectedRecno ) > 1
      msgStop( "No se pueden realizar eliminaciones multiples en tarifas." )
      RETURN .f.
   end if 

   if ( ::getRowSet():fieldGet( 'uuid' ) == Company():Uuid() ) 
      msgStop( "No se puede eliminar la tarifa General." )
      RETURN .f.
   end if 

RETURN ( ::Super:Delete( aSelectedRecno ) )

//---------------------------------------------------------------------------//

METHOD insertPreciosWhereTarifa() CLASS ArticulosTarifasController

   local codigoTarifa  := hget( ::oModel:hBuffer, "codigo" )

   if empty( codigoTarifa )
      RETURN ( Self )
   end if 

   SQLArticulosPreciosModel():insertPreciosWhereTarifa( codigoTarifa )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosTarifasBrowseView

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
      :cSortOrder          := 'margen_predefinido'
      :cHeader             := 'Margen predefinido %'
      :nWidth              := 130
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'margen_predefinido' ), "@E 9999.9999" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :nDataStrAlign       := 1
      :nHeadStrAlign       := 1
   end with

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosTarifasView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TARIFA" ;
      TITLE       ::LblTitle() + "tarifa"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "margen_predefinido" ] ;
      ID          120 ;
      SPINNER ;
      PICTURE     "@E 9999.9999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          140 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

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

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosTarifasValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"  => "El código es un dato requerido" ,;
                                          "unique"    => "EL código introducido ya existe"  } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosTarifasModel FROM SQLCompanyModel

   DATA cTableName                           INIT "articulos_tarifas"

   DATA cConstraints                         INIT "PRIMARY KEY ( id ), UNIQUE KEY ( empresa_codigo, codigo )"

   METHOD getColumns()

   METHOD getInsertArticulosTarifasSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosTarifasModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }            )
   
   hset( ::hColumns, "codigo",               {  "create"    => "VARCHAR( 20 )"                           ,;
                                                "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",               {  "create"    => "VARCHAR( 200 )"                          ,;
                                                "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "margen_predefinido",   {  "create"    => "FLOAT( 8,4 )"                            ,;
                                                "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "sistema",              {  "create"    => "TINYINT ( 1 )"                           ,;
                                                "default"   => {|| "0" } }                               )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertArticulosTarifasSentence()

   local cSentence 

   cSentence   := "INSERT IGNORE INTO " + ::getTableName() + " "
   cSentence   +=    "( uuid, codigo, nombre, sistema ) "
   cSentence   += "VALUES "
   cSentence   +=    "( UUID(), '1', 'General', '1' )"

RETURN ( cSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosTarifasRepository FROM SQLBaseRepository

   METHOD getTableNameSQL()               INLINE ( SQLArticulosTarifasModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//