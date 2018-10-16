#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS FacturasClientesView FROM SQLBaseView
  
   DATA oExplorerBar

   DATA oGetNumero

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

   METHOD Activating()

   METHOD startDialog()

   METHOD addLinksToExplorerBar()

END CLASS

//---------------------------------------------------------------------------//

METHOD Activating() CLASS FacturasClientesView

   if ::oController:isAppendOrDuplicateMode()
      ::oController:oModel:hBuffer()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS FacturasClientesView

   DEFINE DIALOG  ::oDialog ;
      RESOURCE    "TRANSACION_COMERCIAL" ;
      TITLE       ::LblTitle() + "factura cliente"

   REDEFINE BITMAP ::oBitmap ;
      ID          900 ;
      RESOURCE    ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF          ::oDialog

   REDEFINE SAY   ::oMessage ;
      PROMPT      "Facturas de clientes" ;
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

   // Cliente------------------------------------------------------------------

   ::oController:getClientesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_codigo" ] ) )
   ::oController:getClientesController():getSelector():Build( { "idGet" => 170, "idLink" => 171, "idText" => 180, "idNif" => 181, "idDireccion" => 183, "idCodigoPostal" => 184, "idPoblacion" => 185, "idProvincia" => 186, "idTelefono" => 187, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getClientesController():getSelector():setWhen( {|| ::oController:isNotLines() .or. empty( ::oController:oModel:hBuffer[ "cliente_codigo" ] ) } )
   ::oController:getClientesController():getSelector():setValid( {|| ::oController:validate( "cliente_codigo" ) } )

   // Serie-------------------------------------------------------------------

   ::oController:oSerieDocumentoComponent:BindValue( bSETGET( ::oController:oModel:hBuffer[ "serie" ] ) )
   ::oController:oSerieDocumentoComponent:Activate( 4005, ::oFolder:aDialogs[1] )

   // Numero-------------------------------------------------------------------

   ::oController:oNumeroDocumentoComponent:BindValue( bSETGET( ::oController:oModel:hBuffer[ "numero" ] ) )
   ::oController:oNumeroDocumentoComponent:Activate( 110, ::oFolder:aDialogs[1] )

   // Fecha--------------------------------------------------------------------

   REDEFINE GET   ::oController:oModel:hBuffer[ "fecha" ] ;
      ID          130 ;
      PICTURE     "@D" ;
      SPINNER ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   // Formas de pago------------------------------------------------------------

   ::oController:getFormasPagosController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "forma_pago_codigo" ] ) )
   ::oController:getFormasPagosController():getSelector():Build( { "idGet" => 230, "idText" => 231, "idLink" => 232, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getFormasPagosController():getSelector():setValid( {|| ::oController:validate( "forma_pago_codigo" ) } )

   // Almacenes----------------------------------------------------------------

   ::oController:getAlmacenesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "almacen_codigo" ] ) )
   ::oController:getAlmacenesController():getSelector():Build( { "idGet" => 240, "idText" => 241, "idLink" => 242, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getAlmacenesController():getSelector():setValid( {|| ::oController:validate( "almacen_codigo" ) } )

   // Tarifas------------------------------------------------------------------

   ::oController:getArticulosTarifasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "tarifa_codigo" ] ) )
   ::oController:getArticulosTarifasController():getSelector():Build( { "idGet" => 250, "idText" => 251, "idLink" => 252, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:getArticulosTarifasController():getSelector():setWhen( {|| ::oController:isNotLines() } )
   ::oController:getArticulosTarifasController():getSelector():setValid( {|| ::oController:validate( "tarifa_codigo" ) } )

    // Rutas--------------------------------------------------------------------

   ::oController:getRutasController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "ruta_codigo" ] ) )
   ::oController:getRutasController():getSelector():Build( { "idGet" => 260, "idText" => 261, "idLink" => 262, "oDialog" => ::oFolder:aDialogs[1] } )

   // Agentes------------------------------------------------------------------

   ::oController:getAgentesController():getSelector():Bind( bSETGET( ::oController:oModel:hBuffer[ "agente_codigo" ] ) )
   ::oController:getAgentesController():getSelector():Build( { "idGet" => 270, "idText" => 271, "idLink" => 272, "oDialog" => ::oFolder:aDialogs[1] } )

   //Totales------------------------------------------------------------------

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
      VAR         ::oController:oModel:hBuffer[ "recargo_equivalencia" ] ;
      ID          320 ;
      IDSAY       322 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   ::oRecargoEquivalencia:bChange   := {|| ::oController:clientChangeRecargo() }

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

   TBtnBmp():ReDefine( 501, "new16",,,,, {|| ::oController:getFacturasClientesLineasController():AppendLineal() }, ::oFolder:aDialogs[1], .f., , .f., "Añadir línea" )

   TBtnBmp():ReDefine( 502, "del16",,,,, {|| ::oController:getFacturasClientesLineasController():Delete() }, ::oFolder:aDialogs[1], .f., , .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 503, "refresh16",,,,, {|| ::oController:getFacturasClientesLineasController():refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )

   ::oController:getFacturasClientesLineasController():Activate( 500, ::oFolder:aDialogs[1] )

   // Descuentos---------------------------------------------------------------

   TBtnBmp():ReDefine( 601, "new16",,,,, {|| ::oController:getFacturasClientesDescuentosController():AppendLineal() }, ::oFolder:aDialogs[1], .f., , .f., "Añadir línea" )

   TBtnBmp():ReDefine( 602, "del16",,,,, {|| ::oController:getFacturasClientesDescuentosController():Delete() }, ::oFolder:aDialogs[1], .f., , .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 603, "refresh16",,,,, {|| ::oController:getFacturasClientesDescuentosController():refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )

   ::oController:getFacturasClientesDescuentosController():Activate( 600, ::oFolder:aDialogs[1] )   

   // Botones generales--------------------------------------------------------

   ApoloBtnFlat():Redefine( IDOK, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_OKBUTTON, .f., .f. )

   ApoloBtnFlat():Redefine( IDCANCEL, {|| ::oDialog:end() }, ::oDialog, , .f., , , , .f., CLR_BLACK, CLR_WHITE, .f., .f. )

   ::oDialog:bKeyDown   := {| nKey | if( nKey == VK_F5, ::oDialog:end( IDOK ), ) }

   if ::oController:isNotZoomMode() 
   
      ::oDialog:bKeyDown   := <| nKey |  
         do case         
            case nKey == VK_F5
               if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), )
            case nKey == VK_F2
               ::oController:getFacturasClientesLineasController():AppendLineal()
            case nKey == VK_F4
               ::oController:getFacturasClientesLineasController():Delete()
         end 
         RETURN ( 0 )
         >

   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

