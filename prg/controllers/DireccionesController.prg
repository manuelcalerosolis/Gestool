#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionesController FROM SQLBrowseController

   DATA oPaisesController
   DATA oProvinciasController

   METHOD New()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()         INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()            INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS DireccionesController

   ::Super:New( oSenderController )

   ::lTransactional              := .t.

   ::cTitle                      := "Direcciones"

   ::cName                       := "direcciones"

   ::oModel                      := SQLDireccionesModel():New( self )

   ::oBrowseView                 := DireccionesBrowseView():New( self )

   ::oDialogView                 := DireccionesView():New( self )

   ::oValidator                  := DireccionesValidator():New( self, ::oDialogView )

   ::oPaisesController           := PaisesController():New( self )
   ::oProvinciasController       := ProvinciasController():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } ) 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DireccionesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   if empty( uuidEntidad )
      ::oModel:insertBuffer()
   end if 

   idDireccion          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDireccion )
      idDireccion       := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   idDireccion          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDireccion )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD LoadedDuplicateCurrentBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   idDireccion          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDireccion )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idDireccion )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD LoadedDuplicateBuffer( uuidEntidad ) CLASS DireccionesController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD DireccionesControllerDeleteBuffer( aUuidEntidades )

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oDireccionesController:oModel:deleteWhereParentUuid( aUuidEntidades )

   RETURN ( self )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS DireccionesBrowseView

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Direcci�n'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Poblaci�n'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'provincia'
      :cHeader             := 'Provincia'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'provincia' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_postal'
      :cHeader             := 'C�digo Postal'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono'
      :cHeader             := 'Tel�fono'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with   

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movil'
      :cHeader             := 'M�vil'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'movil' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'email'
      :cHeader             := 'Email'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'email' ) }
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

CLASS DireccionesView FROM SQLBaseView
  
   DATA oGetPoblacion
   DATA oGetProvincia
   DATA oGetPais

   METHOD Activate()

   METHOD ExternalRedefine( oDialog )
   
   METHOD validateFields()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DireccionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DIRECCION" ;
      TITLE       ::LblTitle() + "direcciones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_signpost3_48" ;
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

   REDEFINE GET   ::oController:oModel:hBuffer[ "direccion" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_postal" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_postal" ), ::validateFields() ) ;
      OF          ::oDialog 

   REDEFINE GET   ::oGetPoblacion VAR ::oController:oModel:hBuffer[ "poblacion" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "poblacion" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetProvincia VAR ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          140 ;
      IDTEXT      141 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ), ::validateFields() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

   ::oGetProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( ::oGetProvincia ), ::validateFields() }

   REDEFINE GET   ::oGetPais VAR ::oController:oModel:hBuffer[ "codigo_pais" ] ;
      ID          180 ;
      IDTEXT      181 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_pais" ), ::validateFields() ) ;
      BITMAP      "LUPA" ;
      OF          ::oDialog

   ::oGetPais:bHelp  := {|| ::oController:oPaisesController:getSelectorPais( ::oGetPais ), ::validateFields() }

   REDEFINE GET   ::oController:oModel:hBuffer[ "telefono" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "telefono" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "movil" ] ;
      ID          160 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "movil" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "email" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
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

   ::oDialog:bStart     := {|| ::validateFields() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD validateFields() CLASS DireccionesView

   local cPoblacion
   local cCodigoProvincia

   cPoblacion           := SQLCodigosPostalesModel():getField( "poblacion", "codigo", ::oController:oModel:hBuffer[ "codigo_postal" ] )

   if !Empty( cPoblacion ) .and. Empty( ::oController:oModel:hBuffer[ "poblacion" ] )
      ::oGetPoblacion:cText( SQLCodigosPostalesModel():getField( "poblacion", "codigo", ::oController:oModel:hBuffer[ "codigo_postal" ] ) )
      ::oGetPoblacion:Refresh()
   end if

   cCodigoProvincia     := SQLCodigosPostalesModel():getField( "provincia", "codigo", ::oController:oModel:hBuffer[ "codigo_postal" ] )

   if !Empty( cCodigoProvincia ) .and. Empty( ::oController:oModel:hBuffer[ "provincia" ] )
      ::oGetProvincia:cText( cCodigoProvincia )
      ::oGetProvincia:Refresh()
   end if

   if !Empty( ::oController:oModel:hBuffer[ "provincia" ] )
      ::oGetProvincia:oHelpText:cText( SQLProvinciasModel():getField( "provincia", "codigo", ::oController:oModel:hBuffer[ "provincia" ] ) )
      ::oGetProvincia:oHelpText:Refresh()
   end if

   if !Empty( ::oController:oModel:hBuffer[ "codigo_pais" ] )
      ::oGetPais:oHelpText:cText( SQLPaisesModel():getField( "nombre", "codigo", ::oController:oModel:hBuffer[ "codigo_pais" ] ) )
      ::oGetPais:oHelpText:Refresh()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD ExternalRedefine( oDialog )

   REDEFINE GET   ::oController:oModel:hBuffer[ "direccion" ] ;
      ID          1010 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_postal" ] ;
      ID          1020 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::validateFields ) ;
      OF          oDialog 

   REDEFINE GET   ::oGetPoblacion VAR ::oController:oModel:hBuffer[ "poblacion" ] ;
      ID          1030 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oGetProvincia VAR ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          1040 ;
      IDTEXT      1041 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      VALID       ( ::validateFields() ) ;
      OF          oDialog

   ::oGetProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( ::oGetProvincia ), ::validateFields() }

   REDEFINE GET   ::oGetPais VAR ::oController:oModel:hBuffer[ "codigo_pais" ] ;
      ID          1050 ;
      IDTEXT      1051 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::validateFields() ) ;
      BITMAP      "LUPA" ;
      OF          oDialog

   ::oGetPais:bHelp  := {|| ::oController:oPaisesController:getSelectorPais( ::oGetPais ), ::validateFields() }

   REDEFINE GET   ::oController:oModel:hBuffer[ "telefono" ] ;
      ID          1060 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "movil" ] ;
      ID          1070 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "email" ] ;
      ID          1080 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          oDialog

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesValidator

   ::hValidators  := {  "nombre" =>          {  "required"        => "El nombre es un dato requerido" },; 
                        "email" =>           {  "mail"            => "El email no es valido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesModel FROM SQLBaseModel

   DATA cTableName                     INIT "direcciones"

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "text"      => "Identificador"                           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "text"      => "Uuid"                                    ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL "                   ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                      )

   hset( ::hColumns, "direccion",         {  "create"    => "VARCHAR( 150 )"                          ,;
                                             "default"   => {|| space( 150 ) } }                      )

   hset( ::hColumns, "poblacion",         {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "provincia",         {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "codigo_postal",     {  "create"    => "VARCHAR( 10 )"                           ,;
                                             "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "codigo_pais",       {  "create"    => "VARCHAR( 3 )"                            ,;
                                             "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "telefono",          {  "create"    => "VARCHAR( 15 )"                           ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "movil",             {  "create"    => "VARCHAR( 15 )"                           ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "email",             {  "create"    => "VARCHAR( 200 )"                          ,;
                                             "default"   => {|| space( 200 ) } }                      )  

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLDireccionesModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

   logwrite( "::oController:oSenderController:getUuid()"" )
   logwrite( ::oController:oSenderController:getUuid() )
   msgalert( ::oController:oSenderController:getUuid() )

RETURN ( ::oController:oSenderController:getUuid() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesRepository FROM SQLBaseRepository

   METHOD getTableName()         INLINE ( SQLDireccionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//