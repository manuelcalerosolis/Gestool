#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AgentesController FROM SQLNavigatorController

   DATA oDireccionesController

   METHOD New()

   METHOD DireccionesControllerLoadCurrentBuffer()

   METHOD DireccionesControllerUpdateBuffer()

   METHOD DireccionesControllerDeleteBuffer()

   METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   METHOD DireccionesControllerLoadedDuplicateBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS AgentesController

   ::Super:New()

   ::cTitle                      := "Agentes"

   ::cName                       := "agentes"

   ::hImage                      := {  "16" => "gc_businessman2_16",;
                                       "32" => "gc_businessman2_32",;
                                       "48" => "gc_businessman2_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLAgentesModel():New( self )

   ::oBrowseView                 := AgentesBrowseView():New( self )

   ::oDialogView                 := AgentesView():New( self )

   ::oValidator                  := AgentesValidator():New( self )

   ::oDireccionesController      := DireccionesController():New( self )

   ::oRepository                 := AgentesRepository():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:oModel:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:oModel:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::DireccionesControllerLoadCurrentBuffer() } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::DireccionesControllerUpdateBuffer() } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::DireccionesControllerLoadedDuplicateCurrentBuffer() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::DireccionesControllerLoadedDuplicateBuffer() } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::DireccionesControllerDeleteBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadCurrentBuffer()

   local idDireccion     
   local uuidAgente     := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidAgente )
      ::oDireccionesController:oModel:insertBuffer()
   end if 

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuidAgente )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
   end if 

   ::oDireccionesController:oModel:loadCurrentBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerUpdateBuffer()

   local idDireccion     
   local uuidAgente     := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuidAgente )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oDireccionesController:oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerDeleteBuffer()

   local aUuidAgente    := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuidAgente )
      RETURN ( self )
   end if

   ::oDireccionesController:oModel:deleteWhereParentUuid( aUuidAgente )

   RETURN ( self )
//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateCurrentBuffer()

   local uuidAgente
   local idDireccion     

   uuidAgente           := hget( ::oModel:hBuffer, "uuid" )

   idDireccion          := ::oDireccionesController:oModel:getIdWhereParentUuid( uuidAgente )
   if empty( idDireccion )
      ::oDireccionesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oDireccionesController:oModel:loadDuplicateBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerLoadedDuplicateBuffer()

   local uuidAgente     := hget( ::oModel:hBuffer, "uuid" )

   hset( ::oDireccionesController:oModel:hBuffer, "parent_uuid", uuidAgente )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AgentesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS AgentesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'comision'
      :cHeader             := 'Comisión'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'comision' ) }
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

CLASS AgentesView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

END CLASS

//---------------------------------------------------------------------------//
METHOD Activating() CLASS AgentesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//


METHOD Activate() CLASS AgentesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "AGENTE" ;
      TITLE       ::LblTitle() + "agente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_businessman2_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "dni" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "comision" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "direccion" ] ;
      ID          130 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::getDireccionesController():validate( "direccion" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "codigo_postal" ] ;
      ID          140 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog 

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "poblacion" ] ;
      ID          150 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "provincia" ] ;
      ID          160 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "telefono" ] ;
      ID          170 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "movil" ] ;
      ID          180 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::getDireccionesController():oModel:hBuffer[ "email" ] ;
      ID          190 ;
      WHEN        ( ::getDireccionesController():isNotZoomMode() ) ;
      VALID       ( ::getDireccionesController():validate( "email" ) ) ;
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

CLASS AgentesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AgentesValidator

   ::hValidators  := {  "nombre" =>          {  "required"     => "El nombre del agente es un dato requerido"/*,*/;
                                                /*"unique"       => "El nombre del agente introducido ya existe" */}}

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAgentesModel FROM SQLBaseModel

   DATA cTableName               INIT "agentes"


   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAgentesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                       )

   hset( ::hColumns, "dni",               {  "create"    => "VARCHAR( 20 )"                          ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "comision",          {  "create"    => "FLOAT( 5,2 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

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

CLASS AgentesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLAgentesModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS AgentesRepository

   local h
   local aNombres    := ::getDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )
   local aResult     := {}

   for each h in aNombres
      aAdd( aResult, AllTrim( hGet( h, "nombre" ) ) )
   next

RETURN ( aResult )

//---------------------------------------------------------------------------//