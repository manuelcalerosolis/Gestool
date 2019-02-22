#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosGruposController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias ---------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := TercerosGruposBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := TercerosGruposView():New( self ), ), ::oDialogView ) 

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := TercerosGruposValidator():New( self  ), ), ::oValidator ) 

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := TercerosGruposRepository():New( self ), ), ::oRepository ) 

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLTercerosGruposModel():New( self ), ), ::oModel ) 

   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := ItemRange():New( self,  ), ), ::oRange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TercerosGruposController

   ::Super:New( oController )

   ::cTitle                            := "Grupos de terceros"

   ::cName                             := "terceros_grupos"

   ::hImage                            := {  "16" => "gc_users3_16",;
                                             "32" => "gc_users3_32",;
                                             "48" => "gc_users3_48" }

   ::nLevel                            := Auth():Level( ::cName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TercerosGruposController

   iif( !empty( ::oModel ), ::oModel:End(), )

   iif( !empty( ::oBrowseView ), ::oBrowseView:End(), )

   iif( !empty( ::oDialogView ), ::oDialogView:End(), )

   iif( !empty( ::oValidator ), ::oValidator:End(), )

   iif( !empty( ::oRepository ), ::oRepository:End(), )

   iif( !empty( ::oRange ), ::oRange:End(), )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosGruposBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TercerosGruposBrowseView

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

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosGruposView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TercerosGruposView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TERCEROS_GRUPO" ;
      TITLE       ::LblTitle() + "grupo de terceros"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_users3_48" ;
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

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate( ::oDialog ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown      := {| nKey | if( nKey == VK_F5, ::closeActivate( ::oDialog ), ) }

   ::oDialog:bStart        := {|| ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosGruposValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TercerosGruposValidator

   ::hValidators  := {  "nombre" => {  "required"  => "El nombre es un dato requerido",;
                                       "unique"    => "El nombre introducido ya existe" },;
                        "codigo" => {  "required"  => "El c�digo es un dato requerido" ,;
                                       "unique"    => "EL c�digo introducido ya existe"  } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTercerosGruposModel FROM SQLCompanyModel

   DATA cTableName               INIT "terceros_grupos"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTercerosGruposModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                    "text"      => "Identificador"                           ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;                                 
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",   {  "create"    => "VARCHAR ( 20 )"                          ,;
                                    "text"      => "C�digo"                                  ,;
                                    "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR ( 200 )"                         ,;
                                    "text"      => "Nombre"                                  ,;
                                    "default"   => {|| space( 200 ) } }                      )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TercerosGruposRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLTercerosGruposModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestTercerosGruposController FROM TestCase

   DATA oController

   METHOD beforeClass()

   METHOD afterClass()

   METHOD Before() 
   
   METHOD test_create()                

   METHOD test_dialogo_sin_codigo()     

   METHOD test_dialogo_creacion()       

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestTercerosGruposController

   ::oController  := TercerosGruposController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestTercerosGruposController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD Before() CLASS TestTercerosGruposController

   SQLTercerosGruposModel():truncateTable()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_create() CLASS TestTercerosGruposController

   local hBuffer

   hBuffer  := ::oController:getModel();
                  :loadBlankBuffer( {  "codigo" => "0",;
                                       "nombre" => "Test de grupos de terceros" } )
   
   ::Assert():notEquals( 0, ::oController:getModel():insertBuffer( hBuffer ), "test creacion de grupos de terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_codigo() CLASS TestTercerosGruposController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 110 ):cText( "Test de grupos de terceros" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( ::oController:Append(), "test creaci�n de grupos de terceros sin codigo" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD test_dialogo_creacion() CLASS TestTercerosGruposController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100 ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 110 ):cText( "Test de grupos de terceros" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( ::oController:Append(), "test creaci�n de grupos de terceros" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif
