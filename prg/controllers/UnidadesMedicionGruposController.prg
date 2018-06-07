#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposController FROM SQLNavigatorController

   DATA oUnidadesMedicionGruposLineasController

   DATA oCamposExtraValoresController

   DATA oUnidadesMedicionController

   METHOD New()

   METHOD End()


END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS UnidadesMedicionGruposController

   ::Super:New( oSenderController )

   ::cTitle                                  := "Grupos de unidades de medici�n"

   ::cName                                   := "unidades_medicion_grupos"

   ::hImage                                  := {  "16" => "gc_tape_measure2_16",;
                                                   "32" => "gc_tape_measure2_32",;
                                                   "48" => "gc_tape_measure2_48" }

   ::nLevel                                  := Auth():Level( ::cName )

   ::oModel                                  := SQLUnidadesMedicionGruposModel():New( self )

   ::oBrowseView                             := UnidadesMedicionGruposBrowseView():New( self )

   ::oDialogView                             := UnidadesMedicionGruposView():New( self )

   ::oValidator                              := UnidadesMedicionGruposValidator():New( self, ::oDialogView )

   ::oRepository                             := UnidadesMedicionGruposRepository():New( self )

   ::oUnidadesMedicionGruposLineasController :=UnidadesMedicionGruposLineasController():New( self )

   ::oUnidadesMedicionController             := UnidadesMedicionController():New( self )

   ::oCamposExtraValoresController           := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oGetSelector                            := GetSelector():New( self )


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS UnidadesMedicionGruposController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oUnidadesMedicionGruposLineasController:End()

   ::oUnidadesMedicionController:End()

   ::oCamposExtraValoresController:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

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
      :cHeader             := 'C�digo'
      :nWidth              := 50
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposView FROM SQLBaseView

   DATA oSayCamposExtra

   METHOD Activate()

   METHOD StartActivate() 

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS UnidadesMedicionGruposView

   local oDialog
   local oSayCamposExtra
   local oBtnEdit
   local oBtnAppend
   local oBtnDelete

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "GRUPO_UNIDAD_MEDICION" ;
      TITLE       ::LblTitle() + " grupo de unidades de medici�n"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog ;

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog ;
   
   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog ;

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) )
   
   ::oController:oUnidadesMedicioncontroller:oGetSelector:setEvent( 'validated', {|| ::UnidadesMedicionControllerValidated() } )

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Activate( 120, 122, ::oDialog )


   // Unidades equivalencia--------------------------------------------------------------------

   REDEFINE BUTTON oBtnAppend ;
      ID          130 ;
      OF          ::oDialog ;
      WHEN        ( !empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .and. ::oController:isNotZoomMode() ) ;

   oBtnAppend:bAction   := {|| ::oController:oUnidadesMedicionGruposLineasController:Append() }

   REDEFINE BUTTON oBtnEdit ;
      ID          140 ;
      OF          ::oDialog ;
      WHEN        ( !empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .and. ::oController:isNotZoomMode() ) ;

   oBtnEdit:bAction   := {|| ::oController:oUnidadesMedicionGruposLineasController:Edit() }

   REDEFINE BUTTON oBtnDelete ;
      ID          150 ;
      OF          ::oDialog ;
      WHEN        ( !empty( ::oController:oModel:hBuffer[ "unidad_base_codigo" ] ) .and. ::oController:isNotZoomMode() ) ;

   oBtnDelete:bAction   := {|| ::oController:oUnidadesMedicionGruposLineasController:Delete() }

   ::oController:oUnidadesMedicionGruposLineasController:Activate( 160, ::oDialog ) 

// campos extra--------------------------------------------------------------------------------------------------------------//

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          170 ;
      OF          ::oDialog ;

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

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

   ::oController:oUnidadesMedicioncontroller:oGetSelector:Start()

RETURN ( self )
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS UnidadesMedicionGruposValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS UnidadesMedicionGruposValidator

   ::hValidators  := {  "nombre" =>       {  "required"           => "La descripci�n es un dato requerido",;
                                             "unique"             => "La descripci�n introducida ya existe" },;
                        "codigo" =>       {  "required"           => "El c�digo es un dato requerido" ,;
                                             "unique"             => "EL c�digo introducido ya existe"  } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLUnidadesMedicionGruposModel FROM SQLCompanyModel

   DATA cTableName               INIT "unidades_medicion_grupos"

   METHOD getColumns()

   METHOD getInitialSelect()

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLUnidadesMedicionGruposModel

   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;                          
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;                                  
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "codigo",                        {  "create"    => "VARCHAR( 20 ) UNIQUE"                    ,;
                                                         "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "nombre",                        {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "unidad_base_codigo",            {  "create"    => "VARCHAR( 20 )"                           ,;
                                                         "default"   => {|| space( 20 ) } }                       )


RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getInitialSelect() CLASS SQLUnidadesMedicionGruposModel

   local cSelect  := "SELECT unidades_medicion_grupos.id,"                                                                          + " " + ;
                        "unidades_medicion_grupos.uuid,"                                                                            + " " + ;
                        "unidades_medicion_grupos.codigo,"                                                                          + " " + ;
                        "unidades_medicion_grupos.nombre,"                                                                          + " " + ;
                        "unidades_medicion_grupos.unidad_base_codigo,"                                                              + " " + ;
                        "unidades_medicion.nombre as unidad_base_nombre"                                                            + " " + ;   
                     "FROM unidades_medicion_grupos"                                                                                + " " + ;
                        "INNER JOIN unidades_medicion  ON unidades_medicion_grupos.unidad_base_codigo = unidades_medicion.codigo"   + " " 

RETURN ( cSelect )
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
