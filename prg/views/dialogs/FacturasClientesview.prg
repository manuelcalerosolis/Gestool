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
   DATA oTotalDescuento
   DATA nTotalDescuento                INIT 0
   DATA oTotalBase
   DATA nTotalBase                     INIT 0
   DATA oTotalImporte
   DATA nTotalImporte                  INIT 0
   
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

   ::oController:oFacturasClientesLineasController:buildRowSet()

   ::oController:oFacturasClientesDescuentosController:buildRowSet()   

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

   ::oController:oClientesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "cliente_codigo" ] ) )
   ::oController:oClientesController:oGetSelector:Build( { "idGet" => 170, "idLink" => 171, "idText" => 180, "idNif" => 181, "idDireccion" => 183, "idCodigoPostal" => 184, "idPoblacion" => 185, "idProvincia" => 186, "idTelefono" => 187, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:oClientesController:oGetSelector:setWhen( {|| ::oController:isNotLines() } )

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

   ::oController:oFormasPagoController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "forma_pago_codigo" ] ) )
   ::oController:oFormasPagoController:oGetSelector:Build( { "idGet" => 240, "idText" => 241, "idLink" => 242, "oDialog" => ::oFolder:aDialogs[1] } )

   // Rutas--------------------------------------------------------------------

   ::oController:oRutasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "ruta_codigo" ] ) )
   ::oController:oRutasController:oGetSelector:Build( { "idGet" => 260, "idText" => 261, "idLink" => 262, "oDialog" => ::oFolder:aDialogs[1] } )

   // Agentes------------------------------------------------------------------

   ::oController:oAgentesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "agente_codigo" ] ) )
   ::oController:oAgentesController:oGetSelector:Build( { "idGet" => 250, "idText" => 251, "idLink" => 254, "oDialog" => ::oFolder:aDialogs[1] } )

   // Almacenes----------------------------------------------------------------

   ::oController:oAlmacenesController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "almacen_codigo" ] ) )
   ::oController:oAlmacenesController:oGetSelector:Build( { "idGet" => 230, "idText" => 231, "idLink" => 232, "oDialog" => ::oFolder:aDialogs[1] } )

   // Tarifas------------------------------------------------------------------

   ::oController:oArticulosTarifasController:oGetSelector:Bind( bSETGET( ::oController:oModel:hBuffer[ "tarifa_codigo" ] ) )
   ::oController:oArticulosTarifasController:oGetSelector:Build( { "idGet" => 270, "idText" => 271, "idLink" => 272, "oDialog" => ::oFolder:aDialogs[1] } )
   ::oController:oArticulosTarifasController:oGetSelector:setWhen( {|| ::oController:isNotLines() } )

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

   REDEFINE SAYCHECKBOX ::oController:oModel:hBuffer[ "recargo" ] ;
      ID          320 ;
      IDSAY       322 ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      OF          ::oFolder:aDialogs[1]

   REDEFINE SAY   ::oTotalImporte ;
      VAR         ::nTotalImporte ;
      ID          330 ;
      FONT        oFontBold() ;
      PICTURE     "@E 999,999,999.99" ;
      OF          ::oFolder:aDialogs[1]

   // Lineas ------------------------------------------------------------------

   TBtnBmp():ReDefine( 501, "new16",,,,, {|| ::oController:oFacturasClientesLineasController:AppendLineal() }, ::oFolder:aDialogs[1], .f., , .f., "Añadir línea" )

   TBtnBmp():ReDefine( 502, "edit16",,,,, {|| ::oController:oFacturasClientesLineasController:Edit() }, ::oFolder:aDialogs[1], .f., , .f., "Modificar línea" )

   TBtnBmp():ReDefine( 503, "del16",,,,, {|| ::oController:oFacturasClientesLineasController:Delete() }, ::oFolder:aDialogs[1], .f., , .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 504, "refresh16",,,,, {|| ::oController:oFacturasClientesLineasController:refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )

   ::oController:oFacturasClientesLineasController:Activate( 500, ::oFolder:aDialogs[1] )

   // Descuentos---------------------------------------------------------------

   TBtnBmp():ReDefine( 601, "new16",,,,, {|| ::oController:oFacturasClientesDescuentosController:AppendLineal() }, ::oFolder:aDialogs[1], .f., , .f., "Añadir línea" )

   TBtnBmp():ReDefine( 602, "edit16",,,,, {|| MsgInfo( "Editar Descuentos" ) }, ::oFolder:aDialogs[1], .f., , .f., "Modificar línea" )

   TBtnBmp():ReDefine( 603, "del16",,,,, {|| ::oController:oFacturasClientesDescuentosController:Delete() }, ::oFolder:aDialogs[1], .f., , .f., "Eliminar líneas" )

   TBtnBmp():ReDefine( 604, "refresh16",,,,, {|| ::oController:oFacturasClientesDescuentosController:refreshRowSet() }, ::oFolder:aDialogs[1], .f., , .f., "Recargar líneas" )

   ::oController:oFacturasClientesDescuentosController:Activate( 600, ::oFolder:aDialogs[1] )   

   // Botones generales--------------------------------------------------------

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          ::oDialog ;
      WHEN        ( ::oController:isNotZoomMode() ) ;
      ACTION      ( if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDialog ;
      CANCEL ;
      ACTION      ( ::oDialog:end() )

   if ::oController:isNotZoomMode() 
      ::oDialog:AddFastKey( VK_F5, {|| if( validateDialog( ::oFolder:aDialogs ), ::oDialog:end( IDOK ), ) } )
      ::oDialog:AddFastKey( VK_F2, {|| ::oController:oFacturasClientesLineasController:Append() } )
      ::oDialog:AddFastKey( VK_F3, {|| ::oController:oFacturasClientesLineasController:Edit() } )
      ::oDialog:AddFastKey( VK_F4, {|| ::oController:oFacturasClientesLineasController:Delete() } )
   end if

   ::oDialog:bStart := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::oBitmap:end()

RETURN ( ::oDialog:nResult )

//---------------------------------------------------------------------------//

METHOD startDialog() CLASS FacturasClientesView

   ::addLinksToExplorerBar()

   ::oController:oClientesController:oGetSelector:Start()

   ::oController:oFormasPagoController:oGetSelector:Start()

   ::oController:oRutasController:oGetSelector:Start()

   ::oController:oAgentesController:oGetSelector:Start()

   ::oController:oFacturasClientesLineasController:oBrowseView:Refresh()
   
   ::oController:oFacturasClientesDescuentosController:oBrowseView:Refresh()

   ::oController:oArticulosTarifasController:oGetSelector:start()

   ::oController:oAlmacenesController:oGetSelector:start()

   ::oController:oClientesController:oGetSelector:setFocus()

   ::oController:calculateTotals()
   msgalert( ::oController:oModel:hBuffer['recargo'] )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD addLinksToExplorerBar() CLASS FacturasClientesView

   local oPanel

   oPanel            := ::oExplorerBar:AddPanel( "Datos relacionados", nil, 1 ) 

   if ::oController:isZoomMode()
      RETURN ( nil )
   end if

   oPanel:AddLink(   "Incidencias...",;
                     {|| ::oController:oIncidenciasController:activateDialogView() },;
                         ::oController:oIncidenciasController:getImage( "16" ) )

   oPanel:AddLink(   "Tipo de direcciones...",;
                     {|| ::oController:oDireccionTipoDocumentoController:activateDialogView() },;
                         ::oController:oDireccionTipoDocumentoController:getImage( "16" ) )

   oPanel            := ::oExplorerBar:AddPanel( "Otros datos", nil, 1 ) 

   if ::oController:isNotZoomMode()

      oPanel:AddLink(   "Campos extra...",;
                        {||   ::oController:oCamposExtraValoresController:Edit( ::oController:getUuid() ) },;
                              ::oController:oCamposExtraValoresController:getImage( "16" ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//