#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosController FROM SQLNavigatorController

   DATA oArticulosTipoController

   DATA oArticulosCategoriasController

   DATA oArticulosFamiliaController

   DATA oArticulosFabricantesController

   DATA oArticulosPreciosController

   DATA oIvaTipoController

   DATA oImpuestosEspecialesController

   DATA oTagsController

   DATA oPrimeraPropiedadController

   DATA oSegundaPropiedadController

   METHOD New()

   METHOD End()

   METHOD insertPreciosWhereArticulo()

   METHOD getPrecioCosto()        

   METHOD getPorcentajeIVA()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS ArticulosController

   ::Super:New()

   ::cTitle                            := "Artículos"

   ::cName                             := "articulos"

   ::hImage                            := {  "16" => "gc_object_cube_16",;
                                             "32" => "gc_object_cube_32",;
                                             "48" => "gc_object_cube_48" }

   ::lTransactional                    := .t.

   ::nLevel                            := Auth():Level( ::cName )

   ::oModel                            := SQLArticulosModel():New( self )

   ::oBrowseView                       := ArticulosBrowseView():New( self )

   ::oDialogView                       := ArticulosView():New( self )

   ::oValidator                        := ArticulosValidator():New( self, ::oDialogView )

   ::oRepository                       := ArticulosRepository():New( self )

   ::oTagsController                   := TagsController():New( self )

   ::oArticulosFamiliaController       := ArticulosFamiliaController():New( self )

   ::oArticulosTipoController          := ArticulosTipoController():New( self )

   ::oArticulosCategoriasController    := ArticulosCategoriasController():New( self )

   ::oArticulosFabricantesController   := ArticulosFabricantesController():New( self )

   ::oArticulosPreciosController       := ArticulosPreciosController():New( self )

   ::oIvaTipoController                := IvaTipoController():New( self )

   ::oImpuestosEspecialesController    := ImpuestosEspecialesController():New( self )

   ::oPrimeraPropiedadController       := PropiedadesController():New( self )

   ::oSegundaPropiedadController       := PropiedadesController():New( self )

   ::oFilterController:setTableToFilter( ::oModel:cTableName )

   ::oModel:setEvent( 'loadedBlankBuffer',   {|| ::insertPreciosWhereArticulo() } )

   ::oModel:setEvent( 'loadedCurrentBuffer', {|| ::insertPreciosWhereArticulo() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End() CLASS ArticulosController

   ::oModel:End()

   ::oBrowseView:End()

   ::oDialogView:End()

   ::oValidator:End()

   ::oRepository:End()

   ::oTagsController:End()

   ::oArticulosFamiliaController:End()

   ::oArticulosTipoController:End()

   ::oArticulosCategoriasController:End()

   ::oArticulosFabricantesController:End()

   ::oArticulosPreciosController:End()

   ::oIvaTipoController:End()

   ::oImpuestosEspecialesController:End()

   ::oPrimeraPropiedadController:End()

   ::oSegundaPropiedadController:End()

   ::Super:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD getPrecioCosto()

   if empty(::oModel)
      RETURN ( 0 )
   end if 

   if empty(::oModel:hBuffer)
      RETURN ( 0 )
   end if 

RETURN ( ::oModel:hBuffer[ "precio_costo" ] )

//---------------------------------------------------------------------------//

METHOD getPorcentajeIVA()

   if empty(::oModel)
      RETURN ( 0 )
   end if 

   if empty(::oModel:hBuffer)
      RETURN ( 0 )
   end if 

RETURN ( ::oIvaTipoController:oModel:getPorcentajeWhereCodigo( ::oModel:hBuffer[ "iva_tipo_uuid" ] ) )

//---------------------------------------------------------------------------//

METHOD insertPreciosWhereArticulo()

   local uuidArticulo   := hget( ::oModel:hBuffer, "uuid" )

   if empty( uuidArticulo )
      RETURN ( Self )
   end if 

   SQLArticulosPreciosModel():insertPreciosWhereArticulo( uuidArticulo )   

RETURN ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosBrowseView FROM SQLBrowseView

   METHOD addColumns()                       

ENDCLASS

//----------------------------------------------------------------------------//

METHOD addColumns() CLASS ArticulosBrowseView

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

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosView FROM SQLBaseView

   DATA oGetCodigo

   DATA oGetTipo

   DATA oGetMarcador

   DATA cGetMarcador

   DATA oBtnTags

   DATA oTagsEver      

   DATA oComboPeriodoCaducidad

   DATA oGetLoteActual

   DATA oGetPrecioCosto

   DATA oSayCodificacionProveedores
  
   METHOD Activate()

   METHOD End()

   METHOD startActivate()

   METHOD changeLote()           INLINE ( iif( ::oController:oModel:hBuffer[ "lote" ], ::oGetLoteActual:Show(), ::oGetLoteActual:Hide() ) )

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM" ;
      TITLE       ::LblTitle() + "articulo"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getimage( "48" ) ;
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
      PROMPT      "&General",;
                  "&Precios" ;
      DIALOGS     "ARTICULO_GENERAL",;
                  "ARTICULO_PRECIO"    

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

   // Familias de articulos ---------------------------------------------------

   ::oController:oArticulosFamiliaController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulos_familia_uuid" ] ) )
   ::oController:oArticulosFamiliaController:oGetSelector:Activate( 120, 121, ::oFolder:aDialogs[ 1 ] )

   // Tipos de articulos ------------------------------------------------------

   ::oController:oArticulosTipoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulos_tipo_uuid" ] ) )
   ::oController:oArticulosTipoController:oGetSelector:Activate( 130, 131, ::oFolder:aDialogs[ 1 ] )

   // Categorias de articulos--------------------------------------------------

   ::oController:oArticulosCategoriasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulos_categoria_uuid" ] ) )
   ::oController:oArticulosCategoriasController:oGetSelector:Activate( 140, 141, ::oFolder:aDialogs[ 1 ] )
   
   // Fabricantes de articulos--------------------------------------------------

   ::oController:oArticulosFabricantesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulos_fabricante_uuid" ] ) )
   ::oController:oArticulosFabricantesController:oGetSelector:Activate( 150, 151, ::oFolder:aDialogs[ 1 ] )

   // Tipo de IVA--------------------------------------------------------------

   ::oController:oIvaTipoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "iva_tipo_uuid" ] ) )
   ::oController:oIvaTipoController:oGetSelector:Activate( 160, 161, ::oFolder:aDialogs[ 1 ] )

   // Tipo de IVA--------------------------------------------------------------

   ::oController:oImpuestosEspecialesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "impuesto_especial_uuid" ] ) )
   ::oController:oImpuestosEspecialesController:oGetSelector:Activate( 170, 171, ::oFolder:aDialogs[ 1 ] )

   // Primera propiedad--------------------------------------------------------

   ::oController:oPrimeraPropiedadController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "primera_propiedad_uuid" ] ) )
   ::oController:oPrimeraPropiedadController:oGetSelector:Activate( 230, 231, ::oFolder:aDialogs[ 1 ] )

   // Segunda propiedad--------------------------------------------------------

   ::oController:oSegundaPropiedadController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "segunda_propiedad_uuid" ] ) )
   ::oController:oSegundaPropiedadController:oGetSelector:Activate( 240, 241, ::oFolder:aDialogs[ 1 ] )

   // Marcadores---------------------------------------------------------------

   ::oController:oTagsController:oDialogView:ExternalRedefine( { "idGet" => 180, "idButton" => 181, "idTags" => 182 }, ::oFolder:aDialogs[ 1 ] )

   // Obsoleto-----------------------------------------------------------------

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "obsoleto" ] ;
      ID          200 ;
      IDSAY       202 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Caducidad----------------------------------------------------------------

   REDEFINE GET   ::oController:oModel:hBuffer[ "caducidad" ] ;
      ID          190 ;
      PICTURE     "999" ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:oModel:hBuffer[ "caducidad" ] >= 0 ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE COMBOBOX ::oComboPeriodoCaducidad ;
      VAR         ::oController:oModel:hBuffer[ "periodo_caducidad" ] ;
      ITEMS       { "Dia(s)", "Mes(es)", "Año(s)" };
      ID          191 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // lote----------------------------------------------------------------

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "lote" ] ;
      ID          210 ;
      IDSAY       212 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ON CHANGE   ( ::changeLote() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetLoteActual ;
      VAR         ::oController:oModel:hBuffer[ "lote_actual" ] ;
      ID          220 ;
      IDSAY       221 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Precios -----------------------------------------------------------------

   REDEFINE GET   ::oGetPrecioCosto ;
      VAR         ::oController:oModel:hBuffer[ "precio_costo" ] ;
      ID          100 ;
      PICTURE     "@E 99999999.999999" ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[2]

   REDEFINE SAY   ::oSayCodificacionProveedores ;
      PROMPT      "Codificación de proveedores..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          110 ;
      OF          ::oFolder:aDialogs[2]

   ::oSayCodificacionProveedores:lWantClick  := .t.
   ::oSayCodificacionProveedores:OnClick     := {|| msgalert( "Codificación de proveedores..." ) }

   ::oController:oArticulosPreciosController:Activate( 130, ::oFolder:aDialogs[2] )

   // Táctil ------------------------------------------------------------------



   // Botones Articulos -------------------------------------------------------

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

   SendMessage( ::oComboPeriodoCaducidad:hWnd, 0x0153, -1, 14 )

   ::oController:oArticulosFamiliaController:oGetSelector:Start()

   ::oController:oArticulosTipoController:oGetSelector:Start()

   ::oController:oArticulosCategoriasController:oGetSelector:Start()

   ::oController:oArticulosFabricantesController:oGetSelector:Start()

   ::oController:oIvaTipoController:oGetSelector:Start()

   ::oController:oImpuestosEspecialesController:oGetSelector:Start()

   ::oController:oPrimeraPropiedadController:oGetSelector:Start()
   
   ::oController:oSegundaPropiedadController:oGetSelector:Start()

   ::oController:oTagsController:oDialogView:Start()

   ::changeLote()

   ::oGetCodigo:SetFocus()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   MSGALERT( "End" )

   if !empty( ::oController:oTagsController:oDialogView )
      ::oController:oTagsController:oDialogView:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosValidator FROM SQLCompanyValidator

   METHOD getValidators()
 
END CLASS

//---------------------------------------------------------------------------//

METHOD getValidators() CLASS ArticulosValidator

   ::hValidators  := {  "nombre" =>    {  "required"           => "El nombre es un dato requerido",;
                                          "unique"             => "El nombre introducido ya existe" },;
                        "codigo" =>    {  "required"           => "El código es un dato requerido" ,;
                                          "unique"             => "El código introducido ya existe" } }

RETURN ( ::hValidators )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS SQLArticulosModel FROM SQLCompanyModel

   DATA cTableName               INIT "Articulos"

   METHOD getColumns()

   METHOD getArticulosFamiliaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 18 ), SQLArticulosFamiliaModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosFamiliaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosFamiliaModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticulosTipoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLArticulosTipoModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosTipoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosTipoModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticulosCategoriaUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLArticulosCategoriasModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosCategoriaUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosCategoriasModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getArticulosFabricanteUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLArticulosFabricantesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setArticulosFabricanteUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLArticulosFabricantesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getIvaTipoUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 1 ), SQLIvaTiposModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setIvaTipoUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLIvaTiposModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getImpuestoEspecialAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 3 ), SQLImpuestosEspecialesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setImpuestoEspecialAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLImpuestosEspecialesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getPrimeraPropiedadUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLPropiedadesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setPrimeraPropiedadUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLPropiedadesModel():getUuidWhereCodigo( uValue ) ) )

   METHOD getSegundaPropiedadUuidAttribute( uValue ) ; 
                                 INLINE ( if( empty( uValue ), space( 20 ), SQLPropiedadesModel():getCodigoWhereUuid( uValue ) ) )

   METHOD setSegundaPropiedadUuidAttribute( uValue ) ;
                                 INLINE ( if( empty( uValue ), "", SQLPropiedadesModel():getUuidWhereCodigo( uValue ) ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD getColumns() CLASS SQLArticulosModel
   
   hset( ::hColumns, "id",                         {  "create"    => "INTEGER AUTO_INCREMENT UNIQUE"           ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "uuid",                       {  "create"    => "VARCHAR( 40 ) NOT NULL UNIQUE"           ,;
                                                      "default"   => {|| win_uuidcreatestring() } }            )

   ::getEmpresaColumns()

   hset( ::hColumns, "codigo",                     {  "create"    => "VARCHAR( 18 )"                           ,;
                                                      "default"   => {|| space( 18 ) } }                       )

   hset( ::hColumns, "nombre",                     {  "create"    => "VARCHAR( 200 )"                          ,;
                                                      "default"   => {|| space( 200 ) } }                      )

   hset( ::hColumns, "articulos_familia_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulos_tipo_uuid",        {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulos_categoria_uuid",   {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "articulos_fabricante_uuid",  {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "iva_tipo_uuid",              {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "impuesto_especial_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "obsoleto",                   {  "create"    => "BIT"                                     ,;
                                                      "default"   => {|| .f. } }                               )

   hset( ::hColumns, "caducidad",                  {  "create"    => "INTEGER"                                 ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "periodo_caducidad",          {  "create"    => "VARCHAR( 20 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "lote",                       {  "create"    => "BIT"                                     ,;
                                                      "default"   => {|| .f. } }                               )

   hset( ::hColumns, "lote_actual",                {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 20 ) } }                       )

   hset( ::hColumns, "precio_costo",               {  "create"    => "FLOAT( 16, 6 )"                          ,;
                                                      "default"   => {|| 0 } }                                 )

   hset( ::hColumns, "primera_propiedad_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   hset( ::hColumns, "segunda_propiedad_uuid",     {  "create"    => "VARCHAR( 40 )"                           ,;
                                                      "default"   => {|| space( 40 ) } }                       )

   ::getTimeStampColumns()

RETURN ( ::hColumns )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS ArticulosRepository FROM SQLBaseRepository

   METHOD getTableName()                  INLINE ( SQLArticulosModel():getTableName() ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

