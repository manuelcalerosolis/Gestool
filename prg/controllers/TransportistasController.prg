#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TransportistasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()        INLINE( if( empty( ::oBrowseView ), ::oBrowseView := TransportistasBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()        INLINE( if( empty( ::oDialogView ), ::oDialogView := TransportistasView():New( self ), ), ::oDialogView )

   METHOD getRepository()        INLINE(if(empty( ::oRepository ), ::oRepository := TransportistasRepository():New( self ), ), ::oRepository )

   METHOD getValidator()         INLINE( if( empty( ::oValidator ), ::oValidator := TransportistasValidator():New( self  ), ), ::oValidator ) 
   
   METHOD getModel()             INLINE( if( empty( ::oModel ), ::oModel := SQLTransportistasModel():New( self ), ), ::oModel ) 

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TransportistasController

   ::Super:New( oController )

   ::cTitle                         := "Transportistas"

   ::cName                          := "transportistas"

   ::hImage                         := {  "16" => "gc_small_truck_16",;
                                       "32" => "gc_small_truck_32",;
                                       "48" => "gc_small_truck_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getModel():setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TransportistasController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TransportistasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TransportistasBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 100
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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnsCreatedUpdatedAt()
   
   ::getColumnDeletedAt() 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TransportistasView FROM SQLBaseView
  
   METHOD Activate()

   METHOD StartDialog()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TransportistasView

   local oSayCamposExtra
   local oSayT
   local oGetDni
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSPORTISTA" ;
      TITLE       ::LblTitle() + "transportistas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Transportista" ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   oGetDni ;
      VAR         ::oController:getModel():hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( checkCif( oGetDni ) ) ;
      OF          ::oDialog

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oDialog )

   ::redefineExplorerBar( 700 )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
if ::oController:isNotZoomMode() 
   
      ::oDialog:bKeyDown   := <| nKey |  
         do case         
            case nKey == VK_F5
               if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), )
            case nKey == VK_F2
               ::oController:getDireccionesController():Append()
            case nKey == VK_F3
               ::oController:getDireccionesController():Edit()
            case nKey == VK_F4
               ::oController:getDireccionesController():Delete()
         end 
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart  := {|| ::StartDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog() CLASS TransportistasView

   ::oController:getDireccionesController():externalStartDialog()

   ::addLinksToExplorerBar()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS TransportistasView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Incidencias...",         {|| ::oController:getIncidenciasController():activateDialogView() },;
                                                    ::oController:getIncidenciasController():getImage( "16" ) )
      oPanel:AddLink( "Documentos...",          {|| ::oController:getDocumentosController():activateDialogView() },;
                                                    ::oController:getDocumentosController():getImage( "16" ) )
   end if

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()
      oPanel:AddLink( "Campos extra...",        {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                                                    ::oController:getCamposExtraValoresController():getImage( "16" ) )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TransportistasValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TransportistasValidator

   ::hValidators  := {  "codigo" =>          {  "required"     => "El código del transportista es un dato requerido",;
                                                "unique"       => "El código del transportista introducido ya existe" } ,;
                        "nombre" =>          {  "required"     => "El nombre del transportista es un dato requerido",;
                                                "unique"       => "El nombre del transportista introducido ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTransportistasModel FROM SQLCompanyModel

   DATA cTableName                           INIT "transportistas"

   DATA cConstraints                         INIT "PRIMARY KEY ( codigo, deleted_at )"

   MESSAGE getNombre( uuid )                 INLINE ( ::getField( "nombre", "uuid", uuid ) )

   MESSAGE getNombreWhereCodigo( codigo )    INLINE ( ::getField( "nombre", "codigo", codigo ) )

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTransportistasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL"                   ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                      )

   hset( ::hColumns, "dni",               {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   ::getTimeStampColumns()

   ::getDeletedStampColumn()

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

CLASS TransportistasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLTransportistasModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS TransportistasRepository

   local cSentence     := "SELECT nombre FROM " + ::getTableName() + " ORDER BY nombre ASC"
   local aNombres      := ::getDatabase():selectFetchArrayOneColumn( cSentence )

   ains( aNombres, 1, "", .t. )

RETURN ( aNombres )

//---------------------------------------------------------------------------//