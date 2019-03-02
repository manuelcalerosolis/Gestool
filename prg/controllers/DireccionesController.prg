#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionesGestoolController FROM DireccionesController

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLDireccionesGestoolModel():New( self ), ), ::oModel )

   METHOD getCodigosPostalesController() ;
                                       INLINE ( if( empty( ::oCodigosPostalesController ), ::oCodigosPostalesController := CodigosPostalesGestoolController():New( self ), ), ::oCodigosPostalesController )

   METHOD getPaisesController()        INLINE ( if( empty( ::oPaisesController ), ::oPaisesController := PaisesGestoolController():New( self ), ), ::oPaisesController )

   METHOD getProvinciasController()    INLINE ( if( empty( ::oProvinciasController ), ::oProvinciasController := ProvinciasGestoolController():New( self ), ), ::oProvinciasController )

   METHOD getConfiguracionVistasController() ;
                                       INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesController FROM SQLNavigatorController

   DATA lMain                          INIT .f.                       

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::getModel():loadBlankBuffer() )
   METHOD loadMainBlankBuffer()        INLINE ( ::getModel():loadMainBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad ) 

   METHOD deleteBuffer( aUuidEntidades )

   METHOD getUuidParent()              INLINE ( ::oController:getUuid() )

   METHOD includeMain()                INLINE ( ::lMain := .t. )
   METHOD excludeMain()                INLINE ( ::lMain := .f. )
   METHOD getMain()                    INLINE ( ::lMain )

   // Creaciones tardias-------------------------------------------------------
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLDireccionesModel():New( self ), ), ::oModel )
   
   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := DireccionesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE ( if( empty( ::oDialogView ), ::oDialogView := DireccionesView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := DireccionesValidator():New( self, ::getDialogView() ), ), ::oValidator )
   
   METHOD getSelector()                INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := DireccionesGetSelector():New( self ), ), ::oGetSelector )

   METHOD externalStartDialog()        INLINE ( ::getDialogView():StartDialog() )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS DireccionesController

   ::Super:New( oController )

   ::lTransactional                    := .t.

   ::cTitle                            := "Direcciones"

   ::cName                             := "direcciones"

   ::hImage                            := {  "16" => "gc_signpost3_16",;
                                             "32" => "gc_signpost3_32",;
                                             "48" => "gc_signpost3_48" }

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DireccionesController

   if !empty(::oModel )
      ::oModel:End()
   end if 

   if !empty(::oBrowseView)
      ::oBrowseView:End()
   end if 

   if !empty(::oDialogView)
      ::oDialogView:End()
   end if 

   if !empty(::oValidator)
      ::oValidator:End()
   end if 

   if !empty(::oGetSelector)
      ::oGetSelector:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DireccionesController

   local uuid      

   uuid              := ::getController():getUuid() 

   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

   if !( ::getMain() )
      ::getModel():setOthersWhere( "codigo != 0" )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   if empty( uuidEntidad )
      ::getModel():insertBuffer()
   end if 

   idDireccion          := ::getModel():getIdMainWhereParentUuid( uuidEntidad )
   
   if empty( idDireccion )
      ::getModel():insertMainBlankBuffer()
   else
      ::getModel():loadCurrentBuffer( idDireccion )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   idDireccion          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   
   if empty( idDireccion )
      ::getModel():insertBuffer()
   else
      ::getModel():updateBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS DireccionesController

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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'direccion'
      :cHeader             := 'Dirección'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'direccion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'poblacion'
      :cHeader             := 'Población'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'poblacion' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo_provincia'
      :cHeader             := 'Código provincia'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_provincia' ) }
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
      :cHeader             := 'Código Postal'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_postal' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'telefono'
      :cHeader             := 'Teléfono'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'telefono' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with   

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'movil'
      :cHeader             := 'Móvil'
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

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesView FROM SQLBaseView
  
   DATA oGetPais
   DATA oGetDireccion
   DATA oGetPoblacion
   DATA oGetProvincia
   DATA oGetCodigoProvincia

   METHOD Activate()

   METHOD ExternalRedefine( oDialog )

   METHOD ExternalCoreRedefine( oDialog )

   METHOD ExternalContactRedefine( oDialog )

   METHOD StartDialog()
   
