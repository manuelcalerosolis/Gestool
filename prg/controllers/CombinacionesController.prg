#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CombinacionesController FROM SQLBrowseController

   DATA cCodigoArticulo

   DATA aProperties

   DATA oSelectorView

   DATA aHaving                        INIT {}

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD runViewGenerate()

   METHOD runViewSelector()

   METHOD insertCombinations( aCombinations )

   METHOD insertCombination( aCombination )

   METHOD insertOneCombination( aCombinations )

   METHOD getCombinationName( aCombination )

   METHOD isCombinationInRowSet( cCombinationName ) ;
                                       INLINE ( ::getRowSet():findString( cCombinationName, 'articulos_propiedades_nombre' ) )

   METHOD updateIncrementoPrecio( nIncrementoPrecio )

   METHOD insertHaving( hProperty )

   METHOD deleteHaving( hProperty )

   METHOD updateHavingSentence()

   METHOD setCodigoArticulo( cCodigoArticulo ) ;
                                       INLINE ( ::cCodigoArticulo := cCodigoArticulo )

   METHOD getCodigoArticulo()          INLINE ( ::cCodigoArticulo )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := CombinacionesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := CombinacionesView():New( self ), ), ::oDialogView )

   METHOD getSelectorView()            INLINE ( iif( empty( ::oSelectorView ), ::oSelectorView := CombinacionesSelectorView():New( self ), ), ::oSelectorView )

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := CombinacionesRepository():New( self ), ), ::oRepository )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLCombinacionesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CombinacionesController

   ::Super:New( oController )

   ::cTitle                            := "Combinaciones"

   ::cName                             := "combinaciones"

   ::hImage                            := {  "16" => "gc_coathanger_16",;
                                             "32" => "gc_coathanger_32",;
                                             "48" => "gc_coathanger_48" }


   ::nLevel                            := Auth():Level( ::cName )

   ::getModel():setEvent( 'beforeDuplicated', {|| ::getCombinacionesPropiedadesController():getModel():olderUuid := ::getModel():getField( "uuid", "parent_uuid", ::getModel():getUuidOlderParent() ) } )

   ::getModel():setEvent( 'afterDuplicated', {| newUuid | ::getCombinacionesPropiedadesController():getModel():duplicateOthers( newUuid ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CombinacionesController

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oSelectorView )
      ::oSelectorView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD runViewGenerate() CLASS CombinacionesController

   ::aProperties  := ::getPropiedadesController():getModel():selectProperties()

   if empty( ::aProperties )
      msgStop( "No se definieron propiedades" )
      RETURN ( nil )
   end if 

RETURN ( ::dialogViewActivate() )

//---------------------------------------------------------------------------//

METHOD runViewSelector( cCodigoArticulo ) CLASS CombinacionesController

   if empty( cCodigoArticulo )
      RETURN ( nil )
   end if 

   ::setCodigoArticulo( cCodigoArticulo )

   ::getRowSet():buildPad( ::getCombinacionesPropiedadesController():getModel():getPropertyWhereArticuloCodigo( cCodigoArticulo ) )

   if empty( ::getRowSet():recCount() )
      msgStop( "No se definieron propiedades" )
      RETURN ( nil )
   end if 

   ::aProperties     := ::getPropiedadesController():getModel():selectProperties()

   if empty( ::aProperties )
      msgStop( "No se definieron propiedades" )
      RETURN ( nil )
   end if 

   ::uDialogResult   := ::getSelectorView():Activate()

   ::getSelectorView():End()

RETURN ( ::uDialogResult )

//---------------------------------------------------------------------------//

METHOD insertCombinations( aCombinations ) CLASS CombinacionesController

RETURN ( aeval( aCombinations, {|aCombination| ::insertCombination( aCombination ) } ) )

//---------------------------------------------------------------------------//

METHOD insertCombination( aCombination ) CLASS CombinacionesController

   if ::isCombinationInRowSet( ::getCombinationName( aCombination ) )
      RETURN ( nil )
   end if 

   if ::getModel():insertBlankBuffer() != 0
      ::getCombinacionesPropiedadesController():insertProperties( aCombination, ::getModel():getBuffer( "uuid" ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertOneCombination( aCombinations ) CLASS CombinacionesController

   local hCombination
   local cCombinationName  

   for each hCombination in atail( aCombinations )

      cCombinationName     := ::getCombinationName( hCombination )

      if !( ::isCombinationInRowSet( cCombinationName ) )

         if ::getModel():insertBlankBuffer() != 0

            ::getCombinacionesPropiedadesController():insertProperty( hget( hCombination, "propiedad_uuid" ), ::getModel():getBuffer( "uuid" ) )

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

   ::getModel():updateFieldWhereId( ::getRowSet():fieldGet( 'id' ), 'incremento_precio', nIncrementoPrecio )

   ::refreshRowSet()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertHaving( hProperty ) CLASS CombinacionesController

   aadd( ::aHaving, hProperty )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteHaving( hProperty ) CLASS CombinacionesController

   local nPosition

   nPosition      := ascan( ::aHaving, {|h| hget( h, "propiedad_uuid" ) == hget( hProperty, "propiedad_uuid" ) } ) 

   if nPosition != 0
      adel( ::aHaving, nPosition, .t. )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateHavingSentence() CLASS CombinacionesController

   local cGeneralHaving    := ""

   aeval( ::aHaving, {|hHaving| cGeneralHaving += 'articulos_propiedades_nombre LIKE ' + quoted( '%' + hget( hHaving, "propiedad_nombre" ) + '%' ) + ' AND ' } )

   if !empty( cGeneralHaving )
      cGeneralHaving       := chgAtEnd( cGeneralHaving, '', 5 )
   end if 

   ::getModel():setGeneralHaving( cGeneralHaving )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS CombinacionesController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesBrowseView FROM SQLBrowseView

   DATA oColumnIncrementoPrecio

   METHOD addColumns()   

   METHOD onDblClick()                 INLINE ( ::getController():getSelectorView():oDialog:end( IDOK ) )

   METHOD disableEditColumnIncrementoPrecio() ;
                                       INLINE ( ::oColumnIncrementoPrecio:nEditType := 0 )
                    
ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CombinacionesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'combinaciones.id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'combinaciones.uuid'
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

   with object ( ::oColumnIncrementoPrecio := ::oBrowse:AddCol() )
      :cSortOrder          := 'combinaciones.incremento_precio'
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

CLASS CombinacionesView FROM SQLBaseView

   DATA oPanel

   DATA cGroupProperty

   DATA aCombinations

   DATA oButtonAceptar
   DATA oButtonCancelar
   
   DATA oButtonDelete
   DATA oButtonGenerate

   METHOD Activate()

   METHOD redefineBrowse()             INLINE ( ::oController:Activate( 100, ::oDialog ) )

   METHOD startActivate()

   METHOD addPanel( hProperty )

   METHOD addLeftCheckBox( hProperty ) 

   METHOD generateCombinations()

   METHOD generatePanelCombinations( oPanel )

   METHOD changeCheckBox( uValue, oCheckBox )   VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_COMBINACIONES_GEN" ;
      TITLE       "Combinaciones de propiedades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Combinaci�n de propiedades" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;

   ::redefineBrowse()

   ::redefineExplorerBar( 110 )

   REDEFINE BUTTON ::oButtonDelete ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::oController:Delete( ::getController():getBrowseView():getBrowse():aSelected ) )

   REDEFINE BUTTON ::oButtonGenerate ;
      ID          120 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::generateCombinations() )

   ::oButtonAceptar  := ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ::oButtonCancelar := ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bStart  := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER 

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS CombinacionesView

   local hProperty

   ::oController:aHaving   := {}

   for each hProperty in ::oController:aProperties
      
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

   oCheckBox:bChange := {| uValue, oCheckBox | ::changeCheckBox( uValue, oCheckBox ) }

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

   METHOD redefineBrowse()          INLINE ( ::getController():getBrowseView():ActivateDialog( ::oDialog, 100 ) )         

   METHOD showCombinations( oPanel ) 

   METHOD Activate()

   METHOD startActivate()

   METHOD changeCheckBox( uValue, oCheckBox )

END CLASS

//---------------------------------------------------------------------------//

METHOD showCombinations() CLASS CombinacionesSelectorView

   local oPanel
   local cSerial           := ""
   local oControl
   local aPanelCombination := {}

   for each oPanel in ::oExplorerBar:aPanels
      
      for each oControl in oPanel:aControls

         if ( oControl:className() == "TCHECKBOX" ) .and. ( oControl:varGet() )
                  
            aadd( aPanelCombination, oControl:Cargo )

         end if 

      next 

   next 

   aeval( aPanelCombination, {| hSelect | cSerial += hget( hSelect, "propiedad_uuid" ) + ", " } ) 

RETURN ( aPanelCombination )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CombinacionesSelectorView

   if ( ::Super:Activate() != IDOK )
      RETURN ( nil )
   end if 

RETURN ( ::getController():getRowSet():fieldGet( 'uuid' ) )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS CombinacionesSelectorView

   ::getController():getBrowseView():disableEditColumnIncrementoPrecio()

   ::oButtonDelete:Hide()
   
   ::oButtonGenerate:Hide()

   ::Super:startActivate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeCheckBox( lCheckBox, oCheckBox ) CLASS CombinacionesSelectorView

   local hCargo      := oCheckBox:Cargo

   if lCheckBox
      ::getController():insertHaving( hCargo )
   else 
      ::getController():deleteHaving( hCargo )
   end if 

   ::getController():getRowSet():buildPad( ::getController():getModel():getSelectWhereCodigoArticuloHaving( ::getController():getCodigoArticulo(), ::getController():aHaving ) )

   ::getController():getBrowseView():Refresh()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCombinacionesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "combinaciones"

   DATA cGroupBy                       INIT "uuid"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getSelectWhereCodigoArticuloHaving( cCodigoArticulo, aHaving ) 

   METHOD getHaving( aHaving )

   METHOD CountWhereCodigoArticulo( cCodigoArticulo )

#ifdef __TEST__

   METHOD test_create_combinaciones()

#endif
  
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
      TRIM( GROUP_CONCAT( " ", articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre
   
   FROM %1$s AS combinaciones 
      
      INNER JOIN %2$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = combinaciones.uuid

      INNER JOIN %3$s AS articulos_propiedades_lineas
         ON combinaciones_propiedades.propiedad_uuid = articulos_propiedades_lineas.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLCombinacionesPropiedadesModel():getTableName(), SQLPropiedadesLineasModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSelectWhereCodigoArticuloHaving( cCodigoArticulo, aHaving ) CLASS SQLCombinacionesModel

   local cSql        

   cSql  := SQLCombinacionesPropiedadesModel():getPropertyWhereArticuloCodigo( cCodigoArticulo )

   cSql  += ::getHaving( aHaving )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getHaving( aHaving ) CLASS SQLCombinacionesModel

   local cGroup
   local cHaving     
   local hProperty

   if empty( aHaving )
      RETURN ( "" )
   end if 

   cHaving           := " HAVING ( "

   aHaving           := asort( aHaving, , , {|x,y| hget( x, "grupo_id" ) < hget( y, "grupo_id" ) } )

   for each hProperty in aHaving

      if !empty( cGroup )
         if hget( hProperty, "grupo_id" ) == cGroup
            cHaving  += " OR "
         else 
            cHaving  += ") AND ("
         end if 
      end if 

      cHaving        += "articulos_propiedades_nombre LIKE " + quoted( "% " + hget( hProperty, "propiedad_nombre" ) + " %" ) 

      cGroup         := hget( hProperty, "grupo_id" ) 

   next 

   cHaving           += " )"

RETURN ( cHaving )

//---------------------------------------------------------------------------//

METHOD CountWhereCodigoArticulo( cCodigoArticulo ) CLASS SQLCombinacionesModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT( combinaciones.uuid )
      FROM %1$s as combinaciones
     
      INNER JOIN %2$s as articulos
         ON articulos.codigo = %3$s

   WHERE combinaciones.parent_uuid = articulos.uuid 
      AND combinaciones.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLArticulosModel():getTableName(), quoted( cCodigoArticulo ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCombinacionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;                          
                                             "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"              ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR ( 40 )"                              ,;
                                             "default"   => {|| ::getControllerParentUuid() } }          )

   hset( ::hColumns, "incremento_precio", {  "create"    => "FLOAT( 16, 6 )"                             ,;
                                             "default"   => {|| 0 } }                                    )

   ::getDeletedStampColumn() 

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_combinaciones( uuidArticulo ) CLASS SQLCombinacionesModel

   local cGroup
   local aGroup         := {}
   local hProperty
   local aCombination
   local aCombinations  := {}
   local aProperties    := SQLPropiedadesModel():selectProperties()

   for each hProperty in aProperties

      if hget( hProperty, "grupo_nombre" ) != cGroup .and. !empty( aCombinations )

         aadd( aGroup, aCombinations )

         aCombinations  := {}
         
      end if 
         
      aadd( aCombinations, hProperty )

      cGroup            := hget( hProperty, "grupo_nombre" ) 
      
   next

   aadd( aGroup, aCombinations )

   for each aCombination in ( permutateArray( aGroup ) )
      if ::insertBlankBuffer( { "parent_uuid" => uuidArticulo } ) != 0
         SQLCombinacionesPropiedadesModel():insertProperties( aCombination, ::getBuffer( "uuid" ) ) 
      end if 
   next

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CombinacionesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLCombinacionesModel():getTableName() ) 

   METHOD getCombinacionWhereArticuloTexto( cCodigoArticulo, cTextoCombinacion )

END CLASS

//---------------------------------------------------------------------------//

METHOD getCombinacionWhereArticuloTexto( cCodigoArticulo, cTextoCombinacion ) CLASS CombinacionesRepository

   local cSql 

   TEXT INTO cSql

   SELECT 
      combinaciones.id AS id,
      combinaciones.uuid AS uuid,
      combinaciones.parent_uuid AS parent_uuid,
      combinaciones.incremento_precio AS incremento_precio,
      combinaciones_propiedades.id AS propiedades_id,
      combinaciones_propiedades.uuid AS propiedades_uuid,
      TRIM( GROUP_CONCAT( " ", articulos_propiedades_lineas.nombre ORDER BY combinaciones_propiedades.id ) ) AS articulos_propiedades_nombre
   
   FROM %1$s AS combinaciones 

      INNER JOIN %4$s AS articulos
         ON articulos.codigo = %5$s
      
      INNER JOIN %2$s AS combinaciones_propiedades
         ON combinaciones_propiedades.parent_uuid = combinaciones.uuid

      INNER JOIN %3$s AS articulos_propiedades_lineas
         ON combinaciones_propiedades.propiedad_uuid = articulos_propiedades_lineas.uuid

      HAVING articulos_propiedades_nombre LIKE %6$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLCombinacionesPropiedadesModel():getTableName(), SQLPropiedadesLineasModel():getTableName(), SQLArticulosModel():getTableName(), quoted( cCodigoArticulo ), quoted( cTextoCombinacion ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

