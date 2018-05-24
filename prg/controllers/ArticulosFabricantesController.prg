#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosFabricantesController FROM SQLNavigatorController

   DATA oImagenesController

   DATA oCamposExtraValoresController

   DATA oGetSelector

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosFabricantesController

   ::Super:New( oSenderController )

   ::cTitle                         := "Fabricantes"

   ::cName                          := "fabricantes"

   ::hImage                         := {  "16" => "gc_bolt_16",;
                                          "32" => "gc_bolt_32",;
                                          "48" => "gc_bolt_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosFabricantesModel():New( self )

   ::oBrowseView                    := ArticulosFabricantesBrowseView():New( self )

   ::oDialogView                    := ArticulosFabricantesView():New( self )

   ::oValidator                     := ArticulosFabricantesValidator():New( self, ::oDialogView )

   ::oImagenesController            := ImagenesController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

   ::oRepository                    := ArticulosFabricantesRepository():New( self )

   ::oGetSelector                   := GetSelector():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oImagenesController:loadPrincipalBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oImagenesController:insertBuffer() } )

   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::oImagenesController:loadedCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::oImagenesController:updateBuffer( ::getUuid() ) } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::oImagenesController:loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::oImagenesController:loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::oImagenesController:deleteBuffer( ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosFabricantesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oImagenesController:End()

   ::oCamposExtraValoresController:End()

   ::oRepository:End()

   ::oGetSelector:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFabricantesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosFabricantesBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 80
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
   end with

   with object ( ::oBrowse:AddCol() )
      :cHeader             := 'Uuid'
      :nWidth              := 200
      :bEditValue          := {|| ::getRowSet():fieldGet( 'uuid' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
      :lHide               := .t.
   end with

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'Código'
      :nWidth              := 80
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
      :cSortOrder          := 'pagina_web'
      :cHeader             := 'Página web'
      :nWidth              := 300
      :bEditValue          := {|| ::getRowSet():fieldGet( 'pagina_web' ) }
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

CLASS ArticulosFabricantesView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

    DATA oSayCamposExtra

   METHOD getImagenesController()   INLINE ( ::oController:oImagenesController )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ArticulosFabricantesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosFabricantesView

   local oGetImagen
   local oBmpImagen
   local oSayCamposExtra

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "FABRICANTES" ;
      TITLE       ::LblTitle() + "fabricante"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNN" ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "pagina_web" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   oGetImagen ;
      VAR         ::getImagenesController():oModel:hBuffer[ "imagen" ] ;
      ID          130 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetBmp( oGetImagen, oBmpImagen ) ) ;
      ON CHANGE   ( ChgBmp( oGetImagen, oBmpImagen ) ) ;
      WHEN        ( ::getImagenesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE IMAGE oBmpImagen ;
      ID          140 ;
      FILE        cFileBmpName( ::getImagenesController():oModel:hBuffer[ "imagen" ] ) ;
      OF          ::oDialog

      oBmpImagen:SetColor( , getsyscolor( 15 ) )
      oBmpImagen:bLClicked   := {|| ShowImage( oBmpImagen ) }
      oBmpImagen:bRClicked   := {|| ShowImage( oBmpImagen ) }

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          150 ;
      OF          ::oDialog

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oDialog ), ::oDialog:End( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:End() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oDialog ), ::oDialog:End( IDOK ), ) } )
   end if

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:End()

  oBmpImagen:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFabricantesValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosFabricantesValidator

   ::hValidators  := {  "codigo" =>    {  "required"           => "El código es un dato requerido",;
                                          "unique"             => "El código introducido ya existe" } ,;
                        "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" } }                  

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosFabricantesModel FROM SQLCompanyModel

   DATA cTableName                     INIT "articulos_fabricantes"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )   INLINE ( ::getField( "nombre", "uuid", uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosFabricantesModel


   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )
   
   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",      {  "create"    => "VARCHAR( 3 )"                            ,;
                                       "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 100 )"                          ,;
                                       "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "pagina_web",  {  "create"    => "VARCHAR( 200 )"                          ,;
                                       "default"   => {|| space( 200 ) } }                       )
   
   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFabricantesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosFabricantesModel():getTableName() ) 

   METHOD getNombres()                    

   METHOD getNombreWhereUuid( Uuid )      INLINE ( ::getColumnWhereUuid( Uuid, "nombre" ) )

   METHOD getUuidWhereNombre( cNombre )   INLINE ( ::getUuidWhereColumn( cNombre, "nombre", "" ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD getNombres() CLASS ArticulosFabricantesRepository

   local cSQL
   local aNombres       

   cSQL                 := "SELECT nombre FROM " + ::getTableName() + " "
   cSQL                 +=    "ORDER BY nombre ASC"

   aNombres             := ::getDatabase():selectFetchArrayOneColumn( cSQL )

   ains( aNombres, 1, "", .t. )

RETURN ( aNombres )

//---------------------------------------------------------------------------//