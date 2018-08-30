#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS PaisesGestoolController FROM PaisesController

   METHOD getModel()                            INLINE ( ::oModel := SQLPaisesGestoolModel():New( self ) )

   METHOD getLevel()                            INLINE ( nil )

   METHOD getConfiguracionVistasController()    INLINE ( ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS PaisesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

   METHOD getSelectorPais( oGet )

   METHOD getModel()          INLINE ( ::oModel := SQLPaisesModel():New( self ) )

   METHOD getLevel()          INLINE ( iif( empty( ::oSenderController ), ::nLevel := Auth():Level( ::cName ), ) ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS PaisesController

   ::Super:New( oSenderController )

   ::cTitle                   := "Paises"

   ::cName                    := "paises"

   ::hImage                   := {  "16" => "gc_globe_16",;
                                    "32" => "gc_globe_32",;
                                    "48" => "gc_globe_48" }

   ::getLevel()

   ::getModel()

   ::oBrowseView              := PaisesBrowseView():New( self )

   ::oDialogView              := PaisesView():New( self )

   ::oValidator               := PaisesValidator():New( self )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS PaisesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::Super:End()

   ::oModel                := nil

   ::oBrowseView           := nil

   ::oDialogView           := nil

   ::oValidator            := nil

   self                    := nil

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

   METHOD getColumns()

   METHOD getNombreWhereCodigo( codigo )  INLINE ( ::getField( 'nombre', 'codigo', codigo ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLPaisesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) UNIQUE"                    ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 ) UNIQUE"                   ,;
                                             "default"   => {|| space( 200 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

