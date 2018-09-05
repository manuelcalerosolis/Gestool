#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AlmacenesController FROM SQLNavigatorController

   DATA oDireccionesController

   DATA oPaisesController

   DATA oProvinciasController

   DATA oZonasController

   DATA oCamposExtraValoresController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD gettingSelectSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS AlmacenesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Almacenes"

   ::cName                          := "almacenes"

   ::hImage                         := {  "16" => "gc_warehouse_16",;
                                          "32" => "gc_warehouse_32",;
                                          "48" => "gc_warehouse_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLAlmacenesModel():New( self )

   ::oBrowseView                    := AlmacenesBrowseView():New( self )

   ::oDialogView                    := AlmacenesView():New( self )

   ::oValidator                     := AlmacenesValidator():New( self, ::oDialogView )

   ::oGetSelector                   := GetSelector():New( self )

   ::oRepository                    := AlmacenesRepository():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )
   
   ::oDireccionesController         := DireccionesController():New( self )

   ::oZonasController               := ZonasController():New( self )

   ::oPaisesController              := PaisesController():New( self )

   ::oProvinciasController          := ProvinciasController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oDireccionesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oDireccionesController:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oDireccionesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oDireccionesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oDireccionesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oDireccionesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oDireccionesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

   ::oModel:setEvent( 'gettingSelectSentence',        {|| ::gettingSelectSentence() } ) 

   ::setEvents( { 'editing', 'deleting' },            {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AlmacenesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oGetSelector:End()

   ::oRepository:End()

   ::oCamposExtraValoresController:End()

   ::oDireccionesController:End()

   ::oZonasController:End()

   ::oPaisesController:End()

   ::oProvinciasController:End()

   ::oModel                         := nil

   ::oBrowseView                    := nil

   ::oDialogView                    := nil

   ::oValidator                     := nil

   ::oGetSelector                   := nil

   ::oRepository                    := nil

   ::oCamposExtraValoresController  := nil

   ::oDireccionesController         := nil

   ::oZonasController               := nil

   ::oPaisesController              := nil

   ::oProvinciasController          := nil

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS AlmacenesController

   ::oModel:setGeneralWhere( "almacen_uuid = ''" )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS AlmacenesBrowseView

   with object ( ::oBrowse:AddCol() )
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

CLASS AlmacenesView FROM SQLBaseView
  
   DATA oGetPais
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oSayCamposExtra

   METHOD Activate()

   METHOD Activating()

   METHOD getDireccionesController()   INLINE ( ::oController:oDireccionesController )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS AlmacenesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS AlmacenesView

   local oBtnEdit
   local oBtnAppend
   local oBtnDelete
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "ALMACEN_SQL" ;
      TITLE       ::LblTitle() + "almacén"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          160 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

   ::oController:oDireccionesController:oDialogView:ExternalRedefine( ::oDialog )

   // Zonas--------------------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          120 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oZonasController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:oZonasController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          140 ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oZonasController:Delete() }

   ::oController:oZonasController:Activate( 150, ::oDialog ) 

   // Botones almacenes -------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::oController:oDireccionesController:oDialogView:StartDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getUniqueSenctence( uValue )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AlmacenesValidator

   ::hValidators  := {  "nombre" =>    {  "required"     => "El nombre es un dato requerido",;
                                          "unique"       => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"     => "El código es un dato requerido" ,;
                                          "unique"       => "EL código introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD getUniqueSenctence( uValue ) CLASS AlmacenesValidator

   local cSQLSentence   := ::Super:getUniqueSenctence( uValue )

   if empty( ::oController ) .or. empty( ::oController:getSenderController() )
      cSQLSentence      +=    " AND almacen_uuid = ''"
   else 
      cSQLSentence      +=    " AND almacen_uuid = " + quoted( ::oController:getSenderController():getUuid() )
   end if

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAlmacenesModel FROM SQLCompanyModel

   DATA cTableName               INIT "almacenes"

   METHOD getColumns()

   METHOD getAlmacenUuidAttribute( value )

   METHOD getInsertAlmacenSentence()

   METHOD CountAlmacenWhereCodigo( cCodigoAlmacen)

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAlmacenesModel
   
   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "almacen_uuid",      {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 ) NOT NULL"                 ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "sistema",           {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getAlmacenUuidAttribute( value ) CLASS SQLAlmacenesModel
   
   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:getSenderController() )
      RETURN ( value )
   end if

RETURN ( ::oController:getSenderController():getUuid() )

//---------------------------------------------------------------------------//

METHOD getInsertAlmacenSentence() CLASS SQLAlmacenesModel

   local cSentence   := "INSERT IGNORE INTO " + ::getTableName()                          + " " + ;
                           "( uuid, codigo, nombre, sistema )"                            + " " + ;
                        "VALUES"                                                          + " " + ;
                           "( " + quoted( win_uuidcreatestring() ) + ", '1', 'Principal', 1 )"

RETURN ( cSentence )

//---------------------------------------------------------------------------//

METHOD CountAlmacenWhereCodigo( cCodigoAlmacen ) CLASS SQLAlmacenesModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

   FROM %1$s AS almacenes
    
   WHERE almacenes.codigo = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigoAlmacen ) )


RETURN ( getSQLDatabase():getValue ( cSql ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AlmacenesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLAlmacenesModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS AlmacenesRepository

   local aResult     
   local aNombres

   aResult           := {}
   aNombres          := ::getDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )

   if !empty( aNombres )
      aeval( aNombres, {| h | aadd( aResult, alltrim( hGet( h, "nombre" ) ) ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//