#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TransportistasController FROM SQLNavigatorController

   DATA oDireccionesController

   METHOD New()

   METHOD SetSelectorToGet( oGet )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS TransportistasController

   ::Super:New()

   ::cTitle                   := "Transportistas"

   ::cName                    := "transportistas"

   ::hImage                   := {  "16" => "gc_small_truck_16",;
                                    "32" => "gc_small_truck_32",;
                                    "48" => "gc_small_truck_48" }

   ::nLevel                   := Auth():Level( ::cName )

   ::oModel                   := SQLTransportistasModel():New( self )

   ::oBrowseView              := TransportistasBrowseView():New( self )

   ::oDialogView              := TransportistasView():New( self )

   ::oValidator               := TransportistasValidator():New( self )

   ::oDireccionesController   := DireccionesController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD SetSelectorToGet( oGet, cGet ) CLASS TransportistasController

   local hLenguaje            := ::ActivateSelectorView() 

   if !empty( hLenguaje ) .and. hhaskey( hLenguaje, "nombre" )
      oGet:cText( hget( hLenguaje, "nombre" ) )
   else
      oGet:cText( "" )
   end if

   if !empty( hLenguaje ) .and. hhaskey( hLenguaje, "uuid" )
      cGet  := hget( hLenguaje, "uuid" )
   else
      cGet  := ""
   end if

RETURN ( .t. )

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

   local oDlg
   local oBmpGeneral
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  oDlg ;
      RESOURCE    "TRANSPORTISTA" ;
      TITLE       ::LblTitle() + "transportistas"

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_small_truck_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "dni" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "dni" ) ) ;
      OF          oDlg

   REDEFINE BUTTON oBtnAppend ;
      ID          120 ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oDireccionesController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          130 ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:oDireccionesController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          140 ;
      OF          oDlg ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oDireccionesController:Delete() }

   ::oController:oDireccionesController:Activate( oDlg, 150 )

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

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

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

   ::hValidators  := {  "nombre" =>          {  "required"     => "El nombre del transportista es un dato requerido",;
                                                "unique"       => "El nombre del transportista introducido ya existe" }}

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTransportistasModel FROM SQLBaseModel

   DATA cTableName               INIT "transportistas"

   MESSAGE getNombre( uuid )      INLINE ( ::getField( "nombre", "uuid", uuid ) )

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTransportistasModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                       )

   hset( ::hColumns, "dni",               {  "create"    => "VARCHAR( 20 )"                          ,;
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

   METHOD getTableName()         INLINE ( SQLTransportistasModel():getTableName() ) 

   METHOD getNombres()

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS TransportistasRepository

   local cSentence               := "SELECT nombre, uuid FROM " + ::getTableName()
   local aNombres                := ::getDatabase():selectFetch( cSentence )

RETURN ( aNombres )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//