#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosFabricantesController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //COnstrucciones tardias----------------------------------------------------

   METHOD getBrowseView()                 INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosFabricantesBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()                 INLINE( if( empty( ::oDialogView ), ::oDialogView := ArticulosFabricantesView():New( self ), ), ::oDialogView )

   METHOD getValidator()                  INLINE( if( empty( ::oValidator ), ::oValidator := ArticulosFabricantesValidator():New( self ), ), ::oValidator )

   METHOD getRepository()                 INLINE ( if( empty( ::oRepository ), ::oRepository := ArticulosFabricantesRepository():New( self ), ), ::oRepository )

   METHOD getModel()                      INLINE ( if( empty( ::oModel ), ::oModel := SQLArticulosFabricantesModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosFabricantesController

   ::Super:New( oController )

   ::cTitle                         := "Fabricantes"

   ::cName                          := "fabricantes"

   ::hImage                         := {  "16" => "gc_bolt_16",;
                                          "32" => "gc_bolt_32",;
                                          "48" => "gc_bolt_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::getModel():setEvent( 'loadedBlankBuffer',            {|| ::getImagenesController():loadMainBlankBuffer() } )
   ::getModel():setEvent( 'insertedBuffer',               {|| ::getImagenesController():insertBuffer() } )

   ::getModel():setEvent( 'loadedCurrentBuffer',          {|| ::getImagenesController():loadedCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'updatedBuffer',                {|| ::getImagenesController():updateBuffer( ::getUuid() ) } )

   ::getModel():setEvent( 'loadedDuplicateCurrentBuffer', {|| ::getImagenesController():loadedDuplicateCurrentBuffer( ::getUuid() ) } )
   ::getModel():setEvent( 'loadedDuplicateBuffer',        {|| ::getImagenesController():loadedDuplicateBuffer( ::getUuid() ) } )
   
   ::getModel():setEvent( 'deletedSelection',             {|| ::getImagenesController():deleteBuffer( ::getUuidFromRecno( ::getBrowseView():getBrowse():aSelected ) ) } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosFabricantesController
   
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

   ::Super:End()

   self                             := nil

RETURN ( nil )

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

   ::getColumnIdAndUuid()

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

   ::getColumnsCreatedUpdatedAt()

   ::getColumnDeletedAt() 

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

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS ArticulosFabricantesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:getModel():hBuffer()
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
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode()  ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode()  ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oDialog

   REDEFINE GET   ::oController:getModel():hBuffer[ "pagina_web" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE GET   oGetImagen ;
      VAR         ::oController:getImagenesController():getModel():hBuffer[ "imagen" ] ;
      ID          130 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetBmp( oGetImagen, oBmpImagen ) ) ;
      ON CHANGE   ( ChgBmp( oGetImagen, oBmpImagen ) ) ;
      WHEN        ( ::oController:getImagenesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE IMAGE oBmpImagen ;
      ID          140 ;
      FILE        cFileBmpName( ::oController:getImagenesController():getModel():hBuffer[ "imagen" ] ) ;
      OF          ::oDialog

      oBmpImagen:SetColor( , getsyscolor( 15 ) )
      oBmpImagen:bLClicked   := {|| ShowImage( oBmpImagen ) }
      oBmpImagen:bRClicked   := {|| ShowImage( oBmpImagen ) }

   REDEFINE SAY   ::oSayCamposExtra ;
      PROMPT      "Campos extra..." ;
      FONT        oFontBold() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          150 ;
      OF          ::oDialog

   ::oSayCamposExtra:lWantClick  := .t.
   ::oSayCamposExtra:OnClick     := {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) }

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }
   
   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
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

CLASS ArticulosFabricantesValidator FROM SQLBaseValidator

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

   DATA cConstraints                   INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )   INLINE ( ::getField( "nombre", "uuid", uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosFabricantesModel


   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )
   
   hset( ::hColumns, "codigo",      {  "create"    => "VARCHAR( 20 )"                            ,;
                                       "default"   => {|| space( 20 ) } }                        )

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 100 )"                          ,;
                                       "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "pagina_web",  {  "create"    => "VARCHAR( 200 )"                          ,;
                                       "default"   => {|| space( 200 ) } }                       )
   
   ::getTimeStampColumns()

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

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