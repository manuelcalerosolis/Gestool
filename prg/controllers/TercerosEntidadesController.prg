#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS TercerosEntidadesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR
   METHOD End()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::getModel():loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::getModel():insertBuffer() )

   METHOD loadedBlankBuffer()

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()              INLINE( if( empty( ::oBrowseView ), ::oBrowseView := TercerosEntidadesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()              INLINE( if( empty( ::oDialogView ), ::oDialogView := TercerosEntidadesView():New( self ), ), ::oDialogView )

   METHOD getRepository()              INLINE( if( empty( ::oRepository ), ::oRepository := TercerosEntidadesRepository():New( self ), ), ::oRepository )
   
   METHOD getModel()                   INLINE( if( empty( ::oModel ), ::oModel := SQLTercerosEntidadesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS TercerosEntidadesController

   ::Super:New( oController )

   ::cTitle                            := "Entidades Terceros"

   ::cName                             := "entidades_Terceros"

   ::hImage                            := {  "16" => "gc_university_16",;
                                             "32" => "gc_university_32",;
                                             "48" => "gc_university_48" }

   ::getModel():setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End() CLASS TercerosEntidadesController

   if !empty( ::oModel )
      ::oModel:End()
   end if

   if !empty( ::oBrowseView )
      ::oBrowseView:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

   if !empty( ::oRepository )
      ::oRepository:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS TercerosEntidadesController

   local uuid        := ::getController():getUuid() 

   if !empty( uuid )
      ::setModelBuffer( "parent_uuid", uuid )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS TercerosEntidadesController

   local uuid        := ::getController():getUuid()
 
   if !empty( uuid )
      ::getModel():setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD LoadedCurrentBuffer( uuidEntidad ) CLASS TercerosEntidadesController

   local idDocumento     

   if empty( uuidEntidad )
      ::getModel():insertBuffer()
   end if 

   idDocumento          := ::getModel():getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      idDocumento      := ::getModel():insertBlankBuffer()
   end if 

   ::getModel():loadCurrentBuffer( idDocumento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS TercerosEntidadesController

   if empty( ::getModel():getIdWhereParentUuid( uuidEntidad ) )
      ::getModel():insertBuffer()
   else
      ::getModel():updateBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS TercerosEntidadesController

   local idDocumento     

   idDocumento          := ::getModel():getIdWhereParentUuid( uuidEntidad )

   if empty( idDocumento )
      ::getModel():insertBuffer()
      RETURN ( nil )
   end if 

   ::getModel():loadDuplicateBuffer( idDocumento )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS TercerosEntidadesController

   hset( ::getModel():hBuffer, "parent_uuid", uuidEntidad )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS TercerosEntidadesController

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

CLASS TercerosEntidadesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS TercerosEntidadesBrowseView

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

CLASS TercerosEntidadesView FROM SQLBaseView

   DATA oRol
   DATA aRol   INIT  {  "Fiscal",;
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

METHOD Activate() CLASS TercerosEntidadesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TERCERO_ENTIDAD" ;
      TITLE       ::LblTitle() + "terceros entidades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48") ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog 

   ::oController:getEntidadesController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "codigo_entidad" ] ) )
   ::oController:getEntidadesController():getSelector():Build( { "idGet" => 100, "idText" => 101, "idLink" => 102, "oDialog" => ::oDialog } )

   REDEFINE COMBOBOX ::oRol ;
      VAR         ::oController:getModel():hBuffer[ "rol" ] ;
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

CLASS SQLTercerosEntidadesModel FROM SQLCompanyModel

   DATA cTableName                        INIT "terceros_entidades"

   DATA cConstraints                      INIT "PRIMARY KEY ( codigo_entidad, parent_uuid, rol, deleted_at )"

   METHOD getColumns()

   METHOD getNombreWhereCodigo( codigo )  INLINE ( ::getField( 'nombre', 'codigo', codigo ) )

   METHOD getParentUuidAttribute( value )

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLTercerosEntidadesModel

 local cSql

   TEXT INTO cSql

      SELECT terceros_entidades.id AS id,
         terceros_entidades.uuid AS uuid,
         terceros_entidades.rol AS rol,
         terceros_entidades.parent_uuid AS parent_uuid,
         terceros_entidades.deleted_at AS deleted_at,
         entidades.codigo AS codigo_entidad,
         entidades.nombre AS nombre_entidad

      FROM %1$s AS terceros_entidades

      INNER JOIN %2$s AS entidades
         ON terceros_entidades.codigo_entidad = entidades.codigo

      LEFT JOIN %3$s AS Terceros
         ON terceros_entidades.parent_uuid = Terceros.uuid

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), SQLEntidadesModel():getTableName(), SQLTercerosModel():getTableName() )

RETURN ( cSql )

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLTercerosEntidadesModel

   hset( ::hColumns, "id",                      {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"             ,;
                                                   "default"   => {|| 0 } }                                   )
   
   hset( ::hColumns, "uuid",                    {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"               ,;
                                                   "default"   => {|| win_uuidcreatestring() } }              )

   hset( ::hColumns, "codigo_entidad",          {  "create"    => "VARCHAR(20) NOT NULL"                       ,;                                  
                                                   "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "parent_uuid",             {  "create"    => "VARCHAR( 40 ) NOT NULL"                    ,;
                                                   "default"   => {|| space( 40 ) } }                         )

   hset( ::hColumns, "rol",                     {  "create"    => "VARCHAR ( 200 )"                           ,;
                                                   "default"   => {|| space( 200 ) } }                        )
   
   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getParentUuidAttribute( value ) CLASS SQLTercerosEntidadesModel

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

CLASS TercerosEntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLTercerosEntidadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
