#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AgentesController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

   METHOD New()

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

   ::oValidator                  := AgentesValidator():New( self, ::oDialogView )

   ::oDireccionesController      := DireccionesController():New( self )

   ::oRepository                 := AgentesRepository():New( self )

   ::oPaisesController           := PaisesController():New( self )
   ::oProvinciasController       := ProvinciasController():New( self )

   ::oComboSelector              := ComboSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

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
  
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais
   DATA oGetDni

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

   local oGetDni

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

   REDEFINE GET   ::oGetDni VAR ::oController:oModel:hBuffer[ "dni" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( CheckCif( ::oGetDni ) );
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "comision" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@E 999.99" ;
      OF          ::oDialog

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oDialog )

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

   ::oDialog:bStart  := {|| ::oController:oDireccionesController:oDialogView:StartDialog() }

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

   ::hValidators  := {  "nombre" =>          {  "required"     => "El nombre del agente es un dato requerido" }  }

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
   
   ::getEmpresaColumns()

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

   local aNombres    := ::getDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )
   local aResult     := {}

   if !empty( aNombres )
      aeval( aNombres, {| h | aadd( aResult, alltrim( hGet( h, "nombre" ) ) ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//