#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TraduccionesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD loadedBlankBuffer()

   METHOD gettingSelectSentence()

   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := TraduccionesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := TraduccionesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := TraduccionesValidator():New( self ), ), ::oValidator )
   
   METHOD getModel()                      INLINE( if( empty( ::oModel ), ::oModel := SQLTraduccionesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TraduccionesController

   ::Super:New( oController )

   ::lTransactional        := .t.

   ::cTitle                := "Traducciones"

   ::cName                 := "traducciones"

   ::hImage                := {  "16" => "gc_user_message_16",;
                                 "32" => "gc_user_message_32",;
                                 "48" => "gc_user_message_48" }

   //::oModel                := SQLTraduccionesModel():New( self )

   ::setEvent( 'appended',                      {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'edited',                        {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::getBrowseView():Refresh() } )

   ::getModel():setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TraduccionesController
   
   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if

   if !empty( ::oValidator )
      ::oValidator:End()
   end if

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS TraduccionesController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      hset( ::getModel():hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS TraduccionesController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS TraduccionesController

   hset( ::getModel():hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS TraduccionesController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TraduccionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TraduccionesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'uuid'
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'parent_uuid'
      :cHeader             := 'Uuid entidad'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'parent_uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Lenguaje'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'lenguaje_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'texto'
      :cHeader             := 'Texto'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'texto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TraduccionesView FROM SQLBaseView
  
   METHOD Activate()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TraduccionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRADUCCIONES" ;
      TITLE       ::LblTitle() + "traducciones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::oController:getLenguajesController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "lenguaje_codigo" ] ) )
   ::oController:getLenguajesController():getSelector():Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )

   REDEFINE GET   ::oController:getModel():hBuffer[ "texto" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "texto" ) ) ;
      OF          ::oDialog
      
   REDEFINE GET   ::oController:getModel():hBuffer[ "texto_extendido" ] ;
      ID          120 ;
      MEMO ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "texto_extendido" ) ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

   CursorWait()

   ::oController:getLenguajesController():getSelector():Start()

   CursorWE()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TraduccionesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TraduccionesValidator

   ::hValidators  := {  "texto"  => {  "required"  => "El texto de la traducción es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTraduccionesModel FROM SQLCompanyModel

   DATA cTableName                                 INIT "traducciones"

   DATA cConstraints                               INIT "PRIMARY KEY ( parent_uuid, texto, deleted_at )"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLTraduccionesModel

   local cSql 

   TEXT INTO cSql

   SELECT traducciones.id as id,
      traducciones.uuid AS uuid, 
      traducciones.parent_uuid AS parent_uuid, 
      traducciones.lenguaje_codigo AS lenguaje_codigo, 
      lenguajes.nombre AS lenguaje_nombre, 
      traducciones.texto AS texto, 
      LEFT( traducciones.texto_extendido, 256 ) AS texto_extendido,
      traducciones.deleted_at AS deleted_as 
   
   FROM %1$s AS traducciones 
   
      LEFT JOIN %2$s AS lenguajes 
         ON lenguajes.codigo = traducciones.lenguaje_codigo AND lenguajes.deleted_at = 0

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLLenguajesModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTraduccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "lenguaje_codigo",   {  "create"    => "VARCHAR ( 20 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "texto",             {  "create"    => "VARCHAR ( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "texto_extendido",   {  "create"    => "TEXT"                                    ,;
                                             "default"   => {|| "" } }                                )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

