#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DescuentosController FROM SQLNavigatorController

   METHOD New()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS DescuentosController

   ::Super:New( oSenderController )

   ::cTitle                      := "Descuentos"

   ::cName                       := "descuentos"

   ::hImage                      := {  "16" => "gc_symbol_percent_16",;
                                       "32" => "gc_hint_32",;
                                       "48" => "gc_hint_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLDescuentosModel():New( self )

   ::oBrowseView                    := DescuentosBrowseView():New( self )

   ::oDialogView                    := DescuentosView():New( self )

   ::oValidator                     := DescuentosValidator():New( self, ::oDialogView )

   ::oRepository                    := DescuentosRepository():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DescuentosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DescuentosController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuiddescuento ) CLASS DescuentosController

   local idDescuento     

   if empty( uuiddescuento )
      ::oModel:insertBuffer()
   end if 

   idDescuento          := ::oModel:getIdWhereParentUuid( uuiddescuento )
   if empty( idDescuento )
      idDescuento       := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDescuento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidDescuento ) CLASS DescuentosController

   local idDescuento     

   idDescuento          := ::oModel:getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidDescuento ) CLASS DescuentosController

   local idDescuento     

   idDescuento          := ::oModel:getIdWhereParentUuid( uuidDescuento )
   if empty( idDescuento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idDescuento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidDescuento ) CLASS DescuentosController

   hset( ::oModel:hBuffer, "parent_uuid", uuidDescuento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS DescuentosController

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
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DescuentosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DescuentosBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DescuentosView FROM SQLBaseView
  
   DATA oGetFechaResolucion

   METHOD Activate()

   METHOD startDialog()

   METHOD changeFechaResolucion()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DescuentosView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "INCIDENCIA_SQL" ;
      TITLE       ::LblTitle() + "incidencia"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_hint_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   /*REDEFINE GET   ::oController:oModel:hBuffer[ "fecha_hora" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "mostrar" ] ;
      ID          110 ;
      IDSAY       112 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "descripcion" ] ;
      ID          120 ;
      MEMO ;
      VALID       ( ::oController:validate( "descripcion" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "resuelta" ] ;
      ID          130 ;
      IDSAY       132 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::changeFechaResolucion() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetFechaResolucion ;
      VAR         ::oController:oModel:hBuffer[ "fecha_hora_resolucion" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
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
      ACTION     ( ::oDialog:end() )*/

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS DescuentosView

   /*if !::oController:oModel:hBuffer[ "resuelta" ]
      ::oGetFechaResolucion:Hide()
      ::oGetFechaResolucion:Refresh()
   end if*/

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD changeFechaResolucion() CLASS DescuentosView

   /*if ::oController:oModel:hBuffer[ "resuelta" ]

      hSet( ::oController:oModel:hBuffer, "fecha_hora_resolucion", hb_datetime() )
      ::oGetFechaResolucion:Show()

   else

      hSet( ::oController:oModel:hBuffer, "fecha_hora_resolucion", hb_StrToTS( "" ) )
      ::oGetFechaResolucion:Hide()

   end if

   ::oGetFechaResolucion:Refresh()*/

Return ( self )

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

   ::hValidators  := {  "nombre" =>           {  "required"              => "La descripción es un dato requerido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDescuentosModel FROM SQLBaseModel

   DATA cTableName               INIT "descuentos"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDescuentosModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;                                  
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| space( 40 ) } }                       )

   ::getEmpresaColumns()

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                                   "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "fecha_inicio",            {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "fecha_fin",               {  "create"    => "DATE"                                    ,;
                                                   "default"   => {|| ctod( "" ) } }                        )

   hset( ::hColumns, "descuento",               {  "create"    => "DECIMAL(19,6)"                           ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "cantidad_minima",         {  "create"    => "INT UNSIGNED"                            ,;
                                                   "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLDescuentosModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

RETURN ( ::oController:oSenderController:getUuid() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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