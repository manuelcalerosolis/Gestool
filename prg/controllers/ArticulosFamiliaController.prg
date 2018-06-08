#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosFamiliasController FROM SQLNavigatorController

   DATA oImagenesController

   DATA oComentariosController

   DATA oPrimeraPropiedadController

   DATA oSegundaPropiedadController

   DATA oTraduccionesController

   DATA oCamposExtraValoresController

   METHOD New()

   METHOD End()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController ) CLASS ArticulosFamiliasController

   ::Super:New( oSenderController )

   ::cTitle                         := "Familia de artículos"

   ::cName                          := "articulos_familias"

   ::hImage                         := {  "16" => "gc_cubes_16",;
                                          "32" => "gc_cubes_32",;
                                          "48" => "gc_cubes_48" }

   ::nLevel                         := Auth():Level( ::cName )

   ::oModel                         := SQLArticulosFamiliaModel():New( self )

   ::oBrowseView                    := ArticulosFamiliaBrowseView():New( self )

   ::oDialogView                    := ArticulosFamiliaView():New( self )

   ::oValidator                     := ArticulosFamiliaValidator():New( self, ::oDialogView )

   ::oRepository                    := ArticulosFamiliaRepository():New( self )

   ::oPrimeraPropiedadController    := PropiedadesController():New( self )

   ::oSegundaPropiedadController    := PropiedadesController():New( self )

   ::oImagenesController            := ImagenesController():New( self )

   ::oComentariosController         := ComentariosController():New( self )

   ::oTraduccionesController        := TraduccionesController():New( self )

   ::oCamposExtraValoresController  := CamposExtraValoresController():New( self, ::oModel:cTableName )

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

METHOD End() CLASS ArticulosFamiliasController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oImagenesController:End()

   ::oComentariosController:End()

   ::oTraduccionesController:End()

   ::oCamposExtraValoresController:End()

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

   DATA oGetCodigo

   DATA oGetTipo

   DATA oGetColorRGB

   DATA oGetImagen

   DATA oBmpImagen

   DATA oGetPosicion

   DATA oCheckBoxMostrarComentario

   DATA oCheckBoxArticuloNoAcumulable   

   DATA oTreeRelaciones

   DATA uuidSelected
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD changeColorRGB() 

   METHOD changeTreeRelaciones()

   METHOD loadTreeRelaciones()

   METHOD setTreeRelaciones( uuidParent, oNode )

   METHOD getSelectedUuidTreeRelaciones()

   METHOD changeIncluirTPVTactil()

   METHOD endActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosFamiliaView

   local oSayCamposExtra  

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
      TITLE       ::LblTitle() + "familia"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage("48")  ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Familia" ;
      ID          800 ;
      FONT        getBoldFont() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General" ,;
                  "&Relaciones" ;
      DIALOGS     "FAMILIA_GENERAL" ,;
                  "FAMILIA_RELACIONES" 

   ::oFolder:aDialogs[2]:bGotFocus  := {|| ::setTreeRelaciones() }

   REDEFINE GET   ::oGetCodigo ;
      VAR         ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
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

   // Tactil-------------------------------------------------------------------

   REDEFINE CHECKBOX ::oController:oModel:hBuffer[ "incluir_tpv_tactil" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::changeIncluirTPVTactil() ) ;
      OF          ::oFolder:aDialogs[1]

   // Color-------------------------------------------------------------------

   REDEFINE GET   ::oGetColorRGB ;
      VAR         ::oController:oModel:hBuffer[ "color_rgb" ] ;
      ID          150 ;
      IDSAY       151 ;
      BITMAP      "gc_photographic_filters_16" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oGetColorRGB:setColor( ::oController:oModel:hBuffer[ "color_rgb" ], ::oController:oModel:hBuffer[ "color_rgb" ] )
   ::oGetColorRGB:bHelp := {|| ::changeColorRGB() }

   // Imagen-------------------------------------------------------------------

   REDEFINE GET   ::oGetImagen ;
      VAR         ::oController:oImagenesController:oModel:hBuffer[ "imagen" ] ;
      ID          160 ;
      IDSAY       161 ;
      BITMAP      "Folder" ;
      WHEN        ( ::oController:oImagenesController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oGetImagen:bHelp      := {|| GetBmp( ::oGetImagen, ::oBmpImagen ) }
   ::oGetImagen:bChange    := {|| ChgBmp( ::oGetImagen, ::oBmpImagen ) }

   REDEFINE IMAGE ::oBmpImagen ;
      ID          1010 ;
      FILE        cFileBmpName( ::oController:oImagenesController:oModel:hBuffer[ "imagen" ] ) ;
      OF          ::oFolder:aDialogs[1]

   ::oBmpImagen:SetColor( , getsyscolor( 15 ) )
   ::oBmpImagen:bLClicked   := {|| ShowImage( ::oBmpImagen ) }
   ::oBmpImagen:bRClicked   := {|| ShowImage( ::oBmpImagen ) }

   REDEFINE GET   ::oGetPosicion ;
      VAR         ::oController:oModel:hBuffer[ "posicion" ] ;
      ID          170 ;
      IDSAY       171 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         1 ;
      VALID       ( ::oController:oModel:hBuffer[ "posicion" ] >= 0 ) ;
      OF          ::oFolder:aDialogs[1]

   // Comentarios -----------------------------------------------------------------

   ::oController:oComentariosController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "comentario_uuid" ] ) )
   ::oController:oComentariosController:oGetSelector:Build( { "idGet" => 180, "idText" => 181, "idSay" => 182, "oDialog" => ::oFolder:aDialogs[1] } )

   REDEFINE CHECKBOX ::oCheckBoxMostrarComentario ;
      VAR         ::oController:oModel:hBuffer[ "mostrar_ventana_comentarios" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX ::oCheckBoxArticuloNoAcumulable ;
      VAR         ::oController:oModel:hBuffer[ "articulo_no_acumulable" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Relaciones --------------------------------------------------------------

   ::oTreeRelaciones                      := TTreeView():Redefine( 100, ::oFolder:aDialogs[2] )
   ::oTreeRelaciones:bItemSelectChanged   := {|| ::changeTreeRelaciones() }
   ::oTreeRelaciones:bValid               := {|| ::oController:validate( "relaciones" ) }

   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( ::endActivate() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| ::endActivate() } )
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

   ::oBmpImagen:End()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ArticulosFamiliaView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if
  
   oPanel:AddLink(   "Traducciones...",;
                     {|| ::oController:oTraduccionesController:activateDialogView() },;
                     ::oController:oTraduccionesController:getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) },;
                     ::oController:oCamposExtraValoresController:getImage( "16" ) )

