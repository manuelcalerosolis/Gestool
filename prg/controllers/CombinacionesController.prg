#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesController FROM SQLBrowseController

   DATA oPropiedadesController

   DATA oPropiedadesLineasController

   DATA hPropertyList

   DATA oCombinacionesPropiedadesController

   DATA oSelectorView

   METHOD New()

   METHOD End()

   METHOD runViewGenerate()

   METHOD insertCombinations( aCombinations )

   METHOD insertCombination( aCombination )

   METHOD insertOneCombination( aCombinations )

   METHOD getCombinationName( aCombination )

   METHOD isCombinationInRowSet( cCombinationName )   INLINE ( ::getRowSet():findString( cCombinationName, 'articulos_propiedades_nombre' ) )

   METHOD updateIncrementoPrecio( nIncrementoPrecio )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS CombinacionesController

   ::Super:New( oSenderController )

   ::cTitle                               := "Combinaciones"

   ::cName                                := "combinaciones"

   ::hImage                               := {  "16" => "gc_coathanger_16",;
                                                "32" => "gc_coathanger_32",;
                                                "48" => "gc_coathanger_48" }

   ::nLevel                               := Auth():Level( ::cName )

   ::oPropiedadesController               := PropiedadesController():New( self )

   ::oPropiedadesLineasController         := PropiedadesLineasController():New( self )

   ::oModel                               := SQLCombinacionesModel():New( self )

   ::oBrowseView                          := CombinacionesBrowseView():New( self )

   ::oDialogView                          := CombinacionesView():New( self )

   ::oSelectorView                        := CombinacionesSelectorView():New( self )

   ::oValidator                           := CombinacionesValidator():New( self, ::oDialogView )

   ::oRepository                          := CombinacionesRepository():New( self )

   ::oCombinacionesPropiedadesController  := CombinacionesPropiedadesController():New( self )

   ::oGetSelector                         := GetSelector():New( self ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesController

   ::oPropiedadesController:End()

   ::oPropiedadesLineasController:End()

   ::oCombinacionesPropiedadesController:End()

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oSelectorView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD runViewGenerate() CLASS CombinacionesController

   ::hPropertyList  := getSQLDatabase():selectTrimedFetchHash( ::oPropiedadesController:oModel:getPropertyList() ) 

   if empty( ::hPropertyList )
      msgStop( "No se definieron propiedades" )
      RETURN ( nil )
   end if 

   ::beginTransactionalMode()

   if ::dialogViewActivate()
      ::commitTransactionalMode()
   else 
      ::rollbackTransactionalMode()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertCombinations( aCombinations ) CLASS CombinacionesController

RETURN ( aeval( aCombinations, {|aCombination| ::insertCombination( aCombination ) } ) )

//---------------------------------------------------------------------------//

METHOD insertCombination( aCombination ) CLASS CombinacionesController

   local cCombinationName  := ::getCombinationName( aCombination )

   if !( ::isCombinationInRowSet( cCombinationName ) )

      if ::oModel:insertBlankBuffer() != 0

         ::oCombinacionesPropiedadesController:insertProperties( aCombination, ::oModel:getBuffer( "uuid" ) )

      end if 

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertOneCombination( aCombinations ) CLASS CombinacionesController

   local hCombination
   local cCombinationName  

   for each hCombination in atail( aCombinations )

      cCombinationName     := ::getCombinationName( hCombination )

      if !( ::isCombinationInRowSet( cCombinationName ) )

         if ::oModel:insertBlankBuffer() != 0

            ::oCombinacionesPropiedadesController:insertProperty( hget( hCombination, "propiedad_uuid" ), ::oModel:getBuffer( "uuid" ) )

         end if 

      end if 

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getCombinationName( uCombination ) CLASS CombinacionesController

   local cCombination      := ""

   if hb_isarray( uCombination )
   
      aeval( uCombination, {|hCombination| cCombination += hget( hCombination, 'propiedad_nombre' ) + "," } )
   
      cCombination         := chgAtEnd( cCombination, '', 1 )

   end if 

   if hb_ishash( uCombination )
   
      cCombination         := hget( uCombination, 'propiedad_nombre' )

   end if 

RETURN ( cCombination )

//---------------------------------------------------------------------------//

METHOD updateIncrementoPrecio( nIncrementoPrecio ) CLASS CombinacionesController

   ::oModel:updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), 'incremento_precio', nIncrementoPrecio )

   ::refreshRowSet()

