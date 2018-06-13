#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CombinacionesController

   ::Super:New( oSenderController )

   ::cTitle                      := "Combinaciones"

   ::cName                       := "combinaciones"

   ::hImage                      := {  "16" => "gc_cash_register_refresh_16",;
                                       "32" => "gc_cash_register_refresh_32",;
                                       "48" => "gc_cash_register_refresh_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLCombinacionesModel():New( self )

   ::oBrowseView                    := CombinacionesBrowseView():New( self )

   ::oDialogView                    := CombinacionesView():New( self )

   ::oValidator                     := CombinacionesValidator():New( self, ::oDialogView )

   ::oRepository                    := CombinacionesRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesController

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

CLASS CombinacionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CombinacionesBrowseView

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
      :cSortOrder          := 'grupo_nombre'
      :cHeader             := 'Nombre grupo'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'grupo_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'propiedad_nombre'
      :cHeader             := 'Valor propiedad'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'propiedad_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'orden'
      :cHeader             := 'Orden'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'orden' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'incremento_precio'
      :cHeader             := 'Incremento de precio'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'incremento_precio' ) }
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

CLASS CombinacionesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_COMBINACIONES" ;
      TITLE       ::LblTitle() + "Combinaciones de propiedades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;

   
      ::redefineExplorerBar( 100 )

      ::redefineExplorerBar( 110 )

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

   ACTIVATE DIALOG ::oDialog CENTER
   

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CombinacionesValidator

   /*::hValidators  := {  "nombre" =>                {  "required"           => "El nombre es un dato requerido"    ,;
                                                      "unique"             => "El nombre introducido ya existe"   },;
                        "tipos"  =>                {  "required"           => "El tipo es un datos requerido"     },;
                        "Importe"  =>              {  "required"           => "El importe es un datos requerido"  } }*/
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCombinacionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "combinaciones"

   METHOD getColumns()

   METHOD getGeneralSelect()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCombinacionesModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"                ,;                                  
                                                "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",          {  "create"    => "VARCHAR( 40 )"                              ,;
                                                "default"   => {|| ::getSenderControllerParentUuid() } }    )

   hset( ::hColumns, "incremento_precio",    {  "create"    => "FLOAT( 16,6 )"                              ,;
                                                "default"   => { 0 } }                                      ) 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getGeneralSelect() CLASS SQLCombinacionesModel

   local cSelect  := "SELECT grupos.uuid AS grupo_uuid,"                                                                               + " " + ;
                            "grupos.nombre AS grupo_nombre,"                                                                           + " " + ;                     
                            "lineas.uuid AS propiedad_uuid,"                                                                           + " " + ;
                            "lineas.parent_uuid AS parent_uuid,"                                                                       + " " + ;
                            "lineas.nombre AS propiedad_nombre,"                                                                       + " " + ;
                            "lineas.orden AS orden"                                                                                    + " " + ;
                     "FROM " + SQLPropiedadesModel():getTableName() + " AS grupos"                                                     + " " + ; 
                     "INNER JOIN " + SQLPropiedadesLineasModel():getTableName() +" AS lineas"                                          + " " + ;
                     "ON grupos.uuid = lineas.parent_uuid"                                                                             + " " + ;
                     "ORDER by grupo_uuid, orden"                                                                                      + " "      

RETURN ( cSelect )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCombinacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//