RETURN ( self )

//---------------------------------------------------------------------------//


METHOD endActivate()

   if validateDialog( ::oFolder:aDialogs )

      ::uuidSelected    := ::getSelectedUuidTreeRelaciones()

      ::oDialog:end( IDOK )

   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD changeIncluirTPVTactil()

   if ::oController:oModel:hBuffer[ "incluir_tpv_tactil" ]
      ::oGetColorRGB:Show()
      ::oGetImagen:Show()
      ::oBmpImagen:Show()
      ::oGetPosicion:Show()
      ::oCheckBoxMostrarComentario:Show()
      ::oCheckBoxArticuloNoAcumulable:Show()
      ::oController:oComentariosController:oGetSelector:Show()
   else
      ::oGetColorRGB:Hide()
      ::oGetImagen:Hide()
      ::oBmpImagen:Hide()
      ::oGetPosicion:Hide()
      ::oCheckBoxMostrarComentario:Hide()
      ::oCheckBoxArticuloNoAcumulable:Hide()
      ::oController:oComentariosController:oGetSelector:Hide()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD changeColorRGB() 

   local nColorRGB   := ChooseColor()

   if !empty( nColorRGB )
      ::oGetColorRGB:setColor( nColorRGB, nColorRGB )
      ::oGetColorRGB:cText( nColorRGB )
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD changeTreeRelaciones( aItems )

   if empty( aItems )
      aItems      := ::oTreeRelaciones:aItems
   end if

   aeval( aItems, {|oItem| ::oTreeRelaciones:setCheck( oItem, .f. ),;
                           iif( len( oItem:aItems ) > 0, ::changeTreeRelaciones( oItem:aItems ), ) } )

   sysrefresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD loadTreeRelaciones( oTree, familiaUuid )

   local oNode
   local oHashList

   DEFAULT oTree        := ::oTreeRelaciones
   DEFAULT familiaUuid   := ''

   oHashList            := ::oController:oModel:getRowSetWhereFamiliaUuid( familiaUuid )

   if hb_isnil( oHashList )
      RETURN ( self )
   end if 

   while !( oHashList:Eof() )

      oNode             := oTree:Add( oHashList:fieldGet( 'nombre' ) )
      oNode:Cargo       := oHashList:fieldGet( 'uuid' )

      oHashList:Skip()

   end while

   aeval( oTree:aItems, {| oNode | ::loadTreeRelaciones( oNode, oNode:Cargo ) } )

   oNode:Expand()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setTreeRelaciones( uuidParent, aItems )

   local oItem

   DEFAULT uuidParent   := ::oController:oModel:hBuffer[ "familia_uuid" ]
   DEFAULT aItems       := ::oTreeRelaciones:aItems
   
   if empty( uuidParent )
      RETURN ( nil )
   end if 

   if empty( aItems )
      RETURN ( nil )
   end if 

   for each oItem in aItems

      if alltrim( oItem:Cargo ) == alltrim( uuidParent )
         ::oTreeRelaciones:Select( oItem )
         ::oTreeRelaciones:SetCheck( oItem, .t. )
         sysrefresh()
      end if 

      if !empty( oItem:aItems )
         ::setTreeRelaciones( uuidParent, oItem:aItems )
      end if 

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getSelectedUuidTreeRelaciones( aItems, uuidSelected )

   local oItem

   DEFAULT uuidSelected       := ""

   if empty( aItems )
      aItems                  := ::oTreeRelaciones:aItems
   end if

   for each oItem in aItems

      if ::oTreeRelaciones:GetCheck( oItem )
         uuidSelected         := oItem:Cargo
      end if

      if len( oItem:aItems ) > 0
         ::getSelectedUuidTreeRelaciones( oItem:aItems, @uuidSelected )
      end if

   next

