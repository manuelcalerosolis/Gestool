#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS DireccionesGestoolController FROM DireccionesController

   METHOD getModel()                            INLINE ( ::oModel := SQLDireccionesGestoolModel():New( self ) )

   METHOD getCodigosPostalesController()        INLINE ( ::oCodigosPostalesController     := CodigosPostalesGestoolController():New( self ) )

   METHOD getPaisesController()                 INLINE ( ::oPaisesController              := PaisesGestoolController():New( self ) )

   METHOD getProvinciasController()             INLINE ( ::oProvinciasController          := ProvinciasGestoolController():New( self ) )

   METHOD getConfiguracionVistasController()    INLINE ( ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS DireccionesController FROM SQLNavigatorController

   DATA oGetSelector

   DATA oPaisesController

   DATA oProvinciasController

   DATA oCodigosPostalesController

   METHOD New()
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

   METHOD getModel()                      INLINE ( ::oModel                      := SQLDireccionesModel():New( self ) )

   METHOD getCodigosPostalesController()  INLINE ( ::oCodigosPostalesController  := CodigosPostalesController():New( self ) )

   METHOD getPaisesController()           INLINE ( ::oPaisesController           := PaisesController():New( self ) )

   METHOD getProvinciasController()       INLINE ( ::oProvinciasController       := ProvinciasController():New( self ) )

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

   ::oGetSelector                   := GetSelector():New( self )

   ::getCodigosPostalesController()

   ::getPaisesController()

   ::getProvinciasController()

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS DireccionesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oGetSelector:End()

   ::oCodigosPostalesController:End()

   ::oPaisesController:End()

   ::oProvinciasController:End()

   ::Super:End()

   ::oModel                            := nil

   ::oBrowseView                       := nil

   ::oDialogView                       := nil

   ::oValidator                        := nil

   ::oGetSelector                      := nil

   ::oCodigosPostalesController        := nil

   ::oPaisesController                 := nil

   ::oProvinciasController             := nil

   self                                := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS DireccionesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

   ::oModel:setOthersWhere( "principal = 0" )

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
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
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
      :cSortOrder          := 'Código provincia'
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          100 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
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

   ::oGetCodigoProvincia:bHelp  := {|| ::oController:oProvinciasController:getSelectorProvincia( ::oGetCodigoProvincia ), ::oGetCodigoProvincia:lValid() }

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

   ::oGetPais:bHelp  := {|| ::oController:oPaisesController:getSelectorPais( ::oGetPais ), ::oGetPais:lValid() }

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

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD StartDialog()

   ::oGetPais:oHelpText:cText( ::oController:oPaisesController:getModel():getField( "nombre", "codigo", ::oController:oModel:hBuffer[ "codigo_pais" ] ) )

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
//---------------------------------------------------------------------------//

CLASS DireccionesValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD codigoPostal()

   METHOD codigoProvincia()

   METHOD codigoPais()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS DireccionesValidator

   ::hValidators  := {  "nombre" =>             {  "required"        => "El nombre es un dato requerido" },; 
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

      cPoblacion  := ::oController:oCodigosPostalesController:getModel():getField( "poblacion", "codigo", value )
      if !empty( cPoblacion )
         ::oController:oDialogView:oGetPoblacion:cText( cPoblacion )
      end if 

   end if 

   if empty( ::oController:oDialogView:oGetCodigoProvincia:varget() )

      cProvincia  := ::oController:oCodigosPostalesController:getModel():getField( "provincia", "codigo", value )

      MsgInfo( cProvincia, "cProvincia" )

      if !empty( cProvincia )
         ::oController:oDialogView:oGetCodigoProvincia:cText( cProvincia )
         ::oController:oDialogView:oGetCodigoProvincia:lValid()
      else
         ::oController:oDialogView:oGetCodigoProvincia:cText( Space( 100 ) )
      end if 

   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD codigoProvincia( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   ::oController:oDialogView:oGetProvincia:cText( ::oController:oProvinciasController:getModel():getField( "provincia", "codigo", value ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD codigoPais( value )

   if empty( value )
      RETURN ( .t. )
   end if 

   ::oController:oDialogView:oGetPais:oHelpText:cText( ::oController:oPaisesController:getModel():getField( "nombre", "codigo", value ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//
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

   METHOD getTableName()   INLINE ( "gestool." + ::cTableName )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLDireccionesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "direcciones"

   METHOD loadPrincipalBlankBuffer()   INLINE ( ::loadBlankBuffer(), hset( ::hBuffer, "principal", .t. ), hset( ::hBuffer, "nombre", "Principal" ) )

   METHOD insertPrincipalBlankBuffer() INLINE ( ::loadPrincipalBlankBuffer(), ::insertBuffer() ) 

   METHOD getColumns()

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD addParentUuidWhere( cSQLSelect, uuidCliente )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLDireccionesModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"             ,;
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",       {  "create"    => "VARCHAR(40) NOT NULL "                   ,;
                                             "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "principal",         {  "create"    => "TINYINT ( 1 )"                           ,;
                                             "default"   => {|| "0" } }                               )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 140 )"                          ,;
                                             "default"   => {|| space( 140 ) } }                      )

   hset( ::hColumns, "direccion",         {  "create"    => "VARCHAR( 150 )"                          ,;
                                             "default"   => {|| space( 150 ) } }                      )

   hset( ::hColumns, "poblacion",         {  "create"    => "VARCHAR( 100 )"                          ,;
                                             "default"   => {|| space( 100 ) } }                      )

   hset( ::hColumns, "codigo_provincia",  {  "create"    => "VARCHAR( 8 )"                           ,;
                                             "default"   => {|| space( 8 ) } }                       )

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

METHOD addParentUuidWhere( cSQLSelect, uuidCliente ) CLASS SQLDireccionesModel

   local uuid        

   if !::isParentUuidColumn()
      RETURN ( cSQLSelect )
   end if 

   if empty( ::oController )
      RETURN ( cSQLSelect )
   end if

   if empty( ::oController:getSenderController() )
      RETURN ( cSQLSelect )
   end if

   if !empty( uuidCliente )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".parent_uuid = " + quoted( uuidCliente )
      RETURN( cSQLSelect )
   end if 

   uuid           := ::oController:getSenderController():getUuid()

   if !empty( uuid )
      cSQLSelect  += ::getWhereOrAnd( cSQLSelect ) + ::getTableName() + ".parent_uuid = " + quoted( uuid )
   end if 

RETURN ( cSQLSelect )

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