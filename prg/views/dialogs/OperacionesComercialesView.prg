#include "FiveWin.Ch"
#include "Factu.ch"

//---------------------------------------------------------------------------//

CLASS OperacionesComercialesView FROM OperacionesView

   DATA oPanel

   DATA oGetNumero

   DATA oBtnOk

   DATA oBtnPlus

   DATA oBtnDescuentosDeleted

   DATA oBtnLineasDeleted

   DATA oTotalBruto
   DATA nTotalBruto                    INIT 0
   DATA oTotalIva
   DATA nTotalIva                      INIT 0
   DATA oTotalRecargo
   DATA nTotalRecargo                  INIT 0
   DATA oTotalDescuento
   DATA nTotalDescuento                INIT 0
   DATA oTotalBase
   DATA nTotalBase                     INIT 0
   DATA oTotalImporte
   DATA nTotalImporte                  INIT 0
   DATA oRecargoEquivalencia

   METHOD Activate()
      METHOD startActivate()
      METHOD validActivate()

   METHOD addLinksToExplorerBar()

   METHOD lineAppend()

   METHOD setLinesShowDeleted()        INLINE ( ::getController():getLinesController():setShowDeleted(),;
                                                ::oBtnLineasDeleted:Toggle(),;
                                                ::oBtnLineasDeleted:cTooltip := if( ::oBtnLineasDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) )

   METHOD setDiscountShowDeleted()     INLINE ( ::getController():getDiscountController():setShowDeleted(),;
                                                ::oBtnDescuentosDeleted:Toggle(),;
                                                ::oBtnDescuentosDeleted:cTooltip := if( ::oBtnDescuentosDeleted:lPressed, "Ocultar borrados", "Mostrar borrados" ) )

   METHOD defaultTitle()

   METHOD popupActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activate() CLASS OperacionesComercialesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSACION_COMERCIAL" ;
      TITLE       ::LblTitle() + lower( ::getController():cTitle )

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::getController():getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      ::oController:cTitle();
      ID          800 ;
      FONT        oFontBold() ;
      OF          ::oDialog

   REDEFINE FOLDER ::oFolder ;
      ID          500 ;
      OF          ::oDialog ;
      PROMPT      "General" ,;
                  "Comercial" ;
      DIALOGS     "TRANSACION_GENERAL" ,;
                  "CLIENTE_COMERCIAL"

   ::redefineExplorerBar()

   // Terceros------------------------------------------------------------------

   ::getController():getTercerosController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "tercero_codigo" ] ) )
   ::getController():getTercerosController():getSelector():Build( { "idGet" => 170, "idLink" => 171, "idText" => 180, "idNif" => 181, "idDireccion" => 183, "idCodigoPostal" => 184, "idPoblacion" => 185, "idProvincia" => 186, "idTelefono" => 187, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getTercerosController():getSelector():setWhen( {|| ::getController():hasNotLines() .or. empty( ::getController():getModel():hBuffer[ "tercero_codigo" ] ) } )
   ::getController():getTercerosController():getSelector():setValid( {|| ::getController():validate( "tercero_codigo" ) } )

   // Serie-------------------------------------------------------------------

   ::getController():getContadoresController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "serie" ] ) )
   ::getController():getContadoresController():getSelector():Build( { "idGet" => 100, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getContadoresController():getSelector():setWhen( {|| ::getController():isAppendOrDuplicateMode() } )
   ::getController():getContadoresController():getSelector():setEvent( 'loaded', {|oSelector| ::oGetNumero:cText( oSelector:uFields ) } )

   //::getController():getSerieDocumentoComponent():BindValue( bSETGET( ::getController():getModel():hBuffer[ "serie" ] ) )
   //::getController():getSerieDocumentoComponent():Activate( 100, ::oFolder:aDialogs[1] )

   // Numero-------------------------------------------------------------------

   //::getController():getNumeroDocumentoComponent():BindValue( bSETGET( ::getController():getModel():hBuffer[ "numero" ] ) )
   //::getController():getNumeroDocumentoComponent():Activate( 110, ::oFolder:aDialogs[1] )

   // Fecha--------------------------------------------------------------------

   REDEFINE GET   ::oGetNumero ;
      VAR         ::getController():getModel():hBuffer[ "numero" ] ;
      ID          110 ;
      WHEN        ( .f. ) ;
      OF          ::oFolder:aDialogs[1]

   // Fecha--------------------------------------------------------------------

   REDEFINE GET   ::getController():getModel():hBuffer[ "fecha" ] ;
      ID          130 ;
      PICTURE     "@D" ;
      SPINNER ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Stock--------------------------------------------------------------------

   REDEFINE GET   ::getController():getModel():hBuffer[ "fecha_valor_stock" ] ;
      ID          140 ;
      PICTURE     "@DT" ;
      SPINNER ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Formas de pago------------------------------------------------------------

   ::getController():getMetodosPagosController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "metodo_pago_codigo" ] ) )
   ::getController():getMetodosPagosController():getSelector():Build( { "idGet" => 230, "idText" => 231, "idLink" => 232, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getMetodosPagosController():getSelector():setValid( {|| ::getController():validate( "metodo_pago_codigo" ) } )

   // Almacenes----------------------------------------------------------------

   ::getController():getAlmacenesController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "almacen_codigo" ] ) )
   ::getController():getAlmacenesController():getSelector():Build( { "idGet" => 240, "idText" => 241, "idLink" => 242, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getAlmacenesController():getSelector():setValid( {|| ::getController():validate( "almacen_codigo" ) } )

   // Tarifas------------------------------------------------------------------

   ::getController():getArticulosTarifasController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "tarifa_codigo" ] ) )
   ::getController():getArticulosTarifasController():getSelector():Build( { "idGet" => 250, "idText" => 251, "idLink" => 252, "oDialog" => ::oFolder:aDialogs[1] } )
   ::getController():getArticulosTarifasController():getSelector():setWhen( {|| ::getController():hasNotLines() } )
   ::getController():getArticulosTarifasController():getSelector():setValid( {|| ::getController():validate( "tarifa_codigo" ) } )

   // Rutas--------------------------------------------------------------------

   ::getController():getRutasController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "ruta_codigo" ] ) )
   ::getController():getRutasController():getSelector():Build( { "idGet" => 260, "idText" => 261, "idLink" => 262, "oDialog" => ::oFolder:aDialogs[1] } )

   // Agentes------------------------------------------------------------------

   ::getController():getAgentesController():getSelector():Bind( bSETGET( ::getController():getModel():hBuffer[ "agente_codigo" ] ) )
   ::getController():getAgentesController():getSelector():Build( { "idGet" => 270, "idText" => 271, "idLink" => 272, "oDialog" => ::oFolder:aDialogs[1] } )

   // Totales------------------------------------------------------------------

   REDEFINE SAY   ::oTotalBruto ;
      VAR         ::nTotalBruto ;
      ID          280 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAY   ::oTotalDescuento ;
      VAR         ::nTotalDescuento ;
      ID          290 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAY   ::oTotalBase ;
      VAR         ::nTotalBase ;
      ID          300 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAY   ::oTotalIva ;
      VAR         ::nTotalIva ;
      ID          310 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAYCHECKBOX ::oRecargoEquivalencia ;
      VAR         ::getController():getModel():hBuffer[ "recargo_equivalencia" ] ;
      ID          320 ;
      IDSAY       322 ;
      WHEN        ( ::getController():isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oRecargoEquivalencia:bChange   := {|| ::getController():changeRecargo() }

   REDEFINE SAY   ::oTotalRecargo ;
      VAR         ::nTotalRecargo ;
      ID          323 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAY   ::oTotalImporte ;
      VAR         ::nTotalImporte ;
      ID          330 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   // Lineas ------------------------------------------------------------------

   TBtnBmp():ReDefine( 501, "new16", , , , , {|| ::lineAppend() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Añadir línea" )

   TBtnBmp():ReDefine( 502, "del16",,,,, {|| ::getController():getLinesController():Delete() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 503, "refresh16",,,,, {|| ::getController():getLinesController():refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )

   ::oBtnLineasDeleted := TBtnBmp():ReDefine( 504, "gc_deleted_16",,,,, {|| ::setLinesShowDeleted()  }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar/Ocultar borrados" )

   TBtnBmp():ReDefine( 505, "gc_object_cube_16",,,,, {|| ::getController():getLinesController():Edit()  }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar ficha de artículo" )

   ::getController():getLinesController():Activate( 500, ::oFolder:aDialogs[1] )

   // Descuentos---------------------------------------------------------------

   TBtnBmp():ReDefine( 601, "new16",,,,, {|| ::getController():getDiscountController():AppendLineal() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Añadir línea" )

   TBtnBmp():ReDefine( 602, "del16",,,,, {|| ::getController():getDiscountController():Delete() }, ::oFolder:aDialogs[1], .f., {|| ::getController():isNotZoomMode() }, .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 603, "refresh16",,,,, {|| ::getController():getDiscountController():refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )

   ::oBtnDescuentosDeleted := TBtnBmp():ReDefine( 604, "gc_deleted_16",,,,, {|| ::setDiscountShowDeleted() }, ::oFolder:aDialogs[1], .f., , .f., "Mostrar/Ocultar borrados" )

   ::getController():getDiscountController():Activate( 600, ::oFolder:aDialogs[1] )

   // Botones generales--------------------------------------------------------

   ::oBtnOk    := ApoloBtnFlat():Redefine( IDOK, {|| ::validActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ::oBtnPlus  := ApoloBtnFlat():Redefine( IDOKANDNEW, {|| ::popupActivate() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::getController():isNotZoomMode()

      ::oDialog:bKeyDown   := <| nKey |
         do case
            case nKey == VK_F5
               ::validActivate()
            case nKey == VK_F2
               ::getController():getLinesController():AppendLineal()
            case nKey == VK_F4
               ::getController():getLinesController():Delete()
         end
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart := {|| ::startActivate(), ::paintedActivate() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startActivate() CLASS OperacionesComercialesView

   ::addLinksToExplorerBar()

   ::addLinksElementToExplorerBar()

   ::getController():getTercerosController():getSelector():Start()

   ::getController():getMetodosPagosController():getSelector():Start()

   ::getController():getRutasController():getSelector():Start()

   ::getController():getAgentesController():getSelector():Start()

   ::getController():getContadoresController():getSelector():Start()

   ::getController():getArticulosTarifasController():getSelector():Start()

   ::getController():getAlmacenesController():getSelector():Start()

   ::getController():getLinesController():getBrowseView():Refresh()

   ::getController():getDiscountController():getBrowseView():Refresh()

   ::getController():calculateTotals()

   ::getController():getTercerosController():getSelector():setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD validActivate() CLASS OperacionesComercialesView

   if notValidateDialog( ::oFolder:aDialogs )
      RETURN ( nil )
   end if

   if ::getController():notValidate( "formulario" )
      RETURN ( nil )
   end if

   if !::getController():getLinesController():validLine()
      RETURN ( nil )
   end if

RETURN ( ::oDialog:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS OperacionesComercialesView

   ::oPanel          := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 )

   ::oPanel:AddLink( "Incidencias...",;
                     {||   ::getController():getIncidenciasController():activateDialogView() },;
                           ::getController():getIncidenciasController():getImage( "16" ) )

   ::oPanel:AddLink( "Tipo de direcciones...",;
                     {||   ::getController():getDireccionTipoDocumentoController():Edit() },;
                           ::getController():getDireccionTipoDocumentoController():getImage( "16" ) )

   if ::getController():isNotZoomMode()

   ::oPanel:AddLink( "Campos extra...",;
                     {||   ::getController():getCamposExtraValoresController():Edit( ::getController():getUuid() ) },;
                           ::getController():getCamposExtraValoresController():getImage( "16" ) )
   end if

   ::oPanel:AddLink( "Detalle IVA...",;
                     {||   ::getController():getIvaDetalleView():Show()  },;
                           ::getController():getTipoIvaController():getImage( "16" ) )

   ::oPanel:AddLink( "Historial...",;
                     {||   ::getController():getHistoryController():getDialogView():activate() },;
                           ::getController():getHistoryController():getImage( "16" ) )   

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD lineAppend() CLASS OperacionesComercialesView

   if !::getController():getLinesController():validLine()
      RETURN ( nil )
   end if

RETURN ( ::getController():getLinesController():AppendLineal() )

//---------------------------------------------------------------------------//

METHOD defaultTitle() CLASS OperacionesComercialesView

   local cTitle  := ::oController:getTitle() + " : "

   if empty( ::oController:oModel )
      RETURN ( cTitle )
   end if

   if empty( ::oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if

   if hhaskey( ::oController:oModel:hBuffer, "serie" )
      cTitle      +=  alltrim( ::oController:oModel:hBuffer[ "serie" ] ) + "/"
   end if

   if hhaskey( ::oController:oModel:hBuffer, "numero" )
      cTitle      += alltrim( toSQLString( ::oController:oModel:hBuffer[ "numero" ] ) )
   end if

RETURN ( cTitle )

//---------------------------------------------------------------------------//

METHOD popupActivate() CLASS OperacionesComercialesView

   local oMenu

   MENU oMenu POPUP

      MENUITEM "Aceptar e imprimir" ;
         ACTION   (  ::oController:setPostAction( {|| ::getController():getImprimirSeriesController():printDocument() } ),;
                     ::validActivate() )

      MENUITEM "Aceptar y generar PDF" ;
         ACTION   (  ::oController:setPostAction( {|| ::getController():getImprimirSeriesController():pdfDocument() } ),;
                     ::validActivate() )

      if ( Auth():canSendMail() )
         MENUITEM "Aceptar y enviar mail" ;
         ACTION   (  ::oController:setPostAction( {|| ::getController():getMailController():dialogViewActivate() } ),;
                     ::validActivate() )
      end if

   ENDMENU

   ACTIVATE POPUP oMenu AT 1, 1 OF ::oBtnPlus

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
