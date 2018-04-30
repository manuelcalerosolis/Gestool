#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FabricantesController FROM SQLNavigatorController

   DATA oImagenesController

   DATA oGetSelector

   METHOD New()

<<<<<<< HEAD
=======
   METHOD End()

   METHOD ImagenesControllerLoadCurrentBuffer()

   METHOD ImagenesControllerUpdateBuffer()

   METHOD ImagenesControllerDeleteBuffer()

   METHOD ImagenesControllerLoadedDuplicateCurrentBuffer()

   METHOD ImagenesControllerLoadedDuplicateBuffer()

>>>>>>> 28a2b6a2a8a2bfdcc714696461ebb140224b725e
END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS FabricantesController

   ::Super:New()

   ::cTitle                      := "Fabricantes"

   ::cName                       := "fabricantes"

   ::hImage                      := {  "16" => "gc_businessman2_16",;
                                       "32" => "gc_businessman2_32",;
                                       "48" => "gc_businessman2_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLFabricantesModel():New( self )

   ::oBrowseView                 := FabricantesBrowseView():New( self )

   ::oDialogView                 := FabricantesView():New( self )

   ::oValidator                  := FabricantesValidator():New( self, ::oDialogView )

   ::oImagenesController         := ImagenesController():New( self )

   ::oRepository                 := FabricantesRepository():New( self )

   ::oGetSelector                := ComboSelector():New( self )

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
<<<<<<< HEAD
=======
METHOD End() CLASS FabricantesController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oImagenesController:End()

   ::oRepository:End()

   /*::oGetSelector:End()*/

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadCurrentBuffer()

   local idImagen     
   local uuidFabricante    := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidFabricante )
      ::oImagenesController:oModel:insertBuffer()
   end if 

   idImagen                := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFabricante )
   if empty( idImagen )
      ::oImagenesController:oModel:loadBlankBuffer()
      idImagen             := ::oImagenesController:oModel:insertBuffer()
   end if 

   ::oImagenesController:oModel:loadCurrentBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerUpdateBuffer()

   local idImagen     
   local uuidFabricante     := hget( ::oModel:hBuffer, "uuid" )

   idImagen                := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFabricante )
   if empty( idImagen )
      ::oImagenesController:oModel:loadBlankBuffer()
      idImagen             := ::oImagenesController:oModel:insertBuffer()
      RETURN ( self )
   end if 
   ::oImagenesController:oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerDeleteBuffer()

   local aUuidFabricante   := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuidFabricante )
      RETURN ( self )
   end if

   ::oImagenesController:oModel:deleteWhereParentUuid( aUuidFabricante )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadedDuplicateCurrentBuffer()

   local uuidFabricante
   local idImagen     

   uuidFabricante       := hget( ::oModel:hBuffer, "uuid" )

   idImagen             := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFabricante )
   if empty( idImagen )
      ::oImagenesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oImagenesController:oModel:loadDuplicateBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadedDuplicateBuffer()

   local uuidFabricante    := hget( ::oModel:hBuffer, "uuid" )

   hset( ::oImagenesController:oModel:hBuffer, "parent_uuid", uuidFabricante )

RETURN ( self )

//---------------------------------------------------------------------------//
>>>>>>> 28a2b6a2a8a2bfdcc714696461ebb140224b725e
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FabricantesBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS FabricantesBrowseView

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

CLASS FabricantesView FROM SQLBaseView
  
   METHOD Activate()

   METHOD Activating()

   METHOD getImagenesController()   INLINE ( ::oController:oImagenesController )

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS FabricantesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( self )
//---------------------------------------------------------------------------//

METHOD Activate() CLASS FabricantesView

   local getImagen
   local bmpImagen

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "FABRICANTES" ;
      TITLE       ::LblTitle() + "fabricante"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_wrench_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
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

   REDEFINE GET   getImagen ;
      VAR         ::getImagenesController():oModel:hBuffer[ "imagen" ] ;
      ID          130 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetBmp( getImagen, bmpImagen ) ) ;
      ON CHANGE   ( ChgBmp( getImagen, bmpImagen ) ) ;
      WHEN        ( ::getImagenesController():isNotZoomMode() ) ;
      OF          ::oDialog

   REDEFINE IMAGE bmpImagen ;
      ID          140 ;
      FILE        cFileBmpName( ::getImagenesController():oModel:hBuffer[ "imagen" ] ) ;
      OF          ::oDialog

      bmpImagen:SetColor( , getsyscolor( 15 ) )
      bmpImagen:bLClicked   := {|| ShowImage( bmpImagen ) }
      bmpImagen:bRClicked   := {|| ShowImage( bmpImagen ) }

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

   ACTIVATE DIALOG ::oDialog CENTER

  ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS FabricantesValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS FabricantesValidator

   ::hValidators  := {  "codigo" =>    {  "required"           => "El codigo es un dato requerido",;
                                          "unique"             => "El codigo introducido ya existe"  ,;
                                          "onlyAlphanumeric"   => "EL código no puede contener caracteres especiales" } ,;
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

CLASS SQLFabricantesModel FROM SQLBaseModel

   DATA cTableName                     INIT "fabricantes"

   METHOD getColumns()

   METHOD getNombreWhereUuid( uuid )   INLINE ( ::getField( "nombre", "uuid", uuid ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLFabricantesModel


   hset( ::hColumns, "id",          {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                       "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",        {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                       "default"   => {|| win_uuidcreatestring() } }            )
   
   ::getEmpresaColumns()

   ::getTimeStampColumns()

   hset( ::hColumns, "codigo",      {  "create"    => "VARCHAR( 3 )"                            ,;
                                       "default"   => {|| space( 3 ) } }                        )

   hset( ::hColumns, "nombre",      {  "create"    => "VARCHAR( 100 )"                          ,;
                                       "default"   => {|| space( 100 ) } }                       )

   hset( ::hColumns, "pagina_web",  {  "create"    => "VARCHAR( 200 )"                          ,;
                                       "default"   => {|| space( 200 ) } }                       )

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

CLASS FabricantesRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLFabricantesModel():getTableName() ) 

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

METHOD getNombres() CLASS FabricantesRepository

   local cSentence     := "SELECT nombre FROM " + ::getTableName() + " ORDER BY nombre ASC"
   local aNombres      := ::getDatabase():selectFetchArrayOneColumn( cSentence )

   ains( aNombres, 1, "", .t. )

RETURN ( aNombres )

//---------------------------------------------------------------------------//