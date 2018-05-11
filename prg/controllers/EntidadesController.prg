#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS EntidadesController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oContactosController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS EntidadesController

   ::Super:New()

   ::cTitle                      := "Transportistas"

   ::cName                       := "transportistas"

   ::hImage                      := {  "16" => "gc_office_building2_16",;
                                       "32" => "gc_office_building2_32",;
                                       "48" => "gc_office_building2_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLEntidadesModel():New( self )

   ::oBrowseView                 := EntidadesBrowseView():New( self )

   ::oDialogView                 := EntidadesView():New( self )

   ::oValidator                  := EntidadesValidator():New( self, ::oDialogView )

   ::oDireccionesController               := DireccionesController():New( self )

   ::oDireccionesController:oValidator    := DireccionesEntidadesValidator():New( ::oDireccionesController, ::oDialogView )

   msgalert( hb_valtoexp( ::oDireccionesController:oValidator:getValidators() ), "hValidators" )

   ::oContactosController        := ContactosController():New( self )

   ::oRepository                 := TransportistasRepository():New( self )

   ::oGetSelector                := GetSelector():New( self )

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
      :cHeader             := 'C�digo'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descripcion'
      :cHeader             := 'Descripci�n'
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
      :cHeader             := 'Direcci�n'
      :nWidth              := 200
      :bEditValue          := {|| ::oDireccionesController:o:getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'C�digo postal'
      :nWidth              := 80
      :bEditValue          := {|| ::oDireccionesController:getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Poblaci�n'
      :nWidth              := 200
      :bEditValue          := {|| ::oDireccionesController:getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 100
      :bEditValue          := {|| ::oDireccionesController:getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'pais'
      :cHeader             := 'Pa�s'
      :nWidth              := 100
      :bEditValue          := {|| ::oDireccionesController:getRowSet():fieldGet( 'pais' ) }
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
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS EntidadesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ENTIDAD" ;
      TITLE       ::LblTitle() + "entidades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_office_building2_48" ;
      TRANSPARENT ;
      OF          ::oDialog ;

    REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNN" ;
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

      ::oDialog:bStart  := {|| ::oController:oDireccionesController:oDialogView:StartDialog() }
      ::oDialog:bStart  := {|| ::oController:oContactosController:oDialogView( ::oDialog ) }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS EntidadesValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS EntidadesValidator

   ::hValidators  := {  "codigo" =>          {  "required"     => "El c�digo es un dato requerido",;
                                                "unique"       => "El c�digo introducido ya existe" } ,;
                        "descripci�n" =>     {  "required"     => "La descripci�n es un dato requerido" } ,;
                        "gnl_fisico" =>      {  "required"     => "GNL f�sico es un dato requerido" } ,;
                        "punto_logico_op" => {  "required"     => "Punto l�gico op es un dato requerido" } ,;
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

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLEntidadesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 14 ) NOT NULL"                   ,;
                                             "default"   => {|| space( 14 ) } }                        )

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

