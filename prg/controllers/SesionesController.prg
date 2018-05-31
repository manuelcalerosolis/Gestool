#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SesionesController FROM SQLNavigatorController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController) CLASS SesionesController

   ::Super:New( oSenderController )

   ::cTitle                      := "Sesiones"

   ::cName                       := "sesiones"

   ::hImage                      := {  "16" => "gc_clock_16",;
                                       "32" => "gc_clock_32",;
                                       "48" => "gc_clock_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLSesionesModel():New( self )

   ::oBrowseView                 := SesionesBrowseView():New( self )

   ::oDialogView                 := SesionesView():New( self )

   ::oValidator                  := SesionesValidator():New( self, ::oDialogView )

   ::oRepository                 := SesionesRepository():New( self )

   ::oGetSelector                := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS SesionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

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

CLASS SesionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

END CLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS SesionesBrowseView

   /*with object ( ::oBrowse:AddCol() )
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
      :cSortOrder          := 'nombre_caja'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_sesion'
      :cHeader             := 'Código de sesión'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_sesion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with
*/
RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SesionesView FROM SQLBaseView

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS SesionesView

   /*DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAJAS" ;
      TITLE       ::LblTitle() + "cajas"

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
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_sesion" ] ;
      ID          120 ;
      SPINNER  ;
      MIN 0;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

       ::redefineExplorerBar( 200 )

   // Botones caja -------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::StartActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()*/

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SesionesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS SesionesValidator

   /*::hValidators  := {  "nombre_caja" =>  {  "required"           => "El nombre es un dato requerido",;
                                             "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>       {  "required"           => "El código es un dato requerido" ,;
                                             "unique"             => "EL código introducido ya existe" } }*/
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLSesionesModel FROM SQLBaseModel

   DATA cTableName               INIT "cajas_sesiones"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLSesionesModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "caja_uuid",                  {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {||space( 40 ) } }                        )

   hset( ::hColumns, "codigo",                     {  "create"    => "INTEGER"                                 ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "fecha_hora_inicio",          {  "create"    => "TIMESTAMP"                               ,;
                                                      "default"   => {||hb_datetime() } }                      )

   hset( ::hColumns, "fecha_hora_cierre",          {  "create"    => "TIMESTAMP"                               ,;
                                                      "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "estado",                     {  "create"     => "ENUM( 'Abierta', 'Cerrada' )"           ,;
                                                      "default"    => {|| 'Abierta' }  }                       )

   hset( ::hColumns, "delegacion_uuid",            {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {||space( 40 ) } }                        )





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

CLASS SesionesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLSesionesModel():getTableName() ) 


END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//