#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   METHOD insertLineaUnidadBase()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := UnidadesMedicionGruposBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := UnidadesMedicionGruposView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := UnidadesMedicionGruposValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := UnidadesMedicionGruposRepository():New( self ), ), ::oRepository )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionGruposController

   ::Super:New( oSenderController )

   ::cTitle                                  := "Grupos de unidades de medición"

   ::cName                                   := "unidades_medicion_grupos"

   ::hImage                                  := {  "16" => "tab_pane_tape_measure2_16",;
                                                   "32" => "tab_pane_tape_measure2_32",;
                                                   "48" => "tab_pane_tape_measure2_48" }

   ::nLevel                                  := Auth():Level( ::cName )

   ::oModel                                  := SQLUnidadesMedicionGruposModel():New( self )

   ::setEvents( { 'editing', 'deleting' }, {|| if( ::isRowSetSystemRegister(), ( msgStop( "Este registro pertenece al sistema, no se puede alterar." ), .f. ), .t. ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionGruposController

   ::oModel:End()

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

   ::Super:End()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD insertLineaUnidadBase() CLASS UnidadesMedicionGruposController

   if empty( ::getUnidadesMedicionGruposLineasController():oModel:getField( 'uuid', 'parent_uuid', ::getUuid() ) )

      ::getUnidadesMedicionGruposLineasController():oModel:insertLineaUnidadBase( ::oModel:hBuffer[ "uuid" ], ::oModel:hBuffer[ "unidad_base_codigo" ] )

   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS UnidadesMedicionGruposBrowseView

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
      :cSortOrder          := 'unidad_base_nombre'
      :cHeader             := 'Unidad base'
      :nWidth              := 150
      :bEditValue          := {|| ::getRowSet():fieldGet( 'unidad_base_nombre' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'sistema'
      :cHeader             := 'Sistema'
      :nWidth              := 75
      :bEditValue          := {|| if( ::getRowSet():fieldGet( 'sistema' ) == 1, "Sistema", "" ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposView FROM SQLBaseView

   DATA oSayCamposExtra

   METHOD Activate()

   METHOD StartActivate() 

   METHOD validatedUnidadesMedicioncontroller()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionGruposView

   local oBtnEdit
   local oBtnAppend
   local oBtnDelete
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "GRUPO_UNIDAD_MEDICION" ;
      TITLE       ::LblTitle() + " grupo de unidades de medición"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() );
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ::oController:getUnidadesMedicioncontroller():oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) )
   
   ::oController:getUnidadesMedicioncontroller():oGetSelector:setEvent( 'validated', {|| ::validatedUnidadesMedicioncontroller() } )

   ::oController:getUnidadesMedicioncontroller():oGetSelector:setWhen( {|| Empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .AND. ::oController:isNotZoomMode() } )

   ::oController:getUnidadesMedicioncontroller():oGetSelector:Build( { "idGet" => 120, "idText" => 121,"idLink" => 122, "oDialog" => ::oDialog } )

   // Unidades equivalencia--------------------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          130 ;
      OF          ::oDialog ;
      ACTION      ( ::oController:getUnidadesMedicionGruposLineasController():Append() ) ;
      WHEN        ( !empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .and. ::oController:isNotZoomMode() ) ;

   REDEFINE BUTTON oBtnEdit ;
      ID          140 ;
      OF          ::oDialog ;
      ACTION      ( ::oController:getUnidadesMedicionGruposLineasController():Edit() ) ;
      WHEN        ( !empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .and. ::oController:isNotZoomMode() ) ;

   // oBtnEdit:bAction   := {||  }

   REDEFINE BUTTON oBtnDelete ;
      ID          150 ;
      OF          ::oDialog ;
      ACTION      ( ::oController:getUnidadesMedicionGruposLineasController():Delete() ) ;
      WHEN        ( !empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .and. ::oController:isNotZoomMode() ) ;

   ::oController:getUnidadesMedicionGruposLineasController():Activate( 160, ::oDialog ) 

   // campos extra-------------------------------------------------------------

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          170 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   // botones------------------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::StartActivate() }
   
   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD StartActivate() CLASS UnidadesMedicionGruposView

   ::oController:getUnidadesMedicioncontroller():getSelector():Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validatedUnidadesMedicioncontroller() CLASS UnidadesMedicionGruposView

   ::oController:insertLineaUnidadBase()
   
   ::oController:getUnidadesMedicionGruposLineasController():RefreshRowSetAndGoTop()
   
   ::oController:getUnidadesMedicionGruposLineasController():RefreshBrowseView()

Return ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionGruposValidator

   ::hValidators  := {  "nombre" =>    {  "required"  => "La descripción es un dato requerido",;
                                          "unique"    => "La descripción introducida ya existe" },;
                        "codigo" =>    {  "required"  => "El código es un dato requerido" ,;
                                          "unique"    => "EL código introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionGruposModel FROM SQLCompanyModel

   DATA cTableName                        INIT "unidades_medicion_grupos"

   METHOD getColumns()
 
   METHOD getInitialSelect() 

   METHOD getUnidadesMedicionModel()      INLINE ( SQLUnidadesMedicionModel():getTableName() )

   METHOD getInsertUnidadesMedicionGruposSentence()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionGruposModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",                        {  "create"    => "VARCHAR( 20 ) NOT NULL UNIQUE"           ,;
                                                         "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",                        {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "unidad_base_codigo",            {  "create"    => "VARCHAR( 20 )"                           ,;
                                                         "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "sistema",                       {  "create"    => "TINYINT( 1 )"                            ,;
                                                         "default"   => {|| "0" } }                               )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLUnidadesMedicionGruposModel

   local cSelect  := "SELECT grupos.id,"                                                                                         + " " + ;
                        "grupos.uuid,"                                                                                           + " " + ;
                        "grupos.codigo,"                                                                                         + " " + ;
                        "grupos.nombre,"                                                                                         + " " + ;
                        "grupos.unidad_base_codigo,"                                                                             + " " + ;
                        "grupos.sistema,"                                                                                        + " " + ;
                        "unidad.nombre AS unidad_base_nombre"                                                                    + " " + ;   
                     "FROM " + ::getTableName() +" AS grupos"                                                                    + " " + ;
                        "INNER JOIN " + ::getUnidadesMedicionModel() + " AS unidad ON grupos.unidad_base_codigo = unidad.codigo"       

RETURN ( cSelect )

//---------------------------------------------------------------------------//

METHOD getInsertUnidadesMedicionGruposSentence() CLASS SQLUnidadesMedicionGruposModel

   local uuid           := win_uuidcreatestring()
   local cSentence
   local aSentence      := {} 
   local cCodigoDefecto := quoted( __grupo_unidades_medicion__ )

   cSentence            := "INSERT IGNORE INTO " + ::getTableName()                       + " " + ;
                              "( uuid, codigo, nombre, unidad_base_codigo, sistema )"     + " " + ;
                           "VALUES"                                                       + " " + ;
                              "( " + quoted( uuid ) + ", " + cCodigoDefecto + ", 'Unidades', " + cCodigoDefecto + ", 1 )"

   aadd( aSentence, cSentence )

   cSentence            := "INSERT IGNORE INTO " + SQLUnidadesMedicionGruposLineasModel():getTableName()                         + " " + ;
                              "( uuid, parent_uuid, unidad_alternativa_codigo, cantidad_alternativa, cantidad_base, sistema )"   + " " + ;
                           "VALUES"                                                                                              + " " + ;
                              "( UUID(), " + quoted( uuid ) + ", " + cCodigoDefecto + ", 1, 1, 1 )"

   aadd( aSentence, cSentence )

RETURN ( aSentence )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLUnidadesMedicionGruposModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
