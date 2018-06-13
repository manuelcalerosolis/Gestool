#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DelegacionesController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oCamposExtraValoresController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS DelegacionesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Delegaciones"

   ::cName                          := "delegaciones"

   ::hImage                         := {  "16" => "gc_factory_group_16",;
                                          "32" => "gc_factory_group_32",;
                                          "48" => "gc_factory_group_48" }

   ::oModel                         := SQLDelegacionesModel():New( self )

   ::oBrowseView                    := DelegacionesBrowseView():New( self )

   ::oDialogView                    := DelegacionesView():New( self )

   ::oValidator                     := DelegacionesValidator():New( self, ::oDialogView )

   ::oDireccionesController         := DireccionesGestoolController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresGestoolController():New( self, ::oModel:cTableName )

   ::oRepository                    := DelegacionesRepository():New( self )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DelegacionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oDireccionesController:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DelegacionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DelegacionesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DelegacionesView FROM SQLBaseView
  
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais
   DATA oSayCamposExtra

   METHOD Activate()

   METHOD Activating()

   METHOD StartDialog()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS DelegacionesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS DelegacionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DELEGACIONES" ;
      TITLE       ::LblTitle() + "delegación"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oDialog )

   REDEFINE EXPLORERBAR ::oExplorerBar ;
      ID          700 ;
      OF          ::oDialog

   ::oExplorerBar:nBottomColor  := RGB( 255, 255, 255 )
   ::oExplorerBar:nTopColor     := RGB( 255, 255, 255 )

   // Botones Delegaciones -------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::StartDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS DelegacionesView

   ::oController:oDireccionesController:oDialogView:StartDialog()

   ::addLinksToExplorerBar()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS DelegacionesView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...", {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }, ::oController:oCamposExtraValoresController:getImage( "16" ) )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DelegacionesValidator FROM SQLBaseValidator

   METHOD getValidators()

END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DelegacionesValidator

   ::hValidators  := {  "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "EL código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDelegacionesModel FROM SQLBaseModel

   DATA cTableName                        INIT "empresas_delegaciones"

   METHOD getColumns()

   METHOD aNombres()

   METHOD getNombreFromUuid( cUuid )      INLINE ( ::getField( 'nombre', 'uuid', cUuid ) )

   METHOD getUuidFromNombre( cNombre )    INLINE ( ::getField( 'uuid', 'nombre', cNombre ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDelegacionesModel
   
   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| ::getSenderControllerParentUuid() } } )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD aNombres() CLASS SQLDelegacionesModel

   local cSelect  := "SELECT nombre FROM " + ::getTableName()

RETURN ( ::getDatabase():selectFetchArrayOneColumn( cSelect ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DelegacionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLDelegacionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//

