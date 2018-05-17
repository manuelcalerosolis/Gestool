#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ClientesEntidadesController FROM SQLNavigatorController

   DATA oEntidadesController

   METHOD New()

   METHOD gettingSelectSentence()

   METHOD loadBlankBuffer()            INLINE ( ::oModel:loadBlankBuffer() )
   METHOD insertBuffer()               INLINE ( ::oModel:insertBuffer() )

   METHOD loadedBlankBuffer()

   METHOD loadedCurrentBuffer( uuidEntidad ) 
   METHOD updateBuffer( uuidEntidad )

   METHOD loadedDuplicateCurrentBuffer( uuidEntidad )
   METHOD loadedDuplicateBuffer( uuidEntidad )

   METHOD deleteBuffer( aUuidEntidades )

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ClientesEntidadesController

   ::Super:New( oSenderController )

   ::cTitle                      := "Clientes Entidades"

   ::cName                       := "Clientes Entidades"

   ::hImage                      := {  "16" => "gc_university_16",;
                                       "32" => "gc_university_32",;
                                       "48" => "gc_university_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLClientesEntidadesModel():New( self )

   ::oBrowseView                    := ClientesEntidadesBrowseView():New( self )

   ::oDialogView                    := ClientesEntidadesView():New( self )

   ::oValidator                     := ClientesEntidadesValidator():New( self, ::oDialogView )

   ::oRepository                    := ClientesEntidadesRepository():New( self )

   ::oEntidadesController           := EntidadesController():New( self )

   ::setEvent( 'appended',                      {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'edited',                        {|| ::oBrowseView:Refresh() } )
   ::setEvent( 'deletedSelection',              {|| ::oBrowseView:Refresh() } )

   ::oModel:setEvent( 'gettingSelectSentence',  {|| ::gettingSelectSentence() } )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ClientesEntidadesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadedBlankBuffer() CLASS ClientesEntidadesController

   local uuid        := ::getSenderController():getUuid() 

   if !empty( uuid )
      hset( ::oModel:hBuffer, "parent_uuid", uuid )
   end if 

RETURN ( Self )
//---------------------------------------------------------------------------//

METHOD gettingSelectSentence() CLASS ClientesEntidadesController

   local uuid        := ::getSenderController():getUuid()  
   if !empty( uuid )
      ::oModel:setGeneralWhere( "parent_uuid = " + quoted( uuid ) )
   end if 
RETURN ( Self )

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

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD UpdateBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   local idDocumento     

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateCurrentBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   local idDocumento     

   idDocumento          := ::oModel:getIdWhereParentUuid( uuidEntidad )
   if empty( idDocumento )
      ::oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oModel:loadDuplicateBuffer( idDocumento )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadedDuplicateBuffer( uuidEntidad ) CLASS ClientesEntidadesController

   hset( ::oModel:hBuffer, "parent_uuid", uuidEntidad )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD deleteBuffer( aUuidEntidades ) CLASS ClientesEntidadesController

   if empty( aUuidEntidades )
      RETURN ( self )
   end if

   ::oModel:deleteWhereParentUuid( aUuidEntidades )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
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
      :cSortOrder          := 'entidad'
      :cHeader             := 'Entidad'
      :nWidth              := 130
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesEntidadesView FROM SQLBaseView

   CLASSDATA aRol INIT  {  "Fiscal" => "fiscal"                               ,;
                           "Oficina contable" =>"oficina_contable"            ,;
                           "Receptor" => "receptor"                           ,;
                           "Órgano Gestor" => "organo_gestor"                 ,;
                           "Tercero" => "tercero"                             ,;
                           "Pagador" => "pagador"                             ,; 
                           "Unidad tramitadora" => "unidad_tramitadora"       ,; 
                           "Comprador" =>"comprador"                          ,; 
                           "Órgano proponente" => "organo_proponente"         ,; 
                           "Cobrador" => "cobrador"                           ,; 
                           "Vendedor" => "vendedor"                           ,; 
                           "Receptor del pago" => "receptor_pago"             ,; 
                           "Receptor del cobro" => "receptor_cobro"           ,;
                            "Emisor"=> "emisor" }   
  
   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ClientesEntidadesView

   local oDialog
   local oBmpGeneral

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CLIENTE_ENTIDAD" ;
      TITLE       ::LblTitle() + "Clientes Entidades"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_document_text_gear_48" ;
      TRANSPARENT ;
      OF          ::oDialog 

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog 

   ::oController:oEntidadesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "codigo_entidad" ] ) )
   ::oController:oEntidadesController:oGetSelector:Activate( 100, 101, ::oDialog )

   REDEFINE COMBOBOX ::aRol ;
      VAR         ::oController:oModel:hBuffer[ "rol" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION     ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesEntidadesValidator FROM SQLBaseValidator

   METHOD getValidators()


 END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ClientesEntidadesValidator

   ::hValidators  := {  "entidad" =>               {  "required"           => "La entidad es un dato requerido",;
                                                      "unique"             => "La entidad introducida ya existe" }  }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLClientesEntidadesModel FROM SQLCompanyModel

   DATA cTableName               INIT "clientes_entidades"

   METHOD getColumns()

   METHOD getInitialSelect()

   METHOD getCodigoWhereParentUuid( uuid ) INLINE ( ::getField( 'codigo', 'parent_uuid', uuid ) )          

   METHOD getParentUuidAttribute( value )

   METHOD addEmpresaWhere( cSQLSelect )

END CLASS

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLClientesEntidadesModel

   local cSelect  := "SELECT clientes_entidades.id,"                                                               + " " + ;
                        "clientes_entidades.uuid,"                                                                 + " " + ;
                        "clientes_entidades.rol,"                                                                  + " " + ;
                        "clientes_entidades.parent_uuid,"                                                          + " " + ;
                        "entidades.uuid,"                                                                          + " " + ;
                        "entidades.codigo as codigo_entidad,"                                                      + " " + ;
                        "entidades.nombre as nombre_entidad"                                                       + " " + ;
                     "FROM clientes_entidades"                                                                     + " " + ;
                        "INNER JOIN entidades ON clientes_entidades.entidad_uuid = entidades.uuid"                 + " " + ;
                        "INNER JOIN clientes ON clientes_entidades.parent_uuid = clientes.uuid"  + " "

   logwrite( cSelect )

RETURN ( cSelect )

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
   ::getEmpresaColumns()

   hset( ::hColumns, "entidad_uuid",            {  "create"    => "VARCHAR(40) NOT NULL UNIQUE"               ,;                                  
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

   if empty( ::oController:oSenderController )
      RETURN ( value )
   end if

RETURN ( ::oController:oSenderController:getUuid() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ClientesEntidadesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLClientesEntidadesModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//