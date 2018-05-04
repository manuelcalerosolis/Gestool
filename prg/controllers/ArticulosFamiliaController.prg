#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaController FROM SQLNavigatorController

   DATA oImagenesController

   DATA oComentariosController

   DATA oPrimeraPropiedadController

   DATA oSegundaPropiedadController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosFamiliaController

   ::Super:New()

   ::cTitle                      := "Familia de art�culos"

   ::cName                       := "articulos_familia"

   ::hImage                      := {  "16" => "gc_cubes_16",;
                                       "32" => "gc_cubes_32",;
                                       "48" => "gc_cubes_48" }

   ::nLevel                      := Auth():Level( ::cName )

   ::oModel                      := SQLArticulosFamiliaModel():New( self )

   ::oBrowseView                 := ArticulosFamiliaBrowseView():New( self )

   ::oDialogView                 := ArticulosFamiliaView():New( self )

   ::oValidator                  := ArticulosFamiliaValidator():New( self, ::oDialogView )

   ::oRepository                 := ArticulosFamiliaRepository():New( self )

   ::oPrimeraPropiedadController := PropiedadesController():New( self )

   ::oSegundaPropiedadController := PropiedadesController():New( self )

   ::oImagenesController         := ImagenesController():New( self )

   ::oComentariosController      := ComentariosController():New( self )

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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaView FROM SQLBaseView

   DATA oGetCodigo

   DATA oGetTipo

   DATA oColorRGB

   DATA oTreeRelaciones
  
   METHOD Activate()

   METHOD startActivate()

   METHOD changeColorRGB() 

   METHOD changeTreeRelaciones()

   METHOD loadTreeRelaciones()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosFamiliaView

   local oBmpImagen
   local oGetImagen

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM" ;
      TITLE       ::LblTitle() + "familia"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    "gc_object_cube_48" ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Art�culos" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ,;
                  "&Relaciones" ,;
                  "&Lenguaje" ;
      DIALOGS     "FAMILIA_GENERAL" ,;
                  "FAMILIA_RELACIONES" ,;
                  "FAMILIA_LENGUAJE_SQL"

   REDEFINE GET   ::oGetCodigo ;
      VAR         ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   // Primera propiedad -------------------------------------------------------

   ::oController:oPrimeraPropiedadController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "primera_propiedad_uuid" ] ) )
   ::oController:oPrimeraPropiedadController:oGetSelector:Activate( 120, 121, ::oFolder:aDialogs[ 1 ] )

   // Segunda propiedad -------------------------------------------------------

   ::oController:oSegundaPropiedadController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "segunda_propiedad_uuid" ] ) )
   ::oController:oSegundaPropiedadController:oGetSelector:Activate( 130, 131, ::oFolder:aDialogs[ 1 ] )

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "incluir_tpv_tactil" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Color-------------------------------------------------------------------

   REDEFINE GET   ::oColorRGB ;
      VAR         ::oController:oModel:hBuffer[ "color_rgb" ] ;
      ID          150 ;
      BITMAP      "gc_photographic_filters_16" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oColorRGB:setColor( ::oController:oModel:hBuffer[ "color_rgb" ], ::oController:oModel:hBuffer[ "color_rgb" ] )
   ::oColorRGB:bHelp := {|| ::changeColorRGB() }

   // Imagen-------------------------------------------------------------------

   REDEFINE GET   oGetImagen ;
      VAR         ::oController:oImagenesController:oModel:hBuffer[ "imagen" ] ;
      ID          160 ;
      BITMAP      "Folder" ;
      ON HELP     ( GetBmp( oGetImagen, oBmpImagen ) ) ;
      ON CHANGE   ( ChgBmp( oGetImagen, oBmpImagen ) ) ;
      WHEN        ( ::oController:oImagenesController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE IMAGE oBmpImagen ;
      ID          1010 ;
      FILE        cFileBmpName( ::oController:oImagenesController:oModel:hBuffer[ "imagen" ] ) ;
      OF          ::oFolder:aDialogs[1]

   oBmpImagen:SetColor( , getsyscolor( 15 ) )
   oBmpImagen:bLClicked   := {|| ShowImage( oBmpImagen ) }
   oBmpImagen:bRClicked   := {|| ShowImage( oBmpImagen ) }

   REDEFINE GET   ::oController:oModel:hBuffer[ "posicion" ] ;
      ID          170 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         1 ;
      VALID       ( ::oController:oModel:hBuffer[ "posicion" ] > 0 ) ;
      OF          ::oFolder:aDialogs[1]

   // Comentarios -----------------------------------------------------------------

   ::oController:oComentariosController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "comentario_uuid" ] ) )
   ::oController:oComentariosController:oGetSelector:Activate( 180, 181, ::oFolder:aDialogs[1] )

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "mostrar_ventana_comentarios" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX   ::oController:oModel:hBuffer[ "articulo_no_acumulable" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Relaciones --------------------------------------------------------------

   ::oTreeRelaciones                     := TTreeView():Redefine( 100, ::oFolder:aDialogs[2] )
   ::oTreeRelaciones:bItemSelectChanged  := {|| ::changeTreeRelaciones() }

   // Botones -----------------------------------------------------------------

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

   oBmpImagen:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD changeColorRGB() 

   local nColorRGB   := ChooseColor()

   if !empty( nColorRGB )
      ::oColorRGB:setColor( nColorRGB, nColorRGB )
      ::oColorRGB:cText( nColorRGB )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD changeTreeRelaciones()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD loadTreeRelaciones( oNode, parentUuid )

   local oHashList

   DEFAULT oNode        := ::oTreeRelaciones
   DEFAULT parentUuid   := ''

   oHashList            := ::oController:oModel:getRowSetWhereParentUuid( parentUuid )

   if hb_isnil( oHashList )
      RETURN ( self )
   end if 

   while !( oHashList:Eof() )

      oNode             := oNode:Add( oHashList:fieldGet( 'nombre' ) )
      oNode:Cargo       := oHashList:fieldGet( 'uuid' )

      ::loadTreeRelaciones( oNode, oNode:Cargo )

      oHashList:Skip()

   end while

   oNode:Expand()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD startActivate()

   CursorWait()

   ::oController:oPrimeraPropiedadController:oGetSelector:Start()

   ::oController:oSegundaPropiedadController:oGetSelector:Start()

   ::oController:oComentariosController:oGetSelector:Start()

   ::loadTreeRelaciones()

   ::oGetCodigo:setFocus()

   CursorWE()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosFamiliaValidator

   ::hValidators  := {  "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"           => "El c�digo es un dato requerido" ,;
                                          "unique"             => "El c�digo introducido ya existe" } }
RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosFamiliaModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_familia"

   METHOD getColumns()

   METHOD getPrimeraPropiedadUuidAttribute( uuid ) ; 
                                 INLINE ( if( empty( uuid ), space( 18 ), SQLPropiedadesModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setPrimeraPropiedadUuidAttribute( codigo ) ;
                                 INLINE ( if( empty( codigo ), "", SQLPropiedadesModel():getUuidWhereCodigo( codigo ) ) )

   METHOD getComentarioUuidAttribute( uuid ) ; 
                                 INLINE ( if( empty( uuid ), space( 3 ), SQLComentariosModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setComentarioUuidAttribute( codigo ) ;
                                 INLINE ( if( empty( codigo ), "", SQLComentariosModel():getUuidWhereCodigo( codigo ) ) )

   METHOD getRowSetWhereParentUuid( uuid )                                 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosFamiliaModel
   
   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "parent_uuid",                   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",                        {  "create"    => "VARCHAR( 18 )"                           ,;
                                                         "default"   => {|| space( 18 ) } }                       )

   hset( ::hColumns, "nombre",                        {  "create"    => "VARCHAR( 200 )"                          ,;
                                                         "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "primera_propiedad_uuid",        {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "segunda_propiedad_uuid",        {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "incluir_tpv_tactil",            {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

   hset( ::hColumns, "color_rgb",                     {  "create"    => "INT UNSIGNED"                            ,;
                                                         "default"   => {|| rgb( 255, 255, 255 ) } }              )

   hset( ::hColumns, "posicion",                      {  "create"    => "INTEGER( 5 )"                            ,;
                                                         "default"   => {|| space( 5 ) } }                        )

   hset( ::hColumns, "comentario_uuid",               {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_no_acumulable",        {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

   hset( ::hColumns, "mostrar_ventana_comentarios",   {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD getRowSetWhereParentUuid( parentUuid )

   local cSQL      
   local oHashList

   cSQL                 := "SELECT uuid, nombre FROM " + ::cTableName + " "
   cSQL                 +=    "WHERE parent_uuid = " + quoted( parentUuid )

   oHashList            := getSQLDatabase():selectHashList( cSQL ) 

   if hb_isnil( oHashList )
      RETURN ( nil )
   end if 

   oHashList:goTop()

RETURN ( oHashList )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosFamiliaModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//