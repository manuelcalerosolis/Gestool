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
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'tipo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'longitud'
      :cHeader             := 'Longitud'
      :nWidth              := 60
      :nHeadStrAlign       := AL_RIGHT
      :nDataStrAlign       := AL_RIGHT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'longitud' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'decimales'
      :cHeader             := 'Decimales'
      :nWidth              := 60
      :nHeadStrAlign       := AL_RIGHT
      :nDataStrAlign       := AL_RIGHT
      :bEditValue          := {|| ::getRowSet():fieldGet( 'decimales' ) }
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

   DATA oDecimales

   DATA oTipo

   DATA aTipos 

   DATA hTipos

   DATA oLista

   DATA cLista

   DATA oAddListaValores

   DATA oDelListaValores 

   DATA oListaValores

   DATA cListaValores

   DATA aListaValores                  

   METHOD New()

   METHOD enableLongitud()             INLINE ( ::verticalShow( ::oLongitud ), ::verticalShow( ::oDecimales ) )

   METHOD disableLongitud()            INLINE ( ::verticalHide( ::oLongitud ), ::verticalHide( ::oDecimales ) )

   METHOD setLongitud( nLen, nDec )    INLINE ( ::oLongitud:cText( nLen ), ::oDecimales:cText( nDec ) )

   METHOD enableDefecto()              INLINE ( ::verticalShow( ::oLista ), ::verticalShow( ::oListaValores ), ::oAddListaValores:Show(), ::oDelListaValores:Show() )

   METHOD disableDefecto()             INLINE ( ::verticalHide( ::oLista ), ::verticalHide( ::oListaValores ), ::oAddListaValores:Hide(), ::oDelListaValores:Hide() )

   METHOD changeTipo( cTipo )          INLINE ( if( hhaskey( ::hTipos, cTipo ), eval( hGet( ::hTipos, cTipo ) ), ) )

   METHOD addListaValores()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CamposExtraView

   ::Super:New( oController )

   ::aTipos          := {  "Texto", "Número", "Fecha", "Lógico", "Lista" }

   ::hTipos          := {  "Texto"  => {|| ::verticalShow( ::oLongitud ), ::verticalHide( ::oDecimales ), ::setLongitud( 100, 0 ), ::disableDefecto() },;
                           "Número" => {|| ::enableLongitud(), ::disableDefecto(), ::setLongitud( 16, 6 ) },;
                           "Fecha"  => {|| ::disableLongitud(), ::setLongitud( 8, 0 ), ::disableDefecto() },;
                           "Lógico" => {|| ::disableLongitud(), ::setLongitud( 1, 0 ), ::disableDefecto() },;
                           "Lista"  => {|| ::disableLongitud(), ::setLongitud( 10, 0 ), ::enableDefecto() } }

   ::cLista          := space( 200 )

   ::aListaValores   := {}

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CAMPOS_EXTRA";
      TITLE       ::LblTitle() + "campo extra"

   REDEFINE BITMAP ::oBitmap ;
      ID          IDBITMAP ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          IDMESSAGE ;
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

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "requerido" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oLongitud ;
      VAR         ::oController:oModel:hBuffer[ "longitud" ] ;
      ID          130 ;
      IDSAY       131 ;
      PICTURE     "999" ;
      SPINNER ;
      MIN         1 ;
      MAX         200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "longitud" ] >= 1 .and. ::oController:oModel:hBuffer[ "longitud" ] <= 200 ) ;
      OF          ::oDialog

   REDEFINE GET   ::oDecimales ;
      VAR         ::oController:oModel:hBuffer[ "decimales" ] ;
      ID          140 ;
      IDSAY       141 ;
      PICTURE     "9" ;
      SPINNER ;
      MIN         0 ;
      MAX         9 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "decimales" ] >= 0 .and. ::oController:oModel:hBuffer[ "decimales" ] <= 9 ) ;
      OF          ::oDialog

   REDEFINE GET   ::oLista ;
      VAR         ::cLista ;
      ID          150 ;
      IDSAY       151 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE BUTTON ::oAddListaValores;
      ID          160 ;
      OF          ::oDialog ;
      ACTION      ( ::addListaValores() )

   REDEFINE BUTTON ::oDelListaValores ;
      ID          170 ;
      OF          ::oDialog ;
      ACTION      ( ::oListaValores:Del() )

   REDEFINE LISTBOX ::oListaValores ;
      VAR         ::cListaValores ;
      ITEMS       ::oController:oModel:hBuffer[ "lista" ] ;
      ID          180 ;
      OF          ::oDialog

   ::oListaValores:lVisible := .t.

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

   ::oDialog:bStart  := {|| ::ChangeTipo( alltrim( ::oController:oModel:hBuffer[ "tipo" ] ) ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD addListaValores()
   
   if empty( ::cLista )
      RETURN ( .f. )
   end if 

   ::oListaValores:Add( alltrim( ::cLista ) )

   ::oLista:cText( space( 100 ) )
   ::oLista:setFocus()

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

   METHOD getListaAttribute( value )         INLINE ( if( empty( value ), {}, hb_deserialize( value ) ) )

   METHOD setListaAttribute( value )         INLINE ( hb_serialize( value ) )
          
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

   hset( ::hColumns, "lista",             {  "create"    => "TEXT"                                    ,;
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