#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DescuentosController FROM SQLNavigatorController

   DATA uuidOlderParent 

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()                     INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()                        INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) ;
                                                INLINE ( ::setUuidOlderParent( uuidEntidad ) )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := DescuentosBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := DescuentosView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := DescuentosValidator():New( self  ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := DescuentosRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLDescuentosModel():New( self ), ), ::oModel )
   
END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS DescuentosController

   ::Super:New( oController )

   ::cTitle                      := "Descuentos"

   ::cName                       := "descuentos"

   ::hImage                      := {  "16" => "gc_symbol_percent_16",;
                                       "32" => "gc_symbol_percent_32",;
                                       "48" => "gc_symbol_percent_48" }

   ::nLevel                      := Auth():Level( ::cName )


   ::setEvent( 'appended',                      {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'edited',                        {|| ::getBrowseView():Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::getBrowseView():Refresh() } )

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DescuentosController

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

   if !empty( ::oRepository )
      ::oRepository:End()
   end if

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DescuentosController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuiddescuento ) CLASS DescuentosController

   local idDescuento     

   if empty( uuiddescuento )
      ::getModel():insertBuffer()
   end if 

   idDescuento          := ::getModel():getIdWhereParentUuid( uuiddescuento )
   if empty( idDescuento )
      idDescuento       := ::getModel():insertBlankBuffer()
   end if 

   ::getModel():loadCurrentBuffer( idDescuento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidDescuento ) CLASS DescuentosController

   local idDescuento     

   idDescuento          := ::getModel():getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS DescuentosController

   if empty( aUuidEntidades )
      RETURN ( nil )
   end if

   ::getModel():deleteWhereParentUuid( aUuidEntidades )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DescuentosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DescuentosBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'descuento'
      :cHeader             := 'Descuento'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'descuento' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_inicio'
      :cHeader             := 'Inicio'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_inicio' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'fecha_fin'
      :cHeader             := 'Fin'
      :nWidth              := 120
      :bEditValue          := {|| ::getRowSet():fieldGet( 'fecha_fin' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DescuentosView FROM SQLBaseView
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DescuentosView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DESCUENTOS" ;
      TITLE       ::LblTitle() + "descuento"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "descuento" ] ;
      ID          110 ;
      SPINNER ;
      PICTURE     "@E 999.9999" ;
      VALID       ( ::oController:validate( "descuento" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_inicio" ] ;
      ID          120 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_fin" ] ;
      ID          130 ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DescuentosValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DescuentosValidator

   ::hValidators  := {     "nombre" =>                {  "required"           => "El nombre es un dato requerido",;
                                                         "unique"             => "El nombre introducido ya existe" },;
                           "descuento" =>             {  "required"           => "El porcentaje de descuento es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDescuentosModel FROM SQLCompanyModel

   DATA cTableName               INIT "clientes_descuentos"

   DATA cConstraints             INIT "PRIMARY KEY ( nombre,parent_uuid, deleted_at )"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD getSentenceOthersWhereParentUuid( uuidParent )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDescuentosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| space( 40 ) } }                       )


   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "fecha_inicio",            {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "fecha_fin",               {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "descuento",               {  "create"    => "FLOAT(7,4)"                              ,;
                                                   "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLDescuentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid() )

//---------------------------------------------------------------------------//

METHOD getSentenceOthersWhereParentUuid ( uuidParent ) CLASS SQLDescuentosModel

   local cSql

   TEXT INTO cSql

   SELECT *

      FROM %1$s

      WHERE parent_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )


RETURN ( cSql )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DescuentosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLDescuentosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//