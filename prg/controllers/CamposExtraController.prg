#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraController FROM SQLNavigatorController

   METHOD New()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CamposExtraController

   ::Super:New()

   ::cTitle                   := "Campos Extra"

   ::cName                    := "campos_extra"

   ::hImage                   := {  "16" => "gc_user_message_16",;
                                    "32" => "gc_user_message_32",;
                                    "48" => "gc_user_message_48" }

   ::nLevel                   := nLevelUsr( ::cName )

   ::oModel                   := SQLCamposExtraModel():New( self )

   ::oBrowseView              := CamposExtraBrowseView():New( self )

   ::oDialogView              := CamposExtraView():New( self )

   ::oValidator               := CamposExtraValidator():New( self )

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

CLASS CamposExtraBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CamposExtraBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
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
      :cSortOrder          := 'requerido'
      :cHeader             := 'Requerido'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'requerido' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 
      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'tipo'
      :cHeader             := 'Tipo'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 
      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'longitud'
      :cHeader             := 'Longitud'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'longitud' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 
      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'decimales'
      :cHeader             := 'Decimales'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'decimales' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 
      with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'defecto'
      :cHeader             := 'Defecto'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'defecto' ) }
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

CLASS CamposExtraView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraView

   local oDlg
   local oBmpGeneral
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  oDlg ;
      RESOURCE    "CAMPOS_EXTRA";
      TITLE       ::LblTitle() + "Campo extra"

   REDEFINE BITMAP oBmpGeneral ;
      ID          900 ;
      RESOURCE    "gc_user_message_48" ;
      TRANSPARENT ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDlg

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "requerido" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "tipo" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "tipo" ) ) ;
      OF          oDlg
   REDEFINE GET   ::oController:oModel:hBuffer[ "longitud" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

   REDEFINE GET   ::oController:oModel:hBuffer[ "decimales" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDlg

      REDEFINE GET   ::oController:oModel:hBuffer[ "defecto" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
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

   oBmpGeneral:end()

RETURN ( oDlg:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CamposExtraValidator

   ::hValidators  := {     "nombre" =>          {  "required"     => "El nombre es un dato requerido",;
                                                   "unique"       => "El nombre introducido ya existe" } ,;   
                           "tipo"     =>        {  "required"     => "El tipo es un dato requerido"} ,; 
                           "longitud" =>        {  "required"     => "La longitud es un dato requerido"} }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraModel FROM SQLBaseModel

   DATA cTableName               INIT "campos_extra"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "requerido",         {  "create"    => "TINYINT"                                 ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "tipo",              {  "create"    => "VARCHAR( 10 )"                          ,;
                                             "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "longitud",          {  "create"    => "TINYINT"                                 ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "decimales",         {  "create"    => "TINYINT"                                 ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "defecto",           {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

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

CLASS CamposExtraRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLCamposExtraModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//