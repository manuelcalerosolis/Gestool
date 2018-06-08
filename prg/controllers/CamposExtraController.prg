#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CamposExtraGestoolController FROM CamposExtraController

   METHOD getModel()                            INLINE ( ::oModel := SQLCamposExtraGestoolModel():New( self ) )

   METHOD getLevel()                            INLINE ( nil )

   METHOD getCamposExtraEntidadesController()   INLINE ( ::oCamposExtraEntidadesController := CamposExtraEntidadesGestoolController():New( self ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CamposExtraController FROM SQLNavigatorController

   DATA oCamposExtraEntidadesController

   METHOD New()

   METHOD End()

   METHOD deleteEntitiesWhereEmpty()

   METHOD getModel()                            INLINE ( ::oModel := SQLCamposExtraModel():New( self ) )

   METHOD getLevel()                            INLINE ( ::nLevel := Auth():Level( ::getName() ) )

   METHOD getCamposExtraEntidadesController()   INLINE ( ::oCamposExtraEntidadesController := CamposExtraEntidadesController():New( self ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS CamposExtraController

   ::Super:New()

   ::cTitle                            := "Campos extra"

   ::setName( "campos_extra" )

   ::lTransactional                    := .t.


   ::hImage                            := {  "16" => "gc_form_plus2_16",;
                                             "32" => "gc_form_plus2_32",;
                                             "48" => "gc_form_plus2_48" }

   ::getLevel()

   ::getModel()

   ::oBrowseView                       := CamposExtraBrowseView():New( self )

   ::oDialogView                       := CamposExtraView():New( self )

   ::oValidator                        := CamposExtraValidator():New( self, ::oDialogView )

   ::getCamposExtraEntidadesController()

   ::setEvent( 'edited',      {|| ::deleteEntitiesWhereEmpty() } )
   ::setEvent( 'appended',    {|| ::deleteEntitiesWhereEmpty() } )
   ::setEvent( 'duplicated',  {|| ::deleteEntitiesWhereEmpty() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CamposExtraController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oCamposExtraEntidadesController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD deleteEntitiesWhereEmpty()
   
   ::oCamposExtraEntidadesController:oModel:deleteBlankEntityWhereUuid( ::getUuid() )

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
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
      :nWidth              := 80
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

   DATA oFolder
  
   DATA oLongitud

   DATA oDecimales

   DATA oDecimales

   DATA oTipo

   DATA aTipos 

   DATA hBehavior

   DATA hOnChange

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

   METHOD changeBehavior( cTipo )      INLINE ( iif( hhaskey( ::hBehavior, cTipo ), eval( hGet( ::hBehavior, cTipo ) ), ) )

   METHOD changeTipo( cTipo )          INLINE ( iif( hhaskey( ::hOnChange, cTipo ), eval( hGet( ::hOnChange, cTipo ) ), ), ::changeBehavior( cTipo ) )

   METHOD addListaValores()

   METHOD Activate()
   METHOD Activating()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CamposExtraView

   ::Super:New( oController )

   ::aTipos          := {  "Texto", "N�mero", "Fecha", "L�gico", "Lista" }

   ::hBehavior       := {  "Texto"  => {|| ::verticalShow( ::oLongitud ), ::verticalHide( ::oDecimales ), ::disableDefecto() },;
                           "N�mero" => {|| ::enableLongitud(), ::disableDefecto() },;
                           "Fecha"  => {|| ::disableLongitud(), ::disableDefecto() },;
                           "L�gico" => {|| ::disableLongitud(), ::disableDefecto() },;
                           "Lista"  => {|| ::disableLongitud(), ::enableDefecto() } }

   ::hOnChange       := {  "Texto"  => {|| ::setLongitud( 100, 0 ) },;
                           "N�mero" => {|| ::setLongitud( 16, 6 ) },;
                           "Fecha"  => {|| ::setLongitud( 8, 0 ) },;
                           "L�gico" => {|| ::setLongitud( 1, 0 ) },;
                           "Lista"  => {|| ::setLongitud( 10, 0 ) } }

   ::cLista          := space( 200 )

   ::aListaValores   := {}

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activating() CLASS CamposExtraView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer[ "tipo" ]    := "Texto"
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS CamposExtraView

   local oBtnAppend
   local oBtnDelete

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

   REDEFINE FOLDER ::oFolder ;
      ID          100 ;
      OF          ::oDialog ;
      PROMPT      "&General" ,;
                  "&Entidades" ;
      DIALOGS     "CAMPOS_EXTRA_PRINCIPAL",;
                  "CAMPOS_EXTRA_ENTIDADES"

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[ 1 ] 

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[ 1 ]

   REDEFINE COMBOBOX ::oTipo ;
      VAR         ::oController:oModel:hBuffer[ "tipo" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ITEMS       ( ::aTipos ) ;
      OF          ::oFolder:aDialogs[ 1 ]

   ::oTipo:bChange   := {|| ::ChangeTipo( ::oController:oModel:hBuffer[ "tipo" ] ) }

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "requerido" ] ;
      ID          130 ;
      IDSAY       132;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[ 1 ]

   REDEFINE GET   ::oLongitud ;
      VAR         ::oController:oModel:hBuffer[ "longitud" ] ;
      ID          140 ;
      IDSAY       131 ;
      PICTURE     "999" ;
      SPINNER ;
      MIN         1 ;
      MAX         200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "longitud" ] >= 1 .and. ::oController:oModel:hBuffer[ "longitud" ] <= 200 ) ;
      OF          ::oFolder:aDialogs[ 1 ]

   REDEFINE GET   ::oDecimales ;
      VAR         ::oController:oModel:hBuffer[ "decimales" ] ;
      ID          150 ;
      IDSAY       141 ;
      PICTURE     "9" ;
      SPINNER ;
      MIN         0 ;
      MAX         9 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "decimales" ] >= 0 .and. ::oController:oModel:hBuffer[ "decimales" ] <= 9 ) ;
      OF          ::oFolder:aDialogs[ 1 ]

   REDEFINE GET   ::oLista ;
      VAR         ::cLista ;
      ID          160 ;
      IDSAY       151 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[ 1 ]

   REDEFINE BUTTON ::oAddListaValores;
      ID          170 ;
      OF          ::oFolder:aDialogs[ 1 ] ;
      ACTION      ( ::addListaValores() )

   REDEFINE BUTTON ::oDelListaValores ;
      ID          180 ;
      OF          ::oFolder:aDialogs[ 1 ] ;
      ACTION      ( ::oListaValores:Del() )

   REDEFINE LISTBOX ::oListaValores ;
      VAR         ::cListaValores ;
      ITEMS       ::oController:oModel:hBuffer[ "lista" ] ;
      ID          190 ;
      OF          ::oFolder:aDialogs[ 1 ]

   ::oListaValores:lVisible := .t.

   // Segunda pesta�a----------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          100 ;
      OF          ::oFolder:aDialogs[ 2 ] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oCamposExtraEntidadesController:Append() }

   REDEFINE BUTTON oBtnDelete ;
      ID          110 ;
      OF          ::oFolder:aDialogs[ 2 ] ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oCamposExtraEntidadesController:Delete( ::oController:oCamposExtraEntidadesController:oBrowseView:oBrowse:aSelected ) }

   ::oController:oCamposExtraEntidadesController:Activate( 120, ::oFolder:aDialogs[ 2 ] )

   // Botones ------------------------------------------------------------------

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oFolder:aDialogs[ 1 ] ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   ::oDialog:bStart  := {|| ::changeBehavior( alltrim( ::oController:oModel:hBuffer[ "tipo" ] ) ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oFolder:aDialogs[ 1 ] ), ::oDialog:end( IDOK ), ) } )
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

   ::hValidators  := {     "codigo" =>    {  "required"           => "El codigo es un dato requerido",;
                                             "unique"             => "El codigo introducido ya existe"  } ,;
                           "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                             "unique"             => "El nombre introducido ya existe" } ,;   
                           "tipo"     =>  {  "required"           => "El tipo es un dato requerido" } ,; 
                           "longitud" =>  {  "required"           => "La longitud es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraGestoolModel FROM SQLCamposExtraModel

   METHOD getTableName()   INLINE ( "gestool." + ::cTableName )

END CLASS
   
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCamposExtraModel FROM SQLCompanyModel

   DATA cTableName                           INIT "campos_extra"

   METHOD getColumns()

   METHOD getListaAttribute( value )         INLINE ( if( empty( value ), {}, hb_deserialize( value ) ) )

   METHOD setListaAttribute( value )         INLINE ( hb_serialize( value ) )
          
END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCamposExtraModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 )"                            ,;
                                             "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "requerido",         {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| .f. } }                               )

   hset( ::hColumns, "tipo",              {  "create"    => "VARCHAR( 10 )"                           ,;
                                             "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "longitud",          {  "create"    => "SMALLINT UNSIGNED"                       ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "decimales",         {  "create"    => "SMALLINT UNSIGNED"                       ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "lista",             {  "create"    => "TEXT"                                    ,;
                                             "default"   => {|| space( 200 ) } }                      )
   
   ::getTimeStampColumns()

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