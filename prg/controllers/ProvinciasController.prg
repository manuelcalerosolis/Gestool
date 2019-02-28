#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ProvinciasGestoolController FROM ProvinciasController

   METHOD getModel()                INLINE ( if( empty( ::oModel ), ::oModel := SQLProvinciasGestoolModel():New( self ), ), ::oModel )
   
   METHOD getConfiguracionVistasController() ;
                                    INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS

//---------------------------------------------------------------------------//

CLASS ProvinciasController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

   METHOD getSelectorProvincia( oGet )

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                INLINE ( if( empty( ::oModel ), ::oModel := SQLProvinciasModel():New( self ), ), ::oModel )

   METHOD getBrowseView()           INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := ProvinciasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()           INLINE ( if( empty( ::oDialogView ), ::oDialogView := ProvinciasView():New( self ), ), ::oDialogView )

   METHOD getValidator()            INLINE ( if( empty( ::oValidator ), ::oValidator := ProvinciasValidator():New( self ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ProvinciasController

   ::Super:New( oController )

   ::cTitle                   := "Provincias"

   ::cName                    := "provincias"

   ::lTransactional           := .t.

   ::hImage                   := {  "16" => "gc_flag_spain_16",;
                                    "32" => "gc_flag_spain_32",;
                                    "48" => "gc_flag_spain_48" }

   ::getModel()

   if empty( oController )
      ::nLevel                := Auth():Level( ::cName )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ProvinciasController

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSelectorProvincia( oGet ) CLASS ProvinciasController

   local hResult := ::ActivateSelectorView()

   if hb_isnil( hResult )
      RETURN ( Self )
   end if 

   if hHasKey( hResult, "codigo" )
      oGet:cText( hGet( hResult, "codigo" ) )
   else
      oGet:cText( "" )
   end if
   
RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ProvinciasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ProvinciasView

   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "PROVINCIA" ;
      TITLE       ::LblTitle() + "provincia"

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ) ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   oBmpGeneral:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ProvinciasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ProvinciasValidator

   ::hValidators  := {     "codigo"    =>       {  "required"           => "El c�digo es un dato requerido",;
                                                   "unique"             => "El c�digo introducido ya existe" ,;
                                                   "onlyAlphanumeric"   => "EL c�digo no puede contener caracteres especiales" } ,;
                           "provincia" =>       {  "required"           => "La provincia es un datos requerido",;
                                                   "unique"             => "La provincia introducida ya existe" } }                      

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLProvinciasGestoolModel FROM SQLProvinciasModel

   METHOD getTableName()         INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//

CLASS SQLProvinciasModel FROM SQLCompanyModel

   DATA cTableName               INIT "provincias"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLProvinciasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR ( 20 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "provincia",         {  "create"    => "VARCHAR( 50 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 50 ) } }                       )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//