RETURN ( ::oDialog:nResult ) 

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS FacturasClientesView

   ::addLinksToExplorerBar()

   ::oController:getClientesController():getSelector():Start()

   ::oController:getFormasPagosController():getSelector():Start()

   ::oController:getRutasController():getSelector():Start()

   ::oController:getAgentesController():getSelector():Start()

   ::oController:getArticulosTarifasController():getSelector():Start()

   ::oController:getAlmacenesController():getSelector():Start()

   ::oController:getFacturasClientesLineasController():getBrowseView():Refresh()
   
   ::oController:getFacturasClientesDescuentosController():getBrowseView():Refresh()

   ::oController:calculateTotals()

   ::oController:getClientesController():getSelector():setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS FacturasClientesView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if

   oPanel:AddLink(   "Incidencias...",;
                     {|| ::oController:getIncidenciasController():activateDialogView() },;
                         ::oController:getIncidenciasController():getImage( "16" ) )

   oPanel:AddLink(   "Tipo de direcciones...",;
                     {|| ::oController:getDireccionTipoDocumentoController():activateDialogView() },;
                         ::oController:getDireccionTipoDocumentoController():getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()

      oPanel:AddLink(   "Campos extra...",;
                        {||   ::oController:getCamposExtraValoresController():Edit( ::oController:getUuid() ) },;
                              ::oController:getCamposExtraValoresController():getImage( "16" ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//