RETURN ( uuidSelected )

//---------------------------------------------------------------------------//

METHOD startActivate()

   CursorWait()

   ::addLinksToExplorerBar()

   ::oController:oPrimeraPropiedadController:oGetSelector:Start()

   ::oController:oSegundaPropiedadController:oGetSelector:Start()

   ::oController:oComentariosController:oGetSelector:Start()

   ::loadTreeRelaciones()

   ::changeIncluirTPVTactil()

   ::oGetCodigo:setFocus()

   CursorWE()

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaValidator FROM SQLBaseValidator

   METHOD getValidators()

   METHOD sameFamily()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosFamiliaValidator

   ::hValidators  := {  "nombre" =>       {  "required"           => "El nombre es un dato requerido",;
                                             "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>       {  "required"           => "El código es un dato requerido" ,;
                                             "unique"             => "El código introducido ya existe" },;
                        "relaciones" =>   {  "samefamily"         => "Familia relacionada no puede ser la misma" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD sameFamily()

   local uuidSelected := ::oController:oDialogView:getSelectedUuidTreeRelaciones()

   if empty( uuidSelected )
      RETURN ( .t. )
   end if 

   if alltrim( ::oController:oModel:hBuffer[ "uuid" ] ) == alltrim( uuidSelected ) 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosFamiliaModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_familias"

   METHOD getColumns()

   METHOD getPrimeraPropiedadUuidAttribute( uuid ) ; 
                                 INLINE ( if( empty( uuid ), space( 18 ), SQLPropiedadesModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setPrimeraPropiedadUuidAttribute( codigo ) ;
                                 INLINE ( if( empty( codigo ), "", SQLPropiedadesModel():getUuidWhereCodigo( codigo ) ) )

   METHOD getComentarioUuidAttribute( uuid ) ; 
                                 INLINE ( if( empty( uuid ), space( 3 ), SQLComentariosModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setComentarioUuidAttribute( codigo ) ;
                                 INLINE ( if( empty( codigo ), "", SQLComentariosModel():getUuidWhereCodigo( codigo ) ) )

   METHOD setFamiliaUuidAttribute( value )

   METHOD getRowSetWhereFamiliaUuid( uuid )                                 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosFamiliaModel
   
   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                         "default"   => {|| win_uuidcreatestring() } }            )

   hset( ::hColumns, "familia_uuid",                  {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "codigo",                        {  "create"    => "VARCHAR( 20 )"                           ,;
                                                         "default"   => {|| space( 20 ) } }                       )

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
                                                         "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "comentario_uuid",               {  "create"    => "VARCHAR( 40 )"                           ,;
                                                         "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulo_no_acumulable",        {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

   hset( ::hColumns, "mostrar_ventana_comentarios",   {  "create"    => "BIT"                                     ,;
                                                         "default"   => {|| .f. } }                               )

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD setFamiliaUuidAttribute( value )

   if empty( ::oController )
      RETURN ( value )
   end if 

   if empty( ::oController:oDialogView )
      RETURN ( value )
   end if 

RETURN ( ::oController:oDialogView:uuidSelected )

//---------------------------------------------------------------------------//

METHOD getRowSetWhereFamiliaUuid( familiaUuid )

   local cSQL      
   local oHashList

   cSQL                 := "SELECT uuid, nombre FROM " + ::cTableName            + " "
   cSQL                 +=    "WHERE familia_uuid = " + quoted( familiaUuid )    + " "
   cSQL                 +=    "AND empresa_codigo = " + quoted( Company():Codigo() ) + " " 

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
//---------------------------------------------------------------------------//

CLASS ArticulosFamiliaRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosFamiliaModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//