RETURN ( nil )

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
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'articulos_propiedades_nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'articulos_propiedades_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'incremento_precio'
      :cHeader             := 'Incremento de precio'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'incremento_precio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }

      :nEditType           := 1
      :bEditValue          := {|| ::getRowSet():fieldGet( 'incremento_precio' ) }
      :bEditBlock          := {|| ::getRowSet():fieldGet( 'incremento_precio' ) }
      :cEditPicture        := "@E 999999999999.999999"
      :bOnPostEdit         := {|oCol, nIncrementoPrecio| ::oController:updateIncrementoPrecio( nIncrementoPrecio ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesView FROM SQLBaseView

   DATA oPanel

   DATA cGroupProperty

   DATA aCombinations

   DATA aPanelNode

   DATA nFirstPanelSelected
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addPanel( hProperty )

   METHOD addLeftCheckBox( hProperty ) 

   METHOD generateCombinations()

   METHOD generatePanelCombinations( oPanel )

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

   ::oController:Activate( 100, ::oDialog )

   ::redefineExplorerBar( 110 )

   REDEFINE BUTTON ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::oController:Delete( ::oController:getBrowse():aSelected ) )

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

   if empty( hProperty )
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

   local oPanel
   local aPanelCombination

   ::aCombinations         := {}

   for each oPanel in ::oExplorerBar:aPanels
      
      aPanelCombination    := ::generatePanelCombinations( oPanel )
      
      if !empty( aPanelCombination )
         aadd( ::aCombinations, aPanelCombination )
      end if 

   next 

   if empty( ::aCombinations )
      msgStop( "Debe seleccionar al menos una propiedad" )
      RETURN ( nil )
   end if 

   if len( ::aCombinations ) > 1
      ::oController:insertCombinations( permutateArray( ::aCombinations ) )
   else
      ::oController:insertOneCombination( ::aCombinations ) 
   end if 

   ::oController:refreshRowSetAndGoTop()

   ::oController:refreshBrowseView()
   
RETURN ( ::aCombinations )

//---------------------------------------------------------------------------//

METHOD generatePanelCombinations( oPanel )

   local oControl
   local aPanelCombination    := {}

   for each oControl in oPanel:aControls

      if ( oControl:className() == "TCHECKBOX" ) .and. ( oControl:varGet() )
               
         aadd( aPanelCombination, oControl:Cargo )

      end if 

   next 

RETURN ( aPanelCombination )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesSelectorView FROM CombinacionesView 

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesSelectorView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_COMBINACIONES_SELECT" ;
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

   DATA cGroupBy                 INIT "GROUP BY uuid"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLCombinacionesModel

   local cSql 

   TEXT INTO cSql

   SELECT 
      combinaciones.id AS id,
      combinaciones.uuid AS uuid,
      combinaciones.parent_uuid AS parent_uuid,
      combinaciones.incremento_precio AS incremento_precio,
      combinaciones_propiedades.id AS propiedades_id,
      combinaciones_propiedades.uuid AS propiedades_uuid,
      GROUP_CONCAT( articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) AS articulos_propiedades_nombre
   
   FROM %1$s AS combinaciones 
      
      INNER JOIN %2$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = combinaciones.uuid

      INNER JOIN %3$s AS articulos_propiedades_lineas
         ON combinaciones_propiedades.propiedad_uuid = articulos_propiedades_lineas.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql,  ::getTableName(), SQLCombinacionesPropiedadesModel():getTableName(), SQLPropiedadesLineasModel():getTableName() )

   logwrite( cSql )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCombinacionesModel

   hset( ::hColumns, "id",                   {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                                "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                 {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"              ,;                                  
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

CLASS CombinacionesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLCombinacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

