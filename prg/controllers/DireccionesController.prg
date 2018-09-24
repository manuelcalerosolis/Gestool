#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionesGestoolController FROM DireccionesController

   METHOD getModel()                            INLINE ( if( empty( ::oModel ), ::oModel := SQLDireccionesGestoolModel():New( self ), ), ::oModel )

   METHOD getCodigosPostalesController()        INLINE ( if( empty( ::oCodigosPostalesController ), ::oCodigosPostalesController := CodigosPostalesGestoolController():New( self ), ), ::oCodigosPostalesController )

   METHOD getPaisesController()                 INLINE ( if( empty( ::oPaisesController ), ::oPaisesController := PaisesGestoolController():New( self ), ), ::oPaisesController )

   METHOD getProvinciasController()             INLINE ( if( empty( ::oProvinciasController ), ::oProvinciasController := ProvinciasGestoolController():New( self ), ), ::oProvinciasController )

   METHOD getConfiguracionVistasController()    INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesController FROM SQLNavigatorController

   DATA lPrincipal                        INIT .f.

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()               INLINE ( ::oModel:loadBlankBuffer() )
   METHOD loadPrincipalBlankBuffer()      INLINE ( ::oModel:loadPrincipalBlankBuffer() )
   METHOD insertBuffer()                  INLINE ( ::oModel:insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD externalStartDialog()           INLINE ( ::oDialogView:StartDialog() )
   
   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLDireccionesModel():New( self ), ), ::oModel )

   METHOD getUuidParent()                 INLINE ( ::oSenderController:getUuid() )

   METHOD includePrincipal()              INLINE ( ::lPrincipal := .t. )
   METHOD excludePrincipal()              INLINE ( ::lPrincipal := .f. )
   METHOD getPrincipal()                  INLINE ( ::lPrincipal )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS DireccionesController

   ::Super:New( oController )

   ::lTransactional                 := .t.

   ::cTitle                         := "Direcciones"

   ::cName                          := "direcciones"

   ::hImage                         := {  "16" => "gc_signpost3_16",;
                                          "32" => "gc_signpost3_32",;
                                          "48" => "gc_signpost3_48" }

   ::getModel()                        

   ::oBrowseView                    := DireccionesBrowseView():New( self )

   ::oDialogView                    := DireccionesView():New( self )

   ::oValidator                     := DireccionesValidator():New( self, ::oDialogView )

   ::oGetSelector                   := DireccionGetSelector():New( self )
   
   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DireccionesController

   if !empty(::oModel)
      ::oModel:End()
   end if 

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DireccionesController

   local uuid      

   uuid              := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

   if !( ::getPrincipal() )
      ::oModel:setOthersWhere( "codigo != 0" )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   if empty( uuidEntidad )
      ::oModel:insertBuffer()
   end if 

   idDireccion          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDireccion )
      idDireccion       := ::oModel:insertPrincipalBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDireccion )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   idDireccion          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDireccion )
      ::oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::oModel:updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS DireccionesController

   local idDireccion     

   idDireccion          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDireccion )
      ::oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::oModel:loadDuplicateBuffer( idDireccion )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS DireccionesController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS DireccionesController

   if empty( aUuidEntidades )
      RETURN ( nil )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

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
      :cHeader             := 'C�digo'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
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
      :cSortOrder          := 'C�digo provincia'
      :cHeader             := 'codigo_provincia'
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

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   ::ExternalRedefine( ::oDialog )

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
      VAR         ::oController:oModel:hBuffer[ "direccion" ] ;
      ID          1010 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "direccion" ) ) ;
      BITMAP      "gc_earth_lupa_16" ;
      OF          oDialog

   ::oGetDireccion:bHelp  := {|| GoogleMaps( ::oController:oModel:hBuffer[ "direccion" ], Rtrim( ::oController:oModel:hBuffer[ "poblacion" ] ) + Space( 1 ) + Rtrim( ::oController:oModel:hBuffer[ "provincia" ] ) ) }

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo_postal" ] ;
      ID          1020 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_postal" ) ) ;
      OF          oDialog 

   REDEFINE GET   ::oGetPoblacion ;
      VAR         ::oController:oModel:hBuffer[ "poblacion" ] ;
      ID          1030 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oGetCodigoProvincia ;
      VAR         ::oController:oModel:hBuffer[ "codigo_provincia" ] ;
      ID          1040 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      BITMAP      "Lupa" ;
      VALID       ( ::oController:validate( "codigo_provincia" ) ) ;
      OF          oDialog

   ::oGetCodigoProvincia:bHelp  := {|| ::oController:getProvinciasController():getSelectorProvincia( ::oGetCodigoProvincia ), ::oGetCodigoProvincia:lValid() }

   REDEFINE GET   ::oGetProvincia ;
      VAR         ::oController:oModel:hBuffer[ "provincia" ] ;
      ID          1050 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "provincia" ) ) ;
      OF          oDialog

   REDEFINE GET   ::oGetPais ;
      VAR         ::oController:oModel:hBuffer[ "codigo_pais" ] ;
      ID          1060 ;
      IDTEXT      1061 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo_pais" ) ) ;
      BITMAP      "LUPA" ;
      OF          oDialog

   ::oGetPais:bHelp  := {|| ::oController:getPaisesController():getSelectorPais( ::oGetPais ), ::oGetPais:lValid() }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ExternalContactRedefine( oDialog )

   REDEFINE GET   ::oController:oModel:hBuffer[ "telefono" ] ;
      ID          1070 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "movil" ] ;
      ID          1080 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      OF          oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "email" ] ;
      ID          1090 ;
      WHEN        ( ::oController:oSenderController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "email" ) ) ;
      OF          oDialog

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD StartDialog()

   ::oGetPais:oHelpText:cText( ::oController:getPaisesController():getModel():getField( "nombre", "codigo", ::oController:oModel:hBuffer[ "codigo_pais" ] ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD codigoPostal()

   METHOD codigoProvincia()

   METHOD codigoPais()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesValidator

   ::hValidators  := {  "codigo" =>             {  "required"        => "El nombre es un dato requerido" },; 
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

   if empty( ::oController:oDialogView:oGetPoblacion:varget() )

      cPoblacion  := ::oController:getCodigosPostalesController():getModel():getField( "poblacion", "codigo", value )
      if !empty( cPoblacion )
         ::oController:oDialogView:oGetPoblacion:cText( cPoblacion )
      end if 

   end if 

   if empty( ::oController:oDialogView:oGetCodigoProvincia:varget() )

      cProvincia  := ::oController:getCodigosPostalesController():getModel():getField( "provincia", "codigo", value )

      MsgInfo( cProvincia, "cProvincia" )

      if !empty( cProvincia )
         ::oController:oDialogView:oGetCodigoProvincia:cText( cProvincia )
         ::oController:oDialogView:oGetCodigoProvincia:lValid()
      else
         ::oController:oDialogView:oGetCodigoProvincia:cText( space( 100 ) )
      end if 

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD codigoProvincia( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   ::oController:oDialogView:oGetProvincia:cText( ::oController:getProvinciasController():getModel():getField( "provincia", "codigo", value ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD codigoPais( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   ::oController:oDialogView:oGetPais:oHelpText:cText( ::oController:getPaisesController():getModel():getField( "nombre", "codigo", value ) )

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

   ::hValidators  := {  "codigo_postal" =>      {  "codigoPostal"    => "El c�digo postal erroneo",;
                                                   "required"        => "El c�digo postal es un dato requerido" },;
                        "codigo_provincia" =>   {  "codigoProvincia" => "El c�digo de provincia erroneo",;
                                                   "required"        => "El c�digo postal es un dato requerido" },;
                        "codigo_pais" =>        {  "codigoPais"      => "C�digo de pa�s erroneo",;
                                                   "required"        => "El c�digo de p�is es un dato requerido" },;
                        "direccion" =>          {  "required"        => "La direcci�n es un dato requerido" } ,; 
                        "poblacion" =>          {  "required"        => "La poblaci�n es un dato requerido" } ,;
                        "provincia" =>          {  "required"        => "La provincia es un dato requerido" } ,; 
                        "pais" =>               {  "required"        => "El pa�s es un dato requerido" } }                      

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesGestoolModel FROM SQLDireccionesModel

   METHOD getTableName()   INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesModel FROM SQLCompanyModel

   DATA cTableName                        INIT "direcciones"

   DATA cConstraints                      INIT "PRIMARY KEY ( parent_uuid, codigo )"


   METHOD loadPrincipalBlankBuffer()      INLINE ( ::loadBlankBuffer(),;
                                                   hset( ::hBuffer, "codigo", "0" ) )

   METHOD insertPrincipalBlankBuffer()    INLINE ( ::loadPrincipalBlankBuffer(), ::insertBuffer() ) 

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid )    INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD addParentUuidWhere( cSQLSelect ) INLINE ( cSQLSelect )

   METHOD getClienteDireccion( cBy, cCodigo, uuidParent ) ;
                                          INLINE ( atail( ::getDatabase():selectTrimedFetchHash( ::getSentenceClienteDireccion( cBy, cCodigo, uuidParent ) ) ) )

   METHOD getSentenceClienteDireccion( cBy, cCodigo, uuidParent )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR( 40 ) NOT NULL "                 ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) NOT NULL"                  ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "direccion",         {  "create"    => "VARCHAR( 150 )"                          ,;
                                             "default"   => {|| space( 150 ) } }                      )

   hset( ::hColumns, "poblacion",         {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "codigo_provincia",  {  "create"    => "VARCHAR( 8 )"                            ,;
                                             "default"   => {|| space( 8 ) } }                        )

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

RETURN ( ::oController:oSenderController:getUuid() )

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