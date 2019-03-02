#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AgentesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getName()                    INLINE ( "agentes" )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE ( iif( empty( ::oBrowseView ), ::oBrowseView := AgentesBrowseView():New( self ), ), ::oBrowseView )

   METHOD getRepository()              INLINE ( iif( empty( ::oRepository ), ::oRepository := AgentesRepository():New( self ), ), ::oRepository ) 

   METHOD getDialogView()              INLINE ( iif( empty( ::oDialogView ), ::oDialogView := AgentesView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE ( iif( empty( ::oValidator ), ::oValidator := AgentesValidator():New( self ), ), ::oValidator )

   METHOD getModel()                   INLINE ( iif( empty( ::oModel ), ::oModel := SQLAgentesModel():New( self ), ), ::oModel )
   
   METHOD getRange()                   INLINE ( iif( empty( ::oRange ), ::oRange := AgentesItemRange():New( self ), ), ::oRange )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS AgentesController

   ::Super:New( oController )

   ::cTitle                         := "Agentes"

   ::hImage                         := {  "16" => "gc_businessman2_16",;
                                          "32" => "gc_businessman2_32",;
                                          "48" => "gc_businessman2_48" }

   ::nLevel                         := Auth():Level( ::getName() )

   ::getModel():setEvent( 'loadedBlankBuffer',            {|| ::getDireccionesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',               {|| ::getDireccionesController():insertBuffer() } )
   
   ::getModel():setEvent( 'loadedCurrentBuffer',          {|| ::getDireccionesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                {|| ::getDireccionesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getDireccionesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',        {|| ::getDireccionesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection',             {|| ::getDireccionesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS AgentesController

   iif( !empty( ::oModel ), ::oModel:End(), )
   
   iif( !empty( ::oBrowseView ), ::oBrowseView:End(), )
   
   iif( !empty( ::oRepository ), ::oRepository:End(), )

   iif( !empty( ::oDialogView ), ::oDialogView:End(), )

   iif( !empty( ::oValidator ), ::oValidator:End(), )

   iif( !empty( ::oRange ), ::oRange:End(), )

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AgentesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS AgentesBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
      :nWidth              := 100
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

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'dni'
      :cHeader             := 'DNI/CIF'
      :nWidth              := 100
      :bEditValue          := {|| ::getRowSet():fieldGet( 'dni' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with 

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'comision'
      :cHeader             := 'Comisi�n %'
      :nWidth              := 100
      :nHeadStrAlign       := AL_RIGHT
      :nDataStrAlign       := AL_RIGHT
      :bEditValue          := {|| transform( ::getRowSet():fieldGet( 'comision' ), "@E 999.99" ) }
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

   ::getColumnDeletedAt() 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AgentesView FROM SQLBaseView
  
   DATA oGetDni
   DATA oGetPais
   DATA oGetProvincia
   DATA oGetPoblacion

   METHOD Activate()

      METHOD StartActivate()

   METHOD Activating()

   METHOD getDireccionesController()      INLINE ( ::oController:getDireccionesController() )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS AgentesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:getModel():hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS AgentesView

   local oGetDni

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "AGENTE" ;
      TITLE       ::LblTitle() + "agente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48") ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oGetDni VAR ::oController:getModel():hBuffer[ "dni" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( CheckCif( ::oGetDni ) );
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "comision" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      PICTURE     "@E 999.99" ;
      OF          ::oDialog

   ::oController:getDireccionesController():getDialogView():ExternalRedefine( ::oDialog )

   ::redefineExplorerBar( 200 )

   // Botones generales--------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate(), ) }

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS AgentesView

   local oPanel         := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink( "Campos extra...", {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }, "gc_form_plus2_16" )

   ::oController:getDireccionesController():getDialogView():StartDialog()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AgentesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS AgentesValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "El nombre es un dato requerido",;
                                          "unique"    => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"  => "El c�digo es un dato requerido" ,;
                                          "unique"    => "EL c�digo introducido ya existe"  } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLAgentesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "agentes"

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD CountAgenteWhereCodigo( cCodigoAgente )

   METHOD getComisionWhereAgenteCodigo( cCodigoAgente )

#ifdef __TEST__

   METHOD test_create_agente_principal()

   METHOD test_get_uuid_agente_principal()
   
   METHOD test_create_agente_auxiliar()
   
   METHOD test_get_uuid_agente_auxiliar()   

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLAgentesModel
   
   local cSql

   TEXT INTO cSql

   SELECT agentes.id AS id,
      agentes.uuid AS uuid,
      agentes.codigo AS codigo,
      agentes.nombre AS nombre,
      agentes.dni AS dni,
      agentes.comision AS comision,
      agentes.deleted_at AS deleted_at,
      direcciones.telefono AS telefono,
      direcciones.movil AS movil,
      direcciones.email AS email

   FROM %1$s AS agentes
   
      INNER JOIN %2$s AS direcciones 
         ON agentes.uuid = direcciones.parent_uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLDireccionesModel():getTableName() )
  
RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLAgentesModel
   
   hset( ::hColumns, "id",             {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                          "text"      => "Identificador"                           ,;
                                          "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",           {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"          ,;
                                          "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",         {  "create"    => "VARCHAR ( 20 ) NOT NULL"                 ,;
                                          "text"      => "C�digo"                                  ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",         {  "create"    => "VARCHAR ( 140 )"                         ,;
                                          "text"      => "Nombre"                                  ,;
                                          "default"   => {|| space( 140 ) } }                      )

   hset( ::hColumns, "dni",            {  "create"    => "VARCHAR ( 20 )"                          ,;
                                          "text"      => "DNI"                                     ,;
                                          "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "comision",       {  "create"    => "FLOAT ( 5, 2 )"                          ,;
                                          "text"      => "Comisi�n"                                ,;
                                          "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD CountAgenteWhereCodigo( cCodigoAgente ) CLASS SQLAgentesModel

   local cSql

   TEXT INTO cSql

   SELECT COUNT(*)

      FROM %1$s AS agentes
    
      WHERE agentes.codigo = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( cCodigoAgente ) )

RETURN ( getSQLDatabase():getValue ( cSql, 0 ) )

//---------------------------------------------------------------------------//

METHOD getComisionWhereAgenteCodigo( cCodigoAgente ) CLASS SQLAgentesModel

local cSQL

   TEXT INTO cSql

   SELECT agentes.comision

      FROM %1$s AS agentes

      WHERE agentes.codigo = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted (cCodigoAgente ) ) 

RETURN ( getSQLDatabase():getValue ( cSql ) ) 

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_agente_principal() CLASS SQLAgentesModel

   local hBuffer  := ::loadBlankBuffer(   {  "codigo" => "0",;
                                             "nombre" => "Agente principal" } )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_agente_principal() CLASS SQLAgentesModel

RETURN ( ::getUuidWhereCodigo( "0" ) )

//---------------------------------------------------------------------------//

METHOD test_create_agente_auxiliar() CLASS SQLAgentesModel

   local hBuffer  := ::loadBlankBuffer(   {  "codigo" => "1",;
                                             "nombre" => "Agente auxiliar" } )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_get_uuid_agente_auxiliar() CLASS SQLAgentesModel

RETURN ( ::getUuidWhereCodigo( "1" ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AgentesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLAgentesModel():getTableName() ) 

   METHOD getNombres()

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getNombres() CLASS AgentesRepository

   local aNombres    := getSQLDatabase():selectFetchHash( "SELECT nombre FROM " + ::getTableName() )
   local aResult     := {}

   if !empty( aNombres )
      aeval( aNombres, {| h | aadd( aResult, alltrim( hGet( h, "nombre" ) ) ) } )
   end if 

RETURN ( aResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AgentesItemRange FROM ItemRange

   DATA cKey                           INIT 'agente_codigo'

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestAgentesController FROM TestCase

   DATA oController

   DATA aCategories                    INIT { "all", "agentes" }

   METHOD beforeClass()

   METHOD afterClass()

   METHOD test_dialogo_sin_codigo()

   METHOD test_dialogo_sin_nombre() 

   METHOD test_dialogo_creacion()   

END CLASS

//---------------------------------------------------------------------------//

METHOD beforeClass() CLASS TestAgentesController

   SQLAgentesModel():truncateTable()

   ::oController           := AgentesController():New()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD afterClass() CLASS TestAgentesController

RETURN ( ::oController:end() )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_codigo() CLASS TestAgentesController
   
   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )

RETURN ( ::Assert():false( ::oController:Append(), "test creaci�n de agente sin c�digo" ) )

//---------------------------------------------------------------------------//

METHOD test_dialogo_sin_nombre() CLASS TestAgentesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100 ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds(),;
         self:getControl( IDCANCEL ):Click() } )
   
RETURN ( ::Assert():false( ::oController:Append(), "test creaci�n de agente sin nombre" ) )

//---------------------------------------------------------------------------//

METHOD test_dialogo_creacion() CLASS TestAgentesController

   ::oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         testWaitSeconds(),;
         self:getControl( 100 ):cText( "0" ),;
         testWaitSeconds(),;
         self:getControl( 110 ):cText( "Agente principal" ),;
         testWaitSeconds(),;
         self:getControl( IDOK ):Click() } )

RETURN ( ::Assert():true( ::oController:Append(), "test creaci�n de agente" ) )

//---------------------------------------------------------------------------//

#endif


