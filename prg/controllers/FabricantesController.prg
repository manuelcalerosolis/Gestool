#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FabricantesController FROM SQLNavigatorController

   DATA oImagenesController

   METHOD New()

   METHOD ImagenesControllerLoadCurrentBuffer()

   METHOD ImagenesControllerUpdateBuffer()

   METHOD ImagenesControllerDeleteBuffer()

   METHOD ImagenesControllerLoadedDuplicateCurrentBuffer()

   METHOD ImagenesControllerLoadedDuplicateBuffer()

END CLASS

//---------------------------------------------------------------------------//
METHOD New() CLASS FabricantesController

   ::Super:New()

   ::cTitle                      := "Fabricantes"

   ::cName                       := "fabricantes"

   ::hImage                      := {  "16" => "gc_businessman2_16",;
                                       "32" => "gc_businessman2_32",;
                                       "48" => "gc_businessman2_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLFabricantesModel():New( self )

   ::oBrowseView                 := FabricantesBrowseView():New( self )

   ::oDialogView                 := FabricantesView():New( self )

   ::oValidator                  := FabricantesValidator():New( self )

   ::oImagenesController         := ImagenesController():New( self )

   ::oRepository                 := FabricantesRepository():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oImagenesController:oModel:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oImagenesController:oModel:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::ImagenesControllerLoadCurrentBuffer() } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::ImagenesControllerUpdateBuffer() } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::ImagenesControllerLoadedDuplicateCurrentBuffer() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::ImagenesControllerLoadedDuplicateBuffer() } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::ImagenesControllerDeleteBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadCurrentBuffer()

   local idImagen     
   local uuidFabricante     := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidFabricante )
      ::oImagenesController:oModel:insertBuffer()
   end if 

   idImagen                 := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFabricante )
   if empty( idImagen )
      ::oImagenesController:oModel:insertBuffer()
   end if 

   ::oImagenesController:oModel:loadCurrentBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerUpdateBuffer()

   local idImagen     
   local uuidFabricante     := hget( ::oModel:hBuffer, "uuid" )

   idImagen                 := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFabricante )
   if empty( idImagen )
      ::oImagenesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oImagenesController:oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerDeleteBuffer()

   local aUuidFabricante   := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuidFabricante )
      RETURN ( self )
   end if

   ::oImagenesController:oModel:deleteWhereParentUuid( aUuidFabricante )

   RETURN ( self )
//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadedDuplicateCurrentBuffer()

   local uuidFabricante
   local idImagen     

   uuidFabricante           := hget( ::oModel:hBuffer, "uuid" )

   idImagen          := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFabricante )
   if empty( idImagen )
      ::oImagenesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oImagenesController:oModel:loadDuplicateBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadedDuplicateBuffer()

   local uuidFabricante
   uuidFabricante     := hget( ::oModel:hBuffer, "uuid" )

   hset( ::oImagenesController:oModel:hBuffer, "parent_uuid", uuidFabricante )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FabricantesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FabricantesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripción'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'pagina_web'
      :cHeader             := 'Página web'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'pagina_web' ) }
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

CLASS FabricantesView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

   METHOD getImagenesController()   INLINE ( ::oController:oImagenesController )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
METHOD Activating() CLASS FabricantesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD Activate() CLASS FabricantesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "FABRICANTES" ;
      TITLE       ::LblTitle() + "fabricante"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_wrench_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog


   REDEFINE GET   ::oController:oModel:hBuffer[ "descripcion" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "descripcion" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "pagina_web" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getImagenesController():oModel:hBuffer[ "ruta_local" ] ;
      ID          120 ;
      WHEN        ( ::getImagenesController():isNotZoomMode() ) ;
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

CLASS FabricantesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FabricantesValidator

   ::hValidators  := {     "descripcion" =>     {  "required"     => "La descripción es un dato requerido",;
                                                   "unique"       => "La descripción introducida ya existe" } }                  


RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLFabricantesModel FROM SQLBaseModel

   DATA cTableName                  INIT "fabricantes"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFabricantesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "descripcion",       {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "pagina_web",        {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                       )

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

CLASS FabricantesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLAgentesModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS FabricantesRepository

   local h
   local aNombres    := ::getDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )
   local aResult     := {}

   for each h in aNombres
      aAdd( aResult, AllTrim( hGet( h, "nombre" ) ) )
   next

RETURN ( aResult )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//