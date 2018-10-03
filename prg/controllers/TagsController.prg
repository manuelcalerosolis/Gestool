#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TagsController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertTag()

   //Contrucciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := TagsBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := TagsView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := TagsValidator():New( self  ), ), ::oValidator )


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TagsController

   ::Super:New( oController )

   ::cTitle                := "Marcadores"

   ::cName                 := "tags"

   ::lTransactional        := .t.

   ::hImage                := { "16" => "gc_bookmarks_16" }

   ::nLevel                := Auth():Level( "marcadores" )

   ::oModel                := SQLTagsModel():New( self )

   ::oFilterController:setTableToFilter( ::getName() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TagsController

   if !empty(::oModel)
      ::oModel:End()
   endif

   if !empty(::oBrowseView)
      ::oBrowseView:End()
   endif

   if !empty(::oDialogView)
      ::oDialogView:End()
   endif

   if !empty(::oValidator)
      ::oValidator:End()
   endif

   ::Super:End()

   self                    := nil                                

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertTag( tageableUuid, tagUuid ) CLASS TagsController

   local hBuffer              

   if empty( tageableUuid )
      RETURN ( .f. )
   end if 

   if empty( tagUuid )
      RETURN ( .f. )
   end if 

   hBuffer                    := SQLTageableModel():loadBlankBuffer()
   hBuffer[ "tageable_uuid" ] := tageableUuid
   hBuffer[ "tag_uuid"]       := tagUuid
   SQLTageableModel():insertBuffer( hBuffer )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TagsBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TagsBrowseView

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
      :nWidth              := 180
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLTagsModel FROM SQLCompanyModel

   DATA cTableName               INIT "Tags"

   DATA cConstraints             INIT "PRIMARY KEY (id), KEY (uuid)"

   METHOD getColumns()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTagsModel

   hset( ::hColumns, "id",       {  "create"    => "INTEGER AUTO_INCREMENT"                  ,;
                                    "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",     {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                    "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "nombre",   {  "create"    => "VARCHAR( 50 )"                          ,;
                                    "default"   => {|| space( 50 ) } }                       )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TagsView FROM SQLBaseView

   DATA oEditControl

   DATA cEditControl 

   DATA oGetMarcador

   DATA cGetMarcador

   DATA oBtnTags

   DATA oTagsEver

   METHOD Activate()
   
   METHOD End()

   METHOD externalRedefine( hControl, oDialog )

   METHOD Start()

      METHOD validateAndAddTag( cMarcador )
      METHOD selectorAndAddTag()

      METHOD selectorEditControl()
      METHOD assertEditControl()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TagsView

   local oDialog

   DEFINE DIALOG  oDialog ;
      RESOURCE    "MARCADOR" ;
      TITLE       ::lblTitle() + "marcador"

   REDEFINE GET   ::getModel():hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( !::oController:isZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          oDialog

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDialog ;
      WHEN        ( !::oController:isZoomMode() ) ;   
      ACTION      ( if( validateDialog( oDialog ), oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDialog ;
      CANCEL ;
      ACTION      ( oDialog:end() )

   oDialog:AddFastKey( VK_F5, {|| if( validateDialog( oDialog ), oDialog:end( IDOK ), ) } )

   ACTIVATE DIALOG oDialog CENTER

RETURN ( oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD End() CLASS TagsView

   ::Super:end()

   if !empty( ::oBtnTags )
      ::oBtnTags:End()
   end if 

   if !empty( ::oTagsEver )
      ::oTagsEver:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD externalRedefine( hControl, oDialog ) CLASS TagsView

   if !hhaskey( hControl, "idGet" )       .or.  ;
      !hhaskey( hControl, "idButton" )    .or.  ;
      !hhaskey( hControl, "idTags" )      
      RETURN ( Self )
   end if 

   if hb_isnil( oDialog )
      RETURN ( Self )
   end if 

   REDEFINE GET            ::oGetMarcador ;
      VAR                  ::cGetMarcador ;
      ID                   ( hget( hControl, "idGet" ) ) ;
      WHEN                 ( ::oController:getController():isNotZoomMode() ) ;
      PICTURE              "@!" ;
      BITMAP               "gc_navigate_plus_16" ;
      OF                   oDialog

   ::oGetMarcador:bHelp    := {|| iif( ::validateAndAddTag( ::cGetMarcador ), ::oGetMarcador:cText( space( 100 ) ), ) }

   REDEFINE BTNBMP         ::oBtnTags ;
      ID                   ( hget( hControl, "idButton" ) ) ;
      RESOURCE             "lupa" ;
      WHEN                 ( ::oController:getController():isNotZoomMode() ) ;
      OF                   oDialog 

   ::oBtnTags:bAction      := {|| ::selectorAndAddTag() }

   ::oTagsEver             := TTagEver():Redefine( hget( hControl, "idTags" ), oDialog )
   ::oTagsEver:bWhen       := {|| ::oController:getController():isNotZoomMode() }
   ::oTagsEver:bOnDelete   := {| oTag, oTagItem | SQLTageableModel():deleteByUuid( oTagItem:uCargo ) }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validateAndAddTag( cMarcador ) CLASS TagsView

   local uuidTag

   cMarcador      := alltrim( cMarcador )

   if empty( cMarcador )
      RETURN ( .f. )
   end if 

   if ascan( ::oTagsEver:aItems, {|oItem| upper( oItem:cText ) == upper( cMarcador ) } ) != 0
      msgStop( "Este marcador ya está incluido" )
      RETURN ( .f. )
   end if 

   uuidTag        := ::oController:oModel:getUuidWhereNombre( cMarcador ) 
   if empty( uuidTag )
      msgStop( "Este marcador : " + cMarcador + " , no existe" )
      RETURN ( .f. )
   end if 

   ::oController:insertTag( ::oController:getController():getUuid(), uuidTag )

   ::oTagsEver:addItem( cMarcador )
   ::oTagsEver:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD selectorAndAddTag() CLASS TagsView

   local hMarcador   := ::oController:activateSelectorView()

   if !empty( hMarcador ) 
      ::validateAndAddTag( hget( hMarcador, "nombre" ) )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD selectorEditControl() CLASS TagsView

   local hMarcador   := ::oController:activateSelectorView()

   if !empty( hMarcador )
      ::oEditControl:cText( hget( hMarcador, "id" ) )
      ::oEditControl:oHelpText:cText( hget( hMarcador, "nombre" ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Start()
   
   local aTags       := TageableRepository():getHashTageableTags( ::oController:getController():getUuid() ) 

   if empty( aTags )
      RETURN ( .t. )
   end if 

   aeval( aTags, {|h| ::oTagsEver:addItem( hget( h, "nombre" ), hget( h, "uuid" ) ) } )

   ::oTagsEver:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD assertEditControl() CLASS TagsView

   local uValue      := ::oEditControl:VarGet()
   local lAssert     := ::oController:assert( "id", uValue )

   if lAssert 
      ::oEditControl:oHelpText:cText( ::getController():getRepository():getColumnWhereId( uValue ) )
   end if 

RETURN ( lAssert )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS TagsValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getAsserts()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS TagsValidator

   ::hValidators  := {  "nombre" => {  "required"     => "El nombre es un dato requerido",;
                                       "unique"       => "El nombre ya existe" } } 

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getAsserts() CLASS TagsValidator

   ::hAsserts     := {  "id"     => {  "emptyOrExist" => "El identificador no existe" },;
                        "nombre" => {  "emptyOrExist" => "El nombre no existe" } } 

RETURN ( ::hAsserts )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

