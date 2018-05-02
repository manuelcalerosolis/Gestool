#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaController FROM SQLNavigatorController

   DATA oImagenesController

   DATA oComentariosController

   DATA oGetSelector

   METHOD New()

   METHOD End()

   METHOD ImagenesControllerLoadCurrentBuffer()

   METHOD ImagenesControllerUpdateBuffer()

   METHOD ImagenesControllerDeleteBuffer()

   METHOD ImagenesControllerLoadedDuplicateCurrentBuffer()

   METHOD ImagenesControllerLoadedDuplicateBuffer()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosFamiliaController

   ::Super:New()

   ::cTitle                      := "Familia de artículos"

   ::cName                       := "articulos_familia"

   ::hImage                      := {  "16" => "gc_object_cube_16",;
                                       "32" => "gc_object_cube_32",;
                                       "48" => "gc_object_cube_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLArticulosFamiliaModel():New( self )

   ::oBrowseView                 := ArticulosFamiliaBrowseView():New( self )

   ::oDialogView                 := ArticulosFamiliaView():New( self )

   ::oValidator                  := ArticulosFamiliaValidator():New( self, ::oDialogView )

   ::oRepository                 := ArticulosFamiliaRepository():New( self )

   ::oImagenesController         := ImagenesController():New( self )

   ::oComentariosController      := ComentariosController():New( self )
   /*::oArticulosTipoController:oGetSelector:setKey( "codigo" )
   ::oArticulosTipoController:oGetSelector:setView( ::oDialogView )*/

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',            {|| ::oImagenesController:oModel:loadBlankBuffer() } )
   ::oModel:setEvent( 'insertedBuffer',               {|| ::oImagenesController:oModel:insertBuffer() } )
   
   ::oModel:setEvent( 'loadedCurrentBuffer',          {|| ::ImagenesControllerLoadCurrentBuffer() } )
   ::oModel:setEvent( 'updatedBuffer',                {|| ::ImagenesControllerUpdateBuffer() } )

   ::oModel:setEvent( 'loadedDuplicateCurrentBuffer', {|| ::ImagenesControllerLoadedDuplicateCurrentBuffer() } )
   ::oModel:setEvent( 'loadedDuplicateBuffer',        {|| ::ImagenesControllerLoadedDuplicateBuffer() } )
   
   ::oModel:setEvent( 'deletedSelection',             {|| ::ImagenesControllerDeleteBuffer() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosFamiliaController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oImagenesController:End()

   ::oComentariosController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadCurrentBuffer()

   local idImagen     
   local uuidFamilia    := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidFamilia )
      ::oImagenesController:oModel:insertBuffer()
   end if 

   idImagen                := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFamilia )
   if empty( idImagen )
      ::oImagenesController:oModel:loadBlankBuffer()
      idImagen             := ::oImagenesController:oModel:insertBuffer()
   end if 

   ::oImagenesController:oModel:loadCurrentBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerUpdateBuffer()

   local idImagen     
   local uuidFamilia     := hget( ::oModel:hBuffer, "uuid" )

   idImagen                := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFamilia )
   if empty( idImagen )
      ::oImagenesController:oModel:loadBlankBuffer()
      idImagen             := ::oImagenesController:oModel:insertBuffer()
      RETURN ( self )
   end if 
   ::oImagenesController:oModel:updateBuffer()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerDeleteBuffer()

   local aUuidFamilia   := ::getUuidFromRecno( ::oBrowseView:getBrowse():aSelected )

   if empty( aUuidFamilia )
      RETURN ( self )
   end if

   ::oImagenesController:oModel:deleteWhereParentUuid( aUuidFamilia )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadedDuplicateCurrentBuffer()

   local uuidFamilia
   local idImagen     

   uuidFamilia       := hget( ::oModel:hBuffer, "uuid" )

   idImagen             := ::oImagenesController:oModel:getIdWhereParentUuid( uuidFamilia )
   if empty( idImagen )
      ::oImagenesController:oModel:insertBuffer()
      RETURN ( self )
   end if 

   ::oImagenesController:oModel:loadDuplicateBuffer( idImagen )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ImagenesControllerLoadedDuplicateBuffer()

   local uuidFamilia   := hget( ::oModel:hBuffer, "uuid" )

   hset( ::oImagenesController:oModel:hBuffer, "parent_uuid", uuidFamilia )

