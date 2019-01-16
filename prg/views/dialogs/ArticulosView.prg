#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS ArticulosView FROM SQLBaseView

   DATA oGetCodigo

   DATA oGetNombre

   DATA oGetTipo

   DATA oGetMarcador

   DATA cGetMarcador

   DATA oBtnTags

   DATA oBtnAceptar

   DATA oBtnCancelar

   DATA oTagsEver      

   DATA oComboPeriodoCaducidad

   DATA oGetLoteActual

   DATA oGetPrecioCosto

   DATA oSayCodificacionProveedores
  
   METHOD Activate()

   METHOD startActivate()

   METHOD addLinksToExplorerBar()

   METHOD changeFolder( nOption )      INLINE ( iif( nOption > 1, ::oController:insertOrUpdateBuffer(), ) )

   METHOD changeLote()                 INLINE ( iif( ::oController:oModel:hBuffer[ "lote" ], ::oGetLoteActual:Show(), ::oGetLoteActual:Hide() ) )

   METHOD changeNombre()               INLINE ( ::oMessage:setText( "Artículo : " + alltrim( ::oController:oModel:hBuffer[ "nombre" ] ) ) ) 

   METHOD editUnidadesMedicionOperaciones()

END CLASS

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD Activate() CLASS ArticulosView

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
      FONT        oFontBold() ;
      OF          ::oDialog

   ::redefineExplorerBar()

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "&General",;
                  "&Precios" ;
      DIALOGS     "ARTICULO_GENERAL",;
                  "ARTICULO_PRECIO"   

   // ::oFolder:bChange    := {| nOption| ::changeFolder( nOption ) } 

   REDEFINE GET   ::oGetCodigo ;
      VAR         ::oController:oModel:hBuffer[ "codigo" ] ;
      ID          100 ;
      PICTURE     "@! NNNNNNNNNNNNNNNNNN" ;
      WHEN        ( ::oController:isAppendOrDuplicateMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oGetNombre ;
      VAR         ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]
      
   ::oGetNombre:bChange := {|| ::changeNombre() }

   // Familias de articulos ---------------------------------------------------

   ::oController:getArticulosFamiliasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "familia_codigo" ] ) )
   ::oController:getArticulosFamiliasController():getSelector():Build( { "idGet" => 120, "idText" => 121, "idLink" => 122, "oDialog" => ::oFolder:aDialogs[1] } )

   // Tipos de articulos ------------------------------------------------------

   ::oController:getArticulosTipoController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "tipo_codigo" ] ) )
   ::oController:getArticulosTipoController():getSelector():Build( { "idGet" => 130, "idText" => 131, "idLink" => 132, "oDialog" => ::oFolder:aDialogs[1] } )

   // Categorias de articulos--------------------------------------------------

   ::oController:getArticulosCategoriasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "categoria_codigo" ] ) )
   ::oController:getArticulosCategoriasController():getSelector():Build( { "idGet" => 140, "idText" => 141, "idLink" => 142, "oDialog" => ::oFolder:aDialogs[1] } )
   
   // Fabricantes de articulos--------------------------------------------------

   ::oController:getArticulosFabricantesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "fabricante_codigo" ] ) )
   ::oController:getArticulosFabricantesController():getSelector():Build( { "idGet" => 150, "idText" => 151, "idLink" => 152, "oDialog" => ::oFolder:aDialogs[1] } )

   // Tipo de IVA--------------------------------------------------------------

   ::oController:getTipoIvaController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "tipo_iva_codigo" ] ) )
   ::oController:getTipoIvaController():getSelector():Build( { "idGet" => 160, "idText" => 161, "idLink" => 162, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getTipoIvaController():getSelector():bValid  := {|| ::oController:validateTipoIVA() }

   // Impuestos especiales-----------------------------------------------------

   ::oController:getImpuestosEspecialesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "impuesto_especial_codigo" ] ) )
   ::oController:getImpuestosEspecialesController():getSelector():Build( { "idGet" => 170, "idText" => 171, "idLink" => 172, "oDialog" => ::oFolder:aDialogs[1] } )

   // Unidades de medicion grupo-----------------------------------------------

   with object ( ::oController:getUnidadesMedicionGruposController():getSelector() )
      :Bind( bSETGET( ::oController:oModel:hBuffer[ "unidades_medicion_grupos_codigo" ] ) )
      :Build( { "idGet" => 230, "idText" => 231, "idLink" => 232, "oDialog" => ::oFolder:aDialogs[1] } )
      :setWhen( {|| ::oController:isNotZoomMode() .and. SQLUnidadesMedicionOperacionesModel():getNumeroOperacionesWhereArticulo( ::oController:getModelBuffer( "codigo" ) ) == 0 } )
   end with

   // Temporadas---------------------------------------------------------------

   ::oController:getArticulosTemporadasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "temporada_codigo" ] ) )
   ::oController:getArticulosTemporadasController():getSelector():Build( { "idGet" => 250, "idText" => 251, "idLink" => 252, "oDialog" => ::oFolder:aDialogs[1] } )

   // Marcadores---------------------------------------------------------------

   ::oController:getTagsController():getDialogView():ExternalRedefine( { "idGet" => 180, "idButton" => 181, "idTags" => 183 }, ::oFolder:aDialogs[ 1 ] )

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

   // lote---------------------------------------------------------------------

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
      ON UP       ( ::oGetPrecioCosto:ScrollNumber( 1 ), ::oController:validatePrecioCosto() ) ;
      ON DOWN     ( ::oGetPrecioCosto:ScrollNumber( -1 ), ::oController:validatePrecioCosto() ) ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validatePrecioCosto() ) ;
      OF          ::oFolder:aDialogs[2]

   // Browse de precios -------------------------------------------------------

   ::oController:getArticulosPreciosController():Activate( 130, ::oFolder:aDialogs[2] )

   // Botones generales--------------------------------------------------------

   ::oBtnAceptar        := ApoloBtnFlat():Redefine( IDOK, {|| ::closeActivate( ::oFolder:aDialogs ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ::oBtnCancelar       := ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::closeActivate( ::oFolder:aDialogs ), ) }

   ::oDialog:bStart     := {|| ::startActivate(), ::paintedActivate() }

   ::oDialog:Activate( , , , .t. )

   ::oController:getArticulosPreciosController():saveState()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS ArticulosView

   SendMessage( ::oComboPeriodoCaducidad:hWnd, 0x0153, -1, 14 )

   ::addLinksToExplorerBar()

   ::oController:getArticulosFamiliasController():getSelector():Start()

   ::oController:getArticulosTipoController():getSelector():Start()

   ::oController:getArticulosCategoriasController():getSelector():Start()

   ::oController:getArticulosFabricantesController():getSelector():Start()

   ::oController:getTipoIvaController():getSelector():Start()

   ::oController:getImpuestosEspecialesController():getSelector():Start()

   ::oController:getUnidadesMedicionGruposController():GetSelector():Start()
   
   ::oController:getArticulosTemporadasController():getSelector():Start()

   ::oController:getTagsController():getDialogView():Start()

   ::oController:getCombinacionesController():getSelector():Start()

   ::changeNombre()

   ::changeLote()

   ::oGetCodigo:SetFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ArticulosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if

   oPanel:AddLink(   "Combinaciones...",;
                     {||   ::oController:getCombinacionesController():runViewGenerate() },;
                     ::oController:getCombinacionesController():getImage( "16" ) )

   oPanel:AddLink(   "Codificación de proveedores...",;
                     {||   msgInfo( "to-do" ) },;
                     ::oController:getArticulosUnidadesMedicionController():getImage( "16" ) )
 
   oPanel:AddLink(   "Imagenes...",;
                     {||   ::oController:getImagenesController():activateDialogView() },;
                     ::oController:getImagenesController():getImage( "16" ) )

   oPanel:AddLink(   "Traducciones...",;
                     {||   ::oController:getTraduccionesController():activateDialogView() },;
                           ::oController:getTraduccionesController():getImage( "16" ) )

   oPanel:AddLink(   "Unidad por operación...",;
                     {||   ::editUnidadesMedicionOperaciones() },;
                           ::oController:getUnidadesMedicionOperacionesController():getImage( "16" ) )

   oPanel:AddLink(   "Caracteristicas...",;
                     {||   ::oController:getCaracteristicasValoresArticulosController():Edit( ::oController:getUuid() ) },;
                           ::oController:getCaracteristicasValoresArticulosController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros", nil, 1 ) 

   oPanel:AddLink(   "Campos extra...",;
                     {||   ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                           ::oController:getCamposExtraValoresController():getImage( "16" ) )

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

METHOD editUnidadesMedicionOperaciones() CLASS ArticulosView

   if empty( ::oController:getModelBuffer( 'unidades_medicion_grupos_codigo' ) )
      
      msgstop( "Debe seleccionar un grupo de unidades de medición" )

      RETURN ( nil )

   end if 

RETURN ( ::oController:getUnidadesMedicionOperacionesController():activateDialogView() )

//---------------------------------------------------------------------------//
