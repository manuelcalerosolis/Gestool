#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TransportistasController FROM SQLNavigatorController

   DATA oDireccionesController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TransportistasController

   ::Super:New()

   ::cTitle                      := "Transportistas"

   ::cName                       := "transportistas"

   ::hImage                      := {  "16" => "gc_small_truck_16",;
                                       "32" => "gc_small_truck_32",;
                                       "48" => "gc_small_truck_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLTransportistasModel():New( self )

   ::oBrowseView                 := TransportistasBrowseView():New( self )

   ::oDialogView                 := TransportistasView():New( self )

   ::oValidator                  := TransportistasValidator():New( self, ::oDialogView )

   ::oDireccionesController      := DireccionesController():New( self )

   ::oRepository                 := TransportistasRepository():New( self )

   ::oGetSelector                := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TransportistasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oDireccionesController:End()

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

CLASS TransportistasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TransportistasBrowseView

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

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TransportistasView

   local oGetDni
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSPORTISTA" ;
      TITLE       ::LblTitle() + "transportistas"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_small_truck_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Transportista" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( replicate( 'N', 9 ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   oGetDni ;
      VAR         ::oController:oModel:hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( checkCif( oGetDni ) ) ;
      OF          ::oDialog

   REDEFINE BUTTON oBtnAppend ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oDireccionesController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          140 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:oDireccionesController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          150 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oDireccionesController:Delete() }

   ::oController:oDireccionesController:Activate( ::oDialog, 160 )

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
      ::oDialog:AddFastKey( VK_F2, {|| ::oController:oDireccionesController:Append() } )
      ::oDialog:AddFastKey( VK_F3, {|| ::oController:oDireccionesController:Edit() } )
      ::oDialog:AddFastKey( VK_F4, {|| ::oController:oDireccionesController:Delete() } )
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

CLASS TransportistasValidator FROM SQLCompanyValidator

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

   CLASSDATA hColumns                        INIT {   "id"           => {  "create" => "INTEGER AUTO_INCREMENT UNIQUE",;
                                                                           "default" => {|| 0 } },;
                                                                        ;
                                                      "uuid"         => {  "create" => "VARCHAR(40) NOT NULL UNIQUE",;
                                                                           "default" => {|| win_uuidcreatestring() } },;
                                                                        ;
                                                      "empresa_uuid" => {  "create" => "VARCHAR ( 40 ) NOT NULL",;
                                                                           "default" => {|| uuidEmpresa() } },;
                                                                        ;
                                                      "usuario_uuid" => {  "create" => "VARCHAR ( 40 ) NOT NULL",;
                                                                           "default" => {|| Auth():Uuid() } },;
                                                                        ;
                                                      "codigo" =>       {  "create" => "VARCHAR( 9 ) NOT NULL",;
                                                                           "default" => {|| space( 9 ) } },;
                                                                        ;
                                                      "nombre" =>       {  "create" => "VARCHAR( 140 )",;
                                                                           "default" => {|| space( 140 ) } },;
                                                                        ;
                                                      "dni" =>          {  "create" => "VARCHAR( 20 )",;
                                                                           "default" => {|| space( 20 ) } } }

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

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 9 ) NOT NULL"                   ,;
                                             "default"   => {|| space( 9 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                      )

   hset( ::hColumns, "dni",               {  "create"    => "VARCHAR( 20 )"                           ,;
                                             "default"   => {|| space( 20 ) } }                       )

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