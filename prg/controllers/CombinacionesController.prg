#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesController FROM SQLNavigatorController

   DATA oPropiedadesController

   DATA oPropiedadesLineasController

   DATA hPropertyList

   METHOD New()

   METHOD End()

   METHOD runViewGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CombinacionesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Combinaciones"

   ::cName                          := "combinaciones"

   ::hImage                         := {  "16" => "gc_cash_register_refresh_16",;
                                          "32" => "gc_cash_register_refresh_32",;
                                          "48" => "gc_cash_register_refresh_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oPropiedadesController         := PropiedadesController():New( self )

   ::oPropiedadesLineasController   := PropiedadesLineasController():New( self )

   ::oModel                         := SQLCombinacionesModel():New( self )

   ::oBrowseView                    := CombinacionesBrowseView():New( self )

   ::oDialogView                    := CombinacionesView():New( self )

   ::oValidator                     := CombinacionesValidator():New( self, ::oDialogView )

   ::oRepository                    := CombinacionesRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )   

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesController

   ::oPropiedadesController:End()

   ::oPropiedadesLineasController:End()

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD runViewGenerate()

   ::hPropertyList  := getSQLDatabase():selectTrimedFetchHash( ::oPropiedadesController:oModel:getPropertyList() ) 

   if empty( ::hPropertyList )
      msgStop( "No se definieron propiedades" )
      RETURN ( Self )
   end if 

   ::dialogViewActivate()

RETURN ( Self )

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

CLASS CombinacionesView FROM SQLBaseView

   DATA oPanel

   DATA cGroupProperty
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addPanel( hProperty )

   METHOD addLeftCheckBox( hProperty ) 

   METHOD generateCombinations()

   METHOD generateCombination( oControl )

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
   
   ::redefineExplorerBar( 110 )

   REDEFINE BUTTON ;
      ID          120 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::generateCombinations() )

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

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS CombinacionesView

   local hProperty

   for each hProperty in ::oController:hPropertyList
      
      ::addPanel( hProperty )

      ::addLeftCheckBox( hProperty )

   next
   
RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addPanel( hProperty ) CLASS CombinacionesView

   if hget( hProperty, "grupo_nombre" ) != ::cGroupProperty
      ::oPanel       := ::oExplorerBar:addPanel( hget( hProperty, "grupo_nombre" ), nil, 1 )
   end if 

   ::cGroupProperty  := hget( hProperty, "grupo_nombre" ) 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLeftCheckBox( hProperty ) CLASS CombinacionesView

   local oCheckBox

   if empty( ::oPanel )
      RETURN ( nil )
   end if 

   if hget( hProperty, "grupo_color" )
      oCheckBox      := ::oPanel:addLeftColorCheckBox( hget( hProperty, "propiedad_nombre" ), .f., hget( hProperty, "propiedad_color_rgb" ) )
   else
      oCheckBox      := ::oPanel:addLeftCheckBox( hget( hProperty, "propiedad_nombre" ), .f. )
   end if 

   oCheckBox:Cargo   := hProperty

RETURN ( oCheckBox )

//---------------------------------------------------------------------------//

METHOD generateCombinations() CLASS CombinacionesView

   aeval( ::oExplorerBar:aPanels,;
      {|oPanel| aeval( oPanel:aControls,;
         {|oControl| ::generateCombination( oControl ) } ) } )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD generateCombination( oControl ) CLASS CombinacionesView

   msgalert( oControl:ClassName(), "ClassName" )

   if ( oControl:ClassName() != "TCHECKBOX" )
      RETURN ( nil )
   end if 

   if ( oControl:varGet() )
      msgalert( hb_valtoexp( oControl:Cargo ) )
   end if 

RETURN ( nil )

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

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCombinacionesModel FROM SQLCompanyModel

   DATA cTableName               INIT "combinaciones"

   METHOD getColumns()


END CLASS

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCombinacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//