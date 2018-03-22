#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionesController FROM SQLNavigatorController

   METHOD   New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS DireccionesController

   ::Super:New()

   ::cTitle                := "Direcciones"

   ::cName                 := "Direcciones"

   ::hImage                := {  "16" => "gc_modem_16",;
                                 "32" => "gc_modem_32",;
                                 "48" => "gc_modem_48" }

   ::nLevel                := nLevelUsr( ::cName )

   ::oModel                := SQLDireccionesModel():New( self )

   ::oBrowseView           := DireccionesBrowseView():New( self )

   ::oDialogView           := DireccionesView():New( self )

   ::oValidator            := DireccionesValidator():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DireccionesBrowseView


   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Población'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'Código Postal'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono'
      :cHeader             := 'Teléfono'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with   

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movil'
      :cHeader             := 'Móvil'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movil' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fax'
      :cHeader             := 'Fax'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fax' ) }
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

CLASS DireccionesView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DireccionesView

   local oDlg

   DEFINE DIALOG  oDlg ;
      RESOURCE    "DIRECCIONES" ;
      TITLE       ::LblTitle() + "direcciones"

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "drieccion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "drieccion" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "poblacion" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "poblacion" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_postal" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_postal" ) ) ;
      OF          oDlg 

   REDEFINE GET   ::oController:oModel:hBuffer[ "telefono" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "telefono" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "movil" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "movil" ) ) ;
      OF          oDlg
   REDEFINE GET   ::oController:oModel:hBuffer[ "fax" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "fax" ) ) ;
      OF          oDlg

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( oDlg ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   if ::oController:isNotZoomMode() 
      oDlg:AddFastKey( VK_F5, {|| if( validateDialog( oDlg ), oDlg:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DIreccionesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesValidator

   ::hValidators  := {  "nombre" =>          {  "required"        => "El Nombre de la dirección es un dato requerido",;
                                                "unique"          => "El Nombre de la dirección ya existe" },; 
                        "direccion" =>       {  "required"        => "La dirección es un dato requerido"}}
                                              
                                              

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesModel FROM SQLBaseModel

   DATA cTableName               INIT "direcciones"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                       )


   hset( ::hColumns, "direccion",         {  "create"    => "VARCHAR( 150 )"                          ,;
                                             "default"   => {|| space( 150 ) } }                       )

   hset( ::hColumns, "poblacion",         {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "provincia",         {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "codigo_postal",     {  "create"    => "VARCHAR( 10 )"                          ,;
                                             "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "telefono",          {  "create"    => "VARCHAR( 15 )"                          ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "movil",             {  "create"    => "VARCHAR( 15 )"                          ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "fax",               {  "create"    => "VARCHAR( 15 )"                          ,;
                                             "default"   => {|| space( 15 ) } }                       )

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

CLASS DireccionesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLDireccionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//