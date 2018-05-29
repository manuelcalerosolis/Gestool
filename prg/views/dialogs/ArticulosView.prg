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

END CLASS

//---------------------------------------------------------------------------//
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
      PROMPT      "Art�culos" ;
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
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "codigo" ) ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE GET   ::oController:oModel:hBuffer[ "nombre" ] ;
      ID          110 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      VALID       ( ::oController:validate( "nombre" ) ) ;
      OF          ::oFolder:aDialogs[1]

   // Familias de articulos ---------------------------------------------------

   ::oController:oArticulosFamiliasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_familia_uuid" ] ) )
   ::oController:oArticulosFamiliasController:oGetSelector:Activate( 120, 121, ::oFolder:aDialogs[ 1 ] )

   // Tipos de articulos ------------------------------------------------------

   ::oController:oArticulosTipoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_tipo_uuid" ] ) )
   ::oController:oArticulosTipoController:oGetSelector:Activate( 130, 131, ::oFolder:aDialogs[ 1 ] )

   // Categorias de articulos--------------------------------------------------

   ::oController:oArticulosCategoriasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_categoria_uuid" ] ) )
   ::oController:oArticulosCategoriasController:oGetSelector:Activate( 140, 141, ::oFolder:aDialogs[ 1 ] )
   
   // Fabricantes de articulos--------------------------------------------------

   ::oController:oArticulosFabricantesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "articulo_fabricante_uuid" ] ) )
   ::oController:oArticulosFabricantesController:oGetSelector:Activate( 150, 151, ::oFolder:aDialogs[ 1 ] )

   // Tipo de IVA--------------------------------------------------------------

   ::oController:oTipoIvaController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tipo_iva_uuid" ] ) )
   ::oController:oTipoIvaController:oGetSelector:Activate( 160, 161, ::oFolder:aDialogs[ 1 ] )

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
      ITEMS       { "Dia(s)", "Mes(es)", "A�o(s)" };
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
      PROMPT      "Codificaci�n de proveedores..." ;
      FONT        getBoldFont() ; 
      COLOR       rgb( 10, 152, 234 ) ;
      ID          110 ;
      OF          ::oFolder:aDialogs[2]

   ::oSayCodificacionProveedores:lWantClick  := .t.
   ::oSayCodificacionProveedores:OnClick     := {|| msgalert( "Codificaci�n de proveedores..." ) }

   ::oController:oArticulosPreciosController:Activate( 130, ::oFolder:aDialogs[2] )

   // T�ctil ------------------------------------------------------------------



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

METHOD startActivate() CLASS ArticulosView

   SendMessage( ::oComboPeriodoCaducidad:hWnd, 0x0153, -1, 14 )

   ::addLinksToExplorerBar()

   ::oController:oArticulosFamiliasController:oGetSelector:Start()

   ::oController:oArticulosTipoController:oGetSelector:Start()

   ::oController:oArticulosCategoriasController:oGetSelector:Start()

   ::oController:oArticulosFabricantesController:oGetSelector:Start()

   ::oController:oTipoIvaController:oGetSelector:Start()

   ::oController:oImpuestosEspecialesController:oGetSelector:Start()

   ::oController:oPrimeraPropiedadController:oGetSelector:Start()
   
   ::oController:oSegundaPropiedadController:oGetSelector:Start()

   ::oController:oTagsController:oDialogView:Start()

   ::changeLote()

   ::oGetCodigo:SetFocus()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS ArticulosView

   local oPanel            

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( self )
   end if

   oPanel:AddLink(   "Campos extra...",;
                     {|| ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) },;
                     ::oController:oCamposExtraValoresController:getImage( "16" ) )
   
   oPanel:AddLink(   "Unidades de medici�n...",;
                     {|| ::oController:oArticulosUnidadesMedicionController:activateDialogView() },;
                     ::oController:oArticulosUnidadesMedicionController:getImage( "16" ) )

   oPanel:AddLink(   "Imagenes...",;
                     {|| ::oController:oImagenesController:activateDialogView() },;
                     ::oController:oImagenesController:getImage( "16" ) )

   oPanel:AddLink(   "Traducciones...",;
                     {|| ::oController:oTraduccionesController:activateDialogView() },;
                     ::oController:oTraduccionesController:getImage( "16" ) )

RETURN ( self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
