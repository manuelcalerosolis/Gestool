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

   ::setName( "campos_extra" )

   ::nLevel                   := Auth():Level( ::getName() )

   ::hImage                   := {  "16" => "gc_user_message_16",;
                                    "32" => "gc_user_message_32",;
                                    "48" => "gc_user_message_48" }

   ::oModel                   := SQLCamposExtraModel():New( self )

   ::oBrowseView              := CamposExtraBrowseView():New( self )

   ::oDialogView              := CamposExtraView():New( self )

   ::oValidator               := CamposExtraValidator():New( self, ::oDialogView )

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
  
   DATA oLongitud

   DATA oDecimales

   DATA oValorDefecto

   DATA oDecimales

   DATA oTipo

   DATA aTipos 

   DATA hTipos

   DATA oAddDefecto

   DATA oDelDefecto

   DATA oListaDefecto

   DATA cListaDefecto

   DATA aListaDefecto                  

   METHOD New()

   METHOD enableLongitud()             INLINE ( ::oLongitud:Enable(), ::oDecimales:Enable() )

   METHOD disableLongitud()            INLINE ( ::oLongitud:Disable(), ::oDecimales:Disable() )

   METHOD setLongitud( nLen, nDec )    INLINE ( ::oLongitud:cText( nLen ), ::oDecimales:cText( nDec ) )

   METHOD enableDefecto()              INLINE ( ::oValorDefecto:Enable(), ::oAddDefecto:Enable(), ::oDelDefecto:Enable(), ::oListaDefecto:Enable() )

   METHOD disableDefecto()             INLINE ( ::oValorDefecto:Disable(), ::oAddDefecto:Disable(), ::oDelDefecto:Disable(), ::oListaDefecto:Disable() )

   METHOD changeTipo( cTipo )          INLINE ( if( hhaskey( ::hTipos, cTipo ), eval( hGet( ::hTipos, cTipo ) ), ) )

   METHOD addDefecto()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CamposExtraView

   ::Super:New( oController )

   ::aTipos          := {  "Texto", "Número", "Fecha", "Lógico", "Lista" }

   ::hTipos          := {  "Texto"  => {|| ::oLongitud:Enable(), ::oDecimales:Disable(), ::disableDefecto(), ::setLongitud( 100, 0 ) } ,;
                           "Número" => {|| ::enableLongitud(), ::disableDefecto(), ::setLongitud( 16, 6 ) } ,;
                           "Fecha"  => {|| ::disableLongitud(), ::setLongitud( 8, 0 ), ::disableDefecto() } ,;
                           "Lógico" => {|| ::disableLongitud(), ::setLongitud( 1, 0 ), ::disableDefecto() } ,;
                           "Lista"  => {|| ::disableLongitud(), ::setLongitud( 10, 0 ), ::enableDefecto() } }

   ::aListaDefecto   := {}

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAMPOS_EXTRA";
      TITLE       ::LblTitle() + "Campo extra"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
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

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "tipo" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( ::aTipos ) ;
      OF          ::oDialog

   ::oTipo:bChange   := {|| ::ChangeTipo( ::oController:oModel:hBuffer[ "tipo" ] ) }

   REDEFINE GET   ::oLongitud ;
      VAR         ::oController:oModel:hBuffer[ "longitud" ] ;
      ID          120 ;
      PICTURE     "999" ;
      SPINNER ;
      MIN         1 ;
      MAX         200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "longitud" ] >= 1 .and. ::oController:oModel:hBuffer[ "longitud" ] <= 200 ) ;
      OF          ::oDialog

   REDEFINE GET   ::oDecimales ;
      VAR         ::oController:oModel:hBuffer[ "decimales" ] ;
      ID          130 ;
      PICTURE     "9" ;
      SPINNER ;
      MIN         0 ;
      MAX         9 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "decimales" ] >= 0 .and. ::oController:oModel:hBuffer[ "decimales" ] <= 9 ) ;
      OF          ::oDialog

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "requerido" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oValorDefecto ;
      VAR         ::oController:oModel:hBuffer[ "defecto" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE BUTTON ::oAddDefecto;
      ID          160 ;
      OF          ::oDialog ;
      ACTION      ( ::addDefecto() )

   REDEFINE BUTTON ::oDelDefecto;
      ID          170 ;
      OF          ::oDialog ;
      ACTION      ( ::oListaDefecto:Del() )

   REDEFINE LISTBOX ::oListaDefecto ;
      VAR         ::cListaDefecto ;
      ITEMS       ::aListaDefecto ;
      ID          180 ;
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

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD addDefecto()
   
   if empty( ::oController:oModel:hBuffer[ "defecto" ] )
      RETURN ( .f. )
   end if 

   ::oListaDefecto:Add( ::oController:oModel:hBuffer[ "defecto" ] )

   ::oValorDefecto:cText( space( 100 ) )
   ::oValorDefecto:setFocus()

RETURN ( .t. )

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

   DATA cTableName                           INIT "campos_extra"

   METHOD getColumns()

   // METHOD getRequeridoAttribute( value )     INLINE ( value == 1 )

   // METHOD setRequeridoAttribute( value )     INLINE ( iif( value, 1, 0 ) )
          
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "requerido",         {  "create"    => "BIT"                                     ,;
                                             "default"   => {|| .f. } }                               )

   hset( ::hColumns, "tipo",              {  "create"    => "VARCHAR( 10 )"                           ,;
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