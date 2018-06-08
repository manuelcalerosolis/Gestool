#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EntidadesController FROM SQLNavigatorController

   DATA oCamposExtraValoresController

   DATA oDireccionesController

   DATA oContactosController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS EntidadesController

   ::Super:New( oSenderController )

   ::cTitle                               := "Entidades"

   ::cName                                := "entidades"

   ::hImage                               := {  "16" => "gc_office_building2_16",;
                                                "32" => "gc_office_building2_32",;
                                                "48" => "gc_office_building2_48" }

   ::nLevel                               := Auth():Level( ::cName )

   ::oModel                               := SQLEntidadesModel():New( self )

   ::oBrowseView                          := EntidadesBrowseView():New( self )

   ::oDialogView                          := EntidadesView():New( self )

   ::oValidator                           := EntidadesValidator():New( self, ::oDialogView )

   ::oDireccionesController               := DireccionesController():New( self )

   ::oDireccionesController:oValidator    := DireccionesValidator():New( ::oDireccionesController, ::oDialogView )

   ::oCamposExtraValoresController        := CamposExtraValoresController():New( self, ::oModel:cTableName )


   ::oContactosController                 := ContactosController():New( self )

   ::oRepository                          := TransportistasRepository():New( self )

   ::oGetSelector                         := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oContactosController:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oContactosController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oContactosController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oContactosController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oContactosController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oContactosController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oContactosController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS EntidadesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oDireccionesController:End()

   ::oContactosController:End()

   ::oCamposExtraValoresController:End()

   ::oRepository:End()

   ::oGetSelector:End()

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

CLASS EntidadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS EntidadesBrowseView

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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripción'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descripcion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( "direccion" )  }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'Código postal'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Población'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'pais'
      :cHeader             := 'País'
      :nWidth              := 100
      :bEditValue          := {|| SQLPaisesModel():getNombreWhereCodigo( ::getRowSet():fieldGet( 'codigo_pais' )  ) }
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

CLASS EntidadesView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()
   
   METHOD StartDialog()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EntidadesView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENTIDAD" ;
      TITLE       ::LblTitle() + "entidades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

    REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "descripcion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "descripcion" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "gnl_fisico" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "gnl_fisico" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "punto_logico_op" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "punto_logico_op" ) ) ;
      OF          ::oDialog

   //Direcciones

   ::oController:oDireccionesController:oDialogView:ExternalCoreRedefine( ::oDialog )

   //Contacto

   ::oController:oContactosController:oDialogView:ExternalRedefine( ::oDialog )

   REDEFINE GET   ::oController:oModel:hBuffer[ "web" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_ine" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "cno_cnae" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "otros" ] ;
      ID          180 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          190 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

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

      ::oDialog:bStart  := {|| ::StartDialog() }

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartDialog()

   ::oController:oDireccionesController:oDialogView:StartDialog() 
   
   ::oController:oContactosController:oDialogView( ::oDialog ) 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntidadesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS EntidadesValidator

   ::hValidators  := {  "codigo" =>          {  "required"     => "El código es un dato requerido",;
                                                "unique"       => "El código introducido ya existe" } ,;
                        "descripcion" =>     {  "required"     => "La descripción es un dato requerido" } ,;
                        "gnl_fisico" =>      {  "required"     => "GNL físico es un dato requerido" } ,;
                        "punto_logico_op" => {  "required"     => "Punto lógico op es un dato requerido" } ,;
                        "nombre" =>          {  "required"     => "El nombre es un dato requerido"  },;
                                                "unique"       => "El nombre introducido ya existe"  } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLEntidadesModel FROM SQLCompanyModel

   DATA cTableName                           INIT "entidades"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLEntidadesModel

   local cSelect  := "SELECT entidades.id,"                                                                                                     + " " + ;
                        "entidades.uuid,"                                                                                                       + " " + ;
                        "entidades.codigo,"                                                                                                     + " " + ;
                        "entidades.descripcion,"                                                                                                + " " + ;
                        "entidades.nombre,"                                                                                                     + " " + ;
                        "entidades.gnl_fisico,"                                                                                                 + " " + ;
                        "entidades.punto_logico_op,"                                                                                            + " " + ;
                        "entidades.web,"                                                                                                        + " " + ;
                        "entidades.codigo_ine,"                                                                                                 + " " + ;
                        "entidades.cno_cnae,"                                                                                                   + " " + ;
                        "entidades.otros,"                                                                                                      + " " + ;
                        "direcciones.direccion as direccion,"                                                                                   + " " + ;
                        "direcciones.codigo_postal as codigo_postal,"                                                                           + " " + ;
                        "direcciones.poblacion as poblacion,"                                                                                   + " " + ;
                        "direcciones.provincia as provincia,"                                                                                   + " " + ;
                        "direcciones.codigo_pais as codigo_pais"                                                                                + " " + ;
                     "FROM " + ::getTableName() + " AS entidades"                                                                                + " " + ;
                        "INNER JOIN " + SQLDireccionesModel():getTableName() + " AS direcciones ON entidades.uuid = direcciones.parent_uuid"   + " "

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLEntidadesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL"                   ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "descripcion",       {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "gnl_fisico",        {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "punto_logico_op",   {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "web",               {  "create"    => "VARCHAR( 200 )"                           ,;
                                             "default"   => {|| space( 200 ) } }                       )

   hset( ::hColumns, "codigo_ine",        {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "cno_cnae",          {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "otros",             {  "create"    => "VARCHAR( 200 )"                           ,;
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

CLASS EntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLEntidadesModel():getTableName() ) 

END CLASS

