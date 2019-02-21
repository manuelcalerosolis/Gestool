#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosFamiliasController FROM SQLNavigatorController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getBrowseView()           INLINE( if( empty( ::oBrowseView ), ::oBrowseView := ArticulosFamiliaBrowseView():New( self ), ), ::oBrowseView ) 

   METHOD getDialogView()           INLINE( if( empty( ::oDialogView ), ::oDialogView := ArticulosFamiliaView():New( self ), ), ::oDialogView )

   METHOD getValidator()            INLINE( if( empty( ::oValidator ), ::oValidator := ArticulosFamiliaValidator():New( self ), ), ::oValidator )

   METHOD getRepository()           INLINE ( if( empty( ::oRepository ), ::oRepository := ArticulosFamiliaRepository():New( self ), ), ::oRepository )

   METHOD getModel()                INLINE ( if( empty( ::oModel ), ::oModel := SQLArticulosFamiliaModel():New( self ), ), ::oModel )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController ) CLASS ArticulosFamiliasController

   ::Super:New( oController )

   ::cTitle                         := "Familia de art�culos"

   ::cName                          := "articulos_familias"

   ::hImage                         := {  "16" => "gc_cubes_16",;
                                          "32" => "gc_cubes_32",;
                                          "48" => "gc_cubes_48" }

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

METHOD End() CLASS ArticulosFamiliasController

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

   if !empty( ::oGetSelector )
      ::oGetSelector:End()
   end if                 

RETURN ( ::Super:End() )

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

   ::getColumnIdAndUuid()

   with object ( ::oBrowse:AddCol() )
      :cSortOrder          := 'codigo'
      :cHeader             := 'C�digo'
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

   ::getColumnDeletedAt()

