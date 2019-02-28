#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PaisesGestoolController FROM PaisesController

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPaisesGestoolModel():New( self ), ), ::oModel )

   METHOD getLevel()                   INLINE ( nil )

   METHOD getConfiguracionVistasController();
                                       INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS

//---------------------------------------------------------------------------//

CLASS PaisesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

   METHOD getSelectorPais( oGet )

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLPaisesModel():New( self ), ), ::oModel )

   METHOD getLevel()                   INLINE ( iif( empty( ::oController ), ::nLevel := Auth():Level( ::cName ), ) ) 

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := PaisesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := PaisesView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator  := PaisesValidator():New( self ), ), ::oValidator )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS PaisesController

   ::Super:New( oController )

   ::cTitle                   := "Paises"

   ::cName                    := "paises"

   ::hImage                   := {  "16" => "gc_globe_16",;
                                    "32" => "gc_globe_32",;
                                    "48" => "gc_globe_48" }

   ::getLevel()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PaisesController

   if !empty( ::oModel )
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

METHOD getSelectorPais( oGet ) CLASS PaisesController

   local hResult           := ::ActivateSelectorView()

   if hb_isnil( hResult )
      RETURN ( Self )
   end if 

   if hhaskey( hResult, "codigo" )
      oGet:cText( hGet( hResult, "codigo" ) )
   else
      oGet:cText( "" )
   end if
   
RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PaisesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS PaisesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código iso'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt() 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS PaisesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS PaisesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "PAIS" ;
      TITLE       ::LblTitle() + "país"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

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

CLASS PaisesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS PaisesValidator

   ::hValidators  := {     "codigo" =>          {  "required"           => "El código iso es un dato requerido",;
                                                   "unique"             => "El código iso introducido ya existe" } ,;
                           "nombre" =>          {  "required"           => "El nombre es un datos requerido",;
                                                   "unique"             => "El nombre introducido ya existe" } } 
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPaisesGestoolModel FROM SQLPaisesModel

   METHOD getTableName()                  INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLPaisesModel FROM SQLCompanyModel

   DATA cTableName                        INIT "paises"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getNombreWhereCodigo( codigo )  INLINE ( ::getField( 'nombre', 'codigo', codigo ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPaisesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR ( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

