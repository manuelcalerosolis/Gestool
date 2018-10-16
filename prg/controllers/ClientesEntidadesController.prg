#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesEntidadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedBlankBuffer()

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ClientesEntidadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ClientesEntidadesView():New( self ), ), ::oDialogView )

   METHOD getRepository()                 INLINE( if( empty( ::oRepository ), ::oRepository := ClientesEntidadesRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ClientesEntidadesController

   ::Super:New( oController )

   ::cTitle                         := "Entidades_clientes"

   ::cName                          := "Entidades clientes"

   ::hImage                         := {  "16" => "gc_university_16",;
                                          "32" => "gc_university_32",;
                                          "48" => "gc_university_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLClientesEntidadesModel():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesEntidadesController

   ::oModel:End()

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if 

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ClientesEntidadesController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ClientesEntidadesController

   local uuid        := ::getController():getUuid()  
   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   local idDocumento     

   if empty( uuidEntidad )
      ::oModel:insertBuffer()
   end if 

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      idDocumento      := ::oModel:insertBlankBuffer()
   end if 

   ::oModel:loadCurrentBuffer( idDocumento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   local idDocumento     

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::oModel:updateBuffer()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   local idDocumento     

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::oModel:insertBuffer()
      RETURN ( nil )
   end if 

   ::oModel:loadDuplicateBuffer( idDocumento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS ClientesEntidadesController

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

CLASS ClientesEntidadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ClientesEntidadesBrowseView

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
      :cSortOrder          := 'nombre_entidad'
      :cHeader             := 'Entidad'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'nombre_entidad' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'rol'
      :cHeader             := 'Rol'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'rol' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesEntidadesView FROM SQLBaseView

   DATA oRol
   DATA aRol INIT  {    "Fiscal",;
                        "Oficina contable",;
                        "Receptor",;
                        "Órgano Gestor",;
                        "Tercero",;
                        "Pagador",; 
                        "Unidad tramitadora",; 
                        "Comprador",; 
                        "Órgano proponente",; 
                        "Cobrador",; 
                        "Vendedor",; 
                        "Receptor del pago",; 
                        "Receptor del cobro",;
                        "Emisor" }   

   METHOD Activate()

   METHOD startActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ClientesEntidadesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CLIENTE_ENTIDAD" ;
      TITLE       ::LblTitle() + "Clientes Entidades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48") ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog 

   ::oController:getEntidadesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "entidad_uuid" ] ) )
   ::oController:getEntidadesController():getSelector():Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )

   REDEFINE COMBOBOX ::oRol ;
      VAR         ::oController:oModel:hBuffer[ "rol" ] ;
      ID          110 ;
      ITEMS       ::aRol;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

   ::oController:getEntidadesController():oGetSelector:Start()

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLClientesEntidadesModel FROM SQLCompanyModel

   DATA cTableName                        INIT "clientes_entidades"

   METHOD getColumns()

   METHOD getNombreWhereCodigo( codigo )  INLINE ( ::getField( 'nombre', 'codigo', codigo ) )

   METHOD setEntidadUuidAttribute( uValue ) ;
                                          INLINE ( if( empty( uValue ), "", SQLEntidadesModel():getUuidWhereCodigo( uValue ) ) )
             

   METHOD getEntidadUuidAttribute( uValue ) ; 
                                          INLINE ( if( empty( uValue ), space( 3 ), SQLEntidadesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD getParentUuidAttribute( value )

   METHOD addEmpresaWhere( cSQLSelect )

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLClientesEntidadesModel

 local cSql

   TEXT INTO cSql

      SELECT clientes_entidades.id,
             clientes_entidades.uuid,
             clientes_entidades.rol,
             clientes_entidades.parent_uuid,
             entidades.uuid,
             entidades.nombre as nombre_entidad

      FROM %1$s AS clientes_entidades

      INNER JOIN %2$s AS entidades
         ON clientes_entidades.entidad_uuid = entidades.uuid

      INNER JOIN %3$s AS clientes
         ON clientes_entidades.parent_uuid = clientes.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLEntidadesModel():getTableName(), SQLClientesModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD addEmpresaWhere( cSQLSelect ) CLASS SQLClientesEntidadesModel

   if !::isEmpresaColumn()
      RETURN ( cSQLSelect )
   end if 

   cSQLSelect     += ::getWhereOrAnd( cSQLSelect ) + "clientes_entidades.empresa_uuid = " + toSQLString( uuidEmpresa() )

RETURN ( cSQLSelect )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLClientesEntidadesModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"             ,;
                                                   "default"   => {|| 0 } }                                   )
   
   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"               ,;
                                                   "default"   => {|| win_uuidcreatestring() } }              )

   hset( ::hColumns, "entidad_uuid",            {  "create"    => "VARCHAR(40) NOT NULL"                       ,;                                  
                                                   "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                    ,;
                                                   "default"   => {|| space( 40 ) } }                         )

   hset( ::hColumns, "rol",                     {  "create"    => "VARCHAR ( 200 )"                           ,;
                                                   "default"   => {|| space( 200 ) } }                        )
RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLClientesEntidadesModel

   if empty( ::oController )
      RETURN ( value )
   end if

   if empty( ::oController:oController )
      RETURN ( value )
   end if

RETURN ( ::oController:oController:getUuid() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesEntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLClientesEntidadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