RETURN ( self )


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosFamiliaBrowseView

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'id'
      :cHeader             := 'Id'
      :nWidth              := 60
      :bEditValue          := {|| ::getRowSet():fieldGet( 'id' ) }
      :bLClickHeader       := {| row, col, flags, oColumn | ::onClickHeader( oColumn ) }
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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaView FROM SQLBaseView

   DATA oGetTipo
  
   METHOD Activate()

   METHOD startActivate()

   METHOD getImagenesController()   INLINE ( ::oController:oImagenesController )

   METHOD getComentariosController()   INLINE ( ::oController:oComentariosController )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosFamiliaView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM" ;
      TITLE       ::LblTitle() + "familia"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_object_cube_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Artículos" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General";
      DIALOGS     "FAMILIA_GENERAL",;
                  "FAMILIA_RELACIONES",;
                  "FAMILIA_LENGUAJE_SQL"

   REDEFINE GET   ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     ( replicate( 'N', 18 ) ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "propiedad1" ] ;
      ID          120 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "propiedad2" ] ;
      ID          130 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "incluir_tpv_tactil" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "color_boton" ] ;
      ID          150 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oImagenesController:oModel:hBuffer[ "imagen" ] ;
      ID          1010 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "FOLDER" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "posicion" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         1;
      OF          ::oFolder:aDialogs[1]
/*
   REDEFINE GET   ::oController:oComentariosController:oModel:hBuffer[ "comentario" ] ;
      ID          1020 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      BITMAP      "LUPA" ;
      OF          ::oFolder:aDialogs[1]
*/
   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "articulo_no_acumulable" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "mostrar_ventana_comentarios" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oController:oArticulosFamiliaController:oGetSelector:Activate( 130, 131, ::oFolder:aDialogs[ 1 ] )

   // Botones Familia -------------------------------------------------------

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

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate()

   ::oController:oArticulosFamiliaController:oGetSelector:Start()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaValidator FROM SQLBaseValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosFamiliaValidator

   ::hValidators  := {  "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "El código introducido ya existe",;
                                          "onlyAlphanumeric"   => "El código no puede contener caracteres especiales" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosFamiliaModel FROM SQLBaseModel

   DATA cTableName               INIT "articulos_familia"

   METHOD getColumns()

   /*METHOD getArticulosTipoUuidAttribute()

   METHOD setArticulosTipoUuidAttribute()*/

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosFamiliaModel
   
   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 ) NOT NULL"                  ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",                        {  "create"    => "VARCHAR( 18 )"                           ,;
                                                         "default"   => {|| space( 18 ) } }                       )

   hset( ::hColumns, "nombre",                        {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "propiedad1",                    {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "propiedad2",                    {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "incluir_tpv_tactil",            {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

   hset( ::hColumns, "color_boton",                   {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "posicion",                      {  "create"    => "INTEGER( 5 )"                            ,;
                                                         "default"   => {|| space( 5 ) } }                        )

   hset( ::hColumns, "articulo_no_acumulable",        {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

   hset( ::hColumns, "mostrar_ventana_comentarios",   {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )


   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

/*METHOD getArticulosTipoUuidAttribute( uValue ) CLASS SQLArticulosModel

   if empty( uValue )
      RETURN ( space( 3 ) )
   end if 

RETURN ( ArticulosTipoRepository():getCodigoWhereUuid( uValue ) )

//---------------------------------------------------------------------------//

METHOD setArticulosTipoUuidAttribute( uValue ) CLASS SQLArticulosModel

   if empty( uValue )
      RETURN ( uValue )
   end if 

RETURN ( ArticulosTipoRepository():getUuidWhereCodigo( uValue ) )*/

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

