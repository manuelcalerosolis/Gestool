#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD getUnidadesInGroup()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := UnidadesMedicionBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := UnidadesMedicionView():New( self ), ), ::oDialogView )

   METHOD getValidator()               INLINE( if( empty( ::oValidator ), ::oValidator := UnidadesMedicionValidator():New( self ), ), ::oValidator )

   METHOD getRepository()              INLINE ( if( empty( ::oRepository ), ::oRepository := UnidadesMedicionRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                   INLINE ( if( empty( ::oModel ), ::oModel := SQLUnidadesMedicionModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS UnidadesMedicionController

   ::Super:New( oController )

   ::cTitle                            := "Unidades de medición"

   ::cName                             := "unidades_medicion"

   ::hImage                            := {  "16" => "gc_tape_measure2_16",;
                                             "32" => "gc_tape_measure2_32",;
                                             "48" => "gc_tape_measure2_48" }

   ::nLevel                            := Auth():Level( ::cName )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionController
   
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

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD getUnidadesInGroup() 

   local aUnidades 

   aUnidades      := SQLUnidadesMedicionOperacionesModel():getUnidadesWhereGrupo( ::oController:getModelBuffer( 'unidades_medicion_grupos_codigo' ) )

   if empty( aUnidades )
      RETURN ( "" )
   end if 

RETURN ( serializeQuotedArray( aUnidades, "," ) )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionBrowseView

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
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
      :cSortOrder          := 'codigo_iso'
      :cHeader             := 'Código ISO'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'codigo_iso' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   ::getColumnDeletedAt()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionView FROM SQLBaseView

   DATA oSayCamposExtra
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionView

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "UNIDAD_MEDICION" ;
      TITLE          ::LblTitle() + "unidad de medición"

      REDEFINE BITMAP ::oBitmap ;
         ID          900 ;
         RESOURCE    ::oController:getImage( "48" ) ;
         TRANSPARENT ;
         OF          ::oDialog ;

      REDEFINE SAY   ::oMessage ;
         ID          800 ;
         FONT        oFontBold() ;
         OF          ::oDialog ;
      
      REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
         ID          100 ;
         PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
         VALID       ( ::oController:validate( "codigo" ) ) ;
         WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
         OF          ::oDialog ;

      REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
         ID          110 ;
         VALID       ( ::oController:validate( "nombre" ) ) ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog ;

      REDEFINE GET   ::oController:getModel():hBuffer[ "codigo_iso" ] ;
         ID          120 ;
         VALID       ( ::oController:validate( "codigo_iso" ) ) ;
         WHEN        ( ::oController:isNotZoomMode() ) ;
         OF          ::oDialog ;

      REDEFINE SAY   ::oSayCamposExtra ;
         PROMPT      "Campos extra..." ;
         FONT        oFontBold() ; 
         COLOR       rgb( 10, 152, 234 ) ;
         ID          130 ;
         OF          ::oDialog ;

      ::oSayCamposExtra:lWantClick  := .t.
      ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

      ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

      ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

      if ::oController:isNotZoomMode() 
         ::oDialog:bKeyDown         := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
      else
         ::oDialog:bKeyDown         := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
      end if

      ::oDialog:bStart              := {|| ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionValidator

   ::hValidators  := {  "nombre" =>       {  "required"  => "El nombre es un dato requerido",;
                                             "unique"    => "El nombre introducida ya existe" },;
                        "codigo" =>       {  "required"  => "El código es un dato requerido" ,;
                                             "unique"    => "EL código introducido ya existe" },;
                        "codigo_iso" =>   {  "required"  => "El código ISO es un dato requerido" ,;
                                             "unique"    => "EL código ISO introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionModel FROM SQLCompanyModel

   DATA cTableName               INIT "unidades_medicion"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getUnidadMedicionSistema()

   METHOD getInsertUnidadesMedicionSentence()

   METHOD setUnidadesWhere( cSQLSelect, cGeneralWhere )

#ifdef __TEST__

   METHOD test_create_unidades()

   METHOD test_create_cajas() 

   METHOD test_create_palets() 

#endif

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionModel

   hset( ::hColumns, "id",                {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                             "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",              {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                             "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",            {  "create"    => "VARCHAR( 20 ) UNIQUE"                    ,;
                                             "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",            {  "create"    => "VARCHAR( 200 ) UNIQUE"                   ,;
                                             "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "codigo_iso",        {  "create"    => "VARCHAR( 6 )"                            ,;
                                             "default"   => {|| space( 6 ) } }                        )

   hset( ::hColumns, "sistema",           {  "create"    => "TINYINT( 1 )"                            ,;
                                             "default"   => {|| 0 } }                                 )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInsertUnidadesMedicionSentence() CLASS SQLUnidadesMedicionModel

   local cSql

   TEXT INTO cSql

   INSERT IGNORE INTO %1$s 
      ( uuid, codigo, nombre, codigo_iso, sistema, deleted_at ) 
   VALUES 
      ( UUID(), 'UDS', 'Unidades', 'UDS', 1, '0000-00-00 00:00:00' )

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getUnidadMedicionSistema() CLASS SQLUnidadesMedicionModel

   local cSql

   TEXT INTO cSql

   SELECT 
      unidades_medicion.codigo

   FROM %1$s AS unidades_medicion

      WHERE unidades_medicion.sistema = 1

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName() )

RETURN ( getSQLDatabase():getValue( cSql ) )

//---------------------------------------------------------------------------//

METHOD setUnidadesWhere( cCodigoGrupo ) CLASS SQLUnidadesMedicionModel

   local cCodigoUnidades   := SQLUnidadesMedicionOperacionesModel():getSerializeUnidadesWhereGrupo( cCodigoGrupo )

   ::setGeneralWhere( "codigo IN ( " + cCodigoUnidades + " )" )
     
RETURN ( nil )

//---------------------------------------------------------------------------//

#ifdef __TEST__

METHOD test_create_unidades() CLASS SQLUnidadesMedicionModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", "UDS" )
   hset( hBuffer, "nombre", "Unidades" )
   hset( hBuffer, "codigo_iso", "UDS" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_cajas() CLASS SQLUnidadesMedicionModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", "CAJAS" )
   hset( hBuffer, "nombre", "Cajas" )
   hset( hBuffer, "codigo_iso", "CAJ" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

METHOD test_create_palets() CLASS SQLUnidadesMedicionModel

   local hBuffer  := ::loadBlankBuffer()

   hset( hBuffer, "codigo", "PALETS" )
   hset( hBuffer, "nombre", "Palets" )
   hset( hBuffer, "codigo_iso", "PLT" )

RETURN ( ::insertBuffer( hBuffer ) )

//---------------------------------------------------------------------------//

#endif

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

#ifdef __TEST__

CLASS TestUnidadesMedicionController FROM TestCase

   METHOD testAppend()
   
   METHOD testDialogAppend()

   METHOD testDialogEmptyNombre()

   METHOD testDialogEmptyISO()

END CLASS

//---------------------------------------------------------------------------//

METHOD testAppend() CLASS TestUnidadesMedicionController

   local hBuffer  := {  'uuid' => win_uuidcreatestring(),;
                        'codigo' => '0',;
                        'nombre' => 'Test unidad de medición' }

   SQLUnidadesMedicionModel():truncateTable() 

   ::Assert():notEquals( 0, SQLUnidadesMedicionModel():insertBuffer( hBuffer ), "test id UnidadesMedicion distinto de cero" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogAppend() CLASS TestUnidadesMedicionController

   local oController 

   SQLUnidadesMedicionModel():truncateTable() 

   oController    := UnidadesMedicionController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         self:getControl( 100 ):cText( '0' ),;
         testWaitSeconds( 1 ),;
         self:getControl( 110 ):cText( 'Test uniades de medición' ),;
         testWaitSeconds( 1 ),;
         self:getControl( 120 ):cText( 'TST' ),;
         testWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click() } )

   ::Assert():true( oController:Append(), "test ::Assert():true with .t." )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogEmptyNombre() CLASS TestUnidadesMedicionController

   local oController 

   SQLUnidadesMedicionModel():truncateTable() 

   oController    := UnidadesMedicionController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         self:getControl( 100 ):cText( '0' ),;
         testWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( oController:Append(), "test creación unidad de medición sin nombre" )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD testDialogEmptyISO() CLASS TestUnidadesMedicionController

   local oController 

   SQLUnidadesMedicionModel():truncateTable() 

   oController    := UnidadesMedicionController():New()

   oController:getDialogView():setEvent( 'painted',;
      {| self | ;
         self:getControl( 100 ):cText( '0' ),;
         testWaitSeconds( 1 ),;
         self:getControl( 110 ):cText( 'Test uniades de medición' ),;
         testWaitSeconds( 1 ),;
         self:getControl( IDOK ):Click(),;
         testWaitSeconds( 1 ),;
         self:getControl( IDCANCEL ):Click() } )

   ::Assert():false( oController:Append(), "test creación unidad de medición sin codigo ISO" )

RETURN ( nil )

//---------------------------------------------------------------------------//

#endif