END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS DireccionesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "DIRECCION" ;
      TITLE       ::LblTitle() + "direcciones"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   ::ExternalRedefine( ::oDialog )

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart     := {|| ::StartDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD ExternalRedefine( oDialog )

   ::ExternalCoreRedefine( oDialog )

   ::ExternalContactRedefine( oDialog )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExternalCoreRedefine( oDialog )

   REDEFINE GET   ::oGetDireccion ;
      VAR         ::oController:getModel():hBuffer[ "direccion" ] ;
      ID          1010 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "direccion" ) ) ;
      BITMAP      "gc_earth_lupa_16" ;
      OF          oDialog

   ::oGetDireccion:bHelp  := {|| GoogleMaps( ::oController:getModel():hBuffer[ "direccion" ], rtrim( ::oController:oModel:hBuffer[ "poblacion" ] ) + Space( 1 ) + Rtrim( ::oController:oModel:hBuffer[ "provincia" ] ) ) }

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo_postal" ] ;
      ID          1020 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_postal" ) ) ;
      OF          oDialog 

   REDEFINE GET   ::oGetPoblacion ;
      VAR         ::oController:getModel():hBuffer[ "poblacion" ] ;
      ID          1030 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oGetCodigoProvincia ;
      VAR         ::oController:getModel():hBuffer[ "codigo_provincia" ] ;
      ID          1040 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      BITMAP      "Lupa" ;
      VALID       ( ::oController:validate( "codigo_provincia" ) ) ;
      OF          oDialog

   ::oGetCodigoProvincia:bHelp  := {|| ::oController:getProvinciasController():getSelectorProvincia( ::oGetCodigoProvincia ), ::oGetCodigoProvincia:lValid() }

   REDEFINE GET   ::oGetProvincia ;
      VAR         ::oController:getModel():hBuffer[ "provincia" ] ;
      ID          1050 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ) ) ;
      OF          oDialog

   REDEFINE GET   ::oGetPais ;
      VAR         ::oController:getModel():hBuffer[ "codigo_pais" ] ;
      ID          1060 ;
      IDTEXT      1061 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_pais" ) ) ;
      BITMAP      "LUPA" ;
      OF          oDialog

   ::oGetPais:bHelp  := {|| ::oController:getPaisesController():getSelectorPais( ::oGetPais ), ::oGetPais:lValid() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExternalContactRedefine( oDialog )

   REDEFINE GET   ::oController:getModel():hBuffer[ "telefono" ] ;
      ID          1070 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "movil" ] ;
      ID          1080 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "email" ] ;
      ID          1090 ;
      WHEN        ( ::oController:oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          oDialog

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartDialog()

   ::oGetPais:oHelpText:cText( ::oController:getPaisesController():getModel():getField( "nombre", "codigo", ::oController:getModel():hBuffer[ "codigo_pais" ] ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesValidator FROM SQLParentValidator

   METHOD getValidators()

   METHOD codigoPostal()

   METHOD codigoProvincia()

   METHOD codigoPais()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesValidator

   ::hValidators  := {  "codigo" =>             {  "required"        => "El código es un dato requerido" ,;
                                                   "notPrincipal"    => "El código debe ser distinto de 0",;
                                                   "unique"          => "El código introducido ya existe" },;
                        "codigo_postal" =>      {  "codigoPostal"    => "" },;
                        "codigo_provincia" =>   {  "codigoProvincia" => "" },;
                        "codigo_pais" =>        {  "codigoPais"      => "" },;
                        "email" =>              {  "mail"            => "El email no es valido" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD codigoPostal( value )

   local cPoblacion
   local cProvincia

   if empty( value )
      RETURN ( .t. )
   end if 

   if empty( ::oController:getDialogView():oGetPoblacion:varget() )

      cPoblacion  := ::oController:getCodigosPostalesController():getModel():getField( "poblacion", "codigo", value )
      if !empty( cPoblacion )
         ::oController:getDialogView():oGetPoblacion:cText( cPoblacion )
      end if 

   end if 

   if empty( ::oController:getDialogView():oGetCodigoProvincia:varget() )

      cProvincia  := ::oController:getCodigosPostalesController():getModel():getField( "provincia", "codigo", value )

      if !empty( cProvincia )
         ::oController:getDialogView():oGetCodigoProvincia:cText( cProvincia )
         ::oController:getDialogView():oGetCodigoProvincia:lValid()
      else
         ::oController:getDialogView():oGetCodigoProvincia:cText( space( 100 ) )
      end if 

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD codigoProvincia( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   ::oController:getDialogView():oGetProvincia:cText( ::oController:getProvinciasController():getModel():getField( "provincia", "codigo", value ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD codigoPais( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   ::oController:getDialogView():oGetPais:oHelpText:cText( ::oController:getPaisesController():getModel():getField( "nombre", "codigo", value ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesEntidadesValidator FROM DireccionesValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesEntidadesValidator

   ::hValidators  := {  "codigo_postal" =>      {  "codigoPostal"    => "El código postal erroneo",;
                                                   "required"        => "El código postal es un dato requerido" },;
                        "codigo_provincia" =>   {  "codigoProvincia" => "El código de provincia erroneo",;
                                                   "required"        => "El código postal es un dato requerido" },;
                        "codigo_pais" =>        {  "codigoPais"      => "Código de país erroneo",;
                                                   "required"        => "El código de páis es un dato requerido" },;
                        "direccion" =>          {  "required"        => "La dirección es un dato requerido" } ,; 
                        "poblacion" =>          {  "required"        => "La población es un dato requerido" } ,;
                        "provincia" =>          {  "required"        => "La provincia es un dato requerido" } ,; 
                        "pais" =>               {  "required"        => "El país es un dato requerido" } }                      

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesGestoolModel FROM SQLDireccionesModel

   METHOD getTableName()               INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "direcciones"

   DATA cConstraints                   INIT "PRIMARY KEY ( parent_uuid, codigo, deleted_at )"

   METHOD loadMainBlankBuffer()        INLINE ( ::loadBlankBuffer(), hset( ::hBuffer, "codigo", "0" ) )

   METHOD insertMainBlankBuffer()      INLINE ( ::loadMainBlankBuffer(), ::insertBuffer() ) 

   METHOD getColumns()

   METHOD getIdMainWhereParentUuid( uuidParent ) ;
                                       INLINE ( ::getFieldWhere( 'id', { 'parent_uuid' => uuidParent, 'codigo' => '0' } ) )

   METHOD getSentenceOthersWhereParentUuid( uuidParent )


   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD addParentUuidWhere( cSQLSelect ) ;
                                       INLINE ( cSQLSelect )

   METHOD getClienteDireccion( cBy, cCodigo, uuidParent ) ;
                                       INLINE ( atail( getSQLDatabase():selectTrimedFetchHash( ::getSentenceClienteDireccion( cBy, cCodigo, uuidParent ) ) ) )

   METHOD getSentenceClienteDireccion( cBy, cCodigo, uuidParent )

   METHOD duplicateOthers( uuidEntidad )
   
   METHOD duplicateMain( uuidEntidad )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR ( 40 ) NOT NULL "                ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR ( 20 ) NOT NULL"                 ,;
                                             "default"   => {|| space( 20 ) } }                       )
   
   hset( ::hColumns, "direccion",         {  "create"    => "VARCHAR ( 150 )"                         ,;
                                             "text"      => "Dirección"                               ,;
                                             "default"   => {|| space( 150 ) } }                      )

   hset( ::hColumns, "poblacion",         {  "create"    => "VARCHAR ( 100 )"                         ,;
                                             "text"      => "Población"                               ,;
                                             "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "codigo_provincia",  {  "create"    => "VARCHAR ( 8 )"                           ,;
                                             "text"      => "Código provincia"                        ,;
                                             "default"   => {|| space( 8 ) } }                        )

   hset( ::hColumns, "provincia",         {  "create"    => "VARCHAR ( 100 )"                         ,;
                                             "text"      => "Provincia"                               ,;
                                             "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "codigo_postal",     {  "create"    => "VARCHAR ( 10 )"                          ,;
                                             "text"      => "Código postal"                           ,;
                                             "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "codigo_pais",       {  "create"    => "VARCHAR ( 3 )"                           ,;
                                             "text"      => "Código país"                             ,;
                                             "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "telefono",          {  "create"    => "VARCHAR ( 15 )"                          ,;
                                             "text"      => "Teléfono"                                ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "movil",             {  "create"    => "VARCHAR ( 15 )"                          ,;
                                             "text"      => "Teléfono móvil"                          ,;
                                             "default"   => {|| space( 15 ) } }                       )

   hset( ::hColumns, "email",             {  "create"    => "VARCHAR ( 200 )"                         ,;
                                             "text"      => "Email"                                   ,;
                                             "default"   => {|| space( 200 ) } }                      )

   ::getDeletedStampColumn()   

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLDireccionesModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid() )

//---------------------------------------------------------------------------//

METHOD getSentenceClienteDireccion( cBy, cId, uuidParent ) CLASS SQLDireccionesModel

   local cSql

   TEXT INTO cSql

   SELECT direcciones.uuid AS uuid,
      direcciones.codigo AS codigo,
      direcciones.direccion AS direccion,
      direcciones.poblacion AS poblacion,
      direcciones.provincia AS provincia,
      direcciones.codigo_postal AS codigo_postal,
      paises.nombre AS nombre_pais

   FROM %1$s AS direcciones 

   LEFT JOIN %2$s AS paises
      ON direcciones.codigo_pais = paises.codigo

   WHERE direcciones.%3$s = %4$s 
      AND direcciones.parent_uuid = %5$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLPaisesModel():getTableName(), cBy , quoted( cId ), quoted( uuidParent ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getSentenceOthersWhereParentUuid ( uuidParent ) CLASS SQLDireccionesModel

   local cSql

   TEXT INTO cSql

   SELECT *
      FROM %1$s
      WHERE parent_uuid = %2$s AND codigo <> '0'

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD duplicateOthers( uuidEntidad ) CLASS SQLDireccionesModel

   ::duplicateMain( uuidEntidad )

RETURN ( ::Super:duplicateOthers( uuidEntidad ) )

//---------------------------------------------------------------------------//

METHOD duplicateMain( uuidEntidad ) CLASS SQLDireccionesModel

   local idDireccion

   idDireccion          := ::getIdMainWhereParentUuid( ::getUuidOlderParent() )

   if empty( idDireccion )
      ::insertMainBlankBuffer()
   else 
      ::loadDuplicateBuffer( idDireccion, { "parent_uuid" => uuidEntidad } )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesRepository FROM SQLBaseRepository

   METHOD getTableName()               INLINE ( SQLDireccionesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//