#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS CuentasBancariasGestoolController FROM CuentasBancariasController

   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLCuentasBancariasGestoolModel():New( self ), ), ::oModel )

   METHOD getConfiguracionVistasController();
                                       INLINE ( if( empty( ::oConfiguracionVistasController ), ::oConfiguracionVistasController := SQLConfiguracionVistasGestoolController():New( self ), ), ::oConfiguracionVistasController )

   METHOD getUuidParent()              INLINE ( Company():UUID() )

END CLASS 

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasBancariasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD CalculaIBAN()

   METHOD CalculaDigitoControl()

   METHOD loadBlankBuffer()            INLINE ( ::getModel():loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD updateBlanckDefecto()

   METHOD getUuidParent()              INLINE ( SQLtercerosModel():getuuidWhereCodigo( ::oController():getModelBuffer( "tercero_codigo" ) ) )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( if( empty( ::oBrowseView ), ::oBrowseView := CuentasBancariasBrowseView():New( self ), ), ::oBrowseView )

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := CuentasBancariasView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( if( empty( ::oValidator ), ::oValidator := CuentasBancariasValidator():New( self ), ), ::oValidator )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLCuentasBancariasModel():New( self ), ), ::oModel )

   METHOD getSelector()                INLINE ( if( empty( ::oGetSelector ), ::oGetSelector := CuentasBancariasGetSelector():New( self ), ), ::oGetSelector )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS CuentasBancariasController

   ::Super:New( oController )

   ::cTitle                         := "Cuentas bancarias"

   ::cName                          := "cuentas_bancarias"

   ::hImage                         := {  "16" => "gc_central_bank_euro_16",;
                                          "32" => "gc_central_bank_euro_32",;
                                          "48" => "gc_central_bank_euro_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::setEvent( 'appended',          {|| ::updateBlanckDefecto( ::getModelBuffer( "uuid" ) ) } )
   ::setEvent( 'edited',            {|| ::updateBlanckDefecto( ::getModelBuffer( "uuid" ) ) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS CuentasBancariasController

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

   if !empty( ::oGetSelector )
      ::oGetSelector:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD updateBlanckDefecto( uuidBanco ) CLASS CuentasBancariasController

   if ::getModelBuffer( "defecto" )
      
      ::getModel():updateBlanckDefecto( ::getModelBuffer( "parent_uuid" ), uuidBanco )
      
      ::getRowset():refresh()
      
      ::getBrowseView:refresh()

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD CalculaIBAN()

   lIbanDigit( ::getModel():hBuffer[ "iban_codigo_pais" ],;
               ::getModel():hBuffer[ "cuenta_codigo_entidad" ] ,;
               ::getModel():hBuffer[ "cuenta_codigo_oficina" ],;
               ::getModel():hBuffer[ "cuenta_digito_control" ],;
               ::getModel():hBuffer[ "cuenta_numero" ],;
               ::getDialogView():oIBAN ) 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CalculaDigitoControl() CLASS CuentasBancariasController

   lCalcDC( ::getModel():hBuffer[ "cuenta_codigo_entidad" ],;
            ::getModel():hBuffer[ "cuenta_codigo_oficina" ],;
            ::getModel():hBuffer[ "cuenta_digito_control" ],;
            ::getModel():hBuffer[ "cuenta_numero" ],;
            ::getDialogView():oDigitoControl )

   ::getDialogView():oIBAN:lValid() 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS CuentasBancariasController

   local idCuentaBanco     

   if empty( uuidEntidad )
      ::getModel():insertBuffer()
   end if 

   idCuentaBanco          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idCuentaBanco )
      idCuentaBanco       := ::getModel():insertBlankBuffer()
   end if 

   ::getModel():loadCurrentBuffer( idCuentaBanco )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS CuentasBancariasController

   local idCuentaBanco    

   idCuentaBanco          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idCuentaBanco )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS CuentasBancariasController

   local idCuentaBanco    

   idCuentaBanco          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idCuentaBanco )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():loadDuplicateBuffer( idCuentaBanco )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS CuentasBancariasController

   hset( ::getModel():hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS CuentasBancariasController

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

CLASS CuentasBancariasBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

   METHOD formatoCuenta()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS CuentasBancariasBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 50
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
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 50
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'nombre'
      :cHeader             := 'Nombre'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Cuenta'
      :nWidth              := 300
      :bEditValue          := {|| ::formatoCuenta() }
   end with 

    with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'defecto'
      :cHeader             := 'Por defecto'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'defecto' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :SetCheck( { "bullet_square_green_16", "bullet_square_red_16" } )
   end with

   ::getColumnDeletedAt()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD formatoCuenta() CLASS CuentasBancariasBrowseView

   local cCuenta  := ""

      cCuenta     += ::getRowSet():fieldGet( 'iban_codigo_pais' )
      cCuenta     += ::getRowSet():fieldGet( 'iban_digito_control' )
      cCuenta     += " - "
      cCuenta     += ::getRowSet():fieldGet( 'cuenta_codigo_entidad' )
      cCuenta     += " - "
      cCuenta     += ::getRowSet():fieldGet( 'cuenta_codigo_oficina' )
      cCuenta     += " - "
      cCuenta     += ::getRowSet():fieldGet( 'cuenta_digito_control' )
      cCuenta     += " - "
      cCuenta     += ::getRowSet():fieldGet( 'cuenta_numero' )

RETURN ( cCuenta )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasBancariasView FROM SQLBaseView
  
   DATA oGetProvincia
   DATA oGetPoblacion
   DATA oGetPais
   DATA oGetDni

   DATA oSayCamposExtra

   DATA oIBAN 
   DATA oDigitoControl

   DATA oCheckBoxDefecto

   METHOD Activate()

   METHOD ExternalRedefine( oDialog )

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS CuentasBancariasView

   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "BANCOS_SQL" ;
      TITLE       ::LblTitle() + "cuenta bancaria"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   ::ExternalRedefine( ::oDialog )

      REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          200 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   else
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart        := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD ExternalRedefine( oDialog ) CLASS CuentasBancariasView

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          1000 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          1010 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "iban_codigo_pais" ] ;
      ID          1020 ;
      PICTURE     "@!" ;
      VALID       ::oController:CalculaIBAN() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oIBAN  ;
      VAR         ::oController:getModel():hBuffer[ "iban_digito_control" ] ;
      ID          1021 ;
      VALID       ::oController:CalculaIBAN() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_codigo_entidad" ] ;
      ID          1022 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_codigo_oficina" ] ;
      ID          1023 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oDigitoControl ;
      VAR         ::oController:getModel():hBuffer[ "cuenta_digito_control" ];
      ID          1024 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:getModel():hBuffer[ "cuenta_numero" ] ;
      ID          1025 ;
      VALID       ::oController:CalculaDigitoControl() ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE CHECKBOX ::oCheckBoxDefecto ;
      VAR         ::oController:getModel():hBuffer[ "defecto" ] ;
      ID          1026 ;
      VALID       ( ::oController:validate( "defecto" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS CuentasBancariasView

   if ::getController():isAppendMode()      
      ::oCheckBoxDefecto:SetCheck( ::oController:getModel():countBancoParentUuidAndDefecto( ::oController:oController:getModelBuffer( "uuid" ) ) == 0 )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasBancariasValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD getUniqueSentence( uValue )
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS CuentasBancariasValidator

   ::hValidators  := {  "codigo"    =>    {  "required"     => "El codigo es un dato requerido",;
                                             "unique"       => "El codigo introducido ya existe" },;
                        "nombre"    =>    {  "required"     => "El nombre es un dato requerido",;
                                             "unique"       => "El nombre introducido ya existe" } }

RETURN ( ::hValidators ) 

//---------------------------------------------------------------------------//

METHOD getUniqueSentence( uValue )

   local id
   local cSQLSentence

   cSQLSentence         := "SELECT COUNT(*) FROM " + ::oController:getModel():getTableName()       + space( 1 )
   cSQLSentence         +=    "WHERE " + ::cColumnToProced + " = " + toSQLString( uValue )   + space( 1 )

   if ::oController:getModel():isDeletedAtColumn()
      cSQLSentence      +=    "AND deleted_at = 0 " 
   end if 
   
   id                   := ::oController:getModelBufferColumnKey()
   if !empty( id )
      cSQLSentence      +=    "AND " + ::oController:getModelColumnKey() + " <> " + toSQLString( id ) + " "
   end if 

   cSQLSentence         +=    "AND parent_uuid=" + quoted( ::getSuperController():getModelBuffer( "uuid" ) ) + " "

RETURN ( cSQLSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCuentasBancariasGestoolModel FROM SQLCuentasBancariasModel

   METHOD getTableName()               INLINE ( "gestool." + ::cTableName )

#ifdef __TEST__ 

   METHOD create_cuenta()

#endif 

END CLASS

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD create_cuenta( uuidParent) CLASS SQLCuentasBancariasGestoolModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "parent_uuid", uuidParent )
   hset( hBuffer, "nombre", "cuenta empresa" )
   hset( hBuffer, "iban_codigo_pais", 44 )
   hset( hBuffer, "iban_digito_control", 09 )
   hset( hBuffer, "cuenta_codigo_entidad", 4444 )
   hset( hBuffer, "cuenta_digito_control", 10 )
   hset( hBuffer, "cuenta_numero", 4444444444 )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLCuentasBancariasModel FROM SQLCompanyModel

   DATA cTableName               INIT "cuentas_bancarias"

   DATA cConstraints             INIT "PRIMARY KEY ( parent_uuid, codigo, deleted_at )"

   METHOD getIdWhereParentUuid( uuid ) INLINE ( ::getField( 'id', 'parent_uuid', uuid ) )

   METHOD getParentUuidAttribute( value )

   METHOD getSelectByOrder( cSQLSelect )  INLINE (cSQLSelect)

   METHOD getColumns()

   METHOD updateBlanckDefecto( uuidParent )

   METHOD countBancoParentUuidAndDefecto( uuidParent )

   METHOD getUuidWhereCodigoAndParentAndNotDeleted( cCodigo )

   METHOD getCodigoWhereUuidAndNotDeleted( uuid , uuidParent  )

   #ifdef __TEST__

   METHOD create_cuenta()

   #endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLCuentasBancariasModel
   
   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                   "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;
                                                   "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR ( 40 ) NOT NULL"                  ,;
                                                   "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",                  {  "create"    => "VARCHAR ( 20 ) NOT NULL"                  ,;
                                                   "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",                  {  "create"    => "VARCHAR( 140 )"                          ,;
                                                   "default"   => {|| space( 140 ) } }                      )

   hset( ::hColumns, "iban_codigo_pais",        {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "iban_digito_control",     {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "cuenta_codigo_entidad",   {  "create"    => "VARCHAR( 4 )"                            ,;
                                                   "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "cuenta_codigo_oficina",   {  "create"    => "VARCHAR( 4 )"                            ,;
                                                   "default"   => {|| space( 4 ) } }                        )

   hset( ::hColumns, "cuenta_digito_control",   {  "create"    => "VARCHAR( 2 )"                            ,;
                                                   "default"   => {|| space( 2 ) } }                        )

   hset( ::hColumns, "cuenta_numero",           {  "create"    => "VARCHAR( 10 )"                           ,;
                                                   "default"   => {|| space( 10 ) } }                       )

   hset( ::hColumns, "defecto",                 {  "create"    => "TINYINT( 1 )"                            ,;
                                                   "default"   => {|| 0 } }                                 )
   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLCuentasBancariasModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid()  )

//---------------------------------------------------------------------------//

METHOD countBancoParentUuidAndDefecto( uuidParent ) CLASS SQLCuentasBancariasModel

local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

   FROM %1$s AS cuentas_bancarias

   WHERE parent_uuid = %2$s AND deleted_at = 0 AND defecto = 1

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ) )

RETURN ( getSQLDatabase():getValue( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD updateBlanckDefecto( uuidParent, uuidBanco ) CLASS SQLCuentasBancariasModel

 local cSql

   TEXT INTO cSql

   UPDATE %1$s 

   SET defecto = 0

   WHERE parent_uuid =%2$s AND deleted_at = 0 AND uuid <> %3$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuidParent ), quoted( uuidBanco ) )

RETURN ( getSQLDatabase():Exec( cSql ) )

//---------------------------------------------------------------------------//

METHOD getUuidWhereCodigoAndParentAndNotDeleted( cCodigo, uuidParent  ) CLASS SQLCuentasBancariasModel
   
   local cSql

   TEXT INTO cSql

   SELECT uuid 

   FROM %1$s 

   WHERE codigo = %2$s AND parent_uuid =%3$s AND deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigo ), quoted( uuidParent ) )

RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD getCodigoWhereUuidAndNotDeleted( uuid  ) CLASS SQLCuentasBancariasModel
   
   local cSql

   TEXT INTO cSql

   SELECT codigo 

   FROM %1$s 

   WHERE uuid = %2$s AND deleted_at = 0 

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( uuid ) )

RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//


#ifdef __TEST__

METHOD create_cuenta( uuidParent ) CLASS SQLCuentasBancariasModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", "0" )
   hset( hBuffer, "nombre", "cuenta tercero" )
   hset( hBuffer, "parent_uuid", uuidParent )
   hset( hBuffer, "iban_codigo_pais", 44 )
   hset( hBuffer, "iban_digito_control", 09 )
   hset( hBuffer, "cuenta_codigo_entidad", 4444 )
   hset( hBuffer, "cuenta_digito_control", 10 )
   hset( hBuffer, "cuenta_numero", 4444444444 )

RETURN ( ::insertBuffer( hBuffer ) )

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS CuentasBancariasRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLCuentasBancariasModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS CuentasBancariasRepository

   local aNombres    := getSQLDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )
   local aResult     := {}

   if !empty( aNombres )
      aeval( aNombres, {| h | aadd( aResult, alltrim( hGet( h, "nombre" ) ) ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//