#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TraduccionesController FROM SQLNavigatorController

   DATA oLenguajesController

   METHOD New()

   METHOD End()

   METHOD loadedBlankBuffer()

   METHOD gettingSelectSentence()

   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS TraduccionesController

   ::Super:New( oSenderController )

   ::lTransactional        := .t.

   ::cTitle                := "Traducciones"

   ::cName                 := "traducciones"

   ::hImage                := {  "16" => "gc_user_message_16",;
                                 "32" => "gc_user_message_32",;
                                 "48" => "gc_user_message_48" }

   ::oModel                := SQLTraduccionesModel():New( self )

   ::oBrowseView           := TraduccionesBrowseView():New( self )

   ::oDialogView           := TraduccionesView():New( self )

   ::oValidator            := TraduccionesValidator():New( self, ::oDialogView )

   ::oLenguajesController  := LenguajesController():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'loadedBlankBuffer',      {|| ::loadedBlankBuffer() } ) 
   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TraduccionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oLenguajesController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS TraduccionesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS TraduccionesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS TraduccionesController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS TraduccionesController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

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
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'texto'
      :cHeader             := 'Texto'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'texto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

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

   ::oController:oLenguajesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "lenguaje_uuid" ] ) )
   ::oController:oLenguajesController:oGetSelector:Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )

   REDEFINE GET   ::oController:oModel:hBuffer[ "texto" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "texto" ) ) ;
      OF          ::oDialog
      
   REDEFINE GET   ::oController:oModel:hBuffer[ "texto_extendido" ] ;
      ID          120 ;
      MEMO ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "texto_extendido" ) ) ;
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

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

   CursorWait()

   ::oController:oLenguajesController:oGetSelector:Start()

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

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getLenguajeUuidAttribute( uuid )         INLINE ( if( empty( uuid ), space( 3 ), SQLLenguajesModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setLenguajeUuidAttribute( codigo )       INLINE ( if( empty( codigo ), "", SQLLenguajesModel():getUuidWhereCodigo( codigo ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLTraduccionesModel

   local cSelect  := "SELECT traducciones.id, "                                                                + ;
                        "traducciones.uuid, "                                                                  + ;
                        "traducciones.parent_uuid, "                                                           + ;
                        "lenguajes.codigo, "                                                                   + ;
                        "lenguajes.nombre, "                                                                   + ;
                        "traducciones.texto, "                                                                 + ;
                        "LEFT( traducciones.texto_extendido, 256 ) "                                           + ;
                        "FROM " + ::getTableName() + " AS traducciones "                                         + ;
                        "INNER JOIN " +SQLLenguajesModel():getTableName() + " AS lenguajes "                   + ;
                           "ON lenguajes.uuid = traducciones.lenguaje_uuid"

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTraduccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "lenguaje_uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "texto",             {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "texto_extendido",   {  "create"    => "TEXT"                                    ,;
                                             "default"   => {|| "" } }                                )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