RETURN ( nil )

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
      FONT        oFontBold() ;
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
      VAR         ::oController:getModel():hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:getModel():hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   // Tactil-------------------------------------------------------------------

   REDEFINE CHECKBOX ::oController:getModel():hBuffer[ "incluir_tpv_tactil" ] ;
      ID          140 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::changeIncluirTPVTactil() ) ;
      OF          ::oFolder:aDialogs[1]

   // Color-------------------------------------------------------------------

   REDEFINE GET   ::oGetColorRGB ;
      VAR         ::oController:getModel():hBuffer[ "color_rgb" ] ;
      ID          150 ;
      IDSAY       151 ;
      BITMAP      "gc_photographic_filters_16" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oGetColorRGB:setColor( ::oController:getModel():hBuffer[ "color_rgb" ], ::oController:getModel():hBuffer[ "color_rgb" ] )
   ::oGetColorRGB:bHelp := {|| ::changeColorRGB() }

   // Imagen-------------------------------------------------------------------

   REDEFINE GET   ::oGetImagen ;
      VAR         ::oController:getImagenesController():getModel():hBuffer[ "imagen" ] ;
      ID          160 ;
      IDSAY       161 ;
      BITMAP      "Folder" ;
      WHEN        ( ::oController:getImagenesController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oGetImagen:bHelp      := {|| GetBmp( ::oGetImagen, ::oBmpImagen ) }
   ::oGetImagen:bChange    := {|| ChgBmp( ::oGetImagen, ::oBmpImagen ) }

   REDEFINE IMAGE ::oBmpImagen ;
      ID          1010 ;
      FILE        cFileBmpName( ::oController:getImagenesController():getModel():hBuffer[ "imagen" ] ) ;
      OF          ::oFolder:aDialogs[1]

   ::oBmpImagen:SetColor( , getsyscolor( 15 ) )
   ::oBmpImagen:bLClicked   := {|| ShowImage( ::oBmpImagen ) }
   ::oBmpImagen:bRClicked   := {|| ShowImage( ::oBmpImagen ) }

   REDEFINE GET   ::oGetPosicion ;
      VAR         ::oController:getModel():hBuffer[ "posicion" ] ;
      ID          170 ;
      IDSAY       171 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      SPINNER ;
      MIN         1 ;
      VALID       ( ::oController:getModel():hBuffer[ "posicion" ] >= 0 ) ;
      OF          ::oFolder:aDialogs[1]

   // Comentarios -----------------------------------------------------------------

   ::oController:getComentariosController():getSelector():Bind( bSETGET( ::oController:getModel():hBuffer[ "comentario_uuid" ] ) )
   ::oController:getComentariosController():getSelector():Build( { "idGet" => 180, "idText" => 181, "idLink" => 182, "oDialog" => ::oFolder:aDialogs[1] } )

   REDEFINE CHECKBOX ::oCheckBoxMostrarComentario ;
      VAR         ::oController:getModel():hBuffer[ "mostrar_ventana_comentarios" ] ;
      ID          190 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE CHECKBOX ::oCheckBoxArticuloNoAcumulable ;
      VAR         ::oController:getModel():hBuffer[ "articulo_no_acumulable" ] ;
      ID          200 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Relaciones --------------------------------------------------------------

   ::oTreeRelaciones                      := TTreeView():Redefine( 100, ::oFolder:aDialogs[2] )
   ::oTreeRelaciones:bItemSelectChanged   := {|| ::changeTreeRelaciones() }
   ::oTreeRelaciones:bValid               := {|| ::oController:validate( "relaciones" ) }

   // Botones -----------------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
      ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5 .and. validateDialog( ::oDialog ), ::oDialog:end( IDOK ), ) }
   end if

   ::oDialog:bStart  := {|| ::startActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ArticulosFamiliaView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if
  
   oPanel:AddLink(   "Traducciones...",;
                     {|| ::oController:getTraduccionesController():activateDialogView() },;
                     ::oController:getTraduccionesController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                     ::oController:getCamposExtraValoresController():getImage( "16" ) )

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

   if ::oController:getModel():hBuffer[ "incluir_tpv_tactil" ]
      ::oGetColorRGB:Show()
      ::oGetImagen:Show()
      ::oBmpImagen:Show()
      ::oGetPosicion:Show()
      ::oCheckBoxMostrarComentario:Show()
      ::oCheckBoxArticuloNoAcumulable:Show()
      ::oController:getComentariosController():getSelector():Show()
   else
      ::oGetColorRGB:Hide()
      ::oGetImagen:Hide()
      ::oBmpImagen:Hide()
      ::oGetPosicion:Hide()
      ::oCheckBoxMostrarComentario:Hide()
      ::oCheckBoxArticuloNoAcumulable:Hide()
      ::oController:getComentariosController():getSelector():Hide()
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

   oHashList            := ::oController:getModel():getRowSetWhereFamiliaUuid( familiaUuid )

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

   DEFAULT uuidParent   := ::oController:getModel():hBuffer[ "familia_uuid" ]
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

   ::oController:getComentariosController():getSelector():Start()

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
                        "codigo" =>       {  "required"           => "El c�digo es un dato requerido" ,;
                                             "unique"             => "El c�digo introducido ya existe" },;
                        "relaciones" =>   {  "samefamily"         => "Familia relacionada no puede ser la misma" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//

METHOD sameFamily()

   local uuidSelected := ::oController:getDialogView():getSelectedUuidTreeRelaciones()

   if empty( uuidSelected )
      RETURN ( .t. )
   end if 

   if alltrim( ::oController:getModel():hBuffer[ "uuid" ] ) == alltrim( uuidSelected ) 
      RETURN ( .f. )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosFamiliaModel FROM SQLCompanyModel

   DATA cTableName               INIT "articulos_familias"

   DATA cConstraints             INIT "PRIMARY KEY ( codigo, deleted_at )"

   METHOD getColumns()

   /*METHOD getPrimeraPropiedadUuidAttribute( uuid ) ; 
                                 INLINE ( if( empty( uuid ), space( 18 ), SQLPropiedadesModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setPrimeraPropiedadUuidAttribute( codigo ) ;
                                 INLINE ( if( empty( codigo ), "", SQLPropiedadesModel():getUuidWhereCodigo( codigo ) ) )

   METHOD getComentarioUuidAttribute( uuid ) ; 
                                 INLINE ( if( empty( uuid ), space( 3 ), SQLComentariosModel():getCodigoWhereUuid( uuid ) ) )

   METHOD setComentarioUuidAttribute( codigo ) ;
                                 INLINE ( if( empty( codigo ), "", SQLComentariosModel():getUuidWhereCodigo( codigo ) ) )*/

   METHOD setFamiliaUuidAttribute( value )

   METHOD getRowSetWhereFamiliaUuid( uuid )                                 

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosFamiliaModel
   
   hset( ::hColumns, "id",                            {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"              ,;
                                                         "text"      => "Identificador"                              ,;
                                                         "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "uuid",                          {  "create"    => "VARCHAR ( 40 ) NOT NULL UNIQUE"             ,;
                                                         "default"   => {|| win_uuidcreatestring() } }               )

   hset( ::hColumns, "familia_uuid",                  {  "create"    => "VARCHAR ( 40 )"                             ,;
                                                         "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "codigo",                        {  "create"    => "VARCHAR ( 20 )"                             ,;
                                                         "text"      => "C�digo"                                     ,;
                                                         "default"   => {|| space( 20 ) } }                          )

   hset( ::hColumns, "nombre",                        {  "create"    => "VARCHAR ( 200 )"                            ,;
                                                         "text"      => "Nombre"                                     ,;
                                                         "default"   => {|| space( 200 ) } }                         )

   hset( ::hColumns, "incluir_tpv_tactil",            {  "create"    => "TINYINT ( 1 )"                              ,;
                                                         "text"      => "Incluir en t�ctil"                          ,;
                                                         "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "color_rgb",                     {  "create"    => "INT UNSIGNED"                               ,;
                                                         "text"      => "Color RGB"                                  ,;
                                                         "default"   => {|| rgb( 255, 255, 255 ) } }                 )

   hset( ::hColumns, "posicion",                      {  "create"    => "INTEGER ( 5 )"                              ,;
                                                         "text"      => "Posici�n"                                   ,;
                                                         "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "comentario_uuid",               {  "create"    => "VARCHAR ( 40 )"                             ,;
                                                         "default"   => {|| space( 40 ) } }                          )

   hset( ::hColumns, "articulo_no_acumulable",        {  "create"    => "TINYINT ( 1 )"                              ,;
                                                         "text"      => "Familia no acumulable"                      ,;
                                                         "default"   => {|| 0 } }                                    )

   hset( ::hColumns, "mostrar_ventana_comentarios",   {  "create"    => "TINYINT ( 1 )"                              ,;
                                                         "text"      => "Mostrar comentarios"                        ,;
                                                         "default"   => {|| 0 } }                                    )

   ::getDeletedStampColumn()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//

METHOD setFamiliaUuidAttribute( value )

   if empty( ::oController )
      RETURN ( value )
   end if 

   if empty( ::oController:getDialogView() )
      RETURN ( value )
   end if 

RETURN ( ::oController:getDialogView():uuidSelected )

//---------------------------------------------------------------------------//

METHOD getRowSetWhereFamiliaUuid( familiaUuid )

   local cSQL      
   local oHashList

   TEXT INTO cSql

      SELECT uuid, nombre 

      FROM %1$s 

      WHERE familia_uuid = %2$s

   ENDTEXT

   cSql  := hb_strformat( cSql, ::getTableName(), quoted( familiaUuid ) )

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