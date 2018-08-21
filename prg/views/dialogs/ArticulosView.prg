#include "FiveWin.Ch"
#include "Factu.ch" 

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

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD changeLote()           INLINE ( iif( ::oController:oModel:hBuffer[ "lote" ], ::oGetLoteActual:Show(), ::oGetLoteActual:Hide() ) )

   METHOD changeNombre()         INLINE ( ::oMessage:setText( "Artículo : " + alltrim( ::oController:oModel:hBuffer[ "nombre" ] ) ) ) 

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosView

   local oGetNombre

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "CONTAINER_MEDIUM_EXTENDED" ;
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

   ::redefineExplorerBar()

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
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]
      
   oGetNombre:bChange   := {|| ::changeNombre() }

   // Familias de articulos ---------------------------------------------------

   ::oController:oArticulosFamiliasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_familia_codigo" ] ) )
   ::oController:oArticulosFamiliasController:oGetSelector:Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oFolder:aDialogs[1] } )

   // Tipos de articulos ------------------------------------------------------

   ::oController:oArticulosTipoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_tipo_codigo" ] ) )
   ::oController:oArticulosTipoController:oGetSelector:Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )

   // Categorias de articulos--------------------------------------------------

   ::oController:oArticulosCategoriasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_categoria_codigo" ] ) )
   ::oController:oArticulosCategoriasController:oGetSelector:Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )
   
   // Fabricantes de articulos--------------------------------------------------

   ::oController:oArticulosFabricantesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_fabricante_codigo" ] ) )
   ::oController:oArticulosFabricantesController:oGetSelector:Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[1] } )

   // Tipo de IVA--------------------------------------------------------------

   ::oController:oTipoIvaController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tipo_iva_codigo" ] ) )
   ::oController:oTipoIvaController:oGetSelector:Build( { "idGet" => 160, "idText" => 161, "idLink" => 162, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:oTipoIvaController:oGetSelector:bValid  := {|| ::oController:validateTipoIVA() }

   // Impuestos especiales-----------------------------------------------------

   ::oController:oImpuestosEspecialesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "impuesto_especial_codigo" ] ) )
   ::oController:oImpuestosEspecialesController:oGetSelector:Build( { "idGet" => 170, "idText" => 171, "idLink" => 172, "oDialog" => ::oFolder:aDialogs[1] } )

   // Unidades de medicion grupo-----------------------------------------------

   with object ( ::oController:oUnidadesMedicionGruposController:oGetSelector )
      :Bind( bSETGET( ::oController:oModel:hBuffer[ "unidades_medicion_grupos_codigo" ] ) )
      :Build( { "idGet" => 230, "idText" => 231, "idLink" => 232, "oDialog" => ::oFolder:aDialogs[1] } )
      :setWhen( {|| ::oController:isNotZoomMode() .and. SQLUnidadesMedicionOperacionesModel():getNumeroOperacionesWhereArticulo( ::oController:getModelBuffer( "codigo" ) ) == 0 } )
   end with

   // Temporadas---------------------------------------------------------------

   ::oController:oArticulosTemporadasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_temporada_codigo" ] ) )
   ::oController:oArticulosTemporadasController:oGetSelector:Build( { "idGet" => 250, "idText" => 251, "idLink" => 252, "oDialog" => ::oFolder:aDialogs[1] } )

   // Marcadores---------------------------------------------------------------

   ::oController:oTagsController:oDialogView:ExternalRedefine( { "idGet" => 180, "idButton" => 181, "idTags" => 183 }, ::oFolder:aDialogs[ 1 ] )

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
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validatePrecioCosto() ) ;
      OF          ::oFolder:aDialogs[2]

   ::oController:oArticulosPreciosController:Activate( 130, ::oFolder:aDialogs[2] )

   // Botones artículos -------------------------------------------------------

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

   ::oController:oArticulosPreciosController:saveState()

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ArticulosView

   SendMessage( ::oComboPeriodoCaducidad:hWnd, 0x0153, -1, 14 )

   ::addLinksToExplorerBar()

   ::oController:oArticulosFamiliasController:oGetSelector:Start()

   ::oController:oArticulosTipoController:oGetSelector:Start()

   ::oController:oArticulosCategoriasController:oGetSelector:Start()

   ::oController:oArticulosFabricantesController:oGetSelector:Start()

   ::oController:oTipoIvaController:oGetSelector:Start()

   ::oController:oImpuestosEspecialesController:oGetSelector:Start()

   ::oController:oUnidadesMedicionGruposController:oGetSelector:Start()
   
   ::oController:oArticulosTemporadasController:oGetSelector:Start()

   ::oController:oTagsController:oDialogView:Start()

   ::oController:oArticulosFamiliasController:oGetSelector:Start()

   ::changeNombre()

   ::changeLote()

   ::oGetCodigo:SetFocus()

   ::oController:oCombinacionesController:oGetSelector:Start()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ArticulosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if

   oPanel:AddLink(   "Combinaciones...",;
                     {||   ::oController:oCombinacionesController:runViewGenerate() },;
                           ::oController:oCombinacionesController:getImage( "16" ) )

   oPanel:AddLink(   "Codificación de proveedores...",;
                     {||   msgalert( "to-do" ) },;
                           ::oController:oArticulosUnidadesMedicionController:getImage( "16" ) )
 
   oPanel:AddLink(   "Imagenes...",;
                     {||   ::oController:oImagenesController:activateDialogView() },;
                           ::oController:oImagenesController:getImage( "16" ) )

   oPanel:AddLink(   "Traducciones...",;
                     {||   ::oController:oTraduccionesController:activateDialogView() },;
                           ::oController:oTraduccionesController:getImage( "16" ) )

   oPanel:AddLink(   "Unidad por operación...",;
                     {||   ::oController:oUnidadesMedicionOperacionesController:activateDialogView(),;
                           ::oController:oUnidadesMedicionGruposController:oGetSelector:evalWhen() },;
                           ::oController:ounidadesmedicionoperacionesController:getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {||   ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) },;
                           ::oController:oCamposExtraValoresController:getImage( "16" ) )

RETURN ( nil )


//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
